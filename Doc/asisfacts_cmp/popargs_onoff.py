# -*- coding: utf-8 -*-
"""popup_args_check 의미 분석 끔/켬 비교(2026-11-25). 원래 popup_args.csv 는 끝에 되돌린다."""
import collections, csv, glob, os, shutil, subprocess, sys, time
ROOT = r'C:\Projects\NSCM'
V = os.path.join(ROOT, 'tools', 'Harness', 'verify')
sys.path.insert(0, V)
import popup_args_check as PA  # noqa: E402
csv.field_size_limit(10 ** 9)
OUT = os.path.join(ROOT, 'Doc', 'asisfacts_cmp', 'popargs')
sids = sorted(os.path.basename(os.path.dirname(f)) for f in glob.glob(os.path.join(ROOT, 'Doc', 'verify', '*', 'popup_args.csv'))
              if os.path.basename(os.path.dirname(f)).startswith(('DMF', 'SCP', 'SSP')))
for d in ('orig', 'off', 'on'):
    os.makedirs(os.path.join(OUT, d), exist_ok=True)
for s in sids:
    shutil.copy2(os.path.join(ROOT, 'Doc', 'verify', s, 'popup_args.csv'), os.path.join(OUT, 'orig', s + '.csv'))
# 캐시 예열: 전 화면 질의 한 번에
acts = []
for s in sids:
    ap = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', s, 'actions.csv')
    if os.path.exists(ap):
        acts += list(csv.DictReader(open(ap, encoding='utf-8-sig')))
t0 = time.time()
sem = PA.sem_prefetch(acts)
import asis_sem  # noqa: E402
print('예열', len(sem), '건', asis_sem.LAST, f'{time.time() - t0:.0f}s', flush=True)
res = {}
for mode in ('off', 'on'):
    env = dict(os.environ, ASIS_SEM_OFF='1' if mode == 'off' else '0')
    for s in sids:
        subprocess.run([sys.executable, os.path.join(V, 'popup_args_check.py'), s], env=env, capture_output=True, text=True, encoding='utf-8', errors='replace')
        shutil.copy2(os.path.join(ROOT, 'Doc', 'verify', s, 'popup_args.csv'), os.path.join(OUT, mode, s + '.csv'))
    print(mode, '끝', flush=True)
for s in sids:
    shutil.copy2(os.path.join(OUT, 'orig', s + '.csv'), os.path.join(ROOT, 'Doc', 'verify', s, 'popup_args.csv'))
key = lambda r: (r['side'], r['asis_ref'], r['asis_param'], r['tobe_ref'], r['tobe_key'])
tot = {m: collections.Counter() for m in ('off', 'on')}
chg = collections.Counter(); ex = []
for s in sids:
    rr = {m: list(csv.DictReader(open(os.path.join(OUT, m, s + '.csv'), encoding='utf-8-sig'))) for m in ('off', 'on')}
    for m in rr:
        tot[m].update(r['verdict'] for r in rr[m])
    a = {key(r): r for r in rr['off']}
    for r in rr['on']:
        o = a.get(key(r))
        if o and (o['verdict'] != r['verdict'] or o['asis_source'] != r['asis_source']):
            chg[(o['verdict'], r['verdict'])] += 1
            ex.append((s, o['verdict'], r['verdict'], r['asis_arg'][:20], o['asis_source'][:30], r['asis_source'][:50], r['note'][:80]))
print('화면', len(sids), '· 끔', dict(tot['off']), '· 켬', dict(tot['on']))
print('바뀐 행(판정 전→후)', dict(chg))
for e in ex[:40]:
    print(' ', e)
