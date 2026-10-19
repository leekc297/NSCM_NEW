

/*
 * Program ID   : SCP0094_GET_GLOBAL_PSI_AUTO
 * Description  : GLOBAL PSI AUTO 조회
 * Program History
 *===================================================================================================
 *   Date		In Charge	Description
 *===================================================================================================
 * 2023/01/12	chaan 		V1.0.0      Initial Release
 * 2023/04/10   LWY         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 */
--CREATE PROCEDURE [dbo].[SCP0094_GET_GLOBAL_PSI_AUTO]
 CREATE PROCEDURE [dbo].[SCP0094_GET_GLOBAL_PSI_AUTO]
    @p_division_id              NVARCHAR(30)        = '',
    @p_item_id					NVARCHAR(MAX)       ='',
    @p_nick_name				NVARCHAR(MAX)       ='',
    @p_cell_group				NVARCHAR(150)       ='',
    @p_from_site				NVARCHAR(MAX)       ='',
    @p_to_site					NVARCHAR(MAX)       ='',
    @p_plan_start_yyyymmdd		NVARCHAR(8)         = '',
    @p_plan_type				NVARCHAR(50)        = '',
    @p_seq						NVARCHAR(50)        = '',
    @p_bucket				    NVARCHAR(10)        = '',
    @p_chk_all				    NVARCHAR(1)         = '',
    @p_from_yyyymmdd			NVARCHAR(8)         = '',
    @p_to_yyyymmdd				NVARCHAR(8)         = '',
    @p_program_id				NVARCHAR(MAX)       = 'SCP0094',
    @p_sheet_name				NVARCHAR(MAX)       = 'Global PSI Auto',
    @p_user_id					NVARCHAR(MAX)       = '',
    @p_debug_mode				NVARCHAR(1)         = 'F'
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


    --DECLARE @p_division_id              NVARCHAR(30)        = '81';
    --DECLARE @p_item_id					NVARCHAR(MAX)       = '';
    --DECLARE @p_nick_name				NVARCHAR(MAX)       = '';
    --DECLARE @p_cell_group			    NVARCHAR(MAX)       = 'E57D';
    --DECLARE @p_from_site				NVARCHAR(MAX)       = '';
    --DECLARE @p_to_site					NVARCHAR(MAX)       = '';
    --DECLARE @p_plan_start_yyyymmdd		NVARCHAR(8)         = '20230130';
    --DECLARE @p_plan_type				NVARCHAR(50)        = 'PR';
    --DECLARE @p_seq						NVARCHAR(50)        = '1';
    --DECLARE @p_bucket				    NVARCHAR(10)        = 'DAILY';
    --DECLARE @p_chk_all				    NVARCHAR(1)         = 'N';
    --DECLARE @p_from_yyyymmdd			NVARCHAR(8)         = '20230101';
    --DECLARE @p_to_yyyymmdd				NVARCHAR(8)         = '20230331';
    --DECLARE @p_program_id				NVARCHAR(MAX)       = 'SCP0094';
    --DECLARE @p_sheet_name				NVARCHAR(MAX)       = 'Global PSI Auto';
    --DECLARE @p_user_id					NVARCHAR(MAX)       = 'iamarock';
    --DECLARE @p_debug_mode				NVARCHAR(1)         = 'F';


	PRINT 'All Start. ' + CONVERT(CHAR(23), GETDATE(), 21)

	DECLARE @v_cnt_usr_measure			NVARCHAR			= 0;

	SET @v_cnt_usr_measure = CONVERT(nvarchar(50), ISNULL((
                                                            SELECT  COUNT(*)
                                                            FROM    SCM_MST_TITLESET_USER
                                                            WHERE   1=1
                                                                AND PROGRAM_ID  =  @p_program_id
                                                                AND SHEET_NAME  =  @p_sheet_name
                                                                AND USER_ID     =  @p_user_id
                                                          ),0))

	DECLARE @v_from_yyyymmdd			NVARCHAR(8)			= '';
	DECLARE @v_to_yyyymmdd				NVARCHAR(8)			= '';
	DECLARE @v_from_result				NVARCHAR(8)			= '';
	DECLARE @v_to_result				NVARCHAR(8)			= '';


	SELECT  @v_from_yyyymmdd = C.BASIS_START_DATE
	FROM    [dbo].[SCM_SYS_CALENDAR_M]      C
	WHERE   1=1
	    AND C.BASIS_YYYYMMDD = @p_plan_start_yyyymmdd

	SELECT  @v_from_result = C.BASIS_START_DATE
	FROM    [dbo].[SCM_SYS_CALENDAR_M]      C
	WHERE   1=1
	    AND C.BASIS_YYYYMMDD = @p_from_yyyymmdd;

	SELECT  @v_to_result = C.BASIS_START_DATE
	FROM    [dbo].[SCM_SYS_CALENDAR_M]      C
	WHERE   1=1
	    AND C.BASIS_YYYYMMDD = @p_to_yyyymmdd;

	IF @v_from_yyyymmdd > @v_from_result
	BEGIN -- 실적 보여줌
		SET @v_to_yyyymmdd		= @p_to_yyyymmdd;
		SET @v_to_result		= @v_from_yyyymmdd;
	END
	ELSE IF @v_from_yyyymmdd <= @v_from_result
	BEGIN -- 실적 없음
		SET @v_to_yyyymmdd		= @p_to_yyyymmdd;
		SET @v_from_result		= CONVERT(CHAR(8), DATEADD(MM,  6, CONVERT(DATETIME,@p_plan_start_yyyymmdd)), 112);
		SET @v_to_result		= CONVERT(CHAR(8), DATEADD(MM, -6, CONVERT(DATETIME,@p_plan_start_yyyymmdd)), 112);
	END
	ELSE IF @v_from_yyyymmdd > @v_to_result
	BEGIN
		SET @v_from_yyyymmdd	= CONVERT(CHAR(8), DATEADD(MM, -6,  CONVERT(DATETIME,@p_plan_start_yyyymmdd)), 112);
		SET @v_to_yyyymmdd		= CONVERT(CHAR(8), DATEADD(MM, -6,  CONVERT(DATETIME,@p_plan_start_yyyymmdd)), 112);
		SET @v_from_result		= @p_from_yyyymmdd;
		SET @v_to_result		= @p_to_yyyymmdd;
	END
	ELSE IF @v_from_yyyymmdd	= @v_to_result
	BEGIN
		SET @v_to_yyyymmdd		= @v_from_yyyymmdd
		SET @v_from_result		= @p_from_yyyymmdd;
		SET @v_to_result		= @p_to_yyyymmdd;
	END


	PRINT 'v_from_yyyymmdd	: ' + @v_from_yyyymmdd;
	PRINT 'v_to_yyyymmdd	: ' + @v_to_yyyymmdd;
	PRINT 'v_from_result	: ' + @v_from_result;
	PRINT 'v_to_result		: ' + @v_to_result;


	IF(@p_chk_all = 'Y')
    BEGIN
        SET @p_bucket = 'DAILY';
    END


	--------------------------------------------------------------------------------------------------------------------------------------------
	-- 조회조건에 따른 필터링 처리
	--------------------------------------------------------------------------------------------------------------------------------------------
	/********************************************************************************
	 * 임시테이블만들기 - 조회조건 테이블
	 ********************************************************************************/
	/* NICK NAME 조회조건으로 ITEM 추출 */
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_NICKITEM') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_NICKITEM;

	SELECT DISTINCT
			ITEM_ID
	INTO	#TblDynamicPivot_SCP0094_NICKITEM
	FROM	SCM_MST_ITEM_SN A
	WHERE	1=1
		--AND A.NICK_NAME IS NOT NULL
		--AND ISNULL(@p_nick_name, '') != ''
		AND A.NICK_NAME LIKE '%' + @p_nick_name + '%'

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094_NICKITEM;return;

	/* PSI CELL/PACK ITEM 세트 */
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_RANK') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_RANK;

	SELECT	  CELL_ITEM_ID
			, ITEM_ID
			, RANK() OVER(ORDER BY CELL_ITEM_ID ASC) AS 'RANK'
	INTO	#TblDynamicPivot_SCP0094_RANK
	FROM	SCP_ANL_PSI_GLOBAL WITH(NOLOCK)
	WHERE	DIVISION_ID			=  @p_division_id
		AND PLAN_START_YYYYMMDD =  @p_plan_start_yyyymmdd
		AND PLAN_TYPE			=  @p_plan_type
		AND SEQ					=  @p_seq
		AND YYYYMMDD			>= @p_from_yyyymmdd
		AND YYYYMMDD			<= @p_to_yyyymmdd
	GROUP BY CELL_ITEM_ID, ITEM_ID
	ORDER BY CELL_ITEM_ID

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094_RANK;return;



	/* 조회조건에 해당하는 세트 모두 추출 */
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_ITEM') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_ITEM;

	SELECT	  A.CELL_ITEM_ID
			, A.ITEM_ID
	INTO	#TblDynamicPivot_SCP0094_ITEM
	FROM	#TblDynamicPivot_SCP0094_RANK A
	WHERE	A.RANK IN
			(
				SELECT	B.RANK
				FROM	#TblDynamicPivot_SCP0094_RANK B
				WHERE	1=1
					AND (
							   (B.ITEM_ID      IN (SELECT TOKEN   FROM dbo.UF_FX_String_Split (@p_item_id, ',')))
							OR (B.ITEM_ID      IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0094_NICKITEM))
							OR (B.CELL_ITEM_ID IN (SELECT TOKEN   FROM dbo.UF_FX_STRING_SPLIT (@p_item_id, ',')))
							OR (B.CELL_ITEM_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0094_NICKITEM)))
						)

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094_ITEM;return;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_CELL_GROUP') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_CELL_GROUP;
    
    SELECT  *
	INTO	#TblDynamicPivot_SCP0094_CELL_GROUP
    FROM    (
                SELECT DISTINCT
                          A.DIVISION_ID
                        , A.ITEM_ID
                        , A.GROUP_CODE1  AS CELL_GROUP
                FROM    SCP_MST_FINAL_ITEM A WITH(NOLOCK)
	            WHERE	1=1
                    AND ((@p_cell_group IS NULL OR @p_cell_group = '') OR  A.GROUP_CODE1 IN (SELECT TOKEN FROM dbo.UF_FX_String_Split (@p_cell_group, ',')))
            ) A
    WHERE   A.CELL_GROUP IS NOT NULL
        AND A.CELL_GROUP <> ''

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094_CELL_GROUP;return;


	PRINT 'Search Item set End. '+CONVERT(CHAR(23), GETDATE(), 21)


	/* 유저 MEASURE 세팅값 추출 */ --로드율은 PRODUCTION과 동일한 SORT 값을 강제 셋팅
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_MEASURE') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_MEASURE;

	SELECT	  M.COLUMN_NAME
			, M.COLUMN_LABEL_NAME
			, CASE
				WHEN M.COLUMN_NAME = 'LINE_TOTAL_LOAD_ENGINE' AND @v_cnt_usr_measure > 0 THEN ISNULL((
																										SELECT	T.SORT_ORDER_NO
																										FROM	SCM_MST_TITLESET_USER T
																										WHERE	T.PROGRAM_ID	= M.PROGRAM_ID
																											AND T.SHEET_NAME	= M.sheet_name
																											AND T.COLUMN_NAME	= 'PRODUCTION'
																											AND T.USER_ID		= U.USER_ID
																								   ), U.SORT_ORDER_NO)
				WHEN M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'	AND @v_cnt_usr_measure = 0 THEN P.SORT_ORDER_NO
				WHEN M.COLUMN_NAME='SHIP_PLAN'				AND @v_cnt_usr_measure > 0 THEN ISNULL((
																										SELECT	T.SORT_ORDER_NO
																										FROM	SCM_MST_TITLESET_USER T
																										WHERE	T.PROGRAM_ID	= M.program_id
																											AND T.SHEET_NAME	= M.sheet_name
																											AND T.COLUMN_NAME	= 'SHIP_REQ'
																											AND T.USER_ID		= U.USER_ID
																								 ), U.SORT_ORDER_NO)
				WHEN M.COLUMN_NAME = 'SHIP_PLAN' AND @v_cnt_usr_measure = 0 THEN S.SORT_ORDER_NO
				ELSE ISNULL(U.sort_order_no, M.SORT_ORDER_NO)
			  END AS SORT_ORDER_NO
			, M.ATTRIBUTE3 --MEASURE 별 COLOR RGB코드
	INTO	#TblDynamicPivot_SCP0094_MEASURE
	FROM	SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
			LEFT JOIN SCM_MST_TITLESET_USER U ON
					U.PROGRAM_ID    = M.PROGRAM_ID
				AND U.SHEET_NAME    = M.SHEET_NAME
				AND U.COLUMN_NAME   = M.COLUMN_NAME
				AND U.USER_ID       = @p_user_id
			LEFT JOIN SCM_MST_SHEET_MEASURE P ON
					P.PROGRAM_ID    = M.PROGRAM_ID
				AND P.SHEET_NAME    = M.SHEET_NAME
				AND P.COLUMN_NAME   = 'PRODUCTION'
			LEFT JOIN SCM_MST_SHEET_MEASURE S ON
					S.PROGRAM_ID    = M.PROGRAM_ID
				AND S.SHEET_NAME    = M.SHEET_NAME
				AND S.COLUMN_NAME   = 'SHIP_REQ'
	WHERE	M.PROGRAM_ID    = 'SCP0094'
		AND M.VALID_YN      = 'Y'
		AND (@v_cnt_usr_measure = 0 OR ISNULL(U.SORT_ORDER_NO, 0) > 0)

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094_MEASURE;return;


	PRINT 'Search Measure set End. '+CONVERT(CHAR(23), GETDATE(), 21)


	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094;

	CREATE TABLE #TblDynamicPivot_SCP0094
	(
		  DIVISION_ID			NVARCHAR(60)
		, OPERATION_GROUP		NVARCHAR(60)
		, CELL_ITEM_ID			NVARCHAR(100)
		, ITEM_ID				NVARCHAR(100)
		, CELL_GROUP			NVARCHAR(150)
		, TO_SITE				NVARCHAR(60)
		, TO_SITE2				NVARCHAR(60)
		, TO_BOH_QTY			BIGINT
		, FROM_BOH_QTY			BIGINT
		, INCOTERMS				NVARCHAR(20)
		, FROM_SITE				NVARCHAR(60)
		, TRANSPORT_MODE_LINE	NVARCHAR(100)
		, MEASURE				NVARCHAR(100)
		, B_YYYYMMDD			NVARCHAR(10)
		, YYYYMMDD				NVARCHAR(10)
		, YYYYMM				NVARCHAR(6)
		, QTY					NUMERIC(30,10)
		, ISO_WEEK				INT
		, SORT_ORDER_NO			INT
		, COLUMN_LABEL_NAME		NVARCHAR(300)
		, BOD_ID				NVARCHAR(300)
		, ATTRIBUTE9			NVARCHAR(150)
		, ATTRIBUTE10			NVARCHAR(150)
		, ATTRIBUTE3			NVARCHAR(30)
	)


	INSERT	#TblDynamicPivot_SCP0094
	SELECT	  A.DIVISION_ID
			, A.OPERATION_GROUP
			, A.CELL_ITEM_ID
			, A.ITEM_ID
			, N.CELL_GROUP
			, ISNULL(NULLIF(A.TO_SITE, '') , '-') TO_SITE
			, CASE WHEN RIGHT(ISNULL(NULLIF(A.TO_SITE, '') , '-'), 2) = '-S' THEN LEFT(ISNULL(NULLIF(A.TO_SITE, '') , '-'), LEN(ISNULL(NULLIF(A.TO_SITE, '') , '-')) - 2) ELSE ISNULL(NULLIF(A.TO_SITE, '') , '-') END TO_SITE2
			, A.TO_BOH_QTY
			, A.FROM_BOH_QTY
			, A.INCOTERMS
			, A.FROM_SITE
			, A.TRANSPORT_MODE_LINE
			, A.MEASURE
			, A.YYYYMMDD							AS B_YYYYMMDD
			, 'D_'+ A.YYYYMMDD					AS YYYYMMDD
			, O.BASIS_YYYYMM						AS YYYYMM
			, ISNULL(QTY,0)							AS QTY
			, RIGHT(O.BASIS_YYYYMM, 4) + O.ISO_WEEK	AS ISO_WEEK
			, M.SORT_ORDER_NO
			, M.COLUMN_LABEL_NAME
			, A.BOD_ID
			, A.ATTRIBUTE9                          -- OPERATION ID
			, A.ATTRIBUTE10                         -- P:1, A:2
			, M.ATTRIBUTE3                          -- UI용 MEASURE COLOR
	FROM	SCP_ANL_PSI_GLOBAL A WITH(NOLOCK)
			INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) O ON
					A.YYYYMMDD = O.BASIS_YYYYMMDD
			INNER JOIN #TblDynamicPivot_SCP0094_MEASURE (NOLOCK) M ON
					M.COLUMN_NAME=A.MEASURE
            LEFT JOIN #TblDynamicPivot_SCP0094_CELL_GROUP(NOLOCK) N ON
					A.DIVISION_ID   = N.DIVISION_ID
                AND A.ITEM_ID       = N.ITEM_ID
    WHERE	A.DIVISION_ID			= @p_division_id
	    AND A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
	    AND A.PLAN_TYPE				= @p_plan_type
	    AND A.SEQ					= @p_seq
	    AND A.YYYYMMDD				>= @p_from_yyyymmdd
	    AND A.YYYYMMDD				<= @p_to_yyyymmdd
		AND (@v_cnt_usr_measure = 0 OR ISNULL(M.SORT_ORDER_NO,0)>0)

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094_CELL_GROUP;
--select * from #TblDynamicPivot_SCP0094;return;

--select * 
--		FROM    #TblDynamicPivot_SCP0094 A
--				LEFT JOIN #TblDynamicPivot_SCP0094_ITEM B ON A.CELL_ITEM_ID = B.CELL_ITEM_ID AND A.ITEM_ID = B.ITEM_ID
--		WHERE   B.ITEM_ID IS NULL
--RETURN;
	IF (@p_item_id IS NOT NULL AND @p_item_id <> '') OR (@p_nick_name IS NOT NULL AND @p_nick_name <> '')
	BEGIN
		DELETE A
		FROM    #TblDynamicPivot_SCP0094 A
				LEFT JOIN #TblDynamicPivot_SCP0094_ITEM B ON A.CELL_ITEM_ID = B.CELL_ITEM_ID AND A.ITEM_ID = B.ITEM_ID
		WHERE   B.ITEM_ID IS NULL
	END

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094;return;

	IF @p_cell_group IS NOT NULL AND @p_cell_group <> ''
	BEGIN
		DELETE A
		FROM    #TblDynamicPivot_SCP0094 A
				LEFT JOIN #TblDynamicPivot_SCP0094_CELL_GROUP B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID AND A.CELL_GROUP = B.CELL_GROUP
		WHERE   B.CELL_GROUP IS NULL
	END

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094;return;

	IF @p_from_site IS NOT NULL	AND @p_from_site <> ''
	BEGIN
		DELETE A
		FROM    #TblDynamicPivot_SCP0094 A
        WHERE   ISNULL(NULLIF(A.FROM_SITE, '') , '-') NOT IN (SELECT TOKEN FROM dbo.String_Split(@p_from_site, ','))
	END

	IF @p_to_site IS NOT NULL	AND @p_to_site <> ''
	BEGIN
		DELETE A
		FROM    #TblDynamicPivot_SCP0094 A
        WHERE   ISNULL(NULLIF(A.TO_SITE, '') , '-') NOT IN (SELECT TOKEN FROM dbo.String_Split(@p_to_site, ','))
	END


--TESTING : OK
--select * from #TblDynamicPivot_SCP0094;return;


	PRINT 'Search Rowdata set End. '+CONVERT(CHAR(23), GETDATE(), 21)


	/********************************************************************************
	* 1. Line Load(%) Temp
	********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_TEMP') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_TEMP;

	SELECT	  A.DIVISION_ID
			, A.OPERATION_GROUP
			, A.FROM_SITE
			, A.ATTRIBUTE9
			, A.TRANSPORT_MODE_LINE
			, ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0)    AS SUM_LOAD_QTY
			, CASE
				WHEN D.WORKING_TIME <= 0.0 THEN 0
				ELSE ISNULL(((ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0) / D.WORKING_TIME)), 0) * 100
			  END                                       AS QTY
			, D.WORKING_TIME
			, A.YYYYMMDD                                AS B_YYYYMMDD
			, O.BASIS_YYYYMM                            AS YYYYMM
			, O.ISO_WEEK
			,'W_'+O.BASIS_YYYYMM + O.ISO_WEEK           AS WEEK_YYYYMMDD
			,'M_'+O.BASIS_YYYYMM                        AS MONTH_YYYYMMDD
	INTO	#TblDynamicPivot_SCP0094_TEMP
	FROM	SCP_ANL_PSI_GLOBAL A WITH(NOLOCK)
			INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) O ON
					A.YYYYMMDD                                                  = O.BASIS_YYYYMMDD
			INNER JOIN SCM_MST_SHEET_MEASURE M WITH(NOLOCK) ON
					M.PROGRAM_ID                                                = @p_program_id
				AND M.COLUMN_NAME                                               = A.MEASURE
			JOIN SCP_ANL_WORKING_TIME D ON
					A.DIVISION_ID                                               = D.DIVISION_ID
				AND A.ATTRIBUTE9                                                = D.OPERATION_ID
				AND A.FROM_SITE                                                 = D.SCM_SITE_ID
				AND A.TRANSPORT_MODE_LINE                                       = D.LINE_ID
				AND A.YYYYMMDD                                                  = D.YYYYMMDD
			JOIN SCP_ANL_TACT_TIME E ON
					A.DIVISION_ID                                               = E.DIVISION_ID
				AND A.ATTRIBUTE9                                                = E.OPERATION_ID
				AND A.FROM_SITE                                                 = E.SCM_SITE_ID
				AND A.TRANSPORT_MODE_LINE                                       = E.LINE_ID
				AND IIF(A.OPERATION_GROUP = 'P', A.ITEM_ID , A.CELL_ITEM_ID)    = E.ITEM_ID
				AND A.YYYYMMDD                                                  = E.YYYYMMDD
	WHERE		A.DIVISION_ID				                                    = @p_division_id
			AND A.PLAN_START_YYYYMMDD		                                    = @p_plan_start_yyyymmdd
			AND A.PLAN_TYPE					                                    = @p_plan_type
			AND A.SEQ						                                    = @p_seq
			AND A.YYYYMMDD					                                    >= @p_from_yyyymmdd
			AND A.YYYYMMDD					                                    <= @p_to_yyyymmdd
			AND (@v_cnt_usr_measure = 0 OR ISNULL(M.sort_order_no, 0) > 0)
			AND A.MEASURE					                                    = 'PRODUCTION' -- 6초 75712행
	GROUP BY  A.DIVISION_ID
            , A.OPERATION_GROUP
            , A.FROM_SITE
            , A.ATTRIBUTE9
            , A.TRANSPORT_MODE_LINE
            , A.YYYYMMDD
            , O.BASIS_YYYYMM
            , O.ISO_WEEK
            , D.WORKING_TIME

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094_TEMP;return;

  PRINT 'Search Line Load set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	/********************************************************************************
	* 2. 과거 실적구간 temp
	********************************************************************************/
	--생산/출하 실적 Temp Table
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_RESULT') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_RESULT;

	CREATE TABLE #TblDynamicPivot_SCP0094_RESULT
	(
		  DIVISION_ID			NVARCHAR(60)
		, OPERATION_GROUP		NVARCHAR(60)
		, CELL_ITEM_ID			NVARCHAR(100)
		, ITEM_ID				NVARCHAR(100)
		, CELL_GROUP			NVARCHAR(150)
		, TO_SITE				NVARCHAR(60)
		, TO_SITE2				NVARCHAR(60)
		, TO_BOH_QTY			BIGINT
		, FROM_BOH_QTY			BIGINT
		, INCOTERMS				NVARCHAR(20)
		, FROM_SITE				NVARCHAR(60)
		, TRANSPORT_MODE_LINE	NVARCHAR(100)
		, MEASURE				NVARCHAR(100)
		, SORT_ORDER_NO			INT
		, COLUMN_LABEL_NAME		NVARCHAR(300)
		, BOD_ID				NVARCHAR(300)
		, ATTRIBUTE9			NVARCHAR(150)
		, ATTRIBUTE10			NVARCHAR(150)
		, ATTRIBUTE3			NVARCHAR(30)
	)

	IF(@v_from_result<@v_to_result)
	BEGIN
		INSERT INTO #TblDynamicPivot_SCP0094_RESULT
		SELECT DISTINCT
				  A.DIVISION_ID
				, A.OPERATION_GROUP
				, A.CELL_ITEM_ID
				, A.ITEM_ID
                , A.CELL_GROUP
				, A.TO_SITE
				, A.TO_SITE2
				, A.TO_BOH_QTY
				, A.FROM_BOH_QTY
				, A.INCOTERMS
				, A.FROM_SITE
				, A.TRANSPORT_MODE_LINE
				, A.MEASURE
				, A.SORT_ORDER_NO
				, A.COLUMN_LABEL_NAME
				, A.BOD_ID
				, A.ATTRIBUTE9
				, A.ATTRIBUTE10
				, A.ATTRIBUTE3
		FROM	#TblDynamicPivot_SCP0094 A WITH(NOLOCK)
		WHERE	A.MEASURE IN ('PRODUCTION','SHIP_PLAN','ALLOCATION') --2초

		PRINT 'Search Prev Result set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END;

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094;return;

	-- Line Load(%) Insert
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_LOAD') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_LOAD;

	SELECT	  A.DIVISION_ID
			, A.OPERATION_GROUP
			, A.CELL_ITEM_ID
			, A.ITEM_ID
            , A.CELL_GROUP
			, A.TO_SITE
			, A.TO_SITE2
			, A.TO_BOH_QTY
			, A.FROM_BOH_QTY
			, A.INCOTERMS
			, A.FROM_SITE
			, A.TRANSPORT_MODE_LINE
			, 'LINE_TOTAL_LOAD_ENGINE' AS MEASURE
			, A.B_YYYYMMDD
			, A.YYYYMMDD
			, A.YYYYMM
			, B.QTY
			, A.ISO_WEEK
			--, ISNULL(U.SORT_ORDER_NO, M.SORT_ORDER_NO) SORT_ORDER_NO -- 수정
			, M.SORT_ORDER_NO
			, M.COLUMN_LABEL_NAME
			, A.BOD_ID
			, A.ATTRIBUTE9
			, A.ATTRIBUTE10
			, M.ATTRIBUTE3
			, B.SUM_LOAD_QTY
			, B.WORKING_TIME
			, B.WEEK_YYYYMMDD
			, B.MONTH_YYYYMMDD
	INTO	#TblDynamicPivot_SCP0094_LOAD
	FROM	#TblDynamicPivot_SCP0094 A WITH(NOLOCK)
			JOIN #TblDynamicPivot_SCP0094_TEMP B WITH(NOLOCK) ON
					A.DIVISION_ID           = B.DIVISION_ID
				AND A.OPERATION_GROUP       = B.OPERATION_GROUP
				AND A.FROM_SITE             = B.FROM_SITE
				AND A.ATTRIBUTE9            = B.ATTRIBUTE9
				AND A.TRANSPORT_MODE_LINE   = B.TRANSPORT_MODE_LINE
				AND A.B_yyyymmdd            = B.B_yyyymmdd
			INNER JOIN #TblDynamicPivot_SCP0094_MEASURE M WITH(NOLOCK) ON
					M.COLUMN_NAME           = 'LINE_TOTAL_LOAD_ENGINE'

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094_LOAD;return;

	PRINT 'Input Line Load Daily End. '+CONVERT(CHAR(23), GETDATE(), 21)

	/*
	INSERT INTO #TblDynamicPivot_SCP0094
	SELECT A.DIVISION_ID
		   , A.OPERATION_GROUP
		   , A.CELL_ITEM_ID
		   , A.ITEM_ID
		   , A.TO_SITE
		   , A.TO_BOH_QTY
		   , A.FROM_BOH_QTY
		   , A.INCOTERMS
		   , A.FROM_SITE
		   , A.TRANSPORT_MODE_LINE
		   , 'LINE_TOTAL_LOAD_ENGINE' MEASURE
		   , A.B_yyyymmdd
		   , A.yyyymmdd
		   , A.yyyymm
		   , B.qty
		   , A.iso_week
		   --, ISNULL(U.sort_order_no, M.SORT_ORDER_NO) SORT_ORDER_NO -- 수정
		   , M.sort_order_no
		   , M.COLUMN_LABEL_NAME
		   , A.BOD_ID
		   , A.ATTRIBUTE9
		   , A.ATTRIBUTE10
		   , M.ATTRIBUTE3
	FROM #TblDynamicPivot_SCP0094 A WITH(NOLOCK)
	JOIN #TblDynamicPivot_SCP0094_TEMP B WITH(NOLOCK)
		ON A.DIVISION_ID=B.DIVISION_ID
		AND A.OPERATION_GROUP = B.OPERATION_GROUP
		AND A.FROM_SITE=B.FROM_SITE
		AND A.ATTRIBUTE9 = B.ATTRIBUTE9
		AND A.TRANSPORT_MODE_LINE = B.TRANSPORT_MODE_LINE
		AND A.B_yyyymmdd = B.B_yyyymmdd
	INNER JOIN #TblDynamicPivot_SCP0094_MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'
	;
	*/

	--Load율 개선(Daily)
	INSERT INTO #TblDynamicPivot_SCP0094
	SELECT	  A.DIVISION_ID
			, A.OPERATION_GROUP
			, A.CELL_ITEM_ID
			, A.ITEM_ID
            , A.CELL_GROUP
			, A.TO_SITE
			, A.TO_SITE2
			, A.TO_BOH_QTY
			, A.FROM_BOH_QTY
			, A.INCOTERMS
			, A.FROM_SITE
			, A.TRANSPORT_MODE_LINE
			, A.MEASURE
			, A.B_YYYYMMDD
			, A.YYYYMMDD
			, A.YYYYMM
			, A.QTY
			, A.ISO_WEEK
			, A.SORT_ORDER_NO
			, A.COLUMN_LABEL_NAME
			, A.BOD_ID
			, A.ATTRIBUTE9
			, A.ATTRIBUTE10
			, A.ATTRIBUTE3
	FROM	#TblDynamicPivot_SCP0094_LOAD A WITH(NOLOCK)

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094;return;

	PRINT 'Input Line Load Daily set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	--Load율 개선(Week)
	INSERT INTO #TblDynamicPivot_SCP0094
	SELECT    DIVISION_ID
            , OPERATION_GROUP
            , CELL_ITEM_ID
            , ITEM_ID
            , CELL_GROUP
            , TO_SITE
            , TO_SITE2
            , TO_BOH_QTY
            , FROM_BOH_QTY
            , INCOTERMS
            , FROM_SITE
            , TRANSPORT_MODE_LINE
            , MEASURE
            , '-'           AS B_YYYYMMDD
            , WEEK_YYYYMMDD AS YYYYMMDD
            , '-'           AS YYYYMM
            , CASE
                WHEN SUM(WORKING_TIME) <= 0.0 THEN 0
                ELSE ISNULL( ( SUM(SUM_LOAD_QTY) / SUM(WORKING_TIME) ), 0 ) * 100
              END           AS QTY
            , '-'           AS ISO_WEEK
            , SORT_ORDER_NO
            , COLUMN_LABEL_NAME
            , BOD_ID
            , ATTRIBUTE9
            , ATTRIBUTE10
            , ATTRIBUTE3
	FROM    #TblDynamicPivot_SCP0094_LOAD
	GROUP BY   DIVISION_ID
			 , OPERATION_GROUP
			 , CELL_ITEM_ID
			 , ITEM_ID
             , CELL_GROUP
			 , TO_SITE
			 , TO_SITE2
			 , TO_BOH_QTY
			 , FROM_BOH_QTY
			 , INCOTERMS
			 , FROM_SITE
			 , TRANSPORT_MODE_LINE
			 , MEASURE
			 , SORT_ORDER_NO
			 , COLUMN_LABEL_NAME
			 , BOD_ID
			 , ATTRIBUTE9
			 , ATTRIBUTE10
			 , ATTRIBUTE3
			 , WEEK_YYYYMMDD
			 , MONTH_YYYYMMDD

	PRINT 'Input Line Load Week set End. '+CONVERT(CHAR(23), GETDATE(), 21)



	--Load율 개선(Month)
	INSERT INTO #TblDynamicPivot_SCP0094
	SELECT	  DIVISION_ID
			, OPERATION_GROUP
			, CELL_ITEM_ID
			, ITEM_ID
            , CELL_GROUP
			, TO_SITE
			, TO_SITE2
			, TO_BOH_QTY
			, FROM_BOH_QTY
			, INCOTERMS
			, FROM_SITE
			, TRANSPORT_MODE_LINE
			, MEASURE
			, '-'               AS B_YYYYMMDD
			, MONTH_YYYYMMDD    AS YYYYMMDD
			, '-'               AS YYYYMM
			, CASE
				WHEN SUM(working_time) <= 0.0 THEN 0
				ELSE ISNULL( ( SUM(SUM_LOAD_QTY) / SUM(working_time) ) ,0 ) * 100
			  END               AS qty
			, '-'               AS ISO_WEEK
			, SORT_ORDER_NO
			, COLUMN_LABEL_NAME
			, BOD_ID
			, ATTRIBUTE9
			, ATTRIBUTE10
			, ATTRIBUTE3
	FROM    #TblDynamicPivot_SCP0094_LOAD
	GROUP BY DIVISION_ID
			 , OPERATION_GROUP
			 , CELL_ITEM_ID
			 , ITEM_ID
             , CELL_GROUP
			 , TO_SITE
			 , TO_SITE2
			 , TO_BOH_QTY
			 , FROM_BOH_QTY
			 , INCOTERMS
			 , FROM_SITE
			 , TRANSPORT_MODE_LINE
			 , MEASURE
			 , SORT_ORDER_NO
			 , COLUMN_LABEL_NAME
			 , BOD_ID
			 , ATTRIBUTE9
			 , ATTRIBUTE10
			 , ATTRIBUTE3
			 , MONTH_YYYYMMDD

	PRINT 'Input Line Load Month set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	-- 생산/출하/매출 실적 insert
	IF(@v_from_result<@v_to_result)
	BEGIN
		-- 1. 생산실적 insert
		INSERT INTO #TblDynamicPivot_SCP0094
		SELECT DISTINCT
				  R.DIVISION_ID
				, A.OPERATION_GROUP
				, A.CELL_ITEM_ID
				, A.ITEM_ID
                , A.CELL_GROUP
				, A.TO_SITE
				, A.TO_SITE2
				, A.TO_BOH_QTY
				, A.FROM_BOH_QTY
				, A.INCOTERMS
				, A.FROM_SITE
				, A.TRANSPORT_MODE_LINE
				, A.MEASURE
				, CONVERT(NVARCHAR(8), R.PLAN_DATE,112)         AS B_YYYYMMDD
				, 'D_' + CONVERT(NVARCHAR(8), R.PLAN_DATE,112)  AS YYYYMMDD
				, C.BASIS_YYYYMM                                AS YYYYMM
				, R.ACTUAL_GOOD_QTY                             AS QTY
				--,RIGHT(C.BASIS_YYYYMM,2)+C.ISO_WEEK           AS ISO_WEEK
				, RIGHT(C.BASIS_YYYYMM, 4) + C.ISO_WEEK         AS ISO_WEEK
				, A.SORT_ORDER_NO
				, A.COLUMN_LABEL_NAME
				, A.BOD_ID
				, A.ATTRIBUTE9
				, A.ATTRIBUTE10
				, A.ATTRIBUTE3
		FROM	SCM_DNM_PRODUCT_RESULT_V R
				JOIN scm_sys_calendar_m C ON
						CONVERT(NVARCHAR(8), R.PLAN_DATE, 112)  = C.BASIS_YYYYMMDD
				LEFT OUTER JOIN SCP_MST_FINAL_ITEM B ON
						R.DIVISION_ID                           = B.DIVISION_ID
					AND R.ITEM_ID                               = B.ITEM_ID
					AND R.SCP_OPERATION_GROUP                   = B.OPERATION_GROUP
				JOIN #TblDynamicPivot_SCP0094_RESULT A WITH(NOLOCK) ON
						A.MEASURE                               = 'PRODUCTION'
					AND A.DIVISION_ID                           = R.DIVISION_ID
					AND A.OPERATION_GROUP                       = R.SCP_OPERATION_GROUP
					AND A.FROM_SITE                             = R.SCM_SITE_ID
					AND A.ITEM_ID                               = R.ITEM_ID
					AND A.ATTRIBUTE9                            = R.OPERATION_ID
					AND A.TRANSPORT_MODE_LINE                   = R.LINE_ID
		WHERE	1=1
			AND R.PLAN_DATE   >= CONVERT(DATETIME, @v_from_result)
			AND R.PLAN_DATE   <  CONVERT(DATETIME, @v_to_result )
			AND R.DIVISION_ID =  @p_division_id
			AND R.SCP_OPERATION_GROUP IN ('A', 'P')
			AND (
					LEFT(R.OPERATION_ID,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
												SELECT	SEGMENT1 AS OPERATION_ID
												FROM	SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
												WHERE	LOOKUP_TYPE =  'SCP_PLAN_OPERATION'
													AND SEGMENT1    <> 'F6000'
													AND VALID_YN    =  'Y'
											  )
				  OR R.OPERATION_ID IN		  (--외주PACKER의 업체코드
												SELECT	PLANT_ID  AS OPERATION_ID
												FROM	SCM_MST_SITE WITH(NOLOCK)
												WHERE	1=1
													AND DIVISION_ID = @p_division_id
													AND SITE_TYPE   = 'PLANT'
													AND OSP_YN      = 'Y'
													AND VALID_YN    = 'Y'
											  )
			   )

		PRINT 'Input Supply set End. '+CONVERT(CHAR(23), GETDATE(), 21)

		-- 2. 출하실적 insert
		INSERT INTO #TblDynamicPivot_SCP0094
		SELECT	  R.DIVISION_ID
				, A.OPERATION_GROUP
				, A.CELL_ITEM_ID
				, A.ITEM_ID
                , A.CELL_GROUP
				, A.TO_SITE
				, A.TO_SITE2
				, A.TO_BOH_QTY
				, A.FROM_BOH_QTY
				, A.INCOTERMS
				, A.FROM_SITE
				, A.TRANSPORT_MODE_LINE
				, A.MEASURE
				, R.EXFACTORY_DATE                      AS B_YYYYMMDD
				, 'D_' + R.EXFACTORY_DATE               AS YYYYMMDD
				, C.BASIS_YYYYMM                        AS YYYYMM
				, R.EXFACTORY_QTY                       AS QTY
				, RIGHT(C.BASIS_YYYYMM, 4) + C.ISO_WEEK	AS ISO_WEEK
				, A.SORT_ORDER_NO
				, A.COLUMN_LABEL_NAME
				, A.BOD_ID
				, A.ATTRIBUTE9
				, A.ATTRIBUTE10
				, A.ATTRIBUTE3
		FROM	SCM_DNM_EXFACTORY_RESULT R
				JOIN SCM_SYS_CALENDAR_M C ON
						R.EXFACTORY_DATE        = C.BASIS_YYYYMMDD
				LEFT OUTER JOIN SCM_MST_SITE B ON
						B.SCM_SITE_ID           = R.TO_SCM_SITE_ID
					AND B.SITE_TYPE             = 'PLANT'
				JOIN #TblDynamicPivot_SCP0094_RESULT A WITH(NOLOCK) ON
						A.MEASURE               = 'SHIP_PLAN'
					AND A.DIVISION_ID           = R.DIVISION_ID
					AND A.ITEM_ID               = R.ITEM_ID
					AND A.FROM_SITE             = R.FROM_SCM_SITE_ID
					AND A.TO_SITE               = R.TO_SCM_SITE_ID
					AND A.TRANSPORT_MODE_LINE   = R.TRANSPORT_MODE
		WHERE	1=1
			AND R.EXFACTORY_DATE    >= CONVERT(DATETIME, @v_from_result)
			AND R.EXFACTORY_DATE    < CONVERT(DATETIME, @v_to_result )
			AND R.DIVISION_ID		= @p_division_id
			AND (B.PLANT_ID IS NOT NULL OR (B.PLANT_ID IS NULL AND A.INCOTERMS = R.INCOTERMS)) -- FG의 경우 INCOTERMS 비교
			AND R.EXFACTORY_STATUS IN ('D20','D30','D40')

		PRINT 'Input Shipping set End. '+CONVERT(CHAR(23), GETDATE(), 21)

		-- 3. 매출실적 insert
		INSERT INTO	#TblDynamicPivot_SCP0094
		SELECT	  R.DIVISION_ID
				, A.OPERATION_GROUP
				, A.CELL_ITEM_ID
				, A.ITEM_ID
                , A.CELL_GROUP
				, A.TO_SITE
				, A.TO_SITE2
				, A.TO_BOH_QTY
				, A.FROM_BOH_QTY
				, A.INCOTERMS
				, A.FROM_SITE
				, A.TRANSPORT_MODE_LINE
				, A.MEASURE
				, R.YYYYMMDD                            AS B_YYYYMMDD
				, 'D_' + R.YYYYMMDD                     AS YYYYMMDD
				, C.BASIS_YYYYMM                        AS YYYYMM
				, R.QTY                                 AS QTY
				, RIGHT(C.BASIS_YYYYMM, 4) + C.ISO_WEEK AS ISO_WEEK
				, A.SORT_ORDER_NO
				, A.COLUMN_LABEL_NAME
				, A.BOD_ID
				, A.ATTRIBUTE9
				, A.ATTRIBUTE10
				, A.ATTRIBUTE3
		FROM	DM_PLN_SALES_PLAN_RESULT R
				JOIN SCM_SYS_CALENDAR_M C ON
						R.YYYYMMDD      = C.BASIS_YYYYMMDD
		--JOIN SCM_MST_SITE B ON B.SCM_SITE_ID = R.PLANT_SITE_ID AND B.SITE_TYPE='PLANT'
				JOIN #TblDynamicPivot_SCP0094_RESULT A WITH(NOLOCK) ON
						A.MEASURE       = 'ALLOCATION'
					AND A.DIVISION_ID   = R.DIVISION_ID
					AND A.ITEM_ID       = R.ITEM_ID
					AND A.TO_SITE       = R.SCM_SITE_ID
					AND A.INCOTERMS     = R.INCOTERMS
		WHERE	1=1
			AND R.YYYYMMDD      >= CONVERT(DATETIME, @v_from_result)
			AND R.YYYYMMDD      <  CONVERT(DATETIME, @v_to_result )
			AND R.DIVISION_ID   =  @p_division_id
			AND R.MEASURE       =  'RTF'

		PRINT 'Input RTF set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END

--2021/11/02 Start UI 속도 개선
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_FNL') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_FNL;

	CREATE TABLE #TblDynamicPivot_SCP0094_FNL
	(
		  DIVISION_ID			NVARCHAR(60)
		, OPERATION_GROUP		NVARCHAR(60)
		, CELL_ITEM_ID			NVARCHAR(100)
		, ITEM_ID				NVARCHAR(100)
		, CELL_GROUP    		NVARCHAR(150)
		, TO_SITE				NVARCHAR(60)
		, TO_SITE2				NVARCHAR(60)
		, TO_BOH_QTY			BIGINT
		, FROM_BOH_QTY			BIGINT
		, INCOTERMS				NVARCHAR(20)
		, FROM_SITE				NVARCHAR(60)
		, TRANSPORT_MODE_LINE	NVARCHAR(100)
		, MEASURE				NVARCHAR(100)
		, B_YYYYMMDD			NVARCHAR(10)
		, YYYYMMDD				NVARCHAR(10)
		, YYYYMM				NVARCHAR(6)
		, QTY					NUMERIC(30,10)
		, ISO_WEEK				INT
		, SORT_ORDER_NO			INT
		, COLUMN_LABEL_NAME		NVARCHAR(300)
		, BOD_ID				NVARCHAR(300)
		, ATTRIBUTE9			NVARCHAR(150)
		, ATTRIBUTE10			NVARCHAR(150)
		, ATTRIBUTE3			NVARCHAR(30)
	    , WEEK_YN               CHAR(1)
	    , MONTH_YN              CHAR(1)
	)

    INSERT INTO	#TblDynamicPivot_SCP0094_FNL
	SELECT	  DIVISION_ID
			, OPERATION_GROUP
			, CELL_ITEM_ID
			, ITEM_ID
    		, CELL_GROUP
			, TO_SITE
			, TO_SITE2
			, TO_BOH_QTY
			, FROM_BOH_QTY
			, INCOTERMS
			, FROM_SITE
			, TRANSPORT_MODE_LINE
			, MEASURE
			, B_YYYYMMDD
			, YYYYMMDD
			, YYYYMM
			, QTY
			, ISO_WEEK
			, SORT_ORDER_NO
			, COLUMN_LABEL_NAME
			, BOD_ID
			, ATTRIBUTE9
			, ATTRIBUTE10
			, ATTRIBUTE3
            , ''
            , ''
	FROM	#TblDynamicPivot_SCP0094

	--MODEL_INVENTORY, WH_IN_BALANCE, BALANCE, CHAR_AVAILABLE, ACTIVATE_PROGRESS

	--chaan begin V1.5 VMI 안전재고설정 추가 - Measure가 없는 Gap용 가상행을 추가함(Safety Stock 행 복사후 Measure, ATTRIBUTE3-라인색상 등만 Gap용으로 변경)
	INSERT INTO #TblDynamicPivot_SCP0094_FNL
	SELECT    F.DIVISION_ID
			, F.OPERATION_GROUP
			, F.CELL_ITEM_ID
			, F.ITEM_ID
    		, F.CELL_GROUP
			, F.TO_SITE
			, F.TO_SITE2
			, F.TO_BOH_QTY
			, F.FROM_BOH_QTY
			, F.INCOTERMS
			, F.FROM_SITE
			, F.TRANSPORT_MODE_LINE
			, F.MEASURE
			, F.B_YYYYMMDD
			, F.YYYYMMDD
			, F.YYYYMM
			, F.QTY
			, F.ISO_WEEK
			, C.SORT_ORDER_NO
			, C.COLUMN_LABEL_NAME
			, F.BOD_ID
			, F.ATTRIBUTE9
			, F.ATTRIBUTE10
			, C.ATTRIBUTE3
			, F.WEEK_YN
			, F.MONTH_YN
	FROM    (
				SELECT    S.DIVISION_ID
						, S.OPERATION_GROUP
						, S.CELL_ITEM_ID
						, S.ITEM_ID
                		, S.CELL_GROUP
						, S.TO_SITE
						, S.TO_SITE2
						, S.TO_BOH_QTY
						, S.FROM_BOH_QTY
						, S.INCOTERMS
						, S.FROM_SITE
						, S.TRANSPORT_MODE_LINE
						, 'GAP'                                 AS MEASURE
						, S.B_YYYYMMDD
						, S.YYYYMMDD
						, S.YYYYMM
						, (ISNULL(B.QTY, 0) - ISNULL(S.QTY, 0)) AS QTY
						, S.ISO_WEEK
						, S.SORT_ORDER_NO
						, S.COLUMN_LABEL_NAME
						, S.BOD_ID
						, S.ATTRIBUTE9
						, S.ATTRIBUTE10
						, S.ATTRIBUTE3
						, S.WEEK_YN
						, S.MONTH_YN
				FROM
						(
							SELECT  *
							FROM    #TblDynamicPivot_SCP0094_FNL
							WHERE   MEASURE = 'SAFETY_STOCK'
						) S
						LEFT JOIN -- Safet Stocck 을 기준으로 하므로 Safety Stock 행이 없으면 Gap 행도 만들 수 없음
						(
							SELECT  *
							FROM    #TblDynamicPivot_SCP0094_FNL
							WHERE   MEASURE = 'WH_IN_BALANCE'
						) B ON
								S.DIVISION_ID = B.DIVISION_ID
							AND S.OPERATION_GROUP		= B.OPERATION_GROUP
							AND S.CELL_ITEM_ID			= B.CELL_ITEM_ID
							AND S.ITEM_ID				= B.ITEM_ID
							AND S.CELL_GROUP			= B.CELL_GROUP
							AND S.TO_SITE				= B.TO_SITE
							AND S.TO_SITE2				= B.TO_SITE2
							--AND S.TO_BOH_QTY			= B.TO_BOH_QTY
							--AND S.FROM_BOH_QTY		= B.FROM_BOH_QTY
							AND S.INCOTERMS				= B.INCOTERMS
							AND S.FROM_SITE				= B.FROM_SITE
							AND S.TRANSPORT_MODE_LINE	= B.TRANSPORT_MODE_LINE
							AND S.B_yyyymmdd			= B.B_yyyymmdd
							AND S.yyyymmdd				= B.yyyymmdd
							AND S.yyyymm				= B.yyyymm
							AND S.ISO_WEEK				= B.ISO_WEEK
							AND S.BOD_ID				= B.BOD_ID
							--AND S.ATTRIBUTE9			= B.ATTRIBUTE9
							--AND S.ATTRIBUTE10			= B.ATTRIBUTE10
							--AND S.ATTRIBUTE3			= B.ATTRIBUTE3
			) F
			LEFT JOIN
				(
	--                SELECT DISTINCT
	--                          M.PROGRAM_ID
	--                        , M.SHEET_NAME
	--                        , M.COLUMN_NAME
	--                        , M.COLUMN_LABEL_NAME
	--                        , T.SORT_ORDER_NO
	--                        , 'GAP' AS MEASURE
							--, M.ATTRIBUTE9
							--, M.ATTRIBUTE10
							--, M.ATTRIBUTE3
	--                FROM    SCM_MST_SHEET_MEASURE M,
	--                        SCM_MST_TITLESET_USER T
	--                WHERE   1=1
	--                    AND M.PROGRAM_ID  = T.PROGRAM_ID
			 --           AND M.SHEET_NAME  = T.SHEET_NAME
	--                    AND M.COLUMN_NAME = 'GAP'
	--                    AND T.PROGRAM_ID  = @p_program_id
			 --           AND T.SHEET_NAME  = @p_sheet_name
					  --  AND T.USER_ID     = @p_user_id
					SELECT    M.PROGRAM_ID
							, M.SHEET_NAME
							, M.COLUMN_NAME
							, M.COLUMN_LABEL_NAME
							, T.SORT_ORDER_NO
							, 'GAP' AS MEASURE
							, M.ATTRIBUTE9
							, M.ATTRIBUTE10
							, M.ATTRIBUTE3
					FROM    SCM_MST_SHEET_MEASURE M,
							SCM_MST_TITLESET_USER T
					WHERE   1=1
						AND M.PROGRAM_ID  = T.PROGRAM_ID
						AND M.SHEET_NAME  = T.SHEET_NAME
						AND M.COLUMN_NAME = T.COLUMN_NAME
						AND M.COLUMN_NAME = 'GAP'
						AND T.PROGRAM_ID  = @p_program_id
						AND T.SHEET_NAME  = @p_sheet_name
						AND T.USER_ID     = @p_user_id

				) C ON F.MEASURE = C.MEASURE;
	--chaan end V1.5 VMI 안전재고설정 추가 - Measure가 없는 Gap용 가상행을 추가함(Safety Stock 행 복사후 Measure, ATTRIBUTE3-라인색상 등만 Gap용으로 변경)

	UPDATE  A
	SET	    WEEK_YN = 'Y'
	FROM	#TblDynamicPivot_SCP0094_FNL A
			JOIN (
					SELECT	  ISO_WEEK
							, PARTIAL_WEEK_NAME,
							MAX(BASIS_YYYYMMDD) AS YYYYMMDD
					FROM	[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
					WHERE	BASIS_YYYYMMDD >= @p_from_yyyymmdd
						AND BASIS_YYYYMMDD <= @p_to_yyyymmdd  -- 마지막 구간 오류 발생으로 1개월 더함
					GROUP BY ISO_WEEK, PARTIAL_WEEK_NAME
				 ) X ON
					RIGHT(A.YYYYMMDD,8) = X.YYYYMMDD
	   WHERE	MEASURE IN ('MODEL_INVENTORY', 'WH_IN_BALANCE', 'BALANCE', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS', 'SAFETY_STOCK', 'GAP')

	UPDATE  A
	SET	    MONTH_YN = 'Y'
	FROM	#TblDynamicPivot_SCP0094_FNL A
			JOIN (
					SELECT	  BASIS_YYYYMM
							, MAX(BASIS_YYYYMMDD) AS YYYYMMDD
					FROM	[SCM_SYS_CALENDAR_M] WITH(NOLOCK)
					WHERE	BASIS_YYYYMMDD >= @p_from_yyyymmdd
						AND BASIS_YYYYMMDD <= @p_to_yyyymmdd  -- 마지막 구간 오류 발생으로 1개월 더함
					GROUP BY BASIS_YYYYMM
				 ) X ON
					RIGHT(A.YYYYMMDD,8) = X.YYYYMMDD
	WHERE	MEASURE IN ('MODEL_INVENTORY', 'WH_IN_BALANCE', 'BALANCE', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS', 'SAFETY_STOCK', 'GAP');

--TESTING : OK
--select * from #TblDynamicPivot_SCP0094_FNL;return;

--2021/11/02 End UI 속도 개선
	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/
	BEGIN
		IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
			DROP TABLE #TempTable;

		-- SUM 컬럼 문자열 생성 begin
		DECLARE @mQry_SUM NVARCHAR(MAX) = N'';

		-- PIVOIT 대상 날짜문자열 생성

		SELECT	@mQry_SUM = @mQry_SUM + ',' +
			CASE
			    WHEN CHARINDEX('M_', YYYYMMDD) = 1 THEN
                ' SUM(
                        CASE
                            WHEN YYYYMM = RIGHT(''' + YYYYMMDD + ''', 6) AND MEASURE IN       (''MODEL_INVENTORY'', ''WH_IN_BALANCE'', ''BALANCE'', ''CHAR_AVAILABLE'', ''ACTIVATE_PROGRESS'', ''SAFETY_STOCK'', ''GAP'') AND MONTH_YN = ''Y''        THEN CONVERT(NUMERIC(15, 2), QTY)
				            WHEN YYYYMM = RIGHT(''' + YYYYMMDD + ''', 6) AND MEASURE NOT IN   (''MODEL_INVENTORY'', ''WH_IN_BALANCE'', ''BALANCE'', ''CHAR_AVAILABLE'', ''ACTIVATE_PROGRESS'', ''LINE_TOTAL_LOAD_ENGINE'', ''SAFETY_STOCK'', ''GAP'') THEN CONVERT(NUMERIC(15, 2), QTY)
                            ELSE 0
                        END
                     ) AS ' + YYYYMMDD
			    WHEN CHARINDEX('W_', YYYYMMDD) = 1 THEN
                ' SUM(
                        CASE
                            WHEN ISO_WEEK = RIGHT(''' + YYYYMMDD + ''', 6) AND MEASURE IN     (''MODEL_INVENTORY'', ''WH_IN_BALANCE'', ''BALANCE'', ''CHAR_AVAILABLE'', ''ACTIVATE_PROGRESS'', ''SAFETY_STOCK'', ''GAP'') AND WEEK_YN = ''Y''         THEN CONVERT(NUMERIC(15, 2), QTY)
				            WHEN ISO_WEEK = RIGHT(''' + YYYYMMDD + ''', 6) AND MEASURE NOT IN (''MODEL_INVENTORY'', ''WH_IN_BALANCE'', ''BALANCE'', ''CHAR_AVAILABLE'', ''ACTIVATE_PROGRESS'', ''LINE_TOTAL_LOAD_ENGINE'', ''SAFETY_STOCK'', ''GAP'') THEN CONVERT(NUMERIC(15, 2), QTY)
                            ELSE 0
                        END
                     ) AS ' + YYYYMMDD
			    WHEN CHARINDEX('D_', YYYYMMDD) = 1 THEN
                ' SUM(
                        CASE
                            WHEN YYYYMMDD = ''' + YYYYMMDD + ''' THEN QTY
                        END
                     ) AS ' + YYYYMMDD
		    END + '
                     '
		FROM	(
					SELECT    'W_'+A.BASIS_YYYYMM + A.ISO_WEEK                  AS YYYYMMDD
							, A.BASIS_START_DATE + CONVERT(CHAR(2), 21)         AS SORT_ORDER_NO
					FROM	[DBO].[SCM_SYS_CALENDAR_M] A
					WHERE	A.BASIS_YYYYMMDD BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
						AND (@p_bucket = 'DAILY' OR @p_bucket = 'WEEKLY' )
					GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
					UNION ALL
					SELECT	  'M_'+A.BASIS_YYYYMM                               AS YYYYMMDD
							, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01')  AS SORT_ORDER_NO
					FROM	[DBO].[SCM_SYS_CALENDAR_M] A
					WHERE	A.BASIS_YYYYMMDD  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
					GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
					UNION ALL
					SELECT	  'D_' + A.BASIS_YYYYMMDD                           AS YYYYMMDD
							, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31)           AS SORT_ORDER_NO
					FROM	[DBO].[SCM_SYS_CALENDAR_M] A
					WHERE	A.BASIS_YYYYMMDD  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
						AND @p_bucket= 'DAILY'
					GROUP BY A.BASIS_YYYYMMDD
				) AS A
		ORDER BY    SORT_ORDER_NO
		-- SUM 컬럼 문자열 생성 end

--TESTING : OK
--exec debug_log @mQry_SUM, 'T';return;



    DECLARE @mEXEC NVARCHAR(MAX)        = '';
		--2021/11/19 SQL튜닝 반영 DEL begin
		/*
		-- 주의 : 조회항목 변경 시 M_,W_,D_ 컬럼이 항상 뒤에 나와야함
		--        UI에서 합계계산 시 COLUMN COUNT INDEX 계산
		SET @mEXEC = @mEXEC + 'SELECT CASE WHEN A.BOD_ID=''-'' THEN ''-'' ELSE CONVERT(nvarchar(50), ('+CHAR(10);
		--SET @mEXEC = @mEXEC + '										CASE	WHEN ISNULL(l.segment3, '''') = '''' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)  '+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''A''            THEN 0'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''B''            THEN ISNULL(r.lt_departure_inland, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''C''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''D''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''E''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''F''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												ELSE                                     ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)'+CHAR(10);
		--SET @mEXEC = @mEXEC + '										END ) ) END AS LT_DAY'+CHAR(10);
		SET @mEXEC = @mEXEC + '		     B.lt_total )) END AS LT_DAY'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , isnull(NULLIF( A.CELL_QTY_PACK_T, '''') , ''-'') AS CELL_QTY_PACK'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , isnull(d.segment2,''-'') AS OPERATION_GROUP_NAME'+CHAR(10);
		SET @mEXEC = @mEXEC + '	       , ISNULL(H.DEPT_NAME_KO, ''-'') AS DEPT_NAME	                            '+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.*'+CHAR(10);


		--IF @p_division_id != 'EE'
		--BEGIN
		--    SET @mEXEC = @mEXEC + '        , CASE WHEN A.TO_SITE = ''-'' THEN '''''+CHAR(10);
		--    SET @mEXEC = @mEXEC + '          ELSE (SELECT TOP 1 BB.DEPT_NAME_KO FROM SCM_MST_SSO_USER_INFO AA WITH (NOLOCK) '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '                                           INNER JOIN SCM_MST_SSO_DEPT_INFO BB WITH (NOLOCK) ON AA.DEPT_ID = BB.DEPT_ID  '+CHAR(10);
		--	SET @mEXEC = @mEXEC + '                                           INNER JOIN SCM_MST_SITE_ITEM CC WITH (NOLOCK) ON AA.USER_ID = CC.OWNER        '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '               WHERE CC.ITEM_ID = A.ITEM_ID                                      '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '                 AND CC.DIVISION_ID = A.DIVISION_ID AND CC.SCM_SITE_ID = A.TO_SITE) END AS DEPT_NAME      '+CHAR(10);

		--END
		--ELSE BEGIN
		--    SET @mEXEC = @mEXEC + '        , CASE WHEN A.TO_SITE = ''-'' THEN '''''+CHAR(10);
		--    SET @mEXEC = @mEXEC + '          ELSE (SELECT TOP 1 BB.DEPT_NAME_KO FROM SCM_MST_SSO_USER_INFO AA WITH (NOLOCK) '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '                                     INNER JOIN SCM_MST_SSO_DEPT_INFO BB WITH (NOLOCK) ON AA.DEPT_ID = BB.DEPT_ID  '+CHAR(10);
		--	SET @mEXEC = @mEXEC + '                                     INNER JOIN SCM_MST_SITE_ITEM CC WITH (NOLOCK) ON AA.USER_ID = CC.OWNER        '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '               WHERE CC.ITEM_ID = A.ITEM_ID                                      '+CHAR(10);
  --          SET @mEXEC = @mEXEC + '                 AND CC.DIVISION_ID = A.DIVISION_ID AND CC.SCM_SITE_ID = A.TO_SITE2) END AS DEPT_NAME      '+CHAR(10);
		--END;

		--SET @mEXEC = @mEXEC + '        , G.DEPT_NAME_KO AS DEPT_NAME'+CHAR(10);

		SET @mEXEC = @mEXEC + ' FROM ('+CHAR(10);
		*/
		--2021/11/19 SQL튜닝 반영 DEL begin

		SET @mEXEC = @mEXEC + N'
			SELECT	  A.DIVISION_ID
					, A.OPERATION_GROUP
					, A.CELL_ITEM_ID
					, A.ITEM_ID
					, A.CELL_GROUP
					, (
						SELECT TOP 1
								(
									CASE
										WHEN X.NICK_NAME IS NULL THEN ''-''
										WHEN X.NICK_NAME = ''''  THEN ''-''
										ELSE X.NICK_NAME
									END
								)
						FROM	DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)
						WHERE	X.ITEM_ID  = A.ITEM_ID
							AND X.NICK_NAME IS NOT NULL
					  )                                                     AS NICK_NAME
					, CASE
						WHEN A.OPERATION_GROUP = ''A'' THEN ''-''
						ELSE (
								SELECT TOP 1
										CONVERT(NVARCHAR(50), CEILING(V.ACCUMULATED_CHILD_QTY))
								FROM	DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)
								WHERE	V.DIVISION_ID           = A.DIVISION_ID
									AND V.OPERATION_GROUP_ID    = ''A''
									AND V.MODEL_ID              = A.ITEM_ID AND V.CHILD_ITEM_ID=A.CELL_ITEM_ID
							 )
					  END                                                   AS CELL_QTY_PACK_T
					, A.TO_SITE
					, A.TO_SITE2
					, ISNULL(NULLIF((
										SELECT TOP 1
												M.SITE_DESCRIPTION
										FROM	SCM_MST_SITE M
										WHERE	M.SCM_SITE_ID=A.TO_SITE
									), '''') , ''-'')                       AS TO_SITE_DESCRIPTION
					, A.TO_BOH_QTY
					, A.FROM_BOH_QTY
					, ISNULL(NULLIF( A.INCOTERMS, '''') , ''-'') AS INCOTERMS
					, A.FROM_SITE
					, ISNULL(NULLIF((
										SELECT TOP 1
												M.SITE_DESCRIPTION
										FROM	SCM_MST_SITE M
										WHERE	M.SCM_SITE_ID = A.FROM_SITE
									), '''') , ''-'')                       AS FROM_SITE_DESCRIPTION
					, ISNULL(NULLIF(A.TRANSPORT_MODE_LINE, ''''), ''-'')    AS TRANSPORT_MODE_LINE
					, A.BOD_ID
					, A.ATTRIBUTE10
					, A.MEASURE
					, A.COLUMN_LABEL_NAME MEASURE_LABEL
					, A.SORT_ORDER_NO
					, A.ATTRIBUTE3 AS MEASURE_COLOR
					' + @mQry_SUM + N'
			INTO	#TempTable
			FROM	#TblDynamicPivot_SCP0094_FNL A WITH(NOLOCK)
			GROUP BY	  A.DIVISION_ID
		 				, A.OPERATION_GROUP
		 				, A.CELL_ITEM_ID
		 				, A.ITEM_ID
    					, A.CELL_GROUP
		 				, A.TO_SITE
		 				, A.TO_SITE2
		 				, A.TO_BOH_QTY
		 				, A.FROM_BOH_QTY
		 				, A.INCOTERMS
		 				, A.FROM_SITE
		 				, A.TRANSPORT_MODE_LINE
		 				, A.BOD_ID
		 				, A.ATTRIBUTE10
		 				, A.MEASURE
		 				, A.SORT_ORDER_NO
		 				, A.COLUMN_LABEL_NAME
		 				, A.ATTRIBUTE3
		OPTION (MAXDOP 16) ;
		-- 주의 : 조회항목 변경 시 M_,W_,D_ 컬럼이 항상 뒤에 나와야함
		SELECT	  CASE
					WHEN A.BOD_ID = ''-'' THEN ''-''
					ELSE CONVERT(NVARCHAR(50), (B.LT_TOTAL ))
				  END                                               AS LT_DAY
		        , ISNULL(NULLIF( A.CELL_QTY_PACK_T, '''') , ''-'')  AS CELL_QTY_PACK
		        , ISNULL(D.SEGMENT2,''-'')                          AS OPERATION_GROUP_NAME
  		        , ISNULL(H.DEPT_NAME_KO, ''-'')                     AS DEPT_NAME
		        , A.*
		FROM	#TempTable A
				LEFT MERGE JOIN SCP_ANL_BOD_N_V_PLAN_H B WITH(NOLOCK) ON --chaan Row size limit 에러 수정
						B.DIVISION_ID	= A.DIVISION_ID
					AND B.BOD_ID		= A.BOD_ID
					AND B.FROM_SITE		= A.FROM_SITE
					AND B.PLAN_NAME		= '''+@p_plan_start_yyyymmdd+'''
					AND B.PLAN_TYPE		= '''+@p_plan_type+'''
					AND B.PLAN_SEQ		= '''+@p_seq+'''
				 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D ON
						D.LOOKUP_TYPE   = ''OPERATION_GROUP''
					AND D.SEGMENT1      = A.OPERATION_GROUP
		/********** DEPT NAME START **********/
				LEFT MERGE JOIN SCM_MST_SITE E'

			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
			BEGIN
				SET @mEXEC = @mEXEC + N' ON
						E.DIVISION_ID	= A.DIVISION_ID
					AND E.SCM_SITE_ID	= A.TO_SITE'
			END
			ELSE
			BEGIN
				SET @mEXEC = @mEXEC + N' ON
						E.DIVISION_ID	= A.ORIGIN_TO_DIVISION_ID
					AND E.SCM_SITE_ID	= A.TO_SITE2'
			END

			SET @mEXEC = @mEXEC + N'
					AND E.VALID_YN       = ''Y''
				LEFT MERGE JOIN
					(
						SELECT	  *
								, ROW_NUMBER() OVER(PARTITION BY DIVISION_ID , SCM_SITE_ID ,ITEM_ID  ORDER BY PROJECT_CODE) AS RANK_NUMBER
						FROM	SCM_MST_SITE_ITEM
						WHERE	VALID_YN = ''Y''
				    ) F'

			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
			BEGIN
				SET @mEXEC = @mEXEC + N'	ON
						F.DIVISION_ID	= A.DIVISION_ID
					AND F.SCM_SITE_ID	= A.TO_SITE'
			END
			ELSE
			BEGIN
				SET @MEXEC = @MEXEC + N' ON
						F.DIVISION_ID	= A.ORIGIN_TO_DIVISION_ID
					AND F.SCM_SITE_ID	= A.TO_SITE2'
			END

			SET @MEXEC = @MEXEC + N'
					AND F.ITEM_ID		= A.ITEM_ID
					AND F.VALID_YN		=''Y''
					AND F.RANK_NUMBER   = 1  -- PROJECT_CODE 가 없어 1건만 가져오기 위해 처리
				LEFT MERGE JOIN [DBO].[SCM_MST_SSO_USER_INFO] G WITH(NOLOCK) ON
						SUBSTRING(F.OWNER, 0, CASE WHEN CHARINDEX('', '', F.OWNER) = 0 THEN LEN(F.OWNER) + 1 ELSE CHARINDEX('', '', F.OWNER) END) = G.USER_ID
				LEFT MERGE JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] H WITH(NOLOCK)'

			--IF @p_division_id NOT IN ('EE','EE_UC')
			IF @p_division_id NOT IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) --div_commonization
				SET @mEXEC = @mEXEC + N' ON
						CASE WHEN a.DIVISION_ID = ''40'' THEN G.DEPT_ID ELSE E.DEPT_ID END  = H.DEPT_ID'
			ELSE
				SET @mEXEC = @mEXEC + N' ON
						CASE WHEN a.origin_to_division_id = ''40'' THEN G.DEPT_ID ELSE E.DEPT_ID END  = H.DEPT_ID
			/********** DEPT NAME END **********/'

		-- 20220125 vadabi3 DC Link Sort 적용 (Rack_YN, DC_YN Sort 적용)
		SET @mEXEC = @mEXEC + N'
				LEFT MERGE JOIN SCM_MST_FINAL_ITEM_V V ON
						V.DIVISION_ID           = A.DIVISION_ID
					AND V.ITEM_ID               = A.ITEM_ID
					AND V.OPERATION_GROUP_ID    = A.OPERATION_GROUP
		ORDER BY      A.DIVISION_ID
                    , A.CELL_ITEM_ID
                    , A.OPERATION_GROUP DESC
                    , V.RACK_YN DESC
                    , V.DC_YN DESC
                    , A.ITEM_ID
                    , A.CELL_GROUP
                    , A.ATTRIBUTE10
                    , A.TO_SITE DESC
                    , A.INCOTERMS
                    , A.FROM_SITE
                    , A.SORT_ORDER_NO
                    , A.TRANSPORT_MODE_LINE
                    , A.BOD_ID
                    , A.MEASURE_LABEL DESC'


--TESTING : OK
--exec debug_log @mEXEC, 'T';return;
		EXEC (@mEXEC);

		PRINT 'Input Pivot set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END;


	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_NICKITEM') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_NICKITEM;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_RANK') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_RANK;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_ITEM') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_ITEM;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_CELL_GROUP') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_CELL_GROUP;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_MEASURE') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_MEASURE;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_TEMP') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_TEMP;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_RESULT') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_RESULT;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_LOAD') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_LOAD;
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0094_FNL') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0094_FNL;
	IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
		DROP TABLE #TempTable;
END



