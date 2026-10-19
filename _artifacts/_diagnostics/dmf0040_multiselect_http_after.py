import requests, time
s = requests.Session(); s.post("http://localhost:8080/user/login", json={"userId": "minyonglee1"}, timeout=30)
base = {"divisionId":"81","scmSiteId":"ALL","plantSiteId":"ALL","teamId":"ALL","customer":"ALL","bizType":"ALL","projectCode":"","itemId":"",
        "fromYyyymmdd":"20260914","toYyyymmdd":"20261130","sesUserId":"minyonglee1","versionNo":"Current","itemType":"ALL","owner":"",
        "diffOnly":"False","bucket":"MONTHLY","userId":"minyonglee1","mnuId":"DMF0040"}
for label, ov in (("81 Plant Site WA00-P", {"plantSiteId": "WA00-P"}), ("81 Plant Site WA00-P,HQ07-A", {"plantSiteId": "WA00-P,HQ07-A"}),
                  ("40 End Customer LGE", {"divisionId": "40", "customer": "LGE"}), ("40 End Customer NT", {"divisionId": "40", "customer": "NT"}),
                  ("40 End Customer LGE,NT", {"divisionId": "40", "customer": "LGE,NT"})):
    t = time.time(); r = s.post("http://localhost:8080/DMF0040/mktFcstComparison/SEARCH/call-proc", json={**base, **ov}, timeout=600); b = r.json()
    print(f"{label:30} http={r.status_code} code={b.get('code')} rows={len((b.get('result') or {}).get('o_rc1') or [])} msg={(b.get('message') or '')[:80]} {time.time()-t:.0f}s", flush=True)
