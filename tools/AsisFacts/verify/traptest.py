# -*- coding: utf-8 -*-
"""주석/문자열/#if 함정 회귀 테스트. 사용: python traptest.py <AsisFacts outDir>"""
import csv, os, sys
out = sys.argv[1]
def rd(f): return list(csv.DictReader(open(os.path.join(out, f), encoding='utf-8-sig')))
sites = [r for r in rd('sites.csv') if r['target'] == 'FoxDataRequest' or r['site_kind'] == 'derived']
def state(r): return 'commented' if r['commented'] == '1' else ('inactive' if r['active'] == '0' else 'active')
got = {}
for r in sites:
    for v in r['values'].split(' || '):
        if 'T_' in v: got.setdefault(v.replace('DM.', ''), set()).add(state(r))
exp = {
 'T_ACTIVE_1': {'active'}, 'T_ACTIVE_2': {'active'}, 'T_ACTIVE_3': {'active'}, 'T_ACTIVE_4': {'active'},
 'T_ACTIVE_5': {'active'}, 'T_ACTIVE_6': {'active'}, 'T_ACTIVE_7': {'active'},
 'T_COMMENT_1': {'commented'}, 'T_COMMENT_2': {'commented'}, 'T_COMMENT_3': {'commented'},
 'T_COMMENT_4': {'commented'}, 'T_COMMENT_5': {'commented'}, 'T_INACTIVE_1': {'inactive'},
}
fail = 0
for k, v in exp.items():
    ok = got.get(k) == v
    fail += not ok
    print(('OK  ' if ok else 'FAIL'), k, 'expected', v, 'got', got.get(k))
extra = set(got) - set(exp) - {'{p:id}'}
if extra: print('FAIL unexpected:', extra); fail += 1
refs = rd('foxquery_sql_refs.csv')
names = {(r['key'], r['name']) for r in refs}
for k, n, want in [('DM.T_ACTIVE_3', 'REAL_TABLE', True), ('DM.T_ACTIVE_3', 'COMMENTED_TABLE', False), ('DM.T_ACTIVE_3', 'DEAD_TABLE', False)]:
    ok = ((k, n) in names) == want; fail += not ok
    print(('OK  ' if ok else 'FAIL'), 'sql ref', n, 'expected', want)
eps = rd('foxquery_endpoints.csv')
dead = [e for e in eps if e['id'] == 'T_XML_COMMENTED']
ok = len(dead) == 1 and dead[0]['commented'] == '1'; fail += not ok
print(('OK  ' if ok else 'FAIL'), 'xml commented endpoint recorded as commented')
evs = rd('events.csv'); evset = {(e['target'].replace('this.', ''), e['event']) for e in evs if e['op'] == '+='}
for tgt, ev, want in [('btnOk', 'Click', True), ('spdMain', 'CellClick', True), ('this', 'sum_week', False), ('this', 'i', False), ('this', 'Total', False)]:
    ok = ((tgt, ev) in evset) == want; fail += not ok
    print(('OK  ' if ok else 'FAIL'), 'event', tgt + '.' + ev, 'expected', want)
print('RESULT', 'PASS' if fail == 0 else f'FAIL({fail})')
sys.exit(1 if fail else 0)
