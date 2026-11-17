PACKAGE BODY         PKG_SSP0003
IS
    /*
     * Program ID   : PKG_SSP0003
     * Description  : SSP0003 Shipment Change Request Confirm 화면 - 변경 요청 조회 / 승인 / 반려
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     *                             AS-IS 프로시저 8 건 + 이 화면만 부르는 2 건 패키지 전환
     *                             사용자 TB_FX_User -> SCM_ADM_USER_M (UserName -> USER_NM · UserName_E -> USER_ENG_NM)
     * 2026.10.16   AJS          오류 처리 - 하위 프로그램 확정으로 저장점이 없으면 남은 변경만 되돌림(SSP0200 갭 분석 횡전개)
     */

    C_DELIMITER         CONSTANT VARCHAR2(1 CHAR) := '^';

    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(32767 CHAR) INDEX BY PLS_INTEGER;
    TYPE T_FOUND_TAB IS TABLE OF VARCHAR2(1 CHAR) INDEX BY PLS_INTEGER;

    /* ==============================================================================================
       내부 : 구분자 개수 + 1 (AS-IS SCM_ARR_SPL_CNT 와 같은 값 · CLOB 대응)
       ============================================================================================== */
    FUNCTION F_SPL_CNT
    (
        P_TEXT              IN  CLOB
    )
    RETURN PLS_INTEGER
    IS
        V_CNT               PLS_INTEGER := 1;
        V_POS               PLS_INTEGER;
    BEGIN
        IF P_TEXT IS NULL THEN
            RETURN V_CNT;
        END IF;

        V_POS := DBMS_LOB.INSTR(P_TEXT, C_DELIMITER, 1, 1);

        WHILE V_POS > 0 LOOP
            V_CNT := V_CNT + 1;
            V_POS := DBMS_LOB.INSTR(P_TEXT, C_DELIMITER, V_POS + 1, 1);
        END LOOP;

        RETURN V_CNT;
    END F_SPL_CNT; 

    /* ==============================================================================================
       내부 : 앞뒤 공백을 뺀 마지막 글자 위치 (없으면 0)
       ============================================================================================== */
    FUNCTION F_LAST_NON_SPACE
    (
        P_TEXT              IN  CLOB
    )
    RETURN PLS_INTEGER
    IS
        V_POS               PLS_INTEGER;
    BEGIN
        V_POS := NVL(DBMS_LOB.GETLENGTH(P_TEXT), 0);

        WHILE V_POS > 0
          AND DBMS_LOB.SUBSTR(P_TEXT, 1, V_POS) = ' ' LOOP
            V_POS := V_POS - 1;
        END LOOP;

        RETURN V_POS;
    END F_LAST_NON_SPACE;

    /* ==============================================================================================
       내부 : 구분 문자열을 순서대로 한 번에 분리 (AS-IS SCM_ARR_SPL_VAL 과 같은 규칙 · CLOB 대응)
              - 전체 앞뒤 공백 제거 후 끝에 구분자를 붙인 문자열에서 차례로 잘라 앞뒤 공백 제거
              - 다음 위치 = 현재 위치 + 공백 제거한 값 길이 + 1 (AS-IS 와 같은 계산)
              - O_FOUND = 'Y' : 구분자를 찾은 자리 (값이 비어도 AS-IS 는 빈 문자)
                O_FOUND = 'N' : 구분자를 못 찾은 자리 (AS-IS 는 NULL)
       ============================================================================================== */
    PROCEDURE P_SPL_ARR
    (
        P_TEXT              IN  CLOB,
        P_CNT               IN  PLS_INTEGER,
        O_TOKEN             OUT T_TOKEN_TAB,
        O_FOUND             OUT T_FOUND_TAB
    )
    IS
        V_END               PLS_INTEGER;
        V_OFF               PLS_INTEGER := 1;
        V_POS               PLS_INTEGER;
        V_WORD              VARCHAR2(32767 CHAR);
    BEGIN
        V_END := F_LAST_NON_SPACE(P_TEXT);

        /* 전체 앞 공백 */
        WHILE V_OFF <= V_END
          AND DBMS_LOB.SUBSTR(P_TEXT, 1, V_OFF) = ' ' LOOP
            V_OFF := V_OFF + 1;
        END LOOP;

        FOR I IN 1 .. P_CNT LOOP
            IF P_TEXT IS NULL
            OR V_OFF > V_END + 1 THEN
                O_TOKEN(I) := NULL;
                O_FOUND(I) := 'N';
            ELSE
                V_POS := DBMS_LOB.INSTR(P_TEXT, C_DELIMITER, V_OFF, 1);

                IF V_POS = 0
                OR V_POS > V_END THEN
                    V_POS := V_END + 1;   /* 끝에 붙인 구분자 자리 */
                END IF;

                IF V_POS > V_OFF THEN
                    V_WORD := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_POS - V_OFF, V_OFF));
                ELSE
                    V_WORD := NULL;
                END IF;

                O_TOKEN(I) := V_WORD;
                O_FOUND(I) := 'Y';

                V_OFF := V_OFF + NVL(LENGTH(V_WORD), 0) + 1;

                /* 남은 문자열 앞 공백 */
                WHILE V_OFF <= V_END
                  AND DBMS_LOB.SUBSTR(P_TEXT, 1, V_OFF) = ' ' LOOP
                    V_OFF := V_OFF + 1;
                END LOOP;
            END IF;
        END LOOP;
    END P_SPL_ARR;

    /* ==============================================================================================
       내부 : 오류 이력 남기기 (AS-IS CATCH 의 scm_sys_log_batch INSERT + COMMIT 과 같은 자리)
              자율 트랜잭션으로 남겨 본 트랜잭션의 되돌리기에 영향을 주지 않는다
       ============================================================================================== */
    PROCEDURE P_LOG_ERROR
    (
        P_PROGRAM_NAME      IN  VARCHAR2,
        P_LOG_MESSAGE       IN  VARCHAR2
    )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO SCM_SYS_LOG_BATCH
             (
               PROGRAM_NAME
             , LOG_TYPE
             , LOG_COUNT
             , LOG_MESSAGE
             , DESCRIPTION
             , EVENT_DATE
             , CREATION_DATE
             , CREATED_BY
             , LAST_UPDATE_DATE
             , LAST_UPDATED_BY
             )
        VALUES
             (
               P_PROGRAM_NAME
             , 'ERROR'
             , NULL
             , SUBSTR(P_LOG_MESSAGE, 1, 1000)
             , NULL
             , SYSDATE
             , SYSDATE
             , P_PROGRAM_NAME
             , SYSDATE
             , P_PROGRAM_NAME
             );

        COMMIT;
    END P_LOG_ERROR;

    /* ==============================================================================================
       SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM
       ============================================================================================== */
    PROCEDURE P_SSP0003_GET_CHG_REQ_CONFIRM
    (
        P_DIVISION_ID       IN  VARCHAR2,
        P_FROM_SITE         IN  VARCHAR2,
        P_REQUEST_ID        IN  VARCHAR2,
        P_FROM_YYYYMMDD     IN  VARCHAR2,
        P_TO_YYYYMMDD       IN  VARCHAR2,
        P_STATUS            IN  VARCHAR2,
        P_LANGUAGE          IN  VARCHAR2,
        P_ITEM_ID           IN  VARCHAR2,
        P_CHANGE_TYPE       IN  VARCHAR2,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM
     * Description  : Shipment Change Request Confirm
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2018/04/19   ygkim			Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
     * 2018/06/27   ygkim			Item_id, nick_name 컬럼 추가, @p_item_id 파라미터 추가
     * 2018/07/10   ygkim			Change Type 컬럼 추가
     * 2018/09/03   ygkim			Division 'EE' 추가로 인한 쿼리 수정
     * 2018/10/11   ygkim			Shipment Plan Change 화면에서 승인한 항목은 제외
     * 2019/02/14	hwyoon			[CSR ID:3920817] Shipment change Request Confirm List 에 To site 정보 추가 요청
     * 2019/06/17   mcTheJ			[CSR ID:3994058] [요청]생산관리 출하변경 시 사유 code화 관리 Cnage_Type = 'A' 주석처리
     * 2019/07/15	mcTheJ			[CSR ID:4044806] Model PIC 담당자 위임 기능 추가 - 위임자 결재 추가
     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.06   AJS          조회 속도 개선 : 품목·도착지 최대값 하위질의 펼침 금지(변경요청 상세 72만 행 전체 집계 2회 대신 요청별 조회)
     * 2026.10.07   AJS          조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     * 2026.10.08   AJS          조회조건 Model/Nickname : 'ALL'(대소문자 무시 · 앞뒤 공백 무시) 은 조건 없음
     */
        V_LANGUAGE          VARCHAR2(4000 CHAR) := NVL(P_LANGUAGE, 'KO');       /* AS-IS 기본값 'KO' */
        V_CHANGE_TYPE       VARCHAR2(4000 CHAR) := NVL(P_CHANGE_TYPE, 'C');     /* AS-IS 기본값 'C' */
        V_ERR               VARCHAR2(4000 CHAR);
    BEGIN

        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.FROM_SITE
                 , A.CHANGE_REQ_NO
                 , A.SHIPMENT_STATUS
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.ITEM_ID) AS NICK_NAME
                 , A.REQUEST_TITLE
                 , A.CHANGE_REASON_CODE
                 , A.REQUEST_USER
                 , A.REQUEST_DEPT
                 , A.REQUEST_TIME
                 , A.APPROVAL_USER
                 , A.APPROVAL_DEPT
                 , A.DELEGATEE_USER
                 , A.DELEGATEE_DEPT
                 , A.DELEGATEE_USER AS DELEGATEE_USER_1      /* AS-IS 가 같은 칸을 두 번 내보낸다 */
                 , A.DELEGATEE_DEPT AS DELEGATEE_DEPT_1
                 , A.APPROVAL_TIME
                 , A.REJECT_REASON
                 , A.REQUEST_USER_NAME
                 , A.APPROVAL_USER_NAME
                 , A.DELEGATEE_USER_NAME
                 , A.CHANGE_TYPE
                 , A.TO_SITE
              FROM (SELECT A.DIVISION_ID
                         , A.FROM_SITE
                         , A.CHANGE_REQ_NO
                         , A.CHANGE_REQ_STATUS AS SHIPMENT_STATUS
                         /* 옛 시스템은 대소문자를 무시하고 정렬한다 — 최대값 기준을 같게 맞춘다 */
--                       , (SELECT MAX(ITEM_ID) KEEP (DENSE_RANK LAST ORDER BY NLSSORT(ITEM_ID, 'NLS_SORT=BINARY_CI'))   --  2026.10.06 AJS
                         , (SELECT /*+ NO_UNNEST */ MAX(ITEM_ID) KEEP (DENSE_RANK LAST ORDER BY NLSSORT(ITEM_ID, 'NLS_SORT=BINARY_CI'))   /* 요청별 상세 조회 */   --  2026.10.06 AJS
                              FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                             WHERE DIVISION_ID = A.DIVISION_ID
                               AND CHANGE_REQ_NO = A.CHANGE_REQ_NO) AS ITEM_ID
                         , A.REQUEST_TITLE
                         , A.CHANGE_REASON_CODE
                         , A.REQUEST_USER
                         , A.REQUEST_DEPT
                         , A.REQUEST_TIME
                         , A.APPROVAL_USER
                         , A.APPROVAL_DEPT
                         , CASE WHEN A.DELEGATEE_USER IS NOT NULL THEN
                                     A.DELEGATEE_USER
                                ELSE
                                     CASE WHEN A.CHANGE_REQ_STATUS = 'Q' OR A.CHANGE_REQ_STATUS = 'D' THEN
                                               E.DELEGATEE_ID
                                          ELSE
                                               NULL
                                     END
                           END AS DELEGATEE_USER
                         , CASE WHEN A.DELEGATEE_DEPT IS NOT NULL THEN
                                     A.DELEGATEE_DEPT
                                ELSE
                                     CASE WHEN A.CHANGE_REQ_STATUS = 'Q' OR A.CHANGE_REQ_STATUS = 'D' THEN
                                               F.DEPT_ID
                                          ELSE
                                               NULL
                                     END
                           END AS DELEGATEE_DEPT
                         , A.APPROVAL_TIME
                         , A.REJECT_REASON
                         , A.CHANGE_TYPE
                         /* AS-IS 는 문자 결합이라 이름이 없으면 전체가 빈 값이 된다 — 같은 동작을 위해 NULL 판정 */
                         , CASE WHEN (CASE WHEN V_LANGUAGE = 'KO' THEN B.USER_NM ELSE B.USER_ENG_NM END) IS NULL
                                  OR A.REQUEST_USER IS NULL THEN
                                     NULL
                                ELSE
                                     (CASE WHEN V_LANGUAGE = 'KO' THEN B.USER_NM ELSE B.USER_ENG_NM END) || '(' || A.REQUEST_USER || ')'
                           END AS REQUEST_USER_NAME
                         , CASE WHEN (CASE WHEN V_LANGUAGE = 'KO' THEN C.USER_NM ELSE C.USER_ENG_NM END) IS NULL
                                  OR A.APPROVAL_USER IS NULL THEN
                                     NULL
                                ELSE
                                     (CASE WHEN V_LANGUAGE = 'KO' THEN C.USER_NM ELSE C.USER_ENG_NM END) || '(' || A.APPROVAL_USER || ')'
                           END AS APPROVAL_USER_NAME
                         , CASE WHEN A.DELEGATEE_USER IS NOT NULL THEN
                                     CASE WHEN (CASE WHEN V_LANGUAGE = 'KO' THEN D.USER_NM ELSE D.USER_ENG_NM END) IS NULL THEN
                                               NULL
                                          ELSE
                                               (CASE WHEN V_LANGUAGE = 'KO' THEN D.USER_NM ELSE D.USER_ENG_NM END) || '(' || A.DELEGATEE_USER || ')'
                                     END
                                ELSE
                                     CASE WHEN A.CHANGE_REQ_STATUS = 'Q' OR A.CHANGE_REQ_STATUS = 'D' THEN
                                               CASE WHEN (CASE WHEN V_LANGUAGE = 'KO' THEN F.USER_NM ELSE F.USER_ENG_NM END) IS NULL
                                                      OR E.DELEGATEE_ID IS NULL THEN
                                                         NULL
                                                    ELSE
                                                         (CASE WHEN V_LANGUAGE = 'KO' THEN F.USER_NM ELSE F.USER_ENG_NM END) || '(' || E.DELEGATEE_ID || ')'
                                               END
                                          ELSE
                                               NULL
                                     END
                           END AS DELEGATEE_USER_NAME
                         , A.ORIGIN_FROM_DIVISION_ID
                         /* 옛 시스템은 대소문자를 무시하고 정렬한다 — 최대값 기준을 같게 맞춘다 */
--                       , (SELECT MAX(TO_SITE) KEEP (DENSE_RANK LAST ORDER BY NLSSORT(TO_SITE, 'NLS_SORT=BINARY_CI'))   --  2026.10.06 AJS
                         , (SELECT /*+ NO_UNNEST */ MAX(TO_SITE) KEEP (DENSE_RANK LAST ORDER BY NLSSORT(TO_SITE, 'NLS_SORT=BINARY_CI'))   /* 요청별 상세 조회 */   --  2026.10.06 AJS
                              FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                             WHERE DIVISION_ID = A.DIVISION_ID
                               AND CHANGE_REQ_NO = A.CHANGE_REQ_NO) AS TO_SITE
                      FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ A
                         , SCM_ADM_USER_M B
                         , SCM_ADM_USER_M C
                         , SCM_ADM_USER_M D
                         , SSP_MST_DELEGATE E
                         , SCM_ADM_USER_M F
                     WHERE B.USER_ID(+) = A.REQUEST_USER
                       AND B.USE_YN(+) = 'Y'
                       AND C.USER_ID(+) = A.APPROVAL_USER
                       AND C.USE_YN(+) = 'Y'
                       AND D.USER_ID(+) = A.DELEGATEE_USER
                       AND D.USE_YN(+) = 'Y'
                       AND E.DIVISION_ID(+) = A.DIVISION_ID
                       AND E.USER_ID(+) = A.APPROVAL_USER
                       AND E.VALID_YN(+) = 'Y'
                       AND TO_CHAR(SYSDATE, 'YYYYMMDD') BETWEEN E.FROM_DATE(+) AND E.TO_DATE(+)
                       AND F.USER_ID(+) = E.DELEGATEE_ID
                       AND F.USE_YN(+) = 'Y'
                       AND NOT EXISTS (SELECT 1
                                         FROM SCM_MST_SITE
                                        WHERE SCM_SITE_ID = A.FROM_SITE
                                          AND DIVISION_ID = '40'
                                          AND SITE_TYPE = 'PLANT'
                                          AND OSP_YN = 'Y')
                       AND A.VALID_YN = 'Y'
                       /* AS-IS convert(nvarchar(8), a.request_time, 112) 비교를 범위 조건으로 (칸에 함수를 쓰지 않는다) */
                       AND A.REQUEST_TIME >= TO_DATE(P_FROM_YYYYMMDD, 'YYYYMMDD')
                       AND A.REQUEST_TIME < TO_DATE(P_TO_YYYYMMDD, 'YYYYMMDD') + 1
                       AND (P_DIVISION_ID IS NULL OR P_DIVISION_ID = 'ALL' OR A.DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_DIVISION_ID, ','))))
                       AND (P_FROM_SITE IS NULL OR P_FROM_SITE = 'ALL' OR A.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (P_REQUEST_ID IS NULL OR P_REQUEST_ID  = 'ALL' OR A.REQUEST_USER IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_REQUEST_ID, ','))))
                       AND (P_STATUS IS NULL OR P_STATUS = 'ALL' OR A.CHANGE_REQ_STATUS = P_STATUS)
                       AND (V_CHANGE_TYPE IS NULL OR V_CHANGE_TYPE = 'ALL' OR A.CHANGE_TYPE = V_CHANGE_TYPE)   -- 2026.09.30 AJS
                       /*AND a.change_type != 'A'*/
                   ) A
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--           WHERE (P_ITEM_ID IS NULL OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))))
/*           WHERE (P_ITEM_ID IS NULL */
             WHERE (TRIM(P_ITEM_ID) IS NULL   /* AJS 20261008 Model/Nickname */
                OR  UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname : 조회조건 ALL 은 조건 없음 */
                OR  EXISTS (SELECT 1
                              FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                             WHERE SB.COLUMN_VALUE IS NOT NULL
                               AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(SB.COLUMN_VALUE) || '%'
                                    OR EXISTS (SELECT 1
                                                 FROM SCM_MST_ITEM_SN XG
                                                WHERE XG.ITEM_ID = A.ITEM_ID
                                                  AND UPPER(XG.NICK_NAME) LIKE '%' || UPPER(SB.COLUMN_VALUE) || '%'))))
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
             ORDER BY A.REQUEST_TIME DESC NULLS LAST
                    , A.CHANGE_REQ_NO;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR := SUBSTR(SQLERRM, 1, 4000);

            OPEN O_RC1 FOR
                SELECT NULL AS DIVISION_ID
                     , NULL AS FROM_SITE
                  FROM DUAL
                 WHERE 1 = 0;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1'  AS CODE
                     , V_ERR AS MSG
                  FROM DUAL;
    END P_SSP0003_GET_CHG_REQ_CONFIRM;

    /* ==============================================================================================
       SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING
       ============================================================================================== */
    PROCEDURE P_SSP0003_GET_REQ_DRAFTING
    (
        P_CHANGE_REQUEST_NO IN  VARCHAR2,
        P_LANGUAGE          IN  VARCHAR2,
        O_RC1               OUT SYS_REFCURSOR,
        O_RC2               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING
     * Description  : Shipment Change Request 확정
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/04/19   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
     * 2018/05/30   ygkim			project name 가져오는 부분 수정
     * 2018/09/03   ygkim			Division 'EE' 추가로 인한 쿼리 수정
     * 2018/10/17   ygkim			new_base_confirm_yn
     * 2018/10/25   ygkim			Division 40 일 경우 Project Name -> Project Code로
     * 2019/04/04	ayj			    [PJ20189106] 전지.GSCM 고도화 이행- 소형 컬럼추가
     * 2021/10/18   SHINMYUNGSU	    SSP_ANL_SHIP_CONFIRM의 ERP_ATTR1~3 항목 추가
     * 2024/04/17   hsbang			SSP_ANL_SHIP_CONFIRM_CHG_REQ_de의 STATUS_DETAIL, REJECT_REASON 항목 추가
     * 2024/04/30   hsbang			부분승인에서 REJECT 항목도 조회될 수 있도록 함. - Valid = 'Y'로 변경
     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.20   AJS            확정 원장 외부조인 조건 (+) 누락 정정 (AS-IS LEFT OUTER JOIN)
     */
        V_LANGUAGE          VARCHAR2(4000 CHAR) := NVL(P_LANGUAGE, 'KO');       /* AS-IS 기본값 'KO' */
        V_ERR               VARCHAR2(4000 CHAR);
    BEGIN

        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.ERP_SO_NO
                 , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE FN_GET_PROJECT_NAME(A.DIVISION_ID, A.PROJECT_CODE) END AS PROJECT_NAME
                 /*, d.project_name*/
                 , A.FCST_TYPE
                 , A.ITEM_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                 , A.TO_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.TO_SITE), '-') AS TO_SITE_DESCRIPTION
                 , FN_GET_SITE_CUSTOMER_INFO((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.TO_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                 , FN_GET_SITE_CUSTOMER_INFO((CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END), A.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                 /*, b.incoterms*/
                 , B.SSP_INCOTERMS AS INCOTERMS   /* 20201223 incoterms 변경 작업 modify KIMYONGHO */
                 , B.TRANSPORT_MODE
                 , CASE WHEN A.YYYYMMDD IS NULL THEN NULL ELSE TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS SHIPMENT_DATE
                 , A.QTY AS SHIPMENT_CONFIRM_QTY
                 , A.BOD_ID
                 , A.ROUTE_ID
                 , B.LT_TOTAL AS LT_DAY
                 , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETD
                 , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA
                 , A.NEW_BOD_ID
                 , A.NEW_ROUTE_ID AS NEW_ROUTE
                 , A.NEW_D_COUNTRY
                 , A.NEW_D_PORT_CODE
                 , A.NEW_A_COUNTRY
                 , A.NEW_A_PORT_CODE
                 , A.NEW_TO_COUNTRY
                 , A.NEW_TO_CITY
                 , A.NEW_CUSTOMER_LT AS NEW_LT_DAY
                 , TO_CHAR(TO_DATE(A.NEW_ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETD
                 , TO_CHAR(TO_DATE(A.NEW_ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETA
                 , A.NEW_INCOTERMS
                 , A.NEW_TRANSPORT_MODE
                 , CASE WHEN A.NEW_YYYYMMDD IS NULL THEN NULL ELSE TO_CHAR(TO_DATE(A.NEW_YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS NEW_SHIPMENT_DATE
                 , A.NEW_QTY AS NEW_SHIPMENT_CONFIRM_QTY
                 , A.CONFIRM_ID
                 , A.CHANGE_REQ_NO
                 , A.NEW_YN
--                 , CASE WHEN C.CONFIRM_ID IS NOT NULL THEN 'Y' ELSE 'N' END AS NEW_BASE_CONFIRM_YN    --  2026.10.20 AJS
                 , CASE WHEN IA.CONFIRM_ID IS NOT NULL THEN 'Y' ELSE 'N' END AS NEW_BASE_CONFIRM_YN    --  2026.10.20 AJS
                 , A.REMARKS
                 , A.REMARKS2
                 , A.REMARKS3
                 /**** 20211018   SHINMYUNGSU   항목추가   ******************************************/
                 , NVL(A.ERP_ATTR1, '') AS ERP_ATTR1
                 , NVL(A.ERP_ATTR2, '') AS ERP_ATTR2
                 , NVL(A.ERP_ATTR3, '') AS ERP_ATTR3
                 /**** 20240416   hsbang   항목추가   ******************************************/
                 , NVL(A.ATTRIBUTE2, '') AS STATUS_DETAIL
                 , NVL(A.ATTRIBUTE3, '') AS REJECT_REASON
                 /***********************************************************************************/
              FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE A
                 , SCP_MST_BOD_N_V B
     -- 2026.10.20 AJS 확정 원장 외부조인 (START) : 조건식에는 (+) 를 붙일 수 없어 비교 값을 인라인 뷰에서 만든다
--                 , SSP_ANL_SHIP_CONFIRM C
                 , (SELECT DIVISION_ID
                         , CONFIRM_ID
                         , CASE WHEN SHIPMENT_STATUS != 'P' AND CHANGE_TYPE = 'P' AND ATTRIBUTE1 IS NOT NULL THEN ATTRIBUTE1 ELSE CONFIRM_ID END AS MATCH_CONFIRM_ID
                      FROM SSP_ANL_SHIP_CONFIRM) IA
     -- 2026.10.20 AJS 확정 원장 외부조인 (END)
             WHERE B.DIVISION_ID = (CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END)
               AND B.BOD_ID = A.BOD_ID
     -- 2026.10.20 AJS 확정 원장 외부조인 (START)
--               AND C.DIVISION_ID(+) = A.DIVISION_ID
--               AND (CASE WHEN (C.SHIPMENT_STATUS != 'P' AND C.CHANGE_TYPE = 'P' AND C.ATTRIBUTE1 IS NOT NULL) THEN C.ATTRIBUTE1 ELSE C.CONFIRM_ID END) = A.CONFIRM_ID
               AND IA.DIVISION_ID(+) = A.DIVISION_ID
               AND IA.MATCH_CONFIRM_ID(+) = A.CONFIRM_ID
     -- 2026.10.20 AJS 확정 원장 외부조인 (END)
               AND NOT EXISTS (SELECT 1
                                 FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ
                                WHERE CHANGE_REQ_NO = A.CHANGE_REQ_NO
                                  AND CHANGE_REQ_STATUS = 'Q'
                                  AND A.VALID_YN = 'N')
               AND A.CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
               /*AND A.VALID_YN = 'Y'*/
             ORDER BY NEW_SHIPMENT_DATE;

        OPEN O_RC2 FOR
            SELECT A.CHANGE_REQ_NO
                 , A.CHANGE_REQ_STATUS
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , A.REQUEST_TITLE
                 /*,REQUEST_USER*/
                 , CASE V_LANGUAGE WHEN 'KO' THEN D.USER_NM ELSE D.USER_ENG_NM END AS REQUEST_USER
                 /*,REQUEST_DEPT*/
                 , CASE V_LANGUAGE WHEN 'KO' THEN C.DEPT_NAME_KO
                                   WHEN 'EN' THEN C.DEPT_NAME_EN
                                   WHEN 'CN' THEN C.DEPT_NAME_CN
                                   ELSE C.DEPT_NAME_KO
                   END AS REQUEST_DEPT
                 , A.REQUEST_TIME
                 /*,APPROVAL_USER*/
                 , CASE V_LANGUAGE WHEN 'KO' THEN E.USER_NM ELSE E.USER_ENG_NM END AS APPROVAL_USER
                 /*,APPROVAL_DEPT*/
                 , CASE V_LANGUAGE WHEN 'KO' THEN B.DEPT_NAME_KO
                                   WHEN 'EN' THEN B.DEPT_NAME_EN
                                   WHEN 'CN' THEN B.DEPT_NAME_CN
                                   ELSE B.DEPT_NAME_KO
                   END AS APPROVAL_DEPT_NAME
                 , A.APPROVAL_TIME
                 , CASE WHEN V_LANGUAGE = 'KO' THEN F.SEGMENT2 ELSE F.SEGMENT3 END AS CHANGE_REASON_CODE
                 /*,CHANGE_REASON_CODE*/
                 , A.CHANGE_REASON_DETAIL
                 , A.REJECT_REASON
              FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ A
                 , SCM_MST_SSO_DEPT_INFO B
                 , SCM_MST_SSO_DEPT_INFO C
                 , SCM_ADM_USER_M D
                 , SCM_ADM_USER_M E
                 , SCM_ADM_LOOKUP_MASTER_DETAIL F
             WHERE B.DEPT_ID(+) = A.APPROVAL_DEPT
               AND C.DEPT_ID(+) = A.REQUEST_DEPT
               AND D.USER_ID(+) = A.REQUEST_USER
               AND E.USER_ID(+) = A.APPROVAL_USER
               AND F.SEGMENT1(+) = A.CHANGE_REASON_CODE
               AND F.LOOKUP_TYPE(+) = 'CHANGE_REASON_CODE'
               AND F.VALID_YN(+) = 'Y'
               AND A.CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
               AND A.VALID_YN = 'Y';

        OPEN O_RESULT_CURSOR FOR
            SELECT '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR := SUBSTR(SQLERRM, 1, 4000);

            OPEN O_RC1 FOR
                SELECT NULL AS DIVISION_ID
                  FROM DUAL
                 WHERE 1 = 0;

            OPEN O_RC2 FOR
                SELECT NULL AS CHANGE_REQ_NO
                  FROM DUAL
                 WHERE 1 = 0;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1'  AS CODE
                     , V_ERR AS MSG
                  FROM DUAL;
    END P_SSP0003_GET_REQ_DRAFTING;

    /* ==============================================================================================
       SSP0003_GET_SSP_PLAN_PROCESSING_CHECK
       ============================================================================================== */
    PROCEDURE P_SSP0003_GET_PLAN_PROC_CHECK
    (
        P_DIVISION_ID       IN  VARCHAR2,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0003_GET_SSP_PLAN_PROCESSING_CHECK
     * Description  : Shipment Model PIC UserID Check
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2019/08/01   AYJ            SSP Daily Plan 엔진 완료여부 체크
     * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */
        V_ERR               VARCHAR2(4000 CHAR);
    BEGIN

        OPEN O_RC1 FOR
            SELECT CASE WHEN C.PLAN_STATUS = 0 THEN 'Y' ELSE 'N' END AS PLAN_STATUS   /* Y:수행중 */
                 , NVL(CASE WHEN C.PLAN_STATUS = 0 THEN
                                 CASE WHEN (CASE
                                                 /*WHEN P.DIVISION_ID = '81' THEN 20 - DATEDIFF(MI,D.INPUT_START_DATE, GETDATE())*/
                                                 /*WHEN P.DIVISION_ID = '82' THEN  6 - DATEDIFF(MI,D.INPUT_START_DATE, GETDATE())*/
                                                 /*WHEN P.DIVISION_ID = '40' THEN  5 - DATEDIFF(MI,D.INPUT_START_DATE, GETDATE())*/
                                                 WHEN B.ATTRIBUTE3 = '81' THEN 20 - TRUNC((SYSDATE - C.INPUT_START_DATE) * 1440)
                                                 WHEN B.ATTRIBUTE3 = '82' THEN  6 - TRUNC((SYSDATE - C.INPUT_START_DATE) * 1440)
                                                 WHEN B.ATTRIBUTE3 = '40' THEN  5 - TRUNC((SYSDATE - C.INPUT_START_DATE) * 1440)
                                                 ELSE NULL
                                            END) <= 0 THEN 1
                                      ELSE
                                           CASE
                                                WHEN B.ATTRIBUTE3 = '81' THEN 20 - TRUNC((SYSDATE - C.INPUT_START_DATE) * 1440)
                                                WHEN B.ATTRIBUTE3 = '82' THEN  6 - TRUNC((SYSDATE - C.INPUT_START_DATE) * 1440)
                                                WHEN B.ATTRIBUTE3 = '40' THEN  5 - TRUNC((SYSDATE - C.INPUT_START_DATE) * 1440)
                                                ELSE NULL
                                           END
                                 END
                            ELSE NULL
                       END, 0) AS ESTIMATED_REMAIN_MINUTE
              /*,      P.DIVISION_ID*/
              /*,      P.PLAN_NAME */
              /*,      D.INPUT_START_DATE */
              /*,      D.ANL_END_DATE*/
              FROM SCM_MST_PLAN A
                 , SCM_MST_DIVISION B
                 /* AS-IS 는 바깥 조인 조건에 최대 차수 서브쿼리를 두지만 Oracle 은 그 형태를 허용하지 않아 인라인 뷰로 옮긴다 */
                 , (SELECT IA.DIVISION_ID
                         , IA.PLAN_ID
                         , IA.PLAN_STATUS
                         , IA.INPUT_START_DATE
                      FROM SCM_MST_PLAN_DETAIL IA
                     WHERE IA.PLAN_SEQ = (SELECT MAX(PLAN_SEQ)
                                            FROM SCM_MST_PLAN_DETAIL
                                           WHERE MODELING_ID = IA.MODELING_ID
                                             AND DIVISION_ID = IA.DIVISION_ID
                                             AND PLAN_ID = IA.PLAN_ID
                                             AND PLAN_TYPE = IA.PLAN_TYPE)
                       AND IA.PLAN_TYPE = 'SP'
                       AND IA.PLAN_STATUS <> -1) C
             WHERE B.DIVISION_ID = A.DIVISION_ID
               AND C.DIVISION_ID(+) = A.DIVISION_ID
               AND C.PLAN_ID(+) = A.PLAN_ID
               AND A.PLAN_NAME = (SELECT MAX(PLAN_NAME)
                                    FROM SCM_MST_PLAN
                                   WHERE DIVISION_ID = A.DIVISION_ID
                                     AND PLAN_CYCLE = A.PLAN_CYCLE)
               AND A.PLAN_CYCLE = 'DAILY'
               AND A.DIVISION_ID = P_DIVISION_ID;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR := SUBSTR(SQLERRM, 1, 4000);

            OPEN O_RC1 FOR
                SELECT NULL AS PLAN_STATUS
                  FROM DUAL
                 WHERE 1 = 0;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1'  AS CODE
                     , V_ERR AS MSG
                  FROM DUAL;
    END P_SSP0003_GET_PLAN_PROC_CHECK;

    /* ==============================================================================================
       SSP0003_GET_DELEGATEE_LOAD
       ============================================================================================== */
    PROCEDURE P_SSP0003_GET_DELEGATEE_LOAD
    (
        P_DIVISION_ID       IN  VARCHAR2,
        P_APPLOVAL          IN  VARCHAR2,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0003_SSP0003_GET_DELEGATEE_LOAD
     * Description  : DELEGATEE_LOAD
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2019/07/15   mcTheJ         [CSR ID:4044806] Model PIC 담당자 위임 기능 추가

     ex)
     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */
        V_ERR               VARCHAR2(4000 CHAR);
    BEGIN

        OPEN O_RC1 FOR
            SELECT A.DELEGATEE_ID
                 , B.DEPT_ID
              FROM SSP_MST_DELEGATE A
                 , SCM_ADM_USER_M B
             WHERE B.USER_ID = A.DELEGATEE_ID
               AND A.DIVISION_ID = P_DIVISION_ID
               AND A.USER_ID = P_APPLOVAL
               AND A.VALID_YN = 'Y'
               AND TO_CHAR(SYSDATE, 'YYYYMMDD') BETWEEN A.FROM_DATE AND A.TO_DATE;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR := SUBSTR(SQLERRM, 1, 4000);

            OPEN O_RC1 FOR
                SELECT NULL AS DELEGATEE_ID
                  FROM DUAL
                 WHERE 1 = 0;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1'  AS CODE
                     , V_ERR AS MSG
                  FROM DUAL;
    END P_SSP0003_GET_DELEGATEE_LOAD;

    /* ==============================================================================================
       SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM
       ============================================================================================== */
    PROCEDURE P_SSP0003_SAVE_REQ_CONFIRM
    (
        P_CHANGE_REQUEST_NO IN  VARCHAR2,
        P_CHANGE_STATUS     IN  VARCHAR2,
        P_REJECT_REASON     IN  VARCHAR2,
        P_DIVISION_ID       IN  CLOB,
        P_ITEM_ID           IN  VARCHAR2,
        P_FROM_SITE         IN  VARCHAR2,
        P_YYYYMMDD          IN  VARCHAR2,
        P_CONFIRM_ID        IN  CLOB,
        P_NEW_CONFIRM_ID    IN  CLOB,
        P_NEW_ETD_DATE      IN  CLOB,
        P_NEW_ETA_DATE      IN  CLOB,
        P_NEW_QTY           IN  CLOB,
        P_NEW_SHIP_DATE     IN  CLOB,
        P_NEW_YN            IN  CLOB,
        P_NEW_BOD_ID        IN  CLOB,
        P_NEW_ROUTE_ID      IN  CLOB,
        P_NEW_INCOTERMS     IN  CLOB,
        P_NEW_D_CONTRY      IN  CLOB,
        P_NEW_D_PORT_CODE   IN  CLOB,
        P_NEW_A_COUNTRY     IN  CLOB,
        P_NEW_A_PORT_CODE   IN  CLOB,
        P_NEW_TO_COUNTRY    IN  CLOB,
        P_NEW_TO_CITY       IN  CLOB,
        P_NEW_LT_DAY        IN  CLOB,
        P_NEW_TRANSPORT_MODE IN CLOB,
        P_LAST_UPDATED_BY   IN  VARCHAR2,
        P_TIME_ZONE         IN  VARCHAR2,
        P_CHANGE_TYPE       IN  VARCHAR2,
        P_REMARKS           IN  CLOB,
        P_REMARKS2          IN  CLOB,
        P_REMARKS3          IN  CLOB,
        P_DELEGATEE         IN  VARCHAR2,
        P_DELEGATEE_DEPT    IN  VARCHAR2,
        P_ERP_ATTR1         IN  CLOB,
        P_ERP_ATTR2         IN  CLOB,
        P_ERP_ATTR3         IN  CLOB,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM
     * Description  : Shipment Change Request Confirm Save
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/04/20   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
     * 2018/05/29   ygkim			create date, last update date 시간 변경
     * 2018/06/11   ygkim			PR_SSP_ANL_SHIP_CONFIRM_HIST 저장 로직 수정
     * 2018/06/28   ygkim			SSP_ANL_SHIP_PLAN 테이블 체크 조건 Confirm ID 추가
     *								SSP_ANL_SHIP_PLAN 테이블 PROJECT_CODE, FCST_TYPE 조회조건 제거
     * 2018/07/02   ygkim			SSP_ANL_SHIP_PLAN 저장 로직 수정
     * 2018/07/05   ygkim			SSP_ANL_SHIP_PLAN 체크 조건 변경
     * 2018/07/10   ygkim			SSP_ANL_SHIP_CONFIRM Attribute1 수정 추가
     * 2018/07/20   ygkim			Confirm 일 경우 SSP_ANL_SHIP_PLAN 테이블에 기존 날짜 데이터 지우고 Insert 하는 로직 추가
     * 2018/08/09   ygkim			Plan 일 경우 Confirm 테이블에 넣는 로직 수정
     * 2018/09/03   ygkim			Division 'EE' 추가로 인한 쿼리 수정
     * 2018/10/08   ygkim		    Change Type Plan 일 경우 Status 'C' -> 'P'로 변경으로 인한 수정
     * 2018/10/10   ygkim			SSP_ANL_SHIP_CONFIRM_CHG_REQ_de 가져오는 조건 변경
     * 2018/10/12   ygkim           신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.
     * 2018/10/15   ygkim			Change Type New 로직 추가
     * 2018/10/16   ygkim			승인 일 경우 PR_SSP_ANL_SHIP_UPDATE_BOH_VAL 프로시저 호출 파라미터 yyyymmdd 수정
     * 2019/04/04	ayj			    [PJ20189106] 전지.GSCM 고도화 이행- 소형 컬럼추가
     * 2019/07/15	mcTheJ			[CSR ID:4044806] Model PIC 담당자 위임 기능 추가 - 위임자 결재 추가
     * 2019/10/02	ayj				PLAN TB 미사용으로 인한 주석
     * 2019/10/29	ayj				FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
     * 2021/01/07   KIMYONGHO       [C20201223-000448] MKT FCST - SSP Sync
     * 2021/01/12   KIMYONGHO       [C20201223-000448] MKT FCST - SSP Sync 운영이관 검증 단계에서 처리 지연 현상으로 END LOG 이후 호출로 조정함.
     * 2021/03/05   KIMYONGHO       SCS I/F 추가
     * 2021/04/08   KIMYONGHO       [C20210406-000222] MKT FCST - SSP Sync DIVISION_ID parameter 변경
     * 2021/10/18   SHINMYUNGSU	    ERP_ATTR1~3 파라메터만 추가(기존 로직 변경 없음)
     * 2022/01/25   jilee           SSP_MST_MODEL_USER 등록된 추가 사용자 메일 발송
     * 2024/02/23   jilee           폴란드 WA 법인 변경건 전체 내역 송부
     * 2024/04/22   hsbang          부분승인('P', Partial Approved) 추가 (hsbang, 2024.04.22)
     * 2024/05/22   jilee           ERP Reject 포함한 경우 부분 승인 업데이트
     * 2024/11/05   jilee           신규건 Confirm 삭제 주석 처리
     --SCS I/F
     * 2025/12/11   chkim.68        E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */
        V_DIVISION_ID           VARCHAR2(32767 CHAR);
        V_CONFIRM_ID            VARCHAR2(32767 CHAR);
        V_NEW_CONFIRM_ID        VARCHAR2(32767 CHAR);
        V_NEW_ETD_DATE          VARCHAR2(32767 CHAR);
        V_NEW_ETA_DATE          VARCHAR2(32767 CHAR);
        V_NEW_QTY               VARCHAR2(32767 CHAR);
        V_NEW_SHIP_DATE         VARCHAR2(32767 CHAR);
        V_NEW_YN                VARCHAR2(32767 CHAR);

        V_NEW_BOD_ID            VARCHAR2(32767 CHAR);
        V_NEW_ROUTE_ID          VARCHAR2(32767 CHAR);
        V_NEW_INCOTERMS         VARCHAR2(32767 CHAR);
        V_NEW_D_CONTRY          VARCHAR2(32767 CHAR);
        V_NEW_D_PORT_CODE       VARCHAR2(32767 CHAR);
        V_NEW_A_COUNTRY         VARCHAR2(32767 CHAR);
        V_NEW_A_PORT_CODE       VARCHAR2(32767 CHAR);
        V_NEW_TO_COUNTRY        VARCHAR2(32767 CHAR);
        V_NEW_TO_CITY           VARCHAR2(32767 CHAR);
        V_NEW_LT_DAY            VARCHAR2(32767 CHAR);
        V_NEW_TRANSPORT_MODE    VARCHAR2(32767 CHAR);

        V_PLANNED_QTY           NUMBER(30, 3) := 0;   /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */

        V_CHK                   PLS_INTEGER := 0;
        V_LAST_UPDATE_DATE      DATE := SYSDATE;

        V_REMARKS               VARCHAR2(32767 CHAR);
        V_REMARKS2              VARCHAR2(32767 CHAR);
        V_REMARKS3              VARCHAR2(32767 CHAR);

        V_MODEL_USER_CHK        PLS_INTEGER := 0;

        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        V_N_LOG_COUNT           PLS_INTEGER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        V_EVENT_DATE            DATE;

        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_ERP_ERROR_CHK         PLS_INTEGER := 0;
        V_APPROVED_CHK          PLS_INTEGER := 0;

        /* AS-IS 는 입력 파라미터 자체를 바꾸므로 로컬 변수로 받는다 */
        V_CHANGE_STATUS         VARCHAR2(32767 CHAR) := P_CHANGE_STATUS;
        V_REJECT_REASON         VARCHAR2(32767 CHAR) := P_REJECT_REASON;
        V_CHANGE_TYPE           VARCHAR2(32767 CHAR) := P_CHANGE_TYPE;

        V_T_DIVISION_ID         T_TOKEN_TAB;
        V_T_CONFIRM_ID          T_TOKEN_TAB;
        V_T_NEW_CONFIRM_ID      T_TOKEN_TAB;
        V_T_NEW_ETD_DATE        T_TOKEN_TAB;
        V_T_NEW_ETA_DATE        T_TOKEN_TAB;
        V_T_NEW_QTY             T_TOKEN_TAB;
        V_T_NEW_SHIP_DATE       T_TOKEN_TAB;
        V_T_NEW_YN              T_TOKEN_TAB;
        V_T_NEW_BOD_ID          T_TOKEN_TAB;
        V_T_NEW_ROUTE_ID        T_TOKEN_TAB;
        V_T_NEW_INCOTERMS       T_TOKEN_TAB;
        V_T_NEW_D_CONTRY        T_TOKEN_TAB;
        V_T_NEW_D_PORT_CODE     T_TOKEN_TAB;
        V_T_NEW_A_COUNTRY       T_TOKEN_TAB;
        V_T_NEW_A_PORT_CODE     T_TOKEN_TAB;
        V_T_NEW_TO_COUNTRY      T_TOKEN_TAB;
        V_T_NEW_TO_CITY         T_TOKEN_TAB;
        V_T_NEW_LT_DAY          T_TOKEN_TAB;
        V_T_NEW_TRANSPORT_MODE  T_TOKEN_TAB;
        V_T_REMARKS             T_TOKEN_TAB;
        V_T_REMARKS2            T_TOKEN_TAB;
        V_T_REMARKS3            T_TOKEN_TAB;
        V_F                     T_FOUND_TAB;

        V_ERR_CODE              VARCHAR2(40 CHAR);
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0003_SAVE;

        /* 시작 LOG */
        V_LOG_TYPE := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE := V_LAST_UPDATE_DATE;   /*[dbo].[FN_MULTY_TIME](@p_time_zone);*/
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        /* ERP Reject 포함한 경우 부분 승인 업데이트 ------------------------------------------------------- */
        SELECT COUNT(*)
          INTO V_ERP_ERROR_CHK
          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
           AND ATTRIBUTE2 = 'E';

        SELECT COUNT(*)
          INTO V_APPROVED_CHK
          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
           AND ATTRIBUTE2 = 'A';

        IF V_ERP_ERROR_CHK > 0 AND V_APPROVED_CHK > 0 THEN
            V_CHANGE_STATUS := 'P';

            BEGIN
                SELECT ATTRIBUTE3
                  INTO V_REJECT_REASON
                  FROM (SELECT ATTRIBUTE3
                          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
                           AND ATTRIBUTE2 = 'E')
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_REJECT_REASON := NULL;
            END;
        ELSIF V_APPROVED_CHK = 0 THEN
            V_CHANGE_STATUS := 'R';

            BEGIN
                SELECT ATTRIBUTE3
                  INTO V_REJECT_REASON
                  FROM (SELECT ATTRIBUTE3
                          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO)
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_REJECT_REASON := NULL;
            END;
        END IF;
        /* ----------------------------------------------------------------------------------------------- */

        /* AS-IS LEN(ISNULL(@p_delegatee,'')) = 0 : 값이 없거나 공백뿐이면 위임자 칸을 건드리지 않는다 */
        IF LENGTH(RTRIM(P_DELEGATEE)) IS NULL THEN
            UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
               SET CHANGE_REQ_STATUS = V_CHANGE_STATUS
                 , APPROVAL_TIME = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                 , REJECT_REASON = (CASE WHEN V_CHANGE_STATUS IN ('R', 'S', 'P') THEN V_REJECT_REASON END)   /*Reject(R), Self Reject(S)*/
                 , LAST_UPDATED_BY = P_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
             WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;
        ELSE
            UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
               SET CHANGE_REQ_STATUS = V_CHANGE_STATUS
                 , APPROVAL_TIME = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                 , REJECT_REASON = (CASE WHEN V_CHANGE_STATUS IN ('R', 'S', 'P') THEN V_REJECT_REASON END)   /*Reject(R), Self Reject(S)*/
                 , DELEGATEE_USER = P_DELEGATEE
                 , DELEGATEE_DEPT = P_DELEGATEE_DEPT
                 , LAST_UPDATED_BY = P_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
             WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;
        END IF;

        IF V_CHANGE_STATUS IN ('A', 'P') THEN   /*Approved, Partial Approved(hsbang20, 2024.04.22)*/
            V_MAX_LOOP_CNT := F_SPL_CNT(P_CONFIRM_ID);

            /* 구분 문자열을 한 번에 분리해 둔다 (AS-IS 는 값마다 처음부터 다시 훑는다) */
            P_SPL_ARR(P_DIVISION_ID,        V_MAX_LOOP_CNT, V_T_DIVISION_ID,       V_F);
            P_SPL_ARR(P_CONFIRM_ID,         V_MAX_LOOP_CNT, V_T_CONFIRM_ID,        V_F);
            P_SPL_ARR(P_NEW_CONFIRM_ID,     V_MAX_LOOP_CNT, V_T_NEW_CONFIRM_ID,    V_F);
            P_SPL_ARR(P_NEW_ETD_DATE,       V_MAX_LOOP_CNT, V_T_NEW_ETD_DATE,      V_F);
            P_SPL_ARR(P_NEW_ETA_DATE,       V_MAX_LOOP_CNT, V_T_NEW_ETA_DATE,      V_F);
            P_SPL_ARR(P_NEW_QTY,            V_MAX_LOOP_CNT, V_T_NEW_QTY,           V_F);
            P_SPL_ARR(P_NEW_SHIP_DATE,      V_MAX_LOOP_CNT, V_T_NEW_SHIP_DATE,     V_F);
            P_SPL_ARR(P_NEW_YN,             V_MAX_LOOP_CNT, V_T_NEW_YN,            V_F);
            P_SPL_ARR(P_NEW_BOD_ID,         V_MAX_LOOP_CNT, V_T_NEW_BOD_ID,        V_F);
            P_SPL_ARR(P_NEW_ROUTE_ID,       V_MAX_LOOP_CNT, V_T_NEW_ROUTE_ID,      V_F);
            P_SPL_ARR(P_NEW_INCOTERMS,      V_MAX_LOOP_CNT, V_T_NEW_INCOTERMS,     V_F);
            P_SPL_ARR(P_NEW_D_CONTRY,       V_MAX_LOOP_CNT, V_T_NEW_D_CONTRY,      V_F);
            P_SPL_ARR(P_NEW_D_PORT_CODE,    V_MAX_LOOP_CNT, V_T_NEW_D_PORT_CODE,   V_F);
            P_SPL_ARR(P_NEW_A_COUNTRY,      V_MAX_LOOP_CNT, V_T_NEW_A_COUNTRY,     V_F);
            P_SPL_ARR(P_NEW_A_PORT_CODE,    V_MAX_LOOP_CNT, V_T_NEW_A_PORT_CODE,   V_F);
            P_SPL_ARR(P_NEW_TO_COUNTRY,     V_MAX_LOOP_CNT, V_T_NEW_TO_COUNTRY,    V_F);
            P_SPL_ARR(P_NEW_TO_CITY,        V_MAX_LOOP_CNT, V_T_NEW_TO_CITY,       V_F);
            P_SPL_ARR(P_NEW_LT_DAY,         V_MAX_LOOP_CNT, V_T_NEW_LT_DAY,        V_F);
            P_SPL_ARR(P_NEW_TRANSPORT_MODE, V_MAX_LOOP_CNT, V_T_NEW_TRANSPORT_MODE, V_F);
            P_SPL_ARR(P_REMARKS,            V_MAX_LOOP_CNT, V_T_REMARKS,           V_F);
            P_SPL_ARR(P_REMARKS2,           V_MAX_LOOP_CNT, V_T_REMARKS2,          V_F);
            P_SPL_ARR(P_REMARKS3,           V_MAX_LOOP_CNT, V_T_REMARKS3,          V_F);

            /*	WHILE LEN(@p_active_flag) > 0 */
            WHILE LENGTH(RTRIM(P_CONFIRM_ID)) IS NOT NULL
              AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                V_DIVISION_ID        := V_T_DIVISION_ID(V_MST_LOOP_CNT);
                V_CONFIRM_ID         := V_T_CONFIRM_ID(V_MST_LOOP_CNT);
                V_NEW_CONFIRM_ID     := V_T_NEW_CONFIRM_ID(V_MST_LOOP_CNT);
                V_NEW_ETD_DATE       := V_T_NEW_ETD_DATE(V_MST_LOOP_CNT);
                V_NEW_ETA_DATE       := V_T_NEW_ETA_DATE(V_MST_LOOP_CNT);
                V_NEW_QTY            := V_T_NEW_QTY(V_MST_LOOP_CNT);
                V_NEW_SHIP_DATE      := V_T_NEW_SHIP_DATE(V_MST_LOOP_CNT);
                V_NEW_YN             := V_T_NEW_YN(V_MST_LOOP_CNT);

                V_NEW_BOD_ID         := V_T_NEW_BOD_ID(V_MST_LOOP_CNT);
                V_NEW_ROUTE_ID       := V_T_NEW_ROUTE_ID(V_MST_LOOP_CNT);
                V_NEW_INCOTERMS      := V_T_NEW_INCOTERMS(V_MST_LOOP_CNT);
                V_NEW_D_CONTRY       := V_T_NEW_D_CONTRY(V_MST_LOOP_CNT);
                V_NEW_D_PORT_CODE    := V_T_NEW_D_PORT_CODE(V_MST_LOOP_CNT);
                V_NEW_A_COUNTRY      := V_T_NEW_A_COUNTRY(V_MST_LOOP_CNT);
                V_NEW_A_PORT_CODE    := V_T_NEW_A_PORT_CODE(V_MST_LOOP_CNT);
                V_NEW_TO_COUNTRY     := V_T_NEW_TO_COUNTRY(V_MST_LOOP_CNT);
                V_NEW_TO_CITY        := V_T_NEW_TO_CITY(V_MST_LOOP_CNT);
                V_NEW_LT_DAY         := V_T_NEW_LT_DAY(V_MST_LOOP_CNT);
                V_NEW_TRANSPORT_MODE := V_T_NEW_TRANSPORT_MODE(V_MST_LOOP_CNT);

                V_REMARKS            := V_T_REMARKS(V_MST_LOOP_CNT);
                V_REMARKS2           := V_T_REMARKS2(V_MST_LOOP_CNT);
                V_REMARKS3           := V_T_REMARKS3(V_MST_LOOP_CNT);

                IF V_MST_LOOP_CNT > 0 THEN
                    V_NEW_ETD_DATE := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                    /*SET @v_new_eta_date = REPLACE(SUBSTRING(@v_new_eta_date,1,10),'-','')*/
                    V_NEW_SHIP_DATE := REPLACE(SUBSTR(V_NEW_SHIP_DATE, 1, 10), '-', '');

                    /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
                    /*2021.04.08 [C20210406-000222]  @P_division_id - > @v_division_id*/
                    V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(V_DIVISION_ID, V_NEW_BOD_ID, V_NEW_SHIP_DATE);

                    V_CHK := 0;

                    IF V_NEW_YN = 'Y' THEN
                        /* SSP0200 에서 사용 시  @p_change_type = 'N' 변경 */
                        V_CHANGE_TYPE := 'N';

                        IF V_CHANGE_TYPE = 'C' THEN
                            /*SSP_ANL_SHIP_CONFIRM table insert*/
                            INSERT INTO SSP_ANL_SHIP_CONFIRM
                                 (
                                   CONFIRM_ID
                                 , SHIPMENT_STATUS
                                 , DIVISION_ID
                                 , PLAN_START_YYYYMMDD
                                 , PLAN_TYPE
                                 , SEQ
                                 , ITEM_ID
                                 , FROM_SITE
                                 , TO_SITE
                                 , YYYYMMDD
                                 , PLANNED_QTY
                                 , QTY
                                 , BOD_ID
                                 , ROUTE_ID
                                 , BIZ_TYPE
                                 , PROJECT_CODE
                                 , FCST_TYPE
                                 , FCST_ETD_DATE
                                 , FCST_ETA_DATE
                                 , ETD_DATE
                                 , ETA_DATE
                                 , INCOTERMS
                                 , TRANSPORT_MODE
                                 , D_COUNTRY
                                 , D_PORT_CODE
                                 , A_COUNTRY
                                 , A_PORT_CODE
                                 , CUSTOMER_LT
                                 , TO_COUNTRY
                                 , TO_CITY
                                 , FROM_SITE_TYPE
                                 , FROM_SITE_PLANT_ID
                                 , FROM_SITE_VENDOR_ID
                                 , FROM_SITE_SOLDTO_CODE
                                 , FROM_SITE_SHIPTO_CODE
                                 , FROM_SITE_COMPANY_ID
                                 , TO_SITE_TYPE
                                 , TO_SITE_PLANT_ID
                                 , TO_SITE_VENDOR_ID
                                 , TO_SITE_SOLDTO_CODE
                                 , TO_SITE_SHIPTO_CODE
                                 , TO_SITE_COMPANY_ID
                                 , CHANGE_REQ_NO
                                 , ERP_SO_NO   /*신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.*/
                                 , ERP_SO_ITEM_NO
                                 , ERP_DO_NO
                                 , ERP_STATUS
                                 , CHANGE_TYPE
                                 , CREATED_BY
                                 , CREATION_DATE
                                 , LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE
                                 , ELECTRODE_YN
                                 , ELECTRODE_TYPE
                                 , ORIGIN_FROM_DIVISION_ID
                                 , ORIGIN_TO_DIVISION_ID
                                 , BEFORE_QTY
                                 , CHECK_NEED_YN
                                 , REMARKS
                                 , REMARKS2
                                 , REMARKS3
                                 /*----------------------------------------------------------------------------------------
                                     2020.06.30 : KBK
                                     I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                                 ------------------------------------------------------------------------------------------*/
                                 , PACKAGE_TYPE_CODE
                                 , FACTORY_ID
                                 , PACKAGE_QTY
                                 , DOM_EXP
                                 , ERP_ATTR1
                                 , ERP_ATTR2
                                 , ERP_ATTR3
                                 , ERP_ATTR4
                                 , ERP_ATTR5
                                 )
                            SELECT V_NEW_CONFIRM_ID AS CONFIRM_ID
                                 , 'C' AS SHIPMENT_STATUS
                                 , A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.ITEM_ID
                                 , A.FROM_SITE
                                 , A.TO_SITE
                                 , V_NEW_SHIP_DATE AS YYYYMMDD
                                 , 0 AS PLANNED_QTY
                                 , TO_NUMBER(V_NEW_QTY) AS QTY
                                 , V_NEW_BOD_ID AS BOD_ID
                                 , TO_NUMBER(V_NEW_ROUTE_ID) AS ROUTE_ID
                                 , A.BIZ_TYPE
                                 , A.PROJECT_CODE
                                 , A.FCST_TYPE
                                 , A.FCST_ETD_DATE
                                 , A.FCST_ETA_DATE
                                 , V_NEW_ETD_DATE AS ETD_DATE
                                 , V_NEW_ETA_DATE AS ETA_DATE
                                 , V_NEW_INCOTERMS AS INCOTERMS
                                 , V_NEW_TRANSPORT_MODE AS TRANSPORT_MODE
                                 , V_NEW_D_CONTRY AS D_COUNTRY
                                 , V_NEW_D_PORT_CODE AS D_PORT_CODE
                                 , V_NEW_A_COUNTRY AS A_COUNTRY
                                 , V_NEW_A_PORT_CODE AS A_PORT_CODE
                                 , TO_NUMBER(V_NEW_LT_DAY) AS CUSTOMER_LT
                                 , V_NEW_TO_COUNTRY AS TO_COUNTRY
                                 , V_NEW_TO_CITY AS TO_CITY
                                 , A.FROM_SITE_TYPE
                                 , A.FROM_SITE_PLANT_ID
                                 , A.FROM_SITE_VENDOR_ID
                                 , A.FROM_SITE_SOLDTO_CODE
                                 , A.FROM_SITE_SHIPTO_CODE
                                 , A.FROM_SITE_COMPANY_ID
                                 , A.TO_SITE_TYPE
                                 , A.TO_SITE_PLANT_ID
                                 , A.TO_SITE_VENDOR_ID
                                 , A.TO_SITE_SOLDTO_CODE
                                 , A.TO_SITE_SHIPTO_CODE
                                 , A.TO_SITE_COMPANY_ID
                                 , NULL AS CHANGE_REQ_NO
                                 , NULL AS ERP_SO_NO   /*신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.*/
                                 , NULL AS ERP_SO_ITEM_NO
                                 , NULL AS ERP_DO_NO
                                 , NULL AS ERP_STATUS
                                 , 'C'
                                 , P_LAST_UPDATED_BY AS CREATED_BY
                                 , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE*/
                                 , P_LAST_UPDATED_BY AS LAST_UPDATED_BY
                                 , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE*/
                                 , A.ELECTRODE_YN
                                 , A.ELECTRODE_TYPE
                                 , A.ORIGIN_FROM_DIVISION_ID
                                 , A.ORIGIN_TO_DIVISION_ID
                                 , 0 AS BEFORE_QTY
                                 , 'Y' AS CHECK_NEED_YN
                                 , V_REMARKS
                                 , V_REMARKS2
                                 , V_REMARKS3
                                 /*----------------------------------------------------------------------------------------
                                     2020.06.30 : KBK
                                     I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                                 ------------------------------------------------------------------------------------------*/
                                 , A.PACKAGE_TYPE_CODE
                                 , A.FACTORY_ID
                                 , CASE WHEN A.ELECTRODE_YN = 'N' THEN TO_NUMBER(V_NEW_QTY)
                                        ELSE CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                                       WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                                       WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                                       ELSE NULL
                                                  END)
                                   END AS PACKAGE_QTY
                                 , A.DOM_EXP
                                 , A.ERP_ATTR1
                                 , A.ERP_ATTR2
                                 , A.ERP_ATTR3
                                 , A.ERP_ATTR4
                                 , A.ERP_ATTR5
                              FROM SSP_ANL_SHIP_CONFIRM A
                                 , SSP_MST_SITE_ITEM_EE_V B
                             WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                               AND B.SCM_SITE_ID(+) = A.FROM_SITE
                               AND B.ITEM_ID(+) = A.ITEM_ID
                               AND A.CONFIRM_ID = V_CONFIRM_ID;
                        ELSIF V_CHANGE_TYPE = 'N' THEN
                            V_CHK := 0;

                            SELECT COUNT(*)
                              INTO V_CHK
                              FROM SSP_ANL_SHIP_CONFIRM
                             WHERE CONFIRM_ID = V_NEW_CONFIRM_ID;

                            IF V_CHK > 0 THEN
                                /* AS-IS 는 UPDATE ... FROM 조인 (Oracle 은 ORA-01779) — 포장 수량만 상관 서브쿼리로 옮긴다
                                   조인 키(DIVISION_ID · SCM_SITE_ID · ITEM_ID)는 대상 뷰에서 유일해 행이 늘지 않는다 */
                                UPDATE SSP_ANL_SHIP_CONFIRM A
                                   SET A.CHANGE_TYPE = 'C'
                                     , A.SHIPMENT_STATUS = 'C'
                                     , A.CHANGE_REQ_NO = NULL
                                     , A.YYYYMMDD = V_NEW_SHIP_DATE
                                     , A.QTY = TO_NUMBER(V_NEW_QTY)
                                     , A.BOD_ID = V_NEW_BOD_ID
                                     , A.ROUTE_ID = TO_NUMBER(V_NEW_ROUTE_ID)
                                     , A.INCOTERMS = V_NEW_INCOTERMS
                                     , A.D_COUNTRY = V_NEW_D_CONTRY
                                     , A.D_PORT_CODE = V_NEW_D_PORT_CODE
                                     , A.A_COUNTRY = V_NEW_A_COUNTRY
                                     , A.A_PORT_CODE = V_NEW_A_PORT_CODE
                                     , A.TO_COUNTRY = V_NEW_TO_COUNTRY
                                     , A.TO_CITY = V_NEW_TO_CITY
                                     , A.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                                     , A.ETD_DATE = V_NEW_ETD_DATE
                                     , A.ETA_DATE = V_NEW_ETA_DATE
                                     , A.CUSTOMER_LT = TO_NUMBER(V_NEW_LT_DAY)
                                     , A.BEFORE_QTY = 0
                                     , A.CHECK_NEED_YN = 'Y'
                                     , A.LAST_UPDATED_BY = P_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                                     , A.REMARKS = V_REMARKS
                                     , A.REMARKS2 = V_REMARKS2
                                     , A.REMARKS3 = V_REMARKS3
                                     /*----------------------------------------------------------------------------------------
                                         2020.06.30 : KBK
                                         I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                                     ------------------------------------------------------------------------------------------*/
                                     , A.PACKAGE_QTY = CASE WHEN A.ELECTRODE_YN = 'N' THEN TO_NUMBER(V_NEW_QTY)
                                                            ELSE (SELECT CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                                                                   WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                                                                   WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                                                                   ELSE NULL
                                                                              END)
                                                                    FROM SSP_MST_SITE_ITEM_EE_V B
                                                                   WHERE B.DIVISION_ID = A.DIVISION_ID
                                                                     AND B.SCM_SITE_ID = A.FROM_SITE
                                                                     AND B.ITEM_ID = A.ITEM_ID)
                                                       END
                                 WHERE A.CONFIRM_ID = V_NEW_CONFIRM_ID;
                            ELSE
                                INSERT INTO SSP_ANL_SHIP_CONFIRM
                                     (
                                       CONFIRM_ID
                                     , SHIPMENT_STATUS
                                     , DIVISION_ID
                                     , PLAN_START_YYYYMMDD
                                     , PLAN_TYPE
                                     , SEQ
                                     , ITEM_ID
                                     , FROM_SITE
                                     , TO_SITE
                                     , YYYYMMDD
                                     , PLANNED_QTY
                                     , QTY
                                     , BOD_ID
                                     , ROUTE_ID
                                     , BIZ_TYPE
                                     , PROJECT_CODE
                                     , FCST_TYPE
                                     , FCST_ETD_DATE
                                     , FCST_ETA_DATE
                                     , ETD_DATE
                                     , ETA_DATE
                                     , INCOTERMS
                                     , TRANSPORT_MODE
                                     , D_COUNTRY
                                     , D_PORT_CODE
                                     , A_COUNTRY
                                     , A_PORT_CODE
                                     , CUSTOMER_LT
                                     , TO_COUNTRY
                                     , TO_CITY
                                     , FROM_SITE_TYPE
                                     , FROM_SITE_PLANT_ID
                                     , FROM_SITE_VENDOR_ID
                                     , FROM_SITE_SOLDTO_CODE
                                     , FROM_SITE_SHIPTO_CODE
                                     , FROM_SITE_COMPANY_ID
                                     , TO_SITE_TYPE
                                     , TO_SITE_PLANT_ID
                                     , TO_SITE_VENDOR_ID
                                     , TO_SITE_SOLDTO_CODE
                                     , TO_SITE_SHIPTO_CODE
                                     , TO_SITE_COMPANY_ID
                                     , CHANGE_REQ_NO
                                     , ERP_SO_NO   /*신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.*/
                                     , ERP_SO_ITEM_NO
                                     , ERP_DO_NO
                                     , ERP_STATUS
                                     , CHANGE_TYPE
                                     , CREATED_BY
                                     , CREATION_DATE
                                     , LAST_UPDATED_BY
                                     , LAST_UPDATE_DATE
                                     , ELECTRODE_YN
                                     , ELECTRODE_TYPE
                                     , ORIGIN_FROM_DIVISION_ID
                                     , ORIGIN_TO_DIVISION_ID
                                     , BEFORE_QTY
                                     , CHECK_NEED_YN
                                     , REMARKS
                                     , REMARKS2
                                     , REMARKS3
                                     /*----------------------------------------------------------------------------------------
                                         2020.06.30 : KBK
                                         I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                                     ------------------------------------------------------------------------------------------*/
                                     , PACKAGE_TYPE_CODE
                                     , FACTORY_ID
                                     , PACKAGE_QTY
                                     , DOM_EXP
                                     , ERP_ATTR1
                                     , ERP_ATTR2
                                     , ERP_ATTR3
                                     , ERP_ATTR4
                                     , ERP_ATTR5
                                     )
                                SELECT V_NEW_CONFIRM_ID AS CONFIRM_ID
                                     , 'C' AS SHIPMENT_STATUS
                                     , A.DIVISION_ID
                                     , A.PLAN_START_YYYYMMDD
                                     , A.PLAN_TYPE
                                     , A.SEQ
                                     , A.ITEM_ID
                                     , A.FROM_SITE
                                     , A.TO_SITE
                                     , V_NEW_SHIP_DATE AS YYYYMMDD
                                     , 0 AS PLANNED_QTY
                                     , TO_NUMBER(V_NEW_QTY) AS QTY
                                     , V_NEW_BOD_ID AS BOD_ID
                                     , TO_NUMBER(V_NEW_ROUTE_ID) AS ROUTE_ID
                                     , A.BIZ_TYPE
                                     , A.PROJECT_CODE
                                     , A.FCST_TYPE
                                     , A.FCST_ETD_DATE
                                     , A.FCST_ETA_DATE
                                     , V_NEW_ETD_DATE AS ETD_DATE
                                     , V_NEW_ETA_DATE AS ETA_DATE
                                     , V_NEW_INCOTERMS AS INCOTERMS
                                     , V_NEW_TRANSPORT_MODE AS TRANSPORT_MODE
                                     , V_NEW_D_CONTRY AS D_COUNTRY
                                     , V_NEW_D_PORT_CODE AS D_PORT_CODE
                                     , V_NEW_A_COUNTRY AS A_COUNTRY
                                     , V_NEW_A_PORT_CODE AS A_PORT_CODE
                                     , TO_NUMBER(V_NEW_LT_DAY) AS CUSTOMER_LT
                                     , V_NEW_TO_COUNTRY AS TO_COUNTRY
                                     , V_NEW_TO_CITY AS TO_CITY
                                     , A.FROM_SITE_TYPE
                                     , A.FROM_SITE_PLANT_ID
                                     , A.FROM_SITE_VENDOR_ID
                                     , A.FROM_SITE_SOLDTO_CODE
                                     , A.FROM_SITE_SHIPTO_CODE
                                     , A.FROM_SITE_COMPANY_ID
                                     , A.TO_SITE_TYPE
                                     , A.TO_SITE_PLANT_ID
                                     , A.TO_SITE_VENDOR_ID
                                     , A.TO_SITE_SOLDTO_CODE
                                     , A.TO_SITE_SHIPTO_CODE
                                     , A.TO_SITE_COMPANY_ID
                                     , NULL AS CHANGE_REQ_NO
                                     , NULL AS ERP_SO_NO   /*신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.*/
                                     , NULL AS ERP_SO_ITEM_NO
                                     , NULL AS ERP_DO_NO
                                     , NULL AS ERP_STATUS
                                     , 'C'
                                     , P_LAST_UPDATED_BY AS CREATED_BY
                                     , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE*/
                                     , P_LAST_UPDATED_BY AS LAST_UPDATED_BY
                                     , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE*/
                                     , A.ELECTRODE_YN
                                     , A.ELECTRODE_TYPE
                                     , A.ORIGIN_FROM_DIVISION_ID
                                     , A.ORIGIN_TO_DIVISION_ID
                                     , 0 AS BEFORE_QTY
                                     , 'Y' AS CHECK_NEED_YN
                                     , V_REMARKS
                                     , V_REMARKS2
                                     , V_REMARKS3
                                     /*----------------------------------------------------------------------------------------
                                         2020.06.30 : KBK
                                         I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                                     ------------------------------------------------------------------------------------------*/
                                     , A.PACKAGE_TYPE_CODE
                                     , A.FACTORY_ID
                                     , CASE WHEN A.ELECTRODE_YN = 'N' THEN TO_NUMBER(V_NEW_QTY)
                                            ELSE CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                                           WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                                           WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                                           ELSE NULL
                                                      END)
                                       END AS PACKAGE_QTY
                                     , A.DOM_EXP
                                     , A.ERP_ATTR1
                                     , A.ERP_ATTR2
                                     , A.ERP_ATTR3
                                     , A.ERP_ATTR4
                                     , A.ERP_ATTR5
                                  FROM SSP_ANL_SHIP_CONFIRM A
                                     , SSP_MST_SITE_ITEM_EE_V B
                                 WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                                   AND B.SCM_SITE_ID(+) = A.FROM_SITE
                                   AND B.ITEM_ID(+) = A.ITEM_ID
                                   AND A.CONFIRM_ID = V_CONFIRM_ID;
                            END IF;

                            /* SSP0200 에서 사용 시  @p_change_type = 'N' 변경 후 다시 'C' 변경 */
                            /* 2026.10.06 AJS AS-IS 대소문자 무시 비교 반영 - 'c' -> 'C' (START) */
--                          V_CHANGE_TYPE := 'c';
                            V_CHANGE_TYPE := 'C';
                            /* 2026.10.06 AJS AS-IS 대소문자 무시 비교 반영 - 'c' -> 'C' (END) */
                        ELSE
                            /* AS-IS 는 바로 위에서 @p_change_type 을 'N' 으로 바꾸므로 이 갈래에는 닿지 않는다 (원문 구조 보존) */
                            V_PLANNED_QTY := 0;

                            BEGIN
                                SELECT PLANNED_QTY
                                  INTO V_PLANNED_QTY
                                  FROM SSP_ANL_SHIP_CONFIRM
                                 WHERE ATTRIBUTE1 = V_NEW_CONFIRM_ID
                                   AND ROWNUM = 1;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    NULL;
                            END;

                            /*SSP_ANL_SHIP_CONFIRM table insert*/
                            INSERT INTO SSP_ANL_SHIP_CONFIRM
                                 (
                                   CONFIRM_ID
                                 , SHIPMENT_STATUS
                                 , DIVISION_ID
                                 , PLAN_START_YYYYMMDD
                                 , PLAN_TYPE
                                 , SEQ
                                 , ITEM_ID
                                 , FROM_SITE
                                 , TO_SITE
                                 , YYYYMMDD
                                 , PLANNED_QTY
                                 , QTY
                                 , BOD_ID
                                 , ROUTE_ID
                                 , BIZ_TYPE
                                 , PROJECT_CODE
                                 , FCST_TYPE
                                 , FCST_ETD_DATE
                                 , FCST_ETA_DATE
                                 , ETD_DATE
                                 , ETA_DATE
                                 , INCOTERMS
                                 , TRANSPORT_MODE
                                 , D_COUNTRY
                                 , D_PORT_CODE
                                 , A_COUNTRY
                                 , A_PORT_CODE
                                 , CUSTOMER_LT
                                 , TO_COUNTRY
                                 , TO_CITY
                                 , FROM_SITE_TYPE
                                 , FROM_SITE_PLANT_ID
                                 , FROM_SITE_VENDOR_ID
                                 , FROM_SITE_SOLDTO_CODE
                                 , FROM_SITE_SHIPTO_CODE
                                 , FROM_SITE_COMPANY_ID
                                 , TO_SITE_TYPE
                                 , TO_SITE_PLANT_ID
                                 , TO_SITE_VENDOR_ID
                                 , TO_SITE_SOLDTO_CODE
                                 , TO_SITE_SHIPTO_CODE
                                 , TO_SITE_COMPANY_ID
                                 , CHANGE_REQ_NO
                                 , ERP_SO_NO
                                 , ERP_SO_ITEM_NO
                                 , ERP_DO_NO
                                 , ERP_STATUS
                                 , CHANGE_TYPE
                                 , CREATED_BY
                                 , CREATION_DATE
                                 , LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE
                                 , ELECTRODE_YN
                                 , ELECTRODE_TYPE
                                 , ORIGIN_FROM_DIVISION_ID
                                 , ORIGIN_TO_DIVISION_ID
                                 , BEFORE_QTY
                                 , CHECK_NEED_YN
                                 , REMARKS
                                 , REMARKS2
                                 , REMARKS3
                                 /*----------------------------------------------------------------------------------------
                                     2020.06.30 : KBK
                                     I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                                 ------------------------------------------------------------------------------------------*/
                                 , PACKAGE_TYPE_CODE
                                 , FACTORY_ID
                                 , PACKAGE_QTY
                                 , DOM_EXP
                                 , ERP_ATTR1
                                 , ERP_ATTR2
                                 , ERP_ATTR3
                                 , ERP_ATTR4
                                 , ERP_ATTR5
                                 )
                            SELECT V_NEW_CONFIRM_ID AS CONFIRM_ID
                                 , 'C' AS SHIPMENT_STATUS
                                 , A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.ITEM_ID
                                 , A.FROM_SITE
                                 , A.TO_SITE
                                 , V_NEW_SHIP_DATE AS YYYYMMDD
                                 , V_PLANNED_QTY AS PLANNED_QTY
                                 , TO_NUMBER(V_NEW_QTY) AS QTY
                                 , V_NEW_BOD_ID AS BOD_ID
                                 , TO_NUMBER(V_NEW_ROUTE_ID) AS ROUTE_ID
                                 , A.BIZ_TYPE
                                 , A.PROJECT_CODE
                                 , A.FCST_TYPE
                                 , A.FCST_ETD_DATE
                                 , A.FCST_ETA_DATE
                                 , V_NEW_ETD_DATE AS ETD_DATE
                                 , V_NEW_ETA_DATE AS ETA_DATE
                                 , V_NEW_INCOTERMS AS INCOTERMS
                                 , V_NEW_TRANSPORT_MODE AS TRANSPORT_MODE
                                 , V_NEW_D_CONTRY AS D_COUNTRY
                                 , V_NEW_D_PORT_CODE AS D_PORT_CODE
                                 , V_NEW_A_COUNTRY AS A_COUNTRY
                                 , V_NEW_A_PORT_CODE AS A_PORT_CODE
                                 , TO_NUMBER(V_NEW_LT_DAY) AS CUSTOMER_LT
                                 , V_NEW_TO_COUNTRY AS TO_COUNTRY
                                 , V_NEW_TO_CITY AS TO_CITY
                                 , A.FROM_SITE_TYPE
                                 , A.FROM_SITE_PLANT_ID
                                 , A.FROM_SITE_VENDOR_ID
                                 , A.FROM_SITE_SOLDTO_CODE
                                 , A.FROM_SITE_SHIPTO_CODE
                                 , A.FROM_SITE_COMPANY_ID
                                 , A.TO_SITE_TYPE
                                 , A.TO_SITE_PLANT_ID
                                 , A.TO_SITE_VENDOR_ID
                                 , A.TO_SITE_SOLDTO_CODE
                                 , A.TO_SITE_SHIPTO_CODE
                                 , A.TO_SITE_COMPANY_ID
                                 , NULL AS CHANGE_REQ_NO
                                 , NULL AS ERP_SO_NO
                                 , NULL AS ERP_SO_ITEM_NO
                                 , NULL AS ERP_DO_NO
                                 , NULL AS ERP_STATUS
                                 , 'C'
                                 , P_LAST_UPDATED_BY AS CREATED_BY
                                 , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE*/
                                 , P_LAST_UPDATED_BY AS LAST_UPDATED_BY
                                 , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE*/
                                 , A.ELECTRODE_YN
                                 , A.ELECTRODE_TYPE
                                 , A.ORIGIN_FROM_DIVISION_ID
                                 , A.ORIGIN_TO_DIVISION_ID
                                 , A.QTY AS BEFORE_QTY
                                 , 'Y' AS CHECK_NEED_YN
                                 , V_REMARKS
                                 , V_REMARKS2
                                 , V_REMARKS3
                                 /*----------------------------------------------------------------------------------------
                                     2020.06.30 : KBK
                                     I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                                 ------------------------------------------------------------------------------------------*/
                                 , A.PACKAGE_TYPE_CODE
                                 , A.FACTORY_ID
                                 , CASE WHEN A.ELECTRODE_YN = 'N' THEN TO_NUMBER(V_NEW_QTY)
                                        ELSE CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                                       WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                                       WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                                       ELSE NULL
                                                  END)
                                   END AS PACKAGE_QTY
                                 , A.DOM_EXP
                                 , A.ERP_ATTR1
                                 , A.ERP_ATTR2
                                 , A.ERP_ATTR3
                                 , A.ERP_ATTR4
                                 , A.ERP_ATTR5
                              FROM SSP_ANL_SHIP_CONFIRM A
                                 , SSP_MST_SITE_ITEM_EE_V B
                             WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                               AND B.SCM_SITE_ID(+) = A.FROM_SITE
                               AND B.ITEM_ID(+) = A.ITEM_ID
                               AND A.ATTRIBUTE1 = V_CONFIRM_ID;

                            UPDATE SSP_ANL_SHIP_CONFIRM
                               SET SHIPMENT_STATUS = 'P'
                                 , CHANGE_REQ_NO = NULL
                                 , QTY = 0
                                 , BEFORE_QTY = QTY
                                 , CHECK_NEED_YN = 'Y'
                                 , LAST_UPDATED_BY = P_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                                 , PACKAGE_QTY = 0
                             WHERE ATTRIBUTE1 = V_NEW_CONFIRM_ID;
                        END IF;
                    ELSE
                        /*SSP_ANL_SHIP_CONFIRM update*/
                        /* AS-IS 는 변경 상세(RD)와 내부 조인이라 상세가 없으면 갱신되지 않는다 — EXISTS 로 옮긴다 */
                        UPDATE SSP_ANL_SHIP_CONFIRM A
                           SET A.SHIPMENT_STATUS = 'C'
                             , A.CHANGE_REQ_NO = NULL
                             , A.YYYYMMDD = V_NEW_SHIP_DATE
                             , A.QTY = TO_NUMBER(V_NEW_QTY)
                             , A.BOD_ID = V_NEW_BOD_ID
                             , A.ROUTE_ID = TO_NUMBER(V_NEW_ROUTE_ID)
                             , A.INCOTERMS = V_NEW_INCOTERMS
                             , A.D_COUNTRY = V_NEW_D_CONTRY
                             , A.D_PORT_CODE = V_NEW_D_PORT_CODE
                             , A.A_COUNTRY = V_NEW_A_COUNTRY
                             , A.A_PORT_CODE = V_NEW_A_PORT_CODE
                             , A.TO_COUNTRY = V_NEW_TO_COUNTRY
                             , A.TO_CITY = V_NEW_TO_CITY
                             , A.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                             , A.ETD_DATE = V_NEW_ETD_DATE
                             , A.ETA_DATE = V_NEW_ETA_DATE
                             , A.FCST_ETD_DATE = V_NEW_ETD_DATE
                             , A.FCST_ETA_DATE = V_NEW_ETA_DATE
                             , A.CUSTOMER_LT = TO_NUMBER(V_NEW_LT_DAY)
                             , A.BEFORE_QTY = A.QTY
                             , A.CHECK_NEED_YN = 'Y'
                             , A.LAST_UPDATED_BY = P_LAST_UPDATED_BY
                             , A.LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                             , A.REMARKS = V_REMARKS
                             , A.REMARKS2 = V_REMARKS2
                             , A.REMARKS3 = V_REMARKS3
                             /*----------------------------------------------------------------------------------------
                                 2020.06.30 : KBK
                                 I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                             ------------------------------------------------------------------------------------------*/
                             , A.PACKAGE_QTY = CASE WHEN A.ELECTRODE_YN = 'N' THEN TO_NUMBER(V_NEW_QTY)
                                                    ELSE (SELECT CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                                                           WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                                                           WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                                                           ELSE NULL
                                                                      END)
                                                            FROM SSP_MST_SITE_ITEM_EE_V B
                                                           WHERE B.DIVISION_ID = A.DIVISION_ID
                                                             AND B.SCM_SITE_ID = A.FROM_SITE
                                                             AND B.ITEM_ID = A.ITEM_ID)
                                               END
                         WHERE A.CONFIRM_ID = V_NEW_CONFIRM_ID
                           AND EXISTS (SELECT 1
                                         FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                        WHERE CONFIRM_ID = A.CONFIRM_ID
                                          AND CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
                                          AND CONFIRM_ID = V_NEW_CONFIRM_ID);
                    END IF;

                    /*----이력저장*/
                    /*EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_HIST] @p_change_request_no, 'C', @v_new_confirm_id, ... */
                END IF;   /*end of @mst_loop_cnt > 0 */
            END LOOP;   /*end of while loop*/

            /*이력저장*/
            PR_SSP_ANL_SHIP_CONFIRM_HIST(P_CHANGE_REQUEST_NO, P_LAST_UPDATED_BY, P_TIME_ZONE);
        ELSE
            IF V_CHANGE_TYPE = 'C' THEN
                /*SSP_ANL_SHIP_CONFIRM update*/
                UPDATE SSP_ANL_SHIP_CONFIRM
                   SET SHIPMENT_STATUS = 'C'
                     , CHANGE_REQ_NO = NULL
                     , ATTRIBUTE1 = NULL
                     , LAST_UPDATED_BY = P_LAST_UPDATED_BY
                     , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                 WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;
            /*241105 jilee 신규건 삭제 주석 처리*/
            /*ELSE IF @p_change_type = 'N'*/
            /*	BEGIN*/
            /*		--SSP_ANL_SHIP_CONFIRM update*/
            /*		DELETE SSP_ANL_SHIP_CONFIRM*/
            /*		WHERE CHANGE_REQ_NO = @p_change_request_no;*/
            /*	END*/
            ELSE
                /*SSP_ANL_SHIP_CONFIRM update*/
                UPDATE SSP_ANL_SHIP_CONFIRM
                   SET SHIPMENT_STATUS = 'P'
                     , CHANGE_REQ_NO = NULL
                     , ATTRIBUTE1 = NULL
                     , LAST_UPDATED_BY = P_LAST_UPDATED_BY
                     , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                 WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;
            END IF;
        END IF;

        IF V_CHANGE_STATUS = 'A' THEN   /*변경확정*/
            /*메일 발송*/
            SCM_SSP_MAIL_SEND(P_CHANGE_REQUEST_NO, V_CHANGE_STATUS);

            /* 220125 jilee  SSP_MST_MODEL_USER 등록된 추가 사용자 메일 발송 */
            SELECT COUNT(*)
              INTO V_MODEL_USER_CHK
              FROM SSP_MST_MODEL_USER
             WHERE DIVISION_ID = V_DIVISION_ID
               AND FROM_SITE = P_FROM_SITE
               AND ITEM_ID = P_ITEM_ID
               AND VALID_YN = 'Y'
               AND (TRIM(ATTRIBUTE1) IS NOT NULL OR TRIM(ATTRIBUTE2) IS NOT NULL OR TRIM(ATTRIBUTE3) IS NOT NULL
                 OR TRIM(ATTRIBUTE4) IS NOT NULL OR TRIM(ATTRIBUTE5) IS NOT NULL);

            IF V_MODEL_USER_CHK > 0 THEN
                P_SSP0003_MODEL_USER_MAIL(P_CHANGE_REQUEST_NO, V_CHANGE_STATUS, P_DIVISION_ID, P_FROM_SITE, P_ITEM_ID);
            END IF;

            /*SCS I/F*/
            PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_SCS('B', P_CHANGE_REQUEST_NO);
        ELSE   /*변경 Reject*/
            /*메일 발송*/
            SCM_SSP_MAIL_SEND(P_CHANGE_REQUEST_NO, V_CHANGE_STATUS);
        END IF;

        /*240223 jilee 폴란드 WA 법인 변경건 전체 내역 송부*/
        IF LENGTH(RTRIM(V_CONFIRM_ID)) IS NOT NULL THEN
            V_CHK := 0;

            SELECT COUNT(*)
              INTO V_CHK
              FROM DUAL
             WHERE (SELECT SEGMENT1   /*company id*/
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE = 'SSP_PLN_FP_SHIP_TARGET_WA'
                       AND VALID_YN = 'Y') =
                   (SELECT FROM_SITE_COMPANY_ID
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID = V_CONFIRM_ID);

            IF V_CHK > 0 THEN
                PR_SSP_PLN_FP_SHIP_TARGET_WA;
            END IF;
        END IF;

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE := SYSDATE;

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        /* [C20201223-000448] MKT FCST - SSP Sync */
        IF V_CHANGE_STATUS = 'A' THEN   /*변경확정*/
            PR_DM_SSP_CONFIRM_SYNC(P_DIVISION_ID, P_NEW_CONFIRM_ID);
        END IF;

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
            SELECT 'S'       AS RESULT_CODE
                 , '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SUBSTR(SQLERRM, 1, 4000);

--          ROLLBACK TO SAVEPOINT SP_SSP0003_SAVE;    --  2026.10.16 AJS
-- 2026.10.16 AJS 하위 프로그램이 안에서 확정해 저장점이 없으면(ORA-01086) 남은 변경만 되돌리고 오류 결과를 돌려준다 (START)
            BEGIN
                ROLLBACK TO SAVEPOINT SP_SSP0003_SAVE;
            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK;
            END;
-- 2026.10.16 AJS 하위 프로그램이 안에서 확정해 저장점이 없으면(ORA-01086) 남은 변경만 되돌리고 오류 결과를 돌려준다 (END)

            P_LOG_ERROR(V_PROGRAM_NAME, V_ERR_MESSAGE);

            /* error코드, errror 메시지 반환 */
            OPEN O_RESULT_CURSOR FOR
                SELECT 'F'                                       AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                     , '-1'                                      AS CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS MSG
                  FROM DUAL;
    END P_SSP0003_SAVE_REQ_CONFIRM;

    /* ==============================================================================================
       SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK
       ============================================================================================== */
    PROCEDURE P_SSP0003_SAVE_REQ_IF_CHECK
    (
        P_CHANGE_REQUEST_NO IN  VARCHAR2,
        P_CHANGE_STATUS     IN  VARCHAR2,
        P_TIME_ZONE         IN  VARCHAR2,
        P_CHANGE_TYPE       IN  VARCHAR2,
        P_PARTIAL_APPROVAL  IN  VARCHAR2,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK
     * Description  : Shipment Change Request Confirm Interface Check
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/05/23   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
     * 2018/05/29   ygkim			event_date 시간 변경
     * 2018/07/10   ygkim			@p_change_type 파라미터 추가
     * 2024/02/23   jilee           폴란드 WA 법인 변경건 전체 내역 송부
     * 2024/05/22   jilee           PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE 추가
     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */
        V_STATUS                VARCHAR2(10 CHAR);
        V_CHANGE_TYPE           VARCHAR2(32767 CHAR) := NVL(P_CHANGE_TYPE, 'C');   /* AS-IS 기본값 'C' */

        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        V_N_LOG_COUNT           PLS_INTEGER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        V_EVENT_DATE            DATE;

        V_ERR_CODE              VARCHAR2(40 CHAR);
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0003_IFCHK;

        V_STATUS := NULL;

        /* 시작 LOG */
        V_LOG_TYPE := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE := SYSDATE;   /*[dbo].[FN_MULTY_TIME](@p_time_zone);*/
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        IF P_CHANGE_STATUS = 'A' THEN   /*변경확정*/
            IF V_CHANGE_TYPE = 'C' THEN
                V_STATUS := 'B';
            ELSE
                V_STATUS := 'A';
            END IF;

            /*출하확정변경시 ERP 전송 이터 테이블 저장 B: 변경확정,C: 변경요청, D: 변경 Reject*/
            PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(V_STATUS, P_CHANGE_REQUEST_NO);

            /*PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE 추가*/
            IF P_PARTIAL_APPROVAL = 'T' THEN
                P_SSP0003_ERP_IFSEQ_MERGE(P_CHANGE_REQUEST_NO, 'D');
            END IF;
        ELSE   /*변경 Reject*/
            UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
               SET ATTRIBUTE1 = 'Y'
                 /*,LAST_UPDATED_BY = @p_last_updated_by*/
                 /*,LAST_UPDATE_DATE = [dbo].[FN_MULTY_TIME](@p_time_zone)*/
             WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
               AND VALID_YN = 'Y';

            /*출하확정변경시 ERP 전송 이터 테이블 저장 B: 변경확정,C: 변경요청, D: 변경 Reject*/
            PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH('D', P_CHANGE_REQUEST_NO);
        END IF;

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
            SELECT 'S'       AS RESULT_CODE
                 , '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SUBSTR(SQLERRM, 1, 4000);

--          ROLLBACK TO SAVEPOINT SP_SSP0003_IFCHK;    --  2026.10.16 AJS
-- 2026.10.16 AJS 하위 프로그램이 안에서 확정해 저장점이 없으면(ORA-01086) 남은 변경만 되돌리고 오류 결과를 돌려준다 (START)
            BEGIN
                ROLLBACK TO SAVEPOINT SP_SSP0003_IFCHK;
            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK;
            END;
-- 2026.10.16 AJS 하위 프로그램이 안에서 확정해 저장점이 없으면(ORA-01086) 남은 변경만 되돌리고 오류 결과를 돌려준다 (END)

            P_LOG_ERROR(V_PROGRAM_NAME, V_ERR_MESSAGE);

            /* error코드, errror 메시지 반환 */
            OPEN O_RESULT_CURSOR FOR
                SELECT 'F'                                       AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                     , '-1'                                      AS CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS MSG
                  FROM DUAL;
    END P_SSP0003_SAVE_REQ_IF_CHECK;

    /* ==============================================================================================
       SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM
       ============================================================================================== */
    PROCEDURE P_SSP0003_SAVE_REQ_DE_CONFIRM
    (
        P_CHANGE_REQUEST_NO IN  VARCHAR2,
        P_CHANGE_STATUS     IN  VARCHAR2,
        P_REJECT_REASON     IN  VARCHAR2,
        P_CONFIRM_ID        IN  CLOB,
        P_NEW_CONFIRM_ID    IN  CLOB,
        P_LAST_UPDATED_BY   IN  VARCHAR2,
        P_STATUS_DETAIL     IN  CLOB,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM
     * Description  : Shipment Change Request Detail Confirm Save
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2024/04/22   hsbang         Initial Release
     * 2024/10/01   KHJ            NERP_SSP
     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */
        V_CONFIRM_ID            VARCHAR2(32767 CHAR);
        V_NEW_CONFIRM_ID        VARCHAR2(32767 CHAR);
        V_LAST_UPDATE_DATE      DATE := SYSDATE;
        /**** 20240416   hsbang   항목추가   ******************************************/
        V_STATUS_DETAIL         VARCHAR2(32767 CHAR);   /*상세내역 승인상태코드*/
        V_INFSEQNO              VARCHAR2(14 CHAR);
        V_LAST_CONFIRM_DATE     VARCHAR2(8 CHAR);

        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        V_N_LOG_COUNT           PLS_INTEGER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        V_EVENT_DATE            DATE;

        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;

        V_T_CONFIRM_ID          T_TOKEN_TAB;
        V_T_NEW_CONFIRM_ID      T_TOKEN_TAB;
        V_T_STATUS_DETAIL       T_TOKEN_TAB;
        V_F                     T_FOUND_TAB;

        V_ERR_CODE              VARCHAR2(40 CHAR);
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0003_DECFM;

        /* 시작 LOG */
        V_LOG_TYPE := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE := V_LAST_UPDATE_DATE;   /*[dbo].[FN_MULTY_TIME](@p_time_zone);*/
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        IF P_CHANGE_STATUS IN ('A', 'P', 'R', 'S', 'O') THEN   /*Approved, Partial Approved, Reject, Self Reject, D/O Reject*/
            V_MAX_LOOP_CNT := F_SPL_CNT(P_CONFIRM_ID);

            P_SPL_ARR(P_CONFIRM_ID,     V_MAX_LOOP_CNT, V_T_CONFIRM_ID,     V_F);
            P_SPL_ARR(P_NEW_CONFIRM_ID, V_MAX_LOOP_CNT, V_T_NEW_CONFIRM_ID, V_F);
            P_SPL_ARR(P_STATUS_DETAIL,  V_MAX_LOOP_CNT, V_T_STATUS_DETAIL,  V_F);

            /*	WHILE LEN(@p_active_flag) > 0 */
            WHILE LENGTH(RTRIM(P_CONFIRM_ID)) IS NOT NULL
              AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                /*SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ;  */
                V_CONFIRM_ID := V_T_CONFIRM_ID(V_MST_LOOP_CNT);
                V_NEW_CONFIRM_ID := V_T_NEW_CONFIRM_ID(V_MST_LOOP_CNT);

                IF P_CHANGE_STATUS IN ('P') THEN
                    V_STATUS_DETAIL := V_T_STATUS_DETAIL(V_MST_LOOP_CNT);
                ELSE
                    V_STATUS_DETAIL := P_CHANGE_STATUS;
                END IF;

                IF V_MST_LOOP_CNT > 0 THEN
                    UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE A
                       SET A.VALID_YN = (CASE WHEN V_STATUS_DETAIL = 'R' THEN 'N' ELSE A.VALID_YN END)
                         , A.ATTRIBUTE1 = (CASE WHEN V_STATUS_DETAIL = 'R' THEN 'Y' ELSE A.ATTRIBUTE1 END)
                         , A.ATTRIBUTE2 = (CASE WHEN A.ATTRIBUTE2 = 'Q' THEN V_STATUS_DETAIL ELSE A.ATTRIBUTE2 END)
                         , A.ATTRIBUTE3 = (CASE WHEN V_STATUS_DETAIL IN ('R', 'S', 'O') THEN P_REJECT_REASON ELSE NULL END)
                         , A.LAST_UPDATED_BY = P_LAST_UPDATED_BY
                         , A.LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
                     WHERE A.CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
                       AND A.CONFIRM_ID = V_NEW_CONFIRM_ID;

                    IF (P_CHANGE_STATUS = 'P' AND V_STATUS_DETAIL = 'R') THEN   /*Partial Approved AND Status Detail Reject*/
                        SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') || SUBSTR('000000' || TO_CHAR(SEQ1_XIF_ERP_IFSEQNO.NEXTVAL), -6)
                          INTO V_INFSEQNO
                          FROM DUAL;

                        /* 확정구간 마지막 일자( 현재일 기준 + 9 = PLANS_START_YYYYMMDD + 10) */
                        V_LAST_CONFIRM_DATE := TO_CHAR(SYSDATE + 9, 'YYYYMMDD');

                        /*EXEC PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_NEW 'D', @p_change_request_no, @v_new_confirm_id;	*/
                        INSERT INTO XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
                             (
                               IFSEQNO
                             , CONFIRM_ID
                             , SHIPMENT_STATUS
                             , LAST_CONFIRM_DATE
                             , VERSION_TYPE
                             , SALES_COMPANY_ID
                             , DIVISION_ID
                             , ITEM_ID
                             , FROM_SITE
                             , TO_SITE
                             , YYYYMMDD
                             , QTY
                             , BOD_ID
                             , ROUTE_ID
                             , OPERATION_GROUP
                             , BIZ_TYPE
                             , PROJECT_CODE
                             , FCST_TYPE
                             , FCST_ETD_DATE
                             , FCST_ETA_DATE
                             , ETD_DATE
                             , ETA_DATE
                             , INCOTERMS
                             , INCOTERMS2
                             , TRANSPORT_MODE
                             , D_COUNTRY
                             , D_PORT_CODE
                             , A_COUNTRY
                             , A_PORT_CODE
                             , CUSTOMER_LT
                             , TO_COUNTRY
                             , TO_CITY
                             , FROM_SITE_TYPE
                             , FROM_SITE_PLANT_ID
                             , FROM_SITE_VENDOR_ID
                             , FROM_SITE_SOLDTO_CODE
                             , FROM_SITE_SHIPTO_CODE
                             , FROM_SITE_COMPANY_ID
                             , TO_SITE_TYPE
                             , TO_SITE_PLANT_ID
                             , TO_SITE_VENDOR_ID
                             , TO_SITE_SOLDTO_CODE
                             , TO_SITE_SHIPTO_CODE
                             , TO_SITE_COMPANY_ID
                             /* ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) */
                             , BUILDING
                             , REMARK
                             , CUSTOMER_REQ
                             , CHANGE_CODE
                             , CHANGE_CODE_NAME
                             , REQUESTOR
                             , TRANSFER_FLAG
                             , TRANSFER_DATE
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE
                             , ATTRIBUTE1
                             /*----------------------------------------------------------------------------------------
                                 2020.06.30 : KBK
                                 I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                             ------------------------------------------------------------------------------------------*/
                             , PACKAGE_TYPE
                             , FACTORY_ID
                             , PACKAGE_QTY
                             , DOM_EXP
                             , ERP_ATTR1
                             , ERP_ATTR2
                             , ERP_ATTR3
                             , ERP_ATTR4
                             , ERP_ATTR5
                             )
                        SELECT V_INFSEQNO AS IFSEQNO
                             , A.CONFIRM_ID
                             , 'D' AS SHIPMENT_STATUS
                             , V_LAST_CONFIRM_DATE AS LAST_CONFIRM_DATE
                             , A.VERSION_TYPE
                             , NVL(B.NEW_VALUE1, A.SALES_COMPANY_ID) AS SALES_COMPANY_ID
                             , A.DIVISION_ID
                             , A.ITEM_ID
                             , NVL(C.NEW_VALUE1, A.FROM_SITE) AS FROM_SITE
                             , NVL(D.NEW_VALUE1, A.TO_SITE) AS TO_SITE
                             , A.YYYYMMDD
                             , A.QTY
                             , A.BOD_ID
                             , A.ROUTE_ID
                             , A.OPERATION_GROUP
                             , A.BIZ_TYPE
                             , A.PROJECT_CODE
                             , A.FCST_TYPE
                             , A.FCST_ETD_DATE
                             , A.FCST_ETA_DATE
                             , A.ETD_DATE
                             , A.ETA_DATE
                             , A.INCOTERMS
                             , A.INCOTERMS2
                             , A.TRANSPORT_MODE
                             , A.D_COUNTRY
                             , A.D_PORT_CODE
                             , A.A_COUNTRY
                             , A.A_PORT_CODE
                             , A.CUSTOMER_LT
                             , A.TO_COUNTRY
                             , A.TO_CITY
                             , A.FROM_SITE_TYPE
                             , NVL(E.NEW_VALUE1, A.FROM_SITE_PLANT_ID) AS FROM_SITE_PLANT_ID
                             , NVL(F.NEW_VALUE1, A.FROM_SITE_VENDOR_ID) AS FROM_SITE_VENDOR_ID
                             , NVL(G.NEW_VALUE1, A.FROM_SITE_SOLDTO_CODE) AS FROM_SITE_SOLDTO_CODE
                             , NVL(H.NEW_VALUE1, A.FROM_SITE_SHIPTO_CODE) AS FROM_SITE_SHIPTO_CODE
                             , NVL(I.NEW_VALUE1, A.FROM_SITE_COMPANY_ID) AS FROM_SITE_COMPANY_ID
                             , A.TO_SITE_TYPE
                             , NVL(J.NEW_VALUE1, A.TO_SITE_PLANT_ID) AS TO_SITE_PLANT_ID
                             , NVL(K.NEW_VALUE1, A.TO_SITE_VENDOR_ID) AS TO_SITE_VENDOR_ID
                             , NVL(L.NEW_VALUE1, A.TO_SITE_SOLDTO_CODE) AS TO_SITE_SOLDTO_CODE
                             , NVL(M.NEW_VALUE1, A.TO_SITE_SHIPTO_CODE) AS TO_SITE_SHIPTO_CODE
                             , NVL(N.NEW_VALUE1, A.TO_SITE_COMPANY_ID) AS TO_SITE_COMPANY_ID
                             , A.BUILDING
                             , A.REMARK
                             , A.CUSTOMER_REQ
                             , A.CHANGE_CODE
                             , A.CHANGE_CODE_NAME
                             , A.REQUESTOR
                             , 'P' AS TRANSFER_FLAG
                             , NULL AS TRANSFER_DATE
                             , A.CREATED_BY
                             , SYSDATE AS CREATION_DATE
                             , A.LAST_UPDATED_BY
                             , SYSDATE AS LAST_UPDATE_DATE
                             , P_CHANGE_REQUEST_NO
                             /*----------------------------------------------------------------------------------------
                                 2020.06.30 : KBK
                                 I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                             ------------------------------------------------------------------------------------------*/
                             , A.PACKAGE_TYPE
                             , A.FACTORY_ID
                             , A.PACKAGE_QTY
                             , A.DOM_EXP
                             , A.ERP_ATTR1
                             , A.ERP_ATTR2
                             , A.ERP_ATTR3
                             , A.TO_SITE_PLANT_ID AS ERP_ATTR4   /* ERP_ATTR4-- NERP에서 원본 정보 참고용 (2025-04-23) */
                             , A.ERP_ATTR5
                          FROM (SELECT IA.CONFIRM_ID
                                     , IA.VERSION_TYPE
                                     , IA.SALES_COMPANY_ID
                                     /*,X.DIVISION_ID*/
                                     , XA.ATTRIBUTE3 AS DIVISION_ID
                                     , IA.ITEM_ID
                                     , IA.FROM_SITE
                                     , IA.TO_SITE
                                     , IA.YYYYMMDD
                                     , IA.QTY
                                     , IA.BOD_ID
                                     , IA.ROUTE_ID
                                     , IA.BIZ_TYPE AS OPERATION_GROUP
                                     , IA.BIZ_TYPE
                                     , CASE WHEN IA.PROJECT_CODE IS NULL OR IA.PROJECT_CODE = '-' THEN 'TBD' ELSE IA.PROJECT_CODE END AS PROJECT_CODE
                                     , IA.FCST_TYPE
                                     , IA.FCST_ETD_DATE
                                     , IA.FCST_ETA_DATE
                                     , IA.ETD_DATE
                                     , IA.ETA_DATE
                                     , IA.INCOTERMS
                                     , IA.INCOTERMS2
                                     , IA.TRANSPORT_MODE
                                     , IA.D_COUNTRY
                                     , IA.D_PORT_CODE
                                     , IA.A_COUNTRY
                                     , IA.A_PORT_CODE
                                     , IA.CUSTOMER_LT
                                     , IA.TO_COUNTRY
                                     , IA.TO_CITY
                                     /* 현재 시점의 FROM/TO SITE 정보 전송(2018.11.26) */
                                     , FN_GET_SSP_SITE_INFO(IA.DIVISION_ID, IA.FROM_SITE, 'SITE_TYPE') AS FROM_SITE_TYPE
                                     , FN_GET_SSP_SITE_INFO(IA.DIVISION_ID, IA.FROM_SITE, 'PLANT_ID') AS FROM_SITE_PLANT_ID
                                     /* 2020-08-24 11:19:51 */
                                     /* [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청 */
                                     /* 2020-08-24  kimbl1 */
                                     , CASE WHEN SA.HQ_VENDOR_CODE IS NOT NULL THEN SA.HQ_VENDOR_CODE
                                            ELSE FN_GET_SSP_SITE_INFO(IA.DIVISION_ID, IA.FROM_SITE, 'VENDOR_ID')
                                       END AS FROM_SITE_VENDOR_ID
                                     , FN_GET_SSP_SITE_INFO(IA.DIVISION_ID, IA.FROM_SITE, 'SOLDTO_CODE') AS FROM_SITE_SOLDTO_CODE
                                     , FN_GET_SSP_SITE_INFO(IA.DIVISION_ID, IA.FROM_SITE, 'SHIPTO_CODE') AS FROM_SITE_SHIPTO_CODE
                                     , FN_GET_SSP_SITE_INFO(IA.DIVISION_ID, IA.FROM_SITE, 'COMPANY_ID') AS FROM_SITE_COMPANY_ID
                                     , FN_GET_SSP_SITE_INFO(IA.ORIGIN_TO_DIVISION_ID, IA.TO_SITE, 'SITE_TYPE') AS TO_SITE_TYPE
                                     , FN_GET_SSP_SITE_INFO(IA.ORIGIN_TO_DIVISION_ID, IA.TO_SITE, 'PLANT_ID') AS TO_SITE_PLANT_ID
                                     /* 2020-08-24 11:19:51 */
                                     /* [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청 */
                                     /* 2020-08-24  kimbl1 */
                                     , CASE WHEN XB.HQ_VENDOR_CODE IS NOT NULL THEN XB.HQ_VENDOR_CODE
                                            ELSE FN_GET_SSP_SITE_INFO(IA.ORIGIN_TO_DIVISION_ID, IA.TO_SITE, 'VENDOR_ID')
                                       END AS TO_SITE_VENDOR_ID
                                     , FN_GET_SSP_SITE_INFO(IA.ORIGIN_TO_DIVISION_ID, IA.TO_SITE, 'SOLDTO_CODE') AS TO_SITE_SOLDTO_CODE
                                     , FN_GET_SSP_SITE_INFO(IA.ORIGIN_TO_DIVISION_ID, IA.TO_SITE, 'SHIPTO_CODE') AS TO_SITE_SHIPTO_CODE
                                     , FN_GET_SSP_SITE_INFO(IA.ORIGIN_TO_DIVISION_ID, IA.TO_SITE, 'COMPANY_ID') AS TO_SITE_COMPANY_ID
                                     , IA.BUILDING
                                     , IA.REMARK
                                     , IA.CUSTOMER_REQ
                                     , IA.CHANGE_CODE
                                     /* ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) */
                                     , CASE WHEN IA.CHANGE_CODE = 'C00' THEN 'Shipment Plan Adjustment' ELSE IA.CHANGE_CODE_NAME END AS CHANGE_CODE_NAME
                                     , IA.REQUESTOR
                                     /*,GETDATE()          AS TRANSFER_DATE*/
                                     , NULL AS TRANSFER_DATE
                                     , IA.CREATED_BY
                                     /*,X.CREATION_DATE      AS CREATION_DATE*/
                                     , IA.LAST_UPDATED_BY
                                     /*,X.LAST_UPDATE_DATE   AS LAST_UPDATE_DATE*/
                                     /*----------------------------------------------------------------------------------------
                                         2020.06.30 : KBK
                                         I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                                     ------------------------------------------------------------------------------------------*/
                                     , IA.PACKAGE_TYPE
                                     , IA.FACTORY_ID
                                     , IA.PACKAGE_QTY
                                     , IA.DOM_EXP
                                     , IA.ERP_ATTR1
                                     , IA.ERP_ATTR2
                                     , IA.ERP_ATTR3
                                     , IA.ERP_ATTR4
                                     , IA.ERP_ATTR5
                                  FROM (SELECT  /* OLD */
                                               SB.CONFIRM_ID
                                             , 'B' AS VERSION_TYPE
                                             , NVL(SD.ATTRIBUTE2, SE.ATTRIBUTE2) AS SALES_COMPANY_ID
                                             /*,D.DIVISION_ID*/
                                             , CASE WHEN SB.DIVISION_ID = 'EE' THEN SB.ORIGIN_FROM_DIVISION_ID ELSE SB.DIVISION_ID END AS DIVISION_ID
                                             , SB.ITEM_ID
                                             /*                              -- 대표모델로 사용하기로 하여 임시 주석처리 이후 협의사항에 따라 변경 가능 -- 2018.10.18
                                                                             -- 40(소형) FROM_SITE가 PACKER인 경우 PACKER에 해당하는 모델로 변환
                                             ,[dbo].[FN_GET_SSP_PACKER_MODEL]( CASE WHEN D.DIVISION_ID = 'EE' THEN D.ORIGIN_FROM_DIVISION_ID ELSE D.DIVISION_ID END,
                                                                               D.FROM_SITE,
                                                                               D.ITEM_ID     )  AS  ITEM_ID
                                             */
                                             , SB.FROM_SITE
                                             , SB.TO_SITE
                                             , SB.YYYYMMDD
                                             /*,(SELECT MAX(X.NEW_YYYYMMDD) */
                                             /*  FROM  SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE X WITH(NOLOCK) */
                                             /*  WHERE X.CHANGE_REQ_NO = @p_change_req_no*/
                                             /*  AND   ISNULL(X.VALID_YN , 'N')= 'Y' */
                                             /*    )                AS YYYYMMDD_LAST*/
                                             , NVL(SB.QTY, 0) AS QTY
                                             , SB.BOD_ID
                                             , SB.ROUTE_ID
                                             , NULL AS OPERATION_GROUP
                                             , SB.BIZ_TYPE
                                             , SB.PROJECT_CODE
                                             , SB.FCST_TYPE
                                             , SB.FCST_ETD_DATE
                                             , SB.FCST_ETA_DATE
                                             , SB.ETD_DATE
                                             , SB.ETA_DATE
                                             /*,CASE WHEN  [dbo].[FN_GET_SSP_VMI_YN] (D.DIVISION_ID ,D.TO_SITE) = 'Y' THEN */
                                             /*          ISNULL([dbo].[FN_GET_SSP_MKT_FCST_INCOTERMS](D.DIVISION_ID, D.FROM_SITE, D.TO_SITE, D.ITEM_ID, D.PROJECT_CODE, D.FCST_TYPE, D.YYYYMMDD), D.INCOTERMS )*/
                                             /* ELSE D.INCOTERMS*/
                                             /* END           AS INCOTERMS*/
                                             , CASE WHEN FN_GET_SSP_VMI_YN(CASE WHEN SB.DIVISION_ID = 'EE' THEN SB.ORIGIN_FROM_DIVISION_ID ELSE SB.DIVISION_ID END, SB.TO_SITE) = 'Y' THEN
                                                         NVL(FN_GET_SSP_MKT_FCST_INCOTERMS(CASE WHEN SB.DIVISION_ID = 'EE' THEN SB.ORIGIN_FROM_DIVISION_ID ELSE SB.DIVISION_ID END, SB.FROM_SITE, SB.TO_SITE, SB.ITEM_ID, SB.PROJECT_CODE, SB.FCST_TYPE, SB.YYYYMMDD), SB.INCOTERMS)
                                                    ELSE SB.INCOTERMS
                                               END AS INCOTERMS
                                             , NULL AS INCOTERMS2
                                             , SB.TRANSPORT_MODE
                                             , SB.D_COUNTRY
                                             , SB.D_PORT_CODE
                                             , SB.A_COUNTRY
                                             , SB.A_PORT_CODE
                                             , SB.CUSTOMER_LT
                                             , SB.TO_COUNTRY
                                             , SB.TO_CITY
                                             , SB.FROM_SITE_TYPE
                                             , SB.FROM_SITE_PLANT_ID
                                             , SB.FROM_SITE_VENDOR_ID
                                             , SB.FROM_SITE_SOLDTO_CODE
                                             , SB.FROM_SITE_SHIPTO_CODE
                                             , SB.FROM_SITE_COMPANY_ID
                                             , SB.TO_SITE_TYPE
                                             , SB.TO_SITE_PLANT_ID
                                             , SB.TO_SITE_VENDOR_ID
                                             , SB.TO_SITE_SOLDTO_CODE
                                             , SB.TO_SITE_SHIPTO_CODE
                                             , SB.TO_SITE_COMPANY_ID
                                             /* ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) */
                                             , SB.REMARKS2 AS BUILDING
                                             , SB.REMARKS AS REMARK
                                             , SB.REMARKS3 AS CUSTOMER_REQ
                                             , CASE WHEN SA.CHANGE_REASON_CODE = 'Select' THEN NULL ELSE SA.CHANGE_REASON_CODE END AS CHANGE_CODE
                                             , SC.SEGMENT3 AS CHANGE_CODE_NAME
                                             , NVL(SB.REQUESTOR, SA.REQUEST_USER) AS REQUESTOR
                                             , SB.CREATED_BY
                                             , SB.CREATION_DATE
                                             , SB.LAST_UPDATED_BY
                                             , SB.LAST_UPDATE_DATE
                                             , SB.ORIGIN_TO_DIVISION_ID
                                             /*----------------------------------------------------------------------------------------
                                                 2020.06.30 : KBK
                                                 I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                                             ------------------------------------------------------------------------------------------*/
                                             , SB.PACKAGE_TYPE
                                             , SB.FACTORY_ID
                                             , SB.PACKAGE_QTY
                                             , SB.DOM_EXP
                                             , SB.ERP_ATTR1
                                             , SB.ERP_ATTR2
                                             , SB.ERP_ATTR3
                                             , SB.ERP_ATTR4
                                             , SB.ERP_ATTR5
                                          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ SA
                                             , SCM_ADM_LOOKUP_MASTER_DETAIL SC
                                             , SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE SB
                                             , SCM_ADM_LOOKUP_MASTER_DETAIL SD
                                             , SCM_ADM_LOOKUP_MASTER_DETAIL SE
                                         WHERE SC.LOOKUP_TYPE(+) = 'CHANGE_REASON_CODE'
                                           AND SC.SEGMENT1(+) = SA.CHANGE_REASON_CODE
                                           AND SD.LOOKUP_TYPE(+) = 'ELECTRODE_SHIP_FROM_TO'   /* SALES_COMPANY_ID 추출용 */
                                           AND SD.VALID_YN(+) = 'Y'
                                           AND SD.SEGMENT2(+) = SB.ORIGIN_FROM_DIVISION_ID
                                           AND SD.SEGMENT3(+) = SB.FROM_SITE
                                           AND SD.SEGMENT5(+) = SB.ORIGIN_TO_DIVISION_ID
                                           AND SD.ATTRIBUTE1(+) = SB.TO_SITE
                                           AND SE.LOOKUP_TYPE(+) = 'CELL_SHIP_FROM_TO'
                                           AND SE.VALID_YN(+) = 'Y'
                                           AND SE.SEGMENT1(+) = SB.FROM_SITE_COMPANY_ID
                                           AND SE.SEGMENT3(+) = SB.FROM_SITE
                                           AND SE.SEGMENT4(+) = SB.TO_SITE_COMPANY_ID
                                           AND SE.SEGMENT5(+) = SB.TO_SITE
                                           AND SA.CHANGE_REQ_NO = SB.CHANGE_REQ_NO
                                           AND SA.CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
                                           AND SB.CONFIRM_ID = V_NEW_CONFIRM_ID
                                           AND SB.NEW_YN = 'N'
                                           AND NVL(SB.ATTRIBUTE1, 'N') = 'Y') IA
                                     , SCM_MST_DIVISION XA
                                     /* 2020-08-24 11:19:51 */
                                     /* [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청 */
                                     /* 2020-08-24  kimbl1 */
                                     , SCM_MST_SITE SA
                                     , SCM_MST_SITE XB
                                 WHERE XA.DIVISION_ID = IA.DIVISION_ID
                                   AND SA.DIVISION_ID(+) = IA.DIVISION_ID
                                   AND SA.SCM_SITE_ID(+) = IA.FROM_SITE
                                   AND SA.VALID_YN(+) = 'Y'
                                   AND XB.DIVISION_ID(+) = IA.DIVISION_ID
                                   AND XB.SCM_SITE_ID(+) = IA.TO_SITE
                                   AND XB.VALID_YN(+) = 'Y') A
                             , NERP_CONV_MASTER B
                             , NERP_CONV_MASTER C
                             , NERP_CONV_MASTER D
                             , NERP_CONV_MASTER E
                             , NERP_CONV_MASTER F
                             , NERP_CONV_MASTER G
                             , NERP_CONV_MASTER H
                             , NERP_CONV_MASTER I
                             , NERP_CONV_MASTER J
                             , NERP_CONV_MASTER K
                             , NERP_CONV_MASTER L
                             , NERP_CONV_MASTER M
                             , NERP_CONV_MASTER N
                         WHERE B.CODETYPE(+) = 'COMPANY_ID'
                           AND B.OLD_VALUE1(+) = A.SALES_COMPANY_ID
                           AND C.CODETYPE(+) = 'SCP_SITE_ID'
                           AND C.OLD_VALUE1(+) = A.FROM_SITE
                           AND D.CODETYPE(+) = 'SCP_SITE_ID'
                           AND D.OLD_VALUE1(+) = A.TO_SITE
                           AND E.CODETYPE(+) = 'PLANT_ID'
                           AND E.OLD_VALUE1(+) = A.FROM_SITE_PLANT_ID
                           AND F.CODETYPE(+) = 'VENDOR_ID'
                           AND F.OLD_VALUE1(+) = A.FROM_SITE_VENDOR_ID
                           AND G.CODETYPE(+) = 'END_CUSTOMER_ID'
                           AND G.OLD_VALUE1(+) = A.FROM_SITE_SOLDTO_CODE
                           AND H.CODETYPE(+) = 'END_CUSTOMER_ID'
                           AND H.OLD_VALUE1(+) = A.FROM_SITE_SHIPTO_CODE
                           AND I.CODETYPE(+) = 'COMPANY_ID'
                           AND I.OLD_VALUE1(+) = A.FROM_SITE_COMPANY_ID
                           AND J.CODETYPE(+) = 'PLANT_ID'
                           AND J.OLD_VALUE1(+) = A.TO_SITE_PLANT_ID
                           AND K.CODETYPE(+) = 'VENDOR_ID'
                           AND K.OLD_VALUE1(+) = A.TO_SITE_VENDOR_ID
                           AND L.CODETYPE(+) = 'END_CUSTOMER_ID'
                           AND L.OLD_VALUE1(+) = A.TO_SITE_SOLDTO_CODE
                           AND M.CODETYPE(+) = 'END_CUSTOMER_ID'
                           AND M.OLD_VALUE1(+) = A.TO_SITE_SHIPTO_CODE
                           AND N.CODETYPE(+) = 'COMPANY_ID'
                           AND N.OLD_VALUE1(+) = A.TO_SITE_COMPANY_ID;

                        /* D일경우 ATTRIBUTE1DMF N으로 원복 해줌( 삭제대상 ) */
                        UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                           SET ATTRIBUTE1 = 'N'
                         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
                           AND CONFIRM_ID = V_NEW_CONFIRM_ID
                           AND NVL(ATTRIBUTE1, 'N') = 'Y';
                    END IF;

                    /*SSP_ANL_SHIP_CONFIRM update*/
                    IF (P_CHANGE_STATUS IN ('A', 'P')) THEN   /*Approved, Partial Approved 인 경우 처리(R, S인경우에는 SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM 에서 처리)*/
                        /* AS-IS 는 변경 상세(B)와 내부 조인 — 상세가 없으면 갱신되지 않으므로 EXISTS 로 옮긴다 */
                        UPDATE SSP_ANL_SHIP_CONFIRM A
                           SET A.SHIPMENT_STATUS = 'C'
                             , A.CHANGE_REQ_NO = (CASE WHEN V_STATUS_DETAIL = 'R' THEN NULL ELSE A.CHANGE_REQ_NO END)
                             , A.ATTRIBUTE1 = (CASE WHEN V_STATUS_DETAIL = 'R' THEN NULL ELSE A.ATTRIBUTE1 END)
                             , A.QTY = (CASE WHEN V_STATUS_DETAIL = 'R' THEN (SELECT QTY
                                                                                FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                                                               WHERE CONFIRM_ID = A.CONFIRM_ID
                                                                                 AND CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
                                                                                 AND CONFIRM_ID = V_NEW_CONFIRM_ID)
                                             ELSE A.QTY END)
                             , A.LAST_UPDATED_BY = (CASE WHEN V_STATUS_DETAIL = 'R' THEN P_LAST_UPDATED_BY ELSE A.LAST_UPDATED_BY END)
                             , A.LAST_UPDATE_DATE = (CASE WHEN V_STATUS_DETAIL = 'R' THEN V_LAST_UPDATE_DATE ELSE A.LAST_UPDATE_DATE END)
                         WHERE EXISTS (SELECT 1
                                         FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                        WHERE CONFIRM_ID = A.CONFIRM_ID
                                          AND CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
                                          AND CONFIRM_ID = V_NEW_CONFIRM_ID);
                    END IF;
                END IF;   /*end of @mst_loop_cnt > 0 */
            END LOOP;   /*end of while loop*/
        END IF;

        /* ERP IF SEQ MERGE 전송 */
        /*EXEC PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE @p_change_request_no, 'D';*/

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE := SYSDATE;

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
            SELECT 'S'       AS RESULT_CODE
                 , '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SUBSTR(SQLERRM, 1, 4000);

            ROLLBACK TO SAVEPOINT SP_SSP0003_DECFM;

            P_LOG_ERROR(V_PROGRAM_NAME, V_ERR_MESSAGE);

            /* error코드, errror 메시지 반환 */
            OPEN O_RESULT_CURSOR FOR
                SELECT 'F'                                       AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                     , '-1'                                      AS CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS MSG
                  FROM DUAL;
    END P_SSP0003_SAVE_REQ_DE_CONFIRM;

    /* ==============================================================================================
       PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE (이 화면만 호출해 패키지에 편입)
       ============================================================================================== */
    PROCEDURE P_SSP0003_ERP_IFSEQ_MERGE
    (
        P_CHANGE_REQUEST_NO IN  VARCHAR2,
        P_STATUS            IN  VARCHAR2
    )
    IS
    /*
     * Program ID   : PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE
     * Description  : IFSEQ Number Merge후 UI SHIP PLAN 전송
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2024/04/29   jilee	      IFSEQ Number Merge후 UI SHIP PLAN 전송
     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */
        V_IFSEQNO               VARCHAR2(14 CHAR);
        V_LAST_CONFIRM_DATE     VARCHAR2(8 CHAR);
        V_SHIPMENT_STATUS       VARCHAR2(1 CHAR);
    BEGIN

        /* 전송대상 IFSEQNO, LAST_CONFIRM_DATE, SHIPMENT_STATUS 조회 */
        BEGIN
            SELECT IFSEQNO
                 , LAST_CONFIRM_DATE
                 , SHIPMENT_STATUS
              INTO V_IFSEQNO
                 , V_LAST_CONFIRM_DATE
                 , V_SHIPMENT_STATUS
              FROM (SELECT IFSEQNO
                         , LAST_CONFIRM_DATE
                         , SHIPMENT_STATUS
                      FROM XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
                     WHERE TRANSFER_FLAG IN ('P', 'N')
                       /*AND A.SHIPMENT_STATUS != 'A'*/
                       AND ATTRIBUTE1 = P_CHANGE_REQUEST_NO
                     GROUP BY IFSEQNO
                            , LAST_CONFIRM_DATE
                            , SHIPMENT_STATUS
                     ORDER BY IFSEQNO DESC
                            , LAST_CONFIRM_DATE
                            , SHIPMENT_STATUS)
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_IFSEQNO := NULL;
                V_LAST_CONFIRM_DATE := NULL;
                V_SHIPMENT_STATUS := NULL;
        END;

        IF P_STATUS = 'C' THEN
            UPDATE XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
               SET IFSEQNO = V_IFSEQNO
             WHERE ATTRIBUTE1 = P_CHANGE_REQUEST_NO
               AND SHIPMENT_STATUS = 'C'
               AND TRANSFER_FLAG IN ('P', 'N');
        ELSE
            UPDATE XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
               SET IFSEQNO = V_IFSEQNO
             WHERE ATTRIBUTE1 = P_CHANGE_REQUEST_NO
               AND TRANSFER_FLAG IN ('P', 'N');
        END IF;

    END P_SSP0003_ERP_IFSEQ_MERGE;

    /* ==============================================================================================
       SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40
       ============================================================================================== */
    PROCEDURE P_SSP0003_SAVE_REQ_CONFIRM_40
    (
        P_CHANGE_REQUEST_NO IN  VARCHAR2,
        P_CHANGE_STATUS     IN  VARCHAR2,
        P_REJECT_REASON     IN  VARCHAR2,
        P_DIVISION_ID       IN  CLOB,
        P_ITEM_ID           IN  VARCHAR2,
        P_FROM_SITE         IN  VARCHAR2,
        P_YYYYMMDD          IN  VARCHAR2,
        P_CONFIRM_ID        IN  CLOB,
        P_NEW_CONFIRM_ID    IN  CLOB,
        P_NEW_ETD_DATE      IN  CLOB,
        P_NEW_ETA_DATE      IN  CLOB,
        P_NEW_QTY           IN  CLOB,
        P_NEW_SHIP_DATE     IN  CLOB,
        P_NEW_YN            IN  CLOB,
        P_NEW_BOD_ID        IN  CLOB,
        P_NEW_ROUTE_ID      IN  CLOB,
        P_NEW_INCOTERMS     IN  CLOB,
        P_NEW_D_CONTRY      IN  CLOB,
        P_NEW_D_PORT_CODE   IN  CLOB,
        P_NEW_A_COUNTRY     IN  CLOB,
        P_NEW_A_PORT_CODE   IN  CLOB,
        P_NEW_TO_COUNTRY    IN  CLOB,
        P_NEW_TO_CITY       IN  CLOB,
        P_NEW_LT_DAY        IN  CLOB,
        P_NEW_TRANSPORT_MODE IN CLOB,
        P_LAST_UPDATED_BY   IN  VARCHAR2,
        P_TIME_ZONE         IN  VARCHAR2,
        P_CHANGE_TYPE       IN  VARCHAR2,
        P_REMARKS           IN  CLOB,
        P_REMARKS2          IN  CLOB,
        P_REMARKS3          IN  CLOB,
        P_DELEGATEE         IN  VARCHAR2,
        P_DELEGATEE_DEPT    IN  VARCHAR2,
        P_ERP_ATTR1         IN  CLOB,
        P_ERP_ATTR2         IN  CLOB,
        P_ERP_ATTR3         IN  CLOB,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40
     * Description  : Shipment Change Request Confirm Save_40
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2019/03/19   AYJ            Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
     * 2019/07/15	mcTheJ			[CSR ID:4044806] Model PIC 담당자 위임 기능 추가 - 위임자 결재 추가
     * 2019/10/29	ayj				FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
     * 2021/01/07   KIMYONGHO       [C20201223-000448] MKT FCST - SSP Sync
     * 2021/01/12   KIMYONGHO       [C20201223-000448] MKT FCST - SSP Sync CONFIRM_ID parameter 변경
     * 2021/10/18   SHINMYUNGSU	    SSP_ANL_SHIP_CONFIRM의 ERP_ATTR1~3 항목 추가
     * 2024/04/22   hsbang          부분승인('P', Partial Approved) 추가 (hsbang, 2024.04.22)
     * 2024/05/22   jilee           ERP Reject 포함한 경우 부분 승인 업데이트
     * 2025/12/11   chkim.68        E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */
        V_DIVISION_ID           VARCHAR2(32767 CHAR);
        V_CONFIRM_ID            VARCHAR2(32767 CHAR);
        V_NEW_CONFIRM_ID        VARCHAR2(32767 CHAR);
        V_NEW_ETD_DATE          VARCHAR2(32767 CHAR);
        V_NEW_ETA_DATE          VARCHAR2(32767 CHAR);
        V_NEW_QTY               VARCHAR2(32767 CHAR);
        V_NEW_SHIP_DATE         VARCHAR2(32767 CHAR);
        V_NEW_YN                VARCHAR2(32767 CHAR);

        V_NEW_BOD_ID            VARCHAR2(32767 CHAR);
        V_NEW_ROUTE_ID          VARCHAR2(32767 CHAR);
        V_NEW_INCOTERMS         VARCHAR2(32767 CHAR);
        V_NEW_D_CONTRY          VARCHAR2(32767 CHAR);
        V_NEW_D_PORT_CODE       VARCHAR2(32767 CHAR);
        V_NEW_A_COUNTRY         VARCHAR2(32767 CHAR);
        V_NEW_A_PORT_CODE       VARCHAR2(32767 CHAR);
        V_NEW_TO_COUNTRY        VARCHAR2(32767 CHAR);
        V_NEW_TO_CITY           VARCHAR2(32767 CHAR);
        V_NEW_LT_DAY            VARCHAR2(32767 CHAR);
        V_NEW_TRANSPORT_MODE    VARCHAR2(32767 CHAR);

        V_N_DIVISION_ID         VARCHAR2(32767 CHAR);
        V_N_ITEM_ID             VARCHAR2(32767 CHAR);
        V_N_FROM_SITE           VARCHAR2(32767 CHAR);
        V_N_TO_SITE             VARCHAR2(32767 CHAR);
        V_N_YYYYMMDD            VARCHAR2(32767 CHAR);
        V_N_BOD_ID              VARCHAR2(32767 CHAR);
        V_N_PROJECT_CODE        VARCHAR2(32767 CHAR);
        V_N_FCST_TYPE           VARCHAR2(32767 CHAR);
        V_N_INCOTERMS           VARCHAR2(32767 CHAR);
        V_N_TRANSPORT_MODE      VARCHAR2(32767 CHAR);
        V_N_CONFIRM_ID          VARCHAR2(32767 CHAR);
        V_PLAN_START_YYYYMMDD   VARCHAR2(32767 CHAR);
        V_SEQ                   NUMBER;

        V_N_ORI_DIVISION_ID     VARCHAR2(32767 CHAR);
        V_N_ORI_ITEM_ID         VARCHAR2(32767 CHAR);
        V_N_ORI_FROM_SITE       VARCHAR2(32767 CHAR);
        V_N_ORI_TO_SITE         VARCHAR2(32767 CHAR);
        V_N_ORI_YYYYMMDD        VARCHAR2(32767 CHAR);
        V_N_ORI_BOD_ID          VARCHAR2(32767 CHAR);
        V_N_ORI_PROJECT_CODE    VARCHAR2(32767 CHAR);
        V_N_ORI_FCST_TYPE       VARCHAR2(32767 CHAR);
        V_N_ORI_INCOTERMS       VARCHAR2(32767 CHAR);
        V_N_ORI_TRANSPORT_MODE  VARCHAR2(32767 CHAR);
        V_N_ORI_CONFIRM_ID      VARCHAR2(32767 CHAR);
        V_PLANNED_QTY           NUMBER(30, 3) := 0;   /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */

        V_CHK                   PLS_INTEGER := 0;
        V_LAST_UPDATE_DATE      DATE := SYSDATE;

        V_REMARKS               VARCHAR2(32767 CHAR);
        V_REMARKS2              VARCHAR2(32767 CHAR);
        V_REMARKS3              VARCHAR2(32767 CHAR);

        /**** 20211018   SHINMYUNGSU   항목추가   ****************/
        V_ERP_ATTR1             VARCHAR2(32767 CHAR);
        V_ERP_ATTR2             VARCHAR2(32767 CHAR);
        V_ERP_ATTR3             VARCHAR2(32767 CHAR);
        /*********************************************************/

        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        V_N_LOG_COUNT           PLS_INTEGER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        V_EVENT_DATE            DATE;

        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_ERP_ERROR_CHK         PLS_INTEGER := 0;
        V_APPROVED_CHK          PLS_INTEGER := 0;

        /* AS-IS 는 입력 파라미터 자체를 바꾸므로 로컬 변수로 받는다 */
        V_CHANGE_STATUS         VARCHAR2(32767 CHAR) := P_CHANGE_STATUS;
        V_REJECT_REASON         VARCHAR2(32767 CHAR) := P_REJECT_REASON;
        V_CHANGE_TYPE           VARCHAR2(32767 CHAR) := P_CHANGE_TYPE;
        V_YYYYMMDD              VARCHAR2(32767 CHAR) := P_YYYYMMDD;

        V_T_DIVISION_ID         T_TOKEN_TAB;
        V_T_CONFIRM_ID          T_TOKEN_TAB;
        V_T_NEW_CONFIRM_ID      T_TOKEN_TAB;
        V_T_NEW_ETD_DATE        T_TOKEN_TAB;
        V_T_NEW_ETA_DATE        T_TOKEN_TAB;
        V_T_NEW_QTY             T_TOKEN_TAB;
        V_T_NEW_SHIP_DATE       T_TOKEN_TAB;
        V_T_NEW_YN              T_TOKEN_TAB;
        V_T_NEW_BOD_ID          T_TOKEN_TAB;
        V_T_NEW_ROUTE_ID        T_TOKEN_TAB;
        V_T_NEW_INCOTERMS       T_TOKEN_TAB;
        V_T_NEW_D_CONTRY        T_TOKEN_TAB;
        V_T_NEW_D_PORT_CODE     T_TOKEN_TAB;
        V_T_NEW_A_COUNTRY       T_TOKEN_TAB;
        V_T_NEW_A_PORT_CODE     T_TOKEN_TAB;
        V_T_NEW_TO_COUNTRY      T_TOKEN_TAB;
        V_T_NEW_TO_CITY         T_TOKEN_TAB;
        V_T_NEW_LT_DAY          T_TOKEN_TAB;
        V_T_NEW_TRANSPORT_MODE  T_TOKEN_TAB;
        V_T_REMARKS             T_TOKEN_TAB;
        V_T_REMARKS2            T_TOKEN_TAB;
        V_T_REMARKS3            T_TOKEN_TAB;
        V_T_ERP_ATTR1           T_TOKEN_TAB;
        V_T_ERP_ATTR2           T_TOKEN_TAB;
        V_T_ERP_ATTR3           T_TOKEN_TAB;
        V_F                     T_FOUND_TAB;

        V_ERR_CODE              VARCHAR2(40 CHAR);
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0003_SAVE40;

        /* 시작 LOG */
        V_LOG_TYPE := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE := V_LAST_UPDATE_DATE;   /*[dbo].[FN_MULTY_TIME](@p_time_zone);*/
        /*EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;*/

        /* AS-IS #TblDynamic_SSP0003_40_STD — 같은 세션에서 다시 부를 때 쌓이지 않도록 먼저 비운다 */
        DELETE FROM GT_SSP0003_40_STD;

        /* SSP_ANL_SHIP_PLAN_40 의 데이터 생성 시점이 달라 최신 생성 날짜를 조회한다. */
        INSERT INTO GT_SSP0003_40_STD
             (
               DIVISION_ID
             , FROM_SITE
             , PLAN_START_YYYYMMDD
             , COMPANY_ID
             )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.FROM_SITE
             , A.PLAN_START_YYYYMMDD
             , B.COMPANY_ID
          FROM (SELECT DIVISION_ID
                     , FROM_SITE
                     , PLAN_START_YYYYMMDD
                     , RANK() OVER(PARTITION BY FROM_SITE ORDER BY PLAN_START_YYYYMMDD DESC) AS RANK
                  FROM SSP_ANL_SHIP_PLAN_40
                 WHERE DIVISION_ID = '40'
                   -- AND PLAN_START_YYYYMMDD >= TO_CHAR(SYSDATE - 2, 'YYYYMMDD')   /* JSH 전일 테스트용 임시 주석 20261103*/
                   AND PLAN_START_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')       /* 당일 */
                   AND QTY > 0) A
             , SCM_MST_SITE B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.FROM_SITE
           AND A.RANK = 1;

        /* ERP Reject 포함한 경우 부분 승인 업데이트 ------------------------------------------------------- */
        SELECT COUNT(*)
          INTO V_ERP_ERROR_CHK
          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
           AND ATTRIBUTE2 = 'E';

        SELECT COUNT(*)
          INTO V_APPROVED_CHK
          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
           AND ATTRIBUTE2 = 'A';

        IF V_ERP_ERROR_CHK > 0 AND V_APPROVED_CHK > 0 THEN
            V_CHANGE_STATUS := 'P';

            BEGIN
                SELECT ATTRIBUTE3
                  INTO V_REJECT_REASON
                  FROM (SELECT ATTRIBUTE3
                          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
                           AND ATTRIBUTE2 = 'E')
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_REJECT_REASON := NULL;
            END;
        ELSIF V_APPROVED_CHK = 0 THEN
            V_CHANGE_STATUS := 'R';

            BEGIN
                SELECT ATTRIBUTE3
                  INTO V_REJECT_REASON
                  FROM (SELECT ATTRIBUTE3
                          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO)
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_REJECT_REASON := NULL;
            END;
        END IF;
        /* ----------------------------------------------------------------------------------------------- */

        IF LENGTH(RTRIM(P_DELEGATEE)) IS NULL THEN
            UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
               SET CHANGE_REQ_STATUS = V_CHANGE_STATUS
                 , APPROVAL_TIME = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                 , REJECT_REASON = (CASE WHEN V_CHANGE_STATUS IN ('R', 'S', 'P') THEN V_REJECT_REASON END)   /*Reject(R), Self Reject(S)*/
                 , LAST_UPDATED_BY = P_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
             WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;
        ELSE
            UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
               SET CHANGE_REQ_STATUS = V_CHANGE_STATUS
                 , APPROVAL_TIME = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                 , REJECT_REASON = (CASE WHEN V_CHANGE_STATUS IN ('R', 'S', 'P') THEN V_REJECT_REASON END)   /*Reject(R), Self Reject(S)*/
                 , DELEGATEE_USER = P_DELEGATEE
                 , DELEGATEE_DEPT = P_DELEGATEE_DEPT
                 , LAST_UPDATED_BY = P_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
             WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;
        END IF;

        IF V_CHANGE_STATUS IN ('A', 'P') THEN   /*Approved, Partial Approved(hsbang20, 2024.04.22)*/
            V_MAX_LOOP_CNT := F_SPL_CNT(P_CONFIRM_ID);

            P_SPL_ARR(P_DIVISION_ID,        V_MAX_LOOP_CNT, V_T_DIVISION_ID,       V_F);
            P_SPL_ARR(P_CONFIRM_ID,         V_MAX_LOOP_CNT, V_T_CONFIRM_ID,        V_F);
            P_SPL_ARR(P_NEW_CONFIRM_ID,     V_MAX_LOOP_CNT, V_T_NEW_CONFIRM_ID,    V_F);
            P_SPL_ARR(P_NEW_ETD_DATE,       V_MAX_LOOP_CNT, V_T_NEW_ETD_DATE,      V_F);
            P_SPL_ARR(P_NEW_ETA_DATE,       V_MAX_LOOP_CNT, V_T_NEW_ETA_DATE,      V_F);
            P_SPL_ARR(P_NEW_QTY,            V_MAX_LOOP_CNT, V_T_NEW_QTY,           V_F);
            P_SPL_ARR(P_NEW_SHIP_DATE,      V_MAX_LOOP_CNT, V_T_NEW_SHIP_DATE,     V_F);
            P_SPL_ARR(P_NEW_YN,             V_MAX_LOOP_CNT, V_T_NEW_YN,            V_F);
            P_SPL_ARR(P_NEW_BOD_ID,         V_MAX_LOOP_CNT, V_T_NEW_BOD_ID,        V_F);
            P_SPL_ARR(P_NEW_ROUTE_ID,       V_MAX_LOOP_CNT, V_T_NEW_ROUTE_ID,      V_F);
            P_SPL_ARR(P_NEW_INCOTERMS,      V_MAX_LOOP_CNT, V_T_NEW_INCOTERMS,     V_F);
            P_SPL_ARR(P_NEW_D_CONTRY,       V_MAX_LOOP_CNT, V_T_NEW_D_CONTRY,      V_F);
            P_SPL_ARR(P_NEW_D_PORT_CODE,    V_MAX_LOOP_CNT, V_T_NEW_D_PORT_CODE,   V_F);
            P_SPL_ARR(P_NEW_A_COUNTRY,      V_MAX_LOOP_CNT, V_T_NEW_A_COUNTRY,     V_F);
            P_SPL_ARR(P_NEW_A_PORT_CODE,    V_MAX_LOOP_CNT, V_T_NEW_A_PORT_CODE,   V_F);
            P_SPL_ARR(P_NEW_TO_COUNTRY,     V_MAX_LOOP_CNT, V_T_NEW_TO_COUNTRY,    V_F);
            P_SPL_ARR(P_NEW_TO_CITY,        V_MAX_LOOP_CNT, V_T_NEW_TO_CITY,       V_F);
            P_SPL_ARR(P_NEW_LT_DAY,         V_MAX_LOOP_CNT, V_T_NEW_LT_DAY,        V_F);
            P_SPL_ARR(P_NEW_TRANSPORT_MODE, V_MAX_LOOP_CNT, V_T_NEW_TRANSPORT_MODE, V_F);
            P_SPL_ARR(P_REMARKS,            V_MAX_LOOP_CNT, V_T_REMARKS,           V_F);
            P_SPL_ARR(P_REMARKS2,           V_MAX_LOOP_CNT, V_T_REMARKS2,          V_F);
            P_SPL_ARR(P_REMARKS3,           V_MAX_LOOP_CNT, V_T_REMARKS3,          V_F);
            P_SPL_ARR(P_ERP_ATTR1,          V_MAX_LOOP_CNT, V_T_ERP_ATTR1,         V_F);
            P_SPL_ARR(P_ERP_ATTR2,          V_MAX_LOOP_CNT, V_T_ERP_ATTR2,         V_F);
            P_SPL_ARR(P_ERP_ATTR3,          V_MAX_LOOP_CNT, V_T_ERP_ATTR3,         V_F);

            WHILE LENGTH(RTRIM(P_CONFIRM_ID)) IS NOT NULL
              AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                V_DIVISION_ID        := V_T_DIVISION_ID(V_MST_LOOP_CNT);
                V_CONFIRM_ID         := V_T_CONFIRM_ID(V_MST_LOOP_CNT);
                V_NEW_CONFIRM_ID     := V_T_NEW_CONFIRM_ID(V_MST_LOOP_CNT);
                V_NEW_ETD_DATE       := V_T_NEW_ETD_DATE(V_MST_LOOP_CNT);
                V_NEW_ETA_DATE       := V_T_NEW_ETA_DATE(V_MST_LOOP_CNT);
                V_NEW_QTY            := V_T_NEW_QTY(V_MST_LOOP_CNT);
                V_NEW_SHIP_DATE      := V_T_NEW_SHIP_DATE(V_MST_LOOP_CNT);
                V_NEW_YN             := V_T_NEW_YN(V_MST_LOOP_CNT);

                V_NEW_BOD_ID         := V_T_NEW_BOD_ID(V_MST_LOOP_CNT);
                V_NEW_ROUTE_ID       := V_T_NEW_ROUTE_ID(V_MST_LOOP_CNT);
                V_NEW_INCOTERMS      := V_T_NEW_INCOTERMS(V_MST_LOOP_CNT);
                V_NEW_D_CONTRY       := V_T_NEW_D_CONTRY(V_MST_LOOP_CNT);
                V_NEW_D_PORT_CODE    := V_T_NEW_D_PORT_CODE(V_MST_LOOP_CNT);
                V_NEW_A_COUNTRY      := V_T_NEW_A_COUNTRY(V_MST_LOOP_CNT);
                V_NEW_A_PORT_CODE    := V_T_NEW_A_PORT_CODE(V_MST_LOOP_CNT);
                V_NEW_TO_COUNTRY     := V_T_NEW_TO_COUNTRY(V_MST_LOOP_CNT);
                V_NEW_TO_CITY        := V_T_NEW_TO_CITY(V_MST_LOOP_CNT);
                V_NEW_LT_DAY         := V_T_NEW_LT_DAY(V_MST_LOOP_CNT);
                V_NEW_TRANSPORT_MODE := V_T_NEW_TRANSPORT_MODE(V_MST_LOOP_CNT);

                V_REMARKS            := V_T_REMARKS(V_MST_LOOP_CNT);
                V_REMARKS2           := V_T_REMARKS2(V_MST_LOOP_CNT);
                V_REMARKS3           := V_T_REMARKS3(V_MST_LOOP_CNT);

                /**** 20211018   SHINMYUNGSU   항목추가   ******************************************************/
                V_ERP_ATTR1          := V_T_ERP_ATTR1(V_MST_LOOP_CNT);
                V_ERP_ATTR2          := V_T_ERP_ATTR2(V_MST_LOOP_CNT);
                V_ERP_ATTR3          := V_T_ERP_ATTR3(V_MST_LOOP_CNT);
                /***********************************************************************************************/

                IF V_MST_LOOP_CNT > 0 THEN
                    V_NEW_ETD_DATE := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                    /*SET @v_new_eta_date = REPLACE(SUBSTRING(@v_new_eta_date,1,10),'-','')*/
                    V_NEW_SHIP_DATE := REPLACE(SUBSTR(V_NEW_SHIP_DATE, 1, 10), '-', '');

                    /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
                    /*2021.04.08 [C20210406-000222]  @P_division_id - > @v_division_id*/
                    V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(V_DIVISION_ID, V_NEW_BOD_ID, V_NEW_SHIP_DATE);

                    V_CHK := 0;

                    IF V_NEW_YN = 'Y' THEN
                        /* SSP0200 에서 사용 시  @p_change_type = 'N' 변경 */
                        V_CHANGE_TYPE := 'N';

                        IF V_CHANGE_TYPE = 'C' THEN
                            /*SSP_ANL_SHIP_CONFIRM table insert*/
                            INSERT INTO SSP_ANL_SHIP_CONFIRM
                                 (
                                   CONFIRM_ID
                                 , SHIPMENT_STATUS
                                 , DIVISION_ID
                                 , PLAN_START_YYYYMMDD
                                 , PLAN_TYPE
                                 , SEQ
                                 , ITEM_ID
                                 , FROM_SITE
                                 , TO_SITE
                                 , YYYYMMDD
                                 , PLANNED_QTY
                                 , QTY
                                 , BOD_ID
                                 , ROUTE_ID
                                 , BIZ_TYPE
                                 , PROJECT_CODE
                                 , FCST_TYPE
                                 , FCST_ETD_DATE
                                 , FCST_ETA_DATE
                                 , ETD_DATE
                                 , ETA_DATE
                                 , INCOTERMS
                                 , TRANSPORT_MODE
                                 , D_COUNTRY
                                 , D_PORT_CODE
                                 , A_COUNTRY
                                 , A_PORT_CODE
                                 , CUSTOMER_LT
                                 , TO_COUNTRY
                                 , TO_CITY
                                 , FROM_SITE_TYPE
                                 , FROM_SITE_PLANT_ID
                                 , FROM_SITE_VENDOR_ID
                                 , FROM_SITE_SOLDTO_CODE
                                 , FROM_SITE_SHIPTO_CODE
                                 , FROM_SITE_COMPANY_ID
                                 , TO_SITE_TYPE
                                 , TO_SITE_PLANT_ID
                                 , TO_SITE_VENDOR_ID
                                 , TO_SITE_SOLDTO_CODE
                                 , TO_SITE_SHIPTO_CODE
                                 , TO_SITE_COMPANY_ID
                                 , CHANGE_REQ_NO
                                 , ERP_SO_NO   /*신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.*/
                                 , ERP_SO_ITEM_NO
                                 , ERP_DO_NO
                                 , ERP_STATUS
                                 , CHANGE_TYPE
                                 , CREATED_BY
                                 , CREATION_DATE
                                 , LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE
                                 , ELECTRODE_YN
                                 , ELECTRODE_TYPE
                                 , ORIGIN_FROM_DIVISION_ID
                                 , ORIGIN_TO_DIVISION_ID
                                 , BEFORE_QTY
                                 , CHECK_NEED_YN
                                 , REMARKS
                                 , REMARKS2
                                 , REMARKS3
                                 , PACKAGE_TYPE_CODE
                                 , FACTORY_ID
                                 , PACKAGE_QTY
                                 , DOM_EXP
                                 , ERP_ATTR1
                                 , ERP_ATTR2
                                 , ERP_ATTR3
                                 , ERP_ATTR4
                                 , ERP_ATTR5
                                 )
                            SELECT V_NEW_CONFIRM_ID AS CONFIRM_ID
                                 , 'C' AS SHIPMENT_STATUS
                                 , A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.ITEM_ID
                                 , A.FROM_SITE
                                 , A.TO_SITE
                                 , V_NEW_SHIP_DATE AS YYYYMMDD
                                 , 0 AS PLANNED_QTY
                                 , TO_NUMBER(V_NEW_QTY) AS QTY
                                 , V_NEW_BOD_ID AS BOD_ID
                                 , TO_NUMBER(V_NEW_ROUTE_ID) AS ROUTE_ID
                                 , A.BIZ_TYPE
                                 , A.PROJECT_CODE
                                 , A.FCST_TYPE
                                 , A.FCST_ETD_DATE
                                 , A.FCST_ETA_DATE
                                 , V_NEW_ETD_DATE AS ETD_DATE
                                 , V_NEW_ETA_DATE AS ETA_DATE
                                 , V_NEW_INCOTERMS AS INCOTERMS
                                 , V_NEW_TRANSPORT_MODE AS TRANSPORT_MODE
                                 , V_NEW_D_CONTRY AS D_COUNTRY
                                 , V_NEW_D_PORT_CODE AS D_PORT_CODE
                                 , V_NEW_A_COUNTRY AS A_COUNTRY
                                 , V_NEW_A_PORT_CODE AS A_PORT_CODE
                                 , TO_NUMBER(V_NEW_LT_DAY) AS CUSTOMER_LT
                                 , V_NEW_TO_COUNTRY AS TO_COUNTRY
                                 , V_NEW_TO_CITY AS TO_CITY
                                 , A.FROM_SITE_TYPE
                                 , A.FROM_SITE_PLANT_ID
                                 , A.FROM_SITE_VENDOR_ID
                                 , A.FROM_SITE_SOLDTO_CODE
                                 , A.FROM_SITE_SHIPTO_CODE
                                 , A.FROM_SITE_COMPANY_ID
                                 , A.TO_SITE_TYPE
                                 , A.TO_SITE_PLANT_ID
                                 , A.TO_SITE_VENDOR_ID
                                 , A.TO_SITE_SOLDTO_CODE
                                 , A.TO_SITE_SHIPTO_CODE
                                 , A.TO_SITE_COMPANY_ID
                                 , NULL AS CHANGE_REQ_NO
                                 , NULL AS ERP_SO_NO   /*신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.*/
                                 , NULL AS ERP_SO_ITEM_NO
                                 , NULL AS ERP_DO_NO
                                 , NULL AS ERP_STATUS
                                 , 'C'
                                 , P_LAST_UPDATED_BY AS CREATED_BY
                                 , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE*/
                                 , P_LAST_UPDATED_BY AS LAST_UPDATED_BY
                                 , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE*/
                                 , A.ELECTRODE_YN
                                 , A.ELECTRODE_TYPE
                                 , A.ORIGIN_FROM_DIVISION_ID
                                 , A.ORIGIN_TO_DIVISION_ID
                                 , 0 AS BEFORE_QTY
                                 , 'Y' AS CHECK_NEED_YN
                                 , V_REMARKS
                                 , V_REMARKS2
                                 , V_REMARKS3
                                 , A.PACKAGE_TYPE_CODE
                                 , A.FACTORY_ID
                                 , CASE WHEN A.ELECTRODE_YN = 'N' THEN TO_NUMBER(V_NEW_QTY)
                                        ELSE CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                                       WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                                       WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                                       ELSE NULL
                                                  END)
                                   END AS PACKAGE_QTY
                                 , A.DOM_EXP
                                 , V_ERP_ATTR1
                                 , V_ERP_ATTR2
                                 , V_ERP_ATTR3
                                 , A.ERP_ATTR4
                                 , A.ERP_ATTR5
                              FROM SSP_ANL_SHIP_CONFIRM A
                                 , SSP_MST_SITE_ITEM_EE_V B
                             WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                               AND B.SCM_SITE_ID(+) = A.FROM_SITE
                               AND B.ITEM_ID(+) = A.ITEM_ID
                               AND A.CONFIRM_ID = V_CONFIRM_ID;
                        ELSIF V_CHANGE_TYPE = 'N' THEN
                            V_CHK := 0;

                            SELECT COUNT(*)
                              INTO V_CHK
                              FROM SSP_ANL_SHIP_CONFIRM
                             WHERE CONFIRM_ID = V_NEW_CONFIRM_ID;

                            IF V_CHK > 0 THEN
                                UPDATE SSP_ANL_SHIP_CONFIRM A
                                   SET A.CHANGE_TYPE = 'C'
                                     , A.SHIPMENT_STATUS = 'C'
                                     , A.CHANGE_REQ_NO = NULL
                                     , A.YYYYMMDD = V_NEW_SHIP_DATE
                                     , A.QTY = TO_NUMBER(V_NEW_QTY)
                                     , A.BOD_ID = V_NEW_BOD_ID
                                     , A.ROUTE_ID = TO_NUMBER(V_NEW_ROUTE_ID)
                                     , A.INCOTERMS = V_NEW_INCOTERMS
                                     , A.D_COUNTRY = V_NEW_D_CONTRY
                                     , A.D_PORT_CODE = V_NEW_D_PORT_CODE
                                     , A.A_COUNTRY = V_NEW_A_COUNTRY
                                     , A.A_PORT_CODE = V_NEW_A_PORT_CODE
                                     , A.TO_COUNTRY = V_NEW_TO_COUNTRY
                                     , A.TO_CITY = V_NEW_TO_CITY
                                     , A.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                                     , A.ETD_DATE = V_NEW_ETD_DATE
                                     , A.ETA_DATE = V_NEW_ETA_DATE
                                     , A.CUSTOMER_LT = TO_NUMBER(V_NEW_LT_DAY)
                                     , A.BEFORE_QTY = 0
                                     , A.CHECK_NEED_YN = 'Y'
                                     , A.LAST_UPDATED_BY = P_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                                     , A.REMARKS = V_REMARKS
                                     , A.REMARKS2 = V_REMARKS2
                                     , A.REMARKS3 = V_REMARKS3
                                     /**** 20211018   SHINMYUNGSU   항목추가   ****************/
                                     , A.ERP_ATTR1 = V_ERP_ATTR1
                                     , A.ERP_ATTR2 = V_ERP_ATTR2
                                     , A.ERP_ATTR3 = V_ERP_ATTR3
                                     /*********************************************************/
                                     , A.PACKAGE_QTY = CASE WHEN A.ELECTRODE_YN = 'N' THEN TO_NUMBER(V_NEW_QTY)
                                                            ELSE (SELECT CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                                                                   WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                                                                   WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                                                                   ELSE NULL
                                                                              END)
                                                                    FROM SSP_MST_SITE_ITEM_EE_V B
                                                                   WHERE B.DIVISION_ID = A.DIVISION_ID
                                                                     AND B.SCM_SITE_ID = A.FROM_SITE
                                                                     AND B.ITEM_ID = A.ITEM_ID)
                                                       END
                                 WHERE A.CONFIRM_ID = V_NEW_CONFIRM_ID;
                            ELSE
                                INSERT INTO SSP_ANL_SHIP_CONFIRM
                                     (
                                       CONFIRM_ID
                                     , SHIPMENT_STATUS
                                     , DIVISION_ID
                                     , PLAN_START_YYYYMMDD
                                     , PLAN_TYPE
                                     , SEQ
                                     , ITEM_ID
                                     , FROM_SITE
                                     , TO_SITE
                                     , YYYYMMDD
                                     , PLANNED_QTY
                                     , QTY
                                     , BOD_ID
                                     , ROUTE_ID
                                     , BIZ_TYPE
                                     , PROJECT_CODE
                                     , FCST_TYPE
                                     , FCST_ETD_DATE
                                     , FCST_ETA_DATE
                                     , ETD_DATE
                                     , ETA_DATE
                                     , INCOTERMS
                                     , TRANSPORT_MODE
                                     , D_COUNTRY
                                     , D_PORT_CODE
                                     , A_COUNTRY
                                     , A_PORT_CODE
                                     , CUSTOMER_LT
                                     , TO_COUNTRY
                                     , TO_CITY
                                     , FROM_SITE_TYPE
                                     , FROM_SITE_PLANT_ID
                                     , FROM_SITE_VENDOR_ID
                                     , FROM_SITE_SOLDTO_CODE
                                     , FROM_SITE_SHIPTO_CODE
                                     , FROM_SITE_COMPANY_ID
                                     , TO_SITE_TYPE
                                     , TO_SITE_PLANT_ID
                                     , TO_SITE_VENDOR_ID
                                     , TO_SITE_SOLDTO_CODE
                                     , TO_SITE_SHIPTO_CODE
                                     , TO_SITE_COMPANY_ID
                                     , CHANGE_REQ_NO
                                     , ERP_SO_NO   /*신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.*/
                                     , ERP_SO_ITEM_NO
                                     , ERP_DO_NO
                                     , ERP_STATUS
                                     , CHANGE_TYPE
                                     , CREATED_BY
                                     , CREATION_DATE
                                     , LAST_UPDATED_BY
                                     , LAST_UPDATE_DATE
                                     , ELECTRODE_YN
                                     , ELECTRODE_TYPE
                                     , ORIGIN_FROM_DIVISION_ID
                                     , ORIGIN_TO_DIVISION_ID
                                     , BEFORE_QTY
                                     , CHECK_NEED_YN
                                     , REMARKS
                                     , REMARKS2
                                     , REMARKS3
                                     , PACKAGE_TYPE_CODE
                                     , FACTORY_ID
                                     , PACKAGE_QTY
                                     , DOM_EXP
                                     , ERP_ATTR1
                                     , ERP_ATTR2
                                     , ERP_ATTR3
                                     , ERP_ATTR4
                                     , ERP_ATTR5
                                     )
                                SELECT V_NEW_CONFIRM_ID AS CONFIRM_ID
                                     , 'C' AS SHIPMENT_STATUS
                                     , A.DIVISION_ID
                                     , A.PLAN_START_YYYYMMDD
                                     , A.PLAN_TYPE
                                     , A.SEQ
                                     , A.ITEM_ID
                                     , A.FROM_SITE
                                     , A.TO_SITE
                                     , V_NEW_SHIP_DATE AS YYYYMMDD
                                     , 0 AS PLANNED_QTY
                                     , TO_NUMBER(V_NEW_QTY) AS QTY
                                     , V_NEW_BOD_ID AS BOD_ID
                                     , TO_NUMBER(V_NEW_ROUTE_ID) AS ROUTE_ID
                                     , A.BIZ_TYPE
                                     , A.PROJECT_CODE
                                     , A.FCST_TYPE
                                     , A.FCST_ETD_DATE
                                     , A.FCST_ETA_DATE
                                     , V_NEW_ETD_DATE AS ETD_DATE
                                     , V_NEW_ETA_DATE AS ETA_DATE
                                     , V_NEW_INCOTERMS AS INCOTERMS
                                     , V_NEW_TRANSPORT_MODE AS TRANSPORT_MODE
                                     , V_NEW_D_CONTRY AS D_COUNTRY
                                     , V_NEW_D_PORT_CODE AS D_PORT_CODE
                                     , V_NEW_A_COUNTRY AS A_COUNTRY
                                     , V_NEW_A_PORT_CODE AS A_PORT_CODE
                                     , TO_NUMBER(V_NEW_LT_DAY) AS CUSTOMER_LT
                                     , V_NEW_TO_COUNTRY AS TO_COUNTRY
                                     , V_NEW_TO_CITY AS TO_CITY
                                     , A.FROM_SITE_TYPE
                                     , A.FROM_SITE_PLANT_ID
                                     , A.FROM_SITE_VENDOR_ID
                                     , A.FROM_SITE_SOLDTO_CODE
                                     , A.FROM_SITE_SHIPTO_CODE
                                     , A.FROM_SITE_COMPANY_ID
                                     , A.TO_SITE_TYPE
                                     , A.TO_SITE_PLANT_ID
                                     , A.TO_SITE_VENDOR_ID
                                     , A.TO_SITE_SOLDTO_CODE
                                     , A.TO_SITE_SHIPTO_CODE
                                     , A.TO_SITE_COMPANY_ID
                                     , NULL AS CHANGE_REQ_NO
                                     , NULL AS ERP_SO_NO   /*신규 일 경우에는 ERP 4개 컬럼 NULL로 넣어준다.*/
                                     , NULL AS ERP_SO_ITEM_NO
                                     , NULL AS ERP_DO_NO
                                     , NULL AS ERP_STATUS
                                     , 'C'
                                     , P_LAST_UPDATED_BY AS CREATED_BY
                                     , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE*/
                                     , P_LAST_UPDATED_BY AS LAST_UPDATED_BY
                                     , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE*/
                                     , A.ELECTRODE_YN
                                     , A.ELECTRODE_TYPE
                                     , A.ORIGIN_FROM_DIVISION_ID
                                     , A.ORIGIN_TO_DIVISION_ID
                                     , 0 AS BEFORE_QTY
                                     , 'Y' AS CHECK_NEED_YN
                                     , V_REMARKS
                                     , V_REMARKS2
                                     , V_REMARKS3
                                     , A.PACKAGE_TYPE_CODE
                                     , A.FACTORY_ID
                                     , CASE WHEN A.ELECTRODE_YN = 'N' THEN TO_NUMBER(V_NEW_QTY)
                                            ELSE CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                                           WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                                           WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                                           ELSE NULL
                                                      END)
                                       END AS PACKAGE_QTY
                                     , A.DOM_EXP
                                     , V_ERP_ATTR1
                                     , V_ERP_ATTR2
                                     , V_ERP_ATTR3
                                     , A.ERP_ATTR4
                                     , A.ERP_ATTR5
                                  FROM SSP_ANL_SHIP_CONFIRM A
                                     , SSP_MST_SITE_ITEM_EE_V B
                                 WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                                   AND B.SCM_SITE_ID(+) = A.FROM_SITE
                                   AND B.ITEM_ID(+) = A.ITEM_ID
                                   AND A.CONFIRM_ID = V_CONFIRM_ID;
                            END IF;

                            /* SSP0200 에서 사용 시  @p_change_type = 'N' 변경 후 다시 'C' 변경 */
                            /* 2026.10.06 AJS AS-IS 대소문자 무시 비교 반영 - 'c' -> 'C' (START) */
--                          V_CHANGE_TYPE := 'c';
                            V_CHANGE_TYPE := 'C';
                            /* 2026.10.06 AJS AS-IS 대소문자 무시 비교 반영 - 'c' -> 'C' (END) */
                        ELSE
                            /* AS-IS 는 바로 위에서 @p_change_type 을 'N' 으로 바꾸므로 이 갈래에는 닿지 않는다 (원문 구조 보존) */
                            V_PLANNED_QTY := 0;

                            BEGIN
                                SELECT PLANNED_QTY
                                  INTO V_PLANNED_QTY
                                  FROM SSP_ANL_SHIP_CONFIRM
                                 WHERE ATTRIBUTE1 = V_NEW_CONFIRM_ID
                                   AND ROWNUM = 1;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    NULL;
                            END;

                            INSERT INTO SSP_ANL_SHIP_CONFIRM
                                 (
                                   CONFIRM_ID
                                 , SHIPMENT_STATUS
                                 , DIVISION_ID
                                 , PLAN_START_YYYYMMDD
                                 , PLAN_TYPE
                                 , SEQ
                                 , ITEM_ID
                                 , FROM_SITE
                                 , TO_SITE
                                 , YYYYMMDD
                                 , PLANNED_QTY
                                 , QTY
                                 , BOD_ID
                                 , ROUTE_ID
                                 , BIZ_TYPE
                                 , PROJECT_CODE
                                 , FCST_TYPE
                                 , FCST_ETD_DATE
                                 , FCST_ETA_DATE
                                 , ETD_DATE
                                 , ETA_DATE
                                 , INCOTERMS
                                 , TRANSPORT_MODE
                                 , D_COUNTRY
                                 , D_PORT_CODE
                                 , A_COUNTRY
                                 , A_PORT_CODE
                                 , CUSTOMER_LT
                                 , TO_COUNTRY
                                 , TO_CITY
                                 , FROM_SITE_TYPE
                                 , FROM_SITE_PLANT_ID
                                 , FROM_SITE_VENDOR_ID
                                 , FROM_SITE_SOLDTO_CODE
                                 , FROM_SITE_SHIPTO_CODE
                                 , FROM_SITE_COMPANY_ID
                                 , TO_SITE_TYPE
                                 , TO_SITE_PLANT_ID
                                 , TO_SITE_VENDOR_ID
                                 , TO_SITE_SOLDTO_CODE
                                 , TO_SITE_SHIPTO_CODE
                                 , TO_SITE_COMPANY_ID
                                 , CHANGE_REQ_NO
                                 , ERP_SO_NO
                                 , ERP_SO_ITEM_NO
                                 , ERP_DO_NO
                                 , ERP_STATUS
                                 , CHANGE_TYPE
                                 , CREATED_BY
                                 , CREATION_DATE
                                 , LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE
                                 , ELECTRODE_YN
                                 , ELECTRODE_TYPE
                                 , ORIGIN_FROM_DIVISION_ID
                                 , ORIGIN_TO_DIVISION_ID
                                 , BEFORE_QTY
                                 , CHECK_NEED_YN
                                 , REMARKS
                                 , REMARKS2
                                 , REMARKS3
                                 , PACKAGE_TYPE_CODE
                                 , FACTORY_ID
                                 , PACKAGE_QTY
                                 , DOM_EXP
                                 , ERP_ATTR1
                                 , ERP_ATTR2
                                 , ERP_ATTR3
                                 , ERP_ATTR4
                                 , ERP_ATTR5
                                 )
                            SELECT V_NEW_CONFIRM_ID AS CONFIRM_ID
                                 , 'C' AS SHIPMENT_STATUS
                                 , A.DIVISION_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.PLAN_TYPE
                                 , A.SEQ
                                 , A.ITEM_ID
                                 , A.FROM_SITE
                                 , A.TO_SITE
                                 , V_NEW_SHIP_DATE AS YYYYMMDD
                                 , V_PLANNED_QTY AS PLANNED_QTY
                                 , TO_NUMBER(V_NEW_QTY) AS QTY
                                 , V_NEW_BOD_ID AS BOD_ID
                                 , TO_NUMBER(V_NEW_ROUTE_ID) AS ROUTE_ID
                                 , A.BIZ_TYPE
                                 , A.PROJECT_CODE
                                 , A.FCST_TYPE
                                 , A.FCST_ETD_DATE
                                 , A.FCST_ETA_DATE
                                 , V_NEW_ETD_DATE AS ETD_DATE
                                 , V_NEW_ETA_DATE AS ETA_DATE
                                 , V_NEW_INCOTERMS AS INCOTERMS
                                 , V_NEW_TRANSPORT_MODE AS TRANSPORT_MODE
                                 , V_NEW_D_CONTRY AS D_COUNTRY
                                 , V_NEW_D_PORT_CODE AS D_PORT_CODE
                                 , V_NEW_A_COUNTRY AS A_COUNTRY
                                 , V_NEW_A_PORT_CODE AS A_PORT_CODE
                                 , TO_NUMBER(V_NEW_LT_DAY) AS CUSTOMER_LT
                                 , V_NEW_TO_COUNTRY AS TO_COUNTRY
                                 , V_NEW_TO_CITY AS TO_CITY
                                 , A.FROM_SITE_TYPE
                                 , A.FROM_SITE_PLANT_ID
                                 , A.FROM_SITE_VENDOR_ID
                                 , A.FROM_SITE_SOLDTO_CODE
                                 , A.FROM_SITE_SHIPTO_CODE
                                 , A.FROM_SITE_COMPANY_ID
                                 , A.TO_SITE_TYPE
                                 , A.TO_SITE_PLANT_ID
                                 , A.TO_SITE_VENDOR_ID
                                 , A.TO_SITE_SOLDTO_CODE
                                 , A.TO_SITE_SHIPTO_CODE
                                 , A.TO_SITE_COMPANY_ID
                                 , NULL AS CHANGE_REQ_NO
                                 , NULL AS ERP_SO_NO
                                 , NULL AS ERP_SO_ITEM_NO
                                 , NULL AS ERP_DO_NO
                                 , NULL AS ERP_STATUS
                                 , 'C'
                                 , P_LAST_UPDATED_BY AS CREATED_BY
                                 , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE*/
                                 , P_LAST_UPDATED_BY AS LAST_UPDATED_BY
                                 , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE*/
                                 , A.ELECTRODE_YN
                                 , A.ELECTRODE_TYPE
                                 , A.ORIGIN_FROM_DIVISION_ID
                                 , A.ORIGIN_TO_DIVISION_ID
                                 , A.QTY AS BEFORE_QTY
                                 , 'Y' AS CHECK_NEED_YN
                                 , V_REMARKS
                                 , V_REMARKS2
                                 , V_REMARKS3
                                 , A.PACKAGE_TYPE_CODE
                                 , A.FACTORY_ID
                                 , CASE WHEN A.ELECTRODE_YN = 'N' THEN TO_NUMBER(V_NEW_QTY)
                                        ELSE CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                                       WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                                       WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                                       ELSE NULL
                                                  END)
                                   END AS PACKAGE_QTY
                                 , A.DOM_EXP
                                 , A.ERP_ATTR1
                                 , A.ERP_ATTR2
                                 , A.ERP_ATTR3
                                 , A.ERP_ATTR4
                                 , A.ERP_ATTR5
                              FROM SSP_ANL_SHIP_CONFIRM A
                                 , SSP_MST_SITE_ITEM_EE_V B
                             WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                               AND B.SCM_SITE_ID(+) = A.FROM_SITE
                               AND B.ITEM_ID(+) = A.ITEM_ID
                               AND A.ATTRIBUTE1 = V_CONFIRM_ID;

                            UPDATE SSP_ANL_SHIP_CONFIRM
                               SET SHIPMENT_STATUS = 'P'
                                 , CHANGE_REQ_NO = NULL
                                 , QTY = 0
                                 , BEFORE_QTY = QTY
                                 , CHECK_NEED_YN = 'Y'
                                 , LAST_UPDATED_BY = P_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                                 , PACKAGE_QTY = 0
                             WHERE ATTRIBUTE1 = V_NEW_CONFIRM_ID;
                        END IF;
                    ELSE
                        /*SSP_ANL_SHIP_CONFIRM update*/
                        /* AS-IS 40 용에는 본체와 달리 변경 상세와의 내부 조인이 없다 */
                        UPDATE SSP_ANL_SHIP_CONFIRM A
                           SET A.SHIPMENT_STATUS = 'C'
                             , A.CHANGE_REQ_NO = NULL
                             , A.YYYYMMDD = V_NEW_SHIP_DATE
                             , A.QTY = TO_NUMBER(V_NEW_QTY)
                             , A.BOD_ID = V_NEW_BOD_ID
                             , A.ROUTE_ID = TO_NUMBER(V_NEW_ROUTE_ID)
                             , A.INCOTERMS = V_NEW_INCOTERMS
                             , A.D_COUNTRY = V_NEW_D_CONTRY
                             , A.D_PORT_CODE = V_NEW_D_PORT_CODE
                             , A.A_COUNTRY = V_NEW_A_COUNTRY
                             , A.A_PORT_CODE = V_NEW_A_PORT_CODE
                             , A.TO_COUNTRY = V_NEW_TO_COUNTRY
                             , A.TO_CITY = V_NEW_TO_CITY
                             , A.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                             , A.ETD_DATE = V_NEW_ETD_DATE
                             , A.ETA_DATE = V_NEW_ETA_DATE
                             , A.FCST_ETD_DATE = V_NEW_ETD_DATE
                             , A.FCST_ETA_DATE = V_NEW_ETA_DATE
                             , A.CUSTOMER_LT = TO_NUMBER(V_NEW_LT_DAY)
                             , A.BEFORE_QTY = A.QTY
                             , A.CHECK_NEED_YN = 'Y'
                             , A.LAST_UPDATED_BY = P_LAST_UPDATED_BY
                             , A.LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                             , A.REMARKS = V_REMARKS
                             , A.REMARKS2 = V_REMARKS2
                             , A.REMARKS3 = V_REMARKS3
                             /**** 20211018   SHINMYUNGSU   항목추가   ****************/
                             , A.ERP_ATTR1 = V_ERP_ATTR1
                             , A.ERP_ATTR2 = V_ERP_ATTR2
                             , A.ERP_ATTR3 = V_ERP_ATTR3
                             /*********************************************************/
                             , A.PACKAGE_QTY = CASE WHEN A.ELECTRODE_YN = 'N' THEN TO_NUMBER(V_NEW_QTY)
                                                    ELSE (SELECT CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                                                           WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                                                           WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_NEW_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                                                           ELSE NULL
                                                                      END)
                                                            FROM SSP_MST_SITE_ITEM_EE_V B
                                                           WHERE B.DIVISION_ID = A.DIVISION_ID
                                                             AND B.SCM_SITE_ID = A.FROM_SITE
                                                             AND B.ITEM_ID = A.ITEM_ID)
                                               END
                         WHERE A.CONFIRM_ID = V_NEW_CONFIRM_ID;
                    END IF;

                    /*----이력저장*/
                    /*EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_HIST] @p_change_request_no, 'C', @v_new_confirm_id, ... */

                    BEGIN
                        SELECT DIVISION_ID
                             , ITEM_ID
                             , FROM_SITE
                             , TO_SITE
                             , YYYYMMDD
                             , BOD_ID
                             , PROJECT_CODE
                             , FCST_TYPE
                             , INCOTERMS
                             , TRANSPORT_MODE
                             , CONFIRM_ID
                          INTO V_N_DIVISION_ID
                             , V_N_ITEM_ID
                             , V_N_FROM_SITE
                             , V_N_TO_SITE
                             , V_N_YYYYMMDD
                             , V_N_BOD_ID
                             , V_N_PROJECT_CODE
                             , V_N_FCST_TYPE
                             , V_N_INCOTERMS
                             , V_N_TRANSPORT_MODE
                             , V_N_CONFIRM_ID
                          FROM SSP_ANL_SHIP_CONFIRM
                         WHERE CONFIRM_ID = V_NEW_CONFIRM_ID
                           AND ROWNUM = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;

                    /* SSP_ANL_SHIP_PLAN_40 의 데이터 생성 시점이 달라 최신 생성 날짜를 조회한다. */
                    SELECT MAX(PLAN_START_YYYYMMDD)
                         , 1
                      INTO V_PLAN_START_YYYYMMDD
                         , V_SEQ
                      FROM GT_SSP0003_40_STD
                     WHERE DIVISION_ID = V_N_DIVISION_ID
                       AND FROM_SITE = V_N_FROM_SITE;

                    /* 220905 jilee FromSite 제외하고 다시 조회 */
                    IF V_PLAN_START_YYYYMMDD IS NULL THEN
                        SELECT MAX(PLAN_START_YYYYMMDD)
                             , 1
                          INTO V_PLAN_START_YYYYMMDD
                             , V_SEQ
                          FROM GT_SSP0003_40_STD
                         WHERE DIVISION_ID = V_N_DIVISION_ID
                           AND COMPANY_ID IN (SELECT COMPANY_ID
                                                FROM SCM_MST_SITE
                                               WHERE DIVISION_ID = V_N_DIVISION_ID
                                                 AND SCM_SITE_ID = V_N_FROM_SITE);
                    END IF;

                    IF V_CHANGE_TYPE = 'P' THEN
                        SELECT COUNT(*)
                          INTO V_CHK
                          FROM SSP_ANL_SHIP_PLAN_40
                         WHERE DIVISION_ID = V_N_DIVISION_ID
                           AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                           AND PLAN_TYPE = 'SP'
                           AND SEQ = V_SEQ
                           AND ITEM_ID = V_N_ITEM_ID
                           AND FROM_SITE = V_N_FROM_SITE
                           AND TO_SITE = V_N_TO_SITE
                           AND YYYYMMDD = V_N_YYYYMMDD
                           AND MEASURE IN ('SHIP_CONFIRM');

                        /* SSP_ANL_SHIP_PLAN_40 MEASURE SHIP_CONFIRM 이 있을 경우 Delete, Insert */
                        IF V_CHK > 0 THEN
                            DELETE FROM SSP_ANL_SHIP_PLAN_40
                             WHERE DIVISION_ID = V_N_DIVISION_ID
                               AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND PLAN_TYPE = 'SP'
                               AND SEQ = V_SEQ
                               AND ITEM_ID = V_N_ITEM_ID
                               AND FROM_SITE = V_N_FROM_SITE
                               AND TO_SITE = V_N_TO_SITE
                               AND YYYYMMDD = V_N_YYYYMMDD
                               AND MEASURE IN ('SHIP_CONFIRM');
                        END IF;
                    ELSE
                        SELECT COUNT(*)
                          INTO V_CHK
                          FROM SSP_ANL_SHIP_PLAN_40
                         WHERE DIVISION_ID = V_N_DIVISION_ID
                           AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                           AND PLAN_TYPE = 'SP'
                           AND SEQ = V_SEQ
                           AND ITEM_ID = V_N_ITEM_ID
                           AND FROM_SITE = V_N_FROM_SITE
                           AND TO_SITE = V_N_TO_SITE
                           AND YYYYMMDD = V_N_YYYYMMDD
                           AND MEASURE IN ('SHIP_CONFIRM')
                           AND CONFIRM_FLAG = 'Y';   /* Confrim ID가 없는건 삭제하지 않음 */

                        /* SSP_ANL_SHIP_PLAN_40 MEASURE SHIP_CONFIRM 이 있을 경우 Delete, Insert */
                        IF V_CHK > 0 THEN
                            DELETE FROM SSP_ANL_SHIP_PLAN_40
                             WHERE DIVISION_ID = V_N_DIVISION_ID
                               AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND PLAN_TYPE = 'SP'
                               AND SEQ = V_SEQ
                               AND ITEM_ID = V_N_ITEM_ID
                               AND FROM_SITE = V_N_FROM_SITE
                               AND TO_SITE = V_N_TO_SITE
                               AND YYYYMMDD = V_N_YYYYMMDD
                               AND MEASURE IN ('SHIP_CONFIRM')
                               AND CONFIRM_FLAG = 'Y';   /* Confrim ID가 없는건 삭제하지 않음 */
                        END IF;
                    END IF;

                    IF V_CHANGE_TYPE = 'C' THEN   /* Confirm 일 경우에는 날짜가 변경되면 기존것도 지우고 다시 넣는다. */
                        BEGIN
                            SELECT DIVISION_ID
                                 , ITEM_ID
                                 , FROM_SITE
                                 , TO_SITE
                                 , YYYYMMDD
                                 , BOD_ID
                                 , PROJECT_CODE
                                 , FCST_TYPE
                                 , INCOTERMS
                                 , TRANSPORT_MODE
                                 , CONFIRM_ID
                              INTO V_N_ORI_DIVISION_ID
                                 , V_N_ORI_ITEM_ID
                                 , V_N_ORI_FROM_SITE
                                 , V_N_ORI_TO_SITE
                                 , V_N_ORI_YYYYMMDD
                                 , V_N_ORI_BOD_ID
                                 , V_N_ORI_PROJECT_CODE
                                 , V_N_ORI_FCST_TYPE
                                 , V_N_ORI_INCOTERMS
                                 , V_N_ORI_TRANSPORT_MODE
                                 , V_N_ORI_CONFIRM_ID
                              FROM (SELECT DIVISION_ID
                                         , ITEM_ID
                                         , FROM_SITE
                                         , TO_SITE
                                         , YYYYMMDD
                                         , BOD_ID
                                         , PROJECT_CODE
                                         , FCST_TYPE
                                         , INCOTERMS
                                         , TRANSPORT_MODE
                                         , CONFIRM_ID
                                      FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                     WHERE CONFIRM_ID = V_NEW_CONFIRM_ID
                                       AND VALID_YN = 'Y'
                                     ORDER BY LAST_UPDATE_DATE DESC NULLS LAST)
                             WHERE ROWNUM = 1;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                NULL;
                        END;

                        V_CHK := 0;

                        SELECT COUNT(*)
                          INTO V_CHK
                          FROM SSP_ANL_SHIP_PLAN_40
                         WHERE DIVISION_ID = V_N_ORI_DIVISION_ID
                           AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                           AND PLAN_TYPE = 'SP'
                           AND SEQ = V_SEQ
                           AND ITEM_ID = V_N_ORI_ITEM_ID
                           AND FROM_SITE = V_N_ORI_FROM_SITE
                           AND TO_SITE = V_N_ORI_TO_SITE
                           AND YYYYMMDD = V_N_ORI_YYYYMMDD
                           AND MEASURE IN ('SHIP_CONFIRM')
                           AND CONFIRM_FLAG = 'Y';   /* Confrim ID가 없는건 삭제하지 않음 */

                        IF V_CHK > 0 AND V_N_YYYYMMDD <> V_N_ORI_YYYYMMDD THEN
                            DELETE FROM SSP_ANL_SHIP_PLAN_40
                             WHERE DIVISION_ID = V_N_ORI_DIVISION_ID
                               AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND PLAN_TYPE = 'SP'
                               AND SEQ = V_SEQ
                               AND ITEM_ID = V_N_ORI_ITEM_ID
                               AND FROM_SITE = V_N_ORI_FROM_SITE
                               AND TO_SITE = V_N_ORI_TO_SITE
                               AND YYYYMMDD = V_N_ORI_YYYYMMDD
                               AND MEASURE IN ('SHIP_CONFIRM')
                               AND CONFIRM_FLAG = 'Y';   /* Confrim ID가 없는건 삭제하지 않음 */

                            INSERT INTO SSP_ANL_SHIP_PLAN_40
                                 (
                                   DIVISION_ID
                                 , PLAN_START_YYYYMMDD
                                 , PLAN_TYPE
                                 , SEQ
                                 , ITEM_ID
                                 , FROM_SITE
                                 , TO_SITE
                                 , MEASURE
                                 , YYYYMMDD
                                 , BOD_ID
                                 , QTY
                                 , ROUTE_ID
                                 , INCOTERMS
                                 , TRANSPORT_MODE
                                 , BIZ_TYPE
                                 , PROJECT_CODE
                                 , FCST_TYPE
                                 , FCST_ETD_DATE
                                 , FCST_ETA_DATE
                                 , ETD_DATE
                                 , ETA_DATE
                                 , CONFIRM_FLAG
                                 , CONFIRM_ID
                                 , CREATED_BY
                                 , CREATION_DATE
                                 , LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE
                                 , ELECTRODE_YN
                                 , ELECTRODE_TYPE
                                 , ORIGIN_FROM_DIVISION_ID
                                 , ORIGIN_TO_DIVISION_ID
                                 )
                            SELECT DIVISION_ID
                                 , V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                                 , PLAN_TYPE
                                 , V_SEQ AS SEQ
                                 , ITEM_ID
                                 , FROM_SITE
                                 , TO_SITE
                                 , 'SHIP_CONFIRM' AS MEASURE
                                 , YYYYMMDD
                                 , BOD_ID
                                 , QTY
                                 , ROUTE_ID
                                 , INCOTERMS
                                 , TRANSPORT_MODE
                                 , BIZ_TYPE
                                 , PROJECT_CODE
                                 , FCST_TYPE
                                 , FCST_ETD_DATE
                                 , FCST_ETA_DATE
                                 , ETD_DATE
                                 , ETA_DATE
                                 , 'Y' AS CONFIRM_FLAG
                                 , CONFIRM_ID
                                 , P_LAST_UPDATED_BY AS CREATED_BY
                                 , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE*/
                                 , P_LAST_UPDATED_BY AS LAST_UPDATED_BY
                                 , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE*/
                                 , ELECTRODE_YN
                                 , ELECTRODE_TYPE
                                 , ORIGIN_FROM_DIVISION_ID
                                 , ORIGIN_TO_DIVISION_ID
                              FROM SSP_ANL_SHIP_CONFIRM
                             WHERE CONFIRM_ID IN (SELECT CONFIRM_ID
                                                    FROM SSP_ANL_SHIP_CONFIRM
                                                   WHERE DIVISION_ID = V_N_ORI_DIVISION_ID
                                                     AND ITEM_ID = V_N_ORI_ITEM_ID
                                                     AND FROM_SITE = V_N_ORI_FROM_SITE
                                                     AND TO_SITE = V_N_ORI_TO_SITE
                                                     AND YYYYMMDD = V_N_ORI_YYYYMMDD
                                                     AND CHANGE_TYPE = 'C'
                                                     AND NVL(ELECTRODE_YN, '-') <> 'Y');
                        END IF;
                    END IF;

                    INSERT INTO SSP_ANL_SHIP_PLAN_40
                         (
                           DIVISION_ID
                         , PLAN_START_YYYYMMDD
                         , PLAN_TYPE
                         , SEQ
                         , ITEM_ID
                         , FROM_SITE
                         , TO_SITE
                         , MEASURE
                         , YYYYMMDD
                         , BOD_ID
                         , QTY
                         , ROUTE_ID
                         , INCOTERMS
                         , TRANSPORT_MODE
                         , BIZ_TYPE
                         , PROJECT_CODE
                         , FCST_TYPE
                         , FCST_ETD_DATE
                         , FCST_ETA_DATE
                         , ETD_DATE
                         , ETA_DATE
                         , CONFIRM_FLAG
                         , CONFIRM_ID
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , ELECTRODE_YN
                         , ELECTRODE_TYPE
                         , ORIGIN_FROM_DIVISION_ID
                         , ORIGIN_TO_DIVISION_ID
                         )
                    SELECT DIVISION_ID
                         , V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                         , PLAN_TYPE
                         , V_SEQ AS SEQ
                         , ITEM_ID
                         , FROM_SITE
                         , TO_SITE
                         , 'SHIP_CONFIRM' AS MEASURE
                         , YYYYMMDD
                         , BOD_ID
                         , QTY
                         , ROUTE_ID
                         , INCOTERMS
                         , TRANSPORT_MODE
                         , BIZ_TYPE
                         , PROJECT_CODE
                         , FCST_TYPE
                         , FCST_ETD_DATE
                         , FCST_ETA_DATE
                         , ETD_DATE
                         , ETA_DATE
                         , 'Y' AS CONFIRM_FLAG
                         , CONFIRM_ID
                         , P_LAST_UPDATED_BY AS CREATED_BY
                         , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) CREATION_DATE*/
                         , P_LAST_UPDATED_BY AS LAST_UPDATED_BY
                         , V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone) LAST_UPDATE_DATE*/
                         , ELECTRODE_YN
                         , ELECTRODE_TYPE
                         , ORIGIN_FROM_DIVISION_ID
                         , ORIGIN_TO_DIVISION_ID
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID IN (SELECT CONFIRM_ID
                                            FROM SSP_ANL_SHIP_CONFIRM
                                           WHERE DIVISION_ID = V_N_DIVISION_ID
                                             AND ITEM_ID = V_N_ITEM_ID
                                             AND FROM_SITE = V_N_FROM_SITE
                                             AND TO_SITE = V_N_TO_SITE
                                             AND YYYYMMDD = V_NEW_SHIP_DATE
                                             AND CHANGE_TYPE = 'C'
                                             AND NVL(ELECTRODE_YN, '-') <> 'Y');
                END IF;   /*end of @mst_loop_cnt > 0 */
            END LOOP;   /*end of while loop*/

            /*이력저장*/
            PR_SSP_ANL_SHIP_CONFIRM_HIST(P_CHANGE_REQUEST_NO, P_LAST_UPDATED_BY, P_TIME_ZONE);
        ELSE
            IF V_CHANGE_TYPE = 'C' THEN
                /*SSP_ANL_SHIP_CONFIRM update*/
                UPDATE SSP_ANL_SHIP_CONFIRM
                   SET SHIPMENT_STATUS = 'C'
                     , CHANGE_REQ_NO = NULL
                     , ATTRIBUTE1 = NULL
                     , LAST_UPDATED_BY = P_LAST_UPDATED_BY
                     , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                 WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;
            ELSE
                /*SSP_ANL_SHIP_CONFIRM update*/
                UPDATE SSP_ANL_SHIP_CONFIRM
                   SET SHIPMENT_STATUS = 'P'
                     , CHANGE_REQ_NO = NULL
                     , ATTRIBUTE1 = NULL
                     , LAST_UPDATED_BY = P_LAST_UPDATED_BY
                     , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE   /*[dbo].[FN_MULTY_TIME](@p_time_zone)*/
                 WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;
            END IF;
        END IF;

        IF V_CHANGE_STATUS = 'A' THEN   /*변경확정*/
            BEGIN
                SELECT YYYYMMDD
                  INTO V_YYYYMMDD
                  FROM (SELECT CASE WHEN YYYYMMDD > NEW_YYYYMMDD THEN NEW_YYYYMMDD ELSE YYYYMMDD END AS YYYYMMDD
                          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO
                         ORDER BY YYYYMMDD
                                , NEW_YYYYMMDD)
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

            /*메일 발송*/
            SCM_SSP_MAIL_SEND(P_CHANGE_REQUEST_NO, V_CHANGE_STATUS);
        ELSE   /*변경 Reject*/
            /*메일 발송*/
            SCM_SSP_MAIL_SEND(P_CHANGE_REQUEST_NO, V_CHANGE_STATUS);
        END IF;

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE := SYSDATE;

        /* 변경 확정시에만 호출 하도록 변경 */
        IF V_CHANGE_STATUS = 'A' THEN
            PR_DM_SSP_CONFIRM_SYNC(P_DIVISION_ID, P_NEW_CONFIRM_ID);
        END IF;

        DELETE FROM GT_SSP0003_40_STD;

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
            SELECT 'S'       AS RESULT_CODE
                 , '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SUBSTR(SQLERRM, 1, 4000);

--          ROLLBACK TO SAVEPOINT SP_SSP0003_SAVE40;    --  2026.10.16 AJS
-- 2026.10.16 AJS 하위 프로그램이 안에서 확정해 저장점이 없으면(ORA-01086) 남은 변경만 되돌리고 오류 결과를 돌려준다 (START)
            BEGIN
                ROLLBACK TO SAVEPOINT SP_SSP0003_SAVE40;
            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK;
            END;
-- 2026.10.16 AJS 하위 프로그램이 안에서 확정해 저장점이 없으면(ORA-01086) 남은 변경만 되돌리고 오류 결과를 돌려준다 (END)

            P_LOG_ERROR(V_PROGRAM_NAME, V_ERR_MESSAGE);

            /* error코드, errror 메시지 반환 */
            OPEN O_RESULT_CURSOR FOR
                SELECT 'F'                                       AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                     , '-1'                                      AS CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS MSG
                  FROM DUAL;
    END P_SSP0003_SAVE_REQ_CONFIRM_40;

    /* ==============================================================================================
       SCM_SSP_MODEL_USER_MAIL_SEND (이 화면만 호출해 패키지에 편입)
       ============================================================================================== */
    PROCEDURE P_SSP0003_MODEL_USER_MAIL
    (
        P_REQUEST_NO        IN  VARCHAR2,
        P_REQUEST_STATUS    IN  VARCHAR2,
        P_DIVISION_ID       IN  VARCHAR2,
        P_FROM_SITE         IN  VARCHAR2,
        P_ITEM_ID           IN  VARCHAR2
    )
    IS
    /*
     * Program ID   : SCM_SSP_MODEL_USER_MAIL_SEND
     * Description  : SSP 모델 PIC 추가 사용자 MAIL 발송
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2023/01/25   jilee   Initial Release SSP_MST_MODEL_USER 등록된 추가 사용자 메일 발송

     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.27   AJS          동일 본문 수신자 ; 묶음 발송
     */
        V_TO_MAIL               VARCHAR2(4000 CHAR);
        V_CATEGORY_ID           NUMBER := 0;
        -- 2026.10.27 AJS 수신자 ; 묶음 발송용 (상한 4000 = PKG_SEND_MAIL 수신자 인자 길이)
        C_TO_MAIL_MAX           CONSTANT PLS_INTEGER := 4000;
        TYPE T_ADDR_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;
        V_ADDR_SLOT             T_ADDR_TAB;
        V_SLOT_CNT              PLS_INTEGER := 0;
        V_MAIL_TITLE            VARCHAR2(4000 CHAR);
        V_BODY_CONTENTS         VARCHAR2(32767 CHAR);
        V_BODY_CONTENTS_SH      VARCHAR2(4000 CHAR);

        V_BODY_TEXT             VARCHAR2(32767 CHAR);
        V_HEAD_CONT             VARCHAR2(32767 CHAR);
        V_A_BODY_CONTENTS       VARCHAR2(32767 CHAR);
        V_TABLE_BODY            VARCHAR2(32767 CHAR);
        V_HTML_YN               VARCHAR2(1 CHAR);

        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SCM_SSP_MODEL_USER_MAIL_SEND';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        V_N_LOG_COUNT           PLS_INTEGER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        V_EVENT_DATE            DATE;

        /*계산용 변수*/
        V_CHK                   PLS_INTEGER := 0;   /* 쿼리결과 총 건수 */
        V_MAIL_CHK_CNT          PLS_INTEGER := 0;

        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_MODEL_USER_ATTRIBUTE  VARCHAR2(32767 CHAR);
        V_MODEL_USER            VARCHAR2(50 CHAR);

        V_T_MODEL_USER          T_TOKEN_TAB;
        V_F                     T_FOUND_TAB;

        /* AS-IS #TblSSPApprovedMailSend2 — 한 번 읽어 순서대로 쓰므로 컬렉션으로 옮긴다 */
        TYPE T_MAIL_REC IS RECORD
        (
            DIVISION_ID             VARCHAR2(4000 CHAR)
          , ITEM_ID                 VARCHAR2(4000 CHAR)
          , NICK_NAME               VARCHAR2(4000 CHAR)
          , FROM_SITE               VARCHAR2(4000 CHAR)
          , FROM_SITE_DESCRIPTION   VARCHAR2(4000 CHAR)
          , TO_SITE                 VARCHAR2(4000 CHAR)
          , TO_SITE_DESCRIPTION     VARCHAR2(4000 CHAR)
          , MTK_OWNER               VARCHAR2(4000 CHAR)
          , INCOTERMS               VARCHAR2(4000 CHAR)
          , YYYYMMDD                VARCHAR2(4000 CHAR)
          , QTY                     VARCHAR2(4000 CHAR)
          , TRANSPORT_MODE          VARCHAR2(4000 CHAR)
          , NEW_YYYYMMDD            VARCHAR2(4000 CHAR)
          , NEW_QTY                 VARCHAR2(4000 CHAR)
          , NEW_TRANSPORT_MODE      VARCHAR2(4000 CHAR)
          , LAST_UPDATE_DATE        VARCHAR2(4000 CHAR)
          , LAST_UPDATED_BY         VARCHAR2(4000 CHAR)
        );
        TYPE T_MAIL_TAB IS TABLE OF T_MAIL_REC INDEX BY PLS_INTEGER;
        V_MAIL                  T_MAIL_TAB;
    BEGIN

        /*추가 메일 발송자 조회 : 수신자 갯수 확정시 추가 조건 넣기*/
        BEGIN
            SELECT NVL(ATTRIBUTE1, 'X') || C_DELIMITER || NVL(ATTRIBUTE2, 'X') || C_DELIMITER || NVL(ATTRIBUTE3, 'X')
                   || C_DELIMITER || NVL(ATTRIBUTE4, 'X') || C_DELIMITER || NVL(ATTRIBUTE5, 'X')
              INTO V_MODEL_USER_ATTRIBUTE
              FROM SSP_MST_MODEL_USER
             WHERE DIVISION_ID = P_DIVISION_ID
               AND FROM_SITE = P_FROM_SITE
               AND ITEM_ID = P_ITEM_ID
               AND VALID_YN = 'Y'
               AND ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_MODEL_USER_ATTRIBUTE := NULL;
        END;

        /*IF @p_request_status = 'Q' --출하 계획 요청*/
        /*	BEGIN*/
        /*		SET @v_category_id = 14*/
        /*	END*/
        /*ELSE IF @p_request_status = 'A' --출하 계획 승인*/
        V_CATEGORY_ID := 15;

        BEGIN
            SELECT MAIL_TITLE
                 , BODY_CONTENTS
              INTO V_MAIL_TITLE
                 , V_BODY_CONTENTS
              FROM (SELECT A.MAIL_TITLE || '[' || A.CHANGE_REQ_NO || ']' AS MAIL_TITLE
                         , A.BODY_CONTENTS
                      FROM (SELECT IA.CHANGE_REQ_NO
                                 , IA.CHANGE_REQ_STATUS
                                 , XA.MAIL_TITLE
                                 , XA.BODY_CONTENTS
                              FROM (SELECT A.CHANGE_REQ_NO
                                         , A.CHANGE_REQ_STATUS
                                         , 'KO' AS LANGUAGE
                                      FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ A
                                         , SCM_ADM_USER_M B
                                     WHERE B.USER_ID = A.REQUEST_USER
                                       AND B.USE_YN = 'Y') IA
                                 , (SELECT B.LANGUAGE_CODE
                                         , B.MAIL_TITLE
                                         , CASE A.USE_TYPE_CODE WHEN 'MAIL' THEN REPLACE(B.MESSAGE_CONTENT, CHR(10), '<br><br>')
                                                                WHEN 'SMS' THEN B.MESSAGE_CONTENT
                                           END AS BODY_CONTENTS
                                      FROM SCM_ADM_RECIPIENT_LIST A
                                         , SCM_ADM_RECIPIENT_MESSAGE B
                                         , SCM_ADM_RECIPIENT_ASSIGN C
                                         , SCM_ADM_LOOKUP_MASTER_DETAIL D
                                         , SCM_ADM_USER_M E
                                     WHERE B.CATEGORY_ID = A.CATEGORY_ID
                                       AND C.CATEGORY_ID(+) = B.CATEGORY_ID
                                       AND D.SEGMENT1 = B.LANGUAGE_CODE
                                       AND D.LOOKUP_TYPE = 'MAIL_HEADER_FOOT'
                                       AND D.VALID_YN = 'Y'
                                       AND E.LANG_CD(+) = B.LANGUAGE_CODE
                                       AND E.USER_ID(+) = C.USER_ID
                                       AND A.CATEGORY_ID = TO_CHAR(V_CATEGORY_ID)
                                       AND A.VALID_YN = 'Y') XA
                             WHERE IA.LANGUAGE = XA.LANGUAGE_CODE) A
                     WHERE A.CHANGE_REQ_NO = P_REQUEST_NO
                       AND A.CHANGE_REQ_STATUS = P_REQUEST_STATUS)
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_MAIL_TITLE := NULL;
                V_BODY_CONTENTS := NULL;
        END;

        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.NICK_NAME
             , A.FROM_SITE
             , A.FROM_SITE_DESCRIPTION
             , A.TO_SITE
             , A.TO_SITE_DESCRIPTION
             , A.MTK_OWNER
             , A.INCOTERMS
             , A.YYYYMMDD
             , A.QTY
             , A.TRANSPORT_MODE
             , A.NEW_YYYYMMDD
             , A.NEW_QTY
             , A.NEW_TRANSPORT_MODE
             , A.LAST_UPDATE_DATE
             , A.LAST_UPDATED_BY
          BULK COLLECT INTO V_MAIL
          FROM (SELECT IA.DIVISION_ID
                     , IA.ITEM_ID
                     , IA.NICK_NAME
                     , IA.FROM_SITE
                     , IA.FROM_SITE_DESCRIPTION
                     , IA.TO_SITE
                     , IA.TO_SITE_DESCRIPTION
                     , IA.MTK_OWNER
                     , IA.INCOTERMS
                     , IA.YYYYMMDD
                     , IA.QTY
                     , IA.TRANSPORT_MODE
                     , IA.NEW_YYYYMMDD
                     , IA.NEW_QTY
                     , IA.NEW_TRANSPORT_MODE
                     , TO_CHAR(IA.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS') || '.000' AS LAST_UPDATE_DATE
                     , CASE WHEN FN_GET_USER_NAME(IA.LAST_UPDATED_BY) IS NULL OR IA.LAST_UPDATED_BY IS NULL THEN NULL
                            ELSE FN_GET_USER_NAME(IA.LAST_UPDATED_BY) || '(' || IA.LAST_UPDATED_BY || ')'
                       END AS LAST_UPDATED_BY
                  FROM (SELECT B.DIVISION_ID
                             , B.ITEM_ID
                             , FN_GET_ITEM_NICKNAME(B.DIVISION_ID, B.ITEM_ID) AS NICK_NAME
                             , B.FROM_SITE
                             , FN_GET_SCM_SITE_DESCRIPTION(B.DIVISION_ID, B.FROM_SITE) AS FROM_SITE_DESCRIPTION
                             , B.TO_SITE
                             , FN_GET_SCM_SITE_DESCRIPTION(B.DIVISION_ID, B.TO_SITE) AS TO_SITE_DESCRIPTION
                             /* 담당자 이름 목록은 CLOB 으로 돌아와 GROUP BY 에 쓸 수 없다 — 문자형으로 바꾼다 */
                             , DBMS_LOB.SUBSTR(FN_GET_SSP_MKT_OWNER_NAME(C.OWNER, ',', 'KO'), 4000, 1) AS MTK_OWNER
                             , B.INCOTERMS
                             , SUBSTR(B.YYYYMMDD, 1, 4) || '-' || SUBSTR(B.YYYYMMDD, 5, 2) || '-' || SUBSTR(B.YYYYMMDD, 7, 2) AS YYYYMMDD
                             , NVL(REPLACE(TRIM(TO_CHAR(B.QTY, 'FM999,999,999,999,990.00')), '.00', ''), '') AS QTY
                             , B.TRANSPORT_MODE
                             , SUBSTR(B.NEW_YYYYMMDD, 1, 4) || '-' || SUBSTR(B.NEW_YYYYMMDD, 5, 2) || '-' || SUBSTR(B.NEW_YYYYMMDD, 7, 2) AS NEW_YYYYMMDD
                             , NVL(REPLACE(TRIM(TO_CHAR(B.NEW_QTY, 'FM999,999,999,999,990.00')), '.00', ''), '') AS NEW_QTY
                             , B.NEW_TRANSPORT_MODE
                             , CASE WHEN P_REQUEST_STATUS = 'A' THEN A.APPROVAL_TIME
                                    WHEN P_REQUEST_STATUS = 'R' THEN A.APPROVAL_TIME
                                    ELSE A.LAST_UPDATE_DATE
                               END AS LAST_UPDATE_DATE
                             , CASE WHEN P_REQUEST_STATUS = 'A' THEN CASE WHEN A.DELEGATEE_USER IS NULL THEN A.APPROVAL_USER ELSE A.DELEGATEE_USER END
                                    WHEN P_REQUEST_STATUS = 'R' THEN CASE WHEN A.DELEGATEE_USER IS NULL THEN A.APPROVAL_USER ELSE A.DELEGATEE_USER END
                                    ELSE A.LAST_UPDATED_BY
                               END AS LAST_UPDATED_BY
                          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ A
                             , SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE B
                             , SCM_MST_SITE_ITEM C
                         WHERE B.CHANGE_REQ_NO = A.CHANGE_REQ_NO
                           AND B.VALID_YN = 'Y'
                           AND C.DIVISION_ID(+) = CASE WHEN B.DIVISION_ID = 'EE' THEN B.ORIGIN_TO_DIVISION_ID ELSE B.DIVISION_ID END
                           AND C.SCM_SITE_ID(+) = B.TO_SITE
                           AND C.ITEM_ID(+) = B.ITEM_ID
                           AND C.PROJECT_CODE(+) = B.PROJECT_CODE
                           AND A.CHANGE_REQ_STATUS = P_REQUEST_STATUS
                           AND A.CHANGE_REQ_NO = P_REQUEST_NO) IA
                 GROUP BY IA.DIVISION_ID
                        , IA.ITEM_ID
                        , IA.NICK_NAME
                        , IA.FROM_SITE
                        , IA.FROM_SITE_DESCRIPTION
                        , IA.TO_SITE
                        , IA.TO_SITE_DESCRIPTION
                        , IA.MTK_OWNER
                        , IA.INCOTERMS
                        , IA.YYYYMMDD
                        , IA.QTY
                        , IA.TRANSPORT_MODE
                        , IA.NEW_YYYYMMDD
                        , IA.NEW_QTY
                        , IA.NEW_TRANSPORT_MODE
                        , IA.LAST_UPDATE_DATE
                        , IA.LAST_UPDATED_BY
                 ORDER BY IA.DIVISION_ID
                        , IA.ITEM_ID
                        , IA.FROM_SITE
                        , IA.TO_SITE
                        , IA.YYYYMMDD
                        , IA.TRANSPORT_MODE) A;

        V_CHK := V_MAIL.COUNT;

        V_HEAD_CONT := '';
        V_HEAD_CONT := V_HEAD_CONT || '<tr>';
        V_HEAD_CONT := V_HEAD_CONT || '<th rowspan=''2''>' || 'Div' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th rowspan=''2''>' || 'Model' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th rowspan=''2''>' || 'Nick Name' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th rowspan=''2''>' || 'From Site' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th rowspan=''2''>' || 'To Site' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th rowspan=''2''>' || 'MKT Owner' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th rowspan=''2''>' || 'Incoterms' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th colspan=''3''>' || 'Old' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th colspan=''3''>' || 'New' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '</tr>';
        V_HEAD_CONT := V_HEAD_CONT || '<tr>';
        V_HEAD_CONT := V_HEAD_CONT || '<th width=''90px''>' || 'Shipment Date' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th width=''90px''>' || 'Shipment Qty' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th width=''80px''>' || 'Trans Mode' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th width=''90px''>' || 'Shipment Date' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th width=''90px''>' || 'Shipment Qty' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '<th width=''80px''>' || 'Trans Mode' || '</th>';
        V_HEAD_CONT := V_HEAD_CONT || '</tr>';

        V_A_BODY_CONTENTS := '';
        V_BODY_TEXT := '';

        V_MAIL_CHK_CNT := 1;   /* 한 행 FETCH시 마다 +1 */

        WHILE V_MAIL_CHK_CNT <= V_CHK + 1 LOOP
            IF V_MAIL_CHK_CNT = 1 AND V_MAIL.EXISTS(1) THEN
                V_BODY_TEXT := V_BODY_TEXT || 'Last updated by : ' || V_MAIL(1).LAST_UPDATED_BY
                                           || '    Last update Date : ' || V_MAIL(1).LAST_UPDATE_DATE || '</br>';
            END IF;

            IF V_MAIL_CHK_CNT = V_CHK + 1 THEN
                V_TABLE_BODY := '';
                V_TABLE_BODY := ' <html>
                        <head>
                        <title>Untitled Document</title>
                        <style>
                          * {margin:0;padding:0;}
                          body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
                          table {border-collapse:collapse;width:100%;}
                          table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
                          table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
                          table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
                          table tbody td {padding:6px 8px;font-size:12px}
                          table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
                          .hori-table table thead td {text-align:center;padding:3px;}
                          .hori-table table tbody td {text-align:center;padding:3px;}
                          .vertical-table, .hori-table {margin-bottom:20px;}
                        </style>
                        </head>
                        <body>' || '</br>'
                    || '<b>' || REPLACE(NVL(V_BODY_CONTENTS, ''), CHR(10), '<br>') || '</b>' || '</br>' || '</br>'
                    || '<b>' || REPLACE(NVL(V_BODY_TEXT, ''), CHR(10), '<br>') || '</b>'
                    || '<table style=''border-top:2px solid #c8294b; width:1200px;''>
                          <thead>' || NVL(V_HEAD_CONT, '') || '</thead>
                          <tbody>' || NVL(V_A_BODY_CONTENTS, '') || '</tbody>
                          </div>
                        </body>
                    </html>';

                EXIT;
            END IF;

            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<tr>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).DIVISION_ID, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).ITEM_ID, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).NICK_NAME, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).FROM_SITE_DESCRIPTION, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).TO_SITE_DESCRIPTION, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).MTK_OWNER, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).INCOTERMS, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td align=''center''>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).YYYYMMDD, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td align=''right''>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).QTY, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).TRANSPORT_MODE, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td align=''center''>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).NEW_YYYYMMDD, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td align=''right''>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).NEW_QTY, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '<td>' || REPLACE(NVL(V_MAIL(V_MAIL_CHK_CNT).NEW_TRANSPORT_MODE, ''), CHR(10), ' ') || '</td>';
            V_A_BODY_CONTENTS := V_A_BODY_CONTENTS || '</tr>';

            V_MAIL_CHK_CNT := V_MAIL_CHK_CNT + 1;
        END LOOP;

        BEGIN
            V_LOG_TYPE := 'START';
            V_LOG_MESSAGE := '########## Start of procedure ##########';
            V_DESCRIPTION := '';
            V_EVENT_DATE := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

            V_BODY_CONTENTS := V_TABLE_BODY;
            V_HTML_YN := 'Y';

            V_MAX_LOOP_CNT := F_SPL_CNT(V_MODEL_USER_ATTRIBUTE);
            P_SPL_ARR(V_MODEL_USER_ATTRIBUTE, V_MAX_LOOP_CNT, V_T_MODEL_USER, V_F);

            WHILE LENGTH(RTRIM(V_MODEL_USER_ATTRIBUTE)) IS NOT NULL
              AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                IF LENGTH(RTRIM(V_BODY_CONTENTS)) > 100 AND V_MST_LOOP_CNT = 1 THEN
                    V_BODY_CONTENTS_SH := SUBSTR(V_BODY_CONTENTS, 1, 100);
                END IF;

                V_MODEL_USER := V_T_MODEL_USER(V_MST_LOOP_CNT);

                IF V_MODEL_USER <> 'X' AND V_MODEL_USER IS NOT NULL THEN
                    V_TO_MAIL := V_MODEL_USER || '@lgensol.com';

                    -- 2026.10.27 AJS 본문이 수신자와 무관하게 같아 수신자를 ; 로 묶는다 · 4000바이트 초과 시 다음 묶음 (START)
--                    SCM_ADM_MAIL_SEND(V_TO_MAIL, V_MAIL_TITLE, V_BODY_CONTENTS, V_HTML_YN);
--
--                    SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG('MAIL'
--                                                   , V_CATEGORY_ID
--                                                   , V_MAIL_TITLE
--                                                   , V_BODY_CONTENTS_SH
--                                                   , 'Add Mail User'
--                                                   , ''
--                                                   , ''
--                                                   , ''
--                                                   , ''
--                                                   , ''
--                                                   , ''
--                                                   , ''
--                                                   , ''   /*p_send_pgm*/
--                                                   , V_TO_MAIL);
                    IF V_SLOT_CNT = 0
                       OR LENGTHB(V_ADDR_SLOT(V_SLOT_CNT) || ';' || V_TO_MAIL) > C_TO_MAIL_MAX THEN
                        V_SLOT_CNT := V_SLOT_CNT + 1;
                        V_ADDR_SLOT(V_SLOT_CNT) := V_TO_MAIL;
                    ELSE
                        V_ADDR_SLOT(V_SLOT_CNT) := V_ADDR_SLOT(V_SLOT_CNT) || ';' || V_TO_MAIL;
                    END IF;
                    -- 2026.10.27 AJS 본문이 수신자와 무관하게 같아 수신자를 ; 로 묶는다 (END)
                END IF;
            END LOOP;   /* While Loop End */

            -- 2026.10.27 AJS 묶음 단위 발송 · 로그 수신자 100자 (START)
            FOR I IN 1 .. V_SLOT_CNT LOOP
                SCM_ADM_MAIL_SEND(V_ADDR_SLOT(I), V_MAIL_TITLE, V_BODY_CONTENTS, V_HTML_YN);

                SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG('MAIL'
                                               , V_CATEGORY_ID
                                               , V_MAIL_TITLE
                                               , V_BODY_CONTENTS_SH
                                               , 'Add Mail User'
                                               , ''
                                               , ''
                                               , ''
                                               , ''
                                               , ''
                                               , ''
                                               , ''
                                               , ''   /*p_send_pgm*/
                                               , SUBSTR(V_ADDR_SLOT(I), 1, 100));
            END LOOP;
            -- 2026.10.27 AJS 묶음 단위 발송 · 로그 수신자 100자 (END)

            V_LOG_TYPE := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := '';
            V_EVENT_DATE := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);
        EXCEPTION
            WHEN OTHERS THEN
                P_LOG_ERROR(V_PROGRAM_NAME, SUBSTR(SQLERRM, 1, 4000));
        END;

    END P_SSP0003_MODEL_USER_MAIL;

    --  2026.10.21 AJS 공용 ERP 오류 처리 프로시저 래퍼 (START)
    /* ============================================================
       P_SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM
       공용 독립 프로시저 SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM 호출(CNS 전환가이드 「패키지 바디 생성(독립 프로시저 호출)」)
       ============================================================ */
    PROCEDURE P_SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM
    (
        P_CHANGE_REQUEST_NO     IN  VARCHAR2,
        P_CONFIRM_ID            IN  VARCHAR2,
        P_E_TYPE                IN  VARCHAR2,
        P_E_MESSAGE             IN  VARCHAR2,
        P_LAST_UPDATED_BY       IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0003.P_SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM
         * Description  : SSP ERP 에러 반환시 정보 저장
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2026.10.21   AJS            공용 독립 프로시저 SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM 호출 래퍼 추가
         */
    BEGIN
        SCM_MGR.SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM
        (
            P_CHANGE_REQUEST_NO => P_CHANGE_REQUEST_NO,
            P_CONFIRM_ID        => P_CONFIRM_ID,
            P_E_TYPE            => P_E_TYPE,
            P_E_MESSAGE         => P_E_MESSAGE,
            P_LAST_UPDATED_BY   => P_LAST_UPDATED_BY,
            O_RC1               => O_RC1,
            O_RC2               => O_RC2
        );
    END P_SCM_SSP_ANL_SHIP_ERP_ERROR_CONFIRM;

    /* ============================================================
       P_SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM
       공용 독립 프로시저 SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM 호출(CNS 전환가이드 「패키지 바디 생성(독립 프로시저 호출)」)
       ============================================================ */
    PROCEDURE P_SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM
    (
        P_CONFIRM_ID            IN  VARCHAR2,
        P_CHANGE_REQUEST_NO     IN  VARCHAR2,
        P_DEL_FLAG              IN  VARCHAR2 DEFAULT 'D',
        P_LAST_UPDATED_BY       IN  VARCHAR2,
        P_TIME_ZONE             IN  VARCHAR2,
        P_IF_SEND_FLAG          IN  VARCHAR2 DEFAULT 'Y',
        P_CHANGE_TYPE           IN  VARCHAR2 DEFAULT 'C',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0003.P_SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM
         * Description  : Shipment Plan Change 작성중 Confirm별로 삭제(일괄 삭제 -> 개별 Confirm)
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2026.10.21   AJS            공용 독립 프로시저 SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM 호출 래퍼 추가
         */
    BEGIN
        SCM_MGR.SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM
        (
            P_CONFIRM_ID        => P_CONFIRM_ID,
            P_CHANGE_REQUEST_NO => P_CHANGE_REQUEST_NO,
            P_DEL_FLAG          => P_DEL_FLAG,
            P_LAST_UPDATED_BY   => P_LAST_UPDATED_BY,
            P_TIME_ZONE         => P_TIME_ZONE,
            P_IF_SEND_FLAG      => P_IF_SEND_FLAG,
            P_CHANGE_TYPE       => P_CHANGE_TYPE,
            O_RC1               => O_RC1,
            O_RC2               => O_RC2
        );
    END P_SCM_SSP_DELETE_SHIPMENT_REQUEST_DRAFTING_BY_CONFIRM;

    --  2026.10.21 AJS 공용 ERP 오류 처리 프로시저 래퍼 (END)

END PKG_SSP0003;