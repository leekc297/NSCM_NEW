WITH BOH AS (
                     SELECT A.DIVISION_ID
                          , A.PLAN_START_YYYYMMDD
                          , A.PLAN_TYPE
                          , A.SEQ
                          , A.FROM_SITE
                          , A.ITEM_ID
                          , SUM(A.QTY)   AS QTY
                     FROM   (
                            SELECT A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.FROM_SITE
                                 , A.ITEM_ID
                                 , (CASE WHEN NVL(C.SEGMENT3, '-') = 'P' THEN SUM(A.LOT_QTY_MES) ELSE 0 END) AS QTY
                            FROM   SSP_ANL_MES_FCS_STOCK_40_C  A
                                   LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B
                                ON B.DIVISION_ID = A.DIVISION_ID
                               AND B.ITEM_ID = A.ITEM_ID
                                   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C
                                ON C.LOOKUP_TYPE = 'CELL_TYPE_CODE'
                               AND C.VALID_YN    = 'Y'
                               AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
                            WHERE  1 = 1
                            AND    A.DIVISION_ID         = :V_DIVISION_ID
                            AND    A.PLAN_START_YYYYMMDD = :V_PLAN_START_YYYYMMDD
                            AND    A.PLAN_TYPE           = :V_PLAN_TYPE
                            AND    A.SEQ                 = :V_SEQ
                            AND    A.AVAILABLE_YN <> 'N'
                            AND    NVL(A.CHANGE_STATUS, '-') <> 'D'
                            GROUP BY A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.FROM_SITE
                                 , A.ITEM_ID
                                 , C.SEGMENT3

                            UNION ALL

                            SELECT A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.FROM_SITE
                                 , A.ITEM_ID
                                 , SUM(A.AVAILABLE_QTY) AS QTY
                            FROM   SSP_ANL_OWMS_STOCK_C  A
                            WHERE  1 = 1
                            AND    A.DIVISION_ID         = :V_DIVISION_ID
                            AND    A.PLAN_START_YYYYMMDD = :V_PLAN_START_YYYYMMDD
                            AND    A.PLAN_TYPE           = :V_PLAN_TYPE
                            AND    A.SEQ                 = :V_SEQ
                            GROUP BY A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.FROM_SITE
                                 , A.ITEM_ID

                            UNION ALL

                            /* STORAGE ID : B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 외주 재고 */
                            SELECT T.DIVISION_ID            AS DIVISION_ID
                            ,      T.PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
                            ,      T.PLAN_TYPE              AS PLAN_TYPE
                            ,      T.SEQ                    AS SEQ
                            ,      T.SCM_SITE_ID            AS FROM_SITE
                            ,      T.ITEM_ID                AS ITEM_ID
                            ,      ROUND(SUM(T.QTY),0) AS  QTY
                            FROM   SSP_ANL_TCO_STOCK_C T
                            WHERE  1 = 1
                            AND    T.DIVISION_ID         = :V_DIVISION_ID
                            AND    T.PLAN_START_YYYYMMDD = :V_PLAN_START_YYYYMMDD
                            AND    T.PLAN_TYPE           = :V_PLAN_TYPE
                            AND    T.SEQ                 = :V_SEQ
                            GROUP BY
                                    T.DIVISION_ID
                            ,     T.PLAN_START_YYYYMMDD
                            ,     T.PLAN_TYPE
                            ,     T.SEQ
                            ,     T.ITEM_ID
                            ,     T.SCM_SITE_ID
                            ) A
                            JOIN SCM_MST_SITE E
                         ON E.DIVISION_ID = :V_DIVISION_ID
                        AND NVL(E.COMPANY_ID, '-') = NVL(:V_COMPANY_ID, '-')
                        AND E.DIVISION_ID = A.DIVISION_ID
                        AND E.SCM_SITE_ID = A.FROM_SITE
                     WHERE  1 = 1
                     GROUP BY A.DIVISION_ID
                          , A.PLAN_START_YYYYMMDD
                          , A.PLAN_TYPE
                          , A.SEQ
                          , A.FROM_SITE
                          , A.ITEM_ID
                    )
          , Z AS (
                    SELECT DISTINCT
                            P.DIVISION_ID
                    ,      P.PLAN_START_YYYYMMDD
                    ,      P.PLAN_TYPE
                    ,      P.SEQ
                    ,      P.ITEM_ID
                    ,      P.FROM_SITE
                    ,      P.YYYYMMDD
                    ,      CASE WHEN P.ITEM_ID IS NULL THEN 0
                                ELSE SUM(SUM(CASE WHEN P.YYYYMMDD > :V_DATA_START_YYYYMMDD THEN
                                         CASE P.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'POSTP_PLAN'      THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'MES_FCS_HOLD'    THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'WH_IN'           THEN      NVL(P.QTY,0)
                                                        WHEN 'MES_FCS_RELEASE' THEN      NVL(P.QTY,0)
                                         ELSE 0.0 END
                                    ELSE 0 END))
                                         OVER (PARTITION BY P.DIVISION_ID, P.PLAN_START_YYYYMMDD, P.PLAN_TYPE, P.SEQ, P.ITEM_ID, P.FROM_SITE ORDER BY P.YYYYMMDD ROWS UNBOUNDED PRECEDING)
                                   - SUM(CASE WHEN P.YYYYMMDD > :V_DATA_START_YYYYMMDD THEN
                                         CASE P.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'POSTP_PLAN'      THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'MES_FCS_HOLD'    THEN -1 * NVL(P.QTY,0)
                                                        WHEN 'WH_IN'           THEN      NVL(P.QTY,0)
                                                        WHEN 'MES_FCS_RELEASE' THEN      NVL(P.QTY,0)
                                         ELSE 0.0 END
                                    ELSE 0 END)
                           END AS WH_CUM_QTY    /* 시작일 초과 ~ 전일 WH_IN · SHIP_CONFIRM · POSTP_PLAN · MES_FCS_HOLD · MES_FCS_RELEASE 합계 */  --  2026.11.18 ZIONEX
                    FROM  GT_SSP_ANL_SHIP_PLAN_40 P
                            JOIN SCM_MST_SITE E
                         ON E.DIVISION_ID = :V_DIVISION_ID
                        AND NVL(E.COMPANY_ID, '-') = NVL(:V_COMPANY_ID, '-')
                        AND E.DIVISION_ID = P.DIVISION_ID
                        AND E.SCM_SITE_ID = P.FROM_SITE
                    WHERE 1 = 1
                    AND P.DIVISION_ID         = :V_DIVISION_ID
                    AND P.PLAN_START_YYYYMMDD = :V_PLAN_START_YYYYMMDD
                    AND P.PLAN_TYPE           = :V_PLAN_TYPE
                    AND P.SEQ                 = :V_SEQ
                    AND P.MEASURE IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
                    AND P.YYYYMMDD            >= :V_DATA_START_YYYYMMDD
                    GROUP BY P.DIVISION_ID
                    ,        P.PLAN_START_YYYYMMDD
                    ,        P.PLAN_TYPE
                    ,        P.SEQ
                    ,        P.ITEM_ID
                    ,        P.FROM_SITE
                    ,        P.YYYYMMDD
                    )
        SELECT
             Z.DIVISION_ID
            ,Z.PLAN_START_YYYYMMDD
            ,Z.PLAN_TYPE
            ,Z.SEQ
            ,Z.ITEM_ID
            ,Z.FROM_SITE
            ,'-'   AS TO_SITE
            ,'WH_STOCK' AS MEASURE
            ,Z.YYYYMMDD
            ,'-'   AS BOD_ID
            ,/* 전일 WH_IN , 전일 SHIP_CONFIRM */
             (
             CASE WHEN TO_CHAR(SYSDATE, 'YYYYMMDD') < Z.YYYYMMDD THEN Z.WH_CUM_QTY  --  2026.11.18 ZIONEX
             ELSE  0
             END
             )
                /* 당일 OWMS 재고 */
                + NVL(BOH.QTY,0)
                /* 2020.09.09 KBK : 'DCP','MDP','MIP','MTP' 처리 */
                - (
                  CASE WHEN TO_CHAR(SYSDATE, 'YYYYMMDD') <= Z.YYYYMMDD THEN
                       CASE WHEN NVL(B.SEGMENT3, '-') = 'P' THEN NVL(B.WH_IN_QTY2, 0)
                       ELSE 0 END
                  ELSE 0 END
                  )
                /* HOLD 재고 제외 */
                - NVL(HD.HOLD_QTY, 0)                  AS QTY  --  2026.11.18 ZIONEX
            ,'-'   AS INCOTERMS
            ,'-'   AS TRANSPORT_MODE
            ,'-'   AS PROJECT_CODE
            ,'-'   AS FCST_TYPE
            ,'-'   AS CONFIRM_ID
            ,Z.DIVISION_ID
            ,Z.DIVISION_ID  /* ORIGIN_TO_DIVISION_ID */
        FROM Z  --  2026.11.18 ZIONEX (START)
           , BOH
           , (
                            SELECT A.DIVISION_ID
                                    , A.PLAN_START_YYYYMMDD
                                    , A.PLAN_TYPE
                                    , A.SEQ
                                    , A.ITEM_ID
                                    , A.FROM_SITE
                                    , SUM(A.QTY)   AS WH_IN_QTY2
                                    , C.SEGMENT3
                            FROM   GT_SSP_ANL_SHIP_PLAN_40  A
                                   LEFT OUTER JOIN SCP_MST_FINAL_ITEM  B
                                ON B.DIVISION_ID = A.DIVISION_ID
                               AND B.ITEM_ID = A.ITEM_ID
                                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C
                                ON C.LOOKUP_TYPE = 'CELL_TYPE_CODE'
                               AND C.VALID_YN    = 'Y'
                               AND C.SEGMENT3    = 'P'
                               AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
                                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D
                                ON D.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
                               AND D.SEGMENT1    = SUBSTR(A.ITEM_ID, 1, 3)
                               AND D.VALID_YN    = 'Y'
                            WHERE  1 = 1
                            AND    A.DIVISION_ID         = :V_DIVISION_ID
                            AND    A.PLAN_START_YYYYMMDD = :V_PLAN_START_YYYYMMDD
                            AND    A.PLAN_TYPE           = :V_PLAN_TYPE
                            AND    A.SEQ                 = :V_SEQ
                            AND    A.MEASURE = 'WH_IN'
                            AND    A.YYYYMMDD > :V_DATA_START_YYYYMMDD
                            AND    A.YYYYMMDD <= TO_CHAR(TO_DATE(:V_DATA_START_YYYYMMDD, 'YYYYMMDD') + TO_NUMBER(D.SEGMENT2), 'YYYYMMDD')
                            GROUP BY A.DIVISION_ID
                                    , A.PLAN_START_YYYYMMDD
                                    , A.PLAN_TYPE
                                    , A.SEQ
                                    , A.ITEM_ID
                                    , A.FROM_SITE
                                    , C.SEGMENT3
             ) B  /* 2020.09.09 KBK */
           , (SELECT H.DIVISION_ID
                   , H.FROM_SITE
                   , H.ITEM_ID
                   , C.BASIS_YYYYMMDD
                   , SUM(H.HOLD_QTY)                   AS HOLD_QTY  /* HOLD 재고 */
                FROM SSP_ANL_HOLD_STOCK H
                   , SCM_SYS_CALENDAR_M C
               WHERE C.BASIS_YYYYMMDD     >= H.HOLD_YYYYMMDD
                 AND C.BASIS_YYYYMMDD     <= H.RELEASE_YYYYMMDD
                 AND H.DIVISION_ID         = :V_DIVISION_ID
                 AND H.PLAN_START_YYYYMMDD = :V_PLAN_START_YYYYMMDD
                 AND H.PLAN_TYPE           = :V_PLAN_TYPE
                 AND H.SEQ                 = :V_SEQ
                 AND C.BASIS_YYYYMMDD      > :V_DATA_START_YYYYMMDD
                 AND C.BASIS_YYYYMMDD      < :V_DATA_END_YYYYMMDD
               GROUP BY H.DIVISION_ID
                      , H.FROM_SITE
                      , H.ITEM_ID
                      , C.BASIS_YYYYMMDD
             ) HD
       WHERE BOH.DIVISION_ID(+)         = Z.DIVISION_ID
         AND BOH.PLAN_START_YYYYMMDD(+) = Z.PLAN_START_YYYYMMDD
         AND BOH.PLAN_TYPE(+)           = Z.PLAN_TYPE
         AND BOH.SEQ(+)                 = Z.SEQ
         AND BOH.ITEM_ID(+)             = Z.ITEM_ID
         AND BOH.FROM_SITE(+)           = Z.FROM_SITE
         AND B.DIVISION_ID(+)           = Z.DIVISION_ID
         AND B.PLAN_START_YYYYMMDD(+)   = Z.PLAN_START_YYYYMMDD
         AND B.PLAN_TYPE(+)             = Z.PLAN_TYPE
         AND B.SEQ(+)                   = Z.SEQ
         AND B.ITEM_ID(+)               = Z.ITEM_ID
         AND B.FROM_SITE(+)             = Z.FROM_SITE
         AND HD.DIVISION_ID(+)          = Z.DIVISION_ID
         AND HD.FROM_SITE(+)            = Z.FROM_SITE
         AND HD.ITEM_ID(+)              = Z.ITEM_ID
         AND HD.BASIS_YYYYMMDD(+)       = Z.YYYYMMDD  --  2026.11.18 ZIONEX (END)