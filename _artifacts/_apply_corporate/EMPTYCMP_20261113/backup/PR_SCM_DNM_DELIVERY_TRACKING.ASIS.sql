CREATE OR REPLACE PROCEDURE         PR_SCM_DNM_DELIVERY_TRACKING

AS
/*
 * Program ID   : PR_SCM_DNM_DELIVERY_TRACKING
 * Description  : Delivery Tracking 정보 I/F
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.12.26   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.22   Kim Jihye      shipment_no, container_no 기준 중복 데이타 처리
 * 2018.12.04   KSG            company_id 추가
 * 2021.09.29   KSG            C20210928-000189 운송중 재고(Trucking) ETA 정보 반영 관련 : 컬럼 추가
 * 2022.07.20   SSP Pjt.       ZFCY2ATA, ZFCY2ATD 추가
 * 2022.08.10   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ETA 정보 반영 관련 컬럼 추가
                               ZFCY1,ZFCY1ETA,ZFCY1ATA,ZFCY1ETD,ZFCY1ATD,
                               ZFCY2,ZFCY2ETA,ZFCY2ETD,
                               ZFCY3,ZFCY3ETA,ZFCY3ATA,
                               ZFCY3ETD,ZFCY3ATD,ZLANDETD,
                               ZLANDETA,ZLANDATD,ZLANDATA
 * 2024.06.09   vadabi3        NERP - 특정 Company 별도 처리 개선
 * 2024.10.28   vadabi3        NERP - 개발 DB 적용
 ----------------------------------------------------------------------------------------------------
 * 2026.07.06   ZIONEX      [PJ202650304] NextSCM Migration
 * 2026.11.02   ZIONEX         POL_ATD_DATE 빈 값 '19000101'(NOT NULL 컬럼)
 */

    V_BATCH_USER     VARCHAR2(150 CHAR) := 'scm_batch';
    V_PROGRAM_NAME   VARCHAR2(150 CHAR) := 'PR_SCM_DNM_DELIVERY_TRACKING';
    V_LOG_TYPE       VARCHAR2(30 CHAR);
    N_LOG_COUNT      INTEGER := 0;
    V_LOG_MESSAGE    VARCHAR2(1000 CHAR);
    V_DESCRIPTION    VARCHAR2(500 CHAR);
    D_EVENT_DATE     DATE;
    N_HISTORY_SEQ    NUMBER;
    V_ESOC           VARCHAR2(8 CHAR);
    V_ERRMSG         VARCHAR2(4000 CHAR);
BEGIN
  /* NERP 매핑코드 */
    SELECT FN_GET_LOOKUP_VALUE('PR_SCM_DNM_DELIVERY_TRACKING', 'ESOC') INTO V_ESOC FROM DUAL;

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
  /* NERP 대응 임시조치(COMPANY_ID 신코드 치환) */
        UPDATE XIF_ERP_DELIVERY_TRACKING_R_SN
           SET ATTRIBUTE1 = (SELECT NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' AND OLD_VALUE1 = XIF_ERP_DELIVERY_TRACKING_R_SN.ATTRIBUTE1)
         WHERE ATTRIBUTE1 IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID')
           AND (SELECT NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' AND OLD_VALUE1 = XIF_ERP_DELIVERY_TRACKING_R_SN.ATTRIBUTE1) <> ''
           AND TRANSFER_DATE >= '20251003'
           AND TRANSFER_FLAG = 'N';

  /* 인터페이스 테이블 처리 ROW UPDATE */
        UPDATE XIF_ERP_DELIVERY_TRACKING_R_SN
           SET TRANSFER_FLAG = 'P'
         WHERE FN_SCM_SYS_NVL(TRANSFER_FLAG, 'N') = 'N';

  /* History 비교용 변경대상 snapshot → GTT (SELECT * INTO temp$ 대체) */
        INSERT INTO GT_SDDT_TRACKING_TEMP
        SELECT *
          FROM SCM_DNM_DELIVERY_TRACKING
         WHERE COMPANY_ID || SHIPMENT_NO || CONTAINER_NO
               IN ( SELECT FN_SCM_SYS_NVL(ATTRIBUTE1, V_ESOC) || SHIPMENT_NO || CONTAINER_NO
                      FROM XIF_ERP_DELIVERY_TRACKING_R_SN
                     WHERE TRANSFER_FLAG = 'P' );

  /* 지나간 배치까지 적용하기 위해 커서로 처리 */
        FOR R_IF IN ( SELECT IFSEQNO
                        FROM XIF_ERP_DELIVERY_TRACKING_R_SN
                       WHERE TRANSFER_FLAG = 'P'
                       GROUP BY IFSEQNO
                       ORDER BY IFSEQNO ASC )
        LOOP
            MERGE INTO SCM_DNM_DELIVERY_TRACKING A
            USING ( SELECT /* PR_SCM_DNM_DELIVERY_TRACKING */
                            FN_SCM_SYS_NVL(ATTRIBUTE1, V_ESOC)        AS COMPANY_ID
                          , SHIPMENT_NO
                          , FN_SCM_SYS_NVL(CONTAINER_NO, '-')          AS CONTAINER_NO
                          , ROUTE, INCOTERMS, CARRIER, POL_PORT, SHIPPING_DATE
                          , NVL(POL_ATD_DATE, '19000101')         AS POL_ATD_DATE  --  2026.11.02 ZIONEX
                          , TS1_PORT, TS1_ETA_DATE, TS1_ATA_DATE, TS1_ETD_DATE, TS1_ATD_DATE
                          , TS2_PORT, TS2_ETA_DATE, TS2_ATA_DATE, TS2_ETD_DATE, TS2_ATD_DATE
                          , TS3_PORT, TS3_ETA_DATE, TS3_ATA_DATE, TS3_ETD_DATE, TS3_ATD_DATE
                          , POD_PORT, POD_ETA_DATE, POD_ATA_DATE, POD_ETD_DATE, POD_ATD_DATE
                          , F_DEST_PORT, F_DEST_ETA_DATE, F_DEST_ATA_DATE
                          , ATTRIBUTE2, ATTRIBUTE3
                          , REPLACE(CASE WHEN ZFCY2ATA = '0000-00-00' THEN '' ELSE ZFCY2ATA END, '-', '') AS ZFCY2ATA
                          , REPLACE(CASE WHEN ZFCY2ATD = '0000-00-00' THEN '' ELSE ZFCY2ATD END, '-', '') AS ZFCY2ATD
                          , ZFCY1
                          , REPLACE(CASE WHEN ZFCY1ETA = '0000-00-00' THEN '' ELSE ZFCY1ETA END, '-', '') AS ZFCY1ETA
                          , REPLACE(CASE WHEN ZFCY1ATA = '0000-00-00' THEN '' ELSE ZFCY1ATA END, '-', '') AS ZFCY1ATA
                          , REPLACE(CASE WHEN ZFCY1ETD = '0000-00-00' THEN '' ELSE ZFCY1ETD END, '-', '') AS ZFCY1ETD
                          , REPLACE(CASE WHEN ZFCY1ATD = '0000-00-00' THEN '' ELSE ZFCY1ATD END, '-', '') AS ZFCY1ATD
                          , ZFCY2
                          , REPLACE(CASE WHEN ZFCY2ETA = '0000-00-00' THEN '' ELSE ZFCY2ETA END, '-', '') AS ZFCY2ETA
                          , REPLACE(CASE WHEN ZFCY2ETD = '0000-00-00' THEN '' ELSE ZFCY2ETD END, '-', '') AS ZFCY2ETD
                          , ZFCY3
                          , REPLACE(CASE WHEN ZFCY3ETA = '0000-00-00' THEN '' ELSE ZFCY3ETA END, '-', '') AS ZFCY3ETA
                          , REPLACE(CASE WHEN ZFCY3ATA = '0000-00-00' THEN '' ELSE ZFCY3ATA END, '-', '') AS ZFCY3ATA
                          , REPLACE(CASE WHEN ZFCY3ETD = '0000-00-00' THEN '' ELSE ZFCY3ETD END, '-', '') AS ZFCY3ETD
                          , REPLACE(CASE WHEN ZFCY3ATD = '0000-00-00' THEN '' ELSE ZFCY3ATD END, '-', '') AS ZFCY3ATD
                          , REPLACE(CASE WHEN ZLANDETD = '0000-00-00' THEN '' ELSE ZLANDETD END, '-', '') AS ZLANDETD
                          , REPLACE(CASE WHEN ZLANDETA = '0000-00-00' THEN '' ELSE ZLANDETA END, '-', '') AS ZLANDETA
                          , REPLACE(CASE WHEN ZLANDATD = '0000-00-00' THEN '' ELSE ZLANDATD END, '-', '') AS ZLANDATD
                          , REPLACE(CASE WHEN ZLANDATA = '0000-00-00' THEN '' ELSE ZLANDATA END, '-', '') AS ZLANDATA
                      FROM ( SELECT T0.*
                                  , ROW_NUMBER() OVER (PARTITION BY SHIPMENT_NO, CONTAINER_NO ORDER BY SHIPPING_DATE DESC) NUM
                               FROM XIF_ERP_DELIVERY_TRACKING_R_SN T0
                              WHERE IFSEQNO = R_IF.IFSEQNO
                                AND TRANSFER_FLAG = 'P' ) T
                     WHERE NUM = 1 ) B
            ON ( A.COMPANY_ID = B.COMPANY_ID
             AND A.SHIPMENT_NO = B.SHIPMENT_NO
             AND A.CONTAINER_NO = B.CONTAINER_NO )
            WHEN MATCHED THEN
                UPDATE SET
                       ROUTE = B.ROUTE, INCOTERMS = B.INCOTERMS, CARRIER = B.CARRIER, POL = B.POL_PORT
                     , SHIPPING_DATE = B.SHIPPING_DATE, POL_ATD_DATE = B.POL_ATD_DATE
                     , TS1_PORT = B.TS1_PORT, TS1_ETA_DATE = B.TS1_ETA_DATE, TS1_ATA_DATE = B.TS1_ATA_DATE, TS1_ETD_DATE = B.TS1_ETD_DATE, TS1_ATD_DATE = B.TS1_ATD_DATE
                     , TS2_PORT = B.TS2_PORT, TS2_ETA_DATE = B.TS2_ETA_DATE, TS2_ATA_DATE = B.TS2_ATA_DATE, TS2_ETD_DATE = B.TS2_ETD_DATE, TS2_ATD_DATE = B.TS2_ATD_DATE
                     , TS3_PORT = B.TS3_PORT, TS3_ETA_DATE = B.TS3_ETA_DATE, TS3_ATA_DATE = B.TS3_ATA_DATE, TS3_ETD_DATE = B.TS3_ETD_DATE, TS3_ATD_DATE = B.TS3_ATD_DATE
                     , POD = B.POD_PORT, POD_ETA_DATE = B.POD_ETA_DATE, POD_ATA_DATE = B.POD_ATA_DATE, POD_ETD_DATE = B.POD_ETD_DATE, POD_ATD_DATE = B.POD_ATD_DATE
                     , F_DEST_PORT_CODE = B.F_DEST_PORT, F_DEST_ETA_DATE = B.F_DEST_ETA_DATE, F_DEST_ATA_DATE = B.F_DEST_ATA_DATE
                     , ATTRIBUTE2 = B.ATTRIBUTE2, ATTRIBUTE3 = B.ATTRIBUTE3
                     , LAST_UPDATED_BY = V_BATCH_USER, LAST_UPDATE_DATE = SYSDATE
                     , ZFCY2ATA = B.ZFCY2ATA, ZFCY2ATD = B.ZFCY2ATD
                     , ZFCY1 = B.ZFCY1, ZFCY1ETA = B.ZFCY1ETA, ZFCY1ATA = B.ZFCY1ATA, ZFCY1ETD = B.ZFCY1ETD, ZFCY1ATD = B.ZFCY1ATD
                     , ZFCY2 = B.ZFCY2, ZFCY2ETA = B.ZFCY2ETA, ZFCY2ETD = B.ZFCY2ETD
                     , ZFCY3 = B.ZFCY3, ZFCY3ETA = B.ZFCY3ETA, ZFCY3ATA = B.ZFCY3ATA, ZFCY3ETD = B.ZFCY3ETD, ZFCY3ATD = B.ZFCY3ATD
                     , ZLANDETD = B.ZLANDETD, ZLANDETA = B.ZLANDETA, ZLANDATD = B.ZLANDATD, ZLANDATA = B.ZLANDATA
            WHEN NOT MATCHED THEN
                INSERT ( COMPANY_ID, SHIPMENT_NO, CONTAINER_NO, ROUTE, INCOTERMS, CARRIER, POL, SHIPPING_DATE, POL_ATD_DATE
                       , TS1_PORT, TS1_ETA_DATE, TS1_ATA_DATE, TS1_ETD_DATE, TS1_ATD_DATE
                       , TS2_PORT, TS2_ETA_DATE, TS2_ATA_DATE, TS2_ETD_DATE, TS2_ATD_DATE
                       , TS3_PORT, TS3_ETA_DATE, TS3_ATA_DATE, TS3_ETD_DATE, TS3_ATD_DATE
                       , POD, POD_ETA_DATE, POD_ATA_DATE, POD_ETD_DATE, POD_ATD_DATE
                       , F_DEST_PORT_CODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE, ATTRIBUTE2, ATTRIBUTE3
                       , VALID_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                       , ZFCY2ATA, ZFCY2ATD
                       , ZFCY1, ZFCY1ETA, ZFCY1ATA, ZFCY1ETD, ZFCY1ATD
                       , ZFCY2, ZFCY2ETA, ZFCY2ETD
                       , ZFCY3, ZFCY3ETA, ZFCY3ATA, ZFCY3ETD, ZFCY3ATD
                       , ZLANDETD, ZLANDETA, ZLANDATD, ZLANDATA )
                VALUES ( B.COMPANY_ID, B.SHIPMENT_NO, B.CONTAINER_NO, B.ROUTE, B.INCOTERMS, B.CARRIER, B.POL_PORT, B.SHIPPING_DATE, B.POL_ATD_DATE
                       , B.TS1_PORT, B.TS1_ETA_DATE, B.TS1_ATA_DATE, B.TS1_ETD_DATE, B.TS1_ATD_DATE
                       , B.TS2_PORT, B.TS2_ETA_DATE, B.TS2_ATA_DATE, B.TS2_ETD_DATE, B.TS2_ATD_DATE
                       , B.TS3_PORT, B.TS3_ETA_DATE, B.TS3_ATA_DATE, B.TS3_ETD_DATE, B.TS3_ATD_DATE
                       , B.POD_PORT, B.POD_ETA_DATE, B.POD_ATA_DATE, B.POD_ETD_DATE, B.POD_ATD_DATE
                       , B.F_DEST_PORT, B.F_DEST_ETA_DATE, B.F_DEST_ATA_DATE, B.ATTRIBUTE2, B.ATTRIBUTE3
                       , 'Y', V_BATCH_USER, SYSDATE, V_BATCH_USER, SYSDATE
                       , B.ZFCY2ATA, B.ZFCY2ATD
                       , B.ZFCY1, B.ZFCY1ETA, B.ZFCY1ATA, B.ZFCY1ETD, B.ZFCY1ATD
                       , B.ZFCY2, B.ZFCY2ETA, B.ZFCY2ETD
                       , B.ZFCY3, B.ZFCY3ETA, B.ZFCY3ATA, B.ZFCY3ETD, B.ZFCY3ATD
                       , B.ZLANDETD, B.ZLANDETA, B.ZLANDATD, B.ZLANDATA );

            V_LOG_TYPE    := 'APPEND';
            V_LOG_MESSAGE := 'MERGE INTO scm_dnm_delivery_tracking';
            V_DESCRIPTION := 'ifseqno = ' || R_IF.IFSEQNO;
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END LOOP;

  /* History 저장 (변경분 = temp$ snapshot MINUS 현재) */
        N_HISTORY_SEQ := SEQ1_SCM_DNM_DELIVERY_TRACKING_H.NEXTVAL;
        INSERT INTO SCM_DNM_DELIVERY_TRACKING_H
             ( HISTORY_SEQ, COMPANY_ID, SHIPMENT_NO, CONTAINER_NO, ROUTE, INCOTERMS, CARRIER, POL, SHIPPING_DATE, POL_ATD_DATE
             , TS1_PORT, TS1_ETA_DATE, TS1_ATA_DATE, TS1_ETD_DATE, TS1_ATD_DATE
             , TS2_PORT, TS2_ETA_DATE, TS2_ATA_DATE, TS2_ETD_DATE, TS2_ATD_DATE
             , TS3_PORT, TS3_ETA_DATE, TS3_ATA_DATE, TS3_ETD_DATE, TS3_ATD_DATE
             , POD, POD_ETA_DATE, POD_ATA_DATE, POD_ETD_DATE, POD_ATD_DATE
             , F_DEST_PORT_CODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE, ATTRIBUTE2, ATTRIBUTE3, VALID_YN
             , ZFCY2ATA, ZFCY2ATD
             , ZFCY1, ZFCY1ETA, ZFCY1ATA, ZFCY1ETD, ZFCY1ATD
             , ZFCY2, ZFCY2ETA, ZFCY2ETD
             , ZFCY3, ZFCY3ETA, ZFCY3ATA, ZFCY3ETD, ZFCY3ATD
             , ZLANDETD, ZLANDETA, ZLANDATD, ZLANDATA
             , CREATION_DATE, LAST_UPDATE_DATE, CREATED_BY, LAST_UPDATED_BY, HISTORY_CREATION_DATE )
        SELECT N_HISTORY_SEQ, A.*, V_BATCH_USER, V_BATCH_USER, SYSDATE
          FROM ( SELECT A.*, B.CREATION_DATE, B.LAST_UPDATE_DATE
                   FROM ( SELECT COMPANY_ID, SHIPMENT_NO, CONTAINER_NO, ROUTE, INCOTERMS, CARRIER, POL, SHIPPING_DATE, POL_ATD_DATE
                               , TS1_PORT, TS1_ETA_DATE, TS1_ATA_DATE, TS1_ETD_DATE, TS1_ATD_DATE
                               , TS2_PORT, TS2_ETA_DATE, TS2_ATA_DATE, TS2_ETD_DATE, TS2_ATD_DATE
                               , TS3_PORT, TS3_ETA_DATE, TS3_ATA_DATE, TS3_ETD_DATE, TS3_ATD_DATE
                               , POD, POD_ETA_DATE, POD_ATA_DATE, POD_ETD_DATE, POD_ATD_DATE
                               , F_DEST_PORT_CODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE, ATTRIBUTE2, ATTRIBUTE3, VALID_YN
                               , ZFCY2ATA, ZFCY2ATD
                               , ZFCY1, ZFCY1ETA, ZFCY1ATA, ZFCY1ETD, ZFCY1ATD
                               , ZFCY2, ZFCY2ETA, ZFCY2ETD
                               , ZFCY3, ZFCY3ETA, ZFCY3ATA, ZFCY3ETD, ZFCY3ATD
                               , ZLANDETD, ZLANDETA, ZLANDATD, ZLANDATA
                            FROM GT_SDDT_TRACKING_TEMP
                          MINUS
                          SELECT COMPANY_ID, SHIPMENT_NO, CONTAINER_NO, ROUTE, INCOTERMS, CARRIER, POL, SHIPPING_DATE, POL_ATD_DATE
                               , TS1_PORT, TS1_ETA_DATE, TS1_ATA_DATE, TS1_ETD_DATE, TS1_ATD_DATE
                               , TS2_PORT, TS2_ETA_DATE, TS2_ATA_DATE, TS2_ETD_DATE, TS2_ATD_DATE
                               , TS3_PORT, TS3_ETA_DATE, TS3_ATA_DATE, TS3_ETD_DATE, TS3_ATD_DATE
                               , POD, POD_ETA_DATE, POD_ATA_DATE, POD_ETD_DATE, POD_ATD_DATE
                               , F_DEST_PORT_CODE, F_DEST_ETA_DATE, F_DEST_ATA_DATE, ATTRIBUTE2, ATTRIBUTE3, VALID_YN
                               , ZFCY2ATA, ZFCY2ATD
                               , ZFCY1, ZFCY1ETA, ZFCY1ATA, ZFCY1ETD, ZFCY1ATD
                               , ZFCY2, ZFCY2ETA, ZFCY2ETD
                               , ZFCY3, ZFCY3ETA, ZFCY3ATA, ZFCY3ETD, ZFCY3ATD
                               , ZLANDETD, ZLANDETA, ZLANDATD, ZLANDATA
                            FROM SCM_DNM_DELIVERY_TRACKING
                           WHERE COMPANY_ID || SHIPMENT_NO || CONTAINER_NO
                                 IN ( SELECT FN_SCM_SYS_NVL(ATTRIBUTE1, V_ESOC) || SHIPMENT_NO || CONTAINER_NO
                                        FROM XIF_ERP_DELIVERY_TRACKING_R_SN WHERE TRANSFER_FLAG = 'P' ) ) A
                   INNER JOIN GT_SDDT_TRACKING_TEMP B
                      ON A.COMPANY_ID = B.COMPANY_ID
                     AND A.SHIPMENT_NO = B.SHIPMENT_NO
                     AND A.CONTAINER_NO = B.CONTAINER_NO ) A;

  /* 처리 한 row 마킹 */
        UPDATE XIF_ERP_DELIVERY_TRACKING_R_SN
           SET TRANSFER_FLAG = 'Y'
         WHERE TRANSFER_FLAG = 'P';

        V_LOG_TYPE    := 'HISTORY';
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_MESSAGE := 'INSERT INTO scm_dnm_delivery_tracking_h';
        V_DESCRIPTION := '@n_history_seq' || ':' || TO_CHAR(N_HISTORY_SEQ);
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);


        EXECUTE IMMEDIATE 'BEGIN PR_SCM_DNM_INTRANSIT_CUTOFF; END;';

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_ERRMSG := SQLERRM;
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(V_ERRMSG, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
END;
