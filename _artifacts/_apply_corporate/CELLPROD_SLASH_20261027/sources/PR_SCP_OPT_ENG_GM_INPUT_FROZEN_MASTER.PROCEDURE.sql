PROCEDURE PR_SCP_OPT_ENG_GM_INPUT_FROZEN_MASTER
(
     P_PLAN_ID  VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_GM_INPUT_FROZEN_MASTER
 * Description  : SCP OPT ENGINE GM FROZEN MASTER INPUT 생성
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.02.14    Taehyun        Initial Release
 * 2026.07.29    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    /* ------------------------------------------------------------------ */
    /* Set Param for Log */
    /* ------------------------------------------------------------------ */
    V_PROGRAM_NAME        VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_GM_INPUT_FROZEN_MASTER';
    V_PLAN_ID             VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT        VARCHAR2(1000 CHAR);
    /* ------------------------------------------------------------------ */
    /* Set Param for Biz */
    /* ------------------------------------------------------------------ */
    V_DETAIL_DATE         DATE;
    V_DIVISION_ID         VARCHAR2(100 CHAR);
    V_GROUP_ID            VARCHAR2(100 CHAR);
    V_PLAN_START_YYYYMMDD VARCHAR2(50 CHAR);
    V_SCP_PLAN_DATE       VARCHAR2(8 CHAR);
    V_SCP_PLAN_TYPE       VARCHAR2(20 CHAR);
    V_SCP_PLAN_SEQ        VARCHAR2(8 CHAR);
    V_PROD_FROZEN         NUMBER(10);
    V_PLAN_EXEC_TYPE      VARCHAR2(10 CHAR);
    V_SHIP_SCP_PLAN_DATE  VARCHAR2(8 CHAR);
    V_SHIP_SCP_PLAN_TYPE  VARCHAR2(20 CHAR);
    V_SHIP_SCP_PLAN_SEQ   VARCHAR2(8 CHAR);

BEGIN
    /* ------------------------------------------------------------------ */
    /* Procedure 기본조건. */
    /* ------------------------------------------------------------------ */
    /*         SET TRANSACTION ISOLATION LEVEL READ COMMITTED;     Oracle 기본 격리수준이 READ COMMITTED */
    /* ------------------------------------------------------------------ */

    /* ------------------------------------------------------------------ */
    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 */
    /* ------------------------------------------------------------------ */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'START',NULL,NULL,NULL,V_PLAN_ID);

    /* ------------------------------------------------------------------ */
    BEGIN

        /* 이전에 있던 PLAN_ID 정보는 삭제 */
        DELETE
          FROM SCP_OPT_ENG_FROZEN_MASTER_SN
         WHERE PLAN_ID = V_PLAN_ID;


        DELETE
          FROM GT_OPT_ENG_FRZMST_PROD;

        DELETE
          FROM GT_OPT_ENG_FRZMST_SHIP;

        /* ------------------------------------------------------------------ */
        /* PLAN 기본 정보 생성 */
        /* ------------------------------------------------------------------ */

        FOR R IN (SELECT A.DIVISION_ID
                       , A.PLAN_GROUP_ID
                       , A.PLAN_START_YYYYMMDD
                       , A.PLAN_EXEC_TYPE
                         /* ,@V_PLAN_END_YYYYMMDD   = A.PLAN_END_YYYYMMDD */
                    FROM (SELECT PM.DIVISION_ID                                                 AS DIVISION_ID
                               , PGM.OPMZ_PLAN_GR_NAME                                          AS PLAN_GROUP_ID
                               , PM.PLAN_START_YYYYMMDD                                         AS PLAN_START_YYYYMMDD
                               , TO_CHAR(TO_DATE(PM.PLAN_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') AS PLAN_END_YYYYMMDD
                               , 'UI'                                                           AS PLAN_EXEC_TYPE
                            FROM SCP_OPMZ_PLAN_M     PM
                               , SCP_OPMZ_PLAN_GR_M  PGM
                           WHERE PM.OPMZ_PLAN_GR_ID = PGM.OPMZ_PLAN_GR_ID
                             AND PM.OPMZ_PLAN_ID    = V_PLAN_ID
                          UNION
                          SELECT DIVISION_ID                                                    AS DIVISION_ID
                               , PLAN_TYPE_CODE                                                 AS PLAN_GROUP_ID
                               , PLAN_START_YYYYMMDD                                            AS PLAN_START_YYYYMMDD
                               , TO_CHAR(TO_DATE(PLAN_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD')    AS PLAN_END_YYYYMMDD
                               , 'MANUAL'                                                       AS PLAN_EXEC_TYPE
                            FROM SCP_OPT_ENG_SCP_PLAN_ID_M_SN
                           WHERE 1=1
                             AND PLAN_ID = V_PLAN_ID) A) LOOP
            V_DIVISION_ID         := SUBSTR(R.DIVISION_ID,1,100);
            V_GROUP_ID            := SUBSTR(R.PLAN_GROUP_ID,1,100);
            V_PLAN_START_YYYYMMDD := SUBSTR(R.PLAN_START_YYYYMMDD,1,50);
            V_PLAN_EXEC_TYPE      := SUBSTR(R.PLAN_EXEC_TYPE,1,10);
        END LOOP;

        /* ------------------------------------------------------------------ */
        /* FROZEN MASTER 정보 생성 */
        /* ------------------------------------------------------------------ */
        IF V_DIVISION_ID != 'EE' THEN
                /* ------------------------------------------------------------------ */
                /* FROZEN MASTER 정보 생성 */
                /* ------------------------------------------------------------------ */
                IF V_PLAN_EXEC_TYPE = 'MANUAL' THEN
                    FOR R IN (SELECT A.PLAN_START_YYYYMMDD
                                   , A.PLAN_TYPE
                                   , A.PLAN_SEQ
                                FROM (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
                                        FROM SCP_PLAN_VERSION_V
                                       WHERE DIVISION_ID         = V_DIVISION_ID
                                         AND PLAN_START_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD')  /* 해당 주 월요일 YYYYMMDD */
                                       ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC) A
                               WHERE ROWNUM = 1) LOOP
                        V_SCP_PLAN_DATE := SUBSTR(R.PLAN_START_YYYYMMDD,1,8);
                        V_SCP_PLAN_TYPE := SUBSTR(R.PLAN_TYPE,1,20);
                        V_SCP_PLAN_SEQ  := SUBSTR(TO_CHAR(R.PLAN_SEQ),1,8);
                    END LOOP;

                    FOR R IN (SELECT A.PLAN_START_YYYYMMDD
                                   , A.PLAN_TYPE
                                   , A.PLAN_SEQ
                                FROM (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
                                        FROM SCP_PLAN_VERSION_V
                                       WHERE DIVISION_ID         = V_DIVISION_ID
                                         AND PLAN_START_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD'),'MON')-7,'YYYYMMDD')  /* 해당 주 월요일 YYYYMMDD */
                                       ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC) A
                               WHERE ROWNUM = 1) LOOP
                        V_SHIP_SCP_PLAN_DATE := SUBSTR(R.PLAN_START_YYYYMMDD,1,8);
                        V_SHIP_SCP_PLAN_TYPE := SUBSTR(R.PLAN_TYPE,1,20);
                        V_SHIP_SCP_PLAN_SEQ  := SUBSTR(TO_CHAR(R.PLAN_SEQ),1,8);
                    END LOOP;

                    /* ------------------------------------------------------------------ */
                    /* FROZEN 기간 정보 생성 -> 수동인 경우만 사용 */
                    /* ------------------------------------------------------------------ */
                    INSERT
                      INTO GT_OPT_ENG_FRZMST_PROD
                         ( STAGE
                         , FROZEN_START_YYYYMMDD
                         , FROZEN_END_YYYYMMDD
                         , FROZEN_DAYS )
                    SELECT SEGMENT4                                                                                                           AS STAGE
                         , V_PLAN_START_YYYYMMDD                                                                                              AS FROZEN_START_YYYYMMDD
                         , TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD')+NVL(CAST(SEGMENT5 AS NUMBER DEFAULT NULL ON CONVERSION ERROR),0),'YYYYMMDD') AS FROZEN_END_YYYYMMDD
                         , SEGMENT5                                                                                                           AS FROZEN_DAYS
                      FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LV
                     WHERE LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN_NEW'
                       AND VALID_YN    = 'Y'
                       AND SEGMENT1    = V_DIVISION_ID
                       AND SEGMENT2    = V_GROUP_ID
                       AND SEGMENT3    = V_SCP_PLAN_TYPE;

                    INSERT
                      INTO GT_OPT_ENG_FRZMST_SHIP
                         ( STAGE
                         , FROZEN_START_YYYYMMDD
                         , FROZEN_END_YYYYMMDD
                         , FROZEN_DAYS )
                    SELECT 'SHIP'                                                                                                             AS STAGE
                         , V_PLAN_START_YYYYMMDD                                                                                              AS FROZEN_START_YYYYMMDD
                         , TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD')+NVL(CAST(SEGMENT4 AS NUMBER DEFAULT NULL ON CONVERSION ERROR),0),'YYYYMMDD') AS FROZEN_END_YYYYMMDD
                         , SEGMENT4                                                                                                           AS FROZEN_DAYS
                      FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LV
                     WHERE LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
                       AND VALID_YN    = 'Y'
                       AND SEGMENT1    = V_DIVISION_ID
                       AND SEGMENT2    = V_GROUP_ID
                       AND SEGMENT3    = V_SCP_PLAN_TYPE;
                ELSIF V_PLAN_EXEC_TYPE = 'UI' THEN
                    /* 자동인 경우 입력된 데이터로 찾아옴 */
                    FOR R IN (SELECT V.PLAN_START_YYYYMMDD
                                   , V.PLAN_TYPE
                                   , V.PLAN_SEQ
                                FROM SCP_OPMZ_PLAN_M     OP
                                   , SCP_PLAN_VERSION_V  V
                               WHERE V.DIVISION_ID           = V_DIVISION_ID
                                 AND V.PLAN_VERSION_ID       = OP.PROD_REF_SYS_PLAN_ID
                                 AND OP.OPMZ_PLAN_ID         = V_PLAN_ID
                                 AND OP.PROD_REF_SYS_DIVS_CD = 'SCP') LOOP
                        V_SCP_PLAN_DATE := SUBSTR(R.PLAN_START_YYYYMMDD,1,8);
                        V_SCP_PLAN_TYPE := SUBSTR(R.PLAN_TYPE,1,20);
                        V_SCP_PLAN_SEQ  := SUBSTR(TO_CHAR(R.PLAN_SEQ),1,8);
                    END LOOP;

                    FOR R IN (SELECT V.PLAN_START_YYYYMMDD
                                   , V.PLAN_TYPE
                                   , V.PLAN_SEQ
                                FROM SCP_OPMZ_PLAN_M     OP
                                   , SCP_PLAN_VERSION_V  V
                               WHERE V.DIVISION_ID           = V_DIVISION_ID
                                 AND V.PLAN_VERSION_ID       = OP.SHIP_REF_SYS_PLAN_ID
                                 AND OP.OPMZ_PLAN_ID         = V_PLAN_ID
                                 AND OP.SHIP_REF_SYS_DIVS_CD = 'SCP') LOOP
                        V_SHIP_SCP_PLAN_DATE := SUBSTR(R.PLAN_START_YYYYMMDD,1,8);
                        V_SHIP_SCP_PLAN_TYPE := SUBSTR(R.PLAN_TYPE,1,20);
                        V_SHIP_SCP_PLAN_SEQ  := SUBSTR(TO_CHAR(R.PLAN_SEQ),1,8);
                    END LOOP;

                    /* FP의 경우 최신 버전 OR CUTOFF 일자 확인을 위한 변수 설정 */
                    FOR R IN (SELECT CASE WHEN PROD_REF_SYS_PLAN_ID = 'Latest FP Plan' THEN NULL ELSE PROD_REF_SYS_PLAN_ID END     AS SCP_PLAN_DATE
                                   , CASE WHEN PROD_REF_SYS_PLAN_ID = 'Latest FP Plan' THEN PROD_REF_SYS_PLAN_ID ELSE 'CUT_OFF' END AS SCP_PLAN_TYPE
                                FROM SCP_OPMZ_PLAN_M
                               WHERE OPMZ_PLAN_ID         = V_PLAN_ID
                                 AND PROD_REF_SYS_DIVS_CD = 'FP') LOOP
                        V_SCP_PLAN_DATE := SUBSTR(R.SCP_PLAN_DATE,1,8);
                        V_SCP_PLAN_TYPE := SUBSTR(R.SCP_PLAN_TYPE,1,20);
                    END LOOP;
                END IF;
        END IF;


        /* ------------------------------------------------------------------ */
        /* DATA Insert */
        /* ------------------------------------------------------------------ */
        INSERT
          INTO SCP_OPT_ENG_FROZEN_MASTER_SN
             ( PLAN_ID
             , DIVISION_ID
             , FROZEN_TYPE
             , SYS_DIVS_CD
             , PLAN_TYPE
             , PLAN_SEQ
             , PLAN_YYYYMMDD
             , STAGE
             , FROZEN_START_DATE
             , FROZEN_END_DATE
             , FROZEN_DAYS
             , ATTRIBUTE1 )
        /* ----------------------생산 FROZEN---------------------- */
        /* 수동/조립/SCP/PACK&MDLE&ASSY */
        SELECT V_PLAN_ID             AS PLAN_ID
             , V_DIVISION_ID         AS DIVISION_ID
             , 'PROD'                AS FROZEN_TYPE
               /* ,'SCP'                 AS SYS_DIVS_CD */
               /* ,@V_SCP_PLAN_TYPE      AS PLAN_TYPE   */
               /* ,@V_SCP_PLAN_SEQ       AS PLAN_SEQ    */
             , 'FP'                  AS SYS_DIVS_CD
             , 'CUT_OFF'             AS PLAN_TYPE
             , NULL                  AS PLAN_SEQ
             , V_SCP_PLAN_DATE       AS PLAN_YYYYMMDD
             , STAGE                 AS STAGE
             , FROZEN_START_YYYYMMDD AS FROZEN_START_DATE
             , FROZEN_END_YYYYMMDD   AS FROZEN_END_DATE
             , TO_NUMBER(FROZEN_DAYS) AS FROZEN_DAY
             , V_PLAN_EXEC_TYPE      AS ATTRIBUTE1
          FROM GT_OPT_ENG_FRZMST_PROD
         WHERE 1=1
           AND FROZEN_START_YYYYMMDD IS NOT NULL
           AND FROZEN_END_YYYYMMDD   IS NOT NULL
           AND FROZEN_DAYS           IS NOT NULL
        UNION ALL
        /* UI/조립/FP&SCP/PACK */
        SELECT OP.OPMZ_PLAN_ID                 AS PLAN_ID
             , V_DIVISION_ID                   AS DIVISION_ID
             , 'PROD'                          AS FROZEN_TYPE
             , OP.PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
             , V_SCP_PLAN_TYPE                 AS PLAN_TYPE
             , V_SCP_PLAN_SEQ                  AS PLAN_SEQ
             , V_SCP_PLAN_DATE                 AS PLAN_YYYYMMDD
             , 'PACK'                          AS STAGE
             , OP.CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
             , CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                    ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END AS FROZEN_END_DATE
             , (TO_DATE(CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                             ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END,'YYYYMMDD')
               -TO_DATE(OP.CELL_PROD_FRZ_START_YYYYMMDD,'YYYYMMDD'))                                  AS FROZEN_DAY
             , V_PLAN_EXEC_TYPE                AS ATTRIBUTE1
          FROM SCP_OPMZ_PLAN_M OP
         WHERE OP.OPMZ_PLAN_ID = V_PLAN_ID
           AND OP.CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
           AND OP.CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
        UNION ALL
        /* UI/조립/FP&SCP/MDLE */
        SELECT OP.OPMZ_PLAN_ID                 AS PLAN_ID
             , V_DIVISION_ID                   AS DIVISION_ID
             , 'PROD'                          AS FROZEN_TYPE
             , OP.PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
             , V_SCP_PLAN_TYPE                 AS PLAN_TYPE
             , V_SCP_PLAN_SEQ                  AS PLAN_SEQ
             , V_SCP_PLAN_DATE                 AS PLAN_YYYYMMDD
             , 'MDLE'                          AS STAGE
             , OP.CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
             , CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                    ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END AS FROZEN_END_DATE
             , (TO_DATE(CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                             ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END,'YYYYMMDD')
               -TO_DATE(OP.CELL_PROD_FRZ_START_YYYYMMDD,'YYYYMMDD'))                                  AS FROZEN_DAY
             , V_PLAN_EXEC_TYPE                AS ATTRIBUTE1
          FROM SCP_OPMZ_PLAN_M OP
         WHERE OP.OPMZ_PLAN_ID = V_PLAN_ID
           AND OP.CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
           AND OP.CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
        UNION ALL
        /* UI/조립/FP&SCP/CELL */
        /*SELECT  OPMZ_PLAN_ID                 AS PLAN_ID
               ,@V_DIVISION_ID               AS DIVISION_ID
               ,'PROD'                       AS FROZEN_TYPE
               ,PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
               ,@V_SCP_PLAN_TYPE             AS PLAN_TYPE
               ,@V_SCP_PLAN_SEQ              AS PLAN_SEQ
               ,@V_SCP_PLAN_DATE             AS PLAN_YYYYMMDD
               ,'ASSY'                       AS STAGE
               ,CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
               ,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,CONVERT(NVARCHAR(8),DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD),112))    AS FROZEN_END_DATE
               ,DATEDIFF(DAY,CELL_PROD_FRZ_START_YYYYMMDD,IIF(CELL_PROD_FRZ_END_YYYYMMDD='',CELL_PROD_FRZ_START_YYYYMMDD,DATEADD(DAY,1,CELL_PROD_FRZ_END_YYYYMMDD))) AS FROZEN_DAY
               ,@V_PLAN_EXEC_TYPE            AS ATTRIBUTE1
        FROM    SCP_OPMZ_PLAN_M OP WITH(NOLOCK)
        WHERE   OPMZ_PLAN_ID = @V_PLAN_ID
        AND     CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
        AND     CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL*/
        SELECT OP.OPMZ_PLAN_ID                 AS PLAN_ID
             , V_DIVISION_ID                   AS DIVISION_ID
             , 'PROD'                          AS FROZEN_TYPE
             , OP.PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
             , V_SCP_PLAN_TYPE                 AS PLAN_TYPE
             , V_SCP_PLAN_SEQ                  AS PLAN_SEQ
             , V_SCP_PLAN_DATE                 AS PLAN_YYYYMMDD
             , 'ASSY'                          AS STAGE
             , OP.CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
             , CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                    ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END AS FROZEN_END_DATE
             , (TO_DATE(CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                             ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END,'YYYYMMDD')
               -TO_DATE(OP.CELL_PROD_FRZ_START_YYYYMMDD,'YYYYMMDD'))                                  AS FROZEN_DAY
             , V_PLAN_EXEC_TYPE                AS ATTRIBUTE1
          FROM SCP_OPMZ_PLAN_M OP
         WHERE OP.OPMZ_PLAN_ID = V_PLAN_ID
           AND OP.CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
           AND OP.CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
        UNION ALL
        SELECT OP.OPMZ_PLAN_ID                 AS PLAN_ID
             , V_DIVISION_ID                   AS DIVISION_ID
             , 'PROD'                          AS FROZEN_TYPE
             , OP.PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
             , V_SCP_PLAN_TYPE                 AS PLAN_TYPE
             , V_SCP_PLAN_SEQ                  AS PLAN_SEQ
             , V_SCP_PLAN_DATE                 AS PLAN_YYYYMMDD
             , 'STK'                           AS STAGE
             , OP.CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
             , CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                    ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END AS FROZEN_END_DATE
             , (TO_DATE(CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                             ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END,'YYYYMMDD')
               -TO_DATE(OP.CELL_PROD_FRZ_START_YYYYMMDD,'YYYYMMDD'))                                  AS FROZEN_DAY
             , V_PLAN_EXEC_TYPE                AS ATTRIBUTE1
          FROM SCP_OPMZ_PLAN_M OP
         WHERE OP.OPMZ_PLAN_ID = V_PLAN_ID
           AND OP.CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
           AND OP.CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
        UNION ALL
        SELECT OP.OPMZ_PLAN_ID                 AS PLAN_ID
             , V_DIVISION_ID                   AS DIVISION_ID
             , 'PROD'                          AS FROZEN_TYPE
             , OP.PROD_REF_SYS_DIVS_CD         AS SYS_DIVS_CD
             , V_SCP_PLAN_TYPE                 AS PLAN_TYPE
             , V_SCP_PLAN_SEQ                  AS PLAN_SEQ
             , V_SCP_PLAN_DATE                 AS PLAN_YYYYMMDD
             , 'EOL'                           AS STAGE
             , OP.CELL_PROD_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
             , CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                    ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END AS FROZEN_END_DATE
             , (TO_DATE(CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                             ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END,'YYYYMMDD')
               -TO_DATE(OP.CELL_PROD_FRZ_START_YYYYMMDD,'YYYYMMDD'))                                  AS FROZEN_DAY
             , V_PLAN_EXEC_TYPE                AS ATTRIBUTE1
          FROM SCP_OPMZ_PLAN_M OP
         WHERE OP.OPMZ_PLAN_ID = V_PLAN_ID
           AND OP.CELL_PROD_FRZ_START_YYYYMMDD IS NOT NULL
           AND OP.CELL_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
        /* ----------------------생산 FROZEN END---------------------- */
        /* ----------------------출하 FROZEN START---------------------- */
        /* MANUAL/조립/SCP */
        UNION ALL
        SELECT V_PLAN_ID             AS PLAN_ID
             , V_DIVISION_ID         AS DIVISION_ID
             , 'SHIP'                AS FROZEN_TYPE
               /* ,'SCP'                 AS SYS_DIVS_CD */
               /* ,@V_SHIP_SCP_PLAN_TYPE AS PLAN_TYPE   */
               /* ,@V_SHIP_SCP_PLAN_SEQ  AS PLAN_SEQ    */
             , 'SSP'                 AS SYS_DIVS_CD
             , NULL                  AS PLAN_TYPE
             , NULL                  AS PLAN_SEQ
             , NULL                  AS PLAN_YYYYMMDD
             , STAGE                 AS STAGE
             , FROZEN_START_YYYYMMDD AS FROZEN_START_DATE
             , FROZEN_END_YYYYMMDD   AS FROZEN_END_DATE
             , TO_NUMBER(FROZEN_DAYS) AS FROZEN_DAY
             , V_PLAN_EXEC_TYPE      AS ATTRIBUTE1
          FROM GT_OPT_ENG_FRZMST_SHIP
         WHERE 1=1
           AND FROZEN_START_YYYYMMDD IS NOT NULL
           AND FROZEN_END_YYYYMMDD   IS NOT NULL
           AND FROZEN_DAYS           IS NOT NULL
        UNION ALL
        /* UI/조립/SCP&SSP */
        SELECT OP.OPMZ_PLAN_ID            AS PLAN_ID
             , V_DIVISION_ID              AS DIVISION_ID
             , 'SHIP'                     AS FROZEN_TYPE
             , OP.SHIP_REF_SYS_DIVS_CD    AS SYS_DIVS_CD
             , V_SHIP_SCP_PLAN_TYPE       AS PLAN_TYPE
             , V_SHIP_SCP_PLAN_SEQ        AS PLAN_SEQ
             , V_SHIP_SCP_PLAN_DATE       AS PLAN_YYYYMMDD
             , 'SHIP'                     AS STAGE
             , OP.SHIP_FRZ_START_YYYYMMDD AS FROZEN_START_DATE
             , CASE WHEN OP.SHIP_FRZ_END_YYYYMMDD IS NULL THEN OP.SHIP_FRZ_START_YYYYMMDD
                    ELSE TO_CHAR(TO_DATE(OP.SHIP_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END AS FROZEN_END_DATE
               /* 원본 quirk : 이 계산식의 IIF 안쪽만 CONVERT(...,112) 없이 DATEADD 결과(DATETIME)를 그대로 사용 -> DATE 연산으로 재현 */
             , (CASE WHEN OP.SHIP_FRZ_END_YYYYMMDD IS NULL THEN TO_DATE(OP.SHIP_FRZ_START_YYYYMMDD,'YYYYMMDD')
                     ELSE TO_DATE(OP.SHIP_FRZ_END_YYYYMMDD,'YYYYMMDD')+1 END
               -TO_DATE(OP.SHIP_FRZ_START_YYYYMMDD,'YYYYMMDD'))                                 AS FROZEN_DAY
             , V_PLAN_EXEC_TYPE           AS ATTRIBUTE1
          FROM SCP_OPMZ_PLAN_M OP
         WHERE OP.OPMZ_PLAN_ID = V_PLAN_ID
           AND OP.SHIP_FRZ_START_YYYYMMDD IS NOT NULL
           AND OP.SHIP_FRZ_END_YYYYMMDD   IS NOT NULL;
        /* ----------------------출하 FROZEN END---------------------- */
    /* ------------------------------------------------------------------ */
    EXCEPTION
    /* ------------------------------------------------------------------ */
    /* ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC; */
    /* ------------------------------------------------------------------ */
    /* ERROR LOG */
    /* ------------------------------------------------------------------ */
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SUBSTR(SQLERRM,1,1000);
            /* ------------------------------------------------------------------ */
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            /* ------------------------------------------------------------------ */
            V_DETAIL_DATE := SYSDATE;
            /* ------------------------------------------------------------------ */
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,V_DETAIL_DATE,NULL,V_MESSAGE_TEXT,'ERROR');
            /* ------------------------------------------------------------------ */
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
            /* ------------------------------------------------------------------ */
    END;
    /* ------------------------------------------------------------------ */

    /* ------------------------------------------------------------------ */
    /* 종료 LOG */
    /* ------------------------------------------------------------------ */
    IF V_MESSAGE_TEXT IS NULL THEN
    /* ------------------------------------------------------------------ */
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'END',NULL,NULL,NULL,V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL);
    END IF;
    /* ------------------------------------------------------------------ */
END PR_SCP_OPT_ENG_GM_INPUT_FROZEN_MASTER;