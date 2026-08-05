-- =============================================================================
-- DMF0003_P8_CMBO_CELL_CUSTOMER_20260804.sql
-- 목적: DMF0003 그리드 셀 Customer 콤보의 AS-IS 필터 복원 (데이터 무변경 — CMBO/SHEET 메타만)
--
-- 근거 (AS-IS UP_FX_GetCommonDataList 원문 실측 2026-08-04):
--  [1] 셀 END_CUSTOMER(81/82) = 'EndCustomerByDivisionDeptAuth' (L13078):
--      division+team(=SITE.DEPT_ID) 필터 + 권한(D) + NAME=END_CUSTOMER lookup(SEGMENT3) 표시명
--      + 부서제약(ADMIN 전체 / PM_TEAM_MAPPING∪자기부서). TO-BE 현행 'EndCustomerByDivisionDept'는
--      필터 전부 주석 상태(전 division·전 team·무권한) → Auth판 신설.
--      데이터 무변경 방침: SITE.DEPT_ID 미적재(NULL) 행은 통과 → 현행 무회귀, 적재 시 자동 활성.
--  [2] 셀 END_CUSTOMER40 = 'EndCustomerByDivision40' (L13664): SITE_ITEM×SSO(OWNER 첫 토큰)×DEPT
--      + team(B.DEPT_ID) 필터 + lookup UNION 은 **team 미지정('ALL')일 때만**.
--      TO-BE 현행은 team 축 부재 + lookup 무조건 UNION → DEPT_ID 컬럼 반환판 신설
--      (lookup 행은 DEPT_ID='-' 부여 → FE cascade 관대매칭에서 team 지정 시 자동 제외 = AS-IS 1:1).
--  FE(GRID_CASCADE_FILTERS)가 row DIVISION_ID/TEAM_ID 로 클라 cascade — 콤보는 축 컬럼 반환 담당.
--
-- 정책: INSERT-only(NOT EXISTS) + SHEET_COLUMNS 2건 UPDATE / 감사 'admin' / 멱등 / SQL_NM ≤ 100byte.
-- ⭐ 적용 대상 3곳 전부 실행 의무: ①사내 ②클라우드 QA ③클라우드 DEV
-- =============================================================================

-- [1] CMBO 'EndCustomerByDivisionDeptAuth' 신설 (81/82 셀 — AS-IS L13078 1:1 + DEPT_ID 미적재 허용)
INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT
   'EndCustomerByDivisionDeptAuth'
 , 'DM'
 , 'DMF0003 셀 End Customer (AS-IS Auth 1:1 부서제약)'
 , 'SELECT DISTINCT A.DIVISION_ID, A.DEPT_ID, A.END_CUSTOMER AS CODE,' || CHR(10) ||
   '       NVL(D.SEGMENT3, A.END_CUSTOMER) AS NAME' || CHR(10) ||
   'FROM SCM_MST_SITE A' || CHR(10) ||
   'LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D' || CHR(10) ||
   '  ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2' || CHR(10) ||
   ' AND D.LOOKUP_TYPE = ''END_CUSTOMER'' AND D.VALID_YN = ''Y''' || CHR(10) ||
   'WHERE A.END_CUSTOMER IS NOT NULL' || CHR(10) ||
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
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M X WHERE X.SQL_ID = 'EndCustomerByDivisionDeptAuth');

-- [2] CMBO 'EndCustomerByDivision40Team' 신설 (40 셀 — AS-IS L13664 1:1, DEPT_ID 축 반환)
--     lookup UNION 행 DEPT_ID='-' → FE cascade 에서 team 지정 시 제외 (AS-IS @PARAM2='ALL' 한정 UNION 1:1)
INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT
   'EndCustomerByDivision40Team'
 , 'DM'
 , 'DMF0003 셀 End Customer 40 (AS-IS owner-dept team 축 1:1)'
 , 'SELECT DIVISION_ID, DEPT_ID, CODE, NAME FROM (' || CHR(10) ||
   'SELECT DISTINCT A.DIVISION_ID, C.DEPT_ID,' || CHR(10) ||
   '       A.PROJECT_CODE AS CODE, NVL(D.SEGMENT3, A.PROJECT_CODE) AS NAME' || CHR(10) ||
   'FROM SCM_MST_SITE_ITEM A' || CHR(10) ||
   'JOIN SCM_MST_SSO_USER_INFO B' || CHR(10) ||
   '  ON B.USER_ID = TRIM(CASE WHEN INSTR(A.OWNER, '','') > 0' || CHR(10) ||
   '                           THEN SUBSTR(A.OWNER, 1, INSTR(A.OWNER, '','') - 1) ELSE A.OWNER END)' || CHR(10) ||
   'JOIN SCM_MST_SSO_DEPT_INFO C ON C.DEPT_ID = B.DEPT_ID' || CHR(10) ||
   'LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D' || CHR(10) ||
   '  ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2' || CHR(10) ||
   ' AND D.LOOKUP_TYPE = ''END_CUSTOMER'' AND D.VALID_YN = ''Y''' || CHR(10) ||
   'WHERE A.DIVISION_ID = ''40'' AND A.VALID_YN = ''Y'' AND A.PROJECT_CODE IS NOT NULL' || CHR(10) ||
   'UNION' || CHR(10) ||
   'SELECT ''40'', ''-'', SEGMENT2, SEGMENT3' || CHR(10) ||
   'FROM SCM_ADM_LOOKUP_MASTER_DETAIL' || CHR(10) ||
   'WHERE LOOKUP_TYPE = ''END_CUSTOMER'' AND SEGMENT1 = ''40''' || CHR(10) ||
   '  AND SEGMENT2 <> ''-'' AND VALID_YN = ''Y''' || CHR(10) ||
   ') ORDER BY CODE'
 , 'Y'
 , 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M X WHERE X.SQL_ID = 'EndCustomerByDivision40Team');

-- [3] DMF0003 'Mkt Fcst' 셀 콤보 전환 2건 (공유 CMBO 는 무변경 — DMF0003 메타만 교체)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET CELL_COMBO_DATA_TYPE = 'EndCustomerByDivisionDeptAuth',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'Mkt Fcst' AND COLUMN_NAME = 'END_CUSTOMER'
   AND CELL_COMBO_DATA_TYPE = 'EndCustomerByDivisionDept';

UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET CELL_COMBO_DATA_TYPE = 'EndCustomerByDivision40Team',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'Mkt Fcst' AND COLUMN_NAME = 'END_CUSTOMER40'
   AND CELL_COMBO_DATA_TYPE = 'EndCustomerByDivision40';

COMMIT;

-- ===== 검증 1: CMBO 2본 등록 =====
SELECT SQL_ID, USE_YN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
WHERE SQL_ID IN ('EndCustomerByDivisionDeptAuth','EndCustomerByDivision40Team');
-- ===== 검증 2: SHEET_COLUMNS 전환 =====
SELECT COLUMN_NAME, CELL_COMBO_DATA_TYPE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE PROGRAM_ID='DMF0003' AND SHEET_NAME='Mkt Fcst'
  AND COLUMN_NAME IN ('END_CUSTOMER','END_CUSTOMER40','TEAM_ID','SCM_SITE_ID','SCM_SITE_ID40');
-- 원복: [3] 역UPDATE + CMBO 2본 DELETE
