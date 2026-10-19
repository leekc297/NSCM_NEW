"""Pre-apply parse check (ORA-00979 gate).
For every SQL statement containing GROUP BY in a PL/SQL source: substitute PL/SQL variables/parameters with binds,
then client-side cursor.parse() of **the SELECT part** (for INSERT…SELECT the INSERT header is stripped — parsing the whole INSERT
was observed to miss ORA-00979 on 26ai, parsing the SELECT alone reports it). No execution.
Codes: OK / ORA-00979 (GROUP BY mismatch) / other ORA (statement could not be verified by this tool → manual review).
Usage: python parse_check.py <before.sql> <after.sql> [--all]
"""
import sys, re, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parent))
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from groupby_scan import strip_comments, tokenize, is_op, KW
import ora, oracledb

# declarations: "<name> [IN|OUT|IN OUT] [NOCOPY] <type>" where <type> is followed by ( ; , := ) DEFAULT NOT NULL or %TYPE/%ROWTYPE
DECL = re.compile(r"(?:[(,;]|\bIS\b|\bAS\b|\bDECLARE\b)\s*([A-Za-z_][\w$#]*)\s+(?:IN\s+OUT\s+|IN\s+|OUT\s+)?(?:NOCOPY\s+)?([A-Za-z_][\w$#.]*(?:%(?:TYPE|ROWTYPE))?)\s*(?=[(;,):]|:=|DEFAULT\b|NOT\s+NULL)", re.I)
PLSQL_STOP = set("""INTO FROM WHERE SELECT UPDATE DELETE INSERT MERGE VALUES SET RETURN RETURNING EXIT OPEN CLOSE FETCH RAISE GOTO NULL ELSIF WHILE FOR FORALL
EXECUTE IMMEDIATE COMMIT ROLLBACK PRAGMA TYPE SUBTYPE CURSOR PROCEDURE FUNCTION PACKAGE BODY EXCEPTION WHEN OTHERS THEN ELSE LOOP IF END BEGIN DECLARE IS AS
USING BULK COLLECT LIMIT SAVEPOINT LOCK GRANT ALTER CREATE DROP TRUNCATE CALL CASE DUAL ON AND OR NOT IN BY GROUP ORDER HAVING JOIN LEFT RIGHT INNER OUTER
CROSS FULL UNION ALL MINUS INTERSECT DISTINCT EXISTS BETWEEN LIKE CONTINUE REVERSE INDEX OF TABLE RECORD VARRAY CONSTANT AUTHID CURRENT_USER DEFINER DETERMINISTIC
PIPELINED PARALLEL_ENABLE RESULT_CACHE EXTERNAL LANGUAGE JAVA NAME LIBRARY ACCESSIBLE WITH ACCESS CONNECT START PRIOR NOCYCLE MODEL PIVOT UNPIVOT""".split())
STMT_START = ("INSERT", "SELECT", "MERGE", "UPDATE", "DELETE", "WITH")


BASE_TYPES = set("""VARCHAR2 NVARCHAR2 VARCHAR NUMBER DATE INTEGER INT PLS_INTEGER BINARY_INTEGER SIMPLE_INTEGER BOOLEAN CLOB NCLOB BLOB CHAR NCHAR TIMESTAMP
SYS_REFCURSOR LONG RAW FLOAT DEC DECIMAL NUMERIC REAL SMALLINT BINARY_FLOAT BINARY_DOUBLE ROWID UROWID XMLTYPE JSON INTERVAL STRING NATURAL POSITIVE NATURALN POSITIVEN SIGNTYPE""".split())


def _is_type(ty):
    t = ty.upper()
    if t in BASE_TYPES or t.endswith("%TYPE") or t.endswith("%ROWTYPE"):
        return True
    if "." in t and t.split(".")[-1] in BASE_TYPES:
        return True
    # user-defined collection/record/object types by naming convention
    if re.match(r"^(T_|TY_|TYP_|TYPE_|REC_|TAB_|ARR_|OBJ_)", t) or re.search(r"_(TAB|TYPE|REC|OBJ|TBL|ARRAY|ARR|LIST|NT|VARRAY|RECORD|CUR|CURSOR|RT|TT)$", t):
        return True
    return False


def declared_names(src):
    s = strip_comments(src)
    names = set()
    for m in DECL.finditer(s):
        nm, ty = m.group(1).upper(), m.group(2).upper()
        if nm in KW or nm in PLSQL_STOP or not _is_type(ty):
            continue
        names.add(nm)
    # explicitly typed collection/record declarations:  name  SCM_MGR.T_STR_TAB := ... are covered; FOR r IN (SELECT..) loop vars are not (left as dotted → may show ORA-00904)
    return names - KW - PLSQL_STOP


def statements_with_group_by(src):
    s = strip_comments(src); toks = tokenize(s); n = len(toks); out = []
    i = 0
    while i < n:
        t = toks[i]
        if t[0] == "id" and t[1] in STMT_START:
            prev = toks[i - 1] if i > 0 else None
            if prev is None or is_op(prev, ";") or (prev[0] == "id" and prev[1] in ("BEGIN", "THEN", "ELSE", "LOOP", "IS", "AS", "DECLARE", "END")) or is_op(prev, ">>"):
                d = 0; j = i
                while j < n:
                    tt = toks[j]
                    if is_op(tt, "("): d += 1
                    elif is_op(tt, ")"): d -= 1
                    elif d == 0 and is_op(tt, ";"): break
                    j += 1
                seg = toks[i:j]
                if any(a[0] == "id" and a[1] == "GROUP" and b[0] == "id" and b[1] == "BY" for a, b in zip(seg, seg[1:])):
                    st = t[2]; en = toks[j - 1][2] + len(toks[j - 1][1]) if j - 1 < n else len(s)
                    out.append((st, en, s[st:en], seg))
                i = j
        i += 1
    return s, out


def _aliases(seg):
    al = set(); n = len(seg)
    for i in range(1, n):
        t, prev = seg[i], seg[i - 1]
        if t[0] == "id" and "." not in t[1] and t[1] not in KW:
            nxt = seg[i + 1] if i + 1 < n else None
            if nxt is not None and is_op(nxt, "("):
                continue
            if (prev[0] == "id" and prev[1] not in KW) or is_op(prev, ")"):
                al.add(t[1])
    return al


def _insert_collist_span(seg):
    if not (seg and seg[0][0] == "id" and seg[0][1] == "INSERT"):
        return None
    for i in range(1, min(len(seg), 8)):
        if is_op(seg[i], "("):
            d = 0
            for j in range(i, len(seg)):
                if is_op(seg[j], "("): d += 1
                elif is_op(seg[j], ")"):
                    d -= 1
                    if d == 0:
                        return (i, j)
            return None
        if seg[i][0] == "id" and seg[i][1] in ("SELECT", "VALUES", "WITH"):
            return None
    return None


def bindify(seg, s, names):
    out = []; last = seg[0][2]; al = _aliases(seg); col = _insert_collist_span(seg)
    i = 0; n = len(seg)
    while i < n:
        t = seg[i]; pos = t[2]
        raw = s[pos:pos + len(t[1])] if t[0] != "str" else t[1]
        out.append(s[last:pos])
        nxt = seg[i + 1] if i + 1 < n else None
        in_collist = col is not None and col[0] < i < col[1]
        # TABLE(<collection var>) → dummy one-column row source
        if t[0] == "id" and t[1] == "TABLE" and nxt and is_op(nxt, "(") and i + 3 < n and seg[i + 2][0] == "id" and seg[i + 2][1] in names and is_op(seg[i + 3], ")"):
            out.append("(SELECT CAST(NULL AS VARCHAR2(4000)) AS COLUMN_VALUE FROM DUAL WHERE 1=0)")
            last = seg[i + 3][2] + 1; i += 4; continue
        if t[0] == "id" and not in_collist and not (nxt and is_op(nxt, "(")):
            if "." not in t[1] and t[1] in names:
                out.append(":B_" + t[1]); last = pos + len(raw); i += 1; continue
            head = t[1].split(".")[0]
            if "." in t[1] and head in names and head not in al:
                out.append(":B_" + t[1].replace(".", "_")); last = pos + len(raw); i += 1; continue
        out.append(raw); last = pos + len(raw); i += 1
    return "".join(out)


def select_part(sql):
    """INSERT INTO t [(cols)] SELECT … → SELECT …; MERGE/UPDATE/DELETE → unchanged (parsed whole)"""
    u = sql.upper().lstrip()
    if u.startswith("INSERT"):
        # find first top-level SELECT/WITH after the INSERT header
        depth = 0; i = 0; n = len(sql)
        while i < n:
            ch = sql[i]
            if ch == "'":
                j = sql.find("'", i + 1)
                while j != -1 and j + 1 < n and sql[j + 1] == "'": j = sql.find("'", j + 2)
                i = (j if j != -1 else n) + 1; continue
            if ch == "(": depth += 1
            elif ch == ")": depth -= 1
            elif depth == 0 and sql[i:i + 6].upper() == "SELECT" and (i == 0 or not (sql[i - 1].isalnum() or sql[i - 1] == "_")):
                return sql[i:]
            elif depth == 0 and sql[i:i + 4].upper() == "WITH" and (i == 0 or not (sql[i - 1].isalnum() or sql[i - 1] == "_")):
                return sql[i:]
            i += 1
    return sql


def _code(e):
    m = re.findall(r"ORA-\d{5}", str(e))
    for c in m:
        if c != "ORA-06550":
            return c
    return m[0] if m else str(e)[:60]


def parse_all(cur, src):
    names = declared_names(src)
    s, stmts = statements_with_group_by(src)
    res = []
    for st, en, text, seg in stmts:
        sql = bindify(seg, s, names)
        sql = re.sub(r"\bBULK\s+COLLECT\s+INTO\s+:B_\w+(\s*,\s*:B_\w+)*", "", sql, flags=re.I)
        sql = re.sub(r"\bINTO\s+:B_\w+(\s*,\s*:B_\w+)*\s+FROM\b", " FROM", sql, flags=re.I)
        sel = select_part(sql)
        line = s.count("\n", 0, st) + 1
        try:
            cur.parse(sel)          # client parse (OCI parse) — observed to report ORA-00979 where DBMS_SQL.PARSE inside PL/SQL did not
            code = "OK"
        except Exception as e:
            code = _code(e)
        res.append((line, code, text[:100].replace("\n", " ")))
    return res


if __name__ == "__main__":
    before = open(sys.argv[1], encoding="utf-8", errors="ignore").read()
    after = open(sys.argv[2], encoding="utf-8", errors="ignore").read()
    show_all = "--all" in sys.argv
    u, p, d = ora.conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as c:
        cur = c.cursor()
        rb = parse_all(cur, before); ra = parse_all(cur, after)
    from collections import Counter
    print(f"  statements with GROUP BY: before={len(rb)} after={len(ra)}")
    print("  before codes:", dict(Counter(x[1] for x in rb)), "| after codes:", dict(Counter(x[1] for x in ra)))
    for (lb, cb, tb), (la, ca, ta) in zip(rb, ra):
        if show_all or cb != ca or "979" in cb or "979" in ca:
            print(f"  L{lb}->L{la} | before={cb} after={ca} | {ta[:90]}")
    if len(rb) != len(ra):
        print("  ⚠ statement count differs — pairing by order unreliable")
    n979 = sum(1 for x in ra if "00979" in x[1])
    print(f"  AFTER ORA-00979 count = {n979}")
    sys.exit(2 if n979 else 0)
