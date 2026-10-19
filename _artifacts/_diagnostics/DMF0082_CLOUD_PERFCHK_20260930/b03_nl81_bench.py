# -*- coding: utf-8 -*-
"""81/82 Current 최신키 2문장 — 1행 추정 NL 함정(타임아웃) 재현 + 힌트 효과·동등성 벤치 (사내 ZIOUI1 · GTT 만, 끝에 ROLLBACK).

  SA = L1213~1226 (gfjpdh7fc1u59 계열 — 81/82 T_LAST_DATA_SETUP_FCST, DM_PLN_MKT_FCST)
  SB = L1249~1262 (3d2xnx839ksnt — 81/82 T_LAST_DATA_SETUP_PRICE, SCM_MST_FUTURE_PRICE · INDEX(IDX02) 힌트)
재현 방식 = b01 과 동일: TEMP_SITE_ITEM 을 비운 상태에서 먼저 하드파싱 → 원복 → 같은 커서 재사용.
원본(고정계획)은 폭주하므로 맨 마지막에 call_timeout 으로 끊는다.
사용: python b03_nl81_bench.py <div> <user> [timeout_sec]
"""
import io, sys, re, time, hashlib, pathlib, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

DIV = sys.argv[1] if len(sys.argv) > 1 else "82"
USER = sys.argv[2] if len(sys.argv) > 2 else "k0101"
TMO = int(sys.argv[3]) if len(sys.argv) > 3 else 120
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


def find_block(table, hint_prefix):
    """81 분기 문장: 'FROM SCM_MGR.<table> A' 줄 기준으로 SELECT~GROUP BY 끝(';') 추출 — 라인 이동에 견딤."""
    hits = [ln for ln, t in src.items() if re.search(rf"FROM\s+SCM_MGR\.{table}\s+A\s*$", t.rstrip())]
    hits = [ln for ln in hits if "GT_DMF0082_T_LAST_DATA_SETUP_" in "".join(src[i] for i in range(ln - 6, ln))]
    assert len(hits) == 1, (table, hits)
    f = hits[0]
    s = next(i for i in range(f, f - 8, -1) if src[i].lstrip().startswith("SELECT"))
    e = next(i for i in range(f, f + 20) if src[i].rstrip().endswith(";"))
    assert src[s].lstrip().startswith(hint_prefix), src[s][:120]
    blk = "".join(src[i] for i in range(s, e + 1))
    blk = re.sub(r"/\*\[.*?\*/", "", blk)
    blk = re.sub(r"--[^\n]*", "", blk).strip().rstrip(";")
    return s, e, blk


bind = lambda s: s.replace("p_division_id", ":d").replace("p_from_yyyymmdd", ":f").replace("p_to_yyyymmdd", ":t")
sa, ea, SA = find_block("DM_PLN_MKT_FCST", "SELECT A.DIVISION_ID")
sb, eb, SB = find_block("SCM_MST_FUTURE_PRICE", "SELECT /*+ INDEX(A IDX02_SCM_MST_FUTURE_PRICE) */")
print(f"SA L{sa}~{ea} · SB L{sb}~{eb}")
SA, SB = bind(SA), bind(SB)
SB_BARE = SB.replace("/*+ INDEX(A IDX02_SCM_MST_FUTURE_PRICE) */ ", "", 1)
VAR = {
    "SA 원본": SA,
    "SA 힌트 LEADING(C A) USE_HASH(A)": SA.replace("SELECT A.DIVISION_ID", "SELECT /*+ LEADING(C A) USE_HASH(A) */ A.DIVISION_ID", 1),
    "SB 원본 INDEX": SB,
    "SB 힌트 INDEX+HASH": SB_BARE.replace("SELECT A.DIVISION_ID", "SELECT /*+ LEADING(C A) USE_HASH(A) INDEX(A IDX02_SCM_MST_FUTURE_PRICE) */ A.DIVISION_ID", 1),
    "SB 힌트 FULL+HASH": SB_BARE.replace("SELECT A.DIVISION_ID", "SELECT /*+ LEADING(C A) USE_HASH(A) FULL(A) */ A.DIVISION_ID", 1),
}

cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME='PKG_DMF0082'"
            " AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL=0 ORDER BY POSITION")
P = {"P_DIVISION_ID": DIV, "P_TEAM_ID": "ALL", "P_CUSTOMER": "ALL", "P_BIZ_TYPE": "ALL",
     "P_FROM_YYYYMMDD": FRM, "P_TO_YYYYMMDD": TO, "P_SCM_SITE_ID": "ALL", "P_ITEM_ID": None,
     "P_VERSION_TYPE": "Current", "P_QTY_YN": "N", "P_CREATED_BY": USER, "P_USER_GROUP": "ADMIN",
     "P_PLANT_SITE_ID": "ALL", "P_PROJECT_CODE": "ALL", "P_OWNER": "ALL", "P_SENDER_CODE": "ALL"}
args = [P[a] if io_ == "IN" else cn.cursor() for a, io_ in cur.fetchall()]
t0 = time.time()
cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", args)
cur.execute("SELECT COUNT(*) FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM")
print(f"div={DIV} user={USER} 기간 {FRM}~{TO}  SP {time.time() - t0:.2f}s  TEMP_SITE_ITEM={cur.fetchone()[0]:,}\n")
B = {"d": DIV, "f": FRM, "t": TO}


def mystat():
    cur.execute("SELECT S.VALUE FROM V$MYSTAT S JOIN V$STATNAME N ON N.STATISTIC#=S.STATISTIC# WHERE N.NAME='session logical reads'")
    return cur.fetchone()[0]


def run(label, sql):
    b0 = mystat(); t = time.time()
    cur.execute(sql, B)
    rows = cur.fetchall()
    el = time.time() - t
    cur.execute("SELECT PREV_SQL_ID, PREV_CHILD_NUMBER FROM V$SESSION WHERE SID=SYS_CONTEXT('USERENV','SID')")
    q, ch = cur.fetchone()
    cur.execute("SELECT PLAN_HASH_VALUE FROM V$SQL WHERE SQL_ID=:1 AND CHILD_NUMBER=:2", [q, ch])
    phv = (cur.fetchone() or [None])[0]
    cur.execute("SELECT COUNT(*) FROM V$SQL_PLAN WHERE SQL_ID=:1 AND CHILD_NUMBER=:2 AND OPERATION='NESTED LOOPS'", [q, ch])
    nl = cur.fetchone()[0]
    h = hashlib.sha256("\n".join(sorted("|".join("" if v is None else str(v) for v in r) for r in rows)).encode()).hexdigest()[:16]
    print(f"  {label:44} {el:8.2f}s  BG {mystat() - b0:>12,}  rows {len(rows):>7,}  sha {h}  PHV {phv}  NL {nl}")
    return h


def poisoned(label, sql):
    tag = f"/* B03 {label[:2]} {time.time_ns()} */ "
    q = sql.replace("SELECT ", "SELECT " + tag, 1)
    cur.execute("SAVEPOINT B03")
    cur.execute("DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM")
    cur.execute(q, B); cur.fetchall()
    cur.execute("ROLLBACK TO SAVEPOINT B03")
    return run(label + " [빈GTT 파싱→재사용]", q)


res = {}
for k, v in VAR.items():
    if k.endswith("원본") or "원본 INDEX" in k:
        res[k + " fresh"] = run(k + " [정상 파싱]", v.replace("SELECT ", f"SELECT /* B03 f {time.time_ns()} */ ", 1))
for k, v in VAR.items():
    if "힌트" in k:
        res[k] = poisoned(k, v)
print(f"\n  SA 동등성: {'PASS' if res['SA 원본 fresh'] == res['SA 힌트 LEADING(C A) USE_HASH(A)'] else 'FAIL'}")
print(f"  SB 동등성: {'PASS' if res['SB 원본 INDEX fresh'] == res['SB 힌트 INDEX+HASH'] == res['SB 힌트 FULL+HASH'] else 'FAIL'}")

print(f"\n원본 고정계획 재현 (call_timeout {TMO}s — 초과 = 타임아웃 재현)")
for k in ("SB 원본 INDEX", "SA 원본"):
    cn.call_timeout = TMO * 1000
    t = time.time()
    try:
        poisoned(k, VAR[k])
    except oracledb.Error as e:
        print(f"  {k:44} {time.time() - t:8.2f}s  ⚠ 중단 ({str(e).splitlines()[0][:80]})")
        break
try:
    cn.rollback(); cn.close()
except oracledb.Error:
    pass
