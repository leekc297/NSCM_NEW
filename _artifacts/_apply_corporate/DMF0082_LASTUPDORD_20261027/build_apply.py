"""DMF0082 조회 — LAST UPDATED BY · LAST UPDATE DATE 를 정렬 키(ORDER BY)에서 제외 [E20261027-DMF0082LASTUPDORD] (사내 ZIOUI1)

사용자 요청(2026-10-27): [E20261027-DMF0082LASTUPD] 로 두 컬럼을 줄 묶음(GROUP BY)에서 뺀 데 이어 ORDER BY 에서도 뺀다.
원인: V_ORDERBY 는 C_TITLE(사용자 Column Set) 컬럼을 그대로 이어 붙여, 두 컬럼을 고르면 수정일·수정자 순으로 줄 순서가 바뀐다.
보완: 두 조회 프로시저(GET_MAIN_DATA · GET_MAIN_DATA_CURRENT)의 C_TITLE 루프 직후에 V_ORDERBY 에서 두 컬럼 토큰만 제거하는 1문장씩.
      두 컬럼이 없으면 V_ORDERBY 는 원래 값 그대로(토큰 치환 무발생). 기존 문장 무변경.

  python build_apply.py build | apply
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
STATE = os.path.join(HERE, "_fresh_state.json")
PKG, TYP = "PKG_DMF0082", "PACKAGE BODY"
MARK = "[E20261027-DMF0082LASTUPDORD]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"
ANCHOR = "    END LOOP;\n    CLOSE C_TITLE;\n"
BLOCK = (
    "\n"
    f"    --{MARK} LAST UPDATED BY · LAST UPDATE DATE 는 참고값 — 정렬 키에서도 뺀다 (사용자 요청 2026-10-27).\n"
    "    --  [E20261027-DMF0082LASTUPD] 로 줄 묶음에서 뺀 것과 같은 기준: 두 컬럼을 Column Set 에 넣어도 줄 순서는 키 컬럼으로만 정한다.\n"
    "    --  V_ORDERBY 는 ' ORDER BY SORT_KEY, 컬럼, 컬럼…' 형태라 ', 컬럼' 토큰만 제거한다(두 컬럼이 없으면 원래 값 그대로).\n"
    "    V_ORDERBY := RTRIM(REPLACE(REPLACE(V_ORDERBY || ',', ', LAST_UPDATED_BY,', ','), ', LAST_UPDATE_DATE,', ','), ',');\n"
)


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=PKG, t=TYP)
    ddl = cur.fetchone()[0]
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=PKG, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def transform(body):
    if MARK in body:
        sys.exit(f"ABORT: {MARK} 이미 존재")
    if body.count(ANCHOR) != 2:
        sys.exit(f"ABORT: 앵커 {body.count(ANCHOR)}회 (2 기대)")
    p1 = body.index(ANCHOR); p2 = body.index(ANCHOR, p1 + 1)
    cs = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT"); ce = body.index("\nPROCEDURE P_DMF0082_GET_SPREAD_TITLE")
    if not (p1 < cs < p2 < ce):
        sys.exit("ABORT: 앵커 위치가 GET_MAIN_DATA / CURRENT 순서와 다름")
    for p in (p1, p2):
        if "V_ORDERBY := V_ORDERBY ||" not in body[p - 600:p]:
            sys.exit("ABORT: 앵커 앞에 V_ORDERBY 조립 문장이 없음")
    parts = body.split(ANCHOR)
    return parts[0] + ANCHOR + BLOCK + parts[1] + ANCHOR + BLOCK + parts[2]


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
    print("BUILD OK", fetched, host, "LAST_DDL", s["last_ddl"], "+", new.count("\n") - s["src"].count("\n"), "lines, marker", new.count(MARK))


def strip(txt):
    t = "\n".join(l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        if cur.fetchone()[0] != st["host"]:
            sys.exit("ABORT: 접속 DB 가 build 시점과 다름")
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == build 시점 기준본
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} → now {now['last_ddl']}")
        print("FRESH-GATE PASS")
        tobe = strip(open(os.path.join(HERE, F_NEW), encoding="utf-8").read())
        cur.execute(tobe)
        after = read_source(cur)
        cur.execute("SELECT status FROM user_objects WHERE object_name=:n AND object_type=:t", n=PKG, t=TYP)
        stt = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM user_errors WHERE name=:n AND type=:t", n=PKG, t=TYP)
        print("APPLIED", stt, "LAST_DDL", after["last_ddl"], "DB==TOBE", after["src"].rstrip() == tobe[len("CREATE OR REPLACE "):].rstrip(),
              "marker", after["src"].count(MARK), "errors", cur.fetchone()[0])


if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
