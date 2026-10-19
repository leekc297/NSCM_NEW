/****************************************************************************************************
* Program ID  : SCP_GET_SHEET_CALENDAR_3SPAN
* Description : SCP 칼렌더 생성위한 프로시저
* Usage       : exec SCP_GET_SHEET_CALENDAR_3SPAN
* Parameter   : @p_start_yyyymmdd='2017-12-25'
*               @p_end_yyyymmdd='20180130'
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description
*--------------------------------------------------------------------------------------------------
* 2022/07/15  chaan        Initial Release
* 2022/08/25  jahn1501     PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MMDD_LABEL_NAME 추가
* ex)
* EXEC SCP0009_GET_SHEET_CALENDAR_3SPAN @p_start_yyyymmdd ='20180122' , @p_end_yyyymmdd='20180220'
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO]
	@p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;

    --DECLARE @p_start_yyyymmdd  NVARCHAR(8) = '20220729'
    --DECLARE @p_end_yyyymmdd    NVARCHAR(8) = '20230901'

    IF OBJECT_ID (N'tempdb..#T_M', N'U') IS NOT NULL
	    DROP TABLE #T_M;

    SELECT    'M_' + A.BASIS_YYYYMM                                             AS COLUMN_NAME
		    , A.MONTH_NAME                                                      AS COLUMN_LABEL_NAME
		    , A.MONTH_NAME                                                      AS SMALL_CLASS_LABEL_NAME
		    , A.MONTH_NAME                                                      AS LARGE_CLASS_LABEL_NAME
		    , ''                                                                AS DAY_CODE
			, ''																AS MMDD_LABEL_NAME		    
    INTO    #T_M
    FROM    dbo.SCM_SYS_CALENDAR_M A WITH(NOLOCK)
    WHERE   A.BASIS_YYYYMMDD >= @p_start_yyyymmdd
        AND A.BASIS_YYYYMMDD < = @p_end_yyyymmdd
    GROUP BY  A.BASIS_YYYYMM
		    , A.MONTH_NAME;


    IF OBJECT_ID (N'tempdb..#T_W', N'U') IS NOT NULL
	    DROP TABLE #T_W;

    SELECT    X.COLUMN_NAME
            , X.COLUMN_LABEL_NAME
            , X.SMALL_CLASS_LABEL_NAME
            , SUBSTRING(X.COLUMN_NAME, 3, 4) + '-' + SUBSTRING(X.COLUMN_NAME, 7, 2) AS LARGE_CLASS_LABEL_NAME
            , X.DAY_CODE
			, SUBSTRING(X.SMALL_CLASS_LABEL_NAME, 5, 2) + '.' + SUBSTRING(X.SMALL_CLASS_LABEL_NAME, 7, 2) + ' ~ ' 
				+ SUBSTRING(X.SMALL_CLASS_LABEL_NAME, 14, 2) + '.' + SUBSTRING(X.SMALL_CLASS_LABEL_NAME, 16, 2) AS MMDD_LABEL_NAME            
    INTO    #T_W
    FROM    (
                SELECT    'W_' + A.ISO_YYYYMM + RIGHT(A.ISO_YYYYWW, 2) + '_ISO'             AS COLUMN_NAME
		                --, SUBSTRING(A.ISO_YYYYMM, 1, 4) + '-W' + RIGHT(A.ISO_YYYYWW, 2)     AS COLUMN_LABEL_NAME
		                , 'W' + RIGHT(A.ISO_YYYYWW, 2)                                      AS COLUMN_LABEL_NAME
		                , MIN(A.BASIS_START_DATE) + '~' + MAX(A.BASIS_END_DATE)             AS SMALL_CLASS_LABEL_NAME
		                , MIN(A.BASIS_START_DATE) + '~' + MAX(A.BASIS_END_DATE)             AS LARGE_CLASS_LABEL_NAME
		                , ''                                                                AS DAY_CODE
                FROM    dbo.SCM_SYS_CALENDAR_M A WITH(NOLOCK)
                        LEFT JOIN #T_M M ON
                                A.MONTH_NAME = M.LARGE_CLASS_LABEL_NAME
                WHERE   A.BASIS_YYYYMMDD >= @p_start_yyyymmdd
                    AND A.BASIS_YYYYMMDD < = @p_end_yyyymmdd
                GROUP BY  A.ISO_YYYYMM
		                , A.ISO_YYYYWW
            ) X;


    IF OBJECT_ID (N'tempdb..#T_D', N'U') IS NOT NULL
	    DROP TABLE #T_D;

    SELECT    'D_' + A.BASIS_YYYYMMDD                                           AS COLUMN_NAME
		    , A.CALENDAR_DAY                                                    AS COLUMN_LABEL_NAME
		    , W.SMALL_CLASS_LABEL_NAME                                          AS SMALL_CLASS_LABEL_NAME
		    , W.LARGE_CLASS_LABEL_NAME                                     AS LARGE_CLASS_LABEL_NAME
		    , A.DAYOFWEEK                                                       AS DAY_CODE
			, W.MMDD_LABEL_NAME													AS MMDD_LABEL_NAME		    
    INTO    #T_D
    FROM    dbo.SCM_SYS_CALENDAR_M A WITH(NOLOCK)
            LEFT JOIN #T_W W ON
                    'W_' + A.ISO_YYYYMM + RIGHT(A.ISO_YYYYWW, 2) + '_ISO' = W.COLUMN_NAME
    WHERE   A.BASIS_YYYYMMDD >= @p_start_yyyymmdd
	    AND A.BASIS_YYYYMMDD <= @p_end_yyyymmdd;


    --SELECT * FROM #T_M ORDER BY COLUMN_NAME;
    --SELECT * FROM #T_W ORDER BY COLUMN_NAME;
    --SELECT * FROM #T_D ORDER BY COLUMN_NAME;return;

    --최종 데이터를 넣을 빈 테이블 생성
    IF OBJECT_ID('tempdb..#T_WHOLE') IS NOT NULL	
	    DROP TABLE #T_WHOLE;

    CREATE TABLE #T_WHOLE
    (
          COLUMN_NAME                   NVARCHAR(100)
        , COLUMN_LABEL_NAME             NVARCHAR(100)
        , SMALL_CLASS_LABEL_NAME        NVARCHAR(100)
        , LARGE_CLASS_LABEL_NAME        NVARCHAR(100)
        , DAY_CODE                      NVARCHAR(100)
		, MMDD_LABEL_NAME				NVARCHAR(100)        
    )



    DECLARE @V_COLUMN_NAME                  NVARCHAR(50) = N''
    DECLARE @V_COLUMN_LABEL_NAME            NVARCHAR(50) = N''
    DECLARE @V_SMALL_CLASS_LABEL_NAME       NVARCHAR(50) = N''
    DECLARE @V_SMALL_CLASS_LABEL_NAME_BEF   NVARCHAR(50) = N''
    DECLARE @V_LARGE_CLASS_LABEL_NAME       NVARCHAR(50) = N''
    DECLARE @V_LARGE_CLASS_LABEL_NAME_BEF   NVARCHAR(50) = N''
    DECLARE @V_DAY_CODE                     NVARCHAR(50) = N''
	DECLARE @V_MMDD_LABEL_NAME				NVARCHAR(50) = N''    

    DECLARE CUR_D CURSOR FOR
    SELECT    *
    FROM    #T_D
    ORDER BY COLUMN_NAME;

    OPEN CUR_D;

    FETCH NEXT FROM CUR_D INTO
          @V_COLUMN_NAME                
        , @V_COLUMN_LABEL_NAME          
        , @V_SMALL_CLASS_LABEL_NAME     
        , @V_LARGE_CLASS_LABEL_NAME     
        , @V_DAY_CODE                   
		, @V_MMDD_LABEL_NAME
		
    WHILE @@FETCH_STATUS = 0
    BEGIN
        --MONTHLY 추가
        IF @V_LARGE_CLASS_LABEL_NAME != @V_LARGE_CLASS_LABEL_NAME_BEF
        BEGIN
            SET @V_LARGE_CLASS_LABEL_NAME_BEF    = @V_LARGE_CLASS_LABEL_NAME

            INSERT INTO #T_WHOLE
            SELECT  * 
            FROM    #T_M
            WHERE   LARGE_CLASS_LABEL_NAME = @V_LARGE_CLASS_LABEL_NAME
        END

        --WEEKLY 추가
        IF @V_SMALL_CLASS_LABEL_NAME != @V_SMALL_CLASS_LABEL_NAME_BEF
        BEGIN
            SET @V_SMALL_CLASS_LABEL_NAME_BEF    = @V_SMALL_CLASS_LABEL_NAME

            INSERT INTO #T_WHOLE
            SELECT  * 
            FROM    #T_W
            WHERE   LARGE_CLASS_LABEL_NAME = @V_LARGE_CLASS_LABEL_NAME
                AND SMALL_CLASS_LABEL_NAME = @V_SMALL_CLASS_LABEL_NAME
        END

        --DAILY 추가
        INSERT INTO #T_WHOLE 
            SELECT    @V_COLUMN_NAME
                    , @V_COLUMN_LABEL_NAME
                    , @V_SMALL_CLASS_LABEL_NAME
                    , @V_LARGE_CLASS_LABEL_NAME
                    , @V_DAY_CODE
					, @V_MMDD_LABEL_NAME

        FETCH NEXT FROM CUR_D INTO
              @V_COLUMN_NAME
            , @V_COLUMN_LABEL_NAME
            , @V_SMALL_CLASS_LABEL_NAME
            , @V_LARGE_CLASS_LABEL_NAME
            , @V_DAY_CODE
			, @V_MMDD_LABEL_NAME
    END;

    CLOSE CUR_D;
    DEALLOCATE CUR_D;

    SELECT  * 
    FROM    #T_WHOLE
    WHERE   1=1
        --AND SUBSTRING(COLUMN_NAME, 1, 2) = 'W_';
        --AND SMALL_CLASS_LABEL_NAME = '20220704~20220710'
    SELECT  * 
    FROM    #T_WHOLE
    WHERE   1=1
        AND SUBSTRING(COLUMN_NAME, 1, 2) = 'W_';


    IF OBJECT_ID('tempdb..#T_WHOLE') IS NOT NULL	
	    DROP TABLE #T_M;
    IF OBJECT_ID('tempdb..#T_WHOLE') IS NOT NULL	
	    DROP TABLE #T_W;
    IF OBJECT_ID('tempdb..#T_WHOLE') IS NOT NULL	
	    DROP TABLE #T_D;
    IF OBJECT_ID('tempdb..#T_WHOLE') IS NOT NULL	
	    DROP TABLE #T_WHOLE;
END
