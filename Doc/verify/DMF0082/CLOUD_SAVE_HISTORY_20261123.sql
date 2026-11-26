-- DMF0082 단가 저장 'Sql Error' 이력 확인 (클라우드 LIVE 에서 전체 F5)
-- 조회만 함. 기간은 SYSDATE - 7 을 바꿈

-- [1] DMF0082 요청 순서 (초 단위). 저장(SAVE) 바로 뒤 조회(SEARCH)가 오류인지 봄
--   TO_DATE_SENT = 화면이 보낸 종료일. 'Invalid Date' 면 화면 종료일 입력값 문제
--   ERR_YN = Y 인 행이 화면에 'Sql Error' 가 뜬 요청
SELECT TO_CHAR(L.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS')                     AS REQ_AT
     , L.CREATED_BY                                                          AS USER_ID
     , L.SHT_NM                                                              AS SHEET
     , L.MNU_BTN_CD                                                          AS BUTTON
     , CASE WHEN LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0 THEN 'Y' ELSE 'N' END       AS ERR_YN
     , REGEXP_SUBSTR(L.SYS_LOG_MSG_CTN, '"toYyyymmdd":"([^"]*)"', 1, 1, NULL, 1) AS TO_DATE_SENT
     , SUBSTR(L.EXCT_MSG_CTN, 1, 300)                                        AS ORA_MSG
  FROM SCM_MGR.SCM_COM_SYS_LOG L
 WHERE L.MNU_ID = 'DMF0082'
   AND L.LOG_TP_CD IN ('BUTTON','EXCELUPLOAD')
   AND L.CREATION_DATE >= SYSDATE - 7
   AND L.CREATED_BY IN (SELECT E.CREATED_BY
                          FROM SCM_MGR.SCM_COM_SYS_LOG E
                         WHERE E.MNU_ID = 'DMF0082'
                           AND LENGTH(TRIM(E.EXCT_MSG_CTN)) > 0
                           AND E.CREATION_DATE >= SYSDATE - 7)
 ORDER BY L.CREATED_BY, L.CREATION_DATE;

-- [2] 저장 SP 결과 (초 단위). 저장마다 SUCCESS END, FAIL-1(Sql Error), FAIL-2(검증 문구) 중 하나가 남음
--   [1] SAVE 시각과 같은 시각에 SUCCESS END 가 있으면 저장은 끝난 것
SELECT TO_CHAR(B.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS END_AT
     , B.CREATED_BY                                      AS USER_ID
     , B.PROGRAM_NAME
     , B.LOG_TYPE
     , B.LOG_MESSAGE
     , B.LOG_COUNT
     , B.SQL_ERR_MSG
     , B.SQL_BACKTRACE
     , SUBSTR(B.DESCRIPTION, 1, 500)                     AS DESCRIPTION
  FROM SCM_MGR.SCM_SYS_LOG_BATCH B
 WHERE B.PROGRAM_NAME IN ('PKG_DMF0082','PKG_DMF0000','SCM0002_SET_TITLESET_POPUP')
   AND B.CREATION_DATE >= SYSDATE - 7
   AND B.LOG_TYPE IN ('END','ERROR')
   AND B.CREATED_BY <> 'scm_batch'
 ORDER BY B.CREATION_DATE;

-- [3] 최근 90일 DMF0082 저장 계열(SEARCH 외) 요청 중 오류 건수. 0 이면 저장 요청 자체의 오류 이력 없음
SELECT L.SHT_NM AS SHEET
     , L.MNU_BTN_CD AS BUTTON
     , COUNT(*) AS REQ_CNT
     , SUM(CASE WHEN LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0 THEN 1 ELSE 0 END) AS ERR_CNT
     , TO_CHAR(MAX(L.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS') AS LAST_AT
  FROM SCM_MGR.SCM_COM_SYS_LOG L
 WHERE L.MNU_ID = 'DMF0082'
   AND L.MNU_BTN_CD <> 'SEARCH'
   AND L.CREATION_DATE >= SYSDATE - 90
 GROUP BY L.SHT_NM, L.MNU_BTN_CD
 ORDER BY LAST_AT DESC;

-- [4] 다른 화면도 종료일 'Invalid Date' 로 오류가 났는지 (같은 기간 입력 칸을 공용으로 씀)
SELECT L.MNU_ID
     , COUNT(*) AS ERR_CNT
     , TO_CHAR(MAX(L.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS') AS LAST_AT
  FROM SCM_MGR.SCM_COM_SYS_LOG L
 WHERE L.CREATION_DATE >= SYSDATE - 30
   AND LENGTH(TRIM(L.EXCT_MSG_CTN)) > 0
   AND INSTR(L.SYS_LOG_MSG_CTN, 'Invalid Date') > 0
 GROUP BY L.MNU_ID
 ORDER BY ERR_CNT DESC;
