# -*- coding: utf-8 -*-
"""_batch_before.json vs _batch_after.json — 두 세션 재계산 결과 행 단위 대조."""
import json, sys, collections
sys.stdout.reconfigure(encoding='utf-8')
A = json.load(open('_batch_before.json', encoding='utf-8')); B = json.load(open(f'_batch_{sys.argv[1] if len(sys.argv) > 1 else "after"}.json', encoding='utf-8'))
print('before', A['at'], 'after', B['at'])
for d in A['divs']:
    a, b = A['divs'][d]['after'], B['divs'][d]['after']
    new = {k: b[k] for k in b if k not in a}
    gone = {k: a[k] for k in a if k not in b}
    chg = {k: (a[k], b[k]) for k in a if k in b and a[k] != b[k]}
    print(f"-- {d} sec {A['divs'][d]['sec']} -> {B['divs'][d]['sec']} rows {len(a)} -> {len(b)} new {len(new)} gone {len(gone)} changed {len(chg)}")
    print('   new by measure', collections.Counter(k.split('|')[6] for k in new))
    print('   gone by measure', collections.Counter(k.split('|')[6] for k in gone))
    print('   changed by measure', collections.Counter(k.split('|')[6] for k in chg))
    for k, v in list(new.items())[:3]: print('   new', k, v)
    for k, v in list(chg.items())[:4]: print('   chg', k, v)
