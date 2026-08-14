#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form — HTTP call-proc E2E 재현 (SP 단독은 정상인데 화면에서 0건인 원인 규명).

축: ①로그인 ②메인 SEARCH(대조군 — 같은 filters 로 데이터가 나오는지) ③FORM_DATA(문제 축)
    ④응답 원문 구조(키/건수/결과커서)까지 전부 덤프 — "0건" 이 어느 단계에서 생기는지 가른다.
"""
import io, json, sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import requests

BASE = "http://localhost:8080"
USER = sys.argv[1] if len(sys.argv) > 1 else "minyonglee1"
MENU = "DMF0014"
SHEET = "FCST Upload"

sess = requests.Session()
r = sess.post(f"{BASE}/user/login", json={"userId": USER}, timeout=30)
info = (r.json() or {}).get("result") or {}
print(f"[login] HTTP {r.status_code} guest={info.get('guest')} groups={info.get('groups')} div={info.get('div')}")
if info.get("guest") is not False:
    sys.exit("⛔ 게스트 폴백 — 검증 무의미")

# FE store.filters[MAIN] 과 동일 payload (useCustomerFcstUploadStore 실측 15키)
filters = {
    "divisionId": "81",
    "deptId": "ALL",
    "endCustomer": "ALL",
    "scmSiteId": "ALL",
    "plantSiteId": "ALL",
    "projectCode": "",
    "itemId": "",
    "startYyyymmdd": "20260601",
    "endYyyymmdd": "20261231",
    "bucketType": "WEEKLY",
    "domExp": "ALL",
    "createdBy": USER,
    "userinfo": "ADMIN",
    "sesUserId": USER,
    "mnuId": MENU,
}


def call(btn, payload):
    print("\n" + "=" * 92)
    print(f"## POST /{MENU}/{SHEET}/{btn}/call-proc")
    res = sess.post(f"{BASE}/{MENU}/{SHEET}/{btn}/call-proc", json=payload, timeout=300)
    print(f"   HTTP {res.status_code}")
    try:
        body = res.json()
    except Exception:
        print(f"   (JSON 아님) {res.text[:300]}"); return None
    print(f"   code={body.get('code')} message={str(body.get('message'))[:120]}")
    result = body.get("result")
    if not isinstance(result, dict):
        print(f"   result={str(result)[:300]}"); return body
    for k, v in result.items():
        if isinstance(v, list):
            print(f"   result.{k} = {len(v)}행")
            if v:
                print(f"      키({len(v[0])}) = {list(v[0].keys())}")
                print(f"      1행 = {json.dumps(v[0], ensure_ascii=False)[:260]}")
        else:
            print(f"   result.{k} = {str(v)[:160]}")
    return body


call("SEARCH", filters)      # 대조군 — 같은 조건에서 메인은 나오는가
call("FORM_DATA", filters)   # 문제 축
