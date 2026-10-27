# -*- coding: utf-8 -*-
"""AS-IS SP ↔ TO-BE 대상 쌍 + AS-IS 검증 행(idx 부여) → 비교 배치 (cmp/c##.jsonl)
대상 선택: (1) 화면번호와 같은 PKG 사본 (2) API_M 배선된 대상 (3) 그 외 strong 전부 / weak 는 검증요청 플래그
"""
import os, re, csv, json, glob, collections
B = os.path.dirname(os.path.abspath(__file__))
def rd(p):
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))

rows = []
for f in sorted(glob.glob(os.path.join(B, 'out', 'b*.jsonl'))):
    if re.search(r'\.p\d', f):
        continue
    for l in open(f, encoding='utf-8'):
        if l.strip():
            rows.append(json.loads(l))
asis = collections.defaultdict(list)
for r in rows:
    if not r.get('_summary'):
        asis[r['unit']].append(r)
idx = 0
for u, rs in asis.items():
    for r in rs:
        idx += 1
        r['idx'] = idx
json.dump({u: rs for u, rs in asis.items()}, open(os.path.join(B, 'asis_rows_indexed.json'), 'w', encoding='utf-8'), ensure_ascii=False)

blocks = {}
for b in rd(os.path.join(B, 'tobe', 'proc_blocks.csv')):
    blocks[(f"{b['pkg']}.{b['member']}" if b['pkg'] else b['member']).upper()] = b
chain = rd(os.path.join(B, 'ui_sp_chain.csv'))
scr = collections.defaultdict(set)
for c in chain:
    scr[c['unit']].add(c['screen'])

pairs = []
for m in rd(os.path.join(B, 'map.csv')):
    a = m['asis_sp']
    ts = [t for t in m['tobe_targets'].split(' | ') if t]
    if not ts:
        continue
    wired = [t for t in m.get('wired', '').split(' | ') if t]
    pick = set()
    for s in scr.get(a, []):
        for t in ts:
            if t.upper().startswith(f'PKG_{s}.'):
                pick.add(t)
    if not pick:
        pick = set(wired) or set(ts)
    for t in sorted(pick):
        b = blocks.get(t.upper())
        if not b:
            continue
        L = int(b['end']) - int(b['start']) + 1
        pairs.append(dict(asis_sp=a, tobe=t, tobe_file=b['file'], start=int(b['start']), end=int(b['end']), lines=L,
                          confidence=m['confidence'], evidence=m['evidence'], wired='Y' if t in wired else 'N',
                          screens=' '.join(sorted(scr.get(a, []))), asis_rows=asis.get(a, [])))
os.makedirs(os.path.join(B, 'cmp'), exist_ok=True)
pairs.sort(key=lambda p: (p['tobe_file'], p['start']))
LIM = 9000
batches, cur, cl = [], [], 0
for p in pairs:
    if cur and (cl + p['lines'] > LIM or len(cur) >= 30):
        batches.append(cur); cur, cl = [], 0
    cur.append(p); cl += p['lines']
if cur:
    batches.append(cur)
for i, bt in enumerate(batches, 1):
    with open(os.path.join(B, 'cmp', f'c{i:02d}.jsonl'), 'w', encoding='utf-8') as f:
        for p in bt:
            f.write(json.dumps(p, ensure_ascii=False) + '\n')
print('asis rows', idx, 'pairs', len(pairs), 'weak pairs', sum(1 for p in pairs if p['confidence'] == 'weak'),
      'tobe lines', sum(p['lines'] for p in pairs), 'batches', len(batches))
