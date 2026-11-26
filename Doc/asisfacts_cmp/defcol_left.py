# -*- coding: utf-8 -*-
"""facts_defcols 정규화 뒤에도 남는 Def* 혼합 이름(DM·SCP·SSP) 측정 — 쓰기 없음"""
import collections, csv, os, re, sys
ROOT = r'C:\Projects\NSCM'
sys.path.insert(0, os.path.join(ROOT, 'tools', 'Harness', 'verify'))
import facts_defcols as F  # noqa: E402
csv.field_size_limit(10 ** 9)
tot = collections.Counter(); kinds = collections.Counter(); by_why = collections.Counter()
for sid in sorted(os.listdir(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens'))):
    if not sid.startswith(('DMF', 'SCP', 'SSP')):
        continue
    sdir = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid)
    ap = os.path.join(sdir, 'actions.csv')
    if not os.path.exists(ap):
        continue
    rels = sorted({(r.get('file') or '').replace(chr(92), '/') for r in csv.DictReader(open(ap, encoding='utf-8-sig')) if r.get('file')})
    texts = []
    for rel in rels:
        fp = os.path.join(ROOT, 'GSCM', rel)
        if os.path.exists(fp):
            texts.append((os.path.basename(rel), open(fp, encoding='utf-8', errors='replace').read()))
    cmap, clash = F.decl_map(texts)
    for fn in F.FILES:
        fp = os.path.join(sdir, fn)
        if not os.path.exists(fp):
            continue
        t, _ = F.normalize(open(fp, encoding='utf-8-sig').read(), cmap)
        for m in F.RX_TOKEN.finditer(t):
            if not re.fullmatch(r'[A-Z0-9_]+', m.group(2)):
                tot[sid] += 1; kinds[m.group(1) + '.' + m.group(2)] += 1
                by_why['충돌' if m.group(2) in clash else '선언 못 찾음 또는 값이 컬럼 이름 꼴 아님'] += 1
print('정규화 뒤 남는 혼합 이름', sum(tot.values()), '곳 ·', len(kinds), '종 ·', dict(by_why))
print('화면 상위', tot.most_common(8))
print('이름 상위', kinds.most_common(25))
