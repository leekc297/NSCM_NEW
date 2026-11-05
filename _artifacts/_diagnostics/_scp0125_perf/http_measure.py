# 화면과 같은 경로(call-proc) 계측 — 파라미터 = FE useWorkbenchStore.setFilters 원문(divisionId/planStartYyyymmdd/versionNo''/nickName''/itemId'')
import io, sys, time, json, requests
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
BASE="http://localhost:8080"; USER="minyonglee1"
s=requests.Session(); r=s.post(f"{BASE}/user/login", json={"userId": USER}, timeout=60); print("[login]", r.status_code)
for sheet, div, ymd in [("stock","81","20260831"),("stock","81","20260907"),("stock","82","20260824"),("stock","40","20260824"),("stockUc","81_UC","20260907")]:
    body={"divisionId":div,"planStartYyyymmdd":ymd,"versionNo":"","nickName":"","itemId":""}
    t=time.time(); rr=s.post(f"{BASE}/SCP0125/{sheet}/SEARCH/call-proc", json=body, timeout=600); el=time.time()-t
    try:
        j=rr.json(); res=j.get("result") or {}; sizes={k:(len(v) if isinstance(v,list) else v) for k,v in res.items()}; note=f"code={j.get('code')} {json.dumps(sizes)[:80]}"
    except Exception: note=f"HTTP {rr.status_code} {rr.text[:80]}"
    print(f"{sheet:<8}{div:<6}{ymd} {el:6.2f}s {note}")
