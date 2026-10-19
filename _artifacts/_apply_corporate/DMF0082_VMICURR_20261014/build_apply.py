"""DMF0082 조회 — VMI 메저 행에도 LOC 의 CURRENCY 를 표시 [E20261014-DMF0082VMICURR] (사내 ZIOUI1)

사용자 요청(2026-10-14): "DMF0082 에서 VMI 메저일 때도 CURRENCY LOC 에서 가져와서 같이 사용되고, CELL MERGE 되도록".

현상: 수량 메저(MKT_FCST · SCM_FCST · RTF 등)는 같은 키 LOC 행의 통화를 받아 CURRENCY 가 채워지는데(백필 MERGE),
  VMI 계열(MEASURE LIKE 'VMI%' — VMI_In_Req · VMI_Inv · VMI_DIO 등)만 두 군데서 빠져 항상 빈칸이었다.
    ① 백필 MERGE 의 `AND A.MEASURE NOT LIKE 'VMI%'` — LOC 통화를 받지 않음
    ② [E20260825-CURRNORM] 의 `MEASURE LIKE 'VMI%' OR …` — 값이 있어도 ' ' 로 강제
  그래서 같은 품목의 다른 메저 행과 CURRENCY 가 달라 화면의 셀 병합이 VMI 행에서 끊겼다.
  (AS-IS 도 VMI 는 IIF(MEASURE LIKE 'VMI%','',CURRENCY) 로 공백 — 이번 변경은 사용자 요청에 따른 의도적 변경)

보완: 위 두 가지 VMI 제외만 푼다. 통화 원천 · 키 · 비파괴 조건(빈 행만 채움) · 정규화 규칙은 다른 수량 메저와 같다.
  P_DMF0082_GET_MAIN_DATA         : 백필 MERGE 3곳(1차 9키 · 2차 8키 · 3차 5키) + CURRNORM 1곳
  P_DMF0082_GET_MAIN_DATA_CURRENT : 백필 MERGE 1곳 + CURRNORM 1곳
  ⛔ 손대지 않음: CURRENT 적재 단계의 `CASE WHEN A.MEASURE LIKE 'VMI%' THEN NULL ELSE A.CURRENCY END`(2곳)
     — VMI 행 자신의 원장 통화는 지금처럼 비우고, 그 빈칸을 LOC 통화로 채운다("LOC 에서 가져와서").
  조회용 임시 테이블의 표시값만 바뀐다. 원장 · 저장 SP · 단가 검증 무변경
  (수량 메저 저장 원장 DM_PLN_MKT_FCST 에는 CURRENCY 컬럼이 없다 — MKT_FCST 행과 같은 처지).

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
MARK = "[E20261014-DMF0082VMICURR]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"
NOTE = "VMI 도 LOC 통화 표시 (사용자 요청 2026-10-14)"

# (원문, 치환문, GET_MAIN_DATA 안 기대 횟수, GET_MAIN_DATA_CURRENT 안 기대 횟수)
EDITS = [
    # ① GET_MAIN_DATA 백필 MERGE 3곳 (1차 9키 · 2차 8키 CURRCELLPROD · 3차 5키 CURRSITEITEM)
    ("    WHERE  A.CURRENCY IS NULL\n"
     "    AND    A.MEASURE NOT LIKE 'VMI%'\n"
     "    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD;\n",
     "    WHERE  A.CURRENCY IS NULL\n"
     f"    --{MARK} {NOTE} — 원문: AND    A.MEASURE NOT LIKE 'VMI%'\n"
     "    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD;\n",
     3, 0),
    # ② GET_MAIN_DATA_CURRENT 백필 MERGE 1곳
    ("            AND   A.CURRENCY IS NULL                                   /* ISNULL(A.CURRENCY,'')='' → IS NULL (C-7) */\n"
     "            AND   A.MEASURE NOT LIKE 'VMI%';\n",
     "            AND   A.CURRENCY IS NULL                                   /* ISNULL(A.CURRENCY,'')='' → IS NULL (C-7) */\n"
     f"            --{MARK} {NOTE} — 원문: AND   A.MEASURE NOT LIKE 'VMI%';\n"
     "            ;\n",
     0, 1),
    # ③ CURRNORM — VMI 계열 공백 강제 제거 (두 프로시저 동일 문장)
    ("    --   VMI 계열은 AS-IS(IIF(MEASURE LIKE 'VMI%','',CURRENCY) · 백필 제외)와 동일하게 항상 공백.\n"
     "    AND    (   MEASURE LIKE 'VMI%'\n"
     "            OR CURRENCY IS NULL OR TRIM(CURRENCY) IS NULL OR TRIM(CURRENCY) = '/');\n",
     "    --   VMI 계열은 AS-IS(IIF(MEASURE LIKE 'VMI%','',CURRENCY) · 백필 제외)와 동일하게 항상 공백.\n"
     f"    --{MARK} {NOTE} — VMI 공백 강제를 풀어 백필된 LOC 통화를 보존한다(셀 병합).\n"
     "    --   원문: AND    (   MEASURE LIKE 'VMI%'\n"
     "    --               OR CURRENCY IS NULL OR TRIM(CURRENCY) IS NULL OR TRIM(CURRENCY) = '/');\n"
     "    AND    (   CURRENCY IS NULL OR TRIM(CURRENCY) IS NULL OR TRIM(CURRENCY) = '/');\n",
     1, 1),
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
    if "\r" in body:
        sys.exit("ABORT: BODY 원문에 CR 포함")
    p_main = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA\n")
    p_cur = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT")
    p_end = body.index("\nPROCEDURE P_DMF0082_GET_SPREAD_TITLE")
    main_seg, cur_seg = body[p_main:p_cur], body[p_cur:p_end]
    for old, new, n_main, n_cur in EDITS:
        tot, a, b = body.count(old), main_seg.count(old), cur_seg.count(old)
        if (a, b, tot) != (n_main, n_cur, n_main + n_cur):
            sys.exit(f"ABORT: 앵커 일치 MAIN {a}/{n_main} CURRENT {b}/{n_cur} 전체 {tot} — 원문이 바뀌었음\n{old}")
    for old, new, _, _ in EDITS:
        body = body.replace(old, new)
    # 결과 단언: 두 프로시저 구간에서 VMI 제외 조건이 남아 있지 않아야 한다 (CURRENT 적재 CASE 2곳만 남음)
    seg = body[body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA\n"):body.index("\nPROCEDURE P_DMF0082_GET_SPREAD_TITLE")]
    live = [l for l in seg.split("\n") if "VMI%" in l and not l.lstrip().startswith("--") and "/*" not in l]
    if len(live) != 2 or not all("THEN NULL ELSE A.CURRENCY END AS CURRENCY" in l for l in live):
        sys.exit("ABORT: 치환 후 잔존 VMI 조건이 기대(CURRENT 적재 CASE 2줄)와 다름:\n" + "\n".join(live))
    return body


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
