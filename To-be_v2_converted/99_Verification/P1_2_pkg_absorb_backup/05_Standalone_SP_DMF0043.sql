/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0043.sql
 * Description  : Standalone Procedures — DMF0043 화면 (10개)
 *              : 향후 PKG_DMF0043로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0043_GET_CONTRIBUTE_MAIN_DATA
(
    p_yyyy             VARCHAR2,
    p_ver_seq          VARCHAR2,
    p_dis              VARCHAR2,
    p_his              VARCHAR2,
    p_created_by       VARCHAR2,
    p_user_group       VARCHAR2
/****************************************************************************************************/
)
AS

    v_sdt VARCHAR2(10 CHAR) := p_yyyy  ||  '01';
    v_edt VARCHAR2(10 CHAR) := p_yyyy  ||  '12';
    v_thismm VARCHAR2(10 CHAR);
    V_ColumnData VARCHAR2(4000 CHAR) := NULL;
    V_ColumnData2 VARCHAR2(4000 CHAR) := NULL;
    V_Query VARCHAR2(4000 CHAR) := NULL;
BEGIN







    IF (MONTH(SYSDATE) < 10) THEN
        v_thismm := p_yyyy  ||  '0'  ||  CAST(MONTH(SYSDATE) AS VARCHAR2);
    END ELSE BEGIN
        v_thismm := p_yyyy  ||  CAST(MONTH(SYSDATE) AS VARCHAR2);
    END IF;

    -- ######################## 해더 칼럼 데이터 ########################
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_itle';

    INSERT INTO GT_DMF0_itle DMF0043_GET_MAIN_SPREAD_TITLE '40',p_yyyy,p_created_by

    SELECT V_ColumnData  ||  '['  ||  COLUMN_NAME  ||  ']
  INTO V_ColumnData
    FROM GT_DMF0_itle
    WHERE CAST(SORT_ORDER_NO AS INTEGER) > (SELECT CAST(SORT_ORDER_NO AS INTEGER) FROM GT_DMF0_itle WHERE COLUMN_NAME = 'EDIT_FLAG');
    V_ColumnData := SUBSTR(V_ColumnData, 1, LENGTH(V_ColumnData)-1)
    --select V_ColumnData

    SELECT V_ColumnData2 = V_ColumnData2 +
        CASE WHEN INSTR(COLUMN_NAME, '999') <> 0 THEN '[' + COLUMN_NAME + '],'
            ELSE 'CAST([' + COLUMN_NAME + '] AS NUMERIC(5,2)) AS [' + COLUMN_NAME + '],' END
    FROM GT_DMF0_itle
    WHERE CAST(SORT_ORDER_NO AS INTEGER) > (SELECT CAST(SORT_ORDER_NO AS INTEGER) FROM GT_DMF0_itle WHERE COLUMN_NAME = 'EDIT_FLAG');
    V_ColumnData2 := SUBSTR(V_ColumnData2, 1, LENGTH(V_ColumnData2)-1);
    --select V_ColumnData2
    -- ######################## 해더 칼럼 데이터 ########################

    IF (p_his = '') THEN
        -- ######################## DM_MST_CONTRIBUTE_RATIO 데이터 ########################
        -- 연도 데이터
        /* TODO:GTT:GT_DMF0_-->GT_DMF0_ */
        INSERT INTO GT_DMF0_
        SELECT VER_SEQ
             , DEPARTMENT_ID
             , DEPT_ID
             , END_CUST_REPORT
             , SOLDTO_CUST_REPORT
             , PRODUCT_GROUP
             , DM_BIZ_TYPE
             , CAST(CONTRIBUTION_RATIO AS VARCHAR2) AS RATIO
             , 'Y#' + p_yyyy + '#' + OS_CORP_CD AS COLUMN_NAME
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
                  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
                       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
                          ON MA.VER_SEQ = DT.VER_SEQ
                         AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                         AND MA.DEPT_ID = DT.DEPT_ID
                         AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                         AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                         AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                         AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
               ) AS MA
         WHERE YYYYMM = v_thismm
           AND VER_SEQ = p_ver_seq

        UNION ALL

        SELECT VER_SEQ
             , DEPARTMENT_ID
             , DEPT_ID
             , END_CUST_REPORT
             , SOLDTO_CUST_REPORT
             , PRODUCT_GROUP
             , DM_BIZ_TYPE
             , CAST(CONTRIBUTION_TYPE AS VARCHAR2) AS RATIO
             , 'Y#' + p_yyyy + 'GT_DMF0_RBU_0999' AS COLUMN_NAME
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
                  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
                       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
                          ON MA.VER_SEQ = DT.VER_SEQ
                         AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                         AND MA.DEPT_ID = DT.DEPT_ID
                         AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                         AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                         AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                         AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
               ) AS MA
         WHERE YYYYMM  = v_thismm
           AND VER_SEQ = p_ver_seq

        UNION ALL

        -- 월 데이터
        SELECT VER_SEQ
             , DEPARTMENT_ID
             , DEPT_ID
             , END_CUST_REPORT
             , SOLDTO_CUST_REPORT
             , PRODUCT_GROUP
             , DM_BIZ_TYPE
             , CAST(CONTRIBUTION_RATIO AS VARCHAR2) AS RATIO
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
                  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
                       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
                          ON MA.VER_SEQ = DT.VER_SEQ
                         AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                         AND MA.DEPT_ID = DT.DEPT_ID
                         AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                         AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                         AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                         AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
               ) AS MA
         WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
           AND VER_SEQ = p_ver_seq

        UNION ALL

        SELECT VER_SEQ
             , DEPARTMENT_ID
             , DEPT_ID
             , END_CUST_REPORT
             , SOLDTO_CUST_REPORT
             , PRODUCT_GROUP
             , DM_BIZ_TYPE
             , CAST(CONTRIBUTION_TYPE AS VARCHAR2) AS RATIO
             , 'M#' + YYYYMM + 'GT_DMF0_RBU_0999' AS COLUMN_NAME
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
                  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
                       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
                          ON MA.VER_SEQ = DT.VER_SEQ
                         AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                         AND MA.DEPT_ID = DT.DEPT_ID
                         AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                         AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                         AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                         AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
               ) AS MA
         WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
           AND VER_SEQ = p_ver_seq;

        IF (p_dis = 'ALL') THEN
                -- 불일치 조회 관련 칼럼 추가
                /* TODO:GTT:GT_DMF0_2-->GT_DMF0_2 */
                INSERT INTO GT_DMF0_2
                SELECT MAIN.*
                     , DISCARD.DISCARD
                  FROM GT_DMF0_ MAIN
                       INNER JOIN (SELECT VER_SEQ
                                        , DEPARTMENT_ID
                                        , DEPT_ID
                                        , END_CUST_REPORT
                                        , SOLDTO_CUST_REPORT
                                        , PRODUCT_GROUP
                                        , DM_BIZ_TYPE
                                        , CASE WHEN SUM(CONTRIBUTION_RATIO) = 1200 THEN 'Y' ELSE '' END AS DISCARD
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
                                             FROM DM_MST_CONTRIBUTE_RATIO_MST MA
                                                  INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
                                                     ON MA.VER_SEQ = DT.VER_SEQ
                                                    AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                                                    AND MA.DEPT_ID = DT.DEPT_ID
                                                    AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                                                    AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                                                    AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                                                    AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
                                          ) AS MA
                                    WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
                                      AND VER_SEQ = p_ver_seq
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
                         AND MAIN.DM_BIZ_TYPE = DISCARD.DM_BIZ_TYPE;
                -- ######################## DM_MST_CONTRIBUTE_RATIO 데이터 ########################


                V_Query := '
SELECT *
  FROM (SELECT SITE_ITEM.*
             , RATIO.VER_SEQ
             , CASE WHEN RATIO.DISCARD = ''Y'' THEN RATIO.DISCARD ELSE '''' END DISCARD
             , CASE WHEN ((SITE_ITEM.department_id != '''')
                           AND (SITE_ITEM.dept_id != '''')
                           AND (SITE_ITEM.end_cust_report != '''')
                           AND (SITE_ITEM.SOLDTO_CUST_REPORT != '''')
                           AND (SITE_ITEM.PRODUCT_GROUP != '''')
                           AND (SITE_ITEM.dm_biz_type != ''''));
                          THEN ''Y'' ELSE '''' END AS EDIT_FLAG
             , ' + V_ColumnData2 + '
          FROM (SELECT DISTINCT A.DIVISION_ID
                     , TEAM.DEPARTMENT_ID
                     , TEAM.DEPARTMENT_NAME
                     , TEAM.DEPT_ID AS DEPT_ID
                     , TEAM.DEPT_NAME_KO AS DEPT_NAME
                     , NVL(A.ATTRIBUTE2,'''') AS END_CUST_REPORT
                     , NVL(A.ATTRIBUTE1,'''') AS SOLDTO_CUST_REPORT
                     , NVL(A.REPORT_GROUP3,'''') AS PRODUCT_GROUP --PRODUCT_GR
                     , NVL(C.FORECAST_INFO_BIZ_TYPE,'''') AS DM_BIZ_TYPE
                  FROM SCM_MST_SITE_ITEM A
                       INNER JOIN SCM_MST_SITE B
                          ON A.DIVISION_ID = B.DIVISION_ID
                         AND A.SCM_SITE_ID = B.SCM_SITE_ID
                        LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL SAM
                          ON SAM.SEGMENT1 = B.COMPANY_ID
                         AND SAM.LOOKUP_TYPE = ''INTERNAL_TXN''
                       INNER JOIN DM_MST_ITEM_SINGLE_V C
                          ON A.DIVISION_ID = C.DIVISION_ID
                         AND A.ITEM_ID = C.ITEM_ID
                        LEFT OUTER JOIN (SELECT B.USER_ID
                                              , B.USER_NAME
                                              , B.USER_NAME_EN
                                              , B.DEPT_ID
                                              , C.DEPT_NAME_KO
                                              , D.DEPT_ID AS DEPARTMENT_ID
                                              , D.DEPT_NAME_KO AS DEPARTMENT_NAME
                                           FROM SCM_MST_SSO_USER_INFO B
                                                INNER JOIN SCM_MST_SSO_DEPT_INFO C
                                                   ON B.DEPT_ID = C.DEPT_ID
                                                INNER JOIN SCM_MST_SSO_DEPT_INFO D
                                                   ON C.UPPER_DEPT_ID = D.DEPT_ID
                                        ) AS TEAM
                          ON TEAM.USER_ID IN (SELECTtoken FROM TABLE(fn_string_split(A.OWNER, '','')))
                 WHERE A.DIVISION_ID = ''40''
                   AND B.SITE_TYPE = ''SALES''
                   --AND NVL(C.FORECAST_INFO_BIZ_TYPE,'''') <> ''''
                   --AND NVL(A.ATTRIBUTE2,'''') <> ''''
                   --AND NVL(A.ATTRIBUTE1,'''') <> ''''
                   --AND NVL(A.REPORT_GROUP3,'''') <> ''''
                 GROUP BY A.DIVISION_ID
                     , TEAM.DEPARTMENT_ID
                     , TEAM.DEPARTMENT_NAME
                     , TEAM.DEPT_ID
                     , TEAM.DEPT_NAME_KO
                     , NVL(SAM.SEGMENT3,'''')
                     , NVL(A.ATTRIBUTE2,'''')
                     , NVL(A.ATTRIBUTE1,'''')
                     , NVL(A.REPORT_GROUP3,'''')
                     , NVL(C.FORECAST_INFO_BIZ_TYPE,'''')

               ) AS SITE_ITEM
               LEFT JOIN (SELECT VER_SEQ
                               , DEPARTMENT_ID
                               , DEPT_ID
                               , END_CUST_REPORT
                               , SOLDTO_CUST_REPORT
                               , PRODUCT_GROUP
                               , DM_BIZ_TYPE
                               , DISCARD
                               , ' + V_ColumnData + '
                            FROM (SELECT *
                                    FROM GT_DMF0_2) MA;
                                 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + V_ColumnData + ')) AS PVT
                          ) AS RATIO
                 ON SITE_ITEM.DEPARTMENT_ID   = RATIO.DEPARTMENT_ID
                AND SITE_ITEM.DEPT_ID         = RATIO.DEPT_ID
                AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
                AND SITE_ITEM.SOLDTO_CUST_REPORT  = RATIO.SOLDTO_CUST_REPORT
                AND SITE_ITEM.PRODUCT_GROUP   = RATIO.PRODUCT_GROUP
                AND SITE_ITEM.DM_BIZ_TYPE     = RATIO.DM_BIZ_TYPE
       ) MA;
 WHERE DISCARD = CASE WHEN ''' + p_dis + ''' = ''ALL'' THEN DISCARD ELSE ''' + p_dis + ''' END;
'

FETCH FIRST 1 ROWS ONLY
        ELSE  -- 2019/08/27 (p_dis = 'Y') 추가
                /* TODO:GTT:GT_DMF0_master_list-->GT_DMF0_master_list */
                INSERT INTO GT_DMF0_master_list
                SELECT A.DIVISION_ID
                     , TEAM.DEPARTMENT_ID
                     , TEAM.DEPARTMENT_NAME
                     , TEAM.DEPT_ID AS DEPT_ID
                     , TEAM.DEPT_NAME_KO AS DEPT_NAME
                     , NVL(A.ATTRIBUTE2, NULL) AS END_CUST_REPORT
                     , NVL(A.ATTRIBUTE1, NULL) AS SOLDTO_CUST_REPORT
                     , NVL(A.REPORT_GROUP3, NULL) AS PRODUCT_GROUP --PRODUCT_GR
                     , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) AS DM_BIZ_TYPE
                  FROM SCM_MST_SITE_ITEM A
                       INNER JOIN SCM_MST_SITE B
                          ON A.DIVISION_ID = B.DIVISION_ID
                         AND A.SCM_SITE_ID = B.SCM_SITE_ID
                       INNER JOIN DM_MST_ITEM_SINGLE_V C
                          ON A.DIVISION_ID = C.DIVISION_ID
                         AND A.ITEM_ID = C.ITEM_ID
                        LEFT JOIN (SELECT B.USER_ID
                                        , B.USER_NAME
                                        , B.USER_NAME_EN
                                        , B.DEPT_ID
                                        , C.DEPT_NAME_KO
                                        , D.DEPT_ID AS DEPARTMENT_ID
                                        , D.DEPT_NAME_KO AS DEPARTMENT_NAME
                                     FROM SCM_MST_SSO_USER_INFO B
                                          INNER JOIN SCM_MST_SSO_DEPT_INFO C
                                             ON B.DEPT_ID = C.DEPT_ID
                                          INNER JOIN SCM_MST_SSO_DEPT_INFO D
                                             ON C.UPPER_DEPT_ID = D.DEPT_ID
                                   ) AS TEAM
                          ON TEAM.USER_ID IN (SELECTtoken FROM TABLE(fn_string_split(A.OWNER, ',')))
                 WHERE A.DIVISION_ID = '40'
                   AND B.SITE_TYPE = 'SALES'
                 GROUP BY A.DIVISION_ID
                     , TEAM.DEPARTMENT_ID
                     , TEAM.DEPARTMENT_NAME
                     , TEAM.DEPT_ID
                     , TEAM.DEPT_NAME_KO
                     , NVL(A.ATTRIBUTE2, NULL)
                     , NVL(A.ATTRIBUTE1, NULL)
                     , NVL(A.REPORT_GROUP3, NULL)
                     , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL)

FETCH FIRST 1 ROWS ONLY;

                /* TODO:GTT:GT_DMF0_list-->GT_DMF0_list */
                INSERT INTO GT_DMF0_list
                SELECT MAIN.*
                     , DISCARD.DISCARD
                  FROM GT_DMF0_ MAIN
                       INNER JOIN (SELECT VER_SEQ
                                        , DEPARTMENT_ID
                                        , DEPT_ID
                                        , END_CUST_REPORT
                                        , SOLDTO_CUST_REPORT
                                        , PRODUCT_GROUP
                                        , DM_BIZ_TYPE
                                        , CASE WHEN SUM(CASE WHEN RATIO = 100 THEN 0 ELSE 1 END) > 0 THEN 'Y' ELSE '' END AS DISCARD
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
                                             FROM DM_MST_CONTRIBUTE_RATIO_MST MA
                                                  INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
                                                     ON MA.VER_SEQ = DT.VER_SEQ
                                                    AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
                                                    AND MA.DEPT_ID = DT.DEPT_ID
                                                    AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
                                                    AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
                                                    AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
                                                    AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
                                            WHERE MA.VER_SEQ = p_ver_seq
                                              AND DT.YYYYMM >= v_sdt
                                              AND DT.YYYYMM <= v_edt
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
                 WHERE DISCARD.DISCARD = 'Y';

                V_Query := '
SELECT *
  FROM (SELECT SITE_ITEM.*
             , RATIO.VER_SEQ
             , CASE WHEN RATIO.DISCARD = ''Y'' THEN RATIO.DISCARD ELSE '''' END DISCARD
             , CASE WHEN ((SITE_ITEM.department_id != '''')
                           AND (SITE_ITEM.dept_id != '''')
                           AND (SITE_ITEM.end_cust_report != '''')
                           AND (SITE_ITEM.SOLDTO_CUST_REPORT != '''')
                           AND (SITE_ITEM.PRODUCT_GROUP != '''')
                           AND (SITE_ITEM.dm_biz_type != ''''));
                         THEN ''Y'' ELSE '''' END AS EDIT_FLAG
             ,' + V_ColumnData2 + '
          FROM GT_DMF0_master_list SITE_ITEM
               INNER JOIN (SELECT VER_SEQ
                                , DEPARTMENT_ID
                                , DEPT_ID
                                , END_CUST_REPORT
                                , SOLDTO_CUST_REPORT
                                , PRODUCT_GROUP
                                , DM_BIZ_TYPE
                                , DISCARD
                                , ' + V_ColumnData + '

                             FROM (SELECT *
                                     FROM GT_DMF0_list
                                    WHERE DISCARD = ''Y'') MA;
                            PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + V_ColumnData + ')) AS PVT
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
                           AND (SITE_ITEM.dm_biz_type != ''''));
                         THEN ''Y'' ELSE '''' END AS EDIT_FLAG
             , ' + V_ColumnData2 + '
          FROM GT_DMF0_master_list SITE_ITEM
               LEFT OUTER JOIN (SELECT VER_SEQ
                                     , DEPARTMENT_ID
                                     , DEPT_ID
                                     , END_CUST_REPORT
                                     , SOLDTO_CUST_REPORT
                                     , PRODUCT_GROUP
                                     , DM_BIZ_TYPE
                                     , ' + V_ColumnData + '

                                  FROM (SELECT * FROM GT_DMF0_) MA;
                                 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + V_ColumnData + ')) AS PVT
                               ) AS RATIO
                 ON SITE_ITEM.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
                AND SITE_ITEM.DEPT_ID = RATIO.DEPT_ID
                AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
                AND SITE_ITEM.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
                AND SITE_ITEM.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
                AND SITE_ITEM.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE
         WHERE RATIO.VER_SEQ IS NULL
       ) MA;
'

            END IF;

    ELSE  -- (p_his = 'Y')
        -- ######################## 데이터 ########################
        /* TODO:GTT:GT_DMF0_DataTable-->GT_DMF0_DataTable */
        INSERT INTO GT_DMF0_DataTable
        SELECT CONTRIBUTE.*
             , SITE_ITEM.DIVISION_ID
          FROM (SELECT MA.VER_SEQ
                     , MA.DEPARTMENT_ID
                     , MA.DEPT_ID
                     , MA.END_CUST_REPORT
                     , MA.SOLDTO_CUST_REPORT
                     , MA.PRODUCT_GROUP
                     , MA.DM_BIZ_TYPE
                  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
               ) AS CONTRIBUTE
               LEFT OUTER JOIN (
                    SELECT DISTINCT
                           A.DIVISION_ID
                         , TEAM.DEPARTMENT_ID
                         , TEAM.DEPARTMENT_NAME
                         , TEAM.DEPT_ID AS DEPT_ID
                         , TEAM.DEPT_NAME_KO AS DEPT_NAME
                         , NVL(A.ATTRIBUTE2, NULL) AS END_CUST_REPORT
                         , NVL(A.ATTRIBUTE1, NULL) AS SOLDTO_CUST_REPORT
                         , NVL(A.REPORT_GROUP3, NULL) AS PRODUCT_GROUP
                         , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) AS DM_BIZ_TYPE
                      FROM SCM_MST_SITE_ITEM A
                           INNER JOIN SCM_MST_SITE B
                              ON A.DIVISION_ID = B.DIVISION_ID
                             AND A.SCM_SITE_ID = B.SCM_SITE_ID
                            LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL SAM
                              ON SAM.SEGMENT1 = B.COMPANY_ID
                             AND SAM.LOOKUP_TYPE = 'INTERNAL_TXN'
                           INNER JOIN DM_MST_ITEM_SINGLE_V C
                              ON A.DIVISION_ID = C.DIVISION_ID
                             AND A.ITEM_ID = C.ITEM_ID
                            LEFT JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN
                                            , B.DEPT_ID, C.DEPT_NAME_KO, D.DEPT_ID AS DEPARTMENT_ID
                                            , D.DEPT_NAME_KO AS DEPARTMENT_NAME
                                         FROM SCM_MST_SSO_USER_INFO B
                                              INNER JOIN SCM_MST_SSO_DEPT_INFO C
                                                 ON B.DEPT_ID = C.DEPT_ID
                                              INNER JOIN SCM_MST_SSO_DEPT_INFO D
                                                 ON C.UPPER_DEPT_ID = D.DEPT_ID
                                      ) AS TEAM
                              ON TEAM.USER_ID IN (SELECTTOKEN FROM TABLE(fn_string_split(A.OWNER, ',')))
                     WHERE A.DIVISION_ID = '40'
                       AND B.SITE_TYPE = 'SALES'
                       AND NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) IS NOT NULL
                       AND NVL(A.ATTRIBUTE2, NULL) IS NOT NULL
                       AND NVL(A.ATTRIBUTE1, NULL) IS NOT NULL
                       AND NVL(A.REPORT_GROUP3, NULL) IS NOT NULL
                     GROUP BY A.DIVISION_ID
                         , TEAM.DEPARTMENT_ID
                         , TEAM.DEPARTMENT_NAME
                         , TEAM.DEPT_ID
                         , TEAM.DEPT_NAME_KO
                         , NVL(SAM.SEGMENT3, NULL)
                         , NVL(A.ATTRIBUTE2, NULL)
                         , NVL(A.ATTRIBUTE1, NULL)
                         , NVL(A.REPORT_GROUP3, NULL)
                         , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL)
                   ) AS SITE_ITEM
                 ON SITE_ITEM.DEPARTMENT_ID = CONTRIBUTE.DEPARTMENT_ID
                AND SITE_ITEM.DEPT_ID = CONTRIBUTE.DEPT_ID
                AND SITE_ITEM.END_CUST_REPORT = CONTRIBUTE.END_CUST_REPORT
                AND SITE_ITEM.SOLDTO_CUST_REPORT = CONTRIBUTE.SOLDTO_CUST_REPORT
                AND SITE_ITEM.PRODUCT_GROUP = CONTRIBUTE.PRODUCT_GROUP
                AND SITE_ITEM.DM_BIZ_TYPE = CONTRIBUTE.DM_BIZ_TYPE
         WHERE SITE_ITEM.DIVISION_ID IS NULL

        -- 연도 데이터
FETCH FIRST 1 ROWS ONLY
        /* TODO:GTT:GT_DMF0_3-->GT_DMF0_3 */
        INSERT INTO GT_DMF0_3
        SELECT MA.VER_SEQ
             , MA.DEPARTMENT_ID
             , MA.DEPT_ID
             , MA.END_CUST_REPORT
             , MA.SOLDTO_CUST_REPORT
             , MA.PRODUCT_GROUP
             , MA.DM_BIZ_TYPE
             , CAST(DTL.CONTRIBUTION_RATIO AS VARCHAR2) AS RATIO
             , 'Y#' + p_yyyy + '#' + DTL.OS_CORP_CD AS COLUMN_NAME
          FROM GT_DMF0_DataTable MA
               INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
                  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
                 AND MA.DEPT_ID = DTL.DEPT_ID
                 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
                 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
                 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
                 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
         WHERE YYYYMM = v_thismm
           AND MA.VER_SEQ = p_ver_seq

        UNION ALL

        SELECT MA.VER_SEQ
             , MA.DEPARTMENT_ID
             , MA.DEPT_ID
             , MA.END_CUST_REPORT
             , MA.SOLDTO_CUST_REPORT
             , MA.PRODUCT_GROUP
             , MA.DM_BIZ_TYPE
             , CAST(DTL.CONTRIBUTION_TYPE AS VARCHAR2) AS RATIO
             , 'Y#' + p_yyyy + 'GT_DMF0_RBU_0999' AS COLUMN_NAME
          FROM GT_DMF0_DataTable MA
               INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
                  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
                 AND MA.DEPT_ID = DTL.DEPT_ID
                 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
                 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
                 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
                 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
         WHERE YYYYMM = v_thismm
           AND MA.VER_SEQ = p_ver_seq

        UNION ALL

        -- 월 데이터
        SELECT MA.VER_SEQ
             , MA.DEPARTMENT_ID
             , MA.DEPT_ID
             , MA.END_CUST_REPORT
             , MA.SOLDTO_CUST_REPORT
             , MA.PRODUCT_GROUP
             , MA.DM_BIZ_TYPE
             , CAST(DTL.CONTRIBUTION_RATIO AS VARCHAR2) AS RATIO
             , 'M#' + YYYYMM + '#' + OS_CORP_CD AS COLUMN_NAME
          FROM GT_DMF0_DataTable MA
               INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
                  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
                 AND MA.DEPT_ID = DTL.DEPT_ID
                 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
                 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
                 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
                 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
         WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
           AND MA.VER_SEQ = p_ver_seq

        UNION ALL

        SELECT MA.VER_SEQ
             , MA.DEPARTMENT_ID
             , MA.DEPT_ID
             , MA.END_CUST_REPORT
             , MA.SOLDTO_CUST_REPORT
             , MA.PRODUCT_GROUP
             , MA.DM_BIZ_TYPE
             , CAST(DTL.CONTRIBUTION_TYPE AS VARCHAR2) AS RATIO
             , 'M#' + YYYYMM + 'GT_DMF0_RBU_0999' AS COLUMN_NAME
          FROM GT_DMF0_DataTable MA
               INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
                  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
                 AND MA.DEPT_ID = DTL.DEPT_ID
                 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
                 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
                 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
                 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
         WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
           AND MA.VER_SEQ = p_ver_seq;
        -- select * from GT_DMF0_
        -- ######################## 데이터 ########################

        V_Query := '
SELECT VER_SEQ
     , DEPARTMENT_ID
     , DEPT_ID
     , END_CUST_REPORT
     , SOLDTO_CUST_REPORT
     , PRODUCT_GROUP
     , DM_BIZ_TYPE
     , '''' AS EDIT_FLAG
     , ' + V_ColumnData + '
  FROM (SELECT *
          FROM GT_DMF0_3) MA;
 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + V_ColumnData + ')) AS PVT
'
    END IF;

    --SELECT CAST(V_Query AS TEXT)
    --FOR XML PATH('')--,ROOT('x')

    EXECUTE SP_EXECUTESQL V_Query

END;
/
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0043_GET_CONTRIBUTION_SALES_LIST
(
    p_division_id      VARCHAR2,
    p_ver_seq          VARCHAR2,
    p_version_no       VARCHAR2,
    p_end_cust_report  VARCHAR2,
    p_product_group    VARCHAR2,
    p_biz_type         VARCHAR2,
    p_million_yn       VARCHAR2,
    p_compatibility_yn VARCHAR2,
    p_created_by       VARCHAR2
/****************************************************************************************************/
)
AS

/*
 * ========================================
 * [변환검증] 2026-03-02 20:37:24
 * 파일: dbo.DMF0043_GET_CONTRIBUTION_SALES_LIST.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:1  END:2  차이:-1
 * ----------------------------------------
 * BEGIN 위치: L40
 * END;  위치: L196, L686
 * ----------------------------------------
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */



    v_sql_text VARCHAR2(4000 CHAR);
    v_code VARCHAR2(4000 CHAR);
    v_large_code VARCHAR2(4000 CHAR);
    v_small_code VARCHAR2(4000 CHAR);
    v_groupby VARCHAR2(4000 CHAR);
    v_orderby VARCHAR2(4000 CHAR);
    v_col_name VARCHAR2(50 CHAR);
    v_sort_order_no VARCHAR2(50 CHAR);
    v_program_id VARCHAR2(10 CHAR);
    v_sheet_name VARCHAR2(100 CHAR);
    v_user_col_cnt INTEGER;
    v_seq INTEGER;
    v_col VARCHAR2(4000 CHAR);
    v_col_Sum VARCHAR2(4000 CHAR) := NULL;
    v_bottom VARCHAR2(4000 CHAR);
    v_bottom_Sum VARCHAR2(4000 CHAR) := NULL;
    v_col_Total VARCHAR2(4000 CHAR) := NULL;
    v_nsql2 VARCHAR2(4000 CHAR);
    va_program_id VARCHAR2(4000 CHAR);
    va_sheet_name VARCHAR2(4000 CHAR);
BEGIN























    va_program_id := 'DMF0043';
    va_sheet_name := 'ContributeSalesList';

    v_col_name := NULL;
    v_col := NULL;
    v_groupby := NULL;
    v_user_col_cnt := 0;

    SELECT COUNT(*)
  INTO v_user_col_cnt
    FROM   SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND  U.PROGRAM_ID = va_program_id
    AND    U.SHEET_NAME = va_sheet_name
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID    = p_created_by;

    IF v_user_col_cnt = 0 THEN
        INSERT INTO SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT p_created_by
             , C.PROGRAM_ID
      , C.SHEET_NAME
             , 'C'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , ''
             , ''
             , p_created_by
             , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3')
             , p_created_by
             , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3')
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = va_program_id
        AND    C.SHEET_NAME  = va_sheet_name
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y' ;
    END IF;

    --정렬 정보 쿼리 add son young suk 20180727
    v_nsql2 := 'SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , U.SORT_ORDER_NO
             , U.DATA_SORT_METHOD_CODE
        FROM   SCM_MST_TITLESET_USER U
             , SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = '''  ||  va_program_id  || '''
        AND    U.SHEET_NAME  = '''  ||  va_sheet_name  || '''
        AND    U.USER_ID     = '''  ||  p_created_by  ||  '''
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = ''C''
        AND    C.VALID_YN = ''Y''
        AND  '''  ||  p_division_id  ||  ''' IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,'','')) )  -- 20190214
        UNION ALL
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = '''  ||  va_program_id  || '''
        AND    C.SHEET_NAME  = '''  ||  va_sheet_name  || '''
        AND    C.DEFAULT_FLAG = ''''
        AND    C.VALID_YN     = ''Y''
        ORDER BY SORT_ORDER_NO';

    -- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- c_title CURSOR FAST_FORWARD FOR
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , U.SORT_ORDER_NO
        FROM   SCM_MST_TITLESET_USER U
             , SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = va_program_id
        AND    U.SHEET_NAME  = va_sheet_name
        AND    U.USER_ID     = p_created_by
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        UNION ALL
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = va_program_id
        AND    C.SHEET_NAME  = va_sheet_name
        AND    C.DEFAULT_FLAG IS NULL
        AND    C.VALID_YN     = 'Y'
        ORDER BY SORT_ORDER_NO ;

    OPEN c_title;
    FETCH c_title INTO v_program_id, v_sheet_name, v_col_name, v_sort_order_no;
    WHILE v_fetch_status = 0 LOOP
      IF v_col = '' THEN
			  v_col := 'A.'  ||  v_col_name;
			  v_groupby := ' GROUP BY A.'  ||  v_col_name;
			  v_orderby := ' ORDER BY A.'  ||  v_col_name;
			  -- 합계로우용
			  v_bottom := '''Total''';
      ELSE
              v_col := v_col  ||  ', A.'  ||  v_col_name;
              v_groupby := v_groupby  ||  ', A.'  ||  v_col_name;
              v_orderby := v_orderby  ||  ', A.'  ||  v_col_name;
			  -- 합계 로우 용
			  v_bottom := v_bottom  ||  ', null';
          END IF;
          END LOOP;

      FETCH c_title INTO v_program_id, v_sheet_name, v_col_name, v_sort_order_no;
    END;

    CLOSE c_title;
    DEALLOCATE c_title;

    /*/*

    /* TODO:GTT:GT_DMF0_sales_plan_c-->GT_DMF0_sales_plan_c */
    INSERT INTO GT_DMF0_sales_plan_c
    SELECT DIVISION_ID
         , VERSION_NO
		 , PROJECT_CODE
         , SCM_SITE_ID
         , ITEM_ID
         , YYYYMMDD
         , QTY
      FROM DM_PLN_SALES_PLAN_C
     WHERE DIVISION_ID = p_division_id
       AND VERSION_NO = p_version_no
       AND MEASURE = 'SalesAmt_USD'
       AND SCM_SITE_ID NOT IN (SELECT SEGMENT1
                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                       WHERE LOOKUP_TYPE = 'INTERNAL_TXN')  -- 20190906 소거매출 제외
       AND YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq) || '%';




    /* TODO:GTT:GT_DMF0_sales_result_c-->GT_DMF0_sales_result_c */
    INSERT INTO GT_DMF0_sales_result_c
    SELECT PR.DIVISION_ID
         , PR.VERSION_NO
         , PR.PROJECT_CODE
         , PR.SCM_SITE_ID
         , PR.ITEM_ID
         , PR.YYYYMMDD
         , CASE WHEN NVL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
                ELSE PR.QTY/NVL(FP.EXCHANGE_PRICE,0)
           END AS QTY
      FROM DM_PLN_SALES_PLAN_RESULT_C PR
           LEFT OUTER JOIN DM_MST_EXCHANGE_RATE_C FP
             ON PR.DIVISION_ID = FP.DIVISION_ID
            AND PR.VERSION_NO = FP.VERSION_NO
            AND SUBSTR(PR.YYYYMMDD,1,6) || '01' = FP.YYYYMMDD
            AND FP.UNIT_CURRENCY = 'USD'
     WHERE PR.DIVISION_ID = p_division_id
       AND PR.VERSION_NO = p_version_no
       AND PR.MEASURE = 'SalesAmt_KRW'
       AND PR.SCM_SITE_ID NOT IN (SELECT SEGMENT1
                                    FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                   WHERE LOOKUP_TYPE = 'INTERNAL_TXN')  -- 20190906 소거매출 제외
       AND PR.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq) || '%';
	*/

	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_plan_report_c';

	IF ( p_version_no LIKE 'BP%') THEN
		INSERT INTO GT_DMF0_plan_report_c
		SELECT DIVISION_ID
			 , VERSION_NO
			 , PROJECT_CODE
			 , SCM_SITE_ID
			 , ITEM_ID
			 , YYYYMMDD
			 , QTY
		 FROM (
				   SELECT DIVISION_ID
					 , VERSION_NO
					 , PROJECT_CODE
					 , SCM_SITE_ID
					 , ITEM_ID
					 , YYYYMM AS YYYYMMDD
					 , QTY
				  FROM DM_PLN_BP_FCST_REPORT_C
				 WHERE DIVISION_ID = p_division_id
				   AND VERSION_NO = p_version_no
				   AND MEASURE = 'SalesAmt_USD'
				   AND SCM_SITE_ID NOT IN (
											--SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WHERE LOOKUP_TYPE = 'INTERNAL_TXN'  -- 20190906 소거매출 제외 -- 20200427 KHSONG 주석처리
											SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN   -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
											)
				   AND YYYYMM LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq) || '%'
				   ) A;
	ELSE
		INSERT INTO GT_DMF0_plan_report_c
		SELECT DIVISION_ID
			 , VERSION_NO
			 , PROJECT_CODE
			 , SCM_SITE_ID
			 , ITEM_ID
			 , YYYYMMDD
			 , QTY
		 FROM ( SELECT DIVISION_ID
					 , VERSION_NO
					 , PROJECT_CODE
					 , SCM_SITE_ID
					 , ITEM_ID
					 , YYYYMMDD
					 , QTY
				  FROM DM_PLN_SALES_PLAN_REPORT_C
				 WHERE DIVISION_ID = p_division_id
				   AND VERSION_NO = p_version_no
				   AND MEASURE = 'SalesAmt_USD'
				   AND SCM_SITE_ID NOT IN (
											--SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WHERE LOOKUP_TYPE = 'INTERNAL_TXN'  -- 20190906 소거매출 제외 -- 20200427 KHSONG 주석처리
											SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN   -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
											)
				   AND YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq) || '%'
				) A;
	END IF;

    /* TODO:GTT:GT_DMF0_sales_list_c-->GT_DMF0_sales_list_c */
    INSERT INTO GT_DMF0_sales_list_c
    SELECT *
      FROM
          (SELECT SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
             , TEAM.DEPARTMENT_ID
             , TEAM.DEPARTMENT_NAME
             , TEAM.DEPT_ID
             , TEAM.DEPT_NAME_KO AS DEPT_NAME
             , NVL(I.REPORT_GROUP2, NULL) AS CUST_REPORT
             , NVL(I.ATTRIBUTE2, NULL) AS END_CUST_REPORT
             , NVL(I.ATTRIBUTE1, NULL) AS SOLDTO_CUST_REPORT
             , NVL(SC.SHIPTO_CODE, NULL) AS SHIPTO_CODE
             , NVL(I.REPORT_GROUP3, NULL) AS PRODUCT_GROUP
             , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) AS DM_BIZ_TYPE
             , CASE WHEN NVL(p_million_yn,'') = 'Y' THEN SUM(QTY)/1000000 ELSE SUM(QTY) END AS AMT
			 , 'Y' AS EDIT_FLAG
          FROM GT_DMF0_plan_report_c A  --Inner join에서 Left join 으로 변경
                LEFT JOIN SCM_MST_SITE_ITEM I
                  ON A.DIVISION_ID = I.DIVISION_ID
                 AND A.PROJECT_CODE = I.PROJECT_CODE
                 AND A.SCM_SITE_ID = I.SCM_SITE_ID
                 AND A.ITEM_ID = I.ITEM_ID
                LEFT JOIN SCM_MST_SITE_CUSTOMER SC
                  ON SC.DIVISION_ID = I.DIVISION_ID
                 AND SC.SCM_SITE_ID = I.SCM_SITE_ID
                 AND SC.REP_YN      = 'Y'
                LEFT JOIN SCM_MST_SITE B
                  ON A.DIVISION_ID = B.DIVISION_ID
				 AND A.SCM_SITE_ID = B.SCM_SITE_ID
                LEFT JOIN DM_MST_ITEM_SINGLE_V C
                  ON A.DIVISION_ID = C.DIVISION_ID
                 AND A.ITEM_ID = C.ITEM_ID
                 --AND NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) IS NOT NULL
                LEFT JOIN (
                        SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
                        FROM SCM_MST_SSO_USER_INFO B
                        INNER JOIN SCM_MST_SSO_DEPT_INFO C
                        ON B.DEPT_ID = C.DEPT_ID
                        INNER JOIN SCM_MST_SSO_DEPT_INFO D
                        ON C.UPPER_DEPT_ID = D.DEPT_ID
                    ) AS TEAM
      ON TEAM.USER_ID IN (SELECT column_value FROM TABLE(SCM_MGR.FN_SPLIT_STR(I.OWNER, ',')))
         WHERE A.DIVISION_ID = p_division_id
           AND A.VERSION_NO = p_version_no
           AND A.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq) || '%'
         GROUP BY SUBSTR(A.YYYYMMDD,1,6)
             , TEAM.DEPARTMENT_ID
             , TEAM.DEPARTMENT_NAME
             , TEAM.DEPT_ID
             , TEAM.DEPT_NAME_KO
             , NVL(I.REPORT_GROUP2, NULL)
             , NVL(I.ATTRIBUTE2, NULL)
             , NVL(I.ATTRIBUTE1, NULL)
             , NVL(SC.SHIPTO_CODE, NULL)
             , NVL(I.REPORT_GROUP3, NULL)
             , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL)
			 /*
        UNION ALL

FETCH FIRST 1 ROWS ONLY
        SELECT SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
             , TEAM.DEPARTMENT_ID
             , TEAM.DEPARTMENT_NAME
             , TEAM.DEPT_ID
             , TEAM.DEPT_NAME_KO AS DEPT_NAME
             , NVL(I.REPORT_GROUP2, NULL) AS CUST_REPORT
             , NVL(I.ATTRIBUTE2, NULL) AS END_CUST_REPORT
             , NVL(I.ATTRIBUTE1, NULL) AS SOLDTO_CUST_REPORT
             , NVL(SC.SHIPTO_CODE, NULL) AS SHIPTO_CODE
             , NVL(I.REPORT_GROUP3, NULL) AS PRODUCT_GROUP
             , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) AS DM_BIZ_TYPE
             , CASE WHEN NVL(p_million_yn,'') = 'Y' THEN SUM(QTY)/1000000 ELSE SUM(QTY) END AS AMT
			 , 'Y' AS EDIT_FLAG
          FROM GT_DMF0_sales_result_c A
               INNER JOIN SCM_MST_SITE_ITEM I
ON A.DIVISION_ID = I.DIVISION_ID
                 AND A.PROJECT_CODE = I.PROJECT_CODE
                 AND A.SCM_SITE_ID = I.SCM_SITE_ID
                 AND A.ITEM_ID = I.ITEM_ID
               INNER JOIN SCM_MST_SITE_CUSTOMER SC
                  ON SC.DIVISION_ID = I.DIVISION_ID
            AND SC.SCM_SITE_ID = I.SCM_SITE_ID
                 AND SC.REP_YN      = 'Y'
               INNER JOIN SCM_MST_SITE B
                  ON A.DIVISION_ID = B.DIVISION_ID
                 AND A.SCM_SITE_ID = B.SCM_SITE_ID
               INNER JOIN DM_MST_ITEM_SINGLE_V C
ON A.DIVISION_ID = C.DIVISION_ID
                 AND A.ITEM_ID = C.ITEM_ID
                 --AND NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) IS NOT NULL
               LEFT JOIN (
                        SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
                        FROM SCM_MST_SSO_USER_INFO B
                        INNER JOIN SCM_MST_SSO_DEPT_INFO C
                        ON B.DEPT_ID = C.DEPT_ID
                        INNER JOIN SCM_MST_SSO_DEPT_INFO D
                        ON C.UPPER_DEPT_ID = D.DEPT_ID
                    ) AS TEAM
                    ON TEAM.USER_ID IN (SELECT column_value FROM TABLE(SCM_MGR.FN_SPLIT_STR(I.OWNER, ',')))
         WHERE A.DIVISION_ID = p_division_id
           AND A.VERSION_NO = p_version_no
           AND A.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq)+'%'
         GROUP BY SUBSTR(A.YYYYMMDD,1,6)
             , TEAM.DEPARTMENT_ID
             , TEAM.DEPARTMENT_NAME
             , TEAM.DEPT_ID
             , TEAM.DEPT_NAME_KO
             , NVL(I.REPORT_GROUP2, NULL)
             , NVL(I.ATTRIBUTE2, NULL)
             , NVL(I.ATTRIBUTE1, NULL)
             , NVL(SC.SHIPTO_CODE, NULL)
             , NVL(I.REPORT_GROUP3, NULL)
             , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL)*/
             ) A;


    -- TODO: CURSOR-->BULK COLLECT 변환 필요
    -- c_code CURSOR FAST_FORWARD FOR
FETCH FIRST 1 ROWS ONLY
	SELECT DISTINCT CODE, LARGE_CODE, SMALL_CODE, SEQ
	FROM (
		SELECT
			  L.SEGMENT1 + '#'  ||  CASE WHEN L.SEGMENT4 = 'Y' THEN '' ELSE M.SEGMENT1 END AS CODE
			, L.SEGMENT1  AS LARGE_CODE
			, CASE WHEN L.SEGMENT4 = 'Y' THEN L.SEGMENT1 ELSE M.SEGMENT1 END AS SMALL_CODE
			, RANK() OVER ( ORDER BY L.DISPLAY_SEQ, CASE WHEN L.SEGMENT4 = 'Y' THEN 0 ELSE M.DISPLAY_SEQ END ) AS SEQ
		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
			,  SCM_ADM_LOOKUP_MASTER_DETAIL M
		WHERE  1 = 1
		AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
		AND    M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
		AND    L.VALID_YN    = 'Y'
		AND    L.SEGMENT3    = 'Y'
		AND    M.VALID_YN    = 'Y'
		) A;
    ORDER BY A.SEQ;


    v_sql_text := ';
WITH SALES_LIST AS (
    SELECT A.YYYYMM
         , A.DEPARTMENT_NAME
         , A.DEPT_NAME
         , A.DEPARTMENT_ID
         , A.DEPT_ID
       , A.CUST_REPORT
         , A.END_CUST_REPORT
         , A.SOLDTO_CUST_REPORT
         , A.SHIPTO_CODE
         , A.PRODUCT_GROUP
         , A.DM_BIZ_TYPE
		 , A.EDIT_FLAG '
    FROM DUAL;

    OPEN c_code;
    FETCH c_code INTO v_code, v_large_code, v_small_code, v_seq; -- v_seq 는 사용하지 않음. 커서문에서 distinct 를 넣기 위해 사용
    WHILE v_fetch_status = 0 LOOP
        v_sql_text := v_sql_text  ||  '
         , SUM(CASE WHEN NVL(B.CONTRIBUTION_RATIO,0) > 0 AND B.CONTRIBUTION_TYPE = '''  ||  v_small_code  ||  ''' AND B.OS_CORP_CD = '''  ||  v_large_code  ||  '''
                         THEN B.CONTRIBUTION_RATIO/100*A.AMT
                    ELSE 0
               END) AS '  ||  v_code  ||  ' ';

--select v_code

		-- 행별합계
		IF v_code NOT LIKE '%Total%' THEN
			v_col_Sum := v_col_Sum  ||  ', SUM(' || v_code || ') AS '  ||  v_code;
			v_bottom_Sum := v_bottom_Sum  ||  ', SUM(' || v_code || ') AS '  ||  v_code;
		END IF;
		END LOOP;

		---- 컬럼합계 ( Total )
		IF v_code NOT LIKE '%Total%' THEN
			v_col_Total := v_col_Total  ||   CASE WHEN v_col_Total = '' THEN '' ELSE ' +' END  ||  'NVL(SUM('  ||  v_code  ||  '), 0)';
		ELSE  -- Total 컬럼에서는 AS 를 붙여서 마무리
			v_col_Total := v_col_Total  ||  ' AS '  ||  v_code

-- select v_col_Sum as v_sum_column, v_code as v_code, v_col_Total, v_ttsum_column_com

        FETCH c_code INTO v_code, v_large_code, v_small_code, v_seq;
    END IF;

    CLOSE c_code;
    DEALLOCATE c_code;


    v_sql_text := v_sql_text  ||  '
      FROM GT_DMF0_sales_list_c A
INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL B
              ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
             AND A.DEPT_ID = B.DEPT_ID
             AND A.END_CUST_REPORT = B.END_CUST_REPORT
             AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
             AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
             AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE
             AND A.YYYYMM = B.YYYYMM
     WHERE B.VER_SEQ = '  ||  p_ver_seq  ||  ';
     v_end_cust_report
     v_product_group
     v_biz_type
     ';

     v_sql_text := v_sql_text  ||  '
     GROUP BY A.YYYYMM
         , A.DEPARTMENT_NAME
         , A.DEPT_NAME
         , A.DEPARTMENT_ID
         , A.DEPT_ID
         , A.CUST_REPORT
         , A.END_CUST_REPORT
         , A.SOLDTO_CUST_REPORT
         , A.SHIPTO_CODE
         , A.PRODUCT_GROUP
         , A.DM_BIZ_TYPE
		 , A.EDIT_FLAG
)

SELECT v_col  v_col_Sum,'  ||  v_col_Total  ||  '
FROM   SALES_LIST A;
v_groupby
UNION ALL	--합계행
SELECT v_bottom v_bottom_Sum,'  ||  v_col_Total  ||  '
FROM   SALES_LIST A;
v_orderby
';


--    v_sql_text := REPLACE(v_sql_text,'v_end_cust_report'  , FN_SCM_GET_WHERE_SQL('A.END_CUST_REPORT'  , 'IN', p_end_cust_report));
    v_sql_text := REPLACE(v_sql_text,'v_end_cust_report'  , ' AND A.END_CUST_REPORT LIKE ''%'  ||  p_end_cust_report  ||  '%'' ');
    v_sql_text := REPLACE(v_sql_text,'v_product_group'  , FN_SCM_GET_WHERE_SQL('A.PRODUCT_GROUP'  , 'IN', p_product_group));
    v_sql_text := REPLACE(v_sql_text,'v_biz_type'  , FN_SCM_GET_WHERE_SQL('A.DM_BIZ_TYPE'  , 'IN', p_biz_type));
    v_sql_text := REPLACE(v_sql_text,'v_col'  , v_col);
	v_sql_text := REPLACE(v_sql_text,'v_bottom'  , v_bottom);
    v_sql_text := REPLACE(v_sql_text,'v_col_Sum'  , v_col_Sum);
 --   v_sql_text := REPLACE(v_sql_text,'v_col_Sum'  , v_col_Sum);
 --   v_sql_text := REPLACE(v_sql_text,'v_col_Sum'  , v_col_Sum);
    v_sql_text := REPLACE(v_sql_text,'v_bottom_Sum'  , v_bottom_Sum);
    v_sql_text := REPLACE(v_sql_text,'v_groupby'  , v_groupby);
    v_sql_text := REPLACE(v_sql_text,'v_orderby'  , v_orderby);

    --select v_col;
    --select v_sql_text;
    --return;
    SP_EXECUTESQL v_sql_text;
    SP_EXECUTESQL v_nsql2;

    IF NVL(p_compatibility_yn,'') = 'Y' THEN
        SELECT
            -- 등록이 안된 건 count
            (SELECT COUNT(*)
              FROM (SELECT TEAM.DEPARTMENT_ID
                         , TEAM.DEPT_ID AS DEPT_ID
                         , NVL(A.ATTRIBUTE2, NULL) AS END_CUST_REPORT
                         , NVL(A.ATTRIBUTE1, NULL) AS SOLDTO_CUST_REPORT
                         , NVL(A.REPORT_GROUP3, NULL) AS PRODUCT_GROUP
                         , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) AS DM_BIZ_TYPE
                      FROM SCM_MST_SITE_ITEM A
                           INNER JOIN SCM_MST_SITE B
                              ON A.DIVISION_ID = B.DIVISION_ID
                             AND A.SCM_SITE_ID = B.SCM_SITE_ID
                           INNER JOIN DM_MST_ITEM_SINGLE_V C
                              ON A.DIVISION_ID = C.DIVISION_ID
                             AND A.ITEM_ID = C.ITEM_ID
                           LEFT JOIN (
                                    SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
                                         , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
                                      FROM SCM_MST_SSO_USER_INFO B
                                           INNER JOIN SCM_MST_SSO_DEPT_INFO C
                                              ON B.DEPT_ID = C.DEPT_ID
                                           INNER JOIN SCM_MST_SSO_DEPT_INFO D
                  ON C.UPPER_DEPT_ID = D.DEPT_ID
                                     ) AS TEAM
                              ON TEAM.USER_ID IN (SELECT column_value FROM TABLE(SCM_MGR.FN_SPLIT_STR(A.OWNER, ',')))
                     WHERE A.DIVISION_ID = p_division_id
                       AND B.SITE_TYPE = 'SALES'
                       AND NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) IS NOT NULL
                       AND NVL(A.ATTRIBUTE2, NULL) IS NOT NULL
                       AND NVL(A.ATTRIBUTE1, NULL) IS NOT NULL
                       AND NVL(A.REPORT_GROUP3, NULL) IS NOT NULL
                     GROUP BY A.DIVISION_ID
                         , TEAM.DEPARTMENT_ID
                         , TEAM.DEPT_ID
                         , NVL(A.ATTRIBUTE2, NULL)
                         , NVL(A.ATTRIBUTE1, NULL)
                         , NVL(A.REPORT_GROUP3, NULL)
                         , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL)
                   ) LIST;
                  LEFT OUTER JOIN DM_MST_CONTRIBUTE_RATIO_MST RATIO
                    ON LIST.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
                   AND LIST.DEPT_ID = RATIO.DEPT_ID
                   AND LIST.END_CUST_REPORT = RATIO.END_CUST_REPORT
                   AND LIST.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
                   AND LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
                   AND LIST.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE
             WHERE RATIO.DEPARTMENT_ID IS NULL
               AND RATIO.VER_SEQ = p_ver_seq)
                ||
            -- 100%가 안되는 건 COUNT
            (SELECT COUNT(*)
              FROM (SELECT SUM(A.CONTRIBUTION_RATIO) AS RATIO
                      FROM DM_MST_CONTRIBUTE_RATIO_MST M
                           INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL A
                              ON M.VER_SEQ = A.VER_SEQ
                             AND M.DEPARTMENT_ID = A.DEPARTMENT_ID
                             AND M.DEPT_ID = A.DEPT_ID
                             AND M.END_CUST_REPORT = A.END_CUST_REPORT
                             AND M.SOLDTO_CUST_REPORT = A.SOLDTO_CUST_REPORT
                             AND M.PRODUCT_GROUP = A.PRODUCT_GROUP
                             AND M.DM_BIZ_TYPE = A.DM_BIZ_TYPE
                     WHERE A.VER_SEQ = p_ver_seq
                     GROUP BY A.DEPARTMENT_ID
                            , A.DEPT_ID
                            , A.END_CUST_REPORT
                            , A.SOLDTO_CUST_REPORT
                            , A.PRODUCT_GROUP
                            , A.DM_BIZ_TYPE
                            , A.YYYYMM
                   ) R;
             WHERE R.RATIO <> 100)
			 ||
			(
FETCH FIRST 1 ROWS ONLY
			 SELECT COUNT(*)
			  FROM GT_DMF0_sales_list_c A
			left outer JOIN DM_MST_CONTRIBUTE_RATIO_DTL B
						  ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
						 AND A.DEPT_ID = B.DEPT_ID
						 AND A.END_CUST_REPORT = B.END_CUST_REPORT
						 AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
						 AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
						 AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE
						 AND A.YYYYMM = B.YYYYMM
						 and B.VER_SEQ = 2
				 WHERE A.END_CUST_REPORT LIKE '%%'
				  and b.dept_id is null
				) AS CNT;
    ELSE
        SELECT 0 AS CNT
        FROM DUAL;
    END IF;

-- --xml확인할경우
--SELECT CAST(v_sql_text AS TEXT)
--FOR XML PATH('')--,ROOT('x')


 /*
select max(version_no) from dm_pln_sales_plan_c ;

select * from DM_MST_CONTRIBUTE_VER where version_no = 'SP_W_20190905_V001'


DMF0043_GET_CONTRIBUTION_SALES_LIST
p_division_id='40',
p_ver_seq='19',
p_version_no='SP_W_20190905_V001',
p_end_cust_report='',
p_product_group='ALL',
p_biz_type='ALL',
p_million_yn='',
p_compatibility_yn='',
p_created_by='hwi1993'


DMF0043_GET_CONTRIBUTION_SALES_LIST
    p_division_id = '40',
    p_ver_seq = 1,
    p_version_no = 'SP_W_20190905_V001',
    p_end_cust_report IS NULL,
    p_product_group   IS NULL,
    p_biz_type         IS NULL,
    p_million_yn       = '',
    p_compatibility_yn = 'Y',
    p_created_by       = 'hwi1993'

 */

 END;
/
