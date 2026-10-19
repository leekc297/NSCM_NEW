"""dmf0074_2tier_save_roundtrip.py — AS-IS 2단 양식 정상 1행 업로드(P_MODE=0) → [OK] 저장(P_MODE=1 call-proc)
→ 원장 DM_BPS_METAL_LINK_PRICE 적재 확인 → 적재분 삭제·원복 확인. 2026-09-14"""
import pathlib, requests, openpyxl, oracledb
SRC = r"C:\TRANFILE\RECEIVE\DMF0074_MetalLinkPricePopup_ASIS.xlsx"
OUT = pathlib.Path(r"C:\Users\ejene\AppData\Local\Temp\claude\c--Projects-NSCM\0ea4cbc9-b2ef-4b42-8284-e360f3928fc5\scratchpad\dmf0074_2tier_save.xlsx")
wb = openpyxl.load_workbook(SRC); ws = wb.active
for c in ws[3]: c.value = None
row = {"A": "40", "B": 202610, "C": "TC_SAVE", "D": "Isuzu", "E": "MPCISZISLD1V", "F": "Y", "G": "Isuzu_JP_TYO", "H": "USD", "I": "Mass", "J": "N",
       "L": "M035", "S": 6, "Z": 0, "AG": 18.5, "AN": 0.75, "AU": 0.42}
for k, v in row.items(): ws[f"{k}3"] = v
wb.save(OUT)
con = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1"); cur = con.cursor()
cnt = lambda: cur.execute("SELECT COUNT(*) FROM DM_BPS_METAL_LINK_PRICE WHERE DIVISION_ID='40'").fetchone()[0]
total = lambda: cur.execute("SELECT COUNT(*) FROM DM_BPS_METAL_LINK_PRICE").fetchone()[0]
b40, btot = cnt(), total(); print("before div40", b40, "total", btot)
s = requests.Session(); s.post("http://localhost:8080/user/login", json={"userId": "minyonglee1"}, timeout=30)
with open(OUT, "rb") as fh:
    body = s.post("http://localhost:8080/DMF0074_40/Metal Link Price/UPLOAD/excel-upload", files={"file": (OUT.name, fh)}, timeout=600).json()
print("validate", body["result"]["O_CUR_CNT"], [ (x.get("EXCEL_ROW"), x.get("MESSAGE_TEXT")) for x in body["result"]["O_CUR_LIST"] ])
r = s.post("http://localhost:8080/DMF0074/Metal Link Price/SAVE/call-proc",
           json={"mode": 1, "createdBy": "minyonglee1", "programId": "DMF0074_40", "sheetName": "Metal Link Price"}, timeout=600)
j = r.json(); print("save http", r.status_code, "code", j.get("code"), "cursor", (j.get("result") or {}).get("o_result_cursor"))
con.commit()
a40 = cnt(); print("after div40", a40)
cur.execute("""SELECT DIVISION_ID, PLAN_YYYYMM, END_CUSTOMER, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, CURRENCY, FCST_TYPE, METAL_LINK_YN, METAL_EXCEPTION_YN,
               METAL_KIND_CODE, APPLY_PRICE_TYPE_CODE, FROM_PERIOD_YYYYMM, TO_PERIOD_YYYYMM, CONTRACT_UNIT_PRICE, METAL_APPLY_UNIT_PRICE, METAL_REQR_QTY, CREATED_BY
               FROM DM_BPS_METAL_LINK_PRICE WHERE DIVISION_ID='40' ORDER BY METAL_KIND_CODE""")
for x in cur.fetchall(): print("  ", x)
# 원복 — 40 은 사전 0행이었으므로 이번 적재분만 존재
cur.execute("DELETE FROM DM_BPS_METAL_LINK_PRICE WHERE DIVISION_ID='40' AND PLAN_YYYYMM='202610' AND ITEM_ID='MPCISZISLD1V' AND CREATED_BY='minyonglee1'")
print("deleted", cur.rowcount); con.commit()
print("restored div40", cnt(), "(before", b40, ") total", total(), "(before", btot, ")")
