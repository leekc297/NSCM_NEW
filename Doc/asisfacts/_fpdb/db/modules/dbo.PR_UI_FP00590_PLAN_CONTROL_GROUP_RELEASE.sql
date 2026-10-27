






/*
 * Program ID   : PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE
 * Description  : Plan Control Group Release
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/03/17   JYJ				Initial Release UI통합
 * 2024/12/19   leejsthira2     [E20241218-001011]수량이 부적합하다고 릴리즈 불가현상 확인 요청
 * 2025-12-15 	yschoithira	  	[E20251205-001628] ESMI4동 ESS, 자동차 라인 MES DB통합에 따른 기능개선 건
 */

CREATE   PROCEDURE [dbo].[PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE]
  @p_sys_type             NVARCHAR(MAX),
  @p_sys_flag             NVARCHAR(MAX),
  @p_sys_gubun            NVARCHAR(MAX),
  @p_user_id              NVARCHAR(MAX),
  @p_division_id          NVARCHAR(MAX),
  @p_site_id              NVARCHAR(MAX),
  @p_factory_id           NVARCHAR(MAX),
  @p_instance_id          NVARCHAR(MAX),
  @p_plan_date            NVARCHAR(MAX),
  @p_plan_id              NVARCHAR(MAX),
  @p_flag                 NVARCHAR(MAX),
  @p_insert_time          NVARCHAR(MAX),
  @p_release_time         NVARCHAR(MAX),
  @p_is_enable_rel        NVARCHAR(MAX),
  @p_confirm_id           NVARCHAR(MAX),
  @p_confirm_time         NVARCHAR(MAX),
  @p_description          NVARCHAR(MAX),
  @p_isenable             NVARCHAR(MAX),
  @p_ischk                NVARCHAR(MAX),
  @p_next_plan_id         NVARCHAR(MAX),
  @p_release_flag         NVARCHAR(MAX),
  @p_plan_type            NVARCHAR(MAX),
  @p_plan_end_date        NVARCHAR(MAX)


AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type             NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag             NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun            NVARCHAR(MAX) 
	DECLARE @v_user_id              NVARCHAR(MAX)
    DECLARE @v_division_id          NVARCHAR(MAX)
    DECLARE @v_site_id              NVARCHAR(MAX)
    DECLARE @v_factory_id           NVARCHAR(MAX)
    DECLARE @v_instance_id          NVARCHAR(MAX)
    DECLARE @v_plan_date            NVARCHAR(MAX)
    DECLARE @v_plan_id              NVARCHAR(MAX)
    DECLARE @v_flag                 NVARCHAR(MAX)
    DECLARE @v_insert_time          NVARCHAR(MAX)
    DECLARE @v_release_time         NVARCHAR(MAX)
    DECLARE @v_is_enable_rel        NVARCHAR(MAX)
    DECLARE @v_confirm_id           NVARCHAR(MAX)
    DECLARE @v_confirm_time         NVARCHAR(MAX)
    DECLARE @v_description          NVARCHAR(MAX)
    DECLARE @v_isenable             NVARCHAR(MAX)
    DECLARE @v_ischk                NVARCHAR(MAX)
    DECLARE @v_next_plan_id         NVARCHAR(MAX)
    DECLARE @v_release_flag         NVARCHAR(MAX)
    DECLARE @v_plan_type            NVARCHAR(MAX)
    DECLARE @v_plan_end_date        NVARCHAR(MAX)

	DECLARE @recv_active_flag       NVARCHAR(MAX)				    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00590_PLAN_CONTROL_GROUP_RELEASE'
	DECLARE @v_log_type             NVARCHAR(100) = ''
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0
	DECLARE @rtnCount   	        INTEGER = 0

	DECLARE @v_temp1                NVARCHAR(1000)
	DECLARE @v_temp2                NVARCHAR(1000)
	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''
	DECLARE @v_dSql1                NVARCHAR(MAX)=''
	DECLARE @v_dSql2                NVARCHAR(MAX)=''
	DECLARE @v_dSql3                NVARCHAR(MAX)=''

	SET @v_sys_type          = ''
	SET @v_sys_flag          = ''
	SET @v_sys_gubun         = ''
	SET @v_user_id           = ''
    SET @v_division_id       = ''
    SET @v_site_id           = ''
    SET @v_factory_id        = ''
    SET @v_instance_id       = ''
    SET @v_plan_date         = ''
    SET @v_plan_id           = ''
    SET @v_flag              = ''
    SET @v_insert_time       = ''
    SET @v_release_time      = ''
    SET @v_is_enable_rel     = ''
    SET @v_confirm_id        = ''
    SET @v_confirm_time      = ''
    SET @v_description       = ''
    SET @v_isenable          = ''
    SET @v_ischk             = ''
    SET @v_next_plan_id      = ''
    SET @v_release_flag      = ''
    SET @v_plan_type         = ''

	SET @recv_active_flag       = NULL	
	SET @recv_active_flag       = @p_sys_flag
	SET @v_delimiter            = '|'             -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''
	SET	@v_dSql3                = ''
	
	/************************************************************************************************/
	/* Group Release Total팝업경우 :(SELECT_GROUP_RELEASE_TOTAL Select)                             */
	/************************************************************************************************/
    IF(@p_sys_flag ='SELECT_GROUP_RELEASE_TOTAL')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql1 = ''
            SELECT @v_dSql1 += ' SELECT AA.*            ' + char(10)
			SELECT @v_dSql1 += '       ,'''' AS CHK     ' + char(10)
            SELECT @v_dSql1 += '       ,BB.PLAN_ID      ' + char(10)
            SELECT @v_dSql1 += '       ,BB.CONFIRM_ID   ' + char(10)
            SELECT @v_dSql1 += '       ,BB.CONFIRM_TIME ' + char(10)
            SELECT @v_dSql1 += '       ,BB.CONFIRM_FLAG ' + char(10)
            SELECT @v_dSql1 += '       ,BB.DESCRIPTION  ' + char(10)
            SELECT @v_dSql1 += '       ,CASE WHEN R.INSTANCE_ID IS NULL  THEN ''N''     ' + char(10)
            SELECT @v_dSql1 += '             WHEN AA.IS_ENABLE_REL = ''N'' THEN ''N''   ' + char(10)
            SELECT @v_dSql1 += '             WHEN CC.FACTORY_ID IS NOT NULL THEN ''N''  ' + char(10)-- netjob 대기 or 실행중
            SELECT @v_dSql1 += '             ELSE (CASE WHEN (                 ' + char(10)
            SELECT @v_dSql1 += '                     SELECT DISTINCT 1 AS _VAL ' + char(10)
            SELECT @v_dSql1 += '                     FROM   HIS_FP_PLAN_GROUP_DETAIL_H HHH WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '                     WHERE  AA.INSTANCE_ID   = HHH.INSTANCE_ID          ' + char(10)
            SELECT @v_dSql1 += '                     AND    AA.FACTORY_ID    = HHH.PLAN_GROUP_ID        ' + char(10)
            SELECT @v_dSql1 += '                     AND    HHH.PLAN_DATE    = '''+ @p_plan_date +'''   ' + char(10)
            SELECT @v_dSql1 += '                     AND    HHH.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql1 += '                     AND    HHH.PLAN_ID      = '''+ @p_plan_id +'''     ' + char(10)
            SELECT @v_dSql1 += '                   ) IS NULL THEN ''Y'' ELSE ''N'' END) END AS ISENABLE ' + char(10)
            SELECT @v_dSql1 += '       , CASE WHEN BB.PLAN_ID IS NOT NULL AND BB.CONFIRM_FLAG= ''Y'' THEN ''0'' ELSE ''0'' END ISCHK  ' + char(10)
            SELECT @v_dSql1 += '       , '''+ @p_plan_date +''' AS PLAN_DATE ' + char(10)
            --SELECT @v_dSql1 += '       , CASE WHEN '''+ @p_site_id +''' IS NULL OR '''+ @p_site_id +''' = '''' THEN AA.SITE_ID ELSE '''+ @p_site_id +''' END AS SITE_ID   ' + char(10)
            SELECT @v_dSql1 += ' FROM (  ' + char(10)
            SELECT @v_dSql1 += '   	SELECT DISTINCT A.INSTANCE_ID,B.DIVISION_ID,DBO.FN_GETNAME_DIVISION(B.COMPANY_ID,B.DIVISION_ID) AS DIVISION_NAME ' + char(10)
			SELECT @v_dSql1 += '          , ''(''+B.DIVISION_ID+'')''+DBO.FN_GETNAME_DIVISION(B.COMPANY_ID,B.DIVISION_ID) AS DIVISION ' + char(10)
            SELECT @v_dSql1 += '          , C.SEGMENT2 AS FACTORY_ID,C.SEGMENT2 AS FACTORY_NAME ' + char(10)
            SELECT @v_dSql1 += '          , (CASE WHEN C.ATTRIBUTE4 IS NULL OR C.ATTRIBUTE4 = '''' THEN C.SEGMENT2 ELSE C.SEGMENT2 + ''('' + C.ATTRIBUTE4 + '')'' END) AS FACTORY ' + char(10)
            SELECT @v_dSql1 += '          , ''PLAN GROUP'' AS FLAG , D.INSERT_TIME, E.RELEASE_TIME ' + char(10)
            SELECT @v_dSql1 += '          , (CASE WHEN E.RELEASE_TIME IS NULL THEN ''Y''           ' + char(10)
            SELECT @v_dSql1 += '                  WHEN D.INSERT_TIME < E.RELEASE_TIME THEN ''N''   ' + char(10)
            SELECT @v_dSql1 += '                  ELSE ''Y'' END) AS IS_ENABLE_REL                 ' + char(10)
			SELECT @v_dSql1 += '          , B.SITE_ID ' + char(10)
            SELECT @v_dSql1 += '   	FROM FP_INSTANCE_FACTORY_M A WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql1 += '   	INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)        ' + char(10)
            SELECT @v_dSql1 += '   	   ON  A.FACTORY_ID = B.FACTORY_ID             ' + char(10)
            SELECT @v_dSql1 += '   	INNER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '   	   ON  A.INSTANCE_ID = C.SEGMENT1              ' + char(10)
            SELECT @v_dSql1 += ' 	   AND   C.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
            SELECT @v_dSql1 += '     LEFT OUTER JOIN (                                 ' + char(10)
            SELECT @v_dSql1 += '                SELECT MAX(INSERT_TIME) AS INSERT_TIME ' + char(10)
            SELECT @v_dSql1 += '                FROM   SCM_FP_PLAN_H A WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql1 += '                WHERE  A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql1 += '                AND    A.PLAN_ID     = '''+ @p_plan_id +'''     ' + char(10)
            SELECT @v_dSql1 += '     ) D               ' + char(10)
            SELECT @v_dSql1 += '     ON    1=1         ' + char(10)
            SELECT @v_dSql1 += '     LEFT OUTER JOIN ( ' + char(10)
            SELECT @v_dSql1 += '                SELECT B.PLAN_GROUP_ID, MAX(B.RELEASE_TIME) AS RELEASE_TIME ' + char(10)
            SELECT @v_dSql1 += '                FROM   HIS_FP_PLAN_GROUP_DETAIL_H B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '                WHERE  B.PLAN_DATE    = '''+ @p_plan_date +'''   ' + char(10)
            SELECT @v_dSql1 += '                AND    B.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql1 += '                AND    B.RELEASE_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql1 += '                GROUP BY B.PLAN_GROUP_ID      ' + char(10)
            SELECT @v_dSql1 += '     ) E ' + char(10)
            SELECT @v_dSql1 += '     ON    C.SEGMENT2    = E.PLAN_GROUP_ID         ' + char(10)
            SELECT @v_dSql1 += '   	WHERE A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql1 += '     AND   A.ACTIVE_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql1 += '     AND   B.ACTIVE_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql1 += '     AND   C.ACTIVE_FLAG = ''Y'' ' + char(10)
            SELECT @v_dSql1 += ' ) AA ' + char(10)
			SELECT @v_dSql2 = ''
            SELECT @v_dSql2 += ' LEFT OUTER JOIN SCM_FP_PLAN_GROUP_DETAIL_H BB WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += ' ON  AA.INSTANCE_ID = BB.INSTANCE_ID           ' + char(10)
            SELECT @v_dSql2 += ' AND AA.FACTORY_ID  = BB.PLAN_GROUP_ID         ' + char(10)
            SELECT @v_dSql2 += ' AND BB.PLAN_DATE   = '''+ @p_plan_date +'''   ' + char(10)
            SELECT @v_dSql2 += ' AND BB.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql2 += ' -- netjob 체크    ' + char(10)
            SELECT @v_dSql2 += ' LEFT OUTER JOIN ( ' + char(10)
            SELECT @v_dSql2 += '            SELECT DISTINCT PARAMETER1 AS INSTANCE_ID, PARAMETER5 AS FACTORY_ID ' + char(10)
            SELECT @v_dSql2 += '            FROM   FP_NETJOB_QUEUE A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += '            WHERE  1=1 ' + char(10)
            SELECT @v_dSql2 += '            AND    PROC_NAME   = ''PR_SCM_OF_RELEASE_AUTO_PROCESSING'' ' + char(10)
            SELECT @v_dSql2 += '            AND    JOB_TYPE IN (''R'',''P'')              ' + char(10)
            SELECT @v_dSql2 += '            AND    ACTIVE_FLAG = ''Y''                    ' + char(10)
            SELECT @v_dSql2 += '            AND    PARAMETER1  = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql2 += ' ) CC ' + char(10)
            SELECT @v_dSql2 += ' ON  AA.INSTANCE_ID = CC.INSTANCE_ID ' + char(10)
            SELECT @v_dSql2 += ' AND AA.FACTORY_ID  = CC.FACTORY_ID  ' + char(10)
            SELECT @v_dSql2 += ' LEFT OUTER JOIN (                   ' + char(10)
            SELECT @v_dSql2 += '            SELECT DISTINCT R.INSTANCE_ID, R.PLAN_GROUP_ID  ' + char(10)
            SELECT @v_dSql2 += '            FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)       ' + char(10)
            SELECT @v_dSql2 += '            WHERE  R.USER_ID     = '''+ @p_user_id +'''     ' + char(10)
            SELECT @v_dSql2 += '            AND    R.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql2 += '            AND    R.SAVE_FLAG   = ''Y'' ' + char(10)
            SELECT @v_dSql2 += ' ) R ' + char(10)
            SELECT @v_dSql2 += ' ON  AA.INSTANCE_ID = R.INSTANCE_ID   ' + char(10)
            SELECT @v_dSql2 += ' AND AA.FACTORY_ID  = R.PLAN_GROUP_ID ' + char(10)
            SELECT @v_dSql2 += ' WHERE EXISTS (                       ' + char(10)
            SELECT @v_dSql2 += '              SELECT CC.ATTRIBUTE1    ' + char(10)
            SELECT @v_dSql2 += '              FROM   SCM_SYS_LOOKUP_VALUE CC WITH(NOLOCK)   ' + char(10)
            SELECT @v_dSql2 += '              WHERE  AA.INSTANCE_ID = CC.SEGMENT1           ' + char(10)
            SELECT @v_dSql2 += '              AND    AA.FLAG = CC.ATTRIBUTE1                ' + char(10)
            SELECT @v_dSql2 += '              AND    CC.LOOKUP_TYPE_CODE=''INSTANCE_ID''    ' + char(10)
            SELECT @v_dSql2 += '              AND    CC.SEGMENT1 = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql2 += ' ) ' + char(10)

			SELECT @v_dSql =  @v_dSql1 +  @v_dSql2

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
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
				END	
			END
	/************************************************************************************************/
	/* GROUP Release Total팝업경우 :CONFIRM_GROUP_VALIDATION_1(SELECT)                                          */
	/************************************************************************************************/
	ELSE IF(@p_sys_flag ='CONFIRM_GROUP_VALIDATION_1')
		BEGIN --IF(START)
		     SELECT @v_dSql1 = ''
             SELECT @v_dSql1 += ' SELECT * ' + char(10)
             SELECT @v_dSql1 += ' FROM   ( ' + char(10)
             SELECT @v_dSql1 += '         SELECT DISTINCT ' + char(10)
             SELECT @v_dSql1 += '               A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
             SELECT @v_dSql1 += '             , A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LINE_ID, CONVERT(NVARCHAR(6), A.PLAN_DATE, 112) AS MONTH ' + char(10)
             SELECT @v_dSql1 += '             , CASE WHEN C.ACTIVE_FLAG IS NULL THEN N''ITEM_LINE_ASSIGN Noting'' ' + char(10)
             SELECT @v_dSql1 += '                    WHEN C.ACTIVE_FLAG = ''N'' THEN N''ACTIVE_FLAG = N'' ' + char(10)
             SELECT @v_dSql1 += '                    WHEN C.PRIORITY NOT IN ( 1, 2, 3, 4, 5, 6, 7, 8 ) THEN N''PRIORITY CHECK : '' + ISNULL(CONVERT(NVARCHAR, C.PRIORITY), '''') ' + char(10)
			 --SELECT @v_dSql1 += '                    WHEN (A.PLAN_DATE <= A.REL_DATE AND F.EQUIPMENT_ID IS NULL AND A.EQUIP_VALIDATION=''Y'') THEN N''EQUIPMENT  Nothing'' ' + char(10)
			 SELECT @v_dSql1 += '                    WHEN (A.PLAN_DATE <= A.REL_DATE AND F.EQUIPMENT_ID IS NULL AND A.EQUIP_VALIDATION=''Y'' AND (A.INSTANCE_ID NOT LIKE ''%CELL%'' AND A.INSTANCE_ID NOT LIKE ''%PACK%'') ) THEN N''EQUIPMENT  Nothing'' ' + char(10) -- 셀, 팩 설비체크 제외... 20220708
             SELECT @v_dSql1 += '               END  AS ITEM_LINE_ASSIGN_CHECK ' + char(10)
             SELECT @v_dSql1 += '             , CASE WHEN E.KEY_VALUE = ''DAILY_CAPA'' THEN (CASE WHEN D.DAILY_CAPA IS NULL THEN N''Daily Capa Nothing'' WHEN D.DAILY_CAPA <= 0 THEN N''Daily Capa = 0'' END) ' + char(10)
             SELECT @v_dSql1 += '                    WHEN E.KEY_VALUE = ''TACT_TIME'' THEN (CASE WHEN D.TACT_TIME IS NULL THEN N''Tact Time Nothing'' WHEN D.TACT_TIME <= 0 THEN N''Tact Time = 0'' END) ' + char(10)
             SELECT @v_dSql1 += '                    ELSE '''' END AS DAILY_CAPA_CHECK ' + char(10)
             SELECT @v_dSql1 += '             , E.KEY_VALUE ' + char(10)
             SELECT @v_dSql1 += '         FROM (            ' + char(10)
             SELECT @v_dSql1 += '              SELECT A.*, B.REL_DATE, B.EQUIP_VALIDATION ' + char(10)
             SELECT @v_dSql1 += '              FROM   (     ' + char(10)
             SELECT @v_dSql1 += '                      SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
             SELECT @v_dSql1 += '                           , A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql1 += '                           , A.PLAN_DATE , A.OUT_QTY                  ' + char(10)
             SELECT @v_dSql1 += '                      FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK)      ' + char(10)
             SELECT @v_dSql1 += '                      WHERE  A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
             SELECT @v_dSql1 += '                      AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''     ' + char(10)
             SELECT @v_dSql1 += '                      AND    A.OUT_QTY > 0 ' + char(10)
             SELECT @v_dSql1 += '                      UNION ALL            ' + char(10)
             SELECT @v_dSql1 += '                      SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
             SELECT @v_dSql1 += '                           , A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql1 += '                           , A.PLAN_DATE ' + char(10)
             SELECT @v_dSql1 += '                           , A.OUT_QTY   ' + char(10)
             SELECT @v_dSql1 += '                      FROM   FP_AMEND_PLAN_PACK_R A WITH(NOLOCK)      ' + char(10)
             SELECT @v_dSql1 += '                      WHERE  A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
             SELECT @v_dSql1 += '                      AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''     ' + char(10)
             SELECT @v_dSql1 += '                      AND    A.OUT_QTY > 0 ' + char(10)
			 -- 활성화 테이블 추가... 20240502
             SELECT @v_dSql1 += '                      UNION ALL ' + char(10)
             SELECT @v_dSql1 += '                    SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
             SELECT @v_dSql1 += '                           , A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql1 += '                           , A.PLAN_DATE ' + char(10)
             SELECT @v_dSql1 += '                           , A.OUT_QTY   ' + char(10)
             SELECT @v_dSql1 += '                      FROM   FP_AMEND_PLAN_FORM_R A WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql1 += '                      WHERE  A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
             SELECT @v_dSql1 += '                      AND    A.FP_PLAN_ID  = '''+ @p_plan_id +''' ' + char(10)
             SELECT @v_dSql1 += '                      AND    A.OUT_QTY > 0 ' + char(10)
             SELECT @v_dSql1 += '                      UNION ALL            ' + char(10)
             SELECT @v_dSql1 += '                      SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
             SELECT @v_dSql1 += '                           , A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' + char(10)
             SELECT @v_dSql1 += '                           , A.ADJUST_OUT_QTY_BATCH AS OUT_QTY        ' + char(10)
             SELECT @v_dSql1 += '                      FROM   FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK)     ' + char(10)
             SELECT @v_dSql1 += '                      WHERE  A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
             SELECT @v_dSql1 += '                      AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''     ' + char(10)
             SELECT @v_dSql1 += '                      AND    A.ADJUST_OUT_QTY_BATCH > 0               ' + char(10)
             SELECT @v_dSql1 += '               ) A, ( ' + char(10)
             SELECT @v_dSql1 += '                     SELECT DISTINCT  C.FACTORY_ID, C.LINE_ID, C.OPERATION_ID, C.ELECTRODE_TYPE      ' + char(10)
             SELECT @v_dSql1 += '                          , DATEADD(DAY, RELEASR_TERM, CONVERT(DATE, A.PLAN_START_TIME)) AS REL_DATE ' + char(10)
             SELECT @v_dSql1 += '                          , B.EQUIP_VALIDATION ' + char(10)
             SELECT @v_dSql1 += '                     FROM   SCM_FP_PLAN_H A    ' + char(10)
             SELECT @v_dSql1 += '                          , (                  ' + char(10)
             SELECT @v_dSql1 += '                               SELECT A.SEGMENT1     AS INSTANCE_ID, A.ATTRIBUTE1   AS PLAN_CATEGORY ' + char(10)
             SELECT @v_dSql1 += '                                  , B.SEGMENT2     AS FACTORY_ID, C.SEGMENT2     AS PLAN_GROUP       ' + char(10)
             SELECT @v_dSql1 += '                                  , CONVERT(INT, ISNULL(B.SEGMENT3, C.SEGMENT3))     AS RELEASR_TERM ' + char(10)
             SELECT @v_dSql1 += '                                  , ISNULL(B.SEGMENT5, C.ATTRIBUTE3) AS EQUIP_VALIDATION             ' + char(10)
             SELECT @v_dSql1 += '                               FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                 ' + char(10)
             SELECT @v_dSql1 += '                                      LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql1 += '                                          ON    B.LOOKUP_TYPE_CODE  = ''INSTANCE_FACTORY_RELEASE_TERM'' ' + char(10)
             SELECT @v_dSql1 += '                                          AND   B.SEGMENT1          = A.SEGMENT1          ' + char(10)
             SELECT @v_dSql1 += '                                          AND   A.ATTRIBUTE1        = ''BUILDING''        ' + char(10)
             SELECT @v_dSql1 += '                                          AND   B.ACTIVE_FLAG       = ''Y''               ' + char(10)
             SELECT @v_dSql1 += '         LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql1 += '                                          ON    C.LOOKUP_TYPE_CODE  = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
             SELECT @v_dSql1 += '                                          AND   C.SEGMENT1          = A.SEGMENT1     ' + char(10)
             SELECT @v_dSql1 += '                                          AND   A.ATTRIBUTE1        = ''PLAN GROUP'' ' + char(10)
             SELECT @v_dSql1 += '                                          AND   C.ACTIVE_FLAG       = ''Y''          ' + char(10)
             SELECT @v_dSql1 += '                               WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''           ' + char(10)
             SELECT @v_dSql1 += '                               AND    A.SEGMENT1         = '''+ @p_instance_id +'''  ' + char(10)
             SELECT @v_dSql1 += '                           ) B             ' + char(10)
             SELECT @v_dSql1 += '                          , SCM_LINE_M   C ' + char(10)
             SELECT @v_dSql1 += '                      WHERE  A.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
             SELECT @v_dSql1 += '                      AND    A.PLAN_ID      = '''+ @p_plan_id +'''     ' + char(10)
             SELECT @v_dSql1 += '                      AND   ( ( B.PLAN_CATEGORY  = ''BUILDING'' AND B.FACTORY_ID  = C.FACTORY_ID )     ' + char(10)
             SELECT @v_dSql1 += '                               OR ( B.PLAN_CATEGORY != ''BUILDING'' AND B.PLAN_GROUP  = C.MODEL_TYPE ) ' + char(10)
             SELECT @v_dSql1 += '                            ) ' + char(10)
             SELECT @v_dSql1 += '              ) B             ' + char(10)
             SELECT @v_dSql1 += '              WHERE  A.FACTORY_ID     = B.FACTORY_ID     ' + char(10)
             SELECT @v_dSql1 += '              AND    A.LINE_ID        = B.LINE_ID        ' + char(10)
             SELECT @v_dSql1 += '              AND    A.OPERATION_ID   = B.OPERATION_ID   ' + char(10)
             SELECT @v_dSql1 += '              AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql1 += '              --AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @p_plan_date +''' AND (CONVERT(VARCHAR, CONVERT(DATETIME,'''+ @p_plan_date +''') + (SELECT ISNULL(A.ATTRIBUTE15,''10'')*7 FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) WHERE A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' AND A.SEGMENT1 = '''+ @p_instance_id +''') ,112)) ' + char(10)
             SELECT @v_dSql1 += '              AND   A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_plan_end_date +''') -- end date 조건 변경... 20210518 으로 변경됨 ' + char(10)
			 SELECT @v_dSql1 += '         ) A ' + char(10)
			 SELECT @v_dSql2  = ''
             SELECT @v_dSql2 += '         LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql2 += '         ON     C.COMPANY_ID      = A.COMPANY_ID     ' + char(10)
             SELECT @v_dSql2 += '         AND    C.DIVISION_ID     = A.DIVISION_ID    ' + char(10)
             SELECT @v_dSql2 += '         AND    C.SITE_ID         = A.SITE_ID        ' + char(10)
             SELECT @v_dSql2 += '         AND    C.PLANT_ID        = A.PLANT_ID       ' + char(10)
             SELECT @v_dSql2 += '         AND    C.ITEM_ID         = A.ITEM_ID        ' + char(10)
             SELECT @v_dSql2 += '         AND    C.FACTORY_ID      = A.FACTORY_ID     ' + char(10)
             SELECT @v_dSql2 += '         AND    C.LINE_ID         = A.LINE_ID        ' + char(10)
             SELECT @v_dSql2 += '         AND    C.OPERATION_ID    = A.OPERATION_ID   ' + char(10)
             SELECT @v_dSql2 += '         AND    C.ELECTRODE_TYPE  = A.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql2 += '         AND    C.MONTH           = CONVERT(NVARCHAR(6), A.PLAN_DATE, 112) ' + char(10)
             SELECT @v_dSql2 += '    LEFT OUTER JOIN SCM_TACT_TIME_M D WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql2 += '         ON     D.COMPANY_ID      = A.COMPANY_ID     ' + char(10)
             SELECT @v_dSql2 += '         AND    D.DIVISION_ID     = A.DIVISION_ID    ' + char(10)
             SELECT @v_dSql2 += '         AND    D.SITE_ID         = A.SITE_ID        ' + char(10)
             SELECT @v_dSql2 += '         AND    D.PLANT_ID        = A.PLANT_ID       ' + char(10)
             SELECT @v_dSql2 += '         AND    D.ITEM_ID         = A.ITEM_ID        ' + char(10)
             SELECT @v_dSql2 += '         AND    D.FACTORY_ID      = A.FACTORY_ID     ' + char(10)
             SELECT @v_dSql2 += '         AND    D.LINE_ID         = A.LINE_ID        ' + char(10)
             SELECT @v_dSql2 += '         AND    D.OPERATION_ID    = A.OPERATION_ID   ' + char(10)
             SELECT @v_dSql2 += '         AND    D.ELECTRODE_TYPE  = A.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql2 += '         AND    D.MONTH           = CONVERT(NVARCHAR(6), A.PLAN_DATE, 112) ' + char(10)
             SELECT @v_dSql2 += '         INNER JOIN SCM_LINE_M B WITH(NOLOCK)       ' + char(10)
             SELECT @v_dSql2 += '         ON     A.FACTORY_ID     = B.FACTORY_ID     ' + char(10)
             SELECT @v_dSql2 += '         AND    A.LINE_ID        = B.LINE_ID        ' + char(10)
             SELECT @v_dSql2 += '         AND    A.OPERATION_ID   = B.OPERATION_ID   ' + char(10)
             SELECT @v_dSql2 += '         AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql2 += '         LEFT OUTER JOIN FP_INSTANCE_CONFIG_M E WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql2 += '         ON     A.INSTANCE_ID    = E.INSTANCE_ID        ' + char(10)
             SELECT @v_dSql2 += '         AND    E.KEY_ID         = ''FINAL_OP_CAPA''    ' + char(10)
             SELECT @v_dSql2 += '         LEFT OUTER JOIN SCM_EQUIPMENT_M F WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql2 += '         ON     F.COMPANY_ID      = B.COMPANY_ID     ' + char(10)
             SELECT @v_dSql2 += '         AND    F.DIVISION_ID     = B.DIVISION_ID    ' + char(10)
             SELECT @v_dSql2 += '         AND    F.SITE_ID         = B.SITE_ID        ' + char(10)
             SELECT @v_dSql2 += '         AND    F.PLANT_ID        = B.PLANT_ID       ' + char(10)
             SELECT @v_dSql2 += '         AND    F.FACTORY_ID      = B.FACTORY_ID     ' + char(10)
             SELECT @v_dSql2 += '         AND    F.LINE_ID         = B.LINE_ID        ' + char(10)
             SELECT @v_dSql2 += '         AND    F.OPERATION_ID    = B.OPERATION_ID   ' + char(10)
             SELECT @v_dSql2 += '         AND    F.ELECTRODE_TYPE  = B.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql2 += '         AND    F.ACTIVE_FLAG     = ''Y''            ' + char(10)
             SELECT @v_dSql2 += '         AND    F.EQUIPMENT_TYPE  = ''M''            ' + char(10)
             SELECT @v_dSql2 += '         WHERE  A.INSTANCE_ID    = '''+ @p_instance_id +''' ' + char(10)
             SELECT @v_dSql2 += '         AND    A.FP_PLAN_ID     = '''+ @p_plan_id +'''     ' + char(10)
             SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.MODEL_TYPE' , 'EQ', @p_factory_id))    + char(10)
             SELECT @v_dSql2 += ' ) A ' + char(10)
             SELECT @v_dSql2 += ' WHERE  ITEM_LINE_ASSIGN_CHECK IS NOT NULL ' + char(10)
             SELECT @v_dSql2 += ' OR     DAILY_CAPA_CHECK       IS NOT NULL ' + char(10)
             SELECT @v_dSql2 += ' ORDER BY DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LINE_ID, MONTH ' + char(10)

			 SELECT @v_dSql = @v_dSql1 + @v_dSql2 

			IF @p_sys_type = 'SQL'
				BEGIN
					--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
				END
	    END	--IF( END )
    /************************************************************************************************/
	/* Group Release Total팝업경우 :(CONFIRM_GROUP_VALIDATION_2 Select)                                            */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='CONFIRM_GROUP_VALIDATION_2')
	    BEGIN --ELSE IF(START)
		     SELECT @v_dSql1 =''
             SELECT @v_dSql1 += ' SELECT DISTINCT A.ITEM_SEQ, A.INSTANCE_ID, A.FP_PLAN_ID    ' + char(10)
             SELECT @v_dSql1 += '      , DENSE_RANK() OVER (ORDER BY A.ITEM_ID, A.FACTORY_ID ' + char(10)
             SELECT @v_dSql1 += '                , A.LINE_ID, A.OPERATION_ID, ISNULL(A.CHILD_ITEM_ID, ''-'')) AS SEQ ' + char(10)
             SELECT @v_dSql1 += '      , A.ITEM_ID, ISNULL(A.CHILD_ITEM_ID, ''-'') AS CHILD_ITEM_ID    ' + char(10)
             SELECT @v_dSql1 += '      , A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.CHILD_OPERATION_ID ' + char(10)
             SELECT @v_dSql1 += '      , A.CHILD_ELECTRODE_TYPE, A.PLAN_MONTH, A.PROBLEM_TABLE         ' + char(10)
             SELECT @v_dSql1 += '      , A.PROBLEM_DESCRIPTION ' + char(10)
             SELECT @v_dSql1 += ' FROM   (                     ' + char(10)
             SELECT @v_dSql1 += '          SELECT A.INSTANCE_ID, A.FP_PLAN_ID, A.ITEM_ID   ' + char(10)
             SELECT @v_dSql1 += '               , A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID  ' + char(10)
             SELECT @v_dSql1 += '               , B.CHILD_ITEM_ID, A.PLAN_MONTH            ' + char(10)
             SELECT @v_dSql1 += '               , C.OPERATION_ID AS CHILD_OPERATION_ID     ' + char(10)
             SELECT @v_dSql1 += '               , C.ELECTRODE_TYPE AS CHILD_ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql1 += '               , C.PRIORITY, C.ACTIVE_FLAG                ' + char(10)
             SELECT @v_dSql1 += '               , CASE WHEN B.CHILD_ITEM_ID IS NULL          THEN ''SCM_BOM_M''                  ' + char(10)
             SELECT @v_dSql1 += '                      WHEN C.ITEM_ID IS NULL                THEN ''SCM_ITEM_LINE_ASSIGN_M''     ' + char(10)
             SELECT @v_dSql1 += '                      WHEN ISNULL(C.ACTIVE_FLAG, ''N'') = ''N'' THEN ''SCM_ITEM_LINE_ASSIGN_M'' ' + char(10)
             SELECT @v_dSql1 += '                      WHEN ISNULL(C.PRIORITY,    0) NOT IN ( 1, 2, 3, 4, 5, 6, 7, 8 )           ' + char(10)
             SELECT @v_dSql1 += '                                                            THEN ''SCM_ITEM_LINE_ASSIGN_M''     ' + char(10)
			 --SELECT @v_dSql1 += '                      WHEN D.EQUIPMENT_ID  IS NULL          THEN ''SCM_EQUIPMENT_M''            ' + char(10)
			 SELECT @v_dSql1 += '                      WHEN D.EQUIPMENT_ID  IS NULL AND (A.INSTANCE_ID NOT LIKE ''%CELL%'' AND A.INSTANCE_ID NOT LIKE ''%PACK%'') THEN ''SCM_EQUIPMENT_M'' ' + char(10) -- 셀, 팩 설비체크 제외... 20220708
             SELECT @v_dSql1 += '                 END  PROBLEM_TABLE ' + char(10)
             SELECT @v_dSql1 += '               , CASE WHEN B.CHILD_ITEM_ID IS NULL          THEN ''Not Exists Data'' ' + char(10)
             SELECT @v_dSql1 += '                      WHEN C.ITEM_ID IS NULL                THEN ''Not Exists Data'' ' + char(10)
             SELECT @v_dSql1 += '                      WHEN ISNULL(C.ACTIVE_FLAG, ''N'') = ''N'' THEN ''Checking data of ACTIVE_FLAG : '' + ISNULL(C.ACTIVE_FLAG, ''NULL'') ' + char(10)
             SELECT @v_dSql1 += '                      WHEN ISNULL(C.PRIORITY,    0) NOT IN ( 1, 2, 3, 4, 5, 6, 7, 8 ) ' + char(10)
             SELECT @v_dSql1 += '                                                            THEN ''PRIORITY CHECK : '' + ISNULL(CONVERT(NVARCHAR, C.PRIORITY), ''NULL'') ' + char(10)
			 --SELECT @v_dSql1 += '                      WHEN D.EQUIPMENT_ID  IS NULL          THEN ''Not Exists Data'' ' + char(10)
			 SELECT @v_dSql1 += '                      WHEN D.EQUIPMENT_ID  IS NULL AND (A.INSTANCE_ID NOT LIKE ''%CELL%'' AND A.INSTANCE_ID NOT LIKE ''%PACK%'') THEN ''Not Exists Data'' ' + char(10) -- 셀, 팩 설비체크 제외... 20220708
             SELECT @v_dSql1 += '                 END  AS PROBLEM_DESCRIPTION ' + char(10)
             SELECT @v_dSql1 += '               , DENSE_RANK() OVER (PARTITION BY A.PLAN_DATE, A.ITEM_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, B.ALT_ID ' + char(10)
             SELECT @v_dSql1 += '                    ORDER BY CASE WHEN ISNULL(C.PRIORITY, 99) IN ( 1, 2, 3, 4, 5, 6, 7, 8 ) THEN 1 ELSE 9 END, ISNULL(B.ALT_PRIORITY, 99)/*, ISNULL(B.CHILD_ITEM_ID, ''ZZZZ'')*/ ) ITEM_SEQ ' + char(10)
             SELECT @v_dSql1 += '          FROM ( ' + char(10)
             SELECT @v_dSql1 += '             SELECT INSTANCE_ID, FP_PLAN_ID ' + char(10)
             SELECT @v_dSql1 += '                  , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, A.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql1 += '                  , CONVERT(NVARCHAR(6), A.PLAN_DATE, 112) AS PLAN_MONTH ' + char(10)
             SELECT @v_dSql1 += '                  , A.PLAN_DATE                               ' + char(10)
             SELECT @v_dSql1 += '             FROM   FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK)      ' + char(10)
             SELECT @v_dSql1 += '             WHERE  A.INSTANCE_ID = '''+ @p_instance_id +'''  ' + char(10)
             SELECT @v_dSql1 += '             AND    A.FP_PLAN_ID  = '''+ @p_plan_id +'''      ' + char(10)
             SELECT @v_dSql1 += '             AND    A.ADJUST_OUT_QTY_BATCH > 0                ' + char(10)
             SELECT @v_dSql1 += '             AND    A.INSTANCE_ID LIKE ''%E_PRE%''            ' + char(10)
             SELECT @v_dSql1 += '             -- AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_plan_date +''') + CONVERT(NUMERIC, (SELECT ISNULL(A.ATTRIBUTE15,''10'')*7 FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) WHERE A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' AND A.SEGMENT1 = '''+ @p_instance_id +''')) ' + char(10)
             SELECT @v_dSql1 += '             AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,'''+ @p_plan_date +''') AND CONVERT(DATETIME,'''+ @p_plan_end_date +''') -- end date 조건 변경... 20210518 으로 변경됨 ' + char(10)
			 SELECT @v_dSql1 += '             GROUP BY INSTANCE_ID, FP_PLAN_ID ' + char(10)
             SELECT @v_dSql1 += '                    , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID, ITEM_ID, A.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql1 += '                    , CONVERT(NVARCHAR(6), A.PLAN_DATE, 112), A.PLAN_DATE ' + char(10)
             SELECT @v_dSql1 += '          ) A ' + char(10)
			 SELECT @v_dSql2  = ''
             SELECT @v_dSql2 += '          LEFT OUTER JOIN ( ' + char(10)
             SELECT @v_dSql2 += '               SELECT DISTINCT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID ' + char(10)
             SELECT @v_dSql2 += '                     ,AA.PLANT_ID ,AA.PARENT_ITEM_ID ,AA.CHILD_ITEM_ID   ' + char(10)
             SELECT @v_dSql2 += '                     ,AA.ALT_PRIORITY ,AA.ALT_ID ,AA.EFF_START_DATE      ' + char(10)
             SELECT @v_dSql2 += '                     ,AA.EFF_END_DATE             ' + char(10)
             SELECT @v_dSql2 += '               FROM   SCM_BOM_M AA WITH(NOLOCK),  ' + char(10)
             SELECT @v_dSql2 += '               SCM_ITEM_M        CC WITH(NOLOCK), ' + char(10)
             SELECT @v_dSql2 += '               SCM_ITEM_CLASS_M  DD WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql2 += '               WHERE  AA.COMPANY_ID      = CC.COMPANY_ID  ' + char(10)
             SELECT @v_dSql2 += '               AND    AA.DIVISION_ID     = CC.DIVISION_ID ' + char(10)
             SELECT @v_dSql2 += '               AND    AA.SITE_ID         = CC.SITE_ID     ' + char(10)
             SELECT @v_dSql2 += '               AND    AA.CHILD_ITEM_ID   = CC.ITEM_ID     ' + char(10)
             SELECT @v_dSql2 += '               AND    CC.ACTIVE_FLAG     = ''Y''          ' + char(10)
             SELECT @v_dSql2 += '               AND    CC.ITEM_CLASS      = DD.CLASS_ID    ' + char(10)
             SELECT @v_dSql2 += '               AND    DD.USE_FLAG        = ''Y''          ' + char(10)
             SELECT @v_dSql2 += '               AND    AA.ACTIVE_FLAG     = ''Y''          ' + char(10)
             SELECT @v_dSql2 += '               AND    AA.BOM_VERSION_ID  = ''1''          ' + char(10)
             SELECT @v_dSql2 += '               AND    AA.EFF_END_DATE    >  CONVERT(DATE, GETDATE()) ' + char(10)
             SELECT @v_dSql2 += '               AND    DD.LEVEL_2_NAME LIKE ''SLURRY''                ' + char(10)
             SELECT @v_dSql2 += '               AND    DD.CLASS_ID NOT IN ( ''ES01'', ''ES0101'' )    ' + char(10)
             SELECT @v_dSql2 += '          ) B ' + char(10)
             SELECT @v_dSql2 += '          ON     A.COMPANY_ID  = B.COMPANY_ID     ' + char(10)
             SELECT @v_dSql2 += '          AND    A.DIVISION_ID = B.DIVISION_ID    ' + char(10)
             SELECT @v_dSql2 += '          AND    A.SITE_ID     = B.SITE_ID        ' + char(10)
             SELECT @v_dSql2 += '          AND    A.PLANT_ID    = B.PLANT_ID       ' + char(10)
             SELECT @v_dSql2 += '          AND    A.ITEM_ID     = B.PARENT_ITEM_ID ' + char(10)
             SELECT @v_dSql2 += '          AND    B.EFF_START_DATE <= A.PLAN_DATE  ' + char(10)
             SELECT @v_dSql2 += '          AND    B.EFF_END_DATE   > A.PLAN_DATE   ' + char(10)
             SELECT @v_dSql2 += '          LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql2 += '          ON     C.COMPANY_ID  = A.COMPANY_ID    ' + char(10)
             SELECT @v_dSql2 += '          AND    C.DIVISION_ID = A.DIVISION_ID   ' + char(10)
             SELECT @v_dSql2 += '          AND    C.SITE_ID     = A.SITE_ID       ' + char(10)
             SELECT @v_dSql2 += '          AND    C.PLANT_ID    = A.PLANT_ID      ' + char(10)
             SELECT @v_dSql2 += '          AND    C.ITEM_ID     = B.CHILD_ITEM_ID ' + char(10)
             SELECT @v_dSql2 += '          AND    C.FACTORY_ID  = A.FACTORY_ID    ' + char(10)
             SELECT @v_dSql2 += '          AND    C.LINE_ID     = A.LINE_ID       ' + char(10)
             SELECT @v_dSql2 += '          AND    C.MONTH       = A.PLAN_MONTH    ' + char(10)
             SELECT @v_dSql2 += '          LEFT OUTER JOIN SCM_EQUIPMENT_M D WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql2 += '          ON     1=1                                  ' + char(10)
             SELECT @v_dSql2 += '          AND    D.COMPANY_ID      = C.COMPANY_ID     ' + char(10)
             SELECT @v_dSql2 += '          AND    D.DIVISION_ID     = C.DIVISION_ID    ' + char(10)
             SELECT @v_dSql2 += '          AND    D.SITE_ID         = C.SITE_ID        ' + char(10)
             SELECT @v_dSql2 += '          AND    D.PLANT_ID        = C.PLANT_ID       ' + char(10)
             SELECT @v_dSql2 += '          AND    D.FACTORY_ID      = C.FACTORY_ID     ' + char(10)
             SELECT @v_dSql2 += '          AND    D.LINE_ID         = C.LINE_ID        ' + char(10)
             SELECT @v_dSql2 += '          AND    D.OPERATION_ID    = C.OPERATION_ID   ' + char(10)
             SELECT @v_dSql2 += '          AND    D.ELECTRODE_TYPE  = C.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql2 += '          AND    D.ACTIVE_FLAG     = ''Y''            ' + char(10)
             SELECT @v_dSql2 += '          AND    D.EQUIPMENT_TYPE  = ''M''            ' + char(10)
             SELECT @v_dSql2 += '          INNER JOIN SCM_LINE_M E WITH(NOLOCK)        ' + char(10)
             SELECT @v_dSql2 += '          ON     A.FACTORY_ID      = E.FACTORY_ID     ' + char(10)
             SELECT @v_dSql2 += '          AND    A.LINE_ID         = E.LINE_ID        ' + char(10)
             SELECT @v_dSql2 += '          AND    A.OPERATION_ID    = E.OPERATION_ID   ' + char(10)
             SELECT @v_dSql2 += '          AND    A.ELECTRODE_TYPE  = E.ELECTRODE_TYPE ' + char(10)
             SELECT @v_dSql2 += '          WHERE  1=1 ' + char(10)
             SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('E.MODEL_TYPE' , 'EQ', @p_factory_id))    + char(10)
             SELECT @v_dSql2 += ' ) A                ' + char(10)
             SELECT @v_dSql2 += ' WHERE ITEM_SEQ = 1 ' + char(10)
             SELECT @v_dSql2 += ' AND   PROBLEM_DESCRIPTION  IS NOT NULL ' + char(10)

			 SELECT @v_dSql = @v_dSql1 + @v_dSql2

			IF @p_sys_type = 'SQL'
				BEGIN
					--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
					SELECT @v_dSql as [QUERY_VALUE]

				END  
			ELSE 
				BEGIN
					SET @runstart = GetDate()
					--쿼리실행
					EXEC sp_executesql @v_dSql

					SET @runend = GetDate()
					EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
				END	
		END
    /************************************************************************************************/
	/* Group Release Total팝업경우 :(RELEASE_GROUP_VALIDATION_1 Select)                                           */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='RELEASE_GROUP_VALIDATION_1')
	    BEGIN
		     SELECT @v_dSql1 = ''
             SELECT @v_dSql1 += ' WITH TARGET_PLAN AS ' + char(10)
             SELECT @v_dSql1 += ' ( ' + char(10)
/*
             --SELECT @v_dSql1 += '      SELECT INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID , RELEASE_PLAN_ID PLAN_ID, AMEND_PLAN_ID BASIS_PLAN_ID, SLV.ATTRIBUTE1 AS UI_TYPE ' + char(10)
             SELECT @v_dSql1 += '      SELECT INSTANCE_ID' + char(10)
             SELECT @v_dSql1 += '      , (CASE WHEN SLV2.AMEND_LIMIT_YN = ''Y'' THEN SLV2.AMEND_LIMIT_DATE ELSE INSTANCE_DATE END) AS INSTANCE_DATE ' + char(10)  -- release validation block 로직 추가... 20230622
             SELECT @v_dSql1 += '      , DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID , RELEASE_PLAN_ID PLAN_ID, AMEND_PLAN_ID BASIS_PLAN_ID, SLV.ATTRIBUTE1 AS UI_TYPE ' + char(10)
             SELECT @v_dSql1 += '           , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID  ORDER BY INSERT_TIME DESC ) NUMS ' + char(10)
             SELECT @v_dSql1 += '           , SLV2.AMEND_LIMIT_YN, SLV2.AMEND_LIMIT_DATE  ' + char(10) -- release validation block 로직 추가... 20230622
             SELECT @v_dSql1 += '      FROM   FP_RELEASE_PLAN_INFO_H H WITH(NOLOCK)    ' + char(10)
									   -- release validation block 로직 추가... 20230622
             SELECT @v_dSql1 += '      LEFT OUTER JOIN ( ' + char(10)
             SELECT @v_dSql1 += '			SELECT SLV2.SEGMENT1 AS REL_INST, SLV2.SEGMENT2 AS REL_FACT ' + char(10)
             SELECT @v_dSql1 += '			     , SLV2.ATTRIBUTE7 AS AMEND_LIMIT_YN, SLV2.ATTRIBUTE8 AS AMEND_LIMIT_DATE ' + char(10)
             SELECT @v_dSql1 += '			FROM   SCM_SYS_LOOKUP_VALUE  SLV2 WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql1 += '			WHERE  1=1 ' + char(10)
             SELECT @v_dSql1 += '			AND    SLV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
             SELECT @v_dSql1 += '			AND    SLV2.ACTIVE_FLAG = ''Y'' ' + char(10)
             SELECT @v_dSql1 += '			AND    SLV2.SEGMENT1 = ''' + @p_instance_id + ''' ' + char(10)
			 SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SLV2.SEGMENT2' , 'EQ', @p_factory_id))    + char(10)
             SELECT @v_dSql1 += ' ) SLV2 ' + char(10)
             SELECT @v_dSql1 += '      ON  1=1 ' + char(10)
             SELECT @v_dSql1 += '      AND H.INSTANCE_ID   = SLV2.REL_INST ' + char(10)
             SELECT @v_dSql1 += '      AND H.PLAN_GROUP_ID = SLV2.REL_FACT ' + char(10)

             SELECT @v_dSql1 += '           , SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)   ' + char(10)
             SELECT @v_dSql1 += '      WHERE  INSTANCE_ID   = '''+ @p_instance_id +''' ' + char(10)
             SELECT @v_dSql1 += '      AND    INSTANCE_DATE = '''+ @p_plan_date +'''   ' + char(10)
			 SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PLAN_GROUP_ID' , 'EQ', @p_factory_id))    + char(10)
             SELECT @v_dSql1 += '      AND    SLV.LOOKUP_TYPE_CODE = ''INSTANCE AMEND UI''  ' + char(10)
             SELECT @v_dSql1 += '      AND    SLV.SEGMENT1 = H.INSTANCE_ID                  ' + char(10)
*/
             -- [E20241218-001011]수량이 부적합하다고 릴리즈 불가현상 확인 요청 : release wo limit 구간 로직 수정 - RELEASE_TERM 이 LIMTE DATE 보다 이전 구간일 경우, RELEASE_TERM 기준으로 체크되도록 수정... 20241218
             SELECT @v_dSql1 += '      SELECT A.INSTANCE_ID ' + char(10)
             SELECT @v_dSql1 += '           , CASE WHEN A.AMEND_LIMIT_YN = ''Y'' THEN (CASE WHEN A.PLAN_DATE > A.AMEND_LIMIT_DATE AND A.INSTANCE_DATE < A.AMEND_LIMIT_DATE THEN A.AMEND_LIMIT_DATE ELSE A.PLAN_DATE END) ' + char(10)
             SELECT @v_dSql1 += '      	        ELSE A.PLAN_DATE END AS INSTANCE_DATE ' + char(10)
             SELECT @v_dSql1 += '           , A.DIVISION_ID, A.FACTORY_ID, A.PLAN_GROUP_ID, A.PLAN_ID, A.BASIS_PLAN_ID ' + char(10)
             SELECT @v_dSql1 += '           , A.UI_TYPE, A.NUMS ' + char(10)
             SELECT @v_dSql1 += '           , A.AMEND_LIMIT_YN, A.AMEND_LIMIT_DATE ' + char(10)
             SELECT @v_dSql1 += '      FROM ( ' + char(10)
             SELECT @v_dSql1 += '      	  SELECT INSTANCE_ID ' + char(10)
             SELECT @v_dSql1 += '      		   , CONVERT(DATETIME, INSTANCE_DATE) AS INSTANCE_DATE ' + char(10)
             SELECT @v_dSql1 += '      		   , DATEADD( DD, CONVERT(NUMERIC(5),RELEASE_TERM), INSTANCE_DATE) AS PLAN_DATE ' + char(10)
             SELECT @v_dSql1 += '      	       , DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID , RELEASE_PLAN_ID PLAN_ID, AMEND_PLAN_ID BASIS_PLAN_ID, SLV.ATTRIBUTE1 AS UI_TYPE ' + char(10)
             SELECT @v_dSql1 += '      		   , ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID, FACTORY_ID, PLAN_GROUP_ID  ORDER BY INSERT_TIME DESC ) NUMS ' + char(10)
             SELECT @v_dSql1 += '      		   , SLV2.AMEND_LIMIT_YN, CONVERT(DATETIME, SLV2.AMEND_LIMIT_DATE) AS AMEND_LIMIT_DATE ' + char(10)
             SELECT @v_dSql1 += '      	  FROM   FP_RELEASE_PLAN_INFO_H H WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql1 += '      	  LEFT OUTER JOIN ( ' + char(10)
             SELECT @v_dSql1 += '      			SELECT SLV2.SEGMENT1 AS REL_INST, SLV2.SEGMENT2 AS REL_FACT, SLV2.SEGMENT3 AS RELEASE_TERM ' + char(10)
             SELECT @v_dSql1 += '      				 , SLV2.ATTRIBUTE7 AS AMEND_LIMIT_YN, SLV2.ATTRIBUTE8 AS AMEND_LIMIT_DATE ' + char(10)
             SELECT @v_dSql1 += '      			FROM   SCM_SYS_LOOKUP_VALUE  SLV2 WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql1 += '      			WHERE  1=1 ' + char(10)
             SELECT @v_dSql1 += '      			AND    SLV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
             SELECT @v_dSql1 += '      			AND    SLV2.ACTIVE_FLAG = ''Y'' ' + char(10)
             SELECT @v_dSql1 += '      			AND    SLV2.SEGMENT1 = ''' + @p_instance_id + ''' ' + char(10)
			 SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SLV2.SEGMENT2' , 'EQ', @p_factory_id))    + char(10)
             SELECT @v_dSql1 += '      	  ) SLV2 ' + char(10)
             SELECT @v_dSql1 += '      	  ON  1=1 ' + char(10)
             SELECT @v_dSql1 += '      	  AND H.INSTANCE_ID   = SLV2.REL_INST ' + char(10)
             SELECT @v_dSql1 += '      	  AND H.PLAN_GROUP_ID = SLV2.REL_FACT ' + char(10)
             SELECT @v_dSql1 += '      		   , SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql1 += '      	  WHERE  INSTANCE_ID   = ''' + @p_instance_id + ''' ' + char(10)
             SELECT @v_dSql1 += '      	  AND    INSTANCE_DATE = ''' + @p_plan_date + '''   ' + char(10)
			 SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PLAN_GROUP_ID' , 'EQ', @p_factory_id))    + char(10)
             SELECT @v_dSql1 += '      	  AND    SLV.LOOKUP_TYPE_CODE = ''INSTANCE AMEND UI''  ' + char(10)
             SELECT @v_dSql1 += '      	  AND    SLV.SEGMENT1 = H.INSTANCE_ID ' + char(10)
             SELECT @v_dSql1 += '      ) A ' + char(10)

			 SELECT @v_dSql1 += ' )  ' + char(10)
             SELECT @v_dSql1 += ' SELECT PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, MAKE_DATE, PLAN_ID  ' + char(10)
             SELECT @v_dSql1 += '    , SUM(case when groups = ''ERP'' then make_qty else 0 end) ''ERP''   ' + char(10)
             SELECT @v_dSql1 += '    , SUM(case when groups = ''MES'' then make_qty else 0 end)  ''MES''   ' + char(10)
             SELECT @v_dSql1 += '    , SUM(case when groups = ''RELEASE'' then make_qty else 0 end ) ''RELEASE'' ' + char(10)
             SELECT @v_dSql1 += '    , SUM(case when groups = ''AMEND'' then make_qty else 0 end ) ''AMEND''     ' + char(10)
             SELECT @v_dSql1 += '    , SUM(case when groups = ''PLAN_EQUIPMENT_R'' then make_qty else 0 end ) ''PLAN_EQUIPMENT_R''  ' + char(10)
             SELECT @v_dSql1 += '    , CASE WHEN  SUM(case when groups = ''AMEND'' then make_qty else 0 end ) <> SUM(case when groups = ''RELEASE'' then make_qty else 0 end ) THEN ''NG_RELEASE'' ELSE '''' END CHK1_RELEASE  ' + char(10)
             SELECT @v_dSql1 += '    , CASE WHEN  SUM(case when groups = ''RELEASE'' then make_qty else 0 end ) <> SUM(case when groups = ''MES'' then make_qty else 0 end) THEN ''NG_MES'' ELSE '''' END CHK2_MES  ' + char(10)
             SELECT @v_dSql1 += '    , CASE WHEN  SUM(case when groups = ''MES'' then make_qty else 0 end) <> SUM(case when groups = ''ERP'' then make_qty else 0 end) THEN ''NG_ERP'' ELSE '''' END CHK3_ERP  ' + char(10)
             SELECT @v_dSql1 += ' FROM (  ' + char(10)
             SELECT @v_dSql1 += '         SELECT max(groups) as groups, plant_id, factory_id, operation_id, item_id, make_date, sum(make_qty) as make_qty, plan_id ' + char(10)
             SELECT @v_dSql1 += '         FROM  ( SELECT ''ERP'' groups , plant_id, a.factory_id, OPERATION_ID, item_id,SUBSTRING(a.plan_date,1,8) make_date       ' + char(10)
             SELECT @v_dSql1 += '                    , FP_PLAN_QTY AS MAKE_QTY  ' + char(10)
             SELECT @v_dSql1 += '                    , A.FP_PLAN_ID AS PLAN_ID  ' + char(10)
             SELECT @v_dSql1 += '                FROM   SY_XIF_ERP_PRODUCTION_PLAN_S A  WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql1 += '                      ,TARGET_PLAN  PLANS  WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql1 += '                WHERE  FP_PLAN_ID = PLANS.PLAN_ID        ' + char(10)
             SELECT @v_dSql1 += '                AND    PLANS.NUMS = 1                    ' + char(10)
             SELECT @v_dSql1 += '                AND   (A.TOP_BACK_IND = ''B'' OR A.TOP_BACK_IND IS NULL) ' + char(10)
             SELECT @v_dSql1 += '                AND    A.FIX_TYPE = ''Y''  ' + char(10)
             SELECT @v_dSql1 += '              UNION ALL                    ' + char(10)
             SELECT @v_dSql1 += '                SELECT ''ERP'' AS GROUPS, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, CONVERT( VARCHAR, A.PLAN_DATE, 112) , A.PLAN_QTY  ' + char(10)
             SELECT @v_dSql1 += '                     , A.FP_PLAN_ID AS PLAN_ID  ' + char(10)
             SELECT @v_dSql1 += '                FROM   [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql1 += '      ,TARGET_PLAN  PLANS  WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql1 += '                WHERE A.FP_PLAN_ID = PLANS.PLAN_ID     ' + char(10)
             SELECT @v_dSql1 += '                AND   FIX_TYPE   IN (''F'',''N'')      ' + char(10)
             SELECT @v_dSql1 += '                AND   ORDER_TYPE IN (''W'')            ' + char(10)
             SELECT @v_dSql1 += '                AND   PLANS.NUMS = 1                   ' + char(10)
             SELECT @v_dSql1 += '                AND   NOT EXISTS ( SELECT 1            ' + char(10)
             SELECT @v_dSql1 += '                                      FROM   [dbo].[SY_XIF_ERP_PRODUCTION_PLAN_S] XEP WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql1 += '                                      WHERE  XEP.FP_PLAN_ID = A.FP_PLAN_ID          ' + char(10)
             SELECT @v_dSql1 += '                                      AND    XEP.WORK_ORDER_ID = A.WORK_ORDER_ID )  ' + char(10)
             SELECT @v_dSql1 += '           ) PLANSS  ' + char(10)
             SELECT @v_dSql1 += '          GROUP BY plant_id, factory_id, OPERATION_ID, item_id,make_date, plan_id  ' + char(10)
             SELECT @v_dSql1 += '       UNION ALL     ' + char(10)
             SELECT @v_dSql1 += '         SELECT max(groups) as groups, plant_id, factory_id, OPERATION_ID, item_id, make_date, sum(make_qty) as make_qty, plan_id  ' + char(10)
             --SELECT @v_dSql1 += '         FROM  ( SELECT ''MES'' as groups, plant_id, builno factory_id, OPERATION_ID, item_id, replace( SUBSTRING(a.plan_date,1,10) ,''-'','''') make_date  ' + char(10)
			
             -- [E20251205-001628] MODIFY
             SELECT @v_dSql1 += '         FROM  ( SELECT ''MES'' as groups, LM.PLANT_ID AS PLANT_ID, LM.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID , replace( SUBSTRING(a.plan_date,1,10) ,''-'','''') make_date  ' + char(10) -- NERP 오픈 대응... 20241231
             SELECT @v_dSql1 += '                      ,CAST(ATTR_08 AS NUMERIC) AS MAKE_QTY ' + char(10)
             SELECT @v_dSql1 += '                      ,a.PLAN_ID                            ' + char(10)
             SELECT @v_dSql1 += '                  FROM   SY_XIF_MES_WO_S a  with(nolock)    ' + char(10)
             SELECT @v_dSql1 += '                        ,target_plan  plans  with(nolock)   ' + char(10)
			 SELECT @v_dSql1 += '                        , FP_MES_LINE_M_V LM  with(nolock) ' + char(10) -- NERP 오픈 대응... 20241231
             SELECT @v_dSql1 += '                  WHERE a.plan_id  = plans.plan_id          ' + char(10)
             SELECT @v_dSql1 += '                  AND   plans.nums = 1                      ' + char(10)
             SELECT @v_dSql1 += '                  AND   (a.attr_05 = ''B'' or a.attr_05 is null)  ' + char(10)
             SELECT @v_dSql1 += '                  AND   A.IS_RELEASE = ''Y''           ' + char(10)
             SELECT @v_dSql1 += '                  AND   if_id <> ''OFP0_OPLM_FP_WO''   ' + char(10)
			 SELECT @v_dSql1 += '                  AND   A.BUILNO			= ISNULL(LM.MES_MNGL_PRDN,LM.FACTORY_ID)	' + char(10)
             SELECT @v_dSql1 += '                  AND   A.OPERATION_ID	= LM.OPERATION_ID		 ' + char(10)
             SELECT @v_dSql1 += '                  AND   A.ATTR_10		= LM.LINE_ID			 ' + char(10)
             
			 
/*		-- [E20251205-001628]	 
             SELECT @v_dSql1 += '         FROM  ( SELECT ''MES'' as groups, aa.plant_id, builno factory_id, OPERATION_ID, item_id, replace( SUBSTRING(a.plan_date,1,10) ,''-'','''') make_date  ' + char(10) -- NERP 오픈 대응... 20241231
             SELECT @v_dSql1 += '                      ,CAST(ATTR_08 AS NUMERIC) AS MAKE_QTY ' + char(10)
             SELECT @v_dSql1 += '                      ,a.PLAN_ID                            ' + char(10)
             SELECT @v_dSql1 += '                  FROM   SY_XIF_MES_WO_S a  with(nolock)    ' + char(10)
             SELECT @v_dSql1 += '                        ,target_plan  plans  with(nolock)   ' + char(10)
			 SELECT @v_dSql1 += '                        , SCM_FACTORY_M aa with(nolock) ' + char(10) -- NERP 오픈 대응... 20241231
             SELECT @v_dSql1 += '                  WHERE a.plan_id  = plans.plan_id          ' + char(10)
             SELECT @v_dSql1 += '                  AND   plans.nums = 1                      ' + char(10)
             SELECT @v_dSql1 += '                  AND   (a.attr_05 = ''B'' or a.attr_05 is null)  ' + char(10)
             SELECT @v_dSql1 += '                  AND   A.IS_RELEASE = ''Y''           ' + char(10)
             SELECT @v_dSql1 += '                  AND   if_id <> ''OFP0_OPLM_FP_WO''   ' + char(10)
			 SELECT @v_dSql1 += '                  and   a.builno   = aa.factory_id ' + char(10) -- NERP 오픈 대응... 20241231
			 SELECT @v_dSql1 += '                  and   a.plant_id = aa.mes_plant_id ' + char(10)
*/             
			 SELECT @v_dSql1 += '                UNION ALL                              ' + char(10)
             SELECT @v_dSql1 += '                  SELECT ''MES'' AS GROUPS, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, CONVERT( VARCHAR, A.PLAN_DATE, 112) , A.PLAN_QTY  ' + char(10)
             SELECT @v_dSql1 += '                          , A.FP_PLAN_ID AS PLAN_ID  ' + char(10)
             SELECT @v_dSql1 += '                  FROM   [DBO].[FP_PRODUCTION_PLAN_EQUIPMENT_R] A WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql1 += '                          ,TARGET_PLAN  PLANS  WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql1 += '     		       WHERE A.FP_PLAN_ID = PLANS.PLAN_ID         ' + char(10)
             SELECT @v_dSql1 += '     		       AND   FIX_TYPE   IN (''F'',''N'')          ' + char(10)
             SELECT @v_dSql1 += '                  AND   PLANS.NUMS = 1                       ' + char(10)
             SELECT @v_dSql1 += '                  AND   NOT EXISTS ( SELECT 1                ' + char(10)
             SELECT @v_dSql1 += '                                     FROM   [dbo].[SY_XIF_MES_WO_S] XMW WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql1 += '                                     WHERE  XMW.PLAN_ID   = A.FP_PLAN_ID             ' + char(10)
             SELECT @v_dSql1 += '                                     AND    XMW.WO        = A.WORK_ORDER_ID          ' + char(10)
             SELECT @v_dSql1 += '                                     AND    XMW.WO_DETAIL = A.WORK_ORDER_SPL_ID )    ' + char(10)
             SELECT @v_dSql1 += '            ) planss  ' + char(10)
             SELECT @v_dSql1 += '        GROUP BY plant_id, factory_id, OPERATION_ID, item_id, make_date, plan_id  ' + char(10)
             
			 SELECT @v_dSql2 = ''
			 SELECT @v_dSql2 += '       UNION ALL  ' + char(10)
             SELECT @v_dSql2 += '        SELECT ''AMEND'' as groups, ( select f.plant_id from dbo.scm_factory_m f where f.factory_id = w.after_site_id ) as PLANT_ID  ' + char(10)
             SELECT @v_dSql2 += '             ,after_site_id as FACTORY_ID, after_operation_id, ITEM_ID, after_plan_date make_date , CEILING(sum(after_qty)) make_qty  ' + char(10)
             SELECT @v_dSql2 += '             ,plans.plan_id        ' + char(10)
             SELECT @v_dSql2 += '        FROM  [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)  ' + char(10)
             SELECT @v_dSql2 += '              ,target_plan plans  ' + char(10)
             SELECT @v_dSql2 += '              ,( SELECT DEMAND_ID, MIN(AFTER_PLAN_DATE) AS PLAN_DATE       ' + char(10)
             SELECT @v_dSql2 += '                 FROM   [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)  ' + char(10)
             SELECT @v_dSql2 += '                       ,target_plan plans             ' + char(10)
             SELECT @v_dSql2 += '                 WHERE master_id = plans.instance_id  ' + char(10)
             SELECT @v_dSql2 += '                 AND  w.plan_id = plans.basis_plan_id ' + char(10)
             SELECT @v_dSql2 += '                 AND  w.after_in_qty > 0              ' + char(10)
             SELECT @v_dSql2 += '                 AND  plans.nums = 1                  ' + char(10)
             SELECT @v_dSql2 += '                 AND  PLANS.UI_TYPE = ''AMEND UI''    ' + char(10)
             SELECT @v_dSql2 += '                 AND  EXISTS ( SELECT 1               ' + char(10)
             SELECT @v_dSql2 += '                               FROM   SCM_LINE_M   SLM WITH(NOLOCK)              ' + char(10)
             SELECT @v_dSql2 += '                               WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID         ' + char(10)
             SELECT @v_dSql2 += '                               AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID        ' + char(10)
             SELECT @v_dSql2 += '                               AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID    ' + char(10)
             SELECT @v_dSql2 += '                               AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID ) ) ' + char(10)
             SELECT @v_dSql2 += '                 GROUP BY DEMAND_ID ) x       ' + char(10)
             SELECT @v_dSql2 += '         WHERE master_id = plans.instance_id  ' + char(10)
             SELECT @v_dSql2 += '         AND  w.plan_id = plans.basis_plan_id ' + char(10)
             SELECT @v_dSql2 += '         AND  PLANS.UI_TYPE = ''AMEND UI''    ' + char(10)
             SELECT @v_dSql2 += '         AND  w.demand_id = x.demand_id       ' + char(10)
             SELECT @v_dSql2 += '         AND  EXISTS ( SELECT 1               ' + char(10)
             SELECT @v_dSql2 += '                       FROM   SCM_LINE_M   SLM WITH(NOLOCK)              ' + char(10)
             SELECT @v_dSql2 += '                       WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID         ' + char(10)
             SELECT @v_dSql2 += '                       AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID        ' + char(10)
             SELECT @v_dSql2 += '                       AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID    ' + char(10)
             SELECT @v_dSql2 += '                       AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID ) ) ' + char(10)
             --SELECT @v_dSql2 += '         AND  PLAN_DATE <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)                   ' + char(10)
             /*
			 SELECT @v_dSql2 += '         AND  PLAN_DATE <= dateadd(dd,( SELECT (CASE WHEN SLV.ATTRIBUTE7 = ''Y'' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE  ' + char(10) -- release validation block 로직 추가... 20230622
             SELECT @v_dSql2 += '                                       FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)          ' + char(10)
             SELECT @v_dSql2 += '                                       WHERE  SLV.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''  ' + char(10)
             SELECT @v_dSql2 += '                                       AND    SLV.ACTIVE_FLAG = ''Y''           ' + char(10)
             SELECT @v_dSql2 += '                                       AND    SLV.SEGMENT1 = plans.INSTANCE_ID  ' + char(10)
             SELECT @v_dSql2 += '                                       AND    SLV.SEGMENT2 = plans.PLAN_GROUP_ID), convert(datetime,plans.instance_date) )  ' + char(10)
             */
			 -- [E20241218-001011]수량이 부적합하다고 릴리즈 불가현상 확인 요청 : release wo limit 구간 로직 수정 - RELEASE_TERM 이 LIMTE DATE 보다 이전 구간일 경우, RELEASE_TERM 기준으로 체크되도록 수정... 20241218
			 SELECT @v_dSql2 += '         AND  PLAN_DATE <= PLANS.INSTANCE_DATE ' + char(10)
			 SELECT @v_dSql2 += '         AND  plans.nums = 1     ' + char(10)
             SELECT @v_dSql2 += '         AND  exists (           ' + char(10)
             SELECT @v_dSql2 += '                       SELECT 1  ' + char(10)
             SELECT @v_dSql2 += '                       FROM   FP_INSTANCE_CONFIG_M k                 ' + char(10)
             SELECT @v_dSql2 += '                       WHERE  k.instance_id = w.master_id            ' + char(10)
             SELECT @v_dSql2 += '                       AND    k.CATEGORY_ID  = ''PLAN_CATEGORY''     ' + char(10)
             SELECT @v_dSql2 += '                       AND    k.KEY_ID       = ''CELL_HARD_PEGGING'' ' + char(10)
             SELECT @v_dSql2 += '                       AND    k.KEY_VALUE    = ''Y''  ' + char(10)
             SELECT @v_dSql2 += '                       )                              ' + char(10)
             SELECT @v_dSql2 += '        GROUP BY after_site_id, after_operation_id, ITEM_ID, after_plan_date, plans.plan_id  ' + char(10)
             SELECT @v_dSql2 += '       UNION ALL  ' + char(10)
             SELECT @v_dSql2 += '         SELECT ''AMEND'' as groups, ( select f.plant_id from dbo.scm_factory_m f WITH(NOLOCK) where f.factory_id = w.after_site_id ) as PLANT_ID  ' + char(10)
             SELECT @v_dSql2 += '                 ,after_site_id as FACTORY_ID, after_operation_id, ITEM_ID, after_plan_date make_date , CEILING(sum(after_qty)) make_qty  ' + char(10)
             SELECT @v_dSql2 += ' 		            ,plans.plan_id  ' + char(10)
             SELECT @v_dSql2 += '         FROM  [dbo].[FP_AMEND_PRODUCTION_PLAN_R] w with(nolock)  ' + char(10)
             SELECT @v_dSql2 += ' 		         ,target_plan  plans  with(nolock)               ' + char(10)
             SELECT @v_dSql2 += '         WHERE master_id = plans.instance_id                    ' + char(10)
             SELECT @v_dSql2 += '         AND   w.plan_id = plans.basis_plan_id                  ' + char(10)
             SELECT @v_dSql2 += '         AND   PLANS.UI_TYPE = ''AMEND UI''                     ' + char(10)
             SELECT @v_dSql2 += '         AND   EXISTS (SELECT 1                                 ' + char(10)
    SELECT @v_dSql2 += ' 				FROM   SCM_LINE_M   SLM WITH(NOLOCK)             ' + char(10)
             SELECT @v_dSql2 += ' 				WHERE  SLM.FACTORY_ID   = W.AFTER_SITE_ID        ' + char(10)
             SELECT @v_dSql2 += ' 				AND    SLM.LINE_ID      = W.AFTER_ROUTE_ID       ' + char(10)
             SELECT @v_dSql2 += ' 				AND    SLM.OPERATION_ID = W.AFTER_OPERATION_ID   ' + char(10)
             SELECT @v_dSql2 += ' 				AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID )) ' + char(10)
             SELECT @v_dSql2 += '         AND  plans.nums = 1      ' + char(10)
             SELECT @v_dSql2 += '         AND  w.after_in_qty > 0  ' + char(10)
             --SELECT @v_dSql2 += '         AND  after_plan_date <= dateadd(dd,(SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)           ' + char(10)
             /*
			 SELECT @v_dSql2 += '         AND  after_plan_date <= dateadd( dd,( SELECT (CASE WHEN SLV.ATTRIBUTE7 = ''Y'' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE  ' + char(10) -- release validation block 로직 추가... 20230622
             SELECT @v_dSql2 += '                                             FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql2 += '                                             WHERE  SLV.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''  ' + char(10)
             SELECT @v_dSql2 += '                                             AND    SLV.ACTIVE_FLAG = ''Y''           ' + char(10)
             SELECT @v_dSql2 += '                                             AND    SLV.SEGMENT1 = plans.INSTANCE_ID  ' + char(10)
             SELECT @v_dSql2 += '                                             AND    SLV.SEGMENT2 = plans.PLAN_GROUP_ID), convert(datetime,plans.instance_date) )  ' + char(10)
             */
			 -- [E20241218-001011]수량이 부적합하다고 릴리즈 불가현상 확인 요청 : release wo limit 구간 로직 수정 - RELEASE_TERM 이 LIMTE DATE 보다 이전 구간일 경우, RELEASE_TERM 기준으로 체크되도록 수정... 20241218
			 SELECT @v_dSql2 += '         AND  after_plan_date <= PLANS.INSTANCE_DATE ' + char(10)
			 SELECT @v_dSql2 += '         AND  not exists (         ' + char(10)
             SELECT @v_dSql2 += '                         SELECT 1  ' + char(10)
             SELECT @v_dSql2 += '                         FROM   FP_INSTANCE_CONFIG_M k                 ' + char(10)
             SELECT @v_dSql2 += '                         WHERE  k.instance_id = w.master_id            ' + char(10)
             SELECT @v_dSql2 += '                         AND    k.CATEGORY_ID  = ''PLAN_CATEGORY''     ' + char(10)
             SELECT @v_dSql2 += '                         AND    k.KEY_ID       = ''CELL_HARD_PEGGING'' ' + char(10)
             SELECT @v_dSql2 += '                         AND    k.KEY_VALUE    = ''Y''                 ' + char(10)
             SELECT @v_dSql2 += '                         )  ' + char(10)
             SELECT @v_dSql2 += '         GROUP BY after_site_id, after_operation_id, ITEM_ID, after_plan_date, plans.plan_id  ' + char(10)
			 
			 SELECT @v_dSql3 = ''
             SELECT @v_dSql3 += '       UNION ALL  ' + char(10)
             SELECT @v_dSql3 += '        SELECT ''AMEND'' as groups, MAX(W.PLANT_ID) AS PLANT_ID  ' + char(10)
             SELECT @v_dSql3 += '            ,W.FACTORY_ID as FACTORY_ID, W.operation_id, W.ITEM_ID, PLAN_DATE make_date , CEILING(sum(OUT_QTY)) make_qty  ' + char(10)
             SELECT @v_dSql3 += '            ,plans.plan_id  ' + char(10)
             SELECT @v_dSql3 += '        FROM  [dbo].[FP_AMEND_PLAN_R] w with(nolock) ' + char(10)
             SELECT @v_dSql3 += '             ,target_plan  plans  with(nolock)       ' + char(10)
             SELECT @v_dSql3 += '        WHERE w.instance_id = plans.instance_id      ' + char(10)
             SELECT @v_dSql3 += '        AND   w.fp_plan_id  = plans.basis_plan_id    ' + char(10)
             SELECT @v_dSql3 += '        AND   PLANS.UI_TYPE = ''PSI AMEND UI''       ' + char(10)
             SELECT @v_dSql3 += '        AND   EXISTS (SELECT 1                       ' + char(10)
             SELECT @v_dSql3 += '                       FROM   SCM_LINE_M   SLM WITH(NOLOCK)             ' + char(10)
             SELECT @v_dSql3 += '                       WHERE  SLM.FACTORY_ID   = W.FACTORY_ID           ' + char(10)
             SELECT @v_dSql3 += '                       AND    SLM.LINE_ID      = W.LINE_ID              ' + char(10)
             SELECT @v_dSql3 += '                       AND    SLM.OPERATION_ID = W.OPERATION_ID         ' + char(10)
             SELECT @v_dSql3 += '                       AND    ( SLM.MODEL_TYPE = plans.PLAN_GROUP_ID )) ' + char(10)
             SELECT @v_dSql3 += '        AND  plans.nums = 1  ' + char(10)
             SELECT @v_dSql3 += '        AND  in_qty > 0      ' + char(10)
             --SELECT @v_dSql3 += '        AND  plan_date <= dateadd(dd,( SELECT CONVERT(NUMERIC(5), SLV.SEGMENT3)                  ' + char(10)
             /*
			 SELECT @v_dSql3 += '        AND  plan_date <= dateadd(dd,(SELECT (CASE WHEN SLV.ATTRIBUTE7 = ''Y'' THEN 0 ELSE CONVERT(NUMERIC(5), SLV.SEGMENT3) END) AS INSTANCE_DATE ' + char(10) -- release validation block 로직 추가... 20230622
             SELECT @v_dSql3 += '                                       FROM   DBO.SCM_SYS_LOOKUP_VALUE  SLV WITH(NOLOCK)         ' + char(10)
             SELECT @v_dSql3 += '                                       WHERE  SLV.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
             SELECT @v_dSql3 += '                                       AND    SLV.ACTIVE_FLAG = ''Y''           ' + char(10)
             SELECT @v_dSql3 += '                                       AND    SLV.SEGMENT1 = plans.INSTANCE_ID  ' + char(10)
             SELECT @v_dSql3 += '                                       AND    SLV.SEGMENT2 = plans.PLAN_GROUP_ID), convert(datetime,plans.instance_date) )  ' + char(10)
             */
			 -- [E20241218-001011]수량이 부적합하다고 릴리즈 불가현상 확인 요청 : release wo limit 구간 로직 수정 - RELEASE_TERM 이 LIMTE DATE 보다 이전 구간일 경우, RELEASE_TERM 기준으로 체크되도록 수정... 20241218
			 SELECT @v_dSql3 += '        AND  plan_date <= PLANS.INSTANCE_DATE ' + char(10)
			 SELECT @v_dSql3 += '        GROUP BY W.FACTORY_ID, operation_id, ITEM_ID, plan_date, plans.plan_id  ' + char(10)
             SELECT @v_dSql3 += '       UNION ALL  ' + char(10)
             SELECT @v_dSql3 += '        SELECT ''RELEASE'', ( select f.plant_id from scm_factory_m f  with(nolock) where f.factory_id = w.FACTORY_ID ) as PLANT_ID  ' + char(10)
             SELECT @v_dSql3 += '              , W.FACTORY_ID , W.OPERATION_ID , W.ITEM_ID , CONVERT(VARCHAR, W.PLAN_DATE,112) AS PLAN_DATE , CEILING(sum(PLAN_QTY)) make_qty  ' + char(10)
             SELECT @v_dSql3 += '              ,plans.plan_id  ' + char(10)
             SELECT @v_dSql3 += '        FROM   FP_RELEASE_FIX_PLAN_H  W  with(nolock)  ' + char(10)
             SELECT @v_dSql3 += '              ,target_plan  plans  with(nolock)        ' + char(10)
             SELECT @v_dSql3 += '        WHERE W.INSTANCE_ID     = plans.instance_id    ' + char(10)
             SELECT @v_dSql3 += '        AND   w.AMEND_PLAN_ID   = plans.basis_plan_id  ' + char(10)
             SELECT @v_dSql3 += '        AND   w.RELEASE_PLAN_ID = plans.PLAN_ID        ' + char(10)
             SELECT @v_dSql3 += '        AND   plans.nums        = 1                    ' + char(10)
             SELECT @v_dSql3 += '        GROUP BY W.FACTORY_ID, W.operation_id, W.ITEM_ID, W.plan_date, plans.plan_id  ' + char(10)
             SELECT @v_dSql3 += '       UNION ALL  ' + char(10)
             SELECT @v_dSql3 += '        SELECT ''PLAN_EQUIPMENT_R'', a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112), sum( a.plan_qty)  ' + char(10)
             SELECT @v_dSql3 += '              ,plans.plan_id  ' + char(10)
             SELECT @v_dSql3 += '        FROM   dbo.FP_PRODUCTION_PLAN_EQUIPMENT_R a  with(nolock)  ' + char(10)
             SELECT @v_dSql3 += '              ,target_plan plans with(nolock)  ' + char(10)
             SELECT @v_dSql3 += '        WHERE a.FP_PLAN_ID = plans.plan_id     ' + char(10)
             SELECT @v_dSql3 += '        AND   FIX_TYPE   IN (''F'',''N'')      ' + char(10)
             SELECT @v_dSql3 += '        AND   ORDER_TYPE IN (''W'',''M'')      ' + char(10)
             SELECT @v_dSql3 += '        GROUP BY a.PLANT_ID, a.FACTORY_ID, a.OPERATION_ID, a.ITEM_ID, convert( varchar, a.PLAN_DATE, 112),plans.plan_id  ' + char(10)
             SELECT @v_dSql3 += ' ) A  ' + char(10)
             SELECT @v_dSql3 += ' WHERE  OPERATION_ID != ''A6000''  ' + char(10)
             SELECT @v_dSql3 += ' GROUP BY PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, MAKE_DATE, PLAN_ID  ' + char(10)
             SELECT @v_dSql3 += ' HAVING ( ABS(SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = ''RELEASE'' THEN MAKE_QTY ELSE 0 END ))/( CASE WHEN SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) = 0 THEN 1 ELSE SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) END) > 0.0015  ' + char(10)
             SELECT @v_dSql3 += '     OR ABS(SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = ''MES'' THEN MAKE_QTY ELSE 0 END ))/( CASE WHEN SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) = 0 THEN 1 ELSE SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) END) > 0.0015 )  ' + char(10)
             SELECT @v_dSql3 += ' AND ( ABS(SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = ''RELEASE'' THEN MAKE_QTY ELSE 0 END )) > 1  ' + char(10)
             SELECT @v_dSql3 += '     OR ABS(SUM(CASE WHEN GROUPS = ''AMEND'' THEN MAKE_QTY ELSE 0 END ) - SUM(CASE WHEN GROUPS = ''MES'' THEN MAKE_QTY ELSE 0 END ))> 1 )  ' + char(10)
             SELECT @v_dSql3 += ' UNION  ' + char(10)
             SELECT @v_dSql3 += ' SELECT PLANT_ID, FACTORY_ID, OPERATION_ID, ITEM_ID, SUBSTRING(Z.PLAN_DATE,1,8), FP_PLAN_ID  ' + char(10)
             SELECT @v_dSql3 += '     , 0 ''ERP''     ' + char(10)
             SELECT @v_dSql3 += '     , 0 ''MES''     ' + char(10)
             SELECT @v_dSql3 += '     , 0 ''RELEASE'' ' + char(10)
             SELECT @v_dSql3 += '     , 0 ''AMEND''   ' + char(10)
             SELECT @v_dSql3 += '     , count(distinct batch_id) ''PLAN_EQUIPMENT_R''  ' + char(10)
             SELECT @v_dSql3 += '     , z.batch_order_id CHK1_RELEASE  ' + char(10)
             SELECT @v_dSql3 += '     , ''NG_BATCH_ORDER_ID'' CHK2_MES ' + char(10)
             SELECT @v_dSql3 += '     , ''NG_BATCH_ORDER_ID'' CHK3_ERP ' + char(10)
             SELECT @v_dSql3 += ' FROM (  ' + char(10)
             SELECT @v_dSql3 += '         SELECT ISNULL((SELECT  B.BATCH_ID    ' + char(10)
             SELECT @v_dSql3 += '                        FROM    SCM_BATCH_M B ' + char(10)
             SELECT @v_dSql3 += '                        WHERE   B.PLANT_ID = A.PLANT_ID  ' + char(10)
             SELECT @v_dSql3 += '                        AND     B.ITEM_ID = A.ITEM_ID), ITEM_ID) AS BATCH_ID , A.*  ' + char(10)
             SELECT @v_dSql3 += '         FROM   SY_XIF_ERP_PRODUCTION_PLAN_S A WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql3 += '              , TARGET_PLAN PLANS WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql3 += '         WHERE A.FP_PLAN_ID = PLANS.PLAN_ID     ' + char(10)
             SELECT @v_dSql3 += '         AND   BATCH_ORDER_ID <> ''-''          ' + char(10)
             SELECT @v_dSql3 += '      ) z  ' + char(10)
             SELECT @v_dSql3 += ' GROUP BY Z.PLANT_ID, Z.FACTORY_ID, Z.OPERATION_ID, Z.ITEM_ID, SUBSTRING(Z.PLAN_DATE,1,8), FP_PLAN_ID, BATCH_ORDER_ID  ' + char(10)
             SELECT @v_dSql3 += ' HAVING COUNT(DISTINCT z.BATCH_ID) > 1  ' + char(10)

			 SELECT @v_dSql = @v_dSql1 + @v_dSql2 + @v_dSql3
			 
			 IF @p_sys_type = 'SQL'
			 	BEGIN
			 		--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
			 		SELECT @v_dSql as [QUERY_VALUE]
			 
			 	END  
			 ELSE 
			 	BEGIN
			 		SET @runstart = GetDate()
			 		--쿼리실행
			 		EXEC sp_executesql @v_dSql
			 
			 		SET @runend = GetDate()
			 		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
			 	END	
		END
    /************************************************************************************************/
	/* Group Release Total팝업경우 :(RELEASE_GROUP_VALIDATION_2 Select)                                           */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='RELEASE_GROUP_VALIDATION_2')
	    BEGIN
		     SELECT @v_dSql = ''
             SELECT @v_dSql += ' SELECT FP_PLAN_ID, PLANT_ID, FACTORY_ID  ,OPERATION_ID  ' + char(10)
             SELECT @v_dSql += '     ,WORK_ORDER_ID ,PLAN_DATE ,PARENT_ITEM_ID ,LINE_ID  ' + char(10)
             SELECT @v_dSql += '     ,PLAN_QTY ,PLAN_IN_QTY ,CHILD_ITEM_ID  ,CHILD_ASSIGN_LINE_ID  ' + char(10)
             SELECT @v_dSql += '     ,CHILD_ASSIGN_PRIORITY     ' + char(10)
             SELECT @v_dSql += '     ,CASE WHEN (               ' + char(10)
             SELECT @v_dSql += '               SELECT PRIORITY  ' + char(10)
             SELECT @v_dSql += '               FROM  SCM_ITEM_LINE_ASSIGN_EXCEPT_M KK WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql += '               WHERE PLANT_ID   =  A.PLANT_ID   ' + char(10)
             SELECT @v_dSql += '               AND FACTORY_ID = A.FACTORY_ID    ' + char(10)
             SELECT @v_dSql += '               AND ITEM_ID    = A.CHILD_ITEM_ID ' + char(10)
             SELECT @v_dSql += '               AND LINE_ID    = A.LINE_ID       ' + char(10)
             SELECT @v_dSql += '               AND START_TIME <= A.PLAN_DATE    ' + char(10)
             SELECT @v_dSql += '               AND END_TIME   > A.PLAN_DATE     ' + char(10)
             SELECT @v_dSql += '               AND ACTIVE_FLAG = ''N'') IS NULL THEN ''N'' ELSE ''Y''END AS CHILD_ASSIGN_EXCEPT  ' + char(10)
             SELECT @v_dSql += ' FROM (  ' + char(10)
             SELECT @v_dSql += '       SELECT A.COMPANY_ID  ,A.DIVISION_ID ,A.SITE_ID ,A.PLANT_ID     ' + char(10)
             SELECT @v_dSql += '          ,A.FACTORY_ID ,A.OPERATION_ID ,A.WORK_ORDER_ID  ,PLAN_DATE  ' + char(10)
             SELECT @v_dSql += '          ,A.FP_PLAN_ID ,A.LINE_ID ,A.PLAN_QTY ,A.PLAN_IN_QTY         ' + char(10)
             SELECT @v_dSql += '          ,PARENT_ITEM_ID ,CHILD_ITEM_ID ,I.LINE_ID AS CHILD_ASSIGN_LINE_ID            ' + char(10)
             SELECT @v_dSql += '          ,I.OPERATION_ID  AS CHILD_OPERATION_ID ,I.PRIORITY AS CHILD_ASSIGN_PRIORITY  ' + char(10)
             SELECT @v_dSql += '          ,CASE WHEN A.ALT_ID IS NULL THEN 1 ELSE ROW_NUMBER() OVER ( PARTITION BY A.PARENT_ITEM_ID, A.WORK_ORDER_ID, A.ALT_ID   ' + char(10)
             SELECT @v_dSql += '                ORDER BY I.LINE_ID DESC, A.ALT_PRIORITY, A.CHILD_ITEM_ID) END AS ORD_PRIORITY  ' + char(10)
             SELECT @v_dSql += '       FROM (  ' + char(10)
             SELECT @v_dSql += '            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID  ' + char(10)
             SELECT @v_dSql += '            , A.OPERATION_ID, A.PLAN_DATE, A.FP_PLAN_ID, A.WORK_ORDER_ID             ' + char(10)
             SELECT @v_dSql += '            , A.PLAN_QTY, A.PLAN_IN_QTY, A.LINE_ID            ' + char(10)
             SELECT @v_dSql += '               ,B.PARENT_ITEM_ID  ,B.CHILD_ITEM_ID ,B.ALT_ID  ' + char(10)
             SELECT @v_dSql += '               ,B.ALT_PRIORITY                                ' + char(10)
             SELECT @v_dSql += '            FROM DBO.FP_PRODUCTION_PLAN_EQUIPMENT_R A WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql += '                ,DBO.SCM_BOM_M B WITH(NOLOCK)   ' + char(10)
             SELECT @v_dSql += '                ,DBO.SCM_FP_PLAN_GROUP_DETAIL_H C WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql += '                ,DBO.SCM_ITEM_M D WITH(NOLOCK)     ' + char(10)
             SELECT @v_dSql += '            WHERE 1=1                              ' + char(10)
             SELECT @v_dSql += '            AND B.PARENT_ITEM_ID = A.ITEM_ID       ' + char(10)
             SELECT @v_dSql += '            AND B.PLANT_ID = A.PLANT_ID            ' + char(10)
             SELECT @v_dSql += '            AND CHILD_ITEM_ID LIKE ''ASL%''        ' + char(10)
             SELECT @v_dSql += '            AND EFF_START_DATE <= A.START_TIME     ' + char(10)
             SELECT @v_dSql += '            AND EFF_END_DATE > A.START_TIME        ' + char(10)
             SELECT @v_dSql += '            AND A.FP_PLAN_ID   = C.RELEASE_PLAN_ID ' + char(10)
             SELECT @v_dSql += '            AND B.COMPANY_ID    = D.COMPANY_ID     ' + char(10)
             SELECT @v_dSql += '            AND B.DIVISION_ID   = D.DIVISION_ID    ' + char(10)
             SELECT @v_dSql += '            AND B.SITE_ID       = D.SITE_ID        ' + char(10)
             SELECT @v_dSql += '            AND B.CHILD_ITEM_ID = D.ITEM_ID        ' + char(10)
             SELECT @v_dSql += '            AND D.ACTIVE_FLAG   = ''Y''            ' + char(10)
             SELECT @v_dSql += '            AND C.RELEASE_FLAG = ''Y''             ' + char(10)
             SELECT @v_dSql += '            AND C.PLAN_DATE    = '''+ @p_plan_date +'''    ' + char(10)
             SELECT @v_dSql += '            AND C.INSTANCE_ID  = '''+ @p_instance_id +'''  ' + char(10)
             SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PLAN_ID' , 'EQ', @p_plan_id))    + char(10)
             SELECT @v_dSql += '            AND ORDER_TYPE = ''W''  ' + char(10)
             SELECT @v_dSql += '            AND PLAN_IN_QTY > 0.0   ' + char(10)
             SELECT @v_dSql += '            AND OPERATION_ID IN ( ''E2000'', ''S2000'')  ' + char(10)
             SELECT @v_dSql += '       ) A  ' + char(10)
             SELECT @v_dSql += '       LEFT OUTER JOIN  DBO.SCM_ITEM_LINE_ASSIGN_M I WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql += '         ON A.PLANT_ID =  I.PLANT_ID      ' + char(10)
             SELECT @v_dSql += '        AND A.FACTORY_ID  = I.FACTORY_ID  ' + char(10)
             SELECT @v_dSql += '        AND A.CHILD_ITEM_ID = I.ITEM_ID   ' + char(10)
             SELECT @v_dSql += '        AND A.LINE_ID = I.LINE_ID         ' + char(10)
             SELECT @v_dSql += '        AND ACTIVE_FLAG = ''Y''           ' + char(10)
             SELECT @v_dSql += '        AND MONTH = CONVERT(VARCHAR(6),A.PLAN_DATE, 112)  ' + char(10)
             SELECT @v_dSql += '        AND I.PRIORITY != ''9''   ' + char(10)
             SELECT @v_dSql += '        AND NOT EXISTS  (         ' + char(10)
             SELECT @v_dSql += '                        SELECT 1  ' + char(10)
             SELECT @v_dSql += '                        FROM SCM_ITEM_LINE_ASSIGN_EXCEPT_M KK WITH(NOLOCK)  ' + char(10)
             SELECT @v_dSql += '                        WHERE PLANT_ID =  A.PLANT_ID       ' + char(10)
             SELECT @v_dSql += '                        AND FACTORY_ID  = A.FACTORY_ID     ' + char(10)
             SELECT @v_dSql += '                        AND ITEM_ID = A.CHILD_ITEM_ID      ' + char(10)
             SELECT @v_dSql += '                        AND OPERATION_ID = I.OPERATION_ID  ' + char(10)
             SELECT @v_dSql += '                        AND LINE_ID = I.LINE_ID            ' + char(10)
             SELECT @v_dSql += '                        AND START_TIME <= A.PLAN_DATE      ' + char(10)
             SELECT @v_dSql += '                        AND END_TIME >= A.PLAN_DATE        ' + char(10)
             SELECT @v_dSql += '                        AND  ( ACTIVE_FLAG = ''N'' OR PRIORITY = 0 OR PRIORITY = 9 )  ' + char(10)
             SELECT @v_dSql += '                        )  ' + char(10)
             SELECT @v_dSql += ' ) A  ' + char(10)
             SELECT @v_dSql += ' WHERE ORD_PRIORITY = 1  ' + char(10)
             SELECT @v_dSql += ' AND NOT EXISTS (        ' + char(10)
             SELECT @v_dSql += '                SELECT 1 FROM DBO.FP_ORDER_PEGGING_R B WITH(NOLOCK) ' + char(10)
             SELECT @v_dSql += '                WHERE B.FP_PLAN_ID       = A.FP_PLAN_ID             ' + char(10)
             SELECT @v_dSql += '                AND   B.TO_WORK_ORDER_ID = A.WORK_ORDER_ID          ' + char(10)
             SELECT @v_dSql += '                AND   B.FROM_ITEM_ID     = A.CHILD_ITEM_ID          ' + char(10)
             SELECT @v_dSql += ' )  ' + char(10)

			 IF @p_sys_type = 'SQL'
			 	BEGIN
			 		--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
			 		SELECT @v_dSql as [QUERY_VALUE]
			 
			 	END  
			 ELSE 
			 	BEGIN
			 		SET @runstart = GetDate()
			 		--쿼리실행
			 		EXEC sp_executesql @v_dSql
			 
			 		SET @runend = GetDate()
			 		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'select',@runstart, @runend
			 	END	
		END
    /************************************************************************************************/
	/* Group Release Total 팝업화면 EXECUTE_GROUP_CALCURATION경우 :(EXECUTE_CALCURATION )                        */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_GROUP_CALCURATION')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
			--Log
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_FP_CALCURATION] '''+ @p_instance_id +''', '''+ @p_next_plan_id +'''  '

			BEGIN TRY
		        BEGIN
				    --Log :Start
				    EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, 'PR_SCM_FP_CALCURATION', '', @v_dSql, 'select:START', @runstart, @runend
		    	    
					--실제수행
			        EXEC @rtnCount = [dbo].[PR_SCM_FP_CALCURATION] @p_instance_id, @p_next_plan_id

					SELECT @runend = GETDATE()
					--Log :End
					EXEC PR_UI_SQL_LOG @v_proc_name, @p_user_id, 'PR_SCM_FP_CALCURATION', '', @v_dSql, 'select:END', @runstart, @runend
		    	    SELECT 'Result' = @rtnCount 
		    	END
		    END TRY
		    BEGIN CATCH                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
		    	-- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
		    	SET @v_log_message = ERROR_MESSAGE()
		    	EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'PR_SCM_FP_CALCURATION','',@v_log_message,'excute',@runstart, @runend
                
				SET @rtnCount = -1
		    	--SELECT 'Result' = @rtnCount 
				SELECT 'Result' = -99 -- 에러 리턴값 고정 처리... 하위 프로시저에서 오류날경우 상위로 올라옴
		    
		    END CATCH    
		END
    /************************************************************************************************/
	/* Release Total 팝업화면 EXECUTE_GROUP_RESCHEDULE경우 :(EXECUTE_GROUP_RESCHEDULE )                        */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_GROUP_RESCHEDULE')
	    BEGIN --ELSE IF(START)
		    --LOG
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_RF_PLAN_GROUP_RESCHEDULE]  '''+ @p_instance_id +''', '''+ @p_next_plan_id +''', '''+ @p_factory_id +'''  '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_SCM_RF_PLAN_GROUP_RESCHEDULE','',@v_dSql,'select',@runstart, @runend

			--실제수행
			EXEC  @rtnCount = [dbo].[PR_SCM_RF_PLAN_GROUP_RESCHEDULE] @p_instance_id, @p_next_plan_id, @p_factory_id
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount
   --         IF @p_sys_type = 'SQL'
			--	BEGIN
			--		EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--		SELECT @v_dSql as [QUERY_VALUE]

			--	END  
			--ELSE 
			--	BEGIN
			--		SET @runstart = GetDate()
			--		--쿼리실행
			--		EXEC sp_executesql @v_dSql

			--		SET @runend = GetDate()
			--		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--	END	
		END
    /************************************************************************************************/
	/* Group Release Total 팝업화면 EXECUTE_GROUP_RELEASE경우 :(EXECUTE_GROUP_RELEASE )                              */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_GROUP_RELEASE')
	    BEGIN --ELSE IF(START)

		    SELECT @v_dSql = ''
			--LOG
			SET @runstart = GetDate()
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_FP_CONFIRM_RELEASE]  '''+ @p_instance_id +''', '''+ @p_next_plan_id +''', '''+ @p_factory_id +''', '''+ @p_user_id +''' '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_SCM_FP_CONFIRM_RELEASE','',@v_dSql,'select(START)',@runstart, NULL

			--실제수행
			EXEC  @rtnCount = [dbo].[PR_SCM_FP_CONFIRM_RELEASE] @p_instance_id, @p_next_plan_id, @p_factory_id, @p_user_id

			SET @runend = GetDate()
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_SCM_FP_CONFIRM_RELEASE','',@v_dSql,'select(END)',@runstart, @runend
			
            SELECT	'Result' = @rtnCount
   --         IF @p_sys_type = 'SQL'
			--	BEGIN
			--		EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--		SELECT @v_dSql as [QUERY_VALUE]

			--	END  
			--ELSE 
			--	BEGIN
			--		SET @runstart = GetDate()
			--		--쿼리실행
			--		EXEC sp_executesql @v_dSql

			--		SET @runend = GetDate()
			--		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--	END	
		END
    /************************************************************************************************/
	/* Group Release Total 팝업화면 EXECUTE_GROUP_SENDMAIL_QUANTITY_CHECK경우 :(수량검정메일 )                  */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_GROUP_SENDMAIL_QUANTITY_CHECK')
	    BEGIN --ELSE IF(START)
		    --LOG
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_PLAN_RESULT_SEND]  '''+ @p_instance_id +''', '''+ @p_plan_date +''', ''NULL'', '''+ @p_factory_id +'''  '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_SCM_PLAN_RESULT_SEND','',@v_dSql,'select',@runstart, @runend

			--실제수행
			EXEC  @rtnCount = [dbo].[PR_SCM_PLAN_RESULT_SEND] @p_instance_id, @p_plan_date, NULL, @p_factory_id
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount
   --         IF @p_sys_type = 'SQL'
			--	BEGIN
			--		EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--		SELECT @v_dSql as [QUERY_VALUE]

			--	END  
			--ELSE 
			--	BEGIN
			--		SET @runstart = GetDate()
			--		--쿼리실행
			--		EXEC sp_executesql @v_dSql

			--		SET @runend = GetDate()
			--		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--	END	
		END
    /************************************************************************************************/
	/* Group Release Total 팝업화면 EXECUTE_GROUP_RELEASE_PLAN_SEND경우 :(executeSendTotal 메일 )                  */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_GROUP_RELEASE_PLAN_SEND')
	    BEGIN --ELSE IF(START)
			/* 2023-07-20 PR_SCM_RELEASE_PLAN_ATTACH_FILE 호출로 변경 */
			/*
		    --LOG
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_RELEASE_PLAN_SEND]  '''+ @p_instance_id +''', '''+ @p_plan_date +''', ''NULL'', '''+ @p_factory_id +''',  '''+ @p_description +''' '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_SCM_RELEASE_PLAN_SEND','',@v_dSql,'select',@runstart, @runend

			--실제수행
			EXEC  @rtnCount = [dbo].[PR_SCM_RELEASE_PLAN_SEND] @p_instance_id, @p_plan_date, NULL, @p_factory_id, @p_description
			
            SELECT	'Result' = @rtnCount
			*/

			/* 2023-07-20 PR_SCM_RELEASE_PLAN_ATTACH_FILE 호출로 변경 */
		    --LOG 
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_RELEASE_PLAN_ATTACH_FILE]  '''+ @p_instance_id +''', '''+ @p_plan_date +''', ''NULL'', '''+ @p_factory_id +''',  '''+ @p_description +''' '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_SCM_RELEASE_PLAN_ATTACH_FILE','',@v_dSql,'select',@runstart, @runend

			--실제수행
			EXEC  [dbo].[PR_SCM_RELEASE_PLAN_ATTACH_FILE] 
						@P_INSTANCE_ID     = @p_instance_id
					, @P_INSTANCE_DATE   = @p_plan_date
					, @P_FACTORY_ID      = NULL
					, @P_PLAN_GROUP_ID   = @p_factory_id
					, @P_PLAN_DESCRIPTION   =  @p_description
			
			SET @rtnCount = 1
			SELECT	'Result' = @rtnCount
   --         IF @p_sys_type = 'SQL'
			--	BEGIN
			--		EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--		SELECT @v_dSql as [QUERY_VALUE]

			--	END  
			--ELSE 
			--	BEGIN
			--		SET @runstart = GetDate()
			--		--쿼리실행
			--		EXEC sp_executesql @v_dSql

			--		SET @runend = GetDate()
			--		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--	END	
		END
    /************************************************************************************************/
	/* Release Total 팝업화면 EXECUTE_SMS경우 :(담당자SMS발송 )                  */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_SMS')
	    BEGIN --ELSE IF(START)
		    --LOG
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_CONFIRM_SMS_SEND]  '''+ @p_instance_id +''', '''+ @p_plan_id +''', '''+ @p_factory_id +'''  '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_SCM_CONFIRM_SMS_SEND','',@v_dSql,'select',@runstart, @runend

			--실제수행
			EXEC  @rtnCount = [dbo].[PR_SCM_CONFIRM_SMS_SEND] @p_instance_id, @p_plan_id, @p_factory_id
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount
   --         IF @p_sys_type = 'SQL'
			--	BEGIN
			--		EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--		SELECT @v_dSql as [QUERY_VALUE]

			--	END  
			--ELSE 
			--	BEGIN
			--		SET @runstart = GetDate()
			--		--쿼리실행
			--		EXEC sp_executesql @v_dSql

			--		SET @runend = GetDate()
			--		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--	END	
		END
    /************************************************************************************************/
	/* Release Total 팝업화면 EXECUTE_MES_ERP_WO_MASTER경우 :                                       */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_MES_ERP_WO_MASTER')
	    BEGIN --ELSE IF(START)
		    --LOG
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_XIF_MES_ERP_WO_MASTER]  '''+ @p_plan_id +''' '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_XIF_MES_ERP_WO_MASTER','',@v_dSql,'select',@runstart, @runend

			--실제수행
			EXEC  @rtnCount = [dbo].[PR_XIF_MES_ERP_WO_MASTER] @p_plan_id
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount
   --         IF @p_sys_type = 'SQL'
			--	BEGIN
			--		EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--		SELECT @v_dSql as [QUERY_VALUE]

			--	END  
			--ELSE 
			--	BEGIN
			--		SET @runstart = GetDate()
			--		--쿼리실행
			--		EXEC sp_executesql @v_dSql

			--		SET @runend = GetDate()
			--		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--	END	
		END
    /************************************************************************************************/
	/* Release Total 팝업화면 EXECUTE_PR_SCM_OF_ASSY_ELEC_REPORT경우 :                                       */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_PR_SCM_OF_ASSY_ELEC_REPORT')
	    BEGIN --ELSE IF(START)
		    --LOG
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_OF_ASSY_ELEC_REPORT]  '''+ @p_instance_id +''' '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_SCM_OF_ASSY_ELEC_REPORT','',@v_dSql,'select',@runstart, @runend

			--실제수행
			EXEC  @rtnCount = [dbo].[PR_SCM_OF_ASSY_ELEC_REPORT] @p_instance_id
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount
   --         IF @p_sys_type = 'SQL'
			--	BEGIN
			--		EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--		SELECT @v_dSql as [QUERY_VALUE]

			--	END  
			--ELSE 
			--	BEGIN
			--		SET @runstart = GetDate()
			--		--쿼리실행
			--		EXEC sp_executesql @v_dSql

			--		SET @runend = GetDate()
			--		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--	END	
		END
    /************************************************************************************************/
	/* Release Total 팝업화면 EXECUTE_PR_SCM_OF_PACK_REQUIRE_CEL경우 :                                       */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_PR_SCM_OF_PACK_REQUIRE_CEL')
	    BEGIN --ELSE IF(START)
		    --LOG
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_OF_PACK_REQUIRE_CEL]  '''+ @p_instance_id +''', '''', ''Y'', '''', '''', ''N'', '''+ @p_user_id +''', ''NULL'' '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_SCM_OF_PACK_REQUIRE_CEL','',@v_dSql,'select',@runstart, @runend

			--실제수행
			EXEC  @rtnCount = [dbo].[PR_SCM_OF_PACK_REQUIRE_CEL] @p_instance_id, '', 'Y', '', '','N',  @p_user_id, NULL
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount
   --         IF @p_sys_type = 'SQL'
			--	BEGIN
			--		EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--		SELECT @v_dSql as [QUERY_VALUE]

			--	END  
			--ELSE 
			--	BEGIN
			--		SET @runstart = GetDate()
			--		--쿼리실행
			--		EXEC sp_executesql @v_dSql

			--		SET @runend = GetDate()
			--		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--	END	
		END
    /************************************************************************************************/
	/* Release Total 팝업화면 EXECUTE_PR_SCM_OF_PACK_TO_CELL경우 :                                       */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_PR_SCM_OF_PACK_TO_CELL')
	    BEGIN --ELSE IF(START)
		    --LOG
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_OF_PACK_TO_CELL]  '''+ @p_instance_id +''', '''+ @p_plan_id +''' '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_SCM_OF_PACK_TO_CELL','',@v_dSql,'select',@runstart, @runend

			--실제수행
			EXEC  @rtnCount = [dbo].[PR_SCM_OF_PACK_TO_CELL ] @p_instance_id, @p_plan_id
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount
   --         IF @p_sys_type = 'SQL'
			--	BEGIN
			--		EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--		SELECT @v_dSql as [QUERY_VALUE]

			--	END  
			--ELSE 
			--	BEGIN
			--		SET @runstart = GetDate()
			--		--쿼리실행
			--		EXEC sp_executesql @v_dSql

			--		SET @runend = GetDate()
			--		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--	END	
		END
    /************************************************************************************************/
	/* Release Total 팝업화면 EXECUTE_PR_SCM_OF_CELL_DELIVERY_PLAN경우 :                                       */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_PR_SCM_OF_CELL_DELIVERY_PLAN')
	    BEGIN --ELSE IF(START)
		    --LOG
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_SCM_OF_CELL_DELIVERY_PLAN]  '''+ @p_instance_id +''', '''', ''Y'', '''', '''', ''N'', '''+ @p_user_id +''', ''NULL'' '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_SCM_OF_CELL_DELIVERY_PLAN','',@v_dSql,'select',@runstart, @runend

			--실제수행
			EXEC  @rtnCount = [dbo].[PR_SCM_OF_CELL_DELIVERY_PLAN] @p_instance_id, '', 'Y', '', '', 'N',  @p_user_id, NULL
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount
   --         IF @p_sys_type = 'SQL'
			--	BEGIN
			--		EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--		SELECT @v_dSql as [QUERY_VALUE]

			--	END  
			--ELSE 
			--	BEGIN
			--		SET @runstart = GetDate()
			--		--쿼리실행
			--		EXEC sp_executesql @v_dSql

			--		SET @runend = GetDate()
			--		EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
			--	END	
		END
	ELSE
		-- 트랜잭션 (TRAN)
		BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		BEGIN TRAN   

		BEGIN --ELSE ( BEGIN )
		    --max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
			WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
			    BEGIN --WHILE 내(START)
					 
						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가

						SELECT @v_sys_type     = [dbo].[SCM_ARR_SPL_VAL](@p_sys_type,      @v_delimiter, @mst_loop_cnt)
                             , @v_sys_flag     = [dbo].[SCM_ARR_SPL_VAL](@p_sys_flag,      @v_delimiter, @mst_loop_cnt)
                             , @v_sys_gubun    = [dbo].[SCM_ARR_SPL_VAL](@p_sys_gubun,     @v_delimiter, @mst_loop_cnt)
                             , @v_user_id      = [dbo].[SCM_ARR_SPL_VAL](@p_user_id,       @v_delimiter, @mst_loop_cnt)
                             , @v_division_id  = [dbo].[SCM_ARR_SPL_VAL](@p_division_id,   @v_delimiter, @mst_loop_cnt)
                             , @v_site_id      = [dbo].[SCM_ARR_SPL_VAL](@p_site_id,       @v_delimiter, @mst_loop_cnt)
                             , @v_factory_id   = [dbo].[SCM_ARR_SPL_VAL](@p_factory_id,    @v_delimiter, @mst_loop_cnt)
                             , @v_instance_id  = [dbo].[SCM_ARR_SPL_VAL](@p_instance_id,   @v_delimiter, @mst_loop_cnt)
                             , @v_plan_date    = [dbo].[SCM_ARR_SPL_VAL](@p_plan_date,     @v_delimiter, @mst_loop_cnt)
                             , @v_plan_id      = [dbo].[SCM_ARR_SPL_VAL](@p_plan_id,       @v_delimiter, @mst_loop_cnt)
                             , @v_flag         = [dbo].[SCM_ARR_SPL_VAL](@p_flag,          @v_delimiter, @mst_loop_cnt)
                             , @v_insert_time  = [dbo].[SCM_ARR_SPL_VAL](@p_insert_time,   @v_delimiter, @mst_loop_cnt)
                             , @v_release_time = [dbo].[SCM_ARR_SPL_VAL](@p_release_time,  @v_delimiter, @mst_loop_cnt)
                             , @v_is_enable_rel= [dbo].[SCM_ARR_SPL_VAL](@p_is_enable_rel, @v_delimiter, @mst_loop_cnt)
                             , @v_confirm_id   = [dbo].[SCM_ARR_SPL_VAL](@p_confirm_id,    @v_delimiter, @mst_loop_cnt)
                             , @v_confirm_time = [dbo].[SCM_ARR_SPL_VAL](@p_confirm_time,  @v_delimiter, @mst_loop_cnt)
                             , @v_description  = [dbo].[SCM_ARR_SPL_VAL](@p_description,   @v_delimiter, @mst_loop_cnt)
                             , @v_isenable     = [dbo].[SCM_ARR_SPL_VAL](@p_isenable,      @v_delimiter, @mst_loop_cnt)
                             , @v_ischk        = [dbo].[SCM_ARR_SPL_VAL](@p_ischk,         @v_delimiter, @mst_loop_cnt)
                             , @v_next_plan_id = [dbo].[SCM_ARR_SPL_VAL](@p_next_plan_id,  @v_delimiter, @mst_loop_cnt)
                             , @v_release_flag = [dbo].[SCM_ARR_SPL_VAL](@p_release_flag,  @v_delimiter, @mst_loop_cnt)
                             , @v_plan_type    = [dbo].[SCM_ARR_SPL_VAL](@p_plan_type,     @v_delimiter, @mst_loop_cnt)
                             , @v_plan_type    = [dbo].[SCM_ARR_SPL_VAL](@p_plan_type,     @v_delimiter, @mst_loop_cnt)
                        
					   /******************************************************************************/
					   /* INSERT 경우 : INSERT_RUNNING_RELEASE                                      */
					   /******************************************************************************/
					   IF(@v_sys_flag ='INSERT_RUNNING_RELEASE')  
							BEGIN
                                SELECT @v_dSql = ''

                                SELECT @v_dSql  = '  INSERT INTO FP_IS_RUNNING_RELEASE_H (           ' + char(10)
                                SELECT @v_dSql += '  	 INSTANCE_ID,   RELEASE_TYPE,    FP_PLAN_ID  ' + char(10)
                                SELECT @v_dSql += '  	,ACTIVE_FLAG,   INSERT_ID,       INSERT_TIME ' + char(10)
                                SELECT @v_dSql += '  )                                               ' + char(10)
                                SELECT @v_dSql += '  SELECT *                                        ' + char(10)
                                SELECT @v_dSql += '  FROM (                                          ' + char(10)
                                SELECT @v_dSql += '  	SELECT '''+ @v_instance_id +''' AS INSTANCE_ID, '''+ @v_factory_id +''' AS RELEASE_TYPE  ' + char(10)
                                SELECT @v_dSql += '  		 ,'''+ @v_plan_id +''' AS FP_PLAN_ID, ''Y'' AS ACTIVE_FLAG     ' + char(10)
                                SELECT @v_dSql += '  		 , '''+@v_user_id +''' AS INSERT_ID, GETDATE() AS INSERT_TIME  ' + char(10)
                                SELECT @v_dSql += '  ) A ' + char(10)
								
						   END --'I'
					   /******************************************************************************/
					   /* INSERT 경우 : INSERT_RUNNING_RELEASE                                      */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_OT_NET_JOB')  
							BEGIN
                                SELECT @v_dSql = ''

                                SELECT @v_dSql  = '  INSERT INTO FP_NETJOB_QUEUE (             ' + char(10)
                                SELECT @v_dSql += '  	 INSTANCE_DATE                         ' + char(10)
                                SELECT @v_dSql += '  	,INSTANCE_ID                           ' + char(10)
                                SELECT @v_dSql += '  	,FP_PLAN_ID                            ' + char(10)
                                SELECT @v_dSql += '  	,PROC_NAME                             ' + char(10)
                                SELECT @v_dSql += '  	,JOB_SEQ                               ' + char(10)
                                SELECT @v_dSql += '  	,JOB_TYPE                              ' + char(10)
                                SELECT @v_dSql += '  	,ACTIVE_FLAG                           ' + char(10)
                                SELECT @v_dSql += '  	,PARAMETER1                            ' + char(10)
                                SELECT @v_dSql += '  	,PARAMETER2                            ' + char(10)
                                SELECT @v_dSql += '  	,INSERT_ID                             ' + char(10)
                                SELECT @v_dSql += '  	,INSERT_DTTM                           ' + char(10)
                                SELECT @v_dSql += '  	,UPDATE_ID                             ' + char(10)
                                SELECT @v_dSql += '  	,UPDATE_DTTM                           ' + char(10)
                                SELECT @v_dSql += '  )                                         ' + char(10)
                                SELECT @v_dSql += '  SELECT '''+ @v_plan_date +'''             ' + char(10)
                                SELECT @v_dSql += '  	, '''+ @v_instance_id +'''             ' + char(10)
                                SELECT @v_dSql += '  	, '''+ @v_plan_id +'''                 ' + char(10)
                                SELECT @v_dSql += '  	, ''PR_SCM_OF_DEMAND_ORDER_TRACKING''  ' + char(10)
                                SELECT @v_dSql += '  	, NEXT VALUE FOR SEQ_FP_NETJOB         ' + char(10)
                                SELECT @v_dSql += '  	, ''R''                                ' + char(10)
                                SELECT @v_dSql += '  	, ''Y''                                ' + char(10)
                                SELECT @v_dSql += '  	, '''+ @v_instance_id +'''             ' + char(10)
                                SELECT @v_dSql += '  	, ''-''                                ' + char(10)
                                SELECT @v_dSql += '  	, '''+ @v_user_id +'''                 ' + char(10)
                                SELECT @v_dSql += '  	, GETDATE()                            ' + char(10)
                                SELECT @v_dSql += '  	, '''+ @v_user_id +'''                 ' + char(10)
                                SELECT @v_dSql += '  	, GETDATE()                            ' + char(10)

						   END --'I'
					   /******************************************************************************/
					   /* INSERT 경우 : INSERT_QUEUE                                      */
					   /******************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_QUEUE')  
							BEGIN
                                SELECT @v_dSql = ''

                                SELECT @v_dSql +=  ' INSERT INTO FP_NETJOB_QUEUE (               ' + char(10)
                                SELECT @v_dSql +=  ' 	 INSTANCE_DATE                           ' + char(10)
                                SELECT @v_dSql +=  ' 	,INSTANCE_ID                             ' + char(10)
                                SELECT @v_dSql +=  ' 	,FP_PLAN_ID                              ' + char(10)
                                SELECT @v_dSql +=  ' 	,PROC_NAME                               ' + char(10)
                                SELECT @v_dSql +=  ' 	,JOB_SEQ                                 ' + char(10)
                                SELECT @v_dSql +=  ' 	,JOB_TYPE                                ' + char(10)
                                SELECT @v_dSql +=  ' 	,ACTIVE_FLAG                             ' + char(10)
                                SELECT @v_dSql +=  ' 	,PARAMETER1                              ' + char(10)
                                SELECT @v_dSql +=  ' 	,PARAMETER2                              ' + char(10)
                                SELECT @v_dSql +=  ' 	,PARAMETER3                              ' + char(10)
                                SELECT @v_dSql +=  ' 	,PARAMETER4                              ' + char(10)
                                SELECT @v_dSql +=  ' 	,PARAMETER5                              ' + char(10)
                                SELECT @v_dSql +=  ' 	,ATTRIBUTE1                              ' + char(10)
                                SELECT @v_dSql +=  ' 	,ATTRIBUTE2                              ' + char(10)
								SELECT @v_dSql +=  ' 	,ATTRIBUTE3 ' + char(10) -- MRP Transit
                                SELECT @v_dSql +=  ' 	,INSERT_ID                               ' + char(10)
                                SELECT @v_dSql +=  ' 	,INSERT_DTTM                             ' + char(10)
                                SELECT @v_dSql +=  ' 	,UPDATE_ID                               ' + char(10)
                                SELECT @v_dSql +=  ' 	,UPDATE_DTTM                             ' + char(10)
                                SELECT @v_dSql +=  ' )                                           ' + char(10)
                                SELECT @v_dSql +=  ' SELECT '''+ @v_plan_date +'''               ' + char(10)
                                SELECT @v_dSql +=  ' 	, '''+ @v_instance_id +'''               ' + char(10)
                                SELECT @v_dSql +=  ' 	, '''+ @v_next_plan_id +'''              ' + char(10)
                                SELECT @v_dSql +=  ' 	, ''PR_SCM_OF_RELEASE_AUTO_PROCESSING''  ' + char(10)
                                SELECT @v_dSql +=  ' 	, NEXT VALUE FOR SEQ_FP_NETJOB           ' + char(10)
                                SELECT @v_dSql +=  ' 	, ''R''                                  ' + char(10)
                                SELECT @v_dSql +=  ' 	, ''Y''                                  ' + char(10)
                                SELECT @v_dSql +=  ' 	, '''+ @v_instance_id +'''               ' + char(10)
                                SELECT @v_dSql +=  ' 	, '''+ @v_next_plan_id +'''              ' + char(10)
                                SELECT @v_dSql +=  ' 	, '''+ @v_division_id +'''               ' + char(10)
                                SELECT @v_dSql +=  ' 	, '''+ @v_site_id +'''                   ' + char(10)
                                SELECT @v_dSql +=  ' 	, '''+ @v_factory_id +'''                ' + char(10)
                                SELECT @v_dSql +=  ' 	, N'''+ @v_description +'''              ' + char(10)
                                SELECT @v_dSql +=  ' 	, '''+ @v_user_id +'''                   ' + char(10)
								SELECT @v_dSql +=  ' 	, '''+ @v_release_flag +''' ' + char(10) -- MRP Transit
                                SELECT @v_dSql +=  ' 	, '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql +=  ' 	, GETDATE()                              ' + char(10)
                                SELECT @v_dSql +=  ' 	, '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql +=  ' 	, GETDATE()                              ' + char(10)

						   END --'I'
					   /****************************************************************************/
					   /* DELETE  경우  :DELETE_RUNNING_RELEASE                                     */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='DELETE_RUNNING_RELEASE')
							BEGIN
							    SELECT @v_dSql = ''
                                SELECT @v_dSql += '  DELETE FROM FP_IS_RUNNING_RELEASE_H             ' + char(10)
                                SELECT @v_dSql += '  WHERE  INSTANCE_ID  = '''+ @v_instance_id +'''  ' + char(10)
								SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('RELEASE_TYPE' , 'EQ', @v_factory_id))    + char(10)
					 
                            END --M
					   /****************************************************************************/
					   /* UPDATE  경우  :UPDATE_GROUP_DIVISIONLIST                                 */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_GROUP_DIVISIONLIST')
						   BEGIN
								SELECT @v_dSql = ''
                                SELECT @v_dSql += ' MERGE INTO SCM_FP_PLAN_GROUP_DETAIL_H AS A ' + char(10)
                                SELECT @v_dSql += ' USING (  SELECT '''+ @v_plan_date +''' AS PLAN_DATE, '''+ @v_instance_id +''' AS INSTANCE_ID ' + char(10)
                                SELECT @v_dSql += '             , '''+ @v_division_id +''' AS DIVISION_ID, '''+ @v_factory_id +''' AS FACTORY_ID ' + char(10)
                                SELECT @v_dSql += '        ) AS B                          ' + char(10)
                                SELECT @v_dSql += '   ON (A.PLAN_DATE      = B.PLAN_DATE   ' + char(10)
                                SELECT @v_dSql += '   AND A.INSTANCE_ID    = B.INSTANCE_ID ' + char(10)
                                SELECT @v_dSql += '   AND A.PLAN_GROUP_ID  = B.FACTORY_ID) ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                      ' + char(10)
                                SELECT @v_dSql += '     UPDATE SET                         ' + char(10)
                                SELECT @v_dSql += '         PLAN_ID           = '''+ @v_next_plan_id +'''              ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_ID        = '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_TIME      = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_FLAG      = ''P'' ' + char(10)
                                SELECT @v_dSql += '       , RELEASE_TIME      = NULL  ' + char(10)
                                SELECT @v_dSql += '       , RELEASE_FLAG      = ''N'' ' + char(10)
                                SELECT @v_dSql += '       , RELEASE_PLAN_ID   = NULL  ' + char(10)
                                SELECT @v_dSql += '       , MES_TRANSFER_FLAG = ''N'' ' + char(10)
                                SELECT @v_dSql += '       , MES_TRANSFER_TIME = NULL  ' + char(10)
                                --SELECT @v_dSql += '       , DESCRIPTION       = N'''+ @v_description +'''              ' + char(10)
                                SELECT @v_dSql += '       , DESCRIPTION       = (CASE WHEN N''' + @v_description + ''' = '''' OR N''' + @v_description + ''' IS NULL THEN NULL ELSE N''' + @v_description + ''' END)              ' + char(10)
                                SELECT @v_dSql += '       , UPDATE_ID         = '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql += '       , UPDATE_TIME       = DBO.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN ' + char(10)
                                SELECT @v_dSql += '     INSERT (          ' + char(10)
                                SELECT @v_dSql += '         PLAN_DATE     ' + char(10)
                                SELECT @v_dSql += '       , INSTANCE_ID   ' + char(10)
                                SELECT @v_dSql += '       , PLAN_GROUP_ID ' + char(10)
                                SELECT @v_dSql += '       , PLAN_ID       ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_ID    ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_TIME  ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_FLAG  ' + char(10)
                                SELECT @v_dSql += '       , DESCRIPTION   ' + char(10)
                                SELECT @v_dSql += '       , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME ' + char(10)
                                SELECT @v_dSql += '     ) VALUES (                                         ' + char(10)
                                SELECT @v_dSql += '         '''+ @v_plan_date +'''                         ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_instance_id +'''                       ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_factory_id +'''                        ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_next_plan_id +'''                      ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_user_id +'''                           ' + char(10)
                                SELECT @v_dSql += '       , dbo.FN_SITE_TIME('''+ @v_site_id +''')         ' + char(10)
                                SELECT @v_dSql += '       , ''P''                     ' + char(10)
                                --SELECT @v_dSql += '       , N'''+ @v_description +''' ' + char(10)
                                SELECT @v_dSql += '       , (CASE WHEN N''' + @v_description + ''' = '''' OR N''' + @v_description + ''' IS NULL THEN NULL ELSE N''' + @v_description + ''' END) ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +'''), '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '   ); ' + char(10)

                                SELECT @v_dSql += ' MERGE INTO HIS_FP_PLAN_GROUP_DETAIL_H AS A                                                   ' + char(10)
                                SELECT @v_dSql += ' USING ( SELECT '''+ @v_plan_date +''' AS PLAN_DATE, '''+ @v_instance_id +'''  AS INSTANCE_ID ' + char(10)
                                SELECT @v_dSql += '             , '''+ @v_factory_id +''' AS PLAN_GROUP_ID, '''+ @v_next_plan_id +''' AS PLAN_ID ' + char(10)
                                SELECT @v_dSql += '       ) AS B                              ' + char(10)
                                SELECT @v_dSql += '     ON (A.PLAN_DATE     = B.PLAN_DATE     ' + char(10)
                                SELECT @v_dSql += '     AND A.INSTANCE_ID   = B.INSTANCE_ID   ' + char(10)
                                SELECT @v_dSql += '     AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID ' + char(10)
                                SELECT @v_dSql += '     AND A.PLAN_ID       = B.PLAN_ID)      ' + char(10)
                                SELECT @v_dSql += ' WHEN MATCHED THEN                         ' + char(10)
                                SELECT @v_dSql += '     UPDATE SET                            ' + char(10)
                                SELECT @v_dSql += '         PLAN_ID           = '''+ @v_next_plan_id +'''              ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_ID        = '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_TIME      = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_FLAG      = ''Y'' ' + char(10)
                                SELECT @v_dSql += '       , RELEASE_TIME      = NULL  ' + char(10)
                                SELECT @v_dSql += '       , RELEASE_FLAG      = ''N'' ' + char(10)
                                SELECT @v_dSql += '       , RELEASE_PLAN_ID   = NULL  ' + char(10)
                                SELECT @v_dSql += '       , MES_TRANSFER_FLAG = ''N'' ' + char(10)
                                SELECT @v_dSql += '       , MES_TRANSFER_TIME = NULL  ' + char(10)
                                SELECT @v_dSql += '       , UPDATE_ID         = '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql += '       , UPDATE_TIME       = DBO.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += ' WHEN NOT MATCHED THEN     ' + char(10)
                                SELECT @v_dSql += '     INSERT (              ' + char(10)
                                SELECT @v_dSql += '         PLAN_DATE         ' + char(10)
                                SELECT @v_dSql += '       , INSTANCE_ID       ' + char(10)
                                SELECT @v_dSql += '       , PLAN_GROUP_ID     ' + char(10)
                                SELECT @v_dSql += '       , PLAN_ID           ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_ID        ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_TIME      ' + char(10)
                                SELECT @v_dSql += '       , CONFIRM_FLAG      ' + char(10)
                                SELECT @v_dSql += '       , RELEASE_TIME      ' + char(10)
                                SELECT @v_dSql += '       , RELEASE_FLAG      ' + char(10)
                                SELECT @v_dSql += '       , RELEASE_PLAN_ID   ' + char(10)
                                SELECT @v_dSql += '       , DESCRIPTION       ' + char(10)
                                SELECT @v_dSql += '       , MES_TRANSFER_FLAG ' + char(10)
                                SELECT @v_dSql += '       , MES_TRANSFER_TIME ' + char(10)
                                SELECT @v_dSql += '       , INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME ' + char(10)
                                SELECT @v_dSql += '       , JOB_USER_ID, JOB_TIME, JOB_TYPE                ' + char(10)
                                SELECT @v_dSql += '     ) VALUES (                    ' + char(10)
                                SELECT @v_dSql += '         '''+ @v_plan_date +'''    ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_instance_id +'''  ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_factory_id +'''   ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_next_plan_id +''' ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_user_id +'''      ' + char(10)
                                SELECT @v_dSql += '       , dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '       , ''Y''                     ' + char(10)
                                SELECT @v_dSql += '       , NULL                      ' + char(10)
                                SELECT @v_dSql += '       , ''N''                     ' + char(10)
                                SELECT @v_dSql += '       , NULL                      ' + char(10)
                                --SELECT @v_dSql += '       , N'''+ @v_description +''' ' + char(10)
                                SELECT @v_dSql += '       , (CASE WHEN N''' + @v_description + ''' = '''' OR N''' + @v_description + ''' IS NULL THEN NULL ELSE N''' + @v_description + ''' END) ' + char(10)
								SELECT @v_dSql += '       , ''N''                     ' + char(10)
                                SELECT @v_dSql += '       , NULL                      ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +'''), '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += '       , '''+ @v_user_id +''', dbo.FN_SITE_TIME('''+ @v_site_id +'''), ''CONFIRM'' ' + char(10)
                                SELECT @v_dSql += '   ); ' + char(10)

                                SELECT @v_dSql += ' UPDATE SCM_FP_PLAN_H SET                                     ' + char(10)
                                SELECT @v_dSql += '        CONFIRM_FLAG = ''Y''                                  ' + char(10)
                                SELECT @v_dSql += '       ,CONFIRM_ID   = '''+ @v_user_id +'''                   ' + char(10)
                                SELECT @v_dSql += '       ,CONFIRM_TIME = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                                SELECT @v_dSql += ' WHERE  INSTANCE_ID ='''+ @v_instance_id +'''                 ' + char(10)
                                SELECT @v_dSql += ' AND    PLAN_ID     = '''+ @v_next_plan_id +'''               ' + char(10)

						   END --'M1'
					   /****************************************************************************/
					   /* UPDATE  경우  :UPDATE_GROUP_RELEASE_FLAG                                 */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_GROUP_RELEASE_FLAG')
						   BEGIN
								SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE SY_XIF_ERP_PRODUCTION_PLAN_S                       ' + char(10)
                                SELECT @v_dSql += ' SET    SY_XIF_ERP_PRODUCTION_PLAN_S.TRANSFER_FLAG = ''N'' ' + char(10)
                                SELECT @v_dSql += ' FROM   SY_XIF_ERP_PRODUCTION_PLAN_S A             ' + char(10)
                                SELECT @v_dSql += ' INNER JOIN SCM_FP_PLAN_GROUP_DETAIL_H B           ' + char(10)
                                SELECT @v_dSql += ' ON     A.FP_PLAN_ID    = B.RELEASE_PLAN_ID        ' + char(10)
                                SELECT @v_dSql += ' WHERE  B.PLAN_DATE     = '''+ @v_plan_date +'''   ' + char(10)
                                SELECT @v_dSql += ' AND    B.INSTANCE_ID   = '''+ @v_instance_id +''' ' + char(10)
                                SELECT @v_dSql += ' AND    B.RELEASE_FLAG  = ''Y''                    ' + char(10)
                                SELECT @v_dSql += ' AND    A.TRANSFER_FLAG = ''X''                    ' + char(10)
                                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLAN_ID' , 'EQ', @p_plan_id))    + char(10)
                                SELECT @v_dSql += '  ' + char(10)
                                SELECT @v_dSql += ' UPDATE SY_XIF_MES_WO_S                            ' + char(10)
                                SELECT @v_dSql += ' SET    SY_XIF_MES_WO_S.IF_FLAG = ''N''            ' + char(10)
                                SELECT @v_dSql += ' FROM   SY_XIF_MES_WO_S A                          ' + char(10)
                                SELECT @v_dSql += ' INNER JOIN SCM_FP_PLAN_GROUP_DETAIL_H B           ' + char(10)
                                SELECT @v_dSql += ' ON     A.PLAN_ID       = B.RELEASE_PLAN_ID        ' + char(10)
                                SELECT @v_dSql += ' WHERE  B.PLAN_DATE     = '''+ @v_plan_date +'''   ' + char(10)
                                SELECT @v_dSql += ' AND    B.INSTANCE_ID   = '''+ @v_instance_id +''' ' + char(10)
                                SELECT @v_dSql += ' AND    B.RELEASE_FLAG  = ''Y''                    ' + char(10)
                                SELECT @v_dSql += ' AND    A.IF_FLAG       = ''X''                    ' + char(10)
                                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLAN_ID' , 'EQ', @p_plan_id))    + char(10)
                                SELECT @v_dSql += '  ' + char(10)
                                SELECT @v_dSql += ' UPDATE SY_XIF_MES_DAILY_PP_S                      ' + char(10)
                                SELECT @v_dSql += ' SET    SY_XIF_MES_DAILY_PP_S.IF_FLAG = ''N''      ' + char(10)
                                SELECT @v_dSql += ' FROM   SY_XIF_MES_DAILY_PP_S A                    ' + char(10)
                                SELECT @v_dSql += ' INNER JOIN SCM_FP_PLAN_GROUP_DETAIL_H B           ' + char(10)
                                SELECT @v_dSql += ' ON     A.PLAN_ID       = B.RELEASE_PLAN_ID        ' + char(10)
                                SELECT @v_dSql += ' WHERE  B.PLAN_DATE     = '''+ @v_plan_date +'''   ' + char(10)
                                SELECT @v_dSql += ' AND    B.INSTANCE_ID   = '''+ @v_instance_id +''' ' + char(10)
         SELECT @v_dSql += ' AND    B.RELEASE_FLAG  = ''Y''                    ' + char(10)
                                SELECT @v_dSql += ' AND    A.IF_FLAG       = ''X''                    ' + char(10)
                                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLAN_ID' , 'EQ', @p_plan_id))    + char(10)
								-- PDS 테이블 추가... 20230920
                                SELECT @v_dSql += '  ' + char(10)
                                SELECT @v_dSql += ' UPDATE SY_XIF_PDS_WO_S                            ' + char(10)
                                SELECT @v_dSql += ' SET    SY_XIF_PDS_WO_S.IF_FLAG = ''N''            ' + char(10)
                                SELECT @v_dSql += ' FROM   SY_XIF_PDS_WO_S A                          ' + char(10)
                                SELECT @v_dSql += ' INNER JOIN SCM_FP_PLAN_GROUP_DETAIL_H B           ' + char(10)
                                SELECT @v_dSql += ' ON     A.PLAN_ID       = B.RELEASE_PLAN_ID        ' + char(10)
                                SELECT @v_dSql += ' WHERE  B.PLAN_DATE     = '''+ @v_plan_date +'''   ' + char(10)
                                SELECT @v_dSql += ' AND    B.INSTANCE_ID   = '''+ @v_instance_id +''' ' + char(10)
                                SELECT @v_dSql += ' AND    B.RELEASE_FLAG  = ''Y''                    ' + char(10)
                                SELECT @v_dSql += ' AND    A.IF_FLAG       = ''X''                    ' + char(10)
                                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLAN_ID' , 'EQ', @p_plan_id))    + char(10)
								/*
								-- 유효 인스턴스에 대해서만 업데이트
                                SELECT @v_dSql += ' AND    ''' + @v_instance_id + ''' IN ( ' + char(10)
                                SELECT @v_dSql += ' 	SELECT SEGMENT1 ' + char(10)
                                SELECT @v_dSql += ' 	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql += ' 	WHERE  1=1 ' + char(10)
                                SELECT @v_dSql += ' 	AND    LOOKUP_TYPE_CODE = ''PDS_INSTANCE'' ' + char(10)
                                SELECT @v_dSql += ' 	AND    ACTIVE_FLAG = ''Y'' ' + char(10)
                                SELECT @v_dSql += ' 	AND    SEGMENT2 = ''Y'' ' + char(10) -- USE FLAG
                                SELECT @v_dSql += ' 	AND    SEGMENT1 = ''' + @v_instance_id + ''' ' + char(10)
                                SELECT @v_dSql += ' )' + char(10)
								*/
                                SELECT @v_dSql += '  ' + char(10)
                                SELECT @v_dSql += ' UPDATE SCM_FP_PLAN_GROUP_DETAIL_H               ' + char(10)
                                SELECT @v_dSql += ' SET    MES_TRANSFER_FLAG = ''Y''                ' + char(10)
                                SELECT @v_dSql += '       ,MES_TRANSFER_TIME = GETDATE()            ' + char(10)
                                SELECT @v_dSql += ' WHERE  PLAN_DATE     = '''+ @v_plan_date +'''   ' + char(10)
                                SELECT @v_dSql += ' AND    INSTANCE_ID   = '''+ @v_instance_id +''' ' + char(10)
                                SELECT @v_dSql += ' AND    RELEASE_FLAG  = ''Y''                    ' + char(10)
                                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PLAN_ID' , 'EQ', @p_plan_id))    + char(10)


						   END --'M1'
					   /****************************************************************************/
					   /* UPDATE  경우  :UPDATE_GROUP_RELEASE_PLANLIST_2                                  */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='UPDATE_GROUP_RELEASE_PLANLIST_2')
						   BEGIN
								SELECT @v_dSql = ''
                                SELECT @v_dSql += ' UPDATE SCM_FP_PLAN_H SET                       ' + char(10)
                                SELECT @v_dSql += ' REL_DESC    = N'''+ @v_description +'''        ' + char(10)
                                SELECT @v_dSql += ' WHERE  INSTANCE_ID = '''+ @v_instance_id +'''  ' + char(10)
                                SELECT @v_dSql += ' AND    PLAN_ID     = '''+ @v_plan_id +'''      ' + char(10)

						   END --'M1'
					   /****************************************************************************/
					   /* DELETE Group RELEASE ROLLBACK  경우  :DELETE_RELEASE_ROLLBACK                  */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='DELETE_GROUP_RELEASE_ROLLBACK')
						   BEGIN
								SELECT @v_dSql = ''
                                SELECT @v_dSql += ' DELETE FROM SCM_FP_PLAN_GROUP_DETAIL_H         ' + char(10)
                                SELECT @v_dSql += ' WHERE  PLAN_DATE   = '''+ @v_plan_date +'''    ' + char(10)
                                SELECT @v_dSql += ' AND    INSTANCE_ID = '''+ @v_instance_id +'''  ' + char(10)
                                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PLAN_GROUP_ID' , 'EQ', @p_factory_id))    + char(10)
								SELECT @v_dSql += '    ' + char(10)
                                SELECT @v_dSql += ' DELETE FROM HIS_FP_PLAN_GROUP_DETAIL_H         ' + char(10)
                                SELECT @v_dSql += ' WHERE  PLAN_DATE   = '''+ @v_plan_date +'''    ' + char(10)
                                SELECT @v_dSql += ' AND    INSTANCE_ID = '''+ @v_instance_id +'''  ' + char(10)
                                SELECT @v_dSql += ' AND    PLAN_ID     = '''+ @v_plan_id +'''      ' + char(10)
                                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('PLAN_GROUP_ID' , 'EQ', @p_factory_id))    + char(10)

						   END --'M1'
					   /****************************************************************************/
					   /* INSERT Group RELEASE ROLLBACK  경우  :INSERT_GROUP_RELEASE_ROLLBACK                   */
					   /****************************************************************************/
					   ELSE IF(@v_sys_flag ='INSERT_GROUP_RELEASE_ROLLBACK')
						   BEGIN
								SELECT @v_dSql = ''
                                SELECT @v_dSql += ' INSERT INTO SCM_FP_PLAN_GROUP_DETAIL_H (    ' + char(10)
                                SELECT @v_dSql += ' 	  PLAN_DATE, INSTANCE_ID, PLAN_GROUP_ID ' + char(10)
                                SELECT @v_dSql += ' 	, PLAN_ID, CONFIRM_ID, CONFIRM_TIME, CONFIRM_FLAG ' + char(10)
                                SELECT @v_dSql += ' 	, RELEASE_TIME, RELEASE_FLAG, RELEASE_PLAN_ID, MES_TRANSFER_FLAG ' + char(10)
                                SELECT @v_dSql += ' 	, MES_TRANSFER_TIME, DESCRIPTION, INSERT_ID, INSERT_TIME         ' + char(10)
                                SELECT @v_dSql += ' 	, UPDATE_ID, UPDATE_TIME ' + char(10)
                                SELECT @v_dSql += ' )                            ' + char(10)
                                SELECT @v_dSql += ' SELECT A.PLAN_DATE, A.INSTANCE_ID,  A.PLAN_GROUP_ID            ' + char(10)
                                SELECT @v_dSql += '   	 , A.PLAN_ID, A.CONFIRM_ID, A.CONFIRM_TIME, A.CONFIRM_FLAG ' + char(10)
                                SELECT @v_dSql += '   	 , A.RELEASE_TIME, A.RELEASE_FLAG, A.RELEASE_PLAN_ID, A.MES_TRANSFER_FLAG ' + char(10)
                                SELECT @v_dSql += '   	 , A.MES_TRANSFER_TIME, A.DESCRIPTION, A.INSERT_ID, A.INSERT_TIME         ' + char(10)
                                SELECT @v_dSql += '   	 , A.UPDATE_ID, A.UPDATE_TIME                ' + char(10)
                                SELECT @v_dSql += ' FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql += ' INNER JOIN (   ' + char(10)
                                SELECT @v_dSql += ' 	SELECT A.* ' + char(10)
                                SELECT @v_dSql += ' 	FROM (     ' + char(10)
                                SELECT @v_dSql += ' 		SELECT A.PLAN_DATE, A.INSTANCE_ID,  A.PLAN_GROUP_ID, A.PLAN_ID ' + char(10)
                                SELECT @v_dSql += ' 			   , ROW_NUMBER() OVER(PARTITION BY A.PLAN_DATE, A.INSTANCE_ID, A.FACTORY_ID ORDER BY A.JOB_SEQ DESC) AS ROW_NUM ' + char(10)
                                SELECT @v_dSql += ' 		FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK) ' + char(10)
                                SELECT @v_dSql += ' 		WHERE  A.PLAN_DATE   = '''+ @v_plan_date +'''    ' + char(10)
                                SELECT @v_dSql += ' 		AND    A.INSTANCE_ID = '''+ @v_instance_id +'''  ' + char(10)
                                SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLAN_GROUP_ID' , 'EQ', @p_factory_id))    + char(10)
                                SELECT @v_dSql += ' 	) A                 ' + char(10)
                                SELECT @v_dSql += ' 	WHERE A.ROW_NUM = 1 ' + char(10)
                                SELECT @v_dSql += ' ) B                     ' + char(10)
                                SELECT @v_dSql += ' ON  A.PLAN_DATE   = B.PLAN_DATE        ' + char(10)
                                SELECT @v_dSql += ' AND A.INSTANCE_ID = B.INSTANCE_ID      ' + char(10)
                                SELECT @v_dSql += ' AND A.PLAN_GROUP_ID  = B.PLAN_GROUP_ID ' + char(10)
                                SELECT @v_dSql += ' AND A.PLAN_ID	    = B.PLAN_ID        ' + char(10)

						   END --'M1'
                       /****************************************************************************/
				       /* INSERT HIST GROUP DETAIL  경우  :INSERT_HIST_GROUP_DETAIL                   */
				       /****************************************************************************/
				       ELSE IF(@v_sys_flag ='INSERT_HIST_GROUP_DETAIL')
				       	   BEGIN
				       	   	   SELECT @v_dSql = ''
                               SELECT @v_dSql += ' UPDATE HIS_FP_PLAN_GROUP_DETAIL_H                                         ' + char(10)
                               SELECT @v_dSql += ' SET    HIS_FP_PLAN_GROUP_DETAIL_H.RELEASE_TIME    = dbo.FN_SITE_TIME('''+ @v_site_id +''') ' + char(10)
                               SELECT @v_dSql += '       ,HIS_FP_PLAN_GROUP_DETAIL_H.RELEASE_FLAG    = ''Y''                 ' + char(10)
                               SELECT @v_dSql += '       ,HIS_FP_PLAN_GROUP_DETAIL_H.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID     ' + char(10)
                               SELECT @v_dSql += '       ,MES_TRANSFER_FLAG = ''Y''                                          ' + char(10)
                               SELECT @v_dSql += '       ,MES_TRANSFER_TIME = GETDATE()                                      ' + char(10)
                               SELECT @v_dSql += ' FROM   HIS_FP_PLAN_GROUP_DETAIL_H A                                       ' + char(10)
                               SELECT @v_dSql += ' INNER JOIN SCM_FP_PLAN_GROUP_DETAIL_H B                                   ' + char(10)
                               SELECT @v_dSql += ' ON     A.PLAN_DATE    = B.PLAN_DATE                                       ' + char(10)
                               SELECT @v_dSql += ' AND    A.INSTANCE_ID  = B.INSTANCE_ID                                     ' + char(10)
                               SELECT @v_dSql += ' AND    A.PLAN_GROUP_ID   = B.PLAN_GROUP_ID                                ' + char(10)
                               SELECT @v_dSql += ' WHERE  A.PLAN_DATE    = '''+ @v_plan_date +'''                            ' + char(10)
                               SELECT @v_dSql += ' AND    A.INSTANCE_ID  = '''+ @v_instance_id +'''                          ' + char(10)
                               SELECT @v_dSql += ' AND    A.PLAN_ID      = '''+ @v_plan_id +'''                              ' + char(10)
                               SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLAN_GROUP_ID' , 'EQ', @p_factory_id))    + char(10)
				       	   	   
				       	   END --'M1'

					   IF @v_sys_type = 'SQL'
					   	   BEGIN
					   	   	   --EXEC PR_UI_SQL_LOG @v_proc_name,  @v_user_id,'','',@v_dSql,'select',@runstart, @runend
					   	   	   SELECT @v_dSql as [QUERY_VALUE]
					   	   
					   	   END
					   ELSE
					   	   BEGIN
					   	   	   SET @runstart = GetDate()
					   	   	   --쿼리실행
					   	   	   EXEC sp_executesql @v_dSql
					   	   	   
					   	   	   SET @runend = GetDate()
					   	   	   EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id, @v_sys_flag,'', @v_dSql,'SELECT',@runstart, @runend
					   	   END
			    END --WHILE 내(END)

		END --ELSE (END)
 		
        -- 트랜잭션 (COMMIT)
		COMMIT TRAN
		
		-- 수행결과 성공여부 RETURN
		IF @v_sys_type <> 'SQL'
		    SELECT 'SUCCESS' AS result_code,  @max_loop_cnt AS result_cnt	

		END TRY
		BEGIN CATCH                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                     
			ROLLBACK TRAN                                                                                                                                                                                                                                                 
			-- 에러나도 로그는 인서트                                                                                                                                                                                                                                              
			SET @v_log_message = ERROR_MESSAGE()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','',@v_log_message,'excute',@runstart, @runend
        
			SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  
		
		END CATCH    

END --MAIN END

