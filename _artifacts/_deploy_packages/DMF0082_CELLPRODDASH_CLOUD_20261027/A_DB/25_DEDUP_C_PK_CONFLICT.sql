-- 25_DEDUP_C_PK_CONFLICT — [E20261027-CELLPRODDASH] _C 2개 테이블의 CELL_PROD_SITE_ID '/' 중복 행 정리 (클라우드 · SCM_MGR · 전체 F5 · 멱등)
--
-- 배경 (클라우드 _CHECK_PK_CONFLICT_C 결과 2026-10-27):
--   DM_PLN_MKT_FCST_RESULT_C   '/' 2,194행 중 1,982행 · DM_PLN_SALES_PLAN_RESULT_C '/' 48,614행 중 48,014행이
--   같은 키의 '-' 행과 쌍을 이룬다 → 30 이 PK 충돌로 두 테이블을 건너뜀.
--   충돌 쌍 전부 QTY 동일(다름 0) · 양쪽 모두 scm_batch 생성 · '-' 행이 먼저(10-13 16:14~) · '/' 행이 뒤(10-13 17:54~)
--   = TO-BE 원장 DEFAULT '/' 기간에 같은 컷오프가 한 번 더 적재된 **완전 중복**. 키 합산 화면에서는 수량이 2배.
-- 처리:
--   ① 지울 '/' 행을 백업 테이블로 복사 (ZZ_CPD_MFRC_DUP_20261027 · ZZ_CPD_SPRC_DUP_20261027 — 원본 전 컬럼 + 백업 시각)
--   ② 같은 키에 QTY 가 같은 '-' 행이 있는 '/' 행만 DELETE ('-' 행 유지)
--   ③ QTY 가 다른 쌍은 지우지 않고 건수만 출력 (회신 — 현재 0건)
--   이후 30_DATA_SLASH_TO_DASH 를 다시 실행하면 충돌이 없어진 두 테이블의 남은 '/' 행(212 · 600)이 '-' 로 바뀐다.
-- 실행 순서: (10 → 20 → 30 실행 완료 상태에서) 25 → 30 재실행 → 90
-- 원복: 99_ROLLBACK_0_DEDUP (백업 테이블에서 되돌려 넣기)
-- ★ c_dry_run = 'Y' 이면 건수만 (백업·삭제 없음)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250 PAGESIZE 500
SET DEFINE OFF

-- D0 오늘 새로 생긴 '/' 행 확인 (10·20 적용 뒤에도 생기면 다른 적재 경로가 '/' 를 쓰고 있다 — 회신)
SELECT 'D0 오늘' CHK, 'MKT_FCST_RESULT_C' TBL, DIVISION_ID, CUTOFF_TYPE, CUTOFF_YYYYMMDD, CREATED_BY, COUNT(*) N, TO_CHAR(MIN(CREATION_DATE),'YYYY-MM-DD HH24:MI') CREATED_FROM, TO_CHAR(MAX(CREATION_DATE),'YYYY-MM-DD HH24:MI') CREATED_TO
  FROM DM_PLN_MKT_FCST_RESULT_C
 WHERE CELL_PROD_SITE_ID = '/' AND CREATION_DATE >= TRUNC(SYSDATE) - 1
 GROUP BY DIVISION_ID, CUTOFF_TYPE, CUTOFF_YYYYMMDD, CREATED_BY
UNION ALL
SELECT 'D0 오늘', 'SALES_PLAN_RESULT_C', DIVISION_ID, CUTOFF_TYPE, CUTOFF_YYYYMMDD, CREATED_BY, COUNT(*), TO_CHAR(MIN(CREATION_DATE),'YYYY-MM-DD HH24:MI'), TO_CHAR(MAX(CREATION_DATE),'YYYY-MM-DD HH24:MI')
  FROM DM_PLN_SALES_PLAN_RESULT_C
 WHERE CELL_PROD_SITE_ID = '/' AND CREATION_DATE >= TRUNC(SYSDATE) - 1
 GROUP BY DIVISION_ID, CUTOFF_TYPE, CUTOFF_YYYYMMDD, CREATED_BY
 ORDER BY 2, 3, 4, 5;
SELECT 'D0 DEFAULT' CHK, TABLE_NAME, DEFAULT_ON_NULL, DATA_DEFAULT FROM USER_TAB_COLUMNS
 WHERE COLUMN_NAME = 'CELL_PROD_SITE_ID' AND TABLE_NAME IN ('DM_PLN_MKT_FCST_RESULT_C', 'DM_PLN_SALES_PLAN_RESULT_C', 'DM_PLN_MKT_FCST_RESULT', 'DM_PLN_SALES_PLAN_RESULT') ORDER BY 2;

DECLARE
    c_dry_run CONSTANT VARCHAR2(1) := 'N';   -- ★ 'Y' = 건수만
    -- 조인 키 = 클라우드 PK(K0)에서 CELL_PROD_SITE_ID · 가상컬럼 CUTOFF_YYYYMMDD_DATE 제외
    c_on_mfr  CONSTANT VARCHAR2(2000) :=
        'B.CELL_PROD_SITE_ID = ''-'' AND B.DIVISION_ID = A.DIVISION_ID AND B.VERSION_NO = A.VERSION_NO AND B.CUTOFF_TYPE = A.CUTOFF_TYPE AND B.CUTOFF_YYYYMMDD = A.CUTOFF_YYYYMMDD'
     || ' AND B.PROJECT_CODE = A.PROJECT_CODE AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOM_EXP = A.DOM_EXP AND B.FCST_TYPE = A.FCST_TYPE'
     || ' AND B.INCOTERMS = A.INCOTERMS AND B.MEASURE = A.MEASURE AND B.PLANT_SITE_ID = A.PLANT_SITE_ID AND B.YYYYMMDD = A.YYYYMMDD';
    c_on_spr  CONSTANT VARCHAR2(2000) := c_on_mfr || ' AND B.CURRENCY = A.CURRENCY AND B.COMPANY_ID = A.COMPANY_ID';
    c_slash   CONSTANT VARCHAR2(200)  := ' (A.CELL_PROD_SITE_ID = ''/'' OR (A.CELL_PROD_SITE_ID IS NOT NULL AND TRIM(A.CELL_PROD_SITE_ID) IS NULL)) ';
    v_n NUMBER; v_same NUMBER; v_diff NUMBER; v_bak NUMBER; v_del NUMBER;

    PROCEDURE one(p_tab VARCHAR2, p_bak VARCHAR2, p_on VARCHAR2) IS
        v_exists NUMBER;
    BEGIN
        EXECUTE IMMEDIATE 'SELECT COUNT(*), SUM(CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.' || p_tab || ' B WHERE ' || p_on || ' AND NVL(B.QTY, 0) = NVL(A.QTY, 0)) THEN 1 ELSE 0 END)'
                       || ', SUM(CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.' || p_tab || ' B WHERE ' || p_on || ' AND NVL(B.QTY, 0) <> NVL(A.QTY, 0)) THEN 1 ELSE 0 END)'
                       || ' FROM SCM_MGR.' || p_tab || ' A WHERE' || c_slash INTO v_n, v_same, v_diff;
        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(p_tab, 30) || ' ''/''행 ' || NVL(v_n, 0) || ' · 중복(QTY 같음 → 삭제 대상) ' || NVL(v_same, 0)
                             || ' · QTY 다름(유지·회신) ' || NVL(v_diff, 0) || ' · 충돌 없음 ' || (NVL(v_n, 0) - NVL(v_same, 0) - NVL(v_diff, 0)));
        IF c_dry_run = 'Y' OR NVL(v_same, 0) = 0 THEN RETURN; END IF;
        SELECT COUNT(*) INTO v_exists FROM USER_TABLES WHERE TABLE_NAME = p_bak;
        IF v_exists = 0 THEN
            EXECUTE IMMEDIATE 'CREATE TABLE SCM_MGR.' || p_bak || ' AS SELECT A.*, SYSDATE AS ZZ_BACKUP_AT FROM SCM_MGR.' || p_tab || ' A WHERE 1 = 0';
        END IF;
        EXECUTE IMMEDIATE 'INSERT INTO SCM_MGR.' || p_bak || ' SELECT A.*, SYSDATE FROM SCM_MGR.' || p_tab || ' A WHERE' || c_slash
                       || ' AND EXISTS (SELECT 1 FROM SCM_MGR.' || p_tab || ' B WHERE ' || p_on || ' AND NVL(B.QTY, 0) = NVL(A.QTY, 0))';
        v_bak := SQL%ROWCOUNT;
        EXECUTE IMMEDIATE 'DELETE FROM SCM_MGR.' || p_tab || ' A WHERE' || c_slash
                       || ' AND EXISTS (SELECT 1 FROM SCM_MGR.' || p_tab || ' B WHERE ' || p_on || ' AND NVL(B.QTY, 0) = NVL(A.QTY, 0))';
        v_del := SQL%ROWCOUNT;
        IF v_bak <> v_del THEN
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20010, p_tab || ' 백업 ' || v_bak || ' ≠ 삭제 ' || v_del || ' → 전체 취소(원문 무변경)');
        END IF;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('   ' || RPAD(p_tab, 30) || ' 백업 ' || v_bak || ' → ' || p_bak || ' · 삭제 ' || v_del);
    END;
BEGIN
    DBMS_OUTPUT.PUT_LINE('== D1 _C 중복 정리 ' || CASE c_dry_run WHEN 'Y' THEN '[DRY RUN]' ELSE '[실행]' END || ' · ' || SYS_CONTEXT('USERENV','DB_NAME') || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    one('DM_PLN_MKT_FCST_RESULT_C',   'ZZ_CPD_MFRC_DUP_20261027', c_on_mfr);
    one('DM_PLN_SALES_PLAN_RESULT_C', 'ZZ_CPD_SPRC_DUP_20261027', c_on_spr);
    DBMS_OUTPUT.PUT_LINE('== 완료 ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' — 다음: 30_DATA_SLASH_TO_DASH 재실행 (남은 ''/'' 행 → ''-'') → 90_VERIFY');
END;
/
