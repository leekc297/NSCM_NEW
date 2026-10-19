"""DMF0082 저장 — 단가 검증(#10)의 '판매계획 조정 제외' 품목 예외 주석 처리 [E20261013-DMF0082ADJYNALL] (사내 ZIOUI1)

사용자 요청(2026-10-13): "SALES_PLAN_ADJUST_YN = 'N' 이면 단가미적용 항목이 있는데, 이 제외조건을 주석처리 해주세요.
  SALES_PLAN_ADJUST_YN = 'N' 이라도 단가 적용 VALIDATION 적용 되도록 하는 것이 목적"

현행: P_DMF0082_SAVE_MAIN_DATA 검증 #10(Sales Price 해당 주차 확인)은 Site-Item 마스터(SCM_MST_SITE_ITEM)에
  SALES_PLAN_ADJUST_YN='N' 으로 등록된 품목을 검사에서 뺀다 → 그 품목은 판가 없이 수량이 저장된다
  (클라우드 QA 10-12 실측: 40 · AJ상사_AB_TES · MCCM356015A2 · Aima — 오창A 판가 없이 MKT_FCST 저장).
  AS-IS DMF0082_SAVE_MAIN_DATA(LGCE_SCMDEV 06-12본 L1185~1191)도 같은 예외 = 이번 변경은 AS-IS 대비 의도적 강화.
보완: 제외조건 8줄을 줄 주석으로 막는다(삭제하지 않음). 다른 문장 무변경.
  PKG_DMF0082 안에서 이 플래그로 검증을 빼는 곳은 이 한 곳뿐이다(나머지 4곳은 팝업 조회의 컬럼 출력).

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
MARK = "[E20261013-DMF0082ADJYNALL]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"

OLD_LINES = [
    "          AND NOT EXISTS (SELECT 1",
    "                            FROM SCM_MGR.SCM_MST_SITE_ITEM Z",
    "                           WHERE Z.DIVISION_ID  = A.DIVISION_ID",
    "                             AND Z.PROJECT_CODE = A.PROJECT_CODE",
    "                             AND Z.SCM_SITE_ID  = A.SCM_SITE_ID",
    "                             AND Z.ITEM_ID      = A.ITEM_ID",
    "                             AND Z.VALID_YN     = 'Y'",
    "                             AND Z.SALES_PLAN_ADJUST_YN = 'N')",
]
OLD = "".join(l + "\n" for l in OLD_LINES)
NEW = (
    f"          --{MARK} 사용자 요청(2026-10-13): 판매계획 조정 제외(SALES_PLAN_ADJUST_YN='N') 품목도 단가 검증 대상.\n"
    "          --  아래 제외조건 8줄 주석 처리 — 종전에는 이 품목이 판가 없이 수량 저장됐다(AS-IS 동일 예외 → 의도적 강화).\n"
    + "".join("--" + l + "\n" for l in OLD_LINES)
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
        sys.exit(f"ABORT: 단가 검증 제외조건 앵커 일치 {n}회 (1회여야 함) — 원문이 바뀌었음")
    return body.replace(OLD, NEW)


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = read_source(cur)   # 기준본 = 지금 ALL_SOURCE 에서 새로 조회한 원문
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM dual")
        fetched = cur.fetchone()[0]
    new = transform(s["src"])
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
    open(os.path.join(HERE, F_BAK), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(s["src"]) + "/\n")
    open(os.path.join(HERE, F_NEW), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
    json.dump({"last_ddl": s["last_ddl"], "md5": s["md5"], "fetched": fetched}, open(STATE, "w"), indent=1)
    print("BUILD OK", fetched, "LAST_DDL", s["last_ddl"], "lines", s["src"].count("\n"), "->", new.count("\n"),
          "(+", new.count("\n") - s["src"].count("\n"), ") marker", new.count(MARK))


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == build 시점 기준본 (다르면 중단·재빌드)
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS")
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
