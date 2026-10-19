"""DMF0074 Excel Upload — 원장 DEPT_ID = SSPM(SCM_MST_SITE_ITEM.DEPT_ID) 저장 (사내 ZIOUI1)

사용자 지시(2026-10-02): "DMF0074 에서 EXCEL UPLOAD 로 저장하였는데 TABLE 에 DEPT_ID 가 들어가지 않았습니다.
  TO-BE 에서는 EXCEL 에 DEPT_ID 가 없으면 해당 제품의 SCM_MST_SITE_ITEM TABLE 에 들어있는 DEPT_ID 를 사용해서 DEPT_ID 를 저장하면 됩니다."

원인: P_DMF0074_EXCEL_UPLOAD 가 AS-IS [PJ2024-50461] "메탈링크 업로드시 팀정보 관리 안하므로 공백저장" 을 그대로 승계 →
      DM_BPS_METAL_LINK_PRICE / _H INSERT 시 DEPT_ID 고정값 '-' (Excel 에는 DEPT_ID 컬럼 없음 — ATTRIBUTE3 팀명도 미사용).

변경 [E20261002-DEPTSSPM] — P_DMF0074_EXCEL_UPLOAD 4) 원장 MERGE · 5) 이력 INSERT 한정
  1) MERGE USING / _H FROM : GT_DM74_TMP_METAL_LINK_PRICE 에 SCM_MST_SITE_ITEM LEFT JOIN (PK 4키 = 1:1, hook#150 §3-3 — MAX 불필요)
       DIVISION_ID · PROJECT_CODE(40 = END_CUSTOMER) · SCM_SITE_ID · ITEM_ID  →  NVL(SI.DEPT_ID,'-') AS DEPT_ID
       (조인식은 같은 프로시저 2-1/2-2 의 ITM 조인 · GET 의 SITE_ITEM 조인과 동일)
  2) WHEN NOT MATCHED INSERT / _H INSERT : '-' → B.DEPT_ID
  3) WHEN MATCHED UPDATE : A.DEPT_ID = SSPM 값 (SSPM 이 NULL 이면 기존 값 유지)
       DEPT_ID 는 PK 구성 컬럼이나 ON 절에 없음(갱신 가능). 원장에 DEPT 제외 키가 같은 다중 DEPT 행 0건(2026-10-02 실측) → PK 충돌 없음.
  SSPM DEPT_ID 가 NULL 인 모델은 종전대로 '-' (원장 NOT NULL).

사용:
  python build_apply.py build   # ALL_SOURCE 재조회 → 00_BACKUP / 01_BODY 생성 (치환 지점 개수 assert)
  python build_apply.py apply   # FRESH-GATE 통과 시 적용 + 컴파일 확인
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0074"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")
MARK = "[E20261002-DEPTSSPM]"


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


def sspm_view(ind):
    """GT_DM74_TMP_METAL_LINK_PRICE + SSPM DEPT_ID (PK 4키 1:1) 인라인 뷰. ind = 'USING'/'FROM' 줄 들여쓰기."""
    p = ind + "      "
    return (
        f"(SELECT B0.*\n"
        f"{p}     , NVL(SI.DEPT_ID, '-') AS DEPT_ID /*{MARK} DEPT_ID = SSPM(SCM_MST_SITE_ITEM.DEPT_ID) — PK 4키 1:1 (hook#150 §3-3), 미등록 = '-'*/\n"
        f"{p}  FROM SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE B0\n"
        f"{p}  LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM SI\n"
        f"{p}         ON SI.DIVISION_ID  = B0.DIVISION_ID\n"
        f"{p}        AND SI.PROJECT_CODE = CASE WHEN B0.DIVISION_ID = '40' THEN B0.END_CUSTOMER ELSE B0.PROJECT_CODE END\n"
        f"{p}        AND SI.SCM_SITE_ID  = B0.SCM_SITE_ID\n"
        f"{p}        AND SI.ITEM_ID      = B0.ITEM_ID) B"
    )


def rep1(src, old, new, what):
    n = src.count(old)
    if n != 1:
        sys.exit(f"ABORT: {what} 일치 {n}회 (1회여야 함) — 원문이 바뀌었거나 이미 반영됨")
    return src.replace(old, new)


def transform(src):
    if MARK in src:
        sys.exit(f"ABORT: {MARK} 이미 존재 — 재적용 불필요")
    if src.count("PROCEDURE P_DMF0074_EXCEL_UPLOAD") != 1:
        sys.exit("ABORT: P_DMF0074_EXCEL_UPLOAD 위치 특정 불가")
    if "\r" in src:
        sys.exit("ABORT: 원문에 CR 포함 — 치환 패턴 재확인 필요")

    # 1) 원장 MERGE USING → SSPM DEPT_ID 인라인 뷰
    src = rep1(src,
               "        MERGE INTO SCM_MGR.DM_BPS_METAL_LINK_PRICE A\n"
               "        USING SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE B\n",
               "        MERGE INTO SCM_MGR.DM_BPS_METAL_LINK_PRICE A\n"
               "        USING " + sspm_view("        ") + "\n",
               "MERGE USING")

    # 2) WHEN MATCHED — DEPT_ID 를 SSPM 값으로 (SSPM 미등록이면 기존 값 유지)
    src = rep1(src,
               "                ,A.LAST_UPDATED_BY        = P_CREATED_BY\n",
               f"                ,A.DEPT_ID                = CASE WHEN B.DEPT_ID = '-' THEN A.DEPT_ID ELSE B.DEPT_ID END /*{MARK} 기존 행도 SSPM DEPT_ID 로 (SSPM 미등록이면 유지)*/\n"
               "                ,A.LAST_UPDATED_BY        = P_CREATED_BY\n",
               "MERGE MATCHED LAST_UPDATED_BY")

    # 3) WHEN NOT MATCHED INSERT VALUES — '-' → B.DEPT_ID
    src = rep1(src,
               "\n                --,B.DEPT_ID\n                , '-'\n",
               f"\n                --,B.DEPT_ID\n                , B.DEPT_ID /*{MARK} AS-IS 공백저장('-') → SSPM DEPT_ID*/\n",
               "MERGE INSERT VALUES '-'")

    # 4) 이력(_H) INSERT SELECT — '-' → B.DEPT_ID
    src = rep1(src,
               "\n              --,B.DEPT_ID\n              , '-'\n",
               f"\n              --,B.DEPT_ID\n              , B.DEPT_ID /*{MARK} AS-IS 공백저장('-') → SSPM DEPT_ID*/\n",
               "_H SELECT '-'")

    # 5) 이력(_H) INSERT FROM → SSPM DEPT_ID 인라인 뷰
    src = rep1(src,
               "        FROM SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE B;\n",
               "        FROM " + sspm_view("        ") + ";\n",
               "_H FROM")
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
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == build 시점 기준본
        now = read_source(cur)
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS")
        tobe = strip(open(os.path.join(HERE, "01_PKG_DMF0074_BODY.sql"), encoding="utf-8").read())
        cur.execute(tobe)
        print("APPLIED 01_PKG_DMF0074_BODY.sql")
        cur.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM user_objects WHERE object_name=:n ORDER BY 1", n=PKG)
        for r in cur:
            print("  ", r)
        cur.execute("SELECT type, line, position, text FROM user_errors WHERE name=:n ORDER BY sequence", n=PKG)
        errs = cur.fetchall()
        print("USER_ERRORS", len(errs))
        for e in errs:
            print("  ", e)
        after = read_source(cur)
        applied = tobe[len("CREATE OR REPLACE "):]
        print("DB==TOBE", after["src"].rstrip() == applied.rstrip(), "marker", after["src"].count(MARK))
        cur.execute("SELECT COUNT(*) FROM all_objects WHERE owner='SCM_MGR' AND status='INVALID'")
        print("SCM_MGR INVALID objects", cur.fetchone()[0])


if __name__ == "__main__":
    {"build": build, "apply": apply}[sys.argv[1]]()
