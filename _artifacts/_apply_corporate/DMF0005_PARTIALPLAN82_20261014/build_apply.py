"""DMF0005 조회에 PARTIAL_PLAN_YN 반환 추가 [E20261014-DMF0005PARTIALGET] (사내 ZIOUI1)

사용자 요청(2026-10-14): DMF0005 SSPM 82 Sheet 에 PARTIAL_PLAN_YN 컬럼 표시 — 조회에 누락되어 있으면 조회에 추가.

현상: Sheet 메타(production_82 / PARTIAL_PLAN_YN)는 추가했으나 P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION 이
  PARTIAL_PLAN_YN 을 반환하지 않아 값이 빈칸. 저장 프로시저는 이미 이 컬럼을 처리한다.
  AS-IS DMF0005_GET_SALES_SITE_MODEL_PRODUCTION 은 원장 값을 그대로 반환한다(SITE_ITEM.PARTIAL_PLAN_YN / A.PARTIAL_PLAN_YN).

보완: 조회 프로시저에 2줄 추가 — BASE 목록 끝에 SI.PARTIAL_PLAN_YN, 최종 SELECT 끝에 BF.PARTIAL_PLAN_YN.
  (중간 BF 는 SELECT B.* 라 그대로 전달된다.) 기존 줄은 한 글자도 바꾸지 않는다.

  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성
  python build_apply.py apply   # FRESH-GATE 통과 시 BODY 적용 + 컴파일 확인
"""
import sys, os, re, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0005"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261014-DMF0005PARTIALGET]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0005_BODY.sql", "01_PKG_DMF0005_BODY.sql"

P_START = "PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION ("
P_END = "END P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION;"
# (앵커 줄, 바로 다음 줄의 시작, 추가할 식)
R_BASE = re.compile(r"^([ \t]*), CM\.CUSTOMER_MODEL[ \t]*\n(?=[ \t]*FROM[ \t]+SCM_MST_SITE_ITEM[ \t]+SI\b)", re.M)
R_PROJ = re.compile(r"^([ \t]*), BF\.EDIT_FLAG[ \t]*\n(?=[ \t]*FROM[ \t]*\()", re.M)
C_BASE = f"-- 2026.10.14 {MARK} Partial Plan YN 조회 추가(AS-IS 와 같이 원장 값 그대로)"
C_PROJ = f"-- 2026.10.14 {MARK} Partial Plan YN 조회 추가"


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
    if body.count(P_START) != 1 or body.count(P_END) != 1:
        sys.exit(f"ABORT: 프로시저 시작 {body.count(P_START)}회 · 끝 {body.count(P_END)}회")
    a = body.index(P_START)
    b = body.index(P_END, a)
    reg = body[a:b]
    if "PARTIAL_PLAN_YN" in reg.upper():
        sys.exit("ABORT: 조회 프로시저에 PARTIAL_PLAN_YN 이 이미 있음 — 원문이 바뀜")
    n1, n2 = len(R_BASE.findall(reg)), len(R_PROJ.findall(reg))
    if n1 != 1 or n2 != 1:
        sys.exit(f"ABORT: 앵커 개수 불일치 — BASE 끝 {n1} · 최종 SELECT 끝 {n2} (1 · 1 이어야 함)")
    if not (R_BASE.search(reg).start() < R_PROJ.search(reg).start()):
        sys.exit("ABORT: BASE 가 최종 SELECT 보다 뒤에 있음")
    reg = R_BASE.sub(lambda m: m.group(0) + f"{m.group(1)}, SI.PARTIAL_PLAN_YN    {C_BASE}\n", reg)
    reg = R_PROJ.sub(lambda m: m.group(0) + f"{m.group(1)}, BF.PARTIAL_PLAN_YN    {C_PROJ}\n", reg)
    assert reg.count("SI.PARTIAL_PLAN_YN") == 1 and reg.count("BF.PARTIAL_PLAN_YN") == 1 and reg.count(MARK) == 2
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
    old_l, new_l = s["src"].split("\n"), new.split("\n")
    added = [(i + 1, l) for i, l in enumerate(new_l) if MARK in l]
    rest = [l for l in new_l if MARK not in l]
    print("BUILD OK", fetched, "HOST", host, "LAST_DDL", s["last_ddl"], "lines", len(old_l), "->", len(new_l),
          "| 추가 줄 빼면 원문과 동일:", rest == old_l)
    for i, l in added:
        print(f"  + {i}: {l.strip()}")


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
