# -*- coding: utf-8 -*-
"""AS-IS 시트 → 탭 전환 경로(2026-11-17 SCP0104 SOP 탭 런처 자동 전환).

AS-IS 시트(스프레드 시트)가 TabPage 안 그리드에 있으면 런처가 조회 전에 그 탭을 골라야 한다. 경로는 정적 사실로 도출한다.
  그리드  = actions.csv GRID_INIT 'AddSheet(<그리드>, <시트>, ...)' (시트 순번 = 그 그리드의 AddSheet 순서)
  탭 경로 = controls.csv 부모 사슬(그리드 → TabPage → TabControl …) · 페이지 순번 = 같은 TabControl 아래 TabPage 의 선언 줄 순서
  화면별 조건 = Doc/verify/<ID>/sheet_nav.json sheets.<시트>.asis.set (탭 밖에서 시트를 정하는 라디오·콤보 · 원문 근거 src 필수)
최근 런처 덤프(Doc/asislive/<ID>/run_*/controls.json)가 있으면 TabPage 순서를 실측과 대조해 결과에 남긴다(다르면 실측 순서를 쓴다).

  python tools/AsisLive/asis_live_sheet_nav.py <ID> [시트 ...]     (시트 생략 = sheet_data_cond.json·sheet_nav.json 의 시트 전부 · DB·런처 접속 없음)
런처 연결: asis_live_scen_run.py --division sheet:<시트> → steps() 결과를 조회 전에 host act tab=·set 으로 실행.
"""
import csv, glob, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
sys.path.insert(0, P('tools', 'Harness', 'verify'))
import asis_variant as AV  # noqa: E402

csv.field_size_limit(10 ** 8)
nz = lambda t: re.sub(r'[^a-z0-9]', '', str(t or '').lower())
TABCTL = re.compile(r'(TabControl|XtraTabControl)$')
TABPAGE = re.compile(r'(TabPage|XtraTabPage)$')


def _csv(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as f: return list(csv.DictReader(f))
    except OSError: return []


def _json(p, d=None):
    try:
        with open(p, encoding='utf-8-sig') as f: return json.load(f)
    except (OSError, ValueError): return d


def sheet_entries(mid):
    """[{sheet, grid, index, src, class}] — actions.csv GRID_INIT AddSheet 전부(시트 순번 = 그 파일·그리드의 AddSheet 순서)"""
    sdir = P('Doc', 'asisfacts', 'screens', mid); out, order = [], {}
    for r in _csv(os.path.join(sdir, 'actions.csv')):
        if r.get('kind') != 'GRID_INIT' or not re.search(r'AddSheet$', r.get('target') or ''): continue
        if not AV.is_main(r, sdir): continue
        m = re.match(r'\s*\(\s*(\w+)\s*,\s*([^,]+?)\s*,', r.get('value') or '')
        if not m: continue
        grid, sh = m.group(1), m.group(2).strip().strip('"').split('.')[-1]
        key = (r.get('file'), grid); order.setdefault(key, []).append(sh)
        out.append({'sheet': sh, 'grid': grid, 'index': len(order[key]) - 1, 'src': '%s:%s' % (os.path.basename(r.get('file') or ''), r.get('line')), 'class': r.get('class') or ''})
    return out


def sheet_grids(mid):
    """{키: (그리드, 시트 순번, 근거, 클래스)} — 키 = nz(시트) · nz(그리드/시트). 같은 시트 이름이 여러 그리드에 있으면 이름 키는 본체 클래스 첫 그리드,
    다른 그리드는 '그리드/시트' 로 지정한다(SCP0055 spdMain·spdGap 둘 다 shtMain)"""
    mc = main_class(mid); out = {}
    for e in sorted(sheet_entries(mid), key=lambda e: (e['class'] != mc,)):
        v = (e['grid'], e['index'], e['src'], e['class'])
        out.setdefault(nz(e['sheet']), v); out.setdefault(nz(e['grid'] + '/' + e['sheet']), v)
    return out


def main_class(mid):
    """화면 본체 클래스 = files.csv 의 csproj 폴더 이름과 같은 .cs 파일 이름(예 SCP0104_CAPA_Line_Assign) · 없으면 ''"""
    for r in _csv(P('Doc', 'asisfacts', 'screens', mid, 'files.csv')):
        if AV._v(r) == 'legacy' or not r.get('project'): continue
        folder = os.path.basename(os.path.dirname(r['project'].replace(chr(92), '/')))
        if os.path.basename(r['file'].replace(chr(92), '/')) in (folder + '.cs', folder + '.Designer.cs'): return folder
    return ''


def is_popup(e, mc):
    """본체 클래스가 아니고 본체 파일(<본체>.cs)에도 없는 클래스의 시트 = 팝업 시트(SCP0104_CAPA_Line) · 본체 파일 안 보조 클래스(SCP0092 WeeklySheet)는 본체"""
    if not mc or not e.get('class') or e['class'] == mc: return False
    return (e.get('src') or '').split(':')[0] != mc + '.cs'


def live_chain(mid, grid):
    """정적 사실에 없는 그리드(런타임 생성 · SCP0092 WeeklySheet) — 최근 런처 덤프 controls.json 경로로 탭 사슬 · 없으면 []"""
    for d in sorted(glob.glob(P('Doc', 'asislive', mid, 'run_*', 'controls.json')), reverse=True):
        cs = (_json(d, {}) or {}).get('controls') or []
        g = next((c for c in cs if c.get('name') == grid and re.search(r'Spread', c.get('type') or '')), None)
        if not g: continue
        byp = {c.get('path'): c for c in cs}; segs = (g.get('path') or '').strip('/').split('/'); chain = []
        for i in range(len(segs)):
            pth = '/' + '/'.join(segs[:i + 1]); c = byp.get(pth)
            if c and TABPAGE.search(c.get('type') or ''):
                base = pth.rsplit('/', 1)[0]; ctl = byp.get(base) or {}
                pages = [x.get('name') for x in cs if TABPAGE.search(x.get('type') or '') and (x.get('path') or '').rsplit('/', 1)[0] == base]
                chain.append({'control': ctl.get('name') or base.split('/')[-1], 'index': pages.index(c.get('name')), 'page': c.get('name'), 'pages': pages, 'src': os.path.relpath(d, ROOT), 'live': os.path.relpath(d, ROOT)})
        return chain
    return []


def tab_chain(mid, grid, cls=''):
    """그리드에서 위로 올라가며 [(TabControl, 페이지 순번, TabPage, 근거)] (바깥 탭부터) · 탭 밖 그리드면 [] · cls = AddSheet 가 있는 클래스(같은 이름 그리드가 팝업 클래스에도 있음)"""
    sdir = P('Doc', 'asisfacts', 'screens', mid)
    rows = [r for r in _csv(os.path.join(sdir, 'controls.csv')) if AV.is_main(r, sdir) and (not cls or r.get('class') == cls)]
    files = sorted({r['file'] for r in rows if r.get('name') == grid}, key=lambda f: (os.path.basename(f).replace('.Designer.cs', '') != (next((r['class'] for r in rows if r['file'] == f), '')), f))
    for f in files:                                    # 화면 클래스 이름과 같은 Designer 파일 먼저
        fr = [r for r in rows if r['file'] == f]; by = {r['name']: r for r in fr}
        chain, cur, seen = [], by.get(grid), set()
        while cur and cur.get('parent') and cur['parent'] not in ('this', '') and cur['name'] not in seen:
            seen.add(cur['name']); par = by.get(cur['parent']) or by.get(re.sub(r'\.Panel\d+$', '', cur['parent']))   # SplitContainer 패널(splitContainer1.Panel2 · SCM0005)
            if par is None: break
            if TABPAGE.search(par.get('type') or ''):
                ctl = by.get(par.get('parent'))
                if ctl is not None and TABCTL.search(ctl.get('type') or ''):
                    pages = sorted((r for r in fr if r.get('parent') == ctl['name'] and TABPAGE.search(r.get('type') or '')), key=lambda r: int(r.get('line') or 0))
                    ix = [p['name'] for p in pages].index(par['name'])
                    chain.append({'control': ctl['name'], 'index': ix, 'page': par['name'], 'pages': [p['name'] for p in pages], 'src': '%s:%s' % (os.path.basename(f), par.get('line'))})
            cur = par
        return list(reversed(chain))
    return []


def _live_pages(mid, ctl):
    """최근 런처 덤프 controls.json 의 TabControl 아래 TabPage 순서(실측) · 없으면 (None, None)"""
    for d in sorted(glob.glob(P('Doc', 'asislive', mid, 'run_*', 'controls.json')), reverse=True):
        cs = (_json(d, {}) or {}).get('controls') or []
        base = next((c.get('path') for c in cs if c.get('name') == ctl and TABCTL.search(c.get('type') or '')), None)
        if base: return [c.get('name') for c in cs if TABPAGE.search(c.get('type') or '') and (c.get('path') or '').rsplit('/', 1)[0] == base], os.path.relpath(d, ROOT)
    return None, None


def resolve(mid, sheet):
    """{'sheet','grid','sheet_index','tabs':[...],'set':[...],'note'} — 런처가 조회 전에 할 일"""
    mid = mid.upper(); g = sheet_grids(mid).get(nz(sheet))
    nav = ((_json(P('Doc', 'verify', mid, 'sheet_nav.json'), {}) or {}).get('sheets') or {})
    nk = next((k for k in nav if nz(k) == nz(sheet)), None); asis = (nav.get(nk) or {}).get('asis') or {}
    out = {'sheet': sheet, 'grid': '', 'sheet_index': None, 'tabs': [], 'set': asis.get('set') or [], 'set_src': asis.get('src') or '', 'note': ''}
    if not g:
        out['note'] = 'AS-IS AddSheet 에 시트 %s 없음(actions.csv GRID_INIT) — 탭 경로 미도출' % sheet; return out
    out['grid'], out['sheet_index'], out['grid_src'], out['class'] = g
    mc = main_class(mid)
    if is_popup({'class': g[3], 'src': g[2]}, mc):
        out['note'] = '팝업 시트(클래스 %s · 본체 %s) — 탭 전환 대상 아님, 팝업을 여는 동작으로 감' % (g[3], mc); return out
    out['tabs'] = tab_chain(mid, g[0], g[3]) or live_chain(mid, g[0])
    for t in out['tabs']:
        live, src = _live_pages(mid, t['control'])
        if live:
            t['live'] = src
            if t['page'] in live and live.index(t['page']) != t['index']:
                t['static_index'] = t['index']; t['index'] = live.index(t['page']); t['note'] = '정적 순번 %d ≠ 실측 %d → 실측' % (t['static_index'], t['index'])
    return out


def default_tab_index(mid, ctl):
    """TabControl 의 처음 선택 순번 = props.csv SelectedIndex(없으면 0)"""
    sdir = P('Doc', 'asisfacts', 'screens', mid)
    for r in _csv(os.path.join(sdir, 'props.csv')):
        if r.get('target') == ctl and r.get('prop') in ('SelectedIndex', 'SelectedTabPageIndex') and AV.is_main(r, sdir):
            try: return int(str(r.get('value')).strip())
            except ValueError: pass
    return 0


def tab_sheets(mid):
    """화면을 열었을 때 보이지 않는 탭(TabPage 순번 ≠ 처음 선택 순번) 안의 본체 시트 — 배치가 시트별로 한 번 더 실행할 대상.
    이름이 본체에서 하나뿐이면 시트 이름, 여러 그리드가 같은 이름을 쓰면 '그리드/시트'"""
    mid = mid.upper(); out = []
    mc = main_class(mid); ents = [e for e in sheet_entries(mid) if not is_popup(e, mc)]
    cnt = {}
    for e in ents: cnt[nz(e['sheet'])] = cnt.get(nz(e['sheet']), 0) + 1
    for e in ents:
        tabs = tab_chain(mid, e['grid'], e['class']) or live_chain(mid, e['grid'])
        if any(t['index'] != default_tab_index(mid, t['control']) for t in tabs):
            nm = e['sheet'] if cnt[nz(e['sheet'])] == 1 else '%s/%s' % (e['grid'], e['sheet'])
            if nm not in out: out.append(nm)
    return out


def steps(mid, sheet):
    """apply_data_cond 단계 형식 [{act:{tab,index,wait}} | {name,prop,value,...}] — 탭(바깥부터) → 화면별 조건"""
    r = resolve(mid, sheet)
    st = [{'act': {'tab': t['control'], 'index': t['index'], 'wait': 3}, 'wait': 2, 'why': 'sheet %s 탭 %s(%s)' % (sheet, t['page'], t['src'])} for t in r['tabs']]
    st += [dict(s, why='sheet %s 조건(%s)' % (sheet, r['set_src'])) for s in r['set']]
    return st, r


def main(argv):
    if not argv or argv[0].startswith('-'): print(__doc__); return 2
    mid = argv[0].upper(); sheets = argv[1:]
    if not sheets:
        a = list(((_json(P('Doc', 'verify', mid, 'sheet_data_cond.json'), {}) or {}).get('sheets') or {}).keys())
        b = list(((_json(P('Doc', 'verify', mid, 'sheet_nav.json'), {}) or {}).get('sheets') or {}).keys())
        sheets = a + [x for x in b if x not in a]
    bad = 0
    for s in sheets:
        st, r = steps(mid, s)
        tabs = ' → '.join('%s[%d]=%s%s' % (t['control'], t['index'], t['page'], ' (실측 순서 일치 %s)' % t['live'] if t.get('live') and not t.get('note') else (' ' + t['note']) if t.get('note') else ' (실측 덤프 없음)') for t in r['tabs']) or '탭 없음'
        print('%-20s 그리드 %s 시트 %s · %s · 조건 %s %s' % (s, r['grid'] or '-', r['sheet_index'], tabs, ', '.join('%s=%s' % (x.get('name') or 'act', x.get('value', x.get('index', x.get('check')))) for x in r['set']) or '없음', r['note']))
        bad += not r['grid']
    return 0 if not bad else 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
