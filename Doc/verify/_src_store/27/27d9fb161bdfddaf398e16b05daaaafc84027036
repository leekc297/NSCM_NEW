# -*- coding: utf-8 -*-
"""sheet_nav_gen.py — 상세 시트 진입 사실(sheet_nav.json 'drill') 생성 (2026-11-26 T662 · 사용자 'sheet_nav 생성기도 만들어서 상세 시트 진입 보완')

  배경(T661): 다중 시트 화면의 상세 시트(SSP0015 Shipment Confirm Detail 등)는 탭이 아니라 메인 그리드 칸 더블클릭으로 채워진다.
    시트 이동 사실(Doc/verify/<ID>/sheet_nav.json)이 SCP0104 1화면(수작업)에만 있어 검사기가 상세 시트 칸을 메인 그리드에서 재거나 못 쟀다.
  근거 = AS-IS 원문만. 그리드 더블클릭 처리 메서드(*CellDoubleClick) 안의 `<si>.ChangeSheet(SpdSheet.shtX)` 문장마다 원문 가드(if 사슬)를 읽어
    base  바탕 시트 = 가드 `<si>.ActiveSheetIndex == N` → 그 스프레드의 N번째 AddSheet(없으면 그 스프레드의 첫 AddSheet · 하나뿐이면 그것)
    row   행 조건 = `<si>.GetText|GetValue(e.Row, …GetColumnIndex(DefColumns.C))[.ToString()] == "v"` · 변수 == "v"(같은 메서드의 `변수 = …Get*(e.Row, …C)`) · `!= ""` 는 빈값 아님('!')
    cell  칸 조건 = `e.Column == …GetColumnIndex(DefColumns.C)` → {col: C} · `e.Column >= …(C) + 1` → {after: C} · 분기 안 `GetColumnTag(e.Column)` 과 "D_" → {tag: "D_"}
    rest  해석 못 한 원자(검사기는 무시하고 진입 결과로 확인) · IsLock·null 검사는 화면 모드라 뺀다(TO-BE 상시 편집 CR-084·093)
    || 묶음은 첫 갈래만 쓴다(진입 한 경로만 필요). else of(앞 형제 부정)는 양의 정보가 없어 쓰지 않는다
  출력: Doc/verify/<ID>/sheet_nav.json 의 sheets.<시트>.drill (+ _gen). 사람이 적은 항목(drill 아닌 키가 있는 시트)은 건드리지 않는다. 지난 생성분만 다시 쓴다.
  사용:
    python tools/Harness/verify/sheet_nav_gen.py <ID> [--asis <AS-IS ID>] [--dry]
    python tools/Harness/verify/sheet_nav_gen.py --selftest
"""
import csv, collections, io, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
csv.field_size_limit(10 ** 9)

RX_GETROW = r'\w+\.Get(?:Text|Value)\(\s*e\.Row\s*,\s*\w+\.GetColumnIndex\(\s*Def\w*\.([A-Z0-9_]+)(?![a-z])\s*\)\s*\)(?:\.ToString\(\))?(?:\.Trim\(\))?'


def _split_top(s, op):
    out, d, cur, i, q = [], 0, '', 0, False
    while i < len(s):
        ch = s[i]
        if ch == '"' and (i == 0 or s[i - 1] != '\\'):
            q = not q
        if not q:
            if ch == '(':
                d += 1
            elif ch == ')':
                d -= 1
            if d == 0 and s.startswith(op, i):
                out.append(cur); cur = ''; i += len(op); continue
        cur += ch; i += 1
    out.append(cur)
    return [x.strip() for x in out if x.strip()]


def _strip_par(t):
    t = t.strip()
    while t.startswith('(') and t.endswith(')'):
        d = 0; ok = True
        for k, ch in enumerate(t):
            d += ch == '('; d -= ch == ')'
            if d == 0 and k < len(t) - 1:
                ok = False; break
        if not ok:
            break
        t = t[1:-1].strip()
    return t


def parse_guard(segs, var_col):
    """원문 가드 사슬(▸ 로 나뉜 'if (…)'·'else if (…)'·'else of (…)') → {si_index, row, cell, rest}"""
    out = {'idx': None, 'row': {}, 'cell': {}, 'rest': []}

    def atoms(cond):
        cond = _strip_par(cond)
        ors = _split_top(cond, '||')
        if len(ors) > 1:
            return atoms(ors[0])
        ands = _split_top(cond, '&&')
        if len(ands) > 1:
            return [a for x in ands for a in atoms(x)]
        return [cond]

    for seg in segs:
        seg = seg.strip()
        m = re.match(r'^(?:else\s+)?if\s*\((.*)\)\s*$', seg, re.S)
        if not m:
            continue  # else of(부정) · for · switch — 양의 정보 없음
        for a in atoms(m.group(1)):
            a = _strip_par(a)
            if re.fullmatch(r'\w+\s*!=\s*null|null\s*!=\s*\w+', a) or re.search(r'\.IsLock\(', a):
                continue
            mi = re.fullmatch(r'\w+\.ActiveSheetIndex\s*==\s*(\d+)', a)
            if mi:
                out['idx'] = int(mi.group(1)); continue
            mc = re.fullmatch(r'e\.Column\s*==\s*\w+\.GetColumnIndex\(\s*Def\w*\.([A-Z0-9_]+)(?![a-z])\s*\)', a)
            if mc:
                out['cell'] = {'col': mc.group(1)}; continue
            ma = re.fullmatch(r'e\.Column\s*>=?\s*\w+\.GetColumnIndex\(\s*Def\w*\.([A-Z0-9_]+)(?![a-z])\s*\)\s*(?:\+\s*1)?', a)
            if ma:
                out['cell'] = out['cell'] or {'after': ma.group(1)}; continue
            mr = re.fullmatch(RX_GETROW + r'\s*(==|!=)\s*"([^"]*)"', a)
            if mr:
                c, op, v = mr.group(1), mr.group(2), mr.group(3)
                out['row'][c] = v if op == '==' else ('!' if v == '' else out['row'].get(c, '!' + v))
                continue
            mv = re.fullmatch(r'(\w+)(?:\.ToString\(\))?\s*(==|!=)\s*"([^"]*)"', a)
            if mv and var_col(mv.group(1)):
                c, op, v = var_col(mv.group(1)), mv.group(2), mv.group(3)
                out['row'][c] = v if op == '==' else ('!' if v == '' else out['row'].get(c, '!' + v))
                continue
            out['rest'].append(a[:120])
    return out


def build(sid, acts, src_lines, R):
    """AS-IS 사실·원문 → {시트: {'drill': …} | {'tabsearch': …}}"""
    cnt = collections.Counter(a['class'] for a in acts)
    main_cls = cnt.most_common(1)[0][0] if cnt else ''
    code = [l_.split('//')[0] for l_ in src_lines]
    # 스프레드 ↔ 시트(AddSheet 순서) · si 변수 ↔ 스프레드(GetSheetInfo)
    sheets_of_spd, si_spd = collections.OrderedDict(), {}
    for l_ in code:
        for ma in re.finditer(r'\bAddSheet\(\s*(\w+)\s*,\s*([\w.]+|"[^"]*")', l_):
            sv = ma.group(2) if ma.group(2).startswith('"') else (R.const_value(ma.group(2)) or '')
            if sv.startswith('"'):
                lst = sheets_of_spd.setdefault(ma.group(1), [])
                if sv.strip('"') not in lst:
                    lst.append(sv.strip('"'))
        for ma in re.finditer(r'\b(\w+)\s*=\s*(?:this\.)?GetSheetInfo\(\s*(\w+)\.Name\b', l_):
            si_spd.setdefault(ma.group(1), ma.group(2))
    # 더블클릭 처리 메서드 → 스프레드(events.csv '+=' 대상)
    meth_spd = {}
    try:
        for ev in csv.DictReader(open(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid, 'events.csv'), encoding='utf-8-sig')):
            if (ev.get('variant') or 'current') != 'legacy' and (ev.get('op') or '+=') == '+=' and 'DoubleClick' in (ev.get('event') or ev.get('target') or '') + (ev.get('handler') or ''):
                meth_spd.setdefault((ev.get('handler') or '').strip(), (ev.get('target') or '').replace('this.', '').split('.')[0])
    except OSError:
        pass
    def sheet_of(x):
        mv = re.search(r'\(\s*((?:\w+\.)*sht\w+)\s*\)', x.get('value') or '')
        tv = R.const_value(mv.group(1)) if mv else None
        return tv.strip('"') if tv and tv.startswith('"') else ''

    def drill_at(x):
        """더블클릭 처리 메서드의 문장 x(시트 전환 또는 조회 메서드 호출) → (드릴 사실, 바탕 스프레드) · 바탕 미확정이면 (None, '')"""
        key = (x['class'], x['method']); ln = int(x['line'] or 0)
        sg = R.source_guard(key, ln) or x.get('guard') or ''
        segs = [s_.strip() for s_ in sg.split('▸') if s_.strip()]
        lo, hi = R.spans.get(key, (ln, ln))

        def var_col(v, lo=lo, ln=ln):
            cols = set()
            for i in range(max(lo, 1), min(ln, len(code)) + 1):
                m_ = re.search(r'\b' + re.escape(v) + r'\s*=(?!=)\s*' + RX_GETROW, code[i - 1])
                if m_:
                    cols.add(m_.group(1))
            return cols.pop() if len(cols) == 1 else ''
        g = parse_guard(segs, var_col)
        if not g['cell']:
            for i in range(max(lo, ln - 25), ln + 1):
                if i <= len(code) and re.search(r'GetColumnTag\(\s*e\.Column\s*\)', code[i - 1]) and '"D_"' in code[i - 1]:
                    g['cell'] = {'tag': 'D_'}
        spd = meth_spd.get(x['method']) or ('spd' + re.sub(r'^Spd|_CellDoubleClick$|_DoubleClick$', '', x['method'])) if x['method'] else ''
        if spd not in sheets_of_spd:
            alt = [s_ for s_ in sheets_of_spd if s_.lower() == spd.lower()]
            spd = alt[0] if alt else spd
        bl = sheets_of_spd.get(spd, [])
        base = bl[g['idx']] if g['idx'] is not None and g['idx'] < len(bl) else (bl[0] if bl else '')
        if not base:
            return None, ''
        # T663(DMF0004 spdMain_CellDoubleClick:2012 'siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer'): 하위 스프레드의 활성 시트 조건 = 더블클릭 전에 그 탭을 먼저 고른다(pretab)
        pretab, rest = '', []
        for a_ in g['rest']:
            ms_ = re.fullmatch(r'\w+\.ActiveSheet\.SheetName\s*==\s*((?:\w+\.)*sht\w+)', a_)
            cv_ = R.const_value(ms_.group(1)) if ms_ else None
            if cv_ and cv_.startswith('"'):
                if cv_.strip('"') != base:
                    pretab = cv_.strip('"')
                continue
            rest.append(a_)
        g['rest'] = rest
        return {'base': base, **({'pretab': pretab} if pretab else {}), 'row': g['row'], 'cell': g['cell'], 'rest': g['rest'][:4],
                'src': f"{os.path.basename(x.get('file') or '').replace(chr(92), '/')}:{ln} {x['method']}"}, spd

    def better(d, prev):
        return not prev or (len(d['rest']), not d['row'], 'tab' in d) < (len(prev['rest']), not prev['row'], 'tab' in prev)

    out = {}
    dbl = [x for x in acts if x['class'] == main_cls and 'DoubleClick' in x['method']]
    # ① 더블클릭 처리 메서드 안의 시트 전환 = 드릴
    for x in dbl:
        if not re.search(r'\.ChangeSheet$', x['target'] or ''):
            continue
        target = sheet_of(x)
        if not target:
            continue
        d, spd = drill_at(x)
        tspd = si_spd.get(x['target'].split('.')[0], '')
        if not d or d['base'] == target or (tspd and tspd == spd):
            continue  # 같은 스프레드 안 시트 전환(탭) 또는 바탕 시트 미확정 — 드릴 대상 아님
        if better(d, (out.get(target) or {}).get('drill')):
            out[target] = {'drill': d}
    # ② T663: 더블클릭 분기가 부른 조회 메서드 안의 시트 전환(SSP0015 FindData_block_stock → Hold stock Detail) = 같은 드릴 + 그 시트 탭
    sw = collections.defaultdict(list)
    for x in acts:
        if x['class'] == main_cls and 'DoubleClick' not in x['method'] and re.search(r'\.ChangeSheet$', x['target'] or ''):
            t_ = sheet_of(x)
            if t_:
                sw[x['method']].append((t_, x))
    for x in dbl:
        if x.get('kind') != 'CALL_LOCAL' or x['target'] not in sw:
            continue
        d, spd = drill_at(x)
        if not d:
            continue
        for target, y in sw[x['target']]:
            tspd = si_spd.get(y['target'].split('.')[0], '')
            if d['base'] == target or (tspd and tspd == spd) or 'drill' in (out.get(target) or {}) and 'tab' not in out[target]['drill']:
                continue
            d2 = dict(d, tab=target, src=d['src'] + f" → {x['target']}:{y['line']}")
            if better(d2, (out.get(target) or {}).get('drill')):
                out[target] = {'drill': d2}
    # ③ T663: 버튼 클릭 진입점 메서드 안의 시트 전환(SSP0015 BtnSearch_Click · 상세 영역 Search) = 그 시트 탭 + 그 버튼
    btn_txt = {}
    try:
        for r in csv.DictReader(open(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid, 'props.csv'), encoding='utf-8-sig')):
            if (r.get('variant') or 'current') != 'legacy' and r.get('prop') == 'Text' and r.get('class') == main_cls:
                btn_txt.setdefault(r.get('target') or '', (r.get('value') or '').strip().strip('"'))
    except OSError:
        pass
    ent_btn = collections.defaultdict(set)
    try:
        for e in csv.DictReader(open(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid, 'actions_entries.csv'), encoding='utf-8-sig')):
            m_ = re.fullmatch(r'this\.(\w+)\.Click', (e.get('entry') or '').strip())
            if m_ and e.get('class') == main_cls and btn_txt.get(m_.group(1)):
                ent_btn[e.get('method') or ''].add(m_.group(1))
    except OSError:
        pass
    tabbed = {s_ for lst in sheets_of_spd.values() if len(lst) > 1 for s_ in lst}
    for meth, lst in sw.items():
        for btn in sorted(ent_btn.get(meth, ())):
            for target, y in lst:
                if target in out or target not in tabbed:
                    continue
                out[target] = {'tabsearch': {'tab': target, 'button': btn_txt[btn], 'ctl': btn,
                                             'src': f"{os.path.basename(y.get('file') or '').replace(chr(92), '/')}:{y['line']} {meth} ← this.{btn}.Click"}}
    return out


def run(sid, asis, dry=False):
    from asis_live import _src_path
    import facts_lockrules as FL
    sdir = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', asis)
    ap = os.path.join(sdir, 'actions.csv')
    if not os.path.exists(ap):
        print(f'[sheet_nav_gen] {sid}: actions.csv 없음 — 건너뜀'); return 0
    from asis_variant import is_cur
    cur_files = {f_['file'] for f_ in csv.DictReader(open(os.path.join(sdir, 'files.csv'), encoding='utf-8-sig')) if is_cur(f_)} if os.path.exists(os.path.join(sdir, 'files.csv')) else set()
    acts = [x for x in csv.DictReader(open(ap, encoding='utf-8-sig')) if not cur_files or x['file'] in cur_files]  # 현재판 원문만(facts_lockrules 와 같은 기준)
    cnt = collections.Counter(a['class'] for a in acts)
    main_cls = cnt.most_common(1)[0][0] if cnt else ''
    f = next((a['file'] for a in acts if a['class'] == main_cls and (a.get('file') or '').endswith('.cs')), '')
    sp = _src_path(f) if f else ''
    if not sp or not os.path.exists(sp):
        print(f'[sheet_nav_gen] {sid}: 메인 원문 없음 — 건너뜀'); return 0
    src = FL.strip_comments(open(sp, encoding='utf-8-sig', errors='replace').read()).split('\n')
    spans = {}
    for x in acts:
        k = (x['class'], x['method']); ln = int(x['line'] or 0)
        lo, hi = spans.get(k, (ln, ln)); spans[k] = (min(lo, ln), max(hi, ln))
    R = FL.Resolver(src, spans, acts)
    nav = build(asis, acts, src, R)
    op = os.path.join(ROOT, 'Doc', 'verify', sid, 'sheet_nav.json')
    cur = {}
    if os.path.exists(op):
        cur = json.load(open(op, encoding='utf-8-sig'))
    sheets = dict(cur.get('sheets') or {})
    kept = {k: v for k, v in sheets.items() if not (isinstance(v, dict) and v.get('_gen') == 'sheet_nav_gen')}
    added = 0
    for t, d in nav.items():
        if t in kept:
            continue  # 사람이 적은 항목 우선
        kept[t] = dict(d, _gen='sheet_nav_gen'); added += 1
    print(f"[sheet_nav_gen] {sid}: 상세 시트 진입 {len(nav)}건(새로 씀 {added} · 사람 항목 유지 {len([k for k in kept if not (isinstance(kept[k], dict) and kept[k].get('_gen'))])})")
    for t, v in nav.items():
        if 'drill' in v:
            d = v['drill']
            print(f"   {t} ← 드릴 {d['base']}{' · 먼저 탭 ' + d['pretab'] if d.get('pretab') else ''} · 행 {d['row'] or '-'} · 칸 {d['cell'] or '-'}{' · 탭 ' + d['tab'] if d.get('tab') else ''}{' · 미해석 ' + ' / '.join(d['rest']) if d['rest'] else ''} · {d['src']}")
        else:
            ts = v['tabsearch']
            print(f"   {t} ← 탭 + '{ts['button']}' 버튼 · {ts['src']}")
    if dry:
        return 0
    had_gen = any(isinstance(v, dict) and v.get('_gen') == 'sheet_nav_gen' for v in sheets.values())
    if not nav and not had_gen:
        return 0  # 만들 것도 지울 생성분도 없음 — 사람이 적은 파일을 다시 쓰지 않는다
    doc = dict(cur); doc['sheets'] = kept
    doc.setdefault('_doc', '시트 이동 사실. drill 항목은 tools/Harness/verify/sheet_nav_gen.py 가 AS-IS 그리드 더블클릭 → ChangeSheet 원문에서 만든다(_gen). 그 밖은 사람이 적은 항목')
    os.makedirs(os.path.dirname(op), exist_ok=True)
    t_ = op + '.tmp'
    io.open(t_, 'w', encoding='utf-8').write(json.dumps(doc, ensure_ascii=False, indent=1))
    os.replace(t_, op)
    return 0


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok = ok and bool(c)
    vc = lambda v: 'MEASURE' if v == 'sMeasure' else ''
    g = parse_guard(['if (siMain.ActiveSheetIndex == 0)', 'if (siMain != null && siMain.IsLock(siMain.SheetName) == true)', 'if (sMeasure == "SHIP_CONFIRM")'], vc)
    chk('시트 번호·모드 제외·변수 행 조건', g['idx'] == 0 and g['row'] == {'MEASURE': 'SHIP_CONFIRM'} and not g['rest'] and not g['cell'])
    g = parse_guard(['if (e.Column >= siMain.GetColumnIndex(DefColumns.MEASURE) + 1 &&  siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)) == "SHIP_PLAN")'], vc)
    chk('뒤 칸 + 직접 읽기 행 조건', g['cell'] == {'after': 'MEASURE'} and g['row'] == {'MEASURE': 'SHIP_PLAN'})
    g = parse_guard(['else if (e.Column == siMain.GetColumnIndex(DefColumns.BOH_QTY) && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.BOH_TYPE)) == "ERP")'], vc)
    chk('else if 칸 지정 + 행 조건', g['cell'] == {'col': 'BOH_QTY'} and g['row'] == {'BOH_TYPE': 'ERP'})
    g = parse_guard(['if (e.Column >= siMain.GetColumnIndex(DefColumns.FCST_TYPE) + 1 && (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)) == "SHIP_PLAN" || (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.MEASURE)) == "X" && siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE)) != "")))'], vc)
    chk('|| 첫 갈래만', g['row'] == {'MEASURE': 'SHIP_PLAN'} and g['cell'] == {'after': 'FCST_TYPE'})
    g = parse_guard(['else of (sMeasure == "A")', 'if (bFlag == true)'], vc)
    chk('else of 무시 · 해석 못 한 원자는 rest', g['row'] == {} and g['rest'] == ['bFlag == true'])
    g = parse_guard(['if (siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE)) != "")'], vc)
    chk('빈값 아님', g['row'] == {'TO_SITE': '!'})
    chk('대소문자 섞인 칸 상수는 잡지 않음', parse_guard(['if (e.Column == siMain.GetColumnIndex(DefColumns.ItemId))'], vc)['cell'] == {})
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        sys.exit(selftest())
    a = [x for x in sys.argv[1:] if not x.startswith('--')]
    if not a:
        print(__doc__); sys.exit(2)
    asis = sys.argv[sys.argv.index('--asis') + 1] if '--asis' in sys.argv else a[0]
    sys.exit(run(a[0].upper(), asis.upper(), dry='--dry' in sys.argv))
