-- =============================================================================
-- 사용자별 로그인 정보 · UI 사용정보 조회 (클라우드 QA 용 · 조회 전용 SELECT)
-- 작성 2026-11-04
--
-- 원천 (BE 코드 기준)
--   SCM_MGR.SCM_COM_SYS_LOG  ← LogInterceptor.insertSystemLog → sql/admin/log.xml insertSysLog
--     LOG_TP_CD  LOGIN / LOGOUT       : LoginSuccessHandler · LogoutResponseHandler (@SystemLog)
--                BUTTON               : GeneralController call-proc · call-proc-stream (MNU_ID·SHT_NM·MNU_BTN_CD)
--                EXCELUPLOAD          : FileController (MNU_ID·SHT_NM·MNU_BTN_CD)
--                MENU                 : 메뉴 접속 (MNU_ID) — 사내 DB 2026-11-02 부터 적재
--                LOOKUP / COMBO       : 콤보·룩업 조회 (화면 사용 지표에서는 제외)
--                SYSTEM               : 기타
--     CREATED_BY = 사용자 ID, RQR_CLNT_IP = 접속 IP, LOG_ST_DTM~LOG_END_DTM = 요청 시작~종료(TIMESTAMP)
--   SCM_MGR.SCM_ADM_USER_M   : USER_NM · DEPT_ID · LOGN_DTM(최종 로그인)
--   SCM_MGR.SCM_ADM_MNU_M + SCM_ADM_MSG_M : 메뉴명 (MNU_MSG_ID → MSG_NM, 없으면 MNU_DESC)
--
-- 사용법
--   :FROM_DT, :TO_DT = 'YYYYMMDD' (둘 다 포함) — DBeaver 는 실행 시 값 입력 창이 뜬다
--   :LANG_CD = 'KO' 또는 'EN'
--   SQL*Plus 는 VARIABLE FROM_DT VARCHAR2(8); EXEC :FROM_DT := '20261101'; 처럼 먼저 선언
--
-- 주의
--   · 로그인 실패는 적재되지 않는다 (LoginFailureHandler 에 @SystemLog 없음)
--   · SCM_COM_SYS_LOG 인덱스 = PK(SYS_LOG_ID) 1개 뿐 → 기간 조건도 전체 스캔. 기간을 좁혀 실행
--   · 앱 계정(SCMP_APP)으로 접속하면 SCM_MGR. 접두를 빼도 된다 (시노님 존재)
-- =============================================================================


-- [1] 사용자별 로그인 요약 ----------------------------------------------------
SELECT  L.CREATED_BY                                         AS USER_ID
      , U.USER_NM
      , U.DEPT_ID
      , SUM(CASE WHEN L.LOG_TP_CD = 'LOGIN'  THEN 1 ELSE 0 END) AS LOGIN_CNT
      , SUM(CASE WHEN L.LOG_TP_CD = 'LOGOUT' THEN 1 ELSE 0 END) AS LOGOUT_CNT
      , COUNT(DISTINCT CASE WHEN L.LOG_TP_CD = 'LOGIN' THEN TRUNC(L.CREATION_DATE) END) AS LOGIN_DAYS
      , TO_CHAR(MIN(CASE WHEN L.LOG_TP_CD = 'LOGIN' THEN L.LOG_ST_DTM END), 'YYYY-MM-DD HH24:MI:SS') AS FIRST_LOGIN
      , TO_CHAR(MAX(CASE WHEN L.LOG_TP_CD = 'LOGIN' THEN L.LOG_ST_DTM END), 'YYYY-MM-DD HH24:MI:SS') AS LAST_LOGIN
      , COUNT(DISTINCT L.RQR_CLNT_IP)                         AS IP_CNT
      , TO_CHAR(U.LOGN_DTM, 'YYYY-MM-DD HH24:MI:SS')          AS USER_M_LOGN_DTM
  FROM  SCM_MGR.SCM_COM_SYS_LOG L
  LEFT JOIN SCM_MGR.SCM_ADM_USER_M U
         ON U.USER_ID = L.CREATED_BY
 WHERE  L.LOG_TP_CD IN ('LOGIN', 'LOGOUT')
   AND  L.CREATION_DATE >= TO_DATE(:FROM_DT, 'YYYYMMDD')
   AND  L.CREATION_DATE <  TO_DATE(:TO_DT,   'YYYYMMDD') + 1
 GROUP BY L.CREATED_BY, U.USER_NM, U.DEPT_ID, U.LOGN_DTM
 ORDER BY LOGIN_CNT DESC, USER_ID;


-- [2] 로그인 / 로그아웃 상세 이력 --------------------------------------------
SELECT  TO_CHAR(L.LOG_ST_DTM, 'YYYY-MM-DD HH24:MI:SS')        AS LOG_DTM
      , L.LOG_TP_CD
      , L.CREATED_BY                                         AS USER_ID
      , U.USER_NM
      , L.RQR_CLNT_IP                                        AS CLIENT_IP
      , L.EXCT_MSG_CTN                                       AS ERROR_MSG
  FROM  SCM_MGR.SCM_COM_SYS_LOG L
  LEFT JOIN SCM_MGR.SCM_ADM_USER_M U
         ON U.USER_ID = L.CREATED_BY
 WHERE  L.LOG_TP_CD IN ('LOGIN', 'LOGOUT')
   AND  L.CREATION_DATE >= TO_DATE(:FROM_DT, 'YYYYMMDD')
   AND  L.CREATION_DATE <  TO_DATE(:TO_DT,   'YYYYMMDD') + 1
 ORDER BY L.LOG_ST_DTM DESC;


-- [3] 사용자 × 메뉴 사용 요약 (메뉴 접속 · 버튼 실행 · 엑셀 업로드) ---------
SELECT  L.CREATED_BY                                         AS USER_ID
      , U.USER_NM
      , L.MNU_ID
      , NVL(MSG.MSG_NM, M.MNU_DESC)                          AS MNU_NM
      , SUM(CASE WHEN L.LOG_TP_CD = 'MENU'        THEN 1 ELSE 0 END) AS MENU_OPEN_CNT
      , SUM(CASE WHEN L.LOG_TP_CD = 'BUTTON'      THEN 1 ELSE 0 END) AS BUTTON_CNT
      , SUM(CASE WHEN L.LOG_TP_CD = 'EXCELUPLOAD' THEN 1 ELSE 0 END) AS EXCEL_UPLOAD_CNT
      , SUM(CASE WHEN L.EXCT_MSG_CTN IS NOT NULL  THEN 1 ELSE 0 END) AS ERROR_CNT
      , COUNT(DISTINCT TRUNC(L.CREATION_DATE))               AS USE_DAYS
      , TO_CHAR(MIN(L.LOG_ST_DTM), 'YYYY-MM-DD HH24:MI:SS')   AS FIRST_USE
      , TO_CHAR(MAX(L.LOG_ST_DTM), 'YYYY-MM-DD HH24:MI:SS')   AS LAST_USE
  FROM  SCM_MGR.SCM_COM_SYS_LOG L
  LEFT JOIN SCM_MGR.SCM_ADM_USER_M U
         ON U.USER_ID = L.CREATED_BY
  LEFT JOIN SCM_MGR.SCM_ADM_MNU_M M
         ON M.MNU_ID = L.MNU_ID
  LEFT JOIN SCM_MGR.SCM_ADM_MSG_M MSG
         ON MSG.MSG_ID = M.MNU_MSG_ID
        AND MSG.LANG_CD = :LANG_CD
 WHERE  L.LOG_TP_CD IN ('MENU', 'BUTTON', 'EXCELUPLOAD')
   AND  L.CREATION_DATE >= TO_DATE(:FROM_DT, 'YYYYMMDD')
   AND  L.CREATION_DATE <  TO_DATE(:TO_DT,   'YYYYMMDD') + 1
 GROUP BY L.CREATED_BY, U.USER_NM, L.MNU_ID, NVL(MSG.MSG_NM, M.MNU_DESC)
 ORDER BY USER_ID, BUTTON_CNT DESC, MENU_OPEN_CNT DESC;


-- [4] 사용자 × 메뉴 × 시트 × 버튼 실행 상세 (횟수 · 오류 · 소요 시간 ms) ----
SELECT  L.CREATED_BY                                         AS USER_ID
      , U.USER_NM
      , L.MNU_ID
      , NVL(MSG.MSG_NM, M.MNU_DESC)                          AS MNU_NM
      , L.SHT_NM
      , L.MNU_BTN_CD
      , L.LOG_TP_CD
      , COUNT(*)                                             AS EXEC_CNT
      , SUM(CASE WHEN L.EXCT_MSG_CTN IS NOT NULL THEN 1 ELSE 0 END) AS ERROR_CNT
      , ROUND(AVG(  EXTRACT(DAY    FROM (L.TRNM_END_DTM - L.TRNM_ST_DTM)) * 86400000
                  + EXTRACT(HOUR   FROM (L.TRNM_END_DTM - L.TRNM_ST_DTM)) * 3600000
                  + EXTRACT(MINUTE FROM (L.TRNM_END_DTM - L.TRNM_ST_DTM)) * 60000
                  + EXTRACT(SECOND FROM (L.TRNM_END_DTM - L.TRNM_ST_DTM)) * 1000)) AS AVG_SERVER_MS
      , ROUND(MAX(  EXTRACT(DAY    FROM (L.TRNM_END_DTM - L.TRNM_ST_DTM)) * 86400000
                  + EXTRACT(HOUR   FROM (L.TRNM_END_DTM - L.TRNM_ST_DTM)) * 3600000
                  + EXTRACT(MINUTE FROM (L.TRNM_END_DTM - L.TRNM_ST_DTM)) * 60000
                  + EXTRACT(SECOND FROM (L.TRNM_END_DTM - L.TRNM_ST_DTM)) * 1000)) AS MAX_SERVER_MS
      , TO_CHAR(MAX(L.LOG_ST_DTM), 'YYYY-MM-DD HH24:MI:SS')   AS LAST_EXEC
  FROM  SCM_MGR.SCM_COM_SYS_LOG L
  LEFT JOIN SCM_MGR.SCM_ADM_USER_M U
         ON U.USER_ID = L.CREATED_BY
  LEFT JOIN SCM_MGR.SCM_ADM_MNU_M M
         ON M.MNU_ID = L.MNU_ID
  LEFT JOIN SCM_MGR.SCM_ADM_MSG_M MSG
         ON MSG.MSG_ID = M.MNU_MSG_ID
        AND MSG.LANG_CD = :LANG_CD
 WHERE  L.LOG_TP_CD IN ('BUTTON', 'EXCELUPLOAD')
   AND  L.CREATION_DATE >= TO_DATE(:FROM_DT, 'YYYYMMDD')
   AND  L.CREATION_DATE <  TO_DATE(:TO_DT,   'YYYYMMDD') + 1
 GROUP BY L.CREATED_BY, U.USER_NM, L.MNU_ID, NVL(MSG.MSG_NM, M.MNU_DESC), L.SHT_NM, L.MNU_BTN_CD, L.LOG_TP_CD
 ORDER BY USER_ID, L.MNU_ID, EXEC_CNT DESC;


-- [5] 일자별 사용 현황 (접속 사용자 수 · 로그인 · 메뉴 접속 · 버튼 실행) ----
SELECT  TO_CHAR(TRUNC(L.CREATION_DATE), 'YYYY-MM-DD')        AS USE_DT
      , COUNT(DISTINCT L.CREATED_BY)                         AS USER_CNT
      , SUM(CASE WHEN L.LOG_TP_CD = 'LOGIN'       THEN 1 ELSE 0 END) AS LOGIN_CNT
      , SUM(CASE WHEN L.LOG_TP_CD = 'MENU'        THEN 1 ELSE 0 END) AS MENU_OPEN_CNT
      , SUM(CASE WHEN L.LOG_TP_CD = 'BUTTON'      THEN 1 ELSE 0 END) AS BUTTON_CNT
      , SUM(CASE WHEN L.LOG_TP_CD = 'EXCELUPLOAD' THEN 1 ELSE 0 END) AS EXCEL_UPLOAD_CNT
      , COUNT(DISTINCT CASE WHEN L.LOG_TP_CD IN ('MENU', 'BUTTON', 'EXCELUPLOAD') THEN L.MNU_ID END) AS MNU_CNT
  FROM  SCM_MGR.SCM_COM_SYS_LOG L
 WHERE  L.LOG_TP_CD IN ('LOGIN', 'MENU', 'BUTTON', 'EXCELUPLOAD')
   AND  L.CREATION_DATE >= TO_DATE(:FROM_DT, 'YYYYMMDD')
   AND  L.CREATION_DATE <  TO_DATE(:TO_DT,   'YYYYMMDD') + 1
 GROUP BY TRUNC(L.CREATION_DATE)
 ORDER BY USE_DT;


-- [6] 사용자 1명의 사용 이력 상세 (시간 순) — :USER_ID 입력 ------------------
SELECT  TO_CHAR(L.LOG_ST_DTM, 'YYYY-MM-DD HH24:MI:SS')        AS LOG_DTM
      , L.LOG_TP_CD
      , L.MNU_ID
      , NVL(MSG.MSG_NM, M.MNU_DESC)                          AS MNU_NM
      , L.SHT_NM
      , L.MNU_BTN_CD
      , L.CALL_PGM_URL
      , L.RQR_CLNT_IP                                        AS CLIENT_IP
      , L.EXCT_MSG_CTN                                       AS ERROR_MSG
  FROM  SCM_MGR.SCM_COM_SYS_LOG L
  LEFT JOIN SCM_MGR.SCM_ADM_MNU_M M
         ON M.MNU_ID = L.MNU_ID
  LEFT JOIN SCM_MGR.SCM_ADM_MSG_M MSG
         ON MSG.MSG_ID = M.MNU_MSG_ID
        AND MSG.LANG_CD = :LANG_CD
 WHERE  L.CREATED_BY = :USER_ID
   AND  L.LOG_TP_CD IN ('LOGIN', 'LOGOUT', 'MENU', 'BUTTON', 'EXCELUPLOAD')
   AND  L.CREATION_DATE >= TO_DATE(:FROM_DT, 'YYYYMMDD')
   AND  L.CREATION_DATE <  TO_DATE(:TO_DT,   'YYYYMMDD') + 1
 ORDER BY L.LOG_ST_DTM DESC;
