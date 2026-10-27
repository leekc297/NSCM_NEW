# -*- coding: utf-8 -*-
"""DB 검증 행 정리 — SCP/SSP_DB_VALIDATION_취합_20261022.xlsx 의 2_UI별목록(실행 행) + 4_ASIS_TOBE비교(판정) 결합.
출력: db_rows.json (화면별 DB 검증 행, TO-BE 판정 포함) · db_items.json (항목ID → 대표 정보)
"""
import json, os
from collections import defaultdict
import openpyxl

ROOT = r'C:/Projects/NSCM/Doc/화면분석서'
W = os.path.dirname(os.path.abspath(__file__))

rows = defaultdict(list)
items = {}
cmp = defaultdict(list)   # (ui, sp, item) -> [(verdict, tobe, loc, diff)]
supp = defaultdict(list)  # AS-IS 추출누락 보충 행
for dom in ('SCP', 'SSP'):
    wb = openpyxl.load_workbook(f'{ROOT}/{dom}_DB_VALIDATION_취합_20261022.xlsx', read_only=True)
    for i, r in enumerate(wb['3_항목별취합'].iter_rows(values_only=True)):
        if i and r[0] and r[0] not in items:
            items[r[0]] = {'check_type': r[1], 'target': r[2], 'cls': r[3], 'desc': r[4]}
    for i, r in enumerate(wb['4_ASIS_TOBE비교'].iter_rows(values_only=True)):
        if not i or not r[0]:
            continue
        ui, sp, item, cls, ct, desc, reach, tobe, verdict, loc, ev, diff = r[:12]
        if ui[:3] != dom:
            continue
        cmp[(ui, sp, item or '')].append({'verdict': verdict, 'tobe': tobe, 'loc': loc, 'diff': diff})
        if verdict and 'AS-IS 추출누락' in verdict:
            supp[ui].append({'sp': sp, 'item': item, 'cls': cls, 'check_type': ct, 'desc': desc, 'verdict': verdict,
                             'tobe': tobe, 'tobe_loc': loc, 'diff': diff})
    for i, r in enumerate(wb['2_UI별목록'].iter_rows(values_only=True)):
        if not i or not r[0] or not r[6]:
            continue
        ui = r[0]
        if ui[:3] != dom:
            continue
        rec = dict(zip(['ui', 'entry_sp', 'depth', 'sp', 'cs_call', 'item', 'cls', 'check_type', 'target', 'asis_line',
                        'condition', 'on_fail', 'message', 'division', 'reach', 'desc', 'note'], r[:17]))
        if rec['reach'] != '실행':
            continue
        rows[ui].append(rec)

VMAP = [('일치', '적용'), ('차이', '부분적용'), ('누락', '미적용'), ('TO-BE 미이관', '미적용'), ('TO-BE 미개발', 'TO-BE 미개발')]
def apply_of(verdicts):
    vals = []
    for v in verdicts:
        for k, a in VMAP:
            if v['verdict'] and v['verdict'].startswith(k):
                vals.append(a); break
    if not vals:
        return 'TO-BE 미개발', ''
    order = ['미적용', 'TO-BE 미개발', '부분적용', '적용']
    worst = sorted(vals, key=order.index)[0]
    return worst, ''

out = {}
for ui, rs in rows.items():
    lst = []
    for rec in rs:
        vs = cmp.get((ui, rec['sp'], rec['item'] or ''), [])
        a, _ = apply_of(vs)
        rec['tobe_apply'] = a
        rec['tobe_cmp'] = vs
        lst.append(rec)
    for s in supp.get(ui, []):
        vs = [{'verdict': s['verdict'], 'tobe': s['tobe'], 'loc': s['tobe_loc'], 'diff': s['diff']}]
        lst.append({'ui': ui, 'entry_sp': s['sp'], 'depth': None, 'sp': s['sp'], 'cs_call': '', 'item': s['item'], 'cls': s['cls'],
                    'check_type': s['check_type'], 'target': '', 'asis_line': '', 'condition': '', 'on_fail': '', 'message': '',
                    'division': '', 'reach': '실행', 'desc': s['desc'], 'note': '[AS-IS 추출누락 보충 — DB 비교 단계에서 AS-IS 원문 확인]',
                    'tobe_apply': apply_of(vs)[0], 'tobe_cmp': vs})
    out[ui] = lst

json.dump(out, open(f'{W}/db_rows.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1, default=str)
json.dump(items, open(f'{W}/db_items.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1, default=str)
from collections import Counter
c = Counter((r['cls'], r['tobe_apply']) for v in out.values() for r in v)
print('screens with db rows', len(out), 'rows', sum(len(v) for v in out.values()))
for k in sorted(c): print(k, c[k])
