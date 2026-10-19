# -*- coding: utf-8 -*-
"""PKG_DMF0020 — 환율 없는 기간의 LOC 저장 시 KRW·USD 를 0 으로 함께 생성 [E20260930-DMF0020FXZERO] (저장·Excel Upload·Batch Input 3경로)

사용자 지시 (2026-09-30): "환율이 존재하지 않는 기간에 LOC 을 저장하면 KRW, USD 가 같이 생성되지 않는다. 환율이 없으면 0 으로 해서
KRW, USD 는 같이 생성되도록. 저장·EXCEL UPLOAD·BATCH INPUT 동일 적용."
현황 (사내 실측):
  · Excel Upload (P_DMF0020_EXCEL_UPLOAD 5-4/5-5)  : GT_F020_EXCH 와 INNER JOIN → 환율 없는 달은 KRW·USD 행 자체가 없음 (AS-IS 동일 구조)
  · Batch Input (P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP): GT_DMF0020_EXCH 와 INNER JOIN → 동일
  · 저장 (P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL): FE 가 LOC/KRW/USD 3쌍을 보내고 환율 없으면 KRW/USD 0 (09-09 GBP 실측) —
    SP 는 '3쌍이 아니면 MSG00452 반려'. KRW/USD 가 안 온 경우를 위해 검증 앞에서 보충한다(환율 있으면 계산, 없으면 0).
조치:
  (A) EXCEL  : KRW = LOC × NVL(환율,0) · USD = 환율 없거나 0 이면 0, 아니면 KRW/환율 · 두 JOIN → LEFT JOIN
  (B) POPUP  : 동일
  (C) ALL    : 3쌍 검증 직전 KRW/USD 보충 INSERT (LOC 행 기준 · 10키 NULL-safe · 통화 KRW/USD 는 동일값 규칙 그대로)
  원문 줄은 `--[TAG] 원문:` 주석으로 보존. FRESH-GATE.
usage: python apply_fxzero.py backup | apply | restore
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "backup"
TAG = "E20260930-DMF0020FXZERO"
NAME, TYP = "PKG_DMF0020", "PACKAGE BODY"
BAK = HERE / "00_BACKUP_PKG_DMF0020_BODY.sql"
NEW = HERE / "01_PKG_DMF0020_BODY_FXZERO.sql"
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 900000
cur = cn.cursor()


def last_ddl():
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    return cur.fetchone()[0]


def fetch():
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:1 AND TYPE=:2 ORDER BY LINE", [NAME, TYP])
    return [t or "" for (t,) in cur]


def compile_src(src):
    cur.execute("CREATE OR REPLACE " + src.rstrip())
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:1 AND TYPE=:2 ORDER BY SEQUENCE", [NAME, TYP])
    return st, cur.fetchall()


if MODE == "restore":
    src = BAK.read_text(encoding="utf-8").split("CREATE OR REPLACE ", 1)[1].rsplit("\n/\n", 1)[0]
    print("restore:", compile_src(src))
    sys.exit(0)

cur.execute("SELECT DATA_TYPE FROM USER_TAB_COLUMNS WHERE TABLE_NAME='GT_FCSV_RESULTS_MST' AND COLUMN_NAME='V_PRICE'")
VPRICE_T = cur.fetchone()[0]
ddl0 = last_ddl()
L = fetch()
src0 = "".join(L)
assert TAG not in src0, "이미 적용됨"


def proc_range(name):
    s = next(i for i, t in enumerate(L) if t.strip().startswith("PROCEDURE") and t.strip().split()[1] == name)
    e = next((i for i in range(s + 1, len(L)) if L[i].strip().startswith("END " + name)), len(L))
    return s, e


def find_one(a, b, stripped):
    hits = [i for i in range(a, b) if L[i].strip() == stripped]
    assert len(hits) == 1, (stripped, hits)
    return hits[0]


edits = {}   # line index → replacement text (원문은 주석으로 보존)


def replace_line(i, new_code):
    old = L[i]
    ind = old[: len(old) - len(old.lstrip())]
    edits[i] = f"{ind}--[{TAG}] 원문: {old.strip()}\n{ind}{new_code}\n"


# ---------------- (A) EXCEL UPLOAD ----------------
a, b = proc_range("P_DMF0020_EXCEL_UPLOAD")
k = find_one(a, b, "TO_CHAR(ROUND(TO_NUMBER(A.LOC) * B.EXCHANGE_PRICE, 3)),")
replace_line(k, "TO_CHAR(ROUND(TO_NUMBER(A.LOC) * NVL(B.EXCHANGE_PRICE, 0), 3)),   -- 환율 없으면 KRW 0")
j = [i for i in range(k, k + 8) if L[i].strip() == "JOIN GT_F020_EXCH B"]; assert len(j) == 1
replace_line(j[0], "LEFT JOIN GT_F020_EXCH B   -- 환율 없는 달도 KRW 행 생성")
k = find_one(a, b, "TO_CHAR(ROUND(TO_NUMBER(A.LOC) / B.EXCHANGE_PRICE, 3)),")
replace_line(k, "TO_CHAR(CASE WHEN NVL(B.EXCHANGE_PRICE, 0) = 0 THEN 0 ELSE ROUND(TO_NUMBER(A.LOC) / B.EXCHANGE_PRICE, 3) END),   -- USD 환율 없으면 0")
j = [i for i in range(k, k + 8) if L[i].strip() == "JOIN GT_F020_EXCH B"]; assert len(j) == 1
replace_line(j[0], "LEFT JOIN GT_F020_EXCH B   -- 환율 없는 달도 USD 행 생성")

# ---------------- (B) BATCH INPUT (POPUP) ----------------
a, b = proc_range("P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP")
k = find_one(a, b, ",ROUND(A.v_PRICE * B.EXCHANGE_PRICE, 3)")
replace_line(k, ",ROUND(A.v_PRICE * NVL(B.EXCHANGE_PRICE, 0), 3)   -- 환율 없으면 KRW 0")
j = [i for i in range(k, k + 8) if L[i].strip() == "JOIN GT_DMF0020_EXCH B"]; assert len(j) == 1
replace_line(j[0], "LEFT JOIN GT_DMF0020_EXCH B   -- 환율 없는 달도 KRW 행 생성")
k = find_one(a, b, ",ROUND(A.v_PRICE / B.EXCHANGE_PRICE, 3)")
replace_line(k, ",CASE WHEN NVL(B.EXCHANGE_PRICE, 0) = 0 THEN 0 ELSE ROUND(A.v_PRICE / B.EXCHANGE_PRICE, 3) END   -- USD 환율 없으면 0")
j = [i for i in range(k, k + 8) if L[i].strip() == "JOIN GT_DMF0020_EXCH B"]; assert len(j) == 1
replace_line(j[0], "LEFT JOIN GT_DMF0020_EXCH B   -- 환율 없는 달도 USD 행 생성")

# ---------------- (C) SAVE (ALL) — 3쌍 검증 직전 보충 ----------------
a, b = proc_range("P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL")
anc = find_one(a, b, "--[E20250306-001052]_비정상적으로 3쌍이 아닌 메져가 들어오는 경우가 발생함(매번 발생하는 건이 아닌, 가끔 발생하는 부분임)")
KEYS = ["V_DIVISION_ID", "V_PROJECT_CODE", "V_SCM_SITE_ID", "V_PLANT_SITE_ID", "V_ITEM_ID", "V_YYYYMMDD", "V_CURRENCY", "V_DOM_EXP", "V_FCST_TYPE", "V_INCOTERMS"]
I8 = "        "
eq = lambda x, y: "\n".join(f"{I8}                        AND DECODE({x}.{c}, {y}.{c}, 1, 0) = 1" for c in KEYS)
num = (lambda e: e) if VPRICE_T == "NUMBER" else (lambda e: f"TO_CHAR({e})")
krw_expr = "CASE WHEN L.V_CURRENCY = 'KRW' THEN L.V_PRICE ELSE ROUND(L.V_PRICE * NVL(RK.EXCHANGE_PRICE, 0), 3) END"
usd_expr = (f"CASE WHEN L.V_CURRENCY = 'USD' THEN L.V_PRICE WHEN NVL(RU.EXCHANGE_PRICE, 0) = 0 THEN 0 "
            f"ELSE ROUND(({krw_expr}) / RU.EXCHANGE_PRICE, 3) END")
COLS = "V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_CURRENCY, V_MEASURE, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PRICE, V_CREATED_BY, V_CREATION_DATE, V_LAST_UPDATED_BY, V_ROWNUM"


def arm(measure, expr, note):
    return f"""{I8}/*[{TAG}] {note} — 사용자 지시 2026-09-30 "환율 없는 기간도 KRW·USD 를 0 으로 함께 생성" (저장·Excel·Batch 동일).
{I8}   FE 는 LOC/KRW/USD 3쌍을 보내는 것이 정상이고 이 보충은 {measure} 행이 빠진 LOC 행에만 적용된다(10키 NULL-safe). 통화 KRW/USD 는 동일값 규칙 */
{I8}INSERT INTO SCM_MGR.GT_FCSV_RESULTS_MST ( {COLS} )
{I8}SELECT L.V_ACTIVE_FLAG, L.V_DIVISION_ID, L.V_PROJECT_CODE, L.V_SCM_SITE_ID, L.V_PLANT_SITE_ID, L.V_ITEM_ID, L.V_YYYYMMDD, L.V_CURRENCY, '{measure}', L.V_DOM_EXP, L.V_FCST_TYPE, L.V_INCOTERMS
{I8}     , {num(expr)}
{I8}     , L.V_CREATED_BY, L.V_CREATION_DATE, L.V_LAST_UPDATED_BY, L.V_ROWNUM
{I8}  FROM SCM_MGR.GT_FCSV_RESULTS_MST L
{I8}  LEFT JOIN DM_MST_EXCHANGE_RATE RK ON RK.DIVISION_ID = L.V_DIVISION_ID AND RK.YYYYMMDD = SUBSTR(L.V_YYYYMMDD, 1, 6) || '01' AND RK.CURRENCY = 'KRW' AND RK.UNIT_CURRENCY = L.V_CURRENCY
{I8}  LEFT JOIN DM_MST_EXCHANGE_RATE RU ON RU.DIVISION_ID = L.V_DIVISION_ID AND RU.YYYYMMDD = SUBSTR(L.V_YYYYMMDD, 1, 6) || '01' AND RU.CURRENCY = 'KRW' AND RU.UNIT_CURRENCY = 'USD'
{I8} WHERE L.V_MEASURE = 'LOC'
{I8}   AND NOT EXISTS ( SELECT 1 FROM SCM_MGR.GT_FCSV_RESULTS_MST K
{I8}                     WHERE K.V_MEASURE = '{measure}'
{eq('K', 'L')} );

"""


block = arm("KRW", krw_expr, "저장 경로 KRW 보충") + arm("USD", usd_expr, "저장 경로 USD 보충")
new = []
for i, t in enumerate(L):
    if i == anc:
        new.append(block)
    new.append(edits.get(i, t))
src1 = "".join(new)
assert len(edits) == 8 and src1.count(f"--[{TAG}] 원문:") == 8 and src1.count(f"/*[{TAG}]") == 2
chk = "".join(new).replace(block, "", 1)
for i, rep in edits.items():
    chk = chk.replace(rep, L[i], 1)
assert chk == src0, "원문 보존 검증 실패"
print(f"기준본 LAST_DDL={ddl0}  교체 8줄 (EXCEL 4 · POPUP 4) + ALL 보충 삽입 {block.count(chr(10))}줄 (L{anc+1} 앞)  V_PRICE={VPRICE_T}")

now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
BAK.write_text(stamp + "-- 적용 전 원문\nCREATE OR REPLACE " + src0.rstrip() + "\n/\n", encoding="utf-8")
NEW.write_text(stamp + f"-- [{TAG}] PKG_DMF0020 BODY 전체본\nSET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + src1.rstrip() + "\n/\nSHOW ERRORS PACKAGE BODY SCM_MGR.PKG_DMF0020\n", encoding="utf-8")
prev = "".join(f"-- L{i+1}\n{edits[i]}" for i in sorted(edits)) + "\n-- ALL 보충 (L%d 앞)\n" % (anc + 1) + block
(HERE / "_change_preview.sql").write_text(prev, encoding="utf-8")
print("파일 생성 완료")

if MODE == "apply":
    assert last_ddl() == ddl0 and "".join(fetch()) == src0, "FRESH-GATE: 추출 이후 변경 감지 — 중단"
    st, errs = compile_src(src1)
    print(f"적용 결과 STATUS={st} 오류={len(errs)} LAST_DDL={last_ddl()}")
    if st != "VALID" or errs:
        for x in errs[:15]:
            print("  ERR", x)
        print("⚠ 원복:", compile_src(src0))
        sys.exit(1)
cn.close()
