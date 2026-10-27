# -*- coding: utf-8 -*-
"""부분적용 행 수집 → tag_in/tNN.json (적용 TAG 분류 원천, 2026-10-23 사용자 지시: 부분적용 → 적용 + 적용 TAG)"""
import glob, json, os
W = os.path.dirname(os.path.abspath(__file__))
rows = []
for f in sorted(glob.glob(f'{W}/out/u*.jsonl')):
    for ln, line in enumerate(open(f, encoding='utf-8'), 1):
        if not line.strip(): continue
        o = json.loads(line)
        if o.get('t') == 'ui' and o.get('tobe_apply') == '부분적용':
            rows.append({'key': f'{os.path.basename(f)}:{ln}', 'kind': 'UI', 'screen': o['screen'], 'event': o.get('event'),
                         'check': o.get('remark') or o.get('target'), 'asis_msg': o.get('msg_id') or o.get('msg_text'),
                         'asis_loc': o.get('asis_loc'), 'tobe_basis': o.get('tobe_basis'), 'tobe_folders': None})
sp = {}
for f in sorted(glob.glob(f'{W}/out/u*.jsonl')):
    for line in open(f, encoding='utf-8'):
        if line.strip():
            o = json.loads(line)
            if o.get('t') == 'sp': sp[(o['screen'], o.get('sp'))] = o
db = json.load(open(f'{W}/db_rows.json', encoding='utf-8'))
for sid, rs in db.items():
    for i, r in enumerate(rs):
        h = sp.get((sid, r['entry_sp'])) or sp.get((sid, r['sp'])) or {}
        down = h.get('fe_downgrade') and r['tobe_apply'] == '적용'
        if r['tobe_apply'] == '부분적용' or down:
            rows.append({'key': f'DB:{sid}#{i}', 'kind': 'DB', 'screen': sid, 'event': h.get('event'), 'cls': r['cls'],
                         'sp': r['sp'], 'asis_line': r['asis_line'], 'condition': r['condition'], 'on_fail': r['on_fail'],
                         'desc': r['desc'], 'tobe_cmp': r['tobe_cmp'], 'fe_note': h.get('fe_note'),
                         'fe_downgrade_reason': h.get('fe_downgrade_reason') if down else None})
print('UI', sum(1 for r in rows if r['kind'] == 'UI'), 'DB', sum(1 for r in rows if r['kind'] == 'DB'))
N = 8
per = -(-len(rows) // N)
for g in range(N):
    json.dump(rows[g*per:(g+1)*per], open(f'{W}/tag_in/t{g+1:02d}.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    print(g+1, len(rows[g*per:(g+1)*per]))
