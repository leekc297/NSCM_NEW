PROCEDURE PR_SCP_OPT_ENG_ESS_INPUT_FROZEN_MASTER
(
     P_PLAN_ID  VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_ESS_INPUT_FROZEN_MASTER
 * Description  : SCP OPT ENGINE FROZEN MASTER INPUT 생성
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.02.14    Taehyun        Initial Release
 * 2025.10.27    Philsu Park    월요일 기준 계획 못찾을 때 전주 계획 한번 더 조회
 * 2026.03.18    Minyong Lee    PLAN 기준 FROZEN_MASTER STAGE LINK 유형 추가
 * 2026.03.20    Minyong Lee    LINK STAGE Frozen 반영 여부 룩업 설정에 따라 결정
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    V_PROGRAM_NAME           VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_ESS_INPUT_FROZEN_MASTER';
    V_PLAN_ID                VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT           VARCHAR2(1000 CHAR);
    V_DETAIL_DATE            DATE;
    V_DIVISION_ID            VARCHAR2(100 CHAR);
    V_GROUP_ID               VARCHAR2(100 CHAR);
    V_PLAN_START_YYYYMMDD    VARCHAR2(50 CHAR);
    V_SCP_PLAN_DATE          VARCHAR2(8 CHAR);
    V_SCP_PLAN_TYPE          VARCHAR2(20 CHAR);
    V_SCP_PLAN_SEQ           VARCHAR2(8 CHAR);
    V_PLAN_EXEC_TYPE         VARCHAR2(10 CHAR);
    V_SHIP_SCP_PLAN_DATE     VARCHAR2(8 CHAR);
    V_SHIP_SCP_PLAN_TYPE     VARCHAR2(20 CHAR);
    V_SHIP_SCP_PLAN_SEQ      VARCHAR2(8 CHAR);
    V_LINK_FROZEN_APPLY_YN   VARCHAR2(1 CHAR);
BEGIN
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'START',NULL,NULL,NULL,V_PLAN_ID);

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
        /* PLAN 기본 정보 생성                                                 */
        /* ------------------------------------------------------------------ */
        BEGIN
            SELECT SUBSTR(DIVISION_ID,1,100)
                 , SUBSTR(PLAN_GROUP_ID,1,100)
                 , SUBSTR(PLAN_START_YYYYMMDD,1,50)
                 , SUBSTR(PLAN_EXEC_TYPE,1,10)
              INTO V_DIVISION_ID
                 , V_GROUP_ID
                 , V_PLAN_START_YYYYMMDD
                 , V_PLAN_EXEC_TYPE
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
                       AND PLAN_ID = V_PLAN_ID)
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;

        /* ------------------------------------------------------------------ */
        /* FROZEN MASTER 정보 생성                                             */
        /* ------------------------------------------------------------------ */
        IF V_DIVISION_ID != 'EE' THEN
            IF V_PLAN_EXEC_TYPE = 'MANUAL' THEN
                /* 해당 주 월요일(YYYYMMDD) 최신 버전 취득 (생산, -7) */
                BEGIN
                    SELECT SUBSTR(PLAN_START_YYYYMMDD,1,8)
                         , SUBSTR(PLAN_TYPE,1,20)
                         , SUBSTR(TO_CHAR(PLAN_SEQ),1,8)
                      INTO V_SCP_PLAN_DATE
                         , V_SCP_PLAN_TYPE
                         , V_SCP_PLAN_SEQ
                      FROM (SELECT PLAN_START_YYYYMMDD
                                 , PLAN_TYPE
                                 , PLAN_SEQ
                              FROM SCP_PLAN_VERSION_V
                             WHERE DIVISION_ID         = V_DIVISION_ID
                               AND PLAN_START_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD'),'MON') - 7, 'YYYYMMDD')
                             ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC)
                     WHERE ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                END;

                /* 2025.10.27 전주 폴백: 못찾으면 -14일 재조회 (생산) */
                IF V_SCP_PLAN_DATE IS NULL THEN
                    BEGIN
                        SELECT SUBSTR(PLAN_START_YYYYMMDD,1,8)
                             , SUBSTR(PLAN_TYPE,1,20)
                             , SUBSTR(TO_CHAR(PLAN_SEQ),1,8)
                          INTO V_SCP_PLAN_DATE
                             , V_SCP_PLAN_TYPE
                             , V_SCP_PLAN_SEQ
                          FROM (SELECT PLAN_START_YYYYMMDD
                                     , PLAN_TYPE
                                     , PLAN_SEQ
                                  FROM SCP_PLAN_VERSION_V
                                 WHERE DIVISION_ID         = V_DIVISION_ID
                                   AND PLAN_START_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD'),'MON') - 14, 'YYYYMMDD')
                                 ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC)
                         WHERE ROWNUM = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN NULL;
                    END;
                END IF;

                /* 해당 주 월요일(YYYYMMDD) 최신 버전 취득 (출하, -7) */
                BEGIN
                    SELECT SUBSTR(PLAN_START_YYYYMMDD,1,8)
                         , SUBSTR(PLAN_TYPE,1,20)
                         , SUBSTR(TO_CHAR(PLAN_SEQ),1,8)
                      INTO V_SHIP_SCP_PLAN_DATE
                         , V_SHIP_SCP_PLAN_TYPE
                         , V_SHIP_SCP_PLAN_SEQ
                      FROM (SELECT PLAN_START_YYYYMMDD
                                 , PLAN_TYPE
                                 , PLAN_SEQ
                              FROM SCP_PLAN_VERSION_V
                             WHERE DIVISION_ID         = V_DIVISION_ID
                               AND PLAN_START_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD'),'MON') - 7, 'YYYYMMDD')
                             ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC)
                     WHERE ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                END;

                /* 2025.10.27 전주 폴백: 못찾으면 -14일 재조회 (출하) */
                IF V_SHIP_SCP_PLAN_DATE IS NULL THEN
                    BEGIN
                        SELECT SUBSTR(PLAN_START_YYYYMMDD,1,8)
                             , SUBSTR(PLAN_TYPE,1,20)
                             , SUBSTR(TO_CHAR(PLAN_SEQ),1,8)
                          INTO V_SHIP_SCP_PLAN_DATE
                             , V_SHIP_SCP_PLAN_TYPE
                             , V_SHIP_SCP_PLAN_SEQ
                          FROM (SELECT PLAN_START_YYYYMMDD
                                     , PLAN_TYPE
                                     , PLAN_SEQ
                                  FROM SCP_PLAN_VERSION_V
                                 WHERE DIVISION_ID         = V_DIVISION_ID
                                   AND PLAN_START_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD'),'MON') - 14, 'YYYYMMDD')
                                 ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC)
                         WHERE ROWNUM = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN NULL;
                    END;
                END IF;

                /* FROZEN 기간(생산) -> GT_OPT_ENG_FRZMST_PROD */
                INSERT
                  INTO GT_OPT_ENG_FRZMST_PROD
                     ( STAGE
                     , FROZEN_START_YYYYMMDD
                     , FROZEN_END_YYYYMMDD
                     , FROZEN_DAYS )
                SELECT SEGMENT4
                     , V_SCP_PLAN_DATE
                     , TO_CHAR(TO_DATE(V_SCP_PLAN_DATE,'YYYYMMDD') + NVL(CAST(SEGMENT5 AS NUMBER DEFAULT NULL ON CONVERSION ERROR),0), 'YYYYMMDD')
                     , SEGMENT5
                  FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE = 'SCP_OPT_PROD_FROZEN_NEW'
                   AND VALID_YN    = 'Y'
                   AND SEGMENT1    = V_DIVISION_ID
                   AND SEGMENT2    = V_GROUP_ID
                   AND SEGMENT3    = V_SCP_PLAN_TYPE;

                /* FROZEN 기간(출하) -> GT_OPT_ENG_FRZMST_SHIP */
                INSERT
                  INTO GT_OPT_ENG_FRZMST_SHIP
                     ( STAGE
                     , FROZEN_START_YYYYMMDD
                     , FROZEN_END_YYYYMMDD
                     , FROZEN_DAYS )
                SELECT 'SHIP'
                     , V_SCP_PLAN_DATE
                     , TO_CHAR(TO_DATE(V_SCP_PLAN_DATE,'YYYYMMDD') + NVL(CAST(SEGMENT4 AS NUMBER DEFAULT NULL ON CONVERSION ERROR),0), 'YYYYMMDD')
                     , SEGMENT4
                  FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
                   AND VALID_YN    = 'Y'
                   AND SEGMENT1    = V_DIVISION_ID
                   AND SEGMENT2    = V_GROUP_ID
                   AND SEGMENT3    = V_SCP_PLAN_TYPE;

            ELSIF V_PLAN_EXEC_TYPE = 'UI' THEN

                BEGIN
                    SELECT SUBSTR(V.PLAN_START_YYYYMMDD,1,8)
                         , SUBSTR(V.PLAN_TYPE,1,20)
                         , SUBSTR(TO_CHAR(V.PLAN_SEQ),1,8)
                      INTO V_SCP_PLAN_DATE
                         , V_SCP_PLAN_TYPE
                         , V_SCP_PLAN_SEQ
                      FROM SCP_OPMZ_PLAN_M     OP
                         , SCP_PLAN_VERSION_V  V
                     WHERE V.DIVISION_ID          = V_DIVISION_ID
                       AND V.PLAN_VERSION_ID      = OP.PROD_REF_SYS_PLAN_ID
                       AND OP.OPMZ_PLAN_ID        = V_PLAN_ID
                       AND OP.PROD_REF_SYS_DIVS_CD = 'SCP'
                       AND ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                END;


                BEGIN
                    SELECT SUBSTR(V.PLAN_START_YYYYMMDD,1,8)
                         , SUBSTR(V.PLAN_TYPE,1,20)
                         , SUBSTR(TO_CHAR(V.PLAN_SEQ),1,8)
                      INTO V_SHIP_SCP_PLAN_DATE
                         , V_SHIP_SCP_PLAN_TYPE
                         , V_SHIP_SCP_PLAN_SEQ
                      FROM SCP_OPMZ_PLAN_M     OP
                         , SCP_PLAN_VERSION_V  V
                     WHERE V.DIVISION_ID          = V_DIVISION_ID
                       AND V.PLAN_VERSION_ID      = OP.SHIP_REF_SYS_PLAN_ID
                       AND OP.OPMZ_PLAN_ID        = V_PLAN_ID
                       AND OP.SHIP_REF_SYS_DIVS_CD = 'SCP'
                       AND ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                END;

                /* FP의 경우 최신버전 OR CUTOFF 일자 변수 설정 (생산 FP) */
                BEGIN
                    SELECT SUBSTR(CASE WHEN PROD_REF_SYS_PLAN_ID = 'Latest FP Plan' THEN NULL ELSE PROD_REF_SYS_PLAN_ID END,1,8)
                         , SUBSTR(CASE WHEN PROD_REF_SYS_PLAN_ID = 'Latest FP Plan' THEN PROD_REF_SYS_PLAN_ID ELSE 'CUT_OFF' END,1,20)
                      INTO V_SCP_PLAN_DATE
                         , V_SCP_PLAN_TYPE
                      FROM SCP_OPMZ_PLAN_M
                     WHERE OPMZ_PLAN_ID         = V_PLAN_ID
                       AND PROD_REF_SYS_DIVS_CD = 'FP'
                       AND ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                END;
            END IF;
        END IF;

        /* ------------------------------------------------------------------ */
        /* 2026.03.20 LINK STAGE Frozen 반영 여부 (룩업 설정)                  */
        /* ------------------------------------------------------------------ */
        SELECT CASE WHEN EXISTS (SELECT 1
                                   FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
                                  WHERE LOOKUP_TYPE = 'SCP_OPT_ELEC_FROZEN_STAGE'
                                    AND SEGMENT1    = V_GROUP_ID
                                    AND SEGMENT2    = 'LINK'
                                    AND SEGMENT3    = 'Y')
                    THEN 'Y' ELSE 'N' END
          INTO V_LINK_FROZEN_APPLY_YN
          FROM DUAL;

        /* ------------------------------------------------------------------ */
        /* DATA Insert                                                        */
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
        /* --------------------- 생산 FROZEN --------------------- */
        /* 수동/조립/SCP/PACK&MDLE&ASSY */
        SELECT V_PLAN_ID
             , V_DIVISION_ID
             , 'PROD'
             , 'SCP'
             , V_SCP_PLAN_TYPE
             , V_SCP_PLAN_SEQ
             , V_SCP_PLAN_DATE
             , STAGE
             , FROZEN_START_YYYYMMDD
             , FROZEN_END_YYYYMMDD
             , TO_NUMBER(FROZEN_DAYS)
             , V_PLAN_EXEC_TYPE
          FROM GT_OPT_ENG_FRZMST_PROD
         WHERE 1=1
           AND FROZEN_START_YYYYMMDD IS NOT NULL
           AND FROZEN_END_YYYYMMDD   IS NOT NULL
           AND FROZEN_DAYS           IS NOT NULL
        UNION ALL
        /* UI/조립/FP&SCP/PACK */
        SELECT OP.OPMZ_PLAN_ID
             , V_DIVISION_ID
             , 'PROD'
             , OP.PROD_REF_SYS_DIVS_CD
             , V_SCP_PLAN_TYPE
             , V_SCP_PLAN_SEQ
             , V_SCP_PLAN_DATE
             , 'PACK'
             , OP.PMDU_PROD_FRZ_START_YYYYMMDD
             , CASE WHEN OP.PMDU_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.PMDU_PROD_FRZ_START_YYYYMMDD
                    ELSE TO_CHAR(TO_DATE(OP.PMDU_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END
             , ( TO_DATE(CASE WHEN OP.PMDU_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.PMDU_PROD_FRZ_START_YYYYMMDD
                              ELSE TO_CHAR(TO_DATE(OP.PMDU_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END,'YYYYMMDD')
                 - TO_DATE(OP.PMDU_PROD_FRZ_START_YYYYMMDD,'YYYYMMDD') )
             , V_PLAN_EXEC_TYPE
          FROM SCP_OPMZ_PLAN_M OP
         WHERE OP.OPMZ_PLAN_ID = V_PLAN_ID
           AND OP.PMDU_PROD_FRZ_START_YYYYMMDD IS NOT NULL
           AND OP.PMDU_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
        UNION ALL
        /* UI/조립/FP&SCP/MDLE */
        SELECT OP.OPMZ_PLAN_ID
             , V_DIVISION_ID
             , 'PROD'
             , OP.PROD_REF_SYS_DIVS_CD
             , V_SCP_PLAN_TYPE
             , V_SCP_PLAN_SEQ
             , V_SCP_PLAN_DATE
             , 'MDLE'
             , OP.PMDU_PROD_FRZ_START_YYYYMMDD
             , CASE WHEN OP.PMDU_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.PMDU_PROD_FRZ_START_YYYYMMDD
                    ELSE TO_CHAR(TO_DATE(OP.PMDU_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END
             , ( TO_DATE(CASE WHEN OP.PMDU_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.PMDU_PROD_FRZ_START_YYYYMMDD
                              ELSE TO_CHAR(TO_DATE(OP.PMDU_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END,'YYYYMMDD')
                 - TO_DATE(OP.PMDU_PROD_FRZ_START_YYYYMMDD,'YYYYMMDD') )
             , V_PLAN_EXEC_TYPE
          FROM SCP_OPMZ_PLAN_M OP
         WHERE OP.OPMZ_PLAN_ID = V_PLAN_ID
           AND OP.PMDU_PROD_FRZ_START_YYYYMMDD IS NOT NULL
           AND OP.PMDU_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
        UNION ALL
        /* 2026.03.18 UI/조립/FP&SCP/LINK (룩업 적용여부) */
        SELECT OP.OPMZ_PLAN_ID
             , V_DIVISION_ID
             , 'PROD'
             , OP.PROD_REF_SYS_DIVS_CD
             , V_SCP_PLAN_TYPE
             , V_SCP_PLAN_SEQ
             , V_SCP_PLAN_DATE
             , 'LINK'
             , OP.PMDU_PROD_FRZ_START_YYYYMMDD
             , CASE WHEN OP.PMDU_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.PMDU_PROD_FRZ_START_YYYYMMDD
                    ELSE TO_CHAR(TO_DATE(OP.PMDU_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END
             , ( TO_DATE(CASE WHEN OP.PMDU_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.PMDU_PROD_FRZ_START_YYYYMMDD
                              ELSE TO_CHAR(TO_DATE(OP.PMDU_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END,'YYYYMMDD')
                 - TO_DATE(OP.PMDU_PROD_FRZ_START_YYYYMMDD,'YYYYMMDD') )
             , V_PLAN_EXEC_TYPE
          FROM SCP_OPMZ_PLAN_M OP
         WHERE OP.OPMZ_PLAN_ID = V_PLAN_ID
           AND OP.PMDU_PROD_FRZ_START_YYYYMMDD IS NOT NULL
           AND OP.PMDU_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
           AND V_LINK_FROZEN_APPLY_YN = 'Y'
        UNION ALL

        SELECT OP.OPMZ_PLAN_ID
             , V_DIVISION_ID
             , 'PROD'
             , OP.PROD_REF_SYS_DIVS_CD
             , V_SCP_PLAN_TYPE
             , V_SCP_PLAN_SEQ
             , V_SCP_PLAN_DATE
             , 'ASSY'
             , OP.CELL_PROD_FRZ_START_YYYYMMDD
             , CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                    ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END
             , ( TO_DATE(CASE WHEN OP.CELL_PROD_FRZ_END_YYYYMMDD IS NULL THEN OP.CELL_PROD_FRZ_START_YYYYMMDD
                              ELSE TO_CHAR(TO_DATE(OP.CELL_PROD_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END,'YYYYMMDD')
                 - TO_DATE(OP.CELL_PROD_FRZ_START_YYYYMMDD,'YYYYMMDD') )
             , V_PLAN_EXEC_TYPE
          FROM SCP_OPMZ_PLAN_M OP
         WHERE OP.OPMZ_PLAN_ID = V_PLAN_ID
           AND OP.PMDU_PROD_FRZ_START_YYYYMMDD IS NOT NULL
           AND OP.PMDU_PROD_FRZ_END_YYYYMMDD   IS NOT NULL
        /* --------------------- 출하 FROZEN --------------------- */
        UNION ALL
        /* MANUAL/조립/SCP */
        SELECT V_PLAN_ID
             , V_DIVISION_ID
             , 'SHIP'
             , 'SCP'
             , V_SHIP_SCP_PLAN_TYPE
             , V_SHIP_SCP_PLAN_SEQ
             , V_SHIP_SCP_PLAN_DATE
             , STAGE
             , FROZEN_START_YYYYMMDD
             , FROZEN_END_YYYYMMDD
             , TO_NUMBER(FROZEN_DAYS)
             , V_PLAN_EXEC_TYPE
          FROM GT_OPT_ENG_FRZMST_SHIP
         WHERE 1=1
           AND FROZEN_START_YYYYMMDD IS NOT NULL
           AND FROZEN_END_YYYYMMDD   IS NOT NULL
           AND FROZEN_DAYS           IS NOT NULL
        UNION ALL
        /* UI/조립/SCP&SSP */
        SELECT OP.OPMZ_PLAN_ID
             , V_DIVISION_ID
             , 'SHIP'
             , OP.SHIP_REF_SYS_DIVS_CD
             , V_SHIP_SCP_PLAN_TYPE
             , V_SHIP_SCP_PLAN_SEQ
             , V_SHIP_SCP_PLAN_DATE
             , 'SHIP'
             , OP.SHIP_FRZ_START_YYYYMMDD
             , CASE WHEN OP.SHIP_FRZ_END_YYYYMMDD IS NULL THEN OP.SHIP_FRZ_START_YYYYMMDD
                    ELSE TO_CHAR(TO_DATE(OP.SHIP_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END
             , ( TO_DATE(CASE WHEN OP.SHIP_FRZ_END_YYYYMMDD IS NULL THEN OP.SHIP_FRZ_START_YYYYMMDD
                              ELSE TO_CHAR(TO_DATE(OP.SHIP_FRZ_END_YYYYMMDD,'YYYYMMDD')+1,'YYYYMMDD') END,'YYYYMMDD')
                 - TO_DATE(OP.SHIP_FRZ_START_YYYYMMDD,'YYYYMMDD') )
             , V_PLAN_EXEC_TYPE
          FROM SCP_OPMZ_PLAN_M OP
         WHERE OP.OPMZ_PLAN_ID = V_PLAN_ID
           AND OP.SHIP_FRZ_START_YYYYMMDD IS NOT NULL
           AND OP.SHIP_FRZ_END_YYYYMMDD   IS NOT NULL;

    EXCEPTION
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SQLERRM;
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            V_DETAIL_DATE  := SYSDATE;
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,V_DETAIL_DATE,NULL,V_MESSAGE_TEXT,'ERROR');
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'END',NULL,NULL,NULL,V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL);
    END IF;

END PR_SCP_OPT_ENG_ESS_INPUT_FROZEN_MASTER;