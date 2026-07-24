# -*- coding: utf-8 -*-
"""사내 라이브 GT_GGET_*/GT_MFCP_/GT_SAVEPK_ 39종의 실제 DDL 을 덤프 -> 리네임 -> 00B 재작성.
(클라우드 파일이 아니라 라이브 테이블이 body 컬럼 파리티의 권위 소스)
그리고 잘못 만든 GT_DMF0003_* 재생성용 DROP+CREATE 포함."""
import io, os, re, oracledb

BASE = os.path.dirname(os.path.abspath(__file__))
conn = oracledb.connect(user=os.environ["NSCM_ORA_USER"], password=os.environ["NSCM_ORA_PASS"], dsn=os.environ["NSCM_ORA_DSN"])
cur = conn.cursor()
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SEGMENT_ATTRIBUTES',false); END;")
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'STORAGE',false); END;")
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'TABLESPACE',false); END;")

cur.execute("""
SELECT table_name FROM user_tables
 WHERE temporary='Y'
   AND (table_name LIKE 'GT_GGET_%' OR table_name LIKE 'GT_MFCP_%' OR table_name LIKE 'GT_SAVEPK_%')
 ORDER BY table_name""")
names = [r[0] for r in cur.fetchall()]
print("live source GTT:", len(names))

REPL = [("GT_GGET_", "GT_DMF0003_"), ("GT_MFCP_", "GT_DMF0003_MFCP_"), ("GT_SAVEPK_", "GT_DMF0003_SAVEPK_")]
def rn(s):
    for a, b in REPL:
        s = s.replace(a, b)
    return s

out = ["-- [DMF0003 GTT RENAME 20260723] 사내 라이브 정의 기반 리네임 GTT (컬럼 파리티 보장)\n",
       "-- 39 GTT: GT_GGET_/GT_MFCP_/GT_SAVEPK_ -> GT_DMF0003_*  (멱등 -955 skip)\n\n"]
for nm in names:
    ddl = cur.var(oracledb.DB_TYPE_CLOB)
    cur.execute("SELECT DBMS_METADATA.GET_DDL('TABLE', :n, 'SCM_MGR') FROM DUAL", n=nm)
    d = cur.fetchone()[0].read()
    d = rn(d).strip().rstrip(";")
    newnm = rn(nm)
    out.append(f"-- {nm} -> {newnm}\nBEGIN\n  EXECUTE IMMEDIATE q'[{d}]';\nEXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;\nEND;\n/\n")

with io.open(os.path.join(BASE, "00B_GTT_DDL_DMF0003_RENAMED.sql"), "w", encoding="utf-8", newline="") as f:
    f.write("".join(out))
print("rewrote 00B from live, blocks:", len(names))

# 잘못 만든(클라우드 파일 기반) GT_DMF0003_* 를 DROP 후 재생성해야 정확
cur.execute("""SELECT table_name FROM user_tables WHERE temporary='Y' AND table_name LIKE 'GT_DMF0003_%' ORDER BY 1""")
existing = [r[0] for r in cur.fetchall()]
print("existing GT_DMF0003_* to drop&recreate:", len(existing))
dropped = 0
for nm in existing:
    try:
        cur.execute(f'DROP TABLE "SCM_MGR"."{nm}"')
        dropped += 1
    except oracledb.DatabaseError as e:
        code = e.args[0].code
        if code == -14452:
            print("  in-use, skip drop (재생성 불가):", nm)
        elif code == -942:
            pass
        else:
            raise
print("dropped:", dropped)

# 재생성
with io.open(os.path.join(BASE, "00B_GTT_DDL_DMF0003_RENAMED.sql"), "r", encoding="utf-8") as f:
    text = f.read()
ok = 0
for b in re.split(r'(?m)^\s*/\s*$', text):
    if "EXECUTE IMMEDIATE" in b:
        cur.execute(b.strip()); ok += 1
print("recreated blocks:", ok)

cur.execute("""SELECT COUNT(*) FROM user_tables WHERE temporary='Y' AND table_name LIKE 'GT_DMF0003_%'""")
print("GT_DMF0003_* now:", cur.fetchone()[0])
