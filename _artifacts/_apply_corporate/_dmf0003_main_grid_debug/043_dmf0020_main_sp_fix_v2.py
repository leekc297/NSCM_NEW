"""
v2 fix — GROUP BY 측 CASE expression dependent column 추가:
  - line 281 측 `, D.BASIS_START_DATE;` → `, D.BASIS_START_DATE, SUBSTR(A.YYYYMMDD, 1, 6);`
  - line 392 측 `, F.BASIS_START_DATE;` → `, F.BASIS_START_DATE, SUBSTR(A.YYYYMMDD, 1, 6);`
  - line 281 측 GROUP BY 의 마지막 column. (다른 line 측 GROUP BY 측 정확 검증 후 적용.)
"""
import os
import oracledb

with oracledb.connect(user=os.environ["NSCM_ORA_USER"],
                      password=os.environ["NSCM_ORA_PASS"],
                      dsn=os.environ["NSCM_ORA_DSN"]) as con:
    cur = con.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")

    cur.execute("""
        SELECT LINE, TEXT FROM ALL_SOURCE
        WHERE OWNER='SCM_MGR' AND NAME='DMF0020_GET_SCM_MST_FUTURE_PRICE' AND TYPE='PROCEDURE'
        ORDER BY LINE
    """)
    lines = []
    for line_no, text in cur:
        lines.append(text.rstrip("\n"))
    body = "\n".join(lines)
    print(f"[OK] body extracted, lines={len(lines)}")

    # GROUP BY 측 line 281 측 `, D.BASIS_START_DATE;` + line 392 `, F.BASIS_START_DATE;`
    # CASE expression 측 SUBSTR(A.YYYYMMDD, 1, 6) 측 의존 측 → GROUP BY 측 추가 필요.

    # 변경 1: D.BASIS_START_DATE 측 마지막 ; 측 ── GROUP BY 일 가능성. 정확 패턴.
    old1 = "          , D.BASIS_START_DATE;"
    new1 = "          , D.BASIS_START_DATE\n          , SUBSTR(A.YYYYMMDD, 1, 6);"
    cnt1 = body.count(old1)
    body = body.replace(old1, new1)
    print(f"[OK] D.BASIS_START_DATE ; replaced: {cnt1}")

    old2 = "          , F.BASIS_START_DATE;"
    new2 = "          , F.BASIS_START_DATE\n          , SUBSTR(A.YYYYMMDD, 1, 6);"
    cnt2 = body.count(old2)
    body = body.replace(old2, new2)
    print(f"[OK] F.BASIS_START_DATE ; replaced: {cnt2}")

    if cnt1 == 0 and cnt2 == 0:
        print("[WARN] no replace — pattern mismatch (가능 — leading spaces 다름)")
        # leading spaces 측 다른 측 시도
        for spc in ['        ', '\t\t', '   ', '    ', '       ', '         ']:
            old_x = f"{spc}, D.BASIS_START_DATE;"
            if old_x in body:
                print(f"  match leading={len(spc)}: {repr(spc)}")

    ddl = "CREATE OR REPLACE " + body
    if ddl.rstrip().endswith("/"):
        ddl = ddl.rstrip().rstrip("/").rstrip()
    try:
        cur.execute(ddl)
        print("[OK] CREATE OR REPLACE")
    except Exception as e:
        print(f"[FAIL] {e}")
        raise
    cur.execute("""
        SELECT STATUS FROM ALL_OBJECTS
        WHERE OWNER='SCM_MGR' AND OBJECT_NAME='DMF0020_GET_SCM_MST_FUTURE_PRICE' AND OBJECT_TYPE='PROCEDURE'
    """)
    print(f"[STATUS] {cur.fetchone()[0]}")
    cur.execute("""
        SELECT LINE, POSITION, TEXT FROM ALL_ERRORS
        WHERE OWNER='SCM_MGR' AND NAME='DMF0020_GET_SCM_MST_FUTURE_PRICE'
        ORDER BY SEQUENCE
    """)
    errs = cur.fetchall()
    print(f"[ERRORS] {len(errs)}")
    for line, pos, t in errs[:10]:
        print(f"   {line}:{pos} {t}")
