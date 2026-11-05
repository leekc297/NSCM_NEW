"""status.csv 생성 — runs/*/popup_results.json · popup_source.csv 실측만 집계(추정 금지)
  상태: 변이입증(실측+변이 FAIL) · 구현(실측 O·변이 없음) · 미완(코드만 또는 일부) · 해당없음 · 불가
"""
import csv, glob, json, os, re, subprocess, sys
from collections import defaultdict
sys.stdout.reconfigure(encoding='utf-8')
E02 = 'Doc/verify/_parallel/E02'
ids = [l.split()[0] for l in subprocess.run(['python', '-I', 'tools/Harness/verify/engine_gap_cluster.py', 'E02'], capture_output=True, text=True, encoding='utf-8').stdout.splitlines() if l.startswith('EG')]
gap = {r['gap_id']: r for r in csv.DictReader(open('Doc/verify/_engine_gap.csv', encoding='utf-8-sig'))}
eg_menus = json.load(open(f'{E02}/_eg_menus.json', encoding='utf-8'))
base = defaultdict(lambda: defaultdict(lambda: defaultdict(int)))  # eg -> menu -> result -> n
base_ev = defaultdict(list)
mut = defaultdict(list)
for d in sorted(glob.glob(f'{E02}/runs/*/')):
    p = os.path.join(d, 'popup_results.json')
    if os.path.exists(p):
        rn = os.path.basename(d.rstrip('/\\'))
        for r in json.load(open(p, encoding='utf-8')):
            # 판정 코드 교정 전 실행의 기준 행은 쓰지 않는다 — 실행별로 유효 check 만(교정 전 허위 FAIL 혼입 방지)
            if not r.get('mut'):
                ok = (rn.startswith('DMF0005_e_') or
                      (rn.startswith('DMF0005_b_') and re.match(r'PICK|SELECT_MODE|AFTER_SORT|TEXT_|PERIOD_BACK', r['check'])) or
                      (rn.startswith('DMF0005_a_') and re.match(r'CORNERS|POP_SAVE', r['check'])) or
                      (rn.startswith('DMF0005_N1_') and r['check'].startswith('GRID_')))
                if not ok:
                    continue
                if rn.startswith('DMF0005_e_') and r['check'].startswith('GRID_FILTER'):
                    continue
            for e in r.get('egs', []):
                if r.get('mut'):
                    if r['result'] == 'FAIL':
                        mut[e].append((r['screen'], r['mut'], r['check'], r['actual'][:80], os.path.basename(d.rstrip('/\\'))))
                else:
                    base[e][r['screen']][r['result']] += 1
                    if r['result'] in ('PASS', 'FAIL'):
                        base_ev[e].append((r['screen'], r['check'], r['result'], os.path.basename(d.rstrip('/\\')), r['at']))
    p = os.path.join(d, 'popup_source.csv')
    if os.path.exists(p):
        for r in csv.DictReader(open(p, encoding='utf-8-sig')):
            for e in r['egs'].split(';'):
                base[e][r['menu']][r['result']] += 1
                if r['result'] in ('PASS', 'FAIL'):
                    base_ev[e].append((r['menu'], 'SRC_' + r['axis'], r['result'], os.path.basename(d.rstrip('/\\')), ''))

OVERRIDE = {}
ov = f'{E02}/_status_override.csv'
if os.path.exists(ov):
    for r in csv.DictReader(open(ov, encoding='utf-8-sig')):
        OVERRIDE[r['eg_id']] = r

rows = []
for e in ids:
    ms = eg_menus.get(e, [])
    measured = [m for m in base[e] if any(base[e][m][x] for x in ('PASS', 'FAIL', '판정필요'))]
    onDoc = [m for m in measured if m in ms]
    v = mut.get(e, [])
    solid = [m for m in base[e] if base[e][m]['PASS'] or base[e][m]['FAIL']]
    docOk = 'COMMON' in ms or any(m in ms for m in solid)
    if solid and v and docOk:
        st = '변이입증'
    elif solid:
        st = '구현'
    else:
        st = '미완'
    cnt = {m: dict(base[e][m]) for m in base[e]}
    ev = f"실측 {cnt}" + (f" · 변이 {sorted(set((x[1], x[2]) for x in v))[:4]}" if v else '')
    left = []
    if st == '구현' and not v:
        left.append('변이 입증 미완')
    if ms and not onDoc and 'COMMON' not in ms:
        left.append(f'문서 메뉴 {ms} 미측정(측정 메뉴 {measured[:4]})')
    if st == '미완':
        left.append(f"실측 결과 없음 — 남은 일: {gap[e]['how_to_build'][:80]}")
    fls = 'tools/E2E/lib/popupprobe.ts; Doc/e2e/specs/eg_popup.spec.ts; tools/Harness/verify/facts_popup.py'
    row = {'eg_id': e, '상태': st, '메뉴': ';'.join(sorted(base[e])) or ';'.join(ms), '증거': (ev + (' · 남은 일: ' + ' / '.join(left) if left else ''))[:700], '파일': fls}
    if e in OVERRIDE:
        o = OVERRIDE[e]
        if o.get('상태'):
            row['상태'] = o['상태']
        row['증거'] = (o.get('증거', '') + ' | ' + row['증거'])[:900]
        if o.get('파일'):
            row['파일'] = o['파일']
    rows.append(row)
with open(f'{E02}/status.csv', 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.DictWriter(f, ['eg_id', '상태', '메뉴', '증거', '파일'])
    w.writeheader()
    w.writerows(rows)
c = defaultdict(int)
for r in rows:
    c[r['상태']] += 1
print(len(rows), dict(c))
