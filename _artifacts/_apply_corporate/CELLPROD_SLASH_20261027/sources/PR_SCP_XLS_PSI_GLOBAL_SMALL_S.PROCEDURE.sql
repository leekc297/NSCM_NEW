PROCEDURE PR_SCP_XLS_PSI_GLOBAL_SMALL_S
( P_PLAN_CYCLE             IN VARCHAR2                        /* NVARCHAR(0150) */
, P_PLAN_START_YYYYMMDD    IN VARCHAR2                        /* NVARCHAR(0008) */
, P_PLAN_ID                IN VARCHAR2                        /* NVARCHAR(4000) */
, P_MODELING_ID            IN VARCHAR2                        /* NVARCHAR(4000) */
, P_SEQ                    IN VARCHAR2                        /* NVARCHAR(4000) */
, P_PLAN_TYPE              IN VARCHAR2                        /* NVARCHAR(4000) */
, P_MASTER_ID              IN VARCHAR2                        /* NVARCHAR(4000) */
, P_DIVISION_ID            IN VARCHAR2                        /* NVARCHAR(0030) */
, P_ENGINE_PLAN_ID         IN VARCHAR2                        /* NVARCHAR(4000) */
, P_CREATE_FROM_YYYYMMDD   IN VARCHAR2                        /* NVARCHAR(0008) */
, P_CREATE_TO_YYYYMMDD     IN VARCHAR2                        /* NVARCHAR(0008) */
, P_USER_ID                IN VARCHAR2 DEFAULT 'SCP_batch'    /* NVARCHAR(0150) = 'SCP_batch' */
, P_IS_DEBUG               IN VARCHAR2 DEFAULT '0'            /* BIT = 0 : 0:RELEASE, 1 : DEBUG */
, O_RETURN                 OUT NUMBER                         /* AS-IS RETURN 값 */
)
/*
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_SMALL_S
 * Description  : PR_SCP_XLS_PSI_GLOBAL_SMALL 에서 호출함.

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.02.04   KSK         최초생성
 * 2025.04.07   KSK        CELL_EOH의 FROM_BOH_QTY 및 FORMATION관련 메저의 YIELD 수집
 * 2025.10.14   KSK        E20251017-001667 [소형 셀 시뮬레이터] 수율 안보이는 이슈, 컬럼 숨김 기능 오류 수정
 * 2026.04.20   YMH        E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영
 * 2026-04-27   YMH        E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청
 * 2026.10.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
IS
    /* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; SET NOCOUNT ON; SET XACT_ABORT ON; (Oracle 기본 동작) */
    /* SET ANSI_WARNINGS OFF; */
    /* SET ANSI_WARNINGS ON; SET ANSI_NULLS ON; */

    /* AS-IS 인자 선언 길이 재현 */
    V_PLAN_CYCLE             VARCHAR2(150 CHAR)  := SUBSTR(P_PLAN_CYCLE, 1, 150);
    V_PLAN_START_YYYYMMDD    VARCHAR2(8 CHAR)    := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_SEQ_TXT                VARCHAR2(4000 CHAR) := SUBSTR(P_SEQ, 1, 4000);
    V_PLAN_TYPE              VARCHAR2(4000 CHAR) := SUBSTR(P_PLAN_TYPE, 1, 4000);
    V_MASTER_ID              VARCHAR2(4000 CHAR) := SUBSTR(P_MASTER_ID, 1, 4000);
    V_DIVISION_ID            VARCHAR2(30 CHAR)   := SUBSTR(P_DIVISION_ID, 1, 30);
    V_ENGINE_PLAN_ID         VARCHAR2(4000 CHAR) := SUBSTR(P_ENGINE_PLAN_ID, 1, 4000);
    V_CREATE_FROM_YYYYMMDD   VARCHAR2(8 CHAR)    := SUBSTR(P_CREATE_FROM_YYYYMMDD, 1, 8);
    V_CREATE_TO_YYYYMMDD     VARCHAR2(8 CHAR)    := SUBSTR(P_CREATE_TO_YYYYMMDD, 1, 8);
    V_USER_ID                VARCHAR2(150 CHAR)  := SUBSTR(P_USER_ID, 1, 150);
    V_SEQ                    NUMBER(19);         /* SEQ(BIGINT) 칸 비교·적재용 */

    /* LOG 용 변수 설정 */
    V_BATCH_USER             VARCHAR2(150 CHAR)  := 'SCP_batch';
    V_PROGRAM_NAME           VARCHAR2(150 CHAR)  := 'PR_SCP_XLS_PSI_GLOBAL_SMALL_S';
    V_LOG_TYPE               VARCHAR2(30 CHAR);  /* START/END/ERROR/... */
    N_LOG_COUNT              NUMBER(10)          := 0;
    V_LOG_MESSAGE            VARCHAR2(1000 CHAR);
    V_DESCRIPTION            VARCHAR2(500 CHAR);
    V_TABLE_ID               VARCHAR2(150 CHAR)  := 'SCM_SYS_LOG_BATC';
    D_EVENT_DATE             DATE;

    /* 실행시간 확인용 */
    V_START_TIME             DATE                := SYSDATE;
    V_EXEC_TIME              VARCHAR2(10 CHAR)   := NULL;  /* '00:00' */
    N_EXEC_SEC               NUMBER;

    V_PROGRAM_ID             VARCHAR2(30 CHAR)   := 'XLSPSI01';
    /* --DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) */
    /* --DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112) */

    /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청  로직 추가 시작 */
    /* 앞에서 만든 #LineLoad 동일조건이면 다시 생성안함을 위해. */
    V_TO_YYYYMMDD            VARCHAR2(8 CHAR)    := NULL;  /* CONVERT(VARCHAR(8), DATEADD(day, 728, @p_plan_start_yyyymmdd), 112) */
    V_BP_FLAG                VARCHAR2(8 CHAR)    := NULL;

    /* 오류 로그용 */
    V_SQL_ERR_CODE           VARCHAR2(100 CHAR);
    V_SQL_ERR_MSG            VARCHAR2(2000 CHAR);
    V_SQL_BACKTRACE          VARCHAR2(4000 CHAR);
BEGIN
    O_RETURN     := 1;  /* 반환값 초기화 */
    V_BATCH_USER := V_USER_ID;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    IF P_IS_DEBUG = '0' THEN
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );
    END IF;

    /* 실행시간 확인용 : V_START_TIME 선언부 초기화 */

    /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청  로직 추가 시작 */
    /* AS-IS SELECT @변수 = ... : 행이 없으면 초기값 유지, 여러 행이면 마지막 행 값 → 커서 반복으로 재현 */
    FOR CUR_PLAN IN (SELECT P.HORIZON_END_DATE
                          , CASE WHEN TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD') - TO_DATE(P.PLAN_NAME, 'YYYYMMDD') > 364 THEN 'Y'
                                 ELSE 'N'
                            END                                         AS BP_FLAG
                       FROM SCM_MST_PLAN P
                      WHERE P.PLAN_ID     = (SELECT MAX(SA.PLAN_ID)
                                               FROM SCM_MST_PLAN SA
                                              WHERE SA.DIVISION_ID          = V_DIVISION_ID
                                                AND TO_NUMBER(SA.PLAN_ID) < 9999)
                        AND P.PLAN_CYCLE  = 'WEEKLY'
                        AND P.DIVISION_ID = V_DIVISION_ID)
    LOOP
        V_TO_YYYYMMDD := CUR_PLAN.HORIZON_END_DATE;
        V_BP_FLAG     := CUR_PLAN.BP_FLAG;
    END LOOP;

    IF V_BP_FLAG = 'Y' THEN
        /* 중장기일 경우 104주차로 변경 */
        V_TO_YYYYMMDD := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364 + 363, 'YYYYMMDD');
    END IF;

    /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청  로직 추가 끝 */

    /* --DECLARE @debug_mode            NVARCHAR(30) = 'T' */
    BEGIN  /* BEGIN TRY */

        V_SEQ := TO_NUMBER(V_SEQ_TXT);

        /* ------------------------------------------------------------------------------------------------------------- */
        /* Line Load 율 - #LineLoad 를 1 YEAR 단위로 처리하기 위해서 다시 생성함 */
        /* ------------------------------------------------------------------------------------------------------------- */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step 변수확인 ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 000 ' || V_CREATE_TO_YYYYMMDD || '/' || V_TO_YYYYMMDD || '/' || V_PLAN_START_YYYYMMDD || '/' || V_CREATE_FROM_YYYYMMDD;
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        /* AS-IS != 비교 : '' 과 값의 비교가 참이 되도록 한쪽만 NULL 인 경우도 다름으로 판정 */
        IF (   V_CREATE_TO_YYYYMMDD <> V_TO_YYYYMMDD
            OR (V_CREATE_TO_YYYYMMDD IS NULL AND V_TO_YYYYMMDD IS NOT NULL)
            OR (V_CREATE_TO_YYYYMMDD IS NOT NULL AND V_TO_YYYYMMDD IS NULL))
        OR (   V_PLAN_START_YYYYMMDD <> V_CREATE_FROM_YYYYMMDD
            OR (V_PLAN_START_YYYYMMDD IS NULL AND V_CREATE_FROM_YYYYMMDD IS NOT NULL)
            OR (V_PLAN_START_YYYYMMDD IS NOT NULL AND V_CREATE_FROM_YYYYMMDD IS NULL)) THEN

            /* IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL DROP TABLE #LineLoad; */
            DELETE FROM GT_XPGS_LINELOAD;

            INSERT
              INTO GT_XPGS_LINELOAD
                 ( DIVISION_ID
                 , SCM_SITE_ID
                 , OPERATION_GROUP
                 , OPERATION_ID
                 , LINE_ID
                 , MEASURE
                 , QTY
                 , CAPA_TACT
                 , WORKING_TIME
                 , YYYYMMDD
                 , ISO_YYYYWW
                 , TIME_TERM
                 , WEEK_COLUMN
                 )
            SELECT /* DISTINCT */
                   A.DIVISION_ID
                 , A.SCM_SITE_ID
                 , A.OPERATION_GROUP
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                         WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                    END)                                                                    AS MEASURE
                 , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0
                        ELSE NVL(((ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / D.WORKING_TIME)), 0) * 100
                   END                                                                      AS QTY
                 , NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0), 0)                        AS CAPA_TACT
                 , NVL(D.WORKING_TIME, 0)                                                   AS WORKING_TIME
                 , A.YYYYMMDD
                 , C.ISO_YYYYWW
                 , M.TIME_TERM  /* 형교환(Model Change) */
                   /* AS-IS 'WQTY' + REPLICATE('0', 2 - LEN(순번)) + 순번 : 순번 세 자리 이상이면 REPLICATE 가 NULL → 결과 NULL */
                 , CASE WHEN DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY C.ISO_YYYYWW) < 100
                        THEN 'WQTY' || LPAD(TO_CHAR(DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY C.ISO_YYYYWW)), 2, '0')
                   END                                                                      AS WEEK_COLUMN
              FROM SCP_ANL_PRODUCTION_PLAN    A
                 , SCM_SYS_CALENDAR_M         C
                 , GT_XPGS_LINE_WORKINGTIME_BY_LOSS D
                 , SCP_ANL_TACT_TIME          E
                 , SCM_WORK_CALENDAR_M_SN     M
             WHERE C.BASIS_YYYYMMDD           = A.YYYYMMDD
               AND D.DIVISION_ID(+)           = A.DIVISION_ID
               AND D.OPERATION_ID(+)          = A.OPERATION_ID
               AND D.SCM_SITE_ID(+)           = A.SCM_SITE_ID
               AND D.LINE_ID(+)               = A.LINE_ID
               AND D.YYYYMMDD(+)              = A.YYYYMMDD
               AND E.DIVISION_ID(+)           = A.DIVISION_ID
               AND E.OPERATION_ID(+)          = A.OPERATION_ID
               AND E.SCM_SITE_ID(+)           = A.SCM_SITE_ID
               AND E.LINE_ID(+)               = A.LINE_ID
               AND E.ITEM_ID(+)               = A.ITEM_ID
               AND E.YYYYMMDD(+)              = A.YYYYMMDD
               /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현 */
               /* 형교환(Model Change) 적용 - start */
               AND M.DIVISION_ID(+)           = A.DIVISION_ID
               AND M.PLANT_ID(+)              = SUBSTR(A.SCM_SITE_ID, 1, 4)
               AND M.OPERATION_ID(+)          = A.OPERATION_ID
               AND M.WORK_DATE(+)             = TO_DATE(A.YYYYMMDD, 'YYYYMMDD')
               AND M.LINE_ID(+)               = A.LINE_ID
               AND M.LOSS_CODE(+)             = 'XC031'
               /* 형교환(Model Change) 적용 - end */
               AND A.DIVISION_ID              = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD      = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE                = V_PLAN_TYPE
               AND A.SEQ                      = V_SEQ
               AND A.YYYYMMDD                >= V_CREATE_FROM_YYYYMMDD
               AND A.YYYYMMDD                <= V_CREATE_TO_YYYYMMDD
               /* --	                AND A.MEASURE             IN ('CELL_PROD','PACK_PROD') */
               AND A.MEASURE                 IN ('PROD_PLAN_AMEND')
             GROUP BY A.DIVISION_ID
                    , A.SCM_SITE_ID
                    , A.OPERATION_ID
                    , A.LINE_ID
                    , A.YYYYMMDD
                    , D.WORKING_TIME
                    , C.ISO_YYYYWW
                    , A.OPERATION_GROUP
                    , (CASE WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'P' THEN 'PACK_PROD_LOAD'
                            WHEN A.MEASURE = 'PROD_PLAN_AMEND' AND A.OPERATION_GROUP = 'A' THEN 'CELL_PROD_LOAD'
                       END)
                    , M.TIME_TERM  /* 형교환(Model Change) */
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 001 #LineLoad 재생성 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

        END IF;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_SMALL_AUTO) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_SMALL_AUTO') IS NOT NULL DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_AUTO */
        /* --DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_AUTO */
        /* CREATE TABLE #SCP_XLS_PSI_GLOBAL_SMALL_AUTO(...) → GTT GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO 사전 생성
           칸 주석 : OPERATION_GROUP_NAME -- 신규 / CELL_QTY_PACK -- 신규 / TO_SITE_DESCRIPTION -- SCM_SITE_DESCRIPTION
                     PROJECT_CODE -- FG 때문에 추가 / FROM_SITE_DESCRIPTION -- SCM_SITE_DESCRIPTION
                     MEASURE_LABEL -- COLUMN_LABEL_NAME / QTY001 -- 신규 / ATTRIBUTE9 -- OPERATION_ID
                     --                CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE */
        DELETE FROM GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 002 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /*  364일 데이터 생성(PIVOIT 대상 날짜문자열 생성) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* AS-IS 는 달력(SCM_SYS_CALENDAR_M)의 생성 구간 날짜를 정렬 순번(ROW_NUMBER)대로 QTY001~QTY364 칸에 대응시키는
           SUM(CASE WHEN YYYYMMDD = '날짜' THEN QTY ELSE 0 END) AS QTYnnn 문자열을 만들어 sp_executesql 로 실행한다.
           → 동적 SQL 대신 같은 달력 순번(IA.RN)으로 칸을 고르는 정적 SQL 로 환원 */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 전체 DATA 생성 (#PSI_GLOBAL_SMALL_AUTO --> #SCP_XLS_PSI_GLOBAL_SMALL_AUTO) PIVOT */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT /* WITH (TABLOCK) */
          INTO GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001
             , QTY002
             , QTY003
             , QTY004
             , QTY005
             , QTY006
             , QTY007
             , QTY008
             , QTY009
             , QTY010
             , QTY011
             , QTY012
             , QTY013
             , QTY014
             , QTY015
             , QTY016
             , QTY017
             , QTY018
             , QTY019
             , QTY020
             , QTY021
             , QTY022
             , QTY023
             , QTY024
             , QTY025
             , QTY026
             , QTY027
             , QTY028
             , QTY029
             , QTY030
             , QTY031
             , QTY032
             , QTY033
             , QTY034
             , QTY035
             , QTY036
             , QTY037
             , QTY038
             , QTY039
             , QTY040
             , QTY041
             , QTY042
             , QTY043
             , QTY044
             , QTY045
             , QTY046
             , QTY047
             , QTY048
             , QTY049
             , QTY050
             , QTY051
             , QTY052
             , QTY053
             , QTY054
             , QTY055
             , QTY056
             , QTY057
             , QTY058
             , QTY059
             , QTY060
             , QTY061
             , QTY062
             , QTY063
             , QTY064
             , QTY065
             , QTY066
             , QTY067
             , QTY068
             , QTY069
             , QTY070
             , QTY071
             , QTY072
             , QTY073
             , QTY074
             , QTY075
             , QTY076
             , QTY077
             , QTY078
             , QTY079
             , QTY080
             , QTY081
             , QTY082
             , QTY083
             , QTY084
             , QTY085
             , QTY086
             , QTY087
             , QTY088
             , QTY089
             , QTY090
             , QTY091
             , QTY092
             , QTY093
             , QTY094
             , QTY095
             , QTY096
             , QTY097
             , QTY098
             , QTY099
             , QTY100
             , QTY101
             , QTY102
             , QTY103
             , QTY104
             , QTY105
             , QTY106
             , QTY107
             , QTY108
             , QTY109
             , QTY110
             , QTY111
             , QTY112
             , QTY113
             , QTY114
             , QTY115
             , QTY116
             , QTY117
             , QTY118
             , QTY119
             , QTY120
             , QTY121
             , QTY122
             , QTY123
             , QTY124
             , QTY125
             , QTY126
             , QTY127
             , QTY128
             , QTY129
             , QTY130
             , QTY131
             , QTY132
             , QTY133
             , QTY134
             , QTY135
             , QTY136
             , QTY137
             , QTY138
             , QTY139
             , QTY140
             , QTY141
             , QTY142
             , QTY143
             , QTY144
             , QTY145
             , QTY146
             , QTY147
             , QTY148
             , QTY149
             , QTY150
             , QTY151
             , QTY152
             , QTY153
             , QTY154
             , QTY155
             , QTY156
             , QTY157
             , QTY158
             , QTY159
             , QTY160
             , QTY161
             , QTY162
             , QTY163
             , QTY164
             , QTY165
             , QTY166
             , QTY167
             , QTY168
             , QTY169
             , QTY170
             , QTY171
             , QTY172
             , QTY173
             , QTY174
             , QTY175
             , QTY176
             , QTY177
             , QTY178
             , QTY179
             , QTY180
             , QTY181
             , QTY182
             , QTY183
             , QTY184
             , QTY185
             , QTY186
             , QTY187
             , QTY188
             , QTY189
             , QTY190
             , QTY191
             , QTY192
             , QTY193
             , QTY194
             , QTY195
             , QTY196
             , QTY197
             , QTY198
             , QTY199
             , QTY200
             , QTY201
             , QTY202
             , QTY203
             , QTY204
             , QTY205
             , QTY206
             , QTY207
             , QTY208
             , QTY209
             , QTY210
             , QTY211
             , QTY212
             , QTY213
             , QTY214
             , QTY215
             , QTY216
             , QTY217
             , QTY218
             , QTY219
             , QTY220
             , QTY221
             , QTY222
             , QTY223
             , QTY224
             , QTY225
             , QTY226
             , QTY227
             , QTY228
             , QTY229
             , QTY230
             , QTY231
             , QTY232
             , QTY233
             , QTY234
             , QTY235
             , QTY236
             , QTY237
             , QTY238
             , QTY239
             , QTY240
             , QTY241
             , QTY242
             , QTY243
             , QTY244
             , QTY245
             , QTY246
             , QTY247
             , QTY248
             , QTY249
             , QTY250
             , QTY251
             , QTY252
             , QTY253
             , QTY254
             , QTY255
             , QTY256
             , QTY257
             , QTY258
             , QTY259
             , QTY260
             , QTY261
             , QTY262
             , QTY263
             , QTY264
             , QTY265
             , QTY266
             , QTY267
             , QTY268
             , QTY269
             , QTY270
             , QTY271
             , QTY272
             , QTY273
             , QTY274
             , QTY275
             , QTY276
             , QTY277
             , QTY278
             , QTY279
             , QTY280
             , QTY281
             , QTY282
             , QTY283
             , QTY284
             , QTY285
             , QTY286
             , QTY287
             , QTY288
             , QTY289
             , QTY290
             , QTY291
             , QTY292
             , QTY293
             , QTY294
             , QTY295
             , QTY296
             , QTY297
             , QTY298
             , QTY299
             , QTY300
             , QTY301
             , QTY302
             , QTY303
             , QTY304
             , QTY305
             , QTY306
             , QTY307
             , QTY308
             , QTY309
             , QTY310
             , QTY311
             , QTY312
             , QTY313
             , QTY314
             , QTY315
             , QTY316
             , QTY317
             , QTY318
             , QTY319
             , QTY320
             , QTY321
             , QTY322
             , QTY323
             , QTY324
             , QTY325
             , QTY326
             , QTY327
             , QTY328
             , QTY329
             , QTY330
             , QTY331
             , QTY332
             , QTY333
             , QTY334
             , QTY335
             , QTY336
             , QTY337
             , QTY338
             , QTY339
             , QTY340
             , QTY341
             , QTY342
             , QTY343
             , QTY344
             , QTY345
             , QTY346
             , QTY347
             , QTY348
             , QTY349
             , QTY350
             , QTY351
             , QTY352
             , QTY353
             , QTY354
             , QTY355
             , QTY356
             , QTY357
             , QTY358
             , QTY359
             , QTY360
             , QTY361
             , QTY362
             , QTY363
             , QTY364
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT A.DIVISION_ID
             , V_PLAN_START_YYYYMMDD                                         AS PLAN_START_YYYYMMDD
             , V_PLAN_TYPE                                                   AS PLAN_TYPE
             , V_SEQ                                                         AS SEQ
             , A.OPERATION_GROUP
             , (SELECT SA.SEGMENT2
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                 WHERE SA.LOOKUP_TYPE = 'OPERATION_GROUP'
                   AND SA.SEGMENT1    = A.OPERATION_GROUP
                   AND ROWNUM         = 1)                                   AS OPERATION_GROUP_NAME
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , (SELECT (CASE WHEN SB.NICK_NAME IS NULL THEN '-' ELSE SB.NICK_NAME END)
                  FROM SCM_MST_ITEM_SN SB
                 WHERE SB.ITEM_ID = A.ITEM_ID
                   AND SB.NICK_NAME IS NOT NULL
                   AND ROWNUM     = 1)                                       AS NICK_NAME
             , 0                                                             AS CELL_QTY_PACK
             , A.TO_SITE
             , NVL((SELECT SC.SITE_DESCRIPTION
                      FROM SCM_MST_SITE SC
                     WHERE SC.SCM_SITE_ID = A.TO_SITE
                       AND ROWNUM         = 1), '-')                         AS TO_SITE_DESCRIPTION
             , A.PROJECT_CODE
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , NVL(A.INCOTERMS, '-')                                         AS INCOTERMS
             , A.FROM_SITE
             , NVL((SELECT SD.SITE_DESCRIPTION
                      FROM SCM_MST_SITE SD
                     WHERE SD.SCM_SITE_ID = A.FROM_SITE
                       AND ROWNUM         = 1), '-')                         AS FROM_SITE_DESCRIPTION
             , NVL(A.TRANSPORT_MODE, '-')                                    AS TRANSPORT_MODE
             , NVL(A.PROD_LINE, '-')                                         AS PROD_LINE
               /* AS-IS (CASE WHEN A.BOD_ID='-' THEN '-' ELSE CONVERT(NVARCHAR(50), B.LT_TOTAL_BY_WEEK) END) → INT 칸 적재 시 '-' 는 0 */
             , (CASE WHEN A.BOD_ID = '-' THEN 0 ELSE B.LT_TOTAL_BY_WEEK END) AS LT_DAY
             , A.BOD_ID
             , A.MEASURE
             , A.COLUMN_LABEL_NAME                                           AS MEASURE_LABEL
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_KEY1
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_KEY2
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_KEY3
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_KEY4
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_KEY5
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_ATTRIBUTE1
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_ATTRIBUTE2
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_ATTRIBUTE3
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_ATTRIBUTE4
             , CAST(NULL AS VARCHAR2(200 CHAR))                              AS XLS_ATTRIBUTE5
             , A.SORT_ORDER_NO
             , SUM(CASE WHEN IA.RN = 1 THEN A.QTY ELSE 0 END) AS QTY001
             , SUM(CASE WHEN IA.RN = 2 THEN A.QTY ELSE 0 END) AS QTY002
             , SUM(CASE WHEN IA.RN = 3 THEN A.QTY ELSE 0 END) AS QTY003
             , SUM(CASE WHEN IA.RN = 4 THEN A.QTY ELSE 0 END) AS QTY004
             , SUM(CASE WHEN IA.RN = 5 THEN A.QTY ELSE 0 END) AS QTY005
             , SUM(CASE WHEN IA.RN = 6 THEN A.QTY ELSE 0 END) AS QTY006
             , SUM(CASE WHEN IA.RN = 7 THEN A.QTY ELSE 0 END) AS QTY007
             , SUM(CASE WHEN IA.RN = 8 THEN A.QTY ELSE 0 END) AS QTY008
             , SUM(CASE WHEN IA.RN = 9 THEN A.QTY ELSE 0 END) AS QTY009
             , SUM(CASE WHEN IA.RN = 10 THEN A.QTY ELSE 0 END) AS QTY010
             , SUM(CASE WHEN IA.RN = 11 THEN A.QTY ELSE 0 END) AS QTY011
             , SUM(CASE WHEN IA.RN = 12 THEN A.QTY ELSE 0 END) AS QTY012
             , SUM(CASE WHEN IA.RN = 13 THEN A.QTY ELSE 0 END) AS QTY013
             , SUM(CASE WHEN IA.RN = 14 THEN A.QTY ELSE 0 END) AS QTY014
             , SUM(CASE WHEN IA.RN = 15 THEN A.QTY ELSE 0 END) AS QTY015
             , SUM(CASE WHEN IA.RN = 16 THEN A.QTY ELSE 0 END) AS QTY016
             , SUM(CASE WHEN IA.RN = 17 THEN A.QTY ELSE 0 END) AS QTY017
             , SUM(CASE WHEN IA.RN = 18 THEN A.QTY ELSE 0 END) AS QTY018
             , SUM(CASE WHEN IA.RN = 19 THEN A.QTY ELSE 0 END) AS QTY019
             , SUM(CASE WHEN IA.RN = 20 THEN A.QTY ELSE 0 END) AS QTY020
             , SUM(CASE WHEN IA.RN = 21 THEN A.QTY ELSE 0 END) AS QTY021
             , SUM(CASE WHEN IA.RN = 22 THEN A.QTY ELSE 0 END) AS QTY022
             , SUM(CASE WHEN IA.RN = 23 THEN A.QTY ELSE 0 END) AS QTY023
             , SUM(CASE WHEN IA.RN = 24 THEN A.QTY ELSE 0 END) AS QTY024
             , SUM(CASE WHEN IA.RN = 25 THEN A.QTY ELSE 0 END) AS QTY025
             , SUM(CASE WHEN IA.RN = 26 THEN A.QTY ELSE 0 END) AS QTY026
             , SUM(CASE WHEN IA.RN = 27 THEN A.QTY ELSE 0 END) AS QTY027
             , SUM(CASE WHEN IA.RN = 28 THEN A.QTY ELSE 0 END) AS QTY028
             , SUM(CASE WHEN IA.RN = 29 THEN A.QTY ELSE 0 END) AS QTY029
             , SUM(CASE WHEN IA.RN = 30 THEN A.QTY ELSE 0 END) AS QTY030
             , SUM(CASE WHEN IA.RN = 31 THEN A.QTY ELSE 0 END) AS QTY031
             , SUM(CASE WHEN IA.RN = 32 THEN A.QTY ELSE 0 END) AS QTY032
             , SUM(CASE WHEN IA.RN = 33 THEN A.QTY ELSE 0 END) AS QTY033
             , SUM(CASE WHEN IA.RN = 34 THEN A.QTY ELSE 0 END) AS QTY034
             , SUM(CASE WHEN IA.RN = 35 THEN A.QTY ELSE 0 END) AS QTY035
             , SUM(CASE WHEN IA.RN = 36 THEN A.QTY ELSE 0 END) AS QTY036
             , SUM(CASE WHEN IA.RN = 37 THEN A.QTY ELSE 0 END) AS QTY037
             , SUM(CASE WHEN IA.RN = 38 THEN A.QTY ELSE 0 END) AS QTY038
             , SUM(CASE WHEN IA.RN = 39 THEN A.QTY ELSE 0 END) AS QTY039
             , SUM(CASE WHEN IA.RN = 40 THEN A.QTY ELSE 0 END) AS QTY040
             , SUM(CASE WHEN IA.RN = 41 THEN A.QTY ELSE 0 END) AS QTY041
             , SUM(CASE WHEN IA.RN = 42 THEN A.QTY ELSE 0 END) AS QTY042
             , SUM(CASE WHEN IA.RN = 43 THEN A.QTY ELSE 0 END) AS QTY043
             , SUM(CASE WHEN IA.RN = 44 THEN A.QTY ELSE 0 END) AS QTY044
             , SUM(CASE WHEN IA.RN = 45 THEN A.QTY ELSE 0 END) AS QTY045
             , SUM(CASE WHEN IA.RN = 46 THEN A.QTY ELSE 0 END) AS QTY046
             , SUM(CASE WHEN IA.RN = 47 THEN A.QTY ELSE 0 END) AS QTY047
             , SUM(CASE WHEN IA.RN = 48 THEN A.QTY ELSE 0 END) AS QTY048
             , SUM(CASE WHEN IA.RN = 49 THEN A.QTY ELSE 0 END) AS QTY049
             , SUM(CASE WHEN IA.RN = 50 THEN A.QTY ELSE 0 END) AS QTY050
             , SUM(CASE WHEN IA.RN = 51 THEN A.QTY ELSE 0 END) AS QTY051
             , SUM(CASE WHEN IA.RN = 52 THEN A.QTY ELSE 0 END) AS QTY052
             , SUM(CASE WHEN IA.RN = 53 THEN A.QTY ELSE 0 END) AS QTY053
             , SUM(CASE WHEN IA.RN = 54 THEN A.QTY ELSE 0 END) AS QTY054
             , SUM(CASE WHEN IA.RN = 55 THEN A.QTY ELSE 0 END) AS QTY055
             , SUM(CASE WHEN IA.RN = 56 THEN A.QTY ELSE 0 END) AS QTY056
             , SUM(CASE WHEN IA.RN = 57 THEN A.QTY ELSE 0 END) AS QTY057
             , SUM(CASE WHEN IA.RN = 58 THEN A.QTY ELSE 0 END) AS QTY058
             , SUM(CASE WHEN IA.RN = 59 THEN A.QTY ELSE 0 END) AS QTY059
             , SUM(CASE WHEN IA.RN = 60 THEN A.QTY ELSE 0 END) AS QTY060
             , SUM(CASE WHEN IA.RN = 61 THEN A.QTY ELSE 0 END) AS QTY061
             , SUM(CASE WHEN IA.RN = 62 THEN A.QTY ELSE 0 END) AS QTY062
             , SUM(CASE WHEN IA.RN = 63 THEN A.QTY ELSE 0 END) AS QTY063
             , SUM(CASE WHEN IA.RN = 64 THEN A.QTY ELSE 0 END) AS QTY064
             , SUM(CASE WHEN IA.RN = 65 THEN A.QTY ELSE 0 END) AS QTY065
             , SUM(CASE WHEN IA.RN = 66 THEN A.QTY ELSE 0 END) AS QTY066
             , SUM(CASE WHEN IA.RN = 67 THEN A.QTY ELSE 0 END) AS QTY067
             , SUM(CASE WHEN IA.RN = 68 THEN A.QTY ELSE 0 END) AS QTY068
             , SUM(CASE WHEN IA.RN = 69 THEN A.QTY ELSE 0 END) AS QTY069
             , SUM(CASE WHEN IA.RN = 70 THEN A.QTY ELSE 0 END) AS QTY070
             , SUM(CASE WHEN IA.RN = 71 THEN A.QTY ELSE 0 END) AS QTY071
             , SUM(CASE WHEN IA.RN = 72 THEN A.QTY ELSE 0 END) AS QTY072
             , SUM(CASE WHEN IA.RN = 73 THEN A.QTY ELSE 0 END) AS QTY073
             , SUM(CASE WHEN IA.RN = 74 THEN A.QTY ELSE 0 END) AS QTY074
             , SUM(CASE WHEN IA.RN = 75 THEN A.QTY ELSE 0 END) AS QTY075
             , SUM(CASE WHEN IA.RN = 76 THEN A.QTY ELSE 0 END) AS QTY076
             , SUM(CASE WHEN IA.RN = 77 THEN A.QTY ELSE 0 END) AS QTY077
             , SUM(CASE WHEN IA.RN = 78 THEN A.QTY ELSE 0 END) AS QTY078
             , SUM(CASE WHEN IA.RN = 79 THEN A.QTY ELSE 0 END) AS QTY079
             , SUM(CASE WHEN IA.RN = 80 THEN A.QTY ELSE 0 END) AS QTY080
             , SUM(CASE WHEN IA.RN = 81 THEN A.QTY ELSE 0 END) AS QTY081
             , SUM(CASE WHEN IA.RN = 82 THEN A.QTY ELSE 0 END) AS QTY082
             , SUM(CASE WHEN IA.RN = 83 THEN A.QTY ELSE 0 END) AS QTY083
             , SUM(CASE WHEN IA.RN = 84 THEN A.QTY ELSE 0 END) AS QTY084
             , SUM(CASE WHEN IA.RN = 85 THEN A.QTY ELSE 0 END) AS QTY085
             , SUM(CASE WHEN IA.RN = 86 THEN A.QTY ELSE 0 END) AS QTY086
             , SUM(CASE WHEN IA.RN = 87 THEN A.QTY ELSE 0 END) AS QTY087
             , SUM(CASE WHEN IA.RN = 88 THEN A.QTY ELSE 0 END) AS QTY088
             , SUM(CASE WHEN IA.RN = 89 THEN A.QTY ELSE 0 END) AS QTY089
             , SUM(CASE WHEN IA.RN = 90 THEN A.QTY ELSE 0 END) AS QTY090
             , SUM(CASE WHEN IA.RN = 91 THEN A.QTY ELSE 0 END) AS QTY091
             , SUM(CASE WHEN IA.RN = 92 THEN A.QTY ELSE 0 END) AS QTY092
             , SUM(CASE WHEN IA.RN = 93 THEN A.QTY ELSE 0 END) AS QTY093
             , SUM(CASE WHEN IA.RN = 94 THEN A.QTY ELSE 0 END) AS QTY094
             , SUM(CASE WHEN IA.RN = 95 THEN A.QTY ELSE 0 END) AS QTY095
             , SUM(CASE WHEN IA.RN = 96 THEN A.QTY ELSE 0 END) AS QTY096
             , SUM(CASE WHEN IA.RN = 97 THEN A.QTY ELSE 0 END) AS QTY097
             , SUM(CASE WHEN IA.RN = 98 THEN A.QTY ELSE 0 END) AS QTY098
             , SUM(CASE WHEN IA.RN = 99 THEN A.QTY ELSE 0 END) AS QTY099
             , SUM(CASE WHEN IA.RN = 100 THEN A.QTY ELSE 0 END) AS QTY100
             , SUM(CASE WHEN IA.RN = 101 THEN A.QTY ELSE 0 END) AS QTY101
             , SUM(CASE WHEN IA.RN = 102 THEN A.QTY ELSE 0 END) AS QTY102
             , SUM(CASE WHEN IA.RN = 103 THEN A.QTY ELSE 0 END) AS QTY103
             , SUM(CASE WHEN IA.RN = 104 THEN A.QTY ELSE 0 END) AS QTY104
             , SUM(CASE WHEN IA.RN = 105 THEN A.QTY ELSE 0 END) AS QTY105
             , SUM(CASE WHEN IA.RN = 106 THEN A.QTY ELSE 0 END) AS QTY106
             , SUM(CASE WHEN IA.RN = 107 THEN A.QTY ELSE 0 END) AS QTY107
             , SUM(CASE WHEN IA.RN = 108 THEN A.QTY ELSE 0 END) AS QTY108
             , SUM(CASE WHEN IA.RN = 109 THEN A.QTY ELSE 0 END) AS QTY109
             , SUM(CASE WHEN IA.RN = 110 THEN A.QTY ELSE 0 END) AS QTY110
             , SUM(CASE WHEN IA.RN = 111 THEN A.QTY ELSE 0 END) AS QTY111
             , SUM(CASE WHEN IA.RN = 112 THEN A.QTY ELSE 0 END) AS QTY112
             , SUM(CASE WHEN IA.RN = 113 THEN A.QTY ELSE 0 END) AS QTY113
             , SUM(CASE WHEN IA.RN = 114 THEN A.QTY ELSE 0 END) AS QTY114
             , SUM(CASE WHEN IA.RN = 115 THEN A.QTY ELSE 0 END) AS QTY115
             , SUM(CASE WHEN IA.RN = 116 THEN A.QTY ELSE 0 END) AS QTY116
             , SUM(CASE WHEN IA.RN = 117 THEN A.QTY ELSE 0 END) AS QTY117
             , SUM(CASE WHEN IA.RN = 118 THEN A.QTY ELSE 0 END) AS QTY118
             , SUM(CASE WHEN IA.RN = 119 THEN A.QTY ELSE 0 END) AS QTY119
             , SUM(CASE WHEN IA.RN = 120 THEN A.QTY ELSE 0 END) AS QTY120
             , SUM(CASE WHEN IA.RN = 121 THEN A.QTY ELSE 0 END) AS QTY121
             , SUM(CASE WHEN IA.RN = 122 THEN A.QTY ELSE 0 END) AS QTY122
             , SUM(CASE WHEN IA.RN = 123 THEN A.QTY ELSE 0 END) AS QTY123
             , SUM(CASE WHEN IA.RN = 124 THEN A.QTY ELSE 0 END) AS QTY124
             , SUM(CASE WHEN IA.RN = 125 THEN A.QTY ELSE 0 END) AS QTY125
             , SUM(CASE WHEN IA.RN = 126 THEN A.QTY ELSE 0 END) AS QTY126
             , SUM(CASE WHEN IA.RN = 127 THEN A.QTY ELSE 0 END) AS QTY127
             , SUM(CASE WHEN IA.RN = 128 THEN A.QTY ELSE 0 END) AS QTY128
             , SUM(CASE WHEN IA.RN = 129 THEN A.QTY ELSE 0 END) AS QTY129
             , SUM(CASE WHEN IA.RN = 130 THEN A.QTY ELSE 0 END) AS QTY130
             , SUM(CASE WHEN IA.RN = 131 THEN A.QTY ELSE 0 END) AS QTY131
             , SUM(CASE WHEN IA.RN = 132 THEN A.QTY ELSE 0 END) AS QTY132
             , SUM(CASE WHEN IA.RN = 133 THEN A.QTY ELSE 0 END) AS QTY133
             , SUM(CASE WHEN IA.RN = 134 THEN A.QTY ELSE 0 END) AS QTY134
             , SUM(CASE WHEN IA.RN = 135 THEN A.QTY ELSE 0 END) AS QTY135
             , SUM(CASE WHEN IA.RN = 136 THEN A.QTY ELSE 0 END) AS QTY136
             , SUM(CASE WHEN IA.RN = 137 THEN A.QTY ELSE 0 END) AS QTY137
             , SUM(CASE WHEN IA.RN = 138 THEN A.QTY ELSE 0 END) AS QTY138
             , SUM(CASE WHEN IA.RN = 139 THEN A.QTY ELSE 0 END) AS QTY139
             , SUM(CASE WHEN IA.RN = 140 THEN A.QTY ELSE 0 END) AS QTY140
             , SUM(CASE WHEN IA.RN = 141 THEN A.QTY ELSE 0 END) AS QTY141
             , SUM(CASE WHEN IA.RN = 142 THEN A.QTY ELSE 0 END) AS QTY142
             , SUM(CASE WHEN IA.RN = 143 THEN A.QTY ELSE 0 END) AS QTY143
             , SUM(CASE WHEN IA.RN = 144 THEN A.QTY ELSE 0 END) AS QTY144
             , SUM(CASE WHEN IA.RN = 145 THEN A.QTY ELSE 0 END) AS QTY145
             , SUM(CASE WHEN IA.RN = 146 THEN A.QTY ELSE 0 END) AS QTY146
             , SUM(CASE WHEN IA.RN = 147 THEN A.QTY ELSE 0 END) AS QTY147
             , SUM(CASE WHEN IA.RN = 148 THEN A.QTY ELSE 0 END) AS QTY148
             , SUM(CASE WHEN IA.RN = 149 THEN A.QTY ELSE 0 END) AS QTY149
             , SUM(CASE WHEN IA.RN = 150 THEN A.QTY ELSE 0 END) AS QTY150
             , SUM(CASE WHEN IA.RN = 151 THEN A.QTY ELSE 0 END) AS QTY151
             , SUM(CASE WHEN IA.RN = 152 THEN A.QTY ELSE 0 END) AS QTY152
             , SUM(CASE WHEN IA.RN = 153 THEN A.QTY ELSE 0 END) AS QTY153
             , SUM(CASE WHEN IA.RN = 154 THEN A.QTY ELSE 0 END) AS QTY154
             , SUM(CASE WHEN IA.RN = 155 THEN A.QTY ELSE 0 END) AS QTY155
             , SUM(CASE WHEN IA.RN = 156 THEN A.QTY ELSE 0 END) AS QTY156
             , SUM(CASE WHEN IA.RN = 157 THEN A.QTY ELSE 0 END) AS QTY157
             , SUM(CASE WHEN IA.RN = 158 THEN A.QTY ELSE 0 END) AS QTY158
             , SUM(CASE WHEN IA.RN = 159 THEN A.QTY ELSE 0 END) AS QTY159
             , SUM(CASE WHEN IA.RN = 160 THEN A.QTY ELSE 0 END) AS QTY160
             , SUM(CASE WHEN IA.RN = 161 THEN A.QTY ELSE 0 END) AS QTY161
             , SUM(CASE WHEN IA.RN = 162 THEN A.QTY ELSE 0 END) AS QTY162
             , SUM(CASE WHEN IA.RN = 163 THEN A.QTY ELSE 0 END) AS QTY163
             , SUM(CASE WHEN IA.RN = 164 THEN A.QTY ELSE 0 END) AS QTY164
             , SUM(CASE WHEN IA.RN = 165 THEN A.QTY ELSE 0 END) AS QTY165
             , SUM(CASE WHEN IA.RN = 166 THEN A.QTY ELSE 0 END) AS QTY166
             , SUM(CASE WHEN IA.RN = 167 THEN A.QTY ELSE 0 END) AS QTY167
             , SUM(CASE WHEN IA.RN = 168 THEN A.QTY ELSE 0 END) AS QTY168
             , SUM(CASE WHEN IA.RN = 169 THEN A.QTY ELSE 0 END) AS QTY169
             , SUM(CASE WHEN IA.RN = 170 THEN A.QTY ELSE 0 END) AS QTY170
             , SUM(CASE WHEN IA.RN = 171 THEN A.QTY ELSE 0 END) AS QTY171
             , SUM(CASE WHEN IA.RN = 172 THEN A.QTY ELSE 0 END) AS QTY172
             , SUM(CASE WHEN IA.RN = 173 THEN A.QTY ELSE 0 END) AS QTY173
             , SUM(CASE WHEN IA.RN = 174 THEN A.QTY ELSE 0 END) AS QTY174
             , SUM(CASE WHEN IA.RN = 175 THEN A.QTY ELSE 0 END) AS QTY175
             , SUM(CASE WHEN IA.RN = 176 THEN A.QTY ELSE 0 END) AS QTY176
             , SUM(CASE WHEN IA.RN = 177 THEN A.QTY ELSE 0 END) AS QTY177
             , SUM(CASE WHEN IA.RN = 178 THEN A.QTY ELSE 0 END) AS QTY178
             , SUM(CASE WHEN IA.RN = 179 THEN A.QTY ELSE 0 END) AS QTY179
             , SUM(CASE WHEN IA.RN = 180 THEN A.QTY ELSE 0 END) AS QTY180
             , SUM(CASE WHEN IA.RN = 181 THEN A.QTY ELSE 0 END) AS QTY181
             , SUM(CASE WHEN IA.RN = 182 THEN A.QTY ELSE 0 END) AS QTY182
             , SUM(CASE WHEN IA.RN = 183 THEN A.QTY ELSE 0 END) AS QTY183
             , SUM(CASE WHEN IA.RN = 184 THEN A.QTY ELSE 0 END) AS QTY184
             , SUM(CASE WHEN IA.RN = 185 THEN A.QTY ELSE 0 END) AS QTY185
             , SUM(CASE WHEN IA.RN = 186 THEN A.QTY ELSE 0 END) AS QTY186
             , SUM(CASE WHEN IA.RN = 187 THEN A.QTY ELSE 0 END) AS QTY187
             , SUM(CASE WHEN IA.RN = 188 THEN A.QTY ELSE 0 END) AS QTY188
             , SUM(CASE WHEN IA.RN = 189 THEN A.QTY ELSE 0 END) AS QTY189
             , SUM(CASE WHEN IA.RN = 190 THEN A.QTY ELSE 0 END) AS QTY190
             , SUM(CASE WHEN IA.RN = 191 THEN A.QTY ELSE 0 END) AS QTY191
             , SUM(CASE WHEN IA.RN = 192 THEN A.QTY ELSE 0 END) AS QTY192
             , SUM(CASE WHEN IA.RN = 193 THEN A.QTY ELSE 0 END) AS QTY193
             , SUM(CASE WHEN IA.RN = 194 THEN A.QTY ELSE 0 END) AS QTY194
             , SUM(CASE WHEN IA.RN = 195 THEN A.QTY ELSE 0 END) AS QTY195
             , SUM(CASE WHEN IA.RN = 196 THEN A.QTY ELSE 0 END) AS QTY196
             , SUM(CASE WHEN IA.RN = 197 THEN A.QTY ELSE 0 END) AS QTY197
             , SUM(CASE WHEN IA.RN = 198 THEN A.QTY ELSE 0 END) AS QTY198
             , SUM(CASE WHEN IA.RN = 199 THEN A.QTY ELSE 0 END) AS QTY199
             , SUM(CASE WHEN IA.RN = 200 THEN A.QTY ELSE 0 END) AS QTY200
             , SUM(CASE WHEN IA.RN = 201 THEN A.QTY ELSE 0 END) AS QTY201
             , SUM(CASE WHEN IA.RN = 202 THEN A.QTY ELSE 0 END) AS QTY202
             , SUM(CASE WHEN IA.RN = 203 THEN A.QTY ELSE 0 END) AS QTY203
             , SUM(CASE WHEN IA.RN = 204 THEN A.QTY ELSE 0 END) AS QTY204
             , SUM(CASE WHEN IA.RN = 205 THEN A.QTY ELSE 0 END) AS QTY205
             , SUM(CASE WHEN IA.RN = 206 THEN A.QTY ELSE 0 END) AS QTY206
             , SUM(CASE WHEN IA.RN = 207 THEN A.QTY ELSE 0 END) AS QTY207
             , SUM(CASE WHEN IA.RN = 208 THEN A.QTY ELSE 0 END) AS QTY208
             , SUM(CASE WHEN IA.RN = 209 THEN A.QTY ELSE 0 END) AS QTY209
             , SUM(CASE WHEN IA.RN = 210 THEN A.QTY ELSE 0 END) AS QTY210
             , SUM(CASE WHEN IA.RN = 211 THEN A.QTY ELSE 0 END) AS QTY211
             , SUM(CASE WHEN IA.RN = 212 THEN A.QTY ELSE 0 END) AS QTY212
             , SUM(CASE WHEN IA.RN = 213 THEN A.QTY ELSE 0 END) AS QTY213
             , SUM(CASE WHEN IA.RN = 214 THEN A.QTY ELSE 0 END) AS QTY214
             , SUM(CASE WHEN IA.RN = 215 THEN A.QTY ELSE 0 END) AS QTY215
             , SUM(CASE WHEN IA.RN = 216 THEN A.QTY ELSE 0 END) AS QTY216
             , SUM(CASE WHEN IA.RN = 217 THEN A.QTY ELSE 0 END) AS QTY217
             , SUM(CASE WHEN IA.RN = 218 THEN A.QTY ELSE 0 END) AS QTY218
             , SUM(CASE WHEN IA.RN = 219 THEN A.QTY ELSE 0 END) AS QTY219
             , SUM(CASE WHEN IA.RN = 220 THEN A.QTY ELSE 0 END) AS QTY220
             , SUM(CASE WHEN IA.RN = 221 THEN A.QTY ELSE 0 END) AS QTY221
             , SUM(CASE WHEN IA.RN = 222 THEN A.QTY ELSE 0 END) AS QTY222
             , SUM(CASE WHEN IA.RN = 223 THEN A.QTY ELSE 0 END) AS QTY223
             , SUM(CASE WHEN IA.RN = 224 THEN A.QTY ELSE 0 END) AS QTY224
             , SUM(CASE WHEN IA.RN = 225 THEN A.QTY ELSE 0 END) AS QTY225
             , SUM(CASE WHEN IA.RN = 226 THEN A.QTY ELSE 0 END) AS QTY226
             , SUM(CASE WHEN IA.RN = 227 THEN A.QTY ELSE 0 END) AS QTY227
             , SUM(CASE WHEN IA.RN = 228 THEN A.QTY ELSE 0 END) AS QTY228
             , SUM(CASE WHEN IA.RN = 229 THEN A.QTY ELSE 0 END) AS QTY229
             , SUM(CASE WHEN IA.RN = 230 THEN A.QTY ELSE 0 END) AS QTY230
             , SUM(CASE WHEN IA.RN = 231 THEN A.QTY ELSE 0 END) AS QTY231
             , SUM(CASE WHEN IA.RN = 232 THEN A.QTY ELSE 0 END) AS QTY232
             , SUM(CASE WHEN IA.RN = 233 THEN A.QTY ELSE 0 END) AS QTY233
             , SUM(CASE WHEN IA.RN = 234 THEN A.QTY ELSE 0 END) AS QTY234
             , SUM(CASE WHEN IA.RN = 235 THEN A.QTY ELSE 0 END) AS QTY235
             , SUM(CASE WHEN IA.RN = 236 THEN A.QTY ELSE 0 END) AS QTY236
             , SUM(CASE WHEN IA.RN = 237 THEN A.QTY ELSE 0 END) AS QTY237
             , SUM(CASE WHEN IA.RN = 238 THEN A.QTY ELSE 0 END) AS QTY238
             , SUM(CASE WHEN IA.RN = 239 THEN A.QTY ELSE 0 END) AS QTY239
             , SUM(CASE WHEN IA.RN = 240 THEN A.QTY ELSE 0 END) AS QTY240
             , SUM(CASE WHEN IA.RN = 241 THEN A.QTY ELSE 0 END) AS QTY241
             , SUM(CASE WHEN IA.RN = 242 THEN A.QTY ELSE 0 END) AS QTY242
             , SUM(CASE WHEN IA.RN = 243 THEN A.QTY ELSE 0 END) AS QTY243
             , SUM(CASE WHEN IA.RN = 244 THEN A.QTY ELSE 0 END) AS QTY244
             , SUM(CASE WHEN IA.RN = 245 THEN A.QTY ELSE 0 END) AS QTY245
             , SUM(CASE WHEN IA.RN = 246 THEN A.QTY ELSE 0 END) AS QTY246
             , SUM(CASE WHEN IA.RN = 247 THEN A.QTY ELSE 0 END) AS QTY247
             , SUM(CASE WHEN IA.RN = 248 THEN A.QTY ELSE 0 END) AS QTY248
             , SUM(CASE WHEN IA.RN = 249 THEN A.QTY ELSE 0 END) AS QTY249
             , SUM(CASE WHEN IA.RN = 250 THEN A.QTY ELSE 0 END) AS QTY250
             , SUM(CASE WHEN IA.RN = 251 THEN A.QTY ELSE 0 END) AS QTY251
             , SUM(CASE WHEN IA.RN = 252 THEN A.QTY ELSE 0 END) AS QTY252
             , SUM(CASE WHEN IA.RN = 253 THEN A.QTY ELSE 0 END) AS QTY253
             , SUM(CASE WHEN IA.RN = 254 THEN A.QTY ELSE 0 END) AS QTY254
             , SUM(CASE WHEN IA.RN = 255 THEN A.QTY ELSE 0 END) AS QTY255
             , SUM(CASE WHEN IA.RN = 256 THEN A.QTY ELSE 0 END) AS QTY256
             , SUM(CASE WHEN IA.RN = 257 THEN A.QTY ELSE 0 END) AS QTY257
             , SUM(CASE WHEN IA.RN = 258 THEN A.QTY ELSE 0 END) AS QTY258
             , SUM(CASE WHEN IA.RN = 259 THEN A.QTY ELSE 0 END) AS QTY259
             , SUM(CASE WHEN IA.RN = 260 THEN A.QTY ELSE 0 END) AS QTY260
             , SUM(CASE WHEN IA.RN = 261 THEN A.QTY ELSE 0 END) AS QTY261
             , SUM(CASE WHEN IA.RN = 262 THEN A.QTY ELSE 0 END) AS QTY262
             , SUM(CASE WHEN IA.RN = 263 THEN A.QTY ELSE 0 END) AS QTY263
             , SUM(CASE WHEN IA.RN = 264 THEN A.QTY ELSE 0 END) AS QTY264
             , SUM(CASE WHEN IA.RN = 265 THEN A.QTY ELSE 0 END) AS QTY265
             , SUM(CASE WHEN IA.RN = 266 THEN A.QTY ELSE 0 END) AS QTY266
             , SUM(CASE WHEN IA.RN = 267 THEN A.QTY ELSE 0 END) AS QTY267
             , SUM(CASE WHEN IA.RN = 268 THEN A.QTY ELSE 0 END) AS QTY268
             , SUM(CASE WHEN IA.RN = 269 THEN A.QTY ELSE 0 END) AS QTY269
             , SUM(CASE WHEN IA.RN = 270 THEN A.QTY ELSE 0 END) AS QTY270
             , SUM(CASE WHEN IA.RN = 271 THEN A.QTY ELSE 0 END) AS QTY271
             , SUM(CASE WHEN IA.RN = 272 THEN A.QTY ELSE 0 END) AS QTY272
             , SUM(CASE WHEN IA.RN = 273 THEN A.QTY ELSE 0 END) AS QTY273
             , SUM(CASE WHEN IA.RN = 274 THEN A.QTY ELSE 0 END) AS QTY274
             , SUM(CASE WHEN IA.RN = 275 THEN A.QTY ELSE 0 END) AS QTY275
             , SUM(CASE WHEN IA.RN = 276 THEN A.QTY ELSE 0 END) AS QTY276
             , SUM(CASE WHEN IA.RN = 277 THEN A.QTY ELSE 0 END) AS QTY277
             , SUM(CASE WHEN IA.RN = 278 THEN A.QTY ELSE 0 END) AS QTY278
             , SUM(CASE WHEN IA.RN = 279 THEN A.QTY ELSE 0 END) AS QTY279
             , SUM(CASE WHEN IA.RN = 280 THEN A.QTY ELSE 0 END) AS QTY280
             , SUM(CASE WHEN IA.RN = 281 THEN A.QTY ELSE 0 END) AS QTY281
             , SUM(CASE WHEN IA.RN = 282 THEN A.QTY ELSE 0 END) AS QTY282
             , SUM(CASE WHEN IA.RN = 283 THEN A.QTY ELSE 0 END) AS QTY283
             , SUM(CASE WHEN IA.RN = 284 THEN A.QTY ELSE 0 END) AS QTY284
             , SUM(CASE WHEN IA.RN = 285 THEN A.QTY ELSE 0 END) AS QTY285
             , SUM(CASE WHEN IA.RN = 286 THEN A.QTY ELSE 0 END) AS QTY286
             , SUM(CASE WHEN IA.RN = 287 THEN A.QTY ELSE 0 END) AS QTY287
             , SUM(CASE WHEN IA.RN = 288 THEN A.QTY ELSE 0 END) AS QTY288
             , SUM(CASE WHEN IA.RN = 289 THEN A.QTY ELSE 0 END) AS QTY289
             , SUM(CASE WHEN IA.RN = 290 THEN A.QTY ELSE 0 END) AS QTY290
             , SUM(CASE WHEN IA.RN = 291 THEN A.QTY ELSE 0 END) AS QTY291
             , SUM(CASE WHEN IA.RN = 292 THEN A.QTY ELSE 0 END) AS QTY292
             , SUM(CASE WHEN IA.RN = 293 THEN A.QTY ELSE 0 END) AS QTY293
             , SUM(CASE WHEN IA.RN = 294 THEN A.QTY ELSE 0 END) AS QTY294
             , SUM(CASE WHEN IA.RN = 295 THEN A.QTY ELSE 0 END) AS QTY295
             , SUM(CASE WHEN IA.RN = 296 THEN A.QTY ELSE 0 END) AS QTY296
             , SUM(CASE WHEN IA.RN = 297 THEN A.QTY ELSE 0 END) AS QTY297
             , SUM(CASE WHEN IA.RN = 298 THEN A.QTY ELSE 0 END) AS QTY298
             , SUM(CASE WHEN IA.RN = 299 THEN A.QTY ELSE 0 END) AS QTY299
             , SUM(CASE WHEN IA.RN = 300 THEN A.QTY ELSE 0 END) AS QTY300
             , SUM(CASE WHEN IA.RN = 301 THEN A.QTY ELSE 0 END) AS QTY301
             , SUM(CASE WHEN IA.RN = 302 THEN A.QTY ELSE 0 END) AS QTY302
             , SUM(CASE WHEN IA.RN = 303 THEN A.QTY ELSE 0 END) AS QTY303
             , SUM(CASE WHEN IA.RN = 304 THEN A.QTY ELSE 0 END) AS QTY304
             , SUM(CASE WHEN IA.RN = 305 THEN A.QTY ELSE 0 END) AS QTY305
             , SUM(CASE WHEN IA.RN = 306 THEN A.QTY ELSE 0 END) AS QTY306
             , SUM(CASE WHEN IA.RN = 307 THEN A.QTY ELSE 0 END) AS QTY307
             , SUM(CASE WHEN IA.RN = 308 THEN A.QTY ELSE 0 END) AS QTY308
             , SUM(CASE WHEN IA.RN = 309 THEN A.QTY ELSE 0 END) AS QTY309
             , SUM(CASE WHEN IA.RN = 310 THEN A.QTY ELSE 0 END) AS QTY310
             , SUM(CASE WHEN IA.RN = 311 THEN A.QTY ELSE 0 END) AS QTY311
             , SUM(CASE WHEN IA.RN = 312 THEN A.QTY ELSE 0 END) AS QTY312
             , SUM(CASE WHEN IA.RN = 313 THEN A.QTY ELSE 0 END) AS QTY313
             , SUM(CASE WHEN IA.RN = 314 THEN A.QTY ELSE 0 END) AS QTY314
             , SUM(CASE WHEN IA.RN = 315 THEN A.QTY ELSE 0 END) AS QTY315
             , SUM(CASE WHEN IA.RN = 316 THEN A.QTY ELSE 0 END) AS QTY316
             , SUM(CASE WHEN IA.RN = 317 THEN A.QTY ELSE 0 END) AS QTY317
             , SUM(CASE WHEN IA.RN = 318 THEN A.QTY ELSE 0 END) AS QTY318
             , SUM(CASE WHEN IA.RN = 319 THEN A.QTY ELSE 0 END) AS QTY319
             , SUM(CASE WHEN IA.RN = 320 THEN A.QTY ELSE 0 END) AS QTY320
             , SUM(CASE WHEN IA.RN = 321 THEN A.QTY ELSE 0 END) AS QTY321
             , SUM(CASE WHEN IA.RN = 322 THEN A.QTY ELSE 0 END) AS QTY322
             , SUM(CASE WHEN IA.RN = 323 THEN A.QTY ELSE 0 END) AS QTY323
             , SUM(CASE WHEN IA.RN = 324 THEN A.QTY ELSE 0 END) AS QTY324
             , SUM(CASE WHEN IA.RN = 325 THEN A.QTY ELSE 0 END) AS QTY325
             , SUM(CASE WHEN IA.RN = 326 THEN A.QTY ELSE 0 END) AS QTY326
             , SUM(CASE WHEN IA.RN = 327 THEN A.QTY ELSE 0 END) AS QTY327
             , SUM(CASE WHEN IA.RN = 328 THEN A.QTY ELSE 0 END) AS QTY328
             , SUM(CASE WHEN IA.RN = 329 THEN A.QTY ELSE 0 END) AS QTY329
             , SUM(CASE WHEN IA.RN = 330 THEN A.QTY ELSE 0 END) AS QTY330
             , SUM(CASE WHEN IA.RN = 331 THEN A.QTY ELSE 0 END) AS QTY331
             , SUM(CASE WHEN IA.RN = 332 THEN A.QTY ELSE 0 END) AS QTY332
             , SUM(CASE WHEN IA.RN = 333 THEN A.QTY ELSE 0 END) AS QTY333
             , SUM(CASE WHEN IA.RN = 334 THEN A.QTY ELSE 0 END) AS QTY334
             , SUM(CASE WHEN IA.RN = 335 THEN A.QTY ELSE 0 END) AS QTY335
             , SUM(CASE WHEN IA.RN = 336 THEN A.QTY ELSE 0 END) AS QTY336
             , SUM(CASE WHEN IA.RN = 337 THEN A.QTY ELSE 0 END) AS QTY337
             , SUM(CASE WHEN IA.RN = 338 THEN A.QTY ELSE 0 END) AS QTY338
             , SUM(CASE WHEN IA.RN = 339 THEN A.QTY ELSE 0 END) AS QTY339
             , SUM(CASE WHEN IA.RN = 340 THEN A.QTY ELSE 0 END) AS QTY340
             , SUM(CASE WHEN IA.RN = 341 THEN A.QTY ELSE 0 END) AS QTY341
             , SUM(CASE WHEN IA.RN = 342 THEN A.QTY ELSE 0 END) AS QTY342
             , SUM(CASE WHEN IA.RN = 343 THEN A.QTY ELSE 0 END) AS QTY343
             , SUM(CASE WHEN IA.RN = 344 THEN A.QTY ELSE 0 END) AS QTY344
             , SUM(CASE WHEN IA.RN = 345 THEN A.QTY ELSE 0 END) AS QTY345
             , SUM(CASE WHEN IA.RN = 346 THEN A.QTY ELSE 0 END) AS QTY346
             , SUM(CASE WHEN IA.RN = 347 THEN A.QTY ELSE 0 END) AS QTY347
             , SUM(CASE WHEN IA.RN = 348 THEN A.QTY ELSE 0 END) AS QTY348
             , SUM(CASE WHEN IA.RN = 349 THEN A.QTY ELSE 0 END) AS QTY349
             , SUM(CASE WHEN IA.RN = 350 THEN A.QTY ELSE 0 END) AS QTY350
             , SUM(CASE WHEN IA.RN = 351 THEN A.QTY ELSE 0 END) AS QTY351
             , SUM(CASE WHEN IA.RN = 352 THEN A.QTY ELSE 0 END) AS QTY352
             , SUM(CASE WHEN IA.RN = 353 THEN A.QTY ELSE 0 END) AS QTY353
             , SUM(CASE WHEN IA.RN = 354 THEN A.QTY ELSE 0 END) AS QTY354
             , SUM(CASE WHEN IA.RN = 355 THEN A.QTY ELSE 0 END) AS QTY355
             , SUM(CASE WHEN IA.RN = 356 THEN A.QTY ELSE 0 END) AS QTY356
             , SUM(CASE WHEN IA.RN = 357 THEN A.QTY ELSE 0 END) AS QTY357
             , SUM(CASE WHEN IA.RN = 358 THEN A.QTY ELSE 0 END) AS QTY358
             , SUM(CASE WHEN IA.RN = 359 THEN A.QTY ELSE 0 END) AS QTY359
             , SUM(CASE WHEN IA.RN = 360 THEN A.QTY ELSE 0 END) AS QTY360
             , SUM(CASE WHEN IA.RN = 361 THEN A.QTY ELSE 0 END) AS QTY361
             , SUM(CASE WHEN IA.RN = 362 THEN A.QTY ELSE 0 END) AS QTY362
             , SUM(CASE WHEN IA.RN = 363 THEN A.QTY ELSE 0 END) AS QTY363
             , SUM(CASE WHEN IA.RN = 364 THEN A.QTY ELSE 0 END) AS QTY364
             , A.ATTRIBUTE1
             , NULL                                                          AS ATTRIBUTE2
             , NULL                                                          AS ATTRIBUTE3
             , NULL                                                          AS ATTRIBUTE4
             , NULL                                                          AS ATTRIBUTE5
             , NULL                                                          AS ATTRIBUTE6
             , NULL                                                          AS ATTRIBUTE7
             , NULL                                                          AS ATTRIBUTE8
             , A.ATTRIBUTE9
             , NULL                                                          AS ATTRIBUTE10
          FROM GT_XPGS_PSI_GLOBAL_SMALL_AUTO A
             , GT_XPGS_SCP_MST_BOD_V         B
             , (SELECT XA.BASIS_YYYYMMDD
                     , ROW_NUMBER() OVER(ORDER BY XA.BASIS_YYYYMMDD) AS RN
                  FROM (SELECT XB.BASIS_YYYYMMDD
                          FROM SCM_SYS_CALENDAR_M XB
                         WHERE XB.BASIS_YYYYMMDD >= V_CREATE_FROM_YYYYMMDD
                           AND XB.BASIS_YYYYMMDD <= V_CREATE_TO_YYYYMMDD
                         GROUP BY XB.BASIS_YYYYMMDD
                       ) XA
               )                             IA
         WHERE 0 = 0
           AND B.DIVISION_ID(+)    = A.DIVISION_ID
           AND B.BOD_ID(+)         = A.BOD_ID
           AND B.FROM_SITE(+)      = A.FROM_SITE
           AND B.TO_SITE(+)        = A.TO_SITE
           AND B.INCOTERMS(+)      = A.INCOTERMS
           AND IA.BASIS_YYYYMMDD(+) = A.YYYYMMDD
           /* AS-IS LEFT JOIN 조건의 A.YYYYMMDD >= / <= 는 아래 WHERE 조건과 같아 WHERE 로 일원화 */
           /* 튜닝 - start */
           /* --SET @mEXEC = @mEXEC + '	   WHERE A.YYYYMMDD    = ''' + @p_create_from_yyyymmdd  + ''''+CHAR(10);		-- 52 구간별 처리 */
           AND A.YYYYMMDD BETWEEN V_CREATE_FROM_YYYYMMDD AND V_CREATE_TO_YYYYMMDD  /* 52 구간별 처리 */
           /* --SET @mEXEC = @mEXEC + '	      OR A.QTY         <> 0 '+CHAR(10); */
           /* 튜닝 - end */
         GROUP BY A.DIVISION_ID
                , A.OPERATION_GROUP
                , A.CELL_ITEM_ID
                , A.ITEM_ID
                , A.TO_SITE
                , A.PROJECT_CODE
                , A.TO_BOH_QTY
                , A.FROM_BOH_QTY
                , A.INCOTERMS
                , A.FROM_SITE
                , NVL(A.TRANSPORT_MODE, '-')
                , NVL(A.PROD_LINE, '-')
                , A.BOD_ID
                , A.MEASURE
                , A.SORT_ORDER_NO
                , A.COLUMN_LABEL_NAME
                , (CASE WHEN A.BOD_ID = '-' THEN 0 ELSE B.LT_TOTAL_BY_WEEK END)
                , A.ATTRIBUTE1
                /* --, A.ATTRIBUTE2 */
                /* --, A.ATTRIBUTE3 */
                /* --, A.ATTRIBUTE4 */
                /* --, A.ATTRIBUTE5 */
                /* --, A.ATTRIBUTE6 */
                /* --, A.ATTRIBUTE7 */
                /* --, A.ATTRIBUTE8 */
                , A.ATTRIBUTE9
                /* --, A.ATTRIBUTE10 */
        ;

        /* IF @P_IS_DEBUG = 1 : 동적 SQL 문자열 PRINT(4000자 단위) → 정적 SQL 환원으로 대상 없음 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 003 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* TRANSPORT_MODE 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 'SHIP_PLAN'의 TRANSPORT_MODE 종류 별 추가 */

        /* IF OBJECT_ID('tempdb..#TRANSPORT_MODE') IS NOT NULL DROP TABLE #TRANSPORT_MODE; */
        DELETE FROM GT_XPGS_TRANSPORT_MODE;

        INSERT
          INTO GT_XPGS_TRANSPORT_MODE
             ( DIVISION_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , TRANSPORT_MODE
             , LT_TOTAL
             , BOD_ID
             , PROJECT_CODE
             , LT_TOTAL_BY_WEEK
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.FROM_SITE
             , X.TO_SITE
             , X.INCOTERMS
             , X.TRANSPORT_MODE
             , X.LT_TOTAL
             , X.BOD_ID
             , Y.PROJECT_CODE
             , X.LT_TOTAL_BY_WEEK
          FROM GT_XPGS_SCP_MST_BOD_V                 X
             , GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO Y
         WHERE Y.DIVISION_ID(+)  = X.DIVISION_ID
           AND Y.FROM_SITE(+)    = X.FROM_SITE
           AND Y.TO_SITE(+)      = X.TO_SITE
           AND Y.INCOTERMS(+)    = X.INCOTERMS
           AND Y.BOD_ID(+)       = X.BOD_ID  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
           AND Y.PROJECT_CODE(+) <> '-'
           /* --                WHERE ISNULL(Y.PROJECT_CODE ,'') <> '' */
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 004 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        INSERT
          INTO GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001
             , QTY002
             , QTY003
             , QTY004
             , QTY005
             , QTY006
             , QTY007
             , QTY008
             , QTY009
             , QTY010
             , QTY011
             , QTY012
             , QTY013
             , QTY014
             , QTY015
             , QTY016
             , QTY017
             , QTY018
             , QTY019
             , QTY020
             , QTY021
             , QTY022
             , QTY023
             , QTY024
             , QTY025
             , QTY026
             , QTY027
             , QTY028
             , QTY029
             , QTY030
             , QTY031
             , QTY032
             , QTY033
             , QTY034
             , QTY035
             , QTY036
             , QTY037
             , QTY038
             , QTY039
             , QTY040
             , QTY041
             , QTY042
             , QTY043
             , QTY044
             , QTY045
             , QTY046
             , QTY047
             , QTY048
             , QTY049
             , QTY050
             , QTY051
             , QTY052
             , QTY053
             , QTY054
             , QTY055
             , QTY056
             , QTY057
             , QTY058
             , QTY059
             , QTY060
             , QTY061
             , QTY062
             , QTY063
             , QTY064
             , QTY065
             , QTY066
             , QTY067
             , QTY068
             , QTY069
             , QTY070
             , QTY071
             , QTY072
             , QTY073
             , QTY074
             , QTY075
             , QTY076
             , QTY077
             , QTY078
             , QTY079
             , QTY080
             , QTY081
             , QTY082
             , QTY083
             , QTY084
             , QTY085
             , QTY086
             , QTY087
             , QTY088
             , QTY089
             , QTY090
             , QTY091
             , QTY092
             , QTY093
             , QTY094
             , QTY095
             , QTY096
             , QTY097
             , QTY098
             , QTY099
             , QTY100
             , QTY101
             , QTY102
             , QTY103
             , QTY104
             , QTY105
             , QTY106
             , QTY107
             , QTY108
             , QTY109
             , QTY110
             , QTY111
             , QTY112
             , QTY113
             , QTY114
             , QTY115
             , QTY116
             , QTY117
             , QTY118
             , QTY119
             , QTY120
             , QTY121
             , QTY122
             , QTY123
             , QTY124
             , QTY125
             , QTY126
             , QTY127
             , QTY128
             , QTY129
             , QTY130
             , QTY131
             , QTY132
             , QTY133
             , QTY134
             , QTY135
             , QTY136
             , QTY137
             , QTY138
             , QTY139
             , QTY140
             , QTY141
             , QTY142
             , QTY143
             , QTY144
             , QTY145
             , QTY146
             , QTY147
             , QTY148
             , QTY149
             , QTY150
             , QTY151
             , QTY152
             , QTY153
             , QTY154
             , QTY155
             , QTY156
             , QTY157
             , QTY158
             , QTY159
             , QTY160
             , QTY161
             , QTY162
             , QTY163
             , QTY164
             , QTY165
             , QTY166
             , QTY167
             , QTY168
             , QTY169
             , QTY170
             , QTY171
             , QTY172
             , QTY173
             , QTY174
             , QTY175
             , QTY176
             , QTY177
             , QTY178
             , QTY179
             , QTY180
             , QTY181
             , QTY182
             , QTY183
             , QTY184
             , QTY185
             , QTY186
             , QTY187
             , QTY188
             , QTY189
             , QTY190
             , QTY191
             , QTY192
             , QTY193
             , QTY194
             , QTY195
             , QTY196
             , QTY197
             , QTY198
             , QTY199
             , QTY200
             , QTY201
             , QTY202
             , QTY203
             , QTY204
             , QTY205
             , QTY206
             , QTY207
             , QTY208
             , QTY209
             , QTY210
             , QTY211
             , QTY212
             , QTY213
             , QTY214
             , QTY215
             , QTY216
             , QTY217
             , QTY218
             , QTY219
             , QTY220
             , QTY221
             , QTY222
             , QTY223
             , QTY224
             , QTY225
             , QTY226
             , QTY227
             , QTY228
             , QTY229
             , QTY230
             , QTY231
             , QTY232
             , QTY233
             , QTY234
             , QTY235
             , QTY236
             , QTY237
             , QTY238
             , QTY239
             , QTY240
             , QTY241
             , QTY242
             , QTY243
             , QTY244
             , QTY245
             , QTY246
             , QTY247
             , QTY248
             , QTY249
             , QTY250
             , QTY251
             , QTY252
             , QTY253
             , QTY254
             , QTY255
             , QTY256
             , QTY257
             , QTY258
             , QTY259
             , QTY260
             , QTY261
             , QTY262
             , QTY263
             , QTY264
             , QTY265
             , QTY266
             , QTY267
             , QTY268
             , QTY269
             , QTY270
             , QTY271
             , QTY272
             , QTY273
             , QTY274
             , QTY275
             , QTY276
             , QTY277
             , QTY278
             , QTY279
             , QTY280
             , QTY281
             , QTY282
             , QTY283
             , QTY284
             , QTY285
             , QTY286
             , QTY287
             , QTY288
             , QTY289
             , QTY290
             , QTY291
             , QTY292
             , QTY293
             , QTY294
             , QTY295
             , QTY296
             , QTY297
             , QTY298
             , QTY299
             , QTY300
             , QTY301
             , QTY302
             , QTY303
             , QTY304
             , QTY305
             , QTY306
             , QTY307
             , QTY308
             , QTY309
             , QTY310
             , QTY311
             , QTY312
             , QTY313
             , QTY314
             , QTY315
             , QTY316
             , QTY317
             , QTY318
             , QTY319
             , QTY320
             , QTY321
             , QTY322
             , QTY323
             , QTY324
             , QTY325
             , QTY326
             , QTY327
             , QTY328
             , QTY329
             , QTY330
             , QTY331
             , QTY332
             , QTY333
             , QTY334
             , QTY335
             , QTY336
             , QTY337
             , QTY338
             , QTY339
             , QTY340
             , QTY341
             , QTY342
             , QTY343
             , QTY344
             , QTY345
             , QTY346
             , QTY347
             , QTY348
             , QTY349
             , QTY350
             , QTY351
             , QTY352
             , QTY353
             , QTY354
             , QTY355
             , QTY356
             , QTY357
             , QTY358
             , QTY359
             , QTY360
             , QTY361
             , QTY362
             , QTY363
             , QTY364
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT SUB.DIVISION_ID
             , SUB.PLAN_START_YYYYMMDD
             , SUB.PLAN_TYPE
             , SUB.SEQ
             , SUB.OPERATION_GROUP
             , SUB.OPERATION_GROUP_NAME
             , SUB.CELL_ITEM_ID
             , SUB.ITEM_ID
             , SUB.NICK_NAME
             , SUB.CELL_QTY_PACK
             , SUB.TO_SITE
             , SUB.TO_SITE_DESCRIPTION
             , SUB.PROJECT_CODE
             , SUB.FROM_BOH_QTY
             , SUB.TO_BOH_QTY
             , SUB.INCOTERMS
             , SUB.FROM_SITE
             , SUB.FROM_SITE_DESCRIPTION
             , SUB.TRANSPORT_MODE
             , SUB.PROD_LINE
             , SUB.LT_DAY
             , SUB.BOD_ID
             , SUB.MEASURE
             , SUB.MEASURE_LABEL
             , SUB.XLS_KEY1
             , SUB.XLS_KEY2
             , SUB.XLS_KEY3
             , SUB.XLS_KEY4
             , SUB.XLS_KEY5
             , SUB.XLS_ATTRIBUTE1
             , SUB.XLS_ATTRIBUTE2
             , SUB.XLS_ATTRIBUTE3
             , SUB.XLS_ATTRIBUTE4
             , SUB.XLS_ATTRIBUTE5
             , SUB.SORT_ORDER_NO
             , 0                                      AS QTY001
             , 0                                      AS QTY002
             , 0                                      AS QTY003
             , 0                                      AS QTY004
             , 0                                      AS QTY005
             , 0                                      AS QTY006
             , 0                                      AS QTY007
             , 0                                      AS QTY008
             , 0                                      AS QTY009
             , 0                                      AS QTY010
             , 0                                      AS QTY011
             , 0                                      AS QTY012
             , 0                                      AS QTY013
             , 0                                      AS QTY014
             , 0                                      AS QTY015
             , 0                                      AS QTY016
             , 0                                      AS QTY017
             , 0                                      AS QTY018
             , 0                                      AS QTY019
             , 0                                      AS QTY020
             , 0                                      AS QTY021
             , 0                                      AS QTY022
             , 0                                      AS QTY023
             , 0                                      AS QTY024
             , 0                                      AS QTY025
             , 0                                      AS QTY026
             , 0                                      AS QTY027
             , 0                                      AS QTY028
             , 0                                      AS QTY029
             , 0                                      AS QTY030
             , 0                                      AS QTY031
             , 0                                      AS QTY032
             , 0                                      AS QTY033
             , 0                                      AS QTY034
             , 0                                      AS QTY035
             , 0                                      AS QTY036
             , 0                                      AS QTY037
             , 0                                      AS QTY038
             , 0                                      AS QTY039
             , 0                                      AS QTY040
             , 0                                      AS QTY041
             , 0                                      AS QTY042
             , 0                                      AS QTY043
             , 0                                      AS QTY044
             , 0                                      AS QTY045
             , 0                                      AS QTY046
             , 0                                      AS QTY047
             , 0                                      AS QTY048
             , 0                                      AS QTY049
             , 0                                      AS QTY050
             , 0                                      AS QTY051
             , 0                                      AS QTY052
             , 0                                      AS QTY053
             , 0                                      AS QTY054
             , 0                                      AS QTY055
             , 0                                      AS QTY056
             , 0                                      AS QTY057
             , 0                                      AS QTY058
             , 0                                      AS QTY059
             , 0                                      AS QTY060
             , 0                                      AS QTY061
             , 0                                      AS QTY062
             , 0                                      AS QTY063
             , 0                                      AS QTY064
             , 0                                      AS QTY065
             , 0                                      AS QTY066
             , 0                                      AS QTY067
             , 0                                      AS QTY068
             , 0                                      AS QTY069
             , 0                                      AS QTY070
             , 0                                      AS QTY071
             , 0                                      AS QTY072
             , 0                                      AS QTY073
             , 0                                      AS QTY074
             , 0                                      AS QTY075
             , 0                                      AS QTY076
             , 0                                      AS QTY077
             , 0                                      AS QTY078
             , 0                                      AS QTY079
             , 0                                      AS QTY080
             , 0                                      AS QTY081
             , 0                                      AS QTY082
             , 0                                      AS QTY083
             , 0                                      AS QTY084
             , 0                                      AS QTY085
             , 0                                      AS QTY086
             , 0                                      AS QTY087
             , 0                                      AS QTY088
             , 0                                      AS QTY089
             , 0                                      AS QTY090
             , 0                                      AS QTY091
             , 0                                      AS QTY092
             , 0                                      AS QTY093
             , 0                                      AS QTY094
             , 0                                      AS QTY095
             , 0                                      AS QTY096
             , 0                                      AS QTY097
             , 0                                      AS QTY098
             , 0                                      AS QTY099
             , 0                                      AS QTY100
             , 0                                      AS QTY101
             , 0                                      AS QTY102
             , 0                                      AS QTY103
             , 0                                      AS QTY104
             , 0                                      AS QTY105
             , 0                                      AS QTY106
             , 0                                      AS QTY107
             , 0                                      AS QTY108
             , 0                                      AS QTY109
             , 0                                      AS QTY110
             , 0                                      AS QTY111
             , 0                                      AS QTY112
             , 0                                      AS QTY113
             , 0                                      AS QTY114
             , 0                                      AS QTY115
             , 0                                      AS QTY116
             , 0                                      AS QTY117
             , 0                                      AS QTY118
             , 0                                      AS QTY119
             , 0                                      AS QTY120
             , 0                                      AS QTY121
             , 0                                      AS QTY122
             , 0                                      AS QTY123
             , 0                                      AS QTY124
             , 0                                      AS QTY125
             , 0                                      AS QTY126
             , 0                                      AS QTY127
             , 0                                      AS QTY128
             , 0                                      AS QTY129
             , 0                                      AS QTY130
             , 0                                      AS QTY131
             , 0                                      AS QTY132
             , 0                                      AS QTY133
             , 0                                      AS QTY134
             , 0                                      AS QTY135
             , 0                                      AS QTY136
             , 0                                      AS QTY137
             , 0                                      AS QTY138
             , 0                                      AS QTY139
             , 0                                      AS QTY140
             , 0                                      AS QTY141
             , 0                                      AS QTY142
             , 0                                      AS QTY143
             , 0                                      AS QTY144
             , 0                                      AS QTY145
             , 0                                      AS QTY146
             , 0                                      AS QTY147
             , 0                                      AS QTY148
             , 0                                      AS QTY149
             , 0                                      AS QTY150
             , 0                                      AS QTY151
             , 0                                      AS QTY152
             , 0                                      AS QTY153
             , 0                                      AS QTY154
             , 0                                      AS QTY155
             , 0                                      AS QTY156
             , 0                                      AS QTY157
             , 0                                      AS QTY158
             , 0                                      AS QTY159
             , 0                                      AS QTY160
             , 0                                      AS QTY161
             , 0                                      AS QTY162
             , 0                                      AS QTY163
             , 0                                      AS QTY164
             , 0                                      AS QTY165
             , 0                                      AS QTY166
             , 0                                      AS QTY167
             , 0                                      AS QTY168
             , 0                                      AS QTY169
             , 0                                      AS QTY170
             , 0                                      AS QTY171
             , 0                                      AS QTY172
             , 0                                      AS QTY173
             , 0                                      AS QTY174
             , 0                                      AS QTY175
             , 0                                      AS QTY176
             , 0                                      AS QTY177
             , 0                                      AS QTY178
             , 0                                      AS QTY179
             , 0                                      AS QTY180
             , 0                                      AS QTY181
             , 0                                      AS QTY182
             , 0                                      AS QTY183
             , 0                                      AS QTY184
             , 0                                      AS QTY185
             , 0                                      AS QTY186
             , 0                                      AS QTY187
             , 0                                      AS QTY188
             , 0                                      AS QTY189
             , 0                                      AS QTY190
             , 0                                      AS QTY191
             , 0                                      AS QTY192
             , 0                                      AS QTY193
             , 0                                      AS QTY194
             , 0                                      AS QTY195
             , 0                                      AS QTY196
             , 0                                      AS QTY197
             , 0                                      AS QTY198
             , 0                                      AS QTY199
             , 0                                      AS QTY200
             , 0                                      AS QTY201
             , 0                                      AS QTY202
             , 0                                      AS QTY203
             , 0                                      AS QTY204
             , 0                                      AS QTY205
             , 0                                      AS QTY206
             , 0                                      AS QTY207
             , 0                                      AS QTY208
             , 0                                      AS QTY209
             , 0                                      AS QTY210
             , 0                                      AS QTY211
             , 0                                      AS QTY212
             , 0                                      AS QTY213
             , 0                                      AS QTY214
             , 0                                      AS QTY215
             , 0                                      AS QTY216
             , 0                                      AS QTY217
             , 0                                      AS QTY218
             , 0                                      AS QTY219
             , 0                                      AS QTY220
             , 0                                      AS QTY221
             , 0                                      AS QTY222
             , 0                                      AS QTY223
             , 0                                      AS QTY224
             , 0                                      AS QTY225
             , 0                                      AS QTY226
             , 0                                      AS QTY227
             , 0                                      AS QTY228
             , 0                                      AS QTY229
             , 0                                      AS QTY230
             , 0                                      AS QTY231
             , 0                                      AS QTY232
             , 0                                      AS QTY233
             , 0                                      AS QTY234
             , 0                                      AS QTY235
             , 0                                      AS QTY236
             , 0                                      AS QTY237
             , 0                                      AS QTY238
             , 0                                      AS QTY239
             , 0                                      AS QTY240
             , 0                                      AS QTY241
             , 0                                      AS QTY242
             , 0                                      AS QTY243
             , 0                                      AS QTY244
             , 0                                      AS QTY245
             , 0                                      AS QTY246
             , 0                                      AS QTY247
             , 0                                      AS QTY248
             , 0                                      AS QTY249
             , 0                                      AS QTY250
             , 0                                      AS QTY251
             , 0                                      AS QTY252
             , 0                                      AS QTY253
             , 0                                      AS QTY254
             , 0                                      AS QTY255
             , 0                                      AS QTY256
             , 0                                      AS QTY257
             , 0                                      AS QTY258
             , 0                                      AS QTY259
             , 0                                      AS QTY260
             , 0                                      AS QTY261
             , 0                                      AS QTY262
             , 0                                      AS QTY263
             , 0                                      AS QTY264
             , 0                                      AS QTY265
             , 0                                      AS QTY266
             , 0                                      AS QTY267
             , 0                                      AS QTY268
             , 0                                      AS QTY269
             , 0                                      AS QTY270
             , 0                                      AS QTY271
             , 0                                      AS QTY272
             , 0                                      AS QTY273
             , 0                                      AS QTY274
             , 0                                      AS QTY275
             , 0                                      AS QTY276
             , 0                                      AS QTY277
             , 0                                      AS QTY278
             , 0                                      AS QTY279
             , 0                                      AS QTY280
             , 0                                      AS QTY281
             , 0                                      AS QTY282
             , 0                                      AS QTY283
             , 0                                      AS QTY284
             , 0                                      AS QTY285
             , 0                                      AS QTY286
             , 0                                      AS QTY287
             , 0                                      AS QTY288
             , 0                                      AS QTY289
             , 0                                      AS QTY290
             , 0                                      AS QTY291
             , 0                                      AS QTY292
             , 0                                      AS QTY293
             , 0                                      AS QTY294
             , 0                                      AS QTY295
             , 0                                      AS QTY296
             , 0                                      AS QTY297
             , 0                                      AS QTY298
             , 0                                      AS QTY299
             , 0                                      AS QTY300
             , 0                                      AS QTY301
             , 0                                      AS QTY302
             , 0                                      AS QTY303
             , 0                                      AS QTY304
             , 0                                      AS QTY305
             , 0                                      AS QTY306
             , 0                                      AS QTY307
             , 0                                      AS QTY308
             , 0                                      AS QTY309
             , 0                                      AS QTY310
             , 0                                      AS QTY311
             , 0                                      AS QTY312
             , 0                                      AS QTY313
             , 0                                      AS QTY314
             , 0                                      AS QTY315
             , 0                                      AS QTY316
             , 0                                      AS QTY317
             , 0                                      AS QTY318
             , 0                                      AS QTY319
             , 0                                      AS QTY320
             , 0                                      AS QTY321
             , 0                                      AS QTY322
             , 0                                      AS QTY323
             , 0                                      AS QTY324
             , 0                                      AS QTY325
             , 0                                      AS QTY326
             , 0                                      AS QTY327
             , 0                                      AS QTY328
             , 0                                      AS QTY329
             , 0                                      AS QTY330
             , 0                                      AS QTY331
             , 0                                      AS QTY332
             , 0                                      AS QTY333
             , 0                                      AS QTY334
             , 0                                      AS QTY335
             , 0                                      AS QTY336
             , 0                                      AS QTY337
             , 0                                      AS QTY338
             , 0                                      AS QTY339
             , 0                                      AS QTY340
             , 0                                      AS QTY341
             , 0                                      AS QTY342
             , 0                                      AS QTY343
             , 0                                      AS QTY344
             , 0                                      AS QTY345
             , 0                                      AS QTY346
             , 0                                      AS QTY347
             , 0                                      AS QTY348
             , 0                                      AS QTY349
             , 0                                      AS QTY350
             , 0                                      AS QTY351
             , 0                                      AS QTY352
             , 0                                      AS QTY353
             , 0                                      AS QTY354
             , 0                                      AS QTY355
             , 0                                      AS QTY356
             , 0                                      AS QTY357
             , 0                                      AS QTY358
             , 0                                      AS QTY359
             , 0                                      AS QTY360
             , 0                                      AS QTY361
             , 0                                      AS QTY362
             , 0                                      AS QTY363
             , 0                                      AS QTY364
               /* --,X.CREATED_BY */
               /* --,X.CREATION_DATE */
               /* --,X.LAST_UPDATED_BY */
               /* --,X.LAST_UPDATE_DATE */
             , SUB.ATTRIBUTE1
             , SUB.ATTRIBUTE2
             , SUB.ATTRIBUTE3
             , SUB.ATTRIBUTE4
             , SUB.ATTRIBUTE5
             , SUB.ATTRIBUTE6
             , SUB.ATTRIBUTE7
             , SUB.ATTRIBUTE8
             , SUB.ATTRIBUTE9
             , SUB.ATTRIBUTE10
          FROM (SELECT DISTINCT
                       X.DIVISION_ID
                     , X.PLAN_START_YYYYMMDD
                     , X.PLAN_TYPE
                     , X.SEQ
                     , X.OPERATION_GROUP
                     , X.OPERATION_GROUP_NAME
                     , X.CELL_ITEM_ID
                     , X.ITEM_ID
                     , X.NICK_NAME
                     , X.CELL_QTY_PACK
                     , X.TO_SITE
                     , X.TO_SITE_DESCRIPTION
                     , X.PROJECT_CODE
                     , X.FROM_BOH_QTY
                     , X.TO_BOH_QTY
                     , X.INCOTERMS
                     , X.FROM_SITE
                     , X.FROM_SITE_DESCRIPTION
                     , Y.TRANSPORT_MODE
                     , X.PROD_LINE
                     , Y.LT_TOTAL_BY_WEEK                AS LT_DAY
                     , Y.BOD_ID
                     , X.MEASURE
                     , X.MEASURE_LABEL
                     , X.XLS_KEY1
                     , X.XLS_KEY2
                     , X.XLS_KEY3
                     , X.XLS_KEY4
                     , X.XLS_KEY5
                     , X.XLS_ATTRIBUTE1
                     , X.XLS_ATTRIBUTE2
                     , X.XLS_ATTRIBUTE3
                     , X.XLS_ATTRIBUTE4
                     , X.XLS_ATTRIBUTE5
                     , X.SORT_ORDER_NO
                       /* --,X.CREATED_BY */
                       /* --,X.CREATION_DATE */
                       /* --,X.LAST_UPDATED_BY */
                       /* --,X.LAST_UPDATE_DATE */
                     , X.ATTRIBUTE1
                     , X.ATTRIBUTE2
                     , X.ATTRIBUTE3
                     , X.ATTRIBUTE4
                     , X.ATTRIBUTE5
                     , X.ATTRIBUTE6
                     , X.ATTRIBUTE7
                     , X.ATTRIBUTE8
                     , X.ATTRIBUTE9
                     , X.ATTRIBUTE10
                  FROM GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO X
                     , GT_XPGS_TRANSPORT_MODE                Y
                 WHERE 0 = 0
                   AND Y.DIVISION_ID(+)  = X.DIVISION_ID
                   AND Y.FROM_SITE(+)    = X.FROM_SITE
                   AND Y.TO_SITE(+)      = X.TO_SITE
                   AND Y.INCOTERMS(+)    = X.INCOTERMS
                   AND Y.PROJECT_CODE(+) = X.PROJECT_CODE
                   AND Y.BOD_ID(+)       = X.BOD_ID  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
                   /* AS-IS LEFT JOIN 조건 X.MEASURE = 'SHIP_PLAN' : 바깥 조건 SUB.MEASURE = 'SHIP_PLAN' 으로 다른 측정값 행은 어차피 제외되어 WHERE 로 이동 */
                   AND X.MEASURE         = 'SHIP_PLAN'
                   /* --                                AND X.TRANSPORT_MODE  <> Y.TRANSPORT_MODE */
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS (SELECT 1
                             FROM GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO Z
                            WHERE 1 = 1
                              AND Z.DIVISION_ID          = SUB.DIVISION_ID
                              AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP
                              /* AS-IS '' = '' 비교가 참이던 칸은 NULL 끼리도 같은 값으로 비교 */
                              AND (Z.CELL_ITEM_ID = SUB.CELL_ITEM_ID OR (Z.CELL_ITEM_ID IS NULL AND SUB.CELL_ITEM_ID IS NULL))
                              AND Z.ITEM_ID              = SUB.ITEM_ID
                              AND Z.PROJECT_CODE         = SUB.PROJECT_CODE
                              AND Z.TO_SITE              = SUB.TO_SITE
                              AND Z.INCOTERMS            = SUB.INCOTERMS
                              AND Z.FROM_SITE            = SUB.FROM_SITE
                              AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE
                              AND Z.MEASURE              = SUB.MEASURE
                              AND Z.MEASURE              = 'SHIP_PLAN'
                              AND Z.BOD_ID               = SUB.BOD_ID
                              AND (Z.ATTRIBUTE1 = SUB.ATTRIBUTE1 OR (Z.ATTRIBUTE1 IS NULL AND SUB.ATTRIBUTE1 IS NULL))
                              /* --			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9 */
                          )
           AND SUB.MEASURE         = 'SHIP_PLAN'
           AND SUB.TRANSPORT_MODE IS NOT NULL
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 005 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        INSERT
          INTO GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001
             , QTY002
             , QTY003
             , QTY004
             , QTY005
             , QTY006
             , QTY007
             , QTY008
             , QTY009
             , QTY010
             , QTY011
             , QTY012
             , QTY013
             , QTY014
             , QTY015
             , QTY016
             , QTY017
             , QTY018
             , QTY019
             , QTY020
             , QTY021
             , QTY022
             , QTY023
             , QTY024
             , QTY025
             , QTY026
             , QTY027
             , QTY028
             , QTY029
             , QTY030
             , QTY031
             , QTY032
             , QTY033
             , QTY034
             , QTY035
             , QTY036
             , QTY037
             , QTY038
             , QTY039
             , QTY040
             , QTY041
             , QTY042
             , QTY043
             , QTY044
             , QTY045
             , QTY046
             , QTY047
             , QTY048
             , QTY049
             , QTY050
             , QTY051
             , QTY052
             , QTY053
             , QTY054
             , QTY055
             , QTY056
             , QTY057
             , QTY058
             , QTY059
             , QTY060
             , QTY061
             , QTY062
             , QTY063
             , QTY064
             , QTY065
             , QTY066
             , QTY067
             , QTY068
             , QTY069
             , QTY070
             , QTY071
             , QTY072
             , QTY073
             , QTY074
             , QTY075
             , QTY076
             , QTY077
             , QTY078
             , QTY079
             , QTY080
             , QTY081
             , QTY082
             , QTY083
             , QTY084
             , QTY085
             , QTY086
             , QTY087
             , QTY088
             , QTY089
             , QTY090
             , QTY091
             , QTY092
             , QTY093
             , QTY094
             , QTY095
             , QTY096
             , QTY097
             , QTY098
             , QTY099
             , QTY100
             , QTY101
             , QTY102
             , QTY103
             , QTY104
             , QTY105
             , QTY106
             , QTY107
             , QTY108
             , QTY109
             , QTY110
             , QTY111
             , QTY112
             , QTY113
             , QTY114
             , QTY115
             , QTY116
             , QTY117
             , QTY118
             , QTY119
             , QTY120
             , QTY121
             , QTY122
             , QTY123
             , QTY124
             , QTY125
             , QTY126
             , QTY127
             , QTY128
             , QTY129
             , QTY130
             , QTY131
             , QTY132
             , QTY133
             , QTY134
             , QTY135
             , QTY136
             , QTY137
             , QTY138
             , QTY139
             , QTY140
             , QTY141
             , QTY142
             , QTY143
             , QTY144
             , QTY145
             , QTY146
             , QTY147
             , QTY148
             , QTY149
             , QTY150
             , QTY151
             , QTY152
             , QTY153
             , QTY154
             , QTY155
             , QTY156
             , QTY157
             , QTY158
             , QTY159
             , QTY160
             , QTY161
             , QTY162
             , QTY163
             , QTY164
             , QTY165
             , QTY166
             , QTY167
             , QTY168
             , QTY169
             , QTY170
             , QTY171
             , QTY172
             , QTY173
             , QTY174
             , QTY175
             , QTY176
             , QTY177
             , QTY178
             , QTY179
             , QTY180
             , QTY181
             , QTY182
             , QTY183
             , QTY184
             , QTY185
             , QTY186
             , QTY187
             , QTY188
             , QTY189
             , QTY190
             , QTY191
             , QTY192
             , QTY193
             , QTY194
             , QTY195
             , QTY196
             , QTY197
             , QTY198
             , QTY199
             , QTY200
             , QTY201
             , QTY202
             , QTY203
             , QTY204
             , QTY205
             , QTY206
             , QTY207
             , QTY208
             , QTY209
             , QTY210
             , QTY211
             , QTY212
             , QTY213
             , QTY214
             , QTY215
             , QTY216
             , QTY217
             , QTY218
             , QTY219
             , QTY220
             , QTY221
             , QTY222
             , QTY223
             , QTY224
             , QTY225
             , QTY226
             , QTY227
             , QTY228
             , QTY229
             , QTY230
             , QTY231
             , QTY232
             , QTY233
             , QTY234
             , QTY235
             , QTY236
             , QTY237
             , QTY238
             , QTY239
             , QTY240
             , QTY241
             , QTY242
             , QTY243
             , QTY244
             , QTY245
             , QTY246
             , QTY247
             , QTY248
             , QTY249
             , QTY250
             , QTY251
             , QTY252
             , QTY253
             , QTY254
             , QTY255
             , QTY256
             , QTY257
             , QTY258
             , QTY259
             , QTY260
             , QTY261
             , QTY262
             , QTY263
             , QTY264
             , QTY265
             , QTY266
             , QTY267
             , QTY268
             , QTY269
             , QTY270
             , QTY271
             , QTY272
             , QTY273
             , QTY274
             , QTY275
             , QTY276
             , QTY277
             , QTY278
             , QTY279
             , QTY280
             , QTY281
             , QTY282
             , QTY283
             , QTY284
             , QTY285
             , QTY286
             , QTY287
             , QTY288
             , QTY289
             , QTY290
             , QTY291
             , QTY292
             , QTY293
             , QTY294
             , QTY295
             , QTY296
             , QTY297
             , QTY298
             , QTY299
             , QTY300
             , QTY301
             , QTY302
             , QTY303
             , QTY304
             , QTY305
             , QTY306
             , QTY307
             , QTY308
             , QTY309
             , QTY310
             , QTY311
             , QTY312
             , QTY313
             , QTY314
             , QTY315
             , QTY316
             , QTY317
             , QTY318
             , QTY319
             , QTY320
             , QTY321
             , QTY322
             , QTY323
             , QTY324
             , QTY325
             , QTY326
             , QTY327
             , QTY328
             , QTY329
             , QTY330
             , QTY331
             , QTY332
             , QTY333
             , QTY334
             , QTY335
             , QTY336
             , QTY337
             , QTY338
             , QTY339
             , QTY340
             , QTY341
             , QTY342
             , QTY343
             , QTY344
             , QTY345
             , QTY346
             , QTY347
             , QTY348
             , QTY349
             , QTY350
             , QTY351
             , QTY352
             , QTY353
             , QTY354
             , QTY355
             , QTY356
             , QTY357
             , QTY358
             , QTY359
             , QTY360
             , QTY361
             , QTY362
             , QTY363
             , QTY364
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT SUB.DIVISION_ID
             , SUB.PLAN_START_YYYYMMDD
             , SUB.PLAN_TYPE
             , SUB.SEQ
             , SUB.OPERATION_GROUP
             , SUB.OPERATION_GROUP_NAME
             , SUB.CELL_ITEM_ID
             , SUB.ITEM_ID
             , SUB.NICK_NAME
             , SUB.CELL_QTY_PACK
             , SUB.TO_SITE
             , SUB.TO_SITE_DESCRIPTION
             , SUB.PROJECT_CODE
             , SUB.FROM_BOH_QTY
             , SUB.TO_BOH_QTY
             , SUB.INCOTERMS
             , SUB.FROM_SITE
             , SUB.FROM_SITE_DESCRIPTION
             , SUB.TRANSPORT_MODE
             , SUB.PROD_LINE
             , SUB.LT_DAY
             , SUB.BOD_ID
             , SUB.MEASURE
             , SUB.MEASURE_LABEL
             , SUB.XLS_KEY1
             , SUB.XLS_KEY2
             , SUB.XLS_KEY3
             , SUB.XLS_KEY4
             , SUB.XLS_KEY5
             , SUB.XLS_ATTRIBUTE1
             , SUB.XLS_ATTRIBUTE2
             , SUB.XLS_ATTRIBUTE3
             , SUB.XLS_ATTRIBUTE4
             , SUB.XLS_ATTRIBUTE5
             , SUB.SORT_ORDER_NO
             , 0                                      AS QTY001
             , 0                                      AS QTY002
             , 0                                      AS QTY003
             , 0                                      AS QTY004
             , 0                                      AS QTY005
             , 0                                      AS QTY006
             , 0                                      AS QTY007
             , 0                                      AS QTY008
             , 0                                      AS QTY009
             , 0                                      AS QTY010
             , 0                                      AS QTY011
             , 0                                      AS QTY012
             , 0                                      AS QTY013
             , 0                                      AS QTY014
             , 0                                      AS QTY015
             , 0                                      AS QTY016
             , 0                                      AS QTY017
             , 0                                      AS QTY018
             , 0                                      AS QTY019
             , 0                                      AS QTY020
             , 0                                      AS QTY021
             , 0                                      AS QTY022
             , 0                                      AS QTY023
             , 0                                      AS QTY024
             , 0                                      AS QTY025
             , 0                                      AS QTY026
             , 0                                      AS QTY027
             , 0                                      AS QTY028
             , 0                                      AS QTY029
             , 0                                      AS QTY030
             , 0                                      AS QTY031
             , 0                                      AS QTY032
             , 0                                      AS QTY033
             , 0                                      AS QTY034
             , 0                                      AS QTY035
             , 0                                      AS QTY036
             , 0                                      AS QTY037
             , 0                                      AS QTY038
             , 0                                      AS QTY039
             , 0                                      AS QTY040
             , 0                                      AS QTY041
             , 0                                      AS QTY042
             , 0                                      AS QTY043
             , 0                                      AS QTY044
             , 0                                      AS QTY045
             , 0                                      AS QTY046
             , 0                                      AS QTY047
             , 0                                      AS QTY048
             , 0                                      AS QTY049
             , 0                                      AS QTY050
             , 0                                      AS QTY051
             , 0                                      AS QTY052
             , 0                                      AS QTY053
             , 0                                      AS QTY054
             , 0                                      AS QTY055
             , 0                                      AS QTY056
             , 0                                      AS QTY057
             , 0                                      AS QTY058
             , 0                                      AS QTY059
             , 0                                      AS QTY060
             , 0                                      AS QTY061
             , 0                                      AS QTY062
             , 0                                      AS QTY063
             , 0                                      AS QTY064
             , 0                                      AS QTY065
             , 0                                      AS QTY066
             , 0                                      AS QTY067
             , 0                                      AS QTY068
             , 0                                      AS QTY069
             , 0                                      AS QTY070
             , 0                                      AS QTY071
             , 0                                      AS QTY072
             , 0                                      AS QTY073
             , 0                                      AS QTY074
             , 0                                      AS QTY075
             , 0                                      AS QTY076
             , 0                                      AS QTY077
             , 0                                      AS QTY078
             , 0                                      AS QTY079
             , 0                                      AS QTY080
             , 0                                      AS QTY081
             , 0                                      AS QTY082
             , 0                                      AS QTY083
             , 0                                      AS QTY084
             , 0                                      AS QTY085
             , 0                                      AS QTY086
             , 0                                      AS QTY087
             , 0                                      AS QTY088
             , 0                                      AS QTY089
             , 0                                      AS QTY090
             , 0                                      AS QTY091
             , 0                                      AS QTY092
             , 0                                      AS QTY093
             , 0                                      AS QTY094
             , 0                                      AS QTY095
             , 0                                      AS QTY096
             , 0                                      AS QTY097
             , 0                                      AS QTY098
             , 0                                      AS QTY099
             , 0                                      AS QTY100
             , 0                                      AS QTY101
             , 0                                      AS QTY102
             , 0                                      AS QTY103
             , 0                                      AS QTY104
             , 0                                      AS QTY105
             , 0                                      AS QTY106
             , 0                                      AS QTY107
             , 0                                      AS QTY108
             , 0                                      AS QTY109
             , 0                                      AS QTY110
             , 0                                      AS QTY111
             , 0                                      AS QTY112
             , 0                                      AS QTY113
             , 0                                      AS QTY114
             , 0                                      AS QTY115
             , 0                                      AS QTY116
             , 0                                      AS QTY117
             , 0                                      AS QTY118
             , 0                                      AS QTY119
             , 0                                      AS QTY120
             , 0                                      AS QTY121
             , 0                                      AS QTY122
             , 0                                      AS QTY123
             , 0                                      AS QTY124
             , 0                                      AS QTY125
             , 0                                      AS QTY126
             , 0                                      AS QTY127
             , 0                                      AS QTY128
             , 0                                      AS QTY129
             , 0                                      AS QTY130
             , 0                                      AS QTY131
             , 0                                      AS QTY132
             , 0                                      AS QTY133
             , 0                                      AS QTY134
             , 0                                      AS QTY135
             , 0                                      AS QTY136
             , 0                                      AS QTY137
             , 0                                      AS QTY138
             , 0                                      AS QTY139
             , 0                                      AS QTY140
             , 0                                      AS QTY141
             , 0                                      AS QTY142
             , 0                                      AS QTY143
             , 0                                      AS QTY144
             , 0                                      AS QTY145
             , 0                                      AS QTY146
             , 0                                      AS QTY147
             , 0                                      AS QTY148
             , 0                                      AS QTY149
             , 0                                      AS QTY150
             , 0                                      AS QTY151
             , 0                                      AS QTY152
             , 0                                      AS QTY153
             , 0                                      AS QTY154
             , 0                                      AS QTY155
             , 0                                      AS QTY156
             , 0                                      AS QTY157
             , 0                                      AS QTY158
             , 0                                      AS QTY159
             , 0                                      AS QTY160
             , 0                                      AS QTY161
             , 0                                      AS QTY162
             , 0                                      AS QTY163
             , 0                                      AS QTY164
             , 0                                      AS QTY165
             , 0                                      AS QTY166
             , 0                                      AS QTY167
             , 0                                      AS QTY168
             , 0                                      AS QTY169
             , 0                                      AS QTY170
             , 0                                      AS QTY171
             , 0                                      AS QTY172
             , 0                                      AS QTY173
             , 0                                      AS QTY174
             , 0                                      AS QTY175
             , 0                                      AS QTY176
             , 0                                      AS QTY177
             , 0                                      AS QTY178
             , 0                                      AS QTY179
             , 0                                      AS QTY180
             , 0                                      AS QTY181
             , 0                                      AS QTY182
             , 0                                      AS QTY183
             , 0                                      AS QTY184
             , 0                                      AS QTY185
             , 0                                      AS QTY186
             , 0                                      AS QTY187
             , 0                                      AS QTY188
             , 0                                      AS QTY189
             , 0                                      AS QTY190
             , 0                                      AS QTY191
             , 0                                      AS QTY192
             , 0                                      AS QTY193
             , 0                                      AS QTY194
             , 0                                      AS QTY195
             , 0                                      AS QTY196
             , 0                                      AS QTY197
             , 0                                      AS QTY198
             , 0                                      AS QTY199
             , 0                                      AS QTY200
             , 0                                      AS QTY201
             , 0                                      AS QTY202
             , 0                                      AS QTY203
             , 0                                      AS QTY204
             , 0                                      AS QTY205
             , 0                                      AS QTY206
             , 0                                      AS QTY207
             , 0                                      AS QTY208
             , 0                                      AS QTY209
             , 0                                      AS QTY210
             , 0                                      AS QTY211
             , 0                                      AS QTY212
             , 0                                      AS QTY213
             , 0                                      AS QTY214
             , 0                                      AS QTY215
             , 0                                      AS QTY216
             , 0                                      AS QTY217
             , 0                                      AS QTY218
             , 0                                      AS QTY219
             , 0                                      AS QTY220
             , 0                                      AS QTY221
             , 0                                      AS QTY222
             , 0                                      AS QTY223
             , 0                                      AS QTY224
             , 0                                      AS QTY225
             , 0                                      AS QTY226
             , 0                                      AS QTY227
             , 0                                      AS QTY228
             , 0                                      AS QTY229
             , 0                                      AS QTY230
             , 0                                      AS QTY231
             , 0                                      AS QTY232
             , 0                                      AS QTY233
             , 0                                      AS QTY234
             , 0                                      AS QTY235
             , 0                                      AS QTY236
             , 0                                      AS QTY237
             , 0                                      AS QTY238
             , 0                                      AS QTY239
             , 0                                      AS QTY240
             , 0                                      AS QTY241
             , 0                                      AS QTY242
             , 0                                      AS QTY243
             , 0                                      AS QTY244
             , 0                                      AS QTY245
             , 0                                      AS QTY246
             , 0                                      AS QTY247
             , 0                                      AS QTY248
             , 0                                      AS QTY249
             , 0                                      AS QTY250
             , 0                                      AS QTY251
             , 0                                      AS QTY252
             , 0                                      AS QTY253
             , 0                                      AS QTY254
             , 0                                      AS QTY255
             , 0                                      AS QTY256
             , 0                                      AS QTY257
             , 0                                      AS QTY258
             , 0                                      AS QTY259
             , 0                                      AS QTY260
             , 0                                      AS QTY261
             , 0                                      AS QTY262
             , 0                                      AS QTY263
             , 0                                      AS QTY264
             , 0                                      AS QTY265
             , 0                                      AS QTY266
             , 0                                      AS QTY267
             , 0                                      AS QTY268
             , 0                                      AS QTY269
             , 0                                      AS QTY270
             , 0                                      AS QTY271
             , 0                                      AS QTY272
             , 0                                      AS QTY273
             , 0                                      AS QTY274
             , 0                                      AS QTY275
             , 0                                      AS QTY276
             , 0                                      AS QTY277
             , 0                                      AS QTY278
             , 0                                      AS QTY279
             , 0                                      AS QTY280
             , 0                                      AS QTY281
             , 0                                      AS QTY282
             , 0                                      AS QTY283
             , 0                                      AS QTY284
             , 0                                      AS QTY285
             , 0                                      AS QTY286
             , 0                                      AS QTY287
             , 0                                      AS QTY288
             , 0                                      AS QTY289
             , 0                                      AS QTY290
             , 0                                      AS QTY291
             , 0                                      AS QTY292
             , 0                                      AS QTY293
             , 0                                      AS QTY294
             , 0                                      AS QTY295
             , 0                                      AS QTY296
             , 0                                      AS QTY297
             , 0                                      AS QTY298
             , 0                                      AS QTY299
             , 0                                      AS QTY300
             , 0                                      AS QTY301
             , 0                                      AS QTY302
             , 0                                      AS QTY303
             , 0                                      AS QTY304
             , 0                                      AS QTY305
             , 0                                      AS QTY306
             , 0                                      AS QTY307
             , 0                                      AS QTY308
             , 0                                      AS QTY309
             , 0                                      AS QTY310
             , 0                                      AS QTY311
             , 0                                      AS QTY312
             , 0                                      AS QTY313
             , 0                                      AS QTY314
             , 0                                      AS QTY315
             , 0                                      AS QTY316
             , 0                                      AS QTY317
             , 0                                      AS QTY318
             , 0                                      AS QTY319
             , 0                                      AS QTY320
             , 0                                      AS QTY321
             , 0                                      AS QTY322
             , 0                                      AS QTY323
             , 0                                      AS QTY324
             , 0                                      AS QTY325
             , 0                                      AS QTY326
             , 0                                      AS QTY327
             , 0                                      AS QTY328
             , 0                                      AS QTY329
             , 0                                      AS QTY330
             , 0                                      AS QTY331
             , 0                                      AS QTY332
             , 0                                      AS QTY333
             , 0                                      AS QTY334
             , 0                                      AS QTY335
             , 0                                      AS QTY336
             , 0                                      AS QTY337
             , 0                                      AS QTY338
             , 0                                      AS QTY339
             , 0                                      AS QTY340
             , 0                                      AS QTY341
             , 0                                      AS QTY342
             , 0                                      AS QTY343
             , 0                                      AS QTY344
             , 0                                      AS QTY345
             , 0                                      AS QTY346
             , 0                                      AS QTY347
             , 0                                      AS QTY348
             , 0                                      AS QTY349
             , 0                                      AS QTY350
             , 0                                      AS QTY351
             , 0                                      AS QTY352
             , 0                                      AS QTY353
             , 0                                      AS QTY354
             , 0                                      AS QTY355
             , 0                                      AS QTY356
             , 0                                      AS QTY357
             , 0                                      AS QTY358
             , 0                                      AS QTY359
             , 0                                      AS QTY360
             , 0                                      AS QTY361
             , 0                                      AS QTY362
             , 0                                      AS QTY363
             , 0                                      AS QTY364
               /* --,X.CREATED_BY */
               /* --,X.CREATION_DATE */
               /* --,X.LAST_UPDATED_BY */
               /* --,X.LAST_UPDATE_DATE */
             , SUB.ATTRIBUTE1
             , SUB.ATTRIBUTE2
             , SUB.ATTRIBUTE3
             , SUB.ATTRIBUTE4
             , SUB.ATTRIBUTE5
             , SUB.ATTRIBUTE6
             , SUB.ATTRIBUTE7
             , SUB.ATTRIBUTE8
             , SUB.ATTRIBUTE9
             , SUB.ATTRIBUTE10
          FROM (SELECT DISTINCT
                       X.DIVISION_ID
                     , X.PLAN_START_YYYYMMDD
                     , X.PLAN_TYPE
                     , X.SEQ
                     , X.OPERATION_GROUP
                     , X.OPERATION_GROUP_NAME
                     , X.CELL_ITEM_ID
                     , X.ITEM_ID
                     , X.NICK_NAME
                     , X.CELL_QTY_PACK
                     , X.TO_SITE
                     , X.TO_SITE_DESCRIPTION
                     , X.PROJECT_CODE
                     , X.FROM_BOH_QTY
                     , X.TO_BOH_QTY
                     , X.INCOTERMS
                     , X.FROM_SITE
                     , X.FROM_SITE_DESCRIPTION
                     , Y.TRANSPORT_MODE
                     , X.PROD_LINE
                     , Y.LT_TOTAL_BY_WEEK                AS LT_DAY
                     , Y.BOD_ID
                     , X.MEASURE
                     , X.MEASURE_LABEL
                     , X.XLS_KEY1
                     , X.XLS_KEY2
                     , X.XLS_KEY3
                     , X.XLS_KEY4
                     , X.XLS_KEY5
                     , X.XLS_ATTRIBUTE1
                     , X.XLS_ATTRIBUTE2
                     , X.XLS_ATTRIBUTE3
                     , X.XLS_ATTRIBUTE4
                     , X.XLS_ATTRIBUTE5
                     , X.SORT_ORDER_NO
                       /* --,X.CREATED_BY */
                       /* --,X.CREATION_DATE */
                       /* --,X.LAST_UPDATED_BY */
                       /* --,X.LAST_UPDATE_DATE */
                     , X.ATTRIBUTE1
                     , X.ATTRIBUTE2
                     , X.ATTRIBUTE3
                     , X.ATTRIBUTE4
                     , X.ATTRIBUTE5
                     , X.ATTRIBUTE6
                     , X.ATTRIBUTE7
                     , X.ATTRIBUTE8
                     , X.ATTRIBUTE9
                     , X.ATTRIBUTE10
                  FROM GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO X
                     , GT_XPGS_TRANSPORT_MODE                Y
                 WHERE 0 = 0
                   AND Y.DIVISION_ID(+)  = X.DIVISION_ID
                   AND Y.FROM_SITE(+)    = X.FROM_SITE
                   AND Y.TO_SITE(+)      = X.TO_SITE
                   /* --                                AND X.INCOTERMS       = Y.INCOTERMS */
                   AND NVL(Y.PROJECT_CODE(+), '-') = X.PROJECT_CODE
                   AND Y.BOD_ID(+)       = X.BOD_ID  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
                   /* AS-IS LEFT JOIN 조건 X.MEASURE = 'SEMI_SHIP_PLAN' : 바깥 조건 SUB.MEASURE = 'SEMI_SHIP_PLAN' 으로 다른 측정값 행은 어차피 제외되어 WHERE 로 이동 */
                   AND X.MEASURE         = 'SEMI_SHIP_PLAN'
                   /* --                                AND X.TRANSPORT_MODE  <> Y.TRANSPORT_MODE */
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS (SELECT 1
                             FROM GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO Z
                            WHERE 1 = 1
                              AND Z.DIVISION_ID          = SUB.DIVISION_ID
                              AND Z.OPERATION_GROUP      = SUB.OPERATION_GROUP
                              AND (Z.CELL_ITEM_ID = SUB.CELL_ITEM_ID OR (Z.CELL_ITEM_ID IS NULL AND SUB.CELL_ITEM_ID IS NULL))
                              AND Z.ITEM_ID              = SUB.ITEM_ID
                              AND Z.PROJECT_CODE         = SUB.PROJECT_CODE
                              AND Z.TO_SITE              = SUB.TO_SITE
                              AND Z.INCOTERMS            = SUB.INCOTERMS
                              AND Z.FROM_SITE            = SUB.FROM_SITE
                              AND Z.TRANSPORT_MODE       = SUB.TRANSPORT_MODE
                              AND Z.MEASURE              = SUB.MEASURE
                              AND Z.MEASURE              = 'SEMI_SHIP_PLAN'
                              AND Z.BOD_ID               = SUB.BOD_ID
                              AND (Z.ATTRIBUTE1 = SUB.ATTRIBUTE1 OR (Z.ATTRIBUTE1 IS NULL AND SUB.ATTRIBUTE1 IS NULL))
                              /* --			                                         AND Z.ATTRIBUTE9						=	SUB.ATTRIBUTE9 */
                          )
           AND SUB.MEASURE         = 'SEMI_SHIP_PLAN'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 006 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* TACT TIME TEMP 생성  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* #tmp_SCP_MST_TACT_TIME (SCP_MST_TACT_TIME UNION ALL SCP_MST_TACT_TIME_OSP, 사업부 조건) :
           아래 PACK PROD 수율 반영 한 곳에서만 쓰여 그 자리의 인라인 뷰로 옮김 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 007 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* AS-IS L937~L1162 (원문 그대로 보존)
           -- 주석처리 : 2022.10.14 - 불필요한 생산계획 생성을 차단
                       ---------------------------------------------------------------------------------------------------------------
                       ---- LINE_ID 추가
                       ---------------------------------------------------------------------------------------------------------------
                       ---- 'SHIP_PLAN'의 LINE_ID 종류 별 추가
                       --   INSERT INTO #SCP_XLS_PSI_GLOBAL_SMALL_AUTO
                       --          SELECT DISTINCT X.DIVISION_ID
                       --          ,X.PLAN_START_YYYYMMDD
                       --          ,X.PLAN_TYPE
                       --          ,X.SEQ
                       --          ,X.OPERATION_GROUP
                       --          ,X.OPERATION_GROUP_NAME
                       --          ,X.CELL_ITEM_ID
                       --          ,X.ITEM_ID
                       --          ,X.NICK_NAME
                       --          ,X.CELL_QTY_PACK
                       --          ,TO_SITE
                       --          ,TO_SITE_DESCRIPTION
                       --          ,PROJECT_CODE
                       --          ,FROM_BOH_QTY
                       --          ,TO_BOH_QTY
                       --          ,INCOTERMS
                       --          ,FROM_SITE
                       --          ,FROM_SITE_DESCRIPTION
                       --          ,TRANSPORT_MODE
                       --          ,Y.LINE_ID AS PROD_LINE
                       --          ,LT_DAY
                       --          ,BOD_ID
                       --          ,X.MEASURE
                       --          ,X.MEASURE_LABEL
                       --          ,X.XLS_KEY1
                       --          ,X.XLS_KEY2
                       --          ,X.XLS_KEY3
                       --          ,X.XLS_KEY4
                       --          ,X.XLS_KEY5
                       --          ,X.XLS_ATTRIBUTE1
                       --          ,X.XLS_ATTRIBUTE2
                       --          ,X.XLS_ATTRIBUTE3
                       --          ,X.XLS_ATTRIBUTE4
                       --          ,X.XLS_ATTRIBUTE5
                       --          ,X.SORT_ORDER_NO
                       --          ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0  AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
                       --          ,0  AS QTY011 ,0  AS QTY012,0  AS QTY013,0  AS QTY014,0  AS QTY015,0  AS QTY016 ,0  AS QTY017,0  AS QTY018,0  AS QTY019,0  AS QTY020
                       --          ,0  AS QTY021 ,0  AS QTY022,0  AS QTY023,0  AS QTY024,0  AS QTY025,0  AS QTY026 ,0  AS QTY027,0  AS QTY028,0  AS QTY029,0  AS QTY030
                       --          ,0  AS QTY031 ,0  AS QTY032,0  AS QTY033,0  AS QTY034,0  AS QTY035,0  AS QTY036 ,0  AS QTY037,0  AS QTY038,0  AS QTY039,0  AS QTY040
                       --          ,0  AS QTY041 ,0  AS QTY042,0  AS QTY043,0  AS QTY044,0  AS QTY045,0  AS QTY046 ,0  AS QTY047,0  AS QTY048,0  AS QTY049,0  AS QTY050
                       --          ,0  AS QTY051 ,0  AS QTY052,0  AS QTY053,0  AS QTY054,0  AS QTY055,0  AS QTY056 ,0  AS QTY057,0  AS QTY058,0  AS QTY059,0  AS QTY060
                       --          ,0  AS QTY061 ,0  AS QTY062,0  AS QTY063,0  AS QTY064,0  AS QTY065,0  AS QTY066 ,0  AS QTY067,0  AS QTY068,0  AS QTY069,0  AS QTY070
                       --          ,0  AS QTY071 ,0  AS QTY072,0  AS QTY073,0  AS QTY074,0  AS QTY075,0  AS QTY076 ,0  AS QTY077,0  AS QTY078,0  AS QTY079,0  AS QTY080
                       --          ,0  AS QTY081 ,0  AS QTY082,0  AS QTY083,0  AS QTY084,0  AS QTY085,0  AS QTY086 ,0  AS QTY087,0  AS QTY088,0  AS QTY089,0  AS QTY090
                       --          ,0  AS QTY091 ,0  AS QTY092,0  AS QTY093,0  AS QTY094,0  AS QTY095,0  AS QTY096 ,0  AS QTY097,0  AS QTY098,0  AS QTY099,0  AS QTY100

                       --          ,0  AS QTY101 ,0  AS QTY102,0  AS QTY103,0  AS QTY104,0  AS QTY105,0  AS QTY106 ,0  AS QTY107,0  AS QTY108,0  AS QTY109,0  AS QTY110
                       --          ,0  AS QTY111 ,0  AS QTY112,0  AS QTY113,0  AS QTY114,0  AS QTY115,0  AS QTY116 ,0  AS QTY117,0  AS QTY118,0  AS QTY119,0  AS QTY120
                       --          ,0  AS QTY121 ,0  AS QTY122,0  AS QTY123,0  AS QTY124,0  AS QTY125,0  AS QTY126 ,0  AS QTY127,0  AS QTY128,0  AS QTY129,0  AS QTY130
                       --          ,0  AS QTY131 ,0  AS QTY132,0  AS QTY133,0  AS QTY134,0  AS QTY135,0  AS QTY136 ,0  AS QTY137,0  AS QTY138,0  AS QTY139,0  AS QTY140
                       --          ,0  AS QTY141 ,0  AS QTY142,0  AS QTY143,0  AS QTY144,0  AS QTY145,0  AS QTY146 ,0  AS QTY147,0  AS QTY148,0  AS QTY149,0  AS QTY150
                       --          ,0  AS QTY151 ,0  AS QTY152,0  AS QTY153,0  AS QTY154,0  AS QTY155,0  AS QTY156 ,0  AS QTY157,0  AS QTY158,0  AS QTY159,0  AS QTY160
                       --          ,0  AS QTY161 ,0  AS QTY162,0  AS QTY163,0  AS QTY164,0  AS QTY165,0  AS QTY166 ,0  AS QTY167,0  AS QTY168,0  AS QTY169,0  AS QTY170
                       --          ,0  AS QTY171 ,0  AS QTY172,0  AS QTY173,0  AS QTY174,0  AS QTY175,0  AS QTY176 ,0  AS QTY177,0  AS QTY178,0  AS QTY179,0  AS QTY180
                       --          ,0  AS QTY181 ,0  AS QTY182,0  AS QTY183,0  AS QTY184,0  AS QTY185,0  AS QTY186 ,0  AS QTY187,0  AS QTY188,0  AS QTY189,0  AS QTY190
                       --          ,0  AS QTY191 ,0  AS QTY192,0  AS QTY193,0  AS QTY194,0  AS QTY195,0  AS QTY196 ,0  AS QTY197,0  AS QTY198,0  AS QTY199,0  AS QTY200

                       --          ,0  AS QTY201 ,0  AS QTY202,0  AS QTY203,0  AS QTY204,0  AS QTY205,0  AS QTY206 ,0  AS QTY207,0  AS QTY208,0  AS QTY209,0  AS QTY210
                       --          ,0  AS QTY211 ,0  AS QTY212,0  AS QTY213,0  AS QTY214,0  AS QTY215,0  AS QTY216 ,0  AS QTY217,0  AS QTY218,0  AS QTY219,0  AS QTY220
                       --          ,0  AS QTY221 ,0  AS QTY222,0  AS QTY223,0  AS QTY224,0  AS QTY225,0  AS QTY226 ,0  AS QTY227,0  AS QTY228,0  AS QTY229,0  AS QTY230
                       --          ,0  AS QTY231 ,0  AS QTY232,0  AS QTY233,0  AS QTY234,0  AS QTY235,0  AS QTY236 ,0  AS QTY237,0  AS QTY238,0  AS QTY239,0  AS QTY240
                       --          ,0  AS QTY241 ,0  AS QTY242,0  AS QTY243,0  AS QTY244,0  AS QTY245,0  AS QTY246 ,0  AS QTY247,0  AS QTY248,0  AS QTY249,0  AS QTY250
                       --          ,0  AS QTY251 ,0  AS QTY252,0  AS QTY253,0  AS QTY254,0  AS QTY255,0  AS QTY256 ,0  AS QTY257,0  AS QTY258,0  AS QTY259,0  AS QTY260
                       --          ,0  AS QTY261 ,0  AS QTY262,0  AS QTY263,0  AS QTY264,0  AS QTY265,0  AS QTY266 ,0  AS QTY267,0  AS QTY268,0  AS QTY269,0  AS QTY270
                       --          ,0  AS QTY271 ,0  AS QTY272,0  AS QTY273,0  AS QTY274,0  AS QTY275,0  AS QTY276 ,0  AS QTY277,0  AS QTY278,0  AS QTY279,0  AS QTY280
                       --          ,0  AS QTY281 ,0  AS QTY282,0  AS QTY283,0  AS QTY284,0  AS QTY285,0  AS QTY286 ,0  AS QTY287,0  AS QTY288,0  AS QTY289,0  AS QTY290
                       --          ,0  AS QTY291 ,0  AS QTY292,0  AS QTY293,0  AS QTY294,0  AS QTY295,0  AS QTY296 ,0  AS QTY297,0  AS QTY298,0  AS QTY299,0  AS QTY300

                       --          ,0  AS QTY301 ,0  AS QTY302,0  AS QTY303,0  AS QTY304,0  AS QTY305,0  AS QTY306 ,0  AS QTY307,0  AS QTY308,0  AS QTY309,0  AS QTY310
                       --          ,0  AS QTY311 ,0  AS QTY312,0  AS QTY313,0  AS QTY314,0  AS QTY315,0  AS QTY316 ,0  AS QTY317,0  AS QTY318,0  AS QTY319,0  AS QTY320
                       --          ,0  AS QTY321 ,0  AS QTY322,0  AS QTY323,0  AS QTY324,0  AS QTY325,0  AS QTY326 ,0  AS QTY327,0  AS QTY328,0  AS QTY329,0  AS QTY330
                       --          ,0  AS QTY331 ,0  AS QTY332,0  AS QTY333,0  AS QTY334,0  AS QTY335,0  AS QTY336 ,0  AS QTY337,0  AS QTY338,0  AS QTY339,0  AS QTY340
                       --          ,0 AS QTY341 ,0  AS QTY342,0  AS QTY343,0  AS QTY344,0  AS QTY345,0  AS QTY346 ,0  AS QTY347,0  AS QTY348,0  AS QTY349,0  AS QTY350
                       --          ,0  AS QTY351 ,0  AS QTY352,0  AS QTY353,0  AS QTY354,0  AS QTY355,0  AS QTY356 ,0  AS QTY357,0  AS QTY358,0  AS QTY359,0  AS QTY360
                       --          ,0  AS QTY361 ,0  AS QTY362,0  AS QTY363,0  AS QTY364
                       --          --,X.CREATED_BY
                       --          --,X.CREATION_DATE
                       --          --,X.LAST_UPDATED_BY
                       --          --,X.LAST_UPDATE_DATE
                       --          ,X.ATTRIBUTE1
                       --          ,X.ATTRIBUTE2
                       --          ,X.ATTRIBUTE3
                       --          ,X.ATTRIBUTE4
                       --          ,X.ATTRIBUTE5
                       --          ,X.ATTRIBUTE6
                       --          ,X.ATTRIBUTE7
                       --          ,X.ATTRIBUTE8
                       --          ,X.ATTRIBUTE9
                       --          ,X.ATTRIBUTE10
                       --          FROM #SCP_XLS_PSI_GLOBAL_SMALL_AUTO X WITH (NOLOCK)
                       --          CROSS APPLY #tmp_SCP_MST_TACT_TIME Y  WITH (NOLOCK)
                       --          WHERE 0 = 0
                       --          AND X.DIVISION_ID   = Y.DIVISION_ID
                       --          AND X.ITEM_ID       = Y.ITEM_ID
                       --          AND X.FROM_SITE     = Y.PLANT_SITE_ID
                       --          AND X.MEASURE       IN  ('CELL_PROD','PACK_PROD')
                       --          AND NOT EXISTS (
                       --                                SELECT 'X'
                       --                                  FROM #SCP_XLS_PSI_GLOBAL_SMALL_AUTO Z WITH(NOLOCK)
                       --                                 WHERE 1=1
                       --                                   AND Z.DIVISION_ID          = X.DIVISION_ID
                       --                                   AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID
                       --                                   AND Z.ITEM_ID              = X.ITEM_ID
                       --                                   AND Z.MEASURE              = X.MEASURE
                       --                                   AND Z.FROM_SITE            = Y.PLANT_SITE_ID
                       --                                   AND Z.PROD_LINE            = Y.LINE_ID
                       --                                   AND Z.MEASURE              IN ('CELL_PROD','PACK_PROD')
                       --                                   )

                       --  UNION
                       --        SELECT DISTINCT X.DIVISION_ID
                       --          ,X.PLAN_START_YYYYMMDD
                       --          ,X.PLAN_TYPE
                       --          ,X.SEQ
                       --          ,X.OPERATION_GROUP
                       --          ,X.OPERATION_GROUP_NAME
                       --          ,X.CELL_ITEM_ID
                       --          ,X.ITEM_ID
                       --          ,X.NICK_NAME
                       --          ,X.CELL_QTY_PACK
                       --          ,X.TO_SITE
                       --          ,X.TO_SITE_DESCRIPTION
                       --          ,X.PROJECT_CODE
                       --          ,X.FROM_BOH_QTY
                       --          ,X.TO_BOH_QTY
                       --          ,X.INCOTERMS
                       --          ,X.FROM_SITE
                       --          ,X.FROM_SITE_DESCRIPTION
                       --          ,X.TRANSPORT_MODE
                       --          ,Y.LINE_ID AS PROD_LINE
                       --          ,X.LT_DAY
                       --          ,X.BOD_ID
                       --          ,(CASE  WHEN X.MEASURE = 'PACK_PROD' THEN 'PACK_PROD_LOAD'
                       --                  WHEN X.MEASURE = 'CELL_PROD' THEN 'CELL_PROD_LOAD' END ) AS MEASURE
                       --          ,(CASE  WHEN X.MEASURE = 'PACK_PROD' THEN 'Load Ratio(%)'
                       --                  WHEN X.MEASURE = 'CELL_PROD' THEN 'Load Ratio(%)' END ) AS MEASURE_LABEL
                       --          ,X.XLS_KEY1
                       --          ,X.XLS_KEY2
                       --          ,X.XLS_KEY3
                       --          ,X.XLS_KEY4
                       --          ,X.XLS_KEY5
                       --          ,X.XLS_ATTRIBUTE1
                       --          ,X.XLS_ATTRIBUTE2
                       --          ,X.XLS_ATTRIBUTE3
                       --          ,X.XLS_ATTRIBUTE4
                       --          ,X.XLS_ATTRIBUTE5
                       --          ,X.SORT_ORDER_NO
                       --          ,0  AS QTY001 ,0  AS QTY002,0  AS QTY003,0  AS QTY004,0  AS QTY005,0  AS QTY006 ,0  AS QTY007,0  AS QTY008,0  AS QTY009,0  AS QTY010
                       --          ,0  AS QTY011 ,0  AS QTY012,0  AS QTY013,0  AS QTY014,0  AS QTY015,0  AS QTY016 ,0  AS QTY017,0  AS QTY018,0  AS QTY019,0  AS QTY020
                       --          ,0  AS QTY021 ,0  AS QTY022,0  AS QTY023,0  AS QTY024,0  AS QTY025,0  AS QTY026 ,0  AS QTY027,0  AS QTY028,0  AS QTY029,0  AS QTY030
                       --          ,0  AS QTY031 ,0  AS QTY032,0  AS QTY033,0  AS QTY034,0  AS QTY035,0  AS QTY036 ,0  AS QTY037,0  AS QTY038,0  AS QTY039,0  AS QTY040
                       --          ,0  AS QTY041 ,0  AS QTY042,0  AS QTY043,0  AS QTY044,0  AS QTY045,0  AS QTY046 ,0  AS QTY047,0  AS QTY048,0  AS QTY049,0  AS QTY050
                       --          ,0  AS QTY051 ,0  AS QTY052,0  AS QTY053,0  AS QTY054,0  AS QTY055,0  AS QTY056 ,0  AS QTY057,0  AS QTY058,0  AS QTY059,0  AS QTY060
                       --          ,0  AS QTY061 ,0  AS QTY062,0  AS QTY063,0  AS QTY064,0  AS QTY065,0  AS QTY066 ,0  AS QTY067,0  AS QTY068,0  AS QTY069,0  AS QTY070
                       --          ,0  AS QTY071 ,0  AS QTY072,0  AS QTY073,0  AS QTY074,0  AS QTY075,0  AS QTY076 ,0  AS QTY077,0  AS QTY078,0  AS QTY079,0  AS QTY080
                       --          ,0  AS QTY081 ,0  AS QTY082,0  AS QTY083,0  AS QTY084,0  AS QTY085,0  AS QTY086 ,0  AS QTY087,0  AS QTY088,0  AS QTY089,0  AS QTY090
                       --          ,0  AS QTY091 ,0  AS QTY092,0  AS QTY093,0  AS QTY094,0  AS QTY095,0  AS QTY096 ,0  AS QTY097,0  AS QTY098,0  AS QTY099,0  AS QTY100

                       --          ,0  AS QTY101 ,0  AS QTY102,0  AS QTY103,0  AS QTY104,0  AS QTY105,0  AS QTY106 ,0  AS QTY107,0  AS QTY108,0  AS QTY109,0  AS QTY110
                       --          ,0  AS QTY111 ,0  AS QTY112,0  AS QTY113,0  AS QTY114,0  AS QTY115,0  AS QTY116 ,0  AS QTY117,0  AS QTY118,0  AS QTY119,0  AS QTY120
                       --          ,0  AS QTY121 ,0  AS QTY122,0  AS QTY123,0  AS QTY124,0  AS QTY125,0  AS QTY126 ,0  AS QTY127,0  AS QTY128,0  AS QTY129,0  AS QTY130
                       --          ,0  AS QTY131 ,0  AS QTY132,0  AS QTY133,0  AS QTY134,0  AS QTY135,0  AS QTY136 ,0  AS QTY137,0  AS QTY138,0  AS QTY139,0  AS QTY140
                       --          ,0  AS QTY141 ,0  AS QTY142,0  AS QTY143,0  AS QTY144,0  AS QTY145,0  AS QTY146 ,0  AS QTY147,0  AS QTY148,0  AS QTY149,0  AS QTY150
                       --          ,0  AS QTY151 ,0  AS QTY152,0  AS QTY153,0  AS QTY154,0  AS QTY155,0  AS QTY156 ,0  AS QTY157,0  AS QTY158,0  AS QTY159,0  AS QTY160
                       --          ,0  AS QTY161 ,0  AS QTY162,0  AS QTY163,0  AS QTY164,0  AS QTY165,0  AS QTY166 ,0  AS QTY167,0  AS QTY168,0  AS QTY169,0  AS QTY170
                       --          ,0  AS QTY171 ,0  AS QTY172,0  AS QTY173,0  AS QTY174,0  AS QTY175,0  AS QTY176 ,0  AS QTY177,0  AS QTY178,0  AS QTY179,0  AS QTY180
                       --          ,0  AS QTY181 ,0  AS QTY182,0  AS QTY183,0  AS QTY184,0  AS QTY185,0  AS QTY186 ,0  AS QTY187,0  AS QTY188,0  AS QTY189,0  AS QTY190
                       --          ,0  AS QTY191 ,0  AS QTY192,0  AS QTY193,0  AS QTY194,0  AS QTY195,0  AS QTY196 ,0  AS QTY197,0  AS QTY198,0  AS QTY199,0  AS QTY200

                       --          ,0  AS QTY201 ,0  AS QTY202,0  AS QTY203,0  AS QTY204,0  AS QTY205,0  AS QTY206 ,0  AS QTY207,0  AS QTY208,0  AS QTY209,0  AS QTY210
                       --          ,0  AS QTY211 ,0  AS QTY212,0  AS QTY213,0  AS QTY214,0  AS QTY215,0  AS QTY216 ,0  AS QTY217,0  AS QTY218,0  AS QTY219,0  AS QTY220
                       --          ,0  AS QTY221 ,0  AS QTY222,0  AS QTY223,0  AS QTY224,0  AS QTY225,0  AS QTY226 ,0  AS QTY227,0  AS QTY228,0  AS QTY229,0  AS QTY230
                       --          ,0  AS QTY231 ,0  AS QTY232,0  AS QTY233,0  AS QTY234,0  AS QTY235,0  AS QTY236 ,0  AS QTY237,0  AS QTY238,0  AS QTY239,0  AS QTY240
                       --          ,0  AS QTY241 ,0  AS QTY242,0  AS QTY243,0  AS QTY244,0  AS QTY245,0  AS QTY246 ,0  AS QTY247,0  AS QTY248,0  AS QTY249,0  AS QTY250
                       --          ,0  AS QTY251 ,0  AS QTY252,0  AS QTY253,0  AS QTY254,0  AS QTY255,0  AS QTY256 ,0  AS QTY257,0  AS QTY258,0  AS QTY259,0  AS QTY260
                       --          ,0  AS QTY261 ,0  AS QTY262,0  AS QTY263,0  AS QTY264,0  AS QTY265,0  AS QTY266 ,0  AS QTY267,0  AS QTY268,0  AS QTY269,0  AS QTY270
                       --          ,0  AS QTY271 ,0  AS QTY272,0  AS QTY273,0  AS QTY274,0  AS QTY275,0  AS QTY276 ,0  AS QTY277,0  AS QTY278,0  AS QTY279,0  AS QTY280
                       --          ,0  AS QTY281 ,0  AS QTY282,0  AS QTY283,0  AS QTY284,0  AS QTY285,0  AS QTY286 ,0  AS QTY287,0  AS QTY288,0  AS QTY289,0  AS QTY290
                       --          ,0  AS QTY291 ,0  AS QTY292,0  AS QTY293,0  AS QTY294,0  AS QTY295,0  AS QTY296 ,0  AS QTY297,0  AS QTY298,0  AS QTY299,0  AS QTY300

                       --          ,0  AS QTY301 ,0  AS QTY302,0  AS QTY303,0  AS QTY304,0  AS QTY305,0  AS QTY306 ,0  AS QTY307,0  AS QTY308,0  AS QTY309,0  AS QTY310
                       --          ,0  AS QTY311 ,0  AS QTY312,0  AS QTY313,0  AS QTY314,0  AS QTY315,0  AS QTY316 ,0  AS QTY317,0  AS QTY318,0  AS QTY319,0  AS QTY320
                       --          ,0  AS QTY321 ,0  AS QTY322,0  AS QTY323,0  AS QTY324,0  AS QTY325,0  AS QTY326 ,0  AS QTY327,0  AS QTY328,0  AS QTY329,0  AS QTY330
                       --          ,0  AS QTY331 ,0  AS QTY332,0  AS QTY333,0  AS QTY334,0  AS QTY335,0  AS QTY336 ,0  AS QTY337,0  AS QTY338,0  AS QTY339,0  AS QTY340
                       --          ,0  AS QTY341 ,0  AS QTY342,0  AS QTY343,0  AS QTY344,0  AS QTY345,0  AS QTY346 ,0  AS QTY347,0  AS QTY348,0  AS QTY349,0  AS QTY350
                       --          ,0  AS QTY351 ,0  AS QTY352,0  AS QTY353,0  AS QTY354,0  AS QTY355,0  AS QTY356 ,0  AS QTY357,0  AS QTY358,0  AS QTY359,0  AS QTY360
                       --          ,0  AS QTY361 ,0  AS QTY362,0  AS QTY363,0  AS QTY364
                       --          --,X.CREATED_BY
                       --          --,X.CREATION_DATE
                       --          --,X.LAST_UPDATED_BY
                       --          --,X.LAST_UPDATE_DATE
                       --          ,X.ATTRIBUTE1
                       --          ,X.ATTRIBUTE2
                       --          ,X.ATTRIBUTE3
                       --          ,X.ATTRIBUTE4
                       --          ,X.ATTRIBUTE5
                       --          ,X.ATTRIBUTE6
                       --          ,X.ATTRIBUTE7
                       --          ,X.ATTRIBUTE8
                       --          ,X.ATTRIBUTE9
                       --          ,X.ATTRIBUTE10
                       --          FROM #SCP_XLS_PSI_GLOBAL_SMALL_AUTO X WITH (NOLOCK)
                       --          CROSS APPLY #tmp_SCP_MST_TACT_TIME Y  WITH (NOLOCK)
                       --          WHERE 0 = 0
                       --          AND X.DIVISION_ID   = Y.DIVISION_ID
                       --          AND X.ITEM_ID       = Y.ITEM_ID
                       --          AND X.FROM_SITE     = Y.PLANT_SITE_ID
                       --          AND X.MEASURE       IN  ('CELL_PROD','PACK_PROD')
                       --          AND NOT EXISTS (
                       --                                SELECT 'X'
                       --                                  FROM #SCP_XLS_PSI_GLOBAL_SMALL_AUTO Z WITH(NOLOCK)
                       --                                 WHERE 1=1
                       --                                   AND Z.DIVISION_ID          = X.DIVISION_ID
                       --                                   AND Z.CELL_ITEM_ID         = X.CELL_ITEM_ID
                       --                                   AND Z.ITEM_ID              = X.ITEM_ID
                       --                                   AND Z.MEASURE              = X.MEASURE
                       --                                   AND Z.FROM_SITE            = Y.PLANT_SITE_ID
                       --                                   AND Z.PROD_LINE            = Y.LINE_ID
                       --                                   AND Z.MEASURE              IN ('CELL_PROD','PACK_PROD')
                       --                                   )
        */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* MEASURE 추가 : ITEM_ID별 (MKT_FCST_CELL_TOTAL) */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001
             , QTY002
             , QTY003
             , QTY004
             , QTY005
             , QTY006
             , QTY007
             , QTY008
             , QTY009
             , QTY010
             , QTY011
             , QTY012
             , QTY013
             , QTY014
             , QTY015
             , QTY016
             , QTY017
             , QTY018
             , QTY019
             , QTY020
             , QTY021
             , QTY022
             , QTY023
             , QTY024
             , QTY025
             , QTY026
             , QTY027
             , QTY028
             , QTY029
             , QTY030
             , QTY031
             , QTY032
             , QTY033
             , QTY034
             , QTY035
             , QTY036
             , QTY037
             , QTY038
             , QTY039
             , QTY040
             , QTY041
             , QTY042
             , QTY043
             , QTY044
             , QTY045
             , QTY046
             , QTY047
             , QTY048
             , QTY049
             , QTY050
             , QTY051
             , QTY052
             , QTY053
             , QTY054
             , QTY055
             , QTY056
             , QTY057
             , QTY058
             , QTY059
             , QTY060
             , QTY061
             , QTY062
             , QTY063
             , QTY064
             , QTY065
             , QTY066
             , QTY067
             , QTY068
             , QTY069
             , QTY070
             , QTY071
             , QTY072
             , QTY073
             , QTY074
             , QTY075
             , QTY076
             , QTY077
             , QTY078
             , QTY079
             , QTY080
             , QTY081
             , QTY082
             , QTY083
             , QTY084
             , QTY085
             , QTY086
             , QTY087
             , QTY088
             , QTY089
             , QTY090
             , QTY091
             , QTY092
             , QTY093
             , QTY094
             , QTY095
             , QTY096
             , QTY097
             , QTY098
             , QTY099
             , QTY100
             , QTY101
             , QTY102
             , QTY103
             , QTY104
             , QTY105
             , QTY106
             , QTY107
             , QTY108
             , QTY109
             , QTY110
             , QTY111
             , QTY112
             , QTY113
             , QTY114
             , QTY115
             , QTY116
             , QTY117
             , QTY118
             , QTY119
             , QTY120
             , QTY121
             , QTY122
             , QTY123
             , QTY124
             , QTY125
             , QTY126
             , QTY127
             , QTY128
             , QTY129
             , QTY130
             , QTY131
             , QTY132
             , QTY133
             , QTY134
             , QTY135
             , QTY136
             , QTY137
             , QTY138
             , QTY139
             , QTY140
             , QTY141
             , QTY142
             , QTY143
             , QTY144
             , QTY145
             , QTY146
             , QTY147
             , QTY148
             , QTY149
             , QTY150
             , QTY151
             , QTY152
             , QTY153
             , QTY154
             , QTY155
             , QTY156
             , QTY157
             , QTY158
             , QTY159
             , QTY160
             , QTY161
             , QTY162
             , QTY163
             , QTY164
             , QTY165
             , QTY166
             , QTY167
             , QTY168
             , QTY169
             , QTY170
             , QTY171
             , QTY172
             , QTY173
             , QTY174
             , QTY175
             , QTY176
             , QTY177
             , QTY178
             , QTY179
             , QTY180
             , QTY181
             , QTY182
             , QTY183
             , QTY184
             , QTY185
             , QTY186
             , QTY187
             , QTY188
             , QTY189
             , QTY190
             , QTY191
             , QTY192
             , QTY193
             , QTY194
             , QTY195
             , QTY196
             , QTY197
             , QTY198
             , QTY199
             , QTY200
             , QTY201
             , QTY202
             , QTY203
             , QTY204
             , QTY205
             , QTY206
             , QTY207
             , QTY208
             , QTY209
             , QTY210
             , QTY211
             , QTY212
             , QTY213
             , QTY214
             , QTY215
             , QTY216
             , QTY217
             , QTY218
             , QTY219
             , QTY220
             , QTY221
             , QTY222
             , QTY223
             , QTY224
             , QTY225
             , QTY226
             , QTY227
             , QTY228
             , QTY229
             , QTY230
             , QTY231
             , QTY232
             , QTY233
             , QTY234
             , QTY235
             , QTY236
             , QTY237
             , QTY238
             , QTY239
             , QTY240
             , QTY241
             , QTY242
             , QTY243
             , QTY244
             , QTY245
             , QTY246
             , QTY247
             , QTY248
             , QTY249
             , QTY250
             , QTY251
             , QTY252
             , QTY253
             , QTY254
             , QTY255
             , QTY256
             , QTY257
             , QTY258
             , QTY259
             , QTY260
             , QTY261
             , QTY262
             , QTY263
             , QTY264
             , QTY265
             , QTY266
             , QTY267
             , QTY268
             , QTY269
             , QTY270
             , QTY271
             , QTY272
             , QTY273
             , QTY274
             , QTY275
             , QTY276
             , QTY277
             , QTY278
             , QTY279
             , QTY280
             , QTY281
             , QTY282
             , QTY283
             , QTY284
             , QTY285
             , QTY286
             , QTY287
             , QTY288
             , QTY289
             , QTY290
             , QTY291
             , QTY292
             , QTY293
             , QTY294
             , QTY295
             , QTY296
             , QTY297
             , QTY298
             , QTY299
             , QTY300
             , QTY301
             , QTY302
             , QTY303
             , QTY304
             , QTY305
             , QTY306
             , QTY307
             , QTY308
             , QTY309
             , QTY310
             , QTY311
             , QTY312
             , QTY313
             , QTY314
             , QTY315
             , QTY316
             , QTY317
             , QTY318
             , QTY319
             , QTY320
             , QTY321
             , QTY322
             , QTY323
             , QTY324
             , QTY325
             , QTY326
             , QTY327
             , QTY328
             , QTY329
             , QTY330
             , QTY331
             , QTY332
             , QTY333
             , QTY334
             , QTY335
             , QTY336
             , QTY337
             , QTY338
             , QTY339
             , QTY340
             , QTY341
             , QTY342
             , QTY343
             , QTY344
             , QTY345
             , QTY346
             , QTY347
             , QTY348
             , QTY349
             , QTY350
             , QTY351
             , QTY352
             , QTY353
             , QTY354
             , QTY355
             , QTY356
             , QTY357
             , QTY358
             , QTY359
             , QTY360
             , QTY361
             , QTY362
             , QTY363
             , QTY364
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.PLAN_START_YYYYMMDD
             , X.PLAN_TYPE
             , X.SEQ
             , X.OPERATION_GROUP
             , 'CELL'                   AS OPERATION_GROUP_NAME
             , X.CELL_ITEM_ID
             , '-'                      AS ITEM_ID
             , '-'                      AS NICK_NAME
             , 0                        AS CELL_QTY_PACK
             , '-'                      AS TO_SITE
             , '-'                      AS TO_SITE_DESCRIPTION
             , '-'                      AS PROJECT_CODE
             , 0                        AS FROM_BOH_QTY
             , 0                        AS TO_BOH_QTY
             , '-'                      AS INCOTERMS
             , '-'                      AS FROM_SITE
             , '-'                      AS FROM_SITE_DESCRIPTION
             , '-'                      AS TRANSPORT_MODE
             , '-'                      AS PROD_LINE
             , 0                        AS LT_DAY  /* AS-IS '-' AS LT_DAY → INT 칸 적재 시 0 */
             , '-'                      AS BOD_ID
             , M.COLUMN_NAME            AS MEASURE
             , M.COLUMN_LABEL_NAME      AS MEASURE_LABEL
             , X.XLS_KEY1
             , X.XLS_KEY2
             , X.XLS_KEY3
             , X.XLS_KEY4
             , X.XLS_KEY5
             , X.XLS_ATTRIBUTE1
             , X.XLS_ATTRIBUTE2
             , X.XLS_ATTRIBUTE3
             , X.XLS_ATTRIBUTE4
             , X.XLS_ATTRIBUTE5
             , M.SORT_ORDER_NO
             , 0                                      AS QTY001
             , 0                                      AS QTY002
             , 0                                      AS QTY003
             , 0                                      AS QTY004
             , 0                                      AS QTY005
             , 0                                      AS QTY006
             , 0                                      AS QTY007
             , 0                                      AS QTY008
             , 0                                      AS QTY009
             , 0                                      AS QTY010
             , 0                                      AS QTY011
             , 0                                      AS QTY012
             , 0                                      AS QTY013
             , 0                                      AS QTY014
             , 0                                      AS QTY015
             , 0                                      AS QTY016
             , 0                                      AS QTY017
             , 0                                      AS QTY018
             , 0                                      AS QTY019
             , 0                                      AS QTY020
             , 0                                      AS QTY021
             , 0                                      AS QTY022
             , 0                                      AS QTY023
             , 0                                      AS QTY024
             , 0                                      AS QTY025
             , 0                                      AS QTY026
             , 0                                      AS QTY027
             , 0                                      AS QTY028
             , 0                                      AS QTY029
             , 0                                      AS QTY030
             , 0                                      AS QTY031
             , 0                                      AS QTY032
             , 0                                      AS QTY033
             , 0                                      AS QTY034
             , 0                                      AS QTY035
             , 0                                      AS QTY036
             , 0                                      AS QTY037
             , 0                                      AS QTY038
             , 0                                      AS QTY039
             , 0                                      AS QTY040
             , 0                                      AS QTY041
             , 0                                      AS QTY042
             , 0                                      AS QTY043
             , 0                                      AS QTY044
             , 0                                      AS QTY045
             , 0                                      AS QTY046
             , 0                                      AS QTY047
             , 0                                      AS QTY048
             , 0                                      AS QTY049
             , 0                                      AS QTY050
             , 0                                      AS QTY051
             , 0                                      AS QTY052
             , 0                                      AS QTY053
             , 0                                      AS QTY054
             , 0                                      AS QTY055
             , 0                                      AS QTY056
             , 0                                      AS QTY057
             , 0                                      AS QTY058
             , 0                                      AS QTY059
             , 0                                      AS QTY060
             , 0                                      AS QTY061
             , 0                                      AS QTY062
             , 0                                      AS QTY063
             , 0                                      AS QTY064
             , 0                                      AS QTY065
             , 0                                      AS QTY066
             , 0                                      AS QTY067
             , 0                                      AS QTY068
             , 0                                      AS QTY069
             , 0                                      AS QTY070
             , 0                                      AS QTY071
             , 0                                      AS QTY072
             , 0                                      AS QTY073
             , 0                                      AS QTY074
             , 0                                      AS QTY075
             , 0                                      AS QTY076
             , 0                                      AS QTY077
             , 0                                      AS QTY078
             , 0                                      AS QTY079
             , 0                                      AS QTY080
             , 0                                      AS QTY081
             , 0                                      AS QTY082
             , 0                                      AS QTY083
             , 0                                      AS QTY084
             , 0                                      AS QTY085
             , 0                                      AS QTY086
             , 0                                      AS QTY087
             , 0                                      AS QTY088
             , 0                                      AS QTY089
             , 0                                      AS QTY090
             , 0                                      AS QTY091
             , 0                                      AS QTY092
             , 0                                      AS QTY093
             , 0                                      AS QTY094
             , 0                                      AS QTY095
             , 0                                      AS QTY096
             , 0                                      AS QTY097
             , 0                                      AS QTY098
             , 0                                      AS QTY099
             , 0                                      AS QTY100
             , 0                                      AS QTY101
             , 0                                      AS QTY102
             , 0                                      AS QTY103
             , 0                                      AS QTY104
             , 0                                      AS QTY105
             , 0                                      AS QTY106
             , 0                                      AS QTY107
             , 0                                      AS QTY108
             , 0                                      AS QTY109
             , 0                                      AS QTY110
             , 0                                      AS QTY111
             , 0                                      AS QTY112
             , 0                                      AS QTY113
             , 0                                      AS QTY114
             , 0                                      AS QTY115
             , 0                                      AS QTY116
             , 0                                      AS QTY117
             , 0                                      AS QTY118
             , 0                                      AS QTY119
             , 0                                      AS QTY120
             , 0                                      AS QTY121
             , 0                                      AS QTY122
             , 0                                      AS QTY123
             , 0                                      AS QTY124
             , 0                                      AS QTY125
             , 0                                      AS QTY126
             , 0                                      AS QTY127
             , 0                                      AS QTY128
             , 0                                      AS QTY129
             , 0                                      AS QTY130
             , 0                                      AS QTY131
             , 0                                      AS QTY132
             , 0                                      AS QTY133
             , 0                                      AS QTY134
             , 0                                      AS QTY135
             , 0                                      AS QTY136
             , 0                                      AS QTY137
             , 0                                      AS QTY138
             , 0                                      AS QTY139
             , 0                                      AS QTY140
             , 0                                      AS QTY141
             , 0                                      AS QTY142
             , 0                                      AS QTY143
             , 0                                      AS QTY144
             , 0                                      AS QTY145
             , 0                                      AS QTY146
             , 0                                      AS QTY147
             , 0                                      AS QTY148
             , 0                                      AS QTY149
             , 0                                      AS QTY150
             , 0                                      AS QTY151
             , 0                                      AS QTY152
             , 0                                      AS QTY153
             , 0                                      AS QTY154
             , 0                                      AS QTY155
             , 0                                      AS QTY156
             , 0                                      AS QTY157
             , 0                                      AS QTY158
             , 0                                      AS QTY159
             , 0                                      AS QTY160
             , 0                                      AS QTY161
             , 0                                      AS QTY162
             , 0                                      AS QTY163
             , 0                                      AS QTY164
             , 0                                      AS QTY165
             , 0                                      AS QTY166
             , 0                                      AS QTY167
             , 0                                      AS QTY168
             , 0                                      AS QTY169
             , 0                                      AS QTY170
             , 0                                      AS QTY171
             , 0                                      AS QTY172
             , 0                                      AS QTY173
             , 0                                      AS QTY174
             , 0                                      AS QTY175
             , 0                                      AS QTY176
             , 0                                      AS QTY177
             , 0                                      AS QTY178
             , 0                                      AS QTY179
             , 0                                      AS QTY180
             , 0                                      AS QTY181
             , 0                                      AS QTY182
             , 0                                      AS QTY183
             , 0                                      AS QTY184
             , 0                                      AS QTY185
             , 0                                      AS QTY186
             , 0                                      AS QTY187
             , 0                                      AS QTY188
             , 0                                      AS QTY189
             , 0                                      AS QTY190
             , 0                                      AS QTY191
             , 0                                      AS QTY192
             , 0                                      AS QTY193
             , 0                                      AS QTY194
             , 0                                      AS QTY195
             , 0                                      AS QTY196
             , 0                                      AS QTY197
             , 0                                      AS QTY198
             , 0                                      AS QTY199
             , 0                                      AS QTY200
             , 0                                      AS QTY201
             , 0                                      AS QTY202
             , 0                                      AS QTY203
             , 0                                      AS QTY204
             , 0                                      AS QTY205
             , 0                                      AS QTY206
             , 0                                      AS QTY207
             , 0                                      AS QTY208
             , 0                                      AS QTY209
             , 0                                      AS QTY210
             , 0                                      AS QTY211
             , 0                                      AS QTY212
             , 0                                      AS QTY213
             , 0                                      AS QTY214
             , 0                                      AS QTY215
             , 0                                      AS QTY216
             , 0                                      AS QTY217
             , 0                                      AS QTY218
             , 0                                      AS QTY219
             , 0                                      AS QTY220
             , 0                                      AS QTY221
             , 0                                      AS QTY222
             , 0                                      AS QTY223
             , 0                                      AS QTY224
             , 0                                      AS QTY225
             , 0                                      AS QTY226
             , 0                                      AS QTY227
             , 0                                      AS QTY228
             , 0                                      AS QTY229
             , 0                                      AS QTY230
             , 0                                      AS QTY231
             , 0                                      AS QTY232
             , 0                                      AS QTY233
             , 0                                      AS QTY234
             , 0                                      AS QTY235
             , 0                                      AS QTY236
             , 0                                      AS QTY237
             , 0                                      AS QTY238
             , 0                                      AS QTY239
             , 0                                      AS QTY240
             , 0                                      AS QTY241
             , 0                                      AS QTY242
             , 0                                      AS QTY243
             , 0                                      AS QTY244
             , 0                                      AS QTY245
             , 0                                      AS QTY246
             , 0                                      AS QTY247
             , 0                                      AS QTY248
             , 0                                      AS QTY249
             , 0                                      AS QTY250
             , 0                                      AS QTY251
             , 0                                      AS QTY252
             , 0                                      AS QTY253
             , 0                                      AS QTY254
             , 0                                      AS QTY255
             , 0                                      AS QTY256
             , 0                                      AS QTY257
             , 0                                      AS QTY258
             , 0                                      AS QTY259
             , 0                                      AS QTY260
             , 0                                      AS QTY261
             , 0                                      AS QTY262
             , 0                                      AS QTY263
             , 0                                      AS QTY264
             , 0                                      AS QTY265
             , 0                                      AS QTY266
             , 0                                      AS QTY267
             , 0                                      AS QTY268
             , 0                                      AS QTY269
             , 0                                      AS QTY270
             , 0                                      AS QTY271
             , 0                                      AS QTY272
             , 0                                      AS QTY273
             , 0                                      AS QTY274
             , 0                                      AS QTY275
             , 0                                      AS QTY276
             , 0                                      AS QTY277
             , 0                                      AS QTY278
             , 0                                      AS QTY279
             , 0                                      AS QTY280
             , 0                                      AS QTY281
             , 0                                      AS QTY282
             , 0                                      AS QTY283
             , 0                                      AS QTY284
             , 0                                      AS QTY285
             , 0                                      AS QTY286
             , 0                                      AS QTY287
             , 0                                      AS QTY288
             , 0                                      AS QTY289
             , 0                                      AS QTY290
             , 0                                      AS QTY291
             , 0                                      AS QTY292
             , 0                                      AS QTY293
             , 0                                      AS QTY294
             , 0                                      AS QTY295
             , 0                                      AS QTY296
             , 0                                      AS QTY297
             , 0                                      AS QTY298
             , 0                                      AS QTY299
             , 0                                      AS QTY300
             , 0                                      AS QTY301
             , 0                                      AS QTY302
             , 0                                      AS QTY303
             , 0                                      AS QTY304
             , 0                                      AS QTY305
             , 0                                      AS QTY306
             , 0                                      AS QTY307
             , 0                                      AS QTY308
             , 0                                      AS QTY309
             , 0                                      AS QTY310
             , 0                                      AS QTY311
             , 0                                      AS QTY312
             , 0                                      AS QTY313
             , 0                                      AS QTY314
             , 0                                      AS QTY315
             , 0                                      AS QTY316
             , 0                                      AS QTY317
             , 0                                      AS QTY318
             , 0                                      AS QTY319
             , 0                                      AS QTY320
             , 0                                      AS QTY321
             , 0                                      AS QTY322
             , 0                                      AS QTY323
             , 0                                      AS QTY324
             , 0                                      AS QTY325
             , 0                                      AS QTY326
             , 0                                      AS QTY327
             , 0                                      AS QTY328
             , 0                                      AS QTY329
             , 0                                      AS QTY330
             , 0                                      AS QTY331
             , 0                                      AS QTY332
             , 0                                      AS QTY333
             , 0                                      AS QTY334
             , 0                                      AS QTY335
             , 0                                      AS QTY336
             , 0                                      AS QTY337
             , 0                                      AS QTY338
             , 0                                      AS QTY339
             , 0                                      AS QTY340
             , 0                                      AS QTY341
             , 0                                      AS QTY342
             , 0                                      AS QTY343
             , 0                                      AS QTY344
             , 0                                      AS QTY345
             , 0                                      AS QTY346
             , 0                                      AS QTY347
             , 0                                      AS QTY348
             , 0                                      AS QTY349
             , 0                                      AS QTY350
             , 0                                      AS QTY351
             , 0                                      AS QTY352
             , 0                                      AS QTY353
             , 0                                      AS QTY354
             , 0                                      AS QTY355
             , 0                                      AS QTY356
             , 0                                      AS QTY357
             , 0                                      AS QTY358
             , 0                                      AS QTY359
             , 0                                      AS QTY360
             , 0                                      AS QTY361
             , 0                                      AS QTY362
             , 0                                      AS QTY363
             , 0                                      AS QTY364
               /* --,X.CREATED_BY */
               /* --,X.CREATION_DATE */
               /* --,X.LAST_UPDATED_BY */
               /* --,X.LAST_UPDATE_DATE */
             , (CASE WHEN M.COLUMN_NAME = 'MKT_FCST_CELL_TOTAL' THEN 'MKT_FCST_CELL_TOTAL' ELSE 'DIO' END) AS ATTRIBUTE1
             , X.ATTRIBUTE2
             , X.ATTRIBUTE3
             , X.ATTRIBUTE4
             , X.ATTRIBUTE5
             , X.ATTRIBUTE6
             , X.ATTRIBUTE7
             , X.ATTRIBUTE8
             , NULL                     AS ATTRIBUTE9
             , X.ATTRIBUTE10
          FROM GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO X
             , GT_XPGS_MEASURE                       M  /* CROSS APPLY */
         WHERE 1 = 1
           AND M.GUBUN           = 'CELL_ITEM_ID'
           AND M.COLUMN_NAME     = 'MKT_FCST_CELL_TOTAL'
           AND X.OPERATION_GROUP = 'A'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 008 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* DIO 계산용 MEASURE 추가(MKT_FCST_TOTAL,ALLOCATION_TOTAL,EOH_TOTAL,MKT_FCST_DIO,ALLOCATION_DIO) */
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001
             , QTY002
             , QTY003
             , QTY004
             , QTY005
             , QTY006
             , QTY007
             , QTY008
             , QTY009
             , QTY010
             , QTY011
             , QTY012
             , QTY013
             , QTY014
             , QTY015
             , QTY016
             , QTY017
             , QTY018
             , QTY019
             , QTY020
             , QTY021
             , QTY022
             , QTY023
             , QTY024
             , QTY025
             , QTY026
             , QTY027
             , QTY028
             , QTY029
             , QTY030
             , QTY031
             , QTY032
             , QTY033
             , QTY034
             , QTY035
             , QTY036
             , QTY037
             , QTY038
             , QTY039
             , QTY040
             , QTY041
             , QTY042
             , QTY043
             , QTY044
             , QTY045
             , QTY046
             , QTY047
             , QTY048
             , QTY049
             , QTY050
             , QTY051
             , QTY052
             , QTY053
             , QTY054
             , QTY055
             , QTY056
             , QTY057
             , QTY058
             , QTY059
             , QTY060
             , QTY061
             , QTY062
             , QTY063
             , QTY064
             , QTY065
             , QTY066
             , QTY067
             , QTY068
             , QTY069
             , QTY070
             , QTY071
             , QTY072
             , QTY073
             , QTY074
             , QTY075
             , QTY076
             , QTY077
             , QTY078
             , QTY079
             , QTY080
             , QTY081
             , QTY082
             , QTY083
             , QTY084
             , QTY085
             , QTY086
             , QTY087
             , QTY088
             , QTY089
             , QTY090
             , QTY091
             , QTY092
             , QTY093
             , QTY094
             , QTY095
             , QTY096
             , QTY097
             , QTY098
             , QTY099
             , QTY100
             , QTY101
             , QTY102
             , QTY103
             , QTY104
             , QTY105
             , QTY106
             , QTY107
             , QTY108
             , QTY109
             , QTY110
             , QTY111
             , QTY112
             , QTY113
             , QTY114
             , QTY115
             , QTY116
             , QTY117
             , QTY118
             , QTY119
             , QTY120
             , QTY121
             , QTY122
             , QTY123
             , QTY124
             , QTY125
             , QTY126
             , QTY127
             , QTY128
             , QTY129
             , QTY130
             , QTY131
             , QTY132
             , QTY133
             , QTY134
             , QTY135
             , QTY136
             , QTY137
             , QTY138
             , QTY139
             , QTY140
             , QTY141
             , QTY142
             , QTY143
             , QTY144
             , QTY145
             , QTY146
             , QTY147
             , QTY148
             , QTY149
             , QTY150
             , QTY151
             , QTY152
             , QTY153
             , QTY154
             , QTY155
             , QTY156
             , QTY157
             , QTY158
             , QTY159
             , QTY160
             , QTY161
             , QTY162
             , QTY163
             , QTY164
             , QTY165
             , QTY166
             , QTY167
             , QTY168
             , QTY169
             , QTY170
             , QTY171
             , QTY172
             , QTY173
             , QTY174
             , QTY175
             , QTY176
             , QTY177
             , QTY178
             , QTY179
             , QTY180
             , QTY181
             , QTY182
             , QTY183
             , QTY184
             , QTY185
             , QTY186
             , QTY187
             , QTY188
             , QTY189
             , QTY190
             , QTY191
             , QTY192
             , QTY193
             , QTY194
             , QTY195
             , QTY196
             , QTY197
             , QTY198
             , QTY199
             , QTY200
             , QTY201
             , QTY202
             , QTY203
             , QTY204
             , QTY205
             , QTY206
             , QTY207
             , QTY208
             , QTY209
             , QTY210
             , QTY211
             , QTY212
             , QTY213
             , QTY214
             , QTY215
             , QTY216
             , QTY217
             , QTY218
             , QTY219
             , QTY220
             , QTY221
             , QTY222
             , QTY223
             , QTY224
             , QTY225
             , QTY226
             , QTY227
             , QTY228
             , QTY229
             , QTY230
             , QTY231
             , QTY232
             , QTY233
             , QTY234
             , QTY235
             , QTY236
             , QTY237
             , QTY238
             , QTY239
             , QTY240
             , QTY241
             , QTY242
             , QTY243
             , QTY244
             , QTY245
             , QTY246
             , QTY247
             , QTY248
             , QTY249
             , QTY250
             , QTY251
             , QTY252
             , QTY253
             , QTY254
             , QTY255
             , QTY256
             , QTY257
             , QTY258
             , QTY259
             , QTY260
             , QTY261
             , QTY262
             , QTY263
             , QTY264
             , QTY265
             , QTY266
             , QTY267
             , QTY268
             , QTY269
             , QTY270
             , QTY271
             , QTY272
             , QTY273
             , QTY274
             , QTY275
             , QTY276
             , QTY277
             , QTY278
             , QTY279
             , QTY280
             , QTY281
             , QTY282
             , QTY283
             , QTY284
             , QTY285
             , QTY286
             , QTY287
             , QTY288
             , QTY289
             , QTY290
             , QTY291
             , QTY292
             , QTY293
             , QTY294
             , QTY295
             , QTY296
             , QTY297
             , QTY298
             , QTY299
             , QTY300
             , QTY301
             , QTY302
             , QTY303
             , QTY304
             , QTY305
             , QTY306
             , QTY307
             , QTY308
             , QTY309
             , QTY310
             , QTY311
             , QTY312
             , QTY313
             , QTY314
             , QTY315
             , QTY316
             , QTY317
             , QTY318
             , QTY319
             , QTY320
             , QTY321
             , QTY322
             , QTY323
             , QTY324
             , QTY325
             , QTY326
             , QTY327
             , QTY328
             , QTY329
             , QTY330
             , QTY331
             , QTY332
             , QTY333
             , QTY334
             , QTY335
             , QTY336
             , QTY337
             , QTY338
             , QTY339
             , QTY340
             , QTY341
             , QTY342
             , QTY343
             , QTY344
             , QTY345
             , QTY346
             , QTY347
             , QTY348
             , QTY349
             , QTY350
             , QTY351
             , QTY352
             , QTY353
             , QTY354
             , QTY355
             , QTY356
             , QTY357
             , QTY358
             , QTY359
             , QTY360
             , QTY361
             , QTY362
             , QTY363
             , QTY364
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT DISTINCT
               X.DIVISION_ID
             , X.PLAN_START_YYYYMMDD
             , X.PLAN_TYPE
             , X.SEQ
             , 'A'                      AS OPERATION_GROUP
             , 'CELL'                   AS OPERATION_GROUP_NAME
             , X.CELL_ITEM_ID
             , '-'                      AS ITEM_ID
             , '-'                      AS NICK_NAME
             , 0                        AS CELL_QTY_PACK
             , '-'                      AS TO_SITE
             , '-'                      AS TO_SITE_DESCRIPTION
             , '-'                      AS PROJECT_CODE
             , 0                        AS FROM_BOH_QTY
             , 0                        AS TO_BOH_QTY
             , '-'                      AS INCOTERMS
             , '-'                      AS FROM_SITE
             , '-'                      AS FROM_SITE_DESCRIPTION
             , '-'                      AS TRANSPORT_MODE
             , '-'                      AS PROD_LINE
             , 0                        AS LT_DAY  /* AS-IS '-' AS LT_DAY → INT 칸 적재 시 0 */
             , '-'                      AS BOD_ID
             , M.COLUMN_NAME            AS MEASURE
             , M.COLUMN_LABEL_NAME      AS MEASURE_LABEL
             , X.XLS_KEY1
             , X.XLS_KEY2
             , X.XLS_KEY3
             , X.XLS_KEY4
             , X.XLS_KEY5
             , X.XLS_ATTRIBUTE1
             , X.XLS_ATTRIBUTE2
             , X.XLS_ATTRIBUTE3
             , X.XLS_ATTRIBUTE4
             , X.XLS_ATTRIBUTE5
             , M.SORT_ORDER_NO
             , 0                                      AS QTY001
             , 0                                      AS QTY002
             , 0                                      AS QTY003
             , 0                                      AS QTY004
             , 0                                      AS QTY005
             , 0                                      AS QTY006
             , 0                                      AS QTY007
             , 0                                      AS QTY008
             , 0                                      AS QTY009
             , 0                                      AS QTY010
             , 0                                      AS QTY011
             , 0                                      AS QTY012
             , 0                                      AS QTY013
             , 0                                      AS QTY014
             , 0                                      AS QTY015
             , 0                                      AS QTY016
             , 0                                      AS QTY017
             , 0                                      AS QTY018
             , 0                                      AS QTY019
             , 0                                      AS QTY020
             , 0                                      AS QTY021
             , 0                                      AS QTY022
             , 0                                      AS QTY023
             , 0                                      AS QTY024
             , 0                                      AS QTY025
             , 0                                      AS QTY026
             , 0                                      AS QTY027
             , 0                                      AS QTY028
             , 0                                      AS QTY029
             , 0                                      AS QTY030
             , 0                                      AS QTY031
             , 0                                      AS QTY032
             , 0                                      AS QTY033
             , 0                                      AS QTY034
             , 0                                      AS QTY035
             , 0                                      AS QTY036
             , 0                                      AS QTY037
             , 0                                      AS QTY038
             , 0                                      AS QTY039
             , 0                                      AS QTY040
             , 0                                      AS QTY041
             , 0                                      AS QTY042
             , 0                                      AS QTY043
             , 0                                      AS QTY044
             , 0                                      AS QTY045
             , 0                                      AS QTY046
             , 0                                      AS QTY047
             , 0                                      AS QTY048
             , 0                                      AS QTY049
             , 0                                      AS QTY050
             , 0                                      AS QTY051
             , 0                                      AS QTY052
             , 0                                      AS QTY053
             , 0                                      AS QTY054
             , 0                                      AS QTY055
             , 0                                      AS QTY056
             , 0                                      AS QTY057
             , 0                                      AS QTY058
             , 0                                      AS QTY059
             , 0                                      AS QTY060
             , 0                                      AS QTY061
             , 0                                      AS QTY062
             , 0                                      AS QTY063
             , 0                                      AS QTY064
             , 0                                      AS QTY065
             , 0                                      AS QTY066
             , 0                                      AS QTY067
             , 0                                      AS QTY068
             , 0                                      AS QTY069
             , 0                                      AS QTY070
             , 0                                      AS QTY071
             , 0                                      AS QTY072
             , 0                                      AS QTY073
             , 0                                      AS QTY074
             , 0                                      AS QTY075
             , 0                                      AS QTY076
             , 0                                      AS QTY077
             , 0                                      AS QTY078
             , 0                                      AS QTY079
             , 0                                      AS QTY080
             , 0                                      AS QTY081
             , 0                                      AS QTY082
             , 0                                      AS QTY083
             , 0                                      AS QTY084
             , 0                                      AS QTY085
             , 0                                      AS QTY086
             , 0                                      AS QTY087
             , 0                                      AS QTY088
             , 0                                      AS QTY089
             , 0                                      AS QTY090
             , 0                                      AS QTY091
             , 0                                      AS QTY092
             , 0                                      AS QTY093
             , 0                                      AS QTY094
             , 0                                      AS QTY095
             , 0                                      AS QTY096
             , 0                                      AS QTY097
             , 0                                      AS QTY098
             , 0                                      AS QTY099
             , 0                                      AS QTY100
             , 0                                      AS QTY101
             , 0                                      AS QTY102
             , 0                                      AS QTY103
             , 0                                      AS QTY104
             , 0                                      AS QTY105
             , 0                                      AS QTY106
             , 0                                      AS QTY107
             , 0                                      AS QTY108
             , 0                                      AS QTY109
             , 0                                      AS QTY110
             , 0                                      AS QTY111
             , 0                                      AS QTY112
             , 0                                      AS QTY113
             , 0                                      AS QTY114
             , 0                                      AS QTY115
             , 0                                      AS QTY116
             , 0                                      AS QTY117
             , 0                                      AS QTY118
             , 0                                      AS QTY119
             , 0                                      AS QTY120
             , 0                                      AS QTY121
             , 0                                      AS QTY122
             , 0                                      AS QTY123
             , 0                                      AS QTY124
             , 0                                      AS QTY125
             , 0                                      AS QTY126
             , 0                                      AS QTY127
             , 0                                      AS QTY128
             , 0                                      AS QTY129
             , 0                                      AS QTY130
             , 0                                      AS QTY131
             , 0                                      AS QTY132
             , 0                                      AS QTY133
             , 0                                      AS QTY134
             , 0                                      AS QTY135
             , 0                                      AS QTY136
             , 0                                      AS QTY137
             , 0                                      AS QTY138
             , 0                                      AS QTY139
             , 0                                      AS QTY140
             , 0                                      AS QTY141
             , 0                                      AS QTY142
             , 0                                      AS QTY143
             , 0                                      AS QTY144
             , 0                                      AS QTY145
             , 0                                      AS QTY146
             , 0                                      AS QTY147
             , 0                                      AS QTY148
             , 0                                      AS QTY149
             , 0                                      AS QTY150
             , 0                                      AS QTY151
             , 0                                      AS QTY152
             , 0                                      AS QTY153
             , 0                                      AS QTY154
             , 0                                      AS QTY155
             , 0                                      AS QTY156
             , 0                                      AS QTY157
             , 0                                      AS QTY158
             , 0                                      AS QTY159
             , 0                                      AS QTY160
             , 0                                      AS QTY161
             , 0                                      AS QTY162
             , 0                                      AS QTY163
             , 0                                      AS QTY164
             , 0                                      AS QTY165
             , 0                                      AS QTY166
             , 0                                      AS QTY167
             , 0                                      AS QTY168
             , 0                                      AS QTY169
             , 0                                      AS QTY170
             , 0                                      AS QTY171
             , 0                                      AS QTY172
             , 0                                      AS QTY173
             , 0                                      AS QTY174
             , 0                                      AS QTY175
             , 0                                      AS QTY176
             , 0                                      AS QTY177
             , 0                                      AS QTY178
             , 0                                      AS QTY179
             , 0                                      AS QTY180
             , 0                                      AS QTY181
             , 0                                      AS QTY182
             , 0                                      AS QTY183
             , 0                                      AS QTY184
             , 0                                      AS QTY185
             , 0                                      AS QTY186
             , 0                                      AS QTY187
             , 0                                      AS QTY188
             , 0                                      AS QTY189
             , 0                                      AS QTY190
             , 0                                      AS QTY191
             , 0                                      AS QTY192
             , 0                                      AS QTY193
             , 0                                      AS QTY194
             , 0                                      AS QTY195
             , 0                                      AS QTY196
             , 0                                      AS QTY197
             , 0                                      AS QTY198
             , 0                                      AS QTY199
             , 0                                      AS QTY200
             , 0                                      AS QTY201
             , 0                                      AS QTY202
             , 0                                      AS QTY203
             , 0                                      AS QTY204
             , 0                                      AS QTY205
             , 0                                      AS QTY206
             , 0                                      AS QTY207
             , 0                                      AS QTY208
             , 0                                      AS QTY209
             , 0                                      AS QTY210
             , 0                                      AS QTY211
             , 0                                      AS QTY212
             , 0                                      AS QTY213
             , 0                                      AS QTY214
             , 0                                      AS QTY215
             , 0                                      AS QTY216
             , 0                                      AS QTY217
             , 0                                      AS QTY218
             , 0                                      AS QTY219
             , 0                                      AS QTY220
             , 0                                      AS QTY221
             , 0                                      AS QTY222
             , 0                                      AS QTY223
             , 0                                      AS QTY224
             , 0                                      AS QTY225
             , 0                                      AS QTY226
             , 0                                      AS QTY227
             , 0                                      AS QTY228
             , 0                                      AS QTY229
             , 0                                      AS QTY230
             , 0                                      AS QTY231
             , 0                                      AS QTY232
             , 0                                      AS QTY233
             , 0                                      AS QTY234
             , 0                                      AS QTY235
             , 0                                      AS QTY236
             , 0                                      AS QTY237
             , 0                                      AS QTY238
             , 0                                      AS QTY239
             , 0                                      AS QTY240
             , 0                                      AS QTY241
             , 0                                      AS QTY242
             , 0                                      AS QTY243
             , 0                                      AS QTY244
             , 0                                      AS QTY245
             , 0                                      AS QTY246
             , 0                                      AS QTY247
             , 0                                      AS QTY248
             , 0                                      AS QTY249
             , 0                                      AS QTY250
             , 0                                      AS QTY251
             , 0                                      AS QTY252
             , 0                                      AS QTY253
             , 0                                      AS QTY254
             , 0                                      AS QTY255
             , 0                                      AS QTY256
             , 0                                      AS QTY257
             , 0                                      AS QTY258
             , 0                                      AS QTY259
             , 0                                      AS QTY260
             , 0                                      AS QTY261
             , 0                                      AS QTY262
             , 0                                      AS QTY263
             , 0                                      AS QTY264
             , 0                                      AS QTY265
             , 0                                      AS QTY266
             , 0                                      AS QTY267
             , 0                                      AS QTY268
             , 0                                      AS QTY269
             , 0                                      AS QTY270
             , 0                                      AS QTY271
             , 0                                      AS QTY272
             , 0                                      AS QTY273
             , 0                                      AS QTY274
             , 0                                      AS QTY275
             , 0                                      AS QTY276
             , 0                                      AS QTY277
             , 0                                      AS QTY278
             , 0                                      AS QTY279
             , 0                                      AS QTY280
             , 0                                      AS QTY281
             , 0                                      AS QTY282
             , 0                                      AS QTY283
             , 0                                      AS QTY284
             , 0                                      AS QTY285
             , 0                                      AS QTY286
             , 0                                      AS QTY287
             , 0                                      AS QTY288
             , 0                                      AS QTY289
             , 0                                      AS QTY290
             , 0                                      AS QTY291
             , 0                                      AS QTY292
             , 0                                      AS QTY293
             , 0                                      AS QTY294
             , 0                                      AS QTY295
             , 0                                      AS QTY296
             , 0                                      AS QTY297
             , 0                                      AS QTY298
             , 0                                      AS QTY299
             , 0                                      AS QTY300
             , 0                                      AS QTY301
             , 0                                      AS QTY302
             , 0                                      AS QTY303
             , 0                                      AS QTY304
             , 0                                      AS QTY305
             , 0                                      AS QTY306
             , 0                                      AS QTY307
             , 0                                      AS QTY308
             , 0                                      AS QTY309
             , 0                                      AS QTY310
             , 0                                      AS QTY311
             , 0                                      AS QTY312
             , 0                                      AS QTY313
             , 0                                      AS QTY314
             , 0                                      AS QTY315
             , 0                                      AS QTY316
             , 0                                      AS QTY317
             , 0                                      AS QTY318
             , 0                                      AS QTY319
             , 0                                      AS QTY320
             , 0                                      AS QTY321
             , 0                                      AS QTY322
             , 0                                      AS QTY323
             , 0                                      AS QTY324
             , 0                                      AS QTY325
             , 0                                      AS QTY326
             , 0                                      AS QTY327
             , 0                                      AS QTY328
             , 0                                      AS QTY329
             , 0                                      AS QTY330
             , 0                                      AS QTY331
             , 0                                      AS QTY332
             , 0                                      AS QTY333
             , 0                                      AS QTY334
             , 0                                      AS QTY335
             , 0                                      AS QTY336
             , 0                                      AS QTY337
             , 0                                      AS QTY338
             , 0                                      AS QTY339
             , 0                                      AS QTY340
             , 0                                      AS QTY341
             , 0                                      AS QTY342
             , 0                                      AS QTY343
             , 0                                      AS QTY344
             , 0                                      AS QTY345
             , 0                                      AS QTY346
             , 0                                      AS QTY347
             , 0                                      AS QTY348
             , 0                                      AS QTY349
             , 0                                      AS QTY350
             , 0                                      AS QTY351
             , 0                                      AS QTY352
             , 0                                      AS QTY353
             , 0                                      AS QTY354
             , 0                                      AS QTY355
             , 0                                      AS QTY356
             , 0                                      AS QTY357
             , 0                                      AS QTY358
             , 0                                      AS QTY359
             , 0                                      AS QTY360
             , 0                                      AS QTY361
             , 0                                      AS QTY362
             , 0                                      AS QTY363
             , 0                                      AS QTY364
               /* --,X.CREATED_BY */
               /* --,X.CREATION_DATE */
               /* --,X.LAST_UPDATED_BY */
               /* --,X.LAST_UPDATE_DATE */
             , (CASE WHEN M.COLUMN_NAME = 'MKT_FCST_CELL_TOTAL' THEN 'MKT_FCST_CELL_TOTAL' ELSE 'DIO' END) AS ATTRIBUTE1
             , X.ATTRIBUTE2
             , X.ATTRIBUTE3
             , X.ATTRIBUTE4
             , X.ATTRIBUTE5
             , X.ATTRIBUTE6
             , X.ATTRIBUTE7
             , X.ATTRIBUTE8
             , NULL                     AS ATTRIBUTE9
             , X.ATTRIBUTE10
          FROM GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO X
             , GT_XPGS_MEASURE                       M  /* CROSS APPLY */
         WHERE 1 = 1
           AND M.GUBUN        = 'CELL_ITEM_ID'
           AND M.COLUMN_NAME <> 'MKT_FCST_CELL_TOTAL'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 009 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 보정 */
        /* ------------------------------------------------------------------------------------------------------------- */
        UPDATE GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO
           SET LT_DAY         = 0
         WHERE TRANSPORT_MODE = '-'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 010 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 삭제 후 입력 */
        /* ------------------------------------------------------------------------------------------------------------- */

        /* --DELETE FROM SCP_XLS_PSI_GLOBAL_SMALL */
        /* --  WHERE DIVISION_ID = @p_division_id  -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq */

        /* IF OBJECT_ID('TEMPDB..#GLOBAL_XLS_KEY') IS NOT NULL DROP TABLE #GLOBAL_XLS_KEY
           #GLOBAL_XLS_KEY 는 만든 뒤 SCP_XLS_PSI_GLOBAL_SMALL 적재 한 번에만 쓰여(디버그 조회 제외) 바로 적재로 옮김 */
        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 011 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* IF @P_IS_DEBUG = 1 SELECT '#GLOBAL_XLS_KEY' TN, * FROM #GLOBAL_XLS_KEY : 디버그 결과 집합 없음 */

        INSERT /* WITH (TABLOCK) */
          INTO SCP_XLS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , CREATE_FROM_YYYYMMDD
             , CREATE_TO_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001
             , QTY002
             , QTY003
             , QTY004
             , QTY005
             , QTY006
             , QTY007
             , QTY008
             , QTY009
             , QTY010
             , QTY011
             , QTY012
             , QTY013
             , QTY014
             , QTY015
             , QTY016
             , QTY017
             , QTY018
             , QTY019
             , QTY020
             , QTY021
             , QTY022
             , QTY023
             , QTY024
             , QTY025
             , QTY026
             , QTY027
             , QTY028
             , QTY029
             , QTY030
             , QTY031
             , QTY032
             , QTY033
             , QTY034
             , QTY035
             , QTY036
             , QTY037
             , QTY038
             , QTY039
             , QTY040
             , QTY041
             , QTY042
             , QTY043
             , QTY044
             , QTY045
             , QTY046
             , QTY047
             , QTY048
             , QTY049
             , QTY050
             , QTY051
             , QTY052
             , QTY053
             , QTY054
             , QTY055
             , QTY056
             , QTY057
             , QTY058
             , QTY059
             , QTY060
             , QTY061
             , QTY062
             , QTY063
             , QTY064
             , QTY065
             , QTY066
             , QTY067
             , QTY068
             , QTY069
             , QTY070
             , QTY071
             , QTY072
             , QTY073
             , QTY074
             , QTY075
             , QTY076
             , QTY077
             , QTY078
             , QTY079
             , QTY080
             , QTY081
             , QTY082
             , QTY083
             , QTY084
             , QTY085
             , QTY086
             , QTY087
             , QTY088
             , QTY089
             , QTY090
             , QTY091
             , QTY092
             , QTY093
             , QTY094
             , QTY095
             , QTY096
             , QTY097
             , QTY098
             , QTY099
             , QTY100
             , QTY101
             , QTY102
             , QTY103
             , QTY104
             , QTY105
             , QTY106
             , QTY107
             , QTY108
             , QTY109
             , QTY110
             , QTY111
             , QTY112
             , QTY113
             , QTY114
             , QTY115
             , QTY116
             , QTY117
             , QTY118
             , QTY119
             , QTY120
             , QTY121
             , QTY122
             , QTY123
             , QTY124
             , QTY125
             , QTY126
             , QTY127
             , QTY128
             , QTY129
             , QTY130
             , QTY131
             , QTY132
             , QTY133
             , QTY134
             , QTY135
             , QTY136
             , QTY137
             , QTY138
             , QTY139
             , QTY140
             , QTY141
             , QTY142
             , QTY143
             , QTY144
             , QTY145
             , QTY146
             , QTY147
             , QTY148
             , QTY149
             , QTY150
             , QTY151
             , QTY152
             , QTY153
             , QTY154
             , QTY155
             , QTY156
             , QTY157
             , QTY158
             , QTY159
             , QTY160
             , QTY161
             , QTY162
             , QTY163
             , QTY164
             , QTY165
             , QTY166
             , QTY167
             , QTY168
             , QTY169
             , QTY170
             , QTY171
             , QTY172
             , QTY173
             , QTY174
             , QTY175
             , QTY176
             , QTY177
             , QTY178
             , QTY179
             , QTY180
             , QTY181
             , QTY182
             , QTY183
             , QTY184
             , QTY185
             , QTY186
             , QTY187
             , QTY188
             , QTY189
             , QTY190
             , QTY191
             , QTY192
             , QTY193
             , QTY194
             , QTY195
             , QTY196
             , QTY197
             , QTY198
             , QTY199
             , QTY200
             , QTY201
             , QTY202
             , QTY203
             , QTY204
             , QTY205
             , QTY206
             , QTY207
             , QTY208
             , QTY209
             , QTY210
             , QTY211
             , QTY212
             , QTY213
             , QTY214
             , QTY215
             , QTY216
             , QTY217
             , QTY218
             , QTY219
             , QTY220
             , QTY221
             , QTY222
             , QTY223
             , QTY224
             , QTY225
             , QTY226
             , QTY227
             , QTY228
             , QTY229
             , QTY230
             , QTY231
             , QTY232
             , QTY233
             , QTY234
             , QTY235
             , QTY236
             , QTY237
             , QTY238
             , QTY239
             , QTY240
             , QTY241
             , QTY242
             , QTY243
             , QTY244
             , QTY245
             , QTY246
             , QTY247
             , QTY248
             , QTY249
             , QTY250
             , QTY251
             , QTY252
             , QTY253
             , QTY254
             , QTY255
             , QTY256
             , QTY257
             , QTY258
             , QTY259
             , QTY260
             , QTY261
             , QTY262
             , QTY263
             , QTY264
             , QTY265
             , QTY266
             , QTY267
             , QTY268
             , QTY269
             , QTY270
             , QTY271
             , QTY272
             , QTY273
             , QTY274
             , QTY275
             , QTY276
             , QTY277
             , QTY278
             , QTY279
             , QTY280
             , QTY281
             , QTY282
             , QTY283
             , QTY284
             , QTY285
             , QTY286
             , QTY287
             , QTY288
             , QTY289
             , QTY290
             , QTY291
             , QTY292
             , QTY293
             , QTY294
             , QTY295
             , QTY296
             , QTY297
             , QTY298
             , QTY299
             , QTY300
             , QTY301
             , QTY302
             , QTY303
             , QTY304
             , QTY305
             , QTY306
             , QTY307
             , QTY308
             , QTY309
             , QTY310
             , QTY311
             , QTY312
             , QTY313
             , QTY314
             , QTY315
             , QTY316
             , QTY317
             , QTY318
             , QTY319
             , QTY320
             , QTY321
             , QTY322
             , QTY323
             , QTY324
             , QTY325
             , QTY326
             , QTY327
             , QTY328
             , QTY329
             , QTY330
             , QTY331
             , QTY332
             , QTY333
             , QTY334
             , QTY335
             , QTY336
             , QTY337
             , QTY338
             , QTY339
             , QTY340
             , QTY341
             , QTY342
             , QTY343
             , QTY344
             , QTY345
             , QTY346
             , QTY347
             , QTY348
             , QTY349
             , QTY350
             , QTY351
             , QTY352
             , QTY353
             , QTY354
             , QTY355
             , QTY356
             , QTY357
             , QTY358
             , QTY359
             , QTY360
             , QTY361
             , QTY362
             , QTY363
             , QTY364
               /* --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25 */
               /* --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50 */
               /* --,WQTY51,WQTY52 */
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT X.DIVISION_ID
             , X.PLAN_START_YYYYMMDD
             , V_CREATE_FROM_YYYYMMDD                                    AS CREATE_FROM_YYYYMMDD
             , V_CREATE_TO_YYYYMMDD                                      AS CREATE_TO_YYYYMMDD
             , X.PLAN_TYPE
             , X.SEQ
             , X.OPERATION_GROUP
             , X.OPERATION_GROUP_NAME
             , X.CELL_ITEM_ID
             , X.ITEM_ID
             , X.NICK_NAME
             , X.CELL_QTY_PACK
             , X.TO_SITE
             , X.TO_SITE_DESCRIPTION
               /* AS-IS LEN(PROJECT_CODE) = 0 : 빈 문자('')는 Oracle 에서 NULL */
             , (CASE WHEN RTRIM(X.PROJECT_CODE) IS NULL THEN '-' ELSE X.PROJECT_CODE END) AS PROJECT_CODE
             , X.FROM_BOH_QTY
             , X.TO_BOH_QTY
             , X.INCOTERMS
             , X.FROM_SITE
             , X.FROM_SITE_DESCRIPTION
             , X.TRANSPORT_MODE
             , X.PROD_LINE
             , X.LT_DAY
             , X.BOD_ID
             , X.MEASURE
             , X.MEASURE_LABEL
               /* AS-IS 정렬 : NULL·빈 문자가 오름차순 맨 앞, 내림차순 맨 뒤 → NULLS FIRST / NULLS LAST 명시 */
             , ROW_NUMBER() OVER(ORDER BY X.DIVISION_ID NULLS FIRST
                                        , X.OPERATION_GROUP DESC NULLS LAST
                                        , X.CELL_ITEM_ID NULLS FIRST
                                          /* 동일한 CELL ITEM ID 인경우 CELL 공정에서는 CP 해당 품목을 위에 표시 */
                                        , (CASE WHEN X.OPERATION_GROUP = 'P' THEN '0'
                                                WHEN X.OPERATION_GROUP = 'A' THEN FN_GET_FINAL_ITEM(X.DIVISION_ID, X.ITEM_ID, 'CELL_SORT')
                                                ELSE '9'
                                           END) NULLS FIRST
                                        , (CASE WHEN X.ATTRIBUTE1 = 'DIO' THEN '-' ELSE X.OPERATION_GROUP END) DESC NULLS LAST
                                        , X.ITEM_ID NULLS FIRST
                                          /* --                                            ,TO_SITE desc */
                                        , (CASE WHEN (X.TO_SITE = '-' AND X.MEASURE = 'MKT_FCST_PACK_TOTAL') THEN 'ZZZ'
                                                WHEN (X.TO_SITE = '-' AND X.MEASURE = 'MKT_FCST_CELL_TOTAL') THEN 'AAA'
                                                ELSE X.TO_SITE
                                           END) DESC NULLS LAST
                                        , X.ITEM_ID NULLS FIRST
                                        , X.INCOTERMS NULLS FIRST
                                        , (CASE WHEN (X.FROM_SITE = '-' AND X.MEASURE LIKE 'CELL%') THEN 'AAA'
                                                ELSE X.FROM_SITE
                                           END) NULLS FIRST
                                        , X.PROJECT_CODE NULLS FIRST
                                        , X.ATTRIBUTE10 NULLS FIRST
                                        , (CASE WHEN X.MEASURE IN ('PACK_CELL_BOH', 'PACK_CELL_EOH') THEN 'ZZZ' ELSE X.PROD_LINE END) NULLS FIRST
                                        , X.SORT_ORDER_NO NULLS FIRST
                                        , X.TRANSPORT_MODE NULLS FIRST
                                        , X.MEASURE_LABEL DESC NULLS LAST
                                ) AS XLS_KEY1
             , X.XLS_KEY2
             , X.XLS_KEY3
             , X.XLS_KEY4
             , X.XLS_KEY5
             , X.XLS_ATTRIBUTE1
             , X.XLS_ATTRIBUTE2
             , X.XLS_ATTRIBUTE3
             , X.XLS_ATTRIBUTE4
             , X.XLS_ATTRIBUTE5
             , X.SORT_ORDER_NO
             , X.QTY001
             , X.QTY002
             , X.QTY003
             , X.QTY004
             , X.QTY005
             , X.QTY006
             , X.QTY007
             , X.QTY008
             , X.QTY009
             , X.QTY010
             , X.QTY011
             , X.QTY012
             , X.QTY013
             , X.QTY014
             , X.QTY015
             , X.QTY016
             , X.QTY017
             , X.QTY018
             , X.QTY019
             , X.QTY020
             , X.QTY021
             , X.QTY022
             , X.QTY023
             , X.QTY024
             , X.QTY025
             , X.QTY026
             , X.QTY027
             , X.QTY028
             , X.QTY029
             , X.QTY030
             , X.QTY031
             , X.QTY032
             , X.QTY033
             , X.QTY034
             , X.QTY035
             , X.QTY036
             , X.QTY037
             , X.QTY038
             , X.QTY039
             , X.QTY040
             , X.QTY041
             , X.QTY042
             , X.QTY043
             , X.QTY044
             , X.QTY045
             , X.QTY046
             , X.QTY047
             , X.QTY048
             , X.QTY049
             , X.QTY050
             , X.QTY051
             , X.QTY052
             , X.QTY053
             , X.QTY054
             , X.QTY055
             , X.QTY056
             , X.QTY057
             , X.QTY058
             , X.QTY059
             , X.QTY060
             , X.QTY061
             , X.QTY062
             , X.QTY063
             , X.QTY064
             , X.QTY065
             , X.QTY066
             , X.QTY067
             , X.QTY068
             , X.QTY069
             , X.QTY070
             , X.QTY071
             , X.QTY072
             , X.QTY073
             , X.QTY074
             , X.QTY075
             , X.QTY076
             , X.QTY077
             , X.QTY078
             , X.QTY079
             , X.QTY080
             , X.QTY081
             , X.QTY082
             , X.QTY083
             , X.QTY084
             , X.QTY085
             , X.QTY086
             , X.QTY087
             , X.QTY088
             , X.QTY089
             , X.QTY090
             , X.QTY091
             , X.QTY092
             , X.QTY093
             , X.QTY094
             , X.QTY095
             , X.QTY096
             , X.QTY097
             , X.QTY098
             , X.QTY099
             , X.QTY100
             , X.QTY101
             , X.QTY102
             , X.QTY103
             , X.QTY104
             , X.QTY105
             , X.QTY106
             , X.QTY107
             , X.QTY108
             , X.QTY109
             , X.QTY110
             , X.QTY111
             , X.QTY112
             , X.QTY113
             , X.QTY114
             , X.QTY115
             , X.QTY116
             , X.QTY117
             , X.QTY118
             , X.QTY119
             , X.QTY120
             , X.QTY121
             , X.QTY122
             , X.QTY123
             , X.QTY124
             , X.QTY125
             , X.QTY126
             , X.QTY127
             , X.QTY128
             , X.QTY129
             , X.QTY130
             , X.QTY131
             , X.QTY132
             , X.QTY133
             , X.QTY134
             , X.QTY135
             , X.QTY136
             , X.QTY137
             , X.QTY138
             , X.QTY139
             , X.QTY140
             , X.QTY141
             , X.QTY142
             , X.QTY143
             , X.QTY144
             , X.QTY145
             , X.QTY146
             , X.QTY147
             , X.QTY148
             , X.QTY149
             , X.QTY150
             , X.QTY151
             , X.QTY152
             , X.QTY153
             , X.QTY154
             , X.QTY155
             , X.QTY156
             , X.QTY157
             , X.QTY158
             , X.QTY159
             , X.QTY160
             , X.QTY161
             , X.QTY162
             , X.QTY163
             , X.QTY164
             , X.QTY165
             , X.QTY166
             , X.QTY167
             , X.QTY168
             , X.QTY169
             , X.QTY170
             , X.QTY171
             , X.QTY172
             , X.QTY173
             , X.QTY174
             , X.QTY175
             , X.QTY176
             , X.QTY177
             , X.QTY178
             , X.QTY179
             , X.QTY180
             , X.QTY181
             , X.QTY182
             , X.QTY183
             , X.QTY184
             , X.QTY185
             , X.QTY186
             , X.QTY187
             , X.QTY188
             , X.QTY189
             , X.QTY190
             , X.QTY191
             , X.QTY192
             , X.QTY193
             , X.QTY194
             , X.QTY195
             , X.QTY196
             , X.QTY197
             , X.QTY198
             , X.QTY199
             , X.QTY200
             , X.QTY201
             , X.QTY202
             , X.QTY203
             , X.QTY204
             , X.QTY205
             , X.QTY206
             , X.QTY207
             , X.QTY208
             , X.QTY209
             , X.QTY210
             , X.QTY211
             , X.QTY212
             , X.QTY213
             , X.QTY214
             , X.QTY215
             , X.QTY216
             , X.QTY217
             , X.QTY218
             , X.QTY219
             , X.QTY220
             , X.QTY221
             , X.QTY222
             , X.QTY223
             , X.QTY224
             , X.QTY225
             , X.QTY226
             , X.QTY227
             , X.QTY228
             , X.QTY229
             , X.QTY230
             , X.QTY231
             , X.QTY232
             , X.QTY233
             , X.QTY234
             , X.QTY235
             , X.QTY236
             , X.QTY237
             , X.QTY238
             , X.QTY239
             , X.QTY240
             , X.QTY241
             , X.QTY242
             , X.QTY243
             , X.QTY244
             , X.QTY245
             , X.QTY246
             , X.QTY247
             , X.QTY248
             , X.QTY249
             , X.QTY250
             , X.QTY251
             , X.QTY252
             , X.QTY253
             , X.QTY254
             , X.QTY255
             , X.QTY256
             , X.QTY257
             , X.QTY258
             , X.QTY259
             , X.QTY260
             , X.QTY261
             , X.QTY262
             , X.QTY263
             , X.QTY264
             , X.QTY265
             , X.QTY266
             , X.QTY267
             , X.QTY268
             , X.QTY269
             , X.QTY270
             , X.QTY271
             , X.QTY272
             , X.QTY273
             , X.QTY274
             , X.QTY275
             , X.QTY276
             , X.QTY277
             , X.QTY278
             , X.QTY279
             , X.QTY280
             , X.QTY281
             , X.QTY282
             , X.QTY283
             , X.QTY284
             , X.QTY285
             , X.QTY286
             , X.QTY287
             , X.QTY288
             , X.QTY289
             , X.QTY290
             , X.QTY291
             , X.QTY292
             , X.QTY293
             , X.QTY294
             , X.QTY295
             , X.QTY296
             , X.QTY297
             , X.QTY298
             , X.QTY299
             , X.QTY300
             , X.QTY301
             , X.QTY302
             , X.QTY303
             , X.QTY304
             , X.QTY305
             , X.QTY306
             , X.QTY307
             , X.QTY308
             , X.QTY309
             , X.QTY310
             , X.QTY311
             , X.QTY312
             , X.QTY313
             , X.QTY314
             , X.QTY315
             , X.QTY316
             , X.QTY317
             , X.QTY318
             , X.QTY319
             , X.QTY320
             , X.QTY321
             , X.QTY322
             , X.QTY323
             , X.QTY324
             , X.QTY325
             , X.QTY326
             , X.QTY327
             , X.QTY328
             , X.QTY329
             , X.QTY330
             , X.QTY331
             , X.QTY332
             , X.QTY333
             , X.QTY334
             , X.QTY335
             , X.QTY336
             , X.QTY337
             , X.QTY338
             , X.QTY339
             , X.QTY340
             , X.QTY341
             , X.QTY342
             , X.QTY343
             , X.QTY344
             , X.QTY345
             , X.QTY346
             , X.QTY347
             , X.QTY348
             , X.QTY349
             , X.QTY350
             , X.QTY351
             , X.QTY352
             , X.QTY353
             , X.QTY354
             , X.QTY355
             , X.QTY356
             , X.QTY357
             , X.QTY358
             , X.QTY359
             , X.QTY360
             , X.QTY361
             , X.QTY362
             , X.QTY363
             , X.QTY364
               /* --,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25 */
               /* --,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50 */
               /* --,WQTY51,WQTY52 */
             , V_USER_ID                                                 AS CREATED_BY
             , SYSDATE                                                   AS CREATION_DATE
             , V_USER_ID                                                 AS LAST_UPDATED_BY
             , SYSDATE                                                   AS LAST_UPDATE_DATE
             , X.ATTRIBUTE1
             , X.ATTRIBUTE2
             , X.ATTRIBUTE3
             , X.ATTRIBUTE4
             , X.ATTRIBUTE5
             , X.ATTRIBUTE6
             , X.ATTRIBUTE7
             , X.ATTRIBUTE8
             , X.ATTRIBUTE9
             , X.ATTRIBUTE10
          FROM GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO X
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 012 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* 불필요한 TEMP 테이블 삭제 */
        /* IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_SMALL_AUTO') IS NOT NULL DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_AUTO */
        DELETE FROM GT_XPGS_SCP_XLS_PSI_GLOBAL_SMALL_AUTO;

        /* ------------------------------------------------------------------------------------------------------------- */
        /* YIELD(CELL_CHAR_AVAILABLE), LT UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* AS-IS UPDATE ... FROM JOIN : 대상 1행에 원천 여러 행이면 임의 1건 반영 → ROWID 기준 1건으로 MERGE */
        MERGE
         INTO SCP_XLS_PSI_GLOBAL_SMALL T
        USING (SELECT IB.RID
                    , IB.YIELD
                 FROM (SELECT X.ROWID                                 AS RID
                            , (CASE WHEN NVL(Y.SSP_MODIFY_YIELD, 0) > 0.0 THEN NVL(Y.SSP_MODIFY_YIELD, 0)
                                    ELSE NVL(Y.FORMATION_TOTAL_YIELD, 0)
                               END)                                   AS YIELD
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                         FROM SCP_XLS_PSI_GLOBAL_SMALL X
                            , (SELECT Z.ITEM_ID
                                    , Z.PLANT_SITE_ID
                                    , MAX(Z.FORMATION_TOTAL_YIELD)    AS FORMATION_TOTAL_YIELD
                                    , Z.SSP_MODIFY_YIELD
                                 FROM SCP_MST_FORMATION_V Z
                                WHERE Z.DIVISION_ID = V_DIVISION_ID
                                GROUP BY Z.ITEM_ID
                                       , Z.PLANT_SITE_ID
                                       , Z.SSP_MODIFY_YIELD
                              ) Y
                          /* E20251017-001667 반제품 수율정보 누락의 보완 */
                        WHERE X.ITEM_ID              = Y.ITEM_ID
                          AND X.FROM_SITE            = Y.PLANT_SITE_ID
                          AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                          AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          AND X.MEASURE             IN ('CELL_CHAR_AVAILABLE', 'CELL_FOR_FORM_END', 'CELL_PROD_FORM_END')
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (T.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET T.YIELD = S.YIELD
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 013 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* PACK PROD */
        /* ------------------------------------------------------------------------------------------------------------- */
        MERGE
         INTO SCP_XLS_PSI_GLOBAL_SMALL T
        USING (SELECT IB.RID
                    , IB.YIELD
                 FROM (SELECT X.ROWID                                 AS RID
                            , NVL(Y.YIELD, 0)                         AS YIELD
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                            /* -- SELECT X.CELL_ITEM_ID, X.ITEM_ID, X.FROM_SITE, X.TO_SITE, X.YIELD,X.MEASURE,X.PROD_LINE,Y.LINE_ID, (CASE WHEN X.PROD_LINE = Y.LINE_ID THEN 'O' ELSE 'X' END ) AS chk,Y.ITEM_ID, Y.PLANT_SITE_ID,Y.YIELD */
                         FROM SCP_XLS_PSI_GLOBAL_SMALL X
                            , (SELECT XA.PLANT_SITE_ID
                                    , XA.ITEM_ID
                                    , XA.OPERATION_ID
                                    , XA.LINE_ID
                                    , MAX(XA.YIELD)                   AS YIELD
                                 /* AS-IS #tmp_SCP_MST_TACT_TIME */
                                 FROM (SELECT SA.DIVISION_ID
                                            , SA.PLANT_SITE_ID
                                            , SA.ITEM_ID
                                            , SA.OPERATION_ID
                                            , SA.LINE_ID
                                            , SA.YIELD
                                         FROM SCP_MST_TACT_TIME SA
                                        WHERE SA.DIVISION_ID = V_DIVISION_ID
                                        UNION ALL
                                       SELECT SB.DIVISION_ID
                                            , SB.PLANT_SITE_ID
                                            , SB.ITEM_ID
                                            , SB.OPERATION_ID
                                            , SB.LINE_ID
                                            , SB.YIELD
                                         FROM SCP_MST_TACT_TIME_OSP SB
                                        WHERE SB.DIVISION_ID = V_DIVISION_ID
                                      ) XA
                                WHERE XA.DIVISION_ID   = V_DIVISION_ID
                                  AND XA.OPERATION_ID IN ('P9500', 'P5500', 'P5200')  /* PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - P5200 추가 */
                                GROUP BY XA.PLANT_SITE_ID
                                       , XA.ITEM_ID
                                       , XA.OPERATION_ID
                                       , XA.LINE_ID
                              ) Y
                        WHERE X.ITEM_ID              = Y.ITEM_ID
                          AND X.FROM_SITE            = Y.PLANT_SITE_ID
                          AND X.ATTRIBUTE9           = Y.OPERATION_ID
                          AND X.PROD_LINE            = Y.LINE_ID
                          AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                          AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          AND X.MEASURE              = 'PACK_PROD'
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (T.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET T.YIELD = S.YIELD
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 014 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 적용 - START */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 중장기 :: 첫 1 YEAR 만 적용 */
        /* -- */
        IF (V_PLAN_START_YYYYMMDD = V_CREATE_FROM_YYYYMMDD) THEN
            /* 0값으로 초기화 (하이픈을 0 으로 통일) */
            UPDATE SCP_XLS_PSI_GLOBAL_SMALL
               SET LT_DAY               = 0
             WHERE CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
               AND DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
               AND MEASURE              = 'PACK_BOH'
            ;

            /* 실제값으로 Update */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.LT_DAY
                     FROM (SELECT X.ROWID                             AS RID
                                , Y.LT_DAY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , (SELECT XA.LT_DAY
                                        , XA.SCM_SITE_ID
                                        , XA.ITEM_ID
                                     FROM SCP_MST_OPERATION_LT XA
                                    WHERE XA.DIVISION_ID  = V_DIVISION_ID
                                      AND XA.LT_OPERATION = 'PRE_INSP'
                                  ) Y
                            WHERE X.ITEM_ID              = Y.ITEM_ID
                              AND X.FROM_SITE            = Y.SCM_SITE_ID
                              AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                              AND X.MEASURE              = 'PACK_BOH'
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.LT_DAY = S.LT_DAY
            ;
        END IF;
        /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 적용 - START */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 015 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* AS-IS L1691~L1713 (원문 그대로 보존)
                        ( *
                       -------------------------------------------------------------------------------------------------------------
                       -- SCP_ANL_PSI_GLOBAL_SMALL.MODEL_INVENTORY --> SCP_XLS_PSI_GLOBAL_SMALL.PACK_BOH
                       -------------------------------------------------------------------------------------------------------------
                          SELECT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,CELL_ITEM_ID,ITEM_ID,FROM_SITE,QTY
                           INTO #SCP_XLS_PSI_GLOBAL_SMALL_AUTO_MODEL_INVENTORY
                           FROM SCP_ANL_PSI_GLOBAL_SMALL X  WITH (NOLOCK)
                            WHERE X.DIVISION_ID                =  @p_division_id
                                   AND X.PLAN_START_YYYYMMDD    =  @p_plan_start_yyyymmdd
                                   AND X.PLAN_TYPE                    =  @p_plan_type
                                   AND X.SEQ                            =  @p_seq
                               AND X.MEASURE             = 'MODEL_INVENTORY'
                               AND X.YYYYMMDD            = @p_plan_start_yyyymmdd

                         UPDATE X
                           SET X.QTY001            = Y.QTY
                           FROM SCP_XLS_PSI_GLOBAL_SMALL X  WITH (NOLOCK)
                           INNER JOIN #SCP_XLS_PSI_GLOBAL_SMALL_AUTO_MODEL_INVENTORY Y WITH (NOLOCK)
                           ON X.DIVISION_ID   = Y.DIVISION_ID
                           AND X.FROM_SITE    = Y.FROM_SITE
                           AND X.ITEM_ID      = Y.ITEM_ID
                           AND X.MEASURE      ='PACK_BOH'
                       * )
        */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL X
           SET X.ITEM_ID             = (SELECT Y.CHILD_ITEM_ID
                                          FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Y
                                         WHERE Y.DIVISION_ID        = X.DIVISION_ID
                                           AND Y.MODEL_ID           = X.ITEM_ID
                                           AND Y.OPERATION_GROUP_ID = 'A'
                                           /* 2023.07.01 추가 */
                                           AND Y.CELL_TYPE          = 'CP'
                                           AND ROWNUM               = 1)
             , X.TO_SITE             = '-'
             , X.TO_SITE_DESCRIPTION = '-'
             , X.PROJECT_CODE        = '-'
             , X.INCOTERMS           = '-'
             , X.PROD_LINE           = '-'
         WHERE X.OPERATION_GROUP      = 'P'
           AND X.MEASURE             IN ('PACK_CELL_BOH', 'PACK_CELL_EOH')
           AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
           AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 016 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        UPDATE SCP_XLS_PSI_GLOBAL_SMALL X
           SET X.NICK_NAME = (SELECT (CASE WHEN Y.NICK_NAME IS NULL THEN '-' ELSE Y.NICK_NAME END)
                                FROM SCM_MST_ITEM_SN Y
                               WHERE Y.ITEM_ID = X.ITEM_ID
                                 AND Y.NICK_NAME IS NOT NULL
                                 AND ROWNUM    = 1)  /* 2021.05.27 KSW NICK NAME 누락오류 수정 :: AND Y.NICK_NAME IS NOT NULL 추가 */
         WHERE X.OPERATION_GROUP      = 'P'
           AND X.MEASURE             IN ('PACK_CELL_BOH', 'PACK_CELL_EOH')
           AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
           AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 017 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* --- 활성화코드 PACK의 CELL ASSAY는 CP로 표기::2023.06.20, KSK */
        /* ------------------------------------------------------------------------------------------------------------- */
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL
           SET ITEM_ID         = CELL_ITEM_ID
         WHERE OPERATION_GROUP = 'P'
           AND DIVISION_ID     = V_DIVISION_ID  /* 2022.03.23 KSW GM JV 반영 */
           AND FN_GET_FINAL_ITEM(DIVISION_ID, ITEM_ID, 'IS_CA') = 'Y'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 018 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        UPDATE SCP_XLS_PSI_GLOBAL_SMALL X
           SET X.CELL_QTY_PACK = (SELECT CEIL(V.ACCUMULATED_CHILD_QTY)  /* AS-IS CONVERT(NVARCHAR(50), CEILING(...)) */
                                    FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V
                                   WHERE V.DIVISION_ID        = X.DIVISION_ID
                                     AND V.OPERATION_GROUP_ID = 'A'
                                     AND V.MODEL_ID           = X.ITEM_ID
                                     AND V.CHILD_ITEM_ID      = X.CELL_ITEM_ID
                                     AND ROWNUM               = 1)
         WHERE 0 = 0
           AND X.OPERATION_GROUP      = 'P'
           AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
           AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 019 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* AS-IS DELETE TBL FROM (ROW_NUMBER ...) TBL WHERE TBL.ROWNUM > 1 → ROWID 기준 삭제 */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL
         WHERE ROWID IN (SELECT TBL.RID
                           FROM (SELECT ROWID                                                                  AS RID
                                      , ROW_NUMBER() OVER(PARTITION BY CELL_ITEM_ID, ITEM_ID, FROM_SITE ORDER BY XLS_KEY1 DESC) AS RNUM
                                   FROM SCP_XLS_PSI_GLOBAL_SMALL
                                  WHERE MEASURE             IN ('PACK_CELL_BOH')
                                    AND DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                                    AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                                ) TBL
                          WHERE TBL.RNUM > 1)
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 020 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL
         WHERE ROWID IN (SELECT TBL.RID
                           FROM (SELECT ROWID                                                                  AS RID
                                      , ROW_NUMBER() OVER(PARTITION BY CELL_ITEM_ID, ITEM_ID, FROM_SITE ORDER BY XLS_KEY1 DESC) AS RNUM
                                   FROM SCP_XLS_PSI_GLOBAL_SMALL
                                  WHERE MEASURE             IN ('PACK_CELL_EOH')
                                    AND DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                                    AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                                ) TBL
                          WHERE TBL.RNUM > 1)
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 021 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* --SEMI_SHIP_PLAN 해상재고 추가로 인한 중복 발생을 제거 하기 위해서 */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL
         WHERE ROWID IN (SELECT TBL.RID
                           FROM (SELECT ROWID                                                                  AS RID
                                      , ROW_NUMBER() OVER(PARTITION BY CELL_ITEM_ID, ITEM_ID, TO_SITE, FROM_SITE, TRANSPORT_MODE, BOD_ID ORDER BY BOD_ID DESC) AS RNUM  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 BOD_ID 추가 */
                                   FROM SCP_XLS_PSI_GLOBAL_SMALL
                                  WHERE MEASURE             IN ('SEMI_SHIP_PLAN')
                                    AND DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                                    AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                                ) TBL
                          WHERE TBL.RNUM > 1)
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 022 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL
         WHERE MEASURE              = 'SHIP_PLAN'
           AND TRANSPORT_MODE       = '-'
           AND DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
           AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 023 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* BOH 반영(SCP_XLS_BOH) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 중장기 :: 첫 1 YEAR 만 적용 */
        /* -- */
        IF (V_PLAN_START_YYYYMMDD = V_CREATE_FROM_YYYYMMDD) THEN

            /* IF OBJECT_ID('tempdb..#BOH') IS NOT NULL DROP TABLE #BOH */
            DELETE FROM GT_XPGS_BOH;

            INSERT
              INTO GT_XPGS_BOH
                 ( DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , SCM_SITE_ID
                 , INCOTERMS
                 , ITEM_ID
                 , FROM_SCM_SITE_ID
                 , QTY
                 )
            SELECT DIVISION_ID
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , SCM_SITE_ID
                 , INCOTERMS
                 , ITEM_ID
                 , MAX(ATTRIBUTE1)                AS FROM_SCM_SITE_ID  /* E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영 건 추가. */
                 , SUM(QTY)                       AS QTY
                   /* --							, ORIGIN_ITEM_ID */
                   /* --							, SUM(ORIGIN_QTY) AS ORIGIN_QTY */
              FROM SCP_XLS_BOH
             WHERE DIVISION_ID         = V_DIVISION_ID
               AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND PLAN_TYPE           = V_PLAN_TYPE
               AND SEQ                 = V_SEQ
               AND ORIGIN_ITEM_ID IS NULL  /* AS-IS ISNULL(ORIGIN_ITEM_ID,'') = '' */
             GROUP BY DIVISION_ID
                    , PLAN_START_YYYYMMDD
                    , PLAN_TYPE
                    , SEQ
                    , SCM_SITE_ID
                    , INCOTERMS
                    , ITEM_ID
                    /* --							, ORIGIN_ITEM_ID */
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 024 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외 - start */
            /* HOLD 가 포함되지 않음 - PACK HOLD 만 해당 */
            /* IF OBJECT_ID('tempdb..#BOH_NHOLD') IS NOT NULL DROP TABLE #BOH_NHOLD
               #BOH_NHOLD 는 아래 PACK_BOH 반영 한 곳에서만 쓰여 그 자리의 인라인 뷰로 옮김 */

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 025 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                             AS RID
                                , NVL(Y.QTY, 0)                       AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , (SELECT XA.DIVISION_ID
                                        , XA.PLAN_START_YYYYMMDD
                                        , XA.PLAN_TYPE
                                        , XA.SEQ
                                        , XA.SCM_SITE_ID
                                        , XA.INCOTERMS
                                        , XA.ITEM_ID
                                        , SUM(XA.QTY)                 AS QTY
                                          /* --							, ORIGIN_ITEM_ID */
                                          /* --							, SUM(ORIGIN_QTY) AS ORIGIN_QTY */
                                     FROM SCP_XLS_BOH XA
                                    WHERE XA.DIVISION_ID         = V_DIVISION_ID
                                      AND XA.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                      AND XA.PLAN_TYPE           = V_PLAN_TYPE
                                      AND XA.SEQ                 = V_SEQ
                                      AND XA.ORIGIN_ITEM_ID IS NULL  /* AS-IS ISNULL(ORIGIN_ITEM_ID,'') = '' */
                                      AND NOT XA.ATTRIBUTE10 LIKE '%HOLD'  /* Pack BOH 수량에서 Hold 수량제외 */
                                    GROUP BY XA.DIVISION_ID
                                           , XA.PLAN_START_YYYYMMDD
                                           , XA.PLAN_TYPE
                                           , XA.SEQ
                                           , XA.SCM_SITE_ID
                                           , XA.INCOTERMS
                                           , XA.ITEM_ID
                                  ) Y  /* AS-IS #BOH_NHOLD */
                            WHERE 0 = 0
                              AND X.FROM_SITE            = Y.SCM_SITE_ID
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.MEASURE              = 'PACK_BOH'
                              AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.QTY001 = S.QTY
            ;

            /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외 - end */
            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 026 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                             AS RID
                                , NVL(Y.QTY, 0)                       AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , GT_XPGS_BOH              Y
                            WHERE 0 = 0
                              AND X.FROM_SITE            = Y.SCM_SITE_ID
                              AND X.ITEM_ID              = Y.ITEM_ID
                              /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외 */
                              /* --AND X.MEASURE         IN ('PACK_BOH','CELL_BOH','PACK_CELL_BOH') */
                              AND X.MEASURE             IN ('CELL_BOH', 'PACK_CELL_BOH')
                              AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.QTY001 = S.QTY
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 027 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* -- 보류중 해제일자가 없는수량 */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                             AS RID
                                , NVL(X.QTY001, 0) - NVL(Y.QTY, 0)    AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , (SELECT XA.ITEM_ID
                                        , XA.FROM_SITE
                                        , SUM(XA.QTY)                 AS QTY
                                     FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN XA
                                    WHERE XA.DESCR = 'WH_HOLD'
                                    GROUP BY XA.ITEM_ID
                                           , XA.FROM_SITE
                                  ) Y
                            WHERE 0 = 0
                              AND X.FROM_SITE            = Y.FROM_SITE
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.MEASURE             IN ('CELL_BOH', 'PACK_CELL_BOH')  /* 2022.08.30 KSW Cell 재고 개선건 - PACK_CELL_BOH Cell BOH measure 에서 HOLD 수량제외 */
                              AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.QTY001 = S.QTY
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 028 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                             AS RID
                                , NVL(Y.QTY, 0)                       AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , GT_XPGS_BOH              Y
                            WHERE 0 = 0
                              AND X.TO_SITE              = Y.SCM_SITE_ID
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.MEASURE              = 'TO_SITE_BOH'
                              AND X.INCOTERMS            = Y.INCOTERMS
                              AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                              /* E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영 건 추가. */
                              AND NOT EXISTS (/* FROM_SITE 까지 매핑되는 데이터는 제외. */
                                              SELECT 1
                                                FROM SCP_XLS_PSI_GLOBAL_SMALL XX
                                               WHERE EXISTS (SELECT 1
                                                               FROM GT_XPGS_BOH YY
                                                              WHERE 0 = 0
                                                                AND XX.TO_SITE              = YY.SCM_SITE_ID
                                                                AND XX.ITEM_ID              = YY.ITEM_ID
                                                                AND XX.MEASURE              = 'TO_SITE_BOH'
                                                                AND XX.INCOTERMS            = YY.INCOTERMS
                                                                AND XX.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                                                                AND XX.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                                                                AND XX.FROM_SITE            = YY.FROM_SCM_SITE_ID
                                                            )
                                                 AND XX.TO_SITE              = X.TO_SITE
                                                 AND XX.ITEM_ID              = X.ITEM_ID
                                                 AND XX.MEASURE              = X.MEASURE
                                                 AND XX.INCOTERMS            = X.INCOTERMS
                                                 AND XX.DIVISION_ID          = X.DIVISION_ID
                                                 AND XX.CREATE_FROM_YYYYMMDD = X.CREATE_FROM_YYYYMMDD
                                                 /* FROM_SITE 제외하고. -- */
                                             )
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.QTY001 = S.QTY
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 029 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영 건 추가. */
            /* FROM SITE 존재하는 데이터 업데이트. */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                             AS RID
                                , NVL(Y.QTY, 0)                       AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , GT_XPGS_BOH              Y
                            WHERE 0 = 0
                              AND X.TO_SITE              = Y.SCM_SITE_ID
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.MEASURE              = 'TO_SITE_BOH'
                              AND X.INCOTERMS            = Y.INCOTERMS
                              AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW */
                              AND X.FROM_SITE            = Y.FROM_SCM_SITE_ID
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.QTY001 = S.QTY
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 030 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* ------------------------------------------------------------------------------------------------------------- */
            /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - Pack BOH(Wait for Inspection) 추가 - start */
            /* ------------------------------------------------------------------------------------------------------------- */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                             AS RID
                                , NVL(Z.QTY, 0)                       AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , (SELECT Y.ITEM_ID
                                        , Y.FROM_SITE
                                        , SUM(Y.QTY)                  AS QTY
                                     FROM GT_XPGS_PLN_TH_ENG_STOCK_PLAN_INSP Y
                                    WHERE Y.INSP_TYPE = 'INSP_PRE'
                                      /* --AND Y.YYYYMMDD < DATEADD(day, 7, CONVERT(DATE, @p_plan_start_yyyymmdd)) */
                                    GROUP BY Y.ITEM_ID
                                           , Y.FROM_SITE
                                  ) Z
                            WHERE X.ITEM_ID              = Z.ITEM_ID
                              AND X.FROM_SITE            = Z.FROM_SITE
                              AND X.MEASURE              = 'PACK_BOH_WAIT_FOR_INSP'
                              AND X.DIVISION_ID          = V_DIVISION_ID  /* 2022.03.23 KSW GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.QTY001 = S.QTY
            ;
            /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - Pack BOH(Wait for Inspection) 추가 - end */

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 031 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* --/ * */
            /* 2022.07.29 KSW DIO Report에서 사용되는 GRO_STD_DIO, MIN_STD_DIO 으로 대체 - start */
            /* ------------------------------------------------------------------------------------------------------------- */
            /* DIO 관련 시뮬레이션 추가 */
            /* 2020.06.25 KTH DIO 수정 관련 */
            /* ------------------------------------------------------------------------------------------------------------- */
            /* IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO_OLD') IS NOT NULL DROP TABLE #tmp_SCP_MST_DIO_OLD
               #tmp_SCP_MST_DIO_OLD 는 아래 ALLOCATION_DIO 반영 한 곳에서만 쓰여 그 자리의 인라인 뷰로 옮김 */

            IF V_DIVISION_ID <> '81' THEN

                /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
                V_LOG_MESSAGE := '########## log step ##########';
                V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 032 ';
                D_EVENT_DATE  := SYSDATE;
                PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                    , P_LOG_TYPE     => 'TXN'
                                    , P_LOG_COUNT    => 0
                                    , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                    , P_DESCRIPTION  => V_DESCRIPTION
                                    , P_EVENT_DATE   => D_EVENT_DATE
                                    , P_USER_ID      => V_BATCH_USER
                                    );

                MERGE
                 INTO SCP_XLS_PSI_GLOBAL_SMALL T
                USING (SELECT IB.RID
                            , IB.GRO_STD_DIO
                            , IB.MIN_STD_DIO
                         FROM (SELECT X.ROWID                         AS RID
                                      /* AS-IS NUMERIC(17,3) → NVARCHAR 변환은 소수 3자리 고정 표기 */
                                    , TO_CHAR(Z.GRO_STD_DIO, 'FM99999999999990.000') AS GRO_STD_DIO
                                    , TO_CHAR(Z.MIN_STD_DIO, 'FM99999999999990.000') AS MIN_STD_DIO
                                    , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                                 FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                    , (SELECT A.DIVISION_ID
                                            , A.PLANT_ID
                                            , A.ITEM_ID
                                            , A.GRO_STD_DIO
                                            , A.MIN_STD_DIO
                                         FROM SCP_MST_DIO A
                                            , (SELECT SA.DIVISION_ID
                                                    , SA.PLANT_ID
                                                    , MAX(SA.YYYYQ)   AS YYYYQ
                                                 FROM SCP_MST_DIO SA
                                                WHERE SA.DIVISION_ID IS NOT NULL
                                                GROUP BY SA.DIVISION_ID
                                                       , SA.PLANT_ID
                                              ) B
                                        WHERE A.DIVISION_ID = B.DIVISION_ID
                                          AND A.PLANT_ID    = B.PLANT_ID
                                          AND A.YYYYQ       = B.YYYYQ
                                          AND A.DIVISION_ID = V_DIVISION_ID
                                          /* --and a.YYYYMM like '201912' -- @p_plan_start_yyyymmdd -- */
                                      ) Z  /* AS-IS #tmp_SCP_MST_DIO_OLD */
                                WHERE X.CELL_ITEM_ID         = Z.ITEM_ID
                                  /* --                       AND X.FROM_SITE       = Z.PLANT_ID */
                                  AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                                  AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                                  AND X.MEASURE              = 'ALLOCATION_DIO'
                              ) IB
                        WHERE IB.RN = 1
                      ) S
                   ON (T.ROWID = S.RID)
                 WHEN MATCHED THEN
                      UPDATE
                         SET T.ATTRIBUTE4 = S.GRO_STD_DIO
                           , T.ATTRIBUTE5 = S.MIN_STD_DIO
                ;

                /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
                V_LOG_MESSAGE := '########## log step ##########';
                V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 033 ';
                D_EVENT_DATE  := SYSDATE;
                PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                    , P_LOG_TYPE     => 'TXN'
                                    , P_LOG_COUNT    => 0
                                    , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                    , P_DESCRIPTION  => V_DESCRIPTION
                                    , P_EVENT_DATE   => D_EVENT_DATE
                                    , P_USER_ID      => V_BATCH_USER
                                    );

            END IF;

            /* 2022.07.29 KSW DIO Report에서 사용되는 GRO_STD_DIO, MIN_STD_DIO 으로 대체 - end */

        END IF;  /* IF (@p_plan_start_yyyymmdd = @p_create_from_yyyymmdd) 중장기 :: 첫 1 YEAR 만 적용 */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- start */
        /* BOD_ID에 대한 from_yyyymmdd, to_yyyymmdd 추가 --> ATTRIBUTE3 */
        /* ------------------------------------------------------------------------------------------------------------- */
        MERGE
         INTO SCP_XLS_PSI_GLOBAL_SMALL T
        USING (SELECT IB.RID
                    , IB.ATTRIBUTE3
                 FROM (SELECT X.ROWID                                 AS RID
                              /* AS-IS 문자 + 결합 : 어느 한쪽이 NULL 이면 결과 NULL */
                            , (CASE WHEN Z.FROM_YYYYMMDD IS NULL OR Z.TO_YYYYMMDD IS NULL THEN NULL
                                    ELSE Z.FROM_YYYYMMDD || ',' || Z.TO_YYYYMMDD
                               END)                                   AS ATTRIBUTE3
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                         FROM SCP_XLS_PSI_GLOBAL_SMALL X
                            , SCP_MST_BOD_N_V          Z
                        WHERE X.BOD_ID      = Z.BOD_ID
                          AND X.DIVISION_ID = V_DIVISION_ID  /* 2022.03.23 KSW GM JV 반영 */
                          AND X.MEASURE    IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN')
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (T.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET T.ATTRIBUTE3 = S.ATTRIBUTE3
        ;
        /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계- end */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 034 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ------------------------------------------------------------------------------------------------------------- */
        /* 52주 데이터 SCRIPT 생성후 UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* AS-IS : #Rn(WQTY01=1~7 ... WQTY52=358~364) + #CALENDAR(생성 구간 날짜 순번) + #HEADER 로
           'UPDATE X SET WQTYnn = (QTYa+...+QTYg), ...' 문자열을 만들어 sp_executesql 로 실행.
           달력은 날짜가 빠짐없이 1일 1행(2020~2035 확인)이라 주차 nn = QTY(7nn-6)~QTY(7nn) 의 합으로 정적 SQL 환원 */
        /* #CALENDAR : GROUP BY A.BASIS_YYYYMMDD--,ISO_WEEK--,A.BASIS_YYYYMM,ISO_WEEK */
        /* -- PRINT @mQry_sumWeek */
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL X
           SET X.WQTY01 = (X.QTY001 + X.QTY002 + X.QTY003 + X.QTY004 + X.QTY005 + X.QTY006 + X.QTY007)
             , X.WQTY02 = (X.QTY008 + X.QTY009 + X.QTY010 + X.QTY011 + X.QTY012 + X.QTY013 + X.QTY014)
             , X.WQTY03 = (X.QTY015 + X.QTY016 + X.QTY017 + X.QTY018 + X.QTY019 + X.QTY020 + X.QTY021)
             , X.WQTY04 = (X.QTY022 + X.QTY023 + X.QTY024 + X.QTY025 + X.QTY026 + X.QTY027 + X.QTY028)
             , X.WQTY05 = (X.QTY029 + X.QTY030 + X.QTY031 + X.QTY032 + X.QTY033 + X.QTY034 + X.QTY035)
             , X.WQTY06 = (X.QTY036 + X.QTY037 + X.QTY038 + X.QTY039 + X.QTY040 + X.QTY041 + X.QTY042)
             , X.WQTY07 = (X.QTY043 + X.QTY044 + X.QTY045 + X.QTY046 + X.QTY047 + X.QTY048 + X.QTY049)
             , X.WQTY08 = (X.QTY050 + X.QTY051 + X.QTY052 + X.QTY053 + X.QTY054 + X.QTY055 + X.QTY056)
             , X.WQTY09 = (X.QTY057 + X.QTY058 + X.QTY059 + X.QTY060 + X.QTY061 + X.QTY062 + X.QTY063)
             , X.WQTY10 = (X.QTY064 + X.QTY065 + X.QTY066 + X.QTY067 + X.QTY068 + X.QTY069 + X.QTY070)
             , X.WQTY11 = (X.QTY071 + X.QTY072 + X.QTY073 + X.QTY074 + X.QTY075 + X.QTY076 + X.QTY077)
             , X.WQTY12 = (X.QTY078 + X.QTY079 + X.QTY080 + X.QTY081 + X.QTY082 + X.QTY083 + X.QTY084)
             , X.WQTY13 = (X.QTY085 + X.QTY086 + X.QTY087 + X.QTY088 + X.QTY089 + X.QTY090 + X.QTY091)
             , X.WQTY14 = (X.QTY092 + X.QTY093 + X.QTY094 + X.QTY095 + X.QTY096 + X.QTY097 + X.QTY098)
             , X.WQTY15 = (X.QTY099 + X.QTY100 + X.QTY101 + X.QTY102 + X.QTY103 + X.QTY104 + X.QTY105)
             , X.WQTY16 = (X.QTY106 + X.QTY107 + X.QTY108 + X.QTY109 + X.QTY110 + X.QTY111 + X.QTY112)
             , X.WQTY17 = (X.QTY113 + X.QTY114 + X.QTY115 + X.QTY116 + X.QTY117 + X.QTY118 + X.QTY119)
             , X.WQTY18 = (X.QTY120 + X.QTY121 + X.QTY122 + X.QTY123 + X.QTY124 + X.QTY125 + X.QTY126)
             , X.WQTY19 = (X.QTY127 + X.QTY128 + X.QTY129 + X.QTY130 + X.QTY131 + X.QTY132 + X.QTY133)
             , X.WQTY20 = (X.QTY134 + X.QTY135 + X.QTY136 + X.QTY137 + X.QTY138 + X.QTY139 + X.QTY140)
             , X.WQTY21 = (X.QTY141 + X.QTY142 + X.QTY143 + X.QTY144 + X.QTY145 + X.QTY146 + X.QTY147)
             , X.WQTY22 = (X.QTY148 + X.QTY149 + X.QTY150 + X.QTY151 + X.QTY152 + X.QTY153 + X.QTY154)
             , X.WQTY23 = (X.QTY155 + X.QTY156 + X.QTY157 + X.QTY158 + X.QTY159 + X.QTY160 + X.QTY161)
             , X.WQTY24 = (X.QTY162 + X.QTY163 + X.QTY164 + X.QTY165 + X.QTY166 + X.QTY167 + X.QTY168)
             , X.WQTY25 = (X.QTY169 + X.QTY170 + X.QTY171 + X.QTY172 + X.QTY173 + X.QTY174 + X.QTY175)
             , X.WQTY26 = (X.QTY176 + X.QTY177 + X.QTY178 + X.QTY179 + X.QTY180 + X.QTY181 + X.QTY182)
             , X.WQTY27 = (X.QTY183 + X.QTY184 + X.QTY185 + X.QTY186 + X.QTY187 + X.QTY188 + X.QTY189)
             , X.WQTY28 = (X.QTY190 + X.QTY191 + X.QTY192 + X.QTY193 + X.QTY194 + X.QTY195 + X.QTY196)
             , X.WQTY29 = (X.QTY197 + X.QTY198 + X.QTY199 + X.QTY200 + X.QTY201 + X.QTY202 + X.QTY203)
             , X.WQTY30 = (X.QTY204 + X.QTY205 + X.QTY206 + X.QTY207 + X.QTY208 + X.QTY209 + X.QTY210)
             , X.WQTY31 = (X.QTY211 + X.QTY212 + X.QTY213 + X.QTY214 + X.QTY215 + X.QTY216 + X.QTY217)
             , X.WQTY32 = (X.QTY218 + X.QTY219 + X.QTY220 + X.QTY221 + X.QTY222 + X.QTY223 + X.QTY224)
             , X.WQTY33 = (X.QTY225 + X.QTY226 + X.QTY227 + X.QTY228 + X.QTY229 + X.QTY230 + X.QTY231)
             , X.WQTY34 = (X.QTY232 + X.QTY233 + X.QTY234 + X.QTY235 + X.QTY236 + X.QTY237 + X.QTY238)
             , X.WQTY35 = (X.QTY239 + X.QTY240 + X.QTY241 + X.QTY242 + X.QTY243 + X.QTY244 + X.QTY245)
             , X.WQTY36 = (X.QTY246 + X.QTY247 + X.QTY248 + X.QTY249 + X.QTY250 + X.QTY251 + X.QTY252)
             , X.WQTY37 = (X.QTY253 + X.QTY254 + X.QTY255 + X.QTY256 + X.QTY257 + X.QTY258 + X.QTY259)
             , X.WQTY38 = (X.QTY260 + X.QTY261 + X.QTY262 + X.QTY263 + X.QTY264 + X.QTY265 + X.QTY266)
             , X.WQTY39 = (X.QTY267 + X.QTY268 + X.QTY269 + X.QTY270 + X.QTY271 + X.QTY272 + X.QTY273)
             , X.WQTY40 = (X.QTY274 + X.QTY275 + X.QTY276 + X.QTY277 + X.QTY278 + X.QTY279 + X.QTY280)
             , X.WQTY41 = (X.QTY281 + X.QTY282 + X.QTY283 + X.QTY284 + X.QTY285 + X.QTY286 + X.QTY287)
             , X.WQTY42 = (X.QTY288 + X.QTY289 + X.QTY290 + X.QTY291 + X.QTY292 + X.QTY293 + X.QTY294)
             , X.WQTY43 = (X.QTY295 + X.QTY296 + X.QTY297 + X.QTY298 + X.QTY299 + X.QTY300 + X.QTY301)
             , X.WQTY44 = (X.QTY302 + X.QTY303 + X.QTY304 + X.QTY305 + X.QTY306 + X.QTY307 + X.QTY308)
             , X.WQTY45 = (X.QTY309 + X.QTY310 + X.QTY311 + X.QTY312 + X.QTY313 + X.QTY314 + X.QTY315)
             , X.WQTY46 = (X.QTY316 + X.QTY317 + X.QTY318 + X.QTY319 + X.QTY320 + X.QTY321 + X.QTY322)
             , X.WQTY47 = (X.QTY323 + X.QTY324 + X.QTY325 + X.QTY326 + X.QTY327 + X.QTY328 + X.QTY329)
             , X.WQTY48 = (X.QTY330 + X.QTY331 + X.QTY332 + X.QTY333 + X.QTY334 + X.QTY335 + X.QTY336)
             , X.WQTY49 = (X.QTY337 + X.QTY338 + X.QTY339 + X.QTY340 + X.QTY341 + X.QTY342 + X.QTY343)
             , X.WQTY50 = (X.QTY344 + X.QTY345 + X.QTY346 + X.QTY347 + X.QTY348 + X.QTY349 + X.QTY350)
             , X.WQTY51 = (X.QTY351 + X.QTY352 + X.QTY353 + X.QTY354 + X.QTY355 + X.QTY356 + X.QTY357)
             , X.WQTY52 = (X.QTY358 + X.QTY359 + X.QTY360 + X.QTY361 + X.QTY362 + X.QTY363 + X.QTY364)
         WHERE X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
           AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 035 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* -- ------------------------------------------------------------------------------------------------------------- */
        /* WEEK SUM PIVOT 생성 후 UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL DROP TABLE #LineLoad_WEEK;
           #LineLoad_WEEK · #LineLoad_WEEK_PIVOT 는 아래 반영 한 곳에서만 쓰여 인라인 뷰로 옮기고 PIVOT 은 조건부 MIN 집계로 환원 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 036 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 037 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        MERGE
         INTO SCP_XLS_PSI_GLOBAL_SMALL T
        USING (SELECT IB.*
                 FROM (SELECT X.ROWID                                 AS RID
                            , Y.WQTY01
                            , Y.WQTY02
                            , Y.WQTY03
                            , Y.WQTY04
                            , Y.WQTY05
                            , Y.WQTY06
                            , Y.WQTY07
                            , Y.WQTY08
                            , Y.WQTY09
                            , Y.WQTY10
                            , Y.WQTY11
                            , Y.WQTY12
                            , Y.WQTY13
                            , Y.WQTY14
                            , Y.WQTY15
                            , Y.WQTY16
                            , Y.WQTY17
                            , Y.WQTY18
                            , Y.WQTY19
                            , Y.WQTY20
                            , Y.WQTY21
                            , Y.WQTY22
                            , Y.WQTY23
                            , Y.WQTY24
                            , Y.WQTY25
                            , Y.WQTY26
                            , Y.WQTY27
                            , Y.WQTY28
                            , Y.WQTY29
                            , Y.WQTY30
                            , Y.WQTY31
                            , Y.WQTY32
                            , Y.WQTY33
                            , Y.WQTY34
                            , Y.WQTY35
                            , Y.WQTY36
                            , Y.WQTY37
                            , Y.WQTY38
                            , Y.WQTY39
                            , Y.WQTY40
                            , Y.WQTY41
                            , Y.WQTY42
                            , Y.WQTY43
                            , Y.WQTY44
                            , Y.WQTY45
                            , Y.WQTY46
                            , Y.WQTY47
                            , Y.WQTY48
                            , Y.WQTY49
                            , Y.WQTY50
                            , Y.WQTY51
                            , Y.WQTY52
                            , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                         FROM SCP_XLS_PSI_GLOBAL_SMALL X
                            , (SELECT XA.DIVISION_ID
                                    , XA.SITE_ID
                                    , XA.OPERATION_ID
                                    , XA.PROD_LINE
                                    , XA.MEASURE
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY01' THEN XA.WQTY END) AS WQTY01
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY02' THEN XA.WQTY END) AS WQTY02
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY03' THEN XA.WQTY END) AS WQTY03
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY04' THEN XA.WQTY END) AS WQTY04
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY05' THEN XA.WQTY END) AS WQTY05
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY06' THEN XA.WQTY END) AS WQTY06
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY07' THEN XA.WQTY END) AS WQTY07
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY08' THEN XA.WQTY END) AS WQTY08
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY09' THEN XA.WQTY END) AS WQTY09
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY10' THEN XA.WQTY END) AS WQTY10
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY11' THEN XA.WQTY END) AS WQTY11
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY12' THEN XA.WQTY END) AS WQTY12
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY13' THEN XA.WQTY END) AS WQTY13
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY14' THEN XA.WQTY END) AS WQTY14
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY15' THEN XA.WQTY END) AS WQTY15
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY16' THEN XA.WQTY END) AS WQTY16
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY17' THEN XA.WQTY END) AS WQTY17
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY18' THEN XA.WQTY END) AS WQTY18
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY19' THEN XA.WQTY END) AS WQTY19
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY20' THEN XA.WQTY END) AS WQTY20
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY21' THEN XA.WQTY END) AS WQTY21
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY22' THEN XA.WQTY END) AS WQTY22
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY23' THEN XA.WQTY END) AS WQTY23
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY24' THEN XA.WQTY END) AS WQTY24
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY25' THEN XA.WQTY END) AS WQTY25
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY26' THEN XA.WQTY END) AS WQTY26
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY27' THEN XA.WQTY END) AS WQTY27
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY28' THEN XA.WQTY END) AS WQTY28
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY29' THEN XA.WQTY END) AS WQTY29
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY30' THEN XA.WQTY END) AS WQTY30
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY31' THEN XA.WQTY END) AS WQTY31
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY32' THEN XA.WQTY END) AS WQTY32
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY33' THEN XA.WQTY END) AS WQTY33
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY34' THEN XA.WQTY END) AS WQTY34
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY35' THEN XA.WQTY END) AS WQTY35
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY36' THEN XA.WQTY END) AS WQTY36
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY37' THEN XA.WQTY END) AS WQTY37
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY38' THEN XA.WQTY END) AS WQTY38
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY39' THEN XA.WQTY END) AS WQTY39
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY40' THEN XA.WQTY END) AS WQTY40
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY41' THEN XA.WQTY END) AS WQTY41
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY42' THEN XA.WQTY END) AS WQTY42
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY43' THEN XA.WQTY END) AS WQTY43
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY44' THEN XA.WQTY END) AS WQTY44
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY45' THEN XA.WQTY END) AS WQTY45
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY46' THEN XA.WQTY END) AS WQTY46
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY47' THEN XA.WQTY END) AS WQTY47
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY48' THEN XA.WQTY END) AS WQTY48
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY49' THEN XA.WQTY END) AS WQTY49
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY50' THEN XA.WQTY END) AS WQTY50
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY51' THEN XA.WQTY END) AS WQTY51
                                    , MIN(CASE WHEN XA.WEEK_COLUMN = 'WQTY52' THEN XA.WQTY END) AS WQTY52
                                 FROM (SELECT A.DIVISION_ID
                                            , A.SCM_SITE_ID           AS SITE_ID
                                            , A.OPERATION_ID
                                            , A.LINE_ID               AS PROD_LINE
                                            , A.MEASURE
                                            , CASE WHEN SUM(A.WORKING_TIME) <= 0.0 THEN 0
                                                   /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현 - start */
                                                   /* 변경전 */
                                                   /* -- */
                                                   /* --ELSE ISNULL( ( ROUND(SUM(A.CAPA_TACT),0) / SUM(A.WORKING_TIME) ) ,0 ) *100 */
                                                   /* -- */
                                                   ELSE NVL((ROUND(SUM(A.CAPA_TACT), 0) / (SUM(A.WORKING_TIME) - NVL(SUM(A.TIME_TERM), 0))), 0) * 100
                                                   /* PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - CAPA. 형교환 입력(Load Ratio 표시) 및 저장기능 구현 - end */
                                              END                     AS WQTY
                                            , A.ISO_YYYYWW
                                            , A.WEEK_COLUMN
                                         FROM GT_XPGS_LINELOAD A
                                        GROUP BY A.DIVISION_ID
                                               , A.SCM_SITE_ID
                                               , A.OPERATION_ID
                                               , A.LINE_ID
                                               , A.MEASURE
                                               , A.ISO_YYYYWW
                                               , A.WEEK_COLUMN
                                      ) XA  /* AS-IS #LineLoad_WEEK */
                                GROUP BY XA.DIVISION_ID
                                       , XA.SITE_ID
                                       , XA.OPERATION_ID
                                       , XA.PROD_LINE
                                       , XA.MEASURE
                              ) Y  /* AS-IS #LineLoad_WEEK_PIVOT : PIVOT (MIN(WQTY) FOR WEEK_COLUMN IN ([WQTY01] ~ [WQTY52])) */
                        WHERE Y.PROD_LINE            = X.PROD_LINE
                          AND X.DIVISION_ID          = Y.DIVISION_ID
                          AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          AND X.FROM_SITE            = Y.SITE_ID
                          AND X.ATTRIBUTE9           = Y.OPERATION_ID
                          AND X.MEASURE             IN ('PACK_PROD_LOAD', 'CELL_PROD_LOAD')
                      ) IB
                WHERE IB.RN = 1
              ) S
           ON (T.ROWID = S.RID)
         WHEN MATCHED THEN
              UPDATE
                 SET T.WQTY01 = S.WQTY01
                   , T.WQTY02 = S.WQTY02
                   , T.WQTY03 = S.WQTY03
                   , T.WQTY04 = S.WQTY04
                   , T.WQTY05 = S.WQTY05
                   , T.WQTY06 = S.WQTY06
                   , T.WQTY07 = S.WQTY07
                   , T.WQTY08 = S.WQTY08
                   , T.WQTY09 = S.WQTY09
                   , T.WQTY10 = S.WQTY10
                   , T.WQTY11 = S.WQTY11
                   , T.WQTY12 = S.WQTY12
                   , T.WQTY13 = S.WQTY13
                   , T.WQTY14 = S.WQTY14
                   , T.WQTY15 = S.WQTY15
                   , T.WQTY16 = S.WQTY16
                   , T.WQTY17 = S.WQTY17
                   , T.WQTY18 = S.WQTY18
                   , T.WQTY19 = S.WQTY19
                   , T.WQTY20 = S.WQTY20
                   , T.WQTY21 = S.WQTY21
                   , T.WQTY22 = S.WQTY22
                   , T.WQTY23 = S.WQTY23
                   , T.WQTY24 = S.WQTY24
                   , T.WQTY25 = S.WQTY25
                   , T.WQTY26 = S.WQTY26
                   , T.WQTY27 = S.WQTY27
                   , T.WQTY28 = S.WQTY28
                   , T.WQTY29 = S.WQTY29
                   , T.WQTY30 = S.WQTY30
                   , T.WQTY31 = S.WQTY31
                   , T.WQTY32 = S.WQTY32
                   , T.WQTY33 = S.WQTY33
                   , T.WQTY34 = S.WQTY34
                   , T.WQTY35 = S.WQTY35
                   , T.WQTY36 = S.WQTY36
                   , T.WQTY37 = S.WQTY37
                   , T.WQTY38 = S.WQTY38
                   , T.WQTY39 = S.WQTY39
                   , T.WQTY40 = S.WQTY40
                   , T.WQTY41 = S.WQTY41
                   , T.WQTY42 = S.WQTY42
                   , T.WQTY43 = S.WQTY43
                   , T.WQTY44 = S.WQTY44
                   , T.WQTY45 = S.WQTY45
                   , T.WQTY46 = S.WQTY46
                   , T.WQTY47 = S.WQTY47
                   , T.WQTY48 = S.WQTY48
                   , T.WQTY49 = S.WQTY49
                   , T.WQTY50 = S.WQTY50
                   , T.WQTY51 = S.WQTY51
                   , T.WQTY52 = S.WQTY52
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 038 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* LT_TOTAL_BY_WEEK */
        /* BOD LT (SHIP_PLAN/SEMI_SHIP_PLAN) : BOD L/T 계산시 1~7일 구간은 반올림, 이후 구간은 올림 처리 */

        /* LT_DAY 업데이트 - 2021.08.10 KSW - start */
        /* 중장기 :: 첫 1 YEAR 만 적용 */
        /* -- */
        IF (V_PLAN_START_YYYYMMDD = V_CREATE_FROM_YYYYMMDD) THEN

            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.LT_TOTAL
                     FROM (SELECT X.ROWID                             AS RID
                                , Y.LT_TOTAL
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , SCP_MST_BOD_N_V          Y  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                            WHERE X.DIVISION_ID          = Y.DIVISION_ID
                              AND X.FROM_SITE            = Y.FROM_SITE
                              AND X.TO_SITE              = Y.TO_SITE
                              AND X.TRANSPORT_MODE       = Y.TRANSPORT_MODE
                              AND X.BOD_ID               = Y.BOD_ID
                              AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.LT_DAY      = S.LT_TOTAL
                       , T.ATTRIBUTE10 = 'NO_LT_DIVIDE'  /* 2022.05.24 LT오류반영 */
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 039 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* LT_DAY 업데이트 - 2022.03.02 - BOD 정보가 없는 SEMI_SHIP_PLAN UPDATE - START */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.LT_TOTAL
                        , IB.BOD_ID
                        , IB.ATTRIBUTE3
                     FROM (SELECT X.ROWID                             AS RID
                                , Y.LT_TOTAL
                                , Y.BOD_ID
                                  /* AS-IS 문자 + 결합 : 어느 한쪽이 NULL 이면 결과 NULL */
                                , (CASE WHEN Y.FROM_YYYYMMDD IS NULL OR Y.TO_YYYYMMDD IS NULL THEN NULL
                                        ELSE Y.FROM_YYYYMMDD || ',' || Y.TO_YYYYMMDD
                                   END)                               AS ATTRIBUTE3
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , SCP_MST_BOD_N_V          Y  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 - SCP_MST_BOD_V --> SCP_MST_BOD_N_V */
                            WHERE X.DIVISION_ID          = Y.DIVISION_ID
                              AND X.FROM_SITE            = Y.FROM_SITE
                              AND X.TO_SITE              = Y.TO_SITE
                              AND X.TRANSPORT_MODE       = Y.TRANSPORT_MODE
                              AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                              AND X.BOD_ID               = '-'
                              AND X.MEASURE              = 'SEMI_SHIP_PLAN'
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.LT_DAY      = S.LT_TOTAL
                       , T.BOD_ID      = S.BOD_ID
                       , T.ATTRIBUTE3  = S.ATTRIBUTE3
                       , T.ATTRIBUTE10 = 'NO_LT_DIVIDE'  /* 2022.05.24 LT오류반영 */
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 040 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* SEMI_SHIP_PLAN 에서 TRANSPORT_MODE, BOD_ID 가 NULL 인건 삭제 */
            DELETE
              FROM SCP_XLS_PSI_GLOBAL_SMALL
             WHERE MEASURE     = 'SEMI_SHIP_PLAN'
               AND BOD_ID IS NULL
               AND TRANSPORT_MODE IS NULL
               AND DIVISION_ID = V_DIVISION_ID  /* 2022.03.23 KSW GM JV 반영 */
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 041 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* LT_DAY 업데이트 - 2022.03.02 - BOD 정보가 없는 SEMI_SHIP_PLAN UPDATE - END */

            /* 20200323 [전지 공급 대응력 향상을 위한 RTF 적확도 개선] - Hold VMI 대기 재고 Visibility 강화 */
            /* VMI 전진 검사 LT 추가 적용 : SCM_MST_SITE_ITEM 테이블의 SCP_VMI_LT 값 만큼 더해 줌 */
            /* 2022.05.24 LT오류반영 */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.LT_DAY
                     FROM (SELECT X.ROWID                             AS RID
                                , NVL(X.LT_DAY, 0) + NVL(Y.LT_DAY, 0) AS LT_DAY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , (SELECT S.DIVISION_ID
                                        , S.SCM_SITE_ID
                                        , S.ITEM_ID
                                        , MAX(NVL(S.SCP_VMI_LT, 0))   AS LT_DAY
                                     FROM SCM_MST_SITE_ITEM            S
                                        , SCM_ADM_LOOKUP_MASTER_DETAIL MD
                                    WHERE S.DIVISION_ID  = MD.SEGMENT1
                                      AND S.SCM_SITE_ID  = MD.SEGMENT2
                                      AND MD.LOOKUP_TYPE = 'VMI_LT_SITE'
                                      AND S.VALID_YN     = 'Y'
                                      AND MD.VALID_YN    = 'Y'
                                    GROUP BY S.DIVISION_ID
                                           , S.SCM_SITE_ID
                                           , S.ITEM_ID
                                  ) Y
                            WHERE X.DIVISION_ID          = Y.DIVISION_ID
                              AND X.TO_SITE              = Y.SCM_SITE_ID
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.DIVISION_ID          = V_DIVISION_ID  /* 2022.03.23 KSW GM JV 반영 */
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                              AND X.DIVISION_ID          = V_DIVISION_ID
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.LT_DAY      = S.LT_DAY
                       , T.ATTRIBUTE10 = NULL
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 042 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* 2022.05.24 LT오류반영 - start */
            /* VMI LT 업데이트에서 누락된 모든 LT를 7로 나눈값을 적용한다 */
            UPDATE SCP_XLS_PSI_GLOBAL_SMALL X
               SET X.LT_DAY      = (CASE WHEN X.LT_DAY < 7.0 THEN ROUND(X.LT_DAY, 0) ELSE CEIL(X.LT_DAY) END)  /* 2022.06.02 7일 이내는 ROUND, 7일 이상은 CEILING 으로 변경 */
                 , X.ATTRIBUTE10 = NULL
             WHERE X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
               AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
               AND X.ATTRIBUTE10          = 'NO_LT_DIVIDE'
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 043 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* 2022.05.24 LT오류반영 - end */

            /* --SELECT * INTO ##SCP_XLS_PSI_GLOBAL_SMALL2 FROM SCP_XLS_PSI_GLOBAL_SMALL WITH (NOLOCK) */
            /* --RETURN; */

            /* * 2020.03.31 KTH CELL_PROD LT로직 변경 */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.LT_DAY
                     FROM (SELECT X.ROWID                             AS RID
                                , (CEIL(NVL(Y.LT_FORMATION + TO_NUMBER(NVL(Y.ATTRIBUTE1, '0')), 0) / 7.0)) AS LT_DAY
                                  /* --,Y.LT_FORMATION + CONVERT(INT, ISNULL(Y.ATTRIBUTE1, '0')) AS LT_FORMATION */
                                  /* --,Y.LT_FORMATION,ISNULL(Y.ATTRIBUTE1, '0'), * */
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , SCP_MST_FORMATION        Y
                            WHERE X.DIVISION_ID          = Y.DIVISION_ID
                              AND X.FROM_SITE            = Y.PLANT_SITE_ID
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.MEASURE              = 'CELL_PROD'
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                              AND X.DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.LT_DAY = S.LT_DAY
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 044 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* CELL_EOH의 FROM_BOH_QTY 로직설정(KSK, 250407) */
            MERGE
             INTO SCP_XLS_PSI_GLOBAL_SMALL T
            USING (SELECT IB.RID
                        , IB.QTY
                     FROM (SELECT X.ROWID                             AS RID
                                , NVL(Y.QTY, 0)                       AS QTY
                                , ROW_NUMBER() OVER(PARTITION BY X.ROWID ORDER BY NULL) AS RN
                             FROM SCP_XLS_PSI_GLOBAL_SMALL X
                                , (SELECT S.ITEM_ID
                                        , S.FROM_SITE
                                        , SUM(S.QTY001)               AS QTY
                                     FROM SCP_XLS_PSI_GLOBAL_SMALL S
                                    WHERE S.MEASURE = 'CELL_BOH'
                                    GROUP BY S.ITEM_ID
                                           , S.FROM_SITE
                                  ) Y
                            WHERE 0 = 0
                              AND X.FROM_SITE            = Y.FROM_SITE
                              AND X.ITEM_ID              = Y.ITEM_ID
                              AND X.MEASURE              = 'CELL_EOH'
                              AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
                              AND X.DIVISION_ID          = V_DIVISION_ID  /* 2022.03.23 KSW GM JV 반영 */
                          ) IB
                    WHERE IB.RN = 1
                  ) S
               ON (T.ROWID = S.RID)
             WHEN MATCHED THEN
                  UPDATE
                     SET T.FROM_BOH_QTY = S.QTY
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 045 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

        END IF;  /* 중장기 :: 첫 1 YEAR 만 적용 */
        /* LT_DAY 업데이트 - 2021.08.10 KSW - end ------------------------------------------------ */

        /* 중복 오류 보정 */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL
         WHERE ROWID IN (SELECT TBL.RID
                           /* -- SELECT * */
                           FROM (SELECT ROWID                                                                  AS RID
                                      , ROW_NUMBER() OVER(PARTITION BY CELL_ITEM_ID, ITEM_ID, NICK_NAME, TO_SITE, PROJECT_CODE, INCOTERMS, FROM_SITE, TRANSPORT_MODE, PROD_LINE, BOD_ID ORDER BY BOD_ID DESC) AS RNUM  /* PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계 중복제거시 BOD_ID 추가 */
                                      /* --							, * */
                                   FROM SCP_XLS_PSI_GLOBAL_SMALL
                                  WHERE MEASURE             IN ('SEMI_SHIP_PLAN', 'SHIP_PLAN')  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 SHIP_PLAN 추가 */
                                    AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.04.30 KSW PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                                    AND DIVISION_ID          = V_DIVISION_ID           /* 2022.03.23 KSW GM JV 반영 */
                                ) TBL
                          WHERE TBL.RNUM > 1)
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 046 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* ITEM_ID 없는 PACK_CELL_BOH, PACK_CELL_EOH 삭제 - 2021.11.17 KSW */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL
         WHERE CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
           AND DIVISION_ID          = V_DIVISION_ID  /* 2022.03.23 KSW GM JV 반영 */
           AND MEASURE             IN ('PACK_CELL_BOH', 'PACK_CELL_EOH')
           AND ITEM_ID IS NULL
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 047 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* PACK 영역에 추가된 SEMI 삭제 - 2021.11.17 KSW */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL
         WHERE CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
           AND DIVISION_ID          = V_DIVISION_ID  /* 2022.03.23 KSW GM JV 반영 */
           AND MEASURE             IN ('SEMI_WHIN', 'SEMI_INTRANSIT', 'SEMI_INTRANSIT_ETA', 'SEMI_SHIP_PLAN_ETA', 'SEMI_SHIP_PLAN')
           AND OPERATION_GROUP      = 'P'
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 048 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* PACK_CELL_BOH_HOLD 단독으로 존재하는 모델 PACK_CELL_BOH_HOLD 삭제 - 2022.08.30 KSW Cell 재고 개선건 */
        DELETE
          FROM SCP_XLS_PSI_GLOBAL_SMALL Y
         WHERE Y.DIVISION_ID = V_DIVISION_ID
           AND Y.MEASURE     = 'PACK_CELL_BOH_HOLD'
           AND EXISTS (SELECT 1
                         FROM (SELECT S.CELL_ITEM_ID
                                    , S.ITEM_ID
                                    , S.FROM_SITE
                                    , SUM(S.CNT)                      AS CNT
                                 FROM (SELECT A.CELL_ITEM_ID
                                            , A.ITEM_ID
                                            , A.FROM_SITE
                                            , (CASE WHEN A.MEASURE = 'PACK_CELL_BOH' THEN 1 ELSE 2 END) AS CNT
                                         FROM SCP_XLS_PSI_GLOBAL_SMALL A
                                        WHERE A.DIVISION_ID = V_DIVISION_ID
                                          AND A.MEASURE    IN ('PACK_CELL_BOH_HOLD', 'PACK_CELL_BOH')
                                      ) S
                                GROUP BY S.CELL_ITEM_ID
                                       , S.ITEM_ID
                                       , S.FROM_SITE
                              ) X
                        WHERE X.CELL_ITEM_ID = Y.CELL_ITEM_ID
                          AND X.ITEM_ID      = Y.ITEM_ID
                          AND X.FROM_SITE    = Y.FROM_SITE
                          AND X.CNT          = 2)
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 049 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* IF OBJECT_ID('TEMPDB..#PSI_GLOBAL_SMALL_FINAL') IS NOT NULL DROP TABLE #PSI_GLOBAL_SMALL_FINAL
           #PSI_GLOBAL_SMALL_FINAL 은 아래 적재 한 곳에서만 쓰여(디버그 조회 제외) 바로 적재로 옮김 */
        /* IF @P_IS_DEBUG = 1 SELECT '#PSI_GLOBAL_SMALL_FINAL' TN, * FROM #PSI_GLOBAL_SMALL_FINAL : 디버그 결과 집합 없음 */

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 050 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* 2022.08.30 KSW Cell 재고 개선건 */
        /* PACK_CELL_BOH_HOLD measure가 없는 PACK_CELL_BOH 그룹에 PACK_CELL_BOH_HOLD 추가 */
        INSERT
          INTO SCP_XLS_PSI_GLOBAL_SMALL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , CREATE_FROM_YYYYMMDD
             , CREATE_TO_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , OPERATION_GROUP
             , OPERATION_GROUP_NAME
             , CELL_ITEM_ID
             , ITEM_ID
             , NICK_NAME
             , CELL_QTY_PACK
             , TO_SITE
             , TO_SITE_DESCRIPTION
             , PROJECT_CODE
             , FROM_BOH_QTY
             , TO_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , FROM_SITE_DESCRIPTION
             , TRANSPORT_MODE
             , PROD_LINE
             , LT_DAY
             , BOD_ID
             , MEASURE
             , MEASURE_LABEL
             , XLS_KEY1
             , XLS_KEY2
             , XLS_KEY3
             , XLS_KEY4
             , XLS_KEY5
             , XLS_ATTRIBUTE1
             , XLS_ATTRIBUTE2
             , XLS_ATTRIBUTE3
             , XLS_ATTRIBUTE4
             , XLS_ATTRIBUTE5
             , SORT_ORDER_NO
             , QTY001
             , QTY002
             , QTY003
             , QTY004
             , QTY005
             , QTY006
             , QTY007
             , QTY008
             , QTY009
             , QTY010
             , QTY011
             , QTY012
             , QTY013
             , QTY014
             , QTY015
             , QTY016
             , QTY017
             , QTY018
             , QTY019
             , QTY020
             , QTY021
             , QTY022
             , QTY023
             , QTY024
             , QTY025
             , QTY026
             , QTY027
             , QTY028
             , QTY029
             , QTY030
             , QTY031
             , QTY032
             , QTY033
             , QTY034
             , QTY035
             , QTY036
             , QTY037
             , QTY038
             , QTY039
             , QTY040
             , QTY041
             , QTY042
             , QTY043
             , QTY044
             , QTY045
             , QTY046
             , QTY047
             , QTY048
             , QTY049
             , QTY050
             , QTY051
             , QTY052
             , QTY053
             , QTY054
             , QTY055
             , QTY056
             , QTY057
             , QTY058
             , QTY059
             , QTY060
             , QTY061
             , QTY062
             , QTY063
             , QTY064
             , QTY065
             , QTY066
             , QTY067
             , QTY068
             , QTY069
             , QTY070
             , QTY071
             , QTY072
             , QTY073
             , QTY074
             , QTY075
             , QTY076
             , QTY077
             , QTY078
             , QTY079
             , QTY080
             , QTY081
             , QTY082
             , QTY083
             , QTY084
             , QTY085
             , QTY086
             , QTY087
             , QTY088
             , QTY089
             , QTY090
             , QTY091
             , QTY092
             , QTY093
             , QTY094
             , QTY095
             , QTY096
             , QTY097
             , QTY098
             , QTY099
             , QTY100
             , QTY101
             , QTY102
             , QTY103
             , QTY104
             , QTY105
             , QTY106
             , QTY107
             , QTY108
             , QTY109
             , QTY110
             , QTY111
             , QTY112
             , QTY113
             , QTY114
             , QTY115
             , QTY116
             , QTY117
             , QTY118
             , QTY119
             , QTY120
             , QTY121
             , QTY122
             , QTY123
             , QTY124
             , QTY125
             , QTY126
             , QTY127
             , QTY128
             , QTY129
             , QTY130
             , QTY131
             , QTY132
             , QTY133
             , QTY134
             , QTY135
             , QTY136
             , QTY137
             , QTY138
             , QTY139
             , QTY140
             , QTY141
             , QTY142
             , QTY143
             , QTY144
             , QTY145
             , QTY146
             , QTY147
             , QTY148
             , QTY149
             , QTY150
             , QTY151
             , QTY152
             , QTY153
             , QTY154
             , QTY155
             , QTY156
             , QTY157
             , QTY158
             , QTY159
             , QTY160
             , QTY161
             , QTY162
             , QTY163
             , QTY164
             , QTY165
             , QTY166
             , QTY167
             , QTY168
             , QTY169
             , QTY170
             , QTY171
             , QTY172
             , QTY173
             , QTY174
             , QTY175
             , QTY176
             , QTY177
             , QTY178
             , QTY179
             , QTY180
             , QTY181
             , QTY182
             , QTY183
             , QTY184
             , QTY185
             , QTY186
             , QTY187
             , QTY188
             , QTY189
             , QTY190
             , QTY191
             , QTY192
             , QTY193
             , QTY194
             , QTY195
             , QTY196
             , QTY197
             , QTY198
             , QTY199
             , QTY200
             , QTY201
             , QTY202
             , QTY203
             , QTY204
             , QTY205
             , QTY206
             , QTY207
             , QTY208
             , QTY209
             , QTY210
             , QTY211
             , QTY212
             , QTY213
             , QTY214
             , QTY215
             , QTY216
             , QTY217
             , QTY218
             , QTY219
             , QTY220
             , QTY221
             , QTY222
             , QTY223
             , QTY224
             , QTY225
             , QTY226
             , QTY227
             , QTY228
             , QTY229
             , QTY230
             , QTY231
             , QTY232
             , QTY233
             , QTY234
             , QTY235
             , QTY236
             , QTY237
             , QTY238
             , QTY239
             , QTY240
             , QTY241
             , QTY242
             , QTY243
             , QTY244
             , QTY245
             , QTY246
             , QTY247
             , QTY248
             , QTY249
             , QTY250
             , QTY251
             , QTY252
             , QTY253
             , QTY254
             , QTY255
             , QTY256
             , QTY257
             , QTY258
             , QTY259
             , QTY260
             , QTY261
             , QTY262
             , QTY263
             , QTY264
             , QTY265
             , QTY266
             , QTY267
             , QTY268
             , QTY269
             , QTY270
             , QTY271
             , QTY272
             , QTY273
             , QTY274
             , QTY275
             , QTY276
             , QTY277
             , QTY278
             , QTY279
             , QTY280
             , QTY281
             , QTY282
             , QTY283
             , QTY284
             , QTY285
             , QTY286
             , QTY287
             , QTY288
             , QTY289
             , QTY290
             , QTY291
             , QTY292
             , QTY293
             , QTY294
             , QTY295
             , QTY296
             , QTY297
             , QTY298
             , QTY299
             , QTY300
             , QTY301
             , QTY302
             , QTY303
             , QTY304
             , QTY305
             , QTY306
             , QTY307
             , QTY308
             , QTY309
             , QTY310
             , QTY311
             , QTY312
             , QTY313
             , QTY314
             , QTY315
             , QTY316
             , QTY317
             , QTY318
             , QTY319
             , QTY320
             , QTY321
             , QTY322
             , QTY323
             , QTY324
             , QTY325
             , QTY326
             , QTY327
             , QTY328
             , QTY329
             , QTY330
             , QTY331
             , QTY332
             , QTY333
             , QTY334
             , QTY335
             , QTY336
             , QTY337
             , QTY338
             , QTY339
             , QTY340
             , QTY341
             , QTY342
             , QTY343
             , QTY344
             , QTY345
             , QTY346
             , QTY347
             , QTY348
             , QTY349
             , QTY350
             , QTY351
             , QTY352
             , QTY353
             , QTY354
             , QTY355
             , QTY356
             , QTY357
             , QTY358
             , QTY359
             , QTY360
             , QTY361
             , QTY362
             , QTY363
             , QTY364
             , WQTY01
             , WQTY02
             , WQTY03
             , WQTY04
             , WQTY05
             , WQTY06
             , WQTY07
             , WQTY08
             , WQTY09
             , WQTY10
             , WQTY11
             , WQTY12
             , WQTY13
             , WQTY14
             , WQTY15
             , WQTY16
             , WQTY17
             , WQTY18
             , WQTY19
             , WQTY20
             , WQTY21
             , WQTY22
             , WQTY23
             , WQTY24
             , WQTY25
             , WQTY26
             , WQTY27
             , WQTY28
             , WQTY29
             , WQTY30
             , WQTY31
             , WQTY32
             , WQTY33
             , WQTY34
             , WQTY35
             , WQTY36
             , WQTY37
             , WQTY38
             , WQTY39
             , WQTY40
             , WQTY41
             , WQTY42
             , WQTY43
             , WQTY44
             , WQTY45
             , WQTY46
             , WQTY47
             , WQTY48
             , WQTY49
             , WQTY50
             , WQTY51
             , WQTY52
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             )
        SELECT Y.DIVISION_ID
             , Y.PLAN_START_YYYYMMDD
             , Y.CREATE_FROM_YYYYMMDD
             , Y.CREATE_TO_YYYYMMDD
             , Y.PLAN_TYPE
             , Y.SEQ
             , Y.OPERATION_GROUP
             , Y.OPERATION_GROUP_NAME
             , Y.CELL_ITEM_ID
             , Y.ITEM_ID
             , Y.NICK_NAME
             , Y.CELL_QTY_PACK
             , Y.TO_SITE
             , Y.TO_SITE_DESCRIPTION
             , Y.PROJECT_CODE
             , Y.FROM_BOH_QTY
             , Y.TO_BOH_QTY
             , Y.INCOTERMS
             , Y.FROM_SITE
             , Y.FROM_SITE_DESCRIPTION
             , Y.TRANSPORT_MODE
             , Y.PROD_LINE
             , Y.LT_DAY
             , Y.BOD_ID
             , 'PACK_CELL_BOH_HOLD'                 AS MEASURE
             , 'Cell BOH(Hold)'                     AS MEASURE_LABEL
               /* --							, Y.XLS_KEY1 100*10000          AS XLS_KEY1 -- 레코드 추가시의 충돌오류 회피를 위해 키값에 백만을 곱하기 */
             , Y.XLS_KEY1 + 1000000                 AS XLS_KEY1  /* 레코드 추가시의 충돌오류 회피를 위해 키값에 백만을 곱하기 */
             , Y.XLS_KEY2
             , Y.XLS_KEY3
             , Y.XLS_KEY4
             , Y.XLS_KEY5
             , Y.XLS_ATTRIBUTE1
             , Y.XLS_ATTRIBUTE2
             , Y.XLS_ATTRIBUTE3
             , Y.XLS_ATTRIBUTE4
             , Y.XLS_ATTRIBUTE5
             , B.SORT_ORDER_NO + 5                  AS SORT_ORDER_NO
             , 0                                      AS QTY001
             , 0                                      AS QTY002
             , 0                                      AS QTY003
             , 0                                      AS QTY004
             , 0                                      AS QTY005
             , 0                                      AS QTY006
             , 0                                      AS QTY007
             , 0                                      AS QTY008
             , 0                                      AS QTY009
             , 0                                      AS QTY010
             , 0                                      AS QTY011
             , 0                                      AS QTY012
             , 0                                      AS QTY013
             , 0                                      AS QTY014
             , 0                                      AS QTY015
             , 0                                      AS QTY016
             , 0                                      AS QTY017
             , 0                                      AS QTY018
             , 0                                      AS QTY019
             , 0                                      AS QTY020
             , 0                                      AS QTY021
             , 0                                      AS QTY022
             , 0                                      AS QTY023
             , 0                                      AS QTY024
             , 0                                      AS QTY025
             , 0                                      AS QTY026
             , 0                                      AS QTY027
             , 0                                      AS QTY028
             , 0                                      AS QTY029
             , 0                                      AS QTY030
             , 0                                      AS QTY031
             , 0                                      AS QTY032
             , 0                                      AS QTY033
             , 0                                      AS QTY034
             , 0                                      AS QTY035
             , 0                                      AS QTY036
             , 0                                      AS QTY037
             , 0                                      AS QTY038
             , 0                                      AS QTY039
             , 0                                      AS QTY040
             , 0                                      AS QTY041
             , 0                                      AS QTY042
             , 0                                      AS QTY043
             , 0                                      AS QTY044
             , 0                                      AS QTY045
             , 0                                      AS QTY046
             , 0                                      AS QTY047
             , 0                                      AS QTY048
             , 0                                      AS QTY049
             , 0                                      AS QTY050
             , 0                                      AS QTY051
             , 0                                      AS QTY052
             , 0                                      AS QTY053
             , 0                                      AS QTY054
             , 0                                      AS QTY055
             , 0                                      AS QTY056
             , 0                                      AS QTY057
             , 0                                      AS QTY058
             , 0                                      AS QTY059
             , 0                                      AS QTY060
             , 0                                      AS QTY061
             , 0                                      AS QTY062
             , 0                                      AS QTY063
             , 0                                      AS QTY064
             , 0                                      AS QTY065
             , 0                                      AS QTY066
             , 0                                      AS QTY067
             , 0                                      AS QTY068
             , 0                                      AS QTY069
             , 0                                      AS QTY070
             , 0                                      AS QTY071
             , 0                                      AS QTY072
             , 0                                      AS QTY073
             , 0                                      AS QTY074
             , 0                                      AS QTY075
             , 0                                      AS QTY076
             , 0                                      AS QTY077
             , 0                                      AS QTY078
             , 0                                      AS QTY079
             , 0                                      AS QTY080
             , 0                                      AS QTY081
             , 0                                      AS QTY082
             , 0                                      AS QTY083
             , 0                                      AS QTY084
             , 0                                      AS QTY085
             , 0                                      AS QTY086
             , 0                                      AS QTY087
             , 0                                      AS QTY088
             , 0                                      AS QTY089
             , 0                                      AS QTY090
             , 0                                      AS QTY091
             , 0                                      AS QTY092
             , 0                                      AS QTY093
             , 0                                      AS QTY094
             , 0                                      AS QTY095
             , 0                                      AS QTY096
             , 0                                      AS QTY097
             , 0                                      AS QTY098
             , 0                                      AS QTY099
             , 0                                      AS QTY100
             , 0                                      AS QTY101
             , 0                                      AS QTY102
             , 0                                      AS QTY103
             , 0                                      AS QTY104
             , 0                                      AS QTY105
             , 0                                      AS QTY106
             , 0                                      AS QTY107
             , 0                                      AS QTY108
             , 0                                      AS QTY109
             , 0                                      AS QTY110
             , 0                                      AS QTY111
             , 0                                      AS QTY112
             , 0                                      AS QTY113
             , 0                                      AS QTY114
             , 0                                      AS QTY115
             , 0                                      AS QTY116
             , 0                                      AS QTY117
             , 0                                      AS QTY118
             , 0                                      AS QTY119
             , 0                                      AS QTY120
             , 0                                      AS QTY121
             , 0                                      AS QTY122
             , 0                                      AS QTY123
             , 0                                      AS QTY124
             , 0                                      AS QTY125
             , 0                                      AS QTY126
             , 0                                      AS QTY127
             , 0                                      AS QTY128
             , 0                                      AS QTY129
             , 0                                      AS QTY130
             , 0                                      AS QTY131
             , 0                                      AS QTY132
             , 0                                      AS QTY133
             , 0                                      AS QTY134
             , 0                                      AS QTY135
             , 0                                      AS QTY136
             , 0                                      AS QTY137
             , 0                                      AS QTY138
             , 0                                      AS QTY139
             , 0                                      AS QTY140
             , 0                                      AS QTY141
             , 0                                      AS QTY142
             , 0                                      AS QTY143
             , 0                                      AS QTY144
             , 0                                      AS QTY145
             , 0                                      AS QTY146
             , 0                                      AS QTY147
             , 0                                      AS QTY148
             , 0                                      AS QTY149
             , 0                                      AS QTY150
             , 0                                      AS QTY151
             , 0                                      AS QTY152
             , 0                                      AS QTY153
             , 0                                      AS QTY154
             , 0                                      AS QTY155
             , 0                                      AS QTY156
             , 0                                      AS QTY157
             , 0                                      AS QTY158
             , 0                                      AS QTY159
             , 0                                      AS QTY160
             , 0                                      AS QTY161
             , 0                                      AS QTY162
             , 0                                      AS QTY163
             , 0                                      AS QTY164
             , 0                                      AS QTY165
             , 0                                      AS QTY166
             , 0                                      AS QTY167
             , 0                                      AS QTY168
             , 0                                      AS QTY169
             , 0                                      AS QTY170
             , 0                                      AS QTY171
             , 0                                      AS QTY172
             , 0                                      AS QTY173
             , 0                                      AS QTY174
             , 0                                      AS QTY175
             , 0                                      AS QTY176
             , 0                                      AS QTY177
             , 0                                      AS QTY178
             , 0                                      AS QTY179
             , 0                                      AS QTY180
             , 0                                      AS QTY181
             , 0                                      AS QTY182
             , 0                                      AS QTY183
             , 0                                      AS QTY184
             , 0                                      AS QTY185
             , 0                                      AS QTY186
             , 0                                      AS QTY187
             , 0                                      AS QTY188
             , 0                                      AS QTY189
             , 0                                      AS QTY190
             , 0                                      AS QTY191
             , 0                                      AS QTY192
             , 0                                      AS QTY193
             , 0                                      AS QTY194
             , 0                                      AS QTY195
             , 0                                      AS QTY196
             , 0                                      AS QTY197
             , 0                                      AS QTY198
             , 0                                      AS QTY199
             , 0                                      AS QTY200
             , 0                                      AS QTY201
             , 0                                      AS QTY202
             , 0                                      AS QTY203
             , 0                                      AS QTY204
             , 0                                      AS QTY205
             , 0                                      AS QTY206
             , 0                                      AS QTY207
             , 0                                      AS QTY208
             , 0                                      AS QTY209
             , 0                                      AS QTY210
             , 0                                      AS QTY211
             , 0                                      AS QTY212
             , 0                                      AS QTY213
             , 0                                      AS QTY214
             , 0                                      AS QTY215
             , 0                                      AS QTY216
             , 0                                      AS QTY217
             , 0                                      AS QTY218
             , 0                                      AS QTY219
             , 0                                      AS QTY220
             , 0                                      AS QTY221
             , 0                                      AS QTY222
             , 0                                      AS QTY223
             , 0                                      AS QTY224
             , 0                                      AS QTY225
             , 0                                      AS QTY226
             , 0                                      AS QTY227
             , 0                                      AS QTY228
             , 0                                      AS QTY229
             , 0                                      AS QTY230
             , 0                                      AS QTY231
             , 0                                      AS QTY232
             , 0                                      AS QTY233
             , 0                                      AS QTY234
             , 0                                      AS QTY235
             , 0                                      AS QTY236
             , 0                                      AS QTY237
             , 0                                      AS QTY238
             , 0                                      AS QTY239
             , 0                                      AS QTY240
             , 0                                      AS QTY241
             , 0                                      AS QTY242
             , 0                                      AS QTY243
             , 0                                      AS QTY244
             , 0                                      AS QTY245
             , 0                                      AS QTY246
             , 0                                      AS QTY247
             , 0                                      AS QTY248
             , 0                                      AS QTY249
             , 0                                      AS QTY250
             , 0                                      AS QTY251
             , 0                                      AS QTY252
             , 0                                      AS QTY253
             , 0                                      AS QTY254
             , 0                                      AS QTY255
             , 0                                      AS QTY256
             , 0                                      AS QTY257
             , 0                                      AS QTY258
             , 0                                      AS QTY259
             , 0                                      AS QTY260
             , 0                                      AS QTY261
             , 0                                      AS QTY262
             , 0                                      AS QTY263
             , 0                                      AS QTY264
             , 0                                      AS QTY265
             , 0                                      AS QTY266
             , 0                                      AS QTY267
             , 0                                      AS QTY268
             , 0                                      AS QTY269
             , 0                                      AS QTY270
             , 0                                      AS QTY271
             , 0                                      AS QTY272
             , 0                                      AS QTY273
             , 0                                      AS QTY274
             , 0                                      AS QTY275
             , 0                                      AS QTY276
             , 0                                      AS QTY277
             , 0                                      AS QTY278
             , 0                                      AS QTY279
             , 0                                      AS QTY280
             , 0                                      AS QTY281
             , 0                                      AS QTY282
             , 0                                      AS QTY283
             , 0                                      AS QTY284
             , 0                                      AS QTY285
             , 0                                      AS QTY286
             , 0                                      AS QTY287
             , 0                                      AS QTY288
             , 0                                      AS QTY289
             , 0                                      AS QTY290
             , 0                                      AS QTY291
             , 0                                      AS QTY292
             , 0                                      AS QTY293
             , 0                                      AS QTY294
             , 0                                      AS QTY295
             , 0                                      AS QTY296
             , 0                                      AS QTY297
             , 0                                      AS QTY298
             , 0                                      AS QTY299
             , 0                                      AS QTY300
             , 0                                      AS QTY301
             , 0                                      AS QTY302
             , 0                                      AS QTY303
             , 0                                      AS QTY304
             , 0                                      AS QTY305
             , 0                                      AS QTY306
             , 0                                      AS QTY307
             , 0                                      AS QTY308
             , 0                                      AS QTY309
             , 0                                      AS QTY310
             , 0                                      AS QTY311
             , 0                                      AS QTY312
             , 0                                      AS QTY313
             , 0                                      AS QTY314
             , 0                                      AS QTY315
             , 0                                      AS QTY316
             , 0                                      AS QTY317
             , 0                                      AS QTY318
             , 0                                      AS QTY319
             , 0                                      AS QTY320
             , 0                                      AS QTY321
             , 0                                      AS QTY322
             , 0                                      AS QTY323
             , 0                                      AS QTY324
             , 0                                      AS QTY325
             , 0                                      AS QTY326
             , 0                                      AS QTY327
             , 0                                      AS QTY328
             , 0                                      AS QTY329
             , 0                                      AS QTY330
             , 0                                      AS QTY331
             , 0                                      AS QTY332
             , 0                                      AS QTY333
             , 0                                      AS QTY334
             , 0                                      AS QTY335
             , 0                                      AS QTY336
             , 0                                      AS QTY337
             , 0                                      AS QTY338
             , 0                                      AS QTY339
             , 0                                      AS QTY340
             , 0                                      AS QTY341
             , 0                                      AS QTY342
             , 0                                      AS QTY343
             , 0                                      AS QTY344
             , 0                                      AS QTY345
             , 0                                      AS QTY346
             , 0                                      AS QTY347
             , 0                                      AS QTY348
             , 0                                      AS QTY349
             , 0                                      AS QTY350
             , 0                                      AS QTY351
             , 0                                      AS QTY352
             , 0                                      AS QTY353
             , 0                                      AS QTY354
             , 0                                      AS QTY355
             , 0                                      AS QTY356
             , 0                                      AS QTY357
             , 0                                      AS QTY358
             , 0                                      AS QTY359
             , 0                                      AS QTY360
             , 0                                      AS QTY361
             , 0                                      AS QTY362
             , 0                                      AS QTY363
             , 0                                      AS QTY364
             , 0                                      AS WQTY01
             , 0                                      AS WQTY02
             , 0                                      AS WQTY03
             , 0                                      AS WQTY04
             , 0                                      AS WQTY05
             , 0                                      AS WQTY06
             , 0                                      AS WQTY07
             , 0                                      AS WQTY08
             , 0                                      AS WQTY09
             , 0                                      AS WQTY10
             , 0                                      AS WQTY11
             , 0                                      AS WQTY12
             , 0                                      AS WQTY13
             , 0                                      AS WQTY14
             , 0                                      AS WQTY15
             , 0                                      AS WQTY16
             , 0                                      AS WQTY17
             , 0                                      AS WQTY18
             , 0                                      AS WQTY19
             , 0                                      AS WQTY20
             , 0                                      AS WQTY21
             , 0                                      AS WQTY22
             , 0                                      AS WQTY23
             , 0                                      AS WQTY24
             , 0                                      AS WQTY25
             , 0                                      AS WQTY26
             , 0                                      AS WQTY27
             , 0                                      AS WQTY28
             , 0                                      AS WQTY29
             , 0                                      AS WQTY30
             , 0                                      AS WQTY31
             , 0                                      AS WQTY32
             , 0                                      AS WQTY33
             , 0                                      AS WQTY34
             , 0                                      AS WQTY35
             , 0                                      AS WQTY36
             , 0                                      AS WQTY37
             , 0                                      AS WQTY38
             , 0                                      AS WQTY39
             , 0                                      AS WQTY40
             , 0                                      AS WQTY41
             , 0                                      AS WQTY42
             , 0                                      AS WQTY43
             , 0                                      AS WQTY44
             , 0                                      AS WQTY45
             , 0                                      AS WQTY46
             , 0                                      AS WQTY47
             , 0                                      AS WQTY48
             , 0                                      AS WQTY49
             , 0                                      AS WQTY50
             , 0                                      AS WQTY51
             , 0                                      AS WQTY52
             , Y.CREATED_BY
             , Y.CREATION_DATE
             , Y.LAST_UPDATED_BY
             , Y.LAST_UPDATE_DATE
             , Y.ATTRIBUTE1
             , Y.ATTRIBUTE2
             , Y.ATTRIBUTE3
             , Y.ATTRIBUTE4
             , Y.ATTRIBUTE5
             , Y.ATTRIBUTE6
             , Y.ATTRIBUTE7
             , Y.ATTRIBUTE8
             , Y.ATTRIBUTE9
             , Y.ATTRIBUTE10
          FROM (SELECT S.CELL_ITEM_ID
                     , S.ITEM_ID
                     , S.FROM_SITE
                     , SUM(S.CNT)                           AS CNT
                  FROM (SELECT A.CELL_ITEM_ID
                             , A.ITEM_ID
                             , A.FROM_SITE
                             , (CASE WHEN A.MEASURE = 'PACK_CELL_BOH' THEN 1 ELSE 2 END) AS CNT
                          FROM SCP_XLS_PSI_GLOBAL_SMALL A
                         WHERE A.DIVISION_ID          = V_DIVISION_ID
                           AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
                           AND A.MEASURE             IN ('PACK_CELL_BOH_HOLD', 'PACK_CELL_BOH')
                           AND A.CELL_ITEM_ID IS NOT NULL
                       ) S
                 GROUP BY S.CELL_ITEM_ID
                        , S.ITEM_ID
                        , S.FROM_SITE
               )                        X
             , SCP_XLS_PSI_GLOBAL_SMALL Y
             , (SELECT SA.COLUMN_NAME
                     , SA.SORT_ORDER_NO
                  FROM SCM_MST_SHEET_MEASURE SA
                 WHERE SA.COLUMN_NAME = 'PACK_CELL_BOH'
                   AND SA.PROGRAM_ID  = 'XLSPSI01'
               )                        B
         WHERE X.CELL_ITEM_ID         = Y.CELL_ITEM_ID
           AND X.ITEM_ID              = Y.ITEM_ID
           AND X.FROM_SITE            = Y.FROM_SITE
           AND Y.MEASURE              = B.COLUMN_NAME
           AND X.CNT                  = 1
           AND Y.DIVISION_ID          = V_DIVISION_ID
           AND Y.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
           AND Y.MEASURE              = 'PACK_CELL_BOH'
           AND Y.CELL_ITEM_ID IS NOT NULL
        ;

        /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 051 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* 2022.10.11 KSW W01 ~ W08 주차 합산 생산계획이 0 일 경우 1 추가 건에 대한 처리 - START */
        /* W01 ~ W08 주차 0 엔진계획이 0 값 모델 리스트 */
        IF V_PLAN_TYPE = 'PR' AND V_CREATE_FROM_YYYYMMDD = V_PLAN_START_YYYYMMDD THEN
            /* IF OBJECT_ID('tempdb..#tmp_W1W8_ZERO_MODEL') IS NOT NULL DROP TABLE #tmp_W1W8_ZERO_MODEL
               #tmp_W1W8_ZERO_MODEL 은 아래 반영 한 곳에서만 쓰여 EXISTS 조건으로 옮김 */

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 052 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            UPDATE SCP_XLS_PSI_GLOBAL_SMALL X
               SET X.XLS_ATTRIBUTE1 = 'A_SET'
                   /* --,X.QTY001 = 1 -- 저장할 때 1값 저장하는 것으로 변경 */
                   /* --,X.WQTY01 = 1 */
             WHERE EXISTS (SELECT 1
                             FROM (SELECT S.ITEM_ID
                                        , S.SCM_SITE_ID
                                        , S.LINE_ID
                                     FROM (SELECT SA.ITEM_ID
                                                , SA.SCM_SITE_ID
                                                , SA.LINE_ID
                                                , SUM(SA.QTY)        AS S_QTY
                                             FROM SCP_ANL_PRODUCTION_PLAN SA
                                            WHERE SA.DIVISION_ID         = V_DIVISION_ID
                                              AND SA.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                              AND SA.PLAN_TYPE           = V_PLAN_TYPE
                                              AND SA.SEQ                 = V_SEQ
                                              AND SA.MEASURE             = 'PROD_PLAN_AMEND'
                                              /* --AND YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND CONVERT(VARCHAR(8), DATEADD(day, 7 * 8, @p_plan_start_yyyymmdd), 112) */
                                              AND SA.YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND V_CREATE_TO_YYYYMMDD  /* 8주에서 전체 플랜구간 */
                                            GROUP BY SA.ITEM_ID
                                                   , SA.SCM_SITE_ID
                                                   , SA.LINE_ID
                                          ) S
                                    WHERE S.S_QTY = 0
                                  ) Z  /* AS-IS #tmp_W1W8_ZERO_MODEL */
                            WHERE X.ITEM_ID   = Z.ITEM_ID
                              AND X.FROM_SITE = Z.SCM_SITE_ID
                              AND X.PROD_LINE = Z.LINE_ID)
               AND X.DIVISION_ID          = V_DIVISION_ID
               AND X.PLAN_START_YYYYMMDD  = V_PLAN_START_YYYYMMDD
               AND X.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD
               AND X.PLAN_TYPE            = V_PLAN_TYPE
               AND X.SEQ                  = V_SEQ
               AND X.MEASURE             IN ('PACK_PROD', 'CELL_PROD')
            ;

            /* E20260408-000979 소형사업부 SCP 엔진수행 속도 튜닝 요청 */
            V_LOG_MESSAGE := '########## log step ##########';
            V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 053 ';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => 'TXN'
                                , P_LOG_COUNT    => 0
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );

            /* IF OBJECT_ID('tempdb..#tmp_W1W8_ZERO_MODEL') IS NOT NULL DROP TABLE #tmp_W1W8_ZERO_MODEL */
        END IF;
        /* 2022.10.11 KSW W01 ~ W08 주차 합산 생산계획이 0 일 경우 1 추가 건에 대한 처리 - END */

        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        IF P_IS_DEBUG = '0' THEN
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => V_LOG_TYPE
                                , P_LOG_COUNT    => N_LOG_COUNT
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );
        END IF;

    EXCEPTION  /* BEGIN CATCH */
        WHEN OTHERS THEN
            /* --IF @@TRANCOUNT > 0 */
            /* --  BEGIN */
            /* --    ROLLBACK TRAN T1 */
            /* --  END; */

            /* ERROR LOG */
            V_SQL_ERR_CODE  := TO_CHAR(SQLCODE);
            V_SQL_ERR_MSG   := SUBSTR(SQLERRM, 1, 2000);
            V_SQL_BACKTRACE := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
            V_LOG_TYPE      := 'ERROR';
            V_LOG_MESSAGE   := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION   := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || V_SQL_BACKTRACE, 1, 500);
            D_EVENT_DATE    := SYSDATE;
            IF P_IS_DEBUG = '0' THEN
                PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                                    , P_LOG_TYPE      => V_LOG_TYPE
                                    , P_LOG_COUNT     => N_LOG_COUNT
                                    , P_LOG_MESSAGE   => V_LOG_MESSAGE
                                    , P_DESCRIPTION   => V_DESCRIPTION
                                    , P_EVENT_DATE    => D_EVENT_DATE
                                    , P_USER_ID       => V_BATCH_USER
                                    , P_SQL_ERR_CODE  => V_SQL_ERR_CODE
                                    , P_SQL_ERR_MSG   => V_SQL_ERR_MSG
                                    , P_SQL_BACKTRACE => V_SQL_BACKTRACE
                                    );
            END IF;
            /* -- PRINT @@ERROR */
            O_RETURN := -1;
            RETURN;  /* return -1 */
    END;  /* END CATCH; */

    /* 임시 운영반영시에 주석처리 할것. */
    N_EXEC_SEC  := ROUND((SYSDATE - V_START_TIME) * 86400);
    V_EXEC_TIME := CASE WHEN TRUNC(N_EXEC_SEC / 60) < 100
                        THEN LPAD(TO_CHAR(TRUNC(N_EXEC_SEC / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(N_EXEC_SEC, 60)), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '[' || V_MASTER_ID || '][' || V_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;
    IF P_IS_DEBUG = '0' THEN
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );
    END IF;
    O_RETURN := 1;
    RETURN;  /* return 1 */
END;