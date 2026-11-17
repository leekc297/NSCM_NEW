# -*- coding: utf-8 -*-
"""AS-IS 런처 조회 0행 → 데이터 있는 조회조건 자동 탐색·재조회(2026-11-17 사용자 지시: 배치에서 사람이 시트·조건을 지정하지 않는다).

조회 뒤 그리드가 0행이면
  ① 방금 나간 조회 SP 호출을 런처 호출 기록(DbProfile · asis_live_run.parse_dbprofile)에서 읽는다(공통·그리드 제목·저장 계열 SP 제외)
  ② 화면 조회조건 컨트롤과 SP 인자를 값으로 잇는다(컨트롤 현재 값 = 인자값). 바꿔 볼 축 4가지
       popup     팝업으로 고르는 칸(버전 등): 기본 = 팝업 맨 위 행. 맨 위로 조회해 0행이면 위쪽 행(POP_TOP) 값을 차례로 넣어 SP 재실행 → 행이 나오는 첫 행을 팝업에서 고른다(host popup_pick row=)
       division  화면 Division 목록(Division 인자 · 딸린 Site·Plant·Line 인자는 기록값 → 빈 값 순)
       combo     값과 글자가 같은 콤보(연도·월·버전 등)의 앞뒤 항목 최대 6개
       period    날짜·월 컨트롤 값(단일·From~To)을 1·3·6·12·24개월 앞으로(같은 폭 유지)
     후보마다 AS-IS DB(.env.asis · golden.run_asis)에서 SP 를 다시 실행해 행 수를 센다. 한 축 → Division × 기간 순 · SP 당 최대 MAX_REPLAY 회
  ③ 행이 나온 후보를 화면에 넣고(Division = set_division · 콤보 = index · 날짜 = Value/Value1/Value2 · 월 = MonthText) 시트 탭·조건을 맞춰 다시 조회한다
  ④ 찾은 조건은 Doc/asislive/<ID>/data_find.json 에 남겨 같은 화면의 다음 단계(별도 프로세스)가 조회 전에 바로 쓴다
     우선순위: data_find.json(AS-IS 재실행 기록) → Doc/verify/<ID>/sheet_data_cond.json(Division 만) → ② 탐색
모든 후보가 0행이면 out["data_find"]["none"] 에 시도 내역을 남긴다(미측정 · FAIL 아님).
한계: 값이 글자와 다른 콤보(표시 'Sales Plan' · 값 'REPORT_SP_W')는 후보값을 몰라 바꾸지 않는다. 팝업은 여는 메서드(버튼 _Click)를 찾은 칸만 연다.

  python tools/AsisLive/asis_live_datafind.py <ID> [--calls <run 폴더>]   (런처 없이 ②만: 기본 실측 calls.json·controls.json 으로 탐색 · 결과 data_find.json)
"""
import ast, calendar, datetime as dt, glob, json, os, re, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
sys.path.insert(0, HERE); sys.path.insert(0, P('tools', 'DbConn'))

DIV_KEY = re.compile(r'(^|_)division(_id)?$', re.I)
DIV_DEP = re.compile(r'^p_(site|plant|factory|line|item|sub_line|team|model)', re.I)
SKIP_SP = re.compile(r'^(UP_FX_|SCM_SYS_)|SPREAD_TITLE|_TITLE$|GET_COMMON', re.I)   # 공통·그리드 제목 SP(행이 늘 나와 데이터 조건 판단에 못 씀 · 11-17 DMF0044 실측)
WRITE_SP = re.compile(r'(SAVE|INSERT|INS_|UPDATE|UPD_|DELETE|DEL_|MERGE|ADD_|CREATE|APPLY|CONFIRM|APPROV|SEND|EXEC_|_SET_|RESET)', re.I)   # 다시 실행하지 않는 이름(저장·상태 변경)
DIV_CTL = re.compile(r'division|^div\.?$', re.I)
SHIFTS = (1, 3, 6, 12, 24)
MAX_REPLAY = 40
POP_TOP = 15                                                 # 팝업 목록에서 후보로 읽는 위쪽 행 수
POP_TEXT = ('UsrMultiLineEditor', 'UsrTextBox')               # 팝업으로 고르는 값이 들어가는 입력칸(버전 등)
POP_OPENERS = ['btnVersion_Click', 'btnSPVer_Click']          # host popup_pick 기본 여는 메서드
nz = lambda t: re.sub(r'[^a-z0-9]', '', str(t or '').lower())


def now(): return time.strftime('%Y-%m-%d %H:%M:%S')


def cache_path(mid): return P('Doc', 'asislive', mid.upper(), 'data_find.json')


def load(mid):
    try:
        with open(cache_path(mid), encoding='utf-8') as f: return json.load(f)
    except (OSError, ValueError): return {}


def save(mid, j):
    os.makedirs(os.path.dirname(cache_path(mid)), exist_ok=True)
    tmp = cache_path(mid) + '.tmp'
    with open(tmp, 'w', encoding='utf-8') as f: json.dump(j, f, ensure_ascii=False, indent=1, default=str)
    os.replace(tmp, cache_path(mid))


def sheet_key(call):
    """호출의 시트 키 = p_sheet_name 값(없으면 SP 이름)"""
    ps = call.get('params') or {}
    sn = next((v for k, v in ps.items() if nz(k) in ('psheetname', 'sheetname') and v), '')
    return sn or call.get('sp') or ''


def find_calls(calls):
    """조회 구간 SP 호출(공통·제목·저장 계열·인자 없는 호출 제외) — 같은 SP·같은 시트는 마지막 1건"""
    out = {}
    for c in calls or []:
        sp = c.get('sp') or ''
        if not sp or SKIP_SP.search(sp) or WRITE_SP.search(sp) or not c.get('params'): continue
        if c.get('phase') not in (None, '', 'find'): continue
        out[(sp, sheet_key(c))] = c
    return list(out.values())


# ---------- 컨트롤 ↔ 인자 ----------
def _t(c): return c.get('t') or (c.get('type') or '').split('.')[-1]


def _items(c):
    v = c.get('items')
    if isinstance(v, list): return [str(x) for x in v]
    try: return [str(x) for x in ast.literal_eval(str(v))] if v else []
    except (ValueError, SyntaxError): return []


def _vis(c): return str(c.get('visible')).lower() in ('true', '1') and str(c.get('enabled', 'True')).lower() in ('true', '1')


def _shift(v, m):
    """yyyymmdd·yyyymm·yyyy-mm-dd·yyyy-mm 값을 m 개월 앞으로(일 = 그 달 마지막 날로 자름)"""
    s = re.sub(r'[^0-9]', '', str(v))
    if len(s) not in (6, 8): return None
    y, mo = int(s[:4]), int(s[4:6]); t = y * 12 + (mo - 1) - m; y2, mo2 = t // 12, t % 12 + 1
    if len(s) == 6: out = '%04d%02d' % (y2, mo2)
    else: out = '%04d%02d%02d' % (y2, mo2, min(int(s[6:8]), calendar.monthrange(y2, mo2)[1]))
    if '-' in str(v): out = out[:4] + '-' + out[4:6] + ('-' + out[6:] if len(out) == 8 else '')
    return out


def _date_ops(c, parts):
    """날짜·월 컨트롤에 값 넣는 host set 인자 목록(공통 컨트롤 원문 속성 · 2026-11-17 확인)
    UsrDatePicker*·DateTimePicker = Value · UsrDateRange*·WtWeek = Value1/Value2 · UsrMonthPicker = MonthText · UsrMonthRangePicker = MonthText1/MonthText2"""
    t = _t(c); n = c['name']; ym = lambda s: s[:4] + '-' + s[4:6]
    if 'MonthRange' in t: return [{'name': n, 'prop': 'MonthText1', 'value': ym(parts[0])}, {'name': n, 'prop': 'MonthText2', 'value': ym(parts[-1])}]
    if 'Month' in t: return [{'name': n, 'prop': 'MonthText', 'value': ym(parts[0])}]
    if 'Range' in t: return [{'name': n, 'prop': 'Value1', 'value': parts[0][:8]}, {'name': n, 'prop': 'Value2', 'value': parts[-1][:8]}]
    return [{'name': n, 'prop': 'Value', 'value': parts[0][:8]}]


def popup_targets(ctrls, params):
    """팝업으로 고르는 입력칸 중 조회 SP 인자에 값이 들어간 칸 → [{'name','label','keys','value','openers'}]
    입력칸 = UsrMultiLineEditor·UsrTextBox · 여는 메서드 = 이름 줄기 앞 3글자가 같은 버튼(txtSPVersion ↔ btnSPVer)의 _Click + 기본(btnVersion_Click·btnSPVer_Click)"""
    out = []; btns = [c.get('name') or '' for c in ctrls if _t(c) == 'UsrButton' and (c.get('name') or '').lower().startswith('btn')]
    for c in ctrls:
        if _t(c) not in POP_TEXT or not c.get('name') or not _vis(c): continue
        v = str(c.get('text') or c.get('control_values') or '').strip()
        ks = [k for k, x in params.items() if v and str(x).strip() == v and not DIV_KEY.search(k)]
        if not ks: continue
        stem = re.sub(r'^(txt|usr|edt|mle)', '', c['name'], flags=re.I).lower()
        near = [b + '_Click' for b in btns if len(stem) >= 3 and b[3:].lower()[:3] == stem[:3]]
        out.append({'name': c['name'], 'label': c.get('label') or c['name'], 'keys': ks, 'value': v, 'openers': near + [o for o in POP_OPENERS if o not in near]})
    return out


def axes(ctrls, params, div_items, popups=None):
    """[{'axis','cands':[{'label','params':{인자:값},'ops':[화면 동작]}]}] — 컨트롤 현재 값과 같은 인자만 잇는다
    popups = {입력칸 이름: {'values':[팝업 위쪽 행 값…], 'openers':[…]}} — 팝업 축(맨 위 행 → 다음 행 순)을 맨 앞에 둔다"""
    out = []; pv = {k: re.sub(r'[^0-9A-Za-z_]', '', str(v)) for k, v in params.items() if v not in (None, '')}
    for pt in popup_targets(ctrls, params):
        pp = (popups or {}).get(pt['name']) or {}
        cs = [{'label': '%s 팝업 %d번째 행(%s)' % (pt['label'], i + 1, v), 'params': {k: v for k in pt['keys']},
               'ops': [{'popup_row': i, 'popup_ctl': pt['name'], 'openers': ','.join(pp.get('openers') or pt['openers'])}]}
              for i, v in enumerate(pp.get('values') or []) if v and v != pt['value']]
        if cs: out.append({'axis': 'popup:' + pt['name'], 'cands': cs})
    dk = [k for k in params if DIV_KEY.search(k)]
    if dk and div_items:
        cs = []
        for d in div_items:
            cs.append({'label': 'Division %s' % d, 'params': {k: d for k in dk}, 'ops': [{'division': d}]})
            cs.append({'label': 'Division %s(딸린 인자 빈 값)' % d, 'params': dict({k: d for k in dk}, **{k: '' for k in params if DIV_DEP.match(k)}), 'ops': [{'division': d}]})
        out.append({'axis': 'division', 'cands': cs})
    per = []                                                  # [(컨트롤, [인자 키…], [값 조각…])]
    for c in ctrls:
        if not c.get('name') or not _vis(c): continue
        t = _t(c)
        if t == 'UsrCombo' and not DIV_CTL.search(c.get('name') or '') and not DIV_CTL.search(c.get('label') or ''):
            sv, st = str(c.get('selected_value') or ''), str(c.get('selected_text') or '')
            ks = [k for k, v in pv.items() if sv and v == re.sub(r'[^0-9A-Za-z_]', '', sv) and not DIV_KEY.search(k)]
            its = _items(c)
            if not ks or sv != st or len(its) < 2: continue
            try: si = int(c.get('selected_index') or its.index(st))
            except ValueError: continue
            order = [i for d in range(1, 4) for i in (si - d, si + d) if 0 <= i < len(its)][:6]
            out.append({'axis': 'combo:' + c['name'], 'cands': [{'label': '%s=%s' % (c.get('label') or c['name'], its[i]), 'params': {k: its[i] for k in ks}, 'ops': [{'name': c['name'], 'index': str(i)}]} for i in order]})
        elif re.search(r'Date|Month', t) and 'Button' not in t:
            parts = [x for x in str(c.get('control_values') or '').split(':') if re.fullmatch(r'\d{6}|\d{8}', x)]
            if not parts: continue
            ks = [[k for k, v in pv.items() if v == p] for p in parts]
            if not any(ks): continue
            per.append((c, ks, parts))
    paths = [str(c.get('path') or '') for c, _k, _p in per]   # 범위 컨트롤 안 자식 달력(mp1·mp2 · dp1·dp2)은 빼고 바깥 컨트롤로 넣는다(11-17 DMF0074)
    per = [x for x in per if not any(q and str(x[0].get('path') or '').startswith(q + '/') for q in paths)]
    if per:
        cs = []
        for m in SHIFTS:
            ps, ops = {}, []
            for c, ks, parts in per:
                np_ = [_shift(p, m) for p in parts]
                for kk, nv in zip(ks, np_):
                    for k in kk: ps[k] = _shift(params[k], m)
                ops += _date_ops(c, np_)
            cs.append({'label': '기간 %d개월 앞' % m, 'params': ps, 'ops': ops})
        out.append({'axis': 'period', 'cands': cs})
    return out


def plans(ax):
    """시도 순서: 한 축씩(팝업 맨 위 → 다음 행 · Division · 콤보 · 기간) → Division × 기간 → Division × 팝업(앞 3개 Division · 팝업 앞 5행)"""
    by = {a['axis']: a['cands'] for a in ax}; out = []
    for a in ax: out += [[c] for c in a['cands']]
    divs = [c for c in by.get('division', []) if '딸린' not in c['label']][:3]
    if divs and 'period' in by: out += [[d, p] for d in divs for p in by['period']]
    for k, v in by.items():
        if k.startswith('popup:') and divs: out += [[d, p] for d in divs for p in v[:5]]
    return out


def search(mid, calls, ctrls, div_items, cur_div='', stop_after=3, popups=None):
    """조회 SP 를 후보 조건별로 AS-IS DB 에서 다시 실행 → {시트: {'sp','conds':[행 있는 조건…],'divs':[Division 만 바꿔 행 있는 Division…],'tried':[…]}} · data_find.json 에 병합"""
    import dbconn, golden
    try: ax = dbconn.connect('asis')
    except Exception as e: return {'error': 'AS-IS DB 접속 실패: %s' % str(e)[:150]}  # noqa: BLE001
    res = {}
    for c in find_calls(calls):
        sp, ps = c['sp'], {k: ('' if v is None else v) for k, v in (c.get('params') or {}).items()}
        sk = sheet_key(c); ent = res.setdefault(sk, {'sp': sp, 'conds': [], 'divs': [], 'tried': []})
        a = axes(ctrls, ps, [d for d in div_items if d and d != cur_div], popups)
        ent['axes'] = [x['axis'] for x in a]
        if not a: ent['note'] = '바꿔 볼 조건 없음(Division 인자·값이 같은 콤보·날짜 컨트롤·팝업 칸 없음)'; continue
        for plan in plans(a)[:MAX_REPLAY]:
            q = dict(ps)
            for cd in plan: q.update(cd['params'])
            try:
                sets = golden.run_asis(ax, sp, q); n = max((len(r) for _, r in sets), default=0); err = ''
            except Exception as e: n, err = None, str(e)[:120]  # noqa: BLE001
            lab = ' + '.join(cd['label'] for cd in plan)
            ent['tried'].append({'cond': lab, 'rows': n, 'err': err, 'at': now()})
            if n:
                ent['conds'].append({'label': lab, 'rows': n, 'ops': [o for cd in plan for o in cd['ops']], 'params': {k: q[k] for cd in plan for k in cd['params']}})
                if len(plan) == 1 and 'division' in plan[0]['ops'][0]:
                    d = plan[0]['ops'][0]['division']
                    if d not in ent['divs']: ent['divs'].append(d)
                if len(ent['conds']) >= stop_after: break
    try: ax.close()
    except Exception: pass  # noqa: E722
    j = load(mid); j.setdefault('sheets', {}); j['at'] = now(); j['source'] = 'AS-IS 조회 SP 재실행(팝업 행·Division·콤보·기간 후보 · .env.asis)'
    for sk, ent in res.items():
        old = j['sheets'].get(sk) or {}
        new = dict(old); new.update(ent); new.update(divs=ent['divs'] or old.get('divs') or [], conds=ent['conds'] or old.get('conds') or [], at=now())
        j['sheets'][sk] = new
    save(mid, j)
    return res


def known_divs(mid, sheet):
    """기록에서 이 시트에 행이 나온 Division(앞 = 우선) — data_find.json → sheet_data_cond.json"""
    out = []
    ent = (load(mid).get('sheets') or {})
    k = next((x for x in ent if nz(x) == nz(sheet)), None)
    if k: out += [d for d in (ent[k].get('divs') or []) if d not in out]
    try:
        with open(P('Doc', 'verify', mid.upper(), 'sheet_data_cond.json'), encoding='utf-8-sig') as f: sh = json.load(f).get('sheets') or {}
        k = next((x for x in sh if nz(x) == nz(sheet)), None)
        if k: out += [d for d in (sh[k].get('both') or []) + (sh[k].get('divs') or []) if d not in out]
    except (OSError, ValueError): pass
    return out


def known_conds(mid, sheet):
    """기록된 조건(화면 동작 목록) — data_find.json conds → Division 만 기록된 것은 Division 동작으로"""
    ent = (load(mid).get('sheets') or {}); k = next((x for x in ent if nz(x) == nz(sheet)), None)
    out = [dict(c, src='data_find.json') for c in ((ent.get(k) or {}).get('conds') or [])] if k else []
    for d in known_divs(mid, sheet):
        if not any(o == [{'division': d}] for o in (c['ops'] for c in out)): out.append({'label': 'Division %s' % d, 'ops': [{'division': d}], 'src': '기록 Division'})
    return out


def apply_ops(host, mid, ops, done):
    """조건 동작 실행 — division = set_division(+필수 조건 다시 채움) · 그 밖 = host set(잠가서 채움 규칙이 되돌리지 않음). 성공 여부"""
    import asis_live_run as R
    import asis_live_fill as F
    import asis_live_scen_run as S
    ok = True
    for o in ops:
        if 'popup_row' in o:                                  # 팝업을 열어 그 행 선택(host popup_pick row=)
            t = R.now(); r = host.send('popup_pick', timeout=150, wait=60, row=str(o['popup_row']), top=str(POP_TOP), openers=o.get('openers') or ','.join(POP_OPENERS)); R.wait_quiet(t, 2, 40)
            pk = r.get('picked') or {}; done.append({'op': o, 'ok': bool(r.get('ok')), 'applied': pk.get('value'), 'error': r.get('error')}); ok = ok and bool(r.get('ok'))
            if o.get('popup_ctl'): F.LOCK.add(o['popup_ctl'])
        elif 'division' in o:
            x = {}; r = S.set_division(host, x, o['division']); done.append({'op': o, 'ok': r, 'note': x.get('division_note')}); ok = ok and r
            if r:
                try: F.prefill(host, mid)
                except Exception: pass  # noqa: E722
        else:
            t = R.now(); r = host.send('set', timeout=120, **{k: str(v) for k, v in o.items()}); R.wait_quiet(t, 2, 60)
            F.LOCK.add(o.get('name')); done.append({'op': o, 'ok': bool(r.get('ok')), 'applied': r.get('applied'), 'error': r.get('error')}); ok = ok and bool(r.get('ok'))
    return ok


def _remember(mid, sheets, sheet, c, n):
    """런처에서 행이 나온 조건을 data_find.json 에 기록(시트별 conds 맨 앞 · 시트 지정 없는 실행이면 default_cond)"""
    dv = next((o['division'] for o in c['ops'] if 'division' in o), '')
    j = load(mid); j.setdefault('sheets', {})
    for sh in sheets:
        e = j['sheets'].setdefault(sh or '_default', {})
        e['conds'] = [dict(c, launcher_rows=n, launcher_at=now())] + [x for x in (e.get('conds') or []) if x.get('ops') != c['ops']]
        if dv and c['ops'] == [{'division': dv}]: e['divs'] = [dv] + [x for x in (e.get('divs') or []) if x != dv]
    if not sheet and not j.get('default_cond'): j['default_cond'] = {'label': c['label'], 'ops': c['ops'], 'rows': n, 'at': now()}
    save(mid, j)


def ensure_rows(host, mid, out, t_find, rows_fn, refind_fn, sheet='', max_try=4):
    """조회 뒤 0행이면 데이터 있는 조건으로 바꿔 다시 조회한다. 반환 행 수.
    rows_fn() = 현재 그리드 행 수 · refind_fn() = 조회 다시 누르고 기다림 · sheet = 이번 실행 대상 시트(없으면 호출 기록의 시트)"""
    n = rows_fn()
    if n > 0: return n
    import asis_live_run as R
    import asis_live_fill as F
    import asis_live_scen_run as S
    rec = {'at': now(), 'rows0': 0, 'tries': []}; out['data_find'] = rec
    kind, _name, items = S.division_control(host)
    divs_all = [S.div_id(x) for x in items]
    cur = ((out.get('division_set') or {}).get('applied') or '')
    calls = [dict(c, phase='find') for c in R.parse_dbprofile(t_find, R.now())]
    fc = find_calls(calls)
    sheets = [sheet] if sheet else [sheet_key(c) for c in fc] or ['']
    rec['find_sp'] = [c['sp'] for c in fc]; rec['sheets'] = sheets
    cand = []
    jj = load(mid)
    if sheets == [''] and not sheet:                          # 호출 기록에서 시트를 못 읽음 → 기본 조건 + 기록된 조건 전부
        if (jj.get('default_cond') or {}).get('ops'): cand.append(dict(jj['default_cond'], src='data_find.json default_cond'))
        sheets_k = list((jj.get('sheets') or {}).keys())
    else: sheets_k = sheets
    for sh in sheets_k: cand += [c for c in known_conds(mid, sh) if c['ops'] not in [x['ops'] for x in cand]]
    popups = {}
    if not cand and fc:
        try: ctrls = F.state(host)
        except Exception: ctrls = []  # noqa: E722
        # 팝업 칸: 기본 = 팝업 맨 위 행. 지금 값이 맨 위가 아니면 맨 위를 고르고 다시 조회 · 그래도 0행이면 위쪽 행 값을 후보로 SP 재실행
        for pt in popup_targets(ctrls, dict(kv for c in fc for kv in (c.get('params') or {}).items())):
            t = R.now(); r = host.send('popup_pick', timeout=150, wait=60, row='0', top=str(POP_TOP), openers=','.join(pt['openers'])); R.wait_quiet(t, 2, 40)
            pk = r.get('picked') or {}; vals = pk.get('top') or []
            popups[pt['name']] = {'values': vals, 'openers': pt['openers']}
            F.LOCK.add(pt['name'])
            rec.setdefault('popup', []).append({'ctl': pt['name'], 'ok': bool(r.get('ok')), 'error': r.get('error'), 'top0': vals[:1], 'rows': len(vals), 'was': pt['value']})
            if r.get('ok') and vals and vals[0] != pt['value']:
                refind_fn(); n = rows_fn(); rec['tries'].append({'cond': '%s 팝업 맨 위 행(%s)' % (pt['label'], vals[0]), 'rows': n, 'at': now()})
                if n > 0:
                    c0 = {'label': '%s 팝업 1번째 행(%s)' % (pt['label'], vals[0]), 'ops': [{'popup_row': 0, 'popup_ctl': pt['name'], 'openers': ','.join(pt['openers'])}]}
                    rec['found'] = {'cond': c0['label'], 'rows': n, 'ops': c0['ops']}; _remember(mid, sheets, sheet, c0, n)
                    print('   데이터 조건 자동: %s → %d행' % (c0['label'], n), flush=True)
                    return n
        res = search(mid, calls, ctrls, divs_all, cur, popups=popups)
        if isinstance(res, dict) and 'error' in res: rec['search'] = res
        else:
            rec['search'] = {k: {'sp': v.get('sp'), 'axes': v.get('axes'), 'conds': [c['label'] for c in v.get('conds') or []], 'tried': len(v.get('tried') or []), 'note': v.get('note')} for k, v in res.items()}
            for k, v in res.items():
                if sheet and nz(k) != nz(sheet): continue
                cand += [c for c in v.get('conds') or [] if c['ops'] not in [x['ops'] for x in cand]]
    if not cand:
        rec['none'] = '데이터 있는 조건 없음(조회 SP %s · Division 후보 %s · 미측정)' % (','.join(rec['find_sp']) or '없음', ','.join(divs_all) or '없음'); return 0
    for c in cand[:max_try]:
        if any('division' in o and o['division'] not in divs_all for o in c['ops']): rec['tries'].append({'cond': c['label'], 'note': '화면 Division 목록에 없음'}); continue
        done = []
        if not apply_ops(host, mid, c['ops'], done): rec['tries'].append({'cond': c['label'], 'note': '조건 넣기 실패', 'done': done}); continue
        if S.SHEET_TARGET.get(mid):
            st, _r = __import__('asis_live_sheet_nav').steps(mid, S.SHEET_TARGET[mid]); S._run_steps(host, st, [])
        refind_fn(); n = rows_fn(); rec['tries'].append({'cond': c['label'], 'rows': n, 'done': done, 'at': now()})
        if n > 0:
            rec['found'] = {'cond': c['label'], 'rows': n, 'ops': c['ops']}
            dv = next((o['division'] for o in c['ops'] if 'division' in o), '')
            if dv: out['division_set'] = {'ok': True, 'applied': dv}
            _remember(mid, sheets, sheet, c, n)
            print('   데이터 조건 자동: %s → %d행' % (c['label'], n), flush=True)
            return n
    rec['none'] = '후보 %s 전부 0행(미측정)' % ' / '.join(c['label'] for c in cand[:max_try])
    return 0


def main(argv):
    if not argv or argv[0].startswith('-'): print(__doc__); return 2
    mid = argv[0].upper()
    if '--calls' in argv: d = argv[argv.index('--calls') + 1]
    else:
        ds = [x for x in sorted(glob.glob(P('Doc', 'asislive', mid, 'run_*', 'calls.json')), reverse=True) if os.path.basename(os.path.dirname(x)).count('_') == 2]   # 기본 실측 폴더(run_날짜_시각)만
        if not ds: print('[%s] 기본 실측 calls.json 없음' % mid); return 3
        d = os.path.dirname(ds[0])
    calls = (json.load(open(os.path.join(d, 'calls.json'), encoding='utf-8')) or {}).get('calls') or []
    try: ctrls = json.load(open(os.path.join(d, 'controls.json'), encoding='utf-8')).get('controls') or []
    except (OSError, ValueError): ctrls = []
    dc = next((c for c in ctrls if _t(c) in ('UsrCombo',) and DIV_CTL.search(c.get('name') or '') and _items(c)), None)
    divs = [x.split(' ')[0] for x in _items(dc)] if dc else []
    cur = str((dc or {}).get('selected_value') or '')
    popups = {}
    try:                                                      # 기본 실측의 필수 조건 채움(규칙 5 · 팝업 맨 위 행)이 남긴 위쪽 행 값
        for f in json.load(open(os.path.join(d, 'run.json'), encoding='utf-8')).get('fills') or []:
            st = f.get('set') or {}
            if st.get('popup') and f.get('top'): popups[st.get('name')] = {'values': f['top'], 'openers': [st['opener']] if st.get('opener') else []}
    except (OSError, ValueError): pass
    res = search(mid, calls, ctrls, divs, cur, popups=popups)
    if isinstance(res, dict) and 'error' in res: print(res['error']); return 3
    for k, v in res.items():
        print('%-30s %s · 축 %s · 시도 %d · 행 있는 조건 %s%s' % (k, v.get('sp'), ','.join(v.get('axes') or []) or '없음', len(v.get('tried') or []),
                                                    ' / '.join('%s(%d행)' % (c['label'], c['rows']) for c in v.get('conds') or []) or '없음', (' · ' + v['note']) if v.get('note') else ''))
    print('→ %s' % os.path.relpath(cache_path(mid), ROOT))
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
