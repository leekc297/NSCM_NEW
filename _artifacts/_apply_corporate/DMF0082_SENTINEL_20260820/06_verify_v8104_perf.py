"""V81-04 재작성 성능 실측 — 세션 로컬 GTT 에 최근 81 저장 키 적재 후 동일 쿼리 실행 (원장 무변경)."""
import os
import time

import oracledb

ENV_PATH = r"C:\Projects\NSCM\.env.asis"
vals = {}
with open(ENV_PATH, encoding="utf-8") as f:
    for ln in f:
        ln = ln.strip()
        if "=" in ln and not ln.startswith("#"):
            k, v = ln.split("=", 1)
            vals[k] = v

conn = oracledb.connect(
    user="SCM_MGR",
    password=vals["TOBE_DB_PASS"],
    dsn=f"{vals['TOBE_DB_HOST']}:{vals['TOBE_DB_PORT']}/{vals['TOBE_DB_PDB']}",
)
cur = conn.cursor()

cur.execute(
    """
    INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
    ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
    , INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY )
    SELECT 'M', DIVISION_ID, PROJECT_CODE, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
         , INCOTERMS, MEASURE, PLANT_SITE_ID, '-', YYYYMMDD, CURRENCY, PRICE, 'perfprobe'
    FROM   SCM_MGR.SCM_MST_FUTURE_PRICE
    WHERE  LAST_UPDATED_BY = 'minyonglee1' AND ROWNUM <= 15
    """
)
print("GTT rows:", cur.rowcount)

q = """
SELECT A.ITEM_ID
FROM   SCM_MGR.GT_PRDM1_T_MAIN A
LEFT   JOIN SCM_MGR.SCM_MST_SITE_ITEM F
  ON   A.DIVISION_ID  = F.DIVISION_ID
 AND   A.ITEM_ID      = F.ITEM_ID
 AND   A.PROJECT_CODE = F.PROJECT_CODE
 AND   A.SCM_SITE_ID  = F.SCM_SITE_ID
JOIN   (SELECT SN.DIVISION_ID, SN.ITEM_ID, MAX(SN.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
        FROM   SCM_MGR.SCM_MST_ITEM_SN SN
        GROUP  BY SN.DIVISION_ID, SN.ITEM_ID) X
  ON   A.DIVISION_ID = X.DIVISION_ID
 AND   A.ITEM_ID     = X.ITEM_ID
WHERE  CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
            WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
            WHEN INSTR(X.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
            ELSE 0
       END = 1
  AND  ROWNUM = 1
"""
for attempt in (1, 2):
    t0 = time.perf_counter()
    cur.execute(q)
    rows = cur.fetchall()
    print(f"run{attempt}: {time.perf_counter() - t0:.3f}s rows={len(rows)}")

conn.rollback()
print("rolled back (GTT probe rows discarded)")
