# -*- coding: utf-8 -*-
"""SCP·SSP 전 화면 UI VALIDATION 작업 인벤토리.
화면 164(SCP 125 + SSP 39, DB 취합 1b 시트 기준) → AS-IS cs(로직/Designer) · 메뉴명 · TO-BE FE 폴더 · DB 검증 행 수.
"""
import csv, os, re, glob, json
import openpyxl

ROOT = r'C:/Projects/NSCM'
W = os.path.dirname(os.path.abspath(__file__))
SCR = f'{ROOT}/Doc/asisfacts/screens'
GSCM = f'{ROOT}/GSCM'

screens = []
for dom in ('SCP', 'SSP'):
    wb = openpyxl.load_workbook(f'{ROOT}/Doc/화면분석서/{dom}_DB_VALIDATION_취합_20261022.xlsx', read_only=True)
    ws = wb['1b_UI별건수']
    for i, r in enumerate(ws.iter_rows(values_only=True)):
        if i and r[0]:
            screens.append((dom, r[0]))

tobe = {}
for line in open(f'{W}/tobe_menu_grep.txt', encoding='utf-8'):
    path, _, rest = line.strip().partition(':')
    mid = re.search(r"'(\w+)'", rest).group(1)
    tobe.setdefault(mid, []).append(os.path.dirname(path).replace('\\', '/'))

def menu_title(sid):
    f = f'{SCR}/{sid}/dbmeta_dbo_TB_FX_MenuItemInfo.csv'
    if os.path.exists(f):
        for r in csv.DictReader(open(f, encoding='utf-8-sig')):
            if (r['MenuID'] == sid or r['ProgramID'] == sid) and r['Title']:
                return r['Title'], r['PrntMenuID']
    f = f'{SCR}/{sid}/dbmeta_dbo_TB_FX_ProgramInfo.csv'
    if os.path.exists(f):
        for r in csv.DictReader(open(f, encoding='utf-8-sig')):
            if r['ProgramID'] == sid:
                return r['ProgramName'], ''
    return '', ''

rows = []
for dom, sid in screens:
    logic, designer = [], []
    f = f'{SCR}/{sid}/files.csv'
    if os.path.exists(f):
        for r in csv.DictReader(open(f, encoding='utf-8-sig')):
            if r['variant'] == 'legacy' or not r['file'].endswith('.cs'):
                continue
            fn = r['file']
            if 'AssemblyInfo' in fn or fn.endswith('Resources.Designer.cs') or fn.endswith('Settings.Designer.cs'):
                continue
            ent = (fn.replace('\\', '/'), int(r['lines'] or 0))
            (designer if fn.endswith('.Designer.cs') else logic).append(ent)
    title, parent = menu_title(sid)
    folders = tobe.get(sid, [])
    rows.append({
        'domain': dom, 'screen': sid, 'title': title, 'parent_menu': parent,
        'logic_files': ';'.join(f'{p}:{n}' for p, n in logic),
        'logic_lines': sum(n for _, n in logic),
        'designer_files': ';'.join(f'{p}:{n}' for p, n in designer),
        'tobe_folders': ';'.join(folders),
    })

with open(f'{W}/screens.csv', 'w', encoding='utf-8-sig', newline='') as fo:
    w = csv.DictWriter(fo, fieldnames=list(rows[0]))
    w.writeheader(); w.writerows(rows)

print('screens', len(rows), 'no_cs', sum(1 for r in rows if not r['logic_files']),
      'no_title', sum(1 for r in rows if not r['title']), 'no_tobe', sum(1 for r in rows if not r['tobe_folders']),
      'lines', sum(r['logic_lines'] for r in rows))
for r in rows:
    if not r['logic_files'] or not r['title']:
        print('CHECK', r['screen'], r['title'], r['logic_files'][:80])
