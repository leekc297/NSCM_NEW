# -*- coding: utf-8 -*-
"""facts_popup · gen_param_map 의미 분석 끔/켬 비교(2026-11-25). 원래 산출물은 끝에 되돌린다."""
import collections, csv, glob, json, os, shutil, subprocess, sys
ROOT = r'C:\Projects\NSCM'
V = os.path.join(ROOT, 'tools', 'Harness', 'verify')
OUT = os.path.join(ROOT, 'Doc', 'asisfacts_cmp', 'popfacts')
FD = os.path.join(ROOT, 'Doc', 'verify', '_parallel', 'E02', 'facts')
RULES = [os.path.join(ROOT, 'tools', 'Harness', 'rules', n) for n in ('sp_pair.csv', 'param_map.csv')]
csv.field_size_limit(10 ** 9)
sids = sorted(d for d in os.listdir(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens')) if d.startswith(('DMF', 'SCP', 'SSP')))
for d in ('orig', 'off', 'on'):
    os.makedirs(os.path.join(OUT, d), exist_ok=True)
# 원본 보관
shutil.copytree(FD, os.path.join(OUT, 'orig', 'facts'), dirs_exist_ok=True)
for r in RULES:
    shutil.copy2(r, os.path.join(OUT, 'orig', os.path.basename(r)))
gp_sids = sorted({r['menu_id'] for r in csv.DictReader(open(RULES[0], encoding='utf-8-sig')) if r.get('menu_id', '').startswith(('DMF', 'SCP', 'SSP'))})
for mode in ('off', 'on'):
    env = dict(os.environ, ASIS_SEM_OFF='1' if mode == 'off' else '0')
    r = subprocess.run([sys.executable, '-I', os.path.join(V, 'facts_popup.py')] + sids, env=env, capture_output=True, text=True, encoding='utf-8', errors='replace')
    print(mode, 'facts_popup rc', r.returncode, (r.stderr or '')[-300:], flush=True)
    os.makedirs(os.path.join(OUT, mode, 'facts'), exist_ok=True)
    for s in sids:
        f = os.path.join(FD, s + '.json')
        if os.path.exists(f):
            shutil.copy2(f, os.path.join(OUT, mode, 'facts', s + '.json'))
    r = subprocess.run([sys.executable, os.path.join(V, 'gen_param_map.py')] + gp_sids, env=env, capture_output=True, text=True, encoding='utf-8', errors='replace')
    print(mode, 'gen_param_map rc', r.returncode, (r.stderr or '')[-300:], flush=True)
    for rr in RULES:
        shutil.copy2(rr, os.path.join(OUT, mode, os.path.basename(rr)))
# 되돌림
shutil.copytree(os.path.join(OUT, 'orig', 'facts'), FD, dirs_exist_ok=True)
for rr in RULES:
    shutil.copy2(os.path.join(OUT, 'orig', os.path.basename(rr)), rr)


def eps(mode):
    n = collections.Counter(); pops = collections.Counter()
    for s in sids:
        f = os.path.join(OUT, mode, 'facts', s + '.json')
        if not os.path.exists(f):
            continue
        t = open(f, encoding='utf-8').read()
        n[s] = t.count('"endpoint"') - t.count('"endpoint": ""')
        try:
            j = json.load(open(f, encoding='utf-8'))
            for p in (j.get('popups') if isinstance(j, dict) else j) or []:
                pops['sp 있음' if (p.get('sp') or p.get('sps') or p.get('endpoints')) else 'sp 없음'] += 1
        except Exception:
            pass
    return n, pops


for m in ('off', 'on'):
    n, pops = eps(m)
    print(m, 'facts_popup endpoint 표기', sum(n.values()), dict(pops))
no, nn = eps('off')[0], eps('on')[0]
print('endpoint 늘어난 화면', [(s, no[s], nn[s]) for s in sids if nn[s] != no[s]][:30])
for m in ('off', 'on'):
    sp = list(csv.DictReader(open(os.path.join(OUT, m, 'sp_pair.csv'), encoding='utf-8-sig')))
    pm = list(csv.DictReader(open(os.path.join(OUT, m, 'param_map.csv'), encoding='utf-8-sig')))
    print(m, 'sp_pair', len(sp), '짝 있음', sum(1 for r in sp if r.get('tobe_proc')), '· param_map', len(pm), dict(collections.Counter(r.get('status') for r in pm)))
a = {(r['menu_id'], r['asis_sp']) for r in csv.DictReader(open(os.path.join(OUT, 'off', 'sp_pair.csv'), encoding='utf-8-sig'))}
b = [r for r in csv.DictReader(open(os.path.join(OUT, 'on', 'sp_pair.csv'), encoding='utf-8-sig')) if (r['menu_id'], r['asis_sp']) not in a]
print('켬에만 있는 sp_pair', len(b))
for r in b[:20]:
    print(' ', r['menu_id'], r['asis_sp'], r['tobe_proc'], r.get('note', '')[:80])
