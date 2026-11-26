# -*- coding: utf-8 -*-
"""SSP 흐름 뷰어 그림(2026-11-23 사용자 요청 '설치한 SKILL 로 인식성 보완').

baoyu-diagram skill 규칙으로 그린 SVG 틀에 생성 시점 데이터를 채운다.
- 색 = CSS 변수(밝은 테마 themes/light.json 값) · 그리는 순서 = 영역 → 선 → 가림 상자 → 상자 → 글자 → 범례
- 상자 뒤 선이 비치지 않게 가림 상자(--mask)를 먼저 깐다 · 글자는 상자 밖으로 넘치지 않게 줄을 나눈다
- 화면에 넣을 때는 13px 안팎 글자(skill 기본 9~12px 은 표 옆에 놓으면 작다) · 한글 글꼴 = Malgun Gothic
그림 4종: overview_map(SSP 전체 지도) · pi_map(PI 프로세스 맵, 슬라이드 좌표 그대로) · timetable(운영 잡 하루 시간표) · matrix(단계 × 엔터티 격자, HTML 표)
md 에는 '<div class="spf-svg">…' 한 줄로 들어간다(ssp_flow.md2html 이 그대로 통과). 단독 파일은 <out>/diagrams/*.svg.
"""
import os, io, re, csv, html, json, collections

THEME = {  # ~/.claude/skills/baoyu-diagram/themes/light.json 과 같은 값(skill 이 없는 PC 에서도 같은 그림이 나오게 사본을 둔다)
    '--bg': '#f8fafc', '--bg-grid': '#e2e8f0', '--mask': '#f8fafc', '--text': '#0f172a', '--text-muted': '#475569', '--arrow': '#64748b',
    '--color-primary-fill': 'rgba(6,182,212,0.12)', '--color-primary-stroke': '#0891b2', '--color-secondary-fill': 'rgba(5,150,105,0.12)', '--color-secondary-stroke': '#059669',
    '--color-tertiary-fill': 'rgba(124,58,237,0.12)', '--color-tertiary-stroke': '#7c3aed', '--color-accent-fill': 'rgba(217,119,6,0.12)', '--color-accent-stroke': '#d97706',
    '--color-alert-fill': 'rgba(225,29,72,0.12)', '--color-alert-stroke': '#e11d48', '--color-connector-fill': 'rgba(234,88,12,0.12)', '--color-connector-stroke': '#ea580c',
    '--color-neutral-fill': 'rgba(100,116,139,0.12)', '--color-neutral-stroke': '#64748b', '--color-highlight-fill': 'rgba(59,130,246,0.12)', '--color-highlight-stroke': '#3b82f6'}
_SKILL_THEME = os.path.join(os.path.expanduser('~'), '.claude', 'skills', 'baoyu-diagram', 'themes', 'light.json')
try:
    THEME.update({k: v for k, v in json.load(io.open(_SKILL_THEME, encoding='utf-8')).items() if k.startswith('--')})
except Exception:
    pass
FONT = "'Malgun Gothic','Segoe UI','Noto Sans KR',sans-serif"
MERMAID = {}  # 그림 이름 → Mermaid 본(.drawio 변환 원본)
esc = lambda s: html.escape(str(s), quote=True)


def tw(s, fs):
    """글자 폭 어림(한글·전각 = 글자 크기, 영문·숫자 = 0.56배)."""
    return sum(fs * (1.0 if ord(c) > 0x2E7F else (0.34 if c in ' .,:;|/()' else 0.58)) for c in str(s))


def fit(s, fs, width, max_lines=2):
    """폭에 맞춰 줄 나눔. ' / ' · 공백 · '_' 에서 먼저 나누고 그래도 넘치면 글자 단위. 줄 수를 넘으면 끝을 … 으로."""
    s = str(s).strip(); out = []
    if not s: return out
    toks = re.split(r'( / |\s+|(?<=_))', s); cur = ''
    for t in toks:
        if t is None or t == '': continue
        if tw(cur + t, fs) <= width: cur += t; continue
        if cur.strip(): out.append(cur.strip()); cur = ''
        t = t.strip() if t.strip() in ('/', '') else t.lstrip()
        while tw(t, fs) > width:
            n = len(t)
            while n > 1 and tw(t[:n], fs) > width: n -= 1
            out.append(t[:n]); t = t[n:]
        cur = t
    if cur.strip(): out.append(cur.strip())
    out = [x for x in out if x and x != '/']
    if len(out) > max_lines:
        out = out[:max_lines]; last = out[-1]
        while last and tw(last + '…', fs) > width: last = last[:-1]
        out[-1] = last + '…'
    return out


class G:
    """그림 1장. 층(영역, 선, 상자, 글자, 범례)을 따로 모았다가 skill 의 그리는 순서로 합친다."""
    def __init__(self, w, h, name):
        self.w, self.h, self.name = w, h, name
        self.region, self.line, self.box, self.top = [], [], [], []

    def rect(self, x, y, w, h, color='neutral', key=None, title=None, rx=6, sw=1.5, cls=''):
        k = f' data-k="{esc(key)}"' if key else ''; t = f'<title>{esc(title)}</title>' if title else ''
        self.box.append(f'<g class="bx {cls}{" lk" if key else ""}"{k}>{t}<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" height="{h:.1f}" rx="{rx}" fill="var(--mask)"/>'
                        f'<rect class="f" x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" height="{h:.1f}" rx="{rx}" fill="var(--color-{color}-fill)" stroke="var(--color-{color}-stroke)" stroke-width="{sw}"/>')
        return self

    def end(self): self.box.append('</g>'); return self

    def text(self, x, y, s, fs=13, weight=400, fill='text', anchor='middle', layer=None):
        (self.box if layer is None else layer).append(f'<text x="{x:.1f}" y="{y:.1f}" font-size="{fs}" font-weight="{weight}" fill="var(--{fill})" text-anchor="{anchor}">{esc(s)}</text>')
        return self

    def card(self, x, y, w, h, lines, color='neutral', key=None, title=None, cls=''):
        """상자 + 가운데 맞춘 여러 줄. lines = [(글자, 크기, 굵기, 색)]. 폭을 넘는 줄은 fit 으로 나눈다."""
        rows = []
        for s, fs, wt, fill in lines:
            for part in fit(s, fs, w - 14, 2): rows.append((part, fs, wt, fill))
        tot = sum(fs + 4 for _, fs, _, _ in rows); cy = y + (h - tot) / 2
        self.rect(x, y, w, h, color, key, title, cls=cls)
        for s, fs, wt, fill in rows:
            cy += fs + 4; self.text(x + w / 2, cy - 4, s, fs, wt, fill)
        return self.end()

    def band(self, x, y, w, h, label, color='neutral'):
        self.region.append(f'<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" height="{h:.1f}" rx="10" fill="var(--color-{color}-fill)" stroke="var(--color-{color}-stroke)" stroke-width="1" stroke-dasharray="7,4"/>'
                           f'<text x="{x + 12:.1f}" y="{y + 19:.1f}" font-size="13" font-weight="700" fill="var(--color-{color}-stroke)">{esc(label)}</text>')
        return self

    def path(self, pts, color='arrow', arrow=True, dash=False, sw=1.6, cls=''):
        d = 'M' + ' L'.join(f'{x:.1f},{y:.1f}' for x, y in pts)
        st = 'var(--arrow)' if color == 'arrow' else f'var(--color-{color}-stroke)'
        mk = f' marker-end="url(#{self.name}-ar-{color})"' if arrow else ''
        da = ' stroke-dasharray="5,4"' if dash else ''
        self.line.append(f'<path class="ln {cls}" d="{d}" fill="none" stroke="{st}" stroke-width="{sw}"{da}{mk}/>')
        return self

    def svg(self, root_sel=None, legend=None):
        colors = ['arrow', 'primary', 'secondary', 'tertiary', 'accent', 'alert', 'connector', 'neutral', 'highlight']
        mk = ''.join(f'<marker id="{self.name}-ar-{c}" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto"><polygon points="0 0, 10 3.5, 0 7" fill="{"var(--arrow)" if c == "arrow" else f"var(--color-{c}-stroke)"}"/></marker>' for c in colors)
        sel = root_sel or f'svg.bd-{self.name}'
        css = (f'{sel}{{{";".join(f"{k}:{v}" for k, v in THEME.items())}}} '
               f'.bd text{{font-family:{FONT}}} .bd .lk{{cursor:pointer}} .bd .lk:hover .f{{stroke-width:3;stroke:var(--color-highlight-stroke)}}')
        return (f'<svg xmlns="http://www.w3.org/2000/svg" class="bd bd-{self.name}" viewBox="0 0 {self.w:.0f} {self.h:.0f}" width="{self.w:.0f}" height="{self.h:.0f}"><style>{css}</style><defs>{mk}'
                f'<pattern id="{self.name}-grid" width="40" height="40" patternUnits="userSpaceOnUse"><path d="M 40 0 L 0 0 0 40" fill="none" stroke="var(--bg-grid)" stroke-width="0.5"/></pattern></defs>'
                f'<rect width="100%" height="100%" fill="var(--bg)"/><rect width="100%" height="100%" fill="url(#{self.name}-grid)"/>'
                + ''.join(self.region) + ''.join(self.line) + ''.join(self.box) + ''.join(self.top) + '</svg>')


def embed(g, out_dir=None, cap=''):
    """HTML 에 넣는 한 줄(그림 보기 틀 = pre.mermaid 와 같은 도구줄 · mermaid 는 data-processed 가 있으면 다시 그리지 않는다) + 단독 SVG 파일."""
    if out_dir:
        d = os.path.join(out_dir, 'diagrams'); os.makedirs(d, exist_ok=True)
        io.open(os.path.join(d, f'ssp_{g.name}.svg'), 'w', encoding='utf-8', newline='\n').write(g.svg(root_sel=':root').replace(' width="%d" height="%d"' % (g.w, g.h), '', 1))
    c = f'<div class="bd-cap">{cap}</div>' if cap else ''
    return f'<div class="spf-svg"><pre class="mermaid bdsvg" data-processed="true">{g.svg()}</pre>{c}</div>'.replace('\n', ' ')


def legend_html(items):
    return '<span class="bd-leg">' + ''.join(f'<span><i style="background:{THEME[f"--color-{c}-fill"]};border-color:{THEME[f"--color-{c}-stroke"]}"></i>{esc(t)}</span>' for c, t in items) + '</span>'


# ── ① SSP 전체 지도 ────────────────────────────────────────────────────────────
STAGE_KO = {'Master': '기준정보', 'Request': '출하요청', 'Plan': '출하계획', 'Confirm': '출하확정', 'Change': '변경요청', 'ChangeConfirm': '변경확정', 'Analysis': '분석 · 조회', 'Etc': '기타'}


def _inventory(out_dir):
    p = os.path.join(out_dir, 'ssp_batch_inventory.csv')
    if not os.path.exists(p): return []
    return [r for r in csv.DictReader(io.open(p, encoding='utf-8-sig')) if r['category'].startswith('SSP 배치')]


def overview_map(out_dir, stage_screens=None, **_):
    """가로 띠 5줄: 보내는 시스템 → 수신 배치 → SSP 업무 단계(화면) → 송신·후속 배치 → 받는 시스템. stage_screens = {단계: [(화면ID, TO-BE 여부)]}"""
    inv = _inventory(out_dir); grp = collections.defaultdict(list)
    for r in inv: grp[r['group']].append(r)
    def ext(gname):
        c = collections.Counter()
        for r in grp.get(gname, []):
            for s in (r['ext_system'] or '').split(): c[s] += 1
        return c
    stage_screens = stage_screens or {}
    W = 1500; X0 = 150; g = G(W, 792, 'map'); bw = W - X0 - 24
    bands = [(46, 96, '① 보내는 시스템', 'neutral'), (166, 106, '② 수신 배치', 'tertiary'), (296, 228, '③ SSP 업무 단계(화면)', 'primary'), (548, 106, '④ 송신 · 후속 배치', 'tertiary'), (678, 96, '⑤ 받는 시스템', 'neutral')]
    for y, h, lab, col in bands:
        g.region.append(f'<rect x="20" y="{y}" width="{W - 40}" height="{h}" rx="10" fill="var(--color-{col}-fill)" stroke="var(--color-{col}-stroke)" stroke-width="1" stroke-dasharray="7,4"/>')
        for i, part in enumerate(fit(lab, 13.5, 112, 3)): g.text(32, y + 26 + i * 18, part, 13.5, 700, f'color-{col}-stroke', 'start', g.region)
    g.text(24, 28, 'SSP 전체 지도', 18, 700, 'text', 'start', g.top)
    g.text(W - 24, 28, '상자를 누르면 그 단계, 배치 그룹의 상세가 열립니다', 12.5, 400, 'text-muted', 'end', g.top)

    def row(y, h, cells, color):
        """cells = [(줄들, key, title)] 를 띠 폭에 고르게 놓고 가운데 x 목록을 돌려준다."""
        n = len(cells); gap = 18; cw = min(210, (bw - gap * (n - 1)) / max(n, 1)); tot = cw * n + gap * (n - 1); x = X0 + (bw - tot) / 2; xs = []
        for lines, key, title in cells:
            g.card(x, y, cw, h, lines, color, key, title); xs.append((x + cw / 2, x, cw)); x += cw + gap
        return xs
    big = lambda s: (s, 14, 700, 'text'); sub = lambda s: (s, 12, 400, 'text-muted')
    # ① 보내는 시스템
    rc = ext('수신 I/F(외부 → SSP)') + ext('외부 연계 데이터 적재(SCM_DNM·SSP_DNM)')
    src_cells = [([big('SAP ERP'), sub('RFC 수신(SAPRFC_Batch_NERP)')], None, None)] + [([big(s), sub(f'수신 잡 {n}')], None, None) for s, n in sorted(rc.items(), key=lambda kv: (-kv[1], kv[0]))] + [([big('SCP · DM'), sub('계획 · 수요(같은 DB)')], None, None)]
    xs1 = row(64, 62, src_cells, 'neutral')
    # ② 수신 배치
    def gcell(name, short):
        rows = grp.get(name, []); return ([big(short), sub(f'{len(rows)}잡')], 'GRP:' + name, name)
    xs2 = row(190, 66, [gcell('수신 I/F(외부 → SSP)', '수신 I/F'), gcell('외부 연계 데이터 적재(SCM_DNM·SSP_DNM)', '외부 연계 데이터 적재'), gcell('동기화·마스터·운영', '동기화 · 마스터')], 'tertiary')
    # ③ 업무 단계
    main_st = ['Master', 'Request', 'Plan', 'Confirm', 'Change', 'ChangeConfirm']
    def scell(st):
        lst = stage_screens.get(st, []); nt = sum(1 for _, t in lst if t)
        return ([big(STAGE_KO.get(st, st)), (st, 12, 600, 'color-primary-stroke'), sub(f'{len(lst)}화면 · TO-BE {nt}')], f'ST:SSP_PROCESS_FLOW.md:{st}', f'{st} 단계 화면')
    xs3 = row(322, 84, [scell(s) for s in main_st], 'primary')
    for i in range(len(xs3) - 1):
        g.path([(xs3[i][1] + xs3[i][2] + 2, 364), (xs3[i + 1][1] - 3, 364)], 'primary', sw=2.2)
    # 계획 생성 배치(Plan 아래) · 분석 화면
    px = xs3[2]; gp = grp.get('집계·계획 생성(ANL·PLN)', [])
    g.card(px[0] - 150, 440, 300, 62, [big('집계 · 계획 생성 배치'), sub(f'{len(gp)}잡 · 사업부별 Shipment Plan, 통합, FP 목표')], 'tertiary', 'GRP:집계·계획 생성(ANL·PLN)', '집계·계획 생성(ANL·PLN)')
    g.path([(px[0], 440), (px[0], 409)], 'tertiary', sw=2)
    al = stage_screens.get('Analysis', []); ax = xs3[4][0] + (xs3[5][0] - xs3[4][0]) / 2
    g.card(ax - 130, 440, 260, 62, [big(STAGE_KO['Analysis']), ('Analysis', 12, 600, 'color-primary-stroke'), sub(f'{len(al)}화면 · TO-BE {sum(1 for _, t in al if t)}')], 'primary', 'ST:SSP_PROCESS_FLOW.md:Analysis', 'Analysis 단계 화면')
    g.path([(xs3[3][0], 406), (xs3[3][0], 424), (ax - 60, 424), (ax - 60, 438)], 'primary', dash=True)
    # ④ 송신 · 후속 배치
    xs4 = row(568, 66, [gcell('송신 I/F(SSP → 외부)', '송신 I/F'), gcell('알림(메일·SMS)', '알림(메일 · SMS)'), gcell('KPI·BI', 'KPI · BI')], 'tertiary')
    # ⑤ 받는 시스템
    sc_ = ext('송신 I/F(SSP → 외부)')
    dst_cells = [([big('SAP ERP'), sub('출하확정 송신 · 회신')], None, None)] + [([big(s), sub(f'송신 잡 {n}')], None, None) for s, n in sorted(sc_.items(), key=lambda kv: (-kv[1], kv[0]))] + [([big('담당자'), sub('메일 · SMS')], None, None), ([big('DW · BI'), sub('KPI 집계')], None, None)]
    xs5 = row(696, 62, dst_cells, 'neutral')
    # 띠 사이 흐름(띠 가운데 굵은 화살표 1개씩 — 상자마다 선을 그으면 겹친다)
    cx = X0 + bw / 2
    for y1, y2 in [(126, 188), (256, 320), (506, 566), (634, 694)]:
        g.path([(cx, y1 + 2), (cx, y2 - 3)], 'arrow', sw=3)
    mm = ['flowchart TB', '  subgraph B1["1 보내는 시스템"]'] + [f'    A{i}["{c[0][0][0]}<br/>{c[0][1][0]}"]' for i, c in enumerate(src_cells)] + ['  end', '  subgraph B2["2 수신 배치"]']
    for i, nm in enumerate(['수신 I/F(외부 → SSP)', '외부 연계 데이터 적재(SCM_DNM·SSP_DNM)', '동기화·마스터·운영']): mm.append(f'    R{i}["{nm}<br/>{len(grp.get(nm, []))}잡"]')
    mm += ['  end', '  subgraph B3["3 SSP 업무 단계(화면)"]'] + [f'    S_{st}["{STAGE_KO.get(st, st)}<br/>{st} · {len(stage_screens.get(st, []))}화면"]' for st in main_st + ['Analysis']] + [f'    PB["집계 · 계획 생성 배치<br/>{len(gp)}잡"]', '  end', '  subgraph B4["4 송신 · 후속 배치"]']
    for i, nm in enumerate(['송신 I/F(SSP → 외부)', '알림(메일·SMS)', 'KPI·BI']): mm.append(f'    T{i}["{nm}<br/>{len(grp.get(nm, []))}잡"]')
    mm += ['  end', '  subgraph B5["5 받는 시스템"]'] + [f'    Z{i}["{c[0][0][0]}<br/>{c[0][1][0]}"]' for i, c in enumerate(dst_cells)] + ['  end']
    mm += ['  B1 --> B2', '  B2 --> B3', '  B3 --> B4', '  B4 --> B5'] + [f'  S_{a_} --> S_{b_}' for a_, b_ in zip(main_st, main_st[1:])] + ['  PB --> S_Plan', '  S_Confirm -.-> S_Analysis']
    MERMAID['map'] = '\n'.join(mm)
    g.h = 792
    cap = ('<b>읽는 순서</b> 위에서 아래로: 수신 배치가 외부 시스템의 재고, 실적, 계획을 SSP 표에 넣습니다. 화면에서 기준정보, 출하요청, 출하계획, 확정, 변경을 처리하고 계획은 배치가 사업부별로 만듭니다. 송신 배치가 ERP 와 외부 시스템에 보냅니다. '
           f'숫자 = 이번 생성 실측(SSP 배치 {len(inv)}잡, ssp_batch_inventory.csv). ' + legend_html([('primary', '업무 단계(화면)'), ('tertiary', '배치 그룹'), ('neutral', '외부 시스템')]))
    return embed(g, out_dir, cap)


# ── ② PI 프로세스 맵(PPT 1번 슬라이드 좌표 그대로) ──────────────────────────────
LANE_COLOR = ['secondary', 'secondary', 'accent', 'accent', 'primary', 'tertiary', 'alert']


def pi_map(order, lanes, edges, loose, boxes, out_dir=None, has_key=None):
    if not order: return ''
    K = 1 / 6200.0; PAD = 40
    allx = [s['x'] for s in order] + [b[0] for k, b in boxes.items() if k in loose]
    ally = [s['y'] for s in order] + [b[1] for k, b in boxes.items() if k in loose]
    x0 = min(allx); y0 = min(ally)
    X = lambda v: (v - x0) * K + PAD + 16; Y = lambda v: (v - y0) * K + PAD + 44
    maxx = max(s['x'] + s['w'] for s in order); maxy = max([s['y'] + s['h'] for s in order] + [boxes[k][1] + boxes[k][3] for k in loose if k in boxes])
    g = G(X(maxx) + PAD + 16, Y(maxy) + PAD + 10, 'pi')
    lane_idx = {ln: i for i, (_, ln) in enumerate(lanes)}
    by_lane = collections.defaultdict(list)
    for s in order: by_lane[s['lane']].append(s)
    for ln, lst in by_lane.items():
        col = LANE_COLOR[lane_idx.get(ln, 0) % len(LANE_COLOR)]
        bx = min(X(s['x']) for s in lst) - 14; by = min(Y(s['y']) for s in lst) - 30; bx2 = max(X(s['x'] + s['w']) for s in lst) + 14; by2 = max(Y(s['y'] + s['h']) for s in lst) + 14
        g.band(bx, by, bx2 - bx, by2 - by, ln, col)
    # 연결선: 슬라이드의 꺾인 경로 그대로. 화살표는 도착 상자에 가장 가까운 끝에 1개
    def near(pt, k):
        b = boxes.get(k)
        if not b: return 1e18
        cx = min(max(pt[0], b[0]), b[0] + b[2]); cy = min(max(pt[1], b[1]), b[1] + b[3]); return (pt[0] - cx) ** 2 + (pt[1] - cy) ** 2
    drawn = set()
    for e in edges:
        if not e.get('ok') or not e.get('pts'): continue
        best = None
        for i, pl in enumerate(e['pts']):
            if len(pl) < 2: continue
            for rev in (False, True):
                d = near(pl[0] if rev else pl[-1], e['b'])
                if best is None or d < best[0]: best = (d, i, rev)
        for i, pl in enumerate(e['pts']):
            if len(pl) < 2: continue
            pts = [(X(x), Y(y)) for x, y in pl]; arrow = bool(best and best[1] == i and e.get('arrow') == 'end')
            if arrow and best[2]: pts = pts[::-1]
            sig = (tuple((round(a), round(b)) for a, b in pts), arrow)
            if sig in drawn: continue
            drawn.add(sig); g.path(pts, 'arrow', arrow=arrow, sw=1.5, cls=f'e-{e["a"]} e-{e["b"]}')
        if e.get('label') and best is not None:
            pl = e['pts'][best[1]]; mx, my = pl[0] if not best[2] else pl[-1]
            g.text(X(mx) + 10, Y(my) - 6, e['label'], 12, 700, 'color-alert-stroke', 'start', g.top)
    for s in order:
        col = LANE_COLOR[lane_idx.get(s['lane'], 0) % len(LANE_COLOR)]; t = s['texts']
        x, y, w, h = X(s['x']), Y(s['y']), s['w'] * K, s['h'] * K
        key = 'PI:' + s['seq']
        lines = [(f"{s['seq']}. {t[0] if t else ''}", 15, 700, 'text')] + ([(t[1], 12.5, 500, 'text')] if len(t) > 1 else []) + ([(t[2], 12, 400, 'text-muted')] if len(t) > 2 else [])
        g.card(x, y, w, h, lines, col, key if (has_key is None or has_key(key)) else None, f"Seq {s['seq']} · {' / '.join(t)}", cls=f'n-S{s["seq"].replace("-", "_")}')
    for k, lab in loose.items():
        if k not in boxes or not any(e.get('ok') and k in (e['a'], e['b']) for e in edges): continue
        bx, by, bw_, bh = boxes[k]; cx, cy = X(bx + bw_ / 2), Y(by + bh / 2); rx, ry = bw_ * K / 2, bh * K / 2
        pts = f'{cx:.1f},{cy - ry:.1f} {cx + rx:.1f},{cy:.1f} {cx:.1f},{cy + ry:.1f} {cx - rx:.1f},{cy:.1f}'
        g.box.append(f'<g class="bx"><polygon points="{pts}" fill="var(--mask)"/><polygon class="f" points="{pts}" fill="var(--color-accent-fill)" stroke="var(--color-accent-stroke)" stroke-width="1.5"/>')
        for i, part in enumerate(fit(lab, 12, rx * 1.3, 2)): g.text(cx, cy + 4 + (i - 0.5 * (len(fit(lab, 12, rx * 1.3, 2)) - 1)) * 15, part, 12, 700)
        g.box.append('</g>')
    g.text(PAD, 30, 'SSP CUTOFF Process, PI 프로세스 맵', 17, 700, 'text', 'start', g.top)
    g.text(g.w - PAD, 30, f'단계 {len(order)} · 레인 {len(by_lane)} · 배치는 슬라이드와 같음', 12.5, 400, 'text-muted', 'end', g.top)
    cap = '상자 = PI 단계(Seq. 데이터 종류 / Activity / 시스템). 상자를 누르면 그 Seq 의 통합테스트, 화면, 운영 잡, 프로시저, 대상 테이블이 열립니다. 선 = 슬라이드 연결선 경로.'
    return embed(g, out_dir, cap)


# ── ③ 운영 잡 하루 시간표 ──────────────────────────────────────────────────────
GROUP_ORDER = ['수신 I/F(외부 → SSP)', '외부 연계 데이터 적재(SCM_DNM·SSP_DNM)', '집계·계획 생성(ANL·PLN)', '송신 I/F(SSP → 외부)', '알림(메일·SMS)', 'KPI·BI', '동기화·마스터·운영', '기타']
GROUP_COLOR = {'수신 I/F(외부 → SSP)': 'secondary', '외부 연계 데이터 적재(SCM_DNM·SSP_DNM)': 'secondary', '집계·계획 생성(ANL·PLN)': 'primary', '송신 I/F(SSP → 외부)': 'connector', '알림(메일·SMS)': 'alert', 'KPI·BI': 'tertiary', '동기화·마스터·운영': 'neutral', '기타': 'neutral'}


def _hm(t):
    m = re.match(r'\s*(\d{1,2}):(\d{2})', t or ''); return (int(m.group(1)) + int(m.group(2)) / 60.0) if m else None


def timetable(ssp_jobs, out_dir=None, job_group=None, has_key=None):
    """ssp_jobs = [(잡, [{'sheet','cycle','time',…}])], 가로 = 0~24시, 세로 = 잡(그룹별 묶음), 점 = 시각 지정, 띠 = 주기 반복"""
    job_group = job_group or {}
    rows = collections.defaultdict(list)
    for j, sch in ssp_jobs: rows[job_group.get(j) or '기타'].append((j, sch))
    LW = 372; TW = 1008; RH = 22; W = LW + TW + 150; y = 78
    order = [x for x in GROUP_ORDER if x in rows] + [x for x in rows if x not in GROUP_ORDER]
    n = sum(len(rows[x]) for x in order); H = y + n * RH + len(order) * 30 + 40
    g = G(W, H, 'time'); X = lambda hr: LW + hr / 24.0 * TW
    for hr in range(0, 25):
        g.region.append(f'<line x1="{X(hr):.1f}" y1="56" x2="{X(hr):.1f}" y2="{H - 34}" stroke="var(--bg-grid)" stroke-width="{1.4 if hr % 6 == 0 else 0.8}"/>')
        if hr % 2 == 0: g.text(X(hr), 50, f'{hr:02d}시', 12, 600 if hr % 6 == 0 else 400, 'text-muted', 'middle', g.region)
    g.text(20, 30, 'SSP 운영 잡 하루 시간표', 17, 700, 'text', 'start', g.top)
    g.text(W - 20, 30, f'운영 LGCE_SCMPROD 기준 · {n}잡 · 점 = 시각 지정, 띠 = 주기 반복', 12.5, 400, 'text-muted', 'end', g.top)
    for gname in order:
        col = GROUP_COLOR.get(gname, 'neutral'); lst = sorted(rows[gname], key=lambda js: (min([_hm(t) for x in js[1] for t in x['time'].split(',') if _hm(t) is not None] or [99]), js[0]))
        g.region.append(f'<rect x="12" y="{y}" width="{W - 24}" height="{len(lst) * RH + 26}" rx="8" fill="var(--color-{col}-fill)" stroke="var(--color-{col}-stroke)" stroke-width="1" stroke-dasharray="7,4"/>')
        g.text(22, y + 17, f'{gname} · {len(lst)}잡', 13, 700, f'color-{col}-stroke', 'start', g.region)
        y += 24
        for j, sch in lst:
            cy = y + RH / 2; key = 'JOB:' + j; lk = (has_key is None or has_key(key))
            nm = j.replace('JOB.', ''); lab = fit(nm, 12, LW - 40, 1)[0]
            g.box.append(f'<g class="bx{" lk" if lk else ""}"' + (f' data-k="{esc(key)}"' if lk else '') + f'><title>{esc(j)} · ' + esc(' | '.join(f"{x['cycle']} {x['time']}" for x in sch)) + '</title>'
                         f'<rect class="f" x="18" y="{y + 1}" width="{W - 36}" height="{RH - 2}" rx="3" fill="transparent" stroke="transparent" stroke-width="1"/>'
                         f'<text x="{LW - 10}" y="{cy + 4:.1f}" font-size="12" text-anchor="end" fill="var(--text)">{esc(lab)}</text>')
            note = []
            for x in sch:
                t = x['time']
                if x['sheet'] == 'RealTime':
                    m = re.match(r'\s*(\d{1,2}:\d{2})(?::\d{2})?\s*~\s*(\d{1,2}:\d{2})', t); a, b = (_hm(m.group(1)), _hm(m.group(2))) if m else (0, 24)
                    cyc = re.sub(r'^.*?(\d+\s*(?:분|시간)마다).*$', r'\1', t)
                    g.box.append(f'<rect x="{X(a):.1f}" y="{cy - 5:.1f}" width="{max(X(b) - X(a), 4):.1f}" height="10" rx="5" fill="var(--color-{col}-stroke)" opacity="0.45"/>')
                    note.append(cyc + ('' if x['cycle'] == '매일' else f" ({x['cycle']})"))
                else:
                    for tt_ in t.split(','):
                        hm = _hm(tt_)
                        if hm is None: continue
                        g.box.append(f'<circle cx="{X(hm):.1f}" cy="{cy:.1f}" r="5" fill="var(--color-{col}-stroke)"/>')
                    days = x['cycle'].replace(' ', '')
                    ts_ = [q.strip() for q in t.split(',') if q.strip()]
                    note.append((', '.join(ts_) if len(ts_) <= 2 else f'{len(ts_)}회') + ('' if days == '월,화,수,목,금,토,일' else f' ({days})'))
            g.box.append(f'<text x="{LW + TW + 8}" y="{cy + 4:.1f}" font-size="11.5" fill="var(--text-muted)">{esc(fit(" / ".join(note), 11.5, 134, 1)[0] if note else "")}</text></g>')
            y += RH
        y += 8
    g.h = y + 16
    cap = '잡 이름을 누르면 그 잡의 스텝, 프로시저, 읽고 쓰는 표가 열립니다. 오른쪽 글자 = 주기 또는 실행 시각(요일이 매일이 아니면 괄호 안). 정확한 값은 아래 4-1, 4-2 표.' + legend_html([(GROUP_COLOR[x], x) for x in order if x in GROUP_COLOR])
    return embed(g, out_dir, cap)


# ── ④ 격자 표(HTML) — 선이 겹치는 '왼쪽 묶음 ⇒ 가운데 ⇒ 오른쪽 묶음' 그래프를 행 × 열로 ──────────────
def grid(rows, col_groups, get, row_head, cap, row_key=None, row_count=None, count_head='테이블', wlab='W ', rlab='R ', row_text=None):
    """rows = [행 이름] · col_groups = [(묶음 제목, [(열 키, 제목, 작은 제목)])] · get(행, 묶음 번호, 열 키) → (쓰기 목록, 읽기 목록)
    칸 = W n(쓰기) / R n(읽기). 칸에 마우스를 올리면 이름 목록. row_key(행) = 눌렀을 때 여는 탐색 키."""
    two = len(col_groups) > 1 or bool(col_groups and col_groups[0][0])
    h = ['<div class="spf-svg"><div class="tbl-wrap"><table class="mx"><thead>']
    if two:
        h.append(f'<tr><th rowspan="2">{esc(row_head)}</th>' + (f'<th rowspan="2">{esc(count_head)}</th>' if row_count else '') + ''.join(f'<th class="mx-g mx-g{i % 2}" colspan="{len(cols)}">{esc(t)}</th>' for i, (t, cols) in enumerate(col_groups) if cols) + '</tr><tr>')
    else:
        h.append(f'<tr><th>{esc(row_head)}</th>' + (f'<th>{esc(count_head)}</th>' if row_count else ''))
    for i, (_, cols) in enumerate(col_groups):
        for _, t, sm in cols: h.append(f'<th class="mx-g{i % 2}">{esc(t)}' + (f'<small>{esc(sm)}</small>' if sm else '') + '</th>')
    h.append('</tr></thead><tbody>')
    for r in rows:
        k = row_key(r) if row_key else None
        h.append('<tr><th class="mx-e"' + (f' data-k="{esc(k)}"' if k else '') + f'>{row_text(r) if row_text else esc(r)}</th>' + (f'<td class="mx-n">{row_count(r)}</td>' if row_count else ''))
        for i, (_, cols) in enumerate(col_groups):
            for ck, _, _ in cols:
                w, rd_ = get(r, i, ck); w = sorted(w or ()); rd_ = sorted(rd_ or ())
                if not w and not rd_: h.append('<td class="mx-0"></td>'); continue
                tip = ('쓰기: ' + ', '.join(w) if w else '') + (' / ' if w and rd_ else '') + ('읽기: ' + ', '.join(rd_) if rd_ else '')
                if not wlab: tip = ', '.join(w)
                h.append(f'<td class="mx-c" title="{esc(tip)}">' + (f'<b class="mx-w">{wlab}{len(w)}</b>' if w else '') + (f'<b class="mx-r">{rlab}{len(rd_)}</b>' if rd_ else '') + '</td>')
        h.append('</tr>')
    h.append(f'</tbody></table></div><div class="bd-cap">{cap}</div></div>')
    return ''.join(h)


_STCOL = lambda sts: [(s, STAGE_KO.get(s, s), s) for s in sts]
_GSHORT = lambda g: re.sub(r'\(.*?\)', '', g).strip()


def matrix(st_list, ent_tabs, ew, er, st_label=None):
    """행 = 엔터티(테이블 군) · 열 = 업무 단계 · 칸 = W(쓰는 테이블 수) / R(읽기만 하는 테이블 수)."""
    sts = [s for s in st_list if any(k[0] == s for k in list(ew) + list(er))]
    rows = [en for en, ts in sorted(ent_tabs.items(), key=lambda x: -len(x[1]))]
    return grid(rows, [('', _STCOL(sts))], lambda en, i, s: (ew.get((s, en)), er.get((s, en))), '엔터티(테이블 군)',
                'W = 그 단계 화면이 쓰는 테이블 수, R = 읽기만 하는 테이블 수. 칸에 마우스를 올리면 테이블 이름이 보입니다. 엔터티 이름을 누르면 테이블 대응표가 열립니다. 같은 내용의 그래프는 아래 「그래프로 보기」.',
                row_key=lambda en: 'E:' + en, row_count=lambda en: len(ent_tabs[en]))


def context_matrix(st_list, dom_in, dom_out):
    """데이터 흐름 1번(컨텍스트): 행 = 타 도메인, 공통, 인터페이스 묶음, 열 = SSP 업무 단계, R = 그 단계 화면이 읽음, W = 그 단계 화면이 씀."""
    doms = sorted(set(dom_in) | set(dom_out), key=lambda d: -len(set().union(*dom_in.get(d, {}).values(), *dom_out.get(d, {}).values())))
    return grid(doms, [('', _STCOL(st_list))], lambda d, i, s: (dom_out.get(d, {}).get(s), dom_in.get(d, {}).get(s)), 'SSP 밖의 표 묶음',
                'R = 그 단계 화면이 읽는 SSP 밖 테이블 수(입력), W = 그 단계 화면이 쓰는 SSP 밖 테이블 수(출력). 칸에 마우스를 올리면 테이블 이름이 보입니다. 같은 내용의 그래프는 아래 「그래프로 보기」.',
                row_count=lambda d: len(set().union(*dom_in.get(d, {}).values(), *dom_out.get(d, {}).values())))


def batch_matrix(gw, er, write_side='batch'):
    """배치 흐름 2, 3번: 행 = SSP 엔터티, 열 묶음 2개(배치 그룹 | 화면 단계).
    write_side 'batch' = 배치가 쓰고(gw[(그룹, 엔터티)]) 화면이 읽음(er[(엔터티, 단계)]) · 'screen' = 화면이 쓰고(gw[(단계, 엔터티)]) 배치가 읽음(er[(엔터티, 그룹)])."""
    wk = sorted({k[0] for k in gw}); rk = sorted({k[1] for k in er}); ents = sorted({k[1] for k in gw} | {k[0] for k in er}, key=lambda e: -(sum(len(v) for k, v in gw.items() if k[1] == e) + sum(len(v) for k, v in er.items() if k[0] == e)))
    order = ['Master', 'Request', 'Plan', 'Confirm', 'Change', 'ChangeConfirm', 'Analysis', 'Etc']; so = lambda x: sorted(x, key=lambda s: order.index(s) if s in order else 99)
    if write_side == 'batch':
        cg = [('쓰는 배치 그룹(W)', [(g, _GSHORT(g), '') for g in wk]), ('읽는 화면 단계(R)', _STCOL(so(rk)))]
        cap = '왼쪽 열 묶음 W = 배치 그룹이 쓰는 테이블 수, 오른쪽 열 묶음 R = 그 엔터티를 읽는 화면 단계. 한 행을 가로로 읽으면 「어느 배치가 만든 데이터를 어느 단계 화면이 보는지」가 나옵니다. 칸에 마우스를 올리면 테이블 이름. 같은 내용의 그래프는 아래 「그래프로 보기」.'
    else:
        cg = [('쓰는 화면 단계(W)', _STCOL(so(wk))), ('읽는 배치 그룹(R)', [(g, _GSHORT(g), '') for g in rk])]
        cap = '왼쪽 열 묶음 W = 화면 단계가 쓰는 테이블 수, 오른쪽 열 묶음 R = 그 엔터티를 읽는 배치 그룹. 한 행을 가로로 읽으면 「어느 단계 화면이 만든 데이터를 어느 배치가 가져가는지」가 나옵니다. 칸에 마우스를 올리면 테이블 이름. 같은 내용의 그래프는 아래 「그래프로 보기」.'
    return grid(ents, cg, lambda e, i, c: ((gw.get((c, e)), None) if i == 0 else (None, er.get((e, c)))), 'SSP 엔터티', cap, row_key=lambda e: 'E:' + e)


def pair_matrix(pair, order, label, mst_ids=()):
    """프로세스 흐름 2-2(TO-BE 화면 간 흐름): 행 = 쓰는 화면, 열 = 읽기만 하는 화면, 칸 = 매개 테이블 수. pair = {(쓰는 화면, 읽는 화면): 테이블 집합}
    Master 단계 화면은 'Master 화면 n' 한 줄 · 한 칸으로 접는다(그래프와 같은 규칙)."""
    M = 'Master 화면 %d' % len(mst_ids); nd = lambda s: M if s in mst_ids else s
    agg = collections.defaultdict(set)
    for (a, b), ts in pair.items():
        if nd(a) != nd(b): agg[(nd(a), nd(b))] |= set(ts)
    seq = ([M] if mst_ids else []) + [s for s in order if s not in mst_ids]
    rows = [s for s in seq if any(k[0] == s for k in agg)]; cols = [s for s in seq if any(k[1] == s for k in agg)]
    lab = lambda s: (', '.join(mst_ids) if s == M else label(s))
    return grid(rows, [('읽기만 하는 화면', [(c, c, lab(c)[:16] if c != M else '') for c in cols])], lambda r, i, c: (agg.get((r, c)), None), '쓰는 화면',
                '칸의 숫자 = 왼쪽 화면이 쓰고 위쪽 화면이 읽기만 하는 테이블 수. 칸에 마우스를 올리면 테이블 이름이 보입니다. 화면 ID 를 누르면 그 화면의 상세가 열립니다. 쓰는 TO-BE 화면이 4개 이상인 허브 표는 아래 표에 있습니다. 같은 내용의 그래프는 아래 「그래프로 보기」.',
                row_key=lambda s: None if s == M else s, wlab='', row_text=lambda s: esc(s) + '<small>' + esc(lab(s)[:60]) + '</small>')


def iface_table(exts):
    """배치 흐름 5번(외부 인터페이스 맵): 시스템마다 수신 잡 · 송신 잡. exts = {시스템: [수신 잡 집합, 송신 잡 집합]}"""
    def chips(names, cls): return ''.join(f'<span class="if-j {cls}">{esc(n)}</span>' for n in sorted(names)) or '<span class="if-0">없음</span>'
    h = ['<div class="spf-svg"><div class="tbl-wrap"><table class="mx if"><thead><tr><th>외부 시스템</th><th class="mx-g0">수신 잡(외부 → SSP)</th><th class="mx-g1">송신 잡(SSP → 외부)</th></tr></thead><tbody>']
    for e, (rin, sout) in sorted(exts.items(), key=lambda kv: -(len(kv[1][0]) + len(kv[1][1]))):
        h.append(f'<tr><th class="mx-e">{esc(e)}</th><td class="if-c"><b class="mx-r">수신 {len(rin)}</b>{chips(rin, "in")}</td><td class="if-c"><b class="mx-w">송신 {len(sout)}</b>{chips(sout, "out")}</td></tr>')
    h.append('</tbody></table></div><div class="bd-cap">잡 이름을 누르면 그 잡의 상세가 열립니다(이름 앞 ⏱ = SSP 자체 스케줄러 잡). 같은 내용의 그래프는 아래 「그래프로 보기」.</div></div>')
    return ''.join(h)


def fold_next(label='그래프로 보기'):
    """다음에 오는 그림 1개를 접어 두라는 표시(ssp_flow_shell.js 가 details 로 감싼다)."""
    return f'<div class="spf-fold" data-label="{esc(label)}"></div>'


# ── 편집용 파일: .drawio(drawio skill 의 변환 스크립트) · PNG(baoyu-diagram skill 의 main.ts) ──────────────
def _md_mermaid(path, head_rx):
    """md 에서 제목(head_rx)에 맞는 절의 첫 mermaid 블록."""
    if not os.path.exists(path): return None
    t = io.open(path, encoding='utf-8').read()
    m = re.search(r'(?m)^#{2,4} ' + head_rx + r'.*?```mermaid\n(.*?)\n```', t, re.S)
    return m.group(1) if m else None


def export_files(out_dir, log=print):
    """<out>/diagrams 에 .drawio 4종과 PNG 3종을 낸다. 도구(node, bun, skill)가 없거나 변환이 실패하면 건너뛰고 적는다. HTML 생성과 무관."""
    import subprocess, shutil
    d = os.path.join(out_dir, 'diagrams'); os.makedirs(d, exist_ok=True); done = []; skip = []
    home = os.path.expanduser('~'); conv = os.path.join(home, '.claude', 'skills', 'drawio', 'scripts', 'mermaid-to-drawio.js')
    src = {'ssp_map': MERMAID.get('map'),
           'ssp_pi': _md_mermaid(os.path.join(out_dir, 'SSP_REF_PROCESS.md'), r'1\. SSP CUTOFF Process'),
           'ssp_stage_flow': _md_mermaid(os.path.join(out_dir, 'SSP_PROCESS_FLOW.md'), r'2\. 업무 단계 흐름'),
           'ssp_batch_base': _md_mermaid(os.path.join(out_dir, 'SSP_BATCH_FLOW.md'), r'1\. 실행 기반 구조')}
    node = shutil.which('node')
    for name, mm in src.items():
        if not mm: skip.append(f'{name}.drawio(Mermaid 원본 없음)'); continue
        if not node or not os.path.exists(conv): skip.append(f'{name}.drawio(node 또는 drawio skill 없음)'); continue
        f = os.path.join(d, name + '.mmd'); io.open(f, 'w', encoding='utf-8', newline='\n').write(mm + '\n')
        try:
            r = subprocess.run([node, conv, f], capture_output=True, text=True, encoding='utf-8', errors='replace', timeout=180, cwd=d)
            (done if r.returncode == 0 and os.path.exists(os.path.join(d, name + '.drawio')) else skip).append(f'{name}.drawio' + ('' if r.returncode == 0 else f'(변환 실패: {(r.stderr or r.stdout).strip()[:120]})'))
        except Exception as e:
            skip.append(f'{name}.drawio({type(e).__name__})')
        finally:
            if os.path.exists(f): os.remove(f)   # 산출물은 .drawio (skill 규칙: 변환 뒤 .mmd 는 지운다)
    bun = shutil.which('bun'); main_ts = os.path.join(home, '.claude', 'skills', 'baoyu-diagram', 'scripts', 'main.ts')
    for name in ('ssp_map', 'ssp_pi', 'ssp_time'):
        svg = os.path.join(d, name + '.svg')
        if not os.path.exists(svg): continue
        if not bun or not os.path.exists(main_ts): skip.append(f'{name}@2x.png(bun 또는 baoyu-diagram skill 없음)'); continue
        try:
            r = subprocess.run([bun, main_ts, svg, '--theme', 'light', '-o', os.path.join(d, name + '@2x.png')], capture_output=True, text=True, encoding='utf-8', errors='replace', timeout=180)
            (done if r.returncode == 0 else skip).append(f'{name}@2x.png' + ('' if r.returncode == 0 else f'(변환 실패: {(r.stderr or r.stdout).strip()[:120]})'))
        except Exception as e:
            skip.append(f'{name}@2x.png({type(e).__name__})')
    log(f'[ssp_svg] diagrams: 생성 {len(done)}({", ".join(done)})' + (f' · 건너뜀 {len(skip)}({"; ".join(skip)})' if skip else ''))
    return done, skip
