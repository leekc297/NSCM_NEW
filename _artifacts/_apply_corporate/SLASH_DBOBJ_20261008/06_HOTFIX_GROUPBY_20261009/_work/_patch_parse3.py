import pathlib
p = pathlib.Path(__file__).parent / "parse_check.py"; s = p.read_text(encoding="utf-8")
old = '''        try:
            cur.execute("DECLARE c INTEGER; BEGIN c := DBMS_SQL.OPEN_CURSOR; DBMS_SQL.PARSE(c, :sql, DBMS_SQL.NATIVE); DBMS_SQL.CLOSE_CURSOR(c); END;", sql=sel)
            code = "OK"
        except Exception as e:
            code = _code(e)'''
new = '''        try:
            cur.parse(sel)          # client parse (OCI parse) — observed to report ORA-00979 where DBMS_SQL.PARSE inside PL/SQL did not
            code = "OK"
        except Exception as e:
            code = _code(e)'''
assert old in s; s = s.replace(old, new)
s = s.replace("then DBMS_SQL.PARSE **the SELECT part**", "then client-side cursor.parse() of **the SELECT part**")
p.write_text(s, encoding="utf-8"); print("parse_all -> cursor.parse")
