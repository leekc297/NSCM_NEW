# -*- coding: utf-8 -*-
"""
Phase 3 — 05_SEED_SUPPLEMENT.sql (보완 SEED)

원칙 (메모리 룰 준수)
  · 멱등 MERGE · 비파괴 · 사내 전값 WHERE 금지
  · 신규행 감사컬럼 CREATED_BY='TESTDATA_20260918' 로 식별 가능
  · 실행 전 대상 건수 산출 SQL + 원복 SQL 동봉
  · 값은 **기존 실데이터에서 파생**(예측 금지) — 같은 키의 MKT_FCST 를 기준으로 SCM_FCST 생성
"""
import json, re, pathlib, sys, datetime, importlib.util
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent
OUT = D.parent
TG = json.loads((D / "03_targets_v2.json").read_text(encoding="utf-8"))
GAPS = json.loads((D / "06_gaps.json").read_text(encoding="utf-8"))
NOW = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
TAG = "TESTDATA_20260918"


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


tmap = {}
for div, ts in TG["divisions"].items():
    for t in ts:
        tmap[(div, t["ITEM_ID"])] = t

scm_gaps = [g for g in GAPS if g[3] == "SCM_FCST"]
biz_gaps = [g for g in GAPS if "BIZ" in g[3]]

L = []
L.append("-- ============================================================================")
L.append("-- 통합테스트 보완 SEED — 05_SEED_SUPPLEMENT.sql")
L.append("-- 생성 {} · 원천 ZIOUI1 실데이터 파생 (예측값 없음)".format(NOW))
L.append("-- 식별자: CREATED_BY = '{}'".format(TAG))
L.append("--")
L.append("-- 원칙: 멱등 MERGE · 비파괴 · 전값 WHERE 금지")
L.append("-- ⚠ 실행 전 §0 사전확인, 실행 후 §3 검증, 필요 시 §4 원복")
L.append("-- ============================================================================")
L.append("")
L.append("-- §0. 사전 확인 — 대상 키가 실존하고 SCM_FCST 가 없는지")
L.append("SELECT DIVISION_ID, ITEM_ID, SCM_SITE_ID,")
L.append("       SUM(CASE WHEN MEASURE='MKT_FCST' THEN 1 ELSE 0 END) MKT_CNT,")
L.append("       SUM(CASE WHEN MEASURE='SCM_FCST' THEN 1 ELSE 0 END) SCM_CNT")
L.append("  FROM SCM_MGR.DM_PLN_MKT_FCST")
L.append(" WHERE (DIVISION_ID, ITEM_ID) IN (")
L.append("       " + ", ".join("('{}','{}')".format(g[1], g[2]) for g in scm_gaps))
L.append("       )")
L.append(" GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID ORDER BY 1,2,3;")
L.append("")
L.append("-- ============================================================================")
L.append("-- §1. 81 SCM_FCST 보완 ({}건 ITEM)".format(len(scm_gaps)))
L.append("--     근거: 권한메타 GET_ADMIN_GROUP_MEASURE 에 DMF0082/81/SCP Planner/SCM_FCST(TUE) 등재")
L.append("--           그러나 DM_PLN_MKT_FCST 에 81 SCM_FCST 0건 → 테스트 불가")
L.append("--     방식: **같은 키의 MKT_FCST 행을 그대로 복제**해 MEASURE 만 SCM_FCST 로")
L.append("--           (QTY 값도 실데이터 그대로 — 임의 생성 아님)")
L.append("-- ============================================================================")
for g in scm_gaps:
    _, div, item, _, _ = g
    t = tmap.get((div, item))
    if not t:
        continue
    L.append("")
    L.append("-- {} / {} / site={}".format(div, item, t["SCM_SITE_ID"]))
    L.append("MERGE INTO SCM_MGR.DM_PLN_MKT_FCST TGT")
    L.append("USING (")
    L.append("    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,")
    L.append("           INCOTERMS, 'SCM_FCST' AS MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY")
    L.append("      FROM SCM_MGR.DM_PLN_MKT_FCST")
    L.append("     WHERE DIVISION_ID   = '{}'".format(div))
    L.append("       AND ITEM_ID       = '{}'".format(item))
    L.append("       AND SCM_SITE_ID   = '{}'".format(t["SCM_SITE_ID"]))
    L.append("       AND PROJECT_CODE  = '{}'".format(t["PROJECT_CODE"]))
    L.append("       AND DOM_EXP       = '{}'".format(t["DOM_EXP"]))
    L.append("       AND FCST_TYPE     = '{}'".format(t["FCST_TYPE"]))
    L.append("       AND INCOTERMS     = '{}'".format(t["INCOTERMS"]))
    L.append("       AND PLANT_SITE_ID = '{}'".format(t["PLANT_SITE_ID"]))
    L.append("       AND MEASURE       = 'MKT_FCST'")
    L.append("       AND QTY <> 0")
    L.append(") SRC")
    L.append("ON ( TGT.DIVISION_ID = SRC.DIVISION_ID AND TGT.PROJECT_CODE = SRC.PROJECT_CODE")
    L.append(" AND TGT.SCM_SITE_ID = SRC.SCM_SITE_ID AND TGT.ITEM_ID = SRC.ITEM_ID")
    L.append(" AND TGT.DOM_EXP = SRC.DOM_EXP AND TGT.FCST_TYPE = SRC.FCST_TYPE")
    L.append(" AND TGT.INCOTERMS = SRC.INCOTERMS AND TGT.MEASURE = SRC.MEASURE")
    L.append(" AND TGT.PLANT_SITE_ID = SRC.PLANT_SITE_ID AND TGT.YYYYMMDD = SRC.YYYYMMDD )")
    L.append("WHEN NOT MATCHED THEN INSERT (")
    L.append("    DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE,")
    L.append("    INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY,")
    L.append("    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)")
    L.append("VALUES (")
    L.append("    SRC.DIVISION_ID, SRC.PROJECT_CODE, SRC.SCM_SITE_ID, SRC.ITEM_ID, SRC.DOM_EXP,")
    L.append("    SRC.FCST_TYPE, SRC.INCOTERMS, SRC.MEASURE, SRC.PLANT_SITE_ID, SRC.YYYYMMDD,")
    L.append("    SRC.QTY, '{0}', SYSDATE, '{0}', SYSDATE);".format(TAG))

L.append("")
L.append("-- ============================================================================")
L.append("-- §2. 40 BIZ PLAN 보완 — **자동 생성하지 않음**")
L.append("--     대상: {}".format(", ".join(g[2] for g in biz_gaps) or "(없음)"))
L.append("--     사유: DM_PLN_BIZPLAN 은 DEPT_ID·BIZ_TYPE·ITEM_USE·UNIT_ENERGY 등")
L.append("--           MKT_FCST 에 없는 업무 속성을 요구한다. 파생 불가 = 임의값이 되므로 금지.")
L.append("--     조치: DMF0042 화면에서 **직접 입력**하거나, 해당 ITEM 대신")
L.append("--           BIZPLAN 실데이터 보유 ITEM 으로 교체할 것 (아래 조회로 후보 확인)")
L.append("SELECT DIVISION_ID, ITEM_ID, SCM_SITE_ID, COUNT(*) CNT")
L.append("  FROM SCM_MGR.DM_PLN_BIZPLAN WHERE DIVISION_ID='40'")
L.append(" GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID")
L.append(" ORDER BY CNT DESC FETCH FIRST 10 ROWS ONLY;")
L.append("")
L.append("-- ============================================================================")
L.append("-- §3. 실행 후 검증")
L.append("SELECT DIVISION_ID, ITEM_ID, MEASURE, COUNT(*) CNT, MIN(YYYYMMDD) MN, MAX(YYYYMMDD) MX")
L.append("  FROM SCM_MGR.DM_PLN_MKT_FCST WHERE CREATED_BY='{}'".format(TAG))
L.append(" GROUP BY DIVISION_ID, ITEM_ID, MEASURE ORDER BY 1,2,3;")
L.append("")
L.append("-- §4. 원복 (생성분만 삭제 — 기존 데이터 무영향)")
L.append("-- DELETE FROM SCM_MGR.DM_PLN_MKT_FCST WHERE CREATED_BY='{}';".format(TAG))
L.append("-- COMMIT;")

(OUT / "05_SEED_SUPPLEMENT.sql").write_text("\n".join(L), encoding="utf-8")
print("SEED SQL 저장 — SCM_FCST 보완 {}건 / BIZPLAN 수기안내 {}건".format(
    len(scm_gaps), len(biz_gaps)))

# 사전 건수 산출 (읽기 전용)
with conn() as db:
    cur = db.cursor()
    tot = 0
    for g in scm_gaps:
        _, div, item, _, _ = g
        t = tmap[(div, item)]
        cur.execute("""SELECT COUNT(*) FROM SCM_MGR.DM_PLN_MKT_FCST
             WHERE DIVISION_ID=:d AND ITEM_ID=:i AND SCM_SITE_ID=:s AND PROJECT_CODE=:p
               AND DOM_EXP=:de AND FCST_TYPE=:ft AND INCOTERMS=:ic AND PLANT_SITE_ID=:ps
               AND MEASURE='MKT_FCST' AND QTY<>0""",
            d=div, i=item, s=t["SCM_SITE_ID"], p=t["PROJECT_CODE"], de=t["DOM_EXP"],
            ft=t["FCST_TYPE"], ic=t["INCOTERMS"], ps=t["PLANT_SITE_ID"])
        n = cur.fetchone()[0]
        tot += n
        print("   {:20s} 생성예정 {:4d}행".format(item, n))
    print("   합계 {:,}행".format(tot))
