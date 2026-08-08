# [E20260806-WF] PKG_DMF0051 SPEC/BODY + GTT DDL 사내 적용 + 컴파일 검증 (사용자 승인 — DDL/SELECT 만)
import sys
sys.path.insert(0, r"c:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb

u, p, d = ora.conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate"

def split_slash(text):
    """'/' 단독 라인 기준 분할 (CRLF 제거)"""
    stmts, buf = [], []
    for line in text.replace("\r\n", "\n").split("\n"):
        if line.strip() == "/":
            s = "\n".join(buf).strip()
            if s:
                stmts.append(s)
            buf = []
        else:
            buf.append(line)
    tail = "\n".join(buf).strip()
    if tail and not all(l.strip().startswith("--") or not l.strip() for l in tail.split("\n")):
        stmts.append(tail)
    return stmts

def strip_leading_comments(s):
    lines = s.split("\n")
    i = 0
    while i < len(lines) and (not lines[i].strip() or lines[i].strip().startswith("--")):
        i += 1
    return "\n".join(lines[i:])

for fname in ["DMF0051_PKG_GET_WATERFALL_20260806_GTT_DDL.sql",
              "DMF0051_PKG_GET_WATERFALL_20260806_SPEC.sql",
              "DMF0051_PKG_GET_WATERFALL_20260806_BODY.sql"]:
    text = open(BASE + "\\" + fname, encoding="utf-8").read()
    stmts = split_slash(text)
    print(f"== {fname}: {len(stmts)} statement(s)")
    for i, s in enumerate(stmts, 1):
        exec_s = strip_leading_comments(s)
        if not exec_s.strip():
            continue
        try:
            cur.execute(exec_s)
            print(f"   [{i}] OK ({exec_s.split(chr(10))[0][:70]}...)")
        except oracledb.DatabaseError as e:
            err, = e.args
            print(f"   [{i}] ERROR {err.code}: {err.message.splitlines()[0][:150]}")
            if err.code != 24344:  # ORA-24344 = success with compilation error → USER_ERRORS 로 확인
                raise

# 컴파일 상태 + 오류 실측
cur.execute("""SELECT object_name, object_type, status FROM all_objects
               WHERE owner='SCM_MGR' AND object_name='PKG_DMF0051' ORDER BY object_type""")
print("\n== STATUS ==")
for r in cur.fetchall():
    print("  ", r)

cur.execute("""SELECT type, line, position, text FROM all_errors
               WHERE owner='SCM_MGR' AND name='PKG_DMF0051' ORDER BY type, sequence""")
errs = cur.fetchall()
print(f"\n== ALL_ERRORS: {len(errs)} rows ==")
for r in errs[:40]:
    print("  ", r[0], "line", r[1], "pos", r[2], ":", r[3].strip()[:160])

# GTT 생성 확인
cur.execute("""SELECT table_name, temporary, duration FROM all_tables
               WHERE owner='SCM_MGR' AND table_name LIKE 'GT_DM51%' ORDER BY 1""")
print("\n== GT_DM51 GTTs ==")
for r in cur.fetchall():
    print("  ", r)
con.close()
