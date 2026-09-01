"""D4 검증: 오류 잔존 배치(53_GATE) 업로드 후 [OK](P_MODE=1) call-proc → CODE='-1' NOLOAD_ERRORS + 원장 delta 0"""
import sys, os, requests
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora, oracledb
B = "http://localhost:8080"; U = "minyonglee1"
f = r"C:\Projects\NSCM\Doc\단위테스트\_excel_upload_cases\DMF0074\53_GATE.xlsx"
u, p, d = ora.conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()
def counts():
    cur.execute("SELECT (SELECT COUNT(*) FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE), (SELECT COUNT(*) FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE_H) FROM DUAL"); return cur.fetchone()
before = counts(); print("ledger before", before)
s = requests.Session(); s.post(f"{B}/user/login", json={"userId": U}, timeout=30)
with open(f, "rb") as fh:
    r = s.post(f"{B}/DMF0074_40/Metal Link Price/UPLOAD/excel-upload", files={"file": ("53_GATE.xlsx", fh)}, timeout=300)
print("upload http", r.status_code, "cnt", (r.json().get("result") or {}).get("O_CUR_CNT"))
r2 = s.post(f"{B}/DMF0074/Metal Link Price/SAVE/call-proc", json={"mode": 1, "createdBy": U, "programId": "DMF0074_40", "sheetName": "Metal Link Price"}, timeout=300)
body = r2.json(); inner = ((body.get("result") or {}).get("o_result_cursor") or [None])[0]
print("OK(P_MODE=1) http", r2.status_code, "code", body.get("code"), "cursor", inner)
after = counts(); print("ledger after ", after, "| delta", (after[0]-before[0], after[1]-before[1]))
ok = inner and str(inner.get("CODE")) == "-1" and after == before
print("D4 VERDICT:", "PASS" if ok else "FAIL")
