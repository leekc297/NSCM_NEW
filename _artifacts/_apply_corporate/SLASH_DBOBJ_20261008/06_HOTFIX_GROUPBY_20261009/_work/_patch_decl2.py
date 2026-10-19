import pathlib, re
p = pathlib.Path(__file__).parent / "parse_check.py"; s = p.read_text(encoding="utf-8")
old_fn = s[s.index("def declared_names(src):"):s.index("def statements_with_group_by(src):")]
new_fn = '''BASE_TYPES = set("""VARCHAR2 NVARCHAR2 VARCHAR NUMBER DATE INTEGER INT PLS_INTEGER BINARY_INTEGER SIMPLE_INTEGER BOOLEAN CLOB NCLOB BLOB CHAR NCHAR TIMESTAMP
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


'''
s = s.replace(old_fn, new_fn)
p.write_text(s, encoding="utf-8"); print("declared_names v3 patched")
