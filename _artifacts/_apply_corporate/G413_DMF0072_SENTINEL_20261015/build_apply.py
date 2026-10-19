#!/usr/bin/env python3
"""
GAP 413 — DMF0072 N:N Mapping '값 없음' 센티널 통일 비교 (DB 객체 보완 전용)

요구(사용자 2026-10-15): 조회·연결 시 NULL / '' / ' ' / '-' / '/' 를 모두 하나("값 없음")로 인지.
  - 저장값은 그대로 둔다 (DMF0072 신규 = '/', EDI 배치 = ' ', 이관분 = '-').
  - 비교(JOIN/ON/WHERE) 와 매핑 GTT 적재(GROUP BY 포함) 지점만 정규화식으로 감싼다.
  - 정규화식: NVL(NULLIF(NULLIF(NULLIF(RTRIM(LTRIM(x)),'-'),'--'),'/'), <기존 상수>)
      · TRIM 결과 '' / ' ' 는 Oracle 에서 NULL → NVL 로 기존 상수
      · '-' · '--'(hook #119 §1.5 변형) · '/' → NULLIF 로 NULL → 기존 상수
      · 기존 상수(' ' / '/' / '@#@#@#')는 객체별 원문 값을 유지 → 출력값·타 비교 영향 없음

대상 5객체 (ALL_DEPENDENCIES · ALL_SOURCE 'DM_CUST_MODEL_MAPPING_M' 전수 = 5, 타 OWNER 0):
  PKG_DMF0072 BODY               : 저장 시 기존행 판정·UPDATE WHERE ('@#@#@#' 비교) → '/' 행 재저장 시 중복 INSERT 방지
  PR_DM_CUST_MODEL_MAPPING       : EDI → 매핑 기초행 생성 MERGE (조회 B 조인 + ON) → '/' 행을 못 보고 ' ' 쌍둥이 생성 방지
  PR_DM_CUST_MODEL_MAPPING_IF    : NERP IF → 매핑 MERGE ON 2곳
  PR_DM_DNM_EDI_CALLOFF_MKT_FCST : 매핑 GTT 적재(GROUP BY) + EDI↔매핑 조인 2곳
  PR_DM_PLN_CUST_FCST_RECORD     : 매핑 GTT 적재(GROUP BY, '/') + EDI↔매핑 조인 (CUSTOMER_PLANT ' ' vs '/' 불일치 포함)

사용:
  python build_apply.py build   # ALL_SOURCE 재조회 → ORIG_/PATCH_ .sql 생성 + diff 출력 (DB 변경 없음)
  python build_apply.py apply   # FRESH-GATE(적용 직전 재조회 == build 기준본) 통과 시 CREATE OR REPLACE + ALL_ERRORS 확인
"""
import sys, re, pathlib, datetime, difflib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "_diagnostics"))
import ora  # noqa: E402
import oracledb  # noqa: E402

HERE = pathlib.Path(__file__).resolve().parent
MARK = "  /* 2026.10.15 GAP413 센티널 통일 */"

# (object, type, kind, line numbers[ALL_SOURCE.LINE], expected regex hits)
#   kind 'RTRIM' = NVL(RTRIM(LTRIM(col)), 'c')  /  kind 'AT' = NVL(TRIM(col), '@#@#@#')
TARGETS = [
    ("PKG_DMF0072",                    "PACKAGE BODY", "AT",    None,                                                  12),
    ("PR_DM_CUST_MODEL_MAPPING",       "PROCEDURE",    "RTRIM", [164, 165, 166, 193, 194, 195],                        12),
    ("PR_DM_CUST_MODEL_MAPPING_IF",    "PROCEDURE",    "RTRIM", [206, 207, 208, 372, 373, 374],                        12),
    ("PR_DM_DNM_EDI_CALLOFF_MKT_FCST", "PROCEDURE",    "RTRIM", [292, 293, 294, 303, 304, 413, 414, 415, 941, 942, 943], 18),
    ("PR_DM_PLN_CUST_FCST_RECORD",     "PROCEDURE",    "RTRIM", [176, 177, 178, 185, 186, 187, 278, 279, 280],          12),
]

RX_RTRIM = re.compile(r"NVL\(RTRIM\(LTRIM\(([A-Z0-9_.]+(?:\(\+\))?)\)\),\s*'([ /])'\)")
RX_AT = re.compile(r"NVL\(TRIM\(((?:A|REC)\.(?:UNLOADING_POINT|CUSTOMER_PLANT|CUSTOMER_ITEM_ID))\),\s*'@#@#@#'\)")


def norm_rtrim(m):
    return f"NVL(NULLIF(NULLIF(NULLIF(RTRIM(LTRIM({m.group(1)})),'-'),'--'),'/'), '{m.group(2)}')"


def norm_at(m):
    return f"NVL(NULLIF(NULLIF(NULLIF(TRIM({m.group(1)}),'-'),'--'),'/'), '@#@#@#')"


def connect():
    u, p, d = ora.conn_info()
    return oracledb.connect(user=u, password=p, dsn=d)


def fetch_source(cur, name, otype):
    """FRESH: ALL_SOURCE 원문 + LAST_DDL_TIME 재조회."""
    cur.execute("SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=otype)
    lines = [r[1] for r in cur.fetchall()]
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=otype)
    ddl, status = cur.fetchone()
    return lines, ddl, status


def patch(name, kind, line_nos, lines):
    out = list(lines)
    hits = 0
    if kind == "AT":
        idxs = [i for i, t in enumerate(lines) if "'@#@#@#'" in t and "REC." in t and not t.lstrip().startswith("--")]
    else:
        idxs = [n - 1 for n in line_nos]
    for i in idxs:
        src = lines[i]
        rx, fn = (RX_AT, norm_at) if kind == "AT" else (RX_RTRIM, norm_rtrim)
        new, k = rx.subn(fn, src)
        if k == 0:
            raise SystemExit(f"[{name}] LINE {i+1} 치환 대상 없음 — 원문 변경 의심, 중단: {src!r}")
        body = new.rstrip("\n")
        # 라인 끝 표식 (개행 보존 — hook #119 §4 함정 3)
        tail = "\n" if new.endswith("\n") else ""
        if " -- " in body or body.rstrip().endswith("*/"):
            out[i] = body + tail  # 기존 라인주석/블록주석 뒤에는 표식 생략 (주석 삼킴 방지)
        else:
            out[i] = body + MARK + tail
        hits += k
    return out, hits, [i + 1 for i in idxs]


def ddl_text(lines):
    return "CREATE OR REPLACE " + "".join(lines).rstrip() + "\n"


def build(cur, stamp_time):
    plan = []
    for name, otype, kind, line_nos, exp in TARGETS:
        lines, last_ddl, status = fetch_source(cur, name, otype)
        new, hits, changed = patch(name, kind, line_nos, lines)
        if hits != exp:
            raise SystemExit(f"[{name}] 치환 수 {hits} ≠ 기대 {exp} — 중단")
        if len(new) != len(lines):
            raise SystemExit(f"[{name}] 라인 수 변동 — 중단")
        stamp = f"-- SOURCE-FRESH: SCM_MGR.{name} {otype} LAST_DDL={last_ddl} FETCHED={stamp_time} DB=ZIOUI1\n"
        tag = name if otype != "PACKAGE BODY" else name + "_BODY"
        (HERE / f"ORIG_{tag}.sql").write_text(stamp + "-- ROLLBACK 용 원본 (GAP413 적용 전)\n" + ddl_text(lines) + "/\n", encoding="utf-8")
        (HERE / f"PATCH_{tag}.sql").write_text(stamp + "-- GAP413 센티널 통일 비교 — 변경 라인: " + ",".join(map(str, changed)) + "\n" + ddl_text(new) + "/\n", encoding="utf-8")
        print(f"== {name} ({otype}) LAST_DDL={last_ddl} STATUS={status} 치환={hits} 변경라인={changed}")
        for d in difflib.unified_diff(lines, new, lineterm="", n=0):
            if d.startswith(("+", "-")) and not d.startswith(("+++", "---")):
                print("   " + d.rstrip("\n"))
        plan.append((name, otype, lines, new, last_ddl))
    return plan


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "build"
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
    con = connect(); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL")
    print("DB =", cur.fetchone())
    plan = build(cur, now)
    if mode != "apply":
        return
    for name, otype, base, new, last_ddl in plan:
        # FRESH-GATE: 적용 직전 재조회 == build 기준본
        cur_lines, cur_ddl, _ = fetch_source(cur, name, otype)
        if cur_lines != base or cur_ddl != last_ddl:
            raise SystemExit(f"FRESH-GATE 실패: {name} 원문 변경 — 중단·재조회·재병합")
        cur.execute(ddl_text(new))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", n=name, t=otype)
        errs = cur.fetchall()
        cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=otype)
        st = cur.fetchone()
        print(f"APPLIED {name} {otype} -> STATUS={st[0]} LAST_DDL={st[1]} ERRORS={len(errs)}")
        for e in errs:
            print("   ", e)
        if errs:
            raise SystemExit("컴파일 오류 — 중단 (ORIG_*.sql 로 롤백 가능)")


if __name__ == "__main__":
    main()
