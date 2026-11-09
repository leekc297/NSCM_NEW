"""AS-IS 콤보 원천 추출 — Doc/asisfacts/screens/<AS-IS ID>/combo_src.csv (W1 B4·B3 AS-IS 원천 비교 엔진의 AS-IS 쪽, 2026-10-24)

  python tools/Harness/verify/facts_combosrc.py <AS-IS ID>

연결 고리(화면 .cs, 주석 행 제외):
  ① 원천   dtX = Data.Common(Data.Type.T, isAddALL, p1..p5) · Data_SCP.Common/CommonAll/CommonP6 · Data_FP.Common · Data.<헬퍼>(…)
            · Data.CallBizCommonData("CODE", …) · BLUtils.<헬퍼>(…)(아래 HELPERS 등록분)
  ② 필터   dtX = DBUtils.Filter(dtY, "식"[, bool])   — 원천 순서를 유지하는 클라이언트 필터(DBUtils.cs:297/320)
  ③ 바인딩 clsCtrl.setListBox(dtX, ctrl…) · siX.SetCellTypeCombo(row, …GetColumnIndex(DefColumns.C), dtX) · AddComboColumn("헤더", DefColumns.C, …, dtX, …)
            · SpreadInfo.SetComBoParam("이름", dtX)
래퍼 → SP (GSCM.Common/DLL/CommonData.cs:423-456 · Data*.cs CallBiz*):
  Data.Common/CallBizCommonData → UP_FX_GetCommonDataList(@Code,@Param1..5) — Data.cs:289 switch 의 case 별 code·인자 순서를 그대로 읽는다
  Data_SCP.Common·CommonP6 → UP_FX_GetCommonDataList_SCP · Data_SCP.CommonAll → UP_FX_GetCommonDataList_SCP_ALL · Data_FP.Common → UP_FX_GetCommonDataList_FP
  Data.CallBizBaseCodeData/CommonCode → UP_FX_GetBaseCodeList · Data.CallBizData("YesOrNo") → biz 고정 목록(SP 없음)
산출 열: target_kind(SEARCH|GRID|PARAM), target, label, var, filters, wrapper, sp, code, args, unresolved, ref
  args = JSON [{"n":"@Param1","expr":"C# 식"}] — 값 해석(세션·조회조건·셀 값)은 combo_oracle.py 가 실행 시점에 한다
"""
import csv
import json
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
SRC = os.path.join(ROOT, 'GSCM')
CLS = os.path.join(SRC, '01.Framework', 'GSCM.Windows.Forms', 'Class')
COLS = ['target_kind', 'target', 'label', 'method', 'var', 'filters', 'wrapper', 'sp', 'code', 'args', 'unresolved', 'ref']
WRAP_SP = {'Data.Common': 'UP_FX_GetCommonDataList', 'Data.CallBizCommonData': 'UP_FX_GetCommonDataList',
           'Data_SCP.Common': 'UP_FX_GetCommonDataList_SCP', 'Data_SCP.CommonP6': 'UP_FX_GetCommonDataList_SCP',
           'Data_SCP.CommonAll': 'UP_FX_GetCommonDataList_SCP_ALL', 'Data_FP.Common': 'UP_FX_GetCommonDataList_FP'}
# BLUtils 헬퍼 — 래퍼 위에 필터를 얹은 것(GSCM.Utils/BLUtils.cs). 새 헬퍼를 만나면 원문을 읽고 여기에 등록한다(추측 등록 금지)
HELPERS = {
    'BLUtils.GetDivisionWithoutEE': {'wrapper': 'Data_SCP.Common', 'type': 'Division',
                                     'args': ['UserInfoContext.Current["NowGroupID"]', 'UserInfoContext.Current.UserId'],
                                     'filter': "ATTRIBUTE3 <> 'EE'", 'ref': 'BLUtils.cs:58-117'},
    'BLUtils.GetDivisionESS': {'wrapper': 'Data_SCP.Common', 'type': 'Division',
                               'args': ['UserInfoContext.Current["NowGroupID"]', 'UserInfoContext.Current.UserId'],
                               'filter': "ATTRIBUTE3 = '82'", 'ref': 'BLUtils.cs:58-130'},
    'BLUtils.GetDivision': {'wrapper': 'Data_SCP.Common', 'type': 'Division',
                            'args': ['UserInfoContext.Current["NowGroupID"]', 'UserInfoContext.Current.UserId'],
                            'filter': '', 'ref': 'BLUtils.cs:58-147'},
}
# DM 조회조건 공통 원천 — DataService.GetDMInnerTable(열, Filter)(DataService.cs:3682-4105): FoxQuery DM\Common\BigFilter.xml list_line_dm 1회 실행(결과셋 N개)
#   → 열 이름별 결과셋 번호 · Filter 키(DIVISION_ID·DEPT_ID·END_CUSTOMER, 'ALL'=빈값=전체) 로 거름 → CODE 기준 중복 제거(첫 행 NAME) → CODE 정렬
DM_INNER = {
    'MyDivision': (0, []), 'UserTeamByDivision': (1, ['DIVISION_ID']), 'EndCustomerByDivision': (2, ['DIVISION_ID', 'DEPT_ID']),
    'BizType': (3, ['DIVISION_ID']), 'UserSiteByEndCustomer': (4, ['DIVISION_ID', 'DEPT_ID', 'END_CUSTOMER']),
    'UserPlantSiteByDivision': (5, ['DIVISION_ID']), 'UserPlantSiteByEndCustomer': (6, ['DIVISION_ID', 'END_CUSTOMER']),
    'EdiSender': (7, []), 'ScmSitebyEndCustomer40': (8, []),
}


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def read_text(p):
    for enc in ('utf-8-sig', 'cp949', 'utf-8'):
        try:
            with open(p, encoding=enc) as f:
                return f.read()
        except (UnicodeDecodeError, FileNotFoundError):
            continue
    return ''


def strip_comments(t):
    """// 행 주석·/* */ 블록 주석 제거(문자열 안의 // 는 보존). 줄 수는 유지한다(ref 라인 번호 보존)"""
    out, i, n, s = [], 0, len(t), None
    while i < n:
        ch = t[i]
        if s:
            out.append(ch)
            if ch == '\\' and s == '"' and i + 1 < n:
                out.append(t[i + 1]); i += 2; continue
            if ch == s:
                s = None
        elif ch in '"\'':
            s = ch; out.append(ch)
        elif t.startswith('//', i):
            j = t.find('\n', i); i = n if j < 0 else j; continue
        elif t.startswith('/*', i):
            j = t.find('*/', i + 2); j = n if j < 0 else j + 2
            out.append('\n' * t.count('\n', i, j)); i = j; continue
        else:
            out.append(ch)
        i += 1
    return ''.join(out)


def split_args(s):
    """C# 인자 목록 분해 — 괄호·중괄호·문자열 중첩 고려. s = '(' 다음부터 짝 ')' 까지 포함한 문자열"""
    args, depth, cur, q = [], 0, [], None
    for i, ch in enumerate(s):
        if q:
            cur.append(ch)
            if ch == q and s[i - 1] != '\\':
                q = None
            continue
        if ch in '"\'':
            q = ch; cur.append(ch); continue
        if ch in '([{':
            depth += 1
        elif ch in ')]}':
            if depth == 0:
                if ''.join(cur).strip():
                    args.append(''.join(cur).strip())
                return args, i
            depth -= 1
        if ch == ',' and depth == 0:
            args.append(''.join(cur).strip()); cur = []; continue
        cur.append(ch)
    return args, len(s)


def static_rows(text, var_re):
    """var.Rows.Add("C","N") · var.Rows.Add(new String[] { "C", "N" }) → [{'CODE','NAME'}] (원문 순서)"""
    out = []
    for m in re.finditer(r'(' + var_re + r')\.Rows\.Add\s*\(', text):
        args, _ = split_args(text[m.end():])
        lits = re.findall(r'"((?:[^"\\]|\\.)*)"', ' '.join(args))
        if lits:
            out.append({'CODE': lits[0], 'NAME': lits[1] if len(lits) > 1 else lits[0]})
    return out


def build_catalog():
    """Data*.cs 의 enum Type(Description) · Data.Common switch case · 헬퍼 메서드 → 원천 code·인자 매핑"""
    cat = {'types': {}, 'data_cases': {}, 'helpers': {}, 'biz_static': {}}
    # biz 고정 목록 — GSCM.Common/BLL/CommonData.cs [FoxBizMethod("X")] 본문의 dt.Rows.Add(…) (예 YesOrNo = Y,N : CommonData.cs:37-49)
    bll = strip_comments(read_text(os.path.join(SRC, '03.BIZ', 'GSCM.Common', 'BLL', 'CommonData.cs')))
    for m in re.finditer(r'\[FoxBizMethod\("(\w+)"\)\]', bll):
        seg = bll[m.end():]
        nxt = seg.find('[FoxBizMethod(')
        seg = seg[:nxt if nxt > 0 else 3000]
        rows = static_rows(seg, r'\w+')
        if rows:
            cat['biz_static'][m.group(1)] = rows
    for cls in ('Data', 'Data_SCP', 'Data_FP'):
        t = strip_comments(read_text(os.path.join(CLS, f'{cls}.cs')))
        cat['types'][cls] = {m.group(2): m.group(1) for m in re.finditer(r'\[Description\("([^"]*)"\)\]\s*(\w+)\s*=', t)}
        em = re.search(r'enum\s+Type\s*\{', t)
        if em:  # Description 없는 멤버도 이름으로 대조(SpreadInfo 가 Enum.GetNames 로 대소문자 무시 대조 — SpreadInfo.cs:1457-1466)
            body = t[em.end():t.find('}', em.end())]
            cat.setdefault('enum', {})[cls] = re.findall(r'(?:^|,)\s*(?:\[[^\]]*\]\s*)*(\w+)\s*(?:=\s*\d+)?', body)
        if cls == 'Data':
            body = t[t.find('public static DataTable Common(Type type'):]
            body = body[:body.find('public static DataTable UserDivision(')]
            pend = []
            for m in re.finditer(r'case\s+Type\.(\w+)\s*:|dt\s*=\s*(CallBiz\w+)\s*\(', body):
                if m.group(1):
                    pend.append(m.group(1)); continue
                args, _ = split_args(body[m.end():])
                fn = m.group(2)
                for ty in pend:
                    cat['data_cases'][ty] = {'fn': fn, 'args': args}
                pend = []
            for m in re.finditer(r'public static DataTable (\w+)\(([^)]*)\)\s*\{', t):
                name = m.group(1)
                if name in ('Common', 'CommonList', 'CallBizCommonData', 'CommonCode'):
                    continue
                params = [p.split('=')[0].split()[-1] for p in m.group(2).split(',') if p.strip()]
                seg = t[m.end():m.end() + 1500]
                c = re.search(r'(CallBizCommonData|Common)\s*\(', seg)
                if c:
                    args, _ = split_args(seg[c.end():])
                    cat['helpers'][name] = {'params': params, 'fn': c.group(1), 'args': args}
    return cat


def resolve_source(call, args, cat):
    """원천 호출 → (wrapper, sp, code, [(@이름, 식)], 미해결 사유)"""
    def common(cls_wrap, ty_expr, rest):
        cls = cls_wrap.split('.')[0]
        ty = ty_expr.split('.')[-1].strip()
        desc = cat['types'].get(cls, {}).get(ty)
        if cls == 'Data':
            case = cat['data_cases'].get(ty)
            if case and case['fn'] == 'CallBizCommonData':
                pmap = {f'param{i}': (rest[i] if i < len(rest) else '') for i in range(1, 6)}
                pmap['isAddALL'] = rest[0] if rest else 'false'
                code = case['args'][0].strip('"')
                ps = [pmap.get(a, a) for a in case['args'][1:] if a not in ('isAddALL',) and not re.fullmatch(r'(true|false)', a)]
                return cls_wrap, WRAP_SP[cls_wrap], code, [(f'@Param{i + 1}', e) for i, e in enumerate(ps[:5])], ''
            if case and case['fn'] == 'CallBizBaseCodeData':
                return cls_wrap, 'UP_FX_GetBaseCodeList', case['args'][0].strip('"'), [('@BaseCode', case['args'][0])], ''
            if case and case['fn'] == 'CallBizData' and case['args'][0].strip('"') in cat['biz_static']:
                code = case['args'][0].strip('"')
                return cls_wrap, 'STATIC', code, [('rows', json.dumps(cat['biz_static'][code], ensure_ascii=False))], ''
            if case:
                return cls_wrap, '', case['args'][0].strip('"'), [], f'biz 고정 목록({case["fn"]}) — SP 아님'
            return cls_wrap, WRAP_SP[cls_wrap], desc or ty, [(f'@Param{i}', rest[i]) for i in range(1, min(len(rest), 6))], '' if desc else f'Data.Type.{ty} case 미발견'
        if not desc:
            return cls_wrap, WRAP_SP.get(cls_wrap, ''), ty, [], f'{cls}.Type.{ty} Description 미발견'
        return cls_wrap, WRAP_SP[cls_wrap], desc, [(f'@Param{i}', rest[i]) for i in range(1, min(len(rest), 7))], ''

    if call in ('Data.Common', 'Data_SCP.Common', 'Data_SCP.CommonAll', 'Data_SCP.CommonP6', 'Data_FP.Common'):
        return common(call, args[0] if args else '', args[1:] if len(args) > 1 else [])
    if call == 'Data.CallBizCommonData':
        return call, WRAP_SP[call], args[0].strip('"') if args else '', [(f'@Param{i}', a) for i, a in enumerate(args[1:6], 1) if not re.fullmatch(r'(true|false)', a)], ''
    if call == 'Data.CommonCode':
        return call, 'UP_FX_GetBaseCodeList', args[0].strip('"') if args else '', [('@BaseCode', args[0] if args else '')], ''
    if call.startswith('Data.') and call[5:] in cat['helpers']:
        h = cat['helpers'][call[5:]]
        pv = {p: (args[i] if i < len(args) else '') for i, p in enumerate(h['params'])}
        sub = [pv.get(a, a) for a in h['args']]
        if h['fn'] == 'CallBizCommonData':
            vals = [a for a in sub[1:] if not re.fullmatch(r'(true|false)', a) and a not in ('isAddALL',)]
            return call, WRAP_SP['Data.CallBizCommonData'], sub[0].strip('"'), [(f'@Param{i}', a) for i, a in enumerate(vals[:5], 1)], ''
        return common('Data.Common', sub[0], sub[1:])
    if call in HELPERS:
        h = HELPERS[call]
        w, sp, code, ps, un = common(h['wrapper'], f"Type.{h['type']}", ['false'] + h['args'])
        return w, sp, code, ps, un
    if call == 'DataService.GetDMInnerTable':
        col = args[0].strip('"') if args else ''
        if col not in DM_INNER:
            return call, 'DM_BIGFILTER', col, [], f'GetDMInnerTable 열 {col} 미등록(DataService.cs 원문 확인 후 DM_INNER 등록)'
        idx, keys = DM_INNER[col]
        return call, 'DM_BIGFILTER', col, [('@GROUP_ID', 'UserInfoContext.Current["NowGroupID"]'), ('@USER_ID', 'UserInfoContext.Current.UserId')] \
            + [(f'Filter.{k}', f'Filter["{k}"]') for k in keys], ''
    if call.startswith('local:'):
        return local_source(call[6:], args)
    if call.startswith('static:'):
        return 'DataTable.Rows.Add', 'STATIC', call[7:], [('rows', json.dumps(STATIC_OF[call[7:]], ensure_ascii=False))], ''
    return call, '', '', [], f'원천 함수 {call} 미등록(facts_combosrc.HELPERS 에 원문 확인 후 등록)'


CAT = {}
STATIC_OF = {}  # 화면에서 직접 만든 DataTable — dtX.Rows.Add(…) 순서대로 [{'CODE','NAME'}]
LOCAL = {}  # 화면 로컬 메서드 이름 → {'params': [...], 'sp': 'schema.SP', 'pairs': [(파라미터, 식)], 'inner': (호출, 인자)}


def scan_locals(t):
    """화면 .cs 의 private DataTable 메서드 — FoxDataRequest("스키마.SP") + request.Parameters["K"] = 식, 또는 본문의 Data*/BLUtils 호출"""
    for m in re.finditer(r'(?:private|public|protected|internal)\s+(?:static\s+)?DataTable\s+(\w+)\s*\(([^)]*)\)\s*\{', t):
        name = m.group(1)
        params = [p.split('=')[0].split()[-1] for p in m.group(2).split(',') if p.strip()]
        depth, i = 1, m.end()
        while i < len(t) and depth:
            depth += {'{': 1, '}': -1}.get(t[i], 0); i += 1
        body = t[m.end():i]
        sp = re.search(r'new\s+FoxDataRequest\s*\(\s*"([^"]+)"', body)
        if sp:
            pairs = [(k, v.strip()) for k, v in re.findall(r'\.Parameters\[\s*"([^"]+)"\s*\]\s*=\s*([^;]+);', body)]
            LOCAL[name] = {'params': params, 'sp': sp.group(1), 'pairs': pairs}
            continue
        inner = re.search(r'((?:Data(?:_SCP|_FP)?|BLUtils|DataService)\.\w+)\s*\(', body)
        if inner:
            a, _ = split_args(body[inner.end():])
            LOCAL[name] = {'params': params, 'inner': (inner.group(1), a)}


def local_source(name, args):
    h = LOCAL[name]
    pv = {p: (args[i] if i < len(args) else '') for i, p in enumerate(h['params'])}
    if 'sp' in h:
        sp = h['sp'].split('.')[-1]
        ps = [(f'@{k}', pv.get(v, v)) for k, v in h['pairs']]
        code = next((e.strip('"') for k, e in ps if k.upper() == '@CODE'), '')
        return f'local:{name}', sp, code, [(k, e) for k, e in ps if k.upper() != '@CODE'], ''
    call, a = h['inner']
    return resolve_source(call, [pv.get(x, x) for x in a], CAT)


def designer_labels(text):
    """Designer.cs — layoutControlItem.Control = ctrl / .Text = "라벨" → {ctrl: 라벨}"""
    ctrl_of, text_of = {}, {}
    for m in re.finditer(r'this\.(\w+)\.Control\s*=\s*this\.(\w+);', text):
        ctrl_of[m.group(1)] = m.group(2)
    for m in re.finditer(r'this\.(\w+)\.Text\s*=\s*"([^"]*)";', text):
        text_of[m.group(1)] = m.group(2)
    out = {}
    for item, ctrl in ctrl_of.items():
        if text_of.get(item):
            out[ctrl] = text_of[item].strip()
    for m in re.finditer(r'this\.(\w+)\.(?:LabelText|Caption|TitleText)\s*=\s*"([^"]*)";', text):
        out.setdefault(m.group(1), m.group(2).strip())
    return out


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    sid = sys.argv[1].upper()
    sdir = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid)
    files = [r['file'] for r in read_csv(os.path.join(sdir, 'files.csv')) if r.get('variant') == 'current']
    if not files:
        print(f'[FAIL] {sid}: files.csv current 변형 없음 — AsisFacts 먼저 실행')
        return 1
    global CAT
    CAT = cat = build_catalog()
    src_of, filt_of, binds, labels = {}, {}, [], {}
    texts = []
    for rel in files:
        raw = read_text(os.path.join(SRC, rel))
        if rel.endswith('.Designer.cs'):
            labels.update(designer_labels(raw))
            continue
        t = strip_comments(raw)
        scan_locals(t)
        texts.append((rel, t))
    inline = {}  # 바인딩 인자에 원천 호출을 바로 넣은 경우(SetCellTypeCombo(…, Data.Common(…))) → 가상 변수

    def as_var(expr, ref):
        m = re.match(r'((?:Data(?:_SCP|_FP)?|BLUtils|DataService)\.\w+|\w+)\s*\(', expr.strip())
        if not m or re.fullmatch(r'dt\w+', expr.strip()):
            return expr.strip()
        a, _ = split_args(expr.strip()[m.end():])
        call = m.group(1) if '.' in m.group(1) else (f'local:{m.group(1)}' if m.group(1) in LOCAL else m.group(1))
        key = f'<inline {expr.strip()[:80]}>'
        inline[key] = [(call, a, ref)]
        return key

    sig_re = re.compile(r'(?:private|public|protected|internal)\s+(?:static\s+|override\s+|async\s+)*[\w<>\[\],\s]*?\s(\w+)\s*\([^;{)]*\)\s*\{')
    for rel, t in texts:
        base = os.path.basename(rel)
        line = lambda pos: t.count('\n', 0, pos) + 1  # noqa: E731
        sigs = [(m.start(), m.group(1)) for m in sig_re.finditer(t)]

        def method_at(pos, sigs=sigs):
            name = '<field>'
            for sp_, nm in sigs:
                if sp_ > pos:
                    break
                name = nm
            return name

        def var_value(name, pos, t=t):
            """필터식이 변수면 같은 파일에서 그 위치 직전의 마지막 대입식(문자열 조립식)을 돌려준다"""
            if not re.fullmatch(r'\w+', name):
                return name
            last = None
            for m in re.finditer(r'\b' + re.escape(name) + r'\s*\+?=\s*([^;]+);', t[:pos]):
                last = m.group(1).strip()
            return f'{name} := {last}' if last else name

        for m in re.finditer(r'(\w+)\s*=\s*((?:Data(?:_SCP|_FP)?|BLUtils|DataService)\.\w+|\w+)\s*\(', t):
            fn = m.group(2)
            if '.' not in fn:
                if fn not in LOCAL:
                    continue
                fn = f'local:{fn}'
            args, _ = split_args(t[m.end():])
            src_of.setdefault(m.group(1), []).append((fn, args, f'{base}:{line(m.start())}'))
        for m in re.finditer(r'(\w+)\s*=\s*DBUtils\.Filter\s*\(', t):
            args, _ = split_args(t[m.end():])
            if args:
                filt_of.setdefault(m.group(1), []).append((args[0], var_value(args[1], m.start()) if len(args) > 1 else '', f'{base}:{line(m.start())}'))
        # dtX = dtY.Select("식").CopyToDataTable() — 같은 의미의 클라이언트 필터
        for m in re.finditer(r'(\w+)\s*=\s*(\w+)\.Select\s*\(\s*("(?:[^"\\]|\\.)*"|[^)]*)\)\s*\.CopyToDataTable\s*\(\s*\)', t):
            filt_of.setdefault(m.group(1), []).append((m.group(2), m.group(3), f'{base}:{line(m.start())}'))
        for m in re.finditer(r'\.setListBox\s*\(', t):
            args, _ = split_args(t[m.end():])
            if len(args) >= 2:
                binds.append(('SEARCH', args[1].replace('this.', ''), '', as_var(args[0], f'{base}:{line(m.start())}'), f'{base}:{line(m.start())}', method_at(m.start())))
        for m in re.finditer(r'\.SetCellTypeCombo\s*\(', t):
            args, _ = split_args(t[m.end():])
            c = re.search(r'DefColumns\.(\w+)', ' '.join(args[:-1]))
            if c and args:
                binds.append(('GRID', c.group(1), '', as_var(args[-1], f'{base}:{line(m.start())}'), f'{base}:{line(m.start())}', method_at(m.start())))
        for m in re.finditer(r'\.AddComboColumn\w*\s*\(', t):
            args, _ = split_args(t[m.end():])
            c = re.search(r'DefColumns\.(\w+)', ' '.join(args))
            dv = next((a for a in args if re.fullmatch(r'dt\w+', a)), '')
            if c and dv:
                binds.append(('GRID', c.group(1), args[0].strip('"'), dv, f'{base}:{line(m.start())}', method_at(m.start())))
        for m in re.finditer(r'SetComBoParam\s*\(', t):
            args, _ = split_args(t[m.end():])
            if len(args) >= 2:
                binds.append(('PARAM', args[0].strip('"'), '', args[1], f'{base}:{line(m.start())}', method_at(m.start())))

    for rel, t in texts:
        for m in re.finditer(r'(\w+)\.Rows\.Add\s*\(', t):
            STATIC_OF.setdefault(m.group(1), [])
        for v in list(STATIC_OF):
            STATIC_OF[v] = STATIC_OF[v] or static_rows(t, re.escape(v))
            if STATIC_OF[v] and v not in src_of:
                src_of[v] = [(f'static:{v}', [], f'{os.path.basename(rel)} Rows.Add')]
    # 시트 메타 콤보(AS-IS SCM_MST_SHEET_COLUMNS.CELL_COMBO_DATA_TYPE) — SetComBoParam 등록 이름이면 그 DataTable, 아니면 Data.Common(Data.Type.<값>)
    #   (SpreadInfo.cs:1453-1478 · 1950-1990 comboParamsList 우선)
    params = {b[1]: b[3] for b in binds if b[0] == 'PARAM'}
    dtypes = {k.upper(): k for k in list(cat['types'].get('Data', {})) + cat.get('enum', {}).get('Data', [])}
    for r in read_csv(os.path.join(sdir, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv')):
        if (r.get('CELL_CONTROL_OBJECT_TYPE_CODE') or '') != 'FPComboBox' or (r.get('VALID_YN') or 'Y') != 'Y':
            continue
        ct = (r.get('CELL_COMBO_DATA_TYPE') or '').strip()
        col = (r.get('COLUMN_NAME') or '').strip()
        ref = f"SCM_MST_SHEET_COLUMNS {r.get('PROGRAM_ID')}/{r.get('SHEET_NAME')}/{col}"
        if not ct or not col:
            continue
        if ct in params:
            binds.append(('GRID', col, r.get('COLUMN_LABEL_NAME') or '', params[ct], ref, 'SheetMeta'))
        elif ct.upper() in dtypes:
            key = f'<meta Data.Type.{dtypes[ct.upper()]}>'
            inline[key] = [('Data.Common', [f'Data.Type.{dtypes[ct.upper()]}'], ref)]
            binds.append(('GRID', col, r.get('COLUMN_LABEL_NAME') or '', key, ref, 'SheetMeta'))
        else:
            binds.append(('GRID', col, r.get('COLUMN_LABEL_NAME') or '', f'<meta {ct}>', ref, 'SheetMeta'))

    def chain(var, depth=0, seen=None):
        """변수 → [(원천 호출, 인자, ref, [필터식…])] — Filter 체인을 원천까지 거슬러 올라간다(분기별 대입은 모두 열거)"""
        seen = seen or set()
        if var in seen or depth > 6:
            return []
        seen = seen | {var}
        out = [(c, a, r, []) for c, a, r in src_of.get(var, []) + inline.get(var, [])]
        for up, expr, r in filt_of.get(var, []):
            for c, a, r0, fl in chain(up, depth + 1, seen):
                out.append((c, a, r0, fl + [f'{expr} @{r} ({up}→{var})']))
        return out

    rows = []
    for kind, target, label, var, ref, meth in binds:
        srcs = chain(var)
        if not srcs:
            rows.append({'target_kind': kind, 'target': target, 'label': label or labels.get(target, ''), 'method': meth, 'var': var, 'filters': '',
                         'wrapper': '', 'sp': '', 'code': '', 'args': '[]', 'unresolved': f'{var} 원천 대입 미발견(필드 초기화·외부 주입 확인)', 'ref': ref})
            continue
        for call, args, sref, fl in srcs:
            w, sp, code, ps, un = resolve_source(call, args, cat)
            if call in HELPERS and HELPERS[call]['filter']:
                fl = [f"{HELPERS[call]['filter']} @{HELPERS[call]['ref']}"] + fl
            rows.append({'target_kind': kind, 'target': target, 'label': label or labels.get(target, ''), 'method': meth, 'var': var,
                         'filters': ' ▸ '.join(fl), 'wrapper': w, 'sp': sp, 'code': code,
                         'args': json.dumps([{'n': n, 'expr': e} for n, e in ps], ensure_ascii=False), 'unresolved': un, 'ref': f'{ref} ← {sref}'})
    seen, uniq = set(), []
    for r in rows:
        k = tuple(r[c] for c in ('target_kind', 'target', 'method', 'var', 'sp', 'code', 'filters', 'args'))
        if k not in seen:
            seen.add(k); uniq.append(r)
    out = os.path.join(sdir, 'combo_src.csv')
    with open(out, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows(uniq)
    un = sum(1 for r in uniq if r['unresolved'])
    print(f'{sid}: 콤보 원천 {len(uniq)}행(바인딩 {len(binds)} · 미해결 {un}) → {out}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
