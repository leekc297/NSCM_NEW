"""NULL 센티널 '-' → '/' 전환 — 작업대상 / 제외대상 목록 추출 (읽기 전용 · SELECT 만)

판정 기준 (사용자 확정 2026-10-01):
  제외 = AS-IS 에서 원래 '-' 를 쓰던 컬럼 — ① AS-IS 기본값 제약 '-' ② AS-IS 실데이터 '-' 존재 ③ AS-IS SP/VIEW/FUNCTION 코드 '-' 사용 (합집합)
  소스 = '-' 리터럴 전 사용처를 용도별로 분류
  스키마 = SCM_MGR + FP_MGR (TO-BE 사내 ZIOUI1) / AS-IS = LGCE_SCMDEV + LGCE_FPDEV (LESDFPSTO1C01)

사용:
  python extract_dash_inventory.py all          # 전 단계 (캐시가 있으면 재사용)
  python extract_dash_inventory.py <stage>      # tobe_cols | asis_meta | asis_code | asis_data | tobe_data | src | xlsx
  --refresh <stage>                             # 해당 단계 캐시 무시
"""
import sys, os, re, json, time, datetime, collections
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
CACHE = os.path.join(HERE, "_cache")
os.makedirs(CACHE, exist_ok=True)
OUT_XLSX = os.path.join(HERE, "NULL센티널_대시→슬래시_작업대상목록_20261006.xlsx")
SCHEMAS = ("SCM_MGR", "FP_MGR")
ASIS_DBS = {"SCM_MGR": ["LGCE_SCMDEV", "LGCE_FPDEV"], "FP_MGR": ["LGCE_FPDEV", "LGCE_SCMDEV"]}
CHAR_TYPES_MS = ("char", "varchar", "nchar", "nvarchar")
SRC_TYPES = ("PACKAGE", "PACKAGE BODY", "PROCEDURE", "FUNCTION", "TRIGGER", "TYPE BODY")
MIGRATION_MARKERS = ["SOLDTO-SENTINEL", "PLANTNORM", "NVLSAVE", "PKSENTINEL", "SENTINEL", "POJ", "AJS",
                     "E2026", "#119", "센티널", "NOT NULL", "ORA-01400"]
SQL_KW = set("""SELECT FROM WHERE AND OR NOT NULL IS IN AS ON THEN ELSE END WHEN CASE INTO VALUES SET UPDATE INSERT DELETE
JOIN LEFT RIGHT INNER OUTER FULL GROUP BY ORDER HAVING UNION ALL DISTINCT LIKE BETWEEN EXISTS N BEGIN IF ELSIF LOOP
RETURN WITH OVER PARTITION ASC DESC TOP NOLOCK CROSS APPLY MERGE USING MATCHED DECLARE CURSOR FOR OPEN FETCH CLOSE
COMMIT ROLLBACK EXEC EXECUTE PRINT RAISERROR GOTO TRY CATCH CONVERT CAST ISNULL NVL COALESCE REPLACE TRIM LTRIM RTRIM
SUBSTRING SUBSTR LEFT RIGHT LEN LENGTH MAX MIN SUM COUNT AVG""".split())


def log(*a):
    print(time.strftime("%H:%M:%S"), *a, flush=True)


def cache_path(name):
    return os.path.join(CACHE, name + ".json")


def cached(name, fn, refresh):
    p = cache_path(name)
    if os.path.exists(p) and name not in refresh:
        return json.load(open(p, encoding="utf-8"))
    data = fn()
    json.dump(data, open(p, "w", encoding="utf-8"), ensure_ascii=False)
    return data


def ora():
    u, p, d = conn_info()
    c = oracledb.connect(user=u, password=p, dsn=d)
    c.call_timeout = 1800 * 1000
    return c


def asis():
    import pyodbc
    env = {}
    for ln in open(r"C:\Projects\NSCM\.env.asis", encoding="utf-8-sig"):
        ln = ln.strip()
        if ln and not ln.startswith("#") and "=" in ln:
            k, v = ln.split("=", 1); env[k.strip()] = v.strip()
    cs = (f"DRIVER={{{env.get('ASIS_DB_DRIVER', 'ODBC Driver 17 for SQL Server')}}};"
          f"SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};DATABASE={env['ASIS_DB_NAME']};"
          f"UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']};TrustServerCertificate=yes;Encrypt=no")
    c = pyodbc.connect(cs, timeout=30)
    c.timeout = 1800
    return c


# ----------------------------------------------------------------------------------------------------------------
# 1단계 — TO-BE DEFAULT '-' 컬럼
# ----------------------------------------------------------------------------------------------------------------
def stage_tobe_cols():
    with ora() as c:
        cur = c.cursor()
        cur.execute("""SELECT c.owner, c.table_name, c.column_name, c.column_id, c.data_type, c.data_length, c.nullable,
                              c.default_on_null, TRIM(c.data_default_vc), NVL(t.temporary,'N'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS')
                         FROM all_tab_columns c
                         JOIN all_tables t ON t.owner = c.owner AND t.table_name = c.table_name
                        WHERE c.owner IN ('SCM_MGR','FP_MGR') AND TRIM(c.data_default_vc) = '''-'''
                        ORDER BY c.owner, c.table_name, c.column_id""")
        rows = [dict(owner=r[0], table=r[1], column=r[2], col_id=r[3], dtype=r[4], dlen=r[5], nullable=r[6],
                     on_null=r[7], default=r[8], gtt=r[9]) for r in cur]
        stamp = cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'), SYS_CONTEXT('USERENV','SERVICE_NAME') FROM dual").fetchone()
    log("tobe_cols", len(rows))
    return {"rows": rows, "fetched": stamp[0], "service": stamp[1]}


# ----------------------------------------------------------------------------------------------------------------
# 2단계 — AS-IS 메타 (테이블·컬럼·기본값 제약) + 모듈 원문
# ----------------------------------------------------------------------------------------------------------------
def stage_asis_meta():
    out = {"cols": {}, "defaults": [], "fetched": None}
    with asis() as c:
        cur = c.cursor()
        out["fetched"] = str(cur.execute("SELECT SYSDATETIME()").fetchone()[0])
        for db in ("LGCE_SCMDEV", "LGCE_FPDEV"):
            cur.execute(f"""SELECT s.name, t.name, col.name, ty.name, col.max_length
                              FROM {db}.sys.tables t JOIN {db}.sys.schemas s ON s.schema_id = t.schema_id
                              JOIN {db}.sys.columns col ON col.object_id = t.object_id
                              JOIN {db}.sys.types ty ON ty.user_type_id = col.user_type_id""")
            for sch, tb, cn, ty, ml in cur.fetchall():
                out["cols"].setdefault(f"{db}|{tb.upper()}", {"schema": sch, "table": tb, "cols": {}})["cols"][cn.upper()] = {"name": cn, "type": ty}
            cur.execute(f"""SELECT t.name, col.name, dc.definition
                              FROM {db}.sys.default_constraints dc
                              JOIN {db}.sys.tables t ON t.object_id = dc.parent_object_id
                              JOIN {db}.sys.columns col ON col.object_id = dc.parent_object_id AND col.column_id = dc.parent_column_id""")
            for tb, cn, df in cur.fetchall():
                norm = re.sub(r"[()\s]", "", df or "")
                out["defaults"].append({"db": db, "table": tb.upper(), "column": cn.upper(), "definition": df,
                                        "is_dash": norm in ("'-'", "N'-'")})
    log("asis_meta tables", len(out["cols"]), "defaults", len(out["defaults"]))
    return out


def stage_asis_modules():
    mods = []
    with asis() as c:
        cur = c.cursor()
        for db in ("LGCE_SCMDEV", "LGCE_FPDEV"):
            cur.execute(f"""SELECT s.name, o.name, o.type_desc, m.definition
                              FROM {db}.sys.sql_modules m JOIN {db}.sys.objects o ON o.object_id = m.object_id
                              JOIN {db}.sys.schemas s ON s.schema_id = o.schema_id""")
            for sch, nm, td, df in cur.fetchall():
                mods.append({"db": db, "schema": sch, "name": nm, "type": td, "definition": df or ""})
    log("asis modules", len(mods))
    return mods


# AS-IS 코드 근거 — '-' 리터럴 주변에서 컬럼명 추출 (③)
ASIS_PATTERNS = [
    ("ISNULL(col,'-')",    re.compile(r"ISNULL\s*\(\s*(?:[\w\[\]#@]+\.)?\[?(\w+)\]?\s*,\s*N?'-'\s*\)", re.I)),
    ("ISNULL(...,'-') AS col", re.compile(r"ISNULL\s*\((?:[^()]|\([^()]*\))*?,\s*N?'-'\s*\)\s*(?:AS\s+)?\[?(\w+)\]?", re.I)),
    ("col = ISNULL(..,'-')", re.compile(r"\[?(\w+)\]?\s*=\s*ISNULL\s*\((?:[^()]|\([^()]*\))*?,\s*N?'-'\s*\)", re.I)),
    ("col op '-'",         re.compile(r"(?:[\w\[\]#@]+\.)?\[?(\w+)\]?\s*(?:=|<>|!=)\s*N?'-'(?!\w)", re.I)),
    ("'-' op col",         re.compile(r"N?'-'\s*(?:=|<>|!=)\s*(?:[\w\[\]#@]+\.)?\[?(\w+)\]?", re.I)),
    ("'-' AS col",         re.compile(r"N?'-'\s+(?:AS\s+)?\[?(\w+)\]?", re.I)),
    ("col IN (..'-'..)",   re.compile(r"(?:[\w\[\]#@]+\.)?\[?(\w+)\]?\s+(?:NOT\s+)?IN\s*\([^()]*N?'-'", re.I)),
]


def strip_ms_comments(t):
    t = re.sub(r"/\*.*?\*/", lambda m: " " * len(m.group(0)), t, flags=re.S)
    return re.sub(r"--[^\n]*", lambda m: " " * len(m.group(0)), t)


def stage_asis_code(mods):
    """'-' 리터럴 출현 위치마다 앞 300자·뒤 80자 창에서만 패턴 검사 (원문 전체 정규식 = 대형 SP 에서 과도한 역추적).
       매치 구간이 그 '-' 위치를 포함할 때만 채택 → 같은 근거 중복 방지."""
    ev = []
    seen = set()
    for m in mods:
        code = strip_ms_comments(m["definition"])
        for occ in re.finditer(r"N?'-'", code):
            p = occ.start()
            ws = max(0, p - 300); we = min(len(code), occ.end() + 80)
            win = code[ws:we]
            for label, rx in ASIS_PATTERNS:
                for mt in rx.finditer(win):
                    if not (mt.start() <= p - ws <= mt.end()):
                        continue
                    col = mt.group(1).upper()
                    if col in SQL_KW or col.isdigit():
                        continue
                    key = (m["db"], m["name"], col, label, p)
                    if key in seen:
                        continue
                    seen.add(key)
                    s = max(0, mt.start() - 40); e = min(len(win), mt.end() + 40)
                    ev.append({"db": m["db"], "object": m["name"], "type": m["type"], "column": col, "pattern": label,
                               "snippet": re.sub(r"\s+", " ", win[s:e]).strip()[:300]})
    log("asis code evidence rows", len(ev))
    return ev


# ----------------------------------------------------------------------------------------------------------------
# 2-② AS-IS 실데이터 '-' 스캔 / TO-BE 현재 데이터 '-' (참고)
# ----------------------------------------------------------------------------------------------------------------
def map_asis_table(owner, table, meta):
    for db in ASIS_DBS[owner]:
        k = f"{db}|{table}"
        if k in meta["cols"]:
            return db, meta["cols"][k]
    return None, None


def stage_asis_data(tcols, meta):
    p = cache_path("asis_data_partial")
    done = json.load(open(p, encoding="utf-8")) if os.path.exists(p) else {}
    by_table = collections.OrderedDict()
    for r in tcols["rows"]:
        db, ti = map_asis_table(r["owner"], r["table"], meta)
        if not ti:
            continue
        ac = ti["cols"].get(r["column"])
        if not ac or ac["type"].lower() not in CHAR_TYPES_MS:
            continue
        by_table.setdefault((db, ti["schema"], ti["table"]), []).append(ac["name"])
    log("asis data scan tables", len(by_table), "already", len(done))
    with asis() as c:
        cur = c.cursor()
        for (db, sch, tb), cols in by_table.items():
            key = f"{db}|{tb.upper()}"
            if key in done:
                continue
            cols = sorted(set(cols))
            parts = ["COUNT_BIG(*)"]
            for cn in cols:
                parts += [f"SUM(CASE WHEN [{cn}] = '-' THEN 1 ELSE 0 END)",
                          f"SUM(CASE WHEN [{cn}] = '--' THEN 1 ELSE 0 END)",
                          f"SUM(CASE WHEN [{cn}] = '' THEN 1 ELSE 0 END)"]
            sql = f"SELECT {', '.join(parts)} FROM [{db}].[{sch}].[{tb}] WITH (NOLOCK)"
            t0 = time.time()
            try:
                r = cur.execute(sql).fetchone()
                res = {"total": int(r[0] or 0), "cols": {}}
                for i, cn in enumerate(cols):
                    res["cols"][cn.upper()] = {"dash": int(r[1 + 3 * i] or 0), "ddash": int(r[2 + 3 * i] or 0), "blank": int(r[3 + 3 * i] or 0)}
                res["sec"] = round(time.time() - t0, 1)
            except Exception as e:
                res = {"error": str(e)[:300]}
            done[key] = res
            json.dump(done, open(p, "w", encoding="utf-8"), ensure_ascii=False)
            log("  asis", key, res.get("total"), res.get("sec"), res.get("error", ""))
    return done


def stage_tobe_data(tcols):
    p = cache_path("tobe_data_partial")
    done = json.load(open(p, encoding="utf-8")) if os.path.exists(p) else {}
    by_table = collections.OrderedDict()
    for r in tcols["rows"]:
        if r["gtt"] == "Y" or r["dtype"] not in ("VARCHAR2", "CHAR", "NVARCHAR2", "NCHAR"):
            continue
        by_table.setdefault((r["owner"], r["table"]), []).append(r["column"])
    log("tobe data scan tables", len(by_table), "already", len(done))
    with ora() as c:
        cur = c.cursor()
        for (ow, tb), cols in by_table.items():
            key = f"{ow}.{tb}"
            if key in done:
                continue
            parts = ["COUNT(*)"] + [f"SUM(CASE WHEN \"{cn}\" = '-' THEN 1 ELSE 0 END)" for cn in cols]
            t0 = time.time()
            try:
                r = cur.execute(f"SELECT {', '.join(parts)} FROM \"{ow}\".\"{tb}\"").fetchone()
                res = {"total": int(r[0] or 0), "cols": {cn: int(r[1 + i] or 0) for i, cn in enumerate(cols)}, "sec": round(time.time() - t0, 1)}
            except Exception as e:
                res = {"error": str(e)[:300]}
            done[key] = res
            json.dump(done, open(p, "w", encoding="utf-8"), ensure_ascii=False)
            log("  tobe", key, res.get("total"), res.get("sec"), res.get("error", ""))
    return done


# ----------------------------------------------------------------------------------------------------------------
# 3단계 — TO-BE 소스 '-' 사용처 (주석·문자열 인식 토크나이저)
# ----------------------------------------------------------------------------------------------------------------
def stage_src_fetch():
    objs = {}
    types_in = ",".join("'%s'" % t for t in SRC_TYPES)
    with ora() as c:
        cur = c.cursor()
        cur.execute(f"""SELECT owner, name, type, line, text FROM all_source
                         WHERE owner IN ('SCM_MGR','FP_MGR') AND type IN ({types_in})
                           AND name NOT LIKE 'BIN$%'
                           AND (owner, name, type) IN (SELECT owner, name, type FROM all_source
                                                        WHERE owner IN ('SCM_MGR','FP_MGR') AND text LIKE '%''-''%')
                         ORDER BY owner, name, type, line""")
        for ow, nm, ty, ln, tx in cur:
            objs.setdefault(f"{ow}|{ty}|{nm}", []).append(tx or "")
        cur.execute("SELECT owner, view_name, text FROM all_views WHERE owner IN ('SCM_MGR','FP_MGR')")
        for ow, nm, tx in cur:
            tx = tx or ""
            if "'-'" in tx:
                objs[f"{ow}|VIEW|{nm}"] = [l + "\n" for l in tx.split("\n")]
        cnt = cur.execute(f"""SELECT COUNT(*) FROM all_source WHERE owner IN ('SCM_MGR','FP_MGR') AND name NOT LIKE 'BIN$%'
                              AND text LIKE '%''-''%' AND type IN ({types_in})""").fetchone()[0]
        stamp = cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM dual").fetchone()[0]
    log("src objects", len(objs), "lines-with-dash(ALL_SOURCE)", cnt)
    return {"objs": objs, "dash_line_count": cnt, "fetched": stamp}


def tokenize_lines(lines):
    """줄별 (code_text, comment_text, [(start,end,literal_text,in_dynsql)]) — 블록주석·문자열 상태를 줄 넘어 유지.
       '-' 리터럴: 코드 문자열 토큰 '-' 및 동적 SQL 문자열 안의 ''-''."""
    out = []
    in_block = False
    in_str = False
    for line in lines:
        code = []; comm = []; lits = []
        i = 0; n = len(line)
        str_start = None; str_buf = []
        while i < n:
            ch = line[i]
            if in_block:
                if line.startswith("*/", i):
                    in_block = False; comm.append("*/"); i += 2; continue
                comm.append(ch); i += 1; continue
            if in_str:
                if ch == "'":
                    if i + 1 < n and line[i + 1] == "'":
                        str_buf.append("''"); code.append("''"); i += 2; continue
                    in_str = False; code.append("'")
                    lit = "".join(str_buf)
                    if lit == "-":
                        lits.append((str_start, len("".join(code)), "'-'", False))
                    elif "''-''" in lit:
                        lits.append((str_start, len("".join(code)), "dynamic ''-''", True))
                    i += 1; continue
                str_buf.append(ch); code.append(ch); i += 1; continue
            if line.startswith("--", i):
                comm.append(line[i:]); break
            if line.startswith("/*", i):
                in_block = True; comm.append("/*"); i += 2; continue
            if ch == "'":
                in_str = True; str_start = len("".join(code)); str_buf = []; code.append("'"); i += 1; continue
            code.append(ch); i += 1
        if in_str:   # 줄 넘어가는 문자열(동적 SQL) — 줄 끝까지 버퍼 검사
            lit = "".join(str_buf)
            if "''-''" in lit:
                lits.append((str_start, len("".join(code)), "dynamic ''-''", True))
            str_start = 0; str_buf = []
        out.append(("".join(code), "".join(comm), lits))
    return out


ID = r"(?:\"?\w+\"?\.)?\"?(\w+)\"?"


def infer(code_line, s, e, prev_code, next_codes):
    """'-' 리터럴 1개의 용도 분류 + 컬럼 추정."""
    before = code_line[:s]
    after = code_line[e:]
    b_join = (prev_code + " " + before)
    # 비센티널 — 함수 인자 / 연결 구분자
    if re.search(r"(REPLACE|TRANSLATE|INSTR|REGEXP_\w+|\w*SPLIT\w*|LPAD|RPAD|RTRIM|LTRIM|TRIM)\s*\((?:[^()]|\([^()]*\))*$", before, re.I) \
            and not re.search(r"\b(NVL|COALESCE|NVL2|DECODE)\s*\((?:[^()]|\([^()]*\))*$", before, re.I):
        return "NON_SENTINEL", None, "함수 인자(REPLACE/INSTR/SPLIT 등)"
    if re.search(r"\|\|\s*$", before) or re.match(r"\s*\|\|", after):
        return "NON_SENTINEL", None, "문자열 연결 구분자(||)"
    # NVL 계열 초기값
    m = re.search(r"\b(NVL|COALESCE|NVL2|DECODE)\s*\(((?:[^()]|\([^()]*\))*)$", before, re.I)
    if m and re.match(r"\s*\)", after):
        inner = m.group(2)
        ids = [x for x in re.findall(r"(?:\"?\w+\"?\.)?\"?([A-Za-z_]\w*)\"?", inner) if x.upper() not in SQL_KW]
        col = ids[0].upper() if ids else None
        # 대입 대상 컬럼이 따로 있으면(SET col = NVL(...) / NVL(...) AS col) 그것도 기록
        tgt = re.search(r"(\w+)\s*=\s*$", before[:m.start()]) or re.match(r"\s*\)\s*(?:AS\s+)?\"?(\w+)\"?", after, re.I)
        tcol = tgt.group(1).upper() if tgt and tgt.group(1).upper() not in SQL_KW else None
        return "NVL_INIT", tcol or col, f"{m.group(1).upper()} 기본값" + (f" (원식 {col})" if tcol and col and tcol != col else "")
    if re.search(r":=\s*$", before):
        mm = re.search(r"(\w+)\s*:=\s*$", before)
        return "ASSIGN", mm.group(1).upper() if mm else None, "변수 대입"
    if re.search(r"\b(THEN|ELSE)\s*$", before, re.I):
        col = None
        for nx in [after] + next_codes:
            mm = re.search(r"\bEND\b\s*\)?\s*(?:AS\s+)?\"?([A-Za-z_]\w*)\"?", nx, re.I)
            if mm and mm.group(1).upper() not in SQL_KW:
                col = mm.group(1).upper(); break
        if not col:
            mm = re.search(r"(\w+)\s*=\s*\(?\s*(?:NVL\s*\(\s*)?CASE\b(?!.*\bCASE\b)", b_join, re.I | re.S)
            if mm and mm.group(1).upper() not in SQL_KW:
                col = mm.group(1).upper()
        if not col:
            mm = re.findall(r"WHEN\s+" + ID, b_join, re.I)
            col = mm[-1].upper() if mm and mm[-1].upper() not in SQL_KW else None
        return "CASE_VALUE", col, "CASE 결과값"
    m = re.search(ID + r"\s*(?:=|<>|!=|>=|<=)\s*$", before)
    if m and m.group(1).upper() not in SQL_KW:
        return "COMPARE", m.group(1).upper(), "비교(col op '-')"
    m = re.match(r"\s*(?:=|<>|!=)\s*" + ID, after)
    if m and m.group(1).upper() not in SQL_KW:
        return "COMPARE", m.group(1).upper(), "비교('-' op col)"
    m = re.search(ID + r"\s+(?:NOT\s+)?IN\s*\([^()]*$", before, re.I)
    if m and m.group(1).upper() not in SQL_KW:
        return "COMPARE", m.group(1).upper(), "IN 목록"
    m = re.match(r"\s*(?:AS\s+)?\"?([A-Za-z_]\w*)\"?", after, re.I)
    if m and m.group(1).upper() not in SQL_KW:
        return "LITERAL_LOAD", m.group(1).upper(), "'-' AS 별칭"
    if re.search(r"(,|\(|SELECT|VALUES)\s*$", before, re.I) or re.match(r"\s*(,|\))", after):
        return "LITERAL_LOAD", None, "SELECT/VALUES 위치 리터럴(컬럼 위치 대응 필요)"
    if re.search(r"\bDEFAULT\s*$", before, re.I):
        return "DEFAULT_DDL", None, "동적 DDL DEFAULT"
    return "OTHER", None, "기타"


def subprogram_map(lines):
    cur = None; res = []
    for l in lines:
        m = re.match(r"\s*(?:PROCEDURE|FUNCTION)\s+\"?(\w+)", l, re.I)
        if m:
            cur = m.group(1).upper()
        res.append(cur)
    return res


def stage_src_classify(src):
    rows = []
    for key, lines in src["objs"].items():
        ow, ty, nm = key.split("|")
        toks = tokenize_lines(lines)
        subs = subprogram_map(lines)
        for i, (code, comm, lits) in enumerate(toks):
            raw = lines[i].rstrip("\n")
            if not lits and "'-'" in comm:
                rows.append({"owner": ow, "type": ty, "name": nm, "sub": subs[i], "line": i + 1, "occ": 1,
                             "text": raw.strip()[:500], "usage": "COMMENT", "column": None, "detail": "주석 안의 '-'",
                             "markers": markers(raw)})
                continue
            prev_code = toks[i - 1][0] if i > 0 else ""
            next_codes = [toks[j][0] for j in range(i + 1, min(i + 6, len(toks)))]
            for k, (s, e, lt, dyn) in enumerate(lits, 1):
                if dyn:
                    inner = code[s:e].replace("''", "'")
                    sub_toks = tokenize_lines([inner])[0]
                    if sub_toks[2]:
                        s2, e2, _, _ = sub_toks[2][0]
                        u, col, det = infer(sub_toks[0], s2, e2, "", [])
                    else:
                        u, col, det = "OTHER", None, ""
                    usage, detail = "DYNAMIC_SQL:" + u, "동적 SQL 문자열 내 — " + det
                else:
                    usage, col, detail = infer(code, s, e, prev_code, next_codes)
                rows.append({"owner": ow, "type": ty, "name": nm, "sub": subs[i], "line": i + 1, "occ": k,
                             "text": raw.strip()[:500], "usage": usage, "column": col, "detail": detail,
                             "markers": markers(raw)})
    log("src occurrence rows", len(rows))
    return rows


def markers(raw):
    return ", ".join(m for m in MIGRATION_MARKERS if m.upper() in raw.upper())


# ----------------------------------------------------------------------------------------------------------------
# 4단계 — 판정
# ----------------------------------------------------------------------------------------------------------------
def asis_counterparts(sub, name, mod_index):
    cands = []
    for base in filter(None, [sub, name]):
        b = base.upper()
        for c in {b, re.sub(r"^P_", "", b), re.sub(r"^PR_", "", b), re.sub(r"^PKG_", "", b)}:
            for pre in ("", "SP_", "UP_", "USP_", "PR_"):
                if (pre + c) in mod_index:
                    cands.append(pre + c)
    return sorted(set(cands))


def judge_all(tcols, meta, code_ev, adata, tdata, src_rows):
    dflt_dash = {(d["db"], d["table"], d["column"]): d for d in meta["defaults"] if d["is_dash"]}
    code_by_col = collections.defaultdict(list)
    for e in code_ev:
        code_by_col[e["column"]].append(e)
    code_by_obj_col = collections.defaultdict(list)
    for e in code_ev:
        code_by_obj_col[(e["object"].upper(), e["column"])].append(e)

    col_rows = []
    excl_names = collections.defaultdict(set)     # 컬럼명 → 제외 근거가 있는 테이블들
    for r in tcols["rows"]:
        db, ti = map_asis_table(r["owner"], r["table"], meta)
        ac = ti["cols"].get(r["column"]) if ti else None
        e1 = bool(db and (db, r["table"], r["column"]) in dflt_dash)
        d = adata.get(f"{db}|{r['table']}", {}) if db else {}
        dc = d.get("cols", {}).get(r["column"], {}) if d else {}
        e2 = (dc.get("dash", 0) or 0) > 0
        cev = code_by_col.get(r["column"], []) if ac else []
        e3 = bool(cev)
        reasons = [x for x, f in (("①AS-IS 기본값 '-'", e1), (f"②AS-IS 데이터 '-' {dc.get('dash', 0):,}건", e2),
                                  (f"③AS-IS 코드 {len({x['object'] for x in cev})}객체", e3)) if f]
        if not ti:
            verdict, why = "작업대상", "AS-IS 대응 테이블 없음(TO-BE 신규/GTT)"
        elif not ac:
            verdict, why = "작업대상", "AS-IS 대응 컬럼 없음(TO-BE 신규 컬럼)"
        elif reasons:
            verdict, why = "제외(AS-IS '-' 사용)", " / ".join(reasons)
            excl_names[r["column"]].add(f"{r['owner']}.{r['table']}")
        elif d.get("error"):
            verdict, why = "판정보류", "AS-IS 데이터 스캔 실패: " + d["error"][:120]
        else:
            verdict, why = "작업대상", "AS-IS 근거 ①②③ 없음"
        td = tdata.get(f"{r['owner']}.{r['table']}", {})
        col_rows.append({**r, "asis_db": db or "", "asis_table": (ti or {}).get("table", ""), "asis_col": (ac or {}).get("name", ""),
                         "asis_type": (ac or {}).get("type", ""), "e1": "Y" if e1 else "", "asis_rows": d.get("total", ""),
                         "e2_dash": dc.get("dash", "") if dc else "", "asis_ddash": dc.get("ddash", "") if dc else "",
                         "asis_blank": dc.get("blank", "") if dc else "", "e3_objs": len({x["object"] for x in cev}),
                         "e3_sample": ", ".join(sorted({x["object"] for x in cev})[:5]),
                         "tobe_rows": td.get("total", "GTT" if r["gtt"] == "Y" else ""),
                         "tobe_dash": td.get("cols", {}).get(r["column"], "") if td else "",
                         "verdict": verdict, "why": why})

    mod_index = {}
    for e in code_ev:
        mod_index.setdefault(e["object"].upper(), True)
    all_mod_names = set(meta.get("module_names", []))
    for n in all_mod_names:
        mod_index.setdefault(n.upper(), True)

    out_src = []
    for s in src_rows:
        cps = asis_counterparts(s["sub"], s["name"], mod_index)
        col = s["column"]
        same = [cp for cp in cps if col and code_by_obj_col.get((cp, col))]
        u = s["usage"]
        base_u = u.split(":")[-1]
        if u == "COMMENT":
            v, why = "제외(주석)", "주석"
        elif base_u == "NON_SENTINEL":
            v, why = "제외(비센티널 용도)", s["detail"]
        elif same:
            v, why = "제외(AS-IS '-' 사용)", f"대응 AS-IS {', '.join(same)} 원문에 {col} '-' 사용"
        elif col and col in excl_names:
            v, why = "제외(AS-IS '-' 사용)", f"컬럼 {col} AS-IS 근거 — " + ", ".join(sorted(excl_names[col])[:5])
        elif col and code_by_col.get(col):
            v, why = "제외(AS-IS '-' 사용)", f"컬럼 {col} AS-IS 코드 '-' 사용 {len({x['object'] for x in code_by_col[col]})}객체"
        elif not col:
            v, why = "판정보류", "대상 컬럼 특정 불가 — " + s["detail"]
        else:
            v, why = "작업대상", f"컬럼 {col} AS-IS 근거 없음"
        out_src.append({**s, "asis_cp": ", ".join(cps), "verdict": v, "why": why})
    return col_rows, out_src


# ----------------------------------------------------------------------------------------------------------------
# xlsx
# ----------------------------------------------------------------------------------------------------------------
def write_xlsx(tcols, meta, code_ev, adata, col_rows, src_rows, src):
    from openpyxl import Workbook
    from openpyxl.styles import Font, PatternFill, Alignment
    from openpyxl.utils import get_column_letter
    wb = Workbook()
    hdr_fill = PatternFill("solid", fgColor="DDEBF7")
    vfill = {"작업대상": "E2EFDA", "판정보류": "FFF2CC"}

    def sheet(title, headers, rows, widths=None, vcol=None):
        ws = wb.create_sheet(title)
        ws.append(headers)
        for c in ws[1]:
            c.font = Font(bold=True); c.fill = hdr_fill; c.alignment = Alignment(wrap_text=True, vertical="top")
        for r in rows:
            ws.append(r)
        if vcol is not None:
            for row in ws.iter_rows(min_row=2):
                v = str(row[vcol].value or "")
                f = vfill.get(v) or ("FCE4D6" if v.startswith("제외") else None)
                if f:
                    row[vcol].fill = PatternFill("solid", fgColor=f)
        ws.freeze_panes = "A2"
        ws.auto_filter.ref = ws.dimensions
        for i, w in enumerate(widths or [], 1):
            ws.column_dimensions[get_column_letter(i)].width = w
        return ws

    # 요약
    ws = wb.active; ws.title = "요약"
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    ws.append(["NULL 센티널 '-' → '/' 전환 — 작업대상 / 제외대상 목록 (읽기 전용 추출 · DB 변경 없음)"]); ws["A1"].font = Font(bold=True, size=13)
    ws.append([f"작성 {now} · TO-BE 사내 {tcols['service']} (컬럼 {tcols['fetched']} / 소스 {src['fetched']}) · AS-IS LESDFPSTO1C01 LGCE_SCMDEV+LGCE_FPDEV ({meta['fetched'][:19]})"])
    ws.append([])
    ws.append(["판정 기준 (사용자 확정 2026-10-01)"]); ws.cell(ws.max_row, 1).font = Font(bold=True)
    for t in ["제외 = AS-IS 원래 '-' 사용: ① AS-IS 컬럼 기본값 제약 '-' ② AS-IS 실데이터 '-' 존재 ③ AS-IS SP/VIEW/FUNCTION 코드가 그 컬럼에 '-' 사용 (합집합)",
              "소스 줄: 주석 = 제외(주석) · REPLACE/INSTR/SPLIT 인자·|| 구분자 = 제외(비센티널) · 대응 AS-IS 원문 동일 사용 또는 컬럼 AS-IS 근거 = 제외 · 컬럼 특정 불가 = 판정보류 · 그 외 = 작업대상",
              "AS-IS 대응: TO-BE 테이블명 = AS-IS 테이블명 (SCM_MGR→LGCE_SCMDEV 우선, FP_MGR→LGCE_FPDEV 우선, 없으면 반대 DB)"]:
        ws.append(["  " + t])
    ws.append([])
    ws.append(["건수"]); ws.cell(ws.max_row, 1).font = Font(bold=True)
    ws.append(["구분", "스키마", "객체유형", "판정", "건수"])
    for c in ws[ws.max_row]:
        c.font = Font(bold=True); c.fill = hdr_fill
    cnt = collections.Counter((r["owner"], "COLUMN DEFAULT", r["verdict"]) for r in col_rows)
    for k, v in sorted(cnt.items()):
        ws.append(["컬럼DEFAULT", k[0], k[1], k[2], v])
    cnt = collections.Counter((r["owner"], r["type"], r["verdict"]) for r in src_rows)
    for k, v in sorted(cnt.items()):
        ws.append(["소스('-' 출현)", k[0], k[1], k[2], v])
    ws.append([])
    ws.append(["대사"]); ws.cell(ws.max_row, 1).font = Font(bold=True)
    src_lines = {(r["owner"], r["type"], r["name"], r["line"]) for r in src_rows if r["type"] != "VIEW"}
    ws.append([f"컬럼DEFAULT 행수 {len(col_rows):,} = TO-BE DEFAULT '-' 조회 {len(tcols['rows']):,}"])
    ws.append([f"소스 '-' 포함 줄(ALL_SOURCE) {src['dash_line_count']:,} / 분류된 줄(VIEW 제외) {len(src_lines):,}  (차이 = 문자열 안 '-' 가 아닌 줄, 예: 'YYYY-MM-DD' 는 '-' 단독 리터럴 아님)"])
    scan_fail = [k for k, v in adata.items() if v.get("error")]
    ws.append([f"AS-IS 데이터 스캔 테이블 {len(adata):,} / 실패 {len(scan_fail)}" + (" — " + ", ".join(scan_fail[:10]) if scan_fail else "")])
    asis_dash = [d for d in meta["defaults"] if d["is_dash"]]
    ws.append([f"AS-IS 기본값 '-' 컬럼 {len(asis_dash)} (TO-BE DEFAULT '-' 와 대응되는 것은 전부 제외로 분류되어야 함)"])
    ws.append([])
    ws.append(["한계"]); ws.cell(ws.max_row, 1).font = Font(bold=True)
    for t in ["INSERT 컬럼목록↔VALUES/SELECT 위치 대응은 해석하지 않음 → 위치 리터럴은 '판정보류'",
              "동적 SQL 문자열 안의 ''-'' 는 문자열 내용으로 용도 추정 (DYNAMIC_SQL:*)",
              "AS-IS 코드 근거③ 는 컬럼명 기준(테이블 구분 없음) — 같은 이름의 다른 테이블 컬럼이 근거가 될 수 있음(근거 열에 객체명 병기)",
              "AS-IS 데이터 근거② 는 DEV DB(LGCE_*DEV) 기준 — 운영 스냅샷 아님",
              "TO-BE 기준 = 사내 ZIOUI1. 클라우드 QA/DEV 와 판본 차이 가능",
              "TO-BE 기존 데이터의 '-' 값은 이번 범위 밖(데이터 변환은 별도 DB 작업) — 스캔·집계하지 않음"]:
        ws.append(["  " + t])
    ws.column_dimensions["A"].width = 18; ws.column_dimensions["B"].width = 12; ws.column_dimensions["C"].width = 16
    ws.column_dimensions["D"].width = 22; ws.column_dimensions["E"].width = 10

    ch = ["스키마", "테이블", "GTT", "컬럼", "컬럼순번", "데이터형", "길이", "NULLABLE", "DEFAULT ON NULL", "DEFAULT",
          "AS-IS DB", "AS-IS 테이블", "AS-IS 컬럼", "AS-IS 형", "①AS-IS 기본값'-'", "AS-IS 행수", "②AS-IS '-'행수",
          "(참고)AS-IS '--'행수", "(참고)AS-IS 공백행수", "③AS-IS 코드 객체수", "③객체 예시",
          "판정", "판정 근거"]

    def crow(r):
        return [r["owner"], r["table"], r["gtt"], r["column"], r["col_id"], r["dtype"], r["dlen"], r["nullable"], r["on_null"], r["default"],
                r["asis_db"], r["asis_table"], r["asis_col"], r["asis_type"], r["e1"], r["asis_rows"], r["e2_dash"], r["asis_ddash"], r["asis_blank"],
                r["e3_objs"], r["e3_sample"], r["verdict"], r["why"]]
    cw = [9, 32, 5, 26, 6, 10, 6, 6, 8, 8, 13, 30, 24, 10, 8, 11, 10, 9, 9, 8, 40, 20, 50]
    sheet("컬럼DEFAULT", ch, [crow(r) for r in col_rows], cw, vcol=21)

    sh = ["스키마", "객체유형", "객체명", "서브프로그램", "줄", "출현순번", "원문", "용도", "대상컬럼(추정)", "용도 상세", "이관작업 마커",
          "AS-IS 대응 객체", "판정", "판정 근거"]

    def srow(r):
        return [r["owner"], r["type"], r["name"], r["sub"], r["line"], r["occ"], r["text"], r["usage"], r["column"], r["detail"],
                r["markers"], r["asis_cp"], r["verdict"], r["why"]]
    sw = [9, 12, 26, 34, 6, 5, 80, 16, 22, 30, 16, 30, 20, 50]
    sheet("소스줄", sh, [srow(r) for r in src_rows], sw, vcol=12)

    # 같이 보기 — 작업대상 / 제외
    vh = ["구분", "스키마", "객체유형", "객체/테이블", "서브프로그램", "줄", "컬럼", "원문/DEFAULT", "판정", "판정 근거"]
    vw = [11, 9, 13, 32, 30, 6, 26, 70, 20, 60]

    def vrows(pred):
        rs = [["컬럼DEFAULT", r["owner"], "TABLE" + ("(GTT)" if r["gtt"] == "Y" else ""), r["table"], "", "", r["column"],
               f"DEFAULT {r['default']}" + (" ON NULL" if r["on_null"] == "YES" else ""), r["verdict"], r["why"]] for r in col_rows if pred(r["verdict"])]
        rs += [["소스", r["owner"], r["type"], r["name"], r["sub"], r["line"], r["column"], r["text"], r["verdict"], r["why"]]
               for r in src_rows if pred(r["verdict"])]
        return rs
    sheet("작업대상목록", vh, vrows(lambda v: v == "작업대상"), vw, vcol=8)
    sheet("제외목록", vh, vrows(lambda v: v.startswith("제외")), vw, vcol=8)
    sheet("판정보류", vh, vrows(lambda v: v == "판정보류"), vw, vcol=8)

    eh = ["근거", "AS-IS DB", "객체/테이블", "객체유형", "컬럼", "패턴/정의", "발췌"]
    erows = [["①기본값", d["db"], d["table"], "TABLE", d["column"], d["definition"], ""] for d in meta["defaults"] if d["is_dash"]]
    for k, v in adata.items():
        db, tb = k.split("|")
        if v.get("error"):
            erows.append(["②데이터(스캔실패)", db, tb, "TABLE", "", v["error"][:200], ""])
            continue
        for cn, x in v["cols"].items():
            if x["dash"]:
                erows.append(["②데이터", db, tb, "TABLE", cn, f"'-' {x['dash']:,} / 전체 {v['total']:,}", ""])
    erows += [["③코드", e["db"], e["object"], e["type"], e["column"], e["pattern"], e["snippet"]] for e in code_ev]
    sheet("AS-IS근거원장", eh, erows, [14, 13, 40, 22, 26, 26, 90])

    wb.save(OUT_XLSX)
    log("xlsx", OUT_XLSX)


def main():
    args = sys.argv[1:]
    refresh = set()
    if "--refresh" in args:
        i = args.index("--refresh"); refresh.add(args[i + 1]); del args[i:i + 2]
    stage = args[0] if args else "all"
    tcols = cached("tobe_cols", stage_tobe_cols, refresh)
    if stage == "tobe_cols":
        return
    meta = cached("asis_meta", stage_asis_meta, refresh)
    mods = cached("asis_modules", stage_asis_modules, refresh)
    meta["module_names"] = [m["name"] for m in mods]
    code_ev = cached("asis_code", lambda: stage_asis_code(mods), refresh)
    if stage in ("asis_meta", "asis_code"):
        return
    src = cached("src_fetch", stage_src_fetch, refresh)
    src_rows = cached("src_rows", lambda: stage_src_classify(src), refresh)
    if stage == "src":
        return
    adata = stage_asis_data(tcols, meta)
    if stage == "asis_data":
        return
    # TO-BE 실데이터 '-' 스캔은 범위 제외 (2026-10-06 — 데이터 변환은 별도 DB 작업). 명시 요청(stage=tobe_data) 시에만 실행.
    if stage == "tobe_data":
        stage_tobe_data(tcols)
        return
    tdata = {}
    col_rows, out_src = judge_all(tcols, meta, code_ev, adata, tdata, src_rows)
    json.dump({"cols": col_rows, "src": out_src}, open(cache_path("judged"), "w", encoding="utf-8"), ensure_ascii=False)
    write_xlsx(tcols, meta, code_ev, adata, col_rows, out_src, src)


if __name__ == "__main__":
    main()
