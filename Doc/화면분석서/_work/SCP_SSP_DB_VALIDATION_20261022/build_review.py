# -*- coding: utf-8 -*-
"""기준 통일 재판정(R1) / 미도달 재검증(R2) 대상 생성"""
import json, glob, re, os
B = os.path.dirname(os.path.abspath(__file__))
os.makedirs(os.path.join(B, 'rv'), exist_ok=True)
rows = []
for f in sorted(glob.glob(os.path.join(B, 'out', 'b*.jsonl'))):
    b = os.path.basename(f)[:-6]
    for l in open(f, encoding='utf-8'):
        if l.strip():
            r = json.loads(l)
            if not r.get('_summary'):
                r['_batch'] = b
                rows.append(r)
KEYS = ('_batch', 'unit', 'line_from', 'line_to', 'class', 'check_type', 'target', 'condition', 'on_fail', 'desc_ko', 'note', 'division', 'reach')
pat = re.compile(r'0\s*나눗셈|0\s*나누기|나눗셈 방지|분모|divide|division by zero|0 으로 나누|기본 ?(Measure|메저|컬럼)|사용자 (컬럼|Measure|메저|설정)|표시 설정|'
                 r'ISNULL\([^)]*,\s*1\)|NULLIF\([^)]*,\s*0\)|CONFIRM_DAY|FROZEN|EDIT_START|확정구간|편집 ?가능|입력 ?가능', re.I)
def txt(r):
    return ' '.join(str(r.get(k, '')) for k in ('desc_ko', 'note', 'condition', 'on_fail', 'target'))
r1 = [r for r in rows if r.get('reach') == '실행' and (
      (r.get('class') == 'B' and r.get('check_type') in ('QTY', 'COUNT')) or
      (r.get('class') in ('B', 'C', 'D') and pat.search(txt(r))))]
r2 = [r for r in rows if r.get('reach') == '미도달']
for name, rs in (('r1', r1), ('r2', r2)):
    with open(os.path.join(B, 'rv', f'{name}.jsonl'), 'w', encoding='utf-8') as f:
        for r in rs:
            f.write(json.dumps({k: r.get(k) for k in KEYS}, ensure_ascii=False) + '\n')
# r1 은 2분할
r1a, r1b = r1[:len(r1) // 2], r1[len(r1) // 2:]
for name, rs in (('r1a', r1a), ('r1b', r1b)):
    with open(os.path.join(B, 'rv', f'{name}.jsonl'), 'w', encoding='utf-8') as f:
        for r in rs:
            f.write(json.dumps({k: r.get(k) for k in KEYS}, ensure_ascii=False) + '\n')
print('r1', len(r1), 'r1a', len(r1a), 'r1b', len(r1b), 'r2', len(r2))
