"""DMF0082 조회 — 필수 컬럼은 '숨긴 컬럼' 으로 보지 않는다 [E20261012-DMF0082MANDCOL] (사내 ZIOUI1)

사용자 신고(2026-10-12, 클라우드): k0101 로 조회 시 Cell Prod Site HQ06-A 에 LOC 가 안 나온다 (minyonglee1 은 나옴).
  Column Set 을 Default 로 저장하면 나온다. "이전에도 Cell Prod Site 는 화면에 표시되고 있었다."

원인: 화면과 SP 의 '숨김' 판정 불일치.
  - 화면(FE applyLayoutToColumns, 2026-09-03): 사용자가 숨길 수 없는 필수 컬럼(메타 USER_SELECTABLE_FLAG='N' + VISIBLE_FLAG='Y')은
    사용자 컬럼 저장 내역(SCM_MST_TITLESET_USER 'C')에 없어도 **항상 표시**한다.
  - SP([E20260918-KEYCOLGRAIN]/[KEYCOLGRAIN2]): 저장 내역에 행이 없으면 '숨김' 으로 보고 메저별 대표값 하나로 통일한다.
  ⇒ 저장 내역에 CELL_PROD_SITE_ID 가 없는 사용자는 화면에 컬럼이 보이는데도 LOC/KRW/USD 가 한 사이트로 합쳐진다
     (클라우드 실측 V02/V04: 판가 HQ06-A 888 + NJ01-A 777 → NJ01-A 한 줄 832.5, 수요는 HQ06-A).

정정(사용자 승인 A안, 2026-10-12): SP 의 숨김 판정 2곳에, 저장 내역에 없더라도 **메타상 필수 컬럼이면 표시 중으로 본다** 를 추가.
  판정식 = 화면 컬럼 메타 조회(PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST)와 같은 division 토큰 규칙
           + DMF0002_GET_TITLESET_POPUP 의 필수 판정(USER_SELECTABLE_FLAG='N' AND VISIBLE_FLAG='Y').
  기존 문장은 한 글자도 바꾸지 않는다 (판정 SELECT 와 IF 사이에 보정 블록 삽입 2건).

사용:
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
MARK = "[E20261012-DMF0082MANDCOL]"
F_BAK, F_NEW = "00_BACKUP_PKG_DMF0082_BODY.sql", "01_PKG_DMF0082_BODY.sql"


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


def fix_block(col, first):
    head = f"""    --{MARK} 필수 컬럼은 '숨긴 컬럼' 이 아니다 (사용자 신고 2026-10-12 · 승인 A안).
    --  화면은 사용자가 숨길 수 없는 필수 컬럼(메타 USER_SELECTABLE_FLAG='N' + VISIBLE_FLAG='Y')을 사용자 컬럼 저장 내역
    --  (SCM_MST_TITLESET_USER 'C')에 없어도 항상 표시한다. 저장 내역만 보면 '숨김' 으로 오판해 화면에 보이는 컬럼의 값을
    --  대표값 하나로 합친다 — 클라우드 실측: 판가 LOC HQ06-A 888 / NJ01-A 777 이 NJ01-A 한 줄(832.5)로 합쳐져
    --  HQ06-A 에 LOC 가 안 나옴 (Column Set 을 다시 저장해 행이 생기면 정상).
    --  판정식 = 화면 컬럼 메타 조회(PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST)와 같은 division 토큰 규칙.
""" if first else f"""    --{MARK} 필수 컬럼은 '숨긴 컬럼' 이 아니다 — 위 CELL_PROD_SITE_ID 와 같은 보정.
"""
    return head + f"""    IF V_USER_COL_CNT = 0 THEN
        SELECT COUNT(*)
          INTO V_USER_COL_CNT
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
         WHERE C.PROGRAM_ID  = VA_PROGRAM_ID
           AND C.SHEET_NAME  = VA_SHEET_NAME
           AND C.COLUMN_NAME = '{col}'
           AND C.VALID_YN    = 'Y'
           AND C.USER_SELECTABLE_FLAG = 'N'
           AND C.VISIBLE_FLAG = 'Y'
           AND (C.DIVISION_ID IS NULL OR INSTR(',' || C.DIVISION_ID || ',', ',' || p_division_id || ',') > 0);
    END IF;

"""


def rep1(src, old, new, what):
    n = src.count(old)
    if n != 1:
        sys.exit(f"ABORT: {what} 일치 {n}회 (1회여야 함) — 원문이 바뀌었거나 이미 반영됨")
    return src.replace(old, new)


def transform(body):
    if MARK in body:
        sys.exit(f"ABORT: BODY 에 {MARK} 이미 존재 — 재적용 불필요")
    if "\r" in body:
        sys.exit("ABORT: BODY 원문에 CR 포함")
    old1 = ("       AND U.COLUMN_NAME = 'CELL_PROD_SITE_ID';\n\n"
            "    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만 (표시 중이면 AS-IS 파리티 유지)\n")
    new1 = ("       AND U.COLUMN_NAME = 'CELL_PROD_SITE_ID';\n\n" + fix_block("CELL_PROD_SITE_ID", True) +
            "    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만 (표시 중이면 AS-IS 파리티 유지)\n")
    old2 = ("       AND U.COLUMN_NAME = 'PLANT_SITE_ID';\n\n"
            "    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만\n")
    new2 = ("       AND U.COLUMN_NAME = 'PLANT_SITE_ID';\n\n" + fix_block("PLANT_SITE_ID", False) +
            "    IF V_USER_COL_CNT = 0 THEN   -- 화면에서 숨긴 컬럼일 때만\n")
    out = rep1(body, old1, new1, "KEYCOLGRAIN(CELL_PROD_SITE_ID) 판정")
    out = rep1(out, old2, new2, "KEYCOLGRAIN2(PLANT_SITE_ID) 판정")
    return out


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
          "marker", new.count(MARK))


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
