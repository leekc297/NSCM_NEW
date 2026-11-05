"""[E20261102-DMF0082HINT] 교차 측정 — 원본(BASE) / 힌트(HINT, 01_BODY) 를 번갈아 적용하며 같은 호출을 잰다. 끝나면 BASE 상태로 둔다."""
import sys, os, json, time, hashlib, datetime
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb
import build_apply as ba
HERE = os.path.dirname(os.path.abspath(__file__))
BASE = open(ba.F_BAK, encoding='utf-8', newline='\n').read(); HINT = open(ba.F_NEW, encoding='utf-8', newline='\n').read()
cx, c = ba.conn()
USER = "minyonglee1"; FRM, TO = "20261101", "20270430"
out = []
def run(state):
    for div in ('40', '81', '82'):
        for i in range(2):
            outs = [c.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
            t0 = time.time(); c.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", [div, "", "", "", FRM, TO, "", "", "Current", "N", USER, USER, "", "", "", ""] + outs); t1 = time.time()
            k = outs[0].getvalue(); rows = k.fetchall(); t2 = time.time(); names = [d[0] for d in k.description]
            mi = names.index('MEASURE') if 'MEASURE' in names else None
            cnt = {}
            if mi is not None:
                for r in rows: cnt[r[mi]] = cnt.get(r[mi], 0) + 1
            dg = hashlib.md5(''.join(sorted(hashlib.md5(repr(x).encode()).hexdigest() for x in rows)).encode()).hexdigest()
            rec = {'state': state, 'div': div, 'run': i + 1, 'at': datetime.datetime.now().strftime('%H:%M:%S'), 'proc': round(t1 - t0, 2), 'fetch': round(t2 - t1, 2), 'rows': len(rows), 'rtf': cnt.get('RTF_SYS_RP'), 'digest': dg}
            out.append(rec); print(rec, flush=True); cx.rollback()
            json.dump(out, open(os.path.join(HERE, '_ab.json'), 'w', encoding='utf-8'), indent=0)
def switch(src, expect, name):
    now = ba.fetch(c)
    assert now.rstrip() == expect.rstrip(), '원문이 예상과 다름 — 중단(타 작업자 변경 가능)'
    errs = ba.compile_src(c, src); print('SWITCH', name, ba.info(c), 'ERR', len(errs), flush=True); assert not errs
assert ba.fetch(c).rstrip() == BASE.rstrip()
for cyc in range(2):
    switch(HINT, BASE, 'HINT'); run('HINT')
    switch(BASE, HINT, 'BASE'); run('BASE')
print('END BASE 상태', ba.info(c))
