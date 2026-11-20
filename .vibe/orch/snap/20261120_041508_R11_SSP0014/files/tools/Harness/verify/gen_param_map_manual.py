# -*- coding: utf-8 -*-
"""수동 지정 짝(sp_pair.csv source=manual)의 인자 번역표(param_map.csv) 행 생성 (2026-11-16 · SSP0020·SCP0104 차등 검증 'AS-IS 인자 {}' 실행 오류)

  python tools/Harness/verify/gen_param_map_manual.py <ID> [<ID> …]

gen_param_map.py 는 자기 알고리즘으로 짝을 못 찾은 SP 의 인자 행을 만들지 않는다. 사람이 짝을 지정해도 인자 행이 없어 차등 검증이 AS-IS SP 를 인자 없이 불렀다.
이음 규칙(추측 금지): TO-BE fe_key(proc_params.col_nm, 앞의 ses 제거)와 AS-IS 인자(@·p_ 제거)를 영숫자 소문자로 정규화해 같을 때만 MANUAL_OK. 그 밖은 UNRESOLVED(TOBE_ONLY·ASIS_ONLY 표시).
status 가 MANUAL 로 시작하는 행은 gen_param_map.py 가 다시 돌아도 보존한다(그 도구 349행). 같은 (tobe_proc, fe_key, asis_param) 행이 이미 있으면 건드리지 않는다.
입력 Doc/tobefacts/db/proc_params.csv · Doc/asisfacts/db/db_params.csv · 출력 tools/Harness/rules/param_map.csv(덧붙임)
"""
import csv, os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
try: sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception: pass
P = lambda *a: os.path.join(ROOT, *a)
def rd(p):
    with open(p, encoding='utf-8-sig', newline='') as f: return list(csv.DictReader(f))
nz = lambda s: re.sub(r'[^a-z0-9]', '', s.lower())
def nfe(k): return nz(re.sub(r'^p_', '', re.sub(r'^ses(?=[A-Z])', '', k), flags=re.I))   # TO-BE 키가 p_version 처럼 접두를 그대로 쓰는 화면(SCP0104)도 같은 규칙
def nas(k): return nz(re.sub(r'^p_', '', k.lstrip('@'), flags=re.I))
def snake(k): return 'P_' + re.sub(r'^P_', '', re.sub(r'([a-z0-9])([A-Z])', r'\1_\2', re.sub(r'^ses(?=[A-Z])', '', k)).upper())

def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith('-')]
    if not ids: print(__doc__); return 2
    pairs = [r for r in rd(P('tools', 'Harness', 'rules', 'sp_pair.csv')) if r['menu_id'].upper() in ids and r.get('source') == 'manual' and r.get('tobe_proc')]
    tp = {}; ap = {}
    for r in rd(P('Doc', 'tobefacts', 'db', 'proc_params.csv')):
        if (r.get('col_tp_cd') or '').upper() == 'IN': tp.setdefault(r['proc'].upper(), []).append(r['col_nm'])
    for r in rd(P('Doc', 'asisfacts', 'db', 'db_params.csv')):
        if r['type'].strip() == 'P' and r['is_output'] == '0': ap.setdefault(r['object_name'].upper(), []).append(r['param_name'])
    pm = P('tools', 'Harness', 'rules', 'param_map.csv'); old = rd(pm); cols = list(old[0].keys())
    have = {(r['tobe_proc'].upper(), r['fe_key'], r['asis_param']) for r in old}; add = []; stat = {}
    for p in pairs:
        t = tp.get(p['tobe_proc'].upper()); a = ap.get(p['asis_sp'].upper())
        if t is None or a is None:
            print(f"[ERROR] {p['asis_sp']} ↔ {p['tobe_proc']}: 인자 사실 없음(TO-BE {'있음' if t is not None else '없음'} · AS-IS {'있음' if a is not None else '없음'}) — export_tobe_meta / AsisFacts db 갱신 필요"); stat[p['asis_sp']] = 'NOFACT'; continue
        used = set(); n_ok = n_un = 0
        for fk in t:
            hit = [x for x in a if nas(x) == nfe(fk)]
            if len(hit) == 1: row = dict(tobe_proc=p['tobe_proc'], tobe_param=snake(fk), fe_key=fk, asis_sp=p['asis_sp'], asis_param=hit[0], all_semantics='', list_format='', default='', status='MANUAL_OK', note='NONE(수동 짝 2026-11-16 · 이름 정규화 일치)'); used.add(hit[0]); n_ok += 1
            else: row = dict(tobe_proc=p['tobe_proc'], tobe_param=snake(fk), fe_key=fk, asis_sp=p['asis_sp'], asis_param='', all_semantics='', list_format='', default='', status='TOBE_ONLY', note=f"수동 짝 2026-11-16 · AS-IS 후보 {len(hit)}개"); n_un += 1
            if (row['tobe_proc'].upper(), row['fe_key'], row['asis_param']) not in have: add.append(row)
        for x in a:
            if x in used: continue
            row = dict(tobe_proc=p['tobe_proc'], tobe_param='', fe_key='', asis_sp=p['asis_sp'], asis_param=x, all_semantics='', list_format='', default='', status='ASIS_ONLY', note='수동 짝 2026-11-16 · TO-BE 인자 없음'); n_un += 1
            if (row['tobe_proc'].upper(), row['fe_key'], row['asis_param']) not in have: add.append(row)
        stat[p['asis_sp']] = f'OK {n_ok} · 미해결 {n_un}'
    with open(pm + '.tmp', 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols, extrasaction='ignore'); w.writeheader(); w.writerows(old + add)
    os.replace(pm + '.tmp', pm)
    for k, v in stat.items(): print(f'  {k}: {v}')
    print(f'[gen_param_map_manual] 수동 짝 {len(pairs)} · 추가 행 {len(add)} → {pm}')
    return 0

if __name__ == '__main__':
    sys.exit(main())
