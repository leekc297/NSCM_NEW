# AS-IS 웹 서비스(04.WSL) 로컬 실행용 사본 생성 (2026-11-12)
#   원본(GSCM/04.WSL)은 수정하지 않는다. 사본 = GSCM/_asis_local/04.WSL
#   사본의 Framework.config 중 LGCE_SCMDEV 연결만 .env.asis 의 AS-IS DB 로 바꾼다(비밀번호는 출력하지 않음).
import os, re, shutil, sys

ROOT = r"C:\Projects\NSCM"
SRC = os.path.join(ROOT, "GSCM", "04.WSL")
DST = os.path.join(ROOT, "GSCM", "_asis_local", "04.WSL")

env = {}
for line in open(os.path.join(ROOT, ".env.asis"), encoding="utf-8-sig"):
    line = line.strip()
    if "=" in line and not line.startswith("#"):
        k, v = line.split("=", 1)
        env[k.strip()] = v.strip().strip('"').strip("'")
pw_key = next((k for k in env if k.startswith("ASIS_DB_") and re.search(r"PASS|PWD", k)), None)
need = ["ASIS_DB_HOST", "ASIS_DB_PORT", "ASIS_DB_NAME", "ASIS_DB_USER"]
missing = [k for k in need if not env.get(k)] + ([] if pw_key else ["ASIS_DB_PASSWORD"])
if missing:
    sys.exit("[ERROR] .env.asis 누락: " + ", ".join(missing))

if os.path.isdir(DST):
    shutil.rmtree(DST)
ign = shutil.ignore_patterns("obj", "*.cs", "*.csproj", "*.user", "*.vspscc", "*.pdb", "Deploy", "*.zip")
shutil.copytree(SRC, DST, ignore=ign)

conn = "Initial Catalog={};Data Source={},{};uid={};pwd={};".format(
    env["ASIS_DB_NAME"], env["ASIS_DB_HOST"], env["ASIS_DB_PORT"], env["ASIS_DB_USER"], env[pw_key])
changed, kept = [], []
for d in sorted(os.listdir(DST)):
    f = os.path.join(DST, d, "Framework.config")
    if not os.path.isfile(f):
        continue
    raw = open(f, "rb").read()
    enc = "utf-8-sig" if raw.startswith(b"\xef\xbb\xbf") else "utf-8"
    txt = raw.decode(enc)
    pat = re.compile(r'connectionString="Initial Catalog=LGCE_SCMDEV;[^"]*"', re.I)
    new, n = pat.subn(lambda m: 'connectionString="' + conn + '"', txt)
    # 11-12: FP 계열(LGCE_FPDEV_TR)도 같은 AS-IS DB 서버에 있음(sys.databases 확인) → .env.asis 계정으로 연결
    conn_fp = conn.replace("Initial Catalog=" + env["ASIS_DB_NAME"] + ";", "Initial Catalog=LGCE_FPDEV_TR;")
    pat_fp = re.compile(r'connectionString="Initial Catalog=LGCE_FPDEV_TR;[^"]*"', re.I)
    new, n2 = pat_fp.subn(lambda m: 'connectionString="' + conn_fp + '"', new)
    n += n2
    if n and "commandTimeout=" not in new:
        new = re.sub(r'(<add name="GSCM" type="TheOne\.Data\.SqlClient\.FoxSqlDbAccess")', r'\1 commandTimeout="300"', new)
    if n:
        open(f, "w", encoding=enc, newline="").write(new)
        changed.append(d)
    else:
        m = re.search(r"Initial Catalog=([^;]+);Data Source=([^;]+)", txt)
        kept.append("{} ({})".format(d, m.group(1) + " @ " + m.group(2) if m else "연결 문자열 없음"))

apps = sorted(p for p in (os.path.join(d, w) for d in os.listdir(DST) if os.path.isdir(os.path.join(DST, d))
                         for w in os.listdir(os.path.join(DST, d)) if w.endswith(".WSL"))
              if os.path.isfile(os.path.join(DST, p, "Web.config")))
print("사본:", DST)
print("웹 앱:", len(apps))
print("DB 를 .env.asis 로 바꾼 Framework.config:", len(changed))
print("바꾸지 않은 것:", len(kept))
for k in kept:
    print("  -", k)
with open(os.path.join(ROOT, "GSCM", "_asis_local", "apps.txt"), "w", encoding="utf-8") as fo:
    for a in apps:
        has_bin = any(x.lower().endswith(".dll") for x in os.listdir(os.path.join(DST, a, "bin"))) if os.path.isdir(os.path.join(DST, a, "bin")) else False
        fo.write("{}|{}|{}\n".format(os.path.basename(a), os.path.join(DST, a), "bin" if has_bin else "nobin"))
