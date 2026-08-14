#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0014 Excel Form — FE 축 원인 규명.
 ① /admin/menu/DMF0014/column 응답(양식 컬럼 단일 원천) — 0행이면 미리보기에 정보 컬럼이 없다
 ② 버튼 권한 응답(hasButton('FORM_DATA')) — false 면 버튼 자체가 안 뜬다
"""
import io, json, sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import requests

BASE = "http://localhost:8080"
USER = sys.argv[1] if len(sys.argv) > 1 else "minyonglee1"
MENU = "DMF0014"

sess = requests.Session()
r = sess.post(f"{BASE}/user/login", json={"userId": USER}, timeout=30)
print(f"[login] guest={(r.json().get('result') or {}).get('guest')}")

print("\n" + "=" * 92)
print("## ① POST /admin/menu/DMF0014/column  (sheetNm='FCST Upload')")
r = sess.post(f"{BASE}/admin/menu/{MENU}/column", json={"sheetNm": "FCST Upload"}, timeout=60)
print(f"   HTTP {r.status_code}")
body = r.json()
res = body.get("result")
print(f"   code={body.get('code')} / result type={type(res).__name__}")
if isinstance(res, list):
    print(f"   {len(res)}행")
    for c in res:
        print(f"     colNm={c.get('colNm'):<24} lbl={str(c.get('colLblNm')):<22} "
              f"visible={c.get('visible')} display={c.get('display')} inputTpCd={c.get('inputTpCd')}")
else:
    print(f"   {json.dumps(res, ensure_ascii=False)[:400]}")

print("\n" + "=" * 92)
print("## ② 버튼 권한 (hasButton 원천)")
for path, payload in [
    (f"/admin/menu/{MENU}/button", {}),
    (f"/admin/menu/{MENU}/btn", {}),
]:
    try:
        rr = sess.post(f"{BASE}{path}", json=payload, timeout=30)
        if rr.status_code != 200:
            print(f"   {path} → HTTP {rr.status_code}"); continue
        b = rr.json().get("result")
        print(f"   {path} → {type(b).__name__}")
        if isinstance(b, list):
            codes = [x.get("mnuBtnCd") or x.get("MNU_BTN_CD") for x in b]
            print(f"      버튼 {len(b)}종 = {codes}")
            print(f"      FORM_DATA 포함 = {'FORM_DATA' in codes}")
    except Exception as e:
        print(f"   {path} → {str(e)[:80]}")
