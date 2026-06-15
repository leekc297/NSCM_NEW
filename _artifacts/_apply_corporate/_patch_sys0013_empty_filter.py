"""
P_SYS0013_GET_QUERY_LIST 빈 string filter fix
- WHERE EXISTS (... SPLIT_DQ_ID ... ) 등 3 위치에 (NVL(P_DQ_ID,'')='' OR EXISTS ...) 패턴 추가
- LIST + COLUMNS + PARAMETERS 등 동일 사고 가능 — LIST 만 우선
"""
import oracledb, re

conn = oracledb.connect(user="SCM_MGR", password="!SCMroqkf2026", dsn="121.162.245.167:2521/ESSCMD")
cur = conn.cursor()

# PKG body 전체 추출
cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_SYS0013' AND TYPE='PACKAGE BODY' ORDER BY LINE")
body = "".join(r[0] for r in cur.fetchall())

# 3 위치 patch (정확 매칭 — 한 번에)
patches = [
    # P_DQ_ID
    ("AND EXISTS (SELECT 1 FROM SPLIT_DQ_ID P WHERE A.DQ_ID LIKE P.TOKEN || '%')",
     "AND (NVL(P_DQ_ID,'')='' OR EXISTS (SELECT 1 FROM SPLIT_DQ_ID P WHERE A.DQ_ID LIKE P.TOKEN || '%'))"),
    # P_DQ_NAME
    ("AND EXISTS (SELECT 1 FROM SPLIT_DQ_NAME P WHERE A.DQ_NAME LIKE P.TOKEN || '%')",
     "AND (NVL(P_DQ_NAME,'')='' OR EXISTS (SELECT 1 FROM SPLIT_DQ_NAME P WHERE A.DQ_NAME LIKE P.TOKEN || '%'))"),
    # P_ROLE (외부 WHERE)
    ("AND EXISTS (SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%' || P.TOKEN || '%');",
     "AND (NVL(P_ROLE,'')='' OR EXISTS (SELECT 1 FROM SPLIT_ROLE P WHERE GROUP_ID LIKE '%' || P.TOKEN || '%'));"),
]

new_body = body
total = 0
for old, new in patches:
    new_body, n = re.subn(re.escape(old), new, new_body, count=1)
    print(f"  patch ({n}): {old[:60]}...")
    total += n

if total != 3:
    print(f"⚠ 기대 3 patch / 실제 {total}")
    raise SystemExit(1)

# CREATE OR REPLACE 적용 — DDL 한 번에
ddl = "CREATE OR REPLACE " + new_body
out_path = "C:/Projects/NSCM/_artifacts/_apply_corporate/68_sys0013_empty_filter_fix.sql"
with open(out_path, "w", encoding="utf-8") as f:
    f.write(ddl)
    f.write("\n/\n")
print(f"\nWritten: {out_path} ({len(ddl)} bytes)")

# 즉시 적용
try:
    cur.execute(ddl)
    print("✅ Apply: OK")
except Exception as e:
    print(f"❌ Apply: {e}")

conn.commit()
cur.close()
conn.close()
