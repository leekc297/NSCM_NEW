-- ============================================================================
-- DMF0020 배포 차단 세션 KILL   (갱신 2026-08-24)
--   BE(local) 접속처 = 100.65.143.121:1521/OCGSCMD_P01 / SCMP_APP  (사내 DB, 내 세션과 동일 인스턴스)
--   증상 : CREATE OR REPLACE PACKAGE BODY 가 'library cache pin' 으로 무한 대기
--          (DDL_LOCK_TIMEOUT 은 TM 락 전용 — library cache pin 에는 걸리지 않는다)
--   원인 : PKG_DMF0020 을 실행 중인 세션이 핀을 쥐고 있다
--   ⚠⚠ SCMP_APP 은 **공용 앱 계정**이다. 전체 KILL 금지 —
--       다른 개발자/서버 세션이 같은 계정으로 붙어 있다.
--       반드시 STATUS='ACTIVE' + SQL_ID 가 문제 문장인 세션만 골라서 KILL 할 것.
--   ⚠ 아래는 모두 '조회' 세션이라 KILL 해도 데이터 손상 없음. 저장 세션이면 절대 금지.
--   ⚠ SERIAL# 은 시점마다 바뀐다. 반드시 1) 을 먼저 실행할 것.
-- ============================================================================

-- 1) 차단자만 정확히 고른다
SELECT S.SID, S.SERIAL#, S.INST_ID, S.LAST_CALL_ET, S.EVENT, S.SQL_ID, S.MACHINE,
       SUBSTR(Q.SQL_TEXT, 1, 80) SQL_HEAD
  FROM GV$SESSION S
  LEFT JOIN GV$SQL Q ON Q.SQL_ID = S.SQL_ID AND Q.CHILD_NUMBER = S.SQL_CHILD_NUMBER
 WHERE S.USERNAME = 'SCMP_APP'
   AND S.STATUS   = 'ACTIVE'
   AND S.LAST_CALL_ET > 60
   AND UPPER(Q.SQL_TEXT) LIKE '%GT_DMF0020%'
 ORDER BY S.LAST_CALL_ET DESC;

-- 2) KILL (조회 시점 스냅샷 — 위 결과로 갱신해서 쓸 것)
ALTER SYSTEM KILL SESSION '511,59622,@1' IMMEDIATE;   -- 829s  db file sequential read  machine=P2605LN0006
ALTER SYSTEM KILL SESSION '508,46421,@1' IMMEDIATE;   -- 727s  direct path read temp  machine=DESKTOP-9T39I8D

-- 3) 해소 확인 — library cache pin 대기가 사라져야 한다
SELECT SID, USERNAME, EVENT, BLOCKING_SESSION FROM GV$SESSION
 WHERE EVENT LIKE 'library cache%';
