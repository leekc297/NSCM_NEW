# -*- coding: utf-8 -*-
"""산출물에 등장하는 AS-IS 메시지 ID 전수 수집 → asis_msgids.json (메시지 대조표 원천)
원천: out/u*.jsonl 의 ui.msg_id · sp.fail_business/fail_exception.msg_id · 공통_프레임워크(COMMON) ID"""
import csv, glob, json, os, re
from collections import defaultdict

W = os.path.dirname(os.path.abspath(__file__))
MSG = {r['MessageID']: r for r in csv.DictReader(open(r'C:/Projects/NSCM/Doc/asisfacts/db/meta/dbo.TB_FX_MessageInfo.csv', encoding='utf-8-sig'))}
use = defaultdict(lambda: {'screens': set(), 'rows': 0, 'where': set()})

def add(mid, sid, where):
    if mid and re.fullmatch(r'MSG\d{5}', mid):
        u = use[mid]; u['screens'].add(sid); u['rows'] += 1; u['where'].add(where)

for f in glob.glob(f'{W}/out/u*.jsonl'):
    for line in open(f, encoding='utf-8'):
        if not line.strip():
            continue
        o = json.loads(line)
        if o.get('t') == 'ui':
            add(o.get('msg_id'), o['screen'], 'UI')
        elif o.get('t') == 'sp' and not o.get('unreachable'):
            for k in ('fail_business', 'fail_exception'):
                v = o.get(k)
                if isinstance(v, dict):
                    add(v.get('msg_id'), o['screen'], 'DB')
src = open(f'{W}/build_all.py', encoding='utf-8').read()
for mid in re.findall(r"\('[^']+', '(MSG\d{5})', \[\]", src):
    add(mid, '전 화면 공통', '공통_프레임워크')

out = []
for mid in sorted(use):
    r = MSG.get(mid)
    out.append({'asis_msg_id': mid, 'asis_ko': r['Ko'] if r else '(AS-IS 마스터 없음)', 'asis_en': r['En'] if r else '',
                'asis_use_yn': r['UseYN'] if r else '', 'screens': sorted(use[mid]['screens']), 'rows': use[mid]['rows'], 'where': sorted(use[mid]['where'])})
json.dump(out, open(f'{W}/asis_msgids.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print('distinct AS-IS msg ids', len(out), 'not in AS-IS master', sum(1 for x in out if x['asis_ko'].startswith('(AS-IS')))
