-- SOURCE-FRESH: SCM_MGR.PR_DM_CUST_MODEL_MAPPING_IF PROCEDURE LAST_DDL=2026-10-15 11:14:13 FETCHED=2026-10-15 11:15 DB=ZIOUI1
-- ROLLBACK 용 원본 (GAP413 적용 전)
CREATE OR REPLACE PROCEDURE PR_DM_CUST_MODEL_MAPPING_IF
(
    P_ACCEPT_FLAG VARCHAR2  /* 업무구분(ERP) */
)
/*============================================================================================================================
    * Program ID   : PR_DM_CUST_MODEL_MAPPING_IF
    * Description  : N:N Model Mapping 데이터 기초값 생성
    * 테이블      : DM_CUST_MODEL_MAPPING_M
    * Program History
    *=============================================================================================================================
    *   Date   In Charge   Description
    *=============================================================================================================================
    * 2024.12.09    KANG.H.J   [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
    * 2025.09.16    JSSBAE         [E20250910-000974]_NN Mapping Master 컬럼 추가 요청
    * 2025.10.22    JSSBAE         [E20251016-001453]_ERP NN Mapping 데이터 반영 수행시간 단축 및 로그 보완
    * 2026.03.22    김준규        [PJ20264226] NextSCM Pilot 설계 및 개발

    PR_DM_CUST_MODEL_MAPPING_IF('ERP');    --ERP만 해당함.
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
    *============================================================================================================================*/
 AS

    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE     VARCHAR2(30 CHAR);
    N_LOG_COUNT    INTEGER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    D_EVENT_DATE   DATE;
    N_DELETE_COUNT INTEGER := 0;
    N_INSERT_COUNT INTEGER := 0;
    V_CREATED_BY   VARCHAR2(150 CHAR) := 'SYS_BATCH_DATA';
    V_DELIMITER    VARCHAR2(1 CHAR);
    V_ACCEPT_FLAG  VARCHAR2(10 CHAR) := P_ACCEPT_FLAG;
    V_CNT          INTEGER := 0;
    V_IF_SEQ       VARCHAR2(50 CHAR);
    V_SEQ          NUMBER(20, 10);
    V_IDX          INTEGER;
    V_CNT_1        INTEGER := 0;
    V_CNT_2        INTEGER := 0;
    V_IN_PARA_DATA VARCHAR2(4000 CHAR);
    CURSOR CUR_XIF_CUST_DEMAND_MAPPING_MST_R IS
        SELECT IF_SEQ
             , SEQ
          FROM XIF_CUST_DEMAND_MAPPING_MST_R_SN
         WHERE TRANSFER_FLAG IN ('N');
    V_CUR_FOUND BOOLEAN;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    /*====================================================================================================
      LOG 용 변수 설정 (START)
      ----------------------------------------------------------------------------------------------------
      LOG 용 변수 설정 (END)
      ====================================================================================================*/

    /*====================================================================================================
      시작 LOG (START)
      ====================================================================================================*/
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
    V_DESCRIPTION := 'PR_DM_CUST_MODEL_MAPPING_IF: ' || P_ACCEPT_FLAG;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_CREATED_BY);
    /*====================================================================================================
      시작 LOG (END)
      ----------------------------------------------------------------------------------------------------
      [E20250910-000974]_NN Mapping Master 컬럼 추가 요청 (START)
      ====================================================================================================*/

    DELETE FROM GT_DCMM_EDI_CALLOFF_ITEM_MAPPI;

    /*====================================================================================================
      [E20250910-000974]_NN Mapping Master 컬럼 추가 요청 (END)
      ====================================================================================================*/
    DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A001--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / ' || P_ACCEPT_FLAG);

    IF V_ACCEPT_FLAG = 'ERP' THEN
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A002--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / ' || P_ACCEPT_FLAG);
        /* ---------------------------------------------------------------------------------------------------
           기 점검시 'X'로 처리된 것을 'N'으로 변환하여 재점검할 수 있도록 조치함.
           --------------------------------------------------------------------------------------------------- */
        UPDATE XIF_CUST_DEMAND_MAPPING_MST_R_SN
           SET TRANSFER_FLAG = 'N'
         WHERE TRANSFER_FLAG = 'X';

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A003--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / ' || P_ACCEPT_FLAG);

        UPDATE XIF_CUST_DEMAND_MAPPING_MST_R_SN X
           SET X.TRANSFER_FLAG = 'X'
         WHERE X.TRANSFER_FLAG = 'N'
           AND NOT EXISTS (  /* 아래 내용은 기준정보가 있기 때문에 이를 제외하고 'X' 처리함. */
               SELECT IF_SEQ
                    , SEQ
                 FROM XIF_CUST_DEMAND_MAPPING_MST_R_SN A
                    , SCM_MST_SITE                     B
                    , SCM_MST_SITE_CUSTOMER            C
                    , SCM_MST_SITE_ITEM                D
                    , SCM_ADM_LOOKUP_MASTER_DETAIL     E
                WHERE A.DIVISION_ID = B.DIVISION_ID
                  AND B.VALID_YN = 'Y'
                  AND A.DIVISION_ID = C.DIVISION_ID
                  AND B.SCM_SITE_ID = C.SCM_SITE_ID
                  AND A.SOLDTO_CODE = C.SOLDTO_CODE
                  AND A.SHIPTO_CODE = C.SHIPTO_CODE
                  AND C.VALID_YN = 'Y'
                  AND A.DIVISION_ID = C.DIVISION_ID
                  AND B.SCM_SITE_ID = D.SCM_SITE_ID
                  AND A.ITEM_ID = D.ITEM_ID
                  AND NVL(D.ATTRIBUTE6, NULL) IS NOT NULL   /* 2025.01.10 Philsu Park: Incoterms 등록되어 있어야 함. */
                  AND NVL(D.SALES_PLANT, NULL) IS NOT NULL  /* 2025.01.10 Philsu Park: Plant Site 등록되어 있어야 함. */
                  AND A.ERP_SA_ORG_ID = E.SEGMENT1
                  AND E.LOOKUP_TYPE = 'DM_EDI_COMPANY_DIVISION_MAPPING'
                  AND E.SEGMENT3 = 'Y'
                  AND TRANSFER_FLAG IN ('N')
                  AND A.IF_SEQ = X.IF_SEQ
                  AND A.SEQ = X.SEQ);

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A004--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / ' || P_ACCEPT_FLAG);

        V_IDX := 0;

        /*           WHERE TRANSFER_FLAG IN ('N'); -- 'X'는 기준정보가 없는 모델이라 적재필요성 없음. */

        OPEN CUR_XIF_CUST_DEMAND_MAPPING_MST_R;

        FETCH CUR_XIF_CUST_DEMAND_MAPPING_MST_R
            INTO V_IF_SEQ, V_SEQ;

        WHILE (CUR_XIF_CUST_DEMAND_MAPPING_MST_R%FOUND) LOOP
            BEGIN
                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A005--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / ' || P_ACCEPT_FLAG);

                UPDATE XIF_CUST_DEMAND_MAPPING_MST_R_SN
                   SET TRANSFER_FLAG = 'P'
                 WHERE IF_SEQ = V_IF_SEQ
                   AND SEQ = V_SEQ;


                MERGE INTO DM_CUST_MODEL_MAPPING_M A
                USING (SELECT 'ERP' AS DATA_TYPE_CODE
                            , E.SEGMENT2 DIVISION_ID  /* A.DIVISION_ID (81로만 오기 때문에 / JOINT VENTURE 고려 필요함.) */
                            , A.ERP_SA_ORG_ID COMPANY_ID
                            , A.SOLDTO_CODE
                            , A.SHIPTO_CODE
                            , NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), NULL) UNLOADING_POINT
                            , SUBSTR(NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), NULL), 1, 4) CUSTOMER_PLANT
                            , NVL(RTRIM(LTRIM(A.CUST_MATERIAL_CODE)), NULL) CUST_MATERIAL_CODE
                            , B.END_CUSTOMER END_CUSTOMER
                            , B.SCM_SITE_ID
                            , D.PROJECT_CODE
                            , 'MPS' AS FCST_TYPE
                            , D.ATTRIBUTE6 INCOTERMS
                            , 'E' AS DOM_EXP
                            , A.ITEM_ID
                            , A.VALID_FROM_DATE VALID_START_DATE
                            , A.VALID_TO_DATE VALID_END_DATE
                            , 'Y' AS ACTIVE_YN
                            , V_PROGRAM_NAME CREATED_BY
                            , SYSDATE CREATION_DATE
                            , V_PROGRAM_NAME LAST_UPDATED_BY
                            , SYSDATE LAST_UPDATE_DATE
                         /* IF_SEQ, SEQ 기준으로 1건만. USING 절에서 오류 방지. 2026.08.19. 자이오넥스 홍성대 */
                         /* FROM XIF_CUST_DEMAND_MAPPING_MST_R_SN A */
                         FROM (SELECT A.*
                                    , ROW_NUMBER() OVER (PARTITION BY A.IF_SEQ, A.SEQ
                                                             ORDER BY A.TRANSFER_DATE DESC) AS ROW_NUMS
                                 FROM XIF_CUST_DEMAND_MAPPING_MST_R_SN A) A
                            /* ---------------------------------------------------------------------------------------------------------------------------------------
                               [E20250910-000974]_JV가 받아들여지려면 해당 부분으로 수정해야함 위치변경 (START)
                               ---------------------------------------------------------------------------------------------------------------------------------------
                               [E20250910-000974]_JV가 받아들여지려면 해당 부분으로 수정해야함 위치변경 (END)
                               --------------------------------------------------------------------------------------------------------------------------------------- */
                            , SCM_ADM_LOOKUP_MASTER_DETAIL         E
                            , SCM_MST_SITE                         B
                            , SCM_MST_SITE_CUSTOMER                C
                            , SCM_MST_SITE_ITEM                    D
                        WHERE A.ERP_SA_ORG_ID = E.SEGMENT1
                          AND E.LOOKUP_TYPE = 'DM_EDI_COMPANY_DIVISION_MAPPING'
                          AND E.SEGMENT3 = 'Y'
                          AND E.SEGMENT2 = B.DIVISION_ID  /* [E20250910-000974]_변경 (구: A.DIVISION_ID = B.DIVISION_ID 주석처리) */
                          AND B.VALID_YN = 'Y'
                          AND E.SEGMENT2 = C.DIVISION_ID  /* [E20250910-000974]_변경 (구: A.DIVISION_ID = C.DIVISION_ID 주석처리) */
                          AND B.SCM_SITE_ID = C.SCM_SITE_ID
                          AND A.SOLDTO_CODE = C.SOLDTO_CODE
                          AND A.SHIPTO_CODE = C.SHIPTO_CODE
                          AND C.VALID_YN = 'Y'
                          /* AND C.REP_YN = 'Y' */
                          AND E.SEGMENT2 = D.DIVISION_ID  /* [E20250910-000974]_변경 (구: A.DIVISION_ID = D.DIVISION_ID 주석처리) */
                          AND B.SCM_SITE_ID = D.SCM_SITE_ID
                          AND A.ITEM_ID = D.ITEM_ID
                          AND NVL(D.ATTRIBUTE6, NULL) IS NOT NULL   /* 2025.01.10 Philsu Park: Incoterms 등록되어 있어야 함. */
                          AND NVL(D.SALES_PLANT, NULL) IS NOT NULL  /* 2025.01.10 Philsu Park: Plant Site 등록되어 있어야 함. */
                          AND A.TRANSFER_FLAG = 'P'
                          AND A.IF_SEQ = V_IF_SEQ
                          AND A.SEQ = V_SEQ
                          /* IF_SEQ, SEQ 기준으로 1건만. USING 절에서 오류 방지. 2026.08.19. 자이오넥스 홍성대 */
                          AND A.ROW_NUMS = 1) B
                ON (A.DATA_TYPE_CODE = B.DATA_TYPE_CODE
                AND A.DIVISION_ID = B.DIVISION_ID
                AND A.COMPANY_ID = B.COMPANY_ID
                AND A.SOLDTO_CODE = B.SOLDTO_CODE
                AND A.SHIPTO_CODE = B.SHIPTO_CODE
                AND NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), ' ') = NVL(RTRIM(LTRIM(B.UNLOADING_POINT)), ' ')
                AND NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), ' ') = NVL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), ' ')
                AND NVL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)), ' ') = NVL(RTRIM(LTRIM(B.CUST_MATERIAL_CODE)), ' ')
                AND A.SCM_SITE_ID = B.SCM_SITE_ID
                AND A.PROJECT_CODE = B.PROJECT_CODE
                AND A.FCST_TYPE = B.FCST_TYPE
                AND A.INCOTERMS = B.INCOTERMS
                AND A.DOM_EXP = B.DOM_EXP
                AND A.ITEM_ID = B.ITEM_ID)
                WHEN MATCHED THEN
                    UPDATE
                       SET A.END_CUSTOMER     = B.END_CUSTOMER
                         , A.VALID_START_DATE = B.VALID_START_DATE
                         , A.VALID_END_DATE   = B.VALID_END_DATE
                         , A.ACTIVE_YN        = B.ACTIVE_YN
                         , A.LAST_UPDATED_BY  = V_PROGRAM_NAME
                         , A.LAST_UPDATE_DATE = SYSDATE
                WHEN NOT MATCHED THEN
                    INSERT
                        ( DATA_TYPE_CODE
                        , DIVISION_ID
                        , COMPANY_ID
                        , SOLDTO_CODE
                        , SHIPTO_CODE
                        , UNLOADING_POINT
                        , CUSTOMER_PLANT
                        , CUSTOMER_ITEM_ID
                        , END_CUSTOMER
                        , SCM_SITE_ID
                        , PROJECT_CODE
                        , FCST_TYPE
                        , INCOTERMS
                        , DOM_EXP
                        , ITEM_ID
                        , MAPPING_ITEM_ID
                        , VALID_START_DATE
                        , VALID_END_DATE
                        , ACTIVE_YN
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE )
                    VALUES
                        ( B.DATA_TYPE_CODE
                        , B.DIVISION_ID
                        , B.COMPANY_ID
                        , B.SOLDTO_CODE
                        , B.SHIPTO_CODE
                        , B.UNLOADING_POINT
                        , B.CUSTOMER_PLANT
                        , B.CUST_MATERIAL_CODE
                        , B.END_CUSTOMER
                        , B.SCM_SITE_ID
                        , B.PROJECT_CODE
                        , B.FCST_TYPE
                        , B.INCOTERMS
                        , B.DOM_EXP
                        , B.ITEM_ID
                        , B.ITEM_ID
                        , B.VALID_START_DATE
                        , B.VALID_END_DATE
                        , B.ACTIVE_YN
                        , B.CREATED_BY
                        , B.CREATION_DATE
                        , B.LAST_UPDATED_BY
                        , B.LAST_UPDATE_DATE );

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A007--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / ' || P_ACCEPT_FLAG);

                UPDATE XIF_CUST_DEMAND_MAPPING_MST_R_SN
                   SET TRANSFER_FLAG = 'Y'
                 WHERE IF_SEQ = V_IF_SEQ
                   AND SEQ = V_SEQ;


            EXCEPTION
                WHEN OTHERS THEN
                    /* ---------------------------------------------------------------------------------------------------
                       DM_CUST_MODEL_MAPPING_M에 MERGE 실패할 경우 X로 업데이트하여 정리함.
                       --------------------------------------------------------------------------------------------------- */
                    UPDATE XIF_CUST_DEMAND_MAPPING_MST_R_SN
                       SET TRANSFER_FLAG = 'X'
                     WHERE IF_SEQ = V_IF_SEQ
                       AND SEQ = V_SEQ;

                    DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A008--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / ' || P_ACCEPT_FLAG);

                    /*====================================================================================================
                      ERROR LOG (START)
                      ====================================================================================================*/
                    V_LOG_TYPE    := 'ERROR';
                    V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
                    V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    /*====================================================================================================
                      ERROR LOG (END)
                      ====================================================================================================*/
                    DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A009--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / ' || P_ACCEPT_FLAG);


            END;
            FETCH CUR_XIF_CUST_DEMAND_MAPPING_MST_R
                INTO V_IF_SEQ, V_SEQ;
        END LOOP;
        /* ---------------------------------------------------------------------------------------------------------------------------------------
           [E20251016-001453]_위치 변경 (START)
           ---------------------------------------------------------------------------------------------------------------------------------------
           [E20250910-000974]_NN Mapping Master 컬럼 추가 요청 (START)
           --------------------------------------------------------------------------------------------------------------------------------------- */
        SELECT COUNT(*)
          INTO V_CNT_1
          FROM DM_DNM_EDI_CALLOFF_ITEM
         WHERE NVL(DC_LEVEL, NULL) IS NOT NULL;
        IF V_CNT_1 > 0 THEN
            INSERT
              INTO GT_DCMM_EDI_CALLOFF_ITEM_MAPPI
                ( DIVISION_ID
                , COMPANY_ID
                , SOLDTO_CODE
                , SHIPTO_CODE
                , UNLOADING_POINT
                , CUSTOMER_PLANT
                , CUST_MATERIAL_CODE
                , SCM_SITE_ID
                , PROJECT_CODE
                , ITEM_ID
                , DC_LEVEL )
                SELECT A.DIVISION_ID
                     , A.COMPANY_ID
                     , A.SOLDTO_CODE
                     , A.SHIPTO_CODE
                     , A.UNLOADING_POINT
                     , A.CUSTOMER_PLANT
                     , A.CUST_MATERIAL_CODE
                     , A.SCM_SITE_ID
                     , A.PROJECT_CODE
                     , A.ITEM_ID
                     , A.DC_LEVEL
                  FROM (SELECT DIVISION_ID
                             , COMPANY_ID
                             , SOLDTO_CODE
                             , SHIPTO_CODE
                             , UNLOADING_POINT
                             , CUSTOMER_PLANT
                             , CUST_MATERIAL_CODE
                             , SCM_SITE_ID
                             , PROJECT_CODE
                             , ITEM_ID
                             , DC_LEVEL
                             , ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT, CUSTOMER_PLANT, CUST_MATERIAL_CODE, SCM_SITE_ID, PROJECT_CODE, ITEM_ID ORDER BY IFSEQNO DESC) ROW_NUMS
                          FROM DM_DNM_EDI_CALLOFF_ITEM
                         WHERE NVL(DC_LEVEL, NULL) IS NOT NULL) A
                 WHERE A.ROW_NUMS = 1;

            SELECT COUNT(*)
              INTO V_CNT_2
              FROM GT_DCMM_EDI_CALLOFF_ITEM_MAPPI;
            IF V_CNT_2 > 0 THEN
                MERGE INTO DM_CUST_MODEL_MAPPING_M A
                USING (SELECT *
                         FROM GT_DCMM_EDI_CALLOFF_ITEM_MAPPI) B
                ON (A.DIVISION_ID = B.DIVISION_ID
                AND A.COMPANY_ID = B.COMPANY_ID
                AND A.SOLDTO_CODE = B.SOLDTO_CODE
                AND A.SHIPTO_CODE = B.SHIPTO_CODE
                AND NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), ' ') = NVL(RTRIM(LTRIM(B.UNLOADING_POINT)), ' ')
                AND NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), ' ') = NVL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), ' ')
                AND NVL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)), ' ') = NVL(RTRIM(LTRIM(B.CUST_MATERIAL_CODE)), ' ')
                AND A.SCM_SITE_ID = B.SCM_SITE_ID
                AND A.PROJECT_CODE = B.PROJECT_CODE
                AND A.ITEM_ID = B.ITEM_ID)
                WHEN MATCHED THEN
                    UPDATE
                       SET A.DC_LEVEL = B.DC_LEVEL;
            END IF;
        END IF;

        /* ---------------------------------------------------------------------------------------------------------------------------------------
           [E20250910-000974]_NN Mapping Master 컬럼 추가 요청 (END)
           ---------------------------------------------------------------------------------------------------------------------------------------
           [E20251016-001453]_위치 변경 (END)
           --------------------------------------------------------------------------------------------------------------------------------------- */
        CLOSE CUR_XIF_CUST_DEMAND_MAPPING_MST_R;

    END IF;

    /*====================================================================================================
      종료 LOG (START)
      ====================================================================================================*/
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;

    PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_CREATED_BY);
    /*====================================================================================================
      종료 LOG (END)
      ====================================================================================================*/
    DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A010--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || ' / ' || P_ACCEPT_FLAG);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
