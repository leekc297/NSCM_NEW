



/***********************************************************************************************/
/** 프로그램 ID   :PR_UI_FP_PLAN_FORM_CODE                                                    **/
/** 프로그램 명   : Procedure PR_UI_FP_PLAN_FORM_CODE                                         **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                               **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021-12-06     JYJ           Auto Generated With Initial Setting                          **/
/** 2025-02-25     leejsthira2   [E20250217-000184]N2.2 W14주차 FP 문의 관련 수정 요청 건     **/
/** 2026-03-03     SYngsn        E20251119-001047  Result(+Exp.) 값 Plan+Result 보여주고 있는 원인 확인 및 조치 **/
/** 2026-06-08     kimcd         [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응.       **/
/**                              Link Instance 조건 추가                                       **/
/***********************************************************************************************/


CREATE PROCEDURE [dbo].[PR_UI_FP_PLAN_FORM_CODE]
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

	DECLARE @v_group_id         NVARCHAR(50) =''
	DECLARE @v_text             NVARCHAR(MAX)=''
	DECLARE @v_dSql             NVARCHAR(MAX)=''
	DECLARE @v_dSql1            NVARCHAR(MAX)=''
	DECLARE @v_dSql2            NVARCHAR(MAX)=''
	DECLARE @v_dSql3            NVARCHAR(MAX)=''
	DECLARE @v_log_message      NVARCHAR(MAX)=''
	DECLARE @v_proc_name        NVARCHAR(100) = 'PR_UI_FP_PLAN_FORM_CODE'
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	INSERT INTO TH_UIS_SQL 
	VALUES
	(	'PR_UI_FP_PLAN_FORM_CODE',@p_code,'====== START =======', @p_user_id, getdate() )

	/****************************************************************************************************************************************/
	/*  Parameter 세팅                                                                                                       */
	/*                                                                                                    */
	/****************************************************************************************************************************************/
	--BEGIN

	SELECT @v_dSql  = '' , @v_dSql1  = '', @v_dSql2  = '', @v_dSql3  = ''
		/****************************************************************************************************************************************/
		/*   PLAN Amend 화면에서 select_measure 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		IF @p_code = 'select_measure'

			BEGIN
				SELECT @v_dSql = ''
				/* Alias setting */																				
                SELECT @v_dSql += ' WITH M_TABLE AS (                                         ' + char(10)
                SELECT @v_dSql += '       SELECT SEGMENT1     AS USER_ID                      ' + char(10)		
                SELECT @v_dSql += '         , SEGMENT2     AS MENU_ID                         ' + char(10)		
                SELECT @v_dSql += '         , SEGMENT3     AS MEA_ID                          ' + char(10)	  	         													
                SELECT @v_dSql += '         , SEGMENT4     AS MEA_NAME                        ' + char(10)											
                SELECT @v_dSql += '         , SEGMENT5     AS MEA_VALUE                       ' + char(10)
                SELECT @v_dSql += '         , ATTRIBUTE1   AS TYPE                            ' + char(10)
                SELECT @v_dSql += '         , ATTRIBUTE2   AS FLAG                            ' + char(10)
                SELECT @v_dSql += '         , ATTRIBUTE3   AS ACTIVE_FLAG                     ' + char(10)
                SELECT @v_dSql += '       FROM   	SCM_SYS_LOOKUP_VALUE A                    ' + char(10)
                SELECT @v_dSql += '       WHERE  	A.LOOKUP_TYPE_CODE = ''UI_AMEND_MEASURE'' ' + char(10)
                SELECT @v_dSql += '       AND     A.SEGMENT2 = '''+ @param1 +'''              ' + char(10)
                SELECT @v_dSql += '       AND 	A.ACTIVE_FLAG = ''Y''                         ' + char(10)
                SELECT @v_dSql += '  )                                                        ' + char(10)
                SELECT @v_dSql += '  SELECT   ISNULL(A.MEA_ID, B.MEA_ID) MEA_ID               ' + char(10)
                SELECT @v_dSql += '    ,ISNULL(A.MEA_NAME, B.MEA_NAME) MEA_NAME               ' + char(10)
                SELECT @v_dSql += '    ,UPPER(ISNULL(B.MEA_VALUE, A.MEA_VALUE)) MEA_VALUE     ' + char(10)
                SELECT @v_dSql += '    ,ISNULL(A.TYPE, B.TYPE) TYPE                           ' + char(10)
                SELECT @v_dSql += '    ,ISNULL(A.FLAG, B.FLAG) FLAG                           ' + char(10)
                SELECT @v_dSql += '    ,A.MENU_ID                                             ' + char(10)
                SELECT @v_dSql += '    ,'''+ @p_user_id +''' AS USER_ID                       ' + char(10)
                SELECT @v_dSql += ' FROM   M_TABLE A WITH(NOLOCK)                             ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                                         ' + char(10)
                SELECT @v_dSql += '     SELECT *                                              ' + char(10)
                SELECT @v_dSql += '     FROM   TH_UIS_USER_AMEND_MEA_RELATE B WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += '     WHERE  USER_ID = '''+ @p_user_id +'''                 ' + char(10)
                SELECT @v_dSql += '     AND    MENU_ID = '''+ @param1 +'''                    ' + char(10)
                SELECT @v_dSql += '     AND    ACTIVE_FLAG = ''Y''                            ' + char(10)
                SELECT @v_dSql += ' ) B                                                       ' + char(10)
                SELECT @v_dSql += ' ON    A.MENU_ID = B.MENU_ID                               ' + char(10)
                SELECT @v_dSql += ' AND   A.MEA_ID  = B.MEA_ID                                ' + char(10)
                SELECT @v_dSql += ' AND   A.TYPE 	= B.TYPE                                  ' + char(10)
                SELECT @v_dSql += ' WHERE 1=1                                                 ' + char(10)
                SELECT @v_dSql += ' AND   A.ACTIVE_FLAG = ''Y''                               ' + char(10)
				
				--print @v_dSql
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@p_code, @v_dSql , @param1, getdate() ) ;
				--SELECT @v_dSql
				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   Amend화면에서 find_WeekCnt 정보갖고오기   (ISO WEEK)                                                                                    */
		/*   Param : @Param1     , Param2                 */
		/*   Param : BUCKET_FROM , BUCKET_TO              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_WeekCnt' 
		    BEGIN	
				SELECT @v_dSql = ''
				IF isnull(@param3,'') = 'SUN' BEGIN
					SELECT @v_dSql = ''
					SELECT @v_dSql  = ' SELECT YYYYWW AS WEEK                                                           ' + char(10)
					SELECT @v_dSql += '   , (SUBSTRING(YYYYWW,1,4) + ''W'' + SUBSTRING(YYYYWW,5,2)) AS WEEK_NAME    ' + char(10)
					SELECT @v_dSql += '   , COUNT(*) AS WEEK_COUNT                                                          ' + char(10)
					SELECT @v_dSql += '   , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYWW))-1) AS W_VALUE  ' + char(10)
					SELECT @v_dSql += '   , ''1'' AS IS_DAY_VIEW                                                            ' + char(10)
					SELECT @v_dSql += ' FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                               ' + char(10)
					SELECT @v_dSql += ' WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @param1 +''', 112)                          ' + char(10)
					SELECT @v_dSql += ' AND    CAL.DT <= CONVERT(DATETIME, '''+ @param2 +''', 112)                          ' + char(10)
					SELECT @v_dSql += ' GROUP BY YYYYWW                                                                 ' + char(10)
					SELECT @v_dSql += ' ORDER BY YYYYWW                                                                 ' + char(10)                                                            
				END ELSE BEGIN
					SELECT @v_dSql  = ' SELECT ISO_YYYYWW AS WEEK                                                           ' + char(10)
					SELECT @v_dSql += '   , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS WEEK_NAME    ' + char(10)
					SELECT @v_dSql += '   , COUNT(*) AS WEEK_COUNT                                                          ' + char(10)
					SELECT @v_dSql += '   , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS W_VALUE  ' + char(10)
					SELECT @v_dSql += '   , ''1'' AS IS_DAY_VIEW                                                            ' + char(10)
					SELECT @v_dSql += ' FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                               ' + char(10)
					SELECT @v_dSql += ' WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @param1 +''', 112)                          ' + char(10)
					SELECT @v_dSql += ' AND    CAL.DT <= CONVERT(DATETIME, '''+ @param2 +''', 112)                          ' + char(10)
					SELECT @v_dSql += ' GROUP BY ISO_YYYYWW                                                                 ' + char(10)
					SELECT @v_dSql += ' ORDER BY ISO_YYYYWW                                                                 ' + char(10)
				END

			    exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   Amend화면에서 find_WeekCnt_Sun 정보갖고오기    (NORMAL WEEK) (NOT USED)                                                                                 */
		/*   Param : @Param1     , Param2                 */
		/*   Param : BUCKET_FROM , BUCKET_TO              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_WeekCnt_Sun' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql  = ' SELECT YYYYWW AS WEEK                                                           ' + char(10)
                SELECT @v_dSql += '   , (SUBSTRING(YYYYWW,1,4) + ''W'' + SUBSTRING(YYYYWW,5,2)) AS WEEK_NAME    ' + char(10)
                SELECT @v_dSql += '   , COUNT(*) AS WEEK_COUNT                                                          ' + char(10)
                SELECT @v_dSql += '   , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYWW))-1) AS W_VALUE  ' + char(10)
                SELECT @v_dSql += '   , ''1'' AS IS_DAY_VIEW                                                            ' + char(10)
                SELECT @v_dSql += ' FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                               ' + char(10)
                SELECT @v_dSql += ' WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @param1 +''', 112)                          ' + char(10)
                SELECT @v_dSql += ' AND    CAL.DT <= CONVERT(DATETIME, '''+ @param2 +''', 112)                          ' + char(10)
                SELECT @v_dSql += ' GROUP BY YYYYWW                                                                 ' + char(10)
                SELECT @v_dSql += ' ORDER BY YYYYWW                                                                 ' + char(10)

			    exec sp_executesql @v_dSql

		   END    

		/****************************************************************************************************************************************/
		/*   Amend화면에서 find_MonthCnt 정보갖고오기                                                                                      */
		/*   Param : @Param1     , Param2                 */
		/*   Param : BUCKET_FROM , BUCKET_TO              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_MonthCnt' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql  = ' SELECT YYYYMM AS MONTH                      ' + char(10)
                SELECT @v_dSql += '    , SUBSTRING(YYYYMM,1,4) + ''-'' +        ' + char(10)
                SELECT @v_dSql += '      (CASE WHEN MONTH = ''01'' THEN ''Jan'' ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''02'' THEN ''Feb''  ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''03'' THEN ''Mar''  ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''04'' THEN ''Apr''  ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''05'' THEN ''May''  ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''06'' THEN ''Jun''  ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''07'' THEN ''Jul''  ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''08'' THEN ''Aug''  ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''09'' THEN ''Sep''  ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''10'' THEN ''Oct''  ' + char(10)
                SELECT @v_dSql += '           WHEN MONTH = ''11'' THEN ''Nov''  ' + char(10)
                SELECT @v_dSql += '           ELSE ''Dec'' END) AS MONTH_NAME   ' + char(10)
                SELECT @v_dSql += '    , COUNT(*) AS MONTH_COUNT                ' + char(10)
                SELECT @v_dSql += '    , ''M'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMM))-1) AS M_VALUE  ' + char(10)
                SELECT @v_dSql += ' FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                      ' + char(10)
                SELECT @v_dSql += ' WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @param1 +''', 112) ' + char(10)
                SELECT @v_dSql += ' AND    CAL.DT <= CONVERT(DATETIME, '''+ @param2 +''', 112) ' + char(10)
                SELECT @v_dSql += ' GROUP BY YYYYMM, MONTH                                     ' + char(10)
                SELECT @v_dSql += ' ORDER BY YYYYMM                                            ' + char(10)

			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Amend화면에서 find_DateMap 정보갖고오기                                                                                      */
		/*   Param : @Param1,   @Param2     , Param3                 */
		/*   Param : PLAN_DATE, BUCKET_FROM , BUCKET_TO              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_DateMap' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql  = ' SELECT (CASE WHEN YYYYMMDD >= '''+ @param1 +''' THEN ''Y'' ELSE ''N'' END) AS IS_PLAN                   ' + char(10)
                SELECT @v_dSql += '    ,''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS D_VALUE                        ' + char(10)
                SELECT @v_dSql += '    ,YYYYMMDD AS _DATE                                                                                   ' + char(10)
				IF ISNULL(@param4,'') = 'SUN' BEGIN
	                SELECT @v_dSql += '    ,YYYYWW AS _WEEK                                                                                 ' + char(10)
				END ELSE BEGIN
		            SELECT @v_dSql += '    ,ISO_YYYYWW AS _WEEK                                                                                 ' + char(10)
				END
				
                SELECT @v_dSql += '    ,MONTH AS _MONTH                                                                                     ' + char(10)
                SELECT @v_dSql += '    ,SUBSTRING(YYYYMMDD,1,4) + ''-'' + SUBSTRING(YYYYMMDD,5,2) + ''-'' + SUBSTRING(YYYYMMDD,7,2) + '' '' ' + char(10)
                SELECT @v_dSql += '    +(CASE WHEN DAY_SEQ=2 THEN ''(Mon.)''                                                                ' + char(10)
                SELECT @v_dSql += '          WHEN DAY_SEQ=3 THEN ''(Tue.)''                                                                 ' + char(10)
                SELECT @v_dSql += '          WHEN DAY_SEQ=4 THEN ''(Wed.)''                                                                 ' + char(10)
                SELECT @v_dSql += '          WHEN DAY_SEQ=5 THEN ''(Thu.)''                                                                 ' + char(10)
                SELECT @v_dSql += '          WHEN DAY_SEQ=6 THEN ''(Fri.)''                                                                 ' + char(10)
                SELECT @v_dSql += '          WHEN DAY_SEQ=7 THEN ''(Sat.)''                                                                 ' + char(10)
                SELECT @v_dSql += '          ELSE ''(SUN.)'' END)  AS _DATE_TXT                                                             ' + char(10)
                SELECT @v_dSql += '   ,DAY_SEQ                                                                                              ' + char(10)
                SELECT @v_dSql += ' FROM   TH_UIS_CAL A WITH(NOLOCK)                                                                        ' + char(10)
                SELECT @v_dSql += ' WHERE  YYYYMMDD BETWEEN '''+ @param2 +''' AND '''+ @param3 +'''                                         ' + char(10)
                SELECT @v_dSql += ' ORDER BY YYYYMMDD                         ' + char(10)

			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Amend화면에서 find_bukInfo 정보갖고오기                                                                                      */
		/*   Param : @Param1     , Param2                 */
		/*   Param : BUCKET_FROM , BUCKET_TO              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_bukInfo' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.*                    ' + char(10)
                SELECT @v_dSql += ' FROM (                        ' + char(10)
                SELECT @v_dSql += '      SELECT YYYYMMDD AS _DATE ' + char(10)
                SELECT @v_dSql += '        ,SUBSTRING(YYYYMMDD,1,4) + ''-'' + SUBSTRING(YYYYMMDD,5,2) + ''-'' + SUBSTRING(YYYYMMDD,7,2) + '' '' ' + char(10)
                SELECT @v_dSql += '        +(CASE WHEN DAY_SEQ=2 THEN ''(Mon)''                                            ' + char(10)
                SELECT @v_dSql += '              WHEN DAY_SEQ=3 THEN ''(Tue)''                                             ' + char(10)
                SELECT @v_dSql += '              WHEN DAY_SEQ=4 THEN ''(Wed)''                                             ' + char(10)
                SELECT @v_dSql += '              WHEN DAY_SEQ=5 THEN ''(Thu)''                                             ' + char(10)
                SELECT @v_dSql += '              WHEN DAY_SEQ=6 THEN ''(Fri)''                                             ' + char(10)
                SELECT @v_dSql += '              WHEN DAY_SEQ=7 THEN ''(Sat)''                                             ' + char(10)
                SELECT @v_dSql += '              ELSE ''(SUN)'' END) AS _NAME                                              ' + char(10)
                SELECT @v_dSql += '        , 1 AS _COUNT                                                                   ' + char(10)
                SELECT @v_dSql += '        ,''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS _VALUE    ' + char(10)
                SELECT @v_dSql += '        , 1 AS _DATE_SEQ                                                                ' + char(10)

				if isnull(@param3,'') = 'SUN' BEGIN
	                SELECT @v_dSql += '                  , YYYYWW AS WEEK_SEQ             ' + char(10)
				END ELSE BEGIN
		            SELECT @v_dSql += '                  , ISO_YYYYWW AS WEEK_SEQ             ' + char(10)
				END
                --SELECT @v_dSql += '        , ISO_YYYYWW AS WEEK_SEQ                                                        ' + char(10)
                SELECT @v_dSql += '        , ''D'' AS _TYPE                                                                ' + char(10)
                SELECT @v_dSql += '     FROM   TH_UIS_CAL A WITH(NOLOCK)                                                   ' + char(10)
                SELECT @v_dSql += '     WHERE  YYYYMMDD BETWEEN '''+ @param1 +''' AND '''+ @param2 +'''                    ' + char(10)
                SELECT @v_dSql += '     UNION ALL                                                                          ' + char(10)
                
				if isnull(@param3,'') = 'SUN' BEGIN
	                SELECT @v_dSql += '     SELECT YYYYWW AS _DATE             ' + char(10)
					SELECT @v_dSql += '        , (SUBSTRING(YYYYWW,1,4) + ''W'' + SUBSTRING(YYYYWW,5,2)) AS _NAME      ' + char(10)
				END ELSE BEGIN
		            SELECT @v_dSql += '     SELECT ISO_YYYYWW AS _DATE             ' + char(10)
					SELECT @v_dSql += '        , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS _NAME      ' + char(10)
				END
				--SELECT @v_dSql += '     SELECT ISO_YYYYWW AS _DATE                                                         ' + char(10)              
				--SELECT @v_dSql += '        , (SUBSTRING(ISO_YYYYWW,1,4) + ''W'' + SUBSTRING(ISO_YYYYWW,5,2)) AS _NAME      ' + char(10)
                SELECT @v_dSql += '        , COUNT(*) AS _COUNT                                                            ' + char(10)

				if isnull(@param3,'') = 'SUN' BEGIN
					SELECT @v_dSql += '        , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYWW))-1) AS _VALUE ' + char(10)
					SELECT @v_dSql += '        , 1 AS _DATE_SEQ                                                                ' + char(10)
					SELECT @v_dSql += '        , YYYYWW AS WEEK_SEQ                                                        ' + char(10)
				END ELSE BEGIN
					SELECT @v_dSql += '        , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS _VALUE ' + char(10)
					SELECT @v_dSql += '        , 1 AS _DATE_SEQ                                                                ' + char(10)
					SELECT @v_dSql += '        , ISO_YYYYWW AS WEEK_SEQ                                                        ' + char(10)
				END
                --SELECT @v_dSql += '        , ''W'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW))-1) AS _VALUE ' + char(10)
                --SELECT @v_dSql += '        , 1 AS _DATE_SEQ                                                                ' + char(10)
                --SELECT @v_dSql += '        , ISO_YYYYWW AS WEEK_SEQ                                                        ' + char(10)

		        SELECT @v_dSql += ' , ''W'' AS _TYPE                                                                ' + char(10)
                SELECT @v_dSql += '     FROM   TH_UIS_CAL AS CAL WITH(NOLOCK)                                              ' + char(10)
                SELECT @v_dSql += '     WHERE  CAL.DT >= CONVERT(DATETIME, '''+ @param1 +''', 112)                         ' + char(10)
                SELECT @v_dSql += '     AND    CAL.DT <= CONVERT(DATETIME, '''+ @param2 +''', 112)                         ' + char(10)
				if isnull(@param3,'') = 'SUN' BEGIN
					SELECT @v_dSql += '     GROUP BY YYYYWW                                                                ' + char(10)
				END ELSE BEGIN
					SELECT @v_dSql += '     GROUP BY ISO_YYYYWW                                                                ' + char(10)
				END
                SELECT @v_dSql += ' ) A                                                                                    ' + char(10)
                SELECT @v_dSql += ' ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = ''W'' THEN 1 ELSE 2 END), _DATE                  ' + char(10)

			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Plan Amend화면에서 findBucketList_common 정보갖고오기                                                                                      */
		/*   Param : @Param1     , Param2         ,@param3                */
		/*   Param : BUKET ,       BUKET_FROM     ,BUKET_TO               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'findBucketList_common' 
		    BEGIN	
			    SELECT @v_dSql  = ''

                IF (@param1 = 'D' OR @param1 = 'W' OR @param1 = 'P' OR @param1 = 'M' )
                    BEGIN
                        SELECT @v_dSql  =  ' SELECT DISTINCT A.COL_NM, A.YEAR, A.HALF, A.QUARTER                    ' + char(10)
						SELECT @v_dSql +=  '    , A.MONTH, A.WEEK, A.TYPE, A.VALUE, A.LABLE, A.DAY                  ' + char(10)
                        SELECT @v_dSql +=  ' FROM (                                                                 ' + char(10)
                        SELECT @v_dSql +=  '      SELECT   CASE ''' + @param1 + '''                                 ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''M'' THEN ''M'' + ISNULL(CAL.YYYYMM, '''')            ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN ''P'' + ISNULL(CAL.ISO_YYYYPW, '''')        ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN ''W'' + ISNULL(CAL.ISO_YYYYWW, '''')        ' + char(10)
                        SELECT @v_dSql +=  '            ELSE ''D'' + ISNULL(CAL.YYYYMMDD, '''')  END AS COL_NM      ' + char(10)
                        SELECT @v_dSql +=  '        , CASE ''' + @param1 + ''' WHEN ''M'' THEN CAL.YEAR             ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN CAL.ISO_YEAR                                ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN CAL.ISO_YEAR                                ' + char(10)
                        SELECT @v_dSql +=  '            ELSE CAL.ISO_YEAR  END AS YEAR                              ' + char(10)
                        SELECT @v_dSql +=  '        , CASE ''' + @param1 + '''  WHEN ''M'' THEN CAL.HALF            ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN CAL.HALF                                    ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN NULL                                        ' + char(10)
                        SELECT @v_dSql +=  '            ELSE CAL.HALF  END AS HALF                                  ' + char(10)
                        SELECT @v_dSql +=  '        , CASE ''' + @param1 + '''  WHEN ''M'' THEN CAL.QUARTER         ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN CAL.QUARTER                                 ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN NULL                                        ' + char(10)
                        SELECT @v_dSql +=  '            ELSE CAL.QUARTER  END AS QUARTER                            ' + char(10)
                        SELECT @v_dSql +=  '        , CASE ''' + @param1 + '''  WHEN ''M'' THEN CAL.YYYYMM          ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN CAL.YYYYMM                                  ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN NULL                                        ' + char(10)
                        SELECT @v_dSql +=  '            ELSE CAL.YYYYMM  END AS MONTH                               ' + char(10)
                        SELECT @v_dSql +=  '        , CASE ''' + @param1 + '''  WHEN ''M'' THEN NULL                ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN CAL.ISO_YYYYWW                              ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN CAL.ISO_YYYYWW                              ' + char(10)
                        SELECT @v_dSql +=  '            ELSE CAL.ISO_YYYYWW  END AS WEEK                            ' + char(10)
                        SELECT @v_dSql +=  '        , ''' + @param1 + ''' AS TYPE                                   ' + char(10)
                        SELECT @v_dSql +=  '        , CASE ''' + @param1 + '''  WHEN ''M'' THEN CAL.YYYYMM          ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN CAL.ISO_YYYYPW                              ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN CAL.ISO_YYYYWW                              ' + char(10)
                        SELECT @v_dSql +=  '            ELSE CAL.YYYYMMDD   END AS VALUE                            ' + char(10)
                        SELECT @v_dSql +=  '        , CASE ''' + @param1 + '''                                      ' + char(10)
						SELECT @v_dSql +=  '            WHEN ''M'' THEN ''M'' + ISNULL(CAL.MONTH, '''')             ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN ''P'' + ISNULL(CAL.ISO_PARTIAL_WEEK, '''')  ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN ''W'' + ISNULL(CAL.ISO_WEEK, '''')          ' + char(10)
                        SELECT @v_dSql +=  '            ELSE ''D'' + ISNULL(CAL.DAY, '''') END AS LABLE             ' + char(10)
                        SELECT @v_dSql +=  '        , CASE WHEN ''' + @param1 + ''' = ''D'' THEN  DAY_SEQ           ' + char(10)
                        SELECT @v_dSql +=  '               ELSE ''-'' END as day                                    ' + char(10)
                        SELECT @v_dSql +=  '      FROM TH_UIS_CAL AS CAL(NOLOCK)                                    ' + char(10)
                        SELECT @v_dSql +=  '      WHERE CAL.DT >= CONVERT(datetime, ''' + @param2 + ''', 112)       ' + char(10)
						SELECT @v_dSql +=  '       AND CAL.DT <= CONVERT(datetime, ''' + @param3 + ''', 112)        ' + char(10)
                        SELECT @v_dSql +=  '   )  AS A                                                              ' + char(10)
                        SELECT @v_dSql +=  ' UNION ALL                                                              ' + char(10)
                        SELECT @v_dSql +=  ' SELECT  ''TOTAL'' AS COL_NM, NULL AS YEAR, NULL AS HALF                ' + char(10)
						SELECT @v_dSql +=  '   , NULL AS QUARTER, NULL AS MONTH, NULL AS WEEK                       ' + char(10)
						SELECT @v_dSql +=  '   , ''T'' AS TYPE, ''TOTAL'' AS VALUE                                  ' + char(10)
						SELECT @v_dSql +=  '   , ''TOTAL'' AS LABLE, ''-''  AS DAY                         ' + char(10)
                SELECT @v_dSql +=  'ORDER BY A.VALUE                                                        ' + char(10)
                    END
                ELSE
                    BEGIN
                        SELECT @v_dSql   = ' SELECT max(AA.YYYYMMDD) AS YYYYMMDD, AA.COL_NM, AA.YEAR, AA.HALF       ' + char(10)
						SELECT @v_dSql +=  '   , AA.QUARTER, AA.MONTH, AA.WEEK, AA.TYPE, AA.VALUE, AA.LABLE         ' + char(10)
                        SELECT @v_dSql +=  '   , CASE AA.TYPE WHEN ''D'' THEN ''1''  WHEN ''W'' THEN ''2''          ' + char(10)
						SELECT @v_dSql +=  '         WHEN ''P'' THEN ''3''  ELSE ''4'' END AS SEQ                   ' + char(10)
                        SELECT @v_dSql +=  ' FROM (                                                                 ' + char(10)
                        SELECT @v_dSql +=  '       SELECT  A.YYYYMMDD,  ''D'' + ISNULL(A.YYYYMMDD, '''') AS COL_NM  ' + char(10)
                        SELECT @v_dSql +=  '          , A.ISO_YEAR AS YEAR,  A.HALF AS HALF, A.QUARTER AS QUARTER   ' + char(10)
                        SELECT @v_dSql +=  '          , A.YYYYMM AS MONTH,   A.ISO_YYYYWW AS WEEK, ''D'' AS TYPE    ' + char(10)
                        SELECT @v_dSql +=  '          , A.YYYYMMDD AS VALUE,   ''D'' + ISNULL(A.DAY, '''') AS LABLE ' + char(10)
                        SELECT @v_dSql +=  '       FROM TH_UIS_CAL AS A(NOLOCK)                                     ' + char(10)
                        SELECT @v_dSql +=  '       WHERE A.DT >= CONVERT(datetime, ''' + @param2 + ''', 112)        ' + char(10)
						SELECT @v_dSql +=  '          AND A.DT <= CONVERT(datetime, ''' + @param3 + ''', 112)       ' + char(10)
                        SELECT @v_dSql +=  '   )  AS AA                                                             ' + char(10)
                        SELECT @v_dSql +=  ' GROUP BY AA.COL_NM, AA.YEAR, AA.HALF, AA.QUARTER, AA.MONTH             ' + char(10)
						SELECT @v_dSql +=  '        , AA.WEEK, AA.TYPE, AA.VALUE, AA.LABLE                          ' + char(10)
                        SELECT @v_dSql +=  ' UNION ALL                                                              ' + char(10)
                        SELECT @v_dSql +=  ' SELECT  max(BB.YYYYMMDD) AS YYYYMMDD, BB.COL_NM, BB.YEAR, BB.HALF      ' + char(10)
						SELECT @v_dSql +=  '     , BB.QUARTER, BB.MONTH, BB.WEEK, BB.TYPE, BB.VALUE, BB.LABLE       ' + char(10)
                        SELECT @v_dSql +=  '     , CASE BB.TYPE WHEN ''D'' THEN ''1'' WHEN ''W'' THEN ''2''         ' + char(10)
						SELECT @v_dSql +=  '            WHEN ''P'' THEN ''3'' ELSE ''4'' END AS SEQ                 ' + char(10)
                        SELECT @v_dSql +=  ' FROM (                                                                 ' + char(10)
                        SELECT @v_dSql +=  '      SELECT   A.YYYYMMDD                                               ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''W''  WHEN ''M'' THEN ''M'' + ISNULL(A.YYYYMM, '''')   ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN ''P'' + ISNULL(A.ISO_YYYYPW, '')            ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN ''W'' + ISNULL(A.ISO_YYYYWW, '')            ' + char(10)
                        SELECT @v_dSql +=  '            ELSE ''D'' + ISNULL(A.YYYYMMDD, '')   END AS COL_NM         ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''W''   WHEN ''M'' THEN A.YEAR                          ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.ISO_YEAR                                  ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN A.ISO_YEAR                                  ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.ISO_YEAR    END AS YEAR                     ' + char(10)
   SELECT @v_dSql +=  '         , CASE ''W''  WHEN ''M'' THEN A.HALF                           ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.HALF                                      ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN NULL                                        ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.HALF    END AS HALF                                  ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''W''  WHEN ''M'' THEN A.QUARTER                        ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.QUARTER                                   ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN NULL                                        ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.QUARTER  END AS QUARTER                              ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''W''  WHEN ''M'' THEN A.YYYYMM                         ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.YYYYMM                                    ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN NULL                                        ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.YYYYMM   END AS MONTH                                ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''W''   WHEN ''M'' THEN NULL                            ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.ISO_YYYYWW                                ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN A.ISO_YYYYWW                                ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.ISO_YYYYWW   END AS WEEK                             ' + char(10)
                        SELECT @v_dSql +=  '         , ''W'' AS TYPE                                                ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''W''  WHEN ''M'' THEN A.YYYYMM                         ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.ISO_YYYYPW                                ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN A.ISO_YYYYWW                                ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.YYYYMMDD   END AS VALUE                              ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''W''   WHEN ''M'' THEN ''M'' + ISNULL(A.MONTH, '''')   ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN ''P'' + ISNULL(A.ISO_PARTIAL_WEEK, '''')    ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN ''W'' + ISNULL(A.ISO_WEEK, '''')            ' + char(10)
                        SELECT @v_dSql +=  '            ELSE ''D'' + ISNULL(A.DAY, '''')  END AS LABLE              ' + char(10)
                        SELECT @v_dSql +=  '      FROM TH_UIS_CAL AS A(NOLOCK)                                      ' + char(10)
                        SELECT @v_dSql +=  '      WHERE A.DT >= CONVERT(datetime, ''' + @param2 + ''', 112)         ' + char(10)
						SELECT @v_dSql +=  '        AND A.DT <= CONVERT(datetime, ''' + @param3 + ''', 112)         ' + char(10)
                        SELECT @v_dSql +=  '   )  AS BB                                                             ' + char(10)
                        SELECT @v_dSql +=  ' GROUP BY BB.COL_NM, BB.YEAR, BB.HALF, BB.QUARTER, BB.MONTH             ' + char(10)
						SELECT @v_dSql +=  '        , BB.WEEK, BB.TYPE, BB.VALUE, BB.LABLE               ' + char(10)
                        SELECT @v_dSql +=  ' UNION ALL                                                              ' + char(10)
                        SELECT @v_dSql +=  ' SELECT  max(CC.YYYYMMDD) AS YYYYMMDD, CC.COL_NM, CC.YEAR, CC.HALF      ' + char(10)
						SELECT @v_dSql +=  '   , CC.QUARTER, CC.MONTH, CC.WEEK, CC.TYPE, CC.VALUE, CC.LABLE         ' + char(10)
                        SELECT @v_dSql +=  '   , CASE CC.TYPE WHEN ''D'' THEN ''1'' WHEN ''W'' THEN ''2''           ' + char(10)
						SELECT @v_dSql +=  '                  WHEN ''P'' THEN ''3'' ELSE ''4'' END AS SEQ           ' + char(10)
                        SELECT @v_dSql +=  'FROM (                                                                  ' + char(10)
                        SELECT @v_dSql +=  '      SELECT  A.YYYYMMDD                                                ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''M''  WHEN ''M'' THEN ''M'' + ISNULL(A.YYYYMM, '''')   ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN ''P'' + ISNULL(A.ISO_YYYYPW, '''')          ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN ''W'' + ISNULL(A.ISO_YYYYWW, '''')          ' + char(10)
                        SELECT @v_dSql +=  '            ELSE ''D'' + ISNULL(A.YYYYMMDD, '')  END AS COL_NM          ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''M''  WHEN ''M'' THEN A.YEAR                           ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.ISO_YEAR                                  ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN A.ISO_YEAR                                  ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.ISO_YEAR   END AS YEAR                               ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''M''   WHEN ''M'' THEN A.HALF                          ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.HALF                                      ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN NULL                                        ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.HALF  END AS HALF                                    ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''M''   WHEN ''M'' THEN A.QUARTER                       ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.QUARTER                                   ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN NULL                                        ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.QUARTER  END AS QUARTER                              ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''M''                                                   ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''M'' THEN A.YYYYMM                                    ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.YYYYMM                                    ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN NULL                                        ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.YYYYMM   END AS MONTH                                ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''M''  WHEN ''M'' THEN NULL                             ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.ISO_YYYYWW                                ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN A.ISO_YYYYWW         ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.ISO_YYYYWW END AS WEEK                               ' + char(10)
                        SELECT @v_dSql +=  '         , ''M'' AS TYPE                                                ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''M''  WHEN ''M'' THEN A.YYYYMM                         ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN A.ISO_YYYYPW                                ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN A.ISO_YYYYWW                                ' + char(10)
                        SELECT @v_dSql +=  '            ELSE A.YYYYMMDD  END AS VALUE                               ' + char(10)
                        SELECT @v_dSql +=  '         , CASE ''M''  WHEN ''M'' THEN ''M'' + ISNULL(A.MONTH, '''')    ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''P'' THEN ''P'' + ISNULL(A.ISO_PARTIAL_WEEK, '''')    ' + char(10)
                        SELECT @v_dSql +=  '            WHEN ''W'' THEN ''W'' + ISNULL(A.ISO_WEEK, '''')            ' + char(10)
                        SELECT @v_dSql +=  '            ELSE ''D'' + ISNULL(A.DAY, '''')  END AS LABLE              ' + char(10)
                        SELECT @v_dSql +=  '      FROM TH_UIS_CAL AS A(NOLOCK)                                      ' + char(10)
                        SELECT @v_dSql +=  '      WHERE A.DT >= CONVERT(datetime, ''' + @param2 + ''', 112)         ' + char(10)
						SELECT @v_dSql +=  '       AND A.DT <= CONVERT(datetime, ''' + @param3 + ''', 112)          ' + char(10)
                        SELECT @v_dSql +=  '   )  AS CC                                                             ' + char(10)
                        SELECT @v_dSql +=  ' GROUP BY CC.COL_NM, CC.YEAR, CC.HALF, CC.QUARTER, CC.MONTH             ' + char(10)
						SELECT @v_dSql +=  '        , CC.WEEK, CC.TYPE, CC.VALUE, CC.LABLE                          ' + char(10)
                        SELECT @v_dSql +=  'ORDER BY YYYYMMDD, SEQ                                                  ' + char(10)
                    END
  
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Plan Amend화면에서 find_save_seq 정보갖고오기                                                                                      */
		/*   Param : @Param1     , Param2    ,@param3    , @param4            */
		/*   Param :                                                          */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_save_seq' 
		    BEGIN	
			    SELECT @v_dSql  = ''
                SELECT @v_dSql += ' SELECT NEXT VALUE FOR [SEQ_AMEND_SAVE] AS NEW_SEQ  ' + char(10)

			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Plan Amend화면에서 find_save_chk 정보갖고오기                                                                                      */
		/*   Param : @Param1     , Param2    ,@param3    , @param4            */
		/*   Param : INSTANCE_ID                                              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_save_chk' 
		    BEGIN	
			    SELECT @v_dSql =''
                SELECT @v_dSql += ' SELECT CASE WHEN COUNT(*) > 0 THEN ''Y'' ELSE ''N'' END AS AUTH_YN ' + char(10)
                SELECT @v_dSql += ' 	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                      ' + char(10)
                SELECT @v_dSql += ' 	WHERE 1=1                                                  ' + char(10)
                SELECT @v_dSql += ' 	AND B.USER_ID 	  =  '''+ @p_user_id +'''                      ' + char(10)
                SELECT @v_dSql += ' 	AND B.SAVE_FLAG   = ''Y''                                      ' + char(10)
                SELECT @v_dSql += ' 	AND B.INSTANCE_ID = '''+ @param1 +'''                          ' + char(10)

			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Plan Amend화면에서 find_saveAuth 정보갖고오기                                                                                      */
		/*   Param : @Param1     , Param2    ,@param3    , @param4            */
		/*   Param : INSTANCE_ID                                              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_saveAuth' 
		    BEGIN	
			    SELECT @v_dSql =''
                SELECT @v_dSql += ' SELECT A.RELEASE_VALUE, B._VALUE                                ' + char(10)
                SELECT @v_dSql += ' FROM (                                                          ' + char(10)
                SELECT @v_dSql += '   	SELECT (CASE WHEN A.FACTORY_ID = ''-'' THEN                 ' + char(10)
				SELECT @v_dSql += '   	    A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' + char(10)
                SELECT @v_dSql += '   	FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                ' + char(10)
                SELECT @v_dSql += '   	WHERE  INSTANCE_ID     = '''+ @param1 +'''                  ' + char(10)
                SELECT @v_dSql += '   	AND    INSTANCE_DATE   = '''+ @param2 +'''                  ' + char(10)
                SELECT @v_dSql += '   	AND    RELEASE_PLAN_ID = '''+ @param3 +'''                  ' + char(10)
                SELECT @v_dSql += ' ) A                                                             ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                                               ' + char(10)
                SELECT @v_dSql += '   	-- 전송 가능 기준은 배포기준이 된 동 혹은 PLAN GROUP        ' + char(10)
				SELECT @v_dSql += '     -- 기준으로 저장권한 있는지 여부로 확인한다.                ' + char(10)
                SELECT @v_dSql += '   	SELECT DISTINCT (CASE WHEN B.ATTRIBUTE1 = ''PLAN GROUP''    ' + char(10)
				SELECT @v_dSql += '   	    THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS _VALUE   ' + char(10)
                SELECT @v_dSql += '   	FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)                   ' + char(10)
				SELECT @v_dSql += '   	     , SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)                  ' + char(10)
                SELECT @v_dSql += '   	WHERE  A.INSTANCE_ID = B.SEGMENT1                           ' + char(10)
                SELECT @v_dSql += '   	AND    A.USER_ID     = '''+ @p_user_id +'''                 ' + char(10)
                SELECT @v_dSql += '   	AND    A.INSTANCE_ID = '''+ @param1 +'''                    ' + char(10)
                SELECT @v_dSql += '   	AND    A.SAVE_FLAG   = ''Y''                                ' + char(10)
                SELECT @v_dSql += '   	AND    B.ACTIVE_FLAG = ''Y''                                ' + char(10)
                SELECT @v_dSql += '   	AND    B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                 ' + char(10)
                SELECT @v_dSql += ' ) B                                                             ' + char(10)
                SELECT @v_dSql += ' ON A.RELEASE_VALUE = B._VALUE                                   ' + char(10)

			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Plan Amend화면에서 find_Amend_Save_Check 정보갖고오기                                                                 */
		/*   Param : @Param1     , Param2    ,@param3    , @param4            */
		/*   Param : MASTER_ID , PLAN_ID     ,PLAN_DATE  , TableName         */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_Amend_Save_Check' 
		    BEGIN	
			    SELECT @v_dSql  = ''
                SELECT @v_dSql += ' SELECT '''+ @param3 +''' AS PLAN_DATE, A.INSTANCE_ID, NULL AS FACTORY_ID  ' + char(10)
                SELECT @v_dSql += '   	 , A.PLAN_ID, NULL AS CONFIRM_ID, NULL AS CONFIRM_TIME                ' + char(10)
                SELECT @v_dSql += '   	 , NULL AS CONFIRM_FLAG, NULL AS RELEASE_TIME, NULL AS RELEASE_FLAG   ' + char(10)
                SELECT @v_dSql += '   	 , ''ENGINE'' AS _TYPE                                                ' + char(10)
                SELECT @v_dSql += ' FROM   FP_PLAN_STATUS_H A WITH(NOLOCK)                                    ' + char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID   = '''+ @param1 +'''                                ' + char(10)
                SELECT @v_dSql += ' AND    A.PLAN_ID	   = '''+ @param2 +'''                                ' + char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG   = ''1''                                            ' + char(10)
                SELECT @v_dSql += ' UNION ALL                                                                 ' + char(10)
                SELECT @v_dSql += ' SELECT A.PLAN_DATE, A.INSTANCE_ID, A.FACTORY_ID, A.PLAN_ID                ' + char(10)
                SELECT @v_dSql += '   	 , A.CONFIRM_ID, CONVERT(VARCHAR,A.CONFIRM_TIME,20) AS CONFIRM_TIME   ' + char(10)
                SELECT @v_dSql += '   	 , A.CONFIRM_FLAG, CONVERT(VARCHAR,A.RELEASE_TIME,20) AS RELEASE_TIME ' + char(10)
                SELECT @v_dSql += '   	 , A.RELEASE_FLAG, ''FACTORY'' AS _TYPE                               ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_DETAIL_H A WITH(NOLOCK)                                ' + char(10)
                SELECT @v_dSql += ' WHERE  A.PLAN_DATE		= '''+ @param3 +'''                               ' + char(10)
                SELECT @v_dSql += ' AND    A.INSTANCE_ID    = '''+ @param1 +'''                               ' + char(10)
                SELECT @v_dSql += ' AND    A.PLAN_ID	    = '''+ @param2 +'''                               ' + char(10)
                SELECT @v_dSql += ' AND    (A.CONFIRM_FLAG = ''P'' OR A.RELEASE_FLAG = ''P'')                 ' + char(10)
                SELECT @v_dSql += ' UNION ALL                                                                 ' + char(10)
                SELECT @v_dSql += ' SELECT A.PLAN_DATE, A.INSTANCE_ID, A.PLAN_GROUP_ID AS FACTORY_ID                   ' + char(10)
                SELECT @v_dSql += '   	 , A.PLAN_ID, A.CONFIRM_ID, CONVERT(VARCHAR,A.CONFIRM_TIME,20) AS CONFIRM_TIME ' + char(10)
                SELECT @v_dSql += '   	 , A.CONFIRM_FLAG, CONVERT(VARCHAR,A.RELEASE_TIME,20) AS RELEASE_TIME          ' + char(10)
                SELECT @v_dSql += '   	 , A.RELEASE_FLAG, ''PLAN_GROUP'' AS _TYPE                                     ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)                                   ' + char(10)
                SELECT @v_dSql += ' WHERE  A.PLAN_DATE		= '''+ @param3 +'''                                        ' + char(10)
                SELECT @v_dSql += ' AND    A.INSTANCE_ID	= '''+ @param2 +'''                                        ' + char(10)
                SELECT @v_dSql += ' AND    A.PLAN_ID	  	= '''+ @param1 +'''                                        ' + char(10)
                SELECT @v_dSql += ' AND    (A.CONFIRM_FLAG = ''P'' OR A.RELEASE_FLAG = ''P'')                          ' + char(10)
                SELECT @v_dSql += ' UNION ALL                                                                          ' + char(10)
        SELECT @v_dSql += ' SELECT '''+ @param3 +''' AS PLAN_DATE, A.INSTANCE_ID, '''' AS FACTORY_ID              ' + char(10)
                SELECT @v_dSql += '      , '''' AS PLAN_ID, '''' AS CONFIRM_ID                                            ' + char(10)
                SELECT @v_dSql += '      , CONVERT(VARCHAR, A.EVENT_TIME, 20) AS CONFIRM_TIME                             ' + char(10)
                SELECT @v_dSql += '      , (CASE WHEN A.EVENT_TIME IS NOT NULL THEN ''Y'' ELSE ''N'' END) AS CONFIRM_FLAG ' + char(10)
                SELECT @v_dSql += '      , CONVERT(VARCHAR, A.CALCULATION_END, 20) AS RELEASE_TIME                        ' + char(10)
                SELECT @v_dSql += '      , (CASE WHEN A.CALCULATION_START IS NOT NULL AND A.CALCULATION_END IS NOT NULL THEN ''Y'' ELSE ''N'' END) AS RELEASE_FLAG ' + char(10)
                SELECT @v_dSql += '      , ''CONFIRM'' AS _TYPE                                                           ' + char(10)
                SELECT @v_dSql += ' FROM   FP_RELEASE_CALCULATION_STATUS_H A WITH(NOLOCK)                                 ' + char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                              ' + char(10)
                SELECT @v_dSql += ' AND    A.CALCULATION_STATUS IN (''RUN'',''WAIT'')                                     ' + char(10)

				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Plan Amend Memo화면에서 findLookUpCode_ProdType 정보갖고오기                                                                                      */
		/*   Param : @Param1     , Param2                     */
		/*   Param : INSTANCE_ID , DIVISION_ID              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'findLookUpCode_ProdType' 
		    BEGIN	
			    SELECT @v_dSql  = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.ATTRIBUTE2 AS CODE, A.SEGMENT2 AS NAME, A.SORT_ORDER ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                             ' + char(10)
                SELECT @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''                   ' + char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG = ''Y''                                           ' + char(10)
				IF (LEN(@param2) >0 )
				    BEGIN
					    SELECT @v_dSql += ' AND	 A.SEGMENT1 = '''+ @param2 +'''                            ' + char(10)
					END
                IF (@param1 = 'KR_CELL')
				    BEGIN
					    SELECT @v_dSql += ' UNION ALL SELECT ''M/C'' AS CODE_ID, ''M/C'' AS CODE_NAME, ''999'' AS SORT_ORDER ' + char(10)
					END
                SELECT @v_dSql += ' ORDER BY A.SORT_ORDER ' + char(10)

			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Plan Amend화면에서 find_isCurrWeek 정보갖고오기                                                                                      */
		/*   Param : @Param1     , Param2      ,@param3     , @param4              */
		/*   Param : MASTER_ID   , PLAN_ID     ,FP_SITE_ID  , CONFIRM_AREA         */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_isCurrWeek' 
		    BEGIN	
			    SELECT @v_dSql  = ''
                SELECT @v_dSql += ' SELECT CONVERT(VARCHAR, dbo.FN_SITE_TIME('''+ @param3 +''') -                                        ' + char(10)
				SELECT @v_dSql += '         (  SELECT ISNULL(LLL2._DAY, CONVERT(NUMERIC,ISNULL(LLL.SEGMENT1,''0''))) AS _DAY             ' + char(10)
                SELECT @v_dSql += '            FROM   SCM_SYS_LOOKUP_VALUE LLL WITH(NOLOCK)                                              ' + char(10)
                SELECT @v_dSql += '            LEFT OUTER JOIN (                                                                         ' + char(10)
                SELECT @v_dSql += '                     SELECT CONVERT(NUMERIC,ISNULL(SEGMENT1,''0'')) AS _DAY                           ' + char(10)
                SELECT @v_dSql += '                     FROM   SCM_SYS_LOOKUP_VALUE LLL2 WITH(NOLOCK)                                    ' + char(10)
                SELECT @v_dSql += '                     WHERE  LLL2.LOOKUP_TYPE_CODE = ''WPP_DAY_RANGE_BY_INSTANCE''                     ' + char(10)
                SELECT @v_dSql += '                     AND    LLL2.ACTIVE_FLAG = ''Y''                                                  ' + char(10)
                SELECT @v_dSql += '                     AND    LLL2.SEGMENT2 = '''+ @param1 +'''                                         ' + char(10)
                SELECT @v_dSql += '             ) LLL2                                                                                   ' + char(10)
                SELECT @v_dSql += '            ON 1=1                                                                                    ' + char(10)
                SELECT @v_dSql += '            WHERE LLL.LOOKUP_TYPE_CODE = ''WPP_DAY_RANGE'') ,112) AS CURR_DATE                        ' + char(10)
                SELECT @v_dSql += '      , A.RELEASE_PLAN_ID                                                                             ' + char(10)
				SELECT @v_dSql += '      , (CASE WHEN A.RELEASE_PLAN_ID = '''+ @param2 +''' THEN ''Y'' ELSE ''N'' END) AS IS_LATEST_PLAN ' + char(10)
				SELECT @v_dSql += '      , A.RELEASE_TYPE AS RELEASE_VALUE                                                               ' + char(10)
                SELECT @v_dSql += ' FROM (                                                                                               ' + char(10)
                SELECT @v_dSql += ' 	    SELECT A.*                                                                                   ' + char(10)
                SELECT @v_dSql += ' 	        , ROW_NUMBER() OVER (ORDER BY A.INSERT_TIME DESC) AS ROW_NUM                             ' + char(10)
                SELECT @v_dSql += ' 	        , B.RELEASE_TYPE                                                                         ' + char(10)
                SELECT @v_dSql += ' 	    FROM  FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                                                  ' + char(10)
                SELECT @v_dSql += ' 	    INNER JOIN (                                                                                 ' + char(10)
                SELECT @v_dSql += '       	       SELECT RR.INSTANCE_ID, (CASE WHEN RR.FACTORY_ID = ''-''                               ' + char(10)
				SELECT @v_dSql += '       	             THEN RR.PLAN_GROUP_ID ELSE RR.FACTORY_ID END) AS RELEASE_TYPE                   ' + char(10)
                SELECT @v_dSql += '       	       FROM   FP_RELEASE_PLAN_INFO_H RR WITH(NOLOCK)                                         ' + char(10)
                SELECT @v_dSql += '       	       WHERE  INSTANCE_ID     = '''+ @param1 +'''                                            ' + char(10)
                SELECT @v_dSql += '       	       AND    RELEASE_PLAN_ID = '''+ @param2 +'''                                            ' + char(10)
                SELECT @v_dSql += ' 	    ) B                                                                                          ' + char(10)
                SELECT @v_dSql += ' 	    ON  A.INSTANCE_ID = B.INSTANCE_ID                                                       ' + char(10)
                SELECT @v_dSql += ' 	    AND ( CASE WHEN '''+ @param4 +''' = ''BUILDING''                                             ' + char(10)
				SELECT @v_dSql += '       	      THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END) = B.RELEASE_TYPE                           ' + char(10)
                SELECT @v_dSql += ' ) A                                                                                                  ' + char(10)
                SELECT @v_dSql += ' WHERE A.ROW_NUM = 1                                                                                  ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Plan Amend화면에서 find_planPeriod_planResult 정보갖고오기                                                                                      */
		/*   Param : @Param1                    */
		/*   Param : INSTANCE_ID                */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_planPeriod_planResult' 
		    BEGIN	
			    SELECT @v_dSql  = ''
                SELECT @v_dSql += ' SELECT B.TARGET_WEEK                                                                    ' + char(10)
                SELECT @v_dSql += '   , A.DATED1 AS START_DATE                                                              ' + char(10)
				SELECT @v_dSql += '   , CONVERT(VARCHAR, CONVERT(DATETIME,DATED7)+(7*(C.PLAN_WEEK -1)), 112) AS END_DATE    ' + char(10)
                SELECT @v_dSql += '   , (7*C.PLAN_WEEK) AS WEEK_RANGE                                                       ' + char(10)
                SELECT @v_dSql += ' FROM  TH_UIS_CALENDAR A WITH(NOLOCK)                                                    ' + char(10)
                SELECT @v_dSql += '     , (                                                                                 ' + char(10)
                SELECT @v_dSql += '         SELECT ISO_YYYYWW AS TARGET_WEEK                                                ' + char(10)
                SELECT @v_dSql += '         FROM  TH_UIS_CAL A WITH(NOLOCK)                                                 ' + char(10)
				SELECT @v_dSql += '              ,(                                                                         ' + char(10)
                SELECT @v_dSql += '                SELECT SUBSTRING(A.SCP_PLAN_ID,1,8) AS TARGET_DATE                       ' + char(10)
                SELECT @v_dSql += '                FROM (                                                                   ' + char(10)
                SELECT @v_dSql += '                      SELECT MAX(A.SCP_PLAN_ID) AS SCP_PLAN_ID                           ' + char(10)
                SELECT @v_dSql += '                      FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)                   ' + char(10)
                SELECT @v_dSql += '                      WHERE  1=1                                                         ' + char(10)
                SELECT @v_dSql += '                      AND   (A.DIVISION_ID+A.SHOP_GROUP_ID+A.SITE_ID) IN (               ' + char(10)
                SELECT @v_dSql += '                         SELECT DISTINCT A.DIVISION_ID+B.SHOP_GROUP_ID+A.SITE_ID AS CODE ' + char(10)
                SELECT @v_dSql += '                         FROM  SCM_FACTORY_M A WITH(NOLOCK)                              ' + char(10)
                SELECT @v_dSql += '                         INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                 ' + char(10)
                SELECT @v_dSql += '                         ON    A.FACTORY_ID=B.FACTORY_ID                                 ' + char(10)
                SELECT @v_dSql += ' AND   B.ACTIVE_FLAG = ''Y''                                     ' + char(10)
                SELECT @v_dSql += '                         WHERE 1=1                                                       ' + char(10)
                SELECT @v_dSql += '                         AND   A.ACTIVE_FLAG = ''Y''                                     ' + char(10)
                SELECT @v_dSql += '                         AND   B.INSTANCE_ID = '''+ @param1 +'''                         ' + char(10)
                SELECT @v_dSql += '                      )                                                                  ' + char(10)
                SELECT @v_dSql += '                ) A                                                                      ' + char(10)
                SELECT @v_dSql += '       ) B                                                                               ' + char(10)
                SELECT @v_dSql += '       WHERE A.YYYYMMDD = B.TARGET_DATE                                                  ' + char(10)
                SELECT @v_dSql += '   ) B                                                                                   ' + char(10)
                SELECT @v_dSql += ' , (                                                                                     ' + char(10)
                SELECT @v_dSql += '    SELECT CONVERT(NUMERIC, ISNULL(AA.ATTRIBUTE15,8)) AS PLAN_WEEK                       ' + char(10)
                SELECT @v_dSql += '    FROM   SCM_SYS_LOOKUP_VALUE AA WITH(NOLOCK)                                          ' + char(10)
                SELECT @v_dSql += '    WHERE  AA.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                         ' + char(10)
                SELECT @v_dSql += '    AND    AA.ACTIVE_FLAG = ''Y''                                                        ' + char(10)
                SELECT @v_dSql += '    AND    AA.SEGMENT1 = '''+ @param1 +'''                                               ' + char(10)
                SELECT @v_dSql += ' ) C                                                                                     ' + char(10)
                SELECT @v_dSql += ' WHERE A.D0 = B.TARGET_WEEK                                                              ' + char(10)

			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Amend화면에서 findAmendInstanceList_common 정보갖고오기                                                                                      */
		/*   Param : @Param1              */
		/*   Param :                      */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'findAmendInstanceList_common' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql = ' SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME   ' +char(10)
                SELECT @v_dSql += '   , B.SORT_ORDER, B.ATTRIBUTE3 AS USE_WOW_STATUS  ' +char(10)
                SELECT @v_dSql += '   , B.ATTRIBUTE1 AS CONFIRM_AREA                  ' +char(10)
                SELECT @v_dSql += '   , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID               ' +char(10)
                SELECT @v_dSql += '   FROM (                                          ' +char(10)
                SELECT @v_dSql += '     SELECT DISTINCT INSTANCE_ID                   ' +char(10)
                SELECT @v_dSql += '     FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)     ' +char(10)
                SELECT @v_dSql += '     WHERE  USER_ID = '''+ @p_user_id +'''         ' +char(10)
				/*
				IF @param2 = 'Y'
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SAVE_FLAG = ''Y''            ' +char(10)
					END
					*/
                SELECT @v_dSql += '   ) A, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)        ' +char(10)
                SELECT @v_dSql += '   WHERE A.INSTANCE_ID      = B.SEGMENT1           ' +char(10)
                SELECT @v_dSql += '   AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''      ' +char(10)
                SELECT @v_dSql += '   AND   B.SEGMENT1 IN (                           ' +char(10)
                SELECT @v_dSql += '       SELECT INSTANCE_ID                          ' +char(10)
                SELECT @v_dSql += '       FROM FP_AMEND_UI_V                          ' +char(10)
                SELECT @v_dSql += '       WHERE 1=1                                   ' +char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AMEND_UI_NAME' , 'EQ', @param1)) + char(10);
                SELECT @v_dSql += '       AND USE_FLAG = ''Y''                        ' +char(10)
                SELECT @v_dSql += '   )                                               ' +char(10)
                SELECT @v_dSql += '  ORDER BY B.SORT_ORDER                            ' +char(10)

				--exec sp_executesql @v_dSql
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   Amend화면에서 find_lastestSubmit_info 정보갖고오기                                                                                      */
		/*   Param : @Param1 : INSTANCE_ID             */
		/*   Param :                      */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_lastestSubmit_info' 
		    BEGIN	
			    SELECT @v_dSql = ''

                SELECT @v_dSql += ' SELECT A.CALL_SEQUENCE, A.INSTANCE_ID ' +char(10)
                SELECT @v_dSql += '     , REPLACE(A.FP_PLAN_ID, '''+ @param1 +''' + ''-'', '''') AS FP_PLAN_ID ' +char(10)
                SELECT @v_dSql += '     , A.RELEASE_TYPE, A.ROW_NUM ' +char(10)
                SELECT @v_dSql += ' FROM ( ' +char(10)
                SELECT @v_dSql += '       SELECT A.* ' +char(10)
                SELECT @v_dSql += '           , ROW_NUMBER() OVER (ORDER BY CONVERT(NUMERIC,A.CALL_SEQUENCE) DESC) AS ROW_NUM ' +char(10)
                SELECT @v_dSql += '       FROM ( ' +char(10)
                SELECT @v_dSql += '             SELECT A.* ' +char(10)
                SELECT @v_dSql += '                 , (CASE WHEN B.FACTORY_ID =''-'' THEN B.PLAN_GROUP_ID ELSE B.FACTORY_ID END) AS RELEASE_TYPE ' +char(10)
                SELECT @v_dSql += '             FROM ( ' +char(10)
                SELECT @v_dSql += '                   SELECT A.CALL_SEQUENCE, '''+ @param1 +''' AS INSTANCE_ID, CONDITION_VALUE AS FP_PLAN_ID ' +char(10)
                SELECT @v_dSql += '                   FROM   FP_PROC_PARAMETER_H A WITH(NOLOCK) ' +char(10)
                SELECT @v_dSql += '                   WHERE  A.CALL_SEQUENCE IN ( ' +char(10)
                SELECT @v_dSql += '                   	SELECT CALL_SEQUENCE ' +char(10)
                SELECT @v_dSql += '                   	FROM   FP_PROC_PARAMETER_H A WITH(NOLOCK) ' +char(10)
                SELECT @v_dSql += '                   	WHERE  CONDITION_TYPE = ''INSTANCE_ID'' ' +char(10)
                SELECT @v_dSql += '                   	AND    CONDITION_VALUE = '''+ @param1 +''' ' +char(10)
                SELECT @v_dSql += '                   ) ' +char(10)
                SELECT @v_dSql += '                   AND    A.CONDITION_TYPE = ''FP_PLAN_ID'' ' +char(10)
                SELECT @v_dSql += '             ) A ' +char(10)
                SELECT @v_dSql += '             INNER JOIN FP_RELEASE_PLAN_INFO_H B WITH(NOLOCK) ' +char(10)
                SELECT @v_dSql += '             ON  A.INSTANCE_ID = B.INSTANCE_ID ' +char(10)
                SELECT @v_dSql += '             AND A.FP_PLAN_ID  = B.RELEASE_PLAN_ID ' +char(10)
                SELECT @v_dSql += '       ) A ' +char(10)
                SELECT @v_dSql += '       WHERE A.RELEASE_TYPE IN ( ' +char(10)
                SELECT @v_dSql += '             SELECT (CASE WHEN B.FACTORY_ID = ''-'' THEN B.PLAN_GROUP_ID ELSE B.FACTORY_ID END) AS RELEASE_TYPE ' +char(10)
                SELECT @v_dSql += '             FROM   FP_RELEASE_PLAN_INFO_H B WITH(NOLOCK)  ' +char(10)
                SELECT @v_dSql += '             WHERE  B.INSTANCE_ID = '''+ @param1 +''' ' +char(10)
                SELECT @v_dSql += '             AND    B.RELEASE_PLAN_ID = '''+ @param2 +''' ' +char(10)
                SELECT @v_dSql += '       ) ' +char(10)
                SELECT @v_dSql += ' ) A ' +char(10)
                SELECT @v_dSql += ' WHERE ROW_NUM = 1 ' +char(10)

				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   Amend화면에서 find_instanceInfo 정보갖고오기                                                                                      */
		/*   Param : @Param1 : INSTANCE_ID             */
		/*   Param :                      */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_instanceInfo' 
		    BEGIN	
			    SELECT @v_dSql = ''

                SELECT @v_dSql += ' SELECT A.SEGMENT1 AS CODE, A.SEGMENT2 AS NAME ' +char(10)
                SELECT @v_dSql += '      , A.ATTRIBUTE1 AS CONFIRM_AREA, A.ATTRIBUTE2 AS IS_SAME_PLAN_ID, A.ATTRIBUTE3 AS USE_WOW_STATUS ' +char(10)
                SELECT @v_dSql += '      , ISNULL(C.AMEND_TYPE,''AMEND UI'') AS AMEND_TYPE ' +char(10)
                SELECT @v_dSql += '      , A.ATTRIBUTE10 AS FIX_DATE_SYNC, A.ATTRIBUTE12 AS SYNC_YN ' +char(10)
                SELECT @v_dSql += '      , D.SITE_ID                           ' +char(10)
                SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' +char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                          ' +char(10)
                SELECT @v_dSql += '     SELECT A.SEGMENT1 AS INSTANCE_ID, ATTRIBUTE1 AS AMEND_TYPE ' +char(10)
                SELECT @v_dSql += '     FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)        ' +char(10)
                SELECT @v_dSql += '     WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE AMEND UI'' ' +char(10)
                SELECT @v_dSql += ' ) C                                                   ' +char(10)
                SELECT @v_dSql += ' ON     A.SEGMENT1 = C.INSTANCE_ID                     ' +char(10)
                SELECT @v_dSql += ' INNER JOIN (                                          ' +char(10)
                SELECT @v_dSql += ' 		SELECT A.INSTANCE_ID, MAX(B.SITE_ID) AS SITE_ID ' +char(10)
                SELECT @v_dSql += ' 		FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)     ' +char(10)
                SELECT @v_dSql += ' 		INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)         ' +char(10)
                SELECT @v_dSql += ' 		ON    A.FACTORY_ID = B.FACTORY_ID               ' +char(10)
                SELECT @v_dSql += ' 		WHERE A.ACTIVE_FLAG = ''Y''                     ' +char(10)
                SELECT @v_dSql += ' 		AND   B.ACTIVE_FLAG = ''Y''                     ' +char(10)
                SELECT @v_dSql += ' 		GROUP BY A.INSTANCE_ID                          ' +char(10)
                SELECT @v_dSql += ' ) D                                                  ' +char(10)
                SELECT @v_dSql += ' ON     A.SEGMENT1 = D.INSTANCE_ID                    ' +char(10)
                SELECT @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''          ' +char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG = ''Y''                         ' +char(10)
                SELECT @v_dSql += ' AND    A.SEGMENT1 = '''+ @param1 +'''                ' +char(10)
                SELECT @v_dSql += ' GROUP BY A.SEGMENT1, A.SEGMENT2, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, ISNULL(C.AMEND_TYPE,''AMEND UI'') ' +char(10)
                SELECT @v_dSql += '     , A.ATTRIBUTE10, A.ATTRIBUTE12, D.SITE_ID       ' +char(10)

			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   Amend화면에서 find_planInfo 정보갖고오기                                                                                      */
		/*   Param : @Param1    , @Param2             */
		/*   Param : INSTANCE_ID, PLAN_ID               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_planInfo' 
		    BEGIN	
			    SELECT @v_dSql = ''

                SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.PLAN_ID, A.PLAN_TYPE ' +char(10)
                SELECT @v_dSql += '      , A.SITE_ID, CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) AS PLAN_START_TIME, A.PLAN_HORIZON ' +char(10)
                SELECT @v_dSql += '      , A.DEMAND_HORIZON, A.CONFIG_SET_ID, A.BASIS_PLAN_ID ' +char(10)
                SELECT @v_dSql += '      , A.PLAN_ID AS CODE, A.PLAN_ID AS NAME               ' +char(10)
                SELECT @v_dSql += '      , A.DESCRIPTION                                      ' +char(10)
                SELECT @v_dSql += '      , A.CONFIRM_ID, CONVERT(VARCHAR, A.CONFIRM_TIME, 120) AS CONFIRM_TIME ' +char(10)
                SELECT @v_dSql += '      , A.INSERT_ID, CONVERT(VARCHAR, A.INSERT_TIME , 120) AS INSERT_TIME   ' +char(10)
                SELECT @v_dSql += '      , CONVERT(VARCHAR,A.PRE_FIX_DATE,112) AS PRE_FIX_DATE ' +char(10)
                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A WITH(NOLOCK)      ' +char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +''' ' +char(10)
                SELECT @v_dSql += ' AND    A.PLAN_ID = '''+ @param2 +'''     ' +char(10)

			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   Amend화면에서 find_Block_End_Date 정보갖고오기                                                                                      */
		/*   Param : @Param1    , @Param2             */
		/*   Param : INSTANCE_ID, PLAN_ID               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'find_Block_End_Date' 
		    BEGIN	
			    SELECT @v_dSql = ''

                SELECT @v_dSql += ' SELECT  AA.INSTANCE_ID ' +char(10)
                SELECT @v_dSql += '      , BLOCK_END_DATE ' +char(10)
                SELECT @v_dSql += '      , BLOCK_END_DATE ' +char(10)
                SELECT @v_dSql += ' FROM 	(             ' +char(10)
                SELECT @v_dSql += '         SELECT	SEGMENT1 AS INSTANCE_ID ' +char(10)
                SELECT @v_dSql += '             , CONVERT(VARCHAR, DATEADD(DD, (CONVERT(INTEGER, ATTRIBUTE15) * 7 -1) * ISNULL(C.ROLE_CNT,1), (SELECT dbo.FN_SITE_TIME(B.SITE_ID)) ), 112) AS BLOCK_END_DATE ' +char(10)
                SELECT @v_dSql += '             , REPLACE(CONVERT(VARCHAR, DATEADD(DD, (CONVERT(INTEGER, ATTRIBUTE15) * 7 -1) * ISNULL(C.ROLE_CNT,1), (SELECT dbo.FN_SITE_TIME(B.SITE_ID)) ), 112),''/'',''-'') AS BLOCK_DATE ' +char(10)
                SELECT @v_dSql += '             --, CONVERT(VARCHAR, DATEADD(DD, ( (CASE WHEN A.SEGMENT1 LIKE ''KR_%'' THEN CONVERT(INTEGER, ATTRIBUTE15) ELSE 5 END) * 7 -1) * ISNULL(C.ROLE_CNT,1), (SELECT dbo.FN_SITE_TIME(B.SITE_ID)) ), 112) AS BLOCK_END_DATE ' +char(10)
                SELECT @v_dSql += '             --, REPLACE(CONVERT(VARCHAR, DATEADD(DD, ( (CASE WHEN A.SEGMENT1 LIKE ''KR_%'' THEN CONVERT(INTEGER, ATTRIBUTE15) ELSE 5 END) * 7 -1) * ISNULL(C.ROLE_CNT,1), (SELECT dbo.FN_SITE_TIME(B.SITE_ID)) ), 112),''/'',''-'') AS BLOCK_DATE ' +char(10)
                SELECT @v_dSql += '         FROM	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)     ' +char(10)
                SELECT @v_dSql += '         LEFT OUTER JOIN (                               ' +char(10)
                SELECT @v_dSql += '                SELECT DISTINCT B.INSTANCE_ID, A.SITE_ID ' +char(10)
                SELECT @v_dSql += '                FROM SCM_FACTORY_M A WITH(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' +char(10)
                SELECT @v_dSql += '                ON  A.FACTORY_ID=B.FACTORY_ID ' +char(10)
                SELECT @v_dSql += '                AND B.ACTIVE_FLAG = ''Y''     ' +char(10)
                SELECT @v_dSql += '                WHERE 1=1                     ' +char(10)
                SELECT @v_dSql += '                AND	 A.ACTIVE_FLAG = ''Y''   ' +char(10)
                SELECT @v_dSql += '         ) B                                  ' +char(10)
                SELECT @v_dSql += '         ON 1=1                               ' +char(10)
                SELECT @v_dSql += '         AND   A.SEGMENT1 = B.INSTANCE_ID     ' +char(10)
                SELECT @v_dSql += '         LEFT OUTER JOIN (                    ' +char(10)
                SELECT @v_dSql += '                SELECT ISNULL(MAX(CASE WHEN ROLE_ID IN (''RA10101001'', ''RA10101007'') THEN 7 ELSE 1 END),1) AS ROLE_CNT ' +char(10)
                SELECT @v_dSql += '                FROM TH_UIS_USER_ROLE_RELATE          ' +char(10)
                SELECT @v_dSql += '                WHERE USER_ID = '''+ @p_user_id +'''  ' +char(10)
                SELECT @v_dSql += '                AND USE_AT_FLAG = ''Y''               ' +char(10)
                SELECT @v_dSql += '         ) C                                          ' +char(10)
                SELECT @v_dSql += '         ON 1=1                                       ' +char(10)
                SELECT @v_dSql += '         WHERE	A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' +char(10)
                SELECT @v_dSql += '         AND		A.ACTIVE_FLAG 	= ''Y''              ' +char(10)
                SELECT @v_dSql += '         AND		A.SEGMENT1 		= '''+ @param1 +'''  ' +char(10)
                SELECT @v_dSql += ' 		) AA                                         ' +char(10)
                SELECT @v_dSql += ' WHERE 1=1                                            ' +char(10)

			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   Amend화면에서 findFactoryCode_amend_common 정보갖고오기                                                                                      */
		/*            @Param1     @Param2,   @Param3,    @Param4,      @Param5,     @Param6,  @Param7,   @Param8,   @Param9     */
		/*   Param : INSTANCE_ID, PLAN_ID,   PLAN_TYPE,  CONFIRM_AREA, DIVISION_ID, SITE_ID,  PLANT_ID,  NON_AUTH,  SAVE_AUTH    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'findFactoryCode_amend_common' 
		    BEGIN	
			    SELECT @v_dSql1 = ''
                SELECT @v_dSql1 += ' SELECT A.FACTORY_ID AS CODE                                                   ' +char(10)
				SELECT @v_dSql1 += ' , ''('' + A.FACTORY_ID + '')'' + ISNULL(A.FACTORY_NAME, A.FACTORY_ID) AS NAME ' +char(10)
                SELECT @v_dSql1 += ' FROM   SCM_FACTORY_M A WITH(NOLOCK)                                           ' +char(10)
                SELECT @v_dSql1 += ' WHERE  1=1                                                                    ' +char(10)

                IF @Param8 = 'Y'  --NON_AUTH
                    BEGIN 
                         SELECT @v_dSql1 += ' ' +char(10)
                    END
                ELSE
		            BEGIN
                        SELECT @v_dSql1 += ' AND  EXISTS (                                            ' +char(10)
                        SELECT @v_dSql1 += '   	          SELECT 1                                    ' +char(10)
                        SELECT @v_dSql1 += '   	          FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)   ' +char(10)
                        SELECT @v_dSql1 += '   	          WHERE  A.COMPANY_ID     = B.COMPANY_ID      ' +char(10)
                        SELECT @v_dSql1 += ' 	          	AND  A.DIVISION_ID    = B.DIVISION_ID     ' +char(10)
                        SELECT @v_dSql1 += ' 	          	AND  A.SITE_ID        = B.SITE_ID         ' +char(10)
                        SELECT @v_dSql1 += ' 	          	AND  A.PLANT_ID       = B.PLANT_ID        ' +char(10)
                        SELECT @v_dSql1 += ' 	          	AND  A.FACTORY_ID     = B.FACTORY_ID      ' +char(10)
                        SELECT @v_dSql1 += '   	            AND  B.USER_ID     = '''+ @p_user_id +''' ' +char(10)
						IF @Param9 = 'Y' --SAVE_AUTH
						    BEGIN
                                SELECT @v_dSql1 += ' AND    B.SAVE_FLAG = ''Y'' ' +char(10)
							END                        
						
						SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @param1)) + char(10) -- 20220211 수정
						
						SELECT @v_dSql1 += '   	         )                                            ' +char(10)
	                    

                    END
                SELECT @v_dSql1 += ' AND A.ACTIVE_FLAG = ''Y''                                                                               ' +char(10)
                SELECT @v_dSql1 += ' AND EXISTS (                                                                                            ' +char(10)
                SELECT @v_dSql1 += '             SELECT 1 FROM (                                                                             ' +char(10)
                SELECT @v_dSql1 += '                           SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID  ' +char(10)
                SELECT @v_dSql1 += '                           FROM   SCM_FACTORY_M A WITH(NOLOCK)                                           ' +char(10)
                SELECT @v_dSql1 += '                           INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                               ' +char(10)
                SELECT @v_dSql1 += '                           ON    A.FACTORY_ID=B.FACTORY_ID                                               ' +char(10)
                SELECT @v_dSql1 += '                           AND		B.ACTIVE_FLAG = ''Y''                                                ' +char(10)
                SELECT @v_dSql1 += '                           WHERE 1=1                                                                     ' +char(10)
                SELECT @v_dSql1 += '                           AND	 A.ACTIVE_FLAG = ''Y''                                                   ' +char(10)
                SELECT @v_dSql1 += '                           AND   B.INSTANCE_ID = '''+ @param1 +'''                                       ' +char(10)
                SELECT @v_dSql1 += '                          ) C                                                                            ' +char(10)
                SELECT @v_dSql1 += '             WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID                             ' +char(10)
				SELECT @v_dSql1 += '             AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID             ' +char(10)
                SELECT @v_dSql1 += '          )                                                                                              ' +char(10)
	            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5))                                    + char(10)
	            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6))                                        + char(10)
	            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7))                                       + char(10)
				
				SELECT @v_dSql2 = ''
                IF @param3 = 'RELEASE' AND  @param4 = 'PLAN GROUP'
                    BEGIN
                        SELECT @v_dSql2 += ' AND A.FACTORY_ID IN (                                 ' +char(10)
                        SELECT @v_dSql2 += '         SELECT KK.FACTORY_ID                          ' +char(10)
                        SELECT @v_dSql2 += '         FROM   FP_RELEASE_PLAN_INFO_H KK WITH(NOLOCK) ' +char(10)
                        SELECT @v_dSql2 += '         WHERE  KK.INSTANCE_ID = '''+ @param1 +'''     ' +char(10)
                        SELECT @v_dSql2 += '         AND KK.RELEASE_PLAN_ID = '''+ @param2 +'''    ' +char(10)
                        SELECT @v_dSql2 += '    )                                                  ' +char(10)
                    END
			    
                SELECT @v_dSql2 += ' GROUP BY A.FACTORY_ID, A.FACTORY_NAME                         ' +char(10)
                SELECT @v_dSql2 += ' ORDER BY A.FACTORY_ID                                         ' +char(10)
			    
			    SELECT @v_dSql = @v_dSql1 + @v_dSql2
			    
				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   Amend화면에서 findOperationCode_common 정보갖고오기                                                                                 */
		/*            @Param1     @Param2      @Param3   @Param4            */
		/*   Param : INSTANCE_ID, DIVISION_ID, SITE_ID,  AMEND_MAIN_FLAG    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'findOperationCode_common' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.OPERATION_ID AS CODE                                ' + char(10)
				SELECT @v_dSql += '  , ''('' + A.OPERATION_ID + '')'' + B.OPERATION_NAME AS NAME          ' + char(10)
                SELECT @v_dSql += '  , A.AMEND_MAIN_FLAG                                                  ' + char(10)
                SELECT @v_dSql += ' FROM   FP_INSTANCE_OPERATION_V A                                      ' + char(10)
                SELECT @v_dSql += ' 	, SCM_OPERATION_M B                                               ' + char(10)
                SELECT @v_dSql += ' WHERE  A.COMPANY_ID   = B.COMPANY_ID                                  ' + char(10)
                SELECT @v_dSql += ' AND    A.DIVISION_ID  = B.DIVISION_ID                                 ' + char(10)
                SELECT @v_dSql += ' AND    A.SITE_ID      = B.SITE_ID                                     ' + char(10)
                SELECT @v_dSql += ' AND    A.OPERATION_ID = B.OPERATION_ID                                ' + char(10)
                SELECT @v_dSql += ' AND    A.INSTANCE_ID  = '''+ @param1 +'''                             ' + char(10)
                SELECT @v_dSql += ' AND    EXISTS (                                                       ' + char(10)
                SELECT @v_dSql += '                SELECT 1                                               ' + char(10)
                SELECT @v_dSql += '                FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)              ' + char(10)
                SELECT @v_dSql += '                WHERE  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
                SELECT @v_dSql += '                AND    A.DIVISION_ID = B.DIVISION_ID                   ' + char(10)
                SELECT @v_dSql += '                AND    A.SITE_ID     = B.SITE_ID                       ' + char(10)
                SELECT @v_dSql += '                AND    A.OPERATION_ID = B.OPERATION_ID                 ' + char(10)
                SELECT @v_dSql += '                AND    B.USER_ID     = '''+ @p_user_id +'''            ' + char(10)
                SELECT @v_dSql += '               )                                                       ' + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param2))   + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param3))       + char(10)
                SELECT @v_dSql += ' AND   A.AMEND_FLAG = ''Y''                                            ' +char(10)

                IF @param4 ='N'
				    BEGIN 
                        SELECT @v_dSql += ' AND   A.AMEND_MAIN_FLAG = ''Y'' ' +char(10)
				    END
                SELECT @v_dSql += ' ORDER BY A.OPERATION_ID DESC ' +char(10)
				
				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
				exec sp_executesql @v_dSql

		   END
		/**********************************************************************************************************************************************************************/
		/*   Amend화면에서 find_Memo 정보갖고오기                                                                                                                             */
		/*            @param1  @param2   @param3   @param4  @param5  @param6    @param7  @param8   @param9  @param10   @param11   @param12  @param13   @param14   @param15    */
		/*   Param : INSTANCE, DIVISION, SITE,     PLANT,   FACTORY, OPERATION, LINE,   TOP_ITEM,  ITEM,    ELECTRODE, EQUIPMENT, MARKTE,   PROD_TYPE, PLAN_DATE, MEMO_TYPE   */
		/**********************************************************************************************************************************************************************/
		ELSE IF @p_code = 'find_Memo' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID ' + char(10)
                SELECT @v_dSql += '       , A.TOP_ITEM_ID, A.ITEM_ID                                      ' + char(10)
                SELECT @v_dSql += '       , A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.MARKET, A.PRODUCTION_TYPE ' + char(10)
                SELECT @v_dSql += '       , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE   ' + char(10)
                SELECT @v_dSql += '       , CONVERT(VARCHAR,A.PLAN_DATE,112) AS BUCKET_FROM ' + char(10)
                SELECT @v_dSql += '       , CONVERT(VARCHAR,A.PLAN_DATE,112) AS BUCKET_TO   ' + char(10)
                SELECT @v_dSql += '       , A.MEMO                                          ' + char(10)
                SELECT @v_dSql += '       , A.UPDATE_ID AS CREATOR                          ' + char(10)
                SELECT @v_dSql += '       , CONVERT(VARCHAR,A.UPDATE_TIME,120) AS CREATION  ' + char(10)
                SELECT @v_dSql += '       , A.MEMO_TYPE                                     ' + char(10)
                SELECT @v_dSql += ' FROM    FP_AMEND_MEMO_M A WITH(NOLOCK)                  ' + char(10)
                SELECT @v_dSql += ' WHERE   1=1                                             ' + char(10)

                IF (LEN(@param1) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @param1))    + char(10)
                        --SELECT @v_dSql += ' AND   A.INSTANCE_ID = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param2) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param2))    + char(10)
                        --SELECT @v_dSql += ' AND   A.DIVISION_ID = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param3) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param3))    + char(10)
                        --SELECT @v_dSql += ' AND   A.SITE_ID = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param4) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param4))    + char(10)
                        --SELECT @v_dSql += ' AND   A.PLANT_ID = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param5) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param5))    + char(10)
                        --SELECT @v_dSql += ' AND   A.FACTORY_ID = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param6) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param6))    + char(10)
                        --SELECT @v_dSql += ' AND   A.OPERATION_ID = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param7) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param7))    + char(10)
                        --SELECT @v_dSql += ' AND   A.LINE_ID = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param8) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @param8))    + char(10)
                        --SELECT @v_dSql += ' AND   A.TOP_ITEM_ID = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param9) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @param9))    + char(10)
                        --SELECT @v_dSql += ' AND   A.ITEM_ID = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param10) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ELECTRODE_TYPE' , 'EQ', @param10))    + char(10)
                        --SELECT @v_dSql += ' AND   A.ELECTRODE_TYPE = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param11) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.EQUIPMENT_ID' , 'EQ', @param11))    + char(10)
                        --SELECT @v_dSql += ' AND   A.EQUIPMENT_ID = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param12) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.MARKET' , 'EQ', @param12))    + char(10)
                        --SELECT @v_dSql += ' AND   A.MARKET = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param13) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @param13))    + char(10)
                        --SELECT @v_dSql += ' AND   A.PRODUCTION_TYPE = '''+ @param1 +''' ' +char(10)
				    END
                IF (LEN(@param14) > 0)
				    BEGIN 
					    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CONVERT(VARCHAR,A.PLAN_DATE,112)' , 'EQ', @param14))    + char(10)
                        --SELECT @v_dSql += ' AND   CONVERT(VARCHAR,A.PLAN_DATE,112) = '''+ @param1 +''' ' +char(10)
				    END

                IF (LEN(@param15) > 0)
				    BEGIN 
                        SELECT @v_dSql += ' AND   A.MEMO_TYPE = '''+ @param15 +''' ' +char(10)
				    END
                ELSE 
				    BEGIN 
                        SELECT @v_dSql += ' AND   A.MEMO_TYPE = ''DPP'' ' +char(10)
				    END

                SELECT @v_dSql += ' AND	A.MEMO IS NOT NULL ' +char(10)

				--SELECT @v_dSql
			  exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   FP00590화면에서 find Instance 정보갖고오기                                                                                         */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findInstance'

			BEGIN
				SELECT @v_dSql = ''
				/* Alias setting */																				
				SELECT @v_dSql = '  SELECT A.SEGMENT1 AS CODE, A.SEGMENT2 AS NAME                      ' + char(10)
				SELECT @v_dSql += '   , A.ATTRIBUTE1 AS CONFIRM_AREA, A.ATTRIBUTE2 AS IS_SAME_PLAN_ID  ' + char(10)
				SELECT @v_dSql += '   , A.ATTRIBUTE3 AS USE_WOW_STATUS                                 ' + char(10)
				SELECT @v_dSql += '	  , ISNULL(C.AMEND_TYPE,''AMEND UI'' ) AS AMEND_TYPE               ' + char(10)
				SELECT @v_dSql += '	  , A.ATTRIBUTE10 AS FIX_DATE_SYNC, A.ATTRIBUTE12 AS SYNC_YN       ' + char(10)
				SELECT @v_dSql += '  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                        ' + char(10)
				SELECT @v_dSql += '  LEFT OUTER JOIN (                                                 ' + char(10)
				SELECT @v_dSql += '	      SELECT A.SEGMENT1 AS INSTANCE_ID, ATTRIBUTE1 AS AMEND_TYPE   ' + char(10)
				SELECT @v_dSql += '	      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                   ' + char(10)
				SELECT @v_dSql += '	      WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE AMEND UI''            ' + char(10)
				SELECT @v_dSql += '        ) C                                                         ' + char(10)
				SELECT @v_dSql += '  ON     A.SEGMENT1         = C.INSTANCE_ID                         ' + char(10)
				SELECT @v_dSql += '  WHERE  A.LOOKUP_TYPE_CODE = '''+ @param2 +'''                     ' + char(10)
				SELECT @v_dSql += '  AND    A.ACTIVE_FLAG      = ''Y''                                 ' + char(10)
				-- 2026-06-08     kimcd         [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Link Instance 조건 추가
				SELECT @v_dSql += '  AND ( A.SEGMENT1 LIKE ''%CELL%'' OR A.SEGMENT1 LIKE ''%PACK%'' OR A.SEGMENT1 LIKE ''%FORM%'' OR A.SEGMENT1 LIKE ''%PMIX%'' OR A.SEGMENT1 LIKE ''%PRE%'' OR  A.SEGMENT1 LIKE ''PL_E_%'' OR  A.SEGMENT1 LIKE ''%LINK%'') -- 신UI에서 cell/pack/formation/premix/pre/link 만 운영   ' + char(10)
				SELECT @v_dSql += '  --AND    A.SEGMENT1 NOT LIKE ''%POST%''                             ' + char(10)
				SELECT @v_dSql += '  AND    A.SEGMENT1 NOT IN ( ''CN_FORM_T'' )                        ' + char(10)
				SELECT @v_dSql += '  AND    EXISTS (                                                   ' + char(10)
				SELECT @v_dSql += '		SELECT 1                                                       ' + char(10)
				SELECT @v_dSql += '		FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                      ' + char(10)
				SELECT @v_dSql += '		WHERE  A.SEGMENT1 = B.INSTANCE_ID                              ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.SITE_ID' , 'EQ', @param1))    + char(10)
				--SELECT @v_dSql += '		AND    B.SITE_ID  = '''+ @param1 +'''                          ' + char(10)
				SELECT @v_dSql += '		AND    B.USER_ID  = '''+ @p_user_id +'''                       ' + char(10)
				SELECT @v_dSql += '  )                                                                 ' + char(10)
				SELECT @v_dSql += '  GROUP BY A.SEGMENT1, A.SEGMENT2, A.ATTRIBUTE1, A.ATTRIBUTE2       ' + char(10)
				SELECT @v_dSql += '	 , A.ATTRIBUTE3, ISNULL(C.AMEND_TYPE,''AMEND UI'')                 ' + char(10)
				SELECT @v_dSql += '	 , A.ATTRIBUTE10, A.ATTRIBUTE12                                    ' + char(10)
				SELECT @v_dSql += '	 , A.ATTRIBUTE10, A.ATTRIBUTE12  ,A.SORT_ORDER                                  ' + char(10)
				--SELECT @v_dSql += '  ORDER BY A.SEGMENT1			                                   ' + char(10)
				SELECT @v_dSql += '  ORDER BY A.SORT_ORDER			                                   ' + char(10)
				
				--SELECT @v_dsql AS SQL
				--RETURN
				--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00590 Confirm 화면에서 find_PLANWEEK_DATE 정보갖고오기                                                                                         */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_PLANWEEK_DATE'

			BEGIN
				SELECT @v_dSql = ''
                -- 계획일자에 ((PLAN_WEEK - 1) * 7일)일을 더한 날짜의 주차를 가진 날짜들의 가장 큰 날짜(주 마지막날)
                SELECT @v_dSql += ' SELECT '''+ @param2 +''' AS START_DATE, MAX(YYYYMMDD) AS END_DATE            ' + char(10)
                SELECT @v_dSql += ' FROM   TH_UIS_CAL A WITH(NOLOCK)                                             ' + char(10)
                SELECT @v_dSql += ' WHERE  1=1                                                                   ' + char(10)
                SELECT @v_dSql += ' AND ISO_YYYYWW = (                                                           ' + char(10)
                SELECT @v_dSql += '       SELECT ISO_YYYYWW                                                      ' + char(10)
                SELECT @v_dSql += '       FROM   TH_UIS_CAL A WITH(NOLOCK)                                       ' + char(10)
                SELECT @v_dSql += '       WHERE  YYYYMMDD = CONVERT(VARCHAR, CONVERT(DATETIME,'''+ @param2 +''') ' + char(10)
				SELECT @v_dSql += '              + ( SELECT (ISNULL(A.ATTRIBUTE15,''10'')-1)*7                   ' + char(10)
				SELECT @v_dSql += '                  FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                    ' + char(10)
				SELECT @v_dSql += '                  WHERE A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                  ' + char(10)
				SELECT @v_dSql += '                  AND A.SEGMENT1 = '''+ @param1 +'''), 112)                   ' + char(10)
				SELECT @v_dSql += '       )                                                                      ' + char(10) 
				--print @v_dSql
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@p_code, @v_dSql , @param1, getdate() ) ;
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00590 Release Total 팝업화면에서 find_instanceInfo 정보갖고오기                                                                  */
		/*   Param :@Param1	: INSTANCE_ID,   @Param2	: PLAN_ID                                           					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_instanceInfo'
		    BEGIN	
                SELECT @v_dSql += ' SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS INSTANCE_NAME  ' + char(10)
				SELECT @v_dSql += '    , A.SEGMENT3 AS INSTANCE_SUB_CODE                           ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE1 AS CONFIRM_AREA                              ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE2 AS IS_SAME_PLAN_ID                           ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE3 AS USE_WOW_STATUS                            ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE4 AS CREATE_VD_MO                              ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE5 AS PSI_CAL_STATUS                            ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE6 AS MIN_FIX_DATE                              ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE7 AS DEFAULT_FIX_DATE                          ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE8 AS ALLOWED_FIX_DATE_NULL          ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE9 AS INSTANCE_TYPE                             ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE10 AS FIX_DATE_SYNC                            ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE11 AS FIRST_PLAN_CAPA_PLANNING                 ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE12 AS SYNC_YN                                  ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE13 AS ENGINE_PLAN_PER_WEEK                     ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE14 AS BATCH_POINT                              ' + char(10)
                SELECT @v_dSql += '    , A.ATTRIBUTE15 AS PLAN_WEEK                                ' + char(10)
                SELECT @v_dSql += '    , B.RELEASE_QUEUE_FLAG                                      ' + char(10)
                SELECT @v_dSql += '    , B.CAPA_VALIDATION                                         ' + char(10)
                SELECT @v_dSql += '    , B.LIMIT_CAPA                                              ' + char(10)
                SELECT @v_dSql += '    , B.SPLIT_MENU_OPTION ' + char(10) -- 부가정보 추가... 20240118  
                SELECT @v_dSql += '    , B.CREATE_PLAN_FIX_OPTION ' + char(10)
                SELECT @v_dSql += '    , B.PACK_INHOUSE_OPTION ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                     ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                                              ' + char(10)
                SELECT @v_dSql += '		SELECT ISNULL(A.ATTRIBUTE7, ''N'') AS RELEASE_QUEUE_FLAG   ' + char(10)
                SELECT @v_dSql += '		   , ISNULL(A.ATTRIBUTE8, ''N'') AS CAPA_VALIDATION -- capa validation... 20210810 ' + char(10)
                SELECT @v_dSql += '		   , CONVERT(NUMERIC(20,2), (CASE WHEN (A.ATTRIBUTE9 IS NULL OR A.ATTRIBUTE9='''') THEN 100.00 ELSE A.ATTRIBUTE9 END)) AS LIMIT_CAPA ' + char(10)
                SELECT @v_dSql += '		   , A.ATTRIBUTE10 AS SPLIT_MENU_OPTION ' + char(10) -- 부가정보 추가... 20240118
                SELECT @v_dSql += '		   , A.ATTRIBUTE11 AS CREATE_PLAN_FIX_OPTION ' + char(10)
                SELECT @v_dSql += '		   , A.ATTRIBUTE12 AS PACK_INHOUSE_OPTION ' + char(10)
                SELECT @v_dSql += '		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                 ' + char(10)
                SELECT @v_dSql += '		WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE AMEND UI''          ' + char(10)
                SELECT @v_dSql += '		AND    A.ACTIVE_FLAG      = ''Y''                          ' + char(10)
                SELECT @v_dSql += '		AND    A.SEGMENT1         = '''+ @param1 +'''              ' + char(10)
                SELECT @v_dSql += ' ) B                                                            ' + char(10)
                SELECT @v_dSql += ' ON     1=1                                                     ' + char(10)
                SELECT @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                    ' + char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG      = ''Y''                              ' + char(10)
                SELECT @v_dSql += ' AND    A.SEGMENT1         = '''+ @param1 +'''                  ' + char(10) 
			    
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 find_CurrUTDate 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_CurrUTDate'

			BEGIN
				SELECT @v_dSql = ''       
			    SELECT @v_dSql = ' WITH SITE_T AS (                              ' + char(10)
      		    SELECT @v_dSql += ' 	SELECT 	DISTINCT INSTANCE_ID, SITE_ID    ' + char(10)
      		    SELECT @v_dSql += ' 	FROM 	FP_INSTANCE_OPERATION_V          ' + char(10)
      		    SELECT @v_dSql += ' 	WHERE	INSTANCE_ID = '''+ @param1 +'''  ' + char(10)
      		    SELECT @v_dSql += ' )                                            ' + char(10)
			    SELECT @v_dSql += ' SELECT (CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < (FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') + A.BASIS_START_TIME)   ' + char(10)
			    SELECT @v_dSql += ' 			 THEN CONVERT(VARCHAR,DATEADD(DD,-1,FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'')),112)                                                ' + char(10)
			    SELECT @v_dSql += ' 			 ELSE FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') END) AS CURR_DATE                                                                  ' + char(10)
			    SELECT @v_dSql += ' FROM   FP_INSTANCE_START_TIME_V A         ' + char(10)
			    SELECT @v_dSql += ' 	   ,SITE_T B                          ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND	   A.INSTANCE_ID = B.INSTANCE_ID      ' + char(10)

				--Log 중요함으로 남긴다
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'FP00590_find_CurrUTDate','',@v_dSql,'select',@runstart, @runend
				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 findRevision 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findRevision'
		    BEGIN
			    SELECT @v_dSql = '  SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME                              ' + char(10)
				SELECT @v_dSql += '    , A.INSTANCE_ID, A.PLAN_ID, A.PLAN_TYPE, A.SITE_ID                    ' + char(10)
			    SELECT @v_dSql += '	   , CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) AS PLAN_START_TIME      ' + char(10)
			    SELECT @v_dSql += '	   , A.PLAN_HORIZON, A.DEMAND_HORIZON, A.CONFIG_SET_ID, A.BASIS_PLAN_ID  ' + char(10)
			    SELECT @v_dSql += '	   , A.DESCRIPTION, A.CONFIRM_ID, A.INSERT_ID                            ' + char(10)
			    SELECT @v_dSql += '	   , CONVERT(VARCHAR, A.CONFIRM_TIME, 120) AS CONFIRM_TIME               ' + char(10)
			    SELECT @v_dSql += '	   , CONVERT(VARCHAR, A.INSERT_TIME , 120) AS INSERT_TIME                ' + char(10)
			    SELECT @v_dSql += '	   , CONVERT(VARCHAR,A.PRE_FIX_DATE,112) AS PRE_FIX_DATE                 ' + char(10)
			    SELECT @v_dSql += '  FROM   SCM_FP_PLAN_H A WITH(NOLOCK)                                     ' + char(10)
			    SELECT @v_dSql += '  WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                ' + char(10)
			    SELECT @v_dSql += '  AND    CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) = '''+ @param2 +'''  ' + char(10)
			    SELECT @v_dSql += '  AND    PLAN_TYPE <> ''RELEASE''                                         ' + char(10)
			    SELECT @v_dSql += '  AND    RIGHT(A.PLAN_ID,2) <> ''00''                                     ' + char(10)
			    SELECT @v_dSql += '  ORDER BY CODE DESC                                                      ' + char(10)
				
				--Log 중요함으로 남긴다
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'FP00590_findRevision','',@v_dSql,'select',@runstart, @runend
				exec sp_executesql @v_dSql

	      END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 findEngineFlag 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findEngineFlag'
		    BEGIN
			     SELECT @v_dSql = ''
		         SELECT @v_dSql = '  SELECT  '''+ @param2 +''' AS PLAN_ID         ' + char(10)
				 SELECT @v_dSql += '    , A.INBOUND_FLAG AS INBOUND               ' + char(10)
				 SELECT @v_dSql += '    , A.ENGINE_FLAG AS ENGINE                 ' + char(10)
				 SELECT @v_dSql += '    , A.DB_TRANS_FLAG AS OUTBOUND             ' + char(10)
			     SELECT @v_dSql += '  FROM    FP_PLAN_STATUS_H A(NOLOCK)          ' + char(10)
			     SELECT @v_dSql += '  WHERE   A.INSTANCE_ID = '''+ @param1 +'''   ' + char(10)
			     SELECT @v_dSql += '  AND     A.PLAN_ID = '''+ @param2 +'''       ' + char(10)

				 --Log 중요함으로 남긴다
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'FP00590_findEngineFlag','',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 findIsRelease 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findIsRelease'
		    BEGIN
			     SELECT @v_dSql = ''
				 SELECT @v_dSql = '  SELECT MAX(A.RELEASE_FLAG) AS IS_RELEASE                                ' + char(10)
                 SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A(NOLOCK)                                          ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                ' + char(10)
                 SELECT @v_dSql += ' AND    CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) = '''+ @param2 +'''  ' + char(10)

				 --Log 중요함으로 남긴다
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'FP00590_findIsRelease','',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 findIsRunningPlan 정보갖고오기                                                                                                              */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findIsRunningPlan'
		    BEGIN
			    SELECT @v_dSql = ''
			    SELECT @v_dSql = '  SELECT ISNULL(MAX(A.ACTIVE_FLAG),0) AS CNT  ' + char(10)
                SELECT @v_dSql += '    ,MAX(A.PLAN_ID) AS PLAN_ID                ' + char(10)
                SELECT @v_dSql += '    ,MAX(A.INSERT_ID) AS INSERT_ID            ' + char(10)
                SELECT @v_dSql += '  FROM   FP_PLAN_STATUS_H A(NOLOCK)           ' + char(10)
                SELECT @v_dSql += '  WHERE  A.ACTIVE_FLAG = ''1''                ' + char(10)
                SELECT @v_dSql += '  AND    A.INSTANCE_ID = '''+ @param1 +'''    ' + char(10)

				--Log 중요함으로 남긴다
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'FP00590_findIsRunningPlan','',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql

	        END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 find_fixDateInfo 정보갖고오기                                                                                      */
		/*   Param :@Param1	: INSTANCE_ID      																			                        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_fixDateInfo'
		    BEGIN
			    SELECT @v_dSql = ''
			    SELECT @v_dSql = '   SELECT A.SEGMENT1 AS INSTANCE_ID  ' + char(10)
                SELECT @v_dSql += '        , A.ATTRIBUTE6 AS MIN_FIX_DATE           ' + char(10)
                SELECT @v_dSql += '        , A.ATTRIBUTE7 AS DEFAULT_FIX_DATE       ' + char(10)
                SELECT @v_dSql += '        , A.ATTRIBUTE8 AS ALLOWED_FIX_DATE_NULL  ' + char(10)
                SELECT @v_dSql += '   FROM   SCM_SYS_LOOKUP_VALUE A                 ' + char(10)
                SELECT @v_dSql += '   WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''   ' + char(10)
                SELECT @v_dSql += '   AND    A.SEGMENT1 = '''+ @param1 +'''         ' + char(10)
				
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 find_fixDate 정보갖고오기                                                                                      */
		/*   Param :@Param1	: INSTANCE_ID      																			                        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_fixDate'
		    BEGIN
			    SELECT @v_dSql = ''
/*
				SELECT @v_dSql += 'SELECT MAX(YYYYMMDD) AS FIX_DATE ' + char(10)
				SELECT @v_dSql += 'FROM   TH_UIS_CAL A WITH(NOLOCK) ' + char(10)
				SELECT @v_dSql += 'WHERE  1=1 ' + char(10)
				SELECT @v_dSql += 'AND    ISO_YYYYWW = ( ' + char(10)
				SELECT @v_dSql += '		SELECT A.ISO_YYYYWW' + char(10)
				SELECT @v_dSql += '		FROM   TH_UIS_CAL A WITH(NOLOCK)' + char(10)
				SELECT @v_dSql += '		WHERE  1=1' + char(10)
				SELECT @v_dSql += '		AND    A.YYYYMMDD = (' + char(10)
			    SELECT @v_dSql += '			SELECT CONVERT(VARCHAR, DATEADD(DAY, ISNULL(ATTRIBUTE15,8) * 7 -1, CONVERT(DATE, '''+ @param2 +''')), 112) AS FIX_DATE  ' + char(10)
                SELECT @v_dSql += '			FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += '			WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''   ' + char(10)
                SELECT @v_dSql += '			AND    A.SEGMENT1 = '''+ @param1 +'''         ' + char(10)
				SELECT @v_dSql += '		) ' + char(10)
				SELECT @v_dSql += ') ' + char(10)
*/
				-- [E20250217-000184]N2.2 W14주차 FP 문의 관련 수정 요청 건
				SELECT @v_dSql += 'SELECT CONVERT(VARCHAR, DATEADD(DAY ' + char(10)
				SELECT @v_dSql += '			, ((CONVERT(NUMERIC, ISNULL(ATTRIBUTE15,''8''))+1)*7-1) ' + char(10) -- +1 로 한 주차 더 보여줌
				SELECT @v_dSql += '			, DVALUE), 112 ) AS FIX_DATE ' + char(10)
				SELECT @v_dSql += 'FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
				SELECT @v_dSql += ', ( ' + char(10)
				SELECT @v_dSql += '	SELECT MIN(DT) AS DVALUE ' + char(10)-- 기준일자의 주차의 시작일(월요일)을 찾음
				SELECT @v_dSql += '	FROM   TH_UIS_CAL CC WITH(NOLOCK) ' + char(10)
				SELECT @v_dSql += '	WHERE  ISO_YYYYWW = (SELECT ISO_YYYYWW FROM TH_UIS_CAL BB WITH(NOLOCK) WHERE YYYYMMDD = ''' + @param2 + ''') ' + char(10)
				SELECT @v_dSql += ') B ' + char(10)
				SELECT @v_dSql += 'WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
				SELECT @v_dSql += 'AND    A.SEGMENT1 = ''' + @param1 + ''' ' + char(10)

				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql

			END
		
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 find_fixTypeInit 정보갖고오기                                                                                      */
		/*   Param :@Param1	: INSTANCE_ID      																			                        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_fixTypeInit'
		    BEGIN
			     SELECT @v_dSql = ''
			     SELECT @v_dSql = ' SELECT A.INSTANCE_ID, A.KEY_ID, A.KEY_VALUE ' + char(10)
                 SELECT @v_dSql += ' FROM   FP_INSTANCE_CONFIG_M A               ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.CONFIG_SET_ID = ''LG_CHEM''        ' + char(10)
                 SELECT @v_dSql += ' AND    A.KEY_ID = ''FIX_DATE_TYPE''         ' + char(10)
                 SELECT @v_dSql += ' AND    A.INSTANCE_ID = '''+ @param1 +'''    ' + char(10)
				
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql

	        END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 findSyncOperationList 정보갖고오기                        */
		/*   Param :@Param1	:         																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findSyncOperationList'
		    BEGIN
			    SELECT @v_dSql = ''
			    SELECT @v_dSql = '  SELECT DISTINCT O.OPERATION_ID AS CODE, O.OPERATION_ID AS NAME           ' + char(10)
                SELECT @v_dSql += '  FROM   FP_INSTANCE_FACTORY_M FF, SCM_OPERATION_M O, SCM_FACTORY_M F      ' + char(10)
                SELECT @v_dSql += '  WHERE  FF.INSTANCE_TYPE = O.INSTANCE_TYPE                                ' + char(10)
                SELECT @v_dSql += '  AND	   FF.FACTORY_ID    = F.FACTORY_ID                                ' + char(10)
                SELECT @v_dSql += '  AND	   O.DIVISION_ID    = F.DIVISION_ID                               ' + char(10)
                SELECT @v_dSql += '  AND    FF.ACTIVE_FLAG   = ''Y''                                          ' + char(10)
                SELECT @v_dSql += '  AND    O.ACTIVE_FLAG    = ''Y''                                          ' + char(10)
                SELECT @v_dSql += '  AND    O.SYNC_FLAG      = ''Y''                                          ' + char(10)
                SELECT @v_dSql += '  AND    FF.INSTANCE_ID   = '''+ @param2 +'''                              ' + char(10)
                SELECT @v_dSql += '  AND    O.SITE_ID        = '''+ @param1 +'''                              ' + char(10)
                SELECT @v_dSql += '  ORDER BY O.OPERATION_ID DESC                                             ' + char(10)
				
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 findFixTargetList 정보갖고오기                                                                                     */
		/*    Param :@Param1	: INSTANCE_ID, 	@Param2	: PLAN_DATE	             																*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findFixTargetList'
		    BEGIN
			     SELECT @v_dSql = ''
			     SELECT @v_dSql = ' SELECT A.PLAN_ID AS COD                                                       ' + char(10)
                 SELECT @v_dSql += '   , A.PLAN_ID + '' ('' + A.PLAN_TYPE + '')'' AS  NAME                         ' + char(10)
                 SELECT @v_dSql += '   , A.RELEASE_FLAG As RELEASE_FLAG                                            ' + char(10)
                 SELECT @v_dSql += ' FROM (                                                                        ' + char(10)
                 SELECT @v_dSql += '      SELECT A.PLAN_ID, A.PLAN_TYPE, A.RELEASE_FLAG                            ' + char(10)
                 SELECT @v_dSql += '      FROM   SCM_FP_PLAN_H A(NOLOCK)                                           ' + char(10)
                 SELECT @v_dSql += '      WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                 ' + char(10)
                 SELECT @v_dSql += '       AND CONVERT(VARCHAR, A.PLAN_START_TIME, 112) = '''+ @param2 +'''        ' + char(10)
                 SELECT @v_dSql += '      UNION ALL                                                                ' + char(10)
                 SELECT @v_dSql += '      SELECT A.PLAN_ID, A.PLAN_TYPE, A.RELEASE_FLAG                            ' + char(10)
                 SELECT @v_dSql += '      FROM   SCM_FP_PLAN_H A(NOLOCK)                                           ' + char(10)
                 SELECT @v_dSql += '      WHERE  A.INSTANCE_ID ='''+ @param1 +'''                                  ' + char(10)
                 SELECT @v_dSql += '       AND   A.PLAN_TYPE   = ''RELEASE''                                       ' + char(10)
                 SELECT @v_dSql += '       AND   CONVERT(VARCHAR, A.PLAN_START_TIME, 112)                          ' + char(10)
                 SELECT @v_dSql += '         BETWEEN CONVERT(VARCHAR, CONVERT(DATETIME,'''+ @param2 +''')-3, 112)  ' + char(10)
                 SELECT @v_dSql += '         AND     CONVERT(VARCHAR, CONVERT(DATETIME, '''+ @param2 +''')-1, 112) ' + char(10)
                 SELECT @v_dSql += ' ) A                                                                           ' + char(10)
                 SELECT @v_dSql += ' ORDER BY PLAN_ID DESC                                                         ' + char(10)
				 
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		    END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 find_lookupByInstance 정보갖고오기                                                                                 */
		/*   Param :@Param1	: INSTANCE_ID, 	@Param2	: PLAN_DATE																		         	*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_lookupByInstance'
		    BEGIN
			     SELECT @v_dSql = ''
			     SELECT @v_dSql = ' SELECT A.SEGMENT1 AS INSTANCE_ID                           ' + char(10)
                 SELECT @v_dSql += '       ,A.SEGMENT2 AS INSTANCE_NAME                         ' + char(10)
                 SELECT @v_dSql += '       ,A.SEGMENT3 AS INSTANCE_SUB_CODE                     ' + char(10)
                 SELECT @v_dSql += '       ,A.SEGMENT4                                          ' + char(10)
                 SELECT @v_dSql += '       ,A.SEGMENT5                                          ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE1 AS CONFIRM_AREA                        ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE2 AS IS_SAME_PLAN_ID                     ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE3 AS USE_WOW_STATUS                      ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE4 AS CREATE_VD_MO                        ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE5 AS PSI_CAL_STATUS                      ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE6 AS MIN_FIX_DATE                        ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE7 AS DEFAULT_FIX_DATE                    ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE8 AS ALLOWED_FIX_DATE_NULL               ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE9 AS INSTANCE_TYPE                       ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE10 AS FIX_DATE_SYNC                      ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE11 AS FIRST_PLAN_CAPA_PLANNING           ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE12 AS SYNC_YN                            ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE13 AS ENGINE_PLAN_PER_WEEK               ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE14                                       ' + char(10)
                 SELECT @v_dSql += '       ,A.ATTRIBUTE15                                       ' + char(10)
                 SELECT @v_dSql += '       ,CONVERT(NUMERIC,A.ATTRIBUTE13)*7 AS PLAN_HORIZON    ' + char(10)
                 SELECT @v_dSql += '       ,CONVERT(NUMERIC,A.ATTRIBUTE13)*7 AS DEMAND_HORIZON  ' + char(10)
                 SELECT @v_dSql += '       ,'''+ @param2 +''' AS START_DATE                     ' + char(10)
                 SELECT @v_dSql += '       ,CONVERT(VARCHAR, DATEADD(DD, CONVERT(NUMERIC,A.ATTRIBUTE13)*7-1, CONVERT(DATE,'''+ @param2 +''')), 112) AS END_DATE  ' + char(10)
                 SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                 ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                ' + char(10)
                 SELECT @v_dSql += ' AND    A.SEGMENT1 = '''+ @param1 +'''                      ' + char(10)
				 
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			     exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 findEndRevision 정보갖고오기                                                                                 */
		/*   Param :@Param1	: INSTANCE_ID, 	@Param2	: PLAN_DATE																		         	*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findEndRevision'
		    BEGIN
			     SELECT @v_dSql = ''
			     SELECT @v_dSql = ' SELECT A.INSTANCE_ID, A.PLAN_ID, A.PLAN_TYPE, A.SITE_ID                      ' + char(10)
                 SELECT @v_dSql += '       ,CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) AS PLAN_START_TIME        ' + char(10)
                 SELECT @v_dSql += '       ,A.PLAN_HORIZON, A.DEMAND_HORIZON, A.CONFIG_SET_ID, A.BASIS_PLAN_ID    ' + char(10)
                 SELECT @v_dSql += '       ,A.PLAN_ID AS CODE, A.PLAN_ID AS NAME, A.DESCRIPTION                   ' + char(10)
                 SELECT @v_dSql += '       ,A.CONFIRM_ID, CONVERT(VARCHAR, A.CONFIRM_TIME, 120) AS CONFIRM_TIME   ' + char(10)
                 SELECT @v_dSql += '       ,A.INSERT_ID, CONVERT(VARCHAR, A.INSERT_TIME , 120) AS INSERT_TIME     ' + char(10)
                 SELECT @v_dSql += '       ,CONVERT(VARCHAR,A.PRE_FIX_DATE,112) AS PRE_FIX_DATE                   ' + char(10)
                 SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A(NOLOCK)                                               ' + char(10)
                 SELECT @v_dSql += ' 			,FP_PLAN_STATUS_H B(NOLOCK)                                       ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                     ' + char(10)
                 SELECT @v_dSql += ' AND    CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) = '''+ @param2 +'''       ' + char(10)
                 --SELECT @v_dSql += ' AND    A.PLAN_TYPE <> ''RELEASE''                                            ' + char(10)
				 SELECT @v_dSql += ' AND    A.PLAN_TYPE IN (''PRE'', ''SYNC'') ' + char(10) -- <> 조건 대신 IN 조건으로 변경
                 SELECT @v_dSql += ' AND    A.INSTANCE_ID    = B.INSTANCE_ID                                      ' + char(10)
                 SELECT @v_dSql += ' AND    A.PLAN_ID        = B.PLAN_ID                                          ' + char(10)
                 SELECT @v_dSql += ' AND    B.DB_TRANS_FLAG = ''C''                                               ' + char(10)
				 -- 배포버전 제외
                 SELECT @v_dSql += ' AND    A.PLAN_ID NOT IN (                                                    ' + char(10)
                 SELECT @v_dSql += ' 	SELECT PLAN_ID                                                            ' + char(10)
                 SELECT @v_dSql += ' 	FROM   HIS_FP_PLAN_DETAIL_H A WITH(NOLOCK)                                ' + char(10)
                 SELECT @v_dSql += ' 	WHERE  PLAN_DATE = ''' + @param2 + '''                                    ' + char(10)
                 SELECT @v_dSql += ' 	AND    INSTANCE_ID = ''' + @param1 + '''                                  ' + char(10)
                 SELECT @v_dSql += ' 	AND    RELEASE_FLAG = ''Y''                                               ' + char(10)
                 SELECT @v_dSql += ' 	UNION                                                                     ' + char(10)
                 SELECT @v_dSql += ' 	SELECT PLAN_ID                                                            ' + char(10)
                 SELECT @v_dSql += ' 	FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)                          ' + char(10)
                 SELECT @v_dSql += ' 	WHERE  PLAN_DATE = ''' + @param2 + '''                                    ' + char(10)
                 SELECT @v_dSql += ' 	AND    INSTANCE_ID = ''' + @param1 + '''                                  ' + char(10)
                 SELECT @v_dSql += ' 	AND    RELEASE_FLAG = ''Y''                                               ' + char(10)
                 SELECT @v_dSql += ' ) ' + char(10)
                 SELECT @v_dSql += ' ORDER BY CODE DESC                                                           ' + char(10)
				 
				 --Log 중요함으로 남긴다
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			     exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 find_getStepValid 정보갖고오기                                                                                 */
		/*   Param :@Param1	:STEP_ID,  @Param2	: INSTANCE_ID, 	@Param3	: PLAN_DATE													         	*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_getStepValid'
		    BEGIN
			    SELECT @v_dSql = ' SELECT ISNULL(MIN(A.CHECK_FLAG),''N'') AS CHECK_FLAG  ' + char(10)
                SELECT @v_dSql += ' FROM   FP_PLAN_PROG_CHK_H A WITH(NOLOCK)              ' + char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''              ' + char(10)
                SELECT @v_dSql += ' AND    A.PLAN_DATE   = '''+ @param2 +'''              ' + char(10)
                SELECT @v_dSql += ' AND    A.STEP_ID     = '''+ @param3 +'''              ' + char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG = ''Y''                          ' + char(10)
				
				--Log 중요함으로 남긴다
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 find_checkMasterInfo 정보갖고오기                                                                                     */
		/*   Param :@Param1	: INSTANCE_ID, 	@Param2	: PLAN_DATE,	@Param3	:STEP_ID												         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_checkMasterInfo'
		    BEGIN			      
				 SELECT @v_dSql =  ' SELECT A.INSTANCE_ID, C.INSTANCE_NAME, A.PLAN_ID                                 ' + char(10)
                 SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A WITH(NOLOCK)                                              ' + char(10)
                 SELECT @v_dSql += ' LEFT OUTER JOIN (                                                                ' + char(10)
                 SELECT @v_dSql += '   	SELECT A.SEGMENT1 AS INSTANCE_ID,A.SEGMENT2 AS INSTANCE_NAME                  ' + char(10)
                 SELECT @v_dSql += '   	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                    ' + char(10)
                 SELECT @v_dSql += '   	WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                   ' + char(10)
                 SELECT @v_dSql += '   	AND    A.ACTIVE_FLAG = ''Y''                                                  ' + char(10)
                 SELECT @v_dSql += ' ) C                                                                              ' + char(10)
                 SELECT @v_dSql += ' ON A.INSTANCE_ID = C.INSTANCE_ID                                                 ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                         ' + char(10)
                 SELECT @v_dSql += ' AND A.PLAN_ID  = '''+ @param1 +''' + ''-'' + '''+ @param2 +''' + ''-'' + ''00''  ' + char(10)
				 --setup 중인 활성화 동에 대해서 기준정보 체크 예외처리... 20250418
                 SELECT @v_dSql += ' UNION ALL ' + char(10)
                 SELECT @v_dSql += ' SELECT ''' + @param1 + ''' AS INSTANCE_ID, ''-'' AS INSTANCE_NAME, ''-'' AS PLAN_ID ' + char(10)
                 SELECT @v_dSql += ' FROM   ( ' + char(10)
                 SELECT @v_dSql += ' 	SELECT COUNT(*) AS CNT ' + char(10)
                 SELECT @v_dSql += ' 	FROM   SCM_SYS_LOOKUP_VALUE BB WITH(NOLOCK) ' + char(10)
                 SELECT @v_dSql += ' 	WHERE  BB.LOOKUP_TYPE_CODE = ''ABNORMAL_FACTORY'' ' + char(10)
                 SELECT @v_dSql += ' 	AND    BB.ACTIVE_FLAG = ''Y'' ' + char(10)
                 SELECT @v_dSql += ' 	AND    BB.SEGMENT1 IN ( ' + char(10)
                 SELECT @v_dSql += ' 		SELECT DISTINCT CC.FACTORY_ID ' + char(10)
                 SELECT @v_dSql += ' 		FROM   FP_INSTANCE_LINE_V CC WITH(NOLOCK) ' + char(10)
                 SELECT @v_dSql += ' 		WHERE  CC.INSTANCE_ID = ''' + @param1 + ''' ' + char(10)
                 SELECT @v_dSql += ' 	) ' + char(10)
                 SELECT @v_dSql += ' ) A ' + char(10)
                 SELECT @v_dSql += ' WHERE A.CNT > 0 ' + char(10)
				 
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			     exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 find_refInfo 정보갖고오기                                                                                          */
		/*   Param :@Param1	: SITE_ID,   @Param2	: INSTANCE_ID, @Param3	: PLAN_DATE                      					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_refInfo'
		    BEGIN	
		        SELECT @v_dSql =  '  SELECT SV.SEGMENT1 AS SITE_ID, SV.ATTRIBUTE1 AS PLAN_DATE                                    ' + char(10)
                SELECT @v_dSql += '      ,  (CASE WHEN '''+ @param3 +''' > SV.ATTRIBUTE1 THEN ''N'' ELSE ''Y'' END) AS IS_ENABLE  ' + char(10)
                SELECT @v_dSql += '  FROM   SCM_SYS_LOOKUP_VALUE SV WITH(NOLOCK)          ' + char(10)
                SELECT @v_dSql += '  WHERE  SV.LOOKUP_TYPE_CODE = ''AUTO_PLAN_CALL_FLAG''                                         ' + char(10)
                SELECT @v_dSql += '  AND    SV.ACTIVE_FLAG      = ''Y''                                                           ' + char(10)
                SELECT @v_dSql += '  AND    SV.SEGMENT1         = '''+ @param1 +'''                                               ' + char(10)
                SELECT @v_dSql += '  AND    SV.SEGMENT2 = (                                                                       ' + char(10)
                SELECT @v_dSql += '  	SELECT MAX(B.BASIS_START_TIME)                                                            ' + char(10)
                SELECT @v_dSql += '  	FROM   FP_INSTANCE_START_TIME_V B WITH(NOLOCK)                                            ' + char(10)
                SELECT @v_dSql += '  	WHERE  B.INSTANCE_ID = '''+ @param2 +'''                                                  ' + char(10)
                SELECT @v_dSql += '  )                                                                                            ' + char(10)
			    
				--print @v_dSql;
				--INSERT INTO TH_UIS_SQL VALUES ('@@@v_dSql',@p_code,@v_dSql , @param1, getdate() ) ;
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 find_isSaveAuth 정보갖고오기                                                                                          */
		/*   Param :@Param1	: INSTANCE_ID,   @Param2	: USERE_ID                                           					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_isSaveAuth'
		    BEGIN	
		        SELECT @v_dSql = ' SELECT COUNT(*) AS CNT                     ' + char(10)
                SELECT @v_dSql += ' FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)  ' + char(10)
                SELECT @v_dSql += ' WHERE  R.USER_ID     = '''+ @param2 +'''   ' + char(10)
                SELECT @v_dSql += ' AND    R.INSTANCE_ID = '''+ @param1 +'''   ' + char(10)
                SELECT @v_dSql += ' AND    R.SAVE_FLAG   = ''Y''               ' + char(10)
			    
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 find_formAging 정보갖고오기                                                                                          */
		/*   Param :@Param1	: SITE_ID,   @Param2	: PLAN_DATE                                           					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_formAging'
		    BEGIN	
                --SELECT @v_dSql = ' SELECT COUNT(*) AS CNT                                         ' + char(10)
				--setup 중인 활성화 동에 대해서 aging stock 체크 예외처리... 20250418
				SELECT @v_dSql = '' + char(10)
                SELECT @v_dSql += ' SELECT COUNT(*) ' + char(10)
                SELECT @v_dSql += ' 	 + (SELECT COUNT(*) ' + char(10)
                SELECT @v_dSql += ' 	 	FROM   SCM_SYS_LOOKUP_VALUE BB WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' 	 	WHERE  BB.LOOKUP_TYPE_CODE = ''ABNORMAL_FACTORY'' ' + char(10)
                SELECT @v_dSql += ' 	 	AND    BB.ACTIVE_FLAG = ''Y'' ' + char(10)
                SELECT @v_dSql += ' 	 	AND    BB.SEGMENT1 IN ( ' + char(10)
                SELECT @v_dSql += ' 	 		SELECT DISTINCT CC.FACTORY_ID ' + char(10)
                SELECT @v_dSql += ' 	 		FROM   FP_INSTANCE_LINE_V CC WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' 	 		WHERE  CC.INSTANCE_ID = ''' + @param3 + ''' ' + char(10)
                SELECT @v_dSql += ' 		) ' + char(10)
                SELECT @v_dSql += ' 	 ) AS CNT ' + char(10)
                
				SELECT @v_dSql += ' FROM   SCM_AGING_STOCK_H A                                     ' + char(10)
                SELECT @v_dSql += ' WHERE  A.SITE_ID = '''+ @param1 +'''                           ' + char(10)
                SELECT @v_dSql += ' AND    CONVERT(VARCHAR,A.CUTOFF_DATE,112) = '''+ @param2 +'''  ' + char(10)
			    
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590화면에서 findNewPlan 정보갖고오기                                                                                          */
		/*   Param :@Param1	: INSTANCE_ID,   @Param2	: PLAN_DATE                                           					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findNewPlan'
		    BEGIN	
			    SELECT @v_dSql  = ''
                SELECT @v_dSql  = ' SELECT CASE WHEN PLAN_ID = ''EMPTY'' THEN '''+ @param1 +''' + ''-'' + '''+ @param2 +''' + ''-01'' ' + char(10)
                SELECT @v_dSql += '        ELSE '''+ @param1 +''' + ''-'' + '''+ @param2 +''' + ''-''                                   ' + char(10)
                SELECT @v_dSql += '           + REPLICATE (''0'',2-LEN((CONVERT(NUMERIC, RIGHT((A.PLAN_ID), 2))+1))) + CAST ( (CONVERT(NUMERIC, RIGHT((A.PLAN_ID), 2))+1) AS VARCHAR )  ' + char(10)
                SELECT @v_dSql += '        END AS PLAN_ID ' + char(10)
                SELECT @v_dSql += ' FROM (                ' + char(10)
                SELECT @v_dSql += '   SELECT ISNULL(MAX(PLAN_ID), ''EMPTY'') AS PLAN_ID ' + char(10)
                SELECT @v_dSql += '   FROM   SCM_FP_PLAN_H A WITH(NOLOCK)               ' + char(10)
                SELECT @v_dSql += '   WHERE  A.INSTANCE_ID = '''+ @param1 +'''          ' + char(10)
                SELECT @v_dSql += '   AND  A.PLAN_TYPE <> ''RELEASE''                   ' + char(10)
                SELECT @v_dSql += '   AND  CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) = '''+ @param2 +''' ' + char(10)
                SELECT @v_dSql += ' ) A			     ' + char(10)
			   
			    --Log 중요함으로 남긴다
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 PlanInfo팝업화면에서 findPlanGroup 정보갖고오기                                                                                          */
		/*   Param :@Param1	: SITE_ID,   @Param2	: INSTANCE_ID                                           					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findPlanGroup'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql = '  SELECT b.instance_id, c.division_id, c.plant_id, c.factory_id    ' + char(10)
                 SELECT @v_dSql += ' FROM   fp_instance_factory_m b(NOLOCK), scm_factory_m c(NOLOCK)  ' + char(10)
                 SELECT @v_dSql += ' WHERE  b.factory_id = c.factory_id                               ' + char(10)
                 SELECT @v_dSql += ' AND    c.site_id     = '''+ @param1 +'''                         ' + char(10)
                 SELECT @v_dSql += ' AND    b.instance_id = '''+ @param2 +'''                         ' + char(10)
                 SELECT @v_dSql += ' GROUP BY b.instance_id, c.division_id, c.plant_id, c.factory_id  ' + char(10)
                 SELECT @v_dSql += ' ORDER BY b.instance_id, c.division_id, c.plant_id, c.factory_id  ' + char(10)
			    
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 PlanInfo팝업화면에서 findPlanInfo 정보갖고오기                                                                                          */
		/*   Param :@Param1	: INSTANCE_ID,   @Param2	: PLAN_ID       					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findPlanInfo'
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql =  ' SELECT A.INSTANCE_ID            ,A.PLAN_ID            ,A.PLAN_TYPE            ,A.SITE_ID      ' + char(10)
                SELECT @v_dSql += '     ,CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) AS PLAN_START_TIME                           ' + char(10)
                SELECT @v_dSql += '     ,CONVERT(VARCHAR(8), DATEADD(DAY,A.PLAN_HORIZON,A.PLAN_START_TIME), 112) AS PLAN_END_TIME ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_HORIZON          ,A.PLAN_HORIZON_UOM                                              ' + char(10)
                SELECT @v_dSql += '     ,A.DEMAND_HORIZON        ,A.DEMAND_HORIZON_UOM   ,A.CONFIG_SET_ID        ,A.BASIS_PLAN_ID ' + char(10)
                SELECT @v_dSql += '     ,A.DEMAND_PLAN_ID        ,A.SCP_PLAN_ID          ,A.PLAN_WEEK            ,A.CONFIRM_FLAG  ' + char(10)
                SELECT @v_dSql += '     ,A.DESCRIPTION           ,A.PRE_FIX_TARGET_ID, A.PRE_FIX_FLAG                             ' + char(10)
                SELECT @v_dSql += ' 	,CONVERT(VARCHAR,A.PRE_FIX_DATE,112) AS PRE_FIX_DATE                                      ' + char(10)
                SELECT @v_dSql += '     ,A.PRE_FIX_TYPE          ,CONVERT(VARCHAR,A.AMEND_FIX_DATE,112) AS AMEND_FIX_DATE         ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A WITH(NOLOCK)                                                           ' + char(10)
                SELECT @v_dSql += ' WHERE  A.PLAN_ID     = '''+ @param2 +'''                                                      ' + char(10)
                SELECT @v_dSql += ' AND    A.INSTANCE_ID = '''+ @param1 +'''                                                      ' + char(10)
			   
			    EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 Release Total 팝업화면에서 find_runValidationMaster 정보갖고오기                                                                  */
		/*   Param :@Param1	: PLAN_DATE                                           					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_runValidationMaster'
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += '  SELECT * FROM TH_LOG_HISTORY                           ' + char(10)
                SELECT @v_dSql += '  WHERE  PLAN_ID = ''VALIDATION_'' +  '''+ @param1 +'''  ' + char(10)
    	   
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 Release Total 팝업화면에서 find_is_running_release_bySite 정보갖고오기                                                                  */
		/*   Param :@Param1	: INSTANCE_ID,   @Param2	: PLAN_ID                                           					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_is_running_release_bySite'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += '  SELECT A.*                                                 ' + char(10)
                 SELECT @v_dSql += '       , CONVERT(VARCHAR, A.INSERT_TIME, 20) AS INSERT_DATE  ' + char(10)
               SELECT @v_dSql += '  FROM (                                                     ' + char(10)
                 SELECT @v_dSql += '  	SELECT A.*                                      ' + char(10)
                 SELECT @v_dSql += '  	  , ( SELECT MAX(SITE_ID)                                ' + char(10)
                 SELECT @v_dSql += '  		 FROM   FP_INSTANCE_INFO_V AA WITH(NOLOCK)           ' + char(10)
                 SELECT @v_dSql += '  		 WHERE  A.INSTANCE_ID = AA.INSTANCE_ID ) AS SITE_ID  ' + char(10)
                 SELECT @v_dSql += '  	, B.USER_NAME                                            ' + char(10)
                 SELECT @v_dSql += '  	FROM   FP_IS_RUNNING_RELEASE_H A WITH(NOLOCK)            ' + char(10)
                 SELECT @v_dSql += '  	LEFT OUTER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)        ' + char(10)
                 SELECT @v_dSql += '  	ON     A.INSERT_ID = B.USER_ID                           ' + char(10)
                 SELECT @v_dSql += '  	WHERE  A.ACTIVE_FLAG  = ''Y''                            ' + char(10)
                 SELECT @v_dSql += '  	AND    A.INSERT_TIME > DATEADD(MI, -15, GETDATE())       ' + char(10)-- 현재시각에 15분 안쪽에 도는게 있는지만 체크
                 SELECT @v_dSql += '  ) A                                                        ' + char(10)
                 SELECT @v_dSql += '  WHERE A.SITE_ID IN (                                       ' + char(10)
                 SELECT @v_dSql += '  	SELECT MAX(AAA.SITE_ID)                                  ' + char(10)
                 SELECT @v_dSql += '  	FROM   FP_INSTANCE_INFO_V AAA WITH(NOLOCK)               ' + char(10)
                 SELECT @v_dSql += '  	WHERE  AAA.INSTANCE_ID  = '''+ @param1 +'''              ' + char(10)
                 SELECT @v_dSql += '  )                                                          ' + char(10)
				 
				 --Log 중요함으로 남긴다
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend

				 exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 Release Total 팝업화면에서 find_is_running_release 정보갖고오기                                                                  */
		/*   Param :@Param1	: INSTANCE_ID,   @Param2	: PLAN_ID                                           					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_is_running_release'
		    BEGIN	
                SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.RELEASE_TYPE, A.FP_PLAN_ID                     ' + char(10)
                SELECT @v_dSql += '      , A.INSERT_ID, CONVERT(VARCHAR, A.INSERT_TIME, 20) AS INSERT_TIME ' + char(10)
                SELECT @v_dSql += ' FROM   FP_IS_RUNNING_RELEASE_H A WITH(NOLOCK)                          ' + char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID  = '''+ @param1 +'''                              ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.RELEASE_TYPE' , 'EQ', @param2))    + char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG  = ''Y''                                          ' + char(10)
				
				--Log 중요함으로 남긴다
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				--SELECT @v_dSql
				exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 Release Total 팝업화면에서 find_isConfirmed 정보갖고오기(=> Group은 FP00590_find_Group_isConfirmed 변경됨(동일이름이라서..) */
		/*   Param :@Param1	: SITE_ID,   @Param2	: INSTANCE_ID  @Param3	: PLAN_DATE                      					 	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_isConfirmed'
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql1  = ' SELECT B.INSTANCE_ID, B.DIVISION_ID, B.FACTORY_ID, B.PLAN_ID  ' + char(10)
                SELECT @v_dSql1 += ' FROM (             ' + char(10)

                SELECT @v_dSql2 = @param1 + '  ' + char(10)

                SELECT @v_dSql3 += '  ) A, (            ' + char(10)
                SELECT @v_dSql3 += '    SELECT DISTINCT INSTANCE_ID, DIVISION_ID, FACTORY_ID, PLAN_ID ' + char(10)
                SELECT @v_dSql3 += '    FROM HIS_FP_PLAN_DETAIL_H         ' + char(10)
                SELECT @v_dSql3 += '  ) B                                 ' + char(10)
                SELECT @v_dSql3 += '  WHERE A.INSTANCE_ID = B.INSTANCE_ID ' + char(10)
                SELECT @v_dSql3 += '  AND   A.DIVISION_ID = B.DIVISION_ID ' + char(10)
                SELECT @v_dSql3 += '  AND   A.FACTORY_ID  = B.FACTORY_ID  ' + char(10)
                SELECT @v_dSql3 += '  AND   A.PLAN_ID     = B.PLAN_ID     ' + char(10)

				SELECT @v_dSql  = @v_dSql1 + @v_dSql2 + @v_dSql3

				--Log 중요함으로 남긴다
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend

				exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 Group Release Total 팝업화면에서 find_Group_isConfirmed 정보갖고오기(동일이름이라서Group은 FP00590_find_Group_isConfirmed 변경됨 */
		/*   Param :@Param1	: SQL,   @Param2	: INSTANCE_ID  @Param3	: PLAN_DATE                      					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_Group_isConfirmed'
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql1  = ' SELECT B.INSTANCE_ID, A.DIVISION_ID, B.PLAN_GROUP_ID AS FACTORY_ID, B.PLAN_ID ' + char(10)
                SELECT @v_dSql1 += ' FROM (                                                                 ' + char(10)
														                                                    
                SELECT @v_dSql2 = @param1 + '                                                               ' + char(10)
														                                                    
                SELECT @v_dSql3 += '  ) A, (                                                                ' + char(10)
                SELECT @v_dSql3 += '    SELECT DISTINCT INSTANCE_ID, PLAN_GROUP_ID, PLAN_ID ' + char(10)
                SELECT @v_dSql3 += '    FROM HIS_FP_PLAN_GROUP_DETAIL_H                                     ' + char(10)
				SELECT @v_dSql3 += '    WHERE  INSTANCE_ID =  '''+ @param2 +'''                             ' + char(10)
				SELECT @v_dSql3 += '    AND   PLAN_DATE    =  '''+ @param3 +'''                             ' + char(10)
                SELECT @v_dSql3 += '  ) B                                                                   ' + char(10)
                SELECT @v_dSql3 += '  WHERE A.INSTANCE_ID = B.INSTANCE_ID                                   ' + char(10)
                SELECT @v_dSql3 += '  AND   A.FACTORY_ID  = B.PLAN_GROUP_ID                                 ' + char(10)
                SELECT @v_dSql3 += '  AND   A.PLAN_DATE   = B.PLAN_DATE                                     ' + char(10)

				SELECT @v_dSql  = @v_dSql1 + @v_dSql2 + @v_dSql3

				--Log 중요함으로 남긴다
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend

				exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 Release Total 팝업화면에서 find_isPast 정보갖고오기                                                                  */
		/*   Param :@Param1	: SITE_ID,   @Param2	: INSTANCE_ID  @Param3	: PLAN_DATE                            					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_isPast'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql  = '  SELECT '''+ @param3 +''' AS PLAN_DATE, CONVERT(VARCHAR,dbo.FN_SITE_TIME('''+ @param1 +'''),112) AS CURR_DATE, A.BASIS_START_TIME    ' + char(10)
                 SELECT @v_dSql += '       , CASE WHEN (FORMAT(dbo.FN_SITE_TIME('''+ @param1 +''') ,''yyyyMMddHHmmss'') >= ('''+ @param3 +''' + A.BASIS_START_TIME))   ' + char(10)
                 SELECT @v_dSql += '              AND  (FORMAT(dbo.FN_SITE_TIME('''+ @param1 +''') ,''yyyyMMddHHmmss'') < (CONVERT(VARCHAR,DATEADD(DD,1,'''+ @param3 +'''),112) + A.BASIS_START_TIME)) THEN ''Y'' ELSE ''N'' END AS DATE_VALID  ' + char(10)
                 SELECT @v_dSql += '  FROM   FP_INSTANCE_START_TIME_V A  ' + char(10)
                 SELECT @v_dSql += '  WHERE  A.INSTANCE_ID = '''+ @param2 +'''  ' + char(10)
				
				 --Log 중요함으로 남긴다
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 Release Total 팝업화면에서 find_dupReleaseCheck 정보갖고오기                                                                  */
		/*   Param :@Param1	: INSTANCE_ID,   @Param2	: FACTORY_ID                             					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_dupReleaseCheck'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.FACTORY_ID, A.PLAN_GROUP_ID, A.RELEASE_STATUS, ORDER_SEQ, USER_ID  ' + char(10)
                 SELECT @v_dSql += '      , CONVERT(VARCHAR,EVENT_TIME,20) AS EVENT_TIME  ' + char(10)
                 SELECT @v_dSql += '      , CONVERT(VARCHAR,CONFIRM_START,20) AS CONFIRM_START, CONVERT(VARCHAR,CONFIRM_END,20) AS CONFIRM_END  ' + char(10)
                 SELECT @v_dSql += '      , CONVERT(VARCHAR,RELEASE_START,20) AS RELEASE_START, CONVERT(VARCHAR,RELEASE_END,20) AS RELEASE_END  ' + char(10)
                 SELECT @v_dSql += ' FROM   FP_RELEASE_PLAN_STATUS_H A            ' + char(10)
                 SELECT @v_dSql += ' WHERE  INSTANCE_ID = '''+ @param1 +'''       ' + char(10)
                 SELECT @v_dSql += ' AND    FACTORY_ID  = '''+ @param2 +'''       ' + char(10)
                 SELECT @v_dSql += ' AND    RELEASE_STATUS IN (''RUN'',''WAIT'')  ' + char(10)

				  --Log 중요함으로 남긴다
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 Group Release Total 팝업화면에서 FP00590_find_dupGroupReleaseCheck 정보갖고오기                                                                  */
		/*   Param :@Param1	: INSTANCE_ID,   @Param2	: FACTORY_ID                          					         	    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_dupGroupReleaseCheck'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.FACTORY_ID, A.PLAN_GROUP_ID, A.RELEASE_STATUS, ORDER_SEQ, USER_ID  ' + char(10)
                 SELECT @v_dSql += '   , CONVERT(VARCHAR,EVENT_TIME,20) AS EVENT_TIME  ' + char(10)
                 SELECT @v_dSql += '      , CONVERT(VARCHAR,CONFIRM_START,20) AS CONFIRM_START, CONVERT(VARCHAR,CONFIRM_END,20) AS CONFIRM_END  ' + char(10)
                 SELECT @v_dSql += '      , CONVERT(VARCHAR,RELEASE_START,20) AS RELEASE_START, CONVERT(VARCHAR,RELEASE_END,20) AS RELEASE_END  ' + char(10)
                 SELECT @v_dSql += ' FROM   FP_RELEASE_PLAN_STATUS_H A            ' + char(10)
                 SELECT @v_dSql += ' WHERE  INSTANCE_ID = '''+ @param1 +'''       ' + char(10)
                 SELECT @v_dSql += ' AND    PLAN_GROUP_ID  = '''+ @param2 +'''    ' + char(10)
                 SELECT @v_dSql += ' AND    RELEASE_STATUS IN (''RUN'',''WAIT'')  ' + char(10)
				 
				 --Log 중요함으로 남긴다
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 Release Total 팝업화면에서 find_ReleasePlanList2 정보갖고오기                                                              */
		/*   Param :@Param1: SITE_ID,   @Param2: INSTANCE_ID,  @Param3: PLAN_DATE,  @Param4: PLAN_ID, @Param5: FACTORY_LT          		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_ReleasePlanList2'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql  = ' SELECT A.INSTANCE_ID, B.RELEASE_PLAN_ID AS PLAN_ID, A.FACTORY_ID    ' + char(10)
                 SELECT @v_dSql += ' FROM   HIS_FP_PLAN_DETAIL_H A WITH(NOLOCK)                          ' + char(10)
                 SELECT @v_dSql += ' INNER JOIN SCM_FP_PLAN_DETAIL_H B WITH(NOLOCK)                      ' + char(10)
                 SELECT @v_dSql += ' ON     A.PLAN_DATE    = B.PLAN_DATE                                 ' + char(10)
                 SELECT @v_dSql += ' AND    A.INSTANCE_ID  = B.INSTANCE_ID                               ' + char(10)
                 SELECT @v_dSql += ' AND    A.FACTORY_ID   = B.FACTORY_ID                                ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.PLAN_DATE    = '''+ @param3 +'''                           ' + char(10)
                 SELECT @v_dSql += ' AND    A.INSTANCE_ID  = '''+ @param2 +'''                           ' + char(10)
                 SELECT @v_dSql += ' AND    A.PLAN_ID      = '''+ @param4 +'''                           ' + char(10)
                 SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param5))    + char(10)

				  --Log 중요함으로 남긴다
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 Group Release Total 팝업화면에서 FP00590_find_GroupReleasePlanList2 정보갖고오기                                                              */
		/*   Param :@Param1: SITE_ID,   @Param2: INSTANCE_ID,  @Param3: PLAN_DATE,  @Param4: PLAN_ID, @Param5: FACTORY_LT          		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_GroupReleasePlanList2'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql  = ' SELECT A.INSTANCE_ID, B.RELEASE_PLAN_ID AS PLAN_ID,  A.PLAN_GROUP_ID AS FACTORY_ID    ' + char(10)
                 SELECT @v_dSql += ' FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)                    ' + char(10)
                 SELECT @v_dSql += ' INNER JOIN SCM_FP_PLAN_GROUP_DETAIL_H B WITH(NOLOCK)                ' + char(10)
            SELECT @v_dSql += ' ON     A.PLAN_DATE    = B.PLAN_DATE                                 ' + char(10)
                 SELECT @v_dSql += ' AND    A.INSTANCE_ID  = B.INSTANCE_ID                               ' + char(10)
                 SELECT @v_dSql += ' AND    A.PLAN_GROUP_ID   = B.PLAN_GROUP_ID                          ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.PLAN_DATE    = '''+ @param3 +'''                           ' + char(10)
                 SELECT @v_dSql += ' AND    A.INSTANCE_ID  = '''+ @param2 +'''                           ' + char(10)
                 SELECT @v_dSql += ' AND    A.PLAN_ID      = '''+ @param4 +'''                           ' + char(10)
                 SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLAN_GROUP_ID' , 'EQ', @param5))    + char(10)
				 
				  --Log 중요함으로 남긴다
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 --SELECT @v_dSql
				 exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 Release Total 팝업화면에서 find_ReleasePlanList 정보갖고오기                                                              */
		/*   Param :@Param1: SITE_ID,   @Param2: INSTANCE_ID,  @Param3: PLAN_DATE,  @Param4: PLAN_ID, @Param5: FACTORY_LT          		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_ReleasePlanList'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += ' SELECT B.RELEASE_PLAN_ID, B.FACTORY_ID, A.INSTANCE_ID               ' + char(10)
                 SELECT @v_dSql += ' FROM   HIS_FP_PLAN_DETAIL_H A WITH(NOLOCK)                          ' + char(10)
                 SELECT @v_dSql += ' INNER JOIN SCM_FP_PLAN_DETAIL_H B WITH(NOLOCK)                      ' + char(10)
                 SELECT @v_dSql += ' ON     A.PLAN_DATE    = B.PLAN_DATE                                 ' + char(10)
                 SELECT @v_dSql += ' AND    A.INSTANCE_ID  = B.INSTANCE_ID                               ' + char(10)
                 SELECT @v_dSql += ' AND    A.FACTORY_ID   = B.FACTORY_ID                                ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.PLAN_DATE    = '''+ @param3 +'''                           ' + char(10)
                 SELECT @v_dSql += ' AND    A.INSTANCE_ID  = '''+ @param2 +'''                           ' + char(10)
                 SELECT @v_dSql += ' AND    A.PLAN_ID      = '''+ @param4 +'''                           ' + char(10)
                 SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param5))    + char(10)

				  --Log 중요함으로 남긴다
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 Group Release Total 팝업화면에서 FP00590_find_GroupReleasePlanList 정보갖고오기                                                              */
		/*   Param :@Param1: SITE_ID,   @Param2: INSTANCE_ID,  @Param3: PLAN_DATE,  @Param4: PLAN_ID, @Param5: FACTORY_LT          		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_GroupReleasePlanList'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += ' SELECT B.RELEASE_PLAN_ID,B.PLAN_GROUP_ID AS FACTORY_ID, A.INSTANCE_ID  ' + char(10)
                 SELECT @v_dSql += ' FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)                       ' + char(10)
                 SELECT @v_dSql += ' INNER JOIN SCM_FP_PLAN_GROUP_DETAIL_H B WITH(NOLOCK)                   ' + char(10)
                 SELECT @v_dSql += ' ON     A.PLAN_DATE     = B.PLAN_DATE ' + char(10)
                 SELECT @v_dSql += ' AND    A.INSTANCE_ID   = B.INSTANCE_ID                                 ' + char(10)
                 SELECT @v_dSql += ' AND    A.PLAN_GROUP_ID = B.PLAN_GROUP_ID                               ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.PLAN_DATE     = '''+ @param3 +'''                             ' + char(10)
                 SELECT @v_dSql += ' AND    A.INSTANCE_ID   = '''+ @param2 +'''                             ' + char(10)
                 SELECT @v_dSql += ' AND    A.PLAN_ID       = '''+ @param4 +'''                             ' + char(10)
                 SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLAN_GROUP_ID' , 'EQ', @param5))    + char(10)

				  --Log 중요함으로 남긴다
				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 Release Total 팝업화면에서 find_watingTime 정보갖고오기                                                                    */
		/*   Param :@Param1: SITE_ID,   @Param2: FACTORY_LT                                                                      		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_watingTime'
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += '  SELECT A.DELAY_TIME                                                         ' + char(10)
                SELECT @v_dSql += '       , (CASE WHEN A.CNT = B.CNT THEN ''Y'' ELSE ''N'' END) AS CNT_MATCHING  ' + char(10)
                SELECT @v_dSql += '  FROM (                                                                      ' + char(10)
                SELECT @v_dSql += '  	SELECT COUNT(*)*5 AS DELAY_TIME, COUNT(*) AS CNT                         ' + char(10)
                SELECT @v_dSql += '  	FROM   FP_NETJOB_QUEUE A WITH(NOLOCK)                                    ' + char(10)
                SELECT @v_dSql += '  	WHERE  1=1                                                               ' + char(10)
                SELECT @v_dSql += '  	AND    PROC_NAME  = ''PR_SCM_OF_RELEASE_AUTO_PROCESSING''                ' + char(10)
                SELECT @v_dSql += '  	AND    PARAMETER4 = '''+ @param2 +'''                                    ' + char(10)
                SELECT @v_dSql += '  	AND    JOB_TYPE IN (''R'',''P'')                                         ' + char(10)
                SELECT @v_dSql += '  ) A, (                                                                      ' + char(10)
                SELECT @v_dSql += '  	SELECT COUNT(*) AS CNT                                                   ' + char(10)
                SELECT @v_dSql += '  	FROM   FP_NETJOB_QUEUE A WITH(NOLOCK)                                    ' + char(10)
                SELECT @v_dSql += '  	WHERE  1=1                                                               ' + char(10)
                SELECT @v_dSql += '  	AND    PROC_NAME  = ''PR_SCM_OF_RELEASE_AUTO_PROCESSING''                ' + char(10)
                SELECT @v_dSql += '  	AND    PARAMETER4 = '''+ @param2 +'''                                    ' + char(10)
                SELECT @v_dSql += '  	AND    JOB_TYPE IN (''R'',''P'')                                         ' + char(10)
                SELECT @v_dSql += '  	AND    PARAMETER1 = '''+ @param1 +'''                                    ' + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PARAMETER5' , 'EQ', @param2))    + char(10)
         SELECT @v_dSql += '  ) B                                                                         ' + char(10)

				--Log 중요함으로 남긴다
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 WoWStatus 팝업화면에서 FP00590_find_currStageInfo 정보갖고오기                                                              */
		/*   Param :@Param1: INSTANCE_ID,   @Param2: PLAN_DATE,           		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_currStageInfo'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += '  SELECT B.SCP_PLAN_ID, B.SCP_PLAN_TIME                                                               ' + char(10)
                 SELECT @v_dSql += '       , MAX(A.DATE_SEQ) AS DATE_SEQ                                                                  ' + char(10)
                 SELECT @v_dSql += '       , MAX(A.DESCRIPTION) AS DESCRIPTION                                                            ' + char(10)
                 SELECT @v_dSql += '       , MAX(A.DRAFT_PLAN_ID) AS DRAFT_PLAN_ID                                                        ' + char(10)
                 SELECT @v_dSql += '       , MAX(A.SYNC_PLAN_ID) AS SYNC_PLAN_ID                                                          ' + char(10)
                 SELECT @v_dSql += '       , (CASE WHEN MAX(C.SCP_PLAN_ID) IS NULL THEN ''N'' ELSE ''Y'' END) AS IS_SCP_PLAN_SELECTED     ' + char(10)
                 SELECT @v_dSql += '  FROM   FP_PLAN_PROG_CHK_H A WITH(NOLOCK)                                                            ' + char(10)
                 SELECT @v_dSql += '  INNER JOIN (                                                                                        ' + char(10)
                 SELECT @v_dSql += '      SELECT MAX(SCP_PLAN_ID) AS SCP_PLAN_ID, CONVERT(VARCHAR, MAX(INSERT_TIME), 20) AS SCP_PLAN_TIME ' + char(10)
                 SELECT @v_dSql += '      FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK)                                                ' + char(10)
                 SELECT @v_dSql += '  ) B                                                                                                 ' + char(10)
                 SELECT @v_dSql += '  ON 1=1                                                                                              ' + char(10)
                 SELECT @v_dSql += '  LEFT OUTER JOIN (                                                                                   ' + char(10)
                 SELECT @v_dSql += '      SELECT SCP_PLAN_ID                                                                              ' + char(10)
                 SELECT @v_dSql += '      FROM   SCM_FP_PLAN_H BB WITH(NOLOCK)                                                            ' + char(10)
                 SELECT @v_dSql += '      WHERE  BB.INSTANCE_ID = '''+ @param1 +'''                                                       ' + char(10)
                 SELECT @v_dSql += '      AND    CONVERT(VARCHAR,BB.PLAN_START_TIME,112) = '''+ @param2 +'''                              ' + char(10)
                 SELECT @v_dSql += '  ) C                                                                                                 ' + char(10)
                 SELECT @v_dSql += '  ON     B.SCP_PLAN_ID = C.SCP_PLAN_ID                                                                ' + char(10)
                 SELECT @v_dSql += '  WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                                            ' + char(10)
                 SELECT @v_dSql += '  AND    A.PLAN_DATE   = '''+ @param2 +'''                                                       ' + char(10)
                 SELECT @v_dSql += '  AND    A.ACTIVE_FLAG = ''Y''           ' + char(10)
                 SELECT @v_dSql += '  GROUP BY B.SCP_PLAN_ID, B.SCP_PLAN_TIME                                                             ' + char(10)

				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 WoWStatus 팝업화면에서 find_prePlanList 정보갖고오기                                                              */
		/*   Param :@Param1: INSTANCE_ID,   @Param2: PLAN_DATE,           		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_prePlanList'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += ' SELECT PLAN_ID AS CODE, PLAN_ID AS NAME, A.DESCRIPTION               ' + char(10)
                 SELECT @v_dSql += '      , A.INSERT_ID, B.USER_NAME                                      ' + char(10)
                 SELECT @v_dSql += '      , CONVERT(VARCHAR,A.INSERT_TIME,20) AS INSERT_TIME              ' + char(10)
                 SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A WITH(NOLOCK)                                  ' + char(10)
                 SELECT @v_dSql += ' LEFT OUTER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)                    ' + char(10)
                 SELECT @v_dSql += ' ON     A.INSERT_ID   = B.USER_ID                                     ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                             ' + char(10)
                 SELECT @v_dSql += ' AND    CONVERT(VARCHAR, A.PLAN_START_TIME, 112) = '''+ @param2 +'''  ' + char(10)
                 SELECT @v_dSql += ' AND    A.PLAN_TYPE = ''PRE''                                         ' + char(10)
                 SELECT @v_dSql += ' ORDER BY CODE                                                        ' + char(10)

				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 WoWStatus 팝업화면에서 find_syncPlanList 정보갖고오기                                                              */
		/*   Param :@Param1: INSTANCE_ID,   @Param2: PLAN_DATE,           		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_syncPlanList'
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += ' SELECT PLAN_ID AS CODE, PLAN_ID AS NAME, A.DESCRIPTION               ' + char(10)
                 SELECT @v_dSql += '      , A.INSERT_ID, B.USER_NAME                                      ' + char(10)
                 SELECT @v_dSql += '      , CONVERT(VARCHAR,A.INSERT_TIME,20) AS INSERT_TIME              ' + char(10)
                 SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A WITH(NOLOCK)                                  ' + char(10)
                 SELECT @v_dSql += ' LEFT OUTER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)                    ' + char(10)
                 SELECT @v_dSql += ' ON     A.INSERT_ID   = B.USER_ID                                     ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                             ' + char(10)
                 SELECT @v_dSql += ' AND    CONVERT(VARCHAR, A.PLAN_START_TIME, 112) = '''+ @param2 +'''  ' + char(10)
 SELECT @v_dSql += ' AND    A.PLAN_TYPE = ''SYNC''                                        ' + char(10)
				 SELECT @v_dSql += ' AND    A.BASIS_PLAN_ID = '''+ @param3 +'''                           ' + char(10)
                 SELECT @v_dSql += ' ORDER BY CODE                                                        ' + char(10)

				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END	
		/****************************************************************************************************************************************/
		/*   FP00590 WoWStatus 팝업화면에서 FP00590_find_WoWHeaderInfo 정보갖고오기                                                              */
		/*   Param :@Param1: INSTANCE_ID,   @Param2: PLAN_DATE,           		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_WoWHeaderInfo'
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += '  SELECT A.PLAN_GROUP_ID, DENSE_RANK() OVER( ORDER BY A.PLAN_GROUP_ID DESC) LV, COUNT(*) CNT  ' + char(10)
                SELECT @v_dSql += '  FROM   FP_PLAN_GROUP_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '  LEFT OUTER JOIN (                     ' + char(10)
                SELECT @v_dSql += '      SELECT A.INSTANCE_ID              ' + char(10)
                SELECT @v_dSql += '           , A.USER_ID                  ' + char(10)
                SELECT @v_dSql += '           , A.PLAN_GROUP_ID            ' + char(10)
                SELECT @v_dSql += '           , A.USER_GROUP_ID            ' + char(10)
                SELECT @v_dSql += '      FROM (                            ' + char(10)
                SELECT @v_dSql += '          SELECT A.*                    ' + char(10)
                SELECT @v_dSql += '               , ROW_NUMBER() OVER( PARTITION BY A.PLAN_GROUP_ID, A.USER_GROUP_ID, A.USER_ID ' + char(10)
                SELECT @v_dSql += '                     ORDER BY     A.PLAN_GROUP_ID, A.USER_GROUP_ID, A.USER_ID ) AS ROW_NUM   ' + char(10)
                SELECT @v_dSql += '          FROM   FP_USER_LINE_GROUP_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '          WHERE  A.INSTANCE_ID =  '''+ @param1 +'''  ' + char(10)
                SELECT @v_dSql += '          AND    A.ACTIVE_FLAG = ''Y''               ' + char(10)
                SELECT @v_dSql += '      ) A                                            ' + char(10)
                SELECT @v_dSql += '      INNER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)   ' + char(10)
                SELECT @v_dSql += '      ON    A.USER_ID = B.USER_ID             ' + char(10)
                SELECT @v_dSql += '      WHERE A.ROW_NUM = 1                     ' + char(10)
                SELECT @v_dSql += '  ) B                                         ' + char(10)
                SELECT @v_dSql += '  ON     A.INSTANCE_ID   = B.INSTANCE_ID      ' + char(10)
                SELECT @v_dSql += '  AND    A.PLAN_GROUP_ID = B.PLAN_GROUP_ID    ' + char(10)
                SELECT @v_dSql += '  AND    A.USER_GROUP_ID = B.USER_GROUP_ID    ' + char(10)
                SELECT @v_dSql += '  WHERE  A.INSTANCE_ID   = '''+ @param1 +'''  ' + char(10)
                SELECT @v_dSql += '  AND    A.ACTIVE_FLAG   = ''Y''              ' + char(10)
                SELECT @v_dSql += '  GROUP BY A.PLAN_GROUP_ID                    ' + char(10)

				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 WoWStatus 팝업화면에서 FP00590_find_WoWHeaderTitle 정보갖고오기                                                              */
		/*   Param :@Param1: INSTANCE_ID,   @Param2: PLAN_DATE,           		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_WoWHeaderTitle'
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT MAX(CASE WHEN C.COL_NUM = 1  THEN C.USER_ID END)  USER01  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 2  THEN C.USER_ID END)  USER02  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 3  THEN C.USER_ID END)  USER03  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 4  THEN C.USER_ID END)  USER04  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 5  THEN C.USER_ID END)  USER05  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 6  THEN C.USER_ID END)  USER06  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 7  THEN C.USER_ID END)  USER07  ' + char(10)
                SELECT @v_dSql += ' 	,  MAX(CASE WHEN C.COL_NUM = 8  THEN C.USER_ID END)  USER08  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 9  THEN C.USER_ID END)  USER09  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 10 THEN C.USER_ID END)  USER10  ' + char(10)
                SELECT @v_dSql += ' 	,  MAX(CASE WHEN C.COL_NUM = 11 THEN C.USER_ID END)  USER11  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 12 THEN C.USER_ID END)  USER12  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 13 THEN C.USER_ID END)  USER13  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 14 THEN C.USER_ID END)  USER14  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 15 THEN C.USER_ID END)  USER15  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 16 THEN C.USER_ID END)  USER16  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 17 THEN C.USER_ID END)  USER17  ' + char(10)
                SELECT @v_dSql += ' 	,  MAX(CASE WHEN C.COL_NUM = 18 THEN C.USER_ID END)  USER18  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 19 THEN C.USER_ID END)  USER19  ' + char(10)
                SELECT @v_dSql += '     ,  MAX(CASE WHEN C.COL_NUM = 20 THEN C.USER_ID END)  USER20  ' + char(10)
                SELECT @v_dSql += ' FROM (                      ' + char(10)
                SELECT @v_dSql += ' 	  SELECT A.INSTANCE_ID  ' + char(10)
                SELECT @v_dSql += ' 		, A.PLAN_GROUP_ID, A.PLAN_GROUP_DESC  ' + char(10)
                SELECT @v_dSql += ' 		, A.USER_GROUP_ID, A.USER_GROUP_DESC  ' + char(10)
                SELECT @v_dSql += ' 		, DENSE_RANK() OVER( ORDER BY A.PLAN_GROUP_ID DESC) AS LV1                        ' + char(10)
                SELECT @v_dSql += ' 		, ROW_NUMBER() OVER( ORDER BY A.PLAN_GROUP_ID DESC, A.USER_GROUP_ID ) AS COL_NUM  ' + char(10)
                SELECT @v_dSql += ' 		, B.USER_ID, B.USER_NAME             ' + char(10)
                SELECT @v_dSql += '       FROM   FP_PLAN_GROUP_M A WITH(NOLOCK)  ' + char(10)
                SELECT @v_dSql += '       LEFT OUTER JOIN (         ' + char(10)
                SELECT @v_dSql += '           SELECT A.INSTANCE_ID  ' + char(10)
                SELECT @v_dSql += '                , A.USER_ID, ISNULL(B.USER_NAME,''-'') AS USER_NAME  ' + char(10)
                SELECT @v_dSql += '                , A.PLAN_GROUP_ID  ' + char(10)
                SELECT @v_dSql += '                , A.USER_GROUP_ID  ' + char(10)
                SELECT @v_dSql += '           FROM (          ' + char(10)
                SELECT @v_dSql += '               SELECT A.*  ' + char(10)
 SELECT @v_dSql += '                    , ROW_NUMBER() OVER( PARTITION BY A.PLAN_GROUP_ID, A.USER_GROUP_ID, A.USER_ID               ' + char(10)
                SELECT @v_dSql += '                                         ORDER BY     A.PLAN_GROUP_ID, A.USER_GROUP_ID, A.USER_ID ) AS ROW_NUM  ' + char(10)
                SELECT @v_dSql += '               FROM   FP_USER_LINE_GROUP_M A WITH(NOLOCK)  ' + char(10)
                SELECT @v_dSql += '               WHERE  A.INSTANCE_ID =  '''+ @param1 +'''   ' + char(10)
                SELECT @v_dSql += '               AND    A.ACTIVE_FLAG = ''Y''                ' + char(10)
                SELECT @v_dSql += '           ) A                                             ' + char(10)
                SELECT @v_dSql += '           INNER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += '           ON    A.USER_ID = B.USER_ID  ' + char(10)
                SELECT @v_dSql += '           WHERE A.ROW_NUM = 1          ' + char(10)
                SELECT @v_dSql += '       ) B                              ' + char(10)
                SELECT @v_dSql += '       ON     A.INSTANCE_ID   = B.INSTANCE_ID      ' + char(10)
                SELECT @v_dSql += '       AND    A.PLAN_GROUP_ID = B.PLAN_GROUP_ID    ' + char(10)
                SELECT @v_dSql += '       AND    A.USER_GROUP_ID = B.USER_GROUP_ID    ' + char(10)
                SELECT @v_dSql += '       WHERE  A.INSTANCE_ID   = '''+ @param1 +'''  ' + char(10)
                SELECT @v_dSql += '       AND    A.ACTIVE_FLAG   = ''Y''              ' + char(10)
                SELECT @v_dSql += ' 	  ) C  ' + char(10)

				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 WoWStatus 팝업화면에서 FP00590_find_Map 정보갖고오기                                                              */
		/*   Param :@Param1: INSTANCE_ID,   @Param2: PLAN_DATE,           		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_Map' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' WITH _ROW AS ( ' + char(10)
                SELECT @v_dSql += '     SELECT A.SEGMENT1 AS STEP_ID, A.SEGMENT2 AS STEP_DESC, CONVERT(NUMERIC, A.SEGMENT3) AS STEP_SEQ, A.SEGMENT4 AS ROLE_ID ' + char(10)
                SELECT @v_dSql += '          , A.SEGMENT5 AS USE_WOW_STATUS ' + char(10)
                SELECT @v_dSql += '     FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '     WHERE  A.LOOKUP_TYPE_CODE = ''PLAN_PROGRESS_CHK'' ' + char(10)
                SELECT @v_dSql += '     AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
                SELECT @v_dSql += ' ) ' + char(10)
                SELECT @v_dSql += ' , _COL AS ( ' + char(10)
                SELECT @v_dSql += '     SELECT A.INSTANCE_ID ' + char(10)
                SELECT @v_dSql += '          , A.PLAN_GROUP_ID, A.PLAN_GROUP_DESC ' + char(10)
                SELECT @v_dSql += '          , A.USER_GROUP_ID, A.USER_GROUP_DESC ' + char(10)
                SELECT @v_dSql += '     FROM   FP_PLAN_GROUP_M A WITH(NOLOCK)     ' + char(10)
                SELECT @v_dSql += '     WHERE  A.INSTANCE_ID = '''+ @param1 +'''  ' + char(10)
                SELECT @v_dSql += '     AND    A.ACTIVE_FLAG = ''Y''              ' + char(10)
                SELECT @v_dSql += ' ) ' + char(10)
                SELECT @v_dSql += ' , _PG1 AS ( ' + char(10)
                SELECT @v_dSql += '     SELECT A.*, ''ROW'' + CONVERT(VARCHAR,ROW_NUM) AS ROW_VALUE    ' + char(10)
                SELECT @v_dSql += '     FROM ( ' + char(10)
                SELECT @v_dSql += '  SELECT ROW.STEP_ID, ROW.STEP_DESC, ROW.STEP_SEQ, ROW.ROLE_ID ' + char(10)
                SELECT @v_dSql += '            , (CASE WHEN ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE COL.PLAN_GROUP_ID END) AS PLAN_GROUP_ID     ' + char(10)
                SELECT @v_dSql += '            , (CASE WHEN ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE COL.PLAN_GROUP_DESC END) AS PLAN_GROUP_DESC ' + char(10)
                SELECT @v_dSql += '            , ROW.STEP_SEQ AS ROW_NUM ' + char(10)
                SELECT @v_dSql += '       FROM _ROW AS ROW, _COL AS COL  ' + char(10)
                SELECT @v_dSql += '       GROUP BY ROW.STEP_ID, ROW.STEP_DESC, ROW.STEP_SEQ, ROW.ROLE_ID ' + char(10)
                SELECT @v_dSql += '               ,(CASE WHEN ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE COL.PLAN_GROUP_ID END)   ' + char(10)
                SELECT @v_dSql += '               ,(CASE WHEN ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE COL.PLAN_GROUP_DESC END) ' + char(10)
                SELECT @v_dSql += '     ) A ' + char(10)
                SELECT @v_dSql += ' )       ' + char(10)
                SELECT @v_dSql += ' SELECT  A.STEP_ID, A.STEP_DESC, A.STEP_SEQ, A.ROLE_ID, A.PLAN_GROUP_ID             ' + char(10)
                SELECT @v_dSql += '      , A.PLAN_GROUP_DESC, A.ROW_NUM, A.ROW_VALUE, A.USER_GROUP_ID                  ' + char(10)
                SELECT @v_dSql += '      , A.COL_NUM COL_NUM, ''COL'' + CONVERT(VARCHAR, A.COL_NUM) AS COL_VALUE       ' + char(10)
                SELECT @v_dSql += '      , ROW_NUMBER( ) OVER( ORDER BY A.ROW_NUM, A.COL_NUM ) AS CELL_NUM             ' + char(10)
                SELECT @v_dSql += '      , A.ROW_VALUE + ''_'' + (''COL'' + CONVERT(VARCHAR, A.COL_NUM)) AS CELL_VALUE ' + char(10)
                SELECT @v_dSql += ' FROM (                     ' + char(10)
                SELECT @v_dSql += '     SELECT A.*             ' + char(10)
                SELECT @v_dSql += '          , B.USER_GROUP_ID ' + char(10)
                SELECT @v_dSql += '          , ROW_NUMBER( ) OVER( PARTITION BY A.STEP_SEQ ORDER BY A.STEP_SEQ, B.USER_GROUP_ID ) AS COL_NUM ' + char(10)
                SELECT @v_dSql += '     FROM   _PG1 A, ( ' + char(10)
                SELECT @v_dSql += '           SELECT _ROW.STEP_ID, _ROW.STEP_DESC, _ROW.STEP_SEQ, _ROW.ROLE_ID ' + char(10)
                SELECT @v_dSql += '                , (CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.PLAN_GROUP_ID END) AS PLAN_GROUP_ID ' + char(10)
                SELECT @v_dSql += '                , (CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.USER_GROUP_ID END) AS USER_GROUP_ID ' + char(10)
                SELECT @v_dSql += '                , (CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.USER_GROUP_DESC END) AS USER_GROUP_DESC ' + char(10)
                SELECT @v_dSql += '           FROM _ROW, _COL ' + char(10)
                SELECT @v_dSql += '           GROUP BY _ROW.STEP_ID, _ROW.STEP_DESC, _ROW.STEP_SEQ, _ROW.ROLE_ID                ' + char(10)
                SELECT @v_dSql += '             ,(CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.PLAN_GROUP_ID END)   ' + char(10)
                SELECT @v_dSql += '             ,(CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.USER_GROUP_ID END)   ' + char(10)
                SELECT @v_dSql += '             ,(CASE WHEN _ROW.ROLE_ID = ''MASTER'' THEN ''-'' ELSE _COL.USER_GROUP_DESC END) ' + char(10)
                SELECT @v_dSql += '     ) B ' + char(10)
                SELECT @v_dSql += '     WHERE A.STEP_ID = B.STEP_ID ' + char(10)
                SELECT @v_dSql += '     AND   A.PLAN_GROUP_ID = B.PLAN_GROUP_ID ' + char(10)
                SELECT @v_dSql += ' ) A ' + char(10)
                SELECT @v_dSql += ' ORDER BY CELL_NUM ' + char(10)

				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 WoWStatus 팝업화면에서 FP00590_findDataCheck 정보갖고오기                                                              */
		/*   Param :@Param1: INSTANCE_ID,   @Param2: PLAN_DATE,           		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_findDataCheck' 
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += ' SELECT A.STEP_ID, '''' STEP_DESC, '''' STEP_SEQ, '''' ROLE_ID ' + char(10)
				 SELECT @v_dSql += '   ,  A.INSTANCE_ID, A.PLAN_DATE ' + char(10)
                 SELECT @v_dSql += '   , A.SCP_PLAN_ID, A.DRAFT_PLAN_ID, A.SYNC_PLAN_ID ' + char(10)
                 SELECT @v_dSql += '   , A.CHECK_FLAG , A.DESCRIPTION ' + char(10)
                 SELECT @v_dSql += '   , A.UPDATE_ID As USER_ID, B.USER_NAME+''(''+ A.UPDATE_ID+'')'' As JOB_USER_ID ' + char(10)
                 SELECT @v_dSql += '   , CONVERT(VARCHAR,A.UPDATE_TIME,20) AS JOB_TIME  ' + char(10)
                 SELECT @v_dSql += '   , CAST(SUBSTRING(A.STEP_ID,5,2) AS INT) STEP_SEQ ' + char(10)
                 SELECT @v_dSql += '   , DENSE_RANK() OVER(  PARTITION BY A.INSTANCE_ID,A.PLAN_DATE, A.STEP_ID  ' + char(10)
				 SELECT @v_dSql += '    ORDER BY A.INSTANCE_ID,A.PLAN_DATE, A.STEP_ID, A.USER_GROUP_ID  ASC) LV ' + char(10)
                 SELECT @v_dSql += ' FROM   FP_PLAN_PROG_CHK_H A WITH(NOLOCK)          ' + char(10)
                 SELECT @v_dSql += ' LEFT OUTER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK) ' + char(10)
                 SELECT @v_dSql += ' ON     A.UPDATE_ID   = B.USER_ID         ' + char(10)
                 SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                 SELECT @v_dSql += ' AND    A.PLAN_DATE   = '''+ @param2 +''' ' + char(10)
                 SELECT @v_dSql += ' AND    A.ACTIVE_FLAG = ''Y''             ' + char(10)

				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 WoWStatus 팝업화면에서 FP00590_find_CurrSeq 정보갖고오기                                                              */
		/*   Param :@Param1: INSTANCE_ID,   @Param2: PLAN_DATE,           		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_CurrSeq' 
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += '  SELECT MIN(ISNULL(ACTIVE_FLAG,''N'')) AS ACTIVE_FLAG ' + char(10)
                 SELECT @v_dSql += '  FROM   FP_PLAN_PROG_CHK_H A WITH(NOLOCK)             ' + char(10)
                 SELECT @v_dSql += '  WHERE  A.INSTANCE_ID = '''+ @param1 +'''             ' + char(10)
                 SELECT @v_dSql += '  AND    A.PLAN_DATE   = '''+ @param2 +'''             ' + char(10)
                 SELECT @v_dSql += '  AND    A.DATE_SEQ    = '''+ @param3 +'''             ' + char(10)

				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 WoWStatus 팝업화면에서 FP00590_find_currChk 정보갖고오기                                                              */
		/*   Param :@Param1: INSTANCE_ID,   @Param2: PLAN_DATE,           		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_currChk' 
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += ' SELECT ISNULL(CHECK_FLAG,''N'') AS CHECK_FLAG  ' +char(10)
                 SELECT @v_dSql += ' FROM   FP_PLAN_PROG_CHK_H A WITH(NOLOCK)	    ' +char(10)
             SELECT @v_dSql += ' WHERE  INSTANCE_ID   = '''+ @param1 +'''       ' +char(10)
                 SELECT @v_dSql += ' AND    PLAN_DATE     = '''+ @param2 +'''       ' +char(10)
                 SELECT @v_dSql += ' AND    DATE_SEQ      = '''+ @param4 +'''       ' +char(10)
                 SELECT @v_dSql += ' AND    STEP_ID       = '''+ @param3 +'''	    ' +char(10)
                 SELECT @v_dSql += ' AND    USER_GROUP_ID = '''+ @param5 +'''	    ' +char(10)

				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 WoWStatus 팝업화면에서 FP00590_find_currUpperChk 정보갖고오기                                                              */
		/*   Param :@Param1: INSTANCE_ID,   @Param2: PLAN_DATE,           		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_currUpperChk' 
		    BEGIN	
			     SELECT @v_dSql = ''
                 SELECT @v_dSql += ' WITH _STP AS (                                                         ' +char(10)
                 SELECT @v_dSql += '   SELECT CONVERT(NUMERIC, A.SEGMENT3) AS STEP_SEQ                      ' +char(10)
                 SELECT @v_dSql += '   FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                           ' +char(10)
                 SELECT @v_dSql += '   WHERE  A.LOOKUP_TYPE_CODE = ''PLAN_PROGRESS_CHK''                    ' +char(10)
                 SELECT @v_dSql += '   AND    A.SEGMENT1 = '''+ @param3 +'''                                ' +char(10)
                 SELECT @v_dSql += '   AND    A.ACTIVE_FLAG = ''Y''                                         ' +char(10)
                 SELECT @v_dSql += ' )                                                                      ' +char(10)
                 SELECT @v_dSql += ' , _UPPER_STEP AS (                                                     ' +char(10)
                 SELECT @v_dSql += '   SELECT A.STEP_ID                                                     ' +char(10)
                 SELECT @v_dSql += '   FROM (                                                               ' +char(10)
                 SELECT @v_dSql += '     SELECT A.SEGMENT1 AS STEP_ID, A.SEGMENT2 AS STEP_DESC              ' +char(10)
				 SELECT @v_dSql += '     , CONVERT(NUMERIC, A.SEGMENT3) AS STEP_SEQ, A.SEGMENT4 AS ROLE_ID  ' +char(10)
                 SELECT @v_dSql += '          ,(CASE WHEN B.STEP_SEQ <= CONVERT(NUMERIC, A.SEGMENT3)        ' +char(10)
				 SELECT @v_dSql += '            THEN ''N'' ELSE ''Y'' END) AS YN                            ' +char(10)
                 SELECT @v_dSql += '     FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK), _STP B                 ' +char(10)
                 SELECT @v_dSql += '     WHERE  A.LOOKUP_TYPE_CODE = ''PLAN_PROGRESS_CHK''                  ' +char(10)
                 SELECT @v_dSql += '     AND    A.ACTIVE_FLAG = ''Y''                                       ' +char(10)
                 SELECT @v_dSql += '   ) A                                                                  ' +char(10)
                 SELECT @v_dSql += '   WHERE A.YN = ''Y''                                                   ' +char(10)
                 SELECT @v_dSql += ' )                                                                      ' +char(10)
                 SELECT @v_dSql += ' SELECT MIN(ISNULL(A.CHECK_FLAG,''N'')) AS CHECK_FLAG                   ' +char(10)
                 SELECT @v_dSql += ' FROM   FP_PLAN_PROG_CHK_H A WITH(NOLOCK)                               ' +char(10)
                 SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                               ' +char(10)
                 SELECT @v_dSql += ' AND    A.PLAN_DATE   = '''+ @param2 +'''                               ' +char(10)
                 SELECT @v_dSql += ' AND    A.DATE_SEQ    = '''+ @param4 +'''                               ' +char(10)
                 SELECT @v_dSql += ' AND    A.STEP_ID IN (SELECT STEP_ID FROM _UPPER_STEP BB WHERE A.STEP_ID = BB.STEP_ID) ' +char(10)

				 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				 exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   FP00590 Release/Group Release 팝업화면에서 FP00590_find_CapaValidation 정보갖고오기                                                */
		/*   Param :@Param1: INSTANCE_ID, @Param2: PLAN_ID,  @Param3: PLAN_DATE, @Param4: END_DATE, @Param5: CONFIRM_AREA, @Param6: FACTORY_LT, @Param7: LIMIT_CAPA  */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00590_find_CapaValidation' 
		    BEGIN	
			     SELECT @v_dSql = ''
				 -- 후공정 정보 추가.... 20220516
				 SELECT @v_dSql += ' WITH LINE_OFF_CAL AS ( ' +char(10)
				 SELECT @v_dSql += '			SELECT A.*, B.WORK_DATE, SUM(ISNULL(B.TIME_TERM, 0)) * 60 AS OFF_TIME, 86400 - (SUM(ISNULL(B.TIME_TERM, 0)) * 60) AS WORK_TIME ' +char(10)
				 SELECT @v_dSql += '			FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK) ' +char(10)
				 SELECT @v_dSql += '			LEFT OUTER JOIN SCM_WORK_CALENDAR_M B WITH(NOLOCK) ' +char(10)
				 SELECT @v_dSql += '			ON 	1=1 ' +char(10)
				 SELECT @v_dSql += '			AND A.COMPANY_ID   = B.COMPANY_ID ' +char(10)
				 SELECT @v_dSql += '			AND A.DIVISION_ID  = B.DIVISION_ID ' +char(10)
				 SELECT @v_dSql += '			AND A.SITE_ID      = B.SITE_ID ' +char(10)
				 SELECT @v_dSql += '			AND A.PLANT_ID     = B.PLANT_ID ' +char(10)
				 SELECT @v_dSql += '			AND A.FACTORY_ID   = B.FACTORY_ID ' +char(10)
				 SELECT @v_dSql += '			AND A.OPERATION_ID = B.OPERATION_ID ' +char(10)
				 SELECT @v_dSql += '			AND A.LINE_ID      = B.LINE_ID ' +char(10)
				 SELECT @v_dSql += '			AND	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' +char(10)
				 SELECT @v_dSql += '			AND B.LOSS_CODE IN ( ' +char(10)
				 SELECT @v_dSql += '					SELECT SEGMENT1 AS LOSS_CODE ' +char(10)
				 SELECT @v_dSql += '					FROM   SCM_SYS_LOOKUP_VALUE KK WITH(NOLOCK) ' +char(10)
				 SELECT @v_dSql += '					WHERE  1=1 ' +char(10)
				 SELECT @v_dSql += '					AND    LOOKUP_TYPE_CODE = ''CAPA_UI_LOSS_TYPE_DEFINIT'' ' +char(10)
				 SELECT @v_dSql += '					AND    ATTRIBUTE4 = ''Y'' ' +char(10)
				 SELECT @v_dSql += '			) ' +char(10)
				 SELECT @v_dSql += '			WHERE 1=1 ' +char(10)
				 SELECT @v_dSql += '			AND   A.INSTANCE_ID = ''' + @param1 + ''' ' +char(10)
				 SELECT @v_dSql += '			AND   WORK_DATE BETWEEN ''' + @param3 + ''' AND ''' + @param4 + ''' ' +char(10)
				 SELECT @v_dSql += '			GROUP BY A.INSTANCE_ID, A.COMPANY_ID, A.SITE_ID, A.DIVISION_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MODEL_TYPE, B.WORK_DATE ' +char(10)
				 SELECT @v_dSql += ' )  ' +char(10)
				 SELECT @v_dSql += ' , LINE_LOSS_CAL AS ( ' +char(10)
				 SELECT @v_dSql += '			SELECT A.*, B.WORK_MONTH, SUM(ISNULL(B.LOSS_RATE, 0)) AS LOSS_RATE, 1 - SUM(ISNULL(B.LOSS_RATE, 0)) AS UTILIZATION ' +char(10)
				 SELECT @v_dSql += '			FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK) ' +char(10)
				 SELECT @v_dSql += '			LEFT OUTER JOIN SCM_LOSS_M B WITH(NOLOCK) ' +char(10)
				 SELECT @v_dSql += '			ON 	1=1  ' +char(10)
				 SELECT @v_dSql += '			AND A.COMPANY_ID = B.COMPANY_ID  ' +char(10)
				 SELECT @v_dSql += '			AND A.DIVISION_ID = B.DIVISION_ID  ' +char(10)
				 SELECT @v_dSql += '			AND A.SITE_ID = B.SITE_ID  ' +char(10)
				 SELECT @v_dSql += '			AND A.PLANT_ID = B.PLANT_ID  ' +char(10)
				 SELECT @v_dSql += '			AND A.FACTORY_ID = B.FACTORY_ID  ' +char(10)
				 SELECT @v_dSql += '			AND A.OPERATION_ID = B.OPERATION_ID  ' +char(10)
				 SELECT @v_dSql += '			AND A.LINE_ID = B.LINE_ID  ' +char(10)
				 SELECT @v_dSql += '			AND	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE  ' +char(10)
				 SELECT @v_dSql += '			AND B.LOSS_CODE IN 	(  ' +char(10)
				 SELECT @v_dSql += '						SELECT SEGMENT1 AS LOSS_CODE  ' +char(10)
				 SELECT @v_dSql += '						FROM   SCM_SYS_LOOKUP_VALUE KK WITH(NOLOCK)  ' +char(10)
				 SELECT @v_dSql += '						WHERE  1=1  ' +char(10)
				 SELECT @v_dSql += '						AND    LOOKUP_TYPE_CODE = ''CAPA_UI_LOSS_TYPE_DEFINIT''  ' +char(10)
				 SELECT @v_dSql += '						AND    ATTRIBUTE4 = ''Y''  ' +char(10)
				 SELECT @v_dSql += '			)  ' +char(10)
				 SELECT @v_dSql += '			WHERE 1=1  ' +char(10)
				 SELECT @v_dSql += '			AND   A.INSTANCE_ID = ''' + @param1 + ''' ' +char(10)
				 SELECT @v_dSql += '			AND   WORK_MONTH BETWEEN SUBSTRING(''' + @param3 + ''',1,6) AND SUBSTRING(''' + @param4 + ''',1,6)  ' +char(10)
				 SELECT @v_dSql += '			GROUP BY A.INSTANCE_ID, A.COMPANY_ID, A.SITE_ID, A.DIVISION_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.MODEL_TYPE, B.WORK_MONTH  ' +char(10)
				 SELECT @v_dSql += ' ) ' +char(10)
				 SELECT @v_dSql += ' , CAPA_INFO AS ( ' +char(10)
                 SELECT @v_dSql += ' 	-- cell          ' +char(10)
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,2), A.UTILIZATION) AS UTILIZATION ' +char(10)
				 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,0), A.OFF_TIME) AS OFF_TIME       ' +char(10)
                 SELECT @v_dSql += ' 	FROM   FP_AMEND_PLAN_CELL_UTIL_R A WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	WHERE  A.INSTANCE_ID = '''+ @param1 +'''        ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.FP_PLAN_ID  = '''+ @param2 +'''        ' +char(10)
                 SELECT @v_dSql += ' 	--AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' -- 계획일부터 END_PLAN_WEEK_DATE(PLAN_WEEK 막날)까지 ' +char(10)
				 SELECT @v_dSql += ' 	AND    A.PLAN_DATE BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' 	AND    A.UTILIZATION > '''+ @param7 +''' ' +char(10)
                 SELECT @v_dSql += ' 	-- pack                                  ' +char(10)
                 SELECT @v_dSql += ' 	UNION ALL                                ' +char(10)
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,2), A.UTILIZATION) AS UTILIZATION ' +char(10)
				 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,0), A.OFF_TIME) AS OFF_TIME       ' +char(10)
                 SELECT @v_dSql += ' 	FROM   FP_AMEND_PLAN_PACK_UTIL_R A WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	WHERE  A.INSTANCE_ID = '''+ @param1 +'''        ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.FP_PLAN_ID  = '''+ @param2 +'''        ' +char(10)
                 SELECT @v_dSql += ' 	--AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' -- 계획일부터 END_PLAN_WEEK_DATE(PLAN_WEEK 막날)까지 ' +char(10)
				 SELECT @v_dSql += ' 	AND    A.PLAN_DATE BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' 	AND    A.UTILIZATION > '''+ @param7 +''' ' +char(10)
                 SELECT @v_dSql += ' 	-- form                                  ' +char(10)
				 SELECT @v_dSql += ' 	UNION ALL                                ' +char(10)
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,2), A.UTILIZATION) AS UTILIZATION ' +char(10)
				 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,0), A.OFF_TIME) AS OFF_TIME       ' +char(10)
                 SELECT @v_dSql += ' 	FROM   FP_AMEND_PLAN_FORM_UTIL_R A WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	WHERE  A.INSTANCE_ID = '''+ @param1 +'''        ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.FP_PLAN_ID  = '''+ @param2 +'''        ' +char(10)
                 SELECT @v_dSql += ' 	--AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' -- 계획일부터 END_PLAN_WEEK_DATE(PLAN_WEEK 막날)까지 ' +char(10)
				 SELECT @v_dSql += ' 	AND    A.PLAN_DATE BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' 	AND    A.UTILIZATION > '''+ @param7 +''' ' +char(10)
                 SELECT @v_dSql += ' 	-- elec                                  ' +char(10)
                 SELECT @v_dSql += ' 	UNION ALL                                ' +char(10)
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,2), A.UTILIZATION) AS UTILIZATION ' +char(10)
				 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,0), A.OFF_TIME) AS OFF_TIME       ' +char(10)
                 SELECT @v_dSql += ' 	FROM   FP_AMEND_DAILY_UTIL_R A WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	WHERE  A.INSTANCE_ID = '''+ @param1 +'''    ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.FP_PLAN_ID  = '''+ @param2 +'''    ' +char(10)
                 SELECT @v_dSql += ' 	--AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' -- 계획일부터 END_PLAN_WEEK_DATE(PLAN_WEEK 막날)까지 ' +char(10)
				 SELECT @v_dSql += ' 	AND    A.PLAN_DATE BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' 	AND    A.UTILIZATION > '''+ @param7 +''' ' +char(10)
                 SELECT @v_dSql += ' 	-- post ' +char(10)
                 SELECT @v_dSql += ' 	UNION ALL ' +char(10)
				 SELECT @v_dSql += ' 	SELECT A.* ' +char(10)
				 SELECT @v_dSql += ' 	FROM ( ' +char(10)
                 SELECT @v_dSql += ' 		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' +char(10)
                 SELECT @v_dSql += ' 		 	 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' 		 	 , CONVERT( NUMERIC(20,2), (SUM((JR_IN_QTY * B.TACT_TIME / ISNULL(D.UTILIZATION,1)) / ISNULL(C.WORK_TIME, 86400)*100)) ) AS UTILIZATION ' +char(10)
                 SELECT @v_dSql += ' 			 , SUM(ISNULL(C.OFF_TIME,0)) AS OFF_TIME ' +char(10)
                 SELECT @v_dSql += ' 		FROM   FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R A WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 		LEFT OUTER JOIN SCM_TACT_TIME_M B WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 		ON 	  1=1 ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.COMPANY_ID     = B.COMPANY_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.DIVISION_ID    = B.DIVISION_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.SITE_ID        = B.SITE_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.PLANT_ID       = B.PLANT_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.FACTORY_ID     = B.FACTORY_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.OPERATION_ID   = B.OPERATION_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.LINE_ID        = B.LINE_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND	  A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.ITEM_ID        = B.ITEM_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   CONVERT(CHAR(6), A.PLAN_DATE, 112) = B.MONTH ' +char(10)
                 SELECT @v_dSql += ' 		LEFT OUTER JOIN LINE_OFF_CAL C ' +char(10)
                 SELECT @v_dSql += ' 		ON 	  1=1 ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.COMPANY_ID     = C.COMPANY_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.DIVISION_ID    = C.DIVISION_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.SITE_ID        = C.SITE_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.PLANT_ID       = C.PLANT_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.FACTORY_ID     = C.FACTORY_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.OPERATION_ID   = C.OPERATION_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.LINE_ID        = C.LINE_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND	  A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.PLAN_DATE      = C.WORK_DATE ' +char(10)
                 SELECT @v_dSql += ' 		LEFT OUTER JOIN LINE_LOSS_CAL D ' +char(10)
                 SELECT @v_dSql += ' 		ON 	  1=1 ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.COMPANY_ID     = D.COMPANY_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.DIVISION_ID    = D.DIVISION_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.SITE_ID        = D.SITE_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.PLANT_ID       = D.PLANT_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.FACTORY_ID     = D.FACTORY_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.OPERATION_ID   = D.OPERATION_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.LINE_ID        = D.LINE_ID ' +char(10)
                 SELECT @v_dSql += ' 		AND	  A.ELECTRODE_TYPE = D.ELECTRODE_TYPE ' +char(10)
                 SELECT @v_dSql += ' 		AND   CONVERT(CHAR(6), A.PLAN_DATE, 112) = D.WORK_MONTH ' +char(10)
                 SELECT @v_dSql += ' 		WHERE 1=1 ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.INSTANCE_ID = ''' + @param1 + ''' ' +char(10)
                 SELECT @v_dSql += ' 		AND   A.FP_PLAN_ID  = ''' + @param2 + ''' ' +char(10) 
                 SELECT @v_dSql += ' 		AND   A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @param3 + ''') AND CONVERT(DATETIME, ''' + @param4 + ''') ' +char(10)
                 SELECT @v_dSql += ' 		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' +char(10)
                 SELECT @v_dSql += ' 		 	   , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' +char(10)
				 SELECT @v_dSql += ' 	) A ' +char(10)
				 SELECT @v_dSql += ' 	WHERE 1=1 ' +char(10)
				 SELECT @v_dSql += ' 	AND   A.UTILIZATION > ''' + @param7 + ''' ' +char(10)
                 SELECT @v_dSql += ' )                                           ' +char(10)
                 SELECT @v_dSql += ' , RAW_DATA AS (                             ' +char(10)
                 SELECT @v_dSql += ' 	-- cell                                  ' +char(10)
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' 		 , A.PRODUCTION_TYPE, A.MARKET, A.TOP_ITEM_ID, A.ITEM_ID ' +char(10)
                 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,0), A.OUT_QTY) AS OUT_QTY ' +char(10)
                 SELECT @v_dSql += ' 	FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	WHERE  1=1                                 ' +char(10)
                 SELECT @v_dSql += ' 	ANd    A.INSTANCE_ID = '''+ @param1 +'''   ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.FP_PLAN_ID  = '''+ @param2 +'''   ' +char(10)
                 SELECT @v_dSql += ' 	--AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' -- 계획일부터 END_PLAN_WEEK_DATE(PLAN_WEEK 막날)까지 ' +char(10)
				 SELECT @v_dSql += ' 	AND    A.PLAN_DATE BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' 	AND    A.OUT_QTY > 0 ' +char(10)
                 SELECT @v_dSql += ' 	-- pack              ' +char(10)
                 SELECT @v_dSql += ' 	UNION ALL            ' +char(10)
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' 		 , A.PRODUCTION_TYPE, A.MARKET, A.TOP_ITEM_ID, A.ITEM_ID ' +char(10)
                 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,0), A.OUT_QTY) AS OUT_QTY ' +char(10)
                 SELECT @v_dSql += ' 	FROM   FP_AMEND_PLAN_PACK_R A WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	WHERE  1=1                                 ' +char(10)
                 SELECT @v_dSql += ' 	ANd    A.INSTANCE_ID = '''+ @param1 +'''   ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.FP_PLAN_ID  = '''+ @param2 +'''   ' +char(10)
                 SELECT @v_dSql += ' 	--AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' -- 계획일부터 END_PLAN_WEEK_DATE(PLAN_WEEK 막날)까지 ' +char(10)
				 SELECT @v_dSql += ' 	AND    A.PLAN_DATE BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' 	AND    A.OUT_QTY > 0 ' +char(10)
                 SELECT @v_dSql += ' 	-- form              ' +char(10)
                 SELECT @v_dSql += ' 	UNION ALL            ' +char(10)
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' 		 , A.PRODUCTION_TYPE, A.MARKET, A.TOP_ITEM_ID, A.ITEM_ID ' +char(10)
                 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,0), A.OUT_QTY) AS OUT_QTY ' +char(10)
                 SELECT @v_dSql += ' 	FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	WHERE  1=1                                 ' +char(10)
                 SELECT @v_dSql += ' 	ANd    A.INSTANCE_ID = '''+ @param1 +'''   ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.FP_PLAN_ID  = '''+ @param2 +'''   ' +char(10)
                 SELECT @v_dSql += ' 	--AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' -- 계획일부터 END_PLAN_WEEK_DATE(PLAN_WEEK 막날)까지 ' +char(10)
				 SELECT @v_dSql += ' 	AND    A.PLAN_DATE BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' 	AND    A.OUT_QTY > 0 ' +char(10)
                 SELECT @v_dSql += ' 	-- elec              ' +char(10)
                 SELECT @v_dSql += ' 	UNION ALL            ' +char(10)
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' 		 , A.PRODUCTION_TYPE, A.MARKET, A.TOP_ITEM_ID, A.ITEM_ID ' +char(10)
                 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,0), A.ADJUST_OUT_QTY_M) AS OUT_QTY -- 전극은 P/C(M) 로 계산 ' +char(10)
                 SELECT @v_dSql += ' 	FROM   FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	WHERE  1=1                               ' +char(10)
                 SELECT @v_dSql += ' 	ANd    A.INSTANCE_ID = '''+ @param1 +''' ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.FP_PLAN_ID  = '''+ @param2 +''' ' +char(10)
                 SELECT @v_dSql += ' 	--AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' -- 계획일부터 END_PLAN_WEEK_DATE(PLAN_WEEK 막날)까지 ' +char(10)
				 SELECT @v_dSql += ' 	AND    A.PLAN_DATE BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' 	AND    A.ADJUST_OUT_QTY_M > 0 ' +char(10)
                 SELECT @v_dSql += ' 	-- post ' +char(10)
                 SELECT @v_dSql += ' 	UNION ALL ' +char(10)
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' +char(10)
                 SELECT @v_dSql += ' 		 , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' 		 , A.PRODUCTION_TYPE, ''D'' AS MARKET, A.ITEM_ID AS TOP_ITEM_ID , A.ITEM_ID ' +char(10)
                 SELECT @v_dSql += ' 		 , SUM(A.JR_OUT_QTY) AS OUT_QTY ' +char(10)
                 SELECT @v_dSql += ' 	FROM   FP_PRODUCTION_PLAN_EQUIPMENT_EPOST_R A WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	WHERE  1=1 ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.INSTANCE_ID = ''' + @param1 + ''' ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.FP_PLAN_ID  = ''' + @param2 + ''' ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @param3 + ''') AND CONVERT(DATETIME, ''' + @param4 + ''') ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.SHIFT IN (1,2) ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.JR_OUT_QTY > 0 ' +char(10)
                 SELECT @v_dSql += ' 	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' +char(10)
                 SELECT @v_dSql += ' 		   , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' 		   , A.PRODUCTION_TYPE, A.ITEM_ID ' +char(10)
                 SELECT @v_dSql += ' )                                ' +char(10)
                 SELECT @v_dSql += ' SELECT A.*                       ' +char(10)
                 SELECT @v_dSql += '     , B.LINE_NAME                ' +char(10)
                 SELECT @v_dSql += '     , c.NICK_NAME                ' +char(10)
                 SELECT @v_dSql += '     , D.ISO_YYYYWW AS PLAN_WEEK ' +char(10)
                 SELECT @v_dSql += '     , E.DAILY_CAPA              ' +char(10)
                 SELECT @v_dSql += ' FROM (     ' +char(10)
                 SELECT @v_dSql += ' 	-- DATA ' +char(10)
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID ' +char(10)
                 SELECT @v_dSql += ' 		 , A.LINE_ID, A.ELECTRODE_TYPE, CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE     ' +char(10)
                 SELECT @v_dSql += ' 		 , A.PRODUCTION_TYPE, A.MARKET, A.TOP_ITEM_ID, A.ITEM_ID                            ' +char(10)
                 SELECT @v_dSql += ' 		 , CONVERT(NUMERIC(20,0), A.OUT_QTY) AS OUT_QTY, ''DATA'' AS DATA_TYPE              ' +char(10)
                 SELECT @v_dSql += ' 	FROM   RAW_DATA A WITH(NOLOCK), CAPA_INFO B WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	WHERE  1=1                                 ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.COMPANY_ID     = B.COMPANY_ID     ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.DIVISION_ID    = B.DIVISION_ID    ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.SITE_ID        = B.SITE_ID        ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.PLANT_ID       = B.PLANT_ID       ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.FACTORY_ID     = B.FACTORY_ID     ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.OPERATION_ID   = B.OPERATION_ID   ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.LINE_ID        = B.LINE_ID        ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.PLAN_DATE      = B.PLAN_DATE      ' +char(10)
                 SELECT @v_dSql += ' 	-- TOTAL  ' +char(10)
                 SELECT @v_dSql += ' 	UNION ALL ' +char(10)
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID ' +char(10)
                 SELECT @v_dSql += ' 		 , A.ELECTRODE_TYPE, CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE, NULL AS PRODUCTION_TYPE  ' +char(10)
                 SELECT @v_dSql += ' 		 , NULL AS MARKET, ''Load('' + CONVERT(VARCHAR, MAX(B.UTILIZATION))+ ''%)'' AS TOP_ITEM_ID     ' +char(10)
				 SELECT @v_dSql += '         , ''Off('' + CONVERT(VARCHAR, CEILING(MAX(B.OFF_TIME)))+ '' min)'' AS ITEM_ID        ' +char(10)
                 SELECT @v_dSql += ' 		 , SUM(CONVERT(NUMERIC(20,0), A.OUT_QTY)) AS OUT_QTY, ''TOTAL'' AS DATA_TYPE ' +char(10)
                 SELECT @v_dSql += ' 	FROM   RAW_DATA A WITH(NOLOCK), CAPA_INFO B WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	WHERE  1=1                                 ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.COMPANY_ID     = B.COMPANY_ID     ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.DIVISION_ID    = B.DIVISION_ID    ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.SITE_ID        = B.SITE_ID        ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.PLANT_ID       = B.PLANT_ID       ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.FACTORY_ID     = B.FACTORY_ID     ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.OPERATION_ID   = B.OPERATION_ID   ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.LINE_ID        = B.LINE_ID        ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' +char(10)
                 SELECT @v_dSql += ' 	AND    A.PLAN_DATE      = B.PLAN_DATE      ' +char(10)
            SELECT @v_dSql += ' 	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' +char(10)
                 SELECT @v_dSql += ' ) A          ' +char(10)
                 SELECT @v_dSql += ' INNER JOIN SCM_LINE_M B WITH(NOLOCK) ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' ON  A.COMPANY_ID     = B.COMPANY_ID       ' +char(10)
                 SELECT @v_dSql += ' AND A.DIVISION_ID    = B.DIVISION_ID      ' +char(10)
                 SELECT @v_dSql += ' AND A.SITE_ID        = B.SITE_ID          ' +char(10)
                 SELECT @v_dSql += ' AND A.PLANT_ID       = B.PLANT_ID         ' +char(10)
                 SELECT @v_dSql += ' AND A.FACTORY_ID     = B.FACTORY_ID       ' +char(10)
                 SELECT @v_dSql += ' AND A.OPERATION_ID   = B.OPERATION_ID     ' +char(10)
                 SELECT @v_dSql += ' AND A.LINE_ID        = B.LINE_ID          ' +char(10)
                 SELECT @v_dSql += ' AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE        ' +char(10)
                 SELECT @v_dSql += ' LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK) ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' ON  A.COMPANY_ID     = C.COMPANY_ID            ' +char(10)
                 SELECT @v_dSql += ' AND A.DIVISION_ID    = C.DIVISION_ID           ' +char(10)
                 SELECT @v_dSql += ' AND A.SITE_ID        = C.SITE_ID               ' +char(10)
                 SELECT @v_dSql += ' AND A.TOP_ITEM_ID    = C.ITEM_ID               ' +char(10)
                 SELECT @v_dSql += ' LEFT OUTER JOIN TH_UIS_CAL D WITH(NOLOCK) ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' ON  A.PLAN_DATE = D.YYYYMMDD ' +char(10)
                 SELECT @v_dSql += ' LEFT OUTER JOIN (       ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID ' +char(10)
                 SELECT @v_dSql += ' 		 , A.LINE_ID, A.ELECTRODE_TYPE, A.ITEM_ID, A.MONTH, A.DAILY_CAPA ' +char(10)
                 SELECT @v_dSql += ' 	FROM  SCM_TACT_TIME_M A WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	INNER JOIN (                    ' +char(10) -- 속도개선... 20220113
                 SELECT @v_dSql += ' 	    SELECT *                         ' +char(10)
                 SELECT @v_dSql += ' 	    FROM   FP_INSTANCE_LINE_V BB WITH(NOLOCK) ' +char(10)
                 SELECT @v_dSql += ' 	    WHERE  BB.INSTANCE_ID = '''+ @param1 +''' ' +char(10)
                 SELECT @v_dSql += ' 	) BB                                       ' +char(10)
                 SELECT @v_dSql += ' 	ON    A.COMPANY_ID     = BB.COMPANY_ID     ' +char(10)
                 SELECT @v_dSql += ' 	AND   A.DIVISION_ID    = BB.DIVISION_ID    ' +char(10)
                 SELECT @v_dSql += ' 	AND   A.SITE_ID        = BB.SITE_ID        ' +char(10)
                 SELECT @v_dSql += ' 	AND   A.PLANT_ID       = BB.PLANT_ID       ' +char(10)
                 SELECT @v_dSql += ' 	AND   A.FACTORY_ID     = BB.FACTORY_ID     ' +char(10)
                 SELECT @v_dSql += ' 	AND   A.OPERATION_ID   = BB.OPERATION_ID   ' +char(10)
                 SELECT @v_dSql += ' 	AND   A.LINE_ID        = BB.LINE_ID        ' +char(10)
                 SELECT @v_dSql += ' 	AND   A.ELECTRODE_TYPE = BB.ELECTRODE_TYPE ' +char(10)
                 SELECT @v_dSql += ' 	WHERE 1=1 ' +char(10)
                 SELECT @v_dSql += ' 	AND   A.MONTH BETWEEN LEFT('''+ @param3 +''',6) AND LEFT('''+ @param4 +''',6) ' +char(10)
                 SELECT @v_dSql += ' ) E                                      ' +char(10)
                 SELECT @v_dSql += ' ON  A.COMPANY_ID      = E.COMPANY_ID     ' +char(10)
                 SELECT @v_dSql += ' And A.DIVISION_ID     = E.DIVISION_ID    ' +char(10)
                 SELECT @v_dSql += ' And A.SITE_ID = E.SITE_ID        ' +char(10)
                 SELECT @v_dSql += ' And A.PLANT_ID        = E.PLANT_ID       ' +char(10)
                 SELECT @v_dSql += ' And A.FACTORY_ID      = E.FACTORY_ID     ' +char(10)
                 SELECT @v_dSql += ' And A.OPERATION_ID    = E.OPERATION_ID   ' +char(10)
                 SELECT @v_dSql += ' And A.LINE_ID         = E.LINE_ID        ' +char(10)
                 SELECT @v_dSql += ' And A.ELECTRODE_TYPE  = E.ELECTRODE_TYPE ' +char(10)
                 SELECT @v_dSql += ' And A.ITEM_ID         = E.ITEM_ID        ' +char(10)
                 SELECT @v_dSql += ' And LEFT(A.PLAN_DATE,6) = E.MONTH        ' +char(10)
                 SELECT @v_dSql += ' WHERE 1=1                                ' +char(10)
                 SELECT @v_dSql += ' AND   D.YYYYMMDD BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' ' +char(10)
                 
				 IF(@param5 = 'BUILDING') 
				     BEGIN
					     SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param6)) + char(10);
				     END
                 ELSE
				     BEGIN
					     SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.MODEL_TYPE' , 'EQ', @param6)) + char(10);
				     END
                 SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID DESC, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' +char(10)
                 SELECT @v_dSql += '      , (CASE WHEN A.DATA_TYPE=''DATA'' THEN 1 ELSE 999 END), A.TOP_ITEM_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET ' +char(10)
				 SELECT @v_dSql += ' option (force order) ' +char(10) -- 속도개선... 20220113

				 exec sp_executesql @v_dSql

				SET @runend = GetDate()
				EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_code, '', @v_dSql,'select',@runstart, @runend

		   END
		/****************************************************************************************************************************************/
		/*   FP00590 RePlanTotal 팝업화면에서 FP00590_Replan_findPlanInfo정보갖고오기                                                           */
		/*   Param :@Param1: INSTANCE_ID,   @Param2: PLAN_DATE,   @Param2: PLAN_TYPE                                                            */
		/****************************************************************************************************************************************/
        ELSE IF @p_code = 'FP00590_Replan_findPlanInfo' 
            BEGIN	
                SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT     A.INSTANCE_ID, A.PLAN_ID, A.PLAN_TYPE                                                                              ' +char(10)
                SELECT @v_dSql += '     , A.SITE_ID, CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) AS PLAN_START_TIME, A.PLAN_HORIZON                               ' +char(10)
                SELECT @v_dSql += '     , CONVERT(VARCHAR(8), A.PLAN_START_TIME + A.PLAN_HORIZON, 112) AS PLAN_END_TIME                                           ' +char(10)
                SELECT @v_dSql += '     , A.DEMAND_HORIZON, A.CONFIG_SET_ID, A.BASIS_PLAN_ID                                                                      ' +char(10)
                SELECT @v_dSql += '     , A.PLAN_ID AS CODE, A.PLAN_ID AS NAME                                                                                    ' +char(10)
                SELECT @v_dSql += '     , A.DESCRIPTION                                                                                                           ' +char(10)
                SELECT @v_dSql += '     , A.PRE_FIX_TYPE                                                                                                          ' +char(10)
                SELECT @v_dSql += '     , A.CONFIRM_ID, CONVERT(VARCHAR, A.CONFIRM_TIME, 120) AS CONFIRM_TIME                                                     ' +char(10)
                SELECT @v_dSql += '     , A.INSERT_ID, CONVERT(VARCHAR, A.INSERT_TIME , 120) AS INSERT_TIME                                                       ' +char(10)
                SELECT @v_dSql += '     , ISNULL(CONVERT(VARCHAR,A.PRE_FIX_DATE,112), CONVERT(VARCHAR, DATEADD(DD,6,A.PLAN_START_TIME), 112)) AS PRE_FIX_DATE     ' +char(10)
                SELECT @v_dSql += '     , ISNULL(CONVERT(VARCHAR,A.AMEND_FIX_DATE,112), CONVERT(VARCHAR, DATEADD(DD,6,A.PLAN_START_TIME), 112)) AS AMEND_FIX_DATE ' +char(10)
                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A(NOLOCK)                                                                                                ' +char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                                                                      ' +char(10)
                SELECT @v_dSql += ' AND    A.PLAN_ID     = '''+ @param2 +'''                                                                                      ' +char(10)
                SELECT @v_dSql += ' AND    A.PLAN_TYPE   = '''+ @param3 +'''                                                                                      ' +char(10)
                
                --SELECT @v_dSql
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
				exec sp_executesql @v_dSql

            END
		/****************************************************************************************************************************************/
		/*   FP00594화면에서 findPlanner_List 정보갖고오기                                                                                      */
		/*   Param :@Param1: INSTANCE_ID,                                                                       		        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_findPlanner_List' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.USER_ID AS CODE                                                            ' +char(10)
				SELECT @v_dSql += '   , ISNULL(B.USER_NAME,''-'') + '' ('' + A.USER_ID + '')'' AS NAME                           ' +char(10)
                SELECT @v_dSql += '   , (CASE WHEN A.USER_ID = '''+ @p_user_id +''' THEN ''Y'' ELSE ''N'' END) AS DEFAULT_CHECK  ' +char(10)
                SELECT @v_dSql += ' FROM   FP_USER_LINE_GROUP_M A WITH(NOLOCK)                                                   ' +char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)                                            ' +char(10)
                SELECT @v_dSql += ' ON     A.USER_ID = B.USER_ID                                                                 ' +char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                                     ' +char(10)
                SELECT @v_dSql += ' ORDER BY NAME                                                                           ' +char(10)

				exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   FP00594화면에서 findBasisTime 정보갖고오기                                                                                      */
		/*            @Param1     @Param2              */
		/*   Param : INSTANCE_ID, PLAN_ID     */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_findBasisTime' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql = ' SELECT REPLACE(CONVERT(CHAR, DBO.FN_GET_BASISTIME('''+ @param1 +''','''+ @param2 +'''), 24), '':'', '''') AS BASIS_TIME  ' +char(10)
			   
			   exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00594화면에서 findFpPlan_info 정보갖고오기                                                                                      */
		/*            @Param1 @Param2    */
		/*   Param : INSTANCE_ID, PLAN_DATE    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_findFpPlan_info' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql  = ' WITH RELEASE_PLAN AS (                                           ' +char(10)
                SELECT @v_dSql += '      SELECT DISTINCT                                             ' +char(10)
                SELECT @v_dSql += '         A.INSTANCE_ID                                            ' +char(10)
                SELECT @v_dSql += '        ,A.RELEASE_PLAN_ID AS PLAN_ID                             ' +char(10)
                SELECT @v_dSql += '        ,STUFF(( SELECT '','' + PLAN_GROUP_ID                     ' +char(10)
                SELECT @v_dSql += '                 FROM   FP_RELEASE_PLAN_INFO_H B                  ' +char(10)
                SELECT @v_dSql += '                 WHERE  A.INSTANCE_ID     = B.INSTANCE_ID         ' +char(10)
                SELECT @v_dSql += '                 AND    A.INSTANCE_DATE   = B.INSTANCE_DATE       ' +char(10)
                SELECT @v_dSql += '                 AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID     ' +char(10)
                SELECT @v_dSql += '                 FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT     ' +char(10)
                SELECT @v_dSql += '        ,A.PLAN_GROUP_ID                                          ' +char(10)
                SELECT @v_dSql += '        ,A.INSTANCE_DATE AS PLAN_DATE                             ' +char(10)
                SELECT @v_dSql += '      FROM   FP_RELEASE_PLAN_INFO_H A                             ' +char(10)
                SELECT @v_dSql += '      WHERE  1=1                                                  ' +char(10)
                SELECT @v_dSql += '      AND    A.INSTANCE_ID    = '''+ @param1 +'''                 ' +char(10)
                SELECT @v_dSql += '      AND    A.INSTANCE_DATE  = '''+ @param2 +'''                 ' +char(10)
                SELECT @v_dSql += ' )                                                                ' +char(10)
                SELECT @v_dSql += ' SELECT A.PLAN_ID AS CODE                                         ' +char(10)
				SELECT @v_dSql += '   , SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS NAME ' +char(10)
                SELECT @v_dSql += '   , A.PLAN_ID, A.PLAN_TYPE,A.PLAN_START_TIME, A.PLAN_HORIZON     ' +char(10)
                SELECT @v_dSql += '   , A.PLAN_HORIZON_UOM, A.DEMAND_HORIZON, A.DEMAND_HORIZON_UOM   ' +char(10)
                SELECT @v_dSql += '   , A.CONFIG_SET_ID, A.BASIS_PLAN_ID, A.DEMAND_PLAN_ID           ' +char(10)
                SELECT @v_dSql += '   , A.SCP_PLAN_ID, A.PLAN_WEEK                                   ' +char(10)
                SELECT @v_dSql += '   , (SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS PLAN_START_DATE    ' +char(10)
                SELECT @v_dSql += '   , CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS PLAN_END_DATE    ' +char(10)
                SELECT @v_dSql += '   , (SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS DEFAULT_START_DATE ' +char(10)
                SELECT @v_dSql += '   , CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS DEFAULT_END_DATE ' +char(10)
				SELECT @v_dSql += '	  ,CONVERT(VARCHAR, DATEADD(DD, D.ATTRIBUTE15 * 7, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS UI_END_DATE  ' + char(10)
                SELECT @v_dSql += '   , A.INSTANCE_ID, A.SITE_ID, A.DESCRIPTION, A.PLAN_TYPE                                 ' +char(10)
                SELECT @v_dSql += '   , CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID ' +char(10)
                SELECT @v_dSql += '   , CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME                                  ' +char(10)
                SELECT @v_dSql += '   , CASE WHEN A.RELEASE_FLAG = ''Y''                                                     ' +char(10)
                SELECT @v_dSql += '       THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA                         ' +char(10)
				SELECT @v_dSql += '             WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID )      ' +char(10)
                SELECT @v_dSql += '       ELSE A.DESCRIPTION END AS DESCS                                                    ' +char(10)
                SELECT @v_dSql += '   , SUBSTRING(BASIS_PLAN_ID,CHARINDEX(''-'',BASIS_PLAN_ID)+1,11) AS BASIC_VERSION        ' +char(10)
                SELECT @v_dSql += '   , C.FACTORY_LT                                                                         ' +char(10)
                SELECT @v_dSql += '   , (CASE WHEN PLAN_TYPE = ''RELEASE'' THEN ''Y''                                        ' +char(10)
                SELECT @v_dSql += '     WHEN RIGHT(A.PLAN_ID,2) = ''00'' THEN ''Y'' ELSE ''N'' END) READ_ONLY                ' +char(10)
                SELECT @v_dSql += ' FROM  SCM_FP_PLAN_H A WITH(NOLOCK)                                                       ' +char(10)
                SELECT @v_dSql += '      LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK)                                         ' +char(10)
                SELECT @v_dSql += '      ON  A.INSTANCE_ID = C.INSTANCE_ID                                                   ' +char(10)
                SELECT @v_dSql += '      AND A.PLAN_ID = C.PLAN_ID                                                           ' +char(10)
				SELECT @v_dSql += '			LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE D WITH(NOLOCK)                          ' + char(10)
				SELECT @v_dSql += '			ON	A.INSTANCE_ID = D.SEGMENT1                                               ' + char(10)
				SELECT @v_dSql += '			AND D.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                     ' + char(10)
				SELECT @v_dSql += '			AND D.ACTIVE_FLAG = ''Y''                                                    ' + char(10)
                SELECT @v_dSql += '  WHERE  1=1                                                                              ' +char(10)
                SELECT @v_dSql += '  AND    A.INSTANCE_ID = '''+ @param1 +'''                                                ' +char(10)
                SELECT @v_dSql += '  AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = '''+ @param2 +'''                    ' +char(10)
                SELECT @v_dSql += ' ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC                     ' +char(10)

			   exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   FP00594화면에서 findFactoryCode_amend_common 정보갖고오기                                                                                      */
		/*            @Param1     @Param2,   @Param3,    @Param4,      @Param5,     @Param6,  @Param7,   @Param8,   @Param9     */
		/*   Param : INSTANCE_ID, PLAN_ID,   PLAN_TYPE,  CONFIRM_AREA, DIVISION_ID, SITE_ID,  PLANT_ID,  NON_AUTH,  SAVE_AUTH    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_findFactoryCode_amend_common' 
		    BEGIN	
			    SELECT @v_dSql1 = ''
                SELECT @v_dSql1 += ' SELECT A.FACTORY_ID AS CODE                                                   ' +char(10)
				SELECT @v_dSql1 += ' , ''('' + A.FACTORY_ID + '')'' + ISNULL(A.FACTORY_NAME, A.FACTORY_ID) AS NAME ' +char(10)
                SELECT @v_dSql1 += ' FROM   SCM_FACTORY_M A WITH(NOLOCK)                                           ' +char(10)
                SELECT @v_dSql1 += ' WHERE  1=1                                                                    ' +char(10)

                IF @Param8 = 'Y'  --NON_AUTH
                    BEGIN 
                         SELECT @v_dSql1 += ' ' +char(10)
                    END
                ELSE
		            BEGIN
                        SELECT @v_dSql1 += ' AND  EXISTS (                                            ' +char(10)
                        SELECT @v_dSql1 += '   	          SELECT 1                                    ' +char(10)
                        SELECT @v_dSql1 += '   	          FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)   ' +char(10)
                        SELECT @v_dSql1 += '   	          WHERE  A.COMPANY_ID     = B.COMPANY_ID      ' +char(10)
                        SELECT @v_dSql1 += ' 	          	AND  A.DIVISION_ID    = B.DIVISION_ID     ' +char(10)
                        SELECT @v_dSql1 += ' 	          	AND  A.SITE_ID        = B.SITE_ID         ' +char(10)
                        SELECT @v_dSql1 += ' 	          	AND  A.PLANT_ID       = B.PLANT_ID        ' +char(10)
                        SELECT @v_dSql1 += ' 	          	AND  A.FACTORY_ID     = B.FACTORY_ID      ' +char(10)
                        SELECT @v_dSql1 += '   	            AND  B.USER_ID     = '''+ @p_user_id +''' ' +char(10)
						IF @Param9 = 'Y' --SAVE_AUTH
						    BEGIN
                                SELECT @v_dSql1 += ' AND    B.SAVE_FLAG = ''Y'' ' +char(10)
							END                        
						SELECT @v_dSql1 += '   	         )                                            ' +char(10)
	                    

                    END
                SELECT @v_dSql1 += ' AND A.ACTIVE_FLAG = ''Y''                                                                               ' +char(10)
                SELECT @v_dSql1 += ' AND EXISTS (                                                                                            ' +char(10)
                SELECT @v_dSql1 += '             SELECT 1 FROM (                                                                             ' +char(10)
                SELECT @v_dSql1 += '                           SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID  ' +char(10)
                SELECT @v_dSql1 += '                           FROM   SCM_FACTORY_M A WITH(NOLOCK)                                           ' +char(10)
                SELECT @v_dSql1 += '                           INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                               ' +char(10)
                SELECT @v_dSql1 += '                           ON    A.FACTORY_ID=B.FACTORY_ID                                               ' +char(10)
                SELECT @v_dSql1 += '                           AND		B.ACTIVE_FLAG = ''Y''                                                ' +char(10)
                SELECT @v_dSql1 += '                           WHERE 1=1                                                                     ' +char(10)
                SELECT @v_dSql1 += '                           AND	 A.ACTIVE_FLAG = ''Y''                                                   ' +char(10)
                SELECT @v_dSql1 += '                           AND   B.INSTANCE_ID = '''+ @param1 +'''    ' +char(10)
                SELECT @v_dSql1 += '                          ) C                                                                            ' +char(10)
                SELECT @v_dSql1 += '             WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID                     ' +char(10)
				SELECT @v_dSql1 += '             AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID             ' +char(10)
                SELECT @v_dSql1 += '          )                                                                                              ' +char(10)
	            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5))                                    + char(10)
	            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6))                                        + char(10)
	            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7))                                       + char(10)
				
				SELECT @v_dSql2 = ''
                IF @param3 = 'RELEASE' AND  @param4 = 'PLAN GROUP'
                    BEGIN
                        SELECT @v_dSql2 += ' AND A.FACTORY_ID IN (                                 ' +char(10)
                        SELECT @v_dSql2 += '         SELECT KK.FACTORY_ID                          ' +char(10)
                        SELECT @v_dSql2 += '         FROM   FP_RELEASE_PLAN_INFO_H KK WITH(NOLOCK) ' +char(10)
                        SELECT @v_dSql2 += '         WHERE  KK.INSTANCE_ID = '''+ @param1 +'''     ' +char(10)
                        SELECT @v_dSql2 += '         AND KK.RELEASE_PLAN_ID = '''+ @param2 +'''    ' +char(10)
                        SELECT @v_dSql2 += '    )                                                  ' +char(10)
                    END
			    
                SELECT @v_dSql2 += ' GROUP BY A.FACTORY_ID, A.FACTORY_NAME                         ' +char(10)
                SELECT @v_dSql2 += ' ORDER BY A.FACTORY_ID                                         ' +char(10)
			    
			    SELECT @v_dSql = @v_dSql1 + @v_dSql2
			    
				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00594화면에서 findLineCode_List 정보갖고오기                                                                                      */
		/*            @Param1     @Param2,  @Param3,    @Param4,       @Param5,     @Param6,  @Param7,   @Param8,    @Param9,       @Param10,     @Param11   */
		/*   Param : INSTANCE_ID, PLAN_ID,  PLAN_TYPE,  CONFIRM_AREA,  DIVISION_ID, SITE_ID,  PLANT_ID,  FACTORY_ID, OPERATION_ID,  LINEALLCHECK, USERLIST   */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_findLineCode_List' 
		    BEGIN	
			    SELECT @v_dSql1 = ''
                SELECT @v_dSql1  = ' SELECT A.LINE_ID AS CODE                                                                    ' + char(10)
                SELECT @v_dSql1 += '    , ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN  ' + char(10)
				SELECT @v_dSql1 += '              A.LINE_ID ELSE A.LINE_NAME END) AS NAME                                        ' + char(10)
                SELECT @v_dSql1 += ' FROM   SCM_LINE_M A WITH(NOLOCK)                                                            ' + char(10)
                SELECT @v_dSql1 += ' WHERE A.ACTIVE_FLAG = ''Y''                                                                 ' + char(10)
                SELECT @v_dSql1 += '  AND  EXISTS (                                                                              ' + char(10)
                SELECT @v_dSql1 += '                SELECT 1                                                          ' + char(10)
                SELECT @v_dSql1 += '                FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                    ' + char(10)
                SELECT @v_dSql1 += '                WHERE  A.COMPANY_ID   = B.COMPANY_ID                                         ' + char(10)
                SELECT @v_dSql1 += '                AND    A.DIVISION_ID  = B.DIVISION_ID                                        ' + char(10)
                SELECT @v_dSql1 += '                AND    A.SITE_ID      = B.SITE_ID                                            ' + char(10)
                SELECT @v_dSql1 += '                AND    A.PLANT_ID	 = B.PLANT_ID                                            ' + char(10)
                SELECT @v_dSql1 += '                AND    A.FACTORY_ID   = B.FACTORY_ID                                         ' + char(10)
                SELECT @v_dSql1 += '                AND    A.OPERATION_ID = B.OPERATION_ID                                       ' + char(10)
                SELECT @v_dSql1 += '                AND    A.LINE_ID      = B.LINE_ID                                            ' + char(10)
                SELECT @v_dSql1 += '                AND    B.USER_ID      = '''+ @p_user_id +'''                                 ' + char(10)
                SELECT @v_dSql1 += '              )                                                                              ' + char(10)
                SELECT @v_dSql1 += ' AND EXISTS (                                                                                ' + char(10)
                SELECT @v_dSql1 += '             SELECT 1 FROM (                                                                 ' + char(10)
                SELECT @v_dSql1 += '                         SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID                          ' + char(10)
				SELECT @v_dSql1 += '                           , A.SITE_ID,A.PLANT_ID,A.FACTORY_ID                               ' + char(10)
                SELECT @v_dSql1 += '                         FROM  SCM_FACTORY_M A WITH(NOLOCK)                                  ' + char(10)
                SELECT @v_dSql1 += '                         INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                     ' + char(10)
                SELECT @v_dSql1 += '                         ON    A.FACTORY_ID=B.FACTORY_ID                                     ' + char(10)
                SELECT @v_dSql1 += '                         WHERE 1=1                                                           ' + char(10)
                SELECT @v_dSql1 += '                         AND   B.INSTANCE_ID = '''+ @param1 +'''                             ' + char(10)
                SELECT @v_dSql1 += '                         AND   A.ACTIVE_FLAG = ''Y''                                         ' + char(10)
                SELECT @v_dSql1 += '                         AND   B.ACTIVE_FLAG = ''Y''                                         ' + char(10)
                SELECT @v_dSql1 += '                        ) C                                                                  ' + char(10)
                SELECT @v_dSql1 += '             WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID                 ' + char(10)
				SELECT @v_dSql1 += '             AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID ' + char(10)
                SELECT @v_dSql1 += '           )                                                                                 ' + char(10)
	            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5))                       + char(10)
	            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6))                           + char(10)
	            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7))                       + char(10)
	            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param8))                        + char(10)
	            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param9))                      + char(10)
				
				SELECT @v_dSql2 = ''
                IF ( LEN(@param1) > 0 ) --INSTANCE
                    BEGIN
                        SELECT @v_dSql2  = ' AND EXISTS ( SELECT  1                                                      ' + char(10)
                        SELECT @v_dSql2 += '              FROM  SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)                    ' + char(10)
                        SELECT @v_dSql2 += '              WHERE LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                   ' + char(10)
                        SELECT @v_dSql2 += '              AND   LV1.SEGMENT1         = '''+ @param1 +'''                 ' + char(10)
                        SELECT @v_dSql2 += '              AND   LV1.ACTIVE_FLAG      = ''Y''                             ' + char(10)
                        SELECT @v_dSql2 += '              AND   LV1.ATTRIBUTE1       = ''BUILDING''                      ' + char(10)
                        SELECT @v_dSql2 += '              UNION ALL                                                      ' + char(10)
                        SELECT @v_dSql2 += '              SELECT  1                                                      ' + char(10)
                        SELECT @v_dSql2 += '              FROM  SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)                    ' + char(10)
                        SELECT @v_dSql2 += '              	 , SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)                     ' + char(10)
                        SELECT @v_dSql2 += '              WHERE  LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                  ' + char(10)
                        SELECT @v_dSql2 += '              AND   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''       ' + char(10)
                        SELECT @v_dSql2 += '              AND   LV1.SEGMENT1         = LV2.SEGMENT1                      ' + char(10)
                        SELECT @v_dSql2 += '              AND   LV1.SEGMENT1         = '''+ @param1 +'''                 ' + char(10)
                        SELECT @v_dSql2 += '              AND   LV1.ACTIVE_FLAG      = ''Y''                             ' + char(10)
                        SELECT @v_dSql2 += '              AND   LV1.ATTRIBUTE1       = ''PLAN GROUP''                    ' + char(10)
                        SELECT @v_dSql2 += '              AND   LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) ' + char(10)
                		SELECT @v_dSql2 += '            )                                                                ' + char(10)
                    END
               IF @Param10 <> 'Y' --LineAll Check
                    BEGIN
                        SELECT @v_dSql2 += ' AND A.LINE_ID IN (                                                     ' + char(10)
                        SELECT @v_dSql2 += '               SELECT DISTINCT LINE_ID                                  ' + char(10)
                        SELECT @v_dSql2 += '               FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK)              ' + char(10)
                        SELECT @v_dSql2 += '               WHERE 1 = 1                                              ' + char(10)
                        SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.INSTANCE_ID' , 'EQ', @param1)) + char(10)
                        SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.USER_ID' , 'EQ', @param11))    + char(10)
                        SELECT @v_dSql2 += '      )                                                                 ' + char(10)
                    END
               IF @param3 = 'RELEASE' AND  @param4 = 'PLAN GROUP'
                   BEGIN
                       SELECT @v_dSql2 += ' AND A.MODEL_TYPE IN (                                 ' + char(10)
                       SELECT @v_dSql2 += '         SELECT KK.PLAN_GROUP_ID                       ' + char(10)
                       SELECT @v_dSql2 += '         FROM   FP_RELEASE_PLAN_INFO_H KK WITH(NOLOCK) ' + char(10)
                       SELECT @v_dSql2 += '         WHERE  KK.INSTANCE_ID  = '''+ @param1 +'''    ' + char(10)
                       SELECT @v_dSql2 += '         AND KK.RELEASE_PLAN_ID = '''+ @param2 +'''    ' + char(10)
                       SELECT @v_dSql2 += '    )                                                  ' + char(10)
                   END

               SELECT @v_dSql2 += ' GROUP BY A.LINE_ID, A.LINE_NAME                               ' + char(10)
               SELECT @v_dSql2 += ' ORDER BY A.LINE_ID                                            ' + char(10)

			   SELECT @v_dSql = @v_dSql1 + @v_dSql2

			   exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00594화면에서 findOperationCode_common 정보갖고오기                                                                                      */
		/*            @Param1     @Param2      @Param3   @Param4            */
		/*   Param : INSTANCE_ID, DIVISION_ID, SITE_ID,  AMEND_MAIN_FLAG    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_findOperationCode_common' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.OPERATION_ID AS CODE                                ' + char(10)
				SELECT @v_dSql += '  , ''('' + A.OPERATION_ID + '')'' + B.OPERATION_NAME AS NAME          ' + char(10)
                SELECT @v_dSql += '  , A.AMEND_MAIN_FLAG                                                  ' + char(10)
                SELECT @v_dSql += ' FROM   FP_INSTANCE_OPERATION_V A                                      ' + char(10)
                SELECT @v_dSql += ' 	, SCM_OPERATION_M B                                               ' + char(10)
                SELECT @v_dSql += ' WHERE  A.COMPANY_ID   = B.COMPANY_ID                                  ' + char(10)
                SELECT @v_dSql += ' AND    A.DIVISION_ID  = B.DIVISION_ID                                 ' + char(10)
                SELECT @v_dSql += ' AND    A.SITE_ID      = B.SITE_ID                                     ' + char(10)
                SELECT @v_dSql += ' AND    A.OPERATION_ID = B.OPERATION_ID                                ' + char(10)
                SELECT @v_dSql += ' AND    A.INSTANCE_ID  = '''+ @param1 +'''                             ' + char(10)
                SELECT @v_dSql += ' AND    EXISTS (                                                       ' + char(10)
                SELECT @v_dSql += '                SELECT 1                                               ' + char(10)
                SELECT @v_dSql += '                FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)              ' + char(10)
                SELECT @v_dSql += '                WHERE  A.COMPANY_ID  = B.COMPANY_ID                    ' + char(10)
                SELECT @v_dSql += '                AND    A.DIVISION_ID = B.DIVISION_ID                   ' + char(10)
                SELECT @v_dSql += '                AND    A.SITE_ID     = B.SITE_ID                       ' + char(10)
                SELECT @v_dSql += '                AND    A.OPERATION_ID = B.OPERATION_ID                 ' + char(10)
                SELECT @v_dSql += '                AND    B.USER_ID     = '''+ @p_user_id +'''            ' + char(10)
                SELECT @v_dSql += '               )                                                       ' + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param2))   + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param3))       + char(10)
                SELECT @v_dSql += ' AND   A.AMEND_FLAG = ''Y''                                            ' +char(10)

                IF @param4 ='N'
				    BEGIN 
                        SELECT @v_dSql += ' AND   A.AMEND_MAIN_FLAG = ''Y'' ' +char(10)
				    END
                SELECT @v_dSql += ' ORDER BY A.OPERATION_ID DESC ' +char(10)

			   exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   FP00594화면에서 find_FPProdType 정보갖고오기                                                                                      */
		/*   Param : @Param1                  */
		/*   Param : DIVISION_ID              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_find_FPProdType' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql  = ' SELECT  DISTINCT A.ATTRIBUTE2 AS CODE, A.ATTRIBUTE2 AS NAME       ' + char(10)
                SELECT @v_dSql += ' FROM    SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                       ' + char(10)
                SELECT @v_dSql += ' WHERE   A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''             ' + char(10)
                SELECT @v_dSql += ' AND     A.ACTIVE_FLAG = ''Y''                                     ' + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @param1))  + char(10)

			    exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   FP00594화면에서 find_YieldInfo 정보갖고오기                                                                                      */
		/*   Param : @Param1     , Param2    ,@param3   , @param4,    @param5,      @param6,    @param7,    @param8             */
		/*   Param : DIVISION_ID , SITE_ID   ,PLANT_ID  , FACTORY_ID, OPERATION_ID, LINE_ID,    ITEM_ID,    PLAN_DATE          */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_find_YieldInfo' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT ISNULL(B.YIELD, (CASE WHEN A.YIELD = 0 THEN 1 ELSE A.YIELD END)) AS YIELD ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_YIELD_M A WITH(NOLOCK)                                                ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                                                                ' + char(10)
                SELECT @v_dSql += '   SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD          ' + char(10)
                SELECT @v_dSql += '   FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)                                       ' + char(10)
                SELECT @v_dSql += '   WHERE  1 = 1                                                                   ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))            + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))                + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param3))               + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param4))             + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param5))           + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param6))         + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @param7))                + char(10)
                SELECT @v_dSql += '   AND    CONVERT(DATE,'''+ @param8 +''') BETWEEN A.START_TIME AND A.END_TIME     ' + char(10)
                SELECT @v_dSql += ' ) B                                                                          ' + char(10)
                SELECT @v_dSql += ' on     1=1                                                                       ' + char(10)
                SELECT @v_dSql += '   WHERE  1 = 1                                                                   ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1))            + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))                + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param3))               + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param4))             + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param5))           + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param6))                + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'EQ', @param7))                + char(10)
                SELECT @v_dSql += '   AND    A.MONTH        = SUBSTRING('''+ @param8 +''',1,6)                       ' + char(10)

			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00594화면에서 find_ListData 정보갖고오기                                                                                      */
		/*   Param : @Param1     , Param2    ,@param3    , @param4            */
		/*   Param : MASTER_ID , PLAN_ID     ,OPERATION  , TableName         */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_find_ListData' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.INSTANCE_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.FP_PLAN_ID                    ' + char(10)
                SELECT @v_dSql += '      , A.COMPANY_ID, A.DIVISION_ID , A.CATEGORY_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID              ' + char(10)
                SELECT @v_dSql += '      , A.LINE_ID, A.OPERATION_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.ITEM_TYPE                              ' + char(10)
                SELECT @v_dSql += '      , A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.ELECTRODE_TYPE                                     ' + char(10)
                SELECT @v_dSql += '      , A.IN_QTY, A.OUT_QTY                                                                           ' + char(10)
                SELECT @v_dSql += ' FROM   '+ @param4 +'  A WITH(NOLOCK)                                                                 ' + char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID  = '''+ @param1 +'''                                                            ' + char(10)
                SELECT @v_dSql += ' AND    A.FP_PLAN_ID   = '''+ @param2 +'''                                                            ' + char(10)
                SELECT @v_dSql += ' AND    A.CATEGORY_ID  = ''PLAN''                                                                     ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param3))                                 + char(10)
                SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID ' + char(10)
                SELECT @v_dSql += ' , A.ELECTRODE_TYPE, A.ITEM_ID, A.ITEM_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE                 ' + char(10)

			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00594화면에서 find_ListData_BOH 정보갖고오기                                                                                      */
		/*   Param : @Param1     , Param2    ,@param3    , @param4            */
		/*   Param : MASTER_ID , PLAN_ID     ,PLAN_DATE  , TableName         */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_find_ListData_BOH' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql  = ' SELECT A.INSTANCE_ID, '''+ @param3 +''' AS PLAN_DATE , A.FP_PLAN_ID                                   ' + char(10)
                SELECT @v_dSql += '      , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID                                                         ' + char(10)
                SELECT @v_dSql += '      , A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, A.TOP_ITEM_ID                             ' + char(10)
                SELECT @v_dSql += '      ,  A.LOCATION, ISNULL(ISNULL(A.MODIFY_QTY, A.QTY), 0) AS QTY                                     ' + char(10)
                SELECT @v_dSql += '      , ISNULL(ISNULL(A.MODIFY_QTY, A.QTY), 0) AS ORIG_QTY, '''' AS ACTION                             ' + char(10)
                SELECT @v_dSql += ' FROM   '+ @param4  +' A WITH(NOLOCK)                                                                  ' + char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID  = '''+ @param1 +'''                                                             ' + char(10)
                SELECT @v_dSql += ' AND    A.FP_PLAN_ID   = '''+ @param2 +'''                                                             ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LOCATION ' + char(10)

			    exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   FP00594화면에서 find_SyncCalcul 정보갖고오기                                                                                      */
		/*   Param : @Param1                */
		/*   Param : MASTER_ID           */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_find_SyncCalcul' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.SEGMENT1 AS INSTANCE_ID, A.ATTRIBUTE5 AS PSI_CAL_STATUS ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A                                    ' + char(10)
                SELECT @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                      ' + char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG = ''Y''                                     ' + char(10)
                SELECT @v_dSql += ' AND    A.SEGMENT1 = '''+ @param1 +'''                            ' + char(10)

			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00594_LineAddPopup화면에서 find_LineAdd_dup 정보갖고오기                                                                                      */
		/*   Param : @Param1,      @Param2,  @Param3,    @Param4,  @Param5,  @Param6,  @Param7,  @Param8,  @Param9,  @Param10, @Param11,      @Param12, @Param13, @Param14          */
		/*   Param : INSTANCE_ID,  PLAN_ID,  PLAN_DATE , DIVISION, SITE,     PLANT,    ITEM,     TOP_ITEM, OPERATION, FACTORY, PRODUCTY_TYPE, MARKET,   LINE,     ELECTORDE_TYPE    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_find_LineAdd_dup' 
		    BEGIN	
			    SELECT @v_dSql = ''
			    SELECT @v_dSql += ' SELECT COUNT(*) AS CNT ' + char(10)
			    SELECT @v_dSql += ' FROM   FP_AMEND_PLAN_CELL_H A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID     = '''+ @param1 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.FP_PLAN_ID      = '''+ @param2 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.DIVISION_ID     = '''+ @param4 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.SITE_ID         = '''+ @param5 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.PLANT_ID        = '''+ @param6 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.ITEM_ID         = '''+ @param7 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.TOP_ITEM_ID     = '''+ @param8 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.OPERATION_ID    = '''+ @param9 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.FACTORY_ID      = '''+ @param10 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.PRODUCTION_TYPE = '''+ @param11 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.MARKET          = '''+ @param12 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.LINE_ID         = '''+ @param13 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.ELECTRODE_TYPE  = '''+ @param14 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) = '''+ @param3 +''' ' + char(10)

			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00594_LineAddPopup화면에서 find_dup 정보갖고오기                                                                                      */
		/*   Param : @Param1,      @Param2,  @Param3,    @Param4,  @Param5,  @Param6,  @Param7,  @Param8,  @Param9,  @Param10, @Param11,      @Param12, @Param13, @Param14          */
		/*   Param : INSTANCE_ID,  PLAN_ID,  PLAN_DATE , DIVISION, SITE,     PLANT,    ITEM,     TOP_ITEM, OPERATION, FACTORY, PRODUCTY_TYPE, MARKET,   LINE,     ELECTORDE_TYPE    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_find_dup' 
		    BEGIN	
			    SELECT @v_dSql = ''
			    SELECT @v_dSql += ' SELECT COUNT(*) AS CNT ' + char(10)
			    SELECT @v_dSql += ' FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID     = '''+ @param1 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.FP_PLAN_ID      = '''+ @param2 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.DIVISION_ID     = '''+ @param4 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.SITE_ID         = '''+ @param5 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.PLANT_ID        = '''+ @param6 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.ITEM_ID         = '''+ @param7 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.TOP_ITEM_ID     = '''+ @param8 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.OPERATION_ID    = '''+ @param9 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.FACTORY_ID      = '''+ @param10 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.PRODUCTION_TYPE = '''+ @param11 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.MARKET          = '''+ @param12 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.LINE_ID         = '''+ @param13 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.ELECTRODE_TYPE  = '''+ @param14 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) = '''+ @param3 +''' ' + char(10)

			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00594_LineAddPopup화면에서 find_targetInfo 정보갖고오기                                                     */
		/*   Param : @Param1,      @Param2,  @Param3,    @Param4,  @Param5,  @Param6,  @Param7,  @Param8,  @Param9,  @Param10,      @Param11,  @Param12, @Param13          */
		/*   Param : INSTANCE_ID,  PLAN_ID,  DIVISION,   SITE,     PLANT,    ITEM,     TOP_ITEM, OPERATION, FACTORY, PRODUCTY_TYPE, MARKET,    LINE,     ELECTORDE_TYPE    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00594_find_targetInfo' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.*         ' + char(10)
                SELECT @v_dSql += '     , '''' AS MSG1 ' + char(10)
                SELECT @v_dSql += '     , CASE WHEN (A.OPERATION_ID IN (''A3000'',''A9000'') AND H.MARKET IS NULL) ' + char(10)
                SELECT @v_dSql += '            OR (A.OPERATION_ID IN (''A3000'',''A9000'',''P5500'',''P9500'') AND A.PRODUCTION_TYPE = ''TEST'') THEN ''SCP or Test Target-Market'' ELSE '''' END AS MSG2 ' + char(10)
                SELECT @v_dSql += '     ,CASE WHEN R.FACTORY_ID IS NULL THEN ''Permissions'' ELSE '''' END AS MSG3 ' + char(10)
                SELECT @v_dSql += ' FROM ( ' + char(10)
                SELECT @v_dSql += '       SELECT '''+ @param1 +''' AS INSTANCE_ID ' + char(10)
                SELECT @v_dSql += '           , (SELECT COMPANY_ID FROM SCM_FACTORY_M FF WHERE FF.FACTORY_ID = '''+ @param9 +''') AS COMPANY_ID ' + char(10)
                SELECT @v_dSql += '           , '''+ @param3 +''' AS DIVISION_ID, '''+ @param4 +''' AS SITE_ID, '''+ @param5 +''' AS PLANT_ID   ' + char(10)
                SELECT @v_dSql += '           , '''+ @param6 +''' AS ITEM_ID, '''+ @param8 +''' AS OPERATION_ID, '''+ @param9 +''' AS FACTORY_ID, #LOCATION# AS LOCATION ' + char(10)
                SELECT @v_dSql += '           , '''+ @param10 +''' AS PRODUCTION_TYPE, '''+ @param11 +''' AS MARKET ' + char(10)
                SELECT @v_dSql += '           , '''+ @param12 +''' AS LINE_ID, '''+ @param13 +''' AS ELECTRODE_TYPE ' + char(10)
                SELECT @v_dSql += '           , '''+ @param7 +''' AS TOP_ITEM_ID ' + char(10)
                SELECT @v_dSql += ' ) A               ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN ( ' + char(10)
                SELECT @v_dSql += '       SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MARKET, A.ITEM_ID, (CASE WHEN A.PRODUCTION_TYPE = ''TEST'' THEN ''S-TEST'' ELSE A.PRODUCTION_TYPE END) AS PRODUCTION_TYPE ' + char(10)
                SELECT @v_dSql += '       FROM   FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '       WHERE  (A.DIVISION_ID+A.SHOP_GROUP_ID+A.SCP_PLAN_ID) IN (SELECT A.DIVISION_ID+A.SHOP_GROUP_ID+MAX(SCP_PLAN_ID) AS SCP_PLAN_ID FROM FP_WEEKLY_DEMAND_PRODUCT_H A WITH(NOLOCK) GROUP BY A.DIVISION_ID, A.SHOP_GROUP_ID) ' + char(10)
                SELECT @v_dSql += '       UNION ALL ' + char(10)
                SELECT @v_dSql += '       SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(A.MARKET,''D'') AS MARKET, A.ITEM_ID, A.PRODUCTION_TYPE ' + char(10)
                SELECT @v_dSql += '       FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '       WHERE  A.DUE_DATE >= ( SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112)) ' + char(10)
                SELECT @v_dSql += '                              FROM   SCM_FP_PLAN_H                  ' + char(10)
                SELECT @v_dSql += '   WHERE  PLAN_ID = '''+ @param2 +''' )  ' + char(10)
                SELECT @v_dSql += ' ) H ' + char(10)
                SELECT @v_dSql += ' ON  A.COMPANY_ID  = H.COMPANY_ID  ' + char(10)
                SELECT @v_dSql += ' AND A.DIVISION_ID = H.DIVISION_ID ' + char(10)
                SELECT @v_dSql += ' AND A.SITE_ID     = H.SITE_ID     ' + char(10)
                SELECT @v_dSql += ' AND A.PLANT_ID    = H.PLANT_ID    ' + char(10)
                SELECT @v_dSql += ' AND A.MARKET      = H.MARKET      ' + char(10)
                SELECT @v_dSql += ' AND A.TOP_ITEM_ID = H.ITEM_ID     ' + char(10)
                SELECT @v_dSql += ' AND A.PRODUCTION_TYPE = H.PRODUCTION_TYPE ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                         ' + char(10)
                SELECT @v_dSql += '        SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID ' + char(10)
                SELECT @v_dSql += '        FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)   ' + char(10)
                SELECT @v_dSql += '        WHERE  1=1                                ' + char(10)
                SELECT @v_dSql += '        AND    R.USER_ID	= '''+ @p_user_id +'''   ' + char(10)
                SELECT @v_dSql += '        AND    R.SAVE_FLAG	= ''Y''              ' + char(10)
                SELECT @v_dSql += '        AND    R.INSTANCE_ID  = '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += ' ) R         ' + char(10)
                SELECT @v_dSql += ' ON		1=1 ' + char(10)
                SELECT @v_dSql += ' AND		A.COMPANY_ID		= R.COMPANY_ID   ' + char(10)
                SELECT @v_dSql += ' AND		A.DIVISION_ID		= R.DIVISION_ID  ' + char(10)
                SELECT @v_dSql += ' AND		A.SITE_ID			= R.SITE_ID      ' + char(10)
                SELECT @v_dSql += ' AND		A.PLANT_ID			= R.PLANT_ID     ' + char(10)
                SELECT @v_dSql += ' AND		A.FACTORY_ID		= R.FACTORY_ID   ' + char(10)
                SELECT @v_dSql += ' AND		A.OPERATION_ID		= R.OPERATION_ID ' + char(10)
                SELECT @v_dSql += ' AND		A.LINE_ID			= R.LINE_ID      ' + char(10)

			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00595_LineAddPopup화면에서 find_dup 정보갖고오기                                                                                      */
		/*   Param : @Param1,      @Param2,  @Param3,    @Param4,  @Param5,  @Param6,  @Param7,  @Param8,  @Param9,  @Param10, @Param11,      @Param12, @Param13, @Param14          */
		/*   Param : INSTANCE_ID,  PLAN_ID,  PLAN_DATE , DIVISION, SITE,     PLANT,    ITEM,     TOP_ITEM, OPERATION, FACTORY, PRODUCTY_TYPE, MARKET,   LINE,     ELECTORDE_TYPE    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00595_find_dup' 
		    BEGIN	
			    SELECT @v_dSql = ''
			    SELECT @v_dSql += ' SELECT COUNT(*) AS CNT ' + char(10)
			    SELECT @v_dSql += ' FROM   FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID     = '''+ @param1 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.FP_PLAN_ID      = '''+ @param2 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.DIVISION_ID     = '''+ @param4 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.SITE_ID         = '''+ @param5 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.PLANT_ID        = '''+ @param6 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.ITEM_ID         = '''+ @param7 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.TOP_ITEM_ID     = '''+ @param8 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.OPERATION_ID    = '''+ @param9 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.FACTORY_ID      = '''+ @param10 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.PRODUCTION_TYPE = '''+ @param11 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.MARKET          = '''+ @param12 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.LINE_ID         = '''+ @param13 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.ELECTRODE_TYPE  = '''+ @param14 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.EQUIPMENT_ID  = '''+ @param15 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) = '''+ @param3 +''' ' + char(10)
				SELECT @v_dSql += ' AND    A.ADJUST_IN_QTY_BATCH > 0' + char(10)
			    

			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		
		/****************************************************************************************************************************************/
		/*   FP00622화면에서 find_FPNickName 정보갖고오기                                                                                      */
		/*   Param : @Param1,     @Param2, @Param3,     @Param4,   @Param5,     @Param1, @Param7,  @Param8,    @Param9,      @Param10, @Param11                */
		/*   Param : INSTANCE_ID, PLAN_ID, BUCKET_FROM, BUCKET_TO, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID,  PRODUCTION_TYPE            */
		/*   Param : @Param12 TOP_ITEM_ID, @Param13 ITEM_ID  @Param14 AMEND_TABLE, @Param15 AMEND_SALES_TABLE            */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00622_find_FPNickName' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT ISNULL(B.NICK_NAME,''-'') AS CODE, ISNULL(B.NICK_NAME,''-'') AS NAME            ' + char(10)
                SELECT @v_dSql += ' FROM (                                                                                          ' + char(10)
                SELECT @v_dSql += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                 ' + char(10)
				SELECT @v_dSql += '           , A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID                                              ' + char(10)
                SELECT @v_dSql += '       FROM   '+  @param14  +' A WITH(NOLOCK)                                            ' + char(10)
                SELECT @v_dSql += '       WHERE  A.INSTANCE_ID      = '''+ @param1 +'''                                               ' + char(10)
                SELECT @v_dSql += '       AND    A.FP_PLAN_ID       = '''+ @param2 +'''                                               ' + char(10)
                SELECT @v_dSql += '       AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' ' + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5))                + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6))                    + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7))                   + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param8))                 + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param9))               + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param10))                   + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @param11))           + char(10)
                --SELECT @v_dSql += '       AND    A.TOP_ITEM_ID LIKE ''%'' + '''+ @param12 +''' + ''%''                              ' + char(10)
    --SELECT @v_dSql += '       AND    A.ITEM_ID LIKE ''%'' + '''+ @param13 +''' + ''%''                                  ' + char(10)
                SELECT @v_dSql += '       UNION ALL                                                                                 ' + char(10)
                SELECT @v_dSql += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                                 ' + char(10)
				SELECT @v_dSql += '           , A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID                                              ' + char(10)
                SELECT @v_dSql += '       FROM   '+  @param15  +' A WITH(NOLOCK)                                            ' + char(10)
                SELECT @v_dSql += '       WHERE  A.INSTANCE_ID      = '''+ @param1 +'''                                               ' + char(10)
                SELECT @v_dSql += '       AND    A.FP_PLAN_ID       = '''+ @param2 +'''                                               ' + char(10)
                SELECT @v_dSql += '       AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param3 +''' AND '''+ @param4 +''' ' + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5))                + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6))                    + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7))                   + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param8))                 + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param9))               + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param10))                   + char(10)
                SELECT @v_dSql += '       ' +  (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @param11))           + char(10)
                --SELECT @v_dSql += '       AND    A.TOP_ITEM_ID LIKE ''%'' + '''+ @param12 +''' + ''%''                              ' + char(10)
                --SELECT @v_dSql += '       AND    A.ITEM_ID LIKE ''%'' + '''+ @param13 +''' + ''%''                                  ' + char(10)
                SELECT @v_dSql += ' ) A                                                                                             ' + char(10)
                SELECT @v_dSql += ' INNER JOIN SCM_ITEM_M B WITH(NOLOCK)                                                            ' + char(10)
                SELECT @v_dSql += ' ON     A.COMPANY_ID     = B.COMPANY_ID                                                          ' + char(10)
                SELECT @v_dSql += ' AND    A.DIVISION_ID    = B.DIVISION_ID                                                         ' + char(10)
                SELECT @v_dSql += ' AND    A.SITE_ID        = B.SITE_ID                                                             ' + char(10)
                SELECT @v_dSql += ' AND    A.ITEM_ID        = B.ITEM_ID                                                             ' + char(10)
                SELECT @v_dSql += ' ORDER BY ISNULL(B.NICK_NAME,''-'')                                                              ' + char(10)		    
				
				exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql, 'SELECT', @runstart, @runend

			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00622화면에서 find_SyncCalcul 정보갖고오기                                                                                      */
		/*   Param : @Param1,             */
		/*   Param : INSTANCE_ID,         */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00622_find_SyncCalcul' 
		    BEGIN	
			    SELECT @v_dSql = ''
			    SELECT @v_dSql += ' SELECT A.SEGMENT1 AS INSTANCE_ID, A.ATTRIBUTE5 AS PSI_CAL_STATUS ' + char(10)
			    SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
			    SELECT @v_dSql += ' AND    A.ACTIVE_FLAG = ''Y'' ' + char(10)
			    SELECT @v_dSql += ' AND    A.SEGMENT1 = '''+ @param1 +'''  ' + char(10)  
			
			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   FP00608화면에서 find_instance_add 정보갖고오기                                                                                      */
		/*   Param : @Param1,     @Param2, @Param3,     @Param4,   @Param5,     @Param1, @Param7,  @Param8,    @Param9,      @Param10, @Param11                */
		/*   Param : INSTANCE_ID, PLAN_ID, BUCKET_FROM, BUCKET_TO, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID,  PRODUCTION_TYPE            */
		/*   Param : @Param12 TOP_ITEM_ID, @Param13 ITEM_ID  @Param14 AMEND_TABLE, @Param15 AMEND_SALES_TABLE            */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00608_find_instance_add' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.SEGMENT1 AS CODE, C.SEGMENT2 AS NAME, C.INSTANCE_TYPE,C.SORT_ORDER      ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                                ' + char(10)
                SELECT @v_dSql += ' , (                                                                                       ' + char(10)
                -- TH_UIS_ROLE_FACTORY_RELATE is deprecated
    --            SELECT @v_dSql += '     SELECT C.INSTANCE_ID                                                                  ' + char(10)
    --            SELECT @v_dSql += '     FROM   TH_UIS_USER_FACTORY_RELATE A WITH(NOLOCK)                                      ' + char(10)
				--SELECT @v_dSql += '    , TH_UIS_ROLE_FACTORY_RELATE B WITH(NOLOCK), FP_INSTANCE_FACTORY_M C WITH(NOLOCK)      ' + char(10)
    --            SELECT @v_dSql += '     WHERE  A.USER_ID     = '''+ @p_user_id +'''                                           ' + char(10)
    --            SELECT @v_dSql += '     AND    A.ROLE_ID     = B.ROLE_ID                                                      ' + char(10)
    --            SELECT @v_dSql += '     AND    B.FACTORY_ID  = C.FACTORY_ID                                                   ' + char(10)
    --            SELECT @v_dSql += '     AND    A.USE_AT_FLAG = ''Y''                                                          ' + char(10)
    --            SELECT @v_dSql += '     AND    B.USE_AT_FLAG = ''Y''                                                          ' + char(10)
    --            SELECT @v_dSql += '     AND    C.ACTIVE_FLAG = ''Y''                                                          ' + char(10)
    --            SELECT @v_dSql += '     GROUP BY C.INSTANCE_ID                                                                ' + char(10)

				SELECT @v_dSql += ' SELECT DISTINCT INSTANCE_ID ' + char(10)
				SELECT @v_dSql += 'FROM FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
				SELECT @v_dSql += 'WHERE 1=1 ' + char(10)
				SELECT @v_dSql += 'AND R.USER_ID= '''+ @p_user_id +'''' + char(10)
				SELECT @v_dSql += 'AND R.SAVE_FLAG = ''Y''' + char(10)

                SELECT @v_dSql += ' ) B ,(                                                                                    ' + char(10)
                SELECT @v_dSql += '     SELECT SEGMENT1 AS INSTANCE_ID, SEGMENT2, ATTRIBUTE9 AS INSTANCE_TYPE ,SORT_ORDER AS SORT_ORDER                ' + char(10)
                SELECT @v_dSql += '     FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                                            ' + char(10)
                SELECT @v_dSql += '     WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                           ' + char(10)
                SELECT @v_dSql += '     AND    A.ACTIVE_FLAG = ''Y''                                                          ' + char(10)
                SELECT @v_dSql += ' ) C                                                                                       ' + char(10)
    SELECT @v_dSql += ' WHERE  A.SEGMENT1 = B.INSTANCE_ID                                                         ' + char(10)
                SELECT @v_dSql += ' AND    A.SEGMENT1 = C.INSTANCE_ID                                                         ' + char(10)
                SELECT @v_dSql += ' AND    A.LOOKUP_TYPE_CODE = ''INSTANCE AMEND UI''                                         ' + char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG = ''Y''                                                              ' + char(10)
                SELECT @v_dSql += ' AND    ((A.ATTRIBUTE3 IN(''PSI_AMEND_CELL'',''PSI_AMEND_E_PMIX'',''PSI_AMEND_E_PRE''      ' + char(10)
				SELECT @v_dSql += '     ,''PSI_AMEND_FORM'',''PSI_AMEND_PACK'',''PSI_AMEND_POUCH'') AND A.ATTRIBUTE4 = ''Y'') ' + char(10)
                SELECT @v_dSql += '   OR (A.ATTRIBUTE5 IN(''LINE_AMEND_CELL'',''LINE_AMEND_E_PMIX'',''LINE_AMEND_E_PRE''      ' + char(10)
				SELECT @v_dSql += '        ,''LINE_AMEND_FORM'',''LINE_AMEND_PACK'') AND A.ATTRIBUTE6 = ''Y''))               ' + char(10)
                SELECT @v_dSql += ' ORDER BY C.SORT_ORDER                                                                              ' + char(10)
			
			 --   SELECT @v_dSql as SQL
				--RETURN
			    exec sp_executesql @v_dSql
		   END

		/****************************************************************************************************************************************/
		/*   FP00603화면에서 FP00603_findInstanceList_common 정보갖고오기                                                                                      */
		/*   Param : @Param1              */
		/*   Param :                      */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00603_findInstanceList_common' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER                     ' + char(10)
                SELECT @v_dSql += '    , B.ATTRIBUTE3 AS USE_WOW_STATUS                                                ' + char(10)
                SELECT @v_dSql += '    , B.ATTRIBUTE1 AS CONFIRM_AREA                                                  ' + char(10)
                SELECT @v_dSql += '    , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID                                               ' + char(10)
                SELECT @v_dSql += ' FROM (                                                                             ' + char(10)
                SELECT @v_dSql += '        SELECT DISTINCT B.INSTANCE_ID                                               ' + char(10)
                SELECT @v_dSql += '        FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                   ' + char(10)
                SELECT @v_dSql += '        WHERE  B.USER_ID     = '''+ @p_user_id +'''                                 ' + char(10)
                SELECT @v_dSql += '      ) A, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)                                      ' + char(10)
                SELECT @v_dSql += ' WHERE A.INSTANCE_ID      = B.SEGMENT1                                              ' + char(10)
                SELECT @v_dSql += ' AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                         ' + char(10)
                SELECT @v_dSql += ' AND   B.SEGMENT1 IN (                                                              ' + char(10)
                SELECT @v_dSql += '                      SELECT INSTANCE_ID                                            ' + char(10)
     SELECT @v_dSql += '                      FROM FP_AMEND_UI_V                                            ' + char(10)
                SELECT @v_dSql += '                      WHERE 1=1                                                     ' + char(10)
                SELECT @v_dSql += '                      AND AMEND_UI_NAME IN (''PSI_AMEND_CELL'',''PSI_AMEND_POUCH'') ' + char(10)
                SELECT @v_dSql += '                      AND USE_FLAG = ''Y''                                          ' + char(10)
                SELECT @v_dSql += '                     )                                                              ' + char(10)
                SELECT @v_dSql += ' ORDER BY B.SORT_ORDER                                                              ' + char(10)
			
			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   FP00603화면에서 findLineCode_List 정보갖고오기                                                                                      */
		/*            @Param1     @Param2,  @Param3,    @Param4,       @Param5,     @Param6,  @Param7,   @Param8,    @Param9,       ,@Param10,  @Param11, @Param12  */
		/*   Param : INSTANCE_ID, PLAN_ID,  PLAN_TYPE,  CONFIRM_AREA,  DIVISION_ID, SITE_ID,  PLANT_ID,  FACTORY_ID, OPERATION_ID,   IN_ACT,    ALL_LINE,   USER_LT   */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00603_findLineCode_List' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.LINE_ID AS CODE         ' + char(10)
                SELECT @v_dSql += '      , ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_LINE_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE 1=1                        ' + char(10)
                IF ( @param10 <> 'Y' ) --INACTIVE
                    BEGIN
					    SELECT @v_dSql += ' AND  A.ACTIVE_FLAG = ''Y''  ' + char(10)
					END

                SELECT @v_dSql += ' AND  EXISTS (                                          ' + char(10)
                SELECT @v_dSql += '             SELECT 1                                   ' + char(10)
                SELECT @v_dSql += '             FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)  ' + char(10)
                SELECT @v_dSql += '             WHERE  A.COMPANY_ID  = B.COMPANY_ID        ' + char(10)
                SELECT @v_dSql += '             AND    A.DIVISION_ID = B.DIVISION_ID       ' + char(10)
                SELECT @v_dSql += '             AND    A.SITE_ID     = B.SITE_ID           ' + char(10)
                SELECT @v_dSql += '             AND    A.PLANT_ID	  = B.PLANT_ID          ' + char(10)
                SELECT @v_dSql += '             AND    A.FACTORY_ID  = B.FACTORY_ID        ' + char(10)
                SELECT @v_dSql += '             AND    A.OPERATION_ID = B.OPERATION_ID     ' + char(10)

                IF ( @param10 <> 'Y' ) --IN_ACT
                    BEGIN
			    	    SELECT @v_dSql += '             AND  A.LINE_ID  =  B.LINE_ID        ' + char(10)
			    	END

                SELECT @v_dSql += '             AND  B.USER_ID  = '''+ @p_user_id +'''     ' + char(10)
                SELECT @v_dSql += ' 	  )                                                 ' + char(10)
                SELECT @v_dSql += ' AND  EXISTS (                                          ' + char(10)
                SELECT @v_dSql += '              SELECT 1                                  ' + char(10)
                SELECT @v_dSql += ' 	          FROM (                                    ' + char(10)
                SELECT @v_dSql += '                    SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID  ' + char(10)
                SELECT @v_dSql += '                    FROM  SCM_FACTORY_M A WITH(NOLOCK)                                            ' + char(10)
                SELECT @v_dSql += '                    INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)        ' + char(10)
                SELECT @v_dSql += '                    ON    A.FACTORY_ID=B.FACTORY_ID                                               ' + char(10)
                SELECT @v_dSql += '                    WHERE B.INSTANCE_ID = '''+ @param1 +'''                                       ' + char(10)
                SELECT @v_dSql += '                    AND   A.ACTIVE_FLAG = ''Y''                                                   ' + char(10)
                SELECT @v_dSql += '                    AND   B.ACTIVE_FLAG = ''Y''                                                   ' + char(10)
                SELECT @v_dSql += '              ) C                                                                                 ' + char(10)
                SELECT @v_dSql += '              WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID = A.DIVISION_ID                   ' + char(10) 
                SELECT @v_dSql += ' 			  AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID = A.FACTORY_ID   ' + char(10)
                SELECT @v_dSql += ' )  ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5))                       + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6))                           + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7))                          + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param8))                        + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param9))                      + char(10)

                IF ( LEN(@param1) > 0 ) --INSTANCE
				    BEGIN
                        SELECT @v_dSql += ' AND EXISTS ( SELECT  1                                        ' + char(10)
                        SELECT @v_dSql += '              FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)    ' + char(10)
                        SELECT @v_dSql += '              WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''   ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = '''+ @param1 +''' ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ACTIVE_FLAG      = ''Y''             ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ATTRIBUTE1       = ''BUILDING''      ' + char(10)
                        SELECT @v_dSql += '              UNION ALL                                        ' + char(10)
                        SELECT @v_dSql += '              SELECT  1                                        ' + char(10)
                        SELECT @v_dSql += '              FROM  SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)      ' + char(10)
                        SELECT @v_dSql += '                   ,SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)      ' + char(10)
                        SELECT @v_dSql += '              WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''   ' + char(10)
                        SELECT @v_dSql += '              AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''        ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = LV2.SEGMENT1                        ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = '''+ @param1 +'''                   ' + char(10)
                        SELECT @v_dSql += '              AND  LV1.ACTIVE_FLAG      = ''Y''                               ' + char(10);
                        SELECT @v_dSql += '              AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''                      ' + char(10)
                        SELECT @v_dSql += '              AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2)   ' + char(10)
				        SELECT @v_dSql += '            )                                                                    ' + char(10)
                    END

                IF ( @param11 <> 'Y' ) --ALL_LINECHECK
				    BEGIN 
                        SELECT @v_dSql += ' AND A.LINE_ID IN (                                                 ' + char(10)
                        SELECT @v_dSql += '     SELECT DISTINCT LINE_ID                                        ' + char(10)
                        SELECT @v_dSql += '     FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK)                    ' + char(10)
                        SELECT @v_dSql += '     WHERE  AA.INSTANCE_ID = '''+ @param1 +'''                      ' + char(10)
						SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.USER_ID' , 'EQ', @p_user_id))  + char(10)
                        SELECT @v_dSql += ' )                                                                  ' + char(10)
				    END

                IF ( LEN(@param1) > 0 ) --INSTANCE
				    BEGIN
                        SELECT @v_dSql += ' AND EXISTS (                                 ' + char(10)
                        SELECT @v_dSql += '      SELECT 1                                ' + char(10)
                        SELECT @v_dSql += '      FROM FP_INSTANCE_LINE_V AA              ' + char(10)
                        SELECT @v_dSql += '      WHERE ( AA.INSTANCE_ID IN               ' + char(10)
                        SELECT @v_dSql += '                ( SELECT A.SEGMENT2	          ' + char(10)
                        SELECT @v_dSql += '                  FROM SCM_SYS_LOOKUP_VALUE A ' + char(10)
                        SELECT @v_dSql += '                  WHERE A.LOOKUP_TYPE_CODE = ''INSTANCE_AMEND_LINE_VIEW'' ' + char(10)	
                        SELECT @v_dSql += '                  AND A.SEGMENT1 = '''+ @param1 +''' ' + char(10)
                        SELECT @v_dSql += '                 )                                   ' + char(10)
                        SELECT @v_dSql += '              OR AA.INSTANCE_ID = '''+ @param1 +'''  ' + char(10)
                        SELECT @v_dSql += ' 		  )                                          ' + char(10)
                        SELECT @v_dSql += '        AND A.DIVISION_ID  = AA.DIVISION_ID          ' + char(10)		
                        SELECT @v_dSql += '        AND A.SITE_ID      = AA.SITE_ID              ' + char(10)			
                        SELECT @v_dSql += '        AND A.PLANT_ID     = AA.PLANT_ID             ' + char(10)			
                        SELECT @v_dSql += '        AND A.FACTORY_ID   = AA.FACTORY_ID           ' + char(10)		
                        SELECT @v_dSql += '        AND A.OPERATION_ID = AA.OPERATION_ID         ' + char(10)		
                        SELECT @v_dSql += '        AND A.LINE_ID      = AA.LINE_ID              ' + char(10)			
                        SELECT @v_dSql += '      )                                              ' + char(10)
					END
               SELECT @v_dSql += ' GROUP BY A.LINE_ID, A.LINE_NAME                              ' + char(10)
               SELECT @v_dSql += ' ORDER BY A.LINE_ID                                           ' + char(10)

			   --SELECT @v_dSql
			   exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   FP00603화면에서 FP00603_findFpPlan_info 정보갖고오기                                                                               */
		/*   Param : @Param1,  @Param2             */
		/*   Param : INSTANCE, PLAN_DATE              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00603_findFpPlan_info' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.PLAN_ID AS CODE       ' + char(10)
				SELECT @v_dSql += '    , SUBSTRING(PLAN_ID,CHARINDEX(''-'',PLAN_ID)+1,11) AS NAME ' + char(10)
                SELECT @v_dSql += '    ,A.PLAN_ID, A.PLAN_TYPE, A.PLAN_START_TIME                 ' + char(10)
                SELECT @v_dSql += '    ,A.PLAN_HORIZON, A.PLAN_HORIZON_UOM, A.DEMAND_HORIZON      ' + char(10)
                SELECT @v_dSql += '    ,A.DEMAND_HORIZON_UOM, A.CONFIG_SET_ID, A.BASIS_PLAN_ID    ' + char(10)
                SELECT @v_dSql += '    ,A.DEMAND_PLAN_ID, A.SCP_PLAN_ID, A.PLAN_WEEK              ' + char(10)
                SELECT @v_dSql += '    ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS PLAN_START_DATE ' + char(10)
                SELECT @v_dSql += '    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS PLAN_END_DATE ' + char(10)
                SELECT @v_dSql += '    ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS DEFAULT_START_DATE ' + char(10)
                SELECT @v_dSql += '    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS DEFAULT_END_DATE ' + char(10)
                SELECT @v_dSql += '    ,A.INSTANCE_ID ,A.SITE_ID  ,A.DESCRIPTION ,A.PLAN_TYPE ' + char(10)
                SELECT @v_dSql += ' FROM  SCM_FP_PLAN_H A WITH(NOLOCK)                        ' + char(10)
				SELECT @v_dSql += '     ,(                                                    ' + char(10)
                SELECT @v_dSql += '       SELECT C.INSTANCE_ID                                ' + char(10)
                SELECT @v_dSql += '       FROM TH_UIS_USER_FACTORY_RELATE A WITH(NOLOCK)      ' + char(10)
				SELECT @v_dSql += '          , TH_UIS_ROLE_FACTORY_RELATE B WITH(NOLOCK)      ' + char(10)
				SELECT @v_dSql += '          , FP_INSTANCE_FACTORY_M C WITH(NOLOCK)           ' + char(10)
                SELECT @v_dSql += '       WHERE  A.USER_ID     = '''+ @p_user_id +'''         ' + char(10)
                SELECT @v_dSql += '       AND    A.ROLE_ID     = B.ROLE_ID                    ' + char(10)
                SELECT @v_dSql += '       AND    B.FACTORY_ID  = C.FACTORY_ID                 ' + char(10)
                SELECT @v_dSql += '       AND    A.USE_AT_FLAG = ''Y''                        ' + char(10)
                SELECT @v_dSql += '       AND    B.USE_AT_FLAG = ''Y''                        ' + char(10)
                SELECT @v_dSql += '       AND    C.ACTIVE_FLAG = ''Y''                        ' + char(10)
                SELECT @v_dSql += '       GROUP BY C.INSTANCE_ID                              ' + char(10)
                SELECT @v_dSql += '    ) B                                                    ' + char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = B.INSTANCE_ID                      ' + char(10)
                SELECT @v_dSql += '  AND    A.INSTANCE_ID = '''+ @param1 +'''                 ' + char(10)
                SELECT @v_dSql += '  AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) BETWEEN '''+ @param2 +''' - 3 AND '''+ @param2 +''' ' + char(10)
                SELECT @v_dSql += ' ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC ' + char(10)
			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   FP00603화면에서 find_FPProdType 정보갖고오기                                                                                      */
		/*   Param : @Param1   ,  @Param2                */
		/*   Param : INSTANCE_ID, DIVISION_ID              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00603_find_FPProdType' 
		    BEGIN	
			    SELECT @v_dSql  = ''
                SELECT @v_dSql += ' SELECT  DISTINCT A.ATTRIBUTE2 AS CODE, A.ATTRIBUTE2 AS NAME         ' + char(10)
                SELECT @v_dSql += ' FROM    SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                         ' + char(10)
                SELECT @v_dSql += ' WHERE   A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''               ' + char(10)
                SELECT @v_dSql += ' AND     A.ACTIVE_FLAG = ''Y''                                       ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @param1))  + char(10)

				IF(@param1 ='KR_CELL')
				    BEGIN
					    SELECT @v_dSql += ' UNION ALL SELECT ''M/C'' AS CODE, ''M/C'' AS NAME           ' + char(10)
					END
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00603화면에서 find_currDateCol 정보갖고오기                                                                                      */
		/*   Param :@param1	,    @param2,      @param3																						    */
		/*   Param :INSTANCE_ID, BUCKET_FROM , BUCKET_TO   																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00603_find_currDateCol'

			BEGIN
			    --2026-03-03 E20251119-001047 yyyyMMddHHmmss BugFix
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT A.D_COL, B.CURR_DATE                                                             ' + char(10)
                SELECT @v_dSql += ' FROM (                                                                                  ' + char(10)
                SELECT @v_dSql += '       SELECT ''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS D_COL ' + char(10)
                SELECT @v_dSql += '            , A.YYYYMMDD AS D_VALUE                                                      ' + char(10)
                SELECT @v_dSql += '       FROM   TH_UIS_CAL A WITH(NOLOCK)                                                  ' + char(10)
                SELECT @v_dSql += '       WHERE A.YYYYMMDD BETWEEN '''+ @param2 +''' AND '''+ @param3 +'''                  ' + char(10)
                SELECT @v_dSql += ' ) A                                                                                     ' + char(10)
                SELECT @v_dSql += ' INNER JOIN (                                                                            ' + char(10)
                SELECT @v_dSql += '       SELECT CASE WHEN FORMAT(DBO.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < CONVERT(VARCHAR,DBO.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME  ' + char(10)
                SELECT @v_dSql += '                   THEN CONVERT(VARCHAR, DATEADD(DD,-1,DBO.FN_SITE_TIME(B.SITE_ID)), 112)   ' + char(10)
                SELECT @v_dSql += '                   ELSE CONVERT(VARCHAR, DBO.FN_SITE_TIME(B.SITE_ID), 112) END AS CURR_DATE ' + char(10)
                SELECT @v_dSql += '       FROM   FP_INSTANCE_START_TIME_V A                                                    ' + char(10)
                SELECT @v_dSql += '           , ( SELECT MAX(B.SITE_ID) AS SITE_ID                                             ' + char(10)
                SELECT @v_dSql += '               FROM FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += '               WHERE  A.FACTORY_ID = B.FACTORY_ID       ' + char(10)
                SELECT @v_dSql += '               AND    A.ACTIVE_FLAG = ''Y''             ' + char(10)
                SELECT @v_dSql += '               AND    B.ACTIVE_FLAG = ''Y''             ' + char(10)
                SELECT @v_dSql += '               AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += '       ) B                                              ' + char(10)
                SELECT @v_dSql += '       WHERE  A.INSTANCE_ID = '''+ @param1 +'''         ' + char(10)
                SELECT @v_dSql += ' ) B                                                    ' + char(10)
                SELECT @v_dSql += ' ON    A.D_VALUE = B.CURR_DATE                          ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00603화면에서 find_day2WeekAndMonth 정보갖고오기                                                                                      */
		/*   Param :@param1	,    @param2,      																						    */
		/*   Param :BUCKET_FROM, BUCKET_TO    																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00603_find_day2WeekAndMonth'

			BEGIN
                IF isnull(@param3,'') = 'SUN'
                BEGIN
                    SELECT @v_dSql = ''  
                    SELECT @v_dSql += ' SELECT ''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS D_COL   ' + char(10)
                    SELECT @v_dSql += '      , ''W'' + CONVERT(VARCHAR,(DENSE_RANK() OVER(ORDER BY YYYYWW))-1) AS W_COL ' + char(10)
                    SELECT @v_dSql += '      , ''M'' + CONVERT(VARCHAR,(DENSE_RANK() OVER(ORDER BY YYYYMM))-1) AS M_COL     ' + char(10)
                    SELECT @v_dSql += ' FROM   TH_UIS_CAL A WITH(NOLOCK)                                                    ' + char(10)
                    SELECT @v_dSql += ' WHERE  YYYYMMDD BETWEEN '''+ @param1 +''' AND '''+ @param2 +'''                     ' + char(10)
                END
                ELSE BEGIN
                    SELECT @v_dSql = ''  
                    SELECT @v_dSql += ' SELECT ''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS D_COL   ' + char(10)
                    SELECT @v_dSql += '      , ''W'' + CONVERT(VARCHAR,(DENSE_RANK() OVER(ORDER BY ISO_YYYYWW))-1) AS W_COL ' + char(10)
                    SELECT @v_dSql += '      , ''M'' + CONVERT(VARCHAR,(DENSE_RANK() OVER(ORDER BY YYYYMM))-1) AS M_COL     ' + char(10)
                    SELECT @v_dSql += ' FROM   TH_UIS_CAL A WITH(NOLOCK)                                                    ' + char(10)
                    SELECT @v_dSql += ' WHERE  YYYYMMDD BETWEEN '''+ @param1 +''' AND '''+ @param2 +'''                     ' + char(10)
                END
				exec sp_executesql @v_dSql
			END
		
		    --SET @runstart = GetDate()
		    --SET @runend = GetDate()
		    --EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_code,'', @v_dSql,'SELECT',@runstart, @runend

		/****************************************************************************************************************************************/
		/*   FP00604화면에서 findLineCode_List 정보갖고오기                                                                                      */
		/*            @Param1     @Param2,  @Param3,    @Param4,       @Param5,     @Param6,  @Param7,   @Param8,    @Param9,       ,@Param10,  @Param11, @Param12  */
		/*   Param : INSTANCE_ID, PLAN_ID,  PLAN_TYPE,  CONFIRM_AREA,  DIVISION_ID, SITE_ID,  PLANT_ID,  FACTORY_ID, OPERATION_ID,   IN_ACT,    ALL_LINE,   USER_LT   */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00604_findLineCode_List' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.LINE_ID AS CODE         ' + char(10)
                SELECT @v_dSql += '      , ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_LINE_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE 1=1                        ' + char(10)
                IF ( @param10 <> 'Y' ) --INACTIVE
                    BEGIN
					    SELECT @v_dSql += ' AND  A.ACTIVE_FLAG = ''Y''  ' + char(10)
					END

                SELECT @v_dSql += ' AND  EXISTS (                            ' + char(10)
                SELECT @v_dSql += '             SELECT 1                                   ' + char(10)
                SELECT @v_dSql += '             FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)  ' + char(10)
                SELECT @v_dSql += '             WHERE  A.COMPANY_ID  = B.COMPANY_ID        ' + char(10)
                SELECT @v_dSql += '             AND    A.DIVISION_ID = B.DIVISION_ID       ' + char(10)
                SELECT @v_dSql += '             AND    A.SITE_ID     = B.SITE_ID           ' + char(10)
                SELECT @v_dSql += '             AND    A.PLANT_ID	  = B.PLANT_ID          ' + char(10)
                SELECT @v_dSql += '             AND    A.FACTORY_ID  = B.FACTORY_ID        ' + char(10)
                SELECT @v_dSql += '             AND    A.OPERATION_ID = B.OPERATION_ID     ' + char(10)

                IF ( @param10 <> 'Y' ) --IN_ACT
                    BEGIN
			    	    SELECT @v_dSql += '             AND  A.LINE_ID  =  B.LINE_ID        ' + char(10)
			    	END

                SELECT @v_dSql += '             AND  B.USER_ID  = '''+ @p_user_id +'''     ' + char(10)
                SELECT @v_dSql += ' 	  )                                                 ' + char(10)
                SELECT @v_dSql += ' AND  EXISTS (                                          ' + char(10)
                SELECT @v_dSql += '              SELECT 1                                  ' + char(10)
                SELECT @v_dSql += ' 	          FROM (                                    ' + char(10)
                SELECT @v_dSql += '                    SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID  ' + char(10)
                SELECT @v_dSql += '                    FROM  SCM_FACTORY_M A WITH(NOLOCK)                                            ' + char(10)
                SELECT @v_dSql += '                    INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                               ' + char(10)
                SELECT @v_dSql += '                    ON    A.FACTORY_ID=B.FACTORY_ID                                               ' + char(10)
                SELECT @v_dSql += '                    WHERE B.INSTANCE_ID = '''+ @param1 +'''                                       ' + char(10)
                SELECT @v_dSql += '                    AND   A.ACTIVE_FLAG = ''Y''                                                   ' + char(10)
                SELECT @v_dSql += '                    AND   B.ACTIVE_FLAG = ''Y''                                                   ' + char(10)
                SELECT @v_dSql += '              ) C                                                                                 ' + char(10)
                SELECT @v_dSql += '              WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID = A.DIVISION_ID                   ' + char(10) 
                SELECT @v_dSql += ' 			  AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID = A.FACTORY_ID   ' + char(10)
                SELECT @v_dSql += ' )  ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5))                       + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6))                           + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7))                          + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param8))                        + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param9))                      + char(10)

                IF ( LEN(@param1) > 0 ) --INSTANCE
				    BEGIN
                        SELECT @v_dSql += ' AND EXISTS ( SELECT  1                                        ' + char(10)
                        SELECT @v_dSql += '              FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)    ' + char(10)
                        SELECT @v_dSql += '              WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''   ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = '''+ @param1 +''' ' + char(10)
                        SELECT @v_dSql += '      AND     LV1.ACTIVE_FLAG      = ''Y''             ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ATTRIBUTE1       = ''BUILDING''      ' + char(10)
                        SELECT @v_dSql += '              UNION ALL                                        ' + char(10)
                        SELECT @v_dSql += '              SELECT  1                                        ' + char(10)
                        SELECT @v_dSql += '              FROM  SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)      ' + char(10)
                        SELECT @v_dSql += '                   ,SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)      ' + char(10)
                        SELECT @v_dSql += '              WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''   ' + char(10)
                        SELECT @v_dSql += '              AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''        ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = LV2.SEGMENT1                        ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = '''+ @param1 +'''                   ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ACTIVE_FLAG      = ''Y''                               ' + char(10);
                        SELECT @v_dSql += '              AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''                      ' + char(10)
                        SELECT @v_dSql += '              AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2)   ' + char(10)
				        SELECT @v_dSql += '            )                                                                    ' + char(10)
                    END

                IF ( @param11 <> 'Y' ) --ALL_LINECHECK
				    BEGIN 
                        SELECT @v_dSql += ' AND A.LINE_ID IN (                                                 ' + char(10)
                        SELECT @v_dSql += '     SELECT DISTINCT LINE_ID                                        ' + char(10)
                        SELECT @v_dSql += '     FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK)                    ' + char(10)
                        SELECT @v_dSql += '     WHERE  AA.INSTANCE_ID = '''+ @param1 +'''                      ' + char(10)
						SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.USER_ID' , 'EQ', @p_user_id))  + char(10)
                        SELECT @v_dSql += ' )                                                                  ' + char(10)
				    END

                SELECT @v_dSql += ' GROUP BY A.LINE_ID, A.LINE_NAME                              ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.LINE_ID                                           ' + char(10)

			   --SELECT @v_dSql
			   exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00626화면에서 findInstanceList_common 정보갖고오기                                                                                      */
		/*   Param :@param1	,    @param2,      @param3																						    */
		/*   Param :  																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00626_findInstanceList_common'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER ' + char(10)
                SELECT @v_dSql += '      , B.ATTRIBUTE3 AS USE_WOW_STATUS                  ' + char(10)
                SELECT @v_dSql += '      , B.ATTRIBUTE1 AS CONFIRM_AREA                    ' + char(10)
                SELECT @v_dSql += '      , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID                 ' + char(10)
                SELECT @v_dSql += '      , C.SITE_ID                                       ' + char(10)
                SELECT @v_dSql += ' FROM (                                                 ' + char(10)
                SELECT @v_dSql += '      SELECT DISTINCT A.INSTANCE_ID                     ' + char(10)
                SELECT @v_dSql += '      FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)         ' + char(10)
                SELECT @v_dSql += '      WHERE  USER_ID = '''+ @p_user_id +'''             ' + char(10)
                SELECT @v_dSql += '     ) A                                                ' + char(10)
				SELECT @v_dSql += '     , SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)              ' + char(10)
				SELECT @v_dSql += '     , (                                                ' + char(10)
                SELECT @v_dSql += '        SELECT B.INSTANCE_ID, MAX(A.SITE_ID) AS SITE_ID ' + char(10)
                SELECT @v_dSql += '        FROM   SCM_FACTORY_M A WITH(NOLOCK), FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '        WHERE  A.FACTORY_ID  = B.FACTORY_ID         ' + char(10)
                SELECT @v_dSql += '        AND    A.ACTIVE_FLAG = ''Y''                ' + char(10)
                SELECT @v_dSql += '        AND    B.ACTIVE_FLAG = ''Y''                ' + char(10)
                SELECT @v_dSql += '        GROUP BY B.INSTANCE_ID                      ' + char(10)
                SELECT @v_dSql += '     ) C                                            ' + char(10)
                SELECT @v_dSql += ' WHERE A.INSTANCE_ID      = B.SEGMENT1              ' + char(10)
                SELECT @v_dSql += ' AND   A.INSTANCE_ID      = C.INSTANCE_ID           ' + char(10)
                SELECT @v_dSql += ' AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''         ' + char(10)
                SELECT @v_dSql += ' AND   B.SEGMENT1 IN (                              ' + char(10)
                SELECT @v_dSql += ' 		SELECT INSTANCE_ID                         ' + char(10)
                SELECT @v_dSql += ' 		FROM   FP_AMEND_UI_V                       ' + char(10)
                SELECT @v_dSql += ' 		WHERE  AMEND_UI_NAME = '''+ @param1 +'''   ' + char(10)
                SELECT @v_dSql += ' 		AND    USE_FLAG = ''Y''                    ' + char(10)
                SELECT @v_dSql += ' 		AND	 	 (INSTANCE_ID NOT LIKE ''CN_CELL_M%'' AND INSTANCE_ID <> ''KR_CELL_A2'') ' + char(10)
                SELECT @v_dSql += ' )                     ' + char(10)
                SELECT @v_dSql += ' ORDER BY B.SORT_ORDER ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00626화면에서 find_isPast 정보갖고오기                                                                                      */
		/*   Param :@param1	,    @param2,      @param3																						    */
		/*   Param :INSTANCE_ID																				*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00626_find_isPast'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT AA.* ' + char(10)
                SELECT @v_dSql += '     , (SELECT DATED1 FROM TH_UIS_CALENDAR T1 WITH(NOLOCK) WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = AA.CURR_DATE)) AS PLAN_START_DATE ' + char(10)
                SELECT @v_dSql += '     , CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR _T2 WITH(NOLOCK) WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = AA.CURR_DATE)))), 112) AS PLAN_END_DATE ' + char(10)
                SELECT @v_dSql += ' FROM (                        ' + char(10)
                SELECT @v_dSql += '     SELECT A.BASIS_START_TIME ' + char(10)
                SELECT @v_dSql += '   		   , CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < CONVERT(VARCHAR,dbo.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME  ' + char(10)
                SELECT @v_dSql += '   				  THEN CONVERT(VARCHAR, DATEADD(DD,-1,dbo.FN_SITE_TIME(B.SITE_ID)), 112)   ' + char(10)
                SELECT @v_dSql += '   				  ELSE CONVERT(VARCHAR, dbo.FN_SITE_TIME(B.SITE_ID), 112) END AS CURR_DATE ' + char(10)
                SELECT @v_dSql += '     FROM   FP_INSTANCE_START_TIME_V A, (     ' + char(10)
                SELECT @v_dSql += '     		SELECT MAX(B.SITE_ID) AS SITE_ID ' + char(10)
                SELECT @v_dSql += '     		FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '     		WHERE  A.FACTORY_ID = B.FACTORY_ID       ' + char(10)
                SELECT @v_dSql += '     		AND    A.ACTIVE_FLAG = ''Y''             ' + char(10)
                SELECT @v_dSql += '     		AND    B.ACTIVE_FLAG = ''Y''             ' + char(10)
                SELECT @v_dSql += '     		AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += ' 	  ) B                                            ' + char(10)
                SELECT @v_dSql += '     WHERE  A.INSTANCE_ID = '''+ @param1 +'''         ' + char(10)
                SELECT @v_dSql += ' ) AA ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00626화면에서 findFpPlan_info 정보갖고오기                                                                                      */
		/*   Param :@param1	,    @param2,      @param3																						    */
		/*   Param :INSTANCE_ID, PLAN_DATE																				*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00626_findFpPlan_info'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' WITH RELEASE_PLAN AS ( ' + char(10)
                SELECT @v_dSql += '    SELECT DISTINCT     ' + char(10)
                SELECT @v_dSql += '         A.INSTANCE_ID  ' + char(10)
                SELECT @v_dSql += '        ,A.RELEASE_PLAN_ID AS PLAN_ID            ' + char(10)
                SELECT @v_dSql += '        ,STUFF(( SELECT '','' + FACTORY_ID       ' + char(10)
                SELECT @v_dSql += '                 FROM   FP_RELEASE_PLAN_INFO_H B ' + char(10)
                SELECT @v_dSql += '                 WHERE  A.INSTANCE_ID     = B.INSTANCE_ID     ' + char(10)
                SELECT @v_dSql += '                 AND    A.INSTANCE_DATE   = B.INSTANCE_DATE   ' + char(10)
                SELECT @v_dSql += '                 AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID ' + char(10)
                SELECT @v_dSql += '                 FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT ' + char(10)
                SELECT @v_dSql += '        ,A.PLAN_GROUP_ID              ' + char(10)
                SELECT @v_dSql += '        ,A.INSTANCE_DATE AS PLAN_DATE ' + char(10)
                SELECT @v_dSql += '    FROM   FP_RELEASE_PLAN_INFO_H A   ' + char(10)
                SELECT @v_dSql += '    WHERE  1=1                        ' + char(10)
				
				IF(LEN(@param1) > 0 )
				    BEGIN
                        SELECT @v_dSql += '    AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
					END
                IF(LEN(@param2) > 0 )
				    BEGIN
                        SELECT @v_dSql += '    AND  A.INSTANCE_DATE  = '''+ @param2 +''' ' + char(10)
					END
                
                SELECT @v_dSql += ' ) ' + char(10)
                SELECT @v_dSql += ' SELECT A.PLAN_ID AS CODE, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS NAME ' + char(10)
                SELECT @v_dSql += '      ,A.PLAN_ID            ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_TYPE          ' + char(10)
                SELECT @v_dSql += '      ,A.PLAN_START_TIME    ' + char(10)
                SELECT @v_dSql += '      ,A.PLAN_HORIZON       ' + char(10)
                SELECT @v_dSql += '      ,A.PLAN_HORIZON_UOM   ' + char(10)
                SELECT @v_dSql += '      ,A.DEMAND_HORIZON     ' + char(10)
                SELECT @v_dSql += '      ,A.DEMAND_HORIZON_UOM ' + char(10)
                SELECT @v_dSql += '      ,A.CONFIG_SET_ID      ' + char(10)
                SELECT @v_dSql += '      ,A.BASIS_PLAN_ID      ' + char(10)
                SELECT @v_dSql += '      ,A.DEMAND_PLAN_ID     ' + char(10)
                SELECT @v_dSql += '      ,A.SCP_PLAN_ID        ' + char(10)
                SELECT @v_dSql += '      ,A.PLAN_WEEK          ' + char(10)
                SELECT @v_dSql += '      ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS PLAN_START_DATE ' + char(10)
                SELECT @v_dSql += '      ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS PLAN_END_DATE ' + char(10)
                SELECT @v_dSql += '      ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS DEFAULT_START_DATE ' + char(10)
                SELECT @v_dSql += '      ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS DEFAULT_END_DATE ' + char(10)
                SELECT @v_dSql += '      ,A.INSTANCE_ID ' + char(10)
                SELECT @v_dSql += '      ,A.SITE_ID     ' + char(10)
                SELECT @v_dSql += '      ,A.DESCRIPTION ' + char(10)
                SELECT @v_dSql += '      ,A.PLAN_TYPE   ' + char(10)
                SELECT @v_dSql += '      ,CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID ' + char(10)
                SELECT @v_dSql += '      ,CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME ' + char(10)
                SELECT @v_dSql += '      ,CASE WHEN A.RELEASE_FLAG = ''Y''                    ' + char(10)
                SELECT @v_dSql += '            THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID )  ' + char(10)
                SELECT @v_dSql += '            ELSE A.DESCRIPTION END AS DESCS                ' + char(10)
                SELECT @v_dSql += '      ,SUBSTRING(BASIS_PLAN_ID,CHARINDEX(''-'',BASIS_PLAN_ID)+1,11) AS BASIC_VERSION ' + char(10)
                SELECT @v_dSql += '      ,C.FACTORY_LT                                                           ' + char(10)
                SELECT @v_dSql += '      ,(CASE WHEN PLAN_TYPE = ''RELEASE'' THEN ''N'' -- input MPP WPP         ' + char(10)
                SELECT @v_dSql += '        WHEN RIGHT(A.PLAN_ID,2) = ''00'' THEN ''Y'' ELSE ''N'' END) READ_ONLY ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A WITH(NOLOCK)         ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' ON  A.INSTANCE_ID = C.INSTANCE_ID           ' + char(10)
                SELECT @v_dSql += ' AND A.PLAN_ID     = C.PLAN_ID               ' + char(10)
                SELECT @v_dSql += ' WHERE 1=1                                   ' + char(10)
                SELECT @v_dSql += ' AND   CHARINDEX(''-00'',A.PLAN_ID) = 0      ' + char(10)
				IF(LEN(@param1) > 0 )
				    BEGIN
                        SELECT @v_dSql += ' AND A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
					END
                IF(LEN(@param2) > 0 )
				    BEGIN
 SELECT @v_dSql += ' AND CONVERT(VARCHAR(8), PLAN_START_TIME, 112)  = '''+ @param2 +''' ' + char(10)
					END
                SELECT @v_dSql += ' ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00626화면에서 find_cellType 정보갖고오기                                                                                      */
		/*   Param :@param1	,    @param2,      @param3																						    */
		/*   Param :  																						*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00626_find_cellType'
			BEGIN
				SELECT @v_dSql = ''  
                --SELECT @v_dSql += ' SELECT '''' AS CODE, ''ALL'' AS NAME                        ' + char(10)
                --SELECT @v_dSql += ' UNION ALL                                                   ' + char(10)
                SELECT @v_dSql += ' SELECT A.CELL_TYPE AS CODE, A.CELL_TYPE AS NAME             ' + char(10)
                SELECT @v_dSql += ' FROM (                                                      ' + char(10)
                SELECT @v_dSql += ' 	SELECT 	DISTINCT (CASE WHEN LEVEL_4_NAME = ''-''        ' + char(10)
				SELECT @v_dSql += ' 	  THEN LEVEL_2_NAME ELSE LEVEL_4_NAME END) AS CELL_TYPE ' + char(10)
                SELECT @v_dSql += ' 	FROM 	SCM_ITEM_CLASS_M A WITH(NOLOCK)                 ' + char(10)
                SELECT @v_dSql += ' 	WHERE 	LEVEL_1_NAME = ''Model''                        ' + char(10)
                SELECT @v_dSql += ' 	AND 	USE_FLAG = ''Y''                                ' + char(10)
                SELECT @v_dSql += ' 	AND 	SCP_OPERATION_GROUP = ''A''                     ' + char(10)
                SELECT @v_dSql += ' 	AND 	CASE WHEN LEVEL_4_NAME = ''-''                  ' + char(10)
				SELECT @v_dSql += ' 	     THEN LEVEL_2_NAME ELSE LEVEL_4_NAME END != ''-''   ' + char(10)
                SELECT @v_dSql += ' ) A                                                         ' + char(10)
                SELECT @v_dSql += ' ORDER BY CODE                                               ' + char(10)

				exec sp_executesql @v_dSql

			END
		/****************************************************************************************************************************************/
		/*   FP00626화면에서 find_pancakeType 정보갖고오기                                                                                      */
		/*   Param :@param1	,    @param2,      @param3																						    */
		/*   Param :																					*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00626_find_pancakeType'

			BEGIN
				SELECT @v_dSql = ''  
                --SELECT @v_dSql += ' SELECT '''' AS CODE, ''ALL'' AS NAME                        ' + char(10)
                --SELECT @v_dSql += ' UNION ALL                                                   ' + char(10)
                SELECT @v_dSql += ' SELECT 	DISTINCT LEVEL_3_NAME AS CODE, LEVEL_3_NAME AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM 	SCM_ITEM_CLASS_M A WITH(NOLOCK)                     ' + char(10)
                SELECT @v_dSql += ' WHERE 	LEVEL_2_CODE = ''APC''                              ' + char(10)
                SELECT @v_dSql += ' AND 	LEVEL_3_CODE NOT IN (''-'',''APCSR'')               ' + char(10)
                SELECT @v_dSql += ' ORDER BY CODE                                               ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00626화면에서 find_Unit 정보갖고오기                                                                                      */
		/*   Param :@param1	,    @param2,      @param3																						    */
		/*   Param :																					*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00626_find_Unit'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT ''1'' AS CODE, ''1'' AS NAME       ' + char(10)
                SELECT @v_dSql += ' UNION ALL                                 ' + char(10)
                SELECT @v_dSql += ' SELECT ''1000'' AS CODE, ''1000'' AS NAME ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00626화면에서 chk_PlanId 정보갖고오기                                                                                      */
		/*   Param :@param1	,    @param2,      @param3																						    */
		/*   Param :INTANCE_ID,  PLAN_ID																					*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00626_chk_PlanId'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT A.* ' + char(10)
                SELECT @v_dSql += ' FROM (     ' + char(10)
                SELECT @v_dSql += ' 		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' + char(10)
                SELECT @v_dSql += '             , RELEASE_PLAN_ID, INSERT_TIME ' + char(10)
                SELECT @v_dSql += '             , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) ' + char(10)
                SELECT @v_dSql += '                   ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM ' + char(10)
                SELECT @v_dSql += ' 		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)           ' + char(10)
                SELECT @v_dSql += ' 		WHERE	1=1             ' + char(10)
                SELECT @v_dSql += ' 		AND  A.INSTANCE_ID IN ( ' + char(10)
                SELECT @v_dSql += '                                SELECT A.SEGMENT1 AS ELEC_ID                           ' + char(10)
                SELECT @v_dSql += '                                FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)             ' + char(10)
                SELECT @v_dSql += '                                WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP'' ' + char(10)
                SELECT @v_dSql += '                                AND    A.SEGMENT2 = '''+ @param1 +'''                  ' + char(10)
                SELECT @v_dSql += '                               ) ' + char(10)
                SELECT @v_dSql += ' 		AND  A.INSERT_TIME > (  ' + char(10)
                SELECT @v_dSql += '                               SELECT  DISTINCT A.INSERT_TIME         ' + char(10)
                SELECT @v_dSql += '                               FROM SCM_FP_PLAN_H A WITH(NOLOCK)      ' + char(10)
                SELECT @v_dSql += '                               WHERE  1=1                             ' + char(10)
                SELECT @v_dSql += '                               AND A.INSTANCE_ID = '''+ @param1 +'''  ' + char(10)
                SELECT @v_dSql += '                               AND A.PLAN_ID     = '''+ @param2 +''' ' + char(10)
                SELECT @v_dSql += '                               AND CONVERT(VARCHAR,A.INSERT_TIME,112) ' + char(10)	
                SELECT @v_dSql += '                                  =  (                                ' + char(10)
                SELECT @v_dSql += '                                      SELECT CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < CONVERT(VARCHAR,dbo.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME ' + char(10) 
                SELECT @v_dSql += '                                     	    THEN CONVERT(VARCHAR, DATEADD(DD,-1,dbo.FN_SITE_TIME(B.SITE_ID)), 112)   ' + char(10)
                SELECT @v_dSql += '                                     	    ELSE CONVERT(VARCHAR, dbo.FN_SITE_TIME(B.SITE_ID), 112) END AS CURR_DATE ' + char(10)
                SELECT @v_dSql += '                                      FROM FP_INSTANCE_START_TIME_V A        ' + char(10)
                SELECT @v_dSql += '                                      	,( SELECT MAX(B.SITE_ID) AS SITE_ID ' + char(10)
                SELECT @v_dSql += '                                      	   FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                                      	   WHERE  A.FACTORY_ID = B.FACTORY_ID       ' + char(10)
                SELECT @v_dSql += '                                      	   AND    A.ACTIVE_FLAG = ''Y''             ' + char(10)
                SELECT @v_dSql += '                                      	   AND    B.ACTIVE_FLAG = ''Y''             ' + char(10)
                SELECT @v_dSql += '                                      	   AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += '                                            ) B                                      ' + char(10)
                SELECT @v_dSql += '                                      WHERE  A.INSTANCE_ID = '''+ @param1 +'''       ' + char(10)
                SELECT @v_dSql += '                                   ) ' + char(10)
                SELECT @v_dSql += '                              )      ' + char(10)
                SELECT @v_dSql += ' ) A                                 ' + char(10)
                SELECT @v_dSql += ' WHERE A.ROW_NUM = 1                 ' + char(10)

				--SELECT @v_dSql
				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00626화면에서 FP00626_find_measure 정보갖고오기                                                                                      */
		/*   Param :@param1	,    @param2,      @param3																						    */
		/*   Param :MENU_ID,     USER_ID																					*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00626_find_measure'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT '''+ @param1 +''' AS MENU_ID, ''chk_month''      AS MEA_ID, ''Month''                AS MEA_NAME, ''FALSE''   AS MEA_VALUE, ''CATEGORY''   AS TYPE, '''+ @param2 +'''   AS USER_ID, ''''   AS FLAG ' + char(10)
                SELECT @v_dSql += ' UNION ALL	 ' + char(10)
                SELECT @v_dSql += ' SELECT '''+ @param1 +''' AS MENU_ID, ''chk_week''       AS MEA_ID , ''Week''                AS MEA_NAME, ''FALSE''   AS MEA_VALUE, ''CATEGORY''   AS TYPE, '''+ @param2 +'''   AS USER_ID, ''''   AS FLAG ' + char(10)
                SELECT @v_dSql += '  UNION ALL	 ' + char(10)
                SELECT @v_dSql += ' SELECT '''+ @param1 +''' AS MENU_ID, ''chk_day''        AS MEA_ID , ''Day''                 AS MEA_NAME, ''TRUE''    AS MEA_VALUE, ''CATEGORY''   AS TYPE, '''+ @param2 +'''   AS USER_ID, ''''   AS FLAG ' + char(10)
                SELECT @v_dSql += '  UNION ALL	 ' + char(10)
                SELECT @v_dSql += ' SELECT '''+ @param1 +''' AS MENU_ID, ''chk_assy''       AS MEA_ID , ''Assy Plan(Notching)'' AS MEA_NAME, ''TRUE''    AS MEA_VALUE, ''CATEGORY''   AS TYPE, '''+ @param2 +'''   AS USER_ID, ''''   AS FLAG ' + char(10)
                SELECT @v_dSql += '  UNION ALL	 ' + char(10)
                SELECT @v_dSql += ' SELECT '''+ @param1 +''' AS MENU_ID, ''chk_post''   AS MEA_ID , ''Coater Plan + Post Yield'' AS MEA_NAME, ''TRUE''    AS MEA_VALUE, ''CATEGORY''   AS TYPE, '''+ @param2 +'''   AS USER_ID, ''''   AS FLAG ' + char(10)
                SELECT @v_dSql += '  UNION ALL	 ' + char(10)
                SELECT @v_dSql += ' SELECT '''+ @param1 +''' AS MENU_ID, ''chk_coater''     AS MEA_ID , ''Coater Plan''         AS MEA_NAME, ''TRUE''    AS MEA_VALUE, ''CATEGORY''   AS TYPE, '''+ @param2 +'''   AS USER_ID, ''''   AS FLAG ' + char(10)
                SELECT @v_dSql += '  UNION ALL	 ' + char(10)
                SELECT @v_dSql += ' SELECT '''+ @param1 +''' AS MENU_ID, ''chk_shipment''   AS MEA_ID, ''Shipment Plan(Out)''   AS MEA_NAME, ''TRUE''    AS MEA_VALUE, ''CATEGORY''   AS TYPE, '''+ @param2 +'''   AS USER_ID, ''''   AS FLAG ' + char(10)
                SELECT @v_dSql += '  UNION ALL	 ' + char(10)
                SELECT @v_dSql += ' SELECT '''+ @param1 +''' AS MENU_ID, ''chk_shipmentIn'' AS MEA_ID, ''Shipment Plan(In)''    AS MEA_NAME, ''TRUE''    AS MEA_VALUE, ''CATEGORY''   AS TYPE, '''+ @param2 +'''   AS USER_ID, ''''   AS FLAG ' + char(10)
                SELECT @v_dSql += '  UNION ALL	 ' + char(10)
                SELECT @v_dSql += ' SELECT '''+ @param1 +''' AS MENU_ID, ''chk_inv''        AS MEA_ID , ''Inventory''           AS MEA_NAME, ''TRUE''    AS MEA_VALUE, ''CATEGORY''   AS TYPE, '''+ @param2 +'''   AS USER_ID, ''''   AS FLAG ' + char(10)

				exec sp_executesql @v_dSql
			END

		/****************************************************************************************************************************************/
		/*   FP00626화면에서 FP00626_find_planInfo_P 정보갖고오기                                                                               */
		/*   Param :@param1	,    @param2,      @param3	,  @param4	,    @param5																*/
		/*   Param :INSTANCE_ID, PLAN_ID,     PLAN_DATE, RELEASE_FLAG, CHK_PLANID																*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00626_find_planInfo_P'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' WITH ASSY_PLAN AS (                            ' + char(10)
                SELECT @v_dSql += '         SELECT ''ASSY_PLAN'' AS PLAN_TYPE, A.* ' + char(10)
                SELECT @v_dSql += '         FROM (                                 ' + char(10)
                SELECT @v_dSql += '         		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' + char(10)
                SELECT @v_dSql += '                      , RELEASE_PLAN_ID, CONVERT(CHAR(19), A.INSERT_TIME, 20) AS INSERT_TIME, B.INSERT_ID ' + char(10)
                SELECT @v_dSql += '                      , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) ' + char(10)
                SELECT @v_dSql += '                           ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM ' + char(10)
                SELECT @v_dSql += '         		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                      , SCM_FP_PLAN_H B WITH(NOLOCK)          ' + char(10)
				
				IF(@param4 = 'Y')
                    BEGIN
            	         SELECT @v_dSql += '                  	WHERE   1=1 ' + char(10)
					END
            	ELSE
                    BEGIN
            	         SELECT @v_dSql += '                  	WHERE   1= 0 ' + char(10)
					END

                SELECT @v_dSql += '                 AND  A.INSTANCE_ID = '''+ @param1 +'''    ' + char(10)
                SELECT @v_dSql += '                 AND  A.INSTANCE_ID = B.INSTANCE_ID        ' + char(10)
                SELECT @v_dSql += '                 AND  A.RELEASE_PLAN_ID = B.PLAN_ID        ' + char(10)
                SELECT @v_dSql += '         AND  A.INSTANCE_DATE <= '''+ @param3 +''' ' + char(10)
                SELECT @v_dSql += '         ) A                 ' + char(10)
                SELECT @v_dSql += '         WHERE A.ROW_NUM = 1 ' + char(10)
                SELECT @v_dSql += '         UNION ALL           ' + char(10)
                SELECT @v_dSql += '         SELECT  ''ASSY_PLAN'' AS PLAN_TYPE, A.INSTANCE_ID, ''-'' AS RELEASE_VALUE, A.PLAN_ID AS RELEASE_PLAN_ID ' + char(10)
                SELECT @v_dSql += '         		, CONVERT(CHAR(19), A.INSERT_TIME, 20) AS INSERT_TIME, A.INSERT_ID, 1 AS ROW_NM ' + char(10)
                SELECT @v_dSql += '         FROM SCM_FP_PLAN_H A WITH(NOLOCK) ' + char(10)
				
				IF(@param4 = 'Y')
                    BEGIN
            	         SELECT @v_dSql += '                  	WHERE   1=0 ' + char(10)
					END
            	ELSE
                    BEGIN
            	         SELECT @v_dSql += '                  	WHERE   1=1 ' + char(10)
					END

                SELECT @v_dSql += '         AND A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += '         AND A.PLAN_ID     = '''+ @param2 +''' ' + char(10)
                SELECT @v_dSql += ' )                  ' + char(10)
                SELECT @v_dSql += ' , COATER_PLAN AS ( ' + char(10)
                SELECT @v_dSql += '         SELECT ''COATER_PLAN'' AS PLAN_TYPE, A.* ' + char(10)
                SELECT @v_dSql += '         FROM (                                   ' + char(10)
                SELECT @v_dSql += '         		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' + char(10)
                SELECT @v_dSql += '                     , RELEASE_PLAN_ID, CONVERT(CHAR(19), A.INSERT_TIME, 20) AS INSERT_TIME, B.INSERT_ID ' + char(10)
                SELECT @v_dSql += '                     , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) ' + char(10)
                SELECT @v_dSql += '                           ORDER BY  A.INSERT_TIME DESC ) AS ROW_NUM ' + char(10)
                SELECT @v_dSql += '         		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                      , SCM_FP_PLAN_H B WITH(NOLOCK)          ' + char(10)
                SELECT @v_dSql += '         		WHERE  1=1                                   ' + char(10)
                SELECT @v_dSql += '         		AND  A.INSTANCE_ID = B.INSTANCE_ID           ' + char(10)
                SELECT @v_dSql += '                 AND  A.RELEASE_PLAN_ID = B.PLAN_ID           ' + char(10)
                SELECT @v_dSql += '         		AND  A.INSTANCE_ID IN (                      ' + char(10)
                SELECT @v_dSql += '                            SELECT A.SEGMENT1 AS ELEC_ID      ' + char(10)
                SELECT @v_dSql += '                            FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                            WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP'' ' + char(10)
                SELECT @v_dSql += '                            AND    A.SEGMENT2 = '''+ @param1 +'''                  ' + char(10)
                SELECT @v_dSql += '                            ) ' + char(10)
				
				IF(@param4 = 'Y' OR @param5 = 'Y')
                    BEGIN
            	         SELECT @v_dSql += '         		AND  A.INSTANCE_DATE <= '''+ @param3 +''' ' + char(10)
					END
            	ELSE
                    BEGIN
  	         SELECT @v_dSql += '         		AND  A.INSERT_TIME <= ( SELECT INSERT_TIME FROM ASSY_PLAN ) ' + char(10)
					END        		

                SELECT @v_dSql += '         ) A                 ' + char(10)
                SELECT @v_dSql += '         WHERE A.ROW_NUM = 1 ' + char(10)
                SELECT @v_dSql += ' )                           ' + char(10)
                SELECT @v_dSql += ' SELECT *                    ' + char(10)
                SELECT @v_dSql += ' FROM	ASSY_PLAN           ' + char(10)
                SELECT @v_dSql += ' UNION ALL                   ' + char(10)
                SELECT @v_dSql += ' SELECT *                    ' + char(10)
                SELECT @v_dSql += ' FROM	COATER_PLAN         ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00629화면에서 FP00629_findInstanceList_common 정보갖고오기                                                                       */
		/*   Param :@param1	,    @param2,      @param3	,  @param4	,    @param5																*/
		/*   Param :INSTANCE_ID, PLAN_ID,     PLAN_DATE, RELEASE_FLAG, CHK_PLANID																*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00629_findInstanceList_common'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER ' + char(10)
                SELECT @v_dSql += '     , B.ATTRIBUTE3 AS USE_WOW_STATUS             ' + char(10)
                SELECT @v_dSql += '     , B.ATTRIBUTE1 AS CONFIRM_AREA               ' + char(10)
                SELECT @v_dSql += '     , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID            ' + char(10)
                SELECT @v_dSql += ' FROM (                                           ' + char(10)
                SELECT @v_dSql += '        SELECT DISTINCT B.INSTANCE_ID             ' + char(10)
                SELECT @v_dSql += '        FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '        WHERE  B.USER_ID  = '''+ @p_user_id +'''  ' + char(10)
                SELECT @v_dSql += ' ) A, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)         ' + char(10)
                SELECT @v_dSql += ' WHERE A.INSTANCE_ID      = B.SEGMENT1            ' + char(10)
                SELECT @v_dSql += ' AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID''       ' + char(10)
                SELECT @v_dSql += ' AND   B.SEGMENT1 IN (                            ' + char(10)
                SELECT @v_dSql += '                   SELECT INSTANCE_ID             ' + char(10)
                SELECT @v_dSql += '                   FROM   FP_AMEND_UI_V           ' + char(10)
                SELECT @v_dSql += '                   WHERE  1=1                     ' + char(10)
                SELECT @v_dSql += '                   AND    AMEND_UI_NAME IN (''LINE_AMEND_CELL'',''LINE_AMEND_PACK'') ' + char(10)
                SELECT @v_dSql += '                   AND    USE_FLAG = ''Y''        ' + char(10)
                SELECT @v_dSql += ' )                                                ' + char(10)
                SELECT @v_dSql += ' -- 일시적으로 오창,폴란드만 오픈...., pack 포함  ' + char(10)
                SELECT @v_dSql += ' AND   A.INSTANCE_ID IN (''KR_CELL'',''PL_CELL'',''KR_PACK'',''PL_PACK'') ' + char(10)
                SELECT @v_dSql += ' ORDER BY B.SORT_ORDER ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00629화면에서 FP00629_find_currdate 정보갖고오기                                                                                 */
		/*   Param :@param1	 															                */
		/*   Param :INSTANCE_ID 																                                                */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00629_find_currdate'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' WITH SITE_T AS (                              ' + char(10)
                SELECT @v_dSql += '      SELECT DISTINCT A.INSTANCE_ID, A.SITE_ID ' + char(10)
                SELECT @v_dSql += '      FROM FP_INSTANCE_INFO_V A WITH(NOLOCK)   ' + char(10)
                SELECT @v_dSql += '      WHERE A.INSTANCE_ID = '''+ @param1 +'''  ' + char(10)
                SELECT @v_dSql += ' )                                             ' + char(10)
                SELECT @v_dSql += ' SELECT AA.CURR_DATE                           ' + char(10)
                SELECT @v_dSql += '     , AA.CURR_DATE AS PLAN_START_DATE         ' + char(10)
                SELECT @v_dSql += '     , (SELECT CONVERT(VARCHAR,CONVERT(DATETIME,DATED7) + 29,112) FROM TH_UIS_CALENDAR K WITH(NOLOCK) WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = (AA.CURR_DATE))) AS PLAN_END_DATE ' + char(10)
                SELECT @v_dSql += ' FROM ( ' + char(10)
                SELECT @v_dSql += '       SELECT (CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMddHHmmss'') < (FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') + A.BASIS_START_TIME) ' + char(10)
                SELECT @v_dSql += '                    THEN CONVERT(VARCHAR,DATEADD(DD,-1,FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'')),112) ' + char(10)
                SELECT @v_dSql += '               ELSE FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,''yyyyMMdd'') END) AS CURR_DATE ' + char(10)
                SELECT @v_dSql += '       FROM   FP_INSTANCE_START_TIME_V A, SITE_T B ' + char(10)
                SELECT @v_dSql += '       WHERE  A.INSTANCE_ID = B.INSTANCE_ID        ' + char(10)
                SELECT @v_dSql += ' ) AA ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00629화면에서 FP00629_findFpPlan_info 정보갖고오기                                                                               */
		/*   Param :@param1	 ,   @param2															                                            */
		/*   Param :INSTANCE_ID, PLAN_DATE 																                                        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00629_findFpPlan_info'

			BEGIN
				SELECT @v_dSql = ''  
                SELECT @v_dSql += ' WITH RELEASE_PLAN AS (  ' + char(10)
                SELECT @v_dSql += '      SELECT DISTINCT    ' + char(10)
                SELECT @v_dSql += '           A.INSTANCE_ID ' + char(10)
                SELECT @v_dSql += '          ,A.RELEASE_PLAN_ID AS PLAN_ID            ' + char(10)
                SELECT @v_dSql += '          ,STUFF(( SELECT '','' + FACTORY_ID       ' + char(10)
                SELECT @v_dSql += '                   FROM   FP_RELEASE_PLAN_INFO_H B ' + char(10)
                SELECT @v_dSql += '                   WHERE  A.INSTANCE_ID     = B.INSTANCE_ID     ' + char(10)
                SELECT @v_dSql += '                   AND    A.INSTANCE_DATE   = B.INSTANCE_DATE   ' + char(10)
                SELECT @v_dSql += '                   AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID ' + char(10)
                SELECT @v_dSql += '                   FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT ' + char(10)
                SELECT @v_dSql += '          ,A.PLAN_GROUP_ID                         ' + char(10)
                SELECT @v_dSql += '          ,A.INSTANCE_DATE AS PLAN_DATE            ' + char(10)
                SELECT @v_dSql += '      FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '      WHERE  1=1                                   ' + char(10)
				IF(LEN(@param1) > 0)
                    BEGIN
            	         SELECT @v_dSql += ' AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
					END
				IF(LEN(@param2) > 0 )
                    BEGIN
            	   SELECT @v_dSql += ' AND    A.INSTANCE_DATE  = '''+ @param2 +''' ' + char(10)
					END
                SELECT @v_dSql += ' ) ' + char(10)
                SELECT @v_dSql += ' SELECT A.PLAN_ID AS CODE, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS NAME ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_ID            ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_TYPE          ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_START_TIME    ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_HORIZON       ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_HORIZON_UOM   ' + char(10)
                SELECT @v_dSql += '     ,A.DEMAND_HORIZON     ' + char(10)
                SELECT @v_dSql += '     ,A.DEMAND_HORIZON_UOM ' + char(10)
                SELECT @v_dSql += '     ,A.CONFIG_SET_ID      ' + char(10)
                SELECT @v_dSql += '     ,A.BASIS_PLAN_ID      ' + char(10)
                SELECT @v_dSql += '     ,A.DEMAND_PLAN_ID     ' + char(10)
                SELECT @v_dSql += '     ,A.SCP_PLAN_ID        ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_WEEK          ' + char(10)
                SELECT @v_dSql += '     ,'''+ @param2 +''' AS PLAN_START_DATE                                                        ' + char(10)
                SELECT @v_dSql += '     ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,'''+ @param2 +''')), 112) AS PLAN_END_DATE    ' + char(10)
                SELECT @v_dSql += '     ,'''+ @param2 +''' AS DEFAULT_START_DATE                                                     ' + char(10)
                SELECT @v_dSql += '     ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,'''+ @param2 +''')), 112) AS DEFAULT_END_DATE ' + char(10)
                SELECT @v_dSql += '     ,A.INSTANCE_ID ' + char(10)
                SELECT @v_dSql += '     ,A.SITE_ID     ' + char(10)
                SELECT @v_dSql += '     ,A.DESCRIPTION ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_TYPE   ' + char(10)
                SELECT @v_dSql += '     ,CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID ' + char(10)
                SELECT @v_dSql += '     ,CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME ' + char(10)
                SELECT @v_dSql += '     ,CASE WHEN A.RELEASE_FLAG = ''Y''                    ' + char(10)
                SELECT @v_dSql += '           THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID )  ' + char(10)
                SELECT @v_dSql += '           ELSE A.DESCRIPTION END AS DESCS ' + char(10)
                SELECT @v_dSql += '     ,SUBSTRING(BASIS_PLAN_ID,CHARINDEX(''-'',BASIS_PLAN_ID)+1,11) AS BASIC_VERSION ' + char(10)
                SELECT @v_dSql += '     ,C.FACTORY_LT                         ' + char(10)
                SELECT @v_dSql += '     ,(CASE WHEN PLAN_TYPE = ''RELEASE'' THEN ''N'' -- input MPP WPP              ' + char(10)
                SELECT @v_dSql += '            WHEN RIGHT(A.PLAN_ID,2) = ''00'' THEN ''Y'' ELSE ''N'' END) READ_ONLY ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A WITH(NOLOCK)         ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' ON   A.INSTANCE_ID = C.INSTANCE_ID          ' + char(10)
                SELECT @v_dSql += ' AND  A.PLAN_ID     = C.PLAN_ID              ' + char(10)
      SELECT @v_dSql += ' WHERE  1=1                                  ' + char(10)
				IF(LEN(@param1) > 0)
                    BEGIN
            	         SELECT @v_dSql += ' AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
					END
				IF(LEN(@param2) > 0 )
                    BEGIN
            	         SELECT @v_dSql += ' AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = '''+ @param2 +''' ' + char(10)
					END

   	SELECT @v_dSql += 'ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00629화면에서 Simulation Plan ID 정보갖고오기                                                                               */
		/*   Param :@param1	 ,   @param2															                                            */
		/*   Param :INSTANCE_ID, PLAN_DATE 																                                        */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00629_SIM_Plan_Info'

			BEGIN
				SELECT @v_dSql = ''  

				SELECT @v_dSql += N'	SELECT A.SIM_PLAN_ID AS CODE, SUBSTRING(A.SIM_PLAN_ID,CHARINDEX(''-'',A.SIM_PLAN_ID)+1,12) AS NAME                                                                                                                      ' + char(10)
				SELECT @v_dSql += N'	    ,A.SIM_PLAN_ID AS PLAN_ID                                                                                                                                                                                                      ' + char(10)
				SELECT @v_dSql += N'	    ,A.PLAN_TYPE                                                                                                                                                                                                    ' + char(10)
				SELECT @v_dSql += N'	    ,A.PLAN_DATE                                                                                                                                                                                                    ' + char(10)
				SELECT @v_dSql += N'	    ,A.PLAN_START_TIME                                                                                                                                                                                              ' + char(10)
				SELECT @v_dSql += N'	    ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS PLAN_START_DATE                                                            ' + char(10)
				--SELECT @v_dSql += N'	    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @p_plan_date +''')))), 112) AS PLAN_END_DATE         ' + char(10)
				SELECT @v_dSql += N'	    ,CONVERT(VARCHAR, A.PLAN_END_TIME, 112) AS PLAN_END_DATE         ' + char(10)
				SELECT @v_dSql += N'	    ,A.INSTANCE_ID                                                                                                                                                                                                  ' + char(10)
				SELECT @v_dSql += N'	    ,A.SITE_ID                                                                                                                                                                                                      ' + char(10)
				SELECT @v_dSql += N'	    ,A.DESCRIPTION                                                                                                                                                                                                  ' + char(10)
				SELECT @v_dSql += N'	    ,ISNULL(A.HISTORY_YN, ''N'') AS HISTORY_YN                                                                                                                                                                                 ' + char(10)
				SELECT @v_dSql += N'	    ,NULL AS READ_ONLY                                                                                                                                                                                 ' + char(10)
				SELECT @v_dSql += N'        ,A.INSERT_ID ' + char(10)
                SELECT @v_dSql += N'        ,CONVERT(VARCHAR, A.INSERT_DTTM, 120) AS INSERT_TIME ' + char(10)
				SELECT @v_dSql += N'        ,NULL AS BASIC_VERSION      ' + char(10)
				SELECT @v_dSql += N'        ,NULL AS FACTORY_LT      ' + char(10)
				SELECT @v_dSql += N'	FROM   FP_SIM_PLAN_H A WITH(NOLOCK)                                                                                                                                                                                 ' + char(10)
				SELECT @v_dSql += N'	WHERE 1=1                                                                                                                                                                                                           ' + char(10)
				SELECT @v_dSql += N'	--AND   A.PLAN_TYPE <> ''RELEASE''                                                                                                                                                                                  ' + char(10)
				SELECT @v_dSql += N'	AND 	CHARINDEX(''-000'',A.SIM_PLAN_ID) = 0                                                                                                                                                                            ' + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @param1)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CONVERT(VARCHAR(8), CONVERT(DATE, A.PLAN_DATE), 112)' , 'EQ', @param2)) + char(10)
				SELECT @v_dSql += N'	ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.SIM_PLAN_ID DESC                                                                                                                                                ' + char(10)

				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00629화면에서 find_bukInfo 정보갖고오기                                                                                          */
		/*   Param : @Param1     , Param2                                                                                                       */
		/*   Param : BUCKET_FROM , BUCKET_TO                                                                                                    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00629_find_bukInfo' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.*                                            ' + char(10)
                SELECT @v_dSql += ' FROM (                                                ' + char(10)
                SELECT @v_dSql += '       SELECT A._DATE, A._NAME, A._COUNT               ' + char(10)
                SELECT @v_dSql += '           , (A._VALUE + B.POSTFIX) AS _VALUE          ' + char(10)
                SELECT @v_dSql += '           , A._DATE_SEQ, A.WEEK_SEQ, A._TYPE          ' + char(10)
                SELECT @v_dSql += '           , B.POST_ORDER, B.POSTFIX                   ' + char(10)
                SELECT @v_dSql += '       FROM (                                          ' + char(10)
                SELECT @v_dSql += '              SELECT YYYYMMDD AS _DATE                 ' + char(10)
                SELECT @v_dSql += '                  ,SUBSTRING(YYYYMMDD,1,4) + ''-'' + SUBSTRING(YYYYMMDD,5,2) + ''-'' + SUBSTRING(YYYYMMDD,7,2) + '' '' ' + char(10)
                SELECT @v_dSql += '                  +(CASE WHEN DAY_SEQ=2 THEN ''(Mon)'' ' + char(10)
                SELECT @v_dSql += '                         WHEN DAY_SEQ=3 THEN ''(Tue)'' ' + char(10)
                SELECT @v_dSql += '                         WHEN DAY_SEQ=4 THEN ''(Wed)'' ' + char(10)
                SELECT @v_dSql += '                        WHEN DAY_SEQ=5 THEN ''(Thu)'' ' + char(10)
                SELECT @v_dSql += '                         WHEN DAY_SEQ=6 THEN ''(Fri)'' ' + char(10)
                SELECT @v_dSql += '                         WHEN DAY_SEQ=7 THEN ''(Sat)'' ' + char(10)
                SELECT @v_dSql += '                         ELSE ''(SUN)'' END)           ' + char(10)
                SELECT @v_dSql += '                  AS _NAME                             ' + char(10)
                SELECT @v_dSql += '                  , 1 AS _COUNT                        ' + char(10)
                SELECT @v_dSql += '                  ,''D'' + CONVERT(VARCHAR,(ROW_NUMBER() OVER(ORDER BY YYYYMMDD))-1) AS _VALUE ' + char(10)
                SELECT @v_dSql += '                  , 1 AS _DATE_SEQ                     ' + char(10)

				if isnull(@param3,'') = 'SUN' BEGIN
	                SELECT @v_dSql += '                  , YYYYWW AS WEEK_SEQ             ' + char(10)
				END ELSE BEGIN
		            SELECT @v_dSql += '                  , ISO_YYYYWW AS WEEK_SEQ             ' + char(10)
				END


                SELECT @v_dSql += '                  , ''D'' AS _TYPE                     ' + char(10)
                SELECT @v_dSql += '              FROM   TH_UIS_CAL A WITH(NOLOCK)         ' + char(10)
                SELECT @v_dSql += '              WHERE  YYYYMMDD BETWEEN '''+ @param1 +''' AND '''+ @param2 +''' ' + char(10)
                SELECT @v_dSql += '       ) A                                                    ' + char(10)
                SELECT @v_dSql += '       INNER JOIN (                                           ' + char(10)
                SELECT @v_dSql += '            SELECT ''_QTY'' AS POSTFIX, 10 AS POST_ORDER      ' + char(10)
                SELECT @v_dSql += '            UNION ALL                                         ' + char(10)
                SELECT @v_dSql += '            SELECT ''_MATQTY'' AS POSTFIX, 20 AS POST_ORDER   ' + char(10)
                SELECT @v_dSql += '            UNION ALL                                         ' + char(10)
                SELECT @v_dSql += '            SELECT ''_MATINQTY'' AS POSTFIX, 30 AS POST_ORDER ' + char(10)
                SELECT @v_dSql += '            UNION ALL                                         ' + char(10)
                SELECT @v_dSql += '            SELECT ''_EOHQTY'' AS POSTFIX, 40 AS POST_ORDER   ' + char(10)
                SELECT @v_dSql += '            UNION ALL                                         ' + char(10)
                SELECT @v_dSql += '            SELECT ''_EOH2QTY'' AS POSTFIX, 50 AS POST_ORDER  ' + char(10)
                SELECT @v_dSql += '       ) B                                                    ' + char(10)
                SELECT @v_dSql += '       ON   1=1                                               ' + char(10)
                SELECT @v_dSql += ' ) A                                                          ' + char(10)
                SELECT @v_dSql += ' ORDER BY WEEK_SEQ, (CASE WHEN _TYPE = ''W'' THEN 1 ELSE 2 END), _DATE, POST_ORDER ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00606화면에서 find_FPProdType 정보갖고오기                                                                                      */
		/*   Param : @Param1                  */
		/*   Param : DIVISION_ID              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00606_find_FPProdType' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql  = ' SELECT  DISTINCT A.ATTRIBUTE2 AS CODE, A.ATTRIBUTE2 AS NAME       ' + char(10)
                SELECT @v_dSql += ' FROM    SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                       ' + char(10)
                SELECT @v_dSql += ' WHERE   A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE''             ' + char(10)
                SELECT @v_dSql += ' AND     A.ACTIVE_FLAG = ''Y''                                     ' + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @param1))  + char(10)

			    exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   FP00606화면에서 findFpPlan_info 정보갖고오기                                                                                       */
		/*   Param : @Param1     , Param2                                                                                                       */
		/*   Param : INSTANCE_ID , PLAN_DATE                                                                                                    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00606_findLineCode_List' 
		    BEGIN	
				SELECT @v_dSql = '' 
				SELECT @v_dSql += '      SELECT A.LINE_ID AS CODE ' + char(10) 
				SELECT @v_dSql += '           , ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS NAME ' + char(10)
				SELECT @v_dSql += '      FROM   SCM_LINE_M A(NOLOCK) ' + char(10)
			    SELECT @v_dSql += ' WHERE 1=1                        ' + char(10)
	    
                IF (@param10 != 'Y') --IN_ACT
                    BEGIN
                        SELECT @v_dSql += ' AND	A.ACTIVE_FLAG = ''Y'' ' + char(10)
                    END
				SELECT @v_dSql += '      AND    EXISTS (																																	'+ char(10)
				SELECT @v_dSql += '			        	SELECT 1																															'+ char(10)
				SELECT @v_dSql += '			        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)																							'+ char(10)
				SELECT @v_dSql += '			        	WHERE  A.COMPANY_ID  = B.COMPANY_ID																									'+ char(10)
				SELECT @v_dSql += '			        	AND    A.DIVISION_ID = B.DIVISION_ID																								'+ char(10)
				SELECT @v_dSql += '			        	AND    A.SITE_ID     = B.SITE_ID																									'+ char(10)
				SELECT @v_dSql += '			        	AND    A.PLANT_ID	 = B.PLANT_ID																									'+ char(10)
				SELECT @v_dSql += '			        	AND    A.FACTORY_ID  = B.FACTORY_ID																									'+ char(10)
				SELECT @v_dSql += '			        	AND    A.OPERATION_ID = B.OPERATION_ID																								'+ char(10)
				IF (@param10 != 'Y') --IN_ACT
				BEGIN
					SELECT @v_dSql += ' AND    A.LINE_ID 	 = B.LINE_ID' + char(10)
				END
				
				SELECT @v_dSql += '			        	AND    B.USER_ID     = ' + char(39) + @p_user_id  + char(39) + char(10)
				SELECT @v_dSql += '			      	)																																		'+ char(10)
				SELECT @v_dSql += '      AND   EXISTS (																																		'+ char(10)
				SELECT @v_dSql += '          SELECT 1 FROM (																																'+ char(10)
				SELECT @v_dSql += '              SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID																'+ char(10)
				SELECT @v_dSql += '              FROM  SCM_FACTORY_M A(NOLOCK)																												'+ char(10)
				SELECT @v_dSql += '              INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK)																									'+ char(10)
				SELECT @v_dSql += '              ON    A.FACTORY_ID=B.FACTORY_ID																											'+ char(10)
				SELECT @v_dSql += '            WHERE 1=1																																	'+ char(10)
				SELECT @v_dSql += '              AND   B.INSTANCE_ID = ' + char(39) +  @param1 + char(39) + char(10)
				SELECT @v_dSql += '          ) C																																			'+ char(10)
				SELECT @v_dSql += '          WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID '+ char(10)
				SELECT @v_dSql += '      )																																					 '+ char(10)

				--IF(LEN(@param9) > 0)
				--BEGIN
				--                SELECT @v_dSql += '     AND    A.COMPANY_ID = '''+ @param9 +''' ' + char(10)
				--END	
				--IF(LEN(@param5) > 0)
				--BEGIN
				--                SELECT @v_dSql += '     AND    A.DIVISION_ID = '''+ @param9 +''' ' + char(10)
				--END
				--IF(LEN(@param6) > 0)
				--BEGIN
				--                SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param6 +''' ' + char(10)
				--END
				--IF(LEN(@param7) > 0)
				--BEGIN
				--                SELECT @v_dSql += '     AND    A.PLANT_ID = '''+ @param7 +''' ' + char(10)
				--END
				--IF(LEN(@param8) > 0)
				--BEGIN
				--                SELECT @v_dSql += '     AND    A.FACTORY_ID = '''+ @param8 +''' ' + char(10)
				--END
				--IF(LEN(@param10) > 0)
				--BEGIN
				--                SELECT @v_dSql += '     AND    A.LINE_ID = '''+ @param10 +''' ' + char(10)
				--END
				--IF(LEN(@param12) > 0)
				--BEGIN
				--                SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param12 +''' ' + char(10)
				--END

				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5)) + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6)) + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7)) + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param8)) + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param12)) + char(10)

				


                IF(@param1 !='') --INSTANCE_ID
                    BEGIN
                        SELECT @v_dSql += ' AND EXISTS ( SELECT  1                                            ' + char(10)
                        SELECT @v_dSql += '              FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)        ' + char(10)
                        SELECT @v_dSql += '              WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''       ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = ' + char(39)+ @param1 + char(39) + char(10)
                        SELECT @v_dSql += '              AND     LV1.ACTIVE_FLAG      = ''Y''                 ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ATTRIBUTE1       = ''BUILDING''          ' + char(10)
                        SELECT @v_dSql += '              UNION ALL                                            ' + char(10)
                        SELECT @v_dSql += '              SELECT  1                                            ' + char(10)
                        SELECT @v_dSql += '              FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),       ' + char(10)
                        SELECT @v_dSql += '                      SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)        ' + char(10)
                        SELECT @v_dSql += '              WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''       ' + char(10)
                        SELECT @v_dSql += '              AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = LV2.SEGMENT1          ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = '+ char(39) + @param1 + char(39) + char(10)
                        SELECT @v_dSql += '              AND     LV1.ACTIVE_FLAG      = ''Y''                 ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''        ' + char(10)
                        SELECT @v_dSql += '              AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) )  ' + char(10)
                    END

					IF(@param11 != 'Y') --ALL_LINE
                    BEGIN
                        SELECT @v_dSql += ' AND A.LINE_ID IN ( ' + char(10)
                        SELECT @v_dSql += '     SELECT DISTINCT LINE_ID ' + char(10)
                        SELECT @v_dSql += '     FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK) ' + char(10)
                        SELECT @v_dSql += '     WHERE  AA.INSTANCE_ID = ' + char(39)+ @param1 + char(39) +  char(10)
                        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('     AA.USER_ID' , 'EQ', @p_user_id)) + char(10)
                        SELECT @v_dSql += ' ) ' + char(10)
                    END

                 SELECT @v_dSql += ' GROUP BY A.LINE_ID, A.LINE_NAME ' + char(10)
                 SELECT @v_dSql += ' ORDER BY A.LINE_ID ' + char(10)
            
              --SELECT @v_dSql
              exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   FP00607화면에서 findFpPlan_info 정보갖고오기                                                                                       */
		/*   Param : @Param1     , Param2                                                                                                       */
		/*   Param : INSTANCE_ID , PLAN_DATE                                                                                                    */
		/****************************************************************************************************************************************/

		ELSE IF @p_code = 'FP00607_findFpPlan_info' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' WITH RELEASE_PLAN AS ( ' + char(10)
                SELECT @v_dSql += '      SELECT DISTINCT      ' + char(10)
                SELECT @v_dSql += '             A.INSTANCE_ID ' + char(10)
                SELECT @v_dSql += '            ,A.RELEASE_PLAN_ID AS PLAN_ID      ' + char(10)
                SELECT @v_dSql += '            ,STUFF(( SELECT '','' + FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                     FROM   FP_RELEASE_PLAN_INFO_H B ' + char(10)
                SELECT @v_dSql += '                     WHERE  A.INSTANCE_ID     = B.INSTANCE_ID     ' + char(10)
                SELECT @v_dSql += '                     AND    A.INSTANCE_DATE   = B.INSTANCE_DATE   ' + char(10)
                SELECT @v_dSql += '                     AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID ' + char(10)
                SELECT @v_dSql += '                     FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT ' + char(10)
                SELECT @v_dSql += '            ,A.PLAN_GROUP_ID              ' + char(10)
                SELECT @v_dSql += '            ,A.INSTANCE_DATE AS PLAN_DATE ' + char(10)
                SELECT @v_dSql += '      FROM   FP_RELEASE_PLAN_INFO_H A     ' + char(10)
                SELECT @v_dSql += '      WHERE  1=1                          ' + char(10)

				IF(LEN(@param1) > 0)
				    BEGIN
                        SELECT @v_dSql += '      AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
				    END
				IF(LEN(@param2) > 0)
				    BEGIN
                        SELECT @v_dSql += '      AND    A.INSTANCE_DATE = '''+ @param2 +''' ' + char(10)
				    END

                SELECT @v_dSql += ' ) ' + char(10)
                SELECT @v_dSql += ' SELECT A.PLAN_ID AS CODE, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS NAME ' + char(10)
          SELECT @v_dSql += '     ,A.PLAN_ID            ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_TYPE          ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_START_TIME    ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_HORIZON       ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_HORIZON_UOM   ' + char(10)
                SELECT @v_dSql += '     ,A.DEMAND_HORIZON     ' + char(10)
              SELECT @v_dSql += '     ,A.DEMAND_HORIZON_UOM ' + char(10)
                SELECT @v_dSql += '     ,A.CONFIG_SET_ID      ' + char(10)
                SELECT @v_dSql += '     ,A.BASIS_PLAN_ID      ' + char(10)
                SELECT @v_dSql += '     ,A.DEMAND_PLAN_ID     ' + char(10)
                SELECT @v_dSql += '     ,A.SCP_PLAN_ID        ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_WEEK          ' + char(10)
                SELECT @v_dSql += '     --,CONVERT(VARCHAR(8), DATEADD(DAY,-28, A.PLAN_START_TIME), 112) AS PLAN_START_DATE ' + char(10)
                SELECT @v_dSql += '     --,CONVERT(VARCHAR(8), DATEADD(DAY, 55, A.PLAN_START_TIME), 112) AS PLAN_END_DATE   ' + char(10)
                SELECT @v_dSql += '     ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS PLAN_START_DATE ' + char(10)
                SELECT @v_dSql += '     ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS PLAN_END_DATE ' + char(10)
                SELECT @v_dSql += '     ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS DEFAULT_START_DATE ' + char(10)
                SELECT @v_dSql += '     ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS DEFAULT_END_DATE ' + char(10)
                SELECT @v_dSql += '     ,A.INSTANCE_ID ' + char(10)
                SELECT @v_dSql += '     ,A.SITE_ID     ' + char(10)
                SELECT @v_dSql += '     ,A.DESCRIPTION ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_TYPE   ' + char(10)
                SELECT @v_dSql += '     ,CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID ' + char(10)
                SELECT @v_dSql += '     ,CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME ' + char(10)
                SELECT @v_dSql += '     ,CASE WHEN A.RELEASE_FLAG = ''Y''                    ' + char(10)
                SELECT @v_dSql += '     	  THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID ) ' + char(10) 
                SELECT @v_dSql += '     	  ELSE A.DESCRIPTION END AS DESCS          ' + char(10)
                SELECT @v_dSql += '     ,SUBSTRING(A.BASIS_PLAN_ID,CHARINDEX(''-'',A.BASIS_PLAN_ID)+1,11) AS BASIC_VERSION ' + char(10)
                SELECT @v_dSql += '     ,C.FACTORY_LT                                  ' + char(10)
                SELECT @v_dSql += '     ,(CASE WHEN PLAN_TYPE = ''RELEASE'' THEN ''Y'' ' + char(10)
                SELECT @v_dSql += '            WHEN RIGHT(A.PLAN_ID,2) = ''00'' THEN ''Y'' ELSE ''N'' END) AS READ_ONLY ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A WITH(NOLOCK)         ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '   ON  A.INSTANCE_ID = C.INSTANCE_ID         ' + char(10)
                SELECT @v_dSql += ' AND A.PLAN_ID = C.PLAN_ID ' + char(10)
                SELECT @v_dSql += ' WHERE  1=1                ' + char(10)
				IF(LEN(@param1) > 0)
				    BEGIN
               SELECT @v_dSql += '   AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
				    END
				IF(LEN(@param2) > 0)
				    BEGIN
                        SELECT @v_dSql += '   AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = '''+ @param2 +''' ' + char(10)
				    END

                SELECT @v_dSql += ' ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00607화면에서 findLineCode_List 정보갖고오기                                                                                     */
		/*   Param : @Param1   , Param2  , Param3 ,   Param4 ,      Param5 ,  Param6 , Param7 , Param8 , Param9 , Param10 , Param11 , Param12   */
		/*   Param : INSTANCE  , PLAN_ID , PLAN_TYPE, CONFIRM_AREA, DIVISION, SITE,    PLANT,   FACTORY,  LINE  ,OPERATION, ALL_LINE, USER_LT,  */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_findLineCode_List' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.LINE_ID AS CODE ' + char(10)
                SELECT @v_dSql += '     , ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_LINE_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE  A.ACTIVE_FLAG = ''Y''     ' + char(10)
                SELECT @v_dSql += ' AND EXISTS (                     ' + char(10)
                SELECT @v_dSql += '             SELECT 1             ' + char(10)
                SELECT @v_dSql += '             FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '             WHERE  A.COMPANY_ID   = B.COMPANY_ID      ' + char(10)
                SELECT @v_dSql += '             AND    A.DIVISION_ID  = B.DIVISION_ID     ' + char(10)
                SELECT @v_dSql += '             AND    A.SITE_ID      = B.SITE_ID         ' + char(10)
                SELECT @v_dSql += '             AND    A.PLANT_ID     = B.PLANT_ID        ' + char(10)
                SELECT @v_dSql += '             AND    A.FACTORY_ID   = B.FACTORY_ID      ' + char(10)
                SELECT @v_dSql += '             AND    A.OPERATION_ID = B.OPERATION_ID    ' + char(10)
                SELECT @v_dSql += '             AND    A.LINE_ID      = B.LINE_ID         ' + char(10)
                SELECT @v_dSql += '             AND    B.USER_ID      ='''+ @p_user_id +''' ' + char(10)
                SELECT @v_dSql += ' 	       )               ' + char(10)
                SELECT @v_dSql += ' AND EXISTS (               ' + char(10)
                SELECT @v_dSql += '            SELECT 1 FROM ( ' + char(10)
                SELECT @v_dSql += '                SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                FROM  SCM_FACTORY_M A WITH(NOLOCK)              ' + char(10)
                SELECT @v_dSql += '                INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                ON    A.FACTORY_ID=B.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                AND   B.ACTIVE_FLAG = ''Y''     ' + char(10)
                SELECT @v_dSql += '                WHERE 1=1                       ' + char(10)
                SELECT @v_dSql += '                AND   B.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += '            ) C ' + char(10)
                SELECT @v_dSql += '       WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += ' ) ' + char(10)

				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param8)) + char(10)
				--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param9)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param10)) + char(10)

				IF(LEN(@param1) > 0)
				    BEGIN
                        SELECT @v_dSql += ' AND EXISTS ( SELECT  1 ' + char(10)

                        SELECT @v_dSql += '              FROM  SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)       ' + char(10)
                        SELECT @v_dSql += '              WHERE  LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''     ' + char(10)
                        SELECT @v_dSql += '              AND    LV1.SEGMENT1         = ''' + @param1 + ''' ' + char(10)
                        SELECT @v_dSql += '              AND    LV1.ACTIVE_FLAG      = ''Y''               ' + char(10)
                        SELECT @v_dSql += '              AND    LV1.ATTRIBUTE1       = ''BUILDING''        ' + char(10)
                        SELECT @v_dSql += '              UNION ALL ' + char(10)
                        SELECT @v_dSql += '              SELECT  1 ' + char(10)
                        SELECT @v_dSql += '              FROM  SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK), ' + char(10)
                        SELECT @v_dSql += '                    SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)  ' + char(10)
                        SELECT @v_dSql += '              WHERE LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
                        SELECT @v_dSql += '              AND   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.SEGMENT1         = LV2.SEGMENT1        ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.SEGMENT1         = ''' + @param1 + ''' ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.ACTIVE_FLAG      = ''Y''               ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.ATTRIBUTE1       = ''PLAN GROUP''      ' + char(10)
                        SELECT @v_dSql += '              AND   LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) ' + char(10)
						SELECT @v_dSql += '            ) ' + char(10)
				    END
                --ALL_LINE
				IF( @param11 != 'Y')
				    IF(@param1 = 'PL_FORM_A')
				        BEGIN
                            SELECT @v_dSql += ' AND A.MODEL_TYPE IN (  ' + char(10)
                            SELECT @v_dSql += '           SELECT A.SEGMENT2 FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
                            SELECT @v_dSql += '           WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''    ' + char(10)

							IF(LEN(@param12) > 0)
							    BEGIN
								    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ATTRIBUTE6' , 'EQ', @param12)) + char(10)
								END
							ELSE
							    BEGIN
								    SELECT @v_dSql += '           AND A.ATTRIBUTE6 IN ('''') ' + char(10)
								END

                            SELECT @v_dSql += '           ) ' + char(10)

				        END
                    ELSE
				        BEGIN
                            SELECT @v_dSql += ' AND A.LINE_ID IN (          ' + char(10)
                            SELECT @v_dSql += '     SELECT DISTINCT LINE_ID ' + char(10)
                            SELECT @v_dSql += '     FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK) ' + char(10)
    SELECT @v_dSql += '     WHERE  AA.INSTANCE_ID = '''+ @param1 +'''   ' + char(10)

							IF(LEN(@param12) > 0)
							    BEGIN
								    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.USER_ID' , 'EQ', @param12)) + char(10)
								END
							ELSE
							    BEGIN
								    SELECT @v_dSql += '           AND AA.USER_ID IN ('''') ' + char(10)
								END
                            SELECT @v_dSql += ' ) ' + char(10)
				        END
                --PLAN_TYPE, CONFIRM_AREA
				IF( @param3 = 'RELEASE' AND @param4 = 'PLAN GROUP')
				    BEGIN
                        SELECT @v_dSql += ' AND A.MODEL_TYPE IN (           ' + char(10)
                        SELECT @v_dSql += '        SELECT KK.PLAN_GROUP_ID  ' + char(10)
                        SELECT @v_dSql += '        FROM   FP_RELEASE_PLAN_INFO_H KK WITH(NOLOCK)  ' + char(10)
                        SELECT @v_dSql += '        WHERE  KK.INSTANCE_ID = '''+ @param1 +'''      ' + char(10)
                        SELECT @v_dSql += '        AND    KK.RELEASE_PLAN_ID = '''+ @param2 +'''  ' + char(10)
                        SELECT @v_dSql += ' )  ' + char(10)
				    END

                SELECT @v_dSql += ' GROUP BY A.LINE_ID, A.LINE_NAME ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.LINE_ID              ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00607화면에서 findOperationCode_common 정보갖고오기                                                                                      */
		/*            @Param1     @Param2      @Param3   @Param4            */
		/*   Param : INSTANCE_ID, DIVISION_ID, SITE_ID,  AMEND_MAIN_FLAG    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_findOperationCode_common' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.OPERATION_ID AS CODE                                ' + char(10)
				SELECT @v_dSql += '  , ''('' + A.OPERATION_ID + '')'' + B.OPERATION_NAME AS NAME          ' + char(10)
                SELECT @v_dSql += '  , A.AMEND_MAIN_FLAG                                                  ' + char(10)
                SELECT @v_dSql += ' FROM   FP_INSTANCE_OPERATION_V A                                      ' + char(10)
                SELECT @v_dSql += ' 	, SCM_OPERATION_M B                                               ' + char(10)
                SELECT @v_dSql += ' WHERE  A.COMPANY_ID   = B.COMPANY_ID                                  ' + char(10)
                SELECT @v_dSql += ' AND    A.DIVISION_ID  = B.DIVISION_ID                                 ' + char(10)
                SELECT @v_dSql += ' AND    A.SITE_ID      = B.SITE_ID                                     ' + char(10)
                SELECT @v_dSql += ' AND    A.OPERATION_ID = B.OPERATION_ID                                ' + char(10)
                SELECT @v_dSql += ' AND    A.INSTANCE_ID  = '''+ @param1 +'''                             ' + char(10)
                SELECT @v_dSql += ' AND    EXISTS (                                                       ' + char(10)
                SELECT @v_dSql += '                SELECT 1                                               ' + char(10)
                SELECT @v_dSql += '                FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)              ' + char(10)
                SELECT @v_dSql += '                WHERE  A.COMPANY_ID  = B.COMPANY_ID                    ' + char(10)
                SELECT @v_dSql += '                AND    A.DIVISION_ID = B.DIVISION_ID                   ' + char(10)
                SELECT @v_dSql += '                AND    A.SITE_ID     = B.SITE_ID                       ' + char(10)
 SELECT @v_dSql += '                AND    A.OPERATION_ID = B.OPERATION_ID                 ' + char(10)
                SELECT @v_dSql += '                AND    B.USER_ID     = '''+ @p_user_id +'''            ' + char(10)
                SELECT @v_dSql += '               )                                                       ' + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param2))   + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param3))       + char(10)
                SELECT @v_dSql += ' AND   A.AMEND_FLAG = ''Y''                                            ' +char(10)

                IF @param4 ='N'
				    BEGIN 
                        SELECT @v_dSql += ' AND   A.AMEND_MAIN_FLAG = ''Y'' ' +char(10)
				    END
                SELECT @v_dSql += ' ORDER BY A.OPERATION_ID DESC ' +char(10)

			   exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00607화면에서 find_NickName_List 정보갖고오기                                                                                     */
		/*   Param : @Param1   , Param2  , Param3 ,   Param4 ,      Param5 ,   Param6 ,  Param7 , Param8 , Param9 , Param10 , Param11 , Param12   */
		/*   Param : INSTANCE  , PLAN_ID , PLAN_DATE, BUCKET_FROM,  BUCKET_TO, DIVISION, SITE,    PLANT,   FACTORY,  LINE  ,  OPERATION, AMEND_TABLE  */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_find_NickName_List' 
		    BEGIN	
			    SELECT @v_dSql = ''

			    SELECT @v_dSql += ' SELECT DISTINCT ISNULL(B.NICK_NAME,''-'') AS CODE, ISNULL(B.NICK_NAME,''-'') AS NAME ' + char(10)
			    SELECT @v_dSql += ' FROM (     ' + char(10)
			    SELECT @v_dSql += '       -- P ' + char(10)
			    SELECT @v_dSql += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
			    SELECT @v_dSql += '       FROM   '+ TRY_CONVERT(NVARCHAR, @param12) +' A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '       WHERE  A.INSTANCE_ID  = '''+ @param1 +'''                   ' + char(10)
			    SELECT @v_dSql += '       AND    A.FP_PLAN_ID   = '''+ @param2 +'''                   ' + char(10)

	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param6)) + char(10)

				IF(LEN(@param7) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param7 +''' ' + char(10)
				    END					    
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param8))   + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param9)) + char(10)

				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param10)) + char(10)
				IF(LEN(@param11) > 0)	    
				    BEGIN				    
                        SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param11 +''' ' + char(10)
				    END	

			    SELECT @v_dSql += '     -- S      ' + char(10)
			    SELECT @v_dSql += '     UNION ALL ' + char(10)
			    SELECT @v_dSql += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
			    SELECT @v_dSql += '     FROM   '+ TRY_CONVERT(NVARCHAR, @param12) +' A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '     WHERE  A.INSTANCE_ID  = '''+ @param1 +'''                   ' + char(10)
			    SELECT @v_dSql += '     AND    A.FP_PLAN_ID   = '''+ @param2 +'''                   ' + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param6)) + char(10)

				IF(LEN(@param7) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param7 +''' ' + char(10)
				    END					    
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param8)) + char(10)

                SELECT @v_dSql += '     AND    A.FACTORY_ID = ''-''                ' + char(10)
				SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param11 +''' ' + char(10)

			    SELECT @v_dSql += '     UNION ALL                  ' + char(10)
			    SELECT @v_dSql += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
			    SELECT @v_dSql += '     FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)           ' + char(10)
			    SELECT @v_dSql += '     WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) < '''+ @param3 +''' ' + char(10)
			    SELECT @v_dSql += '     AND    A.PLAN_TYPE = ''RELEASE''                            ' + char(10)

	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param6)) + char(10)

				IF(LEN(@param7) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param7 +''' ' + char(10)
				    END		
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param8)) + char(10)
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param9)) + char(10)
                SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param10 +''' ' + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param10)) + char(10)

			    SELECT @v_dSql += '     UNION ALL ' + char(10)
			    SELECT @v_dSql += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
			    SELECT @v_dSql += '     FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '     WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @param4 +''' AND '''+ @param5 +''' ' + char(10)

	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param6)) + char(10)

				IF(LEN(@param7) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param7 +''' ' + char(10)
				    END	
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param8)) + char(10)
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param9)) + char(10)
                SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param11 +''' ' + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param10)) + char(10)
			    SELECT @v_dSql += ' ) A                                    ' + char(10)
			    SELECT @v_dSql += ' INNER JOIN SCM_ITEM_M B WITH(NOLOCK)   ' + char(10)
			    SELECT @v_dSql += ' ON    A.COMPANY_ID     = B.COMPANY_ID  ' + char(10)
			    SELECT @v_dSql += ' AND   A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += ' AND   A.SITE_ID        = B.SITE_ID     ' + char(10)
			    SELECT @v_dSql += ' AND   A.ITEM_ID        = B.ITEM_ID     ' + char(10)
			    SELECT @v_dSql += ' ORDER BY ISNULL(B.NICK_NAME,''-'')     ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00607화면에서 findPlanner_List_exception 정보갖고오기                                                                            */
		/*   Param : @Param1                                                                                                                    */
		/*   Param : INSTANCE_ID                                                                                 */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_findPlanner_List_exception' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.ATTRIBUTE6 AS CODE, ISNULL(B.USER_NAME,''-'') + '' ('' + A.ATTRIBUTE6 + '')'' AS NAME   ' + char(10)
                SELECT @v_dSql += '     , (CASE WHEN A.ATTRIBUTE6 = '''+ @p_user_id +''' THEN ''Y'' ELSE ''N'' END) AS DEFAULT_CHECK ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN TH_UIS_USER_DETAIL B WITH(NOLOCK)       ' + char(10)
                SELECT @v_dSql += ' ON     A.ATTRIBUTE6 = B.USER_ID                         ' + char(10)
                SELECT @v_dSql += ' WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
                SELECT @v_dSql += ' AND    A.SEGMENT1         = '''+ @param1 +'''           ' + char(10)
                SELECT @v_dSql += ' AND    A.ACTIVE_FLAG      = ''Y''                       ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.SORT_ORDER                                   ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00607화면에서 find_ListData 정보갖고오기                                                                                         */
		/*   Param : @Param1  ,    @Param2,  @Param3,      @Param4                                                                              */
		/*   Param : INSTANCE_ID , PLAN_ID,  OPERATION_ID, AMEND_TABLE                                                                          */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_find_ListData' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                      ' + char(10)
                SELECT @v_dSql += '     , A.COMPANY_ID, A.DIVISION_ID, A.CATEGORY_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
                SELECT @v_dSql += '     , A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION ' + char(10)
                SELECT @v_dSql += '     , A.PRODUCTION_TYPE, A.MARKET                         ' + char(10)
                SELECT @v_dSql += '     , A.LINE_ID, A.ELECTRODE_TYPE                         ' + char(10)
                SELECT @v_dSql += '     , A.CUSTOMER_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE ' + char(10)
                SELECT @v_dSql += '     , A.TOP_ITEM_ID                                       ' + char(10)
                SELECT @v_dSql += '     , A.CELL_GROUP_CODE                                   ' + char(10)
                SELECT @v_dSql += '     , A.IN_QTY, A.OUT_QTY                                 ' + char(10)
                SELECT @v_dSql += '     , A.SHIPPING_QTY, A.NET_QTY, A.CARRYOVER_QTY          ' + char(10)
                SELECT @v_dSql += ' FROM  '+ TRY_CONVERT(NVARCHAR, @param4) +' A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE  1=0                               ' + char(10)
                SELECT @v_dSql += ' AND   A.INSTANCE_ID  = '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += ' AND   A.FP_PLAN_ID   = '''+ @param2 +''' ' + char(10)
                SELECT @v_dSql += ' AND   A.CATEGORY_ID  = ''PLAN''          ' + char(10)
                SELECT @v_dSql += ' AND   A.OPERATION_ID = '''+ @param3 +''' ' + char(10)
                SELECT @v_dSql += ' AND   A.FACTORY_ID <> ''-''              ' + char(10)
         SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
                SELECT @v_dSql += '    , A.ITEM_ID, A.MARKET, A.PRODUCTION_TYPE, A.PLAN_DATE ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END		
		/****************************************************************************************************************************************/
		/*   FP00607화면에서 find_ListData_BOH 정보갖고오기                                                                         */
		/*   Param : @Param1  ,    @Param2 ,   @Param3    ,   @Param3                                                                           */
		/*   Param : INSTANCE_ID , PLAN_ID ,   PLAN_DATE,     AMEND_CUTOFF_BOH_TABLE                                                            */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_find_ListData_BOH' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.FP_PLAN_ID                        ' + char(10)
                SELECT @v_dSql += '     , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID              ' + char(10)
                SELECT @v_dSql += '     , A.PLANT_ID, A.ITEM_ID, A.TOP_ITEM_ID                ' + char(10)
                SELECT @v_dSql += '     , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION            ' + char(10)
                SELECT @v_dSql += '     , ISNULL(ISNULL(A.MODIFY_QTY, A.QTY), 0) AS QTY       ' + char(10)
                SELECT @v_dSql += '     , '''+ @param3 +''' AS PLAN_DATE                      ' + char(10)
                SELECT @v_dSql += ' FROM  '+ TRY_CONVERT(NVARCHAR, @param4) +' A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE  A.INSTANCE_ID  = '''+ @param1 +'''                 ' + char(10)
                SELECT @v_dSql += ' AND    A.FP_PLAN_ID   = '''+ @param2 +'''                 ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LOCATION ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END	
		/****************************************************************************************************************************************/
		/*   FP00607화면에서 find_ListData_LT 정보갖고오기                                                                                      */
		/*   Param : @Param1  ,    @Param2 ,   @Param3    ,   @Param4                                                                           */
		/*   Param : DIVISION ,    SITE,       PLNAT  ,       FACTORY                                                                           */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_find_ListData_LT' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '     , A.ITEM_ID, A.LINE_ID, A.OPERATION_ID ' + char(10)
                SELECT @v_dSql += '     , A.SHORTER_LT ' + char(10)
                SELECT @v_dSql += ' FROM   FP_FORMATION_SHORTER_LT_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE  1=0 ' + char(10)
				IF(LEN(@param1) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1)) + char(10)
				    END
                IF(LEN(@param2) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))     + char(10)
				    END
                IF(LEN(@param3) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param3))    + char(10)
				    END
                IF(LEN(@param4) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param4))  + char(10)
				    END
                SELECT @v_dSql += ' ORDER BY A.FACTORY_ID, A.LINE_ID, A.ITEM_ID ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END	
		/****************************************************************************************************************************************/
		/*   FP00607화면에서 find_accumQTY 정보갖고오기                                                                                         */
		/*   Param :                                                                                                                            */
		/*   Param :                                                                                                                            */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_find_accumQTY' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT NULL X ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END	
		/****************************************************************************************************************************************/
		/*   FP00607화면에서 find_operationBOD 정보갖고오기                                                                                     */
		/*   Param : @Param1  ,    @Param2 ,   @Param3    ,   @Param4  ,   @Param5                                                              */
		/*   Param : DIVISION ,    SITE,       PLNAT_ID ,     FACTORY   ,  OPERATION                                                            */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_find_operationBOD' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' -- BOD : item-operation 먼저 보고 없으면 opration 체크. 최종결과가 0 이면 기본 LT 인 1일을 지정    ' + char(10)
                SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID ' + char(10)
                SELECT @v_dSql += '     , (CASE WHEN A.MOVING_TIME_DAY IS NULL OR A.MOVING_TIME_DAY = 0 THEN 1 ELSE A.MOVING_TIME_DAY END) AS MOVING_TIME_DAY ' + char(10)
                SELECT @v_dSql += ' FROM (                                                                                             ' + char(10)
                SELECT @v_dSql += ' 	  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, ''-'' AS ITEM_ID ' + char(10)
                SELECT @v_dSql += '          , BB.BUFFER_TIME, ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') AS BUFFER_TIME_UOM                             ' + char(10)
                SELECT @v_dSql += '          , CASE WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''MINUTE'' THEN CEILING(ISNULL(BB.BUFFER_TIME,0)/1440) ' + char(10)
                SELECT @v_dSql += '                 WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''HOUR''   THEN CEILING(ISNULL(BB.BUFFER_TIME,0)/24)   ' + char(10)
                SELECT @v_dSql += '                 WHEN ISNULL(BB.BUFFER_TIME_UOM,''MINUTE'') = ''DAY''    THEN CEILING(ISNULL(BB.BUFFER_TIME,0))      ' + char(10)
                SELECT @v_dSql += '                 END  MOVING_TIME_DAY                       ' + char(10)
                SELECT @v_dSql += '       FROM  SCM_OPERATION_MOVE_2_V A WITH(NOLOCK)          ' + char(10)
                SELECT @v_dSql += '       LEFT OUTER JOIN SCM_OPERATION_MOVE_M BB WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '       ON   A.COMPANY_ID    = BB.COMPANY_ID        ' + char(10)
    SELECT @v_dSql += '       AND  A.DIVISION_ID   = BB.DIVISION_ID       ' + char(10)
                SELECT @v_dSql += '       AND  A.SITE_ID       = BB.SITE_ID           ' + char(10)
                SELECT @v_dSql += '       AND  A.PLANT_ID      = BB.PLANT_ID          ' + char(10)
                SELECT @v_dSql += '       AND  A.FACTORY_ID    = BB.FACTORY_ID        ' + char(10)
                SELECT @v_dSql += '       AND  A.OPERATION_ID  = BB.OPERATION_ID      ' + char(10)
                SELECT @v_dSql += '       AND  A.MODEL_TYPE = BB.MODEL_TYPE        ' + char(10)
                SELECT @v_dSql += '       AND  A.LINE_ATTR_1   = BB.LINE_ATTR_1       ' + char(10)
                SELECT @v_dSql += '       AND  ISNULL(BB.ACTIVE_FLAG, ''Y'')  = ''Y'' ' + char(10)
                SELECT @v_dSql += '       WHERE 1=1                                   ' + char(10)
				IF(LEN(@param1) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1)) + char(10)
				    END
                IF(LEN(@param2) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))     + char(10)
				    END
                IF(LEN(@param3) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param3))    + char(10)
				    END
                IF(LEN(@param4) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param4))  + char(10)
				    END

                SELECT @v_dSql += '     AND   A.OPERATION_ID = '''+ @param5 +''' ' + char(10)

                SELECT @v_dSql += ' 	UNION ALL                                ' + char(10)
                SELECT @v_dSql += ' 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID ' + char(10)
                SELECT @v_dSql += '         , A.BUFFER_TIME, A.BUFFER_TIME_UOM                                                             ' + char(10)
                SELECT @v_dSql += '         , CASE WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''MINUTE'' THEN CEILING(ISNULL(A.BUFFER_TIME,0)/1440) ' + char(10)
                SELECT @v_dSql += '                WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''HOUR''   THEN CEILING(ISNULL(A.BUFFER_TIME,0)/24)   ' + char(10)
                SELECT @v_dSql += '                WHEN ISNULL(A.BUFFER_TIME_UOM,''MINUTE'') = ''DAY''    THEN CEILING(ISNULL(A.BUFFER_TIME,0))      ' + char(10)
                SELECT @v_dSql += '                END MOVING_TIME_DAY                    ' + char(10)
                SELECT @v_dSql += ' 	FROM   SCM_ITEM_FLOW_EXCEPT_M A WITH(NOLOCK)      ' + char(10)
                SELECT @v_dSql += ' 	INNER JOIN SCM_OPERATION_MOVE_2_V BB WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' 	ON    A.COMPANY_ID    = BB.COMPANY_ID   ' + char(10)
                SELECT @v_dSql += ' 	AND   A.DIVISION_ID   = BB.DIVISION_ID  ' + char(10)
                SELECT @v_dSql += ' 	AND   A.SITE_ID       = BB.SITE_ID      ' + char(10)
                SELECT @v_dSql += ' 	AND   A.PLANT_ID      = BB.PLANT_ID     ' + char(10)
                SELECT @v_dSql += ' 	AND   A.FACTORY_ID    = BB.FACTORY_ID   ' + char(10)
                SELECT @v_dSql += ' 	AND   A.OPERATION_ID  = BB.OPERATION_ID ' + char(10)
                SELECT @v_dSql += ' 	AND   A.MODEL_TYPE    = BB.MODEL_TYPE   ' + char(10)
                SELECT @v_dSql += ' 	AND   A.LINE_ATTR_1   = BB.LINE_ATTR_1  ' + char(10)
                SELECT @v_dSql += ' 	WHERE  1=1                              ' + char(10)
				IF(LEN(@param1) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1)) + char(10)
				    END
                IF(LEN(@param2) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param2))     + char(10)
				    END
                IF(LEN(@param3) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param3))    + char(10)
				    END
                IF(LEN(@param4) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param4))  + char(10)
				    END
                SELECT @v_dSql += '     AND   A.OPERATION_ID = '''+ @param5 +''' ' + char(10)
                SELECT @v_dSql += ' 	AND A.ACTIVE_FLAG = ''Y''             ' + char(10)
                SELECT @v_dSql += ' ) A                                          ' + char(10)
                SELECT @v_dSql += ' ORDER BY FACTORY_ID, OPERATION_ID, (CASE WHEN ITEM_ID = ''-'' THEN 2 ELSE 1 END), ITEM_ID ' + char(10)
				
				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END

		/****************************************************************************************************************************************/
		/*   FP00607화면에서 find_ShipPlanList 정보갖고오기                                                                                     */
		/*   Param : @Param1  ,    @Param2 ,   @Param3    ,   @Param4  ,   @Param5                                                              */
		/*   Param : DIVISION ,    SITE,       PLNAT_ID ,     FACTORY   ,  OPERATION                                                            */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_find_ShipPlanList' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT '''' INSTANCE_ID, '''' PLAN_DATE,     '''' FP_PLAN_ID, '''' COMPANY_ID     ' + char(10)
                SELECT @v_dSql += ' , '''' DIVISION_ID,   '''' SITE_ID,       '''' PLANT_ID,        '''' FACTORY_ID   ' + char(10)
                SELECT @v_dSql += ' , '''' LINE_ID,       '''' OPERATION_ID,  '''' ITEM_ID,         '''' TOP_ITEM_ID  ' + char(10)
                SELECT @v_dSql += ' , '''' ITEM_TYPE,     '''' LOCATION,      '''' PRODUCTION_TYPE, '''' MARKET       ' + char(10)
                SELECT @v_dSql += ' , '''' ELECTRODE_TYPE,'''' CATEGORY_ID,   '''' SALE_SIMUL_QTY,  '''' ORIG_QTY     ' + char(10)  
                SELECT @v_dSql += ' , '''' ACTION         ' + char(10)
                
				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   FP00607화면에서 find_AfterDegasLT 정보갖고오기                                                                                     */
		/*   Param : @Param1  ,    @Param2 ,   @Param3    ,   @Param4  ,   @Param5    , @Param6                                                 */
		/*   Param : DIVISION ,    SITE,       PLNAT_ID ,     FACTORY   ,  LINE       , ITEM                                                    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_find_AfterDegasLT' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT  A.COMPANY_ID, A.SITE_ID, A.DIVISION_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '       , A.ITEM_ID, A.LINE_ID ' + char(10)
                SELECT @v_dSql += '       , MAX(ROUND(ISNULL(AFTER_DEGAS_LT,0)/60/24, 2)) AS AFTER_DEGAS_LT ' + char(10)
                SELECT @v_dSql += ' FROM   FP_FORMATION_LT_V A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE  A.DIVISION_ID  = '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += ' AND    A.SITE_ID      = '''+ @param2 +''' ' + char(10)
                SELECT @v_dSql += ' AND    A.PLANT_ID     = '''+ @param3 +''' ' + char(10)
                SELECT @v_dSql += ' AND    A.FACTORY_ID   = '''+ @param4 +''' ' + char(10)
                SELECT @v_dSql += ' AND    A.ITEM_ID      = '''+ @param6 +''' ' + char(10)
                SELECT @v_dSql += ' AND    A.LINE_ID      = '''+ @param5 +''' ' + char(10)
                SELECT @v_dSql += ' GROUP BY A.COMPANY_ID, A.SITE_ID, A.DIVISION_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '    , A.ITEM_ID, A.LINE_ID ' + char(10)
				
				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END	
		/****************************************************************************************************************************************/
		/*   FP00607_LineAddPopup화면에서 find_dup 정보갖고오기                                                                        */
		/*   Param : @Param1,      @Param2,  @Param3,    @Param4,  @Param5,  @Param6,  @Param7,  @Param8,  @Param9,  @Param10, @Param11         */
		/*   Param : INSTANCE_ID,  PLAN_ID,  PLAN_DATE , DIVISION, SITE,     PLANT,    ITEM,     TOP_ITEM, OPERATION, FACTORY, LINE             */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_find_dup' 
		    BEGIN	
			    SELECT @v_dSql = ''
			    SELECT @v_dSql += ' SELECT COUNT(*) AS CNT                        ' + char(10)
			    SELECT @v_dSql += ' FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK)    ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID     = '''+ @param1 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.FP_PLAN_ID      = '''+ @param3 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.DIVISION_ID     = '''+ @param4 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.SITE_ID         = '''+ @param5 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.PLANT_ID        = '''+ @param6 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.ITEM_ID         = '''+ @param7 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.TOP_ITEM_ID     = '''+ @param8 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.OPERATION_ID    = '''+ @param9 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.FACTORY_ID      = '''+ @param10 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.PRODUCTION_TYPE = ''-''              ' + char(10)
			    SELECT @v_dSql += ' AND    A.MARKET          = ''D''              ' + char(10)
			    SELECT @v_dSql += ' AND    A.LINE_ID         = '''+ @param11 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.CUSTOMER_ID     = ''-''              ' + char(10)
			    SELECT @v_dSql += ' AND    A.PLAN_DATE        = CONVERT(DATE,'''+ @param2 +''') ' + char(10)
				SELECT @v_dSql += ' AND    ( A.IN_QTY > 0 AND A.OUT_QTY > 0 ) ' + char(10) -- 계획값 이외에 값이 있어 추가가 안되어 넣음 20221115 by cys

			    --SELECT @v_dSql
				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00607_LineAddPopup화면에서 (MPP/WPP경우) find_LineAdd_dup 정보갖고오기                                                                        */
		/*   Param : @Param1,      @Param2,  @Param3,    @Param4,  @Param5,  @Param6,  @Param7,  @Param8,  @Param9,  @Param10, @Param11         */
		/*   Param : INSTANCE_ID,  PLAN_ID,  PLAN_DATE , DIVISION, SITE,     PLANT,    ITEM,     TOP_ITEM, OPERATION, FACTORY, LINE             */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_find_LineAdd_dup' 
		    BEGIN	
			    SELECT @v_dSql = ''
			    SELECT @v_dSql += ' SELECT COUNT(*) AS CNT                        ' + char(10)
			    SELECT @v_dSql += ' FROM   FP_AMEND_PLAN_FORM_H A WITH(NOLOCK)    ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID     = '''+ @param1 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.FP_PLAN_ID      = '''+ @param3 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.DIVISION_ID     = '''+ @param4 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.SITE_ID         = '''+ @param5 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.PLANT_ID        = '''+ @param6 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.ITEM_ID         = '''+ @param7 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.TOP_ITEM_ID     = '''+ @param8 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.OPERATION_ID    = '''+ @param9 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.FACTORY_ID      = '''+ @param10 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.PRODUCTION_TYPE = ''-''              ' + char(10)
			    SELECT @v_dSql += ' AND    A.MARKET          = ''D''              ' + char(10)
			    SELECT @v_dSql += ' AND    A.LINE_ID         = '''+ @param11 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.PLAN_DATE        = CONVERT(DATE,'''+ @param2 +''') ' + char(10)
				SELECT @v_dSql += ' AND    ISNULL(A.WPP_OUT_QTY,0) + ISNULL(A.MPP_OUT_QTY,0) > 0 ' + char(10) -- wpp, mpp 수량 조건 추가
				
			    --SELECT @v_dSql
				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00607_LineAddPopup화면에서 find_targetInfo 정보갖고오기                                                                              */
		/*   Param : @Param1,      @Param2,  @Param3,    @Param4,  @Param5,  @Param6,  @Param7,  @Param8,    @Param9,  @Param10,  @Param11    ,  @Param12      */
		/*   Param : INSTANCE_ID,  PLAN_ID,  DIVISION,   SITE,     PLANT,    FACTORY,  LINE,     OPERATION,  ITEM,     TOP_ITEM,  ELECTORDE_TYPEm LOCATION  */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00607_find_targetInfo' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.* ' + char(10)
                SELECT @v_dSql += '     --, ( CASE WHEN A.OPERATION_ID=''A9000'' THEN ( CASE WHEN G.ITEM_ID IS NULL THEN ''RCCP or Test Target'' ELSE '''' END ) ELSE '''' END ) AS MSG1 ' + char(10)
                SELECT @v_dSql += '     , '''' AS MSG1                                                                              ' + char(10)
                SELECT @v_dSql += '     --, ( CASE WHEN H.ITEM_ID IS NULL THEN ''SCP or Test Target-Market'' ELSE '''' END ) AS MSG2 ' + char(10)
                SELECT @v_dSql += '     , '''' AS MSG2                                                              ' + char(10)
                SELECT @v_dSql += '     , CASE WHEN R.FACTORY_ID IS NULL THEN ''Permissions'' ELSE '''' END AS MSG3 ' + char(10)
                SELECT @v_dSql += ' FROM (                                                                          ' + char(10)
                SELECT @v_dSql += '       SELECT '''+ @param1 +''' AS INSTANCE_ID                                   ' + char(10)
                SELECT @v_dSql += '           , (SELECT COMPANY_ID FROM SCM_FACTORY_M FF WHERE FF.FACTORY_ID = '''+ @param6 +''' AND  FF.ACTIVE_FLAG = ''Y'') AS COMPANY_ID      ' + char(10)
                SELECT @v_dSql += '           , '''+ @param3 +''' AS DIVISION_ID, '''+ @param4 +''' AS SITE_ID, '''+ @param5 +''' AS PLANT_ID                                    ' + char(10)
                SELECT @v_dSql += '           , '''+ @param9 +''' AS ITEM_ID, '''+ @param8 +''' AS OPERATION_ID, '''+ @param6 +''' AS FACTORY_ID, '''+ @param12 +''' AS LOCATION ' + char(10)
                SELECT @v_dSql += '           , ''-'' AS PRODUCTION_TYPE, ''D'' AS MARKET                          ' + char(10)
                SELECT @v_dSql += '           , '''+ @param7 +''' AS LINE_ID, '''+ @param11 +''' AS ELECTRODE_TYPE ' + char(10)
                SELECT @v_dSql += '           , '''+ @param10 +''' AS TOP_ITEM_ID                                  ' + char(10)
                SELECT @v_dSql += ' ) A                                                        ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                                                              ' + char(10)
                SELECT @v_dSql += '       SELECT DISTINCT INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID ' + char(10)
                SELECT @v_dSql += '       FROM   FP_INSTANCE_ITEM_V   ' + char(10)
                SELECT @v_dSql += ' ) G                               ' + char(10)
                SELECT @v_dSql += ' ON  A.INSTANCE_ID = G.INSTANCE_ID ' + char(10)
                SELECT @v_dSql += ' AND A.COMPANY_ID  = G.COMPANY_ID  ' + char(10)
                SELECT @v_dSql += ' AND A.DIVISION_ID = G.DIVISION_ID ' + char(10)
                SELECT @v_dSql += ' AND A.SITE_ID     = G.SITE_ID     ' + char(10)
                SELECT @v_dSql += ' AND A.PLANT_ID    = G.PLANT_ID    ' + char(10)
                SELECT @v_dSql += ' AND A.ITEM_ID     = G.ITEM_ID     ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                 ' + char(10)
                SELECT @v_dSql += '       SELECT DISTINCT H.*         ' + char(10)
                SELECT @v_dSql += '       FROM (                      ' + char(10)
                SELECT @v_dSql += '             SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID           ' + char(10)
                SELECT @v_dSql += '             --, A.MARKET                                                     ' + char(10)
                SELECT @v_dSql += '             , A.ITEM_ID                                                      ' + char(10)
                SELECT @v_dSql += '             FROM   FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '             WHERE  A.CELL_PLAN_ID = (SELECT MAX(CELL_PLAN_ID) AS CELL_PLAN_ID FROM FP_WEEKLY_DEMAND_PRODUCT_CELL_BIZ_TARGET_H A WITH(NOLOCK) WHERE 1=1 AND SITE_ID = '''+ @param4 +''' AND DIVISION_ID = '''+ @param3 +''') ' + char(10)
                SELECT @v_dSql += '             UNION ALL                                              ' + char(10)
                SELECT @v_dSql += '             SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10)
                SELECT @v_dSql += '             --, A.MARKET                                           ' + char(10)
                SELECT @v_dSql += '             , ISNULL(A.MODEL,A.ITEM_ID) AS ITEM_ID                 ' + char(10)
                SELECT @v_dSql += '             FROM   FP_WEEKLY_DEMAND_PRODUCT_TEST_H A WITH(NOLOCK)  ' + char(10)
                SELECT @v_dSql += '             WHERE  A.DUE_DATE >= ( SELECT CONVERT(DATETIME,CONVERT(VARCHAR,PLAN_START_TIME,112)) ' + char(10)
                SELECT @v_dSql += '                                    FROM   SCM_FP_PLAN_H                  ' + char(10)
                SELECT @v_dSql += '                                    WHERE  PLAN_ID = '''+ @param2 +''' )  ' + char(10)
                SELECT @v_dSql += '             UNION ALL                                                    ' + char(10)
                SELECT @v_dSql += '             SELECT  DISTINCT C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID      ' + char(10)
                SELECT @v_dSql += '             --, ''D'' AS MARKET                                          ' + char(10)
                SELECT @v_dSql += '             , C.CHILD_ITEM_ID AS ITEM_ID                                 ' + char(10)
                SELECT @v_dSql += '             FROM  FP_RELEASE_FULL_PLAN_H A WITH(NOLOCK)                  ' + char(10)
                SELECT @v_dSql += '                  , (                                                     ' + char(10)
                SELECT @v_dSql += '                      SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.DIVISION_ID, A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                          , MAX(AMEND_PLAN_ID) AS AMEND_PLAN_ID    ' + char(10)
                SELECT @v_dSql += '                      FROM  FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)            ' + char(10)
                SELECT @v_dSql += '                           , (                                               ' + char(10)
                SELECT @v_dSql += '                              SELECT INSTANCE_ID                             ' + char(10)
                SELECT @v_dSql += '                                  , DIVISION_ID                              ' + char(10)
                SELECT @v_dSql += '          , FACTORY_ID                               ' + char(10)
                SELECT @v_dSql += '                                  , MAX(INSTANCE_DATE) AS INSTANCE_DATE      ' + char(10)
                SELECT @v_dSql += '                              FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)   ' + char(10)
                SELECT @v_dSql += '                              WHERE  A.INSTANCE_DATE <= GETDATE()            ' + char(10)
                SELECT @v_dSql += '                              GROUP  BY INSTANCE_ID, DIVISION_ID, FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                             ) B                                             ' + char(10)
                SELECT @v_dSql += '                      WHERE  A.INSTANCE_ID    = B.INSTANCE_ID                ' + char(10)
                SELECT @v_dSql += '                      AND    A.INSTANCE_DATE  = B.INSTANCE_DATE              ' + char(10)
                SELECT @v_dSql += '                      AND    A.DIVISION_ID    = B.DIVISION_ID                ' + char(10)
                SELECT @v_dSql += '                      AND    A.FACTORY_ID     = B.FACTORY_ID                 ' + char(10)
                SELECT @v_dSql += '                      AND    A.INSTANCE_ID    = (SELECT MAX(SL.ATTRIBUTE1) AS PACK_INST FROM SCM_SYS_LOOKUP_VALUE SL WITH(NOLOCK) WHERE SL.LOOKUP_TYPE_CODE = ''FORMATION_ID_MAPPING'' AND SL.SEGMENT2 = '''+ @param1 +''') ' + char(10)
                SELECT @v_dSql += '                      GROUP  BY A.INSTANCE_ID, A.INSTANCE_DATE, A.DIVISION_ID, A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                   ) B                                ' + char(10)
                SELECT @v_dSql += '                  ,SCM_BOM_M C WITH(NOLOCK)           ' + char(10)
                SELECT @v_dSql += '             WHERE A.INSTANCE_ID   = B.INSTANCE_ID    ' + char(10)
                SELECT @v_dSql += '             AND   A.AMEND_PLAN_ID = B.AMEND_PLAN_ID  ' + char(10)
                SELECT @v_dSql += '             AND   A.DIVISION_ID   = C.DIVISION_ID    ' + char(10)
                SELECT @v_dSql += '             AND   A.ITEM_ID       = C.PARENT_ITEM_ID ' + char(10)
                SELECT @v_dSql += '             AND   C.EFF_END_DATE  >= GETDATE()       ' + char(10)
                SELECT @v_dSql += '       ) H                         ' + char(10)
                SELECT @v_dSql += ' ) H                               ' + char(10)
                SELECT @v_dSql += ' ON  A.COMPANY_ID  = H.COMPANY_ID  ' + char(10)
                SELECT @v_dSql += ' AND A.DIVISION_ID = H.DIVISION_ID ' + char(10)
                SELECT @v_dSql += ' AND A.SITE_ID     = H.SITE_ID     ' + char(10)
                SELECT @v_dSql += ' --AND A.PLANT_ID    = H.PLANT_ID  ' + char(10)
                SELECT @v_dSql += ' --AND A.MARKET      = H.MARKET    ' + char(10)
                SELECT @v_dSql += ' AND A.TOP_ITEM_ID = H.ITEM_ID     ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN (                 ' + char(10)
                SELECT @v_dSql += '      SELECT  DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID ' + char(10)
                SELECT @v_dSql += '      FROM	   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '      WHERE  1=1                 ' + char(10)
                SELECT @v_dSql += '      AND    R.USER_ID     = '''+ @p_user_id +'''  ' + char(10)
                SELECT @v_dSql += '      AND    R.SAVE_FLAG   = ''Y''                 ' + char(10)
                SELECT @v_dSql += '      AND    R.INSTANCE_ID = '''+ @param1 +'''     ' + char(10)
                SELECT @v_dSql += ' ) R                                               ' + char(10)
                SELECT @v_dSql += ' ON   1=1                                          ' + char(10)
                SELECT @v_dSql += ' AND  A.COMPANY_ID    = R.COMPANY_ID               ' + char(10)
                SELECT @v_dSql += ' AND  A.DIVISION_ID   = R.DIVISION_ID              ' + char(10)
                SELECT @v_dSql += ' AND  A.SITE_ID       = R.SITE_ID                  ' + char(10)
                SELECT @v_dSql += ' AND  A.PLANT_ID      = R.PLANT_ID                 ' + char(10)
                SELECT @v_dSql += ' AND  A.FACTORY_ID    = R.FACTORY_ID               ' + char(10)
                SELECT @v_dSql += ' AND  A.OPERATION_ID  = R.OPERATION_ID             ' + char(10)
                SELECT @v_dSql += ' AND  A.LINE_ID       = R.LINE_ID                  ' + char(10)

			    --SELECT @v_dSql
				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00621화면에서 findLineCode_List 정보갖고오기                                                                                     */
		/*   Param : @Param1   , Param2  , Param3 ,   Param4 ,      Param5 ,  Param6 , Param7 , Param8 , Param9 , Param10 , Param11 , Param12   */
		/*   Param : INSTANCE  , PLAN_ID , PLAN_TYPE, CONFIRM_AREA, DIVISION, SITE,    PLANT,   FACTORY,  LINE  ,OPERATION, ALL_LINE, USER_LT,  */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00621_findLineCode_List' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.LINE_ID AS CODE ' + char(10)
                SELECT @v_dSql += '     , ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_LINE_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE  A.ACTIVE_FLAG = ''Y''     ' + char(10)
                SELECT @v_dSql += ' AND EXISTS (                     ' + char(10)
                SELECT @v_dSql += '             SELECT 1             ' + char(10)
                SELECT @v_dSql += '             FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '             WHERE  A.COMPANY_ID   = B.COMPANY_ID      ' + char(10)
                SELECT @v_dSql += '             AND    A.DIVISION_ID  = B.DIVISION_ID     ' + char(10)
                SELECT @v_dSql += '             AND    A.SITE_ID      = B.SITE_ID         ' + char(10)
                SELECT @v_dSql += '             AND    A.PLANT_ID     = B.PLANT_ID        ' + char(10)
                SELECT @v_dSql += '             AND    A.FACTORY_ID   = B.FACTORY_ID      ' + char(10)
                SELECT @v_dSql += '             AND    A.OPERATION_ID = B.OPERATION_ID    ' + char(10)
                SELECT @v_dSql += '             AND    A.LINE_ID      = B.LINE_ID         ' + char(10)
                SELECT @v_dSql += '             AND    B.USER_ID      ='''+ @p_user_id +''' ' + char(10)
                SELECT @v_dSql += ' 	       )               ' + char(10)
                SELECT @v_dSql += ' AND EXISTS (               ' + char(10)
                SELECT @v_dSql += '            SELECT 1 FROM ( ' + char(10)
                SELECT @v_dSql += '                SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID ' + char(10)
         SELECT @v_dSql += '                FROM  SCM_FACTORY_M A WITH(NOLOCK)              ' + char(10)
                SELECT @v_dSql += '                INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                ON    A.FACTORY_ID=B.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                AND   B.ACTIVE_FLAG = ''Y''     ' + char(10)
                SELECT @v_dSql += '                WHERE 1=1                       ' + char(10)
                SELECT @v_dSql += '                AND   B.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += '            ) C ' + char(10)
                SELECT @v_dSql += '       WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += ' ) ' + char(10)

				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param8)) + char(10)
				--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param9)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param10)) + char(10)

				IF(LEN(@param1) > 0)
				    BEGIN
                        SELECT @v_dSql += ' AND EXISTS ( SELECT  1 ' + char(10)

                        SELECT @v_dSql += '              FROM  SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)       ' + char(10)
                        SELECT @v_dSql += '              WHERE  LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''     ' + char(10)
                        SELECT @v_dSql += '              AND    LV1.SEGMENT1         = ''' + @param1 + ''' ' + char(10)
                        SELECT @v_dSql += '              AND    LV1.ACTIVE_FLAG      = ''Y''               ' + char(10)
                        SELECT @v_dSql += '              AND    LV1.ATTRIBUTE1       = ''BUILDING''        ' + char(10)
                        SELECT @v_dSql += '              UNION ALL ' + char(10)
                        SELECT @v_dSql += '              SELECT  1 ' + char(10)
                        SELECT @v_dSql += '              FROM  SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK), ' + char(10)
                        SELECT @v_dSql += '                    SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)  ' + char(10)
                        SELECT @v_dSql += '              WHERE LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
                        SELECT @v_dSql += '              AND   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.SEGMENT1         = LV2.SEGMENT1        ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.SEGMENT1         = ''' + @param1 + ''' ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.ACTIVE_FLAG      = ''Y''               ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.ATTRIBUTE1       = ''PLAN GROUP''      ' + char(10)
                        SELECT @v_dSql += '              AND   LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) ' + char(10)
						SELECT @v_dSql += '            ) ' + char(10)
				    END
                --ALL_LINE
				IF( @param11 != 'Y')
				    IF(@param1 = 'PL_FORM_A')
				        BEGIN
                            SELECT @v_dSql += ' AND A.MODEL_TYPE IN (  ' + char(10)
                            SELECT @v_dSql += '           SELECT A.SEGMENT2 FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
                            SELECT @v_dSql += '           WHERE A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''    ' + char(10)

							IF(LEN(@param12) > 0)
							    BEGIN
								    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ATTRIBUTE6' , 'EQ', @param12)) + char(10)
								END
							ELSE
							    BEGIN
								    SELECT @v_dSql += '           AND A.ATTRIBUTE6 IN ('''') ' + char(10)
								END

                            SELECT @v_dSql += '           ) ' + char(10)

				        END
                    ELSE
				        BEGIN
                            SELECT @v_dSql += ' AND A.LINE_ID IN (          ' + char(10)
                     SELECT @v_dSql += '     SELECT DISTINCT LINE_ID ' + char(10)
                            SELECT @v_dSql += '     FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK) ' + char(10)
                            SELECT @v_dSql += '     WHERE  AA.INSTANCE_ID = '''+ @param1 +'''   ' + char(10)

							IF(LEN(@param12) > 0)
							    BEGIN
								    SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.USER_ID' , 'EQ', @param12)) + char(10)
								END
							ELSE
							    BEGIN
								    SELECT @v_dSql += '           AND AA.USER_ID IN ('''') ' + char(10)
								END
                            SELECT @v_dSql += ' ) ' + char(10)
				        END
                --PLAN_TYPE, CONFIRM_AREA
				IF( @param3 = 'RELEASE' AND @param4 = 'PLAN GROUP')
				    BEGIN
                        SELECT @v_dSql += ' AND A.MODEL_TYPE IN (           ' + char(10)
                        SELECT @v_dSql += '        SELECT KK.PLAN_GROUP_ID  ' + char(10)
                        SELECT @v_dSql += '        FROM   FP_RELEASE_PLAN_INFO_H KK WITH(NOLOCK)  ' + char(10)
                        SELECT @v_dSql += '        WHERE  KK.INSTANCE_ID = '''+ @param1 +'''      ' + char(10)
                        SELECT @v_dSql += '        AND    KK.RELEASE_PLAN_ID = '''+ @param2 +'''  ' + char(10)
                        SELECT @v_dSql += ' )  ' + char(10)
				    END

                SELECT @v_dSql += ' GROUP BY A.LINE_ID, A.LINE_NAME ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.LINE_ID              ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00621화면에서 findFpPlan_info 정보갖고오기                                                                                       */
		/*   Param : @Param1     , Param2                                                                                                       */
		/*   Param : INSTANCE_ID , PLAN_DATE                                                                                                    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00621_findFpPlan_info' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' WITH RELEASE_PLAN AS ( ' + char(10)
                SELECT @v_dSql += '      SELECT DISTINCT      ' + char(10)
                SELECT @v_dSql += '             A.INSTANCE_ID ' + char(10)
                SELECT @v_dSql += '            ,A.RELEASE_PLAN_ID AS PLAN_ID      ' + char(10)
                SELECT @v_dSql += '            ,STUFF(( SELECT '','' + FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                     FROM   FP_RELEASE_PLAN_INFO_H B ' + char(10)
                SELECT @v_dSql += '                     WHERE  A.INSTANCE_ID     = B.INSTANCE_ID     ' + char(10)
                SELECT @v_dSql += '                     AND    A.INSTANCE_DATE   = B.INSTANCE_DATE   ' + char(10)
                SELECT @v_dSql += '                     AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID ' + char(10)
                SELECT @v_dSql += '                     FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT ' + char(10)
                SELECT @v_dSql += '            ,A.PLAN_GROUP_ID              ' + char(10)
                SELECT @v_dSql += '            ,A.INSTANCE_DATE AS PLAN_DATE ' + char(10)
                SELECT @v_dSql += '      FROM   FP_RELEASE_PLAN_INFO_H A     ' + char(10)
                SELECT @v_dSql += '      WHERE  1=1                          ' + char(10)

				IF(LEN(@param1) > 0)
				    BEGIN
                        SELECT @v_dSql += '      AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
				    END
				IF(LEN(@param2) > 0)
				    BEGIN
                        SELECT @v_dSql += '      AND    A.INSTANCE_DATE = '''+ @param2 +''' ' + char(10)
				    END

                SELECT @v_dSql += ' ) ' + char(10)
                SELECT @v_dSql += ' SELECT A.PLAN_ID AS CODE, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS NAME ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_ID            ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_TYPE          ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_START_TIME    ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_HORIZON       ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_HORIZON_UOM   ' + char(10)
                SELECT @v_dSql += '     ,A.DEMAND_HORIZON     ' + char(10)
                SELECT @v_dSql += '     ,A.DEMAND_HORIZON_UOM ' + char(10)
                SELECT @v_dSql += '     ,A.CONFIG_SET_ID      ' + char(10)
                SELECT @v_dSql += '     ,A.BASIS_PLAN_ID      ' + char(10)
                SELECT @v_dSql += '     ,A.DEMAND_PLAN_ID     ' + char(10)
                SELECT @v_dSql += '     ,A.SCP_PLAN_ID        ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_WEEK          ' + char(10)
                SELECT @v_dSql += '     --,CONVERT(VARCHAR(8), DATEADD(DAY,-28, A.PLAN_START_TIME), 112) AS PLAN_START_DATE ' + char(10)
                SELECT @v_dSql += '     --,CONVERT(VARCHAR(8), DATEADD(DAY, 55, A.PLAN_START_TIME), 112) AS PLAN_END_DATE   ' + char(10)
                SELECT @v_dSql += '     ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS PLAN_START_DATE ' + char(10)
                SELECT @v_dSql += '     ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS PLAN_END_DATE ' + char(10)
                SELECT @v_dSql += '     ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS DEFAULT_START_DATE ' + char(10)
                SELECT @v_dSql += '     ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS DEFAULT_END_DATE ' + char(10)
                SELECT @v_dSql += '     ,A.INSTANCE_ID ' + char(10)
                SELECT @v_dSql += '     ,A.SITE_ID     ' + char(10)
                SELECT @v_dSql += '     ,A.DESCRIPTION ' + char(10)
                SELECT @v_dSql += '     ,A.PLAN_TYPE   ' + char(10)
                SELECT @v_dSql += '     ,CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID ' + char(10)
                SELECT @v_dSql += '     ,CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME ' + char(10)
                SELECT @v_dSql += '     ,CASE WHEN A.RELEASE_FLAG = ''Y''                    ' + char(10)
                SELECT @v_dSql += '     	  THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID ) ' + char(10) 
                SELECT @v_dSql += '     	  ELSE A.DESCRIPTION END AS DESCS          ' + char(10)
                SELECT @v_dSql += '     ,SUBSTRING(A.BASIS_PLAN_ID,CHARINDEX(''-'',A.BASIS_PLAN_ID)+1,11) AS BASIC_VERSION ' + char(10)
                SELECT @v_dSql += '     ,C.FACTORY_LT                                  ' + char(10)
                SELECT @v_dSql += '     ,(CASE WHEN PLAN_TYPE = ''RELEASE'' THEN ''N'' ' + char(10)
                SELECT @v_dSql += '            WHEN RIGHT(A.PLAN_ID,2) = ''00'' THEN ''Y'' ELSE ''N'' END) AS READ_ONLY ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_FP_PLAN_H A WITH(NOLOCK)         ' + char(10)
                SELECT @v_dSql += ' LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '   ON  A.INSTANCE_ID = C.INSTANCE_ID         ' + char(10)
                SELECT @v_dSql += ' AND A.PLAN_ID = C.PLAN_ID ' + char(10)
                SELECT @v_dSql += ' WHERE  1=1                ' + char(10)
				IF(LEN(@param1) > 0)
				    BEGIN
                        SELECT @v_dSql += '   AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
				    END
				IF(LEN(@param2) > 0)
				    BEGIN
                        SELECT @v_dSql += '   AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = '''+ @param2 +''' ' + char(10)
				    END

                SELECT @v_dSql += ' ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC ' + char(10)

				--SELECT @v_dSql
				EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'select',@runstart, @runend
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   FP00621화면에서 find_NickName_List 정보갖고오기                                                                                     */
		/*   Param : @Param1   , Param2  , Param3 ,   Param4 ,      Param5 ,   Param6 ,  Param7 , Param8 , Param9 , Param10 , Param11 , Param12   */
		/*   Param : INSTANCE  , PLAN_ID , PLAN_DATE, BUCKET_FROM,  BUCKET_TO, DIVISION, SITE,    PLANT,   FACTORY,  LINE  ,  OPERATION, AMEND_TABLE  */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00621_find_NickName_List' 
		    BEGIN	
			    SELECT @v_dSql = ''

			    SELECT @v_dSql += ' SELECT DISTINCT ISNULL(B.NICK_NAME,''-'') AS CODE, ISNULL(B.NICK_NAME,''-'') AS NAME ' + char(10)
			    SELECT @v_dSql += ' FROM (     ' + char(10)
			    SELECT @v_dSql += '       -- P ' + char(10)
			    SELECT @v_dSql += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
			    SELECT @v_dSql += '       FROM   '+ TRY_CONVERT(NVARCHAR, @param12) +' A WITH(NOLOCK)  ' + char(10)
			    SELECT @v_dSql += '       WHERE  A.INSTANCE_ID  = '''+ @param1 +'''                    ' + char(10)
			    SELECT @v_dSql += '       AND    A.FP_PLAN_ID   = '''+ @param2 +'''                    ' + char(10)
				SELECT @v_dSql += '       AND    CONVERT(VARCHAR,A.PLAN_DATE,112) >= '''+ @param3 +''' ' + char(10)
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param6)) + char(10)

				IF(LEN(@param7) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param7 +''' ' + char(10)
				    END					    
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param8))   + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param9)) + char(10)

				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param10)) + char(10)
				IF(LEN(@param11) > 0)	    
				    BEGIN				    
                        SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param11 +''' ' + char(10)
				    END	

			    SELECT @v_dSql += '     -- S      ' + char(10)
			    SELECT @v_dSql += '     UNION ALL ' + char(10)
			    SELECT @v_dSql += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
			    SELECT @v_dSql += '     FROM   '+ TRY_CONVERT(NVARCHAR, @param12) +' A WITH(NOLOCK)  ' + char(10)
			    SELECT @v_dSql += '     WHERE  A.INSTANCE_ID  = '''+ @param1 +'''                    ' + char(10)
			    SELECT @v_dSql += '     AND    A.FP_PLAN_ID   = '''+ @param2 +'''                    ' + char(10)
				SELECT @v_dSql += '     AND    CONVERT(VARCHAR,A.PLAN_DATE,112) >= '''+ @param3 +''' ' + char(10)
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param6)) + char(10)

				IF(LEN(@param7) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param7 +''' ' + char(10)
				    END					    
	            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param8)) + char(10)

                SELECT @v_dSql += '     AND    A.FACTORY_ID = ''-''                ' + char(10)
				SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param11 +''' ' + char(10)

			    SELECT @v_dSql += '     UNION ALL                                  ' + char(10)
			    SELECT @v_dSql += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
			    SELECT @v_dSql += '     FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)           ' + char(10)
			    SELECT @v_dSql += '     WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) < '''+ @param3 +''' ' + char(10)
			    SELECT @v_dSql += '     AND    A.PLAN_TYPE = ''RELEASE''                            ' + char(10)

	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param6)) + char(10)

				IF(LEN(@param7) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param7 +''' ' + char(10)
				    END		
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param8)) + char(10)
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param9)) + char(10)
                SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param10 +''' ' + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param10)) + char(10)

			    SELECT @v_dSql += '     UNION ALL ' + char(10)
			    SELECT @v_dSql += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
			    SELECT @v_dSql += '     FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += '     WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @param4 +''' AND '''+ @param5 +''' ' + char(10)

	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param6)) + char(10)

				IF(LEN(@param7) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param7 +''' ' + char(10)
				    END	
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param8)) + char(10)
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param9)) + char(10)
                SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param11 +''' ' + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param10)) + char(10)
			    SELECT @v_dSql += ' ) A                                    ' + char(10)
			    SELECT @v_dSql += ' INNER JOIN SCM_ITEM_M B WITH(NOLOCK)   ' + char(10)
			    SELECT @v_dSql += ' ON    A.COMPANY_ID     = B.COMPANY_ID  ' + char(10)
			    SELECT @v_dSql += ' AND   A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += ' AND   A.SITE_ID        = B.SITE_ID     ' + char(10)
			    SELECT @v_dSql += ' AND   A.ITEM_ID        = B.ITEM_ID     ' + char(10)
			    SELECT @v_dSql += ' ORDER BY ISNULL(B.NICK_NAME,''-'')     ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   FP00621화면에서 find_ListData 정보갖고오기                                                                                         */
		/*   Param : @Param1  ,    @Param2,  @Param3,      @Param4     @Param5                        */
		/*   Param : INSTANCE_ID , PLAN_ID,  OPERATION_ID, PLAN_TYPE,  AMEND_TABLE                                                              */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00621_find_ListData' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                      ' + char(10)
                SELECT @v_dSql += '     , A.COMPANY_ID, A.DIVISION_ID, A.CATEGORY_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
                SELECT @v_dSql += '     , A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION ' + char(10)
                SELECT @v_dSql += '     , A.PRODUCTION_TYPE, A.MARKET                         ' + char(10)
                SELECT @v_dSql += '     , A.LINE_ID, A.ELECTRODE_TYPE                         ' + char(10)
                SELECT @v_dSql += '     , A.CUSTOMER_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE ' + char(10)
                SELECT @v_dSql += '     , A.TOP_ITEM_ID                                       ' + char(10)
                SELECT @v_dSql += '     , A.CELL_GROUP_CODE                                   ' + char(10)
                SELECT @v_dSql += '     , A.IN_QTY, A.OUT_QTY                                 ' + char(10)
                SELECT @v_dSql += '     , A.SHIPPING_QTY, A.NET_QTY, A.CARRYOVER_QTY          ' + char(10)
                SELECT @v_dSql += '     , A.MPP_IN_QTY, A.MPP_OUT_QTY                         ' + char(10)                
				SELECT @v_dSql += '     , A.WPP_IN_QTY, A.WPP_OUT_QTY                         ' + char(10)
                SELECT @v_dSql += ' FROM  '+ TRY_CONVERT(NVARCHAR, @param5) +' A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE  1=(CASE WHEN '''+ @param3 +''' = ''RELEASE'' THEN 1 ELSE 0 END) ' + char(10)
                SELECT @v_dSql += ' AND   A.INSTANCE_ID  = '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += ' AND   A.FP_PLAN_ID   = '''+ @param2 +''' ' + char(10)
                SELECT @v_dSql += ' AND   A.CATEGORY_ID  = ''PLAN''          ' + char(10)
                SELECT @v_dSql += ' AND   A.OPERATION_ID = '''+ @param3 +''' ' + char(10)
                SELECT @v_dSql += ' AND   A.FACTORY_ID <> ''-''              ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
                SELECT @v_dSql += '    , A.ITEM_ID, A.MARKET, A.PRODUCTION_TYPE, A.PLAN_DATE ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END	
		/****************************************************************************************************************************************/
		/*   FP00621화면에서 find_ListData_BOH 정보갖고오기                                                                                     */
		/*   Param : @Param1  ,    @Param2 ,   @Param3    ,   @Param3                                                                           */
		/*   Param : INSTANCE_ID , PLAN_ID ,   PLAN_DATE,     AMEND_CUTOFF_BOH_TABLE                                                            */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00621_find_ListData_BOH' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.FP_PLAN_ID                        ' + char(10)
                SELECT @v_dSql += '     , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID              ' + char(10)
                SELECT @v_dSql += '     , A.PLANT_ID, A.ITEM_ID, A.TOP_ITEM_ID                ' + char(10)
                SELECT @v_dSql += '     , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION            ' + char(10)
      SELECT @v_dSql += '     , ISNULL(ISNULL(A.MODIFY_QTY, A.QTY), 0) AS QTY       ' + char(10)
                SELECT @v_dSql += '     , '''+ @param3 +''' AS PLAN_DATE                      ' + char(10)
                SELECT @v_dSql += ' FROM  '+ TRY_CONVERT(NVARCHAR, @param4) +' A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE  1 = 0                                              ' + char(10)
                SELECT @v_dSql += ' AND    A.INSTANCE_ID  = '''+ @param1 +'''                 ' + char(10)
                SELECT @v_dSql += ' AND    A.FP_PLAN_ID   = '''+ @param2 +'''                 ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LOCATION ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END	
        /****************************************************************************************************************************************/
        /*   FP00619화면에서 findLineCode_List 정보갖고오기                                                                                     */
        /*            @Param1     @Param2,  @Param3,    @Param4,       @Param5,     @Param6,  @Param7,   @Param8,    @Param9,       ,@Param10,  @Param11, @Param12  */
        /*   Param : INSTANCE_ID, PLAN_ID,  PLAN_TYPE,  CONFIRM_AREA,  DIVISION_ID, SITE_ID,  PLANT_ID,  FACTORY_ID, OPERATION_ID,   IN_ACT,    ALL_LINE,   USER_LT   */
        /****************************************************************************************************************************************/
        ELSE IF @p_code = 'FP00619_findLineCode_List' 
            BEGIN	
                SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.LINE_ID AS CODE         ' + char(10)
                SELECT @v_dSql += '      , ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_LINE_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE 1=1                        ' + char(10)
	    
                IF (@param10 != 'Y') --IN_ACT
                    BEGIN
                        SELECT @v_dSql += ' AND	A.ACTIVE_FLAG = ''Y'' ' + char(10)
                    END
	    
                SELECT @v_dSql += ' AND  EXISTS (                                      ' + char(10)
                SELECT @v_dSql += '          SELECT 1                                  ' + char(10)
                SELECT @v_dSql += '          FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '          WHERE  A.COMPANY_ID   = B.COMPANY_ID      ' + char(10)
                SELECT @v_dSql += '          AND    A.DIVISION_ID  = B.DIVISION_ID     ' + char(10)
                SELECT @v_dSql += '          AND    A.SITE_ID      = B.SITE_ID         ' + char(10)
                SELECT @v_dSql += '          AND    A.PLANT_ID     = B.PLANT_ID        ' + char(10)
                SELECT @v_dSql += '          AND    A.FACTORY_ID   = B.FACTORY_ID      ' + char(10)
                SELECT @v_dSql += '          AND    A.OPERATION_ID = B.OPERATION_ID    ' + char(10)
	    	    
                IF (@param10 != 'Y') --IN_ACT
                    BEGIN
SELECT @v_dSql += '          AND    A.LINE_ID    = B.LINE_ID   ' + char(10)
                    END                                                  
                  
                SELECT @v_dSql += '          AND    B.USER_ID     = '''+ @p_user_id +'''              ' + char(10)
                SELECT @v_dSql += '         )                                                         ' + char(10)
                SELECT @v_dSql += ' AND   EXISTS (                                                    ' + char(10)
                SELECT @v_dSql += '     SELECT 1 FROM (                                               ' + char(10)
                SELECT @v_dSql += '                   SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                   FROM  SCM_FACTORY_M A WITH(NOLOCK)              ' + char(10)
                SELECT @v_dSql += '                   INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                   ON    A.FACTORY_ID=B.FACTORY_ID                 ' + char(10)
                SELECT @v_dSql += '                   AND   B.ACTIVE_FLAG = ''Y''                     ' + char(10)
                SELECT @v_dSql += '                   WHERE 1=1                                       ' + char(10)
                SELECT @v_dSql += '                   AND   B.INSTANCE_ID = '''+ @param1 +'''         ' + char(10)
				SELECT @v_dSql += '                   AND   A.ACTIVE_FLAG = ''Y''                     ' + char(10)
                SELECT @v_dSql += '     ) C                                                           ' + char(10)
                SELECT @v_dSql += '     WHERE C.COMPANY_ID = A.COMPANY_ID AND C.DIVISION_ID = A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += ' )                                                                 ' + char(10)

                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param8))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param9))    + char(10)

                IF(@param1 !='') --INSTANCE_ID
                    BEGIN
                        SELECT @v_dSql += ' AND EXISTS ( SELECT  1                                            ' + char(10)
                        SELECT @v_dSql += '              FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)        ' + char(10)
                        SELECT @v_dSql += '              WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''       ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = '''+ @param1 +'''     ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ACTIVE_FLAG      = ''Y''                 ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ATTRIBUTE1       = ''BUILDING''          ' + char(10)
                        SELECT @v_dSql += '              UNION ALL                                            ' + char(10)
                        SELECT @v_dSql += '              SELECT  1                                            ' + char(10)
                        SELECT @v_dSql += '              FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),       ' + char(10)
                        SELECT @v_dSql += '                      SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)        ' + char(10)
                        SELECT @v_dSql += '              WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''       ' + char(10)
                        SELECT @v_dSql += '              AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = LV2.SEGMENT1          ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = '''+ @param1 +'''     ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ACTIVE_FLAG      = ''Y''                 ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''        ' + char(10)
                        SELECT @v_dSql += '              AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) )  ' + char(10)
                    END
                  
                IF(@param11 != 'Y') --ALL_LINE
                    BEGIN
                        SELECT @v_dSql += ' AND A.LINE_ID IN ( ' + char(10)
                        SELECT @v_dSql += '     SELECT DISTINCT LINE_ID ' + char(10)
                        SELECT @v_dSql += '     FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK) ' + char(10)
                        SELECT @v_dSql += '     WHERE  AA.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('     AND    AA.USER_ID' , 'EQ', @param12)) + char(10)
                        SELECT @v_dSql += ' ) ' + char(10)
                    END
	    
                IF( @param3 = 'RELEASE' AND @param4 = 'PLAN GROUP')
                    BEGIN
                        SELECT @v_dSql += ' AND A.MODEL_TYPE IN (           ' + char(10)
                        SELECT @v_dSql += '        SELECT KK.PLAN_GROUP_ID  ' + char(10)
                        SELECT @v_dSql += '        FROM   FP_RELEASE_PLAN_INFO_H KK WITH(NOLOCK)  ' + char(10)
                        SELECT @v_dSql += '        WHERE  KK.INSTANCE_ID = '''+ @param1 +'''      ' + char(10)
                        SELECT @v_dSql += '        AND    KK.RELEASE_PLAN_ID = '''+ @param2 +'''  ' + char(10)
                        SELECT @v_dSql += ' )  ' + char(10)
                    END
            
                 SELECT @v_dSql += ' GROUP BY A.LINE_ID, A.LINE_NAME ' + char(10)
                 SELECT @v_dSql += ' ORDER BY A.LINE_ID ' + char(10)
            
              --SELECT @v_dSql
              exec sp_executesql @v_dSql
        
           END
        /****************************************************************************************************************************************/
        /*   FP00619화면에서 find_Model_List 정보갖고오기                                                                                     */
        /*            @param1     @Param2,    @Param3,    @Param4,   @Param5,   @Param6,    @Param7,   @Param8         */
        /*   Param : BUCKET_FROM, BUCKET_TO,  DIVISION_ID, SITE_ID,  PLANT_ID,  FACTORY_ID, LINE,      OPERATION_ID    */
        /****************************************************************************************************************************************/
        ELSE IF @p_code = 'FP00619_find_Model_List' 
            BEGIN	
                SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.TOP_ITEM_ID AS CODE, A.TOP_ITEM_ID AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM (                                                       ' + char(10)
                SELECT @v_dSql += '       SELECT A.TOP_ITEM_ID                                   ' + char(10)
                SELECT @v_dSql += '       FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)      ' + char(10)
                SELECT @v_dSql += '       WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @param1 +''' AND '''+ @param2 +''' ' + char(10)
                SELECT @v_dSql += '       AND    A.PLAN_TYPE IN (''RELEASE'',''MPP'',''WPP'')    ' + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param3))        + char(10)
				IF(LEN(@param4) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param4))    + char(10)
				    END
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.PLANT_ID' , 'EQ', @param5))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.FACTORY_ID' , 'EQ', @param6))  + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.LINE_ID' , 'EQ', @param7))     + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.OPERATION_ID' , 'EQ', @param8))+ char(10)

                SELECT @v_dSql += '       UNION ALL ' + char(10)
                SELECT @v_dSql += '       SELECT A.TOP_ITEM_ID ' + char(10)
                SELECT @v_dSql += '       FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '       WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @param1 +''' AND '''+ @param2 +''' ' + char(10)

                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param3))        + char(10)
				IF(LEN(@param4) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param4))    + char(10)
				    END
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.PLANT_ID' , 'EQ', @param5))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.FACTORY_ID' , 'EQ', @param6))  + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.LINE_ID' , 'EQ', @param7))     + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.OPERATION_ID' , 'EQ', @param8))+ char(10)
                SELECT @v_dSql += ' ) A                    ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.TOP_ITEM_ID ' + char(10)

			EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
              --SELECT @v_dSql
              exec sp_executesql @v_dSql
        
           END
        /****************************************************************************************************************************************/
        /*   FP00619화면에서 find_NickName_List 정보갖고오기                                                                                     */
        /*            @param1     @Param2,    @Param3,    @Param4,   @Param5,   @Param6,    @Param7,   @Param8         */
        /*   Param : BUCKET_FROM, BUCKET_TO,  DIVISION_ID, SITE_ID,  PLANT_ID,  FACTORY_ID, LINE,      OPERATION_ID    */
        /****************************************************************************************************************************************/
        ELSE IF @p_code = 'FP00619_find_NickName_List' 
            BEGIN	
                SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT ISNULL(B.NICK_NAME,''-'') AS CODE, ISNULL(B.NICK_NAME,''-'') AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM (                                                                               ' + char(10)
                SELECT @v_dSql += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
                SELECT @v_dSql += '       FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)  ' + char(10)
                SELECT @v_dSql += '       WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN  '''+ @param1 +''' AND '''+ @param2 +''' ' + char(10)
                SELECT @v_dSql += '       AND    A.PLAN_TYPE IN (''RELEASE'',''MPP'',''WPP'') ' + char(10)

                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param3))        + char(10)
				IF(LEN(@param4) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param4))    + char(10)
				    END
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.PLANT_ID' , 'EQ', @param5))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.FACTORY_ID' , 'EQ', @param6))  + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.LINE_ID' , 'EQ', @param7))     + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.OPERATION_ID' , 'EQ', @param8))+ char(10)

                SELECT @v_dSql += ' UNION ALL                                        ' + char(10)
    SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN  '''+ @param1 +''' AND '''+ @param2 +''' ' + char(10)

                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param3))        + char(10)
				IF(LEN(@param4) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param4))    + char(10)
				    END
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.PLANT_ID' , 'EQ', @param5))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.FACTORY_ID' , 'EQ', @param6))  + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.LINE_ID' , 'EQ', @param7))     + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.OPERATION_ID' , 'EQ', @param8))+ char(10)

                SELECT @v_dSql += ' )  A                                    ' + char(10)
                SELECT @v_dSql += ' INNER JOIN SCM_ITEM_M B WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += ' ON     A.COMPANY_ID     = B.COMPANY_ID  ' + char(10)
                SELECT @v_dSql += ' AND    A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
                SELECT @v_dSql += ' AND    A.SITE_ID        = B.SITE_ID     ' + char(10)
                SELECT @v_dSql += ' AND    A.ITEM_ID        = B.ITEM_ID     ' + char(10)
                SELECT @v_dSql += ' ORDER BY ISNULL(B.NICK_NAME,''-'')      ' + char(10)

              EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
              exec sp_executesql @v_dSql
        
           END
        /****************************************************************************************************************************************/
        /*   FP00617화면에서 find_FPNickName 정보갖고오기                                                                                      */
        /*            @param1     @Param2,    @Param3,    @Param4,   @Param5,   @Param6,    @Param7,   @Param8      ,  @Param9   ,  @Param9    */
        /*   Param : BUCKET_FROM, BUCKET_TO,  DIVISION_ID, SITE_ID,  PLANT_ID,  FACTORY_ID, LINE,      OPERATION_ID , PROD_TYPE  , ITEM        */
        /****************************************************************************************************************************************/
        ELSE IF @p_code = 'FP00617_find_FPNickName' 
            BEGIN	
                SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT ISNULL(B.NICK_NAME,''-'') AS CODE, ISNULL(B.NICK_NAME,''-'') AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM (                                                                               ' + char(10)
                SELECT @v_dSql += '      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
                SELECT @v_dSql += '      FROM FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                           ' + char(10)
                SELECT @v_dSql += '      WHERE  1=1                                                                                ' + char(10)
                SELECT @v_dSql += '      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param1 +''' AND '''+ @param2 +''' ' + char(10)
                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param3))        + char(10)

				IF(LEN(@param4) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param4))    + char(10)
				    END
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.PLANT_ID' , 'EQ', @param5))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.FACTORY_ID' , 'EQ', @param6))  + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.LINE_ID' , 'EQ', @param7))     + char(10)
				
				IF(LEN(@param8) > 0)
				    BEGIN
				        SELECT @v_dSql += '      AND    A.OPERATION_ID = '''+ @param8 +''' ' + char(10)
				    END

                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.FP_PRODUCTION_TYPE' , 'EQ', @param9))     + char(10)
				
				IF(LEN(@param10) > 0)
				    BEGIN
				        SELECT @v_dSql += '      AND    A.ITEM_ID LIKE ''%'' + '''+ @param10 +'''+ ''%'' ' + char(10)
				    END

                SELECT @v_dSql += '      UNION ALL                                                                                        ' + char(10)
                SELECT @v_dSql += '      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
                SELECT @v_dSql += '      FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)                                            ' + char(10)
                SELECT @v_dSql += '      WHERE  1=1                                                                                ' + char(10)
                SELECT @v_dSql += '      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param1 +''' AND '''+ @param2 +''' ' + char(10)
                
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('      A.DIVISION_ID' , 'EQ', @param3))        + char(10)

				IF(LEN(@param4) > 0)
				    BEGIN
				        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param4))    + char(10)
				    END
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.PLANT_ID' , 'EQ', @param5))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.FACTORY_ID' , 'EQ', @param6))  + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.LINE_ID' , 'EQ', @param7))     + char(10)
				
				IF(LEN(@param8) > 0)
				    BEGIN
				        SELECT @v_dSql += '      AND    A.OPERATION_ID = '''+ @param8 +''' ' + char(10)
				    END

                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('       A.FP_PRODUCTION_TYPE' , 'EQ', @param9))     + char(10)
				
				IF(LEN(@param10) > 0)
				    BEGIN
				        SELECT @v_dSql += '      AND    A.ITEM_ID LIKE ''%'' + '''+ @param10 +'''+ ''%'' ' + char(10)
				    END

                SELECT @v_dSql += ' ) A                                     ' + char(10)
                SELECT @v_dSql += ' INNER JOIN SCM_ITEM_M B WITH(NOLOCK)    ' + char(10)
                SELECT @v_dSql += ' ON     A.COMPANY_ID     = B.COMPANY_ID  ' + char(10)
                SELECT @v_dSql += ' AND    A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
                SELECT @v_dSql += ' AND    A.SITE_ID        = B.SITE_ID     ' + char(10)
                SELECT @v_dSql += ' AND    A.ITEM_ID        = B.ITEM_ID     ' + char(10)
                SELECT @v_dSql += ' ORDER BY ISNULL(B.NICK_NAME,''-'')      ' + char(10)

              EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
              exec sp_executesql @v_dSql
        
      END
        /****************************************************************************************************************************************/
        /*   FP00617/FP00618화면에서 findLineCode_List 정보갖고오기                                                                                     */
        /*            @Param1     @Param2,      @Param3,    @Param4,   @Param5,    @Param6,        @Param7,   @Param8,    @Param9   */
        /*   Param : INSTANCE_ID,  DIVISION_ID, SITE_ID,    PLANT_ID,  FACTORY_ID, OPERATION_ID,   IN_ACT,    ALL_LINE,   USER_LT   */
        /****************************************************************************************************************************************/
        ELSE IF @p_code = 'FP00617_findLineCode_List' 
            BEGIN	
                SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.LINE_ID AS CODE         ' + char(10)
                SELECT @v_dSql += '      , ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_LINE_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE 1=1                        ' + char(10)
	    
                IF (@param7 != 'Y') --IN_ACT
                    BEGIN
                        SELECT @v_dSql += ' AND	A.ACTIVE_FLAG = ''Y'' ' + char(10)
                    END
	    
                SELECT @v_dSql += ' AND  EXISTS (                                      ' + char(10)
                SELECT @v_dSql += '          SELECT 1                                  ' + char(10)
                SELECT @v_dSql += '          FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '          WHERE  A.COMPANY_ID   = B.COMPANY_ID      ' + char(10)
                SELECT @v_dSql += '          AND    A.DIVISION_ID  = B.DIVISION_ID     ' + char(10)
                SELECT @v_dSql += '          AND    A.SITE_ID      = B.SITE_ID         ' + char(10)
                SELECT @v_dSql += '          AND    A.PLANT_ID     = B.PLANT_ID        ' + char(10)
                SELECT @v_dSql += '          AND    A.FACTORY_ID   = B.FACTORY_ID      ' + char(10)
                SELECT @v_dSql += '          AND    A.OPERATION_ID = B.OPERATION_ID    ' + char(10)
	    	    
                IF (@param7 != 'Y') --IN_ACT
                    BEGIN
                        SELECT @v_dSql += '          AND    A.LINE_ID    = B.LINE_ID   ' + char(10)
                    END                                                  
                  
                SELECT @v_dSql += '          AND    B.USER_ID     = '''+ @p_user_id +'''              ' + char(10)
                SELECT @v_dSql += '         )                                                         ' + char(10)
                SELECT @v_dSql += ' AND   EXISTS (                                                    ' + char(10)
                SELECT @v_dSql += '     SELECT 1 FROM (                                               ' + char(10)
                SELECT @v_dSql += '                   SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                   FROM  SCM_FACTORY_M A WITH(NOLOCK)              ' + char(10)
                SELECT @v_dSql += '                   INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                   ON    A.FACTORY_ID=B.FACTORY_ID                 ' + char(10)
                SELECT @v_dSql += '                   AND   B.ACTIVE_FLAG = ''Y''                     ' + char(10)
                SELECT @v_dSql += '                   WHERE 1=1                                       ' + char(10)
                SELECT @v_dSql += '                   AND   B.INSTANCE_ID = '''+ @param1 +'''         ' + char(10)
				SELECT @v_dSql += '    AND   A.ACTIVE_FLAG = ''Y''                     ' + char(10)
                SELECT @v_dSql += '     ) C                                                           ' + char(10)
                SELECT @v_dSql += '     WHERE C.COMPANY_ID = A.COMPANY_ID AND C.DIVISION_ID = A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += ' )                                                                 ' + char(10)

                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param2))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param3))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param4))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param5))    + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param6))    + char(10)

                IF(@param1 !='') --INSTANCE_ID
                    BEGIN
                        SELECT @v_dSql += ' AND EXISTS ( SELECT  1                                            ' + char(10)
                        SELECT @v_dSql += '              FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)        ' + char(10)
                        SELECT @v_dSql += '              WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''       ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = '''+ @param1 +'''     ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ACTIVE_FLAG      = ''Y''                 ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ATTRIBUTE1       = ''BUILDING''          ' + char(10)
                        SELECT @v_dSql += '              UNION ALL                                            ' + char(10)
                        SELECT @v_dSql += '              SELECT  1                                            ' + char(10)
                        SELECT @v_dSql += '              FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),       ' + char(10)
                        SELECT @v_dSql += '                      SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)        ' + char(10)
                        SELECT @v_dSql += '              WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''       ' + char(10)
                        SELECT @v_dSql += '              AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = LV2.SEGMENT1          ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.SEGMENT1         = '''+ @param1 +'''     ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ACTIVE_FLAG      = ''Y''                 ' + char(10)
                        SELECT @v_dSql += '              AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''        ' + char(10)
                        SELECT @v_dSql += '              AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) )  ' + char(10)
                    END
                  
                IF(@param8 != 'Y') --ALL_LINE
                    BEGIN
                        SELECT @v_dSql += ' AND A.LINE_ID IN ( ' + char(10)
                        SELECT @v_dSql += '     SELECT DISTINCT LINE_ID ' + char(10)
                        SELECT @v_dSql += '     FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK) ' + char(10)
                        SELECT @v_dSql += '     WHERE  AA.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                        SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('     AND    AA.USER_ID' , 'EQ', @param9)) + char(10)
                        SELECT @v_dSql += ' ) ' + char(10)
                    END

                 SELECT @v_dSql += ' GROUP BY A.LINE_ID, A.LINE_NAME ' + char(10)
                 SELECT @v_dSql += ' ORDER BY A.LINE_ID ' + char(10)
            
			  EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend			 
              --SELECT @v_dSql
              exec sp_executesql @v_dSql
        
           END
		/****************************************************************************************************************************************/
		/*   FP00596화면에서 find_ListData 정보갖고오기                                                                                         */
		/*   Param : @Param1   , Param2  , Param3                                                                                               */
		/*   Param : INSTANCE  , PLAN_ID , AMEND_TABLE                                                                                          */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00596_find_ListData' 
		    BEGIN	
			    SELECT @v_dSql = ''
			    SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.FP_PLAN_ID                                             ' + char(10)
			    SELECT @v_dSql += '      , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID        ' + char(10)
			    SELECT @v_dSql += '      , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
			    SELECT @v_dSql += '      , A.TOP_ITEM_ID, A.ITEM_ID                                                ' + char(10)
			    SELECT @v_dSql += '      , A.PRODUCTION_TYPE, A.MARKET                                             ' + char(10)
			    SELECT @v_dSql += '      , A.SEQ                                                                   ' + char(10)
			    SELECT @v_dSql += '      , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE                         ' + char(10)
			    SELECT @v_dSql += '      , A.PLAN_IN_QTY_BATCH, A.PLAN_IN_QTY, A.PLAN_IN_QTY_M, A.PLAN_IN_QTY_CELL, A.PLAN_IN_QTY_KG      ' + char(10)
			    SELECT @v_dSql += '      , A.PLAN_OUT_QTY_BATCH, A.PLAN_OUT_QTY, A.PLAN_OUT_QTY_M, A.PLAN_OUT_QTY_CELL, A.PLAN_OUT_QTY_KG ' + char(10)
			    SELECT @v_dSql += '      , ROUND(A.ADJUST_IN_QTY_BATCH,2) AS ADJUST_IN_QTY_BATCH           ' + char(10)
			    SELECT @v_dSql += '      , CEILING(A.ADJUST_IN_QTY) AS ADJUST_IN_QTY                       ' + char(10)
			    SELECT @v_dSql += '      , CEILING(A.ADJUST_IN_QTY_M) AS ADJUST_IN_QTY_M                   ' + char(10)
			    SELECT @v_dSql += '      , CEILING(A.ADJUST_IN_QTY_CELL) AS ADJUST_IN_QTY_CELL             ' + char(10)
			    SELECT @v_dSql += '      , CEILING(A.ADJUST_IN_QTY_JR) AS ADJUST_IN_QTY_JR                 ' + char(10)
			    SELECT @v_dSql += '      , CEILING(A.ADJUST_IN_QTY_KG) AS ADJUST_IN_QTY_KG                 ' + char(10)
			    SELECT @v_dSql += '      , ROUND(A.ADJUST_OUT_QTY_BATCH,2) AS ADJUST_OUT_QTY_BATCH         ' + char(10)
			    SELECT @v_dSql += '      , CEILING(A.ADJUST_OUT_QTY) AS ADJUST_OUT_QTY                     ' + char(10)
			    SELECT @v_dSql += '      , CEILING(A.ADJUST_OUT_QTY_M) AS ADJUST_OUT_QTY_M                 ' + char(10)
			    SELECT @v_dSql += '      , CEILING(A.ADJUST_OUT_QTY_CELL) AS ADJUST_OUT_QTY_CELL           ' + char(10)
			    SELECT @v_dSql += '      , CEILING(A.ADJUST_OUT_QTY_JR) AS ADJUST_OUT_QTY_JR               ' + char(10)
			    SELECT @v_dSql += '      , CEILING(A.ADJUST_OUT_QTY_KG) AS ADJUST_OUT_QTY_KG               ' + char(10)
			    SELECT @v_dSql += ' FROM   '+ TRY_CONVERT(NVARCHAR,@param3) +' A WITH(NOLOCK)              ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                               ' + char(10)
			    SELECT @v_dSql += ' AND    A.FP_PLAN_ID  = '''+ @param2 +'''                               ' + char(10)
			    SELECT @v_dSql += ' ORDER BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID        ' + char(10)
			    SELECT @v_dSql += '        , LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID ' + char(10)
			    SELECT @v_dSql += '        , TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET                 ' + char(10)
			    SELECT @v_dSql += '        , PLAN_DATE                                                     ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   FP00596화면에서 find_UOMInfo 정보갖고오기                                                                          */
		/*   Param : @param1   , param2  , param3,  param4                                                                                     */
		/*   Param : DIVISION  , SITE ,    PLANT,   FACTORY                                                                                     */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00596_find_UOMInfo' 
		    BEGIN	
			    SELECT @v_dSql = ''
			    SELECT @v_dSql += ' SELECT DISTINCT A.COMPANY_ID                    ' + char(10)
			    SELECT @v_dSql += '     , A.DIVISION_ID                             ' + char(10)
			    SELECT @v_dSql += '     , A.SITE_ID                                 ' + char(10)
			    SELECT @v_dSql += '     , A.PLANT_ID                                ' + char(10)
			    SELECT @v_dSql += '     , A.FACTORY_ID                              ' + char(10)
			    SELECT @v_dSql += '     , A.OPERATION_ID                            ' + char(10)
			    SELECT @v_dSql += '     , A.ITEM_ID                                 ' + char(10)
			    SELECT @v_dSql += '     , A.BATCH_LOT_SIZE AS VALUE                 ' + char(10)
			    SELECT @v_dSql += '     , A.LOT_SIZE_UOM AS CATEGORY                ' + char(10)
			    SELECT @v_dSql += ' FROM SCM_ITEM_EQUIP_RATE_BATCH_M A WITH(NOLOCK) ' + char(10)
			    SELECT @v_dSql += ' WHERE 1=1                                       ' + char(10)
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param1)) + char(10)

				IF(LEN(@param2) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param2 +''' ' + char(10)
				    END		
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param3)) + char(10)
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param4)) + char(10)
      
			    SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			    SELECT @v_dSql += '      , A.OPERATION_ID, A.ITEM_ID                            ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   FP00596화면에서 find_YieldInfo_Child 정보갖고오기                                                                                  */
		/*   Param : @param1   , param2  , param3,      param4 ,    param5,   param6 ,   param7,   param8,      param9,    param9               */
		/*   Param : INSTANCE  , PLANID,   AMEND_TABLE, DIVISION  , SITE ,    PLANT,     FACTORY,  OPERATION,   LINE,      ITEM                 */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00596_find_YieldInfo_Child' 
		    BEGIN	
			    SELECT @v_dSql = ''
			    SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			    SELECT @v_dSql += '      , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE          ' + char(10)
			    SELECT @v_dSql += '      , A.EQUIPMENT_ID                                                   ' + char(10)
			    SELECT @v_dSql += '      , A.ITEM_ID                                                        ' + char(10)
			    SELECT @v_dSql += '      ,  CAST(CONVERT(VARCHAR,A.START_DATE,112) AS decimal) AS START_DATE                  ' + char(10)
			    SELECT @v_dSql += '      ,  CAST(CONVERT(VARCHAR,A.END_DATE,112) AS decimal) AS END_DATE                      ' + char(10)
			    SELECT @v_dSql += '      , A.YIELD AS YIELD                                                 ' + char(10)
			    SELECT @v_dSql += '      , A.CHILD_YIELD AS CHILD_YIELD                                     ' + char(10)
			    SELECT @v_dSql += ' FROM   '+ TRY_CONVERT(NVARCHAR,@param3) +' A WITH(NOLOCK)               ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                ' + char(10)
			    SELECT @v_dSql += ' AND    A.FP_PLAN_ID  = '''+ @param2 +'''                                ' + char(10)

	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param4)) + char(10)

				IF(LEN(@param5) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param5 +''' ' + char(10)
				    END		
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param6)) + char(10)
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param7)) + char(10)
				
				IF(LEN(@param8) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param8 +''' ' + char(10)
				    END	

	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param9)) + char(10)
				
				IF(LEN(@param10) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.ITEM_ID  LIKE ''%'' + '''+ @param10 +''' + ''%'' ' + char(10)
				    END	

			    SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			    SELECT @v_dSql += '      , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			    SELECT @v_dSql += '      , A.EQUIPMENT_ID, A.ITEM_ID, START_DATE ' + char(10)
    
				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00596화면에서 find_YieldInfo  정보갖고오기                                                                                       */
		/*   Param : @param1   ,  param2  ,   param3,      param4 ,    param5,   param6 ,   param7,    param8                                 */
		/*   Param : DIVISION  , SITE ,       PLANT,      FACTORY,  OPERATION,   LINE,      ITEM ,     PLAN_DATE                               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00596_find_YieldInfo' 
		    BEGIN	
			    SELECT @v_dSql = ''

			    SELECT @v_dSql += ' SELECT ISNULL(B.YIELD, (CASE WHEN A.YIELD = 0 THEN 1 ELSE A.YIELD END)) AS YIELD ' + char(10)
			    SELECT @v_dSql += ' FROM   SCM_YIELD_M A WITH(NOLOCK)             ' + char(10)
			    SELECT @v_dSql += ' LEFT OUTER JOIN (                             ' + char(10)
			    SELECT @v_dSql += '     SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD ' + char(10)
			    SELECT @v_dSql += '     FROM   SCM_YIELD_EXCEPT_M A WITH(NOLOCK)  ' + char(10)
			    SELECT @v_dSql += '     WHERE  1=1                                ' + char(10)
			    SELECT @v_dSql += '     AND    A.DIVISION_ID  = '''+ @param1 +''' ' + char(10)
			    SELECT @v_dSql += '     AND    A.SITE_ID      = '''+ @param2 +''' ' + char(10)
			    SELECT @v_dSql += '     AND    A.PLANT_ID     = '''+ @param3 +''' ' + char(10)
			    SELECT @v_dSql += '     AND    A.FACTORY_ID   = '''+ @param4 +''' ' + char(10)
			    SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param5 +''' ' + char(10)
			    SELECT @v_dSql += '     AND    A.LINE_ID      = '''+ @param6 +''' ' + char(10)
			    SELECT @v_dSql += '     AND    A.ITEM_ID      = '''+ @param7 +''' ' + char(10)
			    SELECT @v_dSql += '     AND    CONVERT(DATE,'''+ @param8 +''') BETWEEN A.START_TIME AND A.END_TIME ' + char(10)
			    SELECT @v_dSql += ' ) B                                           ' + char(10)
			    SELECT @v_dSql += ' ON     1=1                                    ' + char(10)
			    SELECT @v_dSql += ' WHERE  1=1                                    ' + char(10)
			    SELECT @v_dSql += ' AND    A.DIVISION_ID  = '''+ @param1 +'''     ' + char(10)
			    SELECT @v_dSql += ' AND    A.SITE_ID      = '''+ @param2 +'''     ' + char(10)
			    SELECT @v_dSql += ' AND    A.PLANT_ID     = '''+ @param3 +'''     ' + char(10)
			    SELECT @v_dSql += ' AND    A.FACTORY_ID   = '''+ @param4 +'''     ' + char(10)
			    SELECT @v_dSql += ' AND    A.OPERATION_ID = '''+ @param5 +'''     ' + char(10)
			    SELECT @v_dSql += ' AND    A.LINE_ID      = '''+ @param6 +'''     ' + char(10)
			    SELECT @v_dSql += ' AND    A.ITEM_ID      = '''+ @param7 +'''     ' + char(10)
			    SELECT @v_dSql += ' AND    A.MONTH        = SUBSTRING('''+ @param8 +''',1,6) ' + char(10)
    
				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   FP00596화면에서 findLineCode_List 정보갖고오기                                                                                     */
		/*   Param : @Param1   , Param2  , Param3 ,   Param4 ,      Param5 ,  Param6 , Param7 , Param8 , Param9 , Param10 , Param11 , Param12   */
		/*   Param : INSTANCE  , PLAN_ID , PLAN_TYPE, CONFIRM_AREA, DIVISION, SITE,    PLANT,   FACTORY,  LINE  ,OPERATION, ALL_LINE, USER_LT,  */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00596_findLineCode_List' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT A.LINE_ID AS CODE ' + char(10)
                SELECT @v_dSql += '     , ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS NAME ' + char(10)
                SELECT @v_dSql += ' FROM   SCM_LINE_M A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += ' WHERE  A.ACTIVE_FLAG = ''Y''     ' + char(10)
                SELECT @v_dSql += ' AND EXISTS (                     ' + char(10)
                SELECT @v_dSql += '             SELECT 1             ' + char(10)
                SELECT @v_dSql += '             FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '             WHERE  A.COMPANY_ID   = B.COMPANY_ID      ' + char(10)
                SELECT @v_dSql += '             AND    A.DIVISION_ID  = B.DIVISION_ID     ' + char(10)
                SELECT @v_dSql += '             AND    A.SITE_ID      = B.SITE_ID         ' + char(10)
                SELECT @v_dSql += '             AND    A.PLANT_ID     = B.PLANT_ID        ' + char(10)
                SELECT @v_dSql += '             AND    A.FACTORY_ID   = B.FACTORY_ID      ' + char(10)
                SELECT @v_dSql += '             AND    A.OPERATION_ID = B.OPERATION_ID    ' + char(10)
                SELECT @v_dSql += '             AND    A.LINE_ID      = B.LINE_ID         ' + char(10)
                SELECT @v_dSql += '             AND    B.USER_ID      ='''+ @p_user_id +''' ' + char(10)
                SELECT @v_dSql += ' 	       )               ' + char(10)
                SELECT @v_dSql += ' AND EXISTS (               ' + char(10)
                SELECT @v_dSql += '            SELECT 1 FROM ( ' + char(10)
                SELECT @v_dSql += '                SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                FROM  SCM_FACTORY_M A WITH(NOLOCK)              ' + char(10)
                SELECT @v_dSql += '                INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += '                ON    A.FACTORY_ID=B.FACTORY_ID ' + char(10)
                SELECT @v_dSql += '                AND   B.ACTIVE_FLAG = ''Y''     ' + char(10)
                SELECT @v_dSql += '                WHERE 1=1                       ' + char(10)
                SELECT @v_dSql += '                AND   B.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
                SELECT @v_dSql += '            ) C ' + char(10)
                SELECT @v_dSql += '       WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += ' ) ' + char(10)

				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param5)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @param6)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param7)) + char(10)
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param8)) + char(10)
				----SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param9)) + char(10) 사용안함
				SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @param10)) + char(10)

				IF(LEN(@param1) > 0)
				    BEGIN
                        SELECT @v_dSql += ' AND EXISTS ( SELECT  1 ' + char(10)

                        SELECT @v_dSql += '              FROM  SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)       ' + char(10)
                        SELECT @v_dSql += '              WHERE  LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''     ' + char(10)
                        SELECT @v_dSql += '              AND    LV1.SEGMENT1         = ''' + @param1 + ''' ' + char(10)
                        SELECT @v_dSql += '              AND    LV1.ACTIVE_FLAG      = ''Y''               ' + char(10)
                        SELECT @v_dSql += '              AND    LV1.ATTRIBUTE1       = ''BUILDING''        ' + char(10)
                        SELECT @v_dSql += '              UNION ALL ' + char(10)
                        SELECT @v_dSql += '              SELECT  1 ' + char(10)
                        SELECT @v_dSql += '              FROM  SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK), ' + char(10)
                        SELECT @v_dSql += '                    SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)  ' + char(10)
                        SELECT @v_dSql += '              WHERE LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
                        SELECT @v_dSql += '              AND   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.SEGMENT1         = LV2.SEGMENT1        ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.SEGMENT1         = ''' + @param1 + ''' ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.ACTIVE_FLAG      = ''Y''               ' + char(10)
                        SELECT @v_dSql += '              AND   LV1.ATTRIBUTE1       = ''PLAN GROUP''      ' + char(10)
                        SELECT @v_dSql += '              AND   LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) ' + char(10)
						SELECT @v_dSql += '            ) ' + char(10)
				    END
                
				IF( @param11 != 'Y')
				    BEGIN
                        SELECT @v_dSql += ' AND A.LINE_ID IN (          ' + char(10)
                        SELECT @v_dSql += '     SELECT DISTINCT LINE_ID ' + char(10)
                        SELECT @v_dSql += '     FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK) ' + char(10)
                        SELECT @v_dSql += '     WHERE  AA.INSTANCE_ID = '''+ @param1 +'''   ' + char(10)
						
						IF(LEN(@param12) > 0)
				            BEGIN
				              SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AA.USER_ID' , 'EQ', @param12)) + char(10)
				            END
                        ELSE
				            BEGIN
				                SELECT @v_dSql += '   AND  AA.USER_ID IN ('''') ' + char(10)
				            END

                        SELECT @v_dSql += ' ) ' + char(10)
				    END				        

				IF( @param3 = 'RELEASE' AND @param4 = 'PLAN GROUP')
				    BEGIN
                        SELECT @v_dSql += ' AND A.MODEL_TYPE IN (           ' + char(10)
                        SELECT @v_dSql += '        SELECT KK.PLAN_GROUP_ID  ' + char(10)
                        SELECT @v_dSql += '        FROM   FP_RELEASE_PLAN_INFO_H KK WITH(NOLOCK)  ' + char(10)
                        SELECT @v_dSql += '        WHERE  KK.INSTANCE_ID = '''+ @param1 +'''      ' + char(10)
                        SELECT @v_dSql += '        AND    KK.RELEASE_PLAN_ID = '''+ @param2 +'''  ' + char(10)
                        SELECT @v_dSql += ' )  ' + char(10)
				    END

                SELECT @v_dSql += ' GROUP BY A.LINE_ID, A.LINE_NAME ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.LINE_ID              ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   FP00596화면에서 find_FPNickName 정보갖고오기                                                                                     */
		/*   Param : @Param1   , Param2  , Param3 ,   Param4 ,      Param5 ,   Param6 ,  Param7 , Param8 , Param9 , Param10 , Param11 , Param12, Param13   */
		/*   Param : INSTANCE  , PLAN_ID , PLAN_DATE, BUCKET_FROM,  BUCKET_TO, DIVISION, SITE,    PLANT,   FACTORY,  LINE  ,  OPERATION, ITEM,   AMEND_TABLE  */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00596_find_FPNickName' 
		    BEGIN	
			    SELECT @v_dSql = ''

			    SELECT @v_dSql += ' SELECT DISTINCT ISNULL(B.NICK_NAME,''-'') AS CODE, ISNULL(B.NICK_NAME,''-'') AS NAME ' + char(10)
			    SELECT @v_dSql += ' FROM (     ' + char(10)
			    SELECT @v_dSql += '       -- P ' + char(10)
			    SELECT @v_dSql += '       SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
			    SELECT @v_dSql += '       FROM   '+ TRY_CONVERT(NVARCHAR, @param13) +' A WITH(NOLOCK)  ' + char(10)
			    SELECT @v_dSql += '       WHERE  A.INSTANCE_ID  = '''+ @param1 +'''                    ' + char(10)
			    SELECT @v_dSql += '       AND    A.FP_PLAN_ID   = '''+ @param2 +'''                    ' + char(10)
				SELECT @v_dSql += '       AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param3 +''' AND  '''+ @param5 +''' ' + char(10)
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param6)) + char(10)

				IF(LEN(@param7) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param7 +''' ' + char(10)
				    END					    
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param8))   + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param9)) + char(10)

				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param10)) + char(10)

				IF(LEN(@param11) > 0)	    
				    BEGIN				    
                        SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param11 +''' ' + char(10)
				    END	

                IF(LEN(@param12) > 0) --ITEM	    
				    BEGIN				    
                        SELECT @v_dSql += '     AND    A.ITEM_ID LIKE ''%'' + '''+ @param12 +''' + ''%'' ' + char(10)
				    END	

			    SELECT @v_dSql += '     UNION ALL                                  ' + char(10)
			    SELECT @v_dSql += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
			    SELECT @v_dSql += '     FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)           ' + char(10)
				SELECT @v_dSql += '     WHERE  1=1                                                  ' + char(10)
			    SELECT @v_dSql += '     AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @param4 +''' AND '''+ @param3 +''' -1 ' + char(10)

	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param6)) + char(10)

				IF(LEN(@param7) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param7 +''' ' + char(10)
				    END		
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param8)) + char(10)
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param9)) + char(10)
                SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param11 +''' ' + char(10)
				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param10)) + char(10)
               
			    IF(LEN(@param12) > 0) --ITEM	    
				    BEGIN				    
                        SELECT @v_dSql += '     AND    A.ITEM_ID LIKE ''%'' + '''+ @param12 +''' + ''%'' ' + char(10)
				    END	

			    SELECT @v_dSql += '     UNION ALL ' + char(10)
			    SELECT @v_dSql += '     SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TOP_ITEM_ID AS ITEM_ID ' + char(10)
			    SELECT @v_dSql += '     FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
				SELECT @v_dSql += '     WHERE  1=1 ' + char(10)
			    SELECT @v_dSql += '     AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @param4 +''' AND '''+ @param5 +''' ' + char(10)

	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @param6)) + char(10)

				IF(LEN(@param7) > 0)
				    BEGIN
                        SELECT @v_dSql += '     AND    A.SITE_ID = '''+ @param7 +''' ' + char(10)
				    END	
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @param8)) + char(10)
	            SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @param9)) + char(10)
			    
				IF(LEN(@param11) > 0) --OPERATION_ID	    
				    BEGIN	
					    SELECT @v_dSql += '     AND    A.OPERATION_ID = '''+ @param11 +''' ' + char(10)
				    END	

				SELECT @v_dSql += '     ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @param10)) + char(10)
			    IF(LEN(@param12) > 0) --ITEM	    
				    BEGIN				    
                        SELECT @v_dSql += '     AND    A.ITEM_ID LIKE ''%'' + '''+ @param12 +''' + ''%'' ' + char(10)
				    END	

			    SELECT @v_dSql += ' ) A                                    ' + char(10)
			    SELECT @v_dSql += ' INNER JOIN SCM_ITEM_M B WITH(NOLOCK)   ' + char(10)
			    SELECT @v_dSql += ' ON    A.COMPANY_ID     = B.COMPANY_ID  ' + char(10)
			    SELECT @v_dSql += ' AND   A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			    SELECT @v_dSql += ' AND   A.SITE_ID        = B.SITE_ID     ' + char(10)
			    SELECT @v_dSql += ' AND   A.ITEM_ID        = B.ITEM_ID     ' + char(10)
			    SELECT @v_dSql += ' ORDER BY ISNULL(B.NICK_NAME,''-'')     ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   Amend FP00596 화면에서 find_UOMInfo_ALL 환산자 정보갖고오기                                                                                 */
		/*            @Param1     @Param2      @Param3   @Param4            */
		/*   Param :     */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00596_find_UOMInfo_ALL' 
		    BEGIN	
			    SELECT @v_dSql = ''
                SELECT @v_dSql += ' SELECT DISTINCT A.COMPANY_ID                                ' + char(10)
                SELECT @v_dSql += '       , A.DIVISION_ID                                       ' + char(10)
                SELECT @v_dSql += '       , A.SITE_ID                                           ' + char(10)
                SELECT @v_dSql += '       , A.PLANT_ID                                          ' + char(10)
                SELECT @v_dSql += '       , A.FACTORY_ID                                        ' + char(10)
                SELECT @v_dSql += '       , A.OPERATION_ID                                      ' + char(10)
                SELECT @v_dSql += '       , A.ITEM_ID                                           ' + char(10)
                SELECT @v_dSql += '       , A.BATCH_LOT_SIZE AS VALUE                           ' + char(10)
                SELECT @v_dSql += '       , A.LOT_SIZE_UOM AS CATEGORY                          ' + char(10)
                SELECT @v_dSql += ' FROM SCM_ITEM_EQUIP_RATE_BATCH_M A WITH(NOLOCK)             ' + char(10)
                SELECT @v_dSql += ' WHERE 1=1                                                   ' + char(10)
                SELECT @v_dSql += ' --AND A.LOT_SIZE_UOM = ''KG''                               ' + char(10)
                SELECT @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
                SELECT @v_dSql += ' , A.OPERATION_ID, A.ITEM_ID                                 ' + char(10)

				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend

			   exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00596화면에서 find_YieldInfo_ALL  정보갖고오기                                                                                       */
		/*   Param : @param1   ,  param2      ,  param3                                     */
		/*   Param : INSTANCE  , PLAN_ID      ,  AMEND_BOR_TABLE                            */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00596_find_YieldInfo_ALL' 
		    BEGIN	
			    SELECT @v_dSql = ''
			    SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID   ' + char(10)
			    SELECT @v_dSql += '      , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE            ' + char(10)
			    SELECT @v_dSql += '      , A.EQUIPMENT_ID                                                     ' + char(10)
			    SELECT @v_dSql += '      , A.ITEM_ID                                                          ' + char(10)
			    SELECT @v_dSql += '      , CONVERT(VARCHAR,A.START_DATE,112) AS START_DATE                    ' + char(10)
			    SELECT @v_dSql += '      , CONVERT(VARCHAR,A.END_DATE,112) AS END_DATE                        ' + char(10)
			    SELECT @v_dSql += '      , A.YIELD AS YIELD                                                   ' + char(10)
			    SELECT @v_dSql += '      , A.CHILD_YIELD AS CHILD_YIELD                                       ' + char(10)
			    SELECT @v_dSql += ' FROM   '+ TRY_CONVERT(NVARCHAR, @param3) +' A WITH(NOLOCK)                ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID = '''+ @param1 +'''                                  ' + char(10)
			    SELECT @v_dSql += ' AND    A.FP_PLAN_ID  = '''+ @param2 +'''                                  ' + char(10)
			    SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			    SELECT @v_dSql += '      , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE            ' + char(10)
			    SELECT @v_dSql += '      , A.EQUIPMENT_ID, A.ITEM_ID, START_DATE                              ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		/****************************************************************************************************************************************/
		/*   FP00596_LineAddPopup화면에서 find_dup 정보갖고오기                                                                                 */
		/*   Param : @Param1,      @Param2,  @Param3,    @Param4,  @Param5,  @Param6,  @Param7,  @Param8,  @Param9,  @Param10, @Param11,        @Param12,  @Param13, @Param14,       @Param15         */
		/*   Param : INSTANCE_ID,  PLAN_ID,  PLAN_DATE , DIVISION, SITE,     PLANT,    ITEM,     TOP_ITEM, OPERATION, FACTORY, PRODUCTION_TYPE, MARKET,    LINE,     ELECTRODE_TYPE, EQUIPMENT_ID             */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00596_find_dup' 
		    BEGIN	
			    SELECT @v_dSql = ''
			    SELECT @v_dSql += ' SELECT COUNT(*) AS CNT                        ' + char(10)
			    SELECT @v_dSql += ' FROM   FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK)    ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID     = '''+ @param1 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.FP_PLAN_ID      = '''+ @param3 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.DIVISION_ID     = '''+ @param4 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.SITE_ID         = '''+ @param5 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.PLANT_ID        = '''+ @param6 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.ITEM_ID         = '''+ @param7 +'''  ' + char(10)
			    --SELECT @v_dSql += ' AND    A.TOP_ITEM_ID     = '''+ @param8 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.OPERATION_ID    = '''+ @param9 +'''  ' + char(10)
			    SELECT @v_dSql += ' AND    A.FACTORY_ID      = '''+ @param10 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.PRODUCTION_TYPE = '''+ @param11 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.MARKET          = '''+ @param12 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.LINE_ID         = '''+ @param13 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    A.ELECTRODE_TYPE  = '''+ @param14 +''' ' + char(10)
				SELECT @v_dSql += ' AND    A.EQUIPMENT_ID    = '''+ @param15 +''' ' + char(10)
			    SELECT @v_dSql += ' AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) ='''+ @param2 +''' ' + char(10)
				SELECT @v_dSql += ' AND    A.ADJUST_IN_QTY_BATCH > 0 ' + char(10)
			    --SELECT @v_dSql
			    exec sp_executesql @v_dSql
				
				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend

		   END
		/****************************************************************************************************************************************/
		/*   FP00597화면에서 findFpPlan_info 정보갖고오기                                                                                      */
		/*            @Param1     @Param2    */
		/*   Param : INSTANCE_ID, PLAN_DATE    */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00597_findFpPlan_info' 
		    BEGIN	
			    SELECT @v_dSql = ''

				SELECT @v_dSql += ' WITH RELEASE_PLAN AS (  ' + char(10)
				SELECT @v_dSql += '      SELECT DISTINCT    ' + char(10)
				SELECT @v_dSql += '           A.INSTANCE_ID ' + char(10)
				SELECT @v_dSql += '          ,A.RELEASE_PLAN_ID AS PLAN_ID            ' + char(10)
				SELECT @v_dSql += '          ,STUFF(( SELECT '','' + FACTORY_ID       ' + char(10)
				SELECT @v_dSql += '                   FROM   FP_RELEASE_PLAN_INFO_H B ' + char(10)
				SELECT @v_dSql += '                   WHERE  A.INSTANCE_ID     = B.INSTANCE_ID     ' + char(10)
				SELECT @v_dSql += '                   AND    A.INSTANCE_DATE   = B.INSTANCE_DATE   ' + char(10)
				SELECT @v_dSql += '                   AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID ' + char(10)
				SELECT @v_dSql += '                   FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT ' + char(10)
				SELECT @v_dSql += '          ,A.PLAN_GROUP_ID              ' + char(10)
				SELECT @v_dSql += '          ,A.INSTANCE_DATE AS PLAN_DATE ' + char(10)
				SELECT @v_dSql += '      FROM   FP_RELEASE_PLAN_INFO_H A   ' + char(10)
				SELECT @v_dSql += '      WHERE  1=1                        ' + char(10)
				SELECT @v_dSql += '      AND    A.INSTANCE_ID    = '''+ @param1 +''' ' + char(10)
				SELECT @v_dSql += '      AND    A.INSTANCE_DATE  = '''+ @param2 +''' ' + char(10)
				SELECT @v_dSql += '   )                                              ' + char(10)
				SELECT @v_dSql += '   SELECT A.PLAN_ID AS CODE, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS NAME ' + char(10)
				SELECT @v_dSql += '       ,A.PLAN_ID            ' + char(10)
				SELECT @v_dSql += '       ,A.PLAN_TYPE          ' + char(10)
				SELECT @v_dSql += '       ,A.PLAN_START_TIME    ' + char(10)
				SELECT @v_dSql += '       ,A.PLAN_HORIZON       ' + char(10)
				SELECT @v_dSql += '       ,A.PLAN_HORIZON_UOM   ' + char(10)
				SELECT @v_dSql += '       ,A.DEMAND_HORIZON     ' + char(10)
				SELECT @v_dSql += '       ,A.DEMAND_HORIZON_UOM ' + char(10)
				SELECT @v_dSql += '       ,A.CONFIG_SET_ID      ' + char(10)
				SELECT @v_dSql += '       ,A.BASIS_PLAN_ID      ' + char(10)
				SELECT @v_dSql += '       ,A.DEMAND_PLAN_ID     ' + char(10)
				SELECT @v_dSql += '       ,A.SCP_PLAN_ID        ' + char(10)
				SELECT @v_dSql += '       ,A.PLAN_WEEK          ' + char(10)
				SELECT @v_dSql += '       ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS PLAN_START_DATE ' + char(10)
				SELECT @v_dSql += '       ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS PLAN_END_DATE ' + char(10)
				SELECT @v_dSql += '       ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS DEFAULT_START_DATE ' + char(10)
				SELECT @v_dSql += '       ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS DEFAULT_END_DATE ' + char(10)
				SELECT @v_dSql += '       ,A.INSTANCE_ID ' + char(10)
				SELECT @v_dSql += '       ,A.SITE_ID     ' + char(10)
				SELECT @v_dSql += '       ,A.DESCRIPTION ' + char(10)
				SELECT @v_dSql += '       ,A.PLAN_TYPE   ' + char(10)
				SELECT @v_dSql += '       ,CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID ' + char(10)
				SELECT @v_dSql += '       ,CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME ' + char(10)
				SELECT @v_dSql += '       ,CASE WHEN A.RELEASE_FLAG = ''Y''                    ' + char(10)
				SELECT @v_dSql += '       	  THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID ) ' + char(10) 
				SELECT @v_dSql += '       	  ELSE A.DESCRIPTION END AS DESCS                                            ' + char(10)
				SELECT @v_dSql += '       ,SUBSTRING(BASIS_PLAN_ID,CHARINDEX(''-'',BASIS_PLAN_ID)+1,11) AS BASIC_VERSION ' + char(10)
				SELECT @v_dSql += '       ,C.FACTORY_LT                                  ' + char(10)
				SELECT @v_dSql += '       ,(CASE WHEN PLAN_TYPE = ''RELEASE'' THEN ''Y'' ' + char(10)
				SELECT @v_dSql += '       	   WHEN RIGHT(A.PLAN_ID,2) = ''00'' THEN ''Y'' ELSE ''N'' END) READ_ONLY ' + char(10)
				SELECT @v_dSql += '   FROM   SCM_FP_PLAN_H A WITH(NOLOCK)                ' + char(10)
				SELECT @v_dSql += '          LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK) ' + char(10)
				SELECT @v_dSql += '          ON  A.INSTANCE_ID = C.INSTANCE_ID           ' + char(10)
				SELECT @v_dSql += '          AND A.PLAN_ID = C.PLAN_ID                   ' + char(10)
				SELECT @v_dSql += '   WHERE  1=1                                         ' + char(10)
				SELECT @v_dSql += '   AND    A.INSTANCE_ID = '''+ @param1 +'''           ' + char(10)
				SELECT @v_dSql += '   AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = '''+ @param2 +''' ' + char(10)
				SELECT @v_dSql += '   ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC ' + char(10)
				
				--SELECT @v_dSql
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   FP00597화면에서 find_ListData 정보갖고오기                                                                                         */
		/*   Param : @Param1   , Param2  , Param3     , Param4                                                                                  */
		/*   Param : INSTANCE  , PLAN_ID , OPERATION,  AMEND_TABLE                                                                               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00597_find_ListData' 
		    BEGIN	
			    SELECT @v_dSql = ''

			    SELECT @v_dSql += ' SELECT A.INSTANCE_ID, A.FP_PLAN_ID  ' + char(10)
			    SELECT @v_dSql += '      , A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID  ' + char(10)
			    SELECT @v_dSql += '      , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID  ' + char(10)
			    SELECT @v_dSql += '      , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID  ' + char(10)
			    SELECT @v_dSql += '      , A.PRODUCTION_TYPE, A.MARKET                         ' + char(10)
			    SELECT @v_dSql += '      , A.CUSTOMER_ID                                       ' + char(10)
			    SELECT @v_dSql += '      , A.SEQ                                               ' + char(10)
				SELECT @v_dSql += '      , A.ADJUST_IN_QTY_BATCH AS ADJUST_IN_QTY              ' + char(10)
			    SELECT @v_dSql += '      , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY_KG           ' + char(10)
				SELECT @v_dSql += '      , A.ADJUST_OUT_QTY_BATCH AS ADJUST_OUT_QTY            ' + char(10)
			    SELECT @v_dSql += '      , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY_KG         ' + char(10)
			    SELECT @v_dSql += ' FROM   '+ TRY_CONVERT(NVARCHAR,@param4) +' A WITH(NOLOCK)  ' + char(10)
			    SELECT @v_dSql += ' WHERE  A.INSTANCE_ID  = '''+ @param1 +'''                  ' + char(10)
			    SELECT @v_dSql += ' AND    A.FP_PLAN_ID   = '''+ @param2 +'''                  ' + char(10)
			    SELECT @v_dSql += ' AND    A.OPERATION_ID = '''+ @param3 +'''                  ' + char(10)
			    SELECT @v_dSql += ' ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID  ' + char(10)
			    SELECT @v_dSql += '        , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID  ' + char(10)
			    SELECT @v_dSql += '        , A.TOP_ITEM_ID, A.ITEM_ID, A.PLAN_DATE  ' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END



		/****************************************************************************************************************************************/
		/*   FP00620화면에서 findFpPlan_info 정보갖고오기                                                                                         */
		/*   Param : @Param1   , Param2  , Param3                          */
		/*   Param : INSTANCE  , PLAN_DATE ,  USER_ID                                                                               */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'FP00620_findFpPlan_info' 
		    BEGIN	
			    SELECT @v_dSql  += '    WITH RELEASE_PLAN AS (' + char(10)
				SELECT @v_dSql  += '            SELECT DISTINCT ' + char(10)
				SELECT @v_dSql  += '                    A.INSTANCE_ID' + char(10)
				SELECT @v_dSql  += '                    ,A.RELEASE_PLAN_ID AS PLAN_ID' + char(10)
				SELECT @v_dSql  += '                    ,STUFF(( SELECT '','' + FACTORY_ID' + char(10)
				SELECT @v_dSql  += '                            FROM   FP_RELEASE_PLAN_INFO_H B' + char(10)
				SELECT @v_dSql  += '                            WHERE  A.INSTANCE_ID     = B.INSTANCE_ID' + char(10)
				SELECT @v_dSql  += '                            AND    A.INSTANCE_DATE   = B.INSTANCE_DATE' + char(10)
				SELECT @v_dSql  += '                            AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID' + char(10)
				SELECT @v_dSql  += '                            FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT' + char(10)
				SELECT @v_dSql  += '                    ,A.PLAN_GROUP_ID' + char(10)
				SELECT @v_dSql  += '                    ,A.INSTANCE_DATE AS PLAN_DATE' + char(10)
				SELECT @v_dSql  += '            FROM   FP_RELEASE_PLAN_INFO_H A' + char(10)
				SELECT @v_dSql  += '            WHERE  1=1' + char(10)
				IF(LEN(@param1) > 0 )
					BEGIN
						SELECT @v_dSql += '    AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
					END
				IF(LEN(@param2) > 0 )
					BEGIN
						SELECT @v_dSql += '    AND    A.INSTANCE_DATE  = '''+ @param2 +''' ' + char(10)
					END
				SELECT @v_dSql  += '        )' + char(10)
				SELECT @v_dSql  += '        SELECT A.PLAN_ID AS CODE_ID, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS CODE_NAME' + char(10)
				SELECT @v_dSql  += '                ,A.PLAN_ID'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_TYPE'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_START_TIME'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_HORIZON'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_HORIZON_UOM'+char(10)
				SELECT @v_dSql  += '                ,A.DEMAND_HORIZON'+char(10)
				SELECT @v_dSql  += '                ,A.DEMAND_HORIZON_UOM'+char(10)
				SELECT @v_dSql  += '                ,A.CONFIG_SET_ID'+char(10)
				SELECT @v_dSql  += '                ,A.BASIS_PLAN_ID'+char(10)
				SELECT @v_dSql  += '                ,A.DEMAND_PLAN_ID'+char(10)
				SELECT @v_dSql  += '                ,A.SCP_PLAN_ID'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_WEEK'+char(10)
				SELECT @v_dSql  += '                ,' + ''''+ @param2 +''' AS PLAN_START_DATE'+char(10)
				SELECT @v_dSql  += '                ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS PLAN_END_DATE ' + char(10)
				SELECT @v_dSql  += '                ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS DEFAULT_START_DATE ' + char(10)
				SELECT @v_dSql  += '                ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS DEFAULT_END_DATE ' + char(10)
				SELECT @v_dSql  += '                ,A.INSTANCE_ID'+char(10)
				SELECT @v_dSql  += '                ,A.SITE_ID'+char(10)
				SELECT @v_dSql  += '                ,A.DESCRIPTION'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_TYPE'+char(10)
				SELECT @v_dSql  += '                ,CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID'+char(10)
				SELECT @v_dSql  += '                ,CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME'+char(10)
				SELECT @v_dSql  += '                ,CASE WHEN A.RELEASE_FLAG = ''Y'' '+char(10)
				SELECT @v_dSql  += '                    THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID ) '+char(10)
				SELECT @v_dSql  += '                    ELSE A.DESCRIPTION END AS DESCS' + char(10)
				SELECT @v_dSql  += '                ,SUBSTRING(BASIS_PLAN_ID,CHARINDEX(''-'',BASIS_PLAN_ID)+1,11) AS BASIC_VERSION' + char(10)
				SELECT @v_dSql  += '                ,C.FACTORY_LT' + char(10)
				SELECT @v_dSql  += '        FROM   SCM_FP_PLAN_H A WITH(NOLOCK)' + char(10)
				SELECT @v_dSql  += '                LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK)' + char(10)
				SELECT @v_dSql  += '                ON  A.INSTANCE_ID = C.INSTANCE_ID' + char(10)
				SELECT @v_dSql  += '                AND A.PLAN_ID = C.PLAN_ID' + char(10)
				SELECT @v_dSql  += '        , (' + char(10)
				SELECT @v_dSql  += '            SELECT C.INSTANCE_ID' + char(10)
				SELECT @v_dSql  += '            FROM   TH_UIS_USER_FACTORY_RELATE A WITH(NOLOCK), TH_UIS_ROLE_FACTORY_RELATE B WITH(NOLOCK), FP_INSTANCE_FACTORY_M C WITH(NOLOCK)' + char(10)
				--개발
				SELECT @v_dSql  += '            WHERE  A.USER_ID =' +  ''''+ 'DEMO117' +''''  + char(10)
				-- 운영 SELECT @v_dSql  += '            WHERE  A.USER_ID =' +  ''''+ @param3 +''''  + char(10)
				SELECT @v_dSql  += '            AND    A.ROLE_ID = B.ROLE_ID' + char(10)
				SELECT @v_dSql  += '            AND    B.FACTORY_ID = C.FACTORY_ID' + char(10)
				SELECT @v_dSql  += '            AND    A.USE_AT_FLAG = ''Y''' + char(10)
				SELECT @v_dSql  += '            AND    B.USE_AT_FLAG = ''Y''' + char(10)
				SELECT @v_dSql  += '            AND    C.ACTIVE_FLAG = ''Y''' + char(10)
				SELECT @v_dSql  += '            GROUP BY C.INSTANCE_ID' + char(10)
				SELECT @v_dSql  += '        ) B' + char(10)
				SELECT @v_dSql  += '        WHERE  A.INSTANCE_ID = B.INSTANCE_ID' + char(10)
				IF(LEN(@param1) > 0)
					BEGIN
						SELECT @v_dSql += '   AND    A.INSTANCE_ID = '''+ @param1 +'''' + char(10)
					END
				IF(LEN(@param2) > 0)
					BEGIN
						SELECT @v_dSql += '   AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) BETWEEN ' + ''''+ @param2 +''''+ ' - 3 AND '+  ''''+ @param2 +'''' + char(10)
					END


				SELECT @v_dSql  += '        ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		   END
		ELSE IF @p_code = 'FP00614_findFpPlan_info' 
		BEGIN
			SELECT @v_dSql  += '    WITH RELEASE_PLAN AS (' + char(10)
				SELECT @v_dSql  += '            SELECT DISTINCT ' + char(10)
				SELECT @v_dSql  += '                    A.INSTANCE_ID' + char(10)
				SELECT @v_dSql  += '                    ,A.RELEASE_PLAN_ID AS PLAN_ID' + char(10)
				SELECT @v_dSql  += '                    ,STUFF(( SELECT '','' + FACTORY_ID' + char(10)
				SELECT @v_dSql  += '                            FROM   FP_RELEASE_PLAN_INFO_H B' + char(10)
				SELECT @v_dSql  += '                            WHERE  A.INSTANCE_ID     = B.INSTANCE_ID' + char(10)
				SELECT @v_dSql  += '                            AND    A.INSTANCE_DATE   = B.INSTANCE_DATE' + char(10)
				SELECT @v_dSql  += '                            AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID' + char(10)
				SELECT @v_dSql  += '                            FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT' + char(10)
				SELECT @v_dSql  += '                    ,A.PLAN_GROUP_ID' + char(10)
				SELECT @v_dSql  += '                    ,A.INSTANCE_DATE AS PLAN_DATE' + char(10)
				SELECT @v_dSql  += '            FROM   FP_RELEASE_PLAN_INFO_H A' + char(10)
				SELECT @v_dSql  += '            WHERE  1=1' + char(10)
				IF(LEN(@param1) > 0 )
					BEGIN
						SELECT @v_dSql += '    AND    A.INSTANCE_ID = '''+ @param1 +''' ' + char(10)
					END
				IF(LEN(@param2) > 0 )
					BEGIN
						SELECT @v_dSql += '    AND    A.INSTANCE_DATE  = '''+ @param2 +''' ' + char(10)
					END
				SELECT @v_dSql  += '        )' + char(10)
				SELECT @v_dSql  += '        SELECT A.PLAN_ID AS CODE_ID, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS CODE_NAME' + char(10)
				SELECT @v_dSql  += '                ,A.PLAN_ID'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_TYPE'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_START_TIME'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_HORIZON'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_HORIZON_UOM'+char(10)
				SELECT @v_dSql  += '                ,A.DEMAND_HORIZON'+char(10)
				SELECT @v_dSql  += '                ,A.DEMAND_HORIZON_UOM'+char(10)
				SELECT @v_dSql  += '                ,A.CONFIG_SET_ID'+char(10)
				SELECT @v_dSql  += '                ,A.BASIS_PLAN_ID'+char(10)
				SELECT @v_dSql  += '                ,A.DEMAND_PLAN_ID'+char(10)
				SELECT @v_dSql  += '                ,A.SCP_PLAN_ID'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_WEEK'+char(10)
			    SELECT @v_dSql += '    ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS PLAN_START_DATE ' + char(10)
                SELECT @v_dSql += '    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS PLAN_END_DATE ' + char(10)
                SELECT @v_dSql += '    ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD = '''+ @param2 +''')) AS DEFAULT_START_DATE ' + char(10)
                SELECT @v_dSql += '    ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '''+ @param2 +''')))), 112) AS DEFAULT_END_DATE ' + char(10)
				SELECT @v_dSql  += '                ,A.INSTANCE_ID'+char(10)
				SELECT @v_dSql  += '                ,A.SITE_ID'+char(10)
				SELECT @v_dSql  += '                ,A.DESCRIPTION'+char(10)
				SELECT @v_dSql  += '                ,A.PLAN_TYPE'+char(10)
				SELECT @v_dSql  += '                ,CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID'+char(10)
				SELECT @v_dSql  += '                ,CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME'+char(10)
				SELECT @v_dSql  += '                ,CASE WHEN A.RELEASE_FLAG = ''Y'' '+char(10)
				SELECT @v_dSql  += '                    THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID ) '+char(10)
				SELECT @v_dSql  += '                    ELSE A.DESCRIPTION END AS DESCS' + char(10)
				SELECT @v_dSql  += '                ,SUBSTRING(BASIS_PLAN_ID,CHARINDEX(''-'',BASIS_PLAN_ID)+1,11) AS BASIC_VERSION' + char(10)
				SELECT @v_dSql  += '                ,C.FACTORY_LT' + char(10)
				SELECT @v_dSql  += '        FROM   SCM_FP_PLAN_H A WITH(NOLOCK)' + char(10)
				SELECT @v_dSql  += '                LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK)' + char(10)
				SELECT @v_dSql  += '                ON  A.INSTANCE_ID = C.INSTANCE_ID' + char(10)
				SELECT @v_dSql  += '                AND A.PLAN_ID = C.PLAN_ID' + char(10)
				SELECT @v_dSql  += '        , (' + char(10)
				SELECT @v_dSql  += '            SELECT C.INSTANCE_ID' + char(10)
				SELECT @v_dSql  += '            FROM   TH_UIS_USER_FACTORY_RELATE A WITH(NOLOCK), TH_UIS_ROLE_FACTORY_RELATE B WITH(NOLOCK), FP_INSTANCE_FACTORY_M C WITH(NOLOCK)' + char(10)
				--개발
				SELECT @v_dSql  += '            WHERE  A.USER_ID =' +  ''''+ 'DEMO117' +''''  + char(10)
				-- 운영 SELECT @v_dSql  += '            WHERE  A.USER_ID =' +  ''''+ @param3 +''''  + char(10)
				SELECT @v_dSql  += '            AND    A.ROLE_ID = B.ROLE_ID' + char(10)
				SELECT @v_dSql  += '            AND    B.FACTORY_ID = C.FACTORY_ID' + char(10)
				SELECT @v_dSql  += '            AND    A.USE_AT_FLAG = ''Y''' + char(10)
				SELECT @v_dSql  += '            AND    B.USE_AT_FLAG = ''Y''' + char(10)
				SELECT @v_dSql  += '            AND    C.ACTIVE_FLAG = ''Y''' + char(10)
				SELECT @v_dSql  += '            GROUP BY C.INSTANCE_ID' + char(10)
				SELECT @v_dSql  += '        ) B' + char(10)
				SELECT @v_dSql  += '        WHERE  A.INSTANCE_ID = B.INSTANCE_ID' + char(10)
				IF(LEN(@param1) > 0)
					BEGIN
						SELECT @v_dSql += '   AND    A.INSTANCE_ID = '''+ @param1 +'''' + char(10)
					END
				IF(LEN(@param2) > 0)
					BEGIN
						SELECT @v_dSql += '   AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) BETWEEN ' + ''''+ @param2 +''''+ ' - 3 AND '+  ''''+ @param2 +'''' + char(10)
					END


				SELECT @v_dSql  += '        ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC' + char(10)

				--SELECT @v_dSql
			    exec sp_executesql @v_dSql
		END
		ELSE IF @p_code = 'WH_LOOK_UP' 
		    BEGIN	
				--WH 그룹 별 TEMP CAPA 기타 정보 조회
	   			SELECT @v_dSql = '';
	   			SELECT @v_dSql += ' SELECT 	SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS FACTORY_ID, SEGMENT3 AS ROLL_TYPE, ' + char(10);
				SELECT @v_dSql += '        SEGMENT4 AS ELECTRODE_TYPE, SEGMENT5 AS ATTR_TYPE, ATTRIBUTE1 AS TEMP_CAPA ' + char(10);		
				SELECT @v_dSql += ' FROM 	SCM_SYS_LOOKUP_VALUE ' + char(10);		
				SELECT @v_dSql += 'WHERE 	LOOKUP_TYPE_CODE = '''+ @param1 +''''+  +char(10);

			    exec sp_executesql @v_dSql

		   END
		   	/****************************************************************************************************************************************/
		/*   AUTHAPPROVAL - 																							*/
		/*   comment="FP02843 comboBox Param"		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code ='ATTR_TYPE'
		BEGIN
			SET @v_dSql = '';
				SELECT @v_dSql += ' SELECT distinct	 SEGMENT5 AS CODE, NAME = CASE   ' + char(10);
				SELECT @v_dSql += ' WHEN SEGMENT5 = ''-'' THEN ''-''   ' + char(10);
				SELECT @v_dSql += ' ELSE  SEGMENT5 + '' TYPE''   ' + char(10);
				SELECT @v_dSql += ' END ' + char(10);
				SELECT @v_dSql += ' FROM 	SCM_SYS_LOOKUP_VALUE		 ' + char(10);
				SELECT @v_dSql += ' WHERE 	1=1		 ' + char(10);
				SELECT @v_dSql += ' AND 	LOOKUP_TYPE_CODE = ''E_POST_WH_CAPA_DEFINIT''		 ' + char(10);
			exec sp_executesql @v_dSql
		END

		/****************************************************************************************************************************************/
		/*   AUTHAPPROVAL - 																							*/
		/*   comment="FP02843 comboBox Param"		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code ='find_CurColor'
		BEGIN
			SET @v_dSql = '';
				SELECT @v_dSql += ' 	SELECT  A.SETUP_COLOR_CODE							' + char(10);
				SELECT @v_dSql += ' 	FROM    FP_AMEND_SETUP_COLOR_M A WITH(NOLOCK)		' + char(10);
				SELECT @v_dSql += ' 	WHERE   1=1											' + char(10);
				SELECT @v_dSql += ' 	AND A.INSTANCE_ID	= '''+ @param1 +'''' + char(10);
				SELECT @v_dSql += ' 	AND A.COMPANY_ID	= '''+ @param2 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.DIVISION_ID	= '''+ @param3 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.SITE_ID		= '''+ @param4 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.PLANT_ID		= '''+ @param5 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.FACTORY_ID	= '''+ @param6 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.OPERATION_ID	= '''+ @param7 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.LINE_ID		= '''+ @param8 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.TOP_ITEM_ID	= '''+ @param9 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.ITEM_ID		= '''+ @param10 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.ELECTRODE_TYPE = '''+ @param11 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.EQUIPMENT_ID	= '''+ @param12 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.MARKET		= '''+ @param13 + '''' + char(10);
				SELECT @v_dSql += ' 	AND A.PRODUCTION_TYPE = '''+ @param14 + '''' + char(10);
				SELECT @v_dSql += ' 	AND CONVERT(VARCHAR,A.PLAN_DATE,112) = '''+ @param15 + '''' + char(10);	
				SELECT @v_dSql += ' 	AND A.SEQ = '''+ @param16 + '''' + char(10); 
			exec sp_executesql @v_dSql
		END
		/****************************************************************************************************************************************/
		/*   find_SetupColor_P - 																							*/
		/*   comment="find_SetupColor_P"		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code ='find_SetupColor_P'
		BEGIN
			SET @v_dSql = '';
			SELECT @v_dSql += '  SELECT 	A.SEGMENT4 AS UI_COLOR, A.ATTRIBUTE2 AS UI_DESC, A.SEGMENT2 AS UI_PARAM   ' + char(10);
			SELECT @v_dSql += '  FROM   	SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)										  ' + char(10);
			SELECT @v_dSql += '  WHERE  	A.LOOKUP_TYPE_CODE = ''UI_AMEND_COLOR''									  ' + char(10);
			SELECT @v_dSql += '  AND    	A.SEGMENT1 = ''' + @param1 +'''' + char(10);
			SELECT @v_dSql += '  AND    	A.ACTIVE_FLAG = ''Y'' ' + char(10);
			exec sp_executesql @v_dSql
		END
		/****************************************************************************************************************************************/
		/*   FINDFPPLAN_INFO - 																							*/
		/*   comment="FINDFPPLAN_INFO"		*/
		/*   Param : @param1	      	@param2         @param3																	*/
		/*   Param : INSTANCE_ID	 	BUCKET_FROM     BUCKET_TO																	*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code ='FIND_FPPLAN_INFO'
		BEGIN		
			SET @v_dSql = '';
			SET @v_dSql += '    WITH RELEASE_PLAN AS ( '+char(10);
			SET @v_dSql += '          SELECT DISTINCT'+char(10);
			SET @v_dSql += '                 A.INSTANCE_ID'+char(10);
			SET @v_dSql += '                ,A.RELEASE_PLAN_ID AS PLAN_ID'+char(10);
			SET @v_dSql += '                ,STUFF(( SELECT '','' + FACTORY_ID'+char(10);
			SET @v_dSql += '                         FROM   FP_RELEASE_PLAN_INFO_H B'+char(10);
			SET @v_dSql += '                         WHERE  A.INSTANCE_ID     = B.INSTANCE_ID'+char(10);
			SET @v_dSql += '                         AND    A.INSTANCE_DATE   = B.INSTANCE_DATE'+char(10);
			SET @v_dSql += '                         AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID'+char(10);
			SET @v_dSql += '                         FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT'+char(10);
			SET @v_dSql += '                ,A.PLAN_GROUP_ID'+char(10);
			SET @v_dSql += '                ,A.INSTANCE_DATE AS PLAN_DATE'+char(10);
			SET @v_dSql += '          FROM   FP_RELEASE_PLAN_INFO_H A'+char(10);
			SET @v_dSql += '          WHERE  1=1'+char(10);
			SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @param1)) + char(10);
			SET @v_dSql += '		AND CONVERT(DATE, A.INSTANCE_DATE) >= CONVERT(DATE, ''' + @param2 + ''')' + char(10); 
			SET @v_dSql += '		AND CONVERT(DATE, A.INSTANCE_DATE) <= CONVERT(DATE, ''' + @param3 + ''')   )' + char(10); 

			SET @v_dSql += '		 SELECT R.INSTANCE_ID, R.PLAN_ID, R.FACTORY_LT, R.PLAN_GROUP_ID, R.PLAN_DATE, A.PLAN_TYPE ' + char(10); 
			SET @v_dSql += '		 FROM SCM_FP_PLAN_H A   WITH(NOLOCK)  ' + char(10); 
			SET @v_dSql += '		 JOIN RELEASE_PLAN as R  ' + char(10);
			SET @v_dSql += '		 ON  A.PLAN_ID = R.PLAN_ID ' + char(10); 
			SET @v_dSql += '		 AND A.PLAN_TYPE = ''RELEASE'' ' + char(10); 
			SET @v_dSql += '		order by R.PLAN_DATE DESC ' + char(10); 

			exec sp_executesql @v_dSql
		END			
		/****************************************************************************************************************************************/
		/*   COMPANY CODE 																							*/
		/*   comment="COMPANY"		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code ='COMPANY'
		BEGIN		
			SET @v_dSql = '';
			SET	@v_dSql += ' SELECT A.COMPANY_ID CODE		' + char(10);				
			SET	@v_dSql += '	    ,A.COMPANY_NAME NAME		' + char(10);
  			SET	@v_dSql += '    FROM SCM_MST_COMPANY_SN A WITH(NOLOCK)			' + char(10);

			EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			exec sp_executesql @v_dSql
		END
		/****************************************************************************************************************************************/
		/*   PROBLEM_TYPE - 																							*/
		/*   comment="PROBLEM_TYPE"		*/
		/*   Param : 																			*/
		/****************************************************************************************************************************************/
		ELSE IF @p_code ='PROBLEM_TYPE'
		    BEGIN		
				SET	@v_dSql += '   SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME		' + char(10);				
				SET	@v_dSql += '   FROM   SCM_SYS_LOOKUP_VALUE(NOLOCK)		' + char(10);
  				SET	@v_dSql += '   WHERE  LOOKUP_TYPE_CODE = ''PROBLEM_TYPE''    ' + char(10);
  				SET	@v_dSql += '   AND    ACTIVE_FLAG = ''Y''    ' + char(10);
  				SET	@v_dSql += '   ORDER BY SORT_ORDER   ' + char(10);

				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
				exec sp_executesql @v_dSql
			END
		/****************************************************************************************************************************************/
		/*   인스턴스 별 PIC 기능 활성화 여부              */
		/*   Param : @Param1                               */
		/*   Param : INSTANCE_ID                           */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'INSTANCE_OPTION' 
		    BEGIN
				
			    SELECT @v_dSql =''
                SELECT @v_dSql += 'SELECT ''' + @param2 + ''' AS INSTANCE_ID, ISNULL(MAX(ATTRIBUTE1), ''N'') AS PIC_ALARM ' + char(10)
                SELECT @v_dSql += 'FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += 'WHERE  1=1 ' + char(10)
                SELECT @v_dSql += 'AND    LOOKUP_TYPE_CODE = ''INSTANCE_OPTION'' ' + char(10)
                SELECT @v_dSql += 'AND    SEGMENT1 = ''' + @param2 + ''' ' + char(10)

				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   JOB MONITER             */
		/*   Param :                             */
		/*   Param : SCM_JOB_MONITER_V                           */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'JOB_MONITER' 
		    BEGIN
				
			    SELECT @v_dSql =''
                SELECT	@v_dSql += '	SELECT MODULE, PROGRAM_NAME, LOG_TYPE, LOG_MESSAGE, DESCRIPTION, CREATION_DATE ' + char(10);
				SELECT	@v_dSql += '	FROM SCM_JOB_MONITER_V		' + char(10);	

				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   JOB MONITER             */
		/*   Param :                             */
		/*   Param : SYSTEM CALL RECIPIENT                           */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'SYSTEM_CALL_RECIPIENT' 
		    BEGIN
				
			    SELECT @v_dSql =''
                SELECT	@v_dSql += '	SELECT SEGMENT1 AS SYSTEM, ATTRIBUTE1 AS RECIPIENT FROM SCM_SYS_LOOKUP_VALUE ' + char(10);
				SELECT	@v_dSql += '			WHERE LOOKUP_TYPE_CODE= ''SYSTEM_CALL_RECIPIENT'' ' + char(10);
				SELECT	@v_dSql += '			AND   ACTIVE_FLAG = ''Y'' ' + char(10);				

				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END
		/****************************************************************************************************************************************/
		/*   USER DETAIL             */
		/*   Param :                             */
		/*   Param : UIS_USER_DETAIL                           */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'UIS_USER_DETAIL' 
		    BEGIN
				
			    SELECT @v_dSql =''
                SELECT @v_dSql += '	select * from   TH_UIS_USER_DETAIL where ' + char(10);
				SELECT @v_dSql += '			USER_ID = '''+ @param1 + '''' + char(10);			

				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END

		/****************************************************************************************************************************************/
		/*   인스턴스 별 plan 생성 및 배포 제한 처리             */
		/*   Param : INSTANCE_ID    */
		/*   Param :                            */
		/****************************************************************************************************************************************/
		ELSE IF @p_code = 'CONTROL_PLAN_CREATE_RELEASE_BY_INSTANCE' 
		    BEGIN
				
			    SELECT @v_dSql =''
                SELECT @v_dSql += 'SELECT A.SEGMENT1 AS INSTANCE_ID ' + char(10)
                SELECT @v_dSql += '     , A.ATTRIBUTE1 AS CREATE_PLAN_LIMIT_YN ' + char(10)
                SELECT @v_dSql += '     , A.ATTRIBUTE2 AS CREATE_PLAN_FIX_DATE_YN ' + char(10)
                SELECT @v_dSql += '     , A.ATTRIBUTE3 AS CREATE_PLAN_FIX_DATE ' + char(10)
                SELECT @v_dSql += '     , A.ATTRIBUTE4 AS CREATE_PLAN_FIX_TYPE_YN ' + char(10)
				SELECT @v_dSql += '     , A.ATTRIBUTE5 AS CREATE_PLAN_FIX_TYPE	' + char(10)
                SELECT @v_dSql += '     , A.ATTRIBUTE6 AS RELEASE_LIMIT_YN ' + char(10)
				SELECT @v_dSql += '     , A.ATTRIBUTE7 AS AMEND_LIMIT_YN ' + char(10)
				SELECT @v_dSql += '     , A.ATTRIBUTE8 AS AMEND_LIMIT_DATE ' + char(10)
				SELECT @v_dSql += '     , CONVERT(VARCHAR, (CONVERT(DATETIME,A.ATTRIBUTE8)+1), 112) AS AMEND_LIMIT_DATE2 ' + char(10) -- amend 입력 가능 시작일자를 별도로 가져온다.(AMEND_LIMIT_DATE + 1)
                SELECT @v_dSql += 'FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
                SELECT @v_dSql += 'WHERE  A.LOOKUP_TYPE_CODE = N''CONTROL_PLAN_CREATE_RELEASE_BY_INSTANCE'' ' + char(10)
                SELECT @v_dSql += 'AND    A.ACTIVE_FLAG      = ''Y'' ' + char(10)
                SELECT @v_dSql += 'AND    A.SEGMENT1 = ''' + @param1 + ''' ' + char(10)
                SELECT @v_dSql += 'ORDER BY SORT_ORDER, A.SEGMENT1 ' + char(10)

				EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, @p_code, '', @v_dSql, 'select', @runstart, @runend
			    exec sp_executesql @v_dSql

		   END

	END

