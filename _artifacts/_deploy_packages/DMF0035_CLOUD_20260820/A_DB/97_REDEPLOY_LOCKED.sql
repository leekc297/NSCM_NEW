-- =====================================================================================================
-- 97_REDEPLOY_LOCKED.sql — 조회 세션이 물고 있어 PKG 재배포(13/15/17)가 끝나지 않을 때
--
--   [증상] `CREATE OR REPLACE PACKAGE BODY` 가 응답 없이 대기.
--   [원인] 실행 중인 세션이 그 패키지에 **library cache pin** 을 잡고 있다. 재배포는 **배타 잠금**이
--          필요해 그 세션이 끝날 때까지 기다린다. 지금 클라우드에는 1,302초짜리 조회가 돌고 있으므로
--          (96 P1 실측: SCMP_APP 2세션, 563초·262초 경과) 그게 끝나기 전에는 배포가 진행되지 않는다.
--   ⚠ **가장 위험한 함정**: 대기하다 취소하면 배포가 안 된 채로 "했다"고 착각하기 쉽다.
--      판정은 반드시 `LAST_DDL_TIME` 변경 + DS2 마커로 한다(아래 R4). 시간이 안 변했으면 미반영이다.
--   ⚠ 배포 중에는 **화면에서 조회를 다시 누르지 말 것** — 새 세션이 또 pin 을 잡아 대기가 무한 연장된다.
-- =====================================================================================================
SET LINESIZE 220
SET PAGESIZE 100

PROMPT ===== R1. 지금 패키지를 물고 있는 세션 (배포를 막는 주체) =====
SELECT S.SID, S.SERIAL#, S.USERNAME, S.STATUS, S.LAST_CALL_ET RUNNING_SEC,
       S.EVENT, S.SQL_ID, O.OBJECT_NAME AS PLSQL_ENTRY
  FROM V$SESSION S
  LEFT JOIN ALL_OBJECTS O ON O.OBJECT_ID = S.PLSQL_ENTRY_OBJECT_ID
 WHERE S.USERNAME IS NOT NULL
   AND ( O.OBJECT_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051')
      OR S.SID IN (SELECT SID FROM V$ACCESS
                    WHERE OWNER='SCM_MGR'
                      AND OBJECT IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051')) )
 ORDER BY S.LAST_CALL_ET DESC;

PROMPT ===== R2. kill 문 자동 생성 (DBA 권한 필요 — SCM_MGR 은 ORA-01031 날 수 있음) =====
--  ⚠ SERIAL# 는 바뀔 수 있다. **kill 직전에 R1 을 다시 돌려** 최신 SID,SERIAL# 로 실행할 것
--    (오래된 값으로 실행하면 ORA-00026: 지정한 세션 ID 없음).
SELECT 'ALTER SYSTEM KILL SESSION ''' || S.SID || ',' || S.SERIAL# || ''' IMMEDIATE;' AS KILL_STMT
  FROM V$SESSION S
  LEFT JOIN ALL_OBJECTS O ON O.OBJECT_ID = S.PLSQL_ENTRY_OBJECT_ID
 WHERE S.USERNAME IS NOT NULL
   AND O.OBJECT_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051');

PROMPT ===== R3. 권장 실행 순서 (race 방지 — 배포를 먼저 '대기열'에 올린다) =====
PROMPT   ① 배포 세션(A)에서 먼저:  ALTER SESSION SET DDL_LOCK_TIMEOUT = 600;
PROMPT                             @13_PKG_DMF0035_BODY.sql     ← 여기서 대기 상태로 둔다
PROMPT   ② 별도 세션(B)에서:       R1 재조회 → R2 의 kill 문 실행 (DBA 계정)
PROMPT   ③ 세션 A 가 잠금을 얻는 즉시 컴파일된다 (SHOW ERRORS 로 결과 확인)
PROMPT   ※ 순서를 뒤집으면(kill 먼저) 그 틈에 화면이 재조회를 걸어 다시 pin 이 잡힌다.
PROMPT   ※ 근본적으로 조용한 시간대(사용자 조회 없는 시점)에 배포하는 것이 가장 안전하다.

PROMPT ===== R4. ⭐ 반영 판정 — 여기서 확인되기 전에는 "적용했다"고 보지 말 것 =====
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS,
       TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL
  FROM ALL_OBJECTS
 WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051')
 ORDER BY 1,2;

SELECT NAME, SUM(CASE WHEN TEXT LIKE '%E20260820-DS2%' THEN 1 ELSE 0 END) DS2_CNT,
       CASE WHEN SUM(CASE WHEN TEXT LIKE '%E20260820-DS2%' THEN 1 ELSE 0 END) >= 1
            THEN 'PASS' ELSE '*** FAIL - 미반영(재배포 필요) ***' END VERDICT
  FROM ALL_SOURCE
 WHERE OWNER='SCM_MGR' AND TYPE='PACKAGE BODY'
   AND NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051')
 GROUP BY NAME ORDER BY 1;

PROMPT ===== R5. (대안) 조회가 끝나기를 기다릴 경우 — 남은 시간 가늠 =====
--  RUNNING_SEC 이 계속 증가하면 아직 진행 중. 클라우드 실측 1,302초/회 이므로 최대 20여 분 걸린다.
SELECT SID, SERIAL#, LAST_CALL_ET RUNNING_SEC, EVENT, SQL_ID FROM V$SESSION
 WHERE STATUS='ACTIVE' AND USERNAME='SCMP_APP' ORDER BY LAST_CALL_ET DESC FETCH FIRST 5 ROWS ONLY;
