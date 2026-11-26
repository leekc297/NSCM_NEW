# -*- coding: utf-8 -*-
"""화면 건수 현황판 생성 (샘플 2026-11-18).

원천 파일만 읽어 Doc/verify/<화면ID>/status.json · status.html 을 만든다. 숫자를 손으로 적지 않는다.
사용: python tools/Docs/screen_status.py SCP0096
"""
import sys, os, re, json, glob, html, collections, datetime

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
RESULTS = ['PASS', 'FAIL', '판정필요', '미검증', '해당없음']


def rel(p):
    return os.path.relpath(p, ROOT).replace('\\', '/')


def mtime(p):
    return datetime.datetime.fromtimestamp(os.path.getmtime(p)).strftime('%Y-%m-%d %H:%M')


def norm_result(v):
    s = str(v or '')
    if s.startswith('미검증'):
        return '미검증'
    return s if s in RESULTS else (s or '빈칸')


def checklist_dir():
    """개선안 20261124012048_SELF_6(R83): CheckList 폴더 = harness.json paths.checklistDir 1곳(verify_if_stale·criteria_build 와 같은 값) · 없으면 Doc/UI_CHECKLIST"""
    try:
        with open(os.path.join(ROOT, 'tools', 'Harness', 'harness.json'), encoding='utf-8-sig') as f:
            hp = (json.load(f) or {}).get('paths')
    except (OSError, ValueError):
        hp = None
    d = (hp.get('checklistDir') if isinstance(hp, dict) else None) or 'Doc/UI_CHECKLIST'
    return os.path.normpath(d if os.path.isabs(d) else os.path.join(ROOT, d))


def latest_checklist(sid):
    best = None
    for p in glob.glob(os.path.join(checklist_dir(), sid + '_*_CheckList_v*.xlsx')):
        m = re.search(r'_v(\d+)\.xlsx$', p)
        if m and (best is None or int(m.group(1)) > best[0]):
            best = (int(m.group(1)), p)
    return best


def read_checklist(sid, sources):
    import openpyxl
    found = latest_checklist(sid)
    if not found:
        return None
    ver, path = found
    sources.append({'file': rel(path), 'time': mtime(path)})
    wb = openpyxl.load_workbook(path, read_only=True)
    rows = list(wb['검증 전체'].iter_rows(values_only=True))[1:]
    if '해당없음' in wb.sheetnames:   # 2026-11-26 make_verify_docs 가 해당없음 행을 별도 시트로 옮김 — 건수는 두 시트 합
        rows += list(wb['해당없음'].iter_rows(values_only=True))[1:]
    totals = collections.Counter(norm_result(r[8]) for r in rows)
    axes = collections.OrderedDict()
    for r in rows:
        ax = r[2] or '분류 없음'
        axes.setdefault(ax, collections.Counter())[norm_result(r[8])] += 1
    order = sorted(axes, key=lambda a: (a == '분류 없음', a))

    def sheet_rows(name):
        if name not in wb.sheetnames:
            return []
        return [[str(r[1] or ''), str(r[5] or ''), str(r[7] or '')]
                for r in list(wb[name].iter_rows(values_only=True))[1:] if r[1]]

    ledger = collections.Counter()
    if '결함 원장 대조' in wb.sheetnames:
        for r in list(wb['결함 원장 대조'].iter_rows(values_only=True))[1:]:
            ledger[norm_result(r[10])] += 1
    unv = collections.Counter()
    if '미검증' in wb.sheetnames:
        for r in list(wb['미검증'].iter_rows(values_only=True))[1:]:
            if r[1]:
                unv['행'] += 1
    return {
        'version': ver, 'total': len(rows),
        'totals': {k: totals.get(k, 0) for k in RESULTS},
        'axes': [dict(axis=a, total=sum(axes[a].values()), **{k: axes[a].get(k, 0) for k in RESULTS}) for a in order],
        'action': sheet_rows('조치 필요'),
        'review': sheet_rows('판정 필요'),
        'ledger': dict(ledger),
        'unverified_sheet_rows': unv['행'],
    }


def read_fe_mapping(sid, sources):
    reg = os.path.join(ROOT, 'Doc', 'gen', sid, 'register.json')
    if not os.path.exists(reg):
        return None
    j = json.load(open(reg, encoding='utf-8'))
    p = os.path.join(ROOT, 'nscm-fe', 'features', j.get('feature', ''), 'src', 'pages', j.get('pageDir', ''), '__asis-mapping__.md')
    if not os.path.exists(p):
        return None
    sources.append({'file': rel(p), 'time': mtime(p)})
    c = collections.Counter()
    for line in open(p, encoding='utf-8'):
        if not line.startswith('| ') or line.startswith('| ID') or line.startswith('|---'):
            continue
        cells = [x.strip() for x in line.strip().strip('|').split('|')]
        if len(cells) >= 5 and re.match(r'^[A-Z]', cells[0]):
            c[cells[-1] or '빈칸'] += 1
    return {'total': sum(c.values()), 'by_state': dict(c)}


def read_asis_actions(sid, sources):
    p = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid, '__asis-actions__.md')
    if not os.path.exists(p):
        return None
    sources.append({'file': rel(p), 'time': mtime(p)})
    total = blank = meaning = 0
    states = collections.Counter()
    for line in open(p, encoding='utf-8'):
        if not line.startswith('| AC-'):
            continue
        cells = [x.strip() for x in line.strip().strip('|').split('|')]
        total += 1
        st = cells[9] if len(cells) > 9 else ''
        states[st or '빈칸'] += 1
        if not st:
            blank += 1
        if len(cells) > 7 and '의미 확인 필요' in cells[7]:
            meaning += 1
    return {'total': total, 'blank_state': blank, 'meaning_needed': meaning, 'by_state': dict(states)}


def read_json(path, sources):
    if not os.path.exists(path):
        return None
    sources.append({'file': rel(path), 'time': mtime(path)})
    return json.load(open(path, encoding='utf-8'))


def collect(sid):
    sources = []
    vdir = os.path.join(ROOT, 'Doc', 'verify', sid)
    data = {
        'screen': sid,
        'made': datetime.datetime.now().strftime('%Y-%m-%d %H:%M'),
        'checklist': read_checklist(sid, sources),
        'fe_mapping': read_fe_mapping(sid, sources),
        'asis_actions': read_asis_actions(sid, sources),
        'counts': read_json(os.path.join(vdir, 'checklist_counts.json'), sources),
        'ledger': read_json(os.path.join(vdir, 'work_ledger_summary.json'), sources),
    }
    # 2026-11-19 사용자: 미검증 해소 보완 뒤 CheckList 재수행 전이면 보완 전 CheckList 건수를 보여 주지 않는다(재수행 뒤 건수만)
    try:
        sys.path.insert(0, os.path.join(ROOT, 'tools', 'Harness', 'verify'))
        import pending_recheck
        data['pending_recheck'] = pending_recheck.pending(sid)
    except Exception:
        data['pending_recheck'] = None
    if data['pending_recheck']:
        data['checklist'] = None; data['counts'] = None; data['ledger'] = None
        sources[:] = [s for s in sources if not re.search(r'CheckList|checklist_counts|work_ledger_summary', s['file'])]
    reg = os.path.join(ROOT, 'Doc', 'gen', sid, 'register.json')
    data['name'] = json.load(open(reg, encoding='utf-8')).get('screenName', '') if os.path.exists(reg) else ''
    data['sources'] = sources
    return data


CSS = """
:root{--fg:#1f2328;--mut:#6e7781;--line:#e1e4e8;--bg:#fff;--soft:#f6f8fa;
--pass:#1a7f37;--fail:#cf222e;--rev:#b08800;--unv:#bc4c00;--na:#afb8c1}
@media (prefers-color-scheme:dark){:root{--fg:#e6edf3;--mut:#8d96a0;--line:#30363d;--bg:#0d1117;--soft:#161b22;
--pass:#3fb950;--fail:#f85149;--rev:#d29922;--unv:#db6d28;--na:#484f58}}
:root[data-theme=light]{--fg:#1f2328;--mut:#6e7781;--line:#e1e4e8;--bg:#fff;--soft:#f6f8fa;
--pass:#1a7f37;--fail:#cf222e;--rev:#b08800;--unv:#bc4c00;--na:#afb8c1}
:root[data-theme=dark]{--fg:#e6edf3;--mut:#8d96a0;--line:#30363d;--bg:#0d1117;--soft:#161b22;
--pass:#3fb950;--fail:#f85149;--rev:#d29922;--unv:#db6d28;--na:#484f58}
*{box-sizing:border-box}
body{margin:0;padding:14px 16px;background:var(--bg);color:var(--fg);font:13px/1.5 'Malgun Gothic',system-ui,sans-serif;max-width:760px}
.hd{display:flex;align-items:baseline;gap:8px;margin-bottom:10px}.hd b{font-size:15px}.hd span{color:var(--mut);font-size:12px}
.kpi{display:flex;border:1px solid var(--line);border-radius:6px;overflow:hidden}
.kpi div{flex:1;padding:6px 10px;border-left:1px solid var(--line)}.kpi div:first-child{border-left:0}
.kpi i{display:block;font-style:normal;color:var(--mut);font-size:11px}.kpi em{font-style:normal;font-size:18px;font-weight:600}
.kpi .FAIL em{color:var(--fail)}.kpi .판정필요 em{color:var(--rev)}.kpi .미검증 em{color:var(--unv)}.kpi .PASS em{color:var(--pass)}
table{border-collapse:collapse;width:100%;margin-top:12px}
th,td{padding:4px 8px;border-bottom:1px solid var(--line);text-align:right;font-variant-numeric:tabular-nums;white-space:nowrap}
th{color:var(--mut);font-weight:400;font-size:12px}th:first-child,td:first-child{text-align:left}
td.bar{width:34%;padding-left:12px}
.bar div{display:flex;height:8px;border-radius:4px;overflow:hidden;background:var(--soft)}
.bar span{height:100%}
.c-PASS{background:var(--pass)}.c-FAIL{background:var(--fail)}.c-판정필요{background:var(--rev)}.c-미검증{background:var(--unv)}.c-해당없음{background:var(--na)}
td.FAIL{color:var(--fail);font-weight:600}td.판정필요{color:var(--rev)}td.미검증{color:var(--unv)}
tr.sum td{font-weight:600;border-bottom:0}
h3{font-size:13px;margin:16px 0 4px}
ul{margin:0;padding-left:18px}li{margin:1px 0}li code{color:var(--mut);font-size:12px}
.line{margin-top:12px;color:var(--fg)}.line b{font-weight:600}.warn{color:var(--unv)}
.src{margin-top:14px;color:var(--mut);font-size:11px}
"""


def e(x):
    return html.escape(str(x))


def fmt(n):
    return f'{n:,}'


def render(d):
    cl = d['checklist']
    ver = f'CheckList v{cl["version"]} · ' if cl else ''
    out = ['<!doctype html><html lang="ko"><head><meta charset="utf-8">',
           f'<title>{e(d["screen"])} 건수 현황</title><style>{CSS}</style></head><body>',
           f'<div class="hd"><b>{e(d["screen"])} {e(d["name"])}</b><span>{ver}생성 {e(d["made"])}</span></div>']
    pr = d.get('pending_recheck')
    if pr:
        out.append(f'<div class="line"><b class="warn">CheckList 재수행 전</b>, 미검증 해소 보완 {e(pr["fixed_at"])} 뒤 CheckList 를 다시 수행하지 않음. '
                   f'보완 전 건수(원장 {e(pr["ledger_at"])})는 표시하지 않고, CheckList 재수행 뒤 표시함</div>')
    if cl:
        t = cl['totals']
        out.append('<div class="kpi"><div><i>전체</i><em>' + fmt(cl['total']) + '</em></div>' +
                   ''.join(f'<div class="{k}"><i>{k}</i><em>{fmt(t[k])}</em></div>' for k in RESULTS) + '</div>')
        out.append('<table><tr><th>축</th><th>전체</th>' + ''.join(f'<th>{k}</th>' for k in RESULTS) + '<th></th></tr>')
        for a in cl['axes']:
            segs = ''.join(f'<span class="c-{k}" style="width:{a[k] / a["total"] * 100:.1f}%" title="{k} {a[k]}"></span>'
                           for k in RESULTS if a[k])
            out.append(f'<tr><td>{e(a["axis"])}</td><td>{fmt(a["total"])}</td>' +
                       ''.join(f'<td class="{k if a[k] and k in ("FAIL", "판정필요", "미검증") else ""}">{fmt(a[k])}</td>' for k in RESULTS) +
                       f'<td class="bar"><div>{segs}</div></td></tr>')
        out.append(f'<tr class="sum"><td>합계</td><td>{fmt(cl["total"])}</td>' +
                   ''.join(f'<td>{fmt(t[k])}</td>' for k in RESULTS) + '<td></td></tr></table>')

    parts = []
    fm = d['fe_mapping']
    if fm:
        bs = fm['by_state']
        miss = bs.get('미구현', 0) + bs.get('빈칸', 0)
        parts.append(f'FE 대조표 <b>{fmt(fm["total"])}</b>행 (구현 {fmt(bs.get("구현", 0))}, 미구현 <b class="{"warn" if miss else ""}">{fmt(miss)}</b>)')
    aa = d['asis_actions']
    if aa:
        parts.append(f'AS-IS 액션 대조표 <b>{fmt(aa["total"])}</b>행 (상태 빈칸 <b class="{"warn" if aa["blank_state"] else ""}">{fmt(aa["blank_state"])}</b>)')
    if parts:
        out.append('<div class="line">' + ', '.join(parts) + '</div>')

    if cl and cl['action']:
        out.append(f'<h3>조치 필요 {fmt(len(cl["action"]))}건</h3><ul>' +
                   ''.join(f'<li>{e(r[2])} <code>{e(r[1])} {e(r[0])}</code></li>' for r in cl['action']) + '</ul>')
    out.append('<div class="src">출처: ' + ', '.join(e(os.path.basename(s['file'])) + ' ' + e(s['time'][5:]) for s in d['sources']) + '</div>')
    out.append('</body></html>')
    return '\n'.join(out)


def main():
    if len(sys.argv) < 2:
        print('사용: python tools/Docs/screen_status.py <화면ID>')
        return 2
    sid = sys.argv[1].upper()
    d = collect(sid)
    vdir = os.path.join(ROOT, 'Doc', 'verify', sid)
    os.makedirs(vdir, exist_ok=True)
    jp, hp = os.path.join(vdir, 'status.json'), os.path.join(vdir, 'status.html')
    json.dump(d, open(jp, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    open(hp, 'w', encoding='utf-8').write(render(d))
    print(rel(jp))
    print(rel(hp))
    print(f'@@HTML {sid} 건수 현황|{rel(hp)}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
