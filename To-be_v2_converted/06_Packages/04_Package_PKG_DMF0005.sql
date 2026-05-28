/*=============================================================================================
 * File         : 04_Package_PKG_DMF0005.sql
 * Description  : Package — PKG_DMF0005
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - $$PLSQL_UNIT 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0005 IS
/*
 * Program ID   : PKG_DMF0005
 * Description  : PKG_DMF0005
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */



  PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION (
      P_DIVISION_ID         IN VARCHAR2
    , P_DEPT_ID             IN VARCHAR2
    , P_END_CUSTOMER        IN VARCHAR2
    , P_SCM_SITE_ID         IN VARCHAR2
    , P_PROJECT_CODE        IN VARCHAR2
    , P_ITEM_ID             IN VARCHAR2
    , P_VALID_YN            IN VARCHAR2
    , P_OWNER               IN VARCHAR2
    , P_USER_ID          IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );


  PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PURCHASE (
      P_DIVISION_ID       IN VARCHAR2
    , P_SCM_SITE_ID        IN VARCHAR2
    , P_PROJECT_CODE   IN VARCHAR2
    , P_ACTIVE_FLAG    IN VARCHAR2
    , P_USER_ID     IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );
 
 PROCEDURE P_DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION (
      P_DATA           IN CLOB
    , P_USER_ID        IN VARCHAR2
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );
 


    -- ============================================================
    -- 신규 흡수 (2026-05-13 P1-2): standalone SP에서 통합
    -- ============================================================
    PROCEDURE P_DMF0005_GET_OWNERINFO (
    
    	V_Search		    VARCHAR2
       ,V_Language		VARCHAR2  DEFAULT 'KO'
       --,V_SSOUserYN      VARCHAR2  DEFAULT ''
       ,p_created_by   VARCHAR2
    
    /* 20180704 creation
    ** 20180723 MODIFY
    ** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
    **
    **
    **
    */
    );

    PROCEDURE P_DMF0005_SAVE_MODEL_CHANGE_POPUP (
    	p_item_id_before		VARCHAR2,
    	p_item_id_after		VARCHAR2,
    	p_last_updated_by		VARCHAR2
    /*
     *===================================================================================================
     * Program ID   : DMF0005_SAVE_MODEL_CHANGE_POPUP
     * Description  : ITEM_ID 수정
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     *	2022.01.05	rosia27			[C20220103-000584]소형 패커 관련하여 코드 변경 관리
     *	2022.02.03	rosia27			[C20220121-000372]소형사업부 Model Code Change 적용
     *===================================================================================================
     */
    );

    END PKG_DMF0005;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0005 IS

PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION (
      P_DIVISION_ID         IN VARCHAR2
    , P_DEPT_ID             IN VARCHAR2
    , P_END_CUSTOMER        IN VARCHAR2
    , P_SCM_SITE_ID         IN VARCHAR2
    , P_PROJECT_CODE        IN VARCHAR2
    , P_ITEM_ID             IN VARCHAR2
    , P_VALID_YN            IN VARCHAR2
    , P_OWNER               IN VARCHAR2
    , P_USER_ID          IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
/*
 * Program ID   : P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION
 * Description  : P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

IS
    V_GROUP_ID VARCHAR2(50) := '';

    V_ROW_CNT  NUMBER := 0;

BEGIN
    SELECT CASE WHEN COUNT(*) > 0 THEN 'ADMIN' ELSE '' END
      INTO V_GROUP_ID
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
       AND VALID_YN = 'Y'
       AND SEGMENT2 = 'ALL'
       AND SEGMENT1 IN ( SELECT DISTINCT USER_GR_ID
                         FROM   SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
                         WHERE  USER_ID = P_USER_ID
                         AND    UNIT_TP_CD = 'D'
                         AND    EDIT_YN = 'Y'
                         AND    USE_YN = 'Y'
                         AND    UNIT_ID = P_DIVISION_ID )
     ;

    OPEN O_RC1 FOR
    WITH
      ITEM_AGG AS (
          SELECT
                T.DIVISION_ID
              , T.ITEM_ID
              , MAX(T.ITEM_NAME) AS ITEM_NAME
              , MAX(T.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
              , MAX(T.NICK_NAME) AS NICK_NAME
              , CASE MIN(CASE WHEN T.ITEM_TYPE = 'P' THEN 1
                              WHEN T.ITEM_TYPE = 'H' THEN 2
                              WHEN T.ITEM_TYPE = 'Q' THEN 3
                              ELSE 4 END)
                    WHEN 1 THEN 'P'
                    WHEN 2 THEN 'H'
                    WHEN 3 THEN 'Q'
                    ELSE 'R'
                END AS ITEM_TYPE
              , MAX(T.ENERGE) AS ENERGE_WH
              , MAX(T.CELL_TYPE) AS CELL_TYPE_CD
          FROM SCM_MST_ITEM_SN T
          WHERE T.DIVISION_ID = P_DIVISION_ID
          GROUP BY T.DIVISION_ID, T.ITEM_ID
      ),
      CELL_TYPE_LKP AS (
          SELECT SEGMENT1 AS CELL_TYPE_CD
               , SEGMENT2 AS CELL_TYPE_NM
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE LOOKUP_TYPE = 'CELL_TYPE'
            AND VALID_YN = 'Y'
      ),
      CUST_MODEL AS (
          SELECT
                DIVISION_ID
              , SCM_SITE_ID
              , PROJECT_CODE
              , ITEM_ID
              , MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL
          FROM DM_MST_CUSTOMER_MODEL
          WHERE VALID_YN = 'Y'
          GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
      ),
      F_ITEM AS (
          SELECT TRIM(VALUE) AS TOKEN
          FROM TABLE(FN_SPLITSTRING(P_ITEM_ID, ','))
          WHERE TRIM(VALUE) IS NOT NULL
      ),
      F_PROJECT AS (
          SELECT TRIM(VALUE) AS TOKEN
          FROM TABLE(FN_SPLITSTRING(P_PROJECT_CODE, ','))
          WHERE TRIM(VALUE) IS NOT NULL
      ),
      F_OWNER AS (
          SELECT TRIM(VALUE) AS TOKEN
          FROM TABLE(FN_SPLITSTRING(P_OWNER, ','))
          WHERE TRIM(VALUE) IS NOT NULL
      ),

    /* 2) BASE */
    BASE AS (
        SELECT
              SI.DIVISION_ID
            , SI.SCM_SITE_ID
            , SI.PROJECT_CODE
            , SI.DEPT_ID AS DEPT_ID
            , DI.DEPT_NAME_KO AS TEAM_NAME
            , SI.ITEM_ID
            , SI.CUST_GROUP
            , CASE WHEN SI.DIVISION_ID = '40' THEN SI.PROJECT_CODE ELSE ST.END_CUSTOMER END AS END_CUSTOMER
            , SC.SOLDTO_CODE
            , SC.SHIPTO_CODE
            , ST.SOLDTO_CUSTOMER
            , SI.OWNER
            , FN_GET_MULTI_OWNER_NAME(SI.OWNER, ',', '1') AS OWNER_NAME
            , SI.SALES_PLAN_ADJUST_YN
            , ISV.ITEM_TYPE
            , ISV.ITEM_CLASS_NAME
            , ISV.ITEM_NAME
            , ISV.NICK_NAME
            , SI.SALES_COMPANY
            , SI.SALES_PLANT
            , SI.BPMS_EXIST
            , SI.CELL_PER_CAR
            , SI.CELL_PER_MODULE
            , CASE
                  WHEN NVL(SI.CELL_PER_MODULE, 0) = 0 THEN NULL
                  ELSE SI.CELL_PER_CAR / SI.CELL_PER_MODULE
              END AS MODULE_PER_CAR
            , SI.ATTRIBUTE6
            , SI.EDI_LT
            , SI.SCP_VMI_LT AS VMI_LT
            
            , CASE WHEN SI.DIVISION_ID LIKE '81%' THEN TO_NUMBER(SI.ATTRIBUTE8) ELSE 0 END AS KWH
            --, TO_NUMBER(SI.ATTRIBUTE8) AS KWH
            , SI.PROJECT_INFO
            , PRJ.PROJECT_NAME
            , PRJ.PROJECT_STATUS
            , PRJ.PROJECT_OWNER
            , SI.PRJ_OWNR_ID
            , SI.ATTRIBUTE5
            , NVL(SI.VALID_YN, 'Y') AS VALID_YN
            , SI.LAST_UPDATE_DATE
            , SI.LAST_UPDATED_BY
            , ISV.ACTIVE_FLAG AS MDM_ACTIVE
            , IA.ENERGE_WH
            , NVL(IA.CELL_TYPE_CD, SI.ATTRIBUTE10) AS CELL_TYPE_CD
            , CT.CELL_TYPE_NM AS CELL_TYPE
            , SI.ATTRIBUTE9
            , SI.ATTRIBUTE4
            , CM.CUSTOMER_MODEL
        FROM SCM_MST_SITE_ITEM SI
        JOIN SCM_MST_SITE ST
          ON ST.DIVISION_ID = SI.DIVISION_ID
         AND ST.SCM_SITE_ID = SI.SCM_SITE_ID
         AND ST.SITE_TYPE = 'SALES'
        LEFT JOIN SCM_MST_SITE_CUSTOMER SC
          ON SC.DIVISION_ID = SI.DIVISION_ID
         AND SC.SCM_SITE_ID = SI.SCM_SITE_ID
         AND SC.REP_YN = 'Y'
         AND SC.VALID_YN = 'Y'
         AND (P_DIVISION_ID = '82' OR NVL(SC.VALID_YN, 'Y') = 'Y')
        LEFT JOIN DM_MST_ITEM_SINGLE_V ISV
          ON ISV.DIVISION_ID = SI.DIVISION_ID
         AND ISV.ITEM_ID = SI.ITEM_ID
        LEFT JOIN SCM_MST_PROJECT PRJ
          ON PRJ.DIVISION_ID = SI.DIVISION_ID
         AND PRJ.PROJECT_CODE = SI.PROJECT_CODE
        LEFT JOIN SCM_MST_SSO_DEPT_INFO DI
          ON DI.DEPT_ID = SI.DEPT_ID
        LEFT JOIN ITEM_AGG IA
               ON IA.DIVISION_ID = SI.DIVISION_ID
              AND IA.ITEM_ID = SI.ITEM_ID
        LEFT JOIN CELL_TYPE_LKP CT                                      -- 추가
               ON CT.CELL_TYPE_CD = NVL(IA.CELL_TYPE_CD, SI.ATTRIBUTE10)
        LEFT JOIN CUST_MODEL CM
          ON CM.DIVISION_ID = SI.DIVISION_ID
         AND CM.SCM_SITE_ID = SI.SCM_SITE_ID
         AND CM.PROJECT_CODE = SI.PROJECT_CODE
         AND CM.ITEM_ID = SI.ITEM_ID
        WHERE SI.DIVISION_ID = P_DIVISION_ID
        /*
           , SCM_MST_SITE ST
           , SCM_MST_SITE_CUSTOMER SC
           , DM_MST_ITEM_SINGLE_V ISV
           , SCM_MST_PROJECT PRJ
           , SCM_MST_SSO_DEPT_INFO DI
           , ITEM_AGG IA
           , CELL_TYPE_LKP CT
           , CUST_MODEL CM
        WHERE SI.DIVISION_ID = P_DIVISION_ID
          AND ST.DIVISION_ID = SI.DIVISION_ID
          AND ST.SCM_SITE_ID = SI.SCM_SITE_ID
          AND ST.SITE_TYPE = 'SALES'
          AND SC.DIVISION_ID(+) = SI.DIVISION_ID
          AND SC.SCM_SITE_ID(+) = SI.SCM_SITE_ID
          AND SC.REP_YN(+) = 'Y'
          AND SC.VALID_YN(+) = 'Y'
          AND ISV.DIVISION_ID(+) = SI.DIVISION_ID
          AND ISV.ITEM_ID(+) = SI.ITEM_ID
          AND PRJ.DIVISION_ID(+) = SI.DIVISION_ID
          AND PRJ.PROJECT_CODE(+) = SI.PROJECT_CODE
          AND DI.DEPT_ID(+) = SI.DEPT_ID
          AND IA.DIVISION_ID(+) = SI.DIVISION_ID
          AND IA.ITEM_ID(+) = SI.ITEM_ID
          AND CT.CELL_TYPE_CD(+) = NVL(IA.CELL_TYPE_CD, SI.ATTRIBUTE10)
          AND CM.DIVISION_ID(+) = SI.DIVISION_ID
          AND CM.SCM_SITE_ID(+) = SI.SCM_SITE_ID
          AND CM.PROJECT_CODE(+) = SI.PROJECT_CODE
          AND CM.ITEM_ID(+) = SI.ITEM_ID*/
    ),

    /* 3) COMMON FILTERED */
    BF AS (
        SELECT B.*
             , CASE WHEN (FN_GET_DEPT_LIST(P_USER_ID, B.DEPT_ID) = 'Y' OR V_GROUP_ID = 'ADMIN')
                    THEN 'Y' ELSE '' END AS EDIT_FLAG
        FROM BASE B
        WHERE (P_DEPT_ID = 'ALL'      OR B.DEPT_ID        IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_DEPT_ID, ','))))
          AND (P_END_CUSTOMER = 'ALL' OR B.END_CUSTOMER   IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_END_CUSTOMER, ',')))
          
          
          )
          AND (P_SCM_SITE_ID = 'ALL'  OR B.SCM_SITE_ID    IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_SCM_SITE_ID, ','))))
          AND (P_VALID_YN = 'ALL'     OR B.VALID_YN       IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_VALID_YN, ','))))
          
          AND (
                NVL(NULLIF(TRIM(P_ITEM_ID), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM F_ITEM X
                      WHERE TRIM(X.TOKEN) IS NOT NULL
                        AND (
                             NVL(B.ITEM_ID, '')   LIKE '%' || TRIM(X.TOKEN) || '%'
                          OR NVL(B.NICK_NAME, '') LIKE '%' || TRIM(X.TOKEN) || '%'
                        )
                )
          )
          AND (
                NVL(NULLIF(TRIM(P_PROJECT_CODE), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM F_PROJECT X
                      WHERE TRIM(X.TOKEN) IS NOT NULL
                        AND (
                             NVL(B.PROJECT_CODE, '') LIKE '%' || TRIM(X.TOKEN) || '%'
                          OR NVL(B.PROJECT_NAME, '') LIKE '%' || TRIM(X.TOKEN) || '%'
                        )
                )
          )
          AND (
                NVL(NULLIF(TRIM(P_OWNER), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM F_OWNER X
                      WHERE TRIM(X.TOKEN) IS NOT NULL
                        AND (
                             NVL(B.OWNER, '')      LIKE '%' || TRIM(X.TOKEN) || '%'
                          OR NVL(B.OWNER_NAME, '') LIKE '%' || TRIM(X.TOKEN) || '%'
                        )
                )
          )
    ),

    /* 4) 81% 분기: ITEM_TYPE IN ('H','P') OR CNT=0 데이터만 결과 리스트에 포함 */
    SITE_CNT AS (
        SELECT DIVISION_ID
             , SCM_SITE_ID
             , PROJECT_CODE
             , SUM(CASE WHEN ITEM_TYPE IN ('H', 'P') THEN 1 ELSE 0 END) AS CNT
        FROM BF
        GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE
    )

    /* 5) BRANCH PROJECTION */
   SELECT
          BF.DIVISION_ID
        , BF.SCM_SITE_ID
        , BF.PROJECT_CODE
        , BF.DEPT_ID
        , BF.TEAM_NAME
        , BF.ITEM_ID
        , BF.CUST_GROUP
        , BF.END_CUSTOMER
        , BF.SOLDTO_CODE
        , BF.SHIPTO_CODE
        , BF.SOLDTO_CUSTOMER
        , BF.OWNER
        , BF.OWNER_NAME
        , BF.SALES_PLAN_ADJUST_YN
        , BF.ITEM_TYPE
        , BF.ITEM_CLASS_NAME
        , BF.ITEM_NAME
        , BF.NICK_NAME
        , BF.SALES_COMPANY
        , BF.SALES_PLANT
        , BF.BPMS_EXIST
        , BF.CELL_PER_CAR
        , BF.CELL_PER_MODULE
        , BF.EDI_LT
        , BF.VMI_LT
        , BF.PROJECT_INFO
        , BF.PROJECT_NAME
        , BF.PROJECT_STATUS
        , BF.PROJECT_OWNER
        , BF.PRJ_OWNR_ID
        , BF.VALID_YN
        , BF.LAST_UPDATE_DATE
        , BF.LAST_UPDATED_BY
        , BF.MDM_ACTIVE
        , BF.ATTRIBUTE5
        , BF.ENERGE_WH
        , BF.CELL_TYPE
        , BF.ATTRIBUTE9
        , BF.ATTRIBUTE4
        , BF.MODULE_PER_CAR
        , BF.ATTRIBUTE6
        , BF.KWH
        , BF.CUSTOMER_MODEL
        , BF.EDIT_FLAG
    FROM (
        SELECT
              B.*
            , NVL(SC.CNT, 0) AS SC_CNT
        FROM BF B
           , SITE_CNT SC
        WHERE SC.DIVISION_ID(+) = B.DIVISION_ID
          AND SC.SCM_SITE_ID(+) = B.SCM_SITE_ID
          AND SC.PROJECT_CODE(+) = B.PROJECT_CODE
    ) BF
    WHERE (
              P_DIVISION_ID IN ('40', '82')
           OR (
                  P_DIVISION_ID LIKE '81%'
              AND (BF.ITEM_TYPE IN ('H', 'P') OR BF.SC_CNT = 0)
              )
          )
    ORDER BY 
          BF.DIVISION_ID
        , BF.TEAM_NAME
        , BF.END_CUSTOMER
        , BF.SOLDTO_CODE
        , BF.SHIPTO_CODE
        , BF.SOLDTO_CUSTOMER
        , BF.SCM_SITE_ID
        , BF.PROJECT_CODE
        , BF.ITEM_ID
    ;

    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    OPEN O_RESULT_CURSOR FOR
         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN

        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );

END P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION;


PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PURCHASE (
      P_DIVISION_ID       IN VARCHAR2
    , P_SCM_SITE_ID        IN VARCHAR2
    , P_PROJECT_CODE   IN VARCHAR2
    , P_ACTIVE_FLAG    IN VARCHAR2
    , P_USER_ID     IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
) IS
    V_GROUP_ID   VARCHAR2(50) := '';
    
    V_ROW_CNT	      NUMBER := 0;
    
BEGIN
    /* ADMIN 그룹 조회 */
    SELECT CASE WHEN COUNT(1) > 0 THEN 'ADMIN' ELSE '' END
      INTO V_GROUP_ID
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
       AND VALID_YN = 'Y'
       AND SEGMENT2 = 'ALL'
       AND SEGMENT1 IN ( SELECT DISTINCT USER_GR_ID 
                         FROM   SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A 
                         WHERE  USER_ID = P_USER_ID
                         AND    UNIT_TP_CD = 'D'
                         AND    UNIT_ID = P_DIVISION_ID )
     ;

    OPEN O_RC1 FOR
    WITH
    
    ITEM_AGG AS (
        SELECT
              T.DIVISION_ID
            , T.ITEM_ID
            , MAX(T.ITEM_NAME) AS ITEM_NAME
            , MAX(T.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
            , MAX(T.NICK_NAME) AS NICK_NAME
            , CASE MIN(CASE WHEN T.ITEM_TYPE = 'P' THEN 1
                            WHEN T.ITEM_TYPE = 'H' THEN 2
                            WHEN T.ITEM_TYPE = 'Q' THEN 3
                            ELSE 4 END)
                  WHEN 1 THEN 'P'
                  WHEN 2 THEN 'H'
                  WHEN 3 THEN 'Q'
                  ELSE 'R'
              END AS ITEM_TYPE
        FROM SCM_MST_ITEM_SN T
        WHERE T.DIVISION_ID = P_DIVISION_ID
        GROUP BY T.DIVISION_ID, T.ITEM_ID
    ),
    CUST_ITEM AS (
        SELECT
              DIVISION_ID
            , SCM_SITE_ID
            , PROJECT_CODE
            , ITEM_ID
            , MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL
        FROM DM_MST_CUSTOMER_MODEL
        GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
    )
    SELECT DISTINCT
          SI.DIVISION_ID
        , SI.SCM_SITE_ID
        , SI.PROJECT_CODE
        , PJ.PROJECT_NAME
        , PJ.PROJECT_STATUS
        , SI.SALES_PLAN_ADJUST_YN
        , IA.ITEM_TYPE
        , IA.ITEM_CLASS_NAME
        , SI.ITEM_ID
        , CASE WHEN SI.DIVISION_ID LIKE '81%' THEN TO_NUMBER(SI.ATTRIBUTE8) ELSE 0 END AS KWH
        , CI.CUSTOMER_MODEL
        , IA.NICK_NAME
        , SI.BPMS_EXIST
        , SI.OWNER
        , FN_GET_MULTI_OWNER_NAME(SI.OWNER, ',', '1') AS OWNER_NAME
        , SI.VALID_YN
        , SI.CELL_PER_CAR
        , SI.CELL_PER_MODULE
        , CASE
              WHEN NVL(SI.CELL_PER_MODULE, 0) = 0 THEN NULL
              ELSE SI.CELL_PER_CAR / SI.CELL_PER_MODULE
          END AS MODULE_PER_CAR
        , SI.SALES_COMPANY
        , SI.SALES_PLANT
        , SI.LAST_UPDATE_DATE
        , SI.LAST_UPDATED_BY
        , CASE WHEN (FN_GET_DEPT_LIST(P_USER_ID, SI.DEPT_ID) = 'Y' OR V_GROUP_ID = 'ADMIN')
               THEN 'Y' ELSE '' END AS EDIT_FLAG
        , SI.ATTRIBUTE6
        , SI.EDI_LT
        FROM SCM_MST_SITE_ITEM SI
    LEFT JOIN SCM_MST_PROJECT PJ
           ON PJ.DIVISION_ID = SI.DIVISION_ID
          AND PJ.PROJECT_CODE = SI.PROJECT_CODE
    LEFT JOIN SCM_MST_SITE ST
           ON ST.DIVISION_ID = SI.DIVISION_ID
          AND ST.SCM_SITE_ID = SI.SCM_SITE_ID
    LEFT JOIN ITEM_AGG IA
           ON IA.DIVISION_ID = SI.DIVISION_ID
          AND IA.ITEM_ID = SI.ITEM_ID
    LEFT JOIN CUST_ITEM CI
           ON CI.DIVISION_ID = SI.DIVISION_ID
          AND CI.SCM_SITE_ID = SI.SCM_SITE_ID
          AND CI.PROJECT_CODE = SI.PROJECT_CODE
          AND CI.ITEM_ID = SI.ITEM_ID
    WHERE IA.ITEM_TYPE IN ('R', 'Q')
      AND SI.DIVISION_ID = P_DIVISION_ID
      AND SI.PROJECT_CODE = P_PROJECT_CODE
      AND SI.SCM_SITE_ID = P_SCM_SITE_ID
      AND SI.VALID_YN  = P_ACTIVE_FLAG
    ORDER BY 
          SI.DIVISION_ID
        , SI.SCM_SITE_ID
        , SI.PROJECT_CODE
        , SI.ITEM_ID
    ;
        /*
       , SCM_MST_PROJECT PJ
       , SCM_MST_SITE ST
       , ITEM_AGG IA
       , CUST_ITEM CI
    WHERE IA.ITEM_TYPE IN ('R', 'Q')
      AND SI.DIVISION_ID = P_DIVISION_ID
      AND SI.PROJECT_CODE = P_PROJECT_CODE
      AND SI.SCM_SITE_ID = P_SCM_SITE_ID
      AND SI.VALID_YN  = P_ACTIVE_FLAG
      AND PJ.DIVISION_ID(+) = SI.DIVISION_ID
      AND PJ.PROJECT_CODE(+) = SI.PROJECT_CODE
      AND ST.DIVISION_ID(+) = SI.DIVISION_ID
      AND ST.SCM_SITE_ID(+) = SI.SCM_SITE_ID
      AND IA.DIVISION_ID(+) = SI.DIVISION_ID
      AND IA.ITEM_ID(+) = SI.ITEM_ID
      AND CI.DIVISION_ID(+) = SI.DIVISION_ID
      AND CI.SCM_SITE_ID(+) = SI.SCM_SITE_ID
      AND CI.PROJECT_CODE(+) = SI.PROJECT_CODE
      AND CI.ITEM_ID(+) = SI.ITEM_ID*/
    

    
     V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
     
     OPEN O_RESULT_CURSOR FOR
          SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
          
EXCEPTION
    WHEN OTHERS THEN
      
        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );
        
END P_DMF0005_GET_SALES_SITE_MODEL_PURCHASE;

PROCEDURE P_DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION (
      P_DATA            IN CLOB
    , P_USER_ID         IN VARCHAR2
    , O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_CNT           NUMBER := 0;
    V_DUP_ITEM_ID   VARCHAR2(50);

    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
    BEGIN
        V_ERR_MSG := P_MSG;
        RAISE EX_BIZ_EX;
    END;
BEGIN
    FOR R IN (
        SELECT
              TRIM(J.CRUD_TYPE) AS CRUD_TYPE
            , TRIM(J.DIVISION_ID) AS DIVISION_ID
            , TRIM(J.PROJECT_CODE) AS PROJECT_CODE
            , TRIM(J.SCM_SITE_ID) AS SCM_SITE_ID
            , REGEXP_REPLACE(TRIM(J.ITEM_ID), '[[:space:]]+', '') AS ITEM_ID
            , NVL(TRIM(J.SALES_PLAN_ADJUST_YN), '') AS SALES_PLAN_ADJUST_YN
            , NVL(TRIM(J.BPMS_EXIST), '') AS BPMS_EXIST
            , NVL(TRIM(J.VALID_YN), 'Y') AS VALID_YN
            , TRIM(J.DEPT_ID) AS DEPT_ID
            , TRIM(J.CUST_GROUP) AS CUST_GROUP
            , REGEXP_REPLACE(
                  REGEXP_REPLACE(NVL(TRIM(J.OWNER), ''), ',+', ','),
                  '(^,|,$)',
                  ''
              ) AS OWNER
            , P_USER_ID AS USER_ID
            , J.EDI_LT AS EDI_LT
            , CASE
                  WHEN REGEXP_LIKE(NVL(TRIM(J.VMI_LT), '0'), '^-?\d+(\.\d+)?$') THEN TO_NUMBER(TRIM(J.VMI_LT))
                  ELSE 0
              END AS VMI_LT_NUM
            , TRIM(J.SALES_COMPANY) AS SALES_COMPANY
            , TRIM(J.SALES_PLANT) AS SALES_PLANT
            , NVL(NULLIF(TRIM(J.PARTIAL_PLAN_YN), ''), '') AS PARTIAL_PLAN_YN
            , TRIM(J.ENERGE_WH) AS ENERGE_WH
            , TO_CHAR(TRIM(J.KWH), 'TM9', 'NLS_NUMERIC_CHARACTERS=.,') AS KWH -- number
            , TRIM(J.ATTRIBUTE6) AS ATTRIBUTE6
            , TRIM(J.ATTRIBUTE9) AS ATTRIBUTE9
            , TRIM(J.PROJECT_INFO) AS PROJECT_INFO
            , J.CELL_PER_CAR AS CELL_PER_CAR
            , J.CELL_PER_MODULE AS CELL_PER_MODULE
            , TRIM(J.PRJ_OWNR_ID) AS PRJ_OWNR_ID
        FROM JSON_TABLE(
            P_DATA,
            '$[*]'
            COLUMNS (
                  CRUD_TYPE             VARCHAR2(1)    PATH '$.CRUD_TYPE'
                , DIVISION_ID           VARCHAR2(30)   PATH '$.DIVISION_ID'
                , PROJECT_CODE          VARCHAR2(50)   PATH '$.PROJECT_CODE'
                , SCM_SITE_ID           VARCHAR2(30)   PATH '$.SCM_SITE_ID'
                , ITEM_ID               VARCHAR2(50)   PATH '$.ITEM_ID'
                , SALES_PLAN_ADJUST_YN  VARCHAR2(1)    PATH '$.SALES_PLAN_ADJUST_YN'
                , BPMS_EXIST            VARCHAR2(1)    PATH '$.BPMS_EXIST'
                , VALID_YN              VARCHAR2(1)    PATH '$.VALID_YN'
                , DEPT_ID               VARCHAR2(100)  PATH '$.DEPT_ID'
                , CUST_GROUP            VARCHAR2(100)  PATH '$.CUST_GROUP'
                , OWNER                 VARCHAR2(1000) PATH '$.OWNER'
                , EDI_LT                NUMBER         PATH '$.EDI_LT'
                , VMI_LT                VARCHAR2(300)  PATH '$.VMI_LT'
                , SALES_COMPANY         VARCHAR2(300)  PATH '$.SALES_COMPANY'
                , SALES_PLANT           VARCHAR2(300)  PATH '$.SALES_PLANT'
                , PARTIAL_PLAN_YN       VARCHAR2(1)    PATH '$.PARTIAL_PLAN_YN'
                , ENERGE_WH             VARCHAR2(300)  PATH '$.ENERGE_WH'   NULL ON EMPTY
                , KWH                   NUMBER         PATH '$.KWH'         NULL ON EMPTY
                , ATTRIBUTE6            VARCHAR2(300)  PATH '$.ATTRIBUTE6'  NULL ON EMPTY
                , ATTRIBUTE9            VARCHAR2(300)  PATH '$.ATTRIBUTE9'  NULL ON EMPTY
                , PROJECT_INFO          VARCHAR2(300)  PATH '$.PROJECT_INFO' NULL ON EMPTY
                , CELL_PER_CAR          NUMBER         PATH '$.CELL_PER_CAR' NULL ON EMPTY
                , CELL_PER_MODULE       NUMBER         PATH '$.CELL_PER_MODULE' NULL ON EMPTY
                , PRJ_OWNR_ID           VARCHAR2(200)  PATH '$.PRJ_OWNR_ID' NULL ON EMPTY
            )
        ) J
    ) LOOP
            /* =========================
             필수값 검증 - 화면에서 처리
             ========================= */
             /*
          IF R.DIVISION_ID = '40' THEN
              IF TRIM(R.CUST_GROUP)   IS NULL THEN RAISE_INVALID('[40] CUST_GROUP is required.'); END IF;
              IF TRIM(R.PROJECT_CODE) IS NULL THEN RAISE_INVALID('[40] PROJECT_CODE is required.'); END IF;
              IF TRIM(R.OWNER)        IS NULL THEN RAISE_INVALID('[40] OWNER is required.'); END IF;
              IF TRIM(R.SCM_SITE_ID)  IS NULL THEN RAISE_INVALID('[40] SCM_SITE_ID is required.'); END IF;
              IF TRIM(R.SALES_COMPANY)IS NULL THEN RAISE_INVALID('[40] SALES_COMPANY is required.'); END IF;
              IF TRIM(R.SALES_PLANT)  IS NULL THEN RAISE_INVALID('[40] SALES_PLANT is required.'); END IF;
              IF TRIM(R.ITEM_ID)      IS NULL THEN RAISE_INVALID('[40] ITEM_ID is required.'); END IF;
              IF TRIM(R.ATTRIBUTE9)   IS NULL THEN RAISE_INVALID('[40] ATTRIBUTE9(Production Process) is required.'); END IF;

          ELSIF R.DIVISION_ID LIKE '81%' THEN
              IF TRIM(R.OWNER)        IS NULL THEN RAISE_INVALID('[81] OWNER is required.'); END IF;
              IF TRIM(R.SCM_SITE_ID)  IS NULL THEN RAISE_INVALID('[81] SCM_SITE_ID is required.'); END IF;
              IF TRIM(R.SALES_COMPANY)IS NULL THEN RAISE_INVALID('[81] SALES_COMPANY is required.'); END IF;
              IF TRIM(R.SALES_PLANT)  IS NULL THEN RAISE_INVALID('[81] SALES_PLANT is required.'); END IF;
              IF TRIM(R.PROJECT_CODE) IS NULL THEN RAISE_INVALID('[81] PROJECT_CODE is required.'); END IF;
              IF TRIM(R.KWH)          IS NULL THEN RAISE_INVALID('[81] KWH is required.'); END IF;
              IF TRIM(R.VALID_YN)     IS NULL THEN RAISE_INVALID('[81] VALID_YN is required.'); END IF;

          ELSIF R.DIVISION_ID = '82' THEN
              IF TRIM(R.OWNER)        IS NULL THEN RAISE_INVALID('[82] OWNER(Sales) is required.'); END IF;
              IF TRIM(R.PRJ_OWNR_ID)  IS NULL THEN RAISE_INVALID('[82] PRJ_OWNR_ID(Owner PM) is required.'); END IF;
              IF TRIM(R.SALES_COMPANY)IS NULL THEN RAISE_INVALID('[82] SALES_COMPANY is required.'); END IF;
              IF TRIM(R.SALES_PLANT)  IS NULL THEN RAISE_INVALID('[82] SALES_PLANT is required.'); END IF;
              IF TRIM(R.PROJECT_CODE) IS NULL THEN RAISE_INVALID('[82] PROJECT_CODE is required.'); END IF;
              IF TRIM(R.VALID_YN)     IS NULL THEN RAISE_INVALID('[82] VALID_YN is required.'); END IF;
          END IF;
          */
          /* =========================
             OWNER 검증
             ========================= */
          IF TRIM(R.OWNER) IS NOT NULL THEN
              SELECT COUNT(*)
                INTO V_CNT
                FROM (
                      SELECT TRIM(S.VALUE) AS TOKEN
                      FROM TABLE(FN_SPLITSTRING(R.OWNER, ',')) S
                      WHERE TRIM(S.VALUE) IS NOT NULL
                ) O
               WHERE NOT EXISTS (
                      SELECT 1
                      FROM SCM_ADM_USER_M U
                      WHERE U.USER_ID = O.TOKEN
                        --AND U.USE_YN = 'Y'
               );

              IF V_CNT > 0 THEN
                  RAISE_INVALID('Owner정보가 존재하지 않습니다. Owner=' || R.OWNER);
              END IF;
          END IF;

          /* =========================
             OWNER(PM) 검증
             ========================= */
          IF R.DIVISION_ID = '82'
             AND TRIM(R.PRJ_OWNR_ID) IS NOT NULL
          THEN
              SELECT COUNT(*)
                INTO V_CNT
                FROM (
                      SELECT TRIM(S.VALUE) AS TOKEN
                      FROM TABLE(FN_SPLITSTRING(R.PRJ_OWNR_ID, ',')) S
                      WHERE TRIM(S.VALUE) IS NOT NULL
                ) O
               WHERE NOT EXISTS (
                      SELECT 1
                      FROM SCM_ADM_USER_M U
                      WHERE U.USER_ID = O.TOKEN
                        --AND U.USE_YN = 'Y'
               );

              IF V_CNT > 0 THEN
                  RAISE_INVALID('Owner(PM)정보가 존재하지 않습니다. Owner(PM)=' || R.PRJ_OWNR_ID);
              END IF;
          END IF;
        /* 40 division: Active=N blocking validation */
        IF R.DIVISION_ID = '40' AND R.VALID_YN = '' THEN
            SELECT COUNT(*)
              INTO V_CNT
              FROM DM_PLN_MKT_FCST
             WHERE YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND DIVISION_ID = R.DIVISION_ID
               AND PROJECT_CODE = R.PROJECT_CODE
               AND SCM_SITE_ID = R.SCM_SITE_ID
               AND ITEM_ID = R.ITEM_ID
               AND QTY <> 0
               AND MEASURE IN ('MKT_FCST', 'RTF_SCP', 'RTF', 'VMI_In_Req', 'VMI_In_Plan', 'AS_In_Req');

            IF V_CNT > 0 THEN
                RAISE_INVALID('당주 월요일 이후의 MKT FCST 정보가 존재하므로 Active='''' 처리가 불가합니다. Sales Site=' || R.SCM_SITE_ID || ', Model=' || R.ITEM_ID);
            END IF;

            SELECT COUNT(*)
              INTO V_CNT
              FROM DM_PLN_BP_FCST
             WHERE YYYYMM >= TO_CHAR(SYSDATE, 'YYYYMM')
               AND DIVISION_ID = R.DIVISION_ID
               AND PROJECT_CODE = R.PROJECT_CODE
               AND SCM_SITE_ID = R.SCM_SITE_ID
               AND ITEM_ID = R.ITEM_ID
               AND QTY <> 0;

            IF V_CNT > 0 THEN
                RAISE_INVALID('계획구간의 Business Plan 정보가 존재하므로 Active='''' 처리가 불가합니다. Sales Site=' || R.SCM_SITE_ID || ', Model=' || R.ITEM_ID);
            END IF;
        END IF;

          /* ============================================================
            DML
            ============================================================ */
        IF R.CRUD_TYPE = 'I' THEN
            IF R.DIVISION_ID = '40' THEN
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM DM_MST_ITEM_SINGLE_V
                 WHERE DIVISION_ID = R.DIVISION_ID
                   AND ITEM_ID = R.ITEM_ID
                   AND ACTIVE_FLAG = 'Y';

                IF V_CNT = 0 THEN
                    RAISE_INVALID('[' || R.ITEM_ID || '] Invalid Item ID !');
                END IF;

                BEGIN
                    SELECT A.ITEM_ID
                      INTO V_DUP_ITEM_ID
                      FROM SCM_MST_SITE_ITEM A
                      JOIN SCM_MST_SITE B
                        ON A.DIVISION_ID = B.DIVISION_ID
                       AND A.SCM_SITE_ID = B.SCM_SITE_ID
                     WHERE A.DIVISION_ID = R.DIVISION_ID
                       AND SUBSTR(UPPER(R.ITEM_ID), 1, 2) = 'MP'
                       AND SUBSTR(A.ITEM_ID, 1, 11) = SUBSTR(R.ITEM_ID, 1, 11)
                       AND A.ITEM_ID <> R.ITEM_ID
                       AND A.VALID_YN = 'Y'
                       AND B.SITE_TYPE = 'SALES'
                       AND ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_DUP_ITEM_ID := NULL;
                END;

                IF V_DUP_ITEM_ID IS NOT NULL THEN
                    RAISE_INVALID('동일 Pack Model이 존재합니다. Model=' || V_DUP_ITEM_ID);
                END IF;

                SELECT COUNT(*)
                  INTO V_CNT
                  FROM SCM_MST_SITE_ITEM
                 WHERE DIVISION_ID = R.DIVISION_ID
                   AND PROJECT_CODE = R.PROJECT_CODE
                   AND SCM_SITE_ID = R.SCM_SITE_ID
                   AND ITEM_ID = R.ITEM_ID;

                IF V_CNT > 0 THEN
                    RAISE_INVALID('동일한 EndCustomer, SalesSite, Model에 대하여 중복저장이 불가합니다.');
                END IF;

                INSERT INTO SCM_MST_SITE_ITEM (
                    DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                    DEPT_ID,
                    SALES_PLAN_ADJUST_YN, VALID_YN, BPMS_EXIST, CUST_GROUP, OWNER,
                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
                    EDI_LT, SCP_VMI_LT, SALES_COMPANY, SALES_PLANT, PARTIAL_PLAN_YN,
                    ATTRIBUTE8, ATTRIBUTE9, PROJECT_INFO, PRJ_OWNR_ID
                ) VALUES (
                    R.DIVISION_ID, R.PROJECT_CODE, R.SCM_SITE_ID, R.ITEM_ID,
                    R.DEPT_ID,
                    R.SALES_PLAN_ADJUST_YN, 'Y', R.BPMS_EXIST, R.CUST_GROUP, R.OWNER,
                    R.USER_ID, SYSDATE, R.USER_ID, SYSDATE,
                    R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, R.PARTIAL_PLAN_YN,
                    R.ENERGE_WH, R.ATTRIBUTE9, R.PROJECT_INFO, R.PRJ_OWNR_ID
                );

                V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

            ELSIF R.DIVISION_ID LIKE '81%' OR R.DIVISION_ID = '82' THEN
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM SCM_MST_PROJECT_ITEM
                 WHERE DIVISION_ID = R.DIVISION_ID
                   AND PROJECT_CODE = R.PROJECT_CODE
                   AND VALID_YN = 'Y';

                IF V_CNT = 0 THEN
                    RAISE_INVALID('해당 프로젝트에 등록된 모델이 없습니다. 프로젝트 및 모델 정보를 확인해 주세요.');
                END IF;

                SELECT COUNT(*)
                  INTO V_CNT
                  FROM SCM_MST_SITE_ITEM
                 WHERE DIVISION_ID = R.DIVISION_ID
                   AND PROJECT_CODE = R.PROJECT_CODE
                   AND SCM_SITE_ID = R.SCM_SITE_ID;

                IF V_CNT > 0 THEN
                    RAISE_INVALID('동일한 Sales Site, Project Code 가 이미 존재합니다.');
                END IF;

                FOR PI IN (
                    SELECT DISTINCT ITEM_ID
                    FROM SCM_MST_PROJECT_ITEM
                    WHERE DIVISION_ID = R.DIVISION_ID
                      AND PROJECT_CODE = R.PROJECT_CODE
                      AND VALID_YN = 'Y'
                ) LOOP
                    INSERT INTO SCM_MST_SITE_ITEM (
                        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                        DEPT_ID,
                        SALES_PLAN_ADJUST_YN, VALID_YN, BPMS_EXIST, CUST_GROUP, OWNER,
                        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
                        EDI_LT, SCP_VMI_LT, SALES_COMPANY, SALES_PLANT, PARTIAL_PLAN_YN,
                        ATTRIBUTE6, ATTRIBUTE8, CELL_PER_CAR, CELL_PER_MODULE, PRJ_OWNR_ID
                    ) VALUES (
                        R.DIVISION_ID, R.PROJECT_CODE, R.SCM_SITE_ID, PI.ITEM_ID,
                        R.DEPT_ID,
                        R.SALES_PLAN_ADJUST_YN, NVL(R.VALID_YN, 'Y'), R.BPMS_EXIST, R.CUST_GROUP, R.OWNER,
                        R.USER_ID, SYSDATE, R.USER_ID, SYSDATE,
                        R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, R.PARTIAL_PLAN_YN,
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.ATTRIBUTE6 ELSE NULL END,
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.KWH ELSE NULL END,
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_CAR ELSE NULL END,
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_MODULE ELSE NULL END,
                        CASE WHEN R.DIVISION_ID = '82' THEN R.PRJ_OWNR_ID ELSE NULL END
                    );

                    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
                END LOOP;
            END IF;

        ELSE
          UPDATE SCM_MST_SITE_ITEM A
             SET A.LAST_UPDATED_BY = R.USER_ID
             , A.LAST_UPDATE_DATE = SYSDATE
             , A.OWNER = NVL(R.OWNER, A.OWNER)
             , A.DEPT_ID = NVL(R.DEPT_ID, A.DEPT_ID)
             , A.SALES_COMPANY = NVL(R.SALES_COMPANY, A.SALES_COMPANY)
             , A.SALES_PLANT = NVL(R.SALES_PLANT, A.SALES_PLANT)
             , A.PARTIAL_PLAN_YN = NVL(R.PARTIAL_PLAN_YN, A.PARTIAL_PLAN_YN)
             , A.CUST_GROUP = NVL(R.CUST_GROUP, A.CUST_GROUP)
             , A.SALES_PLAN_ADJUST_YN = NVL(R.SALES_PLAN_ADJUST_YN, A.SALES_PLAN_ADJUST_YN)
             , A.ATTRIBUTE8 = CASE
                        WHEN R.DIVISION_ID = '40' THEN NVL(R.ENERGE_WH, A.ATTRIBUTE8)
                        WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.KWH, A.ATTRIBUTE8)
                        ELSE A.ATTRIBUTE8
                      END
             , A.ATTRIBUTE9 = CASE WHEN R.DIVISION_ID = '40' THEN NVL(R.ATTRIBUTE9, A.ATTRIBUTE9) ELSE A.ATTRIBUTE9 END
             , A.PROJECT_INFO = CASE WHEN R.DIVISION_ID = '40' THEN NVL(R.PROJECT_INFO, A.PROJECT_INFO) ELSE A.PROJECT_INFO END
             , A.ATTRIBUTE6 = CASE WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.ATTRIBUTE6, A.ATTRIBUTE6) ELSE A.ATTRIBUTE6 END
             , A.EDI_LT = NVL(R.EDI_LT, A.EDI_LT)
             , A.SCP_VMI_LT = NVL(R.VMI_LT_NUM, A.SCP_VMI_LT)
             , A.CELL_PER_CAR = CASE WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.CELL_PER_CAR, A.CELL_PER_CAR) ELSE A.CELL_PER_CAR END
             , A.CELL_PER_MODULE = CASE WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.CELL_PER_MODULE, A.CELL_PER_MODULE) ELSE A.CELL_PER_MODULE END
             , A.PRJ_OWNR_ID = CASE WHEN R.DIVISION_ID = '82' THEN NVL(R.PRJ_OWNR_ID, A.PRJ_OWNR_ID) ELSE A.PRJ_OWNR_ID END
             , A.VALID_YN = NVL(R.VALID_YN, A.VALID_YN)
             , A.BPMS_EXIST = NVL(R.BPMS_EXIST, A.BPMS_EXIST)
           WHERE A.DIVISION_ID = R.DIVISION_ID
             AND A.PROJECT_CODE = R.PROJECT_CODE
             AND A.SCM_SITE_ID = R.SCM_SITE_ID
             AND A.ITEM_ID = R.ITEM_ID;

          IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO SCM_MST_SITE_ITEM (
              DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
              DEPT_ID,
              SALES_PLAN_ADJUST_YN, VALID_YN, BPMS_EXIST, CUST_GROUP, OWNER,
              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
              EDI_LT, SCP_VMI_LT, SALES_COMPANY, SALES_PLANT, PARTIAL_PLAN_YN,
              ATTRIBUTE6, ATTRIBUTE8, ATTRIBUTE9, PROJECT_INFO,
              CELL_PER_CAR, CELL_PER_MODULE, PRJ_OWNR_ID
            ) VALUES (
              R.DIVISION_ID, R.PROJECT_CODE, R.SCM_SITE_ID, R.ITEM_ID,
              R.DEPT_ID,
              NVL(R.SALES_PLAN_ADJUST_YN, ''),
              NVL(R.VALID_YN, 'Y'),
              NVL(R.BPMS_EXIST, ''),
              R.CUST_GROUP,
              R.OWNER,
              R.USER_ID, SYSDATE, R.USER_ID, SYSDATE,
              R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, R.PARTIAL_PLAN_YN,
              CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.ATTRIBUTE6 ELSE NULL END,
              CASE
                WHEN R.DIVISION_ID = '40' THEN R.ENERGE_WH
                WHEN R.DIVISION_ID LIKE '81%' THEN R.KWH
                ELSE NULL
              END,
              CASE WHEN R.DIVISION_ID = '40' THEN R.ATTRIBUTE9 ELSE NULL END,
              CASE WHEN R.DIVISION_ID = '40' THEN R.PROJECT_INFO ELSE NULL END,
              CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_CAR ELSE NULL END,
              CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_MODULE ELSE NULL END,
              CASE WHEN R.DIVISION_ID = '82' THEN R.PRJ_OWNR_ID ELSE NULL END
            );
          END IF;

            V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
        END IF;
    END LOOP;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT
        FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, '0' AS EVENT
            FROM DUAL;

    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || '-'
        );
END P_DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION;


    -- ============================================================
    -- 신규 흡수 (2026-05-13 P1-2): standalone SP 본문 통합
    -- ============================================================
    PROCEDURE P_DMF0005_GET_OWNERINFO (
    
    	V_Search		    VARCHAR2
       ,V_Language		VARCHAR2  DEFAULT 'KO'
       --,V_SSOUserYN      VARCHAR2  DEFAULT ''
       ,p_created_by   VARCHAR2
    
    /* 20180704 creation
    ** 20180723 MODIFY
    ** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
    **
    **
    **
    */
    )
        IS
    v_group_id VARCHAR2(50 CHAR);
        v_cnt_1  INTEGER := 0;
    BEGIN
    
    	-- ------------------------------------------------------------------------------
    	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    	-- ------------------------------------------------------------------------------
    	SELECT COUNT(1)
    	INTO v_cnt_1
    	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    	where LOOKUP_TYPE = 'GET_ADMIN_GROUP'
    	AND VALID_YN = 'Y'
    	AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
    	AND SEGMENT1 = p_created_by;
    	IF v_cnt_1 > 0 THEN
    			v_group_id := 'ADMIN';
    		END IF;
    	-- ------------------------------------------------------------------------------
    	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    	-- ------------------------------------------------------------------------------
    	SELECT DISTINCT  A.user_id UserID
    		,A.user_name UserName
    		,A.user_name_en	UserName_E
    		,A.dept_id
    		,CASE V_Language WHEN 'KO' THEN B.dept_name_ko
    						WHEN 'EN' THEN B.dept_name_en
    						WHEN 'CN' THEN B.dept_name_cn
    			END dept_name
    	FROM SCM_MST_SSO_USER_INFO A
    	INNER JOIN SCM_MST_SSO_DEPT_INFO B
    	ON A.DEPT_ID = B.DEPT_ID
    	AND B.DEPT_ID in (
    	                    select dept_id
    						  from TB_FX_User zz
    						  where zz.dept_id = B.dept_id
    	                  )
    	INNER JOIN (SELECT USER_ID, DEPT_ID FROM SCM_MST_SSO_USER_INFO  ) C ON A.DEPT_ID = C.DEPT_ID
    	WHERE A.ACTIVE_FLAG != 'D'
    
    	--AND C.USER_ID = CASE WHEN ( SELECTw.DefaultGroupID FROM TB_FX_User w   where w.USERID = p_created_by  ) like '%ADMIN'THEN C.USER_ID ELSE p_created_by END
    
    	AND C.USER_ID = CASE WHEN v_group_id = 'ADMIN' THEN C.USER_ID ELSE p_created_by END  --20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
    
    	-- AND C.USER_ID = p_created_by   --추가, 20180704
    		AND (
    			   (V_Search IS NULL OR A.user_id LIKE '%'  ||  V_Search  ||  '%')
    			OR (V_Search IS NULL OR A.user_name LIKE '%'  ||  V_Search  ||  '%')
    			OR (V_Search IS NULL OR A.user_name_en LIKE '%'  ||  V_Search  ||  '%')
    			)
    
    FETCH FIRST 1 ROWS ONLY
    END P_DMF0005_GET_OWNERINFO;

    PROCEDURE P_DMF0005_SAVE_MODEL_CHANGE_POPUP (
    	p_item_id_before		VARCHAR2,
    	p_item_id_after		VARCHAR2,
    	p_last_updated_by		VARCHAR2
    /*
     *===================================================================================================
     * Program ID   : DMF0005_SAVE_MODEL_CHANGE_POPUP
     * Description  : ITEM_ID 수정
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     *	2022.01.05	rosia27			[C20220103-000584]소형 패커 관련하여 코드 변경 관리
     *	2022.02.03	rosia27			[C20220121-000372]소형사업부 Model Code Change 적용
     *===================================================================================================
     */
    )
        IS
    /*
     * ========================================
     * [변환검증] 2026-03-02 20:37:08
     * 파일: dbo.DMF0005_SAVE_MODEL_CHANGE_POPUP.sql
     * ----------------------------------------
     * ⚠ IF: IF:49  END IF:46  차이:+3
     * ⚠ BEGIN: BEGIN:6  END:5  차이:+1
     * ----------------------------------------
     * BEGIN 위치: L82, L129, L134, L146, L174, L214
     * END;  위치: L172, L191, L194, L223, L1553
     * ----------------------------------------
     * 힌트: BEGIN이 1개 더 많음 → END; 누락 가능성
     * 수정 완료 후 이 주석 블록을 삭제하세요.
     * ========================================
     */
    
    
    
        s_item_id_before VARCHAR2(4000 CHAR);
        s_item_id_after VARCHAR2(4000 CHAR);
        s_last_updated_by VARCHAR2(4000 CHAR);
        -- $$PLSQL_UNIT 제거: $$PLSQL_UNIT 사용 (사내 표준 §11)
        v_log_type VARCHAR2(30 CHAR);
        n_log_count INTEGER := 0;
        v_log_message VARCHAR2(1000 CHAR);
        v_description VARCHAR2(500 CHAR);
        d_event_date DATE;
        n_delete_count INTEGER := 0;
        n_insert_count INTEGER := 0;
        n_logo_count INTEGER := 0;
        v_index_item_id_before INTEGER;
        v_index_item_id_after INTEGER;
        v_index_last_updated_by INTEGER;
        v_cnt_1  INTEGER := 0;
        v_cnt_2  INTEGER := 0;
        v_cnt_3  INTEGER := 0;
        v_cnt_4  INTEGER := 0;
        v_cnt_5  INTEGER := 0;
        v_cnt_6  INTEGER := 0;
        v_cnt_7  INTEGER := 0;
        v_cnt_8  INTEGER := 0;
        v_cnt_9  INTEGER := 0;
        v_cnt_10  INTEGER := 0;
        v_cnt_11  INTEGER := 0;
        v_cnt_12  INTEGER := 0;
        v_cnt_13  INTEGER := 0;
        v_cnt_14  INTEGER := 0;
        v_cnt_15  INTEGER := 0;
        v_cnt_16  INTEGER := 0;
        v_cnt_17  INTEGER := 0;
        v_cnt_18  INTEGER := 0;
        v_cnt_19  INTEGER := 0;
        v_cnt_20  INTEGER := 0;
        v_cnt_21  INTEGER := 0;
        v_cnt_22  INTEGER := 0;
        v_cnt_23  INTEGER := 0;
        v_cnt_24  INTEGER := 0;
        v_cnt_25  INTEGER := 0;
        v_cnt_26  INTEGER := 0;
        v_cnt_27  INTEGER := 0;
        v_cnt_28  INTEGER := 0;
        v_cnt_29  INTEGER := 0;
        v_cnt_30  INTEGER := 0;
        v_cnt_31  INTEGER := 0;
        v_cnt_32  INTEGER := 0;
        v_cnt_33  INTEGER := 0;
        v_cnt_34  INTEGER := 0;
        v_cnt_35  INTEGER := 0;
        v_cnt_36  INTEGER := 0;
        v_cnt_37  INTEGER := 0;
        v_cnt_38  INTEGER := 0;
        v_cnt_39  INTEGER := 0;
        v_cnt_40  INTEGER := 0;
        v_cnt_41  INTEGER := 0;
        v_cnt_42  INTEGER := 0;
        v_cnt_43  INTEGER := 0;
        v_cnt_44  INTEGER := 0;
        v_cnt_45  INTEGER := 0;
    BEGIN
    DBMS_OUTPUT.PUT_LINE('1--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    	        	-- 스플릿관련 변수
    
    
    
    	s_item_id_before := NULL;
    	s_item_id_after := NULL;
    	s_last_updated_by := NULL;
    
    	-- 마지막 데이터 처리를 위한 구분자 추가
    	p_item_id_before := RTRIM(p_item_id_before					)  ||  '^';
    	p_item_id_after := RTRIM(p_item_id_after					)  ||  '^';
    	p_last_updated_by := RTRIM(p_last_updated_by					)  ||  '^';
    
    	-- GT_DMF0_results_MST TEMP TABLE
    	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_results_MST';
    
    	-- GT_DMF0_results_insert TEMP TABLE
    	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_results_insert';
    
    	-- LOG 용 변수 설정
    
    
    
    
    
    
    
    
    
    	v_log_type := 'START';
    	v_log_message := '########## Start of procedure ##########';
    	v_description := NULL;
    	d_event_date := SYSTIMESTAMP;
    	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    
    	-- 시작 LOG  (END)
    	v_log_message := NULL      /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/
    
    
    	BEGIN TRY
    
    	--------------------------------------------------------------------------------------------◇◇◇◇
    	--          GT_DMF0_results_MST 테이블에 split후 insert (BEGIN)
    	--------------------------------------------------------------------------------------------◇◇◇◇
    DBMS_OUTPUT.PUT_LINE('2--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    	BEGIN  --split
    
    		WHILE LENGTH(p_item_id_before) > 0
    
    		---------------------------(2)
    		BEGIN  -- WHILE
    		---------------------------(2)
    
    
    
    			v_index_item_id_before := PATINDEX('%'  ||  '^'  ||  '%', p_item_id_before			);
    			v_index_item_id_after := PATINDEX('%'  ||  '^'  ||  '%', p_item_id_after			);
    			v_index_last_updated_by := PATINDEX('%'  ||  '^'  ||  '%', p_last_updated_by		);
    
    			---------------------------(1)
    			IF LENGTH(v_index_item_id_before) > 0
    			---------------------------(1)
    				BEGIN
    					--문자열 자르기(0 ~ INDEX)
    					s_item_id_before := SUBSTR(p_item_id_before			, 0, v_index_item_id_before		);
    					s_item_id_after := SUBSTR(p_item_id_after			, 0, v_index_item_id_after		);
    					s_last_updated_by := SUBSTR(p_last_updated_by			, 0, v_index_last_updated_by		);
    
    					--문자열 자르기(^ ~ END)
    					p_item_id_before := SUBSTR(p_item_id_before			, LENGTH(s_item_id_before			  ||  '^') || 1, LENGTH(p_item_id_before			));
    					p_item_id_after := SUBSTR(p_item_id_after			, LENGTH(s_item_id_after			  ||  '^') || 1, LENGTH(p_item_id_after			));
    					p_last_updated_by := SUBSTR(p_last_updated_by			, LENGTH(s_last_updated_by			  ||  '^') || 1, LENGTH(p_last_updated_by			));
    
    					-- 공백제거(START)
    					s_item_id_before := RTRIM(LTRIM(s_item_id_before			));
    					s_item_id_after := RTRIM(LTRIM(s_item_id_after			));
    					s_last_updated_by := RTRIM(LTRIM(s_last_updated_by		));
    					-- 공백제거(END)
    
    					INSERT INTO GT_DMF0_results_MST (;
    											  item_id_before
    											 ,item_id_after
    											 ,last_updated_by
    					) VALUES (
    											  s_item_id_before
    											 ,s_item_id_after
    											 ,s_last_updated_by
    					)
    				END
    			ELSE
    				BEGIN
    					-- 공백제거(START)
    					s_item_id_before := RTRIM(LTRIM(s_item_id_before			));
    					s_item_id_after := RTRIM(LTRIM(s_item_id_after			));
    					s_last_updated_by := RTRIM(LTRIM(s_last_updated_by		));
    					-- 공백제거(END)
    
    					INSERT INTO GT_DMF0_results_MST (;
    											  item_id_before
    											 ,item_id_after
    											 ,last_updated_by
    					) VALUES (
    											  s_item_id_before
    											 ,s_item_id_after
    											 ,s_last_updated_by
    					)
    			---------------------------(1)
    				END
    			---------------------------(1)
    		---------------------------(2)
    		END  -- WHILE
    		---------------------------(2)
    
    		UPDATE A
    		SET DATA_SEQ = NVL(B.DATA_SEQ, 0) || 1
    		FROM GT_DMF0_results_MST A
    		LEFT OUTER JOIN (
    						SELECT A.BEFORE_CODE, A.AFTER_CODE, MAX(A.DATA_SEQ) AS DATA_SEQ
    						FROM DM_DNM_ITEM_CODE_CHANGE_HISTORY A
    						GROUP BY A.BEFORE_CODE, A.AFTER_CODE
    						) B  ON A.ITEM_ID_BEFORE = B.BEFORE_CODE AND A.ITEM_ID_AFTER= B.AFTER_CODE
    
    DBMS_OUTPUT.PUT_LINE('3--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    		---------VALIDATION CHECK START----------------------------------------
    		--VALIDATION CHECK : 문자 길이가 12자리인지
    		SELECT COUNT(1)
    		INTO v_cnt_1
    		FROM GT_DMF0_results_MST WHERE LENGTH(ITEM_ID_BEFORE) <> 12;
    		IF v_cnt_1 > 0
    		BEGIN
    			SELECT /*__INTO_v_description__*/ 'Model 코드의 자리수가 12자리가 아니므로 변경할 수 없습니다.'  ||  char(10)  ||  'MODEL : '  ||  ITEM_ID_BEFORE
    			FROM GT_DMF0_results_MST
    			WHERE LENGTH(ITEM_ID_BEFORE) <> 12
    
    			SELECT v_description
    			v_log_type := 'INVALID';
    			GOTO ERR_RTN
    			FROM DUAL;
    		END;
    
    		SELECT COUNT(1)
    		INTO v_cnt_2
    		FROM GT_DMF0_results_MST WHERE LENGTH(ITEM_ID_AFTER) <> 12;
    		IF v_cnt_2 > 0 THEN
    			SELECT /*__INTO_v_description__*/ 'Model 코드의 자리수가 12자리가 아니므로 변경할 수 없습니다.'  ||  char(10)  ||  'MODEL : '  ||  ITEM_ID_AFTER
    			FROM GT_DMF0_results_MST
    			WHERE LENGTH(ITEM_ID_AFTER) <> 12
    
    			SELECT v_description
    			v_log_type := 'INVALID';
    			GOTO ERR_RTN
    			FROM DUAL;
    		END IF;
    
    		-- VALIDATION CHECK : 앞의 11자리가 같은지
    		SELECT COUNT(1)
    		INTO v_cnt_3
    		FROM GT_DMF0_results_MST WHERE SUBSTR(item_id_before, 1, 11) <> SUBSTR(item_id_after, 1, 11);
    		IF v_cnt_3 > 0 THEN
    			SELECT /*__INTO_v_description__*/ 'Model 코드의 앞 11자리가 서로 다르므로 변경할 수 없습니다.'  ||   'MODEL : '  ||  ITEM_ID_BEFORE  ||  ', '  ||  ITEM_ID_AFTER
    			FROM GT_DMF0_results_MST
    			WHERE SUBSTR(item_id_before, 1, 11) <> SUBSTR(item_id_after, 1, 11)
    
    			SELECT v_description
    			v_log_type := 'INVALID';
    			GOTO ERR_RTN
    			FROM DUAL;
    		END IF;
    
    		-- VALIDATION CHECK : 맨앞의 두글자가 MP인지
    		SELECT COUNT(1)
    		INTO v_cnt_4
    		FROM GT_DMF0_results_MST WHERE SUBSTR(item_id_before, 1, 2) <> 'MP';
    		IF v_cnt_4 > 0 THEN
    			SELECT /*__INTO_v_description__*/ 'Model 코드가 ''MP''로 시작하지 않는 코드는 변경할 수 없습니다.'  ||   'MODEL : '  ||  ITEM_ID_BEFORE
    			FROM GT_DMF0_results_MST
    			WHERE SUBSTR(item_id_before, 1, 2) <> 'MP'
    
    			SELECT v_description
    			v_log_type := 'INVALID';
    			GOTO ERR_RTN
    			FROM DUAL;
    		END IF;
    
    		SELECT COUNT(1)
    		INTO v_cnt_5
    		FROM GT_DMF0_results_MST WHERE SUBSTR(item_id_after, 1, 2) <> 'MP';
    		IF v_cnt_5 > 0 THEN
    			SELECT /*__INTO_v_description__*/ 'Model 코드가 ''MP''로 시작하지 않는 코드는 변경할 수 없습니다.'  ||   'MODEL : '  ||  ITEM_ID_AFTER
    			FROM GT_DMF0_results_MST
    			WHERE SUBSTR(item_id_after, 1, 2) <> 'MP'
    
    			SELECT v_description
    			v_log_type := 'INVALID';
    			GOTO ERR_RTN
    			FROM DUAL;
    		END IF;
    
    		-- VALIDATION CHECK : 12번째 글자가 다른지
    		SELECT COUNT(1)
    		INTO v_cnt_6
    		FROM GT_DMF0_results_MST WHERE item_id_before = item_id_after;
    		IF v_cnt_6 > 0 THEN
    			SELECT /*__INTO_v_description__*/ '변경전 후의 모델코드가 동일합니다.'  ||   'MODEL : '  ||  item_id_before
    			FROM GT_DMF0_results_MST
    			WHERE item_id_before = item_id_after
    
    			SELECT v_description
    			v_log_type := 'INVALID';
    			GOTO ERR_RTN
    			FROM DUAL;
    		END IF;
    
    		-- VALIDTION CHECK : 12번째가 N, C인 값이 동시 존재하고 있는지
    		SELECT COUNT(1)
    		INTO v_cnt_7
    		FROM GT_DMF0_results_MST A
    		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID_BEFORE = B.ITEM_ID AND B.DIVISION_ID = '40'
    		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID_AFTER = C.ITEM_ID AND C.DIVISION_ID = '40'
    		WHERE B.ITEM_ID IS NULL
    		OR C.ITEM_ID IS NULL;
    		IF v_cnt_7 > 0 THEN
    			SELECT /*__INTO_v_description__*/ CASE WHEN B.ITEM_ID IS NULL THEN A.ITEM_ID_BEFORE ELSE A.ITEM_ID_AFTER END   ||  '은 존재하지 않는 코드입니다.'
    			FROM GT_DMF0_results_MST A
    			LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B ON A.ITEM_ID_BEFORE = B.ITEM_ID AND B.DIVISION_ID = '40'
    			LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID_AFTER = C.ITEM_ID AND C.DIVISION_ID = '40'
    			WHERE B.ITEM_ID IS NULL
    				OR C.ITEM_ID IS NULL
    
    			SELECT v_description
    			v_log_type := 'INVALID';
    			GOTO ERR_RTN
    			FROM DUAL;
    		END IF;
    
    		---------VALIDATION CHECK END----------------------------------------
    
    DBMS_OUTPUT.PUT_LINE('4--'  ||  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    
    		---------TABLE UPDATE START------------------------------------------
    
    		-- DM_ANL_KPI_RTF_DEMAND UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_8
    		FROM DM_ANL_KPI_RTF_DEMAND A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_8 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_ANL_KPI_RTF_DEMAND' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_ANL_KPI_RTF_DEMAND A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_ANL_KPI_RTF_DEMAND A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    			END IF;
    
    		-- DM_ANL_KPI_RTF_SALES UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_9
    		FROM DM_ANL_KPI_RTF_SALES A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_9 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_ANL_KPI_RTF_SALES' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_ANL_KPI_RTF_SALES A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_ANL_KPI_RTF_SALES A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_ANL_KPI_SALES_ACCURACY UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_10
    		FROM DM_ANL_KPI_SALES_ACCURACY A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_10 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_ANL_KPI_SALES_ACCURACY' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_ANL_KPI_SALES_ACCURACY A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_ANL_KPI_SALES_ACCURACY A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_ANL_KPI_SUMMARY UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_11
    		FROM DM_ANL_KPI_SUMMARY A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_11 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_ANL_KPI_SUMMARY' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_ANL_KPI_SUMMARY A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_ANL_KPI_SUMMARY A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_DNM_EDI_CALLOFF_ITEM UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_12
    		FROM DM_DNM_EDI_CALLOFF_ITEM A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_12 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_DNM_EDI_CALLOFF_ITEM' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_DNM_EDI_CALLOFF_ITEM A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_DNM_EDI_CALLOFF_ITEM A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_DNM_SALES_RESULT_IF UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_13
    		FROM DM_DNM_SALES_RESULT_IF A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_13 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_DNM_SALES_RESULT_IF' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_DNM_SALES_RESULT_IF A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_DNM_SALES_RESULT_IF A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_HI_CUST_FCST_INPUT UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_14
    		FROM DM_HI_CUST_FCST_INPUT A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_14 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_HI_CUST_FCST_INPUT' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_HI_CUST_FCST_INPUT A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_HI_CUST_FCST_INPUT A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_HI_MKT_FCST_CHANGE UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_15
    		FROM DM_HI_MKT_FCST_CHANGE A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_15 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_HI_MKT_FCST_CHANGE' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_HI_MKT_FCST_CHANGE A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_HI_MKT_FCST_CHANGE A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_HI_SALES_INPUT UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_16
    		FROM DM_HI_SALES_INPUT A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_16 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_HI_SALES_INPUT' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_HI_SALES_INPUT A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_HI_SALES_INPUT A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_HI_SITE_ITEM_MAPPING UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_17
    		FROM DM_HI_SITE_ITEM_MAPPING A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_17 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_HI_SITE_ITEM_MAPPING' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_HI_SITE_ITEM_MAPPING A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_HI_SITE_ITEM_MAPPING A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_HI_SITE_ITEM_MAPPING_ROWDATA UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_18
    		FROM DM_HI_SITE_ITEM_MAPPING_ROWDATA A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_18 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_HI_SITE_ITEM_MAPPING_ROWDATA' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_HI_SITE_ITEM_MAPPING_ROWDATA A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_HI_SITE_ITEM_MAPPING_ROWDATA A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_MST_BUCKET_CONVERSION UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_19
    		FROM DM_MST_BUCKET_CONVERSION A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_19 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_MST_BUCKET_CONVERSION' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_MST_BUCKET_CONVERSION A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_MST_BUCKET_CONVERSION A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_MST_BUCKET_CONVERSION_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_20
    		FROM DM_MST_BUCKET_CONVERSION_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_20 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_MST_BUCKET_CONVERSION_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_MST_BUCKET_CONVERSION_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_MST_BUCKET_CONVERSION_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_MST_CAPACITY_ALLOCATION UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_21
    		FROM DM_MST_CAPACITY_ALLOCATION A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_21 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_MST_CAPACITY_ALLOCATION' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_MST_CAPACITY_ALLOCATION A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_MST_CAPACITY_ALLOCATION A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_MST_CAPACITY_ALLOCATION_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_22
    		FROM DM_MST_CAPACITY_ALLOCATION_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_22 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_MST_CAPACITY_ALLOCATION_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_MST_CAPACITY_ALLOCATION_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_MST_CAPACITY_ALLOCATION_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_MST_CUSTOMER_MODEL UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_23
    		FROM DM_MST_CUSTOMER_MODEL A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_23 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_MST_CUSTOMER_MODEL' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_MST_CUSTOMER_MODEL A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_MST_CUSTOMER_MODEL A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_MST_CUSTOMER_MODEL_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_24
    		FROM DM_MST_CUSTOMER_MODEL_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_24 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_MST_CUSTOMER_MODEL_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_MST_CUSTOMER_MODEL_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_MST_CUSTOMER_MODEL_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_MST_EDI_CUST_MATERIAL_INFO UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_25
    		FROM DM_MST_EDI_CUST_MATERIAL_INFO A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_25 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_MST_EDI_CUST_MATERIAL_INFO' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_MST_EDI_CUST_MATERIAL_INFO A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_MST_EDI_CUST_MATERIAL_INFO A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		END IF;
    
    		-- DM_PLN_BP_FCST UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_26
    		FROM DM_PLN_BP_FCST A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_26 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_BP_FCST' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_BP_FCST A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_BP_FCST A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_BP_FCST_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_27
    		FROM DM_PLN_BP_FCST_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_27 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_BP_FCST_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_BP_FCST_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_BP_FCST_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_CUSTOMER_PSI UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_28
    		FROM DM_PLN_CUSTOMER_PSI A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_28 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_CUSTOMER_PSI' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_CUSTOMER_PSI A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_CUSTOMER_PSI A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_CUSTOMER_PSI_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_29
    		FROM DM_PLN_CUSTOMER_PSI_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_29 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_CUSTOMER_PSI_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_CUSTOMER_PSI_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_CUSTOMER_PSI_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_MKT_FCST UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_30
    		FROM DM_PLN_MKT_FCST A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_30 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_MKT_FCST' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_MKT_FCST A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_MKT_FCST A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_MKT_FCST_CONFIRM UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_31
    		FROM DM_PLN_MKT_FCST_CONFIRM A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_31 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_MKT_FCST_CONFIRM' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_MKT_FCST_CONFIRM A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_MKT_FCST_CONFIRM A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_MKT_FCST_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_32
    		FROM DM_PLN_MKT_FCST_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_32 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_MKT_FCST_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_MKT_FCST_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_MKT_FCST_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_MKT_FCST_PK_DATA_UPDATE_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_33
    		FROM DM_PLN_MKT_FCST_PK_DATA_UPDATE_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_33 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_MKT_FCST_PK_DATA_UPDATE_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_MKT_FCST_PK_DATA_UPDATE_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_MKT_FCST_PK_DATA_UPDATE_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_MKT_FCST_RESULT UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_34
    		FROM DM_PLN_MKT_FCST_RESULT A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_34 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_MKT_FCST_RESULT' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_MKT_FCST_RESULT A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_MKT_FCST_RESULT A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_PR_DETAIL UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_35
    		FROM DM_PLN_PR_DETAIL A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_35 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_PR_DETAIL' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_PR_DETAIL A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_PR_DETAIL A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_SALES_PLAN UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_36
    		FROM DM_PLN_SALES_PLAN A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_36 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_SALES_PLAN' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_SALES_PLAN A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_SALES_PLAN A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_SALES_PLAN_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_37
    		FROM DM_PLN_SALES_PLAN_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_37 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_SALES_PLAN_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_SALES_PLAN_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_SALES_PLAN_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_SALES_PLAN_REPORT_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_38
    		FROM DM_PLN_SALES_PLAN_REPORT_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_38 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_SALES_PLAN_REPORT_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_SALES_PLAN_REPORT_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_SALES_PLAN_REPORT_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- DM_PLN_SALES_PLAN_RESULT UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_39
    		FROM DM_PLN_SALES_PLAN_RESULT A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_39 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'DM_PLN_SALES_PLAN_RESULT' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM DM_PLN_SALES_PLAN_RESULT A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM DM_PLN_SALES_PLAN_RESULT A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- SCM_MST_FUTURE_PRICE UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_40
    		FROM SCM_MST_FUTURE_PRICE A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_40 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'SCM_MST_FUTURE_PRICE' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM SCM_MST_FUTURE_PRICE A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM SCM_MST_FUTURE_PRICE A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- SCM_MST_FUTURE_PRICE_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_41
    		FROM SCM_MST_FUTURE_PRICE_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_41 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'SCM_MST_FUTURE_PRICE_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM SCM_MST_FUTURE_PRICE_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM SCM_MST_FUTURE_PRICE_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- SCM_MST_SITE_ITEM UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_42
    		FROM SCM_MST_SITE_ITEM A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_42 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'SCM_MST_SITE_ITEM' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM SCM_MST_SITE_ITEM A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM SCM_MST_SITE_ITEM A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- SCM_MST_SITE_ITEM_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_43
    		FROM SCM_MST_SITE_ITEM_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_43 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'SCM_MST_SITE_ITEM_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM SCM_MST_SITE_ITEM_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM SCM_MST_SITE_ITEM_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- SCM_MST_SITE_ITEM_PRIORITY UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_44
    		FROM SCM_MST_SITE_ITEM_PRIORITY A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_44 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'SCM_MST_SITE_ITEM_PRIORITY' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM SCM_MST_SITE_ITEM_PRIORITY A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM SCM_MST_SITE_ITEM_PRIORITY A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		-- SCM_MST_SITE_ITEM_PRIORITY_H UPDATE
    		SELECT COUNT(1)
    		INTO v_cnt_45
    		FROM SCM_MST_SITE_ITEM_PRIORITY_H A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    		IF v_cnt_45 > 0 THEN
    				INSERT INTO GT_DMF0_results_insert (;
    							  ITEM_ID_BEFORE
    							, ITEM_ID_AFTER
    							, TABLE_NAME
    							, ITEM_COUNT
    							, CREATED_BY
    							)
    				SELECT B.ITEM_ID_BEFORE
    					 , B.ITEM_ID_AFTER
    					 , 'SCM_MST_SITE_ITEM_PRIORITY_H' AS TABLE_NAME
    					 , COUNT(*)
    					 , B.LAST_UPDATED_BY
    				FROM SCM_MST_SITE_ITEM_PRIORITY_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40'
    				GROUP BY B.ITEM_ID_BEFORE, B.ITEM_ID_AFTER, B.LAST_UPDATED_BY;
    
    				UPDATE A
    				SET ITEM_ID = B.ITEM_ID_AFTER
    					,LAST_UPDATED_BY = B.LAST_UPDATED_BY
    					,LAST_UPDATE_DATE = SYSDATE
    				FROM SCM_MST_SITE_ITEM_PRIORITY_H A
    				JOIN GT_DMF0_results_MST B ON A.ITEM_ID = B.ITEM_ID_BEFORE
    				WHERE A.DIVISION_ID = '40';
    		END IF;
    
    		INSERT INTO DM_DNM_ITEM_CODE_CHANGE_HISTORY
    			 ( BEFORE_CODE, AFTER_CODE, DATA_SEQ, TABLE_NAME, ROW_COUNT
    			 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
    			 , ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
    			 , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
    		SELECT DISTINCT A.ITEM_ID_BEFORE, A.ITEM_ID_AFTER
    			 , B.DATA_SEQ
    			 , A.TABLE_NAME, A.ITEM_COUNT
    			 , A.CREATED_BY, SYSDATE, A.CREATED_BY, SYSDATE, NULL
    			 , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    		FROM GT_DMF0_results_insert A
    		JOIN GT_DMF0_results_MST B ON A.ITEM_ID_BEFORE = B.ITEM_ID_BEFORE AND A.ITEM_ID_AFTER = B.ITEM_ID_AFTER
    
    	END;
    
    
    	-- END TRY
    
    	EXCEPTION
    	    WHEN OTHERS THEN
    
    
    		-- ERROR LOG
    		v_log_type := 'ERROR';
    		v_log_message := CAST(SQLERRM AS VARCHAR2(1000 CHAR));
    		v_description := 'ERROR_LINE : '  ||  STR(NULL);
    		d_event_date := SYSTIMESTAMP;
    
    		PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    		SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM
    		FROM DUAL;
    
        -- END CATCH
    
    	-- 수행결과 성공여부 DISPLAY
         IF v_log_message IS NULL THEN
    	  SELECT 'success'
    
    	IF  v_log_type not in ('INVALID','ERROR') THEN
    			-- 종료 LOG
    			v_log_type := 'END';
    			v_log_message := '########## END of procedure ##########';
    			d_event_date := SYSTIMESTAMP;
    			PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    		END IF;
    
    	-- INVALID 인경우 ROLLBACK 처리
    	ERR_RTN:
    		IF  v_log_type = 'INVALID' THEN
    				SELECT 'INVALID'
    								-- 종료 LOG
    				v_log_message := '########## END of procedure ##########';
    				d_event_date := SYSTIMESTAMP;
    				PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    				-- [C20210323-000363]
    				PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, 'END', n_log_count, v_log_message, v_description, d_event_date);
    				FROM DUAL;
    			END IF;

    END PKG_DMF0005;
/
