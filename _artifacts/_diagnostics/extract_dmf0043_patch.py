#!/usr/bin/env python3
"""DMF0043 사내 → 클라우드 patch DDL 추출.

사내 ALL_SOURCE 에서 9 객체 (PKG_DMF0043 PACKAGE + BODY + 7 SP) DDL 추출.
각 객체별로 별도 SQL 파일 생성 + 통합 _ALL.sql.

실행:
  set NSCM_ORA_USER=SCM_MGR
  set NSCM_ORA_PASS=!SCMroqkf2026
  set NSCM_ORA_DSN=121.162.245.167:2521/ESSCMD
  python extract_dmf0043_patch.py <output_dir>
"""
import os, sys, pathlib
import oracledb

OUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "."

# (NAME, TYPE)
OBJECTS = [
    ("PKG_DMF0043", "PACKAGE"),
    ("PKG_DMF0043", "PACKAGE BODY"),
    ("DMF0043_GET_CONTRIBUTE_MAIN_DATA",     "PROCEDURE"),
    ("DMF0043_GET_MAIN_SPREAD_TITLE",        "PROCEDURE"),
    ("DMF0043_GET_CONTRIBUTE_RATE_POPUP",    "PROCEDURE"),
    ("DMF0043_GET_CONTRIBUTE_YEAR_POPUP",    "PROCEDURE"),
    ("DMF0043_GET_CONT_VIEW_VERSIONPOPUP",   "PROCEDURE"),
    ("DMF0043_GET_SALES_LIST_SPREAD_TITLE",  "PROCEDURE"),
    ("DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO", "PROCEDURE"),
]

def conn_info():
    return os.getenv("NSCM_ORA_USER"), os.getenv("NSCM_ORA_PASS"), os.getenv("NSCM_ORA_DSN")

def extract_source(cur, name, type_):
    cur.execute(
        "SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE",
        {"n": name, "t": type_}
    )
    return "".join(r[0] for r in cur.fetchall())

def main():
    u, p, d = conn_info()
    if not (u and p and d):
        sys.exit("ERROR: NSCM_ORA_USER/PASS/DSN env vars required")
    out = pathlib.Path(OUT_DIR)
    out.mkdir(parents=True, exist_ok=True)
    all_sql = []
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        for i, (name, type_) in enumerate(OBJECTS, 1):
            body = extract_source(cur, name, type_)
            if not body.strip():
                print(f"[{i}] {name} ({type_}): EMPTY — skipped")
                continue
            # ALL_SOURCE.TEXT 가 'PROCEDURE name(...' 또는 'PACKAGE name AS' 로 시작
            # CREATE OR REPLACE 추가 prefix
            ddl = "CREATE OR REPLACE " + body
            # 2026-06-17 fix (hook sp-patch-file-deploy.md §1.1):
            # END; 와 / 가 같은 라인이면 SP body 안 / 포함 사고 → 명시적 newline 강제
            if not ddl.rstrip().endswith(";"):
                ddl = ddl.rstrip() + ";"
            ddl_with_slash = ddl.rstrip() + "\n/\n"
            fn = f"{i:02d}_{name}_{type_.replace(' ', '_')}.sql"
            (out / fn).write_text(ddl_with_slash, encoding="utf-8", newline="\n")
            line_count = ddl.count("\n")
            print(f"[{i}] {fn}: {line_count} lines")
            all_sql.append(f"-- ===== {i}: {name} ({type_}) =====\n")
            all_sql.append(ddl_with_slash + "\n")
    # 통합 파일
    integrated = "-- DMF0043 — 사내 → 클라우드 patch (2026-06-11 09:56 ~ 14:28 changes)\n"
    integrated += "-- 9 objects (PKG_DMF0043 PACKAGE/BODY + 7 standalone PROCEDURE)\n"
    integrated += "-- 적용 후 컴파일 확인: SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME LIKE 'DMF0043%' OR OBJECT_NAME='PKG_DMF0043';\n\n"
    integrated += "".join(all_sql)
    (out / "00_ALL_DMF0043_patch.sql").write_text(integrated, encoding="utf-8", newline="\n")
    print(f"\n=== integrated: 00_ALL_DMF0043_patch.sql ({integrated.count(chr(10))} lines) ===")

if __name__ == "__main__":
    main()
