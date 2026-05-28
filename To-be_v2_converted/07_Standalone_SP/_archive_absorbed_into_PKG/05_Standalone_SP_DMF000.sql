/*=============================================================================================
 * File         : 05_Standalone_SP_DMF000.sql
 * Description  : Standalone Procedures — DMF000 화면 (1개)
 *              : 향후 PKG_DMF000로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF000_GET_OWNER_DATA
(
    P_DIVISION_ID   IN VARCHAR2,
    P_OWNER_ID      IN VARCHAR2,
    P_SEARCH        IN VARCHAR2,
    P_USER_ID       IN VARCHAR2,  --UserID Team�� Owner�� ��ȸ
    P_NOW_GROUP_ID  IN VARCHAR2,  --���� Setting �� Group ID
    O_RC1           OUT SYS_REFCURSOR,  -- ���� �������� ������
    O_RC2           OUT SYS_REFCURSOR,  -- ������ �������� ������
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*********************************************************************************************
* Program ID  : [DMF000_GET_OWNER_DATA]
* Description : Procedure �ۼ� ���̵�
* Usage       : Procedure �ۼ� �� �����ϼ���!
* Parameter   :
*
*--------------------------------------------------------------------------------------------
* Date        In Charge    Description
*--------------------------------------------------------------------------------------------
* 2018/06/21  JYE       Initial Release - OWNER ��ȸ
* 20180903    JYE       DM ADMIN, DM Planner �� ��ȸ �ǵ���
* 20180904 son young suk @p_search(��ȸ��ư)���� ��ȸ�� @p_owner_id�� �ִ� ���� �ȳ����� ó��
* 20190123    JYE       42, 44 �߰�
* 20190131    ytchoi    job_name(��������)�߰�
* 20200113    P.C.I     Admin,DM Admin �����̸� ���� �� Division�� Team�� Owner�� ��ȸ�ϰ�, �� �ܴ� UserID Team�� Owner�� ��ȸ
* 20200311 KHSONG C20200103-000586 ���ѱ׷��� LOOKUP����
* 20200113    P.C.I     [C20200506-000277] Lookup PM_TEAM_MAPPING �� PM Team�� Owner ��� ����
* 20200709    HWI1993     [C20200708-000347] CMI _Marketing Team ���� �ο�
* 20220304    hwi1993   [C20220228-000147] DM Planner (WS) - Sales Site - Owner �÷� ���� Ȯ�� ��û
* 20220331	  rosia27	[����PJ20216891R]GM_JV
* 2024/10/15	KJJ			[PJ2024-50461] Team Mapping(82�� ����� PM�� ���� 40 ����ο� ����)
* 2026.03.23  kimcd     [PJ20264226] NextSCM Pilot ���� �� ����
****************************************************************************************************/

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 ���ѱ׷��� LOOKUP���� (BEGIN)
    ---------------------------------------------------------------------------------
    -- TABLE ���� ��� Schema ���� TYPE ��� (PLS-00382 ����)
    -- TYPE T_ADMIN_GROUP_TAB  IS TABLE OF VARCHAR2(100 CHAR) INDEX BY PLS_INTEGER;
    -- TYPE T_DEPT_ID_TAB      IS TABLE OF VARCHAR2(50  CHAR) INDEX BY PLS_INTEGER;
    -- TYPE ��ȯ ������ ����

    T_ADMIN_GROUP    T_STR_TAB;--T_ADMIN_GROUP_TAB;
    T_LEVEL2_DEPT_ID T_STR_TAB;--T_DEPT_ID_TAB;  -- ���������� LEVEL2 ���̵� ����.
    T_LEVEL1_DEPT_ID T_STR_TAB;--T_DEPT_ID_TAB;  -- ��Ÿ �߰��ϰ��� �ϴ� �μ��� ���̵� ����.
    T_TMP_DEPT       T_STR_TAB;--T_DEPT_ID_TAB;  --Dept_ID Table ����

    V_GROUP_ID       VARCHAR2(50  CHAR) := ' ';
    V_ADMIN_CNT      PLS_INTEGER        := 0;

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100  CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100  CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER        := 0;
    D_EVENT_DATE     DATE               := SYSDATE;

BEGIN

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 ���ѱ׷��� LOOKUP���� (BEGIN)
    ---------------------------------------------------------------------------------

    -- T_ADMIN_GROUP: LOOKUP���� ����
    SELECT SEGMENT1
    BULK COLLECT INTO T_ADMIN_GROUP
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT2    = 'ALL'
    AND    SEGMENT1    = P_NOW_GROUP_ID;

    -- T_LEVEL2_DEPT_ID
    SELECT SEGMENT1
    BULK COLLECT INTO T_LEVEL2_DEPT_ID
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'DM_OWNER_DEPT'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT2    = 'LEVEL_2';

    -- T_LEVEL1_DEPT_ID
    SELECT SEGMENT1
    BULK COLLECT INTO T_LEVEL1_DEPT_ID
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'DM_OWNER_DEPT'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT2    = 'LEVEL_1';

    -- ADMIN ���� üũ
    SELECT NVL(COUNT(1), 0)
    INTO   V_ADMIN_CNT
    FROM   TABLE(CAST(T_ADMIN_GROUP AS SCM_MGR.T_STR_TAB));

    IF V_ADMIN_CNT > 0 THEN
        V_GROUP_ID := 'ADMIN';
    END IF;

    -- GroupID JOIN ���ǿ� ���: DM Planner, DM Planner (W/S) �߰�
    T_ADMIN_GROUP.EXTEND; -- ���� 1�� �߰�
    T_ADMIN_GROUP(T_ADMIN_GROUP.LAST) := 'DM Planner';
    T_ADMIN_GROUP.EXTEND; -- ���� 1�� �߰�
    T_ADMIN_GROUP(T_ADMIN_GROUP.LAST) := 'DM Planner (W/S)';  -- [C20220228-000147]

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 ���ѱ׷��� LOOKUP���� (END)
    ---------------------------------------------------------------------------------

    -- ���������, 82 �����
    --IF @v_group_id = 'ADMIN' AND @p_division_id = '40'
    IF V_GROUP_ID = 'ADMIN' AND (P_DIVISION_ID = '40' OR P_DIVISION_ID = '82') THEN
        SELECT DISTINCT C.DEPT_ID
        BULK COLLECT INTO T_TMP_DEPT
        FROM   SCM_MGR.SCM_MST_SITE_ITEM     A
             , SCM_MGR.SCM_MST_SSO_USER_INFO  B
             , SCM_MGR.SCM_MST_SSO_DEPT_INFO  C
        WHERE  A.OWNER       = B.USER_ID
        AND    B.DEPT_ID     = C.DEPT_ID
        AND    A.DIVISION_ID = P_DIVISION_ID; -- Admin �̰� 40 ������� ��쿡 �ش� ������� Owner�� ��ȸ / 82 ������߰�[PJ2024-50461] Team Mapping
    END IF;

    -- �ڵ��� �����
    --�ڵ��� ����θ� ����
        --SCM_MST_SITE ������
    --IF @v_group_id = 'ADMIN' AND (@p_division_id LIKE '81%' OR @p_division_id = '82')
    IF V_GROUP_ID = 'ADMIN' AND P_DIVISION_ID LIKE '81%' THEN
        SELECT DEPT_ID
        BULK COLLECT INTO T_TMP_DEPT
        FROM (
            SELECT DISTINCT C.DEPT_ID
            FROM   SCM_MGR.SCM_MST_SITE_ITEM     A
                 , SCM_MGR.SCM_MST_SSO_USER_INFO  B
                 , SCM_MGR.SCM_MST_SSO_DEPT_INFO  C
            WHERE  A.OWNER       = B.USER_ID
            AND    B.DEPT_ID     = C.DEPT_ID
            AND    A.DIVISION_ID = P_DIVISION_ID
            UNION ALL
            SELECT DISTINCT SEGMENT1 AS DEPT_ID
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP
            WHERE  LOOKUP.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
            AND    LOOKUP.VALID_YN    = 'Y'
            AND    LOOKUP.SEGMENT3 IN (
                       SELECT DISTINCT C.DEPT_ID
                       FROM   SCM_MGR.SCM_MST_SITE_ITEM     A
                            , SCM_MGR.SCM_MST_SSO_USER_INFO  B
                            , SCM_MGR.SCM_MST_SSO_DEPT_INFO  C
                       WHERE  A.OWNER       = B.USER_ID
                       AND    B.DEPT_ID     = C.DEPT_ID
                       AND    A.DIVISION_ID = P_DIVISION_ID
                   )
        );

        /*(SELECT DISTINCT B.DEPT_ID
        FROM   SCM_MST_SITE          A WITH(NOLOCK)
             , SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)
        WHERE  A.SITE_TYPE = 'SALES'
        AND    A.DEPT_ID  = B.DEPT_ID
        AND    A.DIVISION_ID = @p_division_id
        UNION ALL -- [C20200506-000277] Lookup PM_TEAM_MAPPING �� PM Team�� Owner ��� ����
        SELECT DISTINCT SEGMENT1 AS DEPT_ID
        FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL LOOKUP WITH(NOLOCK)
            WHERE 	LOOKUP.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
            AND LOOKUP.VALID_YN = 'Y'
            --AND LOOKUP.SEGMENT3 = u.DEPT_ID
            AND LOOKUP.SEGMENT3 in (SELECT DISTINCT B.DEPT_ID
                                    FROM   SCM_MST_SITE          A WITH(NOLOCK)
                                         , SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)
                                    WHERE  A.SITE_TYPE = 'SALES'
                                    AND    A.DEPT_ID  = B.DEPT_ID
                                    AND    A.DIVISION_ID = @p_division_id ));-- Admin �̰� 81, 82 ������� ��쿡 �ػ� ������� Owner�� ��ȸ
                                    */
    END IF;

    IF V_GROUP_ID <> 'ADMIN' THEN
        SELECT DISTINCT DEPT_ID
        BULK COLLECT INTO T_TMP_DEPT
        FROM   SCM_MGR.SCM_ADM_USER_M
        WHERE  USE_YN  = 'Y'
        AND    USER_ID = P_USER_ID; -- Admin, DM Admin�� �ƴ� ��쿡 User ID�� Owner�� ��ȸ
    END IF;

    -- ���� �������� ������
    OPEN O_RC1 FOR
        SELECT
            FXU.USER_ID
          , FXU.USER_NM || ' ' || USER_INFO.JOB_NAME    AS USERNAME  --20190131    ytchoi    job_name(��������)�߰�
          , USER_INFO.USER_NAME_EN
          , FXU.DEPT_ID
          , DEPT_INFO.DEPT_NAME_KO
          , ROW_NUMBER() OVER (ORDER BY FXU.USER_ID, FXU.USER_NM) * 100  AS SORT_ORDER_NO
          , 'Y'  AS USER_SELECTABLE_FLAG
        FROM (SELECT * FROM SCM_MGR.SCM_ADM_USER_M WHERE USE_YN = 'Y') FXU
--      LEFT JOIN SCM_MST_SSO_DEPT_INFO AS DEPT_INFO
        INNER JOIN (
                        SELECT T.DEPT_ID      AS DEPT_ID
                             , T.DEPT_NAME_KO AS DEPT_NAME_KO
                             , T.VALID_YN
                        FROM   SCM_MGR.SCM_MST_SSO_DEPT_INFO D
                             , SCM_MGR.SCM_MST_SSO_DEPT_INFO T
                        WHERE  T.UPPER_DEPT_ID  = D.DEPT_ID
                        AND    T."2LEVEL_DEPT_ID" IN (
                                   SELECT COLUMN_VALUE FROM TABLE(CAST(T_LEVEL2_DEPT_ID AS SCM_MGR.T_STR_TAB))
                               ) -- '58174290'  -- ���������

                        UNION ALL
                        SELECT T.DEPT_ID      AS DEPT_ID
                             , T.DEPT_NAME_KO AS DEPT_NAME_KO
                             , T.VALID_YN
                        FROM   SCM_MGR.SCM_MST_SSO_DEPT_INFO D
                             , SCM_MGR.SCM_MST_SSO_DEPT_INFO T
                        WHERE  T.UPPER_DEPT_ID  = D.DEPT_ID
                        AND    T.DEPT_ID IN (
                                   SELECT COLUMN_VALUE FROM TABLE(CAST(T_LEVEL1_DEPT_ID AS SCM_MGR.T_STR_TAB))
                               ) -- '58174290'  -- ���������

                        /*
                        -- 20200311 KHSONG ������� �ʿ���ºκ� �ּ�ó��
                        AND    ( ( T.[2LEVEL_DEPT_ID] = '58174290' and @p_division_id not in ('42','44') )
                                    OR
                                   ( T.[2LEVEL_DEPT_ID] = '58366794' and @p_division_id in ('42','44') ) )		-- 20190123
                        */

                        AND    D.VALID_YN = 'Y'
                        AND    T.VALID_YN = 'Y'
                    ) DEPT_INFO
            ON FXU.DEPT_ID = DEPT_INFO.DEPT_ID AND DEPT_INFO.VALID_YN = 'Y'
        INNER JOIN SCM_MGR.SCM_MST_SSO_USER_INFO USER_INFO
            ON FXU.USER_ID = USER_INFO.USER_ID
        INNER JOIN SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M FXUGA
            ON FXU.USER_ID = FXUGA.USER_ID
            --AND (GroupID = 'DM ADMIN' OR GroupID = 'DM Planner')  -- 20180903 --20200311 KHSONG �ּ�ó��
            AND FXUGA.USER_GR_ID IN (
                    SELECT COLUMN_VALUE FROM TABLE(CAST(T_ADMIN_GROUP AS SCM_MGR.T_STR_TAB))
                )  --20200311 KHSONG C20200103-000586 ���ѱ׷��� LOOKUP����
        INNER JOIN (
                        -- String_Split(@p_search, ',') �� REGEXP_SUBSTR CONNECT BY
                        SELECT '%' || TRIM(REGEXP_SUBSTR(P_SEARCH, '[^,]+', 1, LEVEL)) || '%' AS TST
                        FROM   DUAL
                        CONNECT BY REGEXP_SUBSTR(P_SEARCH, '[^,]+', 1, LEVEL) IS NOT NULL
                    ) B
            ON (
                    CASE WHEN P_SEARCH IS NULL OR P_SEARCH = '' THEN ' '
                         ELSE USER_INFO.USER_ID
                    END LIKE B.TST
                OR  CASE WHEN P_SEARCH IS NULL OR P_SEARCH = '' THEN ' '
                         ELSE USER_INFO.USER_NAME
                    END LIKE B.TST
                OR  CASE WHEN  P_SEARCH IS NULL OR P_SEARCH = '' THEN ' '
                         ELSE DEPT_INFO.DEPT_NAME_KO
                    END LIKE B.TST
               )
        WHERE  1 = 1
        AND    FXUGA.UNIT_ID = P_DIVISION_ID
        AND    FXUGA.UNIT_TP_CD = 'D' -- ����� ���� ����
        AND    CASE WHEN P_OWNER_ID = 'ALL' THEN 'ALL'
                    ELSE USER_INFO.USER_ID
               END NOT IN (
                       SELECT TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       WHERE  (CASE WHEN P_OWNER_ID = 'ALL' THEN 'ALL' ELSE USER_INFO.USER_ID END)
                              = TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                       CONNECT BY REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
        AND    P_SEARCH NOT IN (
                       SELECT TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       WHERE  (CASE WHEN P_OWNER_ID = 'ALL' THEN 'ALL' ELSE USER_INFO.USER_ID END)
                              = TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                       CONNECT BY REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )  -- 20180904 son young suk �߰�
        AND    FXU.DEPT_ID IN (
                   SELECT COLUMN_VALUE FROM TABLE(CAST(T_TMP_DEPT AS SCM_MGR.T_STR_TAB))
               ) --Dept_ID Table
        GROUP BY FXU.USER_ID, FXU.USER_NM, USER_INFO.USER_NAME_EN, FXU.DEPT_ID, DEPT_INFO.DEPT_NAME_KO, USER_INFO.JOB_NAME
        ORDER BY DEPT_INFO.DEPT_NAME_KO, FXU.USER_NM, FXU.USER_ID;  --[PJ2024-50461] ���� ���� �߰�

    -- ������ �������� ������
    OPEN O_RC2 FOR
        SELECT
            FXU.USER_ID
          , FXU.USER_NM || ' ' || USER_INFO.JOB_NAME    AS USERNAME
          , USER_INFO.USER_NAME_EN
          , FXU.DEPT_ID
          , DEPT_INFO.DEPT_NAME_KO
          --,ROW_NUMBER() OVER (ORDER BY FXU.UserID, FXU.UserName) AS SORT_ORDER_NO
          , (
                SELECT LEVEL AS NR
                FROM   DUAL
                WHERE  TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL)) = FXU.USER_ID
                CONNECT BY REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                AND ROWNUM = 1
            ) AS SORT_ORDER_NO
          , 'Y'  AS USER_SELECTABLE_FLAG
        FROM (SELECT * FROM SCM_MGR.SCM_ADM_USER_M WHERE USE_YN = 'Y') FXU
        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO DEPT_INFO
            ON FXU.DEPT_ID = DEPT_INFO.DEPT_ID AND DEPT_INFO.VALID_YN = 'Y'
        LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO USER_INFO
            ON FXU.USER_ID = USER_INFO.USER_ID
        LEFT JOIN SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M FXUGA
            ON FXU.USER_ID = FXUGA.USER_ID
            --AND (GroupID = 'DM ADMIN' OR GroupID = 'DM Planner')  -- 20180903 --20200311 KHSONG �ּ�ó��
            AND FXUGA.USER_GR_ID IN (
                    SELECT COLUMN_VALUE FROM TABLE(CAST(T_ADMIN_GROUP AS SCM_MGR.T_STR_TAB))
                )  --20200311 KHSONG C20200103-000586 ���ѱ׷��� LOOKUP����
        -- 20180904 son young suk
        --INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_search,',') ) b
        --	ON      CASE WHEN @p_search = '' THEN @p_search
        --			ELSE USER_INFO.USER_ID  END like  b.tst
        --	OR      CASE WHEN @p_search = '' THEN @p_search
        --			ELSE USER_INFO.USER_NAME  END like  b.tst
        --	OR      CASE WHEN @p_search = '' THEN @p_search
        --			ELSE DEPT_INFO.DEPT_NAME_KO  END like  b.tst
        WHERE  1 = 1
        AND    FXUGA.UNIT_ID = P_DIVISION_ID
        AND    FXUGA.UNIT_TP_CD = 'D' -- ����� ���� ����
        AND    CASE WHEN P_OWNER_ID = 'ALL' THEN 'ALL'
                    ELSE USER_INFO.USER_ID
               END IN (
                       SELECT TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       WHERE  (CASE WHEN P_OWNER_ID = 'ALL' THEN 'ALL' ELSE USER_INFO.USER_ID END)
                              = TRIM(REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL))
                       CONNECT BY REGEXP_SUBSTR(P_OWNER_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
        GROUP BY FXU.USER_ID, FXU.USER_NM, USER_INFO.USER_NAME_EN, FXU.DEPT_ID, DEPT_INFO.DEPT_NAME_KO, USER_INFO.JOB_NAME
        ORDER BY SORT_ORDER_NO;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_DIVISION_ID'  VALUE P_DIVISION_ID,
                'P_OWNER_ID'     VALUE P_OWNER_ID,
                'P_SEARCH'       VALUE P_SEARCH,
                'P_USER_ID'      VALUE P_USER_ID,
                'P_NOW_GROUP_ID' VALUE P_NOW_GROUP_ID
            );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END DMF000_GET_OWNER_DATA;
/
