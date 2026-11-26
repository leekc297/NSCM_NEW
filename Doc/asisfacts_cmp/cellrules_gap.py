# -*- coding: utf-8 -*-
"""facts_cellrules 가 쓰는 Def* 컬럼 상수 중 const_map(같은 파일 구조체)으로 못 찾는 참조 수 — 의미 분석 연결 여부 판단용(쓰기 없음)"""
import csv, os, re, sys, collections
ROOT = r'C:\Projects\NSCM'
sys.path.insert(0, os.path.join(ROOT, 'tools', 'Harness', 'verify'))
from facts_cellclear import const_map  # noqa: E402
csv.field_size_limit(10 ** 9)
API = re.compile(r'(?:SetReNumerCellType|AddNumColumn\w*|AddDate\w*Column|SetCellType\w*|AddTextColumn\w*|AddComboColumn\w*)\s*\(')
TOK = re.compile(r'GetColumnIndex\(\s*(Def\w*)\.(\w+)\s*\)')
miss = collections.Counter(); hit = 0; ex = []
for sid in sorted(os.listdir(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens'))):
    if not sid.startswith(('DMF', 'SCP', 'SSP')):
        continue
    fp = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid, 'files.csv')
    if not os.path.exists(fp):
        continue
    for f in csv.DictReader(open(fp, encoding='utf-8-sig')):
        rel = f['file']
        if f.get('variant') == 'legacy' or not rel.endswith('.cs') or rel.endswith('.Designer.cs'):
            continue
        src = os.path.join(ROOT, 'GSCM', rel)
        if not os.path.exists(src):
            continue
        cm = const_map(rel.replace(chr(92), '/'))
        for i, ln in enumerate(open(src, encoding='utf-8', errors='replace').read().split('\n'), 1):
            if ln.strip().startswith('//') or not API.search(ln):
                continue
            for m in TOK.finditer(ln):
                if m.group(2) in cm or re.fullmatch(r'[A-Z0-9_]+', m.group(2)):
                    hit += 1
                else:
                    miss[(sid, m.group(1) + '.' + m.group(2))] += 1
                    if len(ex) < 8:
                        ex.append((rel, i, m.group(0)))
print('셀 규칙 호출의 Def* 참조: const_map 으로 풀림(또는 이름=값)', hit, '· 못 찾음', sum(miss.values()), '곳', len(miss), '종')
print(miss.most_common(12))
for e in ex:
    print('  ', e)
