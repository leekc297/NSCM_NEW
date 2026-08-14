#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 40 division 조회 — 화면이 실제로 쏘는 **시트별 호출을 각각 시간 측정**.

파라미터 근거(추정 아님):
  · 미선택 필터 = 빈 문자열      — FE `useForecastPriceStore.setFilters` 원문
  · versionType = 'Current'      — 〃 initSearchParams
  · qtyYn       = 'N'            — 〃 (기본 false)
  · userGroup   = **userId**     — CMBO 'FcstPriceUserAuthGroup' 이 사내 미등록 →
                                   스토어 주석대로 userId fallback (2026-08-15 실측)
  · 기간        = 당월1일 ~ +6개월-1일 (PR_GET_DAY_RANGE month=6 규약)
"""
import io, sys, time, json, requests
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

BASE = "http://localhost:8080"
USER = "minyonglee1"
DIV  = sys.argv[1] if len(sys.argv) > 1 else "40"
FRM  = sys.argv[2] if len(sys.argv) > 2 else "20260801"
TO   = sys.argv[3] if len(sys.argv) > 3 else "20270131"
E    = ""

s = requests.Session()
r = s.post(f"{BASE}/user/login", json={"userId": USER}, timeout=60)
print(f"[login] HTTP {r.status_code}\n")

main = {
    "divisionId": DIV, "deptId": E, "endCustomer": E, "bizType": E,
    "fromYyyymmdd": FRM, "toYyyymmdd": TO, "salesSite": E, "itemId": E,
    "versionType": "Current", "qtyYn": "N", "userGroup": USER,
    "plantSiteId": E, "projectCode": E, "owner": E, "senderCode": E,
}
title = {"startYyyymmdd": FRM, "endYyyymmdd": TO, "divisionId": DIV, "sesUserId": USER}

CALLS = [
    ("titleSet",          {"divisionId": DIV, "sesUserId": USER}),
    ("version",           {"divisionId": DIV, "sesUserId": USER}),
    ("spreadTitle",       title),
    ("futurePriceInfo",   {"divisionId": DIV, "sesUserId": USER}),
    ("savePriceTitle",    {"divisionId": DIV, "sesUserId": USER}),
    ("savePriceData",     {"divisionId": DIV, "sesUserId": USER}),
    ("FcstNPrice",        main),          # ← 메인 (병목 후보)
]

print(f"{'시트':<20}{'초':>9}   결과")
print("-" * 78)
total = 0.0
for sheet, body in CALLS:
    t0 = time.time()
    try:
        rr = s.post(f"{BASE}/DMF0082/{sheet}/SEARCH/call-proc", json=body, timeout=3600)
        el = time.time() - t0
        total += el
        try:
            j = rr.json()
            res = j.get("result") or {}
            sizes = {k: (len(v) if isinstance(v, list) else v) for k, v in res.items()}
            note = f"code={j.get('code')} {json.dumps(sizes, ensure_ascii=False)}"
        except Exception:
            note = f"HTTP {rr.status_code} {rr.text[:70]}"
    except Exception as ex:
        el = time.time() - t0
        total += el
        note = f"EXCEPTION {str(ex)[:60]}"
    flag = "★" if el >= 5 else " "
    print(f"{flag}{sheet:<19}{el:>9.2f}   {note[:120]}")
print("-" * 78)
print(f"{'합계':<20}{total:>9.2f}")
