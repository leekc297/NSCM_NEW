import sys, re, time
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info; import oracledb
PKG = r"C:\Projects\NSCM\_artifacts\_apply_corporate\SLASH_DEFAULT_20261008"
u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
def run_block(path, label):
    t = open(path, encoding="utf-8").read()
    blk = re.search(r"(DECLARE.*?\nEND;)\n/", t, flags=re.S).group(1)
    cur.callproc("DBMS_OUTPUT.ENABLE", [None]); t0 = time.time(); cur.execute(blk)
    lines = []; 
    while True:
        line = cur.var(str); status = cur.var(int); cur.callproc("DBMS_OUTPUT.GET_LINE", [line, status])
        if status.getvalue() != 0: break
        lines.append(line.getvalue())
    print(f"### {label} ({time.time()-t0:.1f}s) {len(lines)} lines"); [print("  ", l) for l in lines[:15]]; 
    if len(lines) > 15: print("   ...", lines[-1])
run_block(PKG + r"\01_APPLY_CLOUD_idempotent.sql", "01_APPLY_CLOUD (사내 재실행 = 멱등 확인)")
run_block(PKG + r"\02_VERIFY.sql", "02_VERIFY V1")
run_block(PKG + r"\03_RECOMPILE_INVALID.sql", "03_RECOMPILE (사내: 기존 INVALID 48 컴파일 시도)")
cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'"); print("INVALID after 03:", cur.fetchone()[0])
