# -*- coding: utf-8 -*-
"""PKG_DMF0051 BODY 적용 + 룰 #136 3축 검증 (STATUS / ALL_ERRORS / 마커) — 대상 객체 실측.

사용: python apply.py PKG_DMF0051_BODY_PATCHED.sql
      python apply.py 00_BACKUP_PKG_DMF0051_BODY_raw.sql   ← 원복
⚠ PKG_DMF0051 이외 객체는 건드리지 않는다.
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

f = sys.argv[1]
body = open(f, encoding="utf-8").read()
assert body.lstrip().upper().startswith("PACKAGE BODY"), "본문 시작이 PACKAGE BODY 가 아님"
import re as _re
# 정의 대상이 PKG_DMF0051 단일인지 (주석 속 타 패키지 '언급'은 무해 — 정의문만 판정)
_defs = _re.findall(r"PACKAGE\s+BODY\s+(\w+)", body, _re.I)
assert _defs and set(_defs) == {"PKG_DMF0051"}, f"정의 대상 이상: {set(_defs)} — PKG_DMF0022/0035 오염 의심"
assert body.rstrip().endswith("END PKG_DMF0051;"), "종결자 이상"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
print(f"[적용] {f} ({len(body)} bytes)")
cur.execute("CREATE OR REPLACE " + body)

print("\n[룰 #136 3축 — 대상 객체 PKG_DMF0051 실측]")
cur.execute("""SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
               FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0051' ORDER BY OBJECT_TYPE""")
st = cur.fetchall()
for r in st:
    print("  ①STATUS  ", " | ".join(str(x) for x in r))
assert all(r[1] == "VALID" for r in st), "STATUS != VALID"

cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
               WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0051' ORDER BY SEQUENCE""")
er = cur.fetchall()
print(f"  ②ALL_ERRORS  {len(er)}건")
for r in er:
    print("     ", r)
assert not er, "ALL_ERRORS 존재"

cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
               WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0051' AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = "".join(t for _, t in cur.fetchall())
print("  ③마커")
ok = True
for m, exp in [("[E20260820-D51SCALAR]", None), ("[E20260820-D51REGROUP]", None), ("[E20260820-D51SEMI]", None),
               ("[E20260820-DS2]", 1), ("[E20260806-00979]", 3), ("[E20260806-WF]", 3)]:
    got = live.count(m)
    want = exp if exp is not None else (1 if "D51" in m else 1)
    flag = "OK" if got == want else "MISMATCH"
    if got != want:
        ok = False
    print(f"     {flag:8} {m} = {got} (기대 {want})")
print("\n[결과] " + ("3축 PASS" if ok else "3축 FAIL — 원복 필요"))
con.close()

