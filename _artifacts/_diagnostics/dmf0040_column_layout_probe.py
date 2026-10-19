import requests
s = requests.Session(); s.post("http://localhost:8080/user/login", json={"userId": "minyonglee1"}, timeout=30)
def layout(div):
    rows = (s.post("http://localhost:8080/DMF0040/titleSet/SEARCH/call-proc", json={"programId":"DMF0040","sheetName":"Mkt Fcst Waterfall","columnType":"C","divisionId":div}, timeout=60).json().get("result") or {}).get("o_rc1") or []
    return rows
def columns(div):
    return s.post("http://localhost:8080/admin/menu/DMF0040/column", json={"sheetNm":"Mkt Fcst Waterfall","divisionId":div}, timeout=60).json().get("result") or []
for div in ("40", "81", "82"):
    rows = layout(div); cols = columns(div)
    y = [r["COLUMN_NAME"] for r in rows if str(r.get("USER_FLAG")) == "Y"]
    print(f"== div{div} titleSet rows={len(rows)} USER_FLAG=Y({len(y)}): {y}")
    print(f"   titleSet END_CUSTOMER 행: {[ (r['COLUMN_NAME'], r.get('USER_FLAG')) for r in rows if 'END_CUSTOMER' in r['COLUMN_NAME']]}")
    print(f"   /column 표시(display=True): {[c['colNm'] for c in cols if c.get('display')]}")
# FE applyLayoutToColumns 재현 — 최초 진입 division 의 layout 을 이후 division 에 그대로 적용 (store: userColumnLayout !== null 이면 재조회 안 함)
def apply(cols, lay):
    names = set(lay)
    return [c["colNm"] for c in cols if (c["colNm"] in names) or (c.get("personalizable") is False and c.get("visible") is True)]
L40 = [r["COLUMN_NAME"] for r in layout("40") if str(r.get("USER_FLAG")) == "Y"]
L81 = [r["COLUMN_NAME"] for r in layout("81") if str(r.get("USER_FLAG")) == "Y"]
for seq, lay in (("40 진입 → 81 선택", L40), ("81 진입 → 40 선택", L81)):
    tgt = seq[-5:-3]
    shown = apply(columns(tgt), lay)
    print(f"[재현] {seq}: 표시 컬럼 = {shown}  | END_CUSTOMER 계열 표시 = {[c for c in shown if 'END_CUSTOMER' in c]}")
