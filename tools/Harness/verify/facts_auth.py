# -*- coding: utf-8 -*-
"""facts_auth — Division·권한 분기 사실 추출(E03 · 2026-10-31). 화면 독립: 컬럼·컨트롤·그룹 이름은 AS-IS 원문/DB 에서만 온다.

  python -I tools/Harness/verify/facts_auth.py <ID> [<ID> ...]   → Doc/verify/_parallel/E03/facts/<ID>.json

  ① asis.states  = AS-IS 살아있는 메서드의 컨트롤 Enabled/Visible/Visibility 대입 문장 + guard 정규형(condeval 문법: DIV=="40" · DIV[0:2]=="81" · GROUP=="X" · CTL(x)=="v" · RAW(..))
     phase = load(폼 로드 경로) | change(Division 변경 이벤트 경로) | other · 라벨 = 디자이너 Text(layout 항목 Control → 컨트롤 Text)
  ② asis.defaults = Year·Version 류 초기값 대입 문장(DateTime.Now 식 포함)
  ③ asis.insertGuards = Insert 진입 메서드의 GROUP guard MESSAGE 문장
  ④ db.* = 사내오라클 최신 조회(스냅샷 CSV 아님): 메뉴×그룹×사업부·버튼·컬럼(Div 별)·Measure(Div 별)·룩업
  계정 ID 는 산출물에 쓰지 않는다 — accounts 는 key(영역/Div/역할)·groups·divs 만, 런타임에 users.json 에서 key 로 꺼낸다.
  추출 한계: 문장 순서는 메서드 내 stmt_no · 메서드 간 호출 순서는 entry 경로로 근사 → 같은 phase 안 값 충돌 시 평가기(authprobe)가 ERROR.
"""
import collections
import csv
import datetime
import json
import os
import re
import sys
from asis_variant import is_cur  # 2026-11-09 T172: variant 'only' 화면(SSP 등 180) = 현행 — 판정 단일 원천

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
SCR = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens')
OUT = os.path.join(ROOT, 'Doc', 'verify', '_parallel', 'E03', 'facts')


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig', newline='') as f: return list(csv.DictReader(f))


# ── guard 정규형 ────────────────────────────────────────────────
DIVX = r'(?:s(?:trSel_|Sel)?Division(?:Id|ID)?|strDIVISION_ID|(?:this\.)?(?:cbo|clb|usr|ulc)?Divisions?\.(?:ControlValues?|SelectedValue|EditValue)(?:\.ToString\(\))?)'
GRPX = r'UserInfoContext\.Current\["NowGroupID"\]'


def bal(s):
    d = 0
    for ch in s:
        if ch == '(': d += 1
        elif ch == ')':
            d -= 1
            if d < 0: return False
    return d == 0


def split(s, op):
    out, d, cur, i, q = [], 0, '', 0, False
    while i < len(s):
        ch = s[i]
        if ch == '"': q = not q
        if not q:
            if ch == '(': d += 1
            elif ch == ')': d -= 1
            elif d == 0 and s.startswith(op, i):
                out.append(cur); cur = ''; i += len(op); continue
        cur += ch; i += 1
    out.append(cur)
    return [x.strip() for x in out if x.strip()]


def norm_expr(t):
    t = t.strip()
    while t.startswith('(') and t.endswith(')') and bal(t[1:-1]): t = t[1:-1].strip()
    p = split(t, '||')
    if len(p) > 1: return ' || '.join('(' + norm_expr(x) + ')' for x in p)
    p = split(t, '&&')
    if len(p) > 1: return ' && '.join('(' + norm_expr(x) + ')' for x in p)
    if t.startswith('!') and not t.startswith('!='): return '!(' + norm_expr(t[1:]) + ')'
    m = re.fullmatch(DIVX + r'\.Substring\(\s*(\d+)\s*,\s*(\d+)\s*\)\s*(==|!=)\s*"([^"]*)"', t)
    if m:
        a, b = int(m[1]), int(m[2]); return f'DIV[{a}:{a + b}]{m[3]}"{m[4]}"'
    m = re.fullmatch(DIVX + r'\s*(==|!=)\s*"([^"]*)"', t)
    if m: return f'DIV{m[1]}"{m[2]}"'
    if re.fullmatch(DIVX + r'\s*!=\s*null', t): return 'TRUE'
    m = re.fullmatch(GRPX + r'(?:\.ToString\(\))?\s*(==|!=)\s*"([^"]*)"', t)
    if m: return f'GROUP{m[1]}"{m[2]}"'
    m = re.fullmatch(r'(\w+)\.(?:ControlValues?|SelectedValue|EditValue)(?:\.ToString\(\))?\s*(==|!=)\s*"([^"]*)"', t)
    if m: return f'CTL({m[1]}){m[2]}"{m[3]}"'
    if t.lower() == 'true': return 'TRUE'
    if t.lower() == 'false': return 'FALSE'
    return f'RAW({t})'


def norm_guard(guard, method_cases):
    """'if (X) ▸ else of (Y) ▸ switch (..) case "A": ▸ try' → condeval 식"""
    out = []
    for seg in [s.strip() for s in (guard or '').split('▸') if s.strip()]:
        m = re.match(r'^if \((.*)\)$', seg, re.S)
        if m: out.append(norm_expr(m[1])); continue
        m = re.match(r'^else of \((.*)\)$', seg, re.S)
        if m: out.append('!(' + norm_expr(m[1]) + ')'); continue
        m = re.match(r'^switch \((.*?)\) (.*)$', seg, re.S)
        if m:
            subj, rest = m[1], m[2]
            is_grp = re.fullmatch(GRPX + r'(?:\.ToString\(\))?', subj)
            is_div = re.fullmatch(DIVX, subj)
            atom = 'GROUP' if is_grp else 'DIV' if is_div else None
            if not atom: out.append(f'RAW({seg})'); continue
            cases = re.findall(r'case "([^"]*)"', rest)
            if 'default:' in rest:
                others = sorted(set(method_cases.get(subj, set())) - set(cases))
                out.append('(' + ' && '.join(f'{atom}!="{c}"' for c in others) + ')' if others else 'TRUE'); continue
            out.append('(' + ' || '.join(f'{atom}=="{c}"' for c in cases) + ')' if cases else f'RAW({seg})'); continue
        if seg.startswith('catch'): out.append('FALSE'); continue
        if re.match(r'^(try|finally|using|lock|for|foreach|while)\b', seg): continue
        out.append(f'RAW({seg})')
    out = [x for x in out if x != 'TRUE']
    return ' && '.join(f'({x})' for x in out) if out else ''


def collect_cases(rows):
    res = collections.defaultdict(lambda: collections.defaultdict(set))
    for r in rows:
        for seg in (r['guard'] or '').split('▸'):
            m = re.match(r'^\s*switch \((.*?)\) (.*)$', seg.strip(), re.S)
            if m: res[(r['class'], r['method'])][m[1]].update(re.findall(r'case "([^"]*)"', m[2]))
    return res


# ── 화면별 AS-IS 사실 ────────────────────────────────────────────
def asis_facts(sid):
    sd = os.path.join(SCR, sid)
    acts, ents, props = rd(os.path.join(sd, 'actions.csv')), rd(os.path.join(sd, 'actions_entries.csv')), rd(os.path.join(sd, 'props.csv'))
    if not acts: return None
    files = {f['file']: f.get('variant') for f in rd(os.path.join(sd, 'files.csv'))}
    cur = {f for f, v in files.items() if is_cur({'variant': v})}  # T172: only 포함
    try:
        from asis_live import dead_methods
        dead = dead_methods(sid)
    except Exception as e:
        print('[WARN] asis_live 실패 → 죽은 메서드 미제외(살아있는 쪽 보수):', e); dead = {}
    # 주 클래스 = 화면 ID 로 시작 · Popup 이름 제외 · 문장 최다(없으면 문장 최다)
    cnt = collections.Counter(r['class'] for r in acts if not cur or r['file'] in cur)
    cands = [c for c in cnt if c.upper().startswith(sid.upper()) and not re.search(r'(?i)popup|_pop\b', c)] or [c for c in cnt if not re.search(r'(?i)popup', c)] or list(cnt)
    main = max(cands, key=lambda c: cnt[c]) if cands else ''
    live = [r for r in acts if r['class'] == main and (not cur or r['file'] in cur) and (r['class'], r['method']) not in dead]
    cases = collect_cases(live)
    # 경로: Division 변경 이벤트에서 닿는 메서드 / 로드 경로
    ev = [e for e in ents if e['class'] == main and e['entry_kind'] == 'event']
    div_ctl = sorted({m[1] for e in ev for m in [re.match(r'(?:this\.)?(\w*Division\w*)\.\w+', e['entry'])] if m})
    change = {e['method'] for e in ev if re.match(r'(?:this\.)?\w*Division\w*\.(SelectedIndexChanged|SelectedValueChanged|EditValueChanged|ControlValuesChanged|CheckedChanged|ItemCheck|Leave)', e['entry'])}
    load = {e['method'] for e in ents if e['class'] == main and (e['entry_kind'] == 'ctor' or (e['entry_kind'] == 'override' and e['entry'] != 'Dispose'))} | {e['method'] for e in ev if re.search(r'\.(Load|Shown)$', e['entry'])}
    # 라벨: layout item → Control → Text
    ctrl_of, text_of = {}, {}
    for p in props:
        if not is_cur(p): continue
        if p['prop'] == 'Control': ctrl_of[p['target']] = p['value'].replace('this.', '').strip()
        if p['prop'] in ('Text', 'Caption', 'CustomizationFormText'):
            v = p['value'].strip().strip('"')
            if v and (p['prop'] == 'Text' or p['target'] not in text_of): text_of[p['target']] = v
    rev = collections.defaultdict(list)
    for k, v in ctrl_of.items(): rev[v].append(k)

    plan = {}
    for pp in (os.path.join(ROOT, 'Doc', 'e2e', 'specs', f'{sid}.plan.json'), os.path.join(ROOT, 'Doc', 'gen', sid, 'e2e_plan.json')):
        if os.path.exists(pp):
            with open(pp, encoding='utf-8-sig') as fp: plan = json.load(fp)
            break
    plan_f = {x.get('asis'): x for x in plan.get('fields') or [] if x.get('asis')}

    def label_of(t):
        c = []
        for k in [t, ctrl_of.get(t, '')] + rev.get(t, []):
            if k in plan_f:
                c += [v for v in ([plan_f[k].get('tobeLabel')] + list(plan_f[k].get('labels') or [])) if v]
            v = text_of.get(k, '')
            if v and not re.fullmatch(r'(layoutControl(Item|Group)\d*|\w+Button\d*|usrButton\d*|simpleLabelItem\d*)', v, re.I): c.append(v)
        return list(dict.fromkeys(c))
    states = []
    for r in live:
        if r['kind'] not in ('STATE', 'UI_PROP'): continue
        m = re.fullmatch(r'(?:this\.)?(\w+)\.(Enabled|Visible|Visibility|ReadOnly)', r['target'])
        if not m: continue
        ctl, prop = m[1], m[2]
        v = (r['value'] or '').strip()
        val = {'true': True, 'false': False}.get(v.lower())
        if prop == 'Visibility': val = True if 'Always' in v else False if 'Never' in v else None
        if val is None:  # 예: btnA.Visible = btnB.Visible = true 체인 → 맨 끝 리터럴
            m2 = re.search(r'=\s*(true|false)\s*$', v, re.I)
            val = {'true': True, 'false': False}[m2[1].lower()] if m2 else None
        if val is None: continue   # 변수 대입 = 평가 불가
        if prop == 'ReadOnly': prop, val = 'Enabled', not val
        prop = 'visible' if prop in ('Visible', 'Visibility') else 'enabled'
        cs = cases.get((r['class'], r['method']), {})
        cond = norm_guard(r['guard'], cs)
        phase = 'change' if r['method'] in change else 'load' if r['method'] in load else 'other'
        ctl2 = ctrl_of.get(ctl, ctl)
        states.append({'ctl': ctl, 'prop': prop, 'val': val, 'cond': cond, 'phase': phase, 'method': r['method'], 'stmt': int(r['stmt_no'] or 0), 'ref': f"{os.path.basename(r['file'])}:{r['line']}",
                       'labels': label_of(ctl), 'isButton': bool(re.match(r'(?i)(btn|usrButton|button)', ctl2))})
    # Div·GROUP·CTL 이 조건에 있는 (컨트롤, 속성)만 '분기 사실'
    keys = {(s['ctl'], s['prop']) for s in states if re.search(r'\b(DIV|GROUP|CTL)\b', s['cond'])}
    branching = [s for s in states if (s['ctl'], s['prop']) in keys]
    # 초기값: Year·Version 류 — 값에 DateTime 식 / SelectedIndex / 값 대입
    defaults = []
    for r in live:
        if r['kind'] in ('VALUE_SET', 'UI_PROP', 'STATE', 'LOCAL', 'EXPR', 'COMBO_DATA') and r['method'] in load | change:
            if re.search(r'(?i)(year|ver)', r['target'] + ' ' + r['raw']) and re.search(r'DateTime\.Now|SelectedIndex|ControlValues?\s*=|EditValue\s*=|SelectedValue\s*=', r['raw']):
                defaults.append({'target': r['target'], 'raw': r['raw'][:200], 'cond': norm_guard(r['guard'], cases.get((r['class'], r['method']), {})), 'phase': 'change' if r['method'] in change else 'load', 'ref': f"{os.path.basename(r['file'])}:{r['line']}", 'labels': label_of(re.sub(r'\..*', '', r['target']))})
    # Insert 진입: InsertButton/AddRow 경로의 GROUP 문장
    ins_methods = {r['method'] for r in live if re.search(r'(?i)^(InsertButton|btnInsert\w*|InsertRow\w*|AddRow\w*)$', r['method'])}
    ins = []
    for r in live:
        if r['method'] in ins_methods and r['kind'] in ('MESSAGE', 'RETURN', 'FLOW') and re.search(r'NowGroupID|GROUP', r['guard'] or ''):
            ins.append({'kind': r['kind'], 'raw': r['raw'][:220], 'cond': norm_guard(r['guard'], cases.get((r['class'], r['method']), {})), 'value': (r['value'] or '')[:120], 'ref': f"{os.path.basename(r['file'])}:{r['line']}"})
    ins_stmts = [{'kind': r['kind'], 'raw': r['raw'][:160], 'ref': f"{os.path.basename(r['file'])}:{r['line']}", 'method': r['method']} for r in live if r['method'] in ins_methods and re.search(r'(?i)ActiveRow|AddRow|AddRows|InsertRow|Rows\.Add|GetSelection', r['raw'])]
    # 2026-11-06(SCP0016 EG315 허위 FAIL): ColumnHeaderSpan(row, col, 1, 1, …) 처럼 rowSpan·colSpan 이 모두 1인 문장은 병합이 아니다 → 기대에서 제외
    def _is_1x1(raw):
        m = re.search(r'ColumnHeaderSpan\s*\(\s*[^,]+,\s*[^,]+,\s*(\d+)\s*,\s*(\d+)', raw)
        return bool(m and m.group(1) == '1' and m.group(2) == '1')
    hspan = [{'raw': r['raw'][:120], 'ref': f"{os.path.basename(r['file'])}:{r['line']}", 'method': r['method']} for r in live if re.search(r'ColumnHeaderSpan|AddColumnHeaderSpanCell|ColumnHeader\.(?:Cells\[.*\]\.(?:ColumnSpan|RowSpan))', r['raw']) and r['kind'] != 'BRANCH' and not _is_1x1(r['raw'])]
    excl = sorted(k for k, v in plan_f.items() if v.get('excluded'))
    edit_rules = [{'column': e['column'], 'cond': e['existing_cond'], 'ref': e.get('ref', '')} for e in rd(os.path.join(sd, 'edit_expect.csv')) if (e.get('existing_cond') or '').startswith('RULES:')]
    return {'insertStmts': ins_stmts, 'headerSpan': hspan, 'planExcluded': excl, 'editRules': edit_rules, 'mainClass': main, 'divControls': div_ctl, 'changeMethods': sorted(change), 'loadMethods': sorted(load), 'states': branching, 'stateCountAll': len(states), 'defaults': defaults, 'insertGuards': ins,
            'deadExcluded': sorted(f'{a}.{b}' for a, b in dead), 'hasMerge': any(r['kind'].startswith('GRID') and re.search(r'AddSpan|SpanModel|RowMerge|SetRowSpan|AutoSpan', r['raw']) for r in live)}


# ── DB 최신 조회 ─────────────────────────────────────────────────
def db_facts(cx, mid):
    c = cx.cursor(); f = {}

    def q(sql, **kw):
        c.execute(sql, kw); n = [d[0].lower() for d in c.description]
        return [dict(zip(n, ['' if v is None else str(v) for v in r])) for r in c.fetchall()]
    f['menu'] = (q("SELECT MNU_ID, UPPR_MNU_ID, UNIT_TP_CD, USE_YN, N01_ATR_CTN FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID=:m", m=mid) or [{}])[0]
    f['menuGroups'] = q("SELECT USER_GR_ID, USE_YN FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID=:m", m=mid)
    f['btnAuth'] = q("SELECT USER_GR_ID, SHT_NM, MNU_BTN_CD, USE_YN FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID=:m", m=mid)
    f['columns'] = q("SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, VISIBLE_FLAG, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:m", m=mid)
    f['measures'] = q("SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID FROM SCM_MGR.SCM_MST_SHEET_MEASURE WHERE PROGRAM_ID=:m", m=mid)
    f['lookupMeasure'] = q("SELECT SEGMENT1, SEGMENT3, SEGMENT4, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, VALID_YN FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND SEGMENT2=:m", m=mid)
    f['lookupAdmin'] = q("SELECT SEGMENT1, SEGMENT2, VALID_YN FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='GET_ADMIN_GROUP' AND SEGMENT2 IN ('ALL',:m) AND VALID_YN='Y'", m=mid)
    f['now'] = q("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI') NOW_, TO_CHAR(SYSDATE,'DY','NLS_DATE_LANGUAGE=ENGLISH') DOW, TO_CHAR(SYSDATE,'HH24MI') HM FROM DUAL")[0]
    return f


def account_facts(cx, mid, sid):
    """users.json 명부(사용자 관리) 안의 계정만 — 메뉴 권한·그룹·사업부. id 는 산출물에 쓰지 않고 key(영역/Div/역할)로 표기"""
    uj = json.load(open(os.path.join(ROOT, 'tools', 'E2E', 'users.json'), encoding='utf-8-sig'))
    area = 'SCP' if sid.startswith('SCP') else 'SSP' if sid.startswith('SSP') else 'DM'
    pool, out = {}, []
    for dv, roles in (uj['areas'][area].get('divisions') or {}).items():
        for role, uid in roles.items():
            if uid: pool.setdefault(uid, []).append(f'{area}/{dv}/{role}')
    c = cx.cursor()
    for uid, keys in pool.items():
        c.execute("SELECT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID=:u AND USE_YN='Y'", u=uid); groups = sorted(r[0] for r in c.fetchall())
        c.execute("SELECT DISTINCT M.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M M JOIN SCM_MGR.SCM_ADM_USER_GR_MPG_M G ON G.USER_GR_ID=M.USER_GR_ID WHERE G.USER_ID=:u AND G.USE_YN='Y' AND M.MNU_ID=:m AND M.USE_YN='Y'", u=uid, m=mid); mg = sorted(r[0] for r in c.fetchall())
        c.execute("""SELECT DISTINCT A.UNIT_ID FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A JOIN SCM_MGR.SCM_ADM_USER_GR_MPG_M G ON G.USER_ID=A.USER_ID AND G.USER_GR_ID=A.USER_GR_ID AND G.USE_YN='Y'
                     WHERE A.USER_ID=:u AND A.UNIT_TP_CD='D' AND A.USE_YN='Y'""", u=uid); all_div = sorted(r[0] for r in c.fetchall())
        c.execute("""SELECT DISTINCT A.UNIT_ID FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A JOIN SCM_MGR.SCM_ADM_USER_GR_MPG_M G ON G.USER_ID=A.USER_ID AND G.USER_GR_ID=A.USER_GR_ID AND G.USE_YN='Y'
                     JOIN SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M M ON M.USER_GR_ID=A.USER_GR_ID AND M.MNU_ID=:m AND M.USE_YN='Y' WHERE A.USER_ID=:u AND A.UNIT_TP_CD='D' AND A.USE_YN='Y'""", u=uid, m=mid); menu_div = sorted(r[0] for r in c.fetchall())
        c.execute("""SELECT DISTINCT M.MNU_ID FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M M JOIN SCM_MGR.SCM_ADM_USER_GR_MPG_M G ON G.USER_GR_ID=M.USER_GR_ID JOIN SCM_MGR.SCM_ADM_MNU_M N ON N.MNU_ID=M.MNU_ID
                     WHERE G.USER_ID=:u AND G.USE_YN='Y' AND M.USE_YN='Y' AND N.USE_YN='Y'""", u=uid); menus = sorted(r[0] for r in c.fetchall())
        c.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE USER_ID=:u AND PROGRAM_ID=:m", u=uid, m=mid); ts = int(c.fetchone()[0])
        out.append({'key': keys[0], 'keys': keys, 'groups': groups, 'menuGroups': mg, 'divsAll': all_div, 'divsMenu': menu_div, 'menus': menus, 'titleset': ts})
    return out


def btn_auth_div(cx, mid, acc):
    """CR-070 기대 = PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH_DIV(계정·메뉴·Division) 결과. 키 = 계정 key('__default__' = 기본 계정)"""
    uj = json.load(open(os.path.join(ROOT, 'tools', 'E2E', 'users.json'), encoding='utf-8-sig'))
    cfg = json.load(open(os.path.join(ROOT, 'tools', 'E2E', 'e2e.config.json'), encoding='utf-8-sig'))
    c = cx.cursor(); out = {}
    c.execute("SELECT DIVISION_ID FROM SCM_MGR.SCM_MST_DIVISION WHERE VALID_YN='Y'"); alld = sorted(r[0] for r in c.fetchall())

    def call(uid, divs):
        res = {}
        for d in divs:
            rc = cx.cursor(); c.callproc('SCM_MGR.PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH_DIV', [uid, mid, d, rc])
            names = [x[0].upper() for x in rc.description]; rows = rc.fetchall()
            i = next((k for k, n in enumerate(names) if 'BTN' in n), 0)
            res[d] = sorted({str(r[i]) for r in rows})
        return res
    out['__default__'] = call(cfg.get('defaultAccount'), alld)
    for a in acc:
        area, dv, role = a['key'].split('/', 2); uid = uj['areas'][area]['divisions'][dv][role]
        out[a['key']] = call(uid, a['divsMenu'] or [])
    return out


def main():
    ids = [a.upper() for a in sys.argv[1:] if not a.startswith('-')]
    from dbconn import connect
    os.makedirs(OUT, exist_ok=True)
    with connect('tobe') as cx:
        for sid in ids:
            a = asis_facts(sid)
            d = db_facts(cx, sid); acc = account_facts(cx, sid, sid)
            btn_div = btn_auth_div(cx, sid, acc)
            o = {'id': sid, 'at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'asis': a, 'db': d, 'accounts': acc, 'btnDiv': btn_div}
            with open(os.path.join(OUT, f'{sid}.json'), 'w', encoding='utf-8') as fp: json.dump(o, fp, ensure_ascii=False, indent=0)
            st = (a or {}).get('states') or []
            print(sid, '분기 문장', len(st), '· RAW', sum('RAW(' in s['cond'] for s in st), '· 컨트롤', len({s['ctl'] for s in st}), '· 기본값', len((a or {}).get('defaults') or []), '· Insert guard', len((a or {}).get('insertGuards') or []),
                  '· 계정', len(acc), '· 컬럼 행', len(d['columns']), '· Measure 행', len(d['measures']), '· 룩업', len(d['lookupMeasure']), '· 시각', d['now'])


if __name__ == '__main__':
    main()
