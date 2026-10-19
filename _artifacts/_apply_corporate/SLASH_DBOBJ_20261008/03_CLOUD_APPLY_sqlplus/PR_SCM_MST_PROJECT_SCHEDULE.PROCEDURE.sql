-- [E20261008-SLASHOBJ] PROCEDURE PR_SCM_MST_PROJECT_SCHEDULE — 사내 현재 원문(적용본, 사내 LAST_DDL 2026-10-08 16:51:15, 443줄)
CREATE OR REPLACE PROCEDURE PR_SCM_MST_PROJECT_SCHEDULE
/* ============================================================
 * Program ID   : PR_SCM_MST_PROJECT_SCHEDULE
 * Description  : GPLM Project Schedule I/F
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2018. 1. 10   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.07.06    ZIONEX         [PJ202650304] NextSCM Migration
 * ============================================================ */
IS
    /* LOG 용 변수 설정 */
    V_BATCH_USER    VARCHAR2(150 CHAR) := 'scm_batch';
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SCM_MST_PROJECT_SCHEDULE';
    V_LOG_TYPE      VARCHAR2(30 CHAR);          /* START/END/ERROR/... */
    N_LOG_COUNT     PLS_INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;
    V_IFSEQNO       VARCHAR2(30 CHAR);
    N_HISTORY_SEQ   NUMBER(19);

    /* 지나간 배치까지 적용하기 위해 Cursor 로 처리 */
    CURSOR CUR_PROJECT IS
        SELECT IF_SEQ
          FROM XIF_PLM_PJT_SCHEDULE_R_SN
         WHERE ATTR_10 = 'P'
         GROUP BY IF_SEQ
         ORDER BY IF_SEQ ASC;
BEGIN
    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        /* 인터페이스 테이블 처리 ROW UPDATE */
        UPDATE XIF_PLM_PJT_SCHEDULE_R_SN
           SET ATTR_10 = 'P'
         WHERE NVL(ATTR_10, 'N') = 'N';

        /* History 데이터 처리를 위한 TEMP Table 삭제 및 생성 (Oracle: GTT GT_SMPS_SCHEDULE 스냅샷) */
        /* 원본 #temp 는 매 실행 DROP 후 SELECT INTO 재생성(빈 상태) → PRESERVE GTT 는 첫 적재 전 비운다 */
        DELETE
          FROM GT_SMPS_SCHEDULE;
        INSERT
          INTO GT_SMPS_SCHEDULE
        SELECT DIVISION_ID
             , PROJECT_CODE
             , PROJECT_VER_SEQ
             , CV_APP_PLAN_START_DATE
             , CV_APP_PLAN_END_DATE
             , CV_PLAN_START_DATE
             , CV_PLAN_END_DATE
             , CV_ACTUAL_START_DATE
             , CV_ACTUAL_END_DATE
             , DV_APP_PLAN_START_DATE
             , DV_APP_PLAN_END_DATE
             , DV_PLAN_START_DATE
             , DV_PLAN_END_DATE
             , DV_ACTUAL_START_DATE
             , DV_ACTUAL_END_DATE
             , PD_APP_PLAN_START_DATE
             , PD_APP_PLAN_END_DATE
             , PD_PLAN_START_DATE
             , PD_PLAN_END_DATE
             , PD_ACTUAL_START_DATE
             , PD_ACTUAL_END_DATE
             , PV_APP_PLAN_START_DATE
             , PV_APP_PLAN_END_DATE
             , PV_PLAN_START_DATE
             , PV_PLAN_END_DATE
             , PV_ACTUAL_START_DATE
             , PV_ACTUAL_END_DATE
             , VALID_YN
             , CREATION_DATE
             , LAST_UPDATE_DATE
          FROM SCM_MST_PROJECT_SCHEDULE;

        FOR R IN CUR_PROJECT LOOP
            V_IFSEQNO := R.IF_SEQ;

            MERGE INTO SCM_MST_PROJECT_SCHEDULE A
            USING (SELECT DISTINCT /* PR_SCM_MST_PROJECT_SCHEDULE */
                          A0.PROJECT_ID
                        , B0.DIVISION_ID AS DIVISION_ID
                        , NVL(B0.PROJECT_VER_SEQ, '/') AS PROJECT_VER_SEQ
                        , CASE A0.IF_TYPE WHEN 'D' THEN 'N' ELSE 'Y' END AS VALID_YN
                        , A0.CV_APP_PLAN_START_DATE
                        , A0.CV_APP_PLAN_END_DATE
                        , A0.CV_PLAN_START_DATE
                        , A0.CV_PLAN_END_DATE
                        , A0.CV_ACTUAL_START_DATE
                        , A0.CV_ACTUAL_END_DATE
                        , A0.DV_APP_PLAN_START_DATE
                        , A0.DV_APP_PLAN_END_DATE
                        , A0.DV_PLAN_START_DATE
                        , A0.DV_PLAN_END_DATE
                        , A0.DV_ACTUAL_START_DATE
                        , A0.DV_ACTUAL_END_DATE
                        , A0.PD_APP_PLAN_START_DATE
                        , A0.PD_APP_PLAN_END_DATE
                        , A0.PD_PLAN_START_DATE
                        , A0.PD_PLAN_END_DATE
                        , A0.PD_ACTUAL_START_DATE
                        , A0.PD_ACTUAL_END_DATE
                        , A0.PV_APP_PLAN_START_DATE
                        , A0.PV_APP_PLAN_END_DATE
                        , A0.PV_PLAN_START_DATE
                        , A0.PV_PLAN_END_DATE
                        , A0.PV_ACTUAL_START_DATE
                        , A0.PV_ACTUAL_END_DATE
                     FROM XIF_PLM_PJT_SCHEDULE_R_SN A0
                        , (SELECT * FROM SCM_MST_PROJECT_MAPPING) B0
                    /* ★MSSQL nchar 는 = 비교에서 후행 공백을 무시한다(blank-padded). Oracle VARCHAR2 는 구분하므로 RTRIM 으로 원본과 같은 동작을 복원한다 — 없으면 이 조인이 0행이 되어 프로시저가 무동작한다. 2026-08-20 실측 : 조인 MSSQL 5,124,239행 vs ORACLE 0행 */
                    WHERE RTRIM(A0.PROJECT_ID) = RTRIM(B0.GPLM_PROJECT_CODE)
                      AND A0.IF_SEQ     = V_IFSEQNO
                      AND A0.ATTR_10    = 'P'
                      /* 김춘동 임시 처리 2025-11-30 */
                      AND A0.CV_APP_PLAN_START_DATE IS NOT NULL) B
            ON (A.DIVISION_ID  = B.DIVISION_ID
                AND A.PROJECT_CODE = B.PROJECT_ID
                /*AND A.project_ver_seq   =  B.project_ver_seq 수정 필요*/
               )
            WHEN MATCHED THEN
                UPDATE
                   SET A.CV_APP_PLAN_START_DATE = B.CV_APP_PLAN_START_DATE
                     , A.CV_APP_PLAN_END_DATE   = B.CV_APP_PLAN_END_DATE
                     , A.CV_PLAN_START_DATE     = B.CV_PLAN_START_DATE
                     , A.CV_PLAN_END_DATE       = B.CV_PLAN_END_DATE
                     , A.CV_ACTUAL_START_DATE   = B.CV_ACTUAL_START_DATE
                     , A.CV_ACTUAL_END_DATE     = B.CV_ACTUAL_END_DATE
                     , A.DV_APP_PLAN_START_DATE = B.DV_APP_PLAN_START_DATE
                     , A.DV_APP_PLAN_END_DATE   = B.DV_APP_PLAN_END_DATE
                     , A.DV_PLAN_START_DATE     = B.DV_PLAN_START_DATE
                     , A.DV_PLAN_END_DATE       = B.DV_PLAN_END_DATE
                     , A.DV_ACTUAL_START_DATE   = B.DV_ACTUAL_START_DATE
                     , A.DV_ACTUAL_END_DATE     = B.DV_ACTUAL_END_DATE
                     , A.PD_APP_PLAN_START_DATE = B.PD_APP_PLAN_START_DATE
                     , A.PD_APP_PLAN_END_DATE   = B.PD_APP_PLAN_END_DATE
                     , A.PD_PLAN_START_DATE     = B.PD_PLAN_START_DATE
                     , A.PD_PLAN_END_DATE       = B.PD_PLAN_END_DATE
                     , A.PD_ACTUAL_START_DATE   = B.PD_ACTUAL_START_DATE
                     , A.PD_ACTUAL_END_DATE     = B.PD_ACTUAL_END_DATE
                     , A.PV_APP_PLAN_START_DATE = B.PV_APP_PLAN_START_DATE
                     , A.PV_APP_PLAN_END_DATE   = B.PV_APP_PLAN_END_DATE
                     , A.PV_PLAN_START_DATE     = B.PV_PLAN_START_DATE
                     , A.PV_PLAN_END_DATE       = B.PV_PLAN_END_DATE
                     , A.PV_ACTUAL_START_DATE   = B.PV_ACTUAL_START_DATE
                     , A.PV_ACTUAL_END_DATE     = B.PV_ACTUAL_END_DATE
                     , A.VALID_YN               = B.VALID_YN
                     , A.LAST_UPDATED_BY        = V_BATCH_USER
                     , A.LAST_UPDATE_DATE       = SYSDATE
            WHEN NOT MATCHED THEN
                INSERT ( DIVISION_ID
                       , PROJECT_CODE
                       , PROJECT_VER_SEQ
                       , CV_APP_PLAN_START_DATE
                       , CV_APP_PLAN_END_DATE
                       , CV_PLAN_START_DATE
                       , CV_PLAN_END_DATE
                       , CV_ACTUAL_START_DATE
                       , CV_ACTUAL_END_DATE
                       , DV_APP_PLAN_START_DATE
                       , DV_APP_PLAN_END_DATE
                       , DV_PLAN_START_DATE
                       , DV_PLAN_END_DATE
                       , DV_ACTUAL_START_DATE
                       , DV_ACTUAL_END_DATE
                       , PD_APP_PLAN_START_DATE
                       , PD_APP_PLAN_END_DATE
                       , PD_PLAN_START_DATE
                       , PD_PLAN_END_DATE
                       , PD_ACTUAL_START_DATE
                       , PD_ACTUAL_END_DATE
                       , PV_APP_PLAN_START_DATE
                       , PV_APP_PLAN_END_DATE
                       , PV_PLAN_START_DATE
                       , PV_PLAN_END_DATE
                       , PV_ACTUAL_START_DATE
                       , PV_ACTUAL_END_DATE
                       , VALID_YN
                       , CREATED_BY
                       , CREATION_DATE
                       , LAST_UPDATED_BY
                       , LAST_UPDATE_DATE )
                VALUES ( B.DIVISION_ID
                       , B.PROJECT_ID
                       , B.PROJECT_VER_SEQ
                       , B.CV_APP_PLAN_START_DATE
                       , B.CV_APP_PLAN_END_DATE
                       , B.CV_PLAN_START_DATE
                       , B.CV_PLAN_END_DATE
                       , B.CV_ACTUAL_START_DATE
                       , B.CV_ACTUAL_END_DATE
                       , B.DV_APP_PLAN_START_DATE
                       , B.DV_APP_PLAN_END_DATE
                       , B.DV_PLAN_START_DATE
                       , B.DV_PLAN_END_DATE
                       , B.DV_ACTUAL_START_DATE
                       , B.DV_ACTUAL_END_DATE
                       , B.PD_APP_PLAN_START_DATE
                       , B.PD_APP_PLAN_END_DATE
                       , B.PD_PLAN_START_DATE
                       , B.PD_PLAN_END_DATE
                       , B.PD_ACTUAL_START_DATE
                       , B.PD_ACTUAL_END_DATE
                       , B.PV_APP_PLAN_START_DATE
                       , B.PV_APP_PLAN_END_DATE
                       , B.PV_PLAN_START_DATE
                       , B.PV_PLAN_END_DATE
                       , B.PV_ACTUAL_START_DATE
                       , B.PV_ACTUAL_END_DATE
                       , B.VALID_YN
                       , V_BATCH_USER
                       , SYSDATE
                       , V_BATCH_USER
                       , SYSDATE );

            /* 처리 row 마킹 */
            UPDATE XIF_PLM_PJT_SCHEDULE_R_SN
               SET ATTR_10 = 'Y'
             WHERE IF_SEQ  = V_IFSEQNO
               AND ATTR_10 = 'P'
               /* ★MSSQL nchar 는 = 비교에서 후행 공백을 무시한다(blank-padded). Oracle VARCHAR2 는 구분하므로 RTRIM 으로 원본과 같은 동작을 복원한다 — 없으면 이 조인이 0행이 되어 프로시저가 무동작한다. 2026-08-20 실측 : 조인 MSSQL 5,124,239행 vs ORACLE 0행 */
               AND RTRIM(PROJECT_ID) IN (SELECT RTRIM(GPLM_PROJECT_CODE)
                                           FROM SCM_MST_PROJECT_MAPPING);

            /* --------------------------------------------------------- */
            /* Merge LOG */
            /* --------------------------------------------------------- */
            V_LOG_TYPE    := 'APPEND';
            V_LOG_MESSAGE := 'MERGE INTO scm_mst_project_schedule';
            V_DESCRIPTION := 'if_seq = ' || V_IFSEQNO;
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            /* --------------------------------------------------------- */
        END LOOP;

        /* History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리 */
        N_HISTORY_SEQ := SEQ1_SCM_MST_PROJECT_SCHEDULE_H.NEXTVAL;
        INSERT
          INTO SCM_MST_PROJECT_SCHEDULE_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PROJECT_CODE
             , PROJECT_VER_SEQ
             , CV_APP_PLAN_START_DATE
             , CV_APP_PLAN_END_DATE
             , CV_PLAN_START_DATE
             , CV_PLAN_END_DATE
             , CV_ACTUAL_START_DATE
             , CV_ACTUAL_END_DATE
             , DV_APP_PLAN_START_DATE
             , DV_APP_PLAN_END_DATE
             , DV_PLAN_START_DATE
             , DV_PLAN_END_DATE
             , DV_ACTUAL_START_DATE
             , DV_ACTUAL_END_DATE
             , PD_APP_PLAN_START_DATE
             , PD_APP_PLAN_END_DATE
             , PD_PLAN_START_DATE
             , PD_PLAN_END_DATE
             , PD_ACTUAL_START_DATE
             , PD_ACTUAL_END_DATE
             , PV_APP_PLAN_START_DATE
             , PV_APP_PLAN_END_DATE
             , PV_PLAN_START_DATE
             , PV_PLAN_END_DATE
             , PV_ACTUAL_START_DATE
             , PV_ACTUAL_END_DATE
             , VALID_YN
             , CREATION_DATE
             , LAST_UPDATE_DATE
             , CREATED_BY
             , LAST_UPDATED_BY
             , HISTORY_CREATION_DATE )
        SELECT N_HISTORY_SEQ
             , A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_VER_SEQ
             , A.CV_APP_PLAN_START_DATE
             , A.CV_APP_PLAN_END_DATE
             , A.CV_PLAN_START_DATE
             , A.CV_PLAN_END_DATE
             , A.CV_ACTUAL_START_DATE
             , A.CV_ACTUAL_END_DATE
             , A.DV_APP_PLAN_START_DATE
             , A.DV_APP_PLAN_END_DATE
             , A.DV_PLAN_START_DATE
             , A.DV_PLAN_END_DATE
             , A.DV_ACTUAL_START_DATE
             , A.DV_ACTUAL_END_DATE
             , A.PD_APP_PLAN_START_DATE
             , A.PD_APP_PLAN_END_DATE
             , A.PD_PLAN_START_DATE
             , A.PD_PLAN_END_DATE
             , A.PD_ACTUAL_START_DATE
             , A.PD_ACTUAL_END_DATE
             , A.PV_APP_PLAN_START_DATE
             , A.PV_APP_PLAN_END_DATE
             , A.PV_PLAN_START_DATE
             , A.PV_PLAN_END_DATE
             , A.PV_ACTUAL_START_DATE
             , A.PV_ACTUAL_END_DATE
             , A.VALID_YN
             , A.CREATION_DATE
             , A.LAST_UPDATE_DATE
             , V_BATCH_USER
             , V_BATCH_USER
             , SYSDATE
          FROM (SELECT A.DIVISION_ID
                     , A.PROJECT_CODE
                     , A.PROJECT_VER_SEQ
                     , A.CV_APP_PLAN_START_DATE
                     , A.CV_APP_PLAN_END_DATE
                     , A.CV_PLAN_START_DATE
                     , A.CV_PLAN_END_DATE
                     , A.CV_ACTUAL_START_DATE
                     , A.CV_ACTUAL_END_DATE
                     , A.DV_APP_PLAN_START_DATE
                     , A.DV_APP_PLAN_END_DATE
                     , A.DV_PLAN_START_DATE
                     , A.DV_PLAN_END_DATE
                     , A.DV_ACTUAL_START_DATE
                     , A.DV_ACTUAL_END_DATE
                     , A.PD_APP_PLAN_START_DATE
                     , A.PD_APP_PLAN_END_DATE
                     , A.PD_PLAN_START_DATE
                     , A.PD_PLAN_END_DATE
                     , A.PD_ACTUAL_START_DATE
                     , A.PD_ACTUAL_END_DATE
                     , A.PV_APP_PLAN_START_DATE
                     , A.PV_APP_PLAN_END_DATE
                     , A.PV_PLAN_START_DATE
                     , A.PV_PLAN_END_DATE
                     , A.PV_ACTUAL_START_DATE
                     , A.PV_ACTUAL_END_DATE
                     , A.VALID_YN
                     , B.CREATION_DATE
                     , B.LAST_UPDATE_DATE
                  FROM (SELECT /* scm_mst_project_schedule_h */
                               DIVISION_ID
                             , PROJECT_CODE
                             , PROJECT_VER_SEQ
                             , CV_APP_PLAN_START_DATE
                             , CV_APP_PLAN_END_DATE
                             , CV_PLAN_START_DATE
                             , CV_PLAN_END_DATE
                             , CV_ACTUAL_START_DATE
                             , CV_ACTUAL_END_DATE
                             , DV_APP_PLAN_START_DATE
                             , DV_APP_PLAN_END_DATE
                             , DV_PLAN_START_DATE
                             , DV_PLAN_END_DATE
                             , DV_ACTUAL_START_DATE
                             , DV_ACTUAL_END_DATE
                             , PD_APP_PLAN_START_DATE
                             , PD_APP_PLAN_END_DATE
                             , PD_PLAN_START_DATE
                             , PD_PLAN_END_DATE
                             , PD_ACTUAL_START_DATE
                             , PD_ACTUAL_END_DATE
                             , PV_APP_PLAN_START_DATE
                             , PV_APP_PLAN_END_DATE
                             , PV_PLAN_START_DATE
                             , PV_PLAN_END_DATE
                             , PV_ACTUAL_START_DATE
                             , PV_ACTUAL_END_DATE
                             , VALID_YN
                          FROM GT_SMPS_SCHEDULE
                        MINUS
                        SELECT /* scm_mst_project_schedule_h */
                               DIVISION_ID
                             , PROJECT_CODE
                             , PROJECT_VER_SEQ
                             , CV_APP_PLAN_START_DATE
                             , CV_APP_PLAN_END_DATE
                             , CV_PLAN_START_DATE
                             , CV_PLAN_END_DATE
                             , CV_ACTUAL_START_DATE
                             , CV_ACTUAL_END_DATE
                             , DV_APP_PLAN_START_DATE
                             , DV_APP_PLAN_END_DATE
                             , DV_PLAN_START_DATE
                             , DV_PLAN_END_DATE
                             , DV_ACTUAL_START_DATE
                             , DV_ACTUAL_END_DATE
                             , PD_APP_PLAN_START_DATE
                             , PD_APP_PLAN_END_DATE
                             , PD_PLAN_START_DATE
                             , PD_PLAN_END_DATE
                             , PD_ACTUAL_START_DATE
                             , PD_ACTUAL_END_DATE
                             , PV_APP_PLAN_START_DATE
                             , PV_APP_PLAN_END_DATE
                             , PV_PLAN_START_DATE
                             , PV_PLAN_END_DATE
                             , PV_ACTUAL_START_DATE
                             , PV_ACTUAL_END_DATE
                             , VALID_YN
                          FROM SCM_MST_PROJECT_SCHEDULE) A
                     , GT_SMPS_SCHEDULE B
                 WHERE A.DIVISION_ID     = B.DIVISION_ID
                   AND A.PROJECT_CODE    = B.PROJECT_CODE
                   AND A.PROJECT_VER_SEQ = B.PROJECT_VER_SEQ) A;
        N_LOG_COUNT := SQL%ROWCOUNT;

        /* 처리 안된 row 마킹 */
        UPDATE XIF_PLM_PJT_SCHEDULE_R_SN
           SET ATTR_10 = 'X'
         WHERE ATTR_10 = 'P';

        /* HISTORY LOG */
        V_LOG_TYPE    := 'HISTORY';
        V_LOG_MESSAGE := 'INSERT INTO scm_mst_project_schedule_h';
        V_DESCRIPTION := '@n_history_seq' || ':' || TO_CHAR(N_HISTORY_SEQ);
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);


    EXCEPTION
        WHEN OTHERS THEN

            /* ERROR LOG */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END PR_SCM_MST_PROJECT_SCHEDULE;
/
SHOW ERRORS PROCEDURE PR_SCM_MST_PROJECT_SCHEDULE
