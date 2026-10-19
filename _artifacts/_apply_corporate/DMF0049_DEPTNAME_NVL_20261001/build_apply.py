"""DMF0049 저장 — DEPARTMENT_NAME / DEPT_NAME 을 DEPARTMENT_ID / DEPT_ID 기준 룩업으로 산출 + NVL(x,'-') (사내 ZIOUI1)

배경: P_DMF0049_SAVE_SALES_ETC_REPORT_C 의 DEPARTMENT_NAME 산출식이 DEPARTMENT_EDIT_FLAG / 화면 부서명에 의존하고
      마지막 분기가 '' (MSSQL 빈문자 → Oracle NULL). 그리드에서 DEPARTMENT_NAME 컬럼이 제외되어 FLAG·부서명이
      넘어오지 않으면 NULL 저장 → DMF0044/0049 Transfer 의 'DEPARTMENT_NAME 정보가 존재하지 않아' 검증에 걸림.

사용:
  python build_apply.py build   # DB 원문 재조회(ALL_SOURCE) → 00_BACKUP / 01_body SQL 생성 (구 블록 1회 일치 assert)
  python build_apply.py apply   # FRESH-GATE(적용 직전 재조회 = build 기준본) 통과 시 BODY 적용 + 컴파일 확인
"""
import sys, os, hashlib, json
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
PKG = "PKG_DMF0049"
TYP = "PACKAGE BODY"
STATE = os.path.join(HERE, "_fresh_state.json")

OLD = """      , A.DEPARTMENT_NAME = CASE WHEN v_division_id = '40'  /*[E20260820-DIVIDSCALAR]*/ AND NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y') THEN v_etc_department_name
                                 WHEN A.DEPARTMENT_EDIT_FLAG = 'true'  THEN ( SELECT LK1.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y' AND ROWNUM=1 )
                                 WHEN A.DEPARTMENT_EDIT_FLAG = 'false' THEN A.T_DEPARTMENT_NAME
                                 WHEN A.DEPARTMENT_EDIT_FLAG IS NULL OR A.T_DEPARTMENT_NAME IS NULL THEN ''
                            END
      , A.DEPT_NAME = CASE WHEN v_division_id = '40'  /*[E20260820-DIVIDSCALAR]*/ AND NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y') THEN v_etc_department_name
                           ELSE ( SELECT LK2.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK2 WHERE A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND ROWNUM=1 )
                      END;"""

NEW = """      -- [E20261001-DEPTNAMEID] 부서명 = ID 기준 룩업 + NVL '-' (그리드에서 DEPARTMENT_NAME 제외 → EDIT_FLAG/화면 부서명 미전달)
      --   구 식은 DEPARTMENT_EDIT_FLAG/T_DEPARTMENT_NAME 의존 + 마지막 분기 '' (MSSQL 빈문자 → Oracle NULL) → NULL 저장
      --   → DMF0044/DMF0049 Transfer 'DEPARTMENT_NAME 정보가 존재하지 않아 저장할 수 없습니다.' 차단.
      --   DEPARTMENT_NAME ← DEPARTMENT_ID (MDF_DEPARTMENT[_div], SEGMENT3='Y') / DEPT_NAME ← DEPT_ID (DMF0044_DEPARTMENT_TEAM2[_div])
      --   40 + 담당 룩업 없음 = 기타 부서명 (버전 생성 P_DMF0044_SAVE_SALES_PLAN_VERSION_COPY 와 동일 규칙) / 값 없으면 '-'
      , A.DEPARTMENT_NAME = NVL( CASE WHEN v_division_id = '40'  /*[E20260820-DIVIDSCALAR]*/ AND NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y') THEN v_etc_department_name
                                      ELSE ( SELECT LK1.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y' AND ROWNUM=1 )
                                 END, '-')
      , A.DEPT_NAME = NVL( CASE WHEN v_division_id = '40'  /*[E20260820-DIVIDSCALAR]*/ AND NOT EXISTS (SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK1 WHERE A.DEPARTMENT_ID = LK1.SEGMENT1 AND LK1.LOOKUP_TYPE = 'MDF_DEPARTMENT'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND LK1.SEGMENT3='Y') THEN v_etc_department_name
                                ELSE ( SELECT LK2.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK2 WHERE A.DEPT_ID = LK2.SEGMENT1 AND LK2.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'||CASE WHEN A.DIVISION_ID='40' THEN '' ELSE '_'||A.DIVISION_ID END AND ROWNUM=1 )
                           END, '-');"""


def connect():
    u, p, d = conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def read_source(cur):
    """DB 원문 재조회 — ALL_SOURCE + LAST_DDL_TIME (유일한 기준본)."""
    cur.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects "
                "WHERE owner='SCM_MGR' AND object_name=:n AND object_type=:t", n=PKG, t=TYP)
    ddl = cur.fetchone()[0]
    cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=PKG, t=TYP)
    src = "".join(r[0] for r in cur)
    return {"last_ddl": ddl, "md5": hashlib.md5(src.encode("utf-8")).hexdigest(), "src": src}


def ddl_text(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def build():
    with connect() as con:
        cur = con.cursor()
        s = read_source(cur)
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') FROM dual")
        fetched = cur.fetchone()[0]
    src = s["src"]
    n = src.count(OLD)
    if n != 1:
        sys.exit(f"ABORT: 구 부서명 블록 일치 {n}회 (1회여야 함) — 최신 원문이 바뀌었는지 확인")
    new = src.replace(OLD, NEW)
    stamp = f"-- SOURCE-FRESH: SCM_MGR.{PKG} {TYP} LAST_DDL={s['last_ddl']} FETCHED={fetched} DB=ZIOUI1\n"
    open(os.path.join(HERE, "00_BACKUP_PKG_DMF0049_BODY.sql"), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(src) + "/\n")
    open(os.path.join(HERE, "01_PKG_DMF0049_BODY.sql"), "w", encoding="utf-8", newline="\n").write(stamp + ddl_text(new) + "/\n")
    json.dump({"last_ddl": s["last_ddl"], "md5": s["md5"], "fetched": fetched}, open(STATE, "w"), indent=1)
    print("BUILD OK", fetched, s["last_ddl"], s["md5"], "lines", src.count("\n"), "->", new.count("\n"))


def strip(txt):
    lines = [l for l in txt.split("\n") if not l.startswith("-- SOURCE-FRESH:")]
    t = "\n".join(lines).rstrip()
    return t[:-1].rstrip() if t.endswith("/") else t


def apply():
    st = json.load(open(STATE))
    with connect() as con:
        cur = con.cursor()
        now = read_source(cur)   # FRESH-GATE — 적용 직전 재조회, build 기준본과 다르면 중단
        if now["md5"] != st["md5"] or now["last_ddl"] != st["last_ddl"]:
            sys.exit(f"FRESH-GATE FAIL: build {st['last_ddl']} {st['md5']} → now {now['last_ddl']} {now['md5']}")
        print("FRESH-GATE PASS")
        cur.execute(strip(open(os.path.join(HERE, "01_PKG_DMF0049_BODY.sql"), encoding="utf-8").read()))
        print("APPLIED 01_PKG_DMF0049_BODY.sql")
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
