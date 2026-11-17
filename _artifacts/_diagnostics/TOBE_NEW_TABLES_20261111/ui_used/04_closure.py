"""04_closure.py — PL/SQL 멤버 단위 호출 폐포 + TABLE/VIEW 추출 (2026-10-14)

원문 = 01_dump 의 ALL_SOURCE (사내 ZIOUI1, SOURCE-FRESH). DB 접속 없음(파일만).
 1) 패키지 본문을 최상위 멤버로 분할 — BEGIN/END/IF/LOOP/CASE 스택 추적 (지역 서브프로그램은 부모 멤버에 귀속, overload 는 동명 병합)
    패키지 레벨 커서는 'CURSOR:이름' 의사 멤버(참조될 때만 도달), 그 외 패키지 레벨 코드(변수 기본값·초기화 블록)는 '<PKG-LEVEL>'(패키지 사용 시 항상 도달)
 2) 호출 간선 — 'PKG.MEMBER' / 같은 패키지 무수식 멤버 / 독립 PROC·FUNC (동의어·스키마 해석). 타 객체 간선은 ALL_DEPENDENCIES 로 검증
 3) TABLE/VIEW — 정적 SQL(문자열 마스킹 후) + 동적 SQL(문자열 리터럴 내부) 에서 FROM/JOIN/USING/INSERT INTO/MERGE INTO/UPDATE/DELETE/TRUNCATE
    %TYPE/%ROWTYPE 앵커는 데이터 접근이 아니므로 제외(별도 집계)
 4) 검증 — 객체 단위: (전 멤버 추출 합집합) vs ALL_DEPENDENCIES TABLE/VIEW 대조 → parser_check.csv
출력: closure_members.csv, call_edges.csv, member_tables.csv, parser_check.csv, unresolved_refs.csv, combo_tables.csv
"""
import csv, json, re, pathlib, collections

D = pathlib.Path(__file__).resolve().parent
L = lambda p: list(csv.DictReader((D / p).open(encoding="utf-8-sig")))
objects, syns, deps, procs, tables, views_meta = (L(f"dict/{n}.csv") for n in ("objects", "synonyms", "dependencies", "procedures", "tables", "views"))
cmbo = L("meta/cmbo_sql.csv")
entries = L("entries.csv")
SRC = {}
for line in (D / "source/all_source.jsonl").open(encoding="utf-8"):
    o = json.loads(line); SRC[(o["OWNER"], o["NAME"], o["TYPE"])] = o["TEXT"]
VIEWTXT = {}
for line in (D / "source/views.jsonl").open(encoding="utf-8"):
    o = json.loads(line); VIEWTXT[(o["OWNER"], o["NAME"])] = o["TEXT"]

DEFAULT_OWNER = "SCM_MGR"
OTYPE = collections.defaultdict(set)          # (owner,name) -> {types}
for o in objects: OTYPE[(o["OWNER"], o["OBJECT_NAME"])].add(o["OBJECT_TYPE"])
TEMP = {(t["OWNER"], t["TABLE_NAME"]) for t in tables if t["TEMPORARY"] == "Y"}
SYN = {}                                       # (owner,name) -> (towner,tname,dblink)
for s in syns: SYN[(s["OWNER"], s["SYNONYM_NAME"])] = (s["TABLE_OWNER"], s["TABLE_NAME"], s["DB_LINK"])
MEMBERS = collections.defaultdict(set)         # (owner,pkg) -> {member}
OVERLOAD = collections.Counter()
for p in procs:
    if p["OBJECT_TYPE"] == "PACKAGE" and p["PROCEDURE_NAME"]:
        MEMBERS[(p["OWNER"], p["OBJECT_NAME"])].add(p["PROCEDURE_NAME"])
        if p["OVERLOAD"]: OVERLOAD[(p["OWNER"], p["OBJECT_NAME"], p["PROCEDURE_NAME"])] += 1
DEPS = collections.defaultdict(set)            # (owner,name) -> {(rowner,rname,rtype)}
for d in deps:
    DEPS[(d["OWNER"], d["NAME"])].add((d["REFERENCED_OWNER"], d["REFERENCED_NAME"], d["REFERENCED_TYPE"]))

def resolve_name(parts, ctx_owner=DEFAULT_OWNER):
    """식별자 체인(대문자 list) → (owner, name, types, rest) — 동의어 1단계 이상 추적"""
    cands = []
    if len(parts) >= 2 and (parts[0], parts[1]) in OTYPE:
        cands.append((parts[0], parts[1], parts[2:]))
    cands.append((ctx_owner, parts[0], parts[1:]))
    for own, nm, rest in cands:
        for _ in range(4):
            if (own, nm) in OTYPE and OTYPE[(own, nm)] - {"SYNONYM"}:
                return own, nm, OTYPE[(own, nm)] - {"SYNONYM"}, rest
            s = SYN.get((own, nm)) or SYN.get(("PUBLIC", nm))
            if not s: break
            if s[2]: return s[0], s[1], {"REMOTE@" + s[2]}, rest
            own, nm = s[0], s[1]
    return None

# ───────────── 텍스트 전처리 ─────────────
def strip_comments(s):
    out, i, n, q = [], 0, len(s), False
    while i < n:
        c = s[i]
        if q:
            out.append(c)
            if c == "'":
                if i + 1 < n and s[i + 1] == "'": out.append("'"); i += 2; continue
                q = False
            i += 1; continue
        if c == "'": q = True; out.append(c); i += 1; continue
        if s.startswith("--", i):
            j = s.find("\n", i); i = n if j < 0 else j; continue
        if s.startswith("/*", i):
            j = s.find("*/", i + 2); seg = s[i:(n if j < 0 else j + 2)]; out.append("\n" * seg.count("\n")); i = n if j < 0 else j + 2; continue
        # q'[...]' 대체 인용
        if (c in "qQ") and s[i + 1:i + 2] == "'" and i + 2 < n:
            close = {"[": "]", "{": "}", "(": ")", "<": ">"}.get(s[i + 2], s[i + 2])
            j = s.find(close + "'", i + 3)
            if j > 0:
                body = s[i + 3:j]; out.append("'" + body.replace("'", "''") + "'"); i = j + 2; continue
        out.append(c); i += 1
    return "".join(out)
def mask_strings(s):
    """문자열 내용을 공백으로 (길이 보존) + 리터럴 목록 반환"""
    out, lits, i, n = [], [], 0, len(s)
    while i < n:
        c = s[i]
        if c == "'":
            j = i + 1; buf = []
            while j < n:
                if s[j] == "'":
                    if j + 1 < n and s[j + 1] == "'": buf.append("'"); j += 2; continue
                    break
                buf.append(s[j]); j += 1
            lits.append((i, "".join(buf)))
            out.append("'" + " " * (j - i - 1) + "'"); i = j + 1; continue
        out.append(c); i += 1
    return "".join(out), lits

TOK = re.compile(r"[A-Za-z_][A-Za-z0-9_$#]*|\"[^\"]+\"|[();,.@%]|:=|=>|<<|>>")
def tokens(masked):
    return [(m.group(0).upper().strip('"'), m.start()) for m in TOK.finditer(masked)]

# ───────────── 멤버 분할 ─────────────
def split_members(text, kind):
    """kind = PACKAGE BODY | PACKAGE | PROCEDURE | FUNCTION → {segname: [(start,end)...]} (masked 기준 오프셋)"""
    t = strip_comments(text); m, lits = mask_strings(t)
    if kind != "PACKAGE BODY" and kind != "PACKAGE":
        return t, m, lits, {"<OBJECT>": [(0, len(m))]}
    toks = tokens(m)
    segs = collections.defaultdict(list)
    stack = []            # frames: ('SUB',name,start,top) | 'BEGIN' | 'IF' | 'LOOP' | 'CASE'
    pending = None        # (name, start, top, paren_depth)
    paren = 0
    started = False       # 패키지 헤더 IS/AS 통과 여부
    i = 0; N = len(toks)
    level_spans = []      # 패키지 레벨 코드 구간
    lvl_start = None
    cursor_pending = None
    def top_level(): return not any(isinstance(f, tuple) for f in stack)
    while i < N:
        w, off = toks[i]
        nxt = toks[i + 1][0] if i + 1 < N else ""
        if w == "(": paren += 1
        elif w == ")": paren -= 1
        if not started:
            if w in ("IS", "AS"):
                started = True; lvl_start = toks[i + 1][1] if i + 1 < N else len(m)
            i += 1; continue
        if pending is None and w in ("PROCEDURE", "FUNCTION") and paren == 0:
            prevw = toks[i - 1][0] if i else ""
            if prevw not in ("DROP", "MEMBER", "STATIC", "CONSTRUCTOR"):
                is_top = top_level()
                if is_top and lvl_start is not None:
                    level_spans.append((lvl_start, off)); lvl_start = None
                pending = (nxt, off, is_top, paren); i += 2; continue
        if pending is not None:
            if w in ("IS", "AS") and paren == pending[3]:
                stack.append(("SUB", pending[0], pending[1], pending[2])); pending = None; i += 1; continue
            if w == ";" and paren == pending[3]:      # 전방 선언
                if pending[2]: lvl_start = off + 1
                pending = None; i += 1; continue
            i += 1; continue
        if w == "CURSOR" and top_level() and paren == 0:
            cursor_pending = (nxt, off)
        if w == ";" and cursor_pending and top_level() and paren == 0:
            nm, st = cursor_pending; segs["CURSOR:" + nm].append((st, off + 1)); cursor_pending = None
            i += 1; continue
        if w == "BEGIN": stack.append("BEGIN")
        elif w in ("CASE", "IF", "LOOP") and not (i and toks[i - 1][0] == "END" and not m[toks[i - 1][1] + 3:off].strip()):
            stack.append(w)
        elif w == "END":
            # 'END || CASE' 처럼 연산자를 사이에 둔 경우는 END CASE 가 아니다 → 공백만 사이에 있을 때만 결합
            adj = i + 1 < N and not m[off + 3:toks[i + 1][1]].strip()
            if nxt in ("IF", "LOOP", "CASE") and adj:
                # 해당 프레임까지 pop
                while stack and stack[-1] != nxt and not isinstance(stack[-1], tuple): stack.pop()
                if stack and stack[-1] == nxt: stack.pop()
                i += 2; continue
            # END [label]; → BEGIN/CASE pop. 패키지 END(최상위) 처리
            if stack and stack[-1] in ("BEGIN", "CASE"):
                fr = stack.pop()
                if fr == "BEGIN" and stack and isinstance(stack[-1], tuple):
                    sub = stack.pop()
                    # 서브프로그램 종료 → ';' 까지
                    j = i + 1
                    while j < N and toks[j][0] != ";": j += 1
                    endoff = toks[j][1] + 1 if j < N else len(m)
                    if sub[3]:
                        segs[sub[1]].append((sub[2], endoff)); lvl_start = endoff
                    i = j + 1; continue
            elif not stack:
                # 패키지 본문 종료 (초기화 블록 없는 END pkg;)
                pass
            elif stack and stack[-1] in ("IF", "LOOP"):
                stack.pop()
        i += 1
    if lvl_start is not None: level_spans.append((lvl_start, len(m)))
    # 패키지 레벨 = level_spans 에서 커서 구간 제외
    for s, e in level_spans: segs["<PKG-LEVEL>"].append((s, e))
    return t, m, lits, segs

PARSED = {}   # (owner,name,kind) -> (text, masked, lits, segs)
def parsed(owner, name, kind):
    k = (owner, name, kind)
    if k not in PARSED:
        txt = SRC.get(k)
        PARSED[k] = split_members(txt, kind) if txt is not None else None
    return PARSED[k]
def seg_text(p, segname, which=1):
    return "\n".join(p[which][s:e] for s, e in p[3].get(segname, []))
def seg_lits(p, segname):
    return [v for off, v in p[2] if any(s <= off < e for s, e in p[3].get(segname, []))]

# ───────────── SQL 객체 추출 ─────────────
SQLKW = {"SELECT", "WHERE", "GROUP", "ORDER", "HAVING", "UNION", "MINUS", "INTERSECT", "CONNECT", "START", "ON", "SET", "VALUES", "WHEN",
         "THEN", "ELSE", "END", "LEFT", "RIGHT", "FULL", "INNER", "OUTER", "CROSS", "JOIN", "NATURAL", "PIVOT", "UNPIVOT", "FETCH",
         "OFFSET", "FOR", "MODEL", "PARTITION", "SAMPLE", "AS", "WITH", "LATERAL", "USING", "RETURNING", "LOG", "INTO", "AND", "OR"}
def cte_names(masked_sql):
    tk = tokens(masked_sql); N = len(tk); c = set()
    for i in range(N - 3):
        if tk[i][0] in ("WITH", ",") and tk[i + 2][0] == "AS" and tk[i + 3][0] == "(": c.add(tk[i + 1][0])
    return c
def extract_objects(masked_sql, ctx_owner=DEFAULT_OWNER, extra_ctes=()):
    """→ list of (owner,name,types,op,raw)  op ∈ SELECT/INSERT/UPDATE/DELETE/MERGE/TRUNCATE ; unresolved 는 types=None"""
    tk = tokens(masked_sql)
    N = len(tk); out = []
    ctes = set(extra_ctes)
    for i in range(N - 2):
        if tk[i][0] == "WITH" or (tk[i][0] == "," and i > 0):
            if i + 2 < N and tk[i + 2][0] == "AS" and i + 3 < N and tk[i + 3][0] == "(":
                ctes.add(tk[i + 1][0])
            if i + 2 < N and tk[i + 2][0] == "(":   # WITH x (c1,c2) AS (
                j = i + 2; depth = 0
                while j < N:
                    if tk[j][0] == "(": depth += 1
                    elif tk[j][0] == ")":
                        depth -= 1
                        if depth == 0: break
                    j += 1
                if j + 2 < N and tk[j + 1][0] == "AS" and tk[j + 2][0] == "(": ctes.add(tk[i + 1][0])
    def read_ref(j, fn_check=False):
        """j 위치에서 [owner.]name[@link] 읽기 → (parts, link, next_j) or None. fn_check=True(FROM/JOIN) 면 '이름(' = 테이블 함수로 제외"""
        if j >= N or not re.match(r"[A-Z_]", tk[j][0]) or tk[j][0] in SQLKW: return None
        parts = [tk[j][0]]; j += 1
        while j + 1 < N and tk[j][0] == "." and re.match(r"[A-Z_]", tk[j + 1][0]):
            parts.append(tk[j + 1][0]); j += 2
        if fn_check and j < N and tk[j][0] == "(":      # JSON_TABLE( / TABLE( / XMLTABLE( / 파이프라인 함수 = 테이블 함수(객체 아님)
            return None
        link = None
        if j + 1 < N and tk[j][0] == "@":
            link = tk[j + 1][0]; j += 2
            while j + 1 < N and tk[j][0] == "." : link += "." + tk[j + 1][0]; j += 2
        return parts, link, j
    def emit(parts, link, op, j0):
        if len(parts) == 1 and parts[0] in ctes: return
        if parts[-1] in ("DUAL",) : return
        if (len(parts) == 1 or parts[0] == "SYS") and re.match(r"^(USER_|ALL_|DBA_|V\$|GV\$|GLOBAL_NAME$|NLS_|SESSION_)", parts[-1]):
            out.append(("SYS", parts[-1], {"SYS_DICTIONARY_VIEW"}, op, ".".join(parts))); return
        prev = tk[j0 - 1][0] if j0 else ""
        if link:
            out.append((ctx_owner, ".".join(parts), {"REMOTE@" + link}, op, ".".join(parts) + "@" + link)); return
        r = resolve_name(parts, ctx_owner)
        if r and r[2] & {"TABLE", "VIEW", "MATERIALIZED VIEW"} or (r and any(x.startswith("REMOTE@") for x in r[2])):
            out.append((r[0], r[1], r[2], op, ".".join(parts)))
        elif r and r[2] & {"PACKAGE", "FUNCTION", "PROCEDURE", "SEQUENCE", "TYPE"}:
            return
        else:
            out.append((None, ".".join(parts), None, op, ".".join(parts)))
    i = 0
    while i < N:
        w = tk[i][0]
        prev = tk[i - 1][0] if i else ""
        if w == "FROM" and prev not in ("DELETE",):
            # EXTRACT(x FROM y) / TRIM(.. FROM ..) 방지: 직전 '(' 이후에 SELECT 가 없으면 함수 인자 FROM
            j = i + 1
            # 함수 인자 FROM 판정
            k = i - 1; depth = 0; func_from = False
            while k >= 0:
                if tk[k][0] == ")": depth += 1
                elif tk[k][0] == "(":
                    if depth == 0:
                        func_from = k > 0 and tk[k - 1][0] in ("EXTRACT", "TRIM", "SUBSTRING", "OVERLAY", "LISTAGG", "CAST"); break
                    depth -= 1
                elif tk[k][0] in ("SELECT", ";") and depth == 0: break
                k -= 1
            if func_from: i += 1; continue
            while j < N:
                if tk[j][0] == "(":           # 인라인 뷰 / TABLE(...) → 건너뜀 (내부는 별도 FROM 으로 잡힘)
                    depth = 0
                    while j < N:
                        if tk[j][0] == "(": depth += 1
                        elif tk[j][0] == ")":
                            depth -= 1
                            if depth == 0: break
                        j += 1
                    j += 1
                elif tk[j][0] in ("TABLE", "LATERAL", "THE") and j + 1 < N and tk[j + 1][0] == "(":
                    j += 1; continue
                else:
                    r = read_ref(j, True)
                    if not r: break
                    emit(r[0], r[1], "SELECT", j); j = r[2]
                # alias / PARTITION / SAMPLE / pivot 등 건너뛰고 ',' 이면 계속
                while j < N and tk[j][0] not in (",", ";", ")", "(") and tk[j][0] not in SQLKW - {"AS"}:
                    j += 1
                if j < N and tk[j][0] == "AS": j += 2
                if j < N and tk[j][0] == ",": j += 1; continue
                break
            # ⚠ i = j 로 건너뛰면 인라인 뷰 '(' 안의 FROM/JOIN 을 놓친다 → FROM 다음 토큰부터 본 스캔 계속
            i += 1; continue
        if w == "JOIN":
            r = read_ref(i + 1, True)
            if r: emit(r[0], r[1], "SELECT", i + 1)
        elif w == "USING" and i + 1 < N and tk[i + 1][0] != "(":
            # MERGE ... USING t  (EXECUTE IMMEDIATE ... USING 변수 / JOIN USING(col) 제외: 대상이 객체로 해석될 때만)
            r = read_ref(i + 1)
            if r:
                rr = resolve_name(r[0])
                if rr and rr[2] & {"TABLE", "VIEW", "MATERIALIZED VIEW"}: emit(r[0], r[1], "SELECT", i + 1)
        elif w == "INTO" and prev in ("INSERT", "ALL", "FIRST") or (w == "INTO" and _in_insert_all(tk, i)):
            r = read_ref(i + 1)
            if r: emit(r[0], r[1], "INSERT", i + 1)
        elif w == "INTO" and prev == "MERGE":
            r = read_ref(i + 1)
            if r: emit(r[0], r[1], "MERGE", i + 1)
        elif w == "UPDATE" and prev != "FOR":
            # FOR UPDATE [OF/NOWAIT] 제외 · MERGE 의 'THEN UPDATE SET' 은 다음 토큰 SET 로 제외 (IF..THEN UPDATE T 는 포함)
            r = read_ref(i + 1)
            if r and i + 1 < N and tk[i + 1][0] not in ("SET", "OF", "NOWAIT", "WAIT", "SKIP"): emit(r[0], r[1], "UPDATE", i + 1)
        elif w == "DELETE" and prev != "ON":
            # MERGE 의 'DELETE WHERE' 는 다음 토큰 WHERE 로 제외 (IF..THEN DELETE FROM T 는 포함)
            j = i + 1
            if j < N and tk[j][0] == "FROM": j += 1
            r = read_ref(j)
            if r and j < N and tk[j][0] != "WHERE": emit(r[0], r[1], "DELETE", j)
        elif w == "TRUNCATE" and i + 1 < N and tk[i + 1][0] == "TABLE":
            r = read_ref(i + 2)
            if r: emit(r[0], r[1], "TRUNCATE", i + 2)
        elif w == "LOCK" and i + 1 < N and tk[i + 1][0] == "TABLE":
            r = read_ref(i + 2)
            if r: emit(r[0], r[1], "LOCK", i + 2)
        i += 1
    return out
def _in_insert_all(tk, i):
    """INSERT ALL / FIRST 의 두 번째 이후 INTO"""
    k = i - 1; depth = 0
    while k >= 0 and i - k < 400:
        w = tk[k][0]
        if w == ")": depth += 1
        elif w == "(": depth -= 1
        elif w == ";": return False
        elif depth == 0 and w in ("ALL", "FIRST") and k > 0 and tk[k - 1][0] == "INSERT": return True
        elif depth == 0 and w == "SELECT": return False
        k -= 1
    return False

ANCHOR = re.compile(r"([A-Za-z_][\w$#]*(?:\.[A-Za-z_][\w$#]*){0,2})\s*%\s*(ROW)?TYPE", re.I)
SQLISH = re.compile(r"\b(SELECT|FROM|INSERT|UPDATE|DELETE|MERGE|TRUNCATE|JOIN)\b", re.I)

def dynamic_objects(lits, ctx_owner):
    """동적 SQL 문자열 리터럴 → 객체 + 동적 이름(연결) 경고"""
    out, warns = [], []
    joined_ctes = cte_names(mask_strings(" ".join(lits))[0].upper())   # 조각 간 CTE 판정
    for lit in lits:
        if not SQLISH.search(lit): continue
        lm, _ = mask_strings(lit)
        for o in extract_objects(lm.upper(), ctx_owner, joined_ctes):
            # 동적 조각의 미해석 이름은 산출 대상 아님(검토 목록으로) — 실객체만 채택
            out.append(o)
        if re.search(r"\b(FROM|JOIN|INTO|UPDATE|TABLE)\s*$", lit.strip(), re.I):
            warns.append("동적 객체명(문자열 연결) — '" + lit.strip()[-60:] + "'")
    return out, warns

# ───────────── 호출 간선 ─────────────
_mo_cache = {}
def members_of(own, pkg):
    """spec 멤버(ALL_PROCEDURES) ∪ 본문 분할 멤버(private 포함)"""
    k = (own, pkg)
    if k not in _mo_cache:
        p = parsed(own, pkg, "PACKAGE BODY")
        segs = {x for x in (p[3] if p else {}) if not x.startswith("CURSOR:") and x != "<PKG-LEVEL>"}
        _mo_cache[k] = MEMBERS[k] | segs
    return _mo_cache[k]
IDCHAIN = re.compile(r"(?<![A-Za-z0-9_$#.:%'])([A-Za-z_][A-Za-z0-9_$#]*(?:\s*\.\s*[A-Za-z_][A-Za-z0-9_$#]*){0,2})")
def call_refs(masked, cur_owner, cur_pkg):
    """→ set of (owner, objname, member or '') — 패키지 멤버 / 독립 PROC·FUNC"""
    out = set()
    for m in IDCHAIN.finditer(masked):
        chain = [x.strip().upper() for x in m.group(1).split(".")]
        # 0) PL/SQL 이름 해석 우선순위: 무수식 이름은 같은 패키지 멤버가 전역 객체(동명 독립 SP)보다 먼저
        if cur_pkg and len(chain) == 1 and chain[0] in members_of(cur_owner, cur_pkg):
            out.add((cur_owner, cur_pkg, chain[0])); continue
        # 1) PKG.MEMBER (스키마 포함)
        r = resolve_name(chain, cur_owner)
        if r:
            own, nm, types, rest = r
            if "PACKAGE" in types and rest:
                if rest[0] in MEMBERS[(own, nm)]: out.add((own, nm, rest[0]))
                continue
            if types & {"PROCEDURE", "FUNCTION"} and not rest:
                out.add((own, nm, "")); continue
            if "PACKAGE" in types and not rest:
                continue
        # 2) 같은 패키지 무수식 멤버 (spec 공개 멤버 + 본문 전용 private 멤버)
        if cur_pkg and len(chain) == 1 and chain[0] in members_of(cur_owner, cur_pkg):
            out.add((cur_owner, cur_pkg, chain[0]))
    return out

# ───────────── 진입 시드 ─────────────
def seed_of(obj):
    parts = obj.upper().split(".")
    r = resolve_name(parts)
    if not r: return None
    own, nm, types, rest = r
    if "PACKAGE" in types:
        return (own, nm, rest[0] if rest else "")
    return (own, nm, "")

USERS = collections.defaultdict(set)       # node -> {(GROUP, SCREEN)}
ROOTS = collections.defaultdict(set)       # node -> {entry object}
unresolved_entries = []
seeds = []
for e in entries:
    if e["KIND"] in ("CALLPROC", "EXCEL_VALID", "DYNAMIC_QUERY", "FRAMEWORK"):
        s = seed_of(e["OBJECT"])
        if not s: unresolved_entries.append(e); continue
        seeds.append((s, e))

# 콤보 SQL → 테이블 + 함수 시드
cmbo_by = {r["SQL_ID"]: r for r in cmbo}
combo_rows = []
for e in entries:
    if e["KIND"] not in ("COMBO", "GRID_COMBO"): continue
    c = cmbo_by.get(e["OBJECT"])
    if not c: continue
    sql = strip_comments(c["SQL_DTL_CTN"] or "")
    sql = re.sub(r"@[A-Za-z_]\w*", "'0'", sql)   # @바인드 → 리터럴
    mk, lits = mask_strings(sql)
    for own, nm, types, op, raw in extract_objects(mk.upper()):
        combo_rows.append(dict(GROUP=e["GROUP"], SCREEN=e["SCREEN"], COMBO=e["OBJECT"], OWNER=own or "", OBJECT=nm, TYPE="|".join(sorted(types)) if types else "UNRESOLVED", OP=op, RAW=raw))
    for (own, nm, mb) in call_refs(mk.upper(), DEFAULT_OWNER, None):
        seeds.append(((own, nm, mb), dict(e, OBJECT=f"COMBO:{e['OBJECT']}")))
        combo_rows.append(dict(GROUP=e["GROUP"], SCREEN=e["SCREEN"], COMBO=e["OBJECT"], OWNER=own, OBJECT=f"{nm}.{mb}" if mb else nm, TYPE="CALL", OP="EXECUTE", RAW=""))
    if len(c["SQL_DTL_CTN"] or "") >= 3990:
        combo_rows.append(dict(GROUP=e["GROUP"], SCREEN=e["SCREEN"], COMBO=e["OBJECT"], OWNER="", OBJECT="", TYPE="WARN", OP="", RAW="SQL_DTL_CTN 4000자 근접 — 절단 가능성"))

# ───────────── 폐포 ─────────────
def node_kind(own, nm):
    t = OTYPE[(own, nm)]
    if "PACKAGE" in t: return "PACKAGE"
    if "PROCEDURE" in t: return "PROCEDURE"
    if "FUNCTION" in t: return "FUNCTION"
    return "?"
EDGES = set(); NODE_TABLES = {}; NODE_WARN = collections.defaultdict(list); UNRES = []
def node_text(node):
    own, nm, mb = node
    k = node_kind(own, nm)
    if k == "PACKAGE":
        p = parsed(own, nm, "PACKAGE BODY")
        if p is None: return None
        if mb not in p[3]:
            NODE_WARN[node].append(f"멤버 본문 미발견(분할 실패 또는 spec 전용) — {mb}")
            return ("", "", [])
        return (seg_text(p, mb, 0), seg_text(p, mb, 1), seg_lits(p, mb))
    p = parsed(own, nm, k)
    if p is None: return None
    return (p[0], p[1], [v for _, v in p[2]])

def analyze(node):
    if node in NODE_TABLES: return
    own, nm, mb = node
    nt = node_text(node)
    if nt is None:
        NODE_TABLES[node] = []; NODE_WARN[node].append("원문 없음(wrapped/권한/타 스키마)"); return
    raw, masked, lits = nt
    up = masked.upper()
    objs = [(o, n, t, op, r, "STATIC") for o, n, t, op, r in extract_objects(up, own)]
    dyn, warns = dynamic_objects(lits, own)
    objs += [(o, n, t, op, r, "DYNAMIC") for o, n, t, op, r in dyn]
    NODE_WARN[node] += warns
    if re.search(r"\bEXECUTE\s+IMMEDIATE\s+(?!')", up) or re.search(r"\bOPEN\s+\w+\s+FOR\s+(?!SELECT|WITH|')", up) or "DBMS_SQL" in up:
        NODE_WARN[node].append("동적 SQL(변수 실행) 존재 — 리터럴 조각으로 추출, 연결 이름은 수동 확인")
    NODE_TABLES[node] = objs
    pkg = nm if node_kind(own, nm) == "PACKAGE" else None
    for tgt in call_refs(up, own, pkg):
        if tgt[:2] == (own, nm) and tgt[2] == mb: continue
        if tgt[:2] != (own, nm):
            ok = any(r[0] == tgt[0] and r[1] == tgt[1] for r in DEPS.get((own, nm), ()))
            if not ok:
                UNRES.append(dict(FROM=f"{own}.{nm}.{mb}", TO=".".join(x for x in tgt if x), REASON="ALL_DEPENDENCIES 에 없음(동적 호출/오탐) — 간선 제외"))
                continue
        EDGES.add((node, tgt))
    # 동적 리터럴 안 함수 호출 (예: 'SELECT FN_X(..) FROM ..')
    for lit in lits:
        if not SQLISH.search(lit): continue
        lm, _ = mask_strings(lit)
        for tgt in call_refs(lm.upper(), own, pkg):
            if tgt[:2] == (own, nm) and tgt[2] == mb: continue
            EDGES.add((node, tgt)); NODE_WARN[node].append(f"동적 SQL 내 호출 {'.'.join(x for x in tgt if x)}")
    # 패키지 사용 시 패키지 레벨 코드 + 참조된 패키지 레벨 커서
    if pkg:
        p = parsed(own, nm, "PACKAGE BODY")
        if p:
            if mb != "<PKG-LEVEL>" and "<PKG-LEVEL>" in p[3]: EDGES.add((node, (own, nm, "<PKG-LEVEL>")))
            for seg in p[3]:
                if seg.startswith("CURSOR:") and re.search(r"\b" + re.escape(seg[7:]) + r"\b", up) and seg != mb:
                    EDGES.add((node, (own, nm, seg)))

reach = {}
stack = []
for s, e in seeds:
    grp, scr = e["GROUP"], e["SCREEN"]
    USERS[s].add((grp, scr)); ROOTS[s].add(e["OBJECT"]); stack.append(s)
seen = set()
while stack:
    n = stack.pop()
    if n in seen: continue
    seen.add(n); analyze(n)
    for a, b in list(EDGES):
        if a == n and b not in seen: stack.append(b)
# 사용자 전파 (역방향 BFS 대신 정방향 폐포를 시드별로)
adj = collections.defaultdict(set)
for a, b in EDGES: adj[a].add(b)
NODE_USERS = collections.defaultdict(set); NODE_ROOTS = collections.defaultdict(set)
for s, e in seeds:
    st, vis = [s], set()
    while st:
        x = st.pop()
        if x in vis: continue
        vis.add(x); NODE_USERS[x].add((e["GROUP"], e["SCREEN"])); NODE_ROOTS[x].add(e["OBJECT"])
        st.extend(adj[x] - vis)

# ───────────── 파서 검증 (객체 전체) ─────────────
def all_segments(own, nm):
    k = node_kind(own, nm)
    if k == "PACKAGE":
        p = parsed(own, nm, "PACKAGE BODY")
        return [] if p is None else [(own, nm, sg) for sg in p[3]]
    return [(own, nm, "")]
check = []
used_objs = sorted({(n[0], n[1]) for n in seen})
for own, nm in used_objs:
    segs = all_segments(own, nm)
    for sg in segs: analyze(sg)
    found = {(o, n) for sg in segs for (o, n, t, op, r, src) in NODE_TABLES.get(sg, []) if o and t and src == "STATIC"}
    found_dyn = {(o, n) for sg in segs for (o, n, t, op, r, src) in NODE_TABLES.get(sg, []) if o and t and src == "DYNAMIC"}
    dep_tabs = {(ro, rn) for ro, rn, rt in DEPS.get((own, nm), ()) if rt in ("TABLE", "VIEW", "MATERIALIZED VIEW")}
    # 동의어 의존 → 실체
    for ro, rn, rt in DEPS.get((own, nm), ()):
        if rt == "SYNONYM":
            r = resolve_name([rn], ro)
            if r and r[2] & {"TABLE", "VIEW", "MATERIALIZED VIEW"}: dep_tabs.add((r[0], r[1]))
    # %TYPE 앵커 테이블 (의존에는 잡히지만 데이터 접근 아님)
    anchors = set()
    for sg in segs:
        nt = node_text(sg)
        if not nt: continue
        for am in ANCHOR.finditer(nt[1]):
            ch = am.group(1).upper().split(".")
            for cut in (ch, ch[:-1]):
                if not cut: continue
                r = resolve_name(cut, own)
                if r and r[2] & {"TABLE", "VIEW"}: anchors.add((r[0], r[1]))
    used_segs = {n for n in seen if (n[0], n[1]) == (own, nm)}
    used_tabs = {(o, n) for sg in used_segs for (o, n, t, op, r, src) in NODE_TABLES.get(sg, []) if o and t}
    check.append(dict(OWNER=own, OBJECT=nm, KIND=node_kind(own, nm), SEGMENTS=len(segs), USED_SEGMENTS=len(used_segs),
        DEP_TABLES=len(dep_tabs), PARSED_STATIC=len(found), PARSED_DYNAMIC=len(found_dyn),
        MISSING_IN_PARSE=" ".join(sorted(f"{a}.{b}" for a, b in dep_tabs - found - found_dyn - anchors)),
        ANCHOR_ONLY=" ".join(sorted(f"{a}.{b}" for a, b in (dep_tabs & anchors) - found - found_dyn)),
        EXTRA_NOT_IN_DEPS=" ".join(sorted(f"{a}.{b}" for a, b in found - dep_tabs)),
        DYNAMIC_ONLY=" ".join(sorted(f"{a}.{b}" for a, b in found_dyn - found)),
        UNUSED_MEMBER_ONLY_TABLES=" ".join(sorted(f"{a}.{b}" for a, b in (found | found_dyn) - used_tabs))))

# ───────────── 출력 ─────────────
def w(name, rows, cols):
    with (D / name).open("w", encoding="utf-8-sig", newline="") as fh:
        wr = csv.DictWriter(fh, fieldnames=cols, extrasaction="ignore"); wr.writeheader()
        for r in rows: wr.writerow(r)
def nodestr(n): return f"{n[0]}.{n[1]}" + (f".{n[2]}" if n[2] else "")
mem_rows = []
for n in sorted(seen):
    mem_rows.append(dict(NODE=nodestr(n), OWNER=n[0], OBJECT=n[1], MEMBER=n[2], KIND=node_kind(n[0], n[1]),
        OVERLOAD=OVERLOAD.get(n, 0), GROUPS=" ".join(sorted({g for g, _ in NODE_USERS[n]})),
        SCREENS=" ".join(sorted({s for _, s in NODE_USERS[n]})), ROOTS=" ".join(sorted(NODE_ROOTS[n]))[:3000],
        WARN=" / ".join(sorted(set(NODE_WARN[n])))[:2000]))
w("closure_members.csv", mem_rows, ["NODE", "OWNER", "OBJECT", "MEMBER", "KIND", "OVERLOAD", "GROUPS", "SCREENS", "ROOTS", "WARN"])
w("call_edges.csv", [dict(FROM=nodestr(a), TO=nodestr(b)) for a, b in sorted(EDGES) if a in seen], ["FROM", "TO"])
mt = []
for n in sorted(seen):
    for o, nm, t, op, r, src in NODE_TABLES.get(n, []):
        mt.append(dict(NODE=nodestr(n), T_OWNER=o or "", T_NAME=nm, T_TYPE=("GTT" if (o, nm) in TEMP else "|".join(sorted(t))) if t else "UNRESOLVED",
                       OP=op, SRC=src, RAW=r, GROUPS=" ".join(sorted({g for g, _ in NODE_USERS[n]})), SCREENS=" ".join(sorted({s for _, s in NODE_USERS[n]}))))
w("member_tables.csv", mt, ["NODE", "T_OWNER", "T_NAME", "T_TYPE", "OP", "SRC", "RAW", "GROUPS", "SCREENS"])
# 사용 객체의 전 세그먼트(미사용 멤버 포함) 테이블 — 제외 목록 근거
allrows = []
for own, nm in used_objs:
    for sg in all_segments(own, nm):
        for o, n2, t, op, r, src in NODE_TABLES.get(sg, []):
            allrows.append(dict(NODE=nodestr(sg), USED="Y" if sg in seen else "N", T_OWNER=o or "", T_NAME=n2,
                                T_TYPE=("GTT" if (o, n2) in TEMP else "|".join(sorted(t))) if t else "UNRESOLVED", OP=op, SRC=src))
        if not NODE_TABLES.get(sg):
            allrows.append(dict(NODE=nodestr(sg), USED="Y" if sg in seen else "N", T_OWNER="", T_NAME="", T_TYPE="", OP="", SRC=""))
w("all_segment_tables.csv", allrows, ["NODE", "USED", "T_OWNER", "T_NAME", "T_TYPE", "OP", "SRC"])
w("parser_check.csv", check, ["OWNER", "OBJECT", "KIND", "SEGMENTS", "USED_SEGMENTS", "DEP_TABLES", "PARSED_STATIC", "PARSED_DYNAMIC", "MISSING_IN_PARSE", "ANCHOR_ONLY", "EXTRA_NOT_IN_DEPS", "DYNAMIC_ONLY", "UNUSED_MEMBER_ONLY_TABLES"])
w("unresolved_refs.csv", UNRES + [dict(FROM="ENTRY", TO=e["OBJECT"], REASON="진입 객체 DB 미존재/해석 불가") for e in unresolved_entries], ["FROM", "TO", "REASON"])
w("combo_tables.csv", combo_rows, ["GROUP", "SCREEN", "COMBO", "OWNER", "OBJECT", "TYPE", "OP", "RAW"])
print("nodes", len(seen), "edges", len(EDGES), "member_tables", len(mt), "objects", len(used_objs), "unresolved entries", len(unresolved_entries))
miss = [c for c in check if c["MISSING_IN_PARSE"]]
print("parser MISSING objects:", len(miss))
for c in miss[:40]: print("  ", c["OBJECT"], "->", c["MISSING_IN_PARSE"][:200])
