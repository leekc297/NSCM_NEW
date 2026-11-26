PROCEDURE P_SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX
(
    P_DIVISION_ID   IN VARCHAR2,
    P_DEPT_ID       IN VARCHAR2,   --Department
    P_END_CUSTOMER  IN VARCHAR2,   --Endcustomer
    P_SCM_SITE_ID   IN VARCHAR2,
    P_PROJECT_CODE  IN VARCHAR2,
    P_ETC           IN VARCHAR2 DEFAULT NULL,  -- [PJ20200138] ETC Flag 추가
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************************************************************************************************
 * Program ID  : SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX
 * Description : Sales Price화면에서 Project Code를 가져오는 경우에 사용한다.
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   : division_id, dept_id, end_customer, scm_site_id, project_code
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description
 *--------------------------------------------------------------------------------------------------
 * 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/05/04  P.C.I        [PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - ETC 추가
 * 2024/12/13  jssbae       [PJ2024-50461] Team Mapping
 * 2025/04/16  jssbae   [E20250416-001094]_SSPM Owner 기준 Team정보 Mapping 로직 개선
 * 2026.03.27  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발. TEAM 정보를 SCM_MST_SITE_ITEM 기준으로 변경
 ****************************************************************************************************/

/*****************************************************************************************************
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
******************************************************************************************************/
    -- EXEC SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX @p_division_id='ALL', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='ALL', @p_project_code=''

    V_PROGRAM_NAME  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    --SELECT A.DIVISION_ID
    --     , MIN(D.DIVISION_NAME)   AS DIVISION_NAME
    --     , A.PROJECT_CODE
    --     , A.PROJECT_NAME
    --     , A.PROJECT_STATUS
    --   , A.BIZ_TYPE
    --   , A.CURRENCY
    --     , MAX(A.PROJECT_VER_SEQ)  AS PROJECT_VER_SEQ
    --   , A.PROJECT_OWNER
    --   , TEAM.DEPT_ID
    --   , TEAM.DEPT_NAME_KO
    --   , C.END_CUSTOMER
    --FROM   [dbo].[SCM_MST_PROJECT]  A WITH(NOLOCK)
    --LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN = 'Y') D
    --ON A.DROP_YN = 'N' AND A.DIVISION_ID = D.DIVISION_ID
    --LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C
    --ON A.DIVISION_ID = C.DIVISION_ID
    --LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM
    --                     ON C.DEPT_ID = TEAM.DEPT_ID

    IF P_ETC = 'N' THEN

        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.DIVISION_ID                AS DIVISION_NAME
                 , A.PROJECT_CODE
                 , A.PROJECT_NAME
                 , A.PROJECT_STATUS
                 --, A.BIZ_TYPE
                 --, A.BIZ_TYPE
                 , BIZ.CODE                     AS BIZ_TYPE
                 , BIZ.NAME                     AS BIZ_TYPE_NAME
                 , A.CURRENCY
                 , MAX(A.PROJECT_VER_SEQ)       AS PROJECT_VER_SEQ
                 , A.PROJECT_OWNER
                 , TEAM.DEPT_ID
                 , TEAM.DEPT_NAME_KO
                 , C.END_CUSTOMER
            FROM   (SELECT * FROM SCM_MGR.SCM_MST_PROJECT) A
            LEFT JOIN (
                          SELECT * FROM SCM_MGR.SCM_MST_DIVISION WHERE VALID_YN = 'Y'
                      ) D
                ON A.DROP_YN = 'N' AND A.DIVISION_ID = D.DIVISION_ID
            LEFT JOIN (
                          SELECT * FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE VALID_YN = 'Y'
                      ) B
                ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
            LEFT JOIN (
                          SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER
                          FROM   SCM_MGR.SCM_MST_SITE
                          WHERE  VALID_YN = 'Y'
                      ) C
                ON B.DIVISION_ID = C.DIVISION_ID AND B.SCM_SITE_ID = C.SCM_SITE_ID
            --[PJ2024-50461] Team Mapping START 주석처리 하고 변경 내역을 적용한다.
            /*
            LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM
                            ON C.DEPT_ID = TEAM.DEPT_ID
            */
            LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO SU
            --[E20250416-001094]_SSPM Owner 기준 Team정보 Mapping 로직 개선
            --SCM_MST_SITE_ITEM 해당 테이블은 OWNER가 여러명을 가질수 있는 구조로, 해당조건으로 JOIN하면 데이터가 생성되지 않음
            --SPLIT해서 TOP1만 가지고 오는 구조로 변경
                    --ON SU.USER_ID = B.OWNER
                    ON SU.USER_ID = (
                                        SELECT TRIM(REGEXP_SUBSTR(B.OWNER, '[^,]+', 1, 1))
                                        FROM   DUAL
                                    )
            LEFT JOIN (
                          SELECT * FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO WHERE VALID_YN = 'Y'
                      ) TEAM
                ON B.DEPT_ID = TEAM.DEPT_ID
            --[PJ2024-50461] Team Mapping END
            LEFT JOIN (
                          SELECT SEGMENT1  AS CODE
                               , SEGMENT2  AS NAME
                          FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                          WHERE  LOOKUP_TYPE = 'BIZ_TYPE_BPMS'
                      ) BIZ
                ON BIZ.CODE = A.BIZ_TYPE
            WHERE  TEAM.DEPT_ID IS NOT NULL
            AND    (
                       P_DIVISION_ID = 'ALL'
                       OR A.DIVISION_ID IN (
                              SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            AND    (
                       P_DEPT_ID = 'ALL'
                       OR TEAM.DEPT_ID IN (
                              SELECT TRIM(REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            AND    (
                       P_END_CUSTOMER = 'ALL'
                       OR NVL(C.END_CUSTOMER, '') IN (
                              SELECT TRIM(REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            AND    (
                       P_SCM_SITE_ID = 'ALL'
                       OR C.SCM_SITE_ID IN (
                              SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            --AND CASE WHEN @p_project_code = '' THEN ''
            --         ELSE A.PROJECT_CODE
            --  END IN (
            --          Select * from dbo.UF_FX_String_SplitForIN (@p_project_code,',') as P Where
            --          (CASE WHEN @p_project_code = '' THEN '' ELSE A.PROJECT_CODE END) = P.data
            --          )
            --AND CASE WHEN @p_project_code = '' THEN ''
            --         ELSE A.PROJECT_NAME
            --  END IN (
            --          Select * from dbo.UF_FX_String_SplitForIN (@p_project_code,',') as P Where
            --          (CASE WHEN @p_project_code = '' THEN '' ELSE A.PROJECT_NAME END) = P.data
            --          )
            AND    (
                       EXISTS (
                           SELECT 1
                           FROM   (
                                      SELECT TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL)) AS TOKEN
                                      FROM   DUAL
                                      CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL) IS NOT NULL
                                  ) P
                           WHERE  A.PROJECT_CODE LIKE P.TOKEN || '%'
                       )
                       OR EXISTS (
                           SELECT 1
                           FROM   (
                                      SELECT TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL)) AS TOKEN
                                      FROM   DUAL
                                      CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL) IS NOT NULL
                                  ) P
                           WHERE  A.PROJECT_NAME LIKE P.TOKEN || '%'
                       )
                   )
            --AND    (   A.PROJECT_CODE LIKE '%'+ @p_project_code + '%'
            --   OR A.PROJECT_NAME LIKE '%'+ @p_project_code + '%'
            --)
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

    ELSE  -- [PJ20200138] ETC Only인 경우에 Lookup 에서 Project List 조회

        OPEN O_RC1 FOR
            SELECT A.SEGMENT1   AS DIVISION_ID
                 , A.SEGMENT1   AS DIVISION_NAME
                 , A.SEGMENT2   AS PROJECT_CODE
                 , A.SEGMENT3   AS PROJECT_NAME
                 , ''           AS PROJECT_STATUS
                 , ''           AS BIZ_TYPE
                 , ''           AS BIZ_TYPE_NAME
                 , ''           AS CURRENCY
                 , ''           AS PROJECT_VER_SEQ
                 , ''           AS PROJECT_OWNER
                 , ''           AS DEPT_ID
                 , ''           AS DEPT_NAME_KO
                 , ''           AS END_CUSTOMER
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
            WHERE  A.LOOKUP_TYPE = 'DM_ETC_PROJECT'
            AND    A.VALID_YN    = 'Y'
            AND    A.SEGMENT1    = P_DIVISION_ID
            AND    EXISTS (
                       SELECT 1
                       FROM   (
                                  SELECT TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL)) AS TOKEN
                                  FROM   DUAL
                                  CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL) IS NOT NULL
                              ) P
                       WHERE  A.SEGMENT2 LIKE P.TOKEN || '%'
                   );

    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_DEPT_ID'      VALUE P_DEPT_ID,
            'P_END_CUSTOMER' VALUE P_END_CUSTOMER,
            'P_SCM_SITE_ID'  VALUE P_SCM_SITE_ID,
            'P_PROJECT_CODE' VALUE P_PROJECT_CODE,
            'P_ETC'          VALUE P_ETC
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX;
