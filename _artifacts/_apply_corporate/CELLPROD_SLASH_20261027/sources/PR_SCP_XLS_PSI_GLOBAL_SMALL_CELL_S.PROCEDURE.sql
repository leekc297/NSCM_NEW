PROCEDURE PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S
(
      P_PLAN_CYCLE            IN  VARCHAR2                       /* NVARCHAR(0150) */
    , P_PLAN_START_YYYYMMDD   IN  VARCHAR2                       /* NVARCHAR(0008) */
    , P_PLAN_ID               IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_MODELING_ID           IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_SEQ                   IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_PLAN_TYPE             IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_MASTER_ID             IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_DIVISION_ID           IN  VARCHAR2                       /* NVARCHAR(0030) */
    , P_ENGINE_PLAN_ID        IN  VARCHAR2                       /* NVARCHAR(4000) */
    , P_UPDATE                IN  VARCHAR2 DEFAULT 'N'           /* NVARCHAR(4000)  = 'N' */
    , P_CREATE_FROM_YYYYMMDD  IN  VARCHAR2                       /* NVARCHAR(0008) */
    , P_CREATE_TO_YYYYMMDD    IN  VARCHAR2                       /* NVARCHAR(0008) */
    , P_USER_ID               IN  VARCHAR2 DEFAULT 'SCP_batch'   /* NVARCHAR(0150)  = 'SCP_batch' */
    /* ---- , @p_debug       INT OUTPUT */
    , O_RETURN                OUT NUMBER                         /* AS-IS RETURN 값 → OUT 인자(CNS 가이드) */
)
/*
 * Program ID   : PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S
 * Description  : PR_SCP_XLS_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Execute      :
    -- DELETE FROM SCM_SYS_LOG_BATCH where CREATED_BY ='kth'
    EXEC PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S
                                 @p_plan_cycle          = 'WEEKLY'
                               , @p_plan_start_yyyymmdd = '20190107'
                               , @p_plan_id             = '1060'
                               , @p_modeling_id         = '2'
                               , @p_seq                 = '1'
                               , @p_plan_type           = 'PR'
                               , @p_master_id           = '81::WEEKLY'
                               , @p_division_id         = '81'
                               , @p_engine_plan_id      = '1060::PR::1'
                               , @p_user_id             = 'KTH'
    SELECT * FROM SCM_SYS_LOG_BATCH  where PROGRAM_NAME ='PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S' order by CREATION_DATE desc

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.05.25   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전으로 신규생성
                            - 구 버전에서 PIVOT 생성단계 이후 단계를 호출하는 로직으로 분리함 (1 YEAR 구간별 생성 :: 중장기 구현시 컬럼 및 행 SIZE 제약 해결)
 * 2026.07.24   YMH         E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건
 * 2026.10.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 */
/* DROP PROC dbo.PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S */
IS
    /* SET TRANSACTION ISOLATION LEVEL READ COMMITTED; SET NOCOUNT ON; SET XACT_ABORT ON; */
    /* --SET ANSI_WARNINGS OFF; */
    /* SET ANSI_WARNINGS ON; SET ANSI_NULLS ON; (Oracle 기본 동작) */

    /* AS-IS 인자 선언 길이 재현 : NVARCHAR(0008) · NVARCHAR(0030) · NVARCHAR(0150) */
    V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR)    := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 8);
    V_DIVISION_ID           VARCHAR2(30 CHAR)   := SUBSTR(P_DIVISION_ID, 1, 30);
    V_CREATE_FROM_YYYYMMDD  VARCHAR2(8 CHAR)    := SUBSTR(P_CREATE_FROM_YYYYMMDD, 1, 8);
    V_CREATE_TO_YYYYMMDD    VARCHAR2(8 CHAR)    := SUBSTR(P_CREATE_TO_YYYYMMDD, 1, 8);
    V_USER_ID               VARCHAR2(150 CHAR)  := SUBSTR(P_USER_ID, 1, 150);
    N_SEQ                   NUMBER(19);          /* @p_seq 를 BIGINT 칸과 비교할 때의 암묵 변환 재현 */

    /* LOG 용 변수 설정 */
    V_BATCH_USER            VARCHAR2(150 CHAR)  := 'SCP_batch';
    V_PROGRAM_NAME          VARCHAR2(150 CHAR)  := 'PR_SCP_XLS_PSI_GLOBAL_SMALL_CELL_S';
    V_LOG_TYPE              VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT             NUMBER(10)          := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    V_TABLE_ID              VARCHAR2(150 CHAR)  := 'SCM_SYS_LOG_BATC';
    D_EVENT_DATE            DATE;

    /* 실행시간 확인용 */
    V_START_TIME            DATE;
    V_EXEC_TIME             VARCHAR2(10 CHAR)   := NULL;  /* --'00:00'; */

    V_PROGRAM_ID            VARCHAR2(30 CHAR)   := 'XLSPSI03';
    /* DECLARE @p_to_yyyymmdd  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112) */
    /* DECLARE @p_cutoff_date  VARCHAR(8)   =  CONVERT(VARCHAR(8), DATEADD(day,  -1, @p_plan_start_yyyymmdd), 112) */

    N_MAX_XLS_KEY1          NUMBER(10)          := 0;  /* @p_update가 'Y' 일경우  전체 xls_key1 MAX */

    N_SSP_MODIFY_YIELD      NUMBER(20,10)       := 0.0;

    /* 원문 #Rn · #CALENDAR · #HEADER 대체 : 생성 구간 일자 수(일자 칸 QTY001~QTY364 와 주 칸 WQTY01~WQTY52 의 대응) */
    N_DAY_CNT               NUMBER(10)          := 0;

    /* 오류 로그용 */
    V_IN_PARA_DATA          VARCHAR2(4000 CHAR);
BEGIN
    O_RETURN := 1;  /* 반환값 초기화 (AS-IS 정상 종료값 return 1) */

    V_BATCH_USER := V_USER_ID;  /* SET @v_batch_user = @p_user_id */

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );

    /* 실행시간 확인용 */
    V_START_TIME := SYSDATE;

    IF P_UPDATE = 'Y' THEN
        SELECT NVL(MAX(XLS_KEY1), 0) + 1
          INTO N_MAX_XLS_KEY1
          FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL;
    END IF;

    /* DECLARE @debug_mode            NVARCHAR(30) = 'T' */
    BEGIN  /* BEGIN TRY */

        N_SEQ := TO_NUMBER(P_SEQ);

        /* ------------------------------------------------------------------------------------------------------------- */
        /* Line Load 율 - 1 YEAR 단위로 분리하기가 어려워 개발 생성 처리한다. */
        /* ------------------------------------------------------------------------------------------------------------- */
        DELETE FROM GT_XPSC_LINELOAD;  /* IF OBJECT_ID('tempdb..#LineLoad') IS NOT NULL DROP TABLE #LineLoad; */

        INSERT
          INTO GT_XPSC_LINELOAD
             ( DIVISION_ID
             , SITE_ID
             , OPERATION_GROUP
             , OPERATION_ID
             , PROD_LINE
             , MEASURE
             , QTY
             , CAPA_TACT
             , WORKING_TIME
             , YYYYMMDD
             , ISO_YYYYWW
             , WEEK_COLUMN
             )
        SELECT /* DISTINCT */
               A.DIVISION_ID
             , A.SCM_SITE_ID                                         AS SITE_ID
             , A.OPERATION_GROUP
             , A.OPERATION_ID
             , A.LINE_ID                                             AS PROD_LINE
             , 'PROD_LOAD'                                           AS MEASURE
             , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0 ELSE NVL( ( ( ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / D.WORKING_TIME ) ), 0 ) * 100 END AS QTY
             , NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0), 0)    AS CAPA_TACT
             , NVL( D.WORKING_TIME, 0 )                              AS WORKING_TIME
             , A.YYYYMMDD                                            AS YYYYMMDD
             , C.ISO_YYYYWW                                          AS ISO_YYYYWW
               /* 'WQTY' + REPLICATE('0', 2 - LEN(n)) + CONVERT(NVARCHAR, n) : 1년 구간이라 n 은 두 자리 이하 */
             , 'WQTY' || LPAD(TO_CHAR(DENSE_RANK() OVER(PARTITION BY A.LINE_ID ORDER BY C.ISO_YYYYWW)), 2, '0') AS WEEK_COLUMN
          FROM SCP_ANL_PRODUCTION_PLAN A
             , SCM_SYS_CALENDAR_M      C
             , GT_XPSC_LINE_WORKTIME   D
             , SCP_ANL_TACT_TIME       E
         WHERE A.YYYYMMDD            = C.BASIS_YYYYMMDD
           AND A.DIVISION_ID         = D.DIVISION_ID(+)
           AND A.OPERATION_ID        = D.OPERATION_ID(+)
           AND A.SCM_SITE_ID         = D.SCM_SITE_ID(+)
           AND A.LINE_ID             = D.LINE_ID(+)
           AND A.YYYYMMDD            = D.YYYYMMDD(+)
           AND A.DIVISION_ID         = E.DIVISION_ID(+)
           AND A.OPERATION_ID        = E.OPERATION_ID(+)
           AND A.SCM_SITE_ID         = E.SCM_SITE_ID(+)
           AND A.LINE_ID             = E.LINE_ID(+)
           AND A.ITEM_ID             = E.ITEM_ID(+)
           AND A.YYYYMMDD            = E.YYYYMMDD(+)
           AND A.MEASURE             = 'PROD_PLAN_AMEND'
           AND A.OPERATION_GROUP     = 'A'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = N_SEQ
           AND A.YYYYMMDD           >= V_CREATE_FROM_YYYYMMDD
           AND A.YYYYMMDD           <= V_CREATE_TO_YYYYMMDD
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.OPERATION_ID
                , A.LINE_ID
                , A.YYYYMMDD
                , D.WORKING_TIME
                , C.ISO_YYYYWW
                , A.OPERATION_GROUP;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 00100 ';
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
        /* 전체 임시 테이블 생성  (#SCP_XLS_PSI_GLOBAL_SMALL_CELL) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#SCP_XLS_PSI_GLOBAL_SMALL_CELL') IS NOT NULL DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_CELL */
        /* --DROP TABLE #SCP_XLS_PSI_GLOBAL_SMALL_CELLL */
        /* CREATE TABLE #SCP_XLS_PSI_GLOBAL_SMALL_CELL → GTT GT_XPSC_XLS_PSI_SMALL_CELL */
        /*   MEASURE_LABEL : COLUMN_LABEL_NAME , SITE_DESCRIPTION : SCM_SITE_DESCRIPTION , QTY001 : 신규 */
        /*   --                CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE */
        /*   ATTRIBUTE9 : OPERATION_ID */
        DELETE FROM GT_XPSC_XLS_PSI_SMALL_CELL;

        /* ------------------------------------------------------------------------------------------------------------- */
        /*  364일 데이터 생성(PIVOIT 대상 날짜문자열 생성) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* AS-IS 는 생성 구간 달력 일자를 정렬순으로 번호 매겨 'SUM(CASE WHEN YYYYMMDD = ''일자'' THEN QTY ELSE 0 END ) AS QTYnnn' 를 */
        /* 문자열로 조립하고 sp_executesql 로 실행 → 같은 번호 매김(IA.RN)을 정적 SQL 로 옮김 (조립 문자열 @mQry_sum 대체) */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 00200 ';
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
        /* 전체 DATA 생성 (#PSI_GLOBAL_SMALL_CELL --> #SCP_XLS_PSI_GLOBAL_SMALL_CELL) PIVOT */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* DECLARE @mEXEC NVARCHAR(MAX); → 정적 SQL */
        /* PROD_LINE : 원문 ISNULL(A.PROD_LINE,'-') 이나 부르는 쪽이 넣는 빈 문자('')는 Oracle 에서 NULL 이 되므로 */
        /*             NVL 을 걸면 '' 자리가 '-' 로 바뀜 → 부르는 쪽 원천에 실제 NULL 이 없어(빈 문자만 있음) NVL 미적용 */
        INSERT
          INTO GT_XPSC_XLS_PSI_SMALL_CELL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , CELL_TYPE_GROUP_CODE
             , CELL_ITEM_ID
             , NICK_NAME
             , MEASURE
             , MEASURE_LABEL
             , SITE_ID
             , SITE_DESCRIPTION
             , PROD_LINE
             , YIELD
             , LT_WEEK
             , BOH
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
             , V_PLAN_START_YYYYMMDD                                  AS PLAN_START_YYYYMMDD
             , P_PLAN_TYPE                                            AS PLAN_TYPE
             , N_SEQ                                                  AS SEQ
             , A.CELL_TYPE_GROUP_CODE
             , A.CELL_ITEM_ID
             , (SELECT (CASE WHEN SA.NICK_NAME IS NULL THEN '-' ELSE SA.NICK_NAME END)  /* WHEN X.NICK_NAME = '' THEN '-' 는 Oracle 에서 IS NULL 과 같음 */
                  FROM SCM_MST_ITEM_SN SA
                 WHERE SA.ITEM_ID = A.CELL_ITEM_ID
                   AND ROWNUM     = 1)                                AS NICK_NAME
             , A.MEASURE
             , A.COLUMN_LABEL_NAME                                    AS MEASURE_LABEL
             , A.SITE_ID
             , NVL((SELECT XA.SITE_DESCRIPTION
                      FROM SCM_MST_SITE XA
                     WHERE XA.SCM_SITE_ID = A.SITE_ID
                       AND ROWNUM         = 1), '-')                  AS SITE_DESCRIPTION  /* ISNULL(NULLIF((SELECT TOP 1 ..), ''), '-') */
             , A.PROD_LINE                                            AS PROD_LINE
             , NVL(A.YIELD, 0)                                        AS YIELD
             , 0                                                      AS LT_WEEK
             , A.BOH
             , CAST(NULL AS VARCHAR2(200 CHAR))                       AS XLS_KEY1
             , CAST(NULL AS VARCHAR2(200 CHAR))                       AS XLS_KEY2
             , CAST(NULL AS VARCHAR2(200 CHAR))                       AS XLS_KEY3
             , CAST(NULL AS VARCHAR2(200 CHAR))                       AS XLS_KEY4
             , CAST(NULL AS VARCHAR2(200 CHAR))                       AS XLS_KEY5
             , CAST(NULL AS VARCHAR2(200 CHAR))                       AS XLS_ATTRIBUTE1
             , CAST(NULL AS VARCHAR2(200 CHAR))                       AS XLS_ATTRIBUTE2
             , CAST(NULL AS VARCHAR2(200 CHAR))                       AS XLS_ATTRIBUTE3
             , CAST(NULL AS VARCHAR2(200 CHAR))                       AS XLS_ATTRIBUTE4
             , CAST(NULL AS VARCHAR2(200 CHAR))                       AS XLS_ATTRIBUTE5
             , A.SORT_ORDER_NO
             , SUM(CASE WHEN IA.RN =   1 THEN A.QTY ELSE 0 END) AS QTY001
             , SUM(CASE WHEN IA.RN =   2 THEN A.QTY ELSE 0 END) AS QTY002
             , SUM(CASE WHEN IA.RN =   3 THEN A.QTY ELSE 0 END) AS QTY003
             , SUM(CASE WHEN IA.RN =   4 THEN A.QTY ELSE 0 END) AS QTY004
             , SUM(CASE WHEN IA.RN =   5 THEN A.QTY ELSE 0 END) AS QTY005
             , SUM(CASE WHEN IA.RN =   6 THEN A.QTY ELSE 0 END) AS QTY006
             , SUM(CASE WHEN IA.RN =   7 THEN A.QTY ELSE 0 END) AS QTY007
             , SUM(CASE WHEN IA.RN =   8 THEN A.QTY ELSE 0 END) AS QTY008
             , SUM(CASE WHEN IA.RN =   9 THEN A.QTY ELSE 0 END) AS QTY009
             , SUM(CASE WHEN IA.RN =  10 THEN A.QTY ELSE 0 END) AS QTY010
             , SUM(CASE WHEN IA.RN =  11 THEN A.QTY ELSE 0 END) AS QTY011
             , SUM(CASE WHEN IA.RN =  12 THEN A.QTY ELSE 0 END) AS QTY012
             , SUM(CASE WHEN IA.RN =  13 THEN A.QTY ELSE 0 END) AS QTY013
             , SUM(CASE WHEN IA.RN =  14 THEN A.QTY ELSE 0 END) AS QTY014
             , SUM(CASE WHEN IA.RN =  15 THEN A.QTY ELSE 0 END) AS QTY015
             , SUM(CASE WHEN IA.RN =  16 THEN A.QTY ELSE 0 END) AS QTY016
             , SUM(CASE WHEN IA.RN =  17 THEN A.QTY ELSE 0 END) AS QTY017
             , SUM(CASE WHEN IA.RN =  18 THEN A.QTY ELSE 0 END) AS QTY018
             , SUM(CASE WHEN IA.RN =  19 THEN A.QTY ELSE 0 END) AS QTY019
             , SUM(CASE WHEN IA.RN =  20 THEN A.QTY ELSE 0 END) AS QTY020
             , SUM(CASE WHEN IA.RN =  21 THEN A.QTY ELSE 0 END) AS QTY021
             , SUM(CASE WHEN IA.RN =  22 THEN A.QTY ELSE 0 END) AS QTY022
             , SUM(CASE WHEN IA.RN =  23 THEN A.QTY ELSE 0 END) AS QTY023
             , SUM(CASE WHEN IA.RN =  24 THEN A.QTY ELSE 0 END) AS QTY024
             , SUM(CASE WHEN IA.RN =  25 THEN A.QTY ELSE 0 END) AS QTY025
             , SUM(CASE WHEN IA.RN =  26 THEN A.QTY ELSE 0 END) AS QTY026
             , SUM(CASE WHEN IA.RN =  27 THEN A.QTY ELSE 0 END) AS QTY027
             , SUM(CASE WHEN IA.RN =  28 THEN A.QTY ELSE 0 END) AS QTY028
             , SUM(CASE WHEN IA.RN =  29 THEN A.QTY ELSE 0 END) AS QTY029
             , SUM(CASE WHEN IA.RN =  30 THEN A.QTY ELSE 0 END) AS QTY030
             , SUM(CASE WHEN IA.RN =  31 THEN A.QTY ELSE 0 END) AS QTY031
             , SUM(CASE WHEN IA.RN =  32 THEN A.QTY ELSE 0 END) AS QTY032
             , SUM(CASE WHEN IA.RN =  33 THEN A.QTY ELSE 0 END) AS QTY033
             , SUM(CASE WHEN IA.RN =  34 THEN A.QTY ELSE 0 END) AS QTY034
             , SUM(CASE WHEN IA.RN =  35 THEN A.QTY ELSE 0 END) AS QTY035
             , SUM(CASE WHEN IA.RN =  36 THEN A.QTY ELSE 0 END) AS QTY036
             , SUM(CASE WHEN IA.RN =  37 THEN A.QTY ELSE 0 END) AS QTY037
             , SUM(CASE WHEN IA.RN =  38 THEN A.QTY ELSE 0 END) AS QTY038
             , SUM(CASE WHEN IA.RN =  39 THEN A.QTY ELSE 0 END) AS QTY039
             , SUM(CASE WHEN IA.RN =  40 THEN A.QTY ELSE 0 END) AS QTY040
             , SUM(CASE WHEN IA.RN =  41 THEN A.QTY ELSE 0 END) AS QTY041
             , SUM(CASE WHEN IA.RN =  42 THEN A.QTY ELSE 0 END) AS QTY042
             , SUM(CASE WHEN IA.RN =  43 THEN A.QTY ELSE 0 END) AS QTY043
             , SUM(CASE WHEN IA.RN =  44 THEN A.QTY ELSE 0 END) AS QTY044
             , SUM(CASE WHEN IA.RN =  45 THEN A.QTY ELSE 0 END) AS QTY045
             , SUM(CASE WHEN IA.RN =  46 THEN A.QTY ELSE 0 END) AS QTY046
             , SUM(CASE WHEN IA.RN =  47 THEN A.QTY ELSE 0 END) AS QTY047
             , SUM(CASE WHEN IA.RN =  48 THEN A.QTY ELSE 0 END) AS QTY048
             , SUM(CASE WHEN IA.RN =  49 THEN A.QTY ELSE 0 END) AS QTY049
             , SUM(CASE WHEN IA.RN =  50 THEN A.QTY ELSE 0 END) AS QTY050
             , SUM(CASE WHEN IA.RN =  51 THEN A.QTY ELSE 0 END) AS QTY051
             , SUM(CASE WHEN IA.RN =  52 THEN A.QTY ELSE 0 END) AS QTY052
             , SUM(CASE WHEN IA.RN =  53 THEN A.QTY ELSE 0 END) AS QTY053
             , SUM(CASE WHEN IA.RN =  54 THEN A.QTY ELSE 0 END) AS QTY054
             , SUM(CASE WHEN IA.RN =  55 THEN A.QTY ELSE 0 END) AS QTY055
             , SUM(CASE WHEN IA.RN =  56 THEN A.QTY ELSE 0 END) AS QTY056
             , SUM(CASE WHEN IA.RN =  57 THEN A.QTY ELSE 0 END) AS QTY057
             , SUM(CASE WHEN IA.RN =  58 THEN A.QTY ELSE 0 END) AS QTY058
             , SUM(CASE WHEN IA.RN =  59 THEN A.QTY ELSE 0 END) AS QTY059
             , SUM(CASE WHEN IA.RN =  60 THEN A.QTY ELSE 0 END) AS QTY060
             , SUM(CASE WHEN IA.RN =  61 THEN A.QTY ELSE 0 END) AS QTY061
             , SUM(CASE WHEN IA.RN =  62 THEN A.QTY ELSE 0 END) AS QTY062
             , SUM(CASE WHEN IA.RN =  63 THEN A.QTY ELSE 0 END) AS QTY063
             , SUM(CASE WHEN IA.RN =  64 THEN A.QTY ELSE 0 END) AS QTY064
             , SUM(CASE WHEN IA.RN =  65 THEN A.QTY ELSE 0 END) AS QTY065
             , SUM(CASE WHEN IA.RN =  66 THEN A.QTY ELSE 0 END) AS QTY066
             , SUM(CASE WHEN IA.RN =  67 THEN A.QTY ELSE 0 END) AS QTY067
             , SUM(CASE WHEN IA.RN =  68 THEN A.QTY ELSE 0 END) AS QTY068
             , SUM(CASE WHEN IA.RN =  69 THEN A.QTY ELSE 0 END) AS QTY069
             , SUM(CASE WHEN IA.RN =  70 THEN A.QTY ELSE 0 END) AS QTY070
             , SUM(CASE WHEN IA.RN =  71 THEN A.QTY ELSE 0 END) AS QTY071
             , SUM(CASE WHEN IA.RN =  72 THEN A.QTY ELSE 0 END) AS QTY072
             , SUM(CASE WHEN IA.RN =  73 THEN A.QTY ELSE 0 END) AS QTY073
             , SUM(CASE WHEN IA.RN =  74 THEN A.QTY ELSE 0 END) AS QTY074
             , SUM(CASE WHEN IA.RN =  75 THEN A.QTY ELSE 0 END) AS QTY075
             , SUM(CASE WHEN IA.RN =  76 THEN A.QTY ELSE 0 END) AS QTY076
             , SUM(CASE WHEN IA.RN =  77 THEN A.QTY ELSE 0 END) AS QTY077
             , SUM(CASE WHEN IA.RN =  78 THEN A.QTY ELSE 0 END) AS QTY078
             , SUM(CASE WHEN IA.RN =  79 THEN A.QTY ELSE 0 END) AS QTY079
             , SUM(CASE WHEN IA.RN =  80 THEN A.QTY ELSE 0 END) AS QTY080
             , SUM(CASE WHEN IA.RN =  81 THEN A.QTY ELSE 0 END) AS QTY081
             , SUM(CASE WHEN IA.RN =  82 THEN A.QTY ELSE 0 END) AS QTY082
             , SUM(CASE WHEN IA.RN =  83 THEN A.QTY ELSE 0 END) AS QTY083
             , SUM(CASE WHEN IA.RN =  84 THEN A.QTY ELSE 0 END) AS QTY084
             , SUM(CASE WHEN IA.RN =  85 THEN A.QTY ELSE 0 END) AS QTY085
             , SUM(CASE WHEN IA.RN =  86 THEN A.QTY ELSE 0 END) AS QTY086
             , SUM(CASE WHEN IA.RN =  87 THEN A.QTY ELSE 0 END) AS QTY087
             , SUM(CASE WHEN IA.RN =  88 THEN A.QTY ELSE 0 END) AS QTY088
             , SUM(CASE WHEN IA.RN =  89 THEN A.QTY ELSE 0 END) AS QTY089
             , SUM(CASE WHEN IA.RN =  90 THEN A.QTY ELSE 0 END) AS QTY090
             , SUM(CASE WHEN IA.RN =  91 THEN A.QTY ELSE 0 END) AS QTY091
             , SUM(CASE WHEN IA.RN =  92 THEN A.QTY ELSE 0 END) AS QTY092
             , SUM(CASE WHEN IA.RN =  93 THEN A.QTY ELSE 0 END) AS QTY093
             , SUM(CASE WHEN IA.RN =  94 THEN A.QTY ELSE 0 END) AS QTY094
             , SUM(CASE WHEN IA.RN =  95 THEN A.QTY ELSE 0 END) AS QTY095
             , SUM(CASE WHEN IA.RN =  96 THEN A.QTY ELSE 0 END) AS QTY096
             , SUM(CASE WHEN IA.RN =  97 THEN A.QTY ELSE 0 END) AS QTY097
             , SUM(CASE WHEN IA.RN =  98 THEN A.QTY ELSE 0 END) AS QTY098
             , SUM(CASE WHEN IA.RN =  99 THEN A.QTY ELSE 0 END) AS QTY099
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
             , NULL                                                   AS ATTRIBUTE2
             , '0'                                                    AS ATTRIBUTE3
             , NULL                                                   AS ATTRIBUTE4
             , NULL                                                   AS ATTRIBUTE5
             , NULL                                                   AS ATTRIBUTE6
             , NULL                                                   AS ATTRIBUTE7
             , NULL                                                   AS ATTRIBUTE8
             , A.ATTRIBUTE9
             , NULL                                                   AS ATTRIBUTE10
          FROM GT_XPSC_PSI_GLOBAL_SMALL_CELL A
             , (SELECT SB.BASIS_YYYYMMDD                                                  AS YYYYMMDD
                     , ROW_NUMBER() OVER(ORDER BY SB.BASIS_YYYYMMDD || TO_CHAR(31))     AS RN  /* A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO */
                  FROM SCM_SYS_CALENDAR_M SB
                 WHERE SB.BASIS_YYYYMMDD >= V_CREATE_FROM_YYYYMMDD
                   AND SB.BASIS_YYYYMMDD <= V_CREATE_TO_YYYYMMDD
                 GROUP BY SB.BASIS_YYYYMMDD) IA
         WHERE A.YYYYMMDD  = IA.YYYYMMDD(+)
           AND A.YYYYMMDD >= V_CREATE_FROM_YYYYMMDD
           AND A.YYYYMMDD <= V_CREATE_TO_YYYYMMDD
         GROUP BY A.DIVISION_ID
                , A.CELL_TYPE_GROUP_CODE
                , A.CELL_ITEM_ID
                , A.MEASURE
                , A.COLUMN_LABEL_NAME
                , A.SITE_ID
                , A.PROD_LINE
                , A.YIELD
                , A.MEASURE
                , A.SORT_ORDER_NO
                , A.BOH
                , A.ATTRIBUTE1
                , A.ATTRIBUTE9;

        /* EXEC sp_executesql @mEXEC; */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 00300 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /*
            DECLARE @POS int
            DECLARE @LEN NVARCHAR(max)
                    SET @POS =1;
                    SET @LEN =LEN(@mEXEC);
                    WHILE @POS <= @LEN
                        BEGIN
                            PRINT SUBSTRING(@mEXEC,@POS,4000);
                            SET @POS = @POS+4000;
                        END;
        */

        /* ------------------------------------------------------------------------------------------------------------- */
        /* LINE_ID 추가 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* 'SHIP_PLAN'의 LINE_ID 종류 별 추가 */
        INSERT
          INTO GT_XPSC_XLS_PSI_SMALL_CELL
        SELECT DISTINCT
               A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.CELL_TYPE_GROUP_CODE
             , A.CELL_ITEM_ID
             , A.NICK_NAME
             , A.MEASURE
             , A.MEASURE_LABEL
             , B.PLANT_SITE_ID                                        AS SITE_ID
             , NVL((SELECT SA.SITE_DESCRIPTION
                      FROM SCM_MST_SITE SA
                     WHERE SA.SCM_SITE_ID = B.PLANT_SITE_ID
                       AND ROWNUM         = 1), '-')                  AS SITE_DESCRIPTION
             , B.LINE_ID                                              AS PROD_LINE
             , A.YIELD
             , A.LT_WEEK
             , A.BOH
             , A.XLS_KEY1
             , A.XLS_KEY2
             , A.XLS_KEY3
             , A.XLS_KEY4
             , A.XLS_KEY5
             , A.XLS_ATTRIBUTE1
             , A.XLS_ATTRIBUTE2
             , A.XLS_ATTRIBUTE3
             , A.XLS_ATTRIBUTE4
             , A.XLS_ATTRIBUTE5
             , A.SORT_ORDER_NO
             , 0 AS QTY001
             , 0 AS QTY002
             , 0 AS QTY003
             , 0 AS QTY004
             , 0 AS QTY005
             , 0 AS QTY006
             , 0 AS QTY007
             , 0 AS QTY008
             , 0 AS QTY009
             , 0 AS QTY010
             , 0 AS QTY011
             , 0 AS QTY012
             , 0 AS QTY013
             , 0 AS QTY014
             , 0 AS QTY015
             , 0 AS QTY016
             , 0 AS QTY017
             , 0 AS QTY018
             , 0 AS QTY019
             , 0 AS QTY020
             , 0 AS QTY021
             , 0 AS QTY022
             , 0 AS QTY023
             , 0 AS QTY024
             , 0 AS QTY025
             , 0 AS QTY026
             , 0 AS QTY027
             , 0 AS QTY028
             , 0 AS QTY029
             , 0 AS QTY030
             , 0 AS QTY031
             , 0 AS QTY032
             , 0 AS QTY033
             , 0 AS QTY034
             , 0 AS QTY035
             , 0 AS QTY036
             , 0 AS QTY037
             , 0 AS QTY038
             , 0 AS QTY039
             , 0 AS QTY040
             , 0 AS QTY041
             , 0 AS QTY042
             , 0 AS QTY043
             , 0 AS QTY044
             , 0 AS QTY045
             , 0 AS QTY046
             , 0 AS QTY047
             , 0 AS QTY048
             , 0 AS QTY049
             , 0 AS QTY050
             , 0 AS QTY051
             , 0 AS QTY052
             , 0 AS QTY053
             , 0 AS QTY054
             , 0 AS QTY055
             , 0 AS QTY056
             , 0 AS QTY057
             , 0 AS QTY058
             , 0 AS QTY059
             , 0 AS QTY060
             , 0 AS QTY061
             , 0 AS QTY062
             , 0 AS QTY063
             , 0 AS QTY064
             , 0 AS QTY065
             , 0 AS QTY066
             , 0 AS QTY067
             , 0 AS QTY068
             , 0 AS QTY069
             , 0 AS QTY070
             , 0 AS QTY071
             , 0 AS QTY072
             , 0 AS QTY073
             , 0 AS QTY074
             , 0 AS QTY075
             , 0 AS QTY076
             , 0 AS QTY077
             , 0 AS QTY078
             , 0 AS QTY079
             , 0 AS QTY080
             , 0 AS QTY081
             , 0 AS QTY082
             , 0 AS QTY083
             , 0 AS QTY084
             , 0 AS QTY085
             , 0 AS QTY086
             , 0 AS QTY087
             , 0 AS QTY088
             , 0 AS QTY089
             , 0 AS QTY090
             , 0 AS QTY091
             , 0 AS QTY092
             , 0 AS QTY093
             , 0 AS QTY094
             , 0 AS QTY095
             , 0 AS QTY096
             , 0 AS QTY097
             , 0 AS QTY098
             , 0 AS QTY099
             , 0 AS QTY100
             , 0 AS QTY101
             , 0 AS QTY102
             , 0 AS QTY103
             , 0 AS QTY104
             , 0 AS QTY105
             , 0 AS QTY106
             , 0 AS QTY107
             , 0 AS QTY108
             , 0 AS QTY109
             , 0 AS QTY110
             , 0 AS QTY111
             , 0 AS QTY112
             , 0 AS QTY113
             , 0 AS QTY114
             , 0 AS QTY115
             , 0 AS QTY116
             , 0 AS QTY117
             , 0 AS QTY118
             , 0 AS QTY119
             , 0 AS QTY120
             , 0 AS QTY121
             , 0 AS QTY122
             , 0 AS QTY123
             , 0 AS QTY124
             , 0 AS QTY125
             , 0 AS QTY126
             , 0 AS QTY127
             , 0 AS QTY128
             , 0 AS QTY129
             , 0 AS QTY130
             , 0 AS QTY131
             , 0 AS QTY132
             , 0 AS QTY133
             , 0 AS QTY134
             , 0 AS QTY135
             , 0 AS QTY136
             , 0 AS QTY137
             , 0 AS QTY138
             , 0 AS QTY139
             , 0 AS QTY140
             , 0 AS QTY141
             , 0 AS QTY142
             , 0 AS QTY143
             , 0 AS QTY144
             , 0 AS QTY145
             , 0 AS QTY146
             , 0 AS QTY147
             , 0 AS QTY148
             , 0 AS QTY149
             , 0 AS QTY150
             , 0 AS QTY151
             , 0 AS QTY152
             , 0 AS QTY153
             , 0 AS QTY154
             , 0 AS QTY155
             , 0 AS QTY156
             , 0 AS QTY157
             , 0 AS QTY158
             , 0 AS QTY159
             , 0 AS QTY160
             , 0 AS QTY161
             , 0 AS QTY162
             , 0 AS QTY163
             , 0 AS QTY164
             , 0 AS QTY165
             , 0 AS QTY166
             , 0 AS QTY167
             , 0 AS QTY168
             , 0 AS QTY169
             , 0 AS QTY170
             , 0 AS QTY171
             , 0 AS QTY172
             , 0 AS QTY173
             , 0 AS QTY174
             , 0 AS QTY175
             , 0 AS QTY176
             , 0 AS QTY177
             , 0 AS QTY178
             , 0 AS QTY179
             , 0 AS QTY180
             , 0 AS QTY181
             , 0 AS QTY182
             , 0 AS QTY183
             , 0 AS QTY184
             , 0 AS QTY185
             , 0 AS QTY186
             , 0 AS QTY187
             , 0 AS QTY188
             , 0 AS QTY189
             , 0 AS QTY190
             , 0 AS QTY191
             , 0 AS QTY192
             , 0 AS QTY193
             , 0 AS QTY194
             , 0 AS QTY195
             , 0 AS QTY196
             , 0 AS QTY197
             , 0 AS QTY198
             , 0 AS QTY199
             , 0 AS QTY200
             , 0 AS QTY201
             , 0 AS QTY202
             , 0 AS QTY203
             , 0 AS QTY204
             , 0 AS QTY205
             , 0 AS QTY206
             , 0 AS QTY207
             , 0 AS QTY208
             , 0 AS QTY209
             , 0 AS QTY210
             , 0 AS QTY211
             , 0 AS QTY212
             , 0 AS QTY213
             , 0 AS QTY214
             , 0 AS QTY215
             , 0 AS QTY216
             , 0 AS QTY217
             , 0 AS QTY218
             , 0 AS QTY219
             , 0 AS QTY220
             , 0 AS QTY221
             , 0 AS QTY222
             , 0 AS QTY223
             , 0 AS QTY224
             , 0 AS QTY225
             , 0 AS QTY226
             , 0 AS QTY227
             , 0 AS QTY228
             , 0 AS QTY229
             , 0 AS QTY230
             , 0 AS QTY231
             , 0 AS QTY232
             , 0 AS QTY233
             , 0 AS QTY234
             , 0 AS QTY235
             , 0 AS QTY236
             , 0 AS QTY237
             , 0 AS QTY238
             , 0 AS QTY239
             , 0 AS QTY240
             , 0 AS QTY241
             , 0 AS QTY242
             , 0 AS QTY243
             , 0 AS QTY244
             , 0 AS QTY245
             , 0 AS QTY246
             , 0 AS QTY247
             , 0 AS QTY248
             , 0 AS QTY249
             , 0 AS QTY250
             , 0 AS QTY251
             , 0 AS QTY252
             , 0 AS QTY253
             , 0 AS QTY254
             , 0 AS QTY255
             , 0 AS QTY256
             , 0 AS QTY257
             , 0 AS QTY258
             , 0 AS QTY259
             , 0 AS QTY260
             , 0 AS QTY261
             , 0 AS QTY262
             , 0 AS QTY263
             , 0 AS QTY264
             , 0 AS QTY265
             , 0 AS QTY266
             , 0 AS QTY267
             , 0 AS QTY268
             , 0 AS QTY269
             , 0 AS QTY270
             , 0 AS QTY271
             , 0 AS QTY272
             , 0 AS QTY273
             , 0 AS QTY274
             , 0 AS QTY275
             , 0 AS QTY276
             , 0 AS QTY277
             , 0 AS QTY278
             , 0 AS QTY279
             , 0 AS QTY280
             , 0 AS QTY281
             , 0 AS QTY282
             , 0 AS QTY283
             , 0 AS QTY284
             , 0 AS QTY285
             , 0 AS QTY286
             , 0 AS QTY287
             , 0 AS QTY288
             , 0 AS QTY289
             , 0 AS QTY290
             , 0 AS QTY291
             , 0 AS QTY292
             , 0 AS QTY293
             , 0 AS QTY294
             , 0 AS QTY295
             , 0 AS QTY296
             , 0 AS QTY297
             , 0 AS QTY298
             , 0 AS QTY299
             , 0 AS QTY300
             , 0 AS QTY301
             , 0 AS QTY302
             , 0 AS QTY303
             , 0 AS QTY304
             , 0 AS QTY305
             , 0 AS QTY306
             , 0 AS QTY307
             , 0 AS QTY308
             , 0 AS QTY309
             , 0 AS QTY310
             , 0 AS QTY311
             , 0 AS QTY312
             , 0 AS QTY313
             , 0 AS QTY314
             , 0 AS QTY315
             , 0 AS QTY316
             , 0 AS QTY317
             , 0 AS QTY318
             , 0 AS QTY319
             , 0 AS QTY320
             , 0 AS QTY321
             , 0 AS QTY322
             , 0 AS QTY323
             , 0 AS QTY324
             , 0 AS QTY325
             , 0 AS QTY326
             , 0 AS QTY327
             , 0 AS QTY328
             , 0 AS QTY329
             , 0 AS QTY330
             , 0 AS QTY331
             , 0 AS QTY332
             , 0 AS QTY333
             , 0 AS QTY334
             , 0 AS QTY335
             , 0 AS QTY336
             , 0 AS QTY337
             , 0 AS QTY338
             , 0 AS QTY339
             , 0 AS QTY340
             , 0 AS QTY341
             , 0 AS QTY342
             , 0 AS QTY343
             , 0 AS QTY344
             , 0 AS QTY345
             , 0 AS QTY346
             , 0 AS QTY347
             , 0 AS QTY348
             , 0 AS QTY349
             , 0 AS QTY350
             , 0 AS QTY351
             , 0 AS QTY352
             , 0 AS QTY353
             , 0 AS QTY354
             , 0 AS QTY355
             , 0 AS QTY356
             , 0 AS QTY357
             , 0 AS QTY358
             , 0 AS QTY359
             , 0 AS QTY360
             , 0 AS QTY361
             , 0 AS QTY362
             , 0 AS QTY363
             , 0 AS QTY364
               /* ,X.CREATED_BY */
               /* ,X.CREATION_DATE */
               /* ,X.LAST_UPDATED_BY */
               /* ,X.LAST_UPDATE_DATE */
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE7
             , A.ATTRIBUTE8
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
          FROM GT_XPSC_XLS_PSI_SMALL_CELL A
             , GT_XPSC_MST_TACT_TIME      B  /* CROSS APPLY #MST_TACT_TIME Y */
         WHERE A.DIVISION_ID  = B.DIVISION_ID
           AND A.CELL_ITEM_ID = B.ITEM_ID
           AND NOT EXISTS (SELECT 1
                             FROM GT_XPSC_XLS_PSI_SMALL_CELL XA
                            WHERE XA.DIVISION_ID  = A.DIVISION_ID
                              AND XA.CELL_ITEM_ID = A.CELL_ITEM_ID
                              AND XA.MEASURE      = A.MEASURE
                              AND XA.SITE_ID      = B.PLANT_SITE_ID
                              AND XA.PROD_LINE    = B.LINE_ID
                              AND XA.MEASURE      = 'PROD')
           AND A.MEASURE      = 'PROD'
         UNION
        SELECT DISTINCT
               C.DIVISION_ID
             , C.PLAN_START_YYYYMMDD
             , C.PLAN_TYPE
             , C.SEQ
             , C.CELL_TYPE_GROUP_CODE
             , C.CELL_ITEM_ID
             , C.NICK_NAME
             , 'PROD_LOAD'                                            AS MEASURE
             , 'Load Rate'                                            AS MEASURE_LABEL
             , D.PLANT_SITE_ID                                         AS SITE_ID
             , NVL((SELECT SB.SITE_DESCRIPTION
                      FROM SCM_MST_SITE SB
                     WHERE SB.SCM_SITE_ID = D.PLANT_SITE_ID
                       AND ROWNUM         = 1), '-')                  AS SITE_DESCRIPTION
             , D.LINE_ID                                               AS PROD_LINE
             , C.YIELD
             , C.LT_WEEK
             , C.BOH
             , C.XLS_KEY1
             , C.XLS_KEY2
             , C.XLS_KEY3
             , C.XLS_KEY4
             , C.XLS_KEY5
             , C.XLS_ATTRIBUTE1
             , C.XLS_ATTRIBUTE2
             , C.XLS_ATTRIBUTE3
             , C.XLS_ATTRIBUTE4
             , C.XLS_ATTRIBUTE5
             , C.SORT_ORDER_NO
             , 0 AS QTY001
             , 0 AS QTY002
             , 0 AS QTY003
             , 0 AS QTY004
             , 0 AS QTY005
             , 0 AS QTY006
             , 0 AS QTY007
             , 0 AS QTY008
             , 0 AS QTY009
             , 0 AS QTY010
             , 0 AS QTY011
             , 0 AS QTY012
             , 0 AS QTY013
             , 0 AS QTY014
             , 0 AS QTY015
             , 0 AS QTY016
             , 0 AS QTY017
             , 0 AS QTY018
             , 0 AS QTY019
             , 0 AS QTY020
             , 0 AS QTY021
             , 0 AS QTY022
             , 0 AS QTY023
             , 0 AS QTY024
             , 0 AS QTY025
             , 0 AS QTY026
             , 0 AS QTY027
             , 0 AS QTY028
             , 0 AS QTY029
             , 0 AS QTY030
             , 0 AS QTY031
             , 0 AS QTY032
             , 0 AS QTY033
             , 0 AS QTY034
             , 0 AS QTY035
             , 0 AS QTY036
             , 0 AS QTY037
             , 0 AS QTY038
             , 0 AS QTY039
             , 0 AS QTY040
             , 0 AS QTY041
             , 0 AS QTY042
             , 0 AS QTY043
             , 0 AS QTY044
             , 0 AS QTY045
             , 0 AS QTY046
             , 0 AS QTY047
             , 0 AS QTY048
             , 0 AS QTY049
             , 0 AS QTY050
             , 0 AS QTY051
             , 0 AS QTY052
             , 0 AS QTY053
             , 0 AS QTY054
             , 0 AS QTY055
             , 0 AS QTY056
             , 0 AS QTY057
             , 0 AS QTY058
             , 0 AS QTY059
             , 0 AS QTY060
             , 0 AS QTY061
             , 0 AS QTY062
             , 0 AS QTY063
             , 0 AS QTY064
             , 0 AS QTY065
             , 0 AS QTY066
             , 0 AS QTY067
             , 0 AS QTY068
             , 0 AS QTY069
             , 0 AS QTY070
             , 0 AS QTY071
             , 0 AS QTY072
             , 0 AS QTY073
             , 0 AS QTY074
             , 0 AS QTY075
             , 0 AS QTY076
             , 0 AS QTY077
             , 0 AS QTY078
             , 0 AS QTY079
             , 0 AS QTY080
             , 0 AS QTY081
             , 0 AS QTY082
             , 0 AS QTY083
             , 0 AS QTY084
             , 0 AS QTY085
             , 0 AS QTY086
             , 0 AS QTY087
             , 0 AS QTY088
             , 0 AS QTY089
             , 0 AS QTY090
             , 0 AS QTY091
             , 0 AS QTY092
             , 0 AS QTY093
             , 0 AS QTY094
             , 0 AS QTY095
             , 0 AS QTY096
             , 0 AS QTY097
             , 0 AS QTY098
             , 0 AS QTY099
             , 0 AS QTY100
             , 0 AS QTY101
             , 0 AS QTY102
             , 0 AS QTY103
             , 0 AS QTY104
             , 0 AS QTY105
             , 0 AS QTY106
             , 0 AS QTY107
             , 0 AS QTY108
             , 0 AS QTY109
             , 0 AS QTY110
             , 0 AS QTY111
             , 0 AS QTY112
             , 0 AS QTY113
             , 0 AS QTY114
             , 0 AS QTY115
             , 0 AS QTY116
             , 0 AS QTY117
             , 0 AS QTY118
             , 0 AS QTY119
             , 0 AS QTY120
             , 0 AS QTY121
             , 0 AS QTY122
             , 0 AS QTY123
             , 0 AS QTY124
             , 0 AS QTY125
             , 0 AS QTY126
             , 0 AS QTY127
             , 0 AS QTY128
             , 0 AS QTY129
             , 0 AS QTY130
             , 0 AS QTY131
             , 0 AS QTY132
             , 0 AS QTY133
             , 0 AS QTY134
             , 0 AS QTY135
             , 0 AS QTY136
             , 0 AS QTY137
             , 0 AS QTY138
             , 0 AS QTY139
             , 0 AS QTY140
             , 0 AS QTY141
             , 0 AS QTY142
             , 0 AS QTY143
             , 0 AS QTY144
             , 0 AS QTY145
             , 0 AS QTY146
             , 0 AS QTY147
             , 0 AS QTY148
             , 0 AS QTY149
             , 0 AS QTY150
             , 0 AS QTY151
             , 0 AS QTY152
             , 0 AS QTY153
             , 0 AS QTY154
             , 0 AS QTY155
             , 0 AS QTY156
             , 0 AS QTY157
             , 0 AS QTY158
             , 0 AS QTY159
             , 0 AS QTY160
             , 0 AS QTY161
             , 0 AS QTY162
             , 0 AS QTY163
             , 0 AS QTY164
             , 0 AS QTY165
             , 0 AS QTY166
             , 0 AS QTY167
             , 0 AS QTY168
             , 0 AS QTY169
             , 0 AS QTY170
             , 0 AS QTY171
             , 0 AS QTY172
             , 0 AS QTY173
             , 0 AS QTY174
             , 0 AS QTY175
             , 0 AS QTY176
             , 0 AS QTY177
             , 0 AS QTY178
             , 0 AS QTY179
             , 0 AS QTY180
             , 0 AS QTY181
             , 0 AS QTY182
             , 0 AS QTY183
             , 0 AS QTY184
             , 0 AS QTY185
             , 0 AS QTY186
             , 0 AS QTY187
             , 0 AS QTY188
             , 0 AS QTY189
             , 0 AS QTY190
             , 0 AS QTY191
             , 0 AS QTY192
             , 0 AS QTY193
             , 0 AS QTY194
             , 0 AS QTY195
             , 0 AS QTY196
             , 0 AS QTY197
             , 0 AS QTY198
             , 0 AS QTY199
             , 0 AS QTY200
             , 0 AS QTY201
             , 0 AS QTY202
             , 0 AS QTY203
             , 0 AS QTY204
             , 0 AS QTY205
             , 0 AS QTY206
             , 0 AS QTY207
             , 0 AS QTY208
             , 0 AS QTY209
             , 0 AS QTY210
             , 0 AS QTY211
             , 0 AS QTY212
             , 0 AS QTY213
             , 0 AS QTY214
             , 0 AS QTY215
             , 0 AS QTY216
             , 0 AS QTY217
             , 0 AS QTY218
             , 0 AS QTY219
             , 0 AS QTY220
             , 0 AS QTY221
             , 0 AS QTY222
             , 0 AS QTY223
             , 0 AS QTY224
             , 0 AS QTY225
             , 0 AS QTY226
             , 0 AS QTY227
             , 0 AS QTY228
             , 0 AS QTY229
             , 0 AS QTY230
             , 0 AS QTY231
             , 0 AS QTY232
             , 0 AS QTY233
             , 0 AS QTY234
             , 0 AS QTY235
             , 0 AS QTY236
             , 0 AS QTY237
             , 0 AS QTY238
             , 0 AS QTY239
             , 0 AS QTY240
             , 0 AS QTY241
             , 0 AS QTY242
             , 0 AS QTY243
             , 0 AS QTY244
             , 0 AS QTY245
             , 0 AS QTY246
             , 0 AS QTY247
             , 0 AS QTY248
             , 0 AS QTY249
             , 0 AS QTY250
             , 0 AS QTY251
             , 0 AS QTY252
             , 0 AS QTY253
             , 0 AS QTY254
             , 0 AS QTY255
             , 0 AS QTY256
             , 0 AS QTY257
             , 0 AS QTY258
             , 0 AS QTY259
             , 0 AS QTY260
             , 0 AS QTY261
             , 0 AS QTY262
             , 0 AS QTY263
             , 0 AS QTY264
             , 0 AS QTY265
             , 0 AS QTY266
             , 0 AS QTY267
             , 0 AS QTY268
             , 0 AS QTY269
             , 0 AS QTY270
             , 0 AS QTY271
             , 0 AS QTY272
             , 0 AS QTY273
             , 0 AS QTY274
             , 0 AS QTY275
             , 0 AS QTY276
             , 0 AS QTY277
             , 0 AS QTY278
             , 0 AS QTY279
             , 0 AS QTY280
             , 0 AS QTY281
             , 0 AS QTY282
             , 0 AS QTY283
             , 0 AS QTY284
             , 0 AS QTY285
             , 0 AS QTY286
             , 0 AS QTY287
             , 0 AS QTY288
             , 0 AS QTY289
             , 0 AS QTY290
             , 0 AS QTY291
             , 0 AS QTY292
             , 0 AS QTY293
             , 0 AS QTY294
             , 0 AS QTY295
             , 0 AS QTY296
             , 0 AS QTY297
             , 0 AS QTY298
             , 0 AS QTY299
             , 0 AS QTY300
             , 0 AS QTY301
             , 0 AS QTY302
             , 0 AS QTY303
             , 0 AS QTY304
             , 0 AS QTY305
             , 0 AS QTY306
             , 0 AS QTY307
             , 0 AS QTY308
             , 0 AS QTY309
             , 0 AS QTY310
             , 0 AS QTY311
             , 0 AS QTY312
             , 0 AS QTY313
             , 0 AS QTY314
             , 0 AS QTY315
             , 0 AS QTY316
             , 0 AS QTY317
             , 0 AS QTY318
             , 0 AS QTY319
             , 0 AS QTY320
             , 0 AS QTY321
             , 0 AS QTY322
             , 0 AS QTY323
             , 0 AS QTY324
             , 0 AS QTY325
             , 0 AS QTY326
             , 0 AS QTY327
             , 0 AS QTY328
             , 0 AS QTY329
             , 0 AS QTY330
             , 0 AS QTY331
             , 0 AS QTY332
             , 0 AS QTY333
             , 0 AS QTY334
             , 0 AS QTY335
             , 0 AS QTY336
             , 0 AS QTY337
             , 0 AS QTY338
             , 0 AS QTY339
             , 0 AS QTY340
             , 0 AS QTY341
             , 0 AS QTY342
             , 0 AS QTY343
             , 0 AS QTY344
             , 0 AS QTY345
             , 0 AS QTY346
             , 0 AS QTY347
             , 0 AS QTY348
             , 0 AS QTY349
             , 0 AS QTY350
             , 0 AS QTY351
             , 0 AS QTY352
             , 0 AS QTY353
             , 0 AS QTY354
             , 0 AS QTY355
             , 0 AS QTY356
             , 0 AS QTY357
             , 0 AS QTY358
             , 0 AS QTY359
             , 0 AS QTY360
             , 0 AS QTY361
             , 0 AS QTY362
             , 0 AS QTY363
             , 0 AS QTY364
               /* ,X.CREATED_BY */
               /* ,X.CREATION_DATE */
               /* ,X.LAST_UPDATED_BY */
               /* ,X.LAST_UPDATE_DATE */
             , C.ATTRIBUTE1
             , C.ATTRIBUTE2
             , C.ATTRIBUTE3
             , C.ATTRIBUTE4
             , C.ATTRIBUTE5
             , C.ATTRIBUTE6
             , C.ATTRIBUTE7
             , C.ATTRIBUTE8
             , C.ATTRIBUTE9
             , 'PROD_LOAD'                                            AS ATTRIBUTE10
          FROM GT_XPSC_XLS_PSI_SMALL_CELL C
             , GT_XPSC_MST_TACT_TIME      D  /* CROSS APPLY #MST_TACT_TIME Y */
         WHERE C.DIVISION_ID  = D.DIVISION_ID
           AND C.CELL_ITEM_ID = D.ITEM_ID
           AND NOT EXISTS (SELECT 1
                             FROM GT_XPSC_XLS_PSI_SMALL_CELL XB
                            WHERE XB.DIVISION_ID  = C.DIVISION_ID
                              AND XB.CELL_ITEM_ID = C.CELL_ITEM_ID
                              AND XB.MEASURE      = C.MEASURE
                              AND XB.SITE_ID      = D.PLANT_SITE_ID
                              AND XB.PROD_LINE    = D.LINE_ID
                              AND XB.MEASURE      = 'PROD')
           AND C.MEASURE      = 'PROD';

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 00400 ';
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
        /*  보정 추가된 PROD_LOAD 반영 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* PROD_LOAD PIVOT 테이블 생성 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#LineLoad_Pivot') IS NOT NULL DROP TABLE #LineLoad_Pivot */
        /* --DROP TABLE #LineLoad_Pivot */
        DELETE FROM GT_XPSC_LINELOAD_PIVOT;

        /* --                    DECLARE @mEXEC NVARCHAR(MAX); */
        INSERT
          INTO GT_XPSC_LINELOAD_PIVOT
             ( DIVISION_ID
             , SITE_ID
             , OPERATION_ID
             , PROD_LINE
             , MEASURE
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
             )
        SELECT A.DIVISION_ID
             , A.SITE_ID
             , A.OPERATION_ID
             , A.PROD_LINE
             , A.MEASURE
             , SUM(CASE WHEN IA.RN =   1 THEN A.QTY ELSE 0 END) AS QTY001
             , SUM(CASE WHEN IA.RN =   2 THEN A.QTY ELSE 0 END) AS QTY002
             , SUM(CASE WHEN IA.RN =   3 THEN A.QTY ELSE 0 END) AS QTY003
             , SUM(CASE WHEN IA.RN =   4 THEN A.QTY ELSE 0 END) AS QTY004
             , SUM(CASE WHEN IA.RN =   5 THEN A.QTY ELSE 0 END) AS QTY005
             , SUM(CASE WHEN IA.RN =   6 THEN A.QTY ELSE 0 END) AS QTY006
             , SUM(CASE WHEN IA.RN =   7 THEN A.QTY ELSE 0 END) AS QTY007
             , SUM(CASE WHEN IA.RN =   8 THEN A.QTY ELSE 0 END) AS QTY008
             , SUM(CASE WHEN IA.RN =   9 THEN A.QTY ELSE 0 END) AS QTY009
             , SUM(CASE WHEN IA.RN =  10 THEN A.QTY ELSE 0 END) AS QTY010
             , SUM(CASE WHEN IA.RN =  11 THEN A.QTY ELSE 0 END) AS QTY011
             , SUM(CASE WHEN IA.RN =  12 THEN A.QTY ELSE 0 END) AS QTY012
             , SUM(CASE WHEN IA.RN =  13 THEN A.QTY ELSE 0 END) AS QTY013
             , SUM(CASE WHEN IA.RN =  14 THEN A.QTY ELSE 0 END) AS QTY014
             , SUM(CASE WHEN IA.RN =  15 THEN A.QTY ELSE 0 END) AS QTY015
             , SUM(CASE WHEN IA.RN =  16 THEN A.QTY ELSE 0 END) AS QTY016
             , SUM(CASE WHEN IA.RN =  17 THEN A.QTY ELSE 0 END) AS QTY017
             , SUM(CASE WHEN IA.RN =  18 THEN A.QTY ELSE 0 END) AS QTY018
             , SUM(CASE WHEN IA.RN =  19 THEN A.QTY ELSE 0 END) AS QTY019
             , SUM(CASE WHEN IA.RN =  20 THEN A.QTY ELSE 0 END) AS QTY020
             , SUM(CASE WHEN IA.RN =  21 THEN A.QTY ELSE 0 END) AS QTY021
             , SUM(CASE WHEN IA.RN =  22 THEN A.QTY ELSE 0 END) AS QTY022
             , SUM(CASE WHEN IA.RN =  23 THEN A.QTY ELSE 0 END) AS QTY023
             , SUM(CASE WHEN IA.RN =  24 THEN A.QTY ELSE 0 END) AS QTY024
             , SUM(CASE WHEN IA.RN =  25 THEN A.QTY ELSE 0 END) AS QTY025
             , SUM(CASE WHEN IA.RN =  26 THEN A.QTY ELSE 0 END) AS QTY026
             , SUM(CASE WHEN IA.RN =  27 THEN A.QTY ELSE 0 END) AS QTY027
             , SUM(CASE WHEN IA.RN =  28 THEN A.QTY ELSE 0 END) AS QTY028
             , SUM(CASE WHEN IA.RN =  29 THEN A.QTY ELSE 0 END) AS QTY029
             , SUM(CASE WHEN IA.RN =  30 THEN A.QTY ELSE 0 END) AS QTY030
             , SUM(CASE WHEN IA.RN =  31 THEN A.QTY ELSE 0 END) AS QTY031
             , SUM(CASE WHEN IA.RN =  32 THEN A.QTY ELSE 0 END) AS QTY032
             , SUM(CASE WHEN IA.RN =  33 THEN A.QTY ELSE 0 END) AS QTY033
             , SUM(CASE WHEN IA.RN =  34 THEN A.QTY ELSE 0 END) AS QTY034
             , SUM(CASE WHEN IA.RN =  35 THEN A.QTY ELSE 0 END) AS QTY035
             , SUM(CASE WHEN IA.RN =  36 THEN A.QTY ELSE 0 END) AS QTY036
             , SUM(CASE WHEN IA.RN =  37 THEN A.QTY ELSE 0 END) AS QTY037
             , SUM(CASE WHEN IA.RN =  38 THEN A.QTY ELSE 0 END) AS QTY038
             , SUM(CASE WHEN IA.RN =  39 THEN A.QTY ELSE 0 END) AS QTY039
             , SUM(CASE WHEN IA.RN =  40 THEN A.QTY ELSE 0 END) AS QTY040
             , SUM(CASE WHEN IA.RN =  41 THEN A.QTY ELSE 0 END) AS QTY041
             , SUM(CASE WHEN IA.RN =  42 THEN A.QTY ELSE 0 END) AS QTY042
             , SUM(CASE WHEN IA.RN =  43 THEN A.QTY ELSE 0 END) AS QTY043
             , SUM(CASE WHEN IA.RN =  44 THEN A.QTY ELSE 0 END) AS QTY044
             , SUM(CASE WHEN IA.RN =  45 THEN A.QTY ELSE 0 END) AS QTY045
             , SUM(CASE WHEN IA.RN =  46 THEN A.QTY ELSE 0 END) AS QTY046
             , SUM(CASE WHEN IA.RN =  47 THEN A.QTY ELSE 0 END) AS QTY047
             , SUM(CASE WHEN IA.RN =  48 THEN A.QTY ELSE 0 END) AS QTY048
             , SUM(CASE WHEN IA.RN =  49 THEN A.QTY ELSE 0 END) AS QTY049
             , SUM(CASE WHEN IA.RN =  50 THEN A.QTY ELSE 0 END) AS QTY050
             , SUM(CASE WHEN IA.RN =  51 THEN A.QTY ELSE 0 END) AS QTY051
             , SUM(CASE WHEN IA.RN =  52 THEN A.QTY ELSE 0 END) AS QTY052
             , SUM(CASE WHEN IA.RN =  53 THEN A.QTY ELSE 0 END) AS QTY053
             , SUM(CASE WHEN IA.RN =  54 THEN A.QTY ELSE 0 END) AS QTY054
             , SUM(CASE WHEN IA.RN =  55 THEN A.QTY ELSE 0 END) AS QTY055
             , SUM(CASE WHEN IA.RN =  56 THEN A.QTY ELSE 0 END) AS QTY056
             , SUM(CASE WHEN IA.RN =  57 THEN A.QTY ELSE 0 END) AS QTY057
             , SUM(CASE WHEN IA.RN =  58 THEN A.QTY ELSE 0 END) AS QTY058
             , SUM(CASE WHEN IA.RN =  59 THEN A.QTY ELSE 0 END) AS QTY059
             , SUM(CASE WHEN IA.RN =  60 THEN A.QTY ELSE 0 END) AS QTY060
             , SUM(CASE WHEN IA.RN =  61 THEN A.QTY ELSE 0 END) AS QTY061
             , SUM(CASE WHEN IA.RN =  62 THEN A.QTY ELSE 0 END) AS QTY062
             , SUM(CASE WHEN IA.RN =  63 THEN A.QTY ELSE 0 END) AS QTY063
             , SUM(CASE WHEN IA.RN =  64 THEN A.QTY ELSE 0 END) AS QTY064
             , SUM(CASE WHEN IA.RN =  65 THEN A.QTY ELSE 0 END) AS QTY065
             , SUM(CASE WHEN IA.RN =  66 THEN A.QTY ELSE 0 END) AS QTY066
             , SUM(CASE WHEN IA.RN =  67 THEN A.QTY ELSE 0 END) AS QTY067
             , SUM(CASE WHEN IA.RN =  68 THEN A.QTY ELSE 0 END) AS QTY068
             , SUM(CASE WHEN IA.RN =  69 THEN A.QTY ELSE 0 END) AS QTY069
             , SUM(CASE WHEN IA.RN =  70 THEN A.QTY ELSE 0 END) AS QTY070
             , SUM(CASE WHEN IA.RN =  71 THEN A.QTY ELSE 0 END) AS QTY071
             , SUM(CASE WHEN IA.RN =  72 THEN A.QTY ELSE 0 END) AS QTY072
             , SUM(CASE WHEN IA.RN =  73 THEN A.QTY ELSE 0 END) AS QTY073
             , SUM(CASE WHEN IA.RN =  74 THEN A.QTY ELSE 0 END) AS QTY074
             , SUM(CASE WHEN IA.RN =  75 THEN A.QTY ELSE 0 END) AS QTY075
             , SUM(CASE WHEN IA.RN =  76 THEN A.QTY ELSE 0 END) AS QTY076
             , SUM(CASE WHEN IA.RN =  77 THEN A.QTY ELSE 0 END) AS QTY077
             , SUM(CASE WHEN IA.RN =  78 THEN A.QTY ELSE 0 END) AS QTY078
             , SUM(CASE WHEN IA.RN =  79 THEN A.QTY ELSE 0 END) AS QTY079
             , SUM(CASE WHEN IA.RN =  80 THEN A.QTY ELSE 0 END) AS QTY080
             , SUM(CASE WHEN IA.RN =  81 THEN A.QTY ELSE 0 END) AS QTY081
             , SUM(CASE WHEN IA.RN =  82 THEN A.QTY ELSE 0 END) AS QTY082
             , SUM(CASE WHEN IA.RN =  83 THEN A.QTY ELSE 0 END) AS QTY083
             , SUM(CASE WHEN IA.RN =  84 THEN A.QTY ELSE 0 END) AS QTY084
             , SUM(CASE WHEN IA.RN =  85 THEN A.QTY ELSE 0 END) AS QTY085
             , SUM(CASE WHEN IA.RN =  86 THEN A.QTY ELSE 0 END) AS QTY086
             , SUM(CASE WHEN IA.RN =  87 THEN A.QTY ELSE 0 END) AS QTY087
             , SUM(CASE WHEN IA.RN =  88 THEN A.QTY ELSE 0 END) AS QTY088
             , SUM(CASE WHEN IA.RN =  89 THEN A.QTY ELSE 0 END) AS QTY089
             , SUM(CASE WHEN IA.RN =  90 THEN A.QTY ELSE 0 END) AS QTY090
             , SUM(CASE WHEN IA.RN =  91 THEN A.QTY ELSE 0 END) AS QTY091
             , SUM(CASE WHEN IA.RN =  92 THEN A.QTY ELSE 0 END) AS QTY092
             , SUM(CASE WHEN IA.RN =  93 THEN A.QTY ELSE 0 END) AS QTY093
             , SUM(CASE WHEN IA.RN =  94 THEN A.QTY ELSE 0 END) AS QTY094
             , SUM(CASE WHEN IA.RN =  95 THEN A.QTY ELSE 0 END) AS QTY095
             , SUM(CASE WHEN IA.RN =  96 THEN A.QTY ELSE 0 END) AS QTY096
             , SUM(CASE WHEN IA.RN =  97 THEN A.QTY ELSE 0 END) AS QTY097
             , SUM(CASE WHEN IA.RN =  98 THEN A.QTY ELSE 0 END) AS QTY098
             , SUM(CASE WHEN IA.RN =  99 THEN A.QTY ELSE 0 END) AS QTY099
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
          FROM GT_XPSC_LINELOAD A
             , (SELECT SB.BASIS_YYYYMMDD                                                  AS YYYYMMDD
                     , ROW_NUMBER() OVER(ORDER BY SB.BASIS_YYYYMMDD || TO_CHAR(31))     AS RN
                  FROM SCM_SYS_CALENDAR_M SB
                 WHERE SB.BASIS_YYYYMMDD >= V_CREATE_FROM_YYYYMMDD
                   AND SB.BASIS_YYYYMMDD <= V_CREATE_TO_YYYYMMDD
                 GROUP BY SB.BASIS_YYYYMMDD) IA
         WHERE A.YYYYMMDD = IA.YYYYMMDD(+)
         GROUP BY A.DIVISION_ID
                , A.SITE_ID
                , A.OPERATION_ID
                , A.PROD_LINE
                , A.MEASURE;

        /* --PRINT @mEXEC */
        /* EXEC sp_executesql @mEXEC; */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 00500 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* UPDATE X SET X.QTY001 = Y.QTY001 ... FROM #SCP_XLS_PSI_GLOBAL_SMALL_CELL X INNER JOIN #LineLoad_Pivot Y */
        /* → 열쇠(DIVISION_ID·SITE_ID·OPERATION_ID·PROD_LINE·MEASURE)로 묶은 표라 대응 행은 하나 */
        UPDATE GT_XPSC_XLS_PSI_SMALL_CELL A
           SET (
                  QTY001
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
               )
             = (SELECT
                        B.QTY001
                      , B.QTY002
                      , B.QTY003
                      , B.QTY004
                      , B.QTY005
                      , B.QTY006
                      , B.QTY007
                      , B.QTY008
                      , B.QTY009
                      , B.QTY010
                      , B.QTY011
                      , B.QTY012
                      , B.QTY013
                      , B.QTY014
                      , B.QTY015
                      , B.QTY016
                      , B.QTY017
                      , B.QTY018
                      , B.QTY019
                      , B.QTY020
                      , B.QTY021
                      , B.QTY022
                      , B.QTY023
                      , B.QTY024
                      , B.QTY025
                      , B.QTY026
                      , B.QTY027
                      , B.QTY028
                      , B.QTY029
                      , B.QTY030
                      , B.QTY031
                      , B.QTY032
                      , B.QTY033
                      , B.QTY034
                      , B.QTY035
                      , B.QTY036
                      , B.QTY037
                      , B.QTY038
                      , B.QTY039
                      , B.QTY040
                      , B.QTY041
                      , B.QTY042
                      , B.QTY043
                      , B.QTY044
                      , B.QTY045
                      , B.QTY046
                      , B.QTY047
                      , B.QTY048
                      , B.QTY049
                      , B.QTY050
                      , B.QTY051
                      , B.QTY052
                      , B.QTY053
                      , B.QTY054
                      , B.QTY055
                      , B.QTY056
                      , B.QTY057
                      , B.QTY058
                      , B.QTY059
                      , B.QTY060
                      , B.QTY061
                      , B.QTY062
                      , B.QTY063
                      , B.QTY064
                      , B.QTY065
                      , B.QTY066
                      , B.QTY067
                      , B.QTY068
                      , B.QTY069
                      , B.QTY070
                      , B.QTY071
                      , B.QTY072
                      , B.QTY073
                      , B.QTY074
                      , B.QTY075
                      , B.QTY076
                      , B.QTY077
                      , B.QTY078
                      , B.QTY079
                      , B.QTY080
                      , B.QTY081
                      , B.QTY082
                      , B.QTY083
                      , B.QTY084
                      , B.QTY085
                      , B.QTY086
                      , B.QTY087
                      , B.QTY088
                      , B.QTY089
                      , B.QTY090
                      , B.QTY091
                      , B.QTY092
                      , B.QTY093
                      , B.QTY094
                      , B.QTY095
                      , B.QTY096
                      , B.QTY097
                      , B.QTY098
                      , B.QTY099
                      , B.QTY100
                      , B.QTY101
                      , B.QTY102
                      , B.QTY103
                      , B.QTY104
                      , B.QTY105
                      , B.QTY106
                      , B.QTY107
                      , B.QTY108
                      , B.QTY109
                      , B.QTY110
                      , B.QTY111
                      , B.QTY112
                      , B.QTY113
                      , B.QTY114
                      , B.QTY115
                      , B.QTY116
                      , B.QTY117
                      , B.QTY118
                      , B.QTY119
                      , B.QTY120
                      , B.QTY121
                      , B.QTY122
                      , B.QTY123
                      , B.QTY124
                      , B.QTY125
                      , B.QTY126
                      , B.QTY127
                      , B.QTY128
                      , B.QTY129
                      , B.QTY130
                      , B.QTY131
                      , B.QTY132
                      , B.QTY133
                      , B.QTY134
                      , B.QTY135
                      , B.QTY136
                      , B.QTY137
                      , B.QTY138
                      , B.QTY139
                      , B.QTY140
                      , B.QTY141
                      , B.QTY142
                      , B.QTY143
                      , B.QTY144
                      , B.QTY145
                      , B.QTY146
                      , B.QTY147
                      , B.QTY148
                      , B.QTY149
                      , B.QTY150
                      , B.QTY151
                      , B.QTY152
                      , B.QTY153
                      , B.QTY154
                      , B.QTY155
                      , B.QTY156
                      , B.QTY157
                      , B.QTY158
                      , B.QTY159
                      , B.QTY160
                      , B.QTY161
                      , B.QTY162
                      , B.QTY163
                      , B.QTY164
                      , B.QTY165
                      , B.QTY166
                      , B.QTY167
                      , B.QTY168
                      , B.QTY169
                      , B.QTY170
                      , B.QTY171
                      , B.QTY172
                      , B.QTY173
                      , B.QTY174
                      , B.QTY175
                      , B.QTY176
                      , B.QTY177
                      , B.QTY178
                      , B.QTY179
                      , B.QTY180
                      , B.QTY181
                      , B.QTY182
                      , B.QTY183
                      , B.QTY184
                      , B.QTY185
                      , B.QTY186
                      , B.QTY187
                      , B.QTY188
                      , B.QTY189
                      , B.QTY190
                      , B.QTY191
                      , B.QTY192
                      , B.QTY193
                      , B.QTY194
                      , B.QTY195
                      , B.QTY196
                      , B.QTY197
                      , B.QTY198
                      , B.QTY199
                      , B.QTY200
                      , B.QTY201
                      , B.QTY202
                      , B.QTY203
                      , B.QTY204
                      , B.QTY205
                      , B.QTY206
                      , B.QTY207
                      , B.QTY208
                      , B.QTY209
                      , B.QTY210
                      , B.QTY211
                      , B.QTY212
                      , B.QTY213
                      , B.QTY214
                      , B.QTY215
                      , B.QTY216
                      , B.QTY217
                      , B.QTY218
                      , B.QTY219
                      , B.QTY220
                      , B.QTY221
                      , B.QTY222
                      , B.QTY223
                      , B.QTY224
                      , B.QTY225
                      , B.QTY226
                      , B.QTY227
                      , B.QTY228
                      , B.QTY229
                      , B.QTY230
                      , B.QTY231
                      , B.QTY232
                      , B.QTY233
                      , B.QTY234
                      , B.QTY235
                      , B.QTY236
                      , B.QTY237
                      , B.QTY238
                      , B.QTY239
                      , B.QTY240
                      , B.QTY241
                      , B.QTY242
                      , B.QTY243
                      , B.QTY244
                      , B.QTY245
                      , B.QTY246
                      , B.QTY247
                      , B.QTY248
                      , B.QTY249
                      , B.QTY250
                      , B.QTY251
                      , B.QTY252
                      , B.QTY253
                      , B.QTY254
                      , B.QTY255
                      , B.QTY256
                      , B.QTY257
                      , B.QTY258
                      , B.QTY259
                      , B.QTY260
                      , B.QTY261
                      , B.QTY262
                      , B.QTY263
                      , B.QTY264
                      , B.QTY265
                      , B.QTY266
                      , B.QTY267
                      , B.QTY268
                      , B.QTY269
                      , B.QTY270
                      , B.QTY271
                      , B.QTY272
                      , B.QTY273
                      , B.QTY274
                      , B.QTY275
                      , B.QTY276
                      , B.QTY277
                      , B.QTY278
                      , B.QTY279
                      , B.QTY280
                      , B.QTY281
                      , B.QTY282
                      , B.QTY283
                      , B.QTY284
                      , B.QTY285
                      , B.QTY286
                      , B.QTY287
                      , B.QTY288
                      , B.QTY289
                      , B.QTY290
                      , B.QTY291
                      , B.QTY292
                      , B.QTY293
                      , B.QTY294
                      , B.QTY295
                      , B.QTY296
                      , B.QTY297
                      , B.QTY298
                      , B.QTY299
                      , B.QTY300
                      , B.QTY301
                      , B.QTY302
                      , B.QTY303
                      , B.QTY304
                      , B.QTY305
                      , B.QTY306
                      , B.QTY307
                      , B.QTY308
                      , B.QTY309
                      , B.QTY310
                      , B.QTY311
                      , B.QTY312
                      , B.QTY313
                      , B.QTY314
                      , B.QTY315
                      , B.QTY316
                      , B.QTY317
                      , B.QTY318
                      , B.QTY319
                      , B.QTY320
                      , B.QTY321
                      , B.QTY322
                      , B.QTY323
                      , B.QTY324
                      , B.QTY325
                      , B.QTY326
                      , B.QTY327
                      , B.QTY328
                      , B.QTY329
                      , B.QTY330
                      , B.QTY331
                      , B.QTY332
                      , B.QTY333
                      , B.QTY334
                      , B.QTY335
                      , B.QTY336
                      , B.QTY337
                      , B.QTY338
                      , B.QTY339
                      , B.QTY340
                      , B.QTY341
                      , B.QTY342
                      , B.QTY343
                      , B.QTY344
                      , B.QTY345
                      , B.QTY346
                      , B.QTY347
                      , B.QTY348
                      , B.QTY349
                      , B.QTY350
                      , B.QTY351
                      , B.QTY352
                      , B.QTY353
                      , B.QTY354
                      , B.QTY355
                      , B.QTY356
                      , B.QTY357
                      , B.QTY358
                      , B.QTY359
                      , B.QTY360
                      , B.QTY361
                      , B.QTY362
                      , B.QTY363
                      , B.QTY364
                  FROM GT_XPSC_LINELOAD_PIVOT B
                 WHERE B.DIVISION_ID  = A.DIVISION_ID
                   AND B.SITE_ID      = A.SITE_ID
                   AND B.OPERATION_ID = A.ATTRIBUTE9
                   AND B.PROD_LINE    = A.PROD_LINE
                   AND B.MEASURE      = A.MEASURE)
         WHERE EXISTS (SELECT 1
                         FROM GT_XPSC_LINELOAD_PIVOT C
                        WHERE C.DIVISION_ID  = A.DIVISION_ID
                          AND C.SITE_ID      = A.SITE_ID
                          AND C.OPERATION_ID = A.ATTRIBUTE9
                          AND C.PROD_LINE    = A.PROD_LINE
                          AND C.MEASURE      = A.MEASURE)
           AND A.ATTRIBUTE10 = 'PROD_LOAD'
           AND A.MEASURE     = 'PROD_LOAD';

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 00600 ';
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
        /*  삭제 후 입력 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* --IF @p_update ='Y' */
        /* --  BEGIN */
        /* --    DELETE FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL */
        /* --          WHERE DIVISION_ID = @p_division_id */
        /* --          AND CELL_ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_CELL_PROD_Line_V WITH (NOLOCK) ) */
        /* --  END */
        /* --ELSE */
        /* --  BEGIN */
        /* --    DELETE FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL */
        /* --        WHERE DIVISION_ID = @p_division_id -- AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd AND PLAN_TYPE = @p_plan_type AND SEQ = @p_seq */
        /* --  END */

        /* XLS_KEY1 정렬 : MSSQL 은 NULL 을 가장 작은 값으로 정렬 → 오름차순 NULLS FIRST · 내림차순 NULLS LAST 명시 */
        INSERT
          INTO SCP_XLS_PSI_GLOBAL_SMALL_CELL
             ( DIVISION_ID
             , PLAN_START_YYYYMMDD
             , CREATE_FROM_YYYYMMDD
             , CREATE_TO_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , CELL_TYPE_GROUP_CODE
             , CELL_ITEM_ID
             , NICK_NAME
             , MEASURE
             , MEASURE_LABEL
             , SITE_ID
             , SITE_DESCRIPTION
             , PROD_LINE
             , YIELD
             , LT_WEEK
             , BOH
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
               /* --,WQTY01 ~ WQTY52 */
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
        SELECT DIVISION_ID
             , PLAN_START_YYYYMMDD
             , V_CREATE_FROM_YYYYMMDD
             , V_CREATE_TO_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , CELL_TYPE_GROUP_CODE
             , CELL_ITEM_ID
             , NICK_NAME
             , MEASURE
             , MEASURE_LABEL
             , SITE_ID
             , SITE_DESCRIPTION
             , PROD_LINE
             , YIELD
             , LT_WEEK
             , BOH
             , ROW_NUMBER() OVER(ORDER BY DIVISION_ID                                                 ASC  NULLS FIRST
                                        , CELL_TYPE_GROUP_CODE                                        DESC NULLS LAST
                                        , CELL_ITEM_ID                                                ASC  NULLS FIRST
                                        , (CASE WHEN (SITE_ID = '-') THEN 'ZZZ' ELSE SITE_ID END)     ASC  NULLS FIRST
                                        , PROD_LINE                                                   ASC  NULLS FIRST
                                        , SORT_ORDER_NO                                               ASC  NULLS FIRST
                                        , MEASURE_LABEL                                               DESC NULLS LAST) + N_MAX_XLS_KEY1 AS XLS_KEY1
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
               /* --,WQTY01 ~ WQTY52 */
             , V_USER_ID                                              AS CREATED_BY
             , SYSDATE                                                AS CREATION_DATE
             , V_USER_ID                                              AS LAST_UPDATED_BY
             , SYSDATE                                                AS LAST_UPDATE_DATE
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
          FROM GT_XPSC_XLS_PSI_SMALL_CELL;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 00700 ';
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
        /*  YIELD,LEAD TIME UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* LT_WEEK   반올림 로직 반영 */
        /*
              UPDATE X
                 SET X.YIELD      = Y.FORMATION_TOTAL_YIELD
                    ,X.LT_WEEK    = CONVERT(int, Y.TOTAL_LT_FORMATION/7) + (CASE WHEN (TOTAL_LT_FORMATION%7 > 0) THEN 1 ELSE 0 END)
               FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL X WITH (NOLOCK)
               INNER JOIN (
                              SELECT  ITEM_ID
--                                     ,PLANT_SITE_ID
                                     ,MAX(FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD
                                     ,MAX(TOTAL_LT_FORMATION)    AS TOTAL_LT_FORMATION
                                FROM dbo.SCP_MST_FORMATION_V Z  WITH (NOLOCK)
                                WHERE Z.DIVISION_ID = @p_division_id   -- '40'
                                GROUP BY ITEM_ID
                                        --,PLANT_SITE_ID
                          ) Y
                ON X.CELL_ITEM_ID = Y.ITEM_ID
  --              AND X.SITE_ID     = Y.PLANT_SITE_ID
                WHERE MEASURE = 'PROD_TOTAL'
        */
        /* UPDATE XX ... FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL XX INNER JOIN (..) YY → MERGE (YY 는 CELL_ITEM_ID 로 묶여 대응 행 하나) */
        MERGE
         INTO SCP_XLS_PSI_GLOBAL_SMALL_CELL A
        USING (SELECT MAX(SB.TOTAL_LT_FORMATION)                       AS TOTAL_LT_FORMATION
                    , AVG(SB.FORMATION_TOTAL_YIELD)                    AS FORMATION_TOTAL_YIELD
                    , SA.CELL_ITEM_ID
                 FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL SA
                    , (SELECT SC.ITEM_ID
                            , SC.PLANT_SITE_ID
                            , MAX(SC.FORMATION_TOTAL_YIELD)            AS FORMATION_TOTAL_YIELD
                            , MAX(SC.TOTAL_LT_FORMATION)               AS TOTAL_LT_FORMATION
                            , ROW_NUMBER() OVER(PARTITION BY SC.ITEM_ID ORDER BY MAX(SC.TOTAL_LT_FORMATION) DESC NULLS LAST) AS RN
                         FROM SCP_MST_FORMATION_V SC
                        WHERE SC.DIVISION_ID = '40'
                        GROUP BY SC.ITEM_ID
                               , SC.PLANT_SITE_ID) SB
                WHERE SA.CELL_ITEM_ID         = SB.ITEM_ID
                  AND SA.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
                  /* -- AND X.SITE_ID     = Y.PLANT_SITE_ID */
                  AND SA.MEASURE              = 'PROD'
                  AND SB.RN                   = 1
                GROUP BY SA.CELL_ITEM_ID  /* --,FORMATION_TOTAL_YIELD */
              ) IA
           ON (    A.CELL_ITEM_ID         = IA.CELL_ITEM_ID
               AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
               AND A.MEASURE              = 'PROD_TOTAL')
         WHEN MATCHED THEN
       UPDATE
          SET A.LT_WEEK    = TRUNC(IA.TOTAL_LT_FORMATION / 7) + (CASE WHEN (MOD(IA.TOTAL_LT_FORMATION, 7) > 0) THEN 1 ELSE 0 END)
              /* --,XX.YIELD      = YY.FORMATION_TOTAL_YIELD */
            , A.ATTRIBUTE3 = TO_CHAR(IA.TOTAL_LT_FORMATION);

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 00800 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* SSP_MODIFY_YIELD가 0이거나 100 이면, 0이나 100을 제외한 SSP_MODIFY_YIELD의 평균값 */
        /* AVG : MSSQL 은 NUMERIC(20,10) 평균을 소수 10자리에서 버림 → TRUNC(AVG(..), 10) */
        MERGE
         INTO SCP_XLS_PSI_GLOBAL_SMALL_CELL A
        USING (SELECT SA.ITEM_ID
                      /* --,PLANT_SITE_ID */
                      /* --,MAX(FORMATION_TOTAL_YIELD) AS FORMATION_TOTAL_YIELD */
                      /* --,SSP_MODIFY_YIELD */
                      /* --,COUNT(*) AS CNT */
                    , TRUNC(AVG(SA.SSP_MODIFY_YIELD), 10)              AS SSP_MODIFY_YIELD_AVG
                 FROM SCP_MST_FORMATION_V SA
                WHERE SA.DIVISION_ID       = '40'
                  AND SA.SSP_MODIFY_YIELD <> 0.0
                  AND SA.SSP_MODIFY_YIELD <> 1.0
                GROUP BY SA.ITEM_ID
              ) IA
           ON (    A.CELL_ITEM_ID         = IA.ITEM_ID
               AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
               AND A.MEASURE              = 'PROD_TOTAL')
         WHEN MATCHED THEN
       UPDATE
          SET A.YIELD = IA.SSP_MODIFY_YIELD_AVG;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 00900 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* SSP_MODIFY_YIELD가 0일 경우 소형 전체 SSP_MODIFY_YIELD 값의 평균 값으로 UPDATE */
        SELECT TRUNC(AVG(SSP_MODIFY_YIELD), 10)
          INTO N_SSP_MODIFY_YIELD
          FROM SCP_MST_FORMATION_V
         WHERE DIVISION_ID       = '40'
           AND SSP_MODIFY_YIELD <> 0.0
           AND SSP_MODIFY_YIELD <> 1.0;

        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_CELL
           SET YIELD = N_SSP_MODIFY_YIELD
         WHERE MEASURE              = 'PROD_TOTAL'
           AND CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
           AND YIELD                = 0.0;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 01000 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* --(원문 블록 주석 열기 표시 : 주석 안 주석 기호라 기호만 생략) */
        /* ------------------------------------------------------------------------------------------------------------- */
        /*  DIO 관련 시뮬레이션 추가 */
        /*  2020.07.06   KSW         DIO 수정 관련 */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#tmp_SCP_MST_DIO') IS NOT NULL DROP TABLE #tmp_SCP_MST_DIO */
        /* #tmp_SCP_MST_DIO 는 아래 UPDATE 한 곳에서만 읽으므로 인라인 뷰(IA)로 옮김 */
        /* --and a.YYYYMM      like '201912' -- @p_plan_start_yyyymmdd -- */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 01100 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* UPDATE X SET X.ATTRIBUTE4 = Z.GRO_STD_DIO, X.ATTRIBUTE5 = Z.MIN_STD_DIO FROM .. INNER JOIN #tmp_SCP_MST_DIO Z */
        /* 품목 하나에 공장 여러 개면 MSSQL 은 임의 한 행을 씀 → ROWNUM = 1 한 행으로 두 칸을 함께 채움 */
        /* NUMERIC(17,3) → NVARCHAR 변환은 소수 3자리 고정 문자('12.500') → TO_CHAR 형식 지정 */
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_CELL A
           SET (A.ATTRIBUTE4, A.ATTRIBUTE5)
             = (SELECT TO_CHAR(IA.GRO_STD_DIO, 'FM99999999999990.000')
                     , TO_CHAR(IA.MIN_STD_DIO, 'FM99999999999990.000')
                  FROM (SELECT B.DIVISION_ID
                             , B.PLANT_ID
                             , B.ITEM_ID
                             , B.GRO_STD_DIO
                             , B.MIN_STD_DIO
                          FROM SCP_MST_DIO B
                             , (SELECT SB.DIVISION_ID
                                     , SB.PLANT_ID
                                     , MAX(SB.YYYYQ) AS YYYYQ
                                  FROM SCP_MST_DIO SB
                                 WHERE SB.DIVISION_ID IS NOT NULL
                                 GROUP BY SB.DIVISION_ID
                                        , SB.PLANT_ID) SA
                         WHERE B.DIVISION_ID = SA.DIVISION_ID
                           AND B.PLANT_ID    = SA.PLANT_ID
                           AND B.YYYYQ       = SA.YYYYQ
                           AND B.DIVISION_ID = V_DIVISION_ID) IA
                 WHERE IA.ITEM_ID = A.CELL_ITEM_ID
                   /* -- AND X.FROM_SITE   = Z.PLANT_ID */
                   AND ROWNUM     = 1)
         WHERE EXISTS (SELECT 1
                         FROM SCP_MST_DIO C
                            , (SELECT SC.DIVISION_ID
                                    , SC.PLANT_ID
                                    , MAX(SC.YYYYQ) AS YYYYQ
                                 FROM SCP_MST_DIO SC
                                WHERE SC.DIVISION_ID IS NOT NULL
                                GROUP BY SC.DIVISION_ID
                                       , SC.PLANT_ID) XA
                        WHERE C.DIVISION_ID = XA.DIVISION_ID
                          AND C.PLANT_ID    = XA.PLANT_ID
                          AND C.YYYYQ       = XA.YYYYQ
                          AND C.ITEM_ID     = A.CELL_ITEM_ID
                          AND C.DIVISION_ID = V_DIVISION_ID)
           AND A.MEASURE              = 'DIO'
           AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD;  /* * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
        /* --(원문 블록 주석 닫기 표시 : 주석 안 주석 기호라 기호만 생략) */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 01200 ';
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
        /*  52주 데이터 SCRIPT 생성후 UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#Rn') IS NOT NULL DROP TABLE #Rn */
        /* CREATE TABLE #Rn ( WEEK_COLUMN NVARCHAR(6), Rn INT ) */
        /* INSERT INTO #Rn SELECT 'WQTY01', 1 UNION ALL ... SELECT 'WQTY52', 364 */
        /*   → 일련번호 n(1~364)은 주 칸 'WQTY' || LPAD(TRUNC((n - 1) / 7) + 1, 2, '0') 에 대응(7일 단위, 52주) */

        /* --  SELECT 'WQTY' + A.ISO_WEEK     AS WEEK_COLUMN */
        /* --  , ROW_NUMBER() OVER (ORDER BY ISO_WEEK) AS Rn */
        /* --  INTO #Rn */
        /* -- FROM DBO.SCM_SYS_CALENDAR_M A  WITH(NOLOCK) */
        /* --WHERE A.BASIS_YYYYMMDD     >= @p_plan_start_yyyymmdd */
        /* --    AND A.BASIS_YYYYMMDD     <  @p_to_yyyymmdd */

        /* IF OBJECT_ID('tempdb..#CALENDAR') IS NOT NULL DROP TABLE #CALENDAR */
        /* #CALENDAR : 생성 구간 달력 일자에 ROW_NUMBER(정렬 A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31)) 부여 */
        /*             GROUP BY A.BASIS_YYYYMMDD--,ISO_WEEK--,A.BASIS_YYYYMM,ISO_WEEK */
        /* IF OBJECT_ID('tempdb..#HEADER') IS NOT NULL DROP TABLE #HEADER */
        /* #HEADER : #CALENDAR X INNER JOIN #Rn Y ON X.Rn = Y.Rn (order by x.rn) → 일련번호 1~364 중 달력에 있는 일자만 남음 */
        SELECT LEAST(COUNT(*), 364)
          INTO N_DAY_CNT
          FROM (SELECT A.BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M A
                 WHERE A.BASIS_YYYYMMDD >= V_CREATE_FROM_YYYYMMDD
                   AND A.BASIS_YYYYMMDD <= V_CREATE_TO_YYYYMMDD
                 GROUP BY A.BASIS_YYYYMMDD);

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 01300 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* DECLARE @mQry_sumWeek NVARCHAR(MAX); */
        /* AS-IS : #HEADER 에 있는 주 칸만 'WQTYnn = (QTYa+QTYb+...)' 로 조립해 sp_executesql 로 실행 */
        /*   → 정적 SQL : 일자 수(N_DAY_CNT) 밖의 주 칸은 기존 값 유지, 일자 수 밖의 일자 칸은 더하지 않음(0 으로 대체) */
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_CELL
           SET
                 WQTY01 = CASE WHEN N_DAY_CNT >=   1
                                     THEN (  QTY001
                                           + CASE WHEN N_DAY_CNT >=   2 THEN QTY002 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=   3 THEN QTY003 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=   4 THEN QTY004 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=   5 THEN QTY005 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=   6 THEN QTY006 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=   7 THEN QTY007 ELSE 0 END)
                                     ELSE WQTY01
                                END
               , WQTY02 = CASE WHEN N_DAY_CNT >=   8
                                     THEN (  QTY008
                                           + CASE WHEN N_DAY_CNT >=   9 THEN QTY009 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  10 THEN QTY010 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  11 THEN QTY011 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  12 THEN QTY012 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  13 THEN QTY013 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  14 THEN QTY014 ELSE 0 END)
                                     ELSE WQTY02
                                END
               , WQTY03 = CASE WHEN N_DAY_CNT >=  15
                                     THEN (  QTY015
                                           + CASE WHEN N_DAY_CNT >=  16 THEN QTY016 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  17 THEN QTY017 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  18 THEN QTY018 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  19 THEN QTY019 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  20 THEN QTY020 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  21 THEN QTY021 ELSE 0 END)
                                     ELSE WQTY03
                                END
               , WQTY04 = CASE WHEN N_DAY_CNT >=  22
                                     THEN (  QTY022
                                           + CASE WHEN N_DAY_CNT >=  23 THEN QTY023 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  24 THEN QTY024 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  25 THEN QTY025 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  26 THEN QTY026 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  27 THEN QTY027 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  28 THEN QTY028 ELSE 0 END)
                                     ELSE WQTY04
                                END
               , WQTY05 = CASE WHEN N_DAY_CNT >=  29
                                     THEN (  QTY029
                                           + CASE WHEN N_DAY_CNT >=  30 THEN QTY030 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  31 THEN QTY031 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  32 THEN QTY032 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  33 THEN QTY033 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  34 THEN QTY034 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  35 THEN QTY035 ELSE 0 END)
                                     ELSE WQTY05
                                END
               , WQTY06 = CASE WHEN N_DAY_CNT >=  36
                                     THEN (  QTY036
                                           + CASE WHEN N_DAY_CNT >=  37 THEN QTY037 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  38 THEN QTY038 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  39 THEN QTY039 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  40 THEN QTY040 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  41 THEN QTY041 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  42 THEN QTY042 ELSE 0 END)
                                     ELSE WQTY06
                                END
               , WQTY07 = CASE WHEN N_DAY_CNT >=  43
                                     THEN (  QTY043
                                           + CASE WHEN N_DAY_CNT >=  44 THEN QTY044 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  45 THEN QTY045 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  46 THEN QTY046 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  47 THEN QTY047 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  48 THEN QTY048 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  49 THEN QTY049 ELSE 0 END)
                                     ELSE WQTY07
                                END
               , WQTY08 = CASE WHEN N_DAY_CNT >=  50
                                     THEN (  QTY050
                                           + CASE WHEN N_DAY_CNT >=  51 THEN QTY051 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  52 THEN QTY052 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  53 THEN QTY053 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  54 THEN QTY054 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  55 THEN QTY055 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  56 THEN QTY056 ELSE 0 END)
                                     ELSE WQTY08
                                END
               , WQTY09 = CASE WHEN N_DAY_CNT >=  57
                                     THEN (  QTY057
                                           + CASE WHEN N_DAY_CNT >=  58 THEN QTY058 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  59 THEN QTY059 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  60 THEN QTY060 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  61 THEN QTY061 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  62 THEN QTY062 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  63 THEN QTY063 ELSE 0 END)
                                     ELSE WQTY09
                                END
               , WQTY10 = CASE WHEN N_DAY_CNT >=  64
                                     THEN (  QTY064
                                           + CASE WHEN N_DAY_CNT >=  65 THEN QTY065 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  66 THEN QTY066 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  67 THEN QTY067 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  68 THEN QTY068 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  69 THEN QTY069 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  70 THEN QTY070 ELSE 0 END)
                                     ELSE WQTY10
                                END
               , WQTY11 = CASE WHEN N_DAY_CNT >=  71
                                     THEN (  QTY071
                                           + CASE WHEN N_DAY_CNT >=  72 THEN QTY072 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  73 THEN QTY073 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  74 THEN QTY074 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  75 THEN QTY075 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  76 THEN QTY076 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  77 THEN QTY077 ELSE 0 END)
                                     ELSE WQTY11
                                END
               , WQTY12 = CASE WHEN N_DAY_CNT >=  78
                                     THEN (  QTY078
                                           + CASE WHEN N_DAY_CNT >=  79 THEN QTY079 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  80 THEN QTY080 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  81 THEN QTY081 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  82 THEN QTY082 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  83 THEN QTY083 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  84 THEN QTY084 ELSE 0 END)
                                     ELSE WQTY12
                                END
               , WQTY13 = CASE WHEN N_DAY_CNT >=  85
                                     THEN (  QTY085
                                           + CASE WHEN N_DAY_CNT >=  86 THEN QTY086 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  87 THEN QTY087 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  88 THEN QTY088 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  89 THEN QTY089 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  90 THEN QTY090 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  91 THEN QTY091 ELSE 0 END)
                                     ELSE WQTY13
                                END
               , WQTY14 = CASE WHEN N_DAY_CNT >=  92
                                     THEN (  QTY092
                                           + CASE WHEN N_DAY_CNT >=  93 THEN QTY093 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  94 THEN QTY094 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  95 THEN QTY095 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  96 THEN QTY096 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  97 THEN QTY097 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >=  98 THEN QTY098 ELSE 0 END)
                                     ELSE WQTY14
                                END
               , WQTY15 = CASE WHEN N_DAY_CNT >=  99
                                     THEN (  QTY099
                                           + CASE WHEN N_DAY_CNT >= 100 THEN QTY100 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 101 THEN QTY101 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 102 THEN QTY102 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 103 THEN QTY103 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 104 THEN QTY104 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 105 THEN QTY105 ELSE 0 END)
                                     ELSE WQTY15
                                END
               , WQTY16 = CASE WHEN N_DAY_CNT >= 106
                                     THEN (  QTY106
                                           + CASE WHEN N_DAY_CNT >= 107 THEN QTY107 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 108 THEN QTY108 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 109 THEN QTY109 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 110 THEN QTY110 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 111 THEN QTY111 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 112 THEN QTY112 ELSE 0 END)
                                     ELSE WQTY16
                                END
               , WQTY17 = CASE WHEN N_DAY_CNT >= 113
                                     THEN (  QTY113
                                           + CASE WHEN N_DAY_CNT >= 114 THEN QTY114 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 115 THEN QTY115 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 116 THEN QTY116 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 117 THEN QTY117 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 118 THEN QTY118 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 119 THEN QTY119 ELSE 0 END)
                                     ELSE WQTY17
                                END
               , WQTY18 = CASE WHEN N_DAY_CNT >= 120
                                     THEN (  QTY120
                                           + CASE WHEN N_DAY_CNT >= 121 THEN QTY121 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 122 THEN QTY122 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 123 THEN QTY123 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 124 THEN QTY124 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 125 THEN QTY125 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 126 THEN QTY126 ELSE 0 END)
                                     ELSE WQTY18
                                END
               , WQTY19 = CASE WHEN N_DAY_CNT >= 127
                                     THEN (  QTY127
                                           + CASE WHEN N_DAY_CNT >= 128 THEN QTY128 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 129 THEN QTY129 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 130 THEN QTY130 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 131 THEN QTY131 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 132 THEN QTY132 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 133 THEN QTY133 ELSE 0 END)
                                     ELSE WQTY19
                                END
               , WQTY20 = CASE WHEN N_DAY_CNT >= 134
                                     THEN (  QTY134
                                           + CASE WHEN N_DAY_CNT >= 135 THEN QTY135 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 136 THEN QTY136 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 137 THEN QTY137 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 138 THEN QTY138 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 139 THEN QTY139 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 140 THEN QTY140 ELSE 0 END)
                                     ELSE WQTY20
                                END
               , WQTY21 = CASE WHEN N_DAY_CNT >= 141
                                     THEN (  QTY141
                                           + CASE WHEN N_DAY_CNT >= 142 THEN QTY142 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 143 THEN QTY143 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 144 THEN QTY144 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 145 THEN QTY145 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 146 THEN QTY146 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 147 THEN QTY147 ELSE 0 END)
                                     ELSE WQTY21
                                END
               , WQTY22 = CASE WHEN N_DAY_CNT >= 148
                                     THEN (  QTY148
                                           + CASE WHEN N_DAY_CNT >= 149 THEN QTY149 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 150 THEN QTY150 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 151 THEN QTY151 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 152 THEN QTY152 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 153 THEN QTY153 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 154 THEN QTY154 ELSE 0 END)
                                     ELSE WQTY22
                                END
               , WQTY23 = CASE WHEN N_DAY_CNT >= 155
                                     THEN (  QTY155
                                           + CASE WHEN N_DAY_CNT >= 156 THEN QTY156 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 157 THEN QTY157 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 158 THEN QTY158 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 159 THEN QTY159 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 160 THEN QTY160 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 161 THEN QTY161 ELSE 0 END)
                                     ELSE WQTY23
                                END
               , WQTY24 = CASE WHEN N_DAY_CNT >= 162
                                     THEN (  QTY162
                                           + CASE WHEN N_DAY_CNT >= 163 THEN QTY163 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 164 THEN QTY164 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 165 THEN QTY165 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 166 THEN QTY166 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 167 THEN QTY167 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 168 THEN QTY168 ELSE 0 END)
                                     ELSE WQTY24
                                END
               , WQTY25 = CASE WHEN N_DAY_CNT >= 169
                                     THEN (  QTY169
                                           + CASE WHEN N_DAY_CNT >= 170 THEN QTY170 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 171 THEN QTY171 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 172 THEN QTY172 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 173 THEN QTY173 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 174 THEN QTY174 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 175 THEN QTY175 ELSE 0 END)
                                     ELSE WQTY25
                                END
               , WQTY26 = CASE WHEN N_DAY_CNT >= 176
                                     THEN (  QTY176
                                           + CASE WHEN N_DAY_CNT >= 177 THEN QTY177 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 178 THEN QTY178 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 179 THEN QTY179 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 180 THEN QTY180 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 181 THEN QTY181 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 182 THEN QTY182 ELSE 0 END)
                                     ELSE WQTY26
                                END
               , WQTY27 = CASE WHEN N_DAY_CNT >= 183
                                     THEN (  QTY183
                                           + CASE WHEN N_DAY_CNT >= 184 THEN QTY184 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 185 THEN QTY185 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 186 THEN QTY186 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 187 THEN QTY187 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 188 THEN QTY188 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 189 THEN QTY189 ELSE 0 END)
                                     ELSE WQTY27
                                END
               , WQTY28 = CASE WHEN N_DAY_CNT >= 190
                                     THEN (  QTY190
                                           + CASE WHEN N_DAY_CNT >= 191 THEN QTY191 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 192 THEN QTY192 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 193 THEN QTY193 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 194 THEN QTY194 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 195 THEN QTY195 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 196 THEN QTY196 ELSE 0 END)
                                     ELSE WQTY28
                                END
               , WQTY29 = CASE WHEN N_DAY_CNT >= 197
                                     THEN (  QTY197
                                           + CASE WHEN N_DAY_CNT >= 198 THEN QTY198 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 199 THEN QTY199 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 200 THEN QTY200 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 201 THEN QTY201 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 202 THEN QTY202 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 203 THEN QTY203 ELSE 0 END)
                                     ELSE WQTY29
                                END
               , WQTY30 = CASE WHEN N_DAY_CNT >= 204
                                     THEN (  QTY204
                                           + CASE WHEN N_DAY_CNT >= 205 THEN QTY205 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 206 THEN QTY206 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 207 THEN QTY207 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 208 THEN QTY208 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 209 THEN QTY209 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 210 THEN QTY210 ELSE 0 END)
                                     ELSE WQTY30
                                END
               , WQTY31 = CASE WHEN N_DAY_CNT >= 211
                                     THEN (  QTY211
                                           + CASE WHEN N_DAY_CNT >= 212 THEN QTY212 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 213 THEN QTY213 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 214 THEN QTY214 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 215 THEN QTY215 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 216 THEN QTY216 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 217 THEN QTY217 ELSE 0 END)
                                     ELSE WQTY31
                                END
               , WQTY32 = CASE WHEN N_DAY_CNT >= 218
                                     THEN (  QTY218
                                           + CASE WHEN N_DAY_CNT >= 219 THEN QTY219 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 220 THEN QTY220 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 221 THEN QTY221 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 222 THEN QTY222 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 223 THEN QTY223 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 224 THEN QTY224 ELSE 0 END)
                                     ELSE WQTY32
                                END
               , WQTY33 = CASE WHEN N_DAY_CNT >= 225
                                     THEN (  QTY225
                                           + CASE WHEN N_DAY_CNT >= 226 THEN QTY226 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 227 THEN QTY227 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 228 THEN QTY228 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 229 THEN QTY229 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 230 THEN QTY230 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 231 THEN QTY231 ELSE 0 END)
                                     ELSE WQTY33
                                END
               , WQTY34 = CASE WHEN N_DAY_CNT >= 232
                                     THEN (  QTY232
                                           + CASE WHEN N_DAY_CNT >= 233 THEN QTY233 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 234 THEN QTY234 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 235 THEN QTY235 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 236 THEN QTY236 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 237 THEN QTY237 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 238 THEN QTY238 ELSE 0 END)
                                     ELSE WQTY34
                                END
               , WQTY35 = CASE WHEN N_DAY_CNT >= 239
                                     THEN (  QTY239
                                           + CASE WHEN N_DAY_CNT >= 240 THEN QTY240 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 241 THEN QTY241 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 242 THEN QTY242 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 243 THEN QTY243 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 244 THEN QTY244 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 245 THEN QTY245 ELSE 0 END)
                                     ELSE WQTY35
                                END
               , WQTY36 = CASE WHEN N_DAY_CNT >= 246
                                     THEN (  QTY246
                                           + CASE WHEN N_DAY_CNT >= 247 THEN QTY247 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 248 THEN QTY248 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 249 THEN QTY249 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 250 THEN QTY250 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 251 THEN QTY251 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 252 THEN QTY252 ELSE 0 END)
                                     ELSE WQTY36
                                END
               , WQTY37 = CASE WHEN N_DAY_CNT >= 253
                                     THEN (  QTY253
                                           + CASE WHEN N_DAY_CNT >= 254 THEN QTY254 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 255 THEN QTY255 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 256 THEN QTY256 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 257 THEN QTY257 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 258 THEN QTY258 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 259 THEN QTY259 ELSE 0 END)
                                     ELSE WQTY37
                                END
               , WQTY38 = CASE WHEN N_DAY_CNT >= 260
                                     THEN (  QTY260
                                           + CASE WHEN N_DAY_CNT >= 261 THEN QTY261 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 262 THEN QTY262 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 263 THEN QTY263 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 264 THEN QTY264 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 265 THEN QTY265 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 266 THEN QTY266 ELSE 0 END)
                                     ELSE WQTY38
                                END
               , WQTY39 = CASE WHEN N_DAY_CNT >= 267
                                     THEN (  QTY267
                                           + CASE WHEN N_DAY_CNT >= 268 THEN QTY268 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 269 THEN QTY269 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 270 THEN QTY270 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 271 THEN QTY271 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 272 THEN QTY272 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 273 THEN QTY273 ELSE 0 END)
                                     ELSE WQTY39
                                END
               , WQTY40 = CASE WHEN N_DAY_CNT >= 274
                                     THEN (  QTY274
                                           + CASE WHEN N_DAY_CNT >= 275 THEN QTY275 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 276 THEN QTY276 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 277 THEN QTY277 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 278 THEN QTY278 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 279 THEN QTY279 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 280 THEN QTY280 ELSE 0 END)
                                     ELSE WQTY40
                                END
               , WQTY41 = CASE WHEN N_DAY_CNT >= 281
                                     THEN (  QTY281
                                           + CASE WHEN N_DAY_CNT >= 282 THEN QTY282 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 283 THEN QTY283 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 284 THEN QTY284 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 285 THEN QTY285 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 286 THEN QTY286 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 287 THEN QTY287 ELSE 0 END)
                                     ELSE WQTY41
                                END
               , WQTY42 = CASE WHEN N_DAY_CNT >= 288
                                     THEN (  QTY288
                                           + CASE WHEN N_DAY_CNT >= 289 THEN QTY289 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 290 THEN QTY290 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 291 THEN QTY291 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 292 THEN QTY292 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 293 THEN QTY293 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 294 THEN QTY294 ELSE 0 END)
                                     ELSE WQTY42
                                END
               , WQTY43 = CASE WHEN N_DAY_CNT >= 295
                                     THEN (  QTY295
                                           + CASE WHEN N_DAY_CNT >= 296 THEN QTY296 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 297 THEN QTY297 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 298 THEN QTY298 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 299 THEN QTY299 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 300 THEN QTY300 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 301 THEN QTY301 ELSE 0 END)
                                     ELSE WQTY43
                                END
               , WQTY44 = CASE WHEN N_DAY_CNT >= 302
                                     THEN (  QTY302
                                           + CASE WHEN N_DAY_CNT >= 303 THEN QTY303 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 304 THEN QTY304 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 305 THEN QTY305 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 306 THEN QTY306 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 307 THEN QTY307 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 308 THEN QTY308 ELSE 0 END)
                                     ELSE WQTY44
                                END
               , WQTY45 = CASE WHEN N_DAY_CNT >= 309
                                     THEN (  QTY309
                                           + CASE WHEN N_DAY_CNT >= 310 THEN QTY310 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 311 THEN QTY311 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 312 THEN QTY312 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 313 THEN QTY313 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 314 THEN QTY314 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 315 THEN QTY315 ELSE 0 END)
                                     ELSE WQTY45
                                END
               , WQTY46 = CASE WHEN N_DAY_CNT >= 316
                                     THEN (  QTY316
                                           + CASE WHEN N_DAY_CNT >= 317 THEN QTY317 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 318 THEN QTY318 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 319 THEN QTY319 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 320 THEN QTY320 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 321 THEN QTY321 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 322 THEN QTY322 ELSE 0 END)
                                     ELSE WQTY46
                                END
               , WQTY47 = CASE WHEN N_DAY_CNT >= 323
                                     THEN (  QTY323
                                           + CASE WHEN N_DAY_CNT >= 324 THEN QTY324 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 325 THEN QTY325 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 326 THEN QTY326 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 327 THEN QTY327 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 328 THEN QTY328 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 329 THEN QTY329 ELSE 0 END)
                                     ELSE WQTY47
                                END
               , WQTY48 = CASE WHEN N_DAY_CNT >= 330
                                     THEN (  QTY330
                                           + CASE WHEN N_DAY_CNT >= 331 THEN QTY331 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 332 THEN QTY332 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 333 THEN QTY333 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 334 THEN QTY334 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 335 THEN QTY335 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 336 THEN QTY336 ELSE 0 END)
                                     ELSE WQTY48
                                END
               , WQTY49 = CASE WHEN N_DAY_CNT >= 337
                                     THEN (  QTY337
                                           + CASE WHEN N_DAY_CNT >= 338 THEN QTY338 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 339 THEN QTY339 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 340 THEN QTY340 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 341 THEN QTY341 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 342 THEN QTY342 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 343 THEN QTY343 ELSE 0 END)
                                     ELSE WQTY49
                                END
               , WQTY50 = CASE WHEN N_DAY_CNT >= 344
                                     THEN (  QTY344
                                           + CASE WHEN N_DAY_CNT >= 345 THEN QTY345 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 346 THEN QTY346 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 347 THEN QTY347 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 348 THEN QTY348 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 349 THEN QTY349 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 350 THEN QTY350 ELSE 0 END)
                                     ELSE WQTY50
                                END
               , WQTY51 = CASE WHEN N_DAY_CNT >= 351
                                     THEN (  QTY351
                                           + CASE WHEN N_DAY_CNT >= 352 THEN QTY352 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 353 THEN QTY353 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 354 THEN QTY354 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 355 THEN QTY355 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 356 THEN QTY356 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 357 THEN QTY357 ELSE 0 END)
                                     ELSE WQTY51
                                END
               , WQTY52 = CASE WHEN N_DAY_CNT >= 358
                                     THEN (  QTY358
                                           + CASE WHEN N_DAY_CNT >= 359 THEN QTY359 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 360 THEN QTY360 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 361 THEN QTY361 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 362 THEN QTY362 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 363 THEN QTY363 ELSE 0 END
                                           + CASE WHEN N_DAY_CNT >= 364 THEN QTY364 ELSE 0 END)
                                     ELSE WQTY52
                                END
         WHERE CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD;  /* * 2021.05.25   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */

        /* --              PRINT @mQry_sumWeek */
        /* EXEC sp_executesql @mQry_sumWeek; */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 01400 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* -- */
        /* ------------------------------------------------------------------------------------------------------------- */
        /*  WEEK SUM PIVOT 생성 후 UPDATE */
        /* ------------------------------------------------------------------------------------------------------------- */
        /* IF OBJECT_ID('tempdb..#LineLoad_WEEK') IS NOT NULL DROP TABLE #LineLoad_WEEK; */
        /* #LineLoad_WEEK 는 아래 PIVOT 한 곳에서만 읽으므로 인라인 뷰(IA)로 옮기고 PIVOT 결과만 GTT 에 적재 */

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 01500 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* IF OBJECT_ID('tempdb..#LineLoad_WEEK_PIVOT') IS NOT NULL DROP TABLE #LineLoad_WEEK_PIVOT; */
        /* PIVOT ( MIN(WQTY) FOR WEEK_COLUMN IN ([WQTY01] ~ [WQTY52]) ) → MIN(CASE ..) 로 펼침 */
        DELETE FROM GT_XPSC_LINELOAD_WEEK_PIVOT;

        INSERT
          INTO GT_XPSC_LINELOAD_WEEK_PIVOT
             ( DIVISION_ID
             , SITE_ID
             , OPERATION_ID
             , PROD_LINE
             , MEASURE
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
             )
        SELECT IA.DIVISION_ID
             , IA.SITE_ID
             , IA.OPERATION_ID
             , IA.PROD_LINE
             , IA.MEASURE
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY01' THEN IA.WQTY END) AS WQTY01
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY02' THEN IA.WQTY END) AS WQTY02
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY03' THEN IA.WQTY END) AS WQTY03
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY04' THEN IA.WQTY END) AS WQTY04
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY05' THEN IA.WQTY END) AS WQTY05
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY06' THEN IA.WQTY END) AS WQTY06
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY07' THEN IA.WQTY END) AS WQTY07
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY08' THEN IA.WQTY END) AS WQTY08
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY09' THEN IA.WQTY END) AS WQTY09
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY10' THEN IA.WQTY END) AS WQTY10
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY11' THEN IA.WQTY END) AS WQTY11
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY12' THEN IA.WQTY END) AS WQTY12
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY13' THEN IA.WQTY END) AS WQTY13
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY14' THEN IA.WQTY END) AS WQTY14
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY15' THEN IA.WQTY END) AS WQTY15
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY16' THEN IA.WQTY END) AS WQTY16
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY17' THEN IA.WQTY END) AS WQTY17
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY18' THEN IA.WQTY END) AS WQTY18
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY19' THEN IA.WQTY END) AS WQTY19
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY20' THEN IA.WQTY END) AS WQTY20
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY21' THEN IA.WQTY END) AS WQTY21
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY22' THEN IA.WQTY END) AS WQTY22
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY23' THEN IA.WQTY END) AS WQTY23
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY24' THEN IA.WQTY END) AS WQTY24
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY25' THEN IA.WQTY END) AS WQTY25
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY26' THEN IA.WQTY END) AS WQTY26
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY27' THEN IA.WQTY END) AS WQTY27
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY28' THEN IA.WQTY END) AS WQTY28
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY29' THEN IA.WQTY END) AS WQTY29
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY30' THEN IA.WQTY END) AS WQTY30
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY31' THEN IA.WQTY END) AS WQTY31
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY32' THEN IA.WQTY END) AS WQTY32
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY33' THEN IA.WQTY END) AS WQTY33
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY34' THEN IA.WQTY END) AS WQTY34
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY35' THEN IA.WQTY END) AS WQTY35
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY36' THEN IA.WQTY END) AS WQTY36
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY37' THEN IA.WQTY END) AS WQTY37
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY38' THEN IA.WQTY END) AS WQTY38
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY39' THEN IA.WQTY END) AS WQTY39
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY40' THEN IA.WQTY END) AS WQTY40
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY41' THEN IA.WQTY END) AS WQTY41
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY42' THEN IA.WQTY END) AS WQTY42
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY43' THEN IA.WQTY END) AS WQTY43
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY44' THEN IA.WQTY END) AS WQTY44
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY45' THEN IA.WQTY END) AS WQTY45
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY46' THEN IA.WQTY END) AS WQTY46
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY47' THEN IA.WQTY END) AS WQTY47
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY48' THEN IA.WQTY END) AS WQTY48
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY49' THEN IA.WQTY END) AS WQTY49
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY50' THEN IA.WQTY END) AS WQTY50
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY51' THEN IA.WQTY END) AS WQTY51
             , MIN(CASE WHEN IA.WEEK_COLUMN = 'WQTY52' THEN IA.WQTY END) AS WQTY52
          FROM (SELECT A.DIVISION_ID
                     , A.SITE_ID
                     , A.OPERATION_ID
                     , A.PROD_LINE
                     , A.MEASURE
                     , CASE WHEN SUM(A.WORKING_TIME) <= 0.0 THEN 0
                            ELSE NVL( ( ROUND(SUM(A.CAPA_TACT), 0) / SUM(A.WORKING_TIME) ), 0 ) * 100
                       END                                            AS WQTY
                     , A.ISO_YYYYWW
                     , A.WEEK_COLUMN
                  FROM GT_XPSC_LINELOAD A
                 GROUP BY A.DIVISION_ID
                        , A.SITE_ID
                        , A.OPERATION_ID
                        , A.PROD_LINE
                        , A.MEASURE
                        , A.ISO_YYYYWW
                        , A.WEEK_COLUMN) IA
         GROUP BY IA.DIVISION_ID
                , IA.SITE_ID
                , IA.OPERATION_ID
                , IA.PROD_LINE
                , IA.MEASURE;

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 01600 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        /* UPDATE X SET X.WQTY01 = Y.WQTY01 ... FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL X INNER JOIN #LineLoad_WEEK_PIVOT Y */
        /* #LineLoad 의 MEASURE 는 'PROD_LOAD' 한 가지라 (PROD_LINE·DIVISION_ID·SITE_ID·OPERATION_ID) 대응 행은 하나 */
        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_CELL A
           SET (
                  WQTY01
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
               )
             = (SELECT
                        B.WQTY01
                      , B.WQTY02
                      , B.WQTY03
                      , B.WQTY04
                      , B.WQTY05
                      , B.WQTY06
                      , B.WQTY07
                      , B.WQTY08
                      , B.WQTY09
                      , B.WQTY10
                      , B.WQTY11
                      , B.WQTY12
                      , B.WQTY13
                      , B.WQTY14
                      , B.WQTY15
                      , B.WQTY16
                      , B.WQTY17
                      , B.WQTY18
                      , B.WQTY19
                      , B.WQTY20
                      , B.WQTY21
                      , B.WQTY22
                      , B.WQTY23
                      , B.WQTY24
                      , B.WQTY25
                      , B.WQTY26
                      , B.WQTY27
                      , B.WQTY28
                      , B.WQTY29
                      , B.WQTY30
                      , B.WQTY31
                      , B.WQTY32
                      , B.WQTY33
                      , B.WQTY34
                      , B.WQTY35
                      , B.WQTY36
                      , B.WQTY37
                      , B.WQTY38
                      , B.WQTY39
                      , B.WQTY40
                      , B.WQTY41
                      , B.WQTY42
                      , B.WQTY43
                      , B.WQTY44
                      , B.WQTY45
                      , B.WQTY46
                      , B.WQTY47
                      , B.WQTY48
                      , B.WQTY49
                      , B.WQTY50
                      , B.WQTY51
                      , B.WQTY52
                  FROM GT_XPSC_LINELOAD_WEEK_PIVOT B
                 WHERE B.PROD_LINE    = A.PROD_LINE
                   AND B.DIVISION_ID  = A.DIVISION_ID
                   AND B.SITE_ID      = A.SITE_ID
                   AND B.OPERATION_ID = A.ATTRIBUTE9)
         WHERE EXISTS (SELECT 1
                         FROM GT_XPSC_LINELOAD_WEEK_PIVOT C
                        WHERE C.PROD_LINE    = A.PROD_LINE
                          AND C.DIVISION_ID  = A.DIVISION_ID
                          AND C.SITE_ID      = A.SITE_ID
                          AND C.OPERATION_ID = A.ATTRIBUTE9)
           AND A.CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
           AND A.MEASURE IN ('PROD_LOAD');

        /* E20260722-000892 20260720 주차 20260721 소형 fn 속도이슈건 */
        V_LOG_MESSAGE := '########## log step ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' 01700 ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => 'TXN'
                            , P_LOG_COUNT    => 0
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

        UPDATE SCP_XLS_PSI_GLOBAL_SMALL_CELL
           SET ATTRIBUTE2 = 'N'
               /* --SELECT * */
         WHERE CREATE_FROM_YYYYMMDD = V_CREATE_FROM_YYYYMMDD  /* * 2021.05.20   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 버전 추가 */
           AND ATTRIBUTE2           = 'Y'
           AND MEASURE              = 'PROD';

        /* TXN LOG */
        V_LOG_TYPE    := 'TXN';
        N_LOG_COUNT   := 1;  /* @@ROWCOUNT : 바로 앞 SET @v_log_type 단순 대입문이 1 로 바꿔 둔 값 */
        V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
        V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                            , P_LOG_TYPE     => V_LOG_TYPE
                            , P_LOG_COUNT    => N_LOG_COUNT
                            , P_LOG_MESSAGE  => V_LOG_MESSAGE
                            , P_DESCRIPTION  => V_DESCRIPTION
                            , P_EVENT_DATE   => D_EVENT_DATE
                            , P_USER_ID      => V_BATCH_USER
                            );

    EXCEPTION  /* BEGIN CATCH */
        WHEN OTHERS THEN
            /* --IF @@TRANCOUNT > 0 */
            /* --  BEGIN */
            /* --    ROLLBACK TRAN T1 */
            /* --  END; */

            /* ERROR LOG */
            V_LOG_TYPE     := 'ERROR';
            V_LOG_MESSAGE  := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION  := SUBSTR(V_PROGRAM_NAME || 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE   := SYSDATE;
            V_IN_PARA_DATA := SUBSTR( 'P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                                   || ',P_PLAN_ID='             || P_PLAN_ID
                                   || ',P_SEQ='                 || P_SEQ
                                   || ',P_PLAN_TYPE='           || P_PLAN_TYPE
                                   || ',P_MASTER_ID='           || P_MASTER_ID
                                   || ',P_DIVISION_ID='         || P_DIVISION_ID
                                   || ',P_ENGINE_PLAN_ID='      || P_ENGINE_PLAN_ID
                                   || ',P_UPDATE='              || P_UPDATE
                                   || ',P_CREATE_FROM_YYYYMMDD='|| P_CREATE_FROM_YYYYMMDD
                                   || ',P_CREATE_TO_YYYYMMDD='  || P_CREATE_TO_YYYYMMDD
                                   || ',P_USER_ID='             || P_USER_ID, 1, 4000);
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME  => V_PROGRAM_NAME
                                , P_LOG_TYPE      => V_LOG_TYPE
                                , P_LOG_COUNT     => N_LOG_COUNT
                                , P_LOG_MESSAGE   => V_LOG_MESSAGE
                                , P_DESCRIPTION   => V_DESCRIPTION
                                , P_EVENT_DATE    => D_EVENT_DATE
                                , P_USER_ID       => V_BATCH_USER
                                , P_IN_PARA_DATA  => V_IN_PARA_DATA
                                , P_SQL_ERR_CODE  => TO_CHAR(SQLCODE)
                                , P_SQL_ERR_MSG   => SQLERRM
                                , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
                                );
            /* --      PRINT @@ERROR */
            O_RETURN := -1;
            RETURN;  /* return -1 */
    END;  /* END CATCH; */

    /* 임시 운영반영시에 주석처리 할것. */
    /* REPLICATE('0', 2 - LEN(x)) + x : x 가 세 자리 이상이면 REPLICATE 가 NULL 을 돌려 전체가 NULL → CASE 로 재현 */
    V_EXEC_TIME := CASE
                     WHEN LENGTH(TO_CHAR(TRUNC(TRUNC((SYSDATE - V_START_TIME) * 86400) / 60))) > 2
                       OR LENGTH(TO_CHAR(MOD(TRUNC((SYSDATE - V_START_TIME) * 86400), 60))) > 2
                     THEN NULL
                     ELSE LPAD(TO_CHAR(TRUNC(TRUNC((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0')
                          || ':' ||
                          LPAD(TO_CHAR(MOD(TRUNC((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := CASE WHEN P_MASTER_ID IS NULL OR P_ENGINE_PLAN_ID IS NULL OR V_EXEC_TIME IS NULL THEN NULL  /* '+' 결합은 NULL 하나면 전체 NULL */
                          ELSE '[' || P_MASTER_ID || '][' || P_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']'
                     END;
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );

    O_RETURN := 1;
    RETURN;  /* return 1 */
END;