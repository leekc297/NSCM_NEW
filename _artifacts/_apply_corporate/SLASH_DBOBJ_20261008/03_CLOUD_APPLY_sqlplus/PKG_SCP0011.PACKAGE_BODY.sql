-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SCP0011 — 사내 현재 원문(적용본, 사내 LAST_DDL 2026-10-08 16:52:24, 2472줄)
CREATE OR REPLACE PACKAGE BODY PKG_SCP0011
IS

    /* ------------------------------------------------------------
       오류 로그 (공통)
       ------------------------------------------------------------ */
    PROCEDURE P_LOG_ERROR
    (
        P_PROGRAM_NAME  IN  VARCHAR2,
        P_IN_PARA_DATA  IN  VARCHAR2,
        P_SQLCODE       IN  NUMBER,
        P_SQLERRM       IN  VARCHAR2,
        P_BACKTRACE     IN  VARCHAR2
    )
    IS
    BEGIN
        PR_SCM_SYS_LOG_BATCH(P_PROGRAM_NAME
                           , 'ERROR'
                           , NULL
                           , SUBSTR(P_SQLERRM, 1, 1000)
                           , NULL
                           , SYSDATE
                           , SUBSTR(P_IN_PARA_DATA, 1, 2000)
                           , TO_CHAR(P_SQLCODE)
                           , SUBSTR(P_SQLERRM, 1, 2000)
                           , SUBSTR(P_BACKTRACE, 1, 4000));
    END P_LOG_ERROR;


    /* ------------------------------------------------------------
       조립된 조회문 출력 (AS-IS debug_mode 대응)
       ------------------------------------------------------------ */
    PROCEDURE P_PUT_CLOB
    (
        P_CLOB      IN  CLOB
    )
    IS
    BEGIN
        FOR I IN 0 .. TRUNC((NVL(DBMS_LOB.GETLENGTH(P_CLOB), 0) - 1) / 4000)
        LOOP
            DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(P_CLOB, 4000, I * 4000 + 1));
        END LOOP;
    END P_PUT_CLOB;


    /* ------------------------------------------------------------
       빈 문자 비교값
       AS-IS 는 변수 초기값이 빈 문자('')이고 빈 문자는 어떤 날짜 문자열보다 작다.
       Oracle 은 빈 문자가 NULL 이라 비교 결과가 사라지므로 가장 작은 문자로 바꾸어 비교한다.
       ------------------------------------------------------------ */
    FUNCTION F_CMP
    (
        P_STR       IN  VARCHAR2
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF RTRIM(P_STR) IS NULL THEN
            RETURN CHR(1);
        END IF;

        RETURN P_STR;
    END F_CMP;


    /* ------------------------------------------------------------
       CONVERT(DATETIME, 'YYYYMMDD') 대응 - 빈 문자는 1900-01-01
       ------------------------------------------------------------ */
    FUNCTION F_STR_DATE
    (
        P_STR       IN  VARCHAR2
    )
    RETURN DATE
    IS
    BEGIN
        IF RTRIM(P_STR) IS NULL THEN
            RETURN DATE '1900-01-01';
        END IF;

        RETURN TO_DATE(P_STR, 'YYYYMMDD');
    END F_STR_DATE;


    /* ------------------------------------------------------------
       DATEADD(MM, n, d) 대응
       ADD_MONTHS 는 말일을 말일로 옮기지만(0228 -> 0831) AS-IS 는 일자를 유지한다(0228 -> 0828).
       ------------------------------------------------------------ */
    FUNCTION F_ADD_MONTHS
    (
        P_DATE      IN  DATE,
        P_MONTHS    IN  NUMBER
    )
    RETURN DATE
    IS
        V_BASE      DATE := ADD_MONTHS(TRUNC(P_DATE, 'MM'), P_MONTHS);
    BEGIN
        RETURN LEAST(V_BASE + (EXTRACT(DAY FROM P_DATE) - 1), LAST_DAY(V_BASE));
    END F_ADD_MONTHS;


    /* ------------------------------------------------------------
       previous monday
       AS-IS : dateadd(d, datepart(dw, GETDATE()) * -1 - 5, GETDATE())
       MSSQL datepart(dw) 는 일요일이 1 이다(1900-01-07 이 일요일). TRUNC(,'IW') 로 바꾸면 일요일에 한 주 어긋난다.
       ------------------------------------------------------------ */
    FUNCTION F_PREV_MONDAY
    RETURN VARCHAR2
    IS
    BEGIN
        RETURN TO_CHAR(TRUNC(SYSDATE) - (MOD(TRUNC(SYSDATE) - DATE '1900-01-07', 7) + 1) - 5, 'YYYYMMDD');
    END F_PREV_MONDAY;


    /* ------------------------------------------------------------
       쉼표 목록 분리 (AS-IS dbo.String_Split 대응 - 토큰 앞뒤 공백 제거)
       O_ALL = 'Y' : 목록이 비어 조건을 걸지 않음 (AS-IS (@p IS NULL OR @p = '') 갈래)
       P_UPPER = 'Y' : 대소문자 무시 비교 대응 - 원장 칸에 소문자가 없는 조건에만 쓴다
       ------------------------------------------------------------ */
    PROCEDURE P_SPLIT_LIST
    (
        P_STR       IN  VARCHAR2,
        P_UPPER     IN  VARCHAR2,
        O_TAB       OUT T_STR_TAB,
        O_ALL       OUT VARCHAR2
    )
    IS
    BEGIN
        IF RTRIM(P_STR) IS NULL THEN
            O_ALL := 'Y';
            O_TAB := T_STR_TAB();
        ELSE
            O_ALL := 'N';

            SELECT CASE
                       WHEN P_UPPER = 'Y'
                       THEN UPPER(COLUMN_VALUE)
                       ELSE COLUMN_VALUE
                   END
              BULK COLLECT INTO O_TAB
              FROM TABLE(STRING_SPLIT(P_STR, ','));
        END IF;
    END P_SPLIT_LIST;


    /* ------------------------------------------------------------
       계획 · 실적 구간 계산 (세 조회 공통)
       AS-IS 는 달력에 없는 일자면 변수가 빈 문자로 남는다 -> NULL 로 두고 F_CMP 로 비교한다.
       ------------------------------------------------------------ */
    PROCEDURE P_SET_PERIOD
    (
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        O_V_FROM_YYYYMMDD       OUT VARCHAR2,
        O_V_TO_YYYYMMDD         OUT VARCHAR2,
        O_V_FROM_RESULT         OUT VARCHAR2,
        O_V_TO_RESULT           OUT VARCHAR2
    )
    IS
    BEGIN
        O_V_TO_YYYYMMDD := NULL;
        O_V_TO_RESULT   := NULL;

        SELECT MAX(C.BASIS_START_DATE)
          INTO O_V_FROM_YYYYMMDD
          FROM SCM_SYS_CALENDAR_M C
         WHERE C.BASIS_YYYYMMDD = P_PLAN_START_YYYYMMDD;

        SELECT MAX(C.BASIS_START_DATE)
          INTO O_V_FROM_RESULT
          FROM SCM_SYS_CALENDAR_M C
         WHERE C.BASIS_YYYYMMDD = P_FROM_YYYYMMDD;

        SELECT MAX(C.BASIS_START_DATE)
          INTO O_V_TO_RESULT
          FROM SCM_SYS_CALENDAR_M C
         WHERE C.BASIS_YYYYMMDD = P_TO_YYYYMMDD;

        IF F_CMP(O_V_FROM_YYYYMMDD) > F_CMP(O_V_FROM_RESULT) THEN
            -- 실적 보여줌
            O_V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            O_V_TO_RESULT   := O_V_FROM_YYYYMMDD;
        ELSIF F_CMP(O_V_FROM_YYYYMMDD) <= F_CMP(O_V_FROM_RESULT) THEN
            -- 실적 없음
            O_V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            O_V_FROM_RESULT := TO_CHAR(F_ADD_MONTHS(F_STR_DATE(P_PLAN_START_YYYYMMDD),  6), 'YYYYMMDD');
            O_V_TO_RESULT   := TO_CHAR(F_ADD_MONTHS(F_STR_DATE(P_PLAN_START_YYYYMMDD), -6), 'YYYYMMDD');
        ELSIF F_CMP(O_V_FROM_YYYYMMDD) > F_CMP(O_V_TO_RESULT) THEN
            O_V_FROM_YYYYMMDD := TO_CHAR(F_ADD_MONTHS(F_STR_DATE(P_PLAN_START_YYYYMMDD), -6), 'YYYYMMDD');
            O_V_TO_YYYYMMDD   := TO_CHAR(F_ADD_MONTHS(F_STR_DATE(P_PLAN_START_YYYYMMDD), -6), 'YYYYMMDD');
            O_V_FROM_RESULT   := P_FROM_YYYYMMDD;
            O_V_TO_RESULT     := P_TO_YYYYMMDD;
        ELSIF F_CMP(O_V_FROM_YYYYMMDD) = F_CMP(O_V_TO_RESULT) THEN
            O_V_TO_YYYYMMDD := O_V_FROM_YYYYMMDD;
            O_V_FROM_RESULT := P_FROM_YYYYMMDD;
            O_V_TO_RESULT   := P_TO_YYYYMMDD;
        END IF;
    END P_SET_PERIOD;


    /*==================================================================================================
     * Program ID   : [SCP0011_GET_PRODUCTION_PLAN_MODEL]
     * Description  : Production Plan MODEL QTY 조회
     * Program History
     *===================================================================================================
     * Date         In Charge		Description
     *===================================================================================================
     * 2018/01/22   PJS				          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/02/13   PJS				          성능개선  PIVOT제거, CASE SUM방식으로 변경
     * 2018/03/15   PJS				          UOM 필드 제거
     * 2018/04/17   PJS				          임시테이블 삭제 OBJECT_ID형식으로 변경
     * 2018/05/08   byunghunjung	          성능개선을 위해 dbo.String_Split IN조건 쿼리 부분을 Dynamic Query로 변경
     * 2018/05/28   byunghunjung	          실적 테이블 값 조회시 scp_operation_group 조회조건 추가
     * 2018/05/29   PJS				          주Sum 집계방식 변경
     * 2018/06/05   byunghunjung	          성능개선을 위해 Null 레코드 Case 분기에서 제외시키기 위한 Self Join 방식으로 변경 적용
     * 2018/07/11   byunghunjung	          EE 사업부 실적 추가
     * 2018/07/18   YHW				          전극용 조회항목 추가
     * 2018/08/31	YHW				          NICK NAME 조회항목 추가
     * 2018/09/27   ygkim			          생산 실적 조건 추가 (LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회, 외주PACKER의 업체코드)
     * 2021/06/25   KMJ				          UI 속도 개선 반영
     * 2021.07.22   LWY			              PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - scp_anl_production_plan / hist_scp_anl_production_plan 분리작업
     * 2021.10.07   KMJ			              PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - UI 속도 개선으로 Bucket별 조회로 수정
     * 2021.11.24   khj79                     [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - p_chk_all 추가 ( 체크 시 bucket='daily' 조회)
     * 2022.05.13   LSC                       PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
     * 2022.06.27   LWY                       PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : weekly : @v_from_yyyymmdd AND @v_to_yyyymmdd -> @p_from_yyyymmdd AND @p_to_yyyymmdd
     * 2022.08.31   LWY                       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Isuzu 추가
     * 2023.01.02   LWY				          PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 조회기준 변경(main / hist) - 당주,전주(main) / 당주,전주 이전(hist)
     * 2023/04/10   LWY				          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
     * 2023.07.26   vadabi3			          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Model, Material 개선
     * 2024-01-08   chaan                     PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
     * 2024-01-19   chaan           V1.1.1    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - 2차 튜닝
     * 2026.09.17                             [MSSQL -> Oracle 전환] 수량 적재 동적 SQL 을 정적 SQL 로 전환(기간 칸 피벗만 동적)
     *                                        시트 이름 · 사용자 ID 대소문자 무시 비교(AS-IS 정렬규칙 CI 대응)
     * 2026.10.06   AJS                       ISUZU 품목 적재 조회 속도 개선 : 품목 뷰를 하위 뷰(SCM_MST_FINAL_ITEM_ORIGIN_DIV_V)로 바꿔 사업부 갈래 중복 전개 제거 (EXISTS 판정 품목 동일)
     *==================================================================================================*/
    PROCEDURE P_SCP0011_GET_PROD_PLAN_MODEL
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_MODEL_ID              IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0011',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'MODEL',
        P_USER_ID               IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT NULL,
        P_NICK_NAME             IN  VARCHAR2 DEFAULT NULL,
        P_BUCKET                IN  VARCHAR2 DEFAULT NULL,
        P_TO_PERIOD             IN  VARCHAR2 DEFAULT NULL,
        P_CHK_ALL               IN  VARCHAR2 DEFAULT NULL,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_DIVISION_ID           VARCHAR2(50 CHAR)  := UPPER(P_DIVISION_ID);
        V_OPERATION_GROUP       VARCHAR2(50 CHAR)  := UPPER(P_OPERATION_GROUP);
        V_PLAN_TYPE             VARCHAR2(50 CHAR)  := UPPER(P_PLAN_TYPE);
        V_PROGRAM_ID            VARCHAR2(300 CHAR) := UPPER(P_PROGRAM_ID);
        V_SHEET_NAME            VARCHAR2(150 CHAR) := UPPER(P_SHEET_NAME);
        V_USER_ID               VARCHAR2(150 CHAR) := UPPER(P_USER_ID);
        V_BUCKET                VARCHAR2(10 CHAR)  := UPPER(P_BUCKET);
        V_SEQ                   NUMBER;
        V_PLAN_START_DATE       DATE;

        V_CNT_USR_MEASURE       NUMBER := 0;
        V_MIN_YYYYMMDD          VARCHAR2(8 CHAR);
        V_FROM_YYYYMMDD         VARCHAR2(8 CHAR);
        V_TO_YYYYMMDD           VARCHAR2(8 CHAR);
        V_FROM_RESULT           VARCHAR2(8 CHAR);
        V_TO_RESULT             VARCHAR2(8 CHAR);
        V_FROM_RESULT_DATE      DATE;
        V_TO_RESULT_DATE        DATE;
        V_FROM_CMP              VARCHAR2(8 CHAR);   /* 빈 문자 비교값 */
        V_TO_CMP                VARCHAR2(8 CHAR);

        V_SITE_TAB              T_STR_TAB;
        V_SITE_ALL              VARCHAR2(1 CHAR);
        V_ITEM_TAB              T_STR_TAB;
        V_ITEM_ALL              VARCHAR2(1 CHAR);
        V_ELEC_TAB              T_STR_TAB;
        V_ELEC_ALL              VARCHAR2(1 CHAR);
        V_MODEL_TAB             T_STR_TAB;
        V_MODEL_ALL             VARCHAR2(1 CHAR);
        V_RES_DIV_TAB           T_STR_TAB;          /* 실적 조회 사업부 */
        V_OSP_DIV_TAB           T_STR_TAB;          /* 외주 PACKER 조회 사업부 */
        V_NICK_YN               VARCHAR2(1 CHAR) := 'N';

        V_QRY_FIELD             CLOB;
        V_QRY_SUM               CLOB;
        V_SQL                   CLOB;
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        V_SEQ             := TO_NUMBER(P_SEQ);
        /* 파티션 프루닝용 - 형식이 틀리면 NULL 이고, 이때는 계획 일자 조건이 이미 0 건이다 */
        SELECT TO_DATE(P_PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD')
          INTO V_PLAN_START_DATE
          FROM DUAL;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND UPPER(SHEET_NAME)  = V_SHEET_NAME
           AND UPPER(USER_ID)     = V_USER_ID;

        P_SET_PERIOD(P_PLAN_START_YYYYMMDD, P_FROM_YYYYMMDD, P_TO_YYYYMMDD
                   , V_FROM_YYYYMMDD, V_TO_YYYYMMDD, V_FROM_RESULT, V_TO_RESULT);

        V_FROM_RESULT_DATE := F_STR_DATE(V_FROM_RESULT);
        V_TO_RESULT_DATE   := F_STR_DATE(V_TO_RESULT);
        V_FROM_CMP         := F_CMP(V_FROM_YYYYMMDD);
        V_TO_CMP           := F_CMP(V_TO_YYYYMMDD);

        IF P_DEBUG_MODE = 'T' THEN
            DBMS_OUTPUT.PUT_LINE('----------------------------------');
            DBMS_OUTPUT.PUT_LINE('v_from_yyyymmdd =' || V_FROM_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('v_to_yyyymmdd =' || V_TO_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('v_from_result =' || V_FROM_RESULT);
            DBMS_OUTPUT.PUT_LINE('v_to_result =' || V_TO_RESULT);
            DBMS_OUTPUT.PUT_LINE('----------------------------------');
        END IF;

        P_SPLIT_LIST(P_SCM_SITE_ID   , 'Y', V_SITE_TAB , V_SITE_ALL);
        P_SPLIT_LIST(P_ITEM_ID       , 'Y', V_ITEM_TAB , V_ITEM_ALL);
        P_SPLIT_LIST(P_ELECTRODE_TYPE, 'Y', V_ELEC_TAB , V_ELEC_ALL);
        P_SPLIT_LIST(P_MODEL_ID      , 'Y', V_MODEL_TAB, V_MODEL_ALL);

        -- 2021.11.24 : 체크 시 bucket='daily' 조회
        IF UPPER(P_CHK_ALL) = 'Y' THEN
            V_BUCKET := 'DAILY';
        END IF;

        /* 실적 조회 사업부 */
        IF V_DIVISION_ID = 'EE' THEN
            V_RES_DIV_TAB := T_STR_TAB('40', '81', '82');
        ELSIF V_DIVISION_ID = 'EE_UC' THEN
            V_RES_DIV_TAB := T_STR_TAB('81_UC');
        ELSIF V_DIVISION_ID = 'EE_HM' THEN
            V_RES_DIV_TAB := T_STR_TAB('81_HM');
        ELSIF V_DIVISION_ID = 'EE_ST' THEN
            V_RES_DIV_TAB := T_STR_TAB('81_ST');
        ELSE
            V_RES_DIV_TAB := T_STR_TAB(V_DIVISION_ID);
        END IF;

        /* 외주 PACKER 조회 사업부 (AS-IS 는 EE_HM · EE_ST 갈래가 없다) */
        IF V_DIVISION_ID = 'EE' THEN
            V_OSP_DIV_TAB := T_STR_TAB('40', '81', '82');
        ELSIF V_DIVISION_ID = 'EE_UC' THEN
            V_OSP_DIV_TAB := T_STR_TAB('81_UC');
        ELSE
            V_OSP_DIV_TAB := T_STR_TAB(V_DIVISION_ID);
        END IF;

        /********************************************************************************
        * 임시테이블 초기화
        ********************************************************************************/
        DELETE FROM GT_0011_NICKITEM;
        DELETE FROM GT_0011_ISUZU;
        DELETE FROM GT_0011_MDL_QTY;
        DELETE FROM GT_0011_MDL_MAIN;

        /********************************************************************************
        * 임시테이블만들기 - nick name 조회 시
        ********************************************************************************/
        IF RTRIM(P_NICK_NAME) IS NOT NULL THEN

            V_NICK_YN := 'Y';

            INSERT INTO GT_0011_NICKITEM
                 (
                   ITEM_ID
                 )
            SELECT DISTINCT
                   ITEM_ID
              FROM SCM_MST_ITEM_SN
             WHERE NICK_NAME IS NOT NULL
               AND NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%';     /* 원장 NICK_NAME 소문자 0 건 */

        END IF;

        /********************************************************************************
        * 임시테이블만들기 - Qty 부분
        ********************************************************************************/
        -- 2022.08.31 start
        -- ISUZU item
        INSERT INTO GT_0011_ISUZU
             (
               ITEM_ID
             )
        SELECT A.ITEM_ID
--          FROM SCM_MST_FINAL_ITEM_V A                                                     --  2026.10.06 AJS
          FROM SCM_MST_FINAL_ITEM_ORIGIN_DIV_V A          /* 품목 뷰 사업부 갈래 중복 전개 제거 - EXISTS 판정 품목 동일 */   --  2026.10.06 AJS
             , SCP_MST_FINAL_ITEM_V B
         WHERE A.ITEM_ID = B.ITEM_ID
           AND A.IS_YN   = 'Y';
        -- 2022.08.31 end

        -- 2023.01.02
        V_MIN_YYYYMMDD := F_PREV_MONDAY;     -- previous monday

        -- 계획
        IF F_CMP(P_PLAN_START_YYYYMMDD) >= V_MIN_YYYYMMDD THEN

            INSERT INTO GT_0011_MDL_QTY
                 (
                   DIVISION_ID
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,OPERATION_ID
                  ,LINE_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                 )
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.MEASURE
                 , A.YYYYMMDD
                 , A.QTY
                 , NVL(A.ORIGIN_DIVISION_ID, A.DIVISION_ID)         AS ORIGIN_DIVISION_ID
                 , NVL(NULLIF(RTRIM(A.ELECTRODE_TYPE),''), '/')                       AS ELECTRODE_TYPE
              FROM SCP_ANL_PRODUCTION_PLAN A
             WHERE A.YYYYMMDD                >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD                <= P_TO_YYYYMMDD
               AND A.DIVISION_ID              = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE          /* 파티션 프루닝 */
               AND A.PLAN_TYPE                = V_PLAN_TYPE
               AND A.SEQ                      = V_SEQ
               AND A.OPERATION_GROUP          = V_OPERATION_GROUP
               AND A.QTY                     <> 0
               AND (V_SITE_ALL = 'Y' OR A.SCM_SITE_ID    IN (SELECT COLUMN_VALUE FROM TABLE(V_SITE_TAB)))
               AND (V_ITEM_ALL = 'Y' OR A.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
               AND (V_ELEC_ALL = 'Y' OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)));

        ELSIF F_CMP(P_PLAN_START_YYYYMMDD) < V_MIN_YYYYMMDD THEN

            INSERT INTO GT_0011_MDL_QTY
                 (
                   DIVISION_ID
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,OPERATION_ID
                  ,LINE_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                 )
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.MEASURE
                 , A.YYYYMMDD
                 , A.QTY
                 , NVL(A.ORIGIN_DIVISION_ID, A.DIVISION_ID)         AS ORIGIN_DIVISION_ID
                 , NVL(NULLIF(RTRIM(A.ELECTRODE_TYPE),''), '/')                       AS ELECTRODE_TYPE
              FROM HIST_SCP_ANL_PRODUCTION_PLAN A
             WHERE A.YYYYMMDD                >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD                <= P_TO_YYYYMMDD
               AND A.DIVISION_ID              = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE          /* 파티션 프루닝 */
               AND A.PLAN_TYPE                = V_PLAN_TYPE
               AND A.SEQ                      = V_SEQ
               AND A.OPERATION_GROUP          = V_OPERATION_GROUP
               AND A.QTY                     <> 0
               AND (V_SITE_ALL = 'Y' OR A.SCM_SITE_ID    IN (SELECT COLUMN_VALUE FROM TABLE(V_SITE_TAB)))
               AND (V_ITEM_ALL = 'Y' OR A.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
               AND (V_ELEC_ALL = 'Y' OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)));

        END IF;

        -- 생산실적
        INSERT INTO GT_0011_MDL_QTY
             (
               DIVISION_ID
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,OPERATION_ID
              ,LINE_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
             )
        SELECT V_DIVISION_ID                                        AS DIVISION_ID     --div_commonization
             , A.SCP_OPERATION_GROUP                                AS OPERATION_GROUP
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , 'PROD_PLAN_ENGINE'                                   AS MEASURE
             , TO_CHAR(A.PLAN_DATE, 'YYYYMMDD')                     AS YYYYMMDD
             , A.ACTUAL_GOOD_QTY                                    AS QTY
             , A.DIVISION_ID                                        AS ORIGIN_DIVISION_ID
             , NVL(NULLIF(RTRIM(A.ELECTRODE_TYPE),''), '/')                           AS ELECTRODE_TYPE
          FROM SCM_DNM_PRODUCT_RESULT_V A
         WHERE (   SUBSTR(A.OPERATION_ID, 1, 5) IN (SELECT XA.SEGMENT1     --LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
                                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                                                     WHERE XA.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                                       AND XA.SEGMENT1   <> 'F6000'
                                                       AND XA.VALID_YN    = 'Y')
                -- 2022.08.31 start
                OR (    A.OPERATION_ID LIKE 'P5000%'
                    AND EXISTS (SELECT 1
                                  FROM GT_0011_ISUZU XB
                                 WHERE XB.ITEM_ID = A.ITEM_ID))
                -- 2022.08.31 end
                OR A.OPERATION_ID IN (SELECT XC.PLANT_ID                    --외주PACKER의 업체코드
                                        FROM SCM_MST_SITE XC
                                       WHERE XC.DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_OSP_DIV_TAB))
                                         AND XC.SITE_TYPE    = 'PLANT'
                                         AND XC.OSP_YN       = 'Y'
                                         AND XC.VALID_YN     = 'Y'))
           AND A.PLAN_DATE           >= V_FROM_RESULT_DATE
           AND A.PLAN_DATE           <  V_TO_RESULT_DATE                  -- equal 표시 주의할것
           AND A.DIVISION_ID         IN (SELECT COLUMN_VALUE FROM TABLE(V_RES_DIV_TAB))
           AND A.SCP_OPERATION_GROUP  = V_OPERATION_GROUP
           AND (V_SITE_ALL = 'Y' OR A.SCM_SITE_ID    IN (SELECT COLUMN_VALUE FROM TABLE(V_SITE_TAB)))
           AND (V_ITEM_ALL = 'Y' OR A.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
           AND (V_ELEC_ALL = 'Y' OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)));

        /* GT_0011_MDL_QTY 통계 수집(DBMS_STATS)은 넣지 않는다 - 임시 테이블이라도 트랜잭션이 확정되어 호출 측 작업이 함께 확정된다 */

        /********************************************************************************
        * 데이타조회, 임시테이블에 저장 - Main : #TblDynamicPivot_SCP0011_01
        ********************************************************************************/
        INSERT INTO GT_0011_MDL_MAIN
             (
               KEY_IDX
              ,DIVISION_ID
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,MEASURE
              ,MEASURE_NAME
              ,USER_SORT_ORDER_NO
              ,FROM_YYYYMMDD
              ,TO_YYYYMMDD
              ,PLAN_START_YYYYMMDD
              ,YYYYMMDD
              ,YYYYMM
              ,ISO_WEEK
              ,QTY
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,WEEK_YN
              ,MONTH_YN
             )
        SELECT CASE
                   WHEN    IA.DIVISION_ID     IS NULL
                        OR IA.OPERATION_GROUP IS NULL
                        OR IA.SCM_SITE_ID     IS NULL
                        OR IA.ITEM_ID         IS NULL
                   THEN NULL        /* AS-IS 문자열 결합은 NULL 이 섞이면 NULL */
                   ELSE IA.DIVISION_ID || IA.OPERATION_GROUP || IA.SCM_SITE_ID || IA.ITEM_ID
               END                                                  AS KEY_IDX
             , IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.SCM_SITE_ID
             , IA.ITEM_ID
             , P_PLAN_TYPE                                          AS PLAN_TYPE
             , P_SEQ                                                AS PLAN_SEQ
             , IA.MEASURE
             , IA.MEASURE_NAME
             , IA.USER_SORT_ORDER_NO
             , P_FROM_YYYYMMDD                                      AS FROM_YYYYMMDD
             , P_TO_YYYYMMDD                                        AS TO_YYYYMMDD
             , P_PLAN_START_YYYYMMDD                                AS PLAN_START_YYYYMMDD
             , 'D_' || IA.YYYYMMDD                                  AS YYYYMMDD
             , C.BASIS_YYYYMM                                       AS YYYYMM
             , SUBSTR(C.BASIS_YYYYMM, -4) || C.ISO_WEEK             AS ISO_WEEK
             , NVL(B.QTY, 0)                                        AS QTY
             , IA.ORIGIN_DIVISION_ID
             , IA.ELECTRODE_TYPE
             , 'N'                                                  AS WEEK_YN
             , 'N'                                                  AS MONTH_YN
          FROM (SELECT XC.DIVISION_ID
                     , XC.OPERATION_GROUP
                     , XC.SCM_SITE_ID
                     , XC.ITEM_ID
                     , XC.LINE_ID
                     , XC.OPERATION_ID
                     , XA.COLUMN_NAME                               AS MEASURE
                     , XA.COLUMN_LABEL_NAME                         AS MEASURE_NAME
                     , NVL(XB.SORT_ORDER_NO, XA.SORT_ORDER_NO)      AS USER_SORT_ORDER_NO
                     , XC.YYYYMMDD
                     , XC.ORIGIN_DIVISION_ID
                     , XC.ELECTRODE_TYPE
                  FROM SCM_MST_SHEET_MEASURE    XA
                     , SCM_MST_TITLESET_USER    XB
                     , GT_0011_MDL_QTY          XC      -- Header : #TblDynamicPivot_SCP0011_02
                 WHERE XA.PROGRAM_ID          = XB.PROGRAM_ID(+)
                   AND UPPER(XA.SHEET_NAME)   = UPPER(XB.SHEET_NAME(+))
                   AND UPPER(XA.COLUMN_NAME)  = UPPER(XB.COLUMN_NAME(+))
                   AND UPPER(XB.USER_ID(+))   = V_USER_ID
                   AND (   V_CNT_USR_MEASURE = 0
                        OR EXISTS (SELECT 1
                                     FROM SCM_MST_TITLESET_USER SA
                                    WHERE SA.PROGRAM_ID         = V_PROGRAM_ID
                                      AND UPPER(SA.SHEET_NAME)  = V_SHEET_NAME
                                      AND UPPER(SA.USER_ID)     = V_USER_ID
                                      AND UPPER(SA.COLUMN_NAME) = UPPER(XA.COLUMN_NAME)))
                   AND XA.VALID_YN            = 'Y'
                   AND XA.PROGRAM_ID          = V_PROGRAM_ID
                   AND UPPER(XA.SHEET_NAME)   = V_SHEET_NAME
                   AND (   V_OPERATION_GROUP = 'A'
                        OR XA.ATTRIBUTE1 IS NULL
                        OR XA.ATTRIBUTE1 <> 'A')
                 GROUP BY XC.DIVISION_ID
                        , XC.OPERATION_GROUP
                        , XC.SCM_SITE_ID
                        , XC.ITEM_ID
                        , XC.LINE_ID
                        , XC.OPERATION_ID
                        , XA.COLUMN_NAME
                        , XA.COLUMN_LABEL_NAME
                        , XC.YYYYMMDD
                        , XC.ORIGIN_DIVISION_ID
                        , XC.ELECTRODE_TYPE
                        , NVL(XB.SORT_ORDER_NO, XA.SORT_ORDER_NO)) IA
             , GT_0011_MDL_QTY          B       -- QTY : #TblDynamicPivot_SCP0011_03
             , SCM_SYS_CALENDAR_M       C
         WHERE IA.DIVISION_ID        = B.DIVISION_ID(+)
           AND IA.OPERATION_GROUP    = B.OPERATION_GROUP(+)
           AND IA.SCM_SITE_ID        = B.SCM_SITE_ID(+)
           AND IA.ITEM_ID            = B.ITEM_ID(+)
           AND IA.OPERATION_ID       = B.OPERATION_ID(+)
           AND IA.LINE_ID            = B.LINE_ID(+)
           AND IA.MEASURE            = B.MEASURE(+)
           AND IA.YYYYMMDD           = B.YYYYMMDD(+)
           AND IA.ORIGIN_DIVISION_ID = B.ORIGIN_DIVISION_ID(+)
           AND IA.ELECTRODE_TYPE     = B.ELECTRODE_TYPE(+)
           AND IA.YYYYMMDD           = C.BASIS_YYYYMMDD;

        /********************************************************************************
        * MEASURE = ONHAND_EOH의 경우
        ********************************************************************************/
        UPDATE GT_0011_MDL_MAIN
           SET WEEK_YN = 'Y'
         WHERE SUBSTR(YYYYMMDD, -8) IN (SELECT MAX(BASIS_YYYYMMDD)       AS YYYYMMDD
                                          FROM SCM_SYS_CALENDAR_M
                                         WHERE BASIS_YYYYMMDD >= V_FROM_CMP
                                           AND BASIS_YYYYMMDD <= P_TO_PERIOD  -- 마지막 구간 오류 발생으로 1개월 더함
                                         GROUP BY ISO_WEEK
                                                , PARTIAL_WEEK_NAME)
           AND MEASURE = 'ONHAND_EOH';

        UPDATE GT_0011_MDL_MAIN
           SET MONTH_YN = 'Y'
         WHERE SUBSTR(YYYYMMDD, -8) IN (SELECT MAX(BASIS_YYYYMMDD)       AS YYYYMMDD
                                          FROM SCM_SYS_CALENDAR_M
                                         WHERE BASIS_YYYYMMDD >= V_FROM_CMP
                                           AND BASIS_YYYYMMDD <= P_TO_PERIOD  -- 마지막 구간 오류 발생으로 1개월 더함
                                         GROUP BY BASIS_YYYYMM)
           AND MEASURE = 'ONHAND_EOH';

        /* GT_0011_MDL_MAIN 통계 수집(DBMS_STATS)은 넣지 않는다 - 임시 테이블이라도 트랜잭션이 확정되어 호출 측 작업이 함께 확정된다 */

        /********************************************************************************
        * PIVOIT처리
        * 조회 기간에 따라 칸 수가 달라져 동적 SQL 이 불가피하다.
        * 조립에 들어가는 값은 달력 원장에서 만든 칸 이름 · 일수뿐이며 사용자 입력은 바인드로 넘긴다.
        ********************************************************************************/
        -- PIVOIT 대상 날짜문자열 생성
        V_QRY_FIELD := NULL;
        V_QRY_SUM   := NULL;

        FOR R IN (SELECT IA.COL_NAME
                       , IA.CNT
                    FROM (SELECT 'W_' || XA.BASIS_YYYYMM || XA.ISO_WEEK             AS COL_NAME
                               , XA.BASIS_START_DATE || '21'                        AS SORT_ORDER_NO
                               , COUNT(1)                                           AS CNT
                            FROM SCM_SYS_CALENDAR_M XA
                               -- 2022.06.27
                           WHERE XA.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             AND (V_BUCKET = 'DAILY' OR V_BUCKET = 'WEEKLY')
                           GROUP BY XA.BASIS_YYYYMM
                                  , XA.ISO_WEEK
                                  , XA.BASIS_START_DATE
                           UNION ALL
                          SELECT 'M_' || XB.BASIS_YYYYMM                            AS COL_NAME
                               , MIN(XB.BASIS_START_DATE) || '01'                   AS SORT_ORDER_NO
                               , COUNT(1)                                           AS CNT
                            FROM SCM_SYS_CALENDAR_M XB
                           WHERE XB.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY XB.BASIS_YYYYMM
                                  , XB.MONTH_NAME
                           UNION ALL
                          SELECT 'D_' || XC.BASIS_YYYYMMDD                          AS COL_NAME
                               , XC.BASIS_YYYYMMDD || '31'                          AS SORT_ORDER_NO
                               , COUNT(1)                                           AS CNT
                            FROM SCM_SYS_CALENDAR_M XC
                           WHERE XC.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             AND V_BUCKET = 'DAILY'
                           GROUP BY XC.BASIS_YYYYMMDD) IA
                   ORDER BY IA.SORT_ORDER_NO)
        LOOP
            V_QRY_FIELD := V_QRY_FIELD || '     , NVL(IB.' || R.COL_NAME || ', 0) AS ' || R.COL_NAME || CHR(10);

            /* AS-IS 는 NUMERIC(38,10) 나눗셈이라 소수 10 자리에서 절삭된다(20/3 = 6.6666666666) */
            IF SUBSTR(R.COL_NAME, 1, 2) = 'M_' THEN
                V_QRY_SUM := V_QRY_SUM
                          || '     , TRUNC(SUM(CASE WHEN XB.YYYYMM = ''' || SUBSTR(R.COL_NAME, -6) || ''' AND XB.MEASURE = ''ONHAND_EOH'' AND XB.MONTH_YN = ''Y'' THEN XB.QTY'
                          || ' WHEN XB.YYYYMM = ''' || SUBSTR(R.COL_NAME, -6) || ''' AND XB.MEASURE <> ''ONHAND_EOH'''
                          || ' THEN CASE WHEN XB.MEASURE = ''FORMATION_YIELD'' OR XB.MEASURE = ''LINE_TOTAL_LOAD'' THEN ROUND(XB.QTY * 100, 2) ELSE XB.QTY END'
                          || ' ELSE 0 END)'
                          || ' / CASE WHEN XB.MEASURE = ''FORMATION_YIELD'' OR XB.MEASURE = ''LINE_TOTAL_LOAD'' THEN ' || TO_CHAR(R.CNT) || ' ELSE 1 END, 10) AS ' || R.COL_NAME || CHR(10);
            ELSIF SUBSTR(R.COL_NAME, 1, 2) = 'W_' THEN
                V_QRY_SUM := V_QRY_SUM
                          || '     , TRUNC(SUM(CASE WHEN XB.ISO_WEEK = ''' || SUBSTR(R.COL_NAME, -6) || ''' AND XB.MEASURE = ''ONHAND_EOH'' AND XB.WEEK_YN = ''Y'' THEN XB.QTY'
                          || ' WHEN XB.ISO_WEEK = ''' || SUBSTR(R.COL_NAME, -6) || ''' AND XB.MEASURE <> ''ONHAND_EOH'''
                          || ' THEN CASE WHEN XB.MEASURE = ''FORMATION_YIELD'' OR XB.MEASURE = ''LINE_TOTAL_LOAD'' THEN ROUND(XB.QTY * 100, 2) ELSE XB.QTY END'
                          || ' ELSE 0 END)'
                          || ' / CASE WHEN XB.MEASURE = ''FORMATION_YIELD'' OR XB.MEASURE = ''LINE_TOTAL_LOAD'' THEN ' || TO_CHAR(R.CNT) || ' ELSE 1 END, 10) AS ' || R.COL_NAME || CHR(10);
            ELSE
                V_QRY_SUM := V_QRY_SUM
                          || '     , SUM(CASE WHEN XB.YYYYMMDD = ''' || R.COL_NAME || ''''
                          || ' THEN CASE WHEN XB.MEASURE = ''FORMATION_YIELD'' OR XB.MEASURE = ''LINE_TOTAL_LOAD'' THEN ROUND(XB.QTY * 100, 2) ELSE XB.QTY END'
                          || ' ELSE 0 END) AS ' || R.COL_NAME || CHR(10);
            END IF;
        END LOOP;

        /* Null 레코드 Case 분기에서 제외시키기 위한 Self Join 방식으로 변경 */
        V_SQL := 'SELECT IX.*' || CHR(10)
              || '  FROM (SELECT IA.KEY_IDX' || CHR(10)
              || '             , IA.DIVISION_ID' || CHR(10)
              || '             , IA.DIVISION_NAME' || CHR(10)
              || '             , IA.OPERATION_GROUP' || CHR(10)
              || '             , (SELECT SA.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA WHERE SA.LOOKUP_TYPE = ''OPERATION_GROUP'' AND SA.SEGMENT1 = IA.OPERATION_GROUP AND ROWNUM = 1) AS OPERATION_GROUP_NAME' || CHR(10)
              || '             , IA.SCM_SITE_ID' || CHR(10)
              || '             , (SELECT SB.SITE_DESCRIPTION FROM SCM_MST_SITE SB WHERE SB.SCM_SITE_ID = IA.SCM_SITE_ID AND ROWNUM = 1) AS SCM_SITE_DESCRIPTION' || CHR(10)
              || '             , FN_GET_ITEM_PROD_OP(IA.DIVISION_ID, IA.OPERATION_GROUP, IA.ITEM_ID) AS MODEL_ID' || CHR(10)
              || '             , IA.ITEM_ID' || CHR(10)
              || '             , (SELECT CASE WHEN RTRIM(SC.NICK_NAME) IS NULL THEN ''-'' ELSE SC.NICK_NAME END FROM SCM_MST_ITEM_SN SC WHERE SC.ITEM_ID = IA.ITEM_ID AND ROWNUM = 1) AS NICK_NAME' || CHR(10)
              || '             , FN_GET_SCP_ANL_BOH_QTY(IA.DIVISION_ID, IA.PLAN_START_YYYYMMDD, IA.PLAN_TYPE, TO_NUMBER(IA.PLAN_SEQ), IA.SCM_SITE_ID, IA.ITEM_ID, IA.FROM_YYYYMMDD) AS BOH' || CHR(10)
              || '             , IA.MEASURE' || CHR(10)
              || '             , IA.MEASURE_NAME' || CHR(10)
              || '             , IA.USER_SORT_ORDER_NO' || CHR(10)
              || '             , IA.PLAN_START_YYYYMMDD' || CHR(10)
              || '             , IA.PLAN_TYPE' || CHR(10)
              || '             , IA.PLAN_SEQ' || CHR(10)
              || '             , IA.FROM_YYYYMMDD' || CHR(10)
              || '             , IA.TO_YYYYMMDD' || CHR(10)
              || '             , IA.ORIGIN_DIVISION_ID' || CHR(10)
              || '             , IA.ELECTRODE_TYPE' || CHR(10)
              || V_QRY_FIELD
              || '          FROM (SELECT DISTINCT' || CHR(10)
              || '                       XA.KEY_IDX' || CHR(10)
              || '                     , XA.DIVISION_ID' || CHR(10)
              || '                     , XA.DIVISION_ID AS DIVISION_NAME' || CHR(10)
              || '                     , XA.OPERATION_GROUP' || CHR(10)
              || '                     , XA.SCM_SITE_ID' || CHR(10)
              || '                     , XA.ITEM_ID' || CHR(10)
              || '                     , XA.MEASURE' || CHR(10)
              || '                     , XA.MEASURE_NAME' || CHR(10)
              || '                     , XA.USER_SORT_ORDER_NO' || CHR(10)
              || '                     , XA.PLAN_START_YYYYMMDD' || CHR(10)
              || '                     , XA.PLAN_TYPE' || CHR(10)
              || '                     , XA.PLAN_SEQ' || CHR(10)
              || '                     , XA.FROM_YYYYMMDD' || CHR(10)
              || '                     , XA.TO_YYYYMMDD' || CHR(10)
              || '                     , XA.ORIGIN_DIVISION_ID' || CHR(10)
              || '                     , XA.ELECTRODE_TYPE' || CHR(10)
              || '                  FROM GT_0011_MDL_MAIN XA) IA' || CHR(10)
              || '             , (SELECT XB.KEY_IDX' || CHR(10)
              || '                     , XB.DIVISION_ID' || CHR(10)
              || '                     , XB.OPERATION_GROUP' || CHR(10)
              || '                     , XB.SCM_SITE_ID' || CHR(10)
              || '                     , XB.ITEM_ID' || CHR(10)
              || '                     , XB.MEASURE' || CHR(10)
              || '                     , XB.MEASURE_NAME' || CHR(10)
              || '                     , XB.USER_SORT_ORDER_NO' || CHR(10)
              || '                     , XB.PLAN_START_YYYYMMDD' || CHR(10)
              || '                     , XB.PLAN_TYPE' || CHR(10)
              || '                     , XB.PLAN_SEQ' || CHR(10)
              || '                     , XB.FROM_YYYYMMDD' || CHR(10)
              || '                     , XB.TO_YYYYMMDD' || CHR(10)
              || '                     , XB.ORIGIN_DIVISION_ID' || CHR(10)
              || '                     , XB.ELECTRODE_TYPE' || CHR(10)
              || V_QRY_SUM
              || '                  FROM GT_0011_MDL_MAIN XB' || CHR(10)
              || '                 WHERE XB.QTY <> 0' || CHR(10)
              || '                 GROUP BY XB.KEY_IDX, XB.DIVISION_ID, XB.OPERATION_GROUP, XB.SCM_SITE_ID, XB.ITEM_ID, XB.MEASURE, XB.MEASURE_NAME, XB.USER_SORT_ORDER_NO' || CHR(10)
              || '                        , XB.PLAN_START_YYYYMMDD, XB.PLAN_TYPE, XB.PLAN_SEQ, XB.FROM_YYYYMMDD, XB.TO_YYYYMMDD, XB.ORIGIN_DIVISION_ID, XB.ELECTRODE_TYPE) IB' || CHR(10)
              || '         WHERE IA.KEY_IDX             = IB.KEY_IDX(+)' || CHR(10)
              || '           AND IA.DIVISION_ID         = IB.DIVISION_ID(+)' || CHR(10)
              || '           AND IA.OPERATION_GROUP     = IB.OPERATION_GROUP(+)' || CHR(10)
              || '           AND IA.SCM_SITE_ID         = IB.SCM_SITE_ID(+)' || CHR(10)
              || '           AND IA.ITEM_ID             = IB.ITEM_ID(+)' || CHR(10)
              || '           AND IA.MEASURE             = IB.MEASURE(+)' || CHR(10)
              || '           AND IA.MEASURE_NAME        = IB.MEASURE_NAME(+)' || CHR(10)
              || '           AND IA.USER_SORT_ORDER_NO  = IB.USER_SORT_ORDER_NO(+)' || CHR(10)
              || '           AND IA.PLAN_START_YYYYMMDD = IB.PLAN_START_YYYYMMDD(+)' || CHR(10)
              || '           AND IA.PLAN_TYPE           = IB.PLAN_TYPE(+)' || CHR(10)
              || '           AND IA.PLAN_SEQ            = IB.PLAN_SEQ(+)' || CHR(10)
              || '           AND IA.FROM_YYYYMMDD       = IB.FROM_YYYYMMDD(+)' || CHR(10)
              || '           AND IA.TO_YYYYMMDD         = IB.TO_YYYYMMDD(+)' || CHR(10)
              || '           AND IA.ORIGIN_DIVISION_ID  = IB.ORIGIN_DIVISION_ID(+)' || CHR(10)
              || '           AND IA.ELECTRODE_TYPE      = IB.ELECTRODE_TYPE(+)' || CHR(10)
              || '           AND IA.ORIGIN_DIVISION_ID NOT IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_DIVISION_DIV(''EE'')))' || CHR(10);   --div_commonization

        IF V_NICK_YN = 'Y' THEN
            V_SQL := V_SQL
                  || '           AND IA.ITEM_ID IN (SELECT XC.ITEM_ID FROM GT_0011_NICKITEM XC)' || CHR(10);
        END IF;

        V_SQL := V_SQL || '       ) IX' || CHR(10);

        IF V_MODEL_ALL = 'N' THEN
            V_SQL := V_SQL
                  || ' WHERE IX.MODEL_ID IN (SELECT COLUMN_VALUE FROM TABLE(:B_MODEL_TAB))' || CHR(10);
        END IF;

        V_SQL := V_SQL
              || ' ORDER BY IX.DIVISION_ID NULLS FIRST, IX.OPERATION_GROUP NULLS FIRST, IX.SCM_SITE_ID NULLS FIRST, IX.ITEM_ID NULLS FIRST, IX.USER_SORT_ORDER_NO NULLS FIRST';   /* AS-IS 오름차순은 NULL 이 앞 */

        -----------------------------------------------------------
        -- DEBUG QRY 출력
        -----------------------------------------------------------
        IF P_DEBUG_MODE = 'T' THEN
            P_PUT_CLOB(V_SQL);
        END IF;

        IF V_MODEL_ALL = 'N' THEN
            OPEN O_RC1 FOR V_SQL USING V_MODEL_TAB;
        ELSE
            OPEN O_RC1 FOR V_SQL;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('SCP0011_GET_PRODUCTION_PLAN_MODEL'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_OPERATION_GROUP=' || P_OPERATION_GROUP
                     || ', P_SCM_SITE_ID=' || P_SCM_SITE_ID
                     || ', P_MODEL_ID=' || P_MODEL_ID
                     || ', P_ITEM_ID=' || P_ITEM_ID
                     || ', P_FROM_YYYYMMDD=' || P_FROM_YYYYMMDD
                     || ', P_TO_YYYYMMDD=' || P_TO_YYYYMMDD
                     || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_PLAN_TYPE=' || P_PLAN_TYPE
                     || ', P_SEQ=' || P_SEQ
                     || ', P_USER_ID=' || P_USER_ID
                     || ', P_BUCKET=' || P_BUCKET
                     || ', P_TO_PERIOD=' || P_TO_PERIOD
                     || ', P_CHK_ALL=' || P_CHK_ALL
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    END P_SCP0011_GET_PROD_PLAN_MODEL;


    /*==================================================================================================
     * Program ID   : [SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL]
     * Description  : Production Plan MODEL QTY 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/06/11   PJS			   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/06/27   PJS			   key_idx수정, BOH 제거
     * 2018/07/11   byunghunjung   EE 사업부 실적 추가
     * 2018/07/18   YHW			   전극용 조회항목 추가
     * 2018/08/31	YHW			   NICK NAME 조회항목 추가
     * 2018/09/27   ygkim		   생산 실적 조건 추가 (LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회, 외주PACKER의 업체코드)
     * 2021/06/25   kmj			   UI 속도 개선 반영
     * 2021.07.22   LWY			   PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
                                     - scp_anl_production_plan / hist_scp_anl_production_plan 분리작업
     * 2021.10.07   KMJ			   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - UI 속도 개선으로 Bucket별 조회로 수정
     * 2021.11.24   khj79		   PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - p_chk_all 추가 ( 체크 시 bucket='daily' 조회)
     * 2022.05.13   LSC            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
     * 2022.08.31   LWY            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Isuzu 추가
     * 2023.01.02   LWY            PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 조회기준 변경(main / hist) - 당주,전주(main) / 당주,전주 이전(hist)
     * 2023/04/10   LWY			   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
     * 2023.07.26   vadabi3		   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Model, Material 개선
     * 2026.09.17                  [MSSQL -> Oracle 전환] 머리 행 적재 동적 SQL 을 정적 SQL 로 전환(기간 칸만 동적)
     *                             시트 이름 · 사용자 ID 대소문자 무시 비교(AS-IS 정렬규칙 CI 대응)
     * 2026.10.06   AJS            ISUZU 품목 적재 조회 속도 개선 : 품목 뷰를 하위 뷰(SCM_MST_FINAL_ITEM_ORIGIN_DIV_V)로 바꿔 사업부 갈래 중복 전개 제거 (EXISTS 판정 품목 동일)
     *==================================================================================================*/
    PROCEDURE P_SCP0011_GET_PROD_MODEL_TITLE
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_MODEL_ID              IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0011',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'MODEL',
        P_USER_ID               IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT NULL,
        P_NICK_NAME             IN  VARCHAR2 DEFAULT NULL,
        P_BUCKET                IN  VARCHAR2 DEFAULT NULL,
        P_CHK_ALL               IN  VARCHAR2 DEFAULT NULL,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_DIVISION_ID           VARCHAR2(50 CHAR)  := UPPER(P_DIVISION_ID);
        V_OPERATION_GROUP       VARCHAR2(50 CHAR)  := UPPER(P_OPERATION_GROUP);
        V_PLAN_TYPE             VARCHAR2(50 CHAR)  := UPPER(P_PLAN_TYPE);
        V_PROGRAM_ID            VARCHAR2(300 CHAR) := UPPER(P_PROGRAM_ID);
        V_SHEET_NAME            VARCHAR2(150 CHAR) := UPPER(P_SHEET_NAME);
        V_USER_ID               VARCHAR2(150 CHAR) := UPPER(P_USER_ID);
        V_BUCKET                VARCHAR2(10 CHAR)  := UPPER(P_BUCKET);
        V_SEQ                   NUMBER;
        V_PLAN_START_DATE       DATE;

        V_CNT_USR_MEASURE       NUMBER := 0;
        V_MIN_YYYYMMDD          VARCHAR2(8 CHAR);
        V_FROM_YYYYMMDD         VARCHAR2(8 CHAR);
        V_TO_YYYYMMDD           VARCHAR2(8 CHAR);
        V_FROM_RESULT           VARCHAR2(8 CHAR);
        V_TO_RESULT             VARCHAR2(8 CHAR);
        V_FROM_RESULT_DATE      DATE;
        V_TO_RESULT_DATE        DATE;
        V_FROM_CMP              VARCHAR2(8 CHAR);   /* 빈 문자 비교값 */
        V_TO_CMP                VARCHAR2(8 CHAR);

        V_SITE_TAB              T_STR_TAB;
        V_SITE_ALL              VARCHAR2(1 CHAR);
        V_ITEM_TAB              T_STR_TAB;
        V_ITEM_ALL              VARCHAR2(1 CHAR);
        V_ELEC_TAB              T_STR_TAB;
        V_ELEC_ALL              VARCHAR2(1 CHAR);
        V_MODEL_TAB             T_STR_TAB;
        V_MODEL_ALL             VARCHAR2(1 CHAR);
        V_RES_DIV_TAB           T_STR_TAB;
        V_OSP_DIV_TAB           T_STR_TAB;
        V_NICK_YN               VARCHAR2(1 CHAR) := 'N';

        V_QRY_SUM               CLOB;
        V_SQL                   CLOB;
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        V_SEQ             := TO_NUMBER(P_SEQ);
        SELECT TO_DATE(P_PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD')
          INTO V_PLAN_START_DATE
          FROM DUAL;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND UPPER(SHEET_NAME)  = V_SHEET_NAME
           AND UPPER(USER_ID)     = V_USER_ID;

        P_SET_PERIOD(P_PLAN_START_YYYYMMDD, P_FROM_YYYYMMDD, P_TO_YYYYMMDD
                   , V_FROM_YYYYMMDD, V_TO_YYYYMMDD, V_FROM_RESULT, V_TO_RESULT);

        V_FROM_RESULT_DATE := F_STR_DATE(V_FROM_RESULT);
        V_TO_RESULT_DATE   := F_STR_DATE(V_TO_RESULT);
        V_FROM_CMP         := F_CMP(V_FROM_YYYYMMDD);
        V_TO_CMP           := F_CMP(V_TO_YYYYMMDD);

        IF P_DEBUG_MODE = 'T' THEN
            DBMS_OUTPUT.PUT_LINE('----------------------------------');
            DBMS_OUTPUT.PUT_LINE('v_from_yyyymmdd =' || V_FROM_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('v_to_yyyymmdd =' || V_TO_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('v_from_result =' || V_FROM_RESULT);
            DBMS_OUTPUT.PUT_LINE('v_to_result =' || V_TO_RESULT);
            DBMS_OUTPUT.PUT_LINE('----------------------------------');
        END IF;

        P_SPLIT_LIST(P_SCM_SITE_ID   , 'Y', V_SITE_TAB , V_SITE_ALL);
        P_SPLIT_LIST(P_ITEM_ID       , 'Y', V_ITEM_TAB , V_ITEM_ALL);
        P_SPLIT_LIST(P_ELECTRODE_TYPE, 'Y', V_ELEC_TAB , V_ELEC_ALL);
        P_SPLIT_LIST(P_MODEL_ID      , 'Y', V_MODEL_TAB, V_MODEL_ALL);

        -- 2021.11.24 : 체크 시 bucket='daily' 조회
        IF UPPER(P_CHK_ALL) = 'Y' THEN
            V_BUCKET := 'DAILY';
        END IF;

        IF V_DIVISION_ID = 'EE' THEN
            V_RES_DIV_TAB := T_STR_TAB('40', '81', '82');
        ELSIF V_DIVISION_ID = 'EE_UC' THEN
            V_RES_DIV_TAB := T_STR_TAB('81_UC');
        ELSIF V_DIVISION_ID = 'EE_HM' THEN
            V_RES_DIV_TAB := T_STR_TAB('81_HM');
        ELSIF V_DIVISION_ID = 'EE_ST' THEN
            V_RES_DIV_TAB := T_STR_TAB('81_ST');
        ELSE
            V_RES_DIV_TAB := T_STR_TAB(V_DIVISION_ID);
        END IF;

        IF V_DIVISION_ID = 'EE' THEN
            V_OSP_DIV_TAB := T_STR_TAB('40', '81', '82');
        ELSIF V_DIVISION_ID = 'EE_UC' THEN
            V_OSP_DIV_TAB := T_STR_TAB('81_UC');
        ELSE
            V_OSP_DIV_TAB := T_STR_TAB(V_DIVISION_ID);
        END IF;

        /********************************************************************************
        * 임시테이블 초기화
        ********************************************************************************/
        DELETE FROM GT_0011_NICKITEM;
        DELETE FROM GT_0011_ISUZU;
        DELETE FROM GT_0011_TTL_HDR;
        DELETE FROM GT_0011_TTL_MAIN;

        /********************************************************************************
        * 임시테이블만들기 - nick name 조회 시
        ********************************************************************************/
        IF RTRIM(P_NICK_NAME) IS NOT NULL THEN

            V_NICK_YN := 'Y';

            INSERT INTO GT_0011_NICKITEM
                 (
                   ITEM_ID
                 )
            SELECT DISTINCT
                   ITEM_ID
              FROM SCM_MST_ITEM_SN
             WHERE NICK_NAME IS NOT NULL
               AND NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%';     /* 원장 NICK_NAME 소문자 0 건 */

        END IF;

        -- 2022.08.31 start
        -- ISUZU item
        INSERT INTO GT_0011_ISUZU
             (
               ITEM_ID
             )
        SELECT A.ITEM_ID
--          FROM SCM_MST_FINAL_ITEM_V A                                                     --  2026.10.06 AJS
          FROM SCM_MST_FINAL_ITEM_ORIGIN_DIV_V A          /* 품목 뷰 사업부 갈래 중복 전개 제거 - EXISTS 판정 품목 동일 */   --  2026.10.06 AJS
             , SCP_MST_FINAL_ITEM_V B
         WHERE A.ITEM_ID = B.ITEM_ID
           AND A.IS_YN   = 'Y';
        -- 2022.08.31 end

        -- 2023.01.02
        V_MIN_YYYYMMDD := F_PREV_MONDAY;     -- previous monday

        /********************************************************************************
        * 임시테이블만들기 - Header 부분
        ********************************************************************************/
        -- 계획 구간
        IF F_CMP(P_PLAN_START_YYYYMMDD) >= V_MIN_YYYYMMDD THEN

            INSERT INTO GT_0011_TTL_HDR
                 (
                   DIVISION_ID
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,OPERATION_ID
                  ,LINE_ID
                  ,MEASURE
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                 )
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.MEASURE
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
              FROM SCP_ANL_PRODUCTION_PLAN A
             WHERE A.YYYYMMDD                >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD                <= P_TO_YYYYMMDD
               AND A.DIVISION_ID              = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE          /* 파티션 프루닝 */
               AND A.PLAN_TYPE                = V_PLAN_TYPE
               AND A.SEQ                      = V_SEQ
               AND A.OPERATION_GROUP          = V_OPERATION_GROUP
               AND (V_SITE_ALL = 'Y' OR A.SCM_SITE_ID    IN (SELECT COLUMN_VALUE FROM TABLE(V_SITE_TAB)))
               AND (V_ITEM_ALL = 'Y' OR A.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
               AND (V_ELEC_ALL = 'Y' OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)));

        ELSIF F_CMP(P_PLAN_START_YYYYMMDD) < V_MIN_YYYYMMDD THEN

            INSERT INTO GT_0011_TTL_HDR
                 (
                   DIVISION_ID
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,OPERATION_ID
                  ,LINE_ID
                  ,MEASURE
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                 )
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.MEASURE
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
              FROM HIST_SCP_ANL_PRODUCTION_PLAN A
             WHERE A.YYYYMMDD                >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD                <= P_TO_YYYYMMDD
               AND A.DIVISION_ID              = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE          /* 파티션 프루닝 */
               AND A.PLAN_TYPE                = V_PLAN_TYPE
               AND A.SEQ                      = V_SEQ
               AND A.OPERATION_GROUP          = V_OPERATION_GROUP
               AND (V_SITE_ALL = 'Y' OR A.SCM_SITE_ID    IN (SELECT COLUMN_VALUE FROM TABLE(V_SITE_TAB)))
               AND (V_ITEM_ALL = 'Y' OR A.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
               AND (V_ELEC_ALL = 'Y' OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)));

        END IF;

        -- anl 테이블에는 과거구간 YYYYMMDD가 없으므로 실적 테이블에서 YYYYMMDD를 조회하여 추가해준다.
        INSERT INTO GT_0011_TTL_HDR
             (
               DIVISION_ID
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,OPERATION_ID
              ,LINE_ID
              ,MEASURE
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
             )
        SELECT V_DIVISION_ID                                        AS DIVISION_ID     --div_commonization
             , A.SCP_OPERATION_GROUP                                AS OPERATION_GROUP
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , 'PROD_PLAN_ENGINE'                                   AS MEASURE
             , A.DIVISION_ID                                        AS ORIGIN_DIVISION_ID
             , A.ELECTRODE_TYPE
          FROM SCM_DNM_PRODUCT_RESULT_V A
         WHERE (   SUBSTR(A.OPERATION_ID, 1, 5) IN (SELECT XA.SEGMENT1     --LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
                                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                                                     WHERE XA.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                                       AND XA.SEGMENT1   <> 'F6000')
                -- 2022.08.31 start
                OR (    A.OPERATION_ID LIKE 'P5000%'
                    AND EXISTS (SELECT 1
                                  FROM GT_0011_ISUZU XB
                                 WHERE XB.ITEM_ID = A.ITEM_ID))
                -- 2022.08.31 end
                OR A.OPERATION_ID IN (SELECT XC.PLANT_ID                    --외주PACKER의 업체코드
                                        FROM SCM_MST_SITE XC
                                       WHERE XC.DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_OSP_DIV_TAB))
                                         AND XC.SITE_TYPE    = 'PLANT'
                                         AND XC.OSP_YN       = 'Y'
                                         AND XC.VALID_YN     = 'Y'))
           AND A.PLAN_DATE           >= V_FROM_RESULT_DATE
           AND A.PLAN_DATE           <  V_TO_RESULT_DATE                  -- equal 표시 주의할것
           AND A.DIVISION_ID         IN (SELECT COLUMN_VALUE FROM TABLE(V_RES_DIV_TAB))
           AND A.SCP_OPERATION_GROUP  = V_OPERATION_GROUP
           AND A.SCM_SITE_ID         IS NOT NULL
           AND (V_SITE_ALL = 'Y' OR A.SCM_SITE_ID    IN (SELECT COLUMN_VALUE FROM TABLE(V_SITE_TAB)))
           AND (V_ITEM_ALL = 'Y' OR A.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
           AND (V_ELEC_ALL = 'Y' OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)));

        /* GT_0011_TTL_HDR 통계 수집(DBMS_STATS)은 넣지 않는다 - 임시 테이블이라도 트랜잭션이 확정되어 호출 측 작업이 함께 확정된다 */

        /********************************************************************************
        * 데이타조회, 임시테이블에 저장 - Main : #TblDynamicPivot_SCP0011_01
        ********************************************************************************/
        INSERT INTO GT_0011_TTL_MAIN
             (
               KEY_IDX
              ,DIVISION_ID
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,MEASURE
              ,MEASURE_NAME
              ,USER_SORT_ORDER_NO
              ,FROM_YYYYMMDD
              ,TO_YYYYMMDD
              ,PLAN_START_YYYYMMDD
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
             )
        SELECT CASE
                   WHEN    IA.DIVISION_ID     IS NULL
                        OR IA.OPERATION_GROUP IS NULL
                        OR IA.SCM_SITE_ID     IS NULL
                        OR IA.ITEM_ID         IS NULL
                        OR IA.MEASURE         IS NULL
                   THEN NULL        /* AS-IS 문자열 결합은 NULL 이 섞이면 NULL */
                   ELSE IA.DIVISION_ID || IA.OPERATION_GROUP || IA.SCM_SITE_ID || IA.ITEM_ID || IA.MEASURE
               END                                                  AS KEY_IDX
             , IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.SCM_SITE_ID
             , IA.ITEM_ID
             , P_PLAN_TYPE                                          AS PLAN_TYPE
             , P_SEQ                                                AS PLAN_SEQ
             , IA.MEASURE
             , IA.MEASURE_NAME
             , IA.USER_SORT_ORDER_NO
             , P_FROM_YYYYMMDD                                      AS FROM_YYYYMMDD
             , P_TO_YYYYMMDD                                        AS TO_YYYYMMDD
             , P_PLAN_START_YYYYMMDD                                AS PLAN_START_YYYYMMDD
             , IA.ORIGIN_DIVISION_ID
             , IA.ELECTRODE_TYPE
          FROM (SELECT XC.DIVISION_ID
                     , XC.OPERATION_GROUP
                     , XC.SCM_SITE_ID
                     , XC.ITEM_ID
                     , XC.LINE_ID
                     , XC.OPERATION_ID
                     , XA.COLUMN_NAME                               AS MEASURE
                     , XA.COLUMN_LABEL_NAME                         AS MEASURE_NAME
                     , NVL(XB.SORT_ORDER_NO, XA.SORT_ORDER_NO)      AS USER_SORT_ORDER_NO
                     , XC.ORIGIN_DIVISION_ID
                     , XC.ELECTRODE_TYPE
                  FROM SCM_MST_SHEET_MEASURE    XA
                     , SCM_MST_TITLESET_USER    XB
                     , GT_0011_TTL_HDR          XC      -- Header : #TblDynamicPivot_SCP0011_02
                 WHERE XA.PROGRAM_ID          = XB.PROGRAM_ID(+)
                   AND UPPER(XA.SHEET_NAME)   = UPPER(XB.SHEET_NAME(+))
                   AND UPPER(XA.COLUMN_NAME)  = UPPER(XB.COLUMN_NAME(+))
                   AND UPPER(XB.USER_ID(+))   = V_USER_ID
                   AND (   V_CNT_USR_MEASURE = 0
                        OR EXISTS (SELECT 1
                                     FROM SCM_MST_TITLESET_USER SA
                                    WHERE SA.PROGRAM_ID         = V_PROGRAM_ID
                                      AND UPPER(SA.SHEET_NAME)  = V_SHEET_NAME
                                      AND UPPER(SA.USER_ID)     = V_USER_ID
                                      AND UPPER(SA.COLUMN_NAME) = UPPER(XA.COLUMN_NAME)))
                   AND XA.VALID_YN            = 'Y'
                   AND XA.PROGRAM_ID          = V_PROGRAM_ID
                   AND UPPER(XA.SHEET_NAME)   = V_SHEET_NAME
                   AND (   V_OPERATION_GROUP = 'A'
                        OR XA.ATTRIBUTE1 IS NULL
                        OR XA.ATTRIBUTE1 <> 'A')
                 GROUP BY XC.DIVISION_ID
                        , XC.OPERATION_GROUP
                        , XC.SCM_SITE_ID
                        , XC.ITEM_ID
                        , XC.LINE_ID
                        , XC.OPERATION_ID
                        , XA.COLUMN_NAME
                        , XA.COLUMN_LABEL_NAME
                        , XC.ORIGIN_DIVISION_ID
                        , XC.ELECTRODE_TYPE
                        , NVL(XB.SORT_ORDER_NO, XA.SORT_ORDER_NO)) IA;

        /* GT_0011_TTL_MAIN 통계 수집(DBMS_STATS)은 넣지 않는다 - 임시 테이블이라도 트랜잭션이 확정되어 호출 측 작업이 함께 확정된다 */

        /********************************************************************************
        * PIVOIT처리 - 칸 값은 모두 '0'
        ********************************************************************************/
        -- PIVOIT 대상 날짜문자열 생성
        V_QRY_SUM := NULL;

        FOR R IN (SELECT IA.COL_NAME
                    FROM (SELECT 'W_' || XA.BASIS_YYYYMM || XA.ISO_WEEK             AS COL_NAME
                               , XA.BASIS_START_DATE || '21'                        AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M XA
                           WHERE XA.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             AND (V_BUCKET = 'DAILY' OR V_BUCKET = 'WEEKLY')
                           GROUP BY XA.BASIS_YYYYMM
                                  , XA.ISO_WEEK
                                  , XA.BASIS_START_DATE
                           UNION ALL
                          SELECT 'M_' || XB.BASIS_YYYYMM                            AS COL_NAME
                               , MIN(XB.BASIS_START_DATE) || '01'                   AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M XB
                           WHERE XB.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY XB.BASIS_YYYYMM
                                  , XB.MONTH_NAME
                           UNION ALL
                          SELECT 'D_' || XC.BASIS_YYYYMMDD                          AS COL_NAME
                               , XC.BASIS_YYYYMMDD || '31'                          AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M XC
                           WHERE XC.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             AND V_BUCKET = 'DAILY'
                           GROUP BY XC.BASIS_YYYYMMDD) IA
                   ORDER BY IA.SORT_ORDER_NO)
        LOOP
            V_QRY_SUM := V_QRY_SUM || '             , ''0'' AS ' || R.COL_NAME || CHR(10);
        END LOOP;

        V_SQL := 'SELECT IX.*' || CHR(10)
              || '  FROM (SELECT XA.KEY_IDX' || CHR(10)
              || '             , XA.DIVISION_ID' || CHR(10)
              || '             , XA.DIVISION_ID AS DIVISION_NAME' || CHR(10)
              || '             , XA.OPERATION_GROUP' || CHR(10)
              || '             , FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP'', XA.OPERATION_GROUP) AS OPERATION_GROUP_NAME' || CHR(10)
              || '             , XA.SCM_SITE_ID' || CHR(10)
              || '             , FN_GET_SCM_SITE_DESCRIPTION(XA.DIVISION_ID, XA.SCM_SITE_ID) AS SCM_SITE_DESCRIPTION' || CHR(10)
              || '             , FN_GET_ITEM_PROD_OP(XA.DIVISION_ID, XA.OPERATION_GROUP, XA.ITEM_ID) AS MODEL_ID' || CHR(10)
              || '             , XA.ITEM_ID' || CHR(10)
              || '             , NVL(FN_GET_ITEM_NICKNAME(XA.DIVISION_ID, XA.ITEM_ID), ''-'') AS NICK_NAME' || CHR(10)
              || '             , FN_GET_SCP_ANL_BOH_QTY(XA.DIVISION_ID, XA.PLAN_START_YYYYMMDD, XA.PLAN_TYPE, TO_NUMBER(XA.PLAN_SEQ), XA.SCM_SITE_ID, XA.ITEM_ID, XA.FROM_YYYYMMDD) AS BOH' || CHR(10)
              || '             , XA.MEASURE' || CHR(10)
              || '             , XA.MEASURE_NAME' || CHR(10)
              || '             , XA.USER_SORT_ORDER_NO' || CHR(10)
              || '             , XA.PLAN_START_YYYYMMDD' || CHR(10)
              || '             , XA.PLAN_TYPE' || CHR(10)
              || '             , XA.PLAN_SEQ' || CHR(10)
              || '             , XA.FROM_YYYYMMDD' || CHR(10)
              || '             , XA.TO_YYYYMMDD' || CHR(10)
              || '             , XA.ORIGIN_DIVISION_ID' || CHR(10)
              || '             , XA.ELECTRODE_TYPE' || CHR(10)
              || V_QRY_SUM
              || '          FROM GT_0011_TTL_MAIN XA' || CHR(10)
              || '         WHERE XA.ORIGIN_DIVISION_ID NOT IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_DIVISION_DIV(''EE'')))' || CHR(10);   --div_commonization

        IF V_NICK_YN = 'Y' THEN
            V_SQL := V_SQL
                  || '           AND XA.ITEM_ID IN (SELECT XB.ITEM_ID FROM GT_0011_NICKITEM XB)' || CHR(10);
        END IF;

        V_SQL := V_SQL
              || '         GROUP BY XA.KEY_IDX, XA.DIVISION_ID, XA.OPERATION_GROUP, XA.SCM_SITE_ID, XA.ITEM_ID, XA.MEASURE, XA.MEASURE_NAME, XA.USER_SORT_ORDER_NO' || CHR(10)
              || '                , XA.PLAN_START_YYYYMMDD, XA.PLAN_TYPE, XA.PLAN_SEQ, XA.FROM_YYYYMMDD, XA.TO_YYYYMMDD, XA.ORIGIN_DIVISION_ID, XA.ELECTRODE_TYPE' || CHR(10)
              || '       ) IX' || CHR(10);

        IF V_MODEL_ALL = 'N' THEN
            V_SQL := V_SQL
                  || ' WHERE IX.MODEL_ID IN (SELECT COLUMN_VALUE FROM TABLE(:B_MODEL_TAB))' || CHR(10);
        END IF;

        V_SQL := V_SQL
              || ' ORDER BY IX.DIVISION_ID NULLS FIRST, IX.OPERATION_GROUP NULLS FIRST, IX.SCM_SITE_ID NULLS FIRST, IX.ITEM_ID NULLS FIRST, IX.USER_SORT_ORDER_NO NULLS FIRST';   /* AS-IS 오름차순은 NULL 이 앞 */

        -----------------------------------------------------------
        -- DEBUG QRY 출력
        -----------------------------------------------------------
        IF P_DEBUG_MODE = 'T' THEN
            P_PUT_CLOB(V_SQL);
        END IF;

        IF V_MODEL_ALL = 'N' THEN
            OPEN O_RC1 FOR V_SQL USING V_MODEL_TAB;
        ELSE
            OPEN O_RC1 FOR V_SQL;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_OPERATION_GROUP=' || P_OPERATION_GROUP
                     || ', P_SCM_SITE_ID=' || P_SCM_SITE_ID
                     || ', P_MODEL_ID=' || P_MODEL_ID
                     || ', P_ITEM_ID=' || P_ITEM_ID
                     || ', P_FROM_YYYYMMDD=' || P_FROM_YYYYMMDD
                     || ', P_TO_YYYYMMDD=' || P_TO_YYYYMMDD
                     || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_PLAN_TYPE=' || P_PLAN_TYPE
                     || ', P_SEQ=' || P_SEQ
                     || ', P_USER_ID=' || P_USER_ID
                     || ', P_BUCKET=' || P_BUCKET
                     || ', P_CHK_ALL=' || P_CHK_ALL
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    END P_SCP0011_GET_PROD_MODEL_TITLE;


    /*==================================================================================================
     * Program ID   : SCP0011_GET_PRODUCTION_PLAN_LINE
     * Description  : Production Plan Line Header 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/01/22   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/02/13   PJS   성능개선  PIVOT제거, CASE SUM방식으로 변경
     * 2018/04/17   PJS   임시테이블 삭제 OBJECT_ID형식으로 변경
     * 2018/05/28   byunghunjung 실적 테이블 값 조회시 scp_operation_group 조회조건 추가
     * 2018/05/29   PJS 주Sum 집계방식 변경
     * 2018/07/11   byunghunjung EE 사업부 실적 추가
     * 2018/07/18   YHW				전극용 조회항목 추가
     * 2021.10.25   khj79			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 이력 테이블 분리(SCP_ANL_PRODUCTION_PLAN / HIST_SCP_ANL_PRODUCTION_PLAN)
     * 2022.05.13   LSC             PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
     * 2023/01/02   LWY             PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 조회기준 변경(main / hist) - 당주,전주(main) / 당주,전주 이전(hist)
     * 2023/04/10   LWY				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
     * 2023.07.26   vadabi3		   PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Model, Material 개선
     * 2026.09.17                  [MSSQL -> Oracle 전환] 시트 이름 · 사용자 ID 대소문자 무시 비교(AS-IS 정렬규칙 CI 대응)
     *==================================================================================================*/
    PROCEDURE P_SCP0011_GET_PROD_PLAN_LINE
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0011',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'LINE',
        P_USER_ID               IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT NULL,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_DIVISION_ID           VARCHAR2(50 CHAR)  := UPPER(P_DIVISION_ID);
        V_OPERATION_GROUP       VARCHAR2(50 CHAR)  := UPPER(P_OPERATION_GROUP);
        V_SCM_SITE_ID           VARCHAR2(150 CHAR) := UPPER(P_SCM_SITE_ID);
        V_ITEM_ID               VARCHAR2(300 CHAR) := UPPER(P_ITEM_ID);
        V_PLAN_TYPE             VARCHAR2(50 CHAR)  := UPPER(P_PLAN_TYPE);
        V_PROGRAM_ID            VARCHAR2(300 CHAR) := UPPER(P_PROGRAM_ID);
        V_SHEET_NAME            VARCHAR2(150 CHAR) := UPPER(P_SHEET_NAME);
        V_USER_ID               VARCHAR2(150 CHAR) := UPPER(P_USER_ID);
        V_SEQ                   NUMBER;
        V_PLAN_START_DATE       DATE;

        V_CNT_USR_MEASURE       NUMBER := 0;
        V_MIN_YYYYMMDD          VARCHAR2(8 CHAR);
        V_FROM_YYYYMMDD         VARCHAR2(8 CHAR);
        V_TO_YYYYMMDD           VARCHAR2(8 CHAR);
        V_FROM_RESULT           VARCHAR2(8 CHAR);
        V_TO_RESULT             VARCHAR2(8 CHAR);
        V_FROM_RESULT_DATE      DATE;
        V_TO_RESULT_DATE        DATE;
        V_FROM_CMP              VARCHAR2(8 CHAR);   /* 빈 문자 비교값 */
        V_TO_CMP                VARCHAR2(8 CHAR);

        V_SITE_TAB              T_STR_TAB;
        V_SITE_ALL              VARCHAR2(1 CHAR);
        V_ITEM_TAB              T_STR_TAB;
        V_ITEM_ALL              VARCHAR2(1 CHAR);
        V_ELEC_TAB              T_STR_TAB;
        V_ELEC_ALL              VARCHAR2(1 CHAR);

        V_QRY_SUM               CLOB;
        V_SQL                   CLOB;
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        V_SEQ             := TO_NUMBER(P_SEQ);
        SELECT TO_DATE(P_PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD')
          INTO V_PLAN_START_DATE
          FROM DUAL;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE PROGRAM_ID         = V_PROGRAM_ID
           AND UPPER(SHEET_NAME)  = V_SHEET_NAME
           AND UPPER(USER_ID)     = V_USER_ID;

        P_SET_PERIOD(P_PLAN_START_YYYYMMDD, P_FROM_YYYYMMDD, P_TO_YYYYMMDD
                   , V_FROM_YYYYMMDD, V_TO_YYYYMMDD, V_FROM_RESULT, V_TO_RESULT);

        V_FROM_RESULT_DATE := F_STR_DATE(V_FROM_RESULT);
        V_TO_RESULT_DATE   := F_STR_DATE(V_TO_RESULT);
        V_FROM_CMP         := F_CMP(V_FROM_YYYYMMDD);
        V_TO_CMP           := F_CMP(V_TO_YYYYMMDD);

        IF P_DEBUG_MODE = 'T' THEN
            DBMS_OUTPUT.PUT_LINE('----------------------------------');
            DBMS_OUTPUT.PUT_LINE('v_from_yyyymmdd =' || V_FROM_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('v_to_yyyymmdd =' || V_TO_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('v_from_result =' || V_FROM_RESULT);
            DBMS_OUTPUT.PUT_LINE('v_to_result =' || V_TO_RESULT);
            DBMS_OUTPUT.PUT_LINE('----------------------------------');
            DBMS_OUTPUT.PUT_LINE('');
        END IF;

        /* 생산실적 조회 조건은 쉼표 목록, 계획 조회 조건은 단일 값이다 (AS-IS 원문 그대로) */
        P_SPLIT_LIST(P_SCM_SITE_ID   , 'Y', V_SITE_TAB, V_SITE_ALL);
        P_SPLIT_LIST(P_ITEM_ID       , 'Y', V_ITEM_TAB, V_ITEM_ALL);
        P_SPLIT_LIST(P_ELECTRODE_TYPE, 'Y', V_ELEC_TAB, V_ELEC_ALL);

        -- 2023.01.02
        V_MIN_YYYYMMDD := F_PREV_MONDAY;     -- previous monday

        /********************************************************************************
        * 임시테이블 초기화
        ********************************************************************************/
        DELETE FROM GT_0011_LINE;

        /********************************************************************************
        * 데이타조회, 임시테이블에 저장
        ********************************************************************************/
        -- 2021.10.25 : 이력 테이블 분리
        IF F_CMP(P_PLAN_START_YYYYMMDD) >= V_MIN_YYYYMMDD THEN

            INSERT INTO GT_0011_LINE
                 (
                   DIVISION_ID
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,LINE_ID
                  ,ITEM_ID
                  ,MEASURE
                  ,MEASURE_NAME
                  ,USER_SORT_ORDER_NO
                  ,OPERATION_ID
                  ,PLAN_TYPE
                  ,PLAN_SEQ
                  ,FROM_YYYYMMDD
                  ,PLAN_START_YYYYMMDD
                  ,YYYYMMDD
                  ,YYYYMM
                  ,ISO_WEEK
                  ,QTY
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                 )
            SELECT IA.DIVISION_ID
                 , IA.OPERATION_GROUP
                 , IA.SCM_SITE_ID
                 , IA.LINE_ID
                 , IA.ITEM_ID
                 , IA.MEASURE
                 , IA.MEASURE_NAME
                 , IA.USER_SORT_ORDER_NO
                 , IA.OPERATION_ID
                 , P_PLAN_TYPE                                      AS PLAN_TYPE
                 , P_SEQ                                            AS PLAN_SEQ
                 , P_FROM_YYYYMMDD                                  AS FROM_YYYYMMDD
                 , P_PLAN_START_YYYYMMDD                            AS PLAN_START_YYYYMMDD
                 , 'D_' || IA.YYYYMMDD                              AS YYYYMMDD
                 , C.BASIS_YYYYMM                                   AS YYYYMM
                 , SUBSTR(C.BASIS_YYYYMM, -4) || C.ISO_WEEK         AS ISO_WEEK
                 , IB.QTY
                 , IA.ORIGIN_DIVISION_ID
                 , IA.ELECTRODE_TYPE
              FROM (SELECT XC.DIVISION_ID
                         , XC.PLAN_START_YYYYMMDD
                         , XC.PLAN_TYPE
                         , XC.SEQ
                         , XC.OPERATION_GROUP
                         , XC.SCM_SITE_ID
                         , XC.ITEM_ID
                         , XC.LINE_ID
                         , XC.OPERATION_ID
                         , XA.COLUMN_NAME                           AS MEASURE
                         , XA.COLUMN_LABEL_NAME                     AS MEASURE_NAME
                         , NVL(XB.SORT_ORDER_NO, XA.SORT_ORDER_NO)  AS USER_SORT_ORDER_NO
                         , XC.YYYYMMDD
                         , XC.ORIGIN_DIVISION_ID
                         , XC.ELECTRODE_TYPE
                      FROM SCM_MST_SHEET_MEASURE    XA
                         , SCM_MST_TITLESET_USER    XB
                         , (SELECT SA.DIVISION_ID
                                 , SA.PLAN_START_YYYYMMDD
                                 , SA.PLAN_TYPE
                                 , SA.SEQ
                                 , SA.OPERATION_GROUP
                                 , SA.SCM_SITE_ID
                                 , SA.ITEM_ID
                                 , SA.OPERATION_ID
                                 , SA.LINE_ID
                                 , SA.MEASURE
                                 , SA.YYYYMMDD
                                 , NVL(SA.ORIGIN_DIVISION_ID, '-')  AS ORIGIN_DIVISION_ID
                                 , NVL(SA.ELECTRODE_TYPE, '-')      AS ELECTRODE_TYPE
                              FROM SCP_ANL_PRODUCTION_PLAN SA
                             WHERE SA.YYYYMMDD                >= P_FROM_YYYYMMDD
                               AND SA.YYYYMMDD                <= P_TO_YYYYMMDD
                               AND SA.DIVISION_ID              = V_DIVISION_ID
                               AND SA.OPERATION_GROUP          = V_OPERATION_GROUP
                               AND SA.SCM_SITE_ID              = V_SCM_SITE_ID
                               AND SA.ITEM_ID                  = V_ITEM_ID
                               AND SA.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
                               AND SA.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE     /* 파티션 프루닝 */
                               AND SA.PLAN_TYPE                = V_PLAN_TYPE
                               AND SA.SEQ                      = V_SEQ
                               AND (V_ELEC_ALL = 'Y' OR NVL(SA.ELECTRODE_TYPE, '-') IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)))
                             GROUP BY SA.DIVISION_ID
                                    , SA.PLAN_START_YYYYMMDD
                                    , SA.PLAN_TYPE
                                    , SA.SEQ
                                    , SA.OPERATION_GROUP
                                    , SA.SCM_SITE_ID
                                    , SA.ITEM_ID
                                    , SA.LINE_ID
                                    , SA.OPERATION_ID
                                    , SA.MEASURE
                                    , SA.YYYYMMDD
                                    , SA.ORIGIN_DIVISION_ID
                                    , SA.ELECTRODE_TYPE
                             UNION ALL
                            -- 생산실적
                            -- Plan 테이블에는 실적 보고자 하는 YYYYMMDD가 없으므로 생성을 위해 추가
                            SELECT V_DIVISION_ID                    AS DIVISION_ID     -- div_commonization
                                 , P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                                 , P_PLAN_TYPE                      AS PLAN_TYPE
                                 , V_SEQ                            AS SEQ
                                 , SB.SCP_OPERATION_GROUP           AS OPERATION_GROUP
                                 , SB.SCM_SITE_ID
                                 , SB.ITEM_ID
                                 , SB.OPERATION_ID
                                 , SB.LINE_ID
                                 , 'PROD_PLAN_ENGINE'               AS MEASURE
                                 , TO_CHAR(SB.PLAN_DATE, 'YYYYMMDD') AS YYYYMMDD
                                 , SB.DIVISION_ID                   AS ORIGIN_DIVISION_ID
                                 , NVL(SB.ELECTRODE_TYPE, '-')      AS ELECTRODE_TYPE
                              FROM SCM_DNM_PRODUCT_RESULT_V SB
                             WHERE SB.DIVISION_ID IN (SELECT SC.DIVISION_ID      --div_commonization
                                                        FROM SCM_MST_DIVISION SC
                                                       WHERE SC.ATTRIBUTE4 IN (SELECT SD.ATTRIBUTE4
                                                                                 FROM SCM_MST_DIVISION SD
                                                                                WHERE SD.DIVISION_ID = V_DIVISION_ID
                                                                                  AND SD.ATTRIBUTE3  = 'EE')
                                                         AND SC.ATTRIBUTE3 <> 'EE'
                                                       UNION ALL
                                                      SELECT V_DIVISION_ID
                                                        FROM DUAL)
                               AND SB.PLAN_DATE           >= V_FROM_RESULT_DATE
                               AND SB.PLAN_DATE           <  V_TO_RESULT_DATE      -- equal 표시 주의할것
                               AND SB.SCP_OPERATION_GROUP  = V_OPERATION_GROUP
                               AND (V_SITE_ALL = 'Y' OR SB.SCM_SITE_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_SITE_TAB)))
                               AND (V_ITEM_ALL = 'Y' OR SB.ITEM_ID     IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
                               AND (V_ELEC_ALL = 'Y' OR NVL(SB.ELECTRODE_TYPE, '-') IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)))
                             GROUP BY SB.DIVISION_ID
                                    , SB.SCP_OPERATION_GROUP
                                    , SB.SCM_SITE_ID
                                    , SB.ITEM_ID
                                    , SB.LINE_ID
                                    , SB.OPERATION_ID
                                    , SB.PLAN_DATE
                                    , SB.ELECTRODE_TYPE) XC
                     WHERE XA.PROGRAM_ID          = XB.PROGRAM_ID(+)
                       AND UPPER(XA.SHEET_NAME)   = UPPER(XB.SHEET_NAME(+))
                       AND UPPER(XA.COLUMN_NAME)  = UPPER(XB.COLUMN_NAME(+))
                       AND UPPER(XB.USER_ID(+))   = V_USER_ID
                       AND (   V_CNT_USR_MEASURE = 0
                            OR EXISTS (SELECT 1
                                         FROM SCM_MST_TITLESET_USER SE
                                        WHERE SE.PROGRAM_ID         = V_PROGRAM_ID
                                          AND UPPER(SE.SHEET_NAME)  = V_SHEET_NAME
                                          AND UPPER(SE.USER_ID)     = V_USER_ID
                                          AND UPPER(SE.COLUMN_NAME) = UPPER(XA.COLUMN_NAME)))
                       AND XA.PROGRAM_ID          = V_PROGRAM_ID
                       AND UPPER(XA.SHEET_NAME)   = V_SHEET_NAME
                       AND XA.VALID_YN            = 'Y'
                     GROUP BY XC.DIVISION_ID
                            , XC.PLAN_START_YYYYMMDD
                            , XC.PLAN_TYPE
                            , XC.SEQ
                            , XC.OPERATION_GROUP
                            , XC.SCM_SITE_ID
                            , XC.ITEM_ID
                            , XC.LINE_ID
                            , XC.OPERATION_ID
                            , XA.COLUMN_NAME
                            , XA.COLUMN_LABEL_NAME
                            , XC.YYYYMMDD
                            , NVL(XB.SORT_ORDER_NO, XA.SORT_ORDER_NO)
                            , XC.ORIGIN_DIVISION_ID
                            , XC.ELECTRODE_TYPE) IA
                 , (  -- 계획
                    SELECT XD.DIVISION_ID
                         , XD.OPERATION_GROUP
                         , XD.SCM_SITE_ID
                         , XD.ITEM_ID
                         , XD.OPERATION_ID
                         , XD.LINE_ID
                         , XD.MEASURE
                         , XD.YYYYMMDD
                         , XD.QTY
                         , NVL(XD.ORIGIN_DIVISION_ID, '-')          AS ORIGIN_DIVISION_ID
                         , NVL(XD.ELECTRODE_TYPE, '-')              AS ELECTRODE_TYPE
                      FROM SCP_ANL_PRODUCTION_PLAN XD
                     WHERE XD.YYYYMMDD                >= V_FROM_CMP
                       AND XD.YYYYMMDD                <= V_TO_CMP
                       AND XD.DIVISION_ID              = V_DIVISION_ID
                       AND XD.OPERATION_GROUP          = V_OPERATION_GROUP
                       AND XD.SCM_SITE_ID              = V_SCM_SITE_ID
                       AND XD.ITEM_ID                  = V_ITEM_ID
                       AND XD.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
                       AND XD.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE     /* 파티션 프루닝 */
                       AND XD.PLAN_TYPE                = V_PLAN_TYPE
                       AND XD.SEQ                      = V_SEQ
                       AND (V_ELEC_ALL = 'Y' OR NVL(XD.ELECTRODE_TYPE, '-') IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)))
                     UNION ALL
                    -- 생산실적
                    SELECT V_DIVISION_ID                            AS DIVISION_ID     --div_commonization
                         , XE.SCP_OPERATION_GROUP                   AS OPERATION_GROUP
                         , XE.SCM_SITE_ID
                         , XE.ITEM_ID
                         , XE.OPERATION_ID
                         , XE.LINE_ID
                         , 'PROD_PLAN_ENGINE'                       AS MEASURE
                         , TO_CHAR(XE.PLAN_DATE, 'YYYYMMDD')        AS YYYYMMDD
                         , XE.ACTUAL_GOOD_QTY                       AS QTY
                         , XE.DIVISION_ID                           AS ORIGIN_DIVISION_ID
                         , NVL(XE.ELECTRODE_TYPE, '-')              AS ELECTRODE_TYPE
                      FROM SCM_DNM_PRODUCT_RESULT_V XE
                     WHERE XE.DIVISION_ID IN (SELECT SF.DIVISION_ID      --div_commonization
                                                FROM SCM_MST_DIVISION SF
                                               WHERE SF.ATTRIBUTE4 IN (SELECT SG.ATTRIBUTE4
                                                                         FROM SCM_MST_DIVISION SG
                                                                        WHERE SG.DIVISION_ID = V_DIVISION_ID
                                                                          AND SG.ATTRIBUTE3  = 'EE')
                                                 AND SF.ATTRIBUTE3 <> 'EE'
                                               UNION ALL
                                              SELECT V_DIVISION_ID
                                                FROM DUAL)
                       AND XE.PLAN_DATE           >= V_FROM_RESULT_DATE
                       AND XE.PLAN_DATE           <  V_TO_RESULT_DATE      -- equal 표시 주의할것
                       AND XE.SCP_OPERATION_GROUP  = V_OPERATION_GROUP
                       AND XE.SCM_SITE_ID          = V_SCM_SITE_ID
                       AND XE.ITEM_ID              = V_ITEM_ID
                       AND (V_ELEC_ALL = 'Y' OR NVL(XE.ELECTRODE_TYPE, '-') IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)))) IB
                 , SCM_SYS_CALENDAR_M C
             WHERE IA.DIVISION_ID        = IB.DIVISION_ID(+)
               AND IA.OPERATION_GROUP    = IB.OPERATION_GROUP(+)
               AND IA.SCM_SITE_ID        = IB.SCM_SITE_ID(+)
               AND IA.ITEM_ID            = IB.ITEM_ID(+)
               AND IA.OPERATION_ID       = IB.OPERATION_ID(+)
               AND IA.LINE_ID            = IB.LINE_ID(+)
               AND IA.MEASURE            = IB.MEASURE(+)
               AND IA.YYYYMMDD           = IB.YYYYMMDD(+)
               AND IA.ORIGIN_DIVISION_ID = IB.ORIGIN_DIVISION_ID(+)
               AND IA.ELECTRODE_TYPE     = IB.ELECTRODE_TYPE(+)
               AND IA.YYYYMMDD           = C.BASIS_YYYYMMDD
                -- 조회조건 추가부분 (Model Tab에서만 사용하는 REQUIREMENT , FORMATION_YIELD Measure는 *로 입력되어 Line조회시 제외함)
               AND IA.LINE_ID           IS NOT NULL
               AND IA.LINE_ID           <> '*';

        ELSIF F_CMP(P_PLAN_START_YYYYMMDD) < V_MIN_YYYYMMDD THEN

            INSERT INTO GT_0011_LINE
                 (
                   DIVISION_ID
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,LINE_ID
                  ,ITEM_ID
                  ,MEASURE
                  ,MEASURE_NAME
                  ,USER_SORT_ORDER_NO
                  ,OPERATION_ID
                  ,PLAN_TYPE
                  ,PLAN_SEQ
                  ,FROM_YYYYMMDD
                  ,PLAN_START_YYYYMMDD
                  ,YYYYMMDD
                  ,YYYYMM
                  ,ISO_WEEK
                  ,QTY
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                 )
            SELECT IA.DIVISION_ID
                 , IA.OPERATION_GROUP
                 , IA.SCM_SITE_ID
                 , IA.LINE_ID
                 , IA.ITEM_ID
                 , IA.MEASURE
                 , IA.MEASURE_NAME
                 , IA.USER_SORT_ORDER_NO
                 , IA.OPERATION_ID
                 , P_PLAN_TYPE                                      AS PLAN_TYPE
                 , P_SEQ                                            AS PLAN_SEQ
                 , P_FROM_YYYYMMDD                                  AS FROM_YYYYMMDD
                 , P_PLAN_START_YYYYMMDD                            AS PLAN_START_YYYYMMDD
                 , 'D_' || IA.YYYYMMDD                              AS YYYYMMDD
                 , C.BASIS_YYYYMM                                   AS YYYYMM
                 , SUBSTR(C.BASIS_YYYYMM, -4) || C.ISO_WEEK         AS ISO_WEEK
                 , IB.QTY
                 , IA.ORIGIN_DIVISION_ID
                 , IA.ELECTRODE_TYPE
              FROM (SELECT XC.DIVISION_ID
                         , XC.PLAN_START_YYYYMMDD
                         , XC.PLAN_TYPE
                         , XC.SEQ
                         , XC.OPERATION_GROUP
                         , XC.SCM_SITE_ID
                         , XC.ITEM_ID
                         , XC.LINE_ID
                         , XC.OPERATION_ID
                         , XA.COLUMN_NAME                           AS MEASURE
                         , XA.COLUMN_LABEL_NAME                     AS MEASURE_NAME
                         , NVL(XB.SORT_ORDER_NO, XA.SORT_ORDER_NO)  AS USER_SORT_ORDER_NO
                         , XC.YYYYMMDD
                         , XC.ORIGIN_DIVISION_ID
                         , XC.ELECTRODE_TYPE
                      FROM SCM_MST_SHEET_MEASURE    XA
                         , SCM_MST_TITLESET_USER    XB
                         , (SELECT SA.DIVISION_ID
                                 , SA.PLAN_START_YYYYMMDD
                                 , SA.PLAN_TYPE
                                 , SA.SEQ
                                 , SA.OPERATION_GROUP
                                 , SA.SCM_SITE_ID
                                 , SA.ITEM_ID
                                 , SA.OPERATION_ID
                                 , SA.LINE_ID
                                 , SA.MEASURE
                                 , SA.YYYYMMDD
                                 , NVL(SA.ORIGIN_DIVISION_ID, '-')  AS ORIGIN_DIVISION_ID
                                 , NVL(SA.ELECTRODE_TYPE, '-')      AS ELECTRODE_TYPE
                              FROM HIST_SCP_ANL_PRODUCTION_PLAN SA
                             WHERE SA.YYYYMMDD                >= P_FROM_YYYYMMDD
                               AND SA.YYYYMMDD                <= P_TO_YYYYMMDD
                               AND SA.DIVISION_ID              = V_DIVISION_ID
                               AND SA.OPERATION_GROUP          = V_OPERATION_GROUP
                               AND SA.SCM_SITE_ID              = V_SCM_SITE_ID
                               AND SA.ITEM_ID                  = V_ITEM_ID
                               AND SA.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
                               AND SA.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE     /* 파티션 프루닝 */
                               AND SA.PLAN_TYPE                = V_PLAN_TYPE
                               AND SA.SEQ                      = V_SEQ
                               AND (V_ELEC_ALL = 'Y' OR NVL(SA.ELECTRODE_TYPE, '-') IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)))
                             GROUP BY SA.DIVISION_ID
                                    , SA.PLAN_START_YYYYMMDD
                                    , SA.PLAN_TYPE
                                    , SA.SEQ
                                    , SA.OPERATION_GROUP
                                    , SA.SCM_SITE_ID
                                    , SA.ITEM_ID
                                    , SA.LINE_ID
                                    , SA.OPERATION_ID
                                    , SA.MEASURE
                                    , SA.YYYYMMDD
                                    , SA.ORIGIN_DIVISION_ID
                                    , SA.ELECTRODE_TYPE
                             UNION ALL
                            -- 생산실적
                            -- Plan 테이블에는 실적 보고자 하는 YYYYMMDD가 없으므로 생성을 위해 추가
                            SELECT V_DIVISION_ID                    AS DIVISION_ID     --div_commonization
                                 , P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                                 , P_PLAN_TYPE                      AS PLAN_TYPE
                                 , V_SEQ                            AS SEQ
                                 , SB.SCP_OPERATION_GROUP           AS OPERATION_GROUP
                                 , SB.SCM_SITE_ID
                                 , SB.ITEM_ID
                                 , SB.OPERATION_ID
                                 , SB.LINE_ID
                                 , 'PROD_PLAN_ENGINE'               AS MEASURE
                                 , TO_CHAR(SB.PLAN_DATE, 'YYYYMMDD') AS YYYYMMDD
                                 , SB.DIVISION_ID                   AS ORIGIN_DIVISION_ID
                                 , NVL(SB.ELECTRODE_TYPE, '-')      AS ELECTRODE_TYPE
                              FROM SCM_DNM_PRODUCT_RESULT_V SB
                             WHERE SB.DIVISION_ID IN (SELECT SC.DIVISION_ID      --div_commonization
                                                        FROM SCM_MST_DIVISION SC
                                                       WHERE SC.ATTRIBUTE4 IN (SELECT SD.ATTRIBUTE4
                                                                                 FROM SCM_MST_DIVISION SD
                                                                                WHERE SD.DIVISION_ID = V_DIVISION_ID
                                                                                  AND SD.ATTRIBUTE3  = 'EE')
                                                         AND SC.ATTRIBUTE3 <> 'EE'
                                                       UNION ALL
                                                      SELECT V_DIVISION_ID
                                                        FROM DUAL)
                               AND SB.PLAN_DATE           >= V_FROM_RESULT_DATE
                               AND SB.PLAN_DATE           <  V_TO_RESULT_DATE      -- equal 표시 주의할것
                               AND SB.SCP_OPERATION_GROUP  = V_OPERATION_GROUP
                               AND (V_SITE_ALL = 'Y' OR SB.SCM_SITE_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_SITE_TAB)))
                               AND (V_ITEM_ALL = 'Y' OR SB.ITEM_ID     IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
                               AND (V_ELEC_ALL = 'Y' OR NVL(SB.ELECTRODE_TYPE, '-') IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)))
                             GROUP BY SB.DIVISION_ID
                                    , SB.SCP_OPERATION_GROUP
                                    , SB.SCM_SITE_ID
                                    , SB.ITEM_ID
                                    , SB.LINE_ID
                                    , SB.OPERATION_ID
                                    , SB.PLAN_DATE
                                    , SB.ELECTRODE_TYPE) XC
                     WHERE XA.PROGRAM_ID          = XB.PROGRAM_ID(+)
                       AND UPPER(XA.SHEET_NAME)   = UPPER(XB.SHEET_NAME(+))
                       AND UPPER(XA.COLUMN_NAME)  = UPPER(XB.COLUMN_NAME(+))
                       AND UPPER(XB.USER_ID(+))   = V_USER_ID
                       AND (   V_CNT_USR_MEASURE = 0
                            OR EXISTS (SELECT 1
                                         FROM SCM_MST_TITLESET_USER SE
                                        WHERE SE.PROGRAM_ID         = V_PROGRAM_ID
                                          AND UPPER(SE.SHEET_NAME)  = V_SHEET_NAME
                                          AND UPPER(SE.USER_ID)     = V_USER_ID
                                          AND UPPER(SE.COLUMN_NAME) = UPPER(XA.COLUMN_NAME)))
                       AND XA.PROGRAM_ID          = V_PROGRAM_ID
                       AND UPPER(XA.SHEET_NAME)   = V_SHEET_NAME
                       AND XA.VALID_YN            = 'Y'
                     GROUP BY XC.DIVISION_ID
                            , XC.PLAN_START_YYYYMMDD
                            , XC.PLAN_TYPE
                            , XC.SEQ
                            , XC.OPERATION_GROUP
                            , XC.SCM_SITE_ID
                            , XC.ITEM_ID
                            , XC.LINE_ID
                            , XC.OPERATION_ID
                            , XA.COLUMN_NAME
                            , XA.COLUMN_LABEL_NAME
                            , XC.YYYYMMDD
                            , NVL(XB.SORT_ORDER_NO, XA.SORT_ORDER_NO)
                            , XC.ORIGIN_DIVISION_ID
                            , XC.ELECTRODE_TYPE) IA
                 , (  -- 계획
                    SELECT XD.DIVISION_ID
                         , XD.OPERATION_GROUP
                         , XD.SCM_SITE_ID
                         , XD.ITEM_ID
                         , XD.OPERATION_ID
                         , XD.LINE_ID
                         , XD.MEASURE
                         , XD.YYYYMMDD
                         , XD.QTY
                         , NVL(XD.ORIGIN_DIVISION_ID, '-')          AS ORIGIN_DIVISION_ID
                         , NVL(XD.ELECTRODE_TYPE, '-')              AS ELECTRODE_TYPE
                      FROM HIST_SCP_ANL_PRODUCTION_PLAN XD
                     WHERE XD.YYYYMMDD                >= V_FROM_CMP
                       AND XD.YYYYMMDD                <= V_TO_CMP
                       AND XD.DIVISION_ID              = V_DIVISION_ID
                       AND XD.OPERATION_GROUP          = V_OPERATION_GROUP
                       AND XD.SCM_SITE_ID              = V_SCM_SITE_ID
                       AND XD.ITEM_ID                  = V_ITEM_ID
                       AND XD.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
                       AND XD.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE     /* 파티션 프루닝 */
                       AND XD.PLAN_TYPE                = V_PLAN_TYPE
                       AND XD.SEQ                      = V_SEQ
                       AND (V_ELEC_ALL = 'Y' OR NVL(XD.ELECTRODE_TYPE, '-') IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)))
                     UNION ALL
                    -- 생산실적
                    SELECT V_DIVISION_ID                            AS DIVISION_ID     --div_commonization
                         , XE.SCP_OPERATION_GROUP                   AS OPERATION_GROUP
                         , XE.SCM_SITE_ID
                         , XE.ITEM_ID
                         , XE.OPERATION_ID
                         , XE.LINE_ID
                         , 'PROD_PLAN_ENGINE'                       AS MEASURE
                         , TO_CHAR(XE.PLAN_DATE, 'YYYYMMDD')        AS YYYYMMDD
                         , XE.ACTUAL_GOOD_QTY                       AS QTY
                         , XE.DIVISION_ID                           AS ORIGIN_DIVISION_ID
                         , NVL(XE.ELECTRODE_TYPE, '-')              AS ELECTRODE_TYPE
                      FROM SCM_DNM_PRODUCT_RESULT_V XE
                     WHERE XE.DIVISION_ID IN (SELECT SF.DIVISION_ID      --div_commonization
                                                FROM SCM_MST_DIVISION SF
                                               WHERE SF.ATTRIBUTE4 IN (SELECT SG.ATTRIBUTE4
                                                                         FROM SCM_MST_DIVISION SG
                                                                        WHERE SG.DIVISION_ID = V_DIVISION_ID
                                                                          AND SG.ATTRIBUTE3  = 'EE')
                                                 AND SF.ATTRIBUTE3 <> 'EE'
                                               UNION ALL
                                              SELECT V_DIVISION_ID
                                                FROM DUAL)
                       AND XE.PLAN_DATE           >= V_FROM_RESULT_DATE
                       AND XE.PLAN_DATE           <  V_TO_RESULT_DATE      -- equal 표시 주의할것
                       AND XE.SCP_OPERATION_GROUP  = V_OPERATION_GROUP
                       AND XE.SCM_SITE_ID          = V_SCM_SITE_ID
                       AND XE.ITEM_ID              = V_ITEM_ID
                       AND (V_ELEC_ALL = 'Y' OR NVL(XE.ELECTRODE_TYPE, '-') IN (SELECT COLUMN_VALUE FROM TABLE(V_ELEC_TAB)))) IB
                 , SCM_SYS_CALENDAR_M C
             WHERE IA.DIVISION_ID        = IB.DIVISION_ID(+)
               AND IA.OPERATION_GROUP    = IB.OPERATION_GROUP(+)
               AND IA.SCM_SITE_ID        = IB.SCM_SITE_ID(+)
               AND IA.ITEM_ID            = IB.ITEM_ID(+)
               AND IA.OPERATION_ID       = IB.OPERATION_ID(+)
               AND IA.LINE_ID            = IB.LINE_ID(+)
               AND IA.MEASURE            = IB.MEASURE(+)
               AND IA.YYYYMMDD           = IB.YYYYMMDD(+)
               AND IA.ORIGIN_DIVISION_ID = IB.ORIGIN_DIVISION_ID(+)
               AND IA.ELECTRODE_TYPE     = IB.ELECTRODE_TYPE(+)
               AND IA.YYYYMMDD           = C.BASIS_YYYYMMDD
                -- 조회조건 추가부분 (Model Tab에서만 사용하는 REQUIREMENT , FORMATION_YIELD Measure는 *로 입력되어 Line조회시 제외함)
               AND IA.LINE_ID           IS NOT NULL
               AND IA.LINE_ID           <> '*';

        END IF;

        /********************************************************************************
        * PIVOIT처리
        ********************************************************************************/
        -- PIVOIT 대상 날짜문자열 생성
        V_QRY_SUM := NULL;

        FOR R IN (SELECT IA.COL_NAME
                    FROM (SELECT 'W_' || XA.BASIS_YYYYMM || XA.ISO_WEEK             AS COL_NAME
                               , XA.BASIS_START_DATE || '21'                        AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M XA
                           WHERE XA.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY XA.BASIS_YYYYMM
                                  , XA.ISO_WEEK
                                  , XA.BASIS_START_DATE
                           UNION ALL
                          SELECT 'M_' || XB.BASIS_YYYYMM                            AS COL_NAME
                               , MIN(XB.BASIS_START_DATE) || '01'                   AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M XB
                           WHERE XB.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY XB.BASIS_YYYYMM
                                  , XB.MONTH_NAME
                           UNION ALL
                          SELECT 'D_' || XC.BASIS_YYYYMMDD                          AS COL_NAME
                               , XC.BASIS_YYYYMMDD || '31'                          AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M XC
                           WHERE XC.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY XC.BASIS_YYYYMMDD) IA
                   ORDER BY IA.SORT_ORDER_NO)
        LOOP
            IF SUBSTR(R.COL_NAME, 1, 2) = 'M_' THEN
                V_QRY_SUM := V_QRY_SUM
                          || '     , SUM(CASE WHEN YYYYMM = ''' || SUBSTR(R.COL_NAME, -6) || ''' THEN QTY END) AS ' || R.COL_NAME || CHR(10);
            ELSIF SUBSTR(R.COL_NAME, 1, 2) = 'W_' THEN
                V_QRY_SUM := V_QRY_SUM
                          || '     , SUM(CASE WHEN ISO_WEEK = ''' || SUBSTR(R.COL_NAME, -6) || ''' THEN QTY END) AS ' || R.COL_NAME || CHR(10);
            ELSE
                V_QRY_SUM := V_QRY_SUM
                          || '     , SUM(CASE WHEN YYYYMMDD = ''' || R.COL_NAME || ''' THEN QTY END) AS ' || R.COL_NAME || CHR(10);
            END IF;
        END LOOP;

        V_SQL := 'SELECT DIVISION_ID' || CHR(10)
              || '     , FN_GET_DIVISION_NAME(DIVISION_ID) AS DIVISION_NAME' || CHR(10)
              || '     , OPERATION_GROUP' || CHR(10)
              || '     , FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP'', OPERATION_GROUP) AS OPERATION_GROUP_NAME' || CHR(10)
              || '     , SCM_SITE_ID' || CHR(10)
              || '     , FN_GET_SCM_SITE_DESCRIPTION(DIVISION_ID, SCM_SITE_ID) AS SCM_SITE_DESCRIPTION' || CHR(10)
              || '     , LINE_ID' || CHR(10)
              || '     , FN_GET_ITEM_PROD_OP(DIVISION_ID, OPERATION_GROUP, ITEM_ID) AS MODEL_ID' || CHR(10)
              || '     , ITEM_ID' || CHR(10)
              || '     , NVL(FN_GET_ITEM_NICKNAME(DIVISION_ID, ITEM_ID), ''-'') AS NICK_NAME' || CHR(10)
              || '     , MEASURE' || CHR(10)
              || '     , MEASURE_NAME' || CHR(10)
              || '     , OPERATION_ID' || CHR(10)
              || '     , PLAN_TYPE' || CHR(10)
              || '     , PLAN_SEQ' || CHR(10)
              || '     , PLAN_START_YYYYMMDD' || CHR(10)
              || '     , FROM_YYYYMMDD' || CHR(10)
              || '     , USER_SORT_ORDER_NO' || CHR(10)
              || '     , ORIGIN_DIVISION_ID' || CHR(10)
              || '     , ELECTRODE_TYPE' || CHR(10)
              || V_QRY_SUM
              || '  FROM GT_0011_LINE' || CHR(10)
              || ' GROUP BY DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, LINE_ID, ITEM_ID, MEASURE, MEASURE_NAME, OPERATION_ID, PLAN_TYPE, PLAN_SEQ, PLAN_START_YYYYMMDD, FROM_YYYYMMDD, USER_SORT_ORDER_NO' || CHR(10)
              || '        , ORIGIN_DIVISION_ID, ELECTRODE_TYPE' || CHR(10)
              || ' ORDER BY DIVISION_ID NULLS FIRST, OPERATION_GROUP NULLS FIRST, SCM_SITE_ID NULLS FIRST, LINE_ID NULLS FIRST, ITEM_ID NULLS FIRST, USER_SORT_ORDER_NO NULLS FIRST';   /* AS-IS 오름차순은 NULL 이 앞 */

        -----------------------------------------------------------
        -- DEBUG QRY 출력
        -----------------------------------------------------------
        IF P_DEBUG_MODE = 'T' THEN
            P_PUT_CLOB(V_SQL);
        END IF;

        OPEN O_RC1 FOR V_SQL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('SCP0011_GET_PRODUCTION_PLAN_LINE'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_OPERATION_GROUP=' || P_OPERATION_GROUP
                     || ', P_SCM_SITE_ID=' || P_SCM_SITE_ID
                     || ', P_ITEM_ID=' || P_ITEM_ID
                     || ', P_FROM_YYYYMMDD=' || P_FROM_YYYYMMDD
                     || ', P_TO_YYYYMMDD=' || P_TO_YYYYMMDD
                     || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_PLAN_TYPE=' || P_PLAN_TYPE
                     || ', P_SEQ=' || P_SEQ
                     || ', P_USER_ID=' || P_USER_ID
                     || ', P_ELECTRODE_TYPE=' || P_ELECTRODE_TYPE
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    END P_SCP0011_GET_PROD_PLAN_LINE;


    /*==================================================================================================
     * Program ID   : SCP0011_GET_PLAN_EDIT_INFO
     * Description  : PLAN 별 편집가능 여부 정보 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/04/02   PJS    			Initial Release  전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/05/21   PJS             PR 수정모드 조건 변경
     * 2018/06/01   PJS             PLAN 시작일 가져오는 조건 변경
     * 2018/06/07   PJS             MA일 경우 FP운용기간-7일 처리
     * 2018/06/20   PJS             edit_start_date 계산 로직수정(offset -7반영)
     * 2018/07/18	YHW				전극데이터 편집가능여부 조건 수정(ORIGIN DIVISION 사용)
     * 2020/10/28   khj79           [C20201019-000175] , 자동차(81) 사업부의 경우 Final Plan 제외하고 전 구간 생산계획 수정 가능
     * 2021/10/13   khj79			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 82(ESS) 'MA' 플랜 전 구간 수정 가능
     * 2023/05/03   LWY			    PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 81 / SE : PROD_FROZEN 구간 EDIT 불가 적용.
     * 2026.09.17                   [MSSQL -> Oracle 전환] 사이트 비교 대소문자 무시(AS-IS 정렬규칙 CI 대응)
     *==================================================================================================*/
    PROCEDURE P_SCP0011_GET_PLAN_EDIT_INFO
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2 DEFAULT NULL,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_DIVISION_ID           VARCHAR2(50 CHAR) := UPPER(P_DIVISION_ID);
        V_PLAN_TYPE             VARCHAR2(50 CHAR) := UPPER(P_PLAN_TYPE);
        V_ORIGIN_DIVISION_ID    VARCHAR2(60 CHAR) := UPPER(P_ORIGIN_DIVISION_ID);
        V_SEQ                   NUMBER;
        V_BUCKET_M10            VARCHAR2(8 CHAR);       /* 10주전 */
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        V_SEQ        := TO_NUMBER(P_SEQ);
        V_BUCKET_M10 := FN_GET_BUCKET_YYYYMMDD(-10);

        OPEN O_RC1 FOR
        SELECT IA.DIVISION_ID
             , IA.PLAN_VERSION_ID
             , IA.PLAN_NAME                                         AS PLAN_START_YYYYMMDD
             , IA.PLAN_TYPE
             , IA.PLAN_SEQ
             , IC.OSP_YN
             , IC.FP_PLAN_PERIOD
             , CASE
                   WHEN IA.PLAN_TYPE = 'PR' THEN 0
                   WHEN IA.PLAN_TYPE = 'MA' THEN IC.OFFSET - 7
                   ELSE IC.OFFSET
               END                                                  AS OFFSET
                -- 자동차(81) 사업부의 경우 Final Plan 제외하고 전 구간 생산계획 수정 가능
                -- 2021.10.13 : ESS(82) 사업부의 경우 'MA' 플랜 전 구간 생산계획 수정 가능
             , TO_CHAR(TO_DATE(IA.PLAN_NAME, 'YYYYMMDD')
                       + CASE
                             WHEN IA.PLAN_TYPE = 'PR' THEN 0
                              -- LWY begin (2023/05/03)
                              --WHEN A.DIVISION_ID = '81' THEN 0
                             WHEN IA.DIVISION_ID = '81'  AND IA.PLAN_TYPE != 'SE' THEN 0
                             WHEN IA.DIVISION_ID = '81'  AND IA.PLAN_TYPE  = 'SE' THEN IC.PROD_FROZEN
                              -- LWY end	 (2023/05/03)
                              -- 2021.10.13 : ESS(82) 사업부의 경우 'MA' 플랜 전 구간 생산계획 수정 가능
                              --WHEN plan_type ='MA' THEN c.offset -7
                             WHEN IA.DIVISION_ID = '82'  AND IA.PLAN_TYPE  = 'MA' THEN 0
                             WHEN IA.DIVISION_ID != '82' AND IA.PLAN_TYPE  = 'MA' THEN IC.OFFSET - 7
                             ELSE IC.OFFSET
                         END, 'YYYYMMDD')                           AS EDIT_START_DATE
             , CASE IA.PLAN_TYPE
                   WHEN 'PR' THEN 0
                   WHEN 'MA' THEN 1
                   WHEN 'SE' THEN 3
                   WHEN 'FI' THEN 4
                   ELSE 9
               END                                                  AS PLAN_TYPE_ORDER
             , IA.CONFIRM_YN
             , CASE
                   WHEN IA.PLAN_NAME < IB.BASIS_START_DATE
                   THEN 'N'
                   ELSE 'Y'
               END                                                  AS DATE_CHK
             , 'Y'                                                  AS IS_EDITABLE
          FROM (SELECT XA.DIVISION_ID
                     , XB.PLAN_NAME || '-' || XA.PLAN_TYPE || '-' || FN_ZERO_LPAD(TO_CHAR(XA.PLAN_SEQ), 2)  AS PLAN_VERSION_ID
                     , XB.PLAN_NAME
                     , XA.PLAN_SEQ
                     , XA.PLAN_TYPE
                     , CASE
                           WHEN RTRIM(XA.CONFIRM_FLAG) IS NULL
                           THEN 'N'
                           ELSE XA.CONFIRM_FLAG
                       END                                          AS CONFIRM_YN
                  FROM SCM_MST_PLAN_DETAIL  XA
                     , SCM_MST_PLAN         XB
                     , SCM_MST_MODELING     XC
                 WHERE XC.MODELING_ID = XA.MODELING_ID
                   AND XC.DIVISION_ID = XA.DIVISION_ID
                   AND XB.DIVISION_ID = XA.DIVISION_ID
                   AND XB.PLAN_CYCLE  = XC.PLAN_CYCLE
                   AND XB.PLAN_ID     = XA.PLAN_ID
                   AND XC.PLAN_CYCLE  = 'WEEKLY'
                   AND XB.PLAN_NAME  >= V_BUCKET_M10       --10주전
                   AND XA.DIVISION_ID = V_DIVISION_ID
                   AND XA.PLAN_TYPE   = V_PLAN_TYPE
                   AND XA.PLAN_SEQ    = V_SEQ
                   AND XB.PLAN_NAME   = P_PLAN_START_YYYYMMDD) IA
             , (SELECT TO_CHAR(TO_DATE(XD.BASIS_YYYYMMDD, 'YYYYMMDD') - (XD.DAYOFWEEK_NO - 1), 'YYYYMMDD') AS BASIS_START_DATE
                  FROM (SELECT CASE
                                   WHEN SA.DAYOFWEEK_NO - 1 = 0
                                   THEN 7
                                   ELSE SA.DAYOFWEEK_NO - 1
                               END                                  AS DAYOFWEEK_NO
                             , SA.BASIS_YYYYMMDD
                          FROM SCM_SYS_CALENDAR_M SA
                         WHERE SA.BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')) XD) IB
             , (SELECT XE.OSP_YN
                     , XE.FP_PLAN_PERIOD
                     , CASE
                           WHEN XE.OSP_YN = 'Y'
                           THEN 0
                           ELSE XE.FP_PLAN_PERIOD
                       END                                          AS OFFSET
                     , XE.PROD_FROZEN -- LWY
                  FROM SCM_MST_SITE XE
                 WHERE XE.DIVISION_ID        = V_ORIGIN_DIVISION_ID
                   AND UPPER(XE.SCM_SITE_ID) = UPPER(P_SCM_SITE_ID)) IC;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('SCP0011_GET_PLAN_EDIT_INFO'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_SCM_SITE_ID=' || P_SCM_SITE_ID
                     || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_PLAN_TYPE=' || P_PLAN_TYPE
                     || ', P_SEQ=' || P_SEQ
                     || ', P_ORIGIN_DIVISION_ID=' || P_ORIGIN_DIVISION_ID
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    END P_SCP0011_GET_PLAN_EDIT_INFO;


    /*==================================================================================================
     * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND
     * Description  :
     * OutTable     :
     * Execute      : EXEC PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND N'81',N'20180108',N'MA',N'2',N'LTW'
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018.06.07   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018.06.11	HWY			EOH 계산 관련 RETURN값 수정
     * 2026.09.18               [MSSQL -> Oracle 전환] 화면 Target-Plan(Amend) 재계산 (SCP0011 만 호출)
     *                          조인 갱신은 재계산 값을 임시 테이블에 담은 뒤 상관 갱신으로 전환
     *==================================================================================================*/
    PROCEDURE P_SCP_ANL_PROD_PLAN_I_AMEND
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,   -- plan_name
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2 DEFAULT 'scp_batch',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_DIVISION_ID           VARCHAR2(30 CHAR)   := UPPER(P_DIVISION_ID);
        V_PLAN_TYPE             VARCHAR2(30 CHAR)   := UPPER(P_PLAN_TYPE);
        V_OPERATION_GROUP       VARCHAR2(10 CHAR)   := UPPER(P_OPERATION_GROUP);
        V_SEQ                   NUMBER;
        V_PLAN_START_DATE       DATE;

        -- LOG 용 변수 설정
        V_BATCH_USER            VARCHAR2(150 CHAR)  := P_USER_ID;
        V_PROGRAM_NAME          VARCHAR2(150 CHAR)  := 'PR_SCP_ANL_PRODUCTION_PLAN_I_AMEND';
        V_LOG_TYPE              VARCHAR2(30 CHAR);  -- START/END/ERROR/...
        N_LOG_COUNT             NUMBER              := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        V_TABLE_ID              VARCHAR2(150 CHAR)  := 'SCP_ANL_PRODUCTION_PLAN';
        D_EVENT_DATE            DATE;
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        -- 시작 LOG
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := V_PROGRAM_NAME || ':' || ' SCP_ANL_PRODUCTION_PLAN UPDATE LOGIC';
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH(P_PROGRAM_NAME => V_PROGRAM_NAME
                           , P_LOG_TYPE     => V_LOG_TYPE
                           , P_LOG_COUNT    => N_LOG_COUNT
                           , P_LOG_MESSAGE  => V_LOG_MESSAGE
                           , P_DESCRIPTION  => V_DESCRIPTION
                           , P_EVENT_DATE   => D_EVENT_DATE
                           , P_USER_ID      => V_BATCH_USER);

        BEGIN

            /* AS-IS 는 문자 차수를 숫자 칸과 비교해 형 변환 오류가 나면 CATCH 로 간다 */
            V_SEQ := TO_NUMBER(P_SEQ);

            /* 파티션 프루닝용 - 형식이 틀리면 NULL 이고, 이때는 계획 일자 조건이 이미 0 건이다 */
            SELECT TO_DATE(P_PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD')
              INTO V_PLAN_START_DATE
              FROM DUAL;

            -----------------------------------------------------------
            --1. 생산계획(ONHAND_EOH) 데이터 AMEND
            -----------------------------------------------------------
            DELETE FROM GT_0011_AMEND;

            /* 사이트 · 품목별 누적(생산계획 AMEND - 요구량) — 같은 일자 행은 같은 누적값(RANGE 기본 범위) */
            INSERT INTO GT_0011_AMEND
                 (
                   SCM_SITE_ID
                  ,ITEM_ID
                  ,YYYYMMDD
                  ,QTY
                 )
            SELECT DISTINCT
                   IA.SCM_SITE_ID
                 , IA.ITEM_ID
                 , IA.YYYYMMDD
                 , IA.P_SUM - IA.S_SUM                              AS QTY
              FROM (SELECT A.SCM_SITE_ID
                         , A.ITEM_ID
                         , A.YYYYMMDD
                         , SUM(CASE
                                   WHEN A.MEASURE = 'REQUIREMENT'
                                   THEN NVL(A.QTY, 0)
                                   ELSE 0
                               END) OVER (PARTITION BY A.SCM_SITE_ID
                                                     , A.ITEM_ID
                                              ORDER BY A.SCM_SITE_ID
                                                     , A.ITEM_ID
                                                     , A.YYYYMMDD)  AS S_SUM
                         , SUM(CASE
                                   WHEN A.MEASURE = 'PROD_PLAN_AMEND'
                                   THEN NVL(A.QTY, 0)
                                   ELSE 0
                               END) OVER (PARTITION BY A.SCM_SITE_ID
                                                     , A.ITEM_ID
                                              ORDER BY A.SCM_SITE_ID
                                                     , A.ITEM_ID
                                                     , A.YYYYMMDD)  AS P_SUM
                      FROM SCP_ANL_PRODUCTION_PLAN A
                     WHERE A.MEASURE                 IN ('PROD_PLAN_AMEND', 'REQUIREMENT')
                       AND A.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
                       AND A.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE        /* 파티션 프루닝 */
                       AND A.PLAN_TYPE                = V_PLAN_TYPE
                       AND A.SEQ                      = V_SEQ
                       AND A.DIVISION_ID              = V_DIVISION_ID
                       AND A.OPERATION_GROUP          = V_OPERATION_GROUP) IA;

            UPDATE SCP_ANL_PRODUCTION_PLAN A
               SET A.QTY              = (SELECT SA.QTY
                                           FROM GT_0011_AMEND SA
                                          WHERE SA.SCM_SITE_ID = A.SCM_SITE_ID
                                            AND SA.ITEM_ID     = A.ITEM_ID
                                            AND SA.YYYYMMDD    = A.YYYYMMDD)
                 , A.LAST_UPDATED_BY  = P_USER_ID
                 , A.LAST_UPDATE_DATE = SYSDATE
             WHERE EXISTS (SELECT 1
                             FROM GT_0011_AMEND SB
                            WHERE SB.SCM_SITE_ID = A.SCM_SITE_ID
                              AND SB.ITEM_ID     = A.ITEM_ID
                              AND SB.YYYYMMDD    = A.YYYYMMDD)
               AND A.MEASURE                  = 'ONHAND_EOH'
               AND A.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE            /* 파티션 프루닝 */
               AND A.PLAN_TYPE                = V_PLAN_TYPE
               AND A.SEQ                      = V_SEQ
               AND A.DIVISION_ID              = V_DIVISION_ID
               AND A.OPERATION_GROUP          = V_OPERATION_GROUP;

            -- TXN LOG
            V_LOG_TYPE    := 'TXN';
            N_LOG_COUNT   := 1;     /* AS-IS 는 변수 대입 직후의 @@ROWCOUNT(=1)를 기록한다 */
            V_LOG_MESSAGE := 'UPDATE ' || V_TABLE_ID;
            V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYY-MM-DD HH24:MI:SS') || '.000';
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH(P_PROGRAM_NAME => V_PROGRAM_NAME
                               , P_LOG_TYPE     => V_LOG_TYPE
                               , P_LOG_COUNT    => N_LOG_COUNT
                               , P_LOG_MESSAGE  => V_LOG_MESSAGE
                               , P_DESCRIPTION  => V_DESCRIPTION
                               , P_EVENT_DATE   => D_EVENT_DATE
                               , P_USER_ID      => V_BATCH_USER);

            /* AS-IS 는 명시 트랜잭션 없이 문장 단위로 확정된다 */
            COMMIT;

            -- 결과코드 반환
            OPEN O_RC1 FOR
            SELECT 'S'                                              AS RESULT_CODE
              FROM DUAL;

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;

                O_RESULT_CODE := 'F';
                O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

                -- ERROR LOG
                V_LOG_TYPE    := 'ERROR';
                V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
                V_DESCRIPTION := 'ERROR_LINE : ' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 480);
                D_EVENT_DATE  := SYSDATE;
                PR_SCP_SYS_LOG_BATCH(P_PROGRAM_NAME => V_PROGRAM_NAME
                                   , P_LOG_TYPE     => V_LOG_TYPE
                                   , P_LOG_COUNT    => N_LOG_COUNT
                                   , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                   , P_DESCRIPTION  => V_DESCRIPTION
                                   , P_EVENT_DATE   => D_EVENT_DATE
                                   , P_USER_ID      => V_BATCH_USER);

                -- 결과코드 반환
                OPEN O_RC1 FOR
                SELECT 'F'                                          AS RESULT_CODE
                  FROM DUAL;
        END;

        -- 종료 LOG
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCP_SYS_LOG_BATCH(P_PROGRAM_NAME => V_PROGRAM_NAME
                           , P_LOG_TYPE     => V_LOG_TYPE
                           , P_LOG_COUNT    => N_LOG_COUNT
                           , P_LOG_MESSAGE  => V_LOG_MESSAGE
                           , P_DESCRIPTION  => V_DESCRIPTION
                           , P_EVENT_DATE   => D_EVENT_DATE
                           , P_USER_ID      => V_BATCH_USER);

    END P_SCP_ANL_PROD_PLAN_I_AMEND;

END PKG_SCP0011;
/
SHOW ERRORS PACKAGE BODY PKG_SCP0011
