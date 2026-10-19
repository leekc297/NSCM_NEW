"""'-' 리터럴 사용처 정적 분석 엔진 (T-SQL / PL-SQL 공용) — 읽기 전용, DB 접속 없음

scan(text, dialect, catalog) → '-' 리터럴 출현마다
  role    : 문장 안에서의 쓰임 (BRANCH / PREDICATE / NVL / NVL_CMP / CASE_VALUE / LOAD / ASSIGN / DEFAULT / NON_SENTINEL / OTHER)
  refs    : 관련 컬럼 참조 [(table, column, tier)]  tier = 확정 / 추정 / 간접 / 변수
  dest    : 적재 대상 컬럼 [(table, column, tier)]  (INSERT 위치 대응 · UPDATE SET · MERGE)
catalog  : {TABLE: {"cols": set, "kind": "real"|"gtt"|"view"}}  — 이름은 대문자

한계: 정적 분석. 임시테이블·CTE·파생 테이블을 거친 컬럼은 '간접', 변수 경유는 '변수' 로만 표시한다.
"""
import re, bisect

TOK = re.compile(r"""
 (?P<ws>\s+)
|(?P<lc>--[^\n]*)
|(?P<bc>/\*.*?\*/)
|(?P<str>N?'(?:[^']|'')*')
|(?P<bid>\[[^\]\n]*\])
|(?P<qid>"[^"\n]*")
|(?P<num>\d+(?:\.\d+)?)
|(?P<id>[@#:]{0,2}[A-Za-z_\u0080-￿][\w$#@\u0080-￿]*)
|(?P<op><>|!=|\^=|<=|>=|\|\||:=|=>|[=<>(),;.+\-*/%])
|(?P<other>.)
""", re.S | re.X)

KW = set("""SELECT FROM WHERE AND OR NOT NULL IS IN LIKE BETWEEN EXISTS CASE WHEN THEN ELSE END AS ON JOIN INNER LEFT RIGHT FULL OUTER CROSS
APPLY UNION ALL EXCEPT INTERSECT MINUS GROUP BY ORDER HAVING INSERT INTO VALUES UPDATE SET DELETE MERGE USING MATCHED IF ELSIF WHILE BEGIN
DECLARE RETURN WITH OVER PARTITION ASC DESC TOP DISTINCT NOLOCK CURSOR FOR OPEN FETCH CLOSE LOOP EXIT EXEC EXECUTE PRINT GO COMMIT ROLLBACK
DEFAULT VARCHAR NVARCHAR VARCHAR2 CHAR NUMBER INT DATE TABLE VIEW PROCEDURE FUNCTION IS OUT INOUT ROWNUM DUAL PIVOT UNPIVOT COLLATE ESCAPE
LIMIT OFFSET ROWS ONLY NEXT FIRST LAST NULLS TRUE FALSE SYSDATE GETDATE CONNECT PRIOR START LEVEL IMMEDIATE BULK COLLECT RETURNING
OUTPUT INSERTED DELETED PERCENT TIES READONLY TRAN TRANSACTION TRY CATCH THROW RAISERROR GOTO DEALLOCATE TRUNCATE DROP CREATE ALTER""".split())

NVL_FN = {"ISNULL", "NVL", "COALESCE", "IFNULL"}
NONSENT_FN = set("""REPLACE TRANSLATE CHARINDEX PATINDEX INSTR STUFF SUBSTRING SUBSTR LEFT RIGHT STRING_SPLIT SPLIT CONCAT CONCAT_WS LPAD RPAD
LTRIM RTRIM TRIM FORMAT CONVERT CAST TO_CHAR TO_DATE TO_NUMBER REGEXP_REPLACE REGEXP_SUBSTR REGEXP_INSTR REGEXP_LIKE REGEXP_COUNT LISTAGG
STRING_AGG REPLICATE QUOTENAME DATEPART DATENAME STR PARSENAME REVERSE LEN LENGTH UPPER_DUMMY""".split())
PARTIAL_RX = re.compile(r"\b(SUBSTRING|SUBSTR|LEFT|RIGHT|CHARINDEX|INSTR|PATINDEX|LEN|LENGTH|STUFF|REPLACE|ASCII|REVERSE|PARSENAME|TRANSLATE|REGEXP_\w+)\s*\(", re.I)
TRANSPARENT_FN = set("TRIM LTRIM RTRIM UPPER LOWER NULLIF TO_CHAR TO_NCHAR CAST CONVERT MAX MIN NVL2 DISTINCT".split())
CMP_OPS = {"=", "<>", "!=", "^=", "<", ">", "<=", ">="}
SETOPS = {"UNION", "EXCEPT", "INTERSECT", "MINUS"}
BRANCH_KW = {"WHEN", "IF", "ELSIF", "WHILE"}
PRED_KW = {"WHERE", "ON", "HAVING", "UNTIL", "CHECK"}
VALUE_KW = {"SELECT", "SET", "THEN", "ELSE", "VALUES", "RETURN", "INTO", "BY", "DEFAULT", ":=", "USING", "PRINT"}

TSQL_STARTERS = set("""INSERT UPDATE DELETE MERGE IF WHILE DECLARE BEGIN END RETURN EXEC EXECUTE PRINT TRUNCATE DROP CREATE ALTER FETCH OPEN
CLOSE DEALLOCATE COMMIT ROLLBACK GOTO RAISERROR THROW GO SELECT SET ELSE WITH""".split())


class Tok:
    __slots__ = ("k", "t", "u", "p")

    def __init__(self, k, t, p):
        self.k = k; self.t = t; self.p = p
        if k == "bid" or k == "qid":
            self.u = t[1:-1].upper(); self.k = "id"
        elif k == "id":
            self.u = t.upper()
        elif k == "str":
            self.u = t
        else:
            self.u = t.upper()

    def __repr__(self):
        return self.t


def tokenize(text):
    toks = []; comments = []
    for m in TOK.finditer(text):
        k = m.lastgroup
        if k == "ws":
            continue
        if k in ("lc", "bc"):
            comments.append((m.start(), m.group()))
            continue
        toks.append(Tok(k, m.group(), m.start()))
    return toks, comments


def str_value(t):
    s = t[1:] if t[:1] in "Nn" and t[1:2] == "'" else t
    return s[1:-1].replace("''", "'")


def is_dash(tok):
    return tok.k == "str" and str_value(tok.t) == "-"


def is_var(u, dialect):
    if u[:1] in "@:":
        return True
    return False


# ---------------------------------------------------------------------------------------------------------------
# 문장 분할
# ---------------------------------------------------------------------------------------------------------------
def segments(toks, dialect):
    """(start, end) 토큰 구간 목록."""
    segs = []; start = 0; depth = 0; case_d = 0
    n = len(toks)
    if dialect == "plsql":
        for i, t in enumerate(toks):
            if t.t == ";":
                segs.append((start, i)); start = i + 1
        if start < n:
            segs.append((start, n))
        return segs
    starter = None; seen_body = False     # seen_body: INSERT 세그먼트에서 SELECT/VALUES/EXEC 가 이미 나왔는가
    for i, t in enumerate(toks):
        u = t.u
        if t.t == "(":
            depth += 1; continue
        if t.t == ")":
            depth = max(0, depth - 1); continue
        if t.k != "id" and t.t != ";":
            continue
        if u == "CASE":
            case_d += 1; continue
        if u == "END" and case_d > 0:
            case_d -= 1; continue
        if depth > 0 or case_d > 0:
            continue
        cut = False
        if t.t == ";":
            segs.append((start, i)); start = i + 1; starter = None; seen_body = False
            continue
        if u in TSQL_STARTERS:
            prev = toks[i - 1].u if i > start else None
            nxt = toks[i + 1] if i + 1 < n else None
            if u == "SELECT":
                if starter in ("INSERT", "WITH") and not seen_body:
                    seen_body = True
                elif prev in SETOPS or prev == "ALL" or prev == "FOR" or prev == "AS" or i == start:
                    pass
                else:
                    cut = True
            elif u in ("UPDATE", "INSERT", "DELETE"):
                if starter == "MERGE" and prev == "THEN":
                    pass
                elif prev in ("FOR", "AFTER", "OF", ",", "INSTEAD") or (nxt and nxt.t == ","):
                    pass
                elif starter == "WITH" and not seen_body:
                    seen_body = True
                else:
                    cut = True
            elif u == "SET":
                if starter in ("UPDATE", "MERGE") or prev == "UPDATE":
                    pass
                else:
                    cut = True
            elif u == "WITH":
                # CTE 시작만 경계 — 테이블 힌트 WITH (NOLOCK) / WITH RECOMPILE 등은 제외
                if nxt and nxt.k == "id" and i + 2 < n and toks[i + 2].u in ("AS", "("):
                    cut = True
            elif u in ("EXEC", "EXECUTE"):
                if starter == "INSERT" and not seen_body:
                    seen_body = True
                else:
                    cut = True
            elif u == "IF":
                cut = prev not in ("TABLE", "PROCEDURE", "VIEW", "FUNCTION", "INDEX", "TRIGGER")
            elif u == "VALUES":
                pass
            else:
                cut = True
        elif u == "VALUES" and starter == "INSERT":
            seen_body = True
        if cut:
            if i > start:
                segs.append((start, i))
            start = i; starter = u; seen_body = False
    if start < n:
        segs.append((start, n))
    return segs


# ---------------------------------------------------------------------------------------------------------------
# 블록(괄호·집합연산 단위)과 테이블 별칭
# ---------------------------------------------------------------------------------------------------------------
class Block:
    __slots__ = ("parent", "srcs", "start", "end")

    def __init__(self, parent, start):
        self.parent = parent; self.srcs = []; self.start = start; self.end = None   # srcs: (alias, kind, name, inner_block)


def classify_name(name, catalog, ctes, views):
    if name[:1] in "#@":
        return "temp"
    if name in ctes:
        return "cte"
    c = catalog.get(name)
    if c:
        return c["kind"]
    if name in views:
        return "view"
    return "unknown"


def build_blocks(toks, s, e, catalog, views, dialect, qual=None):
    """세그먼트 [s,e) 의 블록 트리 + 토큰별 블록 + 별칭 정의."""
    root = Block(None, s)
    blk_of = {}
    cur = root
    stack = []          # 괄호로 연 블록의 복귀 지점
    paren_blk = {}      # '(' 토큰 index → 그 괄호 안 블록
    ctes = set()
    # CTE 이름 수집
    for i in range(s, e - 2):
        if toks[i].k == "id" and toks[i + 1].u == "AS" and toks[i + 2].t == "(" and (toks[i - 1].u in ("WITH", ",") if i > s else False):
            ctes.add(toks[i].u)
    i = s
    while i < e:
        t = toks[i]
        if t.t == "(":
            nb = Block(cur, i); paren_blk[i] = nb
            stack.append(cur); cur = nb
        elif t.t == ")":
            cur.end = i
            # 집합연산으로 갈린 형제 블록이면 괄호를 연 부모까지 복귀
            cur = stack.pop() if stack else root
        elif t.k == "id" and t.u in SETOPS:
            nb = Block(cur.parent, i)
            if cur.parent is None:
                nb = Block(None, i); nb.parent = root.parent
                # 최상위 집합연산: 형제 블록 (부모 없음) — root 와 별개 스코프
                cur = nb
            else:
                cur = nb
        blk_of[i] = cur
        i += 1

    def parse_ref(j, into=False):
        """j 위치에서 테이블 참조 1개 해석 → (다음 index, alias, kind, name, inner_block) 또는 None"""
        if j >= e:
            return None
        t = toks[j]
        inner = None
        if t.t == "(":
            inner = paren_blk.get(j)
            d = 0; k = j
            while k < e:
                if toks[k].t == "(":
                    d += 1
                elif toks[k].t == ")":
                    d -= 1
                    if d == 0:
                        break
                k += 1
            j2 = k + 1; kind = "derived"; name = "(subquery)"
        elif t.k == "id" and t.u not in KW:
            parts = [t.u]; k = j + 1
            while k + 1 < e and toks[k].t == "." :
                if toks[k + 1].k == "id":
                    parts.append(toks[k + 1].u); k += 2
                elif toks[k + 1].t == ".":      # db..table
                    k += 1
                else:
                    break
            name = parts[-1]; j2 = k
            if qual and len(parts) >= 2 and parts[0] in qual[0] and parts[0] != qual[1]:
                name = parts[0] + "::" + parts[-1]          # 타 DB 한정 참조
            if j2 < e and toks[j2].t == "(" and not into:
                # 테이블 반환 함수 / 힌트 (NOLOCK)
                d = 0; k = j2
                while k < e:
                    if toks[k].t == "(":
                        d += 1
                    elif toks[k].t == ")":
                        d -= 1
                        if d == 0:
                            break
                    k += 1
                if j2 + 1 < e and toks[j2 + 1].u in ("NOLOCK", "READUNCOMMITTED", "UPDLOCK", "ROWLOCK", "TABLOCK", "HOLDLOCK", "INDEX", "READPAST", "TABLOCKX", "XLOCK", "FORCESEEK"):
                    kind = classify_name(name, catalog, ctes, views)
                else:
                    kind = "func"
                j2 = k + 1
            else:
                kind = classify_name(name, catalog, ctes, views)
        else:
            return None
        # 힌트 WITH (NOLOCK)
        if j2 + 1 < e and toks[j2].u == "WITH" and toks[j2 + 1].t == "(":
            k = j2 + 1; d = 0
            while k < e:
                if toks[k].t == "(":
                    d += 1
                elif toks[k].t == ")":
                    d -= 1
                    if d == 0:
                        break
                k += 1
            j2 = k + 1
        alias = None
        if j2 < e and toks[j2].u == "AS" and j2 + 1 < e and toks[j2 + 1].k == "id":
            alias = toks[j2 + 1].u; j2 += 2
        elif j2 < e and toks[j2].k == "id" and toks[j2].u not in KW and not into:
            alias = toks[j2].u; j2 += 1
        elif into and j2 < e and toks[j2].k == "id" and toks[j2].u not in KW and toks[j2].u != "USING":
            alias = toks[j2].u; j2 += 1
        return j2, alias, kind, name, inner

    i = s
    while i < e:
        t = toks[i]
        if t.k == "id":
            u = t.u; j = None; into = False
            if u in ("FROM", "JOIN", "APPLY", "USING"):
                j = i + 1
            elif u == "INTO":
                j = i + 1; into = True
            elif u == "UPDATE" or (u == "MERGE" and i + 1 < e and toks[i + 1].u != "INTO"):
                j = i + 1; into = True
                if j < e and toks[j].u == "TOP":      # UPDATE TOP (n) T
                    j = None
            elif u == "DELETE" and i + 1 < e and toks[i + 1].u != "FROM" and toks[i + 1].k == "id" and toks[i + 1].u not in KW:
                j = None     # DELETE A FROM T A — 별칭은 FROM 에서 정의됨
            if j is not None:
                b = blk_of.get(i, root)
                while True:
                    r = parse_ref(j, into)
                    if not r:
                        break
                    j2, alias, kind, name, inner = r
                    b.srcs.append((alias or name, kind, name, inner))
                    if alias and kind in ("real", "gtt", "view"):
                        b.srcs.append((name, kind, name, inner))       # 테이블명 직접 한정도 허용
                    if u == "FROM" and j2 < e and toks[j2].t == ",":
                        j = j2 + 1; continue
                    break
        i += 1
    return root, blk_of, paren_blk, ctes


def block_chain(b):
    while b is not None:
        yield b
        b = b.parent


# ---------------------------------------------------------------------------------------------------------------
# 컬럼 참조 해석
# ---------------------------------------------------------------------------------------------------------------
def norm_var(u):
    u = u.lstrip("@:")
    for _ in range(2):
        u2 = re.sub(r"^(P|V|L|I|O|IN|LV|PV|G|PI|PO|S|T)_", "", u)
        if u2 == u:
            break
        u = u2
    return u


class Scanner:
    def __init__(self, catalog, pop, views=(), dialect="tsql", qual=None):
        self.catalog = catalog; self.pop = pop; self.views = set(views); self.dialect = dialect; self.qual = qual
        self._dynmap = None
        self.plain = {}
        for k in pop:
            self.plain.setdefault(k.split("::")[-1], set()).add(k)
        self.col_tables = {}
        for tb, cols in pop.items():
            for c in cols:
                self.col_tables.setdefault(c, set()).add(tb)

    # --- 표현식에서 컬럼 참조 추출 -----------------------------------------------------------------------------
    def expr_refs(self, toks, a, b):
        """[a,b) 토큰 구간이 '값으로 내놓는' 컬럼 참조 (alias|None, column, index) 목록 + 변수 목록.
           - 값을 그대로 넘기는 함수(TRIM·NVL·MAX …)는 안으로 들어가고, 그 외 함수의 인자는 값이 아니므로 건너뛴다
           - 스칼라 서브쿼리는 선택목록만, CASE 식은 THEN/ELSE 결과식만 본다"""
        cols = []; vars_ = []
        i = a
        while i < b:
            t = toks[i]
            if t.t == "(":
                if i + 1 < b and toks[i + 1].u == "SELECT":
                    close = self.match_close(toks, i, b)
                    lists = self.select_lists(toks, i + 1, close)
                    if lists:
                        c2, v2 = self.expr_refs(toks, lists[0][0], lists[0][1]); cols += c2; vars_ += v2
                    i = close + 1; continue
                i += 1; continue
            if t.k == "id":
                u = t.u
                if u == "CASE":
                    ce = self.case_end(toks, i, b)
                    for ra, rb in self.case_results(toks, i, ce):
                        c2, v2 = self.expr_refs(toks, ra, rb); cols += c2; vars_ += v2
                    i = ce; continue
                if u[:1] in "@:":
                    vars_.append(u); i += 1; continue
                if i + 1 < b and toks[i + 1].t == "(":
                    if u in TRANSPARENT_FN or u in NVL_FN:
                        i += 1; continue
                    i = self.match_close(toks, i + 1, b) + 1; continue          # 함수 인자는 값이 아님
                if u in KW or u[:1] == "#":
                    i += 1; continue
                parts = [u]; k = i + 1
                while k + 1 < b and toks[k].t == "." and toks[k + 1].k == "id":
                    parts.append(toks[k + 1].u); k += 2
                if k < b and toks[k].t == "(":           # pkg.func( … ) / dbo.fn( … )
                    i = self.match_close(toks, k, b) + 1; continue
                if len(parts) == 1:
                    cols.append((None, parts[0], i))
                else:
                    cols.append((parts[-2], parts[-1], i))
                i = k; continue
            i += 1
        return cols, vars_

    def case_end(self, toks, cs, lim):
        d = 0; nest = 0; k = cs + 1
        while k < lim:
            t = toks[k]
            if t.t == "(":
                d += 1
            elif t.t == ")":
                d -= 1
            elif d == 0 and t.k == "id":
                if t.u == "CASE":
                    nest += 1
                elif t.u == "END":
                    if nest == 0:
                        return k + 1
                    nest -= 1
            k += 1
        return lim

    def case_results(self, toks, cs, ce):
        """CASE … END 의 THEN/ELSE 결과식 구간들."""
        res = []; d = 0; nest = 0; start = None; k = cs + 1
        while k < ce:
            t = toks[k]
            if t.t == "(":
                d += 1
            elif t.t == ")":
                d -= 1
            elif d == 0 and t.k == "id":
                u = t.u
                if u == "CASE":
                    nest += 1
                elif u == "END":
                    if nest == 0:
                        if start is not None:
                            res.append((start, k)); start = None
                    else:
                        nest -= 1
                elif nest == 0:
                    if u in ("THEN", "ELSE"):
                        if start is not None:
                            res.append((start, k))
                        start = k + 1
                    elif u == "WHEN":
                        if start is not None:
                            res.append((start, k)); start = None
            k += 1
        return res

    def resolve(self, alias, col, idx, ctx):
        """→ [(table, col, tier)] (모집단 한정) , note"""
        blk_of, root, modtables = ctx["blk_of"], ctx["root"], ctx["modtables"]
        b0 = blk_of.get(idx, root)
        out = []
        if alias is not None:
            hit = None
            for b in block_chain(b0):
                defs = [s for s in b.srcs if s[0] == alias]
                if defs:
                    hit = defs; break
            if hit is None and b0 is not root:
                defs = [s for s in root.srcs if s[0] == alias]
                hit = defs or None
            if hit is None:
                c = self.catalog.get(alias)
                if c:
                    hit = [(alias, c["kind"], alias, None)]
            if hit is None and self._dynmap and alias in self._dynmap:
                names = self._dynmap[alias]
                reals = sorted(n for k, n in names if k == "real")
                if reals and len(names) == len(reals):
                    cand = [(n, col, "추정") for n in reals if col in self.pop.get(n, ())]
                    return cand, ("동적 SQL 조각 간 별칭(" + alias + "→" + ",".join(reals)[:60] + ")") if cand else "모집단 밖(" + ",".join(reals)[:60] + ")"
                return self.indirect(col, modtables, "동적 SQL 별칭(" + alias + ") 비실테이블")
            if hit is None:
                return self.indirect(col, modtables, "별칭 미해석(" + alias + ")")
            names = {(k, n) for _, k, n, _ in hit}
            if len(names) > 1:      # UPDATE A … FROM T A — 대상 표기(A)가 별칭 자신이면 실제 정의만 남긴다
                real_defs = {x for x in names if not (x[0] == "unknown" and x[1] == alias)}
                if real_defs:
                    names = real_defs
                    hit = [h for h in hit if (h[1], h[2]) in names]
            if len(names) == 1:
                kind, name = next(iter(names))
                if kind == "real":
                    if col in self.pop.get(name, ()):
                        return [(name, col, "확정")], ""
                    return [], "모집단 밖(" + name + ")"
                if kind == "gtt":
                    return self.named(col, "GTT(" + name + ")")
                inner = hit[0][3]
                if inner is not None:
                    tabs = {n for _, k, n, _ in self.block_sources(inner) if k == "real"}
                    cand = [(tb, col, "간접") for tb in sorted(tabs) if col in self.pop.get(tb, ())]
                    if cand:
                        return cand, "파생 테이블 내부 원천"
                return self.indirect(col, modtables, kind + "(" + name + ")")
            cand = [(n, col, "추정") for k, n in sorted(names) if k == "real" and col in self.pop.get(n, ())]
            return cand, "별칭 중복 정의"
        # 무별칭
        for b in block_chain(b0):
            if not b.srcs:
                continue
            reals = sorted({n for _, k, n, _ in b.srcs if k == "real" and col in self.catalog.get(n, {}).get("cols", ())})
            others = [s for s in b.srcs if s[1] != "real"]
            gtt_has = [n for _, k, n, _ in b.srcs if k == "gtt" and col in self.catalog.get(n, {}).get("cols", ())]
            if reals:
                if len(reals) == 1 and not others:
                    tb = reals[0]
                    return ([(tb, col, "확정")] if col in self.pop.get(tb, ()) else []), ("" if col in self.pop.get(tb, ()) else "모집단 밖(" + tb + ")")
                return [(tb, col, "추정") for tb in reals if col in self.pop.get(tb, ())], "무별칭·후보 다수/비실테이블 혼재"
            if gtt_has:
                return self.named(col, "GTT(" + gtt_has[0] + ")")
            if others:
                return self.indirect(col, modtables, "무별칭·" + others[0][1])
        if self._dynmap and ctx.get("dynamic"):
            reals = sorted({n for names in self._dynmap.values() for k, n in names if k == "real" and col in self.catalog.get(n, {}).get("cols", ())})
            cand = [(n, col, "추정") for n in reals if col in self.pop.get(n, ())]
            if cand:
                return cand, "동적 SQL 조각 간 무별칭"
        return [], "컬럼 아님/미해석"

    def dyn_alias_map(self, toks):
        """모듈 안 문자열 리터럴(동적 SQL 조각)을 이어 붙여 별칭 → {(kind, table)} 맵을 만든다."""
        parts = [str_value(t.t) for t in toks if t.k == "str" and len(t.t) > 8]
        if not parts:
            return None
        joined = "\n".join(parts)
        if not re.search(r"\b(FROM|JOIN|UPDATE|INTO)\b", joined, re.I):
            return None
        dt, _ = tokenize(joined)
        root, blk_of, _, _ = build_blocks(dt, 0, len(dt), self.catalog, self.views, self.dialect, self.qual)
        m = {}
        seen = set()
        for b in [root] + list(blk_of.values()):
            if id(b) in seen:
                continue
            seen.add(id(b))
            for alias, kind, name, inner in b.srcs:
                m.setdefault(alias, set()).add((kind, name))
        return m

    def block_sources(self, b, depth=0):
        res = list(b.srcs)
        return res

    def indirect(self, col, modtables, why):
        cand = [(tb, col, "간접") for tb in sorted(modtables) if col in self.pop.get(tb, ())]
        return cand, why

    def named(self, col, why):
        cand = [(tb, col, "간접") for tb in sorted(self.col_tables.get(col, ()))]
        return cand, why

    def var_cands(self, v, modtables):
        c = norm_var(v)
        return [(tb, c, "변수") for tb in sorted(modtables) if c in self.pop.get(tb, ())]

    # --- 본체 ---------------------------------------------------------------------------------------------------
    def scan(self, text, dynamic=False, modtables=None, base_line=None):
        toks, comments = tokenize(text)
        nl = [m.start() for m in re.finditer("\n", text)]
        line_of = lambda p: bisect.bisect_right(nl, p) + 1
        if modtables is None:
            modtables = set()
            for t in toks:
                if t.k == "id" and t.u in self.plain:
                    modtables |= self.plain[t.u]
        if not dynamic:
            self._dynmap = self.dyn_alias_map(toks)
        segs = segments(toks, self.dialect)
        out = []
        seg_ctx = {}
        seg_idx = 0
        dash_idx = [i for i, t in enumerate(toks) if t.k == "str" and ("-" in t.t)]
        for i in dash_idx:
            t = toks[i]
            v = str_value(t.t)
            while seg_idx < len(segs) - 1 and segs[seg_idx][1] <= i:
                seg_idx += 1
            s, e = segs[seg_idx] if segs else (0, len(toks))
            if not (s <= i < e):
                # 세그먼트 경계 토큰(';') 등 — 가장 가까운 구간
                for k, (a, b) in enumerate(segs):
                    if a <= i < b:
                        s, e = a, b; break
            if v == "-":
                if (s, e) not in seg_ctx:
                    root, blk_of, paren_blk, ctes = build_blocks(toks, s, e, self.catalog, self.views, self.dialect, self.qual)
                    seg_ctx[(s, e)] = {"root": root, "blk_of": blk_of, "paren_blk": paren_blk, "modtables": modtables, "s": s, "e": e, "dynamic": dynamic}
                r = self.classify(toks, i, seg_ctx[(s, e)])
                r["line"] = base_line if base_line else line_of(t.p)
                r["dynamic"] = dynamic
                r["pos"] = t.p; r["len"] = len(t.t)
                out.append(r)
            elif "'-'" in v:
                # 동적 SQL 문자열 — 내용을 다시 분석 (별칭 후보는 모듈 전체 테이블)
                inner = self.scan(v, dynamic=True, modtables=modtables)[0]
                raw_pos = [m.start() for m in re.finditer(r"''-''", t.t)]
                for n_, r in enumerate(inner):
                    if base_line:
                        r["line"] = base_line; r["pos"] = None; r["len"] = None
                    elif len(raw_pos) == len(inner):
                        r["pos"] = t.p + raw_pos[n_]; r["len"] = 5; r["line"] = line_of(r["pos"])
                    else:
                        r["pos"] = None; r["len"] = None; r["line"] = line_of(t.p)
                    out.append(r)
        return out, comments

    def classify(self, toks, i, ctx):
        s, e = ctx["s"], ctx["e"]
        res = {"role": "OTHER", "detail": "", "refs": [], "dest": [], "notes": [], "nullchk": False, "expr": ""}
        prev = toks[i - 1] if i > s else None
        nxt = toks[i + 1] if i + 1 < e else None

        def add_refs(a, b, key="refs"):
            cols, vars_ = self.expr_refs(toks, a, b)
            for al, c, idx in cols:
                cand, note = self.resolve(al, c, idx, ctx)
                if cand:
                    res[key].extend(cand)
                if note:
                    res["notes"].append((al + "." if al else "") + c + ": " + note)
            for v in vars_:
                cand = self.var_cands(v, ctx["modtables"])
                res[key].extend(cand)
                res["notes"].append(v + ": 변수")
            res["expr"] = " ".join(x.t for x in toks[a:b])[:160]
            return cols, vars_

        # 연결 구분자
        if (prev and prev.t in ("+", "||")) or (nxt and nxt.t in ("+", "||")):
            res["role"] = "NON_SENTINEL"; res["detail"] = "문자열 연결 구분자"; return res

        # 감싸는 괄호·함수
        fn, open_idx, argpos = self.enclosing(toks, i, s)
        # 비교 연산자 인접
        op_side = None
        if prev and prev.t in CMP_OPS:
            op_side = "L"       # <expr> op '-'
        elif nxt and nxt.t in CMP_OPS:
            op_side = "R"       # '-' op <expr>
        like = prev and prev.u == "LIKE"
        in_list = fn == "IN"

        if fn and (fn in NONSENT_FN or "SPLIT" in fn) and not op_side:
            res["role"] = "NON_SENTINEL"; res["detail"] = "함수 인자(" + fn + ")"; return res

        if fn in NVL_FN and argpos >= 1 and not op_side:
            close = self.match_close(toks, open_idx, e)
            a0 = open_idx + 1
            # 첫 인자 구간
            arg_end = self.arg_end(toks, a0, close)
            add_refs(a0, arg_end)
            res["detail"] = fn + "(x,'-')"
            # NVL(...) 자체가 비교의 피연산자인가
            before = toks[open_idx - 2] if open_idx - 2 >= s else None      # 함수명 앞 토큰
            after = toks[close + 1] if close + 1 < e else None
            cmp_other = None
            if after is not None and after.t in CMP_OPS:
                cmp_other = ("after", close + 2)
            elif before is not None and before.t in CMP_OPS:
                cmp_other = ("before", open_idx - 2)
                if before.t == "=":
                    # col = NVL(x,'-') 가 UPDATE SET / T-SQL 별칭=식 / 변수 대입이면 비교가 아니라 대입
                    la = self.operand_start(toks, open_idx - 3, s)
                    if self.governor(toks, la, s) in ("SET", "SELECT", "DECLARE", "DEFAULT"):
                        cmp_other = None
            if cmp_other:
                gov = self.governor(toks, open_idx - 1, s)
                side, k = cmp_other
                if side == "after":
                    oe = self.operand_end(toks, k, e)
                    other = toks[k:oe]
                    oa, ob = k, oe
                else:
                    oa = self.operand_start(toks, k - 1, s); ob = k
                    other = toks[oa:ob]
                other_txt = " ".join(x.t for x in other)[:120]
                if len(other) == 1 and is_dash(other[0]):
                    res["role"] = "NVL_CMP"; res["nullchk"] = True
                    res["detail"] = fn + "(x,'-') " + ("=" if True else "") + " '-' 비교(NULL검사 겸용)"
                else:
                    res["role"] = "NVL_CMP"; res["detail"] = fn + "(x,'-') 비교 — 상대: " + other_txt
                    cols, vars_ = self.expr_refs(toks, oa, ob)
                    for al, c, idx in cols:
                        cand, note = self.resolve(al, c, idx, ctx)
                        res["refs"].extend(cand)
                res["gov"] = gov
                return res
            # 적재 대상
            res["role"] = "NVL"
            self.find_dest(toks, open_idx - 1, close, ctx, res)
            return res

        if op_side or in_list or like or (prev and prev.u == "WHEN" and self.simple_case(toks, i, s) is not None):
            gov = self.governor(toks, i, s)
            res["gov"] = gov
            # 피연산자
            if prev and prev.u == "WHEN":
                a, b = self.simple_case(toks, i, s)
                add_refs(a, b); gov = "WHEN"; res["gov"] = gov
            elif in_list:
                # IN 앞 표현식
                k = open_idx - 1          # IN 토큰
                if k - 1 >= s and toks[k - 1].u == "NOT":
                    k -= 1
                a = self.operand_start(toks, k - 1, s)
                add_refs(a, k)
            elif op_side == "L" or like:
                k = i - 1
                if like and k - 1 >= s and toks[k - 1].u == "NOT":
                    k -= 1
                a = self.operand_start(toks, k - 1, s)
                add_refs(a, k)
            else:
                b = self.operand_end(toks, i + 2, e)
                add_refs(i + 2, b)
            if PARTIAL_RX.search(res["expr"]):
                res["role"] = "NON_SENTINEL"; res["detail"] = "부분문자열·가공값 비교: " + res["expr"]; res["refs"] = []
                return res
            # 대입/별칭인 '=' 구분: 지배 키워드가 값 위치이고 좌변이 단일 식별자
            if op_side == "L" and prev.t == "=" and gov in ("SET", "SELECT", "DECLARE", "DEFAULT", ",SET", "PARAM"):
                res["role"] = "ASSIGN"; res["detail"] = "대입(" + gov + ") " + res["expr"]
                res["dest"] = res["refs"]; res["refs"] = []
                return res
            # 피연산자가 NVL(x,'-') 로 감싸져 있으면 NULL검사 겸용
            if re.search(r"\b(ISNULL|NVL|COALESCE)\s*\(.*'-'\s*\)", res["expr"], re.I):
                res["nullchk"] = True
            if gov in BRANCH_KW or gov == "IIF" or gov == "DECODE":
                res["role"] = "BRANCH"
            elif gov in PRED_KW:
                res["role"] = "PREDICATE"
            else:
                res["role"] = "PREDICATE"; gov = gov or "?"
            # IF/WHILE 세그먼트 안의 서브쿼리 조건
            st = toks[s].u
            # IF EXISTS (SELECT … WHERE col = '-') 처럼 IF 조건 안 서브쿼리의 조건절은 분기문이 아니라 조건절 비교로 둔다(표시만)
            if res["role"] == "PREDICATE" and st in ("IF", "WHILE", "ELSIF") and self.dialect == "tsql":
                gov = st + " 조건 내 서브쿼리 " + gov
            if res["role"] == "PREDICATE" and self.dialect == "plsql" and self.in_if_cond(toks, i, s):
                gov = "IF 조건 내 서브쿼리 " + gov
            res["detail"] = gov + " " + ("IN 목록" if in_list else ("LIKE" if like else "비교")) + ": " + res["expr"]
            return res

        # 함수 인자형 분기
        if fn == "NULLIF" and argpos == 1:
            close = self.match_close(toks, open_idx, e)
            add_refs(open_idx + 1, self.arg_end(toks, open_idx + 1, close))
            res["role"] = "BRANCH"; res["gov"] = "NULLIF"; res["detail"] = "NULLIF(x,'-') — '-' 를 NULL 로 취급"
            return res
        if fn == "DECODE" and argpos >= 1:
            close = self.match_close(toks, open_idx, e)
            nargs = self.count_args(toks, open_idx, close)
            if argpos % 2 == 1 and argpos < nargs - (1 if nargs % 2 == 0 else 0) + (0):
                add_refs(open_idx + 1, self.arg_end(toks, open_idx + 1, close))
                res["role"] = "BRANCH"; res["gov"] = "DECODE"; res["detail"] = "DECODE(x,'-',…) 검색값"
                return res
            res["role"] = "CASE_VALUE"; res["detail"] = "DECODE 결과값"
            self.find_dest(toks, open_idx - 1, close, ctx, res)
            return res
        if fn == "NVL2":
            close = self.match_close(toks, open_idx, e)
            add_refs(open_idx + 1, self.arg_end(toks, open_idx + 1, close))
            res["role"] = "NVL"; res["detail"] = "NVL2(x,…,'-')"
            self.find_dest(toks, open_idx - 1, close, ctx, res)
            return res

        # 값 위치
        if prev and prev.u in ("THEN", "ELSE"):
            res["role"] = "CASE_VALUE"; res["detail"] = "CASE 결과값(" + prev.u + ")"
            # CASE 식 전체의 조건 컬럼과 적재 대상
            cs, ce = self.case_span(toks, i, s, e)
            if cs is not None:
                cols, vars_ = self.expr_refs(toks, cs, ce)          # 다른 가지의 결과 컬럼 (조건 컬럼은 보지 않음)
                for al, c, idx in cols:
                    cand, note = self.resolve(al, c, idx, ctx)
                    res["refs"].extend(cand)
                res["expr"] = " ".join(x.t for x in toks[cs:min(ce, cs + 40)])[:200]
                self.find_dest(toks, cs, ce - 1, ctx, res)
            return res
        if prev and prev.t in ("=", ":=") :
            a = self.operand_start(toks, i - 2, s)
            add_refs(a, i - 1, "dest")
            res["role"] = "ASSIGN"; res["detail"] = "대입 " + res["expr"]
            return res
        if prev and prev.u == "DEFAULT":
            res["role"] = "DEFAULT"; res["detail"] = "DEFAULT '-' (선언/파라미터/DDL)"
            if i - 3 >= s:
                res["expr"] = " ".join(x.t for x in toks[max(s, i - 4):i])
            return res
        # 선택목록/VALUES 리터럴
        res["role"] = "LOAD"; res["detail"] = "리터럴 값"
        self.find_dest(toks, i, i, ctx, res)
        return res

    # --- 보조 ---------------------------------------------------------------------------------------------------
    def enclosing(self, toks, i, s):
        """i 를 감싸는 가장 안쪽 괄호 → (함수명|'IN'|'(' , 여는괄호 index, 인자 위치)"""
        d = 0; argpos = 0; k = i - 1
        while k >= s:
            t = toks[k].t
            if t == ")":
                d += 1
            elif t == "(":
                if d == 0:
                    p = toks[k - 1] if k - 1 >= s else None
                    if p is not None and p.k == "id":
                        if p.u == "IN":
                            return "IN", k, argpos
                        if p.u not in KW:
                            return p.u, k, argpos
                    return "(", k, argpos
                d -= 1
            elif t == "," and d == 0:
                argpos += 1
            k -= 1
        return None, None, 0

    def match_close(self, toks, open_idx, e):
        d = 0
        for k in range(open_idx, e):
            if toks[k].t == "(":
                d += 1
            elif toks[k].t == ")":
                d -= 1
                if d == 0:
                    return k
        return e - 1

    def arg_end(self, toks, a, close):
        d = 0
        for k in range(a, close):
            if toks[k].t == "(":
                d += 1
            elif toks[k].t == ")":
                d -= 1
            elif toks[k].t == "," and d == 0:
                return k
        return close

    def count_args(self, toks, open_idx, close):
        d = 0; n = 1
        for k in range(open_idx + 1, close):
            if toks[k].t == "(":
                d += 1
            elif toks[k].t == ")":
                d -= 1
            elif toks[k].t == "," and d == 0:
                n += 1
        return n

    STOP_BACK = {"AND", "OR", "NOT", "WHEN", "IF", "ELSIF", "WHILE", "WHERE", "ON", "HAVING", "THEN", "ELSE", "SELECT", "SET", "CASE", "BY",
                 "UNTIL", "RETURN", "VALUES", "DISTINCT", "TOP", "BEGIN", "IS", "AS", "LOOP", "INTO", "USING", "FROM", "JOIN", "CHECK"}

    def operand_start(self, toks, k, s):
        """k 에서 끝나는 피연산자 표현식의 시작 index."""
        d = 0
        while k >= s:
            t = toks[k]
            if t.t == ")":
                d += 1
            elif t.t == "(":
                if d == 0:
                    return k + 1
                d -= 1
            elif d == 0:
                if t.t in (",", ";") or t.t in CMP_OPS or t.t == ":=":
                    return k + 1
                if t.k == "id" and t.u in self.STOP_BACK:
                    return k + 1
            k -= 1
        return s

    def operand_end(self, toks, k, e):
        d = 0
        while k < e:
            t = toks[k]
            if t.t == "(":
                d += 1
            elif t.t == ")":
                if d == 0:
                    return k
                d -= 1
            elif d == 0:
                if t.t in (",", ";") or t.t in CMP_OPS:
                    return k
                if t.k == "id" and t.u in ("AND", "OR", "THEN", "ELSE", "END", "WHEN", "GROUP", "ORDER", "UNION", "WHERE", "HAVING", "LOOP", "BEGIN",
                                           "SELECT", "INSERT", "UPDATE", "DELETE", "SET", "FROM", "JOIN", "LEFT", "RIGHT", "INNER", "ON", "RETURN"):
                    return k
            k += 1
        return e

    def governor(self, toks, i, s):
        """i 위치 표현식을 지배하는 절 키워드 (역방향, 완결된 괄호·CASE 건너뜀, 감싸는 괄호는 밖으로 나감)."""
        d = 0; case_skip = 0; k = i - 1
        while k >= s:
            t = toks[k]
            if t.t == ")":
                d += 1
            elif t.t == "(":
                if d == 0:
                    p = toks[k - 1] if k - 1 >= s else None
                    if p is not None and p.k == "id" and p.u in ("IIF", "DECODE"):
                        return p.u
                else:
                    d -= 1
            elif d == 0 and t.k == "id":
                u = t.u
                if u == "END":
                    nx = toks[k + 1].u if k + 1 < len(toks) else ""
                    if nx not in ("IF", "LOOP", "CASE"):
                        case_skip += 1
                elif u == "CASE":
                    if case_skip > 0:
                        case_skip -= 1
                    else:
                        return "SELECT" if False else self.governor(toks, k, s) if False else "CASE"
                elif case_skip > 0:
                    pass
                elif u in BRANCH_KW or u in PRED_KW:
                    if u == "ON" and k - 1 >= s and toks[k - 1].u in ("NOCOUNT", "XACT_ABORT", "ANSI_NULLS", "QUOTED_IDENTIFIER", "IDENTITY_INSERT"):
                        return "SET"
                    return u
                elif u in ("THEN", "ELSE", "SELECT", "SET", "VALUES", "RETURN", "DECLARE", "DEFAULT", "FROM", "JOIN", "BY", "INTO", "USING"):
                    return u
            k -= 1
        st = toks[s].u if s < len(toks) else ""
        if st in ("IF", "WHILE", "ELSIF", "WHEN"):
            return st
        return ""

    def simple_case(self, toks, i, s):
        """CASE <expr> WHEN '-' 형태면 <expr> 구간 (a,b) — 아니면 None."""
        if not (i - 1 >= s and toks[i - 1].u == "WHEN"):
            return None
        nxt = toks[i + 1] if i + 1 < len(toks) else None
        if nxt is None or nxt.u != "THEN":
            return None
        d = 0; skip = 0; k = i - 2; first_when = i - 1
        while k >= s:
            t = toks[k]
            if t.t == ")":
                d += 1
            elif t.t == "(":
                if d == 0:
                    return None
                d -= 1
            elif d == 0 and t.k == "id":
                if t.u == "END":
                    skip += 1
                elif t.u == "CASE":
                    if skip:
                        skip -= 1
                    else:
                        if first_when - (k + 1) <= 0:
                            return None      # 검색형 CASE (CASE WHEN …)
                        return (k + 1, first_when)
                elif t.u == "WHEN" and skip == 0:
                    first_when = k
            k -= 1
        return None

    def case_span(self, toks, i, s, e):
        """i 가 속한 CASE … END 구간 (CASE index, END index+1)."""
        d = 0; skip = 0; k = i - 1; cs = None
        while k >= s:
            t = toks[k]
            if t.t == ")":
                d += 1
            elif t.t == "(":
                if d == 0:
                    break
                d -= 1
            elif d == 0 and t.k == "id":
                if t.u == "END" and (k + 1 >= e or toks[k + 1].u not in ("IF", "LOOP", "CASE")):
                    skip += 1
                elif t.u == "CASE":
                    if skip:
                        skip -= 1
                    else:
                        cs = k; break
            k -= 1
        if cs is None:
            return None, None
        d = 0; nest = 0; k = cs + 1
        while k < e:
            t = toks[k]
            if t.t == "(":
                d += 1
            elif t.t == ")":
                d -= 1
            elif d == 0 and t.k == "id":
                if t.u == "CASE":
                    nest += 1
                elif t.u == "END":
                    if nest == 0:
                        return cs, k + 1
                    nest -= 1
            k += 1
        return cs, e

    def in_if_cond(self, toks, i, s):
        """PL/SQL: i 가 IF/ELSIF/WHILE … THEN/LOOP 조건 안(서브쿼리 포함)에 있는가."""
        k = i - 1
        while k >= s:
            u = toks[k].u
            if toks[k].k == "id":
                if u in ("THEN", "LOOP", "BEGIN", "ELSE"):
                    return False
                if u in ("IF", "ELSIF", "WHILE"):
                    return True
            k -= 1
        return False

    # --- 적재 대상 컬럼 -----------------------------------------------------------------------------------------
    def find_dest(self, toks, a, b, ctx, res):
        """표현식 [a..b] 가 놓인 위치의 적재 대상 컬럼을 찾는다 (별칭 / UPDATE SET / INSERT 위치 대응)."""
        s, e = ctx["s"], ctx["e"]
        # 1) 뒤따르는 별칭:  expr AS alias  /  expr alias
        k = b + 1
        alias = None
        if k < e and toks[k].u == "AS" and k + 1 < e and toks[k + 1].k == "id":
            alias = toks[k + 1].u
        elif k < e and toks[k].k == "id" and toks[k].u not in KW and toks[k].u[:1] not in "@:":
            alias = toks[k].u
        # 2) 앞선 대입:  col = expr  (UPDATE SET / T-SQL 별칭=식) ,  var := expr
        p = a - 1
        lhs = None
        if p >= s and toks[p].t in ("=", ":="):
            la = self.operand_start(toks, p - 1, s)
            gov = self.governor(toks, la, s)
            if toks[p].t == ":=" or gov in ("SET", "SELECT"):
                lhs = (la, p, gov)
        # 3) INSERT 위치 대응
        pos_col = self.insert_position(toks, a, ctx)
        if pos_col:
            tb, col = pos_col
            if tb in self.pop and col in self.pop[tb]:
                res["dest"].append((tb, col, "확정"))
            elif tb in self.catalog:
                kind = self.catalog[tb]["kind"]
                if kind == "gtt":
                    res["dest"].extend(self.named(col, "")[0]); res["notes"].append("적재 대상 GTT(" + tb + ")." + col)
                else:
                    res["notes"].append("적재 대상 모집단 밖(" + tb + "." + col + ")")
            else:
                res["notes"].append("적재 대상 " + tb + "." + col + " (비실테이블)")
                res["dest"].extend(self.indirect(col, ctx["modtables"], "")[0])
            return
        if lhs:
            la, lb, gov = lhs
            cols, vars_ = self.expr_refs(toks, la, lb)
            if gov == "SET" and cols:
                for al, c, idx in cols:
                    cand, note = self.resolve_update_target(al, c, idx, ctx)
                    res["dest"].extend(cand)
                    if note:
                        res["notes"].append("SET " + c + ": " + note)
            elif cols:
                res["notes"].append("출력 별칭 " + cols[0][1])
                res["alias"] = cols[0][1]
            for v in vars_:
                res["notes"].append("변수 대입 " + v)
                res["dest"].extend(self.var_cands(v, ctx["modtables"]))
            return
        if alias:
            res["alias"] = alias
            res["notes"].append("출력 별칭 " + alias)

    def resolve_update_target(self, al, c, idx, ctx):
        s, e = ctx["s"], ctx["e"]
        toks = ctx.get("toks")
        if al is not None:
            return self.resolve(al, c, idx, ctx)
        # UPDATE <target> SET c = …  — 세그먼트 첫 UPDATE/MERGE 대상
        root = ctx["root"]
        b0 = ctx["blk_of"].get(idx, root)
        for b in block_chain(b0):
            for alias, kind, name, inner in b.srcs:
                if kind == "real" and c in self.pop.get(name, ()):
                    # UPDATE 대상이 실테이블 별칭이면 그 테이블
                    pass
        return self.resolve(None, c, idx, ctx)

    def insert_position(self, toks, a, ctx):
        """a 가 INSERT … (cols) SELECT/VALUES 의 최상위 항목이면 (table, column)."""
        s, e = ctx["s"], ctx["e"]
        cache = ctx.setdefault("ins", None)
        if cache is None:
            cache = ctx["ins"] = self.parse_inserts(toks, s, e)
        for ins in cache:
            for (ia, ib, col) in ins["items"]:
                if ia <= a < ib:
                    return ins["table"], col
        return None

    def parse_inserts(self, toks, s, e):
        """세그먼트 안의 INSERT [INTO] T (c1,c2,…) { VALUES (…) | SELECT … } → 항목 구간과 컬럼의 위치 대응."""
        out = []
        k = s
        while k < e:
            if toks[k].k == "id" and toks[k].u == "INSERT":
                j = k + 1
                if j < e and toks[j].u == "INTO":
                    j += 1
                # 테이블명
                parts = []
                while j < e and toks[j].k == "id" and toks[j].u not in KW:
                    parts.append(toks[j].u); j += 1
                    if j < e and toks[j].t == ".":
                        j += 1
                        if j < e and toks[j].t == ".":
                            j += 1
                    else:
                        break
                # MERGE … WHEN NOT MATCHED THEN INSERT (cols) VALUES (…) — 테이블명 없음
                table = parts[-1] if parts else None
                if table is None:
                    table = self.merge_target(toks, s, k)
                cols = []
                if j < e and toks[j].t == "(":
                    close = self.match_close(toks, j, e)
                    # 컬럼 목록인지 (식별자와 콤마만)
                    inner = toks[j + 1:close]
                    if inner and all(t.k == "id" or t.t in (",", ".") for t in inner) and not any(t.u in ("SELECT",) for t in inner):
                        cur = None
                        for t in inner:
                            if t.t == ",":
                                if cur: cols.append(cur)
                                cur = None
                            elif t.k == "id":
                                cur = t.u
                        if cur: cols.append(cur)
                        j = close + 1
                if not cols and table and table in self.catalog:
                    cols = list(self.catalog[table].get("order", []))
                items = []
                if table and cols and j < e:
                    # OUTPUT 절 등 건너뛰기 없이 바로 VALUES/SELECT 만 처리
                    if toks[j].u == "VALUES" and j + 1 < e and toks[j + 1].t == "(":
                        close = self.match_close(toks, j + 1, e)
                        spans = self.split_top(toks, j + 2, close)
                        if len(spans) == len(cols):
                            items = [(a, b, c) for (a, b), c in zip(spans, cols)]
                    else:
                        # (SELECT … ) 괄호로 싼 경우 / WITH 없이 바로 SELECT
                        jj = j; pclose = None
                        if toks[jj].t == "(" :
                            pclose = self.match_close(toks, jj, e); jj += 1
                        if jj < e and toks[jj].u == "SELECT":
                            lim = pclose if pclose else e
                            for (sa, sb) in self.select_lists(toks, jj, lim):
                                spans = self.split_top(toks, sa, sb)
                                if len(spans) == len(cols):
                                    items.extend((a, b, c) for (a, b), c in zip(spans, cols))
                if table and items:
                    out.append({"table": table, "items": items})
                k = j
            else:
                k += 1
        return out

    def merge_target(self, toks, s, k):
        for j in range(s, k):
            if toks[j].k == "id" and toks[j].u == "MERGE":
                j2 = j + 1
                if j2 < k and toks[j2].u == "INTO":
                    j2 += 1
                parts = []
                while j2 < k and toks[j2].k == "id" and toks[j2].u not in KW:
                    parts.append(toks[j2].u); j2 += 1
                    if j2 < k and toks[j2].t == ".":
                        j2 += 1
                    else:
                        break
                return parts[-1] if parts else None
        return None

    def split_top(self, toks, a, b):
        spans = []; d = 0; cs = 0; st = a
        for k in range(a, b):
            t = toks[k]
            if t.t == "(":
                d += 1
            elif t.t == ")":
                d -= 1
            elif t.k == "id" and t.u == "CASE":
                cs += 1
            elif t.k == "id" and t.u == "END" and cs > 0:
                cs -= 1
            elif t.t == "," and d == 0 and cs == 0:
                spans.append((st, k)); st = k + 1
        spans.append((st, b))
        return spans

    def select_lists(self, toks, j, lim):
        """j(SELECT) 부터 lim 까지 최상위 SELECT … FROM 의 선택목록 구간들 (UNION 가지 포함)."""
        res = []; d = 0; cs = 0; k = j; cur = None
        while k < lim:
            t = toks[k]
            if t.t == "(":
                d += 1
            elif t.t == ")":
                d -= 1
            elif d == 0 and t.k == "id":
                u = t.u
                if u == "CASE":
                    cs += 1
                elif u == "END" and cs > 0:
                    cs -= 1
                elif cs == 0:
                    if u == "SELECT":
                        st = k + 1
                        while st < lim and toks[st].u in ("DISTINCT", "ALL"):
                            st += 1
                        if st < lim and toks[st].u == "TOP":
                            st += 1
                            if st < lim and toks[st].t == "(":
                                st = self.match_close(toks, st, lim) + 1
                            else:
                                st += 1
                        # Oracle 힌트는 주석이라 이미 제거됨
                        cur = st
                    elif u == "FROM" and cur is not None:
                        res.append((cur, k)); cur = None
            k += 1
        if cur is not None:
            res.append((cur, lim))
        return res
