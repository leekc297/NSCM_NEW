# -*- coding: utf-8 -*-
"""Designer 기계 대조: 화면별 Designer(.Designer.cs / .designer.cs)에서 라벨이 '*' 로 끝나는 LayoutControlItem 을 추출.
(DataUtil.checkRequiredOfSearch 는 LayoutControlItem.Text 가 '*' 로 끝나는 항목을 필수로 본다 — FRAMEWORK_REF §3-1)
출력: designer_required.csv (screen, file, item_var, text, customization_text, control)"""
import csv, os, re

W = os.path.dirname(os.path.abspath(__file__))
G = r'C:/Projects/NSCM/GSCM/'
RE_TEXT = re.compile(r'this\.(\w+)\.Text\s*=\s*"([^"]*\*)"\s*;')
RE_CUST = re.compile(r'this\.(\w+)\.CustomizationFormText\s*=\s*"([^"]*)"\s*;')
RE_CTRL = re.compile(r'this\.(\w+)\.Control\s*=\s*this\.(\w+)\s*;')

out = []
for s in csv.DictReader(open(f'{W}/screens.csv', encoding='utf-8-sig')):
    files = [e.rsplit(':', 1)[0] for e in (s['designer_files'] + ';' + s['logic_files']).split(';') if e]
    files = [f for f in dict.fromkeys(files) if f.lower().endswith('.designer.cs')]
    for f in files:
        fp = G + f
        if not os.path.exists(fp):
            continue
        src = open(fp, encoding='utf-8-sig', errors='replace').read()
        cust = dict(RE_CUST.findall(src)); ctrl = dict(RE_CTRL.findall(src))
        for var, text in RE_TEXT.findall(src):
            if not var.lower().startswith(('layoutcontrolitem', 'lci', 'lbl', 'item')) and var not in ctrl:
                continue
            out.append({'screen': s['screen'], 'file': os.path.basename(f), 'item_var': var, 'text': text,
                        'customization_text': cust.get(var, ''), 'control': ctrl.get(var, '')})
with open(f'{W}/designer_required.csv', 'w', encoding='utf-8-sig', newline='') as fo:
    w = csv.DictWriter(fo, fieldnames=['screen', 'file', 'item_var', 'text', 'customization_text', 'control']); w.writeheader(); w.writerows(out)
from collections import Counter
c = Counter(r['screen'] for r in out)
print('labels', len(out), 'screens', len(c))
