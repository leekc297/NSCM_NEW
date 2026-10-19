"""02_build.py — UI별 PKG 전환대상 판정 (2026-09-14)

추정 금지 원칙: UI↔DB 객체 연결은 아래 사실만 사용한다.
  A1 등록 API   : SCM_ADM_MNU_BTN_MPG_M(MNU_ID,SHT_NM,BTN) → SCM_ADM_API_M.API_URL
  A2 FE 실호출  : nscm-fe 주석 제거 코드에서 메뉴ID 리터럴 + 시트명 리터럴
  A3 Excel      : SCM_ADM_EXCEL_COLUMNS(PROGRAM_ID).STORAGE_SQL_ID
  A4 내부 호출  : ALL_DEPENDENCIES + ALL_SOURCE 본문(주석 제거) 에서 호출 멤버까지 특정
  A5 실행 로그  : SCM_COM_SQL_LOG {call X} (09-03~) — 보조
판정 단위 = SP 가 **등록된 메뉴(MNU_ID)**. 통합 대상 PKG = PKG_{UI}. 화면 간 공용 팝업을 여는 화면은 참고 표기만.
DB 는 조회만 한다.
"""
import csv, re, json, pathlib, collections, datetime
import oracledb

D = pathlib.Path(__file__).resolve().parent
FE = pathlib.Path(r"C:\Projects\NSCM\nscm-fe")
BE = pathlib.Path(r"C:\Projects\NSCM\nscm-be\src\main\resources")
L = lambda n: list(csv.DictReader((D / f"{n}.csv").open(encoding="utf-8-sig")))
mnu, btn, api, proc_m, excel, cmbo, objs, members, syns, deps, logs = (L(n) for n in
    ("mnu_m", "btn_mpg", "api_m", "proc_m", "excel_columns", "cmbo_sql", "objects", "pkg_members", "synonyms", "dependencies", "sql_log_calls"))

def norm(x):
    u = (x or "").strip().upper()
    return u[8:] if u.startswith("SCM_MGR.") else u

def ui_of(menu_id):
    """메뉴ID → UI ID (DMF0043_01 → DMF0043). 등록 메뉴 단위를 UI PKG 이름으로 맞추는 용도"""
    return re.sub(r"_\d+$", "", menu_id)

# ───────────────────────── 1. 메뉴 범위 ─────────────────────────
mnu_by = {r["MNU_ID"]: r for r in mnu}
screens = {m for m, r in mnu_by.items() if r["MNU_TP_CD"] == "SCREEN" and r["USE_YN"] == "Y" and not m.startswith("SDM")}

# ───────────────────────── 2. DB 카탈로그 ─────────────────────────
otype = collections.defaultdict(set)
ostatus = {}
for o in objs:
    if o["OWNER"] == "SCM_MGR":
        otype[o["OBJECT_NAME"]].add(o["OBJECT_TYPE"]); ostatus[(o["OBJECT_NAME"], o["OBJECT_TYPE"])] = o["STATUS"]
standalone = {n for n, t in otype.items() if "PROCEDURE" in t}
packages = {n for n, t in otype.items() if "PACKAGE" in t}
functions = {n for n, t in otype.items() if "FUNCTION" in t}
pkg_mem = collections.defaultdict(set)
for m in members:
    if m["PROCEDURE_NAME"]: pkg_mem[m["PACKAGE_NAME"]].add(m["PROCEDURE_NAME"])
syn_to = {}
app_syn = set()
for r in syns:
    if r["TABLE_OWNER"] == "SCM_MGR":
        syn_to.setdefault(r["SYNONYM_NAME"], r["TABLE_NAME"])
        if r["OWNER"] == "SCMP_APP": app_syn.add(r["SYNONYM_NAME"])
proc_m_cnt = collections.Counter()
for r in proc_m: proc_m_cnt[norm(r["PROC_NM"])] += int(r["CNT"])
api_by = {r["API_ID"]: r for r in api}

def resolve(url):
    u = norm(url)
    if not u: return ("EMPTY", "", "", "")
    parts = u.split(".")
    if len(parts) == 2:
        p, mbr = parts; p = syn_to.get(p, p)
        if p in packages: return ("PKG_MEMBER" if mbr in pkg_mem[p] else "PKG_MEMBER_MISSING", p, mbr, "")
        return ("UNKNOWN_QUALIFIED", p, mbr, "")
    n = syn_to.get(u, u)
    if n in standalone: return ("STANDALONE_PROC", "", "", n)
    if n in functions: return ("FUNCTION", "", "", n)
    if n in packages: return ("PACKAGE_ONLY", n, "", "")
    return ("MISSING", "", "", n)

# 프레임워크(BE 매퍼 XML 직접 호출)
framework = set()
for x in BE.rglob("*.xml"):
    for m in re.finditer(r"\{\s*call\s+([A-Za-z0-9_$#.]+)", x.read_text(encoding="utf-8", errors="ignore"), re.I):
        framework.add(norm(m.group(1)))
framework_pkgs = {f.split(".")[0] for f in framework if "." in f} | {f for f in framework if "." not in f}

# ───────────────────────── 3. FE 스캔 (주석 제거) ─────────────────────────
def strip_ts_comments(src):
    out, i, n, q = [], 0, len(src), None
    while i < n:
        c = src[i]
        if q:
            out.append(c)
            if c == "\\" and i + 1 < n: out.append(src[i + 1]); i += 2; continue
            if c == q: q = None
            i += 1; continue
        if c in "'\"`": q = c; out.append(c); i += 1; continue
        if src.startswith("//", i):
            j = src.find("\n", i); i = n if j < 0 else j; continue
        if src.startswith("/*", i):
            j = src.find("*/", i + 2); seg = src[i:(n if j < 0 else j + 2)]
            out.append("\n" * seg.count("\n")); i = n if j < 0 else j + 2; continue
        out.append(c); i += 1
    return "".join(out)

fe_files = {}
for root in (FE / "features", FE / "packages", FE / "apps"):
    for f in root.rglob("*"):
        if f.suffix in (".ts", ".tsx") and "node_modules" not in f.parts and not f.name.endswith(".d.ts") \
           and ".test." not in f.name and ".spec." not in f.name and "__tests__" not in f.parts and "mock" not in f.name.lower():
            try: fe_files[f] = strip_ts_comments(f.read_text(encoding="utf-8", errors="ignore"))
            except Exception: pass

def unit_root(f):
    parts = f.parts
    if "pages" in parts:
        k = parts.index("pages");  return pathlib.Path(*parts[:k + 2])
    return f.parent

btn_menus = sorted({b["MNU_ID"] for b in btn} | {e["PROGRAM_ID"] for e in excel})
menu_fe = {}   # menu -> dict(files, roots, text)
for mid in btn_menus + sorted(screens):
    if mid in menu_fe: continue
    lit = re.compile(r"['\"`]" + re.escape(mid) + r"['\"`]")
    hits = [f for f, t in fe_files.items() if lit.search(t)]
    roots = {unit_root(f) for f in hits}
    if mid in mnu_by and mnu_by[mid]["MNU_URL"] not in ("", "-"):
        for pg in (FE / "features").glob(f"*/src/pages/{mnu_by[mid]['MNU_URL']}"):
            roots.add(pg)
    text = "\n".join(t for f, t in fe_files.items() if any(r in f.parents for r in roots))
    menu_fe[mid] = dict(files=sorted(str(f.relative_to(FE)) for f in hits), roots=sorted(str(r.relative_to(FE)) for r in roots), text=text)

def sheet_in_fe(mid, sht):
    t = menu_fe.get(mid, {}).get("text", "")
    return bool(t) and bool(re.search(r"['\"`]" + re.escape(sht) + r"['\"`]", t))

# 범위 메뉴 = 활성 SCREEN(비SDM) + FE 코드가 참조하는 비화면 메뉴(팝업 등, 비SDM·비활성화면 제외)
def in_scope(mid):
    if mid in screens: return True
    if mid.startswith("SDM"): return False
    r = mnu_by.get(mid)
    if r and r["MNU_TP_CD"] == "SCREEN": return False          # 비활성 화면
    if r and r["USE_YN"] != "Y": return False
    return bool(menu_fe.get(mid, {}).get("files"))
scope_menus = sorted(m for m in btn_menus if in_scope(m))
for s in screens:
    if s not in scope_menus: scope_menus.append(s)
scope_menus = sorted(set(scope_menus))

# 화면 → 참조 팝업 메뉴 (참고 표기용: 화면 페이지 폴더에서 해당 메뉴 리터럴 사용)
screen_ref = collections.defaultdict(set)
for s in screens:
    t = menu_fe[s]["text"]
    for mid in scope_menus:
        if mid != s and mid not in screens and t and re.search(r"['\"`]" + re.escape(mid) + r"['\"`]", t):
            screen_ref[mid].add(s)

# ───────────────────────── 4. 로그 ─────────────────────────
log_by_menu = collections.defaultdict(int); log_total = collections.Counter(); log_last = {}
for r in logs:
    p = norm(r["PROC"]); c = int(r["CNT"])
    log_total[p] += c; log_by_menu[(r["MNU_ID"], p)] += c
    log_last[p] = max(log_last.get(p, ""), r["LAST_EXEC"])
def log_cnt_obj(name):
    """standalone 이름 또는 PKG.MEMBER 의 로그 건수"""
    return log_total.get(name, 0)

# ───────────────────────── 5. 배선 원장 (A1 + A3) ─────────────────────────
ledger = []
for b in btn:
    a = api_by.get(b["API_ID"])
    url = a["API_URL"] if a else ""
    kind, pkg, mbr, sp = resolve(url) if a else ("API_M_NONE", "", "", "")
    key = norm(url)
    ledger.append(dict(MNU_ID=b["MNU_ID"], UI=ui_of(b["MNU_ID"]), SCOPE="Y" if b["MNU_ID"] in scope_menus else "N",
        MNU_TP=mnu_by.get(b["MNU_ID"], {}).get("MNU_TP_CD", "(MNU_M 없음)"), SRC="BTN_MPG", SHT_NM=b["SHT_NM"], BTN=b["MNU_BTN_CD"],
        BTN_USE=b["USE_YN"], API_ID=b["API_ID"], API_TP=a["API_TP_CD"] if a else "", API_USE=a["USE_YN"] if a else "",
        API_URL=url, KIND=kind, PKG=pkg, MEMBER=mbr, STANDALONE=sp, PROC_M=proc_m_cnt.get(key, 0),
        FE_MENU="Y" if menu_fe.get(b["MNU_ID"], {}).get("files") or b["MNU_ID"] in screens and menu_fe[b["MNU_ID"]]["roots"] else "N",
        FE_SHEET="Y" if sheet_in_fe(b["MNU_ID"], b["SHT_NM"]) else "N",
        LOG_MENU=log_by_menu.get((b["MNU_ID"], key), 0), LOG_ALL=log_total.get(key, 0), FRAMEWORK="Y" if key in framework else "N"))
for e in excel:
    url = e["STORAGE_SQL_ID"]; kind, pkg, mbr, sp = resolve(url); key = norm(url)
    mid = e["PROGRAM_ID"]
    ledger.append(dict(MNU_ID=mid, UI=ui_of(mid), SCOPE="Y" if mid in scope_menus else "N",
        MNU_TP=mnu_by.get(mid, {}).get("MNU_TP_CD", "(MNU_M 없음)"), SRC="EXCEL_COLUMNS", SHT_NM=e["SHEET_NAME"], BTN="UPLOAD",
        BTN_USE=e["VALID_YN"], API_ID="", API_TP="EXCEL", API_USE=e["VALID_YN"], API_URL=url, KIND=kind, PKG=pkg, MEMBER=mbr, STANDALONE=sp,
        PROC_M=proc_m_cnt.get(key, 0), FE_MENU="Y" if menu_fe.get(mid, {}).get("files") or menu_fe.get(mid, {}).get("roots") else "N",
        FE_SHEET="Y" if sheet_in_fe(mid, e["SHEET_NAME"]) else "N",
        LOG_MENU=log_by_menu.get((mid, key), 0), LOG_ALL=log_total.get(key, 0), FRAMEWORK="N"))

# ───────────────────────── 6. A4 내부 호출 — 멤버 단위 특정 ─────────────────────────
callers_dep = collections.defaultdict(set)   # standalone -> {caller object}
for r in deps:
    if r["REFERENCED_NAME"] in standalone and r["NAME"] != r["REFERENCED_NAME"]:
        callers_dep[r["REFERENCED_NAME"]].add((r["NAME"], r["TYPE"]))
caller_objs = sorted({c for v in callers_dep.values() for c in v})
conn = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1"); cur = conn.cursor()
src = collections.defaultdict(list)
names = sorted({n for n, _ in caller_objs})
for i in range(0, len(names), 200):
    chunk = names[i:i + 200]
    cur.execute("SELECT NAME, TYPE, LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND TYPE IN ('PACKAGE BODY','PROCEDURE','FUNCTION') AND NAME IN (%s) ORDER BY NAME, TYPE, LINE"
                % ",".join(f":{k}" for k in range(len(chunk))), chunk)
    for n, t, ln, tx in cur: src[(n, t)].append(tx or "")
def strip_sql_comments(s):
    out, i, n, q = [], 0, len(s), False
    while i < n:
        c = s[i]
        if q:
            out.append(c)
            if c == "'": q = False
            i += 1; continue
        if c == "'": q = True; out.append(c); i += 1; continue
        if s.startswith("--", i):
            j = s.find("\n", i); i = n if j < 0 else j; continue
        if s.startswith("/*", i):
            j = s.find("*/", i + 2); seg = s[i:(n if j < 0 else j + 2)]; out.append("\n" * seg.count("\n")); i = n if j < 0 else j + 2; continue
        out.append(c); i += 1
    return "".join(out)
member_decl = re.compile(r"^\s*(PROCEDURE|FUNCTION)\s+([A-Za-z0-9_$#]+)", re.I)
internal = collections.defaultdict(set)   # standalone -> {(caller_obj, member or '')}
for sp, cs in callers_dep.items():
    pat = re.compile(r"(?<![A-Za-z0-9_$#.])(?:SCM_MGR\.)?" + re.escape(sp) + r"(?![A-Za-z0-9_$#])", re.I)
    for (cn, ct) in cs:
        stype = "PACKAGE BODY" if ct in ("PACKAGE", "PACKAGE BODY") else ct
        lines = strip_sql_comments("".join(src.get((cn, stype), []))).split("\n")
        cur_member, found = "", False
        for ln in lines:
            md = member_decl.match(ln)
            if md and stype == "PACKAGE BODY": cur_member = md.group(2).upper()
            if pat.search(ln):
                found = True
                internal[sp].add((cn, cur_member if stype == "PACKAGE BODY" else ""))
        if not found:
            internal[sp].add((cn, "(의존만·본문 LIVE 호출 없음)"))

# 패키지 멤버 호출 그래프 (멤버 단위) — 같은 패키지 안 호출 + 타 객체의 PKG.MEMBER 호출
pkg_dep_callers = collections.defaultdict(set)
for r in deps:
    if r["REFERENCED_NAME"] in packages and r["NAME"] != r["REFERENCED_NAME"]:
        pkg_dep_callers[r["REFERENCED_NAME"]].add((r["NAME"], r["TYPE"]))
_need = sorted({p for p in packages} | {n for v in pkg_dep_callers.values() for n, _ in v})
_have = {n for n, _ in src}
_miss = [n for n in _need if n not in _have]
for i in range(0, len(_miss), 200):
    chunk = _miss[i:i + 200]
    cur.execute("SELECT NAME, TYPE, LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND TYPE IN ('PACKAGE BODY','PROCEDURE','FUNCTION') AND NAME IN (%s) ORDER BY NAME, TYPE, LINE"
                % ",".join(f":{k}" for k in range(len(chunk))), chunk)
    for n, t, ln, tx in cur: src[(n, t)].append(tx or "")
seg_cache = {}
def segments(name, stype):
    """본문(주석 제거)을 멤버별 텍스트로 분할. 비패키지는 {'': 전체}"""
    k = (name, stype)
    if k in seg_cache: return seg_cache[k]
    body = strip_sql_comments("".join(src.get(k, [])))
    if stype != "PACKAGE BODY":
        seg_cache[k] = {"": body}; return seg_cache[k]
    segs, cur_m, buf = collections.defaultdict(str), "", []
    for ln in body.split("\n"):
        md = member_decl.match(ln)
        if md:
            segs[cur_m] += "\n".join(buf); buf = []; cur_m = md.group(2).upper()
        buf.append(ln)
    segs[cur_m] += "\n".join(buf)
    seg_cache[k] = segs; return segs
def member_callers(p, mbr):
    out = set()
    own = re.compile(r"(?<![A-Za-z0-9_$#.])" + re.escape(mbr) + r"\s*\(|(?<![A-Za-z0-9_$#.])" + re.escape(mbr) + r"\s*;", re.I)
    for m2, txt in segments(p, "PACKAGE BODY").items():
        if m2 and m2 != mbr and own.search(txt): out.add(f"{p}.{m2}")
    ext = re.compile(r"(?<![A-Za-z0-9_$#])(?:SCM_MGR\.)?" + re.escape(p) + r"\s*\.\s*" + re.escape(mbr) + r"(?![A-Za-z0-9_$#])", re.I)
    for cn, ct in pkg_dep_callers.get(p, ()):
        stype = "PACKAGE BODY" if ct in ("PACKAGE", "PACKAGE BODY") else ct
        for m2, txt in segments(cn, stype).items():
            if ext.search(txt): out.add(f"{cn}.{m2}" if m2 else cn)
    return out

# 등록 사용: PKG.MEMBER / standalone → 메뉴
reg_users = collections.defaultdict(set)      # object key -> {menu}  (모든 등록)
reg_users_fe = collections.defaultdict(set)   # object key -> {menu}  (FE 에서 시트 호출이 확인된 등록만)
reg_sheet = collections.defaultdict(set)      # object key -> {menu/sheet/btn(FE Y|N)}
for r in ledger:
    if r["KIND"] == "STANDALONE_PROC": k = r["STANDALONE"]
    elif r["KIND"] == "PKG_MEMBER": k = f"{r['PKG']}.{r['MEMBER']}"
    elif r["KIND"] == "PACKAGE_ONLY": k = r["PKG"]
    else: continue
    reg_users[k].add(r["MNU_ID"])
    if r["FE_SHEET"] == "Y": reg_users_fe[k].add(r["MNU_ID"])
    reg_sheet[k].add(f"{r['MNU_ID']}/{r['SHT_NM']}/{r['BTN']}(FE {r['FE_SHEET']})")

_om_cache = {}
def owner_menus(obj_key, seen=None, fe_only=False):
    """객체를 쓰는 메뉴 집합 — 등록(A1/A3) + 내부 호출 경로(A4, 멤버 단위). fe_only=True 면 FE 호출 확인 등록만 뿌리로 쓴다. 반환: {menu: [근거]}"""
    top = seen is None
    if top and (obj_key, fe_only) in _om_cache: return _om_cache[(obj_key, fe_only)]
    seen = seen or set()
    if obj_key in seen: return {}
    seen = seen | {obj_key}
    res = collections.defaultdict(list)
    for m in (reg_users_fe if fe_only else reg_users).get(obj_key, ()):
        res[m].append(f"등록:{obj_key}")
    name = obj_key.split(".")[0] if "." in obj_key else obj_key
    if name in standalone and "." not in obj_key:
        for cn, cm in internal.get(name, ()):
            if cm.startswith("("): continue
            ck = f"{cn}.{cm}" if cm else cn
            for mm, ev in owner_menus(ck, seen, fe_only).items():
                res[mm].append(f"내부:{ck} ← " + ev[0])
    elif "." in obj_key:
        # 패키지 멤버가 등록 API 가 아닐 수 있다(내부 헬퍼) → 이 멤버를 부르는 같은 패키지 멤버 / 타 객체로 거슬러 올라간다
        p, mbr = obj_key.split(".")
        for ck in member_callers(p, mbr):
            for mm, ev in owner_menus(ck, seen, fe_only).items():
                res[mm].append(f"내부:{ck} ← " + ev[0])
    if top: _om_cache[(obj_key, fe_only)] = res
    return res

# ───────────────────────── 6-B. A6 배치 JOB 도달 + 배치 실행 로그 ─────────────────────────
fwd = collections.defaultdict(set)
for r in deps:
    if r["REFERENCED_TYPE"] in ("PROCEDURE", "PACKAGE", "FUNCTION") and r["NAME"] != r["REFERENCED_NAME"]:
        fwd[r["NAME"]].add(r["REFERENCED_NAME"])
jobs = list(csv.DictReader((D / "sched_jobs.csv").open(encoding="utf-8-sig")))
ident = re.compile(r"(?<![A-Za-z0-9_$#.'])([A-Za-z][A-Za-z0-9_$#]*)(?:\s*\.\s*([A-Za-z][A-Za-z0-9_$#]*))?")
batch_by = collections.defaultdict(set)       # object -> {job}
batch_root = collections.defaultdict(set)     # object -> {job} (JOB_ACTION 직접 호출)
for j in jobs:
    act = strip_sql_comments(j["JOB_ACTION"] or "").upper()
    act = re.sub(r"'[^']*'", "''", act)
    roots = set()
    for a, b in ident.findall(act):
        a = a.replace("SCM_MGR", "") or b
        if a in standalone or a in packages or a in functions: roots.add(a)
        elif a == "" and b and (b in standalone or b in packages): roots.add(b)
    stack, seen = list(roots), set(roots)
    for rt in roots: batch_root[rt].add(j["JOB_NAME"])
    while stack:                                 # 객체 단위 의존 폐포(보수적: 넓게 잡힘 → 삭제·이동 판정을 막는 방향)
        n = stack.pop(); batch_by[n].add(j["JOB_NAME"])
        for m in fwd.get(n, ()):
            if m not in seen: seen.add(m); stack.append(m)
cur.execute("SELECT UPPER(PROGRAM_NAME), COUNT(*), MAX(CREATION_DATE) FROM SCM_SYS_LOG_BATCH GROUP BY UPPER(PROGRAM_NAME)")
batch_log = {norm(n): (c, str(d)[:19]) for n, c, d in cur if n}

# ───────────────────────── 6-C. A7 텍스트 참조 — 동적 SQL·BE 코드 (의존 딕셔너리에 안 잡히는 호출) ─────────────────────────
cur.execute("SELECT NAME, TYPE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND TYPE IN ('PACKAGE BODY','PACKAGE','PROCEDURE','FUNCTION','TRIGGER','TYPE BODY') ORDER BY NAME, TYPE, LINE")
all_src = collections.defaultdict(list)
for n, t, tx in cur: all_src[(n, t)].append(tx or "")
all_src_up = {k: strip_sql_comments("".join(v)).upper() for k, v in all_src.items()}
be_code = {}
for f in pathlib.Path(r"C:\Projects\NSCM\nscm-be\src\main").rglob("*"):
    if f.suffix in (".java", ".xml", ".yml", ".properties"):
        be_code[str(f.relative_to(r"C:\Projects\NSCM\nscm-be"))] = f.read_text(encoding="utf-8", errors="ignore").upper()
text_refs = collections.defaultdict(set)
for sp in standalone:
    p = re.compile(r"(?<![A-Z0-9_$#])" + re.escape(sp) + r"(?![A-Z0-9_$#])")
    for (n, t), body in all_src_up.items():
        if n == sp: continue
        if sp in body and p.search(body):
            text_refs[sp].add(f"DB:{n}({t})")
    for fn, body in be_code.items():
        if sp in body and p.search(body): text_refs[sp].add(f"BE:{fn}")

# ───────────────────────── 7. standalone SP 판정 ─────────────────────────
cmbo_text = {r["SQL_ID"]: (r["SQL_TEXT"] or "").upper() for r in cmbo}
def refs_in_cmbo(name):
    p = re.compile(r"(?<![A-Z0-9_$#])" + re.escape(name) + r"(?![A-Z0-9_$#])")
    return sorted(k for k, t in cmbo_text.items() if p.search(t))
api_ref = collections.defaultdict(list)
for a in api:
    k, _, _, sp = resolve(a["API_URL"])
    if k == "STANDALONE_PROC": api_ref[sp].append(a["API_ID"])
excel_ref = collections.defaultdict(list)
for e in excel:
    k, _, _, sp = resolve(e["STORAGE_SQL_ID"])
    if k == "STANDALONE_PROC": excel_ref[sp].append(f"{e['PROGRAM_ID']}/{e['SHEET_NAME']}")

sp_rows = []
for sp in sorted(standalone):
    om = owner_menus(sp)                     # 모든 등록 뿌리 (공통 여부 판정 — 보수 방향)
    om_fe = owner_menus(sp, fe_only=True)    # FE 호출 확인 뿌리 (실사용 판정)
    in_m = sorted(m for m in om if m in scope_menus)
    out_m = sorted(m for m in om if m not in scope_menus)
    fe_m = sorted(m for m in om_fe if m in scope_menus)
    in_ui = sorted({ui_of(m) for m in fe_m})          # 전환 대상 판정 = FE 실사용 UI
    reg_in_ui = sorted({ui_of(m) for m in in_m})
    out_ui = sorted({ui_of(m) for m in out_m})
    all_ui = sorted(set(reg_in_ui) | set(out_ui))
    reg_rows = [r for r in ledger if r["STANDALONE"] == sp]
    fe_sheet_any = any(r["FE_SHEET"] == "Y" for r in reg_rows if r["SCOPE"] == "Y")
    cm = refs_in_cmbo(sp)
    live_callers = sorted(f"{cn}.{m}" if m and not m.startswith("(") else cn for cn, m in internal.get(sp, ()) if not m.startswith("("))
    dead_callers = sorted(cn for cn, m in internal.get(sp, ()) if m.startswith("("))
    lg = log_cnt_obj(sp)
    direct = any(e.startswith("등록:") for m in fe_m for e in om_fe[m])
    bjobs = sorted(batch_by.get(sp, ())); broot = sorted(batch_root.get(sp, ()))
    blog = batch_log.get(sp)
    # 배치 사용 = 스케줄러 JOB 도달만. SCM_SYS_LOG_BATCH 는 UI SP 도 PR_SCM_SYS_LOG_BATCH 로 기록하므로 배치 근거가 아니다(참고 컬럼)
    batch_used = bool(bjobs)
    txt_refs = text_refs.get(sp, set())
    # 의존 딕셔너리 밖 텍스트 참조(동적 SQL 등)가 다른 UI 객체에 있으면 그 UI 도 사용 UI 로 본다 (삭제·이동을 막는 보수 방향)
    dep_names = {c for c, _ in callers_dep.get(sp, ())}
    txt_ui = set()
    for x in txt_refs:
        if not x.startswith("DB:"): continue
        nm = x[3:].split("(")[0]
        if nm in dep_names: continue
        mm = re.fullmatch(r"PKG_([A-Z]{3}\d{4})", nm)
        if mm: txt_ui.add(mm.group(1))
        elif nm in standalone:
            txt_ui |= {ui_of(m) for m in owner_menus(nm)}
    extra_txt_ui = sorted(txt_ui - set(all_ui))
    if extra_txt_ui:
        all_ui = sorted(set(all_ui) | txt_ui)
    if in_ui and len(all_ui) == 1 and not batch_used:
        cls = "PKG전환대상" if direct else "PKG전환대상(내부호출)"
    elif in_ui and (len(all_ui) >= 2 or batch_used):
        cls = ("공통SP(텍스트참조 UI 포함)" if extra_txt_ui and len(set(reg_in_ui) | set(out_ui)) == 1 else "공통SP") if len(all_ui) >= 2 else "공통SP(UI+배치)"
    elif sp in framework:
        cls = "프레임워크공통(BE 매퍼 직접호출)"
    elif reg_in_ui and all(not menu_fe.get(m, {}).get("roots") for m in in_m):
        cls = "FE 화면 미구현 메뉴 사용(전환 보류)"
    elif reg_in_ui:
        cls = "등록됐으나 FE 미사용(배선 정리·삭제 후보)" if not batch_used and len(all_ui) == 1 else "등록됐으나 FE 미사용(타 UI·배치 사용 — 보류)"
    elif out_ui:
        cls = "범위외메뉴전용"
    elif batch_used:
        cls = "배치전용(UI 미도달)"
    elif api_ref.get(sp) or excel_ref.get(sp):
        cls = "API_M/EXCEL 등록만(버튼·메뉴 미배선)"
    elif cm or live_callers or lg or txt_refs:
        cls = "내부호출·콤보·로그 참조만(UI·배치 미도달)"
    else:
        cls = "미사용"
    target = ""
    if cls.startswith("PKG전환대상"):
        target = f"PKG_{in_ui[0]}"
    elif cls.startswith("등록됐으나 FE 미사용(배선"):
        target = f"PKG_{reg_in_ui[0]}"
    sp_rows.append(dict(SP=sp, STATUS=ostatus.get((sp, "PROCEDURE"), ""), 판정=cls, 사용UI=",".join(all_ui), FE사용UI=",".join(in_ui), FE확인메뉴=",".join(fe_m),
        범위내메뉴=",".join(in_m), 범위외메뉴=",".join(out_m), 등록시트=",".join(sorted(reg_sheet.get(sp, ()))),
        통합대상PKG=target, PKG존재="Y" if target in packages else ("N(신규)" if target else ""), 현재멤버수=len(pkg_mem.get(target, ())) if target else "",
        근거=" | ".join(sorted({e for v in om.values() for e in v}))[:1500],
        FE시트확인="Y" if fe_sheet_any else ("N" if reg_rows else "-(내부호출)"),
        열어보는화면=",".join(sorted({s for m in in_m for s in screen_ref.get(m, ())})),
        REF_API_M=",".join(sorted(set(api_ref.get(sp, [])))), REF_PROC_M=proc_m_cnt.get(sp, 0), REF_EXCEL=",".join(excel_ref.get(sp, [])),
        REF_CMBO=",".join(cm), REF_호출객체_LIVE=",".join(live_callers), REF_의존만=",".join(dead_callers),
        LOG건수=lg, LOG최종=log_last.get(sp, ""),
        배치JOB_직접=",".join(broot), 배치JOB_도달수=len(bjobs), 배치JOB_도달=",".join(bjobs)[:800],
        배치로그건수=blog[0] if blog else 0, 배치로그최종=blog[1] if blog else "",
        REF_텍스트_전체=",".join(sorted(txt_refs))[:800], 텍스트참조_추가UI=",".join(extra_txt_ui),
        REF_텍스트_의존외=",".join(sorted(x for x in txt_refs if not (x.startswith("DB:") and x[3:].split("(")[0] in {c for c, _ in callers_dep.get(sp, ())})))[:800],
        SCMP_APP_시노님="Y" if sp in app_syn else "N"))

# ───────────────────────── 8. 유사명 중복 ─────────────────────────
member_index = collections.defaultdict(list)
for p, ms in pkg_mem.items():
    for m in ms: member_index[m].append(p)
def usage_ev(key):
    """객체 사용 근거 — FE 실사용(FE 확인 등록 뿌리) / 등록만(FE 미확인) / 배치 / 로그"""
    fe = owner_menus(key, fe_only=True); allm = owner_menus(key)
    name = key.split(".")[0]
    ev = dict(
        fe=sorted(fe), reg_only=sorted(set(allm) - set(fe)),
        sheets=sorted(reg_sheet.get(key, ())),
        path=" / ".join(sorted({e for v in fe.values() for e in v}))[:300],
        batch=len(batch_by.get(name, ())) if "." not in key else 0,
        log=log_total.get(key, 0))
    return ev
sim_rows = []
spinfo = {r["SP"]: r for r in sp_rows}
for sp in sorted(standalone):
    cands = set()
    for nm in {sp, "P_" + sp, re.sub(r"^P_", "", sp)}:
        for p in member_index.get(nm, ()): cands.add((p, nm))
    for p, nm in sorted(cands):
        s = usage_ev(sp); m = usage_ev(f"{p}.{nm}")
        s_body = all_src_up.get((sp, "PROCEDURE"), "")
        wrapper = bool(re.search(r"(?<![A-Z0-9_$#])" + re.escape(p) + r"\s*\.\s*" + re.escape(nm) + r"(?![A-Z0-9_$#])", s_body))
        su = bool(s["fe"] or s["batch"] or sp in framework); mu = bool(m["fe"])
        if sp in framework:
            verdict = "standalone = 프레임워크(BE 매퍼 직접 호출) 사용 / PKG 멤버 " + ("FE 사용" if mu else "미사용 — 멤버 삭제 가능(BE 매퍼 전환 시에는 반대)")
        elif wrapper and su:
            verdict = "standalone 이 PKG 멤버를 감싸는 래퍼(FE 사용) — 래퍼 로직을 PKG 멤버로 흡수 후 재배선·standalone 삭제"
        elif su and mu:
            verdict = "배선 이원화 — 둘 다 FE 사용(한쪽으로 재배선 후 standalone 삭제)"
        elif su:
            verdict = "standalone 만 FE 사용 / PKG 멤버 미사용 — standalone→멤버 재배선 후 standalone 삭제(멤버 본문 동일성 확인)"
        elif mu:
            verdict = "PKG 멤버만 FE 사용 / standalone 미사용 — standalone 삭제 가능" + (" (standalone 은 FE 미사용 시트에 등록 잔존 → 배선 정리)" if s["reg_only"] else "")
        else:
            verdict = "둘 다 FE 사용 미확인 — 참조 확인 후 삭제 판단"
        fmt = lambda e: (f"FE사용메뉴:{','.join(e['fe'])}" if e["fe"] else "FE사용 없음") + \
            (f" | 등록만(FE미확인):{','.join(e['reg_only'])}" if e["reg_only"] else "") + \
            (f" | 배치JOB:{e['batch']}" if e["batch"] else "") + (f" | 로그:{e['log']}" if e["log"] else "") + \
            (f" | 등록시트:{','.join(e['sheets'])}" if e["sheets"] else "") + (f" | 경로:{e['path']}" if e["path"] else "")
        sim_rows.append(dict(STANDALONE=sp, PKG=p, MEMBER=nm, 래퍼="Y" if wrapper else "N",
                             standalone_근거=fmt(s)[:900], 멤버_근거=fmt(m)[:900], 판정=verdict, standalone_판정=spinfo[sp]["판정"]))
sim_by_sp = collections.defaultdict(list)
for r in sim_rows: sim_by_sp[r["STANDALONE"]].append(f"{r['PKG']}.{r['MEMBER']}")
for r in sp_rows: r["유사명_PKG멤버"] = ",".join(sim_by_sp.get(r["SP"], []))

# ───────────────────────── 9. UI별 요약 ─────────────────────────
ui_rows = []
for mid in scope_menus:
    rows = [r for r in ledger if r["MNU_ID"] == mid]
    pk = sorted({r["PKG"] for r in rows if r["PKG"]})
    sps = sorted({r["STANDALONE"] for r in rows if r["STANDALONE"]})
    internal_sps = sorted(r["SP"] for r in sp_rows if mid in r["범위내메뉴"].split(",") and r["SP"] not in sps)
    conv = sorted(r["SP"] for r in sp_rows if r["판정"].startswith("PKG전환대상") and mid in r["범위내메뉴"].split(","))
    common = sorted(r["SP"] for r in sp_rows if r["판정"].startswith("공통SP") and mid in r["범위내메뉴"].split(","))
    ui_rows.append(dict(MNU_ID=mid, UI=ui_of(mid), 유형=mnu_by.get(mid, {}).get("MNU_TP_CD", "(MNU_M 없음)"), 설명=mnu_by.get(mid, {}).get("MNU_DESC", ""),
        FE페이지="Y" if menu_fe.get(mid, {}).get("roots") else "N", 등록API행=len(rows),
        사용PKG=",".join(pk), 직접standalone=",".join(sps), 내부호출standalone=",".join(internal_sps),
        PKG전환대상=len(conv), 전환대상SP=",".join(conv), 공통SP=",".join(common),
        목표PKG=f"PKG_{ui_of(mid)}", 목표PKG존재="Y" if f"PKG_{ui_of(mid)}" in packages else "N",
        등록객체부재=sum(1 for r in rows if r["KIND"] in ("MISSING", "PKG_MEMBER_MISSING", "UNKNOWN_QUALIFIED")),
        FE시트미확인행=sum(1 for r in rows if r["FE_SHEET"] == "N"), 열어보는화면=",".join(sorted(screen_ref.get(mid, ())))))

json.dump(dict(scope_menus=scope_menus, menu_fe={m: dict(files=v["files"], roots=v["roots"]) for m, v in menu_fe.items()}),
          open(D / "fe_scope.json", "w", encoding="utf-8"), ensure_ascii=False, indent=1)
def dump(name, rows):
    if not rows: return
    with (D / f"{name}.csv").open("w", encoding="utf-8-sig", newline="") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys())); w.writeheader(); w.writerows(rows)
dump("out_ledger", ledger); dump("out_sp", sp_rows); dump("out_similar", sim_rows); dump("out_ui", ui_rows)
print("scope menus", len(scope_menus), [m for m in scope_menus if m not in screens])
print("판정", collections.Counter(r["판정"] for r in sp_rows))
print("similar pairs", len(sim_rows), collections.Counter(r["판정"] for r in sim_rows))
