# -*- coding: utf-8 -*-
r"""
xlsx_to_csv — 개발대상 목록(xlsx) → 대사표 입력 CSV
  입력: Doc\Next SCM 개발대상_자이오넥스_분석_20260511(조재훈).xlsx (시트 UI_MENU_NEW (포함) / (진척현황) / UI_Detail), Doc\UP_SP_DEV_STATUS_20260615.xlsx
  출력: Doc\recon\_input\dev_targets.csv, dev_target_sps.csv, dev_target_sheets.csv, dev_progress.csv, sp_dev_status.csv
        tools\Harness\rules\map_screen.csv (asis_id,tobe_id,title,stage,module) — As-is ID ≠ To-Be MENU_ID 인 화면 짝(gap/gen/recon 공용)
  python xlsx_to_csv.py [--doc C:\Projects\NSCM\Doc]
"""
import sys as _sys
try: _sys.stdout.reconfigure(encoding='utf-8', errors='replace'); _sys.stderr.reconfigure(encoding='utf-8', errors='replace')
except Exception: pass
import sys, os, csv, glob, re
import openpyxl
HERE = os.path.dirname(os.path.abspath(__file__))
doc = sys.argv[sys.argv.index('--doc') + 1] if '--doc' in sys.argv else r'C:\Projects\NSCM\Doc'
rules = sys.argv[sys.argv.index('--rules') + 1] if '--rules' in sys.argv else os.path.join(os.path.dirname(HERE), 'Harness', 'rules')
out = os.path.join(doc, 'recon', '_input'); os.makedirs(out, exist_ok=True)

def wcsv(name, header, rows):
    with open(os.path.join(out, name), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(header); w.writerows(rows)
    print(f'  {name} {len(rows)}행')

def s(v): return '' if v is None else str(v).strip()
ID_RE = re.compile(r'^[A-Z]{2,5}\d{4}(_\d{2})?$')
def idv(v): return v if ID_RE.match(v) else ''
def ffill(rows, cols):
    last = {c: '' for c in cols}
    for r in rows:
        for c in cols:
            if r[c]: last[c] = r[c]
            else: r[c] = last[c]
    return rows

tgt = sorted(glob.glob(os.path.join(doc, '*개발대상*.xlsx')))
if not tgt: sys.exit('개발대상 xlsx 없음')
print('개발대상:', os.path.basename(tgt[-1]))
wb = openpyxl.load_workbook(tgt[-1], read_only=True, data_only=True)

# 1) UI_MENU_NEW (포함) : 화면 + SP
ws = wb['UI_MENU_NEW (포함)']
rows = [list(map(s, r)) for r in ws.iter_rows(values_only=True)][2:]
recs = [dict(stage=r[1], module=r[2], m1=r[3], m2=r[4], m3=r[5], asis=r[6], tobe=r[7], done=r[8], prio=r[9], cns=r[10], sp_full=r[11], schema=r[12], sp=r[13], ui_file=r[14]) for r in rows if any(r)]
ffill(recs, ['stage', 'module', 'm1', 'm2', 'm3', 'asis'])
screens, seen = [], set()
for r in recs:
    if r['asis'] and r['asis'] not in seen:
        seen.add(r['asis']); screens.append([r['stage'], r['module'], r['m1'], r['m2'], r['m3'], r['asis'], r['tobe'], r['done'], r['prio'], r['cns']])
wcsv('dev_targets.csv', ['stage', 'module', 'menu1', 'menu2', 'menu3', 'asis_id', 'tobe_id', 'done', 'priority', 'cns_review'], screens)
sps = [[r['asis'], r['tobe'], r['schema'], r['sp'], r['ui_file']] for r in recs if r['sp']]
wcsv('dev_target_sps.csv', ['asis_id', 'tobe_id', 'schema', 'sp', 'ui_file'], sps)

# 2) 진척현황
if 'UI_MENU_NEW (진척현황)' in wb.sheetnames:
    ws = wb['UI_MENU_NEW (진척현황)']
    rows = [list(map(s, r)) for r in ws.iter_rows(values_only=True)][2:]
    pr = [dict(stage=r[1], module=r[2], m3=r[5], asis=r[6], tobe=r[7], init=r[8], owner=r[9], due=r[10], fin=r[11], done=r[12], prio=r[13], cmt=r[14]) for r in rows if any(r)]
    ffill(pr, ['stage', 'module'])
    wcsv('dev_progress.csv', ['stage', 'module', 'menu3', 'asis_id', 'tobe_id', 'init', 'owner', 'due', 'finished', 'done', 'priority', 'comment'],
         [[p['stage'], p['module'], p['m3'], p['asis'], p['tobe'], p['init'][:10], p['owner'], p['due'][:10], p['fin'][:10], p['done'], p['prio'], p['cmt']] for p in pr if p['asis']])
    # To-Be ID 보강(포함 시트에 비어 있으면 진척현황 값)
    tb = {p['asis']: idv(p['tobe']) for p in pr if p['asis'] and idv(p['tobe'])}
    for sc in screens:
        if not sc[6] and sc[5] in tb: sc[6] = tb[sc[5]]
    wcsv('dev_targets.csv', ['stage', 'module', 'menu1', 'menu2', 'menu3', 'asis_id', 'tobe_id', 'done', 'priority', 'cns_review'], screens)

# 3) UI_Detail : 시트
if 'UI_Detail' in wb.sheetnames:
    ws = wb['UI_Detail']
    rows = [list(map(s, r)) for r in ws.iter_rows(values_only=True)][2:]
    m3_to_id = {sc[4]: sc[5] for sc in screens if sc[4]}
    det = [[m3_to_id.get(r[5], ''), r[1], r[2], r[5], r[6], r[7], r[8], r[9], r[10], r[12]] for r in rows if r[6]]
    wcsv('dev_target_sheets.csv', ['asis_id', 'stage', 'module', 'menu3', 'sheet', 'md_level', 'kind', 'done', 'difficulty', 'comment'], det)

# 4) SP 개발 현황
st = sorted(glob.glob(os.path.join(doc, 'UP_SP_DEV_STATUS*.xlsx')))
if st:
    wb2 = openpyxl.load_workbook(st[-1], read_only=True, data_only=True); ws = wb2.worksheets[0]
    rows = [list(map(s, r)) for r in ws.iter_rows(values_only=True)][1:]
    wcsv('sp_dev_status.csv', ['ui_id', 'ui_name', 'sp', 'finished', 'done', 'ref_table_cnt', 'ref_tables'], [[r[1], r[2], r[3], r[4][:10], r[5], r[6], r[7]] for r in rows if r[3]])

# 5) map_screen.csv (As-is ID ≠ To-Be ID 인 것만 + 동일한 것도 명시)
os.makedirs(rules, exist_ok=True)
mp = os.path.join(rules, 'map_screen.csv')
manual = {}
if os.path.exists(mp):
    with open(mp, encoding='utf-8-sig', newline='') as f:
        for r in csv.DictReader(f):
            if r.get('source') == 'manual': manual[r['asis_id']] = r
with open(mp, 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.writer(f); w.writerow(['asis_id', 'tobe_id', 'title', 'stage', 'module', 'source'])
    for sc in screens:
        if sc[5] in manual: r = manual[sc[5]]; w.writerow([r['asis_id'], r['tobe_id'], r['title'], r['stage'], r['module'], 'manual']); continue
        w.writerow([sc[5], idv(sc[6]) or sc[5], sc[4], sc[0], sc[1], 'xlsx'])
    for k, r in manual.items():
        if k not in seen: w.writerow([r['asis_id'], r['tobe_id'], r['title'], r['stage'], r['module'], 'manual'])
print('  map_screen.csv →', mp)
