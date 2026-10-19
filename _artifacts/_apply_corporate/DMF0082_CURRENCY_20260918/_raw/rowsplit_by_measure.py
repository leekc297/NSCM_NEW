# -*- coding: utf-8 -*-
"""
DMF0082 행분리 — MEASURE 별 · 원인 컬럼별 분해

판정 기준
  그리드 행 그레인 = V_COLUMN ∪ {SORT_ORDER_NO}
    ① C_TITLE (SCM_MST_TITLESET_USER 'C' — 계정별 컬럼 설정)   → AS-IS 도 동일 → 행분리도 AS-IS 파리티
    ② NOTATION / SORT_ORDER_NO                                → AS-IS 도 동일
    ③ [E20260822-KEYCOL] 저장 키 12컬럼 강제 추가               → **TO-BE 전용** → 보완 대상

  따라서 원인 컬럼이 ③ 에만 속하면 AS-IS 에 없던 회귀다.
"""
import re
import sys
import pathlib

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

BIZ = ["DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
       "DOM_EXP", "FCST_TYPE", "INCOTERMS", "PLANT_SITE_ID", "MEASURE"]
EXCLUDE = {"QTY", "BUCKET_TYPE", "BUCKET_KEY", "YYYYMM", "YYYYMMWW",
           "WEEK_END_YN", "MONTH_END_YN", "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT",
           "CREATE_DATE"}
KEYCOL = {"DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP",
          "FCST_TYPE", "INCOTERMS", "MEASURE", "PLANT_SITE_ID", "CELL_PROD_SITE_ID", "CURRENCY"}
FIXED = {"NOTATION", "SORT_ORDER_NO"}

DIV, VER = "40", "Current"
ITEMS = ("MCCM134010A1,MCCM131012A1,MCCM348014A3,MCCM356015A2,MCCM350415B1,"
         "MCCM348018A2,MCCM350415A1,MCCH129520B1,MCSS22561-C1,MIF489266C11")
USER = "minyonglee1"


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


with conn() as db:
    cur = db.cursor()

    # 이 계정의 C_TITLE (그레인 ①)
    cur.execute("""SELECT U.COLUMN_NAME FROM SCM_MGR.SCM_MST_TITLESET_USER U,
                          SCM_MGR.SCM_MST_SHEET_COLUMNS C
                    WHERE U.PROGRAM_ID=C.PROGRAM_ID AND U.SHEET_NAME=C.SHEET_NAME
                      AND U.COLUMN_NAME=C.COLUMN_NAME
                      AND U.PROGRAM_ID='DMF0082' AND U.SHEET_NAME='FcstNPrice'
                      AND U.USER_ID=:u AND U.USER_INQUIRY_COLUMN_TYPE_CODE='C'""", u=USER)
    ctitle = {r[0] for r in cur}
    print("C_TITLE({}) {}컬럼: {}".format(USER, len(ctitle), sorted(ctitle)))

    cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                    AND TABLE_NAME='GT_DMF0082_MF_SP' ORDER BY COLUMN_ID""")
    cols = [r[0] for r in cur if r[0] not in EXCLUDE and r[0] not in BIZ]

    rc = [cur.var(oracledb.CURSOR) for _ in range(6)]
    cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
                 [DIV, "ALL", "ALL", "ALL", "20260101", "20271231", "ALL", ITEMS,
                  VER, "Y", USER, "ADMIN", "ALL", "ALL", "ALL", "ALL"] + rc)
    print("RESULT:", rc[5].getvalue().fetchall()[:1])

    cur.execute("SELECT MEASURE, COUNT(*) FROM SCM_MGR.GT_DMF0082_MF_SP GROUP BY MEASURE ORDER BY 1")
    print("\nGTT MEASURE:", [(r[0], r[1]) for r in cur])

    bizj = ", ".join(BIZ)
    agg = ", ".join("SUM(CASE WHEN K_{0} > 1 THEN 1 ELSE 0 END) AS S_{0}".format(c) for c in cols)
    sub = ", ".join("COUNT(DISTINCT NVL(TO_CHAR({0}), '(NULL)')) AS K_{0}".format(c) for c in cols)

    cur.execute("SELECT DISTINCT MEASURE FROM SCM_MGR.GT_DMF0082_MF_SP ORDER BY 1")
    measures = [r[0] for r in cur]

    print("\n{:16s} {:24s} {:>8s}  {}".format("MEASURE", "원인 컬럼", "업무키수", "그레인 출처 → 판정"))
    print("-" * 104)
    for ms in measures:
        cur.execute("SELECT {a} FROM (SELECT {b}, {s} FROM SCM_MGR.GT_DMF0082_MF_SP "
                    "WHERE MEASURE = :m GROUP BY {b})".format(a=agg, b=bizj, s=sub), m=ms)
        r = cur.fetchone()
        found = [(cols[i], r[i]) for i in range(len(cols)) if r[i]]
        if not found:
            print("{:16s} {:24s} {:>8s}  {}".format(ms, "(없음)", "-", "행분리 없음"))
            continue
        for c, v in sorted(found, key=lambda x: -x[1]):
            src = []
            if c in ctitle:
                src.append("① C_TITLE")
            if c in KEYCOL:
                src.append("③ KEYCOL")
            if c in FIXED:
                src.append("② 고정")
            if not src:
                src.append("그레인 아님(무영향)")
            verdict = ("AS-IS 파리티 → 현행 유지" if (c in ctitle or c in FIXED)
                       else ("**TO-BE 전용 → 보완 대상**" if c in KEYCOL else "그레인 아님"))
            print("{:16s} {:24s} {:>8,d}  {} → {}".format(ms, c, v, "+".join(src), verdict))
