# -*- coding: utf-8 -*-
"""
gen_golden_cases — 화면별 골든 케이스 초안 생성 (As-is SP ↔ To-Be PKG.PROC 짝 + 파라미터)
  입력: Doc\asisfacts\screens\<ID>\endpoints.csv (SP), Doc\asisfacts\db\db_params.csv, Doc\tobefacts\db\proc_meta.csv(있으면), param_defaults.json
  출력: Doc\golden\golden_cases.csv  (screen, case_id, asis_sp, tobe_proc, params(json), match, note)
  이미 있는 파일의 사용자 수정(params/tobe_proc 수동 지정)은 case_id 기준으로 보존한다.
  python gen_golden_cases.py [DMF0003 ...]
"""
import sys as _sys
try: _sys.stdout.reconfigure(encoding='utf-8', errors='replace'); _sys.stderr.reconfigure(encoding='utf-8', errors='replace')
except Exception: pass
import sys, os, csv, json, re
HERE = os.path.dirname(os.path.abspath(__file__))
H = json.load(open(os.path.join(os.path.dirname(HERE), 'Harness', 'harness.json'), encoding='utf-8-sig'))
ASIS, TOBE = H['asisOutDir'], H['tobeOutDir']
OUT_DIR = os.path.join(os.path.dirname(H['genOutDir']), 'golden')
DEFAULTS = {k.lower(): v for k, v in json.load(open(os.path.join(HERE, 'param_defaults.json'), encoding='utf-8-sig')).items() if not k.startswith('_')}

def rcsv(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig', newline='') as f: return list(csv.DictReader(f))

params = {}
for r in rcsv(os.path.join(ASIS, 'db', 'db_params.csv')):
    if r['type'].strip() == 'P' and r['is_output'] == '0':
        params.setdefault(r['object_name'].upper(), []).append((int(r['parameter_id']), r['param_name'].lstrip('@'), r['data_type']))
proc_meta = rcsv(os.path.join(TOBE, 'db', 'proc_meta.csv'))
tobe_by_menu = {}
for r in proc_meta:
    if r.get('proc'): tobe_by_menu.setdefault(r['menu_id'].upper(), set()).add(r['proc'])
tobe_all = {r['proc'] for r in proc_meta if r.get('proc')}
# 메타 CSV 가 없을 때 폴백: To-Be 패키지 소스(06_Packages/*.sql) 의 PROCEDURE 선언에서 PKG.PROC 목록을 얻는다
PKG_DIR = H.get('tobePkgDir') or os.path.join(os.path.dirname(os.path.dirname(ASIS)), 'To-be_v2_converted', '06_Packages')
if os.path.isdir(PKG_DIR):
    for fn in os.listdir(PKG_DIR):
        if not fn.lower().endswith('.sql'): continue
        txt = open(os.path.join(PKG_DIR, fn), encoding='utf-8-sig', errors='ignore').read()
        pkg = re.search(r'PACKAGE\s+(?:BODY\s+)?(?:SCM_MGR\.)?(PKG_\w+)', txt, re.I)
        if not pkg: continue
        for m in re.finditer(r'^\s*PROCEDURE\s+(\w+)', txt, re.I | re.M):
            tobe_all.add(f'{pkg.group(1).upper()}.{m.group(1).upper()}')

def norm(s): return re.sub(r'[^A-Z0-9]', '', s.upper())
def match_tobe(sp, menu):
    """As-is SP 이름 → To-Be PKG.PROC 후보: 같은 메뉴 등록분 우선, 이름 토큰 동일(P_ 접두 제거) > 포함"""
    n = norm(sp)
    pool = list(tobe_by_menu.get(menu, [])) + list(tobe_all)
    for p in pool:
        last = p.split('.')[-1]
        if norm(re.sub(r'^P_', '', last)) == n: return p, 'exact'
    for p in pool:
        if n in norm(p): return p, 'contains'
    return '', 'none'

screens = sys.argv[1:] or sorted(d for d in os.listdir(os.path.join(ASIS, 'screens')) if os.path.isdir(os.path.join(ASIS, 'screens', d)))
os.makedirs(OUT_DIR, exist_ok=True)
out_path = os.path.join(OUT_DIR, 'golden_cases.csv')
keep = {r['case_id']: r for r in rcsv(out_path) if r.get('manual') == 'Y'}
rows = []
for sc in screens:
    sps = []
    for r in rcsv(os.path.join(ASIS, 'screens', sc, 'endpoints.csv')):
        m = re.match(r'^SP\s+(\S+)', r.get('sp_or_sql', '') or '')
        if m and r.get('status') == 'MATCH' and r.get('variant', 'current') == 'current':
            sp = m.group(1).split('.')[-1]
            if sp not in sps: sps.append(sp)
    for sp in sps:
        cid = f'{sc}:{sp}'
        if cid in keep: rows.append(keep[cid]); continue
        ps = sorted(params.get(sp.upper(), []))
        pj = {name: DEFAULTS.get(name.lower(), '') for _, name, _ in ps}
        tobe, how = match_tobe(sp, sc)
        unresolved = [k for k, v in pj.items() if v == '']
        kind = 'SAVE' if re.search(r'SAVE|INS|UPD|DEL|UPLOAD|SET_|CREATE|COPY|CONFIRM', sp, re.I) else 'GET'
        rows.append({'screen': sc, 'case_id': cid, 'kind': kind, 'asis_sp': sp, 'tobe_proc': tobe, 'match': how,
                     'params': json.dumps(pj, ensure_ascii=False), 'manual': '',
                     'note': ('' if not unresolved else '파라미터 값 없음: ' + ','.join(unresolved)) + ('' if tobe else ' / To-Be proc 미매칭(proc_meta.csv 필요 또는 수동 지정)')})
with open(out_path, 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.DictWriter(f, fieldnames=['screen', 'case_id', 'kind', 'asis_sp', 'tobe_proc', 'match', 'params', 'manual', 'note']); w.writeheader(); w.writerows(rows)
n_t = sum(1 for r in rows if r['tobe_proc']); n_p = sum(1 for r in rows if '파라미터 값 없음' not in r['note'])
print(f"골든 케이스 {len(rows)}건 → {out_path}  (To-Be 매칭 {n_t} / 파라미터 완비 {n_p} / 수동보존 {len(keep)})")
