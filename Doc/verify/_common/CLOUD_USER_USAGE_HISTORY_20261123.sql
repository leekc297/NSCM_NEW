-- 사용자 1명 기준 NSCM 사용 이력 전체 (로그인, 화면 열기, 버튼, 엑셀 업로드, 오류) (클라우드 LIVE 에서 전체 F5)
-- 조회만 함. 대상 사용자는 각 블록 P 의 'regina28', 기간은 SYSDATE - 30 을 바꿈
-- 이력 원천
--   SCM_COM_SYS_LOG       : LOG_TP_CD = LOGIN, LOGOUT, MENU(화면 열기), BUTTON(조회, 저장 등), EXCELUPLOAD, SYSTEM
--   TB_FX_MENUCONNECTLOG  : 이전 방식 화면 접속 기록. 사내 minyonglee1 은 MENUID 'Workbench' 등 2026-10-29 까지만 있음. NSCM 화면 열기는 SCM_COM_SYS_LOG MENU 로 봄
--   TB_FX_USERCONNECTLOG  : 접속 이력 (사내 마지막 기록 2026-10-30. 운영 기록 여부 미확인)
--   SCM_ADM_USER_M        : 사용자 정보, 마지막 로그인 시각(LOGN_DTM)

-- [1] 사용자 정보
SELECT U.USER_ID, U.USER_NM, U.DEPT_ID, U.USE_YN, U.ACNT_LOK_YN
     , TO_CHAR(U.LOGN_DTM, 'YYYY-MM-DD HH24:MI:SS') AS LAST_LOGIN_AT
  FROM SCM_MGR.SCM_ADM_USER_M U
 WHERE U.USER_ID = 'regina28';

-- [2] 일자별 사용 건수 (로그인, 화면 열기, 버튼, 오류)
WITH P AS (SELECT 'regina28' AS U, SYSDATE - 30 AS FR FROM DUAL)
SELECT TO_CHAR(L.CREATION_DATE, 'YYYY-MM-DD')                              AS USE_DATE
     , SUM(CASE WHEN L.LOG_TP_CD = 'LOGIN'  THEN 1 ELSE 0 END)              AS LOGIN_CNT
     , SUM(CASE WHEN L.LOG_TP_CD = 'LOGOUT' THEN 1 ELSE 0 END)              AS LOGOUT_CNT
     , SUM(CASE WHEN L.LOG_TP_CD = 'MENU'   THEN 1 ELSE 0 END)              AS MENU_OPEN_CNT
     , SUM(CASE WHEN L.LOG_TP_CD IN ('BUTTON','EXCELUPLOAD') THEN 1 ELSE 0 END) AS BUTTON_CNT
     , SUM(CASE WHEN LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0 THEN 1 ELSE 0 END)    AS ERR_CNT
     , TO_CHAR(MIN(L.CREATION_DATE), 'HH24:MI:SS')                          AS FIRST_AT
     , TO_CHAR(MAX(L.CREATION_DATE), 'HH24:MI:SS')                          AS LAST_AT
  FROM SCM_MGR.SCM_COM_SYS_LOG L, P
 WHERE L.CREATED_BY = P.U
   AND L.CREATION_DATE >= P.FR
 GROUP BY TO_CHAR(L.CREATION_DATE, 'YYYY-MM-DD')
 ORDER BY USE_DATE DESC;

-- [3] 로그인, 로그아웃 이력 (접속 IP 포함)
WITH P AS (SELECT 'regina28' AS U, SYSDATE - 30 AS FR FROM DUAL)
SELECT TO_CHAR(L.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS LOG_AT
     , L.LOG_TP_CD
     , L.RQR_CLNT_IP                                     AS CLIENT_IP
     , SUBSTR(L.EXCT_MSG_CTN, 1, 300)                    AS ORA_MSG
  FROM SCM_MGR.SCM_COM_SYS_LOG L, P
 WHERE L.CREATED_BY = P.U
   AND L.CREATION_DATE >= P.FR
   AND L.LOG_TP_CD IN ('LOGIN','LOGOUT')
 ORDER BY L.CREATION_DATE DESC;

-- [4] 화면별 사용 건수 (화면 열기, 버튼별 실행, 오류)
WITH P AS (SELECT 'regina28' AS U, SYSDATE - 30 AS FR FROM DUAL)
SELECT L.MNU_ID
     , MAX(L.MENU_DESCRIPTION)                                            AS MENU_NAME
     , SUM(CASE WHEN L.LOG_TP_CD = 'MENU' THEN 1 ELSE 0 END)               AS OPEN_CNT
     , SUM(CASE WHEN L.MNU_BTN_CD = 'SEARCH' THEN 1 ELSE 0 END)            AS SEARCH_CNT
     , SUM(CASE WHEN L.LOG_TP_CD IN ('BUTTON','EXCELUPLOAD')
                 AND NVL(L.MNU_BTN_CD, '/') <> 'SEARCH' THEN 1 ELSE 0 END) AS OTHER_BTN_CNT
     , SUM(CASE WHEN LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0 THEN 1 ELSE 0 END)   AS ERR_CNT
     , TO_CHAR(MAX(L.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS')              AS LAST_AT
  FROM SCM_MGR.SCM_COM_SYS_LOG L, P
 WHERE L.CREATED_BY = P.U
   AND L.CREATION_DATE >= P.FR
   AND L.LOG_TP_CD IN ('MENU','BUTTON','EXCELUPLOAD')
 GROUP BY L.MNU_ID
 ORDER BY LAST_AT DESC;

-- [5] 전체 사용 순서 (최근 7일, 최근 1000건)
--   로그인 → 화면 열기 → 조회, 저장 → 오류 순서를 그대로 봄. ERR_YN = Y 가 오류
--   SERVER_SEC = 서버 처리 시간(초)
WITH P AS (SELECT 'regina28' AS U, SYSDATE - 7 AS FR FROM DUAL)
SELECT *
  FROM (
        SELECT TO_CHAR(L.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS')                AS REQ_AT
             , L.LOG_TP_CD
             , L.MNU_ID
             , L.MENU_DESCRIPTION                                               AS MENU_NAME
             , L.SHT_NM                                                         AS SHEET
             , L.MNU_BTN_CD                                                     AS BUTTON
             , ROUND((CAST(L.TRNM_END_DTM AS DATE) - CAST(L.TRNM_ST_DTM AS DATE)) * 86400) AS SERVER_SEC
             , CASE WHEN LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0 THEN 'Y' ELSE 'N' END  AS ERR_YN
             , SUBSTR(L.EXCT_MSG_CTN, 1, 300)                                   AS ORA_MSG
             , L.RQR_CLNT_IP                                                    AS CLIENT_IP
          FROM SCM_MGR.SCM_COM_SYS_LOG L, P
         WHERE L.CREATED_BY = P.U
           AND L.CREATION_DATE >= P.FR
         ORDER BY L.CREATION_DATE DESC
       )
 WHERE ROWNUM <= 1000;

-- [6] 화면 열기 이력 (TB_FX_MENUCONNECTLOG, 최근 500건)
WITH P AS (SELECT 'regina28' AS U, SYSDATE - 30 AS FR FROM DUAL)
SELECT *
  FROM (
        SELECT TO_CHAR(M.LOCALTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') AS OPEN_AT
             , M.MENUID
             , M.CNNTCODE
             , M.CNNTDATE
             , M.CNNTTIME
          FROM SCM_MGR.TB_FX_MENUCONNECTLOG M, P
         WHERE M.USERID = P.U
           AND M.LOCALTIMESTAMP >= CAST(P.FR AS TIMESTAMP)
         ORDER BY M.LOCALTIMESTAMP DESC
       )
 WHERE ROWNUM <= 500;

-- [7] 접속 이력 (TB_FX_USERCONNECTLOG, 최근 200건). CNNTDATETIME = YYYYMMDDHH24MISS + 밀리초
SELECT *
  FROM (
        SELECT C.CNNTDATETIME, C.CNNTCODE, C.CNNTIP
          FROM SCM_MGR.TB_FX_USERCONNECTLOG C
         WHERE C.USERID = 'regina28'
         ORDER BY C.CNNTDATETIME DESC
       )
 WHERE ROWNUM <= 200;
