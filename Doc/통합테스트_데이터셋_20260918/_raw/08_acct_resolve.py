# -*- coding: utf-8 -*-
"""
Phase 4 — 테스트 계정 권한해석 실측 (08_accounts.json)

배경(정정): 지정서 v1 은 `minyonglee1` 이 3개 권한을 전부 보유한다는 이유로
기본 계정으로 배정했다. 그러나 FE 가 권한을 해석하는 CMBO 3종은 모두
    ORDER BY DECODE(USER_GR_ID,'ADMIN',1,2), USER_GR_ID
로 **ADMIN 을 1행째로 올리고 FE 는 1행만 채택**한다(ForecastPrice.tsx / sales-plan.auth.ts).
따라서 ADMIN 겸직 계정은 화면에서 항상 `ADMIN` 으로 해석되어
`DM Planner` / `SCP Planner` **권한 경계를 검증할 수 없다.**

이 스크립트는 계정별로 CMBO SQL 을 그대로 실행해 **FE 가 실제로 보게 될 authGroup**
을 확정하고, 권한별 권장 계정을 뽑는다. (읽기 전용)
"""
import re, json, pathlib, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent

def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))

# CMBO SQL_ID -> (화면, lookup_type, segment2)  — SCM_ADM_CMBO_SQL_M 실측 본문과 동일
AUTH_CMBO = {
    "DMF0082": ("FcstPriceUserAuthGroup",  "GET_ADMIN_GROUP_MEASURE", "DMF0082"),
    "DMF0021": ("SalesPlanUserAuthGroup",  "GET_ADMIN_GROUP_MEASURE", "DMF0021"),
    "DMF0042": ("BizPlanUserAuthGroup",    "GET_ADMIN_GROUP",         "ALL"),
    "DMF0003": (None,                      "GET_ADMIN_GROUP_MEASURE", "DMF0003"),
}
Q = """SELECT M.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M M
 WHERE M.USER_ID=:u AND M.USE_YN='Y'
   AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
        WHERE L.LOOKUP_TYPE=:lt AND L.VALID_YN='Y'
          AND L.SEGMENT1=M.USER_GR_ID AND L.SEGMENT2=:s2)
 ORDER BY DECODE(M.USER_GR_ID,'ADMIN',1,2), M.USER_GR_ID"""

TARGET_GROUPS = ("DM Planner", "DM Planner (W/S)", "SCP Planner")

with conn() as db:
    cur = db.cursor()

    # CMBO 등록 사전확인
    combos = {}
    for cid in ("MktFcstWsPlannerYn", "FcstPriceUserAuthGroup", "SalesPlanUserAuthGroup",
                "BizPlanUserAuthGroup", "FcstTypeWs", "FcstTypeEditMode",
                "SalesFuturePriceEditableDivision", "MyDivision",
                "DMF0042_BP_Measure", "Dmf0003ScpPlannerEditFlag"):
        cur.execute("""SELECT USE_YN, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI')
                         FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:c""", c=cid)
        r = cur.fetchone()
        combos[cid] = {"USE_YN": r[0], "LAST_UPDATE": r[1]} if r else {"USE_YN": "*미등록*", "LAST_UPDATE": ""}

    cur.execute("""SELECT USER_GR_ID, USER_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
                    WHERE USER_GR_ID IN ('DM Planner','DM Planner (W/S)','SCP Planner')
                      AND USE_YN='Y' ORDER BY 1,2""")
    holders = {}
    for g, u in cur:
        holders.setdefault(g, []).append(u)
    users = sorted({u for v in holders.values() for u in v})

    people = []
    for u in users:
        cur.execute("SELECT USER_NM FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID=:u", u=u)
        r = cur.fetchone(); nm = r[0] if r else ""
        cur.execute("""SELECT CASE WHEN EXISTS(SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
                        WHERE USER_ID=:u AND USER_GR_ID='DM Planner (W/S)')
                       THEN 'Y' ELSE 'N' END FROM DUAL""", u=u)
        ws = cur.fetchone()[0]
        cur.execute("""SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
                        WHERE USER_ID=:u AND USE_YN='Y' ORDER BY 1""", u=u)
        allg = [r[0] for r in cur]
        res = {}
        for scr, (_cmbo, lt, s2) in AUTH_CMBO.items():
            cur.execute(Q, u=u, lt=lt, s2=s2)
            rows = [r[0] for r in cur]
            res[scr] = rows[0] if rows else None
        people.append({"USER_ID": u, "USER_NM": nm, "groups": allg,
                       "wsPlannerYn": ws, "resolved": res,
                       "admin_masked": "ADMIN" in allg})

# 권한별 권장 계정 — FE 해석 결과가 해당 권한과 일치하는 계정만
recommend = {}
for g in TARGET_GROUPS:
    ok, bad = [], []
    for p in people:
        if g not in p["groups"]:
            continue
        if g == "DM Planner (W/S)":
            # W/S 는 authGroup 이 아니라 MktFcstWsPlannerYn 으로 판정.
            # 단 ADMIN 겸직이면 authGroup 이 ADMIN 이 되어 measure 권한이 뒤바뀌므로 제외.
            (bad if p["admin_masked"] else ok).append(p["USER_ID"])
        else:
            hit = p["resolved"].get("DMF0082") == g or p["resolved"].get("DMF0021") == g
            (ok if hit else bad).append(p["USER_ID"])
    recommend[g] = {"사용가능": ok, "사용불가(ADMIN 해석)": bad}

out = {"combos": combos, "holders": holders, "people": people, "recommend": recommend}
(D / "08_accounts.json").write_text(json.dumps(out, ensure_ascii=False, indent=1), encoding="utf-8")

print("CMBO 등록 사전확인")
for k, v in combos.items():
    print("   {:34s} USE_YN={} ({})".format(k, v["USE_YN"], v["LAST_UPDATE"]))
print("\n계정별 FE authGroup 해석")
print("   {:15s} {:4s} {:20s} {:20s} {:20s}".format("USER_ID", "W/S", "DMF0082", "DMF0021", "DMF0042"))
for p in people:
    r = p["resolved"]
    print("   {:15s} {:4s} {:20s} {:20s} {:20s}{}".format(
        p["USER_ID"], p["wsPlannerYn"], str(r["DMF0082"]), str(r["DMF0021"]),
        str(r["DMF0042"]), "   ⚠ADMIN겸직" if p["admin_masked"] else ""))
print("\n권한별 권장 계정")
for g, v in recommend.items():
    print("   {:20s} 사용가능={}  사용불가={}".format(g, v["사용가능"], v["사용불가(ADMIN 해석)"]))
