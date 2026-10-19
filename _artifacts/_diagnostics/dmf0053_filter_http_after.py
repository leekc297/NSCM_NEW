import requests, collections
s = requests.Session(); s.post("http://localhost:8080/user/login", json={"userId": "minyonglee1"}, timeout=30)
base = {"divisionId":"81","deptId":"ALL","endCustomer":"ALL","scmSiteId":"ALL","projectCode":"","itemId":"","itemType":"ALL",
        "fromYyyymmdd":"20260701","toYyyymmdd":"20270228","sesUserId":"minyonglee1","plantSiteId":"ALL","bizType":"ALL","owner":"",
        "bucket":"MONTHLY","userDeptId":"","groupId":"","versionNo":"","fromCreatedate":"20260901","toCreatedate":"20260914","userId":"minyonglee1","mnuId":"DMF0053"}
for label, ov, col in (("Project A18BW2003,A15BW7002", {"projectCode": "A18BW2003,A15BW7002"}, "PROJECT_CODE"),
                       ("Model APBMW48CL-B1-1Y0,APBMW48CL-A2-7X0", {"itemId": "APBMW48CL-B1-1Y0,APBMW48CL-A2-7X0"}, "ITEM_ID"),
                       ("Owner hkslee", {"owner": "hkslee"}, None)):
    b = s.post("http://localhost:8080/DMF0053/custFcstWaterfall/SEARCH/call-proc", json={**base, **ov}, timeout=600).json()
    rows = (b.get("result") or {}).get("o_rc1") or []
    dist = collections.Counter(str(r.get(col)) for r in rows) if col else None
    print(f"{label:42} code={b.get('code')} rows={len(rows)} {'값 분포=' + str(dict(dist)) if dist else ''}")
