# -*- coding: utf-8 -*-
"""사내 적용: 00B GTT 생성(멱등) -> 02 body 배포 -> 컴파일/마커 검증."""
import io, os, re, oracledb

BASE = os.path.dirname(os.path.abspath(__file__))
conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
cur = conn.cursor()
cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 280")

# 1) GTT DDL — '/' 단독 라인으로 블록 분할, 각 블록(PL/SQL BEGIN..END)을 실행
with io.open(os.path.join(BASE, "00B_GTT_DDL_DMF0003_RENAMED.sql"), "r", encoding="utf-8") as f:
    text = f.read()
blocks = re.split(r'(?m)^\s*/\s*$', text)
ok = 0
for b in blocks:
    if "EXECUTE IMMEDIATE" not in b:
        continue
    cur.execute(b.strip())
    ok += 1
print(f"GTT blocks executed: {ok}")

# 신명칭 39종 존재 검증
cur.execute("""
SELECT COUNT(*) FROM user_tables WHERE temporary='Y'
  AND (table_name LIKE 'GT_DMF0003_%')""")
print("GT_DMF0003_* GTT count:", cur.fetchone()[0])

# 2) body 배포
with io.open(os.path.join(BASE, "02_PKG_DMF0003_body_renamed.sql"), "r", encoding="utf-8") as f:
    body = f.read()
cur.execute(body)
print("body deployed")

cur.execute("SELECT object_type, status FROM user_objects WHERE object_name='PKG_DMF0003'")
for r in cur.fetchall():
    print("status:", r)
cur.execute("SELECT COUNT(*) FROM user_errors WHERE name='PKG_DMF0003'")
print("errors:", cur.fetchone()[0])
cur.execute("SELECT COUNT(*) FROM user_source WHERE name='PKG_DMF0003' AND type='PACKAGE BODY' AND text LIKE '%[DMF0003 GTT RENAME 20260723]%'")
print("marker:", cur.fetchone()[0])
cur.execute("SELECT COUNT(*) FROM user_source WHERE name='PKG_DMF0003' AND type='PACKAGE BODY' AND (UPPER(text) LIKE '%GT_GGET_%' OR UPPER(text) LIKE '%GT_MFCP_%' OR UPPER(text) LIKE '%GT_SAVEPK_%')")
print("잔존 구명 참조(0 이어야):", cur.fetchone()[0])
