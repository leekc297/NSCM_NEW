PROCEDURE           "PR_DM_LONGPLAN_40_RESTORE" 
(
      P_DIVISION_ID    IN VARCHAR2
    , P_MF_VERSION_NO  IN VARCHAR2
)
/*
 * Program ID   : PR_DM_LONGPLAN_40_RESTORE (소형 중장기계획용 - 데이터 원복 MF/SP)
 * Called by    : 필요에 의해 직접 수행(수동 유틸리티)
 * 변환(MSSQL->Oracle) 2026-07-01 SCMADM : 구 기계번역 파손(BEGIN TRY·본문중DECLARE·SELECT= INTO누락·INSERT INTO중복·EXEC괄호·ISDATE) 전면 재작성
 *   - 검증 SELECT 결과셋 3종 → COUNT INTO + DBMS_OUTPUT(수동 유틸, H-9)
 *   - RAISERROR(sev16)+TRY/CATCH(비재발생) → RAISE_APPLICATION_ERROR + EXCEPTION WHEN OTHERS(swallow+log, 원본동등)
 *   - ISDATE(x)<1 → NULL체크 + TO_DATE 검증블록.  MSSQL autocommit → 복원 후 COMMIT
 *   - 의존 co-call: PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(SP 재계산)
 * Date			: 2021.08.06
 * 2021.08.06	HWI1993			최초생성
 * 2022.11.25	HWI1993			검증 스크립트 추가
 * 2025.08.19	jssbae			[E20250818-000190]_소형사업부 사업계획 수립 지원을 위한 Biz Plan → FCST&PRICE MGMT 동기화 기능 개발
 * 2026.07.06	ZIONEX		[PJ202650304] NextSCM Migration
 */
AS
    V_PROGRAM_NAME             VARCHAR2(150 CHAR) := 'PR_DM_LONGPLAN_40_RESTORE_1024';
    V_LOG_TYPE                 VARCHAR2(30 CHAR);
    N_LOG_COUNT                INTEGER := 0;
    V_LOG_MESSAGE              VARCHAR2(1000 CHAR);
    V_DESCRIPTION              VARCHAR2(500 CHAR);
    V_ERRMSG                   VARCHAR2(1000 CHAR);
    D_EVENT_DATE               DATE;
    V_RESTRICT_START_YYYYMMDD  VARCHAR2(8 CHAR);
    V_RESTRICT_END_YYYYMMDD    VARCHAR2(8 CHAR);
    V_RESTRICT_END_YYYYMM      VARCHAR2(6 CHAR);
    V_SP_VERSION_NO            VARCHAR2(50 CHAR);
    V_DUMMY                    DATE;
    V_CNT                      NUMBER;
BEGIN
    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := 'p_division_id :' || P_DIVISION_ID || '/p_mf_version_no :' || P_MF_VERSION_NO || '/소형 중장기';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;

    BEGIN

        SELECT MAX(ATTRIBUTE1)
             , MAX(ATTRIBUTE2)
             , MAX(SUBSTR(ATTRIBUTE2, 1, 6))
          INTO V_RESTRICT_START_YYYYMMDD
             , V_RESTRICT_END_YYYYMMDD
             , V_RESTRICT_END_YYYYMM
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'DM_LONG_PLAN_START_YYYYMMDD'
           AND SEGMENT1 = P_DIVISION_ID
           AND VALID_YN = 'Y';


        IF V_RESTRICT_START_YYYYMMDD IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, '입력제한 일자가 설정되지 않았습니다.');
        END IF;
        BEGIN
            V_DUMMY := TO_DATE(V_RESTRICT_START_YYYYMMDD, 'YYYYMMDD');
        EXCEPTION WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '입력제한 일자가 설정되지 않았습니다.');
        END;


        IF V_RESTRICT_END_YYYYMMDD IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, '입력제한 종료일자가 설정되지 않았습니다.');
        END IF;
        BEGIN
            V_DUMMY := TO_DATE(V_RESTRICT_END_YYYYMMDD, 'YYYYMMDD');
        EXCEPTION WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '입력제한 종료일자가 설정되지 않았습니다.');
        END;

        /* 2. SALES PLAN VERSION 확인 */
        SELECT MAX(B.VERSION_NO)
          INTO V_SP_VERSION_NO
          FROM DM_MST_VERSION A
             , DM_MST_VERSION B
         WHERE A.YYYYMMDD = B.YYYYMMDD
           AND A.DIVISION_ID = B.DIVISION_ID
           AND A.VER_CRE_SEQ = B.VER_CRE_SEQ
           AND B.VERSION_TYPE = 'SP_M'
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.VERSION_NO = P_MF_VERSION_NO;

        IF V_SP_VERSION_NO IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'SP VERSION 을 못찾았습니다.');
        END IF;


        DELETE
          FROM DM_PLN_MKT_FCST
         WHERE DIVISION_ID = P_DIVISION_ID
           AND YYYYMMDD >= V_RESTRICT_START_YYYYMMDD
           AND YYYYMMDD <= V_RESTRICT_END_YYYYMMDD;

        DELETE
          FROM DM_PLN_CFM_MKT_DEMAND_PLAN
         WHERE DIVISION_ID = P_DIVISION_ID
           AND YYYYMMDD >= V_RESTRICT_START_YYYYMMDD
           AND YYYYMMDD <= V_RESTRICT_END_YYYYMMDD;

        /* 4. 백업(_C) CUTOFF 데이터로 복원 */
        INSERT
          INTO DM_PLN_MKT_FCST
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , QTY
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
             , ATTRIBUTE10 )
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
             , A.QTY
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
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
          FROM DM_PLN_MKT_FCST_C A
         WHERE A.DIVISION_ID = P_DIVISION_ID
           AND A.YYYYMMDD >= V_RESTRICT_START_YYYYMMDD
           AND A.YYYYMMDD <= V_RESTRICT_END_YYYYMMDD
           AND A.VERSION_NO = P_MF_VERSION_NO;

        INSERT
          INTO DM_PLN_CFM_MKT_DEMAND_PLAN
             ( DIVISION_ID
             , PROJECT_CODE
             , END_CUSTOMER
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID
             , YYYYMMDD
             , QTY
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
             , ATTRIBUTE10 )
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
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
          FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
         WHERE A.DIVISION_ID = P_DIVISION_ID
           AND A.YYYYMMDD >= V_RESTRICT_START_YYYYMMDD
           AND A.YYYYMMDD <= V_RESTRICT_END_YYYYMMDD
           AND A.VERSION_NO = P_MF_VERSION_NO;

        COMMIT;

        /* 5. SP 재계산 */
        PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(P_DIVISION_ID, 'SYSTEM');


        SELECT COUNT(*)
          INTO V_CNT
          FROM (SELECT DIVISION_ID
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , YYYYMMDD
                     , QTY
                  FROM DM_PLN_MKT_FCST_C
                 WHERE VERSION_NO = P_MF_VERSION_NO
                   AND DIVISION_ID = P_DIVISION_ID
                   AND YYYYMMDD >= V_RESTRICT_START_YYYYMMDD
                   AND YYYYMMDD <= V_RESTRICT_END_YYYYMMDD
                   AND QTY <> 0
                 GROUP BY DIVISION_ID
                        , PROJECT_CODE
                        , SCM_SITE_ID
                        , ITEM_ID
                        , DOM_EXP
                        , FCST_TYPE
                        , INCOTERMS
                        , MEASURE
                        , PLANT_SITE_ID
                        , YYYYMMDD
                        , QTY) A
     FULL OUTER JOIN (SELECT DIVISION_ID
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
                        FROM DM_PLN_MKT_FCST
                       WHERE DIVISION_ID = P_DIVISION_ID
                         AND YYYYMMDD >= V_RESTRICT_START_YYYYMMDD
                         AND YYYYMMDD <= V_RESTRICT_END_YYYYMMDD
                         AND QTY <> 0
                       GROUP BY DIVISION_ID
                              , PROJECT_CODE
                              , SCM_SITE_ID
                              , ITEM_ID
                              , DOM_EXP
                              , FCST_TYPE
                              , INCOTERMS
                              , MEASURE
                              , YYYYMMDD
                              , PLANT_SITE_ID
                              , QTY) B
                    ON A.DIVISION_ID = B.DIVISION_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.DOM_EXP = B.DOM_EXP
                   AND A.FCST_TYPE = B.FCST_TYPE
                   AND A.INCOTERMS = B.INCOTERMS
                   AND A.MEASURE = B.MEASURE
                   AND A.YYYYMMDD = B.YYYYMMDD
                   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
         WHERE ((A.QTY <> B.QTY) OR (A.DIVISION_ID IS NULL) OR (B.DIVISION_ID IS NULL));
        DBMS_OUTPUT.PUT_LINE('DM_PLN_MKT_FCST_C vs DM_PLN_MKT_FCST DIFF 건 : ' || V_CNT);

        SELECT COUNT(*)
          INTO V_CNT
          FROM (SELECT DIVISION_ID
                     , PROJECT_CODE
                     , END_CUSTOMER
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , YYYYMMDD
                     , CELL_PROD_SITE_ID
                     , QTY
                  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
                 WHERE VERSION_NO = P_MF_VERSION_NO
                   AND DIVISION_ID = P_DIVISION_ID
                   AND YYYYMMDD >= V_RESTRICT_START_YYYYMMDD
                   AND YYYYMMDD <= V_RESTRICT_END_YYYYMMDD
                   AND QTY <> 0
                 GROUP BY DIVISION_ID
                        , PROJECT_CODE
                        , END_CUSTOMER
                        , SCM_SITE_ID
                        , ITEM_ID
                        , DOM_EXP
                        , FCST_TYPE
                        , INCOTERMS
                        , MEASURE
                        , PLANT_SITE_ID
                        , YYYYMMDD
                        , CELL_PROD_SITE_ID
                        , QTY) A
     FULL OUTER JOIN (SELECT DIVISION_ID
                           , PROJECT_CODE
                           , END_CUSTOMER
                           , SCM_SITE_ID
                           , ITEM_ID
                           , DOM_EXP
                           , FCST_TYPE
                           , INCOTERMS
                           , MEASURE
                           , PLANT_SITE_ID
                           , YYYYMMDD
                           , CELL_PROD_SITE_ID
                           , QTY
                        FROM DM_PLN_CFM_MKT_DEMAND_PLAN
                       WHERE DIVISION_ID = P_DIVISION_ID
                         AND YYYYMMDD >= V_RESTRICT_START_YYYYMMDD
                         AND YYYYMMDD <= V_RESTRICT_END_YYYYMMDD
                         AND QTY <> 0
                       GROUP BY DIVISION_ID
                              , PROJECT_CODE
                              , END_CUSTOMER
                              , SCM_SITE_ID
                              , ITEM_ID
                              , DOM_EXP
                              , FCST_TYPE
                              , INCOTERMS
                              , MEASURE
                              , PLANT_SITE_ID
                              , YYYYMMDD
                              , CELL_PROD_SITE_ID
                              , QTY) B
                    ON A.DIVISION_ID = B.DIVISION_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND A.END_CUSTOMER = B.END_CUSTOMER
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.DOM_EXP = B.DOM_EXP
                   AND A.FCST_TYPE = B.FCST_TYPE
                   AND A.INCOTERMS = B.INCOTERMS
                   AND A.MEASURE = B.MEASURE
                   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                   AND A.YYYYMMDD = B.YYYYMMDD
                   AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
         WHERE ((A.QTY <> B.QTY) OR (A.DIVISION_ID IS NULL) OR (B.DIVISION_ID IS NULL));
        DBMS_OUTPUT.PUT_LINE('DM_PLN_CFM_MKT_DEMAND_PLAN_C vs DM_PLN_CFM_MKT_DEMAND_PLAN DIFF 건 : ' || V_CNT);

        SELECT COUNT(*)
          INTO V_CNT
          FROM (SELECT DIVISION_ID
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , YYYYMMDD
                     , CELL_PROD_SITE_ID
                     , QTY
                  FROM DM_PLN_SALES_PLAN_C
                 WHERE VERSION_NO = V_SP_VERSION_NO
                   AND DIVISION_ID = P_DIVISION_ID
                   AND YYYYMMDD >= V_RESTRICT_START_YYYYMMDD
                   AND YYYYMMDD <= V_RESTRICT_END_YYYYMMDD
                   AND QTY <> 0
                 GROUP BY DIVISION_ID
                        , PROJECT_CODE
                        , SCM_SITE_ID
                        , ITEM_ID
                        , DOM_EXP
                        , FCST_TYPE
                        , INCOTERMS
                        , MEASURE
                        , PLANT_SITE_ID
                        , YYYYMMDD
                        , CELL_PROD_SITE_ID
                        , QTY) A
     FULL OUTER JOIN (SELECT DIVISION_ID
                           , PROJECT_CODE
                           , SCM_SITE_ID
                           , ITEM_ID
                           , DOM_EXP
                           , FCST_TYPE
                           , INCOTERMS
                           , MEASURE
                           , PLANT_SITE_ID
                           , YYYYMMDD
                           , CELL_PROD_SITE_ID
                           , QTY
                        FROM DM_PLN_SALES_PLAN
                       WHERE DIVISION_ID = P_DIVISION_ID
                         AND YYYYMMDD >= V_RESTRICT_START_YYYYMMDD
                         AND YYYYMMDD <= V_RESTRICT_END_YYYYMMDD
                         AND QTY <> 0
                       GROUP BY DIVISION_ID
                              , PROJECT_CODE
                              , SCM_SITE_ID
                              , ITEM_ID
                              , DOM_EXP
                              , FCST_TYPE
                              , INCOTERMS
                              , MEASURE
                              , PLANT_SITE_ID
                              , YYYYMMDD
                              , CELL_PROD_SITE_ID
                              , QTY) B
                    ON A.DIVISION_ID = B.DIVISION_ID
                   AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   AND A.ITEM_ID = B.ITEM_ID
                   AND A.DOM_EXP = B.DOM_EXP
                   AND A.FCST_TYPE = B.FCST_TYPE
                   AND A.INCOTERMS = B.INCOTERMS
                   AND A.MEASURE = B.MEASURE
                   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                   AND A.YYYYMMDD = B.YYYYMMDD
                   AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
         WHERE ((A.QTY <> B.QTY) OR (A.DIVISION_ID IS NULL) OR (B.DIVISION_ID IS NULL));
        DBMS_OUTPUT.PUT_LINE('DM_PLN_SALES_PLAN_C vs DM_PLN_SALES_PLAN DIFF 건 : ' || V_CNT);

    EXCEPTION
        WHEN OTHERS THEN
            V_ERRMSG      := SUBSTR(SQLERRM, 1, 1000);
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := V_ERRMSG;
            V_DESCRIPTION := 'ERROR_LINE : ' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 400);
            D_EVENT_DATE  := SYSDATE;
            DBMS_OUTPUT.PUT_LINE('[' || TO_CHAR(SQLCODE) || ']' || V_ERRMSG);
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'p_division_id :' || P_DIVISION_ID || '/p_mf_version_no :' || P_MF_VERSION_NO
                     || '/ V_RESTRICT_START_YYYYMMDD :' || V_RESTRICT_START_YYYYMMDD || '/ 소형 중장기';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
END PR_DM_LONGPLAN_40_RESTORE;