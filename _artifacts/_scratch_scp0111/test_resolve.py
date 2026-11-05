# resolve_call_proc 회귀 시험 — 화면별 AS-IS 엔드포인트 SP + 대조표 SP 대상 전수: 종전 로직 vs 신규
import sys, os, re, importlib.util, csv
menu = sys.argv[1]; sys.argv = ['mapping_trace.py', menu]
spec = importlib.util.spec_from_file_location('mt', r'C:\Projects\NSCM\tools\Harness\verify\mapping_trace.py')
mt = importlib.util.module_from_spec(spec); spec.loader.exec_module(mt)
DOC = mt.DOC
pm_all = [r for r in mt.rdcsv(os.path.join(DOC, 'tobefacts', 'db', 'proc_meta.csv')) if r.get('proc')]
def old(name):  # 종전 F4 로직
    nm_t = name.split('.')[-1].upper()
    pm = [r for r in pm_all if r['proc'].split('.')[-1].upper() == nm_t]
    if not pm:
        tobe = {mt.tail(g.get('tobe_proc') or '-') for g in mt.rdcsv(os.path.join(DOC, 'golden', 'golden_cases.csv')) if g.get('screen', '').upper() == mt.MENU and mt.tail(g.get('asis_sp') or '-') == mt.tail(name) and g.get('tobe_proc')}
        if not tobe:
            nz = lambda x: re.sub(r'^P_', '', x.upper()).replace('_OSP', '')
            tobe = {r['proc'].split('.')[-1].upper() for r in pm_all if r['menu_id'].upper() == mt.MENU and nz(r['proc'].split('.')[-1]) == nz(nm_t)}
        pm = [r for r in pm_all if r['proc'].split('.')[-1].upper() in tobe]
    return pm
names = set()
led = os.path.join(DOC, 'verify', menu, 'verify_ledger.csv')
for r in mt.rdcsv(led):
    if r.get('rule_id') in ('F4', 'A6') and r.get('source') == 'TRACE': names.add(r['target'])
eps = mt.rdcsv(os.path.join(DOC, 'asisfacts', 'screens', mt.asis_id(), 'endpoints.csv'))
for e in eps:
    for m in re.finditer(r'\b[A-Z][A-Z0-9]*\.[A-Z0-9_]+\b', e.get('sp_or_sql') or ''): names.add(m.group(0))
for n in sorted(names):
    o = sorted({f"{r['sheet']}/{r['btn']}" for r in old(n)}); nw, via = mt.resolve_call_proc(n); nn = sorted({f"{r['sheet']}/{r['btn']}" for r in nw})
    flag = 'SAME' if o == nn else ('FIXED' if not o and nn else 'CHANGED')
    print(f"{flag:7} {n:55} old={o} new={nn} {via}")
