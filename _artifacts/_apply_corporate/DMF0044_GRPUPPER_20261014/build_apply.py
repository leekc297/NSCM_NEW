"""DMF0044 조회 CUTOFF DATA 구간 ORA-00979 보완 [E20261014-DMF0044GRPUPPER] (사내 ZIOUI1)

사용자 신고(2026-10-14): 클라우드 DMF0044 조회 — Data Type 이 ALL · CUTOFF DATA 이면 SQL ERROR, ETC 는 정상.

원인(사내 재현): P_DMF0044_GET_SALES_REPORTS_DATA 의 CUTOFF DATA INSERT 문에서
  SELECT 의 Model Type 식은  CASE WHEN UPPER(SINGLE.ITEM_CLASS_NAME) LIKE '%CELL%' …  (UPPER 있음)
  GROUP BY 의 같은 식은      CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' …         (UPPER 없음)
  → ORA-00979 "SINGLE"."ITEM_CLASS_NAME": must appear in the GROUP BY clause (line 1482).
  10-06 백업본에는 SELECT 에도 UPPER 가 없었다 — 그 뒤 SELECT 3줄에만 UPPER 가 들어가고 GROUP BY 가 따라가지 않았다
  (BODY LAST_DDL 2026-10-13 19:46:40, 마커 없음 — 이 작업자의 변경 아님).
  ETC 구간은 SELECT · GROUP BY 모두 UPPER 가 없어 정상이다.

보완: GROUP BY 의 3줄을 SELECT 와 같은 식(UPPER)으로 맞춘다. SELECT 는 건드리지 않는다(대소문자 무시 판정을 넣은 변경은 유지).
  범위 = 프로시저 시작 ~ ETC 구간 시작(IF P_DATA_TYPE <> '1' THEN) 사이. ETC 구간 무변경.

  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성
  python build_apply.py apply   # FRESH-GATE 통과 시 BODY 적용 + 컴파일 확인
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0044"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261014-DMF0044GRPUPPER]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0044_BODY.sql", "01_PKG_DMF0044_BODY.sql"

P_START = "\nPROCEDURE P_DMF0044_GET_SALES_REPORTS_DATA"
P_END = "IF P_DATA_TYPE <> '1' THEN"                        # ETC 구간 시작 = 보완 범위의 끝
T_UP = "WHEN UPPER(SINGLE.ITEM_CLASS_NAME) LIKE '%"       # SELECT 쪽 (그대로 둔다)
T_RAW = "WHEN SINGLE.ITEM_CLASS_NAME LIKE '%"             # GROUP BY 쪽 (UPPER 로 맞춘다)
G_OLD = "CASE WHEN SINGLE.ITEM_CLASS_NAME LIKE '%CELL%' THEN 'Cell'\n"
G_NEW = f"CASE WHEN UPPER(SINGLE.ITEM_CLASS_NAME) LIKE '%CELL%' THEN 'Cell'  --{MARK} SELECT 의 Model Type 식과 같게(UPPER) — 달라서 ORA-00979\n"


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=PKG, t=TYP)
    ddl = cur.fetchone()[0]
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=PKG, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def transform(body):
    if MARK in body:
        sys.exit(f"ABORT: BODY 에 {MARK} 이미 존재 — 재적용 불필요")
    if "\r" in body:
        sys.exit("ABORT: BODY 원문에 CR 포함")
    if body.count(P_START) != 1:
        sys.exit(f"ABORT: 프로시저 시작 {body.count(P_START)}회")
    a = body.index(P_START)
    b = body.index(P_END, a)
    reg = body[a:b]
    if reg.count(T_UP) != 3 or reg.count(T_RAW) != 3 or reg.count(G_OLD) != 1:
        sys.exit(f"ABORT: CUTOFF 구간 식 개수 불일치 — UPPER {reg.count(T_UP)} · UPPER 없음 {reg.count(T_RAW)} · 첫 줄 {reg.count(G_OLD)} (3 · 3 · 1 이어야 함)")
    if not (reg.rindex(T_UP) < reg.rindex("GROUP BY", 0, reg.index(T_RAW)) < reg.index(T_RAW)):   # T_RAW 바로 앞의 GROUP BY 가 UPPER 식 뒤에 있어야 한다
        sys.exit("ABORT: UPPER 식이 SELECT, UPPER 없는 식이 GROUP BY 에 있는 구조가 아님")
    reg = reg.replace(G_OLD, G_NEW).replace(T_RAW, T_UP)
    assert reg.count(T_UP) == 6 and reg.count(T_RAW) == 0 and reg.count("CASE WHEN UPPER(SINGLE.ITEM_CLASS_NAME) LIKE '%CELL%'") == 2
    return body[:a] + reg + body[b:]


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = read_source(cur)   # 기준본 = 지금 ALL_SOURCE 에서 새로 조회한 원문
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI'), SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        fetched, host = cur.fetchone()
    new = transform(s["src"])
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
    open(os.path.join(HERE, F_BAK), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(s["src"]) + "/\n")
    open(os.path.join(HERE, F_NEW), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
    json.dump({"last_ddl": s["last_ddl"], "md5": s["md5"], "fetched": fetched, "host": host}, open(STATE, "w"), indent=1)
    diff = sum(1 for x, y in zip(s["src"].split("\n"), new.split("\n")) if x != y)
    print("BUILD OK", fetched, "HOST", host, "LAST_DDL", s["last_ddl"], "lines", s["src"].count("\n"), "->", new.count("\n"),
          "changed lines", diff, "marker", new.count(MARK))


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        host = cur.fetchone()[0]
        if host != st["host"]:
            sys.exit(f"ABORT: 접속 DB 가 build 시점과 다름 (build {st['host']} → now {host})")
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == build 시점 기준본 (다르면 중단·재빌드)
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS", "HOST", host)
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        inv_before = cur.fetchone()[0]
        tobe = strip(open(os.path.join(HERE, F_NEW), encoding="utf-8").read())
        cur.execute(tobe)
        after = read_source(cur)
        print("APPLIED", F_NEW, "DB==TOBE", after["src"].rstrip() == tobe[len("CREATE OR REPLACE "):].rstrip(),
              "marker", after["src"].count(MARK))
        cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n ORDER BY 1", n=PKG)
        for r in cur:
            print("  ", r)
        cur.execute("SELECT type, line, position, text FROM user_errors WHERE name=:n ORDER BY sequence", n=PKG)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs))
        for e in errs:
            print("  ", e)
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        print("SCM_MGR INVALID objects", inv_before, "->", cur.fetchone()[0])


if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
