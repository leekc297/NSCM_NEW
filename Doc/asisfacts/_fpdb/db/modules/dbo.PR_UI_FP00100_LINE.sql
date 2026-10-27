


/*
 * Program ID   : PR_UI_FP00100_LINE
 * Description  : Line Master
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/14   JYJ				Initial Release UI통합
 * 2022/07/08   KSI				WIP LEVEL 기능 조회&저장 기능 추가
 * 2024/03/12   LJS				WIP LEVEL 널값 오류 수정
 * 2025/03/06   LJS             [E20250305-000713]GSCM.FP Line화면 속도 개선요청건
 * 2025/11/06   kimcd           [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
 *                              JV ESS 생산에 따른 실제 생산하는 라인과 연결 정보 관리. 가상 라인 여부 관리
 *                              LINK_LINE_ID, VIRTUAL_LINE_YN
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00100_LINE]
  @p_sys_type			  NVARCHAR(MAX)='',  
  @p_sys_flag			  NVARCHAR(MAX)='',
  @p_sys_gubun			  NVARCHAR(MAX)='',  
  @p_user_id			  NVARCHAR(MAX)='',
  @p_company_id           NVARCHAR(MAX)='', 
  @p_division_id          NVARCHAR(MAX)='',
  @p_site_id              NVARCHAR(MAX)='',
  @p_plant_id             NVARCHAR(MAX)='',   
  @p_factory_id           NVARCHAR(MAX)='', 
  @p_operation_id         NVARCHAR(MAX)='', 
  @p_line_id              NVARCHAR(MAX)='', 
  @p_line_name            NVARCHAR(MAX)='', 
  @p_line_setup_group_id  NVARCHAR(MAX)='',
  @p_electrode_type       NVARCHAR(MAX)='', 
  @p_line_type            NVARCHAR(MAX)='', 
  @p_line_type_name       NVARCHAR(MAX)='', 
  @p_model_type           NVARCHAR(MAX)='', 
  @p_line_attribute1      NVARCHAR(MAX)='',
  @p_line_location        NVARCHAR(MAX)='',
  @p_active_flag          NVARCHAR(MAX)='',
  @p_description          NVARCHAR(MAX)='',
  @p_scp_line_id          NVARCHAR(MAX)='',
  @p_prod_version_type    NVARCHAR(MAX)='', 
  @p_equipment_count      NVARCHAR(MAX)='',
  @p_mes_line_id          NVARCHAR(MAX)='',
  @p_work_center_id       NVARCHAR(MAX)='',
  @p_pseudo_factory_id    NVARCHAR(MAX)='',
  @p_line_group_id        NVARCHAR(MAX)='',
  @p_virtual_line_yn      NVARCHAR(MAX)='', -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 가상 라인 YN 추가
  @p_link_line_id         NVARCHAR(MAX)=''  -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 연계 라인 ID 추가


AS 
BEGIN  --MAIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    SET NOCOUNT ON                                                                                                                                                                                                                                                   
	SET XACT_ABORT ON 

	DECLARE @v_sys_type			    NVARCHAR(MAX)  -- 값>> SELEC: SQL저장안함, SQL:SQL저장함
	DECLARE @v_sys_flag			    NVARCHAR(MAX)  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	DECLARE @v_sys_gubun			NVARCHAR(MAX) 
	DECLARE @v_user_id			    NVARCHAR(MAX)
	DECLARE @v_company_id           NVARCHAR(MAX)
	DECLARE @v_division_id          NVARCHAR(MAX)
	DECLARE @v_site_id              NVARCHAR(MAX)
	DECLARE @v_plant_id             NVARCHAR(MAX)  
	DECLARE @v_factory_id           NVARCHAR(MAX)
	DECLARE @v_operation_id         NVARCHAR(MAX)
	DECLARE @v_line_id              NVARCHAR(MAX)
	DECLARE @v_mes_line_id          NVARCHAR(MAX)
	DECLARE @v_work_center_id       NVARCHAR(MAX)
	DECLARE @v_line_name            NVARCHAR(MAX)
	DECLARE @v_line_setup_group_id  NVARCHAR(MAX)
	DECLARE @v_electrode_type       NVARCHAR(MAX)
	DECLARE @v_line_type            NVARCHAR(MAX)
	DECLARE @v_line_type_name       NVARCHAR(MAX)
	DECLARE @v_model_type           NVARCHAR(MAX)
	DECLARE @v_line_attribute1      NVARCHAR(MAX)
	DECLARE @v_line_location        NVARCHAR(MAX)
	DECLARE @v_active_flag          NVARCHAR(MAX)
	DECLARE @v_description          NVARCHAR(MAX)
	DECLARE @v_scp_line_id          NVARCHAR(MAX)
	DECLARE @v_prod_version_type    NVARCHAR(MAX)
	DECLARE @v_equipment_count      NVARCHAR(MAX)
	DECLARE @v_pseudo_factory_id    NVARCHAR(MAX)
	DECLARE @v_line_group_id        NVARCHAR(MAX)
	DECLARE @v_virtual_line_yn      NVARCHAR(MAX) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 가상 라인 YN 추가
	DECLARE @v_link_line_id         NVARCHAR(MAX) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 연계 라인 ID 추가
	DECLARE @v_old_link_line_id     NVARCHAR(MAX) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 연계 라인 ID 추가
	

	DECLARE @recv_active_flag       NVARCHAR(MAX)					    
	DECLARE @v_proc_name	        NVARCHAR(100) = 'PR_UI_FP00100_LINE'
	DECLARE @v_log_type             NVARCHAR(100) = '' 
	DECLARE @v_log_message          NVARCHAR(MAX) = ''
	DECLARE @v_error_description    NVARCHAR(MAX) = ''
	DECLARE @v_delimiter            NVARCHAR(1)
	DECLARE @max_loop_cnt	        INTEGER = 0 
	DECLARE @mst_loop_cnt	        INTEGER = 0
	DECLARE @v_seq_no   	        INTEGER = 0

	DECLARE @v_temp1                NVARCHAR(1000)
	DECLARE @v_temp2                NVARCHAR(1000)
	DECLARE @sysdate                DATETIME      = GETDATE()
	DECLARE @runstart               datetime
    DECLARE @runend                 datetime

	DECLARE @v_dSql                 NVARCHAR(MAX)=''
	DECLARE @v_dSql1                NVARCHAR(MAX)=''
	DECLARE @v_dSql2                NVARCHAR(MAX)=''

	DECLARE  @v_Month_M01		 NVARCHAR(MAX)=''
	DECLARE  @v_Month_M02		 NVARCHAR(MAX)=''
	DECLARE  @v_Month_M03		 NVARCHAR(MAX)=''
	DECLARE  @v_Month_M04		 NVARCHAR(MAX)=''
	DECLARE  @v_Month_M05		 NVARCHAR(MAX)=''
	DECLARE  @v_Month_M06		 NVARCHAR(MAX)=''
	DECLARE  @v_Month_M07		 NVARCHAR(MAX)=''
	DECLARE  @v_Month_M08		 NVARCHAR(MAX)=''
	DECLARE  @v_Month_M09		 NVARCHAR(MAX)=''
	DECLARE  @v_Month_M10		 NVARCHAR(MAX)=''
	DECLARE  @v_Month_M11		 NVARCHAR(MAX)=''
	DECLARE  @v_Month_M12		 NVARCHAR(MAX)=''

	DECLARE @v_month_delimiter            NVARCHAR(1)



	SET @v_sys_type			    = ''  -- 값>> SELEC: SQL수행결과리턴, SQL:SQL쿼리문리턴
	SET @v_sys_flag			    = ''  -- 값>> I: Insert, M: Update, D: Delete, G: MERGE
	SET @v_sys_gubun			= '' 
	SET @v_user_id			    = ''
	SET @v_company_id           = ''
	SET @v_division_id          = ''
	SET @v_site_id              = ''
	SET @v_plant_id             = ''  
	SET @v_factory_id           = ''
	SET @v_operation_id         = ''
	SET @v_line_id              = ''
	SET @v_mes_line_id              = ''
	SET @v_work_center_id              = ''
	SET @v_line_name            = ''
	SET @v_line_setup_group_id  = ''
	SET @v_electrode_type       = ''
	SET @v_line_type            = ''
	SET @v_line_type_name       = ''
	SET @v_model_type           = ''
	SET @v_line_attribute1      = ''
	SET @v_line_location        = ''
	SET @v_active_flag          = ''
	SET @v_description          = ''
	SET @v_scp_line_id          = ''
	SET @v_prod_version_type    = ''
	SET @v_equipment_count      = ''
	SEt @v_pseudo_factory_id	= ''
	SEt @v_line_group_id	    = ''
	SET @v_virtual_line_yn      = '' -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 가상 라인 YN 추가
	SET @v_link_line_id         = '' -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 연계 라인 ID 추가
	SET @v_old_link_line_id     = '' -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 연계 라인 ID 추가

	SET @recv_active_flag       = ''		
	SET @recv_active_flag       = @p_sys_flag
	--SET @p_user_id              = dbo.FN_deCRYPT_AES128(@p_user_id)
	SET @v_delimiter            = '|'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_sys_flag, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

	SET	@v_dSql                 = ''
	SET	@v_dSql1                = ''
	SET	@v_dSql2                = ''

	SET @v_month_delimiter            = ','

	/************************************************************************************************/
	/* SELECT인경우 :S(SELECT)                                                                      */
	/************************************************************************************************/
	IF(@p_sys_flag ='S')
		BEGIN --IF(START)
		    SELECT @v_dSql = ''
			--SELECT @v_dSql += ' SELECT  A.COMPANY_ID AS COMPANY_ID,  A.DIVISION_ID AS DIVISION_ID,   A.SITE_ID AS SITE_ID         ' + char(10)
			--- 2023-06-16  Fix For New Line Setup Group
			SELECT @v_dSql += ' SELECT DISTINCT VV.INSTANCE_ID,A.COMPANY_ID AS COMPANY_ID,  A.DIVISION_ID AS DIVISION_ID,   A.SITE_ID AS SITE_ID         ' + char(10)
			SELECT @v_dSql += '   , A.PLANT_ID   AS PLANT_ID, A.FACTORY_ID AS FACTORY_ID, A.OPERATION_ID AS OPERATION_ID          ' + char(10)
			SELECT @v_dSql += '   , A.LINE_ID AS LINE_ID, A.LINE_NAME AS LINE_NAME, A.LINE_SETUP_GROUP_ID AS LINE_SETUP_GROUP_ID  ' + char(10)
			SELECT @v_dSql += '   , A.ELECTRODE_TYPE AS ELECTRODE_TYPE,  A.LINE_TYPE AS LINE_TYPE                                 ' + char(10)
			SELECT @v_dSql += '   , A.LINE_TYPE_NAME AS LINE_TYPE_NAME, A.MODEL_TYPE AS LINE_MODEL_TYPE                           ' + char(10)
			SELECT @v_dSql += '   , ( CASE WHEN A.LINE_ATTR_1 = ''-'' THEN ''Normal'' ELSE A.LINE_ATTR_1 END ) AS LINE_ATTRIBUTE1 ' + char(10)
			SELECT @v_dSql += '   , A.LOCATION AS LINE_LOCATION, A.ACTIVE_FLAG AS ACTIVE_FLAG,      A.DESCRIPTION AS DESCRIPTION  ' + char(10)
			SELECT @v_dSql += '   , A.SCP_LINE_ID AS SCP_LINE_ID,A.MES_LINE_ID AS MES_LINE_ID, A.WORK_CENTER_ID AS WORK_CENTER_ID,   A.PROD_VERSION_TYPE As PROD_VERSION_TYPE                      ' + char(10)
			SELECT @v_dSql += '   ,( SELECT COUNT(*) FROM SCM_EQUIPMENT_M T(NOLOCK)                                               ' + char(10)
			SELECT @v_dSql += '      WHERE T.COMPANY_ID     = A.COMPANY_ID   AND  T.DIVISION_ID    = A.DIVISION_ID                ' + char(10)
			SELECT @v_dSql += '         AND   T.SITE_ID     = A.SITE_ID      AND  T.PLANT_ID       = A.PLANT_ID                   ' + char(10)
			SELECT @v_dSql += '         AND   T.FACTORY_ID  = A.FACTORY_ID   AND  T.OPERATION_ID   = A.OPERATION_ID               ' + char(10)
			SELECT @v_dSql += '         AND   T.LINE_ID     = A.LINE_ID      AND  T.ELECTRODE_TYPE = A.ELECTRODE_TYPE             ' + char(10)
			SELECT @v_dSql += '         AND   T.ACTIVE_FLAG = ''Y''          AND  T.EQUIPMENT_TYPE = ''M''                        ' + char(10)
			SELECT @v_dSql += '     ) AS EQUIPMENT_COUNT                                                                          ' + char(10)
			SELECT @v_dSql += '	  , '''' AS MESSAGE_ID, CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END EDIT_YN          ' + char(10)
			SELECT @v_dSql += '	  , CASE WHEN V.LINE_ID IS NULL THEN ''N'' ELSE ''Y'' END VIRTUAL_FACTORY_EDIT_YN , PSEUDO_FACTORY_ID         ' + char(10)
			SELECT @v_dSql += '   , A.TOP_LINE_ID AS ORG_LINE_ID,  A.UPDATE_ID AS UPDATE_ID                                       ' + char(10)
			SELECT @v_dSql += '	  , A.UPDATE_TIME AS UPDATE_TIME                                                                  ' + char(10)
			SELECT @v_dSql += '	  , A.LINE_GROUP_ID ' + char(10) -- [E20240909-000146]
			SELECT @v_dSql += '	  , A.VIRTUAL_LINE_YN, A.LINK_LINE_ID ' + char(10) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 가상 라인 YN, 연개 라인 추가
			SELECT @v_dSql += '	FROM  SCM_LINE_M A WITH(NOLOCK)                                                                   ' + char(10)
			--- 2023-06-16  Fix For New Line Setup Group
			/*
			SELECT @v_dSql += '     LEFT OUTER JOIN FP_INSTANCE_LINE_V VV WITH(NOLOCK)' + char(10)
			SELECT @v_dSql += '     ON A.LINE_ID = VV.LINE_ID' + char(10)
			*/
			-- line 두줄나오는 증상 수정... 20230705
			SELECT @v_dSql += '	LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql += '		SELECT VV.INSTANCE_ID, VV.COMPANY_ID, VV.DIVISION_ID, VV.SITE_ID, VV.PLANT_ID, VV.FACTORY_ID, VV.OPERATION_ID, VV.LINE_ID, VV.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql += '		FROM FP_INSTANCE_LINE_V VV WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += '		GROUP BY VV.INSTANCE_ID, VV.COMPANY_ID, VV.DIVISION_ID, VV.SITE_ID, VV.PLANT_ID, VV.FACTORY_ID, VV.OPERATION_ID, VV.LINE_ID, VV.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql += '	) VV ' + char(10)
			SELECT @v_dSql += '	ON  1=1 ' + char(10)
			SELECT @v_dSql += '	AND A.COMPANY_ID     = VV.COMPANY_ID ' + char(10)
			SELECT @v_dSql += '	AND A.DIVISION_ID    = VV.DIVISION_ID ' + char(10)
			SELECT @v_dSql += '	AND A.SITE_ID        = VV.SITE_ID ' + char(10)
			SELECT @v_dSql += '	AND A.PLANT_ID       = VV.PLANT_ID ' + char(10)
			SELECT @v_dSql += '	AND A.FACTORY_ID     = VV.FACTORY_ID ' + char(10)
			SELECT @v_dSql += '	AND A.OPERATION_ID   = VV.OPERATION_ID ' + char(10)
			SELECT @v_dSql += '	AND A.LINE_ID        = VV.LINE_ID ' + char(10)
			SELECT @v_dSql += '	AND A.ELECTRODE_TYPE = VV.ELECTRODE_TYPE ' + char(10)
      		SELECT @v_dSql += '     LEFT OUTER JOIN (                                                                             ' + char(10)
			SELECT @v_dSql += '          SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID         ' + char(10)
			SELECT @v_dSql += '          FROM    FP_USER_ROLE_INFO_V R WITH(NOLOCK)		' + char(10)
			SELECT @v_dSql += '          WHERE   R.USER_ID	    = '''+ @p_user_id +''' 	' + char(10)
			SELECT @v_dSql += '          AND     R.SAVE_FLAG	= ''Y''					' + char(10)
			SELECT @v_dSql += '		) R                                                 ' + char(10)
			SELECT @v_dSql += '		ON  1=1                                             ' + char(10)
			SELECT @v_dSql += '		AND A.COMPANY_ID    = R.COMPANY_ID                  ' + char(10)
			SELECT @v_dSql += '		AND A.DIVISION_ID   = R.DIVISION_ID                 ' + char(10)
			SELECT @v_dSql += '		AND A.SITE_ID       = R.SITE_ID                     ' + char(10)
			SELECT @v_dSql += '		AND A.PLANT_ID      = R.PLANT_ID                    ' + char(10)
			SELECT @v_dSql += '		AND A.FACTORY_ID    = R.FACTORY_ID                  ' + char(10)
			--[E20250305-000713]GSCM.FP Line화면 속도 개선요청건
			SELECT @v_dSql += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql += '		SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID ' + char(10)
			SELECT @v_dSql += '		FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql += '		WHERE  R.USER_ID = ''' + @p_user_id + ''' ' + char(10)
			SELECT @v_dSql += '	) R2 ' + char(10)
			SELECT @v_dSql += '	ON  1=1 ' + char(10)
			SELECT @v_dSql += '	AND A.COMPANY_ID    = R2.COMPANY_ID ' + char(10)
			SELECT @v_dSql += '	AND A.DIVISION_ID   = R2.DIVISION_ID ' + char(10)
			SELECT @v_dSql += '	AND A.SITE_ID       = R2.SITE_ID ' + char(10)
			SELECT @v_dSql += '	AND A.PLANT_ID      = R2.PLANT_ID ' + char(10)
			SELECT @v_dSql += '	AND A.FACTORY_ID    = R2.FACTORY_ID ' + char(10)
			SELECT @v_dSql += '			LEFT OUTER HASH JOIN (																											              ' + char(10)
			SELECT @v_dSql += '				SELECT	DISTINCT C.SEGMENT1 AS INSTNCE_ID, V.COMPANY_ID, V.SITE_ID, V.DIVISION_ID, V.PLANT_ID, V.FACTORY_ID, V.LINE_ID	              ' + char(10)
			SELECT @v_dSql += '				FROM	SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)' + char(10)
			SELECT @v_dSql += '						, SCM_SYS_LOOKUP_VALUE D WITH(NOLOCK)' + char(10)
			SELECT @v_dSql += '						, FP_INSTANCE_LINE_V V WITH(NOLOCK)' + char(10)
			SELECT @v_dSql += '				WHERE	1=1                                                                                                                           ' + char(10)            
			SELECT @v_dSql += '				AND		C.LOOKUP_TYPE_CODE = ''FORM_TRAY_SIMUL_OPTION''                                                                                 ' + char(10)     
			SELECT @v_dSql += '				AND		C.ACTIVE_FLAG = ''Y''       																						              ' + char(10)
			SELECT @v_dSql += '				AND     C.ATTRIBUTE1 = ''BUILDING''																						              ' + char(10)
			SELECT @v_dSql += '				AND     D.LOOKUP_TYPE_CODE = ''FORMATION_TRAY_FACTORY_OPTION''                                                                          ' + char(10)            
			SELECT @v_dSql += '				AND		D.ACTIVE_FLAG = ''Y''       																						              ' + char(10)
			SELECT @v_dSql += '				AND     C.SEGMENT1 = D.SEGMENT1																							              ' + char(10)
			SELECT @v_dSql += '				AND		C.SEGMENT1 = V.INSTANCE_ID																						              ' + char(10)
			SELECT @v_dSql += '				AND     D.SEGMENT4 = V.FACTORY_ID																						              ' + char(10)
			SELECT @v_dSql += '			) V																															              ' + char(10)
			SELECT @v_dSql += '			ON 1=1																														              ' + char(10)
			SELECT @v_dSql += '			AND A.COMPANY_ID    = V.COMPANY_ID                  																		              ' + char(10)
			SELECT @v_dSql += '			AND A.DIVISION_ID   = V.DIVISION_ID                 																		              ' + char(10)
			SELECT @v_dSql += '			AND A.SITE_ID       = V.SITE_ID                     																		              ' + char(10)
			SELECT @v_dSql += '			AND A.PLANT_ID      = V.PLANT_ID                    																		              ' + char(10)
			SELECT @v_dSql += '			AND A.FACTORY_ID    = V.FACTORY_ID  																						              ' + char(10)
			SELECT @v_dSql += '			AND A.LINE_ID		= V.LINE_ID																								              ' + char(10)
			SELECT @v_dSql += '			AND A.OPERATION_ID IN (''A9000'', ''F6000'')																					              ' + char(10)
			SELECT @v_dSql += '	, SCM_OPERATION_M B WITH(NOLOCK)                        ' + char(10)
			SELECT @v_dSql += '	WHERE A.COMPANY_ID    = B.COMPANY_ID                    ' + char(10)
			SELECT @v_dSql += '	AND   A.DIVISION_ID   = B.DIVISION_ID                   ' + char(10)
			SELECT @v_dSql += '	AND   A.SITE_ID       = B.SITE_ID                       ' + char(10)
			SELECT @v_dSql += '	AND   A.OPERATION_ID  = B.OPERATION_ID                  ' + char(10)
			SELECT @v_dSql += '	AND  ( B.WO_FLAG = ''Y'' OR B.MO_FLAG = ''Y'' )         ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.ACTIVE_FLAG' , 'EQ', @p_active_flag))    + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.LINE_ID' , 'EQ', @p_line_id))            + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.LINE_NAME' , 'LK', @p_line_name))            + char(10)
			/*
			--[E20250305-000713]GSCM.FP Line화면 속도 개선요청건
			SELECT @v_dSql += '	AND EXISTS (                                                                                   ' + char(10)
			SELECT @v_dSql += '                SELECT 1                                                                        ' + char(10)
			SELECT @v_dSql += '                FROM   FP_USER_ROLE_INFO_V C WITH(NOLOCK)                                       ' + char(10)
			SELECT @v_dSql += '                WHERE  A.COMPANY_ID  = C.COMPANY_ID  AND A.DIVISION_ID = C.DIVISION_ID          ' + char(10)
			SELECT @v_dSql += '                  AND  A.SITE_ID     = C.SITE_ID     AND A.PLANT_ID    = C.PLANT_ID             ' + char(10)
			SELECT @v_dSql += '                  AND  A.FACTORY_ID  = C.FACTORY_ID  AND C.USER_ID     = '''+@p_user_id +'''    ' + char(10)
			SELECT @v_dSql += '            )                                                                                   ' + char(10)
			*/
			SELECT @v_dSql += '	ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID         ' + char(10)

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
	/************************************************************************************************/
	/* SELECT인경우 :SUB_TABLE (SELECT)                                                              */
	/************************************************************************************************/
	ELSE IF(@p_sys_flag ='WIP_LEVEL')
		BEGIN --IF(START)

		SELECT  @v_Month_M01 = [dbo].[SCM_ARR_SPL_VAL]( @p_description,           @v_month_delimiter, 1)
					, @v_Month_M02  = [dbo].[SCM_ARR_SPL_VAL]( @p_description,           @v_month_delimiter, 2)
					, @v_Month_M03 = [dbo].[SCM_ARR_SPL_VAL]( @p_description,       @v_month_delimiter, 3)
					, @v_Month_M04 = [dbo].[SCM_ARR_SPL_VAL]( @p_description,       @v_month_delimiter, 4)
					, @v_Month_M05 = [dbo].[SCM_ARR_SPL_VAL]( @p_description,       @v_month_delimiter, 5)
					, @v_Month_M06 = [dbo].[SCM_ARR_SPL_VAL]( @p_description,       @v_month_delimiter, 6)
					, @v_Month_M07 = [dbo].[SCM_ARR_SPL_VAL]( @p_description,       @v_month_delimiter, 7)
					, @v_Month_M08 = [dbo].[SCM_ARR_SPL_VAL]( @p_description,       @v_month_delimiter, 8)
					, @v_Month_M09 = [dbo].[SCM_ARR_SPL_VAL]( @p_description,       @v_month_delimiter, 9)
					, @v_Month_M10 = [dbo].[SCM_ARR_SPL_VAL]( @p_description,       @v_month_delimiter, 10)
					, @v_Month_M11 = [dbo].[SCM_ARR_SPL_VAL]( @p_description,       @v_month_delimiter, 11)
					, @v_Month_M12 = [dbo].[SCM_ARR_SPL_VAL]( @p_description,       @v_month_delimiter, 12)

		SELECT @v_dSql = '';
		SELECT @v_dSql += '      SELECT   T1.COMPANY_ID, T1.DIVISION_ID,' + char(10);
		SELECT @v_dSql += '	      	   T1.SITE_ID, T1.PLANT_ID, T1.FACTORY_ID,' + char(10);
		SELECT @v_dSql += '	      	   T1.OPERATION_ID, T3.OPERATION_NAME,' + char(10);
		SELECT @v_dSql += '	      	   T1.LINE_ID, T1.ITEM_ID, ISNULL(T4.NICK_NAME, ''-'') AS NICK_NAME, ' + char(10);
		-- [E20240614-001811]Assy 공정의 WIP Level UOM
		--SELECT @v_dSql += '	      	   T1.ELECTRODE_TYPE, T1.ITEM_UOM as WIP_UOM,' + char(10);
		SELECT @v_dSql += '	      	   T1.ELECTRODE_TYPE, ''CELL'' as WIP_UOM,' + char(10);
	      			   --A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11, A12,

		SELECT @v_dSql += '	       	   AS_IS_WIP,' + char(10);
		SELECT @v_dSql += '	       	   AS_WAS_WIP,' + char(10);

					   --B02, B03, B04, B05, B06, B07, B08, B09, B10, B11, B12,
		SELECT @v_dSql += '		      	   LAST_MODIFY_DATE as UPDATE_TIME, LAST_MODIFY_ID as UPDATE_ID, DUE_TO_DATE, ' + char(10);
		SELECT @v_dSql += '	      	   M01,' + char(10);
		SELECT @v_dSql += '	      	   M02, M03, M04, M05, M06, M07, M08, M09, M10, M11, M12,' + char(10);
					   --M02, M03, M04, M05, M06, M07, M08, M09, M10, M11, M12,
		SELECT @v_dSql += '	      	   T2.LINE_TYPE, T1.LANE_QTY, T2.LINE_NAME,' + char(10);
		SELECT @v_dSql += '	      	   CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ISNULL(T6.IS_WIP_LEVEL,''N'') END IS_WIP_LEVEL  ' + char(10);
		SELECT @v_dSql += '	      	   , T4.LEVEL_2_CODE ' + char(10);
		SELECT @v_dSql += '	      	   , CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END EDIT_YN ' + char(10);
		 SELECT @v_dSql += '     FROM ( ' + char(10);
		 SELECT @v_dSql += '      			SELECT COMPANY_ID,		  ' + char(10);
		 SELECT @v_dSql += '		      		   DIVISION_ID,		  ' + char(10);
		 SELECT @v_dSql += '		      		   SITE_ID,			  ' + char(10);
		 SELECT @v_dSql += '		      		   PLANT_ID,		  ' + char(10);
		 SELECT @v_dSql += '		      		   FACTORY_ID,		  ' + char(10);
		 SELECT @v_dSql += '		      		   OPERATION_ID,	  ' + char(10);
		 SELECT @v_dSql += '		      		   LINE_ID, 		  ' + char(10);
		 SELECT @v_dSql += '		      		   ITEM_ID,			  ' + char(10);
		 SELECT @v_dSql += '		      		   ITEM_UOM,			  ' + char(10);
		 SELECT @v_dSql += '		      		   ELECTRODE_TYPE,	  ' + char(10);
		 --ROUND(MAX(CASE MONTH WHEN #M01# THEN CONVERT(numeric,PRIORITY) ELSE 0 END),0) AS A01,
		 --ROUND(MAX(CASE MONTH WHEN #M02# THEN CONVERT(numeric,PRIORITY) ELSE 0 END),0) AS A02,
		 SELECT @v_dSql += '   ROUND(MAX(CASE MONTH WHEN ''' +  @v_Month_M01 + ''' THEN CONVERT(numeric,WIP_LEVEL_QTY) ELSE 0 END),0) AS AS_IS_WIP, ' + char(10);
		 SELECT @v_dSql += '   ROUND(MAX(CASE MONTH WHEN ''' +  @v_Month_M01 + ''' THEN CONVERT(numeric,OLD_WIP_LEVEL_QTY) ELSE 0 END),0) AS AS_WAS_WIP, ' + char(10);


		--ROUND(MAX(CASE MONTH WHEN #M02# THEN CONVERT(numeric,WIP_LEVEL_QTY) ELSE 0 END),0) AS B02,
		--ROUND(MAX(CASE MONTH WHEN #M03# THEN CONVERT(numeric,WIP_LEVEL_QTY) ELSE 0 END),0) AS B03,
			
		SELECT @v_dSql += '	   MAX(CASE RNUM WHEN 1 THEN CONVERT(VARCHAR, UPDATE_TIME, 120) ELSE NULL END) AS LAST_MODIFY_DATE, ' + char(10);
		SELECT @v_dSql += '	   MAX(CASE RNUM WHEN 1 THEN UPDATE_ID ELSE NULL END) AS LAST_MODIFY_ID,							' + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M01  + '''  AS M01,'   + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M02  + '''  AS M02,'   + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M03  + '''  AS M03,'   + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M04  + '''  AS M04,'   + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M05  + '''  AS M05,'   + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M06  + '''  AS M06,'   + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M07  + '''  AS M07,'   + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M08  + '''  AS M08,'   + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M09  + '''  AS M09,'   + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M10  + '''  AS M10,'   + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M11  + '''  AS M11,'   + char(10);
		SELECT @v_dSql += '	''' +    @v_Month_M12  + '''  AS M12,'   + char(10);
					   
		--#M02# AS M02, #M03# AS M03, #M04# AS M04,
					 
							 ------
		SELECT @v_dSql += '					   ''' + @v_Month_M12+ '01'' AS DUE_TO_DATE,  ' + char(10);
		      				   ----
		SELECT @v_dSql += '		   SUM(CASE WHEN B.MONTH = ''' + @v_Month_M01 + ''' THEN B.LANE_QTY ELSE 0 END) AS LANE_QTY, '+char(10);
		SELECT @v_dSql += '	 		   FLOW_ID, FORMATION_FLOW_ID '+char(10);
		SELECT @v_dSql += ' 	FROM ( '+char(10);
		SELECT @v_dSql += '	         	SELECT A.COMPANY_ID, '+char(10);
		SELECT @v_dSql += '	           		   A.DIVISION_ID, '+char(10);
		SELECT @v_dSql += '	           		   A.SITE_ID, '+char(10);
		SELECT @v_dSql += '	           		   A.PLANT_ID, '+char(10);
		SELECT @v_dSql += '	           		   A.FACTORY_ID, '+char(10);
		SELECT @v_dSql += '	           		   A.OPERATION_ID, '+char(10);
		SELECT @v_dSql += '	           		   A.LINE_ID, '+char(10);
		SELECT @v_dSql += '	           		   A.ITEM_ID, '+char(10);
		SELECT @v_dSql += '	           		   A.ELECTRODE_TYPE, '+char(10);
		SELECT @v_dSql += '	           		   A.MONTH, ISNULL(A.PRIORITY, 0) AS PRIORITY, ISNULL(A.WIP_LEVEL_QTY, 0) AS WIP_LEVEL_QTY, '+char(10);
		SELECT @v_dSql += '	           		   ISNULL(A.OLD_WIP_LEVEL_QTY, 0) AS OLD_WIP_LEVEL_QTY, '+char(10);
		SELECT @v_dSql += '	           		   ISNULL(A.UPDATE_ID, '''') UPDATE_ID, A.UPDATE_TIME, '+char(10);
		SELECT @v_dSql += '	           		   ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.ELECTRODE_TYPE ORDER BY A.UPDATE_TIME DESC) AS RNUM, '+char(10);
		SELECT @v_dSql += '	           		   A.LANE_QTY, '+char(10);
		SELECT @v_dSql += '	           		   BB.ITEM_UOM, BB.FLOW_ID, BB.FORMATION_FLOW_ID '+char(10);
		SELECT @v_dSql += '	         	FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) '+char(10);					          	
		SELECT @v_dSql += '		            INNER JOIN SCM_ITEM_M BB WITH(NOLOCK) '+char(10);
		SELECT @v_dSql += '		            ON    A.COMPANY_ID   = BB.COMPANY_ID'+char(10);
		SELECT @v_dSql += '		            AND   A.DIVISION_ID  = BB.DIVISION_ID'+char(10);
		SELECT @v_dSql += '		            AND   A.SITE_ID      = BB.SITE_ID'+char(10);
		SELECT @v_dSql += '		            AND   A.ITEM_ID      = BB.ITEM_ID'+char(10);
		SELECT @v_dSql += '	         	WHERE A.ACTIVE_FLAG = ''Y'' '+char(10);

		----AND   A.MONTH IN (#M01#,#M02#,#M03#,#M04#,#M05#,#M06#,#M07#,#M08#,#M09#,#M10#,#M11#,#M12#)
		------
		--SELECT @v_dSql += '                                 AND   A.MONTH IN (''' + @p_description + ''') ' + char(10);
		------
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.MONTH' , 'EQ', @p_description))    + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.SITE_ID' , 'EQ', @p_site_id))            + char(10);	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.LINE_ID' , 'EQ', @p_line_id))            + char(10);
			          	
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10);
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.ELECTRODE_TYPE' , 'EQ', @p_electrode_type))      + char(10);
			          	
		--SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.ACTIVE_FLAG' , 'EQ', @p_active_flag))    + char(10);


		 SELECT @v_dSql += '		      		) AS B																					'+char(10);
		 SELECT @v_dSql += '	      		GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, 							'+char(10);
		 SELECT @v_dSql += '	      	         OPERATION_ID, LINE_ID, ITEM_ID, ITEM_UOM, ELECTRODE_TYPE,										'+char(10);
		 SELECT @v_dSql += '	      	         FLOW_ID, FORMATION_FLOW_ID																'+char(10);
		 SELECT @v_dSql += '     		 ) T1																							'+char(10);
		 SELECT @v_dSql += '		      INNER HASH JOIN SCM_LINE_M T2 WITH(NOLOCK)													'+char(10);
		 SELECT @v_dSql += '		      ON    T1.COMPANY_ID     = T2.COMPANY_ID														'+char(10);
		 SELECT @v_dSql += '		      AND   T1.DIVISION_ID    = T2.DIVISION_ID														'+char(10);
		 SELECT @v_dSql += '		      AND   T1.SITE_ID        = T2.SITE_ID															'+char(10);
		 SELECT @v_dSql += '		      AND   T1.PLANT_ID       = T2.PLANT_ID															'+char(10);
		 SELECT @v_dSql += '		      AND   T1.FACTORY_ID     = T2.FACTORY_ID														'+char(10);
		 SELECT @v_dSql += '		      AND   T1.OPERATION_ID   = T2.OPERATION_ID														'+char(10);
		 SELECT @v_dSql += '		      AND   T1.LINE_ID        = T2.LINE_ID															'+char(10);
		 SELECT @v_dSql += '		      AND   T1.ELECTRODE_TYPE = T2.ELECTRODE_TYPE													'+char(10);
		 SELECT @v_dSql += '		      AND   T2.ACTIVE_FLAG    = ''Y''																	'+char(10);
		 SELECT @v_dSql += '		      INNER JOIN SCM_OPERATION_M T3 WITH(NOLOCK)													'+char(10);
		 SELECT @v_dSql += '		      ON    T1.COMPANY_ID     = T3.COMPANY_ID														'+char(10);
		 SELECT @v_dSql += '		      AND   T1.DIVISION_ID    = T3.DIVISION_ID														'+char(10);
		 SELECT @v_dSql += '		      AND   T1.SITE_ID        = T3.SITE_ID															'+char(10);
		 SELECT @v_dSql += '		      AND   T1.OPERATION_ID   = T3.OPERATION_ID														'+char(10);
		 SELECT @v_dSql += '		      AND   T3.ACTIVE_FLAG    = ''Y''																	'+char(10);
		 SELECT @v_dSql += '		      INNER JOIN (																					'+char(10);
		 SELECT @v_dSql += '		          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, B.LEVEL_2_CODE		'+char(10);
		 SELECT @v_dSql += '		          FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M B WITH(NOLOCK)							'+char(10);
		 SELECT @v_dSql += '		          WHERE  A.ITEM_CLASS  = B.CLASS_ID															'+char(10);
		 SELECT @v_dSql += '		          AND    A.ACTIVE_FLAG = ''Y'' 																'+char(10);
		 SELECT @v_dSql += '		          AND    B.USE_FLAG    = ''Y''		         												'+char(10);
		 SELECT @v_dSql += '		      ) T4																							'+char(10);
		 SELECT @v_dSql += '		      ON    T1.COMPANY_ID     = T4.COMPANY_ID														'+char(10);
		 SELECT @v_dSql += '		      AND   T1.DIVISION_ID    = T4.DIVISION_ID														'+char(10);
		 SELECT @v_dSql += '		      AND   T1.SITE_ID        = T4.SITE_ID															'+char(10);
		 SELECT @v_dSql += '		      AND   T1.ITEM_ID        = T4.ITEM_ID															'+char(10);
		 -- SELECT @v_dSql += '   LEFT OUTER MERGE																								'+char(10);
		 -- SELECT @v_dSql += '      		JOIN (																							'+char(10);
		 -- SELECT @v_dSql += '		          SELECT CT.COMPANY_ID																		'+char(10);
		 -- SELECT @v_dSql += '		                ,MAX(CT.DIVISION_ID) AS DIVISION_ID													'+char(10);
		 -- SELECT @v_dSql += '		                ,CT.SITE_ID																			'+char(10);
		 -- SELECT @v_dSql += '		                ,CT.PLANT_ID																		'+char(10);
		 -- SELECT @v_dSql += '		                ,CT.CHILD_ITEM_ID																	'+char(10);
		 -- SELECT @v_dSql += '		                ,CT.FLOW_ID																			'+char(10);
		 					
		 -- SELECT @v_dSql += '		          FROM  ( '+char(10);
		 -- SELECT @v_dSql += '				              SELECT DISTINCT CT.COMPANY_ID, CT.DIVISION_ID, CT.SITE_ID, CT.PLANT_ID '+char(10);
		 -- SELECT @v_dSql += '				                    ,CT.MODEL_ID '+char(10);
		 -- SELECT @v_dSql += '				                    ,CT.CHILD_ITEM_ID '+char(10);
		 -- SELECT @v_dSql += '				                    ,SI.NICK_NAME '+char(10);
 	 --    										--,SUBSTRING(SI.FLOW_ID,1,5) AS FLOW_ID 
		 -- SELECT @v_dSql += '				                    ,FL.OPERATION_ID AS FLOW_ID '+char(10);
		 --									--,SUBSTRING(SI.FORMATION_FLOW_ID,1,5) AS FORMATION_FLOW_ID 
		 -- SELECT @v_dSql += '				              FROM   SCM_MODEL_COMP_TEMP CT WITH(NOLOCK)			  ' + char(10);
		 -- SELECT @v_dSql += '				                    ,SCM_ITEM_M SI WITH(NOLOCK)						  ' + char(10);
		 -- SELECT @v_dSql += '				                    ,SCM_ITEM_CLASS_M IC WITH(NOLOCK)				  ' + char(10);
		 -- SELECT @v_dSql += '				                    ,SCM_OPERATION_FLOW_M FL WITH(NOLOCK)			  ' + char(10);
		 -- SELECT @v_dSql += '				              WHERE  CT.CHILD_COMPANY_ID  = SI.COMPANY_ID			  ' + char(10);
		 -- SELECT @v_dSql += '				              AND    CT.CHILD_DIVISION_ID = SI.DIVISION_ID			  ' + char(10);
		 -- SELECT @v_dSql += '				              AND    CT.CHILD_SITE_ID     = SI.SITE_ID				  ' + char(10);
		 -- SELECT @v_dSql += '				              AND    CT.CHILD_ITEM_ID     = SI.ITEM_ID				  ' + char(10);
		 -- SELECT @v_dSql += '				              AND    SI.ITEM_CLASS        = IC.CLASS_ID				  ' + char(10);
		 -- SELECT @v_dSql += '			      			  AND    SI.COMPANY_ID		    = FL.COMPANY_ID			  ' + char(10);
		 -- SELECT @v_dSql += '			      			  AND    SI.DIVISION_ID		    = FL.DIVISION_ID		  ' + char(10);
		 -- SELECT @v_dSql += '			      			  AND    SI.SITE_ID			      = FL.SITE_ID			  ' + char(10);
		 --		      					  --AND    (CASE WHEN SI.FORMATION_FLOW_ID IS NOT NULL THEN SI.FORMATION_FLOW_ID ELSE SI.FLOW_ID END) = FL.FLOW_ID
		 -- SELECT @v_dSql += '				      		  AND   (FL.FLOW_ID = SI.FORMATION_FLOW_ID OR FL.FLOW_ID = SI.FLOW_ID)   ' + char(10);
		 -- SELECT @v_dSql += '				              AND    IC.USE_FLAG          = ''Y''    ' + char(10);
		 -- SELECT @v_dSql += '				              AND    SI.ACTIVE_FLAG       = ''Y''    ' + char(10);
		 -- SELECT @v_dSql += '				              AND    ISNULL(SI.ITEM_TYPE,''H'') IN (''P'',''Q'',''H'')    ' + char(10);
		 -- SELECT @v_dSql += '				              AND    (SI.FLOW_ID IS NOT NULL OR SI.FORMATION_FLOW_ID IS NOT NULL)    ' + char(10);
		 -- SELECT @v_dSql += '				              AND    CT.ALT_PRIORITY = ''Y''    ' + char(10);
		 -- SELECT @v_dSql += '				              AND    FL.ACTIVE_FLAG  = ''Y''    ' + char(10);
		 --SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'SI.DIVISION_ID' , 'EQ', @p_division_id))    + char(10);
		 --SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'SI.SITE_ID' , 'EQ', @p_site_id))            + char(10);	

		 --SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'CT.PLANT_ID' , 'EQ', @p_plant_id))          + char(10);

				             
		 -- SELECT @v_dSql += '		          		) CT ' + char(10);
		 -- SELECT @v_dSql += '		          GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID, CT.FLOW_ID ' + char(10);
		 -- SELECT @v_dSql += '      		) T5 ' + char(10);
		 --SELECT @v_dSql += '		      ON  T1.COMPANY_ID   = T5.COMPANY_ID ' + char(10);
		 --SELECT @v_dSql += '		      AND T1.DIVISION_ID  = T5.DIVISION_ID ' + char(10);
		 --SELECT @v_dSql += '		      AND T1.SITE_ID      = T5.SITE_ID ' + char(10);
		 --SELECT @v_dSql += '		      AND T1.PLANT_ID     = T5.PLANT_ID ' + char(10);
		 --SELECT @v_dSql += '     	      AND T1.OPERATION_ID = T5.FLOW_ID ' + char(10);
		 --SELECT @v_dSql += '		      AND T1.ITEM_ID      = T5.CHILD_ITEM_ID ' + char(10);
		 SELECT @v_dSql += '		      LEFT OUTER MERGE JOIN ( ' + char(10);
		 SELECT @v_dSql += '			          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID ' + char(10);
		 SELECT @v_dSql += '			               , MAX(IS_WIP_LEVEL) AS IS_WIP_LEVEL ' + char(10);
		 SELECT @v_dSql += '			          FROM ( ' + char(10);
		 SELECT @v_dSql += '					            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.INSTANCE_ID ' + char(10);
		 SELECT @v_dSql += '					                 	, (CASE WHEN B.INSTANCE_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS IS_WIP_LEVEL, C.OPERATION_ID ' + char(10);
		 SELECT @v_dSql += '					            FROM ('+ char(10);
		 SELECT @v_dSql += '						                SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, A.INSTANCE_ID '+ char(10);
		 SELECT @v_dSql += '						                FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK) '+ char(10);
		 SELECT @v_dSql += '						                WHERE  A.FACTORY_ID  = B.FACTORY_ID '+ char(10);
		 SELECT @v_dSql += '						                AND    A.ACTIVE_FLAG = ''Y'' '+ char(10);
		 SELECT @v_dSql += '						                AND    B.ACTIVE_FLAG = ''Y'' '+ char(10);
		 SELECT @v_dSql += '					            	) A '+ char(10);
		 SELECT @v_dSql += '						            LEFT OUTER JOIN ( '+ char(10);
		 SELECT @v_dSql += '						  	           	SELECT DISTINCT A.INSTANCE_ID '+ char(10);
		 SELECT @v_dSql += '							              FROM   FP_INSTANCE_CONFIG_M A WITH(NOLOCK) '+ char(10);
		 SELECT @v_dSql += '							              WHERE  A.CONFIG_SET_ID  = ''LG_CHEM'' '+ char(10);
		 SELECT @v_dSql += '							              AND    A.CATEGORY_ID    = ''PLAN_CATEGORY'' ' + char(10);
		 SELECT @v_dSql += '							              AND    A.KEY_ID         = ''PLAN_LEVEL'' '+ char(10);
		 SELECT @v_dSql += '							              AND    A.PART_ID        = ''-'' '+ char(10);
		 SELECT @v_dSql += '							              AND    A.KEY_VALUE      IN (''WIP_LEVEL'', ''WIP_LEVEL_LT'') '+ char(10);
		 SELECT @v_dSql += '						            ) B '+ char(10);
		 SELECT @v_dSql += '						            ON A.INSTANCE_ID = B.INSTANCE_ID '+ char(10);
		 SELECT @v_dSql += '						          	INNER JOIN FP_INSTANCE_OPERATION_V C WITH(NOLOCK)' + char(10);
		 SELECT @v_dSql += '						          	ON A.INSTANCE_ID = C.INSTANCE_ID '+ char(10);
		 SELECT @v_dSql += '				          ) A '+ char(10);
		 SELECT @v_dSql += '			          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID '+ char(10);
		 SELECT @v_dSql += '		      ) T6 '+ char(10);
		 SELECT @v_dSql += '		      ON  T1.COMPANY_ID   = T6.COMPANY_ID '+ char(10);
		 SELECT @v_dSql += '		      AND T1.DIVISION_ID  = T6.DIVISION_ID '+ char(10);
		 SELECT @v_dSql += '		      AND T1.SITE_ID      = T6.SITE_ID '+ char(10);
		 SELECT @v_dSql += '		      AND T1.PLANT_ID     = T6.PLANT_ID '+ char(10);
		 SELECT @v_dSql += '		      AND T1.FACTORY_ID   = T6.FACTORY_ID '+ char(10);
		 SELECT @v_dSql += '		      AND T1.OPERATION_ID = T6.OPERATION_ID '+ char(10);
		 SELECT @v_dSql += '			LEFT OUTER JOIN ( '+ char(10);
		 SELECT @v_dSql += '					SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID '+ char(10);
		 SELECT @v_dSql += '					FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)  ' + char(10);
		 SELECT @v_dSql += '					WHERE	1=1 ' + char(10);
		 SELECT @v_dSql += '					AND		R.USER_ID	= '''+ @p_user_id +'''' + char(10);
		 SELECT @v_dSql += '					AND		R.SAVE_FLAG = ''Y'' ' + char(10);
		 SELECT @v_dSql += '			) R ' + char(10);
		 SELECT @v_dSql += '			ON		1=1 ' + char(10);
		 SELECT @v_dSql += '			AND		T1.COMPANY_ID	= R.COMPANY_ID ' + char(10);
		 SELECT @v_dSql += '			AND		T1.DIVISION_ID	= R.DIVISION_ID ' + char(10);
		 SELECT @v_dSql += '			AND		T1.SITE_ID		= R.SITE_ID ' + char(10);
		 SELECT @v_dSql += '			AND		T1.PLANT_ID		= R.PLANT_ID ' + char(10);
		 SELECT @v_dSql += '			AND		T1.FACTORY_ID	= R.FACTORY_ID ' + char(10);
		 SELECT @v_dSql += '			AND		T1.OPERATION_ID	= R.OPERATION_ID ' + char(10);
		 SELECT @v_dSql += '			AND		T1.LINE_ID		= R.LINE_ID		      ' + char(10); 
		 SELECT @v_dSql += '      WHERE 1=1 ' + char(10);
		 SELECT @v_dSql += '      ORDER BY LINE_ID  , LINE_NAME , OPERATION_ID DESC, ELECTRODE_TYPE ASC, ITEM_ID DESC   ' + char(10);
		 --DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID,
		 --SELECT @v_dSql += '			 OPERATION_NAME, OPERATION_ID  ASC  ' + char(10);	
		 --,  ELECTRODE_TYPE, ITEM_ID
			
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
	
	/************************************************************************************************/
	/* SELECT인경우 :SELECT_IMPORT(SELECT)                                                                      */
	/************************************************************************************************/
	ELSE IF(@p_sys_flag ='SELECT_IMPORT')
		BEGIN --IF(START)
		    SELECT @v_dSql = ''
			SELECT @v_dSql += ' SELECT  A.COMPANY_ID AS COMPANY_ID,    A.DIVISION_ID AS DIVISION_ID,   A.SITE_ID AS SITE_ID, A.PLANT_ID   AS PLANT_ID		   ' + char(10)
			SELECT @v_dSql += '	  , A.FACTORY_ID AS FACTORY_ID,        A.OPERATION_ID AS OPERATION_ID, A.LINE_ID AS LINE_ID, A.LINE_NAME  AS LINE_NAME		   ' + char(10)
			SELECT @v_dSql += '	  , A.LINE_SETUP_GROUP_ID AS LINE_SETUP_GROUP_ID, A.ELECTRODE_TYPE AS ELECTRODE_TYPE,  A.LINE_TYPE AS LINE_TYPE                ' + char(10)
			
			SELECT @v_dSql += '	  , A.MES_LINE_ID AS MES_LINE_ID, A.WORK_CENTER_ID AS WORK_CENTER_ID' + char(10)
			
			
			SELECT @v_dSql += '	  , A.LINE_TYPE_NAME AS LINE_TYPE_NAME, A.MODEL_TYPE AS LINE_MODEL_TYPE                                                        ' + char(10)
			SELECT @v_dSql += '	  , ( CASE WHEN A.LINE_ATTR_1 = ''-'' THEN ''Normal'' ELSE A.LINE_ATTR_1 END ) AS LINE_ATTRIBUTE1, A.LOCATION AS LINE_LOCATION ' + char(10)
			SELECT @v_dSql += '	  , A.ACTIVE_FLAG AS ACTIVE_FLAG, A.DESCRIPTION AS DESCRIPTION,  A.SCP_LINE_ID AS SCP_LINE_ID,  A.PROD_VERSION_TYPE As PROD_VERSION_TYPE ' + char(10)
			SELECT @v_dSql += '	  ,CAST( ( SELECT COUNT(*) FROM SCM_EQUIPMENT_M T(NOLOCK)                                          ' + char(10)
			SELECT @v_dSql += '		 WHERE T.COMPANY_ID    = A.COMPANY_ID  AND   T.DIVISION_ID    = A.DIVISION_ID            ' + char(10)
			SELECT @v_dSql += '		   AND   T.SITE_ID     = A.SITE_ID     AND   T.PLANT_ID       = A.PLANT_ID               ' + char(10)
			SELECT @v_dSql += '		   AND   T.FACTORY_ID  = A.FACTORY_ID  AND   T.OPERATION_ID   = A.OPERATION_ID           ' + char(10)
			SELECT @v_dSql += '		   AND   T.LINE_ID     = A.LINE_ID     AND   T.ELECTRODE_TYPE = A.ELECTRODE_TYPE         ' + char(10)
			SELECT @v_dSql += '		   AND   T.ACTIVE_FLAG = ''Y''         AND   T.EQUIPMENT_TYPE = ''M''                    ' + char(10)
			SELECT @v_dSql += '		) AS CHAR(10) ) AS EQUIPMENT_COUNT                                                        ' + char(10)
			SELECT @v_dSql += '	  , '''' AS MESSAGE_ID,   CASE WHEN R.FACTORY_ID IS NULL THEN ''N'' ELSE ''Y'' END VALID_YN  ' + char(10)
			SELECT @v_dSql += '	FROM  SCM_LINE_M A WITH(NOLOCK)                                                              ' + char(10)
      		SELECT @v_dSql += '		LEFT OUTER JOIN (                                                                        ' + char(10)
			SELECT @v_dSql += '          SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID    ' + char(10)
			SELECT @v_dSql += '          FROM	 FP_USER_ROLE_INFO_V R WITH(NOLOCK)		' + char(10)
			SELECT @v_dSql += '          WHERE	 R.USER_ID	    = '''+ @p_user_id +''' 	' + char(10)
			SELECT @v_dSql += '          AND     R.SAVE_FLAG	= ''Y''         ' + char(10)
			SELECT @v_dSql += '     ) R                                         ' + char(10)
			SELECT @v_dSql += '     ON      1=1                                 ' + char(10)
			SELECT @v_dSql += '     AND     A.COMPANY_ID    = R.COMPANY_ID      ' + char(10)
			SELECT @v_dSql += '     AND     A.DIVISION_ID   = R.DIVISION_ID     ' + char(10)
			SELECT @v_dSql += '     AND     A.SITE_ID       = R.SITE_ID	        ' + char(10)
			SELECT @v_dSql += '     AND     A.PLANT_ID      = R.PLANT_ID        ' + char(10)
			SELECT @v_dSql += '     AND     A.FACTORY_ID    = R.FACTORY_ID      ' + char(10)
			SELECT @v_dSql += '	, SCM_OPERATION_M B WITH(NOLOCK)                ' + char(10)
			SELECT @v_dSql += '	WHERE A.COMPANY_ID    = B.COMPANY_ID            ' + char(10)
			SELECT @v_dSql += '	AND   A.DIVISION_ID   = B.DIVISION_ID           ' + char(10)
			SELECT @v_dSql += '	AND   A.SITE_ID       = B.SITE_ID               ' + char(10)
			SELECT @v_dSql += '	AND   A.OPERATION_ID  = B.OPERATION_ID          ' + char(10)
			SELECT @v_dSql += '	AND  ( B.WO_FLAG = ''Y'' OR B.MO_FLAG = ''Y'' ) ' + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.ACTIVE_FLAG' , 'EQ', @p_active_flag))    + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.DIVISION_ID' , 'EQ', @p_division_id))    + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.SITE_ID' , 'EQ', @p_site_id))            + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.PLANT_ID' , 'EQ', @p_plant_id))          + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.FACTORY_ID' , 'EQ', @p_factory_id))      + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.OPERATION_ID' , 'EQ', @p_operation_id))  + char(10)
			SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]( 'A.LINE_ID' , 'EQ', @p_line_id))            + char(10)
			SELECT @v_dSql += '	AND    EXISTS (                                                                                 ' + char(10)
			SELECT @v_dSql += '               SELECT 1                                                                          ' + char(10)
			SELECT @v_dSql += '               FROM   FP_USER_ROLE_INFO_V C WITH(NOLOCK)                                         ' + char(10)
			SELECT @v_dSql += '               WHERE  A.COMPANY_ID  = C.COMPANY_ID     AND  A.DIVISION_ID = C.DIVISION_ID        ' + char(10)
			SELECT @v_dSql += '                 AND    A.SITE_ID     = C.SITE_ID      AND  A.PLANT_ID    = C.PLANT_ID           ' + char(10)
			SELECT @v_dSql += '                 AND    A.FACTORY_ID  = C.FACTORY_ID   AND  C.USER_ID     = '''+@p_user_id +'''  ' + char(10)
			SELECT @v_dSql += '               )                                                                                 ' + char(10)
			SELECT @v_dSql += '	ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID          ' + char(10)

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
	    END	--ELSE IF( END )
    /************************************************************************************************/
	/* SEL_VALID인경우 :(Excel Upload Validation Select)                                            */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='SELECT_VALID')
	    BEGIN --ELSE IF(START)
		    SELECT @v_dSql = ''
            SELECT @v_dSql += '  SELECT  A.COMPANY_ID AS COMPANY_ID,            A.DIVISION_ID AS DIVISION_ID,           A.SITE_ID AS SITE_ID                            ' + char(10)
	        SELECT @v_dSql += '     , A.PLANT_ID   AS PLANT_ID,                 A.FACTORY_ID AS FACTORY_ID,             A.OPERATION_ID AS OPERATION_ID				    ' + char(10)
	        SELECT @v_dSql += '     , A.LINE_ID AS LINE_ID,                     A.LINE_NAME  AS LINE_NAME,              A.LINE_SETUP_GROUP_ID AS LINE_SETUP_GROUP_ID	' + char(10)
	        SELECT @v_dSql += '     , A.ELECTRODE_TYPE AS ELECTRODE_TYPE,       A.LINE_TYPE AS LINE_TYPE,               A.LINE_TYPE_NAME AS LINE_TYPE_NAME		        ' + char(10)
	        SELECT @v_dSql += '     , A.MODEL_TYPE AS LINE_MODEL_TYPE,          A.LINE_ATTR_1  AS LINE_ATTRIBUTE1,      A.LOCATION AS LINE_LOCATION  ' + char(10)
	        SELECT @v_dSql += '     , A.ACTIVE_FLAG AS ACTIVE_FLAG,             A.DESCRIPTION AS DESCRIPTION,           A.SCP_LINE_ID AS SCP_LINE_ID ' + char(10)
	        SELECT @v_dSql += '     , A.PROD_VERSION_TYPE As PROD_VERSION_TYPE , '''' AS EQUIPMENT_COUNT, A.LINE_GROUP_ID ' + char(10)
	        SELECT @v_dSql += '     , CASE WHEN __MSG = '' Not Found'' THEN ( CASE WHEN MSG99 = '''' THEN '''' ELSE MSG99 END )						 ' + char(10)
	  	    SELECT @v_dSql += '     	  ELSE ( CASE WHEN MSG99 = '''' THEN __MSG ELSE __MSG + '' AND '' + MSG99 END )	   END AS MESSAGE_ID		 ' + char(10)
	        SELECT @v_dSql += '     , CASE WHEN __MSG = '' Not Found'' AND MSG99 = '''' THEN ''Y'' ELSE ''N'' END AS VALID_YN                        ' + char(10)
	        SELECT @v_dSql += '     , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER, A.TOP_LINE_ID AS ORG_LINE_ID ' + char(10)
			SELECT @v_dSql += '  FROM (																												 ' + char(10)
			SELECT @v_dSql += '	    SELECT A.* 	,  MSG1																								 ' + char(10)
			SELECT @v_dSql += '	       +(CASE WHEN (MSG1 = '''')                    THEN MSG2 ELSE (CASE WHEN MSG2 = '''' THEN '''' ELSE '','' + MSG2 END) END)	' + char(10)
			SELECT @v_dSql += '	       +(CASE WHEN (MSG1 = '''' AND MSG2 = '''')    THEN MSG3 ELSE (CASE WHEN MSG3 = '''' THEN '''' ELSE '','' + MSG3 END) END)	' + char(10)
			SELECT @v_dSql += '	       +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''') THEN MSG4 ELSE (CASE WHEN MSG4 = '''' THEN '''' ELSE '','' + MSG4 END) END) ' + char(10)
			SELECT @v_dSql += '	       +(CASE WHEN (MSG1 = '''' AND MSG2 = '''' AND MSG3 = '''' AND MSG4= '''') THEN MSG5 						 ' + char(10)
			SELECT @v_dSql += '	                   ELSE ( CASE WHEN MSG5 = '''' THEN '''' ELSE '','' + MSG5 END ) END )							 ' + char(10)
			SELECT @v_dSql += '	       + '' Not Found'' AS __MSG												 								 ' + char(10)
			SELECT @v_dSql += '	    FROM (																										 ' + char(10)
			SELECT @v_dSql += '	          SELECT A.COMPANY_ID,       A.DIVISION_ID,         A.SITE_ID,       A.PLANT_ID,          A.FACTORY_ID	 ' + char(10)
			SELECT @v_dSql += '	        		,A.OPERATION_ID,     A.LINE_ID,             A.LINE_NAME,     A.ELECTRODE_TYPE,    A.LINE_TYPE	 ' + char(10)
			SELECT @v_dSql += '	        		,A.LINE_TYPE_NAME,   A.LINE_SETUP_GROUP_ID, A.ACTIVE_FLAG,   A.TOP_LINE_ID,       A.DESCRIPTION	 ' + char(10)
			SELECT @v_dSql += '	        		,A.MODEL_TYPE,       A.LINE_ATTR_1,         A.LOCATION,      A.PROD_VERSION_TYPE, A.JOB_USER_ID	 ' + char(10)
			SELECT @v_dSql += '	        		,A.JOB_TIME,         A.JOB_TYPE,            A.JOB_ORDER,     CASE WHEN B.FACTORY_ID IS NULL THEN ''Factory'' ELSE '''' END AS MSG1 ' + char(10)
			SELECT @v_dSql += '	        		,CASE WHEN C.OPERATION_ID IS NULL THEN ''Operation'' ELSE '''' END AS MSG2	 ' + char(10)
			SELECT @v_dSql += '	        		,CASE WHEN D.CODE_ID IS NULL THEN ''Line Attribute'' ELSE '''' END AS MSG3	 ' + char(10)
			SELECT @v_dSql += '	        		,CASE WHEN F.CODE_ID IS NULL THEN ''Model Type'' ELSE '''' END AS MSG4		 ' + char(10)
			SELECT @v_dSql += '	        		,CASE WHEN R.FACTORY_ID IS NULL THEN ''Permissions'' ELSE '''' END AS MSG5	 ' + char(10)
			SELECT @v_dSql += '	        		,CASE WHEN ROW_NUMBER() 													 ' + char(10)
			SELECT @v_dSql += '	        		      OVER( PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.OPERATION_ID,A.LINE_ID,A.ELECTRODE_TYPE	  ' + char(10)
			SELECT @v_dSql += '	        			  ORDER BY  A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.OPERATION_ID,A.LINE_ID,A.ELECTRODE_TYPE) > 1 THEN  ' + char(10)
			SELECT @v_dSql += '	        			    ''Data Overlap''	ELSE '''' END AS MSG99,   SCP_LINE_ID, A.LINE_GROUP_ID ' + char(10)
			SELECT @v_dSql += '	          FROM   BUF_LINE_M A WITH(NOLOCK)																' + char(10)
			SELECT @v_dSql += '	              LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK)												' + char(10)
			SELECT @v_dSql += '	                 ON  A.COMPANY_ID   = B.COMPANY_ID		 AND A.DIVISION_ID  = B.DIVISION_ID				' + char(10)
			SELECT @v_dSql += '	                 AND A.SITE_ID      = B.SITE_ID			 AND A.PLANT_ID     = B.PLANT_ID				' + char(10)
			SELECT @v_dSql += '	                 AND A.FACTORY_ID   = B.FACTORY_ID		 AND B.ACTIVE_FLAG  = ''Y''						' + char(10)
			SELECT @v_dSql += '	              LEFT OUTER JOIN SCM_OPERATION_M C WITH(NOLOCK)											' + char(10)
			SELECT @v_dSql += '	                 ON  A.COMPANY_ID   = C.COMPANY_ID		 AND A.DIVISION_ID  = C.DIVISION_ID				' + char(10)
			SELECT @v_dSql += '	                 AND A.SITE_ID         = C.SITE_ID	         AND A.OPERATION_ID = C.OPERATION_ID		' + char(10)
			SELECT @v_dSql += '	              LEFT OUTER JOIN (																			' + char(10)
			SELECT @v_dSql += '	            	  SELECT A.SEGMENT1 AS SITE_ID	 , A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS PLANT_ID	' + char(10)
			SELECT @v_dSql += '	            		   , A.SEGMENT4 AS FACTORY_ID, A.SEGMENT5 AS CODE_ID								' + char(10)
			SELECT @v_dSql += '	            	  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)											' + char(10)
			SELECT @v_dSql += '	            	  WHERE  A.LOOKUP_TYPE_CODE = ''LINE_ATTRIBUTE''										' + char(10)
			SELECT @v_dSql += '	            	  AND    A.ACTIVE_FLAG      = ''Y''														' + char(10)
			SELECT @v_dSql += '	              ) D																						' + char(10)
			SELECT @v_dSql += '	              ON  A.DIVISION_ID     = D.DIVISION_ID														' + char(10)
			SELECT @v_dSql += '	                  AND A.SITE_ID     = D.SITE_ID		 AND A.PLANT_ID    = D.PLANT_ID						' + char(10)
			SELECT @v_dSql += '	                  AND A.FACTORY_ID  = D.FACTORY_ID	 AND A.LINE_ATTR_1 = D.CODE_ID						' + char(10)
			SELECT @v_dSql += '	              LEFT OUTER JOIN (																			' + char(10)
			SELECT @v_dSql += '	            	  SELECT A.SEGMENT1 AS SITE_ID,    A.SEGMENT2 AS DIVISION_ID,  A.SEGMENT3 AS PLANT_ID	' + char(10)
			SELECT @v_dSql += '	            		   , A.SEGMENT4 AS FACTORY_ID, A.SEGMENT5 AS CODE_ID								' + char(10)
			SELECT @v_dSql += '	            	  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)											' + char(10)
			SELECT @v_dSql += '	            	  WHERE  A.LOOKUP_TYPE_CODE = ''LINE_LOCATION''											' + char(10)
			SELECT @v_dSql += '	            	  AND    A.ACTIVE_FLAG      = ''Y''														' + char(10)
			SELECT @v_dSql += '	              ) E																						' + char(10)
			SELECT @v_dSql += '	              ON  A.DIVISION_ID = E.DIVISION_ID															' + char(10)
			SELECT @v_dSql += '	                  AND A.SITE_ID     = E.SITE_ID         AND A.PLANT_ID    = E.PLANT_ID					' + char(10)
			SELECT @v_dSql += '	                  AND A.FACTORY_ID  = E.FACTORY_ID		AND A.LOCATION    = E.CODE_ID					' + char(10)
			SELECT @v_dSql += '	              LEFT OUTER JOIN (																			' + char(10)
			SELECT @v_dSql += '	            	  SELECT A.SEGMENT1 AS SITE_ID,     A.SEGMENT2 AS DIVISION_ID,   A.SEGMENT3 AS PLANT_ID	' + char(10)
			SELECT @v_dSql += '	            		   , A.SEGMENT4 AS FACTORY_ID,  A.SEGMENT5 AS CODE_ID				  ' + char(10)
			SELECT @v_dSql += '	            	  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)							  ' + char(10)
			SELECT @v_dSql += '	            	  WHERE  A.LOOKUP_TYPE_CODE = ''LINE_MODEL_TYPE''						  ' + char(10)
			SELECT @v_dSql += '	            	  AND    A.ACTIVE_FLAG      = ''Y''										  ' + char(10)
			SELECT @v_dSql += '	              ) F																		  ' + char(10)
			SELECT @v_dSql += '	              ON  A.DIVISION_ID = F.DIVISION_ID											  ' + char(10)
			SELECT @v_dSql += '	                  AND A.SITE_ID     = F.SITE_ID			  AND A.PLANT_ID    = F.PLANT_ID  ' + char(10)
			SELECT @v_dSql += '	                  AND A.FACTORY_ID  = F.FACTORY_ID		  AND A.MODEL_TYPE  = F.CODE_ID	  ' + char(10)
          	SELECT @v_dSql += '	              LEFT OUTER JOIN (															  ' + char(10)
			SELECT @v_dSql += '	            			SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID ' + char(10)
			SELECT @v_dSql += '	            			FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)	 ' + char(10)
			SELECT @v_dSql += '	            			WHERE	1=1									 ' + char(10)
			SELECT @v_dSql += '	            			AND		R.USER_ID	= '''+ @p_user_id +'''	 ' + char(10)
			SELECT @v_dSql += '	            			AND		R.SAVE_FLAG	= ''Y''					 ' + char(10)
			SELECT @v_dSql += '	            	) R													 ' + char(10)
			SELECT @v_dSql += '	            	ON		1=1											 ' + char(10)
			SELECT @v_dSql += '	            	    AND		A.COMPANY_ID    = R.COMPANY_ID	AND		A.DIVISION_ID	= R.DIVISION_ID	 ' + char(10)
			SELECT @v_dSql += '	            	    AND		A.SITE_ID	    = R.SITE_ID		AND		A.PLANT_ID		= R.PLANT_ID	 ' + char(10)
			SELECT @v_dSql += '	            	    AND		A.FACTORY_ID    = R.FACTORY_ID	AND		A.OPERATION_ID	= R.OPERATION_ID ' + char(10)
			SELECT @v_dSql += '	           WHERE A.JOB_USER_ID =  '''+ @p_user_id +'''	' + char(10)
			SELECT @v_dSql += '	    ) A					 ' + char(10)
			SELECT @v_dSql += '  ) A					 ' + char(10)
			SELECT @v_dSql += '  ORDER BY A.JOB_ORDER ;	 ' + char(10)
			
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
		END	--ELSE IF(END)

	ELSE
	-- 트랜잭션 (TRAN)
	BEGIN TRY				                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
			BEGIN TRAN   

			BEGIN --ELSE ( BEGIN )
				--max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행
				WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
					BEGIN --WHILE 내(START)

						SELECT @mst_loop_cnt = @mst_loop_cnt + 1	-- @mst_loop_cnt 1증가
                    
						SELECT  @v_sys_type         = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_type,           @v_delimiter, @mst_loop_cnt)
						   , @v_sys_flag            = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_flag,           @v_delimiter, @mst_loop_cnt)
						   , @v_sys_gubun           = [dbo].[SCM_ARR_SPL_VAL]( @p_sys_gubun,          @v_delimiter, @mst_loop_cnt)
						   , @v_user_id             = [dbo].[SCM_ARR_SPL_VAL]( @p_user_id,            @v_delimiter, @mst_loop_cnt)
						   , @v_company_id          = [dbo].[SCM_ARR_SPL_VAL]( @p_company_id,         @v_delimiter, @mst_loop_cnt)
						   , @v_division_id         = [dbo].[SCM_ARR_SPL_VAL]( @p_division_id,        @v_delimiter, @mst_loop_cnt)
						   , @v_site_id             = [dbo].[SCM_ARR_SPL_VAL]( @p_site_id,            @v_delimiter, @mst_loop_cnt)
						   , @v_plant_id            = [dbo].[SCM_ARR_SPL_VAL]( @p_plant_id,           @v_delimiter, @mst_loop_cnt)
						   , @v_factory_id          = [dbo].[SCM_ARR_SPL_VAL]( @p_factory_id,         @v_delimiter, @mst_loop_cnt)
						   , @v_operation_id        = [dbo].[SCM_ARR_SPL_VAL]( @p_operation_id,       @v_delimiter, @mst_loop_cnt)
						   , @v_line_id             = [dbo].[SCM_ARR_SPL_VAL]( @p_line_id,            @v_delimiter, @mst_loop_cnt)
						   , @v_line_name           = [dbo].[SCM_ARR_SPL_VAL]( @p_line_name,          @v_delimiter, @mst_loop_cnt)
						   , @v_line_setup_group_id = [dbo].[SCM_ARR_SPL_VAL]( @p_line_setup_group_id,@v_delimiter, @mst_loop_cnt)
						   , @v_electrode_type      = [dbo].[SCM_ARR_SPL_VAL]( @p_electrode_type,     @v_delimiter, @mst_loop_cnt)
						   , @v_line_type           = [dbo].[SCM_ARR_SPL_VAL]( @p_line_type,          @v_delimiter, @mst_loop_cnt)
						   , @v_line_type_name      = [dbo].[SCM_ARR_SPL_VAL]( @p_line_type_name,     @v_delimiter, @mst_loop_cnt)
						   , @v_model_type          = [dbo].[SCM_ARR_SPL_VAL]( @p_model_type,         @v_delimiter, @mst_loop_cnt)
						   , @v_line_attribute1     = [dbo].[SCM_ARR_SPL_VAL]( @p_line_attribute1,    @v_delimiter, @mst_loop_cnt)
						   , @v_line_location       = [dbo].[SCM_ARR_SPL_VAL]( @p_line_location,      @v_delimiter, @mst_loop_cnt)
						   , @v_active_flag         = [dbo].[SCM_ARR_SPL_VAL]( @p_active_flag,        @v_delimiter, @mst_loop_cnt)
						   , @v_description         = [dbo].[SCM_ARR_SPL_VAL]( @p_description,        @v_delimiter, @mst_loop_cnt)
						   , @v_scp_line_id         = [dbo].[SCM_ARR_SPL_VAL]( @p_scp_line_id,        @v_delimiter, @mst_loop_cnt)
						   , @v_prod_version_type   = [dbo].[SCM_ARR_SPL_VAL]( @p_prod_version_type,  @v_delimiter, @mst_loop_cnt)
						   , @v_equipment_count     = [dbo].[SCM_ARR_SPL_VAL]( @p_equipment_count,    @v_delimiter, @mst_loop_cnt)
						   , @v_mes_line_id         = [dbo].[SCM_ARR_SPL_VAL]( @p_mes_line_id,        @v_delimiter, @mst_loop_cnt)
						   , @v_work_center_id      = [dbo].[SCM_ARR_SPL_VAL]( @p_work_center_id,     @v_delimiter, @mst_loop_cnt)
						   , @v_pseudo_factory_id   = [dbo].[SCM_ARR_SPL_VAL]( @p_pseudo_factory_id,  @v_delimiter, @mst_loop_cnt)
						   , @v_line_group_id       = [dbo].[SCM_ARR_SPL_VAL]( @p_line_group_id,      @v_delimiter, @mst_loop_cnt)
						   , @v_virtual_line_yn     = [dbo].[SCM_ARR_SPL_VAL]( @p_virtual_line_yn,    @v_delimiter, @mst_loop_cnt) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 가상 라인 YN 추가
						   , @v_link_line_id        = [dbo].[SCM_ARR_SPL_VAL]( @p_link_line_id,       @v_delimiter, @mst_loop_cnt) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 연계 라인 ID 추가
						   , @v_old_link_line_id    = '' -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 연계 라인 ID 추가
						   IF @v_sys_flag ='M' OR @v_sys_flag ='D'
							   BEGIN
                                   SELECT @v_old_link_line_id = SLM.LINK_LINE_ID
								   FROM   SCM_LINE_M	 SLM WITH(NOLOCK)
			                 	   WHERE  SLM.COMPANY_ID     = @v_company_id
			                 	   AND    SLM.DIVISION_ID    = @v_division_id
			                 	   AND    SLM.SITE_ID        = @v_site_id
			                 	   AND    SLM.PLANT_ID       = @v_plant_id
			                 	   AND    SLM.FACTORY_ID     = @v_factory_id
			                 	   AND    SLM.OPERATION_ID   = @v_operation_id
			                 	   AND    SLM.LINE_ID        = @v_line_id
			                 	   AND    SLM.ELECTRODE_TYPE = @v_electrode_type;
							   END;

                    
						/******************************************************************************/
						/* I 경우 : INSERT                                                            */
						/******************************************************************************/
						IF(@v_sys_flag ='I')  
                    		BEGIN
									SELECT @v_dSql = ''
									SELECT @v_dSql  = '	INSERT INTO SCM_LINE_M (                                                                                    ' + char(10)
									SELECT @v_dSql += '		  COMPANY_ID,     DIVISION_ID,               SITE_ID,                   PLANT_ID,          FACTORY_ID 	' + char(10)
									SELECT @v_dSql += '		, OPERATION_ID,   LINE_ID,                   LINE_NAME,                 ELECTRODE_TYPE,    LINE_TYPE	' + char(10)
									SELECT @v_dSql += '		, LINE_TYPE_NAME, LINE_SETUP_GROUP_ID,       MODEL_TYPE,                LINE_ATTR_1,       LOCATION		' + char(10)
									SELECT @v_dSql += '		, MES_LINE_ID, WORK_CENTER_ID' + char(10)
									SELECT @v_dSql += '		, ACTIVE_FLAG,    DESCRIPTION,               INSERT_ID,                 INSERT_TIME,       UPDATE_ID	' + char(10)
									SELECT @v_dSql += '		, UPDATE_TIME,    SCP_LINE_ID,               PROD_VERSION_TYPE, 		PSEUDO_FACTORY_ID				' + char(10)
									SELECT @v_dSql += '		, LINE_GROUP_ID ' + char(10)
									SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선, 가상 라인 flag, 연계 라인 ID 추가
									SELECT @v_dSql += '	)																											' + char(10)
									SELECT @v_dSql += '	VALUES (																									' + char(10)
									SELECT @v_dSql += '		  '''+ @v_company_id +''',    '''+ @v_division_id +''',        '''+ @v_site_id+''',       '''+ @v_plant_id +''',       '''+ @v_factory_id +'''	' + char(10)
									SELECT @v_dSql += '		, NULLIF('''+ @v_operation_id +''',''''),   NULLIF('''+ @v_line_id +''',''''),         NULLIF( N'''+ @v_line_name+''',''''),    NULLIF('''+ @v_electrode_type +''',''''), NULLIF('''+ @v_line_type +''','''')	' + char(10)
									SELECT @v_dSql += '		, N'''+ @v_line_type_name +''', NULLIF(N'''+ @v_line_setup_group_id +''',''''), ISNULL('''+ @v_model_type +''',''-''), ISNULL(N'''+ @v_line_attribute1 +''',''-'')	 ' + char(10)
      								SELECT @v_dSql += '		,	(CASE WHEN(SELECT MAX(A.SEGMENT5) AS LOCATION FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)				' + char(10)
          							SELECT @v_dSql += '					   WHERE  A.LOOKUP_TYPE_CODE = ''LINE_LOCATION'' AND A.ACTIVE_FLAG = ''Y''					' + char(10)
          							SELECT @v_dSql += '						AND   A.SEGMENT2 = '''+ @v_division_id +'''   AND A.SEGMENT1 = '''+ @v_site_id +''' 	' + char(10)
									SELECT @v_dSql += '						AND   A.SEGMENT3 = '''+ @v_plant_id +'''      AND A.SEGMENT4 = '''+ @v_factory_id +'''	' + char(10)
          							SELECT @v_dSql += '						AND   A.SEGMENT5 = '''+ @v_line_location +''') IS NULL THEN ''-'' ELSE N'''+ @v_line_location +''' END )	' + char(10)

									SELECT @v_dSql += '		, NULLIF('''+ @v_mes_line_id +''',''''), NULLIF('''+ @v_work_center_id +''','''')	' + char(10)									

									SELECT @v_dSql += '		, '''+ @v_active_flag +''',    N'''+ @v_description +''',       '''+ @v_user_id +''',          SYSDATETIME(),    '''+ @v_user_id +'''	' + char(10)
									SELECT @v_dSql += '		, SYSDATETIME(),              N'''+ @v_scp_line_id +''',        N'''+ @v_prod_version_type +'''			' + char(10)
									SELECT @v_dSql += '		, N'''+ @v_pseudo_factory_id +'''			' + char(10)
									SELECT @v_dSql += '		, N'''+ @v_line_group_id +''' ' + char(10)
									SELECT @v_dSql += '		, NULLIF(N'''+ @v_virtual_line_yn +''','''') , NULLIF(N'''+ @v_link_line_id +''','''') ' + char(10) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선, 가상 라인 flag, 연계 라인 ID 추가
									SELECT @v_dSql += '	)																											' + char(10)
        							SELECT @v_dSql += '																												' + char(10)
									SELECT @v_dSql += '	INSERT INTO HIS_LINE_M (																					' + char(10)
									SELECT @v_dSql += '		  COMPANY_ID,          DIVISION_ID,     SITE_ID,       PLANT_ID,       FACTORY_ID						' + char(10)
									SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,         LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE						' + char(10)
									SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME,  ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE						' + char(10)
									SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,      INSERT_TIME,    UPDATE_ID						' + char(10)

									SELECT @v_dSql += '		, MES_LINE_ID, WORK_CENTER_ID' + char(10)

									SELECT @v_dSql += '		, UPDATE_TIME,         JOB_USER_ID,     JOB_TIME,      JOB_TYPE,       SCP_LINE_ID,   PROD_VERSION_TYPE	' + char(10)
									SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
									SELECT @v_dSql += '		, LINE_GROUP_ID ' + char(10)
									SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선, 가상 라인 flag, 연계 라인 ID 추가
									SELECT @v_dSql += '	)  														   													' + char(10)
									SELECT @v_dSql += '	SELECT COMPANY_ID,         DIVISION_ID,     SITE_ID,       PLANT_ID,       FACTORY_ID						' + char(10)
									SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,         LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE						' + char(10)
									SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME,  ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE						' + char(10)
									SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,        INSERT_ID,     INSERT_TIME,    UPDATE_ID						' + char(10)

									SELECT @v_dSql += '		, MES_LINE_ID, WORK_CENTER_ID' + char(10)

									SELECT @v_dSql += '		, UPDATE_TIME,   '''+ @v_user_id +''',  SYSDATETIME(), ''INSERT'',     SCP_LINE_ID,   PROD_VERSION_TYPE	' + char(10)
									SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
									SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
									SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선, 가상 라인 flag, 연계 라인 ID 추가
									SELECT @v_dSql += '	FROM  SCM_LINE_M A WITH(NOLOCK)																				' + char(10)
									SELECT @v_dSql += '	WHERE COMPANY_ID               = '''+ @v_company_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   DIVISION_ID              = '''+ @v_division_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   SITE_ID                  = '''+ @v_site_id +'''				' + char(10)
									SELECT @v_dSql += '	AND   PLANT_ID                 = '''+ @v_plant_id +'''				' + char(10)
									SELECT @v_dSql += '	AND   FACTORY_ID               = '''+ @v_factory_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   OPERATION_ID             = '''+ @v_operation_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   LINE_ID                  = '''+ @v_line_id +'''				' + char(10)
									SELECT @v_dSql += '	AND  ISNULL(ELECTRODE_TYPE,'''') = '''+ @v_electrode_type +'''   	' + char(10)


									-- Tray Simulation 업데이트 해준다.
									SELECT @v_dSql += '	UPDATE	A												' + char(10)
									SELECT @v_dSql += '	SET		A.PSEUDO_FACTORY_ID = B.PSEUDO_FACTORY_ID		' + char(10)
									SELECT @v_dSql += '		   ,A.UPDATE_ID = '''+ @v_proc_name +'''						' + char(10)
									SELECT @v_dSql += '		   ,A.UPDATE_DATE = SYSDATETIME()					' + char(10)
									SELECT @v_dSql += '	FROM	SCM_FCS_TRAY_MODEL_M A							' + char(10)
									SELECT @v_dSql += '		   ,SCM_LINE_M B WITH(NOLOCK)						' + char(10)
									SELECT @v_dSql += '	WHERE	1=1												' + char(10)
									SELECT @v_dSql += '	AND   A.COMPANY_ID        = '''+ @v_company_id +'''		' + char(10)
									SELECT @v_dSql += '	AND   A.DIVISION_ID       = '''+ @v_division_id +'''		' + char(10)
									SELECT @v_dSql += '	AND   A.SITE_ID           = '''+ @v_site_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   A.PLANT_ID          = '''+ @v_plant_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   A.LINE_ID           = '''+ @v_line_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   A.COMPANY_ID        = B.COMPANY_ID               ' + char(10)
									SELECT @v_dSql += '	AND   A.DIVISION_ID       = B.DIVISION_ID              ' + char(10)
									SELECT @v_dSql += '	AND   A.SITE_ID           = B.SITE_ID                  ' + char(10)
									SELECT @v_dSql += '	AND   A.PLANT_ID          = B.PLANT_ID                 	' + char(10)
									SELECT @v_dSql += '	AND   A.LINE_ID           = B.LINE_ID                  ' + char(10)
									SELECT @v_dSql += '	AND   B.PSEUDO_FACTORY_ID IS NOT NULL       ' + char(10)

									-- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선. 가상 라인 flag, 연계 라인 추가 시작
									IF @v_link_line_id != ''
							            BEGIN
											SELECT @v_dSql += ''
											SELECT @v_dSql += '	UPDATE SCM_LINE_M SET                                                       ' + char(10)
											SELECT @v_dSql += '		  LINK_LINE_ID         = N'''+ @v_line_id +'''' + char(10)
											SELECT @v_dSql += '		, UPDATE_ID            = '''+ @v_user_id +'''							' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME          = SYSDATETIME()									' + char(10)
											SELECT @v_dSql += '	WHERE  OPERATION_ID         = '''+ @v_operation_id +'''						' + char(10)
											SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_link_line_id +'''		 		    	' + char(10)
											SELECT @v_dSql += '	AND    ELECTRODE_TYPE       = '''+ @v_electrode_type +'''		        	' + char(10)
											SELECT @v_dSql += '	;																			' + char(10)
        									SELECT @v_dSql += '																							' + char(10)
											SELECT @v_dSql += '	INSERT INTO HIS_LINE_M (																' + char(10)
											SELECT @v_dSql += '		  COMPANY_ID,          DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE		' + char(10)
											SELECT @v_dSql += '		, MES_LINE_ID,        WORK_CENTER_ID' + char(10)
											SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE	' + char(10)
											SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID		' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME,         JOB_USER_ID,    JOB_TIME,      JOB_TYPE,       SCP_LINE_ID,  PROD_VERSION_TYPE	' + char(10)
											SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
											SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10)
											SELECT @v_dSql += '	)														  													' + char(10)
											SELECT @v_dSql += '	SELECT COMPANY_ID,         DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID 						' + char(10)
											SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE							' + char(10)
											SELECT @v_dSql += '		, MES_LINE_ID,        WORK_CENTER_ID' + char(10)
											SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE 						' + char(10)
											SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID							' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME,         '''+ @v_user_id +''', SYSDATETIME(), ''UPDATE'', SCP_LINE_ID, PROD_VERSION_TYPE	' + char(10)
											SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
											SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10)
											SELECT @v_dSql += '	FROM  SCM_LINE_M A WITH(NOLOCK)																				' + char(10)
											SELECT @v_dSql += '	WHERE  OPERATION_ID         = '''+ @v_operation_id +'''						' + char(10)
											SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_link_line_id +'''		 	    		' + char(10)
											SELECT @v_dSql += '	AND    ELECTRODE_TYPE       = '''+ @v_electrode_type +'''		        	' + char(10)
											SELECT @v_dSql += '; ' + char(10)+ char(10)
							            END;
									-- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선. 가상 라인 flag, 연계 라인 추가 끝

							   END --'I'
						/****************************************************************************/
						/* UPDATE  경우  :M                                                         */
						/****************************************************************************/
						ELSE IF(@v_sys_flag ='M')
                    		BEGIN
									SELECT @v_dSql = ''
									SELECT @v_dSql += '	UPDATE SCM_LINE_M SET                                                       ' + char(10)
        							SELECT @v_dSql += '		  PROD_VERSION_TYPE    = N'''+ @v_prod_version_type +'''				' + char(10)
									SELECT @v_dSql += '		, ACTIVE_FLAG          = '''+ @v_active_flag +'''						' + char(10)
									SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID  = NULLIF(N'''+ @v_line_setup_group_id +''','''')	' + char(10)
									SELECT @v_dSql += '		, LINE_TYPE            = '''+ @v_line_type +'''							' + char(10)
									SELECT @v_dSql += '		, LINE_TYPE_NAME       = N'''+ @v_line_type_name +'''					' + char(10)
									SELECT @v_dSql += '		, MODEL_TYPE           = N'''+ @v_model_type +'''						' + char(10)
									SELECT @v_dSql += '		, LINE_ATTR_1          = ISNULL(N'''+ @v_line_attribute1 +''',''-'')	' + char(10)
									SELECT @v_dSql += '		, LOCATION             = NULLIF('''+ @v_line_location +''','''')  ' + char(10)
									SELECT @v_dSql += '		, SCP_LINE_ID          = NULLIF(N'''+ @v_scp_line_id +''','''')	' + char(10)
									SELECT @v_dSql += '		, LINE_NAME            = N'''+ @v_line_name +'''						' + char(10)

									SELECT @v_dSql += '		, MES_LINE_ID            = NULLIF(N'''+ @v_mes_line_id +''','''')' + char(10)
									SELECT @v_dSql += '		, WORK_CENTER_ID            = NULLIF(N'''+ @v_work_center_id +''','''')' + char(10)
									SELECT @v_dSql += '		, PSEUDO_FACTORY_ID            = NULLIF(N'''+ @v_pseudo_factory_id +''','''')' + char(10)
									SELECT @v_dSql += '		, LINE_GROUP_ID            = NULLIF(N'''+ @v_line_group_id +''','''')' + char(10)
									SELECT @v_dSql += '		, VIRTUAL_LINE_YN      = NULLIF(N'''+ @v_virtual_line_yn +''','''')' + char(10) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선, 가상 라인 flag 추가
									SELECT @v_dSql += '		, LINK_LINE_ID         = NULLIF(N'''+ @v_link_line_id +''','''')' + char(10) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선, 연계 라인 ID 추가

									SELECT @v_dSql += '		, UPDATE_ID            = '''+ @v_user_id +'''							' + char(10)
									SELECT @v_dSql += '		, UPDATE_TIME          = SYSDATETIME()									' + char(10)
									SELECT @v_dSql += '	WHERE  COMPANY_ID           = '''+ @v_company_id +'''						' + char(10)
									SELECT @v_dSql += '	AND    DIVISION_ID          = '''+ @v_division_id +'''						' + char(10)
									SELECT @v_dSql += '	AND    SITE_ID              = '''+ @v_site_id +'''							' + char(10)
									SELECT @v_dSql += '	AND    PLANT_ID             = '''+ @v_plant_id +'''							' + char(10)
									SELECT @v_dSql += '	AND    FACTORY_ID           = '''+ @v_factory_id +'''						' + char(10)
									SELECT @v_dSql += '	AND    OPERATION_ID         = '''+ @v_operation_id +'''						' + char(10)
									SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_line_id +'''							' + char(10)
									SELECT @v_dSql += '	AND    ISNULL(ELECTRODE_TYPE,'''') = '''+ @v_electrode_type +'''			' + char(10)
									SELECT @v_dSql += '	;																			' + char(10)
        							SELECT @v_dSql += '																							' + char(10)
									SELECT @v_dSql += '	INSERT INTO HIS_LINE_M (																' + char(10)
									SELECT @v_dSql += '		  COMPANY_ID,          DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID	' + char(10)
									SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE		' + char(10)

									SELECT @v_dSql += '		, MES_LINE_ID,        WORK_CENTER_ID' + char(10)

									SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE	' + char(10)
									SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID		' + char(10)
									SELECT @v_dSql += '		, UPDATE_TIME,         JOB_USER_ID,    JOB_TIME,      JOB_TYPE,       SCP_LINE_ID,  PROD_VERSION_TYPE	' + char(10)
									SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
									SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
									SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선, 가상 라인 flag, 연계 라인 ID 추가
									SELECT @v_dSql += '	)														  													' + char(10)
									SELECT @v_dSql += '	SELECT COMPANY_ID,         DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID 						' + char(10)
									SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE							' + char(10)

									SELECT @v_dSql += '		, MES_LINE_ID,        WORK_CENTER_ID' + char(10)

									SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE 						' + char(10)
									SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID							' + char(10)
									SELECT @v_dSql += '		, UPDATE_TIME,         '''+ @v_user_id +''', SYSDATETIME(), ''UPDATE'', SCP_LINE_ID, PROD_VERSION_TYPE	' + char(10)
									SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
									SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
									SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선, 가상 라인 flag, 연계 라인 ID 추가
									SELECT @v_dSql += '	FROM  SCM_LINE_M A WITH(NOLOCK)																				' + char(10)
									SELECT @v_dSql += '	WHERE  COMPANY_ID           = '''+ @v_company_id +'''			 ' + char(10)
									SELECT @v_dSql += '	AND    DIVISION_ID          = '''+ @v_division_id +'''			 ' + char(10)
									SELECT @v_dSql += '	AND    SITE_ID              = '''+ @v_site_id +'''				 ' + char(10)
									SELECT @v_dSql += '	AND    PLANT_ID             = '''+ @v_plant_id +'''				 ' + char(10)
									SELECT @v_dSql += '	AND    FACTORY_ID           = '''+ @v_factory_id +'''			 ' + char(10)
									SELECT @v_dSql += '	AND    OPERATION_ID         = '''+ @v_operation_id +'''			 ' + char(10)
									SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_line_id +'''				 ' + char(10)

									--SELECT @v_dSql += '	AND    MES_LINE_ID              = '''+ @v_line_id +'''				 ' + char(10)
									--SELECT @v_dSql += '	AND    WORK_CENTER_ID              = '''+ @v_line_id +'''				 ' + char(10)

									SELECT @v_dSql += '	AND    ISNULL(ELECTRODE_TYPE,'''') = '''+ @v_electrode_type +''' ' + char(10)
									SELECT @v_dSql += '; ' + char(10)+ char(10)


									-- Tray Simulation 업데이트 해준다.
									SELECT @v_dSql += '	UPDATE	A												' + char(10)
									SELECT @v_dSql += '	SET		A.PSEUDO_FACTORY_ID = B.PSEUDO_FACTORY_ID		' + char(10)
									SELECT @v_dSql += '		   ,A.UPDATE_ID = '''+ @v_proc_name +'''						' + char(10)
									SELECT @v_dSql += '		   ,A.UPDATE_DATE = SYSDATETIME()					' + char(10)
									SELECT @v_dSql += '	FROM	SCM_FCS_TRAY_MODEL_M A							' + char(10)
									SELECT @v_dSql += '		   ,SCM_LINE_M B WITH(NOLOCK)						' + char(10)
									SELECT @v_dSql += '	WHERE	1=1												' + char(10)
									SELECT @v_dSql += '	AND   A.COMPANY_ID        = '''+ @v_company_id +'''		' + char(10)
									SELECT @v_dSql += '	AND   A.DIVISION_ID       = '''+ @v_division_id +'''		' + char(10)
									SELECT @v_dSql += '	AND   A.SITE_ID           = '''+ @v_site_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   A.PLANT_ID          = '''+ @v_plant_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   A.LINE_ID           = '''+ @v_line_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   A.COMPANY_ID        = B.COMPANY_ID               ' + char(10)
									SELECT @v_dSql += '	AND   A.DIVISION_ID       = B.DIVISION_ID              ' + char(10)
									SELECT @v_dSql += '	AND   A.SITE_ID           = B.SITE_ID                  ' + char(10)
									SELECT @v_dSql += '	AND   A.PLANT_ID          = B.PLANT_ID                 	' + char(10)
									SELECT @v_dSql += '	AND   A.LINE_ID           = B.LINE_ID                  ' + char(10)
									SELECT @v_dSql += '	AND   B.PSEUDO_FACTORY_ID IS NOT NULL       ' + char(10)
									SELECT @v_dSql += '; ' + char(10)+ char(10)

									-- line assign Active 동기화 처리... 20240202
									SELECT @v_dSql += 'UPDATE SCM_ITEM_LINE_ASSIGN_M SET ' + char(10)
									SELECT @v_dSql += '       ACTIVE_FLAG          = ''' + @v_active_flag + ''' ' + char(10)
									SELECT @v_dSql += '     , UPDATE_ID            = ''' + @v_user_id + ''' + ''_LINE UPDATED'' ' + char(10)
									SELECT @v_dSql += '     , UPDATE_TIME          = SYSDATETIME() ' + char(10)
									SELECT @v_dSql += 'WHERE  COMPANY_ID           = ''' + @v_company_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    DIVISION_ID          = ''' + @v_division_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    SITE_ID              = ''' + @v_site_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    PLANT_ID             = ''' + @v_plant_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    FACTORY_ID           = ''' + @v_factory_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    OPERATION_ID         = ''' + @v_operation_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    LINE_ID              = ''' + @v_line_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    ISNULL(ELECTRODE_TYPE,'''') = ''' + @v_electrode_type + ''' ' + char(10)
									SELECT @v_dSql += '; ' + char(10)+ char(10)
									SELECT @v_dSql += 'INSERT INTO HIS_ITEM_LINE_ASSIGN_M ( ' + char(10)
									SELECT @v_dSql += '       COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID ' + char(10)
									SELECT @v_dSql += '     , ITEM_ID, LANE_QTY, OPERATION_ID, LINE_ID, MONTH, WORK_CENTER_ID ' + char(10)
									SELECT @v_dSql += '     , PRIORITY ' + char(10)
									SELECT @v_dSql += '     , CERTIFICATION_FLAG, CERTIFICATION_DATE ' + char(10)
									SELECT @v_dSql += '     , ACTIVE_FLAG ' + char(10)
									SELECT @v_dSql += '     , INSERT_ID, INSERT_TIME ' + char(10)
									SELECT @v_dSql += '     , UPDATE_ID, UPDATE_TIME ' + char(10)
									SELECT @v_dSql += '     , JOB_USER_ID, JOB_TIME, JOB_TYPE ' + char(10)
									SELECT @v_dSql += '     , ELECTRODE_TYPE, DESCRIPTION, WIP_LEVEL_QTY ' + char(10)
									SELECT @v_dSql += ') ' + char(10)
									SELECT @v_dSql += 'SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID ' + char(10)
									SELECT @v_dSql += '     , ITEM_ID, LANE_QTY, OPERATION_ID, LINE_ID, MONTH, WORK_CENTER_ID ' + char(10)
									SELECT @v_dSql += '     , PRIORITY ' + char(10)
									SELECT @v_dSql += '     , CERTIFICATION_FLAG, CERTIFICATION_DATE ' + char(10)
									SELECT @v_dSql += '     , ACTIVE_FLAG ' + char(10)
									SELECT @v_dSql += '     , INSERT_ID, INSERT_TIME ' + char(10)
									SELECT @v_dSql += '     , UPDATE_ID, UPDATE_TIME ' + char(10)
									SELECT @v_dSql += '     , ''' + @v_user_id + ''' AS JOB_USER_ID, SYSDATETIME() AS JOB_TIME, ''LINE UPDATED'' AS JOB_TYPE ' + char(10)
									SELECT @v_dSql += '     , ELECTRODE_TYPE, DESCRIPTION, WIP_LEVEL_QTY ' + char(10)
									SELECT @v_dSql += 'FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) ' + char(10)
									SELECT @v_dSql += 'WHERE  COMPANY_ID           = ''' + @v_company_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    DIVISION_ID          = ''' + @v_division_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    SITE_ID              = ''' + @v_site_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    PLANT_ID             = ''' + @v_plant_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    FACTORY_ID           = ''' + @v_factory_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    OPERATION_ID         = ''' + @v_operation_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    LINE_ID              = ''' + @v_line_id + ''' ' + char(10)
									SELECT @v_dSql += 'AND    ISNULL(ELECTRODE_TYPE,'''') = ''' + @v_electrode_type + ''' ' + char(10)
									SELECT @v_dSql += '; ' + char(10)+ char(10)

									-- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선. 가상 라인 flag, 연계 라인 추가 시작
							        IF @v_old_link_line_id != ''
							        AND @v_old_link_line_id != @v_link_line_id
							            BEGIN
											SELECT @v_dSql += ''
											SELECT @v_dSql += '	UPDATE SCM_LINE_M SET                                                       ' + char(10)
											SELECT @v_dSql += '		  LINK_LINE_ID         = NULL ' + char(10)
											SELECT @v_dSql += '		, UPDATE_ID            = '''+ @v_user_id +'''							' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME          = SYSDATETIME()									' + char(10)
											SELECT @v_dSql += '	WHERE  OPERATION_ID         = '''+ @v_operation_id +'''						' + char(10)
											SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_old_link_line_id +'''		 			' + char(10)
											SELECT @v_dSql += '	AND    ELECTRODE_TYPE       = '''+ @v_electrode_type +'''		        	' + char(10)
											SELECT @v_dSql += '	;																			' + char(10)
        									SELECT @v_dSql += '																							' + char(10)
											SELECT @v_dSql += '	INSERT INTO HIS_LINE_M (																' + char(10)
											SELECT @v_dSql += '		  COMPANY_ID,          DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE		' + char(10)
											SELECT @v_dSql += '		, MES_LINE_ID,        WORK_CENTER_ID' + char(10)
											SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE	' + char(10)
											SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID		' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME,         JOB_USER_ID,    JOB_TIME,      JOB_TYPE,       SCP_LINE_ID,  PROD_VERSION_TYPE	' + char(10)
											SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
											SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10)
											SELECT @v_dSql += '	)														  													' + char(10)
											SELECT @v_dSql += '	SELECT COMPANY_ID,         DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID 						' + char(10)
											SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE							' + char(10)
											SELECT @v_dSql += '		, MES_LINE_ID,        WORK_CENTER_ID' + char(10)
											SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE 						' + char(10)
											SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID							' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME,         '''+ @v_user_id +''', SYSDATETIME(), ''UPDATE'', SCP_LINE_ID, PROD_VERSION_TYPE	' + char(10)
											SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
											SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10)
											SELECT @v_dSql += '	FROM  SCM_LINE_M A WITH(NOLOCK)																				' + char(10)
											SELECT @v_dSql += '	WHERE  OPERATION_ID         = '''+ @v_operation_id +'''						' + char(10)
											SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_old_link_line_id +'''		 			' + char(10)
											SELECT @v_dSql += '	AND    ELECTRODE_TYPE       = '''+ @v_electrode_type +'''		        	' + char(10)
											SELECT @v_dSql += '; ' + char(10)+ char(10)
							            END;
							        
							        IF @v_link_line_id != ''
							            BEGIN
											SELECT @v_dSql += ''
											SELECT @v_dSql += '	UPDATE SCM_LINE_M SET                                                       ' + char(10)
											SELECT @v_dSql += '		  LINK_LINE_ID         = N'''+ @v_line_id +'''' + char(10)
											SELECT @v_dSql += '		, UPDATE_ID            = '''+ @v_user_id +'''							' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME          = SYSDATETIME()									' + char(10)
											SELECT @v_dSql += '	WHERE  OPERATION_ID         = '''+ @v_operation_id +'''						' + char(10)
											SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_link_line_id +'''		 		    	' + char(10)
											SELECT @v_dSql += '	AND    ELECTRODE_TYPE       = '''+ @v_electrode_type +'''		        	' + char(10)
											SELECT @v_dSql += '	;																			' + char(10)
        									SELECT @v_dSql += '																							' + char(10)
											SELECT @v_dSql += '	INSERT INTO HIS_LINE_M (																' + char(10)
											SELECT @v_dSql += '		  COMPANY_ID,          DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE		' + char(10)
											SELECT @v_dSql += '		, MES_LINE_ID,        WORK_CENTER_ID' + char(10)
											SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE	' + char(10)
											SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID		' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME,         JOB_USER_ID,    JOB_TIME,      JOB_TYPE,       SCP_LINE_ID,  PROD_VERSION_TYPE	' + char(10)
											SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
											SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10)
											SELECT @v_dSql += '	)														  													' + char(10)
											SELECT @v_dSql += '	SELECT COMPANY_ID,         DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID 						' + char(10)
											SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE							' + char(10)
											SELECT @v_dSql += '		, MES_LINE_ID,        WORK_CENTER_ID' + char(10)
											SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE 						' + char(10)
											SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID							' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME,         '''+ @v_user_id +''', SYSDATETIME(), ''UPDATE'', SCP_LINE_ID, PROD_VERSION_TYPE	' + char(10)
											SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
											SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10)
											SELECT @v_dSql += '	FROM  SCM_LINE_M A WITH(NOLOCK)																				' + char(10)
											SELECT @v_dSql += '	WHERE  OPERATION_ID         = '''+ @v_operation_id +'''						' + char(10)
											SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_link_line_id +'''		 	    		' + char(10)
											SELECT @v_dSql += '	AND    ELECTRODE_TYPE       = '''+ @v_electrode_type +'''		        	' + char(10)
											SELECT @v_dSql += '; ' + char(10)+ char(10)
							            END;
									-- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선. 가상 라인 flag, 연계 라인 추가 끝
								END --M
						/****************************************************************************/
						/* DELETE경우 : D                                                           */
						/****************************************************************************/
						ELSE IF(@v_sys_flag ='D')
						   BEGIN
									SELECT @v_dSql = ''
									SELECT @v_dSql += '	INSERT INTO HIS_LINE_M (																					' + char(10)
									SELECT @v_dSql += '		  COMPANY_ID,          DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID						' + char(10)
									SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE							' + char(10)
									SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE						' + char(10)
									SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID							' + char(10)
									SELECT @v_dSql += '		, UPDATE_TIME,         JOB_USER_ID,    JOB_TIME,      JOB_TYPE,       SCP_LINE_ID,  PROD_VERSION_TYPE	' + char(10)
									SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
									SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
									SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선, 가상 라인 flag, 연계 라인 ID 추가
									SELECT @v_dSql += '	)														  													' + char(10)
									SELECT @v_dSql += '	SELECT COMPANY_ID,         DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID 						' + char(10)
									SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE							' + char(10)
									SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE 						' + char(10)
									SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID							' + char(10)
									SELECT @v_dSql += '		, UPDATE_TIME,         '''+ @v_user_id +''',     SYSDATETIME(), ''DELETE'',       SCP_LINE_ID,  PROD_VERSION_TYPE ' + char(10)
									SELECT @v_dSql += '		, PSEUDO_FACTORY_ID ' + char(10)
									SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
									SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10) -- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선, 가상 라인 flag, 연계 라인 ID 추가
									SELECT @v_dSql += '	FROM   SCM_LINE_M A WITH(NOLOCK)									' + char(10)
									SELECT @v_dSql += '	WHERE  COMPANY_ID           = '''+ @v_company_id +'''				' + char(10)
									SELECT @v_dSql += '	AND    DIVISION_ID          = '''+ @v_division_id +'''				' + char(10)
									SELECT @v_dSql += '	AND    SITE_ID              = '''+ @v_site_id +'''					' + char(10)
									SELECT @v_dSql += '	AND    PLANT_ID             = '''+ @v_plant_id +'''					' + char(10)
									SELECT @v_dSql += '	AND    FACTORY_ID           = '''+ @v_factory_id +'''				' + char(10)
									SELECT @v_dSql += '	AND    OPERATION_ID         = '''+ @v_operation_id +'''				' + char(10)
									SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_line_id +'''					' + char(10)
									SELECT @v_dSql += '	AND    ISNULL(ELECTRODE_TYPE,'''') = '''+ @v_electrode_type +'''	' + char(10)
									SELECT @v_dSql += '	;																	' + char(10)
        							SELECT @v_dSql += '																		' + char(10)
									SELECT @v_dSql += '	DELETE FROM SCM_LINE_M												' + char(10)
									SELECT @v_dSql += '	WHERE  COMPANY_ID           = '''+ @v_company_id +'''				' + char(10)
									SELECT @v_dSql += '	AND    DIVISION_ID          = '''+ @v_division_id +'''				' + char(10)
									SELECT @v_dSql += '	AND    SITE_ID              = '''+ @v_site_id +'''					' + char(10)
									SELECT @v_dSql += '	AND    PLANT_ID             = '''+ @v_plant_id +'''					' + char(10)
									SELECT @v_dSql += '	AND    FACTORY_ID           = '''+ @v_factory_id +'''				' + char(10)
									SELECT @v_dSql += '	AND    OPERATION_ID         = '''+ @v_operation_id +'''				' + char(10)
									SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_line_id +'''					' + char(10)
									SELECT @v_dSql += '	AND    ISNULL(ELECTRODE_TYPE,'''') = '''+  @v_electrode_type +'''	' + char(10)
									SELECT @v_dSql += '		' + char(13)

									-- Tray Simulation 업데이트 해준다.
									SELECT @v_dSql += '	UPDATE	A												' + char(10)
									SELECT @v_dSql += '	SET		A.PSEUDO_FACTORY_ID = '''+ @v_factory_id +'''		' + char(10)
									SELECT @v_dSql += '		   ,A.UPDATE_ID = '''+ @v_proc_name +'''						' + char(10)
									SELECT @v_dSql += '		   ,A.UPDATE_DATE = SYSDATETIME()					' + char(10)
									SELECT @v_dSql += '	FROM	SCM_FCS_TRAY_MODEL_M A							' + char(10)
									SELECT @v_dSql += '		   ,SCM_LINE_M B WITH(NOLOCK)						' + char(10)
									SELECT @v_dSql += '	WHERE	1=1												' + char(10)
									SELECT @v_dSql += '	AND   A.COMPANY_ID        = '''+ @v_company_id +'''		' + char(10)
									SELECT @v_dSql += '	AND   A.DIVISION_ID       = '''+ @v_division_id +'''		' + char(10)
									SELECT @v_dSql += '	AND   A.SITE_ID           = '''+ @v_site_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   A.PLANT_ID          = '''+ @v_plant_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   A.LINE_ID           = '''+ @v_line_id +'''			' + char(10)
									SELECT @v_dSql += '	AND   A.COMPANY_ID        = B.COMPANY_ID               ' + char(10)
									SELECT @v_dSql += '	AND   A.DIVISION_ID       = B.DIVISION_ID              ' + char(10)
									SELECT @v_dSql += '	AND   A.SITE_ID           = B.SITE_ID                  ' + char(10)
									SELECT @v_dSql += '	AND   A.PLANT_ID          = B.PLANT_ID                 	' + char(10)
									SELECT @v_dSql += '	AND   A.LINE_ID           = B.LINE_ID                  ' + char(10)
									SELECT @v_dSql += '	AND   B.PSEUDO_FACTORY_ID IS NOT NULL       ' + char(10)

									-- 2025/11/06 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선. 가상 라인 flag, 연계 라인 추가 시작
							        IF @v_old_link_line_id != ''
							            BEGIN
											SELECT @v_dSql += ''
											SELECT @v_dSql += '	UPDATE SCM_LINE_M SET                                                       ' + char(10)
											SELECT @v_dSql += '		  LINK_LINE_ID         = NULL ' + char(10)
											SELECT @v_dSql += '		, UPDATE_ID            = '''+ @v_user_id +'''							' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME          = SYSDATETIME()									' + char(10)
											SELECT @v_dSql += '	WHERE  OPERATION_ID         = '''+ @v_operation_id +'''						' + char(10)
											SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_old_link_line_id +'''		 			' + char(10)
											SELECT @v_dSql += '	AND    ELECTRODE_TYPE       = '''+ @v_electrode_type +'''		        	' + char(10)
											SELECT @v_dSql += '	;																			' + char(10)
        									SELECT @v_dSql += '																							' + char(10)
											SELECT @v_dSql += '	INSERT INTO HIS_LINE_M (																' + char(10)
											SELECT @v_dSql += '		  COMPANY_ID,          DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE		' + char(10)
											SELECT @v_dSql += '		, MES_LINE_ID,        WORK_CENTER_ID' + char(10)
											SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE	' + char(10)
											SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID		' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME,         JOB_USER_ID,    JOB_TIME,      JOB_TYPE,       SCP_LINE_ID,  PROD_VERSION_TYPE	' + char(10)
											SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
											SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10)
											SELECT @v_dSql += '	)														  													' + char(10)
											SELECT @v_dSql += '	SELECT COMPANY_ID,         DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID 						' + char(10)
											SELECT @v_dSql += '		, OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE							' + char(10)
											SELECT @v_dSql += '		, MES_LINE_ID,        WORK_CENTER_ID' + char(10)
											SELECT @v_dSql += '		, LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE 						' + char(10)
											SELECT @v_dSql += '		, LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID							' + char(10)
											SELECT @v_dSql += '		, UPDATE_TIME,         '''+ @v_user_id +''', SYSDATETIME(), ''UPDATE'', SCP_LINE_ID, PROD_VERSION_TYPE	' + char(10)
											SELECT @v_dSql += '		, PSEUDO_FACTORY_ID	' + char(10)
											SELECT @v_dSql += '		, LINE_GROUP_ID	' + char(10)
											SELECT @v_dSql += '		, VIRTUAL_LINE_YN, LINK_LINE_ID ' + char(10)
											SELECT @v_dSql += '	FROM  SCM_LINE_M A WITH(NOLOCK)																				' + char(10)
											SELECT @v_dSql += '	WHERE  OPERATION_ID         = '''+ @v_operation_id +'''						' + char(10)
											SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_old_link_line_id +'''		 			' + char(10)
											SELECT @v_dSql += '	AND    ELECTRODE_TYPE       = '''+ @v_electrode_type +'''		        	' + char(10)
											SELECT @v_dSql += '; ' + char(10)+ char(10)
							            END;

							   END --'D'
						/***************************************************************************/
						/* DELETE_BUFFER: Excel Import경우 (Excel Import Buffer Delete)           */
						/***************************************************************************/
						ELSE IF(@v_sys_flag ='DELETE_BUFFER')
							BEGIN
								   SELECT @v_dSql = ''
								   SELECT @v_dSql += '	 DELETE FROM BUF_LINE_M                    ' + char(10)
								   SELECT @v_dSql += '	 WHERE JOB_USER_ID = '''+ @v_user_id +'''  ' + char(10)

								END
						/***************************************************************/
						/* Excel Import경우 P: (Excel Import Buffer 저장)              */
						/***************************************************************/
						ELSE IF(@v_sys_flag ='INSERT_BUFFER')
							BEGIN
								SELECT @v_seq_no += 1
                        
								SELECT @v_dSql = ''
								SELECT @v_dSql += '  INSERT INTO BUF_LINE_M ( ' + char(10)
								SELECT @v_dSql += '    COMPANY_ID,     DIVISION_ID,     SITE_ID,         PLANT_ID             ' + char(10)
								SELECT @v_dSql += '  , FACTORY_ID,     OPERATION_ID,    LINE_ID,         LINE_NAME            ' + char(10)
								SELECT @v_dSql += '  , ELECTRODE_TYPE, LINE_TYPE,       LINE_TYPE_NAME,  LINE_SETUP_GROUP_ID  ' + char(10)
								SELECT @v_dSql += '  , ACTIVE_FLAG,    DESCRIPTION,     MODEL_TYPE,      LINE_ATTR_1          ' + char(10)
								SELECT @v_dSql += '  , LOCATION                                                               ' + char(10)
								SELECT @v_dSql += '  , JOB_USER_ID,    JOB_TIME,        JOB_TYPE,        JOB_ORDER            ' + char(10)
								SELECT @v_dSql += '  , SCP_LINE_ID,    PROD_VERSION_TYPE, LINE_GROUP_ID ' + char(10)
								SELECT @v_dSql += '  )  VALUES ( ' + char(10)
								SELECT @v_dSql += '    '''+ @v_company_id +''',     '''+ @v_division_id +''',  '''+ @v_site_id +''',         '''+ @v_plant_id +'''             ' + char(10)
								SELECT @v_dSql += '  , '''+ @v_factory_id +''',     '''+ @v_operation_id +''', '''+ @v_line_id +''',         N'''+ @v_line_name +'''           ' + char(10)
								SELECT @v_dSql += '  , '''+ @v_electrode_type +''', '''+ @v_line_type +''',    N'''+ @v_line_type_name +''', N'''+ @v_line_setup_group_id +''' ' + char(10)
								SELECT @v_dSql += '  , '''+ @v_active_flag +''',    N'''+ @v_description +''', N'''+ @v_model_type +''',     N'''+ @v_line_attribute1 +'''     ' + char(10)
								SELECT @v_dSql += '  , ( CASE WHEN ( SELECT MAX(A.SEGMENT5) AS LOCATION FROM SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
								SELECT @v_dSql += '  	WHERE  A.LOOKUP_TYPE_CODE = ''LINE_LOCATION'' AND A.ACTIVE_FLAG = ''Y''                  ' + char(10)
								SELECT @v_dSql += '  	AND    A.SEGMENT2 = '''+ @v_division_id +''' AND A.SEGMENT1 = '''+ @v_site_id +'''       ' + char(10)
								SELECT @v_dSql += '  	AND    A.SEGMENT3 = '''+ @v_plant_id +'''    AND A.SEGMENT4 = '''+ @v_factory_id +'''    ' + char(10)
								SELECT @v_dSql += '  	AND    A.SEGMENT5 = '''+ @v_line_location +''' ) IS NULL THEN ''-'' ELSE N'''+ @v_line_location +''' END ) ' + char(10)
								SELECT @v_dSql += '  , '''+ @v_user_id +''',      GETDATE(),             ''-'',      '+ CONVERT(VARCHAR, @v_seq_no) +'             ' + char(10)
								SELECT @v_dSql += '  , N'''+ @v_scp_line_id +''',    N'''+ @v_prod_version_type + ''', N''' + @v_line_group_id + ''' ' + char(10)
								SELECT @v_dSql += ' )  ' + char(10)
						   END
						--/*******************************************************************************/
						--/* INSERT_EXCEL: ( Excel Import 저장 )                                         */
						--/*******************************************************************************/
						ELSE IF(@v_sys_flag ='INSERT_EXCEL')
                        
							BEGIN 
								SELECT @v_dSql = ''
								SELECT @v_dSql += '	MERGE INTO SCM_LINE_M A                                                                                                                        ' + char(10)
								SELECT @v_dSql += '	USING ( SELECT '''+ @v_company_id +''' AS COMPANY_ID, '''+ @v_division_id +''' AS DIVISION_ID,       '''+ @v_site_id +''' AS SITE_ID           ' + char(10)
								SELECT @v_dSql += '				, '''+ @v_plant_id +''' AS PLANT_ID,      '''+ @v_factory_id +''' AS FACTORY_ID,         '''+ @v_operation_id +''' AS OPERATION_ID ' + char(10)
								SELECT @v_dSql += '				, '''+ @v_line_id +''' AS LINE_ID,        '''+ @v_electrode_type +''' AS ELECTRODE_TYPE                                            ' + char(10)
								SELECT @v_dSql += '		  ) AS B ' + char(10)
								SELECT @v_dSql += '	ON (         ' + char(10)
              					SELECT @v_dSql += '			A.COMPANY_ID = B.COMPANY_ID AND A.DIVISION_ID  = B.DIVISION_ID  AND A.SITE_ID        = B.SITE_ID        ' + char(10)
								SELECT @v_dSql += '		AND A.PLANT_ID   = B.PLANT_ID   AND A.FACTORY_ID   = B.FACTORY_ID                                           ' + char(10)
								SELECT @v_dSql += '		AND A.LINE_ID    = B.LINE_ID    AND A.OPERATION_ID = B.OPERATION_ID AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE	' + char(10)
								SELECT @v_dSql += '	)                 ' + char(10)
								SELECT @v_dSql += '	WHEN MATCHED THEN ' + char(10)
								SELECT @v_dSql += '	  UPDATE SET ACTIVE_FLAG  = '''+ @v_active_flag +''', LINE_SETUP_GROUP_ID = N'''+ @v_line_setup_group_id +'''   ' + char(10)
								SELECT @v_dSql += '        , MODEL_TYPE   = ISNULL('''+ @v_model_type +''',''-'')              ' + char(10)
								SELECT @v_dSql += '        , LINE_ATTR_1  = ISNULL(N'''+ @v_line_attribute1 +''',''-'')        ' + char(10)
								SELECT @v_dSql += '        , LOCATION     = '''+ @v_line_location +'''                         ' + char(10)
								SELECT @v_dSql += '        , UPDATE_ID    = '''+ @v_user_id +''', UPDATE_TIME = SYSDATETIME()  ' + char(10)
								SELECT @v_dSql += '        , SCP_LINE_ID  = N'''+ @v_scp_line_id +'''                          ' + char(10)
								SELECT @v_dSql += '        , LINE_NAME    = (CASE WHEN (SELECT COUNT(*) AS CNT FROM TH_UIS_USER_ROLE_RELATE AS A ' + char(10)
								SELECT @v_dSql += '                                     WHERE A.ROLE_ID = ''RA10101001''                         ' + char(10)
								SELECT @v_dSql += '                                     AND A.USER_ID = '''+ @v_user_id +''' AND A.USE_AT_FLAG = ''Y'') > 0 THEN N'''+ @v_line_name +''' ELSE LINE_NAME END) ' + char(10)
								SELECT @v_dSql += '        , PROD_VERSION_TYPE = '''+ @v_prod_version_type +'''                                  ' + char(10)
								SELECT @v_dSql += '        , LINE_GROUP_ID = N'''+ @v_line_group_id +'''                                  ' + char(10)
								SELECT @v_dSql += '	WHEN NOT MATCHED THEN                                                                        ' + char(10)
								SELECT @v_dSql += '	  INSERT (                                                                                   ' + char(10)
								SELECT @v_dSql += '       COMPANY_ID,         DIVISION_ID,         SITE_ID,         PLANT_ID,         FACTORY_ID ' + char(10)
								SELECT @v_dSql += '     , OPERATION_ID,       LINE_ID,             LINE_NAME,        ELECTRODE_TYPE,  LINE_TYPE	 ' + char(10)
								SELECT @v_dSql += '     , LINE_TYPE_NAME,     LINE_SETUP_GROUP_ID, MODEL_TYPE,       LINE_ATTR_1,     LOCATION	 ' + char(10)
								SELECT @v_dSql += '     , ACTIVE_FLAG,        DESCRIPTION,         INSERT_ID,        INSERT_TIME,     UPDATE_ID	 ' + char(10)
								SELECT @v_dSql += '     , UPDATE_TIME,        SCP_LINE_ID,         PROD_VERSION_TYPE,   LINE_GROUP_ID' + char(10)
								SELECT @v_dSql += '	  )           ' + char(10)
								SELECT @v_dSql += '	  VALUES (    ' + char(10)
								SELECT @v_dSql += '       '''+ @v_company_id +''',     '''+ @v_division_id +''',        '''+ @v_site_id +''',        '''+ @v_plant_id +''' ,      '''+ @v_factory_id +'''	' + char(10)
								SELECT @v_dSql += '     , '''+ @v_operation_id +''',   '''+ @v_line_id +''',            N'''+ @v_line_name +''',      '''+ @v_electrode_type +''', '''+ @v_line_type +'''	' + char(10)
								SELECT @v_dSql += '     , N'''+ @v_line_type_name +''', '''+ @v_line_setup_group_id +''', ISNULL('''+ @v_model_type +''',''-''), ISNULL(N'''+ @v_line_attribute1 +''',''-''), N'''+ @v_line_location +'''   ' + char(10)
								SELECT @v_dSql += '     , '''+ @v_active_flag +''',    N'''+ @v_description +''',        '''+ @v_user_id +''',        SYSDATETIME(),     '''+ @v_user_id +'''				' + char(10)
								SELECT @v_dSql += '     , SYSDATETIME(),   N'''+ @v_scp_line_id +''',   N'''+ @v_prod_version_type + ''',   N''' + @v_line_group_id + ''' ' + char(10)
								SELECT @v_dSql += '	  )	;   ' + char(10)
								SELECT @v_dSql += '			' + char(10)
								SELECT @v_dSql += '	INSERT INTO HIS_LINE_M                                                                   ' + char(10)
								SELECT @v_dSql += '     (  COMPANY_ID,            DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID  ' + char(10)
								SELECT @v_dSql += '      , OPERATION_ID,          LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE   ' + char(10)
								SELECT @v_dSql += '      , LINE_SETUP_GROUP_ID,   LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE  ' + char(10)
								SELECT @v_dSql += '      , LINE_ATTR_1,           LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID   ' + char(10)
								SELECT @v_dSql += '      , UPDATE_TIME,           JOB_USER_ID,    JOB_TIME,      JOB_TYPE,       SCP_LINE_ID ' + char(10)
								SELECT @v_dSql += '      , PROD_VERSION_TYPE,     LINE_GROUP_ID   )                                          ' + char(10)
								SELECT @v_dSql += '	SELECT COMPANY_ID,            DIVISION_ID,    SITE_ID,       PLANT_ID,       FACTORY_ID	 ' + char(10)
								SELECT @v_dSql += '      , OPERATION_ID,        LINE_ID,        LINE_NAME,     ELECTRODE_TYPE, LINE_TYPE     ' + char(10)
								SELECT @v_dSql += '      , LINE_SETUP_GROUP_ID, LINE_TYPE_NAME, ACTIVE_FLAG,   DESCRIPTION,    MODEL_TYPE    ' + char(10)
								SELECT @v_dSql += '      , LINE_ATTR_1,         LOCATION,       INSERT_ID,     INSERT_TIME,    UPDATE_ID     ' + char(10)
								SELECT @v_dSql += '      , UPDATE_TIME,         '''+ @v_user_id +''',     SYSDATETIME(), ''EXCEL'',  N'''+ @v_scp_line_id +''',  PROD_VERSION_TYPE , N'''  + @v_line_group_id + ''' AS LINE_GROUP_ID ' + char(10)
								SELECT @v_dSql += '	FROM  SCM_LINE_M A WITH(NOLOCK)                           ' + char(10)
								SELECT @v_dSql += '	WHERE  COMPANY_ID           = '''+ @v_company_id +'''     ' + char(10)
								SELECT @v_dSql += '	AND    DIVISION_ID          = '''+ @v_division_id +'''    ' + char(10)
								SELECT @v_dSql += '	AND    SITE_ID              = '''+ @v_site_id +'''        ' + char(10)
								SELECT @v_dSql += '	AND    PLANT_ID             = '''+ @v_plant_id +'''       ' + char(10)
								SELECT @v_dSql += '	AND    FACTORY_ID           = '''+ @v_factory_id +'''     ' + char(10)
								SELECT @v_dSql += '	AND    OPERATION_ID         = '''+ @v_operation_id +'''   ' + char(10)
								SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_line_id +'''        ' + char(10)
								SELECT @v_dSql += '	AND    ELECTRODE_TYPE       = '''+ @v_electrode_type +''' ' + char(10)

							END --'G'

						--/*******************************************************************************/
						--/* SUB_UPDATE                                                                  */
						--/*******************************************************************************/
						ELSE IF(@v_sys_flag ='M_W')
                        
							BEGIN 
						  		SELECT @v_dSql = ''
								SELECT @v_dSql += '		BEGIN ' + char(10);
								SELECT @v_dSql += '			update  SCM_ITEM_LINE_ASSIGN_M set ' + char(10);

								SELECT @v_dSql += '	 	OLD_WIP_LEVEL_QTY = WIP_LEVEL_QTY   ' + char(10);

								SELECT @v_dSql += '		where 1=1 ' +  char(10);
								SELECT @v_dSql += '		AND  DIVISION_ID =''' + @v_division_id +'''' +char(10);
								SELECT @v_dSql += '		AND  SITE_ID =''' +  @v_site_id +''''+char(10);
								SELECT @v_dSql += '		AND  PLANT_ID =''' +  @v_plant_id +''''+char(10);
								SELECT @v_dSql += '		AND  FACTORY_ID	=''' +  @v_factory_id +''''+char(10);
								SELECT @v_dSql += '		AND  ITEM_ID =''' + @v_line_attribute1 +''''+ char(10);
								SELECT @v_dSql += '		AND  OPERATION_ID = '''+ @v_operation_id +'''   ' + char(10)
								SELECT @v_dSql += '		AND  LINE_ID  =''' +  @v_line_id +''''+char(10);
								SELECT @v_dSql += '		AND  MONTH >= ' +  @v_description + char(10);


								SELECT @v_dSql += '		END ' + char(10);


								

							
								SELECT @v_dSql += '		BEGIN ' + char(10);
							
								SELECT @v_dSql += '		update  SCM_ITEM_LINE_ASSIGN_M set ' + char(10);
								--SELECT @v_dSql += '		WIP_LEVEL_QTY = ' + @v_equipment_count + char(10);
								SELECT @v_dSql += '		WIP_LEVEL_QTY = (CASE WHEN ''' + @v_equipment_count + ''' = '''' OR ''' + @v_equipment_count + ''' IS NULL THEN 0 ELSE ''' + @v_equipment_count + ''' END) ' + char(10); -- '' or null 처리... 20240312
								SELECT @v_dSql += '		, UPDATE_ID = ''' + @v_user_id + '''' + char(10);
								SELECT @v_dSql += '		, UPDATE_TIME = dbo.SYSDATE1()'  + char(10);
								SELECT @v_dSql += '		where 1=1 ' +  char(10);
								--SELECT @v_dSql += '		AND  COMPANY_ID =' + @p_company_id + char(10);
								SELECT @v_dSql += '		AND  DIVISION_ID =''' + @v_division_id +'''' +char(10);
								SELECT @v_dSql += '		AND  SITE_ID =''' +  @v_site_id +''''+char(10);
								SELECT @v_dSql += '		AND  PLANT_ID =''' +  @v_plant_id +''''+char(10);
								SELECT @v_dSql += '		AND  FACTORY_ID	=''' +  @v_factory_id +''''+char(10);
								SELECT @v_dSql += '		AND  ITEM_ID =''' + @v_line_attribute1 +''''+ char(10);
								SELECT @v_dSql += '		AND  OPERATION_ID = '''+ @v_operation_id +'''   ' + char(10)
								SELECT @v_dSql += '		AND  LINE_ID  =''' +  @v_line_id +''''+char(10);
								SELECT @v_dSql += '		AND  MONTH >= ' +  @v_description +char(10);
								SELECT @v_dSql += '		END ' + char(10);
						


							END --'SUB_UPDATE'

						--ELSE IF(@v_sys_flag ='I_W')
                        
						--	BEGIN 
						--  		SELECT @v_dSql = ''
						--		SELECT @v_dSql += '	BEGIN ' + char(10);

						--		--SELECT @v_dSql += ' INSERT INTO SCM_ITEM_LINE_ASSIGN_M ' + char(10);
						--		--SELECT @v_dSql += '		(COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID, ' + char(10);
						--		--SELECT @v_dSql += '		OPERATION_ID,LINE_ID,ITEM_ID,LANE_QTY, ' + char(10);
						--		--SELECT @v_dSql += '		MONTH,WORK_CENTER_ID,PRIORITY, ' + char(10);
						--		--SELECT @v_dSql += '		INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME, ELECTRODE_TYPE)  ' + char(10);

						--		--SELECT @v_dSql += ' VALUES (' + char(10);
							
						--		--SELECT @v_dSql += '		  ''' + @v_company_id +''',' +char(10);
						--		--SELECT @v_dSql += '		  ''' + @v_division_id +''',' +char(10);
						--		--SELECT @v_dSql += '		  ''' +  @v_site_id +''','+char(10);
						--		--SELECT @v_dSql += '		  ''' +  @v_plant_id +''','+char(10);
						--		--SELECT @v_dSql += '		  ''' +  @v_factory_id +''','+char(10);	

						--		--SELECT @v_dSql += '		  ''' +  @v_operation_id +''','+char(10);						
						--		--SELECT @v_dSql += '		  ''' +  @v_line_id +''','+char(10);						
						--		--SELECT @v_dSql += '		  ''' +  @v_line_attribute1 +''','+char(10);						
						--		--SELECT @v_dSql += '		CONVERT(numeric,''' +   @v_equipment_count +'''),'+char(10);						
						--		--SELECT @v_dSql += '		  ''' +  @v_description +''','+char(10);		
							
						--		--SELECT @v_dSql += '		null, null,'+char(10);		
							
						--		--SELECT @v_dSql += '		''' +  @v_user_id +''','+char(10);						
						--		--SELECT @v_dSql += '		dbo.SYSDATE1(), '+char(10);						
						--		--SELECT @v_dSql += '		''' +  @v_user_id +''','+char(10);						
						--		--SELECT @v_dSql += '		dbo.SYSDATE1(), '+char(10);		

						--		--SELECT @v_dSql += '		CASE WHEN ' + '''' + @v_electrode_type + '''' + ' = '''' THEN ''-'' ELSE ' + '''' + @v_electrode_type + '''' + ' END )'+char(10);						
						  

						--		SELECT @v_dSql += '	MERGE INTO SCM_ITEM_LINE_ASSIGN_M A                                                                                                                        ' + char(10)
						--		SELECT @v_dSql += '	USING ( SELECT '''+ @v_company_id +''' AS COMPANY_ID, '''+ @v_division_id +''' AS DIVISION_ID,       '''+ @v_site_id +''' AS SITE_ID           ' + char(10)
						--		SELECT @v_dSql += '				, '''+ @v_plant_id +''' AS PLANT_ID,      '''+ @v_factory_id +''' AS FACTORY_ID,         '''+ @v_line_attribute1 +''' AS ITEM_ID ' + char(10)
						--		SELECT @v_dSql += '				, '''+ @v_operation_id +''' AS OPERATION_ID, '''+ @v_line_id +''' AS LINE_ID                                                 ' + char(10)
						--		SELECT @v_dSql += '		  ) AS B ' + char(10)
						--		SELECT @v_dSql += '	ON (         ' + char(10)
      --        					SELECT @v_dSql += '			A.COMPANY_ID = B.COMPANY_ID AND A.DIVISION_ID  = B.DIVISION_ID  AND A.SITE_ID = B.SITE_ID        ' + char(10)
						--		SELECT @v_dSql += '		AND A.PLANT_ID   = B.PLANT_ID   AND A.FACTORY_ID   = B.FACTORY_ID                                           ' + char(10)
						--		SELECT @v_dSql += '		AND A.LINE_ID    = B.LINE_ID    AND A.OPERATION_ID = B.OPERATION_ID AND A.ITEM_ID = B.ITEM_ID	' + char(10)
						--		SELECT @v_dSql += '	)                 ' + char(10)
						--		--SELECT @v_dSql += '	WHEN MATCHED THEN ' + char(10)
						--  -- 		SELECT @v_dSql += '		update  set ' + char(10);
						--		--SELECT @v_dSql += '		COMPANY_ID =   ''' + @v_company_id +''',' +char(10);
						--		--SELECT @v_dSql += '		DIVISION_ID =   ''' + @v_division_id +''',' +char(10);
						--		--SELECT @v_dSql += '		SITE_ID =   ''' +  @v_site_id +''','+char(10);
						--		--SELECT @v_dSql += '		PLANT_ID =  ''' +  @v_plant_id +''','+char(10);
						--		--SELECT @v_dSql += '		FACTORY_ID =   ''' +  @v_factory_id +''','+char(10);	

						--		--SELECT @v_dSql += '		OPERATION_ID =  ''' +  @v_operation_id +''','+char(10);						
						--		--SELECT @v_dSql += '		LINE_ID =  ''' +  @v_line_id +''','+char(10);						
						--		--SELECT @v_dSql += '		ITEM_ID =   ''' +  @v_line_attribute1 +''','+char(10);						
						--		--SELECT @v_dSql += '		LANE_QTY = CONVERT(numeric,''' +   @v_equipment_count +'''),'+char(10);						
						--		--SELECT @v_dSql += '		 MONTH  = ''' +  @v_description +''','+char(10);		
							
						--		--SELECT @v_dSql += '		WORK_CENTER_ID = null, PRIORITY = null,'+char(10);		
							
						--		--SELECT @v_dSql += '		INSERT_ID = ''' +  @v_user_id +''','+char(10);						
						--		--SELECT @v_dSql += '		INSERT_TIME = dbo.SYSDATE1(), '+char(10);						
						--		--SELECT @v_dSql += '		UPDATE_ID = ''' +  @v_user_id +''','+char(10);						
						--		--SELECT @v_dSql += '		UPDATE_TIME = dbo.SYSDATE1(), '+char(10);		

						--		--SELECT @v_dSql += '		ELECTRODE_TYPE = CASE WHEN ' + '''' + @v_electrode_type + '''' + ' = '''' THEN ''-'' ELSE ' + '''' + @v_electrode_type + '''' + ' END '+char(10);						
						  
						--		SELECT @v_dSql += '	WHEN NOT MATCHED THEN                                                                        ' + char(10)
						--   		SELECT @v_dSql += ' INSERT  ' + char(10);
						--		SELECT @v_dSql += '		(COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID, ' + char(10);
						--		SELECT @v_dSql += '		OPERATION_ID,LINE_ID,ITEM_ID, ' + char(10);
						--		SELECT @v_dSql += '		MONTH,WORK_CENTER_ID,PRIORITY, ' + char(10);
						--		SELECT @v_dSql += '		INSERT_ID,INSERT_TIME,UPDATE_ID,UPDATE_TIME, ELECTRODE_TYPE, WIP_LEVEL_QTY, LANE_QTY )  ' + char(10);

						--		SELECT @v_dSql += ' VALUES (' + char(10);
							
						--		SELECT @v_dSql += '		  ''' + @v_company_id +''',' +char(10);
						--		SELECT @v_dSql += '		  ''' + @v_division_id +''',' +char(10);
						--		SELECT @v_dSql += '		  ''' +  @v_site_id +''','+char(10);
						--		SELECT @v_dSql += '		  ''' +  @v_plant_id +''','+char(10);
						--		SELECT @v_dSql += '		  ''' +  @v_factory_id +''','+char(10);	

						--		SELECT @v_dSql += '		  ''' +  @v_operation_id +''','+char(10);						
						--		SELECT @v_dSql += '		  ''' +  @v_line_id +''','+char(10);						
						--		SELECT @v_dSql += '		  ''' +  @v_line_attribute1 +''','+char(10);		
						--		SELECT @v_dSql += '		  ''' +  @v_description +''','+char(10);		
							
						--		SELECT @v_dSql += '		null, ''0'','+char(10);		
							
						--		SELECT @v_dSql += '		''' +  @v_user_id +''','+char(10);						
						--		SELECT @v_dSql += '		dbo.SYSDATE1(), '+char(10);						
						--		SELECT @v_dSql += '		''' +  @v_user_id +''','+char(10);						
						--		SELECT @v_dSql += '		dbo.SYSDATE1(), '+char(10);		

						--		SELECT @v_dSql += '		CASE WHEN ' + '''' + @v_electrode_type + '''' + ' = '''' THEN ''-'' ELSE ' + '''' + @v_electrode_type + '''' + ' END '+char(10);						
						--		SELECT @v_dSql += '		, ''' + @p_equipment_count + '''' +char(10);						
						--		SELECT @v_dSql += '		, ''' + @p_line_location + ''');' +char(10);						
						  
		   



						--		SELECT @v_dSql += '		END ' + char(10);



						


						--	END --'SUB_INSERT'

						-- ELSE IF(@v_sys_flag ='D_W')
                        
						--	BEGIN 
						--  		SELECT @v_dSql = ''
						--			SELECT @v_dSql += '	DELETE FROM SCM_ITEM_LINE_ASSIGN_M												' + char(10)
						--			SELECT @v_dSql += '	WHERE  COMPANY_ID           = '''+ @v_company_id +'''				' + char(10)
						--			SELECT @v_dSql += '	AND    DIVISION_ID          = '''+ @v_division_id +'''				' + char(10)
						--			SELECT @v_dSql += '	AND    SITE_ID              = '''+ @v_site_id +'''					' + char(10)
						--			SELECT @v_dSql += '	AND    PLANT_ID             = '''+ @v_plant_id +'''					' + char(10)
						--			SELECT @v_dSql += '	AND    FACTORY_ID           = '''+ @v_factory_id +'''				' + char(10)
						--			SELECT @v_dSql += '	AND    ITEM_ID              =''' + @v_line_attribute1 +'''          '+ char(10);
						--			SELECT @v_dSql += '	AND    OPERATION_ID         = '''+ @v_operation_id +'''				' + char(10)
						--			SELECT @v_dSql += '	AND    LINE_ID              = '''+ @v_line_id +'''					' + char(10)
						--			SELECT @v_dSql += '	AND    ISNULL(ELECTRODE_TYPE,'''') = '''+  @v_electrode_type +'''	' + char(10)
						--			SELECT @v_dSql += '	AND    MONTH              = '''+ @v_description +'''					' + char(10)
						--			SELECT @v_dSql += '	AND    LANE_QTY              = '''+ @v_line_location +'''					' + char(10)

						--	END --'SUB_INSERT'

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
								EXEC PR_UI_SQL_LOG  @v_proc_name,  @v_user_id,'','', @v_dSql,'SELECT',@runstart, @runend
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

