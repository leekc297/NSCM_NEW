# -*- coding: utf-8 -*-
"""
사업부별 Shipment Plan 산출 흐름 (2026-11-11 사용자 제공 자료 반영)
원천(사본 Doc/asisfacts/ref_ssp/src/):
  - (20261111) 사업부별 Shipment Plan 산출 흐름도.pptx  — 전체 흐름 · Operation Group · 사업부별 단계 카드 · FP 자동생성 · 비교 · 확인 필요
  - (20261111) 사업부별 Shipment Plan 산출 로직.xlsx    — 요약 · 산출 흐름(단계 × 사업부) · 단계별 상세 · 기준정보 설정
산출: <SSP_FLOW 폴더>/SSP_SHIPPLAN_FLOW.md · ssp_shipplan_steps.csv(단계별 상세 원문) · ssp_shipplan_crosscheck.csv
원칙: 자료 문구를 그대로 옮긴다. 그림은 슬라이드와 같은 배치의 색 띠 카드(ssp_cards.py · 같은 줄 · 같은 테마 색 · 줄바꿈 화살표)로 그린다(2026-11-11 인식성 보완 — Mermaid 가로 한 줄 나열 폐기). 카드 번호 순서(1 → 2 → …)와 범례 색(진입 조건 · 출하요청 · 확정·Rolling · 재고 · 생산 · 결과·송신)을 그대로 쓴다.
      자료는 TO-BE(ZIOUI1) 본문 기준이므로, AS-IS SP 본문과의 대조는 따로 '교차검증' 절에 적는다(고치지 않음).
"""
import os, io, re, csv, html, time, zipfile, collections
import xml.etree.ElementTree as ET
import ssp_cards as C

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
SRC = os.path.join(ROOT, 'Doc', 'asisfacts', 'ref_ssp', 'src')
PPT = os.path.join(SRC, '(20261111) 사업부별 Shipment Plan 산출 흐름도.pptx')
XLS = os.path.join(SRC, '(20261111) 사업부별 Shipment Plan 산출 로직.xlsx')
NS = {'p': 'http://schemas.openxmlformats.org/presentationml/2006/main', 'a': 'http://schemas.openxmlformats.org/drawingml/2006/main'}
A = '{%s}' % NS['a']
CAT_STYLE = {'진입 조건': ('#eceff1', '#5b6770'), '출하요청': ('#e0f2f4', '#1f7a8c'), '확정 · Rolling': ('#fdf0dc', '#d98c2b'), '재고': ('#e3ecf8', '#3d6ea8'), '생산': ('#e6f3e4', '#4e8f4a'), '결과 · 송신': ('#dde7ea', '#0f3b4a')}


def available(): return os.path.exists(PPT) and os.path.exists(XLS)
def esc(s): return html.escape(str(s), quote=False).replace('"', '&quot;')  # 작은따옴표는 그대로 둔다(조건식 'FN' 등이 그림에서 깨지지 않게)
def cell(s): return str(s or '').replace('|', '/').replace('\r', '').replace('\n', '<br/>')
def mm(s): return re.sub(r'[^A-Za-z0-9_]', '_', str(s))


def theme():
    """테마 색 이름(accent1 …) → #RRGGBB — 슬라이드와 같은 색을 쓰기 위함"""
    z = zipfile.ZipFile(PPT); t = z.read('ppt/theme/theme1.xml').decode('utf-8'); m = re.search(r'<a:clrScheme.*?</a:clrScheme>', t, re.S)
    d = {k: '#' + v for k, v in re.findall(r'<a:(\w+)><a:(?:srgbClr val|sysClr val="\w+" lastClr)="(\w+)"', m.group(0) if m else '')}
    d.update({'bg1': d.get('lt1', '#FFFFFF'), 'bg2': d.get('lt2', '#EEF2F4'), 'tx1': d.get('dk1', '#1B1F23'), 'tx2': d.get('dk2', '#0B3C49')}); return d


def slides():
    """슬라이드별 도형(문단 목록 · 좌표 · 테마 색) · 표"""
    z = zipfile.ZipFile(PPT); out = {}
    names = sorted([n for n in z.namelist() if re.match(r'ppt/slides/slide\d+\.xml$', n)], key=lambda n: int(re.findall(r'\d+', n)[-1]))
    for n in names:
        sno = int(re.findall(r'\d+', n)[-1]); root = ET.fromstring(z.read(n)); shapes = []; tables = []
        for sp in root.iter('{%s}sp' % NS['p']):
            off = sp.find('p:spPr/a:xfrm/a:off', NS); ext = sp.find('p:spPr/a:xfrm/a:ext', NS)
            if off is None or ext is None: continue
            fill = sp.find('p:spPr/a:solidFill/a:schemeClr', NS); line = sp.find('p:spPr/a:ln/a:solidFill/a:schemeClr', NS); g = sp.find('p:spPr/a:prstGeom', NS); nv = sp.find('p:nvSpPr/p:cNvPr', NS)
            paras = [''.join(t.text or '' for t in pp.iter(A + 't')).strip() for pp in sp.iter(A + 'p')]
            shapes.append({'id': nv.get('id') if nv is not None else '', 'x': int(off.get('x')), 'y': int(off.get('y')), 'w': int(ext.get('cx')), 'h': int(ext.get('cy')), 'fill': fill.get('val') if fill is not None else '', 'line': line.get('val') if line is not None else '',
                           'geom': g.get('prst') if g is not None else '', 'paras': [q for q in paras if q]})
        for gf in root.iter('{%s}graphicFrame' % NS['p']):
            rows = []
            for tr in gf.iter(A + 'tr'):
                rows.append([' / '.join(q for q in (''.join(t.text or '' for t in pp.iter(A + 't')).strip() for pp in tc.iter(A + 'p')) if q) for tc in tr.findall(A + 'tc')])
            if rows: tables.append(rows)
        out[sno] = {'shapes': shapes, 'tables': tables}
    return out


def slide_parts(sl, panels=False):
    """제목 · 부제 · 단계 카드(번호 · 제목 · 문구 · 범주) · 범례 · 나머지 글상자. panels=True 면 번호 없는 '색 띠 제목 + 본문' 상자도 묶는다(no = None)"""
    sh = sl['shapes']; texts = [s for s in sh if s['paras']]
    page = [s for s in texts if len(s['paras']) == 1 and re.fullmatch(r'\d+', s['paras'][0]) and s['y'] > 6000000]
    texts = [s for s in texts if s not in page]
    top = sorted([s for s in texts if s['y'] < 1300000 and s['w'] > 8000000], key=lambda s: s['y'])
    title = top[0]['paras'][0] if top else ''; subtitle = ' '.join(top[1]['paras']) if len(top) > 1 else ''
    legend = {}
    for s in sh:  # 범례 = 작은 정사각형(색) + 바로 오른쪽 글상자
        if not s['paras'] and s['fill'] and s['w'] < 250000 and s['h'] < 250000:
            lab = [t for t in texts if 0 < t['x'] - s['x'] < 400000 and abs((t['y'] + t['h'] / 2) - (s['y'] + s['h'] / 2)) < 150000]
            if lab: legend[s['fill']] = lab[0]['paras'][0]
    leg_texts = {id(t) for t in texts if t['paras'][0] in legend.values() and t['y'] > 5800000}
    cards = []; used = set(id(t) for t in top) | leg_texts
    for t in texts:
        if len(t['paras']) != 1 or id(t) in used: continue
        m = re.match(r'^(\d+)\.\s*(.+)$', t['paras'][0])
        if not m and not panels: continue
        bar = [s for s in sh if not s['paras'] and s['fill'] and s['x'] - 20000 <= t['x'] + t['w'] / 2 <= s['x'] + s['w'] + 20000 and abs(s['y'] - t['y']) < 30000 and s['h'] < 600000]
        body = sorted([b for b in texts if b is not t and id(b) not in used and abs(b['x'] - t['x']) < 150000 and 0 < b['y'] - t['y'] < 700000], key=lambda b: b['y'])
        b = body[0] if body else None
        if not m and not (bar and b): continue     # 번호 없는 상자는 색 띠와 본문이 모두 있을 때만
        cards.append({'no': int(m.group(1)) if m else None, 'title': (m.group(2) if m else t['paras'][0]).strip(), 'lines': b['paras'] if b else [], 'fill': bar[0]['fill'] if bar else '', 'x': t['x'], 'y': t['y']})
        used.add(id(t));
        if b: used.add(id(b))
    for c in cards: c['cat'] = legend.get(c['fill'], '')
    rest = [t for t in texts if id(t) not in used]
    pans = sorted([c for c in cards if c['no'] is None], key=lambda c: (round(c['y'] / 300000), c['x'])); cards = [c for c in cards if c['no'] is not None]
    return {'title': title, 'subtitle': subtitle, 'cards': sorted(cards, key=lambda c: c['no']), 'panels': pans, 'legend': legend, 'rest': sorted(rest, key=lambda t: (round(t['y'] / 200000), t['x'])), 'tables': sl['tables']}


def sheets():
    import openpyxl
    wb = openpyxl.load_workbook(XLS, data_only=True); out = {}
    for ws in wb.worksheets:
        out[ws.title] = [['' if c is None else str(c).strip() for c in r] for r in ws.iter_rows(values_only=True) if any(c not in (None, '') for c in r)]
    return out


def card_diagram(M, key, cards, legend, TH=None):
    """슬라이드와 같은 배치(같은 줄 = 같은 높이의 카드)로 색 띠 카드를 놓는다 — 줄이 바뀌면 꺾인 화살표"""
    TH = TH or {}
    ys = sorted({round(c['y'] / 300000) for c in cards}); per = max(sum(1 for c in cards if round(c['y'] / 300000) == y) for y in ys) if cards else 1
    cells = [C.card(f'{c["no"]}. {c["title"]}', c['lines'], TH.get(c['fill'], '#5b6770')) for c in cards]
    leg = C.legend([(n, TH.get(f, '#5b6770')) for f, n in legend.items()]) if legend else ''
    M += [C.wrap(C.rows(cells, per) + leg), '']


def build(out_dir, parse_sp=None, objs=None, mods=None):
    if not available(): return None
    t0 = time.strftime('%Y-%m-%d %H:%M'); S = slides(); X = sheets(); TH = theme(); P = {k: slide_parts(v, panels=k in (3, 6, 10)) for k, v in S.items()}
    M = [f'# 사업부별 Shipment Plan 산출 흐름 — {t0} 생성', '',
         '> 원천(사용자 제공 2026-11-11 · 사본 `Doc/asisfacts/ref_ssp/src/`): `(20261111) 사업부별 Shipment Plan 산출 흐름도.pptx`(슬라이드 10) · `(20261111) 사업부별 Shipment Plan 산출 로직.xlsx`(요약 · 산출 흐름 · 단계별 상세 · 기준정보 설정). 생성 = `tools/Analysis/ssp_shipplan.py`',
         f'> 자료 기준 = {P[1]["rest"][-1]["paras"][0] if P.get(1) and P[1]["rest"] else "ZIOUI1 현재 본문"} — TO-BE(Oracle) 본문에서 정리한 산출 로직이다. 문구는 원문 그대로 옮겼고, AS-IS SP 본문과의 대조는 §7 에 따로 적었다.', '']
    # §1 전체 흐름(슬라이드 2)
    p2 = P[2]; cols = sorted([t for t in p2['rest'] if 1100000 < t['y'] < 1300000], key=lambda t: t['x'])
    M += [f'## 1. {p2["title"]}', '']
    div_ids = {'40': 'DIV_40', '81 계열 · 82': 'DIV_8X', 'Packer': 'DIV_P', '전극': 'DIV_EE'}
    cells = []; n = len(cols); AR = C.AR
    for ci, h in enumerate(cols):
        band = [x for x in S[2]['shapes'] if not x['paras'] and x['fill'].startswith('accent') and abs(x['y'] - h['y']) < 30000 and x['x'] - 20000 <= h['x'] + h['w'] / 2 <= x['x'] + x['w'] + 20000]
        col = TH.get(h['fill'] if h['fill'].startswith('accent') else (band[0]['fill'] if band else ''), '#5b6770')
        mem = sorted([t for t in p2['rest'] if t is not h and abs(t['x'] - h['x']) < 200000 and h['y'] < t['y'] < 4900000], key=lambda t: t['y'])
        if len(mem) == 1: cells.append(C.card(h['paras'][0], mem[0]['paras'], col))
        else: cells.append(C.column(h['paras'][0], ''.join(C.sub(t['paras'][0], t['paras'][1:], key=('DIV:' + div_ids[t['paras'][0]]) if (h['paras'][0].startswith('사업부별') and t['paras'][0] in div_ids) else None) for t in mem), col))
    conf = [i for i, h in enumerate(cols) if h['paras'][0].startswith('확정')]; calc = [i for i, h in enumerate(cols) if h['paras'][0].startswith('사업부별')]
    roll = ''
    if conf and calc and conf[0] > calc[0]:   # Rolling: 확정 → (다음 날) 사업부별 일 산출 로 되돌아가는 점선
        w = f'(100% - {(n - 1) * AR}px) / {n}'; left = f'calc(({w} + {AR}px) * {calc[0]} + ({w}) / 2)'; wid = f'calc(({w} + {AR}px) * {conf[0] - calc[0]})'
        roll = f'<div class="spf-roll"><i style="left:{left};width:{wid}"></i><span style="left:{left};width:{wid}">↺ Rolling — 확정 행은 다음 날 산출에 다시 읽힘</span></div>'
    box = [t for t in p2['rest'] if t['y'] > 4900000]
    M += [C.wrap(C.rows(cells, n, snake=False) + roll + ''.join(C.note(t['paras'][0], t['paras'][1:], TH.get('accent3', '#d98e2b')) for t in box)), '']
    M += ['- 「사업부별 일 산출」의 사업부 상자(40 · 81 계열·82 · Packer · 전극)를 클릭하면 §4 의 해당 사업부 산출 흐름이 열립니다.', '']
    # §2 요약
    M += ['## 2. 요약 — 산출 단위 · Operation Group · 수량 결정 · 실적 차감 · Rolling · 재고 · 생산', '', '| 구분 | 내용 |', '|---|---|']
    for r in X.get('요약', [])[1:]: M.append(f'| {cell(r[0])} | {cell(r[1] if len(r) > 1 else "")} |')
    # §3 단계 × 사업부
    fl = X.get('산출 흐름', [])
    M += ['', '## 3. 단계 × 사업부 비교', '', '### 3-1. 산출 흐름(엑셀 「산출 흐름」 시트)', '', '| ' + ' | '.join(cell(c) for c in fl[0]) + ' |', '|' + '---|' * len(fl[0])]
    for r in fl[1:]: M.append('| ' + ' | '.join(cell(c) for c in (r + [''] * len(fl[0]))[:len(fl[0])]) + ' |')
    p9 = P.get(9)
    if p9 and p9['tables']:
        tb = p9['tables'][0]
        M += ['', f'### 3-2. {p9["title"]}(흐름도 9번 슬라이드)', '', '| ' + ' | '.join(cell(c) for c in tb[0]) + ' |', '|' + '---|' * len(tb[0])] + ['| ' + ' | '.join(cell(c) for c in r) + ' |' for r in tb[1:]]
    # 단계별 상세 시트 → 절 나누기
    det = X.get('단계별 상세', []); dh = det[0]; secs = collections.OrderedDict(); cur = None
    for r in det[1:]:
        if r[0].startswith('[') and not any(r[1:]): cur = r[0]; secs[cur] = []; continue
        if cur is not None: secs[cur].append((r + [''] * len(dh))[:len(dh)])
    def det_table(prefix):
        out = []
        for k, rows in secs.items():
            if not k.startswith(prefix): continue
            out += [f'**단계별 상세 — {k}**', '', '| ' + ' | '.join(dh) + ' |', '|' + '---|' * len(dh)] + ['| ' + ' | '.join(cell(c) for c in r) + ' |' for r in rows] + ['']
        return out
    # §4 사업부별
    M += ['', '## 4. 사업부별 산출 흐름', '', '- 카드 = 흐름도 슬라이드의 단계(번호 순서대로 진행) · 표 = 엑셀 「단계별 상세」의 같은 사업부 행(프로그램 · 원천 · 대상 · 조건 · 산식)', '']
    p3 = P.get(3)
    M += ['### SCP FINAL 확정 연계 → 출하요청 산출(공통)', '']
    if p3:
        M += [f'- {p3["title"]} — {p3["subtitle"]}', '']
        if p3['tables']:
            tb = p3['tables'][0]; M += ['| ' + ' | '.join(cell(c) for c in tb[0]) + ' |', '|' + '---|' * len(tb[0])] + ['| ' + ' | '.join(cell(c) for c in r) + ' |' for r in tb[1:]] + ['']
        if p3['panels']: M += [C.wrap(f'<div class="spf-grid" style="--n:{len(p3["panels"])}">' + ''.join(C.card(c['title'], c['lines'], TH.get(c['fill'], '#5b6770')) for c in p3['panels']) + '</div>'), '']
        for t in p3['rest']:
            if t['paras']: M.append('- ' + ' / '.join(t['paras']))
        M.append('')
    M += det_table('[공통]')
    for sno, key, prefix in ((4, 'A', '[40]'), (5, 'B', '[81'), (7, 'E', '[전극]'), (8, 'K', '[Packer]')):
        p = P.get(sno)
        if not p: continue
        M += [f'### {p["title"]}', '', f'- {p["subtitle"]}', '']
        card_diagram(M, key, p['cards'], p['legend'], TH)
        if sno == 5 and P.get(6):
            p6 = P[6]; f = sorted([t for t in p6['rest'] if 1500000 < t['y'] < 1700000], key=lambda t: t['x'])
            M += [f'#### {p6["title"]}', '', f'- {p6["subtitle"]}', '']
            boxes = [t for t in f if len(t['paras']) > 1 or len(t['paras'][0]) > 2]; ops = [t for t in f if t not in boxes]; parts = []
            for i, t in enumerate(boxes):   # 산식 상자: 상자 + 연산 기호(+ → =) + 상자 …
                if i:
                    op = [o for o in ops if boxes[i - 1]['x'] < o['x'] < t['x']]; parts.append(f'<div class="spf-ar">{C.esc(op[0]["paras"][0]) if op else ""}</div>')
                solid = t['fill'].startswith('accent') or t['fill'] in ('tx2', 'dk2')
                parts.append(f'<div class="spf-card{" fill" if solid else ""}" style="--c:{TH.get(t["fill"] if solid else (t["line"] or "accent1"), "#5b6770")}"><b>{C.esc(t["paras"][0])}</b>' + ''.join(f'<span>{C.esc(l)}</span>' for l in t['paras'][1:]) + '</div>')
            M += [C.wrap('<div class="spf-row">' + ''.join(parts) + '</div>', 'spf-op'), '']
            if p6['panels']: M += [C.wrap(f'<div class="spf-grid" style="--n:{max(len(p6["panels"]), 2)}">' + ''.join(C.card(c['title'], c['lines'], TH.get(c['fill'], '#5b6770')) for c in p6['panels']) + '</div>'), '']
            for t in p6['rest']:
                if t in f: continue
                M.append('- ' + ' / '.join(t['paras']))
            for tb in p6['tables']: M += ['', '| ' + ' | '.join(cell(c) for c in tb[0]) + ' |', '|' + '---|' * len(tb[0])] + ['| ' + ' | '.join(cell(c) for c in r) + ' |' for r in tb[1:]]
            M.append('')
        M += det_table(prefix)
    M += ['### 통합 — 사업부 결과 통합', ''] + det_table('[통합]')
    # §5 기준정보
    bs = X.get('기준정보 설정', [])
    if bs:
        n = len(bs[0]); M += ['## 5. 기준정보 설정(엑셀 「기준정보 설정」 시트)', '', '| ' + ' | '.join(cell(c) for c in bs[0]) + ' |', '|' + '---|' * n]
        for r in bs[1:]: M.append('| ' + ' | '.join(cell(c) for c in (r + [''] * n)[:n]) + ' |')
    # §6 확인 필요
    p10 = P.get(10)
    if p10:
        M += ['', f'## 6. {p10["title"]}(흐름도 10번 슬라이드)', '']
        if p10['cards']: M += [C.wrap(f'<div class="spf-grid" style="--n:{len(p10["cards"])}">' + ''.join(C.card(f'{c["no"]}. {c["title"]}', c['lines'], TH.get(c['fill'], '#d98e2b')) for c in p10['cards']) + '</div>'), '']
        if p10['panels']: M += [C.wrap(f'<div class="spf-grid" style="--n:1">' + ''.join(C.card(c['title'], c['lines'], TH.get(c['fill'], '#5b6770')) for c in p10['panels']) + '</div>'), '']
        for t in p10['rest']: M.append('- ' + ' / '.join(t['paras']))
    # §7 교차검증
    M += ['', '## 7. 교차검증 — 자료(TO-BE 본문 기준) ↔ AS-IS SP 본문', '',
          '- 엑셀 「단계별 상세」 각 행의 프로그램에 대해, 「원천 테이블」이 AS-IS 본문의 읽기·쓰기 대상에, 「대상 테이블 · 메저」의 테이블이 쓰기 대상에 있는지 대조(중첩 호출 깊이 3 · 이름 끝 `_SN` 은 떼고 비교). 테이블 이름은 AS-IS 객체 카탈로그에 있는 것만 대조하고, 카탈로그에 없는 이름은 따로 적는다(임시 테이블 · 메저 이름 · TO-BE 에만 있는 객체)', '',
          '| 구간 | 단계 | 처리 | 프로그램(AS-IS 본문 있는 것) | 원천 — 본문에 없음 | 대상 — 본문 쓰기에 없음 | AS-IS 카탈로그에 없는 테이블 이름 |', '|---|---|---|---|---|---|---|']
    cross = []; n_cmp = 0; n_ok = 0; unk_tab = collections.defaultdict(set); n_other = 0
    RX_TABLIKE = re.compile(r'^(SCM|SSP|SCP|DM|XIF|GT|HIST|FP|NERP)_[A-Z0-9_]{4,}$')  # 테이블 꼴 이름(메저 · 컬럼 · 룩업 코드 이름은 테이블이 아니므로 건수만 센다)
    objn = {re.sub(r'_SN$', '', o) for o in (objs or [])} | set(objs or [])
    RXT = re.compile(r'\b[A-Z][A-Z0-9]*(?:_[A-Z0-9]+)+\b')
    steps_csv = []
    for sec, rows in secs.items():
        for r in rows:
            steps_csv.append([sec] + r)
            progs = [p_ for p_ in dict.fromkeys(re.findall(r'\bPR_[A-Z0-9_]+', r[3])) if mods is None or p_ in mods]
            if not progs or not parse_sp: continue
            rd_ = set(); wr = set()
            for p_ in progs:
                info = parse_sp(p_); wr |= {re.sub(r'_SN$', '', t) for t in info['writes']}; rd_ |= {re.sub(r'_SN$', '', t) for t in info['reads']}
            src = [re.sub(r'_SN$', '', t) for t in dict.fromkeys(RXT.findall(r[4]))]; tgt = [re.sub(r'_SN$', '', t) for t in dict.fromkeys(RXT.findall(r[5]))]
            unk_all = [t for t in dict.fromkeys(src + tgt) if t not in objn and not t.startswith('PR_')]
            unk = [t for t in unk_all if RX_TABLIKE.match(t)]; n_other += len(unk_all) - len(unk)
            src = [t for t in src if t in objn]; tgt = [t for t in tgt if t in objn]
            ms = [t for t in src if t not in rd_ and t not in wr]; mt = [t for t in tgt if t not in wr]
            n_cmp += 1; n_ok += 0 if (ms or mt) else 1
            if ms or mt or unk:
                M.append(f"| {cell(sec).split(']')[0] + ']'} | {cell(r[1])} | {cell(r[2])} | {', '.join(progs)} | {', '.join(ms) or '-'} | {', '.join(mt) or '-'} | {', '.join(unk) or '-'} |")
            for t in ms: cross.append([sec, r[2], ','.join(progs), '원천 — AS-IS 본문 읽기·쓰기에 없음', t])
            for t in mt: cross.append([sec, r[2], ','.join(progs), '대상 — AS-IS 본문 쓰기에 없음', t])
            for t in unk: cross.append([sec, r[2], ','.join(progs), 'AS-IS 객체 카탈로그에 없는 테이블 이름', t]); unk_tab[t].add(','.join(progs))
            for t in unk_all:
                if t not in unk: cross.append([sec, r[2], ','.join(progs), '테이블 아님(메저 · 컬럼 · 룩업 코드 이름)', t])
    M += ['', f'- 대조한 행 {n_cmp} · 원천·대상이 모두 AS-IS 본문과 맞는 행 {n_ok} · 차이 있는 행 {n_cmp - n_ok} · 근거 `ssp_shipplan_crosscheck.csv`',
          f"- AS-IS 객체 카탈로그에 없는 테이블 이름 {len(unk_tab)}종: " + ('; '.join(f'{t}({", ".join(sorted(v))})' for t, v in sorted(unk_tab.items())) or '없음') + ' — `GT_` 는 TO-BE 전역 임시 테이블. 나머지는 TO-BE 에서 이름이 다르거나 새로 생긴 객체일 수 있어 AS-IS 대응 객체 확인 대상',
          f'- 자료 칸에 함께 적힌 메저 · 컬럼 · 룩업 코드 이름 {n_other}건은 테이블이 아니라 대조에서 제외(CSV 에는 남김)',
          '- 「본문에 없음」의 가능한 원인: 동적 SQL · 깊이 4 이상 호출 · TO-BE 변환에서 바뀐 이름 · 자료가 요약하며 넣은 관련 테이블. 건별 원인은 확인하지 않았다(미확인).', '']
    with io.open(os.path.join(out_dir, 'ssp_shipplan_steps.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(['구간'] + dh); w.writerows(steps_csv)
    with io.open(os.path.join(out_dir, 'ssp_shipplan_crosscheck.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(['section', 'step', 'programs', 'finding', 'name']); w.writerows(cross)
    io.open(os.path.join(out_dir, 'SSP_SHIPPLAN_FLOW.md'), 'w', encoding='utf-8', newline='\n').write('\n'.join(M) + '\n')
    return {'slides': len(S), 'cards': sum(len(P[k]['cards']) for k in P), 'detail_rows': len(steps_csv), 'cmp': n_cmp, 'ok': n_ok, 'cross': len(cross)}
