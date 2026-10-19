import pathlib, re
p = pathlib.Path(__file__).parent / "parse_check.py"; s = p.read_text(encoding="utf-8")
old_decl = s[s.index("DECL = re.compile("):s.index("STMT_START = (")]
new_decl = '''DECL = re.compile(r"(?:[(,;]|\\bIS\\b|\\bAS\\b|\\bDECLARE\\b)\\s*([A-Za-z_][\\w$#]*)\\s+(?:IN\\s+OUT\\s+|IN\\s+|OUT\\s+)?(?:NOCOPY\\s+)?([A-Za-z_][\\w$#.]*(?:%(?:TYPE|ROWTYPE))?)\\s*(?=[(;,):]|:=|DEFAULT\\b|NOT\\s+NULL)", re.I)
PLSQL_STOP = set("""INTO FROM WHERE SELECT UPDATE DELETE INSERT MERGE VALUES SET RETURN RETURNING EXIT OPEN CLOSE FETCH RAISE GOTO NULL ELSIF WHILE FOR FORALL
EXECUTE IMMEDIATE COMMIT ROLLBACK PRAGMA TYPE SUBTYPE CURSOR PROCEDURE FUNCTION PACKAGE BODY EXCEPTION WHEN OTHERS THEN ELSE LOOP IF END BEGIN DECLARE IS AS
USING BULK COLLECT LIMIT SAVEPOINT LOCK GRANT ALTER CREATE DROP TRUNCATE CALL CASE DUAL ON AND OR NOT IN BY GROUP ORDER HAVING JOIN LEFT RIGHT INNER OUTER
CROSS FULL UNION ALL MINUS INTERSECT DISTINCT EXISTS BETWEEN LIKE CONTINUE REVERSE INDEX OF TABLE RECORD VARRAY CONSTANT AUTHID CURRENT_USER DEFINER DETERMINISTIC
PIPELINED PARALLEL_ENABLE RESULT_CACHE EXTERNAL LANGUAGE JAVA NAME LIBRARY ACCESSIBLE WITH ACCESS CONNECT START PRIOR NOCYCLE MODEL PIVOT UNPIVOT""".split())
'''
s = s.replace(old_decl, new_decl)
old_fn = s[s.index("def declared_names(src):"):s.index("def statements_with_group_by(src):")]
new_fn = '''def declared_names(src):
    s = strip_comments(src)
    names = set()
    for m in DECL.finditer(s):
        nm, ty = m.group(1).upper(), m.group(2).upper()
        if nm in KW or nm in PLSQL_STOP or ty in PLSQL_STOP or ty in KW:
            continue
        names.add(nm)
    return names - KW - PLSQL_STOP


'''
s = s.replace(old_fn, new_fn)
p.write_text(s, encoding="utf-8"); print("declared_names patched")
