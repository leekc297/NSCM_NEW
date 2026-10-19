"""PR_DM_BPS_METAL_LINK_S — VERSION_NO 한 자리('_V1') 생성 수정 (사내 ZIOUI1)

원인: GT_DBML_VERSION_SEQ.VERSION_SEQ 가 NUMBER → LPAD 로 넣은 '02' 가 2 로 저장되고
      VERSION_NO_T || NVL(Y.VERSION_SEQ, '01') 의 NVL 결과형도 NUMBER → '01' 이 1 → '..._V1' / '..._V2'
사용자 결정(2026-10-01): GTT 는 그대로 두고 SP 를 수정
  지시식 NVL(TO_CHAR(Y.VERSION_SEQ, '00'), '01') 의 '00' 은 부호 자리 공백을 붙여 ' 02' → '..._V 02' (사내 실측)
  → 동일 의도로 'FM00' 사용: NVL(TO_CHAR(Y.VERSION_SEQ, 'FM00'), '01')  → V01 / V02

사용:
  python build_apply.py build   # USER_SOURCE 재조회 → 00_BACKUP / 01_PROC 생성 (치환 1회 assert)
  python build_apply.py apply   # FRESH-GATE 통과 시 적용 + 컴파일 확인 + 식 재현
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
NAME = "PR_DM_BPS_METAL_LINK_S"
TYP = "PROCEDURE"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261001-VERSEQ2D]"
OLD = "NVL(Y.VERSION_SEQ, '01') VERSION_NO"
NEW = (f"NVL(TO_CHAR(Y.VERSION_SEQ, 'FM00'), '01') VERSION_NO "
       f"/*{MARK} GTT VERSION_SEQ=NUMBER → NVL 결과 NUMBER 로 '_V1' 생성되던 결함. 'FM00' = 공백 없는 2자리*/")


def connect():
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    con.call_timeout = 900000
    return con


def read_source(cur):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n AND object_type=:t", n=NAME, t=TYP)
    ddl = cur.fetchone()[0]
    cur.execute("SELECT text FROM user_source WHERE name=:n AND type=:t ORDER BY line", n=NAME, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = read_source(cur)
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM dual")
        fetched = cur.fetchone()[0]
    src = s["src"]
    if MARK in src:
        sys.exit(f"ABORT: {MARK} 이미 존재")
    n = src.count(OLD)
    if n != 1:
        sys.exit(f"ABORT: '{OLD}' 일치 {n}회 (1회여야 함)")
    new = src.replace(OLD, NEW)
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
    open(os.path.join(HERE, f"00_BACKUP_{NAME}.sql"), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(src) + "/\n")
    open(os.path.join(HERE, f"01_{NAME}.sql"), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
    json.dump({"last_ddl": s["last_ddl"], "md5": s["md5"], "fetched": fetched}, open(STATE, "w"), indent=1)
    print("BUILD OK", fetched, s["last_ddl"], s["md5"], "lines", src.count("\n"), "->", new.count("\n"), flush=True)


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS", flush=True)
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
        cur.execute(strip(open(os.path.join(HERE, f"01_{NAME}.sql"), encoding="utf-8").read()))
        print(f"APPLIED 01_{NAME}.sql", flush=True)
        cur.execute("SELECT status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n", n=NAME)
        print("  ", cur.fetchall())
        cur.execute("SELECT line, position, text FROM user_errors WHERE name=:n ORDER BY sequence", n=NAME)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs), errs)
        cur.execute("SELECT line, TRIM(text) FROM user_source WHERE name=:n AND INSTR(text, :m) > 0", n=NAME, m=MARK)
        print("MARKER", cur.fetchall())
        # 식 재현 — 실제 GTT(NUMBER) 경유: 첫 실행(행 없음) V01 / 다음 V02 / 10회차 V10
        cur.execute("DELETE FROM GT_DBML_VERSION_SEQ")
        cur.execute("INSERT INTO GT_DBML_VERSION_SEQ (DIVISION_ID, VERSION_SEQ) SELECT '82', LPAD(CAST(2 AS VARCHAR2(10 CHAR)), 2, '0') FROM dual")
        cur.execute("INSERT INTO GT_DBML_VERSION_SEQ (DIVISION_ID, VERSION_SEQ) SELECT '81', LPAD(CAST(10 AS VARCHAR2(10 CHAR)), 2, '0') FROM dual")
        cur.execute("""SELECT D.DIV, '26RF_DM_2026_W40_V' || NVL(TO_CHAR(Y.VERSION_SEQ, 'FM00'), '01')
                         FROM (SELECT '40' DIV FROM dual UNION ALL SELECT '81' FROM dual UNION ALL SELECT '82' FROM dual) D
                         LEFT JOIN GT_DBML_VERSION_SEQ Y ON Y.DIVISION_ID = D.DIV ORDER BY 1""")
        print("REPRO", cur.fetchall())
        con.rollback()


if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
