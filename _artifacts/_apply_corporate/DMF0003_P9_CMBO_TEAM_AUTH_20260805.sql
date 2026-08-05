-- =============================================================================
-- DMF0003_P9_CMBO_TEAM_AUTH_20260805.sql
-- 목적: ①그리드 셀 Team 콤보 AS-IS 'TeambyDivisionAuth' 1:1 이식 ②기존 Auth CMBO 2본의
--       DEPT_ID NULL 관용 제거(AS-IS 원형 정정) — 2026-08-05 사용자 확정:
--       "데이터는 넣지 않고 데이터가 들어 있다는 가정하에 query만 as-is와 맞춰주세요"
--
-- 근거 (AS-IS UP_FX_GetCommonDataList 'TeambyDivisionAuth' L13131~13323 — 4분기 1:1):
--   team_cnt = COUNT(PM_TEAM_MAPPING(SEGMENT1=사용자부서).SEGMENT3 ∪ 사용자부서)
--   [1] ≠40·단일팀: SITE(SALES).DEPT_ID×SSO_DEPT + 권한(D) + (ADMIN=전체 / 자기부서만)
--   [2] 40·단일팀 : SITE_ITEM.OWNER→SSO 부서 + (ADMIN=전체 / 자기부서만) — 권한필터 없음(원형 그대로)
--   [3] ≠40·다수팀: SITE(SALES).DEPT_ID + MAPSET(매핑∪자기부서) — 권한·ADMIN 분기 없음(원형 그대로)
--   [4] 40·다수팀 : SITE(SALES)×SITE_ITEM owner 부서 + MAPSET
--   NAME = DEPT_NAME_KO 고정(AS-IS 원형). division 축은 DIVISION_ID 컬럼 반환 → FE cascade 담당.
--   ⚠ [1][3]은 SITE.DEPT_ID 원천 — 현재 TO-BE 미적재(전부 NULL)라 데이터 적재 전까지 ≠40 분기 0행
--     (40 분기는 SITE_ITEM 원천이라 즉시 유효). 데이터 적재 시 별도 조치 없이 AS-IS 동작.
--
-- 정책: INSERT-only + SHEET 1건 UPDATE + REPLACE 2건 / 감사 'admin' / 멱등 / 테이블 데이터 무변경.
-- ⭐ 적용 대상 3곳 전부 실행 의무: ①사내 ②클라우드 QA ③클라우드 DEV (클라우드는 통합본 사용 권장)
-- =============================================================================

-- [1] CMBO 'TeambyDivisionAuth' 신설
INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT
   'TeambyDivisionAuth'
 , 'DM'
 , 'DMF0003 셀 Team (AS-IS Auth 4분기 1:1)'
 , 'WITH ME AS (SELECT DEPT_ID FROM TB_FX_USER WHERE USERID = @sesUserId),' || CHR(10) ||
   'MAPSET AS (SELECT L.SEGMENT3 AS DEPT_ID FROM SCM_ADM_LOOKUP_MASTER_DETAIL L' || CHR(10) ||
   '           WHERE L.LOOKUP_TYPE = ''PM_TEAM_MAPPING'' AND L.VALID_YN = ''Y''' || CHR(10) ||
   '             AND L.SEGMENT1 IN (SELECT DEPT_ID FROM ME)' || CHR(10) ||
   '           UNION SELECT DEPT_ID FROM ME),' || CHR(10) ||
   'F AS (SELECT (SELECT COUNT(*) FROM MAPSET) AS TEAM_CNT,' || CHR(10) ||
   '             (SELECT COUNT(*) FROM SCM_ADM_USER_GR_MPG_M G' || CHR(10) ||
   '              WHERE G.USER_ID = @sesUserId AND G.USER_GR_ID = ''ADMIN'' AND G.USE_YN = ''Y'') AS IS_ADMIN' || CHR(10) ||
   '      FROM DUAL)' || CHR(10) ||
   'SELECT DISTINCT DIVISION_ID, CODE, NAME FROM (' || CHR(10) ||
   'SELECT A.DIVISION_ID, B.DEPT_ID AS CODE, B.DEPT_NAME_KO AS NAME' || CHR(10) ||
   'FROM SCM_MST_SITE A JOIN SCM_MST_SSO_DEPT_INFO B ON A.DEPT_ID = B.DEPT_ID CROSS JOIN F' || CHR(10) ||
   'WHERE A.SITE_TYPE = ''SALES'' AND A.DIVISION_ID <> ''40'' AND F.TEAM_CNT <= 1' || CHR(10) ||
   '  AND A.DIVISION_ID IN (SELECT UNIT_ID FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M' || CHR(10) ||
   '                        WHERE USER_ID = @sesUserId AND UNIT_TP_CD = ''D'' AND USE_YN = ''Y'')' || CHR(10) ||
   '  AND (F.IS_ADMIN > 0 OR B.DEPT_ID IN (SELECT DEPT_ID FROM ME))' || CHR(10) ||
   'UNION' || CHR(10) ||
   'SELECT ''40'', C.DEPT_ID, C.DEPT_NAME_KO' || CHR(10) ||
   'FROM SCM_MST_SITE_ITEM A JOIN SCM_MST_SSO_USER_INFO B ON A.OWNER = B.USER_ID' || CHR(10) ||
   'JOIN SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID CROSS JOIN F' || CHR(10) ||
   'WHERE A.DIVISION_ID = ''40'' AND F.TEAM_CNT <= 1' || CHR(10) ||
   '  AND (F.IS_ADMIN > 0 OR C.DEPT_ID IN (SELECT DEPT_ID FROM ME))' || CHR(10) ||
   'UNION' || CHR(10) ||
   'SELECT A.DIVISION_ID, B.DEPT_ID, B.DEPT_NAME_KO' || CHR(10) ||
   'FROM SCM_MST_SITE A JOIN SCM_MST_SSO_DEPT_INFO B ON A.DEPT_ID = B.DEPT_ID CROSS JOIN F' || CHR(10) ||
   'WHERE A.SITE_TYPE = ''SALES'' AND A.DIVISION_ID <> ''40'' AND F.TEAM_CNT > 1' || CHR(10) ||
   '  AND B.DEPT_ID IN (SELECT DEPT_ID FROM MAPSET)' || CHR(10) ||
   'UNION' || CHR(10) ||
   'SELECT A.DIVISION_ID, B2.DEPT_ID, B2.DEPT_NAME_KO' || CHR(10) ||
   'FROM SCM_MST_SITE A' || CHR(10) ||
   'JOIN SCM_MST_SITE_ITEM I ON A.DIVISION_ID = I.DIVISION_ID AND A.SCM_SITE_ID = I.SCM_SITE_ID' || CHR(10) ||
   'JOIN SCM_MST_SSO_USER_INFO SU ON SU.USER_ID = I.OWNER' || CHR(10) ||
   'JOIN SCM_MST_SSO_DEPT_INFO B2 ON B2.DEPT_ID = SU.DEPT_ID CROSS JOIN F' || CHR(10) ||
   'WHERE A.SITE_TYPE = ''SALES'' AND A.DIVISION_ID = ''40'' AND F.TEAM_CNT > 1' || CHR(10) ||
   '  AND B2.DEPT_ID IN (SELECT DEPT_ID FROM MAPSET)' || CHR(10) ||
   ') ORDER BY CODE'
 , 'Y'
 , 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M X WHERE X.SQL_ID = 'TeambyDivisionAuth');

-- [2] DMF0003 'Mkt Fcst' TEAM_ID 셀 콤보 → Auth판 전환 (공유 'TeambyDivision' 무변경)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET CELL_COMBO_DATA_TYPE = 'TeambyDivisionAuth',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'Mkt Fcst' AND COLUMN_NAME = 'TEAM_ID'
   AND CELL_COMBO_DATA_TYPE = 'TeambyDivision';

-- [3] Auth CMBO 2본의 DEPT_ID NULL 관용 제거 → AS-IS 원형 (멱등: 마커 존재 시에만)
UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN = REPLACE(SQL_DTL_CTN, 'A.DEPT_ID IS NULL' || CHR(10) || '     OR ', ''),
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID IN ('SiteByEndCustomerAuth', 'EndCustomerByDivisionDeptAuth')
   AND DBMS_LOB.INSTR(SQL_DTL_CTN, 'A.DEPT_ID IS NULL') > 0;

COMMIT;

-- ===== 검증 1: CMBO 등록 + NULL 관용 잔존 0 =====
SELECT SQL_ID, USE_YN, DBMS_LOB.INSTR(SQL_DTL_CTN, 'DEPT_ID IS NULL') AS NULL_TOLERANCE
FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
WHERE SQL_ID IN ('TeambyDivisionAuth','SiteByEndCustomerAuth','EndCustomerByDivisionDeptAuth');
-- ===== 검증 2: SHEET_COLUMNS =====
SELECT COLUMN_NAME, CELL_COMBO_DATA_TYPE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst' AND COLUMN_NAME='TEAM_ID';
-- 원복: [2] 역UPDATE + CMBO DELETE + [3] 관용절 재삽입
