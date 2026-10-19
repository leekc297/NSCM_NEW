# -*- coding: utf-8 -*-
"""GET_MAIN_DATA 결과 동등성·시간 비교 — 패키지 A vs B, 6개 OUT 커서 전 행 정렬 SHA-256 + 행수.

화면 파라미터 = FE setFilters 원문(미선택 'ALL', itemId '', userGroup=ADMIN, 기간=당월1일~+6개월-1일).
각 패키지 warm 1회 후 측정 N회. 해시 = 각 행 repr 정렬 후 sha256 (행 순서 무관 — 순서는 별도 해시로도 기록).
사용: python v01_compare.py <div> <pkgA> <pkgB> [N=2] [warm=1]
"""
import datetime, hashlib, io, pathlib, sys, time
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1]))
from ora import conn_info
import oracledb

DIV, PA, PB = sys.argv[1], sys.argv[2], sys.argv[3]
N = int(sys.argv[4]) if len(sys.argv) > 4 else 2
WARM = (sys.argv[5] if len(sys.argv) > 5 else "1") == "1"
USER = "minyonglee1"
today = datetime.date.today()
frm = today.replace(day=1)
m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
IN = [DIV, "ALL", "ALL", "ALL", frm.strftime("%Y%m%d"), to.strftime("%Y%m%d"), "ALL", None, "Current", "N",
      USER, "ADMIN", "ALL", "ALL", "ALL", "ALL"]

u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 1800000
cur = cn.cursor()


def run(pkg):
    outs = [cn.cursor() for _ in range(6)]
    t0 = time.time()
    cur.callproc(f"SCM_MGR.{pkg}.P_DMF0082_GET_MAIN_DATA", IN + outs)
    t1 = time.time()
    res = []
    for oc in outs:
        oc.arraysize = 5000
        rows = oc.fetchall()
        cols = [c[0] for c in oc.description] if oc.description else []
        rs = [repr(tuple(r)) for r in rows]
        res.append((len(rows), hashlib.sha256("\n".join(sorted(rs)).encode()).hexdigest()[:16],
                    hashlib.sha256("\n".join(rs).encode()).hexdigest()[:16], len(cols)))
    t2 = time.time()
    cn.rollback()
    return t1 - t0, t2 - t1, res


out = {}
for pkg in (PA, PB):
    if WARM:
        run(pkg)  # warm
    ts = []
    for _ in range(N):
        sp, fe, res = run(pkg)
        ts.append(sp)
    out[pkg] = res
    print(f"{pkg:18} SP {' / '.join(f'{t:.2f}' for t in ts)}s  (fetch {fe:.2f}s)")
    for i, r in enumerate(res):
        print(f"    cur{i + 1}: rows={r[0]:>6} cols={r[3]:>4} sortedSHA={r[1]} orderSHA={r[2]}")
# cur3 = SYSDATE 기반 TODAY_DATE/DAY/TIME(HHMI) — 실행 시각 의존이라 행수·컬럼수만 비교
TIMEDEP = {2}
same = all((a[0] == b[0] and a[3] == b[3]) if i in TIMEDEP else (a[:2] == b[:2] and a[3] == b[3])
           for i, (a, b) in enumerate(zip(out[PA], out[PB])))
order = all(a[2] == b[2] for i, (a, b) in enumerate(zip(out[PA], out[PB])) if i not in TIMEDEP)
print(f"\n결과 동등성(행수+정렬해시+컬럼수): {'PASS' if same else 'FAIL'}   행 순서까지: {'PASS' if order else 'DIFF'}")
cn.close()
