FUNCTION FN_SCP0104_GET_SPREAD_TITLE
(
    P_FROM_YYYYMM   IN VARCHAR2
  , P_PROGRAM_ID    IN VARCHAR2
  , P_SHEET_NAME    IN VARCHAR2
)
RETURN T_FN_SCP0104_SPREAD_TITLE_TAB PIPELINED
/* ============================================================
 * Program ID   : FN_SCP0104_GET_SPREAD_TITLE
 * Description  : CAPA NEW 날짜 타이틀 리턴 (SCP0104, SCP0105, SCP0106, SCP0107, SCP0108 공통)
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2023/10/12    chaan          V1.1.1  PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2  - Initial Release
 * 2024/12/09    chaan          V1.1.8  PJ20230692  Pre 버전 예외처리
 * 2025/02/09    mrchois        V1.1.8  PJ20249346  (scp0106 Loss Plan UI 수정) Improvement Rate 입력 영역을 제거하고
 *                                                  Operation Plan 에 Goal 직접 입력 형태로 수정
 * 2026.09.27    ZIONEX         [PJ202650304] MSSQL -> Oracle 전환
 * ============================================================ */
IS

    V_SHEET_NAME        VARCHAR2(100 CHAR) := REPLACE(REPLACE(P_SHEET_NAME, '_ASSEMBLY', ''), '_ELTR', '');

    V_FROM_YYYY         VARCHAR2(4 CHAR)   := SUBSTR(P_FROM_YYYYMM, 1, 4);
    /* SCP0106_GET_CAPA_LOSS_PLAN 은 앞에 2개년도를 월별로 추가 */
    V_TO_YYYY_SCP0106   VARCHAR2(4 CHAR)   := TO_CHAR(TO_NUMBER(SUBSTR(P_FROM_YYYYMM, 1, 4)) + 1);
    /* 처음 3년은 월별 */
    V_TO_YYYY_MONTHLY   VARCHAR2(4 CHAR)   := TO_CHAR(TO_NUMBER(SUBSTR(P_FROM_YYYYMM, 1, 4)) + 2);
    /* 4~6년까지는 연도별 */
    V_FROM_YYYY_YEAR    VARCHAR2(4 CHAR)   := TO_CHAR(TO_NUMBER(SUBSTR(P_FROM_YYYYMM, 1, 4)) + 3);
    V_TO_YYYY_YEAR      VARCHAR2(4 CHAR)   := TO_CHAR(TO_NUMBER(SUBSTR(P_FROM_YYYYMM, 1, 4)) + 5);

    /* 보고 코드 — 원문 @TBL_RPT_CODE 를 대신한다 */
    V_RPT_CODE_NM_PLAN  VARCHAR2(100 CHAR);
    V_RPT_CODE_NM_ETC   VARCHAR2(100 CHAR);

    TYPE T_TBL IS TABLE OF T_FN_SCP0104_SPREAD_TITLE_ROW INDEX BY PLS_INTEGER;
    V_TBL1              T_TBL;
    N_IDX               PLS_INTEGER := 0;
    N_CNT               PLS_INTEGER;

BEGIN

    /* 보고 코드는 원문이 상관 없는 조인(1=1)으로 한 행만 붙이므로 값 하나만 가져온다 */
    BEGIN
        SELECT MAX(A.SEGMENT4)
          INTO V_RPT_CODE_NM_PLAN
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
         WHERE A.LOOKUP_TYPE = 'SCP_CAPA_RPT_CODE'
           AND A.VALID_YN    = 'Y'
           AND A.SEGMENT1    = P_PROGRAM_ID
           AND A.SEGMENT2    = V_SHEET_NAME
           AND A.SEGMENT3    = 'PLAN';
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            V_RPT_CODE_NM_PLAN := NULL;
    END;

    BEGIN
        SELECT MAX(A.SEGMENT4)
          INTO V_RPT_CODE_NM_ETC
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
         WHERE A.LOOKUP_TYPE = 'SCP_CAPA_RPT_CODE'
           AND A.VALID_YN    = 'Y'
           AND A.SEGMENT1    = P_PROGRAM_ID
           AND A.SEGMENT2    = V_SHEET_NAME
           AND A.SEGMENT3    = 'ETC';
    EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
            V_RPT_CODE_NM_ETC := NULL;
    END;

    /* 처음 3년은 월별 */
    IF P_PROGRAM_ID IN ('SCP0104', 'SCP0105', 'SCP0106')
    THEN

        FOR R IN (SELECT 'M_01' || A.BASIS_YYYYMM                       AS COLUMN_NAME   /* 동일 기간과 중복되므로 00/01 로 구분 */
                       , A.MONTH_NAME                                   AS COLUMN_LABEL_NAME
                       , A.CALENDAR_YYYY                                AS SMALL_CLASS_LABEL_NAME
                       , V_RPT_CODE_NM_PLAN                             AS LARGE_CLASS_LABEL_NAME
                       , ''                                             AS DAY_CODE
                       , '01' || MIN(A.BASIS_START_DATE) || '01'        AS SORT_ORDER_NO
                    FROM SCM_SYS_CALENDAR_M A
                   WHERE A.CALENDAR_YYYY BETWEEN V_FROM_YYYY AND V_TO_YYYY_MONTHLY
                   GROUP BY A.CALENDAR_YYYY
                          , A.BASIS_YYYYMM
                          , A.MONTH_NAME
                   ORDER BY A.BASIS_YYYYMM
                          , A.MONTH_NAME)
        LOOP
            N_IDX := N_IDX + 1;
            V_TBL1(N_IDX) := T_FN_SCP0104_SPREAD_TITLE_ROW(R.COLUMN_NAME, R.COLUMN_LABEL_NAME
                           , R.SMALL_CLASS_LABEL_NAME, R.LARGE_CLASS_LABEL_NAME, R.DAY_CODE, R.SORT_ORDER_NO);
        END LOOP;

    ELSIF P_PROGRAM_ID IN ('SCP0107', 'SCP0108')    /* TEEP, LOB */
    THEN

        FOR R IN (SELECT 'M_01' || A.BASIS_YYYYMM                       AS COLUMN_NAME   /* 동일 기간과 중복되므로 00/01 로 구분 */
                       , A.MONTH_NAME                                   AS COLUMN_LABEL_NAME
                       , A.CALENDAR_YYYY                                AS SMALL_CLASS_LABEL_NAME
                       , V_RPT_CODE_NM_ETC                              AS LARGE_CLASS_LABEL_NAME
                       , ''                                             AS DAY_CODE
                       , '01' || MIN(A.BASIS_START_DATE) || '01'        AS SORT_ORDER_NO
                    FROM SCM_SYS_CALENDAR_M A
                   WHERE A.CALENDAR_YYYY BETWEEN V_FROM_YYYY AND V_TO_YYYY_MONTHLY
                   GROUP BY A.CALENDAR_YYYY
                          , A.BASIS_YYYYMM
                          , A.MONTH_NAME
                   ORDER BY A.BASIS_YYYYMM
                          , A.MONTH_NAME)
        LOOP
            N_IDX := N_IDX + 1;
            V_TBL1(N_IDX) := T_FN_SCP0104_SPREAD_TITLE_ROW(R.COLUMN_NAME, R.COLUMN_LABEL_NAME
                           , R.SMALL_CLASS_LABEL_NAME, R.LARGE_CLASS_LABEL_NAME, R.DAY_CODE, R.SORT_ORDER_NO);
        END LOOP;

    END IF;

    /* 4~6년까지는 연도별 */
    IF P_PROGRAM_ID = 'SCP0106'
    THEN

        FOR R IN (SELECT 'Y_' || A.CALENDAR_YYYY                        AS COLUMN_NAME
                       , A.CALENDAR_YYYY                                AS COLUMN_LABEL_NAME
                       , A.CALENDAR_YYYY                                AS SMALL_CLASS_LABEL_NAME
                       , V_RPT_CODE_NM_PLAN                             AS LARGE_CLASS_LABEL_NAME
                       , ''                                             AS DAY_CODE
                       , '01' || MIN(A.BASIS_START_DATE) || '01'        AS SORT_ORDER_NO
                    FROM SCM_SYS_CALENDAR_M A
                   WHERE A.CALENDAR_YYYY BETWEEN V_FROM_YYYY_YEAR AND V_TO_YYYY_YEAR
                   GROUP BY A.CALENDAR_YYYY
                   ORDER BY A.CALENDAR_YYYY)
        LOOP
            N_IDX := N_IDX + 1;
            V_TBL1(N_IDX) := T_FN_SCP0104_SPREAD_TITLE_ROW(R.COLUMN_NAME, R.COLUMN_LABEL_NAME
                           , R.SMALL_CLASS_LABEL_NAME, R.LARGE_CLASS_LABEL_NAME, R.DAY_CODE, R.SORT_ORDER_NO);
        END LOOP;

    ELSE

        FOR R IN (SELECT 'Y_' || A.CALENDAR_YYYY                        AS COLUMN_NAME
                       , A.CALENDAR_YYYY                                AS COLUMN_LABEL_NAME
                       , A.CALENDAR_YYYY                                AS SMALL_CLASS_LABEL_NAME
                       , V_RPT_CODE_NM_ETC                              AS LARGE_CLASS_LABEL_NAME
                       , ''                                             AS DAY_CODE
                       , '01' || MIN(A.BASIS_START_DATE) || '01'        AS SORT_ORDER_NO
                    FROM SCM_SYS_CALENDAR_M A
                   WHERE A.CALENDAR_YYYY BETWEEN V_FROM_YYYY_YEAR AND V_TO_YYYY_YEAR
                   GROUP BY A.CALENDAR_YYYY
                   ORDER BY A.CALENDAR_YYYY)
        LOOP
            N_IDX := N_IDX + 1;
            V_TBL1(N_IDX) := T_FN_SCP0104_SPREAD_TITLE_ROW(R.COLUMN_NAME, R.COLUMN_LABEL_NAME
                           , R.SMALL_CLASS_LABEL_NAME, R.LARGE_CLASS_LABEL_NAME, R.DAY_CODE, R.SORT_ORDER_NO);
        END LOOP;

    END IF;

    /* 조회 시작 월보다 앞선 월은 뺀다 */
    N_CNT := N_IDX;
    N_IDX := 0;

    FOR I IN 1 .. N_CNT
    LOOP

        IF NOT (SUBSTR(V_TBL1(I).COLUMN_NAME, 5, 6) < P_FROM_YYYYMM)
        THEN
            N_IDX := N_IDX + 1;
            PIPE ROW (V_TBL1(I));

            /* 우선순위 컬럼 추가 */
            IF P_PROGRAM_ID IN ('SCP0105', 'SCP0106')
            THEN
                PIPE ROW (T_FN_SCP0104_SPREAD_TITLE_ROW(
                              V_TBL1(I).COLUMN_NAME || '_ASSIGN_PRIORITY'
                            , V_TBL1(I).COLUMN_LABEL_NAME
                            , V_TBL1(I).SMALL_CLASS_LABEL_NAME
                            , V_TBL1(I).LARGE_CLASS_LABEL_NAME
                            , V_TBL1(I).DAY_CODE
                            , '99' || SUBSTR(V_TBL1(I).SORT_ORDER_NO, 3)));
            END IF;

        END IF;

    END LOOP;

    RETURN;

END FN_SCP0104_GET_SPREAD_TITLE;