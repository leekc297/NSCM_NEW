"""
DMF0020_GET_SCM_MST_FUTURE_PRICE body 측 PIVOT YYYYMMDD 보정:
  - line 262, 360 측 `D.BASIS_START_DATE AS YYYYMMDD` / `F.BASIS_START_DATE AS YYYYMMDD`
  - 같은 주의 6월 부분 + 7월 부분 row 측 BASIS_START_DATE 같음 → W_yyyymmdd column 1개
  - 변경: CASE WHEN BASIS_START_DATE yyyymm = row yyyymm THEN BASIS_START_DATE ELSE row yyyymm 01
"""
import os, re
import oracledb

with oracledb.connect(user=os.environ["NSCM_ORA_USER"],
                      password=os.environ["NSCM_ORA_PASS"],
                      dsn=os.environ["NSCM_ORA_DSN"]) as con:
    cur = con.cursor()
    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 1800")

    # SP body 추출 — ALL_SOURCE 측 LINE 순서대로
    cur.execute("""
        SELECT LINE, TEXT FROM ALL_SOURCE
        WHERE OWNER='SCM_MGR' AND NAME='DMF0020_GET_SCM_MST_FUTURE_PRICE' AND TYPE='PROCEDURE'
        ORDER BY LINE
    """)
    lines = []
    for line_no, text in cur:
        lines.append(text.rstrip("\n"))

    body = "\n".join(lines)
    orig_len = len(body)
    print(f"[OK] body extracted, lines={len(lines)}, chars={orig_len}")

    # ⭐ 변경 1: `, D.BASIS_START_DATE AS YYYYMMDD` (line 262) — A 측 별칭 사용 JOIN context
    # ⭐ 변경 2: `, F.BASIS_START_DATE AS YYYYMMDD` (line 360) — 동일
    # A.YYYYMMDD or B.YYYYMMDD 측 그 row 의 일자.
    # 같은 ASSIGN 가능 위치 측 정확 변경 (multiple matches).

    # 변환 패턴 1: D.BASIS_START_DATE AS YYYYMMDD (A.YYYYMMDD context)
    new_d = (
        "CASE WHEN SUBSTR(D.BASIS_START_DATE, 1, 6) = SUBSTR(A.YYYYMMDD, 1, 6) "
        "THEN D.BASIS_START_DATE ELSE SUBSTR(A.YYYYMMDD, 1, 6) || '01' END AS YYYYMMDD"
    )
    cnt_d = body.count("D.BASIS_START_DATE AS YYYYMMDD")
    body = body.replace("D.BASIS_START_DATE AS YYYYMMDD", new_d)
    print(f"[OK] D.BASIS_START_DATE AS YYYYMMDD replaced: {cnt_d}")

    # 변환 패턴 2: F.BASIS_START_DATE AS YYYYMMDD (A.YYYYMMDD context)
    new_f = (
        "CASE WHEN SUBSTR(F.BASIS_START_DATE, 1, 6) = SUBSTR(A.YYYYMMDD, 1, 6) "
        "THEN F.BASIS_START_DATE ELSE SUBSTR(A.YYYYMMDD, 1, 6) || '01' END AS YYYYMMDD"
    )
    cnt_f = body.count("F.BASIS_START_DATE AS YYYYMMDD")
    body = body.replace("F.BASIS_START_DATE AS YYYYMMDD", new_f)
    print(f"[OK] F.BASIS_START_DATE AS YYYYMMDD replaced: {cnt_f}")

    # ORDER BY 측도 변경 (line 281, 392 측 D.BASIS_START_DATE / F.BASIS_START_DATE):
    # CASE 측 그대로 ORDER BY 변경 안 함 (절대 시작일 기준 정렬 유지)
    # 다만 GROUP BY 측 BASIS_START_DATE 측 CASE 동일 변환 필요? — GROUP BY 측 그대로 두면 같은 주 + 같은 yyyymm 측 row 1개. 정상.

    print(f"[OK] new length={len(body)}, diff={len(body) - orig_len}")

    # CREATE OR REPLACE PROCEDURE 으로 wrap
    ddl = "CREATE OR REPLACE " + body
    if ddl.rstrip().endswith("/"):
        ddl = ddl.rstrip().rstrip("/").rstrip()

    # SP CREATE
    try:
        cur.execute(ddl)
        print("[OK] CREATE OR REPLACE PROCEDURE DMF0020_GET_SCM_MST_FUTURE_PRICE")
    except Exception as e:
        print(f"[FAIL] {e}")
        raise

    # status + errors
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
