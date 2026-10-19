"""DMF0074 Excel Upload — 동적 컬럼(금속 7종 Key/Period/Contract/Change/Metal Index) 공란 = 오류 아님 (사내 ZIOUI1)

사용자 지시(2026-10-01): "DMF0074 의 경우 UPLOAD 시 동적 COLUMN에 값이 없어도 오류가 아닌 정상으로 처리되도록 해주세요."
  템플릿(P_DMF0074_GET_METAL_LINK_TEMPLATE)은 동적 컬럼 49개를 전부 빈칸으로 내려준다(Metal Link=Y / Exception=N).

변경 [E20261001-EMPTYDYN] — P_DMF0074_EXCEL_UPLOAD 한정
  1) 검증 비활성 8블록 (AS-IS 동일 검증이나 사용자 지시로 해제)
     - 'NULL APPLY PRICE TYPE CODE.'  (Key 7종 전부 공란)
     - 'NULL Ni/Co/Li2CO3/LIOH/Al/Mn/Cu : '  (Key 있음 + Period/Contract/Change/Metal Index 중 공란)
     유지: 'NEED EMPTY VALUE'(Key 공란인데 값 있음) · 숫자/음수/0~12/From>To (값이 있을 때만 검사하는 식이라 공란 무관)
  2) 3-7 합치기: Key(APPLY_PRICE_TYPE) 기준 나머지 5 UNPIVOT GTT INNER JOIN → LEFT JOIN
     (UNPIVOT 은 NULL 을 버리므로 한 칸만 비어도 그 금속 행 전체가 조용히 탈락 → SAVE_VERIFY 허위 실패)
     FROM/TO_PERIOD 는 원장 NOT NULL(DEFAULT ON NULL '-' — MERGE UPDATE 에는 미적용) → NVL(x,'-') 명시.
     원장 기존 '-' 12,214행 = 동일 관례 · 소비처 PR_DM_BPS_METAL_LINK_S / PR_DM_METAL_LINK_CUTOFF 는 통과만(TO_NUMBER 없음).
  Key 전부 공란 행 = 적재 대상 0 → NOLOADGUARD 후보 0 → SUCCESS (원장 변경 없음).

사용:
  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성 (치환 지점 개수 assert)
  python build_apply.py apply   # FRESH-GATE 통과 시 적용 + 컴파일 확인
"""
import sys, os, re, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0074"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261001-EMPTYDYN]"

MSGS = ["NULL APPLY PRICE TYPE CODE.", "NULL Ni : ", "NULL Co : ", "NULL Li2CO3 : ",
        "NULL LIOH : ", "NULL Al : ", "NULL Mn : ", "NULL Cu : "]
JOINS = ["FROM_PERIOD", "TO_PERIOD", "CONTRACT_UNIT", "METAL_APPLY", "METAL_REQR"]


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


def transform(src):
    if MARK in src:
        sys.exit(f"ABORT: {MARK} 이미 존재 — 재적용 불필요")
    up = src.find("PROCEDURE P_DMF0074_EXCEL_UPLOAD")
    if up < 0 or src.count("PROCEDURE P_DMF0074_EXCEL_UPLOAD") != 1:
        sys.exit("ABORT: P_DMF0074_EXCEL_UPLOAD 위치 특정 불가")

    # 1) 검증 8블록 비활성 — 메시지 직후 첫 WHERE UPLOAD_STATUS_CODE = 'UPLOAD' 줄 뒤에 AND 1 = 0
    for m in MSGS:
        pat = re.compile(r"MESSAGE_TEXT\s*=\s*'" + re.escape(m) + r"'.*?\n([ \t]*)WHERE\s+UPLOAD_STATUS_CODE\s*=\s*'UPLOAD'[^\n]*\n", re.S)
        hits = [h for h in pat.finditer(src) if h.start() > up]
        if len(hits) != 1:
            sys.exit(f"ABORT: '{m}' 블록 일치 {len(hits)}회 (1회여야 함)")
        h = hits[0]
        if h.end() - h.start() > 1500:
            sys.exit(f"ABORT: '{m}' 블록 범위 비정상 {h.end() - h.start()}자")
        ind = h.group(1)
        ins = (f"{ind}AND 1 = 0 /*{MARK} 사용자 지시 2026-10-01: 동적 컬럼(금속) 공란 = 오류 아님 → 본 검증 해제 (AS-IS 동일 검증)*/\n")
        src = src[:h.end()] + ins + src[h.end():]

    # 2) 3-7 합치기 INNER → LEFT JOIN
    for j in JOINS:
        old = f"INNER JOIN SCM_MGR.GT_DM74_TMP_{j} {j}\n"
        n = src.count(old)
        if n != 1:
            sys.exit(f"ABORT: '{old.strip()}' 일치 {n}회 (1회여야 함)")
        src = src.replace(old, f"LEFT JOIN SCM_MGR.GT_DM74_TMP_{j} {j} /*{MARK} INNER→LEFT: 칸 공란이어도 금속 행 유지*/\n")

    # 3) FROM/TO_PERIOD NVL '-' (원장 NOT NULL)
    old = "              ,FROM_PERIOD.FROM_PERIOD\n              ,TO_PERIOD.TO_PERIOD\n"
    n = src.count(old)
    if n != 1:
        sys.exit(f"ABORT: FROM/TO_PERIOD 선택 목록 일치 {n}회 (1회여야 함)")
    src = src.replace(old,
                      f"              --{MARK} LEFT JOIN 공란 → 원장 NOT NULL(FROM/TO_PERIOD_YYYYMM, DEFAULT ON NULL '-' 는 MERGE UPDATE 미적용) 보호\n"
                      "              ,NVL(FROM_PERIOD.FROM_PERIOD, '-') AS FROM_PERIOD\n"
                      "              ,NVL(TO_PERIOD.TO_PERIOD, '-') AS TO_PERIOD\n")
    return src


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = read_source(cur)
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM dual")
        fetched = cur.fetchone()[0]
    src = s["src"]
    new = transform(src)
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
    open(os.path.join(HERE, "00_BACKUP_PKG_DMF0074_BODY.sql"), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(src) + "/\n")
    open(os.path.join(HERE, "01_PKG_DMF0074_BODY.sql"), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
    json.dump({"last_ddl": s["last_ddl"], "md5": s["md5"], "fetched": fetched}, open(STATE, "w"), indent=1)
    print("BUILD OK", fetched, s["last_ddl"], s["md5"], "lines", src.count("\n"), "->", new.count("\n"),
          "marker", new.count(MARK))


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS")
        cur.execute(strip(open(os.path.join(HERE, "01_PKG_DMF0074_BODY.sql"), encoding="utf-8").read()))
        print("APPLIED 01_PKG_DMF0074_BODY.sql")
        cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n ORDER BY 1", n=PKG)
        for r in cur:
            print("  ", r)
        cur.execute("SELECT type, line, position, text FROM user_errors WHERE name=:n ORDER BY sequence", n=PKG)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs))
        for e in errs:
            print("  ", e)


if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
