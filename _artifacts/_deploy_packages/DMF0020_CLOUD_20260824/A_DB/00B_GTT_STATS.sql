-- ============================================================================================
-- DMF0020_CLOUD_20260824 / 00B_GTT_STATS.sql
--   토큰·권한 GTT 에 대표 통계를 고정한다.
--
--   왜 필요한가
--     GTT 는 기본적으로 통계가 없다. 사내는 인스턴스 OPTIMIZER_DYNAMIC_SAMPLING=2 라 동적 샘플링이
--     보정하지만, 클라우드는 이 값이 0 인 전력이 있다(DMF0082 실증: 사내 12초 / 클라우드 16분+).
--     통계가 없고 샘플링도 없으면 옵티마이저가 GTT 를 고정 추정해 파국 계획을 만든다.
--
--   ⚠ 정직한 한계 — 이 통계가 성능을 개선한다는 **독립 실증은 없다**.
--     사내에서 계획 붕괴를 잡으려 도입했으나 그것만으로는 해결되지 않았고, 실제 원인은
--     다른 데 있었다(02_PKG BODY 의 [E20260824-OWNERSPLIT] / [E20260824-LOCONLY]).
--     다만 **최종 성능 실측(div82 7.3~8.8s / div40 2.5s)은 이 통계가 걸린 상태에서 나온 값**이므로,
--     사내와 동일 조건을 만들기 위해 함께 이관한다.
--
--   ⚠ 되돌리기 — 클라우드에서 계획이 더 나빠지면 아래 블록으로 즉시 해제할 것.
--        BEGIN
--          FOR t IN (SELECT COLUMN_VALUE T FROM TABLE(SYS.ODCIVARCHAR2LIST(
--                      'GT_DMF0020_PARAM_TOKEN','GT_DMF0020_DEPT_AUTH',
--                      'GT_DMF0020_SEL_MEASURE','GT_DMF0020_SEL_VERSION'))) LOOP
--            DBMS_STATS.UNLOCK_TABLE_STATS('SCM_MGR', t.T);
--            DBMS_STATS.DELETE_TABLE_STATS('SCM_MGR', t.T, no_invalidate=>FALSE);
--            DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', t.T, 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
--          END LOOP;
--        END;
--        /
--
--   ⚠ GLOBAL_TEMP_TABLE_STATS 를 SHARED 로 바꿔야 세션 밖(=BE 커넥션 풀 전체)에 적용된다.
--      기본값 SESSION 이면 통계가 설정한 세션에만 살아 BE 에는 전혀 먹지 않는다(실측 확인).
--   ⚠ no_invalidate=>FALSE — 기존 자식 커서를 즉시 무효화해 새 통계로 재파싱시킨다.
--   ⚠ 01_PKG_SPEC / 02_PKG_BODY 보다 **뒤에**, 90_VERIFY 보다 **앞에** 실행할 것.
--
--   NUM_ROWS 근거 (사내 실측)
--     GT_DMF0020_PARAM_TOKEN  27 : 조회조건 9종 x 평균 3토큰 (전 조건 ALL 이면 9행)
--     GT_DMF0020_DEPT_AUTH    50 : 사용자 1인의 허용 부서 집합
--     GT_DMF0020_SEL_MEASURE  20 : 선택 measure
--     GT_DMF0020_SEL_VERSION  20 : 선택 version
-- ============================================================================================

DECLARE
    TYPE t_rec IS RECORD (tab VARCHAR2(30), nr NUMBER, nb NUMBER, rl NUMBER);
    TYPE t_tab IS TABLE OF t_rec;
    v_list t_tab := t_tab(
        t_rec('GT_DMF0020_PARAM_TOKEN', 27, 1, 30),
        t_rec('GT_DMF0020_DEPT_AUTH',   50, 1, 12),
        t_rec('GT_DMF0020_SEL_MEASURE', 20, 1, 20),
        t_rec('GT_DMF0020_SEL_VERSION', 20, 1, 20)
    );
BEGIN
    FOR i IN 1 .. v_list.COUNT LOOP
        BEGIN
            DBMS_STATS.UNLOCK_TABLE_STATS('SCM_MGR', v_list(i).tab);
        EXCEPTION WHEN OTHERS THEN NULL;          -- 잠겨 있지 않으면 무시
        END;
        DBMS_STATS.SET_TABLE_PREFS('SCM_MGR', v_list(i).tab, 'GLOBAL_TEMP_TABLE_STATS', 'SHARED');
        DBMS_STATS.SET_TABLE_STATS(ownname       => 'SCM_MGR',
                                   tabname       => v_list(i).tab,
                                   numrows       => v_list(i).nr,
                                   numblks       => v_list(i).nb,
                                   avgrlen       => v_list(i).rl,
                                   no_invalidate => FALSE);
        DBMS_STATS.LOCK_TABLE_STATS('SCM_MGR', v_list(i).tab);
    END LOOP;
END;
/

PROMPT ===== 검증: 4종 모두 SHARED 통계 + LOCK 이어야 한다 =====
SELECT TABLE_NAME, SCOPE, NUM_ROWS, BLOCKS, STATTYPE_LOCKED,
       CASE WHEN SCOPE = 'SHARED' AND NUM_ROWS IS NOT NULL AND STATTYPE_LOCKED = 'ALL'
            THEN 'PASS' ELSE 'FAIL' END AS RESULT
  FROM ALL_TAB_STATISTICS
 WHERE OWNER = 'SCM_MGR'
   AND TABLE_NAME IN ('GT_DMF0020_PARAM_TOKEN', 'GT_DMF0020_DEPT_AUTH',
                      'GT_DMF0020_SEL_MEASURE', 'GT_DMF0020_SEL_VERSION')
   AND SCOPE = 'SHARED'
 ORDER BY TABLE_NAME;
