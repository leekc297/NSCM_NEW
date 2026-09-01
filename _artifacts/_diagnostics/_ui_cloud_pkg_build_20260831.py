# -*- coding: utf-8 -*-
"""DMF0044 / DMF0049 클라우드 이관 패키지 생성기 (2026-08-28) — 0827 생성기 계보 + hook #148 G1~G6 흡수

  python _ui_cloud_pkg_build_20260828.py DMF0044 DMF0049   (또는 ALL)

0827 대비 추가 (hook #148 cloud-deploy-silent-failure-gates §3 생성기 의무):
  G1 40_GRANT_SYNONYM.sql   — A_DB 객체 전부의 사내 실측 EXECUTE + 앱계정 시노님
  G2 22A_SHEET_META_DEP_PROGRAMS.sql — PKG BODY 의 `:= 'DMFnnnn'` / PROGRAM_ID = 'DMFnnnn' 리터럴 스윕 → 종속 PROGRAM_ID 시트 메타
  G3 90_VERIFY V11(MNU_M+권한뷰) / V12(EXECUTE+시노님) / V13(종속 PROGRAM_ID 메타) / V14(동일 MNU_URL 타 MNU_ID 0행)
  G4 NLS 스캔 — 동적 SQL `CAST(x AS DATE)` / 마스크 없는 TO_DATE(식별자) 0건 ASSERT
  G5 procedures.d.ts 블록 = `  MENU: {` ~ 다음 top-level 직전(+ 위 JSDoc). 전체본 덮어쓰기 ⛔
  FE 이관 집합 = 화면 폴더 전체(그대로 복사) + **화면 import 폐포 ∩ 변경분**(FE_MERGE — 클라우드판과 diff 병합)
     변경분 = git 작업트리 변경 ∪ 기준 커밋 이후 커밋 변경 (기준 = 08-20 패키지 이후 첫 커밋의 부모)
  _survey/fe_check_YYYYMMDD.txt — 사용자 상시 지시(2026-08-23): 이관 취합 시 FE type-check+lint 결과 동봉
원칙: A_DB 는 사내 라이브 SELECT 만(DDL/DML 실행 없음). 실경로 구조 보존(hook §1.8). MERGE ON=PK 실측. GTT DDL 자급(-955 멱등).
"""
import io, os, re, sys, json, shutil, pathlib, datetime, subprocess
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb
from ora import conn_info

ROOT = pathlib.Path(r"C:\Projects\NSCM"); FE = ROOT / "nscm-fe"; PKGDIR = ROOT / "_artifacts" / "_deploy_packages"
STAMP = "20260831"
BASE_COMMIT = "4b740ab~1"   # 08-20 패키지(DMF0044/0049_CLOUD_20260820) 이후 첫 커밋(2026-08-26)의 부모 = 변경분 기준선
FE_CHECK_LOG = pathlib.Path(r"C:\Users\ejene\AppData\Local\Temp\claude\c--Projects-NSCM\042b60a9-4031-43a1-b506-d6823bb95c80\scratchpad\fe_check_all.txt")

CFG = {
    "DMF0014": dict(pkgs=["PKG_DMF0014"], gtt_prefix=["GT_DM14", "GT_DPCF"],
                    fe_dirs=[], fe_files=[],
                    fe_scan=["features/demand/src/pages/customer-fcst-upload"],
                    note="[E20260831] Excel Upload Validation 클라우드 확인용 재취합. DB = 사내 라이브 현재 기준 전량 "
                         "(0827 패키지 대비 delta: PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40 이 0827 18:12 취합 후 20:14 재배포 — 구 패키지 14번 파일은 구본). "
                         "FE = 이관 제외: customer-fcst-upload 6파일은 2026-08-31 공통소스(클라우드 원천) 반영에서 ADOPT_COMMON/SAME 실측 — 클라우드가 동본 또는 최신."),
    "DMF0074": dict(pkgs=["PKG_DMF0074"], gtt_prefix=["GT_DM74"],
                    fe_dirs=[], fe_files=[],
                    fe_scan=["features/demand/src/pages/metal-link-price"],
                    note="[E20260831] Excel Upload Validation 클라우드 확인용 재취합. DB = 사내 라이브 현재 기준 전량 "
                         "(BODY 08-27 16:17 — D4/D5 정정·D4-NOLOADGUARD 포함). "
                         "FE = 이관 제외: metal-link-price 모달 2본+store 2본은 2026-08-31 공통소스(클라우드 원천) 반영에서 ADOPT_COMMON/ADD 실측 — 클라우드가 동본 또는 최신. "
                         "⚠ 데이터 전제: MAX(SP_W·ATTRIBUTE7=Y) 버전에 SPW 원장(PLAN_C/RESULT_C) 실존해야 C19 계열·화면 조회 가능(90_VERIFY ANCHOR 판정)."),
}
META_TABLES = ["SCM_ADM_PROGRAM", "SCM_ADM_MNU_M", "SCM_ADM_USER_GR_MNU_MPG_M", "SCM_ADM_MNU_BTN_MPG_M",
               "SCM_ADM_USER_GR_MNU_BTN_MPG_M", "SCM_ADM_API_M"]
EXCLUDE_TABLES_NOTE = "SCM_MST_TITLESET_USER / SCM_ADM_USER_MNU_SRCH_COND_M / SCM_ADM_EXCEL_UPLOAD(스테이징) / *_BAK* 는 사용자·임시 데이터라 이관 제외"
APP_ACCTS = ("SCMP_APP", "SCMD_APP")

u, p, d = conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()

def q(sql, **b):
    cur.execute(sql, b); return cur.fetchall()
def cols_of(table):
    return [r[0] for r in q("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t ORDER BY COLUMN_ID", t=table)]
def pk_of(table):
    r = q("""SELECT CC.COLUMN_NAME FROM ALL_CONSTRAINTS C JOIN ALL_CONS_COLUMNS CC ON CC.OWNER=C.OWNER AND CC.CONSTRAINT_NAME=C.CONSTRAINT_NAME
             WHERE C.OWNER='SCM_MGR' AND C.TABLE_NAME=:t AND C.CONSTRAINT_TYPE='P' ORDER BY CC.POSITION""", t=table)
    if r: return [x[0] for x in r]
    r = q("""SELECT CC.COLUMN_NAME FROM ALL_CONSTRAINTS C JOIN ALL_CONS_COLUMNS CC ON CC.OWNER=C.OWNER AND CC.CONSTRAINT_NAME=C.CONSTRAINT_NAME
             WHERE C.OWNER='SCM_MGR' AND C.TABLE_NAME=:t AND C.CONSTRAINT_TYPE='U' ORDER BY C.CONSTRAINT_NAME, CC.POSITION""", t=table)
    return [x[0] for x in r]
def lit(v):
    if v is None: return "NULL"
    if isinstance(v, datetime.datetime): return f"TO_DATE('{v:%Y-%m-%d %H:%M:%S}','YYYY-MM-DD HH24:MI:SS')"
    if isinstance(v, (int, float)): return str(v)
    s = str(v).replace("'", "''")
    if "\n" in s or "\r" in s:
        parts = s.replace("\r\n", "\n").split("\n"); return "||CHR(10)||".join(f"'{x}'" for x in parts)
    return f"'{s}'"

# [E20260831-ONKEY] PK/UK 없는 테이블의 MERGE ON 폴백 = 논리키 (유일성은 사용 시점 실측 assert)
#   사고: SCM_ADM_EXCEL_COLUMNS 무 PK → `ON ()` ORA-00936 (DMF0074 클라우드 적용 실패 2026-08-31 사용자 실측)
LOGICAL_KEY_FALLBACK = {"SCM_ADM_EXCEL_COLUMNS": ["PROGRAM_ID", "SHEET_NAME"]}

def merge_sql(table, rows, cols, pk, tag):
    if not rows: return f"-- {table}: 0행\n"
    if not pk:
        pk = LOGICAL_KEY_FALLBACK.get(table)
        assert pk, f"{table}: PK/UK 부재 + 논리키 폴백 미등록 — MERGE ON 생성 불가 (ON () 방지)"
        dup = q(f"SELECT {', '.join(pk)} FROM SCM_MGR.{table} GROUP BY {', '.join(pk)} HAVING COUNT(*)>1 FETCH FIRST 1 ROWS ONLY")
        assert not dup, f"{table}: 논리키 {pk} 유일성 위반 실측 {dup[:1]} — 키 재선정 필요"
        tag = f"{tag} / 논리키 폴백 {pk} (PK 부재·유일성 실측)"
    out = [f"-- ── {table} {len(rows)}행 MERGE (ON = PK 실측 {pk}) [{tag}] ──"]
    nonkey = [c for c in cols if c not in pk]
    for r in rows:
        v = dict(zip(cols, r))
        src = ", ".join(f"{lit(v[c])} AS {c}" for c in cols)
        on = " AND ".join(f"T.{c}=S.{c}" for c in pk)
        upd = ", ".join(f"T.{c}=S.{c}" for c in nonkey if c not in {"CREATED_BY", "CREATION_DATE"})
        ins_cols = ", ".join(cols); ins_vals = ", ".join(f"S.{c}" for c in cols)
        out.append(f"MERGE INTO SCM_MGR.{table} T USING (SELECT {src} FROM DUAL) S ON ({on})\n"
                   f"WHEN MATCHED THEN UPDATE SET {upd}\nWHEN NOT MATCHED THEN INSERT ({ins_cols}) VALUES ({ins_vals});")
    return "\n".join(out) + "\n"

def insert_sql(table, rows, cols):
    return "\n".join(f"INSERT INTO SCM_MGR.{table} ({', '.join(cols)}) VALUES ({', '.join(lit(x) for x in r)});" for r in rows) + "\n"

def src_of(name, typ):
    return "".join(r[0] for r in q("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ))

# ───────────────────────── FE 변경분 + import 폐포 ─────────────────────────
def git_changed_set():
    def run(args):
        return subprocess.run(["git"] + args, cwd=str(ROOT), capture_output=True, text=True, encoding="utf-8", errors="replace").stdout
    files = set()
    for ln in run(["diff", "--name-only", BASE_COMMIT, "HEAD", "--", "nscm-fe"]).splitlines():
        if ln.strip(): files.add(ln.strip())
    for ln in run(["status", "--porcelain", "--", "nscm-fe"]).splitlines():
        if ln.strip(): files.add(ln[3:].strip().strip('"'))
    return {f[len("nscm-fe/"):] for f in files if f.startswith("nscm-fe/")}

ALIAS = {"@foundation": "packages/foundation/src", "@shared": "packages/shared/src", "@demand": "features/demand/src",
         "@master": "features/master/src", "@report": "features/report/src", "@admin": "features/admin/src", "@authority": "features/authority/src"}
IMPORT_RE = re.compile(r"""(?:^|\n)\s*(?:import|export)[^;'"]*?from\s+['"]([^'"]+)['"]|(?:^|\n)\s*import\s+['"]([^'"]+)['"]""")

def resolve(spec, from_file):
    if spec.startswith("."):
        base = (from_file.parent / spec)
    else:
        head = spec.split("/")[0]
        if head in ALIAS:
            rest = spec[len(head):].lstrip("/")
            base = FE / ALIAS[head] / rest if rest else FE / ALIAS[head]
        elif spec.startswith("features/"):
            base = FE / spec
        else:
            return None  # node_modules
    cands = [base, base.with_suffix(base.suffix + ".ts") if base.suffix else base.with_suffix(".ts"),
             pathlib.Path(str(base) + ".ts"), pathlib.Path(str(base) + ".tsx"), base / "index.ts", base / "index.tsx"]
    for c in cands:
        if c.is_file(): return c.resolve()
    return None

STMT_RE = re.compile(r"""(?:^|\n)[ \t]*((?:import|export)\b[^;]*?from\s+['"]([^'"]+)['"]|import\s+['"]([^'"]+)['"])""", re.S)
LOCAL_EXPORT_RE = re.compile(r"^\s*export\s+(?:default\s+)?(?:async\s+)?(?:const|let|var|function\*?|class|type|interface|enum|abstract\s+class)\s+([A-Za-z_$][\w$]*)", re.M)
LOCAL_EXPORT_LIST_RE = re.compile(r"^\s*export\s*\{([^}]*)\}\s*;?\s*$", re.M)  # export { a, b as c }  (from 없음)
_provides_memo = {}

def _names_in_braces(s):
    out = []
    for part in s.split(","):
        part = part.strip()
        if not part: continue
        part = re.sub(r"^type\s+", "", part)
        m = re.match(r"([A-Za-z_$][\w$]*)(?:\s+as\s+([A-Za-z_$][\w$]*))?", part)
        if m: out.append((m.group(1), m.group(2) or m.group(1)))  # (원명, 노출명)
    return out

def _stmt_symbols(head):
    """import/export 문 머리 → 요청 심볼 집합 (None = 전체/네임스페이스/사이드이펙트)"""
    if re.search(r"\*\s+as\s+\w+", head) or re.match(r"\s*export\s*\*\s*from", head): return None
    syms = set()
    m = re.search(r"\{([^}]*)\}", head)
    if m: syms.update(o for o, _ in _names_in_braces(m.group(1)))
    dm = re.match(r"\s*import\s+(?:type\s+)?([A-Za-z_$][\w$]*)\s*(?:,|from)", head)
    if dm: syms.add("default")
    return syms or None

def provides(f, sym):
    """f 가 sym 을 (직접 정의 또는 재수출로) 제공하는가 — 배럴 가지치기용. (파일, 심볼) 메모."""
    key = (f, sym)
    if key in _provides_memo: return _provides_memo[key]
    _provides_memo[key] = False
    if f.suffix not in (".ts", ".tsx"): return False
    txt = f.read_text(encoding="utf-8", errors="ignore")
    if sym == "default":
        ok = bool(re.search(r"^\s*export\s+default\b", txt, re.M))
    else:
        ok = sym in set(LOCAL_EXPORT_RE.findall(txt)) or any(sym == exp for m in LOCAL_EXPORT_LIST_RE.finditer(txt) for _, exp in _names_in_braces(m.group(1)))
    if not ok:
        for m in STMT_RE.finditer(txt):
            head, spec = m.group(1), m.group(2)
            if not spec or not head.lstrip().startswith("export"): continue
            r = resolve(spec, f)
            if not r: continue
            if re.match(r"\s*export\s*\*\s*from", head):
                if provides(r, sym): ok = True; break
            else:
                bm = re.search(r"\{([^}]*)\}", head)
                if bm:
                    for orig, exp in _names_in_braces(bm.group(1)):
                        if exp == sym and provides(r, orig): ok = True; break
                if ok: break
    _provides_memo[key] = ok
    return ok

def import_closure(start_files):
    """심볼 인지 폐포 — 배럴(index) 은 요청 심볼을 제공하는 가지만 따라간다(전 컴포넌트 끌려오는 과포함 방지)."""
    seen = {}  # file -> set(symbols) or None(전체)
    stack = [(pathlib.Path(f).resolve(), None) for f in start_files]
    while stack:
        f, want = stack.pop()
        if not f.is_file(): continue
        prev = seen.get(f, set())
        if f in seen and (prev is None or (want is not None and want <= prev)): continue
        seen[f] = None if (prev is None or want is None) else (prev | want)
        if f.suffix not in (".ts", ".tsx"): continue
        txt = f.read_text(encoding="utf-8", errors="ignore")
        for m in STMT_RE.finditer(txt):
            head, spec = m.group(1), (m.group(2) or m.group(3))
            r = resolve(spec, f)
            if not r: continue
            is_reexport = head.lstrip().startswith("export")
            syms = _stmt_symbols(head)
            if is_reexport:
                # 재수출은 이 파일에 요청된 심볼(want) 중 그 가지가 제공하는 것만 따라간다
                if want is None:
                    stack.append((r, None)); continue
                if syms is None:  # export * from
                    need = {s for s in want if provides(r, s)}
                else:
                    bm = re.search(r"\{([^}]*)\}", head); pairs = _names_in_braces(bm.group(1)) if bm else []
                    need = {orig for orig, exp in pairs if exp in want}
                if need: stack.append((r, need))
            else:
                stack.append((r, syms))
    return set(seen)

def dts_block(menu, text):
    """G5 — `  MENU: {` 로 시작하는 블록 ~ 다음 top-level(2칸 들여쓰기) 키 직전. 위 JSDoc(/** … */) 포함."""
    lines = text.splitlines()
    start = next((i for i, l in enumerate(lines) if re.match(rf"^  {menu}\s*:\s*\{{", l)), None)
    if start is None: return None, None
    s = start
    j = start - 1
    while j >= 0 and lines[j].strip() == "": j -= 1
    if j >= 0 and lines[j].strip().endswith("*/"):
        k = j
        while k >= 0 and not lines[k].strip().startswith("/**"): k -= 1
        if k >= 0: s = k
    end = len(lines)
    for i in range(start + 1, len(lines)):
        if re.match(r"^  [A-Za-z_][\w]*\s*:\s*\{", lines[i]) or re.match(r"^  /\*\*", lines[i]) or re.match(r"^\}", lines[i]):
            end = i; break
    while end > start and lines[end - 1].strip() == "": end -= 1
    return (s, end), "\n".join(lines[s:end])

def build(menu, changed):
    cfg = CFG[menu]; out = PKGDIR / f"{menu}_CLOUD_{STAMP}"
    if out.exists(): shutil.rmtree(out)
    (out / "A_DB").mkdir(parents=True); (out / "B_FE").mkdir(); (out / "_survey").mkdir()
    report = {"menu": menu, "stamp": STAMP, "db": {}, "fe": {"merge": []}, "notes": [cfg["note"], EXCLUDE_TABLES_NOTE], "gates": {}}
    A = out / "A_DB"
    def w(name, text, note=""):
        (A / name).write_text(text, encoding="utf-8"); report["db"][name] = note
    # ── 객체 축: PKG + 의존 객체 ──
    pkgs = list(cfg["pkgs"]); deps_std = []; gtts = set()
    for pk in list(pkgs):
        for (rn, rt) in q("""SELECT DISTINCT REFERENCED_NAME, REFERENCED_TYPE FROM ALL_DEPENDENCIES
                             WHERE OWNER='SCM_MGR' AND NAME=:n AND REFERENCED_OWNER='SCM_MGR' AND REFERENCED_TYPE IN ('PACKAGE','PROCEDURE','FUNCTION','TABLE','TYPE')""", n=pk):
            if rt == "PACKAGE" and rn not in pkgs and rn.startswith("PKG_DMF"): pkgs.append(rn)
            elif rt in ("PROCEDURE", "FUNCTION") and (rn, rt) not in deps_std: deps_std.append((rn, rt))
            elif rt == "TABLE" and rn.startswith("GT_"): gtts.add(rn)
    for pre in cfg["gtt_prefix"]:
        for (n,) in q("SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y' AND TABLE_NAME LIKE :p", p=pre + "%"): gtts.add(n)
    # 01 GTT DDL (멱등)
    cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SEGMENT_ATTRIBUTES',FALSE); DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',FALSE); END;")
    ddl = [f"-- 01_DDL_GTT.sql — {menu} GTT {len(gtts)}본 (DBMS_METADATA 신선 덤프, ORA-955 기존재 skip = 멱등) [{STAMP}]"]
    for g in sorted(gtts):
        cur.execute("SELECT DBMS_METADATA.GET_DDL('TABLE', :n, 'SCM_MGR') FROM DUAL", n=g); t = cur.fetchone()[0].read().strip()
        ddl.append(f"BEGIN EXECUTE IMMEDIATE q'[{t}]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE = -955 THEN NULL; ELSE RAISE; END IF; END;\n/")
        for (idx,) in q("SELECT INDEX_NAME FROM ALL_INDEXES WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t AND INDEX_TYPE='NORMAL' AND UNIQUENESS='NONUNIQUE'", t=g):
            cur.execute("SELECT DBMS_METADATA.GET_DDL('INDEX', :n, 'SCM_MGR') FROM DUAL", n=idx); it = cur.fetchone()[0].read().strip()
            ddl.append(f"BEGIN EXECUTE IMMEDIATE q'[{it}]'; EXCEPTION WHEN OTHERS THEN IF SQLCODE IN (-955,-1408) THEN NULL; ELSE RAISE; END IF; END;\n/")
    w("01_DDL_GTT.sql", "\n".join(ddl) + "\n", f"GTT {len(gtts)}본 (접두 {cfg['gtt_prefix']} + ALL_DEPENDENCIES)")
    # 10~ PKG (SPEC+BODY) + 의존 standalone
    n = 10; objs = []; bodies = {}
    for pk in pkgs:
        st = q("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n", n=pk)
        body = src_of(pk, "PACKAGE BODY"); bodies[pk] = body
        w(f"{n}_{pk}_SPEC.sql", "CREATE OR REPLACE " + src_of(pk, "PACKAGE") + "\n/\n", f"SPEC {st}")
        w(f"{n+1}_{pk}_BODY.sql", "CREATE OR REPLACE " + body + "\n/\n", f"BODY {st}")
        n += 2; objs.append(pk)
    for (rn, rt) in deps_std:
        s = src_of(rn, rt)
        if s: w(f"{n}_{rt}_{rn}.sql", "CREATE OR REPLACE " + s + "\n/\n", f"의존 {rt} (기이관이면 skip 가능)"); n += 1; objs.append(rn)
    # G4 NLS 스캔 (동적 SQL CAST AS DATE / 마스크 없는 TO_DATE(식별자))
    nls_hits = []
    for pk, body in bodies.items():
        for i, l in enumerate(body.splitlines(), 1):
            if re.search(r"CAST\s*\([^)]*AS\s+DATE\s*\)", l, re.I) or re.search(r"(?<![A-Z_])TO_DATE\s*\(\s*[A-Z_.]+\s*\)", l, re.I):
                nls_hits.append((pk, i, l.strip()[:120]))
    report["gates"]["G4_NLS_hits"] = nls_hits
    # 20 메뉴·배선·권한
    parts = [f"-- 20_MENU_WIRING_AUTH.sql — {menu} 메뉴/배선/권한 현재 기준 MERGE [{STAMP}]"]
    for t in META_TABLES:
        cols = cols_of(t); pk = pk_of(t)
        keycol = "PROGRAM_ID" if "PROGRAM_ID" in cols else ("MNU_ID" if "MNU_ID" in cols else "API_ID")
        rows = q(f"SELECT {', '.join(cols)} FROM SCM_MGR.{t} WHERE {keycol} LIKE :m ORDER BY {', '.join(pk or cols[:1])}", m=menu + "%")
        parts.append(merge_sql(t, rows, cols, pk, f"{keycol} LIKE '{menu}%'")); report["db"][f"20:{t}"] = len(rows)
    parts.append("COMMIT;"); w("20_MENU_WIRING_AUTH.sql", "\n".join(parts) + "\n", "MERGE ON PK 실측")
    # 24 PROC_M
    procs = sorted({r[0] for r in q("SELECT DISTINCT API_URL FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE :m AND API_TP_CD LIKE 'PROC%'", m=menu + "%")})
    pc = cols_of("SCM_ADM_PROC_M"); pl = [f"-- 24_PROC_M.sql — {menu} PROC_M (API_URL 기준 {len(procs)} SP, DELETE+INSERT — 이관 규약) [{STAMP}]"]
    for pn in procs:
        rows = q(f"SELECT {', '.join(pc)} FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:p ORDER BY SORT_ORD", p=pn)
        pl.append(f"DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM='{pn}';"); pl.append(insert_sql("SCM_ADM_PROC_M", rows, pc)); report["db"][f"24:{pn}"] = len(rows)
    pl.append("COMMIT;"); w("24_PROC_M.sql", "\n".join(pl) + "\n", f"{len(procs)} SP")
    # 22 SHEET_COLUMNS / SHEET_MEASURE (PROGRAM_ID, SHEET_NAME) 단위
    def sheet_meta_sql(prog, tag):
        sl = []; cnts = {}
        for t in ("SCM_MST_SHEET_COLUMNS", "SCM_MST_SHEET_MEASURE"):
            cols = cols_of(t)
            for (sh,) in q(f"SELECT DISTINCT SHEET_NAME FROM SCM_MGR.{t} WHERE PROGRAM_ID=:m", m=prog):
                rows = q(f"SELECT {', '.join(cols)} FROM SCM_MGR.{t} WHERE PROGRAM_ID=:m AND SHEET_NAME=:s ORDER BY SORT_ORDER_NO, COLUMN_NAME", m=prog, s=sh)
                sl.append(f"DELETE FROM SCM_MGR.{t} WHERE PROGRAM_ID='{prog}' AND SHEET_NAME={lit(sh)};"); sl.append(insert_sql(t, rows, cols))
                cnts[f"{tag}:{t}:{prog}/{sh}"] = len(rows)
        return sl, cnts
    sl, cnts = sheet_meta_sql(menu, "22"); report["db"].update(cnts)
    w("22_SHEET_META.sql", f"-- 22_SHEET_META.sql — {menu} SHEET_COLUMNS/MEASURE (PROGRAM_ID+SHEET_NAME 단위 DELETE 후 전체 재적재 — hook #98 §9) [{STAMP}]\n" + "\n".join(sl) + "\nCOMMIT;\n", "시트 단위 재적재")
    # G2 22A 종속 PROGRAM_ID (PKG BODY 리터럴 스윕)
    dep_progs = set()
    for pk, body in bodies.items():
        for m in re.finditer(r"(?:V_(?:P_)?PROGRAM_ID\s*:=\s*|PROGRAM_ID\s*=\s*)'(DMF\d{4}|SCM\d{4})'", body): dep_progs.add(m.group(1))
    dep_progs.discard(menu)
    sl2 = []; cnts2 = {}
    for dp in sorted(dep_progs):
        s_, c_ = sheet_meta_sql(dp, "22A"); sl2 += s_; cnts2.update(c_)
    report["db"].update(cnts2); report["gates"]["G2_dep_programs"] = sorted(dep_progs)
    w("22A_SHEET_META_DEP_PROGRAMS.sql", f"-- 22A — PKG BODY 가 V_PROGRAM_ID/PROGRAM_ID 리터럴로 읽는 종속 PROGRAM_ID {sorted(dep_progs)} 의 시트 메타 (hook #148 G2) [{STAMP}]\n"
      + ("\n".join(sl2) + "\nCOMMIT;\n" if sl2 else "-- 종속 PROGRAM_ID 없음 (또는 시트 메타 0행)\n"), f"종속 PROGRAM_ID {sorted(dep_progs)} / {sum(cnts2.values())}행")
    # 25 / 26
    ec = cols_of("SCM_ADM_EXCEL_COLUMNS"); rows = q(f"SELECT {', '.join(ec)} FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID LIKE :m", m=menu + "%")
    w("25_EXCEL_COLUMNS.sql", f"-- 25 EXCEL_COLUMNS {len(rows)}행 [{STAMP}]\n" + merge_sql("SCM_ADM_EXCEL_COLUMNS", rows, ec, pk_of("SCM_ADM_EXCEL_COLUMNS"), "PROGRAM_ID LIKE") + "COMMIT;\n", f"{len(rows)}행")
    lc = cols_of("SCM_ADM_LOOKUP_MASTER_DETAIL"); rows = q(f"SELECT {', '.join(lc)} FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE SEGMENT1 LIKE :m OR LOOKUP_TYPE LIKE :m", m=menu + "%")
    w("26_LOOKUP_DETAIL.sql", f"-- 26 LOOKUP_MASTER_DETAIL SEGMENT1/LOOKUP_TYPE LIKE '{menu}%' {len(rows)}행 [{STAMP}]\n" + merge_sql("SCM_ADM_LOOKUP_MASTER_DETAIL", rows, lc, pk_of("SCM_ADM_LOOKUP_MASTER_DETAIL"), "SEGMENT1") + "COMMIT;\n", f"{len(rows)}행")
    # 21 CMBO
    combo_ids = set()
    for sdir in cfg["fe_scan"]:
        for f in (FE / sdir).rglob("*.ts*"):
            if ".test." in f.name: continue
            txt = f.read_text(encoding="utf-8", errors="ignore")
            for m in re.finditer(r"filters:\s*\[([^\]]*)\]", txt): combo_ids.update(re.findall(r"'([^']+)'", m.group(1)))
            for m in re.finditer(r"ROW_COMBO_IDS\s*=\s*\{([^}]*)\}", txt): combo_ids.update(re.findall(r":\s*'([^']+)'", m.group(1)))
            combo_ids.update(re.findall(r"cellCboDataTp:\s*'([^']+)'", txt))
            combo_ids.update(re.findall(r"comboId:\s*'([^']+)'", txt))
    for (c,) in q("SELECT DISTINCT CELL_COMBO_DATA_TYPE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:m AND CELL_COMBO_DATA_TYPE IS NOT NULL AND TRIM(CELL_COMBO_DATA_TYPE) IS NOT NULL", m=menu): combo_ids.add(c)
    cc = cols_of("SCM_ADM_CMBO_SQL_M"); crow = []
    for cid in sorted(combo_ids):
        crow += q(f"SELECT {', '.join(cc)} FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:s", s=cid)
    shared = {r[0]: len(q("SELECT DISTINCT PROGRAM_ID FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE CELL_COMBO_DATA_TYPE=:s", s=r[0])) for r in crow}
    w("21_CMBO_SQL.sql", f"-- 21 CMBO_SQL_M — FE 소비(useTabComboQueries filters / ROW_COMBO_IDS / cellCboDataTp) + SHEET_COLUMNS 셀콤보 {len(crow)}본 [{STAMP}]\n"
      f"-- ⚠ 공유 콤보(타 화면 소비)는 덮어쓰기 전 클라우드판 diff 확인: {json.dumps(shared, ensure_ascii=False)}\n"
      + merge_sql("SCM_ADM_CMBO_SQL_M", crow, cc, pk_of("SCM_ADM_CMBO_SQL_M"), "SQL_ID") + "COMMIT;\n", f"{len(crow)}본 (FE 요청 {len(combo_ids)}: 미등재 {sorted(combo_ids - {r[0] for r in crow})})")
    # 23 MSG/LBL/MNU
    codes = set()
    for sdir in cfg["fe_scan"]:
        for f in (FE / sdir).rglob("*.ts*"): codes.update(re.findall(r"\b(?:MSG|LBL)\d{5}\b", f.read_text(encoding="utf-8", errors="ignore")))
    for pk in pkgs: codes.update(re.findall(r"\b(?:MSG|LBL)\d{5}\b", bodies[pk]))
    for (aid,) in q("SELECT API_MSG_ID FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE :m", m=menu + "%"):
        if aid and aid != "-": codes.add(aid)
    for (mid,) in q("SELECT MSG_ID FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_TP_CD='MNU' AND (MSG_ID LIKE :m OR MSG_ID IN (SELECT MNU_MSG_ID FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID=:x))", m="%" + menu + "%", x=menu): codes.add(mid)
    mc = cols_of("SCM_ADM_MSG_M"); mrows = []
    for c in sorted(codes): mrows += q(f"SELECT {', '.join(mc)} FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID=:c ORDER BY LANG_CD", c=c)
    missing = sorted(codes - {r[0] for r in mrows})
    w("23_MSG_LBL_MNU.sql", f"-- 23 SCM_ADM_MSG_M {len(mrows)}행 ({len(codes)}코드 × 언어) — FE·PKG·API_MSG·MNU 기계 추출 [{STAMP}]\n-- 메타 미존재 코드(FE 참조하나 사내 MSG_M 없음): {missing}\n"
      + merge_sql("SCM_ADM_MSG_M", mrows, mc, pk_of("SCM_ADM_MSG_M"), "MSG_ID,LANG_CD") + "COMMIT;\n", f"{len(mrows)}행 / 미존재 {missing}")
    # G1 40 GRANT + SYNONYM (사내 실측 재현)
    gl = [f"-- 40_GRANT_SYNONYM.sql — {menu} 앱 계정 EXECUTE 권한 + private synonym (사내 실측 재현, 멱등) [{STAMP}] (hook #148 G1)",
          "-- 실행 계정: SCM_MGR (GRANT) + CREATE ANY SYNONYM 권한 보유 계정. 클라우드 QA 에는 SCMD_APP 계정이 없음(2026-08-28 실측) → 해당 행 ORA-01917 은 무시."]
    for o in objs:
        rows = q("SELECT GRANTEE, PRIVILEGE FROM ALL_TAB_PRIVS WHERE TABLE_SCHEMA='SCM_MGR' AND TABLE_NAME=:n AND GRANTEE IN ('SCMP_APP','SCMD_APP') ORDER BY 1", n=o)
        syns = q("SELECT OWNER FROM ALL_SYNONYMS WHERE TABLE_OWNER='SCM_MGR' AND TABLE_NAME=:n AND SYNONYM_NAME=:n AND OWNER IN ('SCMP_APP','SCMD_APP') ORDER BY 1", n=o)
        gl.append(f"\n-- {o}: 사내 EXECUTE={[g for g,_ in rows]} / 시노님={[s for (s,) in syns]}")
        for g, pv in rows:
            if pv == "EXECUTE": gl.append(f"GRANT EXECUTE ON SCM_MGR.{o} TO {g};")
        for (s,) in syns: gl.append(f"CREATE OR REPLACE SYNONYM {s}.{o} FOR SCM_MGR.{o};")
    w("40_GRANT_SYNONYM.sql", "\n".join(gl) + "\n", f"대상 {len(objs)}: {objs}")
    # 90 VERIFY (+ V11~V14)
    v = [f"-- 90_VERIFY.sql — {menu} 적용 확인 [{STAMP}]",
         f"SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'MM-DD HH24:MI') LAST_DDL FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ({', '.join(lit(x) for x in pkgs)}) ORDER BY 1,2;",
         f"SELECT COUNT(*) AS INVALID_CNT FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID' AND OBJECT_NAME IN ({', '.join(lit(x) for x in objs)});"]
    for t in META_TABLES:
        keycol = "PROGRAM_ID" if "PROGRAM_ID" in cols_of(t) else ("MNU_ID" if "MNU_ID" in cols_of(t) else "API_ID")
        v.append(f"-- 기대 {report['db'].get('20:'+t)}\nSELECT '{t}' T, COUNT(*) CNT FROM SCM_MGR.{t} WHERE {keycol} LIKE '{menu}%';")
    for k, cnt in report["db"].items():
        if k.startswith("22:") or k.startswith("22A:"):
            _, t, ps = k.split(":", 2); prog, sh = ps.split("/", 1)
            v.append(f"-- 기대 {cnt}\nSELECT '{t}/{prog}/{sh}' T, COUNT(*) CNT FROM SCM_MGR.{t} WHERE PROGRAM_ID='{prog}' AND SHEET_NAME={lit(sh)};")
    v.append(f"-- 기대 {len(gtts)}\nSELECT COUNT(*) AS GTT_CNT FROM ALL_TABLES WHERE OWNER='SCM_MGR' AND TEMPORARY='Y' AND TABLE_NAME IN ({', '.join(lit(x) for x in sorted(gtts)) or 'NULL'});")
    mnu_url = q("SELECT MNU_URL, ROUTE_PATH FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID=:m", m=menu)
    murl, mroute = (mnu_url[0] if mnu_url else ("", ""))
    v += ["", "-- ── V11~V14 조용한-실패 게이트 (hook #148) ──",
          f"-- V11 메뉴 행 실존 (기대 1행, UNIT_TP_CD='D', USE_YN='Y') — 부재 시 권한 뷰 INNER JOIN 으로 오류 없이 0행\nSELECT 'V11-MNU' G, MNU_ID, UNIT_TP_CD, USE_YN, MNU_URL, ROUTE_PATH FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='{menu}';",
          f"-- V11-B 테스트 계정 권한 뷰 (기대 ≥1, 조회 Division 포함) — <TEST_USER> 치환\nSELECT 'V11-AUTH' G, UNIT_ID, EDIT_YN FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V WHERE USER_ID='<TEST_USER>' AND MNU_ID='{menu}' ORDER BY 2;",
          f"-- V12 앱 계정 EXECUTE + 시노님 (기대: 객체별 SCMP_APP 각 1행 — 없으면 40_GRANT_SYNONYM.sql)\nSELECT 'V12-GRANT' G, TABLE_NAME, GRANTEE FROM ALL_TAB_PRIVS WHERE TABLE_SCHEMA='SCM_MGR' AND PRIVILEGE='EXECUTE' AND GRANTEE='SCMP_APP' AND TABLE_NAME IN ({', '.join(lit(x) for x in objs)}) ORDER BY 2;",
          f"SELECT 'V12-SYN' G, SYNONYM_NAME FROM ALL_SYNONYMS WHERE OWNER='SCMP_APP' AND TABLE_OWNER='SCM_MGR' AND SYNONYM_NAME IN ({', '.join(lit(x) for x in objs)}) ORDER BY 2;",
          f"-- V13 종속 PROGRAM_ID 시트 메타 (기대: 각 PROGRAM_ID > 0 — 22/22A 주석 값)\nSELECT 'V13-META' G, PROGRAM_ID, 'COLUMNS' T, COUNT(*) CNT FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID IN ({', '.join(lit(x) for x in [menu] + sorted(dep_progs))}) GROUP BY PROGRAM_ID\nUNION ALL SELECT 'V13-META', PROGRAM_ID, 'MEASURE', COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID IN ({', '.join(lit(x) for x in [menu] + sorted(dep_progs))}) GROUP BY PROGRAM_ID ORDER BY 2,3;",
          f"-- V14 동일 MNU_URL/ROUTE_PATH 를 가진 타 MNU_ID (기대 0행 — DMF0035/SCM0020 사고 계보: 그 메뉴로 진입하면 오류 없이 0행)\nSELECT 'V14-DUPURL' G, MNU_ID, UPPR_MNU_ID, MNU_URL, ROUTE_PATH, USE_YN FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID <> '{menu}' AND (MNU_URL = {lit(murl)} OR ROUTE_PATH = {lit(mroute)});"]
    w("90_VERIFY.sql", "\n".join(v) + "\n", "기대 카운트 실측 + V11~V14")
    # ── B_FE: 화면 폴더 전체 ──
    copied = []; screen_files = []
    for rel in cfg["fe_dirs"]:
        for f in (FE / rel).rglob("*"):
            if f.is_file():
                dst = out / "B_FE" / f.relative_to(FE); dst.parent.mkdir(parents=True, exist_ok=True); shutil.copy2(f, dst)
                copied.append(str(f.relative_to(FE)).replace("\\", "/"))
                if f.suffix in (".ts", ".tsx"): screen_files.append(f)
    if cfg["fe_dirs"]:  # [E20260831] FE 미동봉 구성(fe_dirs=[])은 게이트 대상 외 — 게이트 의도 = 화면 폴더 동봉 시 등록 키 누락 방지
        assert any(c.endswith("/index.ts") for c in copied), "viewRegistry 등록 키 index.ts 부재 — 이관 불가 (feedback_deploy_fe_partial_folder_notfound)"
    # ── FE_MERGE: import 폐포 ∩ 변경분 (+ procedures.d.ts 블록) ──
    closure = import_closure(screen_files)
    screen_roots = [(FE / r).resolve() for r in cfg["fe_dirs"]]
    ext = []
    for f in sorted(closure):
        if any(str(f).startswith(str(r)) for r in screen_roots): continue
        rel = str(f.relative_to(FE)).replace("\\", "/")
        if rel in changed: ext.append(rel)
    merged = []
    for rel in ext:
        src = FE / rel; dst = out / "FE_MERGE" / rel; dst.parent.mkdir(parents=True, exist_ok=True); shutil.copy2(src, dst); merged.append(rel)
    # procedures.d.ts 블록 (G5)
    dts = FE / "configs/types/procedures.d.ts"; text = dts.read_text(encoding="utf-8", errors="ignore")
    rng, blk = dts_block(menu, text)
    if blk:
        sheet_keys = re.findall(r'^    ([A-Za-z_][A-Za-z0-9_]*)\s*:\s*\{', blk, re.M)
        (out / "FE_MERGE").mkdir(exist_ok=True)
        (out / "FE_MERGE" / f"procedures.d.ts.{menu}_BLOCK.txt").write_text(
            f"// procedures.d.ts 중 {menu} 계약 블록 (L{rng[0]+1}~L{rng[1]}) — 클라우드판의 같은 키 블록만 교체. 전체본 덮어쓰기 ⛔\n"
            f"// 시트 키: {sheet_keys}\n" + blk + "\n", encoding="utf-8")
        merged.append(f"procedures.d.ts.{menu}_BLOCK.txt (L{rng[0]+1}~L{rng[1]}, 시트 키 {sheet_keys})")
    report["fe"]["merge"] = merged
    # 화면 폴더가 참조하는 페이지 밖 피처 모듈
    ext_imports = set()
    for f in screen_files:
        for m in re.finditer(r"from\s+'((?:features/|@(?:master|demand|report|admin)/)[^']+)'", f.read_text(encoding="utf-8", errors="ignore")): ext_imports.add(m.group(1))
    report["fe"].update({"files": copied, "external_feature_imports": sorted(ext_imports), "closure_size": len(closure),
                         "closure_changed_outside_screen": ext, "changed_set_size": len(changed)})
    # ── _survey: fe_check ──
    if FE_CHECK_LOG.exists():
        shutil.copy2(FE_CHECK_LOG, out / "_survey" / f"fe_check_{STAMP}.txt"); report["notes"].append(f"_survey/fe_check_{STAMP}.txt 동봉 (전체 lint + type-check)")
    else:
        report["notes"].append("⚠ fe_check 로그 부재 — 별도 실행 필요")
    # ── README / FILELIST ──
    files = sorted(str(f.relative_to(out)).replace("\\", "/") for f in out.rglob("*") if f.is_file())
    (out / "_FILELIST.md").write_text("\n".join(files) + "\n", encoding="utf-8")
    (out / "_survey" / "survey.json").write_text(json.dumps(report, ensure_ascii=False, indent=1, default=str), encoding="utf-8")
    db_rows = "\n".join(f"| {k} | {v} |" for k, v in report["db"].items() if ":" not in k)
    axes = "\n".join(f"| {k} | {v} |" for k, v in report["db"].items() if ":" in k)
    readme = f"""# {menu}_CLOUD_{STAMP} — 클라우드 이관 패키지 (사내 DB 현재 기준 신선 덤프 · FE 실경로 구조 · 이관 대상만)

생성 {datetime.datetime.now():%Y-%m-%d %H:%M} · 생성기 `_artifacts/_diagnostics/_ui_cloud_pkg_build_{STAMP}.py {menu}` (SELECT 만 — DDL/DML 실행 없음)
{cfg['note']}
{EXCLUDE_TABLES_NOTE}
⭐ 클라우드는 **QA·DEV 두 DB 모두** 적용 (2026-08-04 사용자 확정).

## 적용 순서 (A_DB)
`01_DDL_GTT` → `10~ PKG SPEC/BODY`(의존 PKG·PROC·FUNCTION 포함 — 기이관이면 diff 후 skip) → **`40_GRANT_SYNONYM`** → `20_MENU_WIRING_AUTH` → `24_PROC_M` → `22_SHEET_META` → `22A_SHEET_META_DEP_PROGRAMS` → `21_CMBO_SQL`(⚠ 공유 콤보 diff) → `23_MSG_LBL_MNU` → `25_EXCEL_COLUMNS` → `26_LOOKUP_DETAIL` → (B_FE / FE_MERGE 배포) → `90_VERIFY`(V11~V14 포함, `<TEST_USER>` 치환)
DBeaver Execute Script(Ctrl+Alt+X) / SQLcl `@file`. PKG 파일은 `/` 종결.

## A_DB 파일
| 파일 | 내용 |
|---|---|
{db_rows}

## 메타 축 행수 (사내 현재 기준 = VERIFY 기대값)
| 축 | 행수 |
|---|---|
{axes}

## 게이트 (hook #148 생성기 의무)
- G1 GRANT/시노님 대상 {len(objs)}: {objs}
- G2 종속 PROGRAM_ID: {sorted(dep_progs) or '없음'}
- G4 NLS 스캔(동적 CAST AS DATE / 마스크 없는 TO_DATE): {len(nls_hits)}건 {nls_hits[:5]}
- G5 procedures.d.ts 블록 경계: {'L%d~L%d' % (rng[0]+1, rng[1]) if blk else '⚠ 블록 없음'}

## B_FE ({len(copied)} 파일 — **그대로 복사**: 화면 폴더 전체, 실경로 `nscm-fe/` 기준 구조 보존)
""" + "\n".join(f"- `{f}`" for f in copied) + f"""

## FE_MERGE ({len(merged)} — **그대로 덮어쓰기 금지**: 클라우드판과 diff 병합)
화면에서 import 로 도달하는 파일(폐포 {len(closure)}본) 중 **기준선({BASE_COMMIT}) 이후 변경분 ∩** = 아래. 화면이 참조하지 않는 변경 파일은 이 패키지에 넣지 않았다(이관 대상만).
""" + "\n".join(f"- `{f}`" for f in merged) + f"""
- `procedures.d.ts` → 전체 파일이 아니라 동봉한 `procedures.d.ts.{menu}_BLOCK.txt` 의 화면 블록만 이식(다른 화면 블록은 클라우드판 유지).
- `packages/**` 공용 → 클라우드 공통소스판과 3-way diff 후 마커 구간만 반영. 공용 파일은 다른 화면(DMF0082/0021 등)의 변경도 함께 담고 있을 수 있다 — diff 로 판단.
- `apps/web/**`(mdi 셸·viewRegistry) 는 세대 혼재라 파일 단위 덮어쓰기 ⛔ — 본 패키지 제외.

화면 폴더가 참조하는 **페이지 밖 피처 모듈**(클라우드에 기존재해야 함 — 부재 시 별도 이관): {sorted(ext_imports) or '없음'}

## _survey
- `fe_check_{STAMP}.txt` — 작업 트리 전체 lint + type-check (사용자 상시 지시). 기준선 2026-08-23: type-check 123 / lint 79 (BACKUP 폴더·SDM1010 계약 충돌 등 기존 잔재).
- `survey.json` — 생성 근거 전문.
"""
    (out / "README.md").write_text(readme, encoding="utf-8")
    print(f"[{menu}] → {out}  A_DB {len(list(A.iterdir()))}파일 / B_FE {len(copied)}파일 / FE_MERGE {len(merged)} / GTT {len(gtts)} / PKG {pkgs} / 의존 {deps_std}")
    for k, vv in report["db"].items():
        if ":" in k: print(f"    {k} = {vv}")
    print("    G2 dep:", sorted(dep_progs), "| G4 NLS:", nls_hits, "| G5:", rng)
    print("    FE_MERGE:", merged)
    print("    FE 외부 import:", sorted(ext_imports))

if __name__ == "__main__":
    targets = sys.argv[1:] or ["ALL"]
    changed = git_changed_set()
    print(f"변경분(기준 {BASE_COMMIT}..HEAD + 작업트리): {len(changed)} 파일")
    for m in (list(CFG) if targets == ["ALL"] else targets): build(m, changed)

