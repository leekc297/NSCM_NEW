"""[E20261001-EMPTYASIS] 구조 게이트 — 적용된 BODY 의 3-1~3-7 INSERT 문장을 그대로 세션 GTT 에서 실행 (원장 무접촉, ROLLBACK)

모의 FINAL 3행:
  R1 81 / Metal Link Y / Exception 공란 / Energy 공란 / Ni 키 K1 + Period(Fr) 3 만 입력, 나머지 6 금속 전부 공란
  R2 81 / Metal Link N / 동적 전부 공란
  R3 82 / Metal Link Y / Exception N / Energy 1.2345 / Co 전 항목 입력
기대: 21행(3×7) · R1 Ni = K1/3/'-'/0/0/0 · 빈 금속 '-'/'-'/'-'/0/0/0 · Exception 공란 → '-' · Energy 공란 → 0
"""
import sys, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

cur.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name='PKG_DMF0074' AND type='PACKAGE BODY' ORDER BY line")
src = "".join(r[0] for r in cur)
assert src.count("[E20261001-EMPTYASIS]") == 12, "마커 12개가 아님 — 적용 판본 확인"

stmts = []
for t in ["APPLY_PRICE_TYPE", "FROM_PERIOD", "TO_PERIOD", "CONTRACT_UNIT", "METAL_APPLY", "METAL_REQR", "METAL_LINK_PRICE"]:
    m = re.findall(r"(INSERT INTO SCM_MGR\.GT_DM74_TMP_" + t + r"\b.*?);\n", src, re.S)
    assert len(m) == 1, f"{t} INSERT {len(m)}개"
    stmts.append((t, m[0]))

cols = ("DIVISION_ID,PLAN_YYYYMM,END_CUSTOMER,PROJECT_CODE,PLANT_SITE_ID,ITEM_ID,METAL_LINK_YN,SCM_SITE_ID,CURRENCY,FCST_TYPE,"
        "METAL_EXCEPTION_YN,ENERGY,APPLY_PRICE_TYPE_CODE1,APPLY_PRICE_TYPE_CODE2,FROM_PERIOD1,FROM_PERIOD2,TO_PERIOD2,"
        "CONTRACT_UNIT2,METAL_APPLY2,METAL_REQR2")
rows = [
    ("81", "202611", "EC", "PJ", "PS", "MOCK_R1", "Y", "SS", "USD", "F1", None, None, "K1", None, "3", None, None, None, None, None),
    ("81", "202611", "EC", "PJ", "PS", "MOCK_R2", "N", "SS", "USD", "F1", None, None, None, None, None, None, None, None, None, None),
    ("82", "202611", "EC", "PJ", "PS", "MOCK_R3", "Y", "SS", "USD", "F1", "N", "1.2345", None, "K2", None, "5", "2", "10.555", "20.444", "1.005"),
]
print("prep ok", flush=True)
try:
    for t in ["GT_DM74_TMP_EXCEL_UPLOAD_FINAL", "GT_DM74_TEMP_VERSION_NO", "GT_DM74_TMP_APPLY_PRICE_TYPE", "GT_DM74_TMP_FROM_PERIOD",
              "GT_DM74_TMP_TO_PERIOD", "GT_DM74_TMP_CONTRACT_UNIT", "GT_DM74_TMP_METAL_APPLY", "GT_DM74_TMP_METAL_REQR", "GT_DM74_TMP_METAL_LINK_PRICE"]:
        print("del", t, flush=True); cur.execute(f"DELETE FROM SCM_MGR.{t}")
    cur.executemany(f"INSERT INTO SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL ({cols}) VALUES ({','.join(':' + str(i + 1) for i in range(20))})", rows)
    cur.executemany("INSERT INTO SCM_MGR.GT_DM74_TEMP_VERSION_NO (DIVISION_ID, VERSION_NO) VALUES (:1, :2)", [("81", "MOCKVER81"), ("82", "MOCKVER82")])
    for t, s in stmts:
        print("run", t, flush=True); cur.execute(s)
        print(f"{t:18s} {cur.rowcount}")
    cur.execute("""SELECT ITEM_ID, METAL_KIND_CODE, METAL_LINK_YN, METAL_EXCEPTION_YN EX, ENERGY, APPLY_PRICE_TYPE_CODE KEYV,
                          FROM_PERIOD, TO_PERIOD, CONTRACT_UNIT, METAL_APPLY, METAL_REQR, VERSION_NO
                     FROM SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE ORDER BY ITEM_ID,
                          DECODE(METAL_KIND_CODE,'Ni',1,'Co',2,'Li2CO3',3,'LIOH',4,'Al',5,'Mn',6,'Cu',7)""")
    res = cur.fetchall()
    for r in res:
        print(r)
    nulls = [r for r in res if any(v is None for v in (r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10]))]
    ok = (len(res) == 21 and not nulls
          and res[0][1:] == ("Ni", "Y", "-", 0, "K1", "3", "-", 0, 0, 0, "MOCKVER81")
          and all(r[5] == "-" and r[8] == 0 for r in res if r[0] == "MOCK_R2")
          and [r for r in res if r[0] == "MOCK_R3" and r[1] == "Co"][0][4:11] == (1.235, "K2", "5", "2", 10.56, 20.44, 1.01))
    print("RESULT", "PASS" if ok else "FAIL", "rows", len(res), "null-cols", len(nulls))
finally:
    con.rollback()
    con.close()
