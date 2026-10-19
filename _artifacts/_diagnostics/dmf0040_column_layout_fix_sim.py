"""dmf0040_column_layout_fix_sim.py — 수정 후 store 로직(division 바뀌면 titleSet 재조회) 재현 — 40→81→82→40. 2026-09-14"""
import requests
s = requests.Session(); s.post("http://localhost:8080/user/login", json={"userId": "minyonglee1"}, timeout=30)
def layout(div):
    rows = (s.post("http://localhost:8080/DMF0040/titleSet/SEARCH/call-proc", json={"programId":"DMF0040","sheetName":"Mkt Fcst Waterfall","columnType":"C","divisionId":div}, timeout=60).json().get("result") or {}).get("o_rc1") or []
    return [r["COLUMN_NAME"] for r in rows if str(r.get("USER_FLAG")) == "Y"]
def columns(div):
    return s.post("http://localhost:8080/admin/menu/DMF0040/column", json={"sheetNm":"Mkt Fcst Waterfall","divisionId":div}, timeout=60).json().get("result") or []
def apply(cols, lay):
    if lay is None: return [c["colNm"] for c in cols if c.get("display")]
    names = set(lay)
    return [c["colNm"] for c in cols if c["colNm"] in names or (c.get("personalizable") is False and c.get("visible") is True)]
state = {"layout": None, "div": ""}
for div in ("40", "81", "82", "40"):
    old = dict(state)
    if state["layout"] is None or state["div"] != div:          # ⭐ 수정된 조건
        lay = layout(div); state["layout"] = lay or None; state["div"] = div
    shown = apply(columns(div), state["layout"])
    before = apply(columns(div), old["layout"]) if old["layout"] is not None else shown   # 수정 전(최초 레이아웃 재사용)
    ec = lambda xs: [x for x in xs if x.startswith(("END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID"))]
    print(f"div{div}: 수정 후 End Customer·Sales Site·Model = {ec(shown)}   | 수정 전 = {ec(before) if old['layout'] is not None else '(최초 진입)'}")
