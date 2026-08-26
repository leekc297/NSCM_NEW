-- ============================================================================================
-- [클라우드에서 실행 #2] DMF0020 역이관 — ALL_SOURCE **원문 추출** (read-only)
--   hook #122: DDL 은 원문 그대로. 재작성·정리 금지.
--
-- 사용법 (SQL*Plus / SQLcl):
--   SET PAGESIZE 0 LINESIZE 32767 TRIMSPOOL ON LONG 100000000 FEEDBACK OFF HEADING OFF ECHO OFF
--   SPOOL DMF0020_CLOUD_SOURCE_20260824.sql
--   @02_CLOUD_EXTRACT_SOURCE.sql
--   SPOOL OFF
-- DBeaver 면 아래 SELECT 결과를 그대로 텍스트로 내보내면 된다(줄 순서 유지 필수).
-- ============================================================================================

-- ── 추출 대상 (사내 배선 실측 기준, 2026-08-24) ────────────────────────────────
--   A. PKG  : PKG_DMF0020 (SPEC + BODY) — 내부 프로시저 16개 포함
--   B. 단독 : 배선이 직접 가리키는 5본 + PKG 가 호출하는 1본
--   ⛔ 제외 : DMF0002_GET_TITLESET_POPUP / DMF0073_GET_VERSION_SALESPRICE (타 화면 소유 공용)
--   ⛔ 제외 : FN_* · PKG_SCM_USER_MNU · PR_* (전사 공용 — 존재·상태만 확인)
-- ────────────────────────────────────────────────────────────────────────────

WITH tgt (NM, TP, SORT) AS (
  SELECT 'PKG_DMF0020',                                  'PACKAGE',      1 FROM DUAL UNION ALL
  SELECT 'PKG_DMF0020',                                  'PACKAGE BODY', 2 FROM DUAL UNION ALL
  SELECT 'DMF0020_GET_SCM_MST_FUTURE_PRICE',             'PROCEDURE',    3 FROM DUAL UNION ALL
  SELECT 'DMF0020_GET_SPREAD_TITLE_DATE',                'PROCEDURE',    4 FROM DUAL UNION ALL
  SELECT 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL',        'PROCEDURE',    5 FROM DUAL UNION ALL
  SELECT 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP',      'PROCEDURE',    6 FROM DUAL UNION ALL
  SELECT 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION', 'PROCEDURE',    7 FROM DUAL)
SELECT TXT FROM (
  SELECT t.SORT, 0 AS LN,
         '-- ============ ' || t.TP || ' ' || t.NM || ' ============' || CHR(10) ||
         'CREATE OR REPLACE ' AS TXT
  FROM   tgt t
  WHERE  EXISTS (SELECT 1 FROM ALL_SOURCE s WHERE s.OWNER='SCM_MGR' AND s.NAME=t.NM AND s.TYPE=t.TP)
  UNION ALL
  SELECT t.SORT, s.LINE, RTRIM(s.TEXT, CHR(10))
  FROM   tgt t JOIN ALL_SOURCE s
         ON s.OWNER='SCM_MGR' AND s.NAME=t.NM AND s.TYPE=t.TP
  UNION ALL
  SELECT t.SORT, 999999, '/'
  FROM   tgt t
  WHERE  EXISTS (SELECT 1 FROM ALL_SOURCE s WHERE s.OWNER='SCM_MGR' AND s.NAME=t.NM AND s.TYPE=t.TP)
) ORDER BY SORT, LN;

-- ⚠ 위 결과가 비거나 특정 대상이 통째로 빠지면 = 클라우드에 그 객체가 **없다**는 뜻이다.
--    없는 대상은 01_CLOUD_INVENTORY.sql 의 I1 로 이름이 다른지 먼저 확인할 것(개명 가능성).
