"""Run DMF0043_GET_CONTRIBUTION_SALES_LIST with user-reported params and report o_rc1 row count + intermediate GT_* row counts. Diagnostic only — no DB modifications."""
import os, sys, pathlib
import oracledb

root = pathlib.Path(__file__).resolve().parents[2]
env_file = root / ".env.asis"  # ignored — we use NSCM_ORA_* env vars

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()

# Step 1: call SP
o_rc1 = cur.var(oracledb.CURSOR)
o_rc2 = cur.var(oracledb.CURSOR)
o_rc3 = cur.var(oracledb.CURSOR)

print("[ SP call ] DMF0043_GET_CONTRIBUTION_SALES_LIST")
print("    P_DIVISION_ID    = '40'")
print("    P_VER_SEQ        = '12'")
print("    P_VERSION_NO     = 'R_S_20251126_V002_C'")
print("    P_END_CUST_REPORT= 'ALL'")
print("    P_PRODUCT_GROUP  = 'ALL'")
print("    P_BIZ_TYPE       = 'ALL'")
print("    P_MILLION_YN     = 'N'")
print("    P_COMPATIBILITY_YN='N'")
print("    P_CREATED_BY     = 'minyonglee1'")
import time
t0 = time.time()
cur.callproc("DMF0043_GET_CONTRIBUTION_SALES_LIST", [
    "40",                 # p_division_id
    "12",                 # p_ver_seq
    "R_S_20251126_V002_C",# p_version_no
    "ALL",                # p_end_cust_report
    "ALL",                # p_product_group
    "ALL",                # p_biz_type
    "N",                  # p_million_yn
    "N",                  # p_compatibility_yn
    "minyonglee1",        # p_created_by
    o_rc1, o_rc2, o_rc3,
])
elapsed = time.time() - t0
print(f"\n[ SP elapsed ] {elapsed:.2f} sec")

# Step 2: count o_rc1 rows
rc1 = o_rc1.getvalue()
rc1_rows = rc1.fetchall()
print(f"[ o_rc1 ] {len(rc1_rows)} rows")
if rc1_rows:
    print(f"  columns: {[d[0] for d in rc1.description]}")
    print(f"  first row sample: {rc1_rows[0]}")

# Step 3: peek GT_DMF0043_PLAN_REPORT_C (stage 1)
cur.execute("SELECT COUNT(*) FROM GT_DMF0043_PLAN_REPORT_C")
gt_plan_cnt = cur.fetchone()[0]
print(f"\n[ GT_DMF0043_PLAN_REPORT_C ] {gt_plan_cnt} rows (Stage 1: SALES_PLAN→GT after measure+SCM_SITE filter)")

# Step 4: peek GT_DMF0043_SALES_LIST_C (stage 2)
cur.execute("SELECT COUNT(*) FROM GT_DMF0043_SALES_LIST_C")
gt_list_cnt = cur.fetchone()[0]
print(f"[ GT_DMF0043_SALES_LIST_C  ] {gt_list_cnt} rows (Stage 2: GT_PLAN_REPORT × SITE_ITEM × TEAM)")

# Step 5: distinct DEPARTMENT_ID nulls in Stage 2
cur.execute("SELECT COUNT(*), SUM(CASE WHEN DEPARTMENT_ID IS NULL THEN 1 ELSE 0 END), SUM(CASE WHEN END_CUST_REPORT='' OR END_CUST_REPORT IS NULL THEN 1 ELSE 0 END) FROM GT_DMF0043_SALES_LIST_C")
tot, null_dept, empty_end = cur.fetchone()
print(f"[ GT_DMF0043_SALES_LIST_C diag ] total={tot} / DEPARTMENT_ID NULL = {null_dept} / END_CUST_REPORT empty = {empty_end}")

# Step 6: how many GT_SALES_LIST keys actually exist in RATIO_DTL?
cur.execute("""
SELECT COUNT(*) FROM GT_DMF0043_SALES_LIST_C A
WHERE EXISTS (SELECT 1 FROM DM_MST_CONTRIBUTE_RATIO_DTL B
              WHERE B.VER_SEQ=12
                AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
                AND A.DEPT_ID = B.DEPT_ID
                AND A.END_CUST_REPORT = B.END_CUST_REPORT
                AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
                AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE
                AND A.YYYYMM = B.YYYYMM)
""")
match_cnt = cur.fetchone()[0]
print(f"[ Stage3 INNER JOIN ] {match_cnt} GT_SALES_LIST rows that match RATIO_DTL (VER_SEQ=12, 6-key)")

# Step 7: diagnose mismatch — try 5-key without YYYYMM (the year-month coupling)
cur.execute("""
SELECT COUNT(*) FROM GT_DMF0043_SALES_LIST_C A
WHERE EXISTS (SELECT 1 FROM DM_MST_CONTRIBUTE_RATIO_DTL B
              WHERE B.VER_SEQ=12
                AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
                AND A.DEPT_ID = B.DEPT_ID
                AND A.END_CUST_REPORT = B.END_CUST_REPORT
                AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
                AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE)
""")
match_5 = cur.fetchone()[0]
print(f"[ Stage3 5-key (no YYYYMM) ] {match_5} GT_SALES_LIST rows match by 5-key only")

# Step 8: sample mismatch — pick one GT row with non-null dept, show GT vs DTL row key comparison
cur.execute("""
SELECT YYYYMM, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT, DM_BIZ_TYPE
FROM GT_DMF0043_SALES_LIST_C
WHERE DEPARTMENT_ID IS NOT NULL AND ROWNUM <= 5
""")
print("\n[ GT_SALES_LIST sample (first 5 non-null DEPT) ]")
for row in cur.fetchall():
    print(f"  {row}")

cur.execute("""
SELECT YYYYMM, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT, DM_BIZ_TYPE, PRODUCT_GROUP
FROM DM_MST_CONTRIBUTE_RATIO_DTL WHERE VER_SEQ=12 AND ROWNUM <= 5
""")
print("\n[ DM_MST_CONTRIBUTE_RATIO_DTL sample (VER_SEQ=12, first 5) ]")
for row in cur.fetchall():
    print(f"  {row}")

conn.rollback()  # discard any GT_* writes (GTT scope is anyway session)
cur.close(); conn.close()
print("\n[ done ]")
