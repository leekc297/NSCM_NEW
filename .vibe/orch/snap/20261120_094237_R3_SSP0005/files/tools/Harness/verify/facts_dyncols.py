"""AS-IS 런타임(동적) 그리드 컬럼 패밀리 추출 — Doc/asisfacts/screens/<AS-IS ID>/dyn_columns.csv (2026-10-30 SCP0111 월 컬럼 검사 우주 밖 · 검사기 결함 T15)

  python tools/Harness/verify/facts_dyncols.py <AS-IS ID>

무엇: 화면 코드가 루프/데이터로 만드는 컬럼(월·주·일 캘린더 피벗 등)은 SCM_MST_SHEET_COLUMNS 메타에 없어 원장 COLUMN 행(D1·E1·H2·H8·D5)이 생기지 않았다.
  grid_code.csv 의 DB_DRIVEN/루프 안 Add*Column 선언을 '패밀리' 1건으로 기록하고, 같은 메서드의 Data.Common(Data.Type.<X>) 원천으로 TO-BE binding 정규식을 정한다.
  잠금(facts_lockrules)·셀 규칙(facts_cellrules)·원장(ledger)·프로브(_verify.spec)가 같은 키 '<DYNAMIC:<family>>' 로 연결된다.
열: family_id(<DYNAMIC:X>), method, line, sheet, api, cell_type, merge, width, visible, fixed_point, decimals, negative_red, separator, binding_regex, loop_source, header_source, ref
기본값 근거 = Doc/asisfacts/framework/spreadinfo_defaults.csv(facts_gridcols 가 원문 인용으로 기록) — 코드에 하드코딩하지 않는다.
"""
import csv
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
DOC = os.path.join(ROOT, 'Doc')
COLS = ['family_id', 'method', 'line', 'sheet', 'api', 'cell_type', 'merge', 'width', 'visible', 'fixed_point', 'decimals', 'negative_red', 'separator', 'binding_regex', 'loop_source', 'header_source', 'ref']
# Data.Type 원천 → TO-BE 그리드 binding 정규식(피벗 컬럼 명명 관례: YYYYMM · M_YYYYMM · W_YYYYMMDD · D_YYYYMMDD · Wnn)
BINDING_BY_SOURCE = [('CalendarMonth', r'^\d{6}$|^M_?\d{6}$'), ('CalendarWeek', r'^\d{6,8}$|^W_?\d{6,8}$|^W\d{2}$'), ('CalendarDay', r'^\d{8}$|^D_?\d{8}$')]
BINDING_DEFAULT = r'^[WMDY]?_?\d{6,8}$'
API_TYPE = [('AddComboColumn', 'COMBO'), ('AddNumTextColumn', 'NUMBER'), ('AddNumColumn', 'NUMBER'), ('AddDateColumn', 'DATE'), ('AddDateTimeColumn', 'DATETIME'),
            ('AddCheckColumn', 'CHECK'), ('AddTextColumn', 'TEXT'), ('AddExTextColumn', 'TEXT')]


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig', newline='') as f: return list(csv.DictReader(f))


def defaults():
    return {r['rule']: r for r in rd(os.path.join(DOC, 'asisfacts', 'framework', 'spreadinfo_defaults.csv'))}


def lit(v):
    m = re.fullmatch(r'\{\?(.+)\}', (v or '').strip()); v = m.group(1) if m else (v or '').strip()
    return v.split('.')[-1] if re.match(r'^(FPMerge|FPHAlign|FPVAlign)\.', v) else v


def tag_prefixes(files):
    """2026-11-10 T205(SSP0023 A8 허위 FAIL '동적 기간 칸 0개' — 화면은 X_D_20261010 255칸): 화면 코드가 컬럼 태그 앞에 붙이는 한 글자 접두(X_ · Y_ · Z_).
       근거 = 같은 화면 원문의 문자열 상수 "P_D_"/"P_W_"/"P_M_"/"P_Y_"(예 cs:2107 "X_D_" + CONFIRM_DAY) 또는 GetColumnTag(…).IndexOf("P_") == 0(cs:4477). 원문에 없으면 접두 없음."""
    ps = set()
    for f in files:
        fp = os.path.join(ROOT, 'GSCM', f.replace(chr(92), os.sep)) if f and not os.path.isabs(f) else f
        try: src = open(fp, encoding='utf-8-sig', errors='replace').read()
        except OSError: continue
        ps |= set(re.findall(r'"([A-Z])_[DWMY]_"', src))
        ps |= set(re.findall(r'GetColumnTag\([^()]*\)\.(?:IndexOf|StartsWith)\("([A-Z])_"\)\s*(?:==\s*0|\))', src))
    return sorted(ps - set('DWM'))  # D_·W_·M_ 는 기간 종류 글자 자체(IndexOf("D_")==0) — 바깥 접두 아님(DMF0082·SCP0016·SCP0111·SSP0005 오검출 대조)


def with_prefix(rx, ps):
    """'^A$|^B$' 각 대안 앞에 (?:(?:X|Y)_)? 접두 허용"""
    if not ps: return rx
    pre = '(?:(?:' + '|'.join(ps) + ')_)?'
    return '|'.join('^' + pre + '(?:' + a.strip().lstrip('^').rstrip('$') + ')$' for a in rx.split('|'))


def main():
    sid = (sys.argv[1] if len(sys.argv) > 1 else '').upper()
    if not sid: print(__doc__); return 2
    sdir = os.path.join(DOC, 'asisfacts', 'screens', sid)
    gc = [r for r in rd(os.path.join(sdir, 'grid_code.csv')) if r.get('variant', 'current') != 'legacy' and r.get('kind') == 'COLUMN']
    acts = rd(os.path.join(sdir, 'actions.csv'))
    D = defaults()
    out = []
    for r in gc:
        api = r.get('api') or ''
        cond = r.get('conditions') or ''
        if not (r.get('source') == 'DB_DRIVEN' or re.search(r'\b(for|foreach|while)\b', cond)):
            continue
        meth = r.get('member') or ''
        # 루프 원천: 같은 메서드의 Data.Common(Data.Type.X …) → 패밀리 키
        src_type = ''
        for a in acts:
            if a.get('method') == meth and 'Data.Common' in (a.get('target') or ''):
                m = re.search(r'Data\.Type\.(\w+)', a.get('value') or '')
                if m: src_type = m.group(1); break
        if not src_type:
            m = re.search(r'(dt\w+)', cond)
            src_type = m.group(1) if m else 'LOOP'
        fam = f'<DYNAMIC:{src_type}>'
        ctype = next((t for a, t in API_TYPE if api.startswith(a)), api)
        names = (r.get('arg_names') or '').split(',')
        args = [x.strip() for x in (r.get('args') or '').split('¦')]
        argmap = {n.strip(): lit(args[i]) for i, n in enumerate(names) if i < len(args)}
        n_args = len(args)
        fixed = ''
        if ctype == 'NUMBER':
            if 'blFixedPoint' in argmap: fixed = 'Y' if argmap['blFixedPoint'] == 'true' else 'N'
            elif api.startswith('AddNumColumn') and n_args <= 5: fixed = 'Y' if (D.get('addnumcolumn_5arg_fixedpoint', {}).get('value') or '').lower() == 'true' else 'N'
        dec = ''
        if ctype == 'NUMBER':
            dec = argmap.get('pDecPlaces') or argmap.get('iDecimal') or ('0' if fixed == 'Y' else '')
        neg = 'Y' if ctype == 'NUMBER' and (D.get('number_negative_red', {}).get('value') or '').lower() == 'true' else ('' if ctype != 'NUMBER' else 'N')
        sep = 'Y' if ctype == 'NUMBER' and (argmap.get('pShowSep', 'true') == 'true') else ('' if ctype != 'NUMBER' else 'N')
        rx = with_prefix(next((b for s, b in BINDING_BY_SOURCE if s.lower() == src_type.lower()), BINDING_DEFAULT), tag_prefixes([r.get('file') or '']))
        out.append({'family_id': fam, 'method': meth, 'line': r.get('line', ''), 'sheet': r.get('sheet_hint') or '', 'api': api, 'cell_type': ctype,
                    'merge': lit(argmap.get('merge', '')), 'width': argmap.get('fWidth', ''), 'visible': argmap.get('bVisible', ''), 'fixed_point': fixed, 'decimals': dec,
                    'negative_red': neg, 'separator': sep, 'binding_regex': rx, 'loop_source': src_type, 'header_source': lit(r.get('header') or ''),
                    'ref': f"{os.path.basename((r.get('file') or '').replace(chr(92), '/'))}:{r.get('line', '')} · {D.get('number_negative_red', {}).get('ref', '')}"})
    # 같은 패밀리 중복 제거 — 2026-11-10 T205: 첫 줄이 아니라 '보이는' 선언 우선(SSP0023 첫 줄 = 이름에 B_ 있는 숨김 분기 AddTextColumn 폭 0 ·
    #   실제 표시 칸은 else 분기 AddNumColumn 폭 100 — 첫 줄을 쓰면 패밀리 속성이 TEXT·숨김으로 기록됨). 보이는 선언이 없으면 첫 줄
    hidden = lambda o: (o['width'] or '').strip() == '0' or (o['visible'] or '').strip().lower() == 'false'
    seen, uniq = {}, []
    for o in out:
        k = o['family_id']
        if k not in seen: seen[k] = len(uniq); uniq.append(o)
        elif hidden(uniq[seen[k]]) and not hidden(o): uniq[seen[k]] = o
    p = os.path.join(sdir, 'dyn_columns.csv')
    with open(p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows(uniq)
    print(f"{sid}: 동적 컬럼 패밀리 {len(uniq)}건 → {p}" + (' · ' + ', '.join(f"{o['family_id']} {o['cell_type']} 소수{o['decimals'] or '-'} 음수빨강{o['negative_red'] or '-'} /{o['binding_regex']}/" for o in uniq) if uniq else ''))
    return 0


if __name__ == '__main__':
    sys.exit(main())
