"""DMF0082 조회 — 시스템 컬럼 10종은 DEFAULT_FLAG 값과 무관하게 항상 포함 [E20261013-DMF0082DEFFLAGN] (사내 ZIOUI1)

사용자 지시(2026-10-13): "DEFAULT_FLAG 가 'N' 으로 처리되어도 오류가 발생하면 안됩니다."

증상: 10-13 11:48 부터 DMF0082 조회가 SQL ERROR (ORA-00904 "SORT_KEY", PKG_DMF0082 L4741 OPEN O_RC1).
원인: SCM_MST_SHEET_COLUMNS(DMF0082·FcstNPrice) 시스템 컬럼 10종의 DEFAULT_FLAG 가 '/' → 'N' 으로 바뀜(11:48:18).
  C_TITLE 커서 2번째 UNION 은 빈값 표기('/')인 컬럼만 고르므로 0건 → V_COLUMN 에 SORT_KEY 등이 빠지고
  고정 문장 'ORDER BY SORT_KEY' 가 없는 컬럼을 가리킨다.
보완: 2번째 UNION 의 판정을 "빈값 표기(NULL/' '/'-'/'/') 이거나, 시스템 컬럼 10종이면 값 무관" 으로 넓힌다.
  그 외 'N' 컬럼(사용자 선택 컬럼 39종)은 종전대로 제외한다 — 넣으면 GROUP BY 축이 늘어 행이 갈린다.
  대상 2곳: P_DMF0082_GET_MAIN_DATA · P_DMF0082_GET_MAIN_DATA_CURRENT (같은 문장). 다른 문장 무변경.

  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성
  python build_apply.py apply   # FRESH-GATE 통과 시 BODY 적용 + 컴파일 확인
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0082"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261013-DMF0082DEFFLAGN]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"

SYS_COLS = ['GROUP_ID', 'VERSION_NO', 'MEASURE_GROUP', 'BUCKET', 'EDIT_FLAG',
            'SORT_KEY', 'NEW_FLAG', 'ATTR1', 'VMI_STD_DIO', 'AS_YN']
OLD_PREFIX = "        AND    NVL(TRIM(C.DEFAULT_FLAG), '/') = '/'"
NEW = (
    f"        --{MARK} 사용자 지시(2026-10-13): DEFAULT_FLAG 가 'N' 이어도 조회 오류가 나면 안 된다.\n"
    "        --  시스템 컬럼 10종(AS-IS DEFAULT_FLAG='' 인 컬럼)은 DEFAULT_FLAG 값과 무관하게 항상 포함한다.\n"
    "        --  빠지면 V_COLUMN 에 SORT_KEY 가 없어 'ORDER BY SORT_KEY' 가 ORA-00904 (10-13 11:48 실측, 10종이 'N' 으로 바뀜).\n"
    "        --  그 외 'N' 컬럼(사용자 선택 컬럼)은 종전대로 제외 — 포함하면 GROUP BY 축이 늘어 행이 갈린다.\n"
    "        AND    ( RTRIM(C.DEFAULT_FLAG, ' -/') IS NULL\n"
    "              OR C.COLUMN_NAME IN (" + ",".join(f"'{c}'" for c in SYS_COLS) + ") )\n"
)


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
    out, hit = [], 0
    for line in body.split("\n"):
        if line.startswith(OLD_PREFIX):
            hit += 1
            out.append("--" + line)          # 종전 판정은 줄 주석으로 보존
            out.append(NEW.rstrip("\n"))
        else:
            out.append(line)
    if hit != 2:
        sys.exit(f"ABORT: DEFAULT_FLAG 판정 앵커 일치 {hit}회 (2회여야 함) — 원문이 바뀌었음")
    return "\n".join(out)


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
    print("BUILD OK", fetched, "HOST", host, "LAST_DDL", s["last_ddl"], "lines", s["src"].count("\n"), "->", new.count("\n"),
          "(+", new.count("\n") - s["src"].count("\n"), ") marker", new.count(MARK))


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
