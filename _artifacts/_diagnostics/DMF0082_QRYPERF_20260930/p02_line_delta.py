# -*- coding: utf-8 -*-
"""DMF0082 조회 — PKG 소스 라인별 소요 (V$SQL 델타, PROGRAM_ID/PROGRAM_LINE# 귀속).

ASH(1초 샘플)는 문장 수십 개로 흩어진 6~7초를 가를 해상도가 없다(p01 실측: 15 샘플).
V$SQL.PROGRAM_ID = PKG_DMF0082 BODY OBJECT_ID 인 커서의 ELAPSED/EXEC/BUFFER 델타를 PROGRAM_LINE# 로 모은다.
커서 동일성 키에 FIRST_LOAD_TIME·CHILD_ADDRESS 포함 (계측 무결성 M1 — 되감긴 커서 탈락 방지).
PKG 밖 시간(DBMS_STATS 내부 재귀 SQL 등)은 PROGRAM_ID 가 PKG 가 아니라 별도 합계로 보인다.
⚠ V$SQL 은 인스턴스 전역 — 같은 시각 타 세션이 DMF0082 를 돌리면 섞인다. EXECUTIONS 델타로 확인.
사용: python p02_line_delta.py <div> [반복=2] [group=ADMIN]
"""
import io, pathlib, re, sys, time, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

DIV = sys.argv[1] if len(sys.argv) > 1 else "40"
REPEAT = int(sys.argv[2]) if len(sys.argv) > 2 else 2
GRP = sys.argv[3] if len(sys.argv) > 3 else "ADMIN"
USER = "minyonglee1"

today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
# 순서 = BE procExec (deptId→P_TEAM_ID, endCustomer→P_CUSTOMER, salesSite→P_SCM_SITE_ID)
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
cur.execute("SELECT OBJECT_ID FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
OBJ = cur.fetchone()[0]
cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME='PKG_DMF0082'"
            " AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL=0 ORDER BY POSITION")
args = cur.fetchall()
assert not [a for a, io_ in args if io_ == "IN" and a not in P]

# 2차(09-30): PROGRAM_ID 필터는 동적 SQL(EXECUTE IMMEDIATE) 을 못 잡는다(0.15s 만 귀속 실측) →
#   전역 V$SQL 델타 + 소스 텍스트 매칭으로 라인 귀속. DB 한산 시간대(활성 사용자 세션 1) 에만 신뢰.
SNAP = """SELECT SQL_ID, CHILD_ADDRESS, FIRST_LOAD_TIME, 0, EXECUTIONS, ELAPSED_TIME,
                 CPU_TIME, BUFFER_GETS, ROWS_PROCESSED, PLAN_HASH_VALUE, SUBSTR(SQL_TEXT,1,200)
            FROM V$SQL WHERE SQL_TEXT NOT LIKE 'SELECT SQL_ID, CHILD_ADDRESS%'"""

cur.execute("SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
_src = [(ln, (tx or "").rstrip()) for ln, tx in cur]
_offs, _parts, _pos = [], [], 0
for ln, t in _src:
    pc = re.sub(r"\s+", " ", t).strip()
    _offs.append((_pos, ln)); _parts.append(pc); _pos += len(pc) + 1
NORM = " ".join(_parts).upper()


def src_line(txt):
    key = re.sub(r"\s+", " ", txt or "").strip().upper()
    off = NORM.find(key[:120]) if len(key) > 40 else -1
    if off < 0 and len(key) > 60:
        off = NORM.find(key[:60])
    if off < 0:
        return "(외부)"
    best = _offs[0][1]
    lo, hi = 0, len(_offs) - 1
    while lo <= hi:
        mid = (lo + hi) // 2
        if _offs[mid][0] <= off:
            best = _offs[mid][1]; lo = mid + 1
        else:
            hi = mid - 1
    return best


def snap():
    cur.execute(SNAP)
    return {(r[0], r[1], r[2]): r for r in cur}


def run_once():
    ins, outs = [], []
    for a, io_ in args:
        (ins.append(P[a]) if io_ == "IN" else outs.append(cn.cursor()))
    t0 = time.time()
    cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", ins + outs)
    t1 = time.time()
    for oc in outs:
        oc.arraysize = 5000
        while oc.fetchmany(5000):
            pass
    t2 = time.time()
    cn.rollback()
    return t1 - t0, t2 - t1


run_once()  # 워밍업(하드파싱 제외) — 세션 재사용 조건(BE 풀) 모사
agg = {}
tot_sp = 0.0
for i in range(REPEAT):
    a = snap()
    sp, fe = run_once()
    b = snap()
    tot_sp += sp
    print(f"run{i + 1}: SP {sp:.2f}s fetch {fe:.2f}s")
    for k, rb in b.items():
        ra = a.get(k)
        de = rb[4] - (ra[4] if ra else 0)
        if de <= 0:
            continue
        e = agg.setdefault((src_line(rb[10]), rb[0]), {"ex": 0, "el": 0, "cpu": 0, "bg": 0, "rows": 0, "ids": set(), "txt": rb[10]})
        e["ex"] += de
        e["el"] += rb[5] - (ra[5] if ra else 0)
        e["cpu"] += rb[6] - (ra[6] if ra else 0)
        e["bg"] += rb[7] - (ra[7] if ra else 0)
        e["rows"] += rb[8] - (ra[8] if ra else 0)
        e["ids"].add(f"{rb[0]}/{rb[9]}")

tot_el = sum(e["el"] for e in agg.values()) / 1e6
print(f"\ndiv={DIV} group={GRP} 반복={REPEAT}  SP 평균 {tot_sp / REPEAT:.2f}s  PKG 문장 합계 {tot_el / REPEAT:.2f}s/회"
      f"  (차이 = PKG 밖: DBMS_STATS·PL/SQL 로직·재귀)")
print(f"{'라인':>6} {'초/회':>7} {'비중':>6} {'실행/회':>7} {'BG/회':>11} {'행/회':>9}  SQL_ID/PHV  문장")
for (ln, _sid), e in sorted(agg.items(), key=lambda kv: -kv[1]["el"]):
    s = e["el"] / 1e6 / REPEAT
    if s < 0.02:
        continue
    print(f"{str(ln):>6} {s:7.3f} {s * 100 / max(tot_sp / REPEAT, 1e-9):5.1f}% {e['ex'] / REPEAT:7.0f} "
          f"{e['bg'] / REPEAT:11,.0f} {e['rows'] / REPEAT:9,.0f}  {','.join(sorted(e['ids']))[:34]:34} "
          f"{' '.join((e['txt'] or '').split())[:70]}")
cn.close()
