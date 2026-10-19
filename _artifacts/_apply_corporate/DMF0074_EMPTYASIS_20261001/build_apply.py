"""DMF0074 Excel Upload — 동적 컬럼(금속 7종) 공란 적재를 AS-IS 와 동일하게 (사내 ZIOUI1)

사용자 결정(2026-10-01): 1번 "AS-IS 그대로 맞추기" — 검증은 현행 유지, 적재만 AS-IS 동작으로.

AS-IS DMF0074_EXCEL_UPLOAD (MSSQL) 실동작 — 엑셀 빈칸 = '' (NULL 아님):
  - UNPIVOT 은 NULL 만 제외 → '' 는 남으므로 모델마다 금속 7행이 항상 생성·MERGE
  - 키·기간 '' 저장(이관 후 '-') / ROUND('',n) = 0 → 단가·수량·Energy 0 저장 / Exception '' 저장(이관 후 '-')
  - 근거: TO-BE 원장의 AS-IS 이관분(2024-09~2025-09) 전 모델 METALS=7, 키 '-' + 단가 0 = 81 8,165행 / 82 1,875행,
          81 Energy 전부 0(33,495행), 82 Exception '-' 1,113행
TO-BE(Oracle '' = NULL) 격차: UNPIVOT 이 빈 금속을 버림 → Metal Link=N/Exception=Y 행 미저장, 81 키만 있는 금속 탈락,
  빈칸 재업로드 시 기존 값 미갱신 / Exception 공란 = NULL = NULL 조인 불일치로 행 전체 탈락

변경 [E20261001-EMPTYASIS] — P_DMF0074_EXCEL_UPLOAD 3) UNPIVOT · 3-7) 합치기 한정 (검증 블록 무변경)
  1) 3-1 ~ 3-6 UNPIVOT → UNPIVOT INCLUDE NULLS (6곳) = MSSQL '' 보존과 동일하게 금속 7행 유지
  2) 3-7 조인의 METAL_EXCEPTION_YN 비교 → NVL 양변 (5곳) = AS-IS '' = '' 매칭
  3) 3-7 SELECT: Exception NVL '-' / Energy·단가·수량 NVL 0 / 키·기간 NVL '-'
     (원장 NOT NULL 컬럼 METAL_EXCEPTION_YN·APPLY_PRICE_TYPE_CODE·FROM/TO_PERIOD_YYYYMM = DEFAULT ON NULL '-' 이나
      MERGE UPDATE 에는 미적용 → 명시 NVL 필수)

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
MARK = "[E20261001-EMPTYASIS]"

OLD_SEL = """              ,APPLY_PRICE_TYPE.METAL_EXCEPTION_YN
              ,ROUND(TO_NUMBER(APPLY_PRICE_TYPE.ENERGY), 3) ENERGY
              ,APPLY_PRICE_TYPE.METAL_KIND_CODE
              ,APPLY_PRICE_TYPE.APPLY_PRICE_TYPE_CODE
              ,FROM_PERIOD.FROM_PERIOD
              ,TO_PERIOD.TO_PERIOD
              --셋째 자리에서 반올림 처리
              ,ROUND(TO_NUMBER(CONTRACT_UNIT.CONTRACT_UNIT), 2) CONTRACT_UNIT
              ,ROUND(TO_NUMBER(METAL_APPLY.METAL_APPLY), 2) METAL_APPLY
              ,ROUND(TO_NUMBER(METAL_REQR.METAL_REQR), 2) METAL_REQR
"""

NEW_SEL = f"""              --{MARK} AS-IS 파리티: MSSQL 빈칸 '' 저장 / ROUND('',n) = 0 → 공란 = 문자 '-' · 숫자 0
              --  (원장 NOT NULL 문자 컬럼은 DEFAULT ON NULL '-' 가 MERGE UPDATE 에 미적용 → 명시 NVL)
              ,NVL(APPLY_PRICE_TYPE.METAL_EXCEPTION_YN, '-') AS METAL_EXCEPTION_YN
              ,NVL(ROUND(TO_NUMBER(APPLY_PRICE_TYPE.ENERGY), 3), 0) ENERGY
              ,APPLY_PRICE_TYPE.METAL_KIND_CODE
              ,NVL(APPLY_PRICE_TYPE.APPLY_PRICE_TYPE_CODE, '-') AS APPLY_PRICE_TYPE_CODE
              ,NVL(FROM_PERIOD.FROM_PERIOD, '-') AS FROM_PERIOD
              ,NVL(TO_PERIOD.TO_PERIOD, '-') AS TO_PERIOD
              --셋째 자리에서 반올림 처리
              ,NVL(ROUND(TO_NUMBER(CONTRACT_UNIT.CONTRACT_UNIT), 2), 0) CONTRACT_UNIT
              ,NVL(ROUND(TO_NUMBER(METAL_APPLY.METAL_APPLY), 2), 0) METAL_APPLY
              ,NVL(ROUND(TO_NUMBER(METAL_REQR.METAL_REQR), 2), 0) METAL_REQR
"""


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
    if MARK in src or "[E20261001-EMPTYDYN]" in src:
        sys.exit("ABORT: EMPTYASIS/EMPTYDYN 마커 이미 존재 — 원문 확인 필요")
    if src.count("PROCEDURE P_DMF0074_EXCEL_UPLOAD") != 1:
        sys.exit("ABORT: P_DMF0074_EXCEL_UPLOAD 위치 특정 불가")

    # 1) UNPIVOT INCLUDE NULLS (3-1 ~ 3-6)
    old = "        FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL\n        UNPIVOT\n"
    n = src.count(old)
    if n != 6:
        sys.exit(f"ABORT: FINAL UNPIVOT 일치 {n}회 (6회여야 함)")
    src = src.replace(old, "        FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL\n"
                           f"        UNPIVOT INCLUDE NULLS /*{MARK} AS-IS(MSSQL '' 보존) 동일 — 빈 금속도 7행 유지*/\n")

    # 2) 3-7 조인 METAL_EXCEPTION_YN NVL 양변
    pat = re.compile(r"AND APPLY_PRICE_TYPE\.METAL_EXCEPTION_YN(\s+)= (\w+)\.METAL_EXCEPTION_YN\n")
    hits = pat.findall(src)
    if len(hits) != 5:
        sys.exit(f"ABORT: METAL_EXCEPTION_YN 조인 일치 {len(hits)}회 (5회여야 함)")
    src = pat.sub(lambda m: f"AND NVL(APPLY_PRICE_TYPE.METAL_EXCEPTION_YN,'@#@#@#') = NVL({m.group(2)}.METAL_EXCEPTION_YN,'@#@#@#') /*{MARK} Exception 공란 매칭*/\n", src)

    # 3) 3-7 SELECT NVL
    n = src.count(OLD_SEL)
    if n != 1:
        sys.exit(f"ABORT: 3-7 SELECT 목록 일치 {n}회 (1회여야 함)")
    src = src.replace(OLD_SEL, NEW_SEL)
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
        cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 60")
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
