

/*
 * Program ID   : SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL
 * Description  : Shipment Plan Waterfall 조회
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 * 2018/04/24   byunghunjung	          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/21   byunghunjung	          sold to , ship to, project name 컬럼 제거
 * 2018/05/22	byunghunjung	          order by 순서 변경
 * 2018/05/31	KYH				          1년조회시 년도가 다른 같은 월 조회시 sum이 표시되는 문제 ex) 2018.0528 ~ 2019.0527 조회시 2019.5월 (마지막 주)에 2018.5월 sum값 표시
 * 2018/06/21   HWY				          조회 컬럼 추가
 * 2018/06/25   HWY				          성능개선
 * 2018/07/02	KYH				          신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
 * 2021/05/24   khj79                     [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선- 부서정보 없는 경우 조회 안되는 오류 수정
 * 2021/07/07   khj79			          PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
 * 2021/12/06   khj79			          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 속도 개선 튜닝
 * 2022.05.13   LSC                       PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2022.07.17   chaan                     PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : Bucket->ISO_WEEK 추가
 * 2023/04/10   LWY				          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2023.06.23   KJJ				          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Like 검색기능
 * 2024-01-08   chaan                     PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
 ==================================================================================================================================================================
 ex) EXEC SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL @p_from_yyyymmdd='20180604', @p_to_yyyymmdd='20181003', @p_division_id='81', @p_biz_type='E', @p_project_code='', @p_item_id='', @p_version_no='SP_W_20180604', @p_program_id='SCP0016', @p_sheet_name='Shipment Plan FG', @p_user_id='kaiser99'

 */
CREATE PROCEDURE [dbo].[SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL]
--CREATE PROCEDURE [dbo].[SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL]
	@p_from_yyyymmdd		NVARCHAR(MAX),
	@p_to_yyyymmdd			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_biz_type				NVARCHAR(MAX),
	@p_project_code			NVARCHAR(MAX),
	@p_item_id				NVARCHAR(MAX),
	@p_version_no			NVARCHAR(MAX),
	@p_electype				NVARCHAR(MAX),
	@p_program_id			NVARCHAR(MAX) = 'SCP0016' ,
	@p_sheet_name			NVARCHAR(MAX) = 'Shipment Plan FG' ,
	@p_user_id				NVARCHAR(MAX),
	@debug_mode				NVARCHAR(20)  ='F'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	--DECLARE @p_from_yyyymmdd		NVARCHAR(MAX)   = N'20220704'
	--DECLARE @p_to_yyyymmdd			NVARCHAR(MAX)   = N'20230702'
	--DECLARE @p_division_id			NVARCHAR(MAX)   = N'82'
	--DECLARE @p_biz_type				NVARCHAR(MAX)   = N'P'
	--DECLARE @p_project_code			NVARCHAR(MAX)   = N''
	--DECLARE @p_item_id				NVARCHAR(MAX)   = N''
	--DECLARE @p_version_no			NVARCHAR(MAX)   = N'SP_W_20220704'
	--DECLARE @p_electype				NVARCHAR(MAX)   = N''
	--DECLARE @p_program_id			NVARCHAR(MAX)   = N'SCP0016'
	--DECLARE @p_sheet_name			NVARCHAR(MAX)   = N'Shipment Plan FG'
	--DECLARE @p_user_id				NVARCHAR(MAX)   = N'iamarock'
	--DECLARE @debug_mode				NVARCHAR(20)    = N'F'



	DECLARE @v_data_cnt			    NVARCHAR(8)     = 0;
	DECLARE @v_cnt_usr_measure	    NVARCHAR(MAX)   = '0';

	SET @v_cnt_usr_measure = (
								SELECT	COUNT(*)
								FROM	SCM_MST_TITLESET_USER
								WHERE	1=1
									AND PROGRAM_ID  =  @p_program_id
									AND SHEET_NAME  =  @p_sheet_name
									AND USER_ID     =  @p_user_id
							  )

	DECLARE @mDQry				NVARCHAR(MAX) = '';

	DECLARE @v_version_no		NVARCHAR(MAX) = '';
	DECLARE @v_project_code		NVARCHAR(MAX) = '';
	DECLARE @v_item_id			NVARCHAR(MAX) = '';
	DECLARE @v_electype			NVARCHAR(MAX) = '';

	--IN 조건으로 데이터를 가져옴
	SET @v_version_no		= [dbo].FN_GET_IN_STR(@p_version_no);
	SET @v_project_code		= [dbo].FN_GET_IN_STR(@p_project_code);
	--SET @v_item_id			= [dbo].FN_GET_IN_STR(@p_item_id);
	SET @v_electype			= [dbo].FN_GET_IN_STR(@p_electype);

	/********************************************************************************
	* 1. SCP_ANL_SHIPMENT_PLAN_FG_C 테이블에서 필요한데이터만 먼저 추출
	********************************************************************************/
	  IF OBJECT_ID('tempdb..#TMP_SCP0016_DATA1') IS NOT NULL
		   DROP TABLE #TMP_SCP0016_DATA1

	CREATE TABLE #TMP_SCP0016_DATA1
	(
		 VERSION_NO					NVARCHAR(50)
		,DIVISION_ID				NVARCHAR(30)
		,BIZ_TYPE					NVARCHAR(30)
		,PROJECT_CODE				NVARCHAR(50)
		,ITEM_ID					NVARCHAR(50)
		,ELECTRODE_TYPE				NVARCHAR(50)
		,ORIGIN_TO_DIVISION_ID		NVARCHAR(50)
		,TO_SITE					NVARCHAR(30)
		,INCOTERMS					NVARCHAR(10)
		,ORIGIN_FROM_DIVISION_ID	NVARCHAR(50)
		,FROM_SITE					NVARCHAR(30)
		,MEASURE					NVARCHAR(50)
		,BOD_ID						NVARCHAR(150)
		,QTY						NUMERIC(20,10)
		,PLAN_START_YYYYMMDD		NVARCHAR(8)
		,PLAN_TYPE					NVARCHAR(50)
		,SEQ						NVARCHAR(200)
		,BIZ_TYPE_NAME				NVARCHAR(30)
		,NICK_NAME					NVARCHAR(150)
		,TO_SITE_NAME				NVARCHAR(150)
		,FROM_SITE_NAME				NVARCHAR(150)
		,YYYYMMDD					NVARCHAR(10)
	);

	SET @mDQry = N'
					INSERT INTO #TMP_SCP0016_DATA1
						SELECT	  A.VERSION_NO
								, A.DIVISION_ID
								, A.BIZ_TYPE
								, A.PROJECT_CODE
								, A.ITEM_ID
								, A.ELECTRODE_TYPE
								, A.ORIGIN_TO_DIVISION_ID
								, A.TO_SITE
								, A.INCOTERMS
								, A.ORIGIN_FROM_DIVISION_ID
								, A.FROM_SITE
								, A.MEASURE
								, A.BOD_ID
								, A.QTY
								, A.PLAN_START_YYYYMMDD
								, A.PLAN_TYPE
								, A.SEQ
								, A.BIZ_TYPE_NAME
								, A.NICK_NAME
								, A.TO_SITE_NAME
								, A.FROM_SITE_NAME
								, A.YYYYMMDD
						FROM	SCP_ANL_SHIPMENT_PLAN_FG_C A
						WHERE	1=1
							AND A.YYYYMMDD    >= ''' + @p_from_yyyymmdd + '''
							AND A.YYYYMMDD    <= ''' + @p_to_yyyymmdd + '''
							AND A.DIVISION_ID =  ''' + @p_division_id + '''
							AND A.BIZ_TYPE    =  ''' + @p_biz_type + ''''

	IF (@p_version_no IS NOT NULL AND @p_version_no !='')
		SET @mDQry = @mDQry + N'
							AND A.VERSION_NO IN (' + @v_version_no + ')';

	IF (@p_project_code IS NOT NULL AND @p_project_code !='')
		SET @mDQry = @mDQry + N'
							AND A.PROJECT_CODE IN (' + @v_project_code + ')';

	IF (@p_item_id IS NOT NULL AND @p_item_id !='')
		SET @mDQry = @mDQry + N'
							AND  A.ITEM_ID IN (SELECT * FROM DBO.FN_GET_ITEM_LIKE_CONDITION(''' + @p_item_id + ''', ''''))';

	IF (@p_electype IS NOT NULL AND @p_electype != '')
		SET @mDQry = @mDQry + N'
							AND A.ELECTRODE_TYPE IN (' + @v_electype + ')';

    --exec debug_log @mQry, 'T';return;
	EXEC (@mDQry);

	/********************************************************************************
	* 2. 뷰에서 필요한 정보만 추출해서 임시 테이블로
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TMP_SCP0016_BOD_N_V') IS NOT NULL
		DROP TABLE #TMP_SCP0016_BOD_N_V

	SELECT	  DIVISION_ID
			, BOD_ID
			, FROM_SITE
			, TRANSPORT_MODE
			, LT_TOTAL
	INTO	#TMP_SCP0016_BOD_N_V
	FROM	SCP_MST_BOD_N_V



	/********************************************************************************
	* 3. 임시테이블만들기
	********************************************************************************/
	  IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0016') IS NOT NULL
		   DROP TABLE #TblDynamicPivot_SCP0016

	CREATE TABLE #TblDynamicPivot_SCP0016
	(
		 KEY_IDX					NVARCHAR(200)
		,VERSION_NO					NVARCHAR(50)
		,DIVISION_ID				NVARCHAR(30)
		,BIZ_TYPE					NVARCHAR(30)
		,PROJECT_CODE				NVARCHAR(50)
		,ITEM_ID					NVARCHAR(50)
		,ELECTRODE_TYPE				NVARCHAR(50)
		,ORIGIN_TO_DIVISION_ID		NVARCHAR(50)
		,TO_SITE					NVARCHAR(30)
		,INCOTERMS					NVARCHAR(10)
		,ORIGIN_FROM_DIVISION_ID	NVARCHAR(50)
		,FROM_SITE					NVARCHAR(30)
		,TRANSPORT_MODE				NVARCHAR(50)
		,LT_DAY						NVARCHAR(300)
		,MEASURE					NVARCHAR(50)
		,MEASURE_LABEL				NVARCHAR(150)
		,MEASURE_ORDER_NO			INT
		,BOD_ID						NVARCHAR(150)
		,QTY						NUMERIC(20,10)
		,PLAN_START_YYYYMMDD		NVARCHAR(8)
		,PLAN_TYPE					NVARCHAR(50)
		,SEQ						NVARCHAR(200)
		,BIZ_TYPE_NAME				NVARCHAR(30)
		,NICK_NAME					NVARCHAR(150)
		,TO_SITE_NAME				NVARCHAR(150)
		,FROM_SITE_NAME				NVARCHAR(150)
		,FROM_YYYYMMDD				NVARCHAR(8)
		,TO_YYYYMMDD				NVARCHAR(8)
		,YYYYMMDD					NVARCHAR(10)
		,YYYYMM						NVARCHAR(6)
		,ISO_WEEK					NVARCHAR(6)
	);

	SET @mDQry = N'
					INSERT INTO #TblDynamicPivot_SCP0016
						SELECT DISTINCT
								  (A.DIVISION_ID + A.BIZ_TYPE + A.PROJECT_CODE  + A.ITEM_ID + A.TO_SITE + A.INCOTERMS) AS KEY_IDX
								, A.VERSION_NO
								, A.DIVISION_ID
								, A.BIZ_TYPE
								, A.PROJECT_CODE
								, A.ITEM_ID
								, ISNULL(NULLIF(A.ELECTRODE_TYPE , ''''), ''-'') AS ELECTRODE_TYPE
								, ISNULL(NULLIF(A.ORIGIN_TO_DIVISION_ID , '''') , ''-'') AS ORIGIN_TO_DIVISION_ID
								, A.TO_SITE
								, A.INCOTERMS
								, ISNULL(NULLIF(A.ORIGIN_FROM_DIVISION_ID , '''') , ''-'') AS ORIGIN_FROM_DIVISION_ID
								, A.FROM_SITE
								, C.TRANSPORT_MODE
								, C.LT_TOTAL AS LT_DAY
								, A.MEASURE
								, B.COLUMN_LABEL_NAME  AS MEASURE_LABEL
								, ISNULL(D.SORT_ORDER_NO, B.SORT_ORDER_NO ) AS MEASURE_ORDER_NO
								, A.BOD_ID
								, A.QTY
								, A.PLAN_START_YYYYMMDD
								, A.PLAN_TYPE
								, A.SEQ
								, A.BIZ_TYPE_NAME
								, A.NICK_NAME
								, A.TO_SITE_NAME
								, A.FROM_SITE_NAME
								, ''' + @P_FROM_YYYYMMDD + ''' AS FROM_YYYYMMDD
								, ''' + @P_TO_YYYYMMDD + ''' AS TO_YYYYMMDD
								, ''D_'' + A.YYYYMMDD AS YYYYMMDD
								, O.BASIS_YYYYMM AS YYYYMM
								, RIGHT(O.BASIS_YYYYMM, 4)+O.ISO_WEEK AS ISO_WEEK
						FROM	#TMP_SCP0016_DATA1 A
								INNER HASH JOIN SCM_SYS_CALENDAR_M O ON
										A.YYYYMMDD = O.BASIS_YYYYMMDD
								INNER HASH JOIN SCM_MST_SHEET_MEASURE B ON
									A.MEASURE = B.COLUMN_NAME'

	-- BOD 2단계 개발 : 시작
	--IF @p_division_id != 'EE'
	--	SET @mDQry = @mDQry + '	LEFT JOIN scp_mst_bod_v c ON a.division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site                                                         ' + char(10) ;
	--ELSE
	--	SET @mDQry = @mDQry + '	LEFT JOIN scp_mst_bod_v c ON a.origin_from_division_id = c.division_id AND  a.bod_id = c.bod_id AND a.from_site = c.from_site                                                         ' + char(10) ;

	--IF @p_division_id NOT IN ('EE','EE_UC')
	IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
		SET @mDQry = @mDQry + N'
								LEFT JOIN #TMP_SCP0016_BOD_N_V c ON
										A.DIVISION_ID = C.DIVISION_ID
									AND A.BOD_ID = C.BOD_ID
									AND A.FROM_SITE = C.FROM_SITE'
	ELSE
		SET @mDQry = @mDQry + N'
								LEFT JOIN #TMP_SCP0016_BOD_N_V C ON
										A.ORIGIN_FROM_DIVISION_ID = C.DIVISION_ID
									AND A.BOD_ID = C.BOD_ID
									AND A.FROM_SITE = C.FROM_SITE'
	-- BOD 2단계 개발 : 끝

	SET @mDQry = @mDQry + N'
								LEFT OUTER JOIN SCM_MST_TITLESET_USER d ON
										D.PROGRAM_ID  = B.PROGRAM_ID
									AND D.SHEET_NAME  = B.SHEET_NAME
									AND D.COLUMN_NAME = B.COLUMN_NAME
									AND D.USER_ID = ''' + @p_user_id + '''
						WHERE	1=1
							AND B.PROGRAM_ID = '''+@p_program_id+'''
							AND B.SHEET_NAME = '''+@p_sheet_name+'''
							AND B.VALID_YN = ''Y''
							AND ('''+@v_cnt_usr_measure+''' = ''0'' OR
									EXISTS (
												SELECT	1
												FROM	SCM_MST_TITLESET_USER
												WHERE	PROGRAM_ID  = '''+@p_program_id+'''
													AND SHEET_NAME  = '''+@p_sheet_name+'''
													AND USER_ID     = '''+@p_user_id+'''
													AND COLUMN_NAME = B.COLUMN_NAME
											)
								)
						'
--2023.12.14 천승호
					+ '   OPTION (MAXDOP 1) ; '


	--exec debug_log @mDQry, 'T';return;
	EXEC (@mDQry);



	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/
	BEGIN
		--DECLARE @mQuery NVARCHAR(MAX);
		DECLARE @mQry_sum		NVARCHAR(MAX);
		DECLARE @mEXEC			NVARCHAR(MAX);
		DECLARE @mDAY_QTY		NVARCHAR(MAX);

		-- PIVOIT 대상 날짜문자열 생성
		SET @mQry_sum = '';

			SELECT  @mQry_sum = @mQry_sum + N'
									, ' +
                            CASE
                                WHEN CHARINDEX('M_', YYYYMMDD) = 1 THEN  'SUM(CASE WHEN YYYYMM   = RIGHT(''' + YYYYMMDD + ''', 6) THEN QTY END ) AS ' + YYYYMMDD
							    WHEN CHARINDEX('W_', YYYYMMDD) = 1 THEN
                                    CASE
                                        WHEN RIGHT(YYYYMMDD, 4) <> '_ISO' THEN
                                            'SUM(CASE WHEN ISO_WEEK = RIGHT(''' + YYYYMMDD + ''', 6) THEN  QTY  END ) AS ' + YYYYMMDD
                                        ELSE
                                            'SUM(CASE WHEN ISO_WEEK = SUBSTRING(YYYYMMDD, 3, 6) THEN  QTY  END ) AS ' + YYYYMMDD
                                    END
								WHEN CHARINDEX('D_', YYYYMMDD) =1 THEN  'SUM(CASE WHEN YYYYMMDD = ''' + YYYYMMDD + ''' THEN QTY  END ) AS ' + YYYYMMDD
							END
		FROM
                (
                    SELECT    'M_'+A.BASIS_YYYYMM                               AS YYYYMMDD
                            , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01')  AS SORT_ORDER_NO
                    FROM    [DBO].[SCM_SYS_CALENDAR_M] A
                    WHERE   A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
                    GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                    UNION ALL
                    SELECT    'W_'+A.BASIS_YYYYMM + A.ISO_WEEK                  AS YYYYMMDD
                            , A.BASIS_START_DATE + CONVERT(CHAR(2), 21)         AS SORT_ORDER_NO
                    FROM    [DBO].[SCM_SYS_CALENDAR_M] A
                    WHERE   A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
                    GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                    UNION ALL
                    SELECT    'W_' + A.ISO_YYYYMM + A.ISO_WEEK + '_ISO'         AS YYYYMMDD
                            , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), 21)    AS SORT_ORDER_NO
                    FROM    [DBO].[SCM_SYS_CALENDAR_M] A
                    WHERE   A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
                    GROUP BY A.ISO_YYYYMM, A.ISO_WEEK
                    UNION ALL
                    SELECT    'D_'+A.BASIS_YYYYMMDD                             AS YYYYMMDD
                            , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31)           AS SORT_ORDER_NO
                    FROM    [DBO].[SCM_SYS_CALENDAR_M] A
                    WHERE   A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
                    GROUP BY A.BASIS_YYYYMMDD
                ) AS A
        ORDER BY SORT_ORDER_NO
--2023.12.30 천승호
		OPTION (MAXDOP 1) ;

--print '@mQry_sum :' + @mQry_sum;return;

		SET @mEXEC = N'
				SELECT	A.*
						, ISNULL(b.PROJECT_NAME, ''-'') PROJECT_NAME
						, ISNULL(b.PROJECT_OWNER, ''-'') PROJECT_OWNER
						, ISNULL(dbo.FN_GET_LOOKUP_CODE_DESC(''ITEM_TYPE_CODE'', c.ITEM_TYPE) ,''-'') ITEM_TYPE
						, ISNULL(e.DEPT_NAME_KO, ''-'') DEPT_NAME_KO
				FROM	(
							SELECT	  KEY_IDX
									, DIVISION_ID
									, BIZ_TYPE
									, BIZ_TYPE_NAME
									, PROJECT_CODE
									, ITEM_ID
									, CASE
										WHEN NICK_NAME IS NULL OR NICK_NAME ='''' THEN ''-''
										ELSE NICK_NAME
									  END AS NICK_NAME
									, ELECTRODE_TYPE
									, ORIGIN_TO_DIVISION_ID
									, TO_SITE
									, TO_SITE_NAME
									, INCOTERMS
									, ORIGIN_FROM_DIVISION_ID
									, FROM_SITE
									, ISNULL(FROM_SITE_NAME ,''-'') AS FROM_SITE_NAME
									, BOD_ID
									, ISNULL(TRANSPORT_MODE , ''-'') AS TRANSPORT_MODE
									, ISNULL(LT_DAY , 0) AS LT_DAY
									, PLAN_START_YYYYMMDD
									, PLAN_TYPE
									, SEQ
									, CAST(ROUND([dbo].[FN_GET_SCP_ANL_BOH_QTY](DIVISION_ID ,PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, TO_SITE , ITEM_ID,FROM_YYYYMMDD) , 1) AS INT) AS BOH
									, VERSION_NO
									, MEASURE
									, MEASURE_ORDER_NO
									, MEASURE_LABEL
									, FROM_YYYYMMDD
									, TO_YYYYMMDD
									' + @mQry_sum + '
							FROM	#TblDynamicPivot_SCP0016 T
							GROUP BY	  KEY_IDX
										, DIVISION_ID
										, BIZ_TYPE,BIZ_TYPE_NAME,PROJECT_CODE
										, ITEM_ID
										, NICK_NAME
										, ELECTRODE_TYPE
										, ORIGIN_TO_DIVISION_ID
										, TO_SITE,TO_SITE_NAME,INCOTERMS
										, ORIGIN_FROM_DIVISION_ID
										, FROM_SITE
										, FROM_SITE_NAME
										, BOD_ID
										, TRANSPORT_MODE
										, LT_DAY
										, PLAN_START_YYYYMMDD
										, PLAN_TYPE
										, SEQ
										, VERSION_NO
										, MEASURE
										, MEASURE_ORDER_NO
										, MEASURE_LABEL
										, FROM_YYYYMMDD
										, TO_YYYYMMDD
						) A
						LEFT JOIN (
									SELECT	  DIVISION_ID
											, PROJECT_CODE
											, PROJECT_NAME
											, PROJECT_OWNER
											, ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE ORDER BY PROJECT_VER_SEQ ASC ) NUMS
									FROM	SCM_MST_PROJECT WITH(NOLOCK)) B ON
								A.PROJECT_CODE	= B.PROJECT_CODE'

		--IF @p_division_id NOT IN ('EE','EE_UC')
		IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
			SET @mEXEC = @mEXEC + N'
							AND A.DIVISION_ID = B.DIVISION_ID'
		ELSE
			SET @mEXEC = @mEXEC + N'
							AND A.ORIGIN_TO_DIVISION_ID = B.DIVISION_ID'

		SET @mEXEC = @mEXEC + N'
							AND B.NUMS = 1
						LEFT JOIN (
									SELECT	  DIVISION_ID
											, ITEM_ID
											, ITEM_NAME
											, NICK_NAME
											, ITEM_TYPE
											, ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, ITEM_ID ORDER BY  CASE ITEM_TYPE WHEN ''P'' THEN 999 WHEN ''H'' THEN 888 WHEN ''R'' THEN 777  WHEN ''Q'' THEN 666 ELSE 0 END  DESC ) NUMS
									FROM	SCM_MST_ITEM_SN WITH(NOLOCK)) C ON
								A.ITEM_ID=C.ITEM_ID'

		IF @p_division_id NOT IN ('EE','EE_UC')
			SET @mEXEC = @mEXEC + N'
							AND A.DIVISION_ID=C.DIVISION_ID'
		ELSE
			SET @mEXEC = @mEXEC + N'
							AND A.ORIGIN_TO_DIVISION_ID = C.DIVISION_ID'

		SET @mEXEC = @mEXEC + N'
							AND C.NUMS = 1'

		--IF @p_division_id NOT IN ('EE','EE_UC')
		IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
		BEGIN
			-- 2021-05-24 : 부서정보 없는 경우 조회 안되는 오류 수정
			--SET @mEXEC = @mEXEC+'      INNER JOIN scm_mst_site d  on a.DIVISION_ID=d.DIVISION_ID and a.TO_SITE=d.SCM_SITE_ID
			--SET @mEXEC = @mEXEC+'      INNER JOIN SCM_MST_SSO_DEPT_INFO e on e.DEPT_ID=d.DEPT_ID

			SET @mEXEC = @mEXEC + N'
						LEFT JOIN SCM_MST_SITE D ON
								A.DIVISION_ID = D.DIVISION_ID
							AND A.TO_SITE = D.SCM_SITE_ID
						LEFT JOIN SCM_MST_SSO_DEPT_INFO E ON
								E.DEPT_ID=D.DEPT_ID'
		END
		ELSE
		BEGIN
			SET @mEXEC = @mEXEC + N'
						LEFT JOIN SCM_MST_SITE D  ON
								A.ORIGIN_FROM_DIVISION_ID = D.DIVISION_ID
							AND D.SCM_SITE_ID = DBO.FN_GET_SITE_NAME_SHIPMENT(A.TO_SITE)
						LEFT JOIN SCM_MST_SSO_DEPT_INFO E ON
								E.DEPT_ID=D.DEPT_ID'
		END;

		SET @mEXEC = @mEXEC + N'
				ORDER BY	  DIVISION_ID
							, BIZ_TYPE
							, ITEM_ID
							, TO_SITE
							, PROJECT_CODE
							, INCOTERMS
							, FROM_SITE
							, BOD_ID
							, MEASURE_ORDER_NO
							, VERSION_NO'
--2023.12.30 천승호
		SET @mEXEC = @mEXEC 
			+ ' 	OPTION (MAXDOP 1) ; ' 
/*
checkpoint
dbcc dropcleanbuffers
dbcc freeproccache

--OPTION (MAXDOP 1) ;
--27초, 24초

*/


--exec debug_log @mEXEC, 'T';return;
		EXEC (@mEXEC);

		--임시테이블 삭제
		IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0016') IS NOT NULL
		BEGIN
			DROP TABLE #TblDynamicPivot_SCP0016;
		END

	END;
END

  
