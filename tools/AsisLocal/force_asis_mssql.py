# 로컬 AS-IS 실행 사본의 모든 DB 연결을 AS-IS MSSQL(.env.asis) 로만 강제 (2026-11-12 사용자 지시 "DB 연결은 AS-IS MSSQL 로만")
#   대상: GSCM/_asis_local/04.WSL 의 Framework*.config 전부(실사용 Framework.config + 대체용 DEV/QA/MGR)
#   Catalog: FP 계열 → LGCE_FPDEV_TR, 그 외 MSSQL → LGCE_SCMDEV (둘 다 .env.asis 서버에 존재 확인 11-12)
#   Oracle(DW) 연결은 MSSQL 로 바꿀 수 없으므로 그 서비스 폴더를 사본에서 제외(삭제)한다. 원본 04.WSL 은 건드리지 않는다.
import os, re, shutil

ROOT = r"C:\Projects\NSCM"
DST = os.path.join(ROOT, "GSCM", "_asis_local", "04.WSL")
env = {}
for line in open(os.path.join(ROOT, ".env.asis"), encoding="utf-8-sig"):
    line = line.strip()
    if "=" in line and not line.startswith("#"):
        k, v = line.split("=", 1)
        env[k.strip()] = v.strip().strip('"').strip("'")
pw = env[next(k for k in env if k.startswith("ASIS_DB_") and re.search(r"PASS|PWD", k))]
host = "{},{}".format(env["ASIS_DB_HOST"], env["ASIS_DB_PORT"])

def conn(cat):
    return "Initial Catalog={};Data Source={};uid={};pwd={};".format(cat, host, env["ASIS_DB_USER"], pw)

cs_pat = re.compile(r'connectionString="([^"]*)"', re.I)
changed = removed = 0
for d in sorted(os.listdir(DST)):
    full = os.path.join(DST, d)
    if not os.path.isdir(full):
        continue
    cfgs = []
    for dp, dn, fn in os.walk(full):
        dn[:] = [x for x in dn if x != "bin"]
        cfgs += [os.path.join(dp, f) for f in fn if re.match(r"Framework.*\.config$", f, re.I)]
    oracle = any("DESCRIPTION=" in open(c, encoding="utf-8-sig", errors="ignore").read() for c in cfgs)
    if oracle:
        shutil.rmtree(full)
        removed += 1
        print("removed (Oracle DW, MSSQL 아님):", d)
        continue
    for c in cfgs:
        raw = open(c, "rb").read()
        enc = "utf-8-sig" if raw.startswith(b"\xef\xbb\xbf") else "utf-8"
        t = raw.decode(enc)
        def rep(m):
            v = m.group(1)
            if not re.search(r"(Data Source|server)\s*=", v, re.I):
                return m.group(0)
            cat = "LGCE_FPDEV_TR" if re.search(r"Initial Catalog=[^;]*FP", v, re.I) else env["ASIS_DB_NAME"]
            return 'connectionString="' + conn(cat) + '"'
        t2 = cs_pat.sub(rep, t)
        if "commandTimeout=" not in t2:
            t2 = re.sub(r'(<add name="GSCM" type="TheOne\.Data\.SqlClient\.FoxSqlDbAccess")', r'\1 commandTimeout="300"', t2)
        if t2 != t:
            open(c, "w", encoding=enc, newline="").write(t2)
            changed += 1
print("config files changed:", changed, "| service folders removed:", removed)
