PACKAGE BODY           "PKG_SCM0000"
AS

PROCEDURE P_SCM0000_GET_SRCH_COND (
    P_USER_ID         IN VARCHAR2,
    P_MNU_ID          IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR
) IS

/*
*===================================================================================================
* Program ID   : P_SCM0000_GET_SRCH_COND
* Description  : 화면별 검색조건 조회
* Program History
*===================================================================================================
* Date          In Charge       Description
*===================================================================================================
* 2026.03.24   park.choyi       Search Condition (UP_FX_GetSearchCondition)
*===================================================================================================
*/

    V_ROW_CNT   NUMBER := 0;
    V_SQL_CODE  VARCHAR2(50);
    V_ERR_MSG   VARCHAR2(4000);
BEGIN
    OPEN O_RC1 FOR
        SELECT PRAM_NM, PRAM_CTN
        FROM SCM_ADM_USER_MNU_SRCH_COND_M
        WHERE USER_ID = P_USER_ID
          AND MNU_ID  = P_MNU_ID
        ORDER BY PRAM_NM;

    -- 조회건수 계산
    SELECT COUNT(*)
      INTO V_ROW_CNT
      FROM SCM_ADM_USER_MNU_SRCH_COND_M
     WHERE USER_ID = P_USER_ID
       AND MNU_ID  = P_MNU_ID;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE);
        V_ERR_MSG  := SQLERRM;

        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_ERR_MSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' ||
            'P_USER_ID=' || NVL(P_USER_ID, 'NULL') ||
            ',P_MNU_ID=' || NVL(P_MNU_ID, 'NULL')
        );
END P_SCM0000_GET_SRCH_COND;


PROCEDURE P_SCM0000_RESET_SRCH_COND (
    P_USER_ID         IN VARCHAR2,
    P_MNU_ID          IN VARCHAR2
) IS

/*
*===================================================================================================
* Program ID   : P_SCM0000_RESET_SRCH_COND
* Description  : 화면별 검색조건 삭제
* Program History
*===================================================================================================
* Date          In Charge       Description
*===================================================================================================
* 2022.05.20	chaan           V1.0    Inititialize
* 2026.03.24   park.choyi     Search Condition (UP_FX_ResetSearchCondition)
*===================================================================================================
*/
    V_ROW_CNT    NUMBER := 0;
    V_SQL_CODE   VARCHAR2(50);
    V_ERR_MSG    VARCHAR2(4000);
BEGIN
    DELETE FROM SCM_ADM_USER_MNU_SRCH_COND_M
     WHERE USER_ID = P_USER_ID
       AND MNU_ID  = P_MNU_ID;

    V_ROW_CNT := SQL%ROWCOUNT;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE);
        V_ERR_MSG  := SQLERRM;

        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_ERR_MSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || 'P_USER_ID=' || NVL(P_USER_ID, 'NULL') ||
            ',P_MNU_ID=' || NVL(P_MNU_ID, 'NULL')
        );
END P_SCM0000_RESET_SRCH_COND;


PROCEDURE P_SCM0000_SAVE_SRCH_COND (
    P_USER_ID         IN VARCHAR2,
    P_MNU_ID          IN VARCHAR2,
    P_DATA            IN CLOB
) IS

/*
*===================================================================================================
* Program ID   : P_SCM0000_SAVE_SRCH_COND
* Description  : 화면별 검색조건 저장
* Program History
*===================================================================================================
* Date          In Charge       Description
*===================================================================================================
* 2020-07-07   khj79      [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 @ControlValue SIZE 변경(255=>4000)
* 2026.03.24   park.choyi     Search Condition (UP_FX_SaveSearchCondition)
*===================================================================================================
*/

    V_ROW_CNT    NUMBER := 0;
    V_SQL_CODE   VARCHAR2(50);
    V_ERR_MSG    VARCHAR2(4000);


  V_PROGRAM_NAME      VARCHAR2(200) := $$PLSQL_UNIT;
  v_log_type          VARCHAR2(30 CHAR); -- START/END/ERROR/...
  n_log_count         PLS_INTEGER        := 0;
  v_log_message       VARCHAR2(1000 CHAR);
  v_description       VARCHAR2(1000 CHAR);
  d_event_date        DATE;
BEGIN


    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

  v_log_type    := 'START';
  v_log_message := '########## Start of procedure ##########';
  v_description := '';
  d_event_date  := SYSDATE;
  BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


  -- P_DATA 로그 (CLOB chunk)
  DECLARE
      V_CLOB_LEN   PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_DATA), 0);
      V_POS        PLS_INTEGER := 1;
      V_CHUNK_SIZE PLS_INTEGER := 1000; -- 로그 1건당 길이
      V_CHUNK      VARCHAR2(4000);
      V_IDX        PLS_INTEGER := 1;
  BEGIN
      -- 전체 길이 로그
      v_log_type    := 'ING';
      v_log_message := 'P_DATA LENGTH';
      v_description := 'P_DATA_LEN=' || TO_CHAR(V_CLOB_LEN);
      d_event_date  := SYSDATE;
      SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

      -- 내용 로그 (분할)
      WHILE V_POS <= V_CLOB_LEN LOOP
          V_CHUNK := DBMS_LOB.SUBSTR(P_DATA, V_CHUNK_SIZE, V_POS);

          v_log_type    := 'ING';
          v_log_message := 'P_DATA CHUNK ' || TO_CHAR(V_IDX);
          v_description := V_CHUNK;
          d_event_date  := SYSDATE;
          SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

          V_POS := V_POS + V_CHUNK_SIZE;
          V_IDX := V_IDX + 1;
      END LOOP;
  END;

    DELETE FROM SCM_ADM_USER_MNU_SRCH_COND_M
     WHERE USER_ID = P_USER_ID
       AND MNU_ID  = P_MNU_ID;


    v_log_type    := 'ING';
    v_log_message := '';
    v_description := 'P_USER_ID : ''' || P_USER_ID || ''', P_MNU_ID : ''' || P_MNU_ID || '''';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;



    FOR R IN (
        SELECT
              TRIM(JT.PRAM_NM)  AS PRAM_NM
            , JT.PRAM_CTN       AS PRAM_CTN
          FROM JSON_TABLE(
              P_DATA,
              '$[*]'
              COLUMNS (
                    PRAM_NM   VARCHAR2(200)   PATH '$."PRAM_NM"'  NULL ON EMPTY NULL ON ERROR
                  , PRAM_CTN  VARCHAR2(4000)  PATH '$."PRAM_CTN"' NULL ON EMPTY NULL ON ERROR
              )
          ) JT
     WHERE TRIM(JT.PRAM_NM) IS NOT NULL
       AND TRIM(JT.PRAM_CTN) IS NOT NULL
    ) LOOP

        MERGE INTO SCM_ADM_USER_MNU_SRCH_COND_M T
        USING (
            SELECT P_USER_ID  AS USER_ID
                 , P_MNU_ID   AS MNU_ID
                 , R.PRAM_NM  AS PRAM_NM
                 , R.PRAM_CTN AS PRAM_CTN
              FROM DUAL
        ) S
        ON (
                T.USER_ID = S.USER_ID
            AND T.MNU_ID  = S.MNU_ID
            AND T.PRAM_NM = S.PRAM_NM
        )
        WHEN MATCHED THEN
            UPDATE SET
                  T.PRAM_CTN         = S.PRAM_CTN
                , T.LAST_UPDATED_BY  = S.USER_ID
                , T.LAST_UPDATE_DATE = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (
                  USER_ID, MNU_ID, PRAM_NM, PRAM_CTN
                , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            )
            VALUES (
                  S.USER_ID, S.MNU_ID, S.PRAM_NM, S.PRAM_CTN
                , S.USER_ID, SYSDATE, S.USER_ID, SYSDATE
            );

        V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    END LOOP;

    COMMIT;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE);
        V_ERR_MSG  := SQLERRM;

        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_ERR_MSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' ||
            'P_USER_ID=' || NVL(P_USER_ID, 'NULL') ||
            ',P_MNU_ID=' || NVL(P_MNU_ID, 'NULL')
        );

END P_SCM0000_SAVE_SRCH_COND;

END PKG_SCM0000;