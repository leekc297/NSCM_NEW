/*=============================================================================================
 * File         : 04_Package_PKG_COM0000.sql
 * Description  : Package — PKG_COM0000
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_COM0000 IS
/*
 * Program ID   : PKG_COM0000
 * Description  : PKG_COM0000
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.09   park.choyi     [PJ20264226] NextSCM Pilot 설계 및 개발
 */


PROCEDURE P_COM0001_GET_CITY_BY_COUNTRY_POPUP(
	p_country 		IN 	VARCHAR2,
	p_city	  		IN 	VARCHAR2,
	o_rc1			OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
);

PROCEDURE P_COM0002_GET_CUSTOMER_BY_DIVISION_POPUP(
    p_division_id 	IN 	VARCHAR2,
    p_soldto_code 	IN 	VARCHAR2,
    p_shipto_code 	IN 	VARCHAR2,
    o_rc1         	OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
);

PROCEDURE P_COM0003_GET_STORAGE_BY_DIVISION_POPUP
(
    p_division_id 	IN 	VARCHAR2,
    p_storage_id  	IN 	VARCHAR2,
    o_rc1         	OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
);

PROCEDURE P_COM0004_GET_OWNERINFO_POPUP(
	p_search	 	IN 	VARCHAR2,
	p_lang_code  	IN 	VARCHAR2,
	p_user_id 	IN 	VARCHAR2,
	p_division_id 	IN 	VARCHAR2,
	o_rc1  		 	OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
);

PROCEDURE P_COM0005_GET_PROJECT_BY_DIVISION_POPUP(
  	p_division_id   IN 	VARCHAR2,
  	p_dept_id       IN 	VARCHAR2,	
  	p_end_customer  IN 	VARCHAR2,	
  	p_scm_site_id   IN 	VARCHAR2,
  	p_project_code  IN 	VARCHAR2,
  	p_etc		   	IN 	VARCHAR2,
  	o_rc1 			OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
);

PROCEDURE P_COM0006_GET_OWNER_DATA (
    P_DIVISION_ID   IN 	VARCHAR2,
    P_DEPT_ID       IN 	VARCHAR2,
    P_END_CUSTOMER  IN 	VARCHAR2,
    P_PROJECT_CODE  IN 	VARCHAR2,
    P_SCM_SITE_ID   IN 	VARCHAR2,
    P_OWNER_ID      IN 	VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
);

PROCEDURE P_COM0007_GET_MESSAGE_POPUP (
    P_MSG_TP_CD   	IN 	VARCHAR2,
    P_MSG_CTN       IN 	VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
);

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
);

PROCEDURE P_COM0009_GET_TEAM_POPUP(
    P_TEAM_ID     	IN  VARCHAR2,
    P_TEAM_NAME   	IN  VARCHAR2,
    P_CREATED_BY  	IN  VARCHAR2,
    O_RC1      	  	OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
);


PROCEDURE P_COM0010_GET_SSO_USER_POPUP(
    P_USER_CTN     	IN  VARCHAR2,
    P_LANG_CD   	IN  VARCHAR2,
    O_RC1      	  	OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
);


PROCEDURE P_COM0011_GET_SSO_DEPT_POPUP(
    P_DEPT_CTN     	IN  VARCHAR2,
    P_LANG_CD   	IN  VARCHAR2,
    O_RC1      	  	OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
);


PROCEDURE P_COM0012_GET_PROJECT_BY_ONLY_DIVISION_POPUP(
    p_division_id   IN  VARCHAR2,
    o_rc1       OUT SYS_REFCURSOR,
  O_RESULT_CURSOR OUT SYS_REFCURSOR
);

END PKG_COM0000;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_COM0000 IS

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
    AND    (
    	   A.COUNTRY      LIKE '%' ||  p_country  ||  '%'
		OR A.COUNTRY_NAME LIKE '%' ||  p_country  ||  '%'
		   )
    AND    (   
           B.CITY      LIKE '%' ||  p_city  ||  '%'
		OR B.CITY_NAME LIKE '%' ||  p_city  ||  '%'
		   )
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
	  AND (
	        C.SHIPTO_CODE        LIKE '%' || NVL(P_SHIPTO_CODE, '') || '%'
	        OR C.SHIPTO_DESCRIPTION LIKE '%' || NVL(P_SHIPTO_CODE, '') || '%'
	      )
	  AND (
	        C.SOLDTO_CODE        LIKE '%' || NVL(P_SOLDTO_CODE, '') || '%'
	        OR C.SOLDTO_DESCRIPTION LIKE '%' || NVL(P_SOLDTO_CODE, '') || '%'
	      )
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
	  AND S.STORAGE_ID LIKE '%' || NVL(P_STORAGE_ID, '') || '%'
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
	p_user_id 	IN 	VARCHAR2,
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
                 ) THEN 'Y' ELSE ''
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
        WHERE (SELECT ADMIN_YN FROM IS_ADMIN) = ''
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
     AND FXU.DEPT_ID NOT IN ('LESIC')
    ORDER BY DI.DEPT_NAME_KO, USER_NAME, FXU.USER_ID
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
 */
AS
BEGIN
  IF p_etc = '' THEN
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
        ON A.DROP_YN = ''
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
      LEFT JOIN SCM_MST_SSO_USER_INFO SU
        ON SU.USER_ID = B.OWNER 
--        	(
--        
--             SELECT COLUMN_VALUE
--             FROM TABLE(String_Split(B.OWNER, ','))
--             FETCH FIRST 1 ROWS ONLY
--           )
      LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WHERE VALID_YN = 'Y') TEAM
        ON SU.DEPT_ID = TEAM.DEPT_ID
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
    	AND (p_dept_id = 'ALL' OR SU.DEPT_ID IN (
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
                FROM TABLE(UF_FX_String_Split(p_project_code, ',')) P
                WHERE A.PROJECT_CODE LIKE P.TOKEN || '%'
              )
              OR
              EXISTS (
                SELECT 1
                FROM TABLE(UF_FX_String_Split(p_project_code, ',')) P
                WHERE A.PROJECT_NAME LIKE P.TOKEN || '%'
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
              WHERE A.SEGMENT2 LIKE P.TOKEN || '%'
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
                 ) THEN 'Y' ELSE ''
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
        WHERE (SELECT ADMIN_YN FROM IS_ADMIN) = ''
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
                    WHERE A.PROJECT_CODE LIKE P.VALUE || '%'
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
        HAVING
            (P_MSG_CTN IS NULL OR 
             UPPER(MAX(CASE WHEN A.LANG_CD = 'KO' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%') OR 
             UPPER(MAX(CASE WHEN A.LANG_CD = 'EN' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%') OR 
             UPPER(MAX(CASE WHEN A.LANG_CD = 'CN' THEN A.MSG_NM END)) LIKE UPPER('%' || P_MSG_CTN || '%')
            )
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
 */

BEGIN

    OPEN O_RC1 FOR
        
    WITH
    ITEM_SINGLE_V AS (
        SELECT T1.DIVISION_ID, T1.ITEM_ID
             , MAX(T1.ITEM_NAME) AS ITEM_NAME
             , MAX(T1.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
             , MAX(T1.NICK_NAME) AS NICK_NAME
             , CASE MIN(CASE WHEN T1.ITEM_TYPE='P' THEN 1 WHEN T1.ITEM_TYPE='H' THEN 2
                             WHEN T1.ITEM_TYPE='Q' THEN 3 ELSE 4 END)
                 WHEN 1 THEN 'P' WHEN 2 THEN 'H' WHEN 3 THEN 'Q' ELSE 'R' END AS ITEM_TYPE
             , MAX(T1.ACTIVE_FLAG) AS ACTIVE_FLAG
        FROM SCM_MST_ITEM_SN T1
        WHERE (
                (P_DIVISION_ID='81' AND T1.DIVISION_ID LIKE '81%')
                OR T1.DIVISION_ID=P_DIVISION_ID
              )
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
        SELECT DISTINCT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(NVL(P_PROJECT_CODE, ''), ','))
        WHERE VALUE IS NOT NULL
    ),
    SPLIT_ITEM AS (
        SELECT DISTINCT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(NVL(P_ITEM_ID, ''), ','))
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
                    WHERE D.PROJECT_CODE LIKE P.VALUE || '%'
                )
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_PROJ P
                    WHERE A.PROJECT_NAME LIKE P.VALUE || '%'
                )
              )

          AND (
                NVL(TRIM(P_ITEM_ID), 'ALL') = 'ALL'
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_ITEM P
                    WHERE D.ITEM_ID LIKE P.VALUE || '%'
                )
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_ITEM P
                    WHERE T.NICK_NAME LIKE P.VALUE || '%'
                )
              )

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
                    WHERE D.PROJECT_CODE LIKE P.VALUE || '%'
                )
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_PROJ P
                    WHERE A.PROJECT_NAME LIKE P.VALUE || '%'
                )
              )

          AND (
                NVL(TRIM(P_ITEM_ID), 'ALL') = 'ALL'
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_ITEM P
                    WHERE D.ITEM_ID LIKE P.VALUE || '%'
                )
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_ITEM P
                    WHERE T.NICK_NAME LIKE P.VALUE || '%'
                )
              )

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
                    WHERE D.ITEM_ID LIKE P.VALUE || '%'
                )
                OR EXISTS (
                    SELECT 1
                    FROM SPLIT_ITEM P
                    WHERE T.NICK_NAME LIKE P.VALUE || '%'
                )
              )
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
    

    IF (
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
             WHERE T.UPPER_DEPT_ID = D.DEPT_ID
               AND (
                     T."2LEVEL_DEPT_ID" IN ('58174290')
                     OR (
                         T.DEPT_ID IN (
                             SELECT DISTINCT B.DEPT_ID 
                               FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
                               JOIN SCM_MST_SSO_USER_INFO B
                                 ON A.USER_ID = B.USER_ID
--                              WHERE A.GroupID = 'DM Planner (W/S)'
                         )
                         AND T."2LEVEL_DEPT_ID" IS NOT NULL
                     )
               )
               AND D.VALID_YN = 'Y'
               AND T.VALID_YN = 'Y'
               AND D.DEPT_NAME_KO <> '_'
               AND T.DEPT_ID LIKE '%' || p_team_id || '%'
               AND (
                    T.DEPT_NAME_KO LIKE '%' || p_team_name || '%'
                    OR T.DEPT_NAME_EN LIKE '%' || p_team_name || '%'
                    OR T.DEPT_NAME_CN LIKE '%' || p_team_name || '%'
               )
               AND T.DEPT_ID = CASE WHEN v_group_id = 'ADMIN' THEN T.DEPT_ID ELSE v_dept_id END 
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
    O_RC1           OUT SYS_REFCURSOR,
	O_RESULT_CURSOR	OUT	SYS_REFCURSOR
)
AS
BEGIN
    OPEN O_RC1 FOR
        SELECT	U.USER_ID
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
        	LEFT JOIN SCM_MST_SSO_DEPT_INFO D
        		ON	U.DEPT_ID = D.DEPT_ID 
		WHERE	(P_USER_CTN IS NULL OR
				 UPPER(U.USER_ID) LIKE '%' || UPPER(P_USER_CTN) || '%' OR
				 UPPER(U.USER_NAME) LIKE '%' || UPPER(P_USER_CTN) || '%' OR
				 UPPER(U.USER_NAME_EN) LIKE '%' || UPPER(P_USER_CTN) || '%')
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
		WHERE	(P_DEPT_CTN IS NULL OR
				 UPPER(D.DEPT_NAME_KO) LIKE '%' || UPPER(P_DEPT_CTN) || '%' OR
				 UPPER(D.DEPT_NAME_EN) LIKE '%' || UPPER(P_DEPT_CTN) || '%' OR
				 UPPER(D.DEPT_NAME_CN) LIKE '%' || UPPER(P_DEPT_CTN) || '%' OR
				 UPPER(D.DEPT_ID) LIKE '%' || UPPER(P_DEPT_CTN) || '%')
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
        ON A.DROP_YN = ''
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
        AND (p_division_id = 'ALL' OR A.DIVISION_ID IN (
              SELECT P.COLUMN_VALUE
              FROM TABLE(UF_FX_String_SplitForIN(p_division_id, ',')) P
            ))
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


END PKG_COM0000;
/
