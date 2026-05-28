/*=============================================================================================
 * File         : 04_Package_PKG_SYS0011.sql
 * Description  : Package — PKG_SYS0011
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SYS0011
AS

/*
 * Program ID   : PKG_SYS0011
 * Description  : PKG_SYS0011
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.04.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */


    PROCEDURE P_SYS0011_GET_AUTH_DATA (
	    O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SYS0011_GET_DIVISION_DATA (
	    O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );
    
    PROCEDURE P_SYS0011_GET_MY_AUTH_DATA (
      P_USER_ID       IN  VARCHAR2
	  , O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );
    
    PROCEDURE P_SYS0011_GET_USER_INFO_DATA (
      P_USER_ID       IN  VARCHAR2
	  , O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
    );
    
    PROCEDURE P_SYS0011_SAVE_USER_INFO_DATA(
      P_DATA      IN    CLOB,
      P_USER_ID   IN    VARCHAR2,
      O_RESULT_CURSOR OUT   SYS_REFCURSOR
    );
    
    PROCEDURE P_SYS0011_SAVE_MY_AUTH_DATA(
      P_DATA      IN    CLOB,
      P_USER_ID   IN    VARCHAR2,
      O_RESULT_CURSOR OUT   SYS_REFCURSOR
    );
    
END PKG_SYS0011;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SYS0011
AS

	PROCEDURE P_SYS0011_GET_AUTH_DATA (
	    O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
	) IS
		--V_ERR_MSG 	VARCHAR2(4000);
    
/*
 * Program ID   : P_SYS0011_GET_AUTH_DATA
 * Description  : P_SYS0011_GET_AUTH_DATA
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.04.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

	BEGIN
    OPEN O_CURSOR FOR
      SELECT  G.USER_GR_ID
          , G.USER_GR_NM
      FROM  SCM_ADM_USER_GR_M G
      WHERE   G.USE_YN = 'Y'
      ORDER BY G.USER_GR_ID
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
	
	END P_SYS0011_GET_AUTH_DATA;


	PROCEDURE P_SYS0011_GET_DIVISION_DATA (
	    O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
	) IS
		--V_ERR_MSG 	VARCHAR2(4000);
    
/*
 * Program ID   : P_SYS0011_GET_DIVISION_DATA
 * Description  : P_SYS0011_GET_DIVISION_DATA
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.04.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

	BEGIN
    OPEN O_CURSOR FOR
    SELECT DIVISION_ID, DIVISION_NAME
    FROM 	SCM_MST_DIVISION 
    WHERE VALID_YN = 'Y'
    ORDER BY DIVISION_ID      
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
	
	END P_SYS0011_GET_DIVISION_DATA;
  
	PROCEDURE P_SYS0011_GET_MY_AUTH_DATA (
      P_USER_ID       IN  VARCHAR2
	  , O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
	) IS
		--V_ERR_MSG 	VARCHAR2(4000);
    
/*
 * Program ID   : P_SYS0011_GET_MY_AUTH_DATA
 * Description  : P_SYS0011_GET_MY_AUTH_DATA
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.04.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

	BEGIN
    OPEN O_CURSOR FOR
        SELECT  chk
          , user_id
          , user_gr_id
          , user_gr_nm
          , division_id
          , division_name
          , plant_id
          , plant_name
          , approval_result
          , approval_user
          , created_by
          , creation_date
          , last_updated_by
          , last_update_date
          , reject_reason
          , lang_cd
          , tmz_cd
    FROM (
        /* 1) 요청 테이블 기준 */
        SELECT  ' ' AS chk
              , a.user_id
              , g.user_gr_id
              , g.user_gr_nm
              , a.division_id
              , a.division_id || ' ' || d.division_name AS division_name
              , a.plant_id
              , MAX(CASE WHEN TRIM(sn.plant_name) IS NULL THEN v.vendor_name ELSE sn.plant_name END) AS plant_name
              , a.approval_result
              , a.approval_user
              , a.created_by
              , a.creation_date
              , a.last_updated_by
              , a.last_update_date
              , a.reject_reason
              , u.lang_cd
              , u.tmz_cd
        FROM scm_mst_auth_request a
        JOIN scm_adm_user_gr_m g
          ON a.group_id = g.user_gr_id
        JOIN scm_mst_division d
          ON a.division_id = d.division_id
        LEFT JOIN scm_mst_plant_sn sn
          ON a.division_id = sn.division_id
         AND a.plant_id = sn.plant_id
        LEFT JOIN scm_mst_vendor v
          ON v.vendor_code = a.plant_id
        LEFT JOIN SCM_ADM_USER_M u
          ON a.user_id = u.user_id
         AND u.use_yn = 'Y'
        WHERE a.user_id = P_USER_ID
        GROUP BY
                a.user_id
              , g.user_gr_id
              , g.user_gr_nm
              , a.division_id
              , a.division_id || ' ' || d.division_name
              , a.plant_id
              , a.approval_result
              , a.approval_user
              , a.created_by
              , a.creation_date
              , a.last_updated_by
              , a.last_update_date
              , a.reject_reason
              , u.lang_cd
              , u.tmz_cd

        UNION ALL
        /* 2) 그룹-조직 권한 테이블 기준 */

        SELECT  '' AS chk
              , a.user_id AS user_id
              , a.user_gr_id AS group_id
              , g.user_gr_nm AS group_name
              , a.division_id
              , a.division_id || ' ' || d.division_name AS division_name
              , a.plant_id
              , MAX(CASE WHEN TRIM(sn.plant_name) IS NULL THEN v.vendor_name ELSE sn.plant_name END) AS plant_name
              , 'APPROVED' AS approval_result
              , a.created_by AS approval_user
              , a.created_by
              , a.creation_date
              , 'Group User' AS last_updated_by
              , a.last_update_date
              , '' AS reject_reason
              , u.lang_cd
              , u.tmz_cd
        FROM (
            SELECT  x.user_id
                  , x.user_gr_id
                  , CASE WHEN x.unit_tp_cd = 'D' THEN x.unit_id
                         WHEN x.unit_tp_cd = 'P' THEN x.uppr_unit_id
                    END AS division_id
                  , CASE WHEN x.unit_tp_cd = 'P' THEN x.unit_id
                         ELSE ''
                    END AS plant_id
                  , x.creation_date
                  , x.created_by
                  , x.last_update_date
                  , x.last_updated_by
            FROM scm_adm_user_gr_unit_auth_mpg_m x
            WHERE x.user_id = P_USER_ID
        ) a
        JOIN scm_adm_user_gr_m g
          ON a.user_gr_id = g.user_gr_id
        JOIN scm_mst_division d
          ON a.division_id = d.division_id
        LEFT JOIN scm_mst_plant_sn sn
          ON a.division_id = sn.division_id
         AND a.plant_id = sn.plant_id
        LEFT JOIN scm_mst_vendor v
          ON v.vendor_code = a.plant_id
        LEFT JOIN SCM_ADM_USER_M u
          ON a.user_id = u.user_id
         AND u.use_yn = 'Y'
        WHERE NOT EXISTS (
            SELECT 1
            FROM scm_mst_auth_request b
            WHERE b.group_id    = a.user_gr_id
              AND b.user_id     = a.user_id
              AND b.division_id = a.division_id
        )
        GROUP BY
                a.user_id
              , a.user_gr_id
              , g.user_gr_nm
              , a.division_id
              , a.division_id || ' ' || d.division_name
              , a.plant_id
              , a.created_by
              , a.creation_date
              , a.last_update_date
              , u.lang_cd
              , u.tmz_cd
    )
    ORDER BY user_gr_id, division_id, plant_id;
    
    
    OPEN O_RESULT_CURSOR FOR
      SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;
            
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || '-' );
	
	END P_SYS0011_GET_MY_AUTH_DATA;
  
	PROCEDURE P_SYS0011_GET_USER_INFO_DATA (
      P_USER_ID       IN  VARCHAR2
	  , O_CURSOR        OUT SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
	) IS
		--V_ERR_MSG 	VARCHAR2(4000);
    
/*
 * Program ID   : P_SYS0011_GET_USER_INFO_DATA
 * Description  : P_SYS0011_GET_USER_INFO_DATA
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.04.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

	BEGIN
    OPEN O_CURSOR FOR
    SELECT A.USER_ID, A.USER_NAME AS USER_NM, A.USER_NAME_EN AS USER_ENG_NM, A.DEPT_ID, B.DEPT_NAME_KO AS DEPT_NAME
         , LANG_CD, TMZ_CD
    FROM   SCM_MST_SSO_USER_INFO A
    LEFT JOIN SCM_MST_SSO_DEPT_INFO B
    ON  A.DEPT_ID = B.DEPT_ID
    AND B.VALID_YN = 'Y'
    LEFT JOIN SCM_ADM_USER_M C
    ON  A.USER_ID = C.USER_ID
    AND C.USE_YN = 'Y'
    WHERE  A.USER_ID = P_USER_ID
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
	
	END P_SYS0011_GET_USER_INFO_DATA;
  
  
  PROCEDURE P_SYS0011_SAVE_USER_INFO_DATA(
    P_DATA      IN    CLOB,
    P_USER_ID   IN    VARCHAR2,
    O_RESULT_CURSOR OUT   SYS_REFCURSOR
  ) IS
/*
 * Program ID   : P_SYS0011_SAVE_USER_INFO_DATA
 * Description  : P_SYS0011_SAVE_USER_INFO_DATA
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.04.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

    V_ROW_CNT NUMBER := 0;
    V_ERR_MSG   VARCHAR2(4000);
  BEGIN
    
    -- MERGE
    MERGE INTO SCM_ADM_USER_M T
        USING (
      SELECT 
                V_USER_ID       AS USER_ID,
                V_USER_NM       AS USER_NM,
                V_USER_ENG_NM   AS USER_ENG_NM,
                V_DEPT_ID       AS DEPT_ID,
                V_LANG_CD       AS LANG_CD,
                V_TMZ_CD        AS TMZ_CD
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_USER_ID       VARCHAR2(200) PATH '$.USER_ID',
                    V_USER_NM       VARCHAR2(200) PATH '$.USER_NM',
                    V_USER_ENG_NM   VARCHAR2(200) PATH '$.USER_ENG_NM',
                    V_DEPT_ID       VARCHAR2(200) PATH '$.DEPT_ID',
                    V_LANG_CD       VARCHAR2(200) PATH '$.LANG_CD',
                    V_TMZ_CD        VARCHAR2(200) PATH '$.TMZ_CD'
                ))
        ) M
        ON (T.USER_ID = M.USER_ID)
        WHEN MATCHED THEN
            UPDATE SET T.LANG_CD        = LANG_CD
                  , T.TMZ_CD            = TMZ_CD
                  , T.LAST_UPDATED_BY   = P_USER_ID
                  , T.LAST_UPDATE_DATE  = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (USER_ID
                , USER_NM
                , USER_ENG_NM
                , DEPT_ID
                , LANG_CD
                , TMZ_CD
                , PERM_KEP_CNC_YN
                , USE_YN
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE)
            VALUES (M.USER_ID
                , M.USER_NM
                , M.USER_ENG_NM
                , M.DEPT_ID
                , M.LANG_CD
                , M.TMZ_CD
                , ''
                , 'Y'
                , P_USER_ID
                , SYSDATE
                , P_USER_ID
                , SYSDATE)
      ;
     
    -- 생성, 수정 건수 확인
    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
    
    COMMIT; 
  
      OPEN O_RESULT_CURSOR FOR
           SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
  
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;

        IF SQLCODE = -1 THEN
                V_ERR_MSG := 'Duplicate key error.';         
                  OPEN O_RESULT_CURSOR FOR
                  SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
            ELSIF SQLCODE = -1400 THEN
                  V_ERR_MSG := 'Required value is missing.';
                  OPEN O_RESULT_CURSOR FOR
                  SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
            ELSIF SQLCODE = -12899 THEN
                V_ERR_MSG := 'Maximum data size exceeded.';
                  OPEN O_RESULT_CURSOR FOR
                  SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
            ELSE
              RAISE_APPLICATION_ERROR(-20001,
              '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
              ' / SQLERRM=' || SQLERRM ||
              ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
              ' / PARAMS=' || '-' );
            END IF;
    
  END P_SYS0011_SAVE_USER_INFO_DATA;
  
  PROCEDURE P_SYS0011_SAVE_MY_AUTH_DATA(
    P_DATA      IN    CLOB,
    P_USER_ID   IN    VARCHAR2,
    O_RESULT_CURSOR OUT   SYS_REFCURSOR
  ) IS
/*
 * Program ID   : P_SYS0011_SAVE_MY_AUTH_DATA
 * Description  : P_SYS0011_SAVE_MY_AUTH_DATA
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.04.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

    V_ROW_CNT NUMBER := 0;
    V_ERR_MSG   VARCHAR2(4000);
  BEGIN
    
    -- MERGE
    MERGE INTO SCM_MST_AUTH_REQUEST T
        USING (
      SELECT 
                V_USER_ID       AS USER_ID,
                V_USER_GR_ID    AS USER_GR_ID,
                NVL(V_DIVISION_ID,'-')   AS DIVISION_ID,
                NVL(V_PLANT_ID,'-')      AS PLANT_ID
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_USER_ID       VARCHAR2(200) PATH '$.USER_ID',
                    V_USER_GR_ID    VARCHAR2(200) PATH '$.USER_GR_ID',
                    V_DIVISION_ID   VARCHAR2(200) PATH '$.DIVISION_ID' NULL ON EMPTY,
                    V_PLANT_ID      VARCHAR2(200) PATH '$.PLANT_ID'    NULL ON EMPTY                
                ))
        ) M
        ON (T.USER_ID = M.USER_ID 
        AND T.GROUP_ID = M.USER_GR_ID 
        AND T.DIVISION_ID = M.DIVISION_ID 
        AND T.PLANT_ID = M.PLANT_ID  )
        WHEN NOT MATCHED THEN
            INSERT (USER_ID
                , GROUP_ID
                , DIVISION_ID
                , PLANT_ID
                --, APPROVAL_RESULT
                --, APPROVAL_USER
                --, REJECT_REASON
                , CREATED_BY
                , CREATION_DATE )
            VALUES (M.USER_ID
                , M.USER_GR_ID
                , M.DIVISION_ID
                , M.PLANT_ID
                , P_USER_ID
                , SYSDATE)
      ;
     
    -- 생성, 수정 건수 확인
    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
    
    COMMIT; 
  
      OPEN O_RESULT_CURSOR FOR
           SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;
  
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;

        IF SQLCODE = -1 THEN
                V_ERR_MSG := 'Duplicate key error.';         
                  OPEN O_RESULT_CURSOR FOR
                  SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
            ELSIF SQLCODE = -1400 THEN
                  V_ERR_MSG := 'Required value is missing.';
                  OPEN O_RESULT_CURSOR FOR
                  SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
            ELSIF SQLCODE = -12899 THEN
                V_ERR_MSG := 'Maximum data size exceeded.';
                  OPEN O_RESULT_CURSOR FOR
                  SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
            ELSE
              RAISE_APPLICATION_ERROR(-20001,
              '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
              ' / SQLERRM=' || SQLERRM ||
              ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
              ' / PARAMS=' || '-' );
            END IF;
    
  END P_SYS0011_SAVE_MY_AUTH_DATA;
  
END PKG_SYS0011;
/
