# -*- coding: utf-8 -*-
"""2026-11-25 VM 사실 추출기 의미 분석 연결 전후 대조: facts_combosrc · facts_lockrules 를 기준본(facts_before)이 있는 화면에 다시 돌린다"""
import csv, os, re, subprocess, sys, time, collections
ROOT = r'C:\Projects\NSCM'
V = os.path.join(ROOT, 'tools', 'Harness', 'verify')
BEF = os.path.join(ROOT, 'Doc', 'asisfacts_cmp', 'facts_before')
SCR = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens')
csv.field_size_limit(10 ** 9)


def rd(p):
    try:
        return list(csv.DictReader(open(p, encoding='utf-8-sig')))
    except OSError:
        return []


def raw_n(rows):
    return sum(1 for r in rows if 'RAW(' in ' '.join(str(v) for v in r.values()))


ids = sorted(os.listdir(BEF))
tot = collections.Counter()
for sid in ids:
    line = [sid]
    for tool, fn in (('facts_combosrc.py', 'combo_src.csv'), ('facts_lockrules.py', 'lock_rules.csv')):
        if not os.path.exists(os.path.join(BEF, sid, fn)):
            continue
        t0 = time.time()
        r = subprocess.run([sys.executable, os.path.join(V, tool), sid], capture_output=True, text=True, encoding='utf-8', errors='replace', cwd=ROOT, timeout=3600)
        sem = [l for l in (r.stdout or '').splitlines() if '의미 분석' in l]
        b, a = rd(os.path.join(BEF, sid, fn)), rd(os.path.join(SCR, sid, fn))
        if fn == 'combo_src.csv':
            ub, ua = sum(1 for x in b if x.get('unresolved')), sum(1 for x in a if x.get('unresolved'))
            tot['combo_rows_b'] += len(b); tot['combo_rows_a'] += len(a); tot['combo_un_b'] += ub; tot['combo_un_a'] += ua
            line.append(f'콤보 {len(b)}→{len(a)}행 미해결 {ub}→{ua}')
        else:
            ub, ua = raw_n(b), raw_n(a)
            tot['lock_rows_b'] += len(b); tot['lock_rows_a'] += len(a); tot['lock_raw_b'] += ub; tot['lock_raw_a'] += ua
            line.append(f'잠금 {len(b)}→{len(a)}행 RAW {ub}→{ua}')
        line.append(f'rc={r.returncode} {time.time() - t0:.0f}s' + (f" [{sem[0][:110]}]" if sem else ''))
        if r.returncode != 0:
            line.append((r.stderr or r.stdout)[-200:].replace('\n', ' '))
    print(time.strftime('%H:%M:%S'), ' · '.join(line), flush=True)
print('합계', dict(tot), flush=True)
