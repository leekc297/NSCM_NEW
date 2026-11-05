# -*- coding: utf-8 -*-
"""E03 상태 집계 — runs/*/e2e.json · eg_combo_judge.json · static/*.json 실측만 세어 status.csv(eg_id,상태,메뉴,증거,파일)를 만든다.
   python -I Doc/verify/_parallel/E03/tools/status_build.py
   상태 규칙: 변이입증 = 기준 실행에 그 EG 판정(PASS/FAIL/NA)이 있고 + 변이 실행(폴더명 m_*)에서 그 EG 가 FAIL · 구현 = 판정 있음·변이 미완 · 그 외는 NOTE 의 사유로 불가/해당없음/미완.
"""
import collections
import csv
import glob
import json
import os
import re

E03 = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
ROOT = os.path.abspath(os.path.join(E03, '..', '..', '..', '..'))
GAP = os.path.join(ROOT, 'Doc', 'verify', '_engine_gap.csv')

# 항목별 '무엇을 어떻게 재는가' + 남은 일. 사실 판단은 집계가 하고, 여기는 설명만 적는다.
NOTE = json.load(open(os.path.join(os.path.dirname(__file__), 'status_notes.json'), encoding='utf-8'))


def rel(p):
    return os.path.relpath(p, ROOT).replace('\\', '/')


def main():
    rows = [r for r in csv.DictReader(open(GAP, encoding='utf-8-sig')) if r['engine'].startswith('E03') and r['status'] != '있음']
    base, mut = collections.defaultdict(list), collections.defaultdict(list)
    for fp in glob.glob(os.path.join(E03, 'runs', '*', 'e2e.json')) + glob.glob(os.path.join(E03, 'runs', '*', 'eg_combo_judge.json')):
        name = os.path.basename(os.path.dirname(fp))
        if fp.endswith('eg_combo_judge.json') and name == 'r7_DMF0003': continue  # 가상 스크롤로 후보 일부만 읽은 무효 측정
        if name.startswith('x') or re.match(r'r[1-4]_', name): continue  # 탐색·측정 순서 결함 수정 전 실행 제외
        try: data = json.load(open(fp, encoding='utf-8'))
        except Exception: continue
        for x in data:
            if (name, x['eg']) in {('r6_DMF0003', 'EG022'), ('r6_DMF0003', 'EG402'), ('r6_DMF0003', 'EG380'), ('r5_DMF0048', 'EG395')}: continue  # 재측정 결함 수정 전(r8)
            if name in ('r5_DMF0005', 'r5_DMF0068') and x['eg'] in ('EG109', 'EG126', 'EG140', 'EG319', 'EG373'): continue  # Insert 대기·Div 없는 화면 결함 수정 전(r8 로 재측정)
            (mut if name.startswith('m_') else base)[x['eg']].append({**x, 'run': name, 'file': rel(fp)})
    for fp in glob.glob(os.path.join(E03, 'static', '*.json')):
        d = json.load(open(fp, encoding='utf-8'))
        for x in d['rows']:
            (mut if os.path.basename(fp).startswith('m_') else base)[x['eg']].append({**x, 'screen': x.get('id', ''), 'run': 'static/' + os.path.basename(fp), 'file': rel(fp)})
    out = []
    for r in rows:
        eg = r['gap_id']; b, m = base.get(eg, []), mut.get(eg, [])
        decided = [x for x in b if x['result'] in ('PASS', 'FAIL', 'NA')]
        pf = [x for x in b if x['result'] in ('PASS', 'FAIL')]
        c = collections.Counter(x['result'] for x in b)
        menus = sorted({x.get('screen', '') for x in b if x.get('screen')})
        mf = [x for x in m if x['result'] == 'FAIL']
        n = NOTE.get(eg, {})
        if n.get('force'): state = n['force']
        elif pf and mf: state = '변이입증'
        elif decided: state = '구현'
        else: state = '미완'
        ev = f"기준 {dict(c)} · 변이 FAIL {len(mf)}건({','.join(sorted({x['run'] for x in mf}))[:90]})" if b or m else '실측 없음'
        out.append({'eg_id': eg, '상태': state, '메뉴': ' '.join(menus) or n.get('menu', ''), '증거': f"{n.get('how', '')} | {ev}" + (f" | 남은 일: {n['todo']}" if n.get('todo') else ''), '파일': ' '.join(sorted({x['file'] for x in b + m})[:4]) or n.get('file', '')})
    with open(os.path.join(E03, 'status.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['eg_id', '상태', '메뉴', '증거', '파일']); w.writeheader(); w.writerows(out)
    print(len(out), collections.Counter(x['상태'] for x in out))
    for x in out: print(x['eg_id'], x['상태'], x['메뉴'][:40], '|', x['증거'][:150])


if __name__ == '__main__':
    main()
