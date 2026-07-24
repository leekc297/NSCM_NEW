-- =====================================================================
-- SCM_ADM_MNU_M.ROUTE_PATH — 클라우드 → 로컬 오라클 동기화 (2026-07-21)
--
-- 배경: SCM_ADM_MNU_M 에 ROUTE_PATH 컬럼 신규 추가(VARCHAR2 4000, NULLABLE 실측).
--   키 = MNU_ID (PK, 유일 100건 실측). 두 인스턴스가 별도 오라클이라 직접 복사 불가 →
--   (A) 클라우드에서 UPDATE 스크립트를 "생성"하고, (B) 로컬에서 그 스크립트를 실행한다.
--   ※ DB LINK 가 있으면 (C) 로 1회 MERGE 가능.
--
-- ⚠ 안전: ROUTE_PATH IS NOT NULL 만 대상(로컬의 기존 값을 NULL 로 덮어쓰지 않음).
--   전체(빈값 포함) 동기화가 필요하면 각 WHERE 의 'ROUTE_PATH IS NOT NULL' 제거.
--   MNU_ID 일치 행만 UPDATE(신규 메뉴 INSERT 안 함 — 메뉴 세트 동일 가정).
-- =====================================================================


-- =====================================================================
-- (A) 클라우드(ROUTE_PATH 보유 DB)에서 실행 → UPDATE 스크립트 파일 생성
--     sqlplus 예: sqlplus SCM_MGR/**@<cloud_dsn> @이파일  (아래 A 블록만)
-- =====================================================================
SET PAGESIZE 0
SET LINESIZE 32767
SET LONG 32767
SET LONGCHUNKSIZE 32767
SET TRIMSPOOL ON
SET FEEDBACK OFF
SET VERIFY OFF
SET HEADING OFF
SET ECHO OFF

SPOOL route_path_update_local.sql

SELECT 'UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = '
       || '''' || REPLACE(ROUTE_PATH, '''', '''''') || ''''
       || ', LAST_UPDATED_BY = ''admin'', LAST_UPDATE_DATE = SYSDATE'
       || ' WHERE MNU_ID = ''' || MNU_ID || ''';'
FROM   SCM_MGR.SCM_ADM_MNU_M
WHERE  ROUTE_PATH IS NOT NULL
ORDER BY MNU_ID;

PROMPT COMMIT;

SPOOL OFF

-- → 생성물: route_path_update_local.sql (UPDATE N건 + COMMIT). 이 파일을 (B) 로 로컬에 실행.
--   (컬럼 SET LAST_UPDATED_BY/DATE 는 감사용 — 해당 컬럼 없으면 위 '|| ', LAST_UPDATED_BY...' ' 절 제거)


-- =====================================================================
-- (B) 로컬(대상 DB)에서 실행 — (A) 산출물 적용
--     sqlplus SCM_MGR/**@<local_dsn> @route_path_update_local.sql
--   (별도 파일이므로 여기서는 예시만; 실제 UPDATE 문은 route_path_update_local.sql 에 들어있음)
-- =====================================================================
-- 예시 형태(자동 생성됨):
-- UPDATE SCM_MGR.SCM_ADM_MNU_M SET ROUTE_PATH = 'demand/demand-plan/forecast-price',
--   LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID = 'DMF0082';
-- ...
-- COMMIT;


-- =====================================================================
-- (C) 대안 — 로컬에 클라우드행 DB LINK 가 있을 때: 로컬에서 1회 MERGE
--     (DB LINK 명은 환경에 맞게 교체. 없으면 (A)+(B) 사용)
-- =====================================================================
-- MERGE INTO SCM_MGR.SCM_ADM_MNU_M t
-- USING ( SELECT MNU_ID, ROUTE_PATH
--         FROM   SCM_MGR.SCM_ADM_MNU_M@CLOUD_DBLINK
--         WHERE  ROUTE_PATH IS NOT NULL ) s
-- ON (t.MNU_ID = s.MNU_ID)
-- WHEN MATCHED THEN UPDATE SET
--   t.ROUTE_PATH = s.ROUTE_PATH,
--   t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE;
-- COMMIT;


-- =====================================================================
-- 검증 (로컬 적용 후):
--   SELECT COUNT(*) TOT, COUNT(ROUTE_PATH) HAS_ROUTE FROM SCM_MGR.SCM_ADM_MNU_M;
--   SELECT MNU_ID, MNU_URL, ROUTE_PATH FROM SCM_MGR.SCM_ADM_MNU_M WHERE ROUTE_PATH IS NOT NULL ORDER BY MNU_ID;
-- 원복: 필요 시 적용 전 백업 —
--   CREATE TABLE SCM_MGR.SCM_ADM_MNU_M_BAK_ROUTE_0721 AS
--     SELECT MNU_ID, ROUTE_PATH FROM SCM_MGR.SCM_ADM_MNU_M;  (로컬에서 (B) 실행 전)
-- =====================================================================
