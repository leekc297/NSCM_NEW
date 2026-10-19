"""DMF0005 조회 — Sold-To 행별 실행 제거 + Owner 이름 행별 재계산 차단 [E20261014-DMF0005SCONM] (사내 ZIOUI1)
사용자 승인 2026-10-14 ("1, 2번 적용해주세요" — 1 = 구조 보완, 2 = 힌트 NO_PUSH_PRED(ONM))

배경: NOPUSH 패치(E20261014-DMF0005NOPUSH) 적용 뒤 클라우드 QA 실측(C06, 2회차) 82 39.8s · 81 36.8s · 40 16.3s.
  남은 시간 = 두 구간이 결과 행마다 반복 (QA SQL Monitor ALLSTATS):
  ① Sold-To(SCM_MST_SITE_CUSTOMER) 조인 — VW_DCL(행별 실행 형태) 45,675회 · 82 23.8s / 81 15.3s / 40 12.5s
  ② Owner 이름(OWNER_NM) — VIEW PUSHED PREDICATE 45,675회 · 원장 인덱스 9,100만 ~ 1억 3,800만 행 SORT UNIQUE · 82 22.4s / 81 32.4s / 40 4.4s
보완:
  1 (구조 · hook #129 3순위) BASE 의 Sold-To LEFT JOIN ON 절에서 `AND (P_DIVISION_ID = '82' OR NVL(SC.VALID_YN, 'Y') = 'Y')` 제거(주석 보존).
    바로 위 `AND SC.VALID_YN = 'Y'` 때문에 연결된 행에서는 항상 참 → 결과 동일. 바인드가 섞인 이 조건 때문에 조인이 VW_DCL 로 바뀌어 있었다.
  2 (힌트 · 5순위 · 승인) BASE 의 SELECT 에 /*+ NO_PUSH_PRED(ONM) */ — Owner 이름은 Owner 종류마다 한 번(07-22 설계)만 구한다.
    QA 가 비용 판단으로 고른 행별 반복이라 구문 변경으로 막을 근거가 없어 힌트. 함수 제거(1순위)는 이미 Owner 종류별 1회 구조.
검증(사내): 복제 패키지 결과 동등성 시나리오 96 × 674,518행 PASS (1 단독 · 1+2 모두) · QA 조건 모사 1.3 ~ 2.5초.
  사내는 QA 조건 모사에서도 두 구간을 해시 조인으로 처리해 QA 의 행별 반복이 재현되지 않는다 → QA 효과는 적용 뒤 C06 재측정으로 확인.

  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성
  python build_apply.py apply   # FRESH-GATE 통과 시 BODY 적용 + 컴파일 확인
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0005"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261014-DMF0005SCONM]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0005_BODY.sql", "01_PKG_DMF0005_BODY.sql"

P_START = "PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION ("
P_END = "END P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION;"
REPL = [
    ("    BASE AS (\n        SELECT\n              SI.DIVISION_ID\n",
     "    BASE AS (\n        SELECT /*+ NO_PUSH_PRED(ONM) */    -- 2026.10.14 " + MARK
     + " Owner 이름(OWNER_NM)을 행마다 다시 구하지 않고 Owner 종류마다 한 번(07-22 설계) — 클라우드 QA 행별 반복 대응 · 힌트 사용자 승인\n"
     + "              SI.DIVISION_ID\n"),
    ("         AND (P_DIVISION_ID = '82' OR NVL(SC.VALID_YN, 'Y') = 'Y')\n",
     "--       AND (P_DIVISION_ID = '82' OR NVL(SC.VALID_YN, 'Y') = 'Y')    -- 2026.10.14 " + MARK
     + " 원본 — 바로 위 SC.VALID_YN = 'Y' 로 항상 참. 바인드가 섞인 이 조건이 조인을 행별 실행(VW_DCL)으로 바꿔 제거(결과 동일)\n"),
]


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
    if "E20261014-DMF0005NOPUSH" not in body:
        sys.exit("ABORT: 선행 NOPUSH 패치가 없는 원문")
    if body.count(P_START) != 1 or body.count(P_END) != 1:
        sys.exit(f"ABORT: 프로시저 시작 {body.count(P_START)}회 · 끝 {body.count(P_END)}회")
    a, b = body.index(P_START), body.index(P_END)
    reg = body[a:b]
    if "\r" in reg or "\t" in reg:
        sys.exit("ABORT: 조회 프로시저 원문에 CR 또는 탭 포함")
    for old, new in REPL:
        if body.count(old) != 1 or reg.count(old) != 1:
            sys.exit(f"ABORT: 앵커 매칭 BODY {body.count(old)} · 조회 프로시저 {reg.count(old)} (1 · 1 이어야 함) [{old.strip()[:60]}]")
        reg = reg.replace(old, new)
    new_body = body[:a] + reg + body[b:]
    assert new_body.count(MARK) == 2
    return new_body


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
    o, n = s["src"].split("\n"), new.split("\n")
    print("BUILD OK", fetched, "HOST", host, "LAST_DDL", s["last_ddl"], "lines", len(o), "->", len(n),
          "| 바뀐 줄", [(i + 1, x.strip()[:70]) for i, (x, y) in enumerate(zip(o, n)) if x != y])


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
