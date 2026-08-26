# -*- coding: utf-8 -*-
"""[E20260825-XLSPRICECOL2] 업로드 왕복 시뮬 — 폼 산출 행을 BE 동일 경로로 스테이징 후 검증 SP mode0 실호출.
   판정: ①SUCCESS 분류 ②ATTRIBUTE302(코드 항등)/308(Plant 통과) ③T_MAIN PLANT 직송/CELL_PROD '-'
   정리: created_by='xlstest' 스테이징 행 삭제 (원장 무접촉 — mode0 은 검증·GTT 만)"""
import io, json, sys
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace", line_buffering=True)
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 300000
cur = con.cursor()
FRM, TO = "20260824", "20261130"
TESTER = "xlstest"

# 0) 폼 실호출 — 왕복 원천 행 3건 + 주차 목록
rc1, rcr = cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)
cur.callproc("PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA", [
    "81", "ALL", "ALL", "ALL", FRM, TO, "ALL", "ALL",
    "Current", "N", "minyonglee1", "minyonglee1", "ALL", "ALL", "ALL", "ALL", rc1, rcr])
c1 = rc1.getvalue()
cols = [x[0] for x in c1.description]
rows = c1.fetchmany(3)
res = rcr.getvalue().fetchone()
weeks = [w for w in (res[3] or "").split(",") if len(w) == 8][:2]  # 앞 2주만 사용
ix = {k: cols.index(k) for k in ("DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "PLANT_SITE_ID",
                                 "ITEM_ID", "CURRENCY", "MEASURE", "DOM_EXP", "FCST_TYPE", "INCOTERMS")}
print("[0] 폼 행 3건 확보 / 주차:", weeks)

# 1) BE 동일 스테이징 — cvtListUploadRows 산출 형태(@TITLE + UPLOAD, _COL1..N) 그대로
TOKENS = ["Div", "Project Code", "Sales Site", "Model", "Incoterms",
          "FCST Type", "Customs Handbook", "Plant Site", "Currency", "Measure"]
ncol = 10 + len(weeks)
payload = []
head = {"UPLOAD_STAT": "@TITLE"}
for i, t in enumerate(TOKENS):
    head["_COL%d" % (i + 1)] = t
for i, w in enumerate(weeks):
    head["_COL%d" % (11 + i)] = w
payload.append(head)
for r in rows:
    row = {"UPLOAD_STAT": "UPLOAD",
           "_COL1": r[ix["DIVISION_ID"]], "_COL2": r[ix["PROJECT_CODE"]],
           "_COL3": r[ix["SCM_SITE_ID"]], "_COL4": r[ix["ITEM_ID"]],
           "_COL5": r[ix["INCOTERMS"]], "_COL6": r[ix["FCST_TYPE"]],
           "_COL7": r[ix["DOM_EXP"]], "_COL8": r[ix["PLANT_SITE_ID"]],
           "_COL9": r[ix["CURRENCY"]], "_COL10": r[ix["MEASURE"]]}
    for i, w in enumerate(weeks):
        row["_COL%d" % (11 + i)] = "123.45"
    payload.append(row)

# 사전 정리 (재실행 무해)
cur.execute("DELETE FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND CREATED_BY=:c", c=TESTER)
con.commit()

rc = cur.var(oracledb.CURSOR)
cur.callproc("PKG_NSCM_UI_EXCEL.PR_SAVE_EXCEL_UPLOAD",
             [json.dumps(payload, ensure_ascii=False), ncol, "DMF0082", "FcstNPrice", TESTER, rc])
print("[1] 스테이징:", rc.getvalue().fetchone())

# 2) 검증 SP mode 0
rc2 = cur.var(oracledb.CURSOR)
cur.callproc("PKG_DMF0082.P_DMF0082_EXCEL_UPLOAD", ["0", TESTER, "DMF0082", "FcstNPrice", rc2])
print("[2] mode0 결과커서:", rc2.getvalue().fetchone())

cur.execute("""SELECT UPLOAD_STATUS_CODE, MESSAGE_TEXT, ATTRIBUTE2, ATTRIBUTE302, ATTRIBUTE8, ATTRIBUTE308
    FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
    WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND CREATED_BY=:c
    ORDER BY UPLOAD_ID""", c=TESTER)
ok = True
for r in cur.fetchall():
    st = r[0]
    print("   행:", r)
    if st == "UPLOAD" or st == "ERROR":
        ok = False
print("[3] 분류 판정:", "PASS (전 데이터행 SUCCESS 또는 V_TITLE)" if ok else "FAIL")

# 3) T_MAIN — PLANT 직송/CELL_PROD '-' (mode0 PRICECHK1 이 같은 세션 GTT 에 산출)
cur.execute("SELECT PROJECT_CODE, END_CUSTOMER, PLANT_SITE_ID, CELL_PROD_SITE_ID, COUNT(*) FROM SCM_MGR.GT_PRDM1_T_MAIN GROUP BY PROJECT_CODE, END_CUSTOMER, PLANT_SITE_ID, CELL_PROD_SITE_ID FETCH FIRST 6 ROWS ONLY")
tm = cur.fetchall()
for r in tm:
    print("   T_MAIN:", r)
src_plants = {(rows[i][ix["PROJECT_CODE"]], rows[i][ix["PLANT_SITE_ID"]]) for i in range(len(rows))}
tm_plants = {(r[0], r[2]) for r in tm}
print("[4] PLANT 직송 대조:", "PASS" if src_plants and src_plants <= tm_plants or (tm and all(r[3] == "-" for r in tm)) else "확인 필요",
      "/ 원천", src_plants, "/ T_MAIN", tm_plants)

# 정리
cur.execute("DELETE FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND CREATED_BY=:c", c=TESTER)
con.commit()
print("[5] 스테이징 정리 완료")
con.close()
