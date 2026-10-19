"""DMF0082 조회 — 화면 필수 표시 컬럼은 Column Setting 과 무관하게 항상 반환 [E20261013-DMF0082MANDRET] (사내 ZIOUI1)

사용자 신고(2026-10-13): AS From Site 를 "항상 보여주는 컬럼"으로 바꿨는데 컬럼은 보이고 값이 안 보인다.

원인: 화면은 필수 컬럼(메타 USER_SELECTABLE_FLAG='N' + VISIBLE_FLAG='Y')을 사용자 Column Set 저장 내역에 없어도 항상 표시한다.
  조회 SP 는 결과 컬럼 목록을 Column Set 저장 내역(SCM_MST_TITLESET_USER 'C')으로 만들고, 그와 무관하게 넣어 주는 것은
  저장 키 12컬럼([E20260822-KEYCOL])뿐이다. AS_FROM_SITE 는 거기에 없어 Column Set 에 넣지 않은 사용자에게는 값이 내려가지 않는다.
  (사내 실측: 81 · minyonglee1(저장 내역에 있음) = 결과에 AS_FROM_SITE 있음 / k0101(없음) = 없음)

보완: 저장 키 강제 추가 루프 바로 뒤에, 컬럼 메타의 필수 컬럼을 같은 방식으로 추가하는 루프를 넣는다.
  - 판정 = 화면과 같은 메타 규칙 (VALID_YN='Y' · USER_SELECTABLE_FLAG='N' · VISIBLE_FLAG='Y' · division 토큰 = [E20261012-DMF0082MANDCOL] 과 동일 식)
  - 최종 피벗 원천 임시 테이블에 실제로 있는 컬럼만 (없는 컬럼이 필수로 등록돼도 ORA-00904 가 나지 않게)
  - 이미 목록에 있으면 넣지 않는다 (멱등 — Column Set 에 넣은 사용자 · 저장 키 12컬럼은 결과 불변)
  대상 2곳: P_DMF0082_GET_MAIN_DATA(GT_DMF0082_MF_SP) · P_DMF0082_GET_MAIN_DATA_CURRENT(GTT_MF_SP). 기존 문장 무변경.

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
MARK = "[E20261013-DMF0082MANDRET]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"

# 앵커 = 저장 키 강제 추가 루프의 끝 5줄 (두 프로시저에 같은 문장으로 1회씩)
ANCHOR = (
    "        IF INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',' || K.C || ',') = 0 THEN\n"
    "            V_COLUMN  := V_COLUMN  || ', ' || K.C;\n"
    "            V_GROUPBY := V_GROUPBY || ', ' || K.C;\n"
    "        END IF;\n"
    "    END LOOP;\n"
)
GTT = ["GT_DMF0082_MF_SP", "GTT_MF_SP"]   # 1번째 = GET_MAIN_DATA / 2번째 = GET_MAIN_DATA_CURRENT 의 최종 피벗 원천


def block(gtt):
    return (
        "\n"
        f"    --{MARK} 화면 필수 표시 컬럼은 Column Setting 과 무관하게 항상 반환한다 (사용자 신고 2026-10-13).\n"
        "    --  화면은 필수 컬럼(메타 USER_SELECTABLE_FLAG='N' + VISIBLE_FLAG='Y')을 사용자 컬럼 저장 내역에 없어도 항상 표시한다.\n"
        "    --  위 루프는 저장 키 12컬럼만 보장하므로, 그 밖의 필수 컬럼은 저장 내역에 없는 사용자에게 값이 내려가지 않았다\n"
        "    --  (실측: AS_FROM_SITE 를 필수로 바꾼 뒤 컬럼은 보이고 값이 빈칸).\n"
        "    --  판정식 = [E20261012-DMF0082MANDCOL] 과 같은 메타 · division 토큰 규칙. 최종 피벗 원천에 실제로 있는 컬럼만 넣는다\n"
        "    --  (없는 컬럼이 필수로 등록돼도 ORA-00904 가 나지 않게). 이미 있으면 넣지 않는다(멱등).\n"
        "    FOR K IN ( SELECT C.COLUMN_NAME AS C\n"
        "                 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C\n"
        "                WHERE C.PROGRAM_ID  = VA_PROGRAM_ID\n"
        "                  AND C.SHEET_NAME  = VA_SHEET_NAME\n"
        "                  AND C.VALID_YN    = 'Y'\n"
        "                  AND C.USER_SELECTABLE_FLAG = 'N'\n"
        "                  AND C.VISIBLE_FLAG = 'Y'\n"
        "                  AND (C.DIVISION_ID IS NULL OR INSTR(',' || C.DIVISION_ID || ',', ',' || p_division_id || ',') > 0)\n"
        f"                  AND C.COLUMN_NAME IN ( SELECT T.COLUMN_NAME FROM USER_TAB_COLUMNS T WHERE T.TABLE_NAME = '{gtt}' )\n"
        "                ORDER BY C.SORT_ORDER_NO, C.COLUMN_NAME ) LOOP\n"
        "        IF INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',' || K.C || ',') = 0 THEN\n"
        "            V_COLUMN  := V_COLUMN  || ', ' || K.C;\n"
        "            V_GROUPBY := V_GROUPBY || ', ' || K.C;\n"
        "        END IF;\n"
        "    END LOOP;\n"
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
    n = body.count(ANCHOR)
    if n != 2:
        sys.exit(f"ABORT: 저장 키 루프 끝 앵커 일치 {n}회 (2회여야 함) — 원문이 바뀌었음")
    p1 = body.index(ANCHOR)
    p2 = body.index(ANCHOR, p1 + 1)
    cur_proc = body.index("\nPROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT")
    nxt_proc = body.index("\nPROCEDURE P_DMF0082_GET_SPREAD_TITLE")
    if not (p1 < cur_proc < p2 < nxt_proc):
        sys.exit("ABORT: 앵커 위치가 GET_MAIN_DATA / GET_MAIN_DATA_CURRENT 순서와 다름")
    for p in (p1, p2):   # 앵커가 저장 키 루프의 끝인지 확인
        if "CELL_PROD_SITE_ID,CURRENCY'" not in body[p - 700:p]:
            sys.exit("ABORT: 앵커 앞에 저장 키 목록이 없음")
    parts = body.split(ANCHOR)
    return parts[0] + ANCHOR + block(GTT[0]) + parts[1] + ANCHOR + block(GTT[1]) + parts[2]


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
