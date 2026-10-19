-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_COM0000 — 원복(사내 적용 전 원문)
CREATE OR REPLACE PACKAGE BODY         "PKG_COM0000" IS

PROCEDURE P_COM0001_GET_CITY_BY_COUNTRY_POPUP
(
	p_country 		IN 	VARCHAR2,
	p_city	  		IN 	VARCHAR2,
	o_rc1			OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
/*
 * Program ID   : PKG_COM0000
 * Description  : P_COM0001_GET_CITY_BY_COUNTRY_POPUP
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.09   park.choyi     [PJ20264226] NextSCM Pilot 설계 및 개발
 */

IS
BEGIN
	OPEN o_rc1 FOR

    SELECT A.COUNTRY
       	 , A.COUNTRY_NAME
       	 , B.CITY
       	 , B.CITY_NAME
	   	 , B.STATE_NM
  	FROM   SCM_MST_COUNTRY A
         , SCM_MST_CITY    B
    WHERE  A.COUNTRY  = B.COUNTRY
    AND    A.VALID_YN = 'Y'
    AND    B.VALID_YN = 'Y'
    /* [2026.10.01] AJS 복수조건(쉼표 구분) 조회 - 입력 원문과 쉼표로 쪼갠 값을 함께 견준다 (START) */
    AND    ( p_country IS NULL
          OR UPPER(A.COUNTRY)      LIKE '%' || UPPER(p_country) || '%'
          OR UPPER(A.COUNTRY_NAME) LIKE '%' || UPPER(p_country) || '%'
          OR EXISTS (SELECT 1
                       FROM (SELECT DISTINCT TRIM(REGEXP_SUBSTR(UPPER(p_country), '[^,]+', 1, LEVEL)) AS TST
                               FROM DUAL
                            CONNECT BY REGEXP_SUBSTR(UPPER(p_country), '[^,]+', 1, LEVEL) IS NOT NULL) IA
                      WHERE IA.TST IS NOT NULL
                        AND ( UPPER(A.COUNTRY)      LIKE '%' || IA.TST || '%'
                           OR UPPER(A.COUNTRY_NAME) LIKE '%' || IA.TST || '%'
                            ) ) )
--    AND    (
--    	   UPPER(A.COUNTRY)      LIKE '%' ||  UPPER(p_country)  ||  '%'
--		OR UPPER(A.COUNTRY_NAME) LIKE '%' ||  UPPER(p_country)  ||  '%'
--		   )
    /* [2026.10.01] AJS (END) */
    /* [2026.10.01] AJS 복수조건(쉼표 구분) 조회 - 입력 원문과 쉼표로 쪼갠 값을 함께 견준다 (START) */
    AND    ( p_city IS NULL
          OR UPPER(B.CITY)      LIKE '%' || UPPER(p_city) || '%'
          OR UPPER(B.CITY_NAME) LIKE '%' || UPPER(p_city) || '%'
          OR EXISTS (SELECT 1
                       FROM (SELECT DISTINCT TRIM(REGEXP_SUBSTR(UPPER(p_city), '[^,]+', 1, LEVEL)) AS TST
                               FROM DUAL
                            CONNECT BY REGEXP_SUBSTR(UPPER(p_city), '[^,]+', 1, LEVEL) IS NOT NULL) IA
                      WHERE IA.TST IS NOT NULL
                        AND ( UPPER(B.CITY)      LIKE '%' || IA.TST || '%'
                           OR UPPER(B.CITY_NAME) LIKE '%' || IA.TST || '%'
                            ) ) )
--    AND    (
--           UPPER(B.CITY)      LIKE '%' ||  UPPER(p_city)  ||  '%'
--		OR UPPER(B.CITY_NAME) LIKE '%' ||  UPPER(p_city)  ||  '%'
--		   )
    /* [2026.10.01] AJS (END) */
	;

	OPEN O_RESULT_CURSOR FOR
		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR(-20001,
	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
	        ' / SQLERRM=' || SQLERRM ||
	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	        ' / PARAMS=' || '-' );

END P_COM0001_GET_CITY_BY_COUNTRY_POPUP;


PROCEDURE P_COM0002_GET_CUSTOMER_BY_DIVISION_POPUP
(
    p_division_id 	IN 	VARCHAR2,
    p_soldto_code 	IN 	VARCHAR2,
    p_shipto_code 	IN 	VARCHAR2,
    o_rc1         	OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
AS
BEGIN
    OPEN o_rc1 FOR
	SELECT
	    C.DIVISION_ID,
	    D.DIVISION_NAME,
	    C.SOLDTO_CODE,
	    C.SOLDTO_DESCRIPTION,
	    C.SHIPTO_CODE,
	    C.SHIPTO_DESCRIPTION,
	    C.SHIPTO_REGION_NAME,
	    C.SHIPTO_CITY_NAME
	FROM SCM_MST_CUSTOMER C
	JOIN SCM_MST_DIVISION D
	  ON D.DIVISION_ID = C.DIVISION_ID
	WHERE C.VALID_YN = 'Y'
	  AND (
	        P_DIVISION_ID = 'ALL'
	        OR C.DIVISION_ID IN (
	            SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
	            FROM DUAL
	            CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
	        )
	      )
	  /* [2026.10.01] AJS 복수조건(쉼표 구분) 조회 - 입력 원문과 쉼표로 쪼갠 값을 함께 견준다 (START) */
	  AND ( P_SHIPTO_CODE IS NULL
	        OR UPPER(C.SHIPTO_CODE)        LIKE '%' || UPPER(P_SHIPTO_CODE) || '%'
	        OR UPPER(C.SHIPTO_DESCRIPTION) LIKE '%' || UPPER(P_SHIPTO_CODE) || '%'
	        OR EXISTS (SELECT 1
	                     FROM (SELECT DISTINCT TRIM(REGEXP_SUBSTR(UPPER(P_SHIPTO_CODE), '[^,]+', 1, LEVEL)) AS TST
	                             FROM DUAL
	                          CONNECT BY REGEXP_SUBSTR(UPPER(P_SHIPTO_CODE), '[^,]+', 1, LEVEL) IS NOT NULL) IA
	                    WHERE IA.TST IS NOT NULL
	                      AND ( UPPER(C.SHIPTO_CODE)        LIKE '%' || IA.TST || '%'
	                         OR UPPER(C.SHIPTO_DESCRIPTION) LIKE '%' || IA.TST || '%'
	                          ) ) )
--	  AND (
--	           UPPER(C.SHIPTO_CODE)        LIKE '%' || NVL(UPPER(P_SHIPTO_CODE), '') || '%'
--	        OR UPPER(C.SHIPTO_DESCRIPTION) LIKE '%' || NVL(UPPER(P_SHIPTO_CODE), '') || '%'
--	      )
	  /* [2026.10.01] AJS (END) */
	  /* [2026.10.01] AJS 복수조건(쉼표 구분) 조회 - 입력 원문과 쉼표로 쪼갠 값을 함께 견준다 (START) */
	  AND ( P_SOLDTO_CODE IS NULL
	        OR UPPER(C.SOLDTO_CODE)        LIKE '%' || UPPER(P_SOLDTO_CODE) || '%'
	        OR UPPER(C.SOLDTO_DESCRIPTION) LIKE '%' || UPPER(P_SOLDTO_CODE) || '%'
	        OR EXISTS (SELECT 1
	                     FROM (SELECT DISTINCT TRIM(REGEXP_SUBSTR(UPPER(P_SOLDTO_CODE), '[^,]+', 1, LEVEL)) AS TST
	                             FROM DUAL
	                          CONNECT BY REGEXP_SUBSTR(UPPER(P_SOLDTO_CODE), '[^,]+', 1, LEVEL) IS NOT NULL) IA
	                    WHERE IA.TST IS NOT NULL
	                      AND ( UPPER(C.SOLDTO_CODE)        LIKE '%' || IA.TST || '%'
	                         OR UPPER(C.SOLDTO_DESCRIPTION) LIKE '%' || IA.TST || '%'
	                          ) ) )
--	  AND (
--	           UPPER(C.SOLDTO_CODE)        LIKE '%' || NVL(UPPER(P_SOLDTO_CODE), '') || '%'
--	        OR UPPER(C.SOLDTO_DESCRIPTION) LIKE '%' || NVL(UPPER(P_SOLDTO_CODE), '') || '%'
--	      )
	  /* [2026.10.01] AJS (END) */
	  AND NOT EXISTS (
	        SELECT 1
	        FROM SCM_MST_SITE_CUSTOMER SC
	        JOIN SCM_MST_SITE B
	          ON B.DIVISION_ID = SC.DIVISION_ID
	         AND B.SCM_SITE_ID = SC.SCM_SITE_ID
	        WHERE SC.SOLDTO_CODE = C.SOLDTO_CODE
	          AND SC.SHIPTO_CODE = C.SHIPTO_CODE
	          AND SC.DIVISION_ID = C.DIVISION_ID
	          AND SC.VALID_YN = 'Y'
	          AND B.SITE_TYPE = 'SALES'
	      );

	OPEN O_RESULT_CURSOR FOR
		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR(-20001,
	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
	        ' / SQLERRM=' || SQLERRM ||
	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	        ' / PARAMS=' || '-' );

END P_COM0002_GET_CUSTOMER_BY_DIVISION_POPUP;


PROCEDURE P_COM0003_GET_STORAGE_BY_DIVISION_POPUP
(
    p_division_id 	IN 	VARCHAR2,
    p_storage_id  	IN 	VARCHAR2,
    o_rc1         	OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
AS
BEGIN
    OPEN o_rc1 FOR
	SELECT
	    S.DIVISION_ID,
	    D.DIVISION_NAME,
	    S.STORAGE_ID,
	    S.PLANT_ID,
	    S.STORAGE_DESCRIPTION
	FROM SCM_MST_SLOC S
	JOIN SCM_MST_DIVISION D
	  ON D.DIVISION_ID = S.DIVISION_ID
	WHERE S.VALID_YN = 'Y'
	  AND (
	        S.STORAGE_ID LIKE '6%'
	        OR S.STORAGE_ID LIKE 'A%'
	        OR S.STORAGE_ID LIKE 'B%'
	        OR (S.STORAGE_ID LIKE '799%' AND S.STORAGE_ID NOT IN ('7990', '7999'))
	      )
	  AND (
	        P_DIVISION_ID = 'ALL'
	        OR S.DIVISION_ID IN (
	            SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
	            FROM DUAL
	            CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
	        )
	      )
	  /* [2026.10.01] AJS 복수조건(쉼표 구분) 조회 - 입력 원문과 쉼표로 쪼갠 값을 함께 견준다 (START) */
	  AND ( P_STORAGE_ID IS NULL
	        OR UPPER(S.STORAGE_ID) LIKE '%' || UPPER(P_STORAGE_ID) || '%'
	        OR EXISTS (SELECT 1
	                     FROM (SELECT DISTINCT TRIM(REGEXP_SUBSTR(UPPER(P_STORAGE_ID), '[^,]+', 1, LEVEL)) AS TST
	                             FROM DUAL
	                          CONNECT BY REGEXP_SUBSTR(UPPER(P_STORAGE_ID), '[^,]+', 1, LEVEL) IS NOT NULL) IA
	                    WHERE IA.TST IS NOT NULL
	                      AND ( UPPER(S.STORAGE_ID) LIKE '%' || IA.TST || '%'
	                          ) ) )
--	  AND UPPER(S.STORAGE_ID) LIKE '%' || NVL(UPPER(P_STORAGE_ID), '') || '%'
	  /* [2026.10.01] AJS (END) */
	  AND NOT EXISTS (
	        SELECT 1
	        FROM SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
	        WHERE LOOK.LOOKUP_TYPE = 'SALES_SITE_VS_WAREHOUSE'
	          AND LOOK.VALID_YN    = 'Y'
	          AND LOOK.SEGMENT1    = S.STORAGE_ID
	          AND (
	                P_DIVISION_ID = 'ALL'
	                OR LOOK.SEGMENT3 = S.DIVISION_ID
	              )
	      );

	OPEN O_RESULT_CURSOR FOR
		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR(-20001,
	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
	        ' / SQLERRM=' || SQLERRM ||
	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	        ' / PARAMS=' || '-' );

END P_COM0003_GET_STORAGE_BY_DIVISION_POPUP;


PROCEDURE P_COM0004_GET_OWNERINFO_POPUP(
	p_search	 	IN 	VARCHAR2,
	p_lang_code  	IN 	VARCHAR2,
	p_user_id 		IN 	VARCHAR2,
	p_division_id 	IN 	VARCHAR2,
	o_rc1  		 	OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
AS
    --v_group_id VARCHAR2(50);
    --v_count NUMBER;
BEGIN
    -- ADMIN 그룹 여부 확인
    /*SELECT COUNT(1)
      INTO v_count
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
       AND VALID_YN = 'Y'
       AND SEGMENT2 = 'ALL'
       AND SEGMENT1 = p_created_by;

    IF v_count > 0 THEN
        v_group_id := 'ADMIN';
    END IF;
*/
    OPEN o_rc1 FOR

    WITH
    -- 2) admin group definition
    ADMIN_GROUP AS (
        SELECT DISTINCT SEGMENT1 AS ADMIN_GROUP
        FROM SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
          AND VALID_YN = 'Y'
          AND ATTRIBUTE1 = 'Y'
    ),

    -- 3) current user group (division scope)
    USER_GROUP AS (
        SELECT DISTINCT A.USER_GR_ID
        FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
        WHERE UPPER(A.USER_ID) = UPPER(P_USER_ID)
          AND A.UNIT_TP_CD = 'D'
          AND A.UNIT_ID = P_DIVISION_ID
    ),

    -- 4) is admin?
    IS_ADMIN AS (
        SELECT CASE
                 WHEN EXISTS (
                     SELECT 1
                     FROM USER_GROUP UG
                     JOIN ADMIN_GROUP AG
                       ON AG.ADMIN_GROUP = UG.USER_GR_ID
                 ) THEN 'Y' ELSE 'N'
               END AS ADMIN_YN
        FROM DUAL
    ),

    -- 5) OWNER first token from site_item
    OWNER_BASE AS (
--*[2026.09.14] POJ 권한과 부관하게 User정보 기준으로 조회 되도록 처리
        SELECT DISTINCT
               A.DIVISION_ID,
--               TRIM(SUBSTR(A.OWNER, 1, INSTR(A.OWNER || ',', ',') - 1)) AS FIRST_OWNER_ID		--*[2026.09.14] POJ 원본
               A.DEPT_ID
        FROM SCM_MST_SITE_ITEM A
        WHERE A.DIVISION_ID = P_DIVISION_ID
--          AND TRIM(A.OWNER) IS NOT NULL	--*[2026.09.14] POJ 원본
          AND A.DEPT_ID IS NOT NULL
    ),

    OWNER_DEPT AS (
--*[2026.09.14] POJ 권한과 부관하게 User정보 기준으로 조회 되도록 처리
        SELECT DISTINCT
               OB.DIVISION_ID,
               D.DEPT_ID
        FROM OWNER_BASE OB
--        JOIN SCM_MST_SSO_USER_INFO U				--*[2026.09.14] POJ 원본
--          ON U.USER_ID = OB.FIRST_OWNER_ID		--*[2026.09.14] POJ 원본
        JOIN SCM_MST_SSO_DEPT_INFO D
          ON D.DEPT_ID = OB.DEPT_ID
         AND D.VALID_YN = 'Y'
    ),

    PM_TEAM_MAP AS (
        SELECT DISTINCT
               L.SEGMENT1 AS DEPT_ID,
               L.SEGMENT3 AS SRC_DEPT_ID
        FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
        WHERE L.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
          AND L.VALID_YN = 'Y'
    ),

    -- 6) tmpDept equivalent
    TMP_DEPT AS (
--*[2026.09.14] POJ 권한과 부관하게 User정보 기준으로 조회 되도록 처리
        -- ADMIN + 40/82
        SELECT OD.DEPT_ID
        FROM OWNER_DEPT OD
        WHERE 1=1 
--          AND (SELECT ADMIN_YN FROM IS_ADMIN) = 'Y'	--*[2026.09.14] POJ 원본
          AND P_DIVISION_ID IN ('40', '82')
          AND OD.DIVISION_ID = P_DIVISION_ID

        UNION

        -- ADMIN + 81% owner dept
        SELECT OD.DEPT_ID
        FROM OWNER_DEPT OD
        WHERE 1=1
--          AND (SELECT ADMIN_YN FROM IS_ADMIN) = 'Y'	--*[2026.09.14] POJ 원본
          AND P_DIVISION_ID LIKE '81%'
          AND OD.DIVISION_ID = P_DIVISION_ID

        UNION

        -- ADMIN + 81% PM_TEAM_MAPPING
        SELECT PM.DEPT_ID
        FROM PM_TEAM_MAP PM
        JOIN OWNER_DEPT OD
          ON OD.DEPT_ID = PM.SRC_DEPT_ID
        WHERE 1=1 
--          AND (SELECT ADMIN_YN FROM IS_ADMIN) = 'Y'	--*[2026.09.14] POJ 원본
          AND P_DIVISION_ID LIKE '81%'
          AND OD.DIVISION_ID = P_DIVISION_ID
--*[2026.09.14] POJ 권한과 부관하게 User정보 기준으로 조회 되도록 처리
--        UNION
--        -- NON ADMIN : my dept only
--        SELECT DISTINCT U.DEPT_ID
--        FROM SCM_ADM_USER_M U
--        WHERE (SELECT ADMIN_YN FROM IS_ADMIN) = 'N'
--          AND U.USE_YN = 'Y'
--          AND UPPER(U.USER_ID) = UPPER(P_USER_ID)
    ),

    FXU AS (
        SELECT DISTINCT 
              U.USER_ID
            , U.USER_NM 	AS USER_NAME
            , U.USER_ENG_NM	AS USER_NAME_EN
            , U.DEPT_ID
        FROM SCM_ADM_USER_M U
        WHERE U.USE_YN = 'Y'
    ),

    DEPT_INFO AS (
        SELECT DISTINCT D.DEPT_ID, D.DEPT_NAME_KO
        FROM SCM_MST_SSO_DEPT_INFO D
        WHERE D.VALID_YN = 'Y'
    )

    SELECT A.USER_ID, A.USER_NAME, A.USER_NAME_EN, A.DEPT_ID, A.DEPT_NAME_KO, 
           ROW_NUMBER() OVER (ORDER BY A.USER_ID, A.USER_NAME) * 100 AS SORT_ORDER_NO,
           A.USER_SELECTABLE_FLAG
    FROM  (
            SELECT DISTINCT 
                  FXU.USER_ID
--                , FXU.USER_NAME || ' ' || NVL(UI.JOB_NAME, '') AS USER_NAME	--*[2026.09.14] POJ 원본
                , FXU.USER_NAME
                , FXU.USER_NAME_EN
                , FXU.DEPT_ID
                , DI.DEPT_NAME_KO
                , 'Y' AS USER_SELECTABLE_FLAG
            FROM FXU
            JOIN SCM_MST_SSO_USER_INFO UI										
              ON UI.USER_ID = FXU.USER_ID										
            LEFT
            JOIN DEPT_INFO DI
              ON DI.DEPT_ID = FXU.DEPT_ID
--            JOIN SCM_ADM_USER_GR_UNIT_AUTH_MPG_M UGA							--*[2026.09.14] POJ 원본
--              ON UGA.USER_ID = FXU.USER_ID									--*[2026.09.14] POJ 원본
--             AND UGA.USE_YN = 'Y'												--*[2026.09.14] POJ 원본
--             AND UGA.UNIT_TP_CD = 'D'											--*[2026.09.14] POJ 원본
--             AND UGA.UNIT_ID = P_DIVISION_ID									--*[2026.09.14] POJ 원본
--             AND UGA.USER_GR_ID IN (SELECT ADMIN_GROUP FROM ADMIN_GROUP)		--*[2026.09.14] POJ 원본
            WHERE 1 = 1 
--             AND FXU.DEPT_ID IN (SELECT DEPT_ID FROM TMP_DEPT)				--*[2026.09.14] POJ 원본 : DIVISION기준에 속하는 부서정보인데 우선 전체 사용자가 나오도록 주석으로 막음
             AND NVL(FXU.DEPT_ID,'-') NOT IN ('LESIC')
--             AND (
--                p_search IS NULL OR UPPER(FXU.USER_ID) LIKE '%' || UPPER(p_search) || '%'
--             OR p_search IS NULL OR UPPER(FXU.USER_NAME) LIKE '%' || UPPER(p_search) || '%'
--             OR p_search IS NULL OR UPPER(FXU.USER_NAME_EN) LIKE '%' || UPPER(p_search) || '%'
--             )
             AND (
	        	  p_search = '' OR p_search IS NULL
	        	  OR
	              EXISTS (
	                SELECT 1
	                FROM TABLE(UF_FX_String_Split(UPPER(p_search), ',')) P
	                WHERE UPPER(FXU.USER_ID) LIKE '%' || UPPER(P.TOKEN) || '%'
	              )
	              OR
	              EXISTS (
	                SELECT 1
	                FROM TABLE(UF_FX_String_Split(UPPER(p_search), ',')) P
	                WHERE UPPER(FXU.USER_NAME) LIKE '%' || UPPER(P.TOKEN) || '%'
	              )
	              OR
	              EXISTS (
	                SELECT 1
	                FROM TABLE(UF_FX_String_Split(UPPER(p_search), ',')) P
	                WHERE UPPER(FXU.USER_NAME_EN) LIKE '%' || UPPER(P.TOKEN) || '%'
	              )
	            )
          ) A
    ORDER BY DEPT_NAME_KO, USER_NAME, USER_ID
    ;


    /*
        SELECT DISTINCT
            A.user_id AS UserID,
            A.user_name AS UserName,
            A.user_name_en AS UserName_E,
            A.dept_id,
            CASE p_lang_code
                WHEN 'KO' THEN B.dept_name_ko
                WHEN 'EN' THEN B.dept_name_en
                WHEN 'CN' THEN B.dept_name_cn
                ELSE B.dept_name_ko
            END AS dept_name
        FROM SCM_MST_SSO_USER_INFO A
        INNER JOIN SCM_MST_SSO_DEPT_INFO B
            ON A.DEPT_ID = B.DEPT_ID
        AND B.DEPT_ID IN (
            SELECT dept_id
              FROM SCM_ADM_USER_M um
             WHERE um.dept_id = B.dept_id
        )
        INNER JOIN (
            SELECT USER_ID, DEPT_ID
              FROM SCM_MST_SSO_USER_INFO
        ) C ON A.DEPT_ID = C.DEPT_ID
        WHERE A.ACTIVE_FLAG != 'D'
          AND C.USER_ID = CASE WHEN v_group_id = 'ADMIN' THEN C.USER_ID ELSE p_created_by END
          AND (
                p_search IS NULL OR A.user_id LIKE '%' || p_search || '%'
             OR p_search IS NULL OR A.user_name LIKE '%' || p_search || '%'
             OR p_search IS NULL OR A.user_name_en LIKE '%' || p_search || '%'
          );
	     */
	OPEN O_RESULT_CURSOR FOR
		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR(-20001,
	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
	        ' / SQLERRM=' || SQLERRM ||
	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	        ' / PARAMS=' || '-' );

END P_COM0004_GET_OWNERINFO_POPUP;


PROCEDURE P_COM0005_GET_PROJECT_BY_DIVISION_POPUP(
  	p_division_id   IN 	VARCHAR2,
  	p_dept_id       IN 	VARCHAR2,
  	p_end_customer  IN 	VARCHAR2,
  	p_scm_site_id  	IN 	VARCHAR2,
  	p_project_code  IN 	VARCHAR2,
  	p_etc		   	IN 	VARCHAR2,
  	o_rc1 			OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
/*
 * Program ID   : PKG_COM0000
 * Description  : P_COM0005_GET_PROJECT_BY_DIVISION_POPUP
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.16   park.choyi     [PJ20264226] NextSCM Pilot 설계 및 개발
 * 2026.10.06   AJS          조회 속도 개선 - 결과·조건에 쓰이지 않는 사용자 정보 조인 제거
 */
AS
BEGIN
  IF p_etc = 'N' THEN
    OPEN o_rc1 FOR
      SELECT A.DIVISION_ID
           , D.DIVISION_NAME                      AS DIVISION_NAME
           , A.PROJECT_CODE
           , A.PROJECT_NAME
           , A.PROJECT_STATUS
           , BIZ.CODE                             AS BIZ_TYPE
           , BIZ.NAME                             AS BIZ_TYPE_NAME
           , A.CURRENCY
           , MAX(A.PROJECT_VER_SEQ)               AS PROJECT_VER_SEQ
           , A.PROJECT_OWNER
           , TEAM.DEPT_ID
           , TEAM.DEPT_NAME_KO
           , C.END_CUSTOMER
      FROM SCM_MST_PROJECT A
      LEFT JOIN (SELECT * FROM SCM_MST_DIVISION WHERE VALID_YN = 'Y') D
        ON A.DROP_YN = 'N'
       AND A.DIVISION_ID = D.DIVISION_ID
      LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM WHERE VALID_YN = 'Y') B
        ON A.DIVISION_ID = B.DIVISION_ID
       AND A.PROJECT_CODE = B.PROJECT_CODE
      LEFT JOIN (
          SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER
          FROM SCM_MST_SITE
          WHERE VALID_YN = 'Y'
      ) C
        ON B.DIVISION_ID = C.DIVISION_ID
       AND B.SCM_SITE_ID = C.SCM_SITE_ID
      -- 2026.10.06 AJS 결과·조건에 쓰이지 않는 사용자 조인 제거(사용자 아이디 유일 - 행 수 불변) (START)
--      LEFT JOIN SCM_MST_SSO_USER_INFO SU
--        ON SU.USER_ID = TRIM(REGEXP_SUBSTR(B.OWNER, '[^,]+', 1, 1))
      -- 2026.10.06 AJS (END)
--        	(
--
--             SELECT COLUMN_VALUE
--             FROM TABLE(String_Split(B.OWNER, ','))
--             FETCH FIRST 1 ROWS ONLY
--           )
      LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WHERE VALID_YN = 'Y') TEAM
        ON B.DEPT_ID = TEAM.DEPT_ID
      LEFT JOIN (
          SELECT SEGMENT1 AS CODE
               , SEGMENT2 AS NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE LOOKUP_TYPE = 'BIZ_TYPE_BPMS'
      ) BIZ
        ON BIZ.CODE = A.BIZ_TYPE
      WHERE TEAM.DEPT_ID IS NOT NULL
        AND (p_division_id = 'ALL' OR A.DIVISION_ID IN (
              SELECT P.COLUMN_VALUE
              FROM TABLE(UF_FX_String_SplitForIN(p_division_id, ',')) P
            ))
    	AND (p_dept_id = 'ALL' OR TEAM.DEPT_ID IN (
              SELECT P.COLUMN_VALUE
              FROM TABLE(UF_FX_String_SplitForIN(p_dept_id, ',')) P
            ))
        AND (p_end_customer = 'ALL' OR NVL(C.END_CUSTOMER, '') IN (
              SELECT P.COLUMN_VALUE
              FROM TABLE(UF_FX_String_SplitForIN(p_end_customer, ',')) P
            ))
        AND (p_scm_site_id = 'ALL' OR C.SCM_SITE_ID IN (
              SELECT P.COLUMN_VALUE
              FROM TABLE(UF_FX_String_SplitForIN(p_scm_site_id, ',')) P
            ))
        AND (
        	  p_project_code = '' OR p_project_code IS NULL
        	  OR
              EXISTS (
                SELECT 1
                FROM TABLE(UF_FX_String_Split(UPPER(p_project_code), ',')) P
                WHERE UPPER(A.PROJECT_CODE) LIKE '%' || UPPER(P.TOKEN) || '%'
              )
              OR
              EXISTS (
                SELECT 1
                FROM TABLE(UF_FX_String_Split(UPPER(p_project_code), ',')) P
                WHERE UPPER(A.PROJECT_NAME) LIKE '%' || UPPER(P.TOKEN) || '%'
              )
            )
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
      ORDER BY A.PROJECT_NAME
             , A.PROJECT_CODE;
  ELSE
    OPEN o_rc1 FOR
      SELECT A.SEGMENT1 AS DIVISION_ID
           , A.SEGMENT1 AS DIVISION_NAME
           , A.SEGMENT2 AS PROJECT_CODE
           , A.SEGMENT3 AS PROJECT_NAME
           , ''         AS PROJECT_STATUS
           , ''         AS BIZ_TYPE
           , ''         AS BIZ_TYPE_NAME
           , ''         AS CURRENCY
           , ''         AS PROJECT_VER_SEQ
           , ''         AS PROJECT_OWNER
           , ''         AS DEPT_ID
           , ''         AS DEPT_NAME_KO
           , ''         AS END_CUSTOMER
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
      WHERE A.LOOKUP_TYPE = 'DM_ETC_Project'
        AND A.VALID_YN = 'Y'
        AND A.SEGMENT1 = p_division_id
        AND EXISTS (
              SELECT 1
              FROM TABLE(UF_FX_String_Split(p_project_code, ',')) P
              WHERE UPPER(A.SEGMENT2) LIKE UPPER(P.TOKEN) || '%'
            );
  END IF;

	OPEN O_RESULT_CURSOR FOR
		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR(-20001,
	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
	        ' / SQLERRM=' || SQLERRM ||
	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	        ' / PARAMS=' || '-' );

END P_COM0005_GET_PROJECT_BY_DIVISION_POPUP;



PROCEDURE P_COM0006_GET_OWNER_DATA (
    P_DIVISION_ID   IN 	VARCHAR2,
    P_DEPT_ID       IN 	VARCHAR2,
    P_END_CUSTOMER  IN 	VARCHAR2,
    P_PROJECT_CODE  IN 	VARCHAR2,
    P_SCM_SITE_ID   IN 	VARCHAR2,
    P_OWNER_ID      IN 	VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
/*
 * Program ID   : PKG_COM0000
 * Description  : P_COM0006_GET_OWNER_DATA
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.16   park.choyi     [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS
BEGIN
    OPEN O_RC1 FOR
    /*
    WITH

    -- 2) admin group definition
    ADMIN_GROUP AS (
        SELECT DISTINCT SEGMENT1 AS ADMIN_GROUP
        FROM SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
          AND VALID_YN = 'Y'
          AND ATTRIBUTE1 = 'Y'
    ),

    -- 3) current user group (division scope)
    USER_GROUP AS (
        SELECT DISTINCT A.USER_GR_ID
        FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
        WHERE A.USER_ID = P_USER_ID
          AND A.UNIT_TP_CD = 'D'
          AND A.UNIT_ID = P_DIVISION_ID
    ),

    -- 4) is admin?
    IS_ADMIN AS (
        SELECT CASE
                 WHEN EXISTS (
                     SELECT 1
                     FROM USER_GROUP UG
                     JOIN ADMIN_GROUP AG
                       ON AG.ADMIN_GROUP = UG.USER_GR_ID
                 ) THEN 'Y' ELSE 'N'
               END AS ADMIN_YN
        FROM DUAL
    ),

    -- 5) OWNER first token from site_item
    OWNER_BASE AS (
        SELECT DISTINCT
               A.DIVISION_ID,
               TRIM(SUBSTR(A.OWNER, 1, INSTR(A.OWNER || ',', ',') - 1)) AS FIRST_OWNER_ID
        FROM SCM_MST_SITE_ITEM A
        WHERE A.DIVISION_ID = P_DIVISION_ID
          AND TRIM(A.OWNER) IS NOT NULL
    ),

    OWNER_DEPT AS (
        SELECT DISTINCT
               OB.DIVISION_ID,
               D.DEPT_ID
        FROM OWNER_BASE OB
        JOIN SCM_MST_SSO_USER_INFO U
          ON U.USER_ID = OB.FIRST_OWNER_ID
        JOIN SCM_MST_SSO_DEPT_INFO D
          ON D.DEPT_ID = U.DEPT_ID
         AND D.VALID_YN = 'Y'
    ),

    PM_TEAM_MAP AS (
        SELECT DISTINCT
               L.SEGMENT1 AS DEPT_ID,
               L.SEGMENT3 AS SRC_DEPT_ID
        FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
        WHERE L.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
          AND L.VALID_YN = 'Y'
    ),

    -- 6) tmpDept equivalent
    TMP_DEPT AS (
        -- ADMIN + 40/82
        SELECT OD.DEPT_ID
        FROM OWNER_DEPT OD
        WHERE (SELECT ADMIN_YN FROM IS_ADMIN) = 'Y'
          AND P_DIVISION_ID IN ('40', '82')
          AND OD.DIVISION_ID = P_DIVISION_ID

        UNION

        -- ADMIN + 81% owner dept
        SELECT OD.DEPT_ID
        FROM OWNER_DEPT OD
        WHERE (SELECT ADMIN_YN FROM IS_ADMIN) = 'Y'
          AND P_DIVISION_ID LIKE '81%'
          AND OD.DIVISION_ID = P_DIVISION_ID

        UNION

        -- ADMIN + 81% PM_TEAM_MAPPING
        SELECT PM.DEPT_ID
        FROM PM_TEAM_MAP PM
        JOIN OWNER_DEPT OD
          ON OD.DEPT_ID = PM.SRC_DEPT_ID
        WHERE (SELECT ADMIN_YN FROM IS_ADMIN) = 'Y'
          AND P_DIVISION_ID LIKE '81%'
          AND OD.DIVISION_ID = P_DIVISION_ID

        UNION

        -- NON ADMIN : my dept only
        SELECT DISTINCT U.DEPT_ID
        FROM SCM_ADM_USER_M U
        WHERE (SELECT ADMIN_YN FROM IS_ADMIN) = 'N'
          AND U.USE_YN = 'Y'
          AND U.USER_ID = P_USER_ID
    ),

    FXU AS (
        SELECT
              U.USER_ID
            , U.USER_NM AS USER_NAME
            , U.DEPT_ID
        FROM SCM_ADM_USER_M U
        WHERE U.USE_YN = 'Y'
    ),

    DEPT_INFO AS (
        SELECT D.DEPT_ID, D.DEPT_NAME_KO
        FROM SCM_MST_SSO_DEPT_INFO D
        WHERE D.VALID_YN = 'Y'
    )

    SELECT
          FXU.USER_ID
        , FXU.USER_NAME || ' ' || NVL(UI.JOB_NAME, '') AS USER_NAME
        , UI.USER_NAME_EN
        , FXU.DEPT_ID
        , DI.DEPT_NAME_KO
        , ROW_NUMBER() OVER (ORDER BY FXU.USER_ID, FXU.USER_NAME) * 100 AS SORT_ORDER_NO
        , 'Y' AS USER_SELECTABLE_FLAG
    FROM FXU
    JOIN SCM_MST_SSO_USER_INFO UI
      ON UI.USER_ID = FXU.USER_ID
    JOIN DEPT_INFO DI
      ON DI.DEPT_ID = FXU.DEPT_ID
    JOIN SCM_ADM_USER_GR_UNIT_AUTH_MPG_M UGA
      ON UGA.USER_ID = FXU.USER_ID
     AND UGA.USE_YN = 'Y'
     AND UGA.UNIT_TP_CD = 'D'
     AND UGA.UNIT_ID = P_DIVISION_ID
     AND UGA.USER_GR_ID IN (SELECT ADMIN_GROUP FROM ADMIN_GROUP)
    WHERE FXU.DEPT_ID IN (SELECT DEPT_ID FROM TMP_DEPT)
    ORDER BY DI.DEPT_NAME_KO, FXU.USER_NAME, FXU.USER_ID
    */


    WITH
    SPLIT_DEPT AS (
        SELECT DISTINCT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(NVL(P_DEPT_ID, 'ALL'), ','))
        WHERE VALUE IS NOT NULL
    ),
    SPLIT_CUST AS (
        SELECT DISTINCT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(NVL(P_END_CUSTOMER, 'ALL'), ','))
        WHERE VALUE IS NOT NULL
    ),
    SPLIT_SITE AS (
        SELECT DISTINCT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(NVL(P_SCM_SITE_ID, 'ALL'), ','))
        WHERE VALUE IS NOT NULL
    ),
    SPLIT_PROJ AS (
        SELECT DISTINCT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(NVL(P_PROJECT_CODE, ''), ','))
        WHERE VALUE IS NOT NULL
    )
        SELECT DISTINCT A.DIVISION_ID AS DIVISION_ID, C.DEPT_ID, C.DEPT_NAME_KO, B.USER_ID AS OWNER, 0 SORT_ORDER_NO
        , B.USER_NAME, B.USER_NAME_EN
          FROM SCM_MST_SITE_ITEM A
          JOIN SCM_MST_SSO_USER_INFO B ON A.OWNER = B.USER_ID
          JOIN SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
          JOIN SCM_MST_SITE S ON A.SCM_SITE_ID=S.SCM_SITE_ID AND S.VALID_YN='Y' AND S.SITE_TYPE='SALES'
         WHERE 1 = 1
          AND A.DIVISION_ID = P_DIVISION_ID
          AND B.DEPT_ID NOT IN ('LESIC')
          AND (P_DIVISION_ID = '40' OR P_DIVISION_ID = '82' OR P_DIVISION_ID LIKE '81%')
          AND  A.VALID_YN='Y'
          AND (P_DEPT_ID='ALL' OR C.DEPT_ID IN (SELECT VALUE FROM SPLIT_DEPT))
          AND (P_END_CUSTOMER='ALL' OR NVL(CASE WHEN P_DIVISION_ID<>'40' THEN S.END_CUSTOMER ELSE A.PROJECT_CODE END, 'NULL') IN (SELECT VALUE FROM SPLIT_CUST))

          AND (P_SCM_SITE_ID='ALL' OR A.SCM_SITE_ID IN (SELECT VALUE FROM SPLIT_SITE))
          AND (
                NVL(TRIM(P_PROJECT_CODE), 'ALL') = 'ALL'
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_PROJ P
                    WHERE UPPER(A.PROJECT_CODE) LIKE UPPER(P.VALUE) || '%'
                )
              )
--           AND (
--                P_OWNER_ID IS NULL OR UPPER(B.USER_ID) LIKE '%' || UPPER(P_OWNER_ID) || '%'
--             OR P_OWNER_ID IS NULL OR UPPER(B.USER_NAME) LIKE '%' || UPPER(P_OWNER_ID) || '%'
--             OR P_OWNER_ID IS NULL OR UPPER(B.USER_NAME_EN) LIKE '%' || UPPER(P_OWNER_ID) || '%'
--             )
             AND (
	        	  P_OWNER_ID = '' OR P_OWNER_ID IS NULL
	        	  OR
	              EXISTS (
	                SELECT 1
	                FROM TABLE(UF_FX_String_Split(UPPER(P_OWNER_ID), ',')) P
	                WHERE UPPER(B.USER_ID) LIKE '%' || UPPER(P.TOKEN) || '%'
	              )
	              OR
	              EXISTS (
	                SELECT 1
	                FROM TABLE(UF_FX_String_Split(UPPER(P_OWNER_ID), ',')) P
	                WHERE UPPER(B.USER_NAME) LIKE '%' || UPPER(P.TOKEN) || '%'
	              )
	              OR
	              EXISTS (
	                SELECT 1
	                FROM TABLE(UF_FX_String_Split(UPPER(P_OWNER_ID), ',')) P
	                WHERE UPPER(B.USER_NAME_EN) LIKE '%' || UPPER(P.TOKEN) || '%'
	              )
	            )
          ORDER BY A.DIVISION_ID, C.DEPT_NAME_KO, B.USER_ID

             ;

	OPEN O_RESULT_CURSOR FOR
		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR(-20001,
	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
	        ' / SQLERRM=' || SQLERRM ||
	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	        ' / PARAMS=' || '-' );

END P_COM0006_GET_OWNER_DATA;

PROCEDURE P_COM0007_GET_MESSAGE_POPUP (
    P_MSG_TP_CD   	IN 	VARCHAR2,
    P_MSG_CTN       IN 	VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
AS
BEGIN
    OPEN O_RC1 FOR
        SELECT
            A.MSG_ID,
            MAX(CASE WHEN A.LANG_CD = 'KO' THEN A.MSG_NM END) AS MSG_NM_KO,
            MAX(CASE WHEN A.LANG_CD = 'EN' THEN A.MSG_NM END) AS MSG_NM_EN,
            MAX(CASE WHEN A.LANG_CD = 'CN' THEN A.MSG_NM END) AS MSG_NM_CN,
            A.MSG_TP_CD
        FROM SCM_ADM_MSG_M A
        WHERE (P_MSG_TP_CD IS NULL OR P_MSG_TP_CD = '' OR P_MSG_TP_CD = 'ALL' OR A.MSG_TP_CD IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(P_MSG_TP_CD, ','))))
        AND	A.USE_YN = 'Y'
        GROUP BY A.MSG_ID, A.MSG_TP_CD
        /* [2026.10.01] AJS 복수조건(쉼표 구분) 조회 - 입력 원문과 쉼표로 쪼갠 값을 함께 견준다 (START) */
        HAVING ( P_MSG_CTN IS NULL
              OR UPPER(MAX(CASE WHEN A.LANG_CD = 'KO' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%')
              OR UPPER(MAX(CASE WHEN A.LANG_CD = 'EN' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%')
              OR UPPER(MAX(CASE WHEN A.LANG_CD = 'CN' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%')
              OR EXISTS (SELECT 1
                           FROM (SELECT DISTINCT TRIM(REGEXP_SUBSTR(UPPER(P_MSG_CTN), '[^,]+', 1, LEVEL)) AS TST
                                   FROM DUAL
                                CONNECT BY REGEXP_SUBSTR(UPPER(P_MSG_CTN), '[^,]+', 1, LEVEL) IS NOT NULL) IA
                          WHERE IA.TST IS NOT NULL
                            AND ( UPPER(MAX(CASE WHEN A.LANG_CD = 'KO' THEN A.MSG_NM END)) LIKE '%' || IA.TST || '%'
                               OR UPPER(MAX(CASE WHEN A.LANG_CD = 'EN' THEN A.MSG_NM END)) LIKE '%' || IA.TST || '%'
                               OR UPPER(MAX(CASE WHEN A.LANG_CD = 'CN' THEN A.MSG_NM END)) LIKE '%' || IA.TST || '%'
                                ) ) )
--        HAVING
--            (P_MSG_CTN IS NULL OR
--             UPPER(MAX(CASE WHEN A.LANG_CD = 'KO' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%') OR
--             UPPER(MAX(CASE WHEN A.LANG_CD = 'EN' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%') OR
--             UPPER(MAX(CASE WHEN A.LANG_CD = 'CN' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%')
--            )
        /* [2026.10.01] AJS (END) */
        ORDER BY A.MSG_ID
	    ;

	OPEN O_RESULT_CURSOR FOR
		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR(-20001,
	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
	        ' / SQLERRM=' || SQLERRM ||
	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	        ' / PARAMS=' || '-' );

END P_COM0007_GET_MESSAGE_POPUP;



PROCEDURE P_COM0008_GET_ITEM_BY_DIVISION_POPUP(
	P_DIVISION_ID   IN 	VARCHAR2,
	P_DEPT_ID		IN 	VARCHAR2,
	P_END_CUSTOMER  IN 	VARCHAR2,
	P_SCM_SITE_ID   IN 	VARCHAR2,
	P_PROJECT_CODE  IN 	VARCHAR2,
	P_ITEM_ID 		IN 	VARCHAR2,
	P_MDMACTIVE_SW  IN 	VARCHAR2,
	O_RC1 			OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
AS
/*
 * Program ID   : PKG_COM0000
 * Description  : P_COM0008_GET_ITEM_BY_DIVISION_POPUP
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.16   park.choyi     [PJ20264226] NextSCM Pilot 설계 및 개발
 * 2026.10.06   AJS          조회 속도 개선 - 품목 집계(ITEM_SINGLE_V)를 사이트품목에 있는 사업부·품목으로 한정
 */

BEGIN

    OPEN O_RC1 FOR

    WITH
    ITEM_SINGLE_V AS (
--        SELECT T1.DIVISION_ID, T1.ITEM_ID   --  2026.10.06 AJS
        SELECT /*+ LEADING(IA) USE_NL(T1) INDEX(T1 PK_SCM_ITEM_M) */ T1.DIVISION_ID, T1.ITEM_ID   --  2026.10.06 AJS
             , MAX(T1.ITEM_NAME) AS ITEM_NAME
             , MAX(T1.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
             , MAX(T1.NICK_NAME) AS NICK_NAME
             , CASE MIN(CASE WHEN T1.ITEM_TYPE='P' THEN 1 WHEN T1.ITEM_TYPE='H' THEN 2
                             WHEN T1.ITEM_TYPE='Q' THEN 3 ELSE 4 END)
                 WHEN 1 THEN 'P' WHEN 2 THEN 'H' WHEN 3 THEN 'Q' ELSE 'R' END AS ITEM_TYPE
             , MAX(T1.ACTIVE_FLAG) AS ACTIVE_FLAG
--        FROM SCM_MST_ITEM_SN T1   --  2026.10.06 AJS
        -- 2026.10.06 AJS 품목 집계를 사이트품목에 있는 사업부·품목으로 한정(사업부 전체 품목 집계 제거) (START)
        FROM (SELECT DISTINCT XA.DIVISION_ID
                            , XA.ITEM_ID
                FROM SCM_MST_SITE_ITEM XA
               WHERE XA.VALID_YN = 'Y'
                 AND (   (P_DIVISION_ID = '81' AND XA.DIVISION_ID LIKE '81%')
                      OR XA.DIVISION_ID = P_DIVISION_ID
                     )
                 AND (   P_SCM_SITE_ID = 'ALL'
                      OR INSTR(',' || REGEXP_REPLACE(TRIM(NVL(P_SCM_SITE_ID, 'ALL')), ' *, *', ',') || ',', ',' || XA.SCM_SITE_ID || ',') > 0
                     )
                 AND (   P_DEPT_ID = 'ALL'
                      OR INSTR(',' || REGEXP_REPLACE(TRIM(NVL(P_DEPT_ID, 'ALL')), ' *, *', ',') || ',', ',' || XA.DEPT_ID || ',') > 0
                     )
             ) IA
           , SCM_MST_ITEM_SN T1
        -- 2026.10.06 AJS (END)
        WHERE (
                (P_DIVISION_ID='81' AND T1.DIVISION_ID LIKE '81%')
                OR T1.DIVISION_ID=P_DIVISION_ID
              )
          AND T1.DIVISION_ID = IA.DIVISION_ID   --  2026.10.06 AJS
          AND T1.ITEM_ID = IA.ITEM_ID   --  2026.10.06 AJS
        GROUP BY T1.DIVISION_ID, T1.ITEM_ID
    ),
    TMP_81_UC_EXCEPTION AS (
        SELECT P_DIVISION_ID AS DIVISION_ID, V.ITEM_ID, V.ACTIVE_FLAG
        FROM (
            SELECT P_DIVISION_ID AS DIVISION_ID, V.ITEM_ID, V.ACTIVE_FLAG
            FROM ITEM_SINGLE_V V
            WHERE V.DIVISION_ID='81'
            GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
        ) V
        INNER JOIN (
            SELECT S.DIVISION_ID, S.ITEM_ID
            FROM SCM_MST_SITE_ITEM S
            WHERE S.DIVISION_ID=P_DIVISION_ID AND S.ITEM_ID!=''
            GROUP BY S.DIVISION_ID, S.ITEM_ID
        ) S ON S.DIVISION_ID=V.DIVISION_ID AND S.ITEM_ID=V.ITEM_ID
        WHERE P_DIVISION_ID='81_UC'
        GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
    ),
    SPLIT_DEPT AS (
        SELECT DISTINCT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(NVL(P_DEPT_ID, 'ALL'), ','))
        WHERE VALUE IS NOT NULL
    ),
    SPLIT_CUST AS (
        SELECT DISTINCT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(NVL(P_END_CUSTOMER, 'ALL'), ','))
        WHERE VALUE IS NOT NULL
    ),
    SPLIT_SITE AS (
        SELECT DISTINCT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(NVL(P_SCM_SITE_ID, 'ALL'), ','))
        WHERE VALUE IS NOT NULL
    ),
    SPLIT_PROJ AS (
        SELECT DISTINCT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(NVL(UPPER(P_PROJECT_CODE), ''), ','))
        WHERE VALUE IS NOT NULL
    ),
    SPLIT_ITEM AS (
        SELECT DISTINCT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(NVL(UPPER(P_ITEM_ID), ''), ','))
        WHERE VALUE IS NOT NULL
    )
    SELECT *
    FROM (
        /* 81% */
        SELECT DISTINCT I.DIVISION_ID, I.DIVISION_ID AS DIVISION_NAME, D.PROJECT_CODE, A.PROJECT_NAME
             , S.SCM_SITE_ID, S.SITE_DESCRIPTION, D.ITEM_ID, T.ITEM_NAME, T.ITEM_TYPE
             , (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE SEGMENT1=T.ITEM_TYPE AND LOOKUP_TYPE='ITEM_TYPE_CODE' AND VALID_YN='Y' AND ROWNUM=1) AS ITEM_TYPE_NAME
             , T.NICK_NAME, T.ITEM_CLASS_NAME
             , TEAM.DEPT_ID, TEAM.DEPT_NAME_KO AS DEPT_NAME, S.END_CUSTOMER, D.CURRENCY
        FROM SCM_MST_DIVISION I
        LEFT JOIN SCM_MST_SITE_ITEM D ON I.DIVISION_ID=D.DIVISION_ID AND D.VALID_YN='Y' AND D.PROJECT_CODE <> '-'
        LEFT JOIN SCM_MST_PROJECT A ON I.DIVISION_ID=D.DIVISION_ID AND D.PROJECT_CODE=A.PROJECT_CODE
        LEFT JOIN SCM_MST_SITE S ON S.DIVISION_ID = D.DIVISION_ID AND D.SCM_SITE_ID=S.SCM_SITE_ID AND S.VALID_YN='Y'
        LEFT JOIN ITEM_SINGLE_V T ON I.DIVISION_ID=T.DIVISION_ID AND D.ITEM_ID=T.ITEM_ID
        --LEFT JOIN SCM_MST_SSO_USER_INFO U ON D.OWNER IS NOT NULL AND U.USER_ID=TRIM(SUBSTR(D.OWNER, 1, INSTR(D.OWNER||',', ',')-1))
        LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM ON D.DEPT_ID=TEAM.DEPT_ID
        LEFT JOIN TMP_81_UC_EXCEPTION EX ON EX.DIVISION_ID=D.DIVISION_ID AND EX.ITEM_ID=D.ITEM_ID
        WHERE (P_DIVISION_ID='81' AND I.DIVISION_ID LIKE '81%' OR I.DIVISION_ID=P_DIVISION_ID) AND S.SITE_TYPE='SALES'
          AND I.DIVISION_ID LIKE '81%' AND I.VALID_YN='Y'
          AND (P_DEPT_ID='ALL' OR TEAM.DEPT_ID IN (SELECT VALUE FROM SPLIT_DEPT))
          AND (P_END_CUSTOMER='ALL' OR NVL(S.END_CUSTOMER, 'NULL') IN (SELECT VALUE FROM SPLIT_CUST))
          AND (P_SCM_SITE_ID='ALL' OR S.SCM_SITE_ID IN (SELECT VALUE FROM SPLIT_SITE))
          --AND (NVL(TRIM(P_PROJECT_CODE), 'ALL') = 'ALL' OR D.PROJECT_CODE IN (SELECT VALUE FROM SPLIT_PROJ) OR A.PROJECT_NAME IN (SELECT VALUE FROM SPLIT_PROJ))
          --AND (NVL(TRIM(P_ITEM_ID), 'ALL') = 'ALL' OR T.ITEM_ID IN (SELECT VALUE FROM SPLIT_ITEM) OR T.NICK_NAME IN (SELECT VALUE FROM SPLIT_ITEM))
          AND (
                NVL(TRIM(P_PROJECT_CODE), 'ALL') = 'ALL'
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_PROJ P
                    WHERE UPPER(D.PROJECT_CODE) LIKE UPPER(P.VALUE) || '%'
                )
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_PROJ P
                    WHERE UPPER(A.PROJECT_NAME) LIKE UPPER(P.VALUE) || '%'
                )
              )

          AND (
                NVL(TRIM(P_ITEM_ID), 'ALL') = 'ALL'
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_ITEM P
                    WHERE UPPER(D.ITEM_ID) LIKE UPPER(P.VALUE) || '%'
                )
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_ITEM P
                    WHERE UPPER(T.NICK_NAME) LIKE UPPER(P.VALUE) || '%'
                )
              )
          --*[2026-08-26] AS-IS 분석 중 아래 조건이 제거되어 추가(데이터 검증 시 차이가 있고 제외되어야 했던 모델을 입력 시 선택하면 Validaion 오류가 나서 동일하게 추가)    
          --[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선 
	      AND CASE WHEN P_DIVISION_ID = '81_UC' 
	               THEN (CASE WHEN NVL(P_MDMACTIVE_SW, '-') = '-' THEN '-'  ELSE NVL(T.ACTIVE_FLAG,EX.ACTIVE_FLAG)  END)
		           ELSE (CASE WHEN NVL(P_MDMACTIVE_SW, '-') = '-' THEN '-'  ELSE T.ACTIVE_FLAG END)
		       END = (CASE WHEN NVL(P_MDMACTIVE_SW, '-') = '-' THEN '-'  ELSE 'Y' END)

        UNION ALL

        /* 82 */
        SELECT DISTINCT I.DIVISION_ID, I.DIVISION_ID, D.PROJECT_CODE, A.PROJECT_NAME
             , S.SCM_SITE_ID, S.SITE_DESCRIPTION, T.ITEM_ID, T.ITEM_NAME, T.ITEM_TYPE
             , (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE SEGMENT1=T.ITEM_TYPE AND LOOKUP_TYPE='ITEM_TYPE_CODE' AND VALID_YN='Y' AND ROWNUM=1) AS ITEM_TYPE_NAME
             , T.NICK_NAME, T.ITEM_CLASS_NAME, TEAM.DEPT_ID, TEAM.DEPT_NAME_KO AS DEPT_NAME, S.END_CUSTOMER, D.CURRENCY
        FROM SCM_MST_DIVISION I
        LEFT JOIN SCM_MST_SITE_ITEM D ON I.DIVISION_ID=D.DIVISION_ID AND D.VALID_YN='Y' AND D.PROJECT_CODE <> '-'
        LEFT JOIN SCM_MST_PROJECT A ON I.DIVISION_ID=D.DIVISION_ID AND D.PROJECT_CODE=A.PROJECT_CODE
        LEFT JOIN SCM_MST_SITE S ON I.DIVISION_ID=D.DIVISION_ID AND D.SCM_SITE_ID=S.SCM_SITE_ID AND S.VALID_YN='Y'
        LEFT JOIN ITEM_SINGLE_V T ON I.DIVISION_ID=T.DIVISION_ID AND D.ITEM_ID=T.ITEM_ID
        --LEFT JOIN SCM_MST_SSO_USER_INFO U ON D.OWNER IS NOT NULL AND U.USER_ID=TRIM(SUBSTR(D.OWNER, 1, INSTR(D.OWNER||',', ',')-1))
        LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM ON D.DEPT_ID=TEAM.DEPT_ID
        WHERE I.DIVISION_ID=P_DIVISION_ID AND I.DIVISION_ID='82' AND I.VALID_YN='Y' AND S.SITE_TYPE='SALES'
          AND (P_DEPT_ID='ALL' OR TEAM.DEPT_ID IN (SELECT VALUE FROM SPLIT_DEPT))
          AND (P_END_CUSTOMER='ALL' OR NVL(S.END_CUSTOMER, 'NULL') IN (SELECT VALUE FROM SPLIT_CUST))
          AND (P_SCM_SITE_ID='ALL' OR S.SCM_SITE_ID IN (SELECT VALUE FROM SPLIT_SITE))
          --AND (NVL(TRIM(P_PROJECT_CODE), 'ALL') = 'ALL' OR D.PROJECT_CODE IN (SELECT VALUE FROM SPLIT_PROJ) OR A.PROJECT_NAME IN (SELECT VALUE FROM SPLIT_PROJ))
          --AND (NVL(TRIM(P_ITEM_ID), 'ALL') = 'ALL' OR T.ITEM_ID IN (SELECT VALUE FROM SPLIT_ITEM) OR T.NICK_NAME IN (SELECT VALUE FROM SPLIT_ITEM))
          AND (
                NVL(TRIM(P_PROJECT_CODE), 'ALL') = 'ALL'
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_PROJ P
                    WHERE UPPER(D.PROJECT_CODE) LIKE UPPER(P.VALUE) || '%'
                )
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_PROJ P
                    WHERE UPPER(A.PROJECT_NAME) LIKE UPPER(P.VALUE) || '%'
                )
              )

          AND (
                NVL(TRIM(P_ITEM_ID), 'ALL') = 'ALL'
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_ITEM P
                    WHERE UPPER(D.ITEM_ID) LIKE UPPER(P.VALUE) || '%'
                )
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_ITEM P
                    WHERE UPPER(T.NICK_NAME) LIKE UPPER(P.VALUE) || '%'
                )
              )
          --*[2026-08-26] AS-IS 분석 중 아래 조건이 제거되어 추가(데이터 검증 시 차이가 있고 제외되어야 했던 모델을 입력 시 선태하면 Validaion 오류가 나서 동일하게 추가)  
          --[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
		  AND CASE WHEN NVL(P_MDMACTIVE_SW, '-') = '-' THEN '-'  ELSE T.ACTIVE_FLAG END = CASE WHEN NVL(P_MDMACTIVE_SW, '-') = '-' THEN '-'  ELSE 'Y' END --20231127 

        UNION ALL

        /* 4% */
        SELECT DISTINCT I.DIVISION_ID, I.DIVISION_ID, D.PROJECT_CODE, ''
             , S.SCM_SITE_ID, S.SITE_DESCRIPTION, D.ITEM_ID, T.ITEM_NAME, T.ITEM_TYPE
             , (SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE SEGMENT1=T.ITEM_TYPE AND LOOKUP_TYPE='ITEM_TYPE_CODE' AND VALID_YN='Y' AND ROWNUM=1) AS ITEM_TYPE_NAME
             , T.NICK_NAME, T.ITEM_CLASS_NAME, TEAM.DEPT_ID, TEAM.DEPT_NAME_KO AS DEPT_NAME, D.PROJECT_CODE AS END_CUSTOMER, D.CURRENCY
        FROM SCM_MST_DIVISION I
        LEFT JOIN SCM_MST_SITE_ITEM D ON I.DIVISION_ID=D.DIVISION_ID AND D.VALID_YN='Y'
        --LEFT JOIN SCM_MST_SSO_USER_INFO U ON D.OWNER IS NOT NULL AND U.USER_ID=TRIM(SUBSTR(D.OWNER, 1, INSTR(D.OWNER||',', ',')-1))
        LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM ON D.DEPT_ID=TEAM.DEPT_ID AND TEAM.VALID_YN='Y'
        LEFT JOIN SCM_MST_SITE S ON S.DIVISION_ID = D.DIVISION_ID AND D.SCM_SITE_ID=S.SCM_SITE_ID AND S.VALID_YN='Y'
        LEFT JOIN ITEM_SINGLE_V T ON I.DIVISION_ID=T.DIVISION_ID AND D.ITEM_ID=T.ITEM_ID
        LEFT JOIN TMP_81_UC_EXCEPTION EX ON EX.DIVISION_ID=D.DIVISION_ID AND EX.ITEM_ID=D.ITEM_ID
        WHERE I.DIVISION_ID=P_DIVISION_ID AND I.DIVISION_ID LIKE '4%' AND I.VALID_YN='Y' AND S.SITE_TYPE='SALES'
          AND (P_DEPT_ID='ALL' OR TEAM.DEPT_ID IN (SELECT VALUE FROM SPLIT_DEPT))
          AND (P_END_CUSTOMER='ALL' OR NVL(D.PROJECT_CODE, 'NULL') IN (SELECT VALUE FROM SPLIT_CUST))
          AND (P_SCM_SITE_ID='ALL' OR S.SCM_SITE_ID IN (SELECT VALUE FROM SPLIT_SITE))
          --AND (NVL(TRIM(P_ITEM_ID), 'ALL') = 'ALL' OR T.ITEM_ID IN (SELECT VALUE FROM SPLIT_ITEM) OR T.NICK_NAME IN (SELECT VALUE FROM SPLIT_ITEM))
          AND (
                NVL(TRIM(P_ITEM_ID), 'ALL') = 'ALL'
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_ITEM P
                    WHERE UPPER(D.ITEM_ID)   LIKE UPPER(P.VALUE) || '%'
                )
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_ITEM P
                    WHERE UPPER(T.NICK_NAME) LIKE UPPER(P.VALUE) || '%'
                )
              )
          --*[2026-08-26] AS-IS 분석 중 아래 조건이 제거되어 추가(데이터 검증 시 차이가 있고 제외되어야 했던 모델을 입력 시 선태하면 Validaion 오류가 나서 동일하게 추가)  
          --[E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
		  AND CASE WHEN P_DIVISION_ID = '81_UC' 
		           THEN (CASE WHEN NVL(P_MDMACTIVE_SW, '-') = '-' THEN '-'  ELSE NVL(T.ACTIVE_FLAG,EX.ACTIVE_FLAG)  END)
    			   ELSE (CASE WHEN NVL(P_MDMACTIVE_SW, '-') = '-' THEN '-'  ELSE T.ACTIVE_FLAG END)		 
               END = (CASE WHEN NVL(P_MDMACTIVE_SW, '-') = '-' THEN '-'  ELSE 'Y' END)
    )
    ORDER BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, SITE_DESCRIPTION, ITEM_ID, ITEM_NAME
    ;

	OPEN O_RESULT_CURSOR FOR
		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR(-20001,
	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
	        ' / SQLERRM=' || SQLERRM ||
	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	        ' / PARAMS=' || '-' );


/*
    WITH TEMP_DM_MST_ITEM_SINGLE_V AS
    (
        SELECT    A.DIVISION_ID, A.ITEM_ID
                , ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
                , ACTIVE_FLAG
        FROM    (   SELECT  T1.DIVISION_ID          AS DIVISION_ID,
                            T1.ITEM_ID              AS ITEM_ID,
                            MAX(T1.ITEM_NAME)       AS ITEM_NAME,           -- 해당 컬럼이 NULL인 경우가 있으므로 하나로 통일
                            MAX(T1.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME,     -- 해당 컬럼이 NULL인 경우가 있으므로 하나로 통일
                            MAX(T1.NICK_NAME)       AS NICK_NAME,           -- 닉네임이 NULL인 경우가 있으므로 하나로 통일
                            CASE  MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1  -- 타입이 사이트와 사업부, 법인에 따라 다양하게 존재하므로 하나로 통일
                                            WHEN T1.ITEM_TYPE = 'H' THEN 2  -- 또한 가장 완성된 상태의 자재 타입을 판매한다고 가정, 해당 자재타입을 사용함
                                            WHEN T1.ITEM_TYPE = 'Q' THEN 3
                                            ELSE 4 END )
                                WHEN 1 THEN 'P'
                                WHEN 2 THEN 'H'
                                WHEN 3 THEN 'Q'
                                ELSE 'R' END        AS ITEM_TYPE,
                            MAX(T1.ACTIVE_FLAG)     AS ACTIVE_FLAG  -- 20180720 ADD 'Y'대상중 1건 추출
                    FROM    SCM_MST_ITEM_SN T1
                    WHERE   T1.DIVISION_ID  = p_division_id
                    GROUP BY T1.DIVISION_ID, T1.ITEM_ID
                ) A
        WHERE A.DIVISION_ID = p_division_id
    )
-- AS-IS 소스에 있었지만 사용 용도를 모르겠음.. - 20260320 강민재
--    , TMP_81_UC_EXCEPTION AS
--    (
--        SELECT p_division_id AS DIVISION_ID, V.ITEM_ID, V.ACTIVE_FLAG
--        FROM    (   SELECT  p_division_id AS DIVISION_ID, V.ITEM_ID, V.ACTIVE_FLAG
--                    FROM    TEMP_DM_MST_ITEM_SINGLE_V V
--                    WHERE   V.DIVISION_ID = '81'  -- 고정값사용 (81_UC의 경우 81번 값으로 대체 처리, ACTIVE_FLAG가 NULL인 경우에 한함.)
--                    GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
--                ) V
--        INNER JOIN (    SELECT  S.DIVISION_ID, S.ITEM_ID
--                        FROM    SCM_MST_SITE_ITEM S
--                        WHERE   S.DIVISION_ID   = p_division_id
--                        AND     S.ITEM_ID       != ' '
--                        GROUP BY S.DIVISION_ID, S.ITEM_ID
--                    ) S
--            ON  S.DIVISION_ID   = V.DIVISION_ID
--            AND S.ITEM_ID       = V.ITEM_ID
--        WHERE   1=1
--        AND     p_division_id   = '81_UC'  -- Philsu Park: Having절 대체. 굳이 Having으로 할 필요가??
--        GROUP BY V.ITEM_ID, V.ACTIVE_FLAG
--    )
    SELECT    I.DIVISION_ID
            , I.DIVISION_ID  AS DIVISION_NAME
            , D.PROJECT_CODE
            , A.PROJECT_NAME
            , S.SCM_SITE_ID
            , S.SITE_DESCRIPTION
            , D.ITEM_ID
            , T.ITEM_NAME
            , T.ITEM_TYPE
            , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
            , T.NICK_NAME
            , T.ITEM_CLASS_NAME
            , TEAM.DEPT_ID
            , TEAM.DEPT_NAME_KO
            , S.END_CUSTOMER
            , D.CURRENCY
            , D.PROJECT_CODE AS END_CUSTOMER40
    FROM SCM_MST_DIVISION I
    LEFT JOIN SCM_MST_SITE_ITEM D
        ON  I.DIVISION_ID   = D.DIVISION_ID
        AND D.VALID_YN      = 'Y'
    LEFT JOIN SCM_MST_PROJECT A
        ON  I.DIVISION_ID   = D.DIVISION_ID
        AND D.PROJECT_CODE  = A.PROJECT_CODE
    LEFT JOIN SCM_MST_SITE S
        ON  D.SCM_SITE_ID   = S.SCM_SITE_ID
        AND S.VALID_YN      = 'Y'
    LEFT JOIN TEMP_DM_MST_ITEM_SINGLE_V T
        ON  I.DIVISION_ID   = T.DIVISION_ID
        AND D.ITEM_ID       = T.ITEM_ID
    LEFT JOIN (
                SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
                FROM SCM_MST_SSO_USER_INFO B
                INNER JOIN SCM_MST_SSO_DEPT_INFO C
                ON B.DEPT_ID = C.DEPT_ID
              ) TEAM
        ON  TEAM.USER_ID IN (
                SELECT COLUMN_VALUE FROM (
                    SELECT COLUMN_VALUE, ROWNUM AS RN FROM String_Split(D.OWNER, ',')
                ) WHERE RN = 1
            )
    LEFT JOIN (
                SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE   VALID_YN    = 'Y'
                AND     LOOKUP_TYPE = 'ITEM_TYPE_CODE'
              ) ITEM_TYPE_CODE
        ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
    -- LEFT OUTER JOIN TMP_81_UC_EXCEPTION EX ON EX.DIVISION_ID = D.DIVISION_ID AND EX.ITEM_ID = D.ITEM_ID  -- [E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
    WHERE   I.DIVISION_ID       = p_division_id   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회
    AND     I.DIVISION_ID       LIKE '81%'
    AND     I.VALID_YN          = 'Y'
    AND     S.SITE_TYPE         = 'SALES'
    AND (   p_dept_id = 'ALL'
            OR EXISTS (SELECT * FROM UF_FX_String_SplitForIN(p_dept_id, ',') P WHERE P.COLUMN_VALUE = TEAM.DEPT_ID)
        )
    AND (   p_end_customer = 'ALL'
            OR EXISTS (SELECT * FROM UF_FX_String_SplitForIN(p_end_customer, ',') P WHERE P.COLUMN_VALUE = NVL(S.END_CUSTOMER, ''))
        )
    AND (   p_scm_site_id = 'ALL'
            OR EXISTS (SELECT * FROM UF_FX_String_SplitForIN(p_scm_site_id, ',') P WHERE P.COLUMN_VALUE = S.SCM_SITE_ID)
        )
    AND (
            EXISTS (SELECT * FROM UF_FX_String_Split(p_project_code, ',') P WHERE D.PROJECT_CODE LIKE P.TOKEN || '%')
            OR
            EXISTS (SELECT * FROM UF_FX_String_Split(p_project_code, ',') P WHERE A.PROJECT_NAME LIKE P.TOKEN || '%')
        )
    AND (
            EXISTS (SELECT * FROM UF_FX_String_Split(p_item_id, ',') P WHERE D.ITEM_ID LIKE P.TOKEN || '%')
            OR
            EXISTS (SELECT * FROM UF_FX_String_Split(p_item_id, ',') P WHERE T.NICK_NAME LIKE P.TOKEN || '%')
        )   -- 20181205 nick name 조회요청으로 변경

--     [E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
--    AND CASE WHEN p_division_id = '81_UC' THEN
--                CASE WHEN NVL(p_mdmActive_Sw, '') = '' THEN '' ELSE NVL(T.ACTIVE_FLAG, EX.ACTIVE_FLAG) END
--             ELSE
--                CASE WHEN NVL(p_mdmActive_Sw, '') = '' THEN '' ELSE T.ACTIVE_FLAG END
--             END = CASE WHEN NVL(p_mdmActive_Sw, '') = '' THEN '' ELSE 'Y' END

	AND CASE
	        WHEN NVL(p_mdmActive_Sw, '') = '' THEN ''
	        ELSE T.ACTIVE_FLAG
	    END = CASE
	              WHEN NVL(p_mdmActive_Sw, '') = '' THEN ''
	              ELSE 'Y'
	          END

    UNION

    SELECT    I.DIVISION_ID
            , I.DIVISION_ID  AS DIVISION_NAME
            , D.PROJECT_CODE
            , A.PROJECT_NAME
            , S.SCM_SITE_ID
            , S.SITE_DESCRIPTION
            , T.ITEM_ID
            , T.ITEM_NAME
            , T.ITEM_TYPE
            , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
            , T.NICK_NAME
            , T.ITEM_CLASS_NAME
            , TEAM.DEPT_ID
            , TEAM.DEPT_NAME_KO
            , S.END_CUSTOMER
            , D.CURRENCY
            , D.PROJECT_CODE AS END_CUSTOMER40
    FROM    SCM_MST_DIVISION I
    LEFT JOIN   SCM_MST_SITE_ITEM D
        ON  I.DIVISION_ID   = D.DIVISION_ID
        AND D.VALID_YN      = 'Y'
    LEFT JOIN SCM_MST_PROJECT A
        ON  I.DIVISION_ID   = D.DIVISION_ID
        AND D.PROJECT_CODE  = A.PROJECT_CODE
    LEFT JOIN SCM_MST_SITE S
        ON  I.DIVISION_ID   = D.DIVISION_ID
        AND D.SCM_SITE_ID   = S.SCM_SITE_ID
        AND S.VALID_YN      = 'Y'
    LEFT OUTER JOIN TEMP_DM_MST_ITEM_SINGLE_V T
        ON  I.DIVISION_ID   = T.DIVISION_ID
        AND D.ITEM_ID       = T.ITEM_ID
        -- [E20241118-000143]_ESS 사업부 Sales Price 입력 시 제외조건 일시조치 요청 START
        --AND T.ITEM_TYPE not in ( 'H', 'R')
        --AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외
        -- [E20241118-000143]_ESS 사업부 Sales Price 입력 시 제외조건 일시조치 요청 END
    LEFT JOIN (
                SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
                FROM SCM_MST_SSO_USER_INFO B
                INNER JOIN SCM_MST_SSO_DEPT_INFO C
                ON B.DEPT_ID = C.DEPT_ID
              ) TEAM
        ON  TEAM.USER_ID IN (
                SELECT COLUMN_VALUE FROM (
                    SELECT COLUMN_VALUE, ROWNUM AS RN FROM String_Split(D.OWNER, ',')
                ) WHERE RN = 1
            )
    LEFT JOIN (
                SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE   LOOKUP_TYPE = 'ITEM_TYPE_CODE'
                AND     VALID_YN    = 'Y'
              ) ITEM_TYPE_CODE
        ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
    WHERE   I.DIVISION_ID   = p_division_id
    AND     I.DIVISION_ID   = '82'
    AND     I.VALID_YN      = 'Y'
    AND     S.SITE_TYPE     = 'SALES'
    AND (   p_dept_id = 'ALL'
            OR EXISTS (SELECT * FROM UF_FX_String_SplitForIN(p_dept_id, ',') P WHERE P.COLUMN_VALUE = TEAM.DEPT_ID)
        )
    AND (   p_end_customer = 'ALL'
            OR EXISTS (SELECT * FROM UF_FX_String_SplitForIN(p_end_customer, ',') P WHERE P.COLUMN_VALUE = NVL(S.END_CUSTOMER, ''))
        )
    AND (   p_scm_site_id = 'ALL'
            OR EXISTS (SELECT * FROM UF_FX_String_SplitForIN(p_scm_site_id, ',') P WHERE P.COLUMN_VALUE = S.SCM_SITE_ID)
        )
    AND (
            EXISTS (SELECT * FROM UF_FX_String_Split(p_project_code, ',') P WHERE D.PROJECT_CODE LIKE P.TOKEN || '%')
            OR
            EXISTS (SELECT * FROM UF_FX_String_Split(p_project_code, ',') P WHERE A.PROJECT_NAME LIKE P.TOKEN || '%')
        )
    AND (
            EXISTS (SELECT * FROM UF_FX_String_Split(p_item_id, ',') P WHERE T.ITEM_ID LIKE P.TOKEN || '%')
            OR
            EXISTS (SELECT * FROM UF_FX_String_Split(p_item_id, ',') P WHERE T.NICK_NAME LIKE P.TOKEN || '%')
        )   -- 20181205 nick name 조회요청으로 변경


--    -- [E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
--    AND CASE WHEN NVL(p_mdmActive_Sw, '') = '' THEN '' ELSE T.ACTIVE_FLAG END
--      = CASE WHEN NVL(p_mdmActive_Sw, '') = '' THEN '' ELSE 'Y' END  -- 20231127

    UNION  -- 20180611 소형 추가, 42, 44

    SELECT    I.DIVISION_ID
            , I.DIVISION_ID  AS DIVISION_NAME
            , D.PROJECT_CODE
            , '' AS PROJECT_NAME
            , S.SCM_SITE_ID
            , S.SITE_DESCRIPTION
            , D.ITEM_ID
            , T.ITEM_NAME
            , T.ITEM_TYPE
            , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
            , T.NICK_NAME
            , T.ITEM_CLASS_NAME
            , TEAM.DEPT_ID
            , TEAM.DEPT_NAME_KO
            , S.END_CUSTOMER
            , D.CURRENCY
            , D.PROJECT_CODE AS END_CUSTOMER40
    FROM  SCM_MST_DIVISION I
    LEFT JOIN SCM_MST_SITE_ITEM D
        ON  I.DIVISION_ID   = D.DIVISION_ID
        AND D.VALID_YN      = 'Y'
    LEFT JOIN SCM_MST_SSO_USER_INFO USER_INFO
        ON  D.OWNER         = USER_INFO.USER_ID
    LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
        ON  USER_INFO.DEPT_ID   = TEAM.DEPT_ID
        AND TEAM.VALID_YN       = 'Y'
    LEFT JOIN SCM_MST_SITE S
        ON  I.DIVISION_ID   = D.DIVISION_ID
        AND D.SCM_SITE_ID   = S.SCM_SITE_ID
        AND S.VALID_YN      = 'Y'
    LEFT JOIN TEMP_DM_MST_ITEM_SINGLE_V T
        ON  I.DIVISION_ID   = T.DIVISION_ID
        AND D.ITEM_ID       = T.ITEM_ID
    LEFT JOIN (
                SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
                FROM    SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE   LOOKUP_TYPE = 'ITEM_TYPE_CODE'
                AND     VALID_YN    = 'Y'
              ) ITEM_TYPE_CODE
        ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
    -- LEFT OUTER JOIN TMP_81_UC_EXCEPTION EX ON EX.DIVISION_ID = D.DIVISION_ID AND EX.ITEM_ID = D.ITEM_ID  -- [E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
    WHERE   I.DIVISION_ID       = p_division_id     -- 20190123
    AND     I.DIVISION_ID       LIKE '4%'
    AND     I.VALID_YN          = 'Y'
    AND     S.SITE_TYPE         = 'SALES'
    AND (   p_dept_id = 'ALL'
            OR EXISTS (SELECT * FROM UF_FX_String_SplitForIN(p_dept_id, ',') P WHERE P.COLUMN_VALUE = TEAM.DEPT_ID)
        )
    AND (   p_end_customer = 'ALL'
            OR EXISTS (
                SELECT * FROM UF_FX_String_SplitForIN(p_end_customer, ',') P
                WHERE P.COLUMN_VALUE = NVL(CASE WHEN p_division_id <> '40' THEN S.END_CUSTOMER ELSE D.PROJECT_CODE END, '')
            )
        )
    AND (   p_scm_site_id = 'ALL'
            OR EXISTS (SELECT * FROM UF_FX_String_SplitForIN(p_scm_site_id, ',') P WHERE P.COLUMN_VALUE = S.SCM_SITE_ID)
        )
    AND (
            EXISTS (SELECT * FROM UF_FX_String_Split(p_item_id, ',') P WHERE D.ITEM_ID LIKE P.TOKEN || '%')
            OR
            EXISTS (SELECT * FROM UF_FX_String_Split(p_item_id, ',') P WHERE T.NICK_NAME LIKE P.TOKEN || '%')
        )   -- 20181205 nick name 조회요청으로 변경

    -- [E20231019-001234] DM시스템의 모델코드 사용중지 정보 제공 개선
    -- AND CASE WHEN NVL(p_mdmActive_Sw, '') = '' THEN '' ELSE T.ACTIVE_FLAG END = CASE WHEN NVL(p_mdmActive_Sw, '') = '' THEN '' ELSE 'Y' END  -- 20231127
--    AND CASE WHEN p_division_id = '81_UC' THEN
--                CASE WHEN NVL(p_mdmActive_Sw, '') = '' THEN '' ELSE NVL(T.ACTIVE_FLAG, EX.ACTIVE_FLAG) END
--             ELSE
--                CASE WHEN NVL(p_mdmActive_Sw, '') = '' THEN '' ELSE T.ACTIVE_FLAG END
--             END = CASE WHEN NVL(p_mdmActive_Sw, '') = '' THEN '' ELSE 'Y' END
	AND CASE
	        WHEN NVL(p_mdmActive_Sw, '') = '' THEN ''
	        ELSE T.ACTIVE_FLAG
	    END = CASE
	              WHEN NVL(p_mdmActive_Sw, '') = '' THEN ''
	              ELSE 'Y'
	          END

--    ORDER BY DIVISION_ID
--           , PROJECT_CODE
--           -- , PROJECT_NAME
--           , SCM_SITE_ID
--           , SITE_DESCRIPTION
--           , ITEM_ID
--           , ITEM_NAME
	;*/

END P_COM0008_GET_ITEM_BY_DIVISION_POPUP;

PROCEDURE P_COM0009_GET_TEAM_POPUP(
    P_TEAM_ID     	IN  VARCHAR2,
    P_TEAM_NAME   	IN  VARCHAR2,
    P_CREATED_BY  	IN  VARCHAR2,
    -- P_USERINFO    IN  VARCHAR2,
    P_DIVISION_ID   IN  VARCHAR2,
    O_RC1      	  	OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
/*
 * Program ID   : PKG_COM0000
 * Description  : P_COM0009_GET_TEAM_POPUP
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.16   park.choyi     [PJ20264226] NextSCM Pilot 설계 및 개발
 * 2026.10.06   AJS          조회 속도 개선 - 권한 사용자 부서 목록 하위질의를 한 번만 구해 바깥 조인(팀 목록 조회 분기)
 */
AS
    v_dept_id            VARCHAR2(50) := '';
    v_group_id           VARCHAR2(50) := '';
    v_team_cnt           NUMBER := 0;
    v_admin_cnt          NUMBER := 0;
    v_sales_mgmt_cnt     NUMBER := 0;
    v_org_dept_id        VARCHAR2(50) := '';
    v_org_upper_dept_id  VARCHAR2(50) := '';
BEGIN
    -- User Dept ID
    BEGIN
    	SELECT 	DISTINCT A.DEPT_ID
		  INTO  v_org_dept_id
     	  FROM  SCM_MST_SSO_USER_INFO A
     	  JOIN  SCM_MST_SSO_DEPT_INFO B
     		ON  A.DEPT_ID = B.DEPT_ID
 		 	AND A.USER_ID = p_created_By
 		 	AND ROWNUM = 1;
    EXCEPTION
           WHEN NO_DATA_FOUND THEN
              	v_org_dept_id := '';
    END;

    SELECT COUNT(SEGMENT3)
      INTO v_team_cnt
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'PM_TEAM_MAPPING'
       AND VALID_YN = 'Y'
       AND SEGMENT1 = (
           SELECT DEPT_ID
             FROM SCM_MST_SSO_USER_INFO
            WHERE USER_ID = p_created_By
              AND ROWNUM = 1
    		);

    -- 권한그룹을 LOOKUP관리


    SELECT COUNT(1)
      INTO v_admin_cnt
      FROM (
        SELECT USER_GR_ID
          FROM SCM_ADM_USER_GR_MPG_M
         WHERE USER_ID = p_created_By
         ) usergr
      JOIN (
        SELECT SEGMENT1
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
           AND VALID_YN = 'Y'
           AND SEGMENT2 = 'ALL'
           AND SEGMENT1 = 'DM ADMIN'
      ) admgr
        ON usergr.USER_GR_ID = admgr.SEGMENT1;

    -- SELECT COUNT(1)
    --   INTO v_admin_cnt
    --   FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    --  WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
    --    AND VALID_YN = 'Y'
    --    AND SEGMENT2 = 'ALL'
    --    AND SEGMENT1 = p_userinfo;

     IF v_admin_cnt > 0 THEN
         v_group_id := 'ADMIN';
     END IF;


     --------------------------------------------------------------
     --Admin 여부와 상관 없이 전체 조회 되도록 Setting// 권한별 조회 필요시 아래 Line 삭제
        v_team_cnt := 0; v_sales_mgmt_cnt:= 1 ; v_group_id := 'ADMIN'; 
     -------------------------------------------------------------- 
    --*[2026-09-18 / POJ] Division별로 Team 목록이 표시 되어야 하는 케이스 추가
    --* Sales Site Project Model화면은 Division_id 값이 없음.
    IF (P_DIVISION_ID IS NOT NULL) THEN
    
    	OPEN o_rc1 FOR
				SELECT DISTINCT X.CODE AS DEPT_ID,
			   X.NAME AS DEPT_NAME_KO,
			   X.CODE AS TEAM_ID,
			   X.NAME AS TEAM_NAME_KO
		FROM   (
				  SELECT DISTINCT A.DEPT_ID AS CODE
				       , CASE NVL((
				      SELECT MAX(U.LANG_CD)
				      FROM SCM_ADM_USER_M U
				      WHERE U.USER_ID = p_created_by ), 'KO') WHEN 'EN' THEN B.DEPT_NAME_EN WHEN 'CN' THEN B.DEPT_NAME_CN ELSE B.DEPT_NAME_KO END AS NAME
				  FROM SCM_MST_SITE_ITEM A
				       , SCM_MST_SSO_DEPT_INFO B
				  WHERE A.DEPT_ID = B.DEPT_ID
				    AND A.VALID_YN = 'Y'
				    AND NVL(P_DIVISION_ID, 'ALL') <> '40'
				    AND ( NVL(P_DIVISION_ID, 'ALL') = 'ALL'
				      OR INSTR(',' || P_DIVISION_ID || ',', ',' || A.DIVISION_ID || ',') > 0 )
				    AND A.DIVISION_ID IN (
				    SELECT U.UNIT_ID
				    FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M U
				    WHERE U.UNIT_TP_CD = 'D'
				      AND U.USE_YN = 'Y'
				      AND U.USER_GR_ID IN (
				      SELECT G.USER_GR_ID
				      FROM SCM_ADM_USER_GR_MPG_M G
				      WHERE G.USER_ID = p_created_by
				        AND G.USE_YN = 'Y' )
				      AND U.USER_ID = p_created_by )
				  UNION ALL
				  SELECT DISTINCT A.DEPT_ID AS CODE
				       , CASE NVL((
				      SELECT MAX(U.LANG_CD)
				      FROM SCM_ADM_USER_M U
				      WHERE U.USER_ID = p_created_by ), 'KO') WHEN 'EN' THEN C.DEPT_NAME_EN WHEN 'CN' THEN C.DEPT_NAME_CN ELSE C.DEPT_NAME_KO END AS NAME
				  FROM SCM_MST_SITE_ITEM A
				       , SCM_MST_SSO_DEPT_INFO C
				  WHERE A.DEPT_ID = C.DEPT_ID
				    AND A.VALID_YN = 'Y'
				    AND A.DIVISION_ID = '40'
				    AND NVL(P_DIVISION_ID, 'ALL') = '40' 				
			) X
			ORDER BY
				X.NAME,
				X.CODE;
 
    	
    -- ELSE IF (   --*[2026-09-18] POJ 원본
    -- [2026-09-18 / POJ] ELSE IF 는 ELSE 안에서 새 IF 를 여는 것이라 END IF 가 하나 더 필요하다.
    --   같은 IF 의 분기로 쓰려면 ELSIF 여야 한다 (PLS-00103 원인).
    ELSIF (
           v_team_cnt < 1
           OR (
           	v_sales_mgmt_cnt > 0
           	AND v_group_id = 'ADMIN'
           )
       )
    THEN
        -- 일반적인 팀 정보 조회
        BEGIN
            SELECT NVL((
                       SELECT SEGMENT3
                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE LOOKUP_TYPE = 'PM_TEAM_MAPPING'
                          AND VALID_YN = 'Y'
                          AND SEGMENT1 = U.DEPT_ID
                          AND ROWNUM = 1
                   ), U.DEPT_ID)
              INTO v_dept_id
              FROM SCM_MST_SSO_USER_INFO U
             WHERE U.USER_ID = p_created_by
               AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_dept_id := '';
        END;

        
        -- 상위 DEPT
        BEGIN
            SELECT SEGMENT3
              INTO v_org_upper_dept_id
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
             WHERE LOOKUP_TYPE = 'SALES_MGMT_TEAM'
               AND VALID_YN = 'Y'
               AND SEGMENT5 = 'Y'
               AND SEGMENT1 = v_org_dept_id
               AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_org_upper_dept_id := '';
        END;

        OPEN o_rc1 FOR
            SELECT D.DEPT_ID,
                   D.DEPT_NAME_KO,
                   T.DEPT_ID      AS TEAM_ID,
                   T.DEPT_NAME_KO AS TEAM_NAME_KO
              FROM SCM_MST_SSO_DEPT_INFO D,
                   SCM_MST_SSO_DEPT_INFO T
                   -- 2026.10.06 AJS 권한 사용자 부서 목록을 행마다 다시 구하지 않고 한 번만 구해 바깥 조인 (START)
                 , (SELECT DISTINCT B.DEPT_ID
                      FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
                         , SCM_MST_SSO_USER_INFO B
                     WHERE A.USER_ID = B.USER_ID
                   ) XA
                   -- 2026.10.06 AJS (END)
             WHERE T.UPPER_DEPT_ID = D.DEPT_ID
               AND T.DEPT_ID = XA.DEPT_ID(+)   --  2026.10.06 AJS
               AND (
                     T."2LEVEL_DEPT_ID" IN ('58174290')
                     OR (
                         -- 2026.10.06 AJS 행마다 도는 IN 하위질의를 바깥 조인 결과 확인으로 교체 (START)
--                         T.DEPT_ID IN (
--                             SELECT DISTINCT B.DEPT_ID
--                               FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
--                               JOIN SCM_MST_SSO_USER_INFO B
--                                 ON A.USER_ID = B.USER_ID
----                              WHERE A.GroupID = 'DM Planner (W/S)'
--                         )
                         XA.DEPT_ID IS NOT NULL
                         -- 2026.10.06 AJS (END)
                         AND T."2LEVEL_DEPT_ID" IS NOT NULL
                     )
               )
               AND D.VALID_YN = 'Y'
               AND T.VALID_YN = 'Y'
               AND D.DEPT_NAME_KO <> '_'
               /* [2026.10.01] AJS 복수조건(쉼표 구분) 조회 - 입력 원문과 쉼표로 쪼갠 값을 함께 견준다 (START) */
               AND ( p_team_id IS NULL
                     OR UPPER(T.DEPT_ID) LIKE '%' || UPPER(p_team_id) || '%'
                     OR EXISTS (SELECT 1
                                  FROM (SELECT DISTINCT TRIM(REGEXP_SUBSTR(UPPER(p_team_id), '[^,]+', 1, LEVEL)) AS TST
                                          FROM DUAL
                                       CONNECT BY REGEXP_SUBSTR(UPPER(p_team_id), '[^,]+', 1, LEVEL) IS NOT NULL) IA
                                 WHERE IA.TST IS NOT NULL
                                   AND ( UPPER(T.DEPT_ID) LIKE '%' || IA.TST || '%'
                                       ) ) )
--               AND UPPER(T.DEPT_ID) LIKE '%' || UPPER(p_team_id) || '%'
               /* [2026.10.01] AJS (END) */
               /* [2026.10.01] AJS 복수조건(쉼표 구분) 조회 - 입력 원문과 쉼표로 쪼갠 값을 함께 견준다 (START) */
               AND ( p_team_name IS NULL
                     OR UPPER(T.DEPT_NAME_KO) LIKE '%' || UPPER(p_team_name) || '%'
                     OR UPPER(T.DEPT_NAME_EN) LIKE '%' || UPPER(p_team_name) || '%'
                     OR UPPER(T.DEPT_NAME_CN) LIKE '%' || UPPER(p_team_name) || '%'
                     OR EXISTS (SELECT 1
                                  FROM (SELECT DISTINCT TRIM(REGEXP_SUBSTR(UPPER(p_team_name), '[^,]+', 1, LEVEL)) AS TST
                                          FROM DUAL
                                       CONNECT BY REGEXP_SUBSTR(UPPER(p_team_name), '[^,]+', 1, LEVEL) IS NOT NULL) IA
                                 WHERE IA.TST IS NOT NULL
                                   AND ( UPPER(T.DEPT_NAME_KO) LIKE '%' || IA.TST || '%'
                                      OR UPPER(T.DEPT_NAME_EN) LIKE '%' || IA.TST || '%'
                                      OR UPPER(T.DEPT_NAME_CN) LIKE '%' || IA.TST || '%'
                                       ) ) )
--               AND (
--                    UPPER(T.DEPT_NAME_KO) LIKE '%' || UPPER(p_team_name) || '%'
--                    OR UPPER(T.DEPT_NAME_EN) LIKE '%' || UPPER(p_team_name) || '%'
--                    OR UPPER(T.DEPT_NAME_CN) LIKE '%' || UPPER(p_team_name) || '%'
--               )
               /* [2026.10.01] AJS (END) */
               AND T.DEPT_ID = CASE WHEN v_group_id = 'ADMIN' THEN T.DEPT_ID ELSE v_dept_id END --ADMIN 여부 상관 없이 전체 조회 되도록 수정
               AND T.ATTRIBUTE2 LIKE '%' || v_org_upper_dept_id || '%'
             ORDER BY D.DEPT_NAME_KO, D.DEPT_ID;

	    ELSE
	        -- 복수 팀 권한 조회
	        OPEN O_RC1 FOR
	            SELECT D.DEPT_ID,
	                   D.DEPT_NAME_KO,
	                   T.DEPT_ID      AS TEAM_ID,
	                   T.DEPT_NAME_KO AS TEAM_NAME_KO
	              FROM SCM_MST_SSO_DEPT_INFO D,
	                   SCM_MST_SSO_DEPT_INFO T
	             WHERE T.UPPER_DEPT_ID = D.DEPT_ID
	               AND (
	                     T."2LEVEL_DEPT_ID" IN ('58174290')
	                     OR (
	                         T.DEPT_ID IN (
	                             SELECT DISTINCT B.DEPT_ID
	                               FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
	                               JOIN SCM_MST_SSO_USER_INFO B
	                                 ON A.USER_ID = B.USER_ID
	                              -- WHERE A.GroupID = 'DM Planner (W/S)'
	                         )
	                         AND T."2LEVEL_DEPT_ID" IS NOT NULL
	                     )
	               )
	               AND D.VALID_YN = 'Y'
	               AND T.VALID_YN = 'Y'
	               AND D.DEPT_NAME_KO <> '_'
	               AND T.DEPT_ID IN (
	                   SELECT SEGMENT3
	                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	                    WHERE LOOKUP_TYPE = 'PM_TEAM_MAPPING'
	                      AND VALID_YN = 'Y'
	                      AND SEGMENT1 = (
	                          SELECT DEPT_ID
	                            FROM SCM_MST_SSO_USER_INFO
	                           WHERE USER_ID = p_created_by
	                             AND ROWNUM = 1
	                      )
	                   UNION
	                   SELECT U.DEPT_ID
	                     FROM SCM_MST_SSO_USER_INFO U
	                    WHERE U.USER_ID = p_created_by
	               )
	             ORDER BY D.DEPT_NAME_KO, D.DEPT_ID;
	    END IF;

	OPEN O_RESULT_CURSOR FOR
		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR(-20001,
	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
	        ' / SQLERRM=' || SQLERRM ||
	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	        ' / PARAMS=' || '-' );

END P_COM0009_GET_TEAM_POPUP;

PROCEDURE P_COM0010_GET_SSO_USER_POPUP (
    P_USER_CTN   	IN 	VARCHAR2,
    P_LANG_CD       IN 	VARCHAR2,
    P_SSO_USER_YN   IN  VARCHAR2,		--*[2026.09.14] POJ P_SSO_USER_YN 추가
    O_RC1           OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
/*
 * Program ID   : PKG_COM0000
 * Description  : P_COM0010_GET_SSO_USER_POPUP
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.09.14	POJ				P_SSO_USER_YN 추가 : Group User의 경우 SSO_USER기준이 아니라 SCM_ADM_USER_M 기준으로 조회되도록 처리
 * 2026.10.01	AJS				User ID(Name) 복수조건(쉼표 구분) 조회 : 쉼표로 쪼갠 값마다 부분일치(OR), 중복 행 제거
 */
AS
BEGIN
	IF (P_SSO_USER_YN = 'N') THEN
		OPEN O_RC1 FOR
	        /* [2026.10.01] AJS User ID(Name) 복수조건(쉼표 구분) 조회 - 쉼표로 쪼갠 값마다 부분일치, 빈 값은 전건 (START) */
	        SELECT	DISTINCT
	        		U.USER_ID
	        	  , U.USER_NM 		
	        	  , U.USER_ENG_NM 	
	        	  , U.DEPT_ID
	        	  , CASE
		        	  	WHEN P_LANG_CD = 'KO' THEN D.DEPT_NAME_KO
		        	  	WHEN P_LANG_CD = 'EN' THEN D.DEPT_NAME_EN
		        	  	WHEN P_LANG_CD = 'CN' THEN D.DEPT_NAME_CN
		        	  	ELSE '-'
		        	END AS DEPT_NM
	        FROM 	SCM_ADM_USER_M U
	        	  , SCM_MST_SSO_DEPT_INFO D
	        	  , (SELECT DISTINCT TRIM(REGEXP_SUBSTR(UPPER(P_USER_CTN), '[^,]+', 1, LEVEL)) AS TST
	        	            FROM DUAL
	        	         CONNECT BY REGEXP_SUBSTR(UPPER(P_USER_CTN), '[^,]+', 1, LEVEL) IS NOT NULL) IA
			WHERE	U.DEPT_ID = D.DEPT_ID (+)
			  AND	( P_USER_CTN IS NULL
				       OR UPPER(U.USER_ID) LIKE '%' || UPPER(P_USER_CTN) || '%'   /* [2026.10.01] AJS 입력 원문 그대로도 견준다 */
				       OR UPPER(U.USER_NM) LIKE '%' || UPPER(P_USER_CTN) || '%'
				       OR UPPER(U.USER_ENG_NM) LIKE '%' || UPPER(P_USER_CTN) || '%'
				       OR ( IA.TST IS NOT NULL
				        AND ( UPPER(U.USER_ID) LIKE '%' || IA.TST || '%'
				           OR UPPER(U.USER_NM) LIKE '%' || IA.TST || '%'
				           OR UPPER(U.USER_ENG_NM) LIKE '%' || IA.TST || '%' ) ) )
--			  AND	( P_USER_CTN IS NULL
--				       OR ( IA.TST IS NOT NULL
--				        AND ( UPPER(U.USER_ID) LIKE '%' || IA.TST || '%'
--				           OR UPPER(U.USER_NM) LIKE '%' || IA.TST || '%'
--				           OR UPPER(U.USER_ENG_NM) LIKE '%' || IA.TST || '%' ) ) )
--	        SELECT	U.USER_ID
--	        	  , U.USER_NM 		
--	        	  , U.USER_ENG_NM 	
--	        	  , U.DEPT_ID
--	        	  , CASE
--		        	  	WHEN P_LANG_CD = 'KO' THEN D.DEPT_NAME_KO
--		        	  	WHEN P_LANG_CD = 'EN' THEN D.DEPT_NAME_EN
--		        	  	WHEN P_LANG_CD = 'CN' THEN D.DEPT_NAME_CN
--		        	  	ELSE '-'
--		        	END AS DEPT_NM
--	        FROM 	SCM_ADM_USER_M U		
--	     LEFT JOIN SCM_MST_SSO_DEPT_INFO D
--	        		ON	U.DEPT_ID = D.DEPT_ID
--			WHERE	(P_USER_CTN IS NULL OR
--					 UPPER(U.USER_ID) LIKE '%' || UPPER(P_USER_CTN) || '%' OR
--					 UPPER(U.USER_NM) LIKE '%' || UPPER(P_USER_CTN) || '%' OR		
--					 UPPER(U.USER_ENG_NM) LIKE '%' || UPPER(P_USER_CTN) || '%')	
--					 
	        /* [2026.10.01] AJS (END) */
		    ;
	ELSE
	    OPEN O_RC1 FOR
	        /* [2026.10.01] AJS User ID(Name) 복수조건(쉼표 구분) 조회 - 쉼표로 쪼갠 값마다 부분일치, 빈 값은 전건 (START) */
	        SELECT	DISTINCT
	        		U.USER_ID
	        	  , U.USER_NAME 	AS USER_NM			
	        	  , U.USER_NAME_EN 	AS USER_ENG_NM		
	        	  , U.DEPT_ID
	        	  , CASE
		        	  	WHEN P_LANG_CD = 'KO' THEN D.DEPT_NAME_KO
		        	  	WHEN P_LANG_CD = 'EN' THEN D.DEPT_NAME_EN
		        	  	WHEN P_LANG_CD = 'CN' THEN D.DEPT_NAME_CN
		        	  	ELSE '-'
		        	END AS DEPT_NM
	        FROM 	SCM_MST_SSO_USER_INFO U
	        	  , SCM_MST_SSO_DEPT_INFO D
	        	  , (SELECT DISTINCT TRIM(REGEXP_SUBSTR(UPPER(P_USER_CTN), '[^,]+', 1, LEVEL)) AS TST
	        	            FROM DUAL
	        	         CONNECT BY REGEXP_SUBSTR(UPPER(P_USER_CTN), '[^,]+', 1, LEVEL) IS NOT NULL) IA
			WHERE	U.DEPT_ID = D.DEPT_ID (+)
			  AND	( P_USER_CTN IS NULL
				       OR UPPER(U.USER_ID) LIKE '%' || UPPER(P_USER_CTN) || '%'   /* [2026.10.01] AJS 입력 원문 그대로도 견준다 */
				       OR UPPER(U.USER_NAME) LIKE '%' || UPPER(P_USER_CTN) || '%'
				       OR UPPER(U.USER_NAME_EN) LIKE '%' || UPPER(P_USER_CTN) || '%'
				       OR ( IA.TST IS NOT NULL
				        AND ( UPPER(U.USER_ID) LIKE '%' || IA.TST || '%'
				           OR UPPER(U.USER_NAME) LIKE '%' || IA.TST || '%'
				           OR UPPER(U.USER_NAME_EN) LIKE '%' || IA.TST || '%' ) ) )
--			  AND	( P_USER_CTN IS NULL
--				       OR ( IA.TST IS NOT NULL
--				        AND ( UPPER(U.USER_ID) LIKE '%' || IA.TST || '%'
--				           OR UPPER(U.USER_NAME) LIKE '%' || IA.TST || '%'
--				           OR UPPER(U.USER_NAME_EN) LIKE '%' || IA.TST || '%' ) ) )
--	        SELECT	U.USER_ID
--	        	  , U.USER_NAME 	AS USER_NM			
--	        	  , U.USER_NAME_EN 	AS USER_ENG_NM		
--	        	  , U.DEPT_ID
--	        	  , CASE
--		        	  	WHEN P_LANG_CD = 'KO' THEN D.DEPT_NAME_KO
--		        	  	WHEN P_LANG_CD = 'EN' THEN D.DEPT_NAME_EN
--		        	  	WHEN P_LANG_CD = 'CN' THEN D.DEPT_NAME_CN
--		        	  	ELSE '-'
--		        	END AS DEPT_NM
--	        FROM 	SCM_MST_SSO_USER_INFO U		
--	     LEFT JOIN SCM_MST_SSO_DEPT_INFO D
--	        		ON	U.DEPT_ID = D.DEPT_ID
--			WHERE	(P_USER_CTN IS NULL OR
--					 UPPER(U.USER_ID) LIKE '%' || UPPER(P_USER_CTN) || '%' OR
--					 UPPER(U.USER_NAME) LIKE '%' || UPPER(P_USER_CTN) || '%' OR		
--					 UPPER(U.USER_NAME_EN) LIKE '%' || UPPER(P_USER_CTN) || '%')	
--					 
	        /* [2026.10.01] AJS (END) */
		    ;

	END IF;

	OPEN O_RESULT_CURSOR FOR
		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR(-20001,
	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
	        ' / SQLERRM=' || SQLERRM ||
	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	        ' / PARAMS=' || '-' );

END P_COM0010_GET_SSO_USER_POPUP;

PROCEDURE P_COM0011_GET_SSO_DEPT_POPUP (
    P_DEPT_CTN   	IN 	VARCHAR2,
    P_LANG_CD       IN 	VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
AS
BEGIN
    OPEN O_RC1 FOR
        SELECT	D.DEPT_ID
        	  , CASE
	        	  	WHEN P_LANG_CD = 'KO' THEN D.DEPT_NAME_KO
	        	  	WHEN P_LANG_CD = 'EN' THEN D.DEPT_NAME_EN
	        	  	WHEN P_LANG_CD = 'CN' THEN D.DEPT_NAME_CN
	        	  	ELSE '-'
	        	END AS DEPT_NM
        FROM	SCM_MST_SSO_DEPT_INFO D
		/* [2026.10.01] AJS 복수조건(쉼표 구분) 조회 - 입력 원문과 쉼표로 쪼갠 값을 함께 견준다 (START) */
		WHERE	( P_DEPT_CTN IS NULL
		      OR UPPER(D.DEPT_NAME_KO) LIKE '%' || UPPER(P_DEPT_CTN) || '%'
		      OR UPPER(D.DEPT_NAME_EN) LIKE '%' || UPPER(P_DEPT_CTN) || '%'
		      OR UPPER(D.DEPT_NAME_CN) LIKE '%' || UPPER(P_DEPT_CTN) || '%'
		      OR UPPER(D.DEPT_ID)      LIKE '%' || UPPER(P_DEPT_CTN) || '%'
		      OR EXISTS (SELECT 1
		                   FROM (SELECT DISTINCT TRIM(REGEXP_SUBSTR(UPPER(P_DEPT_CTN), '[^,]+', 1, LEVEL)) AS TST
		                           FROM DUAL
		                        CONNECT BY REGEXP_SUBSTR(UPPER(P_DEPT_CTN), '[^,]+', 1, LEVEL) IS NOT NULL) IA
		                  WHERE IA.TST IS NOT NULL
		                    AND ( UPPER(D.DEPT_NAME_KO) LIKE '%' || IA.TST || '%'
		                       OR UPPER(D.DEPT_NAME_EN) LIKE '%' || IA.TST || '%'
		                       OR UPPER(D.DEPT_NAME_CN) LIKE '%' || IA.TST || '%'
		                       OR UPPER(D.DEPT_ID)      LIKE '%' || IA.TST || '%'
		                        ) ) )
--		WHERE	(P_DEPT_CTN IS NULL OR
--				 UPPER(D.DEPT_NAME_KO) LIKE '%' || UPPER(P_DEPT_CTN) || '%' OR
--				 UPPER(D.DEPT_NAME_EN) LIKE '%' || UPPER(P_DEPT_CTN) || '%' OR
--				 UPPER(D.DEPT_NAME_CN) LIKE '%' || UPPER(P_DEPT_CTN) || '%' OR
--				 UPPER(D.DEPT_ID) LIKE '%' || UPPER(P_DEPT_CTN) || '%')
		/* [2026.10.01] AJS (END) */
	    ;

	OPEN O_RESULT_CURSOR FOR
		SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE_APPLICATION_ERROR(-20001,
	        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
	        ' / SQLERRM=' || SQLERRM ||
	        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	        ' / PARAMS=' || '-' );

END P_COM0011_GET_SSO_DEPT_POPUP;


PROCEDURE P_COM0012_GET_PROJECT_BY_ONLY_DIVISION_POPUP(
    p_division_id   IN  VARCHAR2,
    p_project_code   IN  VARCHAR2,
    o_rc1       OUT SYS_REFCURSOR,
  O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : PKG_COM0000
 * Description  : P_COM0005_GET_PROJECT_BY_DIVISION_POPUP
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.16   park.choyi     [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS
BEGIN

    OPEN o_rc1 FOR
      SELECT A.DIVISION_ID
           , D.DIVISION_NAME                      AS DIVISION_NAME
           , A.PROJECT_CODE
           , A.PROJECT_NAME
           , A.PROJECT_STATUS
           , BIZ.CODE                             AS BIZ_TYPE
           , BIZ.NAME                             AS BIZ_TYPE_NAME
           , A.CURRENCY
           , MAX(A.PROJECT_VER_SEQ)               AS PROJECT_VER_SEQ
           , A.PROJECT_OWNER
           , C.END_CUSTOMER
      FROM SCM_MST_PROJECT A
      LEFT JOIN (SELECT * FROM SCM_MST_DIVISION WHERE VALID_YN = 'Y') D
        ON A.DIVISION_ID = D.DIVISION_ID
      LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM WHERE VALID_YN = 'Y') B
        ON A.DIVISION_ID = B.DIVISION_ID
       AND A.PROJECT_CODE = B.PROJECT_CODE
      LEFT JOIN (
          SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER
          FROM SCM_MST_SITE
          WHERE VALID_YN = 'Y'
      ) C
        ON B.DIVISION_ID = C.DIVISION_ID
       AND B.SCM_SITE_ID = C.SCM_SITE_ID
      LEFT JOIN SCM_MST_SSO_USER_INFO SU
        ON SU.USER_ID = B.OWNER
      LEFT JOIN (
          SELECT SEGMENT1 AS CODE
               , SEGMENT2 AS NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE LOOKUP_TYPE = 'BIZ_TYPE_BPMS'
      ) BIZ
        ON BIZ.CODE = A.BIZ_TYPE
      WHERE 1=1
        AND A.DROP_YN = 'N'   /* 2026.09.16 AJS 제외 프로젝트 미표시 (ON 절에서 이동) */
        AND (p_division_id = 'ALL' OR A.DIVISION_ID IN (
              SELECT P.COLUMN_VALUE
              FROM TABLE(UF_FX_String_SplitForIN(p_division_id, ',')) P
            ))
        AND (
        	  p_project_code = '' OR p_project_code IS NULL
        	  OR
              EXISTS (
                SELECT 1
                FROM TABLE(UF_FX_String_Split(UPPER(p_project_code), ',')) P
                WHERE UPPER(A.PROJECT_CODE) LIKE '%' || UPPER(P.TOKEN) || '%'
              )
              OR
              EXISTS (
                SELECT 1
                FROM TABLE(UF_FX_String_Split(UPPER(p_project_code), ',')) P
                WHERE UPPER(A.PROJECT_NAME) LIKE '%' || UPPER(P.TOKEN) || '%'
              )
            )
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
             , C.END_CUSTOMER
      ORDER BY A.PROJECT_NAME
             , A.PROJECT_CODE;


  OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

  EXCEPTION
      WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
          ' / SQLERRM=' || SQLERRM ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || '-' );

END P_COM0012_GET_PROJECT_BY_ONLY_DIVISION_POPUP;



-- 2026.09.17 AJS 공용 조회조건 SCP0121_GET_SEARCH_INFO 추가 (START)
PROCEDURE P_SCP0121_GET_SEARCH_INFO
    (
        P_USER_ID   IN  VARCHAR2,
        O_RC1       OUT SYS_REFCURSOR,
        O_RC2       OUT SYS_REFCURSOR,
        O_RC3       OUT SYS_REFCURSOR,
        O_RC4       OUT SYS_REFCURSOR,
        O_RC5       OUT SYS_REFCURSOR,
        O_RC6       OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
     * Program ID   : SCP0121_GET_SEARCH_INFO
     * Description  : 전극(EE)을 포함한 조회조건 정보 (SCP0039 · SCP0120 · SCP0121 · SCP0122 · SCP0123 · SCP0124 · SCP0126 공용)
     * Program History
     *===========================================================================================================
     *   Date       In Charge      Description
     *===========================================================================================================
     * 2025/04/21   mrchois        PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
     * 2025/06/05   mrchois        PJ2024A332R Target 대상, Onwer 정보 추가
     * 2025/06/25   mrchois        PJ2024A332R MKT FCST Version 정보 추가
     * 2025/09/03   mrchois        PJ20257329  사업부별 Operation 룩업으로부터 Operation 및 라인 표시, 삭제한 Plan Group 미표시, OSP Plant 및 라인 표시
     * 2025/10/20   mrchois        PJ20257329  Plan Group 검색조건 정렬 방식 변경(Group Code -> Group Name)
     * 2026.09.17   AJS            PKG_SCP0121 본문을 공용 패키지로 이동 · Factory / Plan Group 정렬 AS-IS 기준
     */
    IS
        V_PROC_INPUT    VARCHAR2(4000);
        V_STEP          VARCHAR2(100);
    BEGIN

        V_PROC_INPUT := 'P_USER_ID=' || P_USER_ID;

        /* GTT 초기화 */
        V_STEP := 'GTT 초기화';
        DELETE FROM GT_0121_DIVISION_INFO;
        DELETE FROM GT_0121_LINE_MASTER;
        DELETE FROM GT_0121_OSP_PLANT_INFO;

        /* ---------------------------------------------------------------------------------------- */
        /* 사업부 정보 (전극 사업부 매핑)                                                            */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'DIVISION_INFO';
        INSERT INTO GT_0121_DIVISION_INFO
        (
            DIVISION_ID
          , ORG_DIVISION_ID
          , DIVISION_DV
        )
        SELECT A.DIVISION_ID
             , B.DIVISION_ID  AS ORG_DIVISION_ID
             , A.ATTRIBUTE3   AS DIVISION_DV
          FROM SCM_MST_DIVISION A
             , SCM_MST_DIVISION B
         WHERE A.ATTRIBUTE4 = B.ATTRIBUTE4
           AND ( (A.ATTRIBUTE3 != 'EE' AND A.DIVISION_ID = B.DIVISION_ID)
                 OR
                 (A.ATTRIBUTE3 =  'EE' AND B.ATTRIBUTE3 != 'EE')
               )
           AND A.VALID_YN = 'Y'
           AND B.VALID_YN = 'Y';

        /* ---------------------------------------------------------------------------------------- */
        /* 라인 마스터 (SCP Plan 공정 범위)                                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'LINE_MASTER';
        INSERT INTO GT_0121_LINE_MASTER
        (
            COMPANY_ID
          , DIVISION_ID
          , SITE_ID
          , PLANT_ID
          , FACTORY_ID
          , FACTORY_NAME
          , OPERATION_ID
          , LINE_ID
          , LINE_NAME
        )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , B.FACTORY_NAME
             , A.OPERATION_ID
             , A.LINE_ID
             , MAX(A.LINE_NAME)  AS LINE_NAME
          FROM SCM_MST_LINE_SN    A
             , SCM_MST_FACTORY_SN B
         WHERE B.COMPANY_ID = A.COMPANY_ID
           AND B.FACTORY_ID = A.FACTORY_ID
           AND A.ACTIVE_FLAG = 'Y'
           AND EXISTS ( SELECT 1
                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                         WHERE SA.SEGMENT1 = A.OPERATION_ID
                           AND SA.SEGMENT4 LIKE '%' || A.DIVISION_ID || '%'
                           AND SA.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                           AND SA.VALID_YN = 'Y' )
         GROUP BY A.COMPANY_ID
                , A.DIVISION_ID
                , A.SITE_ID
                , A.PLANT_ID
                , A.FACTORY_ID
                , B.FACTORY_NAME
                , A.OPERATION_ID
                , A.LINE_ID;

        /* ---------------------------------------------------------------------------------------- */
        /* [PJ20257329] OSP Plant 및 라인 정보 (2025-09-03)                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'OSP_PLANT_INFO';
        INSERT INTO GT_0121_OSP_PLANT_INFO
        (
            PLANT_ID
          , PLANT_NAME
          , DIVISION_ID
          , SCM_SITE_ID
          , LINE_ID
          , LINE_NAME
          , OPERATION_ID
          , VALID_YN
          , LAST_UPDATE_DATE
        )
        SELECT B.PLANT_ID
             , C.VENDOR_NAME  AS PLANT_NAME
             , A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.LINE_ID
             , A.LINE_NAME
             , A.OPERATION_ID
             , A.VALID_YN
             , A.LAST_UPDATE_DATE
          FROM SCM_MST_LINE_OSP A
             , SCM_MST_SITE     B
             , SCM_MST_VENDOR   C
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.SCM_SITE_ID = B.SCM_SITE_ID
           AND C.VENDOR_CODE(+) = B.PLANT_ID
           AND C.COMPANY_ID(+)  = B.COMPANY_ID
           AND A.VALID_YN = 'Y'
           AND B.VALID_YN = 'Y';

        /* ---------------------------------------------------------------------------------------- */
        /* 1. Plant id 정보                                                                          */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC1 Plant';
        OPEN O_RC1 FOR
            SELECT DISTINCT
                   A.PLANT_ID                                       AS CODE
                 , CASE WHEN A.PLANT_ID IS NULL OR IA.PLANT_NAME IS NULL
                        THEN NULL
                        ELSE A.PLANT_ID || ' ' || IA.PLANT_NAME
                   END                                              AS NAME
                 , B.DIVISION_ID
                 , B.ORG_DIVISION_ID
                 , 1                                                AS SEQ
              FROM GT_0121_LINE_MASTER   A
                 , GT_0121_DIVISION_INFO B
                 , ( SELECT DISTINCT PLANT_ID, PLANT_NAME
                       FROM SCP_MST_CAPA_LINE ) IA
             WHERE A.DIVISION_ID = B.ORG_DIVISION_ID
               AND A.OPERATION_ID = CASE WHEN B.DIVISION_DV = 'EE'
                                         THEN 'E2000'
                                         ELSE A.OPERATION_ID
                                    END
               AND A.OPERATION_ID != CASE WHEN B.DIVISION_DV = 'EE'
                                          THEN 'Z'
                                          ELSE 'E2000'
                                     END
               AND IA.PLANT_ID(+) = A.PLANT_ID
             UNION
            SELECT PLANT_ID                                         AS CODE
                 , CASE WHEN PLANT_ID IS NULL OR PLANT_NAME IS NULL
                        THEN NULL
                        ELSE PLANT_ID || ' ' || PLANT_NAME
                   END                                              AS NAME
                 , DIVISION_ID
                 , DIVISION_ID                                      AS ORG_DIVISION_ID
                 , 2                                                AS SEQ
              FROM GT_0121_OSP_PLANT_INFO
             ORDER BY SEQ, DIVISION_ID, CODE;

        /* ---------------------------------------------------------------------------------------- */
        /* 2. Factory id 정보                                                                        */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC2 Factory';
        OPEN O_RC2 FOR
          SELECT XA.CODE
               , XA.NAME
               , XA.DIVISION_ID
               , XA.ORG_DIVISION_ID
            FROM (
            SELECT DISTINCT
                   A.FACTORY_ID                                     AS CODE
                 , CASE WHEN A.FACTORY_ID IS NULL OR A.FACTORY_NAME IS NULL
                        THEN NULL
                        ELSE A.FACTORY_ID || ' ' || A.FACTORY_NAME
                   END                                              AS NAME
                 , B.DIVISION_ID
                 , B.ORG_DIVISION_ID
              FROM GT_0121_LINE_MASTER   A
                 , GT_0121_DIVISION_INFO B
             WHERE A.DIVISION_ID = B.ORG_DIVISION_ID
               AND A.OPERATION_ID = CASE WHEN B.DIVISION_DV = 'EE'
                                         THEN 'E2000'
                                         ELSE A.OPERATION_ID
                                    END
               AND A.OPERATION_ID != CASE WHEN B.DIVISION_DV = 'EE'
                                          THEN 'Z'
                                          ELSE 'E2000'
                                     END
             UNION
            SELECT '-' AS CODE, '-' AS NAME, '82' AS DIVISION_ID, '82' AS ORG_DIVISION_ID
              FROM DUAL
                 ) XA
           /* AS-IS UNION 결과 순서 : 대소문자 무시 · 하이픈 무시 · 밑줄 우선 */
           ORDER BY UPPER(REPLACE(REPLACE(XA.CODE, '-', ''), '_', CHR(1))) NULLS FIRST
                  , UPPER(REPLACE(REPLACE(XA.NAME, '-', ''), '_', CHR(1))) NULLS FIRST
                  , XA.DIVISION_ID
                  , XA.ORG_DIVISION_ID;

        /* ---------------------------------------------------------------------------------------- */
        /* 3. Line id 정보                                                                           */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC3 Line';
        OPEN O_RC3 FOR
            SELECT IA.CODE
                 , IA.NAME
                 , IA.DIVISION_ID
                 , IA.ORG_DIVISION_ID
                 , IA.OPERATION_ID
                 , IA.PLANT_ID
                 , IA.FACTORY_ID
                 , 1                                                AS SEQ
              FROM ( SELECT DISTINCT
                            A.LINE_ID                               AS CODE
                          , CASE WHEN A.LINE_ID IS NULL OR A.LINE_NAME IS NULL
                                 THEN NULL
                                 ELSE A.LINE_ID || '   ' || A.LINE_NAME
                            END                                     AS NAME
                          , B.DIVISION_ID
                          , B.ORG_DIVISION_ID
                          , A.OPERATION_ID
                          , A.PLANT_ID
                          , A.FACTORY_ID
                       FROM GT_0121_LINE_MASTER   A
                          , GT_0121_DIVISION_INFO B
                      WHERE A.DIVISION_ID = B.ORG_DIVISION_ID
                        AND A.OPERATION_ID = CASE WHEN B.DIVISION_DV = 'EE'
                                                  THEN 'E2000'
                                                  ELSE A.OPERATION_ID
                                             END
                        AND A.OPERATION_ID != CASE WHEN B.DIVISION_DV = 'EE'
                                                   THEN 'Z'
                                                   ELSE 'E2000'
                                              END ) IA
                 , SCM_ADM_LOOKUP_MASTER_DETAIL C
             WHERE C.SEGMENT1 = IA.DIVISION_ID
               AND C.SEGMENT2 = IA.OPERATION_ID
               AND C.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION'
               AND C.VALID_YN = 'Y'
             UNION
            SELECT LINE_ID                                          AS CODE
                 , CASE WHEN LINE_ID IS NULL OR LINE_NAME IS NULL
                        THEN NULL
                        ELSE LINE_ID || ' ' || LINE_NAME
                   END                                              AS NAME
                 , DIVISION_ID
                 , DIVISION_ID                                      AS ORG_DIVISION_ID
                 , OPERATION_ID
                 , PLANT_ID
                 , '-'                                              AS FACTORY_ID
                 , 2                                                AS SEQ
              FROM GT_0121_OSP_PLANT_INFO
             ORDER BY SEQ, DIVISION_ID, CODE;

        /* ---------------------------------------------------------------------------------------- */
        /* 4. Plan Group 정보                                                                        */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC4 Plan Group';
        OPEN O_RC4 FOR
            SELECT OPMZ_PLAN_GR_ID    AS CODE
                 , OPMZ_PLAN_GR_NAME  AS NAME
                 , DIVISION_ID
              FROM SCP_OPMZ_PLAN_GR_M
             WHERE VALID_YN = 'Y'   /* [PJ20257329] Plan Group 검색조건에 삭제한 Plan Group 미표시 (2025-09-03) */
               AND ( P_USER_ID IS NULL OR OWNR_LST_CTN LIKE '%' || P_USER_ID || '%' )
             ORDER BY UPPER(REPLACE(REPLACE(OPMZ_PLAN_GR_NAME, '-', ''), '_', CHR(1)));   /* [PJ20257329] 정렬 방식 변경(Group Code -> Group Name) (2025-10-20) · AS-IS 대소문자 무시 정렬 */

        /* ---------------------------------------------------------------------------------------- */
        /* 5. Prod Frozen Target 대상 정보                                                           */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC5 Target';
        OPEN O_RC5 FOR
            SELECT SEGMENT1     AS CODE
                 , DESCRIPTION  AS NAME
                 , SEGMENT2     AS DIVISION_ID
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
             WHERE LOOKUP_TYPE = 'OPMZ_TGT_DIVS_CD'
               AND VALID_YN = 'Y';

        /* ---------------------------------------------------------------------------------------- */
        /* 6. 사업부별 Operation 정보                                                                */
        /* ---------------------------------------------------------------------------------------- */
        V_STEP := 'O_RC6 Operation';
        OPEN O_RC6 FOR
            SELECT DISTINCT
                   B.SEGMENT2                                       AS CODE
                 , CASE WHEN B.SEGMENT2 IS NULL OR C.OPERATION_NAME IS NULL
                        THEN NULL
                        ELSE B.SEGMENT2 || ' ' || C.OPERATION_NAME
                   END                                              AS NAME
                 , B.SEGMENT1                                       AS DIVISION_ID
                 , 1                                                AS SEQ
              FROM SCM_ADM_LOOKUP_MASTER        A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
                 , SCM_OPERATION_M_SN           C
             WHERE A.LOOKUP_TYPE = B.LOOKUP_TYPE
               AND C.OPERATION_ID(+) = B.SEGMENT2
               AND C.ACTIVE_FLAG(+)  = 'Y'
               AND B.VALID_YN = 'Y'
               AND A.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION'
               AND A.VALID_YN = 'Y'
             UNION
            SELECT OPERATION_ID                                     AS CODE
                 , CASE WHEN OPERATION_ID IS NULL
                        THEN NULL
                        ELSE OPERATION_ID || ' ' || OPERATION_ID
                   END                                              AS NAME
                 , DIVISION_ID
                 , 2                                                AS SEQ
              FROM GT_0121_OSP_PLANT_INFO
             ORDER BY SEQ, DIVISION_ID, CODE;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[PKG_COM0000.P_SCP0121_GET_SEARCH_INFO] STEP=' || V_STEP
                                          || ' INPUT=' || V_PROC_INPUT || ' / ' || SQLERRM);
    END P_SCP0121_GET_SEARCH_INFO;
-- 2026.09.17 AJS 공용 조회조건 SCP0121_GET_SEARCH_INFO 추가 (END)

-- 2026.09.17 AJS 공용 기간 조회 SCM0001_GET_SCP_DAY_PERIOD 외 3건 추가 (START)
/* ---------------------------------------------------------------------------------------- */
/* 기간 조회 공통 계산 (AS-IS SQL Server 동작 재현, 패키지 내부 전용)                        */
/* ---------------------------------------------------------------------------------------- */
/* 시작일 하한 : AS-IS 문자열 비교(Latin1_General_CI_AS)는 하이픈을 건너뛰고 비교한 뒤        */
/*               같으면 하이픈이 있는 쪽을 크게 본다 → 'YYYY-MM-DD' 입력은 당일이 빠진다      */
FUNCTION F_SCM0001_LOW_BOUND(
    P_DATE IN VARCHAR2
) RETURN VARCHAR2
IS
BEGIN
    IF INSTR(P_DATE, '-') > 0 THEN
        RETURN REPLACE(P_DATE, '-', '') || CHR(1);
    END IF;
    RETURN P_DATE;
END F_SCM0001_LOW_BOUND;

/* AS-IS datetime 범위(1753-01-01 ~ 9999-12-31) 초과 시 AS-IS 와 같이 오류 */
FUNCTION F_SCM0001_CHECK_RANGE(
    P_DATE IN DATE
) RETURN VARCHAR2
IS
BEGIN
    IF P_DATE < DATE '1753-01-01' OR P_DATE > DATE '9999-12-31' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Adding a value to a datetime column caused an overflow.');
    END IF;
    RETURN TO_CHAR(P_DATE, 'YYYYMMDD');
END F_SCM0001_CHECK_RANGE;

/* DATEADD(DAY, n, 일자) */
FUNCTION F_SCM0001_ADD_DAYS(
    P_DATE IN VARCHAR2,
    P_DAYS IN NUMBER
) RETURN VARCHAR2
IS
BEGIN
    IF P_DATE IS NULL OR P_DAYS IS NULL THEN
        RETURN NULL;
    END IF;
    RETURN F_SCM0001_CHECK_RANGE(TO_DATE(REPLACE(P_DATE, '-', ''), 'YYYYMMDD') + P_DAYS);
END F_SCM0001_ADD_DAYS;

/* DATEADD(MM, n, 일자) : 대상 월에 같은 일자가 없으면 말일(ADD_MONTHS 의 말일→말일 규칙과 다름) */
FUNCTION F_SCM0001_ADD_MONTHS(
    P_DATE   IN VARCHAR2,
    P_MONTHS IN NUMBER
) RETURN VARCHAR2
IS
    V_BASE  DATE;
    V_MONTH DATE;
BEGIN
    IF P_DATE IS NULL OR P_MONTHS IS NULL THEN
        RETURN NULL;
    END IF;
    V_BASE  := TO_DATE(REPLACE(P_DATE, '-', ''), 'YYYYMMDD');
    V_MONTH := ADD_MONTHS(TRUNC(V_BASE, 'MM'), TRUNC(P_MONTHS));
    RETURN F_SCM0001_CHECK_RANGE(LEAST(V_MONTH + (EXTRACT(DAY FROM V_BASE) - 1), LAST_DAY(V_MONTH)));
END F_SCM0001_ADD_MONTHS;


PROCEDURE P_SCM0001_GET_SCP_DAY_PERIOD(
    P_FROM_DATE     IN  VARCHAR2,
    P_OFFSET_DAY    IN  VARCHAR2,
    P_TIMEZONE      IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : PKG_COM0000
 * Description  : P_SCM0001_GET_SCP_DAY_PERIOD - PERIOD 일자별 기간조회 (공용)
 *                결과 PERIOD = 'YYYYMMDD:YYYYMMDD' (조회 구간이 없으면 NULL)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.09.17   AJS            AS-IS SCM0001_GET_SCP_DAY_PERIOD 전환
 */
AS
    V_STEP        VARCHAR2(100 CHAR);
    V_FROM_DATE   VARCHAR2(30 CHAR);
    V_FROM_KEY    VARCHAR2(30 CHAR);
    V_FROM_LOW    VARCHAR2(31 CHAR);
    V_OFFSET_DAY  NUMBER;
    V_TO_DATE     VARCHAR2(8 CHAR);
BEGIN
    V_STEP := 'INPUT';
    V_FROM_DATE  := TRIM(P_FROM_DATE);
    V_OFFSET_DAY := TO_NUMBER(TRIM(P_OFFSET_DAY));

    /* 시작일이 비면 시간대 기준 오늘 */
    IF V_FROM_DATE IS NULL THEN
        V_FROM_DATE := TO_CHAR(FN_MULTY_TIME(P_TIMEZONE), 'YYYYMMDD');
    END IF;

    /* AS-IS INT 인자 ISNULL(@p_offset_day,'')='' 는 0 도 빈값으로 판정 → 6 */
    IF V_OFFSET_DAY IS NULL OR V_OFFSET_DAY = 0 THEN
        V_OFFSET_DAY := 6;
    END IF;

    V_FROM_KEY := REPLACE(V_FROM_DATE, '-', '');
    V_FROM_LOW := F_SCM0001_LOW_BOUND(V_FROM_DATE);
    V_TO_DATE  := F_SCM0001_ADD_DAYS(V_FROM_KEY, V_OFFSET_DAY);

    V_STEP := 'O_RC1';
    IF V_OFFSET_DAY < 0 THEN
        OPEN O_RC1 FOR
            SELECT CASE WHEN MIN(BASIS_YYYYMMDD) IS NOT NULL
                        THEN MIN(BASIS_YYYYMMDD) || ':' || MAX(BASIS_YYYYMMDD)
                   END AS PERIOD
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD <= V_FROM_KEY
               AND BASIS_YYYYMMDD >= V_TO_DATE;
    ELSE
        OPEN O_RC1 FOR
            SELECT CASE WHEN MIN(BASIS_YYYYMMDD) IS NOT NULL
                        THEN MIN(BASIS_YYYYMMDD) || ':' || MAX(BASIS_YYYYMMDD)
                   END AS PERIOD
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= V_FROM_LOW
               AND BASIS_YYYYMMDD <= V_TO_DATE;
    END IF;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, '[PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD] STEP=' || V_STEP
                                      || ' INPUT=' || P_FROM_DATE || '|' || P_OFFSET_DAY || '|' || P_TIMEZONE
                                      || ' / ' || SQLERRM);
END P_SCM0001_GET_SCP_DAY_PERIOD;


PROCEDURE P_SCM0001_GET_SCP_PERIOD(
    P_FROM_DATE     IN  VARCHAR2,
    P_OFFSET_MONTH  IN  VARCHAR2,
    P_TIMEZONE      IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : PKG_COM0000
 * Description  : P_SCM0001_GET_SCP_PERIOD - PERIOD 기간조회 (공용)
 *                시작일부터 12개월 뒤 일자의 직전 일요일까지. 개월 수 인자는 AS-IS 와 같이 무시(12 고정)
 *                결과 PERIOD = 'YYYYMMDD:YYYYMMDD' (조회 구간이 없으면 NULL)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.09.17   AJS            AS-IS SCM0001_GET_SCP_PERIOD 전환
 */
AS
    V_STEP        VARCHAR2(100 CHAR);
    V_FROM_DATE   VARCHAR2(30 CHAR);
    V_FROM_LOW    VARCHAR2(31 CHAR);
    V_TO_DATE     VARCHAR2(8 CHAR);
BEGIN
    V_STEP := 'INPUT';
    V_FROM_DATE := TRIM(P_FROM_DATE);

    /* 시작일이 비면 시간대 기준 오늘 */
    IF V_FROM_DATE IS NULL THEN
        V_FROM_DATE := TO_CHAR(FN_MULTY_TIME(P_TIMEZONE), 'YYYYMMDD');
    END IF;

    /* AS-IS : 개월 수는 인자와 상관없이 12 */
    V_FROM_LOW := F_SCM0001_LOW_BOUND(V_FROM_DATE);
    V_TO_DATE  := F_SCM0001_ADD_MONTHS(V_FROM_DATE, 12);

    /* 종료일은 마지막 일자의 직전 일요일(일요일이면 당일) */
    V_STEP := 'O_RC1';
    OPEN O_RC1 FOR
        SELECT CASE WHEN IA.MIN_BASIS_YYYYMMDD IS NOT NULL
                    THEN IA.MIN_BASIS_YYYYMMDD || ':'
                      || TO_CHAR(TRUNC(TO_DATE(IA.MAX_BASIS_YYYYMMDD, 'YYYYMMDD') + 1, 'IW') - 1, 'YYYYMMDD')
               END AS PERIOD
          FROM (SELECT MIN(BASIS_YYYYMMDD) AS MIN_BASIS_YYYYMMDD
                     , MAX(BASIS_YYYYMMDD) AS MAX_BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M
                 WHERE BASIS_YYYYMMDD >= V_FROM_LOW
                   AND BASIS_YYYYMMDD <= V_TO_DATE
               ) IA;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, '[PKG_COM0000.P_SCM0001_GET_SCP_PERIOD] STEP=' || V_STEP
                                      || ' INPUT=' || P_FROM_DATE || '|' || P_OFFSET_MONTH || '|' || P_TIMEZONE
                                      || ' / ' || SQLERRM);
END P_SCM0001_GET_SCP_PERIOD;


PROCEDURE P_SCM0001_GET_SCP_MONTH_PERIOD(
    P_DIVISION_ID   IN  VARCHAR2,
    P_PLAN_CYCLE    IN  VARCHAR2,
    P_FROM_DATE     IN  VARCHAR2,
    P_OFFSET_MONTH  IN  VARCHAR2,
    P_TIMEZONE      IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : PKG_COM0000
 * Description  : P_SCM0001_GET_SCP_MONTH_PERIOD - PERIOD 기간조회 SCM_MST_PLAN 테이블에서 가져옴 (공용)
 *                주간 계획이 있으면 계획명 ~ 계획명+363일, 없으면 시작일 ~ 개월 수 뒤 일자의 직전 일요일
 *                결과 PERIOD = 'YYYYMMDD:YYYYMMDD' (조회 구간이 없으면 NULL)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.09.17   AJS            AS-IS SCM0001_GET_SCP_MONTH_PERIOD 전환
 */
AS
    V_STEP          VARCHAR2(100 CHAR);
    V_DIVISION_ID   VARCHAR2(100 CHAR);
    V_PLAN_NAME     VARCHAR2(30 CHAR);
    V_CHK           NUMBER := 0;
    V_FROM_DATE     VARCHAR2(30 CHAR);
    V_FROM_LOW      VARCHAR2(31 CHAR);
    V_OFFSET_MONTH  VARCHAR2(2 CHAR);
    V_TO_DATE       VARCHAR2(8 CHAR);
BEGIN
    /* AS-IS 문자열 비교는 대소문자·뒤 공백 무시 */
    V_STEP := 'INPUT';
    V_DIVISION_ID := UPPER(RTRIM(P_DIVISION_ID));
    V_PLAN_NAME   := RTRIM(P_FROM_DATE);

    V_STEP := 'PLAN CHECK';
    SELECT COUNT(*)
      INTO V_CHK
      FROM SCM_MST_PLAN
     WHERE PLAN_CYCLE = 'WEEKLY'
       AND DIVISION_ID = V_DIVISION_ID
       AND PLAN_NAME = V_PLAN_NAME
       AND ROWNUM = 1;

    V_STEP := 'O_RC1';
    IF V_CHK > 0 THEN
        /* 2021-05-27 : 중장기 - 계획명 + 363일 */
        OPEN O_RC1 FOR
            SELECT PLAN_NAME || ':' || TO_CHAR(TO_DATE(PLAN_NAME, 'YYYYMMDD') + 363, 'YYYYMMDD') AS PERIOD
              FROM SCM_MST_PLAN
             WHERE PLAN_CYCLE = 'WEEKLY'
               AND DIVISION_ID = V_DIVISION_ID
               AND PLAN_NAME = V_PLAN_NAME;
    ELSE
        V_FROM_DATE := TRIM(P_FROM_DATE);

        /* 시작일이 비면 시간대 기준 오늘 */
        IF V_FROM_DATE IS NULL THEN
            V_FROM_DATE := TO_CHAR(FN_MULTY_TIME(P_TIMEZONE), 'YYYYMMDD');
        END IF;

        /* AS-IS NVARCHAR(2) 인자 : 3자리 이상은 앞 2자리, 비면 12 */
        V_OFFSET_MONTH := TRIM(SUBSTR(P_OFFSET_MONTH, 1, 2));
        IF V_OFFSET_MONTH IS NULL THEN
            V_OFFSET_MONTH := '12';
        END IF;

        V_FROM_LOW := F_SCM0001_LOW_BOUND(V_FROM_DATE);
        V_TO_DATE  := F_SCM0001_ADD_MONTHS(V_FROM_DATE, TO_NUMBER(V_OFFSET_MONTH));

        /* 종료일은 마지막 일자의 직전 일요일(일요일이면 당일) */
        OPEN O_RC1 FOR
            SELECT CASE WHEN IA.MIN_BASIS_YYYYMMDD IS NOT NULL
                        THEN IA.MIN_BASIS_YYYYMMDD || ':'
                          || TO_CHAR(TRUNC(TO_DATE(IA.MAX_BASIS_YYYYMMDD, 'YYYYMMDD') + 1, 'IW') - 1, 'YYYYMMDD')
                   END AS PERIOD
              FROM (SELECT MIN(BASIS_YYYYMMDD) AS MIN_BASIS_YYYYMMDD
                         , MAX(BASIS_YYYYMMDD) AS MAX_BASIS_YYYYMMDD
                      FROM SCM_SYS_CALENDAR_M
                     WHERE BASIS_YYYYMMDD >= V_FROM_LOW
                       AND BASIS_YYYYMMDD <= V_TO_DATE
                   ) IA;
    END IF;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, '[PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD] STEP=' || V_STEP
                                      || ' INPUT=' || P_DIVISION_ID || '|' || P_PLAN_CYCLE || '|' || P_FROM_DATE
                                      || '|' || P_OFFSET_MONTH || '|' || P_TIMEZONE
                                      || ' / ' || SQLERRM);
END P_SCM0001_GET_SCP_MONTH_PERIOD;


PROCEDURE P_SCM0001_GET_WEEK_MONDAY_PERIOD(
    P_FROM_DATE     IN  VARCHAR2,
    P_OFFSET_DAY    IN  VARCHAR2,
    P_TIMEZONE      IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : PKG_COM0000
 * Description  : P_SCM0001_GET_WEEK_MONDAY_PERIOD - PERIOD 일자별 기간조회 (조회시점 월요일 기준)
 *                결과 PERIOD = 'YYYYMMDD:YYYYMMDD' (조회 구간이 없으면 NULL)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.09.17   AJS            AS-IS SCM0001_GET_WEEK_MONDAY_PERIOD 전환
 */
AS
    V_STEP        VARCHAR2(100 CHAR);
    V_FROM_DATE   VARCHAR2(30 CHAR);
    V_FROM_KEY    VARCHAR2(30 CHAR);
    V_FROM_LOW    VARCHAR2(31 CHAR);
    V_OFFSET_DAY  NUMBER;
    V_TO_DATE     VARCHAR2(8 CHAR);
BEGIN
    V_STEP := 'INPUT';
    V_FROM_DATE  := TRIM(P_FROM_DATE);
    V_OFFSET_DAY := TO_NUMBER(TRIM(P_OFFSET_DAY));

    /* 시작일이 비면 이번 주 월요일(AS-IS 도 시간대 미사용) */
    IF V_FROM_DATE IS NULL THEN
        V_FROM_DATE := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');
    END IF;

    /* AS-IS INT 인자 ISNULL(@p_offset_day,'')='' 는 0 도 빈값으로 판정 → 370 */
    IF V_OFFSET_DAY IS NULL OR V_OFFSET_DAY = 0 THEN
        V_OFFSET_DAY := 370;
    END IF;

    V_FROM_KEY := REPLACE(V_FROM_DATE, '-', '');
    V_FROM_LOW := F_SCM0001_LOW_BOUND(V_FROM_DATE);
    V_TO_DATE  := F_SCM0001_ADD_DAYS(V_FROM_KEY, V_OFFSET_DAY);

    V_STEP := 'O_RC1';
    IF V_OFFSET_DAY < 0 THEN
        OPEN O_RC1 FOR
            SELECT CASE WHEN MIN(BASIS_YYYYMMDD) IS NOT NULL
                        THEN MIN(BASIS_YYYYMMDD) || ':' || MAX(BASIS_YYYYMMDD)
                   END AS PERIOD
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD <= V_FROM_KEY
               AND BASIS_YYYYMMDD >= V_TO_DATE;
    ELSE
        OPEN O_RC1 FOR
            SELECT CASE WHEN MIN(BASIS_YYYYMMDD) IS NOT NULL
                        THEN MIN(BASIS_YYYYMMDD) || ':' || MAX(BASIS_YYYYMMDD)
                   END AS PERIOD
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= V_FROM_LOW
               AND BASIS_YYYYMMDD <= V_TO_DATE;
    END IF;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, '[PKG_COM0000.P_SCM0001_GET_WEEK_MONDAY_PERIOD] STEP=' || V_STEP
                                      || ' INPUT=' || P_FROM_DATE || '|' || P_OFFSET_DAY || '|' || P_TIMEZONE
                                      || ' / ' || SQLERRM);
END P_SCM0001_GET_WEEK_MONDAY_PERIOD;
-- 2026.09.17 AJS 공용 기간 조회 SCM0001_GET_SCP_DAY_PERIOD 외 3건 추가 (END)

-- 2026.10.06 AJS 공용 일별 계획 기간 SCM0001_GET_SCP_DAILY_PLAN_PERIOD 추가 (START)
PROCEDURE P_SCM0001_GET_SCP_DAILY_PLAN_PERIOD(
    P_DIVISION_ID   IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : PKG_COM0000
 * Description  : P_SCM0001_GET_SCP_DAILY_PLAN_PERIOD - 사업부별 일별 계획 기간 조회 (공용)
 *                결과 DAILY_PLAN_PERIOD = SCM_MST_DIVISION.DAILY_PLAN_PERIOD (사업부가 없으면 0행)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2021/06/15   khj79          [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - 최초작성
 * 2026.10.06   AJS            AS-IS SCM0001_GET_SCP_DAILY_PLAN_PERIOD 전환
 */
AS
    V_STEP        VARCHAR2(100 CHAR);
BEGIN
    V_STEP := 'O_RC1';
    /* AS-IS 대소문자 무시 비교 — 사업부 코드는 원장에 소문자 0건이라 인자만 UPPER */
    OPEN O_RC1 FOR
        SELECT DAILY_PLAN_PERIOD
          FROM SCM_MST_DIVISION
         WHERE DIVISION_ID = UPPER(P_DIVISION_ID);

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, '[PKG_COM0000.P_SCM0001_GET_SCP_DAILY_PLAN_PERIOD] STEP=' || V_STEP
                                      || ' INPUT=' || P_DIVISION_ID
                                      || ' / ' || SQLERRM);
END P_SCM0001_GET_SCP_DAILY_PLAN_PERIOD;
-- 2026.10.06 AJS 공용 일별 계획 기간 SCM0001_GET_SCP_DAILY_PLAN_PERIOD 추가 (END)


-- 2026.09.17 AJS 공용 기간 달력 헤더 SCP0009_GET_SHEET_CALENDAR_3SPAN 추가 (START)
PROCEDURE P_SCP0009_GET_SHEET_CALENDAR_3SPAN
    (
        P_START_YYYYMMDD    IN  VARCHAR2,
        P_END_YYYYMMDD      IN  VARCHAR2,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    /*
     * Program ID   : SCP0009_GET_SHEET_CALENDAR_3SPAN
     * Description  : SCP 칼렌더 생성위한 프로시저 (기간의 일·주·월 칼럼 헤더, SCP 다수 화면 공용)
     * Program History
     *===========================================================================================================
     *   Date       In Charge      Description
     *===========================================================================================================
     * 2018/11/20   KYH            Initial Release
     * 2026.09.17   AJS            [MSSQL -> Oracle 전환] 공용 패키지 편입
     *
     * AS-IS 원문 주석
     * Program ID  : SCP_GET_SHEET_CALENDAR_3SPAN
     * Usage       : exec SCP_GET_SHEET_CALENDAR_3SPAN
     * Parameter   : @p_start_yyyymmdd='2017-12-25'
     *               @p_end_yyyymmdd='20180130'
     * ex)
     * EXEC SCP0009_GET_SHEET_CALENDAR_3SPAN @p_start_yyyymmdd ='20180122' , @p_end_yyyymmdd='20180220'
     *
     * 전환 기준 (AS-IS 동작 재현)
     *   1. 인자는 AS-IS NVARCHAR(8) 이므로 앞 8자만 사용 ('2017-12-25' -> '2017-12-')
     *   2. AS-IS 비교 콜레이션(Latin1_General_CI_AS)은 하이픈(-)·아포스트로피(')를 무시하고
     *      기호·공백류를 숫자보다 앞에, 전각 숫자를 숫자와 같게 판정하므로 비교값을 같은 기준으로 변환
     *      ('2017-12-' -> '201712' : 2017년 12월 1일부터)
     *   3. 시작일이 빈값이면 AS-IS 는 '' 비교로 전체 기간 조회 -> 달력 첫날부터 조회
     *      (종료일 빈값은 AS-IS·TO-BE 모두 0건)
     *   4. DAY_CODE 빈 문자('')는 Oracle 에서 NULL
     */
    IS
        V_START_KEY     VARCHAR2(40);
        V_END_KEY       VARCHAR2(40);

        /* AS-IS 문자열 비교 기준으로 인자 변환 */
        FUNCTION F_COMPARE_KEY(P_VALUE IN VARCHAR2) RETURN VARCHAR2
        IS
            V_VALUE     VARCHAR2(40);
        BEGIN
            /* NVARCHAR(8) 절삭 */
            V_VALUE := SUBSTR(P_VALUE, 1, 8);
            /* 비교에서 무시되는 문자 제거 : 아포스트로피 · 하이픈 · 소프트 하이픈 · EN DASH */
            V_VALUE := TRANSLATE(V_VALUE
                               , CHR(1) || '''-' || UNISTR('\00AD\2013')
                               , CHR(1));
            /* 전각·위첨자 숫자는 숫자로, 숫자보다 앞에 정렬되는 기호·공백류는 공백으로 */
            V_VALUE := TRANSLATE(V_VALUE
                               , UNISTR('\FF10\FF11\FF12\FF13\FF14\FF15\FF16\FF17\FF18\FF19\00B9\00B2\00B3')
                                 || ':;<=>?@[\]^_`{|}~'
                                 || UNISTR('\3000\00A0')
                               , '0123456789123'
                                 || RPAD(' ', 19));
            RETURN V_VALUE;
        END F_COMPARE_KEY;

    BEGIN

        /* 시작일 빈값 = AS-IS '' 비교(전체) */
        V_START_KEY := NVL(F_COMPARE_KEY(P_START_YYYYMMDD), ' ');
        /* 종료일 빈값 = NULL 비교(0건), AS-IS '' 비교와 동일 결과 */
        V_END_KEY   := F_COMPARE_KEY(P_END_YYYYMMDD);

        OPEN O_RC1 FOR
            SELECT 'D_' || BASIS_YYYYMMDD           AS COLUMN_NAME
                 , CALENDAR_DAY                     AS COLUMN_LABEL_NAME
                 , WEEK_NAME                        AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                       AS LARGE_CLASS_LABEL_NAME
                 , DAYOFWEEK                        AS DAY_CODE
                 , BASIS_YYYYMMDD || '31'           AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= V_START_KEY
               AND BASIS_YYYYMMDD <= V_END_KEY
             UNION ALL
            SELECT 'W_' || BASIS_YYYYMM || ISO_WEEK AS COLUMN_NAME
                 , WEEK_NAME                        AS COLUMN_LABEL_NAME
                 , WEEK_NAME                        AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                       AS LARGE_CLASS_LABEL_NAME
                 , NULL                             AS DAY_CODE
                 , BASIS_START_DATE || '21'         AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= V_START_KEY
               AND BASIS_YYYYMMDD <= V_END_KEY
             GROUP BY BASIS_YYYYMM
                    , ISO_WEEK
                    , WEEK_NAME
                    , MONTH_NAME
                    , BASIS_START_DATE
             UNION ALL
            SELECT 'M_' || BASIS_YYYYMM             AS COLUMN_NAME
                 , MONTH_NAME                       AS COLUMN_LABEL_NAME
                 , MONTH_NAME                       AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                       AS LARGE_CLASS_LABEL_NAME
                 , NULL                             AS DAY_CODE
                 , MIN(BASIS_START_DATE) || '01'    AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= V_START_KEY
               AND BASIS_YYYYMMDD <= V_END_KEY
             GROUP BY BASIS_YYYYMM
                    , MONTH_NAME
             ORDER BY SORT_ORDER_NO;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN] ' || SQLERRM);
    END P_SCP0009_GET_SHEET_CALENDAR_3SPAN;
-- 2026.09.17 AJS 공용 기간 달력 헤더 SCP0009_GET_SHEET_CALENDAR_3SPAN 추가 (END)

-- 2026.09.18 AJS 공용 기본 계획 버전 SCP0011_GET_LAST_PLAN_VERSION · 생산계획 라인 저장 SCP0011_SAVE_PRODUCTION_PLAN_LINE 추가 (START)
PROCEDURE P_SCP0011_GET_LAST_PLAN_VER
    (
        P_DIVISION_ID       IN  VARCHAR2,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    /*
     * Program ID   : SCP0011_GET_LAST_PLAN_VERSION
     * Description  : PLAN VERSION 기본값 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/02/20   PJS    			Initial Release  전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2026.09.18   AJS             [MSSQL -> Oracle 전환] 공용 패키지 편입 (PKG_SCP0009 사본 본문 + 사업부 대소문자 무시)
     * ex)
     * EXEC [SCP0011_GET_LAST_PLAN_VERSION] @p_division_id='81'
     */
    IS
        V_PLAN_VERSION      VARCHAR2(100 CHAR);
    BEGIN

        /* AS-IS 는 대소문자 · 뒤 공백을 구분하지 않는다 - 사업부 ID 원장은 모두 대문자 */
        V_PLAN_VERSION := FN_GET_SCP_LAST_PLAN_VERSION_ID(RTRIM(UPPER(P_DIVISION_ID)));

        OPEN O_RC1 FOR
        SELECT FN_SCM_SPLIT(V_PLAN_VERSION, 1, '-')                AS PLAN_START_YYYYMMDD
             , FN_SCM_SPLIT(V_PLAN_VERSION, 2, '-')                AS PLAN_TYPE
             , TO_CHAR(TO_NUMBER(FN_SCM_SPLIT(V_PLAN_VERSION, 3, '-') DEFAULT NULL ON CONVERSION ERROR))  AS PLAN_SEQ
          FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'                                                  AS CODE
             , 'SUCCESS'                                            AS MSG
             , '0'                                                  AS EVENT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[PKG_COM0000.P_SCP0011_GET_LAST_PLAN_VER] ' || SQLERRM);
    END P_SCP0011_GET_LAST_PLAN_VER;


PROCEDURE P_SCP0011_SAVE_PROD_PLAN_LINE
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_PLAN_START_YYYYMMDD   IN  CLOB,
        P_PLAN_TYPE             IN  CLOB,
        P_SEQ                   IN  CLOB,
        P_OPERATION_GROUP       IN  CLOB,
        P_SCM_SITE_ID           IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_OPERATION_ID          IN  CLOB,
        P_MEASURE               IN  CLOB,
        P_YYYYMMDD              IN  CLOB,
        P_QTY                   IN  CLOB,
        P_USER_ID               IN  CLOB,
        P_FIX                   IN  CLOB,
        P_ELECTRODE_TYPE        IN  CLOB DEFAULT NULL,
        P_ORIGIN_DIVISION_ID    IN  CLOB DEFAULT NULL,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0011',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    /*
     * Program ID   : [SCP0011_SAVE_PRODUCTION_PLAN_LINE]
     * Description  : Production Plan의 Line "Prod. Plan(Amend)" Measure저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/05/17   PJS   SInitial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/05/23   PJS	  FIX값 저장 기능 추가
     * 2018/07/18	YHW	  전극용 데이터 저장 추가(ORIGIN_DIVISION_ID, ELECTRODE_TYPE)
     * 2025/11/11   hrkim [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선
     *						: ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
     * 2026.09.18   AJS   [MSSQL -> Oracle 전환] 공용 패키지 편입
     *                    - MERGE 는 갱신 후 0 건이면 추가로 전환
     *                    - 기준 데이터베이스는 계획 원장 PK 제약이 꺼져 있어, AS-IS 에서 PK 위반으로 실패하던 경우를 같은 오류로 막음
     *                    - 이력 저장 PR_SCP_ANL_PRODUCTION_PLAN_HIST · PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST 는 본문 안 추가문으로 흡수
     *                    - 입력이 크므로 CLOB 로 받아 한 번에 분리 (빈 칸 : NOT NULL 칸은 '-', 수량은 NULL)
     */
    IS
        TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;

        T_ACTIVE_FLAG           T_TOKEN_TAB;
        T_DIVISION_ID           T_TOKEN_TAB;
        T_PLAN_START_YYYYMMDD   T_TOKEN_TAB;
        T_PLAN_TYPE             T_TOKEN_TAB;
        T_SEQ                   T_TOKEN_TAB;
        T_OPERATION_GROUP       T_TOKEN_TAB;
        T_SCM_SITE_ID           T_TOKEN_TAB;
        T_ITEM_ID               T_TOKEN_TAB;
        T_LINE_ID               T_TOKEN_TAB;
        T_OPERATION_ID          T_TOKEN_TAB;
        T_MEASURE               T_TOKEN_TAB;
        T_YYYYMMDD              T_TOKEN_TAB;
        T_QTY                   T_TOKEN_TAB;
        T_USER_ID               T_TOKEN_TAB;
        T_FIX                   T_TOKEN_TAB;
        T_ELECTRODE_TYPE        T_TOKEN_TAB;
        T_ORIGIN_DIVISION_ID    T_TOKEN_TAB;

        V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
        V_DIVISION_ID           VARCHAR2(4000 CHAR);
        V_PLAN_START_YYYYMMDD   VARCHAR2(4000 CHAR);
        V_PLAN_TYPE             VARCHAR2(4000 CHAR);
        V_SEQ                   NUMBER;
        V_OPERATION_GROUP       VARCHAR2(4000 CHAR);
        V_SCM_SITE_ID           VARCHAR2(4000 CHAR);
        V_ITEM_ID               VARCHAR2(4000 CHAR);
        V_LINE_ID               VARCHAR2(4000 CHAR);
        V_OPERATION_ID          VARCHAR2(4000 CHAR);
        V_MEASURE               VARCHAR2(4000 CHAR);
        V_YYYYMMDD              VARCHAR2(4000 CHAR);
        V_QTY                   NUMBER;
        V_FIX                   VARCHAR2(4000 CHAR);
        V_ELECTRODE_TYPE        VARCHAR2(4000 CHAR);
        V_ORIGIN_DIVISION_ID    VARCHAR2(4000 CHAR);
        V_PLAN_START_DATE       DATE;

        V_CREATED_BY            VARCHAR2(4000 CHAR);
        V_CREATION_DATE         DATE := SYSDATE;
        V_LAST_UPDATED_BY       VARCHAR2(4000 CHAR);

        V_SEQ_STR               VARCHAR2(4000 CHAR);
        V_QTY_STR               VARCHAR2(4000 CHAR);

        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_DUMMY_CNT             PLS_INTEGER;
        V_HAS_DATA              VARCHAR2(1 CHAR) := 'N';

        -- LOG 용 변수 설정
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := '[SCP0011_SAVE_PRODUCTION_PLAN_LINE]';
        V_LOG_TYPE              VARCHAR2(30 CHAR); -- START/END/ERROR/...
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;

        V_FIX_ID                VARCHAR2(100 CHAR);
        V_CNT                   PLS_INTEGER;

        -- 예외처리 변수 설정
        V_ERR_CODE              NUMBER;
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);

        /* '^' 분리 (AS-IS SCM_ARR_SPL_CNT · SCM_ARR_SPL_VAL 대응 - 토큰 앞뒤 공백 제거, 빈 토큰은 NULL) */
        PROCEDURE P_SPLIT_TOKEN
        (
            P_STR       IN  CLOB,
            O_TAB       OUT T_TOKEN_TAB,
            O_CNT       OUT PLS_INTEGER
        )
        IS
            V_POS       PLS_INTEGER;
            V_FROM      PLS_INTEGER := 1;
            V_NR        PLS_INTEGER := 0;
            V_LEN       PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_STR), 0);
        BEGIN
            IF V_LEN = 0 THEN
                O_CNT := 0;
                RETURN;
            END IF;

            LOOP
                V_POS := DBMS_LOB.INSTR(P_STR, '^', V_FROM, 1);

                EXIT WHEN V_POS = 0 OR V_POS IS NULL;

                V_NR := V_NR + 1;

                IF V_POS > V_FROM THEN
                    O_TAB(V_NR) := TRIM(DBMS_LOB.SUBSTR(P_STR, V_POS - V_FROM, V_FROM));
                END IF;

                V_FROM := V_POS + 1;
            END LOOP;

            V_NR := V_NR + 1;

            IF V_FROM <= V_LEN THEN
                O_TAB(V_NR) := TRIM(DBMS_LOB.SUBSTR(P_STR, V_LEN - V_FROM + 1, V_FROM));
            END IF;

            O_CNT := V_NR;
        END P_SPLIT_TOKEN;

        /* 토큰 꺼내기 - 없는 순번이면 NULL (AS-IS SCM_ARR_SPL_VAL 과 같음) */
        FUNCTION F_TOKEN
        (
            P_TAB       IN  T_TOKEN_TAB,
            P_IDX       IN  PLS_INTEGER
        )
        RETURN VARCHAR2
        IS
        BEGIN
            IF P_TAB.EXISTS(P_IDX) THEN
                RETURN P_TAB(P_IDX);
            END IF;

            RETURN NULL;
        END F_TOKEN;

    BEGIN

        -- SCP0011, SCP0013에서 공용으로 사용하는 프로시져 이기 때문에 SCP0013에서 호출되었을 경우 @v_program_name 변경
        IF P_PROGRAM_ID = 'SCP0013' THEN
            V_PROGRAM_NAME := 'SCP0013';
        END IF;

        -- 시작 LOG
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        -------------------------------------------------------------------------------------------------------------------------------------------------------
        --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
        -- JV/ESS 라인 및 scm site 매핑 정보 추출
        -------------------------------------------------------------------------------------------------------------------------------------------------------
        DELETE FROM GT_0011_JV_LINE_MAP;
        DELETE FROM GT_0011_JV_SITE_MAP;
        DELETE FROM GT_0011_LAST_PLAN;
        DELETE FROM GT_0011_JV_SYNC;

        INSERT INTO GT_0011_JV_LINE_MAP
             (
               VL_COMPANY_ID
              ,VL_DIVISION_ID
              ,VL_SITE_ID
              ,VL_PLANT_ID
              ,VL_FACTORY_ID
              ,VL_LINE_ID
              ,RL_COMPANY_ID
              ,RL_DIVISION_ID
              ,RL_SITE_ID
              ,RL_PLANT_ID
              ,RL_FACTORY_ID
              ,RL_LINE_ID
             )
        SELECT VL_COMPANY_ID
             , VL_DIVISION_ID
             , VL_SITE_ID
             , VL_PLANT_ID
             , VL_FACTORY_ID
             , VL_LINE_ID
             , RL_COMPANY_ID
             , RL_DIVISION_ID
             , RL_SITE_ID
             , RL_PLANT_ID
             , RL_FACTORY_ID
             , RL_LINE_ID
          FROM TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP());

        INSERT INTO GT_0011_JV_SITE_MAP
             (
               VP_COMPANY_ID
              ,VP_DIVISION_ID
              ,VP_SITE_ID
              ,VP_PLANT_ID
              ,VP_SCM_SITE_ID
              ,RP_COMPANY_ID
              ,RP_DIVISION_ID
              ,RP_SITE_ID
              ,RP_PLANT_ID
              ,RP_SCM_SITE_ID
             )
        SELECT VP_COMPANY_ID
             , VP_DIVISION_ID
             , VP_SITE_ID
             , VP_PLANT_ID
             , VP_SCM_SITE_ID
             , RP_COMPANY_ID
             , RP_DIVISION_ID
             , RP_SITE_ID
             , RP_PLANT_ID
             , RP_SCM_SITE_ID
          FROM TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP());

        ------------------------------------------------------------------------------------------------------------
        -- DIVISION 주차별 최종 수행 Plan 버전 정보
        -- ESS 가상 라인 매핑 JV division의 동기화 대상 버전 정보 확인을 위한 데이터
        -- Final Plan은 수정 대상에서 제외 ?
        ------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0011_LAST_PLAN
             (
               DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,PLAN_SEQ
             )
        SELECT IA.DIVISION_ID
             , IA.PLAN_START_YYYYMMDD
             , IA.PLAN_TYPE
             , IA.PLAN_SEQ
          FROM (SELECT B.DIVISION_ID
                     , A.PLAN_NAME                                  AS PLAN_START_YYYYMMDD
                     , B.PLAN_TYPE
                     , B.PLAN_SEQ
                     , ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
                                                     , A.PLAN_NAME
                                              ORDER BY CASE
                                                           WHEN B.PLAN_TYPE = 'PR' THEN 4
                                                           WHEN B.PLAN_TYPE = 'MA' THEN 3
                                                           WHEN B.PLAN_TYPE = 'SE' THEN 2
                                                           WHEN B.PLAN_TYPE = 'FN' THEN 1
                                                           ELSE 0
                                                       END
                                                     , B.PLAN_SEQ         DESC NULLS LAST      /* AS-IS 내림차순은 NULL 이 뒤 */
                                                     , B.INPUT_START_DATE DESC NULLS LAST) AS RN
                  FROM SCM_MST_PLAN         A
                     , SCM_MST_PLAN_DETAIL  B
                     , SCM_MST_DIVISION     C
                 WHERE B.DIVISION_ID  = A.DIVISION_ID
                   AND B.PLAN_ID      = A.PLAN_ID
                   AND C.DIVISION_ID  = A.DIVISION_ID
                   AND B.PLAN_STATUS  = '1'
                   AND C.ATTRIBUTE3  != 'EE'
                   AND A.PLAN_CYCLE   = 'WEEKLY'
                   AND A.PLAN_NAME   >= TO_CHAR(TRUNC(SYSDATE) - 20, 'YYYYMMDD')) IA
         WHERE IA.RN         = 1
           AND IA.PLAN_TYPE != 'FN'; -- Final plan 대상에서 제외
        ------------------------------------------------------------------------------------------------------------------------------
        --### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
        ------------------------------------------------------------------------------------------------------------------------------

        /* 행 단위 입력 분리 */
        P_SPLIT_TOKEN(P_ACTIVE_FLAG        , T_ACTIVE_FLAG        , V_MAX_LOOP_CNT);   -- 프로시저 LOOP 길이를 판단
        P_SPLIT_TOKEN(P_DIVISION_ID        , T_DIVISION_ID        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PLAN_START_YYYYMMDD, T_PLAN_START_YYYYMMDD, V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PLAN_TYPE          , T_PLAN_TYPE          , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_SEQ                , T_SEQ                , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_OPERATION_GROUP    , T_OPERATION_GROUP    , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_SCM_SITE_ID        , T_SCM_SITE_ID        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_ITEM_ID            , T_ITEM_ID            , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_LINE_ID            , T_LINE_ID            , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_OPERATION_ID       , T_OPERATION_ID       , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_MEASURE            , T_MEASURE            , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_YYYYMMDD           , T_YYYYMMDD           , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_QTY                , T_QTY                , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_USER_ID            , T_USER_ID            , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_FIX                , T_FIX                , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_ELECTRODE_TYPE     , T_ELECTRODE_TYPE     , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_ORIGIN_DIVISION_ID , T_ORIGIN_DIVISION_ID , V_DUMMY_CNT);

        /* AS-IS 반복 조건 LEN(@p_active_flag) > 0 - 공백만 있는 값도 빈 값 */
        IF RTRIM(DBMS_LOB.SUBSTR(P_ACTIVE_FLAG, 32767, 1)) IS NOT NULL THEN
            V_HAS_DATA := 'Y';
        END IF;

        WHILE V_HAS_DATA = 'Y' AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            -- @mst_loop_cnt 1증가
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            -- 각 컬럼들에 대한 스플릿처리로직 스타트
            V_ACTIVE_FLAG         := F_TOKEN(T_ACTIVE_FLAG        , V_MST_LOOP_CNT);
            V_DIVISION_ID         := F_TOKEN(T_DIVISION_ID        , V_MST_LOOP_CNT);
            V_PLAN_START_YYYYMMDD := F_TOKEN(T_PLAN_START_YYYYMMDD, V_MST_LOOP_CNT);
            V_PLAN_TYPE           := F_TOKEN(T_PLAN_TYPE          , V_MST_LOOP_CNT);
            V_SEQ_STR             := F_TOKEN(T_SEQ                , V_MST_LOOP_CNT);
            V_OPERATION_GROUP     := F_TOKEN(T_OPERATION_GROUP    , V_MST_LOOP_CNT);
            V_SCM_SITE_ID         := F_TOKEN(T_SCM_SITE_ID        , V_MST_LOOP_CNT);
            V_ITEM_ID             := F_TOKEN(T_ITEM_ID            , V_MST_LOOP_CNT);
            V_LINE_ID             := F_TOKEN(T_LINE_ID            , V_MST_LOOP_CNT);
            V_OPERATION_ID        := F_TOKEN(T_OPERATION_ID       , V_MST_LOOP_CNT);
            V_MEASURE             := F_TOKEN(T_MEASURE            , V_MST_LOOP_CNT);
            V_YYYYMMDD            := F_TOKEN(T_YYYYMMDD           , V_MST_LOOP_CNT);
            V_QTY_STR             := F_TOKEN(T_QTY                , V_MST_LOOP_CNT);
            V_FIX                 := F_TOKEN(T_FIX                , V_MST_LOOP_CNT);
            V_ELECTRODE_TYPE      := F_TOKEN(T_ELECTRODE_TYPE     , V_MST_LOOP_CNT);
            V_ORIGIN_DIVISION_ID  := F_TOKEN(T_ORIGIN_DIVISION_ID , V_MST_LOOP_CNT);

            V_CREATED_BY          := F_TOKEN(T_USER_ID            , V_MST_LOOP_CNT);
            V_LAST_UPDATED_BY     := F_TOKEN(T_USER_ID            , V_MST_LOOP_CNT);

            -- LOOP 파라미터 출력 DEBUG용
            IF P_DEBUG_MODE = 'T' THEN
                DBMS_OUTPUT.PUT_LINE('===============================================');
                DBMS_OUTPUT.PUT_LINE('@v_active_flag		  = ' || V_ACTIVE_FLAG);
                DBMS_OUTPUT.PUT_LINE('@v_division_id         = ' || V_DIVISION_ID);
                DBMS_OUTPUT.PUT_LINE('@v_plan_start_yyyymmdd = ' || V_PLAN_START_YYYYMMDD);
                DBMS_OUTPUT.PUT_LINE('@v_plan_type           = ' || V_PLAN_TYPE);
                DBMS_OUTPUT.PUT_LINE('@v_seq                 = ' || V_SEQ_STR);
                DBMS_OUTPUT.PUT_LINE('@v_operation_group     = ' || V_OPERATION_GROUP);
                DBMS_OUTPUT.PUT_LINE('@v_scm_site_id         = ' || V_SCM_SITE_ID);
                DBMS_OUTPUT.PUT_LINE('@v_item_id             = ' || V_ITEM_ID);
                DBMS_OUTPUT.PUT_LINE('@v_line_id             = ' || V_LINE_ID);
                DBMS_OUTPUT.PUT_LINE('@v_operation_id        = ' || V_OPERATION_ID);
                DBMS_OUTPUT.PUT_LINE('@v_measure             = ' || V_MEASURE);
                DBMS_OUTPUT.PUT_LINE('@v_yyyymmdd            = ' || V_YYYYMMDD);
                DBMS_OUTPUT.PUT_LINE('@v_qty                 = ' || V_QTY_STR);
                DBMS_OUTPUT.PUT_LINE('@v_fix                 = ' || V_FIX);
                DBMS_OUTPUT.PUT_LINE('@v_electrode_type      = ' || V_ELECTRODE_TYPE);
                DBMS_OUTPUT.PUT_LINE('@v_origin_division_id  = ' || V_ORIGIN_DIVISION_ID);
                DBMS_OUTPUT.PUT_LINE('@v_created_by		  = ' || V_CREATED_BY);
                DBMS_OUTPUT.PUT_LINE('@v_last_updated_by	  = ' || V_LAST_UPDATED_BY);
            END IF;

            -------------------------------------------------------------------------------------------------------------------------------------------------------
            --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
            -- ESS 가상 라인에 매핑된 JV 라인 계획 skip처리 (단방향 저장)
            -------------------------------------------------------------------------------------------------------------------------------------------------------
            SELECT COUNT(*)
              INTO V_CNT
              FROM GT_0011_JV_LINE_MAP A
                 , GT_0011_JV_SITE_MAP B
             WHERE B.RP_COMPANY_ID  = A.RL_COMPANY_ID
               AND B.RP_DIVISION_ID = A.RL_DIVISION_ID
               AND B.RP_SITE_ID     = A.RL_SITE_ID
               AND B.RP_PLANT_ID    = A.RL_PLANT_ID
               AND B.RP_DIVISION_ID = V_DIVISION_ID
               AND B.RP_SCM_SITE_ID = V_SCM_SITE_ID
               AND A.RL_LINE_ID     = V_LINE_ID
               AND ROWNUM           = 1;

            CONTINUE WHEN V_CNT > 0;   -- ESS 가상 라인에 매핑된 JV Real line이면 skip

            -------------------------------------------------------------------------------------------------------------------------------------------------------
            -- ESS 가상 라인에 매핑된 동기화 대상 JV 라인 정보
            -------------------------------------------------------------------------------------------------------------------------------------------------------
            DELETE FROM GT_0011_JV_SYNC;

            INSERT INTO GT_0011_JV_SYNC
                 (
                   RP_DIVISION_ID
                  ,RP_SCM_SITE_ID
                  ,RL_LINE_ID
                 )
            SELECT DISTINCT
                   B.RP_DIVISION_ID
                 , B.RP_SCM_SITE_ID
                 , A.RL_LINE_ID
              FROM GT_0011_JV_LINE_MAP A
                 , GT_0011_JV_SITE_MAP B
             WHERE B.VP_COMPANY_ID  = A.VL_COMPANY_ID
               AND B.VP_DIVISION_ID = A.VL_DIVISION_ID
               AND B.VP_SITE_ID     = A.VL_SITE_ID
               AND B.VP_PLANT_ID    = A.VL_PLANT_ID
               AND B.VP_DIVISION_ID = V_DIVISION_ID
               AND B.VP_SCM_SITE_ID = V_SCM_SITE_ID
               AND A.VL_LINE_ID     = V_LINE_ID;
            -------------------------------------------------------------------------------------------------------------------------------------------------------
            --### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
            -------------------------------------------------------------------------------------------------------------------------------------------------------

            /* 숫자 변환은 AS-IS 와 같이 건너뛰기 판정 뒤(이력 저장 시점)에 한다.
               사용자 입력 칸 - 숫자가 아니면 AS-IS 처럼 오류. 원장 칸 자릿수 NUMERIC(20,10) 에 맞춤 */
            V_SEQ := TO_NUMBER(V_SEQ_STR);
            V_QTY := ROUND(TO_NUMBER(V_QTY_STR), 10);

            SELECT TO_DATE(V_PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD')
              INTO V_PLAN_START_DATE
              FROM DUAL;

            --이력저장 (AS-IS PR_SCP_ANL_PRODUCTION_PLAN_HIST)
            INSERT INTO SCP_ANL_PRODUCTION_PLAN_H
                 (
                   HISTORY_SEQ
                  ,DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,LINE_ID
                  ,OPERATION_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,CREATED_BY
                  ,CREATION_DATE
                  ,LAST_UPDATED_BY
                  ,LAST_UPDATE_DATE
                  ,HISTORY_CREATION_DATE
                 )
            VALUES
                 (
                   SEQ1_SCP_ANL_PRODUCTION_PLAN_H.NEXTVAL
                  ,NVL(V_DIVISION_ID, '-')
                  ,NVL(V_PLAN_START_YYYYMMDD, '-')
                  ,NVL(V_PLAN_TYPE, '-')
                  ,V_SEQ
                  ,NVL(V_OPERATION_GROUP, '-')
                  ,NVL(V_SCM_SITE_ID, '-')
                  ,NVL(V_ITEM_ID, '-')
                  ,NVL(V_LINE_ID, '-')
                  ,NVL(V_OPERATION_ID, '-')
                  ,NVL(V_MEASURE, '-')
                  ,NVL(V_YYYYMMDD, '-')
                  ,V_QTY
                  ,V_ORIGIN_DIVISION_ID
                  ,V_ELECTRODE_TYPE
                  ,NVL(V_CREATED_BY, '-')
                  ,V_CREATION_DATE
                  ,NVL(V_LAST_UPDATED_BY, '-')
                  ,SYSDATE
                  ,SYSDATE
                 );

            --데이터 저장
            -- 수정
            IF V_ACTIVE_FLAG IN ('M', 'I', 'm', 'i') THEN

                UPDATE SCP_ANL_PRODUCTION_PLAN
                   SET QTY                      = V_QTY
                     , LAST_UPDATED_BY          = NVL(V_LAST_UPDATED_BY, '-')
                     , LAST_UPDATE_DATE         = V_CREATION_DATE
                 WHERE DIVISION_ID              = V_DIVISION_ID
                   AND PLAN_START_YYYYMMDD      = V_PLAN_START_YYYYMMDD
                   AND PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE          /* 파티션 프루닝 */
                   AND PLAN_TYPE                = V_PLAN_TYPE
                   AND SEQ                      = V_SEQ
                   AND OPERATION_GROUP          = V_OPERATION_GROUP
                   AND SCM_SITE_ID              = V_SCM_SITE_ID
                   AND ITEM_ID                  = V_ITEM_ID
                   AND LINE_ID                  = V_LINE_ID
                   AND OPERATION_ID             = V_OPERATION_ID
                   AND MEASURE                  = V_MEASURE
                   AND YYYYMMDD                 = V_YYYYMMDD
                   AND NVL(ELECTRODE_TYPE, '-') = NVL(V_ELECTRODE_TYPE, '-');

                IF SQL%ROWCOUNT = 0 THEN

                    /* 기준 데이터베이스는 계획 원장 PK 제약이 꺼져 있다. AS-IS 는 같은 키(전극 구분만 다름)가 있으면 PK 위반으로 실패한다 */
                    SELECT COUNT(*)
                      INTO V_CNT
                      FROM SCP_ANL_PRODUCTION_PLAN
                     WHERE DIVISION_ID              = V_DIVISION_ID
                       AND PLAN_START_YYYYMMDD      = V_PLAN_START_YYYYMMDD
                       AND PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE
                       AND PLAN_TYPE                = V_PLAN_TYPE
                       AND SEQ                      = V_SEQ
                       AND OPERATION_GROUP          = V_OPERATION_GROUP
                       AND SCM_SITE_ID              = V_SCM_SITE_ID
                       AND ITEM_ID                  = V_ITEM_ID
                       AND LINE_ID                  = V_LINE_ID
                       AND OPERATION_ID             = V_OPERATION_ID
                       AND MEASURE                  = V_MEASURE
                       AND YYYYMMDD                 = V_YYYYMMDD
                       AND ROWNUM                   = 1;

                    IF V_CNT > 0 THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Violation of PRIMARY KEY constraint ''PK_SCP_ANL_PRODUCTION_PLAN''. Cannot insert duplicate key in object ''dbo.scp_anl_production_plan''.');
                    END IF;

                    INSERT INTO SCP_ANL_PRODUCTION_PLAN
                         (
                           DIVISION_ID
                          ,PLAN_START_YYYYMMDD
                          ,PLAN_TYPE
                          ,SEQ
                          ,OPERATION_GROUP
                          ,SCM_SITE_ID
                          ,ITEM_ID
                          ,LINE_ID
                          ,OPERATION_ID
                          ,MEASURE
                          ,YYYYMMDD
                          ,QTY
                          ,CREATED_BY
                          ,CREATION_DATE
                          ,LAST_UPDATED_BY
                          ,LAST_UPDATE_DATE
                          ,ORIGIN_DIVISION_ID
                          ,ELECTRODE_TYPE
                         )
                    VALUES
                         (
                           NVL(V_DIVISION_ID, '-')
                          ,NVL(V_PLAN_START_YYYYMMDD, '-')
                          ,NVL(V_PLAN_TYPE, '-')
                          ,V_SEQ
                          ,NVL(V_OPERATION_GROUP, '-')
                          ,NVL(V_SCM_SITE_ID, '-')
                          ,NVL(V_ITEM_ID, '-')
                          ,NVL(V_LINE_ID, '-')
                          ,NVL(V_OPERATION_ID, '-')
                          ,NVL(V_MEASURE, '-')
                          ,NVL(V_YYYYMMDD, '-')
                          ,V_QTY
                          ,NVL(V_CREATED_BY, '-')
                          ,V_CREATION_DATE
                          ,NVL(V_LAST_UPDATED_BY, '-')
                          ,V_CREATION_DATE
                          ,V_ORIGIN_DIVISION_ID
                          ,V_ELECTRODE_TYPE
                         );

                END IF;

                -------------------------------------------------------------------------------------------------------------------------------------------------------
                --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
                -- PK : DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD
                -- ESS 가상 라인에 매핑된 동기화 대상 JV 라인 계획 Insert/Update
                -------------------------------------------------------------------------------------------------------------------------------------------------------
                FOR R IN (SELECT C.RP_DIVISION_ID                   AS DIVISION_ID
                               , A.PLAN_START_YYYYMMDD
                               , B.PLAN_TYPE
                               , B.PLAN_SEQ                         AS SEQ
                               , A.OPERATION_GROUP
                               , C.RP_SCM_SITE_ID                   AS SCM_SITE_ID
                               , A.ITEM_ID
                               , C.RL_LINE_ID                       AS LINE_ID
                               , A.OPERATION_ID
                               , A.MEASURE
                               , A.YYYYMMDD
                               , A.QTY
                               , C.RP_DIVISION_ID                   AS ORIGIN_DIVISION_ID   -- 전극은 대상이 아니기 때문에 division_id와 origin division_id 일치 ?
                               , A.ELECTRODE_TYPE
                               , A.CELL_QTY
                            FROM SCP_ANL_PRODUCTION_PLAN    A      -- ESS Plan
                               , GT_0011_LAST_PLAN          B
                               , GT_0011_JV_SYNC            C
                           WHERE B.DIVISION_ID              = C.RP_DIVISION_ID
                             AND B.PLAN_START_YYYYMMDD      = A.PLAN_START_YYYYMMDD
                             AND A.DIVISION_ID              = V_DIVISION_ID
                             AND A.PLAN_START_YYYYMMDD      = V_PLAN_START_YYYYMMDD
                             AND A.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE
                             AND A.PLAN_TYPE                = V_PLAN_TYPE
                             AND A.SEQ                      = V_SEQ
                             AND A.OPERATION_GROUP          = V_OPERATION_GROUP
                             AND A.SCM_SITE_ID              = V_SCM_SITE_ID
                             AND A.ITEM_ID                  = V_ITEM_ID
                             AND A.LINE_ID                  = V_LINE_ID
                             AND A.OPERATION_ID             = V_OPERATION_ID
                             AND A.MEASURE                  = V_MEASURE
                             AND A.YYYYMMDD                 = V_YYYYMMDD)
                LOOP
                    UPDATE SCP_ANL_PRODUCTION_PLAN
                       SET QTY                      = R.QTY
                         , LAST_UPDATED_BY          = NVL(V_LAST_UPDATED_BY, '-')
                         , LAST_UPDATE_DATE         = SYSDATE
                     WHERE DIVISION_ID              = R.DIVISION_ID
                       AND PLAN_START_YYYYMMDD      = R.PLAN_START_YYYYMMDD
                       AND PLAN_TYPE                = R.PLAN_TYPE
                       AND SEQ                      = R.SEQ
                       AND OPERATION_GROUP          = R.OPERATION_GROUP
                       AND SCM_SITE_ID              = R.SCM_SITE_ID
                       AND ITEM_ID                  = R.ITEM_ID
                       AND LINE_ID                  = R.LINE_ID
                       AND OPERATION_ID             = R.OPERATION_ID
                       AND MEASURE                  = R.MEASURE
                       AND YYYYMMDD                 = R.YYYYMMDD;

                    IF SQL%ROWCOUNT = 0 THEN
                        INSERT INTO SCP_ANL_PRODUCTION_PLAN
                             (
                               DIVISION_ID
                              ,PLAN_START_YYYYMMDD
                              ,PLAN_TYPE
                              ,SEQ
                              ,OPERATION_GROUP
                              ,SCM_SITE_ID
                              ,ITEM_ID
                              ,LINE_ID
                              ,OPERATION_ID
                              ,MEASURE
                              ,YYYYMMDD
                              ,QTY
                              ,ORIGIN_DIVISION_ID
                              ,ELECTRODE_TYPE
                              ,CREATED_BY
                              ,CREATION_DATE
                              ,LAST_UPDATED_BY
                              ,LAST_UPDATE_DATE
                              ,CELL_QTY
                             )
                        VALUES
                             (
                               R.DIVISION_ID
                              ,R.PLAN_START_YYYYMMDD
                              ,R.PLAN_TYPE
                              ,R.SEQ
                              ,R.OPERATION_GROUP
                              ,R.SCM_SITE_ID
                              ,R.ITEM_ID
                              ,R.LINE_ID
                              ,R.OPERATION_ID
                              ,R.MEASURE
                              ,R.YYYYMMDD
                              ,R.QTY
                              ,R.ORIGIN_DIVISION_ID
                              ,R.ELECTRODE_TYPE
                              ,NVL(V_LAST_UPDATED_BY, '-')
                              ,SYSDATE
                              ,NVL(V_LAST_UPDATED_BY, '-')
                              ,SYSDATE
                              ,R.CELL_QTY
                             );
                    END IF;
                END LOOP;

                -------------------------------------------------------------------------------------------------------------------------------------------------------
                -- ESS 가상 라인에 매핑된 동기화 대상 JV 라인 계획 이력 생성
                -------------------------------------------------------------------------------------------------------------------------------------------------------
                INSERT INTO SCP_ANL_PRODUCTION_PLAN_H
                     (
                       HISTORY_SEQ
                      ,DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,SEQ
                      ,OPERATION_GROUP
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,LINE_ID
                      ,OPERATION_ID
                      ,MEASURE
                      ,YYYYMMDD
                      ,QTY
                      ,ORIGIN_DIVISION_ID
                      ,ELECTRODE_TYPE
                      ,CREATED_BY
                      ,CREATION_DATE
                      ,LAST_UPDATED_BY
                      ,LAST_UPDATE_DATE
                      ,ATTRIBUTE1
                      ,ATTRIBUTE2
                      ,ATTRIBUTE3
                      ,ATTRIBUTE4
                      ,ATTRIBUTE5
                      ,ATTRIBUTE6
                      ,ATTRIBUTE7
                      ,ATTRIBUTE8
                      ,ATTRIBUTE9
                      ,ATTRIBUTE10
                      ,HISTORY_CREATION_DATE
                     )
                SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_H.NEXTVAL       AS HISTORY_SEQ
                     , C.DIVISION_ID
                     , C.PLAN_START_YYYYMMDD
                     , C.PLAN_TYPE
                     , C.SEQ
                     , C.OPERATION_GROUP
                     , C.SCM_SITE_ID
                     , C.ITEM_ID
                     , C.LINE_ID
                     , C.OPERATION_ID
                     , C.MEASURE
                     , C.YYYYMMDD
                     , C.QTY
                     , C.ORIGIN_DIVISION_ID
                     , C.ELECTRODE_TYPE
                     , C.CREATED_BY
                     , C.CREATION_DATE
                     , C.LAST_UPDATED_BY
                     , C.LAST_UPDATE_DATE
                     , C.ATTRIBUTE1
                     , C.ATTRIBUTE2
                     , C.ATTRIBUTE3
                     , C.ATTRIBUTE4
                     , C.ATTRIBUTE5
                     , C.ATTRIBUTE6
                     , C.ATTRIBUTE7
                     , C.ATTRIBUTE8
                     , C.ATTRIBUTE9
                     , C.ATTRIBUTE10
                     , SYSDATE                                      AS HISTORY_CREATION_DATE
                  FROM GT_0011_JV_SYNC          A
                     , GT_0011_LAST_PLAN        B
                     , SCP_ANL_PRODUCTION_PLAN  C
                 WHERE B.DIVISION_ID              = A.RP_DIVISION_ID      -- JV division
                   AND C.DIVISION_ID              = A.RP_DIVISION_ID      -- JV division
                   AND C.PLAN_TYPE                = B.PLAN_TYPE
                   AND C.SEQ                      = B.PLAN_SEQ
                   AND C.SCM_SITE_ID              = A.RP_SCM_SITE_ID      -- JV Real scm site_id
                   AND C.LINE_ID                  = A.RL_LINE_ID          -- JV Real line
                   AND B.PLAN_START_YYYYMMDD      = V_PLAN_START_YYYYMMDD
                   AND C.PLAN_START_YYYYMMDD      = V_PLAN_START_YYYYMMDD
                   AND C.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE
                   AND C.OPERATION_GROUP          = V_OPERATION_GROUP
                   AND C.ITEM_ID                  = V_ITEM_ID
                   AND C.OPERATION_ID             = V_OPERATION_ID
                   AND C.MEASURE                  = V_MEASURE
                   AND C.YYYYMMDD                 = V_YYYYMMDD;
                -------------------------------------------------------------------------------------------------------------------------------------------------------
                --### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
                -------------------------------------------------------------------------------------------------------------------------------------------------------

            ELSIF V_ACTIVE_FLAG IN ('D', 'd') THEN

                DELETE FROM SCP_ANL_PRODUCTION_PLAN
                      WHERE DIVISION_ID              = V_DIVISION_ID
                        AND PLAN_START_YYYYMMDD      = V_PLAN_START_YYYYMMDD
                        AND PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE     /* 파티션 프루닝 */
                        AND PLAN_TYPE                = V_PLAN_TYPE
                        AND SEQ                      = V_SEQ
                        AND OPERATION_GROUP          = V_OPERATION_GROUP
                        AND SCM_SITE_ID              = V_SCM_SITE_ID
                        AND ITEM_ID                  = V_ITEM_ID
                        AND LINE_ID                  = V_LINE_ID
                        AND OPERATION_ID             = V_OPERATION_ID
                        AND MEASURE                  = V_MEASURE
                        AND YYYYMMDD                 = V_YYYYMMDD
                        AND NVL(ELECTRODE_TYPE, '-') = NVL(V_ELECTRODE_TYPE, '-');

                -------------------------------------------------------------------------------------------------------------------------------------------------------
                --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
                -- ESS 가상 라인에 매핑된 동기화 대상 JV 라인 계획 삭제
                -------------------------------------------------------------------------------------------------------------------------------------------------------
                DELETE FROM SCP_ANL_PRODUCTION_PLAN C
                      WHERE EXISTS (SELECT 1
                                      FROM GT_0011_JV_SYNC    SA
                                         , GT_0011_LAST_PLAN  SB
                                     WHERE SB.DIVISION_ID         = SA.RP_DIVISION_ID
                                       AND SB.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                       AND C.DIVISION_ID          = SA.RP_DIVISION_ID      -- JV division
                                       AND C.PLAN_TYPE            = SB.PLAN_TYPE
                                       AND C.SEQ                  = SB.PLAN_SEQ
                                       AND C.SCM_SITE_ID          = SA.RP_SCM_SITE_ID      -- JV Real scm site_id
                                       AND C.LINE_ID              = SA.RL_LINE_ID)         -- JV Real line
                        AND C.PLAN_START_YYYYMMDD      = V_PLAN_START_YYYYMMDD
                        AND C.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE
                        AND C.OPERATION_GROUP          = V_OPERATION_GROUP
                        AND C.ITEM_ID                  = V_ITEM_ID
                        AND C.OPERATION_ID             = V_OPERATION_ID
                        AND C.MEASURE                  = V_MEASURE
                        AND C.YYYYMMDD                 = V_YYYYMMDD;
                -------------------------------------------------------------------------------------------------------------------------------------------------------
                --### END : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
                -------------------------------------------------------------------------------------------------------------------------------------------------------

            END IF;

            IF V_FIX IN ('Y', 'y') THEN

                -- FIX데이타 수정
                UPDATE SCP_ANL_PRODUCTION_PLAN_FIX
                   SET QTY                      = V_QTY
                     , LAST_UPDATED_BY          = NVL(V_LAST_UPDATED_BY, '-')
                     , LAST_UPDATE_DATE         = D_EVENT_DATE
                 WHERE DIVISION_ID              = V_DIVISION_ID
                   AND OPERATION_GROUP          = V_OPERATION_GROUP
                   AND SCM_SITE_ID              = V_SCM_SITE_ID
                   AND ITEM_ID                  = V_ITEM_ID
                   AND LINE_ID                  = V_LINE_ID
                   AND OPERATION_ID             = V_OPERATION_ID
                   AND YYYYMMDD                 = V_YYYYMMDD
                   AND NVL(ELECTRODE_TYPE, '-') = NVL(V_ELECTRODE_TYPE, '-');

                --FIX_ID조회 (AS-IS 는 반복마다 빈 문자로 초기화하고, 여러 행이면 마지막 행 값)
                SELECT MAX(FIX_ID)
                  INTO V_FIX_ID
                  FROM SCP_ANL_PRODUCTION_PLAN_FIX
                 WHERE DIVISION_ID              = V_DIVISION_ID
                   AND OPERATION_GROUP          = V_OPERATION_GROUP
                   AND SCM_SITE_ID              = V_SCM_SITE_ID
                   AND ITEM_ID                  = V_ITEM_ID
                   AND LINE_ID                  = V_LINE_ID
                   AND OPERATION_ID             = V_OPERATION_ID
                   AND YYYYMMDD                 = V_YYYYMMDD
                   AND NVL(ELECTRODE_TYPE, '-') = NVL(V_ELECTRODE_TYPE, '-');

                --이력저장 (AS-IS PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST)
                INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H
                     (
                       HISTORY_SEQ
                      ,FIX_ID
                      ,DIVISION_ID
                      ,OPERATION_GROUP
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,LINE_ID
                      ,OPERATION_ID
                      ,YYYYMMDD
                      ,QTY
                      ,FIX_REASON
                      ,ORIGIN_DIVISION_ID
                      ,ELECTRODE_TYPE
                      ,CREATED_BY
                      ,CREATION_DATE
                      ,LAST_UPDATED_BY
                      ,LAST_UPDATE_DATE
                      ,HISTORY_CREATION_DATE
                     )
                VALUES
                     (
                       SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
                      ,NVL(V_FIX_ID, '-')
                      ,NVL(V_DIVISION_ID, '-')
                      ,NVL(V_OPERATION_GROUP, '-')
                      ,NVL(V_SCM_SITE_ID, '-')
                      ,NVL(V_ITEM_ID, '-')
                      ,NVL(V_LINE_ID, '-')
                      ,NVL(V_OPERATION_ID, '-')
                      ,NVL(V_YYYYMMDD, '-')
                      ,V_QTY
                      ,NULL
                      ,V_ORIGIN_DIVISION_ID
                      ,V_ELECTRODE_TYPE
                      ,NVL(V_LAST_UPDATED_BY, '-')
                      ,D_EVENT_DATE
                      ,NVL(V_LAST_UPDATED_BY, '-')
                      ,SYSDATE
                      ,SYSDATE
                     );

                -------------------------------------------------------------------------------------------------------------------------------------------------------
                --### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
                -- ESS 가상 라인에 매핑된 동기화 대상 JV 라인 계획 Fix 데이터 변경
                -------------------------------------------------------------------------------------------------------------------------------------------------------
                UPDATE SCP_ANL_PRODUCTION_PLAN_FIX A
                   SET A.QTY              = V_QTY
                     , A.LAST_UPDATED_BY  = NVL(V_LAST_UPDATED_BY, '-')
                     , A.LAST_UPDATE_DATE = SYSDATE
                 WHERE EXISTS (SELECT 1
                                 FROM GT_0011_JV_SYNC SA
                                WHERE A.DIVISION_ID = SA.RP_DIVISION_ID
                                  AND A.SCM_SITE_ID = SA.RP_SCM_SITE_ID     -- JV Real scm site_id
                                  AND A.LINE_ID     = SA.RL_LINE_ID)        -- JV Real line
                   AND A.OPERATION_GROUP  = V_OPERATION_GROUP
                   AND A.ITEM_ID          = V_ITEM_ID
                   AND A.OPERATION_ID     = V_OPERATION_ID
                   AND A.YYYYMMDD         = V_YYYYMMDD;

                -------------------------------------------------------------------------------------------------------------------------------------------------------
                -- ESS 가상 라인에 매핑된 동기화 대상 JV 라인 계획 Fix 데이터 변경후 이력 생성
                -------------------------------------------------------------------------------------------------------------------------------------------------------
                INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H
                     (
                       HISTORY_SEQ
                      ,FIX_ID
                      ,DIVISION_ID
                      ,OPERATION_GROUP
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,LINE_ID
                      ,OPERATION_ID
                      ,YYYYMMDD
                      ,QTY
                      ,FIX_REASON
                      ,ORIGIN_DIVISION_ID
                      ,ELECTRODE_TYPE
                      ,CREATED_BY
                      ,CREATION_DATE
                      ,LAST_UPDATED_BY
                      ,LAST_UPDATE_DATE
                      ,ATTRIBUTE1
                      ,ATTRIBUTE2
                      ,ATTRIBUTE3
                      ,ATTRIBUTE4
                      ,ATTRIBUTE5
                      ,ATTRIBUTE6
                      ,ATTRIBUTE7
                      ,ATTRIBUTE8
                      ,ATTRIBUTE9
                      ,ATTRIBUTE10
                      ,HISTORY_CREATION_DATE
                     )
                SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL   AS HISTORY_SEQ
                     , B.FIX_ID
                     , B.DIVISION_ID
                     , B.OPERATION_GROUP
                     , B.SCM_SITE_ID
                     , B.ITEM_ID
                     , B.LINE_ID
                     , B.OPERATION_ID
                     , B.YYYYMMDD
                     , B.QTY
                     , B.FIX_REASON
                     , B.ORIGIN_DIVISION_ID
                     , B.ELECTRODE_TYPE
                     , B.CREATED_BY
                     , B.CREATION_DATE
                     , B.LAST_UPDATED_BY
                     , B.LAST_UPDATE_DATE
                     , B.ATTRIBUTE1
                     , B.ATTRIBUTE2
                     , B.ATTRIBUTE3
                     , B.ATTRIBUTE4
                     , B.ATTRIBUTE5
                     , B.ATTRIBUTE6
                     , B.ATTRIBUTE7
                     , B.ATTRIBUTE8
                     , B.ATTRIBUTE9
                     , B.ATTRIBUTE10
                     , SYSDATE                                      AS HISTORY_CREATION_DATE
                  FROM GT_0011_JV_SYNC               A
                     , SCP_ANL_PRODUCTION_PLAN_FIX   B
                 WHERE B.DIVISION_ID      = A.RP_DIVISION_ID
                   AND B.SCM_SITE_ID      = A.RP_SCM_SITE_ID      -- JV Real scm site_id
                   AND B.LINE_ID          = A.RL_LINE_ID          -- JV Real line
                   AND B.OPERATION_GROUP  = V_OPERATION_GROUP
                   AND B.ITEM_ID          = V_ITEM_ID
                   AND B.OPERATION_ID     = V_OPERATION_ID
                   AND B.YYYYMMDD         = V_YYYYMMDD;
                -------------------------------------------------------------------------------------------------------------------------------------------------------
                --### ENd : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
                -------------------------------------------------------------------------------------------------------------------------------------------------------

            END IF;

        END LOOP; -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        -- 결과코드, 결과 카운트 반환
        OPEN O_RC1 FOR
        SELECT 'S'                                                  AS RESULT_CODE
             , V_MST_LOOP_CNT                                       AS RESULT_CNT
             , CAST(NULL AS NUMBER)                                 AS ERR_CODE
             , CAST(NULL AS VARCHAR2(4000))                         AS ERR_MESSAGE
          FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'                                                  AS CODE
             , 'SUCCESS'                                            AS MSG
             , '0'                                                  AS EVENT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK; --입력 데이타 롤백 처리

            INSERT INTO SCM_SYS_LOG_BATCH
                 (
                   PROGRAM_NAME
                  ,LOG_TYPE
                  ,LOG_COUNT
                  ,LOG_MESSAGE
                  ,DESCRIPTION
                  ,EVENT_DATE
                  ,CREATION_DATE
                  ,CREATED_BY
                  ,LAST_UPDATE_DATE
                  ,LAST_UPDATED_BY
                 )
            VALUES
                 (
                   'SCP0011_SAVE_PRODUCTION_PLAN_LINE'
                  ,'ERROR'
                  ,NULL
                  ,SUBSTR(V_ERR_MESSAGE, 1, 1000)
                  ,NULL
                  ,SYSDATE
                  ,SYSDATE
                  ,'SCP0011_SAVE_PRODUCTION_PLAN_LINE'
                  ,SYSDATE
                  ,'SCP0011_SAVE_PRODUCTION_PLAN_LINE'
                 );

            COMMIT;   /* AS-IS 는 되돌린 뒤 오류 로그를 자동 확정으로 남긴다 */

            -- error코드, errror 메시지 반환
            OPEN O_RC1 FOR
            SELECT 'F'                                              AS RESULT_CODE
                 , CAST(NULL AS NUMBER)                             AS RESULT_CNT
                 , V_ERR_CODE                                       AS ERR_CODE
                 , V_ERR_MESSAGE                                    AS ERR_MESSAGE
              FROM DUAL;

            OPEN O_RESULT_CURSOR FOR
            SELECT TO_CHAR(V_ERR_CODE)                              AS CODE
                 , V_ERR_MESSAGE                                    AS MSG
                 , '0'                                              AS EVENT
              FROM DUAL;
    END P_SCP0011_SAVE_PROD_PLAN_LINE;
-- 2026.09.18 AJS 공용 기본 계획 버전 SCP0011_GET_LAST_PLAN_VERSION · 생산계획 라인 저장 SCP0011_SAVE_PRODUCTION_PLAN_LINE 추가 (END)

END PKG_COM0000;
/
SHOW ERRORS PACKAGE BODY PKG_COM0000
