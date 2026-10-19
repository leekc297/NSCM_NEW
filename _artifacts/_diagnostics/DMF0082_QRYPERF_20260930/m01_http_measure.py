#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 조회 — 화면 Search 1회가 쏘는 호출을 HTTP 경로로 시간 측정 (2026-09-30 재작성).

_0082_measure.py(2026-08-15) 이후 FE 계약이 바뀌어 새로 만든다. 파라미터 근거 = FE 원문:
  · 본문 = 필터 객체 그대로 (axios.post 의 {data} 는 요청 config — {data:..} 래핑 시 BE 파라미터 NULL, 09-30 실측)
  · 미선택 멀티필터 = 'ALL'           — useForecastPriceStore.joinComma (빈 배열 → 'ALL')
  · itemId 미선택 = ''                — 〃 setFilters L352
  · sesUserId 전송                    — 〃 setFilters L355
  · userGroup = CMBO 'FcstPriceUserAuthGroup' 첫 행 CODE, 없으면 userId  — ForecastPrice.tsx L228~234
  · 기간 = 당월1일 ~ +6개월-1일        — makeInitSearchParams (PR_GET_DAY_RANGE month=6)
  · Search 1회 = FcstNPrice + spreadTitle (ForecastPrice.tsx L205~219 useTabProcQuery 2본)
사용: python m01_http_measure.py <div> [반복수]
"""
import io, sys, time, json, datetime, requests
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

BASE = "http://localhost:8080"
USER = "minyonglee1"
DIV = sys.argv[1] if len(sys.argv) > 1 else "40"
REP = int(sys.argv[2]) if len(sys.argv) > 2 else 1

today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
FRM, TO = frm.strftime("%Y%m%d"), to.strftime("%Y%m%d")

s = requests.Session()
r = s.post(f"{BASE}/user/login", json={"userId": USER}, timeout=60)
print(f"[login] HTTP {r.status_code}")

cr = s.post(f"{BASE}/admin/combo", json={"comboId": "FcstPriceUserAuthGroup", "mnuId": "DMF0082"}, timeout=120)
try:
    rows = cr.json().get("result") or []
except Exception:
    rows = []
group = str(rows[0].get("CODE")) if rows and rows[0].get("CODE") else USER
print(f"[authGroup] {group}  (combo rows={len(rows)})  기간 {FRM}~{TO}  div={DIV}\n")

main = {
    "divisionId": DIV, "deptId": "ALL", "endCustomer": "ALL", "bizType": "ALL",
    "fromYyyymmdd": FRM, "toYyyymmdd": TO, "salesSite": "ALL", "itemId": "",
    "versionType": "Current", "qtyYn": "N", "sesUserId": USER, "userGroup": group,
    "plantSiteId": "ALL", "projectCode": "ALL", "owner": "ALL", "senderCode": "ALL",
}
title = {"startYyyymmdd": FRM, "endYyyymmdd": TO, "sesUserId": USER, "divisionId": DIV}
CALLS = [("FcstNPrice", main), ("spreadTitle", title)]

for it in range(REP):
    print(f"--- run {it + 1}")
    for sheet, body in CALLS:
        t0 = time.time()
        rr = s.post(f"{BASE}/DMF0082/{sheet}/SEARCH/call-proc", json=body, timeout=3600)
        el = time.time() - t0
        try:
            j = rr.json()
            res = j.get("result") or {}
            sizes = {k: (len(v) if isinstance(v, list) else v) for k, v in res.items()} if isinstance(res, dict) else res
            note = f"code={j.get('code')} {json.dumps(sizes, ensure_ascii=False)[:150]}"
        except Exception:
            note = f"HTTP {rr.status_code} {rr.text[:100]}"
        print(f"{'★' if el >= 3 else ' '}{sheet:<14}{el:>8.2f}s  bytes={len(rr.content):>10,}  {note}")
