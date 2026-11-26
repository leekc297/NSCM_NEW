import os
p = r'C:\Projects\NSCM\tools\Harness\verify\facts_sortrules.py'
b = open(p, 'rb').read().decode('utf-8'); crlf = '\r\n' in b; s = b.replace('\r\n', '\n')
a1 = "def run(screen):\n"
assert s.count(a1) == 1
func = r'''# T563(2026-11-25 SCP0005 FACT-9f114f46 1행): 화면 본체가 부르지 않는 팝업 클래스 SP(SCP0005_DistributionRoutePopup.cs:171 SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID)의
#   ORDER BY 가 소속 표시 없이 화면 정렬처럼 적혔다(endpoints.csv class 칸 미사용). 행은 그대로 두고(T529 팝업 SP 추가와 같은 방향) note 에 팝업 소속과 여는 위치를 적는다.
#   팝업 = 화면 .cs 원문에서 다른 클래스가 new 로 만드는 클래스(화면 본체는 프레임워크가 열어 new 대상 아님). SP 를 부르는 클래스가 전부 팝업일 때만 표시
def popup_owner(screen, sd=None, src_root=None):
    """{SP 대문자: '팝업 <클래스> 소속(<연 곳 파일:행> new <클래스>() → <SP 호출 파일:행>)'}"""
    sd = sd or os.path.join(SCR, screen)
    roots = [src_root] if src_root else [os.path.join(ROOT, 'GSCM'), os.path.join(ROOT, 'GSCM_20260512')]
    news = {}
    for f in rdcsv(os.path.join(sd, 'files.csv')):
        rel = f.get('file', '')
        if not rel.endswith('.cs') or rel.endswith('.Designer.cs'): continue
        pth = next((os.path.join(r, rel) for r in roots if os.path.exists(os.path.join(r, rel))), '')
        if not pth: continue
        txt = cs_strip_comments(open(pth, encoding='utf-8', errors='ignore').read())
        own = set(re.findall(r'\bclass\s+(\w+)', txt))
        for ln, line in enumerate(txt.split('\n'), 1):
            for c in re.findall(r'\bnew\s+(?:[\w]+\.)*(\w+)\s*\(', line):
                if c not in own: news.setdefault(c, f"{os.path.basename(rel)}:{ln}")
    calls = {}
    for r in rdcsv(os.path.join(sd, 'endpoints.csv')):
        m = re.match(r'^SP\s+(\S+)', r.get('sp_or_sql', '') or '')
        if m and r.get('class'): calls.setdefault(m.group(1).split('.')[-1].upper(), []).append((r['class'], f"{os.path.basename(r.get('file', ''))}:{r.get('line', '')}"))
    for r in rdcsv(os.path.join(sd, 'actions.csv')):
        if r.get('kind') == 'ENDPOINT' and r.get('endpoint') and r.get('class'):
            calls.setdefault(r['endpoint'].split('.')[-1].upper(), []).append((r['class'], f"{os.path.basename(r.get('file', ''))}:{r.get('line', '')}"))
    out = {}
    for sp, lst in calls.items():
        cls = {c for c, _ in lst}
        if cls and all(c in news for c in cls):
            c0 = sorted(cls)[0]; at = next(a for c, a in lst if c == c0)
            out[sp] = f"팝업 {c0} 소속({news[c0]} new {c0}() → {at})"
    return out


def _selftest_popup_owner():
    import tempfile, shutil
    d = tempfile.mkdtemp(); sd = os.path.join(d, 'scr'); os.makedirs(os.path.join(d, 'src')); os.makedirs(sd)
    open(os.path.join(d, 'src', 'Main.cs'), 'w', encoding='utf-8').write('class Main {\n void A() {\n  var p = new NS.Pop();\n  // new Ghost();\n }\n}\n')
    open(os.path.join(d, 'src', 'Pop.cs'), 'w', encoding='utf-8').write('class Pop { }\n')
    with open(os.path.join(sd, 'files.csv'), 'w', encoding='utf-8', newline='') as f:
        f.write('file\nMain.cs\nPop.cs\n')
    with open(os.path.join(sd, 'endpoints.csv'), 'w', encoding='utf-8', newline='') as f:
        f.write('file,class,line,sp_or_sql\nMain.cs,Main,9,SP X_GET_MAIN\nPop.cs,Pop,7,SP X_GET_HIST\nMain.cs,Main,12,SP X_GET_BOTH\nPop.cs,Pop,8,SP X_GET_BOTH\nMain.cs,Ghost,3,SP X_GET_GHOST\n')
    try:
        r = popup_owner('X', sd=sd, src_root=os.path.join(d, 'src'))
    finally:
        shutil.rmtree(d, ignore_errors=True)
    cases = [('T563 팝업 클래스만 부르는 SP = 팝업 소속', r.get('X_GET_HIST', '').startswith('팝업 Pop 소속(Main.cs:3')),
             ('T563 화면 본체 SP 는 표시 없음(변이)', 'X_GET_MAIN' not in r),
             ('T563 본체·팝업 둘 다 부르면 표시 없음(변이)', 'X_GET_BOTH' not in r),
             ('T563 주석 속 new 는 팝업 근거 아님(변이)', 'X_GET_GHOST' not in r)]
    for n, ok in cases: print(('PASS ' if ok else 'FAIL ') + n)
    return 0 if all(ok for _, ok in cases) else 1


'''
s = s.replace(a1, func + a1)
a2 = "    sps += [s for s, _ in popup_sps(screen, sps)]\n    rows = []\n    for sp in sps: rows += sp_rules(sp, screen)\n"
assert s.count(a2) == 1
s = s.replace(a2, r'''    _pop = popup_sps(screen, sps)
    sps += [s for s, _ in _pop]
    owner = popup_owner(screen)  # T563 팝업 소속 표시
    for _s, _ev in _pop:  # T529 로 더한 팝업 SP = 근거 문장에 연 곳이 있다
        owner.setdefault(_s.upper(), f"팝업 소속({_ev})")
    rows = []
    for sp in sps:
        _r = sp_rules(sp, screen)
        if sp.upper() in owner:
            for x in _r: x['note'] = (x.get('note') or '') + ' · ' + owner[sp.upper()] + ' — 화면 본체 조회 아님'
        rows += _r
''')
a3 = "    if a[0] == '--selftest': sys.exit(_selftest_assign())\n"
assert s.count(a3) == 1
s = s.replace(a3, "    if a[0] == '--selftest': sys.exit(_selftest_assign() or _selftest_popup_owner())\n")
open(p + '.s_tmp', 'wb').write((s.replace('\n', '\r\n') if crlf else s).encode('utf-8')); os.replace(p + '.s_tmp', p)
print('ok', crlf)
