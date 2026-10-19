
/****************************************************************************************************/
/* Program ID  : DMF0043_GET_CONTRIBUTE_MAIN_DATA                                                   */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/07/18     JYE        해외법인 기여율 등록 조회                                              */
/* 2019/08/02     JYE        설계 변경 및 로직 분기.                                                */
/* 2019/08/27     YJS        불일치조회 쿼리 분기.                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0043_GET_CONTRIBUTE_MAIN_DATA]
    @p_yyyy             NVARCHAR(10),
    @p_ver_seq          NVARCHAR(10),
    @p_dis              NVARCHAR(10),
    @p_his              NVARCHAR(1),
    @p_created_by       NVARCHAR(50),
    @p_user_group       NVARCHAR(50)
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE @sdt NVARCHAR(10)=@p_yyyy + '01'
    DECLARE @edt NVARCHAR(10)= @p_yyyy + '12'
    DECLARE @thismm NVARCHAR(10)
    DECLARE @ColumnData NVARCHAR(MAX)=''
    DECLARE @ColumnData2 NVARCHAR(MAX)=''
    DECLARE @Query NVARCHAR(MAX)=''

    IF (MONTH(GETDATE()) < 10) BEGIN
        SET @thismm = @p_yyyy + '0' + CAST(MONTH(GETDATE()) AS NVARCHAR)
    END ELSE BEGIN
        SET @thismm = @p_yyyy + CAST(MONTH(GETDATE()) AS NVARCHAR)
    END

    IF OBJECT_ID (N'tempdb..#temp', N'U') IS NOT NULL
        DROP TABLE #temp
    IF OBJECT_ID (N'tempdb..#temp2', N'U') IS NOT NULL
        DROP TABLE #temp2
    IF OBJECT_ID (N'tempdb..#temp3', N'U') IS NOT NULL
        DROP TABLE #temp3
    IF OBJECT_ID (N'tempdb..#Title', N'U') IS NOT NULL
        DROP TABLE #Title

    -- ######################## 해더 칼럼 데이터 ########################
    CREATE TABLE #Title (
        PROGRAM_ID NVARCHAR(100)
        , SHEET_NAME NVARCHAR(100)
        , COLUMN_NAME NVARCHAR(100)
        , COLUMN_LABEL_NAME NVARCHAR(100)
        , SORT_ORDER_NO NVARCHAR(100)
        , DATA_SORT_METHOD_CODE NVARCHAR(100)
        , SMALL_CLASS_LABEL_NAME NVARCHAR(100)
        , LARGE_CLASS_LABEL_NAME NVARCHAR(100)
        , DAY_CODE NVARCHAR(100)
        , FIXED_FLAG NVARCHAR(100)
        , COLUMN_WIDTH NVARCHAR(100)
        , CELL_CONTROL_OBJECT_TYPE_CODE NVARCHAR(100)
        , CELL_COMBO_DATA_TYPE NVARCHAR(100)
        , DATA_SCALE_NUMBER NVARCHAR(100)
        , DATA_MAX_LENGTH NVARCHAR(100)
        , HORIZONTAL_ALIGN_CODE NVARCHAR(100)
        , UPPERCASE_APPLY_FLAG NVARCHAR(100)
        , VISIBLE_FLAG NVARCHAR(100)
        , DEFAULT_FLAG NVARCHAR(100)
        , USER_SELECTABLE_FLAG NVARCHAR(100)
        , VALID_YN NVARCHAR(100)
        , DIVISION_ID NVARCHAR(100)
    );

    insert #Title exec DMF0043_GET_MAIN_SPREAD_TITLE '40',@p_yyyy,@p_created_by

    SELECT @ColumnData = @ColumnData + '[' + COLUMN_NAME + '],'
    FROM #Title
    WHERE CAST(SORT_ORDER_NO AS INT) > (SELECT CAST(SORT_ORDER_NO AS INT) FROM #Title WHERE COLUMN_NAME = 'EDIT_FLAG')
    SET @ColumnData = LEFT(@ColumnData, LEN(@ColumnData)-1)
    --select @ColumnData

    SELECT @ColumnData2 = @ColumnData2 +
        CASE WHEN CHARINDEX('999', COLUMN_NAME) <> 0 THEN '[' + COLUMN_NAME + '],'
            ELSE 'CAST([' + COLUMN_NAME + '] AS NUMERIC(5,2)) AS [' + COLUMN_NAME + '],' END
    FROM #Title
    WHERE CAST(SORT_ORDER_NO AS INT) > (SELECT CAST(SORT_ORDER_NO AS INT) FROM #Title WHERE COLUMN_NAME = 'EDIT_FLAG')
    SET @ColumnData2 = LEFT(@ColumnData2, LEN(@ColumnData2)-1)
    --select @ColumnData2
    -- ######################## 해더 칼럼 데이터 ########################

    IF (@p_his = 'N') BEGIN
        -- ######################## DM_MST_CONTRIBUTE_RATIO 데이터 ########################
        -- 연도 데이터
        SELECT VER_SEQ
             , DEPARTMENT_ID
             , DEPT_ID
             , END_CUST_REPORT
             , SOLDTO_CUST_REPORT
             , PRODUCT_GROUP
             , DM_BIZ_TYPE
             , CAST(CONTRIBUTION_RATIO AS NVARCHAR) AS RATIO
             , 'Y#' + @p_yyyy + '#' + OS_CORP_CD AS COLUMN_NAME
          INTO #temp
          FROM (SELECT MA.VER_SEQ
                     , MA.DEPARTMENT_ID
                     , MA.DEPT_ID
                     , MA.END_CUST_REPORT
                     , MA.SOLDTO_CUST_REPORT
                     , MA.PRODUCT_GROUP
                     , MA.DM_BIZ_TYPE
                     , DT.YYYYMM
                     , DT.OS_CORP_CD
                     , DT.CONTRIBUTION_TYPE
                     , DT.CONTRIBUTION_RATIO
                  FROM dbo.DM_MST_CONTRIBUTE_RATIO_MST AS MA WITH (NOLOCK)
                       INNER JOIN dbo.DM_MST_CONTRIBUTE_RATIO_DTL AS DT WITH (NOLOCK)
                          ON MA.VER_SEQ = DT.VER_SEQ
                         AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                         AND MA.DEPT_ID = DT.DEPT_ID
                         AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                         AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                         AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                         AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
               ) AS MA
         WHERE YYYYMM = @thismm
           AND VER_SEQ = @p_ver_seq

        UNION ALL

        SELECT VER_SEQ
             , DEPARTMENT_ID
             , DEPT_ID
             , END_CUST_REPORT
             , SOLDTO_CUST_REPORT
             , PRODUCT_GROUP
             , DM_BIZ_TYPE
             , CAST(CONTRIBUTION_TYPE AS NVARCHAR) AS RATIO
             , 'Y#' + @p_yyyy + '#RBU_0999' AS COLUMN_NAME
          FROM (SELECT MA.VER_SEQ
                     , MA.DEPARTMENT_ID
                     , MA.DEPT_ID
                     , MA.END_CUST_REPORT
                     , MA.SOLDTO_CUST_REPORT
                     , MA.PRODUCT_GROUP
                     , MA.DM_BIZ_TYPE
                     , DT.YYYYMM
                     , DT.OS_CORP_CD
                     , DT.CONTRIBUTION_TYPE
                     , DT.CONTRIBUTION_RATIO
                  FROM dbo.DM_MST_CONTRIBUTE_RATIO_MST AS MA WITH (NOLOCK)
                       INNER JOIN dbo.DM_MST_CONTRIBUTE_RATIO_DTL AS DT
                          ON MA.VER_SEQ = DT.VER_SEQ
                         AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                         AND MA.DEPT_ID = DT.DEPT_ID
                         AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                         AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                         AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                         AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
               ) AS MA
         WHERE YYYYMM  = @thismm
           AND VER_SEQ = @p_ver_seq

        UNION ALL

        -- 월 데이터
        SELECT VER_SEQ
             , DEPARTMENT_ID
             , DEPT_ID
             , END_CUST_REPORT
             , SOLDTO_CUST_REPORT
             , PRODUCT_GROUP
             , DM_BIZ_TYPE
             , CAST(CONTRIBUTION_RATIO AS NVARCHAR) AS RATIO
             , 'M#' + YYYYMM + '#' + OS_CORP_CD AS COLUMN_NAME
          FROM (SELECT MA.VER_SEQ
                     , MA.DEPARTMENT_ID
                     , MA.DEPT_ID
                     , MA.END_CUST_REPORT
                     , MA.SOLDTO_CUST_REPORT
                     , MA.PRODUCT_GROUP
                     , MA.DM_BIZ_TYPE
                     , DT.YYYYMM
                     , DT.OS_CORP_CD
                     , DT.CONTRIBUTION_TYPE
                     , DT.CONTRIBUTION_RATIO
                  FROM dbo.DM_MST_CONTRIBUTE_RATIO_MST AS MA
                       INNER JOIN dbo.DM_MST_CONTRIBUTE_RATIO_DTL AS DT
                          ON MA.VER_SEQ = DT.VER_SEQ
                         AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                         AND MA.DEPT_ID = DT.DEPT_ID
                         AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                         AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                         AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                         AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
               ) AS MA
         WHERE YYYYMM >= @sdt AND YYYYMM <= @edt
           AND VER_SEQ = @p_ver_seq

        UNION ALL

        SELECT VER_SEQ
             , DEPARTMENT_ID
             , DEPT_ID
             , END_CUST_REPORT
             , SOLDTO_CUST_REPORT
             , PRODUCT_GROUP
             , DM_BIZ_TYPE
             , CAST(CONTRIBUTION_TYPE AS NVARCHAR) AS RATIO
             , 'M#' + YYYYMM + '#RBU_0999' AS COLUMN_NAME
          FROM (SELECT MA.VER_SEQ
                     , MA.DEPARTMENT_ID
                     , MA.DEPT_ID
                     , MA.END_CUST_REPORT
                     , MA.SOLDTO_CUST_REPORT
                     , MA.PRODUCT_GROUP
                     , MA.DM_BIZ_TYPE
                     , DT.YYYYMM
                     , DT.OS_CORP_CD
                     , DT.CONTRIBUTION_TYPE
                     , DT.CONTRIBUTION_RATIO
                  FROM dbo.DM_MST_CONTRIBUTE_RATIO_MST AS MA
                       INNER JOIN dbo.DM_MST_CONTRIBUTE_RATIO_DTL AS DT
                          ON MA.VER_SEQ = DT.VER_SEQ
                         AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                         AND MA.DEPT_ID = DT.DEPT_ID
                         AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                         AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                         AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                         AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
               ) AS MA
         WHERE YYYYMM >= @sdt AND YYYYMM <= @edt
           AND VER_SEQ = @p_ver_seq

        IF (@p_dis = 'ALL') --2019/08/27
            BEGIN
                -- 불일치 조회 관련 칼럼 추가
                SELECT MAIN.*
                     , DISCARD.DISCARD
                  INTO #temp2
                  FROM #temp AS MAIN
                       INNER JOIN (SELECT VER_SEQ
                                        , DEPARTMENT_ID
                                        , DEPT_ID
                                        , END_CUST_REPORT
                                        , SOLDTO_CUST_REPORT
                                        , PRODUCT_GROUP
                                        , DM_BIZ_TYPE
                                        , CASE WHEN SUM(CONTRIBUTION_RATIO) = 1200 THEN 'Y' ELSE 'N' END AS DISCARD
                                     FROM (SELECT MA.VER_SEQ
                                                , MA.DEPARTMENT_ID
                                                , MA.DEPT_ID
                                                , MA.END_CUST_REPORT
                                                , MA.SOLDTO_CUST_REPORT
                                                , MA.PRODUCT_GROUP
                                                , MA.DM_BIZ_TYPE
                                                , DT.YYYYMM
                                                , DT.OS_CORP_CD
                                                , DT.CONTRIBUTION_TYPE
                                                , DT.CONTRIBUTION_RATIO
                                             FROM dbo.DM_MST_CONTRIBUTE_RATIO_MST AS MA
                                                  INNER JOIN dbo.DM_MST_CONTRIBUTE_RATIO_DTL AS DT
                                                     ON MA.VER_SEQ = DT.VER_SEQ
                                                    AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                                                    AND MA.DEPT_ID = DT.DEPT_ID
                                                    AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                                                    AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                                                    AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                                                    AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
                                          ) AS MA
                                    WHERE YYYYMM >= @sdt AND YYYYMM <= @edt
                                      AND VER_SEQ = @p_ver_seq
                                    GROUP BY VER_SEQ
                                        , DEPARTMENT_ID
                                        , DEPT_ID
                                        , END_CUST_REPORT
                                        , SOLDTO_CUST_REPORT
                                        , PRODUCT_GROUP
                                        , DM_BIZ_TYPE
                                  ) AS DISCARD
                          ON MAIN.VER_SEQ = DISCARD.VER_SEQ
                         AND MAIN.DEPARTMENT_ID = DISCARD.DEPARTMENT_ID
                         AND MAIN.DEPT_ID = DISCARD.DEPT_ID
                         AND MAIN.END_CUST_REPORT = DISCARD.END_CUST_REPORT
                         AND MAIN.SOLDTO_CUST_REPORT = DISCARD.SOLDTO_CUST_REPORT
                         AND MAIN.PRODUCT_GROUP = DISCARD.PRODUCT_GROUP
                         AND MAIN.DM_BIZ_TYPE = DISCARD.DM_BIZ_TYPE
                -- ######################## DM_MST_CONTRIBUTE_RATIO 데이터 ########################


                SET @Query = '
SELECT *
  FROM (SELECT SITE_ITEM.*
             , RATIO.VER_SEQ
             , CASE WHEN RATIO.DISCARD = ''Y'' THEN RATIO.DISCARD ELSE ''N'' END DISCARD
             , CASE WHEN ((SITE_ITEM.department_id != '''')
                           AND (SITE_ITEM.dept_id != '''')
                           AND (SITE_ITEM.end_cust_report != '''')
                           AND (SITE_ITEM.SOLDTO_CUST_REPORT != '''')
                           AND (SITE_ITEM.PRODUCT_GROUP != '''')
                           AND (SITE_ITEM.dm_biz_type != ''''))
                          THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
             , ' + @ColumnData2 + '
          FROM (SELECT DISTINCT A.DIVISION_ID
                     , TEAM.DEPARTMENT_ID
                     , TEAM.DEPARTMENT_NAME
                     , TEAM.DEPT_ID AS DEPT_ID
                     , TEAM.DEPT_NAME_KO AS DEPT_NAME
                     , ISNULL(A.ATTRIBUTE2,'''') AS END_CUST_REPORT
                     , ISNULL(A.ATTRIBUTE1,'''') AS SOLDTO_CUST_REPORT
                     , ISNULL(A.REPORT_GROUP3,'''') AS PRODUCT_GROUP --PRODUCT_GR
                     , ISNULL(C.FORECAST_INFO_BIZ_TYPE,'''') AS DM_BIZ_TYPE
                  FROM SCM_MST_SITE_ITEM A WITH (NOLOCK)
                       INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
                          ON A.DIVISION_ID = B.DIVISION_ID
                         AND A.SCM_SITE_ID = B.SCM_SITE_ID
                        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL SAM WITH (NOLOCK)
                          ON SAM.SEGMENT1 = B.COMPANY_ID
                         AND SAM.LOOKUP_TYPE = ''INTERNAL_TXN''
                       INNER JOIN DM_MST_ITEM_SINGLE_V C WITH (NOLOCK)
                          ON A.DIVISION_ID = C.DIVISION_ID
                         AND A.ITEM_ID = C.ITEM_ID
                        LEFT OUTER JOIN (SELECT B.USER_ID
                                              , B.USER_NAME
                                              , B.USER_NAME_EN
                                              , B.DEPT_ID
                                              , C.DEPT_NAME_KO
                                              , D.DEPT_ID AS DEPARTMENT_ID
                                              , D.DEPT_NAME_KO AS DEPARTMENT_NAME
                                           FROM SCM_MST_SSO_USER_INFO AS B WITH (NOLOCK)
                                                INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
                                                   ON B.DEPT_ID = C.DEPT_ID
                                                INNER JOIN SCM_MST_SSO_DEPT_INFO AS D WITH (NOLOCK)
                                                   ON C.UPPER_DEPT_ID = D.DEPT_ID
                                        ) AS TEAM
                          ON TEAM.USER_ID IN (SELECT TOP 1 token FROM dbo.String_Split(A.OWNER, '',''))
                 WHERE A.DIVISION_ID = ''40''
                   AND B.SITE_TYPE = ''SALES''
                   --AND ISNULL(C.FORECAST_INFO_BIZ_TYPE,'''') <> ''''
                   --AND ISNULL(A.ATTRIBUTE2,'''') <> ''''
                   --AND ISNULL(A.ATTRIBUTE1,'''') <> ''''
                   --AND ISNULL(A.REPORT_GROUP3,'''') <> ''''
                 GROUP BY A.DIVISION_ID
                     , TEAM.DEPARTMENT_ID
                     , TEAM.DEPARTMENT_NAME
                     , TEAM.DEPT_ID
                     , TEAM.DEPT_NAME_KO
                     , ISNULL(SAM.SEGMENT3,'''')
                     , ISNULL(A.ATTRIBUTE2,'''')
                     , ISNULL(A.ATTRIBUTE1,'''')
                     , ISNULL(A.REPORT_GROUP3,'''')
                     , ISNULL(C.FORECAST_INFO_BIZ_TYPE,'''')

               ) AS SITE_ITEM
               LEFT JOIN (SELECT VER_SEQ
                               , DEPARTMENT_ID
                               , DEPT_ID
                               , END_CUST_REPORT
                               , SOLDTO_CUST_REPORT
                               , PRODUCT_GROUP
                               , DM_BIZ_TYPE
                               , DISCARD
                               , ' + @ColumnData + '
                            FROM (SELECT *
                                    FROM #temp2) MA
                                 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + @ColumnData + ')) AS PVT
                          ) AS RATIO
                 ON SITE_ITEM.DEPARTMENT_ID   = RATIO.DEPARTMENT_ID
                AND SITE_ITEM.DEPT_ID         = RATIO.DEPT_ID
                AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
                AND SITE_ITEM.SOLDTO_CUST_REPORT  = RATIO.SOLDTO_CUST_REPORT
                AND SITE_ITEM.PRODUCT_GROUP   = RATIO.PRODUCT_GROUP
                AND SITE_ITEM.DM_BIZ_TYPE     = RATIO.DM_BIZ_TYPE
       ) MA
 WHERE DISCARD = CASE WHEN ''' + @p_dis + ''' = ''ALL'' THEN DISCARD ELSE ''' + @p_dis + ''' END
'

            END
        ELSE  -- 2019/08/27 (@p_dis = 'Y') 추가
            BEGIN
                IF OBJECT_ID (N'tempdb..#master_list', N'U') IS NOT NULL
                    DROP TABLE #master_list
                IF OBJECT_ID (N'tempdb..#dis_list', N'U') IS NOT NULL
                    DROP TABLE #dis_list
                IF OBJECT_ID (N'tempdb..#temp_list', N'U') IS NOT NULL
                    DROP TABLE #temp_list

                SELECT A.DIVISION_ID
                     , TEAM.DEPARTMENT_ID
                     , TEAM.DEPARTMENT_NAME
                     , TEAM.DEPT_ID AS DEPT_ID
                     , TEAM.DEPT_NAME_KO AS DEPT_NAME
                     , ISNULL(A.ATTRIBUTE2,'') AS END_CUST_REPORT
                     , ISNULL(A.ATTRIBUTE1,'') AS SOLDTO_CUST_REPORT
                     , ISNULL(A.REPORT_GROUP3,'') AS PRODUCT_GROUP --PRODUCT_GR
                     , ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') AS DM_BIZ_TYPE
                  INTO #master_list
                  FROM SCM_MST_SITE_ITEM A WITH (NOLOCK)
                       INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
                          ON A.DIVISION_ID = B.DIVISION_ID
                         AND A.SCM_SITE_ID = B.SCM_SITE_ID
                       INNER JOIN DM_MST_ITEM_SINGLE_V C WITH (NOLOCK)
                          ON A.DIVISION_ID = C.DIVISION_ID
                         AND A.ITEM_ID = C.ITEM_ID
                        LEFT JOIN (SELECT B.USER_ID
                                        , B.USER_NAME
                                        , B.USER_NAME_EN
                                        , B.DEPT_ID
                                        , C.DEPT_NAME_KO
                                        , D.DEPT_ID AS DEPARTMENT_ID
                                        , D.DEPT_NAME_KO AS DEPARTMENT_NAME
                                     FROM SCM_MST_SSO_USER_INFO AS B WITH (NOLOCK)
                                          INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
                                             ON B.DEPT_ID = C.DEPT_ID
                                          INNER JOIN SCM_MST_SSO_DEPT_INFO AS D WITH (NOLOCK)
                                             ON C.UPPER_DEPT_ID = D.DEPT_ID
                                   ) AS TEAM
                          ON TEAM.USER_ID IN (SELECT TOP 1 token FROM dbo.String_Split(A.OWNER, ','))
                 WHERE A.DIVISION_ID = '40'
                   AND B.SITE_TYPE = 'SALES'
                 GROUP BY A.DIVISION_ID
                     , TEAM.DEPARTMENT_ID
                     , TEAM.DEPARTMENT_NAME
                     , TEAM.DEPT_ID
                     , TEAM.DEPT_NAME_KO
                     , ISNULL(A.ATTRIBUTE2,'')
                     , ISNULL(A.ATTRIBUTE1,'')
                     , ISNULL(A.REPORT_GROUP3,'')
                     , ISNULL(C.FORECAST_INFO_BIZ_TYPE,'')
                ;

                SELECT MAIN.*
                     , DISCARD.DISCARD
                  INTO #temp_list
                  FROM #temp AS MAIN
                       INNER JOIN (SELECT VER_SEQ
                                        , DEPARTMENT_ID
                                        , DEPT_ID
                                        , END_CUST_REPORT
                                        , SOLDTO_CUST_REPORT
                                        , PRODUCT_GROUP
                                        , DM_BIZ_TYPE
                                        , CASE WHEN SUM(CASE WHEN RATIO = 100 THEN 0 ELSE 1 END) > 0 THEN 'Y' ELSE 'N' END AS DISCARD
                                     FROM (SELECT MA.VER_SEQ
                                                , MA.DEPARTMENT_ID
                                                , MA.DEPT_ID
                                                , MA.END_CUST_REPORT
                                                , MA.SOLDTO_CUST_REPORT
                                                , MA.PRODUCT_GROUP
                                                , MA.DM_BIZ_TYPE
                                                , DT.YYYYMM
                                                , DT.OS_CORP_CD
                                                , DT.CONTRIBUTION_TYPE
                                                , DT.CONTRIBUTION_RATIO
                                                , SUM(CONTRIBUTION_RATIO) OVER(PARTITION BY MA.VER_SEQ
                                                                                          , MA.DEPARTMENT_ID
                                                                                          , MA.DEPT_ID
                                                                                          , MA.END_CUST_REPORT
                                                                                          , MA.SOLDTO_CUST_REPORT
                                                                                          , MA.PRODUCT_GROUP
                                                                                          , MA.DM_BIZ_TYPE
                                                                                          , DT.YYYYMM) AS RATIO
                                             FROM DM_MST_CONTRIBUTE_RATIO_MST AS MA WITH (NOLOCK)
                                                  INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL AS DT WITH (NOLOCK)
                                                     ON MA.VER_SEQ = DT.VER_SEQ
                                                    AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                                                    AND MA.DEPT_ID = DT.DEPT_ID
                                                    AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                                                    AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                                                    AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                                                    AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
                                            WHERE MA.VER_SEQ = @p_ver_seq
                                              AND DT.YYYYMM >= @sdt
                                              AND DT.YYYYMM <= @edt
                                          ) AS MA
                                    GROUP BY VER_SEQ
                                           , DEPARTMENT_ID
                                           , DEPT_ID
                                           , END_CUST_REPORT
                                           , SOLDTO_CUST_REPORT
                                           , PRODUCT_GROUP
                                           , DM_BIZ_TYPE
                                  ) AS DISCARD
                          ON MAIN.VER_SEQ         = DISCARD.VER_SEQ
                         AND MAIN.DEPARTMENT_ID   = DISCARD.DEPARTMENT_ID
                         AND MAIN.DEPT_ID         = DISCARD.DEPT_ID
                         AND MAIN.END_CUST_REPORT = DISCARD.END_CUST_REPORT
                         AND MAIN.SOLDTO_CUST_REPORT  = DISCARD.SOLDTO_CUST_REPORT
                         AND MAIN.PRODUCT_GROUP   = DISCARD.PRODUCT_GROUP
                         AND MAIN.DM_BIZ_TYPE     = DISCARD.DM_BIZ_TYPE
                 WHERE DISCARD.DISCARD = 'Y'

                SET @Query = '
SELECT *
  FROM (SELECT SITE_ITEM.*
             , RATIO.VER_SEQ
             , CASE WHEN RATIO.DISCARD = ''Y'' THEN RATIO.DISCARD ELSE ''N'' END DISCARD
             , CASE WHEN ((SITE_ITEM.department_id != '''')
                           AND (SITE_ITEM.dept_id != '''')
                           AND (SITE_ITEM.end_cust_report != '''')
                           AND (SITE_ITEM.SOLDTO_CUST_REPORT != '''')
                           AND (SITE_ITEM.PRODUCT_GROUP != '''')
                           AND (SITE_ITEM.dm_biz_type != ''''))
                         THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
             ,' + @ColumnData2 + '
          FROM #master_list AS SITE_ITEM
               INNER JOIN (SELECT VER_SEQ
                                , DEPARTMENT_ID
                                , DEPT_ID
                                , END_CUST_REPORT
                                , SOLDTO_CUST_REPORT
                                , PRODUCT_GROUP
                                , DM_BIZ_TYPE
                                , DISCARD
                                , ' + @ColumnData + '

                             FROM (SELECT *
                                     FROM #temp_list
                                    WHERE DISCARD = ''Y'') MA
                            PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + @ColumnData + ')) AS PVT
                          ) AS RATIO
                  ON  SITE_ITEM.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
                 AND SITE_ITEM.DEPT_ID = RATIO.DEPT_ID
                 AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
                 AND SITE_ITEM.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
                 AND SITE_ITEM.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
                 AND SITE_ITEM.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE

        UNION ALL
        SELECT SITE_ITEM.*
             , RATIO.VER_SEQ
             , ''Y'' AS DISCARD
             , CASE WHEN ((SITE_ITEM.department_id != '''')
                           AND (SITE_ITEM.dept_id != '''')
                           AND (SITE_ITEM.end_cust_report != '''')
                           AND (SITE_ITEM.SOLDTO_CUST_REPORT != '''')
                           AND (SITE_ITEM.PRODUCT_GROUP != '''')
                           AND (SITE_ITEM.dm_biz_type != ''''))
                         THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
             , ' + @ColumnData2 + '
          FROM #master_list AS SITE_ITEM
               LEFT OUTER JOIN (SELECT VER_SEQ
                                     , DEPARTMENT_ID
                                     , DEPT_ID
                                     , END_CUST_REPORT
                                     , SOLDTO_CUST_REPORT
                                     , PRODUCT_GROUP
                                     , DM_BIZ_TYPE
                                     , ' + @ColumnData + '

                                  FROM (SELECT * FROM #temp) MA
                                 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + @ColumnData + ')) AS PVT
                               ) AS RATIO
                 ON SITE_ITEM.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
                AND SITE_ITEM.DEPT_ID = RATIO.DEPT_ID
                AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
                AND SITE_ITEM.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
                AND SITE_ITEM.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
                AND SITE_ITEM.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE
         WHERE RATIO.VER_SEQ IS NULL
       ) MA
'

            END
    END

    ELSE BEGIN   -- (@p_his = 'Y')
        -- ######################## 데이터 ########################
        SELECT CONTRIBUTE.*
             , SITE_ITEM.DIVISION_ID
          INTO #DataTable
          FROM (SELECT MA.VER_SEQ
                     , MA.DEPARTMENT_ID
                     , MA.DEPT_ID
                     , MA.END_CUST_REPORT
                     , MA.SOLDTO_CUST_REPORT
                     , MA.PRODUCT_GROUP
                     , MA.DM_BIZ_TYPE
                  FROM dbo.DM_MST_CONTRIBUTE_RATIO_MST AS MA WITH (NOLOCK)
               ) AS CONTRIBUTE
               LEFT OUTER JOIN (
                    SELECT DISTINCT
                           A.DIVISION_ID
                         , TEAM.DEPARTMENT_ID
                         , TEAM.DEPARTMENT_NAME
                         , TEAM.DEPT_ID AS DEPT_ID
                         , TEAM.DEPT_NAME_KO AS DEPT_NAME
                         , ISNULL(A.ATTRIBUTE2,'') AS END_CUST_REPORT
                         , ISNULL(A.ATTRIBUTE1,'') AS SOLDTO_CUST_REPORT
                         , ISNULL(A.REPORT_GROUP3,'') AS PRODUCT_GROUP
                         , ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') AS DM_BIZ_TYPE
                      FROM SCM_MST_SITE_ITEM A WITH (NOLOCK)
                           INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
                              ON A.DIVISION_ID = B.DIVISION_ID
                             AND A.SCM_SITE_ID = B.SCM_SITE_ID
                            LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL SAM WITH (NOLOCK)
                              ON SAM.SEGMENT1 = B.COMPANY_ID
                             AND SAM.LOOKUP_TYPE = 'INTERNAL_TXN'
                           INNER JOIN DM_MST_ITEM_SINGLE_V C WITH (NOLOCK)
                              ON A.DIVISION_ID = C.DIVISION_ID
                             AND A.ITEM_ID = C.ITEM_ID
                            LEFT JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN
                                            , B.DEPT_ID, C.DEPT_NAME_KO, D.DEPT_ID AS DEPARTMENT_ID
                                            , D.DEPT_NAME_KO AS DEPARTMENT_NAME
                                         FROM SCM_MST_SSO_USER_INFO AS B WITH (NOLOCK)
                                              INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
                                                 ON B.DEPT_ID = C.DEPT_ID
                                              INNER JOIN SCM_MST_SSO_DEPT_INFO AS D WITH (NOLOCK)
                                                 ON C.UPPER_DEPT_ID = D.DEPT_ID
                                      ) AS TEAM
                              ON TEAM.USER_ID IN (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER, ','))
                     WHERE A.DIVISION_ID = '40'
                       AND B.SITE_TYPE = 'SALES'
                       AND ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') <> ''
                       AND ISNULL(A.ATTRIBUTE2,'') <> ''
                       AND ISNULL(A.ATTRIBUTE1,'') <> ''
                       AND ISNULL(A.REPORT_GROUP3,'') <> ''
                     GROUP BY A.DIVISION_ID
                         , TEAM.DEPARTMENT_ID
                         , TEAM.DEPARTMENT_NAME
                         , TEAM.DEPT_ID
                         , TEAM.DEPT_NAME_KO
                         , ISNULL(SAM.SEGMENT3,'')
                         , ISNULL(A.ATTRIBUTE2,'')
                         , ISNULL(A.ATTRIBUTE1,'')
                         , ISNULL(A.REPORT_GROUP3,'')
                         , ISNULL(C.FORECAST_INFO_BIZ_TYPE,'')
                   ) AS SITE_ITEM
                 ON SITE_ITEM.DEPARTMENT_ID = CONTRIBUTE.DEPARTMENT_ID
                AND SITE_ITEM.DEPT_ID = CONTRIBUTE.DEPT_ID
                AND SITE_ITEM.END_CUST_REPORT = CONTRIBUTE.END_CUST_REPORT
                AND SITE_ITEM.SOLDTO_CUST_REPORT = CONTRIBUTE.SOLDTO_CUST_REPORT
                AND SITE_ITEM.PRODUCT_GROUP = CONTRIBUTE.PRODUCT_GROUP
                AND SITE_ITEM.DM_BIZ_TYPE = CONTRIBUTE.DM_BIZ_TYPE
         WHERE SITE_ITEM.DIVISION_ID IS NULL

        -- 연도 데이터
        SELECT MA.VER_SEQ
             , MA.DEPARTMENT_ID
             , MA.DEPT_ID
             , MA.END_CUST_REPORT
             , MA.SOLDTO_CUST_REPORT
             , MA.PRODUCT_GROUP
             , MA.DM_BIZ_TYPE
             , CAST(DTL.CONTRIBUTION_RATIO AS NVARCHAR) AS RATIO
             , 'Y#' + @p_yyyy + '#' + DTL.OS_CORP_CD AS COLUMN_NAME
          INTO #temp3
          FROM #DataTable AS MA
               INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL AS DTL
                  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
                 AND MA.DEPT_ID = DTL.DEPT_ID
                 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
                 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
                 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
                 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
         WHERE YYYYMM = @thismm
           AND MA.VER_SEQ = @p_ver_seq

        UNION ALL

        SELECT MA.VER_SEQ
             , MA.DEPARTMENT_ID
             , MA.DEPT_ID
             , MA.END_CUST_REPORT
             , MA.SOLDTO_CUST_REPORT
             , MA.PRODUCT_GROUP
             , MA.DM_BIZ_TYPE
             , CAST(DTL.CONTRIBUTION_TYPE AS NVARCHAR) AS RATIO
             , 'Y#' + @p_yyyy + '#RBU_0999' AS COLUMN_NAME
          FROM #DataTable AS MA
               INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL AS DTL
                  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
                 AND MA.DEPT_ID = DTL.DEPT_ID
                 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
                 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
                 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
                 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
         WHERE YYYYMM = @thismm
           AND MA.VER_SEQ = @p_ver_seq

        UNION ALL

        -- 월 데이터
        SELECT MA.VER_SEQ
             , MA.DEPARTMENT_ID
             , MA.DEPT_ID
             , MA.END_CUST_REPORT
             , MA.SOLDTO_CUST_REPORT
             , MA.PRODUCT_GROUP
             , MA.DM_BIZ_TYPE
             , CAST(DTL.CONTRIBUTION_RATIO AS NVARCHAR) AS RATIO
             , 'M#' + YYYYMM + '#' + OS_CORP_CD AS COLUMN_NAME
          FROM #DataTable AS MA
               INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL AS DTL
                  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
                 AND MA.DEPT_ID = DTL.DEPT_ID
                 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
                 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
                 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
                 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
         WHERE YYYYMM >= @sdt AND YYYYMM <= @edt
           AND MA.VER_SEQ = @p_ver_seq

        UNION ALL

        SELECT MA.VER_SEQ
             , MA.DEPARTMENT_ID
             , MA.DEPT_ID
             , MA.END_CUST_REPORT
             , MA.SOLDTO_CUST_REPORT
             , MA.PRODUCT_GROUP
             , MA.DM_BIZ_TYPE
             , CAST(DTL.CONTRIBUTION_TYPE AS NVARCHAR) AS RATIO
             , 'M#' + YYYYMM + '#RBU_0999' AS COLUMN_NAME
          FROM #DataTable AS MA
               INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL AS DTL
                  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
                 AND MA.DEPT_ID = DTL.DEPT_ID
                 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
                 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
                 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
                 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
         WHERE YYYYMM >= @sdt AND YYYYMM <= @edt
           AND MA.VER_SEQ = @p_ver_seq
        -- select * from #temp
        -- ######################## 데이터 ########################

        SET @Query = '
SELECT VER_SEQ
     , DEPARTMENT_ID
     , DEPT_ID
     , END_CUST_REPORT
     , SOLDTO_CUST_REPORT
     , PRODUCT_GROUP
     , DM_BIZ_TYPE
     , ''N'' AS EDIT_FLAG
     , ' + @ColumnData + '
  FROM (SELECT *
          FROM #temp3) MA
 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + @ColumnData + ')) AS PVT
'
    END

    --SELECT CONVERT(TEXT, @Query)
    --FOR XML PATH('')--,ROOT('x')

    EXECUTE dbo.SP_EXECUTESQL @Query
	
END
