-- SOURCE-FRESH: SCM_MGR.PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA PROCEDURE LAST_DDL=2026-09-15 18:59:11 FETCHED=2026-09-15 21:03 DB=ZIOUI1
-- 외부 호출부 — 대상 SP 호출을 PKG 멤버로 전환 (사내 적용 2026-09-15)
SET DEFINE OFF
CREATE OR REPLACE PROCEDURE SCM_MGR."PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA" 
(
    /* Add the parameters for the stored procedure here */
    P_ACTIVE_FLAG           VARCHAR2
  , P_DIVISION_ID           VARCHAR2
  , P_CUSTOMER_PROJECT_CODE VARCHAR2
  , P_CUSTOMER_MODEL        VARCHAR2
  , P_SCM_SITE_ID           VARCHAR2
  , P_PROJECT_CODE          VARCHAR2
  , P_ITEM_ID               VARCHAR2
  , P_VALID_YN              VARCHAR2
  , P_CUSTOMER_MODEL_TYPE   VARCHAR2
  , P_CONVERT_QTY_PACK      VARCHAR2
  , P_CONVERT_QTY_MODULE    VARCHAR2
  , P_CONVERT_QTY_CELL      VARCHAR2
  , P_CREATED_BY            VARCHAR2
  , P_CREATION_DATE         VARCHAR2
  , P_LAST_UPDATED_BY       VARCHAR2
  , P_LAST_UPDATE_DATE      VARCHAR2
    /*
    P_ATTRIBUTE1            VARCHAR2,
    P_ATTRIBUTE2            VARCHAR2,
    P_ATTRIBUTE3            VARCHAR2,
    P_ATTRIBUTE4            VARCHAR2,
    P_ATTRIBUTE5            VARCHAR2,
    P_ATTRIBUTE6            VARCHAR2,
    P_ATTRIBUTE7            VARCHAR2,
    P_ATTRIBUTE8            VARCHAR2,
    P_ATTRIBUTE9            VARCHAR2,
    P_ATTRIBUTE10           VARCHAR2
    */
    /* P_SUCCESS_YN          OUT VARCHAR2 */
)
/*
 * Program ID   : PR_DM_MST_SAVE_CUSTOMER_MODEL_MAPPING_DATA
 * Description  : CUSTOMER MODEL MAPPING DATA INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 12. 15    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.07.06      ZIONEX           [PJ202650304] NextSCM Migration
 *
 */
AS

    V_RECV_ACTIVE_FLAG      VARCHAR2(4000 CHAR);

    V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
    V_DIVISION_ID           VARCHAR2(4000 CHAR);
    V_CUSTOMER_PROJECT_CODE VARCHAR2(4000 CHAR);
    V_CUSTOMER_MODEL        VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID           VARCHAR2(4000 CHAR);
    V_PROJECT_CODE          VARCHAR2(4000 CHAR);
    V_ITEM_ID               VARCHAR2(4000 CHAR);
    V_VALID_YN              VARCHAR2(4000 CHAR);
    V_CUSTOMER_MODEL_TYPE   VARCHAR2(4000 CHAR);
    V_CONVERT_QTY_PACK      VARCHAR2(4000 CHAR);
    V_CONVERT_QTY_MODULE    VARCHAR2(4000 CHAR);
    V_CONVERT_QTY_CELL      VARCHAR2(4000 CHAR);
    V_CREATED_BY            VARCHAR2(4000 CHAR);
    V_CREATION_DATE         VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY       VARCHAR2(4000 CHAR);
    V_LAST_UPDATE_DATE      VARCHAR2(4000 CHAR);
    V_ATTRIBUTE1            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE2            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE3            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE4            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE5            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE6            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE7            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE8            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE9            VARCHAR2(4000 CHAR);
    V_ATTRIBUTE10           VARCHAR2(4000 CHAR);

    V_DELIMITER             VARCHAR2(1 CHAR);
    V_MAX_LOOP_CNT          PLS_INTEGER := 0;
    V_MST_LOOP_CNT          PLS_INTEGER := 0;

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE              VARCHAR2(30 CHAR); /* START/END/ERROR/... */
    N_LOG_COUNT             PLS_INTEGER := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    D_EVENT_DATE            DATE;


    V_IN_PARA_DATA          VARCHAR2(4000 CHAR);

BEGIN

    V_RECV_ACTIVE_FLAG := NULL;
    V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;

    /* recv init */
    V_ACTIVE_FLAG           := NULL;
    V_DIVISION_ID           := NULL;
    V_CUSTOMER_PROJECT_CODE := NULL;
    V_CUSTOMER_MODEL        := NULL;
    V_SCM_SITE_ID           := NULL;
    V_PROJECT_CODE          := NULL;
    V_ITEM_ID               := NULL;
    V_VALID_YN              := NULL;
    V_CUSTOMER_MODEL_TYPE   := NULL;
    V_CONVERT_QTY_PACK      := NULL;
    V_CONVERT_QTY_MODULE    := NULL;
    V_CONVERT_QTY_CELL      := NULL;
    V_CREATED_BY            := NULL;
    V_CREATION_DATE         := NULL;
    V_LAST_UPDATED_BY       := NULL;
    V_LAST_UPDATE_DATE      := NULL;
    V_ATTRIBUTE1            := NULL;
    V_ATTRIBUTE2            := NULL;
    V_ATTRIBUTE3            := NULL;
    V_ATTRIBUTE4            := NULL;
    V_ATTRIBUTE5            := NULL;
    V_ATTRIBUTE6            := NULL;
    V_ATTRIBUTE7            := NULL;
    V_ATTRIBUTE8            := NULL;
    V_ATTRIBUTE9            := NULL;
    V_ATTRIBUTE10           := NULL;

    V_DELIMITER := '^';  /* 데이터 구분자 */

    V_IN_PARA_DATA := JSON_OBJECT(
        'P_ACTIVE_FLAG'           VALUE P_ACTIVE_FLAG
      , 'P_DIVISION_ID'           VALUE P_DIVISION_ID
      , 'P_CUSTOMER_PROJECT_CODE' VALUE P_CUSTOMER_PROJECT_CODE
      , 'P_CUSTOMER_MODEL'        VALUE P_CUSTOMER_MODEL
      , 'P_SCM_SITE_ID'           VALUE P_SCM_SITE_ID
      , 'P_PROJECT_CODE'          VALUE P_PROJECT_CODE
      , 'P_ITEM_ID'               VALUE P_ITEM_ID
      , 'P_VALID_YN'              VALUE P_VALID_YN
      , 'P_CUSTOMER_MODEL_TYPE'   VALUE P_CUSTOMER_MODEL_TYPE
      , 'P_CONVERT_QTY_PACK'      VALUE P_CONVERT_QTY_PACK
      , 'P_CONVERT_QTY_MODULE'    VALUE P_CONVERT_QTY_MODULE
      , 'P_CONVERT_QTY_CELL'      VALUE P_CONVERT_QTY_CELL
      , 'P_CREATED_BY'            VALUE P_CREATED_BY
        RETURNING VARCHAR2(4000 CHAR));

    /* 트랜잭션 (START) -- BEGIN TRANSACTION CUSTOMER_MODEL_MAPPING_DATA (Oracle: 평면 트랜잭션) */

    /* 시작 LOG  (START) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;      /* <- 변수 재사용을 위하여 초기화해야함 */
    /* 시작 LOG  (END) */


    /* 프로시저 LOOP 길이를 판단 */
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);
    DBMS_OUTPUT.PUT_LINE('max_loop_cnt = ' || V_MAX_LOOP_CNT);

    /* WHILE LEN(@p_active_flag) > 0 */
    WHILE LENGTH(V_RECV_ACTIVE_FLAG) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT

    /* (0) */
    LOOP

        DBMS_OUTPUT.PUT_LINE('max_loop_cnt = ' || V_MAX_LOOP_CNT);
        /* @mst_loop_cnt 1증가 */
        V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

        /* DISPLAY */
        /* DBMS_OUTPUT.PUT_LINE(V_MST_LOOP_CNT || ' @mst_loop_cnt'); */

        /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
        BEGIN

            V_ACTIVE_FLAG           := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,           V_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID           := SCM_ARR_SPL_VAL(P_DIVISION_ID,           V_DELIMITER, V_MST_LOOP_CNT);
            V_CUSTOMER_PROJECT_CODE := SCM_ARR_SPL_VAL(P_CUSTOMER_PROJECT_CODE, V_DELIMITER, V_MST_LOOP_CNT);
            V_CUSTOMER_MODEL        := SCM_ARR_SPL_VAL(P_CUSTOMER_MODEL,        V_DELIMITER, V_MST_LOOP_CNT);
            V_SCM_SITE_ID           := SCM_ARR_SPL_VAL(P_SCM_SITE_ID,           V_DELIMITER, V_MST_LOOP_CNT);
            V_PROJECT_CODE          := SCM_ARR_SPL_VAL(P_PROJECT_CODE,          V_DELIMITER, V_MST_LOOP_CNT);
            V_ITEM_ID               := SCM_ARR_SPL_VAL(P_ITEM_ID,               V_DELIMITER, V_MST_LOOP_CNT);
            V_VALID_YN              := SCM_ARR_SPL_VAL(P_VALID_YN,              V_DELIMITER, V_MST_LOOP_CNT);
            V_CUSTOMER_MODEL_TYPE   := SCM_ARR_SPL_VAL(P_CUSTOMER_MODEL_TYPE,   V_DELIMITER, V_MST_LOOP_CNT);
            V_CONVERT_QTY_PACK      := SCM_ARR_SPL_VAL(P_CONVERT_QTY_PACK,      V_DELIMITER, V_MST_LOOP_CNT);
            V_CONVERT_QTY_MODULE    := SCM_ARR_SPL_VAL(P_CONVERT_QTY_MODULE,    V_DELIMITER, V_MST_LOOP_CNT);
            V_CONVERT_QTY_CELL      := SCM_ARR_SPL_VAL(P_CONVERT_QTY_CELL,      V_DELIMITER, V_MST_LOOP_CNT);
            V_CREATED_BY            := SCM_ARR_SPL_VAL(P_CREATED_BY,            V_DELIMITER, V_MST_LOOP_CNT);
            V_LAST_UPDATED_BY       := SCM_ARR_SPL_VAL(P_LAST_UPDATED_BY,       V_DELIMITER, V_MST_LOOP_CNT);

            /*-- 확인용 변수값 DISPLAY
            DBMS_OUTPUT.PUT_LINE('v_active_flag='           || V_ACTIVE_FLAG);
            DBMS_OUTPUT.PUT_LINE('V_DIVISION_ID='           || V_DIVISION_ID);
            DBMS_OUTPUT.PUT_LINE('V_CUSTOMER_PROJECT_CODE=' || V_CUSTOMER_PROJECT_CODE);
            DBMS_OUTPUT.PUT_LINE('V_CUSTOMER_MODEL='        || V_CUSTOMER_MODEL);
            DBMS_OUTPUT.PUT_LINE('V_SCM_SITE_ID='           || V_SCM_SITE_ID);
            DBMS_OUTPUT.PUT_LINE('V_PROJECT_CODE='          || V_PROJECT_CODE);
            DBMS_OUTPUT.PUT_LINE('V_ITEM_ID='               || V_ITEM_ID);
            DBMS_OUTPUT.PUT_LINE('V_VALID_YN='              || V_VALID_YN);
            DBMS_OUTPUT.PUT_LINE('V_CUSTOMER_MODEL_TYPE='   || V_CUSTOMER_MODEL_TYPE);
            DBMS_OUTPUT.PUT_LINE('V_CONVERT_QTY_PACK='      || V_CONVERT_QTY_PACK);
            DBMS_OUTPUT.PUT_LINE('V_CONVERT_QTY_MODULE='    || V_CONVERT_QTY_MODULE);
            DBMS_OUTPUT.PUT_LINE('V_CONVERT_QTY_CELL='      || V_CONVERT_QTY_CELL);
            DBMS_OUTPUT.PUT_LINE('V_CREATED_BY='            || V_CREATED_BY);
            DBMS_OUTPUT.PUT_LINE('V_LAST_UPDATED_BY='       || V_LAST_UPDATED_BY);
            */

        END;

        /*--------- MULTI & SINGLE ROW START --------*/

        /* (1) */
        /*-- max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행하도록함 --*/
        IF V_MST_LOOP_CNT <= V_MAX_LOOP_CNT THEN

            /* (2) */
            /* INSERT */
            IF V_ACTIVE_FLAG = 'I' THEN

                /* INSERT 전 PK값 DELETE */
                DELETE
                    FROM DM_MST_CUSTOMER_MODEL
                    WHERE
                          DIVISION_ID = V_DIVISION_ID
                      AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                      AND CUSTOMER_MODEL = V_CUSTOMER_MODEL
                      AND SCM_SITE_ID = V_SCM_SITE_ID ;

                /* INSERT 수행 */
                INSERT INTO DM_MST_CUSTOMER_MODEL
                   (
                    DIVISION_ID
                   ,CUSTOMER_PROJECT_CODE
                   ,CUSTOMER_MODEL
                   ,SCM_SITE_ID
                   ,PROJECT_CODE
                   ,ITEM_ID
                   ,VALID_YN
                   ,CUSTOMER_MODEL_TYPE
                   ,CONVERT_QTY_PACK
                   ,CONVERT_QTY_MODULE
                   ,CONVERT_QTY_CELL
                   ,CREATED_BY
                   ,CREATION_DATE
                   ,LAST_UPDATED_BY
                   ,LAST_UPDATE_DATE
                   ,ATTRIBUTE1
                   ,ATTRIBUTE2
                   ,ATTRIBUTE3
                   ,ATTRIBUTE4
                   ,ATTRIBUTE5
                   ,ATTRIBUTE6
                   ,ATTRIBUTE7
                   ,ATTRIBUTE8
                   ,ATTRIBUTE9
                   ,ATTRIBUTE10
                   )
                VALUES
                   (
                      V_DIVISION_ID
                     ,V_CUSTOMER_PROJECT_CODE
                     ,V_CUSTOMER_MODEL
                     ,V_SCM_SITE_ID
                     ,V_PROJECT_CODE
                     ,V_ITEM_ID
                     ,V_VALID_YN
                     ,V_CUSTOMER_MODEL_TYPE
                     ,V_CONVERT_QTY_PACK
                     ,V_CONVERT_QTY_MODULE
                     ,V_CONVERT_QTY_CELL
                     ,V_CREATED_BY
                     ,SYSDATE
                     ,V_LAST_UPDATED_BY
                     ,SYSDATE
                     ,NULL
                     ,NULL
                     ,NULL
                     ,NULL
                     ,NULL
                     ,NULL
                     ,NULL
                     ,NULL
                     ,NULL
                     ,NULL
                     ) ;
            END IF;
            /* (2) */

            /* (3) */
            /* UPDATE */
            IF V_ACTIVE_FLAG = 'M' THEN

                UPDATE DM_MST_CUSTOMER_MODEL
                SET
                 PROJECT_CODE = V_PROJECT_CODE
                ,ITEM_ID = V_ITEM_ID
               ,VALID_YN = V_VALID_YN
               ,CUSTOMER_MODEL_TYPE = V_CUSTOMER_MODEL_TYPE
               ,CONVERT_QTY_PACK = V_CONVERT_QTY_PACK
               ,CONVERT_QTY_MODULE = V_CONVERT_QTY_MODULE
               ,CONVERT_QTY_CELL = V_CONVERT_QTY_CELL
               ,LAST_UPDATED_BY = V_LAST_UPDATED_BY
               ,LAST_UPDATE_DATE = SYSDATE
               ,ATTRIBUTE1 = NULL
               ,ATTRIBUTE2 = NULL
               ,ATTRIBUTE3 = NULL
               ,ATTRIBUTE4 = NULL
               ,ATTRIBUTE5 = NULL
               ,ATTRIBUTE6 = NULL
               ,ATTRIBUTE7 = NULL
               ,ATTRIBUTE8 = NULL
               ,ATTRIBUTE9 = NULL
               ,ATTRIBUTE10 = NULL
                WHERE
                      DIVISION_ID = V_DIVISION_ID
                  AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                  AND CUSTOMER_MODEL = V_CUSTOMER_MODEL
                  AND SCM_SITE_ID = V_SCM_SITE_ID ;
            END IF;
            /* (3) */

            /* (4) */
            /* DELETE */
            IF V_ACTIVE_FLAG = 'D' THEN

                DELETE
                FROM DM_MST_CUSTOMER_MODEL
                WHERE
                      DIVISION_ID = V_DIVISION_ID
                  AND CUSTOMER_PROJECT_CODE = V_CUSTOMER_PROJECT_CODE
                  AND CUSTOMER_MODEL = V_CUSTOMER_MODEL
                  AND SCM_SITE_ID = V_SCM_SITE_ID ;
            END IF;
            /* (4) */

            /* HISTORY INSERT */
            BEGIN
                PKG_DMF0006.P_PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST(
                     V_DIVISION_ID
                    ,V_CUSTOMER_PROJECT_CODE
                    ,V_CUSTOMER_MODEL
                    ,V_SCM_SITE_ID
                    ,V_PROJECT_CODE
                    ,V_ITEM_ID
                    ,V_VALID_YN
                    ,V_CUSTOMER_MODEL_TYPE
                    ,V_CONVERT_QTY_PACK
                    ,V_CONVERT_QTY_MODULE
                    ,V_CONVERT_QTY_CELL
                    ,V_CREATED_BY
                );
            END;

        END IF;
        /* (1) */
    END LOOP;
    /* (0) */

    /* IF @@TRANCOUNT > 0 */
    /* 트랜잭션 (COMMIT) */
    COMMIT;


    /* 수행결과 성공여부 DISPLAY */
    IF V_LOG_MESSAGE IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('success');
    END IF;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

/*------------------------------------------------------------*/
EXCEPTION
    WHEN OTHERS THEN
/*------------------------------------------------------------*/
        ROLLBACK;

        /* ERROR LOG */
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;

        /* SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  에러메시지 DISPLAY */
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
          , P_IN_PARA_DATA  => V_IN_PARA_DATA
          , P_SQL_ERR_CODE  => SQLCODE
          , P_SQL_ERR_MSG   => SQLERRM
          , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        RAISE_APPLICATION_ERROR(-20001, '[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
