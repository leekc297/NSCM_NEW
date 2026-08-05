PROCEDURE PR_SSP_ANL_ESS_REQ
(
      P_DM_REQ_NO    IN VARCHAR2
    , P_DIVISION_ID  IN VARCHAR2
    , R_ERROR_MSG    OUT VARCHAR2
)
/* ==================================================================================================
 * Program ID   : PR_SSP_ANL_ESS_REQ
 * Description  : PLAN ALL
 * OutTable     :
 * Execute      : EXEC PR_SSP_ANL_ESS_REQ
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 *   20210317   SSP Pjt.       Create
 *   20241001   KHJ            NERP_SSP
 *   2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
 * ================================================================================================== */
AS

    /* LOG 용 변수 설정 */
    V_BATCH_USER                VARCHAR2(150 CHAR) := 'ssp_batch';

    V_PROGRAM_NAME                VARCHAR2(150 CHAR) := 'PR_SSP_ANL_ESS_REQ';
    V_LOG_TYPE                    VARCHAR2(30 CHAR);
    N_LOG_COUNT                    INTEGER := 0;
    V_LOG_MESSAGE                VARCHAR2(1000 CHAR);
    V_DESCRIPTION                VARCHAR2(500 CHAR);                       /* ▶ 상세설명 */
    V_TABLE_ID                    VARCHAR2(150 CHAR) := 'SSP_ANL_ESS_REQ'; /* ▶ 테이블 필수 */
    D_EVENT_DATE                TIMESTAMP ;

    DM_REQ_CNT                    INTEGER := 0;
    V_DIVISION_ID               VARCHAR2(10 CHAR);
    V_DM_REQ_NO                    VARCHAR2(60 CHAR) := '';

    V_START_TIME                TIMESTAMP := SYSTIMESTAMP;
    V_EXEC_TIME                    VARCHAR2(10 CHAR) := '';

    /* AS-IS에서 BEGIN ~ END 구간내 선언 했던 변수들 */
    INX                            INTEGER;
    MAX_NUM                        INTEGER;
    DM_REQ_NO                    VARCHAR2(60 CHAR);
    ITEM_ID                        VARCHAR2(50 CHAR);
    DIVISION_ID                    VARCHAR2(10 CHAR);
    PROJECT_CODE                VARCHAR2(50 CHAR);
    SCM_SITE_ID                    VARCHAR2(50 CHAR);
    PLANT_SITE_ID                VARCHAR2(50 CHAR);
    DOM_EXP                        VARCHAR2(6 CHAR);
    FCST_TYPE                    VARCHAR2(50 CHAR);
    INCOTERMS                    VARCHAR2(20 CHAR);
    V_YYYYMMDD                    VARCHAR2(8 CHAR); /* 열의 정의가 애매하는 컴파일 에러로 인하여 V_붙임 */
    PLAN_QTY                    NUMBER(20, 10);
    DM_REQUEST_DATE                TIMESTAMP;

    BEFORE_DM_REQ_NO            VARCHAR2(60 CHAR);
    BEFORE_ITEM_ID                VARCHAR2(50 CHAR);
    BEFORE_PLAN_QTY                NUMBER(20, 10);
    /* 오라클 프로시저에서는 리턴값을 줄수 없다. */
    /* v_return                    INTEGER; */

    /* NERP 매핑코드 */
    V_KR012031                     VARCHAR2(20 CHAR);
BEGIN

    /* GT_PRSSP_ANL_ESS_REQ 초기화 */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSSP_ANL_ESS_REQ';

    V_KR012031 := FN_GET_LOOKUP_VALUE('PR_SSP_ANL_ESS_REQ', 'KR012031P');

    IF P_DIVISION_ID IS NULL THEN
        V_DIVISION_ID := '82';
    ELSE
        V_DIVISION_ID := P_DIVISION_ID;
    END IF;

    IF P_DM_REQ_NO IS NULL THEN
        RETURN;
    ELSE
        V_DM_REQ_NO := P_DM_REQ_NO;

        SELECT COUNT(*)
          INTO DM_REQ_CNT
          FROM (SELECT REQUEST_NO
                     , ITEM_ID
                  FROM DM_PLN_PR_DETAIL
                 WHERE 1 = 1
                   AND REQUEST_NO = V_DM_REQ_NO
                 GROUP BY REQUEST_NO
                        , ITEM_ID
                HAVING COUNT(*) > 1
               ) C;

        IF DM_REQ_CNT > 0 THEN
            R_ERROR_MSG := 'Duplicated ITEM. REQUEST NO : ' ||V_DM_REQ_NO;
            RETURN;
        END IF;

        SELECT COUNT(ITEM_ID)
          INTO DM_REQ_CNT
          FROM SSP_ANL_ESS_REQ
         WHERE DM_REQ_NO = V_DM_REQ_NO;

        IF DM_REQ_CNT > 0 THEN
            R_ERROR_MSG := 'Already requested. REQUEST NO : ' ||V_DM_REQ_NO;
            RETURN;
        END IF;

        /* B.FROM_SITE(+) 원본 주석: CASE WHEN A.PLANT_SITE_ID IS NULL OR A.PLANT_SITE_ID = '' THEN 'KR012031-P' ELSE A.PLANT_SITE_ID END */
        SELECT COUNT(*)
          INTO DM_REQ_CNT
          FROM DM_PLN_PR_DETAIL A
             , SCP_MST_BOD_V    B
         WHERE 1 = 1
           AND B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.FROM_SITE(+) = CASE
                                    WHEN A.PLANT_SITE_ID IS NULL OR A.PLANT_SITE_ID = '' THEN V_KR012031
                                    ELSE A.PLANT_SITE_ID
                                END
           AND B.TO_SITE(+) = A.SCM_SITE_ID
           AND B.INCOTERMS(+) = A.INCOTERMS
           AND B.BOD_VALID_YN(+) = 'Y'
           AND A.REQUEST_NO = V_DM_REQ_NO
           AND B.BOD_ID IS NULL;

        IF DM_REQ_CNT > 0 THEN
            R_ERROR_MSG := 'No BOD referenced in SSP. REQUEST NO : ' ||V_DM_REQ_NO;
            RETURN;
        END IF;
    END IF;

    INX := 0;
    MAX_NUM := 0;

    /* 시작 LOG */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME||': ' ||V_TABLE_ID||' INSERT LOGIC';
    D_EVENT_DATE := SYSTIMESTAMP;

    PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

    BEGIN

        INSERT
          INTO GT_PRSSP_ANL_ESS_REQ
             ( DM_REQ_NO
             , ITEM_SEQ
             , ITEM_ID
             , DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , PLANT_SITE_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , YYYYMMDD
             , PLAN_QTY
             , UOM
             , INV_ALLO_QTY
             , SLOC_ID
             , SLOC_PLANT_ID
             , PUCH_MGR
             , PUCH_GROUP
             , PR_HEADER
             , PR_ITEM_DETAIL
             , DM_REQUESTED_BY
             , DM_REQUEST_DATE
             , BOD_ID
             , HOLD_FLAG
             , CONFIRM_ID
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT A.REQUEST_NO AS DM_REQ_NO
             , A.ITEM_SEQ
             , A.ITEM_ID
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , CASE
                    WHEN A.PLANT_SITE_ID IS NULL OR A.PLANT_SITE_ID = '' THEN V_KR012031
                    ELSE A.PLANT_SITE_ID
                END
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.YYYYMMDD
             , A.PLAN_QTY
             , A.UOM
             , 0 AS INV_ALLO_QTY
             , A.STORAGE_ID AS SLOC_ID
             , A.STORAGE_PLANT_ID AS SLOC_PLANT_ID
             , A.PUCH_MGR
             , A.PUCH_GROUP
             , A.PR_HEADER
             , A.PR_ITEM_DETAIL
             , A.ATTRIBUTE1 AS DM_REQUESTED_BY /* 요청자 한글 이름 */
             , A.LAST_UPDATE_DATE AS DM_REQUEST_DATE
             , (SELECT *
                  FROM (SELECT BOD_ID
                          FROM SCP_MST_BOD_V
                         WHERE DIVISION_ID = A.DIVISION_ID
                           AND FROM_SITE = CASE
                                                WHEN A.PLANT_SITE_ID IS NULL OR A.PLANT_SITE_ID = '' THEN V_KR012031
                                                ELSE A.PLANT_SITE_ID
                                            END
                           AND TO_SITE = A.SCM_SITE_ID
                           AND INCOTERMS = A.INCOTERMS
                           AND BOD_VALID_YN = 'Y'
                         ORDER BY PRIORITY ASC)
                 WHERE ROWNUM <= 1) AS BOD_ID
             , 'N'
             , NULL
             , V_BATCH_USER AS CREATED_BY
             , SYSTIMESTAMP AS CREATION_DATE
             , A.LAST_UPDATED_BY AS LAST_UPDATED_BY /* 요청자 GPORTAL ID */
             , SYSTIMESTAMP AS LAST_UPDATE_DATE
          FROM DM_PLN_PR_DETAIL A
         WHERE 1 = 1
           AND A.REQUEST_NO = V_DM_REQ_NO;

        /* ------------------------------------------------------------- */
        /* 음수수량 요청시 이전 요청 확인하여 블로킹 */
        SELECT 1
             , COUNT(*)
          INTO INX
             , MAX_NUM
          FROM GT_PRSSP_ANL_ESS_REQ;

        WHILE INX <= MAX_NUM
        LOOP

            SELECT DM_REQ_NO
                 , ITEM_ID
                 , DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , PLANT_SITE_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , YYYYMMDD
                 , PLAN_QTY
                 , DM_REQUEST_DATE
              INTO DM_REQ_NO
                 , ITEM_ID
                 , DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , PLANT_SITE_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , V_YYYYMMDD
                 , PLAN_QTY
                 , DM_REQUEST_DATE
              FROM GT_PRSSP_ANL_ESS_REQ
             WHERE TID = INX;

            IF PLAN_QTY < 0 THEN
                BEFORE_DM_REQ_NO := NULL;
                BEFORE_ITEM_ID := NULL;
                BEFORE_PLAN_QTY := NULL;

                SELECT *
                  INTO BEFORE_DM_REQ_NO
                     , BEFORE_ITEM_ID
                     , BEFORE_PLAN_QTY
                  FROM (SELECT R.DM_REQ_NO AS BEFORE_DM_REQ_NO
                             , R.ITEM_ID   AS BEFORE_ITEM_ID
                             , R.PLAN_QTY  AS BEFORE_PLAN_QTY
                          FROM SSP_ANL_ESS_REQ R
                             , SSP_ANL_ESS_PR  P
                         WHERE 1 = 1
                           AND P.DM_REQ_NO(+) = R.DM_REQ_NO
                           AND P.PR_ITEM_ID(+) = R.ITEM_ID
                           AND R.ITEM_ID = ITEM_ID
                           AND R.DIVISION_ID = DIVISION_ID
                           AND R.PROJECT_CODE = PROJECT_CODE
                           AND R.SCM_SITE_ID = SCM_SITE_ID
                           AND R.PLANT_SITE_ID = PLANT_SITE_ID
                           AND R.DOM_EXP = DOM_EXP
                           AND R.FCST_TYPE = FCST_TYPE
                           AND R.INCOTERMS = INCOTERMS
                           AND R.YYYYMMDD = V_YYYYMMDD
                           AND R.DM_REQUEST_DATE < DM_REQUEST_DATE
                           AND P.PR_NO IS NULL
                           AND P.ATTRIBUTE1 IS NULL
                         ORDER BY DM_REQUEST_DATE DESC
                       )
                 WHERE ROWNUM = 1;

                IF (PLAN_QTY * -1) = BEFORE_PLAN_QTY THEN

                    UPDATE SSP_ANL_ESS_REQ
                       SET HOLD_FLAG = 'Y'
                     WHERE DM_REQ_NO = BEFORE_DM_REQ_NO
                       AND ITEM_ID   = BEFORE_ITEM_ID;

                    UPDATE GT_PRSSP_ANL_ESS_REQ
                       SET HOLD_FLAG = 'Y'
                     WHERE DM_REQ_NO = DM_REQ_NO
                       AND ITEM_ID   = ITEM_ID;

                END IF;

            END IF;

            INX := INX + 1;

        END LOOP;

        /* DM 정보 기준 SSP_ANL_ESS_REQ 정보 생성 */
        INSERT
          INTO SSP_ANL_ESS_REQ
             ( DM_REQ_NO
             , ITEM_SEQ
             , ITEM_ID
             , DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , PLANT_SITE_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , YYYYMMDD
             , PLAN_QTY
             , UOM
             , INV_ALLO_QTY
             , SLOC_ID
             , SLOC_PLANT_ID
             , PUCH_MGR
             , PUCH_GROUP
             , PR_HEADER
             , PR_ITEM_DETAIL
             , DM_REQUESTED_BY
             , DM_REQUEST_DATE
             , BOD_ID
             , HOLD_FLAG
             , CONFIRM_ID
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1 )            /* 최초 DM_REQUESTOR */
        SELECT DM_REQ_NO
             , ITEM_SEQ
             , ITEM_ID
             , DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , PLANT_SITE_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , YYYYMMDD
             , PLAN_QTY
             , UOM
             , INV_ALLO_QTY
             , SLOC_ID
             , SLOC_PLANT_ID
             , PUCH_MGR
             , PUCH_GROUP
             , PR_HEADER
             , PR_ITEM_DETAIL
             , DM_REQUESTED_BY
             , DM_REQUEST_DATE
             , BOD_ID
             , HOLD_FLAG
             , CONFIRM_ID
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , LAST_UPDATED_BY /* 최초 DM_REQUESTOR */
          FROM GT_PRSSP_ANL_ESS_REQ;

        /* DM 정보 기준 SSP_ANL_ESS_REQ_H 정보 생성 */
        INSERT
          INTO SSP_ANL_ESS_REQ_H
             ( HISTORY_SEQ
             , DM_REQ_NO
             , ITEM_SEQ
             , ITEM_ID
             , DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , PLANT_SITE_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , YYYYMMDD
             , PLAN_QTY
             , UOM
             , INV_ALLO_QTY
             , SLOC_ID
             , SLOC_PLANT_ID
             , PUCH_MGR
             , PUCH_GROUP
             , PR_HEADER
             , PR_ITEM_DETAIL
             , DM_REQUESTED_BY
             , DM_REQUEST_DATE
             , BOD_ID
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE )
        SELECT SUBSTR(TO_CHAR(SYSTIMESTAMP, 'YYYYMMDD'), 1, 8)||LPAD(TO_CHAR(SEQ1_SSP_ANL_ESS.NEXTVAL, '0'), 6) AS HISTORY_SEQ
             , DM_REQ_NO
             , ITEM_SEQ
             , ITEM_ID
             , DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , PLANT_SITE_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , YYYYMMDD
             , PLAN_QTY
             , UOM
             , INV_ALLO_QTY
             , SLOC_ID
             , SLOC_PLANT_ID
             , PUCH_MGR
             , PUCH_GROUP
             , PR_HEADER
             , PR_ITEM_DETAIL
             , DM_REQUESTED_BY
             , DM_REQUEST_DATE
             , BOD_ID
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
          FROM GT_PRSSP_ANL_ESS_REQ;

        /* DM 정보 기준 SSP REQ 정보 생성 후 DM 테이블 SSP_TRANSFER_FLAG 및 LAST_UPDATE_DATE 변경 */
        UPDATE DM_PLN_PR_DETAIL
           SET SSP_TRANSFER_FLAG = 'Y'
             , LAST_UPDATED_BY   = V_BATCH_USER
             , LAST_UPDATE_DATE  = SYSTIMESTAMP
         WHERE 1 = 1
           AND REQUEST_NO = V_DM_REQ_NO;

        /* ------------------------------------------------------------------------------------------------- */
        /* ERP 재고 NETTING PROGRAM CALL */
        /* ------------------------------------------------------------------------------------------------- */
        PR_SSP_ANL_ESS_REQ_NET(V_DM_REQ_NO, V_DIVISION_ID, V_LOG_MESSAGE);

        /* 기존 MSSQL은 프로시저도 리턴값을 줬으나 오라클 프로시저는 불가능하여. v_return 변수가 아닌 메시지 값을 사용하여 구분하도록 수정. */
        IF V_LOG_MESSAGE != 'OK' THEN
            V_LOG_MESSAGE := 'PR_SSP_ANL_ESS_REQ_NET : '||V_LOG_MESSAGE ;
            RAISE_APPLICATION_ERROR(-20001, V_LOG_MESSAGE);
        END IF;

        /* --------------------------------------------------------- */
        /* 실행 Logic END -- */
        /* --------------------------------------------------------- */

        /* TXN LOG */
        V_LOG_TYPE := 'TXN';    /* ▶ 로그타입 */
        N_LOG_COUNT := SQL%ROWCOUNT;
        V_LOG_MESSAGE := 'EXECUTE '||V_PROGRAM_NAME;
        V_DESCRIPTION := 'Process Complete...' ||':' ||SUBSTR(TO_CHAR (D_EVENT_DATE, 'YYYYMMDD'), 1, 8);
        D_EVENT_DATE := SYSTIMESTAMP;

        PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

        EXCEPTION WHEN OTHERS THEN
            /* ERROR LOG */
            V_LOG_TYPE := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := V_PROGRAM_NAME||'ERROR_LINE : ' ||LPAD(TO_CHAR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 'FM9999999999'), 10);
            D_EVENT_DATE := SYSTIMESTAMP;

            PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

            R_ERROR_MSG := SUBSTR(SQLERRM, 1, 1000);
            RETURN;

    END;

    /* 임시 운영반영시에 주석처리 할것. */
    V_EXEC_TIME := TO_CHAR(EXTRACT(MINUTE FROM (SYSTIMESTAMP - V_START_TIME)), 'FM00')||':' ||
               TO_CHAR(TRUNC(EXTRACT(SECOND FROM (SYSTIMESTAMP - V_START_TIME))), 'FM00');

    /* 종료 LOG */
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '['||+'][' ||V_EXEC_TIME||']';
    D_EVENT_DATE := SYSTIMESTAMP;

    PR_DM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_BATCH_USER);

    R_ERROR_MSG := 'OK';

    RETURN;
END ;