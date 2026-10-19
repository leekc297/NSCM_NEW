# -*- coding: utf-8 -*-
"""병목 2문장 힌트 효과·결과 동등성 벤치 (사내 ZIOUI1 · 영구 변경 없음 — GTT 만, 끝에 ROLLBACK).

같은 세션에서 GET_MAIN_DATA 를 1회 실행해 GTT(C=TEMP_SITE_ITEM, B=TEMP_SELECT_MEASURE, D=T_WS_FCST)를 채운 뒤
해당 SELECT 부분만 떼어 원본 / 힌트본을 실행하고 시간·BG·행 SHA 를 비교한다.
  S1 = L1943~2019 (2nysu9tbng9v4 — CUST 종속 메저 실적 arm, DM_PLN_MKT_FCST_RESULT)
  S2 = L1229~1242 (7mrzdbpupw3b9 — div40 T_LAST_DATA_SETUP_FCST, DM_PLN_CFM_MKT_DEMAND_PLAN)
사용: python b01_hint_bench.py <div> <user>
"""
import io, sys, re, time, hashlib, pathlib, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

DIV = sys.argv[1] if len(sys.argv) > 1 else "40"
USER = sys.argv[2] if len(sys.argv) > 2 else "k0101"
today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
FRM, TO = frm.strftime("%Y%m%d"), to.strftime("%Y%m%d")

u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 1800000
cur = cn.cursor()
cur.execute("SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
src = {ln: (t or "") for ln, t in cur}


def block(a, b):
    s = "".join(src[i] for i in range(a, b + 1))
    s = re.sub(r"--[^\n]*", "", s).strip().rstrip(";")
    return s


# 앵커 검증 — 라인이 바뀌었으면 중단
assert src[1943].strip().startswith("SELECT A.DIVISION_ID") and "A.QTY <> 0;" in src[2019], "S1 앵커 불일치"
assert src[1229].strip().startswith("SELECT A.DIVISION_ID") and "A.MEASURE;" in src[1242], "S2 앵커 불일치"
assert "DM_PLN_MKT_FCST_RESULT A" in src[2003] and "DM_PLN_CFM_MKT_DEMAND_PLAN A" in src[1233]

S1 = block(1943, 2019)
S2 = block(1229, 1242)
bind = lambda s: (s.replace("p_division_id", ":d").replace("p_from_yyyymmdd", ":f")
                   .replace("p_to_yyyymmdd", ":t").replace("V_TO_RESULT", ":r"))
S1, S2 = bind(S1), bind(S2)
H1 = ("/*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) "
      "USE_HASH(D) USE_HASH(C) SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */")
H2 = "/*+ LEADING(A) USE_HASH(C) */"
S1H = S1.replace("SELECT A.DIVISION_ID", "SELECT " + H1 + " A.DIVISION_ID", 1)
S2H = S2.replace("SELECT A.DIVISION_ID", "SELECT " + H2 + " A.DIVISION_ID", 1)

# GET_MAIN_DATA 1회 — GTT 적재 (결과 커서는 버림)
cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME='PKG_DMF0082'"
            " AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL=0 ORDER BY POSITION")
P = {"P_DIVISION_ID": DIV, "P_TEAM_ID": "ALL", "P_CUSTOMER": "ALL", "P_BIZ_TYPE": "ALL",
     "P_FROM_YYYYMMDD": FRM, "P_TO_YYYYMMDD": TO, "P_SCM_SITE_ID": "ALL", "P_ITEM_ID": None,
     "P_VERSION_TYPE": "Current", "P_QTY_YN": "N", "P_CREATED_BY": USER, "P_USER_GROUP": "ADMIN",
     "P_PLANT_SITE_ID": "ALL", "P_PROJECT_CODE": "ALL", "P_OWNER": "ALL", "P_SENDER_CODE": "ALL"}
args = [P[a] if io_ == "IN" else cn.cursor() for a, io_ in cur.fetchall()]
t0 = time.time()
cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", args)
print(f"div={DIV} user={USER} 기간 {FRM}~{TO}  SP {time.time() - t0:.2f}s")
for tb in ("GT_DMF0082_TEMP_SITE_ITEM", "GT_DMF0082_TEMP_SELECT_MEASURE", "GT_DMF0082_T_WS_FCST"):
    cur.execute(f"SELECT COUNT(*) FROM SCM_MGR.{tb}")
    print(f"  {tb} = {cur.fetchone()[0]}")
cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE WHERE MEASURE_GROUP='CUST_FCST' AND MEASURE<>'CUST_FCST'")
print(f"  CUST 종속 메저 = {cur.fetchone()[0]}")

# V_TO_RESULT = SP 가 쓴 실측 바인드 (V$SQL_BIND_CAPTURE 최근값) — 없으면 금주 월요일
cur.execute("""SELECT VALUE_STRING FROM (SELECT B.VALUE_STRING FROM V$SQL_BIND_CAPTURE B JOIN V$SQL S
                 ON S.SQL_ID=B.SQL_ID AND S.CHILD_ADDRESS=B.CHILD_ADDRESS
                WHERE B.SQL_ID='2nysu9tbng9v4' AND B.POSITION=3 ORDER BY S.LAST_ACTIVE_TIME DESC) WHERE ROWNUM=1""")
r = cur.fetchone()
mon = (today - datetime.timedelta(days=today.weekday())).strftime("%Y%m%d")
VTR = r[0] if r and r[0] else mon
print(f"  V_TO_RESULT = {VTR}\n")


def mystat():
    cur.execute("SELECT S.VALUE FROM V$MYSTAT S JOIN V$STATNAME N ON N.STATISTIC#=S.STATISTIC# WHERE N.NAME='session logical reads'")
    return cur.fetchone()[0]


def run(label, sql, binds):
    b0 = mystat(); t = time.time()
    cur.execute(sql, binds)
    rows = cur.fetchall()
    el = time.time() - t
    cur.execute("SELECT PREV_SQL_ID, PREV_CHILD_NUMBER FROM V$SESSION WHERE SID=SYS_CONTEXT('USERENV','SID')")
    sid_, ch = cur.fetchone()
    cur.execute("SELECT PLAN_HASH_VALUE FROM V$SQL WHERE SQL_ID=:1 AND CHILD_NUMBER=:2", [sid_, ch])
    phv = (cur.fetchone() or [None])[0]
    bg = mystat() - b0
    h = hashlib.sha256("\n".join(sorted("|".join("" if v is None else str(v) for v in r) for r in rows)).encode()).hexdigest()[:16]
    print(f"  {label:26} {el:7.2f}s  BG {bg:>10,}  rows {len(rows):>7,}  sha {h}  PHV {phv}")
    return h


def poisoned(label, sql, binds, empty_sql):
    """SP 안 커서 재현: 불리한 GTT 상태(empty_sql 로 삭제)에서 먼저 하드파싱 → 원상태 복원 → 같은 커서 재사용 실행."""
    tag = f"/* B01 {label} {time.time_ns()} */ "
    q = sql.replace("SELECT ", "SELECT " + tag, 1)
    cur.execute("SAVEPOINT B01")
    cur.execute(empty_sql)
    cur.execute(q, binds); cur.fetchall()          # 불리한 상태에서 파싱 (계획 고정)
    cur.execute("ROLLBACK TO SAVEPOINT B01")       # GTT 원복
    return run(label + " (고정계획 재사용)", q, binds)


E1 = "DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE WHERE MEASURE_GROUP='CUST_FCST' AND MEASURE<>'CUST_FCST'"
E2 = "DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM"
print("S1 (2nysu9tbng9v4 · CUST 종속 메저 실적 arm) — 파싱 시점: 종속 메저 0행")
import os
b1 = {"d": DIV, "f": os.getenv("B01_S1_FROM", FRM), "r": os.getenv("B01_S1_TO", VTR)}
print(f"  S1 바인드 {b1}")
a = poisoned("원본", S1, b1, E1); b = poisoned("힌트", S1H, b1, E1)
print(f"  동등성: {'PASS' if a == b else 'FAIL'}\n")
if DIV == "40":
    print("S2 (7mrzdbpupw3b9 · div40 T_LAST_DATA_SETUP_FCST) — 파싱 시점: TEMP_SITE_ITEM 0행")
    b2 = {"d": DIV, "f": FRM, "t": TO}
    a = poisoned("원본", S2, b2, E2); b = poisoned("힌트", S2H, b2, E2)
    c0 = run("원본 (정상 파싱)", S2.replace("SELECT ", f"SELECT /* B01 fresh {time.time_ns()} */ ", 1), b2)
    print(f"  동등성: {'PASS' if a == b == c0 else 'FAIL'}")
cn.rollback()
cn.close()
