/*=============================================================================================
 * File         : 04_Package_PKG_DMF0004.sql
 * Description  : Package — PKG_DMF0004
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
 *   - v_program_name 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0004 IS
/*
 * Program ID   : PKG_DMF0003
 * Description  : PKG_DMF0003
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.09   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */


    PROCEDURE P_DMF0004_GET_SALES_SITE_DATA(
        P_DIVISION_ID        IN VARCHAR2,

        P_END_CUSTOMER       IN VARCHAR2,
        P_SCM_SITE_ID        IN VARCHAR2,
        P_ACTIVE_FLAG        IN VARCHAR2,
        P_SOLDTO_CUSTOMER    IN VARCHAR2,
        P_USER_ID            IN VARCHAR2,
        P_MENU_ID            IN VARCHAR2,

        o_rc1                OUT SYS_REFCURSOR,
        O_RESULT_CURSOR    OUT SYS_REFCURSOR
    );
 
    PROCEDURE P_DMF0004_SAVE_SALES_SITE_DATA(

      P_DATA      IN  CLOB,
      P_USER_ID   IN  VARCHAR2,
      O_RESULT_CURSOR    OUT SYS_REFCURSOR
    );
    
   PROCEDURE P_DMF0004_GET_SALES_SITE_DETAIL_DATA(
  		P_DIVISION_ID IN VARCHAR2,
  		P_SCM_SITE_ID IN VARCHAR2,
  		P_ACTIVE_FLAG IN VARCHAR2,
  		P_USER_ID IN VARCHAR2,
  		o_rc1 OUT SYS_REFCURSOR,
  		o_rc2 OUT SYS_REFCURSOR,
  		o_rc3 OUT SYS_REFCURSOR,
      O_RESULT_CURSOR    OUT SYS_REFCURSOR
   );
     
  PROCEDURE P_DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA (
      P_DATA      IN  CLOB,
      P_USER_ID   IN  VARCHAR2,
      O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );
    
  PROCEDURE P_DMF0004_SAVE_SALES_SITE_LOCATION_DATA (
        P_DATA      IN  CLOB
      , P_USER_ID   IN  VARCHAR2
      , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );
  
  PROCEDURE P_DMF0004_SAVE_SALES_SITE_BUCKET_DATA (
        P_DATA      IN  CLOB
      , P_USER_ID   IN  VARCHAR2
      , O_RESULT_CURSOR    OUT SYS_REFCURSOR
  );

END PKG_DMF0004;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0004 IS
PROCEDURE P_DMF0004_GET_SALES_SITE_DATA(
        P_DIVISION_ID        IN VARCHAR2,

        P_END_CUSTOMER       IN VARCHAR2,
        P_SCM_SITE_ID        IN VARCHAR2,
        P_ACTIVE_FLAG        IN VARCHAR2,
        P_SOLDTO_CUSTOMER    IN VARCHAR2,
        P_USER_ID            IN VARCHAR2,
        P_MENU_ID            IN VARCHAR2,
        
        o_rc1                OUT SYS_REFCURSOR,
        O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
/*
 * Program ID   : P_DMF0004_GET_SALES_SITE_DATA
 * Description  : P_DMF0004_GET_SALES_SITE_DATA
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.09   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

IS

    V_GROUP_ID VARCHAR2(50) := '';
    
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT	      NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    
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
     
    OPEN o_rc1 FOR 
    
    SELECT S.DIVISION_ID,
           CASE WHEN S.DIVISION_ID = '40' THEN 'acer' ELSE S.END_CUSTOMER END AS END_CUSTOMER,
           S.SOLDTO_CUSTOMER,
           C.SOLDTO_CODE AS REP_SOLDTO_CODE,
           C.SHIPTO_CODE AS REP_SHIPTO_CODE,
           S.COUNTRY,
           CO.COUNTRY_NAME,
           S.CITY,
           CT.CITY_NAME,
           S.SCM_SITE_ID,
           S.COMPANY_ID,
           S.SITE_DESCRIPTION,
           S.ATTRIBUTE3 AS DISTRIBUTION_CHANNEL,
           S.VMI_YN,
           S.VALID_YN,
           S.LAST_UPDATED_BY,
           S.LAST_UPDATE_DATE,
           S.ATTRIBUTE2 AS SHIP_PLAN_AUTO,
           S.ATTRIBUTE5           
         , CASE WHEN V_GROUP_ID = 'ADMIN'
                THEN 'Y' ELSE '' END AS EDIT_FLAG
          FROM SCM_MST_SITE S
          , SCM_MST_SITE_CUSTOMER C
          , SCM_MST_COUNTRY CO
          , SCM_MST_CITY CT
         WHERE S.SITE_TYPE = 'SALES'
         AND S.DIVISION_ID = P_DIVISION_ID
         AND S.DIVISION_ID = C.DIVISION_ID(+)
         AND S.SCM_SITE_ID = C.SCM_SITE_ID(+)
         AND C.REP_YN(+) = 'Y'
         AND C.VALID_YN(+) = 'Y'
         AND S.COUNTRY = CO.COUNTRY(+)
         AND S.COUNTRY = CT.COUNTRY(+)
         AND S.CITY = CT.CITY(+)
         AND (P_END_CUSTOMER = 'ALL' OR S.END_CUSTOMER IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_END_CUSTOMER, ','))))
         AND (P_SCM_SITE_ID = 'ALL' OR S.SCM_SITE_ID IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_SCM_SITE_ID, ','))))
         AND (P_ACTIVE_FLAG = 'ALL' OR S.VALID_YN IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_ACTIVE_FLAG, ','))))
         AND (P_SOLDTO_CUSTOMER = 'ALL' OR S.SOLDTO_CUSTOMER IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_SOLDTO_CUSTOMER, ','))))
        
     ORDER BY S.DIVISION_ID, S.SCM_SITE_ID
     ;
     
     V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

     OPEN O_RESULT_CURSOR FOR
          SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION

    WHEN OTHERS THEN
        ROLLBACK;
        
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_ERR_MSG    := SQLERRM;
        
        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_ERR_MSG ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );
        

END P_DMF0004_GET_SALES_SITE_DATA;

PROCEDURE P_DMF0004_SAVE_SALES_SITE_DATA (
    P_DATA      IN  CLOB,
    P_USER_ID   IN  VARCHAR2,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT	      NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);

    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
    BEGIN
        V_ERR_MSG     := P_MSG;
        RAISE EX_BIZ_EX;
    END;
BEGIN

    FOR R IN (
        SELECT
              TRIM(JT.CRUD_TYPE)                       AS CRUD_TYPE
            , TRIM(JT.DIVISION_ID)                     AS DIVISION_ID
            , TRIM(JT.SCM_SITE_ID)                     AS SCM_SITE_ID

            , (CASE WHEN TRIM(JT.DIVISION_ID) = '40' THEN '-' ELSE TRIM(JT.END_CUSTOMER) END) AS END_CUSTOMER
            , TRIM(JT.SOLDTO_CUSTOMER)                   AS SOLDTO_CUSTOMER
            , TRIM(JT.CITY)                            AS CITY
            , TRIM(JT.COUNTRY)                         AS COUNTRY

            , NVL(TRIM(JT.VMI_YN), '')                AS VMI_YN
            , NVL(TRIM(JT.VALID_YN), 'Y')              AS VALID_YN
            /* If sesUserId is null, fallback to LAST_UPDATED_BY from JSON payload. */
            , P_USER_ID                                AS USER_ID
            , TRIM(JT.COMPANY_ID)                      AS COMPANY_ID
            , TRIM(JT.SHIP_PLAN_AUTO)                  AS SHIP_PLAN_AUTO


        FROM JSON_TABLE(
            P_DATA,
            '$[*]'
            COLUMNS (
                  CRUD_TYPE           VARCHAR2(10)     PATH '$."CRUD_TYPE"' NULL ON EMPTY NULL ON ERROR
                , DIVISION_ID           VARCHAR2(50)   PATH '$."DIVISION_ID"' NULL ON EMPTY NULL ON ERROR
                , SCM_SITE_ID           VARCHAR2(100)  PATH '$."SCM_SITE_ID"' NULL ON EMPTY NULL ON ERROR

                , END_CUSTOMER          VARCHAR2(200)  PATH '$."END_CUSTOMER"' NULL ON EMPTY NULL ON ERROR
                , SOLDTO_CUSTOMER         VARCHAR2(200)  PATH '$."SOLDTO_CUSTOMER"' NULL ON EMPTY NULL ON ERROR
                , CITY                  VARCHAR2(200)  PATH '$."CITY"' NULL ON EMPTY NULL ON ERROR
                , COUNTRY               VARCHAR2(200)  PATH '$."COUNTRY"' NULL ON EMPTY NULL ON ERROR

                , VMI_YN                VARCHAR2(1)    PATH '$."VMI_YN"' NULL ON EMPTY NULL ON ERROR
                , VALID_YN              VARCHAR2(1)    PATH '$."VALID_YN"' NULL ON EMPTY NULL ON ERROR


                , COMPANY_ID            VARCHAR2(100)  PATH '$."COMPANY_ID"' NULL ON EMPTY NULL ON ERROR
                , SHIP_PLAN_AUTO        VARCHAR2(10)   PATH '$."SHIP_PLAN_AUTO"' NULL ON EMPTY NULL ON ERROR


            )
        ) JT
    ) LOOP
    /*
        IF R.DIVISION_ID IS NULL
           OR R.SCM_SITE_ID IS NULL
           OR R.END_CUSTOMER IS NULL
           OR R.SOLDTO_CUSTOMER IS NULL
           OR R.CITY IS NULL
           OR R.COUNTRY IS NULL
           OR R.SHIP_PLAN_AUTO IS NULL THEN
            RAISE_INVALID('Please check required input values.');
        END IF;
*/
        IF R.DIVISION_ID IS NULL THEN
            RAISE_INVALID('DIVISION_ID IS NULL');
        END IF;

        IF R.SCM_SITE_ID IS NULL THEN
            RAISE_INVALID('SCM_SITE_ID IS NULL');
        END IF;

        IF R.END_CUSTOMER IS NULL THEN
            RAISE_INVALID('END_CUSTOMER IS NULL');
        END IF;

        IF R.SOLDTO_CUSTOMER IS NULL THEN
            RAISE_INVALID('SOLDTO_CUSTOMER IS NULL');
        END IF;

        IF R.CITY IS NULL THEN
            RAISE_INVALID('CITY IS NULL');
        END IF;

        IF R.COUNTRY IS NULL THEN
            RAISE_INVALID('COUNTRY IS NULL');
        END IF;

        IF R.SHIP_PLAN_AUTO IS NULL THEN
            RAISE_INVALID('SHIP_PLAN_AUTO IS NULL');
        END IF;

        IF R.USER_ID IS NULL THEN
            RAISE_INVALID('사용자 ID는 필수입니다.');
        END IF;
          
        IF R.COMPANY_ID IS NULL THEN
            RAISE_INVALID('COMPANY_ID는 필수입니다.');
        END IF;

        IF R.VALID_YN = '' AND R.DIVISION_ID = '40' THEN
            DECLARE
                V_CNT NUMBER;
            BEGIN
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM (
                        SELECT 1
                          FROM DM_PLN_SALES_PLAN
                         WHERE DIVISION_ID = R.DIVISION_ID
                           AND SCM_SITE_ID = R.SCM_SITE_ID
                           AND QTY <> 0
                           AND ROWNUM = 1
                        UNION ALL
                        SELECT 1
                          FROM DM_PLN_SALES_PLAN_RESULT
                         WHERE DIVISION_ID = R.DIVISION_ID
                           AND SCM_SITE_ID = R.SCM_SITE_ID
                           AND QTY <> 0
                           AND ROWNUM = 1
                  );
                IF V_CNT > 0 THEN
                    RAISE_INVALID('Sales Plan 데이터가 있어 Active=''''으로 변경할 수 없습니다. Sales Site: ' || R.SCM_SITE_ID);
                END IF;
            END;
        END IF;
/*
        IF R.DIVISION_ID NOT IN ('40', '42', '44') THEN
            DECLARE
                V_CNT NUMBER;
            BEGIN
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM SCM_MST_SSO_DEPT_INFO
                 WHERE VALID_YN = 'Y'
                   AND DEPT_ID = R.DEPT_ID;
                IF V_CNT = 0 THEN
                    RAISE_INVALID('Input value: [' || R.DEPT_ID || '] Please select Team ID from the popup.');
                END IF;
            END;
        END IF;
*/
        IF R.CRUD_TYPE = 'I' THEN
            DECLARE
                V_CNT NUMBER;
            BEGIN
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM SCM_MST_SITE
                 WHERE DIVISION_ID = R.DIVISION_ID
                   AND SCM_SITE_ID = R.SCM_SITE_ID;
                IF V_CNT > 0 THEN
                    RAISE_INVALID('이미 존재하는 Site입니다. [' || R.SCM_SITE_ID || ']');
                END IF;
            END;
        END IF;

        IF R.CRUD_TYPE = 'M' AND R.VALID_YN = '' THEN
            UPDATE SCM_MST_SITE_CUSTOMER
               SET VALID_YN         = ''
                 , REP_YN           = ''
                 , LAST_UPDATED_BY  = R.USER_ID
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID = R.DIVISION_ID
               AND SCM_SITE_ID = R.SCM_SITE_ID;
/*
            PR_DM_MST_SITE_CUSTOMER_HIST(
                R.DIVISION_ID,
                R.SCM_SITE_ID,
                'ALL',
                'ALL',
                '',
                R.USER_ID,
                R.VALID_YN
            );*/
        END IF;
/*
        PR_DM_MST_SITE_HIST(
             R.DIVISION_ID
            ,R.SCM_SITE_ID
            ,R.SITE_DESCRIPTION
            ,'SALES'
            ,R.CITY
            ,R.COUNTRY
            ,' '
            ,NULL
            ,' '
            ,R.VMI_YN
            ,R.VALID_YN
            ,'Y'
            ,NULL
            ,NULL
            ,NULL
            ,NULL
            ,R.END_CUSTOMER
            ,R.SOLDTO_CUSTOMER
            ,NULL
            ,NULL
            ,NULL
            ,R.COMPANY_ID
            ,NULL
            ,R.USER_ID
            ,R.USER_ID
            ,''
            ,R.SHIP_PLAN_AUTO
            ,R.DISTRIBUTION_CHANNEL
            ,R.ATTRIBUTE5
        );
*/
                UPDATE SCM_MST_SITE
                     SET VMI_YN = R.VMI_YN
                         , VALID_YN = R.VALID_YN
                         , COMPANY_ID = R.COMPANY_ID
                         , LAST_UPDATED_BY = R.USER_ID
                         , LAST_UPDATE_DATE = SYSDATE
                         , ATTRIBUTE2 = R.SHIP_PLAN_AUTO
                 WHERE DIVISION_ID = R.DIVISION_ID
                     AND SCM_SITE_ID = R.SCM_SITE_ID;

                IF SQL%ROWCOUNT = 0 THEN
                        INSERT INTO SCM_MST_SITE (
                                    DIVISION_ID
                                , SCM_SITE_ID
                                , SITE_DESCRIPTION
                                , SITE_TYPE
                                , END_CUSTOMER
                                , SOLDTO_CUSTOMER
                                , CITY
                                , COUNTRY
                                , VMI_YN
                                , VALID_YN
                                , NEW_YN
                                , COMPANY_ID
                                , CREATED_BY
                                , CREATION_DATE
                                , LAST_UPDATED_BY
                                , LAST_UPDATE_DATE
                                , ATTRIBUTE2
                        )
                        VALUES (
                                    R.DIVISION_ID
                                , R.SCM_SITE_ID
                                , R.SCM_SITE_ID
                                , 'SALES'
                                , R.END_CUSTOMER
                                , R.SOLDTO_CUSTOMER
                                , R.CITY
                                , R.COUNTRY
                                , R.VMI_YN
                                , R.VALID_YN
                                , 'Y'
                                , R.COMPANY_ID
                                , R.USER_ID
                                , SYSDATE
                                , R.USER_ID
                                , SYSDATE
                                , R.SHIP_PLAN_AUTO
                        );
                END IF;

                V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
    END LOOP;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;

        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    WHEN OTHERS THEN
        ROLLBACK;
        
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_ERR_MSG    := SQLERRM;
        
        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_ERR_MSG ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );
        

END P_DMF0004_SAVE_SALES_SITE_DATA;


PROCEDURE P_DMF0004_GET_SALES_SITE_DETAIL_DATA (
    P_DIVISION_ID   IN VARCHAR2,
    P_SCM_SITE_ID   IN VARCHAR2,
    P_ACTIVE_FLAG   IN VARCHAR2,
    P_USER_ID    IN VARCHAR2,
    o_rc1           OUT SYS_REFCURSOR,
    o_rc2           OUT SYS_REFCURSOR,
    o_rc3           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
IS
    V_GROUP_ID VARCHAR2(50) := '';
    
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT	      NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    
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
     
    
    /* 1) CUSTOMER */
    OPEN o_rc1 FOR
        SELECT
            S.DIVISION_ID,
            S.SCM_SITE_ID,
            S.SOLDTO_CODE,
            C.SOLDTO_DESCRIPTION,
            S.SHIPTO_CODE,
            C.SHIPTO_DESCRIPTION,
            C.SHIPTO_REGION_NAME,
            C.SHIPTO_CITY_NAME,
            S.REP_YN,
            S.VALID_YN,
            S.LAST_UPDATE_DATE,
            S.LAST_UPDATED_BY
         , CASE WHEN V_GROUP_ID = 'ADMIN' THEN 'Y' ELSE '' END AS EDIT_FLAG
                FROM SCM_MST_SITE_CUSTOMER S
                     , SCM_MST_CUSTOMER C
                     , SCM_MST_SITE ST
        WHERE S.DIVISION_ID = P_DIVISION_ID
                    AND C.DIVISION_ID(+) = S.DIVISION_ID
                    AND C.SOLDTO_CODE(+) = S.SOLDTO_CODE
                    AND C.SHIPTO_CODE(+) = S.SHIPTO_CODE
                    AND ST.DIVISION_ID = S.DIVISION_ID
                    AND ST.SCM_SITE_ID = S.SCM_SITE_ID
          AND S.SCM_SITE_ID = P_SCM_SITE_ID
          /*AND (
                P_ACTIVE_FLAG IS NULL
                OR P_ACTIVE_FLAG = 'ALL'
                OR TRIM(P_ACTIVE_FLAG) = ''
                OR S.VALID_YN = P_ACTIVE_FLAG
              )*/;
     V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    /* 2) LOCATION */
    OPEN o_rc2 FOR
        SELECT
            L.LOCATION_SEQ,
            L.DIVISION_ID,
            D.DIVISION_NAME,
            L.SCM_SITE_ID,
            L.LOCATION_CODE,
            (
                SELECT MAX(SLOC.STORAGE_DESCRIPTION)
                FROM SCM_MST_SLOC SLOC
                WHERE SLOC.DIVISION_ID = L.DIVISION_ID
                  AND SLOC.STORAGE_ID = L.STORAGE_ID
                  AND SLOC.PLANT_ID = L.PLANT_ID
            ) AS LOCATION_DESCRIPTION,
            L.STORAGE_ID,
            L.PLANT_ID,
            L.VALID_YN,
            L.LAST_UPDATED_BY,
            L.LAST_UPDATE_DATE
            , CASE WHEN V_GROUP_ID = 'ADMIN' THEN 'Y' ELSE '' END AS EDIT_FLAG
        FROM SCM_MST_LOCATION L
        INNER JOIN SCM_MST_DIVISION D
                ON D.DIVISION_ID = L.DIVISION_ID
        INNER JOIN SCM_MST_SITE ST
                ON ST.DIVISION_ID = L.DIVISION_ID
               AND ST.SCM_SITE_ID = L.SCM_SITE_ID
        WHERE L.DIVISION_ID = P_DIVISION_ID
          AND UPPER(L.SCM_SITE_ID) = UPPER(P_SCM_SITE_ID)
          /*AND (
                P_ACTIVE_FLAG IS NULL
                OR P_ACTIVE_FLAG = 'ALL'
                OR TRIM(P_ACTIVE_FLAG) = ''
                OR L.VALID_YN = P_ACTIVE_FLAG
              )*/;
     V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    /* 3) BUCKET */
    OPEN o_rc3 FOR
        SELECT
            MA.DIVISION_ID,
            MA.SCM_SITE_ID,
            MA.INCOTERMS,
            MA.D_MON,
            MA.D_TUE,
            MA.D_WED,
            MA.D_THU,
            MA.D_FRI,
            MA.D_SAT,
            MA.D_SUN,
            MA.LAST_UPDATE_DATE,
            MA.LAST_UPDATED_BY
            , CASE WHEN V_GROUP_ID = 'ADMIN' THEN 'Y' ELSE '' END AS EDIT_FLAG
        FROM (
            SELECT
                B.DIVISION_ID,
                B.SCM_SITE_ID,
                B.INCOTERMS,
                MAX(CASE WHEN B.YYYYMMDD = 'MON' THEN B.BUCKET_PER END) AS D_MON,
                MAX(CASE WHEN B.YYYYMMDD = 'TUE' THEN B.BUCKET_PER END) AS D_TUE,
                MAX(CASE WHEN B.YYYYMMDD = 'WED' THEN B.BUCKET_PER END) AS D_WED,
                MAX(CASE WHEN B.YYYYMMDD = 'THU' THEN B.BUCKET_PER END) AS D_THU,
                MAX(CASE WHEN B.YYYYMMDD = 'FRI' THEN B.BUCKET_PER END) AS D_FRI,
                MAX(CASE WHEN B.YYYYMMDD = 'SAT' THEN B.BUCKET_PER END) AS D_SAT,
                MAX(CASE WHEN B.YYYYMMDD = 'SUN' THEN B.BUCKET_PER END) AS D_SUN,
                MAX(B.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE,
                MAX(B.LAST_UPDATED_BY)  AS LAST_UPDATED_BY
            FROM DM_MST_BUCKET_CONVERSION B
            WHERE B.CONVERSION_TYPE = 'WTOD'
              AND B.DIVISION_ID = P_DIVISION_ID
              AND B.SCM_SITE_ID = P_SCM_SITE_ID
            GROUP BY
                B.DIVISION_ID,
                B.SCM_SITE_ID,
                B.INCOTERMS
        ) MA
        INNER JOIN SCM_MST_SITE ST
                ON ST.DIVISION_ID = MA.DIVISION_ID
               AND ST.SCM_SITE_ID = MA.SCM_SITE_ID;
              
     V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

     OPEN O_RESULT_CURSOR FOR
          SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

        
EXCEPTION

    WHEN OTHERS THEN
        ROLLBACK;
        
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_ERR_MSG    := SQLERRM;
        
        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_ERR_MSG ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );
        
        
END P_DMF0004_GET_SALES_SITE_DETAIL_DATA;




PROCEDURE P_DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA (
    P_DATA      IN  CLOB,
    P_USER_ID   IN  VARCHAR2,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT	      NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);

    V_DUP_SCM_SITE_ID VARCHAR2(200);

    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
    BEGIN
        V_ERR_MSG     := P_MSG;
        RAISE EX_BIZ_EX;
    END;
BEGIN

    FOR R IN (
        SELECT
              TRIM(JT.CRUD_TYPE)         AS CRUD_TYPE
            , TRIM(JT.DIVISION_ID)         AS DIVISION_ID
            , TRIM(JT.SCM_SITE_ID)         AS SCM_SITE_ID
            , TRIM(JT.SOLDTO_CODE)         AS SOLDTO_CODE

            , TRIM(JT.SHIPTO_CODE)         AS SHIPTO_CODE

            , TRIM(JT.REP_YN)              AS REP_YN
            , NVL(TRIM(JT.VALID_YN), 'Y')  AS VALID_YN
            , P_USER_ID                    AS CREATED_BY
        FROM JSON_TABLE(
            P_DATA,
            '$[*]'
            COLUMNS (
                  CRUD_TYPE          VARCHAR2(20)   PATH '$."CRUD_TYPE"'
                , DIVISION_ID          VARCHAR2(50)   PATH '$."DIVISION_ID"'
                , SCM_SITE_ID          VARCHAR2(100)  PATH '$."SCM_SITE_ID"'
                , SOLDTO_CODE          VARCHAR2(100)  PATH '$."SOLDTO_CODE"'

                , SHIPTO_CODE          VARCHAR2(100)  PATH '$."SHIPTO_CODE"'

                , REP_YN               VARCHAR2(1)    PATH '$."REP_YN"'
                , VALID_YN             VARCHAR2(1)    PATH '$."VALID_YN"'

            )
        ) JT
    ) LOOP
        /* HISTORY INSERT (요청 기능 반영) */
        /*PR_DM_MST_SITE_CUSTOMER_HIST(
            R.DIVISION_ID,
            R.SCM_SITE_ID,
            R.SOLDTO_CODE,
            R.SHIPTO_CODE,
            R.REP_YN,
            R.CREATED_BY,
            R.VALID_YN
        );*/

        /* 필수값 검증 */
        IF R.DIVISION_ID IS NULL OR R.SCM_SITE_ID IS NULL OR R.SOLDTO_CODE IS NULL
           OR R.SHIPTO_CODE IS NULL OR R.REP_YN IS NULL
           OR R.DIVISION_ID = '' OR R.SCM_SITE_ID = '' OR R.SOLDTO_CODE = ''
           OR R.SHIPTO_CODE = '' OR R.REP_YN = '' THEN
            RAISE_INVALID('입력값을 확인하세요.');
        END IF;

        /* SOLDTO/SHIPTO 유효성 검증 */
        DECLARE
            V_CNT NUMBER;
        BEGIN
            SELECT COUNT(*)
              INTO V_CNT
              FROM SCM_MST_CUSTOMER
             WHERE DIVISION_ID = R.DIVISION_ID
               AND SHIPTO_CODE = R.SHIPTO_CODE
               AND SOLDTO_CODE = R.SOLDTO_CODE;

            IF V_CNT = 0 THEN
                RAISE_INVALID('Invalid soldto - shipto mapping' || CHR(10) ||
                              'Ship-To Code: ' || TRIM(R.SHIPTO_CODE) || CHR(10) ||
                              'Sold-To Code: ' || TRIM(R.SOLDTO_CODE));
            END IF;

            SELECT COUNT(*)
              INTO V_CNT
              FROM SCM_MST_CUSTOMER
             WHERE DIVISION_ID = R.DIVISION_ID
               AND SHIPTO_CODE = R.SHIPTO_CODE
               AND SOLDTO_CODE = R.SOLDTO_CODE
               AND VALID_YN = ''
               AND R.VALID_YN = 'Y';

            IF V_CNT > 0 THEN
                RAISE_INVALID('MDM에서 사용 중지되었습니다.' || CHR(10) ||
                              'Ship-To Code: ' || TRIM(R.SHIPTO_CODE) || CHR(10) ||
                              'Sold-To Code: ' || TRIM(R.SOLDTO_CODE));
            END IF;
        END;

        /* REP_YN='Y' 인 경우 대표코드 사용 불가 여부 확인 (NERP_CONV_MASTER 체크) */
        
        IF R.REP_YN = 'Y' THEN
            DECLARE
                V_CNT NUMBER;
            BEGIN
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM (
                        SELECT A.SHIPTO_CODE, A.SOLDTO_CODE
                          FROM SCM_MST_CUSTOMER A
                         WHERE A.DIVISION_ID = R.DIVISION_ID
                           AND A.SHIPTO_CODE = R.SHIPTO_CODE
                           AND A.SOLDTO_CODE = R.SOLDTO_CODE
                       ) A
                  JOIN (
                        SELECT OLD_VALUE1
                          FROM NERP_CONV_MASTER
                         WHERE CODETYPE = 'END_CUSTOMER_ID'
                       ) B
                    ON (A.SOLDTO_CODE = B.OLD_VALUE1 OR A.SHIPTO_CODE = B.OLD_VALUE1);

                IF V_CNT > 0 THEN
                    RAISE_INVALID('구버전 soldto_code를 대표코드로 선택할 수 없습니다.');
                END IF;
            END;
        END IF;

        /* 존재하면 UPDATE, 없으면 INSERT */
        DECLARE
            V_EXISTS NUMBER;
            V_CNT    NUMBER;
        BEGIN
            SELECT COUNT(*)
              INTO V_EXISTS
              FROM SCM_MST_SITE_CUSTOMER A
              JOIN SCM_MST_SITE C
                ON C.DIVISION_ID = A.DIVISION_ID
               AND C.SCM_SITE_ID = A.SCM_SITE_ID
             WHERE A.DIVISION_ID = R.DIVISION_ID
               AND A.SCM_SITE_ID = R.SCM_SITE_ID
               AND A.SOLDTO_CODE = R.SOLDTO_CODE
               AND A.SHIPTO_CODE = R.SHIPTO_CODE
               AND C.SITE_TYPE = 'SALES';

            IF V_EXISTS > 0 THEN
                IF R.REP_YN = 'Y' THEN
                    UPDATE SCM_MST_SITE_CUSTOMER
                       SET REP_YN = ''
                     WHERE DIVISION_ID = R.DIVISION_ID
                       AND SCM_SITE_ID = R.SCM_SITE_ID;
                END IF;

                UPDATE SCM_MST_SITE_CUSTOMER
                   SET REP_YN           = R.REP_YN
                     , VALID_YN         = R.VALID_YN
                     , LAST_UPDATED_BY  = R.CREATED_BY
                     , LAST_UPDATE_DATE = SYSDATE
                 WHERE DIVISION_ID = R.DIVISION_ID
                   AND SCM_SITE_ID = R.SCM_SITE_ID
                   AND SOLDTO_CODE = R.SOLDTO_CODE
                   AND SHIPTO_CODE = R.SHIPTO_CODE;
                   
                   
                   V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
                   
            ELSE
                /* 신규 INSERT 시 국가코드 검증 */
                IF LENGTH(R.SHIPTO_CODE) > 4 THEN
                    SELECT COUNT(*)
                      INTO V_CNT
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE = 'SALES_SITE_ID_ADDTION'
                       AND SEGMENT1 = R.SCM_SITE_ID
                       AND VALID_YN = 'Y';

                    IF V_CNT = 0 THEN
                        SELECT COUNT(*)
                          INTO V_CNT
                          FROM SCM_MST_SITE
                         WHERE DIVISION_ID = R.DIVISION_ID
                           AND SCM_SITE_ID = R.SCM_SITE_ID
                           AND COUNTRY = SUBSTR(R.SHIPTO_CODE, 1, 2)
                           AND VALID_YN = 'Y';

                        IF V_CNT = 0 THEN
                            RAISE_INVALID('Sales Site의 국가와 등록하려는 Shipto Code의 국가 코드가 다릅니다.' || CHR(10) ||
                                          'Div : ' || TRIM(R.DIVISION_ID) || CHR(10) ||
                                          'Sales Site : ' || TRIM(R.SCM_SITE_ID) || CHR(10) ||
                                          'Shipto Code : ' || TRIM(R.SHIPTO_CODE));
                        END IF;
                    END IF;
                END IF;

                INSERT INTO SCM_MST_SITE_CUSTOMER (
                      DIVISION_ID, SCM_SITE_ID, SOLDTO_CODE, SHIPTO_CODE
                    , REP_YN, VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                ) VALUES (
                      R.DIVISION_ID, R.SCM_SITE_ID, R.SOLDTO_CODE, R.SHIPTO_CODE
                    , R.REP_YN, R.VALID_YN, R.CREATED_BY, SYSDATE, R.CREATED_BY, SYSDATE
                );
                V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
                
            END IF;
        END;

        /* 중복 SHIPTO/SOLDTO(VALID_YN='Y') 검증 */
        IF R.VALID_YN = 'Y' THEN
            DECLARE
                V_CNT NUMBER;
            BEGIN
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM (
                        SELECT A.DIVISION_ID, A.SHIPTO_CODE, A.SOLDTO_CODE
                          FROM SCM_MST_SITE_CUSTOMER A
                          JOIN SCM_MST_SITE C
                            ON C.DIVISION_ID = A.DIVISION_ID
                           AND C.SCM_SITE_ID = A.SCM_SITE_ID
                         WHERE A.DIVISION_ID = R.DIVISION_ID
                           AND A.SHIPTO_CODE = R.SHIPTO_CODE
                           AND A.SOLDTO_CODE = R.SOLDTO_CODE
                           AND A.VALID_YN = 'Y'
                           AND C.SITE_TYPE = 'SALES'
                         GROUP BY A.DIVISION_ID, A.SHIPTO_CODE, A.SOLDTO_CODE
                        HAVING COUNT(*) > 1
                  );

                IF V_CNT > 0 THEN
                    SELECT A.SCM_SITE_ID
                      INTO V_DUP_SCM_SITE_ID
                      FROM SCM_MST_SITE_CUSTOMER A
                      JOIN SCM_MST_SITE C
                        ON C.DIVISION_ID = A.DIVISION_ID
                       AND C.SCM_SITE_ID = A.SCM_SITE_ID
                     WHERE A.DIVISION_ID = R.DIVISION_ID
                       AND A.SHIPTO_CODE = R.SHIPTO_CODE
                       AND A.SOLDTO_CODE = R.SOLDTO_CODE
                       AND A.SCM_SITE_ID <> R.SCM_SITE_ID
                       AND A.VALID_YN = 'Y'
                       AND C.SITE_TYPE = 'SALES'
                       AND ROWNUM = 1;

                    RAISE_INVALID(V_DUP_SCM_SITE_ID || ' Sales Site 에서 '
                                  || R.SHIPTO_CODE || 'Ship-To Code가 이미 사용중입니다.');
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
        END IF;

        /* REP_YN 중복 검증 */
        DECLARE
            V_CNT NUMBER;
        BEGIN
            SELECT COUNT(*)
              INTO V_CNT
              FROM (
                    SELECT A.DIVISION_ID, A.SCM_SITE_ID
                      FROM SCM_MST_SITE_CUSTOMER A
                      JOIN SCM_MST_SITE C
                        ON C.DIVISION_ID = A.DIVISION_ID
                       AND C.SCM_SITE_ID = A.SCM_SITE_ID
                     WHERE A.DIVISION_ID = R.DIVISION_ID
                       AND A.SCM_SITE_ID = R.SCM_SITE_ID
                       AND A.REP_YN = 'Y'
                       AND C.SITE_TYPE = 'SALES'
                     GROUP BY A.DIVISION_ID, A.SCM_SITE_ID
                    HAVING COUNT(*) > 1
              );

            IF V_CNT > 0 THEN
                RAISE_INVALID(V_DUP_SCM_SITE_ID ||' Sales Site 에서 Rep값 설정이 중복되었습니다.');
            END IF;
        END;

        /* 일반 SALES SITE의 SOLD-TO 건수 제한 검증(예외 LOOKUP 제외, NERP 신규코드 제외) */
        DECLARE
            V_ALLOW_MULTI NUMBER;
            V_ROWNUM_MAX  NUMBER;
        BEGIN
            SELECT COUNT(*)
              INTO V_ALLOW_MULTI
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
             WHERE LOOKUP_TYPE = 'SALES_SITE_ID_ADDTION'
               AND SEGMENT1 = R.SCM_SITE_ID
               AND VALID_YN = 'Y';

            IF V_ALLOW_MULTI = 0 THEN
                SELECT NVL(MAX(RN), 0)
                  INTO V_ROWNUM_MAX
                  FROM (
                        SELECT ROW_NUMBER() OVER (ORDER BY A.DIVISION_ID) RN
                                                    FROM SCM_MST_SITE_CUSTOMER A
                                                         , NERP_CONV_MASTER B
                         WHERE A.DIVISION_ID = R.DIVISION_ID
                           AND A.SCM_SITE_ID = R.SCM_SITE_ID
                           AND A.VALID_YN = 'Y'
                                                     AND A.SOLDTO_CODE = B.OLD_VALUE1(+)
                                                     AND B.CODETYPE(+) = 'END_CUSTOMER_ID'
                         GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, NVL(B.NEW_VALUE1, A.SOLDTO_CODE)
                  );

                IF V_ROWNUM_MAX > 1 THEN
                    RAISE_INVALID('하나의 Sales Site에 2개 이상의 Sold-To는 등록할 수 없습니다. Sold-To Code: ' || TRIM(R.SOLDTO_CODE));
                END IF;
            END IF;
        END;
    END LOOP;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;

        OPEN O_RESULT_CURSOR FOR
             SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    WHEN OTHERS THEN
        ROLLBACK;
        
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_ERR_MSG    := SQLERRM;
        
        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_ERR_MSG ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );
        

END P_DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA;

PROCEDURE P_DMF0004_SAVE_SALES_SITE_LOCATION_DATA (
      P_DATA      IN  CLOB
    , P_USER_ID   IN  VARCHAR2
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT	      NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);

    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
    BEGIN
        V_ERR_MSG     := P_MSG;
        RAISE EX_BIZ_EX;
    END;
BEGIN
  

        FOR R IN (
                SELECT
                            TRIM(JT.CRUD_TYPE)               AS CRUD_TYPE
                        , JT.LOCATION_SEQ                  AS LOCATION_SEQ
                        , TRIM(JT.DIVISION_ID)             AS DIVISION_ID
                        , TRIM(JT.LOCATION_CODE)           AS LOCATION_CODE
                        , TRIM(JT.LOCATION_DESCRIPTION)    AS LOCATION_DESCRIPTION
                        , TRIM(JT.SCM_SITE_ID)             AS SCM_SITE_ID
                        , TRIM(JT.PLANT_ID)                AS PLANT_ID
                        , TRIM(JT.LOCATION_CODE)           AS STORAGE_ID
                        , NVL(TRIM(JT.VALID_YN), 'Y')      AS VALID_YN
                        , P_USER_ID                        AS CREATED_BY
                FROM JSON_TABLE(
                        P_DATA
                    , '$[*]'
                    COLUMNS(
                                CRUD_TYPE              VARCHAR2(10)   PATH '$."CRUD_TYPE"'
                            , LOCATION_SEQ           NUMBER         PATH '$."LOCATION_SEQ"'
                            , DIVISION_ID            VARCHAR2(50)   PATH '$."DIVISION_ID"'
                            , LOCATION_CODE          VARCHAR2(100)  PATH '$."LOCATION_CODE"'
                            , LOCATION_DESCRIPTION   VARCHAR2(400)  PATH '$."LOCATION_DESCRIPTION"'
                            , SCM_SITE_ID            VARCHAR2(100)  PATH '$."SCM_SITE_ID"'
                            , PLANT_ID               VARCHAR2(100)  PATH '$."PLANT_ID"'
                            , VALID_YN               VARCHAR2(1)    PATH '$."VALID_YN"'
                    )
                ) JT
        ) LOOP
        DECLARE
            V_LOCATION_SEQ   NUMBER;
            V_S_SITE_ID      VARCHAR2(100);
            V_CNT            NUMBER;
        BEGIN
                        /* 필수값 검증 */
            IF R.DIVISION_ID IS NULL THEN RAISE_INVALID('DIVISION_ID IS NULL'); END IF;
            IF R.LOCATION_CODE IS NULL THEN RAISE_INVALID('LOCATION_CODE IS NULL'); END IF;
            IF R.SCM_SITE_ID IS NULL THEN RAISE_INVALID('SCM_SITE_ID IS NULL'); END IF;
            IF R.PLANT_ID IS NULL THEN RAISE_INVALID('PLANT_ID IS NULL'); END IF;
            IF R.STORAGE_ID IS NULL THEN RAISE_INVALID('STORAGE_ID IS NULL'); END IF;

                        /* LOCATION_SEQ 채번 */
            V_LOCATION_SEQ := NVL(R.LOCATION_SEQ, SEQ1_SCM_MST_LOCATION.NEXTVAL);

                        /* [C20200224-000354] SLOC MASTER 유효성 확인 */
                        /* 변환 규칙: STORAGE_ID = LOCATION_CODE 사용 */
            SELECT COUNT(*)
                            INTO V_CNT
                            FROM SCM_MST_SLOC A
                         WHERE A.VALID_YN = 'Y'
                             AND A.DIVISION_ID = R.DIVISION_ID
                             AND A.PLANT_ID = R.PLANT_ID
                             AND A.STORAGE_ID = R.LOCATION_CODE;

            IF V_CNT = 0 THEN
                RAISE_INVALID('storage id : ' || R.LOCATION_CODE || ' 은(는) 존재하지 않는 Storage 입니다.');
            END IF;

                        /* 20181019 중복 VALIDATION */
            BEGIN
                SELECT A.SCM_SITE_ID
                  INTO V_S_SITE_ID
                  FROM SCM_MST_LOCATION A
                  JOIN SCM_MST_SITE B
                    ON B.DIVISION_ID = A.DIVISION_ID
                   AND B.SCM_SITE_ID = R.SCM_SITE_ID
                                     AND B.SITE_TYPE = 'SALES'
                                     AND A.VALID_YN = 'Y'
                 WHERE A.DIVISION_ID = R.DIVISION_ID
                                     AND A.PLANT_ID = R.PLANT_ID
                                     AND A.STORAGE_ID = R.STORAGE_ID
                   AND A.SCM_SITE_ID <> R.SCM_SITE_ID
                   AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_S_SITE_ID := NULL;
            END;

            IF V_S_SITE_ID IS NOT NULL THEN
                RAISE_INVALID(
                    'storage id : ' || R.STORAGE_ID || ' 은(는) ' || V_S_SITE_ID || ' 에서 이미 사용중입니다.'
                );
            END IF;
                        /*
                        PR_DM_MST_SITE_SLOC_MAPPING_HIST(
                                    V_LOCATION_SEQ
                                , R.DIVISION_ID
                                , R.LOCATION_CODE
                                , R.LOCATION_DESCRIPTION
                                , R.SCM_SITE_ID
                                , R.PLANT_ID
                                , '***'
                                , '***'
                                , R.STORAGE_ID
                                , NULL
                                , R.VALID_YN
                                , R.CREATED_BY
                        );
                        */

                        /* UPSERT */
            UPDATE SCM_MST_LOCATION
               SET LOCATION_DESCRIPTION = R.LOCATION_DESCRIPTION
                 , SCM_SITE_ID = R.SCM_SITE_ID
                 , PLANT_ID = R.PLANT_ID
                 , FACTORY_ID = '***'
                 , OPERATION_ID = '***'
                 , STORAGE_ID = R.STORAGE_ID
                 , VALID_YN = R.VALID_YN
                 , LAST_UPDATED_BY = R.CREATED_BY
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE LOCATION_SEQ = V_LOCATION_SEQ
               AND DIVISION_ID = R.DIVISION_ID
               AND LOCATION_CODE = R.LOCATION_CODE;

            IF SQL%ROWCOUNT = 0 THEN
                INSERT INTO SCM_MST_LOCATION (
                      LOCATION_SEQ
                    , DIVISION_ID
                    , LOCATION_CODE
                    , LOCATION_DESCRIPTION
                    , SCM_SITE_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , OPERATION_ID
                    , STORAGE_ID
                    , VALID_YN
                    , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE
                )
                VALUES (
                      V_LOCATION_SEQ
                    , R.DIVISION_ID
                    , R.LOCATION_CODE
                    , R.LOCATION_DESCRIPTION
                    , R.SCM_SITE_ID
                    , R.PLANT_ID
                    , '***'
                    , '***'
                    , R.STORAGE_ID
                    , R.VALID_YN
                    , R.CREATED_BY
                    , SYSDATE
                    , R.CREATED_BY
                    , SYSDATE
                );
            END IF;

            V_ROW_CNT := V_ROW_CNT + 1;
        END;
    END LOOP;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
         SELECT
               '0' AS CODE
             , 'SUCCESS' AS MSG
             , TO_CHAR(V_ROW_CNT) AS EVENT
         FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;

        OPEN O_RESULT_CURSOR FOR
             SELECT
                   '-1' AS CODE
                 , V_ERR_MSG AS MSG
                 , TO_CHAR(0) AS EVENT
             FROM DUAL;

    WHEN OTHERS THEN
        ROLLBACK;
        
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_ERR_MSG    := SQLERRM;
        
        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_ERR_MSG ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );
        

END P_DMF0004_SAVE_SALES_SITE_LOCATION_DATA;

PROCEDURE P_DMF0004_SAVE_SALES_SITE_BUCKET_DATA (
      P_DATA      IN  CLOB
    , P_USER_ID   IN  VARCHAR2
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT	      NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);

    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
    BEGIN
        V_ERR_MSG     := P_MSG;
        RAISE EX_BIZ_EX;
    END;
BEGIN
 
        FOR R IN (
                SELECT
              CRUD_TYPE
            , DIVISION_ID
            , SCM_SITE_ID
            , INCOTERMS
            , DAY_CODE AS YYYYMMDD
            , CASE
                  WHEN UPPER(BUCKET_PER) = 'Y' THEN 'Y'
                  ELSE ''
              END AS BUCKET_PER
            , CONVERSION_TYPE
            , CREATED_BY
                FROM (
                        SELECT
                                    TRIM(JT.CRUD_TYPE)          AS CRUD_TYPE
                                , TRIM(JT.DIVISION_ID)        AS DIVISION_ID
                                , TRIM(JT.SCM_SITE_ID)        AS SCM_SITE_ID
                                , TRIM(JT.INCOTERMS)          AS INCOTERMS
                                , NVL(TRIM(JT.D_MON), '')    AS D_MON
                                , NVL(TRIM(JT.D_TUE), '')    AS D_TUE
                                , NVL(TRIM(JT.D_WED), '')    AS D_WED
                                , NVL(TRIM(JT.D_THU), '')    AS D_THU
                                , NVL(TRIM(JT.D_FRI), '')    AS D_FRI
                                , NVL(TRIM(JT.D_SAT), '')    AS D_SAT
                                , NVL(TRIM(JT.D_SUN), '')    AS D_SUN
                                , 'WTOD'                      AS CONVERSION_TYPE
                                , P_USER_ID                   AS CREATED_BY
                        FROM JSON_TABLE(
                                P_DATA
                            , '$[*]'
                            COLUMNS(
                                        CRUD_TYPE   VARCHAR2(10)   PATH '$."CRUD_TYPE"'
                                    , DIVISION_ID VARCHAR2(50)   PATH '$."DIVISION_ID"'
                                    , SCM_SITE_ID VARCHAR2(100)  PATH '$."SCM_SITE_ID"'
                                    , INCOTERMS   VARCHAR2(50)   PATH '$."INCOTERMS"'
                                    , D_MON       VARCHAR2(2)    PATH '$."D_MON"' NULL ON ERROR
                                    , D_TUE       VARCHAR2(2)    PATH '$."D_TUE"' NULL ON ERROR
                                    , D_WED       VARCHAR2(2)    PATH '$."D_WED"' NULL ON ERROR
                                    , D_THU       VARCHAR2(2)    PATH '$."D_THU"' NULL ON ERROR
                                    , D_FRI       VARCHAR2(2)    PATH '$."D_FRI"' NULL ON ERROR
                                    , D_SAT       VARCHAR2(2)    PATH '$."D_SAT"' NULL ON ERROR
                                    , D_SUN       VARCHAR2(2)    PATH '$."D_SUN"' NULL ON ERROR
                            )
                        ) JT
                ) J
        UNPIVOT(
            BUCKET_PER FOR DAY_CODE IN (
                  D_MON AS 'MON'
                , D_TUE AS 'TUE'
                , D_WED AS 'WED'
                , D_THU AS 'THU'
                , D_FRI AS 'FRI'
                , D_SAT AS 'SAT'
                , D_SUN AS 'SUN'
            )
        )
    ) LOOP
        IF R.DIVISION_ID IS NULL THEN RAISE_INVALID('DIVISION_ID IS NULL'); END IF;
        IF R.SCM_SITE_ID IS NULL THEN RAISE_INVALID('SCM_SITE_ID IS NULL'); END IF;
        IF R.INCOTERMS IS NULL THEN RAISE_INVALID('INCOTERMS IS NULL'); END IF;
        IF R.YYYYMMDD IS NULL THEN RAISE_INVALID('YYYYMMDD IS NULL'); END IF;
        IF R.BUCKET_PER IS NULL THEN RAISE_INVALID('BUCKET_PER IS NULL'); END IF;

                UPDATE DM_MST_BUCKET_CONVERSION
                     SET BUCKET_PER = R.BUCKET_PER
                         , LAST_UPDATED_BY = R.CREATED_BY
                         , LAST_UPDATE_DATE = SYSDATE
                 WHERE DIVISION_ID = R.DIVISION_ID
                     AND SCM_SITE_ID = R.SCM_SITE_ID
                     AND INCOTERMS = R.INCOTERMS
                     AND YYYYMMDD = R.YYYYMMDD;

                IF SQL%ROWCOUNT = 0 THEN
                        INSERT INTO DM_MST_BUCKET_CONVERSION(
                                    DIVISION_ID
                                , PROJECT_CODE
                                , SCM_SITE_ID
                                , INCOTERMS
                                , ITEM_ID
                                , YYYYMMDD
                                , BUCKET_PER
                                , CONVERSION_TYPE
                                , VALID_YN
                                , CREATED_BY
                                , CREATION_DATE
                                , LAST_UPDATED_BY
                                , LAST_UPDATE_DATE
                        )
                        VALUES(
                                    R.DIVISION_ID
                                , '***'
                                , R.SCM_SITE_ID
                                , R.INCOTERMS
                                , '***'
                                , R.YYYYMMDD
                                , R.BUCKET_PER
                                , R.CONVERSION_TYPE
                                , 'Y'
                                , R.CREATED_BY
                                , SYSDATE
                                , R.CREATED_BY
                                , SYSDATE
                        );
                END IF;

        V_ROW_CNT := V_ROW_CNT + 1;
    END LOOP;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
            SELECT
                '0' AS CODE
               , 'SUCCESS' AS MSG
               , TO_CHAR(V_ROW_CNT) AS EVENT
            FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;

        OPEN O_RESULT_CURSOR FOR
             SELECT
                   '-1' AS CODE
                 , V_ERR_MSG AS MSG
                 , TO_CHAR(0) AS EVENT
             FROM DUAL;

    WHEN OTHERS THEN
        ROLLBACK;
        
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_ERR_MSG    := SQLERRM;
        
        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
        ' / SQLERRM=' || V_ERR_MSG ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );
        

END P_DMF0004_SAVE_SALES_SITE_BUCKET_DATA;


END PKG_DMF0004;
/
