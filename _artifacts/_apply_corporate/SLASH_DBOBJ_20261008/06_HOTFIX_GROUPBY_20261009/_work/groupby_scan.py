"""SELECT-list vs GROUP BY expression consistency scanner (ORA-00979 candidates).
Usage: python groupby_scan.py <sql file> [--json]
Heuristic, token-based. Comments removed (positions preserved). Strings kept verbatim.
Finding = a non-aggregate SELECT / ORDER BY / HAVING item that still contains a column reference after
every GROUP BY expression occurring in it has been masked out.
  sev 'dotted' = ALIAS.COL left over (high confidence)
  sev 'bare'   = bare identifier left over that is not a known keyword/function and not variable-like (lower confidence)
"""
import re, sys, json

KW = set("""SELECT FROM WHERE GROUP BY ORDER HAVING AND OR NOT IN IS NULL LIKE BETWEEN CASE WHEN THEN ELSE END AS ON JOIN LEFT RIGHT FULL INNER OUTER
CROSS UNION ALL MINUS INTERSECT DISTINCT UNIQUE EXISTS ANY SOME ESCAPE ASC DESC NULLS FIRST LAST WITH CONNECT START PRIOR ROWNUM ROWID LEVEL SYSDATE SYSTIMESTAMP
USER UID CURRENT_DATE CURRENT_TIMESTAMP LOCALTIMESTAMP DUAL TRUE FALSE OVER PARTITION ROWS RANGE UNBOUNDED PRECEDING FOLLOWING CURRENT ROW INTERVAL DAY MONTH YEAR HOUR MINUTE SECOND
TO_DATE TO_CHAR TO_NUMBER NVL NVL2 NULLIF COALESCE DECODE SUBSTR SUBSTRB INSTR LENGTH LENGTHB TRIM LTRIM RTRIM UPPER LOWER INITCAP REPLACE REGEXP_REPLACE REGEXP_SUBSTR REGEXP_LIKE REGEXP_INSTR
LPAD RPAD CONCAT TRUNC ROUND FLOOR CEIL MOD ABS SIGN POWER GREATEST LEAST ADD_MONTHS LAST_DAY NEXT_DAY MONTHS_BETWEEN EXTRACT CAST TO_TIMESTAMP CHR ASCII TRANSLATE
SYS_GUID SYS_CONTEXT XMLAGG XMLELEMENT NUMBER VARCHAR2 CHAR DATE INTEGER PLS_INTEGER BINARY_INTEGER BOOLEAN CLOB JSON_OBJECT JSON_ARRAYAGG JSON_VALUE KEY VALUE RETURNING FORMAT JSON
LISTAGG WITHIN GROUPING GROUPING_ID ROLLUP CUBE SETS KEEP DENSE_RANK RANK ROW_NUMBER LAG LEAD FIRST_VALUE LAST_VALUE NTILE RATIO_TO_REPORT
TABLE COLUMN_VALUE MULTISET LATERAL FETCH NEXT ONLY OFFSET PERCENT TIES LEADING TRAILING BOTH""".split())
AGG = set("SUM MAX MIN COUNT AVG LISTAGG STDDEV VARIANCE MEDIAN XMLAGG COLLECT WM_CONCAT GROUPING GROUPING_ID JSON_ARRAYAGG JSON_OBJECTAGG STATS_MODE PERCENTILE_CONT PERCENTILE_DISC CORR COVAR_POP COVAR_SAMP APPROX_COUNT_DISTINCT DENSE_RANK RANK FIRST LAST ANY_VALUE".split())
VAR_PREFIX = ("P_", "V_", "N_", "D_", "L_", "G_", "I_", "O_", "C_", "R_", "B_", "T_", "W_", "X_", "@")

TOK = re.compile(r"""
 (?P<ws>\s+)
|(?P<str>'(?:[^']|'')*')
|(?P<qid>"[^"]+"(?:\."[^"]+")*)
|(?P<num>\d+(?:\.\d+)?)
|(?P<id>[A-Za-z_][\w$#]*(?:\.[A-Za-z_"][\w$#"]*)*)
|(?P<op>\|\||<>|!=|>=|<=|:=|=>|\.\.|[(),;=<>+\-*/%.:&@?])
""", re.X)


def strip_comments(s):
    out = []; i = 0; n = len(s)
    while i < n:
        c = s[i]
        if c == "'":
            j = i + 1
            while j < n:
                if s[j] == "'":
                    if j + 1 < n and s[j + 1] == "'":
                        j += 2; continue
                    break
                j += 1
            out.append(s[i:j + 1]); i = j + 1; continue
        if s.startswith("--", i):
            j = s.find("\n", i); j = n if j < 0 else j
            out.append(" " * (j - i)); i = j; continue
        if s.startswith("/*", i):
            j = s.find("*/", i + 2); j = n if j < 0 else j + 2
            out.append("".join("\n" if ch == "\n" else " " for ch in s[i:j])); i = j; continue
        out.append(c); i += 1
    return "".join(out)


def tokenize(s):
    toks = []
    for m in TOK.finditer(s):
        k = m.lastgroup
        if k == "ws":
            continue
        t = m.group()
        toks.append((k, t if k == "str" else t.upper(), m.start()))
    return toks


def line_of(s, pos):
    return s.count("\n", 0, pos) + 1


def is_op(t, ch):
    return t[0] == "op" and t[1] == ch


def split_items(toks, a, b):
    items = []; cur = []; d = 0
    for t in toks[a:b]:
        if is_op(t, "("): d += 1
        elif is_op(t, ")"): d -= 1
        if is_op(t, ",") and d == 0:
            items.append(cur); cur = []; continue
        cur.append(t)
    if cur:
        items.append(cur)
    return items


def strip_alias(it):
    if len(it) >= 3 and it[-2][0] == "id" and it[-2][1] == "AS" and it[-1][0] in ("id", "qid"):
        return it[:-2]
    if len(it) >= 2 and it[-1][0] in ("id", "qid") and it[-1][1] not in KW:
        prev = it[-2]
        if (prev[0] in ("id", "qid", "str", "num") and not (prev[0] == "id" and prev[1] in KW)) or is_op(prev, ")"):
            return it[:-1]
    return it


def key(it):
    return "".join(t[1] for t in it)


def skip_paren(it, i):
    """it[i] is '(' → index of matching ')'"""
    d = 0; j = i; n = len(it)
    while j < n:
        if is_op(it[j], "("): d += 1
        elif is_op(it[j], ")"):
            d -= 1
            if d == 0:
                return j
        j += 1
    return n - 1


def mask_aggregates(it):
    out = []; i = 0; n = len(it)
    while i < n:
        t = it[i]
        if t[0] == "id" and t[1] in AGG and i + 1 < n and is_op(it[i + 1], "("):
            j = skip_paren(it, i + 1)
            k = j + 1
            if k + 1 < n and it[k][0] == "id" and it[k][1] == "KEEP" and is_op(it[k + 1], "("):
                j = skip_paren(it, k + 1)
            out.append(("agg", "#AGG", t[2])); i = j + 1; continue
        if t[0] == "id" and t[1] == "OVER" and i + 1 < n and is_op(it[i + 1], "("):
            return [("agg", "#WIN", t[2])]
        out.append(t); i += 1
    return out


def mask_groups(it, gkeys):
    toks = list(it)
    for g in sorted(gkeys, key=lambda g: -len(key(g))):
        gk = key(g); glen = len(g)
        if not gk:
            continue
        i = 0
        while i + glen <= len(toks):
            if key(toks[i:i + glen]) == gk and not any(t[0] == "grp" for t in toks[i:i + glen]):
                toks[i:i + glen] = [("grp", "#G", toks[i][2])]
            i += 1
    return toks


def leftovers(it):
    dotted = []; bare = []
    for i, t in enumerate(it):
        if t[0] == "id":
            nxt = it[i + 1] if i + 1 < len(it) else None
            if nxt and is_op(nxt, "("):
                continue
            if "." in t[1]:
                head = t[1].split(".")[0]
                if head in ("DBMS_OUTPUT", "DBMS_UTILITY", "SYS", "DBMS_SQL", "DBMS_LOB", "SCM_MGR"):
                    continue
                dotted.append(t)
            elif t[1] not in KW and not t[1].startswith(VAR_PREFIX):
                bare.append(t)
        elif t[0] == "qid":
            dotted.append(t)
    return dotted, bare


STOP_GROUP = {"HAVING", "ORDER", "UNION", "MINUS", "INTERSECT", "MODEL", "WINDOW", "FETCH", "OFFSET", "FOR", "CONNECT", "START",
              "INSERT", "SELECT", "UPDATE", "DELETE", "MERGE", "BEGIN", "END", "IF", "LOOP", "EXCEPTION", "RETURNING", "BULK", "INTO",
              "WHEN", "ELSE", "THEN", "ELSIF", "OPEN", "CLOSE", "COMMIT", "ROLLBACK", "RAISE", "EXIT", "RETURN", "DECLARE", "CURSOR",
              "PROCEDURE", "FUNCTION", "WHERE", "SET", "VALUES", "USING", "PIVOT", "UNPIVOT"}


def unwrap_outer_parens(x):
    if len(x) >= 2 and is_op(x[0], "(") and is_op(x[-1], ")") and skip_paren(x, 0) == len(x) - 1:
        return x[1:-1]
    return x


def clause_end(toks, j, stops):
    """scan from j at depth 0 until ';' / ')' closing / stop keyword → index. CASE…END (nested) is skipped as one unit."""
    d = 0; n = len(toks); case_depth = 0
    while j < n:
        t = toks[j]
        if is_op(t, "("): d += 1
        elif is_op(t, ")"):
            d -= 1
            if d < 0:
                return j
        elif t[0] == "id" and t[1] == "CASE":
            case_depth += 1
        elif t[0] == "id" and t[1] == "END" and case_depth > 0:
            case_depth -= 1
        elif case_depth > 0 and t[0] == "id" and t[1] in ("WHEN", "THEN", "ELSE"):
            pass
        elif d == 0 and case_depth == 0 and (is_op(t, ";") or (t[0] == "id" and t[1] in stops)):
            return j
        j += 1
    return n


def scan(sql):
    s = strip_comments(sql); toks = tokenize(s); findings = []
    n = len(toks)
    for gi in range(n - 1):
        if not (toks[gi][0] == "id" and toks[gi][1] == "GROUP" and toks[gi + 1][0] == "id" and toks[gi + 1][1] == "BY"):
            continue
        d = 0; si = None
        for k in range(gi - 1, -1, -1):
            t = toks[k]
            if is_op(t, ")"): d += 1
            elif is_op(t, "("):
                d -= 1
                if d < 0:
                    break
            elif d == 0 and t[0] == "id" and t[1] == "SELECT":
                si = k; break
        if si is None:
            continue
        a = si + 1
        if a < n and toks[a][0] == "id" and toks[a][1] in ("DISTINCT", "UNIQUE", "ALL"):
            a += 1
        d = 0; fi = None
        for k in range(a, gi):
            t = toks[k]
            if is_op(t, "("): d += 1
            elif is_op(t, ")"): d -= 1
            elif d == 0 and t[0] == "id" and t[1] == "FROM":
                fi = k; break
        if fi is None:
            continue
        ge = clause_end(toks, gi + 2, STOP_GROUP)
        gkeys = [unwrap_outer_parens(x) for x in split_items(toks, gi + 2, ge) if x]
        extra = []
        k = ge
        while k < n and not is_op(toks[k], ";"):
            t = toks[k]
            if t[0] == "id" and t[1] == "HAVING":
                e = clause_end(toks, k + 1, {"ORDER", "UNION", "MINUS", "INTERSECT", "FETCH"})
                extra.append(("HAVING", [toks[k + 1:e]])); k = e; continue
            if t[0] == "id" and t[1] == "ORDER" and k + 1 < n and toks[k + 1][1] == "BY":
                e = clause_end(toks, k + 2, {"UNION", "MINUS", "INTERSECT", "FETCH", "OFFSET", "FOR"})
                items = [[tt for tt in x if not (tt[0] == "id" and tt[1] in ("ASC", "DESC", "NULLS", "FIRST", "LAST"))] for x in split_items(toks, k + 2, e)]
                extra.append(("ORDER BY", items)); k = e; continue
            if is_op(t, ")") or (t[0] == "id" and t[1] in ("UNION", "MINUS", "INTERSECT")):
                break
            k += 1
        raw_items = [x for x in split_items(toks, a, fi) if x]
        sitems = [strip_alias(x) for x in raw_items]
        aliases = {key(x[-1:]) for x in raw_items if len(x) >= 2 and len(strip_alias(x)) < len(x)}
        for label, items in [("SELECT", sitems)] + extra:
            for it in items:
                if not it:
                    continue
                if label == "ORDER BY" and len(it) == 1 and (it[0][0] == "num" or key(it) in aliases):
                    continue
                m = mask_aggregates(it)
                if any(t[0] == "agg" and t[1] == "#WIN" for t in m):
                    continue
                m = mask_groups(m, gkeys)
                dotted, bare = leftovers(m)
                if dotted or bare:
                    findings.append({"kind": label, "sev": "dotted" if dotted else "bare", "line": line_of(s, it[0][2]),
                                     "group_by_line": line_of(s, toks[gi][2]), "select_line": line_of(s, toks[si][2]),
                                     "item": " ".join(t[1] for t in it)[:200], "leftover": [t[1] for t in (dotted or bare)][:6],
                                     "group_keys": [key(g) for g in gkeys][:40]})
    return findings


if __name__ == "__main__":
    f = sys.argv[1]; sql = open(f, encoding="utf-8", errors="ignore").read()
    r = scan(sql)
    if "--json" in sys.argv:
        print(json.dumps(r, ensure_ascii=False, indent=1))
    else:
        for x in r:
            print(f"{x['sev']:6} {x['kind']:8} L{x['line']} (SELECT L{x['select_line']} / GROUP BY L{x['group_by_line']}) | {x['item'][:120]} | left={x['leftover']}")
        print("findings:", len(r))
