PACKAGE BODY PKG_SCP0024
IS

    /* ^ 구분 분리 결과 (AS-IS SCM_ARR_SPL_VAL 대응) */
    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;


    /* ------------------------------------------------------------
       배치 로그 (AS-IS PR_SCM_SYS_LOG_BATCH - 자율 트랜잭션으로 기록)
       ------------------------------------------------------------ */
    PROCEDURE P_LOG
    (
        P_PROGRAM_NAME  IN  VARCHAR2,
        P_LOG_TYPE      IN  VARCHAR2,
        P_LOG_MESSAGE   IN  VARCHAR2,
        P_DESCRIPTION   IN  VARCHAR2,
        P_EVENT_DATE    IN  DATE
    )
    IS
    BEGIN
        PR_SCM_SYS_LOG_BATCH(P_PROGRAM_NAME
                           , P_LOG_TYPE
                           , 0
                           , P_LOG_MESSAGE
                           , P_DESCRIPTION
                           , P_EVENT_DATE
                           , NULL
                           , NULL
                           , NULL
                           , NULL);
    END P_LOG;


    /* ------------------------------------------------------------
       오류 로그 (AS-IS CATCH 의 scm_sys_log_batch 기록 대응)
       ------------------------------------------------------------ */
    PROCEDURE P_LOG_ERROR
    (
        P_PROGRAM_NAME  IN  VARCHAR2,
        P_IN_PARA_DATA  IN  VARCHAR2,
        P_SQLCODE       IN  NUMBER,
        P_SQLERRM       IN  VARCHAR2,
        P_BACKTRACE     IN  VARCHAR2
    )
    IS
    BEGIN
        PR_SCM_SYS_LOG_BATCH(P_PROGRAM_NAME
                           , 'ERROR'
                           , NULL
                           , SUBSTR(P_SQLERRM, 1, 1000)
                           , NULL
                           , SYSDATE
                           , SUBSTR(P_IN_PARA_DATA, 1, 2000)
                           , TO_CHAR(P_SQLCODE)
                           , SUBSTR(P_SQLERRM, 1, 2000)
                           , SUBSTR(P_BACKTRACE, 1, 4000));
    END P_LOG_ERROR;


    /* ------------------------------------------------------------
       ^ 구분 CLOB 분리 (AS-IS SCM_ARR_SPL_VAL · SCM_ARR_SPL_CNT 대응)
       - 토큰 앞뒤 공백 제거, 순번 1 부터
       - O_CNT : AS-IS SCM_ARR_SPL_CNT (구분자 수 + 1)
       ------------------------------------------------------------ */
    PROCEDURE P_SPLIT_TOKEN
    (
        P_STR       IN  CLOB,
        P_DELIM     IN  VARCHAR2,
        O_TAB       OUT T_TOKEN_TAB,
        O_CNT       OUT PLS_INTEGER
    )
    IS
        V_POS       PLS_INTEGER;
        V_FROM      PLS_INTEGER := 1;
        V_NR        PLS_INTEGER := 0;
        V_LEN       PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_STR), 0);
    BEGIN

        /* AS-IS SCM_ARR_SPL_CNT('') = 1 */
        IF V_LEN = 0 THEN
            O_CNT := 1;
            RETURN;
        END IF;

        LOOP
            V_POS := DBMS_LOB.INSTR(P_STR, P_DELIM, V_FROM, 1);

            EXIT WHEN V_POS = 0 OR V_POS IS NULL;

            V_NR := V_NR + 1;
            O_TAB(V_NR) := TRIM(DBMS_LOB.SUBSTR(P_STR, V_POS - V_FROM, V_FROM));
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


    /* ========================================================================================
       내부 : FIX 이력 저장 - PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST
       ======================================================================================== */
    PROCEDURE P_FIX_HIST
    (
        P_FIX_ID                IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_OPERATION_ID          IN  VARCHAR2,
        P_YYYYMMDD              IN  VARCHAR2,
        P_QTY                   IN  VARCHAR2,
        P_FIX_REASON            IN  VARCHAR2,
        P_CREATED_BY            IN  VARCHAR2,
        P_CREATION_DATE         IN  DATE,
        P_LAST_UPDATED_BY       IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2 DEFAULT NULL,
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT NULL
    )
    IS
    /*
     * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST
     * Description  : Production Plan Fix History
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/05/17   PJS             Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/07/18	YHW				전극용 데이터 저장 추가
     * 2026.09.17   AJS            MSSQL -> Oracle 전환 (PKG_SCP0024 내부로 편입)
     */
    BEGIN

        INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H
             (
               HISTORY_SEQ
             , FIX_ID
             , DIVISION_ID
             , OPERATION_GROUP
             , SCM_SITE_ID
             , ITEM_ID
             , LINE_ID
             , OPERATION_ID
             , YYYYMMDD
             , QTY
             , FIX_REASON
             , ORIGIN_DIVISION_ID
             , ELECTRODE_TYPE
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        VALUES
             (
               SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
             , P_FIX_ID
             , P_DIVISION_ID
             , P_OPERATION_GROUP
             , P_SCM_SITE_ID
             , P_ITEM_ID
             , P_LINE_ID
             , P_OPERATION_ID
             , P_YYYYMMDD
             , TO_NUMBER(P_QTY)
             , P_FIX_REASON
             , P_ORIGIN_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_CREATED_BY
             , P_CREATION_DATE
             , P_LAST_UPDATED_BY
             , SYSDATE
             , SYSDATE
             );

    END P_FIX_HIST;


    /* ========================================================================================
       내부 : FIX 이력 일괄 저장 - PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET
              AS-IS 는 TVP(@SCP0013_HIST)를 인자로 받는다. TO-BE 는 직전 단계에서 GT_0024_DYN_FIX 에
              적재된 같은 행 집합을 그대로 읽는다(대상 집합 동일).
       ======================================================================================== */
    PROCEDURE P_FIX_HIST_DS
    IS
    /*
     * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET
     * Description  : Production Plan History
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019.02.21   HWYOON			[CSR ID:3929450] Supply(Plan Line, FG, SEMI) 수정 시 Fix 데이터 저장로직 개선
     * 2019.06.07	HWYOON			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2019.09.03	HWYOON			[CSR ID:4071705] Production Plan Fix에서 Unfix 기능 추가 - I/M/D FLAG 추가
     * 2026.09.17   AJS            MSSQL -> Oracle 전환 (PKG_SCP0024 내부로 편입)
     */
    BEGIN

        INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H
             (
               HISTORY_SEQ
             , FIX_ID
             , DIVISION_ID
             , OPERATION_GROUP
             , SCM_SITE_ID
             , ITEM_ID
             , LINE_ID
             , OPERATION_ID
             , YYYYMMDD
             , QTY
             , FIX_REASON
             , ORIGIN_DIVISION_ID
             , ELECTRODE_TYPE
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             , ATTRIBUTE1
             )
        SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
             , A.FIX_ID
             , B.P_DIVISION_ID
             , B.P_OPERATION_GROUP
             , B.P_SCM_SITE_ID
             , B.P_ITEM_ID
             , B.P_LINE_ID
             , B.P_OPERATION_ID
             , B.P_YYYYMMDD
             , TO_NUMBER(B.P_QTY)
             , A.FIX_REASON
             , B.P_ORIGIN_DIVISION_ID
             , B.P_ELECTRODE_TYPE
             , B.P_USER_ID
             , SYSDATE
             , B.P_USER_ID
             , SYSDATE
             , SYSDATE
             , B.P_ACTIVE_FLAG    /* AS-IS ISNULL(p_active_flag,'') - Oracle 은 빈 문자열이 NULL 이라 값 그대로 */
          FROM SCP_ANL_PRODUCTION_PLAN_FIX  A
             , GT_0024_DYN_FIX              B
         WHERE A.DIVISION_ID               = B.P_DIVISION_ID
           AND A.OPERATION_GROUP           = B.P_OPERATION_GROUP
           AND A.SCM_SITE_ID               = B.P_SCM_SITE_ID
           AND A.ITEM_ID                   = B.P_ITEM_ID
           AND A.LINE_ID                   = B.P_LINE_ID
           AND A.OPERATION_ID              = B.P_OPERATION_ID
           AND A.YYYYMMDD                  = B.P_YYYYMMDD
           AND NVL(A.ELECTRODE_TYPE, '-')  = NVL(B.P_ELECTRODE_TYPE, '-');
           /* AND B.p_fix='Y' */

    END P_FIX_HIST_DS;


    /* ========================================================================================
       1. SCP0024_GET_PRODUCTION_PLAN_FIX
       ======================================================================================== */
    PROCEDURE P_SCP0024_GET_PROD_PLAN_FIX
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT NULL,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',    /* AS-IS 기본값 'T' - 2026.09.17 AJS 화면 미사용 인자라 출력 없는 'F' 로 */
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
    /*
     * Program ID   : SCP0024_GET_PRODUCTION_PLAN_FIX
     * Description  : Production Plan Line 별 조회
     * Program History
     *===================================================================================================
     * Date         In Charge		Description
     *===================================================================================================
     * 2018/05/10   byunghunjung              Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/05/29   ygkim		              주차 Sum 가져오는 부분 수정
     * 2018/06/21   ygkim			          fix Reason 가져오는 쿼리 수정
     * 2018/07/18   hwyoon			          전극용 조회항목 추가
     * 2024-01-08   chaan                     PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
     * 2024-01-19   chaan           V1.1.1    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - 2차 튜닝
     * 2026.09.17   AJS                       MSSQL -> Oracle 전환
     *                                        - 칸 목록이 조회 기간에 따라 달라져 피벗 조회문만 동적 조립 (조회조건은 바인드)
     *                                        - AS-IS 대소문자 무시 비교 : 원장 대상 칸 소문자 0 건이라 조회조건만 대문자로
     *                                        - AS-IS 정렬규칙(Latin1_General_CI_AS : 대소문자·하이픈 무시, 밑줄은 글자 앞) 재현
     * 2026.10.06   AJS                       조회 속도 개선 - 날짜 칸 피벗을 PIVOT 연산으로 변경, 이름 함수 결과 재사용(결과 동일)
     */
        V_DIVISION_ID           VARCHAR2(50 CHAR);
        V_OPERATION_GROUP       VARCHAR2(50 CHAR);
        V_SCM_SITE_ID           VARCHAR2(32767 CHAR);
        V_LINE_ID               VARCHAR2(32767 CHAR);
        V_ITEM_ID               VARCHAR2(32767 CHAR);
        V_ELECTRODE_TYPE        VARCHAR2(32767 CHAR);

        V_COL_PIVOT             CLOB;
        V_SQL                   CLOB;
        V_COL_IN                CLOB;                                             --  2026.10.06 AJS
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        /* 조회조건 정리 (AS-IS 인자 길이 NVARCHAR(50) 은 넘는 값을 잘라 받는다)
           2026.09.17 AJS 선언부 대입 -> 본문 대입 (값 오류도 아래 예외 처리로) */
        V_DIVISION_ID     := SUBSTR(UPPER(RTRIM(P_DIVISION_ID)), 1, 50);
        V_OPERATION_GROUP := SUBSTR(UPPER(RTRIM(P_OPERATION_GROUP)), 1, 50);
        V_SCM_SITE_ID     := UPPER(RTRIM(P_SCM_SITE_ID));
        V_LINE_ID         := UPPER(RTRIM(P_LINE_ID));
        V_ITEM_ID         := UPPER(RTRIM(P_ITEM_ID));
        V_ELECTRODE_TYPE  := UPPER(RTRIM(P_ELECTRODE_TYPE));

        /********************************************************************************
        * PIVOIT처리
        * 2026.09.17 AJS 임시테이블(#TblDynamicPivot_SCP0024) 적재 -> 결과 조회문 안 인라인 뷰
        *   반환 커서가 세션 보존형 임시테이블을 읽으면 접속 재사용 시 고수위선이 남아 조회가 느려진다.
        *   추출 조건 · 달력 조인은 원문과 같고 조건값은 바인드로 넘긴다.
        ********************************************************************************/
        /* PIVOIT 대상 날짜문자열 생성 */
        FOR C1 IN (SELECT IA.COL_NAME
                     FROM (SELECT 'W_'||A.BASIS_YYYYMM||A.ISO_WEEK      AS COL_NAME
                                , A.BASIS_START_DATE||'21'              AS SORT_ORDER_NO
                             FROM SCM_SYS_CALENDAR_M A
                            WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                            GROUP BY A.BASIS_YYYYMM
                                   , A.ISO_WEEK
                                   , A.BASIS_START_DATE
                           UNION ALL
                           SELECT 'M_'||A.BASIS_YYYYMM                  AS COL_NAME
                                , MIN(A.BASIS_START_DATE)||'01'         AS SORT_ORDER_NO
                             FROM SCM_SYS_CALENDAR_M A
                            WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                            GROUP BY A.BASIS_YYYYMM
                                   , A.MONTH_NAME
                           UNION ALL
                           SELECT 'D_'||A.BASIS_YYYYMMDD                AS COL_NAME
                                , A.BASIS_YYYYMMDD||'31'                AS SORT_ORDER_NO
                             FROM SCM_SYS_CALENDAR_M A
                            WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                            GROUP BY A.BASIS_YYYYMMDD) IA
                    ORDER BY IA.SORT_ORDER_NO)
        LOOP
            -- 2026.10.06 AJS 날짜 칸 피벗을 PIVOT 연산으로 변경 (START)
--            /* AS-IS convert(nvarchar, convert(numeric, x)) : 소수 첫째 자리 반올림 후 문자
--               AS-IS convert(nvarchar, max(fix_reason))    : 길이 미지정 nvarchar 는 30 자로 잘린다 */
--            IF SUBSTR(C1.COL_NAME, 1, 2) = 'M_' THEN
--                V_COL_PIVOT := V_COL_PIVOT
--                            || '     , CASE WHEN XA.MEASURE = ''Prod Plan'' THEN TO_CHAR(ROUND(SUM(CASE WHEN XA.YYYYMM = '''
--                            || SUBSTR(C1.COL_NAME, -6)
--                            || ''' THEN XA.QTY END))) ELSE NULL END AS '
--                            || C1.COL_NAME
--                            || CHR(10);
--            ELSIF SUBSTR(C1.COL_NAME, 1, 2) = 'W_' THEN
--                V_COL_PIVOT := V_COL_PIVOT
--                            || '     , CASE WHEN XA.MEASURE = ''Prod Plan'' THEN TO_CHAR(ROUND(SUM(CASE WHEN XA.ISO_WEEK = '''
--                            || SUBSTR(C1.COL_NAME, -6)
--                            || ''' THEN XA.QTY END))) ELSE NULL END AS '
--                            || C1.COL_NAME
--                            || CHR(10);
--            ELSIF SUBSTR(C1.COL_NAME, 1, 2) = 'D_' THEN
--                V_COL_PIVOT := V_COL_PIVOT
--                            || '     , CASE WHEN XA.MEASURE = ''Prod Plan'' THEN TO_CHAR(ROUND(SUM(CASE WHEN XA.YYYYMMDD = '''
--                            || C1.COL_NAME
--                            || ''' THEN XA.QTY END))) ELSE SUBSTR(MAX(CASE WHEN XA.YYYYMMDD = '''
--                            || C1.COL_NAME
--                            || ''' THEN XA.FIX_REASON END), 1, 30) END AS '
--                            || C1.COL_NAME
--                            || CHR(10);
--            END IF;
            /* 칸 목록(IA.칸)과 PIVOT 값 목록을 만든다. 칸 값 계산은 아래 조회문 IB 에서 칸마다 한 번만 한다
               값 목록 : 월 'M'+연월 · 주 'W'+연월끝4자리+주차 · 일 'D_'+일자 (원래 CASE 비교값과 같은 값) */
            V_COL_PIVOT := V_COL_PIVOT
                        || '     , IA.'
                        || C1.COL_NAME
                        || CHR(10);
            V_COL_IN    := V_COL_IN
                        || CASE WHEN V_COL_IN IS NULL THEN '' ELSE '                , ' END
                        || ''''
                        || CASE SUBSTR(C1.COL_NAME, 1, 2)
                                WHEN 'M_' THEN 'M' || SUBSTR(C1.COL_NAME, -6)
                                WHEN 'W_' THEN 'W' || SUBSTR(C1.COL_NAME, -6)
                                ELSE C1.COL_NAME
                           END
                        || ''' AS '
                        || C1.COL_NAME
                        || CHR(10);
            -- 2026.10.06 AJS 날짜 칸 피벗을 PIVOT 연산으로 변경 (END)
        END LOOP;

        -- 2026.10.06 AJS 날짜 칸 피벗을 PIVOT 연산으로 변경 (START)
        /* 날짜 칸이 없으면(조회 기간에 달력 일자가 없을 때) 원래 조회문을 그대로 쓴다 */
        IF V_COL_IN IS NULL THEN
        -- 2026.10.06 AJS 날짜 칸 피벗을 PIVOT 연산으로 변경 (END)
        /* 정렬 : AS-IS 정렬규칙 재현 - 1단 하이픈·대소문자 무시 · 2단 하이픈 포함 대소문자 무시 · 3단 원값 */
        V_SQL := 'SELECT XA.DIVISION_ID'                                                         || CHR(10)
              || '     , FN_GET_DIVISION_NAME(XA.DIVISION_ID) AS DIVISION_NAME'                  || CHR(10)
              || '     , XA.OPERATION_GROUP'                                                     || CHR(10)
              || '     , FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP'', XA.OPERATION_GROUP) AS OPERATION_GROUP_NAME' || CHR(10)
              || '     , XA.SCM_SITE_ID'                                                         || CHR(10)
              || '     , FN_GET_SCM_SITE_DESCRIPTION(XA.DIVISION_ID, XA.SCM_SITE_ID) AS SCM_SITE_DESCRIPTION' || CHR(10)
              || '     , XA.OPERATION_ID'                                                        || CHR(10)
              || '     , XA.LINE_ID'                                                             || CHR(10)
              || '     , XA.ITEM_ID'                                                             || CHR(10)
              || '     , FN_GET_ITEM_NICKNAME(XA.DIVISION_ID, XA.ITEM_ID) AS NICK_NAME'          || CHR(10)
              || '     , XA.ORIGIN_DIVISION_ID'                                                  || CHR(10)
              || '     , XA.ELECTRODE_TYPE'                                                      || CHR(10)
              || '     , XA.MEASURE'                                                             || CHR(10)
              || V_COL_PIVOT
              || '  FROM (SELECT M.DIVISION_ID'                                                  || CHR(10)
              || '             , M.OPERATION_GROUP'                                              || CHR(10)
              || '             , M.SCM_SITE_ID'                                                  || CHR(10)
              || '             , M.OPERATION_ID'                                                 || CHR(10)
              || '             , M.LINE_ID'                                                      || CHR(10)
              || '             , M.ITEM_ID'                                                      || CHR(10)
              || '             , M.MEASURE'                                                      || CHR(10)
              || '             , M.QTY'                                                          || CHR(10)
              || '             , ''D_''||M.YYYYMMDD AS YYYYMMDD'                                 || CHR(10)
              || '             , N.BASIS_YYYYMM AS YYYYMM'                                       || CHR(10)
              || '             , SUBSTR(N.BASIS_YYYYMM, -4)||N.ISO_WEEK AS ISO_WEEK'             || CHR(10)
              || '             , M.FIX_REASON'                                                   || CHR(10)
              || '             , M.ORIGIN_DIVISION_ID'                                           || CHR(10)
              || '             , M.ELECTRODE_TYPE'                                               || CHR(10)
              || '          FROM (SELECT A.DIVISION_ID'                                          || CHR(10)
              || '                     , A.OPERATION_GROUP'                                      || CHR(10)
              || '                     , A.SCM_SITE_ID'                                          || CHR(10)
              || '                     , A.OPERATION_ID'                                         || CHR(10)
              || '                     , A.LINE_ID'                                              || CHR(10)
              || '                     , A.ITEM_ID'                                              || CHR(10)
              || '                     , B.MEASURE'                                              || CHR(10)
              || '                     , A.YYYYMMDD'                                             || CHR(10)
              || '                     , CASE WHEN B.MEASURE = ''Fix Reason'' THEN NULL ELSE A.QTY END AS QTY' || CHR(10)
              || '                     , A.FIX_REASON'                                           || CHR(10)
              || '                     , NVL(A.ORIGIN_DIVISION_ID, ''-'') AS ORIGIN_DIVISION_ID' || CHR(10)
              || '                     , NVL(A.ELECTRODE_TYPE, ''-'') AS ELECTRODE_TYPE'         || CHR(10)
              || '                  FROM SCP_ANL_PRODUCTION_PLAN_FIX A'                          || CHR(10)
              || '                     , (SELECT ''Fix Reason'' AS MEASURE'                      || CHR(10)
              || '                          FROM DUAL'                                           || CHR(10)
              || '                        UNION ALL'                                             || CHR(10)
              || '                        SELECT ''Prod Plan'' AS MEASURE'                       || CHR(10)
              || '                          FROM DUAL) B'                                        || CHR(10)
              || '                 WHERE (   :B_SITE1 IS NULL'                                   || CHR(10)
              || '                        OR A.SCM_SITE_ID IN (SELECT SA.COLUMN_VALUE'           || CHR(10)
              || '                                               FROM TABLE(STRING_SPLIT(:B_SITE2, '','')) SA))' || CHR(10)
              || '                   AND (   :B_ITEM1 IS NULL'                                   || CHR(10)
              || '                        OR A.ITEM_ID IN (SELECT SB.COLUMN_VALUE'               || CHR(10)
              || '                                           FROM TABLE(STRING_SPLIT(:B_ITEM2, '','')) SB))' || CHR(10)
              || '                   AND (   :B_LINE1 IS NULL'                                   || CHR(10)
              || '                        OR A.LINE_ID IN (SELECT SC.COLUMN_VALUE'               || CHR(10)
              || '                                           FROM TABLE(STRING_SPLIT(:B_LINE2, '','')) SC))' || CHR(10)
              || '                   AND (   :B_ET1 IS NULL'                                     || CHR(10)
              || '                        OR A.ELECTRODE_TYPE IN (SELECT SD.COLUMN_VALUE'        || CHR(10)
              || '                                                  FROM TABLE(STRING_SPLIT(:B_ET2, '','')) SD))' || CHR(10)
              || '                   AND A.YYYYMMDD        >= :B_FROM'                           || CHR(10)
              || '                   AND A.YYYYMMDD        <= :B_TO'                             || CHR(10)
              || '                   AND A.DIVISION_ID      = :B_DIV'                            || CHR(10)
              || '                   AND A.OPERATION_GROUP  = :B_OG) M'                          || CHR(10)
              || '             , SCM_SYS_CALENDAR_M N'                                           || CHR(10)
              || '         WHERE N.BASIS_YYYYMMDD = M.YYYYMMDD) XA'                              || CHR(10)
              || ' GROUP BY XA.DIVISION_ID'                                                      || CHR(10)
              || '        , XA.OPERATION_GROUP'                                                  || CHR(10)
              || '        , XA.SCM_SITE_ID'                                                      || CHR(10)
              || '        , XA.OPERATION_ID'                                                     || CHR(10)
              || '        , XA.LINE_ID'                                                          || CHR(10)
              || '        , XA.ITEM_ID'                                                          || CHR(10)
              || '        , XA.MEASURE'                                                          || CHR(10)
              || '        , XA.ORIGIN_DIVISION_ID'                                               || CHR(10)
              || '        , XA.ELECTRODE_TYPE'                                                   || CHR(10)
              || ' ORDER BY UPPER(TRANSLATE(XA.DIVISION_ID, ''_-'', ''/'')) NULLS FIRST'         || CHR(10)
              || '        , UPPER(TRANSLATE(XA.DIVISION_ID, ''_'', ''/'')) NULLS FIRST'          || CHR(10)
              || '        , XA.DIVISION_ID NULLS FIRST'                                          || CHR(10)
              || '        , UPPER(TRANSLATE(XA.OPERATION_GROUP, ''_-'', ''/'')) NULLS FIRST'     || CHR(10)
              || '        , UPPER(TRANSLATE(XA.OPERATION_GROUP, ''_'', ''/'')) NULLS FIRST'      || CHR(10)
              || '        , XA.OPERATION_GROUP NULLS FIRST'                                      || CHR(10)
              || '        , UPPER(TRANSLATE(XA.SCM_SITE_ID, ''_-'', ''/'')) NULLS FIRST'         || CHR(10)
              || '        , UPPER(TRANSLATE(XA.SCM_SITE_ID, ''_'', ''/'')) NULLS FIRST'          || CHR(10)
              || '        , XA.SCM_SITE_ID NULLS FIRST'                                          || CHR(10)
              || '        , UPPER(TRANSLATE(XA.OPERATION_ID, ''_-'', ''/'')) NULLS FIRST'        || CHR(10)
              || '        , UPPER(TRANSLATE(XA.OPERATION_ID, ''_'', ''/'')) NULLS FIRST'         || CHR(10)
              || '        , XA.OPERATION_ID NULLS FIRST'                                         || CHR(10)
              || '        , UPPER(TRANSLATE(XA.LINE_ID, ''_-'', ''/'')) NULLS FIRST'             || CHR(10)
              || '        , UPPER(TRANSLATE(XA.LINE_ID, ''_'', ''/'')) NULLS FIRST'              || CHR(10)
              || '        , XA.LINE_ID NULLS FIRST'                                              || CHR(10)
              || '        , UPPER(TRANSLATE(XA.ITEM_ID, ''_-'', ''/'')) NULLS FIRST'             || CHR(10)
              || '        , UPPER(TRANSLATE(XA.ITEM_ID, ''_'', ''/'')) NULLS FIRST'              || CHR(10)
              || '        , XA.ITEM_ID NULLS FIRST'                                              || CHR(10)
              || '        , XA.MEASURE DESC';
        -- 2026.10.06 AJS 날짜 칸 피벗을 PIVOT 연산으로 변경 (START)
        ELSE
            /* 원래 조회문은 행마다 날짜 칸 수만큼 CASE 집계를 계산해 52주 조회에 십수 초가 걸린다.
               IB 에서 (행 열쇠, 칸) 단위로 값을 한 번만 계산한 뒤 PIVOT 으로 펼친다.
               - 원 행 XA 를 3번(KND 1 일 · 2 주 · 3 월) 복제해 칸 값(PCOL)을 붙인다
               - Prod Plan : TO_CHAR(ROUND(SUM(QTY))) - 원래 월 · 주 · 일 칸과 같은 식
               - Fix Reason : 일 칸만 SUBSTR(MAX(FIX_REASON), 1, 30), 월 · 주 칸은 NULL - 원래와 같은 식
               - (행 열쇠, 칸) 마다 한 행이므로 PIVOT 의 MAX 는 그 값 그대로다
               이름 함수는 같은 인자면 결과를 재사용하도록 스칼라 하위질의로 감싼다 */
            V_SQL := 'SELECT IA.DIVISION_ID'                                                                  || CHR(10)
                  || '     , (SELECT FN_GET_DIVISION_NAME(IA.DIVISION_ID) FROM DUAL) AS DIVISION_NAME'        || CHR(10)
                  || '     , IA.OPERATION_GROUP'                                                              || CHR(10)
                  || '     , (SELECT FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP'', IA.OPERATION_GROUP) FROM DUAL) AS OPERATION_GROUP_NAME' || CHR(10)
                  || '     , IA.SCM_SITE_ID'                                                                  || CHR(10)
                  || '     , (SELECT FN_GET_SCM_SITE_DESCRIPTION(IA.DIVISION_ID, IA.SCM_SITE_ID) FROM DUAL) AS SCM_SITE_DESCRIPTION' || CHR(10)
                  || '     , IA.OPERATION_ID'                                                                 || CHR(10)
                  || '     , IA.LINE_ID'                                                                      || CHR(10)
                  || '     , IA.ITEM_ID'                                                                      || CHR(10)
                  || '     , (SELECT FN_GET_ITEM_NICKNAME(IA.DIVISION_ID, IA.ITEM_ID) FROM DUAL) AS NICK_NAME' || CHR(10)
                  || '     , IA.ORIGIN_DIVISION_ID'                                                           || CHR(10)
                  || '     , IA.ELECTRODE_TYPE'                                                               || CHR(10)
                  || '     , IA.MEASURE'                                                                      || CHR(10)
                  || V_COL_PIVOT
                  || '  FROM (SELECT IB.DIVISION_ID'                                                          || CHR(10)
                  || '             , IB.OPERATION_GROUP'                                                      || CHR(10)
                  || '             , IB.SCM_SITE_ID'                                                          || CHR(10)
                  || '             , IB.OPERATION_ID'                                                         || CHR(10)
                  || '             , IB.LINE_ID'                                                              || CHR(10)
                  || '             , IB.ITEM_ID'                                                              || CHR(10)
                  || '             , IB.MEASURE'                                                              || CHR(10)
                  || '             , IB.ORIGIN_DIVISION_ID'                                                   || CHR(10)
                  || '             , IB.ELECTRODE_TYPE'                                                       || CHR(10)
                  || '             , IB.PCOL'                                                                 || CHR(10)
                  || '             , IB.PVAL'                                                                 || CHR(10)
                  || '          FROM (SELECT XA.DIVISION_ID'                                                  || CHR(10)
                  || '                     , XA.OPERATION_GROUP'                                              || CHR(10)
                  || '                     , XA.SCM_SITE_ID'                                                  || CHR(10)
                  || '                     , XA.OPERATION_ID'                                                 || CHR(10)
                  || '                     , XA.LINE_ID'                                                      || CHR(10)
                  || '                     , XA.ITEM_ID'                                                      || CHR(10)
                  || '                     , XA.MEASURE'                                                      || CHR(10)
                  || '                     , XA.ORIGIN_DIVISION_ID'                                           || CHR(10)
                  || '                     , XA.ELECTRODE_TYPE'                                               || CHR(10)
                  || '                     , XB.KND'                                                          || CHR(10)
                  || '                     , CASE XB.KND WHEN 1 THEN XA.YYYYMMDD WHEN 2 THEN ''W'' || XA.ISO_WEEK ELSE ''M'' || XA.YYYYMM END AS PCOL' || CHR(10)
                  || '                     , CASE WHEN XA.MEASURE = ''Prod Plan'' THEN TO_CHAR(ROUND(SUM(XA.QTY)))' || CHR(10)
                  || '                            WHEN XB.KND = 1 THEN SUBSTR(MAX(XA.FIX_REASON), 1, 30)'     || CHR(10)
                  || '                       END AS PVAL'                                                     || CHR(10)
                  || '                  FROM (SELECT M.DIVISION_ID'                                           || CHR(10)
                  || '                             , M.OPERATION_GROUP'                                       || CHR(10)
                  || '                             , M.SCM_SITE_ID'                                           || CHR(10)
                  || '                             , M.OPERATION_ID'                                          || CHR(10)
                  || '                             , M.LINE_ID'                                               || CHR(10)
                  || '                             , M.ITEM_ID'                                               || CHR(10)
                  || '                             , M.MEASURE'                                               || CHR(10)
                  || '                             , M.QTY'                                                   || CHR(10)
                  || '                             , ''D_''||M.YYYYMMDD AS YYYYMMDD'                          || CHR(10)
                  || '                             , N.BASIS_YYYYMM AS YYYYMM'                                || CHR(10)
                  || '                             , SUBSTR(N.BASIS_YYYYMM, -4)||N.ISO_WEEK AS ISO_WEEK'      || CHR(10)
                  || '                             , M.FIX_REASON'                                            || CHR(10)
                  || '                             , M.ORIGIN_DIVISION_ID'                                    || CHR(10)
                  || '                             , M.ELECTRODE_TYPE'                                        || CHR(10)
                  || '                          FROM (SELECT A.DIVISION_ID'                                   || CHR(10)
                  || '                                     , A.OPERATION_GROUP'                               || CHR(10)
                  || '                                     , A.SCM_SITE_ID'                                   || CHR(10)
                  || '                                     , A.OPERATION_ID'                                  || CHR(10)
                  || '                                     , A.LINE_ID'                                       || CHR(10)
                  || '                                     , A.ITEM_ID'                                       || CHR(10)
                  || '                                     , B.MEASURE'                                       || CHR(10)
                  || '                                     , A.YYYYMMDD'                                      || CHR(10)
                  || '                                     , CASE WHEN B.MEASURE = ''Fix Reason'' THEN NULL ELSE A.QTY END AS QTY' || CHR(10)
                  || '                                     , A.FIX_REASON'                                    || CHR(10)
                  || '                                     , NVL(A.ORIGIN_DIVISION_ID, ''-'') AS ORIGIN_DIVISION_ID' || CHR(10)
                  || '                                     , NVL(A.ELECTRODE_TYPE, ''-'') AS ELECTRODE_TYPE'  || CHR(10)
                  || '                                  FROM SCP_ANL_PRODUCTION_PLAN_FIX A'                   || CHR(10)
                  || '                                     , (SELECT ''Fix Reason'' AS MEASURE'               || CHR(10)
                  || '                                          FROM DUAL'                                    || CHR(10)
                  || '                                        UNION ALL'                                      || CHR(10)
                  || '                                        SELECT ''Prod Plan'' AS MEASURE'                || CHR(10)
                  || '                                          FROM DUAL) B'                                 || CHR(10)
                  || '                                 WHERE (   :B_SITE1 IS NULL'                            || CHR(10)
                  || '                                        OR A.SCM_SITE_ID IN (SELECT SA.COLUMN_VALUE'    || CHR(10)
                  || '                                                               FROM TABLE(STRING_SPLIT(:B_SITE2, '','')) SA))' || CHR(10)
                  || '                                   AND (   :B_ITEM1 IS NULL'                            || CHR(10)
                  || '                                        OR A.ITEM_ID IN (SELECT SB.COLUMN_VALUE'        || CHR(10)
                  || '                                                           FROM TABLE(STRING_SPLIT(:B_ITEM2, '','')) SB))' || CHR(10)
                  || '                                   AND (   :B_LINE1 IS NULL'                            || CHR(10)
                  || '                                        OR A.LINE_ID IN (SELECT SC.COLUMN_VALUE'        || CHR(10)
                  || '                                                           FROM TABLE(STRING_SPLIT(:B_LINE2, '','')) SC))' || CHR(10)
                  || '                                   AND (   :B_ET1 IS NULL'                              || CHR(10)
                  || '                                        OR A.ELECTRODE_TYPE IN (SELECT SD.COLUMN_VALUE' || CHR(10)
                  || '                                                                  FROM TABLE(STRING_SPLIT(:B_ET2, '','')) SD))' || CHR(10)
                  || '                                   AND A.YYYYMMDD        >= :B_FROM'                    || CHR(10)
                  || '                                   AND A.YYYYMMDD        <= :B_TO'                      || CHR(10)
                  || '                                   AND A.DIVISION_ID      = :B_DIV'                     || CHR(10)
                  || '                                   AND A.OPERATION_GROUP  = :B_OG) M'                   || CHR(10)
                  || '                             , SCM_SYS_CALENDAR_M N'                                    || CHR(10)
                  || '                         WHERE N.BASIS_YYYYMMDD = M.YYYYMMDD) XA'                       || CHR(10)
                  || '                     , (SELECT 1 AS KND'                                                || CHR(10)
                  || '                          FROM DUAL'                                                    || CHR(10)
                  || '                        UNION ALL'                                                      || CHR(10)
                  || '                        SELECT 2 AS KND'                                                || CHR(10)
                  || '                          FROM DUAL'                                                    || CHR(10)
                  || '                        UNION ALL'                                                      || CHR(10)
                  || '                        SELECT 3 AS KND'                                                || CHR(10)
                  || '                          FROM DUAL) XB'                                                || CHR(10)
                  || '                 GROUP BY XA.DIVISION_ID'                                               || CHR(10)
                  || '                        , XA.OPERATION_GROUP'                                           || CHR(10)
                  || '                        , XA.SCM_SITE_ID'                                               || CHR(10)
                  || '                        , XA.OPERATION_ID'                                              || CHR(10)
                  || '                        , XA.LINE_ID'                                                   || CHR(10)
                  || '                        , XA.ITEM_ID'                                                   || CHR(10)
                  || '                        , XA.MEASURE'                                                   || CHR(10)
                  || '                        , XA.ORIGIN_DIVISION_ID'                                        || CHR(10)
                  || '                        , XA.ELECTRODE_TYPE'                                            || CHR(10)
                  || '                        , XB.KND'                                                       || CHR(10)
                  || '                        , CASE XB.KND WHEN 1 THEN XA.YYYYMMDD WHEN 2 THEN ''W'' || XA.ISO_WEEK ELSE ''M'' || XA.YYYYMM END) IB' || CHR(10)
                  || '       )'                                                                               || CHR(10)
                  || ' PIVOT (MAX(PVAL) FOR PCOL IN (' || V_COL_IN || '                )) IA'                || CHR(10)
                  || ' ORDER BY UPPER(TRANSLATE(IA.DIVISION_ID, ''_-'', ''/'')) NULLS FIRST'                  || CHR(10)
                  || '        , UPPER(TRANSLATE(IA.DIVISION_ID, ''_'', ''/'')) NULLS FIRST'                   || CHR(10)
                  || '        , IA.DIVISION_ID NULLS FIRST'                                                   || CHR(10)
                  || '        , UPPER(TRANSLATE(IA.OPERATION_GROUP, ''_-'', ''/'')) NULLS FIRST'              || CHR(10)
                  || '        , UPPER(TRANSLATE(IA.OPERATION_GROUP, ''_'', ''/'')) NULLS FIRST'               || CHR(10)
                  || '        , IA.OPERATION_GROUP NULLS FIRST'                                               || CHR(10)
                  || '        , UPPER(TRANSLATE(IA.SCM_SITE_ID, ''_-'', ''/'')) NULLS FIRST'                  || CHR(10)
                  || '        , UPPER(TRANSLATE(IA.SCM_SITE_ID, ''_'', ''/'')) NULLS FIRST'                   || CHR(10)
                  || '        , IA.SCM_SITE_ID NULLS FIRST'                                                   || CHR(10)
                  || '        , UPPER(TRANSLATE(IA.OPERATION_ID, ''_-'', ''/'')) NULLS FIRST'                 || CHR(10)
                  || '        , UPPER(TRANSLATE(IA.OPERATION_ID, ''_'', ''/'')) NULLS FIRST'                  || CHR(10)
                  || '        , IA.OPERATION_ID NULLS FIRST'                                                  || CHR(10)
                  || '        , UPPER(TRANSLATE(IA.LINE_ID, ''_-'', ''/'')) NULLS FIRST'                      || CHR(10)
                  || '        , UPPER(TRANSLATE(IA.LINE_ID, ''_'', ''/'')) NULLS FIRST'                       || CHR(10)
                  || '        , IA.LINE_ID NULLS FIRST'                                                       || CHR(10)
                  || '        , UPPER(TRANSLATE(IA.ITEM_ID, ''_-'', ''/'')) NULLS FIRST'                      || CHR(10)
                  || '        , UPPER(TRANSLATE(IA.ITEM_ID, ''_'', ''/'')) NULLS FIRST'                       || CHR(10)
                  || '        , IA.ITEM_ID NULLS FIRST'                                                       || CHR(10)
                  || '        , IA.MEASURE DESC';
        END IF;
        -- 2026.10.06 AJS 날짜 칸 피벗을 PIVOT 연산으로 변경 (END)

        IF P_DEBUG_MODE = 'T' THEN
            /* AS-IS 조립 조회문 확인용 */
            FOR I IN 0 .. TRUNC((DBMS_LOB.GETLENGTH(V_SQL) - 1) / 3000)
            LOOP
                DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(V_SQL, 3000, I * 3000 + 1));
            END LOOP;
        END IF;

        OPEN O_RC1 FOR V_SQL
        USING V_SCM_SITE_ID, V_SCM_SITE_ID
            , V_ITEM_ID, V_ITEM_ID
            , V_LINE_ID, V_LINE_ID
            , V_ELECTRODE_TYPE, V_ELECTRODE_TYPE
            , P_FROM_YYYYMMDD, P_TO_YYYYMMDD
            , V_DIVISION_ID, V_OPERATION_GROUP;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('SCP0024_GET_PRODUCTION_PLAN_FIX'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_OPERATION_GROUP=' || P_OPERATION_GROUP
                     || ', P_SCM_SITE_ID=' || SUBSTR(P_SCM_SITE_ID, 1, 500)
                     || ', P_LINE_ID=' || SUBSTR(P_LINE_ID, 1, 500)
                     || ', P_ITEM_ID=' || SUBSTR(P_ITEM_ID, 1, 300)
                     || ', P_FROM_YYYYMMDD=' || P_FROM_YYYYMMDD
                     || ', P_TO_YYYYMMDD=' || P_TO_YYYYMMDD
                     || ', P_ELECTRODE_TYPE=' || P_ELECTRODE_TYPE
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            /* 화면이 결과 커서를 읽을 수 있게 빈 커서를 연다 */
            OPEN O_RC1 FOR
            SELECT NULL                                         AS DIVISION_ID
              FROM DUAL
             WHERE 1 = 2;

    END P_SCP0024_GET_PROD_PLAN_FIX;


    /* ========================================================================================
       2. SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET
          입력 P_DATA : JSON 배열. 행마다 아래 키(대문자)를 싣는다. AS-IS 형식 테이블(DBO.SCP0013) 칸과 같다.
            ACTIVE_FLAG · DIVISION_ID · PLAN_START_YYYYMMDD · PLAN_TYPE · SEQ · OPERATION_GROUP ·
            SCM_SITE_ID · ITEM_ID · LINE_ID · OPERATION_ID · MEASURE · YYYYMMDD · QTY · FIX_REASON ·
            ORIGIN_DIVISION_ID · ELECTRODE_TYPE · BUCKET_TYPE
          등록자 : P_USER_ID (AS-IS 행별 p_user_id - 화면이 모든 행에 로그인 사용자를 싣는다)
       ======================================================================================== */
    PROCEDURE P_SCP0024_SAVE_PLAN_FIX_DS
    (
        P_DATA                  IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (START)
        -- O_RESULT_CODE           OUT VARCHAR2,
        -- O_RESULT_CNT            OUT NUMBER,
        -- O_RESULT_MSG            OUT VARCHAR2
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
        -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (END)
    )
    IS
    /*
     * Program ID   : SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET
     * Description  : PRODUCTION_PLAN_FIX 일괄등록/수정
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019/06/07   YHW				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2021/10/20   KMJ				[PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 속도 개선을 위한 변경
     * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
     * 2025/11/11   hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선
     *									- ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
     * 2026.09.17   AJS            MSSQL -> Oracle 전환
     *                              - 입력 형식 테이블(@SCP0013) -> JSON 배열(P_DATA)
     *                              - 오류 시 이 프로시저가 바꾼 원장을 저장 시작 시점으로 되돌림
     *                                (AS-IS 는 트랜잭션 없이 문장 단위 확정 - 중간 오류 시 일부만 남음)
     */
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR)  := 'SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;

        /* 실행시간 확인용 */
        V_START_TIME            DATE                := SYSDATE;
        V_EXEC_TIME             VARCHAR2(10 CHAR);

        V_MAX_LOOP_CNT          NUMBER              := 0;
        V_COMMITTED             VARCHAR2(1 CHAR)    := 'N';    /* 확정 뒤 오류는 되돌리지 않는다 (AS-IS 와 같음) */
        -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (START)
        /* SQLCODE · SQLERRM 은 SQL 문 안에서 바로 쓸 수 없으므로 변수로 받는다 */
        V_ERR_CODE              VARCHAR2(30 CHAR);
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
        -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (END)
    BEGIN

        -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (START)
        -- O_RESULT_CODE := 'S';
        -- O_RESULT_CNT  := 0;
        -- O_RESULT_MSG  := NULL;
        -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (END)

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        P_LOG(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        SAVEPOINT SP_SCP0024_SAVE_DS;

        /********************************************************************************
        * 임시테이블만들기
        ********************************************************************************/
        DELETE FROM GT_0024_DYN_FIX;
        DELETE FROM GT_0024_JV_LINE_MAP;
        DELETE FROM GT_0024_JV_SITE_MAP;
        DELETE FROM GT_0024_DIV_LAST_PLAN;

        ------------------------------------------------------------------------------------------------------------
        /* [PJ2025F254] JV/ESS 라인 및 scm site 매핑 정보 추출 */
        ------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0024_JV_LINE_MAP
             (
               VL_COMPANY_ID
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

        INSERT INTO GT_0024_JV_SITE_MAP
             (
               VP_COMPANY_ID
             , VP_DIVISION_ID
             , VP_SITE_ID
             , VP_PLANT_ID
             , VP_SCM_SITE_ID
             , RP_COMPANY_ID
             , RP_DIVISION_ID
             , RP_SITE_ID
             , RP_PLANT_ID
             , RP_SCM_SITE_ID
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
        /* DIVISION 주차별 최종 수행 Plan 버전 정보
           ESS 가상 라인 매핑 JV division의 동기화 대상 버전 정보 확인을 위한 데이터
           Final Plan은 수정 대상에서 제외 ? */
        ------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0024_DIV_LAST_PLAN
             (
               DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , PLAN_SEQ
             , HORIZON_END_DATE
             , PLAN_STATUS
             , INPUT_START_DATE
             , RN
             )
        SELECT IA.DIVISION_ID
             , IA.PLAN_START_YYYYMMDD
             , IA.PLAN_TYPE
             , IA.PLAN_SEQ
             , IA.HORIZON_END_DATE
             , IA.PLAN_STATUS
             , IA.INPUT_START_DATE
             , IA.RN
          FROM (SELECT B.DIVISION_ID
                     , A.PLAN_NAME                              AS PLAN_START_YYYYMMDD
                     , B.PLAN_TYPE
                     , B.PLAN_SEQ
                     , A.HORIZON_END_DATE
                     , B.PLAN_STATUS
                     , B.INPUT_START_DATE
                     , ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
                                                     , A.PLAN_NAME
                                              ORDER BY CASE
                                                           WHEN B.PLAN_TYPE = 'PR' THEN 4
                                                           WHEN B.PLAN_TYPE = 'MA' THEN 3
                                                           WHEN B.PLAN_TYPE = 'SE' THEN 2
                                                           WHEN B.PLAN_TYPE = 'FN' THEN 1
                                                           ELSE 0
                                                       END
                                                     , B.PLAN_SEQ DESC
                                                     , B.INPUT_START_DATE DESC) AS RN
                  FROM SCM_MST_PLAN         A
                     , SCM_MST_PLAN_DETAIL  B
                     , SCM_MST_DIVISION     C
                 WHERE B.DIVISION_ID  = A.DIVISION_ID
                   AND B.PLAN_ID      = A.PLAN_ID
                   AND C.DIVISION_ID  = A.DIVISION_ID
                   AND B.PLAN_STATUS  = '1'
                   AND C.ATTRIBUTE3  != 'EE'
                   AND A.PLAN_CYCLE   = 'WEEKLY'
                   AND A.PLAN_NAME   >= TO_CHAR(SYSDATE - 20, 'YYYYMMDD')) IA
         WHERE IA.RN         = 1
           AND IA.PLAN_TYPE != 'FN';    /* Final plan 대상에서 제외 */

        ------------------------------------------------------------------------------------------------------------
        /* 파라미터 Type 값 임시테이블에 저장
           기존 대상에서 ESS 가상 line에 매핑된 JV Real Line은 제외 : 단방향 수정 (ESS가상 -> JV) */
        ------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0024_DYN_FIX
             (
               P_ACTIVE_FLAG
             , P_DIVISION_ID
             , P_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , P_SEQ
             , P_OPERATION_GROUP
             , P_SCM_SITE_ID
             , P_ITEM_ID
             , P_LINE_ID
             , P_OPERATION_ID
             , P_MEASURE
             , P_YYYYMMDD
             , P_QTY
             , P_FIX_REASON
             , P_ORIGIN_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_USER_ID
             , P_BUCKET_TYPE
             , FIX_ID
             )
        SELECT PR.ACTIVE_FLAG
             , PR.DIVISION_ID
             , PR.PLAN_START_YYYYMMDD
             , PR.PLAN_TYPE
             , PR.SEQ
             , PR.OPERATION_GROUP
             , PR.SCM_SITE_ID
             , PR.ITEM_ID
             , PR.LINE_ID
             , PR.OPERATION_ID
             , PR.MEASURE
             , PR.YYYYMMDD
             , PR.QTY                                   /* AS-IS ISNULL(PR.p_qty, 0) */
             , PR.FIX_REASON
             , PR.ORIGIN_DIVISION_ID
             , PR.ELECTRODE_TYPE
             , P_USER_ID
             , PR.BUCKET_TYPE
             , NULL
          FROM (SELECT CASE
                           WHEN JT.ACTIVE_FLAG_RAW = '""' THEN 'X'    /* AS-IS 빈 문자열 - 아래 입력/수정 판정 대상 */
                           ELSE JT.ACTIVE_FLAG
                       END                                      AS ACTIVE_FLAG
                     , UPPER(RTRIM(JT.DIVISION_ID))                  AS DIVISION_ID
                     , JT.PLAN_START_YYYYMMDD
                     , UPPER(RTRIM(JT.PLAN_TYPE))                    AS PLAN_TYPE
                     , JT.SEQ
                     , UPPER(RTRIM(JT.OPERATION_GROUP))              AS OPERATION_GROUP
                     , UPPER(RTRIM(JT.SCM_SITE_ID))                  AS SCM_SITE_ID
                     , UPPER(RTRIM(JT.ITEM_ID))                      AS ITEM_ID
                     , UPPER(RTRIM(JT.LINE_ID))                      AS LINE_ID
                     , UPPER(RTRIM(JT.OPERATION_ID))                 AS OPERATION_ID
                     , JT.MEASURE
                     , JT.YYYYMMDD
                     , CASE
                           WHEN JT.QTY_RAW IS NULL      THEN '0'      /* 키 없음 = AS-IS NULL -> 0 */
                           WHEN JT.QTY_RAW = 'null'     THEN '0'
                           ELSE TRIM(JT.QTY)                           /* 빈 문자열·공백만은 NULL (AS-IS ISNULL(p_qty,'') = '' 처리와 같음) - 2026.09.17 AJS TRIM 추가 */
                       END                                      AS QTY
                     , JT.FIX_REASON
                     , JT.ORIGIN_DIVISION_ID
                     , UPPER(RTRIM(JT.ELECTRODE_TYPE))               AS ELECTRODE_TYPE
                     , JT.BUCKET_TYPE
                  FROM JSON_TABLE(P_DATA, '$[*]' ERROR ON ERROR    /* 형식이 틀린 입력은 오류 - 2026.09.17 AJS */
                           COLUMNS (
                               ACTIVE_FLAG          VARCHAR2(10 CHAR)   PATH '$.ACTIVE_FLAG'         NULL ON EMPTY ERROR ON ERROR
                             , ACTIVE_FLAG_RAW      VARCHAR2(20 CHAR)   FORMAT JSON PATH '$.ACTIVE_FLAG' NULL ON EMPTY
                             , DIVISION_ID          VARCHAR2(100 CHAR)  PATH '$.DIVISION_ID'         NULL ON EMPTY ERROR ON ERROR
                             , PLAN_START_YYYYMMDD  VARCHAR2(100 CHAR)  PATH '$.PLAN_START_YYYYMMDD' NULL ON EMPTY ERROR ON ERROR
                             , PLAN_TYPE            VARCHAR2(100 CHAR)  PATH '$.PLAN_TYPE'           NULL ON EMPTY ERROR ON ERROR
                             , SEQ                  VARCHAR2(100 CHAR)  PATH '$.SEQ'                 NULL ON EMPTY ERROR ON ERROR
                             , OPERATION_GROUP      VARCHAR2(100 CHAR)  PATH '$.OPERATION_GROUP'     NULL ON EMPTY ERROR ON ERROR
                             , SCM_SITE_ID          VARCHAR2(200 CHAR)  PATH '$.SCM_SITE_ID'         NULL ON EMPTY ERROR ON ERROR
                             , ITEM_ID              VARCHAR2(200 CHAR)  PATH '$.ITEM_ID'             NULL ON EMPTY ERROR ON ERROR
                             , LINE_ID              VARCHAR2(200 CHAR)  PATH '$.LINE_ID'             NULL ON EMPTY ERROR ON ERROR
                             , OPERATION_ID         VARCHAR2(200 CHAR)  PATH '$.OPERATION_ID'        NULL ON EMPTY ERROR ON ERROR
                             , MEASURE              VARCHAR2(200 CHAR)  PATH '$.MEASURE'             NULL ON EMPTY ERROR ON ERROR
                             , YYYYMMDD             VARCHAR2(100 CHAR)  PATH '$.YYYYMMDD'            NULL ON EMPTY ERROR ON ERROR
                             , QTY                  VARCHAR2(400 CHAR)  PATH '$.QTY'                 NULL ON EMPTY ERROR ON ERROR
                             , QTY_RAW              VARCHAR2(400 CHAR)  FORMAT JSON PATH '$.QTY'     NULL ON EMPTY
                             , FIX_REASON           VARCHAR2(400 CHAR)  PATH '$.FIX_REASON'          NULL ON EMPTY ERROR ON ERROR
                             , ORIGIN_DIVISION_ID   VARCHAR2(100 CHAR)  PATH '$.ORIGIN_DIVISION_ID'  NULL ON EMPTY ERROR ON ERROR
                             , ELECTRODE_TYPE       VARCHAR2(100 CHAR)  PATH '$.ELECTRODE_TYPE'      NULL ON EMPTY ERROR ON ERROR
                             , BUCKET_TYPE          VARCHAR2(100 CHAR)  PATH '$.BUCKET_TYPE'         NULL ON EMPTY ERROR ON ERROR
                           )) JT) PR
             , GT_0024_JV_SITE_MAP  SM
             , GT_0024_JV_LINE_MAP  LM
         WHERE SM.RP_DIVISION_ID(+)  = PR.DIVISION_ID
           AND SM.RP_SCM_SITE_ID(+)  = PR.SCM_SITE_ID
           AND LM.RL_DIVISION_ID(+)  = PR.DIVISION_ID
           AND LM.RL_LINE_ID(+)      = PR.LINE_ID
           AND LM.RL_COMPANY_ID(+)   = SM.RP_COMPANY_ID
           AND LM.RL_DIVISION_ID(+)  = SM.RP_DIVISION_ID
           AND LM.RL_SITE_ID(+)      = SM.RP_SITE_ID
           AND LM.RL_PLANT_ID(+)     = SM.RP_PLANT_ID
           AND LM.RL_DIVISION_ID IS NULL;    /* ESS 가상 line에 매핑된 JV Real Line은 제외  (단방향 수정 ESS가상 -> JV) */

        ------------------------------------------------------------------------------------------------------------
        /* ESS 가상 line에 매핑된 JV Real Line 정보 추가 */
        ------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0024_DYN_FIX
             (
               P_ACTIVE_FLAG
             , P_DIVISION_ID
             , P_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , P_SEQ
             , P_OPERATION_GROUP
             , P_SCM_SITE_ID
             , P_ITEM_ID
             , P_LINE_ID
             , P_OPERATION_ID
             , P_MEASURE
             , P_YYYYMMDD
             , P_QTY
             , P_FIX_REASON
             , P_ORIGIN_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_USER_ID
             , P_BUCKET_TYPE
             , FIX_ID
             )
        SELECT PR.ACTIVE_FLAG
             , LM.RL_DIVISION_ID                                AS P_DIVISION_ID
             , PR.PLAN_START_YYYYMMDD
             , PV.PLAN_TYPE                                     AS P_PLAN_TYPE
             , TO_CHAR(PV.PLAN_SEQ)                             AS P_SEQ
             , PR.OPERATION_GROUP
             , SM.RP_SCM_SITE_ID                                AS P_SCM_SITE_ID
             , PR.ITEM_ID
             , LM.RL_LINE_ID                                    AS P_LINE_ID
             , PR.OPERATION_ID
             , PR.MEASURE
             , PR.YYYYMMDD
             , PR.QTY
             , PR.FIX_REASON
             , LM.RL_DIVISION_ID                                AS P_ORIGIN_DIVISION_ID
             , PR.ELECTRODE_TYPE
             , P_USER_ID
             , PR.BUCKET_TYPE
             , NULL
          FROM (SELECT CASE
                           WHEN JT.ACTIVE_FLAG_RAW = '""' THEN 'X'
                           ELSE JT.ACTIVE_FLAG
                       END                                      AS ACTIVE_FLAG
                     , UPPER(RTRIM(JT.DIVISION_ID))                  AS DIVISION_ID
                     , JT.PLAN_START_YYYYMMDD
                     , UPPER(RTRIM(JT.OPERATION_GROUP))              AS OPERATION_GROUP
                     , UPPER(RTRIM(JT.SCM_SITE_ID))                  AS SCM_SITE_ID
                     , UPPER(RTRIM(JT.ITEM_ID))                      AS ITEM_ID
                     , UPPER(RTRIM(JT.LINE_ID))                      AS LINE_ID
                     , UPPER(RTRIM(JT.OPERATION_ID))                 AS OPERATION_ID
                     , JT.MEASURE
                     , JT.YYYYMMDD
                     , CASE
                           WHEN JT.QTY_RAW IS NULL      THEN '0'
                           WHEN JT.QTY_RAW = 'null'     THEN '0'
                           ELSE TRIM(JT.QTY)
                       END                                      AS QTY
                     , JT.FIX_REASON
                     , UPPER(RTRIM(JT.ELECTRODE_TYPE))               AS ELECTRODE_TYPE
                     , JT.BUCKET_TYPE
                  FROM JSON_TABLE(P_DATA, '$[*]' ERROR ON ERROR    /* 형식이 틀린 입력은 오류 - 2026.09.17 AJS */
                           COLUMNS (
                               ACTIVE_FLAG          VARCHAR2(10 CHAR)   PATH '$.ACTIVE_FLAG'         NULL ON EMPTY ERROR ON ERROR
                             , ACTIVE_FLAG_RAW      VARCHAR2(20 CHAR)   FORMAT JSON PATH '$.ACTIVE_FLAG' NULL ON EMPTY
                             , DIVISION_ID          VARCHAR2(100 CHAR)  PATH '$.DIVISION_ID'         NULL ON EMPTY ERROR ON ERROR
                             , PLAN_START_YYYYMMDD  VARCHAR2(100 CHAR)  PATH '$.PLAN_START_YYYYMMDD' NULL ON EMPTY ERROR ON ERROR
                             , OPERATION_GROUP      VARCHAR2(100 CHAR)  PATH '$.OPERATION_GROUP'     NULL ON EMPTY ERROR ON ERROR
                             , SCM_SITE_ID          VARCHAR2(200 CHAR)  PATH '$.SCM_SITE_ID'         NULL ON EMPTY ERROR ON ERROR
                             , ITEM_ID              VARCHAR2(200 CHAR)  PATH '$.ITEM_ID'             NULL ON EMPTY ERROR ON ERROR
                             , LINE_ID              VARCHAR2(200 CHAR)  PATH '$.LINE_ID'             NULL ON EMPTY ERROR ON ERROR
                             , OPERATION_ID         VARCHAR2(200 CHAR)  PATH '$.OPERATION_ID'        NULL ON EMPTY ERROR ON ERROR
                             , MEASURE              VARCHAR2(200 CHAR)  PATH '$.MEASURE'             NULL ON EMPTY ERROR ON ERROR
                             , YYYYMMDD             VARCHAR2(100 CHAR)  PATH '$.YYYYMMDD'            NULL ON EMPTY ERROR ON ERROR
                             , QTY                  VARCHAR2(400 CHAR)  PATH '$.QTY'                 NULL ON EMPTY ERROR ON ERROR
                             , QTY_RAW              VARCHAR2(400 CHAR)  FORMAT JSON PATH '$.QTY'     NULL ON EMPTY
                             , FIX_REASON           VARCHAR2(400 CHAR)  PATH '$.FIX_REASON'          NULL ON EMPTY ERROR ON ERROR
                             , ELECTRODE_TYPE       VARCHAR2(100 CHAR)  PATH '$.ELECTRODE_TYPE'      NULL ON EMPTY ERROR ON ERROR
                             , BUCKET_TYPE          VARCHAR2(100 CHAR)  PATH '$.BUCKET_TYPE'         NULL ON EMPTY ERROR ON ERROR
                           )) JT) PR
             , GT_0024_JV_SITE_MAP      SM
             , GT_0024_JV_LINE_MAP      LM
             , GT_0024_DIV_LAST_PLAN    PV
         WHERE SM.VP_DIVISION_ID      = PR.DIVISION_ID
           AND SM.VP_SCM_SITE_ID      = PR.SCM_SITE_ID
           AND LM.VL_DIVISION_ID      = PR.DIVISION_ID
           AND LM.VL_LINE_ID          = PR.LINE_ID
           AND LM.VL_COMPANY_ID       = SM.VP_COMPANY_ID
           AND LM.VL_DIVISION_ID      = SM.VP_DIVISION_ID
           AND LM.VL_SITE_ID          = SM.VP_SITE_ID
           AND LM.VL_PLANT_ID         = SM.VP_PLANT_ID
           AND PV.DIVISION_ID         = LM.RL_DIVISION_ID
           AND PV.PLAN_START_YYYYMMDD = PR.PLAN_START_YYYYMMDD;
        ------------------------------------------------------------------------------------------------------------------------------
        /* ### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장) */
        ------------------------------------------------------------------------------------------------------------------------------

        /* 주 SUM fix 처리  시 0 -> scp_anl_production_plan 값으로 수정 */
        UPDATE GT_0024_DYN_FIX X
           SET X.P_QTY = (SELECT TO_CHAR(T.QTY)
                            FROM SCP_ANL_PRODUCTION_PLAN T
                           WHERE T.DIVISION_ID              = X.P_DIVISION_ID
                             AND T.PLAN_START_YYYYMMDD      = X.P_PLAN_START_YYYYMMDD
                             AND T.PLAN_TYPE                = X.P_PLAN_TYPE
                             AND T.SEQ                      = TO_NUMBER(X.P_SEQ)    /* 숫자 칸 비교 - 형 일치 */
                             AND T.OPERATION_GROUP          = X.P_OPERATION_GROUP
                             AND T.SCM_SITE_ID              = X.P_SCM_SITE_ID
                             AND T.ITEM_ID                  = X.P_ITEM_ID
                             AND T.LINE_ID                  = X.P_LINE_ID
                             AND T.OPERATION_ID             = X.P_OPERATION_ID
                             /* AND T.MEASURE				= X.P_MEASURE */
                             AND T.YYYYMMDD                 = X.P_YYYYMMDD
                             AND T.PLAN_START_YYYYMMDD_DATE = TO_DATE(X.P_PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD')    /* 파티션 키 */
                             AND T.MEASURE                  = 'PROD_PLAN_AMEND'
                             AND ROWNUM                     = 1)
         WHERE EXISTS (SELECT 1
                         FROM SCP_ANL_PRODUCTION_PLAN T
                        WHERE T.DIVISION_ID              = X.P_DIVISION_ID
                          AND T.PLAN_START_YYYYMMDD      = X.P_PLAN_START_YYYYMMDD
                          AND T.PLAN_TYPE                = X.P_PLAN_TYPE
                          AND T.SEQ                      = TO_NUMBER(X.P_SEQ)
                          AND T.OPERATION_GROUP          = X.P_OPERATION_GROUP
                          AND T.SCM_SITE_ID              = X.P_SCM_SITE_ID
                          AND T.ITEM_ID                  = X.P_ITEM_ID
                          AND T.LINE_ID                  = X.P_LINE_ID
                          AND T.OPERATION_ID             = X.P_OPERATION_ID
                          AND T.YYYYMMDD                 = X.P_YYYYMMDD
                          AND T.PLAN_START_YYYYMMDD_DATE = TO_DATE(X.P_PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD')
                          AND T.MEASURE                  = 'PROD_PLAN_AMEND')
           AND X.P_BUCKET_TYPE = 'WEEKLY';

        /* 수정 Row */
        SELECT COUNT(*)
          INTO V_MAX_LOOP_CNT
          FROM GT_0024_DYN_FIX;

        /* 입력,수정모드 결정 (AS-IS 빈 문자열 표시 -> 'X') */
        UPDATE GT_0024_DYN_FIX
           SET P_ACTIVE_FLAG = 'X'
         WHERE UPPER(P_ACTIVE_FLAG) != 'D';    /* AS-IS 대소문자 무시 비교 - 2026.09.17 AJS */

        /* 수정모드 */
        UPDATE GT_0024_DYN_FIX B
           SET (B.P_ACTIVE_FLAG
              , B.FIX_ID) = (SELECT 'M'
                                  , A.FIX_ID
                               FROM SCP_ANL_PRODUCTION_PLAN_FIX A
                              WHERE A.DIVISION_ID              = B.P_DIVISION_ID
                                AND A.OPERATION_GROUP          = B.P_OPERATION_GROUP
                                AND A.SCM_SITE_ID              = B.P_SCM_SITE_ID
                                AND A.ITEM_ID                  = B.P_ITEM_ID
                                AND A.LINE_ID                  = B.P_LINE_ID
                                AND A.OPERATION_ID             = B.P_OPERATION_ID
                                AND A.YYYYMMDD                 = B.P_YYYYMMDD
                                AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-')
                                AND ROWNUM                     = 1)
         WHERE EXISTS (SELECT 1
                         FROM SCP_ANL_PRODUCTION_PLAN_FIX A
                        WHERE A.DIVISION_ID              = B.P_DIVISION_ID
                          AND A.OPERATION_GROUP          = B.P_OPERATION_GROUP
                          AND A.SCM_SITE_ID              = B.P_SCM_SITE_ID
                          AND A.ITEM_ID                  = B.P_ITEM_ID
                          AND A.LINE_ID                  = B.P_LINE_ID
                          AND A.OPERATION_ID             = B.P_OPERATION_ID
                          AND A.YYYYMMDD                 = B.P_YYYYMMDD
                          AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-'))
           AND B.P_ACTIVE_FLAG = 'X';

        /* 입력모드 */
        UPDATE GT_0024_DYN_FIX
           SET P_ACTIVE_FLAG = 'I'
         WHERE P_ACTIVE_FLAG = 'X';

        /* 입력대상 데이타 FIX_ID 채번
           AS-IS 'F' + p_yyyymmdd + REPLICATE('0', 11 - LEN(FIX_ID)) + FIX_ID (11 자리 초과 시 NULL) */
        UPDATE GT_0024_DYN_FIX
           SET FIX_ID = TO_CHAR(SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX.NEXTVAL)
         WHERE P_ACTIVE_FLAG = 'I';

        UPDATE GT_0024_DYN_FIX
           SET FIX_ID = CASE
                            WHEN LENGTH(FIX_ID) <= 11 THEN 'F'||P_YYYYMMDD||LPAD(FIX_ID, 11, '0')
                        END
         WHERE P_ACTIVE_FLAG = 'I';

        /* 수량 Null 처리 : AS-IS ISNULL(p_qty,'') = '' -> NULL. Oracle 은 빈 문자열이 이미 NULL */

        /* 1. 입력 */
        INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX
             (
               FIX_ID
             , DIVISION_ID
             , OPERATION_GROUP
             , SCM_SITE_ID
             , ITEM_ID
             , LINE_ID
             , OPERATION_ID
             , YYYYMMDD
             , QTY
             , FIX_REASON
             , ORIGIN_DIVISION_ID
             , ELECTRODE_TYPE
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             )
        SELECT FIX_ID
             , P_DIVISION_ID
             , P_OPERATION_GROUP
             , P_SCM_SITE_ID
             , P_ITEM_ID
             , P_LINE_ID
             , P_OPERATION_ID
             , P_YYYYMMDD
             , TO_NUMBER(P_QTY)
             , P_FIX_REASON
             , P_ORIGIN_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_USER_ID
             , D_EVENT_DATE
             , P_USER_ID
             , D_EVENT_DATE
          FROM GT_0024_DYN_FIX
         WHERE P_ACTIVE_FLAG = 'I';

        /* 2. 수정 */
        UPDATE SCP_ANL_PRODUCTION_PLAN_FIX A
           SET (A.QTY
              , A.FIX_REASON
              , A.LAST_UPDATED_BY
              , A.LAST_UPDATE_DATE) = (SELECT TO_NUMBER(B.P_QTY)
                                            , B.P_FIX_REASON
                                            , B.P_USER_ID
                                            , D_EVENT_DATE
                                         FROM GT_0024_DYN_FIX B
                                        WHERE B.P_DIVISION_ID            = A.DIVISION_ID
                                          AND B.P_OPERATION_GROUP        = A.OPERATION_GROUP
                                          AND B.P_SCM_SITE_ID            = A.SCM_SITE_ID
                                          AND B.P_ITEM_ID                = A.ITEM_ID
                                          AND B.P_LINE_ID                = A.LINE_ID
                                          AND B.P_OPERATION_ID           = A.OPERATION_ID
                                          AND B.P_YYYYMMDD               = A.YYYYMMDD
                                          AND NVL(B.P_ELECTRODE_TYPE, '-') = NVL(A.ELECTRODE_TYPE, '-')
                                          AND B.P_ACTIVE_FLAG            = 'M'
                                          AND ROWNUM                     = 1)
         WHERE EXISTS (SELECT 1
                         FROM GT_0024_DYN_FIX B
                        WHERE B.P_DIVISION_ID            = A.DIVISION_ID
                          AND B.P_OPERATION_GROUP        = A.OPERATION_GROUP
                          AND B.P_SCM_SITE_ID            = A.SCM_SITE_ID
                          AND B.P_ITEM_ID                = A.ITEM_ID
                          AND B.P_LINE_ID                = A.LINE_ID
                          AND B.P_OPERATION_ID           = A.OPERATION_ID
                          AND B.P_YYYYMMDD               = A.YYYYMMDD
                          AND NVL(B.P_ELECTRODE_TYPE, '-') = NVL(A.ELECTRODE_TYPE, '-')
                          AND B.P_ACTIVE_FLAG            = 'M');

        /* 3. Fix History
           2021.10.20 : 주차 fix UI 에서 fix 처리 시 0 으로 전달. 임시 테이블로 이력 테이블 생성 */
        P_FIX_HIST_DS;

        /* 4. 삭제 */
        DELETE FROM SCP_ANL_PRODUCTION_PLAN_FIX A
         WHERE EXISTS (SELECT 1
                         FROM GT_0024_DYN_FIX B
                        WHERE B.P_DIVISION_ID            = A.DIVISION_ID
                          AND B.P_OPERATION_GROUP        = A.OPERATION_GROUP
                          AND B.P_SCM_SITE_ID            = A.SCM_SITE_ID
                          AND B.P_ITEM_ID                = A.ITEM_ID
                          AND B.P_LINE_ID                = A.LINE_ID
                          AND B.P_OPERATION_ID           = A.OPERATION_ID
                          AND B.P_YYYYMMDD               = A.YYYYMMDD
                          AND NVL(B.P_ELECTRODE_TYPE, '-') = NVL(A.ELECTRODE_TYPE, '-')
                          AND UPPER(B.P_ACTIVE_FLAG)     = 'D');

        COMMIT;
        V_COMMITTED := 'Y';

        V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0')
                    || ':'
                    || LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
        P_LOG(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_MESSAGE, V_DESCRIPTION, SYSDATE);

        /* 결과코드, 결과 카운트 반환 */
        -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (START)
        -- O_RESULT_CODE := 'S';
        -- O_RESULT_CNT  := V_MAX_LOOP_CNT;
        -- O_RESULT_MSG  := NULL;
        OPEN O_RESULT_CURSOR FOR
            SELECT 'S'            AS RESULT_CODE
                 , V_MAX_LOOP_CNT AS RESULT_CNT
                 , '0'            AS CODE
                 , 'SUCCESS'      AS MSG
              FROM DUAL;
        -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (END)

    EXCEPTION
        WHEN OTHERS THEN
            -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (START)
            -- O_RESULT_CODE := 'F';
            -- O_RESULT_CNT  := 0;
            -- O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;
            V_ERR_CODE    := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SUBSTR(SQLERRM, 1, 4000);
            -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (END)

            IF V_COMMITTED = 'N' THEN
                ROLLBACK TO SAVEPOINT SP_SCP0024_SAVE_DS;
            END IF;

            P_LOG_ERROR(V_PROGRAM_NAME
                      , 'P_USER_ID=' || P_USER_ID || ', P_DATA=' || DBMS_LOB.SUBSTR(P_DATA, 1500, 1)
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (START)
            OPEN O_RESULT_CURSOR FOR
                SELECT 'F'                                        AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE  AS ERR_MESSAGE
                     , '-1'                                       AS CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE  AS MSG
                  FROM DUAL;
            -- 2026.10.06 AJS 결과 반환을 결과 커서로 변경 (END)

    END P_SCP0024_SAVE_PLAN_FIX_DS;


    /* ========================================================================================
       3. SCP0024_SAVE_PRODUCTION_PLAN_FIX
       ======================================================================================== */
    PROCEDURE P_SCP0024_SAVE_PROD_PLAN_FIX
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_OPERATION_GROUP       IN  CLOB,
        P_SCM_SITE_ID           IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_OPERATION_ID          IN  CLOB,
        P_YYYYMMDD              IN  CLOB,
        P_QTY                   IN  CLOB,
        P_FIX_REASON            IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  CLOB,
        P_ELECTRODE_TYPE        IN  CLOB,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
    /*
     * Program ID   : SCP0024_SAVE_PRODUCTION_PLAN_FIX
     * Description  : PRODUCTION_PLAN_FIX 등록,수정
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/05/17   PJS				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/07/18	YHW				전극용 저장항목 추가
     * 2019/02/26	YHW				[CSR:]FIX 데이터 존재할 시 FIX HISTORY 저장
     * 2026.09.17   AJS            MSSQL -> Oracle 전환
     *                              - 오류 시 이 프로시저가 바꾼 원장을 저장 시작 시점으로 되돌림
     *                                (AS-IS 는 트랜잭션 없이 행 단위 확정 - 중간 오류 시 앞 행만 남음)
     */
        V_DELIMITER             VARCHAR2(1 CHAR)    := '^';
        V_MAX_LOOP_CNT          PLS_INTEGER         := 0;
        V_MST_LOOP_CNT          PLS_INTEGER         := 0;
        V_DUMMY_CNT             PLS_INTEGER;

        T_ACTIVE_FLAG           T_TOKEN_TAB;
        T_DIVISION_ID           T_TOKEN_TAB;
        T_OPERATION_GROUP       T_TOKEN_TAB;
        T_SCM_SITE_ID           T_TOKEN_TAB;
        T_LINE_ID               T_TOKEN_TAB;
        T_ITEM_ID               T_TOKEN_TAB;
        T_OPERATION_ID          T_TOKEN_TAB;
        T_YYYYMMDD              T_TOKEN_TAB;
        T_QTY                   T_TOKEN_TAB;
        T_ORIGIN_DIVISION_ID    T_TOKEN_TAB;
        T_ELECTRODE_TYPE        T_TOKEN_TAB;

        V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
        V_DIVISION_ID           VARCHAR2(4000 CHAR);
        V_OPERATION_GROUP       VARCHAR2(4000 CHAR);
        V_SCM_SITE_ID           VARCHAR2(4000 CHAR);
        V_LINE_ID               VARCHAR2(4000 CHAR);
        V_ITEM_ID               VARCHAR2(4000 CHAR);
        V_OPERATION_ID          VARCHAR2(4000 CHAR);
        V_YYYYMMDD              VARCHAR2(4000 CHAR);
        V_QTY                   VARCHAR2(4000 CHAR);
        V_FIX_REASON            VARCHAR2(4000 CHAR);
        V_ORIGIN_DIVISION_ID    VARCHAR2(4000 CHAR);
        V_ELECTRODE_TYPE        VARCHAR2(4000 CHAR);
        V_LAST_UPDATED_BY       VARCHAR2(4000 CHAR) := P_USER_ID;
        V_FIX_ID                VARCHAR2(4000 CHAR);
        V_SEQ                   VARCHAR2(4000 CHAR);
        V_PK_CNT                PLS_INTEGER;

        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR)  := 'SCP0024_SAVE_PRODUCTION_PLAN_FIX';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;
        V_COMMITTED             VARCHAR2(1 CHAR)    := 'N';    /* 확정 뒤 오류는 되돌리지 않는다 (AS-IS 와 같음) */
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_CNT  := 0;
        O_RESULT_MSG  := NULL;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        P_LOG(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        SAVEPOINT SP_SCP0024_SAVE;

        /* 프로시저 LOOP 길이를 판단 */
        P_SPLIT_TOKEN(P_ACTIVE_FLAG,        V_DELIMITER, T_ACTIVE_FLAG,        V_MAX_LOOP_CNT);
        P_SPLIT_TOKEN(P_DIVISION_ID,        V_DELIMITER, T_DIVISION_ID,        V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_OPERATION_GROUP,    V_DELIMITER, T_OPERATION_GROUP,    V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_SCM_SITE_ID,        V_DELIMITER, T_SCM_SITE_ID,        V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_LINE_ID,            V_DELIMITER, T_LINE_ID,            V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_ITEM_ID,            V_DELIMITER, T_ITEM_ID,            V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_OPERATION_ID,       V_DELIMITER, T_OPERATION_ID,       V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_YYYYMMDD,           V_DELIMITER, T_YYYYMMDD,           V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_QTY,                V_DELIMITER, T_QTY,                V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_ORIGIN_DIVISION_ID, V_DELIMITER, T_ORIGIN_DIVISION_ID, V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_ELECTRODE_TYPE,     V_DELIMITER, T_ELECTRODE_TYPE,     V_DUMMY_CNT);

        /* AS-IS WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt */
        /* AS-IS LEN 은 뒤 공백을 세지 않는다 - 2026.09.17 AJS RTRIM 추가 */
        WHILE NVL(DBMS_LOB.GETLENGTH(RTRIM(P_ACTIVE_FLAG)), 0) > 0
          AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP
            /* @mst_loop_cnt 1증가 */
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트
               키 칸은 대문자로 받는다 (AS-IS 대소문자 무시 비교 · 원장 키 칸 소문자 0 건) */
            V_ACTIVE_FLAG        := F_TOKEN(T_ACTIVE_FLAG,        V_MST_LOOP_CNT);
            V_DIVISION_ID        := UPPER(F_TOKEN(T_DIVISION_ID,        V_MST_LOOP_CNT));
            V_OPERATION_GROUP    := UPPER(F_TOKEN(T_OPERATION_GROUP,    V_MST_LOOP_CNT));
            V_SCM_SITE_ID        := UPPER(F_TOKEN(T_SCM_SITE_ID,        V_MST_LOOP_CNT));
            V_LINE_ID            := UPPER(F_TOKEN(T_LINE_ID,            V_MST_LOOP_CNT));
            V_ITEM_ID            := UPPER(F_TOKEN(T_ITEM_ID,            V_MST_LOOP_CNT));
            V_OPERATION_ID       := UPPER(F_TOKEN(T_OPERATION_ID,       V_MST_LOOP_CNT));
            V_YYYYMMDD           := F_TOKEN(T_YYYYMMDD,           V_MST_LOOP_CNT);
            V_QTY                := F_TOKEN(T_QTY,                V_MST_LOOP_CNT);
            V_FIX_REASON         := P_FIX_REASON;
            V_ORIGIN_DIVISION_ID := F_TOKEN(T_ORIGIN_DIVISION_ID, V_MST_LOOP_CNT);
            V_ELECTRODE_TYPE     := UPPER(F_TOKEN(T_ELECTRODE_TYPE,     V_MST_LOOP_CNT));

            IF P_DEBUG_MODE = 'T' THEN
                DBMS_OUTPUT.PUT_LINE('@mst_loop_cnt     =' || TO_CHAR(V_MST_LOOP_CNT));
                DBMS_OUTPUT.PUT_LINE('=================================================');
                DBMS_OUTPUT.PUT_LINE('@v_active_flag     =''' || V_ACTIVE_FLAG     || '''');
                DBMS_OUTPUT.PUT_LINE('@v_division_id     =''' || V_DIVISION_ID     || '''');
                DBMS_OUTPUT.PUT_LINE('@v_operation_group =''' || V_OPERATION_GROUP || '''');
                DBMS_OUTPUT.PUT_LINE('@v_scm_site_id     =''' || V_SCM_SITE_ID     || '''');
                DBMS_OUTPUT.PUT_LINE('@v_line_id         =''' || V_LINE_ID         || '''');
                DBMS_OUTPUT.PUT_LINE('@v_item_id         =''' || V_ITEM_ID         || '''');
                DBMS_OUTPUT.PUT_LINE('@v_operation_id    =''' || V_OPERATION_ID    || '''');
                DBMS_OUTPUT.PUT_LINE('@v_yyyymmdd        =''' || V_YYYYMMDD        || '''');
                DBMS_OUTPUT.PUT_LINE('@v_qty             =''' || V_QTY             || '''');
                DBMS_OUTPUT.PUT_LINE('@v_fix_reason      =''' || V_FIX_REASON      || '''');
                DBMS_OUTPUT.PUT_LINE('@v_origin_division_id	=''' || V_ORIGIN_DIVISION_ID || '''');
                DBMS_OUTPUT.PUT_LINE('@v_electrode_type		=''' || V_ELECTRODE_TYPE     || '''');
                DBMS_OUTPUT.PUT_LINE('@p_user_id =''' || P_USER_ID || '''');
            END IF;

            /* 기존 데이타 존재여부 조회 */
            SELECT COUNT(*)
              INTO V_PK_CNT
              FROM SCP_ANL_PRODUCTION_PLAN_FIX
             WHERE DIVISION_ID              = V_DIVISION_ID
               AND OPERATION_GROUP          = V_OPERATION_GROUP
               AND SCM_SITE_ID              = V_SCM_SITE_ID
               AND ITEM_ID                  = V_ITEM_ID
               AND LINE_ID                  = V_LINE_ID
               AND OPERATION_ID             = V_OPERATION_ID
               AND YYYYMMDD                 = V_YYYYMMDD
               AND NVL(ELECTRODE_TYPE, '-') = NVL(V_ELECTRODE_TYPE, '-')
               AND ROWNUM                   = 1;    /* 존재 여부만 판단 (AS-IS @v_pk_cnt > 0) */

            IF P_DEBUG_MODE = 'T' THEN
                DBMS_OUTPUT.PUT_LINE('@v_pk_cnt =' || TO_CHAR(V_PK_CNT));
            END IF;

            /* 입력, 수정 모드 결정
               AS-IS 는 반복 범위 안의 토큰이 NULL 이 되지 않는다(빈 토큰은 '').
               Oracle 은 빈 토큰이 NULL 이므로 NULL 도 '' 와 같이 입력/수정 판정 대상으로 본다 */
            IF V_ACTIVE_FLAG IS NULL
            OR UPPER(V_ACTIVE_FLAG) != 'D' THEN    /* AS-IS 대소문자 무시 비교 - 2026.09.17 AJS */
                IF V_PK_CNT > 0 THEN
                    V_ACTIVE_FLAG := 'M';
                ELSE
                    V_ACTIVE_FLAG := 'I';
                END IF;
            END IF;

            /* FIX_KEY 생성 */
            IF V_ACTIVE_FLAG = 'I' THEN
                V_SEQ := TO_CHAR(SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX.NEXTVAL);

                IF LENGTH(V_SEQ) <= 11 THEN
                    V_FIX_ID := 'F' || V_YYYYMMDD || LPAD(V_SEQ, 11, '0');
                ELSE
                    V_FIX_ID := NULL;
                END IF;
            ELSE
                /* AS-IS SELECT @v_fix_id = FIX_ID : 행이 없으면 직전 값 유지 */
                FOR C1 IN (SELECT FIX_ID
                             FROM SCP_ANL_PRODUCTION_PLAN_FIX
                            WHERE DIVISION_ID              = V_DIVISION_ID
                              AND OPERATION_GROUP          = V_OPERATION_GROUP
                              AND SCM_SITE_ID              = V_SCM_SITE_ID
                              AND ITEM_ID                  = V_ITEM_ID
                              AND LINE_ID                  = V_LINE_ID
                              AND OPERATION_ID             = V_OPERATION_ID
                              AND YYYYMMDD                 = V_YYYYMMDD
                              AND NVL(ELECTRODE_TYPE, '-') = NVL(V_ELECTRODE_TYPE, '-'))
                LOOP
                    V_FIX_ID := C1.FIX_ID;
                END LOOP;
            END IF;

            /* IF ISNULL(@v_qty,'') = '' -> NULL : Oracle 은 빈 문자열이 이미 NULL */

            IF V_PK_CNT > 0 THEN
                P_FIX_HIST(V_FIX_ID
                         , V_DIVISION_ID
                         , V_OPERATION_GROUP
                         , V_SCM_SITE_ID
                         , V_ITEM_ID
                         , V_LINE_ID
                         , V_OPERATION_ID
                         , V_YYYYMMDD
                         , V_QTY
                         , V_FIX_REASON
                         , V_LAST_UPDATED_BY
                         , D_EVENT_DATE
                         , V_LAST_UPDATED_BY
                         , V_ORIGIN_DIVISION_ID
                         , V_ELECTRODE_TYPE);
            END IF;

            IF V_MST_LOOP_CNT > 0 THEN
                IF V_ACTIVE_FLAG = 'I' THEN
                    INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX
                         (
                           FIX_ID
                         , DIVISION_ID
                         , OPERATION_GROUP
                         , SCM_SITE_ID
                         , ITEM_ID
                         , LINE_ID
                         , OPERATION_ID
                         , YYYYMMDD
                         , QTY
                         , FIX_REASON
                         , ORIGIN_DIVISION_ID
                         , ELECTRODE_TYPE
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         )
                    VALUES
                         (
                           V_FIX_ID
                         , V_DIVISION_ID
                         , V_OPERATION_GROUP
                         , V_SCM_SITE_ID
                         , V_ITEM_ID
                         , V_LINE_ID
                         , V_OPERATION_ID
                         , V_YYYYMMDD
                         , TO_NUMBER(V_QTY)
                         , V_FIX_REASON
                         , V_ORIGIN_DIVISION_ID
                         , V_ELECTRODE_TYPE
                         , V_LAST_UPDATED_BY
                         , D_EVENT_DATE
                         , V_LAST_UPDATED_BY
                         , D_EVENT_DATE
                         );
                ELSIF V_ACTIVE_FLAG = 'M' THEN
                    UPDATE SCP_ANL_PRODUCTION_PLAN_FIX
                       SET QTY                      = TO_NUMBER(V_QTY)
                         , FIX_REASON               = V_FIX_REASON
                         , LAST_UPDATED_BY          = V_LAST_UPDATED_BY
                         , LAST_UPDATE_DATE         = D_EVENT_DATE
                     WHERE DIVISION_ID              = V_DIVISION_ID
                       AND OPERATION_GROUP          = V_OPERATION_GROUP
                       AND SCM_SITE_ID              = V_SCM_SITE_ID
                       AND ITEM_ID                  = V_ITEM_ID
                       AND LINE_ID                  = V_LINE_ID
                       AND OPERATION_ID             = V_OPERATION_ID
                       AND YYYYMMDD                 = V_YYYYMMDD
                       AND NVL(ELECTRODE_TYPE, '-') = NVL(V_ELECTRODE_TYPE, '-');
                ELSIF UPPER(V_ACTIVE_FLAG) = 'D' THEN
                    DELETE FROM SCP_ANL_PRODUCTION_PLAN_FIX
                     WHERE DIVISION_ID              = V_DIVISION_ID
                       AND OPERATION_GROUP          = V_OPERATION_GROUP
                       AND SCM_SITE_ID              = V_SCM_SITE_ID
                       AND ITEM_ID                  = V_ITEM_ID
                       AND LINE_ID                  = V_LINE_ID
                       AND OPERATION_ID             = V_OPERATION_ID
                       AND YYYYMMDD                 = V_YYYYMMDD
                       AND NVL(ELECTRODE_TYPE, '-') = NVL(V_ELECTRODE_TYPE, '-');
                END IF;
            END IF;
        END LOOP;    /* END OF WHILE */

        COMMIT;
        V_COMMITTED := 'Y';

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        P_LOG(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_MESSAGE, V_DESCRIPTION, SYSDATE);

        /* 결과코드, 결과 카운트 반환 */
        O_RESULT_CODE := 'S';
        O_RESULT_CNT  := V_MAX_LOOP_CNT;
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := 0;
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            IF V_COMMITTED = 'N' THEN
                ROLLBACK TO SAVEPOINT SP_SCP0024_SAVE;
            END IF;

            P_LOG_ERROR(V_PROGRAM_NAME
                      , 'P_USER_ID=' || P_USER_ID
                     || ', P_ACTIVE_FLAG=' || DBMS_LOB.SUBSTR(P_ACTIVE_FLAG, 200, 1)
                     || ', P_DIVISION_ID=' || DBMS_LOB.SUBSTR(P_DIVISION_ID, 200, 1)
                     || ', P_YYYYMMDD=' || DBMS_LOB.SUBSTR(P_YYYYMMDD, 500, 1)
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    END P_SCP0024_SAVE_PROD_PLAN_FIX;

END PKG_SCP0024;