-- =============================================================================
-- DMF0003_CLOUD_SQLPLUS_20260804.sql — 클라우드 전용 sqlplus 통합 실행본 (python 불필요)
--
-- 내용 (사내 적용 완료분과 동일 2건):
--   [패치1] Sales Site 콤보 asYn 게이트 제거  (= CMBO_USERSITE_ASYN_GATE_REMOVAL_20260804.sql)
--   [패치2] 셀 콤보 Auth판 CMBO + SHEET_COLUMNS 전환 + AsIncotermsEdit (= DMF0003_P2 v2)
--   테이블 데이터 INSERT/UPDATE 없음 — CMBO/SHEET_COLUMNS 메타만. 멱등(재실행 안전).
--
-- ⭐ 실행 방법 — QA·DEV 2개 DB 에서 각각 1회씩 (2026-08-04 동시적용 의무):
--   (한글 깨짐 방지)  export NLS_LANG=KOREAN_KOREA.AL32UTF8
--   sqlplus SCM_MGR/<암호>@//<QA호스트>:1521/OCGSCMD_P01
--   SQL> @DMF0003_CLOUD_SQLPLUS_20260804.sql
--   → DEV 호스트로 접속해 동일하게 1회 더 실행
-- =============================================================================
SET DEFINE OFF
SET SQLBLANKLINES ON
SET LINESIZE 200
SET PAGESIZE 100

PROMPT ===== [0] 접속 DB 실체 확인 (QA/DEV 어느 쪽인지 — 진단 0순위) =====
SELECT USER AS CONN_USER,
       SYS_CONTEXT('USERENV','DB_NAME')     AS DB_NAME,
       SYS_CONTEXT('USERENV','SERVER_HOST') AS SERVER_HOST
FROM DUAL;

PROMPT ===== [패치1] asYn 게이트 제거 (2행 기대, 이미 적용 시 0행) =====
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN     = REPLACE(SQL_DTL_CTN, CHR(10) || '  AND NVL(TRIM(@asYn), ''N'') = ''Y''', ''),
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID IN ('UserSiteByEndCustomer', 'SiteByEndCustomer_DMF0003')
   AND DBMS_LOB.INSTR(SQL_DTL_CTN, '@asYn') > 0;

COMMIT;

PROMPT ===== [패치2-1] CMBO 'SiteByEndCustomerAuth' 등록 (1행 기대, 기존재 시 0행) =====
INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT
   'SiteByEndCustomerAuth'
 , 'DM'
 , 'DMF0003 셀 Sales Site (AS-IS Auth 1:1 부서제약)'
 , 'SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID AS CODE, A.SCM_SITE_ID AS NAME' || CHR(10) ||
   'FROM SCM_MST_SITE A' || CHR(10) ||
   'WHERE A.SITE_TYPE = ''SALES''' || CHR(10) ||
   '  AND A.VALID_YN = ''Y''' || CHR(10) ||
   '  AND A.DIVISION_ID IN (SELECT UNIT_ID FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M' || CHR(10) ||
   '                        WHERE USER_ID = @sesUserId AND UNIT_TP_CD = ''D'' AND USE_YN = ''Y'')' || CHR(10) ||
   '  AND ( A.DEPT_ID IS NULL' || CHR(10) ||
   '     OR EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M G' || CHR(10) ||
   '                WHERE G.USER_ID = @sesUserId AND G.USER_GR_ID = ''ADMIN'' AND G.USE_YN = ''Y'')' || CHR(10) ||
   '     OR A.DEPT_ID IN (' || CHR(10) ||
   '          SELECT L.SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL L' || CHR(10) ||
   '          WHERE L.LOOKUP_TYPE = ''PM_TEAM_MAPPING'' AND L.VALID_YN = ''Y''' || CHR(10) ||
   '            AND L.SEGMENT1 IN (SELECT U.DEPT_ID FROM TB_FX_USER U WHERE U.USERID = @sesUserId)' || CHR(10) ||
   '          UNION' || CHR(10) ||
   '          SELECT U.DEPT_ID FROM TB_FX_USER U WHERE U.USERID = @sesUserId))' || CHR(10) ||
   'ORDER BY CODE'
 , 'Y'
 , 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M X WHERE X.SQL_ID = 'SiteByEndCustomerAuth');

PROMPT ===== [패치2-2] CMBO 'AsIncotermsEdit' 등록 (1행 기대, 기존재 시 0행) =====
INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT
   'AsIncotermsEdit'
 , 'DM'
 , 'DMF0003 AS 사이트 전용 Incoterms 편집 (AS-IS AS_INCOTERMS lookup 1:1)'
 , 'SELECT SEGMENT2 AS CODE, ATTRIBUTE1 AS NAME' || CHR(10) ||
   'FROM SCM_ADM_LOOKUP_MASTER_DETAIL' || CHR(10) ||
   'WHERE LOOKUP_TYPE = ''AS_INCOTERMS''' || CHR(10) ||
   '  AND VALID_YN = ''Y''' || CHR(10) ||
   '  AND SEGMENT1 = @divisionId' || CHR(10) ||
   'ORDER BY SEGMENT2'
 , 'Y'
 , 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M X WHERE X.SQL_ID = 'AsIncotermsEdit');

PROMPT ===== [패치2-3] DMF0003 'Mkt Fcst' SCM_SITE_ID 셀 콤보 -> Auth판 전환 (1행 기대, 기적용 시 0행) =====
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET CELL_COMBO_DATA_TYPE = 'SiteByEndCustomerAuth',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'Mkt Fcst' AND COLUMN_NAME = 'SCM_SITE_ID'
   AND CELL_COMBO_DATA_TYPE = 'SiteByEndCustomer';

COMMIT;

PROMPT ===== [검증1] asYn 잔존 0 + AS branch 존치 (2행 모두 ASYN_REMAIN=0, AS_BRANCH>0 이어야 함) =====
SELECT SQL_ID,
       DBMS_LOB.INSTR(SQL_DTL_CTN, '@asYn')         AS ASYN_REMAIN,
       DBMS_LOB.INSTR(SQL_DTL_CTN, 'AS_SITE_PLANT') AS AS_BRANCH
FROM   SCM_MGR.SCM_ADM_CMBO_SQL_M
WHERE  SQL_ID IN ('UserSiteByEndCustomer', 'SiteByEndCustomer_DMF0003');

PROMPT ===== [검증2] CMBO 2본 등록 (2행, USE_YN=Y) =====
SELECT SQL_ID, USE_YN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
WHERE  SQL_ID IN ('SiteByEndCustomerAuth', 'AsIncotermsEdit');

PROMPT ===== [검증3] SHEET_COLUMNS 전환 (SCM_SITE_ID=SiteByEndCustomerAuth / SCM_SITE_ID40=SiteByEndCustomer) =====
SELECT SHEET_NAME, COLUMN_NAME, CELL_COMBO_DATA_TYPE
FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE  PROGRAM_ID = 'DMF0003' AND COLUMN_NAME IN ('SCM_SITE_ID', 'SCM_SITE_ID40');

PROMPT ===== 완료 — 위 검증 3개가 기대값과 다르면 결과를 공유해 주세요 =====
