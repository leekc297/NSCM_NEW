#!/usr/bin/env python3
"""
04_parse_dynamic.py — 동적 SQL 내 객체 4-경로 추출 + 콤보 SQL 파싱
경로: ①ALL_SOURCE 정적 파싱 ②V$SQL/V$SQL_PLAN ③AWR(ASH 귀속) ④SCM_COM_SQL_LOG
출력: dynamic_static.csv / dynamic_vsql.csv / dynamic_awr.csv / sql_log_tables.csv /
      combo_tables.csv / dynamic_report.txt
"""
import csv, re, pathlib
from collections import defaultdict

HERE = pathlib.Path(__file__).resolve().parent
OWNERS = ("SCM_MGR", "SCMD_APP", "SCMC", "FP_MGR", "INF_MGR", "ENG_SCP", "OPT_MGR")

def load(name):
    with (HERE / f"{name}.csv").open(encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))

def wcsv(name, header, rows):
    with (HERE / name).open("w", newline="", encoding="utf-8-sig") as f:
        w = csv.writer(f); w.writerow(header); w.writerows(rows)
    print(f"{name}: {len(rows)} rows")

# ---------- 카탈로그 ----------
objects = defaultdict(list)
by_id = {}
for r in load("all_objects"):
    objects[(r["OWNER"], r["OBJECT_NAME"])].append(r["OBJECT_TYPE"])
    by_id[r["OBJECT_ID"]] = (r["OWNER"], r["OBJECT_NAME"], r["OBJECT_TYPE"])
syn = {}
for r in load("all_synonyms"):
    syn[(r["OWNER"], r["SYNONYM_NAME"])] = (r["TABLE_OWNER"], r["TABLE_NAME"])

def resolve(ident):
    """식별자 -> (owner,name) or None (카탈로그 검증)"""
    ident = ident.strip().upper().strip('"')
    if "." in ident:
        o, n = ident.split(".", 1)
        if o in OWNERS and (o, n) in objects:
            return (o, n)
        if (o, n) in syn:
            return syn[(o, n)]
        return None
    for o in OWNERS:
        if (o, ident) in objects:
            return (o, ident)
        if (o, ident) in syn:
            t = syn[(o, ident)]
            return t if t[0] in OWNERS else None
    if ("PUBLIC", ident) in syn:
        t = syn[("PUBLIC", ident)]
        return t if t[0] in OWNERS else None
    return None

# unit -> UIs (closure 기반)
unit_uis = defaultdict(set)
for r in load("closure"):
    if r["TYPE"] in ("PACKAGE", "PROCEDURE", "FUNCTION", "TRIGGER", "TYPE"):
        unit_uis[(r["OWNER"], r["OBJECT_NAME"])].add(r["UI"])

# ---------- SQL 텍스트 → 테이블 추출 ----------
IDENT = r'[A-Za-z_][\w$#]*(?:\s*\.\s*[A-Za-z_][\w$#]*)?'
KW = re.compile(
    r'\b(?:FROM|JOIN|INTO|UPDATE|MERGE\s+INTO|DELETE\s+FROM|TRUNCATE\s+TABLE|ALTER\s+TABLE|'
    r'LOCK\s+TABLE|TABLE\s*\(\s*)\s+(' + IDENT + r')',
    re.IGNORECASE)
LIST_CONT = re.compile(r'\s*,\s*(' + IDENT + r')')
STOPWORDS = {"SELECT", "DUAL", "WHERE", "SET", "VALUES", "THE", "AND", "OR"}

def strip_comments(sql):
    sql = re.sub(r'--[^\n]*', ' ', sql)
    sql = re.sub(r'/\*.*?\*/', ' ', sql, flags=re.DOTALL)
    return sql

SEQ_RE = re.compile(r'\b([A-Za-z_][\w$#]*)\s*\.\s*(?:NEXTVAL|CURRVAL)\b', re.IGNORECASE)

def extract_tables(sql):
    out = set()
    sql = strip_comments(sql)
    for m in SEQ_RE.finditer(sql):
        out.add(m.group(1))
    for m in KW.finditer(sql):
        cand = re.sub(r'\s+', '', m.group(1))
        if cand.upper() in STOPWORDS:
            continue
        out.add(cand)
        pos = m.end()
        while True:  # FROM A, B, C
            m2 = LIST_CONT.match(sql, pos)
            if not m2:
                break
            c2 = re.sub(r'\s+', '', m2.group(1))
            if c2.upper() not in STOPWORDS:
                out.add(c2)
            pos = m2.end()
    return out

# ---------- ① ALL_SOURCE 정적 파싱 ----------
DYN_RE = re.compile(r'EXECUTE\s+IMMEDIATE|OPEN\s+\w+\s+FOR\s+(?!\s*(?:SELECT|WITH)\b)|DBMS_SQL\.PARSE',
                    re.IGNORECASE)
STR_LIT = re.compile(r"'((?:[^']|'')*)'", re.DOTALL)
NONLIT = re.compile(r"\|\|\s*(?!\s*')")

static_rows, static_units, manual_units = [], [], []
for sf in sorted((HERE / "sources").glob("*.sql")):
    owner, name = sf.name.split(".", 2)[:2]
    body = sf.read_text(encoding="utf-8", errors="ignore")
    code = strip_comments(body)
    dyn_points = len(DYN_RE.findall(code))
    if dyn_points == 0:
        continue
    nonlit = bool(NONLIT.search(code))
    found = set()
    for m in STR_LIT.finditer(code):
        lit = m.group(1).replace("''", "'")
        if len(lit) < 8:
            continue
        for cand in extract_tables(lit):
            k = resolve(cand)
            if k:
                found.add(k)
    uis = sorted(unit_uis.get((owner, name), {"?"}))
    static_units.append([owner, name, dyn_points, "Y" if nonlit else "", len(found), ";".join(uis)])
    if not found:
        # EXECUTE IMMEDIATE 직후 리터럴이 전부 세션설정/트랜잭션 제어이면 수동확인 불필요
        lits = re.findall(r"EXECUTE\s+IMMEDIATE\s*'([^']*)", code, re.IGNORECASE)
        if lits and all(re.match(r'\s*(ALTER\s+SESSION|COMMIT|ROLLBACK)', l, re.IGNORECASE) for l in lits):
            manual_units.append(f"{owner}.{name} (dyn_points={dyn_points}, ALTER SESSION만 — 객체무관, 확인불요)")
        else:
            manual_units.append(f"{owner}.{name} (dyn_points={dyn_points}, 추출 0 — 수동확인)")
    for o, n in sorted(found):
        static_rows.append([owner, name, o, n, ";".join(uis)])
wcsv("dynamic_static.csv", ["SRC_OWNER", "SRC_UNIT", "OBJECT_OWNER", "OBJECT_NAME", "UIS"], static_rows)
wcsv("dynamic_static_units.csv", ["OWNER", "UNIT", "DYN_POINTS", "NONLITERAL", "OBJ_FOUND", "UIS"],
     static_units)

# ---------- ② V$SQL ----------
vs_rows = []
for r in load("vsql_plan_objects"):
    unit = by_id.get(r["PROGRAM_ID"])
    if unit:
        uis = sorted(unit_uis.get((unit[0], unit[1]), set()))
        src = f"{unit[0]}.{unit[1]}"
    else:
        uis, src = (["COMMON"], f"(비PLSQL:{r['MODULE']})") if r["PROGRAM_ID"] in ("0", "") else (["?"], f"(미해석 PROGRAM_ID={r['PROGRAM_ID']})")
    vs_rows.append([r["SQL_ID"], src, ";".join(uis) or "?",
                    r["OBJECT_OWNER"], r["OBJECT_NAME"], r["OBJECT_TYPE"]])
wcsv("dynamic_vsql.csv", ["SQL_ID", "SRC_UNIT", "UIS", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE"], vs_rows)

# ---------- ③ AWR (ASH 귀속) ----------
ash = defaultdict(set)   # sql_id -> units
for r in load("awr_ash_attribution"):
    u = by_id.get(r["PLSQL_ENTRY_OBJECT_ID"])
    if u:
        ash[r["SQL_ID"]].add((u[0], u[1]))
awr_rows, awr_unattr = [], 0
for r in load("awr_plan_objects"):
    units = ash.get(r["SQL_ID"], set())
    if not units:
        awr_unattr += 1
        continue
    for u in sorted(units):
        uis = sorted(unit_uis.get(u, set()))
        if not uis:
            continue
        awr_rows.append([r["SQL_ID"], f"{u[0]}.{u[1]}", ";".join(uis),
                         r["OBJECT_OWNER"], r["OBJECT_NAME"], r["OBJECT_TYPE"]])
wcsv("dynamic_awr.csv", ["SQL_ID", "SRC_UNIT", "UIS", "OBJECT_OWNER", "OBJECT_NAME", "OBJECT_TYPE"], awr_rows)

# ---------- ④ SCM_COM_SQL_LOG ----------
log_tab = defaultdict(int)
for r in load("sql_log_distinct"):
    for cand in extract_tables(r["SQL_TEXT_1000"]):
        k = resolve(cand)
        if k:
            log_tab[k] += int(r["EXEC_CNT"] or 1)
wcsv("sql_log_tables.csv", ["OBJECT_OWNER", "OBJECT_NAME", "EXEC_CNT"],
     [[o, n, c] for (o, n), c in sorted(log_tab.items())])

# ---------- 콤보 CLOB 파싱 + UI 매핑(2경로 합집합) ----------
combo_ui = defaultdict(set)
for r in load("combo_ui"):
    combo_ui[r["SQL_ID"]].update(r["UIS"].split(";"))
prefix_re = re.compile(r"^(SYS|DMF|SCP|SCM|COM|SSP|FP)\d{4}")
for r in load("sheet_columns_combo"):
    m = prefix_re.match(r["PROGRAM_ID"])
    if m and r["CELL_COMBO_DATA_TYPE"]:
        combo_ui[r["CELL_COMBO_DATA_TYPE"]].add(m.group(0))
combo_rows, combo_noparse = [], []
for r in load("cmbo_sql"):
    sid = r["SQL_ID"]
    tabs = set()
    for cand in extract_tables(r["SQL_DTL_CTN"] or ""):
        k = resolve(cand)
        if k:
            tabs.add(k)
    uis = sorted(combo_ui.get(sid, set()))
    if not tabs and (r["SQL_DTL_CTN"] or "").strip():
        combo_noparse.append(sid)
    for o, n in sorted(tabs):
        combo_rows.append([sid, ";".join(uis) or "(미사용)", o, n])
wcsv("combo_tables.csv", ["SQL_ID", "UIS", "OBJECT_OWNER", "OBJECT_NAME"], combo_rows)

# ---------- SYS0013 등록 동적쿼리(DQ_TEXT) 파싱 ----------
dq_rows, dq_noparse = [], []
for r in load("dq_list"):
    tabs = set()
    for cand in extract_tables(r["DQ_TEXT"] or ""):
        k = resolve(cand)
        if k:
            tabs.add(k)
    if not tabs:
        dq_noparse.append(r["DQ_ID"])
    for o, n in sorted(tabs):
        dq_rows.append([r["DQ_ID"], r["DQ_NAME"], r["VALID_YN"], o, n])
wcsv("dq_tables.csv", ["DQ_ID", "DQ_NAME", "VALID_YN", "OBJECT_OWNER", "OBJECT_NAME"], dq_rows)

# ---------- 리포트 ----------
rep = []
rep.append(f"① 정적: 동적SQL 보유 유닛 {len(static_units)} / 추출 객체행 {len(static_rows)} / 추출0(수동확인) {len(manual_units)}")
rep += ["   " + x for x in manual_units]
rep.append(f"② V$: {len(vs_rows)}행")
rep.append(f"③ AWR: 귀속 {len(awr_rows)}행 / 귀속불가 SQL 객체행 {awr_unattr} (한계 기재)")
rep.append(f"④ SQL_LOG: 테이블 {len(log_tab)}종")
rep.append(f"콤보: UI매핑 콤보 {sum(1 for v in combo_ui.values() if v)} / 파싱0 콤보 {combo_noparse}")
rep.append(f"SYS0013 등록쿼리: {len(dq_rows)}객체행 / 파싱0 DQ_ID {dq_noparse}")
(HERE / "dynamic_report.txt").write_text("\n".join(rep), encoding="utf-8")
print("\n".join(rep))
