/*
* Program ID   : SCP0092_GET_SQL_SUMMARY_PIVOT
* Description  :
* Program History
*===================================================================================================
* Date         In Charge       Description
*===================================================================================================
* 2022/04/29   chaan            V1.0    Initial Release SCP0092_GET_RTF_ARCHEIVEMENT_RATE_SUMMARY 에서 호출
* 2022.05.30	chaan           V1.4    Weekly 수정후 기준 변경
* 2022.06.17	chaan           V1.6    cell 컬럼 생성 오류 수정
* 2022.06.22	chaan           V1.7    주별 금액 오류 수정
* 2022.07.01	chaan           V1.1.   프로시저명 변경 (GET_SQL_SCP0092_SUMMARY_PIVOT -> SCP0092_GET_SQL_SUMMARY_PIVOT)
* 2022/07/04   chaan		    V1.1.2  CATEGORY 대상 테이블 및 컬럼 변경 (SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT3 -> SCP_MST_FINAL_ITEM.GROUP_CODE5)
* 2022/07/15    chaan		    V1.1.3  CATEGORY 미입력항목 '기타' 로 표기
                                        소계 정렬용 DISPLAY_SEQ 추가
* 2022/09/26    chaan           V1.1.4  CATEGORY_NAME 이 '기타' 이면 제일 뒤로 위치
* 2022/12/16    chaan           V1.1.5  Sub2 집계중 동일 Category Code 가 존재하여 누락되는 오류 수정
                                        - Join 에 'CATEGORY_NAME' 추가
                                        - PIVIOT 전 서브쿼리에서 값을 다음 키별로 Sum
                                            DIVISION_ID
                                            CATEGORY_CODE
                                            CATEGORY_NAME
                                            WEEK_NAME
*                                                                                                  
*/


--CREATE PROCEDURE [dbo].[GET_SQL_SCP0092_SUMMARY_PIVOT]
CREATE PROCEDURE [dbo].[SCP0092_GET_SQL_SUMMARY_PIVOT]
(
    @p_pivot_table_name   NVARCHAR(MAX),            -- #TBL_SCP0092_PIVOT
    @p_raw_table_name     NVARCHAR(MAX),            -- #TBL_SCP0092_RAW

    @p_ww_pivot_cols      NVARCHAR(MAX),
    @p_mm_pivot_cols      NVARCHAR(MAX),
    @p_yyyy_pivot_cols    NVARCHAR(MAX),
    @p_final_cols         NVARCHAR(MAX),
                          
    @p_ww_sql             NVARCHAR(MAX) OUTPUT,
    @p_mm_sql             NVARCHAR(MAX) OUTPUT,
    @p_yyyy_sql           NVARCHAR(MAX) OUTPUT,
    @p_final_sql          NVARCHAR(MAX) OUTPUT
)
AS    
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

    --DECLARE @p_pivot_table_name   NVARCHAR(MAX)             = '#TBL_SCP0092_PIVOT_SUB2';
    --DECLARE @p_raw_table_name     NVARCHAR(MAX)             = '#TBL_SCP0092_RAW_ESS_SUB2';
    --DECLARE @p_ww_pivot_cols      NVARCHAR(MAX)             = '[W01],[W02],[W03],[W04],[W05],[W06],[W07],[W08],[W09],[W10],[W11],[W12],[W13],[W14],[W15],[W16],[W17],[W18],[W19],[W20],[W21],[W22],[W23],[W24],[W25],[W26],[W27],[W28],[W29],[W30],[W31],[W32],[W33],[W34],[W35],[W36],[W37],[W38],[W39],[W40],[W41],[W42],[W43],[W44],[W45],[W46],[W47],[W48],[W49],[W50],[W51],[W52]';
    --DECLARE @p_mm_pivot_cols      NVARCHAR(MAX)             = '[01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12]';
    --DECLARE @p_yyyy_pivot_cols    NVARCHAR(MAX)             = '[2022]';
    --DECLARE @p_final_cols         NVARCHAR(MAX)             = ', M.[01] AS [M_202201], M.[01_CELL] AS [M_202201_CELL], W.[W01] AS [W_20220101], W.[W01_CELL] AS [W_20220101_CELL], W.[W02] AS [W_20220102], W.[W02_CELL] AS [W_20220102_CELL], W.[W03] AS [W_20220103], W.[W03_CELL] AS [W_20220103_CELL], W.[W04] AS [W_20220104], W.[W04_CELL] AS [W_20220104_CELL], M.[02] AS [M_202202], M.[02_CELL] AS [M_202202_CELL], W.[W05] AS [W_20220205], W.[W05_CELL] AS [W_20220205_CELL], W.[W06] AS [W_20220206], W.[W06_CELL] AS [W_20220206_CELL], W.[W07] AS [W_20220207], W.[W07_CELL] AS [W_20220207_CELL], W.[W08] AS [W_20220208], W.[W08_CELL] AS [W_20220208_CELL], M.[03] AS [M_202203], M.[03_CELL] AS [M_202203_CELL], W.[W09] AS [W_20220309], W.[W09_CELL] AS [W_20220309_CELL], W.[W10] AS [W_20220310], W.[W10_CELL] AS [W_20220310_CELL], W.[W11] AS [W_20220311], W.[W11_CELL] AS [W_20220311_CELL], W.[W12] AS [W_20220312], W.[W12_CELL] AS [W_20220312_CELL], W.[W13] AS [W_20220313], W.[W13_CELL] AS [W_20220313_CELL], M.[04] AS [M_202204], M.[04_CELL] AS [M_202204_CELL], W.[W14] AS [W_20220414], W.[W14_CELL] AS [W_20220414_CELL], W.[W15] AS [W_20220415], W.[W15_CELL] AS [W_20220415_CELL], W.[W16] AS [W_20220416], W.[W16_CELL] AS [W_20220416_CELL], W.[W17] AS [W_20220417], W.[W17_CELL] AS [W_20220417_CELL], M.[05] AS [M_202205], M.[05_CELL] AS [M_202205_CELL], W.[W18] AS [W_20220518], W.[W18_CELL] AS [W_20220518_CELL], W.[W19] AS [W_20220519], W.[W19_CELL] AS [W_20220519_CELL], W.[W20] AS [W_20220520], W.[W20_CELL] AS [W_20220520_CELL], W.[W21] AS [W_20220521], W.[W21_CELL] AS [W_20220521_CELL], M.[06] AS [M_202206], M.[06_CELL] AS [M_202206_CELL], W.[W22] AS [W_20220622], W.[W22_CELL] AS [W_20220622_CELL], W.[W23] AS [W_20220623], W.[W23_CELL] AS [W_20220623_CELL], W.[W24] AS [W_20220624], W.[W24_CELL] AS [W_20220624_CELL], W.[W25] AS [W_20220625], W.[W25_CELL] AS [W_20220625_CELL], W.[W26] AS [W_20220626], W.[W26_CELL] AS [W_20220626_CELL], M.[07] AS [M_202207], M.[07_CELL] AS [M_202207_CELL], W.[W27] AS [W_20220727], W.[W27_CELL] AS [W_20220727_CELL], W.[W28] AS [W_20220728], W.[W28_CELL] AS [W_20220728_CELL], W.[W29] AS [W_20220729], W.[W29_CELL] AS [W_20220729_CELL], W.[W30] AS [W_20220730], W.[W30_CELL] AS [W_20220730_CELL], M.[08] AS [M_202208], M.[08_CELL] AS [M_202208_CELL], W.[W31] AS [W_20220831], W.[W31_CELL] AS [W_20220831_CELL], W.[W32] AS [W_20220832], W.[W32_CELL] AS [W_20220832_CELL], W.[W33] AS [W_20220833], W.[W33_CELL] AS [W_20220833_CELL], W.[W34] AS [W_20220834], W.[W34_CELL] AS [W_20220834_CELL], M.[09] AS [M_202209], M.[09_CELL] AS [M_202209_CELL], W.[W35] AS [W_20220935], W.[W35_CELL] AS [W_20220935_CELL], W.[W36] AS [W_20220936], W.[W36_CELL] AS [W_20220936_CELL], W.[W37] AS [W_20220937], W.[W37_CELL] AS [W_20220937_CELL], W.[W38] AS [W_20220938], W.[W38_CELL] AS [W_20220938_CELL], W.[W39] AS [W_20220939], W.[W39_CELL] AS [W_20220939_CELL], M.[10] AS [M_202210], M.[10_CELL] AS [M_202210_CELL], W.[W40] AS [W_20221040], W.[W40_CELL] AS [W_20221040_CELL], W.[W41] AS [W_20221041], W.[W41_CELL] AS [W_20221041_CELL], W.[W42] AS [W_20221042], W.[W42_CELL] AS [W_20221042_CELL], W.[W43] AS [W_20221043], W.[W43_CELL] AS [W_20221043_CELL], M.[11] AS [M_202211], M.[11_CELL] AS [M_202211_CELL], W.[W44] AS [W_20221144], W.[W44_CELL] AS [W_20221144_CELL], W.[W45] AS [W_20221145], W.[W45_CELL] AS [W_20221145_CELL], W.[W46] AS [W_20221146], W.[W46_CELL] AS [W_20221146_CELL], W.[W47] AS [W_20221147], W.[W47_CELL] AS [W_20221147_CELL], M.[12] AS [M_202212], M.[12_CELL] AS [M_202212_CELL], W.[W48] AS [W_20221248], W.[W48_CELL] AS [W_20221248_CELL], W.[W49] AS [W_20221249], W.[W49_CELL] AS [W_20221249_CELL], W.[W50] AS [W_20221250], W.[W50_CELL] AS [W_20221250_CELL], W.[W51] AS [W_20221251], W.[W51_CELL] AS [W_20221251_CELL], W.[W52] AS [W_20221252], W.[W52_CELL] AS [W_20221252_CELL]';
    --DECLARE @p_ww_sql             NVARCHAR(MAX)             = ''
    --DECLARE @p_mm_sql             NVARCHAR(MAX)             = ''
    --DECLARE @p_yyyy_sql           NVARCHAR(MAX)             = ''
    --DECLARE @p_final_sql          NVARCHAR(MAX)             = ''


    DECLARE @v_ww_pivot_cols_cell           NVARCHAR(MAX) = REPLACE(@p_ww_pivot_cols,               ']', '_CELL]');
    DECLARE @v_mm_pivot_cols_cell           NVARCHAR(MAX) = REPLACE(@p_mm_pivot_cols,               ']', '_CELL]');
    DECLARE @v_yyyy_pivot_cols_cell         NVARCHAR(MAX) = REPLACE(@p_yyyy_pivot_cols,             ']', '_CELL]');
                                            
    DECLARE @v_ww_pivot_cols_max            NVARCHAR(MAX) = REPLACE(REPLACE(@p_ww_pivot_cols,       '[', 'MAX(['), ']', '])');
    DECLARE @v_mm_pivot_cols_max            NVARCHAR(MAX) = REPLACE(REPLACE(@p_mm_pivot_cols,       '[', 'MAX(['), ']', '])');
    DECLARE @v_yyyy_pivot_cols_max          NVARCHAR(MAX) = REPLACE(REPLACE(@p_yyyy_pivot_cols,     '[', 'MAX(['), ']', '])');

    DECLARE @v_ww_pivot_cols_max_cell       NVARCHAR(MAX) = REPLACE(REPLACE(@v_ww_pivot_cols_cell,  '[', 'MAX(['), ']', '])');
    DECLARE @v_mm_pivot_cols_max_cell       NVARCHAR(MAX) = REPLACE(REPLACE(@v_mm_pivot_cols_cell,  '[', 'MAX(['), ']', '])');
    DECLARE @v_yyyy_pivot_cols_max_cell     NVARCHAR(MAX) = REPLACE(REPLACE(@v_yyyy_pivot_cols_cell,'[', 'MAX(['), ']', '])');

    --DECLARE @v_ww_pivot_cols_max            NVARCHAR(MAX) = REPLACE(REPLACE(@p_ww_pivot_cols,       '[', 'SUM(['), ']', '])');
    --DECLARE @v_mm_pivot_cols_max            NVARCHAR(MAX) = REPLACE(REPLACE(@p_mm_pivot_cols,       '[', 'SUM(['), ']', '])');
    --DECLARE @v_yyyy_pivot_cols_max          NVARCHAR(MAX) = REPLACE(REPLACE(@p_yyyy_pivot_cols,     '[', 'SUM(['), ']', '])');

    --DECLARE @v_ww_pivot_cols_max_cell       NVARCHAR(MAX) = REPLACE(REPLACE(@v_ww_pivot_cols_cell,  '[', 'SUM(['), ']', '])');
    --DECLARE @v_mm_pivot_cols_max_cell       NVARCHAR(MAX) = REPLACE(REPLACE(@v_mm_pivot_cols_cell,  '[', 'SUM(['), ']', '])');
    --DECLARE @v_yyyy_pivot_cols_max_cell     NVARCHAR(MAX) = REPLACE(REPLACE(@v_yyyy_pivot_cols_cell,'[', 'SUM(['), ']', '])');


/*
SET @SQL_WW = '
INSERT INTO #TBL_SCP0092_PIVOT_WW
(
    DIVISION_ID,
    CATEGORY_CODE,
    CATEGORY_NAME,
    RPT_MEASURE,
    ' + @WW_PIVOT_COLS + ',
    DISPLAY_SEQ,
    USER_SORT_ORDER_NO
)
    SELECT    X.*
            , G.DISPLAY_SEQ
            , M.USER_SORT_ORDER_NO
    FROM
            (
                SELECT  *
                FROM    (
                            SELECT	  T.DIVISION_ID
		                            , T.CATEGORY_CODE
		                            , T.CATEGORY_NAME
                                    , T.WEEK_NAME
                                    , ''RTF'' AS RPT_MEASURE
                                    , T.RTF
                            FROM    #TBL_SCP0092_RAW_WW T
                        ) AS A
                PIVOT   (
                            SUM(RTF) FOR WEEK_NAME IN (' + @WW_PIVOT_COLS + ')
                        ) AS RTF
                UNION
                SELECT  *
                FROM    (
                            SELECT	  T.DIVISION_ID
		                            , T.CATEGORY_CODE
		                            , T.CATEGORY_NAME
                                    , T.WEEK_NAME
                                    , ''RESULT'' AS RPT_MEASURE
                                    , T.RESULT
                            FROM    #TBL_SCP0092_RAW_WW T
                        ) AS B
                PIVOT   (
                            SUM(RESULT) FOR WEEK_NAME IN (' + @WW_PIVOT_COLS + ')
                        ) AS RES
                UNION
                SELECT  *
                FROM    (
                            SELECT	  T.DIVISION_ID
		                            , T.CATEGORY_CODE
		                            , T.CATEGORY_NAME
                                    , T.WEEK_NAME
                                    , ''RESULT_WITH_RTF'' AS RPT_MEASURE
                                    , T.RESULT_WITH_RTF
                            FROM    #TBL_SCP0092_RAW_WW T
                        ) AS C
                PIVOT   (
                            SUM(RESULT_WITH_RTF) FOR WEEK_NAME IN (' + @WW_PIVOT_COLS + ')
                        ) AS RWR
                UNION
                SELECT  *
                FROM    (
                            SELECT	  T.DIVISION_ID
		                            , T.CATEGORY_CODE
		                            , T.CATEGORY_NAME
                                    , T.WEEK_NAME
                                    , ''RATE'' AS RPT_MEASURE
                                    , (T.RATE * 100) AS RATE
                            FROM    #TBL_SCP0092_RAW_WW T
                        ) AS D
                PIVOT   (
                            SUM(RATE) FOR WEEK_NAME IN (' + @WW_PIVOT_COLS + ')
                        ) AS RATE
            ) X
            LEFT JOIN #TBL_SCP0092_CATEGORY G ON
                    X.DIVISION_ID   = G.DIVISION_ID
                AND X.CATEGORY_CODE    = G.SEGMENT2
            LEFT JOIN #TBL_SCP0092_MEASURE M ON
                    LTRIM(RTRIM(X.RPT_MEASURE)) = M.MEASURE
    ORDER BY      X.DIVISION_ID
                , G.DISPLAY_SEQ
                , M.USER_SORT_ORDER_NO';

PRINT @SQL_WW;

EXEC(@SQL_WW);

--select * from #TBL_SCP0092_PIVOT_YYYY;return;


SET @SQL_MM = '
INSERT INTO #TBL_SCP0092_PIVOT_MM
(
    DIVISION_ID,
    CATEGORY_CODE,
    CATEGORY_NAME,
    RPT_MEASURE,
    ' + @MM_PIVOT_COLS + '
)
SELECT    X.*
FROM
        (
            SELECT  *
            FROM    (
                        SELECT	  T.DIVISION_ID
		                        , T.CATEGORY_CODE
		                        , T.CATEGORY_NAME
                                , T.MM
                                , ''RTF'' AS RPT_MEASURE
                                , T.RTF
                        FROM    #TBL_SCP0092_RAW_MM T
                    ) AS A
            PIVOT   (
                        SUM(RTF) FOR MM IN (' + @MM_PIVOT_COLS + ')
                    ) AS RTF
            UNION
            SELECT  *
            FROM    (
                        SELECT	  T.DIVISION_ID
		                        , T.CATEGORY_CODE
		                        , T.CATEGORY_NAME
                                , T.MM
                                , ''RESULT'' AS RPT_MEASURE
                                , T.RESULT
                        FROM    #TBL_SCP0092_RAW_MM T
                    ) AS B
            PIVOT   (
                        SUM(RESULT) FOR MM IN (' + @MM_PIVOT_COLS + ')
                    ) AS RES
            UNION
            SELECT  *
            FROM    (
                        SELECT	  T.DIVISION_ID
		                        , T.CATEGORY_CODE
		                        , T.CATEGORY_NAME
                                , T.MM
                                , ''RESULT_WITH_RTF'' AS RPT_MEASURE
                                , T.RESULT_WITH_RTF
                        FROM    #TBL_SCP0092_RAW_MM T
                    ) AS C
            PIVOT   (
                        SUM(RESULT_WITH_RTF) FOR MM IN (' + @MM_PIVOT_COLS + ')
                    ) AS RWR
            UNION
            SELECT  *
            FROM    (
                        SELECT	  T.DIVISION_ID
		                        , T.CATEGORY_CODE
		                        , T.CATEGORY_NAME
                                , T.MM
                                , ''RATE'' AS RPT_MEASURE
                                , (T.RATE * 100) AS RATE
                        FROM    #TBL_SCP0092_RAW_MM T
                    ) AS D
            PIVOT   (
                        SUM(RATE) FOR MM IN (' + @MM_PIVOT_COLS + ')
                    ) AS RATE
        ) X';

PRINT @SQL_MM;

EXEC(@SQL_MM);


SET @SQL_YYYY = '
INSERT INTO #TBL_SCP0092_PIVOT_YYYY
(
	DIVISION_ID,
    CATEGORY_CODE,
    CATEGORY_NAME,
	RPT_MEASURE,
	[YEAR]
)
SELECT    X.*
FROM
        (
            SELECT  *
            FROM    (
                        SELECT	  T.DIVISION_ID
		                        , T.CATEGORY_CODE
		                        , T.CATEGORY_NAME
                                , T.YYYY
                                , ''RTF'' AS RPT_MEASURE
                                , T.RTF
                        FROM    #TBL_SCP0092_RAW_YYYY T
                    ) AS A
            PIVOT   (
                        SUM(RTF) FOR YYYY IN (' + @YYYY_PIVOT_COLS + ')
                    ) AS RTF
            UNION
            SELECT  *
            FROM    (
                        SELECT	  T.DIVISION_ID
		                        , T.CATEGORY_CODE
		                        , T.CATEGORY_NAME
                                , T.YYYY
                                , ''RESULT'' AS RPT_MEASURE
                                , T.RESULT
                        FROM    #TBL_SCP0092_RAW_YYYY T
                    ) AS B
            PIVOT   (
                        SUM(RESULT) FOR YYYY IN (' + @YYYY_PIVOT_COLS + ')
                    ) AS RES
            UNION
            SELECT  *
            FROM    (
                        SELECT	  T.DIVISION_ID
		                        , T.CATEGORY_CODE
		                        , T.CATEGORY_NAME
                                , T.YYYY
                                , ''RESULT_WITH_RTF'' AS RPT_MEASURE
                                , T.RESULT_WITH_RTF
                        FROM    #TBL_SCP0092_RAW_YYYY T
                    ) AS C
            PIVOT   (
                        SUM(RESULT_WITH_RTF) FOR YYYY IN (' + @YYYY_PIVOT_COLS + ')
                    ) AS RWR
            UNION
            SELECT  *
            FROM    (
                        SELECT	  T.DIVISION_ID
		                        , T.CATEGORY_CODE
		                        , T.CATEGORY_NAME
                                , T.YYYY
                                , ''RATE'' AS RPT_MEASURE
                                , (T.RATE * 100) AS RATE
                        FROM    #TBL_SCP0092_RAW_YYYY T
                    ) AS D
            PIVOT   (
                        SUM(RATE) FOR YYYY IN (' + @YYYY_PIVOT_COLS + ')
                    ) AS RATE
        ) X';

PRINT @SQL_YYYY;

EXEC(@SQL_YYYY);

SET @SQL = '
SELECT    W.DIVISION_ID
        , D.DIVISION_NAME
        , W.CATEGORY_CODE
        , W.CATEGORY_NAME
        , W.RPT_MEASURE
        ' + @V_COLS + '
        , W.DISPLAY_SEQ
        , W.USER_SORT_ORDER_NO
        , Y.[YEAR]
FROM    #TBL_SCP0092_PIVOT_WW W
        LEFT JOIN SCM_MST_DIVISION D ON
                W.DIVISION_ID = D.DIVISION_ID
        LEFT JOIN #TBL_SCP0092_PIVOT_YYYY Y ON
                W.DIVISION_ID = Y.DIVISION_ID
            AND W.CATEGORY_CODE  = Y.CATEGORY_CODE
            AND W.CATEGORY_NAME  = Y.CATEGORY_NAME
            AND W.RPT_MEASURE = Y.RPT_MEASURE
        LEFT JOIN #TBL_SCP0092_PIVOT_MM M ON
                W.DIVISION_ID = M.DIVISION_ID
            AND W.CATEGORY_CODE  = M.CATEGORY_CODE
            AND W.CATEGORY_NAME  = M.CATEGORY_NAME
            AND W.RPT_MEASURE = M.RPT_MEASURE';

*/


/*
    SET @p_ww_sql = '
    INSERT INTO ' + @p_pivot_table_name + '_WW
    (
          DIVISION_ID
        , CATEGORY_CODE
        , CATEGORY_NAME
        , RPT_MEASURE
        , ' + @p_ww_pivot_cols + '
    )
    SELECT    X.*
    FROM
            (
                SELECT  *
                FROM    (
                            SELECT	  DIVISION_ID
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , WEEK_NAME AS WW
                                    , ''RTF'' AS RPT_MEASURE
                                    , RTF
                            FROM    ' + @p_raw_table_name + '_WW T
                        ) AS A
                PIVOT   (
                            SUM(RTF) FOR WW IN (' + @p_ww_pivot_cols + ')
                        ) AS RTF
                UNION
                SELECT  *
                FROM    (
                            SELECT	  DIVISION_ID
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , WEEK_NAME AS WW
                                    , ''RESULT'' AS RPT_MEASURE
                                    , RESULT
                            FROM    ' + @p_raw_table_name + '_WW T
                        ) AS B
                PIVOT   (
                            SUM(RESULT) FOR WW IN (' + @p_ww_pivot_cols + ')
                        ) AS RES
                UNION
                SELECT  *
                FROM    (
                            SELECT	  DIVISION_ID
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , WEEK_NAME AS WW
                                    , ''RESULT_WITH_RTF'' AS RPT_MEASURE
                                    , RESULT_WITH_RTF
                            FROM    ' + @p_raw_table_name + '_WW T
                        ) AS C
                PIVOT   (
                            SUM(RESULT_WITH_RTF) FOR WW IN (' + @p_ww_pivot_cols + ')
                        ) AS RWR
                UNION
                SELECT  *
                FROM    (
                            SELECT	  DIVISION_ID
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , WEEK_NAME AS WW
                                    , LEFT(''RATE'' + SPACE(50), 50) AS RPT_MEASURE
                                    , (T.RATE * 100) AS RATE
                            FROM    ' + @p_raw_table_name + '_WW T
                        ) AS D
                PIVOT   (
                            SUM(RATE) FOR WW IN (' + @p_ww_pivot_cols + ')
                        ) AS RATE
            ) X';
*/


    SET @p_ww_sql = N'
    INSERT INTO ' + @p_pivot_table_name + '_WW
    (
          DIVISION_ID
        , CATEGORY_CODE
        , CATEGORY_NAME
        , RPT_MEASURE
        , ' + @p_ww_pivot_cols + '
        , ' + @v_ww_pivot_cols_cell + '
        , DISPLAY_SEQ
        , USER_SORT_ORDER_NO
    )
        SELECT    X.DIVISION_ID 
                , X.CATEGORY_CODE
                , X.CATEGORY_NAME
                , X.RPT_MEASURE
                , ' + @v_ww_pivot_cols_max +'
                , ' + @v_ww_pivot_cols_max_cell +'
                , G.DISPLAY_SEQ
                , M.USER_SORT_ORDER_NO
        FROM
                (
                    SELECT    DIVISION_ID 
		                    , CATEGORY_CODE
		                    , CATEGORY_NAME
                            , RPT_MEASURE
                            , ' + @p_ww_pivot_cols + '
                            , ' + @v_ww_pivot_cols_cell + '
                    FROM
                            (
                                SELECT	  DIVISION_ID
		                                , CATEGORY_CODE
		                                , CATEGORY_NAME
                                        , WEEK_NAME                 AS WW
                                        , WEEK_NAME + ''_CELL''     AS WW_CELL
                                        , ''RTF''                   AS RPT_MEASURE
                                        , RTF
                                        , RTF_CELL
                                FROM
                                        (
                                            SELECT	  DIVISION_ID
		                                            , CATEGORY_CODE
		                                            , CATEGORY_NAME
                                                    , WEEK_NAME
                                                    , SUM(RTF)                  AS RTF
                                                    , SUM(RTF_CELL)             AS RTF_CELL
                                            FROM    ' + @p_raw_table_name + '_WW T
                                            GROUP BY  DIVISION_ID
		                                            , CATEGORY_CODE
		                                            , CATEGORY_NAME
                                                    , WEEK_NAME
                                        ) S
                            ) AS A
                    PIVOT   (
                                SUM(RTF) FOR WW IN (' + @p_ww_pivot_cols + ')
                            ) AS RTF
                    PIVOT   (
                                SUM(RTF_CELL) FOR WW_CELL IN (' + @v_ww_pivot_cols_cell + ')
                            ) AS RTF_CELL
				    UNION
                    SELECT    DIVISION_ID 
		                    , CATEGORY_CODE
		                    , CATEGORY_NAME
                            , RPT_MEASURE
                            , ' + @p_ww_pivot_cols + '
                            , ' + @v_ww_pivot_cols_cell + '
                    FROM
                            (
                                SELECT	  DIVISION_ID
		                                , CATEGORY_CODE
		                                , CATEGORY_NAME
                                        , WEEK_NAME                 AS WW
                                        , WEEK_NAME + ''_CELL''     AS WW_CELL
                                        , ''RESULT''                AS RPT_MEASURE
                                        , RESULT
                                        , RESULT_CELL
                                FROM
                                        (
                                            SELECT	  DIVISION_ID
		                                            , CATEGORY_CODE
		                                            , CATEGORY_NAME
                                                    , WEEK_NAME
                                                    , SUM(RESULT)                  AS RESULT
                                                    , SUM(RESULT_CELL)             AS RESULT_CELL
                                            FROM    ' + @p_raw_table_name + '_WW T
                                            GROUP BY  DIVISION_ID
		                                            , CATEGORY_CODE
		                                            , CATEGORY_NAME
                                                    , WEEK_NAME
                                        ) S
                            ) AS A
                    PIVOT   (
                                SUM(RESULT) FOR WW IN (' + @p_ww_pivot_cols + ')
                            ) AS RTF
                    PIVOT   (
                                SUM(RESULT_CELL) FOR WW_CELL IN (' + @v_ww_pivot_cols_cell + ')
                            ) AS RTF_CELL
				    UNION
                    SELECT    DIVISION_ID 
		                    , CATEGORY_CODE
		                    , CATEGORY_NAME
                            , RPT_MEASURE
                            , ' + @p_ww_pivot_cols + '
                            , ' + @v_ww_pivot_cols_cell + '
                    FROM
                            (
                                SELECT	  DIVISION_ID
		                                , CATEGORY_CODE
		                                , CATEGORY_NAME
                                        , WEEK_NAME                 AS WW
                                        , WEEK_NAME + ''_CELL''     AS WW_CELL
                                        , ''RESULT_WITH_RTF''       AS RPT_MEASURE
                                        , RESULT_WITH_RTF
                                        , RESULT_WITH_RTF_CELL
                                FROM
                                        (
                                            SELECT	  DIVISION_ID
		                                            , CATEGORY_CODE
		                                            , CATEGORY_NAME
                                                    , WEEK_NAME
                                                    , SUM(RESULT_WITH_RTF)                  AS RESULT_WITH_RTF
                                                    , SUM(RESULT_WITH_RTF_CELL)             AS RESULT_WITH_RTF_CELL
                                            FROM    ' + @p_raw_table_name + '_WW T
                                            GROUP BY  DIVISION_ID
		                                            , CATEGORY_CODE
		                                            , CATEGORY_NAME
                                                    , WEEK_NAME
                                        ) S
                            ) AS A
                    PIVOT   (
                                SUM(RESULT_WITH_RTF) FOR WW IN (' + @p_ww_pivot_cols + ')
                            ) AS RTF
                    PIVOT   (
                                SUM(RESULT_WITH_RTF_CELL) FOR WW_CELL IN (' + @v_ww_pivot_cols_cell + ')
                            ) AS RTF_CELL
				    UNION
                    SELECT    DIVISION_ID 
		                    , CATEGORY_CODE
		                    , CATEGORY_NAME
                            , RPT_MEASURE
                            , ' + @p_ww_pivot_cols + '
                            , ' + @v_ww_pivot_cols_cell + '
                    FROM
                            (
                                SELECT	  DIVISION_ID
		                                , CATEGORY_CODE
		                                , CATEGORY_NAME
                                        , WEEK_NAME                 AS WW
                                        , WEEK_NAME + ''_CELL''     AS WW_CELL
                                        , ''RATE''                  AS RPT_MEASURE
                                        , RATE
                                        , RATE_CELL
                                FROM
                                        (
                                            SELECT	  DIVISION_ID
		                                            , CATEGORY_CODE
		                                            , CATEGORY_NAME
                                                    , WEEK_NAME
                                                    , SUM(RATE)                  AS RATE
                                                    , SUM(RATE_CELL)             AS RATE_CELL
                                            FROM    ' + @p_raw_table_name + '_WW T
                                            GROUP BY  DIVISION_ID
		                                            , CATEGORY_CODE
		                                            , CATEGORY_NAME
                                                    , WEEK_NAME
                                        ) S
                            ) AS A
                    PIVOT   (
                                SUM(RATE) FOR WW IN (' + @p_ww_pivot_cols + ')
                            ) AS RTF
                    PIVOT   (
                                SUM(RATE_CELL) FOR WW_CELL IN (' + @v_ww_pivot_cols_cell + ')
                            ) AS RTF_CELL
                ) X
                LEFT JOIN #TBL_SCP0092_CATEGORY G ON
                        X.DIVISION_ID      = G.DIVISION_ID
                    AND X.CATEGORY_CODE    = G.CATEGORY_CODE
                    AND X.CATEGORY_NAME    = G.CATEGORY_NAME
                LEFT JOIN #TBL_SCP0092_MEASURE M ON
                        LTRIM(RTRIM(X.RPT_MEASURE)) = M.MEASURE
        GROUP BY      X.DIVISION_ID
                    , X.CATEGORY_CODE
                    , X.CATEGORY_NAME
                    , X.RPT_MEASURE
                    , G.DISPLAY_SEQ
                    , M.USER_SORT_ORDER_NO
        ORDER BY      X.DIVISION_ID
                    , G.DISPLAY_SEQ
                    , M.USER_SORT_ORDER_NO';


    --PRINT @p_ww_sql;

    
    --MONTH-----------------------------------------------------------------

    SET @p_mm_sql = N'
    INSERT INTO ' + @p_pivot_table_name + '_MM
    (
          DIVISION_ID
        , CATEGORY_CODE
        , CATEGORY_NAME
        , RPT_MEASURE
        , ' + @p_mm_pivot_cols + '
        , ' + @v_mm_pivot_cols_cell + '
    )
    SELECT    X.DIVISION_ID 
            , X.CATEGORY_CODE
            , X.CATEGORY_NAME
            , X.RPT_MEASURE
            , ' + @v_mm_pivot_cols_max +'
            , ' + @v_mm_pivot_cols_max_cell +'
    FROM
            (
                SELECT    DIVISION_ID 
		                , CATEGORY_CODE
		                , CATEGORY_NAME
                        , RPT_MEASURE
                        , ' + @p_mm_pivot_cols + '
                        , ' + @v_mm_pivot_cols_cell + '
                FROM    (
                            SELECT	  DIVISION_ID 
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , MM
                                    , (MM + ''_CELL'') AS MM_CELL
                                    , ''RTF'' AS RPT_MEASURE
                                    , RTF
                                    , RTF_CELL
                            FROM    ' + @p_raw_table_name + '_MM T
                        ) AS A
                PIVOT   (
                            SUM(RTF) FOR MM IN (' + @p_mm_pivot_cols + ')
                        ) AS RTF
                PIVOT   (
                            SUM(RTF_CELL) FOR MM_CELL IN (' + @v_mm_pivot_cols_cell + ')
                        ) AS RTF_CELL
				UNION
                SELECT    DIVISION_ID 
		                , CATEGORY_CODE
		                , CATEGORY_NAME
                        , RPT_MEASURE
                        , ' + @p_mm_pivot_cols + '
                        , ' + @v_mm_pivot_cols_cell + '
                FROM    (
                            SELECT	  DIVISION_ID 
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , MM
                                    , (MM + ''_CELL'') AS MM_CELL
                                    , ''RESULT'' AS RPT_MEASURE
                                    , RESULT
                                    , RESULT_CELL
                            FROM    ' + @p_raw_table_name + '_MM T
                        ) AS A
                PIVOT   (
                            SUM(RESULT) FOR MM IN (' + @p_mm_pivot_cols + ')
                        ) AS RTF
                PIVOT   (
                            SUM(RESULT_CELL) FOR MM_CELL IN (' + @v_mm_pivot_cols_cell + ')
                        ) AS RTF_CELL
				UNION
                SELECT    DIVISION_ID 
		                , CATEGORY_CODE
		                , CATEGORY_NAME
                        , RPT_MEASURE
                        , ' + @p_mm_pivot_cols + '
                        , ' + @v_mm_pivot_cols_cell + '
                FROM    (
                            SELECT	  DIVISION_ID 
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , MM
                                    , (MM + ''_CELL'') AS MM_CELL
                                    , ''RESULT_WITH_RTF'' AS RPT_MEASURE
                                    , RESULT_WITH_RTF
                                    , RESULT_WITH_RTF_CELL
                            FROM    ' + @p_raw_table_name + '_MM T
                        ) AS A
                PIVOT   (
                            SUM(RESULT_WITH_RTF) FOR MM IN (' + @p_mm_pivot_cols + ')
                        ) AS RTF
                PIVOT   (
                            SUM(RESULT_WITH_RTF_CELL) FOR MM_CELL IN (' + @v_mm_pivot_cols_cell + ')
                        ) AS RTF_CELL
				UNION
                SELECT    DIVISION_ID 
		                , CATEGORY_CODE
		                , CATEGORY_NAME
                        , RPT_MEASURE
                        , ' + @p_mm_pivot_cols + '
                        , ' + @v_mm_pivot_cols_cell + '
                FROM    (
                            SELECT	  DIVISION_ID 
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , MM
                                    , (MM + ''_CELL'') AS MM_CELL
                                    , ''RATE'' AS RPT_MEASURE
                                    , RATE
                                    , RATE_CELL
                            FROM    ' + @p_raw_table_name + '_MM T
                        ) AS A
                PIVOT   (
                            SUM(RATE) FOR MM IN (' + @p_mm_pivot_cols + ')
                        ) AS RTF
                PIVOT   (
                            SUM(RATE_CELL) FOR MM_CELL IN (' + @v_mm_pivot_cols_cell + ')
                        ) AS RTF_CELL
            ) X
    GROUP BY      X.DIVISION_ID
                , X.CATEGORY_CODE
                , X.CATEGORY_NAME
                , X.RPT_MEASURE';

    --PRINT @p_mm_sql;


    --YEAR-----------------------------------------------------------------
    SET @p_yyyy_sql = N'
    INSERT INTO ' + @p_pivot_table_name + '_YYYY
    (
          DIVISION_ID
        , CATEGORY_CODE
        , CATEGORY_NAME
        , RPT_MEASURE
        , [YEAR]
        , [YEAR_CELL]
    )
    SELECT    X.DIVISION_ID 
            , X.CATEGORY_CODE
            , X.CATEGORY_NAME
            , X.RPT_MEASURE
            , ' + @v_yyyy_pivot_cols_max +'
            , ' + @v_yyyy_pivot_cols_max_cell +'
    FROM
            (
                SELECT    DIVISION_ID 
		                , CATEGORY_CODE
		                , CATEGORY_NAME
                        , RPT_MEASURE
                        , ' + @p_yyyy_pivot_cols + '
                        , ' + @v_yyyy_pivot_cols_cell + '
                FROM    (
                            SELECT	  DIVISION_ID 
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , YYYY
                                    , (YYYY + ''_CELL'') AS YYYY_CELL
                                    , ''RTF'' AS RPT_MEASURE
                                    , RTF
                                    , RTF_CELL
                            FROM    ' + @p_raw_table_name + '_YYYY T
                        ) AS A
                PIVOT   (
                            SUM(RTF) FOR YYYY IN (' + @p_yyyy_pivot_cols + ')
                        ) AS RTF
                PIVOT   (
                            SUM(RTF_CELL) FOR YYYY_CELL IN (' + @v_yyyy_pivot_cols_cell + ')
                        ) AS RTF_CELL
				UNION
                SELECT    DIVISION_ID 
		                , CATEGORY_CODE
		                , CATEGORY_NAME
                        , RPT_MEASURE
                        , ' + @p_yyyy_pivot_cols + '
                        , ' + @v_yyyy_pivot_cols_cell + '
                FROM    (
                            SELECT	  DIVISION_ID 
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , YYYY
                                    , (YYYY + ''_CELL'') AS YYYY_CELL
                                    , ''RESULT'' AS RPT_MEASURE
                                    , RESULT
                                    , RESULT_CELL
                            FROM    ' + @p_raw_table_name + '_YYYY T
                        ) AS A
                PIVOT   (
                            SUM(RESULT) FOR YYYY IN (' + @p_yyyy_pivot_cols + ')
                        ) AS RTF
                PIVOT   (
                            SUM(RESULT_CELL) FOR YYYY_CELL IN (' + @v_yyyy_pivot_cols_cell + ')
                        ) AS RTF_CELL
				UNION
                SELECT    DIVISION_ID 
		                , CATEGORY_CODE
		                , CATEGORY_NAME
                        , RPT_MEASURE
                        , ' + @p_yyyy_pivot_cols + '
                        , ' + @v_yyyy_pivot_cols_cell + '
                FROM    (
                            SELECT	  DIVISION_ID 
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , YYYY
                                    , (YYYY + ''_CELL'') AS YYYY_CELL
                                    , ''RESULT_WITH_RTF'' AS RPT_MEASURE
                                    , RESULT_WITH_RTF
                                    , RESULT_WITH_RTF_CELL
                            FROM    ' + @p_raw_table_name + '_YYYY T
                        ) AS A
                PIVOT   (
                            SUM(RESULT_WITH_RTF) FOR YYYY IN (' + @p_yyyy_pivot_cols + ')
                        ) AS RTF
                PIVOT   (
                            SUM(RESULT_WITH_RTF_CELL) FOR YYYY_CELL IN (' + @v_yyyy_pivot_cols_cell + ')
                        ) AS RTF_CELL
				UNION
                SELECT    DIVISION_ID 
		                , CATEGORY_CODE
		                , CATEGORY_NAME
                        , RPT_MEASURE
                        , ' + @p_yyyy_pivot_cols + '
                        , ' + @v_yyyy_pivot_cols_cell + '
                FROM    (
                            SELECT	  DIVISION_ID 
		                            , CATEGORY_CODE
		                            , CATEGORY_NAME
                                    , YYYY
                                    , (YYYY + ''_CELL'') AS YYYY_CELL
                                    , ''RATE'' AS RPT_MEASURE
                                    , RATE
                                    , RATE_CELL
                            FROM    ' + @p_raw_table_name + '_YYYY T
                        ) AS A
                PIVOT   (
                            SUM(RATE) FOR YYYY IN (' + @p_yyyy_pivot_cols + ')
                        ) AS RTF
                PIVOT   (
                            SUM(RATE_CELL) FOR YYYY_CELL IN (' + @v_yyyy_pivot_cols_cell + ')
                        ) AS RTF_CELL
            ) X
    GROUP BY      X.DIVISION_ID
                , X.CATEGORY_CODE
                , X.CATEGORY_NAME
                , X.RPT_MEASURE';

    --PRINT @p_yyyy_sql;


    SET @p_final_sql = N'
        SELECT    W.DIVISION_ID
                , D.DIVISION_NAME
                , W.CATEGORY_CODE
                , W.CATEGORY_NAME
                , W.RPT_MEASURE
                ' + @p_final_cols + '
                , W.DISPLAY_SEQ
                , W.USER_SORT_ORDER_NO
                , Y.[YEAR]
                , Y.[YEAR_CELL]
        FROM    ' + @p_pivot_table_name + '_WW W
                LEFT JOIN SCM_MST_DIVISION D ON
                        W.DIVISION_ID = D.DIVISION_ID
                LEFT JOIN ' + @p_pivot_table_name + '_YYYY Y ON
                        W.DIVISION_ID = Y.DIVISION_ID
                    AND W.CATEGORY_CODE  = Y.CATEGORY_CODE
                    AND W.CATEGORY_NAME  = Y.CATEGORY_NAME
                    AND W.RPT_MEASURE = Y.RPT_MEASURE
                LEFT JOIN ' + @p_pivot_table_name + '_MM M ON
                        W.DIVISION_ID = M.DIVISION_ID
                    AND W.CATEGORY_CODE  = M.CATEGORY_CODE
                    AND W.CATEGORY_NAME  = M.CATEGORY_NAME
                    AND W.RPT_MEASURE = M.RPT_MEASURE
        ORDER BY      W.DIVISION_ID
                    , W.DISPLAY_SEQ
                    , W.CATEGORY_NAME
                    , W.USER_SORT_ORDER_NO
';

--TESTING : NOK
--EXEC DEBUG_LOG @p_ww_sql, 'T';
--EXEC DEBUG_LOG @p_mm_sql, 'T';
--EXEC DEBUG_LOG @p_yyyy_sql, 'T';
--EXEC DEBUG_LOG @p_final_sql, 'T';


END;
