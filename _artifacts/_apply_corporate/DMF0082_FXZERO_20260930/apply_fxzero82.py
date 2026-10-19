# -*- coding: utf-8 -*-
"""PKG_DMF0082 — 환율 없는 기간의 LOC 저장 시 KRW·USD 를 0 으로 함께 생성 [E20260930-DMF0082FXZERO]
(LOC 저장 · Batch Price Input(SavePricePeriodModal) = P_DMF0082_SAVE_MAIN_DATA 1본 · Excel Upload = P_DMF0082_EXCEL_UPLOAD)

사용자 지시 (2026-09-30): "DMF0082 에도 LOC 저장하는 로직이 있다. LOC 저장, EXCEL UPLOAD, BATCH PRICE INPUT 3개에 대해서
환율이 없어도 3개 SET 이 일괄 저장 되도록."
현황 (사내 실측 · AS-IS DMF0082_SAVE_MAIN_DATA L1640/1656/1872/1880 동일 구조):
  · SAVE_MAIN : KRW = LOC × EX.EXCHANGE_PRICE (LEFT JOIN → 환율 없으면 NULL) / USD = KRW ÷ USD.EXCHANGE_PRICE (NULL)
                → Phase1 DELETE(QTY_PRICE = 0) 도 Phase2 MERGE(QTY_PRICE <> 0) 도 NULL 은 해당 없음 → KRW·USD 행 미생성
                (40 = DM_PLN_CFM_SELLING_PRICE / 81 = SCM_MST_FUTURE_PRICE 두 분기 동일)
  · EXCEL     : 5-4/5-5 가 GT_F020_EXCH 와 INNER JOIN → 환율 없는 달은 KRW·USD 파생 행 자체가 없음 (AS-IS DMF0082_EXCEL_UPLOAD 는 MKT_FCST 전용, TO-BE 81 확장분)
조치:
  (A) SAVE_MAIN 파생 : KRW = LOC × NVL(환율,0) · USD = USD환율 없으면 (통화 USD 면 LOC, 아니면 0) 아니면 KRW ÷ USD환율
  (B) SAVE_MAIN Phase1/Phase2 (40·81) : "LOC 가 0 이 아닌 세트의 KRW/USD 0" 은 삭제 대상에서 제외하고 MERGE 대상에 포함 (0 으로 저장)
      — LOC=0(삭제 의도) 인 세트의 KRW/USD 0 은 종전대로 삭제
  (C) EXCEL 5-4/5-5 : LEFT JOIN + NVL/CASE (DMF0020 FXZERO 와 동일)
  원문 줄은 `--[TAG] 원문:` 주석으로 보존. FRESH-GATE.
usage: python apply_fxzero82.py backup | apply | restore
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "backup"
TAG = "E20260930-DMF0082FXZERO"
NAME, TYP = "PKG_DMF0082", "PACKAGE BODY"
BAK = HERE / "00_BACKUP_PKG_DMF0082_BODY.sql"
NEW = HERE / "01_PKG_DMF0082_BODY_FXZERO.sql"
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

ddl0 = last_ddl()
L = fetch()
src0 = "".join(L)
assert TAG not in src0, "이미 적용됨"


def proc_range(name):
    s = next(i for i, t in enumerate(L) if t.strip().startswith("PROCEDURE") and t.strip().split()[1] == name)
    e = next((i for i in range(s + 1, len(L)) if L[i].strip().startswith("END " + name)), len(L))
    return s, e


def find_all(a, b, stripped):
    return [i for i in range(a, b) if L[i].strip() == stripped]


def find_one(a, b, stripped):
    hits = find_all(a, b, stripped)
    assert len(hits) == 1, (stripped, hits)
    return hits[0]


edits = {}   # line index → replacement text (원문은 주석으로 보존)


def replace_line(i, new_code):
    old = L[i]
    ind = old[: len(old) - len(old.lstrip())]
    body = "\n".join(ind + x if k else x for k, x in enumerate(new_code.split("\n")))
    edits[i] = f"{ind}--[{TAG}] 원문: {old.strip()}\n{ind}{body}\n"


# ---------------- (A) SAVE_MAIN — KRW/USD 파생 (환율 없으면 0) ----------------
a, b = proc_range("P_DMF0082_SAVE_MAIN_DATA")
k = find_one(a, b, ", ROUND(NVL(T.QTY_PRICE, 0) * CASE WHEN T.CURRENCY = 'KRW' THEN 1 ELSE EX.EXCHANGE_PRICE END, 3) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가")
replace_line(k, ", ROUND(NVL(T.QTY_PRICE, 0) * CASE WHEN T.CURRENCY = 'KRW' THEN 1 ELSE NVL(EX.EXCHANGE_PRICE, 0) END, 3) AS QTY_PRICE   -- 환율 없으면 KRW 0")
k = find_one(a, b, ", ROUND(ROUND((NVL(T.QTY_PRICE, 0) * CASE WHEN T.CURRENCY = 'KRW' THEN 1 ELSE EX.EXCHANGE_PRICE END), 3) / USD.EXCHANGE_PRICE, 3) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가")
replace_line(k, ", CASE WHEN NVL(USD.EXCHANGE_PRICE, 0) = 0 THEN CASE WHEN T.CURRENCY = 'USD' THEN NVL(T.QTY_PRICE, 0) ELSE 0 END   -- USD 환율 없으면 0 (통화 USD 면 LOC 그대로)\n"
                "       ELSE ROUND(ROUND((NVL(T.QTY_PRICE, 0) * CASE WHEN T.CURRENCY = 'KRW' THEN 1 ELSE NVL(EX.EXCHANGE_PRICE, 0) END), 3) / USD.EXCHANGE_PRICE, 3) END AS QTY_PRICE")

# ---------------- (B) SAVE_MAIN — Phase1 DELETE 제외 / Phase2 MERGE 포함 (40 · 81) ----------------
K40 = ["DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "PLANT_SITE_ID", "CELL_PROD_SITE_ID", "ITEM_ID", "YYYYMMDD", "DOM_EXP", "FCST_TYPE", "INCOTERMS"]
K81 = ["DIVISION_ID", "PROJECT_CODE", "SCM_SITE_ID", "PLANT_SITE_ID", "ITEM_ID", "YYYYMMDD", "DOM_EXP", "FCST_TYPE", "INCOTERMS"]


def loc_alive(alias, keys):
    """같은 세트(키)의 LOC 행이 0 이 아닌지 — 환율 없어 0 이 된 KRW/USD 를 '삭제 의도 0' 과 구분"""
    cond = " AND ".join(f"L.{c} = {alias}.{c}" for c in keys)
    return f"EXISTS ( SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN L WHERE L.MEASURE = 'LOC' AND NVL(L.QTY_PRICE, 0) <> 0 AND {cond} )"


price_end = find_one(a, b, "END IF;  --[DIV81] 판가 DML 분기")   # 판가 블록 끝 — 이후(MKT_DEMAND_PLAN 등)의 동일 문장은 대상 아님
ph1 = find_all(a, price_end, "AND B.QTY_PRICE = 0")
ph2 = find_all(a, price_end, "WHERE M.MEASURE IN ('KRW', 'USD', 'LOC') AND M.QTY_PRICE <> 0)")
assert len(ph1) == 2 and len(ph2) == 2, (ph1, ph2)
div81_mark = find_one(a, b, "--[DIV81] Phase 1-81: DELETE SCM_MST_FUTURE_PRICE (QTY_PRICE=0) — 키 10종 (END_CUSTOMER/CELL_PROD 제외)")
assert ph1[0] < ph2[0] < div81_mark < ph1[1] < ph2[1]
for i, keys in ((ph1[0], K40), (ph1[1], K81)):
    replace_line(i, f"AND B.QTY_PRICE = 0\n  AND NOT ( B.MEASURE IN ('KRW', 'USD') AND {loc_alive('B', keys)} )   -- LOC 가 살아있는 세트의 KRW/USD 0(환율 없음) 은 삭제 아님")
for i, keys in ((ph2[0], K40), (ph2[1], K81)):
    replace_line(i, f"WHERE M.MEASURE IN ('KRW', 'USD', 'LOC')\n  AND ( M.QTY_PRICE <> 0 OR ( M.MEASURE IN ('KRW', 'USD') AND {loc_alive('M', keys)} ) ))   -- 환율 없는 KRW/USD 는 0 으로 저장")

# ---------------- (C) EXCEL UPLOAD 5-4/5-5 ----------------
a, b = proc_range("P_DMF0082_EXCEL_UPLOAD")
k = find_one(a, b, "TO_CHAR(ROUND(TO_NUMBER(A.LOC) * B.EXCHANGE_PRICE, 3)),")
replace_line(k, "TO_CHAR(ROUND(TO_NUMBER(A.LOC) * NVL(B.EXCHANGE_PRICE, 0), 3)),   -- 환율 없으면 KRW 0")
j = [i for i in range(k, k + 8) if L[i].strip() == "JOIN GT_F020_EXCH B"]; assert len(j) == 1
replace_line(j[0], "LEFT JOIN GT_F020_EXCH B   -- 환율 없는 달도 KRW 행 생성")
k = find_one(a, b, "TO_CHAR(ROUND(TO_NUMBER(A.LOC) / B.EXCHANGE_PRICE, 3)),")
replace_line(k, "TO_CHAR(CASE WHEN NVL(B.EXCHANGE_PRICE, 0) = 0 THEN 0 ELSE ROUND(TO_NUMBER(A.LOC) / B.EXCHANGE_PRICE, 3) END),   -- USD 환율 없으면 0")
j = [i for i in range(k, k + 8) if L[i].strip() == "JOIN GT_F020_EXCH B"]; assert len(j) == 1
replace_line(j[0], "LEFT JOIN GT_F020_EXCH B   -- 환율 없는 달도 USD 행 생성")

new = [edits.get(i, t) for i, t in enumerate(L)]
src1 = "".join(new)
assert len(edits) == 10 and src1.count(f"--[{TAG}] 원문:") == 10
chk = src1
for i in sorted(edits):
    chk = chk.replace(edits[i], L[i], 1)
assert chk == src0, "원문 보존 검증 실패"
print(f"기준본 LAST_DDL={ddl0}  교체 10줄 (SAVE_MAIN 파생 2 · Phase1 2 · Phase2 2 · EXCEL 4)")

now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
BAK.write_text(stamp + "-- 적용 전 원문\nCREATE OR REPLACE " + src0.rstrip() + "\n/\n", encoding="utf-8")
NEW.write_text(stamp + f"-- [{TAG}] PKG_DMF0082 BODY 전체본\nSET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + src1.rstrip() + "\n/\nSHOW ERRORS PACKAGE BODY SCM_MGR.PKG_DMF0082\n", encoding="utf-8")
(HERE / "_change_preview.sql").write_text("".join(f"-- L{i+1}\n{edits[i]}" for i in sorted(edits)), encoding="utf-8")
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
