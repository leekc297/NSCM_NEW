"""ZT 전후 비교 하네스 — 사내 ZIOUI1 SCM_MGR 에 테스트 복사본(ZT_ 접두사)을 만들어 원본 SP 와 결과 커서를 비교한다.

  데이터 변환 시뮬레이션 : 대상 테이블을 읽는 자리를 뷰 ZT_V_<TABLE> 로 바꾼다 (뷰 = 케이스 컬럼만 '-'→'/' 매핑, 데이터 무변경)
  코드 변경            : 케이스 JSON 의 edits = [(line, col, old, new)] 를 패키지 본문에 적용 (한 줄 안 위치 기반 치환)
  비교                 : 원본·복사본을 같은 파라미터로 호출 → OUT 커서 전부 fetch → 원본 결과의 문자열 '-' 를 '/' 로 정규화한 뒤
                        다중집합으로 비교 (행수·불일치 행·컬럼별 차이). 결과는 zt/_result/<case>.json 과 콘솔.
  정리                 : --drop 으로 ZT 객체 제거. 원본 객체·데이터는 건드리지 않는다.

사용: python zt_case.py <case.json> [--deploy] [--run] [--drop]
case.json 예:
{ "name": "SSP_ANL_SHIP_PLAN_C_5cols",
  "table": "SSP_ANL_SHIP_PLAN_C", "map_cols": ["CONFIRM_ID","FCST_TYPE","INCOTERMS","TRANSPORT_MODE","TO_SITE"],
  "packages": { "PKG_SSP0060": { "edits": [[3646, 78, "'-'", "'/'"], ...] } },
  "calls": [ { "pkg": "PKG_SSP0060", "proc": "P_SSP0060_GET_SHIPMENT_PLAN", "params": ["82","HQ00",...], "out": ["O_RC1","O_RC2"] } ] }
"""
import sys, os, re, json, time, collections, hashlib
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb
HERE = os.path.dirname(os.path.abspath(__file__)); SRC = os.path.join(HERE, "_src"); RES = os.path.join(HERE, "_result"); os.makedirs(RES, exist_ok=True)


def log(*a):
    print(time.strftime("%H:%M:%S"), *a, flush=True)


def conn():
    u, p, d = conn_info()
    c = oracledb.connect(user=u, password=p, dsn=d); c.call_timeout = 1800 * 1000
    return c


def read_src(name, ty):
    return open(os.path.join(SRC, f"{name}__{ty}.sql"), encoding="utf-8", newline="").read()   # 개행 변환 없이(CRLF 보존) — FRESH-GATE 바이트 대조용


def build_view_ddl(cur, table, map_cols):
    cur.execute("SELECT column_name FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name=:1 ORDER BY column_id", [table])
    cols = [r[0] for r in cur]
    sel = ", ".join((f"DECODE({c},'-','/',{c}) AS {c}" if c in map_cols else c) for c in cols)
    return f"CREATE OR REPLACE VIEW SCM_MGR.ZT_V_{table} AS SELECT {sel} FROM SCM_MGR.{table}", cols


def apply_edits(text, edits, name):
    lines = text.split("\n"); applied = []
    for ln, col, old, new in edits:
        raw = lines[ln - 1]
        pos = col - 1
        if raw[pos:pos + len(old)] != old:
            # 위치가 어긋나면 그 줄에서 old 의 첫 출현을 찾되, 여러 개면 중단
            if raw.count(old) == 1:
                pos = raw.index(old)
            else:
                raise SystemExit(f"[{name}] L{ln} C{col}: 기대 {old!r} 가 없음 (줄: {raw.strip()[:120]!r})")
        lines[ln - 1] = raw[:pos] + new + raw[pos + len(old):]
        applied.append((ln, col, old, new))
    return "\n".join(lines), applied


def make_copy(name, ty, text, table, pkg_names):
    tables = table if isinstance(table, list) else [table]
    zt = "ZT_" + name
    t = re.sub(r"(PACKAGE(?:\s+BODY)?\s+)(?:\"?SCM_MGR\"?\.)?\"?" + name + r"\"?", lambda m: m.group(1) + zt, text, count=1, flags=re.I)
    t = re.sub(r"\bEND\s+" + name + r"\s*;", f"END {zt};", t, flags=re.I)
    for p in pkg_names:                      # 케이스에 포함된 패키지끼리의 참조는 복사본으로
        t = re.sub(r"\b" + p + r"\.", "ZT_" + p + ".", t)
    for tb in tables:
        t = re.sub(r"\b(FROM|JOIN|INTO|UPDATE)(\s+)(?:SCM_MGR\.)?" + tb + r"\b", lambda m, tb=tb: m.group(1) + m.group(2) + "ZT_V_" + tb, t, flags=re.I)
        t = re.sub(r",(\s+)(?:SCM_MGR\.)?" + tb + r"(\s+\w+)", lambda m, tb=tb: "," + m.group(1) + "ZT_V_" + tb + m.group(2), t, flags=re.I)
    return zt, t


def fresh_gate(cur, name, ty):
    """FRESH-GATE (hook #152): 배포 직전 DB 원문(ALL_SOURCE)을 다시 읽어 로컬 기준본(zt/_src)과 바이트 단위로 같은지 assert.
    다르면 중단 — 로컬 파일을 기준본으로 쓰지 않는다. 같으면 DB 원문을 그대로 기준본으로 돌려준다."""
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:1 AND type=:2 ORDER BY line", [name, ty.replace("_", " ")])
    db_text = "".join(r[0] or "" for r in cur)
    local = read_src(name, ty)
    if db_text != local:
        stamp0 = cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:1 AND object_type=:2", [name, ty.replace("_", " ")]).fetchone()[0]
        dl, ll = db_text.splitlines(), local.splitlines()
        first = next((i for i, (x, y) in enumerate(zip(dl, ll)) if x != y), min(len(dl), len(ll)))
        log("FRESH-GATE diff:", name, ty, "DB last_ddl", stamp0, "| lines db/local", len(dl), len(ll), "| first diff line", first + 1, repr(dl[first][:80]) if first < len(dl) else "", repr(ll[first][:80]) if first < len(ll) else "")
        h1, h2 = hashlib.md5(db_text.encode("utf-8")).hexdigest()[:8], hashlib.md5(local.encode("utf-8")).hexdigest()[:8]
        raise SystemExit(f"FRESH-GATE FAIL: {name} {ty} DB 원문({h1}) != 로컬 기준본({h2}) — zt_fetch.py 로 다시 받은 뒤 edits 줄 번호를 재확인할 것")
    stamp = cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:1 AND object_type=:2", [name, ty.replace("_", " ")]).fetchone()[0]
    log("FRESH-GATE OK", name, ty, "last_ddl", stamp, "md5", hashlib.md5(db_text.encode("utf-8")).hexdigest()[:8])
    return db_text


def deploy(case):
    names = list(case["packages"])
    with conn() as c:
        cur = c.cursor()
        for name in names:                       # FRESH-GATE: 모든 대상 패키지 원문을 DB 에서 재조회해 기준본과 대조
            for ty in ("PACKAGE", "PACKAGE_BODY"):
                if os.path.exists(os.path.join(SRC, f"{name}__{ty}.sql")):
                    fresh_gate(cur, name, ty)
        tables = case.get("tables") or [case["table"]]
        for tb in tables:
            vddl, cols = build_view_ddl(cur, tb, case["map_cols"])
            cur.execute(vddl); log("view ZT_V_" + tb, len(cols), "cols; mapped", case["map_cols"])
        for name, spec in case["packages"].items():
            for ty in ("PACKAGE", "PACKAGE_BODY"):
                try:
                    text = read_src(name, ty)
                except FileNotFoundError:
                    continue
                if ty == "PACKAGE_BODY":
                    text, applied = apply_edits(text, spec.get("edits", []), name)
                    log(name, "edits applied", len(applied))
                zt, t = make_copy(name, ty, text, tables, names)
                refs = len(re.findall(r"ZT_V_", t))
                ddl = t.rstrip().rstrip("/").rstrip()
                if not re.match(r"\s*CREATE", ddl, re.I):          # ALL_SOURCE 원문은 'PACKAGE …' 로 시작 — CREATE OR REPLACE 를 붙인다
                    ddl = "CREATE OR REPLACE " + ddl.lstrip()
                log("   ddl head:", " ".join(ddl[:60].split()))
                cur.execute(ddl)
                cur.execute("SELECT status FROM all_objects WHERE owner='SCM_MGR' AND object_name=:1 AND object_type=:2", [zt, ty.replace("_", " ")])
                st = cur.fetchone()
                errs = cur.execute("SELECT line, position, text FROM all_errors WHERE owner='SCM_MGR' AND name=:1 AND type=:2 ORDER BY sequence", [zt, ty.replace("_", " ")]).fetchall()
                log(zt, ty, "status", st and st[0], "| view refs", refs, "| errors", len(errs))
                for e in errs[:8]:
                    log("   ", e)
                if errs:
                    raise SystemExit("compile error")
        c.commit()


def fetch_all(cur, pkg, proc, params, outs, nout):
    ocs = [cur.var(oracledb.CURSOR) for _ in range(nout)]
    cur.callproc(f"SCM_MGR.{pkg}.{proc}", list(params) + ocs)
    res = {}
    for nm, v in zip(outs, ocs):
        rc = v.getvalue()
        if rc is None:
            res[nm] = {"cols": [], "rows": []}; continue
        cols = [d[0] for d in rc.description]
        rows = [tuple(("" if x is None else str(x)) for x in r) for r in rc]
        res[nm] = {"cols": cols, "rows": rows}
    return res


def normalize(res):
    out = {}
    for nm, r in res.items():
        out[nm] = {"cols": r["cols"], "rows": [tuple("/" if x == "-" else x for x in row) for row in r["rows"]]}
    return out


def compare(a, b):
    """a=원본(정규화 전), b=ZT. raw 가 같으면 SAME. 다르면 원본의 '-' 를 '/' 로 바꿔 다시 비교(rename-only 판정)."""
    rep = {}
    for nm in a:
        raw_a, rb = a[nm]["rows"], b.get(nm, {"rows": []})["rows"]
        if collections.Counter(raw_a) == collections.Counter(rb):
            rep[nm] = {"rows_orig": len(raw_a), "rows_zt": len(rb), "only_orig": 0, "only_zt": 0, "same": True, "raw_same": True, "coldiff": {}, "sample_orig": [], "sample_zt": [], "cols": a[nm]["cols"]}
            continue
        ra = [tuple("/" if x == "-" else x for x in row) for row in raw_a]
        ca, cb = collections.Counter(ra), collections.Counter(rb)
        only_a = list((ca - cb).elements()); only_b = list((cb - ca).elements())
        coldiff = collections.Counter()
        if a[nm]["cols"] == b.get(nm, {}).get("cols") and only_a and only_b:
            # 행 단위로 짝을 맞춰 어느 컬럼이 다른지 집계 (키 없이 — 첫 n개 컬럼이 같은 행끼리)
            idx = collections.defaultdict(list)
            for r in only_b:
                idx[r[:3]].append(r)
            for r in only_a:
                for s in idx.get(r[:3], [])[:1]:
                    for i, (x, y) in enumerate(zip(r, s)):
                        if x != y:
                            coldiff[a[nm]["cols"][i]] += 1
        rep[nm] = {"rows_orig": len(ra), "rows_zt": len(rb), "only_orig": len(only_a), "only_zt": len(only_b),
                   "same": not only_a and not only_b, "raw_same": False, "rename_only": not only_a and not only_b, "coldiff": dict(coldiff.most_common(10)),
                   "sample_orig": only_a[:5], "sample_zt": only_b[:5], "cols": a[nm]["cols"]}
    return rep


def run(case):
    out = []
    with conn() as c:
        c.call_timeout = int(case.get("call_timeout_sec", 300)) * 1000      # 호출 1건 상한 — 초과/오류는 기록하고 다음으로
        cur = c.cursor()
        for call in case["calls"]:
            nout = len(call["out"])
            try:
                _run_one(cur, call, nout, out)
            except Exception as e:
                msg = str(e).split("\n")[0][:160]
                log(call["proc"], call["params"][:4], "| 실행 실패:", msg)
                out.append({"call": call, "error": msg, "sec_orig": "", "sec_zt": "", "dash_cells_orig": {}, "slash_cells_zt": {}, "compare": {}})
                try:
                    c.rollback()
                except Exception:
                    pass
    json.dump(out, open(os.path.join(RES, case["name"] + ".json"), "w", encoding="utf-8"), ensure_ascii=False, indent=1, default=str)
    return out


def _run_one(cur, call, nout, out):
    if True:
        if True:
            if call.get("zt_first"):          # 캐시 영향 확인용 — 복사본을 먼저 호출
                t0 = time.time(); zt = fetch_all(cur, "ZT_" + call["pkg"], call["proc"], call["params"], call["out"], nout); tz = time.time()
                orig = fetch_all(cur, call["pkg"], call["proc"], call["params"], call["out"], nout); to = time.time()
                t1 = t0 + (to - tz); t2 = t1 + (tz - t0)
            else:
                t0 = time.time(); orig = fetch_all(cur, call["pkg"], call["proc"], call["params"], call["out"], nout); t1 = time.time()
                zt = fetch_all(cur, "ZT_" + call["pkg"], call["proc"], call["params"], call["out"], nout); t2 = time.time()
            rep = compare(orig, zt)
            dash_in_orig = {nm: sum(1 for r in orig[nm]["rows"] for x in r if x == "-") for nm in orig}
            slash_in_zt = {nm: sum(1 for r in zt[nm]["rows"] for x in r if x == "/") for nm in zt}
            item = {"call": call, "sec_orig": round(t1 - t0, 1), "sec_zt": round(t2 - t1, 1), "dash_cells_orig": dash_in_orig, "slash_cells_zt": slash_in_zt, "compare": rep}
            out.append(item)
            log(call["proc"], call["params"][:4], "| orig %.1fs zt %.1fs" % (t1 - t0, t2 - t1))
            for nm, r in rep.items():
                log("   ", nm, "rows", r["rows_orig"], "/", r["rows_zt"], "| RAW SAME(출력 동일)" if r.get("raw_same") else ("| RENAME-ONLY('-'→'/' 치환으로만 설명됨)" if r.get("rename_only") else f"| DIFF only_orig {r['only_orig']} only_zt {r['only_zt']} cols {r['coldiff']}"),
                    "| '-' cells orig", dash_in_orig[nm], "'/' cells zt", slash_in_zt[nm])
                if not r["same"]:
                    for s in r["sample_orig"][:2]:
                        log("      orig:", s[:12])
                    for s in r["sample_zt"][:2]:
                        log("      zt  :", s[:12])


def drop(case):
    with conn() as c:
        cur = c.cursor()
        for name in case["packages"]:
            try:
                cur.execute(f"DROP PACKAGE SCM_MGR.ZT_{name}"); log("dropped ZT_" + name)
            except Exception as e:
                log("drop skip", name, str(e)[:80])
        for tb in (case.get("tables") or [case["table"]]):
            try:
                cur.execute(f"DROP VIEW SCM_MGR.ZT_V_{tb}"); log("dropped view ZT_V_" + tb)
            except Exception as e:
                log("drop view skip", tb, str(e)[:80])


if __name__ == "__main__":
    case = json.load(open(sys.argv[1], encoding="utf-8"))
    if "--deploy" in sys.argv:
        deploy(case)
    if "--run" in sys.argv:
        run(case)
    if "--drop" in sys.argv:
        drop(case)
