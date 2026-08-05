-- =============================================================================
-- DMF0082_CMBO_USER_AUTH_GROUP_20260804.sql
-- 목적: CMBO 'FcstPriceUserAuthGroup' 등록 (F-1 해소 — A안)
--   FE(ForecastPrice.tsx)가 이 콤보 1행을 store.authGroup 에 주입 → P_USER_GROUP 으로 전송.
--   미등재 상태에서는 USER_ID fallback → PKG_DMF0082 GET_ADMIN_GROUP_MEASURE 직접매칭 실패
--   → 전 measure EDIT_AUTH_YN='N' (DMF0003 유령 groupId 사고와 동일 구조).
-- 원형: SalesPlanUserAuthGroup (DMF0021, 2026-07-15 P6) — DMF0021→DMF0082 치환.
-- 정책: INSERT-only(NOT EXISTS) 멱등 / 감사컬럼 'admin' / 기존재 무변경.
-- ⭐ 적용 대상 3곳 전부 실행 의무: ①사내 ②클라우드 QA ③클라우드 DEV
--   (클라우드 DB 적용물은 QA·DEV 2군데 동시 적용 의무 — 2026-08-04 사용자 확정)
-- =============================================================================

INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT
   'FcstPriceUserAuthGroup'
 , 'DM'
 , 'DMF0082 P_USER_GROUP 권한 그룹 (보유그룹 × GET_ADMIN_GROUP_MEASURE 교집합)'
 , 'SELECT M.USER_GR_ID AS CODE, M.USER_GR_ID AS NAME' || CHR(10) ||
   'FROM SCM_ADM_USER_GR_MPG_M M' || CHR(10) ||
   'WHERE M.USER_ID = @sesUserId' || CHR(10) ||
   '  AND M.USE_YN = ''Y''' || CHR(10) ||
   '  AND EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL L' || CHR(10) ||
   '              WHERE L.LOOKUP_TYPE = ''GET_ADMIN_GROUP_MEASURE'' AND L.VALID_YN = ''Y''' || CHR(10) ||
   '                AND L.SEGMENT1 = M.USER_GR_ID AND L.SEGMENT2 = ''DMF0082'')' || CHR(10) ||
   'ORDER BY DECODE(M.USER_GR_ID, ''ADMIN'', 1, 2), M.USER_GR_ID'
 , 'Y'
 , 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M X
                  WHERE X.SQL_ID = 'FcstPriceUserAuthGroup');

COMMIT;

-- ===== 검증 (각 DB에서 실행 — 1행/SQL 원문 확인) =====
SELECT SQL_ID, MDU_DIVS_CD, USE_YN, SQL_DTL_CTN
FROM   SCM_MGR.SCM_ADM_CMBO_SQL_M
WHERE  SQL_ID = 'FcstPriceUserAuthGroup';

-- ===== 검증 2: 콤보 SQL 시뮬레이션 (wonqthanq 예 — DM ADMIN 1행 기대) =====
SELECT M.USER_GR_ID AS CODE, M.USER_GR_ID AS NAME
FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M M
WHERE M.USER_ID = 'wonqthanq'
  AND M.USE_YN = 'Y'
  AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
              WHERE L.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE' AND L.VALID_YN = 'Y'
                AND L.SEGMENT1 = M.USER_GR_ID AND L.SEGMENT2 = 'DMF0082')
ORDER BY DECODE(M.USER_GR_ID, 'ADMIN', 1, 2), M.USER_GR_ID;
