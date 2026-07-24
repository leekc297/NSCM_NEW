CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_GET_SALES_VERSION_POPUP" 
(
    P_DIVISION_ID     IN VARCHAR2,
    P_SDT             IN VARCHAR2,
    P_EDT             IN VARCHAR2,
    P_VERSION_TYPE    IN VARCHAR2,
    P_DESCRIPTION     IN VARCHAR2,
    P_USER_ID         IN VARCHAR2, -- For EditYn
    P_MNU_ID          IN VARCHAR2, -- For EditYn
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*************************************************************************************************
 Program ID  : [DMF0044_GET_MDF_VERSION_POPUP]
 Description : Procedure 작성 가이드
 Usage       : Procedure 작성 시 참조하세요!
 Parameter   :

--------------------------------------------------------------------------------------------------
 Date        In Charge    Description
--------------------------------------------------------------------------------------------------
 2019/05/27  JYE
 20191121		HWI1993		DMF0044_GET_SALES_VERSION_POPUP, DMF0044_GET_COPY_VERSION_POPUP 팝업 통합
							기존 팝업의 기능을 유지하기 위해 @p_Description 파라미터를 받아서 상황에 따라 VERSION_NO 또는 DESCRIPTION 에 걸어줌

 2020/06/10	hwi1993		날짜 검색조건을 yyyymmdd(CutoffDate) 에서 Creation_date 로 변경
 20200714     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외(화요일에 Sales Paln Cutoff 제외하고 생성된 SP Version)
 20200722     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외 원복
 2021/07/03	HWI1993		하반기과제 속도개선 - 데이터 이동보관 처리
 DMF0044_GET_SALES_VERSION_POPUP '40', '20200501', '20200630', 'report_sp_w', ''
 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
***************************************************************************************************/
IS

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    IF P_VERSION_TYPE LIKE 'REPORT%' THEN

        OPEN O_RC1 FOR
        SELECT
            T1.DIVISION_ID, VERSION_NO, ORI_VERSION_NO AS ORI_VERSION
            , VERSION_DESCRIPTION, VERSION_TYPE
            , SEND_YN, VER_CRE_SEQ
            , CASE WHEN ATTRIBUTE1 = 'CP' AND REGEXP_LIKE(ATTRIBUTE2, '^\d{8}$') THEN SUBSTR(ATTRIBUTE2, 1, 4) || '-' || SUBSTR(ATTRIBUTE2, 5, 2) || '-' || SUBSTR(ATTRIBUTE2, 7, 2) ELSE NULL END AS YYYYMMDD
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY AS UPDATED_BY, LAST_UPDATE_DATE AS UPDATE_DATE
            , CASE WHEN NVL(MV_PLAN_YYYYMM, '') <> '' THEN SUBSTR(MV_PLAN_YYYYMM, 1, 4) || '-' || SUBSTR(MV_PLAN_YYYYMM, 5, 2) ELSE '' END AS MV_PLAN_YYYYMM
            , NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM DM_MDF_VERSION T1
            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON T1.DIVISION_ID = T2.UNIT_ID

        WHERE
            T1.DIVISION_ID = P_DIVISION_ID
            --AND YYYYMMDD BETWEEN @p_sdt AND @p_edt
            AND CREATION_DATE >= FN_CHAR_TO_DATE(P_SDT)
            AND CREATION_DATE < FN_CHAR_TO_DATE(P_EDT) + 1
            AND VERSION_TYPE = P_VERSION_TYPE
            AND VERSION_DESCRIPTION LIKE '%' || P_DESCRIPTION || '%'
            AND SEND_YN <> 'D'
        ORDER BY CREATION_DATE DESC, VERSION_NO;

    ELSE

        OPEN O_RC1 FOR
        -- DIVISION_ID 를 넣어서 중복이 없으므로 GROUP BY 를 하지 않음.
        WITH SPLIT_DESC AS (
            SELECT TRIM(REGEXP_SUBSTR(P_DESCRIPTION, '[^,]+', 1, LEVEL)) AS TOKEN
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_DESCRIPTION, '[^,]+', 1, LEVEL) IS NOT NULL
        )
        SELECT T1.DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE
            , NULL AS REPORT_DATE, NULL AS SEND_YN
            , NULL AS YYYYMMDD
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY AS UPDATED_BY, LAST_UPDATE_DATE AS UPDATE_DATE
            , NVL(T2.EDIT_YN,'N') AS EDIT_YN
        FROM DM_MST_VERSION T1
            INNER JOIN (SELECT * -- EDIT_YN
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
            ON T1.DIVISION_ID = T2.UNIT_ID

        WHERE (YYYYMMDD >= P_SDT AND YYYYMMDD <= P_EDT)
          AND T1.DIVISION_ID = P_DIVISION_ID
          AND VERSION_TYPE = P_VERSION_TYPE
          AND EXISTS (SELECT 1 FROM SPLIT_DESC P WHERE VERSION_NO LIKE P.TOKEN || '%')
          --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
          AND NVL(ATTRIBUTE1, '') <> 'MOVE'
        ORDER BY TO_CHAR(CREATION_DATE, 'YYYYMMDD') DESC, VERSION_NO;

    END IF;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_SDT'          VALUE P_SDT,
            'P_EDT'          VALUE P_EDT,
            'P_VERSION_TYPE' VALUE P_VERSION_TYPE,
            'P_DESCRIPTION'  VALUE P_DESCRIPTION,
            'P_USER_ID'      VALUE P_USER_ID,
            'P_MNU_ID'       VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
END DMF0044_GET_SALES_VERSION_POPUP;