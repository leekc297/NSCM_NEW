# 코드는 호출하지만 FoxQuery 에 정의가 없고 DB 프로시저는 있는 id → 로컬 사본 foxml 에 보충 정의 생성 (2026-11-12)
#   원본 GSCM/04.WSL/FoxQuery 는 수정하지 않는다. 대상 = GSCM/_asis_local/04.WSL/FoxQuery/<파일>.foxml
#   파라미터: 코드의 request.Parameters["키"] ↔ DB sys.parameters. 이름이 같으면 이름으로, 아니면 개수가 같을 때만 순서로 매핑.
#   매핑할 수 없으면 생성하지 않고 보고만 한다(추측 매핑 금지).
#   --apply 없으면 미리보기만.
import os, re, csv, sys, pyodbc

ROOT = r"C:\Projects\NSCM"
SRC = os.path.join(ROOT, "GSCM")
FQ = os.path.join(SRC, "_asis_local", "04.WSL", "FoxQuery")
APPLY = "--apply" in sys.argv

env = {}
for line in open(os.path.join(ROOT, ".env.asis"), encoding="utf-8-sig"):
    line = line.strip()
    if "=" in line and not line.startswith("#"):
        k, v = line.split("=", 1)
        env[k.strip()] = v.strip().strip('"').strip("'")
pw = env[next(k for k in env if k.startswith("ASIS_DB_") and re.search(r"PASS|PWD", k))]

rows = [r for r in csv.DictReader(open(os.path.join(SRC, "_build_logs", "foxquery_missing.csv"), encoding="utf-8-sig")) if r["db_proc_in"]]

def proc_params(cat, name):
    cn = pyodbc.connect("DRIVER={%s};SERVER=%s,%s;DATABASE=%s;UID=%s;PWD=%s;TrustServerCertificate=yes" % (
        env["ASIS_DB_DRIVER"], env["ASIS_DB_HOST"], env["ASIS_DB_PORT"], cat, env["ASIS_DB_USER"], pw), timeout=15)
    cur = cn.cursor()
    cur.execute("""SELECT p.name, t.name, p.max_length, p.is_output FROM sys.parameters p
                   JOIN sys.types t ON t.user_type_id = p.user_type_id
                   WHERE p.object_id = OBJECT_ID(?) ORDER BY p.parameter_id""", name)
    r = cur.fetchall(); cn.close()
    return r

DBT = {"nvarchar": "NVarChar", "varchar": "VarChar", "nchar": "NChar", "char": "Char", "int": "Int", "bigint": "BigInt",
       "decimal": "Decimal", "numeric": "Decimal", "float": "Float", "datetime": "DateTime", "date": "Date", "bit": "Bit",
       "ntext": "NText", "text": "Text", "smallint": "SmallInt", "money": "Money", "uniqueidentifier": "UniqueIdentifier",
       "xml": "Xml", "nvarchar(max)": "NVarChar", "structured": "Structured"}

def client_keys(call):
    keys = []
    for dp, dn, fn in os.walk(SRC):
        dn[:] = [d for d in dn if d not in ("obj", "bin", "_asis_local", "_build_logs", ".git")]
        for f in fn:
            if not f.endswith(".cs"):
                continue
            t = open(os.path.join(dp, f), encoding="utf-8-sig", errors="ignore").read()
            for m in re.finditer(r'FoxDataRequest\(\s*"' + re.escape(call) + r'"\s*\)', t):
                seg = t[m.end(): m.end() + 4000]
                stop = re.search(r"Execute\w*\(|new FoxDataRequest", seg)
                seg = seg[: stop.start()] if stop else seg
                ks = re.findall(r'Parameters\[\s*"([^"]+)"\s*\]', seg)
                ks += re.findall(r'Parameters\.Add\(\s*"([^"]+)"', seg)
                seen = []
                [seen.append(k) for k in ks if k not in seen]
                keys.append(seen)
    return keys

plan = {}
report = []
for r in rows:
    call, fx, qid, cat = r["call"], r["foxml"], r["id"], r["db_proc_in"]
    ps = proc_params(cat, qid)
    sp = [(p[0].lstrip("@"), p[1].lower(), p[2], p[3]) for p in ps]
    variants = client_keys(call)
    uniq = [list(v) for v in {tuple(v) for v in variants}]
    status, mapping = "", None
    if len(uniq) != 1:
        status = "SKIP 호출부 파라미터가 여러 형태(%d)" % len(uniq)
    else:
        ck = uniq[0]
        byname = {k.lower(): k for k in ck}
        if all(s[0].lower() in byname for s in sp) and len(ck) == len(sp):
            mapping = [(s, byname[s[0].lower()]) for s in sp]; status = "OK 이름 일치"
        elif len(ck) == len(sp):
            mapping = list(zip(sp, ck)); status = "OK 순서 매핑(개수 %d 일치)" % len(sp)
        else:
            status = "SKIP 개수 불일치 코드%d / SP%d" % (len(ck), len(sp))
    report.append((call, status, [s[0] for s in sp], uniq[0] if len(uniq) == 1 else uniq))
    if mapping is not None:
        x ='    <procedure id="%s" inputType="DataRow" methodName="%s">\n      <text><![CDATA[\n%s\n]]></text>\n      <parameters>\n' % (qid, qid, qid)
        for (n, t, ln, out), key in mapping:
            x += '        <parameter name="%s" property="%s" dbType="%s" direction="%s" />\n' % (
                n, key, DBT.get(t, "NVarChar"), "Output" if out else "Input")
        x += "      </parameters>\n    </procedure>\n"
        plan.setdefault(fx, []).append((qid, x))

for c, s, spn, ck in report:
    print("%-58s %s\n      SP=%s\n      code=%s" % (c, s, spn, ck))

if APPLY:
    for fx, items in plan.items():
        f = os.path.join(FQ, fx + ".foxml")
        raw = open(f, "rb").read(); enc = "utf-8-sig" if raw.startswith(b"\xef\xbb\xbf") else "utf-8"
        t = raw.decode(enc)
        add = "".join(x for q, x in items if ('id="%s"' % q) not in t)
        i = t.rfind("</")  # 루트 닫힘 태그 앞에 삽입
        close = t.rfind("</statements>") if "</statements>" in t else i
        t = t[:close] + "    <!-- 2026-11-12 로컬 보충(DB 프로시저 기준 · 원본 foxml 에 없음) -->\n" + add + t[close:]
        open(f, "w", encoding=enc, newline="").write(t)
        print("applied", fx, len(items))
