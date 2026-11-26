# -*- coding: utf-8 -*-
"""AS-IS 팝업 사실 추출 - 팝업마다 트리거·조건 칸·SP·정렬·선택 방식·병합·저장 (2026-10-31 E02 팝업 검사기)

  python -I tools/Harness/verify/facts_popup.py <AS-IS ID> [...]   -> Doc/verify/_parallel/E02/facts/<ID>.json
  python -I tools/Harness/verify/facts_popup.py --all               -> Fact Pack 있는 전 화면

원천(화면 고유값 없음)
  - 호출: popup_args_check.asis_popups(실행 안 되는 메서드 제외 = asis_live.dead_methods)
  - 팝업 클래스 내부: Doc/asisfacts/screens/<ID>/{actions,props,controls}.csv (Fact Pack 이 팝업 클래스도 담는다)
  - SP 원문: Doc/asisfacts/db/modules/dbo.<SP>.sql (facts_sortrules.strip_comments 로 주석 제거 후 판단)

추출 한계(명시)
  - 트리거 분류는 메서드 이름 관례(btnX_Click·*DoubleClick*·InsertButton)만. 다른 이름의 핸들러는 kind=OTHER 로 남기고 E2E 는 ERROR 로 보고한다.
  - 호출부의 콤보 값 조건(guard)은 원문 그대로 guard 에 적는다. 평가하지 않는다.
  - SP 원문이 없으면 order_known=false, like/upper/comma 는 null(미확인) - 기대값으로 쓰지 말 것.
  - 동적 SQL 안 LIKE/UPPER 는 문자열 포함 여부로만 본다(실행 분기 미평가).
"""
import csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from popup_args_check import asis_popups  # noqa: E402
from facts_sortrules import strip_comments  # noqa: E402

ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
SCR = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens')
MOD = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules')
OUT = os.path.join(ROOT, 'Doc', 'verify', '_parallel', 'E02', 'facts')
csv.field_size_limit(10 ** 8)
rd = lambda p: list(csv.DictReader(open(p, encoding='utf-8-sig', newline=''))) if os.path.exists(p) else []

INPUT_T = re.compile(r'Usr(TextBox|TextEdit|Text|Combo|CheckedList|CheckedListBox|DatePicker|DateRangePicker\d*|MonthPicker|MonthRangePicker|WeekPicker|SpinEdit|MultiLineEditor|Lookup\w*|ButtonEdit)\b|TextEdit\b|ComboBox\w*\b', re.I)
SAVE_SP = re.compile(r'(SAVE|_INS|_UPD|_DEL|INSERT|UPDATE|DELETE|MERGE|CREATE|BATCH|COPY|TRANSFER)', re.I)
_sp_cache = {}


def unq(v):
    v = (v or '').strip()
    m = re.fullmatch(r'"(.*)"', v, re.S)
    return m.group(1) if m else v


def sp_facts(sp):
    """SP 원문 주석 제거 후 ORDER BY(최상위) · LIKE · UPPER · 콤마 분해 호출 존재"""
    if sp in _sp_cache:
        return _sp_cache[sp]
    fp = os.path.join(MOD, f'dbo.{sp}.sql')
    r = {'sp': sp, 'src': '', 'order_known': False, 'order_keys': '', 'order_line': '', 'like': None, 'upper': None, 'comma': None, 'params': []}
    if os.path.exists(fp):
        txt = strip_comments(open(fp, encoding='utf-8-sig', errors='replace').read())
        r['src'] = os.path.relpath(fp, ROOT).replace('\\', '/')
        r['order_known'] = True
        lines = txt.split('\n')
        last = None
        depth = 0
        for i, ln in enumerate(lines, 1):
            m = re.search(r'\bORDER\s+BY\s+(.+)$', ln, re.I)
            if m and depth <= 0 and not re.search(r'OVER\s*\(', ln, re.I) and 'ROW_NUMBER' not in ln.upper():
                last = (i, re.sub(r"['\s\[\]]+", ' ', m.group(1)).strip())
            depth += ln.count('(') - ln.count(')')
        if last:
            r['order_keys'], r['order_line'] = last[1][:200], str(last[0])
        up = txt.upper()
        r['like'] = ' LIKE ' in up or 'LIKE(' in up
        r['upper'] = 'UPPER(' in up
        r['comma'] = bool(re.search(r"STRING_SPLIT|FN_SPLIT|FN_STRSPLIT|SPLIT\w*\(|CHARINDEX\(\s*','", up))
        r['params'] = re.findall(r'@(\w+)\s+(?:N?VARCHAR|VARCHAR|INT|BIT|DATETIME|DATE|DECIMAL|NUMERIC|CHAR)', txt[:6000], re.I)[:40]
    _sp_cache[sp] = r
    return r


def classify_trigger(p, ctl_names, acts_main):
    m = p['method']
    if re.search(r'DoubleClick', m, re.I):
        # 호출 줄 guard 체인에서 DefColumns.X 추출 — 같은 메서드 같은 줄 행의 guard 를 쓴다
        guard = ''
        for a in acts_main:
            if a['method'] == m and a['line'] == p['line']:
                guard = a.get('guard', '') or guard
        hits = re.findall(r'e\.Column\s*==\s*\w+\.GetColumnIndex\(\s*(?:[\w.]*DefColumns\.)?"?([A-Za-z0-9_]+)"?', guard)
        if not hits:
            hits = re.findall(r'DefColumns\.([A-Z0-9_]+)', guard)
        if not hits:
            hits = re.findall(r'==\s*"([A-Z0-9_]+)"', guard)
        col = hits[-1] if hits else ''
        return {'kind': 'CELL', 'control': (m.split('_')[0]), 'column': col, 'guard': guard[:400]}
    mm = re.match(r'(?i)(btn\w+?)_(Click|ButtonClick)$', m)
    if mm:
        c = mm.group(1)
        c = next((n for n in ctl_names if n.lower() == c.lower()), c)
        suf = c[3:]
        txt = next((n for n in ctl_names if n.lower() in (f'txt{suf}'.lower(), f'txt{suf}id'.lower(), f'clb{suf}'.lower(), f'cbo{suf}'.lower())), '')
        return {'kind': 'COND' if txt else 'BTN', 'control': c, 'input': txt, 'column': '', 'guard': ''}
    if re.match(r'(?i)(txt\w+?)_(KeyDown|KeyPress|KeyUp|ButtonClick|Click|EditValueChanged)$', m):
        return {'kind': 'COND', 'control': m.split('_')[0], 'input': m.split('_')[0], 'column': '', 'guard': ''}
    if re.match(r'(?i)InsertButton', m):
        return {'kind': 'INSERT', 'control': 'Insert', 'column': '', 'guard': ''}
    return {'kind': 'OTHER', 'control': m, 'column': '', 'guard': ''}


def popup_class(cls, acts, props, ctrls):
    A = [a for a in acts if a['class'] == cls]
    P = [x for x in props if x['class'] == cls]
    C = [x for x in ctrls if x['class'] == cls]
    file = next((a['file'] for a in A), next((x['file'] for x in P), ''))
    if not A and not P and not C:
        return {'cls': cls, 'in_pack': False}
    pv = {}
    for x in P:
        pv.setdefault(x['target'], {})[x['prop']] = (x['value'], x['line'], x['file'])
    title = ''
    for t in ('this', '$this', ''):
        if t in pv and 'Text' in pv[t]:
            title = unq(pv[t]['Text'][0])
    labels = {}
    for tgt, d in pv.items():
        if 'Control' in d:
            c = d['Control'][0].replace('this.', '').strip()
            if 'Text' in d:
                labels[c] = unq(d['Text'][0])
    conds, buttons = [], []
    for x in C:
        n, t = x['name'], x['type']
        d = pv.get(n, {})
        if re.search(r'UsrButton|SimpleButton', t):
            vis = unq(d.get('Visible', ('true',))[0]).lower() != 'false'
            buttons.append({'name': n, 'text': unq(d.get('Text', ('',))[0]), 'visible': vis})
        elif INPUT_T.search(t):
            en = d.get('Enabled')
            ro = d.get('ReadOnly') or d.get('Properties.ReadOnly')
            conds.append({'name': n, 'type': t.split('.')[-1], 'label': labels.get(n, unq(d.get('Text', ('',))[0]) if 'Check' in t else ''),
                          'visible_designer': unq(d.get('Visible', ('true',))[0]).lower() != 'false',
                          'disabled_designer': bool((en and en[0].strip().lower() == 'false') or (ro and ro[0].strip().lower() == 'true')),
                          'ref': f"{os.path.basename(x['file'])}:{x['line']}"})
    # 코드에서 고정·비활성(무가드 = 항상)
    states = {}
    for a in A:
        m = re.match(r'(\w+)\.(Enabled|ReadOnly|Properties\.ReadOnly|Visible)$', a['target'] or '')
        if a['kind'] in ('STATE', 'UI_PROP', 'VALUE_SET', 'FLAG') and m:
            states.setdefault(m.group(1), []).append({'prop': m.group(2), 'value': (a['value'] or '').strip(), 'guard': (a['guard'] or '')[:160], 'ref': f"{os.path.basename(a['file'])}:{a['line']}", 'method': a['method']})
    is_dis = lambda s: (s['prop'] == 'Enabled' and s['value'].lower() == 'false') or (s['prop'].endswith('ReadOnly') and s['value'].lower() == 'true')
    for c in conds:
        st = states.get(c['name'], [])
        c['disabled_code'] = next((s for s in st if is_dis(s) and not s['guard']), None)
        c['disabled_guarded'] = [s for s in st if is_dis(s) and s['guard']][:3]
        c['hidden_code'] = next((s for s in st if s['prop'] == 'Visible' and s['value'].lower() == 'false' and not s['guard']), None)
    sps = []
    for a in A:
        if a['kind'] != 'ENDPOINT':
            continue
        for ep in re.findall(r'[A-Za-z0-9_.]+', a.get('endpoint') or a.get('value') or ''):
            sp = ep.split('.')[-1]
            if not re.match(r'[A-Z]{2,}\d*_', sp, re.I):
                continue
            f = dict(sp_facts(sp))
            f.update({'method': a['method'], 'ref': f"{os.path.basename(a['file'])}:{a['line']}", 'save': bool(SAVE_SP.search(sp)) and not re.search(r'_GET_', sp, re.I)})
            if not any(s['sp'] == sp and s['method'] == a['method'] for s in sps):
                sps.append(f)

    def grep(rx, kinds=None):
        o = []
        for a in A:
            if kinds and a['kind'] not in kinds:
                continue
            if re.search(rx, (a['target'] or '') + ' ' + (a['value'] or '') + ' ' + (a['raw'] or '')):
                o.append({'ref': f"{os.path.basename(a['file'])}:{a['line']}", 'method': a['method'], 'raw': (a['raw'] or '')[:160], 'guard': (a['guard'] or '')[:120]})
        return o
    return {
        'cls': cls, 'in_pack': True, 'file': (file or '').replace('\\', '/'), 'title': title,
        'conds': conds, 'buttons': buttons, 'sps': sps,
        'merge': grep(r'SpanModel|AddSpanCell|ColumnMerge|MergePolicy|SetColumnMerge|MergeRange|RowMerge|AutoSpan|SetMerge|\.Merge\b')[:6],
        'lock': grep(r'LockRange|\.Locked\s*=|SetLock|LockColumn')[:6],
        'color': grep(r'SetBGColor|BackColor')[:6],
        'dyn_cols': [x for x in grep(r'Add\w*Column|AddColumn|SetColumn\b') if re.search(r'\bfor(each)?\b', x['guard'])][:6],
        'multi_check': grep(r'AddCheckColumn|CheckColumn|SetCheckBox|CheckBoxCellType|CellType\s*=\s*.*Check')[:4],
        'selection': grep(r'SelectionPolicy|OperationMode|SelectionUnit|SelectionStyle')[:6],
        'filter': grep(r'AutoFilter|SetFilter|RowFilter|\.Filter\b')[:6],
        'sort': grep(r'\.Sort\(|SortRange|AutoSortColumn|AllowSort|DataView\.Sort|\.OrderBy\(')[:6],
        'close_after': grep(r'this\.Close\(|DialogResult\s*=')[:8],
        'messages': [x['raw'] for x in grep(r'ShowMessage|MessageBox|MSG\d{5}', {'MESSAGE'})][:12],
        'period_use': grep(r'drpPeriod|DateRange|FromDate|ToDate|StartDate|EndDate|MonthFrom|MonthTo')[:6],
    }


_SRC_IDX = {}


def src_index():
    if not _SRC_IDX:
        base = os.path.join(ROOT, 'GSCM', '06.UIL')
        for dp, _, fs in os.walk(base):
            for f in fs:
                if f.endswith('.cs') and not f.endswith('.Designer.cs'):
                    _SRC_IDX.setdefault(f[:-3], os.path.join(dp, f))
        _SRC_IDX.setdefault('__built__', '')
    return _SRC_IDX


def strip_cs(lines):
    """C# 주석 제거(줄 번호 유지) — 주석 코드는 근거가 아니다"""
    out, inb = [], False
    for ln in lines:
        s = ln
        if inb:
            j = s.find('*/')
            if j < 0:
                out.append('')
                continue
            s = s[j + 2:]
            inb = False
        s = re.sub(r'/\*.*?\*/', '', s)
        k = s.find('/*')
        if k >= 0:
            s = s[:k]
            inb = True
        # 문자열 밖 // 만 제거
        q = False
        for i in range(len(s) - 1):
            if s[i] == '"' and (i == 0 or s[i - 1] != '\\'):
                q = not q
            if not q and s[i:i + 2] == '//':
                s = s[:i]
                break
        out.append(s)
    return out


def src_records(cls):
    """Fact Pack 에 없는 공용 팝업 클래스 — .cs/.Designer.cs 원문을 actions/props/controls 와 같은 모양으로 읽는다.
    guard = 메서드 본문보다 깊은 들여쓰기면 '(중첩 블록)' (조건 평가 안 함 — 고정 판단에서 제외)."""
    fp = src_index().get(cls)
    if not fp:
        return [], [], []
    rel = os.path.relpath(fp, os.path.join(ROOT, 'GSCM')).replace('/', '\\')
    lines = strip_cs(open(fp, encoding='utf-8-sig', errors='replace').read().split('\n'))
    A, method, base = [], '', None
    for i, ln in enumerate(lines, 1):
        m = re.match(r'\s*(?:private|public|protected|internal)\s+(?:override\s+|static\s+|async\s+|virtual\s+)*[\w<>\[\],]+\s+(\w+)\s*\(', ln)
        if m:
            method, base = m.group(1), None
            continue
        st = ln.strip()
        if not st or st in '{}':
            continue
        ind = len(ln) - len(ln.lstrip())
        if base is None:
            base = ind
        guard = '(중첩 블록)' if ind > (base or 0) else ''
        ep = re.search(r'new\s+FoxDataRequest\(\s*"([^"]+)"', st)
        if ep:
            A.append({'method': method, 'file': rel, 'line': str(i), 'kind': 'ENDPOINT', 'target': '', 'value': ep.group(1), 'endpoint': ep.group(1), 'guard': guard, 'raw': st})
        as_ = re.match(r'(\w+(?:\.\w+)*)\s*=\s*(.+?);\s*$', st)
        kind = 'STATE' if as_ else 'EXPR'
        if re.search(r'ShowMessage|MessageBox\.Show|MSG\d{5}', st):
            kind = 'MESSAGE'
        A.append({'method': method, 'file': rel, 'line': str(i), 'kind': kind, 'target': as_.group(1) if as_ else '', 'value': as_.group(2) if as_ else '', 'endpoint': '', 'guard': guard, 'raw': st})
    P, C = [], []
    dp = fp[:-3] + '.Designer.cs'
    if os.path.exists(dp):
        drel = os.path.relpath(dp, os.path.join(ROOT, 'GSCM')).replace('/', '\\')
        for i, ln in enumerate(strip_cs(open(dp, encoding='utf-8-sig', errors='replace').read().split('\n')), 1):
            st = ln.strip()
            m = re.match(r'this\.(\w+)\s*=\s*new\s+([\w.]+)', st)
            if m:
                C.append({'file': drel, 'class': cls, 'name': m.group(1), 'type': m.group(2), 'line': str(i)})
                continue
            m = re.match(r'this\.(\w+)\.([\w.]+)\s*=\s*(.+?);\s*$', st)
            if m:
                P.append({'file': drel, 'class': cls, 'line': str(i), 'target': m.group(1), 'prop': m.group(2), 'value': m.group(3)})
                continue
            m = re.match(r'this\.(Text)\s*=\s*(.+?);\s*$', st)
            if m:
                P.append({'file': drel, 'class': cls, 'line': str(i), 'target': 'this', 'prop': 'Text', 'value': m.group(2)})
    for a in A:
        a['class'] = cls
    return A, P, C


def main_sort_after(p, acts_main):
    """호출 후 메인 그리드 재정렬(.Sort) · 재조회(FindData/Search) 사실"""
    L = int(p['line'] or 0)
    o = []
    for a in acts_main:
        if a['method'] != p['method'] or int(a['line'] or 0) <= L:
            continue
        raw = (a['raw'] or '')
        if re.search(r'\.Sort\(|SortRange|AutoSortColumn|DataView\.Sort|OrderBy\(|FindData|SearchButton', raw):
            o.append({'ref': f"{os.path.basename(a['file'])}:{a['line']}", 'raw': raw[:160]})
    return o[:6]


def run(aid):
    d = os.path.join(SCR, aid)
    if not os.path.isdir(d):
        return None
    acts = rd(os.path.join(d, 'actions.csv'))
    props = rd(os.path.join(d, 'props.csv'))
    ctrls = rd(os.path.join(d, 'controls.csv'))
    pops = asis_popups(aid)
    classes = {}
    calls = []
    seen = set()
    for p in pops:
        am = [a for a in acts if a['class'] == p['cls']]
        names = [c['name'] for c in ctrls if c['class'] == p['cls']]
        tr = classify_trigger(p, names, am)
        if tr.get('control') and tr['kind'] in ('BTN', 'COND'):
            lab = next((x for x in props if x['class'] == p['cls'] and x['target'] == tr['control'] and x['prop'] == 'Text'), None)
            tr['button_text'] = unq(lab['value']) if lab else ''
            lbl = None
            inp = tr.get('input') or ''
            for x in props:
                if x['class'] == p['cls'] and x['prop'] == 'Control' and x['value'].replace('this.', '').strip() == inp:
                    lbl = next((y for y in props if y['class'] == p['cls'] and y['target'] == x['target'] and y['prop'] == 'Text'), None)
            tr['cond_label'] = unq(lbl['value']) if lbl else ''
        ckey = (p['popup'], tr['kind'], tr.get('control'), tr.get('column'), p['method'])
        if ckey in seen:
            continue
        seen.add(ckey)
        multi = next((i for i in p['items'] if re.search(r'multi', i['param'], re.I)), None)
        pdiv = next((i for i in p['items'] if re.search(r'div', i['param'], re.I)), None)
        pper = [i for i in p['items'] if re.search(r'period|from|to|date|start|end', i['param'], re.I)]
        calls.append({'cls': p['popup'], 'method': p['method'], 'asis_ref': f"{p['file']}:{p['line']}", 'trigger': tr,
                      'multi': (multi or {}).get('arg', '') if (multi or {}).get('kind') == 'LITERAL' else '',
                      'div_arg': (pdiv or {}).get('arg', ''), 'period_args': [i['arg'] for i in pper],
                      'args': [{'param': i['param'], 'kind': i['kind'], 'arg': i['arg'][:80]} for i in p['items']],
                      'results': sorted(p.get('results') or []), 'after': main_sort_after(p, am),
                      'back': [{'ref': f"{os.path.basename(a['file'])}:{a['line']}", 'target': a['target'], 'value': (a['value'] or '')[:80]} for a in am
                               if a['method'] == p['method'] and int(a['line'] or 0) > int(p['line'] or 0) and a['target'] and re.search(r'(?i)\b(pop\w*|frm\w*|f[A-Z]\w*)\.', a['value'] or '')][:12]})
        if p['popup'] not in classes:
            k = popup_class(p['popup'], acts, props, ctrls)
            if not k.get('in_pack'):
                sa, sp_, sc = src_records(p['popup'])
                k = popup_class(p['popup'], sa, sp_, sc)
                k['from'] = 'source' if k.get('in_pack') else 'none'
            else:
                k['from'] = 'factpack'
            classes[p['popup']] = k
    os.makedirs(OUT, exist_ok=True)
    j = {'screen': aid, 'calls': calls, 'classes': classes}
    with open(os.path.join(OUT, f'{aid}.json'), 'w', encoding='utf-8') as f:
        json.dump(j, f, ensure_ascii=False, indent=1)
    return j


if __name__ == '__main__':
    ids = sys.argv[1:] or []
    if ids == ['--all']:
        ids = sorted(os.listdir(SCR))
    for i in ids:
        j = run(i)
        if j is None:
            print(i, 'Fact Pack 없음')
        else:
            k = {}
            for c in j['calls']:
                k[c['trigger']['kind']] = k.get(c['trigger']['kind'], 0) + 1
            print(i, 'calls', len(j['calls']), k, 'classes', len(j['classes']), 'pack', sum(1 for c in j['classes'].values() if c.get('in_pack')))
