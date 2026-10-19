"""DMF0005 조회 — H · P 유무 판정을 별도 조인 없이 한 번에 계산 [E20261014-DMF0005SITECNT] (사내 ZIOUI1)

현상(2026-10-14): 클라우드 QA 에서 PKG_DMF0005 BODY 교체 뒤 DMF0005 조회가 끝나지 않음(40 = 18분, 82 · 81 은 더 김).
원인(QA SQL Monitor 실측 · 사내 재현):
  조회 문장의 SITE_CNT(사이트 · 프로젝트 · 팀 묶음별 H · P 건수) 구간이 결과 행마다 다시 실행된다
  (VIEW PUSHED PREDICATE — 40: 15,672회 × 품목 집계 17만 행 = 26억 행 읽기).
  QA 는 조회조건 값을 보지 않고 계획을 만들어(Peeked Binds 없음 · 사업부 행 수를 평균 15,930 으로 추정) 이 계획을 고른다.
  사내도 세션에서 _optim_peek_user_binds = FALSE · optimizer_adaptive_plans = FALSE 로 두면 같은 계획 · 2분 제한 초과로 재현된다.
  오늘 추가한 Partial Plan YN 2줄이 없는 원문도 같은 조건에서 똑같이 느리다 — 2줄의 내용이 아니라 문장 재파싱이 계기.

보완: SITE_CNT 를 따로 집계해 다시 조인하지 않고, BASE(원장 × 품목 집계)를 읽는 김에 묶음별 H · P 유무를 함께 구한다.
  BASE 에 1줄 추가 :  MAX(CASE WHEN IA.ITEM_TYPE IN ('H','P') THEN 1 ELSE 0 END)
                       OVER (PARTITION BY SI.DIVISION_ID, SI.SCM_SITE_ID, SI.PROJECT_CODE, NVL(SI.DEPT_ID,'/')) AS SC_CNT
  SITE_CNT 정의 · 최종 SELECT 의 SITE_CNT 조인 6줄은 주석 처리(원본 보존).
동등성 근거(구조):
  - SITE_CNT 와 BASE 는 같은 원장(SCM_MST_SITE_ITEM, 사업부 조건만) × 같은 품목 집계(ITEM_AGG, 같은 연결 조건)를 읽는다.
  - 묶음 키가 같다(사업부 · 사이트 · 프로젝트 · NVL(팀,'/')). BASE 의 SALES 사이트 조건은 사이트 단위라 묶음을 통째로 남기거나 뺀다.
  - 조회조건(팀 · 고객 · 사이트 · Active · 모델 · 프로젝트 · Owner)은 BASE 뒤(BF)에서 걸리므로 묶음 판정은 종전처럼 조건 적용 전 기준이다.
  - SC_CNT 는 "= 0 인가" 로만 쓰인다(81 계열 표시 대상 판정). 건수 대신 유무(1/0)로 바꿔도 판정이 같고,
    BASE 의 다른 조인이 행을 늘려도 MAX 라 값이 변하지 않는다.

  python build_apply.py build            # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성
  python build_apply.py apply            # FRESH-GATE 통과 시 BODY 적용 + 컴파일 확인
"""
import sys, os, re, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0005"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261014-DMF0005SITECNT]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0005_BODY.sql", "01_PKG_DMF0005_BODY.sql"

P_START = "PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION ("
P_END = "END P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION;"
NEW_COL = ("MAX(CASE WHEN IA.ITEM_TYPE IN ('H', 'P') THEN 1 ELSE 0 END) OVER (PARTITION BY SI.DIVISION_ID, SI.SCM_SITE_ID, SI.PROJECT_CODE, NVL(SI.DEPT_ID, '/')) AS SC_CNT"
           f"    -- 2026.10.14 {MARK} 같은 사이트 · 프로젝트 · 팀 묶음의 H · P 유무(1 / 0) — SITE_CNT 를 따로 집계해 다시 잇지 않고 여기서 함께 계산")
C_OLD = f"    -- 2026.10.14 {MARK} 원본"


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


def norm(s):
    return re.sub(r"\s+", " ", s.split("--")[0]).strip()


def transform(body):
    if MARK in body:
        sys.exit(f"ABORT: BODY 에 {MARK} 이미 존재 — 재적용 불필요")
    if "\r" in body:
        sys.exit("ABORT: BODY 원문에 CR 포함")
    if body.count(P_START) != 1 or body.count(P_END) != 1:
        sys.exit(f"ABORT: 프로시저 시작 {body.count(P_START)}회 · 끝 {body.count(P_END)}회")
    a = body.index(P_START)
    b = body.index(P_END, a)
    L = body[a:b].split("\n")
    N = [norm(x) for x in L]

    def find(text, start=0, expect=1):
        hits = [i for i in range(start, len(N)) if N[i] == text]
        if len(hits) != expect:
            sys.exit(f"ABORT: 앵커 [{text}] {len(hits)}곳 (기대 {expect})")
        return hits[0]

    # ① BASE 목록 끝(FROM SCM_MST_SITE_ITEM SI 바로 앞 줄) 뒤에 SC_CNT 1줄
    i_from = find("FROM SCM_MST_SITE_ITEM SI")
    i_last = i_from - 1
    if not N[i_last].startswith(", "):
        sys.exit(f"ABORT: BASE 목록 마지막 줄 형태가 다름 [{L[i_last].strip()}]")
    indent = re.match(r"[ \t]*", L[i_last]).group(0)
    # ② SITE_CNT 정의 : "SITE_CNT AS (" ~ 그 닫는 ")" (다음 유효 줄이 SELECT = 최종 SELECT)
    i_cte = find("SITE_CNT AS (")
    i_sel = next(i for i in range(i_cte + 1, len(N)) if N[i] == "SELECT" and N[i - 1] in ("", ")") or N[i] == "SELECT" and L[i - 1].lstrip().startswith("/*"))
    i_close = max(i for i in range(i_cte, i_sel) if N[i] == ")")
    i_prev = max(i for i in range(0, i_cte) if N[i] not in ("",) and not L[i].lstrip().startswith(("--", "/*")))
    if N[i_prev] != "),":
        sys.exit(f"ABORT: SITE_CNT 앞 CTE 의 닫는 줄이 '),' 가 아님 [{L[i_prev].strip()}]")
    if sum(1 for i in range(i_cte, i_close + 1) if "SITE_CNT" in N[i]) != 1 or not any("ITEM_AGG IA9" in N[i] for i in range(i_cte, i_close + 1)):
        sys.exit("ABORT: SITE_CNT 정의 범위가 예상과 다름")
    # ③ 최종 SELECT 의 SITE_CNT 조인 6줄
    j = [find(", NVL(SC.CNT, 0) AS SC_CNT", i_sel), find(", SITE_CNT SC", i_sel), find("WHERE SC.DIVISION_ID(+) = B.DIVISION_ID", i_sel),
         find("AND SC.SCM_SITE_ID(+) = B.SCM_SITE_ID", i_sel), find("AND SC.PROJECT_CODE(+) = B.PROJECT_CODE", i_sel),
         find("AND SC.DEPT_ID(+) = NVL(B.DEPT_ID, '/')", i_sel)]
    if j != sorted(j) or j[-1] - j[0] != 6 or N[j[0] + 1] != "FROM BF B" or N[j[-1] + 1] != ") BF":
        sys.exit(f"ABORT: 최종 SELECT 의 SITE_CNT 조인 줄 배치가 예상과 다름 {j}")
    # BASE 안의 SC 는 SCM_MST_SITE_CUSTOMER 별칭(다른 것) — SITE_CNT 의 SC 는 최종 SELECT(i_sel 이후)에서만 본다
    used = [i for i in range(len(N)) if re.search(r"\bSITE_CNT\b|\bSC_CNT\b", N[i]) or (i >= i_sel and re.search(r"\bSC\.", N[i]))]
    allowed = set(range(i_cte, i_close + 1)) | set(j) | {i for i in range(j[-1], len(N)) if "BF.SC_CNT = 0" in N[i]}
    if set(used) - allowed:
        sys.exit(f"ABORT: SITE_CNT / SC / SC_CNT 를 쓰는 줄이 더 있음 {[L[i].strip() for i in sorted(set(used) - allowed)]}")

    out = []
    for i, line in enumerate(L):
        if i == i_prev:
            out.append(line.replace("),", ")", 1) + f"    -- 2026.10.14 {MARK} 뒤따르던 SITE_CNT 정의를 쓰지 않아 쉼표 제거")
        elif i_cte <= i <= i_close:
            out.append(line if line.lstrip().startswith("--") or not line.strip() else "-- " + line + (C_OLD if i == i_cte else ""))
        elif i in j:
            out.append("-- " + line + C_OLD)
        else:
            out.append(line)
        if i == i_last:
            out.append(f"{indent}, {NEW_COL}")
    reg = "\n".join(out)
    assert reg.count(NEW_COL) == 1 and len(out) == len(L) + 1
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
    o, n = s["src"].split("\n"), new.split("\n")
    print("BUILD OK", fetched, "HOST", host, "LAST_DDL", s["last_ddl"], "lines", len(o), "->", len(n))
    import difflib
    for d in difflib.unified_diff(o, n, lineterm="", n=0):
        if d.startswith(("+", "-")) and not d.startswith(("+++", "---")):
            print("  ", d[:210])


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
