# -*- coding: utf-8 -*-
"""
Phase 2 — 테스트 대상 키 조합 선별 (ZIOUI1 실데이터, 읽기 전용).

선정 규칙
  1) DIVISION 별 ITEM 5종 = measure 다양성 × 행수 상위
  2) ITEM 마다 **실제 존재하는** 키 조합(PROJECT/SITE/DOM_EXP/FCST_TYPE/INCOTERMS/PLANT_SITE) 1건
     — measure 종류가 가장 많은 조합 우선
  3) 각 조합의 measure 별 보유 현황·기간·현재값을 함께 수집 (예측 금지)
"""
import json, re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent
DIVS = ["40", "81", "82"]
TOPN_ITEM = 5
KEY = ["PROJECT_CODE", "SCM_SITE_ID", "ITEM_ID", "DOM_EXP", "FCST_TYPE", "INCOTERMS", "PLANT_SITE_ID"]
FOCUS = ("MKT_FCST", "SCM_FCST", "CUST_FCST", "RTF", "RTF_SYS_RP", "LOC")


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


def rows(cur, sql, **kw):
    cur.execute(sql, kw)
    cols = [c[0] for c in cur.description]
    return [dict(zip(cols, r)) for r in cur.fetchall()]


out = {"divisions": {}}
with conn() as db:
    cur = db.cursor()
    for div in DIVS:
        print("=" * 70)
        print("DIVISION", div)

        # 1) ITEM 5종
        items = rows(cur, """
            SELECT * FROM (
              SELECT ITEM_ID,
                     COUNT(DISTINCT MEASURE) M_CNT, COUNT(*) ROW_CNT,
                     COUNT(DISTINCT SCM_SITE_ID) SITE_CNT,
                     SUM(CASE WHEN MEASURE='MKT_FCST'   THEN 1 ELSE 0 END) MKT,
                     SUM(CASE WHEN MEASURE='SCM_FCST'   THEN 1 ELSE 0 END) SCM,
                     SUM(CASE WHEN MEASURE='CUST_FCST'  THEN 1 ELSE 0 END) CUST,
                     SUM(CASE WHEN MEASURE='RTF'        THEN 1 ELSE 0 END) RTF,
                     SUM(CASE WHEN MEASURE='RTF_SYS_RP' THEN 1 ELSE 0 END) RTF_RP
                FROM SCM_MGR.DM_PLN_MKT_FCST
               WHERE DIVISION_ID = :d
               GROUP BY ITEM_ID
               ORDER BY COUNT(DISTINCT MEASURE) DESC, COUNT(*) DESC
            ) WHERE ROWNUM <= :n""", d=div, n=TOPN_ITEM)
        print("  ITEM {}종: {}".format(len(items), [i["ITEM_ID"] for i in items]))

        div_out = []
        for it in items:
            # 2) 그 ITEM 의 최적 키 조합 1건
            combo = rows(cur, """
                SELECT * FROM (
                  SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
                         INCOTERMS, PLANT_SITE_ID,
                         COUNT(DISTINCT MEASURE) M_CNT, COUNT(*) ROW_CNT,
                         MIN(YYYYMMDD) MIN_YMD, MAX(YYYYMMDD) MAX_YMD
                    FROM SCM_MGR.DM_PLN_MKT_FCST
                   WHERE DIVISION_ID = :d AND ITEM_ID = :i
                   GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
                            INCOTERMS, PLANT_SITE_ID
                   ORDER BY COUNT(DISTINCT MEASURE) DESC, COUNT(*) DESC
                ) WHERE ROWNUM <= 1""", d=div, i=it["ITEM_ID"])
            if not combo:
                continue
            c = combo[0]

            # 3) 그 조합의 measure 별 현황
            meas = rows(cur, """
                SELECT MEASURE, COUNT(*) CNT, MIN(YYYYMMDD) MIN_YMD, MAX(YYYYMMDD) MAX_YMD,
                       ROUND(SUM(QTY),2) SUM_QTY, MAX(LAST_UPDATED_BY) LAST_BY
                  FROM SCM_MGR.DM_PLN_MKT_FCST
                 WHERE DIVISION_ID=:d AND PROJECT_CODE=:p AND SCM_SITE_ID=:s AND ITEM_ID=:i
                   AND DOM_EXP=:de AND FCST_TYPE=:ft AND INCOTERMS=:ic AND PLANT_SITE_ID=:ps
                 GROUP BY MEASURE ORDER BY COUNT(*) DESC""",
                d=div, p=c["PROJECT_CODE"], s=c["SCM_SITE_ID"], i=c["ITEM_ID"],
                de=c["DOM_EXP"], ft=c["FCST_TYPE"], ic=c["INCOTERMS"], ps=c["PLANT_SITE_ID"])

            c["item_stat"] = it
            c["measures"] = meas
            c["focus_have"] = sorted({m["MEASURE"] for m in meas} & set(FOCUS))
            c["focus_miss"] = sorted(set(FOCUS) - {m["MEASURE"] for m in meas})
            div_out.append(c)
            print("   {:20s} site={:26s} measures={} 결손={}".format(
                c["ITEM_ID"], str(c["SCM_SITE_ID"])[:26],
                len(meas), c["focus_miss"]))
        out["divisions"][div] = div_out

(D / "02_targets.json").write_text(json.dumps(out, ensure_ascii=False, indent=1, default=str),
                                   encoding="utf-8")
print("\n저장: 02_targets.json")
