# -*- coding: utf-8 -*-
"""DMF0082 조회(P_DMF0082_GET_MAIN_DATA) 문장별 시간 귀속 — hook #129 ⓪-b.

dmf0082_stage_profile.py(2026-09-07) 방식 계승 + 보강:
  · division / userGroup 인자화 (화면 실전달값 = CMBO FcstPriceUserAuthGroup 첫 행 'ADMIN', 09-30 실측)
  · SP 실행 시간과 메인 커서 fetch 시간을 분리 (HTTP 총소요와 대조용)
  · 귀속 = 내 SID 한정 ASH, SQL_ID × PLAN_LINE 단위 (V$SQL 델타는 인스턴스 전역이라 오귀속)
  · 재귀 SQL(함수 내부) 은 TOP_LEVEL_SQL_ID 로 호출 문장에 묶어 함께 표시
사용: python p01_stage_profile.py <div> [반복=1] [group=ADMIN]
"""
import io, pathlib, re, sys, time, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

DIV = sys.argv[1] if len(sys.argv) > 1 else "40"
REPEAT = int(sys.argv[2]) if len(sys.argv) > 2 else 1
GRP = sys.argv[3] if len(sys.argv) > 3 else "ADMIN"
USER = "minyonglee1"

today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)

# FE setFilters 원문 매핑 (IN 인자명 → 값, 순서=BE procExec: deptId→P_TEAM_ID, endCustomer→P_CUSTOMER, salesSite→P_SCM_SITE_ID). 미선택 멀티 = 'ALL', itemId = ''.
P = {
    "P_DIVISION_ID": DIV, "P_TEAM_ID": "ALL", "P_CUSTOMER": "ALL", "P_BIZ_TYPE": "ALL",
    "P_FROM_YYYYMMDD": frm.strftime("%Y%m%d"), "P_TO_YYYYMMDD": to.strftime("%Y%m%d"),
    "P_SCM_SITE_ID": "ALL", "P_ITEM_ID": None, "P_VERSION_TYPE": "Current", "P_QTY_YN": "N",
    "P_CREATED_BY": USER, "P_USER_GROUP": GRP, "P_PLANT_SITE_ID": "ALL",
    "P_PROJECT_CODE": "ALL", "P_OWNER": "ALL", "P_SENDER_CODE": "ALL",
}

u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 1800000
cur = cn.cursor()
cur.execute("SELECT SYS_CONTEXT('USERENV','SID'), SYSTIMESTAMP FROM DUAL")
sid, t_begin = cur.fetchone()
sid = int(sid)

cur.execute("SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
src = [(ln, (tx or "").rstrip()) for ln, tx in cur]
offsets, parts, pos = [], [], 0
for ln, t in src:
    piece = re.sub(r"\s+", " ", t).strip()
    offsets.append((pos, ln)); parts.append(piece); pos += len(piece) + 1
norm_src = " ".join(parts).upper()


def line_of(off):
    lo, hi, best = 0, len(offsets) - 1, offsets[0][1]
    while lo <= hi:
        mid = (lo + hi) // 2
        if offsets[mid][0] <= off:
            best = offsets[mid][1]; lo = mid + 1
        else:
            hi = mid - 1
    return best


cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME='PKG_DMF0082'"
            " AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL=0 ORDER BY POSITION")
args = cur.fetchall()
miss = [a for a, io_ in args if io_ == "IN" and a not in P]
if miss:
    sys.exit(f"IN 인자 매핑 누락: {miss}")

print(f"div={DIV} group={GRP} 기간 {P['P_FROM_YYYYMMDD']}~{P['P_TO_YYYYMMDD']} SID={sid}")
for r in range(REPEAT):
    ins, outs = [], []
    for a, io_ in args:
        (ins.append(P[a]) if io_ == "IN" else outs.append(cn.cursor()))
    t0 = time.time()
    cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", ins + outs)
    t1 = time.time()
    cnts = []
    for oc in outs:
        oc.arraysize = 5000
        n = 0
        while True:
            b = oc.fetchmany(5000)
            if not b:
                break
            n += len(b)
        cnts.append(n)
    t2 = time.time()
    cn.rollback()
    print(f"  run{r + 1}: SP {t1 - t0:6.2f}s  fetch {t2 - t1:6.2f}s  rows={cnts}")

time.sleep(2)
cur.execute("""
WITH A AS (
  SELECT SQL_ID, TOP_LEVEL_SQL_ID, SQL_PLAN_LINE_ID, NVL(EVENT,'ON CPU') EVT
    FROM V$ACTIVE_SESSION_HISTORY
   WHERE SESSION_ID = :s AND SAMPLE_TIME >= :t),
T AS (SELECT SQL_ID, MIN(SQL_TEXT) TXT FROM V$SQL
       WHERE SQL_ID IN (SELECT SQL_ID FROM A UNION SELECT TOP_LEVEL_SQL_ID FROM A) GROUP BY SQL_ID)
SELECT A.SQL_ID, A.TOP_LEVEL_SQL_ID, A.SQL_PLAN_LINE_ID, A.EVT, COUNT(*) N, T1.TXT, T2.TXT
  FROM A LEFT JOIN T T1 ON T1.SQL_ID = A.SQL_ID LEFT JOIN T T2 ON T2.SQL_ID = A.TOP_LEVEL_SQL_ID
 GROUP BY A.SQL_ID, A.TOP_LEVEL_SQL_ID, A.SQL_PLAN_LINE_ID, A.EVT, T1.TXT, T2.TXT
""", s=sid, t=t_begin)
rows = cur.fetchall()

stmt = {}
for sql_id, top, pl, evt, n, txt, toptxt in rows:
    key = re.sub(r"\s+", " ", (txt or "")).strip().upper()
    off = norm_src.find(key[:120]) if len(key) > 40 else -1
    if off < 0 and len(key) > 60:
        off = norm_src.find(key[:60])
    line = line_of(off) if off >= 0 else None
    k = (line, sql_id)
    e = stmt.setdefault(k, {"n": 0, "pl": {}, "evt": {}, "txt": key[:90], "top": top})
    e["n"] += n
    e["pl"][pl] = e["pl"].get(pl, 0) + n
    e["evt"][evt] = e["evt"].get(evt, 0) + n

total = sum(e["n"] for e in stmt.values())
print(f"\n{'라인':>6} {'샘플':>5} {'비중':>6} {'SQL_ID':14} 상위라인(샘플)            이벤트          문장")
for (line, sql_id), e in sorted(stmt.items(), key=lambda kv: -kv[1]["n"]):
    if e["n"] < 1:
        continue
    pls = ",".join(f"{k}:{v}" for k, v in sorted(e["pl"].items(), key=lambda kv: -kv[1])[:4])
    ev = max(e["evt"], key=e["evt"].get)
    print(f"{str(line) if line else '(외부)':>6} {e['n']:5} {e['n'] * 100 / max(total, 1):5.1f}% {sql_id or '-':14} "
          f"{pls:24} {ev[:14]:14} {e['txt']}")
print(f"\n총 ASH 샘플 {total} (≈초) / {REPEAT}회")
cn.close()
