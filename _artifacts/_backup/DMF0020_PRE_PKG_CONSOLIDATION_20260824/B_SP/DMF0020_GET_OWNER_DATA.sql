-- [BACKUP 2026-08-24] SCM_MGR.DMF0020_GET_OWNER_DATA (PROCEDURE, INVALID)
-- 원본 LAST_DDL = 2026-07-21 16:38:57

CREATE OR REPLACE PROCEDURE           "DMF0020_GET_OWNER_DATA"
(
    P_DIVISION_ID     IN VARCHAR2,
    P_DEPT_ID         IN VARCHAR2,
    P_END_CUSTOMER    IN VARCHAR2,
    P_PROJECT_CODE    IN VARCHAR2,
    P_SCM_SITE_ID     IN VARCHAR2,
    P_OWNER_ID        IN VARCHAR2,

    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn

    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*--------------------------------------------------------------------------------------------------*/
/* Program ID  : [DMF0020_GET_OWNER_DATA]                                                           */
/* Description : 상단 owner 조회조건 'Owner By DivisionPopup'                                       */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/06/21  JYE       Initial Release - OWNER 조회
** 2019/01/23  JYE           42, 44 사업부 추가
** 20200423    KHSONG    C20200422-000403 WS Owner 정보추가요청건 반영
** 2022.04.06  rosia27	 [과제PJ20216891R]GM_JV
* 2024/08/14	KJJ			[PJ2024-50461] Team Mapping
* 2026.03.17   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
*/
/*--------------------------------------------------------------------------------------------------*/
/*
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
*/
/*--------------------------------------------------------------------------------------------------*/
/*
VAR RC1 REFCURSOR;
VAR RC2 REFCURSOR;
EXEC DMF0020_GET_OWNER_DATA('40','58666055','ALL','','ALL','sunny.kim', :RC1, :RC2);
PRINT RC1;
PRINT RC2;
*/
AS

    /*
    DMF000_GET_OWNER_DATA(Multi Owner 조회창)과 동일하게 쿼리 수정(2024.10.17)

    아래 룩업 사용
    --GET_ADMIN_GROUP
    --DM_OWNER_DEPT
    */

    --쿼리 전체 수정

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    v_ADMIN_GROUP    T_STR_TAB := T_STR_TAB();
    v_group_id       VARCHAR2(50 CHAR) := '';

    T_LEVEL2_DEPT_ID T_STR_TAB := T_STR_TAB();  -- 전지본부의 LEVEL2 아이디가 들어간다.
    T_LEVEL1_DEPT_ID T_STR_TAB := T_STR_TAB();  -- 기타 추가하고자 하는 부서의 아이디가 들어간다.
    V_TMPDEPT        T_STR_TAB := T_STR_TAB();

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    SELECT SEGMENT1
    BULK COLLECT INTO v_ADMIN_GROUP
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT2    = 'ALL'
    AND    SEGMENT1    = 'ADMIN'; --조건 빠지면 안됨

    SELECT SEGMENT1
    BULK COLLECT INTO T_LEVEL2_DEPT_ID
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'DM_OWNER_DEPT'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT2    = 'LEVEL_2';

    SELECT SEGMENT1
    BULK COLLECT INTO T_LEVEL1_DEPT_ID
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'DM_OWNER_DEPT'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT2    = 'LEVEL_1';

    -- GroupID JOIN 조건에 사용
    v_ADMIN_GROUP.EXTEND(2);
    v_ADMIN_GROUP(v_ADMIN_GROUP.COUNT - 1) := 'DM Planner';
    v_ADMIN_GROUP(v_ADMIN_GROUP.COUNT)     := 'DM Planner (W/S)'; -- [C20220228-000147]

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    -- 소형사업부, 82 사업부
    --IF v_group_id = 'ADMIN' AND (P_DIVISION_ID = '40' OR P_DIVISION_ID = '82')
    IF P_DIVISION_ID = '40' OR P_DIVISION_ID = '82' THEN
        SELECT DISTINCT C.DEPT_ID
        BULK COLLECT INTO V_TMPDEPT
        FROM   SCM_MST_SITE_ITEM A
             , SCM_MST_SSO_USER_INFO B
             , SCM_MST_SSO_DEPT_INFO C
        WHERE  A.OWNER       = B.USER_ID
        AND    B.DEPT_ID     = C.DEPT_ID
        AND    A.DIVISION_ID = P_DIVISION_ID;-- Admin 이고 40 사업부의 경우에 해당 사업부의 Owner만 조회 / 82 사업부추가[PJ2024-50461] Team Mapping
    END IF;

    -- 자동차 사업부
    --IF v_group_id = 'ADMIN' AND P_DIVISION_ID LIKE '81%'
    IF P_DIVISION_ID LIKE '81%' THEN
        SELECT DISTINCT DEPT_ID
        BULK COLLECT INTO V_TMPDEPT
        FROM (
            SELECT C.DEPT_ID
            FROM   SCM_MST_SITE_ITEM A
                 , SCM_MST_SSO_USER_INFO B
                 , SCM_MST_SSO_DEPT_INFO C
            WHERE  A.OWNER       = B.USER_ID
            AND    B.DEPT_ID     = C.DEPT_ID
            AND    A.DIVISION_ID = P_DIVISION_ID
            UNION ALL
            SELECT DISTINCT SEGMENT1 AS DEPT_ID
            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP
            WHERE  LOOKUP.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
            AND    LOOKUP.VALID_YN    = 'Y'
            AND    LOOKUP.SEGMENT3 IN (
                       SELECT DISTINCT C.DEPT_ID
                       FROM   SCM_MST_SITE_ITEM A
                            , SCM_MST_SSO_USER_INFO B
                            , SCM_MST_SSO_DEPT_INFO C
                       WHERE  A.OWNER       = B.USER_ID
                       AND    B.DEPT_ID     = C.DEPT_ID
                       AND    A.DIVISION_ID = P_DIVISION_ID
                   )
        );
    END IF;

    OPEN O_RC1 FOR
    SELECT FxUGA.unit_id                                                      AS DIVISION_ID
         , FxU.Dept_ID
         , DEPT_INFO.DEPT_NAME_KO
         , FxU.USER_NM
         , FxU.User_ID                                                      AS OWNER_NAME
         , ROW_NUMBER() OVER (ORDER BY FxU.User_ID, FxU.USER_NM) * 100     AS SORT_ORDER_NO
         , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM  (SELECT * FROM SCM_ADM_USER_M WHERE Use_YN = 'Y') FxU
    INNER JOIN (
                SELECT T.DEPT_ID      AS DEPT_ID
                     , T.DEPT_NAME_KO AS DEPT_NAME_KO
                     , T.VALID_YN
                FROM   SCM_MST_SSO_DEPT_INFO D
                     , SCM_MST_SSO_DEPT_INFO T
                WHERE  T.UPPER_DEPT_ID = D.DEPT_ID
                AND    T."2LEVEL_DEPT_ID" IN ( SELECT COLUMN_VALUE FROM TABLE(T_LEVEL2_DEPT_ID) ) -- '58174290'  -- 전지사업부

                UNION ALL
                SELECT T.DEPT_ID      AS DEPT_ID
                     , T.DEPT_NAME_KO AS DEPT_NAME_KO
                     , T.VALID_YN
                FROM   SCM_MST_SSO_DEPT_INFO D
                     , SCM_MST_SSO_DEPT_INFO T
                WHERE  T.UPPER_DEPT_ID = D.DEPT_ID
                AND    T.DEPT_ID IN ( SELECT COLUMN_VALUE FROM TABLE(T_LEVEL1_DEPT_ID) ) -- '58174290'  -- 전지사업부
                AND    D.VALID_YN = 'Y'
                AND    T.VALID_YN = 'Y'
              ) DEPT_INFO
        ON FxU.DEPT_ID = DEPT_INFO.DEPT_ID AND DEPT_INFO.VALID_YN = 'Y'
    INNER JOIN SCM_MST_SSO_USER_INFO USER_INFO
        ON FxU.User_ID = USER_INFO.USER_ID
    INNER JOIN SCM_ADM_USER_GR_UNIT_AUTH_MPG_M FxUGA
        ON FxU.User_ID = FxUGA.User_ID
        AND USER_GR_ID IN (SELECT COLUMN_VALUE FROM TABLE(v_ADMIN_GROUP))  --20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리

    INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
    ON FxUGA.UNIT_ID = T2.UNIT_ID


    WHERE 1 = 1
    AND   FxUGA.unit_id = P_DIVISION_ID
    -- P_DEPT_ID 'ALL' 분기 (Case 17)
    AND   (
              ( P_DEPT_ID = 'ALL' )
           OR ( P_DEPT_ID <> 'ALL'
                AND FxU.DEPT_ID IN (
                    SELECT TRIM(REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL))
                    FROM   DUAL
                    CONNECT BY REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                )
              )
          )
    -- P_OWNER_ID 조건 (Oracle: '' IS NULL)
    AND   (
              P_OWNER_ID IS NULL
           OR FxU.User_ID IN (
                  SELECT TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                  FROM   DUAL
                  CONNECT BY REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL) IS NOT NULL
              )
           OR FxU.USER_NM IN (
                  SELECT TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                  FROM   DUAL
                  CONNECT BY REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL) IS NOT NULL
              )
           OR USER_INFO.USER_NAME_EN IN (
                  SELECT TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                  FROM   DUAL
                  CONNECT BY REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL) IS NOT NULL
              )
          )
    AND   FxU.Dept_ID IN ( SELECT COLUMN_VALUE FROM TABLE(V_TMPDEPT) ) --Dept_ID Table
    GROUP BY FxUGA.unit_id, FxU.User_ID, FxU.USER_NM, USER_INFO.USER_NAME_EN, FxU.Dept_ID, DEPT_INFO.DEPT_NAME_KO, USER_INFO.JOB_NAME, T2.EDIT_YN
    ORDER BY DEPT_INFO.DEPT_NAME_KO, FxU.USER_NM, FxU.User_ID;

    /*
    -----------------------------------------------------------------------
    -- 하단 주석 블록 (DIVISION_ID = '40' / '81','82' 분기) 원본 유지
    -- ... (원본 MSSQL 주석 그대로 보존 - 생략)
    -----------------------------------------------------------------------
    */

    --=============================================================================================================================
    -- 결과코드 0 성공, -1 오류. 조회에서는 건수 없음. NULL로 회신
    --=============================================================================================================================
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_DIVISION_ID'   VALUE P_DIVISION_ID,
                'P_DEPT_ID'       VALUE P_DEPT_ID,
                'P_END_CUSTOMER'  VALUE P_END_CUSTOMER,
                'P_PROJECT_CODE'  VALUE P_PROJECT_CODE,
                'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
                'P_OWNER_ID'      VALUE P_OWNER_ID
            );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END DMF0020_GET_OWNER_DATA;
/
