-- [E20261008-SLASHOBJ] PROCEDURE PR_DM_DNM_EDI_CALLOFF_DATA — 원복(사내 적용 전 원문)
CREATE OR REPLACE PROCEDURE           "PR_DM_DNM_EDI_CALLOFF_DATA" 
/*=====================================================================================================================================================
 * Program ID  : PR_DM_DNM_EDI_CALLOFF_DATA
 * Description  : BMW / AUDI등 EDI 정보 ERP I/F -> GSCM EDI_CALLOFF 신규 INSERT
 *                    XIF_ERP_EDI_CALLOFF_HEAD_R    -> DM_DNM_EDI_CALLOFF_HEAD
 *                    XIF_ERP_EDI_CALLOFF_PARTNER_R -> DM_DNM_EDI_CALLOFF_PARTNER
 *                    XIF_ERP_EDI_CALLOFF_ITEM_R    -> DM_DNM_EDI_CALLOFF_ITEM
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      Description
 *=====================================================================================================================================================
 * 배포시 주의사항 : 개발기 -> LGCE_INF , 운영기 -> LGCE_INF
 *=====================================================================================================================================================
 * 2023.05.03   kdmcc14     EDI과제
 * 2023.12.13   chano0612   [PARTNER_TYPE 다중으로 인한 오류 처리]
 * 2024.06.27   JSSBAE      [E20240610-000320]_SCM DM EDI(Cust FCST) 관련 문의사항 (예외로직적용: 앞뒤 공백값, NULL값 공백으로 치환해서 비교 처리)
 * 2024.08.30   JSSBAE      [E20240807-000723]_GSCM EDI내 고객사 파트넘버 문의
 * 2024.12.26   KANG.H.J    [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 * 2025.06.19   김준규        IT20250117A NERP 오펀차수별 Mapping Code적용
 * 2025.09.16 JSSBAE        [E20250910-000974]_NN Mapping Master 컬럼 추가 요청
 * 2026-03-23   김준규        [PJ20264226] NextSCM Pilot 설계 및 개발
 * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
 *===================================================================================================================================================*/
IS

    V_BATCH_USER          VARCHAR2(150 CHAR) := 'scm_batch';
    V_PROGRAM_NAME        VARCHAR2(200 CHAR) := $$PLSQL_UNIT;
    V_BATCH_CHK_MSG       VARCHAR2(150 CHAR) := NULL;
    V_LOG_TYPE            VARCHAR2(30 CHAR);
    N_LOG_COUNT           INTEGER := 0;
    V_LOG_MESSAGE         VARCHAR2(1000 CHAR);
    V_DESCRIPTION         VARCHAR2(500 CHAR);
    D_EVENT_DATE          DATE;
    V_IFSEQNO             VARCHAR2(30 CHAR);
    V_IFSEQNO_X           VARCHAR2(30 CHAR);
    V_FETCH_STATUS        INTEGER := 0;
    V_NEW_INSERT_COUNT    INTEGER := 0;
    V_IN_PARA_DATA        CLOB;
    V_STEP                VARCHAR2(4000 CHAR) := NULL;
    V_TMP_COUNT           INTEGER := 0;
    V_DIVISION_ID         VARCHAR2(30 CHAR);
    V_DIVISION_ID_UC      VARCHAR2(30 CHAR);
    V_NERP_ROLLIN_STAGE   VARCHAR2(30 CHAR);
    V_NERP_START_YYYYMMDD VARCHAR2(8 CHAR);
    V_I                   INTEGER := 1;
    V_CNT                 INTEGER := 0;
    V_CNT_1               INTEGER := 0;
    V_CNT_2               INTEGER := 0;
    V_CNT_3               INTEGER := 0;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
    END IF;

    V_IN_PARA_DATA := NULL;

    /* LOG 용 변수 설정 */

    V_DIVISION_ID    := '81';
    V_DIVISION_ID_UC := '81_UC';

    /* --------------------------------------------------------------------- */
    /* 2025.06.19 김준규 IT20250117A NERP 오펀차수별 Mapping Code적용 Start */
    /* --------------------------------------------------------------------- */
    SELECT LMD.SEGMENT1, LMD.SEGMENT2
      INTO V_NERP_ROLLIN_STAGE, V_NERP_START_YYYYMMDD
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL LMD
      JOIN SCM_ADM_LOOKUP_MASTER ALM
        ON ALM.LOOKUP_TYPE = LMD.LOOKUP_TYPE
       AND ALM.LOOKUP_TYPE = 'NERP_ROLLIN_STAGE'
     WHERE ALM.VALID_YN = 'Y'
       AND LMD.VALID_YN = 'Y'
     FETCH FIRST 1 ROWS ONLY;
    /* --------------------------------------------------------------------- */
    /* 2025.06.19 김준규 IT20250117A NERP 오펀차수별 Mapping Code적용 End */
    /* --------------------------------------------------------------------- */
    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* ◇◇◇◇◇ BEGIN TRY (Oracle: EXCEPTION 블록으로 대체) ◇◇◇◇◇ */

    /* IF TABLE의 신규 수신받은 건이 있을때만 처리 */
    SELECT (SELECT COUNT(1) FROM XIF_ERP_EDI_CALLOFF_HEAD_R_SN WHERE NVL(TRANSACTION_FLAG, 'N') IN ('P', 'N')) +
           (SELECT COUNT(1) FROM XIF_ERP_EDI_CALLOFF_ITEM_R_SN WHERE NVL(TRANSACTION_FLAG, 'N') IN ('P', 'N')) +
           (SELECT COUNT(1) FROM XIF_ERP_EDI_CALLOFF_PARTNER_R_SN WHERE NVL(TRANSACTION_FLAG, 'N') IN ('P', 'N'))
      INTO V_TMP_COUNT
      FROM DUAL;
    IF V_TMP_COUNT > 0 THEN

        /* 인터페이스 테이블 처리 ROW UPDATE */
        UPDATE XIF_ERP_EDI_CALLOFF_HEAD_R_SN
           SET TRANSACTION_FLAG = 'P'
         WHERE NVL(TRANSACTION_FLAG, 'N') = 'N'
           /* 2025.06.19 김준규 IT20250117A NERP 오펀차수별 Mapping Code적용 Start */
           /* OLD 코드는 반영이 되지 않게 처리 */
           AND NOT EXISTS (SELECT 1
                             FROM NERP_CONV_MASTER NCM
                            WHERE NCM.CODETYPE = 'COMPANY_ID'
                              AND NCM.OLD_VALUE1 = XIF_ERP_EDI_CALLOFF_HEAD_R_SN.COMPANY_ID
                              AND NCM.ATTRIBUTE5 <= V_NERP_ROLLIN_STAGE)
           /* 2025.06.19 김준규 IT20250117A NERP 오펀차수별 Mapping Code적용 End */
        ;

        DBMS_OUTPUT.PUT_LINE('CUR_EDI_CALL_OFF_HEAD start' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        /* 지나간 배치까지 적용하기 위해 Cursor 로 처리 */

        /* CUR_EDI_CALL_OFF_HEAD CURSOR FOR */

        FOR REC_HEAD IN (SELECT IFSEQNO FROM XIF_ERP_EDI_CALLOFF_HEAD_R_SN WHERE TRANSACTION_FLAG = 'P' GROUP BY IFSEQNO ORDER BY IFSEQNO ASC) LOOP
            V_IFSEQNO := REC_HEAD.IFSEQNO;


            MERGE INTO DM_DNM_EDI_CALLOFF_HEAD A
            USING (
                   SELECT IFSEQNO
                        , SOLDTO_CODE
                        , COMPANY_ID
                        , MESSAGE_REFERENCE
                        , MESSAGE_TYPE
                        , DOC_IDENTIFINER
                        , EDI_INTERCHANGE_NO
                        , DOC_ISSUE_DATE
                        , RDD_TYPE
                        , COMPANY_NAME
                        , SOLDTO_NAME
                        , EDI_IF_SEQ
                        , TRANSACTION_FLAG
                        , CREATE_USER_ID
                        , CREATE_DATE
                        , CREATE_TIME
                        , UPDATE_USER_ID
                        , UPDATE_DATE
                        , UPDATE_TIME
                        , TRANSFER_CREATE_USER_ID
                        , TRANSFER_CREATE_DATE
                        , TRANSFER_CREATE_TIME
                        , TRANSFER_UPDATE_USER_ID
                        , TRANSFER_UPDATE_DATE
                        , TRANSFER_UPDATE_TIME
                        , DOC_STATUS
                        , (CASE
                               WHEN IFSEQNO LIKE '1%' THEN
                                'G'
                               ELSE
                                'D'
                           END || SENDER_CODE) SENDER_CODE
                        , SENDER_NAME
                        , CASE
                              WHEN REGEXP_LIKE(ATTRIBUTE1, '^\d+$') THEN
                               TO_NUMBER(ATTRIBUTE1)
                              ELSE
                               0
                          END AS TT_CNT
                        , CASE
                              WHEN REGEXP_LIKE(ATTRIBUTE2, '^\d+$') THEN
                               TO_NUMBER(ATTRIBUTE2)
                              ELSE
                               0
                          END AS SENDER_CNT
                     FROM XIF_ERP_EDI_CALLOFF_HEAD_R_SN
                    WHERE IFSEQNO = V_IFSEQNO
                      AND TRANSACTION_FLAG = 'P'
                    GROUP BY IFSEQNO
                           , SOLDTO_CODE
                           , COMPANY_ID
                           , MESSAGE_REFERENCE
                           , MESSAGE_TYPE
                           , DOC_IDENTIFINER
                           , EDI_INTERCHANGE_NO
                           , DOC_ISSUE_DATE
                           , RDD_TYPE
                           , COMPANY_NAME
                           , SOLDTO_NAME
                           , EDI_IF_SEQ
                           , TRANSACTION_FLAG
                           , CREATE_USER_ID
                           , CREATE_DATE
                           , CREATE_TIME
                           , UPDATE_USER_ID
                           , UPDATE_DATE
                           , UPDATE_TIME
                           , TRANSFER_CREATE_USER_ID
                           , TRANSFER_CREATE_DATE
                           , TRANSFER_CREATE_TIME
                           , TRANSFER_UPDATE_USER_ID
                           , TRANSFER_UPDATE_DATE
                           , TRANSFER_UPDATE_TIME
                           , DOC_STATUS
                           , (CASE
                                  WHEN IFSEQNO LIKE '1%' THEN
                                   'G'
                                  ELSE
                                   'D'
                              END || SENDER_CODE)
                           , SENDER_NAME
                           , CASE
                                 WHEN REGEXP_LIKE(ATTRIBUTE1, '^\d+$') THEN
                                  TO_NUMBER(ATTRIBUTE1)
                                 ELSE
                                  0
                             END
                           , CASE
                                 WHEN REGEXP_LIKE(ATTRIBUTE2, '^\d+$') THEN
                                  TO_NUMBER(ATTRIBUTE2)
                                 ELSE
                                  0
                             END) B
            ON (A.SOLDTO_CODE = B.SOLDTO_CODE AND A.COMPANY_ID = B.COMPANY_ID AND (A.MESSAGE_REFERENCE = B.MESSAGE_REFERENCE OR (A.MESSAGE_REFERENCE IS NULL AND B.MESSAGE_REFERENCE IS NULL)) AND (A.MESSAGE_TYPE = B.MESSAGE_TYPE OR (A.MESSAGE_TYPE IS NULL AND B.MESSAGE_TYPE IS NULL)) AND (A.DOC_IDENTIFINER = B.DOC_IDENTIFINER OR (A.DOC_IDENTIFINER IS NULL AND B.DOC_IDENTIFINER IS NULL)))
            WHEN MATCHED THEN
                UPDATE
                   SET A.EDI_INTERCHANGE_NO = B.EDI_INTERCHANGE_NO
                     , A.DOC_ISSUE_DATE     = B.DOC_ISSUE_DATE
                     , A.RDD_TYPE           = B.RDD_TYPE
                     , A.COMPANY_NAME       = B.COMPANY_NAME
                     , A.SOLDTO_NAME        = B.SOLDTO_NAME
                     , A.EDI_IF_SEQ         = B.EDI_IF_SEQ
                     , A.TRANSACTION_FLAG   = B.TRANSACTION_FLAG
                     , A.CREATE_USER_ID     = B.CREATE_USER_ID
                     , A.CREATE_DATE        = B.CREATE_DATE
                     , A.CREATE_TIME        = B.CREATE_TIME
                     , A.UPDATE_USER_ID     = B.UPDATE_USER_ID
                     , A.UPDATE_DATE        = B.UPDATE_DATE
                     , A.UPDATE_TIME        = B.UPDATE_TIME
                     , A.VALID_YN           = 'Y'
                     , A.LAST_UPDATED_BY    = V_BATCH_USER
                     , A.LAST_UPDATE_DATE   = SYSDATE
                     , A.ATTRIBUTE6         = B.DOC_STATUS
                     , A.SENDER_CODE        = B.SENDER_CODE
                     , A.SENDER_NAME        = B.SENDER_NAME
                     , A.TT_CNT             = B.TT_CNT
                     , A.SENDER_CNT         = B.SENDER_CNT
            WHEN NOT MATCHED THEN
                INSERT ( SOLDTO_CODE
                       , COMPANY_ID
                       , MESSAGE_REFERENCE
                       , MESSAGE_TYPE
                       , DOC_IDENTIFINER
                       , EDI_INTERCHANGE_NO
                       , DOC_ISSUE_DATE
                       , RDD_TYPE
                       , COMPANY_NAME
                       , SOLDTO_NAME
                       , EDI_IF_SEQ
                       , TRANSACTION_FLAG
                       , CREATE_USER_ID
                       , CREATE_DATE
                       , CREATE_TIME
                       , UPDATE_USER_ID
                       , UPDATE_DATE
                       , UPDATE_TIME
                       , VALID_YN
                       , CREATED_BY
                       , CREATION_DATE
                       , LAST_UPDATED_BY
                       , LAST_UPDATE_DATE
                       , ATTRIBUTE6
                       , SENDER_CODE
                       , SENDER_NAME
                       , TT_CNT
                       , SENDER_CNT )
                VALUES ( NVL(B.SOLDTO_CODE, '-')
                       , NVL(B.COMPANY_ID, '-')
                       , NVL(B.MESSAGE_REFERENCE, '-')
                       , NVL(B.MESSAGE_TYPE, '-')
                       , NVL(B.DOC_IDENTIFINER, '-')
                       , B.EDI_INTERCHANGE_NO
                       , B.DOC_ISSUE_DATE
                       , B.RDD_TYPE
                       , B.COMPANY_NAME
                       , B.SOLDTO_NAME
                       , B.EDI_IF_SEQ
                       , B.TRANSACTION_FLAG
                       , B.CREATE_USER_ID
                       , B.CREATE_DATE
                       , B.CREATE_TIME
                       , B.UPDATE_USER_ID
                       , B.UPDATE_DATE
                       , B.UPDATE_TIME
                       , 'Y'
                       , V_BATCH_USER
                       , SYSDATE
                       , V_BATCH_USER
                       , SYSDATE
                       , B.DOC_STATUS
                       , B.SENDER_CODE
                       , B.SENDER_NAME
                       , B.TT_CNT
                       , B.SENDER_CNT );

            /* 처리 한 row 마킹 */
            UPDATE XIF_ERP_EDI_CALLOFF_HEAD_R_SN
               SET TRANSACTION_FLAG = 'Y'
             WHERE TRANSACTION_FLAG = 'P'
               AND IFSEQNO = V_IFSEQNO;

        END LOOP;

        DBMS_OUTPUT.PUT_LINE('CUR_EDI_CALL_OFF_HEAD end' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        /* ---------------------------------------------------------------- */
        /* EDI_CALLOFF_HEAD (END) */
        /* ---------------------------------------------------------------- */
        /* ---------------------------------------------------------------- */
        /* EDI_CALLOFF_PARTNER (START) */
        /* ---------------------------------------------------------------- */
        /* 인터페이스 테이블 처리 ROW UPDATE */
        UPDATE XIF_ERP_EDI_CALLOFF_PARTNER_R_SN
           SET TRANSACTION_FLAG = 'P'
         WHERE NVL(TRANSACTION_FLAG, 'N') = 'N'
           /* 2025.06.16   김준규   NERP) 오펀차수별 적용 대응 Start */
           /* OLD 코드는 반영이 되지 않게 처리 */
           AND NOT EXISTS (SELECT 1
                             FROM NERP_CONV_MASTER NCM
                            WHERE NCM.CODETYPE = 'COMPANY_ID'
                              AND NCM.OLD_VALUE1 = XIF_ERP_EDI_CALLOFF_PARTNER_R_SN.COMPANY_ID
                              AND NCM.ATTRIBUTE5 <= V_NERP_ROLLIN_STAGE)
           /* 2025.06.16   김준규   NERP) 오펀차수별 적용 대응 End */
        ;

        DBMS_OUTPUT.PUT_LINE('CUR_EDI_CALL_OFF_PARTNER start ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        /* 지나간 배치까지 적용하기 위해 Cursor 로 처리 */

        /* CUR_EDI_CALL_OFF_PARTNER CURSOR FOR */

        FOR REC_PARTNER IN (SELECT IFSEQNO FROM XIF_ERP_EDI_CALLOFF_PARTNER_R_SN WHERE TRANSACTION_FLAG = 'P' GROUP BY IFSEQNO ORDER BY IFSEQNO ASC) LOOP
            V_IFSEQNO := REC_PARTNER.IFSEQNO;


            MERGE INTO DM_DNM_EDI_CALLOFF_PARTNER A
            USING (
                   SELECT IFSEQNO
                        , SOLDTO_CODE
                        , COMPANY_ID
                        , MESSAGE_REFERENCE
                        , MESSAGE_TYPE
                        , DOC_IDENTIFINER
                        , SHIPTO_CODE
                        , PARTNER_TYPE
                        , SHIPTO_SEQ
                        , COMPANY_NAME
                        , SHIPTO_NAME1
                        , SHIPTO_NAME2
                        , CITY_NAME
                        , POSTAL_CODE
                        , COUNTRY
                        , SHIPTO_DUNS_NO
                        , EDI_IF_SEQ
                        , TRANSACTION_FLAG
                        , SHIP_FROM_PLANT
                        , CREATE_USER_ID
                        , CREATE_DATE
                        , CREATE_TIME
                        , UPDATE_USER_ID
                        , UPDATE_DATE
                        , UPDATE_TIME
                        , TRANSFER_CREATE_USER_ID
                        , TRANSFER_CREATE_DATE
                        , TRANSFER_CREATE_TIME
                        , TRANSFER_UPDATE_USER_ID
                        , TRANSFER_UPDATE_DATE
                        , TRANSFER_UPDATE_TIME
                        , DOC_STATUS
                        , (CASE
                               WHEN IFSEQNO LIKE '1%' THEN
                                'G'
                               ELSE
                                'D'
                           END || SENDER_CODE) SENDER_CODE
                        , SENDER_NAME
                        , CASE
                              WHEN REGEXP_LIKE(ATTRIBUTE1, '^\d+$') THEN
                               TO_NUMBER(ATTRIBUTE1)
                              ELSE
                               0
                          END AS TT_CNT
                        , CASE
                              WHEN REGEXP_LIKE(ATTRIBUTE2, '^\d+$') THEN
                               TO_NUMBER(ATTRIBUTE2)
                              ELSE
                               0
                          END AS SENDER_CNT
                     FROM XIF_ERP_EDI_CALLOFF_PARTNER_R_SN
                    WHERE IFSEQNO = V_IFSEQNO
                      AND TRANSACTION_FLAG = 'P'
                    GROUP BY IFSEQNO
                           , SOLDTO_CODE
                           , COMPANY_ID
                           , MESSAGE_REFERENCE
                           , MESSAGE_TYPE
                           , DOC_IDENTIFINER
                           , SHIPTO_CODE
                           , PARTNER_TYPE
                           , SHIPTO_SEQ
                           , COMPANY_NAME
                           , SHIPTO_NAME1
                           , SHIPTO_NAME2
                           , CITY_NAME
                           , POSTAL_CODE
                           , COUNTRY
                           , SHIPTO_DUNS_NO
                           , EDI_IF_SEQ
                           , TRANSACTION_FLAG
                           , SHIP_FROM_PLANT
                           , CREATE_USER_ID
                           , CREATE_DATE
                           , CREATE_TIME
                           , UPDATE_USER_ID
                           , UPDATE_DATE
                           , UPDATE_TIME
                           , TRANSFER_CREATE_USER_ID
                           , TRANSFER_CREATE_DATE
                           , TRANSFER_CREATE_TIME
                           , TRANSFER_UPDATE_USER_ID
                           , TRANSFER_UPDATE_DATE
                           , TRANSFER_UPDATE_TIME
                           , DOC_STATUS
                           , (CASE
                                  WHEN IFSEQNO LIKE '1%' THEN
                                   'G'
                                  ELSE
                                   'D'
                              END || SENDER_CODE)
                           , SENDER_NAME
                           , CASE
                                 WHEN REGEXP_LIKE(ATTRIBUTE1, '^\d+$') THEN
                                  TO_NUMBER(ATTRIBUTE1)
                                 ELSE
                                  0
                             END
                           , CASE
                                 WHEN REGEXP_LIKE(ATTRIBUTE2, '^\d+$') THEN
                                  TO_NUMBER(ATTRIBUTE2)
                                 ELSE
                                  0
                             END
                  ) B
            ON (A.SOLDTO_CODE = B.SOLDTO_CODE AND A.COMPANY_ID = B.COMPANY_ID AND (A.MESSAGE_REFERENCE = B.MESSAGE_REFERENCE OR (A.MESSAGE_REFERENCE IS NULL AND B.MESSAGE_REFERENCE IS NULL)) AND (A.MESSAGE_TYPE = B.MESSAGE_TYPE OR (A.MESSAGE_TYPE IS NULL AND B.MESSAGE_TYPE IS NULL)) AND (A.DOC_IDENTIFINER = B.DOC_IDENTIFINER OR (A.DOC_IDENTIFINER IS NULL AND B.DOC_IDENTIFINER IS NULL)) AND (A.SHIPTO_CODE = B.SHIPTO_CODE OR (A.SHIPTO_CODE IS NULL AND B.SHIPTO_CODE IS NULL)) AND (A.PARTNER_TYPE = B.PARTNER_TYPE OR (A.PARTNER_TYPE IS NULL AND B.PARTNER_TYPE IS NULL)) AND (A.SHIPTO_SEQ = B.SHIPTO_SEQ OR (A.SHIPTO_SEQ IS NULL AND B.SHIPTO_SEQ IS NULL)))
            WHEN MATCHED THEN
                UPDATE
                   SET A.COMPANY_NAME     = B.COMPANY_NAME
                     , A.SHIPTO_NAME1     = B.SHIPTO_NAME1
                     , A.SHIPTO_NAME2     = B.SHIPTO_NAME2
                     , A.CITY_NAME        = B.CITY_NAME
                     , A.POSTAL_CODE      = B.POSTAL_CODE
                     , A.COUNTRY          = B.COUNTRY
                     , A.SHIPTO_DUNS_NO   = B.SHIPTO_DUNS_NO
                     , A.EDI_IF_SEQ       = B.EDI_IF_SEQ
                     , A.TRANSACTION_FLAG = B.TRANSACTION_FLAG
                     , A.SHIP_FROM_PLANT  = B.SHIP_FROM_PLANT
                     , A.CREATE_USER_ID   = B.CREATE_USER_ID
                     , A.CREATE_DATE      = B.CREATE_DATE
                     , A.CREATE_TIME      = B.CREATE_TIME
                     , A.UPDATE_USER_ID   = B.UPDATE_USER_ID
                     , A.UPDATE_DATE      = B.UPDATE_DATE
                     , A.UPDATE_TIME      = B.UPDATE_TIME
                     , A.VALID_YN         = 'Y'
                     , A.LAST_UPDATED_BY  = V_BATCH_USER
                     , A.LAST_UPDATE_DATE = SYSDATE
                     , A.ATTRIBUTE6       = B.DOC_STATUS
                     , A.SENDER_CODE      = B.SENDER_CODE
                     , A.SENDER_NAME      = B.SENDER_NAME
                     , A.TT_CNT           = B.TT_CNT
                     , A.SENDER_CNT       = B.SENDER_CNT
            WHEN NOT MATCHED THEN
                INSERT ( SOLDTO_CODE
                       , COMPANY_ID
                       , MESSAGE_REFERENCE
                       , MESSAGE_TYPE
                       , DOC_IDENTIFINER
                       , SHIPTO_CODE
                       , PARTNER_TYPE
                       , SHIPTO_SEQ
                       , COMPANY_NAME
                       , SHIPTO_NAME1
                       , SHIPTO_NAME2
                       , CITY_NAME
                       , POSTAL_CODE
                       , COUNTRY
                       , SHIPTO_DUNS_NO
                       , EDI_IF_SEQ
                       , TRANSACTION_FLAG
                       , SHIP_FROM_PLANT
                       , CREATE_USER_ID
                       , CREATE_DATE
                       , CREATE_TIME
                       , UPDATE_USER_ID
                       , UPDATE_DATE
                       , UPDATE_TIME
                       , VALID_YN
                       , CREATED_BY
                       , CREATION_DATE
                       , LAST_UPDATED_BY
                       , LAST_UPDATE_DATE
                       , ATTRIBUTE6
                       , SENDER_CODE
                       , SENDER_NAME
                       , TT_CNT
                       , SENDER_CNT )
                VALUES ( B.SOLDTO_CODE
                       , B.COMPANY_ID
                       , NVL(B.MESSAGE_REFERENCE, '-')
                       , B.MESSAGE_TYPE
                       , NVL(B.DOC_IDENTIFINER, '-')
                       , B.SHIPTO_CODE
                       , B.PARTNER_TYPE
                       , B.SHIPTO_SEQ
                       , B.COMPANY_NAME
                       , B.SHIPTO_NAME1
                       , B.SHIPTO_NAME2
                       , B.CITY_NAME
                       , B.POSTAL_CODE
                       , B.COUNTRY
                       , B.SHIPTO_DUNS_NO
                       , B.EDI_IF_SEQ
                       , B.TRANSACTION_FLAG
                       , B.SHIP_FROM_PLANT
                       , B.CREATE_USER_ID
                       , B.CREATE_DATE
                       , B.CREATE_TIME
                       , B.UPDATE_USER_ID
                       , B.UPDATE_DATE
                       , B.UPDATE_TIME
                       , 'Y'
                       , V_BATCH_USER
                       , SYSDATE
                       , V_BATCH_USER
                       , SYSDATE
                       , B.DOC_STATUS
                       , B.SENDER_CODE
                       , B.SENDER_NAME
                       , B.TT_CNT
                       , B.SENDER_CNT );

            /* 처리 한 row 마킹 */
            UPDATE XIF_ERP_EDI_CALLOFF_PARTNER_R_SN
               SET TRANSACTION_FLAG = 'Y'
             WHERE TRANSACTION_FLAG = 'P'
               AND IFSEQNO = V_IFSEQNO;

        END LOOP;

        DBMS_OUTPUT.PUT_LINE('CUR_EDI_CALL_OFF_PARTNER end ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        /* ---------------------------------------------------------------- */
        /* EDI_CALLOFF_ITEM (START) */
        /* ---------------------------------------------------------------- */
        /* 인터페이스 테이블 처리 ROW UPDATE */
        UPDATE XIF_ERP_EDI_CALLOFF_ITEM_R_SN
           SET TRANSACTION_FLAG = 'P'
         WHERE NVL(TRANSACTION_FLAG, 'N') = 'N'
           /* 2025.06.16   김준규   NERP) 오펀차수별 적용 대응 Start */
           /* OLD 코드는 반영이 되지 않게 처리 */
           AND NOT EXISTS (SELECT 1
                             FROM NERP_CONV_MASTER NCM
                            WHERE NCM.CODETYPE = 'COMPANY_ID'
                              AND NCM.OLD_VALUE1 = XIF_ERP_EDI_CALLOFF_ITEM_R_SN.COMPANY_ID
                              AND NCM.ATTRIBUTE5 <= V_NERP_ROLLIN_STAGE)
           /* 2025.06.16   김준규   NERP) 오펀차수별 적용 대응 End */
        ;

        DBMS_OUTPUT.PUT_LINE('XIF_ERP_EDI_CALLOFF_ITEM_R_SN start ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        /* 테이블중복제거 */
        /* 임시확인용테이블 중복제거 */

        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DDECD_EDI_NEW_ALL';

        INSERT
          INTO GT_DDECD_EDI_NEW_ALL
             ( NUM, IFSEQNO )
        SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1 FROM DUAL)) NUM, IFSEQNO
          FROM XIF_ERP_EDI_CALLOFF_ITEM_R_SN
         WHERE TRANSACTION_FLAG = 'P'
         GROUP BY IFSEQNO
         ORDER BY IFSEQNO ASC;

        SELECT COUNT(*) INTO V_CNT FROM GT_DDECD_EDI_NEW_ALL;
        DBMS_OUTPUT.PUT_LINE(V_CNT);
        /* ◇◇◇◇◇ */
        WHILE (V_I <= V_CNT) LOOP
            DBMS_OUTPUT.PUT_LINE(V_I);
            /* 신규 IFSEQNO */
            SELECT IFSEQNO INTO V_IFSEQNO FROM GT_DDECD_EDI_NEW_ALL WHERE NUM = V_I;
            DBMS_OUTPUT.PUT_LINE('IFSEQNO : ' || V_IFSEQNO);
            INSERT INTO DM_DNM_EDI_CALLOFF_ITEM
                       ( EDI_IF_SEQ
                       , SUB_NO
                       , YYYYMMDD
                       , DIVISION_ID
                       , SOLDTO_CODE
                       , COMPANY_ID
                       , MESSAGE_REFERENCE
                       , MESSAGE_TYPE
                       , DOC_IDENTIFINER
                       , SHIPTO_CODE
                       , PARTNER_TYPE
                       , SHIPTO_SEQ
                       , SHIP_TO_ITEM_SEQ
                       , ITEM_ID
                       , CUSTOMER_PLANT
                       , UNLOADING_POINT
                       , SCHEDULING_TYPE
                       , RDD_START
                       , QTY
                       , UOM
                       , RDD_END
                       , CUSTOMER_PO_NO
                       , CUSTOMER_CALL_OFF_NO
                       , CUSTOMER_CALL_OFF_DATE
                       , PREVIOUS_CALL_OFF_NO
                       , PREVIOUS_CALL_OFF_DATE
                       , COMPANY_NAME
                       , SHIPTO_NAME1
                       , SHIPTO_NAME2
                       , TRANSACTION_FLAG
                       , ERP_FCST_TYPE
                       , CREATE_USER_ID
                       , CREATE_DATE
                       , CREATE_TIME
                       , UPDATE_USER_ID
                       , UPDATE_DATE
                       , UPDATE_TIME
                       , VALID_YN
                       , CREATED_BY
                       , CREATION_DATE
                       , LAST_UPDATED_BY
                       , LAST_UPDATE_DATE
                       , IFSEQNO
                       , SOLDTO_CODE_W
                       , MESSAGE_TYPE_W
                       , RDD_START_W
                       , DOC_STATUS
                       , PROJECT_CODE
                       , SCM_SITE_ID
                       , SALES_PLANT_SITE_ID
                       , EDI_INCOTERMS
                       , STATUS_CODE
                       , BOM_STATUS
                       , SALES_SITE_STATUS
                       , SSPM_STATUS
                       , PROJECT_STATUS
                       , ITEM_STATUS
                       , SALES_PLANT_SITE_STATUS
                       , INCOTERMS_STATUS
                       , CUST_MATERIAL_CODE
                       , SENDER_CODE
                       , SENDER_NAME
                       , TT_CNT
                       , SENDER_CNT
                       , ERP_STATUS
                       , BASIS_YYYYMMDD
                       , DC_LEVEL /* [E20250910-000974]_NN Mapping Master 컬럼 추가 요청 */
                       )
                SELECT EDI_IF_SEQ
                     , ROW_NUMBER() OVER(PARTITION BY EDI_IF_SEQ ORDER BY RDD_START) SUB_NO
                     , CASE
                           WHEN SUBSTR(RDD_START, 7, 2) = '00' THEN
                            TO_CHAR(LAST_DAY(SUBSTR(RDD_START, 1, 6) || '01'), 'YYYYMMDD')
                           ELSE
                            NVL(RDD_START, NULL) /* RDD_START가 년/월까지만 정의된 경우 월초로 데이터 변환 */
                       END AS YYYYMMDD
                     , B.SEGMENT2 DIVISION_ID /* EDI는 모두 81로 넘어옴 ==> 법인코드별로 JV 법인 구분 기능 */
                     , NVL(A.SOLDTO_CODE, NULL) SOLDTO_CODE
                     , NVL(COMPANY_ID, NULL) COMPANY_ID
                     , NVL(MESSAGE_REFERENCE, NULL) MESSAGE_REFERENCE
                     , MESSAGE_TYPE
                     , NVL(DOC_IDENTIFINER, NULL) DOC_IDENTIFINER
                     , NVL(A.SHIPTO_CODE, NULL) SHIPTO_CODE
                     , PARTNER_TYPE
                     , SHIPTO_SEQ
                     , SHIP_TO_ITEM_SEQ
                     , NVL(LTRIM(RTRIM(ITEM_ID)), NULL) ITEM_ID
                     , NVL(LTRIM(RTRIM(CUSTOMER_PLANT)), NULL) CUSTOMER_PLANT
                     , NVL(LTRIM(RTRIM(UNLOADING_POINT)), NULL) UNLOADING_POINT
                     , SCHEDULING_TYPE
                     , RDD_START
                     , QTY
                     , UOM
                     , RDD_END
                     , CUSTOMER_PO_NO
                     , CUSTOMER_CALL_OFF_NO
                     , CUSTOMER_CALL_OFF_DATE
                     , PREVIOUS_CALL_OFF_NO
                     , PREVIOUS_CALL_OFF_DATE
                     , COMPANY_NAME
                     , SHIPTO_NAME1
                     , SHIPTO_NAME2
                     , TRANSACTION_FLAG
                     , ERP_FCST_TYPE
                     , CREATE_USER_ID
                     , CREATE_DATE
                     , CREATE_TIME
                     , UPDATE_USER_ID
                     , UPDATE_DATE
                     , UPDATE_TIME
                     , 'Y' AS VALID_YN
                     , V_BATCH_USER
                     , SYSDATE
                     , V_BATCH_USER
                     , SYSDATE
                     , V_IFSEQNO IFSEQNO
                     , A.SOLDTO_CODE
                     , MESSAGE_TYPE
                     , CASE
                           WHEN SUBSTR(RDD_START, 7, 2) = '00' THEN
                            RDD_START
                           ELSE
                            NULL
                       END AS RDD_START_W
                     , NVL(A.DOC_STATUS, NULL) DOC_STATUS
                     , NULL AS PROJECT_CODE
                     , NULL AS SCM_SITE_ID
                     , NULL AS SALES_PLANT_SITE_ID
                     , NULL AS EDI_INCOTERMS
                     , 'U' AS STATUS_CODE
                     , 'S' AS BOM_STATUS /* BOM_STATUS는 체크 제외함. */
                     , 'E' AS SALES_SITE_STATUS
                     , 'E' AS SSPM_STATUS
                     , 'E' AS PROJECT_STATUS
                     , 'E' AS ITEM_STATUS
                     , 'E' AS SALES_PLANT_SITE_STATUS
                     , 'E' AS INCOTERMS_STATUS
                     , NVL(LTRIM(RTRIM(CUST_MATERIAL_CODE)), NULL) CUST_MATERIAL_CODE
                     , (CASE
                            WHEN IFSEQNO LIKE '1%' THEN
                             'G'
                            ELSE
                             'D'
                        END || SENDER_CODE) SENDER_CODE
                     , SENDER_NAME
                     , CASE
                           WHEN REGEXP_LIKE(A.ATTRIBUTE1, '^\d+$') THEN
                            TO_NUMBER(A.ATTRIBUTE1)
                           ELSE
                            0
                       END TT_CNT
                     , CASE
                           WHEN REGEXP_LIKE(A.ATTRIBUTE2, '^\d+$') THEN
                            TO_NUMBER(A.ATTRIBUTE2)
                           ELSE
                            0
                       END SENDER_CNT
                     , CASE
                           WHEN (RDD_START IS NULL OR LENGTH(RDD_START) <> 8 OR SOLDTO_CODE IS NULL OR SHIPTO_CODE IS NULL OR ITEM_ID IS NULL) THEN
                            'E'
                           ELSE
                            'S'
                       END AS ERP_STATUS
                     , CASE
                           WHEN SUBSTR(RDD_START, 7, 2) = '00' THEN
                            TO_CHAR(LAST_DAY(SUBSTR(RDD_START, 1, 6) || '01'), 'YYYYMMDD')
                           ELSE
                            NVL(RDD_START, NULL)
                       END AS BASIS_YYYYMMDD
                     , A.ATTRIBUTE3 /* [E20250910-000974]_ERP에서 ATTRIBUTE3에 DC_LEVEL 정보를 넣어 주기로함 */
                  FROM XIF_ERP_EDI_CALLOFF_ITEM_R_SN A
                 INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B /* [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 start */
                    ON B.LOOKUP_TYPE = 'DM_EDI_COMPANY_DIVISION_MAPPING'
                   AND A.COMPANY_ID = B.SEGMENT1
                   AND B.VALID_YN = 'Y'
                 WHERE IFSEQNO = V_IFSEQNO
                   AND TRANSACTION_FLAG = 'P';
            DBMS_OUTPUT.PUT_LINE('END');
            /* 처리 한 row 마킹 */
            UPDATE XIF_ERP_EDI_CALLOFF_ITEM_R_SN
               SET TRANSACTION_FLAG = 'Y'
             WHERE TRANSACTION_FLAG = 'P'
               AND IFSEQNO = V_IFSEQNO;

            V_I := V_I + 1;

        END LOOP;

        /* 처리결과건수 로그변수에 입력 */
        SELECT COUNT(*)
          INTO V_TMP_COUNT
          FROM DM_DNM_EDI_CALLOFF_ITEM
         WHERE 1 = 1
           AND IFSEQNO IN (SELECT IFSEQNO FROM GT_DDECD_EDI_NEW_ALL);
        V_NEW_INSERT_COUNT := V_NEW_INSERT_COUNT + V_TMP_COUNT;

    END IF;
    /* ◇◇◇◇◇ IF TABLE의 정보가 존재하는경우 수행 (END) ◇◇◇◇◇ */

    COMMIT;


    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'EDI New INSERT INTO Count : ' || TO_CHAR(V_NEW_INSERT_COUNT);
    D_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    DBMS_OUTPUT.PUT_LINE('end ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                            ,'ERROR'
                            ,0
                            ,SQLERRM
                            ,NULL
                            ,SYSDATE
                            ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                            ,P_SQL_ERR_CODE  => SQLCODE
                            ,P_SQL_ERR_MSG   => SQLERRM
                            ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        RAISE_APPLICATION_ERROR(-20001
                               ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
/
SHOW ERRORS PROCEDURE PR_DM_DNM_EDI_CALLOFF_DATA
