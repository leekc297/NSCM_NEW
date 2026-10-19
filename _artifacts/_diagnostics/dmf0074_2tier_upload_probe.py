"""dmf0074_2tier_upload_probe.py — AS-IS 2단 헤더 양식(원본 파일 기반)으로 실업로드(P_MODE=0) 후
응답(O_CUR_CNT/O_CUR_LIST) ↔ 스테이징(SCM_ADM_EXCEL_UPLOAD) 행별 대사. 2026-09-14"""
import sys, json, requests, openpyxl, oracledb, pathlib
SRC = r"C:\TRANFILE\RECEIVE\DMF0074_MetalLinkPricePopup_ASIS.xlsx"
OUT = pathlib.Path(r"C:\Users\ejene\AppData\Local\Temp\claude\c--Projects-NSCM\0ea4cbc9-b2ef-4b42-8284-e360f3928fc5\scratchpad\dmf0074_2tier_probe.xlsx")
FORM, SHEET, USER = "DMF0074_40", "Metal Link Price", "minyonglee1"
base = {"A": "40", "B": 202610, "D": "Isuzu", "E": "MPCISZISLD1V", "F": "Y", "G": "Isuzu_JP_TYO", "H": "USD", "I": "Mass", "J": "N"}
# 40 양식 열: L..R Key(Ni..Cu) / S..Y PeriodFr / Z..AF PeriodTo / AG..AM Contract / AN..AT Change / AU..BA Index
ni_full = {"L": "M035", "S": 6, "Z": 0, "AG": 18.5, "AN": 0.75, "AU": 0.42}
rows = [  # (excel row, team, overrides, expected message)
  (3, "TC_R3", {**ni_full}, "(정상 또는 환경성 C19)"),
  (4, "TC_R4", {**ni_full, "B": None}, "NULL PLAN DATE."),
  (5, "TC_R5", {"L": "BOGUS"}, "Invalid KEY CODE : Ni"),
  (6, "TC_R6", {**ni_full, "S": 13}, "Invalid INTEGER 0 ~ 12."),
  (7, "TC_R7", {**ni_full, "S": 1, "Z": 3}, "From Value must be larger than To Value."),
  (8, "TC_R8", {"M": "M037"}, "NULL Co : Period(Fr)"),
  (10, "TC_R10", {**ni_full, "D": "ZZZ_NOT_EXIST"}, "Invalid END CUSTOMER."),
]
wb = openpyxl.load_workbook(SRC); ws = wb.active
for c in ws[3]: c.value = None                      # AS-IS 파일 3행 번호 표기 제거
for r, team, ov, _ in rows:
    vals = {**base, "C": team, **ov}
    for col, v in vals.items():
        if v is not None: ws[f"{col}{r}"] = v       # 숫자는 숫자 셀 그대로 (General 서식 입력 모사)
wb.save(OUT)
s = requests.Session(); assert s.post("http://localhost:8080/user/login", json={"userId": USER}, timeout=30).status_code == 200
with open(OUT, "rb") as fh:
    resp = s.post(f"http://localhost:8080/{FORM}/{SHEET}/UPLOAD/excel-upload", files={"file": (OUT.name, fh)}, timeout=600)
body = resp.json(); res = body.get("result") or {}
print("http", resp.status_code, "code", body.get("code"), body.get("message"))
print("CNT", res.get("O_CUR_CNT"))
lst = res.get("O_CUR_LIST") or []
print("LIST keys", list(lst[0].keys())[:8] if lst else None, "... n=", len(lst))
for x in lst:
    print(" LIST EXCEL_ROW", x.get("EXCEL_ROW"), "team", x.get("ATTRIBUTE3"), "Key_Ni", x.get("ATTRIBUTE12"), "Key_Co", x.get("ATTRIBUTE13"),
          "Fr_Ni", x.get("ATTRIBUTE19"), "To_Ni", x.get("ATTRIBUTE26"), "Contract_Ni", x.get("ATTRIBUTE33"), "| MSG", x.get("MESSAGE_TEXT"))
con = oracledb.connect(user="SCM_MGR", password="zionex1!", dsn="175.211.29.206:2521/ZIOUI1"); cur = con.cursor()
cur.execute("""SELECT UPLOAD_ID, UPLOAD_STATUS_CODE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE19, ATTRIBUTE26, ATTRIBUTE33, ATTRIBUTE40, ATTRIBUTE47, ATTRIBUTE53, MESSAGE_TEXT
               FROM SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND CREATED_BY=:u
                AND CREATION_DATE=(SELECT MAX(CREATION_DATE) FROM SCM_ADM_EXCEL_UPLOAD WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND CREATED_BY=:u) ORDER BY UPLOAD_ID""", p=FORM, s=SHEET, u=USER)
print("STAGING (UPLOAD_ID 순)")
for r in cur.fetchall(): print(" ", r)
exp = {t: e for _, t, _, e in rows}
print("EXPECTED", json.dumps(exp, ensure_ascii=False))
