"""CELL_PROD_SITE_ID 빈값 = '-' (AS-IS 파리티) 로직 보완 [E20261027-CELLPRODDASH] (사내 ZIOUI1)

사용자 확인(2026-10-27): AS-IS 는 전 사업부 CELL_PROD_SITE_ID 빈값을 '-' 로 처리한다 (AS-IS LGCE_SCMDEV 실측:
  원장 DEFAULT '-' · DMF0082 GET 81 계획 arm '-' · DMF0003 81 저장 '-' · PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING ELSE '-' · 데이터 '/' 0건).
  TO-BE 는 원장 DEFAULT '/' + 실적 매핑 ELSE '/' (2026.10.11 변경) 라 실적 행만 '/' → 같은 키 계획('-')과 DMF0082 에서 2줄 (클라우드 81 BMW_US_SPA).

보완 (CELL_PROD_SITE_ID 한 컬럼만):
  1) PKG_DMF0082 BODY — GET_MAIN_DATA · GET_MAIN_DATA_CURRENT 의 [E20261013-DMF0082AFSSHARE] 직전에 조회용 임시 테이블 정규화 1문장씩
     ('/' · 공백 → '-'). 원장 정리 전후 모두 같은 키를 한 줄로 보이게 하는 방어.
  2) PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING — CELL_PROD_SITE_ID CASE 의 ELSE '/' 3곳(SELECT 2 · GROUP BY 1) → '-' (AS-IS L934 · L1158).
  기존 다른 문장 무변경.

  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP_* / 01_* 생성
  python build_apply.py apply   # FRESH-GATE 통과 시 적용 + 컴파일 확인
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261027-CELLPRODDASH]"

PKG_ANCHOR = "    /* [E20261013-DMF0082AFSSHARE]"


def pkg_block(gtt):
    return (
        f"    /* {MARK} Cell Prod Site 빈값 표기 통일 '/' → '-' (사용자 확인 2026-10-27).\n"
        "       AS-IS 는 전 사업부 빈값 = '-' (원장 DEFAULT '-' · 81 계획 arm 리터럴 '-' · 40 은 '-' = Common 코드).\n"
        "       TO-BE 원장 DEFAULT '/' · 실적 매핑 ELSE '/' 기간에 적재된 실적 행이 '/' 라 같은 키의 계획('-')과 줄이 갈렸다\n"
        "       (클라우드 81 BMW_US_SPA · Cell Prod Site 를 화면에 표시한 계정). 원장 정리와 별개로 조회 결과에 '/' · 공백이 섞여도 '-' 로 맞춘다.\n"
        "       조회용 임시 테이블의 표시값만 바꾼다 — 원장 · 저장 무변경. */\n"
        f"    UPDATE SCM_MGR.{gtt}\n"
        "    SET    CELL_PROD_SITE_ID = '-'\n"
        "    WHERE  CELL_PROD_SITE_ID = '/' OR (CELL_PROD_SITE_ID IS NOT NULL AND TRIM(CELL_PROD_SITE_ID) IS NULL);\n"
        "\n"
    )


MAP_REPL = [  # (원문 줄, 교체 줄, 기대 건수)
    ("                     ELSE '/' END AS CELL_PROD_SITE_ID    --  2026.10.11 AJS\n",
     f"                     ELSE '-' END AS CELL_PROD_SITE_ID    --  {MARK} 2026.10.27 AS-IS ELSE '-' 복원 (2026.10.11 AJS '/')\n", 2),
    ("                      ELSE '/' END;    --  2026.10.11 AJS\n",
     f"                      ELSE '-' END;    --  {MARK} 2026.10.27 AS-IS ELSE '-' 복원 (2026.10.11 AJS '/')\n", 1),
]

OBJS = [("PKG_DMF0082", "PACKAGE BODY", "PKG_DMF0082_BODY"),
        ("PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING", "PROCEDURE", "PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING")]


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur, name, typ):
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=name, t=typ)
    ddl = cur.fetchone()[0]
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=name, t=typ)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def transform(name, body):
    if MARK in body:
        sys.exit(f"ABORT: {name} 에 {MARK} 이미 존재")
    if "\r" in body:
        sys.exit(f"ABORT: {name} 원문에 CR 포함")
    if name == "PKG_DMF0082":
        if body.count(PKG_ANCHOR) != 2:
            sys.exit(f"ABORT: PKG 앵커 {body.count(PKG_ANCHOR)}회 (2 기대)")
        p1 = body.index(PKG_ANCHOR); p2 = body.index(PKG_ANCHOR, p1 + 1)
        cs = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT"); ce = body.index("\nPROCEDURE P_DMF0082_GET_SPREAD_TITLE")
        if not (p1 < cs < p2 < ce):
            sys.exit("ABORT: PKG 앵커 위치가 GET_MAIN_DATA / CURRENT 순서와 다름")
        if "MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T" not in body[p1:p1 + 1500] or "MERGE INTO SCM_MGR.GTT_MF_SP T" not in body[p2:p2 + 1500]:
            sys.exit("ABORT: 앵커 뒤 AFSSHARE MERGE 대상 GTT 불일치")
        return body[:p1] + pkg_block("GT_DMF0082_MF_SP") + body[p1:p2] + pkg_block("GTT_MF_SP") + body[p2:]
    new = body
    for old, rep, n in MAP_REPL:
        if new.count(old) != n:
            sys.exit(f"ABORT: {name} 대상 줄 {new.count(old)}회 ({n} 기대): {old.strip()}")
        new = new.replace(old, rep)
    return new


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    st = {}
    with connect() as con:
        cur = con.cursor()
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI'), SYS_CONTEXT('USERENV','SERVER_HOST') FROM dual")
        fetched, host = cur.fetchone()
        for name, typ, fn in OBJS:
            s = read_source(cur, name, typ)   # 기준본 = 지금 ALL_SOURCE 에서 새로 조회한 원문
            new = transform(name, s["src"])
            stamp = f"-- SOURCE-FRESH: SCM_MGR.{name} {typ} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
            open(os.path.join(HERE, f"00_BACKUP_{fn}.sql"), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(s["src"]) + "/\n")
            open(os.path.join(HERE, f"01_{fn}.sql"), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
            st[name] = {"typ": typ, "fn": fn, "last_ddl": s["last_ddl"], "md5": s["md5"]}
            print("BUILD", name, "LAST_DDL", s["last_ddl"], "lines", s["src"].count("\n"), "->", new.count("\n"), "marker", new.count(MARK))
    st["_"] = {"fetched": fetched, "host": host}
    json.dump(st, open(STATE, "w"), indent=1)


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
        if host != st["_"]["host"]:
            sys.exit(f"ABORT: 접속 DB 가 build 시점과 다름 ({st['_']['host']} → {host})")
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == build 시점 기준본 (하나라도 다르면 전부 중단)
        for name, typ, fn in OBJS:
            now = read_source(cur, name, typ)
            if now["md5"] != st[name]["md5"] or now["last_ddl"] != st[name]["last_ddl"]:
                sys.exit(f"FRESH-GATE FAIL {name}: build {st[name]['last_ddl']} → now {now['last_ddl']}")
        print("FRESH-GATE PASS", host)
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        inv0 = cur.fetchone()[0]
        for name, typ, fn in OBJS:
            tobe = strip(open(os.path.join(HERE, f"01_{fn}.sql"), encoding="utf-8").read())
            cur.execute(tobe)
            after = read_source(cur, name, typ)
            cur.execute("SELECT status FROM user_objects WHERE object_name=:n AND object_type=:t", n=name, t=typ)
            stt = cur.fetchone()[0]
            cur.execute("SELECT line, position, text FROM user_errors WHERE name=:n AND type=:t ORDER BY sequence", n=name, t=typ)
            errs = cur.fetchall()
            print("APPLIED", name, stt, "LAST_DDL", after["last_ddl"], "DB==TOBE", after["src"].rstrip() == tobe[len("CREATE OR REPLACE "):].rstrip(),
                  "marker", after["src"].count(MARK), "errors", len(errs))
            for e in errs: print("   ", e)
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        print("SCM_MGR INVALID", inv0, "->", cur.fetchone()[0])


if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
