# -*- coding: utf-8 -*-
"""검증용 복제 패키지 생성 · 삭제 (사내 ZIOUI1). 원본 PKG_DMF0005 는 건드리지 않는다.

  python _clone_pkg.py create <복제이름> <BODY 원문 파일(.sql, CREATE OR REPLACE PACKAGE BODY "PKG_DMF0005" …)>
  python _clone_pkg.py drop   <복제이름>

SPEC 은 지금 DB 의 PKG_DMF0005 SPEC 을 이름만 바꿔 만든다. BODY 는 파일 원문에서 패키지 이름만 바꾼다.
복제이름은 PKG_DMF0005_ 로 시작해야 한다(원본 · 타 객체 보호).
"""
import sys, re, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

mode, name = sys.argv[1], sys.argv[2].upper()
assert re.fullmatch(r"PKG_DMF0005_[A-Z0-9]{2,8}", name), "복제이름은 PKG_DMF0005_XXX 형식"
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
print("HOST", cur.fetchone()[0], mode, name)

if mode == "drop":
    cur.execute("SELECT COUNT(*) FROM user_objects WHERE object_name = :n", n=name)
    if cur.fetchone()[0]:
        cur.execute(f"DROP PACKAGE {name}")
    cur.execute("SELECT COUNT(*) FROM user_objects WHERE object_name = :n", n=name)
    print("남은 객체", cur.fetchone()[0])
    sys.exit(0)

cur.execute("SELECT COUNT(*) FROM user_objects WHERE object_name = :n", n=name)
assert cur.fetchone()[0] == 0, f"{name} 이미 있음 — 먼저 drop"
cur.execute("SELECT text FROM user_source WHERE name='PKG_DMF0005' AND type='PACKAGE' ORDER BY line")
spec = "".join(r[0] for r in cur)
body = pathlib.Path(sys.argv[3]).read_text(encoding="utf-8")
body = "\n".join(l for l in body.split("\n") if not l.startswith("-- SOURCE-FRESH:")).rstrip()
if body.endswith("/"):
    body = body[:-1].rstrip()
body = re.sub(r"^CREATE OR REPLACE\s+", "", body)


def rename(src):
    out, n = re.subn(r'"?PKG_DMF0005"?(?![A-Z0-9_.])', name, src)   # PKG_DMF0005.xxx 호출 · 다른 이름의 일부는 제외
    return out, n


spec2, n1 = rename(spec)
body2, n2 = rename(body)
print("이름 치환 spec", n1, "body", n2)
cur.execute("CREATE OR REPLACE " + spec2.rstrip())
cur.execute("CREATE OR REPLACE " + body2.rstrip())
cur.execute("SELECT object_type, status FROM user_objects WHERE object_name = :n ORDER BY 1", n=name)
print(cur.fetchall())
cur.execute("SELECT type, line, text FROM user_errors WHERE name = :n ORDER BY sequence", n=name)
for e in cur:
    print("  ERR", e)
