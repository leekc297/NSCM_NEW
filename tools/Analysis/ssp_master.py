# -*- coding: utf-8 -*-
"""
SSP 한눈에 보기(SSP_OVERVIEW.md) 생성 (2026-11-16)
원천:
  ① Standard Information SSP Manual 1.pptx → Doc/asisfacts/ref_ssp/manual_*.csv (ssp_ref_extract.py --manual)
     1번 슬라이드 Master Flow: 단계 상자 10 · 연결선 9 · 담당 팀 = 상자 채움 색을 범례 색에 대조(가장 가까운 색)
     2~11번 슬라이드: 화면별 메뉴·UI 정의·설명·Key Point·자주 받는 문의(원문)
  ② SSP 프로세스 확인 내용.pptx(2026-11-20 판 · 8번 사업부별 계획기준 추가) → ssp_ref.ppt_slides · run_conditions · proc_jobs(운영 잡 주기)
  ③ Doc/tobefacts/db/menu.csv(TO-BE 화면 ID) · Doc/asisfacts/screens/<화면>/endpoints.csv(AS-IS 화면 → SP) · SP 본문(parse_sp)
검증: 단계 화살표(A → B)마다 A 화면 SP 가 쓰는 테이블을 B 화면 SP 가 읽는지 AS-IS SP 본문으로 대조한다.
      Manual 문구 중 저장소에서 확인되는 것(BOD ITEM 30분 자동 생성 = 운영 잡 주기 · BOD Required 계산 원천 = SCP0007_GET_BOD 읽기 테이블)은 확인 결과를 같이 적는다.
문장: 원문 인용은 그대로 · 생성 문장은 문장 규칙(50_DOC_STYLE.md)을 따른다.
"""
import os, io, re, csv, time, collections
import ssp_ref as R
import ssp_cards as C

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
MENU = os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'menu.csv')
SCREENS = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens')
SRC_MANUAL = 'Standard Information SSP Manual 1.pptx'
# 범례 문구 → 카드 색(화면 표시용). 팀 판정은 PPT 채움 색으로 하고 이 표는 표시 색만 정한다
TEAM_COLOR = {'마케팅팀 관리': '#b7860b', 'SCP PI 관리': '#c0602a', 'SCM팀 관리': '#4e8f4a', '물류기획팀 관리': '#3a6ea5', '시스템 자동 설정': '#5b6770', '': '#7b52b8'}
STEP_SYSTEM_PROC = {'BOD ITEM': 'PR_SCP_MST_BOD_ITEM'}  # 시스템 자동 단계의 생성 배치(운영 잡 목록에서 주기 확인)


def available(): return os.path.exists(os.path.join(R.REF, 'manual_shapes.csv'))


def _rgb(h): return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4)) if h and len(h) == 6 else None


def _norm(s): return re.sub(r'[^a-z0-9]', '', (s or '').lower())


def master_flow():
    """1번 슬라이드 → steps[{no,name,sub,team,team_dist,fill}] · edges[(no_a,no_b,how)] · note(원문)"""
    sh = [x for x in R.rd('manual_shapes.csv') if x['slide'] == '1']
    by_group = collections.defaultdict(list)
    for x in sh: by_group[x['group']].append(x)
    legend = []
    for x in sh:
        if x['text'].endswith('관리') or x['text'] == '시스템 자동 설정':
            chip = [y for y in by_group[x['group']] if not y['text'] and y['fill']]
            if chip: legend.append((x['text'], chip[0]['fill']))
    steps = []
    for x in sh:
        m = re.match(r'^(\d+)\.\s*(.*)$', x['text'])
        if not m: continue
        fill = x['fill'] or (next((y['fill'] for y in by_group[x['group']] if not y['text'] and y['fill']), '') if x['group'] else '')
        body = m.group(2).replace(' / ', ' ').strip()
        nm = re.split(r'\(', body)[0].strip(); sub = body[len(nm):].strip().strip('()').strip()
        team, dist = '', None
        if _rgb(fill):
            a = _rgb(fill)
            cand = sorted(((sum((p - q) ** 2 for p, q in zip(a, _rgb(c))) ** 0.5, t) for t, c in legend if _rgb(c)))
            if cand: dist, team = round(cand[0][0]), cand[0][1]
        steps.append({'no': int(m.group(1)), 'id': x['id'], 'name': nm, 'sub': re.sub(r'\s+', ' ', sub), 'team': team, 'team_dist': dist, 'fill': fill})
    steps.sort(key=lambda s: s['no']); id2no = {s['id']: s['no'] for s in steps}
    edges = []
    for c in R.rd('manual_connectors.csv'):
        if c['slide'] != '1': continue
        a, b = id2no.get(c['start_id']), id2no.get(c['end_id'])
        if a and b:
            if c['arrow_at_start'] == 'Y' and c['arrow_at_end'] != 'Y': a, b = b, a
            edges.append((a, b, f"{c['start_by']}/{c['end_by']} · 끝점 거리 {c['start_dist_emu']}/{c['end_dist_emu']} EMU"))
    notes = [x['text'] for x in sh if not re.match(r'^\d+\.', x['text']) and len(x['text']) > 40]
    return steps, edges, legend, notes


def manual_pages():
    """2~11번 슬라이드 → [{slide, menu, ui, author, date, ui_def, keypoint, desc, faq_text}] (원문)"""
    tb = collections.defaultdict(dict)
    for t in R.rd('manual_tables.csv'): tb[(t['slide'], t['frame_id'], int(t['row']))][int(t['col'])] = t['text']
    sh = R.rd('manual_shapes.csv'); out = []
    for sno in sorted({int(x['slide']) for x in sh}):
        if sno == 1: continue
        rows = {k: v for k, v in tb.items() if k[0] == str(sno)}
        kv = {}
        for k, r in rows.items():
            cells = [r[c] for c in sorted(r)]
            for i in range(0, len(cells) - 1, 2):
                if cells[i]: kv[cells[i].strip()] = cells[i + 1].strip()
        long_ = sorted([x for x in sh if x['slide'] == str(sno) and len(x['text']) > 40], key=lambda x: int(x['x'] or 0))
        faq = [x['text'] for x in long_ if int(x['x'] or 0) < 2000000]   # 왼쪽 메모 상자(자주 받는 문의)
        desc = [x['text'] for x in long_ if int(x['x'] or 0) >= 2000000]  # 오른쪽 설명 상자
        out.append({'slide': sno, 'menu': kv.get('메뉴', ''), 'ui': kv.get('UI 명', ''), 'author': kv.get('작성자', ''), 'date': kv.get('날짜', ''), 'ui_def': kv.get('UI 정의', ''),
                    'keypoint': kv.get('Key Point', ''), 'desc': ' / '.join(desc), 'faq_text': ' / '.join(faq)})
    return out


def qa_pairs(text):
    """'Q. … A. …' 원문 → [(질문, 답)] · 'A1.' 'A2.' 는 한 답으로 잇는다"""
    out = []
    for blk in re.split(r'Q\.\s*', text or '')[1:]:
        parts = re.split(r'A\d?\.\s*', blk)
        q = parts[0].strip(); a = ' '.join(p.strip() for p in parts[1:] if p.strip())
        out.append((re.sub(r'\s+', ' ', q), re.sub(r'\s+', ' ', a)))
    return out


def menu_screens():
    rows = []
    with io.open(MENU, encoding='utf-8-sig', newline='') as f:
        for r in csv.DictReader(f):
            if r['use_yn'] == 'Y' and r['mnu_tp_cd'] == 'SCREEN': rows.append(r)
    return rows


_MATRIX = None


def _matrix():
    """_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx 화면_SP_Tables_매트릭스 → {화면 ID 원문: [SP 실명]}"""
    global _MATRIX
    if _MATRIX is None:
        _MATRIX = collections.defaultdict(list)
        p = os.path.join(ROOT, '_analysis', 'Screen_POPUP_SP_Tables_Matrix.xlsx')
        if os.path.exists(p):
            import openpyxl
            ws = openpyxl.load_workbook(p, read_only=True)['화면_SP_Tables_매트릭스']; hdr = None
            for row in ws.iter_rows(values_only=True):
                if hdr is None: hdr = [str(c or '') for c in row]; continue
                r = dict(zip(hdr, row)); sp = str(r.get('SP 실명') or '').strip()
                if sp and re.match(r'^[A-Za-z0-9_]+$', sp) and sp != 'Bare': _MATRIX[str(r.get('화면 ID') or '')].append(sp.upper())
    return _MATRIX


def screen_sps(sid):
    """AS-IS 화면 → SP = ① endpoints.csv SP 행 ② actions.csv 의 QueryId 값 ③ 매트릭스(화면 ID 가 '<sid>_' 로 시작) 합집합.
    ②는 SCP0006 처럼 QueryId 를 분기마다 바꾸는 화면에서 endpoints 가 SP 를 못 잡은 경우(2026-11-16 실측 SCP0006 endpoints SP 0건)를 메운다.
    매트릭스에만 있고 commented_calls.csv 에 있는 SP 는 제외(ssp_flow.py 11-10 규칙과 같음). → ({sp: 출처집합}, 제외 목록)"""
    out = collections.defaultdict(set)
    for r in _rd(os.path.join(SCREENS, sid, 'endpoints.csv')):
        m = re.match(r'^SP\s+([A-Za-z0-9_.]+)', r.get('sp_or_sql') or '')
        if m: out[m.group(1).split('.')[-1].upper()].add('endpoints')
    for r in _rd(os.path.join(SCREENS, sid, 'actions.csv')):
        if (r.get('target') or '').endswith('QueryId'):
            m = re.search(r'"([A-Za-z]+\.)?([A-Za-z0-9_]+)"', r.get('value') or '')
            if m: out[m.group(2).upper()].add('actions')
    com = {((r.get('key') or r.get('candidate') or '').split('.')[-1].upper()) for r in _rd(os.path.join(SCREENS, sid, 'commented_calls.csv'))}
    dropped = []
    for k, sps in _matrix().items():
        if k == sid or k.startswith(sid + '_'):
            for sp in sps:
                if sp in com and sp not in out: dropped.append(sp); continue
                out[sp].add('matrix')
    return dict(out), sorted(set(dropped))


def _rd(p):
    if not os.path.exists(p): return []
    with io.open(p, encoding='utf-8-sig', newline='') as f: return list(csv.DictReader(f))


def build(out_dir, parse_sp=None, objs=None):
    if not available(): return None
    t0 = time.strftime('%Y-%m-%d %H:%M')
    steps, edges, legend, s1_notes = master_flow(); pages = manual_pages(); menus = menu_screens()
    prod = R.prod_schedule(); pj = R.proc_jobs(prod)
    # 단계 ↔ 매뉴얼 장 ↔ TO-BE 화면
    for s in steps:
        s['pages'] = [p for p in pages if _norm(p['menu'].split('>')[-1]) == _norm(s['name'])]
        if _norm(s['name']).startswith('ssp'):
            s['tobe'] = [(r['mnu_id'], r['mnu_desc']) for r in sorted(menus, key=lambda r: int(r['sort_ord'] or 0)) if r['uppr_mnu_id'] == 'Shipping_Schedule' and r['mnu_desc'].startswith('Shipment Plan(')]
            s['tobe_rule'] = "TO-BE Shipping_Schedule 메뉴 중 이름이 'Shipment Plan('으로 시작하는 화면"
        else:
            key = _norm(s['pages'][0]['menu'].split('>')[-1]) if s['pages'] else _norm(s['name'])
            s['tobe'] = [(r['mnu_id'], r['mnu_desc']) for r in menus if _norm(r['mnu_desc']) == key]
            s['tobe_rule'] = 'menu.csv 화면 이름 = 매뉴얼 메뉴 마지막 이름'
        s['sps'] = {}; s['sp_src'] = collections.Counter(); s['sp_dropped'] = []
        for sid, _ in s['tobe']:
            got, drop = screen_sps(sid); s['sps'][sid] = sorted(got); s['sp_dropped'] += drop
            for v in got.values():
                for q in v: s['sp_src'][q] += 1
        s['batch'] = STEP_SYSTEM_PROC.get(s['name'], '')
        rd_, wr_ = set(), set()
        if parse_sp:
            for sid, sps in s['sps'].items():
                for sp in sps:
                    info = parse_sp(sp); rd_ |= {R.norm_tab(t) for t in info['reads'] if objs is None or t in objs}; wr_ |= {R.norm_tab(t) for t in info['writes'] if objs is None or t in objs}
            if s['batch']:
                info = parse_sp(s['batch']); rd_ |= {R.norm_tab(t) for t in info['reads'] if objs is None or t in objs}; wr_ |= {R.norm_tab(t) for t in info['writes'] if objs is None or t in objs}
        s['reads'] = {t for t in rd_ if not re.search(r'_LOG$|SYS_LOG|_H$', t)}; s['writes'] = {t for t in wr_ if not re.search(r'_LOG$|SYS_LOG|_H$', t)}
    byno = {s['no']: s for s in steps}

    sl_n = (R.ppt_slides() or [{'slide': 0}])[-1]['slide']  # 프로세스 PPT 장 수(11-20 판 10장)
    M = [f'# SSP 한눈에 보기 · {t0} 생성', '',
         f'> 원천: ① `{SRC_MANUAL}`(기준정보 Master Flow 1장 · 화면 매뉴얼 10장) ② `{R.SRC_NAMES["ppt"]}`(2026-11-20 판 · 배치 {sl_n}장) ③ 운영 잡 목록 `{R.SRC_NAMES["batch"]}` ④ TO-BE `menu.csv` · AS-IS 화면 SP(endpoints) · SP 본문. 사본 `Doc/asisfacts/ref_ssp/src/` · 구조화 `manual_*.csv` · 생성기 `tools/Analysis/ssp_master.py`',
         '> 전체 순서는 이 탭에서, 상세는 뒤 탭에서 본다. 업무 프로세스 탭에 PI 22 Seq, 통합테스트, 운영 잡, 배치 입출력이 있다. Shipment Plan 산출 흐름 탭에 사업부별 계산 순서, 화면별 상세 탭에 화면 → SP → 테이블이 있다.', '']

    # 1. Master Flow 카드
    M += ['## 1. 기준정보 → 출하계획 순서(SSP Manual Master Flow)', '',
          f'- 출처: {SRC_MANUAL} 1번 슬라이드. 단계 {len(steps)}, 연결선 {len(edges)}(도형 끝점 대조). 카드 색은 상자 채움 색과 가장 가까운 범례 색({len(legend)}개 범례)', '']
    cells = []
    for s in steps:
        tb = ', '.join(f'{i} {d}' for i, d in s['tobe']) or 'TO-BE 화면 없음'
        lines = [f'TO-BE {tb}', f"담당: {s['team'].replace(' 관리', '').replace(' 설정', '') or '범례 없음'}"]
        if s['sub']: lines.insert(0, s['sub'])
        if s['pages'] and s['pages'][0]['keypoint']: lines.append('Key Point: ' + re.sub(r'\s+', ' ', s['pages'][0]['keypoint'].lstrip('- ')))
        if s['batch']:
            jb = pj.get(s['batch'].upper(), [])
            lines.append(f"자동 생성: {s['batch']}" + (f" ({jb[0][1]} {jb[0][2]})" if jb else ' (배치 목록 잡 시트에 없음)'))
        cells.append(C.card(f"{s['no']}. {s['name']}", lines, TEAM_COLOR.get(s['team'], '#7b52b8')))
    seq_ok = [e for e in edges if e[1] == e[0] + 1]
    M += [C.wrap(C.rows(cells, 5) + C.legend([(t.replace(' 관리', '').replace(' 설정', ''), TEAM_COLOR.get(t, '#5b6770')) for t, _ in legend] + [('담당 표시 없음', TEAM_COLOR[''])])), '']
    for n_ in s1_notes: M += [C.wrap(C.note('Manual 메모(원문)', [n_.split(' / ')[0]] + n_.split(' / ')[1:], '#c0602a')), '']
    M += [f"- 연결선 {len(edges)}개 중 번호 순서(n → n+1)인 선 {len(seq_ok)}개" + ('' if len(seq_ok) == len(edges) else f" · 번호 순서가 아닌 선: {', '.join(f'{a}→{b}' for a, b, _ in edges if b != a + 1)}"), '']
    M += ['| 단계 | 담당(채움 색 → 범례) | 매뉴얼 장 | TO-BE 화면 | 화면 판정 규칙 | AS-IS 화면 SP 수(출처별) |', '|---|---|---|---|---|---|']
    for s in steps:
        M.append(f"| {s['no']}. {s['name']} | {s['team'] or '-'} ({s['fill'] or '채움 없음'}, 색 거리 {s['team_dist'] if s['team_dist'] is not None else '-'}) | {', '.join(str(p['slide']) for p in s['pages']) or '-'} | {', '.join(f'{i} {d}' for i, d in s['tobe']) or '-'} | {s['tobe_rule']} | {sum(len(v) for v in s['sps'].values())} (endpoints {s['sp_src']['endpoints']}, actions {s['sp_src']['actions']}, 매트릭스 {s['sp_src']['matrix']}{', 주석 호출 제외 ' + str(len(s['sp_dropped'])) if s['sp_dropped'] else ''}) |")
    M.append('')

    # 1-1. 단계 간 데이터 연결 검증
    M += ['### 1-1. 단계 화살표 검증(AS-IS SP 본문)', '',
          '- 화살표 A → B 마다 A 화면 SP(시스템 자동 단계는 생성 배치)가 쓰는 테이블을 B 화면 SP 가 읽는지 대조함. 이력(_H), 로그 표 제외. 중첩 호출 깊이 3', '',
          '| 화살표 | A 가 쓰고 B 가 읽는 테이블 | 판정 |', '|---|---|---|']
    n_ok = 0; cross = []
    for a, b, how in sorted(edges):
        sa, sb = byno[a], byno[b]; both = sorted(sa['writes'] & sb['reads'])
        if both: n_ok += 1
        verdict = '데이터 연결 있음' if both else ('A 화면 SP 쓰기 없음' if not sa['writes'] else '직접 연결 테이블 없음(업무 순서 화살표)')
        M.append(f"| {a}. {sa['name']} → {b}. {sb['name']} | {', '.join(both) or '-'} | {verdict} |")
        cross.append(['arrow', f'{a}->{b}', verdict, ' '.join(both)])
    M += ['', f'- 화살표 {len(edges)} 중 데이터 연결 확인 {n_ok}', '']
    # 비인접 연결(앞 단계가 쓴 표를 두 단계 이상 뒤에서 읽음) = 매뉴얼의 선행 조건 문구와 대조할 근거
    M += ['### 1-2. 두 단계 이상 뒤에서 읽는 앞 단계 표', '', '| 앞 단계 | 뒤 단계 | 테이블 |', '|---|---|---|']
    n_far = 0
    for s in steps:
        for t in steps:
            if t['no'] - s['no'] >= 2:
                both = sorted(s['writes'] & t['reads'])
                if both: n_far += 1; M.append(f"| {s['no']}. {s['name']} | {t['no']}. {t['name']} | {', '.join(both)} |")
    M += ['', f'- {n_far}쌍', '']

    # 2. 출하계획 오류 확인 순서(BOD ITEM 장)
    bi = next((p for p in pages if _norm(p['ui']) == 'boditem'), None)
    if bi:
        order = re.findall(r'(MKT FCST|Project Route|BOD)\s*\(([^)]*)\)', bi['faq_text'])
        auto = re.search(r'(\d+)분에 한번씩 자동생성', bi['faq_text'])
        jb = pj.get('PR_SCP_MST_BOD_ITEM', [])
        name2step = {_norm(s['name']): s for s in steps}
        cells2 = [C.card('① BOD ITEM 조회', ['SCP0030 BOD ITEM 에서 To Site · Item 입력 후 조회', 'Shipment Plan 입력값과 BOD Item 등록값이 다르면 오류'], '#5b6770')]
        for i, (nm, why) in enumerate(order):
            st = name2step.get(_norm(nm)); tb = ', '.join(x for x, _ in st['tobe']) if st else ''
            cells2.append(C.card(f"{'②③④⑤'[i]} {nm} 확인", [why, f'TO-BE {tb}' if tb else '', f"담당: {st['team'].replace(' 관리', '')}" if st and st['team'] else ''], TEAM_COLOR.get(st['team'], '#7b52b8') if st else '#7b52b8'))
        cells2.append(C.card(f"{'②③④⑤⑥'[len(order)]} BOD ITEM 자동 생성", [f"Manual: {auto.group(1)}분마다" if auto else 'Manual 주기 문구 없음', 'JOB.PR_SCP_MST_BOD_ITEM ' + (f'{jb[0][1]} {jb[0][2]}' if jb else '운영 잡 목록에 없음')], '#5b6770'))
        M += ['## 2. 출하계획 입력 오류 시 확인 순서(BOD ITEM 오류)', '', f'- 출처 = {SRC_MANUAL} {bi["slide"]}번 슬라이드 메모(원문 순서). 자동 생성 주기는 운영 잡 목록과 대조', '',
              C.wrap(C.rows([c for c in cells2], 3)), '']
        same = bool(auto and jb and re.search(rf'\b{auto.group(1)}분', jb[0][2]))
        M += [f"- 자동 생성 주기 대조: Manual {auto.group(1) if auto else '-'}분, 운영 잡 {jb[0][2] if jb else '-'}. 결과 {'일치' if same else '불일치 또는 미확인'}"]
        cross.append(['manual', 'BOD ITEM 자동 생성 주기', '일치' if same else '불일치', jb[0][2] if jb else ''])
        if parse_sp:
            info = parse_sp('SCP0007_GET_BOD'); rdx = {R.norm_tab(t) for t in info['reads']}
            # 단계별 대표 테이블 = 그 단계 화면 SP 가 쓰는 표(1-1 표 실측): MKT FCST·Sales Site Project Model → DM_PLN_MKT_FCST · Project Route → SCM_MST_SITE_ITEM · Distribution Route → SCP_MST_DISTRIBUTION_ROUTE
            need = [('MKT FCST', 'DM_PLN_MKT_FCST'), ('Project Route', 'SCM_MST_SITE_ITEM'), ('Distribution Route', 'SCP_MST_DISTRIBUTION_ROUTE')]
            # 두 번째 근거 = 본문 문자열 검색: 동적 SQL 의 쉼표 조인(', scm_mst_site_item b')은 FROM/JOIN 파서가 잡지 못한다(2026-11-16 실측)
            bp = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules', 'dbo.SCP0007_GET_BOD.sql'); body = io.open(bp, encoding='utf-8', errors='replace').read() if os.path.exists(bp) else ''
            def has(t): return t in rdx or bool(re.search(r'\b' + t + r'\b', body, re.I))
            how_ = {t: ('읽기 파싱' if t in rdx else '본문 문자열(쉼표 조인)') for _, t in need if has(t)}
            got = [f'{n} {t}({how_[t]})' for n, t in need if has(t)]; miss = [f'{n} {t}' for n, t in need if not has(t)]
            M += [f"- BOD Required 원천 대조(Manual 10번 슬라이드 'BOD는 MKT FCST와 Project Route가 등록되어 있어야 생성', 'Route Count 가 0인 경우는 Distribution Route가 없으므로'): SP SCP0007_GET_BOD 가 읽는 표 {', '.join(got) or '없음'}" + (f" · 읽지 않음 {', '.join(miss)}" if miss else '') + ". Required 행은 저장된 행이 아니고 BOD 조회 때 SP 가 계산함(SP 본문 주석 'BOD Requied - From Site : Project route , To Site : Mkt FCST')"]
            cross.append(['manual', 'BOD Required 원천', '일치' if not miss else '일부 없음', ' '.join(got) + (' / 없음 ' + ' '.join(miss) if miss else '')])
        M.append('')

    # 3. 하루 배치 흐름(CUTOFF)
    conds = R.run_conditions(); by_proc = collections.defaultdict(list)
    for c in conds: by_proc[c['proc'].upper()].append(c)
    sl_all = R.ppt_slides()
    M += ['## 3. 하루 배치 흐름(SSP CUTOFF · 배치별)', '',
          f"- 출처: {R.SRC_NAMES['ppt']} 2~{sl_all[-1]['slide'] if sl_all else '-'}번 슬라이드. 카드 1개가 슬라이드 1장, 줄 1개가 프로시저와 운영 잡 주기. [조건] 표시는 진행 조건이 있는 프로시저(아래 3-1 표)", '']
    cells3 = []
    for sl in sl_all:
        lines = []
        for p_ in dict.fromkeys(sl['procs'] + [q for q in sl.get('table_procs', []) if q not in sl['procs']]):
            jb = pj.get(p_.upper(), [])
            when = '; '.join(dict.fromkeys(f'{cy} {tm}'.strip() for _, cy, tm in jb)) or '배치 목록 잡 시트에 없음'
            grp = [f_['rows'][0][ci] for f_ in sl.get('frames', []) for r in f_['rows'] if r and r[0].strip() == '참고 PRC' for ci in range(1, len(r)) if r[ci].strip() == p_ and ci < len(f_['rows'][0])]
            lines.append(f"{'[조건] ' if p_.upper() in by_proc else ''}{(grp[0] + ' 계획기준 · ') if grp and p_ not in sl['procs'] else ''}{p_} ({when})")
        cells3.append(C.card(f"슬라이드 {sl['slide']}. {', '.join(sl['titles']) or '(제목 없음)'}", lines, '#1f7a8c'))
    M += [C.wrap(f'<div class="spf-grid" style="--n:2">' + ''.join(cells3) + '</div>'), '']
    M += ['### 3-1. 프로세스 진행 조건(계획을 만들기 전 확인, 2026-11-16 판 추가 내용)', '',
          '| 슬라이드 | 프로시저 | 운영 잡 | 진행 조건(원문) |', '|---|---|---|---|']
    for c in conds:
        jb = '<br/>'.join(f'{j} ({cy} {tm})' for j, cy, tm in pj.get(c['proc'].upper(), [])) or '-'
        M.append(f"| {c['slide']} | {c['proc']} | {R.cellmd(jb)} | {'<br/>'.join(R.cellmd(i) for i in c['items'])} |")
    M += ['', f'- {len(conds)}묶음. 입출력 화살표와 본문 대조는 업무 프로세스 탭 5-0, 6-5', '']

    # 4. 자주 받는 문의
    M += ['## 4. 자주 받는 문의(SSP Manual 원문)', '', '| 화면 | 질문 | 답 |', '|---|---|---|']
    n_q = 0
    for p in pages:
        for q, a in qa_pairs(p['faq_text']):
            n_q += 1; M.append(f"| {R.cellmd(p['ui'])} ({p['slide']}번) | {R.cellmd(q)} | {R.cellmd(a)} |")
    M += ['', f'- {n_q}건', '']
    # 5. 화면 매뉴얼 원문
    M += ['## 5. 화면별 매뉴얼 원문(2~11번 슬라이드)', '', '| 장 | 메뉴 | UI 명 | 작성자 · 날짜 | UI 정의 | Key Point | 설명 | 메모(자주 발생 사례) |', '|---|---|---|---|---|---|---|---|']
    for p in pages:
        M.append(f"| {p['slide']} | {R.cellmd(p['menu'])} | {R.cellmd(p['ui'])} | {R.cellmd(p['author'])} · {R.cellmd(p['date'])} | {R.cellmd(p['ui_def'])} | {R.cellmd(p['keypoint'])} | {'<br/>'.join(R.cellmd(x) for x in p['desc'].split(' / '))} | {'<br/>'.join(R.cellmd(x) for x in p['faq_text'].split(' / ')) or '-'} |")
    M.append('')
    io.open(os.path.join(out_dir, 'SSP_OVERVIEW.md'), 'w', encoding='utf-8', newline='\n').write('\n'.join(M) + '\n')
    with io.open(os.path.join(out_dir, 'ssp_master_crosscheck.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(['kind', 'key', 'finding', 'detail']); w.writerows(cross)
    with io.open(os.path.join(out_dir, 'ssp_master_steps.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(['no', 'step', 'sub', 'team', 'fill', 'manual_slides', 'tobe_screens', 'asis_sp', 'writes', 'reads'])
        for s in steps: w.writerow([s['no'], s['name'], s['sub'], s['team'], s['fill'], ' '.join(str(p['slide']) for p in s['pages']), ' '.join(i for i, _ in s['tobe']), ' '.join(sp for v in s['sps'].values() for sp in v), ' '.join(sorted(s['writes'])), ' '.join(sorted(s['reads']))])
    return {'steps': len(steps), 'edges': len(edges), 'edges_data': n_ok, 'faq': n_q, 'conds': len(conds), 'pages': len(pages)}
