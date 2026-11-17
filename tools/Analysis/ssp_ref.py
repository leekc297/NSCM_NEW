# -*- coding: utf-8 -*-
"""
SSP 기존 분석 자료(Doc/asisfacts/ref_ssp — ssp_ref_extract.py 산출) → 흐름 산출물 반영 (2026-11-11)
  build(out_dir, ctx) → SSP_REF_PROCESS.md · ssp_ref_crosscheck.csv · ssp_ref_screen_links.csv
  screen_links() / prod_schedule() 는 ssp_flow.py · ssp_batch_flow.py 가 가져다 쓴다.
원칙: 자료 원문을 그대로 옮기고, 이 저장소의 분석(SP 본문 파싱 · DEV msdb)과 어긋나는 곳은 고치지 않고 '교차검증' 절에 나란히 적는다.
"""
import os, io, re, csv, html, time, collections

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
REF = os.path.join(ROOT, 'Doc', 'asisfacts', 'ref_ssp')
GEOM_TOL = 90000   # EMU(약 0.1인치) — 연결선 끝점이 도형 테두리에서 이 거리 안이면 그 도형에 붙은 것으로 본다(도형 id 가 없을 때)
LINE_TOL = 60000   # EMU — 연결선 끝점이 다른 연결선 경로에서 이 거리 안이면 같은 줄기로 합류한 것으로 본다
SRC_NAMES = {'ppt': 'SSP 프로세스 확인 내용.pptx',  # 2026-11-16 판(9장 · 진행여부 체크 기준 추가)으로 교체 · 11-11 판 = src/SSP 프로세스 확인 내용_20261111.pptx
 'batch': 'SCP_SSP_Batch List_261103.xlsx', 'it': '(20261112) SSP 통합테스트 시나리오-V2.xlsx'}  # 2026-11-16 V2 로 교체(11-09 판 사본은 src/ 에 그대로)


def rd(name):
    p = os.path.join(REF, name)
    if not os.path.exists(p): return []
    with io.open(p, encoding='utf-8-sig', newline='') as f: return list(csv.DictReader(f))


def available(): return os.path.exists(os.path.join(REF, 'it_scenario.csv'))


def _seg_dist(p, a, b):
    (px, py), (ax, ay), (bx, by) = p, a, b
    dx, dy = bx - ax, by - ay
    if dx == 0 and dy == 0: return ((px - ax) ** 2 + (py - ay) ** 2) ** 0.5
    t = max(0.0, min(1.0, ((px - ax) * dx + (py - ay) * dy) / (dx * dx + dy * dy)))
    return ((px - ax - t * dx) ** 2 + (py - ay - t * dy) ** 2) ** 0.5


def resolve_lines(conns, boxes, id2box, prio=None):
    """연결선 묶음 → 간선. boxes = {key: (x, y, w, h)} · id2box = {도형 id: key}
    ① 끝점이 도형에 붙었는지: 도형 id → 없으면 테두리 GEOM_TOL 이내 ② 끝점이 다른 연결선 경로에 LINE_TOL 이내로 닿으면 한 줄기
    ③ 줄기마다: 화살표 없는 쪽에 붙은 도형 = 출발, 화살표가 닿은 도형 = 도착 → 출발 전부 → 도착 전부
    반환 (edges[{a,b,arrow,conns,how}], unresolved[{id,why}])"""
    cs = []
    for c in conns:
        pts = [tuple(float(v) for v in q.split(',')) for q in (c.get('path') or '').split(';') if q]
        if len(pts) < 2: continue
        cs.append({'id': c['id'], 'pts': pts, 'st': c['start_id'] if c['start_by'] == 'id' else '', 'en': c['end_id'] if c['end_by'] == 'id' else '', 'head': c['arrow_at_start'] == 'Y', 'tail': c['arrow_at_end'] == 'Y'})
    def border_dist(pt, k):
        x, y, w, h = boxes[k]
        if x <= pt[0] <= x + w and y <= pt[1] <= y + h: return min(pt[0] - x, x + w - pt[0], pt[1] - y, y + h - pt[1])
        dx = max(x - pt[0], 0, pt[0] - (x + w)); dy = max(y - pt[1], 0, pt[1] - (y + h)); return (dx * dx + dy * dy) ** 0.5
    def promote(pt, k):
        # 글상자에 붙은 끝이 그 글상자를 담은 묶음 사각형의 테두리에 닿아 있으면 묶음 전체에 붙은 것으로 본다(그림에서 화살표가 사각형 테두리에서 나감)
        if not prio or k not in prio: return k
        kx, ky, kw, kh = boxes[k]
        outer = [c for c in boxes if c not in prio and boxes[c][0] - 20000 <= kx + kw / 2 <= boxes[c][0] + boxes[c][2] + 20000 and boxes[c][1] - 20000 <= ky + kh / 2 <= boxes[c][1] + boxes[c][3] + 20000 and border_dist(pt, c) <= GEOM_TOL]
        return min(outer, key=lambda c: boxes[c][2] * boxes[c][3]) if outer else k
    def attach(pt, sid):
        if sid and sid in id2box: return promote(pt, id2box[sid]), 'id'
        if prio:  # 묶음 사각형 테두리에 닿은 끝 → 묶음(글상자 여백과 겹쳐도 테두리가 우선 — 슬라이드 3 이미지로 확인)
            near_c = [c for c in boxes if c not in prio and border_dist(pt, c) <= GEOM_TOL]
            if near_c: return min(near_c, key=lambda c: boxes[c][2] * boxes[c][3]), 'geom'
        for keys in ((prio, set(boxes) - set(prio)) if prio else (set(boxes),)):
            best = None
            for k in keys:
                x, y, w, h = boxes[k]
                dx = max(x - pt[0], 0, pt[0] - (x + w)); dy = max(y - pt[1], 0, pt[1] - (y + h)); d = (dx * dx + dy * dy) ** 0.5
                if best is None or d < best[0]: best = (d, k)
            if best and best[0] <= GEOM_TOL: return best[1], 'geom'
        return '', ''
    par = {c['id']: c['id'] for c in cs}
    def find(a):
        while par[a] != a: par[a] = par[par[a]]; a = par[a]
        return a
    ends = {}
    for c in cs:
        a, ah = attach(c['pts'][0], c['st']); b, bh = attach(c['pts'][-1], c['en'])
        ends[c['id']] = [(a, ah, c['head']), (b, bh, c['tail'])]
    for c in cs:
        for i, pt in enumerate((c['pts'][0], c['pts'][-1])):
            if ends[c['id']][i][0]: continue  # 도형에 붙은 끝은 줄기 합류로 보지 않는다
            for o in cs:
                if o['id'] == c['id']: continue
                if min(_seg_dist(pt, o['pts'][j], o['pts'][j + 1]) for j in range(len(o['pts']) - 1)) <= LINE_TOL:
                    par[find(c['id'])] = find(o['id'])
    comp = collections.defaultdict(list)
    for c in cs: comp[find(c['id'])].append(c)
    edges = []; unresolved = []
    for root, members in comp.items():
        src = []; snk = []; loose = 0
        for c in members:
            for box, how, arrow in ends[c['id']]:
                if box: (snk if arrow else src).append((box, how))
                else: loose += 1
        ids = ','.join(sorted((c['id'] for c in members), key=lambda v: int(v) if v.isdigit() else 0))
        how = 'id' if all(h == 'id' for _, h in src + snk) else '좌표'
        how += '' if len(members) == 1 else f' · 줄기 {len(members)}선'
        if snk and src:
            for a in dict.fromkeys(b for b, _ in src):
                for b in dict.fromkeys(b for b, _ in snk):
                    if a != b: edges.append({'a': a, 'b': b, 'arrow': True, 'conns': ids, 'how': how, 'pts': [c['pts'] for c in members]})
        elif len({b for b, _ in src}) >= 2 and not snk:
            bs = list(dict.fromkeys(b for b, _ in src))
            for i in range(len(bs) - 1): edges.append({'a': bs[i], 'b': bs[i + 1], 'arrow': False, 'conns': ids, 'how': how, 'pts': [c['pts'] for c in members]})
        elif len({b for b, _ in snk}) >= 2 and not src:
            bs = list(dict.fromkeys(b for b, _ in snk))
            for i in range(len(bs) - 1): edges.append({'a': bs[i], 'b': bs[i + 1], 'arrow': False, 'conns': ids, 'how': how + ' · 양끝 화살표', 'pts': [c['pts'] for c in members]})
        else:
            unresolved.append({'id': ids, 'why': f"도형에 붙은 끝 {len(src) + len(snk)}개(출발 {len(src)} · 도착 {len(snk)}) · 어디에도 안 붙은 끝 {loose}개"})
    return edges, unresolved
def mm(s): return re.sub(r'[^A-Za-z0-9_]', '_', str(s))
def esc(s): return html.escape(str(s)).replace('"', '&quot;')
def ids_in(text): return list(dict.fromkeys(re.findall(r'\b([A-Z]{3}\d{4})\b', text or '')))
def cellmd(s): return str(s or '').replace('|', '/').replace('\n', ' ')


# ── PI 프로세스(PPT 1번 슬라이드) ─────────────────────────────────────────────
def pi_process():
    sh = [x for x in rd('ppt_shapes.csv') if x['slide'] == '1']; gr = {x['id']: x for x in rd('ppt_groups.csv') if x['slide'] == '1'}
    cn = [x for x in rd('ppt_connectors.csv') if x['slide'] == '1']
    bygrp = collections.defaultdict(list)
    for x in sh: bygrp[x['group']].append(x)
    RXS = re.compile(r'\d+(-\d+)?$')
    steps = {}
    for g, v in bygrp.items():
        if g not in gr or len(v) > 6: continue
        texts = [y for y in sorted(v, key=lambda y: (int(y['y'] or 0), int(y['x'] or 0))) if y['text']]
        seq = [y['text'] for y in texts if RXS.match(y['text'])]
        if len(texts) >= 2: steps[g] = {'grp': g, 'seq': seq[0] if seq else '', 'texts': [y['text'] for y in texts if not RXS.match(y['text'])], 'x': int(gr[g]['x']), 'y': int(gr[g]['y']), 'w': int(gr[g]['w']), 'h': int(gr[g]['h'])}
    # Seq 문구가 그룹 밖 도형으로 떨어져 있는 단계(2-1 등) — 그 문구가 놓인 위치의 단계 그룹에 붙인다
    for y in sh:
        if RXS.match(y['text']) and y['group'] not in steps:
            cx, cy = int(y['x']) + int(y['w']) / 2, int(y['y']) + int(y['h']) / 2
            cand = [s for s in steps.values() if not s['seq'] and s['x'] - 50000 <= cx <= s['x'] + s['w'] + 50000 and s['y'] - 50000 <= cy <= s['y'] + s['h'] + 50000]
            if cand: cand[0]['seq'] = y['text']
    # 시스템 문구가 다른 그룹에 있는 단계(2-3) — 단계 박스 바로 아래 놓인 'SCM xxx' 문구
    for s in steps.values():
        if len(s['texts']) < 3:
            near = [y for y in sh if y['group'] not in steps and re.match(r'(SCM|ERP|MES|LSP|Off)', y['text']) and abs(int(y['x']) - s['x']) < 80000 and 0 <= int(y['y']) - s['y'] <= s['h'] + 250000]
            if near: s['texts'].append(near[0]['text'])
    steps = {g: s for g, s in steps.items() if s['seq']}
    lanes = sorted([(int(y['x']), y['text']) for y in sh if y['group'] not in steps and int(y['y'] or 0) < 900000 and int(y['y'] or 0) > 500000 and y['text']], key=lambda t: t[0])
    def lane_of(x):
        c = [t for t in lanes if t[0] <= x + 200000]
        return c[-1][1] if c else ''
    for s in steps.values(): s['lane'] = lane_of(s['x'])
    s2g = {y['id']: y['group'] for y in sh}
    boxes = {}; id2box = {}; labels = {}
    for g, st in steps.items():
        k = 'S' + st['seq'].replace('-', '_'); boxes[k] = (st['x'], st['y'], st['w'], st['h']); labels[k] = st['seq']
    for y in sh:
        if s2g.get(y['id']) in steps: id2box[y['id']] = 'S' + steps[s2g[y['id']]]['seq'].replace('-', '_')
        elif y['text'] and y['geom'] in ('flowChartDecision', 'diamond'):
            k = 'X' + y['id']; boxes[k] = (int(y['x']), int(y['y']), int(y['w']), int(y['h'])); labels[k] = y['text']; id2box[y['id']] = k
    raw, unresolved = resolve_lines(cn, boxes, id2box)
    yn = [(int(y['x']) + int(y['w']) / 2, int(y['y']) + int(y['h']) / 2, y['text']) for y in sh if y['text'] in ('Y', 'N')]
    edges = []; loose_nodes = {}
    for e in raw:
        label = ''
        if e['a'].startswith('X') and yn:  # 판단 도형에서 나가는 선 — 선 경로에 가장 가까운 Y/N 문구
            best = min(((min(_seg_dist((x, y_), pl[j], pl[j + 1]) for pl in e['pts'] for j in range(len(pl) - 1))), t) for x, y_, t in yn)
            if best[0] < 400000: label = best[1]
        edges.append({'id': e['conns'], 'a': e['a'], 'al': labels.get(e['a'], ''), 'b': e['b'], 'bl': labels.get(e['b'], ''), 'arrow': 'end' if e['arrow'] else 'none', 'by': e['how'], 'dist': 0, 'ok': True, 'label': label})
        for nid in (e['a'], e['b']):
            if nid.startswith('X'): loose_nodes[nid] = labels[nid]
    for u in unresolved: edges.append({'id': u['id'], 'a': '', 'al': '', 'b': '', 'bl': '', 'arrow': '', 'by': '', 'dist': 0, 'ok': False, 'label': '', 'why': u['why']})
    order = sorted(steps.values(), key=lambda s: [int(p) for p in s['seq'].split('-')])
    return order, lanes, edges, loose_nodes


def pi_seq_expand(text, order):
    """'PI 2-1 ~ 2-4' · 'PI 13 · 14 · 15 · 16' · 'PI 6~8' → Seq 목록"""
    seqs = [s['seq'] for s in order]; out = []
    t = re.sub(r'^\s*PI\s*', '', text or '')
    for part in re.split(r'\s*·\s*', t):
        m = re.match(r'\s*(\d+(?:-\d+)?)\s*~\s*(\d+(?:-\d+)?)\s*$', part)
        if m and m.group(1) in seqs and m.group(2) in seqs:
            out += seqs[seqs.index(m.group(1)):seqs.index(m.group(2)) + 1]
        elif part.strip() in seqs: out.append(part.strip())
    return list(dict.fromkeys(out))


# ── 통합테스트 시나리오 ───────────────────────────────────────────────────────
def scenarios():
    rows = rd('it_scenario.csv'); out = []
    for r in rows:
        g = lambda k: (r.get(k) or '').strip()
        st_ = re.sub(r'\s*\(\d+건\)\s*$', '', g('stage_row')).strip() or g('시나리오(흐름 단계)').split(' / ')[0]  # 흐름 단계 = 구분 행 문구(① …) · 행 칸의 ' / ' 뒤는 세부 이름
        sub_ = g('시나리오(흐름 단계)').split(' / ', 1)[1] if ' / ' in g('시나리오(흐름 단계)') else ''
        out.append({'id': g('테스트ID'), 'pi': g('시나리오 ID'), 'stage': st_, 'sub': sub_, 'kind': g('구분'), 'timeline': g('타임라인'), 'schedule': g('스케줄 (주기)') or g('스케줄'), 'step': g('단계'), 'ver': g('버전타입'),
                    'screens': g('화면 ID'), 'name': g('테스트명'), 'div': g('비고(사업부)'), 'src': g('SRC 테이블'), 'tgt': g('TGT 테이블'), 'job': g('JOB (Full Name)'), 'prc': g('프로시저 (Full Name)'), 'expect': g('예상결과'), 'asis_run': g('실행절차 (As-Is/MSSQL)'), 'tobe_run': g('실행절차 (To-Be/Oracle')})
    return out


def screen_links():
    """화면 ID → [(테스트ID, 흐름 단계, PI, 테스트명)] · 수정 필요사항"""
    links = collections.defaultdict(list)
    for s in scenarios():
        for sid in ids_in(s['screens']): links[sid].append((s['id'], s['stage'], s['pi'], s['name']))
    for r in rd('it_precheck.csv'):
        for sid in ids_in(r.get('화면 ID', '')): links[sid].append((r.get('테스트ID', ''), '사전 점검', '-', r.get('점검 항목', '')))
    issues = collections.defaultdict(list)
    for r in rd('it_issues.csv'):
        if r['sheet'] == '수정 필요사항' and r['c1'] not in ('No', ''):
            for sid in ids_in(r['c2']): issues[sid].append((r['c3'], r['c5']))
    return links, issues


# ── 운영 잡 스케줄 ────────────────────────────────────────────────────────────
def prod_schedule():
    """잡 이름 → [{'sheet','cycle','time','call','module','if','note'}] (운영 LGCE_SCMPROD 기준 · Batch List 261103)"""
    out = collections.defaultdict(list)
    for r in rd('prod_jobs.csv'):
        out[r['job'].strip()].append({'sheet': r['sheet'], 'cycle': r['cycle'], 'time': r['time'], 'call': r['call_procedure'], 'module': r['module'], 'if': r['if'], 'note': r['note'], 'content': r['job_content'], 'no': r['no']})
    return out


def sched_text(rows): return ' | '.join(f"{x['cycle']} {x['time']}".strip() for x in rows)


def batch_list():
    return {r['procedure'].strip().upper(): r for r in rd('batch_list.csv') if r.get('procedure')}


def if_tables():
    out = collections.defaultdict(set)
    for r in rd('if_prc.csv'):
        if r.get('procedure') and r.get('if_table'): out[r['procedure'].strip().upper()].add((r['if'], r['if_table'].strip()))
    return out


# ── PPT 슬라이드 2~7(배치별 입출력) ───────────────────────────────────────────
RX_PROC = re.compile(r'^(PR_|SCM_SSP_|NERP_PR_)[A-Z0-9_]+$')
RX_TAB = re.compile(r'^[A-Z][A-Z0-9_]{5,}$')


def _tab_parts(text):
    """글상자 문구 → 테이블 이름 목록(전부 테이블 꼴일 때만). 'A : 설명' 은 A 로 본다"""
    parts = [re.split(r'\s*:\s*', q.strip())[0].strip() for q in text.split(' / ') if q.strip()]
    return parts if parts and all(RX_TAB.match(q) and '_' in q and not RX_PROC.match(q) for q in parts) else []


def ppt_slides():
    """슬라이드 그림 규칙(이미지로 확인): 프로시저 머리 상자 아래에 '원천 테이블(묶음) → 대상 테이블(묶음)' 화살표.
    여러 테이블은 빈 사각형 안에 글상자로 놓이고 화살표는 그 사각형 테두리에 붙는다. 화살표의 소속 프로시저 = 같은 세로 줄에서 바로 위에 있는 프로시저 머리 상자."""
    sh = rd('ppt_shapes.csv'); cn = rd('ppt_connectors.csv'); out = []
    for sno in sorted({int(x['slide']) for x in sh}):
        if sno == 1: continue
        ss = [x for x in sh if x['slide'] == str(sno) and x['x'] != '']
        for x in ss:
            for k in ('x', 'y', 'w', 'h'): x[k] = int(x[k])
        texts = [x for x in ss if x['text']]
        procs = [x for x in texts if RX_PROC.match(x['text'].strip())]
        tabs = {x['id']: _tab_parts(x['text']) for x in texts if not RX_PROC.match(x['text'].strip()) and _tab_parts(x['text'])}
        notes = [x for x in texts if x not in procs and x['id'] not in tabs]
        def inside(inner, outer): return outer['x'] - 20000 <= inner['x'] + inner['w'] / 2 <= outer['x'] + outer['w'] + 20000 and outer['y'] - 20000 <= inner['y'] + inner['h'] / 2 <= outer['y'] + outer['h'] + 20000
        conts = {}
        for x in ss:
            if x['text'] or x['w'] < 200000 or x['h'] < 150000: continue
            inner_t = [t for t in texts if t['id'] in tabs and inside(t, x)]; inner_p = [t for t in procs if inside(t, x)]
            if inner_t and not inner_p: conts[x['id']] = (x, sorted(inner_t, key=lambda t: (t['y'], t['x'])))
        boxes = {}; node_tabs = {}
        for x in texts:
            if x['id'] in tabs: boxes['T' + x['id']] = (x['x'], x['y'], x['w'], x['h']); node_tabs['T' + x['id']] = tabs[x['id']]
        for cid, (x, inner) in conts.items():
            boxes['C' + cid] = (x['x'], x['y'], x['w'], x['h']); node_tabs['C' + cid] = [q for t in inner for q in tabs[t['id']]]
        raw, unresolved = resolve_lines([c for c in cn if c['slide'] == str(sno)], boxes, {k[1:]: k for k in boxes}, prio={k for k in boxes if k.startswith('T')})
        rows = []
        for e in raw:
            xs = [q[0] for pl in e['pts'] for q in pl]; ys = [q[1] for pl in e['pts'] for q in pl]
            cx = (min(xs) + max(xs)) / 2; top = min(min(ys), boxes[e['a']][1], boxes[e['b']][1])
            cand = [p_ for p_ in procs if p_['y'] + p_['h'] <= top + 40000 and p_['x'] - 0.15 * p_['w'] <= cx <= p_['x'] + 1.15 * p_['w']]
            own = max(cand, key=lambda p_: p_['y'])['text'].strip() if cand else ''
            own_how = '같은 세로 줄'
            if not own:  # 같은 세로 줄에 머리 상자가 없으면(넓은 묶음 상자 안 화살표) 위쪽에서 가장 가까운 머리 상자
                above = [p_ for p_ in procs if p_['y'] + p_['h'] <= top + 40000]
                if above: own = min(above, key=lambda p_: (top - (p_['y'] + p_['h'])) + abs((p_['x'] + p_['w'] / 2) - cx))['text'].strip(); own_how = '위쪽 가장 가까운 머리 상자'
            rows.append({'proc': own, 'src': node_tabs[e['a']], 'tgt': node_tabs[e['b']], 'a': e['a'], 'b': e['b'], 'arrow': e['arrow'], 'how': e['how'] + ' · 소속=' + own_how})
        # 제목 = 슬라이드 위쪽 띠(y < TITLE_BAND)의 번호 문구. 2026-11-16 판부터 '■ 프로세스 진행여부 체크 기준' 패널에 '1. …' 조건 문구가 들어와 위치로 구분한다(※ 메모·조건은 설명 문구 표에 남음)
        titles = [x['text'] for x in sorted(notes, key=lambda x: (x['y'], x['x'])) if re.match(r'^\d+(-\d+)?\.\s', x['text']) and x['y'] < TITLE_BAND]
        used = {k for r in rows for k in (r['a'], r['b'])}
        lone_tabs = [(x['text']) for x in sorted(texts, key=lambda x: (x['y'], x['x'])) if x['id'] in tabs and 'T' + x['id'] not in used and not any(x in inner for cid, (c_, inner) in conts.items() if 'C' + cid in used)]
        tbl = collections.defaultdict(dict)
        for t in rd('ppt_tables.csv'):
            if t['slide'] == str(sno): tbl[(t['frame_id'], int(t['row']))][int(t['col'])] = t['text']
        out.append({'slide': sno, 'tables': [[r[c] for c in sorted(r)] for k, r in sorted(tbl.items())], 'procs': [x['text'].strip() for x in sorted(procs, key=lambda x: (x['x'] // 2000000, x['y']))], 'rows': rows, 'notes': [x['text'] for x in sorted(notes, key=lambda x: (x['y'], x['x']))], 'titles': titles, 'unresolved': unresolved, 'lone_tabs': lone_tabs, 'n_conn': sum(1 for c in cn if c['slide'] == str(sno))})
    return out


TITLE_BAND = 300000  # EMU · 제목 문구 y 상한(2026-11-16 판 실측: 제목 y 41183~205105 · 조건 문구 y 377100 이상)
RX_COND = re.compile(r'^(\d+\.\s|※|- 당일|- 프로세스 진행 여부 체크 없음|- PR_)')


def run_conditions():
    """'프로세스 진행여부 체크 기준'(2026-11-16 판 PPT에 추가) → [{'slide','proc','items','how'}]
    소속 규칙(슬라이드 배치 실측):
      ① '■ 프로세스 진행여부 체크 기준' 머리 문구가 있는 슬라이드 = 그 오른쪽 패널(x ≥ 머리 x − 0.5M, y > 머리 y)의 조건 문구.
         패널 안에 '- PR_…' 줄이 있으면 그 아래 문구가 그 프로시저 몫 · 없으면 '- 프로세스 진행여부 체크 -' 표지에 가장 가까운 머리 상자 · 표지도 없으면 머리 상자가 하나일 때 그 상자
      ② 머리 문구가 없는 슬라이드 = '보낸데이터건수' · '진행 여부 체크 없음' · '수행 X' · 'Snapshot' 문구를 가장 가까운 머리 상자(같은 세로 줄 위쪽 우선)에 붙인다
    """
    sh = rd('ppt_shapes.csv'); out = []
    for sno in sorted({int(x['slide']) for x in sh}):
        if sno == 1: continue
        ss = [dict(x) for x in sh if x['slide'] == str(sno) and x['x'] != '' and x['text']]
        for x in ss:
            for k in ('x', 'y', 'w', 'h'): x[k] = int(x[k])
        procs = [x for x in ss if RX_PROC.match(x['text'].strip())]
        def dist(a, b):
            dx = max(b['x'] - (a['x'] + a['w']), 0, a['x'] - (b['x'] + b['w'])); dy = max(b['y'] - (a['y'] + a['h']), 0, a['y'] - (b['y'] + b['h']))
            return (dx * dx + dy * dy) ** 0.5
        hdr = [x for x in ss if x['text'].startswith('■ 프로세스 진행여부 체크 기준')]
        if hdr:
            h = hdr[0]; mark = [x for x in ss if x['text'].strip() == '- 프로세스 진행여부 체크 -']
            panel = sorted([x for x in ss if x['x'] >= h['x'] - 500000 and x['y'] > h['y'] and x is not h and x not in mark and not RX_PROC.match(x['text'].strip()) and RX_COND.match(x['text'])], key=lambda x: x['y'])
            owner = ''; how = ''
            if mark and procs: owner = min(procs, key=lambda p_: dist(p_, mark[0]))['text'].strip(); how = "'- 프로세스 진행여부 체크 -' 표지에 가장 가까운 머리 상자"
            elif len({p_['text'].strip() for p_ in procs}) == 1: owner = procs[0]['text'].strip(); how = '슬라이드의 유일한 머리 상자'
            cur = {'slide': sno, 'proc': owner, 'items': [], 'how': how}
            for x in panel:
                t = x['text'].strip()
                if t.startswith('- PR_'):
                    if cur['items']: out.append(cur)
                    cur = {'slide': sno, 'proc': t[2:].strip(), 'items': [], 'how': "패널 안 '- 프로시저' 줄 아래"}; continue
                cur['items'].append(t)
            if cur['items']: out.append(cur)
        for x in ss:
            t = x['text']
            if not re.search(r'보낸데이터건수|진행 여부 체크 없음|수행 X|Snapshot 한', t) or (hdr and x['x'] >= hdr[0]['x'] - 500000): continue
            above = [p_ for p_ in procs if p_['y'] + p_['h'] <= x['y'] + 40000 and p_['x'] - 0.15 * p_['w'] <= x['x'] + x['w'] / 2 <= p_['x'] + 1.15 * p_['w']]
            if above: own = max(above, key=lambda p_: p_['y']); how = '같은 세로 줄 바로 위 머리 상자'
            else: own = min(procs, key=lambda p_: dist(p_, x)); how = '가장 가까운 머리 상자'
            out.append({'slide': sno, 'proc': own['text'].strip(), 'items': [q.strip() for q in t.split(' / ') if q.strip()], 'how': how})
    return out


def proc_jobs(prod=None):
    """프로시저 → 운영 잡 [(잡, 주기, 시각)] — 잡 호출 트리(prod_job_calltree 깊이 전부) + 잡 목록 call_procedure"""
    prod = prod or prod_schedule(); out = collections.defaultdict(list)
    for j, rows in prod.items():
        for x in rows:
            for p_ in re.split(r'\s*/\s*', x['call'] or ''):
                if p_.strip(): out[p_.strip().upper()].append((j, x['cycle'], x['time']))
    for r in rd('prod_job_calltree.csv'):
        p_ = re.sub(r'^[└├│\s]+', '', r['procedure'] or '').strip().upper()
        if p_ and r['job'] in prod and not any(q[0] == r['job'] for q in out[p_]):
            for x in prod[r['job']]: out[p_].append((r['job'], x['cycle'], x['time']))
    return out


def norm_tab(t):
    t = t.strip().upper()
    return re.sub(r'_SN$', '', t)


def tgt_tables(text):
    """시나리오 TGT 테이블 칸 → 테이블 이름 집합('A(_H)' = A · A_H, 'A(COL)' = A, 한글 설명 제외)"""
    out = set()
    for part in re.split(r'\s*/\s*|\s*·\s*', text or ''):
        m = re.match(r'^([A-Z][A-Z0-9_]{3,})(\((.*?)\))?', part.strip())
        if not m or '_' not in m.group(1): continue
        base = m.group(1); out.add(base)
        if m.group(3) and re.fullmatch(r'_[A-Z0-9_]+', m.group(3)): out.add(base + m.group(3))
    return out


# ── 산출 ──────────────────────────────────────────────────────────────────────
def build(out_dir, parse_sp=None, objs=None, screens=None):
    """SSP_REF_PROCESS.md 생성. parse_sp(sp)->{'reads','writes','calls','missing'} · objs = AS-IS 객체 이름 집합 · screens = {id: {...}}"""
    if not available(): return None
    t0 = time.strftime('%Y-%m-%d %H:%M')
    order, lanes, edges, loose = pi_process(); n_conn = sum(1 for x in rd('ppt_connectors.csv') if x['slide'] == '1'); sc = scenarios(); prod = prod_schedule(); bl = batch_list(); ift = if_tables()
    pre = rd('it_precheck.csv'); iss = rd('it_issues.csv'); summ = rd('it_summary.csv')
    screens = screens or {}
    def scr_name(sid):
        s = screens.get(sid) or {}
        return (s.get('tobe_desc') or s.get('name') or '')
    M = [f'# SSP 업무 프로세스 — 기존 분석 자료 반영 · {t0} 생성', '',
         f'> 원천(사용자 제공 2026-11-11 · 사본 `Doc/asisfacts/ref_ssp/src/`): ① `{SRC_NAMES["ppt"]}`(SSP CUTOFF Process · 배치별 입출력) ② `{SRC_NAMES["batch"]}`(운영 LGCE_SCMPROD 잡 스케줄 · 프로시저 목록 · TO-BE 객체 상태) ③ `{SRC_NAMES["it"]}`(흐름 {len(dict.fromkeys(x["stage"] for x in sc))}단계 · {len(sc)}건). 구조화 = `tools/Analysis/ssp_ref_extract.py` → `Doc/asisfacts/ref_ssp/*.csv` · 이 문서 = `tools/Analysis/ssp_ref.py`',
         '> 자료 원문을 그대로 옮겼다. 이 저장소의 분석(SP 본문 파싱 · DEV msdb)과 어긋나는 곳은 고치지 않고 §6 교차검증에 나란히 적었다.', '',
         '## 1. SSP CUTOFF Process — PI 프로세스 맵(22 Seq)', '',
         f'- 출처 = {SRC_NAMES["ppt"]} 1번 슬라이드 · 단계 박스 {len(order)}개(Seq 1-1 ~ 22) · 레인 {len(lanes)} · 흐름 간선 {sum(1 for e in edges if e["ok"])}개(연결선 {n_conn}개에서 해석) · 풀지 못한 줄기 {sum(1 for e in edges if not e["ok"])}',
         f'- 연결선 판정: 연결선의 실제 꺾인 경로를 계산해 ① 끝점이 도형에 붙었는지(도형 id · 없으면 테두리 {GEOM_TOL} EMU 이내) ② 끝점이 다른 연결선에 {LINE_TOL} EMU 이내로 닿으면 한 줄기로 묶음 ③ 줄기의 화살표 없는 쪽 박스 → 화살표가 닿는 박스. 풀지 못한 선은 §1-2. PowerPoint 로 내보낸 슬라이드 이미지와 눈으로 대조함', '', '```mermaid', 'flowchart LR']
    by_lane = collections.defaultdict(list)
    for s in order: by_lane[s['lane']].append(s)
    for i, (x, ln) in enumerate(lanes):
        if not by_lane.get(ln): continue
        M.append(f'  subgraph L{i}["{esc(ln)}"]')
        for s in sorted(by_lane[ln], key=lambda s: (s['y'], s['x'])):
            t = s['texts']; M.append(f'    S{s["seq"].replace("-", "_")}["{esc(s["seq"])}. {esc(t[0] if t else "")}<br/>{esc(t[1] if len(t) > 1 else "")}<br/>{esc(t[2] if len(t) > 2 else "")}"]')
        M.append('  end')
    for nid, lab in sorted(loose.items()):
        if any(e['ok'] and nid in (e['a'], e['b']) for e in edges): M.append(f'  {nid}{{"{esc(lab)}"}}')
    for e in edges:
        if not e['ok']: continue
        lab = f'|{e["label"]}|' if e['label'] else ''
        if e['arrow'] == 'end': M.append(f'  {e["a"]} -->{lab} {e["b"]}')
        elif e['arrow'] == 'start': M.append(f'  {e["b"]} -->{lab} {e["a"]}')
        else: M.append(f'  {e["a"]} ---{lab} {e["b"]}')
    M += ['```', '', '### 1-1. Seq 별 대응 — 통합테스트 · 화면 · 운영 잡 · 프로시저 · 대상 테이블', '',
          '- 대응 = 통합테스트 시나리오의 「시나리오 ID(PI n)」 칸 · 잡 스케줄 = 배치 목록의 운영 잡 시트', '',
          '| Seq | 레인 | 데이터 종류 | Activity | 시스템 | 통합테스트 | 화면 | 운영 잡(주기 · 시간) | 프로시저 | 대상 테이블 |', '|---|---|---|---|---|---|---|---|---|---|']
    pi_map = collections.defaultdict(list)
    for s in sc:
        for q in pi_seq_expand(s['pi'], order): pi_map[q].append(s)
    def job_names(text): return list(dict.fromkeys(re.findall(r'JOB\.[A-Za-z0-9_]+', text or '')))
    for s in order:
        rows = pi_map.get(s['seq'], []); t = s['texts']
        jobs = list(dict.fromkeys(j for r in rows for j in job_names(r['job'])))
        jtxt = '<br/>'.join(f"{j} ({sched_text(prod[j]) if j in prod else '운영 잡 시트에 없음'})" for j in jobs) or '-'
        prcs = list(dict.fromkeys(p.strip().replace('SCM_MGR.', '') for r in rows for p in r['prc'].split(' / ') if p.strip() and p.strip() != '-'))
        tg = list(dict.fromkeys(x.strip() for r in rows for x in r['tgt'].split(' / ') if x.strip() and x.strip() != '-'))
        scr = list(dict.fromkeys(i for r in rows for i in ids_in(r['screens'])))
        M.append(f"| {s['seq']} | {cellmd(s['lane'])} | {cellmd(t[0] if t else '')} | {cellmd(t[1] if len(t) > 1 else '')} | {cellmd(t[2] if len(t) > 2 else '')} | {', '.join(r['id'] for r in rows) or '-'} | {', '.join(scr) or '-'} | {jtxt} | {'<br/>'.join(prcs) or '-'} | {'<br/>'.join(tg) or '-'} |")
    bad = [e for e in edges if not e['ok']]
    M += ['', f'### 1-2. 그림에 넣지 않은 연결선({len(bad)})', '', '| 연결선 id | 사유 |', '|---|---|']
    for e in bad:
        why = e.get('why') or '끝 도형 미확정'
        M.append(f"| {e['id']} | {why} |")

    # §2 통합테스트 흐름
    stages = list(dict.fromkeys(s['stage'] for s in sc))
    M += ['', f'## 2. 통합테스트 흐름 {len(stages)}단계(업무 순서 · {len(sc)}건)', '']
    for r in summ:
        vals = [v for v in r.values() if v]
        if vals and vals[0] in ('범위', '구성', '근거 자료', 'JOB · 프로시저', '검증 방법'): M.append(f'- **{vals[0]}**: {cellmd(" ".join(vals[1:]))}')
    # 단계 띠(2026-11-11 인식성 보완): 가로 한 줄 Mermaid(폭 2,907px) 대신 5개씩 줄바꿈하는 단계 카드 — 클릭하면 그 단계의 시나리오 표가 열린다
    import ssp_cards as C
    cells = []
    for i, st in enumerate(stages):
        rows = [s for s in sc if s['stage'] == st]; kinds = collections.Counter(s['kind'] for s in rows)
        cells.append(f'<div class="spf-card" style="--c:#1f7a8c" data-k="IT:{C.esc(st.split()[0])}"><b>{C.esc(st)}</b><span>{len(rows)}건 · ' + C.esc(' · '.join(f'{k} {v}' for k, v in kinds.items())) + '</span></div>')
    M += ['', C.wrap(C.rows(cells, 5), 'spf-step'), '']
    for st in stages:
        rows = [s for s in sc if s['stage'] == st]
        M += [f'### {st} ({len(rows)}건)', '', '| 테스트ID | 세부 | PI | 구분 | 타임라인 | 스케줄 | 단계 | 사업부 | 화면 | 테스트명 | 운영 잡 · 프로시저 | 대상 테이블 |', '|---|---|---|---|---|---|---|---|---|---|---|---|']
        for s in rows:
            M.append(f"| {s['id']} | {cellmd(s['sub'])} | {cellmd(s['pi'])} | {s['kind']} | {cellmd(s['timeline'])} | {cellmd(s['schedule'])} | {cellmd(s['step'])} | {cellmd(s['div'])} | {', '.join(ids_in(s['screens'])) or '-'} | {cellmd(s['name'])} | {cellmd(s['job'])}<br/>{cellmd(s['prc'])} | {cellmd(s['tgt'])} |")
        M.append('')
    M += [f'### 사전 점검({len(pre)}건) — 시험 시작 전', '', '| 테스트ID | 점검 항목 | 화면 |', '|---|---|---|']
    for r in pre: M.append(f"| {r.get('테스트ID', '')} | {cellmd(r.get('점검 항목', ''))} | {cellmd(r.get('화면 ID', ''))} |")
    M += ['', '### 협의사항 · 수정 필요사항(자료 원문)', '', '| 구분 | No | 항목/UI | 내용 | 상태 |', '|---|---|---|---|---|']
    for r in iss:
        v = [r[f'c{i}'] for i in range(1, 10)]; nz = [x for x in v if x]
        if not nz or nz[0] in ('No',): continue
        if r['sheet'] == '협의사항': M.append(f"| 협의사항 | {nz[0]} | {cellmd(nz[1] if len(nz) > 1 else '')} | {cellmd(nz[2] if len(nz) > 2 else '')} | - |")
        else: M.append(f"| 수정 필요 | {v[0]} | {cellmd(v[1])} | {cellmd(v[2])} | {cellmd(v[4])} (접수 {cellmd(v[3])[:10]}) |")

    # §2 끝: V2 추가 시트(SO 오더타입 매핑 · 송신 컬럼 값 규칙) + 대조(케이스 ID 실존 · 송신 컬럼 = AS-IS 적재 SP INSERT 열)
    cross_v2 = []
    sor = rd('it_so_ordertype.csv'); sod = rd('it_so_ordertype_detail.csv'); snd = rd('it_send_rules.csv')
    ids_all = {x['id'] for x in sc}
    def case_ids(t):
        out_ = []
        for a, b in re.findall(r'(S\d{2}-\d{2})(?:\s*~\s*(S\d{2}-\d{2}))?', t or ''):
            if b and a[:3] == b[:3]:
                out_ += [f'{a[:4]}{n:02d}' for n in range(int(a[4:]), int(b[4:]) + 1)]
            else: out_.append(a)
        return out_
    ins_cols = set(); ins_sp = []
    mdir = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules')
    if os.path.isdir(mdir):
        for fn in os.listdir(mdir):
            if not fn.lower().endswith('.sql'): continue
            body = io.open(os.path.join(mdir, fn), encoding='utf-8', errors='replace').read()
            body = re.sub(r'/\*.*?\*/', ' ', body, flags=re.S); body = re.sub(r'--[^\n]*', ' ', body)
            hit = False
            for m in re.finditer(r'(?is)INSERT\s+INTO\s+(?:\[?dbo\]?\.)?\[?XIF_ERP_SHIP_PLAN_CONFIRM_S_SN\]?\s*\(([^)]*)\)', body):
                ins_cols |= {c.strip().strip('[]').upper() for c in m.group(1).split(',') if c.strip()}; hit = True
            if hit: ins_sp.append(fn[4:-4])
    if sor or snd:
        M += ['', '### 2-1. ERP 송신 규칙(V2 추가 시트 · 원문)', '']
    if sor:
        M += [f"#### SO 오더타입 매핑 — {cellmd(sor[0]['block_title'])}", '']
        hd = [k for k in sor[0].keys() if k != 'block_title']
        M += ['| ' + ' | '.join(hd) + ' | 케이스 실존 |', '|' + '---|' * (len(hd) + 1)]
        for r in sor:
            cs = case_ids(r.get('케이스', '')); miss = [c for c in cs if c not in ids_all]
            M.append('| ' + ' | '.join(cellmd(r[k]) for k in hd) + f" | {'있음 ' + str(len(cs)) if not miss else '없음 ' + ', '.join(miss)} |")
        if sod:
            M += ['', f"- 상세 {len(sod)}행({cellmd(sod[0]['block_title'])[:80]}) · 사업부별 오더타입 수: " + ', '.join(f"{d} {len({x['오더타입'] for x in sod if x['사업부'] == d})}" for d in dict.fromkeys(x['사업부'] for x in sod)) + ' · 원문 행은 `Doc/asisfacts/ref_ssp/it_so_ordertype_detail.csv`']
        M.append('')
    if snd:
        M += [f"#### 송신 컬럼 값 규칙 — {cellmd(snd[0]['block_title'])}", '',
              f"- 대조 1 = 규칙의 송신 컬럼 이름이 AS-IS SP 본문의 `INSERT INTO XIF_ERP_SHIP_PLAN_CONFIRM_S_SN (…)` 열 목록에 있는지(적재 SP {len(ins_sp)}개 · 열 {len(ins_cols)}종). 대조 2 = 케이스 ID 가 통합 시나리오에 있는지. 한글 이름(회사 · Site …, 항구)은 대조하지 않음. 축약 표기(접두 생략 · ETD/ETA)는 적재 열 이름으로 풀어 대조하고 푼 내용을 표에 적음", '',
              '| 송신 컬럼 | 값 결정 규칙 | 값 유형 | 케이스 | AS-IS 적재 열 | 케이스 실존 |', '|---|---|---|---|---|---|']
        for r in snd:
            col = r.get('송신 컬럼', '')
            names = []
            for part in re.split(r'\s*[·,]\s*|\s+/\s+', col):
                m = re.fullmatch(r'([A-Z]+)/([A-Z]+)(_[A-Z0-9_]+)', part.strip())
                if m: names += [m.group(1) + m.group(3), m.group(2) + m.group(3)]
                elif re.fullmatch(r'[A-Z][A-Z0-9_]{2,}', part.strip()): names.append(part.strip())
            # 축약 표기 풀기(2026-11-16 실측): ① 'TO_SITE_SOLDTO_CODE / SHIPTO_CODE' = 앞 이름의 접두(TO_SITE_)를 생략 ② 'ETD' · 'ETA' = 적재 열 ETD_DATE · ETA_DATE. 풀린 이름은 표에 '표기 → 열' 로 적는다
            alias = {}
            for i_, n in enumerate(names):
                if n in ins_cols: continue
                cand = []
                if i_:
                    pv = names[i_ - 1]; k_ = len(n.split('_')); pre = '_'.join(pv.split('_')[:-k_]) if len(pv.split('_')) > k_ else ''
                    if pre and f'{pre}_{n}' in ins_cols: cand = [f'{pre}_{n}']
                if not cand:
                    cand = [c for c in ins_cols if c == n + '_DATE'] or [c for c in ins_cols if c.endswith('_' + n)]
                if len(cand) == 1: alias[n] = cand[0]
            ok_ = [n for n in names if n in ins_cols or n in alias]; ng_ = [n for n in names if n not in ins_cols and n not in alias]
            cs = case_ids(r.get('케이스', '')); miss = [c for c in cs if c not in ids_all]
            colv = ('-' if not names else (f"있음 {len(ok_)}" + (f" (표기 → 열: {', '.join(f'{a} → {b}' for a, b in alias.items())})" if alias else '') + (f" · 없음 {', '.join(ng_)}" if ng_ else '')))
            M.append(f"| {cellmd(col)} | {cellmd(r.get('값 결정 규칙', ''))} | {cellmd(r.get('값 유형', ''))} | {cellmd(r.get('케이스', ''))} | {colv} | {('있음 ' + str(len(cs))) if cs and not miss else ('-' if not cs else '없음 ' + ', '.join(miss))} |")
            for n in ng_: cross_v2.append(['send_rule', col, '송신 컬럼 — AS-IS 적재 INSERT 열에 없음', n])
            for c in miss: cross_v2.append(['send_rule', col, '케이스 ID — 통합 시나리오에 없음', c])
        M += ['', f"- AS-IS 적재 SP: {', '.join(sorted(ins_sp))}", '']
    # §3 화면 ↔ PI ↔ 통합테스트
    links, issues = screen_links()
    M += ['', '## 3. 화면별 연계 — PI Seq · 통합테스트 · 수정 필요사항', '', '| 화면 | 이름 | PI Seq | 통합테스트(흐름 단계) | 수정 필요사항 |', '|---|---|---|---|---|']
    link_rows = []
    for sid in sorted(links):
        tests = links[sid]; pis = list(dict.fromkeys(q for t in tests for q in pi_seq_expand(t[2], order)))
        M.append(f"| {sid} | {cellmd(scr_name(sid))} | {', '.join(pis) or '-'} | {'<br/>'.join(f'{t[0]} {cellmd(t[1])}' for t in tests)} | {'<br/>'.join(cellmd(a) + ' — ' + cellmd(b) for a, b in issues.get(sid, [])) or '-'} |")
        for t in tests: link_rows.append([sid, scr_name(sid), t[0], t[1], t[2], t[3]])
    with io.open(os.path.join(out_dir, 'ssp_ref_screen_links.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(['screen_id', 'screen_name', 'test_id', 'flow_stage', 'pi', 'test_name']); w.writerows(link_rows)

    # §4 운영 잡 스케줄(SSP)
    ssp_jobs = sorted([(j, rows) for j, rows in prod.items() if any('SSP' in x['module'] for x in rows)], key=lambda kv: kv[0])
    tt = [r for r in rd('prod_job_timetable.csv') if 'SSP' in r['module'] or r['job'] in dict(ssp_jobs)]
    M += ['', f'## 4. 운영 잡 스케줄 — SSP({len(ssp_jobs)}잡 · 운영 LGCE_SCMPROD 기준)', '',
          f'- 출처 = {SRC_NAMES["batch"]} 시트 JOB-Daily&Weekly · JOB-RealTime · JOB-Monthly · Job 시간대별 실행 요일. DEV msdb 복제본에는 없던 운영 주기·시각이다', '',
          '### 4-1. 시각 지정 잡(시각순)', '', '| 시각 | 잡 | 월 | 화 | 수 | 목 | 금 | 토 | 일 | 호출 프로시저 |', '|---|---|---|---|---|---|---|---|---|---|']
    def tkey(t):
        m = re.match(r'(\d+):(\d+)', t or ''); return (int(m.group(1)), int(m.group(2))) if m else (99, 99)
    for r in sorted(tt, key=lambda r: (tkey(r['time']), r['job'])):
        call = '<br/>'.join(dict.fromkeys(x['call'].replace(' / ', '<br/>') for x in prod.get(r['job'], [])))
        M.append(f"| {r['time']} | {r['job']} | {r['mon']} | {r['tue']} | {r['wed']} | {r['thu']} | {r['fri']} | {r['sat']} | {r['sun']} | {call or '-'} |")
    M += ['', '### 4-2. 주기 반복 잡(RealTime)', '', '| 잡 | I/F | 주기 | 시간 | 호출 프로시저 | 비고 |', '|---|---|---|---|---|---|']
    for j, rows in ssp_jobs:
        for x in rows:
            if x['sheet'] == 'RealTime': M.append(f"| {j} | {x['if'] or '-'} | {x['cycle']} | {x['time']} | {x['call'].replace(' / ', '<br/>')} | {cellmd(x['note']) or '-'} |")
    M += ['', '### 4-3. 잡 → 프로시저 호출 트리(SSP 잡)', '', '| 잡 | 깊이 | 구분 | 프로시저 | 호출 인자 |', '|---|---|---|---|---|']
    for r in rd('prod_job_calltree.csv'):
        if r['job'] in dict(ssp_jobs): M.append(f"| {r['job']} | {r['depth']} | {r['call_kind']} | {cellmd(r['procedure'])} | {cellmd(r['args'])} |")

    # §5 PPT 배치별 입출력
    _sl_all = ppt_slides(); _rng = f"{_sl_all[0]['slide']}~{_sl_all[-1]['slide']}" if _sl_all else '-'
    conds = run_conditions(); pj = proc_jobs(prod)
    M += ['', f'## 5. 배치별 입출력 · 처리 규칙 — {SRC_NAMES["ppt"]} {_rng}번 슬라이드(2026-11-16 판 · 9장)', '',
          '### 5-0. 프로세스 진행 조건 — 배치가 실제로 계획을 만들기 전에 확인하는 것(2026-11-16 판에 추가된 「■ 프로세스 진행여부 체크 기준」)', '',
          '- 소속 규칙: 체크 패널이 있는 슬라이드는 패널 안 「- 프로시저」 줄 또는 「- 프로세스 진행여부 체크 -」 표지에 가장 가까운 머리 상자 · 패널이 없는 슬라이드는 같은 세로 줄 바로 위(없으면 가장 가까운) 머리 상자 · 운영 잡 = 배치 목록 운영 잡 시트 + 잡 호출 트리', '',
          '| 슬라이드 | 프로시저 | 운영 잡(주기 · 시각) | 진행 조건(원문 순서) | 소속 판정 |', '|---|---|---|---|---|']
    for c in conds:
        jb = '<br/>'.join(f"{j} ({cy} {tm})".strip() for j, cy, tm in pj.get(c['proc'].upper(), [])) or '배치 목록 잡 시트에 없음'
        M.append(f"| {c['slide']} | {c['proc'] or '(소속 미확인)'} | {cellmd(jb)} | {'<br/>'.join(cellmd(i) for i in c['items'])} | {c['how']} |")
    M += ['', f"- 진행 조건 묶음 {len(conds)} · 소속 미확인 {sum(1 for c in conds if not c['proc'])}", '']
    with io.open(os.path.join(out_dir, 'ssp_ref_run_conditions.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w_ = csv.writer(f); w_.writerow(['slide', 'procedure', 'jobs', 'conditions', 'owner_rule'])
        for c in conds: w_.writerow([c['slide'], c['proc'], ' | '.join(f'{j} ({cy} {tm})' for j, cy, tm in pj.get(c['proc'].upper(), [])), ' | '.join(c['items']), c['how']])
    M += ['### 5-1. 슬라이드별 입출력', '',
          '- 슬라이드 그림 규칙(PowerPoint 이미지로 확인): 프로시저 머리 상자 아래에 「원천 테이블(묶음) → 대상 테이블(묶음)」 화살표. 화살표의 소속 프로시저 = 같은 세로 줄에서 바로 위 머리 상자(슬라이드 배치 기준). 설명 문구는 원문 그대로', '']
    slide_procs = collections.defaultdict(set); ppt_rows = []
    for sl in _sl_all:
        for p_ in sl['procs']: slide_procs[p_.upper()].add(sl['slide'])
        M += [f"#### 슬라이드 {sl['slide']} — {cellmd(' · '.join(sl['titles']) or '(제목 문구 없음)')}", '',
              f"- 프로시저 {len(set(sl['procs']))} · 연결선 {sl['n_conn']} → 입출력 화살표 {len(sl['rows'])} · 풀지 못한 선 {len(sl['unresolved'])}", '']
        if sl['rows']:
            M += ['```mermaid', 'flowchart LR']; seen = set()
            def nd(k, tabs_):
                nid = f'N{sl["slide"]}_{k}'
                if nid not in seen: seen.add(nid); M.append(f'  {nid}[("' + '<br/>'.join(esc(t) for t in tabs_) + '")]')
                return nid
            for r in sl['rows']:
                a_ = nd(r['a'], r['src']); b_ = nd(r['b'], r['tgt']); lab = f'|"{esc(r["proc"])}"|' if r['proc'] else ''
                M.append(f'  {a_} -->{lab} {b_}' if r['arrow'] else f'  {a_} ---{lab} {b_}')
            M += ['```', '']
            M += ['| 소속 프로시저(바로 위 머리 상자) | 원천 테이블 | 대상 테이블 | 선 판정 |', '|---|---|---|---|']
            for r in sl['rows']:
                M.append(f"| {r['proc'] or '(머리 상자 없음)'} | {', '.join(r['src'])} | {', '.join(r['tgt'])} | {r['how']} |"); ppt_rows.append((sl['slide'], r))
            M.append('')
        no_arrow = [p_ for p_ in dict.fromkeys(sl['procs']) if p_ not in {r['proc'] for r in sl['rows']}]
        if no_arrow: M += [f"- 화살표 없이 머리 상자만 있는 프로시저: {', '.join(no_arrow)}"]
        if sl['lone_tabs']: M += [f"- 화살표에 연결되지 않은 테이블 문구: {'; '.join(cellmd(t) for t in sl['lone_tabs'])}"]
        if sl['unresolved']: M += ['- 도형에 붙지 않은 선(구역 구분선 등): ' + ' / '.join(f"{u['id']}({u['why']})" for u in sl['unresolved'])]
        if sl['tables']:
            n_ = max(len(r) for r in sl['tables'])
            M += ['', '슬라이드 안 표(원문):', '', '| ' + ' | '.join(f'칸{i + 1}' for i in range(n_)) + ' |', '|' + '---|' * n_] + ['| ' + ' | '.join(cellmd(c) for c in (r + [''] * n_)[:n_]) + ' |' for r in sl['tables']]
            for r in sl['tables']:
                for c in r:
                    if RX_PROC.match(c.strip()): slide_procs[c.strip().upper()].add(sl['slide'])
        M += ['', '| 설명 문구(원문 · 위 → 아래) |', '|---|'] + [f'| {cellmd(t)} |' for t in sl['notes']] + ['']

    # §6 교차검증
    M += ['## 6. 교차검증 — 기존 자료 ↔ 이 저장소 분석', '']
    cross = list(cross_v2)  # §2-1 V2 송신 규칙 대조 결과 포함
    # (a) 운영 잡 ↔ DEV msdb
    inv_p = os.path.join(out_dir, 'ssp_batch_inventory.csv'); dev_jobs = set()
    if os.path.exists(inv_p):
        with io.open(inv_p, encoding='utf-8-sig', newline='') as f:
            for r in csv.DictReader(f):
                if r['category'].startswith('SSP 배치') and not r['job_name'].startswith('SYSTEMEXE'): dev_jobs.add(r['job_name'])
    prod_ssp = {j for j, _ in ssp_jobs}
    only_prod = sorted(prod_ssp - dev_jobs); only_dev = sorted(dev_jobs - prod_ssp)
    M += ['### 6-1. 운영 잡 목록 ↔ DEV msdb 잡(SSP 배치)', '',
          f"- 운영 목록(SSP 모듈) {len(prod_ssp)} · DEV msdb SSP 배치 {len(dev_jobs) if dev_jobs else '미생성(ssp_batch_flow.py 먼저 실행)'} · 양쪽 모두 {len(prod_ssp & dev_jobs)}",
          f"- 운영 목록에만: {', '.join(only_prod) or '없음'}", f"- DEV msdb 에만: {', '.join(only_dev) or '없음'}", '']
    for j in only_prod: cross.append(['job', j, '운영 목록에만', sched_text(prod[j])])
    for j in only_dev: cross.append(['job', j, 'DEV msdb 에만', ''])
    # (b) 자료에 나온 프로시저의 AS-IS 존재
    mod_dir = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules'); mods = {f[4:-4].upper() for f in os.listdir(mod_dir) if f.lower().endswith('.sql')} if os.path.isdir(mod_dir) else set()
    ref_procs = collections.defaultdict(set)
    for p_, sls in slide_procs.items(): ref_procs[p_].add('PPT 슬라이드 ' + ','.join(str(x) for x in sorted(sls)))
    for s in sc:
        for p_ in re.findall(r'SCM_MGR\.([A-Z0-9_]+)', s['prc']): ref_procs[p_].add('통합테스트 ' + s['id'])
    for j, rows in ssp_jobs:
        for x in rows:
            for p_ in re.split(r'\s*/\s*', x['call']):
                if re.match(r'^[A-Z][A-Z0-9_]+$', p_.strip()): ref_procs[p_.strip()].add('운영 잡 ' + j)
    miss = sorted(p_ for p_ in ref_procs if p_ not in mods and not p_.startswith('PKG_'))
    pkgs = sorted(p_ for p_ in ref_procs if p_.startswith('PKG_'))
    M += ['### 6-2. 자료에 나온 프로시저 ↔ AS-IS DB 모듈 추출본', '',
          f'- 자료에 나온 프로시저 {len(ref_procs)}종(TO-BE 패키지 {len(pkgs)} 포함) · AS-IS 모듈 추출본(`Doc/asisfacts/db/modules`)에 없는 것 {len(miss)}', '']
    if miss:
        M += ['| 프로시저 | 자료 출처 | 배치 목록 상태(TO-BE 개발서버 10-28) |', '|---|---|---|']
        for p_ in miss:
            b = bl.get(p_, {}); M.append(f"| {p_} | {'; '.join(sorted(ref_procs[p_]))[:200]} | {b.get('dev_ora_1028', '목록에 없음') or '-'} |"); cross.append(['proc', p_, 'AS-IS 모듈 추출본에 없음', '; '.join(sorted(ref_procs[p_]))])
        M.append('')
    # (c) 시나리오 대상 테이블 ↔ SP 본문 쓰기 테이블
    M += ['### 6-3. 통합테스트 대상 테이블 ↔ AS-IS SP 본문 쓰기 테이블', '',
          '- 시나리오 「TGT 테이블」과, 같은 행 프로시저의 AS-IS 본문에서 찾은 쓰기 대상(중첩 호출 깊이 3)을 대조. 이름 끝 `_SN`(시노님)은 떼고 비교. TO-BE 화면 패키지(PKG_화면ID)는 그 화면의 AS-IS 화면 SP 가 쓰는 테이블로 대조', '',
          '| 테스트ID | 대조한 AS-IS 프로시저 · 화면 | 양쪽 일치 | 시나리오에만 | 본문 파싱에만(로그 표 제외) |', '|---|---|---|---|---|']
    n_cmp = 0
    scr_writes = collections.defaultdict(set)  # 화면 → AS-IS 화면 SP 가 쓰는 테이블(ssp_flow 산출)
    sst = os.path.join(out_dir, 'ssp_screen_sp_table.csv')
    if os.path.exists(sst):
        with io.open(sst, encoding='utf-8-sig', newline='') as f:
            for r in csv.DictReader(f):
                if r['rw'] == 'W' and r['table']: scr_writes[r['screen_id']].add(norm_tab(r['table']))
    if parse_sp:
        for s in sc:
            prcs = [p_ for p_ in re.findall(r'SCM_MGR\.([A-Z0-9_]+)', s['prc']) if not p_.startswith('PKG_') and p_ in mods]
            pk_scr = [q[4:] for q in re.findall(r'SCM_MGR\.(PKG_[A-Z]{3}\d{4})', s['prc'])]  # TO-BE 화면 패키지 → 같은 화면의 AS-IS 화면 SP 쓰기로 대조
            tg = {norm_tab(t) for t in tgt_tables(s['tgt'])}
            if not (prcs or pk_scr) or not tg: continue
            wr = set()
            for p_ in prcs:
                info = parse_sp(p_); wr |= {norm_tab(t) for t in info['writes'] if (objs is None or t in objs)}
            for q in pk_scr: wr |= scr_writes.get(q, set())
            prcs = prcs + [f'화면 {q} 저장 SP' for q in pk_scr]
            wr = {t for t in wr if not re.search(r'_LOG|SYS_LOG', t)}
            both = sorted(tg & wr); only_s = sorted(tg - wr); only_p = sorted(wr - tg); n_cmp += 1
            M.append(f"| {s['id']} | {', '.join(prcs)} | {', '.join(both) or '-'} | {', '.join(only_s) or '-'} | {', '.join(only_p) or '-'} |")
            for t in only_s: cross.append(['table', s['id'], '시나리오 TGT 에만(본문 파싱 쓰기 없음)', t])
            for t in only_p: cross.append(['table', s['id'], '본문 파싱 쓰기에만', t])
    M += ['', f'- 대조한 시나리오 {n_cmp}건. 「시나리오에만」 = 동적 SQL·깊이 4 이상 호출·TO-BE 에서 바뀐 이름일 수 있어 원인 확인 대상 · 「본문 파싱에만」 = 시나리오가 검증 대상으로 잡지 않은 부수 쓰기', '']
    # (c2) PPT 입출력 ↔ SP 본문
    M += ['### 6-4. 프로세스 PPT 입출력 ↔ AS-IS SP 본문', '',
          '- PPT 화살표의 「대상 테이블」이 그 프로시저 본문의 쓰기 대상에, 「원천 테이블」이 읽기 대상에 있는지 대조(중첩 호출 깊이 3 · 이름 끝 `_SN` 제외 비교)', '',
          '| 슬라이드 | 프로시저 | 대상(쓰기) 일치 | 대상 — 본문에 없음 | 원천(읽기) 일치 | 원천 — 본문에 없음 |', '|---|---|---|---|---|---|']
    n_ppt = 0
    if parse_sp:
        for sno_, r in ppt_rows:
            p_ = r['proc'].upper()
            if not p_ or p_ not in mods: continue
            info = parse_sp(p_); wr = {norm_tab(t) for t in info['writes']}; rdx = {norm_tab(t) for t in info['reads']} | wr
            tg = [norm_tab(t) for t in r['tgt']]; sr = [norm_tab(t) for t in r['src']]; n_ppt += 1
            M.append(f"| {sno_} | {p_} | {', '.join(t for t in tg if t in wr) or '-'} | {', '.join(t for t in tg if t not in wr) or '-'} | {', '.join(t for t in sr if t in rdx) or '-'} | {', '.join(t for t in sr if t not in rdx) or '-'} |")
            for t in tg:
                if t not in wr: cross.append(['ppt', f'슬라이드 {sno_} {p_}', 'PPT 대상 테이블 — 본문 쓰기에 없음', t])
            for t in sr:
                if t not in rdx: cross.append(['ppt', f'슬라이드 {sno_} {p_}', 'PPT 원천 테이블 — 본문 읽기에 없음', t])
    M += ['', f'- 대조한 화살표 {n_ppt}개', '']
    # (c3) 진행 조건 문구 ↔ SP 본문 — 조건에 나온 테이블 이름 · '룩업'(SCM_ADM_LOOKUP_MASTER_DETAIL)이 그 프로시저 본문(깊이 3)에 있는지
    M += ['### 6-5. 프로세스 진행 조건(5-0) ↔ AS-IS SP 본문', '',
          "- 조건 문구에 나온 테이블 이름과 '룩업'(= `SCM_ADM_LOOKUP_MASTER_DETAIL`)이 그 프로시저 본문의 읽기·쓰기 대상에 있는지 대조. 조건의 논리(건수 비교·당일 여부)는 본문 판독 대상이라 여기서는 대상 객체만 본다", '',
          '| 슬라이드 | 프로시저 | 조건에 나온 객체 | 본문에 있음 | 본문에 없음 |', '|---|---|---|---|---|']
    n_cd = 0
    if parse_sp:
        for c in conds:
            p_ = c['proc'].upper()
            if not p_ or p_ not in mods: continue
            txt = ' '.join(c['items']); need = [t for t in dict.fromkeys(re.findall(r'\b([A-Z][A-Z0-9]*_[A-Z0-9_]{3,})\b', txt)) if not RX_PROC.match(t) and not t.startswith(('V_', 'CUTOFF_', 'PLANT_', 'DIVISION_'))]
            if re.search(r'룩업|Look ?up', txt, re.I): need.append('SCM_ADM_LOOKUP_MASTER_DETAIL')
            if not need: continue
            info = parse_sp(p_); al = {norm_tab(t) for t in info['reads']} | {norm_tab(t) for t in info['writes']}
            ok_ = [t for t in need if norm_tab(t) in al]; ng_ = [t for t in need if norm_tab(t) not in al]; n_cd += 1
            M.append(f"| {c['slide']} | {p_} | {', '.join(need)} | {', '.join(ok_) or '-'} | {', '.join(ng_) or '-'} |")
            for t in ng_: cross.append(['cond', f"슬라이드 {c['slide']} {p_}", '진행 조건 객체 — 본문에 없음', t])
    M += ['', f'- 대조한 진행 조건 묶음 {n_cd}', '']
    # (d) TO-BE 객체 상태
    ssp_bl = [r for r in bl.values() if r['module'] == 'SSP']
    inval = sorted(r['procedure'] for r in ssp_bl if (r['dev_ora_1028'] or '').upper() not in ('VALID', ''))
    M += ['### 6-6. TO-BE 객체 상태 — 배치 목록(개발서버 Oracle 10-28 확인분)', '',
          f"- SSP 프로시저 {len(ssp_bl)} · VALID {sum(1 for r in ssp_bl if (r['dev_ora_1028'] or '').upper() == 'VALID')} · VALID 아님 {len(inval)} · I/F 수신(R) {sum(1 for r in ssp_bl if r['if'] == 'R')} · 송신(S) {sum(1 for r in ssp_bl if r['if'] == 'S')} · 잡 관련 {sum(1 for r in ssp_bl if r['job_related'] == 'Y')} · UI 연계 {sum(1 for r in ssp_bl if r['ui_linked'] == 'Y')}",
          f"- VALID 아님: {', '.join(inval) or '없음'}", '- 통합테스트 「수정 필요사항」 1번(11-09 접수)의 컴파일 오류 8건과는 확인 시점이 달라 목록이 다를 수 있음 — 두 목록을 그대로 병기', '']
    with io.open(os.path.join(out_dir, 'ssp_ref_crosscheck.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(['kind', 'key', 'finding', 'detail']); w.writerows(cross)
    io.open(os.path.join(out_dir, 'SSP_REF_PROCESS.md'), 'w', encoding='utf-8', newline='\n').write('\n'.join(M) + '\n')
    return {'steps': len(order), 'edges_ok': sum(1 for e in edges if e['ok']), 'edges': len(edges), 'scenarios': len(sc), 'ssp_jobs': len(ssp_jobs), 'only_prod': len(only_prod), 'only_dev': len(only_dev), 'ref_procs': len(ref_procs), 'miss': len(miss), 'cmp': n_cmp, 'cross': len(cross), 'conds': len(conds), 'ppt_slides': len(_sl_all)}
