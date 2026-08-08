#!/usr/bin/env python3
"""DMF0082 uicategory 작업 전/후 증적 — 사용법: python evidence_dmf0082_uicategory.py pre|post
① 메타 카운트/토큰 분포 ② titleset 카운트 ③ PROC_M 행수
④ P_DMF0082_GET_MAIN_DATA_CURRENT 40/81/82 실호출 — O_RC1 행수+컬럼수 (40 무회귀 기준)
   (사용자=minyonglee1: titleset 기보유 → 시드 부작용 없음. GTT 는 세션 임시 — 무해)"""
import sys, pathlib, datetime
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info
import oracledb

label = sys.argv[1] if len(sys.argv) > 1 else "pre"
OUT = pathlib.Path(__file__).resolve().parents[1] / "_apply_corporate" / f"EVIDENCE_DMF0082_uicategory_{label}_20260807.txt"
L = [f"# DMF0082 uicategory EVIDENCE ({label}) — {datetime.datetime.now().isoformat()}"]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

def q(title, sql):
    cur.execute(sql)
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    L.append(f"\n## {title}")
    L.append(" | ".join(cols))
    for r in rows:
        L.append(" | ".join("" if v is None else str(v) for v in r))

q("SHEET_COLUMNS 카운트/토큰", """
SELECT SHEET_NAME, COUNT(*) TOT,
 SUM(CASE WHEN ','||DIVISION_ID||',' LIKE '%,40,%' THEN 1 ELSE 0 END) D40,
 SUM(CASE WHEN ','||DIVISION_ID||',' LIKE '%,81,%' THEN 1 ELSE 0 END) D81,
 SUM(CASE WHEN ','||DIVISION_ID||',' LIKE '%,82,%' THEN 1 ELSE 0 END) D82
 FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082' GROUP BY SHEET_NAME""")
q("FcstNPrice 5키 DIVISION_ID", """
SELECT COLUMN_NAME, DIVISION_ID, DEFAULT_FLAG, VISIBLE_FLAG, VALID_YN
 FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
 AND COLUMN_NAME IN ('DIVISION_ID','END_CUSTOMER','SCM_SITE_ID','ITEM_ID','CELL_PROD_SITE_ID') ORDER BY SORT_ORDER_NO""")
q("SHEET_MEASURE 토큰", """
SELECT COLUMN_NAME, DIVISION_ID, DEFAULT_FLAG, VALID_YN FROM SCM_MST_SHEET_MEASURE
 WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' ORDER BY SORT_ORDER_NO""")
q("TITLESET 카운트", """
SELECT USER_INQUIRY_COLUMN_TYPE_CODE TP, COUNT(*) CNT, COUNT(DISTINCT USER_ID) USERS
 FROM SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
 GROUP BY USER_INQUIRY_COLUMN_TYPE_CODE""")
q("PROC_M GET 2종", """
SELECT PROC_NM, COL_NM, COL_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M
 WHERE PROC_NM LIKE 'PKG_DMF0082.P_DMF0082_GET_MAIN_DATA%' ORDER BY PROC_NM, SORT_ORD""")

L.append("\n## GET_MAIN_DATA 실호출 (from=20260801 to=20270201, ALL, itemId=''[FE 규약], ver=Current, qtyYn=N, user=minyonglee1, group=DM ADMIN)")
for div in ("40", "81", "82"):
    rcs = [con.cursor() for _ in range(6)]
    try:
        cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
                     [div, "ALL", "ALL", "ALL", "20260801", "20270201", "ALL", "",
                      "Current", "N", "minyonglee1", "DM ADMIN", "ALL", "ALL", "ALL", "ALL"] + rcs)
        cols = [c[0] for c in rcs[0].description]
        rows = rcs[0].fetchall()
        res = rcs[5].fetchall()
        L.append(f"div={div}: O_RC1 rows={len(rows)} cols={len(cols)} | RESULT={res[:1]}")
        L.append(f"  cols: {', '.join(cols)}")
    except Exception as e:
        L.append(f"div={div}: ERROR {e}")
    for c in rcs:
        try: c.close()
        except Exception: pass

con.rollback()
con.close()
OUT.write_text("\n".join(L) + "\n", encoding="utf-8", newline="\n")
print(f"written: {OUT}")
print("\n".join(L[-14:]))
