# -*- coding: utf-8 -*-
"""DMF0082 조회(P_DMF0082_GET_MAIN_DATA) — 10046 트레이스 기반 문장별 시간 귀속 (hook #129 ⓪-b 정본).

왜 트레이스인가 (09-30 실측):
  · ASH 1초 샘플 = 해상도 부족 (6.8초가 문장 수십 개로 흩어짐, 15 샘플)
  · V$SQL PROGRAM_ID 귀속 = 동적 SQL 누락 (0.15s 만 잡힘)
  · V$SQL 전역 델타 = 타 세션(DBeaver get_ddl) 오염 + GTT 통계수집(NO_INVALIDATE=>FALSE)의 커서 무효화로 누락
  ⇒ 10046(level 8) 은 **내 세션 한정·문장별 정확 시간**이다. V$DIAG_TRACE_FILE_CONTENTS 로 DB 에서 읽는다.

집계:
  · dep=1 커서(= PKG 가 직접 실행한 SQL) 별 PARSE/EXEC/FETCH e(µs) 합, 실행수, 행수, 하드파싱(mis=1) 수
    — EXEC e 는 그 문장이 부른 함수 재귀 SQL 시간을 포함한다
  · 구간 갭: dep=1 호출 사이 시간 = PL/SQL 로직 + DBMS_STATS 등 비커서 호출. 갭 안에서 돈 dep>=2 재귀 SQL 을
    보고 'DBMS_STATS' 여부를 표시 (OPTSTAT/dbms_stats 텍스트)
  · 소스 라인 = PKG_DMF0082 BODY 정규화 텍스트 매칭
사용: python p03_trace_profile.py <div> [group=ADMIN] [warm=1]
  warm=1 이면 트레이스 전 1회 선실행(BE 풀 세션 재사용 모사). 결과 원문 = p03_div<div>.trc.txt 로 저장.
"""
import io, pathlib, re, sys, time, datetime
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))
from ora import conn_info
import oracledb

DIV = sys.argv[1] if len(sys.argv) > 1 else "40"
GRP = sys.argv[2] if len(sys.argv) > 2 else "ADMIN"
WARM = (sys.argv[3] if len(sys.argv) > 3 else "1") == "1"
USER = "minyonglee1"
import os
PKG = os.environ.get("QPT_PKG", "PKG_DMF0082")  # 실험 패키지 트레이스 시 QPT_PKG=PKG_DMF0082_QPT

today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
# 순서 = BE procExec (deptId→P_TEAM_ID, endCustomer→P_CUSTOMER, salesSite→P_SCM_SITE_ID). 미선택 멀티 = 'ALL'
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
cur.execute("SELECT ARGUMENT_NAME, IN_OUT FROM USER_ARGUMENTS WHERE PACKAGE_NAME='PKG_DMF0082'"
            " AND OBJECT_NAME='P_DMF0082_GET_MAIN_DATA' AND DATA_LEVEL=0 ORDER BY POSITION")
args = cur.fetchall()
assert not [a for a, io_ in args if io_ == "IN" and a not in P]


def run_once():
    ins, outs = [], []
    for a, io_ in args:
        (ins.append(P[a]) if io_ == "IN" else outs.append(cn.cursor()))
    t0 = time.time()
    cur.callproc(f"{PKG}.P_DMF0082_GET_MAIN_DATA", ins + outs)
    t1 = time.time()
    cnt = []
    for oc in outs:
        oc.arraysize = 5000
        n = 0
        while True:
            b = oc.fetchmany(5000)
            if not b:
                break
            n += len(b)
        cnt.append(n)
    t2 = time.time()
    cn.rollback()
    return t1 - t0, t2 - t1, cnt


if WARM:
    sp, fe, cnt = run_once()
    print(f"warm : SP {sp:.2f}s fetch {fe:.2f}s rows={cnt}")
tag = f"Q0082_{DIV}_{int(time.time())}"
cur.execute(f"ALTER SESSION SET tracefile_identifier='{tag}'")
cur.execute("ALTER SESSION SET EVENTS '10046 trace name context forever, level 8'")
sp, fe, cnt = run_once()
cur.execute("ALTER SESSION SET EVENTS '10046 trace name context off'")
print(f"trace: SP {sp:.2f}s fetch {fe:.2f}s rows={cnt}")
cur.execute("SELECT VALUE FROM V$DIAG_INFO WHERE NAME='Default Trace File'")
fn = re.split(r"[\\/]", cur.fetchone()[0])[-1]
cur.execute("SELECT PAYLOAD FROM V$DIAG_TRACE_FILE_CONTENTS WHERE TRACE_FILENAME=:f ORDER BY LINE_NUMBER", f=fn)
lines = []
for (pl,) in cur:
    lines.extend((pl or "").split("\n"))
(HERE / f"p03_div{DIV}.trc.txt").write_text("\n".join(lines), encoding="utf-8")

# --- 소스 매핑 ---
cur.execute("SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
offs, parts, pos = [], [], 0
for ln, t in cur:
    pc = re.sub(r"\s+", " ", (t or "")).strip()
    offs.append((pos, ln)); parts.append(pc); pos += len(pc) + 1
NORM = " ".join(parts).upper()


def src_line(txt):
    key = re.sub(r"\s+", " ", txt or "").strip().upper()
    for L in (120, 60, 40):
        if len(key) >= L:
            off = NORM.find(key[:L])
            if off >= 0:
                lo, hi, best = 0, len(offs) - 1, offs[0][1]
                while lo <= hi:
                    mid = (lo + hi) // 2
                    if offs[mid][0] <= off:
                        best = offs[mid][1]; lo = mid + 1
                    else:
                        hi = mid - 1
                return best
    return None


# --- 트레이스 파싱 ---
re_pic = re.compile(r"^PARSING IN CURSOR #(\d+) len=\d+ dep=(\d+) .*?sqlid='(\w+)'")
re_call = re.compile(r"^(PARSE|EXEC|FETCH) #(\d+):c=(\d+),e=(\d+),p=\d+,cr=(\d+),cu=(\d+),mis=(\d),r=(\d+),dep=(\d+),.*?tim=(\d+)")
re_wait = re.compile(r"^WAIT #(\d+): nam='([^']+)' ela=\s*(\d+)")
cur_sql, sql_txt = {}, {}
stat = {}          # sqlid -> dict (dep=1 only)
events = []        # dep=1 호출 타임라인: (start, end, sqlid)
rec = []           # dep>=2 호출: (start, end, sqlid)
waits = {}
i = 0
while i < len(lines):
    ln = lines[i]
    mm = re_pic.match(ln)
    if mm:
        c, dep, sid = mm.group(1), int(mm.group(2)), mm.group(3)
        txt = lines[i + 1] if i + 1 < len(lines) else ""
        j = i + 2
        while j < len(lines) and lines[j] != "END OF STMT" and j < i + 60:
            txt += " " + lines[j]; j += 1
        cur_sql[c] = (sid, dep)
        sql_txt.setdefault(sid, txt)
        i = j + 1
        continue
    mc = re_call.match(ln)
    if mc:
        kind, c, cpu, e, cr, cu, mis, r, dep, tim = mc.groups()
        e, tim, dep = int(e), int(tim), int(dep)
        sid = cur_sql.get(c, ("?" + c, dep))[0]
        if dep == 1:
            s = stat.setdefault(sid, {"PARSE": 0, "EXEC": 0, "FETCH": 0, "n": 0, "rows": 0, "mis": 0, "lio": 0})
            s[kind] += e
            s["lio"] += int(cr) + int(cu)
            if kind == "EXEC":
                s["n"] += 1
            if kind in ("EXEC", "FETCH"):
                s["rows"] += int(r)
            s["mis"] += int(mis)
            events.append((tim - e, tim, sid))
        elif dep >= 2:
            rec.append((tim - e, tim, sid))
    mw = re_wait.match(ln)
    if mw:
        waits[mw.group(2)] = waits.get(mw.group(2), 0) + int(mw.group(3))
    i += 1

tot = sp * 1e6
d1 = sum(s["PARSE"] + s["EXEC"] + s["FETCH"] for s in stat.values())
events.sort()
# 갭 = dep1 호출 사이. 갭 안의 재귀(dep>=2) SQL 중 통계수집 계열 비중으로 라벨
gap_stats, gap_other = 0, 0
gap_rows = []
for k in range(1, len(events)):
    g0, g1 = events[k - 1][1], events[k][0]
    if g1 - g0 <= 0:
        continue
    inside = [r for r in rec if r[0] >= g0 and r[1] <= g1]
    is_st = any(re.search(r"OPTSTAT|dbms_stats|DBMS_STATS|SQL ANALYZE", sql_txt.get(r[2], ""), re.I) for r in inside)
    if is_st:
        gap_stats += g1 - g0
    else:
        gap_other += g1 - g0
    if g1 - g0 > 50000:
        gap_rows.append((g1 - g0, events[k - 1][2], events[k][2], "STATS" if is_st else "PLSQL/기타"))

print(f"\ndiv={DIV} group={GRP}  SP {sp:.2f}s  | dep=1 SQL 합 {d1 / 1e6:.2f}s  | 갭: DBMS_STATS {gap_stats / 1e6:.2f}s  "
      f"PL/SQL·기타 {gap_other / 1e6:.2f}s")
print(f"\n{'라인':>6} {'초':>7} {'비중':>6} {'parse':>6} {'exec':>7} {'fetch':>6} {'실행':>5} {'하드':>4} {'LIO':>11} {'행':>9}  sqlid          문장")
for sid, s in sorted(stat.items(), key=lambda kv: -(kv[1]["PARSE"] + kv[1]["EXEC"] + kv[1]["FETCH"])):
    t = s["PARSE"] + s["EXEC"] + s["FETCH"]
    if t < 20000:
        continue
    txt = " ".join(sql_txt.get(sid, "").split())
    print(f"{str(src_line(txt) or '-'):>6} {t / 1e6:7.3f} {t * 100 / tot:5.1f}% {s['PARSE'] / 1e6:6.2f} {s['EXEC'] / 1e6:7.2f} "
          f"{s['FETCH'] / 1e6:6.2f} {s['n']:5} {s['mis']:4} {s['lio']:11,} {s['rows']:9,}  {sid:14} {txt[:80]}")
# --- 범주 합계 (dep=1 만 — 자식 시간 중복 없음) ---
ST_RE = re.compile(r"dbms_stats|SQL Analyze|substrb\(dump\(val|ora_temp_\d|_parallel_syspls_obey_force|"
                   r"V\$SESSION_FIX_CONTROL|COUNT\(UNQ\)|use_nl\(o c cu h\)|POS\+1 POS|OPTSTAT", re.I)
cat = {}
for sid, s_ in stat.items():
    txt = " ".join(sql_txt.get(sid, "").split())
    k = "STATS(통계수집)" if ST_RE.search(txt) else ("PKG 문장" if src_line(txt) else "기타(매칭불가)")
    c_ = cat.setdefault(k, [0, 0, 0, 0])
    c_[0] += s_["PARSE"] + s_["EXEC"] + s_["FETCH"]; c_[1] += s_["mis"]; c_[2] += s_["PARSE"]; c_[3] += 1
print("\n[범주 합계 dep=1]")
for k, v in sorted(cat.items(), key=lambda kv: -kv[1][0]):
    print(f"  {k:16} {v[0] / 1e6:7.3f}s  문장 {v[3]:4}  하드파싱 {v[1]:4}  PARSE콜 {v[2] / 1e6:.3f}s")
hp = sum(1 for l in lines if re.match(r"^(PARSE|EXEC) #\d+:.*mis=1", l))
print(f"  전체 하드파싱 이벤트 {hp} (재귀 포함)")
print("\n[기타(매칭불가) 상위]")
for sid, s_ in sorted(stat.items(), key=lambda kv: -(kv[1]["PARSE"] + kv[1]["EXEC"] + kv[1]["FETCH"])):
    txt = " ".join(sql_txt.get(sid, "").split())
    if ST_RE.search(txt) or src_line(txt):
        continue
    t = s_["PARSE"] + s_["EXEC"] + s_["FETCH"]
    if t > 20000:
        print(f"  {t / 1e6:6.3f}s {sid} {txt[:140]}")

print("\n[갭 > 50ms]")
for g, a, b, lab in sorted(gap_rows, reverse=True)[:25]:
    ta = " ".join(sql_txt.get(a, "").split())[:50]
    print(f"  {g / 1e6:6.3f}s {lab:10} after {src_line(sql_txt.get(a, '')) or '-'}:{ta}")
print("\n[대기 이벤트 합]")
for k, v in sorted(waits.items(), key=lambda kv: -kv[1])[:8]:
    print(f"  {v / 1e6:7.3f}s  {k}")
cn.close()
