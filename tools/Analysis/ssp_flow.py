# -*- coding: utf-8 -*-
"""SSP 도메인 데이터 흐름·프로세스 흐름 다이어그램 생성기 (2026-11-09 · 사용자: SSP 업무분석서·화면정의서 재작성 전 전체 흐름 파악)

  python tools/Analysis/ssp_flow.py [--out Doc/화면분석서/SSP_FLOW_<YYYYMMDD>]

원천(전부 기계 추출 · 추정 없음):
  ① _analysis/Screen_POPUP_SP_Tables_Matrix.xlsx — 화면_SP_Tables_매트릭스(SSP 행) · 화면_인벤토리(SSP 화면·유형·부모·POPUP)
  ② Doc/asisfacts/screens/SSP*/endpoints.csv — 화면 .cs 가 실제 호출하는 SP(FoxDataRequest) · ①과 교차검증
  ③ Doc/asisfacts/db/modules/dbo.<SP>.sql — SP 본문: 읽기(FROM/JOIN) · 쓰기(INSERT/UPDATE/MERGE/DELETE/TRUNCATE) · 중첩 EXEC(깊이 3)
  ④ Doc/tobefacts/db/menu.csv(TO-BE SSP 메뉴 19) · proc_meta.csv(TO-BE PKG 배선)
산출: ssp_screen_inventory.csv · ssp_screen_sp_table.csv · ssp_crosscheck.csv · SSP_DATA_FLOW.md · SSP_DATA_FLOW_DETAIL.md · SSP_PROCESS_FLOW.md · SSP_FLOW.html · README.md
한계(명시): SP 본문이 modules 에 없는 SP(동적 SQL·외부 DB·함수)는 ①의 참조 테이블만 사용 · 동적 SQL 문자열 안의 테이블은 정규식이 잡는 범위까지
"""
import argparse, csv, io, json, os, re, sys, time, collections, html

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'Harness', 'verify'))
MATRIX = os.path.join(ROOT, '_analysis', 'Screen_POPUP_SP_Tables_Matrix.xlsx')
MODULES = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules')
SCREENS = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens')
MENU = os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'menu.csv')
PROC_META = os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'proc_meta.csv')
DB_OBJECTS = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'db_objects.csv')  # AS-IS 객체 카탈로그(U/V/SN) — SP 본문에서 잡힌 이름의 실존 검증

NAME = r'((?:\[?[A-Za-z_][\w$]*\]?\s*\.\s*){0,2}\[?[A-Za-z_][\w$]*\]?)'
RX_READ = re.compile(r'(?is)\b(?:FROM|JOIN)\s+' + NAME + r'(?![\w$\]])(?!\s*\()')  # 식별자 끝 경계 + 함수 호출 제외(절단 방지)
RX_DEL = re.compile(r'(?is)\bDELETE\s+(?:TOP\s*\(\s*\d+\s*\)\s+)?(?:FROM\s+)?' + NAME)
RX_TRUNC = re.compile(r'(?is)\bTRUNCATE\s+TABLE\s+' + NAME)
RX_EXEC = re.compile(r'(?is)\bEXEC(?:UTE)?\s+(?:@\w+\s*=\s*)?' + NAME)
KW = {'SELECT', 'WHERE', 'OPENQUERY', 'OPENROWSET', 'VALUES', 'DUAL', 'INSERTED', 'DELETED', 'STRING_SPLIT', 'OPENJSON', 'SP_EXECUTESQL', 'XP_CMDSHELL'}
LOG_SP = re.compile(r'^(PR_SCM_SYS_LOG|SCM_SYS_LOG)', re.I)


def strip_comments(s):
    s = re.sub(r'/\*.*?\*/', ' ', s, flags=re.S)
    return re.sub(r'--[^\n]*', ' ', s)


def norm_name(n):
    n = re.sub(r'[\[\]\s]', '', n)
    parts = [p for p in n.split('.') if p]
    if not parts: return ''
    t = parts[-1].upper()
    if t.startswith('#') or t.startswith('@') or t in KW: return ''
    return t


def classify(t):
    if re.match(r'^(SCM_)?SSP_|^SCM_SSP', t): return 'SSP'
    if re.match(r'^SCM_(MST|ADM|SYS|COM|CMM)_|^SCM_ADM|^SCM_(ITEM|CODE|MODEL)_|^TB_FX_', t): return '공통(마스터·시스템)'
    if re.match(r'^SCM_DNM_', t): return '외부 연계 실적·재고·계획'  # SCM_DNM_* = ERP·SCS·MES·FP 수신 원본(XIF_*)을 공통 적재 SP 가 정제해 쌓은 표·뷰 (11-09 사용자 요청으로 'DNM(수신 데이터)' 대체)
    if re.match(r'^(SCM_)?DM_|^DM[0-9]|^SCM_DM', t): return 'DM'
    if re.match(r'^(SCM_)?SCP_|^SCM_SCP', t): return 'SCP'
    if re.match(r'^(SCM_)?FP_|^SCM_FP', t): return 'FP'
    if re.search(r'IF_|_IF$|NERP|SCS|ERP|MES|EDI', t): return '인터페이스'
    return '기타'


_body_cache = {}
def sp_body(sp):
    sp = sp.upper()
    if sp not in _body_cache:
        p = os.path.join(MODULES, f'dbo.{sp}.sql')
        if not os.path.exists(p):
            cands = [f for f in os.listdir(MODULES) if f.upper() == f'DBO.{sp}.SQL']
            p = os.path.join(MODULES, cands[0]) if cands else ''
        _body_cache[sp] = strip_comments(io.open(p, encoding='utf-8', errors='replace').read()) if p else None
    return _body_cache[sp]


def parse_sp(sp, depth=0, seen=None):
    """→ {'reads': set, 'writes': set, 'calls': [(sp, depth)], 'missing': [sp…]}"""
    seen = seen if seen is not None else set()
    out = {'reads': set(), 'writes': set(), 'calls': [], 'missing': []}
    if sp.upper() in seen or depth > 3: return out
    seen.add(sp.upper())
    body = sp_body(sp)
    if body is None:
        out['missing'].append(sp.upper()); return out
    from sp_dml_check import writes as _writes
    try:
        for t in _writes(body): out['writes'].add(t.upper())
    except Exception:
        pass
    for rx in (RX_DEL, RX_TRUNC):
        for m in rx.finditer(body):
            t = norm_name(m.group(1));
            if t: out['writes'].add(t)
    for m in RX_READ.finditer(body):
        t = norm_name(m.group(1))
        if t and not t.startswith('FN_') and not t.startswith('UFN_'): out['reads'].add(t)
    for m in RX_EXEC.finditer(body):
        c = norm_name(m.group(1))
        if not c or c in KW: continue
        out['calls'].append((c, depth + 1))
        if LOG_SP.match(c): continue
        sub = parse_sp(c, depth + 1, seen)
        out['reads'] |= sub['reads']; out['writes'] |= sub['writes']; out['calls'] += sub['calls']; out['missing'] += sub['missing']
    return out

def stage_of(s):
    n = (s.get('tobe_desc') or '') + ' ' + (s.get('name') or '')
    rules = [('ChangeConfirm', r'Change\s*Request\s*Confirm|ChangeRequestConfirm'), ('Change', r'Change\s*Request|ChangeRequest|Change History|ChangeHistory'), ('Confirm', r'Confirm'),
             ('Request', r'Request'), ('Plan', r'Plan|PSI|Problem|Adjust'), ('Master', r'Working\s*Day|PIC|Delegate|Master|Itemby|LT\s*Management|LTManagement'),
             ('Analysis', r'Inventory|Tracking|Simulation|OrderDetail|Sql')]
    for st, rx in rules:
        if re.search(rx, n, re.I): return st
    return 'Etc'
STAGES = ['Master', 'Request', 'Plan', 'Confirm', 'Change', 'ChangeConfirm', 'Analysis', 'Etc']


ENTITY_RULES = [  # (엔터티 군, 정규식) — 위에서부터 첫 일치 · SSP 테이블 이름(SSP_/SCM_SSP_ 접두 제거 후)
    ('출하확정 변경요청(CHG_REQ)', r'SHIP_CONFIRM_CHG_REQ'),
    ('출하확정(CONFIRM)', r'SHIP_CONFIRM'),
    ('ERP 출하 I/F(DO·SO)', r'SHIP_ERP'),
    ('출하계획(SHIP_PLAN)', r'SHIP_PLAN|SHIPMENT_PLAN'),
    ('출하요청(SHIP_REQ)', r'SHIP_REQ'),
    ('출하실적·반품(OWMS)', r'SHIP_RESULT|SHIP_RETURN|DELIVERY_TRACKING'),
    ('ESS', r'ESS_'),
    ('생산계획·PSI', r'PRODUCTION|PROD_PLAN|PSI_|FORMATION'),
    ('문제 리포트(PROBLEM)', r'PROBLEM_REPORT'),
    ('재고(STOCK·ONHAND)', r'STOCK|ONHAND|BOH_|INVENTORY'),
    ('FP I/F', r'^DNM_FP_|FP_'),
    ('메일 발송', r'SEND_MAIL'),
    ('마스터(모델·담당·사이트·캘린더·버전)', r'^MST_|^PLAN_VERSION'),
]


def entity_of(t):
    x = re.sub(r'^(SCM_)?SSP_', '', t); x = re.sub(r'^SCM_SSP_', '', x)
    for en, rx in ENTITY_RULES:
        if re.search(rx, x): return en
    toks = [k for k in x.split('_') if k]
    return '기타 ' + ('_'.join(toks[:2]) if len(toks) >= 2 else (toks[0] if toks else t))


def rd(p):
    """CSV → dict 행 목록(utf-8-sig) · 파일 없으면 빈 목록"""
    if not os.path.exists(p): return []
    with io.open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def mm_id(s):
    return re.sub(r'[^A-Za-z0-9_]', '_', s)


def main(out_dir):
    import openpyxl
    os.makedirs(out_dir, exist_ok=True)
    wb = openpyxl.load_workbook(MATRIX, read_only=True)
    rows = list(wb['화면_SP_Tables_매트릭스'].iter_rows(values_only=True)); H = rows[0]
    mat = [dict(zip(H, r)) for r in rows[1:] if str(r[1]) == 'SSP']
    inv_rows = list(wb['화면_인벤토리'].iter_rows(values_only=True)); IH = inv_rows[0]
    inv = [dict(zip(IH, r)) for r in inv_rows[1:] if str(r[1]) == 'SSP']
    menus = {r['mnu_id'].upper(): r for r in rd(MENU) if r.get('mnu_id', '').upper().startswith('SSP')}
    groups = {r['mnu_id']: r for r in rd(MENU) if r.get('mnu_id') in ('Shipping', 'Shipping_Master', 'Shipping_Schedule')}
    pm = collections.defaultdict(set)
    for r in rd(PROC_META):
        if (r.get('menu_id') or '').upper().startswith('SSP') and r.get('proc'): pm[r['menu_id'].upper()].add(f"{r.get('btn') or ''}:{r['proc']}")
    packs = {d for d in os.listdir(SCREENS) if d.startswith('SSP')}

    # ── 화면 인벤토리
    def asis_is_popup(sid):
        p = os.path.join(SCREENS, sid, 'files.csv')
        own = [x for x in rd(p) if os.path.basename((x.get('file') or x.get('path') or '').replace(chr(92), '/')).upper().startswith(sid.upper() + '_')]
        des = [x for x in own if (x.get('file') or '').lower().endswith('.designer.cs')] or own
        inpop = [('popup' in os.path.basename((x.get('file') or '').replace(chr(92), '/')).lower()) or ('popup' in [k.lower() for k in (x.get('file') or '').replace(chr(92), '/').split('/')[:-1]]) for x in des]
        return bool(inpop) and all(inpop)
    screens = collections.OrderedDict()
    for r in inv:
        sid_full = str(r['화면 ID']); sid = sid_full.split('_')[0].upper(); name = sid_full[len(sid) + 1:] if '_' in sid_full else sid_full
        m = menus.get(sid)
        if sid in screens:
            if name and name not in screens[sid]['name']: screens[sid]['name'] += ' / ' + name
            continue
        screens[sid] = {'id': sid, 'name': name, 'type': ('Popup(AS-IS 경로)' if asis_is_popup(sid) else r['유형']), 'parent': (str(r['부모']) if r['부모'] not in (None, 'None') else ''), 'popups': str(r.get('POPUP 목록') or ''), 'sp_count_cs': r.get('cs') or '',
                        'asis_pack': 'Y' if sid in packs else 'N', 'tobe_menu': m['mnu_id'] if m else '', 'tobe_group': (groups.get(m['uppr_mnu_id'], {}).get('mnu_desc') if m else '') or (m['uppr_mnu_id'] if m else ''), 'tobe_desc': m['mnu_desc'] if m else '', 'tobe_sort': int(m['sort_ord']) if m and str(m.get('sort_ord') or '').isdigit() else 999,
                        'tobe_pkg': sorted(pm.get(sid, [])), 'sps': collections.OrderedDict()}
    # ── 화면 → SP (매트릭스)
    for r in mat:
        sid = str(r['화면 ID']).split('_')[0].upper(); sp = (r['SP 실명'] or '').strip()
        if sid not in screens or not sp or sp.startswith('('): continue
        try: mtabs = set(json.loads(r['참조 테이블 (JSON)'] or '[]'))
        except Exception: mtabs = set()
        e = screens[sid]['sps'].setdefault(sp.upper(), {'endpoint': r['SP Endpoint'] or '', 'matrix_tables': set(), 'in_matrix': True, 'in_endpoints': False})
        e['matrix_tables'] |= {t.upper() for t in mtabs}
    # ── 화면 → SP (asisfacts endpoints) 교차검증
    cross = []
    for sid in screens:
        p = os.path.join(SCREENS, sid, 'endpoints.csv')
        ep = set()
        for r in rd(p):
            m = re.match(r'^SP\s+([A-Za-z0-9_.]+)', r.get('sp_or_sql') or '')
            if m: ep.add(m.group(1).split('.')[-1].upper())
        for sp in ep:
            e = screens[sid]['sps'].setdefault(sp, {'endpoint': '', 'matrix_tables': set(), 'in_matrix': False, 'in_endpoints': False})
            e['in_endpoints'] = True
        mset = {sp for sp, e in screens[sid]['sps'].items() if e['in_matrix']}
        cross.append({'screen_id': sid, 'asis_pack': screens[sid]['asis_pack'], 'matrix_sp': len(mset), 'endpoints_sp': len(ep), 'only_matrix': ' '.join(sorted(mset - ep)), 'only_endpoints': ' '.join(sorted(ep - mset)), 'both': len(mset & ep)})
    # ── SP 본문 파싱
    objs = {r['name'].upper(): r['type'].strip() for r in rd(DB_OBJECTS) if r.get('type', '').strip() in ('U', 'V', 'SN')}
    nonobj = collections.Counter()  # 본문 정규식이 잡았지만 AS-IS 객체가 아닌 이름(커서·임시 표·별칭·동적 SQL 조각) — 흐름에서 제외
    def only_obj(names):
        if not objs: return set(names)
        keep = set()
        for t in names:
            if t in objs: keep.add(t)
            else: nonobj[t] += 1
        return keep
    def objcnt(ts):
        c = collections.Counter(objs.get(t, '?') for t in ts)
        parts = [f'{nm} {c[k]}' for k, nm in (('U', '테이블'), ('V', '뷰'), ('SN', '시노님'), ('?', '미분류')) if c[k]]
        return f"{len(ts)}개({'·'.join(parts)})"
    sp_info = {}; missing = set()
    for sid, s in screens.items():
        for sp, e in s['sps'].items():
            if sp not in sp_info:
                info = parse_sp(sp); info['reads'] = only_obj(info['reads']); info['writes'] = only_obj(info['writes']); sp_info[sp] = info; missing |= set(info['missing'])
            info = sp_info[sp]
            e['reads'] = set(info['reads']); e['writes'] = set(info['writes']); e['calls'] = info['calls']; e['body'] = sp_body(sp) is not None
            # 매트릭스 참조 테이블 중 본문에서 못 잡은 것은 읽기(출처 matrix)로 보강
            e['matrix_only'] = {t for t in only_obj(e['matrix_tables']) if t not in e['reads'] and t not in e['writes']}

    # ── 근거 CSV
    with io.open(os.path.join(out_dir, 'ssp_screen_inventory.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(['screen_id', 'asis_name', 'type', 'parent', 'asis_pack', 'tobe_menu', 'tobe_group', 'tobe_desc', 'tobe_sort', 'tobe_pkg_wiring', 'sp_count', 'popups'])
        for s in screens.values(): w.writerow([s['id'], s['name'], s['type'], s['parent'], s['asis_pack'], s['tobe_menu'], s['tobe_group'], s['tobe_desc'], s['tobe_sort'] if s['tobe_sort'] != 999 else '', ' '.join(s['tobe_pkg']), len(s['sps']), s['popups']])
    with io.open(os.path.join(out_dir, 'ssp_screen_sp_table.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.writer(f); w.writerow(['screen_id', 'screen_name', 'sp', 'sp_source', 'body_found', 'table', 'rw', 'table_domain', 'table_source'])
        for s in screens.values():
            for sp, e in s['sps'].items():
                src = 'matrix+endpoints' if e['in_matrix'] and e['in_endpoints'] else ('matrix' if e['in_matrix'] else 'endpoints')
                tabs = [(t, 'W') for t in sorted(e['writes'])] + [(t, 'R') for t in sorted(e['reads'] - e['writes'])] + [(t, 'R?') for t in sorted(e['matrix_only'])]
                if not tabs: w.writerow([s['id'], s['name'], sp, src, 'Y' if e['body'] else 'N', '', '', '', ''])
                for t, rw in tabs: w.writerow([s['id'], s['name'], sp, src, 'Y' if e['body'] else 'N', t, rw, classify(t), 'body' if rw != 'R?' else 'matrix'])
    with io.open(os.path.join(out_dir, 'ssp_crosscheck.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, list(cross[0].keys())); w.writeheader(); w.writerows(cross)

    # ── 집계: 테이블별 writer/reader 화면(메인 화면 기준 · 팝업은 부모로 귀속)
    def owner(sid):
        s = screens[sid]; p = s['parent'].split('_')[0].upper() if s['type'] != 'Main' and s['parent'] else ''
        return p if p in screens else sid
    writers = collections.defaultdict(set); readers = collections.defaultdict(set); tabdom = {}
    for sid, s in screens.items():
        o = owner(sid)
        for sp, e in s['sps'].items():
            for t in e['writes']: writers[t].add(o); tabdom[t] = classify(t)
            for t in (e['reads'] - e['writes']) | e['matrix_only']: readers[t].add(o); tabdom[t] = classify(t)
    log_tabs = {t for t in tabdom if re.search(r'_LOG|SYS_LOG|_HIST$|_H$', t)}

    # ── 데이터 흐름 md
    mains = list(screens.values())  # 팝업도 흐름 대상(라벨에 표기)
    n_pop = sum(1 for s in screens.values() if str(s['type']).startswith('Popup'))
    tobe = [s for s in mains if s['tobe_menu']]; asis_only = [s for s in mains if not s['tobe_menu']]
    def node(s): return f"{mm_id(s['id'])}[\"{s['id']}{'(팝업)' if str(s['type']).startswith('Popup') else ''}<br/>{html.escape(s['name'][:28])}{' ★TO-BE' if s['tobe_menu'] else ''}\"]"
    L = [f'# SSP 데이터 흐름(Data Flow) — {time.strftime("%Y-%m-%d %H:%M")} 생성 · 원천 = AS-IS 화면→SP 호출(매트릭스+endpoints) · SP 본문 읽기/쓰기(깊이 3)', '',
         f'- 화면 {len(screens)}(메인 {len(screens) - n_pop} · 팝업 전용 {n_pop}) · TO-BE 메뉴 {len(tobe)} · AS-IS 전용 {len(asis_only)} · SP {len(sp_info)}(본문 없음 {len(missing)}) · 테이블 {len(tabdom)}',
         '- 화살표: 화면 → 테이블 = 쓰기(W, SP INSERT/UPDATE/MERGE/DELETE) · 테이블 → 화면 = 읽기(R) · 팝업의 호출은 부모 메인 화면으로 귀속 · 로그/이력 표와 공통 마스터 읽기는 개요에서 생략(상세 파일에 전부 있음)', '',
         '## 1. 컨텍스트 — 타 도메인·공통 테이블 → SSP 업무 단계 → 타 도메인·인터페이스 테이블', '',
         '- 노드 수량 = N개(테이블·뷰·시노님 — AS-IS 객체 카탈로그 종류) · 단계 = 화면 이름·TO-BE 메뉴명 규칙(`stage_of`) · 간선 라벨 = 매개 객체 수 · R = 읽기(점선) · W = 쓰기(굵은 선) · 화면 단위는 §2-1, 테이블 단위는 §3 표', '', '```mermaid', 'flowchart LR']
    stage = {s['id']: stage_of(s) for s in mains}
    st_list = [st for st in STAGES if any(stage[s['id']] == st for s in mains)]
    def st_label(st):
        lst = [s for s in mains if stage[s['id']] == st]
        return f'{st}<br/>{len(lst)}화면 · TO-BE {sum(1 for s in lst if s["tobe_menu"])}'
    def owner_stage(sid): return stage[owner(sid)] if owner(sid) in stage else stage.get(sid, 'Etc')
    dom_in = collections.defaultdict(lambda: collections.defaultdict(set)); dom_out = collections.defaultdict(lambda: collections.defaultdict(set))
    for t, rs in readers.items():
        d = tabdom[t]
        if d != 'SSP' and t not in log_tabs:
            for sid in rs: dom_in[d][owner_stage(sid)].add(t)
    for t, ws in writers.items():
        d = tabdom[t]
        if d != 'SSP' and t not in log_tabs:
            for sid in ws: dom_out[d][owner_stage(sid)].add(t)
    L.append('  subgraph IN["입력: 타 도메인·공통 테이블(SSP 화면이 읽음)"]')
    for d in sorted(dom_in): L.append(f'    IN_{mm_id(d)}["{d}<br/>{objcnt(set().union(*dom_in[d].values()))}"]')
    L.append('  end'); L.append('  subgraph SSPD["SSP 업무 단계"]')
    for st in st_list: L.append(f'    ST_{st}["{st_label(st)}"]')
    L.append('  end'); L.append('  subgraph OUT["출력: SSP 화면이 쓰는 타 도메인·인터페이스 테이블"]')
    for d in sorted(dom_out): L.append(f'    OUT_{mm_id(d)}["{d}<br/>{objcnt(set().union(*dom_out[d].values()))}"]')
    L.append('  end')
    for d in sorted(dom_in):
        for st, ts in sorted(dom_in[d].items()): L.append(f'  IN_{mm_id(d)} -."R {len(ts)}".-> ST_{st}')
    for d in sorted(dom_out):
        for st, ts in sorted(dom_out[d].items()): L.append(f'  ST_{st} =="W {len(ts)}"==> OUT_{mm_id(d)}')
    # 외부 연계 표 설명(SCM_DNM_*) — 객체 종류·원천을 카탈로그·SP 본문에서 실측
    syn = {r['name'].upper(): r['base_object_name'] for r in rd(os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'db_synonyms.csv'))}
    rcnt = {r['table_name'].upper(): r['row_count'] for r in rd(os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'db_rowcounts.csv'))}
    ext_tabs = sorted(t for t in tabdom if tabdom[t] == classify('SCM_DNM_X') and t not in log_tabs)
    L += ['```', '', f'### 1-1. 「{classify("SCM_DNM_X")}」 설명 — {objcnt(ext_tabs)}', '',
          '- AS-IS 이름 접두 `SCM_DNM_` 묶음. 외부 시스템(ERP·SCS·MES·FP)에서 받은 원본(`XIF_*` 표·타 DB 표)을 공통 적재 SP 가 정제해 쌓은 **실적·재고·계획 데이터**이며, SSP 화면은 읽기만 한다(쓰기 화면 0).',
          '- 접두 `DNM` 의 원어 풀이는 AS-IS 소스·문서에서 찾지 못함(미확인) — 위 의미는 아래 표의 적재 SP 설명 원문·원천 표로 확인한 것.', '',
          '| 표 | 종류 | 원천(적재 SP 설명 원문 · 원본) | 행 수(DEV) | 읽는 SSP 화면 |', '|---|---|---|---|---|']
    for t in ext_tabs:
        kind = {'U': '테이블', 'V': '뷰', 'SN': '동의어'}.get(objs.get(t, ''), objs.get(t, '?'))
        if kind == '동의어': src = f"타 DB 표 `{syn.get(t, '?')}` 를 직접 참조"
        elif kind == '뷰':
            b = sp_body(t) or ''
            src = '뷰: ' + ', '.join(sorted({x.upper() for x in re.findall(r'(?i)\b(?:FROM|JOIN)\s+(?:\w+\.)*\[?(\w+)\]?', b) if x.upper().startswith(('SCM_DNM_', 'SSP_DNM_', 'XIF_'))})) or '-'
        else:
            loaders = []
            for f_ in os.listdir(MODULES):
                if not f_.upper().startswith(('DBO.PR_', )): continue
                b = sp_body(f_[4:-4]) or ''
                if re.search(r'(?is)\b(?:INSERT\s+(?:INTO\s+)?|MERGE\s+(?:INTO\s+)?)(?:\w+\.)*\[?' + t + r'\]?\b', b):
                    d = re.search(r'(?i)Description\s*:\s*(.*)', io.open(os.path.join(MODULES, f_), encoding='utf-8', errors='replace').read())
                    xif = sorted({x.upper() for x in re.findall(r'(?i)\b(?:FROM|JOIN)\s+(?:\w+\.)*\[?(XIF_\w+)\]?', b)})
                    loaders.append(f"{f_[4:-4]}「{(d.group(1).strip() if d else '-')[:40]}」 ← {', '.join(xif) or '-'}")
            src = ' · '.join(loaders) or '적재 SP 미발견'
        L.append(f"| {t} | {kind} | {src} | {rcnt.get(t, '-')} | {', '.join(sorted(readers.get(t, set()))) or '-'} |")
    L += ['', '## 2. SSP 엔터티 흐름 — 만드는 단계(W) ⇒ 엔터티(테이블 군) ⇒ 쓰는 단계(R)', '',
          '- 엔터티 = SSP 테이블을 업무 의미 규칙표(`ENTITY_RULES`)로 묶음 · 왼쪽 = 쓰는 단계 · 오른쪽 = 읽는 단계(같은 단계가 양쪽에 나올 수 있음) · 라벨 = 테이블 수 · 공통 마스터·로그 표 제외', '', '```mermaid', 'flowchart LR']
    ent_tabs = collections.defaultdict(set)
    for t in tabdom:
        if tabdom[t] == 'SSP' and t not in log_tabs and (writers.get(t) or readers.get(t)): ent_tabs[entity_of(t)].add(t)
    ew = collections.defaultdict(set); er = collections.defaultdict(set)  # (stage, entity) → tables
    for en, ts in ent_tabs.items():
        for t in ts:
            for sid in writers.get(t, set()): ew[(owner_stage(sid), en)].add(t)
            for sid in readers.get(t, set()) - writers.get(t, set()): er[(owner_stage(sid), en)].add(t)
    L.append('  subgraph WS["만드는 단계(W)"]')
    for st in st_list:
        if any(k[0] == st for k in ew): L.append(f'    W_{st}["{st_label(st)}"]')
    L.append('  end'); L.append('  subgraph EN["SSP 엔터티"]')
    for en, ts in sorted(ent_tabs.items(), key=lambda x: -len(x[1])): L.append(f'    E_{mm_id(en)}[("{html.escape(en)}<br/>{objcnt(ts)}")]')
    L.append('  end'); L.append('  subgraph RS["읽는 단계(R)"]')
    for st in st_list:
        if any(k[0] == st for k in er): L.append(f'    R_{st}["{st_label(st)}"]')
    L.append('  end')
    for (st, en), ts in sorted(ew.items()): L.append(f'  W_{st} =="W {len(ts)}"==> E_{mm_id(en)}')
    for (st, en), ts in sorted(er.items()): L.append(f'  E_{mm_id(en)} -."R {len(ts)}".-> R_{st}')
    L += ['```', '', '### 2-1. 단계별 화면 ⇒ 엔터티 ⇒ 화면(화면 단위)', '', '- 각 단계의 화면이 쓰는(W)/읽는(R) SSP 엔터티 · 라벨 = 테이블 수 · 화면·SP·테이블 단위 전체는 `SSP_DATA_FLOW_DETAIL.md`', '']
    for st in st_list:
        lst = sorted([s for s in mains if stage[s['id']] == st], key=lambda x: (x['tobe_sort'], x['id']))
        sw = collections.defaultdict(set); sr = collections.defaultdict(set)
        for en, ts in ent_tabs.items():
            for t in ts:
                for sid in writers.get(t, set()):
                    if owner_stage(sid) == st: sw[(owner(sid), en)].add(t)
                for sid in readers.get(t, set()) - writers.get(t, set()):
                    if owner_stage(sid) == st: sr[(owner(sid), en)].add(t)
        L += [f'#### {st} ({len(lst)}화면)', '', '```mermaid', 'flowchart LR']
        ws_ids = sorted({k[0] for k in sw}); rs_ids = sorted({k[0] for k in sr}); ens = sorted({k[1] for k in list(sw) + list(sr)})
        if ws_ids:
            L.append('  subgraph WS["쓰는 화면"]')
            for sid in ws_ids: L.append('    ' + node(screens[sid]).replace(mm_id(sid), 'W_' + mm_id(sid), 1))
            L.append('  end')
        L.append('  subgraph EN["SSP 엔터티"]')
        for en in ens: L.append(f'    E_{mm_id(en)}[("{html.escape(en)}")]')
        L.append('  end')
        if rs_ids:
            L.append('  subgraph RS["읽는 화면"]')
            for sid in rs_ids: L.append('    ' + node(screens[sid]).replace(mm_id(sid), 'R_' + mm_id(sid), 1))
            L.append('  end')
        for (sid, en), ts in sorted(sw.items()): L.append(f'  W_{mm_id(sid)} =="W {len(ts)}"==> E_{mm_id(en)}')
        for (sid, en), ts in sorted(sr.items()): L.append(f'  E_{mm_id(en)} -."R {len(ts)}".-> R_{mm_id(sid)}')
        for s_ in lst:
            if s_['id'] not in ws_ids and s_['id'] not in rs_ids: L.append(f'  X_{mm_id(s_["id"])}["{s_["id"]} {html.escape(s_["name"][:24])}<br/>(SSP 엔터티 R/W 없음 — 상세 참조)"]')
        L += ['```', '']
    L += ['### 2-2. 엔터티 군 → 테이블 대응표', '', '| 엔터티 | 테이블 수 | 테이블 |', '|---|---|---|']
    for en, ts in sorted(ent_tabs.items(), key=lambda x: -len(x[1])): L.append(f'| {en} | {len(ts)} | {", ".join(sorted(ts))} |')
    L += ['']
    L += ['```', '', '## 3. SSP 테이블별 쓰기/읽기 화면 표', '', '| 테이블 | 도메인 | 쓰는 화면 | 읽는 화면 |', '|---|---|---|---|']
    for t in sorted(tabdom, key=lambda x: (tabdom[x] != 'SSP', tabdom[x], x)):
        if t in log_tabs: continue
        L.append(f"| {t} | {tabdom[t]} | {', '.join(sorted(writers.get(t, []))) or '-'} | {', '.join(sorted(readers.get(t, set()) - writers.get(t, set()))) or '-'} |")
    L += ['', f'## 4. 로그·이력 표({len(log_tabs)}) — 개요 생략분', '', ', '.join(sorted(log_tabs)) or '-', '', '> 화면별 SP·테이블 상세 = `SSP_DATA_FLOW_DETAIL.md` · 근거 행 = `ssp_screen_sp_table.csv` · 교차검증 = `ssp_crosscheck.csv`']
    io.open(os.path.join(out_dir, 'SSP_DATA_FLOW.md'), 'w', encoding='utf-8', newline='\n').write('\n'.join(L) + '\n')

    # ── 상세(화면별)
    D = [f'# SSP 데이터 흐름 상세 — 화면별 SP·테이블(R/W) · {time.strftime("%Y-%m-%d %H:%M")}', '', '> 다이어그램 = 화면 → SP(GET/SAVE) → 엔터티(SSP 테이블 군 · 타 도메인은 도메인명) · 라벨 = 테이블 수 · 테이블 단위는 각 절의 표 · R = SP 본문 FROM/JOIN · W = INSERT/UPDATE/MERGE/DELETE/TRUNCATE · R? = 매트릭스 참조 테이블인데 본문 정규식이 못 잡은 것(동적 SQL·본문 없음) · 중첩 EXEC 깊이 3 포함', '']
    for s in sorted(screens.values(), key=lambda x: (x['type'] != 'Main', x['tobe_sort'], x['id'])):
        D += [f"## {s['id']} {s['name']} ({s['type']}{' · 부모 ' + s['parent'] if s['parent'] else ''}){' · TO-BE ' + s['tobe_menu'] + ' ' + s['tobe_desc'] if s['tobe_menu'] else ' · AS-IS 전용(TO-BE 메뉴 없음)'}", '',
              f"- SP {len(s['sps'])}개 · TO-BE PKG 배선 {len(s['tobe_pkg'])}건{(' · ' + ', '.join(s['tobe_pkg'][:6])) if s['tobe_pkg'] else ''} · 팝업 {s['popups'] or '-'}", '', '```mermaid', 'flowchart LR', f"  S[\"{s['id']}<br/>{html.escape(s['name'][:30])}\"]"]
        for sp, e in s['sps'].items():
            kind = 'SAVE' if re.search(r'SAVE|INS|UPD|DEL|CONFIRM|SEND|ADJUST|MAIL', sp) else 'GET'
            D.append(f"  P_{mm_id(sp)}{{{{\"{sp}{'' if e['body'] else ' (본문 없음)'}\"}}}}")
            D.append(f"  S --{kind}--> P_{mm_id(sp)}")
            def grp(t): return entity_of(t) if classify(t) == 'SSP' else classify(t)
            for en, n in sorted(collections.Counter(grp(t) for t in e['writes']).items()): D.append(f"  P_{mm_id(sp)} ==\"W {n}\"==> E_{mm_id(en)}[(\"{html.escape(en)}\")]")
            for en, n in sorted(collections.Counter(grp(t) for t in e['reads'] - e['writes']).items()): D.append(f"  E_{mm_id(en)}[(\"{html.escape(en)}\")] -.\"R {n}\".-> P_{mm_id(sp)}")
            for en, n in sorted(collections.Counter(grp(t) for t in e['matrix_only']).items()): D.append(f"  E_{mm_id(en)}[(\"{html.escape(en)}\")] -.\"R? {n}\".-> P_{mm_id(sp)}")
        D += ['```', '', '| SP | 출처 | 본문 | 쓰기(W) | 읽기(R) | 중첩 호출 |', '|---|---|---|---|---|---|']
        for sp, e in s['sps'].items():
            src = 'matrix+endpoints' if e['in_matrix'] and e['in_endpoints'] else ('matrix' if e['in_matrix'] else 'endpoints')
            D.append(f"| {sp} | {src} | {'Y' if e['body'] else 'N'} | {', '.join(sorted(e['writes'])) or '-'} | {', '.join(sorted((e['reads'] - e['writes']) | e['matrix_only'])) or '-'} | {', '.join(sorted({c for c, _ in e['calls']})) or '-'} |")
        D.append('')
    io.open(os.path.join(out_dir, 'SSP_DATA_FLOW_DETAIL.md'), 'w', encoding='utf-8', newline='\n').write('\n'.join(D) + '\n')

    # ── 프로세스 흐름: 데이터 의존(쓰기 화면 → 읽기 화면) DAG + 메뉴 그룹
    dep = collections.defaultdict(set)  # (A,B) → tables
    for t in tabdom:
        if t in log_tabs or tabdom[t] == '공통(마스터·시스템)': continue
        for a in writers.get(t, []):
            for b in readers.get(t, []):
                if a != b: dep[(a, b)].add(t)
    P = [f'# SSP 프로세스 흐름(Process Flow) — {time.strftime("%Y-%m-%d %H:%M")} 생성', '',
         '- 근거: 화면 A 가 쓰는(W) 테이블을 화면 B 가 읽으면(R) A → B 선행(데이터 의존) · 공통 마스터·로그 표는 제외 · 메뉴 그룹 = TO-BE menu.csv(Shipping Master / Shipping Schedule) · AS-IS 전용 화면은 별도 묶음',
         '- 이 순서는 데이터가 흐르는 방향이지 운영 절차서의 순서가 아니다 — 업무 절차 확정은 화면정의서 재작성 때 담당자 확인', '',
         '## 1. TO-BE 메뉴 구조', '', '```mermaid', 'flowchart LR', '  M0["Shipping"]']
    for g in ('Shipping_Master', 'Shipping_Schedule'):
        gd = groups.get(g, {}).get('mnu_desc', g); P.append(f'  M0 --> {mm_id(g)}["{gd}"]')
        for s in sorted([x for x in tobe if x['tobe_group'] == gd], key=lambda x: x['tobe_sort']): P.append(f"  {mm_id(g)} --> {mm_id(s['id'])}[\"{s['id']} {html.escape(s['tobe_desc'])}\"]")
    P += ['```', '', '## 2. 업무 단계 흐름(데이터 의존 집계) — 단계 = 화면 이름·TO-BE 메뉴명 규칙 · 간선 라벨 = 선행 단계 화면이 쓰고 후행 단계 화면이 읽는 (화면쌍, 테이블) 수', '',
          '- 노드 = 단계(화면 수 · TO-BE 수) · 실선 = (화면쌍,테이블) 5 이상 · 점선 = 5 미만 · 화면 단위는 §2-1(단계별)·§2-2(TO-BE 화면만) · 전체 쌍은 §3 표', '', '```mermaid', 'flowchart LR']
    for st in st_list: P.append(f'  ST_{st}["{st_label(st)}"]')
    agg = collections.Counter()
    for (a_, b_), ts in dep.items():
        if stage[a_] != stage[b_]: agg[(stage[a_], stage[b_])] += len(ts)
    for (sa, sb), n in sorted(agg.items(), key=lambda x: -x[1]): P.append(f'  ST_{sa} {"-->" if n >= 5 else "-.->"}|{n}| ST_{sb}')
    P += ['```', '', '### 2-1. 단계별 화면 의존 — 단계 안 화면은 개별, 다른 단계는 한 노드로 접음(라벨 = 테이블 수)', '']
    for st in st_list:
        lst = {s['id'] for s in mains if stage[s['id']] == st}
        inner = collections.Counter(); to_st = collections.Counter(); from_st = collections.Counter()
        for (a_, b_), ts in dep.items():
            if a_ in lst and b_ in lst: inner[(a_, b_)] += len(ts)
            elif a_ in lst: to_st[(a_, stage[b_])] += len(ts)
            elif b_ in lst: from_st[(stage[a_], b_)] += len(ts)
        P += [f'#### {st} ({len(lst)}화면)', '', '```mermaid', 'flowchart LR']
        for sid in sorted(lst, key=lambda x: (screens[x]['tobe_sort'], x)): P.append('  ' + node(screens[sid]))
        for ost in sorted({k[0] for k in from_st}): P.append(f'  IN_{ost}["◀ {ost} 단계"]')
        for ost in sorted({k[1] for k in to_st}): P.append(f'  OUT_{ost}["{ost} 단계 ▶"]')
        for (a_, b_), n in sorted(inner.items()): P.append(f'  {mm_id(a_)} -->|{n}| {mm_id(b_)}')
        for (ost, b_), n in sorted(from_st.items()): P.append(f'  IN_{ost} -.->|{n}| {mm_id(b_)}')
        for (a_, ost), n in sorted(to_st.items()): P.append(f'  {mm_id(a_)} -.->|{n}| OUT_{ost}')
        if not inner and not to_st and not from_st: P.append(f'  NOTE_{st}["다른 화면과 SSP 테이블 의존 없음(공통 마스터·로그 제외)"]')
        P += ['```', '']
    P += ['### 2-2. TO-BE 메뉴 화면 간 흐름(19 화면만 · 단계별 색)', '', '- Master 단계 화면(기준정보 · 거의 모든 화면이 읽음)은 한 노드로 접음 · AS-IS 전용 화면을 거치는 의존은 제외 · 라벨 = 매개 테이블 수(쓰는 화면 → 읽기만 하는 화면 · 단방향 전달) · 여러 TO-BE 화면이 함께 쓰는 허브 표는 그림 아래 표 · 화면정의서 재작성 순서 검토용', '', '```mermaid', 'flowchart LR']
    colors = {'Master': '#e3f2fd', 'Request': '#fff3e0', 'Plan': '#e8f5e9', 'Confirm': '#f3e5f5', 'Change': '#fce4ec', 'ChangeConfirm': '#ede7f6', 'Analysis': '#f1f8e9', 'Etc': '#eeeeee'}
    for st in st_list: P.append(f'  classDef {st} fill:{colors.get(st, "#eee")},stroke:#777')
    tobe_ids = {s['id'] for s in tobe}
    mst_ids = sorted(s_['id'] for s_ in tobe if stage[s_['id']] == 'Master')
    def tb_node(sid): return 'MST' if sid in mst_ids else mm_id(sid)
    P.append(f'  MST["Master 화면 {len(mst_ids)}<br/>{html.escape(", ".join(mst_ids))}"]:::Master')
    for s_ in sorted(tobe, key=lambda x: (STAGES.index(stage[x['id']]), x['tobe_sort'])):
        if s_['id'] not in mst_ids: P.append(f'  {mm_id(s_["id"])}["{s_["id"]}<br/>{html.escape(s_["tobe_desc"] or s_["name"])[:30]}"]:::{stage[s_["id"]]}')
    # 허브 표(쓰는 화면 ≥ HUB_MIN) 는 화면쌍 간선 대신 표 노드로 — n×m 간선 폭발 방지 · 나머지 표는 단방향 전달(쓰는 화면 → 읽기만 하는 화면)만 간선
    HUB_MIN = 4
    hubs = {t for t in tabdom if tabdom[t] == 'SSP' and t not in log_tabs and len({owner(x) for x in writers.get(t, set())} & tobe_ids) >= HUB_MIN}
    pair = collections.defaultdict(set)
    for t in tabdom:
        if t in log_tabs or tabdom[t] == '공통(마스터·시스템)' or t in hubs: continue
        ws = {owner(x) for x in writers.get(t, set())} & tobe_ids; rs = ({owner(x) for x in readers.get(t, set())} & tobe_ids) - ws
        for a_ in ws:
            for b_ in rs: pair[(a_, b_)].add(t)
    n_tb = 0
    pair2 = collections.defaultdict(set)
    for (a_, b_), ts in pair.items():
        if tb_node(a_) != tb_node(b_): pair2[(tb_node(a_), tb_node(b_))] |= ts
    for (a_, b_), ts in sorted(pair2.items(), key=lambda x: -len(x[1])): P.append(f'  {a_} -->|{len(ts)}| {b_}'); n_tb += 1
    P.append(f'  LEG["범례: ' + ' · '.join(f'{st}' for st in st_list) + f' — 전달 간선 {n_tb} · 허브 표 {len(hubs)}개는 아래 표"]')
    P += ['```', '', f'**허브 표** — 쓰는 TO-BE 화면 ≥ {HUB_MIN}: 여러 화면이 함께 쓰고 읽는 표라 화면쌍 간선 대신 표로 제시(그림에 넣으면 간선이 폭발)', '', '| 허브 표 | 쓰는 TO-BE 화면 | 읽기만 하는 TO-BE 화면 |', '|---|---|---|']
    for t in sorted(hubs):
        ws = {owner(x) for x in writers.get(t, set())} & tobe_ids; rs = ({owner(x) for x in readers.get(t, set())} & tobe_ids) - ws
        P.append(f"| {t} | {', '.join(sorted(ws))} | {', '.join(sorted(rs)) or '-'} |")
    P += ['']
    P += ['## 3. 의존 표(선행 화면 → 후행 화면 · 매개 테이블)', '', '| 선행(쓰기) | 후행(읽기) | 매개 테이블 |', '|---|---|---|']
    for (a, b), ts in sorted(dep.items()): P.append(f"| {a} {screens[a]['name']} | {b} {screens[b]['name']} | {', '.join(sorted(ts))} |")
    # 위상 정렬(사이클은 보고)
    indeg = collections.Counter(); nodes = {s['id'] for s in mains}
    for (a, b) in dep: indeg[b] += 1
    order = []; q = sorted([n for n in nodes if indeg[n] == 0]); seen = set()
    adj = collections.defaultdict(set)
    for (a, b) in dep: adj[a].add(b)
    while q:
        n = q.pop(0); order.append(n); seen.add(n)
        for b in sorted(adj[n]):
            indeg[b] -= 1
            if indeg[b] == 0: q.append(b)
    cyc = sorted(nodes - set(order))
    P += ['', '## 4. 단계(위상 정렬 — 선행 의존이 없는 화면부터)', '']
    P.append('1. ' + ' → '.join(f"{n}({screens[n]['name'][:18]})" for n in order if n in {s['id'] for s in mains}) if order else '-')
    P += ['', f'- 상호 의존(사이클)으로 순서를 못 정한 화면 {len(cyc)}: {", ".join(cyc) or "없음"} — 같은 표를 서로 쓰고 읽음(의존 표 참조)', '',
          '## 5. 화면 내부 표준 프로세스', '', '```mermaid', 'sequenceDiagram', '  participant U as 사용자', '  participant UI as SSP 화면', '  participant BE as Spring BE(call-proc)', '  participant DB as Oracle PKG_SSPxxxx',
          '  U->>UI: 조회조건 입력 → Search(F5)', '  UI->>BE: /SSPxxxx/<sheet>/SEARCH/call-proc', '  BE->>DB: P_SSPxxxx_GET_*(조건 인자)', '  DB-->>UI: 결과 커서', '  U->>UI: 편집(Insert/수정/Delete) → Save(F7)',
          '  UI->>UI: 화면 사전검증(필수·중복·형식)', '  UI->>BE: /SSPxxxx/<sheet>/SAVE/call-proc(CRUD_TYPE I/M/D)', '  BE->>DB: P_SSPxxxx_SAVE_*(행 단위) + PR_SCM_SYS_LOG_BATCH', '  DB-->>UI: RESULT_CODE/MESSAGE', '```', '',
          '> 화면별 실제 SP 이름·호출 종류(GET/SAVE)는 `SSP_DATA_FLOW_DETAIL.md` 각 절의 다이어그램 참조']
    io.open(os.path.join(out_dir, 'SSP_PROCESS_FLOW.md'), 'w', encoding='utf-8', newline='\n').write('\n'.join(P) + '\n')

    # ── HTML 뷰어(Mermaid · 탭)
    def inline(t):
        t = html.escape(t)
        t = re.sub(r'`([^`]+)`', r'<code></code>', t)
        t = re.sub(r'\*\*([^*]+)\*\*', r'<b></b>', t)
        return t
    def md2html(path):
        """간이 Markdown → HTML: 제목·mermaid·표·목록·인용·문단(다이어그램 사이의 설명 문장을 전부 보존)"""
        lines = io.open(path, encoding='utf-8').read().split('\n'); out = []; i = 0; para = []; ul = []; tbl = []
        def flush():
            nonlocal para, ul, tbl
            if para: out.append('<p>' + inline(' '.join(para)) + '</p>'); para = []
            if ul: out.append('<ul>' + ''.join(f'<li>{inline(x)}</li>' for x in ul) + '</ul>'); ul = []
            if tbl:
                rows = [[c.strip() for c in r.strip().strip('|').split('|')] for r in tbl if not re.match(r'^\s*\|?\s*:?-{2,}', r)]
                if rows:
                    out.append('<table><thead><tr>' + ''.join(f'<th>{inline(c)}</th>' for c in rows[0]) + '</tr></thead><tbody>' + ''.join('<tr>' + ''.join(f'<td>{inline(c)}</td>' for c in r) + '</tr>' for r in rows[1:]) + '</tbody></table>')
                tbl = []
        while i < len(lines):
            ln = lines[i]
            if ln.startswith('```mermaid'):
                flush(); j = i + 1; buf = []
                while j < len(lines) and not lines[j].startswith('```'): buf.append(lines[j]); j += 1
                out.append('<pre class="mermaid">' + html.escape('\n'.join(buf)) + '</pre>'); i = j + 1; continue
            if ln.startswith('```'):
                flush(); j = i + 1; buf = []
                while j < len(lines) and not lines[j].startswith('```'): buf.append(lines[j]); j += 1
                out.append('<pre class="code">' + html.escape('\n'.join(buf)) + '</pre>'); i = j + 1; continue
            m = re.match(r'^(#{1,6})\s+(.*)$', ln)
            if m:
                flush(); lv = min(len(m.group(1)) + 1, 6); out.append(f'<h{lv}>{inline(m.group(2))}</h{lv}>'); i += 1; continue
            if ln.lstrip().startswith('|'):
                if para or ul: flush()
                tbl.append(ln); i += 1; continue
            if tbl: flush()
            if re.match(r'^\s*[-*]\s+', ln):
                if para: flush()
                ul.append(re.sub(r'^\s*[-*]\s+', '', ln)); i += 1; continue
            if ul: flush()
            if ln.startswith('>'):
                flush(); out.append(f'<blockquote>{inline(ln.lstrip(">").strip())}</blockquote>'); i += 1; continue
            if not ln.strip(): flush(); i += 1; continue
            para.append(ln.strip()); i += 1
        flush(); return ''.join(out)
    tabs = [('데이터 흐름(개요)', 'SSP_DATA_FLOW.md'), ('프로세스 흐름', 'SSP_PROCESS_FLOW.md'), ('화면별 상세', 'SSP_DATA_FLOW_DETAIL.md')]
    for t_, fn_ in (('배치 흐름', 'SSP_BATCH_FLOW.md'), ('배치 분석서', 'SSP_BATCH_ANALYSIS.md')):  # ssp_batch_flow.py 산출이 있으면 탭 추가
        if os.path.exists(os.path.join(out_dir, fn_)): tabs.append((t_, fn_))
    body = []
    for i, (title, fn) in enumerate(tabs):
        body.append(f'<section id="tab{i}" class="tab{" on" if i == 0 else ""}"><h2>{html.escape(title)} <small>({fn})</small></h2>')
        body.append(md2html(os.path.join(out_dir, fn)))
        body.append('</section>')
    H = f"""<!doctype html><html lang="ko"><head><meta charset="utf-8"><title>SSP 데이터·프로세스 흐름</title>
<style>body{{font-family:Segoe UI,Malgun Gothic,sans-serif;margin:16px;background:#fafafa;color:#222}} nav button{{margin:0 4px 12px 0;padding:6px 12px;border:1px solid #888;background:#fff;cursor:pointer}} nav button.on{{background:#1f6feb;color:#fff}} .tab{{display:none}} .tab.on{{display:block}} pre.mermaid{{background:#fff;border:1px solid #ddd;padding:8px;overflow:auto}} pre.code{{background:#f3f3f3;padding:8px;overflow:auto}} h3,h4,h5{{margin:18px 0 6px}} small{{color:#666}} table{{border-collapse:collapse;margin:6px 0;font-size:13px}} th,td{{border:1px solid #ccc;padding:3px 8px;vertical-align:top}} th{{background:#eef}} code{{background:#eee;padding:0 3px}} blockquote{{color:#555;border-left:3px solid #bbb;margin:6px 0;padding:2px 10px}}</style></head><body>
<h1>SSP 데이터 흐름 · 프로세스 흐름 <small>{time.strftime("%Y-%m-%d %H:%M")} · 원천 = AS-IS 매트릭스·endpoints·SP 본문 · 근거 CSV 동봉</small></h1>
<div id="err" style="color:#b00"></div><nav>{''.join(f'<button onclick="show({i})" id="b{i}" class="{"on" if i == 0 else ""}">{html.escape(t)}</button>' for i, (t, _) in enumerate(tabs))}</nav>
{''.join(body)}
<script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/10.9.1/mermaid.min.js"></script>
<script>document.querySelectorAll('.tab').forEach(e=>e.classList.add('on'));mermaid.initialize({{startOnLoad:false,maxTextSize:900000,flowchart:{{useMaxWidth:false}},securityLevel:'loose'}});mermaid.run({{querySelector:'pre.mermaid'}}).then(()=>show(0)).catch(e=>{{document.getElementById('err').textContent='Mermaid 오류: '+e;show(0);}});function show(i){{document.querySelectorAll('.tab').forEach((e,k)=>e.classList.toggle('on',k===i));document.querySelectorAll('nav button').forEach((e,k)=>e.classList.toggle('on',k===i));}}</script>
</body></html>"""
    io.open(os.path.join(out_dir, 'SSP_FLOW.html'), 'w', encoding='utf-8', newline='\n').write(H)

    # ── README
    nx = sum(1 for c in cross if c['only_endpoints']); nm = sum(1 for c in cross if c['only_matrix'])
    R = [f'# SSP 흐름 산출물 — {time.strftime("%Y-%m-%d %H:%M")} · 생성기 `tools/Analysis/ssp_flow.py`', '',
         '## 원천·방법', '- 화면→SP: `_analysis/Screen_POPUP_SP_Tables_Matrix.xlsx`(SSP 608행) + `Doc/asisfacts/screens/SSP*/endpoints.csv`(39 팩트팩) 합집합 · 둘의 차이는 `ssp_crosscheck.csv`',
         '- SP→테이블: `Doc/asisfacts/db/modules/dbo.<SP>.sql` 본문 — 읽기 FROM/JOIN · 쓰기 INSERT/UPDATE/MERGE(sp_dml_check.writes)+DELETE/TRUNCATE · 중첩 EXEC 깊이 3 · 로그 SP(PR_SCM_SYS_LOG_*)는 호출만 기록',
         '- TO-BE: `Doc/tobefacts/db/menu.csv` SSP 메뉴 19 · `proc_meta.csv` PKG 배선', '',
         '## 수치(이번 생성 실측)', f'- 화면 {len(screens)}(메인 {len(screens) - n_pop} · 팝업 전용 {n_pop} = AS-IS 파일이 전부 Popup 폴더인 화면 · 메인 화면 소속 팝업은 popups 열) · TO-BE 메뉴 화면 {len(tobe)} · AS-IS 전용 {len(asis_only)}',
         f'- 테이블 실존 검증: AS-IS 객체 카탈로그 `Doc/asisfacts/db/db_objects.csv`(U/V/SN {len(objs)}) 에 없는 이름 {len(nonobj)}종({sum(nonobj.values())}회) 은 흐름에서 제외 = 커서·임시 표·별칭·동적 SQL 조각: {", ".join(sorted(nonobj)[:40])}{" …" if len(nonobj) > 40 else ""}',
         f'- SP {len(sp_info)} · 본문 없음 {len(missing)}: {", ".join(sorted(missing)[:20])}{" …" if len(missing) > 20 else ""}', f'- 테이블 {len(tabdom)}(SSP {sum(1 for t in tabdom if tabdom[t] == "SSP")} · 공통 {sum(1 for t in tabdom if tabdom[t].startswith("공통"))} · 타 도메인/인터페이스/기타 {sum(1 for t in tabdom if tabdom[t] not in ("SSP",) and not tabdom[t].startswith("공통"))}) · 로그/이력 {len(log_tabs)}',
         f'- 교차검증: endpoints 에만 있는 SP 가 있는 화면 {nx} · 매트릭스에만 있는 화면 {nm}(상세 ssp_crosscheck.csv)', f'- 데이터 의존 간선 {len(dep)} · 위상 정렬 미결(사이클) 화면 {len(cyc)}', '',
         '## 한계(명시)', '- 본문 없는 SP·동적 SQL 안의 테이블은 매트릭스 참조 테이블(R?)로만 표기 · 외부 DB/링크 서버·함수 내부 테이블은 미추출 · 배치(UI 외) 가 SSP 표를 쓰는 흐름은 범위 밖(화면 기준)',
         '- 프로세스 순서는 데이터 의존에서 도출 — 운영 절차·승인 흐름은 담당자 확인 필요', '',
         '## 파일', '- `SSP_FLOW.html` 뷰어(브라우저로 열기 · Mermaid · 배치 탭 포함) · `SSP_DATA_FLOW.md` · `SSP_DATA_FLOW_DETAIL.md` · `SSP_PROCESS_FLOW.md` · `ssp_screen_inventory.csv` · `ssp_screen_sp_table.csv` · `ssp_crosscheck.csv`', '- 배치(`tools/Analysis/ssp_batch_flow.py` · 원천 `Doc/asisfacts/db/batch/*.csv` = `asis_batch_facts.py` 가 AS-IS msdb·SSP_INT_SYSTEMEXE 에서 추출): `SSP_BATCH_ANALYSIS.md` · `SSP_BATCH_FLOW.md` · `ssp_batch_inventory.csv` · `ssp_batch_sp_table.csv`']
    io.open(os.path.join(out_dir, 'README.md'), 'w', encoding='utf-8', newline='\n').write('\n'.join(R) + '\n')
    print(f'[ssp_flow] 비객체 제외 {len(nonobj)}종 · 화면 {len(screens)}(메인 {len(screens) - n_pop} · 팝업 전용 {n_pop}) · TO-BE {len(tobe)} · SP {len(sp_info)}(본문 없음 {len(missing)}) · 테이블 {len(tabdom)} · 의존 간선 {len(dep)} · 사이클 {len(cyc)} → {os.path.relpath(out_dir, ROOT)}')
    return 0


if __name__ == '__main__':
    ap = argparse.ArgumentParser(); ap.add_argument('--out', default=os.path.join(ROOT, 'Doc', '화면분석서', f'SSP_FLOW_{time.strftime("%Y%m%d")}'))
    a = ap.parse_args(); sys.exit(main(a.out))
