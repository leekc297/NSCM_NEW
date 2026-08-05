# -*- coding: utf-8 -*-
"""UI SP 직접 콜 검증 — SYS0002(USER) / SYS0014(GROUP_USER) 결과에 14계정 노출 자동 판정.
접속: _artifacts/_diagnostics/ora.py conn_info() 재사용"""
import os
import sys

sys.stdout.reconfigure(encoding="utf-8")
BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.normpath(os.path.join(BASE, "..", "..", "_diagnostics")))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

USERS = {'hongjae.kim', 'eunah.koo', 'yooah.chung', 'dodae',
         'jiwon.park', 'bpark416', 'jaehyeok', 'park6151', 'bottle',
         'wonqthanq', 'ys_cho', 'miyeong.lee', 'yeonjusung', 'coeogus'}
EXPECT_BY_GROUP = {
    'DM ADMIN': {'hongjae.kim', 'jiwon.park', 'wonqthanq'},
    'DM Planner': {'eunah.koo', 'bpark416', 'ys_cho'},
    'DM Planner (W/S)': {'jaehyeok', 'miyeong.lee'},
    'DM Viewer': {'yooah.chung', 'park6151', 'yeonjusung'},
    'SCP Planner': {'dodae', 'bottle', 'coeogus'},
}

fails = []
u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()

    # [1] SYS0002 USER 화면 GET
    rc = con.cursor(); res = con.cursor()
    cur.callproc("SCM_MGR.PKG_SYS0002.SYS0002_GET_MAIN_DATA",
                 [None, None, "ALL", "ALL", "KO", rc, res])
    cols = [c[0].upper() for c in rc.description]
    idx = cols.index("USER_ID")
    got = {r[idx] for r in rc.fetchall()}
    missing = USERS - got
    print(f"[SYS0002 GET] 결과 {len(got)}명 / 14계정 포함: {'OK' if not missing else 'MISSING ' + str(sorted(missing))}")
    if missing:
        fails.append(f"SYS0002 미노출: {sorted(missing)}")

    # [2] SYS0014 그룹 목록
    rc = con.cursor(); res = con.cursor()
    cur.callproc("SCM_MGR.P_SYS0014_GET_GROUP_LIST_M", [None, rc, res])
    cols = [c[0].upper() for c in rc.description]
    gidx = cols.index("USER_GR_ID")
    groups = {r[gidx] for r in rc.fetchall()}
    ok = "SCP Planner" in groups
    print(f"[SYS0014 GROUP_LIST] {len(groups)}그룹 / SCP Planner 포함: {'OK' if ok else 'MISSING'}")
    if not ok:
        fails.append("SYS0014 그룹목록에 SCP Planner 없음")

    # [3] 그룹별 사용자 목록
    for gr, expect in EXPECT_BY_GROUP.items():
        rc = con.cursor(); res = con.cursor()
        cur.callproc("SCM_MGR.P_SYS0014_GET_USER_BY_GROUP_M", [gr, rc, res])
        cols = [c[0].upper() for c in rc.description]
        idx = cols.index("USER_ID")
        got = {r[idx] for r in rc.fetchall()}
        missing = expect - got
        print(f"[SYS0014 USER_BY_GROUP:{gr}] {len(got)}명 / 기대 {len(expect)}명 포함: "
              f"{'OK' if not missing else 'MISSING ' + str(sorted(missing))}")
        if missing:
            fails.append(f"{gr} 미노출: {sorted(missing)}")

    # [4] Division 권한 (대표 3건)
    for gr, uid in (('DM ADMIN', 'hongjae.kim'), ('SCP Planner', 'bottle'), ('DM Viewer', 'yeonjusung')):
        rc = con.cursor(); res = con.cursor()
        cur.callproc("SCM_MGR.P_SYS0014_GET_AUTH_LIST_M", [gr, uid, "D", rc, res])
        rows = rc.fetchall()
        print(f"[SYS0014 AUTH_LIST:{gr}/{uid}] {len(rows)} rows {'OK' if rows else 'EMPTY!'}")
        if not rows:
            fails.append(f"AUTH_LIST 0행: {gr}/{uid}")

print("\n" + ("[FAIL] " + " | ".join(fails) if fails else "[PASS] 전체 검증 통과"))
sys.exit(1 if fails else 0)
