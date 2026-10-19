# -*- coding: utf-8 -*-
"""
Phase 2 (정정) — 테스트 대상 선별 v2.

v1 문제: 전체 measure 다양성으로 뽑아 FOCUS 메저(SCM_FCST 등) 결손이 많았고,
         단가(LOC)는 DM_PLN_MKT_FCST 에 없는데 '결손'으로 잡혔다.
v2 규칙:
  · 랭킹 = FOCUS 메저 보유 종수(MKT/SCM/CUST/RTF/RTF_SYS_RP) 우선, 그다음 행수
  · 단가는 별도 원장에서 확인  — DMF0082 계열 = DM_PLN_CFM_SELLING_PRICE
                                DMF0020 계열 = SCM_MST_FUTURE_PRICE
  · 키 조합은 그 ITEM 의 **실존 조합** 중 FOCUS 보유가 최다인 1건
"""
import json, re, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent
DIVS = ["40", "81", "82"]
TOPN = 5
FOCUS = ["MKT_FCST", "SCM_FCST", "CUST_FCST", "RTF", "RTF_SYS_RP"]


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


def rows(cur, sql, **kw):
    cur.execute(sql, kw)
    cols = [c[0] for c in cur.description]
    return [dict(zip(cols, r)) for r in cur.fetchall()]


FOCUS_SEL = ", ".join(
    "MAX(CASE WHEN MEASURE='{0}' THEN 1 ELSE 0 END) H_{0}".format(m) for m in FOCUS)
FOCUS_SCORE = " + ".join(
    "MAX(CASE WHEN MEASURE='{0}' THEN 1 ELSE 0 END)".format(m) for m in FOCUS)

out = {"divisions": {}}
with conn() as db:
    cur = db.cursor()
    for div in DIVS:
        print("=" * 78)
        print("DIVISION", div)

        items = rows(cur, """
            SELECT * FROM (
              SELECT ITEM_ID, {score} FOCUS_SCORE, COUNT(*) ROW_CNT,
                     COUNT(DISTINCT SCM_SITE_ID) SITE_CNT, COUNT(DISTINCT MEASURE) M_CNT, {sel}
                FROM SCM_MGR.DM_PLN_MKT_FCST
               WHERE DIVISION_ID = :d
               GROUP BY ITEM_ID
               ORDER BY {score} DESC, COUNT(*) DESC
            ) WHERE ROWNUM <= :n""".format(score=FOCUS_SCORE, sel=FOCUS_SEL), d=div, n=TOPN)

        div_out = []
        for it in items:
            combo = rows(cur, """
                SELECT * FROM (
                  SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
                         PLANT_SITE_ID, {score} FOCUS_SCORE, COUNT(*) ROW_CNT,
                         MIN(YYYYMMDD) MIN_YMD, MAX(YYYYMMDD) MAX_YMD
                    FROM SCM_MGR.DM_PLN_MKT_FCST
                   WHERE DIVISION_ID=:d AND ITEM_ID=:i
                   GROUP BY PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,
                            INCOTERMS, PLANT_SITE_ID
                   ORDER BY {score} DESC, COUNT(*) DESC
                ) WHERE ROWNUM <= 1""".format(score=FOCUS_SCORE), d=div, i=it["ITEM_ID"])
            if not combo:
                continue
            c = combo[0]
            k = dict(d=div, p=c["PROJECT_CODE"], s=c["SCM_SITE_ID"], i=c["ITEM_ID"],
                     de=c["DOM_EXP"], ft=c["FCST_TYPE"], ic=c["INCOTERMS"], ps=c["PLANT_SITE_ID"])

            c["measures"] = rows(cur, """
                SELECT MEASURE, COUNT(*) CNT, MIN(YYYYMMDD) MIN_YMD, MAX(YYYYMMDD) MAX_YMD,
                       ROUND(SUM(QTY),2) SUM_QTY
                  FROM SCM_MGR.DM_PLN_MKT_FCST
                 WHERE DIVISION_ID=:d AND PROJECT_CODE=:p AND SCM_SITE_ID=:s AND ITEM_ID=:i
                   AND DOM_EXP=:de AND FCST_TYPE=:ft AND INCOTERMS=:ic AND PLANT_SITE_ID=:ps
                 GROUP BY MEASURE ORDER BY COUNT(*) DESC""", **k)

            # 단가 (DMF0082 축)
            c["price_selling"] = rows(cur, """
                SELECT MEASURE, CURRENCY, COUNT(*) CNT, MIN(YYYYMMDD) MIN_YMD,
                       MAX(YYYYMMDD) MAX_YMD, ROUND(AVG(PRICE),4) AVG_PRICE
                  FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE
                 WHERE DIVISION_ID=:d AND PROJECT_CODE=:p AND SCM_SITE_ID=:s AND ITEM_ID=:i
                   AND DOM_EXP=:de AND FCST_TYPE=:ft AND INCOTERMS=:ic
                 GROUP BY MEASURE, CURRENCY ORDER BY COUNT(*) DESC""",
                d=div, p=c["PROJECT_CODE"], s=c["SCM_SITE_ID"], i=c["ITEM_ID"],
                de=c["DOM_EXP"], ft=c["FCST_TYPE"], ic=c["INCOTERMS"])

            # 단가 (DMF0020 축)
            c["price_future"] = rows(cur, """
                SELECT MEASURE, CURRENCY, COUNT(*) CNT, MIN(YYYYMMDD) MIN_YMD,
                       MAX(YYYYMMDD) MAX_YMD, ROUND(AVG(PRICE),4) AVG_PRICE
                  FROM SCM_MGR.SCM_MST_FUTURE_PRICE
                 WHERE DIVISION_ID=:d AND PROJECT_CODE=:p AND SCM_SITE_ID=:s AND ITEM_ID=:i
                   AND DOM_EXP=:de AND FCST_TYPE=:ft AND INCOTERMS=:ic
                 GROUP BY MEASURE, CURRENCY ORDER BY COUNT(*) DESC""",
                d=div, p=c["PROJECT_CODE"], s=c["SCM_SITE_ID"], i=c["ITEM_ID"],
                de=c["DOM_EXP"], ft=c["FCST_TYPE"], ic=c["INCOTERMS"])

            have = {m["MEASURE"] for m in c["measures"]}
            c["item_stat"] = it
            c["focus_have"] = [m for m in FOCUS if m in have]
            c["focus_miss"] = [m for m in FOCUS if m not in have]
            div_out.append(c)
            print("  {:20s} site={:24s} FOCUS={}/{} 결손={} 단가(SP/FP)={}/{}".format(
                c["ITEM_ID"], str(c["SCM_SITE_ID"])[:24],
                len(c["focus_have"]), len(FOCUS), c["focus_miss"] or "-",
                len(c["price_selling"]), len(c["price_future"])))
        out["divisions"][div] = div_out

(D / "03_targets_v2.json").write_text(json.dumps(out, ensure_ascii=False, indent=1, default=str),
                                      encoding="utf-8")
print("\n저장: 03_targets_v2.json")
