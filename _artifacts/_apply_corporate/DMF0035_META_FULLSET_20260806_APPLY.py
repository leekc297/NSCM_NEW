# -*- coding: utf-8 -*-
"""
DMF0035_META_FULLSET_20260806_APPLY.py — DMF0035 Demand Plan Waterfall 사내 메타 전세트 적용·검증 러너

사용:
  python DMF0035_META_FULLSET_20260806_APPLY.py            # 적용 + 검증
  python DMF0035_META_FULLSET_20260806_APPLY.py --verify   # 검증만 (DML 미실행)

접속: _diagnostics/ora.py conn_info() (SCM_MGR@OCGSCMD_P01)
SQL : 같은 폴더 DMF0035_META_FULLSET_20260806.sql — 문장 구분자 = 단독 '/' 라인
정책: 멱등(MERGE/차이가드 UPDATE) · 감사컬럼 'admin' · DELETE/DROP 없음 · SP 실행 없음
"""
import sys, io, pathlib

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import ora  # noqa: E402
import oracledb  # noqa: E402

HERE = pathlib.Path(__file__).resolve().parent
SQL_FILE = HERE / "DMF0035_META_FULLSET_20260806.sql"

# PROC_M ↔ USER_ARGUMENTS positional 대조 대상 (본 세트 신규 5 + 재사용 2)
PROCS = [
    ("PKG_DMF0035", "P_DMF0035_GET_MKT_FCST_WATERFALL"),
    ("PKG_DMF0035", "P_DMF0035_GET_SPREAD_TITLE"),
    ("PKG_DMF0022", "P_DMF0022_GET_DM_PLN_SALES_PLAN_WATERFALL"),
    ("PKG_DMF0022", "P_DMF0022_GET_SPREAD_TITLE"),
    ("PKG_DMF0051", "P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL"),
    ("PKG_DMF0051", "P_DMF0051_GET_SPREAD_TITLE"),
    (None, "DMF0073_GET_VERSION_SALESPRICE"),
]

EXPECT = {  # 테이블별 기대 카운트 (DMF0035 대상 행)
    "SCM_ADM_MSG_M (MNU00691)": 3,
    "SCM_ADM_API_M (DMF0035_%)": 7,
    "SCM_ADM_MNU_BTN_MPG_M (DMF0035)": 7,
    "SCM_ADM_USER_GR_MNU_BTN_MPG_M (DMF0035)": 35,
    "SCM_ADM_CMBO_SQL_M (QtyType/DM)": 1,
    "PROC_M PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL": 25,
    "PROC_M PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE": 7,
    "PROC_M PKG_DMF0022.P_DMF0022_GET_SPREAD_TITLE": 9,
    "PROC_M PKG_DMF0051.P_DMF0051_GET_DM_PLN_BIZ_PLAN_WATERFALL": 22,
    "PROC_M PKG_DMF0051.P_DMF0051_GET_SPREAD_TITLE": 9,
}


def split_statements(text: str):
    stmts, buf = [], []
    for line in text.replace("\r", "").splitlines():
        if line.strip() == "/":
            s = "\n".join(buf).strip()
            if s:
                stmts.append(s)
            buf = []
        else:
            buf.append(line)
    tail = "\n".join(buf).strip()
    # 꼬리 주석 블록은 무시 (실행 문장은 모두 '/' 종결)
    if tail and not all(ln.strip().startswith("--") or not ln.strip() for ln in tail.splitlines()):
        stmts.append(tail)
    return stmts


def apply(cur):
    print("=" * 70)
    print("[APPLY] " + str(SQL_FILE))
    print("=" * 70)
    text = SQL_FILE.read_text(encoding="utf-8")
    total = 0
    for i, s in enumerate(split_statements(text), 1):
        head = next(ln.strip() for ln in s.splitlines() if ln.strip() and not ln.strip().startswith("--"))
        try:
            cur.execute(s)
            print(f"  [{i:02d}] OK  rows={cur.rowcount:<3} :: {head[:80]}")
            total += cur.rowcount
        except Exception as e:
            print(f"  [{i:02d}] FAIL :: {head[:80]}\n        {e}")
            raise
    cur.connection.commit()
    print(f"[APPLY] COMMIT 완료 — 합계 영향 행수 {total}")


def q(cur, sql, binds=None):
    cur.execute(sql, binds or {})
    return cur.fetchall()


def verify(cur):
    print("\n" + "=" * 70)
    print("[VERIFY 1] 항목별 카운트 (기대 vs 실제)")
    print("=" * 70)
    actual = {}
    actual["SCM_ADM_MSG_M (MNU00691)"] = q(cur, "SELECT COUNT(*) FROM SCM_ADM_MSG_M WHERE MSG_ID='MNU00691'")[0][0]
    actual["SCM_ADM_API_M (DMF0035_%)"] = q(cur, "SELECT COUNT(*) FROM SCM_ADM_API_M WHERE API_ID LIKE 'DMF0035\\_%' ESCAPE '\\'")[0][0]
    actual["SCM_ADM_MNU_BTN_MPG_M (DMF0035)"] = q(cur, "SELECT COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0035'")[0][0]
    actual["SCM_ADM_USER_GR_MNU_BTN_MPG_M (DMF0035)"] = q(cur, "SELECT COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0035'")[0][0]
    actual["SCM_ADM_CMBO_SQL_M (QtyType/DM)"] = q(cur, "SELECT COUNT(*) FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID='QtyType' AND MDU_DIVS_CD='DM'")[0][0]
    for pkg, prc in PROCS[:6]:
        nm = (pkg + "." if pkg else "") + prc
        key = "PROC_M " + nm
        if key in EXPECT:
            actual[key] = q(cur, "SELECT COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM=:1", [nm])[0][0]
    ok = True
    for k, exp in EXPECT.items():
        act = actual.get(k, "?")
        flag = "PASS" if act == exp else "FAIL"
        if flag == "FAIL":
            ok = False
        print(f"  [{flag}] {k:<58} 기대 {exp:>3} / 실제 {act}")

    print("\n" + "=" * 70)
    print("[VERIFY 2] PROC_M ↔ USER_ARGUMENTS positional 대조 (7 SP)")
    print("=" * 70)
    mismatch_total = 0
    for pkg, prc in PROCS:
        nm = (pkg + "." if pkg else "") + prc
        rows = q(cur, """
            SELECT NVL(p.SORT_ORD, a.POSITION) POS, p.COL_NM, a.ARGUMENT_NAME,
                   p.COL_TP_CD, a.IN_OUT, p.DATA_TP_CD, a.DATA_TYPE,
                   CASE WHEN p.SORT_ORD IS NULL OR a.POSITION IS NULL THEN 'MISSING'
                        WHEN p.COL_TP_CD <> a.IN_OUT THEN 'IN_OUT'
                        WHEN p.DATA_TP_CD='VARCHAR'     AND a.DATA_TYPE <> 'VARCHAR2'   THEN 'TYPE'
                        WHEN p.DATA_TP_CD IN ('CURSOR','PROC_RESULT') AND a.DATA_TYPE <> 'REF CURSOR' THEN 'TYPE'
                        ELSE 'OK' END CHK
              FROM (SELECT SORT_ORD, COL_NM, COL_TP_CD, DATA_TP_CD
                      FROM SCM_ADM_PROC_M WHERE PROC_NM = :nm) p
              FULL OUTER JOIN
                   (SELECT POSITION, ARGUMENT_NAME, IN_OUT, DATA_TYPE
                      FROM USER_ARGUMENTS
                     WHERE OBJECT_NAME = :prc
                       AND ((:pkg IS NULL AND PACKAGE_NAME IS NULL) OR PACKAGE_NAME = :pkg)) a
                ON p.SORT_ORD = a.POSITION
             ORDER BY 1""", {"nm": nm, "prc": prc, "pkg": pkg})
        bad = [r for r in rows if r[7] != "OK"]
        mismatch_total += len(bad)
        print(f"  {nm}: args {len(rows)}행 / 불일치 {len(bad)}")
        for r in bad:
            print(f"     !! pos={r[0]} PROC_M={r[1]}/{r[3]}/{r[5]} ARGS={r[2]}/{r[4]}/{r[6]} → {r[7]}")
    print(f"  ==> positional 불일치 합계: {mismatch_total} (0 이어야 PASS)")
    if mismatch_total:
        ok = False

    print("\n" + "=" * 70)
    print("[VERIFY 3] MNU_M DMF0035 최종 행")
    print("=" * 70)
    for r in q(cur, """SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, MNU_LV_NO,
                              MNU_TP_CD, UNIT_TP_CD, USE_YN, ROUTE_PATH, LAST_UPDATED_BY
                         FROM SCM_ADM_MNU_M WHERE MNU_ID='DMF0035'"""):
        for c, v in zip(["MNU_ID", "UPPR_MNU_ID", "MNU_URL", "MNU_MSG_ID", "MNU_DESC", "SORT_ORD", "MNU_LV_NO",
                         "MNU_TP_CD", "UNIT_TP_CD", "USE_YN", "ROUTE_PATH", "LAST_UPDATED_BY"], r):
            print(f"  {c:<16} = {v}")

    print("\n" + "=" * 70)
    print("[VERIFY 4] 기존재 SKIP 대상 현황 (SHEET_COLUMNS/MEASURE/GR_MNU/CMBO/MSG)")
    print("=" * 70)
    for r in q(cur, """SELECT 'SHEET_COLUMNS' T, PROGRAM_ID, SHEET_NAME, COUNT(*) C FROM SCM_MST_SHEET_COLUMNS
                        WHERE PROGRAM_ID IN ('DMF0035','DMF0022','DMF0051') GROUP BY PROGRAM_ID, SHEET_NAME
                       UNION ALL
                       SELECT 'SHEET_MEASURE', PROGRAM_ID, SHEET_NAME, COUNT(*) FROM SCM_MST_SHEET_MEASURE
                        WHERE PROGRAM_ID IN ('DMF0035','DMF0022','DMF0051') GROUP BY PROGRAM_ID, SHEET_NAME
                        ORDER BY 1, 2, 3"""):
        print(f"  {r[0]:<14} {r[1]:<8} {r[2]:<24} {r[3]}행")
    for r in q(cur, """SELECT USER_GR_ID, USE_YN FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0035' ORDER BY 1"""):
        print(f"  GR_MNU_MPG_M   DMF0035  {r[0]:<12} USE_YN={r[1]}")
    for r in q(cur, """SELECT SQL_ID, MDU_DIVS_CD, USE_YN FROM SCM_ADM_CMBO_SQL_M
                        WHERE SQL_ID IN ('BucketType','BucketType2','SenderCode','ItemType','QtyType') ORDER BY 1"""):
        print(f"  CMBO           {r[0]:<14} MDU={r[1]:<4} USE_YN={r[2]}")
    for r in q(cur, """SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_ADM_MSG_M WHERE MSG_ID='MNU00691' ORDER BY LANG_CD"""):
        print(f"  MSG_M          {r[0]} {r[1]} '{r[2]}'")

    print("\n[RESULT] " + ("ALL PASS" if ok else "FAIL 항목 존재 — 위 로그 확인"))
    return ok


def main():
    verify_only = "--verify" in sys.argv
    u, p, d = ora.conn_info()
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        if not verify_only:
            apply(cur)
        ok = verify(cur)
    sys.exit(0 if ok else 2)


if __name__ == "__main__":
    main()
