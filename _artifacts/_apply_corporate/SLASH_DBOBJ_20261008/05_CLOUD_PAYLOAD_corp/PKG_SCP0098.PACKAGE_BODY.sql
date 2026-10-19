PACKAGE BODY PKG_SCP0098 IS

/*==================================================================================================
 * Program ID   : [SCP0098_COPY_MONTH_WEEK]
 * Description  : 전 주차 & 전 월 카테고리 정보 복사
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/04/01   LJS			    init
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 *==================================================================================================*/
    PROCEDURE P_COPY_MONTH_WEEK (
        P_USER_ID       IN  VARCHAR2 DEFAULT '-'
      , P_DAY_TYPE      IN  VARCHAR2 DEFAULT '-'
      , P_DEBUG_MODE    IN  VARCHAR2 DEFAULT '-'
      , O_RC            OUT SYS_REFCURSOR
      , O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    IS
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0098_COPY_MONTH_WEEK';
        V_LOG_TYPE          VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
        N_LOG_COUNT         NUMBER(10) := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;

        /* 예외처리 변수 설정 */
        V_ERR_CODE          NUMBER(10);
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);

        /* 실행시간 확인용 */
        V_START_TIME        DATE := SYSDATE;
        V_EXEC_TIME         VARCHAR2(10 CHAR) := '';
        V_EXEC_SEC          NUMBER(10) := 0;

        V_USERID            VARCHAR2(4000 CHAR);
        V_TYPE              VARCHAR2(4000 CHAR);
        V_DEBUG             VARCHAR2(4000 CHAR);

        V_CURWEEK           VARCHAR2(24 CHAR);  /* 금주 */
        V_BEFWEEK           VARCHAR2(24 CHAR);  /* 전주 */
        V_CURMONTH          VARCHAR2(24 CHAR);  /* 금월 */
        V_BEFMONTH          VARCHAR2(24 CHAR);  /* 전월 */
    BEGIN

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        V_USERID := P_USER_ID;
        V_TYPE   := P_DAY_TYPE;
        V_DEBUG  := P_DEBUG_MODE;

        BEGIN
            SELECT ISO_YYYYWW
              INTO V_CURWEEK
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
               AND ROWNUM = 1
            ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_CURWEEK := NULL;
        END;

        BEGIN
            SELECT ISO_YYYYWW
              INTO V_BEFWEEK
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')
               AND ROWNUM = 1
            ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_BEFWEEK := NULL;
        END;

        BEGIN
            SELECT BASIS_YYYYMM
              INTO V_CURMONTH
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
               AND ROWNUM = 1
            ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_CURMONTH := NULL;
        END;

        BEGIN
            SELECT BASIS_YYYYMM
              INTO V_BEFMONTH
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD = TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYYMMDD')
               AND ROWNUM = 1
            ;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_BEFMONTH := NULL;
        END;

        IF V_TYPE = 'WEEK' THEN

            /* 주 복사(실제는 일단위) : 전주 -> 당주 */
            /* AS-IS MERGE 를 UPDATE + INSERT 로 나눈 것 (온라인 SQL 은 MERGE 를 쓰지 않는다) */
            UPDATE SCP_MST_CAPA_WORK A
               SET ( A.VALUE
                   , A.LAST_UPDATED_BY
                   , A.LAST_UPDATE_DATE )
                   = ( SELECT SA.VALUE
                            , 'COPY_WEEK_' || V_USERID
                            , SYSDATE
                         FROM SCP_MST_CAPA_WORK SA
                            , SCM_SYS_CALENDAR_M SB
                        WHERE SA.YYYYMMDD     = SB.BASIS_YYYYMMDD
                          AND SA.DIVISION_ID  = A.DIVISION_ID
                          AND SA.PLANT_ID     = A.PLANT_ID
                          AND SA.FACTORY_ID   = A.FACTORY_ID
                          AND SA.OPERATION_ID = A.OPERATION_ID
                          AND SA.LINE_ID      = A.LINE_ID
                          AND SA.MEASURE      = A.MEASURE
                          AND TO_CHAR(SB.BASIS_DATE + 7, 'YYYYMMDD') = A.YYYYMMDD
                          AND SB.ISO_YYYYWW   = V_BEFWEEK
                          AND SA.MEASURE      IN ( 'DAILY_CAPA', 'LOAD_RATE', 'NO_WORK', 'RAMP_UP' ) )
             WHERE EXISTS ( SELECT 1
                              FROM SCP_MST_CAPA_WORK SA
                                 , SCM_SYS_CALENDAR_M SB
                             WHERE SA.YYYYMMDD     = SB.BASIS_YYYYMMDD
                               AND SA.DIVISION_ID  = A.DIVISION_ID
                               AND SA.PLANT_ID     = A.PLANT_ID
                               AND SA.FACTORY_ID   = A.FACTORY_ID
                               AND SA.OPERATION_ID = A.OPERATION_ID
                               AND SA.LINE_ID      = A.LINE_ID
                               AND SA.MEASURE      = A.MEASURE
                               AND TO_CHAR(SB.BASIS_DATE + 7, 'YYYYMMDD') = A.YYYYMMDD
                               AND SB.ISO_YYYYWW   = V_BEFWEEK
                               AND SA.MEASURE      IN ( 'DAILY_CAPA', 'LOAD_RATE', 'NO_WORK', 'RAMP_UP' ) )
            ;

            INSERT INTO SCP_MST_CAPA_WORK
                 ( DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID
                 , MEASURE, YYYYMMDD, VALUE
                 , CREATED_BY, CREATION_DATE
                 , LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                 , PROD_READY_RATE
                 )
            SELECT A.DIVISION_ID
                 , A.PLANT_ID
                 , A.FACTORY_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.MEASURE
                 , TO_CHAR(B.BASIS_DATE + 7, 'YYYYMMDD') AS YYYYMMDD
                 , A.VALUE
                 , 'COPY_WEEK_' || V_USERID              AS CREATED_BY
                 , SYSDATE                               AS CREATION_DATE
                 , 'COPY_WEEK_' || V_USERID              AS LAST_UPDATED_BY
                 , SYSDATE                               AS LAST_UPDATE_DATE
                 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
                 , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
                 , A.PROD_READY_RATE
              FROM SCP_MST_CAPA_WORK A
                 , SCM_SYS_CALENDAR_M B
             WHERE A.YYYYMMDD   = B.BASIS_YYYYMMDD
               AND NOT EXISTS ( SELECT 1
                                  FROM SCP_MST_CAPA_WORK SA
                                 WHERE SA.DIVISION_ID  = A.DIVISION_ID
                                   AND SA.PLANT_ID     = A.PLANT_ID
                                   AND SA.FACTORY_ID   = A.FACTORY_ID
                                   AND SA.OPERATION_ID = A.OPERATION_ID
                                   AND SA.LINE_ID      = A.LINE_ID
                                   AND SA.MEASURE      = A.MEASURE
                                   AND SA.YYYYMMDD     = TO_CHAR(B.BASIS_DATE + 7, 'YYYYMMDD') )
               AND B.ISO_YYYYWW = V_BEFWEEK
               AND A.MEASURE    IN ( 'DAILY_CAPA', 'LOAD_RATE', 'NO_WORK', 'RAMP_UP' )
            ;

        ELSE /* @v_type = 'MONTH' */

            /* 월복사 : 전월->당월 */
            UPDATE SCP_MST_CAPA A
               SET ( A.VALUE
                   , A.LAST_UPDATED_BY
                   , A.LAST_UPDATE_DATE )
                   = ( SELECT SA.VALUE
                            , 'COPY_MONTH_' || V_USERID
                            , SYSDATE
                         FROM SCP_MST_CAPA SA
                        WHERE SA.DIVISION_ID  = A.DIVISION_ID
                          AND SA.PLANT_ID     = A.PLANT_ID
                          AND SA.FACTORY_ID   = A.FACTORY_ID
                          AND SA.OPERATION_ID = A.OPERATION_ID
                          AND SA.LINE_ID      = A.LINE_ID
                          AND SA.ITEM_ID      = A.ITEM_ID
                          AND SA.YYYYMM       = V_BEFMONTH
                          AND A.YYYYMM        = V_CURMONTH )
             WHERE EXISTS ( SELECT 1
                              FROM SCP_MST_CAPA SA
                             WHERE SA.DIVISION_ID  = A.DIVISION_ID
                               AND SA.PLANT_ID     = A.PLANT_ID
                               AND SA.FACTORY_ID   = A.FACTORY_ID
                               AND SA.OPERATION_ID = A.OPERATION_ID
                               AND SA.LINE_ID      = A.LINE_ID
                               AND SA.ITEM_ID      = A.ITEM_ID
                               AND SA.YYYYMM       = V_BEFMONTH
                               AND A.YYYYMM        = V_CURMONTH )
            ;

            INSERT INTO SCP_MST_CAPA
                 ( DIVISION_ID, PLANT_ID, FACTORY_ID, OPERATION_ID
                 , LINE_ID, ITEM_ID
                 , YYYYMM, VALUE
                 , CREATED_BY, CREATION_DATE
                 , LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                 )
            SELECT A.DIVISION_ID
                 , A.PLANT_ID
                 , A.FACTORY_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.ITEM_ID
                 , V_CURMONTH                             AS YYYYMM
                 , A.VALUE
                 , 'COPY_MONTH_' || V_USERID              AS CREATED_BY     /* user_id */
                 , SYSDATE                                AS CREATION_DATE
                 , 'COPY_MONTH_' || V_USERID              AS LAST_UPDATED_BY /* user_id */
                 , SYSDATE                                AS LAST_UPDATE_DATE
                 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
                 , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
              FROM SCP_MST_CAPA A
             WHERE NOT EXISTS ( SELECT 1
                                  FROM SCP_MST_CAPA SA
                                 WHERE SA.DIVISION_ID  = A.DIVISION_ID
                                   AND SA.PLANT_ID     = A.PLANT_ID
                                   AND SA.FACTORY_ID   = A.FACTORY_ID
                                   AND SA.OPERATION_ID = A.OPERATION_ID
                                   AND SA.LINE_ID      = A.LINE_ID
                                   AND SA.ITEM_ID      = A.ITEM_ID
                                   AND SA.YYYYMM       = V_CURMONTH )
               AND A.YYYYMM = V_BEFMONTH
            ;

        END IF;

        /* 임시 운영반영시에 주석처리 할것. */
        V_EXEC_SEC  := ROUND((SYSDATE - V_START_TIME) * 86400);
        V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(V_EXEC_SEC / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(V_EXEC_SEC, 60)), 2, '0');

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC FOR
            SELECT 'S' AS RESULT_CODE
                 , 1   AS RESULT_CNT
              FROM DUAL
        ;

        OPEN O_RESULT_CURSOR FOR
            SELECT NULL AS ERR_CODE
                 , NULL AS ERR_MESSAGE
              FROM DUAL
             WHERE 1 = 0
        ;

    EXCEPTION
        WHEN OTHERS THEN
            /* AS-IS 는 CATCH 에서 입력 데이타 롤백을 주석으로 막아 두었다. 같은 동작으로 둔다. */
            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            INSERT INTO SCM_SYS_LOG_BATCH ( PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY )
            VALUES ( V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL, SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME )
            ;

            OPEN O_RC FOR
                SELECT 'S' AS RESULT_CODE
                     , 1   AS RESULT_CNT
                  FROM DUAL
                 WHERE 1 = 0
            ;

            /* 에러 메시지, 에러 데이터  반환 */
            OPEN O_RESULT_CURSOR FOR
                SELECT V_ERR_CODE    AS ERR_CODE
                     , V_ERR_MESSAGE AS ERR_MESSAGE
                  FROM DUAL
            ;
    END P_COPY_MONTH_WEEK;

/*==================================================================================================
 * Program ID   : SCP0098_GET_CAPA_MobilityIT
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/07/19   khj79          최초작성 - SCP0049_GET_CAPA 참조 => SCP0013 ,Production Plan Line 참조
 * 2020/08/21   khj79          최초작성 - SCP0049_GET_CAPA 참조 => Line Assign / Operation / LOCATION_GROUP_ROUTE
 * 2023/08/23   vadabi3        PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 PIVOT
 * 2023/09/06   vadabi3        PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 Version 2 - 조회 대상 개선
 * 2023/12/07   vadabi3        PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 속도개선
 * 2023/02/06   vadabi3        E20240207-001060 소형 CAPA 엑셀 다운로드 및 Plant 검색조건 수정 - plant site 조건 검색 미적용 수정
 * 2024/04/01   leejsthira2    오창, 월요일 조건으로 무조건 생산준비율 반영
 * 2025/08/01   hrkim		   PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.07   AJS          [속도2차] 생산준비율 반영 갱신을 행별 공장 집계 대신 값 조회로 · 월 칸(M_) 행별 하위질의를 한 번 집계해 붙임
 *==================================================================================================*/
    PROCEDURE P_GET_CAPA_MOBILITYIT (
        P_TODAY_YYYYMMDD    IN  VARCHAR2
      , P_FROM_YYYYMMDD     IN  VARCHAR2
      , P_TO_YYYYMMDD       IN  VARCHAR2
      , P_DIVISION_ID       IN  VARCHAR2
      , P_PLANT_ID          IN  VARCHAR2
      , P_LINE_ID           IN  VARCHAR2
      , P_OPERATION_ID      IN  VARCHAR2
      , P_MODEL_ID          IN  VARCHAR2
      , P_ITEM_ID           IN  VARCHAR2
      , P_NICK_NAME         IN  VARCHAR2
      , P_BUCKET            IN  VARCHAR2
      , P_USER_ID           IN  VARCHAR2
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC                OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        /* Declare */
        V_PROGRAM_ID            VARCHAR2(400 CHAR) := 'SCP0098';
        V_SHEET_NAME            VARCHAR2(600 CHAR) := 'CAPA_SMALL';
        V_TODAY_YYYYMM          VARCHAR2(6 CHAR);
        V_PLANT_ID              VARCHAR2(4000 CHAR);

        /* 날짜 조건용 변수 설정 */
        V_START_MONTH           VARCHAR2(6 CHAR);   /* 시작 월(현재월 +1 년) */
        V_END_MONTH             VARCHAR2(6 CHAR);   /* 마지막 월 */

        V_TODAY_YYYYMM_FIRSTDAY VARCHAR2(8 CHAR);

        /* 쿼리 실행용 변수 */
        V_MEXEC                 CLOB;
        V_MQRY_FIELD            CLOB;   /* 피벗 칸 목록 (D_) */
        V_MQRY_FIELD_LAST       CLOB;   /* 최종 표기 변환 (D_) */
        V_MQRY_FIELD_PRODREADY  CLOB;   /* 월 칸 (M_) */
        V_PIVOT_AGG             CLOB;   /* 피벗 집계식 (D_) */
        V_OEE_PIVOT             CLOB;   /* 월 칸 집계식 (M_) */ /* AJS 20261007 속도 */

        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        /* GTT 초기화 (TRUNCATE 금지) */
        DELETE FROM GT_SCP0098_ITEM_LIST;
        DELETE FROM GT_SCP0098_ITEM_LIST_YYYYMM;
        DELETE FROM GT_SCP0098_STD_LINE_DATA;
        DELETE FROM GT_SCP0098_STD_ITEM_DATA;
        DELETE FROM GT_SCP0098_TARGET_MEASURE;
        DELETE FROM GT_SCP0098_LINE_MEASURE;
        DELETE FROM GT_SCP0098_LINE_MEAS_DIST;
        DELETE FROM GT_SCP0098_ITEM_MEASURE;
        DELETE FROM GT_SCP0098_PROD_READY_RATE;
        DELETE FROM GT_SCP0098_MEAS_WORK;
        DELETE FROM GT_SCP0098_DAILYCAPA_DAY;
        DELETE FROM GT_SCP0098_ITEM_LIST_TERM;
        DELETE FROM GT_SCP0098_MEAS_CAPA;
        DELETE FROM GT_SCP0098_MEAS_CAPA_NOWORK;
        DELETE FROM GT_SCP0098_OEE_TERM;
        DELETE FROM GT_SCP0098_CAPA_YMD;
        DELETE FROM GT_SCP0098_CAPA_YMD_CALC;

        V_TODAY_YYYYMM := SUBSTR(P_TODAY_YYYYMMDD, 1, 6);

        /* IF @p_plant_id = 'ALL' SET @p_plant_id = null; */
        IF P_PLANT_ID = 'ALL' THEN
            V_PLANT_ID := NULL;
        ELSE
            V_PLANT_ID := P_PLANT_ID;
        END IF;

        /* 조회 날짜 설정 */
        V_START_MONTH := SUBSTR(P_FROM_YYYYMMDD, 1, 6); /* 현재일 */
        V_END_MONTH   := SUBSTR(P_TO_YYYYMMDD  , 1, 6); /* 조회일자가 기준을 넘을 경우 Y+1 으로 조회 */

        V_TODAY_YYYYMM_FIRSTDAY := V_TODAY_YYYYMM || '01';

        /* #TMP_SCP0098_ITEM_LIST_ALL) LOCATION_GROUP_ROUTE */
        /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 — 테이블 변수 대신 IN 서브쿼리로 옮겼다 */
        INSERT INTO GT_SCP0098_ITEM_LIST
             ( DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , OPERATION_GROUP_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , ITEM_CLASS
             )
        SELECT DISTINCT
               IA.DIVISION_ID
             , IA.COMPANY_ID
             , IA.SITE_ID
             , IA.PLANT_ID
             , IA.OPERATION_GROUP_ID
             , IA.FACTORY_ID
             , IA.OPERATION_ID
             , IA.LINE_ID
             , XA.ITEM_ID
             , ( SELECT MAX(SA.ITEM_CLASS)
                   FROM SCM_ITEM_M_SN SA
                  WHERE SA.COMPANY_ID  = XA.COMPANY_ID
                    AND SA.DIVISION_ID = XA.DIVISION_ID
                    AND SA.SITE_ID     = XA.SITE_ID
                    AND SA.ITEM_ID     = XA.ITEM_ID
                    AND SA.ITEM_CLASS  = 'ES1901'
                    AND SA.ACTIVE_FLAG = 'Y'
                    AND XA.PRIORITY    NOT IN ('0', '9') ) AS ITEM_CLASS
          FROM ( SELECT DISTINCT
                        DIVISION_ID
                      , COMPANY_ID
                      , SITE_ID
                      , PLANT_ID
                      , OPERATION_GROUP_ID
                      , FACTORY_ID
                      , OPERATION_ID
                      , LINE_ID
                   FROM SCM_LINE_HIERARCHY_V_SN
                  WHERE OPERATION_ID IN ( SELECT SEGMENT1
                                            FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                           WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                             AND SEGMENT3    = 'A'   /* 공정그룹(Cell) */
                                             AND ATTRIBUTE1  = 'Y' ) /* Final Operation */
                    AND ( TRIM(P_DIVISION_ID) IS NULL OR DIVISION_ID IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_DIVISION_ID, ',')) ) )
                    AND ( TRIM(V_PLANT_ID)    IS NULL OR PLANT_ID || '-' || OPERATION_GROUP_ID IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_PLANT_ID, ',')) ) )
                    AND ( TRIM(P_LINE_ID)     IS NULL OR LINE_ID  IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_LINE_ID, ',')) ) )
               ) IA
             , ( SELECT SA.COMPANY_ID
                      , SA.DIVISION_ID
                      , SA.SITE_ID
                      , SA.PLANT_ID
                      , SA.FACTORY_ID
                      , SA.LINE_ID
                      , SA.OPERATION_ID
                      , SA.ITEM_ID
                      , SA.PRIORITY
                   FROM SCM_MST_ITEM_LINE_ASSIGN_SN SA
                  WHERE SA.MONTH   >= V_START_MONTH
                    AND SA.MONTH   <= V_END_MONTH
                    AND SA.ITEM_ID NOT LIKE 'AJR%'
                    AND SA.ITEM_ID IS NOT NULL
                    AND ( TRIM(P_ITEM_ID) IS NULL OR SA.ITEM_ID IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) ) )
               ) XA
         WHERE IA.DIVISION_ID  = XA.DIVISION_ID(+)
           AND IA.SITE_ID      = XA.SITE_ID(+)
           AND IA.PLANT_ID     = XA.PLANT_ID(+)
           AND IA.FACTORY_ID   = XA.FACTORY_ID(+)
           AND IA.LINE_ID      = XA.LINE_ID(+)
           AND IA.OPERATION_ID = XA.OPERATION_ID(+)
        ;

        /* #TMP_SCP0098_ITEM_LIST_YYYYMM */
        INSERT INTO GT_SCP0098_ITEM_LIST_YYYYMM
             ( DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMM
             )
        SELECT A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.ITEM_ID
             , B.MONTH AS YYYYMM
          FROM SCM_MST_ITEM_LINE_ASSIGN_SN B
             , GT_SCP0098_ITEM_LIST A
         WHERE A.COMPANY_ID   = B.COMPANY_ID
           AND A.DIVISION_ID  = B.DIVISION_ID
           AND A.SITE_ID      = B.SITE_ID
           AND A.PLANT_ID     = B.PLANT_ID
           AND A.FACTORY_ID   = B.FACTORY_ID
           AND A.OPERATION_ID = B.OPERATION_ID
           AND A.LINE_ID      = B.LINE_ID
           AND A.ITEM_ID      = B.ITEM_ID
           AND B.MONTH        >= V_START_MONTH
           AND B.MONTH        <= V_END_MONTH
        ;

        /* #TMP_SCP0098_STD_LINE_DATA) Line List */
        INSERT INTO GT_SCP0098_STD_LINE_DATA
             ( DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , SITE_NAME
             , FACTORY_NAME
             , OPERATION_GROUP_ID
             , OPERATION_GROUP_NAME
             , LINE_NAME
             , OPERATION_NAME
             )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , NVL(B.SITE_NAME      , '-') AS SITE_NAME
             , NVL(B.FACTORY_NAME   , '-') AS FACTORY_NAME
             , B.OPERATION_GROUP_ID
             , NVL(B.OPERATION_GROUP, '-') AS OPERATION_GROUP_NAME
             , NVL(B.LINE_NAME      , '-') AS LINE_NAME
             , NVL(B.OPERATION_NAME , '-') AS OPERATION_NAME
          FROM GT_SCP0098_ITEM_LIST A
             , SCM_LINE_HIERARCHY_V_SN B
         WHERE A.COMPANY_ID   = B.COMPANY_ID(+)
           AND A.DIVISION_ID  = B.DIVISION_ID(+)
           AND A.SITE_ID      = B.SITE_ID(+)
           AND A.PLANT_ID     = B.PLANT_ID(+)
           AND A.FACTORY_ID   = B.FACTORY_ID(+)
           AND A.OPERATION_ID = B.OPERATION_ID(+)
           AND A.LINE_ID      = B.LINE_ID(+)
        ;

        /* #TMP_SCP0098_STD_ITEM_DATA) Item List */
        INSERT INTO GT_SCP0098_STD_ITEM_DATA
             ( DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , SITE_NAME
             , FACTORY_NAME
             , OPERATION_GROUP_ID
             , OPERATION_GROUP_NAME
             , LINE_NAME
             , OPERATION_NAME
             , ITEM_ID
             , ITEM_NAME
             )
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , NVL(B.SITE_NAME      , '-') AS SITE_NAME
             , NVL(B.FACTORY_NAME   , '-') AS FACTORY_NAME
             , B.OPERATION_GROUP_ID
             , NVL(B.OPERATION_GROUP, '-') AS OPERATION_GROUP_NAME
             , NVL(B.LINE_NAME      , '-') AS LINE_NAME
             , NVL(B.OPERATION_NAME , '-') AS OPERATION_NAME
             , A.ITEM_ID
             , NVL(FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID), '-') AS ITEM_NAME
          FROM GT_SCP0098_ITEM_LIST A
             , SCM_LINE_HIERARCHY_V_SN B
         WHERE A.COMPANY_ID   = B.COMPANY_ID(+)
           AND A.DIVISION_ID  = B.DIVISION_ID(+)
           AND A.SITE_ID      = B.SITE_ID(+)
           AND A.PLANT_ID     = B.PLANT_ID(+)
           AND A.FACTORY_ID   = B.FACTORY_ID(+)
           AND A.OPERATION_ID = B.OPERATION_ID(+)
           AND A.LINE_ID      = B.LINE_ID(+)
        ;

        /* #TARGET_MEASURES */
        INSERT INTO GT_SCP0098_TARGET_MEASURE
             ( MEASURE_UI
             , MEASURE_NAME
             , MEASURE_DB
             , COL_DIV
             , SORT_ORDER_NO
             )
        SELECT IA.MEASURE_UI
             , IA.MEASURE_NAME
             , SUBSTR(IA.MEASURE_UI, 1, INSTR(IA.MEASURE_UI, '_') - 1)                              AS MEASURE_DB
             , SUBSTR(IA.MEASURE_UI, INSTR(IA.MEASURE_UI, '_') + 1, LENGTH(RTRIM(IA.MEASURE_UI)))   AS COL_DIV
             , IA.SORT_ORDER_NO
          FROM ( /* user별 설정한 조회 대상 measure */
                 SELECT UM.COLUMN_NAME       AS MEASURE_UI
                      , M.COLUMN_LABEL_NAME  AS MEASURE_NAME
                      , UM.SORT_ORDER_NO
                   FROM SCM_MST_TITLESET_USER UM
                      , SCM_MST_SHEET_MEASURE M
                  WHERE M.COLUMN_NAME = UM.COLUMN_NAME
                    AND M.PROGRAM_ID  = V_PROGRAM_ID
                    AND M.SHEET_NAME  = V_SHEET_NAME
                    AND M.VALID_YN    = 'Y'
                    AND UM.USER_ID    = P_USER_ID
                    AND UM.PROGRAM_ID = V_PROGRAM_ID
                    AND UM.SHEET_NAME = V_SHEET_NAME

                 UNION ALL
                 /* user별 설정한 measure정보가 없을 경우 default measure를 보여준다. */
                 SELECT M.COLUMN_NAME        AS MEASURE_UI
                      , M.COLUMN_LABEL_NAME  AS MEASURE_NAME
                      , M.SORT_ORDER_NO
                   FROM SCM_MST_SHEET_MEASURE M
                  WHERE M.PROGRAM_ID   = V_PROGRAM_ID
                    AND M.SHEET_NAME   = V_SHEET_NAME
                    AND M.VALID_YN     = 'Y'
                    AND M.DEFAULT_FLAG = 'Y'
                    AND NOT EXISTS ( SELECT 1
                                       FROM SCM_MST_TITLESET_USER SA
                                          , SCM_MST_SHEET_MEASURE SB
                                      WHERE SB.COLUMN_NAME = SA.COLUMN_NAME
                                        AND SB.PROGRAM_ID  = V_PROGRAM_ID
                                        AND SB.SHEET_NAME  = V_SHEET_NAME
                                        AND SB.VALID_YN    = 'Y'
                                        AND SA.USER_ID     = P_USER_ID
                                        AND SA.PROGRAM_ID  = V_PROGRAM_ID
                                        AND SA.SHEET_NAME  = V_SHEET_NAME )
               ) IA
        ;

        /* #TMP_LIST)
           1) Line / Measure Cross = NO work, Ramp up, Load Rate
           2) ITEM / Measure Cross = Daily Capa                    */
        INSERT INTO GT_SCP0098_LINE_MEASURE
             ( DIVISION_ID
             , COMPANY_ID
             , SCM_SITE
             , SITE_NAME
             , PLANT_ID
             , OPERATION_GROUP_ID
             , FACTORY_ID
             , FACTORY_NAME
             , OPERATION_ID
             , OPERATION_NAME
             , LINE_ID
             , LINE_NAME
             , MEASURE_UI
             , MEASURE_NAME
             , MEASURE_DB
             , COL_DIV
             , SORT_ORDER_NO
             , ITEM_ID
             , ITEM_NAME
             )
        SELECT T.DIVISION_ID
             , T.COMPANY_ID
             , T.SITE_ID AS SCM_SITE
             , T.SITE_NAME
             , T.PLANT_ID
             , T.OPERATION_GROUP_ID
             , T.FACTORY_ID
             , T.FACTORY_NAME
             , T.OPERATION_ID
             , T.OPERATION_NAME
             , T.LINE_ID
             , T.LINE_NAME
             , M.MEASURE_UI
             , M.MEASURE_NAME
             , M.MEASURE_DB
             , M.COL_DIV
             , M.SORT_ORDER_NO
             , '/' AS ITEM_ID
             , '-' AS ITEM_NAME
          FROM GT_SCP0098_STD_LINE_DATA T
             , GT_SCP0098_TARGET_MEASURE M
         WHERE M.MEASURE_UI != 'DAILY_CAPA'
        ;

        INSERT INTO GT_SCP0098_LINE_MEAS_DIST
             ( DIVISION_ID
             , COMPANY_ID
             , SCM_SITE
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_GROUP_ID
             , OPERATION_ID
             , LINE_ID
             , MEASURE_UI
             , SITE_NAME
             , FACTORY_NAME
             , LINE_NAME
             , OPERATION_NAME
             , MEASURE_NAME
             , SORT_ORDER_NO
             )
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SCM_SITE
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_GROUP_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.MEASURE_UI
             , MAX(A.SITE_NAME)      AS SITE_NAME
             , MAX(A.FACTORY_NAME)   AS FACTORY_NAME
             , MAX(A.LINE_NAME)      AS LINE_NAME
             , MAX(A.OPERATION_NAME) AS OPERATION_NAME
             , MAX(A.MEASURE_NAME)   AS MEASURE_NAME
             , MAX(A.SORT_ORDER_NO)  AS SORT_ORDER_NO
          FROM GT_SCP0098_LINE_MEASURE A
        GROUP BY A.DIVISION_ID
               , A.COMPANY_ID
               , A.SCM_SITE
               , A.PLANT_ID
               , A.FACTORY_ID
               , A.OPERATION_GROUP_ID
               , A.OPERATION_ID
               , A.LINE_ID
               , A.MEASURE_UI
        ;

        INSERT INTO GT_SCP0098_ITEM_MEASURE
             ( DIVISION_ID
             , COMPANY_ID
             , SCM_SITE
             , SITE_NAME
             , PLANT_ID
             , OPERATION_GROUP_ID
             , FACTORY_ID
             , FACTORY_NAME
             , OPERATION_ID
             , OPERATION_NAME
             , LINE_ID
             , LINE_NAME
             , MEASURE_UI
             , MEASURE_NAME
             , MEASURE_DB
             , COL_DIV
             , SORT_ORDER_NO
             , ITEM_ID
             , ITEM_NAME
             )
        SELECT T.DIVISION_ID
             , T.COMPANY_ID
             , T.SITE_ID AS SCM_SITE
             , T.SITE_NAME
             , T.PLANT_ID
             , T.OPERATION_GROUP_ID
             , T.FACTORY_ID
             , T.FACTORY_NAME
             , T.OPERATION_ID
             , T.OPERATION_NAME
             , T.LINE_ID
             , T.LINE_NAME
             , M.MEASURE_UI
             , M.MEASURE_NAME
             , M.MEASURE_DB
             , M.COL_DIV
             , M.SORT_ORDER_NO
             , T.ITEM_ID            AS ITEM_ID
             , NVL(T.ITEM_NAME,'-') AS ITEM_NAME
          FROM GT_SCP0098_STD_ITEM_DATA T
             , GT_SCP0098_TARGET_MEASURE M
         WHERE M.MEASURE_UI = 'DAILY_CAPA'
           AND ( TRIM(P_NICK_NAME) IS NULL OR T.ITEM_NAME IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_NICK_NAME, ',')) ) )
        ;

        /********************************************************************************
        * PROD_READY_RATE
        1, PROD_READY_RATE 변경 가능성 없음으로 추정
        2, TODAY 기준으로 생산준비율 조회
        3, 추후 기간별 생산준비율 관리가 필요할 시 개선 필요
        ********************************************************************************/
        INSERT INTO GT_SCP0098_PROD_READY_RATE
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , PROD_READY_RATE
             )
        SELECT DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , CASE WHEN PROD_READY_RATE IS NOT NULL THEN CAST(PROD_READY_RATE AS NUMBER(10,3))
                    ELSE PROD_READY_RATE
               END AS PROD_READY_RATE
          FROM SCP_MST_CAPA_WORK
         WHERE MEASURE  = 'NO_WORK'
           AND YYYYMMDD = V_TODAY_YYYYMM_FIRSTDAY
        ;

        /********************************************************************************
        * #TMP_MEASURE_CAPA_WORK = ( LINE + NO_WORK, LOAD_RATE, RAMP_UP)
        ********************************************************************************/
        INSERT INTO GT_SCP0098_MEAS_WORK
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , BASIS_YYYYMMDD
             , MEASURE
             , VALUE
             )
        SELECT W.DIVISION_ID
             , W.PLANT_ID
             , W.FACTORY_ID
             , W.OPERATION_ID
             , W.LINE_ID
             , 'D_' || W.YYYYMMDD AS BASIS_YYYYMMDD
             , W.MEASURE
             , CASE WHEN W.VALUE IS NOT NULL AND W.MEASURE = 'LOAD_RATE' THEN CAST(W.VALUE AS NUMBER(13,3))
                    WHEN W.VALUE IS NOT NULL AND W.MEASURE = 'RAMP_UP'   THEN CAST(W.VALUE AS NUMBER(13,3))
                    ELSE W.VALUE
               END AS VALUE
          FROM SCP_MST_CAPA_WORK W
             , GT_SCP0098_STD_LINE_DATA D
         WHERE W.DIVISION_ID  = D.DIVISION_ID
           AND W.PLANT_ID     = D.PLANT_ID
           AND W.FACTORY_ID   = D.FACTORY_ID
           AND W.OPERATION_ID = D.OPERATION_ID
           AND W.LINE_ID      = D.LINE_ID
           AND W.YYYYMMDD     >= P_FROM_YYYYMMDD
           AND W.YYYYMMDD     <= P_TO_YYYYMMDD
        ;

        /********************************************************************************
        *#TMP_DAILYCAPA_DAY
        ********************************************************************************/
        INSERT INTO GT_SCP0098_DAILYCAPA_DAY
             ( BASIS_YYYYMMDD
             , MEASURE
             , YYYYMMDD
             )
        SELECT 'D_' || BASIS_YYYYMMDD          AS BASIS_YYYYMMDD
             , 'DAILY_CAPA'                    AS MEASURE
             , SUBSTR(BASIS_YYYYMMDD, 1, 6)    AS YYYYMMDD
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
           AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        ;

        /********************************************************************************
        * #TMP_SCP0098_ITEM_LIST_YYYYMM_TERM
        ********************************************************************************/
        INSERT INTO GT_SCP0098_ITEM_LIST_TERM
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMM
             )
        SELECT IA.DIVISION_ID
             , IA.PLANT_ID
             , IA.FACTORY_ID
             , IA.OPERATION_ID
             , IA.LINE_ID
             , IA.ITEM_ID
             , XA.YYYYMMDD AS YYYYMM
          FROM ( SELECT DISTINCT
                        DIVISION_ID
                      , PLANT_ID
                      , FACTORY_ID
                      , OPERATION_ID
                      , LINE_ID
                      , ITEM_ID
                   FROM GT_SCP0098_ITEM_LIST_YYYYMM ) IA
             , ( SELECT DISTINCT YYYYMMDD
                   FROM GT_SCP0098_DAILYCAPA_DAY ) XA
        ;

        /********************************************************************************
        * #TMP_MEASURE_CAPA
        ********************************************************************************/
        INSERT INTO GT_SCP0098_MEAS_CAPA
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMM
             , BASIS_YYYYMM
             , VALUE
             )
        SELECT B.DIVISION_ID
             , B.PLANT_ID
             , B.FACTORY_ID
             , B.OPERATION_ID
             , B.LINE_ID
             , B.ITEM_ID
             , NVL(W.YYYYMM, B.YYYYMM)          AS YYYYMM
             , 'M_' || NVL(W.YYYYMM, B.YYYYMM)  AS BASIS_YYYYMM
             , CASE WHEN W.VALUE IS NOT NULL
                    THEN CAST(NVL(W.VALUE, 0) AS NUMBER(13,0))
                    ELSE W.VALUE
               END AS VALUE
          FROM GT_SCP0098_ITEM_LIST_TERM B
             , SCP_MST_CAPA W
         WHERE W.DIVISION_ID(+)  = B.DIVISION_ID
           AND W.PLANT_ID(+)     = B.PLANT_ID
           AND W.FACTORY_ID(+)   = B.FACTORY_ID
           AND W.OPERATION_ID(+) = B.OPERATION_ID
           AND W.LINE_ID(+)      = B.LINE_ID
           AND W.ITEM_ID(+)      = B.ITEM_ID
           AND W.YYYYMM(+)       = B.YYYYMM
           AND B.YYYYMM          >= V_START_MONTH
           AND B.YYYYMM          <= V_END_MONTH
        ;

        /********************************************************************************
        * NO WORK + Next Day
        ********************************************************************************/
        INSERT INTO GT_SCP0098_MEAS_CAPA_NOWORK
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , BASIS_YYYYMMDD
             , MEASURE
             , VALUE
             , BASIS_YYYYMMDD_NEXT
             )
        SELECT DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , BASIS_YYYYMMDD
             , MEASURE
             , VALUE
             , 'D_' || TO_CHAR(TO_DATE(SUBSTR(BASIS_YYYYMMDD, 3, 8), 'YYYYMMDD') + 1, 'YYYYMMDD') AS BASIS_YYYYMMDD_NEXT
          FROM GT_SCP0098_MEAS_WORK
         WHERE MEASURE = 'NO_WORK'
           AND VALUE   = 1
        ;

        /********************************************************************************
        * OEE = Capa/일
        ********************************************************************************/
        INSERT INTO GT_SCP0098_OEE_TERM
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMM
             , VALUE
             )
        SELECT B.DIVISION_ID
             , B.PLANT_ID
             , B.FACTORY_ID
             , B.OPERATION_ID
             , B.LINE_ID
             , B.ITEM_ID
             , B.YYYYMM
             , W.VALUE
          FROM GT_SCP0098_ITEM_LIST_TERM B
             , SCP_MST_CAPA W
         WHERE W.DIVISION_ID(+)  = B.DIVISION_ID
           AND W.PLANT_ID(+)     = B.PLANT_ID
           AND W.FACTORY_ID(+)   = B.FACTORY_ID
           AND W.OPERATION_ID(+) = B.OPERATION_ID
           AND W.LINE_ID(+)      = B.LINE_ID
           AND W.ITEM_ID(+)      = B.ITEM_ID
           AND W.YYYYMM(+)       = B.YYYYMM
           AND B.YYYYMM          >= V_START_MONTH
           AND B.YYYYMM          <= V_END_MONTH
        ;

        /********************************************************************************
        * Daily Cala Value Calc
        ********************************************************************************/
        INSERT INTO GT_SCP0098_CAPA_YMD
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , VALUE
             , MEASURE
             , BASIS_YYYYMMDD
             )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.ITEM_ID
             , A.VALUE
             , IA.MEASURE
             , IA.BASIS_YYYYMMDD
          FROM GT_SCP0098_MEAS_CAPA A
             , GT_SCP0098_DAILYCAPA_DAY IA
         WHERE A.YYYYMM = IA.YYYYMMDD
        ;

        UPDATE GT_SCP0098_CAPA_YMD A
           SET A.NO_WORK = ( SELECT MAX(CA.VALUE)
                               FROM GT_SCP0098_MEAS_WORK CA
                              WHERE CA.DIVISION_ID    = A.DIVISION_ID
                                AND CA.PLANT_ID       = A.PLANT_ID
                                AND CA.FACTORY_ID     = A.FACTORY_ID
                                AND CA.OPERATION_ID   = A.OPERATION_ID
                                AND CA.LINE_ID        = A.LINE_ID
                                AND CA.BASIS_YYYYMMDD = A.BASIS_YYYYMMDD
                                AND CA.MEASURE        = 'NO_WORK' )
         WHERE EXISTS ( SELECT 1
                          FROM GT_SCP0098_MEAS_WORK CA
                         WHERE CA.DIVISION_ID    = A.DIVISION_ID
                           AND CA.PLANT_ID       = A.PLANT_ID
                           AND CA.FACTORY_ID     = A.FACTORY_ID
                           AND CA.OPERATION_ID   = A.OPERATION_ID
                           AND CA.LINE_ID        = A.LINE_ID
                           AND CA.BASIS_YYYYMMDD = A.BASIS_YYYYMMDD
                           AND CA.MEASURE        = 'NO_WORK' )
        ;

        UPDATE GT_SCP0098_CAPA_YMD A
           SET A.LOAD_RATE = ( SELECT MAX(CA.VALUE)
                                 FROM GT_SCP0098_MEAS_WORK CA
                                WHERE CA.DIVISION_ID    = A.DIVISION_ID
                                  AND CA.PLANT_ID       = A.PLANT_ID
                                  AND CA.FACTORY_ID     = A.FACTORY_ID
                                  AND CA.OPERATION_ID   = A.OPERATION_ID
                                  AND CA.LINE_ID        = A.LINE_ID
                                  AND CA.BASIS_YYYYMMDD = A.BASIS_YYYYMMDD
                                  AND CA.MEASURE        = 'LOAD_RATE' )
         WHERE EXISTS ( SELECT 1
                          FROM GT_SCP0098_MEAS_WORK CA
                         WHERE CA.DIVISION_ID    = A.DIVISION_ID
                           AND CA.PLANT_ID       = A.PLANT_ID
                           AND CA.FACTORY_ID     = A.FACTORY_ID
                           AND CA.OPERATION_ID   = A.OPERATION_ID
                           AND CA.LINE_ID        = A.LINE_ID
                           AND CA.BASIS_YYYYMMDD = A.BASIS_YYYYMMDD
                           AND CA.MEASURE        = 'LOAD_RATE' )
        ;

        UPDATE GT_SCP0098_CAPA_YMD A
           SET A.RAMP_UP = ( SELECT MAX(CA.VALUE)
                               FROM GT_SCP0098_MEAS_WORK CA
                              WHERE CA.DIVISION_ID    = A.DIVISION_ID
                                AND CA.PLANT_ID       = A.PLANT_ID
                                AND CA.FACTORY_ID     = A.FACTORY_ID
                                AND CA.OPERATION_ID   = A.OPERATION_ID
                                AND CA.LINE_ID        = A.LINE_ID
                                AND CA.BASIS_YYYYMMDD = A.BASIS_YYYYMMDD
                                AND CA.MEASURE        = 'RAMP_UP' )
         WHERE EXISTS ( SELECT 1
                          FROM GT_SCP0098_MEAS_WORK CA
                         WHERE CA.DIVISION_ID    = A.DIVISION_ID
                           AND CA.PLANT_ID       = A.PLANT_ID
                           AND CA.FACTORY_ID     = A.FACTORY_ID
                           AND CA.OPERATION_ID   = A.OPERATION_ID
                           AND CA.LINE_ID        = A.LINE_ID
                           AND CA.BASIS_YYYYMMDD = A.BASIS_YYYYMMDD
                           AND CA.MEASURE        = 'RAMP_UP' )
        ;

        /* PROD_RATE 기간으로 관리 안함 +  변경 가능성 없음 */
        UPDATE GT_SCP0098_CAPA_YMD A
           SET A.PROD_RATE = ( SELECT MAX(CA.PROD_READY_RATE)
                                 FROM GT_SCP0098_PROD_READY_RATE CA
                                WHERE CA.DIVISION_ID  = A.DIVISION_ID
                                  AND CA.PLANT_ID     = A.PLANT_ID
                                  AND CA.FACTORY_ID   = A.FACTORY_ID
                                  AND CA.OPERATION_ID = A.OPERATION_ID
                                  AND CA.LINE_ID      = A.LINE_ID )
         WHERE EXISTS ( SELECT 1
                          FROM GT_SCP0098_PROD_READY_RATE CA
                         WHERE CA.DIVISION_ID  = A.DIVISION_ID
                           AND CA.PLANT_ID     = A.PLANT_ID
                           AND CA.FACTORY_ID   = A.FACTORY_ID
                           AND CA.OPERATION_ID = A.OPERATION_ID
                           AND CA.LINE_ID      = A.LINE_ID )
        ;

        /* NO_WORK_NEXTDAY */
        UPDATE GT_SCP0098_CAPA_YMD A
           SET A.NO_WORK_NEXTDAY = 1
         WHERE EXISTS ( SELECT 1
                          FROM GT_SCP0098_MEAS_CAPA_NOWORK CA
                         WHERE CA.DIVISION_ID         = A.DIVISION_ID
                           AND CA.PLANT_ID            = A.PLANT_ID
                           AND CA.FACTORY_ID          = A.FACTORY_ID
                           AND CA.OPERATION_ID        = A.OPERATION_ID
                           AND CA.LINE_ID             = A.LINE_ID
                           AND CA.BASIS_YYYYMMDD_NEXT = A.BASIS_YYYYMMDD )
        ;

        /* 오창, 월요일 조건으로 무조건 생산준비율 반영... 20240401 */
--        UPDATE GT_SCP0098_CAPA_YMD A
--           SET A.VALUE_CALC = ( SELECT CASE WHEN A.NO_WORK = 1 THEN 0
--                                            WHEN A.NO_WORK_NEXTDAY = 1 THEN NVL(A.VALUE, 0) * NVL(A.LOAD_RATE / 100, 1) * NVL(A.RAMP_UP, 1) * NVL(A.PROD_RATE / 100, 1)
--                                            WHEN SB.SITE_ID = 'A001' AND SA.DAYOFWEEK = 'MON' THEN NVL(A.VALUE, 0) * NVL(A.LOAD_RATE / 100, 1) * NVL(A.RAMP_UP, 1) * NVL(A.PROD_RATE / 100, 1)
--                                            ELSE NVL(A.VALUE, 0) * NVL(A.LOAD_RATE / 100, 1) * NVL(A.RAMP_UP, 1)
--                                       END
--                                  FROM SCM_SYS_CALENDAR_M SA
--                                     , ( SELECT FACTORY_ID
--                                              , MAX(SITE_ID) AS SITE_ID
--                                           FROM SCM_MST_FACTORY_SN
--                                         GROUP BY FACTORY_ID ) SB
--                                 WHERE SUBSTR(A.BASIS_YYYYMMDD, -8) = SA.BASIS_YYYYMMDD
--                                   AND A.FACTORY_ID                 = SB.FACTORY_ID )
--         WHERE EXISTS ( SELECT 1
--                          FROM SCM_SYS_CALENDAR_M SA
--                             , ( SELECT FACTORY_ID
--                                      , MAX(SITE_ID) AS SITE_ID
--                                   FROM SCM_MST_FACTORY_SN
--                                 GROUP BY FACTORY_ID ) SB
--                         WHERE SUBSTR(A.BASIS_YYYYMMDD, -8) = SA.BASIS_YYYYMMDD
--                           AND A.FACTORY_ID                 = SB.FACTORY_ID )
--        ;
        UPDATE GT_SCP0098_CAPA_YMD A /* AJS 20261007 속도 */
           SET A.VALUE_CALC = CASE WHEN A.NO_WORK = 1 THEN 0 /* AJS 20261007 속도 */
                                   WHEN A.NO_WORK_NEXTDAY = 1 THEN NVL(A.VALUE, 0) * NVL(A.LOAD_RATE / 100, 1) * NVL(A.RAMP_UP, 1) * NVL(A.PROD_RATE / 100, 1) /* AJS 20261007 속도 */
                                   WHEN ( SELECT MAX(SB.SITE_ID) /* AJS 20261007 속도 */
                                            FROM SCM_MST_FACTORY_SN SB /* AJS 20261007 속도 */
                                           WHERE SB.FACTORY_ID = A.FACTORY_ID ) = 'A001' /* AJS 20261007 속도 */
                                    AND ( SELECT SA.DAYOFWEEK /* AJS 20261007 속도 */
                                            FROM SCM_SYS_CALENDAR_M SA /* AJS 20261007 속도 */
                                           WHERE SA.BASIS_YYYYMMDD = SUBSTR(A.BASIS_YYYYMMDD, -8) ) = 'MON' /* AJS 20261007 속도 */
                                   THEN NVL(A.VALUE, 0) * NVL(A.LOAD_RATE / 100, 1) * NVL(A.RAMP_UP, 1) * NVL(A.PROD_RATE / 100, 1) /* AJS 20261007 속도 */
                                   ELSE NVL(A.VALUE, 0) * NVL(A.LOAD_RATE / 100, 1) * NVL(A.RAMP_UP, 1) /* AJS 20261007 속도 */
                              END /* AJS 20261007 속도 */
         WHERE EXISTS ( SELECT 1 /* AJS 20261007 속도 */
                          FROM SCM_SYS_CALENDAR_M SA /* AJS 20261007 속도 */
                         WHERE SA.BASIS_YYYYMMDD = SUBSTR(A.BASIS_YYYYMMDD, -8) ) /* AJS 20261007 속도 */
           AND EXISTS ( SELECT 1 /* AJS 20261007 속도 */
                          FROM SCM_MST_FACTORY_SN SB /* AJS 20261007 속도 */
                         WHERE SB.FACTORY_ID = A.FACTORY_ID ) /* AJS 20261007 속도 */
        ; /* AJS 20261007 속도 */

        INSERT INTO GT_SCP0098_CAPA_YMD_CALC
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , VALUE
             , MEASURE
             , BASIS_YYYYMMDD
             )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.ITEM_ID
             , A.VALUE_CALC AS VALUE
             , A.MEASURE
             , A.BASIS_YYYYMMDD
          FROM GT_SCP0098_CAPA_YMD A
        ;

        /* PIVOIT Column 처리
           ★ 동적 SQL 로 남기는 유일한 자리 : 조회 기간에 따라 일자 · 월 칸 이름이 달라지는 피벗이라
             정적 SQL 로 옮길 수 없다. 나머지는 모두 정적 SQL 이다.
             AS-IS 가 같은 목록을 네 번 훑는 것을 한 번으로 합쳤다. */
        V_MQRY_FIELD           := NULL;
        V_MQRY_FIELD_LAST      := NULL;
        V_MQRY_FIELD_PRODREADY := NULL;
        V_PIVOT_AGG            := NULL;
        V_OEE_PIVOT            := NULL; /* AJS 20261007 속도 */

        FOR C1 IN ( SELECT YYYYMMDD
                      FROM ( SELECT 'M_' || A.BASIS_YYYYMM                AS YYYYMMDD
                                  , MIN(A.BASIS_START_DATE) || '01'       AS SORT_ORDER_NO
                               FROM SCM_SYS_CALENDAR_M A
                              WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                                AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM
                                  , A.MONTH_NAME
                           ) IA
                     WHERE YYYYMMDD LIKE 'M_%'
                  ORDER BY SORT_ORDER_NO )
        LOOP
--            V_MQRY_FIELD_PRODREADY := V_MQRY_FIELD_PRODREADY
--                                   || '     , CASE WHEN MEASURE_UI = ''DAILY_CAPA'''                       || CHR(10)
--                                   || '            THEN ( SELECT MAX(VALUE)'                                || CHR(10)
--                                   || '                     FROM GT_SCP0098_OEE_TERM'                       || CHR(10)
--                                   || '                    WHERE DIVISION_ID  = A.DIVISION_ID'              || CHR(10)
--                                   || '                      AND PLANT_ID     = A.PLANT_ID'                 || CHR(10)
--                                   || '                      AND FACTORY_ID   = A.FACTORY_ID'               || CHR(10)
--                                   || '                      AND OPERATION_ID = A.OPERATION_ID'             || CHR(10)
--                                   || '                      AND LINE_ID      = A.LINE_ID'                  || CHR(10)
--                                   || '                      AND ITEM_ID      = A.ITEM_ID'                  || CHR(10)
--                                   || '                      AND YYYYMM       = ''' || SUBSTR(C1.YYYYMMDD, 3) || ''' )' || CHR(10)
--                                   || '            ELSE NULL'                                               || CHR(10)
--                                   || '       END AS ' || C1.YYYYMMDD                                       || CHR(10);
            V_MQRY_FIELD_PRODREADY := V_MQRY_FIELD_PRODREADY /* AJS 20261007 속도 */
                                   || '     , CASE WHEN MEASURE_UI = ''DAILY_CAPA'''                       || CHR(10) /* AJS 20261007 속도 */
                                   || '            THEN XA.OEE_' || C1.YYYYMMDD                             || CHR(10) /* AJS 20261007 속도 */
                                   || '            ELSE NULL'                                               || CHR(10) /* AJS 20261007 속도 */
                                   || '       END AS ' || C1.YYYYMMDD                                       || CHR(10); /* AJS 20261007 속도 */

            V_OEE_PIVOT := V_OEE_PIVOT /* AJS 20261007 속도 */
                        || '              , MAX(CASE WHEN YYYYMM = ''' || SUBSTR(C1.YYYYMMDD, 3) || ''' THEN VALUE END) AS OEE_' || C1.YYYYMMDD || CHR(10); /* AJS 20261007 속도 */
        END LOOP;

        FOR C2 IN ( SELECT YYYYMMDD
                      FROM ( SELECT 'D_' || A.BASIS_YYYYMMDD              AS YYYYMMDD
                                  , A.BASIS_YYYYMMDD || '31'              AS SORT_ORDER_NO
                               FROM SCM_SYS_CALENDAR_M A
                              WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                                AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMMDD
                           ) IA
                     WHERE YYYYMMDD LIKE 'D_%'
                  ORDER BY SORT_ORDER_NO )
        LOOP
            V_MQRY_FIELD := V_MQRY_FIELD || '     , ' || C2.YYYYMMDD || CHR(10);

            V_PIVOT_AGG  := V_PIVOT_AGG
                         || '     , MAX(CASE WHEN A.BASIS_YYYYMMDD = ''' || C2.YYYYMMDD || ''' THEN A.VALUE END) AS ' || C2.YYYYMMDD || CHR(10);

            V_MQRY_FIELD_LAST := V_MQRY_FIELD_LAST
                              || '     , CASE WHEN MEASURE_UI = ''NO_WORK'' AND ' || C2.YYYYMMDD || ' = 1  THEN ''Y'''  || CHR(10)
                              || '            WHEN MEASURE_UI = ''NO_WORK'' AND ' || C2.YYYYMMDD || ' != 1 THEN ''''' || CHR(10)
                              || '            ELSE TO_CHAR(' || C2.YYYYMMDD || ', ''FM99999999990.000'')'   || CHR(10)
                              || '       END AS ' || C2.YYYYMMDD                                            || CHR(10);
        END LOOP;

        V_MEXEC := 'SELECT DIVISION_ID'                                              || CHR(10)
                || '     , PLANT_ID'                                                 || CHR(10)
                || '     , FACTORY_ID'                                               || CHR(10)
                || '     , OPERATION_ID'                                             || CHR(10)
                || '     , LINE_ID'                                                  || CHR(10)
                || '     , MEASURE_UI'                                               || CHR(10)
                || '     , ITEM_ID'                                                  || CHR(10)
                || '     , ITEM_NAME'                                                || CHR(10)
                || '     , FACTORY_NAME'                                             || CHR(10)
                || '     , LINE_NAME'                                                || CHR(10)
                || '     , MEASURE_NAME'                                             || CHR(10)
                || '     , SORT_ORDER_NO'                                            || CHR(10)
                || V_MQRY_FIELD_PRODREADY
                || V_MQRY_FIELD_LAST
                || '     , PRODUCT_READY'                                            || CHR(10)
                || '  FROM ( SELECT DATA.DIVISION_ID'                                || CHR(10)
                || '              , DATA.PLANT_ID'                                   || CHR(10)
                || '              , DATA.FACTORY_ID'                                 || CHR(10)
                || '              , DATA.OPERATION_ID'                               || CHR(10)
                || '              , DATA.LINE_ID'                                    || CHR(10)
                || '              , DATA.MEASURE_UI'                                 || CHR(10)
                || '              , DATA.ITEM_ID'                                    || CHR(10)
                || '              , DATA.ITEM_NAME'                                  || CHR(10)
                || '              , DATA.FACTORY_NAME'                               || CHR(10)
                || '              , DATA.LINE_NAME'                                  || CHR(10)
                || '              , DATA.MEASURE_NAME'                               || CHR(10)
                || '              , DATA.SORT_ORDER_NO'                              || CHR(10)
                || REPLACE(V_MQRY_FIELD, '     , ', '              , DATA.')
                || '              , ( SELECT MAX(PROD_READY_RATE)'                   || CHR(10)
                || '                    FROM GT_SCP0098_PROD_READY_RATE'             || CHR(10)
                || '                   WHERE DIVISION_ID  = DATA.DIVISION_ID'        || CHR(10)
                || '                     AND PLANT_ID     = DATA.PLANT_ID'           || CHR(10)
                || '                     AND FACTORY_ID   = DATA.FACTORY_ID'         || CHR(10)
                || '                     AND OPERATION_ID = DATA.OPERATION_ID'       || CHR(10)
                || '                     AND LINE_ID      = DATA.LINE_ID ) AS PRODUCT_READY' || CHR(10)
                || '           FROM ( SELECT A.DIVISION_ID'                          || CHR(10)
                || '                       , A.PLANT_ID'                             || CHR(10)
                || '                       , A.FACTORY_ID'                           || CHR(10)
                || '                       , A.OPERATION_ID'                         || CHR(10)
                || '                       , A.LINE_ID'                              || CHR(10)
                || '                       , A.MEASURE   AS MEASURE_UI'              || CHR(10)
                || '                       , A.ITEM_ID   AS ITEM_ID'                 || CHR(10)
                || '                       , L.ITEM_NAME AS ITEM_NAME'               || CHR(10)
                || '                       , L.FACTORY_NAME'                         || CHR(10)
                || '                       , L.LINE_NAME'                            || CHR(10)
                || '                       , L.MEASURE_NAME'                         || CHR(10)
                || '                       , L.SORT_ORDER_NO'                        || CHR(10)
                || REPLACE(V_PIVOT_AGG, '     , ', '                       , ')
                || '                    FROM GT_SCP0098_CAPA_YMD_CALC A'             || CHR(10)
                || '                       , GT_SCP0098_ITEM_MEASURE L'              || CHR(10)
                || '                   WHERE A.DIVISION_ID  = L.DIVISION_ID'         || CHR(10)
                || '                     AND A.PLANT_ID     = L.PLANT_ID'            || CHR(10)
                || '                     AND A.FACTORY_ID   = L.FACTORY_ID'          || CHR(10)
                || '                     AND A.OPERATION_ID = L.OPERATION_ID'        || CHR(10)
                || '                     AND A.LINE_ID      = L.LINE_ID'             || CHR(10)
                || '                     AND A.ITEM_ID      = L.ITEM_ID'             || CHR(10)
                || '                     AND A.MEASURE      = L.MEASURE_UI'          || CHR(10)
                || '                 GROUP BY A.DIVISION_ID'                         || CHR(10)
                || '                        , A.PLANT_ID'                            || CHR(10)
                || '                        , A.FACTORY_ID'                          || CHR(10)
                || '                        , A.OPERATION_ID'                        || CHR(10)
                || '                        , A.LINE_ID'                             || CHR(10)
                || '                        , A.MEASURE'                             || CHR(10)
                || '                        , A.ITEM_ID'                             || CHR(10)
                || '                        , L.ITEM_NAME'                           || CHR(10)
                || '                        , L.FACTORY_NAME'                        || CHR(10)
                || '                        , L.LINE_NAME'                           || CHR(10)
                || '                        , L.MEASURE_NAME'                        || CHR(10)
                || '                        , L.SORT_ORDER_NO'                       || CHR(10)
                || '                  UNION ALL'                                     || CHR(10)
                || '                  SELECT A.DIVISION_ID'                          || CHR(10)
                || '                       , A.PLANT_ID'                             || CHR(10)
                || '                       , A.FACTORY_ID'                           || CHR(10)
                || '                       , A.OPERATION_ID'                         || CHR(10)
                || '                       , A.LINE_ID'                              || CHR(10)
                || '                       , A.MEASURE AS MEASURE_UI'                || CHR(10)
                || '                       , '' ''     AS ITEM_ID'                   || CHR(10)
                || '                       , '' ''     AS ITEM_NAME'                  || CHR(10)
                || '                       , L.FACTORY_NAME'                         || CHR(10)
                || '                       , L.LINE_NAME'                            || CHR(10)
                || '                       , L.MEASURE_NAME'                         || CHR(10)
                || '                       , L.SORT_ORDER_NO'                        || CHR(10)
                || REPLACE(V_PIVOT_AGG, '     , ', '                       , ')
                || '                    FROM GT_SCP0098_MEAS_WORK A'                 || CHR(10)
                || '                       , GT_SCP0098_LINE_MEAS_DIST L'            || CHR(10)
                || '                   WHERE A.DIVISION_ID  = L.DIVISION_ID'         || CHR(10)
                || '                     AND A.PLANT_ID     = L.PLANT_ID'            || CHR(10)
                || '                     AND A.FACTORY_ID   = L.FACTORY_ID'          || CHR(10)
                || '                     AND A.OPERATION_ID = L.OPERATION_ID'        || CHR(10)
                || '                     AND A.LINE_ID      = L.LINE_ID'             || CHR(10)
                || '                     AND A.MEASURE      = L.MEASURE_UI'          || CHR(10)
                || '                     AND A.MEASURE      != ''DAILY_CAPA'''       || CHR(10)
                || '                 GROUP BY A.DIVISION_ID'                         || CHR(10)
                || '                        , A.PLANT_ID'                            || CHR(10)
                || '                        , A.FACTORY_ID'                          || CHR(10)
                || '                        , A.OPERATION_ID'                        || CHR(10)
                || '                        , A.LINE_ID'                             || CHR(10)
                || '                        , A.MEASURE'                             || CHR(10)
                || '                        , L.FACTORY_NAME'                        || CHR(10)
                || '                        , L.LINE_NAME'                           || CHR(10)
                || '                        , L.MEASURE_NAME'                        || CHR(10)
                || '                        , L.SORT_ORDER_NO'                       || CHR(10)
                || '                ) DATA'                                          || CHR(10)
                || '       ) A'                                                      || CHR(10)
                || '     , ( SELECT DIVISION_ID  AS OT_DIVISION_ID'                  || CHR(10) /* AJS 20261007 속도 */
                || '              , PLANT_ID     AS OT_PLANT_ID'                     || CHR(10) /* AJS 20261007 속도 */
                || '              , FACTORY_ID   AS OT_FACTORY_ID'                   || CHR(10) /* AJS 20261007 속도 */
                || '              , OPERATION_ID AS OT_OPERATION_ID'                 || CHR(10) /* AJS 20261007 속도 */
                || '              , LINE_ID      AS OT_LINE_ID'                      || CHR(10) /* AJS 20261007 속도 */
                || '              , ITEM_ID      AS OT_ITEM_ID'                      || CHR(10) /* AJS 20261007 속도 */
                || V_OEE_PIVOT /* AJS 20261007 속도 */
                || '           FROM GT_SCP0098_OEE_TERM'                             || CHR(10) /* AJS 20261007 속도 */
                || '          GROUP BY DIVISION_ID'                                  || CHR(10) /* AJS 20261007 속도 */
                || '                 , PLANT_ID'                                     || CHR(10) /* AJS 20261007 속도 */
                || '                 , FACTORY_ID'                                   || CHR(10) /* AJS 20261007 속도 */
                || '                 , OPERATION_ID'                                 || CHR(10) /* AJS 20261007 속도 */
                || '                 , LINE_ID'                                      || CHR(10) /* AJS 20261007 속도 */
                || '                 , ITEM_ID ) XA'                                 || CHR(10) /* AJS 20261007 속도 */
                || ' WHERE XA.OT_DIVISION_ID(+)  = A.DIVISION_ID'                    || CHR(10) /* AJS 20261007 속도 */
                || '   AND XA.OT_PLANT_ID(+)     = A.PLANT_ID'                       || CHR(10) /* AJS 20261007 속도 */
                || '   AND XA.OT_FACTORY_ID(+)   = A.FACTORY_ID'                     || CHR(10) /* AJS 20261007 속도 */
                || '   AND XA.OT_OPERATION_ID(+) = A.OPERATION_ID'                   || CHR(10) /* AJS 20261007 속도 */
                || '   AND XA.OT_LINE_ID(+)      = A.LINE_ID'                        || CHR(10) /* AJS 20261007 속도 */
                || '   AND XA.OT_ITEM_ID(+)      = A.ITEM_ID'                        || CHR(10) /* AJS 20261007 속도 */
                || 'ORDER BY DIVISION_ID'                                            || CHR(10)
                || '       , PLANT_ID'                                               || CHR(10)
                || '       , FACTORY_ID'                                             || CHR(10)
                || '       , OPERATION_ID'                                           || CHR(10)
                || '       , LINE_ID'                                                || CHR(10)
                || '       , SORT_ORDER_NO'                                          || CHR(10)
                || '       , ITEM_ID'                                                || CHR(10)
        ;

        OPEN O_RC FOR V_MEXEC;

        OPEN O_RESULT_CURSOR FOR
            SELECT NULL AS ERR_MESSAGE
              FROM DUAL
             WHERE 1 = 0
        ;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MESSAGE := SQLERRM;

            OPEN O_RC FOR
                SELECT NULL AS DUMMY
                  FROM DUAL
                 WHERE 1 = 0
            ;

            OPEN O_RESULT_CURSOR FOR
                SELECT V_ERR_MESSAGE AS ERR_MESSAGE
                  FROM DUAL
            ;
    END P_GET_CAPA_MOBILITYIT;

/*==================================================================================================
 * Program ID   : SCP0098_GET_CAPA_MobilityIT_LINE
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/07/19   khj79          최초작성 - SCP0049_GET_CAPA 참조 => SCP0013 ,Production Plan Line 참조
 * 2020/08/21   khj79          최초작성 - SCP0049_GET_CAPA 참조 => Line Assign / Operation / LOCATION_GROUP_ROUTE
 * 2020/08/23   vadabi3        최초작성 - SCP0049_GET_CAPA 참조 => PIVOT
 * 2020/09/06   vadabi3        Version 2 - 조회 대상 개선
 * 2025/08/01   hrkim		   PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.07   AJS          [속도2차] 품목 목록 적재 시 라인 계층 인라인 뷰 병합 방지(NO_MERGE) · 월 칸(M_) 행별 하위질의를 한 번 집계해 붙임
 *==================================================================================================*/
    PROCEDURE P_GET_CAPA_MOBILITYIT_LINE (
        P_TODAY_YYYYMMDD    IN  VARCHAR2
      , P_FROM_YYYYMMDD     IN  VARCHAR2
      , P_TO_YYYYMMDD       IN  VARCHAR2
      , P_DIVISION_ID       IN  VARCHAR2
      , P_PLANT_ID          IN  VARCHAR2
      , P_LINE_ID           IN  VARCHAR2
      , P_OPERATION_ID      IN  VARCHAR2
      , P_MODEL_ID          IN  VARCHAR2
      , P_ITEM_ID           IN  VARCHAR2
      , P_NICK_NAME         IN  VARCHAR2
      , P_BUCKET            IN  VARCHAR2
      , P_USER_ID           IN  VARCHAR2
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC                OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        /* Declare */
        V_PROGRAM_ID            VARCHAR2(400 CHAR) := 'SCP0098';
        V_SHEET_NAME            VARCHAR2(600 CHAR) := 'CAPA_SMALL';
        V_TODAY_YYYYMM          VARCHAR2(6 CHAR);

        /* 날짜 조건용 변수 설정 */
        V_START_MONTH           VARCHAR2(6 CHAR);   /* 시작 월(현재월 +1 년) */
        V_END_MONTH             VARCHAR2(6 CHAR);   /* 마지막 월 */

        V_TODAY_YYYYMM_FIRSTDAY VARCHAR2(8 CHAR);

        /* 쿼리 실행용 변수 */
        V_MEXEC                 CLOB;
        V_MQRY_FIELD            CLOB;   /* 피벗 칸 목록 (D_) */
        V_MQRY_FIELD_LAST       CLOB;   /* 최종 표기 변환 (D_) */
        V_MQRY_FIELD_PRODREADY  CLOB;   /* 월 칸 (M_) */
        V_PIVOT_AGG             CLOB;   /* 피벗 집계식 (D_) */
        V_OEE_PIVOT             CLOB;   /* 월 칸 집계식 (M_) */ /* AJS 20261007 속도 */

        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        /* GTT 초기화 (TRUNCATE 금지) */
        DELETE FROM GT_SCP0098_ITEM_LIST;
        DELETE FROM GT_SCP0098_ITEM_LIST_YYYYMM;
        DELETE FROM GT_SCP0098_STD_LINE_DATA;
        DELETE FROM GT_SCP0098_STD_ITEM_DATA;
        DELETE FROM GT_SCP0098_TARGET_MEASURE;
        DELETE FROM GT_SCP0098_LINE_MEASURE;
        DELETE FROM GT_SCP0098_LINE_MEAS_DIST;
        DELETE FROM GT_SCP0098_ITEM_MEASURE;
        DELETE FROM GT_SCP0098_PROD_READY_RATE;
        DELETE FROM GT_SCP0098_MEAS_WORK;
        DELETE FROM GT_SCP0098_DAILYCAPA_DAY;
        DELETE FROM GT_SCP0098_ITEM_LIST_TERM;
        DELETE FROM GT_SCP0098_MEAS_CAPA;
        DELETE FROM GT_SCP0098_MEAS_CAPA_NOWORK;
        DELETE FROM GT_SCP0098_OEE_TERM;
        DELETE FROM GT_SCP0098_CAPA_YMD;
        DELETE FROM GT_SCP0098_CAPA_YMD_CALC;

        V_TODAY_YYYYMM := SUBSTR(P_TODAY_YYYYMMDD, 1, 6);

        /* 조회 날짜 설정 */
        V_START_MONTH := SUBSTR(P_FROM_YYYYMMDD, 1, 6); /* 현재일 */
        V_END_MONTH   := SUBSTR(P_TO_YYYYMMDD  , 1, 6); /* 조회일자가 기준을 넘을 경우 Y+1 으로 조회 */

        V_TODAY_YYYYMM_FIRSTDAY := V_TODAY_YYYYMM || '01';

        /* #TMP_SCP0098_ITEM_LIST_ALL) LOCATION_GROUP_ROUTE */
        /* [PJ20257329] 2025.08.01 Cell 완성 공정 하드코딩 변경 — 테이블 변수 대신 IN 서브쿼리로 옮겼다 */
        /* ★ PRIORITY 조건이 조인절이 아니라 WHERE 에 있어 품목 배정이 없는 라인은 제외된다(AS-IS 그대로) */
        INSERT INTO GT_SCP0098_ITEM_LIST
             ( DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , OPERATION_GROUP_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , ITEM_CLASS
             )
--        SELECT DISTINCT
        SELECT /*+ NO_MERGE(IA) */ DISTINCT /* AJS 20261007 속도 */
               IA.DIVISION_ID
             , IA.COMPANY_ID
             , IA.SITE_ID
             , IA.PLANT_ID
             , IA.OPERATION_GROUP_ID
             , IA.FACTORY_ID
             , IA.OPERATION_ID
             , IA.LINE_ID
             , XA.ITEM_ID
             , ( SELECT MAX(SA.ITEM_CLASS)
                   FROM SCM_ITEM_M_SN SA
                  WHERE SA.COMPANY_ID  = XA.COMPANY_ID
                    AND SA.DIVISION_ID = XA.DIVISION_ID
                    AND SA.SITE_ID     = XA.SITE_ID
                    AND SA.ITEM_ID     = XA.ITEM_ID
                    AND SA.ITEM_CLASS  = 'ES1901'
                    AND SA.ACTIVE_FLAG = 'Y' ) AS ITEM_CLASS
          FROM ( SELECT DISTINCT
                        DIVISION_ID
                      , COMPANY_ID
                      , SITE_ID
                      , PLANT_ID
                      , OPERATION_GROUP_ID
                      , FACTORY_ID
                      , OPERATION_ID
                      , LINE_ID
                   FROM SCM_LINE_HIERARCHY_V_SN
                  WHERE OPERATION_ID IN ( SELECT SEGMENT1
                                            FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                           WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                             AND SEGMENT3    = 'A'   /* 공정그룹(Cell) */
                                             AND ATTRIBUTE1  = 'Y' ) /* Final Operation */
                    AND ( TRIM(P_DIVISION_ID) IS NULL OR DIVISION_ID IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_DIVISION_ID, ',')) ) )
                    AND ( TRIM(P_PLANT_ID)    IS NULL OR PLANT_ID    IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_PLANT_ID, ',')) ) )
                    AND ( TRIM(P_LINE_ID)     IS NULL OR LINE_ID     IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_LINE_ID, ',')) ) )
               ) IA
             , ( SELECT SA.COMPANY_ID
                      , SA.DIVISION_ID
                      , SA.SITE_ID
                      , SA.PLANT_ID
                      , SA.FACTORY_ID
                      , SA.LINE_ID
                      , SA.OPERATION_ID
                      , SA.ITEM_ID
                      , SA.PRIORITY
                   FROM SCM_MST_ITEM_LINE_ASSIGN_SN SA
                  WHERE SA.MONTH   >= V_START_MONTH
                    AND SA.MONTH   <= V_END_MONTH
                    AND SA.ITEM_ID NOT LIKE 'AJR%'
                    AND SA.ITEM_ID IS NOT NULL
                    AND ( TRIM(P_ITEM_ID) IS NULL OR SA.ITEM_ID IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) ) )
               ) XA
         WHERE IA.DIVISION_ID  = XA.DIVISION_ID(+)
           AND IA.SITE_ID      = XA.SITE_ID(+)
           AND IA.PLANT_ID     = XA.PLANT_ID(+)
           AND IA.FACTORY_ID   = XA.FACTORY_ID(+)
           AND IA.LINE_ID      = XA.LINE_ID(+)
           AND IA.OPERATION_ID = XA.OPERATION_ID(+)
           AND XA.PRIORITY     NOT IN ('0', '9')
        ;

        /* #TMP_SCP0098_ITEM_LIST_YYYYMM */
        INSERT INTO GT_SCP0098_ITEM_LIST_YYYYMM
             ( DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMM
             )
        SELECT A.DIVISION_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.ITEM_ID
             , B.MONTH AS YYYYMM
          FROM GT_SCP0098_ITEM_LIST A
             , SCM_MST_ITEM_LINE_ASSIGN_SN B
         WHERE A.COMPANY_ID   = B.COMPANY_ID
           AND A.DIVISION_ID  = B.DIVISION_ID
           AND A.SITE_ID      = B.SITE_ID
           AND A.PLANT_ID     = B.PLANT_ID
           AND A.FACTORY_ID   = B.FACTORY_ID
           AND A.OPERATION_ID = B.OPERATION_ID
           AND A.LINE_ID      = B.LINE_ID
           AND A.ITEM_ID      = B.ITEM_ID
           AND B.MONTH        >= V_START_MONTH
           AND B.MONTH        <= V_END_MONTH
        ;

        /* #TMP_SCP0098_STD_LINE_DATA) Line List */
        INSERT INTO GT_SCP0098_STD_LINE_DATA
             ( DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , SITE_NAME
             , FACTORY_NAME
             , OPERATION_GROUP_ID
             , OPERATION_GROUP_NAME
             , LINE_NAME
             , OPERATION_NAME
             )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , NVL(B.SITE_NAME      , '-') AS SITE_NAME
             , NVL(B.FACTORY_NAME   , '-') AS FACTORY_NAME
             , B.OPERATION_GROUP_ID
             , NVL(B.OPERATION_GROUP, '-') AS OPERATION_GROUP_NAME
             , NVL(B.LINE_NAME      , '-') AS LINE_NAME
             , NVL(B.OPERATION_NAME , '-') AS OPERATION_NAME
          FROM GT_SCP0098_ITEM_LIST A
             , SCM_LINE_HIERARCHY_V_SN B
         WHERE A.COMPANY_ID   = B.COMPANY_ID(+)
           AND A.DIVISION_ID  = B.DIVISION_ID(+)
           AND A.SITE_ID      = B.SITE_ID(+)
           AND A.PLANT_ID     = B.PLANT_ID(+)
           AND A.FACTORY_ID   = B.FACTORY_ID(+)
           AND A.OPERATION_ID = B.OPERATION_ID(+)
           AND A.LINE_ID      = B.LINE_ID(+)
        ;

        /* #TMP_SCP0098_STD_ITEM_DATA) Item List */
        INSERT INTO GT_SCP0098_STD_ITEM_DATA
             ( DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , SITE_NAME
             , FACTORY_NAME
             , OPERATION_GROUP_ID
             , OPERATION_GROUP_NAME
             , LINE_NAME
             , OPERATION_NAME
             , ITEM_ID
             , ITEM_NAME
             )
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SITE_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , NVL(B.SITE_NAME      , '-') AS SITE_NAME
             , NVL(B.FACTORY_NAME   , '-') AS FACTORY_NAME
             , B.OPERATION_GROUP_ID
             , NVL(B.OPERATION_GROUP, '-') AS OPERATION_GROUP_NAME
             , NVL(B.LINE_NAME      , '-') AS LINE_NAME
             , NVL(B.OPERATION_NAME , '-') AS OPERATION_NAME
             , A.ITEM_ID
             , NVL(FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID), '-') AS ITEM_NAME
          FROM GT_SCP0098_ITEM_LIST A
             , SCM_LINE_HIERARCHY_V_SN B
         WHERE A.COMPANY_ID   = B.COMPANY_ID(+)
           AND A.DIVISION_ID  = B.DIVISION_ID(+)
           AND A.SITE_ID      = B.SITE_ID(+)
           AND A.PLANT_ID     = B.PLANT_ID(+)
           AND A.FACTORY_ID   = B.FACTORY_ID(+)
           AND A.OPERATION_ID = B.OPERATION_ID(+)
           AND A.LINE_ID      = B.LINE_ID(+)
        ;

        /* #TARGET_MEASURES */
        INSERT INTO GT_SCP0098_TARGET_MEASURE
             ( MEASURE_UI
             , MEASURE_NAME
             , MEASURE_DB
             , COL_DIV
             , SORT_ORDER_NO
             )
        SELECT IA.MEASURE_UI
             , IA.MEASURE_NAME
             , SUBSTR(IA.MEASURE_UI, 1, INSTR(IA.MEASURE_UI, '_') - 1)                              AS MEASURE_DB
             , SUBSTR(IA.MEASURE_UI, INSTR(IA.MEASURE_UI, '_') + 1, LENGTH(RTRIM(IA.MEASURE_UI)))   AS COL_DIV
             , IA.SORT_ORDER_NO
          FROM ( /* user별 설정한 조회 대상 measure */
                 SELECT UM.COLUMN_NAME       AS MEASURE_UI
                      , M.COLUMN_LABEL_NAME  AS MEASURE_NAME
                      , UM.SORT_ORDER_NO
                   FROM SCM_MST_TITLESET_USER UM
                      , SCM_MST_SHEET_MEASURE M
                  WHERE M.COLUMN_NAME = UM.COLUMN_NAME
                    AND M.PROGRAM_ID  = V_PROGRAM_ID
                    AND M.SHEET_NAME  = V_SHEET_NAME
                    AND M.VALID_YN    = 'Y'
                    AND UM.USER_ID    = P_USER_ID
                    AND UM.PROGRAM_ID = V_PROGRAM_ID
                    AND UM.SHEET_NAME = V_SHEET_NAME

                 UNION ALL
                 /* user별 설정한 measure정보가 없을 경우 default measure를 보여준다. */
                 SELECT M.COLUMN_NAME        AS MEASURE_UI
                      , M.COLUMN_LABEL_NAME  AS MEASURE_NAME
                      , M.SORT_ORDER_NO
                   FROM SCM_MST_SHEET_MEASURE M
                  WHERE M.PROGRAM_ID   = V_PROGRAM_ID
                    AND M.SHEET_NAME   = V_SHEET_NAME
                    AND M.VALID_YN     = 'Y'
                    AND M.DEFAULT_FLAG = 'Y'
                    AND NOT EXISTS ( SELECT 1
                                       FROM SCM_MST_TITLESET_USER SA
                                          , SCM_MST_SHEET_MEASURE SB
                                      WHERE SB.COLUMN_NAME = SA.COLUMN_NAME
                                        AND SB.PROGRAM_ID  = V_PROGRAM_ID
                                        AND SB.SHEET_NAME  = V_SHEET_NAME
                                        AND SB.VALID_YN    = 'Y'
                                        AND SA.USER_ID     = P_USER_ID
                                        AND SA.PROGRAM_ID  = V_PROGRAM_ID
                                        AND SA.SHEET_NAME  = V_SHEET_NAME )
               ) IA
        ;

        /* #TMP_LIST)
           1) Line / Measure Cross = NO work, Ramp up, Load Rate
           2) ITEM / Measure Cross = Daily Capa                    */
        INSERT INTO GT_SCP0098_LINE_MEASURE
             ( DIVISION_ID
             , COMPANY_ID
             , SCM_SITE
             , SITE_NAME
             , PLANT_ID
             , OPERATION_GROUP_ID
             , FACTORY_ID
             , FACTORY_NAME
             , OPERATION_ID
             , OPERATION_NAME
             , LINE_ID
             , LINE_NAME
             , MEASURE_UI
             , MEASURE_NAME
             , MEASURE_DB
             , COL_DIV
             , SORT_ORDER_NO
             , ITEM_ID
             , ITEM_NAME
             )
        SELECT T.DIVISION_ID
             , T.COMPANY_ID
             , T.SITE_ID AS SCM_SITE
             , T.SITE_NAME
             , T.PLANT_ID
             , T.OPERATION_GROUP_ID
             , T.FACTORY_ID
             , T.FACTORY_NAME
             , T.OPERATION_ID
             , T.OPERATION_NAME
             , T.LINE_ID
             , T.LINE_NAME
             , M.MEASURE_UI
             , M.MEASURE_NAME
             , M.MEASURE_DB
             , M.COL_DIV
             , M.SORT_ORDER_NO
             , '/' AS ITEM_ID
             , '-' AS ITEM_NAME
          FROM GT_SCP0098_STD_LINE_DATA T
             , GT_SCP0098_TARGET_MEASURE M
         WHERE M.MEASURE_UI != 'DAILY_CAPA'
        ;

        INSERT INTO GT_SCP0098_LINE_MEAS_DIST
             ( DIVISION_ID
             , COMPANY_ID
             , SCM_SITE
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_GROUP_ID
             , OPERATION_ID
             , LINE_ID
             , MEASURE_UI
             , SITE_NAME
             , FACTORY_NAME
             , LINE_NAME
             , OPERATION_NAME
             , MEASURE_NAME
             , SORT_ORDER_NO
             )
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.SCM_SITE
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_GROUP_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.MEASURE_UI
             , MAX(A.SITE_NAME)      AS SITE_NAME
             , MAX(A.FACTORY_NAME)   AS FACTORY_NAME
             , MAX(A.LINE_NAME)      AS LINE_NAME
             , MAX(A.OPERATION_NAME) AS OPERATION_NAME
             , MAX(A.MEASURE_NAME)   AS MEASURE_NAME
             , MAX(A.SORT_ORDER_NO)  AS SORT_ORDER_NO
          FROM GT_SCP0098_LINE_MEASURE A
        GROUP BY A.DIVISION_ID
               , A.COMPANY_ID
               , A.SCM_SITE
               , A.PLANT_ID
               , A.FACTORY_ID
               , A.OPERATION_GROUP_ID
               , A.OPERATION_ID
               , A.LINE_ID
               , A.MEASURE_UI
        ;

        INSERT INTO GT_SCP0098_ITEM_MEASURE
             ( DIVISION_ID
             , COMPANY_ID
             , SCM_SITE
             , SITE_NAME
             , PLANT_ID
             , OPERATION_GROUP_ID
             , FACTORY_ID
             , FACTORY_NAME
             , OPERATION_ID
             , OPERATION_NAME
             , LINE_ID
             , LINE_NAME
             , MEASURE_UI
             , MEASURE_NAME
             , MEASURE_DB
             , COL_DIV
             , SORT_ORDER_NO
             , ITEM_ID
             , ITEM_NAME
             )
        SELECT T.DIVISION_ID
             , T.COMPANY_ID
             , T.SITE_ID AS SCM_SITE
             , T.SITE_NAME
             , T.PLANT_ID
             , T.OPERATION_GROUP_ID
             , T.FACTORY_ID
             , T.FACTORY_NAME
             , T.OPERATION_ID
             , T.OPERATION_NAME
             , T.LINE_ID
             , T.LINE_NAME
             , M.MEASURE_UI
             , M.MEASURE_NAME
             , M.MEASURE_DB
             , M.COL_DIV
             , M.SORT_ORDER_NO
             , T.ITEM_ID   AS ITEM_ID
             , T.ITEM_NAME AS ITEM_NAME
          FROM GT_SCP0098_STD_ITEM_DATA T
             , GT_SCP0098_TARGET_MEASURE M
         WHERE M.MEASURE_UI = 'DAILY_CAPA'
           AND ( TRIM(P_NICK_NAME) IS NULL OR T.ITEM_NAME IN ( SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_NICK_NAME, ',')) ) )
        ;

        /********************************************************************************
        * PROD_READY_RATE
        1, PROD_READY_RATE 변경 가능성 없음으로 추정
        2, TODAY 기준으로 생산준비율 조회
        3, 추후 기간별 생산준비율 관리가 필요할 시 개선 필요
        ********************************************************************************/
        INSERT INTO GT_SCP0098_PROD_READY_RATE
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , PROD_READY_RATE
             )
        SELECT DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , PROD_READY_RATE
          FROM SCP_MST_CAPA_WORK
         WHERE MEASURE  = 'NO_WORK'
           AND YYYYMMDD = V_TODAY_YYYYMM_FIRSTDAY
        ;

        /********************************************************************************
        * #TMP_MEASURE_CAPA_WORK = ( LINE + NO_WORK, LOAD_RATE, RAMP_UP)
        ********************************************************************************/
        INSERT INTO GT_SCP0098_MEAS_WORK
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , BASIS_YYYYMMDD
             , MEASURE
             , VALUE
             )
        SELECT W.DIVISION_ID
             , W.PLANT_ID
             , W.FACTORY_ID
             , W.OPERATION_ID
             , W.LINE_ID
             , 'D_' || W.YYYYMMDD AS BASIS_YYYYMMDD
             , W.MEASURE
             , CAST(NVL(W.VALUE, 0) AS NUMBER(13,2)) AS VALUE
          FROM SCP_MST_CAPA_WORK W
             , GT_SCP0098_STD_LINE_DATA D
         WHERE W.DIVISION_ID  = D.DIVISION_ID
           AND W.PLANT_ID     = D.PLANT_ID
           AND W.FACTORY_ID   = D.FACTORY_ID
           AND W.OPERATION_ID = D.OPERATION_ID
           AND W.LINE_ID      = D.LINE_ID
           AND W.YYYYMMDD     >= P_FROM_YYYYMMDD
           AND W.YYYYMMDD     <= P_TO_YYYYMMDD
        ;

        /********************************************************************************
        *#TMP_DAILYCAPA_DAY
        ********************************************************************************/
        INSERT INTO GT_SCP0098_DAILYCAPA_DAY
             ( BASIS_YYYYMMDD
             , MEASURE
             , YYYYMMDD
             )
        SELECT 'D_' || BASIS_YYYYMMDD          AS BASIS_YYYYMMDD
             , 'DAILY_CAPA'                    AS MEASURE
             , SUBSTR(BASIS_YYYYMMDD, 1, 6)    AS YYYYMMDD
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
           AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD
        ;

        /********************************************************************************
        * #TMP_SCP0098_ITEM_LIST_YYYYMM_TERM
        ********************************************************************************/
        INSERT INTO GT_SCP0098_ITEM_LIST_TERM
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMM
             )
        SELECT IA.DIVISION_ID
             , IA.PLANT_ID
             , IA.FACTORY_ID
             , IA.OPERATION_ID
             , IA.LINE_ID
             , IA.ITEM_ID
             , XA.YYYYMMDD AS YYYYMM
          FROM ( SELECT DISTINCT
                        DIVISION_ID
                      , PLANT_ID
                      , FACTORY_ID
                      , OPERATION_ID
                      , LINE_ID
                      , ITEM_ID
                   FROM GT_SCP0098_ITEM_LIST_YYYYMM ) IA
             , ( SELECT DISTINCT YYYYMMDD
                   FROM GT_SCP0098_DAILYCAPA_DAY ) XA
        ;

        /********************************************************************************
        * #TMP_MEASURE_CAPA
        ********************************************************************************/
        INSERT INTO GT_SCP0098_MEAS_CAPA
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMM
             , BASIS_YYYYMM
             , VALUE
             )
        SELECT B.DIVISION_ID
             , B.PLANT_ID
             , B.FACTORY_ID
             , B.OPERATION_ID
             , B.LINE_ID
             , B.ITEM_ID
             , NVL(W.YYYYMM, B.YYYYMM)          AS YYYYMM
             , 'M_' || NVL(W.YYYYMM, B.YYYYMM)  AS BASIS_YYYYMM
             , CAST(NVL(W.VALUE, 0) AS NUMBER(13,0)) AS VALUE
          FROM GT_SCP0098_ITEM_LIST_TERM B
             , SCP_MST_CAPA W
         WHERE W.DIVISION_ID(+)  = B.DIVISION_ID
           AND W.PLANT_ID(+)     = B.PLANT_ID
           AND W.FACTORY_ID(+)   = B.FACTORY_ID
           AND W.OPERATION_ID(+) = B.OPERATION_ID
           AND W.LINE_ID(+)      = B.LINE_ID
           AND W.ITEM_ID(+)      = B.ITEM_ID
           AND W.YYYYMM(+)       = B.YYYYMM
           AND B.YYYYMM          >= V_START_MONTH
           AND B.YYYYMM          <= V_END_MONTH
        ;

        /********************************************************************************
        * OEE = Capa/일
        ********************************************************************************/
        INSERT INTO GT_SCP0098_OEE_TERM
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , YYYYMM
             , VALUE
             )
        SELECT B.DIVISION_ID
             , B.PLANT_ID
             , B.FACTORY_ID
             , B.OPERATION_ID
             , B.LINE_ID
             , B.ITEM_ID
             , B.YYYYMM
             , NVL(W.VALUE, 0) AS VALUE
          FROM GT_SCP0098_ITEM_LIST_TERM B
             , SCP_MST_CAPA W
         WHERE W.DIVISION_ID(+)  = B.DIVISION_ID
           AND W.PLANT_ID(+)     = B.PLANT_ID
           AND W.FACTORY_ID(+)   = B.FACTORY_ID
           AND W.OPERATION_ID(+) = B.OPERATION_ID
           AND W.LINE_ID(+)      = B.LINE_ID
           AND W.ITEM_ID(+)      = B.ITEM_ID
           AND W.YYYYMM(+)       = B.YYYYMM
           AND B.YYYYMM          >= V_START_MONTH
           AND B.YYYYMM          <= V_END_MONTH
        ;

        /********************************************************************************
        * Daily Cala Value Calc
        ********************************************************************************/
        INSERT INTO GT_SCP0098_CAPA_YMD
             ( DIVISION_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ITEM_ID
             , VALUE
             , MEASURE
             , BASIS_YYYYMMDD
             )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.FACTORY_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.ITEM_ID
             , A.VALUE
             , IA.MEASURE
             , IA.BASIS_YYYYMMDD
          FROM GT_SCP0098_MEAS_CAPA A
             , GT_SCP0098_DAILYCAPA_DAY IA
         WHERE A.YYYYMM = IA.YYYYMMDD
        ;

        /* PIVOIT Column 처리
           ★ 동적 SQL 로 남기는 유일한 자리 : 조회 기간에 따라 일자 · 월 칸 이름이 달라지는 피벗이라
             정적 SQL 로 옮길 수 없다. 나머지는 모두 정적 SQL 이다. */
        V_MQRY_FIELD           := NULL;
        V_MQRY_FIELD_LAST      := NULL;
        V_MQRY_FIELD_PRODREADY := NULL;
        V_PIVOT_AGG            := NULL;
        V_OEE_PIVOT            := NULL; /* AJS 20261007 속도 */

        FOR C1 IN ( SELECT YYYYMMDD
                      FROM ( SELECT 'M_' || A.BASIS_YYYYMM                AS YYYYMMDD
                                  , MIN(A.BASIS_START_DATE) || '01'       AS SORT_ORDER_NO
                               FROM SCM_SYS_CALENDAR_M A
                              WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                                AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM
                                  , A.MONTH_NAME
                           ) IA
                     WHERE YYYYMMDD LIKE 'M_%'
                  ORDER BY SORT_ORDER_NO )
        LOOP
--            V_MQRY_FIELD_PRODREADY := V_MQRY_FIELD_PRODREADY
--                                   || '     , CASE WHEN MEASURE_UI = ''DAILY_CAPA'''                       || CHR(10)
--                                   || '            THEN NVL( ( SELECT MAX(VALUE)'                           || CHR(10)
--                                   || '                          FROM GT_SCP0098_OEE_TERM'                  || CHR(10)
--                                   || '                         WHERE DIVISION_ID  = A.DIVISION_ID'         || CHR(10)
--                                   || '                           AND PLANT_ID     = A.PLANT_ID'            || CHR(10)
--                                   || '                           AND FACTORY_ID   = A.FACTORY_ID'          || CHR(10)
--                                   || '                           AND OPERATION_ID = A.OPERATION_ID'        || CHR(10)
--                                   || '                           AND LINE_ID      = A.LINE_ID'             || CHR(10)
--                                   || '                           AND ITEM_ID      = A.ITEM_ID'             || CHR(10)
--                                   || '                           AND YYYYMM       = ''' || SUBSTR(C1.YYYYMMDD, 3) || ''' ), 0)' || CHR(10)
--                                   || '            ELSE NULL'                                               || CHR(10)
--                                   || '       END AS ' || C1.YYYYMMDD                                       || CHR(10);
            V_MQRY_FIELD_PRODREADY := V_MQRY_FIELD_PRODREADY /* AJS 20261007 속도 */
                                   || '     , CASE WHEN MEASURE_UI = ''DAILY_CAPA'''                       || CHR(10) /* AJS 20261007 속도 */
                                   || '            THEN NVL(XA.OEE_' || C1.YYYYMMDD || ', 0)'               || CHR(10) /* AJS 20261007 속도 */
                                   || '            ELSE NULL'                                               || CHR(10) /* AJS 20261007 속도 */
                                   || '       END AS ' || C1.YYYYMMDD                                       || CHR(10); /* AJS 20261007 속도 */

            V_OEE_PIVOT := V_OEE_PIVOT /* AJS 20261007 속도 */
                        || '              , MAX(CASE WHEN YYYYMM = ''' || SUBSTR(C1.YYYYMMDD, 3) || ''' THEN VALUE END) AS OEE_' || C1.YYYYMMDD || CHR(10); /* AJS 20261007 속도 */
        END LOOP;

        FOR C2 IN ( SELECT YYYYMMDD
                      FROM ( SELECT 'D_' || A.BASIS_YYYYMMDD              AS YYYYMMDD
                                  , A.BASIS_YYYYMMDD || '31'              AS SORT_ORDER_NO
                               FROM SCM_SYS_CALENDAR_M A
                              WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                                AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMMDD
                           ) IA
                     WHERE YYYYMMDD LIKE 'D_%'
                  ORDER BY SORT_ORDER_NO )
        LOOP
            V_MQRY_FIELD := V_MQRY_FIELD || '     , ' || C2.YYYYMMDD || CHR(10);

            V_PIVOT_AGG  := V_PIVOT_AGG
                         || '     , MAX(CASE WHEN A.BASIS_YYYYMMDD = ''' || C2.YYYYMMDD || ''' THEN A.VALUE END) AS ' || C2.YYYYMMDD || CHR(10);

            V_MQRY_FIELD_LAST := V_MQRY_FIELD_LAST
                              || '     , CASE WHEN MEASURE_UI = ''NO_WORK''   AND ' || C2.YYYYMMDD || ' = 1  THEN ''Y'''  || CHR(10)
                              || '            WHEN MEASURE_UI = ''NO_WORK''   AND ' || C2.YYYYMMDD || ' != 1 THEN '''''   || CHR(10)
                              || '            WHEN MEASURE_UI = ''LOAD_RATE'' THEN NVL(TO_CHAR(' || C2.YYYYMMDD || ', ''FM999999999999990.00''), ''100'')' || CHR(10)
                              || '            WHEN MEASURE_UI = ''RAMP_UP''   THEN NVL(TO_CHAR(' || C2.YYYYMMDD || ', ''FM999999999999990.00''), ''1'')'   || CHR(10)
                              || '            ELSE TO_CHAR(' || C2.YYYYMMDD || ', ''FM999999999999990.00'')'  || CHR(10)
                              || '       END AS ' || C2.YYYYMMDD                                            || CHR(10);
        END LOOP;

        V_MEXEC := 'SELECT DIVISION_ID'                                              || CHR(10)
                || '     , PLANT_ID'                                                 || CHR(10)
                || '     , FACTORY_ID'                                               || CHR(10)
                || '     , OPERATION_ID'                                             || CHR(10)
                || '     , LINE_ID'                                                  || CHR(10)
                || '     , MEASURE_UI'                                               || CHR(10)
                || '     , ITEM_ID'                                                  || CHR(10)
                || '     , ITEM_NAME'                                                || CHR(10)
                || '     , FACTORY_NAME'                                             || CHR(10)
                || '     , LINE_NAME'                                                || CHR(10)
                || '     , MEASURE_NAME'                                             || CHR(10)
                || '     , SORT_ORDER_NO'                                            || CHR(10)
                || V_MQRY_FIELD_PRODREADY
                || V_MQRY_FIELD_LAST
                || '     , NVL(PRODUCT_READY, 100) AS PRODUCT_READY'                 || CHR(10)
                || '  FROM ( SELECT DATA.DIVISION_ID'                                || CHR(10)
                || '              , DATA.PLANT_ID'                                   || CHR(10)
                || '              , DATA.FACTORY_ID'                                 || CHR(10)
                || '              , DATA.OPERATION_ID'                               || CHR(10)
                || '              , DATA.LINE_ID'                                    || CHR(10)
                || '              , DATA.MEASURE_UI'                                 || CHR(10)
                || '              , DATA.ITEM_ID'                                    || CHR(10)
                || '              , DATA.ITEM_NAME'                                  || CHR(10)
                || '              , DATA.FACTORY_NAME'                               || CHR(10)
                || '              , DATA.LINE_NAME'                                  || CHR(10)
                || '              , DATA.MEASURE_NAME'                               || CHR(10)
                || '              , DATA.SORT_ORDER_NO'                              || CHR(10)
                || REPLACE(V_MQRY_FIELD, '     , ', '              , DATA.')
                || '              , ( SELECT MAX(PROD_READY_RATE)'                   || CHR(10)
                || '                    FROM GT_SCP0098_PROD_READY_RATE'             || CHR(10)
                || '                   WHERE DIVISION_ID  = DATA.DIVISION_ID'        || CHR(10)
                || '                     AND PLANT_ID     = DATA.PLANT_ID'           || CHR(10)
                || '                     AND FACTORY_ID   = DATA.FACTORY_ID'         || CHR(10)
                || '                     AND OPERATION_ID = DATA.OPERATION_ID'       || CHR(10)
                || '                     AND LINE_ID      = DATA.LINE_ID ) AS PRODUCT_READY' || CHR(10)
                || '           FROM ( SELECT A.DIVISION_ID'                          || CHR(10)
                || '                       , A.PLANT_ID'                             || CHR(10)
                || '                       , A.FACTORY_ID'                           || CHR(10)
                || '                       , A.OPERATION_ID'                         || CHR(10)
                || '                       , A.LINE_ID'                              || CHR(10)
                || '                       , A.MEASURE   AS MEASURE_UI'              || CHR(10)
                || '                       , A.ITEM_ID   AS ITEM_ID'                 || CHR(10)
                || '                       , L.ITEM_NAME AS ITEM_NAME'               || CHR(10)
                || '                       , L.FACTORY_NAME'                         || CHR(10)
                || '                       , L.LINE_NAME'                            || CHR(10)
                || '                       , L.MEASURE_NAME'                         || CHR(10)
                || '                       , L.SORT_ORDER_NO'                        || CHR(10)
                || REPLACE(V_PIVOT_AGG, '     , ', '                       , ')
                || '                    FROM GT_SCP0098_CAPA_YMD A'                  || CHR(10)
                || '                       , GT_SCP0098_ITEM_MEASURE L'              || CHR(10)
                || '                   WHERE A.DIVISION_ID  = L.DIVISION_ID'         || CHR(10)
                || '                     AND A.PLANT_ID     = L.PLANT_ID'            || CHR(10)
                || '                     AND A.FACTORY_ID   = L.FACTORY_ID'          || CHR(10)
                || '                     AND A.OPERATION_ID = L.OPERATION_ID'        || CHR(10)
                || '                     AND A.LINE_ID      = L.LINE_ID'             || CHR(10)
                || '                     AND A.ITEM_ID      = L.ITEM_ID'             || CHR(10)
                || '                     AND A.MEASURE      = L.MEASURE_UI'          || CHR(10)
                || '                 GROUP BY A.DIVISION_ID'                         || CHR(10)
                || '                        , A.PLANT_ID'                            || CHR(10)
                || '                        , A.FACTORY_ID'                          || CHR(10)
                || '                        , A.OPERATION_ID'                        || CHR(10)
                || '                        , A.LINE_ID'                             || CHR(10)
                || '                        , A.MEASURE'                             || CHR(10)
                || '                        , A.ITEM_ID'                             || CHR(10)
                || '                        , L.ITEM_NAME'                           || CHR(10)
                || '                        , L.FACTORY_NAME'                        || CHR(10)
                || '                        , L.LINE_NAME'                           || CHR(10)
                || '                        , L.MEASURE_NAME'                        || CHR(10)
                || '                        , L.SORT_ORDER_NO'                       || CHR(10)
                || '                  UNION ALL'                                     || CHR(10)
                || '                  SELECT A.DIVISION_ID'                          || CHR(10)
                || '                       , A.PLANT_ID'                             || CHR(10)
                || '                       , A.FACTORY_ID'                           || CHR(10)
                || '                       , A.OPERATION_ID'                         || CHR(10)
                || '                       , A.LINE_ID'                              || CHR(10)
                || '                       , A.MEASURE AS MEASURE_UI'                || CHR(10)
                || '                       , '' ''     AS ITEM_ID'                   || CHR(10)
                || '                       , '' ''     AS ITEM_NAME'                  || CHR(10)
                || '                       , L.FACTORY_NAME'                         || CHR(10)
                || '                       , L.LINE_NAME'                            || CHR(10)
                || '                       , L.MEASURE_NAME'                         || CHR(10)
                || '                       , L.SORT_ORDER_NO'                        || CHR(10)
                || REPLACE(V_PIVOT_AGG, '     , ', '                       , ')
                || '                    FROM GT_SCP0098_MEAS_WORK A'                 || CHR(10)
                || '                       , GT_SCP0098_LINE_MEAS_DIST L'            || CHR(10)
                || '                   WHERE A.DIVISION_ID  = L.DIVISION_ID'         || CHR(10)
                || '                     AND A.PLANT_ID     = L.PLANT_ID'            || CHR(10)
                || '                     AND A.FACTORY_ID   = L.FACTORY_ID'          || CHR(10)
                || '                     AND A.OPERATION_ID = L.OPERATION_ID'        || CHR(10)
                || '                     AND A.LINE_ID      = L.LINE_ID'             || CHR(10)
                || '                     AND A.MEASURE      = L.MEASURE_UI'          || CHR(10)
                || '                     AND A.MEASURE      != ''DAILY_CAPA'''       || CHR(10)
                || '                 GROUP BY A.DIVISION_ID'                         || CHR(10)
                || '                        , A.PLANT_ID'                            || CHR(10)
                || '                        , A.FACTORY_ID'                          || CHR(10)
                || '                        , A.OPERATION_ID'                        || CHR(10)
                || '                        , A.LINE_ID'                             || CHR(10)
                || '                        , A.MEASURE'                             || CHR(10)
                || '                        , L.FACTORY_NAME'                        || CHR(10)
                || '                        , L.LINE_NAME'                           || CHR(10)
                || '                        , L.MEASURE_NAME'                        || CHR(10)
                || '                        , L.SORT_ORDER_NO'                       || CHR(10)
                || '                ) DATA'                                          || CHR(10)
                || '       ) A'                                                      || CHR(10)
                || '     , ( SELECT DIVISION_ID  AS OT_DIVISION_ID'                  || CHR(10) /* AJS 20261007 속도 */
                || '              , PLANT_ID     AS OT_PLANT_ID'                     || CHR(10) /* AJS 20261007 속도 */
                || '              , FACTORY_ID   AS OT_FACTORY_ID'                   || CHR(10) /* AJS 20261007 속도 */
                || '              , OPERATION_ID AS OT_OPERATION_ID'                 || CHR(10) /* AJS 20261007 속도 */
                || '              , LINE_ID      AS OT_LINE_ID'                      || CHR(10) /* AJS 20261007 속도 */
                || '              , ITEM_ID      AS OT_ITEM_ID'                      || CHR(10) /* AJS 20261007 속도 */
                || V_OEE_PIVOT /* AJS 20261007 속도 */
                || '           FROM GT_SCP0098_OEE_TERM'                             || CHR(10) /* AJS 20261007 속도 */
                || '          GROUP BY DIVISION_ID'                                  || CHR(10) /* AJS 20261007 속도 */
                || '                 , PLANT_ID'                                     || CHR(10) /* AJS 20261007 속도 */
                || '                 , FACTORY_ID'                                   || CHR(10) /* AJS 20261007 속도 */
                || '                 , OPERATION_ID'                                 || CHR(10) /* AJS 20261007 속도 */
                || '                 , LINE_ID'                                      || CHR(10) /* AJS 20261007 속도 */
                || '                 , ITEM_ID ) XA'                                 || CHR(10) /* AJS 20261007 속도 */
                || ' WHERE XA.OT_DIVISION_ID(+)  = A.DIVISION_ID'                    || CHR(10) /* AJS 20261007 속도 */
                || '   AND XA.OT_PLANT_ID(+)     = A.PLANT_ID'                       || CHR(10) /* AJS 20261007 속도 */
                || '   AND XA.OT_FACTORY_ID(+)   = A.FACTORY_ID'                     || CHR(10) /* AJS 20261007 속도 */
                || '   AND XA.OT_OPERATION_ID(+) = A.OPERATION_ID'                   || CHR(10) /* AJS 20261007 속도 */
                || '   AND XA.OT_LINE_ID(+)      = A.LINE_ID'                        || CHR(10) /* AJS 20261007 속도 */
                || '   AND XA.OT_ITEM_ID(+)      = A.ITEM_ID'                        || CHR(10) /* AJS 20261007 속도 */
                || 'ORDER BY DIVISION_ID'                                            || CHR(10)
                || '       , PLANT_ID'                                               || CHR(10)
                || '       , FACTORY_ID'                                             || CHR(10)
                || '       , OPERATION_ID'                                           || CHR(10)
                || '       , LINE_ID'                                                || CHR(10)
                || '       , SORT_ORDER_NO'                                          || CHR(10)
                || '       , ITEM_ID'                                                || CHR(10)
        ;

        OPEN O_RC FOR V_MEXEC;

        OPEN O_RESULT_CURSOR FOR
            SELECT NULL AS ERR_MESSAGE
              FROM DUAL
             WHERE 1 = 0
        ;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MESSAGE := SQLERRM;

            OPEN O_RC FOR
                SELECT NULL AS DUMMY
                  FROM DUAL
                 WHERE 1 = 0
            ;

            OPEN O_RESULT_CURSOR FOR
                SELECT V_ERR_MESSAGE AS ERR_MESSAGE
                  FROM DUAL
            ;
    END P_GET_CAPA_MOBILITYIT_LINE;

/*==================================================================================================
 * Program ID   : SCP0098_SAVE_SCP_CAPA
 * Description  : SCP CAPA SAVE
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/08/25   vadabi3      최초작성
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 *==================================================================================================*/
    PROCEDURE P_SAVE_SCP_CAPA (
        P_ACTIVE_FLAG   IN  VARCHAR2
      , P_DIVISION_ID   IN  VARCHAR2
      , P_PLANT_ID      IN  VARCHAR2
      , P_FACTORY_ID    IN  VARCHAR2
      , P_OPERATION_ID  IN  VARCHAR2
      , P_LINE_ID       IN  VARCHAR2
      , P_ITEM_ID       IN  VARCHAR2
      , P_YYYYMM        IN  VARCHAR2
      , P_VALUE         IN  VARCHAR2
      , P_USER_ID       IN  VARCHAR2
      , O_RC            OUT SYS_REFCURSOR
      , O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    IS
        /* 변수 선언 */
        V_MAX_LOOP_CNT      NUMBER(10) := 0;
        V_MST_LOOP_CNT      NUMBER(10) := 0;
        V_DELIMITER         VARCHAR2(1 CHAR);

        /* 변수 설정 */
        V_DIVISION_ID       VARCHAR2(4000 CHAR);
        V_PLANT_ID          VARCHAR2(4000 CHAR);
        V_FACTORY_ID        VARCHAR2(4000 CHAR);
        V_OPERATION_ID      VARCHAR2(4000 CHAR);
        V_LINE_ID           VARCHAR2(4000 CHAR);
        V_ITEM_ID           VARCHAR2(4000 CHAR);
        V_YYYYMM            VARCHAR2(4000 CHAR);
        V_VALUE             VARCHAR2(4000 CHAR);
        V_UPD_CNT           NUMBER(10) := 0;
        /* AS-IS 는 결과의 @@ROWCOUNT 를 WHILE 루프를 빠져나온 뒤에 읽어 언제나 0 을 돌려준다. 같은 값으로 맞춘다. */
        V_UPDATE_ROW        NUMBER(10) := 0;

        /* Start Log */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0098_SAVE_SCP_CAPA';
        V_LOG_TYPE          VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
        N_LOG_COUNT         NUMBER(10) := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;

        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
    BEGIN

        V_DELIMITER    := '^';
        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER));

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := P_USER_ID || ' : ' || P_ITEM_ID;
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_MAX_LOOP_CNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        WHILE V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;
            V_DIVISION_ID  := SCM_ARR_SPL_VAL(P_DIVISION_ID , V_DELIMITER, V_MST_LOOP_CNT);
            V_PLANT_ID     := SCM_ARR_SPL_VAL(P_PLANT_ID    , V_DELIMITER, V_MST_LOOP_CNT);
            V_FACTORY_ID   := SCM_ARR_SPL_VAL(P_FACTORY_ID  , V_DELIMITER, V_MST_LOOP_CNT);
            V_OPERATION_ID := SCM_ARR_SPL_VAL(P_OPERATION_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_LINE_ID      := SCM_ARR_SPL_VAL(P_LINE_ID     , V_DELIMITER, V_MST_LOOP_CNT);
            V_ITEM_ID      := SCM_ARR_SPL_VAL(P_ITEM_ID     , V_DELIMITER, V_MST_LOOP_CNT);
            V_YYYYMM       := SCM_ARR_SPL_VAL(P_YYYYMM      , V_DELIMITER, V_MST_LOOP_CNT);
            V_VALUE        := SCM_ARR_SPL_VAL(P_VALUE       , V_DELIMITER, V_MST_LOOP_CNT);

            /* AS-IS MERGE 를 UPDATE + INSERT 로 나눈 것 (온라인 SQL 은 MERGE 를 쓰지 않는다) */
            UPDATE SCP_MST_CAPA
               SET VALUE            = TO_NUMBER(V_VALUE)
                 , LAST_UPDATED_BY  = P_USER_ID
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID  = V_DIVISION_ID
               AND PLANT_ID     = V_PLANT_ID
               AND FACTORY_ID   = V_FACTORY_ID
               AND OPERATION_ID = V_OPERATION_ID
               AND LINE_ID      = V_LINE_ID
               AND ITEM_ID      = V_ITEM_ID
               AND YYYYMM       = V_YYYYMM
            ;

            V_UPD_CNT := SQL%ROWCOUNT;

            IF V_UPD_CNT = 0 THEN

                INSERT INTO SCP_MST_CAPA
                     ( DIVISION_ID
                     , PLANT_ID
                     , FACTORY_ID
                     , OPERATION_ID
                     , LINE_ID
                     , ITEM_ID
                     , YYYYMM
                     , VALUE
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                     )
                VALUES
                     ( V_DIVISION_ID
                     , V_PLANT_ID
                     , V_FACTORY_ID
                     , V_OPERATION_ID
                     , V_LINE_ID
                     , V_ITEM_ID
                     , V_YYYYMM
                     , TO_NUMBER(V_VALUE)
                     , P_USER_ID
                     , SYSDATE
                     , P_USER_ID
                     , SYSDATE
                     )
                ;

                V_UPD_CNT := SQL%ROWCOUNT;

            END IF;

        END LOOP;

        /* Finish Log */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := P_USER_ID || ' : ' || P_VALUE;
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        /* 결과 코드 반환 */
        OPEN O_RC FOR
            SELECT 'S'          AS RESULT_CODE
                 , V_UPDATE_ROW AS UPDATE_ROW
              FROM DUAL
        ;

        OPEN O_RESULT_CURSOR FOR
            SELECT NULL AS ERR_MESSAGE
              FROM DUAL
             WHERE 1 = 0
        ;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MESSAGE := SQLERRM;

            /* Error Log */
            INSERT INTO SCM_SYS_LOG_BATCH ( PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY )
            VALUES ( V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, P_USER_ID || P_VALUE, SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME )
            ;

            /* AS-IS 는 CATCH 에서 ROLLBACK 없이 COMMIT WORK 를 한다. 같은 동작으로 둔다. */
            COMMIT;

            OPEN O_RC FOR
                SELECT 'S' AS RESULT_CODE
                     , 0   AS UPDATE_ROW
                  FROM DUAL
                 WHERE 1 = 0
            ;

            OPEN O_RESULT_CURSOR FOR
                SELECT V_ERR_MESSAGE AS ERR_MESSAGE
                  FROM DUAL
            ;
    END P_SAVE_SCP_CAPA;

/*==================================================================================================
 * Program ID   : SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE
 * Description  : SCP CAPA SAVE
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/08/25   vadabi3      최초작성
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 *==================================================================================================*/
    PROCEDURE P_SAVE_SCP_CAPA_PRODUCT_RATE (
        P_ACTIVE_FLAG     IN  VARCHAR2
      , P_DIVISION_ID     IN  VARCHAR2
      , P_PLANT_ID        IN  VARCHAR2
      , P_FACTORY_ID      IN  VARCHAR2
      , P_OPERATION_ID    IN  VARCHAR2
      , P_LINE_ID         IN  VARCHAR2
      , P_START_YYYYMMDD  IN  VARCHAR2
      , P_END_YYYYMMDD    IN  VARCHAR2
      , P_PRODUCT_RATE    IN  VARCHAR2
      , P_USER_ID         IN  VARCHAR2
      , O_RC              OUT SYS_REFCURSOR
      , O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        /* 변수 선언 */
        V_MAX_LOOP_CNT      NUMBER(10) := 0;
        V_MST_LOOP_CNT      NUMBER(10) := 0;
        V_DELIMITER         VARCHAR2(1 CHAR);

        /* 변수 설정 */
        V_DIVISION_ID       VARCHAR2(4000 CHAR);
        V_PLANT_ID          VARCHAR2(4000 CHAR);
        V_FACTORY_ID        VARCHAR2(4000 CHAR);
        V_OPERATION_ID      VARCHAR2(4000 CHAR);
        V_LINE_ID           VARCHAR2(4000 CHAR);
        V_YYYYMMDD          VARCHAR2(4000 CHAR);
        V_PRODUCT_RATE      VARCHAR2(4000 CHAR);
        V_UPD_CNT           NUMBER(10) := 0;
        /* AS-IS 는 결과의 @@ROWCOUNT 를 WHILE 루프를 빠져나온 뒤에 읽어 언제나 0 을 돌려준다. 같은 값으로 맞춘다. */
        V_UPDATE_ROW        NUMBER(10) := 0;

        /* Start Log */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0098_SAVE_SCP_CAPA_PRODUCT_RATE';
        V_LOG_TYPE          VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
        N_LOG_COUNT         NUMBER(10) := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;

        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
    BEGIN

        V_DELIMITER    := '^';
        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER));

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := P_USER_ID || ' : ' || P_START_YYYYMMDD || ' : ' || P_END_YYYYMMDD || ' : ' || P_LINE_ID;
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_MAX_LOOP_CNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        /* TODAY 해당월의 1일 부터 업데이트 구간 */
        V_YYYYMMDD := TO_CHAR(SYSDATE, 'YYYYMM') || '01';

        WHILE V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;
            V_DIVISION_ID  := SCM_ARR_SPL_VAL(P_DIVISION_ID , V_DELIMITER, V_MST_LOOP_CNT);
            V_PLANT_ID     := SCM_ARR_SPL_VAL(P_PLANT_ID    , V_DELIMITER, V_MST_LOOP_CNT);
            V_FACTORY_ID   := SCM_ARR_SPL_VAL(P_FACTORY_ID  , V_DELIMITER, V_MST_LOOP_CNT);
            V_OPERATION_ID := SCM_ARR_SPL_VAL(P_OPERATION_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_LINE_ID      := SCM_ARR_SPL_VAL(P_LINE_ID     , V_DELIMITER, V_MST_LOOP_CNT);
            V_PRODUCT_RATE := SCM_ARR_SPL_VAL(P_PRODUCT_RATE, V_DELIMITER, V_MST_LOOP_CNT);

            /* AS-IS MERGE 를 UPDATE + INSERT 로 나눈 것 (온라인 SQL 은 MERGE 를 쓰지 않는다) */
            /* AS-IS 와 같이 MEASURE 조건이 없어 기준일 이후의 모든 측정값 행이 함께 갱신된다 */
            UPDATE SCP_MST_CAPA_WORK
               SET PROD_READY_RATE  = TO_NUMBER(V_PRODUCT_RATE)
                 , LAST_UPDATED_BY  = P_USER_ID
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID  = V_DIVISION_ID
               AND PLANT_ID     = V_PLANT_ID
               AND FACTORY_ID   = V_FACTORY_ID
               AND OPERATION_ID = V_OPERATION_ID
               AND LINE_ID      = V_LINE_ID
               AND YYYYMMDD     >= V_YYYYMMDD
             /*AND YYYYMMDD     LIKE '%01' */
            ;

            V_UPD_CNT := SQL%ROWCOUNT;

            IF V_UPD_CNT = 0 THEN

                INSERT INTO SCP_MST_CAPA_WORK
                     ( DIVISION_ID
                     , PLANT_ID
                     , FACTORY_ID
                     , OPERATION_ID
                     , LINE_ID
                     , MEASURE
                     , YYYYMMDD
                     , PROD_READY_RATE
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                     )
                VALUES
                     ( V_DIVISION_ID
                     , V_PLANT_ID
                     , V_FACTORY_ID
                     , V_OPERATION_ID
                     , V_LINE_ID
                     , 'NO_WORK'
                     , P_START_YYYYMMDD
                     , TO_NUMBER(V_PRODUCT_RATE)
                     , P_USER_ID
                     , SYSDATE
                     , P_USER_ID
                     , SYSDATE
                     )
                ;

                V_UPD_CNT := SQL%ROWCOUNT;

            END IF;

        END LOOP;

        /* Finish Log */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := P_USER_ID || ' : ' || P_PRODUCT_RATE;
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        /* 결과 코드 반환 */
        OPEN O_RC FOR
            SELECT 'S'          AS RESULT_CODE
                 , V_UPDATE_ROW AS UPDATE_ROW
              FROM DUAL
        ;

        OPEN O_RESULT_CURSOR FOR
            SELECT NULL AS ERR_MESSAGE
              FROM DUAL
             WHERE 1 = 0
        ;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MESSAGE := SQLERRM;

            /* Error Log */
            INSERT INTO SCM_SYS_LOG_BATCH ( PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY )
            VALUES ( V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, P_USER_ID || P_PRODUCT_RATE, SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME )
            ;

            /* AS-IS 는 CATCH 에서 ROLLBACK 없이 COMMIT WORK 를 한다. 같은 동작으로 둔다. */
            COMMIT;

            OPEN O_RC FOR
                SELECT 'S' AS RESULT_CODE
                     , 0   AS UPDATE_ROW
                  FROM DUAL
                 WHERE 1 = 0
            ;

            OPEN O_RESULT_CURSOR FOR
                SELECT V_ERR_MESSAGE AS ERR_MESSAGE
                  FROM DUAL
            ;
    END P_SAVE_SCP_CAPA_PRODUCT_RATE;

/*==================================================================================================
 * Program ID   : SCP0098_SAVE_SCP_CAPA_WORK
 * Description  : SCP CAPA SAVE
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/08/25   vadabi3      최초작성
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 *==================================================================================================*/
    PROCEDURE P_SAVE_SCP_CAPA_WORK (
        P_ACTIVE_FLAG   IN  VARCHAR2
      , P_DIVISION_ID   IN  VARCHAR2
      , P_PLANT_ID      IN  VARCHAR2
      , P_FACTORY_ID    IN  VARCHAR2
      , P_OPERATION_ID  IN  VARCHAR2
      , P_LINE_ID       IN  VARCHAR2
      , P_MEASURE       IN  VARCHAR2
      , P_YYYYMMDD      IN  VARCHAR2
      , P_VALUE         IN  VARCHAR2
      , P_USER_ID       IN  VARCHAR2
      , O_RC            OUT SYS_REFCURSOR
      , O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    IS
        /* 변수 선언 */
        V_MAX_LOOP_CNT      NUMBER(10) := 0;
        V_MST_LOOP_CNT      NUMBER(10) := 0;
        V_DELIMITER         VARCHAR2(1 CHAR);

        /* 변수 설정 */
        V_DIVISION_ID       VARCHAR2(4000 CHAR);
        V_PLANT_ID          VARCHAR2(4000 CHAR);
        V_FACTORY_ID        VARCHAR2(4000 CHAR);
        V_OPERATION_ID      VARCHAR2(4000 CHAR);
        V_LINE_ID           VARCHAR2(4000 CHAR);
        V_MEASURE           VARCHAR2(4000 CHAR);
        V_YYYYMMDD          VARCHAR2(4000 CHAR);
        V_VALUE             VARCHAR2(4000 CHAR);
        V_UPD_CNT           NUMBER(10) := 0;
        /* AS-IS 는 결과의 @@ROWCOUNT 를 WHILE 루프를 빠져나온 뒤에 읽어 언제나 0 을 돌려준다. 같은 값으로 맞춘다. */
        V_UPDATE_ROW        NUMBER(10) := 0;

        /* Start Log */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0098_SAVE_SCP_CAPA_WORK';
        V_LOG_TYPE          VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
        N_LOG_COUNT         NUMBER(10) := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;

        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
    BEGIN

        V_DELIMITER    := '^';
        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER));

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := P_USER_ID || ' : ' || P_LINE_ID;
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_MAX_LOOP_CNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        WHILE V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;
            V_DIVISION_ID  := SCM_ARR_SPL_VAL(P_DIVISION_ID , V_DELIMITER, V_MST_LOOP_CNT);
            V_PLANT_ID     := SCM_ARR_SPL_VAL(P_PLANT_ID    , V_DELIMITER, V_MST_LOOP_CNT);
            V_FACTORY_ID   := SCM_ARR_SPL_VAL(P_FACTORY_ID  , V_DELIMITER, V_MST_LOOP_CNT);
            V_OPERATION_ID := SCM_ARR_SPL_VAL(P_OPERATION_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_LINE_ID      := SCM_ARR_SPL_VAL(P_LINE_ID     , V_DELIMITER, V_MST_LOOP_CNT);
            V_MEASURE      := SCM_ARR_SPL_VAL(P_MEASURE     , V_DELIMITER, V_MST_LOOP_CNT);
            V_YYYYMMDD     := SCM_ARR_SPL_VAL(P_YYYYMMDD    , V_DELIMITER, V_MST_LOOP_CNT);
            V_VALUE        := SCM_ARR_SPL_VAL(P_VALUE       , V_DELIMITER, V_MST_LOOP_CNT);

            /* AS-IS MERGE 를 UPDATE + INSERT 로 나눈 것 (온라인 SQL 은 MERGE 를 쓰지 않는다) */
            UPDATE SCP_MST_CAPA_WORK
               SET VALUE            = TO_NUMBER(V_VALUE)
                 , LAST_UPDATED_BY  = P_USER_ID
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID  = V_DIVISION_ID
               AND PLANT_ID     = V_PLANT_ID
               AND FACTORY_ID   = V_FACTORY_ID
               AND OPERATION_ID = V_OPERATION_ID
               AND LINE_ID      = V_LINE_ID
               AND MEASURE      = V_MEASURE
               AND YYYYMMDD     = V_YYYYMMDD
            ;

            V_UPD_CNT := SQL%ROWCOUNT;

            IF V_UPD_CNT = 0 THEN

                INSERT INTO SCP_MST_CAPA_WORK
                     ( DIVISION_ID
                     , PLANT_ID
                     , FACTORY_ID
                     , OPERATION_ID
                     , LINE_ID
                     , MEASURE
                     , YYYYMMDD
                     , VALUE
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                     )
                VALUES
                     ( V_DIVISION_ID
                     , V_PLANT_ID
                     , V_FACTORY_ID
                     , V_OPERATION_ID
                     , V_LINE_ID
                     , V_MEASURE
                     , V_YYYYMMDD
                     , TO_NUMBER(V_VALUE)
                     , P_USER_ID
                     , SYSDATE
                     , P_USER_ID
                     , SYSDATE
                     )
                ;

                V_UPD_CNT := SQL%ROWCOUNT;

            END IF;

        END LOOP;

        /* Finish Log */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := P_MEASURE || ' : ' || P_VALUE;
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        /* 결과 코드 반환 */
        OPEN O_RC FOR
            SELECT 'S'          AS RESULT_CODE
                 , V_UPDATE_ROW AS UPDATE_ROW
              FROM DUAL
        ;

        OPEN O_RESULT_CURSOR FOR
            SELECT NULL AS ERR_MESSAGE
              FROM DUAL
             WHERE 1 = 0
        ;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MESSAGE := SQLERRM;

            /* Error Log */
            INSERT INTO SCM_SYS_LOG_BATCH ( PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY )
            VALUES ( V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, P_MEASURE || P_VALUE, SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME )
            ;

            /* AS-IS 는 CATCH 에서 ROLLBACK 없이 COMMIT WORK 를 한다. 같은 동작으로 둔다. */
            COMMIT;

            OPEN O_RC FOR
                SELECT 'S' AS RESULT_CODE
                     , 0   AS UPDATE_ROW
                  FROM DUAL
                 WHERE 1 = 0
            ;

            OPEN O_RESULT_CURSOR FOR
                SELECT V_ERR_MESSAGE AS ERR_MESSAGE
                  FROM DUAL
            ;
    END P_SAVE_SCP_CAPA_WORK;

END PKG_SCP0098;