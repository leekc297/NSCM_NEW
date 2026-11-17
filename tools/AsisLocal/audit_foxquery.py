# AS-IS 소스가 호출하는 FoxQuery id ↔ FoxQuery/*.foxml 정의 대조 (2026-11-12)
#   호출: new FoxDataRequest("파일.id") / FoxDataRequest("id") 형태(문자열 리터럴만 · 변수 조합 호출은 따로 집계)
#   정의: <procedure|select|statement ... id="...">  (foxml 파일명 = 앞 접두어)
#   DB: .env.asis MSSQL 의 sys.procedures 에 같은 이름이 있는지
import os, re, csv, pyodbc

ROOT = r"C:\Projects\NSCM"
SRC = os.path.join(ROOT, "GSCM")
FQ = os.path.join(SRC, "_asis_local", "04.WSL", "FoxQuery")
OUT = os.path.join(SRC, "_build_logs", "foxquery_missing.csv")

defined = {}
for f in os.listdir(FQ):
    if f.lower().endswith(".foxml"):
        t = open(os.path.join(FQ, f), encoding="utf-8-sig", errors="ignore").read()
        for m in re.finditer(r'<\w+\s+id="([^"]+)"', t):
            defined.setdefault(f[:-6].lower(), set()).add(m.group(1).lower())

lit = re.compile(r'FoxDataRequest\(\s*"([^"]+)"')
dyn = 0
uses = {}
for dp, dn, fn in os.walk(SRC):
    dn[:] = [d for d in dn if d not in ("obj", "bin", "_asis_local", "_build_logs", ".git")]
    for f in fn:
        if not f.endswith(".cs"):
            continue
        p = os.path.join(dp, f)
        t = open(p, encoding="utf-8-sig", errors="ignore").read()
        t = re.sub(r"/\*.*?\*/", "", t, flags=re.S)
        t = re.sub(r"//[^\n]*", "", t)
        dyn += len(re.findall(r"FoxDataRequest\(\s*[^\")\s]", t))
        for m in lit.finditer(t):
            uses.setdefault(m.group(1), set()).add(os.path.relpath(p, SRC))

env = {}
for line in open(os.path.join(ROOT, ".env.asis"), encoding="utf-8-sig"):
    line = line.strip()
    if "=" in line and not line.startswith("#"):
        k, v = line.split("=", 1)
        env[k.strip()] = v.strip().strip('"').strip("'")
pw = env[next(k for k in env if k.startswith("ASIS_DB_") and re.search(r"PASS|PWD", k))]
procs = {}
for cat in (env["ASIS_DB_NAME"], "LGCE_FPDEV_TR"):
    cn = pyodbc.connect("DRIVER={%s};SERVER=%s,%s;DATABASE=%s;UID=%s;PWD=%s;TrustServerCertificate=yes" % (
        env["ASIS_DB_DRIVER"], env["ASIS_DB_HOST"], env["ASIS_DB_PORT"], cat, env["ASIS_DB_USER"], pw), timeout=15)
    cur = cn.cursor()
    cur.execute("SELECT name FROM sys.procedures")
    for (n,) in cur.fetchall():
        procs.setdefault(n.lower(), cat)
    cn.close()

rows = []
for full, files in sorted(uses.items()):
    if "." in full:
        fx, qid = full.split(".", 1)
    else:
        fx, qid = "", full
    ok = qid.lower() in defined.get(fx.lower(), set()) if fx else any(qid.lower() in s for s in defined.values())
    if not ok:
        rows.append([full, fx, qid, "Y" if fx.lower() in defined else "N(file 없음)", procs.get(qid.lower(), ""), len(files), sorted(files)[0]])
with open(OUT, "w", newline="", encoding="utf-8-sig") as fo:
    w = csv.writer(fo)
    w.writerow(["call", "foxml", "id", "foxml_exists", "db_proc_in", "call_files", "first_file"])
    w.writerows(rows)
print("literal query ids used:", len(uses), "| dynamic (non-literal) calls:", dyn)
print("not defined in FoxQuery:", len(rows), "| of which DB proc exists:", sum(1 for r in rows if r[4]))
from collections import Counter
print("by foxml:", dict(Counter(r[1] for r in rows)))
print("csv:", OUT)
