

/*
 * Program ID   : SCP0038_GET_GLOBAL_PSI_SMALL
 * Description  : GLOBAL PSI(SMALL) 조회
 * Program History
 *===================================================================================================
 *   Date		In Charge	Description
 *===================================================================================================
 * 2018/11/29	hwyoon		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/12/04	hwyoon		Sorting 순서 수정(1차-P기준,2차-P,TCO기준)
 * 2019/02/21	hwyoon		[CSR ID:3931058] 화면 Measure 색상 변경 건
 * 2019/04/30	hwyoon		[CSR ID:3986877] 소형 Global PSI Design 변경 요청
 * 2019/06/25	hwyoon		[CSR ID:4018125] Global PSI(Small) 내 Packer 셀 재고 행 추가 요청 - ATTRIBUTE10 추가
 * 2019/06/27	hwyoon		[CSR ID:4023208] GSCM 시스템 개선 요청 - 라인가동율 산출로직 변경
 * 2019/10/21	hwyoon		오류수정 - 출하실적 조회 시 "삭제"수량 제외 r.EXFACTORY_STATUS IN ('D20','D30','D40')
 * 2019/11/21	hwwoon		오류수정 - 로드율 계산 시 라인 누락 오류 수정
 * 2019/12/12	hwyoon		UI Category 수정 - Operation Group 코드명 컬럼 추가 (Pack, Cell)
 * 2021/03/26	KSW  		PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 변경
 * 2021/04/06   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 변경 - 조회오류수정
 * 2021/05/13   khj79       [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 1단계 개발(LT_DAY 변경을 위한 scp_mst_bod_v 로 변경 )
 * 2021/06/08   khj79       [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 분기 제거(table 0 값 제거 완료)
 * 2021/07/15   khj79		[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : scp_mst_bod_v=> scp_mst_bod_n_v
 * 2022/04/29   chaan		81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2023/06/13   vadabi3		PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - [활성화] Final Item) Cell Type 기준 Sort 적용

 * EXEC SCP0038_GET_GLOBAL_PSI_SMALL_YHW @p_from_yyyymmdd='20181126',@p_to_yyyymmdd='20191124',@p_division_id='40'
									  ,@p_item_id='MCP2563H4A10,MPMGOO0A501C,MCP2982B1A10-M01',@p_nick_name='',@p_from_site='',@p_to_site=''
									  ,@p_plan_start_yyyymmdd='20181126',@p_plan_type='PR',@p_seq='1'
									  ,@p_program_id='SCP0038',@p_sheet_name='Global PSI',@p_user_id='hwwoonins',@debug_mode='T'
 */
CREATE PROCEDURE [dbo].[SCP0038_GET_GLOBAL_PSI_SMALL_NEW]
	@p_from_yyyymmdd			  NVARCHAR(8),
	@p_to_yyyymmdd				  NVARCHAR(8),
--chaan	@p_division_id          NVARCHAR(2)
   @p_division_id                  NVARCHAR(30),--chaan
	@p_item_id					    NVARCHAR(MAX) = '',
	@p_nick_name				    NVARCHAR(MAX) = '',
	@p_from_site				    NVARCHAR(MAX) = '',
	@p_to_site					    NVARCHAR(MAX) = '',
	@p_plan_start_yyyymmdd	NVARCHAR(8),
	@p_plan_type				    NVARCHAR(50),
	@p_seq						      NVARCHAR(50),
	@p_program_id				    NVARCHAR(MAX) = 'SCP0038',
	@p_sheet_name				    NVARCHAR(MAX) = 'Global PSI',
	@p_user_id					    NVARCHAR(MAX) = '',
	@debug_mode					    NVARCHAR(1)   = 'F'
AS

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------Start'
		print CONVERT(CHAR(23), getdate(), 21)
	END

	DECLARE @arr_from_site varchar(max) , @arr_to_site varchar(max);
	SELECT @arr_from_site   = ISNULL(@arr_from_site + ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_from_site,',')
	SELECT @arr_to_site     = ISNULL(@arr_to_site	+ ',''' + token +'''', ''''+token+'''') FROM dbo.String_Split(@p_to_site,',')


	DECLARE @v_cnt_usr_measure	nvarchar =0;
	SET @v_cnt_usr_measure = convert(nvarchar(50), ISNULL((
								SELECT COUNT(*)
								FROM scm_mst_titleset_user
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name
								 AND user_id     =  @p_user_id
							  ),0))


	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8)='';
	DECLARE @v_from_result       AS NVARCHAR(8)='';
	DECLARE @v_to_result         AS NVARCHAR(8)='';

	-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 변경 - start
	DECLARE @v_toway_result      AS NVARCHAR(8)='20210412';
	-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 변경 - end

	SELECT @v_from_yyyymmdd = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_plan_start_yyyymmdd

	SELECT @v_from_result = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_from_yyyymmdd;

	SELECT @v_to_result = C.BASIS_START_DATE
	FROM   [dbo].[SCM_SYS_CALENDAR_M]      C
	WHERE  1 = 1
	AND    C.BASIS_YYYYMMDD = @p_to_yyyymmdd;

	IF @v_from_yyyymmdd > @v_from_result
		BEGIN -- 실적 보여줌
		SET @v_to_yyyymmdd   = @p_to_yyyymmdd;
		SET @v_to_result     = @v_from_yyyymmdd;
		END;
	ELSE IF @v_from_yyyymmdd <= @v_from_result
		BEGIN -- 실적 없음
		SET @v_to_yyyymmdd   = @p_to_yyyymmdd;
		SET @v_from_result = CONVERT(CHAR(8), DATEADD(MM, 6, convert(datetime,@p_plan_start_yyyymmdd)), 112);
		SET @v_to_result = CONVERT(CHAR(8), DATEADD(MM, -6, convert(datetime,@p_plan_start_yyyymmdd)), 112)

		END;
	ELSE IF @v_from_yyyymmdd > @v_to_result
		BEGIN
		SET @v_from_yyyymmdd = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
		SET @v_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
		SET @v_from_result = @p_from_yyyymmdd;
		SET @v_to_result = @p_to_yyyymmdd;
		END;
	ELSE IF @v_from_yyyymmdd = @v_to_result
		BEGIN
		SET @v_to_yyyymmdd = @v_from_yyyymmdd
		SET @v_from_result = @p_from_yyyymmdd;
		SET @v_to_result = @p_to_yyyymmdd;
		END;

	IF @debug_mode ='T'
	BEGIN
		PRINT '----------------------------------';
		PRINT 'v_from_yyyymmdd =' +@v_from_yyyymmdd;
		PRINT 'v_to_yyyymmdd =' +@v_to_yyyymmdd;
		PRINT 'v_from_result =' +@v_from_result;
		PRINT 'v_to_result =' +@v_to_result	;
		PRINT '----------------------------------';
	END;


	/********************************************************************************
	 * 임시테이블만들기 - 조회조건 테이블
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_item') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_item;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_cellItem') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_cellItem;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_LINE_LOAD') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_LINE_LOAD;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_LINE') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_LINE;

	IF OBJECT_ID('tempdb..#tbl_ITEM_ID_Cell_Item_ID') IS NOT NULL
	DROP TABLE #tbl_ITEM_ID_Cell_Item_ID

	IF OBJECT_ID('tempdb..#PACK') IS NOT NULL
	DROP TABLE #PACK

	IF OBJECT_ID('tempdb..#TCOCELL') IS NOT NULL
	DROP TABLE #TCOCELL

	IF OBJECT_ID('tempdb..#CELL') IS NOT NULL
	DROP TABLE #CELL

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_item_order') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_item_order;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_NICKITEM') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_NICKITEM

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_RANK') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_RANK

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_MEASURE') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_MEASURE

	--생산실적, 출하실적 용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_RESULT') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_RESULT;

	--생산 로드율 주SUM, 월SUM
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_LINE_LOAD_BASE') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_LINE_LOAD_BASE;

	/* NICK NAME 조회조건으로 ITEM 추출 */
	SELECT distinct ITEM_ID
	INTO #TblDynamicPivot_SCP0038_NICKITEM
	FROM SCM_MST_ITEM_SN
	WHERE 1=1
	AND NICK_NAME IS NOT NULL
	AND ISNULL(@p_nick_name,'')!=''
	AND NICK_NAME LIKE @p_nick_name+'%'


	/* ITEM GROUP */
    SELECT DISTINCT A.ITEM_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP
	INTO #tbl_ITEM_ID_Cell_Item_ID
    FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK)
	--JOIN SCP_MST_FINAL_ITEM_V V WITH(NOLOCK) ON A.ITEM_ID=V.ITEM_ID
    WHERE A.DIVISION_ID         = @p_division_id
	    AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
	    AND A.PLAN_TYPE           = @p_plan_type
	    AND A.SEQ                 = @p_seq
		AND A.YYYYMMDD              >= @p_from_yyyymmdd
		AND A.YYYYMMDD              <= @p_to_yyyymmdd

	/* P */
	SELECT A.ITEM_ID, A.CELL_ITEM_ID, Y.Value, A.OPERATION_GROUP, RANK() OVER(ORDER BY A.ITEM_ID ASC) AS 'RANK'
	INTO #PACK
	FROM #tbl_ITEM_ID_Cell_Item_ID A WITH(NOLOCK)
	CROSS APPLY (  SELECT ID,VALUE
					        FROM dbo.FN_SplitString(A.CELL_ITEM_ID,',') )  Y
	WHERE A.OPERATION_GROUP = 'P'

	/*
	-- TCOCELL
	-- 20230613 SCP_MST_FINAL_ITEM_V.CELL_TYPE Sort 적용
	*/
	SELECT ITEM_ID, CELL_ITEM_ID
	      ,dbo.FN_GET_SCP_CELL_TYPE_SORT(CELL_TYPE) + RANK AS RANK
	INTO #TCOCELL
	FROM
	(
		SELECT A.ITEM_ID, A.CELL_ITEM_ID, V.CELL_TYPE
		    , ISNULL(B.RANK,RANK() OVER(ORDER BY  A.ITEM_ID ASC)) AS 'RANK'
		FROM #tbl_ITEM_ID_Cell_Item_ID A WITH(NOLOCK)
		LEFT JOIN  #PACK B ON B.Value = A.CELL_ITEM_ID
		JOIN SCP_MST_FINAL_ITEM_V V WITH(NOLOCK) ON V.ITEM_ID=A.ITEM_ID AND ISNULL(V.TCO_CELL_YN,'-')='Y'
		WHERE A.OPERATION_GROUP = 'A'
	) DATA




	/*
	-- C
	-- 20230613 SCP_MST_FINAL_ITEM_V.CELL_TYPE Sort 적용
	*/
	SELECT ITEM_ID, CELL_ITEM_ID, OPERATION_GROUP
	       ,dbo.FN_GET_SCP_CELL_TYPE_SORT(CELL_TYPE) + RANK AS RANK
	INTO #CELL
	FROM
	(
		SELECT A.ITEM_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP, V.CELL_TYPE
			 , ISNULL(ISNULL(T.RANK,B.RANK),99999) AS 'RANK'

		FROM #tbl_ITEM_ID_Cell_Item_ID A WITH(NOLOCK)
		LEFT JOIN  #PACK B ON B.Value = A.CELL_ITEM_ID
		LEFT JOIN  #TCOCELL T ON T.CELL_ITEM_ID = A.ITEM_ID
		JOIN SCP_MST_FINAL_ITEM_V V WITH(NOLOCK) ON V.ITEM_ID=A.ITEM_ID AND ISNULL(V.TCO_CELL_YN,'-')='N'
		WHERE A.OPERATION_GROUP = 'A'
	) DATA

	/* RANK */
	SELECT A.ITEM_ID, A.CELL_ITEM_ID, MAX(RANK) RANK
	INTO #TblDynamicPivot_SCP0038_item_order
	FROM (
		SELECT ITEM_ID, CELL_ITEM_ID, RANK
		FROM #PACK
		UNION ALL
		SELECT ITEM_ID, CELL_ITEM_ID, RANK
		FROM #TCOCELL
		UNION ALL
		SELECT ITEM_ID, CELL_ITEM_ID, RANK
		FROM #CELL
	) A
	GROUP BY A.ITEM_ID, A.CELL_ITEM_ID


	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------RANK'
		print CONVERT(CHAR(23), getdate(), 21)
	END


	/* 하위 Cell Item */
	SELECT Y.Value AS SUB_CELL_ITEM_ID
	INTO #TblDynamicPivot_SCP0038_cellItem
	FROM #TblDynamicPivot_SCP0038_item_order X WITH(NOLOCK)
	CROSS APPLY (  SELECT ID,VALUE
					FROM dbo.FN_SplitString(X.CELL_ITEM_ID,',') )  Y
	WHERE 1=1
	AND X.ITEM_ID IN ( SELECT value FROM dbo.FN_SplitString (@p_item_id,',') )
	AND ( (ISNULL(@p_nick_name,'')='')
		  OR
		  (X.ITEM_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0038_NICKITEM) )
		)
	GROUP BY Y.Value

	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------Cell Item'
		print CONVERT(CHAR(23), getdate(), 21)
	END


	/* PSI PACK/CELL, TCO/CELL, CELL/CELL 세트 */
	/*
	SELECT A.ITEM_ID, A.CELL_ITEM_ID, A.RANK
	INTO #TblDynamicPivot_SCP0038_item
	FROM #TblDynamicPivot_SCP0038_item_order A WITH(NOLOCK)
	CROSS APPLY (  SELECT ID,VALUE
					FROM dbo.FN_SplitString(A.CELL_ITEM_ID,',') )  Y
	JOIN #TblDynamicPivot_SCP0038_cellItem B ON Y.Value=B.SUB_CELL_ITEM_ID
	WHERE 1=1
	GROUP BY A.ITEM_ID, A.CELL_ITEM_ID, A.RANK
	*/
	SELECT A.ITEM_ID, A.CELL_ITEM_ID, A.RANK
			, (CASE WHEN V.OPERATION_GROUP='P' THEN 1
				   WHEN V.TCO_CELL_YN='Y'	 THEN 2
				   ELSE 3
			  END) AS RANK_DETAIL
	INTO #TblDynamicPivot_SCP0038_item
	FROM #TblDynamicPivot_SCP0038_item_order A WITH(NOLOCK)
	CROSS APPLY (  SELECT ID,VALUE
					FROM dbo.FN_SplitString(A.CELL_ITEM_ID,',') )  Y
	JOIN #TblDynamicPivot_SCP0038_cellItem B ON Y.Value=B.SUB_CELL_ITEM_ID
	LEFT JOIN SCP_MST_FINAL_ITEM_V V WITH(NOLOCK) ON V.ITEM_ID=A.ITEM_ID
	WHERE 1=1
	--AND Y.Value IN (SELECT SUB_CELL_ITEM_ID FROM #TblDynamicPivot_SCP0038_cellItem )
	GROUP BY A.ITEM_ID, A.CELL_ITEM_ID, A.RANK, V.OPERATION_GROUP, V.TCO_CELL_YN


	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------Item Set'
		print CONVERT(CHAR(23), getdate(), 21)
	END


	/* 유저 MEASURE 세팅값 추출 */ --로드율은 PRODUCTION과 동일한 SORT 값을 강제 셋팅
	SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME
			, CASE WHEN M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'	AND @v_cnt_usr_measure>0	THEN ISNULL( (SELECT T.SORT_ORDER_NO
																									FROM SCM_MST_TITLESET_USER T
																									WHERE T.PROGRAM_ID=M.program_id
																									AND T.SHEET_NAME=M.sheet_name
																									AND T.COLUMN_NAME='PRODUCTION'
																									AND T.USER_ID=U.user_id), U.SORT_ORDER_NO)
				   WHEN M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'	AND @v_cnt_usr_measure=0	THEN P.SORT_ORDER_NO
				   WHEN M.COLUMN_NAME='SHIP_PLAN'				AND @v_cnt_usr_measure>0	THEN ISNULL( (SELECT T.SORT_ORDER_NO
																									FROM SCM_MST_TITLESET_USER T
																									WHERE T.PROGRAM_ID=M.program_id
																									AND T.SHEET_NAME=M.sheet_name
																									AND T.COLUMN_NAME='SHIP_REQ'
																									AND T.USER_ID=U.user_id), U.SORT_ORDER_NO)
				   WHEN M.COLUMN_NAME='SHIP_PLAN'				AND @v_cnt_usr_measure=0	THEN S.SORT_ORDER_NO
				   ELSE ISNULL(U.sort_order_no, M.SORT_ORDER_NO)
			  END AS SORT_ORDER_NO
			  , M.ATTRIBUTE3 --MEASURE 별 COLOR RGB코드
	INTO #TblDynamicPivot_SCP0038_MEASURE
	FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
	LEFT JOIN SCM_MST_TITLESET_USER U ON U.program_id  = M.program_id AND U.sheet_name  = M.sheet_name
										AND U.column_name = M.column_name AND U.user_id = @p_user_id
	LEFT JOIN SCM_MST_SHEET_MEASURE P ON P.program_id  = M.program_id AND P.sheet_name  = M.sheet_name AND P.column_name = 'PRODUCTION'
	LEFT JOIN SCM_MST_SHEET_MEASURE S ON S.program_id  = M.program_id AND S.sheet_name  = M.sheet_name AND S.column_name = 'SHIP_REQ'
	WHERE M.PROGRAM_ID = @p_program_id
	AND M.VALID_YN='Y'
	and (@v_cnt_usr_measure=0 or ISNULL(U.SORT_ORDER_NO,0)>0)

	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------User Measure'
		print CONVERT(CHAR(23), getdate(), 21)
	END


	/********************************************************************************
	 * 임시테이블만들기 - 본 테이블
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038;

	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	DECLARE @mEXEC NVARCHAR(MAX);

	CREATE TABLE #TblDynamicPivot_SCP0038 (
		 DIVISION_ID		      NVARCHAR(60)
		,OPERATION_GROUP	    NVARCHAR(60)
		,CELL_ITEM_ID		      NVARCHAR(100)
		,ITEM_ID			        NVARCHAR(100)
		,TO_SITE			        NVARCHAR(60)
		,TO_BOH_QTY			      BIGINT
		,FROM_BOH_QTY		      BIGINT
		,INCOTERMS			      NVARCHAR(20)
		,FROM_SITE			      NVARCHAR(60)
		,TRANSPORT_MODE_LINE	NVARCHAR(100)
		,MEASURE			        NVARCHAR(100)
		,B_yyyymmdd			      NVARCHAR(10)
		,yyyymmdd			        NVARCHAR(10)
		,yyyymm				        NVARCHAR(6)
		,qty				          numeric(20,10)
		,iso_week			        INT
		,SORT_ORDER_NO		    INT
		,COLUMN_LABEL_NAME	  NVARCHAR(300)
		,BOD_ID				        NVARCHAR(300)
		,ATTRIBUTE9			      NVARCHAR(150)
		,RANK				          INT
		,RANK_DETAIL				INT
		,ATTRIBUTE3				NVARCHAR(30)
		,ATTRIBUTE2				NVARCHAR(150)
		,ATTRIBUTE10				NVARCHAR(1)
	);

	--생산/출하 실적 Temp Table
	CREATE TABLE #TblDynamicPivot_SCP0038_RESULT (
		 DIVISION_ID		      NVARCHAR(60)
		,OPERATION_GROUP	    NVARCHAR(60)
		,CELL_ITEM_ID		      NVARCHAR(100)
		,ITEM_ID			        NVARCHAR(100)
		,TO_SITE			        NVARCHAR(60)
		,TO_BOH_QTY			      BIGINT
		,FROM_BOH_QTY		      BIGINT
		,INCOTERMS			      NVARCHAR(20)
		,FROM_SITE			      NVARCHAR(60)
		,TRANSPORT_MODE_LINE	NVARCHAR(100)
		,MEASURE			        NVARCHAR(100)
		,SORT_ORDER_NO		    INT
		,COLUMN_LABEL_NAME	  NVARCHAR(300)
		,BOD_ID				        NVARCHAR(300)
		,ATTRIBUTE9			      NVARCHAR(150)
		,RANK				          INT
		,RANK_DETAIL				INT
		,ATTRIBUTE3				NVARCHAR(30)
		,ATTRIBUTE2				NVARCHAR(150)
		,ATTRIBUTE10				NVARCHAR(1)
	);


	SET @mEXEC = '';
	SET @mEXEC = @mEXEC + ' INSERT #TblDynamicPivot_SCP0038	 '+CHAR(10);

	-- KSW - 0값 제거 - start
	----SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID												'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.OPERATION_GROUP											'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.CELL_ITEM_ID											'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.ITEM_ID													'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, isnull(NULLIF(A.TO_SITE, '''') , ''-'') TO_SITE			'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.TO_BOH_QTY												'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.FROM_BOH_QTY											'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.INCOTERMS 												'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.FROM_SITE 												'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.TRANSPORT_MODE_LINE										'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.MEASURE													'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.yyyymmdd AS B_yyyymmdd									'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, ''D_''+ A.yyyymmdd AS yyyymmdd							'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, o.basis_yyyymm AS yyyymm									'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, isnull(qty,0) AS qty										'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week			'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, M.SORT_ORDER_NO											'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, M.COLUMN_LABEL_NAME										'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.BOD_ID													'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE9												'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, I.RANK													'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, I.RANK_DETAIL												'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, M.ATTRIBUTE3												'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, CASE WHEN A.MEASURE = ''ACTIVATE_PROGRESS'' THEN REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, A.ATTRIBUTE2) ,1) , ''.00'', '''')	'+CHAR(10);
	----SET @mEXEC = @mEXEC + '				   WHEN A.MEASURE = ''MODEL_INVENTORY'' THEN REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, A.ATTRIBUTE2) ,1) , ''.00'', '''')	'+CHAR(10);
	----SET @mEXEC = @mEXEC + '				   ELSE '' ''												'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			  END AS ATTRIBUTE2												'+CHAR(10);
	----SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE10													'+CHAR(10);
	----SET @mEXEC = @mEXEC + '	   FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)							'+CHAR(10);
	----SET @mEXEC = @mEXEC + '	   INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd				'+CHAR(10);
	----SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0038_MEASURE M (NOLOCK) ON M.COLUMN_NAME=A.MEASURE				'+CHAR(10);
	----SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0038_item I on A.CELL_ITEM_ID = I.CELL_ITEM_ID AND A.ITEM_ID=I.ITEM_ID				'+CHAR(10);
	----SET @mEXEC = @mEXEC + '	  WHERE A.DIVISION_ID			= '''+@p_division_id+'''				'+CHAR(10);
	----SET @mEXEC = @mEXEC + '		AND A.PLAN_START_YYYYMMDD	= '''+@p_plan_start_yyyymmdd+'''		'+CHAR(10);
	----SET @mEXEC = @mEXEC + '		AND A.PLAN_TYPE				= '''+@p_plan_type+'''					'+CHAR(10);
	----SET @mEXEC = @mEXEC + '		AND A.SEQ					= '+@p_seq+'							'+CHAR(10);
	----SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD >= '''+@p_from_yyyymmdd+'''							'+CHAR(10);
	----SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD <= '''+@p_to_yyyymmdd+'''							'+CHAR(10);
	------SET @mEXEC = @mEXEC+'     	AND ('+@v_cnt_usr_measure+' = 0 OR ISNULL(M.sort_order_no,0)>0) '+CHAR(10);


-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 변경 - start
-- 2021-06-08 : 분기 제거
--IF (CONVERT(CHAR(8), @v_toway_result, 112) <= CONVERT(CHAR(8), @p_plan_start_yyyymmdd, 112))
--BEGIN
--PRINT '-------------RESULT nozero after SEARCH'

	SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.OPERATION_GROUP											'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.CELL_ITEM_ID											'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ITEM_ID													'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, isnull(NULLIF(A.TO_SITE, '''') , ''-'') TO_SITE			'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.TO_BOH_QTY												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.FROM_BOH_QTY											'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.INCOTERMS 												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.FROM_SITE 												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.TRANSPORT_MODE_LINE										'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.MEASURE													'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.yyyymmdd AS B_yyyymmdd									'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, ''D_''+ A.yyyymmdd AS yyyymmdd							'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, o.basis_yyyymm AS yyyymm									'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, isnull(qty,0) AS qty										'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week			'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, M.SORT_ORDER_NO											'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, M.COLUMN_LABEL_NAME										'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.BOD_ID													'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE9												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, I.RANK													'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, I.RANK_DETAIL												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, M.ATTRIBUTE3												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, CASE WHEN A.MEASURE = ''ACTIVATE_PROGRESS'' THEN REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, A.ATTRIBUTE2) ,1) , ''.00'', '''')	'+CHAR(10);
	SET @mEXEC = @mEXEC + '				   WHEN A.MEASURE = ''MODEL_INVENTORY'' THEN REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, A.ATTRIBUTE2) ,1) , ''.00'', '''')	'+CHAR(10);
	SET @mEXEC = @mEXEC + '				   ELSE '' ''											'+CHAR(10);
	SET @mEXEC = @mEXEC + '			  END AS ATTRIBUTE2											'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE10												'+CHAR(10);
	--SET @mEXEC = @mEXEC + '	   FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)							'+CHAR(10);

	SET @mEXEC = @mEXEC + '	     FROM (SELECT A.DIVISION_ID										'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.PLAN_START_YYYYMMDD                                     '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.PLAN_TYPE                                               '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.SEQ                                                     '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.OPERATION_GROUP											'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.CELL_ITEM_ID											'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ITEM_ID													'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.TO_SITE        			                                '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.TO_BOH_QTY												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.FROM_BOH_QTY											'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.INCOTERMS 												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.FROM_SITE 												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.TRANSPORT_MODE_LINE										'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.MEASURE													'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.yyyymmdd          									    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.QTY          									        '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.BOD_ID													'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE2												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE9												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE10												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK)              '+CHAR(10);
	SET @mEXEC = @mEXEC + '	        INNER JOIN #TblDynamicPivot_SCP0038_item I on A.CELL_ITEM_ID = I.CELL_ITEM_ID AND A.ITEM_ID=I.ITEM_ID				'+CHAR(10);
	SET @mEXEC = @mEXEC + '          WHERE 1 = 1                                                '+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.DIVISION_ID         = '''+@p_division_id+'''				'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd+'''		'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.PLAN_TYPE           = '''+@p_plan_type+'''					'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.SEQ                 = '+@p_seq+'							'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.YYYYMMDD              >= '''+@p_plan_start_yyyymmdd+'''	'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.YYYYMMDD              <= '''+@p_to_yyyymmdd+'''			'+CHAR(10);
    SET @mEXEC = @mEXEC + '          UNION ALL                                                  '+CHAR(10);

	-- Line Load(%) 관련 Measure 를 위한 처리
	SET @mEXEC = @mEXEC + '          SELECT DISTINCT                '+CHAR(10);
    SET @mEXEC = @mEXEC + '            A.DIVISION_ID				'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.PLAN_START_YYYYMMDD        '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.PLAN_TYPE                  '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.SEQ                        '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.OPERATION_GROUP			'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.CELL_ITEM_ID									'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ITEM_ID										'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.TO_SITE        			'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.TO_BOH_QTY											'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.FROM_BOH_QTY											'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.INCOTERMS 												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.FROM_SITE 												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.TRANSPORT_MODE_LINE										'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.MEASURE													    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			 , B.BASIS_YYYYMMDD AS YYYYMMDD								'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , 0 AS QTY          									    '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.BOD_ID													'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE2												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE9												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE10                                            '+CHAR(10);
    SET @mEXEC = @mEXEC + '          FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK),         '+CHAR(10);
	SET @mEXEC = @mEXEC + '               (SELECT B.BASIS_YYYYMMDD                          '+CHAR(10);
	SET @mEXEC = @mEXEC + '                  FROM SCM_SYS_CALENDAR_M B (NOLOCK)             '+CHAR(10);
	SET @mEXEC = @mEXEC + '                 WHERE B.BASIS_YYYYMMDD BETWEEN '''+@p_plan_start_yyyymmdd+''' AND '''+@p_to_yyyymmdd+'''				'+CHAR(10);
	SET @mEXEC = @mEXEC + '               ) B                                               '+CHAR(10);
	SET @mEXEC = @mEXEC + '          WHERE 1 = 1                                                        '+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.DIVISION_ID         = '''+@p_division_id+'''				'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd+'''		'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.PLAN_TYPE           = '''+@p_plan_type+'''					'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.SEQ                 = '+@p_seq+'							'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.CELL_ITEM_ID in (SELECT CELL_ITEM_ID FROM #TblDynamicPivot_SCP0038_item)  '+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.YYYYMMDD              >= '''+@p_plan_start_yyyymmdd+'''							'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.YYYYMMDD              <= '''+@p_to_yyyymmdd+'''							'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.MEASURE               = ''PRODUCTION''                                     '+CHAR(10);
	SET @mEXEC = @mEXEC + '          UNION ALL                                                  '+CHAR(10);

	---- RTF(ALLOCATION), Balance Measure 를 위한 처리
	SET @mEXEC = @mEXEC + '          SELECT DISTINCT                '+CHAR(10);
    SET @mEXEC = @mEXEC + '            A.DIVISION_ID				'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.PLAN_START_YYYYMMDD        '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.PLAN_TYPE                  '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.SEQ                        '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.OPERATION_GROUP			'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.CELL_ITEM_ID									'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ITEM_ID										'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.TO_SITE        			'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.TO_BOH_QTY											'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.FROM_BOH_QTY											'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.INCOTERMS 												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.FROM_SITE 												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.TRANSPORT_MODE_LINE										'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , BB.COLUMN_NAME   AS MEASURE							    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			 , B.BASIS_YYYYMMDD AS YYYYMMDD								'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , 0 AS QTY          									    '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.BOD_ID													'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE2												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE9												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE10                                            '+CHAR(10);
    SET @mEXEC = @mEXEC + '          FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK),         '+CHAR(10);
	SET @mEXEC = @mEXEC + '               (SELECT B.BASIS_YYYYMMDD                          '+CHAR(10);
	SET @mEXEC = @mEXEC + '                  FROM SCM_SYS_CALENDAR_M B (NOLOCK)             '+CHAR(10);
	SET @mEXEC = @mEXEC + '                 WHERE B.BASIS_YYYYMMDD BETWEEN '''+@p_plan_start_yyyymmdd+''' AND '''+@p_to_yyyymmdd+'''				'+CHAR(10);
	SET @mEXEC = @mEXEC + '               ) B,                                                  '+CHAR(10);
	SET @mEXEC = @mEXEC + '                #TblDynamicPivot_SCP0038_MEASURE BB (NOLOCK)         '+CHAR(10);
	SET @mEXEC = @mEXEC + '          WHERE 1 = 1                                                        '+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.DIVISION_ID         = '''+@p_division_id+'''				'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd+'''		'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.PLAN_TYPE           = '''+@p_plan_type+'''					'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.SEQ                 = '+@p_seq+'							'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.CELL_ITEM_ID in (SELECT CELL_ITEM_ID FROM #TblDynamicPivot_SCP0038_item)  '+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.YYYYMMDD              >= '''+@p_plan_start_yyyymmdd+'''							'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.YYYYMMDD              <= '''+@p_to_yyyymmdd+'''							'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.MEASURE               = ''MKT_FCST''                                       '+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND BB.COLUMN_NAME IN (''ALLOCATION'', ''BALANCE'') '+CHAR(10);
	SET @mEXEC = @mEXEC + '          UNION ALL                                                  '+CHAR(10);

	---- WH_IN Measure 를 위한 처리
	SET @mEXEC = @mEXEC + '          SELECT DISTINCT                '+CHAR(10);
    SET @mEXEC = @mEXEC + '            A.DIVISION_ID				'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.PLAN_START_YYYYMMDD        '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.PLAN_TYPE                  '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.SEQ                        '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.OPERATION_GROUP			'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.CELL_ITEM_ID									'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ITEM_ID										'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.TO_SITE        			'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.TO_BOH_QTY											'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.FROM_BOH_QTY											'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.INCOTERMS 												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.FROM_SITE 												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , ''-'' AS TRANSPORT_MODE_LINE										'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , BB.COLUMN_NAME   AS MEASURE							    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			 , B.BASIS_YYYYMMDD AS YYYYMMDD								'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , 0 AS QTY          									    '+CHAR(10);
	SET @mEXEC = @mEXEC + '          , ''-'' AS BOD_ID													'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE2												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE9												'+CHAR(10);
	SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE10                                            '+CHAR(10);
    SET @mEXEC = @mEXEC + '          FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK),   '+CHAR(10);
	SET @mEXEC = @mEXEC + '               (SELECT B.BASIS_YYYYMMDD                          '+CHAR(10);
	SET @mEXEC = @mEXEC + '                  FROM SCM_SYS_CALENDAR_M B (NOLOCK)             '+CHAR(10);
	SET @mEXEC = @mEXEC + '                 WHERE B.BASIS_YYYYMMDD BETWEEN '''+@p_plan_start_yyyymmdd+''' AND '''+@p_to_yyyymmdd+'''				'+CHAR(10);
	--SET @mEXEC = @mEXEC + '                 WHERE B.BASIS_YYYYMMDD = '''+@p_from_yyyymmdd+'''           '+CHAR(10);
	SET @mEXEC = @mEXEC + '               ) B,                                                  '+CHAR(10);
	SET @mEXEC = @mEXEC + '                #TblDynamicPivot_SCP0038_MEASURE BB (NOLOCK)         '+CHAR(10);
	SET @mEXEC = @mEXEC + '          WHERE 1 = 1                                                        '+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.DIVISION_ID         = '''+@p_division_id+'''				'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd+'''		'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.PLAN_TYPE           = '''+@p_plan_type+'''					'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.SEQ                 = '+@p_seq+'							'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.CELL_ITEM_ID in (SELECT CELL_ITEM_ID FROM #TblDynamicPivot_SCP0038_item)  '+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.YYYYMMDD              >= '''+@p_plan_start_yyyymmdd+'''							'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.YYYYMMDD              <= '''+@p_to_yyyymmdd+'''							'+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND A.MEASURE               = ''SHIP_PLAN''                                        '+CHAR(10);
	SET @mEXEC = @mEXEC + '            AND BB.COLUMN_NAME IN (''WH_IN'')                               '+CHAR(10);
	--SET @mEXEC = @mEXEC + '          UNION ALL                                                  '+CHAR(10);

	-------- MKT_FCST Measure 를 위한 처리
	--SET @mEXEC = @mEXEC + '          SELECT DISTINCT                '+CHAR(10);
 --   SET @mEXEC = @mEXEC + '            A.DIVISION_ID				'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.PLAN_START_YYYYMMDD        '+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.PLAN_TYPE                  '+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.SEQ                        '+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.OPERATION_GROUP			'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.CELL_ITEM_ID									'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.ITEM_ID										'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.TO_SITE        			'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.TO_BOH_QTY											'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.FROM_BOH_QTY											'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.INCOTERMS 												'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.FROM_SITE 												'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.TRANSPORT_MODE_LINE										'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , BB.COLUMN_NAME   AS MEASURE							    '+CHAR(10);
	--SET @mEXEC = @mEXEC + '			 , B.BASIS_YYYYMMDD AS YYYYMMDD								'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , 0 AS QTY          									    '+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.BOD_ID													'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE2												'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE9												'+CHAR(10);
	--SET @mEXEC = @mEXEC + '          , A.ATTRIBUTE10                                            '+CHAR(10);
 --   SET @mEXEC = @mEXEC + '          FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK),   '+CHAR(10);
	--SET @mEXEC = @mEXEC + '               (SELECT B.BASIS_YYYYMMDD                          '+CHAR(10);
	--SET @mEXEC = @mEXEC + '                  FROM SCM_SYS_CALENDAR_M B (NOLOCK)             '+CHAR(10);
	--SET @mEXEC = @mEXEC + '                 WHERE B.BASIS_YYYYMMDD BETWEEN '''+@p_from_yyyymmdd+''' AND '''+@p_to_yyyymmdd+'''				'+CHAR(10);
	----SET @mEXEC = @mEXEC + '                 WHERE B.BASIS_YYYYMMDD = '''+@p_from_yyyymmdd+'''           '+CHAR(10);
	--SET @mEXEC = @mEXEC + '               ) B,                                                  '+CHAR(10);
	--SET @mEXEC = @mEXEC + '                #TblDynamicPivot_SCP0038_MEASURE BB (NOLOCK)         '+CHAR(10);
	--SET @mEXEC = @mEXEC + '          WHERE 1 = 1                                                        '+CHAR(10);
	--SET @mEXEC = @mEXEC + '            AND A.DIVISION_ID         = '''+@p_division_id+'''				'+CHAR(10);
	--SET @mEXEC = @mEXEC + '            AND A.PLAN_START_YYYYMMDD = '''+@p_plan_start_yyyymmdd+'''		'+CHAR(10);
	--SET @mEXEC = @mEXEC + '            AND A.PLAN_TYPE           = '''+@p_plan_type+'''					'+CHAR(10);
	--SET @mEXEC = @mEXEC + '            AND A.SEQ                 = '+@p_seq+'							'+CHAR(10);
	--SET @mEXEC = @mEXEC + '            AND A.CELL_ITEM_ID in (SELECT DISTINCT value FROM dbo.FN_SplitString('''+@p_item_id+''','',''))   '+CHAR(10);
	--SET @mEXEC = @mEXEC + '            AND A.YYYYMMDD              >= '''+@p_from_yyyymmdd+'''							'+CHAR(10);
	--SET @mEXEC = @mEXEC + '            AND A.YYYYMMDD              <= '''+@p_to_yyyymmdd+'''							'+CHAR(10);
	--SET @mEXEC = @mEXEC + '            AND A.MEASURE               = ''ALLOCATION  ''                                      '+CHAR(10);
	--SET @mEXEC = @mEXEC + '            AND BB.COLUMN_NAME IN (''MKT_FCST'')                               '+CHAR(10);
	--SET @mEXEC = @mEXEC + '          UNION ALL                                                  '+CHAR(10);

	---- Measure 구성요소 충족을 위한 쿼리
 --   SET @mEXEC = @mEXEC + '         SELECT                                                      '+CHAR(10);
	--SET @mEXEC = @mEXEC + '           '''+ @p_division_id + ''' AS DIVISION_ID					'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, '''+ @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD  '+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, '''+ @p_plan_type + ''' AS PLAN_TYPE                      '+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, '+@p_seq+' AS SEQ                                         '+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, ''A'' AS OPERATION_GROUP									'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, AA.CELL_ITEM_ID											'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, AA.ITEM_ID												'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, ''-'' AS TO_SITE        			                        '+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, 0 AS TO_BOH_QTY											'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, 0 AS FROM_BOH_QTY											'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, ''-'' AS INCOTERMS 										'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, ''-'' AS FROM_SITE 										'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, ''-'' AS TRANSPORT_MODE_LINE								'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, BB.COLUMN_NAME AS MEASURE									'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, '''+ @p_plan_start_yyyymmdd + ''' AS yyyymmdd          	'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, 0 AS QTY          									    '+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, ''-'' AS BOD_ID											'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, NULL AS ATTRIBUTE2										'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, NULL AS ATTRIBUTE9										'+CHAR(10);
	--SET @mEXEC = @mEXEC + '			, NULL AS ATTRIBUTE10										'+CHAR(10);
	--SET @mEXEC = @mEXEC + '           FROM #TblDynamicPivot_SCP0038_item AA (NOLOCK),           '+CHAR(10);
	--SET @mEXEC = @mEXEC + '                #TblDynamicPivot_SCP0038_MEASURE BB (NOLOCK)         '+CHAR(10);
	--SET @mEXEC = @mEXEC + '          WHERE 1 = 1                                                '+CHAR(10);
	--SET @mEXEC = @mEXEC + '            AND NOT BB.COLUMN_NAME IN (SELECT DISTINCT MEASURE       '+CHAR(10);
	--SET @mEXEC = @mEXEC + '         		FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK)   '+CHAR(10);
	--SET @mEXEC = @mEXEC + '         		WHERE A.DIVISION_ID         = '''+@p_division_id+'''				'+CHAR(10);
	--SET @mEXEC = @mEXEC + '         			AND A.PLAN_START_YYYYMMDD ='''+@p_plan_start_yyyymmdd+'''		'+CHAR(10);
	--SET @mEXEC = @mEXEC + '         			AND A.PLAN_TYPE           = '''+@p_plan_type+'''				'+CHAR(10);
	--SET @mEXEC = @mEXEC + '         			AND A.SEQ                 = '+@p_seq+'							'+CHAR(10);
	--SET @mEXEC = @mEXEC + '         			AND A.ITEM_ID = AA.ITEM_ID                                      '+CHAR(10);
	--SET @mEXEC = @mEXEC + '         			AND A.YYYYMMDD              >= '''+@p_from_yyyymmdd+'''			'+CHAR(10);
	--SET @mEXEC = @mEXEC + '         			AND A.YYYYMMDD              <= '''+@p_to_yyyymmdd+'''			'+CHAR(10);
	--SET @mEXEC = @mEXEC + '         	   )    '+CHAR(10);
	--SET @mEXEC = @mEXEC + '            AND NOT BB.COLUMN_NAME IN (''WH_IN_BALANCE'', ''LINE_TOTAL_LOAD_ENGINE'', ''CHAR_AVAILABLE'', ''ACTIVATE_PROGRESS'', ''ACTIVATE_COMPLETED'', ''ALLOCATION'', ''BALANCE'') '+CHAR(10);
	SET @mEXEC = @mEXEC + '            ) A							                                            '+CHAR(10);
	--SET @mEXEC = @mEXEC + '	   INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd				'+CHAR(10);

	SET @mEXEC = @mEXEC + '    INNER JOIN (SELECT B.BASIS_YYYYMMDD, B.basis_yyyymm, B.iso_week                          '+CHAR(10);
	SET @mEXEC = @mEXEC + '                  FROM SCM_SYS_CALENDAR_M B (NOLOCK)             '+CHAR(10);
	SET @mEXEC = @mEXEC + '                 WHERE B.BASIS_YYYYMMDD BETWEEN '''+@p_plan_start_yyyymmdd+''' AND '''+@p_to_yyyymmdd+'''				'+CHAR(10);
	SET @mEXEC = @mEXEC + '               ) o on A.yyyymmdd = o.basis_yyyymmdd                                          '+CHAR(10);

	SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0038_MEASURE M (NOLOCK) ON M.COLUMN_NAME=A.MEASURE		'+CHAR(10);
	SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0038_item I on A.CELL_ITEM_ID = I.CELL_ITEM_ID AND A.ITEM_ID=I.ITEM_ID				'+CHAR(10);
	SET @mEXEC = @mEXEC + '	  WHERE A.DIVISION_ID			= '''+@p_division_id+'''				'+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.PLAN_START_YYYYMMDD	= '''+@p_plan_start_yyyymmdd+'''		'+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.PLAN_TYPE				= '''+@p_plan_type+'''					'+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.SEQ					= '+@p_seq+'							'+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD >= '''+@p_plan_start_yyyymmdd+'''							'+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD <= '''+@p_to_yyyymmdd+'''							'+CHAR(10);

--END;
--ELSE
--BEGIN
--	SET @mEXEC = '';
--	SET @mEXEC = @mEXEC + ' INSERT #TblDynamicPivot_SCP0038	 '+CHAR(10);
--	SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID												'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.OPERATION_GROUP											'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.CELL_ITEM_ID											'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.ITEM_ID													'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, isnull(NULLIF(A.TO_SITE, '''') , ''-'') TO_SITE			'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.TO_BOH_QTY												'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.FROM_BOH_QTY											'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.INCOTERMS 												'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.FROM_SITE 												'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.TRANSPORT_MODE_LINE										'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.MEASURE													'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.yyyymmdd AS B_yyyymmdd									'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, ''D_''+ A.yyyymmdd AS yyyymmdd							'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, o.basis_yyyymm AS yyyymm									'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, isnull(qty,0) AS qty										'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, RIGHT(o.basis_yyyymm, 4)+o.iso_week AS iso_week			'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, M.SORT_ORDER_NO											'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, M.COLUMN_LABEL_NAME										'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.BOD_ID													'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE9												'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, I.RANK													'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, I.RANK_DETAIL												'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, M.ATTRIBUTE3												'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, CASE WHEN A.MEASURE = ''ACTIVATE_PROGRESS'' THEN REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, A.ATTRIBUTE2) ,1) , ''.00'', '''')	'+CHAR(10);
--	SET @mEXEC = @mEXEC + '				   WHEN A.MEASURE = ''MODEL_INVENTORY'' THEN REPLACE(CONVERT(VARCHAR, CONVERT(MONEY, A.ATTRIBUTE2) ,1) , ''.00'', '''')	'+CHAR(10);
--	SET @mEXEC = @mEXEC + '				   ELSE '' ''												'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			  END AS ATTRIBUTE2												'+CHAR(10);
--	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE10													'+CHAR(10);
--	SET @mEXEC = @mEXEC + '	   FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)							'+CHAR(10);
--	SET @mEXEC = @mEXEC + '	   INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o on A.yyyymmdd = o.basis_yyyymmdd				'+CHAR(10);
--	SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0038_MEASURE M (NOLOCK) ON M.COLUMN_NAME=A.MEASURE				'+CHAR(10);
--	SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0038_item I on A.CELL_ITEM_ID = I.CELL_ITEM_ID AND A.ITEM_ID=I.ITEM_ID				'+CHAR(10);
--	SET @mEXEC = @mEXEC + '	  WHERE A.DIVISION_ID			= '''+@p_division_id+'''				'+CHAR(10);
--	SET @mEXEC = @mEXEC + '		AND A.PLAN_START_YYYYMMDD	= '''+@p_plan_start_yyyymmdd+'''		'+CHAR(10);
--	SET @mEXEC = @mEXEC + '		AND A.PLAN_TYPE				= '''+@p_plan_type+'''					'+CHAR(10);
--	SET @mEXEC = @mEXEC + '		AND A.SEQ					= '+@p_seq+'							'+CHAR(10);
--	SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD >= '''+@p_from_yyyymmdd+'''							'+CHAR(10);
--	SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD <= '''+@p_to_yyyymmdd+'''							'+CHAR(10);
--END;
-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 변경 - end

	IF NOT(@p_from_site IS NULL	OR  @p_from_site	='') BEGIN SET @mEXEC = @mEXEC+'   	AND A.FROM_SITE     IN ('+@arr_from_site+') 				'+CHAR(10); END;
	IF NOT(@p_to_site	  IS NULL	OR  @p_to_site		='') BEGIN SET @mEXEC = @mEXEC+'   	AND A.TO_SITE       IN ('+@arr_to_site+') 					'+CHAR(10); END;


	-----------------------------------------------------------
	-- DEBUG QRY 출력
	-----------------------------------------------------------
	IF( @debug_mode ='T')
		BEGIN
			DECLARE @POS INT =1;
			DECLARE @LEN INT =LEN(@mEXEC);
			WHILE @POS <= @LEN
				BEGIN
					PRINT SUBSTRING(@mEXEC,@POS,4000);
					SET @POS = @POS+4000;
				END;
		END;

	EXEC (@mEXEC);


	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------DataSearch'
		print CONVERT(CHAR(23), getdate(), 21)
	END


	/* LINE */
	SELECT DISTINCT A.TRANSPORT_MODE_LINE
	INTO #TblDynamicPivot_SCP0038_LINE
	FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK)
	LEFT JOIN SCM_MST_SITE S WITH(NOLOCK) ON S.SITE_TYPE='PLANT' AND S.SCM_SITE_ID=A.TRANSPORT_MODE_LINE
	WHERE A.DIVISION_ID         = @p_division_id
		AND A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND A.PLAN_TYPE           = @p_plan_type
		AND A.SEQ                 = @p_seq
		AND A.YYYYMMDD             >= @p_from_yyyymmdd
		AND A.YYYYMMDD             <= @p_to_yyyymmdd
		AND A.MEASURE				= 'PRODUCTION'
		AND S.SITE_DESCRIPTION IS NULL
		--AND ISNULL(NULLIF(TRANSPORT_MODE_LINE,''),'-')!='-'
		AND NULLIF(A.TRANSPORT_MODE_LINE,'') NOT IN (SELECT SEGMENT1
															FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
															WHERE LOOKUP_TYPE='TRANSPORT_MODE_CODE'
															AND VALID_YN='Y')
	/*
	SELECT DISTINCT TRANSPORT_MODE_LINE
	INTO #TblDynamicPivot_SCP0038_LINE
    FROM SCP_ANL_PSI_GLOBAL_SMALL WITH (NOLOCK)
    WHERE DIVISION_ID         = @p_division_id
	    AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
	    AND PLAN_TYPE           = @p_plan_type
	    AND SEQ                 = @p_seq
		AND YYYYMMDD             >= @p_from_yyyymmdd
		AND YYYYMMDD             <= @p_to_yyyymmdd
		--AND ISNULL(NULLIF(TRANSPORT_MODE_LINE,''),'-')!='-'
		AND NULLIF(TRANSPORT_MODE_LINE,'') NOT IN (SELECT SEGMENT1
															FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
															WHERE LOOKUP_TYPE='TRANSPORT_MODE_CODE'
															AND VALID_YN='Y')*/

	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------Line Search'
		print CONVERT(CHAR(23), getdate(), 21)
	END


	/********************************************************************************
	* 1. Line Load(%) Temp
	********************************************************************************/
	SELECT A.DIVISION_ID
		, A.OPERATION_GROUP
		, A.FROM_SITE
		, A.ATTRIBUTE9
		, A.TRANSPORT_MODE_LINE
		, round(sum(a.qty * (e.tact_time/60)),0) AS SUM_LOAD_QTY
		, CASE WHEN d.working_time <= 0.0 THEN 0
				ELSE ISNULL( ( ( round(sum(a.qty * (e.tact_time/60)),0) / d.working_time ) ) ,0 ) *100
			END AS qty
		, d.working_time
		, A.yyyymmdd AS B_yyyymmdd
		, o.basis_yyyymm AS yyyymm
		, o.iso_week
		, 'W_'+o.basis_yyyymm + o.iso_week AS week_yyyymmdd
		, 'M_'+o.basis_yyyymm  AS month_yyyymmdd
    INTO #TblDynamicPivot_SCP0038_LINE_LOAD
    FROM SCP_ANL_PSI_GLOBAL_SMALL A WITH(NOLOCK)
    INNER JOIN SCM_SYS_CALENDAR_M (NOLOCK) o
            on A.yyyymmdd     = o.basis_yyyymmdd
    INNER JOIN SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
            ON M.PROGRAM_ID   = @p_program_id
           AND M.COLUMN_NAME  = A.MEASURE
    LEFT OUTER JOIN scp_anl_working_time d WITH(NOLOCK)
            ON a.division_id  = d.division_id
           and a.ATTRIBUTE9   = d.operation_id
           and a.FROM_SITE    = d.scm_site_id
					 and a.TRANSPORT_MODE_LINE = d.line_id
					 and a.yyyymmdd     = d.yyyymmdd
    LEFT OUTER JOIN scp_anl_tact_time e WITH(NOLOCK)
           ON a.division_id   = e.division_id
          and a.ATTRIBUTE9    = e.operation_id
					and a.FROM_SITE     = e.scm_site_id
				  and a.TRANSPORT_MODE_LINE = e.line_id
					and A.ITEM_ID       = e.item_id
					and a.yyyymmdd      = e.yyyymmdd
  WHERE A.DIVISION_ID			    = @p_division_id
	AND A.PLAN_START_YYYYMMDD	  = @p_plan_start_yyyymmdd
	AND A.PLAN_TYPE				      = @p_plan_type
	AND A.SEQ					          = @p_seq
	AND A.YYYYMMDD             >= @p_from_yyyymmdd
	AND A.YYYYMMDD             <= @p_to_yyyymmdd
	AND a.MEASURE               = 'PRODUCTION'
	AND A.TRANSPORT_MODE_LINE IN (SELECT TRANSPORT_MODE_LINE FROM #TblDynamicPivot_SCP0038_LINE)
  GROUP BY a.division_id, a.operation_group ,a.FROM_SITE ,a.ATTRIBUTE9 ,a.TRANSPORT_MODE_LINE, a.yyyymmdd,o.basis_yyyymm,o.iso_week, d.working_time
  ;

	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------Line Load Search'
		print CONVERT(CHAR(23), getdate(), 21)
	END



	/********************************************************************************
	* 2. 과거 실적구간 temp
	********************************************************************************/
	IF(@v_from_result<@v_to_result)
	BEGIN
		INSERT INTO #TblDynamicPivot_SCP0038_RESULT
		SELECT DISTINCT
				 A.DIVISION_ID
				,A.OPERATION_GROUP
				,A.CELL_ITEM_ID
				,A.ITEM_ID
				,A.TO_SITE
				,A.TO_BOH_QTY
				,A.FROM_BOH_QTY
				,A.INCOTERMS
				,A.FROM_SITE
				,A.TRANSPORT_MODE_LINE
				,A.MEASURE
				,A.SORT_ORDER_NO
				,A.COLUMN_LABEL_NAME
				,A.BOD_ID
				,A.ATTRIBUTE9
				,A.RANK
				,A.RANK_DETAIL
				,A.ATTRIBUTE3
				,A.ATTRIBUTE2
				,A.ATTRIBUTE10
		FROM #TblDynamicPivot_SCP0038 A WITH(NOLOCK)
		WHERE A.MEASURE IN ('PRODUCTION','SHIP_PLAN','ALLOCATION')
		;

		PRINT 'Search Prev Result set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END;


	-- Line Load(%) Insert
	/*
	INSERT INTO #TblDynamicPivot_SCP0038
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
		   , M.sort_order_no
		   , M.COLUMN_LABEL_NAME
		   , A.BOD_ID
		   , A.ATTRIBUTE9
		   , A.RANK
		   , A.RANK_DETAIL
		   , M.ATTRIBUTE3
		   , ' ' AS ATTRIBUTE2
	FROM #TblDynamicPivot_SCP0038 A WITH(NOLOCK)
	JOIN #TblDynamicPivot_SCP0038_LINE_LOAD B WITH(NOLOCK)
		ON A.DIVISION_ID=B.DIVISION_ID
		AND A.OPERATION_GROUP     = B.OPERATION_GROUP
		AND A.FROM_SITE           = B.FROM_SITE
		AND A.ATTRIBUTE9          = B.ATTRIBUTE9
		AND A.TRANSPORT_MODE_LINE = B.TRANSPORT_MODE_LINE
		AND A.B_yyyymmdd          = B.B_yyyymmdd
	INNER JOIN #TblDynamicPivot_SCP0038_MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'
	;
	*/

	-- Line Load(%) Base
	SELECT DISTINCT A.DIVISION_ID
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
		   , M.sort_order_no
		   , M.COLUMN_LABEL_NAME
		   , A.BOD_ID
		   , A.ATTRIBUTE9
		   , A.RANK
		   , A.RANK_DETAIL
		   , M.ATTRIBUTE3
		   , ' ' AS ATTRIBUTE2
		   , B.SUM_LOAD_QTY
		   , B.working_time
		   , B.week_yyyymmdd
		   , B.month_yyyymmdd
		   , A.ATTRIBUTE10
	INTO #TblDynamicPivot_SCP0038_LINE_LOAD_BASE
	FROM #TblDynamicPivot_SCP0038 A WITH(NOLOCK)
	INNER JOIN #TblDynamicPivot_SCP0038_LINE_LOAD B WITH(NOLOCK)
		ON A.DIVISION_ID=B.DIVISION_ID
		AND A.OPERATION_GROUP     = B.OPERATION_GROUP
		AND A.FROM_SITE           = B.FROM_SITE
		AND A.ATTRIBUTE9          = B.ATTRIBUTE9
		AND A.TRANSPORT_MODE_LINE = B.TRANSPORT_MODE_LINE
		AND A.B_yyyymmdd          = B.B_yyyymmdd
		AND A.MEASURE			  = 'PRODUCTION'
	INNER JOIN #TblDynamicPivot_SCP0038_MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'
	;


	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------Line Load Base'
		print CONVERT(CHAR(23), getdate(), 21)
	END


	-- Line Load(%) Daily Insert
	INSERT INTO #TblDynamicPivot_SCP0038
	SELECT DIVISION_ID
		   , OPERATION_GROUP
		   , CELL_ITEM_ID
		   , ITEM_ID
		   , TO_SITE
		   , TO_BOH_QTY
		   , FROM_BOH_QTY
		   , INCOTERMS
		   , FROM_SITE
		   , TRANSPORT_MODE_LINE
		   , 'LINE_TOTAL_LOAD_ENGINE' MEASURE
		   , B_yyyymmdd
		   , yyyymmdd
		   , yyyymm
		   , qty
		   , iso_week
		   , sort_order_no
		   , COLUMN_LABEL_NAME
		   , BOD_ID
		   , ATTRIBUTE9
		   , RANK
		   , RANK_DETAIL
		   , ATTRIBUTE3
		   , ATTRIBUTE2
		   , ATTRIBUTE10
	FROM #TblDynamicPivot_SCP0038_LINE_LOAD_BASE A WITH(NOLOCK)
	;


	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------Line Load Daily Add'
		print CONVERT(CHAR(23), getdate(), 21)
	END


	--select * from #TblDynamicPivot_SCP0038_LINE_LOAD_BASE

	-- Line Load(%) Week Sum Insert
	INSERT INTO #TblDynamicPivot_SCP0038
	SELECT DIVISION_ID
		   , OPERATION_GROUP
		   , CELL_ITEM_ID
		   , ITEM_ID
		   , TO_SITE
		   , TO_BOH_QTY
		   , FROM_BOH_QTY
		   , INCOTERMS
		   , FROM_SITE
		   , TRANSPORT_MODE_LINE
		   , 'LINE_TOTAL_LOAD_ENGINE' MEASURE
		   , '-' AS B_yyyymmdd
		   , week_yyyymmdd AS yyyymmdd
		   , '-' AS yyyymm
		   , CASE WHEN SUM(working_time) <= 0.0 THEN 0
				ELSE ISNULL( ( SUM(SUM_LOAD_QTY) / SUM(working_time) ) ,0 ) *100
			  END AS qty
		   , '-' AS iso_week
		   , sort_order_no
		   , COLUMN_LABEL_NAME
		   , BOD_ID
		   , ATTRIBUTE9
		   , RANK
		   , RANK_DETAIL
		   , ATTRIBUTE3
		   , ATTRIBUTE2
		   , ATTRIBUTE10
	FROM #TblDynamicPivot_SCP0038_LINE_LOAD_BASE
	GROUP BY DIVISION_ID
			 , OPERATION_GROUP
			 , CELL_ITEM_ID
			 , ITEM_ID
			 , TO_SITE
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
			 , RANK
			 , RANK_DETAIL
			 , ATTRIBUTE3
			 , ATTRIBUTE2
			 , ATTRIBUTE10
			 , WEEK_YYYYMMDD
			 , MONTH_YYYYMMDD

	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------Line Load Week Add'
		print CONVERT(CHAR(23), getdate(), 21)
	END



	-- Line Load(%) Month Sum Insert
	INSERT INTO #TblDynamicPivot_SCP0038
	SELECT DIVISION_ID
		   , OPERATION_GROUP
		   , CELL_ITEM_ID
		   , ITEM_ID
		   , TO_SITE
		   , TO_BOH_QTY
		   , FROM_BOH_QTY
		   , INCOTERMS
		   , FROM_SITE
		   , TRANSPORT_MODE_LINE
		   , 'LINE_TOTAL_LOAD_ENGINE' MEASURE
		   , '-' AS B_yyyymmdd
		   , MONTH_YYYYMMDD AS yyyymmdd
		   , '-' AS yyyymm
		   , CASE WHEN SUM(working_time) <= 0.0 THEN 0
				ELSE ISNULL( ( SUM(SUM_LOAD_QTY) / SUM(working_time) ) ,0 ) *100
			  END AS qty
		   , '-' AS iso_week
		   , sort_order_no
		   , COLUMN_LABEL_NAME
		   , BOD_ID
		   , ATTRIBUTE9
		   , RANK
		   , RANK_DETAIL
		   , ATTRIBUTE3
		   , ATTRIBUTE2
		   , ATTRIBUTE10
	FROM #TblDynamicPivot_SCP0038_LINE_LOAD_BASE
	GROUP BY DIVISION_ID
			 , OPERATION_GROUP
			 , CELL_ITEM_ID
			 , ITEM_ID
			 , TO_SITE
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
			 , RANK
			 , RANK_DETAIL
			 , ATTRIBUTE3
			 , ATTRIBUTE2
			 , ATTRIBUTE10
			 , MONTH_YYYYMMDD

	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------Line Load Month Add'
		print CONVERT(CHAR(23), getdate(), 21)
	END


	-- 생산/출하/매출 실적 insert
	IF(@v_from_result<@v_to_result)
	BEGIN
		-- 1. 생산실적 insert
		INSERT INTO #TblDynamicPivot_SCP0038
		SELECT  distinct
			r.division_id
		   	,a.operation_group
			,a.cell_item_id
			,a.item_id
			,a.to_site
			,a.to_boh_qty
			,a.from_boh_qty
			,a.incoterms
			,a.from_site
			,a.transport_mode_line
			,a.measure
			,convert(nvarchar(8), r.plan_date,112) AS B_yyyymmdd
			,'D_'+convert(nvarchar(8), r.plan_date,112)  AS yyyymmdd
			,c.basis_yyyymm AS yyyymm
			,r.actual_good_qty AS qty
			,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
			,a.sort_order_no
			,a.column_label_name
			,a.bod_id
			,a.attribute9
			,a.rank
			,a.rank_detail
			,a.attribute3
			,a.attribute2
			,a.attribute10
		FROM SCM_DNM_product_result_v r
		JOIN scm_sys_calendar_m c on convert(nvarchar(8), r.plan_date,112)  = c.basis_yyyymmdd
		LEFT OUTER JOIN SCP_MST_FINAL_ITEM b on r.division_id = b.division_id and r.item_id = b.item_id and r.scp_operation_group = b.operation_group
		JOIN #TblDynamicPivot_SCP0038_RESULT A WITH(NOLOCK) ON A.MEASURE='PRODUCTION'
															AND A.DIVISION_ID=R.DIVISION_ID
															AND A.OPERATION_GROUP=R.scp_operation_group
															AND A.FROM_SITE=R.SCM_SITE_ID
															AND A.ITEM_ID=R.ITEM_ID
															AND A.ATTRIBUTE9=R.OPERATION_ID
															AND A.TRANSPORT_MODE_LINE=R.LINE_ID
		WHERE 1=1
			AND r.plan_date          >= convert(datetime, @v_from_result)
			AND r.plan_date          < convert(datetime, @v_to_result )
			AND r.division_id = @p_division_id
			AND r.scp_operation_group IN ('A','P')
			AND ( LEFT(r.operation_id,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
											SELECT segment1 AS operation_id
												FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
											WHERE lookup_type = 'SCP_PLAN_OPERATION'
												AND SEGMENT1 <> 'F6000'
												AND valid_yn    = 'Y')
                -- ISUZU item
                OR (
                    LEFT(r.operation_id,5) = 'P5000'
                    AND EXISTS (
                                SELECT 1
                                FROM dbo.SCM_MST_FINAL_ITEM_V A1 WITH(NOLOCK)
                                INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B1 WITH(NOLOCK) ON A1.ITEM_ID = B1.ITEM_ID
                                WHERE A1.ITEM_ID = r.ITEM_ID
                                  AND A1.IS_YN = 'Y'
                                )
				   )
				OR r.operation_id IN (--외주PACKER의 업체코드
											SELECT plant_id  AS operation_id
											FROM SCM_MST_SITE WITH(NOLOCK)
											WHERE 1=1
											AND division_id = @p_division_id
											AND site_type   = 'PLANT'
											AND osp_yn      = 'Y'
											AND valid_yn    = 'Y'
											) )
		;


	IF @debug_mode ='T'
	BEGIN
		PRINT 'Input Supply set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END
		

		-- 2. 출하실적 insert
		INSERT INTO #TblDynamicPivot_SCP0038
		SELECT
			r.division_id
		   	,a.operation_group
			,a.cell_item_id
			,a.item_id
			,a.to_site
			,a.to_boh_qty
			,a.from_boh_qty
			,a.incoterms
			,a.from_site
			,a.transport_mode_line
			,a.measure
			,r.exfactory_date AS B_yyyymmdd
			,'D_'+r.exfactory_date  AS yyyymmdd
			,c.basis_yyyymm AS yyyymm
			,r.exfactory_qty AS qty
			,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
			,a.sort_order_no
			,a.column_label_name
			,a.bod_id
			,a.attribute9
			,a.rank
			,a.rank_detail
			,a.attribute3
			,a.attribute2
			,a.attribute10
		FROM SCM_DNM_EXFACTORY_RESULT r
		JOIN scm_sys_calendar_m c on r.exfactory_date = c.basis_yyyymmdd
		LEFT OUTER JOIN SCM_MST_SITE b on b.scm_site_id = r.to_scm_site_id and b.site_type='PLANT'
		JOIN #TblDynamicPivot_SCP0038_RESULT A WITH(NOLOCK) ON A.MEASURE='SHIP_PLAN'
															AND A.DIVISION_ID=R.DIVISION_ID
															AND A.ITEM_ID=R.ITEM_ID
															AND A.FROM_SITE=R.FROM_SCM_SITE_ID
															AND A.TO_SITE=R.TO_SCM_SITE_ID
															AND A.TRANSPORT_MODE_LINE=R.TRANSPORT_MODE
		WHERE 1=1
			AND r.exfactory_date          >= convert(datetime, @v_from_result)
			AND r.exfactory_date          < convert(datetime, @v_to_result )
			AND r.EXFACTORY_STATUS IN ('D20','D30','D40') -- 2019/10/21 추가
			AND r.division_id = @p_division_id
			AND (B.PLANT_ID IS NOT NULL OR (B.PLANT_ID IS NULL AND A.incoterms=R.incoterms)) -- FG의 경우 incoterms 비교
		;


	IF @debug_mode ='T'
	BEGIN
		PRINT 'Input Shipping set End. '+CONVERT(CHAR(23), GETDATE(), 21);
	END
		

		-- 3. 매출실적 insert
		INSERT INTO #TblDynamicPivot_SCP0038
		SELECT
			r.division_id
		   	,a.operation_group
			,a.cell_item_id
			,a.item_id
			,a.to_site
			,a.to_boh_qty
			,a.from_boh_qty
			,a.incoterms
			,a.from_site
			,a.transport_mode_line
			,a.measure
			,r.yyyymmdd AS B_yyyymmdd
			,'D_'+r.yyyymmdd  AS yyyymmdd
			,c.basis_yyyymm AS yyyymm
			,r.qty AS qty
			,RIGHT(c.basis_yyyymm,4)+c.iso_week AS iso_week
			,a.sort_order_no
			,a.column_label_name
			,a.bod_id
			,a.attribute9
			,a.rank
			,a.rank_detail
			,a.attribute3
			,a.attribute2
			,a.attribute10
		FROM dm_pln_sales_plan_result r
		JOIN scm_sys_calendar_m c on r.yyyymmdd = c.basis_yyyymmdd
		--JOIN SCM_MST_SITE b on b.scm_site_id = r.PLANT_SITE_ID and b.site_type='PLANT'
		JOIN #TblDynamicPivot_SCP0038_RESULT A WITH(NOLOCK) ON A.MEASURE='ALLOCATION'
															AND A.DIVISION_ID=R.DIVISION_ID
															AND A.ITEM_ID=R.ITEM_ID
															AND A.TO_SITE=R.SCM_SITE_ID
															AND A.incoterms=R.incoterms
		WHERE 1=1
			AND r.yyyymmdd          >= convert(datetime, @v_from_result)
			AND r.yyyymmdd          < convert(datetime, @v_to_result )
			AND r.division_id = @p_division_id
			AND r.measure = 'RTF'
		;


	IF @debug_mode ='T'
	BEGIN
		PRINT 'Input RTF set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	END
		

	END;



	/*
	CREATE CLUSTERED INDEX [IX01_##TblDynamicPivot_SCP0038] ON #TblDynamicPivot_SCP0038 (
		 DIVISION_ID
		,OPERATION_GROUP
		,CELL_ITEM_ID
		,ITEM_ID
		,TO_SITE
		,TO_BOH_QTY
		,FROM_BOH_QTY
		,ELECTRODE_TYPE
		,PSI_TYPE
		,PSI_NAME
		,PSI_VALUE
		,PSI_SEQ
		,INVENTORY_SEQ
		,yyyymmdd
		,yyyymm
	);
	*/


	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/
	begin
		DECLARE @mQry_sum NVARCHAR(MAX);
		DECLARE @mQry_isnull NVARCHAR(MAX);

		-- PIVOIT 대상 날짜문자열 생성
		SET @mQry_sum = '';
		SET @mQry_isnull = '';

		SELECT  @mQry_sum = @mQry_sum+','+
			CASE  WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY WHEN MEASURE!=''LINE_TOTAL_LOAD_ENGINE'' AND yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END )  AS ' + yyyymmdd
				  WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY WHEN MEASURE!=''LINE_TOTAL_LOAD_ENGINE'' AND iso_week = RIGHT('''+yyyymmdd+''', 6) THEN QTY END ) AS ' + yyyymmdd
				  WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY END ) AS ' + yyyymmdd
			END +''+CHAR(10)
			,@mQry_isnull = @mQry_isnull+',ISNULL(A.' + A.yyyymmdd +',0) AS '+yyyymmdd+CHAR(10)
		FROM (
			SELECT 'W_'+a.basis_yyyymm + a.iso_week AS yyyymmdd
				    , a.basis_start_date + CONVERT(CHAR(2), 21) AS sort_order_no
			FROM [dbo].[scm_sys_calendar_m] a
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.iso_week, a.basis_start_date
			UNION ALL
			SELECT 'M_'+a.basis_yyyymm  AS yyyymmdd
			      ,MIN(a.basis_start_date) + CONVERT(CHAR(2), '01') AS sort_order_no
			FROM [dbo].[scm_sys_calendar_m] a
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymm, a.month_name
			UNION ALL
			SELECT 'D_'+a.basis_yyyymmdd   AS yyyymmdd
			      , a.basis_yyyymmdd + CONVERT(CHAR(2), 31) AS sort_order_no
			FROM [dbo].[scm_sys_calendar_m] a
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY a.basis_yyyymmdd
		) AS A
		ORDER BY sort_order_no  ;



		SET @mEXEC = '';

		-- 주의 : 조회항목 변경 시 M_,W_,D_ 컬럼이 항상 뒤에 나와야함
		--        UI에서 합계계산 시 COLUMN COUNT INDEX 계산
		--SET @mEXEC = @mEXEC + ' SELECT isnull(NULLIF( A.LT_DAY_T, '''') , ''-'') AS LT_DAY						'+CHAR(10);
		--SET @mEXEC = @mEXEC + '        , isnull(NULLIF( A.CELL_QTY_PACK_T, '''') , ''-'') AS CELL_QTY_PACK		'+CHAR(10);
		SET @mEXEC = @mEXEC + 'SELECT CASE WHEN A.BOD_ID=''-'' THEN ''-'' ELSE convert(nvarchar(50), (	'+CHAR(10);
		--PJ20209642 : BOD LT 1단계 개발 ( scp_mst_bod_v.lt_total 로 변경)
		--SET @mEXEC = @mEXEC + '										CASE	WHEN ISNULL(l.segment3, '''') = '''' THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)  '+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''A''            THEN 0				'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''B''            THEN ISNULL(r.lt_departure_inland, 0)			'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''C''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0)			'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''D''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0)			'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''E''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0)			'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												WHEN l.segment3  = ''F''            THEN ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)	'+CHAR(10);
  --      SET @mEXEC = @mEXEC + '												ELSE                                     ISNULL(r.lt_departure_inland, 0) + ISNULL(r.lt_wait_shipping, 0) + ISNULL(r.lt_voyage, 0) + ISNULL(r.lt_lay_off_clearance, 0) + ISNULL(r.lt_arrival_inland, 0)	'+CHAR(10);
		--SET @mEXEC = @mEXEC + '										END ) ) END AS LT_DAY						'+CHAR(10);
		SET @mEXEC = @mEXEC + '		     B.lt_total )) END AS LT_DAY											'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , isnull(NULLIF( A.CELL_QTY_PACK_T, '''') , ''-'') AS CELL_QTY_PACK		'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , isnull(d.segment2,''-'') AS OPERATION_GROUP_NAME						'+CHAR(10);
		--SET @mEXEC = @mEXEC + '        , A.*																	'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.DIVISION_ID, A.RANK															'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.OPERATION_GROUP														'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.CELL_ITEM_ID															'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.ITEM_ID															    '+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.NICK_NAME															'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.CELL_QTY_PACK_T														'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.TO_SITE															    '+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.TO_SITE_DESCRIPTION													'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.TO_BOH_QTY															'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.FROM_BOH_QTY															'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.INCOTERMS															'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.FROM_SITE															'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.FROM_SITE_DESCRIPTION												'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.TRANSPORT_MODE_LINE													'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.BOD_ID															    '+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.MEASURE															    '+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.MEASURE_LABEL														'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.SORT_ORDER_NO														'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.RANK															        '+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.RANK_DETAIL															'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.MEASURE_COLOR														'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.BOH_QTY															    '+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.ATTRIBUTE10															'+CHAR(10);

		SET @mEXEC = @mEXEC + ' 	   ' +@mQry_isnull+'									                    '+CHAR(10);

		SET @mEXEC = @mEXEC + ' FROM (																			'+CHAR(10);
		SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID															'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.OPERATION_GROUP												'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.CELL_ITEM_ID												'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ITEM_ID														'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN ''-''  WHEN X.NICK_NAME = ''''    THEN ''-''  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.ITEM_ID) AS NICK_NAME		'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, CASE WHEN A.OPERATION_GROUP=''A'' THEN ''-'' ELSE (SELECT convert(nvarchar(50), MAX(ceiling(V.ACCUMULATED_CHILD_QTY)) ) 	'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 									FROM DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V V WITH (NOLOCK)					'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 									WHERE V.DIVISION_ID=A.DIVISION_ID AND V.OPERATION_GROUP_ID=''A''		'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 									AND V.MODEL_ID  = A.ITEM_ID AND V.CHILD_ITEM_ID IN ( SELECT value FROM dbo.FN_SplitString (A.CELL_ITEM_ID,'','') )			'+CHAR(10);
		--SET @mEXEC = @mEXEC + ' 									AND V.MODEL_ID  = A.ITEM_ID AND V.CHILD_ITEM_ID=A.CELL_ITEM_ID			'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 									) END AS CELL_QTY_PACK_T												'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_SITE																					'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, isnull(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID=A.TO_SITE), '''') , ''-'') AS TO_SITE_DESCRIPTION	'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_BOH_QTY																				'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_BOH_QTY																			'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, isnull(NULLIF( A.INCOTERMS, '''') , ''-'') AS INCOTERMS									'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_SITE																				'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, isnull(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID=A.FROM_SITE), '''') , ''-'') AS FROM_SITE_DESCRIPTION	'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, isnull(NULLIF( A.TRANSPORT_MODE_LINE, '''') , ''-'') AS TRANSPORT_MODE_LINE				'+CHAR(10);
		--SET @mEXEC = @mEXEC + ' 				, (SELECT convert(nvarchar(50), V.lt_total) FROM scp_mst_bod_v V WHERE V.DIVISION_ID=A.DIVISION_ID AND V.BOD_ID = A.BOD_ID AND V.FROM_SITE=A.FROM_SITE) AS LT_DAY_T	'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.BOD_ID											'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.MEASURE											'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.COLUMN_LABEL_NAME MEASURE_LABEL					'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.SORT_ORDER_NO									'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.RANK											'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.RANK_DETAIL										'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE3 AS MEASURE_COLOR						'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE2 AS BOH_QTY							'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE10										'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				' + @mQry_sum +'									'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_SCP0038 A WITH(NOLOCK)				'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 		GROUP BY A.DIVISION_ID										'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.OPERATION_GROUP									'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.CELL_ITEM_ID									'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ITEM_ID											'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_SITE											'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_BOH_QTY										'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_BOH_QTY									'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.INCOTERMS										'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_SITE										'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TRANSPORT_MODE_LINE								'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.BOD_ID											'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.MEASURE											'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.SORT_ORDER_NO									'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.COLUMN_LABEL_NAME								'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.RANK											'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.RANK_DETAIL										'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE3										'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE2										'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE10										'+CHAR(10);
		SET @mEXEC = @mEXEC + '      ) A															'+CHAR(10);

		--PJ20209642 : BOD LT 1단계 개발 ( scp_mst_bod_v.lt_total 로 변경)
		--SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_bod b WITH(NOLOCK)																'+CHAR(10);
		--SET @mEXEC = @mEXEC + '				ON B.DIVISION_ID=A.DIVISION_ID AND B.BOD_ID=A.BOD_ID AND B.FROM_SITE=A.FROM_SITE 			'+CHAR(10);
		--SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_distribution_route r WITH(NOLOCK)												'+CHAR(10);
		--SET @mEXEC = @mEXEC + '				ON R.route_id = B.route_id																	'+CHAR(10);
		--SET @mEXEC = @mEXEC + '      LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL l WITH(NOLOCK)												'+CHAR(10);
		--SET @mEXEC = @mEXEC + '				ON l.lookup_type = ''INCOTERMS'' AND l.valid_yn    = ''Y'' AND b.incoterms = l.segment1		'+CHAR(10);
		-- BOD 2단계 : scp_mst_bod_v -> scp_mst_bod_n_v
		--SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_bod_v b WITH(NOLOCK)																'+CHAR(10);
		SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_bod_n_v b WITH(NOLOCK)															'+CHAR(10);
		SET @mEXEC = @mEXEC + '				ON B.DIVISION_ID=A.DIVISION_ID AND B.BOD_ID=A.BOD_ID AND B.FROM_SITE=A.FROM_SITE 			'+CHAR(10);

		SET @mEXEC = @mEXEC + '		 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL d on d.LOOKUP_TYPE = ''OPERATION_GROUP'' and d.segment1 = a.operation_group			'+CHAR(10);

-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 0값 제거에 따른 변경 - start
-- 2021-06-08 : 분기 제거
--IF (CONVERT(CHAR(8), @v_toway_result, 112) <= CONVERT(CHAR(8), @p_plan_start_yyyymmdd, 112))
--BEGIN
		-- BOD 2단계
		--SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.OPERATION_GROUP DESC, A.RANK, A.RANK_DETAIL, A.CELL_ITEM_ID, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE desc, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.MEASURE_LABEL DESC		'+CHAR(10);
		SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.OPERATION_GROUP DESC, A.RANK, A.RANK_DETAIL, A.CELL_ITEM_ID, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE desc, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.BOD_ID, A.MEASURE_LABEL DESC		'+CHAR(10);
--END;
--ELSE
--BEGIN
--		SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.RANK, A.RANK_DETAIL, A.OPERATION_GROUP DESC, A.CELL_ITEM_ID, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE desc, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.MEASURE_LABEL DESC		'+CHAR(10);
--END;
		-- org
		--SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.RANK, A.RANK_DETAIL, A.OPERATION_GROUP DESC, A.CELL_ITEM_ID, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE desc, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.MEASURE_LABEL DESC		'+CHAR(10);

		--SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.RANK, A.RANK_DETAIL, A.OPERATION_GROUP DESC, A.CELL_ITEM_ID, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE desc, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.MEASURE_LABEL DESC		'+CHAR(10);
		--SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.RANK, A.OPERATION_GROUP DESC, A.CELL_ITEM_ID, A.ITEM_ID,A.TO_SITE desc, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.MEASURE_LABEL DESC		'+CHAR(10);

		IF( @debug_mode ='T')
			BEGIN
				SET @POS =1;
				SET @LEN =LEN(@mEXEC);
				WHILE @POS <= @LEN
					BEGIN
						PRINT SUBSTRING(@mEXEC,@POS,4000);
						SET @POS = @POS+4000;
					END;
			END;
		EXEC (@mEXEC);

	end;


	IF @debug_mode ='T'
	BEGIN
		PRINT '-------------RESULT SEARCH'
		print CONVERT(CHAR(23), getdate(), 21)
	END



	--임시테이블 삭제
	IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0038_item') is not null
		DROP TABLE #TblDynamicPivot_SCP0038_item

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_cellItem') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_cellItem;

	IF OBJECT_ID('tempdb..#tbl_ITEM_ID_Cell_Item_ID') IS NOT NULL
	DROP TABLE #tbl_ITEM_ID_Cell_Item_ID

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_LINE_LOAD') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_LINE_LOAD

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_LINE') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_LINE;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_NICKITEM') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0038_NICKITEM

	IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0038') is not null
		DROP TABLE #TblDynamicPivot_SCP0038

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_RANK') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0038_RANK

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_MEASURE') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0038_MEASURE

	IF OBJECT_ID('tempdb..#PACK') IS NOT NULL
	DROP TABLE #PACK

	IF OBJECT_ID('tempdb..#TCOCELL') IS NOT NULL
	DROP TABLE #TCOCELL

	IF OBJECT_ID('tempdb..#CELL') IS NOT NULL
	DROP TABLE #CELL

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_item_order') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_item_order;

	--생산실적, 출하실적 용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_RESULT') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_RESULT;

	--생산 로드율 주SUM, 월SUM
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0038_LINE_LOAD_BASE') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0038_LINE_LOAD_BASE;

END

