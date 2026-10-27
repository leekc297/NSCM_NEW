# -*- coding: utf-8 -*-
"""매핑·블록 보정 후 쌍 재산정: c01~c10(투입분) 중 유효 쌍 재사용, 나머지 → cmp/n##.jsonl"""
import json, os, shutil
B = os.path.dirname(os.path.abspath(__file__))
os.chdir(B)
src = open('build_compare.py', encoding='utf-8').read()
src = src.split("os.makedirs(os.path.join(B, 'cmp'), exist_ok=True)")[0]
g = {'__file__': os.path.join(B, 'build_compare.py'), '__name__': 'bc'}
exec(compile(src, 'build_compare.py', 'exec'), g)
pairs = g['pairs']
disp = {}
for i in range(1, 11):
    for l in open(f'cmp/c{i:02d}.jsonl', encoding='utf-8'):
        p = json.loads(l)
        disp[(p['asis_sp'], p['tobe'], p['start'])] = (p['end'], f'c{i:02d}')
valid, todo = [], []
for p in pairs:
    k = (p['asis_sp'], p['tobe'], p['start'])
    if k in disp and disp[k][0] >= p['end']:
        valid.append([*k, disp[k][1]])
    else:
        todo.append(p)
os.makedirs('cmp_old', exist_ok=True)
for i in range(11, 39):
    f = f'cmp/c{i:02d}.jsonl'
    if os.path.exists(f):
        shutil.move(f, f'cmp_old/c{i:02d}.jsonl')
todo.sort(key=lambda p: (p['tobe_file'], p['start']))
LIM = 9000
bs, cur, cl = [], [], 0
for p in todo:
    if cur and (cl + p['lines'] > LIM or len(cur) >= 30):
        bs.append(cur); cur, cl = [], 0
    cur.append(p); cl += p['lines']
if cur:
    bs.append(cur)
for i, b in enumerate(bs, 1):
    with open(f'cmp/n{i:02d}.jsonl', 'w', encoding='utf-8') as f:
        for p in b:
            f.write(json.dumps(p, ensure_ascii=False) + '\n')
json.dump({'valid_from_c01_c10': valid, 'new_pairs': [[p['asis_sp'], p['tobe'], p['start'], f'n{i:02d}'] for i, b in enumerate(bs, 1) for p in b]},
          open('pairs_final.json', 'w', encoding='utf-8'), ensure_ascii=False)
print('total pairs', len(pairs), 'reuse', len(valid), 'new', len(todo), 'new batches', len(bs), 'tobe lines new', sum(p['lines'] for p in todo))
