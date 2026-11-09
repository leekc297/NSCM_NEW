# -*- coding: utf-8 -*-
"""상위 셀 변경 → 하위 셀 초기화 AS-IS 사실(2026-11-01 엔진 갭 EG085)

입력: Doc/asisfacts/screens/<ID>/actions.csv · files.csv · AS-IS 소스(GSCM → GSCM_20260512)
출력: Doc/asisfacts/screens/<ID>/cell_clear.csv
  grid(siMain 등) · src·tgt(AS-IS 상수) · src_col·tgt_col(상수 값 = 컬럼) · cond(조건부면 원문) · refilled(같은 분기에서 다시 채움) · ref

원천 = guard 체인에서 가장 안쪽의 e.Column == GetColumnIndex(상수) 분기('else of' 제외) · 대상 = SetValue/SetText(e.Row, GetColumnIndex(상수), 빈 값)
자기 칸 비우기(입력 검증)·원천 분기 없는 문장은 제외. 컬럼 존재 확인 분기(GetColumnIndex > 0 등)는 조건으로 보지 않는다.
"""
import csv, os, re, sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
csv.field_size_limit(10 ** 8)
HANDLER = re.compile(r'ComboSel|Changed?$|EditChange')
CLEAR = re.compile(r'(\w+)\.Set(?:Value|Text)\(\s*e\.Row\s*,\s*\w+\.GetColumnIndex\(\s*(?:\w+\.)*(\w+)\s*\)\s*,\s*(?:""|string\.Empty|String\.Empty|null)\s*\)')
SETANY = re.compile(r'\.Set(?:Value|Text)\(\s*e\.Row\s*,\s*\w+\.GetColumnIndex\(\s*(?:\w+\.)*(\w+)\s*\)\s*,\s*([^)]+)\)')
SRC = re.compile(r'e\.Column\s*==\s*\w+\.GetColumnIndex\(\s*(?:\w+\.)*(\w+)\s*\)')
EXIST = re.compile(r'^if \(\w+\.GetColumnIndex\([^)]*\)\s*(?:>\s*0|>=\s*0|!=\s*-1|>\s*-1)\)$')
EMPTY = re.compile(r'^\s*(?:""|string\.Empty|String\.Empty|null)\s*$')
COLS = ['grid', 'src', 'tgt', 'src_col', 'tgt_col', 'cond', 'refilled', 'ref']


def rd(p):
    return list(csv.DictReader(open(p, encoding='utf-8-sig', newline=''))) if os.path.exists(p) else []


def const_map(file_rel):
    """파일의 DefColumns 계열 구조체 상수 → 문자열 값. 같은 이름의 라벨 구조체(DefColumnNames 등)가 뒤에 오므로 구조체별로 보고 Def*Columns 만 쓴다"""
    q = next((x for x in (os.path.join(ROOT, 'GSCM', file_rel), os.path.join(ROOT, 'GSCM_20260512', file_rel)) if os.path.exists(x)), '')
    if not q:
        return {}
    t = open(q, encoding='utf-8-sig', errors='replace').read()
    out = {}
    for m in re.finditer(r'\b(?:struct|class)\s+(Def\w*)\s*\{', t):
        if not re.fullmatch(r'Def(?:Main|Sub)?Columns?\w*|Def[A-Z]\w*Col\w*', m.group(1)) or re.search(r'Name|Header|Label', m.group(1)):
            continue
        depth, i = 1, m.end()
        while i < len(t) and depth:
            depth += {'{': 1, '}': -1}.get(t[i], 0)
            i += 1
        for k, v in re.findall(r'\bstring\s+(\w+)\s*=\s*"([^"]*)"', t[m.end():i]):
            out.setdefault(k, v)
    return out


def main(sid):
    d = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid)
    files = {f['file'] for f in rd(os.path.join(d, 'files.csv')) if f.get('variant') in ('current', 'shared')}
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from asis_live import dead_methods
    dead = dead_methods(sid)
    acts = [a for a in rd(os.path.join(d, 'actions.csv')) if a['file'] in files and (a['class'], a['method']) not in dead]
    cmap = {}
    out, seen = [], set()
    for a in acts:
        if a['kind'] != 'GRID_SET' or not HANDLER.search(a['method']):
            continue
        k = CLEAR.search(a['raw'])
        if not k:
            continue
        segs = [s.strip() for s in a['guard'].split('▸')]
        idx = [i for i, s in enumerate(segs) if SRC.search(s) and not s.startswith('else of')]
        if not idx:
            continue
        src, tgt = SRC.findall(segs[idx[-1]])[-1], k.group(2)
        if src == tgt:
            continue
        rest = [s for s in segs[idx[-1] + 1:] if not EXIST.match(s)]
        if a['file'] not in cmap:
            cmap[a['file']] = const_map(a['file'].replace('\\', '/'))
        cm = cmap[a['file']]
        # 같은 분기(같은 원천)에서 대상을 다시 채우면 초기화 뒤 교체도 AS-IS 동작
        refilled = any(b['kind'] == 'GRID_SET' and b['method'] == a['method'] and SRC.search(b['guard']) and src in SRC.findall(b['guard']) and any(m[0] == tgt and not EMPTY.match(m[1]) for m in SETANY.findall(b['raw'])) for b in acts)
        key = (k.group(1), src, tgt, ' ▸ '.join(rest))
        if key in seen:
            continue
        seen.add(key)
        out.append({'grid': k.group(1), 'src': src, 'tgt': tgt, 'src_col': cm.get(src, ''), 'tgt_col': cm.get(tgt, ''), 'cond': ' ▸ '.join(rest)[:500], 'refilled': 'Y' if refilled else '', 'ref': f"{os.path.basename(a['file'])}:{a['line']} {a['class']}.{a['method']}"})
    p = os.path.join(d, 'cell_clear.csv')
    with open(p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(out)
    print(f"{sid}: 셀 초기화 {len(out)}건(무조건 {sum(1 for x in out if not x['cond'])}·조건부 {sum(1 for x in out if x['cond'])}·컬럼 미해석 {sum(1 for x in out if not x['src_col'] or not x['tgt_col'])}) → {p}")


if __name__ == '__main__':
    main(sys.argv[1].upper())
