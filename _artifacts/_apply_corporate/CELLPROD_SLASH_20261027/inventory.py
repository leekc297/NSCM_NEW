"""CELL_PROD_SITE_ID '-' → '/' 일괄 변경 사전 실측 (조회 전용)"""
import sys; sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb, re
u,p,d = conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
cur.execute("""SELECT C.TABLE_NAME FROM USER_TAB_COLUMNS C JOIN USER_TABLES T ON T.TABLE_NAME=C.TABLE_NAME
 WHERE C.COLUMN_NAME='CELL_PROD_SITE_ID' AND T.TEMPORARY='N'
   AND NOT REGEXP_LIKE(C.TABLE_NAME, '(_BAK|BAK2|_SNAPSHOT|_KEEP|_TMP|_TEST)') ORDER BY 1""")
tabs = [r[0] for r in cur]
print("== ① 대상 테이블", len(tabs))
for t in tabs:
    cur.execute("SELECT cc.column_name FROM user_constraints c JOIN user_cons_columns cc ON cc.constraint_name=c.constraint_name WHERE c.table_name=:t AND c.constraint_type='P' ORDER BY cc.position", t=t)
    pk = [r[0] for r in cur]
    cur.execute(f"SELECT DIVISION_ID, SUM(CASE WHEN CELL_PROD_SITE_ID='-' THEN 1 ELSE 0 END), SUM(CASE WHEN CELL_PROD_SITE_ID='/' THEN 1 ELSE 0 END), COUNT(*) FROM SCM_MGR.{t} GROUP BY DIVISION_ID ORDER BY 1") if t != "X" else None
    rows = cur.fetchall()
    coll = "PK 없음"
    if pk and "CELL_PROD_SITE_ID" in pk:
        on = " AND ".join(f"B.{c} = A.{c}" for c in pk if c != "CELL_PROD_SITE_ID")
        cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{t} A WHERE A.CELL_PROD_SITE_ID='-' AND EXISTS (SELECT 1 FROM SCM_MGR.{t} B WHERE B.CELL_PROD_SITE_ID='/' AND {on})")
        coll = f"PK충돌 {cur.fetchone()[0]}"
    elif pk:
        coll = "PK 에 CELL_PROD 없음"
    print(f"  {t:36s} PK={','.join(pk)[:80]} | {coll}")
    for r in rows:
        if r[1] or r[2]: print(f"      div {r[0]:6s} '-' {r[1]:>9,} '/' {r[2]:>9,} 전체 {r[3]:>9,}")
print("== ③ CELL_PROD_SITE_ID 와 '-' 를 같은 줄에 쓰는 PL/SQL (주석 제외)")
cur.execute("""SELECT OWNER, NAME, TYPE, LINE, TEXT FROM ALL_SOURCE WHERE OWNER IN ('SCM_MGR') AND UPPER(TEXT) LIKE '%CELL_PROD%' AND TEXT LIKE '%''-''%' ORDER BY NAME, TYPE, LINE""")
agg = {}
for o,n,ty,l,tx in cur:
    code = tx.split("--")[0]
    if "'-'" in code and "CELL_PROD" in code.upper():
        agg.setdefault((n,ty), []).append(l)
for k,v in agg.items(): print(f"  {k[0]:40s} {k[1]:13s} {len(v)}줄  L{v[:12]}")
