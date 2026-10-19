"""[E20260908-XLSMONTH] DMF0082 Excel Form → Upload 왕복 E2E (검증단계 P_MODE=0, 원장 미변경).
   Form SP 행으로 M0~M12 양식 xlsx 를 만들어 실제 BE /excel-upload 에 올리고,
   기간 컬럼 인식(V_TITLE ATTRIBUTE11~23) + 월→일자 전개(GT_DMF0082_FCST_PRICE_DAILY) 를 실측한다."""
import sys, os, datetime, requests, oracledb
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import ora
from openpyxl import Workbook

BASE, USER, DIV = "http://localhost:8080", "minyonglee1", "81"
PROG, SHEET = "DMF0082", "FcstNPrice"
u, p, d = ora.conn_info(); con = oracledb.connect(user=u, password=p, dsn=d); cur = con.cursor()

# 1) Form SP 로 실제 양식 행 확보 (선두 3행만)
rc1 = cur.var(oracledb.DB_TYPE_CURSOR); res = cur.var(oracledb.DB_TYPE_CURSOR)
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA",
  [DIV,'ALL','ALL','ALL','20260901','20270831','ALL','','Current','N',USER,USER,
   'ALL','ALL','ALL','ALL', rc1, res])
crs = rc1.getvalue(); cols = [c[0] for c in crs.description]; rows = crs.fetchmany(3)
print("Form 행 확보:", len(rows), "| 컬럼", len(cols))

TOKEN = {'DIVISION_ID':'Div','PROJECT_CODE':'Project Code','SCM_SITE_ID':'Sales Site',
         'PLANT_SITE_ID':'Plant Site','ITEM_ID':'Model','CURRENCY':'Currency','MEASURE':'Measure',
         'DOM_EXP':'Customs Handbook','FCST_TYPE':'FCST Type','INCOTERMS':'Incoterms'}
MONTHS = [f"M{i}" for i in range(13)]
idx = {c: i for i, c in enumerate(cols)}

# 2) 양식 xlsx 생성 — 헤더 = 토큰 10 + M0~M12 (원형)
wb = Workbook(); ws = wb.active; ws.title = "Sheet1"
header = [TOKEN[c] for c in TOKEN] + MONTHS
ws.append(header)
TEST_PRICE = 1234.5
for r in rows:
    line = [str(r[idx[c]] or '') for c in TOKEN]
    line += [TEST_PRICE if m in ('M0', 'M12') else '' for m in MONTHS]   # M0/M12 만 값 (경계 2개)
    ws.append(line)
path = os.path.join(os.environ.get('TEMP','.'), "DMF0082_XLSMONTH_E2E.xlsx"); wb.save(path)
print("xlsx 생성:", path, "| 헤더", len(header), "| 데이터행", len(rows))

# 3) 실제 BE 업로드 (검증·분류 = P_MODE=0)
s = requests.Session()
r = s.post(f"{BASE}/user/login", json={"userId": USER}, timeout=30); assert r.status_code == 200, r.text[:200]
with open(path, "rb") as fh:
    resp = s.post(f"{BASE}/{PROG}/{SHEET}/UPLOAD/excel-upload",
                  files={"file": (os.path.basename(path), fh,
                         "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")}, timeout=600)
print("HTTP", resp.status_code, "| body head:", resp.text[:160].replace("\n", " "))

# 4) 스테이징 실측 — 기간 헤더가 ATTRIBUTE11~23 에 M0~M12 로 들어갔는가
cur.execute("""SELECT ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,
                      ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23
                 FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND CREATED_BY=:u AND UPLOAD_STATUS_CODE='V_TITLE'
                  AND CREATION_DATE=(SELECT MAX(CREATION_DATE) FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                                      WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND CREATED_BY=:u)""",
            p=PROG, s=SHEET, u=USER)
t = cur.fetchone()
print("V_TITLE 기간 슬롯(ATTRIBUTE11~23):", list(t) if t else "없음")

cur.execute("""SELECT UPLOAD_STATUS_CODE, SUBSTR(MESSAGE_TEXT,1,90), COUNT(*)
                 FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND CREATED_BY=:u
                  AND NVL(UPLOAD_STATUS_CODE,'-') NOT IN ('V_TITLE','@TITLE')
                  AND CREATION_DATE=(SELECT MAX(CREATION_DATE) FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                                      WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND CREATED_BY=:u)
                GROUP BY UPLOAD_STATUS_CODE, SUBSTR(MESSAGE_TEXT,1,90)""", p=PROG, s=SHEET, u=USER)
print("분류 결과:")
for row in cur: print("   ", row)
