"""ZT 자동 케이스 생성·실행 — 컬럼 케이스(table, cols) 하나를 받아
  ① ALL_DEPENDENCIES 로 참조 객체 수집 → ② 원문을 DB 에서 새로 받아(zt_fetch) sqlscan 으로 케이스 컬럼에 '확정'으로 묶인 '-' 출현을 전부 '/' 로 바꾸는 edits 생성
  ③ 테이블을 읽는 조회 서브프로그램(OUT 커서 보유)을 찾아 파라미터를 데이터·시그니처에서 유도 → ④ zt_case.deploy/run/drop
  결과: zt/_result/<case>.json + 콘솔.  DB 변경 = ZT_ 객체 생성/삭제뿐(원본·데이터 무변경).

사용: python zt_auto.py CASE02 SCP_ANL_PRODUCTION_PLAN LINE_ID [--tables SCP_ANL_PRODUCTION_PLAN_C,SCP_ANL_PRODUCTION_PLAN_H] [--skip-run] [--keep]
"""
import sys, os, re, json, time, collections, subprocess
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.dirname(HERE)); sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import zt_case
from sqlscan import Scanner
import oracledb
from ora import conn_info
CACHE = os.path.join(os.path.dirname(HERE), "_cache")
LOG = zt_case.log


def conn():
    u, p, d = conn_info(); c = oracledb.connect(user=u, password=p, dsn=d); c.call_timeout = 1800 * 1000; return c


def catalog():
    cat = json.load(open(os.path.join(CACHE, "tobe_cat.json"), encoding="utf-8"))
    scm, fp = {}, {}
    for k, v in cat["tables"].items():
        ow, tb = k.split("|"); ent = {"kind": v["kind"], "cols": set(v["order"]), "order": v["order"]}
        (scm if ow == "SCM_MGR" else fp)[tb] = ent
    c = dict(fp); c.update(scm); return c


def deps(cur, tables):
    cur.execute("SELECT DISTINCT name, type FROM all_dependencies WHERE owner='SCM_MGR' AND referenced_owner='SCM_MGR' AND referenced_name IN (%s) ORDER BY type, name"
                % ",".join("'%s'" % t for t in tables))
    return [(n, t) for n, t in cur if not n.startswith("ZT_")]      # 다른 케이스의 ZT 복사본은 제외


def fetch(names):
    subprocess.run([sys.executable, os.path.join(HERE, "zt_fetch.py")] + names, check=True, capture_output=True)


def scan_edits(name, ty, text, cat, tables, cols):
    """원문에서 케이스 (table,col) 에 '확정'으로 묶인 '-' 출현 → edits [(line, col1, old, new)] + 요약."""
    pop = {t: set(cols) for t in tables}
    views = {t for t, v in cat.items() if v["kind"] == "view"}
    sc = Scanner(cat, pop, views, "plsql")
    occ, _ = sc.scan(text)
    lines = text.split("\n"); starts = [0]
    for l in lines:
        starts.append(starts[-1] + len(l) + 1)
    edits = []; roles = collections.Counter(); skipped = collections.Counter()
    for r in occ:
        if r["role"] in ("NON_SENTINEL",) or r.get("pos") is None:
            continue
        tied = {(t, c) for t, c, tier in r["refs"] + r["dest"] if tier == "확정" and t in tables and c in cols}
        if not tied:
            continue
        ln = r["line"]; col0 = r["pos"] - starts[ln - 1]
        seg = lines[ln - 1][col0:col0 + r["len"]]
        if "-" not in seg:
            skipped["pos-mismatch"] += 1; continue
        edits.append([ln, col0 + 1, seg, seg.replace("-", "/")]); roles[r["role"]] += 1
    return edits, roles


def reads_table(text, tables):
    return any(re.search(r"\b(FROM|JOIN|INTO|UPDATE)\s+(SCM_MGR\.)?" + t + r"\b|,\s*(SCM_MGR\.)?" + t + r"\s+\w", text, re.I) for t in tables)


def subprograms(text):
    """(name, start_line, end_line) — PACKAGE BODY 안 PROCEDURE/FUNCTION 경계."""
    out = []; cur = None
    for i, l in enumerate(text.split("\n"), 1):
        m = re.match(r"\s*(PROCEDURE|FUNCTION)\s+\"?(\w+)", l, re.I)
        if m:
            if cur:
                out.append((cur[0], cur[1], i - 1))
            cur = (m.group(2).upper(), i)
    if cur:
        out.append((cur[0], cur[1], 10 ** 9))
    return out


def args_of(cur, pkg, proc):
    cur.execute("SELECT position, argument_name, in_out, data_type FROM all_arguments WHERE owner='SCM_MGR' AND NVL(package_name,'-')=:1 AND object_name=:2 AND data_level=0 ORDER BY position",
                [pkg or "-", proc])
    return [(p, (n or "").upper(), io, dt) for p, n, io, dt in cur]


def derive_params(cur, args, tables, screen, cache):
    """IN 파라미터 값을 시그니처 이름 + 케이스 테이블 데이터에서 유도. 대안 세트 최대 3개."""
    t0 = tables[0]
    def distinct(col, n=3):
        k = (t0, col)
        if k not in cache:
            try:
                # 전체 GROUP BY 금지(1억 행 테이블) — 앞쪽 2만 행만 읽어 빈도 상위 값 추정(통계 유무와 무관하게 빠름)
                cur.execute(f"SELECT {col} FROM (SELECT {col}, COUNT(*) N FROM (SELECT {col} FROM SCM_MGR.{t0} WHERE ROWNUM <= 20000) GROUP BY {col} ORDER BY N DESC) WHERE ROWNUM <= {n}")
                cache[k] = [r[0] for r in cur if r[0] is not None]
            except Exception:
                cache[k] = []
        return cache[k]
    def has(col):
        cur.execute("SELECT COUNT(*) FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name=:1 AND column_name=:2", [t0, col]); return cur.fetchone()[0] > 0
    def dates():
        k = (t0, "__dates")
        if k not in cache:
            dc = next((c for c in ("YYYYMMDD", "PLAN_DATE", "BASIS_YYYYMMDD", "CUTOFF_YYYYMMDD", "YYYYMM") if has(c)), None)
            if dc:
                cur.execute(f"SELECT MIN({dc}), MAX({dc}) FROM (SELECT {dc} FROM SCM_MGR.{t0} WHERE ROWNUM <= 20000)"); mn, mx = cur.fetchone()
                cache[k] = (str(mn)[:8].replace("-", ""), str(mx)[:8].replace("-", ""))
            else:
                cache[k] = ("20260101", "20261231")
        return cache[k]
    sets = []
    for alt in range(3):
        vals = []
        for p, n, io, dt in args:
            if io != "IN":
                continue
            base = re.sub(r"^(P|V|I)_", "", n)
            v = ""
            if base in ("USER_ID", "CREATED_BY", "SES_USER_ID", "LOGIN_ID"):
                v = "minyonglee1"
            elif base in ("PROGRAM_ID", "MENU_ID", "MNU_ID"):
                v = screen
            elif base == "SHEET_NAME":
                cur.execute("SELECT SHEET_NAME FROM (SELECT SHEET_NAME, COUNT(*) N FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:1 GROUP BY SHEET_NAME ORDER BY N DESC) WHERE ROWNUM=1", [screen])
                r = cur.fetchone(); v = r[0] if r else ""
            elif base in ("FROM_YYYYMMDD", "START_YYYYMMDD", "START_DATE", "FROM_DATE", "FROM_YYYYMM"):
                v = dates()[0][:6] if base.endswith("YYYYMM") else dates()[0]
            elif base in ("TO_YYYYMMDD", "END_YYYYMMDD", "END_DATE", "TO_DATE", "TO_YYYYMM"):
                v = dates()[1][:6] if base.endswith("YYYYMM") else dates()[1]
            elif base.endswith("_YN") or base.endswith("CHK") or base in ("REAL_FLAG", "DEBUG_MODE", "INVALID_EXEC"):
                v = "N"
            elif base == "BUCKET":
                v = "MONTHLY"
            elif base in ("VERSION_TYPE",):
                v = "Current"
            else:
                # 테이블에 같은 이름(또는 유사) 컬럼이 있으면 빈도 상위 값, 없으면 'ALL'/''
                cand = [c for c in (base, base.replace("SCM_SITE_ID", "FROM_SITE"), base.replace("SITE_ID", "FROM_SITE"), "SCM_SITE_ID" if base == "FROM_SITE" else base) if has(c)]
                if cand:
                    d = distinct(cand[0]); v = d[min(alt, len(d) - 1)] if d else ""
                elif base in ("ITEM_ID", "PROJECT_CODE", "CUSTOMER", "END_CUSTOMER", "TEAM_ID", "DEPT_ID", "OWNER", "BIZ_TYPE", "ITEM_TYPE", "PLANT_SITE_ID", "SCM_SITE_ID", "SALES_SITE", "SENDER_CODE", "PRODUCT_LEVEL1", "OPERATION_GROUP", "FROM_SITE", "COMPANY_ID"):
                    v = "ALL" if base not in ("ITEM_ID", "PROJECT_CODE", "PRODUCT_LEVEL1", "FROM_SITE", "COMPANY_ID") else ""
            vals.append(v)
        if vals not in sets:
            sets.append(vals)
    return sets


def main():
    a = sys.argv[1:]
    name, table, cols = a[0], a[1], a[2].split(",")
    tables = [table] + (a[a.index("--tables") + 1].split(",") if "--tables" in a else [])
    cat = catalog()
    with conn() as c:
        cur = c.cursor()
        dp = deps(cur, tables)
        LOG(name, "deps", len(dp), collections.Counter(t for _, t in dp))
        pkgs = sorted({n for n, t in dp if t == "PACKAGE BODY"}); procs = sorted({n for n, t in dp if t == "PROCEDURE"}); views = sorted({n for n, t in dp if t == "VIEW"}); funcs = sorted({n for n, t in dp if t == "FUNCTION"})
        fetch(pkgs + procs + funcs)
        case = {"name": name, "table": table, "map_cols": cols, "tables": tables, "packages": {}, "calls": [], "notes": []}
        cache = {}
        for pkg in pkgs:
            text = zt_case.read_src(pkg, "PACKAGE_BODY")
            edits, roles = scan_edits(pkg, "PACKAGE BODY", text, cat, tables, cols)
            reads = reads_table(text, tables)
            LOG("  ", pkg, "edits", len(edits), dict(roles), "| reads table", reads)
            if not reads and not edits:
                continue
            case["packages"][pkg] = {"edits": edits}
            screen = re.sub(r"^PKG_", "", pkg)
            for sub, s0, s1 in subprograms(text):
                body = "\n".join(text.split("\n")[s0 - 1:s1])
                if not reads_table(body, tables):
                    continue
                ar = args_of(cur, pkg, sub)
                outs = [n for p, n, io, dt in ar if io == "OUT" and dt == "REF CURSOR"]
                if not outs or "_GET_" not in sub or re.search(r"SAVE|_DEL|_INS|_UPD|UPLOAD|LOAD|CREATE|MERGE|_EXEC", sub, re.I):
                    case["notes"].append(f"{pkg}.{sub}: 테이블 읽음 — 실행 비교 제외(OUT 커서 없음 또는 조회 SP 아님)"); continue
                if any(io == "OUT" and dt != "REF CURSOR" for p, n, io, dt in ar) or any(io == "IN/OUT" for p, n, io, dt in ar):
                    case["notes"].append(f"{pkg}.{sub}: OUT 스칼라/IN OUT 인자 — 실행 비교 제외"); continue
                import zt_params
                sheet_cache = cache.setdefault("__sheets", {})
                try:
                    psets = zt_params.derive(cur, ar, body, table, screen, sheet_cache)
                except Exception as e:
                    LOG("   param derive fail", pkg, sub, str(e)[:100]); psets = []
                if not psets:
                    psets = derive_params(cur, ar, tables, screen, cache)[:2]
                for ps in psets[:2]:
                    case["calls"].append({"pkg": pkg, "proc": sub, "params": [str(v) if v is not None else "" for v in ps], "out": outs})
        for pr in procs:
            text = zt_case.read_src(pr, "PROCEDURE")
            edits, roles = scan_edits(pr, "PROCEDURE", text, cat, tables, cols)
            LOG("  ", pr, "(PROCEDURE) edits", len(edits), dict(roles), "— 배치: 코드 변경 목록만, 실행 비교 제외")
            case["notes"].append(f"{pr}: PROCEDURE(배치) edits {len(edits)} — 실행 비교 제외")
            case.setdefault("proc_edits", {})[pr] = edits
        for v in views:
            case["notes"].append(f"{v}: VIEW — 값 통과(인터페이스 매핑 대상)")
        for f in funcs:
            case["notes"].append(f"{f}: FUNCTION — 실행 비교 제외")
    json.dump(case, open(os.path.join(HERE, name.lower() + ".json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=list)
    LOG(name, "packages", len(case["packages"]), "calls", len(case["calls"]), "notes", len(case["notes"]))
    if "--skip-run" in a:
        return
    try:
        zt_case.deploy(case)
        zt_case.run(case)
    finally:
        if "--keep" not in a:
            zt_case.drop(case)


if __name__ == "__main__":
    main()
