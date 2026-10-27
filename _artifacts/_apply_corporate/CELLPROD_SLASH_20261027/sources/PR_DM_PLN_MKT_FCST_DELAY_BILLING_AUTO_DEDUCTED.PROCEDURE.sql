PROCEDURE         "PR_DM_PLN_MKT_FCST_DELAY_BILLING_AUTO_DEDUCTED" 
(
    P_DIVISION_ID   IN VARCHAR2
)
/*==============================================================================================================================
 * Program ID   : PR_DM_PLN_MKT_FCST_DELAY_BILLING_AUTO_DEDUCTED
 * Description  : 23시에 발생한 실적과 13시에 발생한 실적이 다른 경우 룩업에 등록한 대상에 대해서만 MKT FCST에서 차감
 * Program History
 * 요청배경: 매출실적 지연처리로 인한 수요계획 입력 시 혼선이 있어 특정 팀/모델에 대해 개선안 적용요청
 * 요청내용: 실적업데이트 시점 기준 월 13시~월 23시 사이에 매출실적이 추가 발생하면 이를 수요계획 구간에서 자동 차감하는 안
 *  ※ 23시 데이터가 13시 데이터보다 많은 경우에만 적용되며, 13시 데이터가 더 큰 경우에는 해당 없음 ※
 *  ※ MKT FCST 데이터를 새로 생성해주지는 않고, 계획수량에 있는 내에서의 수량에 대해서까지만 뺴준다 ※
 *==============================================================================================================================
 *   Date       In Charge      Description
 *==============================================================================================================================
 * 2025.04.14   JSSBAE         [E20250404-001534]_[공급생산 SCM PI팀] 지연 빌링 발생 시 수요계획 보정 기능 개발 요청
 * 2025.06.23   KANG.H.J       [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.07.06   ZIONEX         [PJ202650304] NextSCM Migration
 ==============================================================================================================================*/
IS
    V_PROGRAM_NAME    VARCHAR2(150 CHAR) := 'PR_DM_PLN_MKT_FCST_DELAY_BILLING_AUTO_DEDUCTED';
    V_LOG_TYPE        VARCHAR2(30 CHAR);       /* START/END/ERROR/... */
    N_LOG_COUNT       NUMBER             := 0;
    V_LOG_MESSAGE     VARCHAR2(1000 CHAR);
    V_DESCRIPTION     VARCHAR2(500 CHAR);
    D_EVENT_DATE      DATE;
    V_BATCH_USER      VARCHAR2(150 CHAR) := 'AUTO_DEDUCTED';
    V_VERSION         VARCHAR2(50 CHAR);

    V_DEDUCTED_QTY    NUMBER(30,10);   /* 실제 차감해야 하는 실적 수량 */
    V_TARGET_QTY      NUMBER(30,10);   /* 실제 MKT FCST 에서 차감한 수량 */
    V_REM_QTY         NUMBER(30,10);   /* 차감하고 남은 수량 */
    V_CNT             NUMBER;
BEGIN


    /* 버전설정 (MF_D 와 V000 은 고정이다) */
    V_VERSION := 'MF_D_' || TO_CHAR(SYSDATE, 'YYYYMMDD') || '_V000';

    /*==========================================================================================================================
    -- 시작 LOG (START)
    ==========================================================================================================================*/
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;      /* <- 변수 재사용을 위하여 초기화해야함 */

    /*==========================================================================================================================
    -- 트랜잭션 (원본 BEGIN TRANSACTION AUTO_DEDUCTED / COMMIT WORK / ROLLBACK -> Oracle 블록 COMMIT / EXCEPTION ROLLBACK)
    ==========================================================================================================================*/
    BEGIN


        DELETE
          FROM GT_DM_DEDUCT_ITEM;
        DELETE
          FROM GT_DM_DEDUCT_DATA;
        DELETE
          FROM GT_DM_DEDUCT_MFDATA;
        DELETE
          FROM GT_DM_DEDUCT_LOOP;
        DELETE
          FROM GT_DM_DEDUCT_UPD;

        /*----------------------------------------------------------------------------------------------------------------------
        -- 1. DM_PLN_MKT_FCST 에서 차감 대상이 될 데이터를 추출하여 TEMP(GTT)에 담는다.
        --   룩업 등록 대상 기준 DIVISION_ID/ITEM/TEAM(OWNER->DEPT_ID) 로 SCM_MST_SITE_ITEM PK 를 추출.
        --   OWNER 는 콤마 다건 -> STRING_SPLIT 로 분해하여 각 OWNER 의 DEPT_ID 를 모두 추출.
        ----------------------------------------------------------------------------------------------------------------------*/
        INSERT
          INTO GT_DM_DEDUCT_ITEM
             ( DIVISION_ID
             , SCM_SITE_ID
             , PROJECT_CODE
             , ITEM_ID )
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.PROJECT_CODE
             , A.ITEM_ID
          FROM ( SELECT A.DIVISION_ID
                      , A.PROJECT_CODE
                      , A.SCM_SITE_ID
                      , A.ITEM_ID
                      , A.OWNER
--                      , A.REAL_OWNER
--                      , B.DEPT_ID
                      , A.DEPT_ID                                           -- 2026.09.03 AJS
/*                   FROM ( SELECT A.DIVISION_ID
                               , A.PROJECT_CODE
                               , A.SCM_SITE_ID
                               , A.ITEM_ID
                               , A.OWNER
                               , S.COLUMN_VALUE AS REAL_OWNER
                               , A.DEPT_ID
                            FROM SCM_MST_SITE_ITEM A
                           CROSS JOIN TABLE(STRING_SPLIT(A.OWNER, ',')) S
                           WHERE A.VALID_YN = 'Y'
                             AND RTRIM(A.OWNER) IS NOT NULL
                        ) A
                      , SCM_MST_SSO_USER_INFO      B                        */
                   FROM SCM_MST_SITE_ITEM A                                 -- 2026.09.06 AJS
                      , SCM_ADM_LOOKUP_MASTER_DETAIL C
/*                  WHERE UPPER(A.REAL_OWNER) = UPPER(B.USER_ID)            */
                  WHERE A.ITEM_ID           = C.SEGMENT2                    -- 2026.09.06 AJS
--                    AND B.DEPT_ID           = C.SEGMENT3
                    AND A.DEPT_ID           = C.SEGMENT3                    -- 2026.09.03 AJS
                    AND A.VALID_YN          = 'Y'                           -- 2026.09.06 AJS
                    AND A.DIVISION_ID       = P_DIVISION_ID
                    AND C.LOOKUP_TYPE       = 'DM_DELAY_BILLING_AUTO_DEDUCTED'
               ) A
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.PROJECT_CODE
                , A.ITEM_ID;
        N_LOG_COUNT := SQL%ROWCOUNT;

        V_LOG_TYPE    := 'APPEND';
        V_LOG_MESSAGE := 'TARGET DATA1';
        V_DESCRIPTION := '#TEMP_DEDUCTED_ITEM INSERT: DIVISION_ID: ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /*----------------------------------------------------------------------------------------------------------------------
        --    KEY 별 총 갭차이(차감수량 SUM)만 보관한다. (날짜별 갭 산출 후 KEY 로 SUM)
        ---------------------------------------------------------------------------------------------------------------------- */
        INSERT
          INTO GT_DM_DEDUCT_DATA
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , PLANT_SITE_ID
             , DEDUCTED_QTY )
        SELECT T.DIVISION_ID
             , T.PROJECT_CODE
             , T.SCM_SITE_ID
             , T.ITEM_ID
             , T.DOM_EXP
             , T.FCST_TYPE
             , T.INCOTERMS
             , T.PLANT_SITE_ID
             , SUM(T.DEDUCTED_QTY) AS DEDUCTED_QTY
          FROM ( SELECT A.DIVISION_ID
                      , A.PROJECT_CODE
                      , A.SCM_SITE_ID
                      , A.ITEM_ID
                      , A.DOM_EXP
                      , A.FCST_TYPE
                      , A.INCOTERMS
                      , A.MEASURE
                      , A.PLANT_SITE_ID
                      , A.YYYYMMDD
                      , A.SALES_QTY_23
                      , NVL(B.SALES_QTY_13, 0) AS SALES_QTY_13
                      , A.SALES_QTY_23 - NVL(B.SALES_QTY_13, 0) AS DEDUCTED_QTY
                   FROM ( /* 23시 실적 받은 데이터 */
                          SELECT A.DIVISION_ID
                               , A.PROJECT_CODE
                               , A.SCM_SITE_ID
                               , A.ITEM_ID
                               , A.DOM_EXP
                               , A.FCST_TYPE
                               , A.INCOTERMS
                               , A.MEASURE
                               , A.PLANT_SITE_ID
                               , A.YYYYMMDD
                               , SUM(A.QTY) AS SALES_QTY_23
                            FROM DM_PLN_MKT_FCST_RESULT A
                               , GT_DM_DEDUCT_ITEM      B
                           WHERE A.DIVISION_ID  = B.DIVISION_ID
                             AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                             AND A.PROJECT_CODE = B.PROJECT_CODE
                             AND A.ITEM_ID      = B.ITEM_ID
                             AND A.MEASURE      = 'RTF_SYS_RP'
                             AND A.YYYYMMDD    >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 14, 'YYYYMMDD')   /* 전주 월요일 */
                             AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7,  'YYYYMMDD')   /* 당주 월요일 이전 */
                           GROUP BY A.DIVISION_ID
                                  , A.PROJECT_CODE
                                  , A.SCM_SITE_ID
                                  , A.ITEM_ID
                                  , A.DOM_EXP
                                  , A.FCST_TYPE
                                  , A.INCOTERMS
                                  , A.MEASURE
                                  , A.PLANT_SITE_ID
                                  , A.YYYYMMDD
                        ) A
                      , ( /* 13시 실적 받아 MF_D 에 보관한 데이터 */
                          SELECT A.DIVISION_ID
                               , A.PROJECT_CODE
                               , A.SCM_SITE_ID
                               , A.ITEM_ID
                               , A.DOM_EXP
                               , A.FCST_TYPE
                               , A.INCOTERMS
                               , A.MEASURE
                               , A.PLANT_SITE_ID
                               , A.YYYYMMDD
                               , SUM(A.QTY) AS SALES_QTY_13
                            FROM DM_PLN_MKT_FCST_RESULT_C A
                               , GT_DM_DEDUCT_ITEM        B
                           WHERE A.DIVISION_ID  = B.DIVISION_ID
                             AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                             AND A.PROJECT_CODE = B.PROJECT_CODE
                             AND A.ITEM_ID      = B.ITEM_ID
                             AND A.MEASURE      = 'RTF_SYS_RP'
                             AND A.YYYYMMDD    >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 14, 'YYYYMMDD')   /* 전주 월요일 */
                             AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7,  'YYYYMMDD')   /* 당주 월요일 이전 */
                             AND A.VERSION_NO   = V_VERSION
                           GROUP BY A.DIVISION_ID
                                  , A.PROJECT_CODE
                                  , A.SCM_SITE_ID
                                  , A.ITEM_ID
                                  , A.DOM_EXP
                                  , A.FCST_TYPE
                                  , A.INCOTERMS
                                  , A.MEASURE
                                  , A.PLANT_SITE_ID
                                  , A.YYYYMMDD
                        ) B
                  WHERE A.DIVISION_ID    = B.DIVISION_ID(+)
                    AND A.PROJECT_CODE   = B.PROJECT_CODE(+)
                    AND A.SCM_SITE_ID    = B.SCM_SITE_ID(+)
                    AND A.ITEM_ID        = B.ITEM_ID(+)
                    AND A.DOM_EXP        = B.DOM_EXP(+)
                    AND A.FCST_TYPE      = B.FCST_TYPE(+)
                    AND A.INCOTERMS      = B.INCOTERMS(+)
                    AND A.MEASURE        = B.MEASURE(+)
                    AND A.PLANT_SITE_ID  = B.PLANT_SITE_ID(+)
                    AND A.YYYYMMDD       = B.YYYYMMDD(+)
                    AND ( ( NVL(A.SALES_QTY_23, 0) > NVL(B.SALES_QTY_13, 0) ) OR B.DIVISION_ID IS NULL )
               ) T
         GROUP BY T.DIVISION_ID
                , T.PROJECT_CODE
                , T.SCM_SITE_ID
                , T.ITEM_ID
                , T.DOM_EXP
                , T.FCST_TYPE
                , T.INCOTERMS
                , T.PLANT_SITE_ID;
        N_LOG_COUNT := SQL%ROWCOUNT;

        V_LOG_TYPE    := 'APPEND';
        V_LOG_MESSAGE := 'TARGET DATA2';
        V_DESCRIPTION := '#TEMP_DEDUCTED_DATA INSERT: DIVISION_ID: ' || P_DIVISION_ID;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /*----------------------------------------------------------------------------------------------------------------------
        -- ※ DIFF 건수가 발생하지 않은 경우에는 다음으로 수행하지 않고 종료한다. ※
        ----------------------------------------------------------------------------------------------------------------------*/
        SELECT COUNT(1)
          INTO V_CNT
          FROM GT_DM_DEDUCT_DATA;

        IF V_CNT > 0 THEN

            /*------------------------------------------------------------------------------------------------------------------
            -- 3. DM_PLN_MKT_FCST 와 룩업에 존재하는 데이터를 대상으로 잡는다.
            --   기준일자: 당주 월요일 이후 / 대상메져: MKT_FCST / 수량 0 초과. (KEY 별 일자순 ROW_NUM 부여)
            ------------------------------------------------------------------------------------------------------------------*/
            INSERT
              INTO GT_DM_DEDUCT_MFDATA
                 ( DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , YYYYMMDD
                 , PLANT_SITE_ID
                 , QTY
                 , ROW_NUM )
            SELECT A.DIVISION_ID
                 , A.PROJECT_CODE
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.DOM_EXP
                 , A.FCST_TYPE
                 , A.INCOTERMS
                 , A.MEASURE
                 , A.YYYYMMDD
                 , A.PLANT_SITE_ID
                 , A.QTY
                 , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID ORDER BY A.YYYYMMDD ASC) AS ROW_NUM
              FROM DM_PLN_MKT_FCST A
                 , GT_DM_DEDUCT_DATA B
             WHERE A.DIVISION_ID   = B.DIVISION_ID
               AND A.PROJECT_CODE  = B.PROJECT_CODE
               AND A.SCM_SITE_ID   = B.SCM_SITE_ID
               AND A.ITEM_ID       = B.ITEM_ID
               AND A.DOM_EXP       = B.DOM_EXP
               AND A.FCST_TYPE     = B.FCST_TYPE
               AND A.INCOTERMS     = B.INCOTERMS
               AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
               AND A.MEASURE       = 'MKT_FCST'
               AND A.YYYYMMDD     >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND A.QTY           > 0;
            N_LOG_COUNT := SQL%ROWCOUNT;

            V_LOG_TYPE    := 'APPEND';
            V_LOG_MESSAGE := 'TARGET DATA3';
            V_DESCRIPTION := '#TEMP_MKT_FCST_DATA: DIVISION_ID: ' || P_DIVISION_ID;
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);


            INSERT
              INTO GT_DM_DEDUCT_LOOP
                 ( DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , SEQ )
            SELECT DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , ROW_NUMBER() OVER (ORDER BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID) AS SEQ
              FROM GT_DM_DEDUCT_MFDATA
             GROUP BY DIVISION_ID
                    , PROJECT_CODE
                    , SCM_SITE_ID
                    , ITEM_ID
                    , DOM_EXP
                    , FCST_TYPE
                    , INCOTERMS
                    , MEASURE
                    , PLANT_SITE_ID;
            N_LOG_COUNT := SQL%ROWCOUNT;

            V_LOG_TYPE    := 'APPEND';
            V_LOG_MESSAGE := 'TARGET DATA4';
            V_DESCRIPTION := '#TEMP_TARGET_MKT_FCST: DIVISION_ID: ' || P_DIVISION_ID;
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /*------------------------------------------------------------------------------------------------------------------
            -- 5. MKT FCST 대상 데이터에서 일자별로 순차 차감한다. (외부 LOOP=KEY(SEQ), 내부 LOOP=일자(ROW_NUM))
            ------------------------------------------------------------------------------------------------------------------*/
            FOR L IN ( SELECT L.DIVISION_ID
                            , L.PROJECT_CODE
                            , L.SCM_SITE_ID
                            , L.ITEM_ID
                            , L.DOM_EXP
                            , L.FCST_TYPE
                            , L.INCOTERMS
                            , L.PLANT_SITE_ID
                            , L.SEQ
                            , D.DEDUCTED_QTY
                         FROM GT_DM_DEDUCT_LOOP L
                            , GT_DM_DEDUCT_DATA  D
                        WHERE L.DIVISION_ID   = D.DIVISION_ID
                          AND L.PROJECT_CODE  = D.PROJECT_CODE
                          AND L.SCM_SITE_ID   = D.SCM_SITE_ID
                          AND L.ITEM_ID       = D.ITEM_ID
                          AND L.DOM_EXP       = D.DOM_EXP
                          AND L.FCST_TYPE     = D.FCST_TYPE
                          AND L.INCOTERMS     = D.INCOTERMS
                          AND L.PLANT_SITE_ID = D.PLANT_SITE_ID
                        ORDER BY L.SEQ )
            LOOP
                /* MKT FCST 대상 건들 중 실제로 차감해야 하는 실적 수량 */
                V_DEDUCTED_QTY := L.DEDUCTED_QTY;

                V_LOG_TYPE    := 'APPEND';
                V_LOG_MESSAGE := 'TARGET DATA5';
                V_DESCRIPTION := SUBSTR('#TEMP_UPDATE_MKT_FCST: DIVISION_ID: ' || P_DIVISION_ID || ' / PROJECT_CODE: ' || L.PROJECT_CODE
                                     || ' / SCM_SITE_ID: ' || L.SCM_SITE_ID || ' / ITEM_ID: ' || L.ITEM_ID || ' / DOM_EXP: ' || L.DOM_EXP || ' / FCST_TYPE: ' || L.FCST_TYPE
                                     || ' / INCOTERMS: ' || L.INCOTERMS || ' / PLANT_SITE_ID: ' || L.PLANT_SITE_ID || ' / DEDUCTED_QTY: ' || TO_CHAR(V_DEDUCTED_QTY), 1, 500);
                D_EVENT_DATE  := SYSDATE;
                N_LOG_COUNT   := L.SEQ;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

                FOR M IN ( SELECT M.YYYYMMDD
                                , M.QTY
                             FROM GT_DM_DEDUCT_MFDATA M
                            WHERE M.DIVISION_ID   = L.DIVISION_ID
                              AND M.PROJECT_CODE  = L.PROJECT_CODE
                              AND M.SCM_SITE_ID   = L.SCM_SITE_ID
                              AND M.ITEM_ID       = L.ITEM_ID
                              AND M.DOM_EXP       = L.DOM_EXP
                              AND M.FCST_TYPE     = L.FCST_TYPE
                              AND M.INCOTERMS     = L.INCOTERMS
                              AND M.PLANT_SITE_ID = L.PLANT_SITE_ID
                            ORDER BY M.ROW_NUM )
                LOOP
                    V_TARGET_QTY := CASE WHEN NVL(M.QTY, 0) - V_DEDUCTED_QTY < 0 THEN NVL(M.QTY, 0) - NVL(M.QTY, 0)
                                         ELSE NVL(M.QTY, 0) - V_DEDUCTED_QTY
                                    END;
                    V_REM_QTY    := V_DEDUCTED_QTY - NVL(M.QTY, 0);   /* MKT FCST 에서 실적수량을 빼고 남은 수량 */

                    INSERT
                      INTO GT_DM_DEDUCT_UPD
                         ( DIVISION_ID
                         , PROJECT_CODE
                         , SCM_SITE_ID
                         , ITEM_ID
                         , DOM_EXP
                         , FCST_TYPE
                         , INCOTERMS
                         , MEASURE
                         , YYYYMMDD
                         , PLANT_SITE_ID
                         , QTY
                         , BEFORE_QTY )
                    VALUES ( L.DIVISION_ID
                           , L.PROJECT_CODE
                           , L.SCM_SITE_ID
                           , L.ITEM_ID
                           , L.DOM_EXP
                           , L.FCST_TYPE
                           , L.INCOTERMS
                           , 'MKT_FCST'
                           , M.YYYYMMDD
                           , L.PLANT_SITE_ID
                           , V_TARGET_QTY
                           , M.QTY );

                    V_DEDUCTED_QTY := V_REM_QTY;

                    /* 차감할 수치가 0보다 작은 경우는 더이상 돌리지 않는다 */
                    EXIT WHEN V_DEDUCTED_QTY < 0;
                END LOOP;
            END LOOP;
            N_LOG_COUNT := SQL%ROWCOUNT;

            V_LOG_TYPE    := 'APPEND';
            V_LOG_MESSAGE := 'TARGET DATA6';
            V_DESCRIPTION := '#TEMP_UPDATE_MKT_FCST_적재완료: DIVISION_ID: ' || P_DIVISION_ID;
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            /*------------------------------------------------------------------------------------------------------------------
            -- 6. 5번에서 생성한 데이터로 MKT FCST 테이블에 UPDATE 한다.
            --   (1) 기존수량은 ATTRIBUTE6 에 보관 (2) LAST_UPDATED_BY 는 AUTO_DEDUCTED
            --   (원본 UPDATE A ... FROM A JOIN #TEMP -> MERGE)
            ------------------------------------------------------------------------------------------------------------------*/
            MERGE
             INTO DM_PLN_MKT_FCST A
            USING GT_DM_DEDUCT_UPD B
               ON ( A.DIVISION_ID   = B.DIVISION_ID
                AND A.PROJECT_CODE  = B.PROJECT_CODE
                AND A.SCM_SITE_ID   = B.SCM_SITE_ID
                AND A.ITEM_ID       = B.ITEM_ID
                AND A.DOM_EXP       = B.DOM_EXP
                AND A.FCST_TYPE     = B.FCST_TYPE
                AND A.INCOTERMS     = B.INCOTERMS
                AND A.MEASURE       = B.MEASURE
                AND A.YYYYMMDD      = B.YYYYMMDD
                AND A.PLANT_SITE_ID = B.PLANT_SITE_ID )
             WHEN MATCHED THEN
            UPDATE
               SET A.QTY              = B.QTY
                 , A.ATTRIBUTE6       = B.BEFORE_QTY
                 , A.LAST_UPDATED_BY  = V_BATCH_USER
                 , A.LAST_UPDATE_DATE = SYSDATE;
            N_LOG_COUNT := SQL%ROWCOUNT;

            V_LOG_TYPE    := 'APPEND';
            V_LOG_MESSAGE := 'MKT FCST UPDATE DATA';
            V_DESCRIPTION := 'MKT FCST UPDATE: DIVISION_ID: ' || P_DIVISION_ID;
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        END IF;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;   /* 원본 ROLLBACK TRANSACTION AUTO_DEDUCTED */

            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('[' || SQLCODE || ']' || SQLERRM, 1, 500);
            D_EVENT_DATE  := SYSDATE;

            /* 에러메시지 DISPLAY (원본 CATCH 의 SELECT 결과셋 -> Oracle 암시적 결과셋 불가, 디버그 아티팩트로 주석 보존) */


            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
                               , JSON_OBJECT('P_DIVISION_ID' VALUE P_DIVISION_ID RETURNING VARCHAR2(4000 CHAR))
                               , SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END;

    /*==========================================================================================================================
    -- 종료 LOG (END) - 원본은 TRY/CATCH 바깥에 두어 정상·에러 모두 항상 기록한다.
    ==========================================================================================================================*/
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'MKT FCST UPDATE DATA= ' || TO_CHAR(N_LOG_COUNT);
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);


END PR_DM_PLN_MKT_FCST_DELAY_BILLING_AUTO_DEDUCTED;