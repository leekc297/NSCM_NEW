"""dmf0074_asis_ci_numeric_probe.py — AS-IS(MSSQL CI·ISNUMERIC) 에서는 통과하던 입력이 TO-BE 에서 어떤 메시지로 나오는지 실측. 2026-09-14"""
import pathlib, requests, openpyxl, oracledb
SRC = r"C:\TRANFILE\RECEIVE\DMF0074_MetalLinkPricePopup_ASIS.xlsx"
OUT = pathlib.Path(r"C:\Users\ejene\AppData\Local\Temp\claude\c--Projects-NSCM\0ea4cbc9-b2ef-4b42-8284-e360f3928fc5\scratchpad\dmf0074_ci_probe.xlsx")
base = {"A": "40", "D": "Isuzu", "E": "MPCISZISLD1V", "F": "Y", "G": "Isuzu_JP_TYO", "H": "USD", "I": "Mass", "J": "N",
        "L": "M035", "S": "6", "Z": "0", "AG": "18.5", "AN": "0.75", "AU": "0.42"}
cases = [("CTRL 기준(정상)", {}),
         ("FCST type 소문자 mass", {"I": "mass"}), ("End Customer 대문자 ISUZU", {"D": "ISUZU"}),
         ("Sales Site 소문자", {"G": "isuzu_jp_tyo"}), ("Currency 소문자 usd", {"H": "usd"}),
         ("Key 코드 소문자 m035", {"L": "m035"}), ("Metal Link 소문자 y", {"F": "y"}),
         ("Exception 소문자 n", {"J": "n"}), ("Contract Price .5", {"AG": ".5"}),
         ("Contract Price 5.", {"AG": "5."}), ("Period(Fr) +6", {"S": "+6"})]
wb = openpyxl.load_workbook(SRC); ws = wb.active
for c in ws[3]: c.value = None
meta = []
for i, (title, ov) in enumerate(cases):
    r = 3 + i; y, m = divmod(10 + i, 12)
    vals = {**base, "B": f"{2026 + y}{m + 1:02d}", "C": f"CI{i:02d}", **ov}
    for k, v in vals.items(): ws[f"{k}{r}"] = v
    meta.append((r, f"CI{i:02d}", title))
wb.save(OUT)
s = requests.Session(); s.post("http://localhost:8080/user/login", json={"userId": "minyonglee1"}, timeout=30)
with open(OUT, "rb") as fh:
    body = s.post("http://localhost:8080/DMF0074_40/Metal Link Price/UPLOAD/excel-upload", files={"file": (OUT.name, fh)}, timeout=600).json()
print("CNT", body["result"]["O_CUR_CNT"])
con = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1"); cur = con.cursor()
cur.execute("""SELECT ATTRIBUTE3, UPLOAD_STATUS_CODE, MESSAGE_TEXT FROM SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID='DMF0074_40' AND SHEET_NAME='Metal Link Price' AND CREATED_BY='minyonglee1'
               AND CREATION_DATE=(SELECT MAX(CREATION_DATE) FROM SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID='DMF0074_40' AND SHEET_NAME='Metal Link Price' AND CREATED_BY='minyonglee1')""")
st = {t: (s_, m) for t, s_, m in cur.fetchall()}
for r, t, title in meta: print(f"row{r:<3} {title:26} -> {st[t][0]:8} {st[t][1] or ''}")
