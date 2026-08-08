-- =====================================================================================
-- [E20260806-PERF] DMF0022 Waterfall — GTT 인덱스 2본 (사용자 승인 2026-08-06 — GTT 한정 직접 적용)
-- =====================================================================================
-- AS-IS(MSSQL) 등가: dbo.DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL 이 매 실행 생성하는
--   CREATE CLUSTERED INDEX IDX1_TEMP_DM_MST_ITEM_SINGLE_V   ON #TEMP_DM_MST_ITEM_SINGLE_V   (DIVISION_ID, ITEM_ID)
--   CREATE CLUSTERED INDEX IDX1_TEMP_DM_MST_ITEM_SINGLE_V_T ON #TEMP_DM_MST_ITEM_SINGLE_V_T (DIVISION_ID, ITEM_ID)
-- Oracle GTT 는 인덱스가 영구 정의(데이터만 세션 사유)이므로 1회 생성으로 등가.
--
-- 타 PKG 영향 확인 (2026-08-06 실측): GT_DM22_DM_MST_ITEM_SINGLE_V 재사용처 = PKG_DMF0051 뿐,
--   조인 조건 (A.DIVISION_ID=D.DIVISION_ID AND A.ITEM_ID=D.ITEM_ID) — 본 인덱스 키와 동일 → 악화 없음.
--   GT_DM22_DM_MST_ITEM_SINGLE_V_T 는 PKG_DMF0022 전용.
--
-- 멱등: ORA-00955(중복 이름) skip. 사용 중 세션 존재 시 ORA-14452 — 재시도 필요(치명 아님).
-- =====================================================================================

DECLARE
    PROCEDURE DO_DDL(P_SQL VARCHAR2) IS
        E_EXISTS EXCEPTION; PRAGMA EXCEPTION_INIT(E_EXISTS, -955);
    BEGIN
        EXECUTE IMMEDIATE P_SQL;
        DBMS_OUTPUT.PUT_LINE('OK   : ' || P_SQL);
    EXCEPTION
        WHEN E_EXISTS THEN DBMS_OUTPUT.PUT_LINE('SKIP(-955): ' || P_SQL);
    END;
BEGIN
    DO_DDL('CREATE INDEX SCM_MGR.IDX1_GT_DM22_ITEM_SINGLE_V   ON SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V   (DIVISION_ID, ITEM_ID)');
    DO_DDL('CREATE INDEX SCM_MGR.IDX1_GT_DM22_ITEM_SINGLE_V_T ON SCM_MGR.GT_DM22_DM_MST_ITEM_SINGLE_V_T (DIVISION_ID, ITEM_ID)');
END;
/
