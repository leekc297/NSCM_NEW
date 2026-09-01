# -*- coding: utf-8 -*-
"""DMF0035 MKT 로컬 BE HTTP 실측 — 클라우드 브라우저 응답(B) 대조 기준: 키 이름·행 수"""
import io, sys, json, requests; sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
base, user = "http://localhost:8080", "minyonglee1"
s = requests.Session(); r = s.post(f"{base}/user/login", json={"userId": user}, timeout=30); print("login", r.status_code, (r.json().get("result") or {}).get("userId"))
common = dict(divisionId='40', deptId='ALL', endCustomer='ALL', scmSiteId='ALL', projectCode='ALL', itemId='ALL', itemType='ALL',
              fromYyyymmdd='20260801', toYyyymmdd='20270228', sesUserId=user, plantSiteId='ALL', bizType='ALL', owner='', userId=user, menuId='DMF0035')
mkt = dict(common, versionNo='CURRENT', bucket='WEEKLY', cellYn='N', senderCode='ALL', userDeptId='', groupId='')
title = dict(divisionId='40', bucket='WEEKLY', fromYyyymmdd='20260801', toYyyymmdd='20270228', sesUserId=user, userId=user)
for sheet, body in (("mktFcstSpreadTitle", title), ("mktFcstWaterfall", mkt)):
    r = s.post(f"{base}/DMF0035/{sheet}/SEARCH/call-proc", json=body, timeout=300)
    j = r.json(); res = j.get("result") or {}
    print(sheet, "HTTP", r.status_code, "code", j.get("code"), "result keys", list(res.keys())[:6], {k: (len(v) if isinstance(v, list) else v) for k, v in res.items() if k.lower().startswith(("o_", "code", "msg"))})
    if isinstance(res.get("o_rc1"), list) and res["o_rc1"]: print("   first row keys(앞 12):", list(res["o_rc1"][0].keys())[:12])
