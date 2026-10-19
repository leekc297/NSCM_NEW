import pathlib, difflib, sys
pkg = pathlib.Path(sys.argv[1]); src = (pkg / "00_BACKUP_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_20261007.sql").read_text(encoding="utf-8")
new = src
def rep(old, nw, label):
    global new
    n = new.count(old); assert n == 1, f"{label}: anchor count {n}"
    new = new.replace(old, nw)
# 0) 변수 선언
rep("    V_MAX_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR);\n",
    "    V_MAX_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR);\n"
    "    V_MAX_PLAN_START_PRE      VARCHAR2(8 CHAR);                 /* [E20261007-PERF] L1391 뷰 1회 평가에서 함께 구한 MAX(PLAN_START_YYYYMMDD) */\n"
    "    V_MAX_PLAN_START_PRE_YN   VARCHAR2(1 CHAR) := 'N';          /* [E20261007-PERF] 위 값 확보 여부 */\n", "decl")
# 1) L1389~1399 : MAX(PLAN_ID) + KEEP 로 PLAN_START 동시 확보
rep("""        IF V_P_PLAN_ID IS NULL THEN
            BEGIN
                SELECT NVL(MAX(PLAN_ID), '')
                  INTO V_MAX_PLAN_ID
                  FROM SCP_PLN_RTF_ALLOCATION_V
                 WHERE DIVISION_ID = P_DIVISION_ID;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                V_MAX_PLAN_ID := '';
            END;
            V_P_PLAN_ID := V_MAX_PLAN_ID;
        END IF;
""", """        IF V_P_PLAN_ID IS NULL THEN
            BEGIN
                /* [E20261007-PERF] 뷰(SCP_PLN_RTF_ALLOCATION_V) 1회 평가로 MAX(PLAN_ID) 와 그 PLAN 의 MAX(PLAN_START_YYYYMMDD) 를 함께 구한다.
                   KEEP (DENSE_RANK LAST ORDER BY PLAN_ID) = "PLAN_ID 가 최대인 행들의 MAX(PLAN_START_YYYYMMDD)" 로 아래 재평가 질의와 동치.
                   (클라우드 10-07 실측 A001→A007 구간 뷰 4회 평가 → 2회) */
                SELECT NVL(MAX(PLAN_ID), '')
                     , NVL(MAX(PLAN_START_YYYYMMDD) KEEP (DENSE_RANK LAST ORDER BY PLAN_ID), '')
                  INTO V_MAX_PLAN_ID, V_MAX_PLAN_START_PRE
                  FROM SCP_PLN_RTF_ALLOCATION_V
                 WHERE DIVISION_ID = P_DIVISION_ID;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                V_MAX_PLAN_ID        := '';
                V_MAX_PLAN_START_PRE := '';
            END;
            V_P_PLAN_ID             := V_MAX_PLAN_ID;
            V_MAX_PLAN_START_PRE_YN := 'Y';
        END IF;
""", "L1389")
# 2) L1421~1430 : 확보된 값이 있으면 재평가 생략
rep("""        /* [C20210215-000212] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용 */
        BEGIN
            SELECT NVL(MAX(PLAN_START_YYYYMMDD), '')
              INTO V_MAX_PLAN_START_YYYYMMDD
              FROM SCP_PLN_RTF_ALLOCATION_V
             WHERE DIVISION_ID = P_DIVISION_ID
               AND PLAN_ID     = V_P_PLAN_ID;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            V_MAX_PLAN_START_YYYYMMDD := '';
        END;
""", """        /* [C20210215-000212] SCP에서 계획을 수립하지 않는 주차는 마지막 계획수립 주차 RTF 적용 */
        IF V_MAX_PLAN_START_PRE_YN = 'Y' THEN
            /* [E20261007-PERF] 배치 경로(P_PLAN_ID NULL): 위 L1391 평가에서 확보한 값 사용 (V_P_PLAN_ID = MAX(PLAN_ID) 이므로 동치) */
            V_MAX_PLAN_START_YYYYMMDD := V_MAX_PLAN_START_PRE;
        ELSE
            BEGIN
                SELECT NVL(MAX(PLAN_START_YYYYMMDD), '')
                  INTO V_MAX_PLAN_START_YYYYMMDD
                  FROM SCP_PLN_RTF_ALLOCATION_V
                 WHERE DIVISION_ID = P_DIVISION_ID
                   AND PLAN_ID     = V_P_PLAN_ID;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                V_MAX_PLAN_START_YYYYMMDD := '';
            END;
        END IF;
""", "L1421")
# 3) L1633~1649 블록을 L1578 앞(ELSE 분기 안)으로 이동
blk = """    /* ================================================================================================================ */
    /* [PJ2025-50017] SCP_PLN_RTF_ALLOCATION_V => GT_PRDM2_MF_RTF_ALLOCATION 데이터 INSERT */
    /* ================================================================================================================ */
    INSERT INTO GT_PRDM2_MF_RTF_ALLOCATION
    ( MASTER_ID, PLAN_ID, OUT_VERSION_ID, DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ENG_DEMAND_ID
    , ITEM_ID, PROJECT_CODE, SALES_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE, DEMAND_TYPE, DUE_DATE, PLANT_SITE_ID, YYYYMMDD
    , ALLOCATION_QTY, DELIVERY_ORDER_ID, FROM_SITE, FROM_ITEM_ID, SCP_INCOTERMS, FROM_SITE_ID, CELL_PROD_SITE_ID )
    SELECT MASTER_ID, PLAN_ID, OUT_VERSION_ID, DIVISION_ID, ORIGIN_DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, ENG_DEMAND_ID
         , ITEM_ID, PROJECT_CODE, SALES_SITE_ID, INCOTERMS, DOM_EXP, FCST_TYPE, DEMAND_TYPE, DUE_DATE, PLANT_SITE_ID, YYYYMMDD
         , ALLOCATION_QTY, DELIVERY_ORDER_ID, FROM_SITE, FROM_ITEM_ID, SCP_INCOTERMS, FROM_SITE_ID, CELL_PROD_SITE_ID
      FROM SCP_PLN_RTF_ALLOCATION_V
     WHERE DIVISION_ID        = C_SCP_DIVISION_ID
       AND ORIGIN_DIVISION_ID = C_DIVISION_ID
       AND PLAN_ID            = C_PLAN_ID
       AND YYYYMMDD          >= C_PLAN_START_YYYYMMDD;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM2_MF_RTF_ALLOCATION');
"""
rep(blk, """    /* ================================================================================================================ */
    /* [PJ2025-50017] SCP_PLN_RTF_ALLOCATION_V => GT_PRDM2_MF_RTF_ALLOCATION 데이터 INSERT
       [E20261007-PERF] 이 적재를 위 ELSE 분기(GT_PRDM2_RESULTS 적재 직전)로 이동. 화면 CALL 경로는 C_PLAN_ID 가 NULL 이라 원래도 0건 적재였음. */
    /* ================================================================================================================ */
""", "L1633-remove")
moved = blk.replace("\n    ", "\n        ").replace("    /* ====", "        /* ====", 1)
moved = moved.replace("[PJ2025-50017] SCP_PLN_RTF_ALLOCATION_V => GT_PRDM2_MF_RTF_ALLOCATION 데이터 INSERT */",
                      "[PJ2025-50017] SCP_PLN_RTF_ALLOCATION_V => GT_PRDM2_MF_RTF_ALLOCATION 데이터 INSERT\n           [E20261007-PERF] 원위치(END IF 뒤)에서 이동 — 아래 GT_PRDM2_RESULTS 적재의 UNION 분기가 이 GTT 를 재사용해 뷰 재평가를 생략한다. 조건·컬럼 원문 그대로. */")
anchor = """        /* ---------------------------------------------------------------------------------------------------------------- */
        /* DM_PLN_CFM_MKT_DEMAND_PLAN / DM_PLN_MKT_FCST 담은 데이터와, 전극으로 발생한 데이터를 임시 테이블에 담는다. */
        /* ---------------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PRDM2_RESULTS
"""
rep(anchor, moved + "\n" + anchor, "L1578-insert")
# 4) L1606 : 뷰 → GTT 재사용
rep("""          FROM SCP_PLN_RTF_ALLOCATION_V
         WHERE DIVISION_ID      = C_SCP_DIVISION_ID
           AND ORIGIN_DIVISION_ID = C_DIVISION_ID
           AND PLAN_ID          = C_PLAN_ID
           AND YYYYMMDD        >= C_PLAN_START_YYYYMMDD
         GROUP BY ORIGIN_DIVISION_ID, PROJECT_CODE, SALES_SITE_ID
""", """          FROM GT_PRDM2_MF_RTF_ALLOCATION   /* [E20261007-PERF] SCP_PLN_RTF_ALLOCATION_V → 위에서 같은 조건으로 적재한 GTT 재사용 (뷰 재평가 생략). WHERE 는 원문 유지 */
         WHERE DIVISION_ID      = C_SCP_DIVISION_ID
           AND ORIGIN_DIVISION_ID = C_DIVISION_ID
           AND PLAN_ID          = C_PLAN_ID
           AND YYYYMMDD        >= C_PLAN_START_YYYYMMDD
         GROUP BY ORIGIN_DIVISION_ID, PROJECT_CODE, SALES_SITE_ID
""", "L1606")
# 5) 이력 헤더
rep(" * 2026.08.28\tJSSBAE\t\t\t[E20260812-001054]_화요일 Sales Plan 재수행 후 H5.5 RTF 오류 발생 [E20261006-ASISDELTA]\n",
    " * 2026.08.28\tJSSBAE\t\t\t[E20260812-001054]_화요일 Sales Plan 재수행 후 H5.5 RTF 오류 발생 [E20261006-ASISDELTA]\n"
    " * 2026.10.07\tZIONEX\t\t\t[E20261007-PERF] 배치(P_PLAN_ID NULL) 경로 SCP_PLN_RTF_ALLOCATION_V 평가 4회→2회 (MAX 2질의 통합 · GTT 재사용, 결과 동치) — 클라우드 A001→A007 구간 실측 기반\n", "header")
out = pkg / "01_PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE_VIEWONCE.sql"
out.write_text(new, encoding="utf-8")
d = list(difflib.unified_diff(src.splitlines(), new.splitlines(), "00_BACKUP", "01_VIEWONCE", lineterm="", n=2))
(pkg / "02_DIFF.txt").write_text("\n".join(d), encoding="utf-8")
print("written", out.name, "lines:", new.count("\n")+1, "| diff lines:", len(d), "| markers:", new.count("[E20261007-PERF]"))
