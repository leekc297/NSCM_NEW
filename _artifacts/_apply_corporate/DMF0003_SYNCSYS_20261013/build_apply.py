"""DMF0003 저장 연계 Sales Plan 동기화 — 생성자·수정자 기록을 'SYSTEM' 으로 [E20261013-DMF0003SYNCSYS] (사내 ZIOUI1)

사용자 요청(2026-10-13): P_DMF0003_MKT_FCST_SALES_PLAN_SYNC 가 DM_PLN_SALES_PLAN 에 기록하는 생성자·수정자를 아래로 변경.
  수량(MKT_FCST·CUST_FCST·TMM_FCST·RTF·RTF_SYS_RP) : 생성자 = 원장 행의 생성자 그대로 · 생성 시각 = 원장 생성 시각 · 수정자 = 'SYSTEM' · 수정 시각 = 저장 시각
  금액(SalesAmt_KRW/LOC/USD · MKT_AMT_KRW/LOC)       : 생성자 = 'SYSTEM' · 생성 시각 = 저장 시각 · 수정자 = 'SYSTEM' · 수정 시각 = 저장 시각

종전: 수정자 = DMF0003 에서 저장한 사용자(전 메저), 금액 메저 생성자 = 저장한 사용자.
  82 사업부는 한 품목만 저장해도 사업부 전체 Sales Plan(당주 이후)이 다시 기록되므로, 손대지 않은 품목·메저까지
  그 사용자가 수정한 것으로 남았다 (클라우드 QA 10-13 13:42 k0101 — 12,249행).
  AS-IS DMF0003_MKT_FCST_SALES_PLAN_SYNC L335~336 도 저장한 사용자로 기록 = 이번 변경은 AS-IS 대비 의도적 변경.

보완: 최종 INSERT 의 SELECT 목록 2줄만 교체 (종전 2줄은 줄 주석으로 보존). 수량·금액 값, 삭제 범위, 메저 목록 무변경.
  호출처는 P_DMF0003_SAVE_MKT_FCST 한 곳(82 일 때)뿐이다.

  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성
  python build_apply.py apply   # FRESH-GATE 통과 시 BODY 적용 + 컴파일 확인
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0003"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261013-DMF0003SYNCSYS]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0003_BODY.sql", "01_PKG_DMF0003_BODY.sql"

OLD_LINES = [
    "                 , NVL(CREATED_BY, V_CREATED_BY), NVL(CREATION_DATE, SYSDATE)",
    "                 , V_CREATED_BY, SYSDATE AS LAST_UPDATE_DATE",
]
OLD = "".join(l + "\n" for l in OLD_LINES)
NEW = (
    f"                 --{MARK} 사용자 요청(2026-10-13): 생성자·수정자를 저장한 사용자가 아니라 'SYSTEM' 으로 기록한다.\n"
    "                 --  수량 메저(MKT_FCST·CUST_FCST·TMM_FCST·RTF·RTF_SYS_RP) = 생성자·생성 시각은 원장 값 그대로, 수정자만 'SYSTEM'.\n"
    "                 --  금액 메저(SalesAmt_KRW/LOC/USD·MKT_AMT_KRW/LOC) = 생성자·수정자 모두 'SYSTEM', 생성 시각 = 저장 시각.\n"
    "                 --  수정 시각 = 전 메저 저장 시각. 메저 종류로 직접 구분한다 (원장 생성자가 빈 수량 행에 'SYSTEM' 이 들어가지 않게).\n"
    "                 --  종전에는 82 를 한 품목만 저장해도 사업부 전체 행이 그 사용자가 수정한 것으로 남았다 (AS-IS 동일 → 의도적 변경).\n"
    + "".join("--" + l + "\n" for l in OLD_LINES)
    + "                 , CASE WHEN MEASURE IN ('MKT_FCST', 'CUST_FCST', 'TMM_FCST', 'RTF', 'RTF_SYS_RP') THEN CREATED_BY ELSE 'SYSTEM' END, NVL(CREATION_DATE, SYSDATE)\n"
    + "                 , 'SYSTEM', SYSDATE AS LAST_UPDATE_DATE\n"
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
    n = body.count(OLD)
    if n != 1:
        sys.exit(f"ABORT: 최종 기록 2줄 앵커 일치 {n}회 (1회여야 함) — 원문이 바뀌었음")
    # 앵커가 동기화 프로시저 안에 있는지 확인 (다른 프로시저의 같은 문장을 건드리지 않는다)
    pos = body.index(OLD)
    s = body.rfind("\nPROCEDURE ", 0, pos)
    head = body[s:s + 80]
    if "P_DMF0003_MKT_FCST_SALES_PLAN_SYNC" not in head:
        sys.exit(f"ABORT: 앵커가 동기화 프로시저 밖에 있음 — {head!r}")
    return body.replace(OLD, NEW)


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
