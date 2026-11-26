    PROCEDURE P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_OPERATION_GROUP       IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_ERR_MSG               VARCHAR2(4000 CHAR);
        V_TO_SITE_TYPE          VARCHAR2(30 CHAR) := 'PLANT';
    BEGIN

        OPEN O_RC1 FOR
            SELECT DISTINCT
                   A.DIVISION_ID
                 , B.FROM_SITE
                 , SF.DIVISION_ID                             AS FROM_DIVISION_ID
                 , SF.SITE_TYPE                               AS FROM_SITE_TYPE
                 , SF.SITE_DESCRIPTION                        AS FROM_SITE_NAME
                 , B.TO_SITE
                 , ST.DIVISION_ID                             AS TO_DIVISION_ID
                 , ST.SITE_TYPE                               AS TO_SITE_TYPE
                 , ST.SITE_DESCRIPTION                        AS TO_SITE_NAME
                 , A.ITEM_ID
                 , A.PRIORITY
                 , A.BOD_ID
                 , B.INCOTERMS
                 , C.TRANSPORT_MODE
                 /* BOD 2단계 개발 */
                 /* ,(SELECT v.lt_total FROM scp_mst_bod_v v WHERE v.division_id = b.division_id  and v.bod_id = b.bod_id ) AS lead_time */
                 , (SELECT SA.LT_TOTAL
                      FROM SCP_MST_BOD_N_V SA
                     WHERE SA.DIVISION_ID = B.DIVISION_ID
                       AND SA.BOD_ID      = B.BOD_ID)          AS LEAD_TIME
                 , A.VALID_YN                                 AS BOD_ITEM_VALID
                 , C.ROUTE_ID
                 , C.DAYS_MON
                 , C.DAYS_TUE
                 , C.DAYS_WED
                 , C.DAYS_THU
                 , C.DAYS_FRI
                 , C.DAYS_SAT
                 , C.DAYS_SUN
                 /* Ship Frozen구간 다음일자 */
                 , TO_CHAR(TO_DATE(P_FROM_YYYYMMDD, 'YYYYMMDD') + NVL(FS.SHIP_FROZEN, 0), 'YYYYMMDD') AS FROZEN_YYYYMMDD
                 , TO_DATE(B.ATTRIBUTE2, 'YYYYMMDD')          AS BOD_FROM_YYYYMMDD    /* BOD 2단계 개발 */
                 , TO_DATE(B.ATTRIBUTE3, 'YYYYMMDD')          AS BOD_TO_YYYYMMDD      /* BOD 2단계 개발 */
              FROM SCP_MST_BOD_ITEM              A
                 , SCP_MST_BOD                   B
                 , SCM_MST_SITE                  SF
                 , SCM_MST_SITE                  ST
                 , SCP_MST_DISTRIBUTION_ROUTE    C
                 , SCM_MST_SITE                  FS
             WHERE A.BOD_ID            = B.BOD_ID
               AND SF.SCM_SITE_ID      = B.FROM_SITE
               AND ST.SCM_SITE_ID      = B.TO_SITE
               AND B.ROUTE_ID          = C.ROUTE_ID
               AND FS.DIVISION_ID      = A.DIVISION_ID
               AND FS.SCM_SITE_ID      = B.FROM_SITE
               AND SF.SITE_TYPE        = 'PLANT'
               AND SF.OPERATION_GROUP  = P_OPERATION_GROUP
               AND ST.SITE_TYPE        = V_TO_SITE_TYPE
               AND FS.SITE_TYPE        = 'PLANT'
               AND FS.OPERATION_GROUP  = P_OPERATION_GROUP
               AND FS.OSP_YN           = 'N'
               AND FS.VALID_YN         = 'Y'
               AND B.INCOTERMS         = 'DAP'                 /* Semi 용 DAP 적용 */
               AND SF.PLANT_ID        <> ST.PLANT_ID           /* 동일 Plant 제외(A040-A -> A040-P 등) */
               AND A.DIVISION_ID       = P_DIVISION_ID
               AND UPPER(A.ITEM_ID)    = UPPER(P_ITEM_ID)
             ORDER BY BOD_ITEM_VALID DESC
                    , FN_ASIS_SORT_KEY(DIVISION_ID) NULLS FIRST
                    , FN_ASIS_SORT_KEY(FROM_SITE) NULLS FIRST
                    , FN_ASIS_SORT_KEY(TO_SITE) NULLS FIRST
                    , PRIORITY
                    , FN_ASIS_SORT_KEY(TRANSPORT_MODE) NULLS FIRST;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE;
