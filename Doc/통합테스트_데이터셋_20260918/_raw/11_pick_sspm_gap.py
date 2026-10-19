# -*- coding: utf-8 -*-
"""
Phase 3 — SSPM 에는 있는데 MKT_FCST 가 없는 키 선별 (division 별 5건)

기준 (사용자 확정 2026-09-18): **SSPM 키 단위**
  SCM_MST_SITE_ITEM(VALID_YN='Y') 의 DIVISION+PROJECT_CODE+SCM_SITE_ID+ITEM_ID 조합 중
  DM_PLN_MKT_FCST(MEASURE='MKT_FCST', QTY<>0) 에 같은 조합이 **없는** 키.

선별 규칙 (예측 금지 — 전부 실데이터)
  1. 그 ITEM 의 SSPM 키 수가 많은 순 (사이트 다양성)
  2. 신규 입력 시 채워야 할 부속키(FCST_TYPE/INCOTERMS/DOM_EXP/PLANT_SITE_ID)는
     **그 SCM_SITE_ID 에서 실제로 쓰이는 최빈 조합**을 DM_PLN_MKT_FCST 에서 가져온다.
     사이트에 실적이 없으면 division 최빈 조합으로 폴백하고 출처를 표기한다.
  3. SSPM 자체 속성(CURRENCY/DEPT_ID/OWNER/CUST_GROUP)은 SCM_MST_SITE_ITEM 실값 그대로
"""
import re
import json
import pathlib
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent
N_PER_DIV = 5


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    pat = "CONN='([^/]+)/" + chr(34) + "([^" + chr(34) + "]+)" + chr(34) + "@([^']+)'"
    m = re.search(pat, sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


GAP_SQL = """
SELECT * FROM (
  SELECT S.DIVISION_ID, S.PROJECT_CODE, S.SCM_SITE_ID, S.ITEM_ID,
         S.CURRENCY, S.DEPT_ID, S.OWNER, S.CUST_GROUP, S.APPLICATION, S.ROUTE,
         COUNT(*) OVER (PARTITION BY S.ITEM_ID) AS ITEM_KEY_CNT
    FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                  MAX(CURRENCY) CURRENCY, MAX(DEPT_ID) DEPT_ID, MAX(OWNER) OWNER,
                  MAX(CUST_GROUP) CUST_GROUP, MAX(APPLICATION) APPLICATION, MAX(ROUTE) ROUTE
             FROM SCM_MGR.SCM_MST_SITE_ITEM
            WHERE DIVISION_ID = :d AND VALID_YN = 'Y'
            GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID ) S
   WHERE NOT EXISTS (
           SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST F
            WHERE F.DIVISION_ID = S.DIVISION_ID AND F.PROJECT_CODE = S.PROJECT_CODE
              AND F.SCM_SITE_ID = S.SCM_SITE_ID AND F.ITEM_ID = S.ITEM_ID
              AND F.MEASURE = 'MKT_FCST' AND F.QTY <> 0 )
   ORDER BY ITEM_KEY_CNT DESC, S.ITEM_ID, S.SCM_SITE_ID )
WHERE ROWNUM <= :n
"""

# ITEM 이 한 종에 몰리지 않도록 **ITEM 별 1건**씩 뽑는다 (사이트·프로젝트 다양성 확보)
GAP_SQL = """
SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
       CURRENCY, DEPT_ID, OWNER, CUST_GROUP, APPLICATION, ROUTE, ITEM_KEY_CNT
  FROM ( SELECT S.*, ROW_NUMBER() OVER (PARTITION BY S.ITEM_ID
                        ORDER BY S.SCM_SITE_ID, S.PROJECT_CODE) RN_IN_ITEM,
                COUNT(*) OVER (PARTITION BY S.ITEM_ID) ITEM_KEY_CNT
           FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                         MAX(CURRENCY) CURRENCY, MAX(DEPT_ID) DEPT_ID, MAX(OWNER) OWNER,
                         MAX(CUST_GROUP) CUST_GROUP, MAX(APPLICATION) APPLICATION, MAX(ROUTE) ROUTE
                    FROM SCM_MGR.SCM_MST_SITE_ITEM
                   WHERE DIVISION_ID = :d AND VALID_YN = 'Y'
                     AND ITEM_ID IS NOT NULL AND ITEM_ID <> '-'   -- 센티널 제외
                   GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID ) S
          WHERE NOT EXISTS (
                  SELECT 1 FROM SCM_MGR.DM_PLN_MKT_FCST F
                   WHERE F.DIVISION_ID = S.DIVISION_ID AND F.PROJECT_CODE = S.PROJECT_CODE
                     AND F.SCM_SITE_ID = S.SCM_SITE_ID AND F.ITEM_ID = S.ITEM_ID
                     AND F.MEASURE = 'MKT_FCST' AND F.QTY <> 0 ) )
 WHERE RN_IN_ITEM = 1
   AND ROWNUM <= :n
 ORDER BY ITEM_KEY_CNT DESC
"""

SITE_MODE_SQL = """
SELECT FCST_TYPE, INCOTERMS, DOM_EXP, PLANT_SITE_ID, CNT FROM (
  SELECT FCST_TYPE, INCOTERMS, DOM_EXP, PLANT_SITE_ID, COUNT(*) CNT
    FROM SCM_MGR.DM_PLN_MKT_FCST
   WHERE DIVISION_ID = :d AND SCM_SITE_ID = :s AND MEASURE = 'MKT_FCST' AND QTY <> 0
   GROUP BY FCST_TYPE, INCOTERMS, DOM_EXP, PLANT_SITE_ID
   ORDER BY COUNT(*) DESC )
WHERE ROWNUM = 1
"""

DIV_MODE_SQL = """
SELECT FCST_TYPE, INCOTERMS, DOM_EXP, PLANT_SITE_ID, CNT FROM (
  SELECT FCST_TYPE, INCOTERMS, DOM_EXP, PLANT_SITE_ID, COUNT(*) CNT
    FROM SCM_MGR.DM_PLN_MKT_FCST
   WHERE DIVISION_ID = :d AND MEASURE = 'MKT_FCST' AND QTY <> 0
   GROUP BY FCST_TYPE, INCOTERMS, DOM_EXP, PLANT_SITE_ID
   ORDER BY COUNT(*) DESC )
WHERE ROWNUM = 1
"""

out = {}
with conn() as db:
    cur = db.cursor()
    for div in ("40", "81", "82"):
        cur.execute(DIV_MODE_SQL, d=div)
        dm = cur.fetchone()
        cur.execute(GAP_SQL, d=div, n=N_PER_DIV)
        cols = [c[0] for c in cur.description]
        keys = []
        for r in cur.fetchall():
            k = dict(zip(cols, r))
            cur.execute(SITE_MODE_SQL, d=div, s=k["SCM_SITE_ID"])
            sm = cur.fetchone()
            src = "사이트 최빈" if sm else "DIVISION 최빈"
            use = sm or dm
            k["FCST_TYPE"], k["INCOTERMS"], k["DOM_EXP"], k["PLANT_SITE_ID"] = use[0], use[1], use[2], use[3]
            k["부속키출처"] = "{}({:,}건)".format(src, use[4])
            # 분류기준 — 왜 이 행이 '신규' 인지 실측 근거
            cur.execute("""SELECT COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST
                            WHERE DIVISION_ID=:d AND PROJECT_CODE=:p
                              AND SCM_SITE_ID=:s AND ITEM_ID=:i""",
                        d=div, p=k["PROJECT_CODE"], s=k["SCM_SITE_ID"], i=k["ITEM_ID"])
            any_meas = cur.fetchone()[0]
            k["분류기준"] = ("SSPM 등록 O / MKT_FCST 0건"
                             " · 이 키의 DM_PLN_MKT_FCST 전 메저 {}행"
                             " · 해당 ITEM 의 SSPM 키 {}개").format(any_meas, k["ITEM_KEY_CNT"])
            keys.append(k)
        out[div] = keys
        print("DIV {} — SSPM 미생성 키 {}건".format(div, len(keys)))
        for k in keys:
            print("   {:22s} {:24s} PJT={:12s} {}/{}/{}/{}  [{}]".format(
                str(k["ITEM_ID"])[:22], str(k["SCM_SITE_ID"])[:24], str(k["PROJECT_CODE"])[:12],
                k["FCST_TYPE"], k["INCOTERMS"], k["DOM_EXP"], k["PLANT_SITE_ID"], k["부속키출처"]))

(D / "11_sspm_gap.json").write_text(json.dumps(out, ensure_ascii=False, indent=1, default=str),
                                    encoding="utf-8")
print("\n11_sspm_gap.json 저장")
