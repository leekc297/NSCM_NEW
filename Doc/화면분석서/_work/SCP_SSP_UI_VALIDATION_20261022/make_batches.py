# -*- coding: utf-8 -*-
"""화면 배치 분할 + 배치 입력 파일(batch_in/uNN.json) 생성. 기준: C# 로직 줄수 합 ≤ 8,000 (큰 화면은 단독)."""
import csv, json, os
from collections import defaultdict

W = os.path.dirname(os.path.abspath(__file__))
ROOT = r'C:/Projects/NSCM'
LIMIT = 8000

scr = list(csv.DictReader(open(f'{W}/screens.csv', encoding='utf-8-sig')))
db = json.load(open(f'{W}/db_rows.json', encoding='utf-8'))
direct = defaultdict(list)
for r in csv.DictReader(open(f'{ROOT}/Doc/화면분석서/_work/SCP_SSP_DB_VALIDATION_20261022/ui_sp_direct.csv', encoding='utf-8-sig')):
    direct[r['screen']].append({k: r[k] for k in ('unit_kind', 'unit', 'member', 'line', 'file', 'pattern', 'status')})

batches, cur, n = [], [], 0
for dom in ('SCP', 'SSP'):
    for s in [x for x in scr if x['domain'] == dom]:
        ln = int(s['logic_lines'])
        if cur and (n + ln > LIMIT or cur[0]['domain'] != dom):
            batches.append(cur); cur, n = [], 0
        cur.append(s); n += ln
    if cur:
        batches.append(cur); cur, n = [], 0

os.makedirs(f'{W}/batch_in', exist_ok=True)
os.makedirs(f'{W}/out', exist_ok=True)
index = []
for i, b in enumerate(batches, 1):
    bid = f'u{i:02d}'
    payload = []
    for s in b:
        sid = s['screen']
        rs = db.get(sid, [])
        sps = sorted({r['entry_sp'] for r in rs if r['entry_sp']} | {d['unit'] for d in direct[sid]})
        payload.append({
            'screen': sid, 'title': s['title'], 'domain': s['domain'],
            'logic_files': s['logic_files'].split(';') if s['logic_files'] else [],
            'designer_files': s['designer_files'].split(';') if s['designer_files'] else [],
            'tobe_folders': s['tobe_folders'].split(';') if s['tobe_folders'] else [],
            'direct_calls': direct[sid],
            'entry_sps': sps,
            'db_validation_brief': [
                {'entry_sp': r['entry_sp'], 'sp': r['sp'], 'depth': r['depth'], 'cls': r['cls'], 'check_type': r['check_type'],
                 'desc': r['desc'], 'message': r['message'], 'on_fail': (r['on_fail'] or '')[:160]}
                for r in rs if r['cls'] in ('A 차단형', 'D 검증리포트형')],
        })
    json.dump(payload, open(f'{W}/batch_in/{bid}.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1, default=str)
    index.append({'batch': bid, 'screens': ' '.join(s['screen'] for s in b), 'logic_lines': sum(int(s['logic_lines']) for s in b),
                  'tobe_screens': sum(1 for s in b if s['tobe_folders'])})
with open(f'{W}/batches.csv', 'w', encoding='utf-8-sig', newline='') as fo:
    w = csv.DictWriter(fo, fieldnames=list(index[0])); w.writeheader(); w.writerows(index)
print('batches', len(batches))
for x in index: print(x)
