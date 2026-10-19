"""DMF0082 조회 — MKT_FCST 의 AS From Site 를 같은 키의 다른 메저 행에도 표시 [E20261013-DMF0082AFSSHARE] (사내 ZIOUI1)

사용자 요청(2026-10-13): "MKT_FCST 에 AS_FROM_SITE 에 값이 있으며 동일 KEY 기준에 AS_FROM_SITE 가 같이 보여지고, CELL MERGE 가 발생하도록".

현상: AS From Site 는 수요 원장(ATTRIBUTE10)에만 저장된다. 판가(LOC·KRW·USD) · 실적 · 계산 메저 행은 빈칸으로 내려가
  같은 품목이어도 MKT_FCST 행과 값이 달라 화면의 셀 병합이 끊긴다 (AS-IS 도 같다 — 판가 행은 '' 고정).

보완: 최종 피벗 원천 임시 테이블에서 AS From Site 빈값 정규화([E20260825-AFSBLANK]) 바로 뒤에 MERGE 1문장을 넣는다.
  - 원천  = 같은 조회 결과 안의 MKT_FCST 행 중 AS From Site 값이 있는 것 (빈칸 · '-' · '/' 는 값 없음으로 본다)
  - 키    = Division · Project · End Customer · Sales Site · Model · Customs Handbook · Fcst Type · Incoterms · Plant Site · Cell Prod Site
  - 대상  = 같은 키의 MKT_FCST 가 아닌 메저 행 중 AS From Site 가 비어 있는 것 (자기 값이 있는 행 · MKT_FCST 행은 건드리지 않는다)
  - 한 키의 MKT_FCST 에 서로 다른 값이 둘 이상이면 어느 쪽인지 정할 수 없어 채우지 않는다
  - AS From Site 가 조회 결과 컬럼에 있을 때만 실행 (그 컬럼이 없는 조회 — 예: 40 — 는 문장 자체를 건너뛴다)
  조회용 임시 테이블의 표시값만 바꾼다. 원장 · 저장 · 단가 검증 무변경.
  대상 2곳: P_DMF0082_GET_MAIN_DATA(GT_DMF0082_MF_SP) · P_DMF0082_GET_MAIN_DATA_CURRENT(GTT_MF_SP).

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
MARK = "[E20261013-DMF0082AFSSHARE]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"
GTT = ["GT_DMF0082_MF_SP", "GTT_MF_SP"]   # 1번째 = GET_MAIN_DATA / 2번째 = GET_MAIN_DATA_CURRENT 의 최종 피벗 원천
KEYS = ["DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP", "FCST_TYPE", "INCOTERMS",
        "PLANT_SITE_ID", "CELL_PROD_SITE_ID"]


def anchor(gtt):   # [E20260825-AFSBLANK] 빈값 정규화 문장 (프로시저마다 1회)
    return (f"    UPDATE SCM_MGR.{gtt}\n"
            "    SET    AS_FROM_SITE = ' '\n"
            "    WHERE  AS_FROM_SITE IS NULL;\n")


def merge_sql(gtt, ind="        "):
    on = ("\n" + ind + "AND ").join(f"NVL(T.{k}, '/') = NVL(S.{k}, '/')" for k in KEYS)
    return (
        f"{ind}MERGE INTO SCM_MGR.{gtt} T\n"
        f"{ind}USING ( SELECT {', '.join(KEYS[:5])}\n"
        f"{ind}             , {', '.join(KEYS[5:])}\n"
        f"{ind}             , MAX(AS_FROM_SITE) AS AS_FROM_SITE\n"
        f"{ind}        FROM   SCM_MGR.{gtt}\n"
        f"{ind}        WHERE  MEASURE = 'MKT_FCST'\n"
        f"{ind}        AND    RTRIM(AS_FROM_SITE, ' -/') IS NOT NULL\n"
        f"{ind}        GROUP BY {', '.join(KEYS[:5])}\n"
        f"{ind}               , {', '.join(KEYS[5:])}\n"
        f"{ind}        HAVING COUNT(DISTINCT AS_FROM_SITE) = 1 ) S\n"
        f"{ind}ON (    {on} )\n"
        f"{ind}WHEN MATCHED THEN\n"
        f"{ind}UPDATE SET T.AS_FROM_SITE = S.AS_FROM_SITE\n"
        f"{ind}WHERE  T.MEASURE <> 'MKT_FCST'\n"
        f"{ind}AND    RTRIM(T.AS_FROM_SITE, ' -/') IS NULL;\n"
    )


def block(gtt):
    return (
        "\n"
        f"    /* {MARK} MKT_FCST 의 AS From Site 를 같은 키의 다른 메저 행에도 표시 (사용자 요청 2026-10-13).\n"
        "       AS From Site 는 수요 원장(ATTRIBUTE10)에만 저장된다. 판가 · 실적 · 계산 메저 행은 빈칸이라 같은 품목이어도\n"
        "       MKT_FCST 행과 값이 달라 화면의 셀 병합이 끊겼다 (AS-IS 도 판가 행은 '' 고정 — 의도적 변경).\n"
        "       원천 = 이 조회 결과의 MKT_FCST 행 중 값이 있는 것(빈칸 · '-' · '/' 는 값 없음).\n"
        "       대상 = 같은 키(그리드 행 식별 10컬럼)의 MKT_FCST 가 아닌 행 중 비어 있는 것 — 자기 값이 있는 행은 그대로 둔다.\n"
        "       한 키의 MKT_FCST 에 값이 둘 이상이면 채우지 않는다. 결과 컬럼에 AS_FROM_SITE 가 없으면 건너뛴다.\n"
        "       조회용 임시 테이블의 표시값만 바꾼다 — 원장 · 저장 · 단가 검증 무변경. */\n"
        "    IF INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',AS_FROM_SITE,') > 0 THEN\n"
        + merge_sql(gtt) +
        "    END IF;\n"
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
    cur_proc = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT")
    nxt_proc = body.index("\nPROCEDURE P_DMF0082_GET_SPREAD_TITLE")
    pos = []
    for g in GTT:
        a = anchor(g)
        if body.count(a) != 1:
            sys.exit(f"ABORT: {g} 빈값 정규화 앵커 일치 {body.count(a)}회 (1회여야 함) — 원문이 바뀌었음")
        pos.append(body.index(a))
    if not (pos[0] < cur_proc < pos[1] < nxt_proc):
        sys.exit("ABORT: 앵커 위치가 GET_MAIN_DATA / GET_MAIN_DATA_CURRENT 순서와 다름")
    for g in GTT:
        a = anchor(g)
        body = body.replace(a, a + block(g))
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
