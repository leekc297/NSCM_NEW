
/****************************************************************************************************/
/* Program ID  : P_SSP0046_GET_BUCKET_TYPE_CODE                                                     */
/* Description : Bucket Type 코드 (AS-IS SSP0046_GET_BUCKET_TYPE_CODE)                              */
/****************************************************************************************************/
PROCEDURE P_SSP0046_GET_BUCKET_TYPE_CODE
(
    O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
BEGIN

    OPEN O_RC1 FOR
        SELECT L.SEGMENT1                                                   AS CODE
             , L.SEGMENT2                                                   AS NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
         WHERE L.LOOKUP_TYPE = 'BUCKET_TYPE_CODE'
           AND L.VALID_YN    = 'Y'
         ORDER BY L.DISPLAY_SEQ;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0046_GET_BUCKET_TYPE_CODE;

/****************************************************************************************************/
/* Program ID  : P_SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP                                           */
/* Description : BOD 팝업 - 품목별 BOD, 경로 (AS-IS SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP)         */
/*               부서 = To Site 대표 부서 SCM_MST_SITE_ITEM (DIVISION_ID, SCM_SITE_ID) MAX (#150)   */
/****************************************************************************************************/
PROCEDURE P_SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP
(
    P_DIVISION_ID       IN  VARCHAR2
  , P_ITEM_ID           IN  VARCHAR2
  , P_FROM_SITE         IN  VARCHAR2
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
BEGIN

    OPEN O_RC1 FOR
        SELECT DISTINCT
               A.DIVISION_ID
             , B.FROM_SITE
             , SF.DIVISION_ID                                               AS FROM_DIVISION_ID
             , SF.SITE_TYPE                                                 AS FROM_SITE_TYPE
             , SF.SITE_DESCRIPTION                                          AS FROM_SITE_NAME
             , B.TO_SITE
             , ST.DIVISION_ID                                               AS TO_DIVISION_ID
             , ST.SITE_TYPE                                                 AS TO_SITE_TYPE
             , ST.SITE_DESCRIPTION                                          AS TO_SITE_NAME
             , A.ITEM_ID
             , A.PRIORITY
             , A.BOD_ID
             , B.INCOTERMS
             , C.TRANSPORT_MODE
             , (SELECT V.LT_TOTAL
                  FROM SCP_MST_BOD_V V
                 WHERE V.DIVISION_ID = B.DIVISION_ID
                   AND V.BOD_ID      = B.BOD_ID)                            AS LEAD_TIME
             , A.VALID_YN                                                   AS BOD_ITEM_VALID
             , C.ROUTE_ID
             , C.DAYS_MON
             , C.DAYS_TUE
             , C.DAYS_WED
             , C.DAYS_THU
             , C.DAYS_FRI
             , C.DAYS_SAT
             , C.DAYS_SUN
             , TO_CHAR(SYSDATE + NVL(FS.SHIP_FROZEN, 0) - 1, 'YYYYMMDD')    AS FROZEN_YYYYMMDD     /* Ship Frozen구간 다음일자 */
             , ST.END_CUSTOMER
             , (SELECT DP.DEPT_NAME_KO
                  FROM SCM_MST_SSO_DEPT_INFO DP
                 WHERE DP.DEPT_ID = (SELECT MAX(SA.DEPT_ID)                 /* To Site 대표 부서 (#150) */
                                       FROM SCM_MST_SITE_ITEM SA
                                      WHERE SA.DIVISION_ID = ST.DIVISION_ID
                                        AND SA.SCM_SITE_ID = ST.SCM_SITE_ID
                                        AND SA.DEPT_ID IS NOT NULL))        AS DEPT_NAME_KO
          FROM SCP_MST_BOD_ITEM A
         INNER JOIN SCP_MST_BOD B
            ON A.BOD_ID          = B.BOD_ID
         INNER JOIN SCM_MST_SITE SF
            ON SF.SCM_SITE_ID    = B.FROM_SITE
           AND SF.SITE_TYPE      = 'PLANT'
         INNER JOIN SCM_MST_SITE ST
            ON ST.SCM_SITE_ID    = B.TO_SITE
         INNER JOIN SCP_MST_DISTRIBUTION_ROUTE C
            ON B.ROUTE_ID        = C.ROUTE_ID
         INNER JOIN SCM_MST_SITE FS
            ON A.DIVISION_ID     = FS.DIVISION_ID
           AND B.TO_SITE         = FS.SCM_SITE_ID
           AND FS.VALID_YN       = 'Y'
         WHERE A.DIVISION_ID     = P_DIVISION_ID
           AND UPPER(A.ITEM_ID)  = UPPER(P_ITEM_ID)
           AND (TRIM(P_FROM_SITE) IS NULL OR B.FROM_SITE = P_FROM_SITE)
         ORDER BY BOD_ITEM_VALID DESC
                , FN_ASIS_SORT_KEY(DIVISION_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(FROM_SITE) NULLS FIRST
                , FN_ASIS_SORT_KEY(TO_SITE) NULLS FIRST
                , PRIORITY
                , FN_ASIS_SORT_KEY(TRANSPORT_MODE) NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0046_GET_BODITEM_FOR_PRJROUTE_POPUP;

/****************************************************************************************************/
/* Program ID  : P_SSP0046_GET_ITEM_BY_DIVISION_POPUPEX                                             */
/* Description : 품목 팝업 (AS-IS SSP0046_GET_ITEM_BY_DIVISION_POPUPEx)                             */
/*               81 계열 = SITE_ITEM 기준 / 82 = 사업부 전 품목(E%, H·R 제외)                       */
/*               부서 : 81 계열 = SITE_ITEM 행 DEPT_ID(PK 4키) / 82 = 사이트 대표 부서 MAX (#150)   */
/*               조건 '' 은 Oracle NULL 이므로 NULL 토큰 1건으로 다룬다 (AS-IS 분리 함수 = 빈 토큰 1건) */
/****************************************************************************************************/
PROCEDURE P_SSP0046_GET_ITEM_BY_DIVISION_POPUPEX
(
    P_DIVISION_ID       IN  VARCHAR2
  , P_DEPT_ID           IN  VARCHAR2
  , P_END_CUSTOMER      IN  VARCHAR2
  , P_PROJECT_CODE      IN  VARCHAR2
  , P_SCM_SITE_ID       IN  VARCHAR2
  , P_ITEM_ID           IN  VARCHAR2
  , P_BIZ_TYPE          IN  VARCHAR2
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
BEGIN

    OPEN O_RC1 FOR
        SELECT DIVISION_ID, DIVISION_NAME, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, SITE_DESCRIPTION
             , ITEM_ID, ITEM_NAME, ITEM_TYPE, ITEM_TYPE_NAME, NICK_NAME, ITEM_CLASS_NAME
             , DEPT_ID, DEPT_NAME_KO, END_CUSTOMER, CURRENCY, END_CUSTOMER40
          FROM (
                /* 81 계열 : SITE_ITEM 에 연결된 품목 */
                SELECT DISTINCT
                       I.DIVISION_ID
                     , I.DIVISION_ID                                        AS DIVISION_NAME
                     , D.PROJECT_CODE
                     , A.PROJECT_NAME
                     , S.SCM_SITE_ID
                     , S.SITE_DESCRIPTION
                     , D.ITEM_ID
                     , T.ITEM_NAME
                     , T.ITEM_TYPE
                     , ITC.NAME                                             AS ITEM_TYPE_NAME
                     , T.NICK_NAME
                     , T.ITEM_CLASS_NAME
                     , TEAM.DEPT_ID
                     , TEAM.DEPT_NAME_KO
                     , C.END_CUSTOMER
                     , D.CURRENCY
                     , D.PROJECT_CODE                                       AS END_CUSTOMER40
                  FROM SCM_MST_DIVISION I
                  LEFT OUTER JOIN SCM_MST_SITE_ITEM D
                    ON I.DIVISION_ID   = D.DIVISION_ID
                   AND D.VALID_YN      = 'Y'
                  LEFT OUTER JOIN SCM_MST_PROJECT A
                    ON D.PROJECT_CODE  = A.PROJECT_CODE
                  LEFT OUTER JOIN SCM_MST_SITE S
                    ON D.SCM_SITE_ID   = S.SCM_SITE_ID
                   AND S.VALID_YN      = 'Y'
                  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V T
                    ON I.DIVISION_ID   = T.DIVISION_ID
                   AND D.ITEM_ID       = T.ITEM_ID
                  LEFT OUTER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER
                                     FROM SCM_MST_SITE
                                    WHERE VALID_YN = 'Y') C
                    ON I.DIVISION_ID   = C.DIVISION_ID
                   AND D.SCM_SITE_ID   = C.SCM_SITE_ID
                  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO TEAM                /* SITE_ITEM 행 부서 (#150 §3-3), 유효 사이트일 때만 (AS-IS C 경유) */
                    ON TEAM.DEPT_ID    = D.DEPT_ID
                   AND TEAM.VALID_YN   = 'Y'
                   AND C.SCM_SITE_ID  IS NOT NULL
                  LEFT OUTER JOIN (SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE VALID_YN    = 'Y'
                                      AND LOOKUP_TYPE = 'ITEM_TYPE_CODE') ITC
                    ON T.ITEM_TYPE     = ITC.CODE
                 INNER JOIN SCM_MST_ITEM_SN U
                    ON I.DIVISION_ID   = U.DIVISION_ID
                   AND D.ITEM_ID       = U.ITEM_ID
                   AND U.SCP_OPERATION_GROUP = P_BIZ_TYPE
                 WHERE I.VALID_YN      = 'Y'
                   AND I.DIVISION_ID LIKE '81%'                             /* DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회 */
                   AND S.SITE_TYPE     = 'SALES'
                   AND (P_DIVISION_ID = 'ALL' OR I.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
                   AND (P_DEPT_ID = 'ALL' OR TEAM.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DEPT_ID, ','))))
                   AND (P_END_CUSTOMER = 'ALL'
                        OR NVL(C.END_CUSTOMER, '/') IN (SELECT NVL(TOKEN, '/') FROM TABLE(FN_STRING_SPLIT(P_END_CUSTOMER, ','))
                                                        UNION ALL SELECT '/' FROM DUAL WHERE P_END_CUSTOMER IS NULL))
                   AND (P_SCM_SITE_ID = 'ALL' OR S.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_SCM_SITE_ID, ','))))
                   AND EXISTS (SELECT 1
                                 FROM (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_PROJECT_CODE, ','))
                                        UNION ALL SELECT NULL FROM DUAL WHERE P_PROJECT_CODE IS NULL) P
                                WHERE UPPER(D.PROJECT_CODE) LIKE UPPER(P.TOKEN) || '%'
                                   OR UPPER(A.PROJECT_NAME) LIKE UPPER(P.TOKEN) || '%')
                   AND EXISTS (SELECT 1
                                 FROM (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))
                                        UNION ALL SELECT NULL FROM DUAL WHERE P_ITEM_ID IS NULL) P
                                WHERE UPPER(D.ITEM_ID)   LIKE UPPER(P.TOKEN) || '%'
                                   OR UPPER(T.NICK_NAME) LIKE UPPER(P.TOKEN) || '%')     /* 20181205 nick name 조회요청 */
                 UNION
                /* 82 : 사업부 전 품목 (자재·반제품 제외) */
                SELECT DISTINCT
                       I.DIVISION_ID
                     , I.DIVISION_ID                                        AS DIVISION_NAME
                     , D.PROJECT_CODE
                     , A.PROJECT_NAME
                     , S.SCM_SITE_ID
                     , S.SITE_DESCRIPTION
                     , T.ITEM_ID
                     , T.ITEM_NAME
                     , T.ITEM_TYPE
                     , ITC.NAME                                             AS ITEM_TYPE_NAME
                     , T.NICK_NAME
                     , T.ITEM_CLASS_NAME
                     , TEAM.DEPT_ID
                     , TEAM.DEPT_NAME_KO
                     , C.END_CUSTOMER
                     , D.CURRENCY
                     , D.PROJECT_CODE                                       AS END_CUSTOMER40
                  FROM SCM_MST_DIVISION I
                  LEFT OUTER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, CURRENCY
                                     FROM SCM_MST_SITE_ITEM
                                    WHERE VALID_YN = 'Y') D
                    ON I.DIVISION_ID   = D.DIVISION_ID
                  LEFT OUTER JOIN SCM_MST_PROJECT A
                    ON D.PROJECT_CODE  = A.PROJECT_CODE
                  LEFT OUTER JOIN SCM_MST_SITE S
                    ON D.SCM_SITE_ID   = S.SCM_SITE_ID
                   AND S.VALID_YN      = 'Y'
                  LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V T
                    ON I.DIVISION_ID   = T.DIVISION_ID
                   AND T.ITEM_TYPE NOT IN ('H', 'R')                        /* 자재 반재품 는 제외 */
                   AND T.ITEM_ID   LIKE 'E%'
                  LEFT OUTER JOIN (SELECT S2.DIVISION_ID
                                        , S2.SCM_SITE_ID
                                        , S2.END_CUSTOMER
                                        , (SELECT MAX(SA.DEPT_ID)
                                             FROM SCM_MST_SITE_ITEM SA
                                                , SCM_MST_SSO_DEPT_INFO SD
                                            WHERE SA.DIVISION_ID = S2.DIVISION_ID
                                              AND SA.SCM_SITE_ID = S2.SCM_SITE_ID
                                              AND SA.DEPT_ID     = SD.DEPT_ID
                                              AND SD.VALID_YN    = 'Y') AS DEPT_ID   /* 사이트 대표 부서, 유효부서 술어는 MAX 안쪽 (#150) */
                                     FROM SCM_MST_SITE S2
                                    WHERE S2.VALID_YN = 'Y') C
                    ON I.DIVISION_ID   = C.DIVISION_ID
                   AND D.SCM_SITE_ID   = C.SCM_SITE_ID
                  LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO TEAM
                    ON TEAM.DEPT_ID    = C.DEPT_ID
                  LEFT OUTER JOIN (SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                    WHERE VALID_YN    = 'Y'
                                      AND LOOKUP_TYPE = 'ITEM_TYPE_CODE') ITC
                    ON T.ITEM_TYPE     = ITC.CODE
                 INNER JOIN SCM_MST_ITEM_SN U
                    ON I.DIVISION_ID   = U.DIVISION_ID
                   AND T.ITEM_ID       = U.ITEM_ID
                   AND U.SCP_OPERATION_GROUP = P_BIZ_TYPE
                 WHERE I.VALID_YN      = 'Y'
                   AND I.DIVISION_ID   = '82'
                   AND S.SITE_TYPE     = 'SALES'
                   AND (P_DIVISION_ID = 'ALL' OR I.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
                   AND (P_DEPT_ID = 'ALL' OR TEAM.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DEPT_ID, ','))))
                   AND (P_END_CUSTOMER = 'ALL'
                        OR NVL(C.END_CUSTOMER, '/') IN (SELECT NVL(TOKEN, '/') FROM TABLE(FN_STRING_SPLIT(P_END_CUSTOMER, ','))
                                                        UNION ALL SELECT '/' FROM DUAL WHERE P_END_CUSTOMER IS NULL))
                   AND (P_SCM_SITE_ID = 'ALL' OR S.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_SCM_SITE_ID, ','))))
                   AND EXISTS (SELECT 1
                                 FROM (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_PROJECT_CODE, ','))
                                        UNION ALL SELECT NULL FROM DUAL WHERE P_PROJECT_CODE IS NULL) P
                                WHERE UPPER(D.PROJECT_CODE) LIKE UPPER(P.TOKEN) || '%'
                                   OR UPPER(A.PROJECT_NAME) LIKE UPPER(P.TOKEN) || '%')
                   AND EXISTS (SELECT 1
                                 FROM (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))
                                        UNION ALL SELECT NULL FROM DUAL WHERE P_ITEM_ID IS NULL) P
                                WHERE UPPER(T.ITEM_ID)   LIKE UPPER(P.TOKEN) || '%'
                                   OR UPPER(T.NICK_NAME) LIKE UPPER(P.TOKEN) || '%')
               )
         ORDER BY FN_ASIS_SORT_KEY(DIVISION_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(PROJECT_CODE) NULLS FIRST
                , FN_ASIS_SORT_KEY(SCM_SITE_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(SITE_DESCRIPTION) NULLS FIRST
                , FN_ASIS_SORT_KEY(ITEM_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(ITEM_NAME) NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0046_GET_ITEM_BY_DIVISION_POPUPEX;

/****************************************************************************************************/
/* Program ID  : P_SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX                                          */
/* Description : 프로젝트 팝업 (AS-IS SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX)                      */
/*               P_ETC = 'N' : 프로젝트 마스터 / 그 외 : LOOKUP DM_ETC_PROJECT ([PJ20200138])       */
/*               부서 = SITE_ITEM 행 DEPT_ID (#150 §3-3), 유효 사이트일 때만 (AS-IS C 경유)         */
/****************************************************************************************************/
PROCEDURE P_SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX
(
    P_DIVISION_ID       IN  VARCHAR2
  , P_DEPT_ID           IN  VARCHAR2
  , P_END_CUSTOMER      IN  VARCHAR2
  , P_SCM_SITE_ID       IN  VARCHAR2
  , P_PROJECT_CODE      IN  VARCHAR2
  , P_ETC               IN  VARCHAR2
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
BEGIN

    IF P_ETC = 'N'
    THEN
        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.DIVISION_ID                                            AS DIVISION_NAME
                 , A.PROJECT_CODE
                 , A.PROJECT_NAME
                 , A.PROJECT_STATUS
                 , BIZ.CODE                                                 AS BIZ_TYPE
                 , BIZ.NAME                                                 AS BIZ_TYPE_NAME
                 , A.CURRENCY
                 , MAX(A.PROJECT_VER_SEQ)                                   AS PROJECT_VER_SEQ
                 , A.PROJECT_OWNER
                 , TEAM.DEPT_ID
                 , TEAM.DEPT_NAME_KO
                 , C.END_CUSTOMER
              FROM SCM_MST_PROJECT A
              LEFT OUTER JOIN SCM_MST_DIVISION D
                ON A.DROP_YN       = 'N'
               AND A.DIVISION_ID   = D.DIVISION_ID
               AND D.VALID_YN      = 'Y'
              LEFT OUTER JOIN SCM_MST_SITE_ITEM B
                ON A.DIVISION_ID   = B.DIVISION_ID
               AND A.PROJECT_CODE  = B.PROJECT_CODE
               AND B.VALID_YN      = 'Y'
              LEFT OUTER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER
                                 FROM SCM_MST_SITE
                                WHERE VALID_YN = 'Y') C
                ON B.DIVISION_ID   = C.DIVISION_ID
               AND B.SCM_SITE_ID   = C.SCM_SITE_ID
              LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO TEAM
                ON TEAM.DEPT_ID    = B.DEPT_ID
               AND TEAM.VALID_YN   = 'Y'
               AND C.SCM_SITE_ID  IS NOT NULL
              LEFT OUTER JOIN (SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                WHERE LOOKUP_TYPE = 'BIZ_TYPE_BPMS') BIZ
                ON BIZ.CODE        = A.BIZ_TYPE
             WHERE TEAM.DEPT_ID IS NOT NULL
               AND (P_DIVISION_ID = 'ALL' OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
               AND (P_DEPT_ID = 'ALL' OR TEAM.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DEPT_ID, ','))))
               AND (P_END_CUSTOMER = 'ALL'
                    OR NVL(C.END_CUSTOMER, '/') IN (SELECT NVL(TOKEN, '/') FROM TABLE(FN_STRING_SPLIT(P_END_CUSTOMER, ','))
                                                    UNION ALL SELECT '/' FROM DUAL WHERE P_END_CUSTOMER IS NULL))
               AND (P_SCM_SITE_ID = 'ALL' OR C.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_SCM_SITE_ID, ','))))
               AND EXISTS (SELECT 1
                             FROM (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_PROJECT_CODE, ','))
                                    UNION ALL SELECT NULL FROM DUAL WHERE P_PROJECT_CODE IS NULL) P
                            WHERE UPPER(A.PROJECT_CODE) LIKE UPPER(P.TOKEN) || '%'
                               OR UPPER(A.PROJECT_NAME) LIKE UPPER(P.TOKEN) || '%')
             GROUP BY A.DIVISION_ID
                    , D.DIVISION_NAME
                    , A.PROJECT_CODE
                    , A.PROJECT_NAME
                    , A.PROJECT_STATUS
                    , A.BIZ_TYPE
                    , A.BIZ_TYPE_NAME
                    , BIZ.CODE
                    , BIZ.NAME
                    , A.CURRENCY
                    , A.PROJECT_OWNER
                    , TEAM.DEPT_ID
                    , TEAM.DEPT_NAME_KO
                    , C.END_CUSTOMER
             ORDER BY FN_ASIS_SORT_KEY(A.PROJECT_NAME) NULLS FIRST
                    , FN_ASIS_SORT_KEY(A.PROJECT_CODE) NULLS FIRST;
    ELSE
        /* [PJ20200138] ETC Only인 경우에 Lookup 에서 Project List 조회 */
        OPEN O_RC1 FOR
            SELECT A.SEGMENT1                                               AS DIVISION_ID
                 , A.SEGMENT1                                               AS DIVISION_NAME
                 , A.SEGMENT2                                               AS PROJECT_CODE
                 , A.SEGMENT3                                               AS PROJECT_NAME
                 , CAST(NULL AS VARCHAR2(50))                               AS PROJECT_STATUS
                 , CAST(NULL AS VARCHAR2(50))                               AS BIZ_TYPE
                 , CAST(NULL AS VARCHAR2(200))                              AS BIZ_TYPE_NAME
                 , CAST(NULL AS VARCHAR2(10))                               AS CURRENCY
                 , CAST(NULL AS VARCHAR2(10))                               AS PROJECT_VER_SEQ
                 , CAST(NULL AS VARCHAR2(200))                              AS PROJECT_OWNER
                 , CAST(NULL AS VARCHAR2(50))                               AS DEPT_ID
                 , CAST(NULL AS VARCHAR2(200))                              AS DEPT_NAME_KO
                 , CAST(NULL AS VARCHAR2(50))                               AS END_CUSTOMER
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
             WHERE A.LOOKUP_TYPE = 'DM_ETC_PROJECT'
               AND A.VALID_YN    = 'Y'
               AND A.SEGMENT1    = P_DIVISION_ID
               AND EXISTS (SELECT 1
                             FROM (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_PROJECT_CODE, ','))
                                    UNION ALL SELECT NULL FROM DUAL WHERE P_PROJECT_CODE IS NULL) P
                            WHERE UPPER(A.SEGMENT2) LIKE UPPER(P.TOKEN) || '%');
    END IF;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0046_GET_PROJECT_BY_DIVISION_POPUPEX;

/****************************************************************************************************/
/* Program ID  : P_SSP0046_GET_CUSTOMER_BY_DIVISION                                                 */
/* Description : 팝업 조회조건 End Customer (AS-IS SSP0046_GET_CUSTOMER_BY_DIVISION)                */
/*               부서 = 사이트 대표 부서 SCM_MST_SITE_ITEM MAX (#150)                               */
/****************************************************************************************************/
PROCEDURE P_SSP0046_GET_CUSTOMER_BY_DIVISION
(
    P_DIVISION_ID       IN  VARCHAR2
  , P_DEPT_ID           IN  VARCHAR2
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
BEGIN

    OPEN O_RC1 FOR
        SELECT DISTINCT
               IA.END_CUSTOMER                                              AS CODE
             , IA.END_CUSTOMER                                              AS NAME
          FROM (SELECT A.END_CUSTOMER
                     , (SELECT MAX(SA.DEPT_ID)
                          FROM SCM_MST_SITE_ITEM SA
                             , SCM_MST_SSO_DEPT_INFO SD
                         WHERE SA.DIVISION_ID = A.DIVISION_ID
                           AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                           AND SA.DEPT_ID     = SD.DEPT_ID)                 AS DEPT_ID   /* 사이트 대표 부서, AS-IS 부서 INNER 조건은 MAX 안쪽 (#150) */
                  FROM SCM_MST_SITE A
                 WHERE A.VALID_YN = 'Y'
                   AND NVL(A.END_CUSTOMER, '/') NOT IN ('-', '/')           /* AS-IS END_CUSTOMER <> '' */
                   AND (P_DIVISION_ID = 'ALL' OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
               ) IA
         WHERE IA.DEPT_ID IS NOT NULL
           AND (P_DEPT_ID = 'ALL' OR IA.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DEPT_ID, ','))));

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0046_GET_CUSTOMER_BY_DIVISION;

/****************************************************************************************************/
/* Program ID  : P_SSP0046_GET_SITE_BY_DIVISION                                                     */
/* Description : 팝업 조회조건 Sales Site (AS-IS SSP0046_GET_SITE_BY_DIVISION)                      */
/*               부서 = 사이트 대표 부서 SCM_MST_SITE_ITEM MAX (#150)                               */
/****************************************************************************************************/
PROCEDURE P_SSP0046_GET_SITE_BY_DIVISION
(
    P_DIVISION_ID       IN  VARCHAR2
  , P_DEPT_ID           IN  VARCHAR2
  , P_END_CUSTOMER      IN  VARCHAR2
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
BEGIN

    OPEN O_RC1 FOR
        SELECT IA.SCM_SITE_ID                                               AS CODE
             , IA.SITE_DESCRIPTION                                          AS NAME
          FROM (SELECT A.SCM_SITE_ID
                     , A.SITE_DESCRIPTION
                     , A.END_CUSTOMER
                     , (SELECT MAX(SA.DEPT_ID)
                          FROM SCM_MST_SITE_ITEM SA
                         WHERE SA.DIVISION_ID = A.DIVISION_ID
                           AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                           AND SA.DEPT_ID IS NOT NULL)                      AS DEPT_ID   /* 사이트 대표 부서 (#150) */
                  FROM SCM_MST_SITE A
                 WHERE A.SITE_TYPE = 'SALES'
                   AND A.VALID_YN  = 'Y'
                   AND (P_DIVISION_ID = 'ALL' OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
               ) IA
         WHERE (P_DEPT_ID = 'ALL' OR IA.DEPT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DEPT_ID, ','))))
           AND (P_END_CUSTOMER = 'ALL'
                OR NVL(IA.END_CUSTOMER, '/') IN (SELECT NVL(TOKEN, '/') FROM TABLE(FN_STRING_SPLIT(P_END_CUSTOMER, ','))
                                                 UNION ALL SELECT '/' FROM DUAL WHERE P_END_CUSTOMER IS NULL))
         ORDER BY FN_ASIS_SORT_KEY(IA.SITE_DESCRIPTION) NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0046_GET_SITE_BY_DIVISION;

/****************************************************************************************************/
/* Program ID  : P_SSP0046_GET_TEAM_BY_DIVISION                                                     */
/* Description : 팝업 조회조건 Team (AS-IS SSP0046_GET_TEAM_BY_DIVISION)                            */
/*               부서 = Sales 사이트 대표 부서 SCM_MST_SITE_ITEM MAX (#150)                         */
/****************************************************************************************************/
PROCEDURE P_SSP0046_GET_TEAM_BY_DIVISION
(
    P_DIVISION_ID       IN  VARCHAR2
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
BEGIN

    OPEN O_RC1 FOR
        SELECT DISTINCT
               B.DEPT_ID                                                    AS CODE
             , B.DEPT_NAME_KO                                               AS NAME
          FROM (SELECT (SELECT MAX(SA.DEPT_ID)
                          FROM SCM_MST_SITE_ITEM SA
                             , SCM_MST_SSO_DEPT_INFO SD
                         WHERE SA.DIVISION_ID = A.DIVISION_ID
                           AND SA.SCM_SITE_ID = A.SCM_SITE_ID
                           AND SA.DEPT_ID     = SD.DEPT_ID)                 AS DEPT_ID   /* 사이트 대표 부서, AS-IS 부서 INNER 조건은 MAX 안쪽 (#150) */
                  FROM SCM_MST_SITE A
                 WHERE A.SITE_TYPE = 'SALES'
                   AND (P_DIVISION_ID = 'ALL' OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
               ) IA
             , SCM_MST_SSO_DEPT_INFO B
         WHERE IA.DEPT_ID = B.DEPT_ID;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0046_GET_TEAM_BY_DIVISION;

/****************************************************************************************************/
/* Program ID  : P_SSP0046_GET_COMMON_SPREAD_TITLE                                                  */
/* Description : 품목 팝업 칸 머리글 (AS-IS SSP0046_GET_COMMON_SPREAD_TITLE)                        */
/*               사용자 컬럼 설정(SCM_MST_TITLESET_USER 'C')이 없으면 기본 메타, 있으면 사용자 순서 */
/****************************************************************************************************/
PROCEDURE P_SSP0046_GET_COMMON_SPREAD_TITLE
(
    P_START_YYYYMMDD    IN  VARCHAR2
  , P_END_YYYYMMDD      IN  VARCHAR2
  , P_CREATED_BY        IN  VARCHAR2
  , P_PROGRAM_ID        IN  VARCHAR2
  , P_SHEET_NAME        IN  VARCHAR2
  , P_DIVISION_ID       IN  VARCHAR2
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    V_CNT       NUMBER := 0;
BEGIN

    SELECT COUNT(*)
      INTO V_CNT
      FROM SCM_MST_TITLESET_USER U
     WHERE U.PROGRAM_ID                    = P_PROGRAM_ID
       AND U.SHEET_NAME                    = P_SHEET_NAME
       AND U.USER_ID                       = P_CREATED_BY
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

    IF V_CNT = 0
    THEN
        OPEN O_RC1 FOR
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , CAST(NULL AS VARCHAR2(10))                               AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , CASE C.VALID_YN
                        WHEN 'Y' THEN CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
                        ELSE C.VALID_YN
                   END                                                      AS VALID_YN
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , 0                                                        AS SEQ
              FROM SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID   = P_PROGRAM_ID
               AND C.SHEET_NAME   = P_SHEET_NAME
               AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(C.DIVISION_ID, ',')))
             ORDER BY SEQ
                    , SORT_ORDER_NO;
    ELSE
        OPEN O_RC1 FOR
            SELECT U.PROGRAM_ID
                 , U.SHEET_NAME
                 , U.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , U.SORT_ORDER_NO
                 , U.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , CAST(NULL AS VARCHAR2(10))                               AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , CASE C.VALID_YN
                        WHEN 'Y' THEN CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
                        ELSE C.VALID_YN
                   END                                                      AS VALID_YN
                 , 1                                                        AS SEQ
              FROM SCM_MST_TITLESET_USER U
                 , SCM_MST_SHEET_COLUMNS C
             WHERE U.PROGRAM_ID                    = C.PROGRAM_ID
               AND U.SHEET_NAME                    = C.SHEET_NAME
               AND U.COLUMN_NAME                   = C.COLUMN_NAME
               AND U.PROGRAM_ID                    = P_PROGRAM_ID
               AND U.SHEET_NAME                    = P_SHEET_NAME
               AND U.USER_ID                       = P_CREATED_BY
               AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
               AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(C.DIVISION_ID, ',')))
             UNION ALL
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , CAST(NULL AS VARCHAR2(10))                               AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , CASE C.VALID_YN
                        WHEN 'Y' THEN CASE FN_GET_DIVISION_YN(C.DIVISION_ID, P_DIVISION_ID) WHEN 'Y' THEN C.VISIBLE_FLAG ELSE 'N' END
                        ELSE C.VALID_YN
                   END                                                      AS VALID_YN
                 , 2                                                        AS SEQ
              FROM SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID   = P_PROGRAM_ID
               AND C.SHEET_NAME   = P_SHEET_NAME
               AND C.VISIBLE_FLAG = 'N'
               AND NVL(C.DEFAULT_FLAG, '/') IN ('-', '/')                   /* AS-IS DEFAULT_FLAG = '' */
               AND C.VALID_YN     = 'Y'
               AND P_DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(C.DIVISION_ID, ',')))
             ORDER BY SEQ
                    , SORT_ORDER_NO;
    END IF;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0046_GET_COMMON_SPREAD_TITLE;

/****************************************************************************************************/
/* Program ID  : P_SSP0046_GET_COMMON_SPREAD_TITLE_EX                                               */
/* Description : 프로젝트 팝업 칸 머리글 (AS-IS SSP0046_GET_COMMON_SPREAD_TITLE_EX, 사업부 조건 없음) */
/****************************************************************************************************/
PROCEDURE P_SSP0046_GET_COMMON_SPREAD_TITLE_EX
(
    P_START_YYYYMMDD    IN  VARCHAR2
  , P_END_YYYYMMDD      IN  VARCHAR2
  , P_CREATED_BY        IN  VARCHAR2
  , P_PROGRAM_ID        IN  VARCHAR2
  , P_SHEET_NAME        IN  VARCHAR2
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    V_CNT       NUMBER := 0;
BEGIN

    SELECT COUNT(*)
      INTO V_CNT
      FROM SCM_MST_TITLESET_USER U
         , SCM_MST_SHEET_COLUMNS C
     WHERE U.PROGRAM_ID                    = C.PROGRAM_ID
       AND U.SHEET_NAME                    = C.SHEET_NAME
       AND U.COLUMN_NAME                   = C.COLUMN_NAME
       AND U.PROGRAM_ID                    = P_PROGRAM_ID
       AND U.SHEET_NAME                    = P_SHEET_NAME
       AND U.USER_ID                       = P_CREATED_BY
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

    IF V_CNT = 0
    THEN
        OPEN O_RC1 FOR
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , CAST(NULL AS VARCHAR2(10))                               AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , 0                                                        AS SEQ
              FROM SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID   = P_PROGRAM_ID
               AND C.SHEET_NAME   = P_SHEET_NAME
             ORDER BY SEQ
                    , SORT_ORDER_NO;
    ELSE
        OPEN O_RC1 FOR
            SELECT U.PROGRAM_ID
                 , U.SHEET_NAME
                 , U.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , U.SORT_ORDER_NO
                 , U.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , CAST(NULL AS VARCHAR2(10))                               AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , 1                                                        AS SEQ
              FROM SCM_MST_TITLESET_USER U
                 , SCM_MST_SHEET_COLUMNS C
             WHERE U.PROGRAM_ID                    = C.PROGRAM_ID
               AND U.SHEET_NAME                    = C.SHEET_NAME
               AND U.COLUMN_NAME                   = C.COLUMN_NAME
               AND U.PROGRAM_ID                    = P_PROGRAM_ID
               AND U.SHEET_NAME                    = P_SHEET_NAME
               AND U.USER_ID                       = P_CREATED_BY
               AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
             UNION ALL
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , CAST(NULL AS VARCHAR2(10))                               AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , 2                                                        AS SEQ
              FROM SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID   = P_PROGRAM_ID
               AND C.SHEET_NAME   = P_SHEET_NAME
               AND C.VISIBLE_FLAG = 'N'
               AND NVL(C.DEFAULT_FLAG, '/') IN ('-', '/')                   /* AS-IS DEFAULT_FLAG = '' */
               AND C.VALID_YN     = 'Y'
             ORDER BY SEQ
                    , SORT_ORDER_NO;
    END IF;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0046_GET_COMMON_SPREAD_TITLE_EX;

