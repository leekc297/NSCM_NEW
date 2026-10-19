# -*- coding: utf-8 -*-
"""
DMF0082 — 동일 업무키가 그리드 2행 이상으로 갈리는 케이스 전수 조사

배경
  최종 커서는 PIVOT 이므로 SELECT 목록(V_COLUMN)에 남은 **모든 컬럼이 행 그레인**이 된다.
  V_COLUMN = ① C_TITLE(사용자 컬럼 설정 SCM_MST_TITLESET_USER 'C')
             ② NOTATION
             ③ [E20260822-KEYCOL] 저장 키 12컬럼 강제 추가  ← TO-BE 전용 (AS-IS 부재)
  따라서 ③ 에 든 컬럼의 값이 arm 별로 갈리면 AS-IS 에 없는 행분리가 난다.

조사 방법
  업무키 = 그리드가 "같은 행"으로 봐야 하는 축
         = DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID,
           DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MEASURE
  이 업무키 안에서 나머지 그레인 컬럼의 값이 2종 이상이면 행이 갈린다.
  컬럼별로 분해해 **어느 컬럼이 몇 건을 가르는지** 집계한다. (읽기 전용)
"""
import re
import sys
import pathlib

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

BIZ = ["DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
       "DOM_EXP", "FCST_TYPE", "INCOTERMS", "PLANT_SITE_ID", "MEASURE"]

# KEYCOL 강제 추가분 + 그리드 그레인이 될 수 있는 부가 컬럼
# 날짜/수량 축은 원래 여러 값 → 제외. 나머지 전 컬럼이 그리드 그레인 후보다.
EXCLUDE = {"QTY", "BUCKET_TYPE", "BUCKET_KEY", "YYYYMM", "YYYYMMWW",
           "WEEK_END_YN", "MONTH_END_YN", "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT",
           "CREATE_DATE"}
SPLIT_CANDIDATES = None  # 아래에서 MF_SP 전 컬럼으로 채운다

CASES = [
    ("40", "Current", "MCCM134010A1,MCCM131012A1,MCCM348014A3,MCCM356015A2,MCCM350415B1,"
                      "MCCM348018A2,MCCM350415A1,MCCH129520B1,MCSS22561-C1,MIF489266C11"),
    ("81", "Current", "ACLN1007I-A1,ACHP2005I-A1,ACLF1015I-A2,ACLF1015I-B1,ACEN1063I-D1"),
    ("82", "Current", "ETD1551AFB3A-XBA,ETD1551AFB3C-XBA,EH257064P8S1,EH048189P3S1,EA102156PG01"),
]


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


with conn() as db:
    cur = db.cursor()
    cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                    AND TABLE_NAME='GT_DMF0082_MF_SP'""")
    have = {r[0] for r in cur}
    cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
                    AND TABLE_NAME='GT_DMF0082_MF_SP' ORDER BY COLUMN_ID""")
    cols = [r[0] for r in cur if r[0] not in EXCLUDE and r[0] not in BIZ]
    bizj = ", ".join(BIZ)

    for div, ver, items in CASES:
        rc = [cur.var(oracledb.CURSOR) for _ in range(6)]
        cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA",
                     [div, "ALL", "ALL", "ALL", "20260101", "20271231", "ALL", items,
                      ver, "Y", "minyonglee1", "ADMIN", "ALL", "ALL", "ALL", "ALL"] + rc)
        res = rc[5].getvalue().fetchall()[:1]

        cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_MF_SP")
        tot = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM (SELECT {b} FROM SCM_MGR.GT_DMF0082_MF_SP "
                    "GROUP BY {b})".format(b=bizj))
        bizkeys = cur.fetchone()[0]
        print("\n=== DIV {} / {} / ITEM {}종 ===  RESULT={}  GTT {:,}행 · 업무키 {:,}개".format(
            div, ver, len(items.split(",")), res, tot, bizkeys))

        # 컬럼별 — 업무키 안에서 값이 2종 이상인 키 수
        agg = ", ".join("SUM(CASE WHEN K_{0} > 1 THEN 1 ELSE 0 END) AS S_{0}".format(c) for c in cols)
        sub = ", ".join("COUNT(DISTINCT NVL(TO_CHAR({0}), '(NULL)')) AS K_{0}".format(c) for c in cols)
        cur.execute("SELECT {a} FROM (SELECT {b}, {s} FROM SCM_MGR.GT_DMF0082_MF_SP "
                    "GROUP BY {b})".format(a=agg, b=bizj, s=sub))
        r = cur.fetchone()
        found = [(cols[i], r[i]) for i in range(len(cols)) if r[i]]
        if not found:
            print("   행분리 유발 컬럼 없음")
        for c, v in sorted(found, key=lambda x: -x[1]):
            print("   {:22s} {:>6,d} 업무키에서 값이 2종 이상  <== 행분리".format(c, v))

        # 실제로 몇 행이 갈리는가 (전체 그레인 기준)
        allg = bizj + ", " + ", ".join(cols)
        cur.execute("""SELECT SUM(CASE WHEN C > 1 THEN 1 ELSE 0 END), COUNT(*)
                         FROM (SELECT {b}, COUNT(*) OVER (PARTITION BY {b}) C
                                 FROM (SELECT {a} FROM SCM_MGR.GT_DMF0082_MF_SP
                                        GROUP BY {a}))""".format(b=bizj, a=allg))
        split, allrows = cur.fetchone()
        print("   → 그리드 행 {:,}개 중 {:,}개가 같은 업무키의 분신".format(allrows or 0, split or 0))

        # 대표 사례
        if found:
            c0 = sorted(found, key=lambda x: -x[1])[0][0]
            cur.execute("""SELECT ITEM_ID, SCM_SITE_ID, PROJECT_CODE, MEASURE,
                                  LISTAGG(V, ' | ') WITHIN GROUP (ORDER BY V) AS 값들
                             FROM (SELECT {b}, NVL(TO_CHAR({c}),'(NULL)') AS V
                                     FROM SCM_MGR.GT_DMF0082_MF_SP
                                    GROUP BY {b}, NVL(TO_CHAR({c}),'(NULL)'))
                            GROUP BY {b} HAVING COUNT(*) > 1
                            ORDER BY 1,2 FETCH FIRST 5 ROWS ONLY""".format(b=bizj, c=c0))
            print("   [{}] 사례".format(c0))
            for x in cur:
                print("      {} / {} / {} / {:14s} → {}".format(*[str(y) for y in x]))
