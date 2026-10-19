"""NULL 센티널 '-' → '/' 전환 — 기준 파일 기반 대상/제외 판정 + TO-BE 적용대상 취합 (읽기 전용 · SELECT 만)

모집단 : C:\\TRANFILE\\RECEIVE\\20260820_NOTNULL컬럼_DEFAULT처리(품질DB전체).xlsx  시트 '처리대상이력'
제외   : AS-IS 에서 그 TABLE.COLUMN 의 '-' 에 대한 분기문(IF / CASE 등)이 확정된 경우만 (사용자 확정 2026-10-06)
AS-IS  : MSSQL SP/VIEW/FUNCTION/TRIGGER (LGCE_SCMDEV · LGCE_FPDEV) + FoxQuery XML 인라인 SQL + C# 소스
TO-BE  : 사내 ZIOUI1 SCM_MGR · FP_MGR 의 PACKAGE(BODY)/PROCEDURE/FUNCTION/TRIGGER/TYPE BODY/VIEW

사용:
  python build_slash_target.py all                # 전 단계 (캐시 있으면 재사용)
  python build_slash_target.py all --refresh X    # X 단계 캐시 무시 (pop|tobe_cat|asis_meta|asis_mods|tobe_src|cs|xml)
  python build_slash_target.py xlsx --judgment F  # F(이전 산출 xlsx)의 '사용자 판정' 을 반영해 재생성
"""
import sys, os, re, json, time, html, glob, collections

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\DASH_SENTINEL_INVENTORY_20261001")
from sqlscan import Scanner
import extract_dash_inventory as old          # ora() / asis() / stage_asis_modules / stage_src_fetch / subprogram_map / MIGRATION_MARKERS

CACHE = os.path.join(HERE, "_cache"); os.makedirs(CACHE, exist_ok=True)
SRC_XLSX = glob.glob(r"C:\TRANFILE\RECEIVE\20260820_NOTNULL*.xlsx")
OUT_XLSX = os.path.join(HERE, "NULL센티널_슬래시전환_작업대상_20261007.xlsx")
GSCM = r"C:\Projects\NSCM\GSCM"
OLD_CACHE = os.path.join(os.path.dirname(old.__file__), "_cache")
ASIS_DBS = ("LGCE_SCMDEV", "LGCE_FPDEV")
ILLEGAL = re.compile(r"[\x00-\x08\x0b\x0c\x0e-\x1f]")


POP_EXTRA = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "SLASH_SENTINEL_DMLRISK_20261007", "_pop_extra.json")


def log(*a):
    print(time.strftime("%H:%M:%S"), *a, flush=True)


def cpath(n):
    return os.path.join(CACHE, n + ".json")


def cached(name, fn, refresh):
    p = cpath(name)
    if os.path.exists(p) and name not in refresh:
        return json.load(open(p, encoding="utf-8"))
    d = fn()
    json.dump(d, open(p, "w", encoding="utf-8"), ensure_ascii=False)
    return d


# ------------------------------------------------------------------------------------------------------------
# 1. 모집단
# ------------------------------------------------------------------------------------------------------------
def stage_pop():
    from openpyxl import load_workbook
    wb = load_workbook(SRC_XLSX[0], read_only=True, data_only=True)
    rows = []
    for r in wb["처리대상이력"].iter_rows(min_row=2, values_only=True):
        if r[0]:
            rows.append({"owner": r[0], "table": r[1].upper(), "column": r[2].upper(), "col_id": r[3], "dtype": r[4], "nullable": r[5],
                         "file_default": r[6], "file_ddl": r[7]})
    # 2026-10-07 사용자 지시(범위 확대): 기준 파일 '정제전' 에 있고 사내 DB 에 DEFAULT '-' 가 설정돼 있는데 '처리대상이력' 에서 빠진 컬럼 일괄 추가
    #   추가분 = SLASH_SENTINEL_DMLRISK_20261007/_pop_extra.json (s7_pop_extra.py 생성 · 115컬럼/27테이블 — SCM_MST_FUTURE_PRICE·DM_PLN_SALES_PLAN 등)
    extra_n = 0
    if os.path.exists(POP_EXTRA):
        have = {(r["table"], r["column"]) for r in rows}
        for e in json.load(open(POP_EXTRA, encoding="utf-8"))["rows"]:
            if (e["table"].upper(), e["column"].upper()) not in have:
                rows.append({"owner": e["owner"], "table": e["table"].upper(), "column": e["column"].upper(), "col_id": e["col_id"], "dtype": e["dtype"],
                             "nullable": e["nullable"], "file_default": e["file_default"], "file_ddl": e["file_ddl"], "extra": e.get("added", "추가분")})
                extra_n += 1
    log("pop rows", len(rows), "(추가분 %d)" % extra_n)
    return {"rows": rows, "file": SRC_XLSX[0], "mtime": time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(os.path.getmtime(SRC_XLSX[0]))), "extra": extra_n}


def stage_tobe_cat():
    out = {"tables": {}, "views": {}}
    with old.ora() as c:
        cur = c.cursor()
        cur.execute("""SELECT c.owner, c.table_name, c.column_name, c.column_id, c.data_type, c.data_length, c.nullable, c.default_on_null,
                              TRIM(c.data_default_vc), NVL(t.temporary,'V')
                         FROM all_tab_columns c LEFT JOIN all_tables t ON t.owner = c.owner AND t.table_name = c.table_name
                        WHERE c.owner IN ('SCM_MGR','FP_MGR') AND c.table_name NOT LIKE 'BIN$%'
                        ORDER BY c.owner, c.table_name, c.column_id""")
        for ow, tb, cn, cid, dt, dl, nu, on, df, tmp in cur:
            d = out["tables"].setdefault(ow + "|" + tb, {"kind": {"Y": "gtt", "N": "real", "V": "view"}[tmp], "cols": {}, "order": []})
            d["cols"][cn] = {"dtype": dt, "dlen": dl, "nullable": nu, "on_null": on, "default": df}
            d["order"].append(cn)
        out["fetched"], out["service"] = cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'), SYS_CONTEXT('USERENV','SERVICE_NAME') FROM dual").fetchone()
    log("tobe catalog objects", len(out["tables"]))
    return out


def stage_asis_meta():
    out = {"tables": {}, "defaults": [], "fetched": None}
    with old.asis() as c:
        cur = c.cursor()
        out["fetched"] = str(cur.execute("SELECT SYSDATETIME()").fetchone()[0])[:19]
        for db in ASIS_DBS:
            cur.execute(f"""SELECT t.name, col.name, col.column_id, ty.name
                              FROM {db}.sys.tables t JOIN {db}.sys.columns col ON col.object_id = t.object_id
                              JOIN {db}.sys.types ty ON ty.user_type_id = col.user_type_id ORDER BY t.name, col.column_id""")
            for tb, cn, cid, ty in cur.fetchall():
                d = out["tables"].setdefault(db + "|" + tb.upper(), {"order": [], "types": {}})
                d["order"].append(cn.upper()); d["types"][cn.upper()] = ty
            cur.execute(f"""SELECT t.name, col.name, dc.definition FROM {db}.sys.default_constraints dc
                              JOIN {db}.sys.tables t ON t.object_id = dc.parent_object_id
                              JOIN {db}.sys.columns col ON col.object_id = dc.parent_object_id AND col.column_id = dc.parent_column_id""")
            for tb, cn, df in cur.fetchall():
                if re.sub(r"[()\s]", "", df or "") in ("'-'", "N'-'"):
                    out["defaults"].append([db, tb.upper(), cn.upper()])
    log("asis tables", len(out["tables"]), "default '-'", len(out["defaults"]))
    return out


def norm_default(d):
    x = (d or "").strip()
    while x.startswith("(") and x.endswith(")"):
        x = x[1:-1].strip()
    return x


def stage_asis_defaults_all():
    """AS-IS 컬럼 DEFAULT 제약 전체(값 포함). 접속 불가 시 10-01 수집분으로 대체하고 명시."""
    try:
        rows = []
        with old.asis() as c:
            cur = c.cursor()
            stamp = str(cur.execute("SELECT SYSDATETIME()").fetchone()[0])[:19]
            for db in ASIS_DBS:
                cur.execute(f"""SELECT t.name, col.name, dc.definition FROM {db}.sys.default_constraints dc
                                  JOIN {db}.sys.tables t ON t.object_id = dc.parent_object_id
                                  JOIN {db}.sys.columns col ON col.object_id = dc.parent_object_id AND col.column_id = dc.parent_column_id""")
                rows += [[db, tb.upper(), cn.upper(), df] for tb, cn, df in cur.fetchall()]
        return {"rows": rows, "fetched": stamp, "source": "DB 직접 조회"}
    except Exception as e:
        log("AS-IS 접속 실패 → 10-01 수집분 사용:", str(e)[:120])
        o = json.load(open(os.path.join(OLD_CACHE, "asis_meta.json"), encoding="utf-8"))
        return {"rows": [[d["db"], d["table"], d["column"], d["definition"]] for d in o["defaults"]], "fetched": str(o["fetched"])[:19],
                "source": "2026-10-01 수집분 (오늘 AS-IS 접속 실패)"}


def stage_tobe_objs():
    """TO-BE 객체 전체(패키지 서브프로그램 포함) — AS-IS 동치 지점의 TO-BE 대응 찾기용."""
    with old.ora() as c:
        cur = c.cursor()
        cur.execute("""SELECT owner, object_name, NVL(procedure_name, object_name) FROM all_procedures
                        WHERE owner IN ('SCM_MGR','FP_MGR') AND object_type IN ('PACKAGE','PROCEDURE','FUNCTION') AND object_name NOT LIKE 'BIN$%'
                       UNION SELECT owner, view_name, view_name FROM all_views WHERE owner IN ('SCM_MGR','FP_MGR')""")
        rows = [list(r) for r in cur]
    log("tobe objects", len(rows))
    return rows


def stage_asis_mods():
    try:
        mods = old.stage_asis_modules()
        return {"mods": mods, "fetched": time.strftime("%Y-%m-%d %H:%M:%S"), "source": "DB 직접 조회"}
    except Exception as e:            # 접속 불가 — 10-01 캐시로 진행하고 명시
        log("AS-IS 접속 실패 → 10-01 캐시 사용:", str(e)[:200])
        mods = json.load(open(os.path.join(OLD_CACHE, "asis_modules.json"), encoding="utf-8"))
        return {"mods": mods, "fetched": "2026-10-01 15:19 (캐시)", "source": "10-01 캐시 (AS-IS 접속 실패: %s)" % str(e)[:120]}


# ------------------------------------------------------------------------------------------------------------
# 2. AS-IS 스캔
# ------------------------------------------------------------------------------------------------------------
def asis_scanners(pop_tabs, meta, views_by_db):
    """DB 별 Scanner — 자기 DB 테이블 우선, 타 DB 는 'DB::T' 키."""
    res = {}
    names = {db: {k.split("|")[1] for k in meta["tables"] if k.startswith(db + "|")} for db in ASIS_DBS}
    for db in ASIS_DBS:
        other = [d for d in ASIS_DBS if d != db][0]
        cat = {}
        for k, v in meta["tables"].items():
            d, tb = k.split("|")
            ent = {"kind": "real", "cols": set(v["order"]), "order": v["order"]}
            if d == db:
                cat[tb] = ent
            else:
                cat[d + "::" + tb] = ent
        pop = {}
        for tb, cols in pop_tabs.items():
            home = "LGCE_SCMDEV" if tb in names["LGCE_SCMDEV"] else ("LGCE_FPDEV" if tb in names["LGCE_FPDEV"] else None)
            if home is None:
                continue
            pop[tb if home == db else home + "::" + tb] = cols
        res[db] = Scanner(cat, pop, views=views_by_db.get(db, ()), dialect="tsql", qual=(set(ASIS_DBS), db))
    return res, names


def strip_q(x):
    return [(t.split("::")[-1], c, tier) for t, c, tier in x]


def snippet(lines, ln, span=1):
    a = max(0, ln - 1 - span); b = min(len(lines), ln + span)
    return ILLEGAL.sub(" ", " ⏎ ".join(("▶ " if i == ln - 1 else "") + lines[i].strip()[:260] for i in range(a, b) if lines[i].strip()))[:520]


def ev_class(r):
    role = r["role"]
    if role == "BRANCH":
        return "A_NULLCHK" if r["nullchk"] else "A"
    if role == "PREDICATE":
        return "B_NULLCHK" if r["nullchk"] else "B"
    if role == "NVL_CMP":
        if r["nullchk"]:
            return "A_NULLCHK" if r.get("gov") in ("WHEN", "IF", "ELSIF", "WHILE", "IIF", "DECODE") else "B_NULLCHK"
        return "C"
    if role == "NVL":
        return "C"
    if role in ("CASE_VALUE", "LOAD", "ASSIGN", "DEFAULT"):
        return "D"
    return None


def scan_asis_db(mods, scanners):
    ev = []; stat = collections.Counter(); fails = []
    for m in mods:
        df = m["definition"]
        if "'-'" not in df:
            continue
        stat["modules_with_dash"] += 1
        try:
            occ, _ = scanners[m["db"]].scan(df)
        except Exception as e:
            fails.append([m["db"], m["name"], str(e)[:200]]); continue
        lines = df.split("\n")
        for r in occ:
            stat["occ"] += 1; stat["role:" + r["role"]] += 1
            cls = ev_class(r)
            if cls is None:
                continue
            ev.append({"src": "DB", "loc": m["db"], "object": m["name"], "otype": m["type"].replace("SQL_", ""), "line": r["line"], "cls": cls,
                       "role": r["role"], "detail": r["detail"][:200], "dynamic": r["dynamic"], "refs": strip_q(r["refs"]), "dest": strip_q(r["dest"]),
                       "notes": "; ".join(r["notes"])[:200], "snip": snippet(lines, r["line"])})
    log("asis DB occurrences", stat["occ"], "evidence", len(ev), "fail", len(fails))
    return {"ev": ev, "stat": dict(stat), "fails": fails}


def walk(root, exts, skip=("bin", "obj", ".vs", "packages", ".git", "node_modules", "00.Assemblies")):
    for dp, dn, fn in os.walk(root):
        dn[:] = [d for d in dn if d not in skip]
        for f in fn:
            if f.lower().endswith(exts):
                yield os.path.join(dp, f)


def read_text(p):
    b = open(p, "rb").read()
    for enc in ("utf-8-sig", "cp949", "utf-16"):
        try:
            return b.decode(enc)
        except Exception:
            pass
    return b.decode("utf-8", "replace")


def stage_xml_raw():
    """FoxQuery 등 XML 안의 인라인 SQL — '-' 가 든 파일 원문 수집."""
    files = []
    n = 0
    for p in walk(GSCM, (".xml", ".foxml", ".sql")):
        n += 1
        try:
            t = read_text(p)
        except Exception:
            continue
        if "'-'" in t:
            files.append({"path": os.path.relpath(p, GSCM), "text": t})
    log("xml/sql files scanned", n, "with '-'", len(files))
    return {"files": files, "scanned": n}


def scan_asis_xml(xmlraw, scanners):
    ev = []; stat = collections.Counter(); fails = []
    for f in xmlraw["files"]:
        text = f["text"]
        db = "LGCE_FPDEV" if re.search(r"[\\/]FP[\\/]", f["path"]) else "LGCE_SCMDEV"
        is_xml = f["path"].lower().endswith((".xml", ".foxml"))
        chunks = []
        if is_xml:
            # 태그 사이 텍스트(및 CDATA)를 SQL 로 취급. 직전 여는 태그의 id/name 을 쿼리명으로.
            pos = 0; last_id = ""
            for m in re.finditer(r"<!\[CDATA\[(.*?)\]\]>|<[^>]+>", text, re.S):
                if m.start() > pos:
                    chunks.append((pos, text[pos:m.start()], last_id, True))
                if m.group(1) is not None:
                    chunks.append((m.start(1), m.group(1), last_id, False))
                else:
                    mm = re.search(r"\b(?:id|name|key)\s*=\s*\"([^\"]+)\"", m.group(0), re.I)
                    if mm:
                        last_id = mm.group(1)
                pos = m.end()
            if pos < len(text):
                chunks.append((pos, text[pos:], last_id, True))
        else:
            chunks.append((0, text, "", False))
        for off, body, qid, unesc in chunks:
            if "'-'" not in body:
                continue
            sql = html.unescape(body) if unesc else body
            base = text.count("\n", 0, off)
            try:
                occ, _ = scanners[db].scan(sql)
            except Exception as e:
                fails.append([f["path"], qid, str(e)[:200]]); continue
            lines = sql.split("\n")
            for r in occ:
                stat["occ"] += 1
                cls = ev_class(r)
                if cls is None:
                    continue
                ev.append({"src": "XML", "loc": f["path"], "object": qid or os.path.basename(f["path"]), "otype": "FoxQuery" if is_xml else "SQL파일",
                           "line": base + r["line"], "cls": cls, "role": r["role"], "detail": r["detail"][:200], "dynamic": r["dynamic"],
                           "refs": strip_q(r["refs"]), "dest": strip_q(r["dest"]), "notes": "; ".join(r["notes"])[:200], "snip": snippet(lines, r["line"])})
    log("asis XML occurrences", stat["occ"], "evidence", len(ev), "fail", len(fails))
    return {"ev": ev, "stat": dict(stat), "fails": fails}


CS_RX = re.compile(r"""(==|!=)\s*"-"|"-"\s*(==|!=)|\.Equals\(\s*"-"\s*\)|"-"\.Equals\(|case\s+"-"\s*:|\.CompareTo\(\s*"-"\s*\)|\.StartsWith\(\s*"-"\s*\)""")
CS_BRANCH = re.compile(r"\b(if|else\s+if|while|switch|case)\b|\?|&&|\|\|")


def stage_cs(colnames):
    """C# — "-" 비교가 든 줄과 인접 줄의 컬럼명 문자열."""
    colnames = set(colnames)
    rows = []; n = 0; hit_files = 0
    for p in walk(GSCM, (".cs",)):
        n += 1
        try:
            t = read_text(p)
        except Exception:
            continue
        if '"-"' not in t:
            continue
        lines = t.split("\n"); fh = False
        for i, ln in enumerate(lines):
            code = ln.split("//")[0] if not ln.strip().startswith("//") else ""
            if not CS_RX.search(code):
                continue
            fh = True
            same = sorted({s for s in re.findall(r"\"([A-Za-z][A-Za-z0-9_]+)\"", code) if s.upper() in colnames} |
                          {s for s in re.findall(r"\b([A-Z][A-Z0-9_]{2,})\b", code) if s in colnames})
            win = lines[max(0, i - 3):i + 4]
            near = sorted({s for l in win for s in re.findall(r"\"([A-Za-z][A-Za-z0-9_]+)\"", l) if s.upper() in colnames} - set(same))
            rel = os.path.relpath(p, GSCM)
            sid = re.findall(r"\b([A-Z]{3}\d{4}(?:_\d+)?)", rel)
            rows.append({"path": rel, "screen": sid[-1] if sid else "", "line": i + 1, "branch": bool(CS_BRANCH.search(code)),
                         "same": [s.upper() for s in same], "near": [s.upper() for s in near],
                         "snip": ILLEGAL.sub(" ", " ⏎ ".join(l.strip() for l in lines[max(0, i - 1):i + 2] if l.strip()))[:420]})
        hit_files += fh
    log("cs files", n, "with compare", hit_files, "rows", len(rows))
    return {"rows": rows, "scanned": n, "hit_files": hit_files}


# ------------------------------------------------------------------------------------------------------------
# 3. 컬럼 판정
# ------------------------------------------------------------------------------------------------------------
TIER_ORDER = {"확정": 0, "추정": 1, "간접": 2, "변수": 3}


FORCE_TARGET = {("SCM_MST_SSO_USER_INFO", "USER_ID"): "'-' 는 서브쿼리 안 PROJECT_CODE 의 비교",
                ("SCP_ANL_PROBLEM_REPORT_PEGGING", "PEGGING_OPERATION_CODE"): "뷰 SCP_PLN_PEGGING_INFO_V 의 필터",
                ("SCP_MST_SHIPMENT_LOT_SIZE", "TO_SITE"): "다른 테이블 임시 복사본의 TO_SITE"}
NAME_EXCL = {"CELL_PROD_SITE_ID", "BOD_ID", "TO_SITE", "FROM_SITE", "LINE_ID", "INCOTERMS", "FCST_TYPE"}


def op_cols(notes):
    """근거의 비고에서 (피연산자 컬럼명, 미연결 사유) 추출."""
    out = []
    for part in notes.split("; "):
        m = re.match(r"(?:[\w#@\[\]]+\.)?([A-Za-z_]\w*): (.*)", part)
        if m and not part.startswith("@"):
            out.append((m.group(1).upper(), m.group(2)))
    return out


def judge_columns(pop, cat, meta, asis_names, ev_all, cs, user_j=None, adef=None):
    adef_map = {(r[0], r[1], r[2]): norm_default(r[3]) for r in (adef or {}).get("rows", [])}
    popset = {(r["table"], r["column"]) for r in pop["rows"]}
    per = collections.defaultdict(lambda: collections.Counter())
    samples = collections.defaultdict(list)
    simple = collections.defaultdict(lambda: collections.Counter())
    for e in ev_all:
        cls = e["cls"]
        if cls in ("C", "D"):
            targets = e["refs"] + e["dest"] if cls == "C" else e["dest"]
            for tb, c, tier in {tuple(x) for x in targets}:
                if (tb, c) in popset and tier == "확정":
                    simple[(tb, c)][cls] += 1
            continue
        for tb, c, tier in {tuple(x) for x in e["refs"]}:
            if (tb, c) not in popset:
                continue
            key = cls + "|" + tier + ("|동적" if e["dynamic"] else "")
            per[(tb, c)][key] += 1
            if e["src"] == "DB" and tier == "확정":
                per[(tb, c)]["DBFIX|" + cls] += 1          # AS-IS DB 객체 · 테이블까지 확정된 비교/분기 (동적 SQL 포함)
            samples[(tb, c)].append((0 if cls == "A" else 1 if cls == "A_NULLCHK" else 2, TIER_ORDER[tier], 1 if e["dynamic"] else 0, e))
    unlinked = collections.Counter()        # 컬럼명 → 분기문인데 모집단 테이블로 이어지지 않은 건수(모집단 밖 실테이블로 확정된 것은 제외)
    for e in ev_all:
        if e["cls"] in ("A", "A_NULLCHK") and not [x for x in e["refs"] if (x[0], x[1]) in popset]:
            for nm, why in op_cols(e["notes"]):
                if not why.startswith("모집단 밖"):
                    unlinked[nm] += 1
    cs_by_col = collections.defaultdict(list)
    for r in cs["rows"]:
        for c in r["same"]:
            cs_by_col[c].append(("same", r))
        for c in r["near"]:
            cs_by_col[c].append(("near", r))
    asis_def = {(tb, c) for db, tb, c in meta["defaults"]}
    try:
        adata = json.load(open(os.path.join(OLD_CACHE, "asis_data_partial.json"), encoding="utf-8"))
    except Exception:
        adata = {}
    out = []
    for r in pop["rows"]:
        tb, c = r["table"], r["column"]
        cur = cat["tables"].get("SCM_MGR|" + tb, {}).get("cols", {}).get(c)
        if cur is None:
            state = "현재 DB 에 컬럼 없음"
        elif cur["default"] == "'-'":
            state = "DEFAULT '-'" + (" ON NULL" if cur["on_null"] == "YES" else " (ON NULL 아님)")
        else:
            state = "DEFAULT 변경됨: " + str(cur["default"])
        home = "LGCE_SCMDEV" if tb in asis_names["LGCE_SCMDEV"] else ("LGCE_FPDEV" if tb in asis_names["LGCE_FPDEV"] else "")
        asis_has_col = bool(home) and c in meta["tables"][home + "|" + tb]["types"]
        k = per[(tb, c)]
        a_fix = k["A|확정"]
        a_other = sum(v for kk, v in k.items() if kk.startswith("A|") and kk != "A|확정")
        a_null = sum(v for kk, v in k.items() if kk.startswith("A_NULLCHK"))
        b_fix = k["B|확정"]
        b_other = sum(v for kk, v in k.items() if kk.startswith("B|") and kk != "B|확정")
        b_null = sum(v for kk, v in k.items() if kk.startswith("B_NULLCHK"))
        csr = cs_by_col.get(c, [])
        cs_same = sum(1 for w, x in csr if w == "same" and x["branch"]); cs_near = sum(1 for w, x in csr if w == "near" and x["branch"])
        reasons = []
        # 2026-10-06 사용자 확정(2차): AS-IS DB 객체에 그 TABLE.COLUMN 의 '-' 비교 또는 분기가 있으면 제외
        db_a = k["DBFIX|A"]; db_b = k["DBFIX|B"]; db_an = k["DBFIX|A_NULLCHK"]; db_bn = k["DBFIX|B_NULLCHK"]
        if db_a or db_b or db_an or db_bn:
            verdict = "제외"
            reasons.append("AS-IS DB 객체 확정 근거 — " + " · ".join(x for x in [
                f"분기문 {db_a}건" if db_a else "", f"조건절 비교 {db_b}건" if db_b else "",
                f"분기문(NULL검사 겸용) {db_an}건" if db_an else "", f"조건절(NULL검사 겸용) {db_bn}건" if db_bn else ""] if x))
        elif cs_same:
            # 2026-10-06 사용자 확정(3차): C# 화면 소스의 "-" 분기 줄에 컬럼명이 있는 5개 컬럼명은 테이블과 무관하게 제외
            verdict = "제외"
        elif a_fix:
            verdict = "검토필요"; reasons.append(f"분기문 확정 {a_fix}건(DB 객체 아님 — FoxQuery XML)")
        elif a_other or a_null or b_fix or b_other or b_null:
            verdict = "검토필요"
        elif False:
            verdict = "검토필요(C#만)"
        else:
            verdict = "대상"
        loose = sum(v for kk, v in k.items() if not kk.startswith("DBFIX|") and "|확정" not in kk)
        if loose: reasons.append(f"테이블 미확정 근거(추정·간접·변수) {loose}건")
        xml_fix = (a_fix + b_fix + sum(v for kk, v in k.items() if kk.startswith(("A_NULLCHK|확정", "B_NULLCHK|확정")))) - (db_a + db_b + db_an + db_bn)
        if xml_fix > 0 and verdict == "제외": reasons.append(f"FoxQuery XML 확정 {xml_fix}건")
        if cs_same: reasons.append(f"C# 분기 컬럼명 기준 제외(사용자 확정 · 테이블 미특정) {cs_same}건")
        if cs_near: reasons.append(f"(참고) C# 분기 인접 줄에 컬럼명 {cs_near}건")
        # 2026-10-06 사용자 확정(4차) — 잔여 검토필요 37건 처리
        if (tb, c) in FORCE_TARGET:
            verdict = "대상"; reasons.insert(0, "사용자 확정 대상(근거가 이 컬럼과 무관: " + FORCE_TARGET[(tb, c)] + ")")
        elif c in NAME_EXCL and verdict != "제외":
            reasons.insert(0, "컬럼명 단위 제외(사용자 확정 — AS-IS DB 객체에서 이 컬럼명의 '-' 가 값으로 쓰임" + (", 이 테이블은 직접 근거 없음" if verdict == "대상" else "") + ")")
            verdict = "제외"
        elif verdict == "검토필요":
            verdict = "제외"; reasons.insert(0, "사용자 확정 제외(테이블 미확정 근거)")
        if not home:
            reasons.append("AS-IS 대응 테이블 없음")
        elif not asis_has_col:
            reasons.append("AS-IS 테이블에 해당 컬럼 없음")
        if verdict == "대상" and not [x for x in reasons if not x.startswith(("(참고)", "AS-IS 대응", "AS-IS 테이블에"))]:
            reasons.append("분기·조건절 근거 없음")
        ss = sorted(samples[(tb, c)], key=lambda x: x[:3])
        seen = set(); sm = []
        for _, _, _, e in ss:
            key = (e["object"], e["line"])
            if key in seen:
                continue
            seen.add(key); sm.append(f"[{e['object']} L{e['line']}] {e['snip']}")
            if len(sm) == 3:
                break
        ad = adata.get((home or "") + "|" + tb, {})
        adash = ad.get("cols", {}).get(c, {}).get("dash", "") if ad and not ad.get("error") else ""
        out.append({"owner": r["owner"], "table": tb, "column": c, "dtype": r["dtype"], "state": state, "asis_db": home,
                    "asis_col": "Y" if asis_has_col else ("" if home else ""), "a_fix": a_fix, "a_other": a_other, "a_null": a_null,
                    "b_fix": b_fix, "b_other": b_other, "b_null": b_null, "cs_same": cs_same, "cs_near": cs_near,
                    "c_cnt": simple[(tb, c)]["C"], "d_cnt": simple[(tb, c)]["D"], "auto": verdict, "why": " / ".join(reasons),
                    "samples": sm + [""] * (3 - len(sm)), "asis_default": "Y" if (tb, c) in asis_def else "", "asis_dash": adash,
                    "cur_default": cur["default"] if cur else "", "cur_on_null": cur["on_null"] if cur else "", "nullable_now": cur["nullable"] if cur else "", "unlinked": unlinked.get(c, 0),
                    # 2026-10-07 사용자 확정(6차): AS-IS 에 DEFAULT 가 있던 컬럼은 그 값 유지, 없던 컬럼만 '/'
                    "asis_default_val": adef_map.get((home, tb, c), "") if home else "",
                    "apply_default": (cur["default"] if (cur and cur["default"] not in (None, "", "NULL", "'-'"))
                                      else ((adef_map.get((home, tb, c)) or "'/'") if home else "'/'"))})
    # 동일 컬럼명 타 테이블 제외 수
    exc_by_name = collections.Counter(o["column"] for o in out if o["auto"] == "제외")
    for o in out:
        o["same_name_excl"] = exc_by_name[o["column"]] - (1 if o["auto"] == "제외" else 0)
        uj = (user_j or {}).get((o["table"], o["column"]))
        o["user"] = uj or ""
        o["final"] = "대상"          # 2026-10-06 사용자 확정(5차): 전 컬럼이 NOT NULL 이므로 빈값 대체는 모두 '/' — DEFAULT 는 전부 '/' 적용
    return out


# ------------------------------------------------------------------------------------------------------------
# 4. TO-BE 소스 스캔
# ------------------------------------------------------------------------------------------------------------
def stage_tobe_scan(src, cat, pop_tabs):
    scm = {}; fp = {}
    for k, v in cat["tables"].items():
        ow, tb = k.split("|")
        ent = {"kind": v["kind"], "cols": set(v["order"]), "order": v["order"]}
        (scm if ow == "SCM_MGR" else fp)[tb] = ent
    cat_scm = dict(fp); cat_scm.update(scm)
    cat_fp = dict(scm); cat_fp.update(fp)
    pop_fp = {t: c for t, c in pop_tabs.items() if t not in fp}
    views = {t for t, v in cat_scm.items() if v["kind"] == "view"}
    sc = {"SCM_MGR": Scanner(cat_scm, pop_tabs, views, "plsql"), "FP_MGR": Scanner(cat_fp, pop_fp, views, "plsql")}
    rows = []; stat = collections.Counter(); fails = []
    for key, lines in src["objs"].items():
        ow, ty, nm = key.split("|")
        text = "".join(lines)
        subs = old.subprogram_map(lines)
        starts = [0]
        for l in lines:
            starts.append(starts[-1] + len(l))
        try:
            occ, comments = sc[ow].scan(text)
        except Exception as e:
            fails.append([key, str(e)[:200]]); continue
        stat["comment_dash"] += sum(c.count("'-'") for _, c in comments)
        for r in occ:
            ln = r["line"]; raw = lines[ln - 1].rstrip("\n") if ln - 1 < len(lines) else ""
            changed = ""; col = None
            if r.get("pos") is not None and r.get("len"):
                col = r["pos"] - starts[ln - 1]
                seg = raw[col:col + r["len"]]
                if "-" in seg and col >= 0:
                    changed = raw[:col] + seg.replace("-", "/") + raw[col + r["len"]:]
            rows.append({"owner": ow, "type": ty, "name": nm, "sub": subs[ln - 1] if ln - 1 < len(subs) else "", "line": ln,
                         "text": ILLEGAL.sub(" ", raw.strip())[:500], "changed": ILLEGAL.sub(" ", changed.strip())[:500], "role": r["role"],
                         "detail": r["detail"][:200], "dynamic": r["dynamic"], "nullchk": r["nullchk"], "refs": r["refs"], "dest": r["dest"],
                         "notes": "; ".join(r["notes"])[:300], "alias": r.get("alias", ""), "markers": old.markers(raw),
                         "colpos": (col + 1) if col is not None and col >= 0 else "", "raw": raw.strip(), "lead": len(raw) - len(raw.lstrip())})
            stat["occ"] += 1; stat["role:" + r["role"]] += 1
    log("tobe occurrences", stat["occ"], "fail", len(fails))
    return {"rows": rows, "stat": dict(stat), "fails": fails}


def place_tobe(trows, cols):
    final = {(c["table"], c["column"]): c["final"] for c in cols}
    meaning = {(c["table"], c["column"]) for c in cols if c["auto"] == "제외"}
    sheets = collections.defaultdict(list)
    for r in trows:
        if r["role"] == "NON_SENTINEL":
            sheets["nonsent"].append(r); continue
        cands = {tuple(x) for x in r["refs"]} | {tuple(x) for x in r["dest"]}
        fixed = sorted({(t, c) for t, c, tier in cands if tier == "확정" and (t, c) in final})
        loose = sorted({(t, c, tier) for t, c, tier in cands if tier != "확정" and (t, c) in final})
        r["fixed"] = fixed; r["loose"] = loose
        if fixed:
            mean = [x for x in fixed if x in meaning]
            r["col_verdicts"] = ", ".join(f"{t}.{c}" + ("('-' 의미 사용)" if (t, c) in meaning else "") for t, c in fixed)
            if r["role"] in ("NVL", "NVL_CMP") and not r["nullchk"]:
                r["advice"] = "빈값 대체 → '/' 로 변경" + (" (이 컬럼은 '-' 를 값으로도 쓰므로 넘어온 '-' 는 그대로 둔다)" if mean else "")
                sheets["nvl"].append(r)
            else:
                if r["nullchk"]:
                    r["advice"] = "NULL검사 겸용 비교 — '/' 로 바꿀지, '-' 값도 함께 볼지 결정 필요"
                elif mean:
                    r["advice"] = "유지 권고 — AS-IS 에서 '-' 를 값으로 쓰는 컬럼의 비교·적재"
                else:
                    r["advice"] = "검토 — 빈값 대체 목적이면 '/' 로 변경, AS-IS 원래 '-' 값이면 유지"
                sheets["other"].append(r)
        elif loose:
            cnt = collections.Counter(final[(t, c)] for t, c, _ in loose)
            r["col_verdicts"] = f"후보 {len(loose)} (대상 {cnt['대상']} · 제외 {cnt['제외']} · 검토필요 {cnt['검토필요'] + cnt['검토필요(C#만)']})"
            sheets["unres"].append(r)
        elif "모집단 밖" in r["notes"]:
            sheets["outpop"].append(r)
        else:
            r["col_verdicts"] = ""
            sheets["unres"].append(r)
    for r in sheets["unres"]:
        n = r["notes"]; tiers = {t for _, _, t in r.get("loose", [])}
        if r["dynamic"]:
            w = "동적 SQL"
        elif "GTT(" in n:
            w = "GTT 컬럼/적재"
        elif "변수" in n or "변수" in tiers:
            w = "변수·파라미터"
        elif "derived" in n or "cte(" in n or "view(" in n or "func" in n or "temp" in n:
            w = "파생·CTE·뷰·함수 경유"
        elif "출력 별칭" in n and not r.get("loose"):
            w = "조회 출력 컬럼(적재 아님)"
        elif "추정" in tiers:
            w = "무별칭·후보 다수"
        elif "unknown(" in n or "미해석" in n:
            w = "테이블·별칭 미해석"
        else:
            w = "컬럼 참조 없음" if not n else "기타"
        r["unres_why"] = w
    return sheets


# ------------------------------------------------------------------------------------------------------------
# 5. xlsx
# ------------------------------------------------------------------------------------------------------------
def write_xlsx(pop, cat, meta, mods, cols, ev_all, cs, sheets, stats, out_path):
    from openpyxl import Workbook
    from openpyxl.styles import Font, PatternFill, Alignment
    from openpyxl.utils import get_column_letter
    from openpyxl.worksheet.datavalidation import DataValidation
    wb = Workbook()
    hdr = PatternFill("solid", fgColor="DDEBF7"); inp = PatternFill("solid", fgColor="FFF2CC")
    vfill = {"'-' 의미 사용": "F8CBAD", "단순(빈값 대체만)": "C6E0B4"}

    def sheet(title, headers, rows, widths, vcol=None, freeze="A2"):
        ws = wb.create_sheet(title)
        ws.append(headers)
        for r in rows:
            ws.append([ILLEGAL.sub(" ", v) if isinstance(v, str) else v for v in r])
        for c in ws[1]:
            c.font = Font(bold=True); c.fill = hdr; c.alignment = Alignment(wrap_text=True, vertical="center")
        ws.freeze_panes = freeze
        ws.auto_filter.ref = ws.dimensions
        for i, w in enumerate(widths, 1):
            ws.column_dimensions[get_column_letter(i)].width = w
        if vcol is not None:
            for row in ws.iter_rows(min_row=2, min_col=vcol + 1, max_col=vcol + 1):
                f = vfill.get(str(row[0].value))
                if f:
                    row[0].fill = PatternFill("solid", fgColor=f)
        if "사용자 판정" in headers and rows:
            L = get_column_letter(headers.index("사용자 판정") + 1)
            dv = DataValidation(type="list", formula1='"대상,제외"', allow_blank=True)
            ws.add_data_validation(dv); dv.add(f"{L}2:{L}{len(rows) + 1}")
            ws[f"{L}1"].fill = inp
            ws.column_dimensions[L].hidden = True          # 5차 확정으로 전 컬럼 '/' — 입력 불필요
        return ws

    # --- 1_컬럼판정
    h1 = ["스키마", "테이블", "컬럼", "데이터형", "현재 DB 상태", "AS-IS DB", "AS-IS 컬럼 존재",
          "분기문 확정", "분기문 추정·간접·변수·동적", "분기문·NULL검사 겸용", "조건절 비교 확정", "조건절 비교 기타", "조건절·NULL검사 겸용",
          "C# 분기 같은줄", "C# 분기 인접줄", "(참고)단순 NULL대체", "(참고)단순 적재·대입", "AS-IS '-' 사용 분류", "분류 사유", "근거 발췌 1", "근거 발췌 2", "근거 발췌 3",
          "동일 컬럼명 타 테이블 제외 수", "(참고)같은 컬럼명의 테이블 미연결 분기 건수", "AS-IS DEFAULT 값", "(참고)AS-IS '-' 행수(10-01)", "사용자 판정", "적용 DEFAULT", "비고"]
    r1 = [[c["owner"], c["table"], c["column"], c["dtype"], c["state"], c["asis_db"], c["asis_col"], c["a_fix"], c["a_other"], c["a_null"],
           c["b_fix"], c["b_other"], c["b_null"], c["cs_same"], c["cs_near"], c["c_cnt"], c["d_cnt"], {"제외": "'-' 의미 사용", "대상": "단순(빈값 대체만)"}.get(c["auto"], c["auto"]), c["why"]] + c["samples"] +
          [c["same_name_excl"], c["unlinked"], (c["asis_default_val"] or ("(DEFAULT 없음)" if c["asis_db"] else "(AS-IS 테이블 없음)")), c["asis_dash"], c["user"], c["apply_default"], ""] for c in cols]
    sheet("1_컬럼판정", h1, r1, [9, 34, 24, 10, 20, 13, 7, 7, 9, 9, 7, 7, 9, 7, 7, 8, 8, 10, 46, 70, 70, 70, 8, 9, 8, 10, 11, 10, 24], vcol=17, freeze="D2")

    # --- 2_ASIS분기근거
    popset = {(c["table"], c["column"]) for c in cols}
    cls_nm = {"A": "분기문", "A_NULLCHK": "분기문·NULL검사 겸용", "B": "조건절 비교", "B_NULLCHK": "조건절·NULL검사 겸용"}
    h2 = ["테이블", "컬럼", "근거 종류", "컬럼 특정 수준", "동적SQL", "원천", "DB/파일", "객체", "객체유형", "줄", "문장·피연산자", "발췌", "비고"]
    r2 = []
    for e in ev_all:
        if e["cls"] not in cls_nm:
            continue
        refs = sorted({tuple(x) for x in e["refs"] if (x[0], x[1]) in popset}, key=lambda x: (x[0], x[1]))
        for tb, c, tier in refs:
            r2.append([tb, c, cls_nm[e["cls"]], tier, "Y" if e["dynamic"] else "", e["src"], e["loc"], e["object"], e["otype"], e["line"],
                       e["detail"], e["snip"], e["notes"]])
    colnames = {c["column"] for c in cols}
    for r in cs["rows"]:
        names = [(x, "같은 줄") for x in r["same"]] + [(x, "인접 줄") for x in r["near"]]
        if not names:
            names = [("(컬럼 미특정)", "")]
        for cn, where in names:
            r2.append(["(C# — 테이블 미특정)", cn, "C# 분기" if r["branch"] else "C# 비교(분기 아님)", "컬럼명 " + where if where else "", "", "C#", r["path"],
                       r["screen"], "cs", r["line"], "", r["snip"], ""])
    r2.sort(key=lambda x: (x[1], x[0], x[2], x[3], str(x[7]), x[9] or 0))
    sheet("2_ASIS분기근거", h2, r2, [34, 24, 18, 12, 6, 6, 30, 44, 16, 7, 60, 110, 40])
    # --- 2b 분기문이지만 모집단 컬럼으로 이어지지 않은 것 (누락 확인용)
    r2b = [[", ".join(sorted({n for n, w in op_cols(e["notes"])})), "Y" if any(n in colnames for n, w in op_cols(e["notes"])) else "",
            cls_nm[e["cls"]], "Y" if e["dynamic"] else "", e["src"], e["loc"], e["object"], e["otype"], e["line"], e["detail"], e["snip"], e["notes"]]
           for e in ev_all if e["cls"] in ("A", "A_NULLCHK") and not [x for x in e["refs"] if (x[0], x[1]) in popset]]
    r2b.sort(key=lambda x: (x[0], x[5], str(x[6]), x[8] or 0))
    sheet("2b_ASIS분기_컬럼미연결", ["피연산자 컬럼명", "모집단 컬럼명과 동일", "근거 종류", "동적SQL", "원천", "DB/파일", "객체", "객체유형", "줄", "문장·피연산자", "발췌",
                              "미연결 사유"], r2b, [24, 8, 18, 6, 6, 30, 44, 16, 7, 60, 110, 60])

    # --- 3_ASIS단순사용(참고)
    agg = collections.Counter()
    for e in ev_all:
        if e["cls"] in ("C", "D"):
            targets = (e["refs"] + e["dest"]) if e["cls"] == "C" else e["dest"]
            for tb, c, tier in {tuple(x) for x in targets}:
                if (tb, c) in popset:
                    agg[(tb, c, "NULL 대체(ISNULL·COALESCE)" if e["cls"] == "C" else "적재·대입·CASE 결과값", tier, e["src"], e["object"])] += 1
    r3 = [[k[0], k[1], k[2], k[3], k[4], k[5], v] for k, v in sorted(agg.items())]
    sheet("3_ASIS단순사용(참고)", ["테이블", "컬럼", "쓰임", "컬럼 특정 수준", "원천", "객체", "건수"], r3, [34, 24, 26, 12, 6, 50, 7])

    # --- TO-BE
    role_nm = {"NVL": "NVL 초기값", "NVL_CMP": "NVL 비교(null-safe)", "BRANCH": "분기(IF/CASE/DECODE/NULLIF)", "PREDICATE": "조건절 비교",
               "CASE_VALUE": "CASE 결과값", "LOAD": "리터럴 적재", "ASSIGN": "대입", "DEFAULT": "DEFAULT 선언", "OTHER": "기타", "NON_SENTINEL": "비센티널"}
    ht = ["스키마", "객체유형", "객체명", "서브프로그램", "줄", "열", "쓰임", "상세", "동적SQL", "대상 컬럼(확정)", "컬럼 판정", "원문", "변경안('-'→'/')",
          "후보 컬럼(미확정)", "이관작업 마커", "비고"]
    wt = [9, 13, 34, 34, 6, 5, 20, 46, 6, 46, 40, 90, 90, 46, 16, 40]

    def trow(r):
        fx = ", ".join(f"{t}.{c}" for t, c in r.get("fixed", []))
        lo = r.get("loose", [])
        lo_txt = ", ".join(f"{t}.{c}({tier})" for t, c, tier in lo[:8]) + (f" 외 {len(lo) - 8}" if len(lo) > 8 else "")
        note = r["notes"] + ((" / 출력 별칭 " + r["alias"]) if r.get("alias") and "출력 별칭" not in r["notes"] else "")
        if r["nullchk"]:
            note = "NULL검사 겸용 / " + note
        if r.get("advice"):
            note = r["advice"] + " / " + note
        return [r["owner"], r["type"], r["name"], r["sub"], r["line"], r.get("colpos", ""), role_nm.get(r["role"], r["role"]), r["detail"], "Y" if r["dynamic"] else "",
                fx, r.get("col_verdicts", ""), r["text"], ("(유지)" if r.get("advice", "").startswith("유지") else r["changed"]), lo_txt, r["markers"], (("[" + r["unres_why"] + "] ") if r.get("unres_why") else "") + note]

    key = lambda r: (r["owner"], r["name"], r["type"], r["line"], r.get("colpos") or 0)
    sheet("4_TOBE_NVL적용대상", ht, [trow(r) for r in sorted(sheets["nvl"], key=key)], wt, freeze="G2")
    sheet("5_TOBE_함께검토", ht, [trow(r) for r in sorted(sheets["other"], key=key)], wt, freeze="G2")
    sheet("6_TOBE_컬럼미특정", ht, [trow(r) for r in sorted(sheets["unres"], key=key)], wt, freeze="G2")
    if sheets["excl"]:
        sheet("7_TOBE_제외·검토컬럼", ht, [trow(r) for r in sorted(sheets["excl"], key=key)], wt, freeze="G2")
    # --- 8 DDL
    r8 = []
    for c in cols:
        if c["final"] != "대상":
            continue
        ap = c["apply_default"]; asis = c["asis_default_val"] or ("(DEFAULT 없음)" if c["asis_db"] else "(AS-IS 테이블 없음)")
        if c["cur_default"] == ap:
            ddl = "-- 변경 없음 (현재 DEFAULT 가 이미 적용 값과 같음)"
        elif c["cur_default"] == "'-'":
            on = " ON NULL" if c["cur_on_null"] == "YES" else ""
            ddl = f"ALTER TABLE {c['owner']}.{c['table']} MODIFY ({c['column']} DEFAULT{on} {ap});"
        else:
            ddl = f"-- 현재 DEFAULT 가 '-' 가 아님({c['cur_default'] or '없음'}): 적용 값 {ap} 로 바꿀지 확인 필요"
        r8.append([c["owner"], c["table"], c["column"], c["state"], asis, ap, ddl])
    sheet("8_DEFAULT변경DDL(참고)", ["스키마", "테이블", "컬럼", "현재 DB 상태", "AS-IS DEFAULT 값", "적용 DEFAULT", "DDL (실행하지 않음 — 참고용)"],
          r8, [9, 34, 24, 22, 20, 12, 90])
    sheet("9_TOBE_모집단밖(참고)", ht, [trow(r) for r in sorted(sheets["outpop"], key=key)], wt, freeze="G2")

    # --- 요약 (맨 앞)
    ws = wb["Sheet"]; ws.title = "요약"
    vc = collections.Counter(c["auto"] for c in cols); fc = collections.Counter(c["final"] for c in cols)
    L = []
    L.append(["NULL 센티널 '-' → '/' 전환 — 대상/제외 판정 + TO-BE 적용대상 취합"])
    L.append([])
    L.append(["기준"])
    L.append([f"  모집단: {pop['file']} / 시트 '처리대상이력' {len(pop['rows']):,}행 (파일 수정시각 {pop['mtime']})"])
    L.append([f"  TO-BE: 사내 {cat['service']} 조회 {cat['fetched']} (컬럼 사전) / 소스 {stats['tobe_src_fetched']}"])
    L.append([f"  AS-IS DB: {mods['source']} — {mods['fetched']} / 메타 {meta['fetched']} / 모듈 {len(mods['mods']):,}개"])
    L.append([f"  AS-IS 파일: {GSCM} — XML·SQL {stats['xml_scanned']:,}개 중 '-' 포함 {stats['xml_files']:,}개 / C# {cs['scanned']:,}개 중 \"-\" 비교 포함 {cs['hit_files']:,}개"])
    L.append([])
    L.append(["최종 방침 (사용자 확정 2026-10-06 5차)"])
    L.append(["  모집단 1,797 컬럼은 전부 NOT NULL 이다 → 빈값 대체는 전부 '/' 로 한다. DEFAULT 는 전 컬럼 '/' 적용 (MSSQL 로 되돌려 보낼 때 빈값과 실제 '-' 를 구분하기 위함)"])
    L.append(["  '-' 값이 넘어오면 그대로 저장·사용한다. AS-IS 에 원래 있던 '-' 비교·분기 로직은 '-' 그대로 유지한다."])
    L.append(["  아래 '제외' 기준으로 가려낸 컬럼은 이제 DEFAULT 변경에서 빠지는 것이 아니라, \"'-' 를 값으로도 쓰는 컬럼\" 표시로만 쓴다 (1_컬럼판정 의 'AS-IS '-' 사용 분류' = '-' 의미 사용)."])
    L.append([])
    L.append(["'-' 의미 사용 분류 기준 (2~4차 확정분)"])
    L.append(["  제외     = AS-IS DB 객체(SP·VIEW·FUNCTION·TRIGGER)에 그 TABLE.COLUMN 의 '-' 를 비교하거나 분기하는 로직이 있고, 테이블까지 확정된 경우"])
    L.append(["             (분기문: IF·WHILE 조건 / CASE WHEN / CASE x WHEN '-' / IIF / NULLIF(x,'-') · 조건절: WHERE·ON·HAVING 의 = <> IN 비교 · ISNULL(x,'-') = '-' 형태 포함 · 동적 SQL 포함)"])
    L.append(["  검토필요 = 비교·분기는 있으나 어느 테이블의 컬럼인지 확정 못 함(추정·간접·변수) / DB 객체가 아닌 FoxQuery XML 인라인 SQL 의 근거만 있음"])
    L.append(["  제외(C#)  = C# 화면 소스의 \"-\" 분기 줄에 컬럼명이 직접 나오는 컬럼명(ITEM_ID · SCM_SITE_ID · PROJECT_CODE · FACTORY_ID · ELECTRODE_TYPE)은 테이블과 무관하게 전부 제외 (사용자 확정 3차)"])
    L.append(["  제외(컬럼명) = CELL_PROD_SITE_ID · BOD_ID · TO_SITE · FROM_SITE · LINE_ID · INCOTERMS · FCST_TYPE 는 컬럼명 단위로 전부 제외 (사용자 확정 4차). 단 SCP_MST_SHIPMENT_LOT_SIZE.TO_SITE 는 대상으로 명시 확정"])
    L.append(["  잔여 검토필요 37건: 3건(USER_ID · PEGGING_OPERATION_CODE · SCP_MST_SHIPMENT_LOT_SIZE.TO_SITE)은 대상, 나머지는 제외로 확정 (사용자 확정 4차)"])
    L.append(["  대상     = 위 근거 없음. ISNULL(x,'-') 단독 · ISNULL(a,'-') = ISNULL(b,'-') · '-' 적재 · CASE 결과값 '-' 같은 단순 사용은 제외 사유가 아님"])
    L.append(["  최종 판정 = '사용자 판정' 열에 값이 있으면 그 값, 없으면 자동 판정"])
    L.append([])
    L.append(["적용 DEFAULT (사용자 확정 6차: AS-IS 에 DEFAULT 가 있던 컬럼은 그 값 유지, 없던 컬럼만 '/')"])
    for k, v in sorted(collections.Counter(c["apply_default"] for c in cols).items()):
        L.append(["  적용 DEFAULT " + k, v])
    ac = collections.Counter("AS-IS DEFAULT 있음" if c["asis_default_val"] else ("AS-IS DEFAULT 없음" if c["asis_db"] else "AS-IS 대응 테이블 없음") for c in cols)
    for k, v in sorted(ac.items()):
        L.append(["  " + k, v])
    L.append([f"  AS-IS DEFAULT 출처: {stats['adef_source']} — {stats['adef_fetched']}"])
    L.append([])
    L.append(["컬럼 건수"])
    L.append(["  DEFAULT '/' 적용 대상", len(cols)])
    L.append(["    그중 '-' 의미 사용 컬럼(값 '-' 유지 필요)", vc["제외"]])
    L.append(["    그중 단순(빈값 대체만)", vc["대상"]])
    st = collections.Counter(c["state"].split(":")[0] for c in cols)
    L.append([])
    L.append(["현재 DB 상태"])
    for k, v in sorted(st.items()):
        L.append(["  " + k, v])
    L.append([])
    L.append(["AS-IS 근거 건수"])
    ec = collections.Counter((e["src"], e["cls"]) for e in ev_all)
    for k, v in sorted(ec.items()):
        L.append([f"  {k[0]} / {k[1]}", v])
    L.append([f"  AS-IS DB '-' 포함 모듈 {stats['asis_db'].get('modules_with_dash', 0):,}개 · '-' 출현 {stats['asis_db'].get('occ', 0):,}건 / XML '-' 출현 {stats['asis_xml'].get('occ', 0):,}건 / C# 비교 줄 {len(cs['rows']):,}건"])
    L.append([])
    L.append(["TO-BE '-' 출현 배치"])
    tot = 0
    for k, nm in (("nvl", "4_TOBE_NVL적용대상"), ("other", "5_TOBE_함께검토"), ("unres", "6_TOBE_컬럼미특정"), ("excl", "(7 시트 폐지 — 4·5 로 흡수)"),
                  ("outpop", "9_TOBE_모집단밖(참고)"), ("nonsent", "비센티널 용도(시트 없음)")):
        L.append(["  " + nm, len(sheets[k])]); tot += len(sheets[k])
    L.append(["  합계(코드 내 '-' 리터럴 출현)", tot])
    L.append([f"  대사: 스캔 출현 수 {stats['tobe'].get('occ', 0):,} = 배치 합계 {tot:,} / 주석 안의 '-' {stats['tobe'].get('comment_dash', 0):,}건(대상 아님) / '-' 포함 소스 줄(ALL_SOURCE) {stats['tobe_dash_lines']:,}"])
    L.append([])
    L.append(["분석 실패(숨기지 않음)"])
    L.append([f"  AS-IS DB 모듈 {len(stats['fails_asis_db'])} / XML {len(stats['fails_asis_xml'])} / TO-BE 객체 {len(stats['fails_tobe'])}"])
    for f in (stats["fails_asis_db"] + stats["fails_asis_xml"] + stats["fails_tobe"])[:30]:
        L.append(["    " + " | ".join(str(x) for x in f)])
    L.append([])
    L.append(["한계"])
    for t in ["정적 분석이다 — 임시테이블·CTE·파생 테이블을 거친 컬럼은 '간접', 변수 경유는 '변수', 동적 SQL 은 '동적' 으로 표시하고 자동으로 제외하지 않는다(검토필요).",
              "무별칭 컬럼은 같은 문장의 실테이블 중 그 컬럼을 가진 것이 하나일 때만 확정한다.",
              "분기문이지만 어느 모집단 테이블의 컬럼인지 잇지 못한 근거는 2b_ASIS분기_컬럼미연결 에 전부 싣는다(판정에는 반영하지 않음). "
              "1_컬럼판정 의 '(참고)같은 컬럼명의 테이블 미연결 분기 건수' 가 0 이 아닌 컬럼명은 2b 를 그 컬럼명으로 걸러 확인할 것.",
              "C# 근거는 컬럼명 수준이다(테이블을 특정할 수 없음) — 같은 컬럼명을 가진 모든 테이블이 검토필요로 올라온다. '판정 사유' 로 걸러 볼 것.",
              "AS-IS 대응 테이블 = 같은 이름(LGCE_SCMDEV 우선, 없으면 LGCE_FPDEV). 대응이 없으면 근거가 생길 수 없어 대상이 된다.",
              "AS-IS DB 는 DEV(LGCE_*DEV), TO-BE 는 사내 ZIOUI1 기준 — 운영·클라우드와 판본 차이 가능.",
              "TO-BE 시트는 '-' 리터럴 1개가 1행이다 — 한 줄에 '-' 가 여러 개면 여러 행으로 나오고('열' 로 구분), '변경안' 은 그 행의 '-' 하나만 바꾼 모습이다.",
              "TO-BE 4·5 시트에는 컬럼이 '확정' 된 줄만 싣는다. 변수·파라미터·GTT 컬럼·동적 SQL 등은 6_TOBE_컬럼미특정 으로 분리한다(후보 컬럼 병기).",
              "TABLE.COLUMN 단위 판정이므로 제외 테이블과 대상 테이블 사이에서 같은 컬럼이 조인·복사되면 '-' 와 '/' 가 어긋날 수 있다 — '동일 컬럼명 타 테이블 제외 수' 열 참고.",
              "'(참고)AS-IS '-' 행수' 는 2026-10-01 수집분이며 판정에 쓰지 않는다. TO-BE 기존 데이터는 범위 밖.",
              "DB 객체·데이터 변경 없음. 8_DEFAULT변경DDL 은 문장 텍스트일 뿐 실행하지 않았다."]:
        L.append(["  " + t])
    for r in L:
        ws.append(r)
    ws["A1"].font = Font(bold=True, size=13)
    for row in ws.iter_rows(min_col=1, max_col=1):
        v = row[0].value
        if isinstance(v, str) and v and not v.startswith(" ") and row[0].row > 1:
            row[0].font = Font(bold=True)
    ws.column_dimensions["A"].width = 150; ws.column_dimensions["B"].width = 10; ws.column_dimensions["C"].width = 10
    wb.save(out_path)
    log("xlsx", out_path)


def load_user_judgment(path):
    from openpyxl import load_workbook
    wb = load_workbook(path, read_only=True, data_only=True)
    ws = wb["1_컬럼판정"]
    it = ws.iter_rows(values_only=True); h = list(next(it))
    ti, ci, ui = h.index("테이블"), h.index("컬럼"), h.index("사용자 판정")
    return {(r[ti], r[ci]): r[ui] for r in it if r[ui]}


def main():
    args = sys.argv[1:]
    refresh = set(); judgment = None
    while "--refresh" in args:
        i = args.index("--refresh"); refresh.add(args[i + 1]); del args[i:i + 2]
    if "--judgment" in args:
        i = args.index("--judgment"); judgment = args[i + 1]; del args[i:i + 2]
    stage = args[0] if args else "all"

    pop = cached("pop", stage_pop, refresh)
    pop_tabs = collections.defaultdict(set)
    for r in pop["rows"]:
        pop_tabs[r["table"]].add(r["column"])
    pop_tabs = dict(pop_tabs)
    cat = cached("tobe_cat", stage_tobe_cat, refresh)
    meta = cached("asis_meta", stage_asis_meta, refresh)
    mods = cached("asis_mods", stage_asis_mods, refresh)
    views_by_db = collections.defaultdict(set)
    for m in mods["mods"]:
        if m["type"] == "VIEW":
            views_by_db[m["db"]].add(m["name"].upper())
    scanners, asis_names = asis_scanners(pop_tabs, meta, views_by_db)
    asis_db = scan_asis_db(mods["mods"], scanners)
    xmlraw = cached("xml", stage_xml_raw, refresh)
    asis_xml = scan_asis_xml(xmlraw, scanners)
    colnames = {r["column"] for r in pop["rows"]}
    cs = cached("cs", lambda: stage_cs(sorted(colnames)), refresh)
    ev_all = asis_db["ev"] + asis_xml["ev"]
    user_j = load_user_judgment(judgment) if judgment else None
    adef = cached("asis_defaults_all", stage_asis_defaults_all, refresh)
    cols = judge_columns(pop, cat, meta, asis_names, ev_all, cs, user_j, adef)
    src = cached("tobe_src", old.stage_src_fetch, refresh)
    tobe = stage_tobe_scan(src, cat, pop_tabs)
    sheets = place_tobe(tobe["rows"], cols)
    import report2
    try:
        adata = json.load(open(os.path.join(OLD_CACHE, "asis_data_partial.json"), encoding="utf-8"))
    except Exception:
        adata = {}
    try:
        space = json.load(open(cpath("asis_space"), encoding="utf-8"))
    except Exception:
        space = {}
    report2.data_class(cols, adata, space)
    report2.assign_actions(tobe["rows"], cols, mods["mods"])
    stats = {"asis_db": asis_db["stat"], "asis_xml": asis_xml["stat"], "tobe": tobe["stat"], "fails_asis_db": asis_db["fails"],
             "fails_asis_xml": asis_xml["fails"], "fails_tobe": tobe["fails"], "xml_scanned": xmlraw["scanned"], "xml_files": len(xmlraw["files"]),
             "tobe_src_fetched": src["fetched"], "tobe_dash_lines": src["dash_line_count"],
             "adef_source": adef["source"], "adef_fetched": adef["fetched"]}
    json.dump({"cols": cols, "ev": ev_all, "tobe": [{k: v for k, v in r.items()} for r in tobe["rows"]]},
              open(cpath("result"), "w", encoding="utf-8"), ensure_ascii=False, default=list)
    tobe_objs = cached("tobe_objs", stage_tobe_objs, refresh)
    out = OUT_XLSX
    for n in range(0, 20):
        try:
            report2.write_xlsx2(pop, cat, meta, mods, cols, ev_all, cs, tobe["rows"], stats, out, op_cols, tobe_objs)
            break
        except PermissionError:
            out = OUT_XLSX.replace(".xlsx", f"_v{n + 2}.xlsx")
    log("xlsx", out)
    vc = collections.Counter(c["auto"] for c in cols)
    log("verdict", dict(vc), "| tobe sheets", {k: len(v) for k, v in sheets.items()})


if __name__ == "__main__":
    main()
