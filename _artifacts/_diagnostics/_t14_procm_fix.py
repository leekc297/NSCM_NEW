#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form PROC_M 키 정정 — 12~15 를 store.filters 실측 키로 교체.

⚠ 12~15 는 메인 GET 과 **동일한 FE 키**여야 한다(Form 은 store.filters 를 무가공 전달 — hook #135 §3-1).
   실측 store payload = createdBy / userinfo / sesUserId / mnuId.
   구 등재값(sesUserId/userinfo/userId/menuId)은 12·14·15 가 어긋나 NULL 바인딩이 된다.
"""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

PROC = "PKG_DMF0014.P_DMF0014_GET_EXCEL_FORM_DATA"
ROWS = [
    ("divisionId", "VARCHAR", "IN", 1), ("deptId", "VARCHAR", "IN", 2),
    ("endCustomer", "VARCHAR", "IN", 3), ("scmSiteId", "VARCHAR", "IN", 4),
    ("plantSiteId", "VARCHAR", "IN", 5), ("projectCode", "VARCHAR", "IN", 6),
    ("itemId", "VARCHAR", "IN", 7), ("startYyyymmdd", "VARCHAR", "IN", 8),
    ("endYyyymmdd", "VARCHAR", "IN", 9), ("bucketType", "VARCHAR", "IN", 10),
    ("domExp", "VARCHAR", "IN", 11), ("createdBy", "VARCHAR", "IN", 12),
    ("userinfo", "VARCHAR", "IN", 13), ("sesUserId", "VARCHAR", "IN", 14),
    ("mnuId", "VARCHAR", "IN", 15),
    ("o_rc1", "CURSOR", "OUT", 16), ("o_result_cursor", "PROC_RESULT", "OUT", 17),
]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = :n", {"n": PROC})
print(f"[delete] {cur.rowcount}행")

cur.executemany(
    """INSERT INTO SCM_MGR.SCM_ADM_PROC_M
       (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
       VALUES (:1, :2, :3, :4, :5, 'admin', SYSDATE, 'admin', SYSDATE)""",
    [(PROC, c, dt, ct, so) for c, dt, ct, so in ROWS],
)
print(f"[insert] {cur.rowcount}행")
con.commit()

cur.execute("""SELECT SORT_ORD, COL_NM, DATA_TP_CD, COL_TP_CD FROM SCM_MGR.SCM_ADM_PROC_M
               WHERE PROC_NM = :n ORDER BY SORT_ORD""", {"n": PROC})
print("\n[verify] PROC_M")
for r in cur.fetchall():
    print(f"   {r[0]:>3} {r[1]:<18} {r[2]:<12} {r[3]}")
con.close()
