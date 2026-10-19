"""사내 리허설 — 01 실행 · 02 블록 실행(SPOOL 대신 DBMS_OUTPUT 수집) · 생성 스크립트 충실도/문법 검증 (저장 호출은 실행하지 않음)"""
import sys, os, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "_rehearsal_out"); os.makedirs(OUT, exist_ok=True)


def drain(cur):
    lines, chunk, n = [], cur.arrayvar(str, 1000), cur.var(int)
    while True:
        n.setvalue(0, 1000)
        cur.callproc("dbms_output.get_lines", [chunk, n])
        lines.extend(x or "" for x in chunk.getvalue()[: n.getvalue()])
        if n.getvalue() < 1000:
            return lines


u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.callproc("dbms_output.enable", [None])

# 01 — SELECT 2개
t01 = open(os.path.join(HERE, "A_DB", "01_FIND_DMF0082_BULK_SAVE_CLOUD.sql"), encoding="utf-8").read()
for st in [s.strip() for s in re.split(r";\s*\n", t01) if s.strip()]:
    body = "\n".join(l for l in st.split("\n") if not l.strip().startswith(("--", "SET "))).strip()
    if not body:
        continue
    cur.execute(body)
    print([c[0] for c in cur.description]); [print(r) for r in cur.fetchall()]

# 02 — DECLARE … END; 블록만
t02 = open(os.path.join(HERE, "A_DB", "02_MAKE_REPLAY_SCRIPT_CLOUD.sql"), encoding="utf-8").read()
blk = t02[t02.index("DECLARE"): t02.index("\n/\nSPOOL OFF")]
cur.execute(blk)
gen = drain(cur)
gpath = os.path.join(OUT, "DMF0082_SAVE_REPLAY.sql")
open(gpath, "w", encoding="utf-8", newline="\n").write("\n".join(gen) + "\n")
print("generated lines", len(gen), "bytes", os.path.getsize(gpath)); print(gen[0]); print(gen[1]); print(gen[-1])

# 충실도: 생성 스크립트의 조각을 다시 이어 붙인 값 == 원본 SQL_TEXT 의 인자 값
seq = int(re.search(r"LOG_SEQ=(\d+)", gen[1]).group(1))
cur.execute("SELECT SQL_TEXT FROM SCM_MGR.SCM_COM_SQL_LOG WHERE LOG_SEQ=:s", s=seq)
txt = cur.fetchone()[0].read()
head = "{call PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA( '"; tail = "', NULL)}"
orig = txt[len(head):-len(tail)].split("', '")
rebuilt = {}
for l in gen:
    m = re.match(r"\s+DBMS_LOB\.APPEND\(v_(\w+), TO_CLOB\('(.*)'\)\);$", l)
    if m:
        rebuilt.setdefault(m.group(1), []).append(m.group(2).replace("''", "'"))
names = list(rebuilt.keys())
print("params orig", len(orig), "rebuilt", len(names))
ok = len(orig) == 17 and all("".join(rebuilt[n]) == orig[i] for i, n in enumerate(names))
print("FIDELITY", "PASS" if ok else "FAIL", "rows", orig[0].count("^") + 1)

# 문법·크기: 저장 호출~커서 출력 구간을 빼고 실행 (인자 조립 + 길이 출력까지)
src = "\n".join(gen)
plsql = src[src.index("DECLARE"): src.index("\n/\n")]
cut_s = plsql.index("    v_t0 := SYSTIMESTAMP;")
cut_e = plsql.index("    DBMS_SQL.CLOSE_CURSOR(v_cur);") + len("    DBMS_SQL.CLOSE_CURSOR(v_cur);")
dry = plsql[:cut_s] + "    NULL; -- DRY-RUN: SAVE call skipped\n" + plsql[cut_e:]
cur.execute(dry)
for l in drain(cur):
    print("  DRY", l)
# 호출부 문법만 따로 검증: 호출을 포함한 전체 블록을 컴파일만 (DBMS_SQL.PARSE 는 익명블록 실행이 되므로, 호출을 IF 1=0 으로 감싼 사본)
guarded = plsql.replace("    v_t0 := SYSTIMESTAMP;", "    IF 1 = 0 THEN\n    v_t0 := SYSTIMESTAMP;", 1).replace(
    "    DBMS_SQL.CLOSE_CURSOR(v_cur);", "    DBMS_SQL.CLOSE_CURSOR(v_cur);\n    END IF;", 1)
cur.execute(guarded)
print("GUARDED (call compiled, not executed) OK")
