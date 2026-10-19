# 적용 후 검증 : 실제 PKG 호출 결과 == 원본(BASE, 적용 전 원문을 익명 블록으로 실행) — 행수 + 전 컬럼 해시
import sys, time, hashlib
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics\SCP0030_PERF_20261015')
from bench_get_bod_item import *
u, p, d = ora.conn_info(); c = oracledb.connect(user=u, password=p, dsn=d); cur = c.cursor()
cur.execute("ALTER SESSION SET statistics_level=ALL")
def pkg(args):
    r1 = cur.var(oracledb.CURSOR); r2 = cur.var(oracledb.CURSOR)
    t = time.time(); cur.callproc('PKG_SCP0030.P_SCP0030_GET_BOD_ITEM', args + [r1, r2]); r = r1.getvalue(); r.arraysize = 5000
    h = hashlib.md5(); n = 0
    while True:
        rows = r.fetchmany()
        if not rows: break
        for row in rows: h.update(repr(row).encode()); n += 1
    rs = r2.getvalue().fetchall()
    return time.time() - t, n, h.hexdigest(), rs
U = ['minyonglee1', 'SCP0030']
CASES = {
  'FULL(ALL)':         ['ALL','ALL','ALL','ALL','ALL','','','ALL'] + U,
  'DIV 81,40,82':      ['81,40,82','ALL','ALL','ALL','ALL','','','ALL'] + U,
  'DIV blank':         ['','ALL','ALL','ALL','ALL','','','ALL'] + U,
  'ITEM EM0482':       ['82','ALL','ALL','ALL','SEA','EM0482','','Y'] + U,
  'ITEM MCCH129520B1': ['81_UC,40','ALL','ALL','ALL','ALL','MCCH129520B1','','ALL'] + U,
  'ITEM=NICK H26A':    ['ALL','ALL','ALL','ALL','ALL','H26A','','ALL'] + U,
  'ITEM 2tok':         ['ALL','ALL','ALL','ALL','ALL','EM0482, mcch12','','ALL'] + U,
  'ITEM ALL literal':  ['ALL','ALL','ALL','ALL','ALL','ALL','','ALL'] + U,
  'ITEM comma only':   ['ALL','ALL','ALL','ALL','ALL',',','','ALL'] + U,
  'ITEM nomatch':      ['ALL','ALL','ALL','ALL','ALL','ZZZ_NO_ITEM','','ALL'] + U,
  'NICK P41A+VALID N': ['ALL','ALL','ALL','ALL','ALL','','P41A','N'] + U,
}
bad = 0
for nm, a in CASES.items():
    _, n0, h0 = run(cur, 'BASE', a)
    el, n1, h1, rs = pkg(a)
    ok = (n0, h0) == (n1, h1); bad += (not ok)
    print('%-18s BASE rows=%7d | PKG rows=%7d %.2fs %s RESULT=%s' % (nm, n0, n1, el, 'SAME' if ok else 'DIFF', rs))
print('DIFF CASES =', bad)
