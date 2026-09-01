-- 30_PROCEDURE_PR_GET_DAY_RANGE.sql — API_M 배선 standalone PROCEDURE (VALID, LAST_DDL 2026-07-21 16:39) — 클라우드 부재/구판이면 적용
-- 의존: ['TABLE:SCM_SYS_CALENDAR_M', 'TABLE:TB_FX_USER', 'FUNCTION:FN_MULTY_TIME']
CREATE OR REPLACE PROCEDURE PR_GET_DAY_RANGE
(
    p_created_by       VARCHAR2,
    p_month            INTEGER,
    O_RC1              OUT SYS_REFCURSOR,
    O_RC2              OUT SYS_REFCURSOR,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : PR_GET_DAY_RANGE
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/13  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/07/26  SonYoungSuk    Default 조회구간을 해당 월 1일부터 p_month개월의 마지막 날 까지
 * 2026/07/04  ZIONEX         [PJ202650304] NextSCM Migration : T-SQL 결과셋 2개 → O_RC1/O_RC2 OPEN FOR 복원
 *                            (AS-IS 클라이언트 Tables[1]=월단위 범위 사용), DATEADD→ADD_MONTHS,
 *                            CONVERT(112)→TO_CHAR, WITH(NOLOCK) 제거
 */
    v_user_time_zone VARCHAR2(10 CHAR);
BEGIN

    v_user_time_zone := NULL;

    BEGIN
        SELECT U.TIMEZONE
          INTO v_user_time_zone
          FROM TB_FX_USER U
         WHERE U.USERID = p_created_by;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_user_time_zone := NULL;
    END;

    -- 1st resultset (AS-IS Tables[0]) : 현재 ~ p_month 개월 구간의 ISO 주 경계 정렬 범위
    OPEN O_RC1 FOR
        SELECT MIN(C.BASIS_YYYYMMDD) || ':' || MAX(C.BASIS_YYYYMMDD) AS DAY_RANGE
          FROM SCM_SYS_CALENDAR_M C
             , (SELECT DISTINCT ISO_YYYYWW
                  FROM SCM_SYS_CALENDAR_M
                 WHERE 1 = 1
                   AND BASIS_YYYYMMDD >= TO_CHAR(FN_MULTY_TIME(v_user_time_zone), 'YYYYMMDD')
                   AND BASIS_YYYYMMDD <= TO_CHAR(ADD_MONTHS(FN_MULTY_TIME(v_user_time_zone), p_month), 'YYYYMMDD')
               ) T
         WHERE 1 = 1
           AND C.ISO_YYYYWW = T.ISO_YYYYWW;

    -- 2nd resultset (AS-IS Tables[1], add SonYoungSuk 20180726) : 해당 월 1일 ~ p_month개월의 마지막 날
    OPEN O_RC2 FOR
        SELECT MIN(BASIS_YYYYMMDD) || ':' || MAX(BASIS_YYYYMMDD) AS DAY_RANGE
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD >= TO_CHAR(FN_MULTY_TIME(v_user_time_zone), 'YYYYMM') || '01'                    -- 해당 월 1일
           AND BASIS_YYYYMMDD <= TO_CHAR(TO_DATE(TO_CHAR(ADD_MONTHS(FN_MULTY_TIME(v_user_time_zone), p_month), 'YYYYMM') || '01', 'YYYYMMDD') - 1, 'YYYYMMDD');  -- 해당 월 1일에서 p_month개월의 마지막 날

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

END;
/
