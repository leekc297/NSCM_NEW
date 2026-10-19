"""[E20261014-DMF0082VMICURR] VMI 와 MKT_FCST 를 같은 조회에 함께 띄워 키별 CURRENCY 비교 (원장 무변경)

메저 선택(SCM_MST_TITLESET_USER 'M')을 같은 트랜잭션 안에서만 임시로 추가 → 조회 SP 호출 → ROLLBACK.
조회 SP 는 COMMIT 하지 않는다(GET_MAIN_DATA 본문 COMMIT 0 — 2026-10-14 실측). 끝나면 추가 행 잔존 0 을 재확인한다.

  python probe_mix.py <PROC> <DIV> <FROM> <TO> <SITE> [USER]
"""
import sys, re
from collections import Counter, defaultdict
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

proc, div, f, t, site = sys.argv[1:6]
user = sys.argv[6] if len(sys.argv) > 6 else "minyonglee1"
ADD = ["MKT_FCST", "SCM_FCST", "RTF_SYS_RP", "VMI_In_Req", "VMI_Inv", "VMI_DIO", "LOC"]
NON_KEY = re.compile(r"^(MEASURE|QTY|[MWD]_\d+|SORT_KEY|SORT_ORDER_NO|LAST_UPDATE_DATE|LAST_UPDATED_BY|EDIT_FLAG|BUCKET|MEASURE_GROUP|NOTATION|CURRENCY|ATTR1|NEW_FLAG|VMI_STD_DIO|AS_YN|GROUP_ID|VERSION_NO)$")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT SHEET_NAME, MAX(SORT_ORDER_NO) FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND USER_ID=:u AND USER_INQUIRY_COLUMN_TYPE_CODE='M' GROUP BY SHEET_NAME", u=user)
sheet, mx = cur.fetchone()
added = 0
for i, m in enumerate(ADD):
    cur.execute("""INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
                   (USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG,
                    DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
                   SELECT :u, 'DMF0082', :s, 'M', :m, :o, 'N', NULL, :u, SYSDATE, :u, SYSDATE FROM DUAL
                   WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME=:s
                                     AND USER_ID=:u AND USER_INQUIRY_COLUMN_TYPE_CODE='M' AND COLUMN_NAME=:m)""",
                u=user, s=sheet, m=m, o=int(mx or 0) + i + 1)
    added += cur.rowcount
try:
    args = [div, "ALL", "ALL", "ALL", f, t, site, "", "Current", "N", user, "ADMIN", "ALL", "ALL", "ALL", "ALL"]
    outs = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
    cur.callproc("SCM_MGR.PKG_DMF0082." + proc, args + outs)
    c = outs[0].getvalue()
    cols = [x[0] for x in c.description]
    rows = c.fetchall()
finally:
    con.rollback()
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND USER_ID=:u AND USER_INQUIRY_COLUMN_TYPE_CODE='M'", u=user)
print(f"{proc} {div} {site} | 임시 메저 추가 {added}행 → ROLLBACK 후 {user} 'M' 행 {cur.fetchone()[0]}")

mi, ci = cols.index("MEASURE"), cols.index("CURRENCY")
keyi = [i for i, cn in enumerate(cols) if not NON_KEY.match(cn)]
dist = defaultdict(Counter)
bykey = defaultdict(dict)
for r in rows:
    dist[r[mi]][repr(r[ci])] += 1
    bykey[tuple(r[i] for i in keyi)].setdefault(r[mi], set()).add(r[ci])
for m in sorted(dist):
    print(f"   {m:12s} {dict(dist[m])}")
cmp = Counter()
for k, ms in bykey.items():
    if "MKT_FCST" not in ms:
        continue
    mk = ms["MKT_FCST"]
    for m, cs in ms.items():
        if m.startswith("VMI"):
            cmp[f"{m} {'== MKT_FCST' if cs == mk else f'!= MKT_FCST ({sorted(cs)} vs {sorted(mk)})'}"] += 1
print("   같은 키 VMI vs MKT_FCST:", dict(cmp) or "비교 대상 키 없음")
