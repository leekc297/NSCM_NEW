"""DMF0005 조회 — SITE_CNT 행별 재실행 차단 힌트 1개 [E20261014-DMF0005NOPUSH] (사내 ZIOUI1) · 힌트 사용자 승인 2026-10-14

현상(2026-10-14): 클라우드 QA 에서 PKG_DMF0005 BODY 교체 뒤 DMF0005 조회가 끝나지 않음(40 = 18분, 82 · 81 은 더 김).
원인(QA SQL Monitor 실측 · 사내 재현):
  최종 SELECT 의 SITE_CNT(사이트 · 프로젝트 · 팀 묶음별 H · P 건수) 조인에 조인 조건이 밀려 들어가(VIEW PUSHED PREDICATE)
  결과 행마다 SITE_CNT 가 다시 실행된다 — 40: 15,672회 × 품목 집계 17만 행 = 26억 행 읽기.
  QA 는 조회조건 값을 보지 않고 계획을 만들어(Peeked Binds 없음 · 사업부 행 수를 평균으로 추정) 이 계획을 고른다.
  사내도 세션에서 _optim_peek_user_binds = FALSE · optimizer_adaptive_plans = FALSE 로 두면 같은 계획 · 2분 제한 초과(40 · 82 · 81).
  Partial Plan YN 2줄이 없는 원문도 같은 조건에서 똑같이 느리다 — 2줄의 내용이 아니라 문장 재파싱이 계기.
검토 순서(hook #129): ①구조 변경(SITE_CNT 를 BASE 분석함수로 합침) 시험 → 품목 집계가 대신 행마다 재실행되어 사내 기본 설정에서도 느려짐 · 폐기
  ②SARGable — 원인 조인이 10-08 모델 대소문자 · 끝 공백 무시 연결(함수 씌운 조인)이라 동작을 바꾸지 않고는 불가
  ③인덱스 — 대상 SCM_ITEM_M 은 FP_MGR 소유 · 함수 기반 인덱스 필요 → 즉시 조치 불가
  ④통계 — QA 는 바인드 값을 보지 않는 설정이라 통계를 다시 모아도 같은 계획 가능 → ⑤힌트(사용자 승인)
보완: 최종 SELECT 안쪽 `SELECT B.*, NVL(SC.CNT, 0) AS SC_CNT FROM BF B, SITE_CNT SC …` 의 SELECT 에 /*+ NO_PUSH_PRED(SC) */ 1개.
  SITE_CNT 는 한 번 계산한 뒤 해시 조인으로 붙는다. 결과 값에는 영향 없음(동등성 시나리오 대조).
  QA 조건 모사 측정: 40 0.96s · 82 1.53s · 81 1.71s · 81_UC 0.23s (현재 패키지 = 셋 다 2분 초과).

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
MARK = "[E20261014-DMF0005NOPUSH]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0005_BODY.sql", "01_PKG_DMF0005_BODY.sql"

P_START = "PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION ("
P_END = "END P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION;"
OLD = "        SELECT\n              B.*\n            , NVL(SC.CNT, 0) AS SC_CNT\n"
NEW = ("        SELECT /*+ NO_PUSH_PRED(SC) */    -- 2026.10.14 " + MARK
       + " SITE_CNT 를 행마다 다시 실행하지 않고 한 번 계산해 붙인다(클라우드 QA 조회 미종료 대응 · 힌트 사용자 승인)\n"
       + "              B.*\n            , NVL(SC.CNT, 0) AS SC_CNT\n")


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
    if "\r" in body or "\t" in body[body.index(P_START):body.index(P_END)]:
        sys.exit("ABORT: 조회 프로시저 원문에 CR 또는 탭 포함")
    if body.count(P_START) != 1 or body.count(P_END) != 1:
        sys.exit(f"ABORT: 프로시저 시작 {body.count(P_START)}회 · 끝 {body.count(P_END)}회")
    a, b = body.index(P_START), body.index(P_END)
    reg = body[a:b]
    if body.count(OLD) != 1 or reg.count(OLD) != 1:
        sys.exit(f"ABORT: 앵커 매칭 BODY {body.count(OLD)} · 조회 프로시저 {reg.count(OLD)} (1 · 1 이어야 함)")
    new = body[:a] + reg.replace(OLD, NEW) + body[b:]
    assert new.count(MARK) == 1 and new.count("NO_PUSH_PRED") == body.count("NO_PUSH_PRED") + 1
    return new


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
          "| 바뀐 줄", [(i + 1, x.strip()[:90]) for i, (x, y) in enumerate(zip(o, n)) if x != y])


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
