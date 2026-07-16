-- =====================================================================================================
-- DMF0082 SavePricePeriod(Price Batch Input) SP 재설계 동반 GTT 셋업
--   배포 순서: (1) 본 GTT DDL/stats  →  (2) DMF0082_savePrice_SP_orig.sql (SP)
--   대상: 사내 OCGSCMD_P01 / SCM_MGR  (+ 클라우드 이관 시 동일 실행)
--   작성: 2026-07-13  사유: SavePricePeriod 0행/폭발(594s) 사고 전체 재설계
-- =====================================================================================================
-- [배경] 조회 시 0행(Oracle ''=NULL 필터버그) + div40 폭발/hang(97~594s). 근본원인 3종:
--   (1) PJT 원본 인라인 subquery의 OWNER split-in-join → 옵티마이저 decorrelate = 184M 카테시안
--   (2) TEAM 조인키 부재('일단 주석처리') → 전체 유효부서(2만+)와 카테시안 (GROUP BY로 출력 2만배 뻥튀기)
--   (3) INSERT 컬럼목록↔SELECT 순서 어긋남(PROJECT_CODE 22자 → PROJECT_OWNER 20자 유입 ORA-12899)
-- [해결] PJT를 물리 GTT에 1회 사전 실현 + TEAM 카테시안 div40 차단 + 컬럼정렬 교정 + 멀티선택 skip/GTT 룰
--        결과: div40 5966행 / ~9s (구 0행 or 594s+ 폭발)
-- =====================================================================================================

-- 1) 멀티선택 필터 사전적재 GTT (PROJECT/OWNER 값. ALL/빈값=미적재→조건 skip)
DECLARE v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM user_tables WHERE table_name = 'GT_DMF0082_SP_FILTER';
  IF v_cnt = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0082_SP_FILTER (
        FILTER_TYPE  VARCHAR2(30 CHAR),
        FILTER_VALUE VARCHAR2(240 CHAR)
      ) ON COMMIT PRESERVE ROWS';
  END IF;
END;
/

-- 2) PJT 원본 사전 실현 GTT (SCM_MST_PROJECT ∪ SCM_MST_SITE_ITEM×OWNER). 인라인 카테시안 폭발 회피용.
DECLARE v_cnt NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_cnt FROM user_tables WHERE table_name = 'GT_DMF0082_PJT';
  IF v_cnt = 0 THEN
    EXECUTE IMMEDIATE '
      CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0082_PJT (
        DIVISION_ID   VARCHAR2(60 CHAR),
        PROJECT_CODE  VARCHAR2(240 CHAR),
        PROJECT_NAME  VARCHAR2(1000 CHAR),
        PROJECT_OWNER VARCHAR2(4000 CHAR),
        PROJECT_STATUS VARCHAR2(240 CHAR),
        BIZ_TYPE      VARCHAR2(240 CHAR),
        SCM_SITE_ID   VARCHAR2(240 CHAR),
        ITEM_ID       VARCHAR2(240 CHAR),
        DEPT_ID       VARCHAR2(240 CHAR),
        DEPT_NAME_KO  VARCHAR2(1000 CHAR),
        USER_ID       VARCHAR2(240 CHAR),
        USER_NAME     VARCHAR2(1000 CHAR),
        USER_NAME_EN  VARCHAR2(1000 CHAR)
      ) ON COMMIT PRESERVE ROWS';
  END IF;
END;
/

-- 3) GTT 공유 stats 고정 (미수집 시 하드파스마다 dynamic sampling → 첫 호출 ~60s. 고정 시 하드파스 안정화)
BEGIN
  DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DMF0082_PJT','GLOBAL_TEMP_TABLE_STATS','SHARED');
  DBMS_STATS.SET_TABLE_STATS('SCM_MGR','GT_DMF0082_PJT', numrows => 22000, numblks => 300, avgrlen => 120);
  DBMS_STATS.LOCK_TABLE_STATS('SCM_MGR','GT_DMF0082_PJT');

  DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DMF0082_SP_FILTER','GLOBAL_TEMP_TABLE_STATS','SHARED');
  DBMS_STATS.SET_TABLE_STATS('SCM_MGR','GT_DMF0082_SP_FILTER', numrows => 5, numblks => 1, avgrlen => 30);
  DBMS_STATS.LOCK_TABLE_STATS('SCM_MGR','GT_DMF0082_SP_FILTER');
END;
/
