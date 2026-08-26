# -*- coding: utf-8 -*-
"""클라우드 패키지 파일 자기검증 + 사내 재실행 VALID 실증 (round-trip).

패키지 파일을 SQL*Plus 가 하듯 파싱해서(헤더/SET/CREATE~/ /SHOW ERRORS) 실제로 컴파일하고
STATUS/ALL_ERRORS/마커 3축을 다시 확인한다. 헤더 주석의 'PACKAGE BODY' 로 자르지 않는다.
"""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

SRC = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0035_CLOUD_20260820\A_DB\17_PKG_DMF0051_BODY.sql"
txt = open(SRC, encoding="utf-8").read()

print("[① 형식 검증]")
lines = txt.split("\n")
hdr_end = next(i for i, l in enumerate(lines) if not l.startswith("--"))
print(f"  헤더 주석 {hdr_end}줄")
assert lines[hdr_end] == "SET DEFINE OFF", lines[hdr_end]
assert lines[hdr_end + 1] == "SET SQLBLANKLINES ON", lines[hdr_end + 1]
assert lines[hdr_end + 2].startswith("CREATE OR REPLACE PACKAGE BODY"), lines[hdr_end + 2]
assert lines[-2] == "SHOW ERRORS" or lines[-1] == "SHOW ERRORS"
# 종결자 '/' 는 CREATE 블록 바로 다음 단독 줄
slash = [i for i, l in enumerate(lines) if l.strip() == "/"]
assert len(slash) == 1, f"'/' 단독줄 {len(slash)}개"
print("  헤더 → SET DEFINE OFF → SET SQLBLANKLINES ON → CREATE OR REPLACE PACKAGE BODY → / → SHOW ERRORS  OK")

# ② SQL*Plus 파싱과 동일하게 CREATE 블록만 추출 (헤더 문자열 검색 금지 — 줄 인덱스 기반)
stmt = "\n".join(lines[hdr_end + 2:slash[0]])
assert stmt.upper().startswith("CREATE OR REPLACE PACKAGE BODY")
assert stmt.rstrip().endswith("END PKG_DMF0051;")
defs = set(re.findall(r"PACKAGE\s+BODY\s+(\w+)", stmt, re.I))
assert defs == {"PKG_DMF0051"}, defs
print(f"[② CREATE 블록 추출] {len(stmt)} bytes / 정의 대상 {defs}")

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
cur.execute(stmt)
print("[③ 사내 재실행] 컴파일 완료")

cur.execute("""SELECT OBJECT_TYPE, STATUS FROM ALL_OBJECTS
               WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0051' ORDER BY OBJECT_TYPE""")
st = cur.fetchall()
for r in st:
    print("   STATUS ", r)
assert all(r[1] == "VALID" for r in st)
cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0051'")
n = cur.fetchone()[0]
print(f"   ALL_ERRORS {n}건")
assert n == 0
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0051'
               AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = "".join(t for _, t in cur.fetchall())
for m, n2 in [("[E20260820-D51SCALAR]", 1), ("[E20260820-D51REGROUP]", 1), ("[E20260820-D51SEMI]", 1),
              ("[E20260820-D51ITEMPFX]", 1), ("[E20260820-DS2]", 1), ("[E20260806-00979]", 3), ("[E20260806-WF]", 3)]:
    g = live.count(m)
    print(f"   마커 {m} = {g} (기대 {n2}) {'OK' if g == n2 else 'MISMATCH'}")
    assert g == n2
print("\n[결과] 패키지 파일 round-trip PASS — 형식 + 사내 컴파일 VALID + 마커 3축")
con.close()
