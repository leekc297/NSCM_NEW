

/*
 * Program ID   : [PR_UI_FP01886_USER_POPUP]
 * Description  : Authority Request
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/19   JYJ				Initial Release UI통합
 * 2024/04/15   leejsthira2		기준 user 테이블 변경
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01886_USER_POPUP]
  @p_sys_type                   NVARCHAR(100),
  @p_sys_flag                   NVARCHAR(100),
  @p_sys_gubun                  NVARCHAR(100),
  @p_user_id                    NVARCHAR(100),
  @p_auth_user_id	    	    NVARCHAR(100),
  @p_auth_user_name	    	    NVARCHAR(100)

AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type             NVARCHAR(100)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag             NVARCHAR(100)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun            NVARCHAR(100) 
	DECLARE @v_user_id              NVARCHAR(100)
    DECLARE @v_auth_user_id			NVARCHAR(100)
    DECLARE @v_auth_user_name	    NVARCHAR(100)


	DECLARE @recv_active_flag       NVARCHAR(100)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = '[PR_UI_FP01886_USER_POPUP]'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(100) = ''
	DECLARE @v_error_description    NVARCHAR(100) = ''
	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''

	SET @v_sys_type                 = ''
	SET @v_sys_flag                 = ''
	SET @v_sys_gubun                = ''
	SET @v_user_id                  = ''
    SET @v_auth_user_id				= ''
    SET @v_auth_user_name			= ''

	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag

	SET	@v_dSql                 = ''


	/************************************************************************************************/
	/* SELECT인경우 :SELECT(MAIN)                                                                 */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_USER')
        BEGIN --IF(START)
            SELECT @v_dSql = ''
			/*
            SELECT @v_dSql += ' SELECT A.COMPANY, A.DIVISION, A.CORPORATION, A.PLANT        ' + char(10)
            SELECT @v_dSql += '    , A.DEPARTMENT, A.USER_ID, A.USER_NAME, A.USER_GRAD_CODE ' + char(10)
            SELECT @v_dSql += '    , A.IP_ADRESS, A.PASS_CODE PASS_CODE  ' + char(10)
            SELECT @v_dSql += ' FROM   TH_UIS_USER_DETAIL A ' + char(10)
            SELECT @v_dSql += ' WHERE  1=1                  ' + char(10)
 
			IF(LEN(@p_auth_user_id) > 0)
                BEGIN
                    SELECT @v_dSql += ' AND    A.USER_ID   LIKE ''%'' + UPPER('''+ @p_auth_user_id +''') + ''%'' ' + char(10)
                END
			IF(LEN(@p_auth_user_name) > 0)
                BEGIN
                    SELECT @v_dSql += ' AND    A.USER_NAME  LIKE ''%'' + UPPER(N'''+ @p_auth_user_name +''') + ''%'' ' + char(10)
                END
            SELECT @v_dSql += ' ORDER BY A.COMPANY, A.DIVISION, A.CORPORATION, A.PLANT, A.DEPARTMENT, A.USER_ID ' + char(10)
			*/
			-- 기준 user 테이블 변경
            SELECT @v_dSql += 'SELECT ''-'' AS COMPANY,  ''-'' AS DIVISION,  ''-'' AS CORPORATION,  ''-'' AS PLANT ' + char(10)
            SELECT @v_dSql += '     , ISNULL((CASE WHEN A.LANGUAGE = ''KR'' THEN B.DEPT_NAME_KO ' + char(10)
            SELECT @v_dSql += '                    WHEN A.LANGUAGE = ''EN'' THEN B.DEPT_NAME_EN ' + char(10)
            SELECT @v_dSql += '    	            ELSE B.DEPT_NAME_KO END), A.DEPT_ID)AS DEPARTMENT ' + char(10)
            SELECT @v_dSql += '     , A.USERID AS USER_ID, A.USERNAME AS USER_NAME ' + char(10)
            SELECT @v_dSql += '     , ''-'' AS USER_GRAD_CODE, ''-'' AS IP_ADRESS, ''-'' AS PASS_CODE ' + char(10)
            SELECT @v_dSql += 'FROM  TB_FX_USER_SN A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += 'LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO_SN B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql += 'ON    A.DEPT_ID = B.DEPT_ID ' + char(10)
            SELECT @v_dSql += 'WHERE 1=1 ' + char(10)

			IF(LEN(@p_auth_user_id) > 0)
            BEGIN
                SELECT @v_dSql += 'AND    A.USERID   LIKE ''%'' + UPPER('''+ @p_auth_user_id +''') + ''%'' ' + char(10)
            END
			IF(LEN(@p_auth_user_name) > 0)
            BEGIN
                SELECT @v_dSql += 'AND    A.USERNAME  LIKE ''%'' + UPPER(N'''+ @p_auth_user_name +''') + ''%'' ' + char(10)
            END

            SELECT @v_dSql += 'ORDER BY DEPARTMENT, USER_ID  ' + char(10)

		    IF @p_sys_type = 'SQL'
		  	    BEGIN
		  	    	 EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
		  	    	 SELECT @v_dSql as [QUERY_VALUE]
		  	    END  
		    ELSE 
		    	BEGIN
		    		SET @runstart = GetDate()
		    		--쿼리실행
		    		EXEC sp_executesql @v_dSql
		    		
		    		SET @runend = GetDate()
		    		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
		    	END
        END	--IF( END )

END --MAIN END

