PROCEDURE PR_SCP_MST_ITEM_SN_SCP_EXTRA_SPEC_UPDATE
/* ============================================================
 * Program ID   : PR_SCP_MST_ITEM_SN_SCP_EXTRA_SPEC_UPDATE
 * Description  : SCM_MST_ITEM_SN의 SCP_EXTRA_SPEC update
 *              : 매일 x시에 동작함.
 *              : SCP_EXTRA_SPEC이 없으면 Update함
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2022.07.04    sclee.lee      Initial Release PJ20216891 Digital SCM 3 Level 가속화를 위한 개선
 * 2025.02.27    hrkim          PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선
 *                              Cell Assy 모델 extra spec update 대상에 포함
 *                              - 하위 반제품 참조에서  Cell Assy 모델은 제외함
 *                                (반제품 참조시 Cell Assy가 포함되어 '일반'이 아닌데 일반으로 update되는 현상)
 *                              - with 구문을 temp 테이블 사용으로 변경
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    /* LOG 용 변수 설정 */
    V_BATCH_USER    VARCHAR2(150 CHAR) := 'scm_batch';
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SCP_MST_ITEM_SN_SCP_EXTRA_SPEC_UPDATE';
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     NUMBER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;
BEGIN
    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN

        DELETE
          FROM GT_SMISSES_TGT_CELL_MODEL;
        DELETE
          FROM GT_SMISSES_SCP_EXTRA_SPEC_CP;
        DELETE
          FROM GT_SMISSES_TARGET_EXTRA_SPEC;
        DELETE
          FROM GT_SMISSES_TARGET_EXTRA_SPEC_FIANL;

        /* 대상 cell model  - Cell Product */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '대상 cell model  - Cell Product  ');

        INSERT
          INTO GT_SMISSES_TGT_CELL_MODEL
             ( DIVISION_ID
             , MODEL_ID
             , ITEM_CLASS
             , DV
             , CP_ITEM_ID )
        SELECT DISTINCT A.DIVISION_ID
             , A.MODEL_ID
             , A.ITEM_CLASS                            /* 반제품 Item class */
             , 'CP'          AS DV                     /* CP(Cell Product) */
             , A.MODEL_ID    AS CP_ITEM_ID
          FROM (
                SELECT CT.COMPANY_ID
                     , CT.DIVISION_ID
                     , CT.SITE_ID
                     , CT.MODEL_ID
                     , SI.ITEM_CLASS                   /* 반제품 item class */
                     , ROW_NUMBER() OVER (PARTITION BY CT.COMPANY_ID, CT.SITE_ID, CT.MODEL_ID, CT.PLANT_ID
                                          ORDER BY CT.NLEVEL, CT.INSERT_TIME, CT.CHILD_ITEM_ID) RN
                  FROM SCM_MST_ITEM_SN        SI
                     , SCM_MST_BOM_SN         CT
                     , SCP_MST_FINAL_ITEM     C
                     , SCM_MST_ITEM_CLASS_SN  IC
                 WHERE CT.CHILD_ITEM_ID     = SI.ITEM_ID
                   AND CT.CHILD_COMPANY_ID  = SI.COMPANY_ID
                   AND CT.CHILD_DIVISION_ID = SI.DIVISION_ID
                   AND CT.CHILD_SITE_ID     = SI.SITE_ID
                   AND CT.DIVISION_ID       = C.DIVISION_ID
                   AND CT.MODEL_ID          = C.ITEM_ID
                   AND SI.ITEM_CLASS        = IC.CLASS_ID
                   AND CT.DIVISION_ID       = '40'
                   AND NVL(SI.ITEM_TYPE, 'H') IN ('H')
                   AND CT.ALT_PRIORITY      = 'Y'
                   AND C.ITEM_CLASS IN (SELECT B.SEGMENT1              /* model item_class */
                                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                                         WHERE B.LOOKUP_TYPE = 'SCP_EXTRA_SPEC_ITEM_CLASS'
                                           AND B.VALID_YN    = 'Y')
                   AND IC.USE_FLAG          = 'Y'
                   AND NOT EXISTS (SELECT 1                            /* 모델 하위 반제품 Cell Assy 제외 */
                                     FROM SCP_MST_CELL_PROD_ASSY_MAP CA
                                    WHERE CA.DIVISION_ID  = SI.DIVISION_ID
                                      AND CA.ITEM_ID_ASSY = SI.ITEM_ID)
               ) A
         WHERE A.RN = 1;

        /* 대상 cell model  - Cell Assy 추가 (문장시작 읽기일관성으로 현재 GTT의 CP행만 참조) */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '대상 cell model  - Cell Assy 추가 ');

        INSERT
          INTO GT_SMISSES_TGT_CELL_MODEL
             ( DIVISION_ID
             , MODEL_ID
             , ITEM_CLASS
             , DV
             , CP_ITEM_ID )
        SELECT DISTINCT A.DIVISION_ID
             , CA.ITEM_ID_ASSY   AS MODEL_ID
             , A.ITEM_CLASS
             , 'CA'              AS DV                 /* CA(Cell Assy) */
             , A.MODEL_ID        AS CP_ITEM_ID
          FROM GT_SMISSES_TGT_CELL_MODEL      A
             , SCP_MST_CELL_PROD_ASSY_MAP     CA
         WHERE CA.DIVISION_ID  = A.DIVISION_ID
           AND CA.ITEM_ID_PROD = A.MODEL_ID;

        /* 기등록 CP모델의 extra spec 정보 (UI 등에서 기등록된 CP의 extra spec 추출) */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '기등록 CP모델의 extra spec 정보 ');

        INSERT
          INTO GT_SMISSES_SCP_EXTRA_SPEC_CP
             ( DIVISION_ID
             , MODEL_ID
             , DV
             , SCP_EXTRA_SPEC_CP_ASIS )
        SELECT TG.DIVISION_ID
             , TG.MODEL_ID
             , TG.DV
             , MAX(CP.SCP_EXTRA_SPEC)  AS SCP_EXTRA_SPEC_CP_ASIS
          FROM GT_SMISSES_TGT_CELL_MODEL  TG
             , SCM_MST_ITEM_SN            CP
         WHERE CP.DIVISION_ID = TG.DIVISION_ID
           AND CP.ITEM_ID     = TG.CP_ITEM_ID                        /* Cell Product Model */
           AND RTRIM(CP.SCP_EXTRA_SPEC) IS NOT NULL                  /* MSSQL: SCP_EXTRA_SPEC IS NOT NULL AND != '' (공백/빈문자 제외) */
         GROUP BY TG.DIVISION_ID, TG.MODEL_ID, TG.DV;

        /* 소형 대상 모델 with extra spec */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '소형 대상 모델 with extra spec  ');

        INSERT
          INTO GT_SMISSES_TARGET_EXTRA_SPEC
             ( DIVISION_ID
             , MODEL_ID
             , ITEM_CLASS
             , DV
             , CP_ITEM_ID
             , SCP_EXTRA_SPEC_TOBE
             , SCP_EXTRA_SPEC_CP_ASIS )
        SELECT TG.DIVISION_ID
             , TG.MODEL_ID
             , TG.ITEM_CLASS
             , TG.DV
             , TG.CP_ITEM_ID
             , CASE WHEN CP.SCP_EXTRA_SPEC_CP_ASIS IS NOT NULL AND CP.SCP_EXTRA_SPEC_CP_ASIS != '일반' THEN CP.SCP_EXTRA_SPEC_CP_ASIS
                    WHEN TG.ITEM_CLASS = 'ES0801'                                                      THEN 'Stacking'   /* 반제품 ITEM class */
                    WHEN TG.ITEM_CLASS = 'ES1701'                                                      THEN 'ZZS'
                    ELSE '일반'
               END  AS SCP_EXTRA_SPEC_TOBE
             , CP.SCP_EXTRA_SPEC_CP_ASIS
          FROM GT_SMISSES_TGT_CELL_MODEL      TG
             , GT_SMISSES_SCP_EXTRA_SPEC_CP   CP
         WHERE CP.DIVISION_ID(+) = TG.DIVISION_ID
           AND CP.MODEL_ID(+)    = TG.MODEL_ID
           AND CP.DV(+)          = TG.DV;

        /* 소형 최종 update 대상 */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || '소형 최종 update 대상');

        INSERT
          INTO GT_SMISSES_TARGET_EXTRA_SPEC_FIANL
             ( MODEL_ID
             , DIVISION_ID
             , ITEM_CLASS
             , SCP_EXTRA_SPEC_TOBE
             , SCP_EXTRA_SPEC_CP_ASIS
             , SCP_EXTRA_SPEC
             , RN )
        SELECT DISTINCT A.MODEL_ID
             , A.DIVISION_ID
             , A.ITEM_CLASS
             , A.SCP_EXTRA_SPEC_TOBE
             , A.SCP_EXTRA_SPEC_CP_ASIS
             , X.SCP_EXTRA_SPEC
             , ROW_NUMBER() OVER (PARTITION BY A.MODEL_ID, A.DIVISION_ID ORDER BY A.ITEM_CLASS) AS RN
          FROM GT_SMISSES_TARGET_EXTRA_SPEC  A
             , SCM_MST_ITEM_SN               X
         WHERE A.MODEL_ID    = X.ITEM_ID
           AND A.DIVISION_ID = X.DIVISION_ID
           AND (X.SCP_EXTRA_SPEC IS NULL
                OR (X.SCP_EXTRA_SPEC = '일반' AND A.SCP_EXTRA_SPEC_TOBE != '일반'));

        /* SCP_EXTRA_SPEC 업데이트 실행 (원본 UPDATE..FROM JOIN -> MERGE, FT는 RN=1로 (MODEL_ID,DIVISION_ID)당 1행) */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3') || 'SCP_EXTRA_SPEC 업데이트 실행 ');

        MERGE INTO SCM_MST_ITEM_SN TG
        USING (SELECT FT.MODEL_ID
                    , FT.DIVISION_ID
                    , FT.SCP_EXTRA_SPEC_TOBE
                 FROM GT_SMISSES_TARGET_EXTRA_SPEC_FIANL FT
                WHERE FT.RN = 1) FT
           ON (TG.DIVISION_ID = FT.DIVISION_ID AND TG.ITEM_ID = FT.MODEL_ID)
        WHEN MATCHED THEN
          UPDATE SET TG.SCP_EXTRA_SPEC = FT.SCP_EXTRA_SPEC_TOBE
                   , TG.UPDATE_TIME    = SYSDATE
                   , TG.UPDATE_ID      = V_PROGRAM_NAME;

        N_LOG_COUNT := SQL%ROWCOUNT;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            /* ERROR LOG (원본 CATCH: 재던지지 않고 로그만 기록 후 종료 LOG로 진행) */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := 'ERROR_LINE : ' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 400);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END PR_SCP_MST_ITEM_SN_SCP_EXTRA_SPEC_UPDATE;