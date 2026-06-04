-- ============================================================================
-- SCM0009 권한 승인 화면 — UP_FX_GetApprovalAuthRequest 정밀 fix
-- 작성: 2026-06-04
-- AS-IS: dbo.UP_FX_GetApprovalAuthRequest (MSSQL, 71 lines, 2018~2023)
-- 현재 Oracle 상태: INVALID (자동변환 결함 4건 - line 29 alias single-quote /
--                  line 38 truncation / line 56 group by 끝 ',;' / SELECT INTO 누락)
-- 변환 룰:
--   (1) AS-IS standalone SELECT → OPEN O_RC1 FOR ... (SYS_REFCURSOR 반환)
--   (2) (NOLOCK) 제거 (Oracle read consistency 자동)
--   (3) alias 'X' → AS "X" (Oracle 표준)
--   (4) isnull(x,'') = '' → x IS NULL (Oracle 에서 '' = NULL)
--   (5) + 문자열 연결 → ||
--   (6) N'%' → '%' (Oracle 은 NVARCHAR literal prefix 불요)
--   (7) String_Split(@x,',') → SCM_MGR.FN_SCM_STRING_SPLIT (PIPELINED TABLE function)
--   (8) IN ( SELECT ... ) 패턴 보존
-- ============================================================================

CREATE OR REPLACE PROCEDURE SCM_MGR.UP_FX_GetApprovalAuthRequest
(
    p_userId     IN  VARCHAR2,    -- FE: userId (sub-string match on b.USER_NAME OR a.USER_ID)
    p_startDate  IN  VARCHAR2,    -- FE: startDate (YYYYMMDD) → AS-IS p_ReqFromDate
    p_endDate    IN  VARCHAR2,    -- FE: endDate (YYYYMMDD)   → AS-IS p_ReqToDate
    p_status     IN  VARCHAR2,    -- FE: status (REQUEST/APPROVED/REJECTED) → AS-IS p_ApprResult
    O_RC1        OUT SYS_REFCURSOR
)
/*
 * Program ID   : UP_FX_GetApprovalAuthRequest
 * Description  : 신규사용자 권한 요청 승인 조회 (AS-IS dbo.UP_FX_GetApprovalAuthRequest)
 *                TO-BE 신호: AS-IS 8 IN (div/userId/deptName/reqFrom/reqTo/apprFrom/apprTo/apprResult)
 *                          → TO-BE 화면이 보내는 4 IN (userId/startDate/endDate/status) 만 활용.
 *                          AS-IS 미사용 4 filter (div/deptName/apprFrom/apprTo) 는 TO-BE 화면 미노출이라 제거.
 *                          향후 화면 확장 시 SP signature 재정의 필요.
 * Program History
 *=================================================================================================
 * Date         In Charge    Description
 *=================================================================================================
 * 2018.03.06   KYH          Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP)
 * 2018.04.06   ygkim        조회 기간 조건 수정
 * 2018.06.05   ygkim        Plant Name 가져오는 부분 수정
 * 2023.02.01   lwy          PJ20216994 권한 승인 화면내 법인정보 추가 (COMPANY_ID/WORKING_NAME/SSO_LOCATE)
 * 2026.06.04   gyucheollee  Oracle 정밀 변환 + TO-BE FE 4 IN 매칭 (positional camelCase binding)
 *                          + SELECT → OPEN REFCURSOR + alias quote 정정 + GROUP BY syntax 정정
 *                          + SCM_MST_PLANT_SN dangling synonym → empty view redirect (별도 fix)
 */
AS
    v_ReqFromDate VARCHAR2(10);   -- YYYY-MM-DD
    v_ReqToDate   VARCHAR2(10);
BEGIN
    -- FE YYYYMMDD → AS-IS YYYY-MM-DD 형식 변환 (NULL 안전)
    v_ReqFromDate := CASE WHEN p_startDate IS NULL OR LENGTH(p_startDate) <> 8 THEN NULL
                          ELSE SUBSTR(p_startDate, 1, 4) || '-' || SUBSTR(p_startDate, 5, 2) || '-' || SUBSTR(p_startDate, 7, 2)
                     END;
    v_ReqToDate   := CASE WHEN p_endDate   IS NULL OR LENGTH(p_endDate)   <> 8 THEN NULL
                          ELSE SUBSTR(p_endDate,   1, 4) || '-' || SUBSTR(p_endDate,   5, 2) || '-' || SUBSTR(p_endDate,   7, 2)
                     END;

    OPEN O_RC1 FOR
        SELECT
            ' '                                                  AS CHK,
            -- composite key 합성 (FE 가 REQUEST_ID 1개만 보내는 패턴 지원)
            -- format: USER_ID|GROUP_ID|DIVISION_ID|PLANT_ID
            a.USER_ID || '|' || a.GROUP_ID || '|' || a.DIVISION_ID || '|' || a.PLANT_ID  AS REQUEST_ID,
            a.CREATION_DATE                                      AS REQUEST_DATE,
            a.USER_ID,
            b.USER_NAME,
            b.COMPANY_ID,
            b.WORKING_NAME,
            b.SSO_LOCATE,
            b.DEPT_ID,
            c.DEPT_NAME_KO,
            a.GROUP_ID,
            a.DIVISION_ID,
            d.DIVISION_NAME,
            a.PLANT_ID,
            MAX(CASE
                    WHEN SN.PLANT_NAME IS NULL OR SN.PLANT_NAME = '' THEN V.VENDOR_NAME
                    ELSE SN.PLANT_NAME
                END)                                              AS PLANT_NAME,
            a.APPROVAL_RESULT,
            a.APPROVAL_USER,
            a.REJECT_REASON,
            a.LAST_UPDATE_DATE                                    AS APPROVAL_DATE
          FROM SCM_MST_AUTH_REQUEST          a
          INNER JOIN SCM_MST_SSO_USER_INFO   b ON a.USER_ID    = b.USER_ID
          LEFT JOIN  SCM_MST_SSO_DEPT_INFO   c ON b.DEPT_ID    = c.DEPT_ID
          LEFT JOIN  SCM_MST_DIVISION        d ON a.DIVISION_ID= d.DIVISION_ID
          LEFT OUTER JOIN SCM_MST_PLANT_SN   sn ON a.DIVISION_ID = sn.DIVISION_ID AND a.PLANT_ID = sn.PLANT_ID
          LEFT OUTER JOIN SCM_MST_VENDOR     v  ON v.VENDOR_CODE  = a.PLANT_ID
         WHERE 1 = 1
           AND (v_ReqFromDate IS NULL OR a.CREATION_DATE >= TO_DATE(v_ReqFromDate || ' 00:00:00', 'YYYY-MM-DD HH24:MI:SS'))
           AND (v_ReqToDate   IS NULL OR a.CREATION_DATE <= TO_DATE(v_ReqToDate   || ' 23:59:59', 'YYYY-MM-DD HH24:MI:SS'))
           AND (p_status IS NULL OR p_status = ''
                OR a.APPROVAL_RESULT IN (SELECT COLUMN_VALUE FROM TABLE(SCM_MGR.FN_SCM_STRING_SPLIT(p_status, ','))))
           AND (p_userId IS NULL OR p_userId = ''
                OR b.USER_NAME LIKE '%' || p_userId || '%'
                OR a.USER_ID   LIKE '%' || p_userId || '%')
         GROUP BY
            a.CREATION_DATE,
            a.USER_ID,
            a.GROUP_ID,
            a.DIVISION_ID,
            a.PLANT_ID,
            b.USER_NAME,
            b.COMPANY_ID,
            b.WORKING_NAME,
            b.SSO_LOCATE,
            b.DEPT_ID,
            c.DEPT_NAME_KO,
            d.DIVISION_NAME,
            a.APPROVAL_RESULT,
            a.APPROVAL_USER,
            a.REJECT_REASON,
            a.LAST_UPDATE_DATE
         ORDER BY a.CREATION_DATE ASC, a.DIVISION_ID ASC, a.USER_ID ASC;
END UP_FX_GetApprovalAuthRequest;
/

SHOW ERRORS PROCEDURE SCM_MGR.UP_FX_GetApprovalAuthRequest;
