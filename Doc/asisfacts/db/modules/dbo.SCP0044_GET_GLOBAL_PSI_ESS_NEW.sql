
/*
 * Program ID   : SCP0044_GET_GLOBAL_PSI_ESS
 * Description  : GLOBAL PSI(ESS) 조회
 * Execute      :
                   EXEC SCP0044_GET_GLOBAL_PSI_ESS
                     @p_from_yyyymmdd            = '20190715'
                    ,@p_to_yyyymmdd              = '20200712'
                    ,@p_division_id              = '82'
                    ,@p_item_id                  = 'ECE0630N1-02'
                    ,@p_nick_name                = ''
                    ,@p_from_site                = ''
                    ,@p_to_site                  = ''
                    ,@p_plan_start_yyyymmdd      = '20190715'
                    ,@p_plan_type                = 'MA'
                    ,@p_seq                      = '1'
                    ,@p_program_id               = 'SCP0044'
                    ,@p_sheet_name               = 'Global PSI ESS'
                    ,@p_user_id                  = ''
                    ,@debug_mode                 = 'F'
 *
 * Program History
 *===================================================================================================
 *   Date		In Charge	Description
 *===================================================================================================
 * 2019/07/02	hwyoon		Initial Release [PJ20189106] 전지.GSCM 고도화 이행
 * 2019/07/02	KTH			함수변경(FN_SplitString)
							임시테이별 컬럼타입 변경BIGINT --> INT
							WITH(NOLOCK) 추가
							@v_cnt_usr_measure TYPE변경 NVARCHAR --> INT
 * 2019/10/21	hwyoon		오류수정 - 출하실적 조회 시 "삭제"수량 제외 r.EXFACTORY_STATUS IN ('D20','D30','D40')
 * 2021/05/13   khj79       [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 1단계 개발(LT_DAY 변경을 위한 scp_mst_bod_v 로 변경 )
 * 2021/07/15   khj79		[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : scp_mst_bod_v=> scp_mst_bod_n_v
 * 2022/01/25   vadabi3		PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - DC Link Sort 적용 (Rack_YN, DC_YN Sort 적용)
 * 2022/04/29   chaan		81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2023/06/13   vadabi3		PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - [활성화] Final Item) Cell Type 기준 Sort 적용
 */
CREATE PROCEDURE [dbo].[SCP0044_GET_GLOBAL_PSI_ESS_NEW]
	@p_from_yyyymmdd				NVARCHAR(008),
	@p_to_yyyymmdd					NVARCHAR(008),
--chaan	@p_division_id          NVARCHAR(2)
   @p_division_id                  NVARCHAR(30),--chaan
	@p_item_id					    NVARCHAR(MAX)='',
	@p_nick_name				    NVARCHAR(MAX)='',
	@p_from_site				    NVARCHAR(MAX)='',
	@p_to_site					    NVARCHAR(MAX)='',
	@p_plan_start_yyyymmdd			NVARCHAR(008),
	@p_plan_type				    NVARCHAR(050),
	@p_seq						    NVARCHAR(050),
	@p_program_id				    NVARCHAR(MAX)='SCP0044',
	@p_sheet_name				    NVARCHAR(MAX)='Global PSI ESS',
	@p_user_id					    NVARCHAR(MAX)='',
	@debug_mode					    NVARCHAR(001)='F'
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	IF( @debug_mode ='T')
		PRINT 'All Start. '+CONVERT(CHAR(23), GETDATE(), 21)

	DECLARE @arr_item_id varchar(max) , @arr_from_site varchar(max) , @arr_to_site varchar(max);
	SELECT @arr_item_id		  = ISNULL(@arr_item_id	  + ',''' + value +'''', ''''+value+'''') FROM dbo.FN_SplitString(@p_item_id,',')
	SELECT @arr_from_site   = ISNULL(@arr_from_site + ',''' + value +'''', ''''+value+'''') FROM dbo.FN_SplitString(@p_from_site,',')
	SELECT @arr_to_site     = ISNULL(@arr_to_site	  + ',''' + value +'''', ''''+value+'''') FROM dbo.FN_SplitString(@p_to_site,',')

	DECLARE @v_cnt_usr_measure	int  =0;
	SET @v_cnt_usr_measure = (
								SELECT COUNT(*)
								FROM scm_mst_titleset_user  WITH(NOLOCK)
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name
								 AND user_id     =  @p_user_id
							  )

	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8)='';
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8)='';
	DECLARE @v_from_result       AS NVARCHAR(8)='';
	DECLARE @v_to_result         AS NVARCHAR(8)='';


	 SET @v_from_yyyymmdd = @p_plan_start_yyyymmdd
   SET @v_from_result   = @v_from_yyyymmdd

   SELECT @v_to_result = C.BASIS_START_DATE
	  FROM   dbo.SCM_SYS_CALENDAR_M      C	WITH(NOLOCK)
	  WHERE  1 = 1
  	  AND    C.BASIS_YYYYMMDD = @p_to_yyyymmdd;

	IF @v_from_yyyymmdd > @v_from_result
		BEGIN -- 실적 보여줌
		  SET @v_to_yyyymmdd    = @p_to_yyyymmdd;
		  SET @v_to_result      = @v_from_yyyymmdd;
		END;
	ELSE IF @v_from_yyyymmdd <= @v_from_result
		BEGIN -- 실적 없음
		  SET @v_to_yyyymmdd    = @p_to_yyyymmdd;
		  SET @v_from_result    = CONVERT(CHAR(8), DATEADD(MM,  6, convert(datetime,@p_plan_start_yyyymmdd)), 112);
		  SET @v_to_result      = CONVERT(CHAR(8), DATEADD(MM, -6, convert(datetime,@p_plan_start_yyyymmdd)), 112)
		END;
	ELSE IF @v_from_yyyymmdd > @v_to_result
		BEGIN
		  SET @v_from_yyyymmdd  = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
		  SET @v_to_yyyymmdd    = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
		  SET @v_from_result    = @p_from_yyyymmdd;
		  SET @v_to_result      = @p_to_yyyymmdd;
		END;
	ELSE IF @v_from_yyyymmdd  = @v_to_result
		BEGIN
		  SET @v_to_yyyymmdd    = @v_from_yyyymmdd
		  SET @v_from_result    = @p_from_yyyymmdd;
		  SET @v_to_result      = @p_to_yyyymmdd;
		END;

	IF @debug_mode ='T'
	BEGIN
		PRINT '--------------------------------------';
		PRINT 'v_from_yyyymmdd  =' +@v_from_yyyymmdd;
		PRINT 'v_to_yyyymmdd    =' +@v_to_yyyymmdd;
		PRINT 'v_from_result    =' +@v_from_result;
		PRINT 'v_to_result      =' +@v_to_result	;
		PRINT '--------------------------------------';
	END;

	/********************************************************************************
	 * 임시테이블만들기 - 조회조건 테이블
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_item') IS NOT NULL
	  DROP TABLE #TblDynamicPivot_SCP0044_item;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_TEMP') IS NOT NULL
	  DROP TABLE #TblDynamicPivot_SCP0044_TEMP;

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_NICKITEM') IS NOT NULL
	  DROP TABLE #TblDynamicPivot_SCP0044_NICKITEM

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_RANK') IS NOT NULL
	  DROP TABLE #TblDynamicPivot_SCP0044_RANK

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_MEASURE') IS NOT NULL
	  DROP TABLE #TblDynamicPivot_SCP0044_MEASURE

	--생산실적, 출하실적 용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_RESULT') IS NOT NULL
	  DROP TABLE #TblDynamicPivot_SCP0044_RESULT;

	--로드률 용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_LOAD') IS NOT NULL
	  DROP TABLE #TblDynamicPivot_SCP0044_LOAD;

  -- 반복으로 사용되는 테이븍을 임시테이블로 변경
  IF OBJECT_ID('tempdb..#SCM_MST_SHEET_MEASURE') IS NOT NULL
	  DROP TABLE #SCM_MST_SHEET_MEASURE;

    SELECT *
      INTO #SCM_MST_SHEET_MEASURE
    	FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
  	 WHERE M.PROGRAM_ID = 'SCP0044'
	     AND M.VALID_YN   = 'Y'


	/* NICK NAME 조회조건으로 ITEM 추출 */
	SELECT DISTINCT ITEM_ID
	  INTO #TblDynamicPivot_SCP0044_NICKITEM
	  FROM SCM_MST_ITEM_SN WITH(NOLOCK)
	 WHERE 1=1
	  AND NICK_NAME IS NOT NULL
	  AND ISNULL(@p_nick_name,'')!=''
	  AND NICK_NAME LIKE @p_nick_name+'%'

	/* PSI CELL/PACK ITEM 세트 */
	SELECT CELL_ITEM_ID, ITEM_ID, RANK() OVER(ORDER BY CELL_ITEM_ID ASC) AS 'RANK'
	  INTO #TblDynamicPivot_SCP0044_RANK

	  FROM SCP_ANL_PSI_GLOBAL_ESS WITH(NOLOCK)
	 WHERE DIVISION_ID          = @p_division_id
	   AND PLAN_START_YYYYMMDD  = @p_plan_start_yyyymmdd
	   AND PLAN_TYPE            = @p_plan_type
	   AND SEQ                  = @p_seq
	   AND YYYYMMDD             >= @p_from_yyyymmdd
	   AND YYYYMMDD             <= @p_to_yyyymmdd

	GROUP BY CELL_ITEM_ID, ITEM_ID
	ORDER BY CELL_ITEM_ID

	/* 조회조건에 해당하는 세트 모두 추출 */
	SELECT A.CELL_ITEM_ID, A.ITEM_ID
	INTO #TblDynamicPivot_SCP0044_item
	FROM #TblDynamicPivot_SCP0044_RANK A WITH(NOLOCK)
	WHERE A.RANK IN
		(
			SELECT B.RANK
			FROM #TblDynamicPivot_SCP0044_RANK B WITH(NOLOCK)
			WHERE 1=1
			AND ( (B.ITEM_ID IN (SELECT VALUE FROM dbo.FN_SplitString (@p_item_id,',')) )
			 OR (B.ITEM_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0044_NICKITEM))
			 OR (B.CELL_ITEM_ID IN (SELECT VALUE FROM dbo.FN_SplitString(@p_item_id,',')) )
			 OR (B.CELL_ITEM_ID IN (SELECT ITEM_ID FROM #TblDynamicPivot_SCP0044_NICKITEM)) )
		)
	;

	IF( @debug_mode ='T')
		PRINT 'Search Item set End. '+CONVERT(CHAR(23), GETDATE(), 21)


	/* 유저 MEASURE 세팅값 추출 */ --로드율은 PRODUCTION과 동일한 SORT 값을 강제 셋팅
	SELECT M.COLUMN_NAME, M.COLUMN_LABEL_NAME
			  , CASE  WHEN M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'	AND @v_cnt_usr_measure>0
                  THEN ISNULL( (SELECT T.SORT_ORDER_NO
															  FROM SCM_MST_TITLESET_USER T
															  WHERE T.PROGRAM_ID=M.program_id
															  AND T.SHEET_NAME=M.sheet_name
															  AND T.COLUMN_NAME='PRODUCTION'
															  AND T.USER_ID=U.user_id), U.SORT_ORDER_NO)
				        WHEN M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'	AND @v_cnt_usr_measure=0
                  THEN P.SORT_ORDER_NO
				        WHEN M.COLUMN_NAME='SHIP_PLAN'				AND @v_cnt_usr_measure>0
                  THEN ISNULL( (SELECT T.SORT_ORDER_NO
															  FROM SCM_MST_TITLESET_USER T
															  WHERE T.PROGRAM_ID=M.program_id
															  AND T.SHEET_NAME=M.sheet_name
															  AND T.COLUMN_NAME='SHIP_REQ'
															  AND T.USER_ID=U.user_id), U.SORT_ORDER_NO)
				        WHEN M.COLUMN_NAME='SHIP_PLAN'				AND @v_cnt_usr_measure=0
                  THEN S.SORT_ORDER_NO
				        ELSE ISNULL(U.sort_order_no, M.SORT_ORDER_NO)
			          END AS SORT_ORDER_NO
			  , M.ATTRIBUTE3 --MEASURE 별 COLOR RGB코드
	INTO #TblDynamicPivot_SCP0044_MEASURE
	FROM #SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
	LEFT HASH JOIN SCM_MST_TITLESET_USER U WITH(NOLOCK)
         ON U.program_id  = M.program_id
        AND U.sheet_name  = M.sheet_name
				AND U.column_name = M.column_name
        AND U.user_id     = @p_user_id
	LEFT HASH JOIN #SCM_MST_SHEET_MEASURE P WITH(NOLOCK)
         ON P.program_id  = M.program_id
        AND P.sheet_name  = M.sheet_name
        AND P.column_name = 'PRODUCTION'
	LEFT HASH JOIN #SCM_MST_SHEET_MEASURE S WITH(NOLOCK)
         ON S.program_id  = M.program_id
        AND S.sheet_name  = M.sheet_name
        AND S.column_name = 'SHIP_REQ'
	WHERE M.PROGRAM_ID='SCP0044'
		  AND M.VALID_YN='Y'
		  AND (@v_cnt_usr_measure=0 or ISNULL(U.SORT_ORDER_NO,0)>0)

	IF( @debug_mode ='T')
		PRINT 'Search Measure set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	/********************************************************************************
	 * 임시테이블만들기 - 본 테이블
	 ********************************************************************************/
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044') IS NOT NULL
	DROP TABLE #TblDynamicPivot_SCP0044;

	/********************************************************************************
	* 데이타조회, 임시테이블에 저장
	********************************************************************************/
	DECLARE @mEXEC NVARCHAR(MAX);

	CREATE TABLE #TblDynamicPivot_SCP0044 (
		 DIVISION_ID		      NVARCHAR(060)
		,OPERATION_GROUP	    NVARCHAR(060)
		,CELL_ITEM_ID		      NVARCHAR(100)
		,ITEM_ID			        NVARCHAR(100)
    ,CONVERT_QTY_CELL     INT
		,TO_SITE			        NVARCHAR(060)
		,TO_BOH_QTY			      INT
		,FROM_BOH_QTY		      INT
		,INCOTERMS			      NVARCHAR(020)
		,FROM_SITE			      NVARCHAR(060)
		,TRANSPORT_MODE_LINE	NVARCHAR(100)
		,MEASURE			        NVARCHAR(100)
		,B_YYYYMMDD			      NVARCHAR(010)
		,YYYYMMDD			        NVARCHAR(010)
		,YYYYMM				        NVARCHAR(006)
		,QTY				          numeric(30,10)
		,ISO_WEEK			        INT
		,SORT_ORDER_NO		    INT
		,COLUMN_LABEL_NAME	  NVARCHAR(300)
		,BOD_ID				        NVARCHAR(300)
		,ATTRIBUTE9			      NVARCHAR(150)
		,ATTRIBUTE10		      NVARCHAR(150)
		,ATTRIBUTE3				    NVARCHAR(030)
	);

	--생산/출하 실적 Temp Table
	CREATE TABLE #TblDynamicPivot_SCP0044_RESULT (
		 DIVISION_ID		      NVARCHAR(060)
		,OPERATION_GROUP	    NVARCHAR(060)
		,CELL_ITEM_ID		      NVARCHAR(100)
		,ITEM_ID			        NVARCHAR(100)
    ,CONVERT_QTY_CELL     INT
		,TO_SITE			        NVARCHAR(060)
		,TO_BOH_QTY			      INT
		,FROM_BOH_QTY		      INT
		,INCOTERMS			      NVARCHAR(020)
		,FROM_SITE			      NVARCHAR(060)
		,TRANSPORT_MODE_LINE	NVARCHAR(100)
		,MEASURE			        NVARCHAR(100)
		,SORT_ORDER_NO		    INT
		,COLUMN_LABEL_NAME	  NVARCHAR(300)
		,BOD_ID				        NVARCHAR(300)
		,ATTRIBUTE9			      NVARCHAR(150)
		,ATTRIBUTE10		      NVARCHAR(150)
		,ATTRIBUTE3				    NVARCHAR(030)
	);

	SET @mEXEC = '';
	SET @mEXEC = @mEXEC + ' INSERT #TblDynamicPivot_SCP0044	      '+CHAR(10);
	SET @mEXEC = @mEXEC + ' SELECT A.DIVISION_ID							    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.OPERATION_GROUP						    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.CELL_ITEM_ID							    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ITEM_ID										    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.CONVERT_QTY_CELL              '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, ISNULL(NULLIF(A.TO_SITE, '''') , ''-'') TO_SITE			    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.TO_BOH_QTY								    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.FROM_BOH_QTY						    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.INCOTERMS 								    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.FROM_SITE 								    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.TRANSPORT_MODE_LINE				    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.MEASURE										    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.YYYYMMDD AS B_YYYYMMDD		    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, ''D_''+ A.YYYYMMDD AS YYYYMMDD	'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, O.BASIS_YYYYMM AS YYYYMM				'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, ISNULL(QTY,0) AS QTY						'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, RIGHT(O.BASIS_YYYYMM, 4)+O.ISO_WEEK AS ISO_WEEK			    '+CHAR(10);
	SET @mEXEC = @mEXEC + '			, M.SORT_ORDER_NO									'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, M.COLUMN_LABEL_NAME							'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.BOD_ID												'+CHAR(10);
	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE9										'+CHAR(10); -- OPERATION ID
	SET @mEXEC = @mEXEC + '			, A.ATTRIBUTE10										'+CHAR(10); -- P:1, A:2
	SET @mEXEC = @mEXEC + '			, M.ATTRIBUTE3										'+CHAR(10); -- UI용 MEASURE COLOR
	SET @mEXEC = @mEXEC + '	   FROM SCP_ANL_PSI_GLOBAL_ESS A WITH(NOLOCK)						      '+CHAR(10);
	SET @mEXEC = @mEXEC + '	   INNER JOIN SCM_SYS_CALENDAR_M O WITH(NOLOCK) ON A.YYYYMMDD = O.BASIS_YYYYMMDD				    '+CHAR(10);
	SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0044_MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME=A.MEASURE		'+CHAR(10);
	IF (NOT(@p_item_id IS NULL OR @p_item_id ='') OR NOT(@p_nick_name IS NULL OR @p_nick_name =''))
		BEGIN
			SET @mEXEC = @mEXEC + '	   INNER JOIN #TblDynamicPivot_SCP0044_item I WITH(NOLOCK) ON A.CELL_ITEM_ID = I.CELL_ITEM_ID AND A.ITEM_ID=I.ITEM_ID				'+CHAR(10);
		END;
	SET @mEXEC = @mEXEC + '	  WHERE A.DIVISION_ID			  = '''+@p_division_id+'''          '+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.PLAN_START_YYYYMMDD	= '''+@p_plan_start_yyyymmdd+'''	'+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.PLAN_TYPE				    = '''+@p_plan_type+'''					  '+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.SEQ					        = '''+@p_seq+'''						      '+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD           >= '''+@p_from_yyyymmdd+'''				'+CHAR(10);
	SET @mEXEC = @mEXEC + '		AND A.YYYYMMDD           <= '''+@p_to_yyyymmdd+'''					'+CHAR(10);
	SET @mEXEC = @mEXEC + '   AND ('''+CONVERT(NVARCHAR,@v_cnt_usr_measure)+''' = ''0'' OR ISNULL(M.sort_order_no,0)>0)   '+CHAR(10);

	IF NOT(@p_from_site IS NULL	OR  @p_from_site	='')
      SET @mEXEC = @mEXEC+'   	AND A.FROM_SITE     IN ('+@arr_from_site+') 				'+CHAR(10);
	IF NOT(@p_to_site	IS NULL	  OR  @p_to_site		='')
      SET @mEXEC = @mEXEC+'   	AND A.TO_SITE       IN ('+@arr_to_site+') 					'+CHAR(10);





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



	IF( @debug_mode ='T')
		PRINT 'Search Rowdata set End. '+CONVERT(CHAR(23), GETDATE(), 21)


	/********************************************************************************
	* 1. Line Load(%) Temp
	********************************************************************************/
	SELECT  A.DIVISION_ID
		    , A.OPERATION_GROUP
		    , A.FROM_SITE
		    , A.ATTRIBUTE9
		    , A.TRANSPORT_MODE_LINE
		    , ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0) AS SUM_LOAD_QTY
		    , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0
				    ELSE ISNULL( ( ( ROUND(SUM(A.QTY * (E.TACT_TIME/60)),0) / D.WORKING_TIME ) ) ,0 ) *100
			    END AS QTY
		    , D.WORKING_TIME
		    , A.YYYYMMDD AS B_YYYYMMDD
		    , O.BASIS_YYYYMM AS YYYYMM
		    , O.ISO_WEEK
		    ,'W_'+O.BASIS_YYYYMM + O.ISO_WEEK AS WEEK_YYYYMMDD
		    ,'M_'+O.BASIS_YYYYMM  AS MONTH_YYYYMMDD
   INTO #TblDynamicPivot_SCP0044_TEMP
   FROM SCP_ANL_PSI_GLOBAL_ESS A WITH(NOLOCK)

     INNER JOIN SCM_SYS_CALENDAR_M O WITH(NOLOCK)
           ON A.YYYYMMDD      = O.BASIS_YYYYMMDD
	 INNER JOIN SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
           ON M.PROGRAM_ID    = @P_PROGRAM_ID
          AND M.COLUMN_NAME   = A.MEASURE
	 INNER JOIN SCP_ANL_WORKING_TIME D WITH(NOLOCK)
           ON A.DIVISION_ID   = D.DIVISION_ID
          AND A.ATTRIBUTE9    = D.OPERATION_ID
					AND A.FROM_SITE     = D.SCM_SITE_ID
					AND A.TRANSPORT_MODE_LINE = D.LINE_ID
					AND A.YYYYMMDD      = D.YYYYMMDD
	 INNER JOIN SCP_ANL_TACT_TIME E WITH(NOLOCK)
	 
           ON A.DIVISION_ID   = E.DIVISION_ID
          AND A.ATTRIBUTE9    = E.OPERATION_ID
					AND A.FROM_SITE     = E.SCM_SITE_ID
					AND A.TRANSPORT_MODE_LINE = E.LINE_ID
					AND (CASE WHEN A.OPERATION_GROUP='P' THEN A.ITEM_ID ELSE A.CELL_ITEM_ID END) = E.ITEM_ID
					AND A.YYYYMMDD      = E.YYYYMMDD
  WHERE A.DIVISION_ID			    = @p_division_id
	  AND A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
	  AND A.PLAN_TYPE				    = @p_plan_type
	  AND A.SEQ					        = @p_seq
	  AND A.YYYYMMDD            >= @p_from_yyyymmdd
	  AND A.YYYYMMDD            <= @p_to_yyyymmdd
	  AND (@v_cnt_usr_measure   = 0 OR ISNULL(M.sort_order_no,0)>0)
	  AND A.MEASURE             ='PRODUCTION' -- 6초 75712행
  GROUP BY A.DIVISION_ID, A.OPERATION_GROUP ,A.FROM_SITE ,A.ATTRIBUTE9 ,A.TRANSPORT_MODE_LINE, A.YYYYMMDD,O.BASIS_YYYYMM,O.ISO_WEEK, D.WORKING_TIME
  ;



	IF( @debug_mode ='T')
		PRINT 'Search Line Load set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	/********************************************************************************
	* 2. 과거 실적구간 temp
	********************************************************************************/
	IF(@v_from_result<@v_to_result)
	BEGIN
		INSERT INTO #TblDynamicPivot_SCP0044_RESULT
		SELECT DISTINCT
			     A.DIVISION_ID
			   , A.OPERATION_GROUP
			   , A.CELL_ITEM_ID
			   , A.ITEM_ID
			   , A.CONVERT_QTY_CELL
			   , A.TO_SITE
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
		FROM #TblDynamicPivot_SCP0044 A WITH(NOLOCK)
		WHERE A.MEASURE IN ('PRODUCTION','SHIP_PLAN','ALLOCATION') --2초
		;


		IF( @debug_mode ='T')
			PRINT 'Search Prev Result set End. '+CONVERT(CHAR(23), GETDATE(), 21)
	
	END;


	-- Line Load(%) Insert
	SELECT A.DIVISION_ID
		   , A.OPERATION_GROUP
		   , A.CELL_ITEM_ID
		   , A.ITEM_ID
		   , A.CONVERT_QTY_CELL
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
		   , B.SUM_LOAD_QTY
		   , B.WORKING_TIME
		   , B.week_yyyymmdd
		   , B.month_yyyymmdd
	INTO #TblDynamicPivot_SCP0044_LOAD
	FROM #TblDynamicPivot_SCP0044 A WITH(NOLOCK)
	INNER JOIN #TblDynamicPivot_SCP0044_TEMP B WITH(NOLOCK)
		      ON A.DIVISION_ID			= B.DIVISION_ID
		     AND A.OPERATION_GROUP		= B.OPERATION_GROUP
		     AND A.FROM_SITE			= B.FROM_SITE
		     AND A.ATTRIBUTE9			= B.ATTRIBUTE9
		     AND A.TRANSPORT_MODE_LINE  = B.TRANSPORT_MODE_LINE
		     AND A.B_yyyymmdd			= B.B_yyyymmdd
	INNER JOIN #TblDynamicPivot_SCP0044_MEASURE M WITH(NOLOCK)
          ON M.COLUMN_NAME				='LINE_TOTAL_LOAD_ENGINE'
	;


	IF( @debug_mode ='T')
		PRINT 'Input Line Load Daily End. '+CONVERT(CHAR(23), GETDATE(), 21)

	/*
	INSERT INTO #TblDynamicPivot_SCP0044
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
	FROM #TblDynamicPivot_SCP0044 A WITH(NOLOCK)
	JOIN #TblDynamicPivot_SCP0044_TEMP B WITH(NOLOCK)
		ON A.DIVISION_ID=B.DIVISION_ID
		AND A.OPERATION_GROUP = B.OPERATION_GROUP
		AND A.FROM_SITE=B.FROM_SITE
		AND A.ATTRIBUTE9 = B.ATTRIBUTE9
		AND A.TRANSPORT_MODE_LINE = B.TRANSPORT_MODE_LINE
		AND A.B_yyyymmdd = B.B_yyyymmdd
	INNER JOIN #TblDynamicPivot_SCP0044_MEASURE M WITH(NOLOCK) ON M.COLUMN_NAME='LINE_TOTAL_LOAD_ENGINE'
	;
	*/

	--Load율 개선(Daily)
	INSERT INTO #TblDynamicPivot_SCP0044
	SELECT A.DIVISION_ID
		   , A.OPERATION_GROUP
		   , A.CELL_ITEM_ID
		   , A.ITEM_ID
		   , A.CONVERT_QTY_CELL
		   , A.TO_SITE
		   , A.TO_BOH_QTY
		   , A.FROM_BOH_QTY
		   , A.INCOTERMS
		   , A.FROM_SITE
		   , A.TRANSPORT_MODE_LINE
		   , A.MEASURE
		   , A.B_yyyymmdd
		   , A.yyyymmdd
		   , A.yyyymm
		   , A.qty
		   , A.iso_week
		   , A.sort_order_no
		   , A.COLUMN_LABEL_NAME
		   , A.BOD_ID
		   , A.ATTRIBUTE9
		   , A.ATTRIBUTE10
		   , A.ATTRIBUTE3
	FROM #TblDynamicPivot_SCP0044_LOAD A WITH(NOLOCK)


	IF( @debug_mode ='T')
		PRINT 'Input Line Load Daily set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	--Load율 개선(Week)
	INSERT INTO #TblDynamicPivot_SCP0044
	SELECT DIVISION_ID
		   , OPERATION_GROUP
		   , CELL_ITEM_ID
		   , ITEM_ID
		   , CONVERT_QTY_CELL
		   , TO_SITE
		   , TO_BOH_QTY
		   , FROM_BOH_QTY
		   , INCOTERMS
		   , FROM_SITE
		   , TRANSPORT_MODE_LINE
		   , MEASURE
		   , '-' AS B_YYYYMMDD
		   , WEEK_YYYYMMDD AS YYYYMMDD
		   , '-' AS YYYYMM
		   , CASE WHEN SUM(working_time) <= 0.0 THEN 0
				      ELSE ISNULL( ( SUM(SUM_LOAD_QTY) / SUM(working_time) ) ,0 ) *100
			        END AS qty
		   , '-' AS iso_week
		   , sort_order_no
		   , COLUMN_LABEL_NAME
		   , BOD_ID
		   , ATTRIBUTE9
		   , ATTRIBUTE10
		   , ATTRIBUTE3
	FROM #TblDynamicPivot_SCP0044_LOAD WITH(NOLOCK)
	GROUP BY DIVISION_ID
			 , OPERATION_GROUP
			 , CELL_ITEM_ID
			 , ITEM_ID
			 , CONVERT_QTY_CELL
			 , TO_SITE
			 , TO_BOH_QTY
			 , FROM_BOH_QTY
			 , INCOTERMS
			 , FROM_SITE
			 , TRANSPORT_MODE_LINE
			 , MEASURE
			 , sort_order_no
			 , COLUMN_LABEL_NAME
			 , BOD_ID
			 , ATTRIBUTE9
			 , ATTRIBUTE10
			 , ATTRIBUTE3
			 , WEEK_YYYYMMDD
			 , MONTH_YYYYMMDD
	;


	IF( @debug_mode ='T')
		PRINT 'Input Line Load Week set End. '+CONVERT(CHAR(23), GETDATE(), 21)



	--Load율 개선(Month)
	INSERT INTO #TblDynamicPivot_SCP0044
	SELECT DIVISION_ID
		   , OPERATION_GROUP
		   , CELL_ITEM_ID
		   , ITEM_ID
		   , CONVERT_QTY_CELL
		   , TO_SITE
		   , TO_BOH_QTY
		   , FROM_BOH_QTY
		   , INCOTERMS
		   , FROM_SITE
		   , TRANSPORT_MODE_LINE
		   , MEASURE
		   , '-' AS B_YYYYMMDD
		   , MONTH_YYYYMMDD AS YYYYMMDD
		   , '-' AS YYYYMM
		   , CASE WHEN SUM(working_time) <= 0.0 THEN 0
				      ELSE ISNULL( ( SUM(SUM_LOAD_QTY) / SUM(working_time) ) ,0 ) *100
			        END AS qty
		   , '-' AS iso_week
		   , sort_order_no
		   , COLUMN_LABEL_NAME
		   , BOD_ID
		   , ATTRIBUTE9
		   , ATTRIBUTE10
		   , ATTRIBUTE3
	FROM #TblDynamicPivot_SCP0044_LOAD WITH(NOLOCK)
	GROUP BY DIVISION_ID
			 , OPERATION_GROUP
			 , CELL_ITEM_ID
			 , ITEM_ID
			 , CONVERT_QTY_CELL
			 , TO_SITE
			 , TO_BOH_QTY
			 , FROM_BOH_QTY
			 , INCOTERMS
			 , FROM_SITE
			 , TRANSPORT_MODE_LINE
			 , MEASURE
			 , sort_order_no
			 , COLUMN_LABEL_NAME
			 , BOD_ID
			 , ATTRIBUTE9
			 , ATTRIBUTE10
			 , ATTRIBUTE3
			 , MONTH_YYYYMMDD
	;


	IF( @debug_mode ='T')
		PRINT 'Input Line Load Month set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	-- 생산/출하/매출 실적 insert
	IF(@v_from_result<@v_to_result)
	BEGIN
		-- 1. 생산실적 insert
		INSERT INTO #TblDynamicPivot_SCP0044
		SELECT  DISTINCT
			 R.DIVISION_ID
			,A.OPERATION_GROUP
			,A.CELL_ITEM_ID
			,A.ITEM_ID
			,A.CONVERT_QTY_CELL
			,A.TO_SITE
			,A.TO_BOH_QTY
			,A.FROM_BOH_QTY
			,A.INCOTERMS
			,A.FROM_SITE
			,A.TRANSPORT_MODE_LINE
			,A.MEASURE
			,CONVERT(NVARCHAR(8), R.PLAN_DATE,112) AS B_YYYYMMDD
			,'D_'+CONVERT(NVARCHAR(8), R.PLAN_DATE,112)  AS YYYYMMDD
			,C.BASIS_YYYYMM AS YYYYMM
			,R.ACTUAL_GOOD_QTY AS QTY
			--,RIGHT(C.BASIS_YYYYMM,2)+C.ISO_WEEK AS ISO_WEEK
			,RIGHT(C.BASIS_YYYYMM,4)+C.ISO_WEEK AS ISO_WEEK
			,A.SORT_ORDER_NO
			,A.COLUMN_LABEL_NAME
			,A.BOD_ID
			,A.ATTRIBUTE9
			,A.ATTRIBUTE10
			,A.ATTRIBUTE3
		FROM SCM_DNM_PRODUCT_RESULT_V R	WITH(NOLOCK)
		INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
            ON CONVERT(NVARCHAR(8), R.PLAN_DATE,112)  = C.BASIS_YYYYMMDD
		LEFT OUTER JOIN SCP_MST_FINAL_ITEM B WITH(NOLOCK)
            ON R.DIVISION_ID          = B.DIVISION_ID
           AND R.ITEM_ID              = B.ITEM_ID
           AND R.SCP_OPERATION_GROUP  = B.OPERATION_GROUP
		INNER JOIN #TblDynamicPivot_SCP0044_RESULT A WITH(NOLOCK)
            ON A.MEASURE              ='PRODUCTION'
					 AND A.DIVISION_ID          = R.DIVISION_ID
					 AND A.OPERATION_GROUP      = R.SCP_OPERATION_GROUP
					 AND A.FROM_SITE            = R.SCM_SITE_ID
					 AND A.ITEM_ID              = R.ITEM_ID
					 AND A.ATTRIBUTE9           = R.OPERATION_ID
					 AND A.TRANSPORT_MODE_LINE  = R.LINE_ID
		WHERE 1=1
			AND R.PLAN_DATE     >= CONVERT(DATETIME, @v_from_result)
			AND R.PLAN_DATE     <  CONVERT(DATETIME, @v_to_result )
			AND R.DIVISION_ID   = @p_division_id
			AND R.SCP_OPERATION_GROUP IN ('A','P')
			AND ( LEFT(R.OPERATION_ID,5) IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
											                  SELECT SEGMENT1 AS OPERATION_ID
												                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
											                  WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
												                  AND SEGMENT1    <> 'F6000'
												                  AND VALID_YN    = 'Y'
                                       )
				    OR R.OPERATION_ID     IN (--외주PACKER의 업체코드
											                  SELECT PLANT_ID  AS OPERATION_ID
											                  FROM SCM_MST_SITE WITH(NOLOCK)
											                  WHERE 1=1
											                  AND DIVISION_ID = @p_division_id
											                  AND SITE_TYPE   = 'PLANT'
											                  AND OSP_YN      = 'Y'
											                  AND VALID_YN    = 'Y'
											            )
         )
		;


	IF( @debug_mode ='T')
		PRINT 'Input Supply set End. '+CONVERT(CHAR(23), GETDATE(), 21)

		-- 2. 출하실적 insert
		INSERT INTO #TblDynamicPivot_SCP0044
		SELECT   R.DIVISION_ID
			    ,A.OPERATION_GROUP
			    ,A.CELL_ITEM_ID
			    ,A.ITEM_ID
			    ,A.CONVERT_QTY_CELL
			    ,A.TO_SITE
			    ,A.TO_BOH_QTY
			    ,A.FROM_BOH_QTY
			    ,A.INCOTERMS
			    ,A.FROM_SITE
			    ,A.TRANSPORT_MODE_LINE
			    ,A.MEASURE
			    ,R.EXFACTORY_DATE AS B_YYYYMMDD
			    ,'D_'+R.EXFACTORY_DATE  AS YYYYMMDD
			    ,C.BASIS_YYYYMM AS YYYYMM
			    ,R.EXFACTORY_QTY AS QTY
			    ,RIGHT(C.BASIS_YYYYMM,4)+C.ISO_WEEK AS ISO_WEEK
			    ,A.SORT_ORDER_NO
			    ,A.COLUMN_LABEL_NAME
			    ,A.BOD_ID
			    ,A.ATTRIBUTE9
			    ,A.ATTRIBUTE10
			    ,A.ATTRIBUTE3
		  FROM SCM_DNM_EXFACTORY_RESULT R	WITH(NOLOCK)
		  INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
              ON R.EXFACTORY_DATE = C.BASIS_YYYYMMDD
		  LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
              ON B.SCM_SITE_ID    = R.TO_SCM_SITE_ID
             AND B.SITE_TYPE      ='PLANT'
		  INNER JOIN #TblDynamicPivot_SCP0044_RESULT A WITH(NOLOCK)
              ON A.MEASURE        ='SHIP_PLAN'
             AND A.DIVISION_ID    = R.DIVISION_ID
						 AND A.ITEM_ID        = R.ITEM_ID
						 AND A.FROM_SITE      = R.FROM_SCM_SITE_ID
						 AND A.TO_SITE        = R.TO_SCM_SITE_ID
						 AND A.TRANSPORT_MODE_LINE  = R.TRANSPORT_MODE
		WHERE 1=1
			AND R.EXFACTORY_DATE        >= CONVERT(DATETIME, @v_from_result)
			AND R.EXFACTORY_DATE        < CONVERT(DATETIME, @v_to_result )
			AND R.EXFACTORY_STATUS IN ('D20','D30','D40') -- 2019/10/21 추가
			AND R.DIVISION_ID           = @p_division_id
			AND (B.PLANT_ID IS NOT NULL OR (B.PLANT_ID IS NULL AND A.INCOTERMS=R.INCOTERMS)) -- FG의 경우 INCOTERMS 비교
		;


	IF( @debug_mode ='T')
		PRINT 'Input Shipping set End. '+CONVERT(CHAR(23), GETDATE(), 21)

		-- 3. 매출실적 insert
		INSERT INTO #TblDynamicPivot_SCP0044
		SELECT
			     R.DIVISION_ID
			    ,A.OPERATION_GROUP
			    ,A.CELL_ITEM_ID
			    ,A.ITEM_ID
			    ,A.CONVERT_QTY_CELL
			    ,A.TO_SITE
			    ,A.TO_BOH_QTY
			    ,A.FROM_BOH_QTY
			    ,A.INCOTERMS
			    ,A.FROM_SITE
			    ,A.TRANSPORT_MODE_LINE
			    ,A.MEASURE
			    ,R.YYYYMMDD AS B_YYYYMMDD
			    ,'D_'+R.YYYYMMDD  AS YYYYMMDD
			    ,C.BASIS_YYYYMM AS YYYYMM
			    ,R.QTY AS QTY
			    ,RIGHT(C.BASIS_YYYYMM,4)+C.ISO_WEEK AS ISO_WEEK
			    ,A.SORT_ORDER_NO
			    ,A.COLUMN_LABEL_NAME
			    ,A.BOD_ID
			    ,A.ATTRIBUTE9
			    ,A.ATTRIBUTE10
			    ,A.ATTRIBUTE3
		FROM DM_PLN_SALES_PLAN_RESULT R	WITH(NOLOCK)
		INNER JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
            ON R.YYYYMMDD = C.BASIS_YYYYMMDD
		--JOIN SCM_MST_SITE B ON B.SCM_SITE_ID = R.PLANT_SITE_ID AND B.SITE_TYPE='PLANT'
		INNER JOIN #TblDynamicPivot_SCP0044_RESULT A WITH(NOLOCK)
            ON A.MEASURE      = 'ALLOCATION'
					 AND A.DIVISION_ID  = R.DIVISION_ID
					 AND A.ITEM_ID      = R.ITEM_ID
					 AND A.TO_SITE      = R.SCM_SITE_ID
					 AND A.INCOTERMS    = R.INCOTERMS
		WHERE 1=1
			AND R.YYYYMMDD          >= CONVERT(DATETIME, @v_from_result)
			AND R.YYYYMMDD          < CONVERT(DATETIME, @v_to_result )
			AND R.DIVISION_ID       = @p_division_id
			AND R.MEASURE           = 'RTF'
		;


	IF( @debug_mode ='T')
		PRINT 'Input RTF set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	END

	/********************************************************************************
	* PIVOIT처리
	********************************************************************************/
	begin
		DECLARE @mQry_sum NVARCHAR(MAX);

		-- PIVOIT 대상 날짜문자열 생성
		SET @mQry_sum = '';

		/*
		SELECT  @mQry_sum = @mQry_sum+','+
			CASE WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN yyyymm   = RIGHT('''+yyyymmdd+''',6) THEN QTY END )  AS ' + yyyymmdd
				 WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN iso_week = RIGHT('''+yyyymmdd+''', 6) THEN QTY END ) AS ' + yyyymmdd
				 WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN yyyymmdd = '''+yyyymmdd+''' THEN QTY END ) AS ' + yyyymmdd
			END +''+CHAR(10)
		*/
		SELECT  @mQry_sum = @mQry_sum+','+
			CASE  WHEN CHARINDEX('M_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN YYYYMMDD = '''+yyyymmdd+''' THEN QTY WHEN MEASURE!=''LINE_TOTAL_LOAD_ENGINE'' AND yyyymm   = RIGHT('''+yyyymmdd+''', 6) THEN QTY END ) AS ' + yyyymmdd
				    WHEN CHARINDEX('W_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN YYYYMMDD = '''+yyyymmdd+''' THEN QTY WHEN MEASURE!=''LINE_TOTAL_LOAD_ENGINE'' AND iso_week = RIGHT('''+yyyymmdd+''', 6) THEN QTY END ) AS ' + yyyymmdd
				    WHEN CHARINDEX('D_', yyyymmdd) =1 THEN  ' SUM(CASE WHEN YYYYMMDD = '''+yyyymmdd+''' THEN QTY END ) AS ' + yyyymmdd
			END +''+CHAR(10)
		FROM (
			SELECT 'W_'+A.BASIS_YYYYMM + A.ISO_WEEK AS YYYYMMDD
				, A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
			FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)
			WHERE a.basis_yyyymmdd  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
			UNION ALL
			SELECT 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
			  ,MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
			FROM DBO.SCM_SYS_CALENDAR_M A WITH(NOLOCK)
			WHERE A.BASIS_YYYYMMDD  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
			UNION ALL
			SELECT 'D_'+A.BASIS_YYYYMMDD   AS YYYYMMDD
			  , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
			FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK)
			WHERE A.BASIS_YYYYMMDD  BETWEEN @p_from_yyyymmdd AND @p_to_yyyymmdd
			GROUP BY A.BASIS_YYYYMMDD
		) AS A
		ORDER BY SORT_ORDER_NO  ;

		-----------------------------------------------------------
		-- DEBUG QRY 출력
		-----------------------------------------------------------
		--IF( @debug_mode ='T')
			--BEGIN
				--SET @POS =1;
				--SET @LEN =LEN(@mQry_sum);
				--WHILE @POS <= @LEN
					--BEGIN
						--PRINT SUBSTRING(@mQry_sum,@POS,4000);
						--SET @POS = @POS+4000;
					--END;
			--END;


      --SELECT * INTO ##TblDynamicPivot_SCP0044
      --FROM #TblDynamicPivot_SCP0044

		SET @mEXEC = '';

		-- 주의 : 조회항목 변경 시 M_,W_,D_ 컬럼이 항상 뒤에 나와야함
		--        UI에서 합계계산 시 COLUMN COUNT INDEX 계산
		SET @mEXEC = @mEXEC + 'SELECT CASE WHEN A.BOD_ID=''-'' THEN ''-''
                                        ELSE CONVERT(NVARCHAR(50), (	                  '+CHAR(10);

		--PJ20209642 : BOD LT 1단계 개발 ( scp_mst_bod_v.lt_total 로 변경)
		--SET @mEXEC = @mEXEC + '										CASE	WHEN ISNULL(L.SEGMENT3, '''') = ''''  THEN ISNULL(R.LT_DEPARTURE_INLAND, 0) + ISNULL(R.LT_WAIT_SHIPPING, 0) + ISNULL(R.LT_VOYAGE, 0) + ISNULL(R.LT_LAY_OFF_CLEARANCE, 0) + ISNULL(R.LT_ARRIVAL_INLAND, 0)  '+CHAR(10);
  --  SET @MEXEC = @MEXEC + '												  WHEN L.SEGMENT3  = ''A''              THEN  0				                  '+CHAR(10);
  --  SET @MEXEC = @MEXEC + '												  WHEN L.SEGMENT3  = ''B''              THEN  ISNULL(R.LT_DEPARTURE_INLAND, 0)			'+CHAR(10);
  --  SET @MEXEC = @MEXEC + '												  WHEN L.SEGMENT3  = ''C''              THEN  ISNULL(R.LT_DEPARTURE_INLAND, 0) + ISNULL(R.LT_WAIT_SHIPPING, 0)			'+CHAR(10);
  --  SET @MEXEC = @MEXEC + '												  WHEN L.SEGMENT3  = ''D''              THEN  ISNULL(R.LT_DEPARTURE_INLAND, 0) + ISNULL(R.LT_WAIT_SHIPPING, 0) + ISNULL(R.LT_VOYAGE, 0)			'+CHAR(10);
  --  SET @MEXEC = @MEXEC + '												  WHEN L.SEGMENT3  = ''E''              THEN  ISNULL(R.LT_DEPARTURE_INLAND, 0) + ISNULL(R.LT_WAIT_SHIPPING, 0) + ISNULL(R.LT_VOYAGE, 0) + ISNULL(R.LT_LAY_OFF_CLEARANCE, 0)			'+CHAR(10);
  --  SET @MEXEC = @MEXEC + '												  WHEN L.SEGMENT3  = ''F''              THEN  ISNULL(R.LT_DEPARTURE_INLAND, 0) + ISNULL(R.LT_WAIT_SHIPPING, 0) + ISNULL(R.LT_VOYAGE, 0) + ISNULL(R.LT_LAY_OFF_CLEARANCE, 0) + ISNULL(R.LT_ARRIVAL_INLAND, 0)	    '+CHAR(10);
  --  SET @MEXEC = @MEXEC + '												  ELSE                                        ISNULL(R.LT_DEPARTURE_INLAND, 0) + ISNULL(R.LT_WAIT_SHIPPING, 0) + ISNULL(R.LT_VOYAGE, 0) + ISNULL(R.LT_LAY_OFF_CLEARANCE, 0) + ISNULL(R.LT_ARRIVAL_INLAND, 0)	    '+CHAR(10);
		--SET @MEXEC = @MEXEC + '										END ) ) END AS LT_DAY			                '+CHAR(10);
		SET @mEXEC = @mEXEC + '		     B.lt_total )) END AS LT_DAY											'+CHAR(10);
		SET @MEXEC = @MEXEC + '        , ISNULL(NULLIF( A.CONVERT_QTY_CELL, '''') , ''-'') AS CELL_QTY_PACK		'+CHAR(10);
		-- 20220125 vadabi3 DC Link Sort 적용 (Rack_YN, DC_YN Sort 적용)
		SET @mEXEC = @mEXEC + '		   , v.RACK_YN																'+CHAR(10);
		SET @mEXEC = @mEXEC + '		   , v.DC_YN																'+CHAR(10);
		SET @mEXEC = @mEXEC + '        , A.*																                '+CHAR(10);
		SET @mEXEC = @mEXEC + '        , dbo.FN_GET_SCP_CELL_TYPE_SORT(v.cell_type) AS cell_type_sort '+CHAR(10); -- 20230613 Final Item) Cell Type Sort
		SET @mEXEC = @mEXEC + ' FROM (																			                '+CHAR(10);
		SET @mEXEC = @mEXEC + ' SELECT    A.DIVISION_ID											                '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.OPERATION_GROUP									                '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.CELL_ITEM_ID										                '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ITEM_ID													                '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, (SELECT TOP 1 (CASE WHEN X.NICK_NAME IS NULL THEN ''-''  WHEN X.NICK_NAME = ''''    THEN ''-''  ELSE X.NICK_NAME END) FROM DBO.SCM_MST_ITEM_SN X WITH (NOLOCK)  WHERE  X.ITEM_ID  = A.ITEM_ID) AS NICK_NAME		          '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.CONVERT_QTY_CELL                                           '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_SITE													                                              '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, ISNULL(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION
                                                        FROM SCM_MST_SITE M WITH (NOLOCK)
                                                       WHERE M.SCM_SITE_ID  = A.TO_SITE
                                                       ), '''') , ''-'') AS TO_SITE_DESCRIPTION	                      '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_BOH_QTY											                                              '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_BOH_QTY										                                              '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, ISNULL(NULLIF( A.INCOTERMS, '''') , ''-'') AS INCOTERMS									        '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_SITE												                                              '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, ISNULL(NULLIF( (SELECT TOP 1 M.SITE_DESCRIPTION
                                                        FROM SCM_MST_SITE M WITH (NOLOCK)
                                                       WHERE M.SCM_SITE_ID  = A.FROM_SITE
                                                       ), '''') , ''-'') AS FROM_SITE_DESCRIPTION	                    '+CHAR(10);
		SET @MEXEC = @MEXEC + ' 				, ISNULL(NULLIF( A.TRANSPORT_MODE_LINE, '''') , ''-'') AS TRANSPORT_MODE_LINE		  '+CHAR(10);
		SET @MEXEC = @MEXEC + ' 				, (CASE WHEN A.OPERATION_GROUP =''P''  THEN ''-'' ELSE A.BOD_ID END) AS BOD_ID	  '+CHAR(10);
		SET @MEXEC = @MEXEC + ' 				, A.ATTRIBUTE10										                  '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.MEASURE											                    '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.COLUMN_LABEL_NAME MEASURE_LABEL	                '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.SORT_ORDER_NO									                  '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE3 AS MEASURE_COLOR			                '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				' + @mQry_sum +'									                  '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 		FROM #TblDynamicPivot_SCP0044 A WITH(NOLOCK)				    '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 		GROUP BY A.DIVISION_ID									                '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.OPERATION_GROUP									                '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.CELL_ITEM_ID									                  '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ITEM_ID											                    '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.CONVERT_QTY_CELL											          '+CHAR(10);
        SET @mEXEC = @mEXEC + ' 				, A.TO_SITE											                    '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TO_BOH_QTY										                  '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_BOH_QTY									                  '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.INCOTERMS										                    '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.FROM_SITE										                    '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.TRANSPORT_MODE_LINE							                '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, (CASE WHEN A.OPERATION_GROUP =''P''  THEN ''-'' ELSE A.BOD_ID END) 	            '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE10										                  '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.MEASURE											                    '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.SORT_ORDER_NO									                  '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.COLUMN_LABEL_NAME								                '+CHAR(10);
		SET @mEXEC = @mEXEC + ' 				, A.ATTRIBUTE3										                  '+CHAR(10);
		SET @mEXEC = @mEXEC + '      ) A															                      '+CHAR(10);

		--PJ20209642 : BOD LT 1단계 개발 ( scp_mst_bod_v.lt_total 로 변경)
		--SET @mEXEC = @mEXEC + '      LEFT JOIN SCP_MST_BOD B WITH(NOLOCK)		                '+CHAR(10);
		--SET @mEXEC = @mEXEC + '				      ON B.DIVISION_ID  = A.DIVISION_ID               '+CHAR(10);
  --  SET @mEXEC = @mEXEC + '				     AND B.BOD_ID       = A.BOD_ID                    '+CHAR(10);
  --  SET @mEXEC = @mEXEC + '				     AND B.FROM_SITE    = A.FROM_SITE 			          '+CHAR(10);
		--SET @mEXEC = @mEXEC + '      LEFT JOIN SCP_MST_DISTRIBUTION_ROUTE R WITH(NOLOCK)    '+CHAR(10);
		--SET @mEXEC = @mEXEC + '				      ON R.ROUTE_ID     = B.ROUTE_ID								  '+CHAR(10);
		--SET @mEXEC = @mEXEC + '      LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  '+CHAR(10);
		--SET @mEXEC = @mEXEC + '				ON L.LOOKUP_TYPE  = ''INCOTERMS''                     '+CHAR(10);
  --  SET @mEXEC = @mEXEC + '				AND L.VALID_YN    = ''Y''                             '+CHAR(10);
  --  SET @mEXEC = @mEXEC + '				AND B.INCOTERMS   = L.SEGMENT1		                    '+CHAR(10);
		-- BOD 2단계 : scp_mst_bod_v -> scp_mst_bod_n_v
		--SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_bod_v b WITH(NOLOCK)																'+CHAR(10);

		SET @mEXEC = @mEXEC + '      LEFT JOIN scp_mst_bod_n_v b WITH(NOLOCK)															'+CHAR(10);
		SET @mEXEC = @mEXEC + '				ON B.DIVISION_ID=A.DIVISION_ID AND B.BOD_ID=A.BOD_ID AND B.FROM_SITE=A.FROM_SITE 			'+CHAR(10);

		-- 20220125 vadabi3 DC Link Sort 적용 (Rack_YN, DC_YN Sort 적용)
		SET @mEXEC = @mEXEC + '      LEFT JOIN scm_mst_final_item_v v 									                                    '+CHAR(10);
		SET @mEXEC = @mEXEC + '				ON v.DIVISION_ID=A.DIVISION_ID AND v.ITEM_ID=A.ITEM_ID AND v.OPERATION_GROUP_ID=A.OPERATION_GROUP  '+CHAR(10);
	  --SET @mEXEC = @mEXEC + '		INNER JOIN scm_adm_lookup_master_detail m ON m.segment1 = v.operation_group_id  '+CHAR(10);




		-- BOD 2단계
		--SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP DESC, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE DESC, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.MEASURE_LABEL DESC		'+CHAR(10);
		--SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP DESC, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE DESC, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.BOD_ID , A.MEASURE_LABEL DESC		'+CHAR(10);
		-- 20220125 vadabi3 DC Link Sort 적용 (Rack_YN, DC_YN Sort 적용)
	    SET @mEXEC = @mEXEC + ' 	 ORDER BY A.DIVISION_ID, A.CELL_ITEM_ID, A.OPERATION_GROUP DESC, v.RACK_YN DESC, v.DC_YN DESC, cell_type_sort, A.ITEM_ID,A.ATTRIBUTE10, A.TO_SITE DESC, A.INCOTERMS, A.FROM_SITE, A.SORT_ORDER_NO, A.TRANSPORT_MODE_LINE, A.BOD_ID , A.MEASURE_LABEL DESC		'+CHAR(10);




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

		IF( @debug_mode ='T')
				PRINT 'Input Pivot set End. '+CONVERT(CHAR(23), GETDATE(), 21)

	END;

	--임시테이블 삭제
	IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0044_item') is not null
		DROP TABLE #TblDynamicPivot_SCP0044_item

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_TEMP') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0044_TEMP

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_NICKITEM') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0044_NICKITEM

	IF OBJECT_ID('tempdb.dbo.#TblDynamicPivot_SCP0044') is not null
		DROP TABLE #TblDynamicPivot_SCP0044

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_RANK') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0044_RANK

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_MEASURE') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0044_MEASURE

	--생산실적, 출하실적 용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_RESULT') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0044_RESULT;

	--로드률 용
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCP0044_LOAD') IS NOT NULL
		DROP TABLE #TblDynamicPivot_SCP0044_LOAD;

END


