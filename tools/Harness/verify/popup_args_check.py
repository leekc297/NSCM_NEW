"""G5 팝업 조건 연동 정적 검사 — AS-IS 팝업 호출 인자 ↔ TO-BE 모달 전달값 + 화면 조회조건 연동 (2026-10-29)

사용자 요청(10-29, SCP0020): 조회조건 MODEL/NICKNAME 팝업 기동 시 DIV·MODEL 코드는 조회조건에서 연동되는데 OPERATION GROUP 이
  연동되지 않는다(TO-BE 가 operationGroup: '' 고정 전달). G5 는 E2E(@verify) 전용이라 실행하지 못한 행이 전부 NA(W7 수동)로
  지나가 이 오류가 CheckList 에 나오지 않았다 → 정적 검사기로 판정한다. 화면 고유값(조건명·모달명·변수명)을 쓰지 않는다.

판정 단위(item)
  ASIS 축 — AS-IS 팝업 호출(new X(...) · pop.Form_Load(...) · pop.Prop = v)의 인자마다:
      인자의 출처(지역 변수 대입 추적 → 컨트롤 .ControlValues/.Text · 그리드 셀 DefColumns.X · 리터럴)를 구하고
      짝지은 TO-BE 모달 사용처의 같은 개념 인자가
        값에 바인딩 = PASS · 빈값/고정값 = FAIL(연동 누락) · TO-BE 모달에 대응 인자 없음 = NA(팝업 교체·조건 축소 — 사람 확인)
      AS-IS 리터럴 인자("" · true · 숫자)는 연동 대상 아님 = NA
  TOBE 축 — TO-BE 모달 사용처의 인자마다(CR-004 '팝업이 연결된 조회조건은 입력값을 팝업 조건으로 전달' · 사용자 10-29):
        빈값/고정값인데 같은 개념의 화면 조회조건이 있음 = FAIL(연동 누락)
        빈값/고정값이고 대응 조회조건 없음 = PASS(고정 조건)
        값에 바인딩 = PASS(같은 개념 또는 화면 값) · 다른 개념 값 = NA(사람 확인)
  추출 실패(모달 속성 해석 불가·조회조건 상태 추출 불가) = ERROR(검사기 한계) — FAIL 로 적지 않는다

추출 한계(명시)
  - TO-BE: 페이지 폴더 .tsx 의 JSX `<…Modal|…Popup …>` 여는 태그 속성 중 객체 리터럴(`={{ … }}`)·스칼라 값만. 변수로 넘긴 객체는
    같은 파일의 `const v = { … }` / `useMemo(() => ({ … }))` 까지만 따라간다. 모달 내부에서 인자를 바꾸는 처리는 보지 않는다.
  - 화면 조회조건 = SearchArea/FormItem 이 있는 파일에서 searchCondition 별칭(sc 등).<필드> 로 쓰는 필드
  - 개념 대응 = 이름 정규화(접두 cbo/clb/txt… · 접미 Id/Ids/Cd/Code/List 제거 · 동의어 item=material=model=nickname, div=division)
  - '고정 조건 수정 불가'(팝업에서 Div 비활성 등)는 판정하지 않는다(E2E @verify G5 · H6 몫)

  python popup_args_check.py <MENU_ID> [--asis <AS-IS ID>]   → Doc/verify/<ID>/popup_args.csv
"""
import csv, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); from asis_live import dead_methods, dead_sps, sp_base  # noqa: E402
from collections import Counter
from asis_variant import is_cur  # 2026-11-09 T172: variant 'only' 화면(SSP 등 180) = 현행 — 판정 단일 원천

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)

FIELDS = ['menu_id', 'side', 'pair', 'asis_ref', 'asis_method', 'asis_popup', 'asis_param', 'asis_arg', 'asis_source', 'concept',
          'tobe_ref', 'tobe_modal', 'tobe_key', 'tobe_value', 'host_label', 'screen_field', 'verdict', 'note']
SYN = {'material': 'item', 'model': 'item', 'nickname': 'item', 'nick': 'item', 'mat': 'item', 'div': 'division',
       'opergroup': 'operationgroup', 'opgroup': 'operationgroup', 'operationgrp': 'operationgroup', 'opergrp': 'operationgroup'}
# 모달의 표시·동작용 속성(조건 인자 아님)
NON_PARAM = re.compile(r'^(open|size|height|width|min\w*|max\w*|type|position|className|style|key|ref|children|title|customHeaderTitle|'
                       r'disable\w*|hide\w*|show\w*|multi\w*|readOnly|fullWidth|loading|callFromCell|on[A-Z]\w*|set[A-Z]\w*|handle[A-Z]\w*|modalClose|fallbackColumns|visibleMeasures|measures)$')
PRIMITIVE = {'CustomDialog', 'Dialog', 'MuiDialog'}
UI_ONLY_PROP = re.compile(r'^(StartPosition|Location|Size|Owner|Width|Height|TopMost|ShowInTaskbar|Text|Icon|MaximizeBox|MinimizeBox|WindowState|Font|BackColor)$')
STATE_ROOT = {'sc', 'searchCondition', 'cond', 'condition', 'state', 's', 'row', 'item', 'r', 'e', 'props', 'params', 'p', 'record', 'rec', 'data', 'current', 'value'}
JS_NOISE = {'String', 'Number', 'Boolean', 'join', 'toString', 'trim', 'map', 'filter', 'length', 'split', 'toUpperCase', 'toLowerCase',
            'true', 'false', 'null', 'undefined', 'as', 'const', 'ALL', 'gridRef', 'GridUtils', 'getRow', 'current'}


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def concept(name):
    s = re.sub(r'^(cbo|clb|cmb|txt|dtp|rdo|chk|lst|num|str|s|p|v|_)(?=[A-Z])', '', (name or '').strip())
    s = re.sub(r'[^A-Za-z0-9]', '', s).lower()
    for _ in range(3):
        s2 = re.sub(r'(ids|id|cds|cd|codes|code|list|values|value|nm|nms)$', '', s)
        if s2 == s or len(s2) < 3:
            break
        s = s2
    if s.endswith('s') and len(s) > 4 and not s.endswith(('ss', 'us')):
        s = s[:-1]
    return SYN.get(s, s)


def split_top(text, sep=','):
    out, depth, q, cur = [], 0, '', ''
    for ch in text:
        if q:
            cur += ch
            if ch == q:
                q = ''
            continue
        if ch in '\'"`':
            q = ch; cur += ch; continue
        if ch in '([{':
            depth += 1
        elif ch in ')]}':
            depth -= 1
        if ch == sep and depth == 0:
            out.append(cur); cur = ''
        else:
            cur += ch
    if cur.strip():
        out.append(cur)
    return [x.strip() for x in out if x.strip()]


def balanced(src, i, open_ch='{', close_ch='}'):
    """src[i] == open_ch → 짝 닫힘 다음 인덱스. 문자열 내부 무시"""
    depth, q, j = 0, '', i
    while j < len(src):
        ch = src[j]
        if q:
            if ch == q and src[j - 1] != '\\':
                q = ''
        elif ch in '\'"`':
            q = ch
        elif ch == open_ch:
            depth += 1
        elif ch == close_ch:
            depth -= 1
            if depth == 0:
                return j + 1
        j += 1
    return -1


def strip_comments(src):
    src = re.sub(r'/\*.*?\*/', lambda m: re.sub(r'[^\n]', ' ', m.group(0)), src, flags=re.S)
    src = re.sub(r'\{\s*/\*.*?\*/\s*\}', lambda m: ' ' * len(m.group(0)), src, flags=re.S)
    return re.sub(r'(?<![:\'"])//[^\n]*', lambda m: ' ' * len(m.group(0)), src)


def classify(expr):
    e = (expr or '').strip()
    e = re.sub(r'\s+as\s+[\w<>\[\]|. ]+$', '', e)
    if e in ("''", '""', '``', 'undefined', 'null', '[]', '{}', ''):
        return 'EMPTY', ''
    if re.fullmatch(r"'[^']*'|\"[^\"]*\"|`[^`$]*`|-?\d+(\.\d+)?|true|false|[A-Z][A-Z0-9_]*(\.[A-Z][A-Z0-9_]*)*", e):
        return 'LITERAL', ''
    ids = [x for x in re.findall(r'[A-Za-z_]\w*', re.sub(r"'[^']*'|\"[^\"]*\"", ' ', e)) if x not in JS_NOISE]
    props = re.findall(r'\.\s*([A-Za-z_]\w*)', e)
    props = [x for x in props if x not in JS_NOISE and x not in STATE_ROOT]  # routePopup.row?.FROM_COUNTRY → FROM_COUNTRY (행·상태 루트 제외, 마지막 속성)
    pick = props[-1] if props else next((x for x in ids if x not in STATE_ROOT), ids[0] if ids else '')
    if not pick:
        return 'LITERAL', ''
    return 'BOUND', pick


def page_dir(mid):
    for r in read_csv(P('Doc', 'tobefacts', 'screens', '_index.csv')):
        if r['menu_id'].upper() == mid and '/components/' not in r['page_key']:
            feat, *rest = r['page_key'].split('/')
            return P('nscm-fe', 'features', feat, 'src', 'pages', *rest)
    return ''


def fe_sources(pdir):
    out = {}
    for dp, _, fs in os.walk(pdir):
        if 'node_modules' in dp:
            continue
        for f in fs:
            if f.endswith(('.ts', '.tsx')) and not f.endswith(('.test.ts', '.test.tsx', '.spec.ts')):
                p = os.path.join(dp, f)
                with open(p, encoding='utf-8', errors='replace') as h:
                    out[p] = strip_comments(h.read())
    return out


def line_of(src, i):
    return src.count('\n', 0, i) + 1


def resolve_object(src, ident, before):
    """같은 파일에서 `const ident = { … }` / `useMemo(() => ({ … }))` 객체 리터럴 본문"""
    for m in re.finditer(r'\bconst\s+' + re.escape(ident) + r'\b[^=]*=\s*(useMemo\(\s*\(\)\s*=>\s*\(\s*)?\{', src[:before]):
        st = m.end() - 1
        en = balanced(src, st)
        if en > 0:
            return src[st + 1:en - 1]
    return None


def tobe_usages(srcs, rel):
    """JSX 모달 사용처 → [{file, line, modal, params:[(key, expr, prop)], open_expr, error}]"""
    out = []
    for f, src in srcs.items():
        own = os.path.splitext(os.path.basename(f))[0]
        for m in re.finditer(r'<([A-Z]\w*(?:Modal|Popup|Dialog))\b', src):
            name = m.group(1)
            if name in PRIMITIVE or name == own:
                continue
            i, attrs, err = m.end(), [], ''
            while i < len(src):
                while i < len(src) and src[i].isspace():
                    i += 1
                if src.startswith('/>', i) or src.startswith('>', i):
                    break
                am = re.match(r'([A-Za-z_][\w-]*)\s*(=\s*)?', src[i:])
                if not am:
                    err = f"속성 해석 불가({src[i:i + 30]!r})"; break
                key = am.group(1); i += am.end()
                if not am.group(2):
                    attrs.append((key, 'true')); continue
                if src[i] == '{':
                    en = balanced(src, i)
                    if en < 0:
                        err = '중괄호 짝 해석 불가'; break
                    attrs.append((key, src[i + 1:en - 1].strip())); i = en
                elif src[i] in '\'"':
                    en = src.find(src[i], i + 1)
                    attrs.append((key, src[i:en + 1])); i = en + 1
                else:
                    err = f"속성 값 해석 불가({key})"; break
            params, open_expr = [], ''
            for key, val in attrs:
                if key == 'open':
                    open_expr = val
                if NON_PARAM.match(key) or re.search(r'=>|^function\b|^<', val):
                    continue
                body = None
                if val.startswith('{') and val.endswith('}'):
                    body = val[1:-1]
                elif re.fullmatch(r'[a-z]\w*', val) and re.search(r'(?i)param|cond|search|filter', key):
                    body = resolve_object(src, val, m.start())
                if body is not None:
                    for ent in split_top(body):
                        if ent.startswith('...'):
                            params.append(('(spread)', ent, key)); continue
                        km = re.match(r"['\"]?([A-Za-z_]\w*)['\"]?\s*:\s*(.*)$", ent, re.S)
                        if km:
                            params.append((km.group(1), km.group(2).strip(), key))
                        elif re.fullmatch(r'[A-Za-z_]\w*', ent):
                            params.append((ent, ent, key))
                else:
                    params.append((key, val, ''))
            out.append({'file': f, 'rel': rel(f), 'line': line_of(src, m.start()), 'modal': name, 'params': params, 'open': open_expr,
                        'attrs': dict(attrs), 'error': err, 'pos': m.start()})
    return out


def screen_fields(srcs):
    """조회조건 상태 필드 → {field: label}. 메인 조회영역(SearchArea/FormItem) 파일의 조회조건 상태 별칭.<필드>
    별칭 = store 선택자 state.(searchCondition|searchParams|condition…) 를 받은 변수 + FormItem 컨트롤 value={X.f} 의 X
    팝업 컴포넌트 파일(이름에 Modal/Popup/Dialog)의 자체 조회영역은 메인 조회조건이 아니므로 제외"""
    fields = {}
    for f, src in srcs.items():
        if not re.search(r'<SearchArea\b|<FormItem\b|<SearchFields\b', src) or re.search(r'(Modal|Popup|Dialog)', os.path.basename(f)):
            continue
        aliases = {'searchCondition'}
        aliases |= set(re.findall(r'const\s+(\w+)\s*=\s*\w+\(\s*\(?\s*\w+\s*\)?\s*=>\s*\w+\.(?:searchCondition|searchConditions|searchParams?|conditions?|searchForm)\s*\)', src))
        aliases |= set(re.findall(r'searchCondition\s*:\s*(\w+)', src))
        aliases |= {a for a in re.findall(r'\bvalue=\{\s*([a-z]\w*)\.[A-Za-z_]\w*', src) if a not in ('e', 'event', 'option', 'opt', 'row', 'item', 'r')}
        for al in aliases:
            for fm in re.finditer(r'\b' + re.escape(al) + r'\.([A-Za-z_]\w*)', src):
                fld = fm.group(1)
                win = src[max(0, fm.start() - 700):fm.start()]
                labs = re.findall(r"t\(\s*(?:LBL\.\w+|'[^']*'|\"[^\"]*\")\s*,\s*'_?([^']+)'\s*\)", win) + re.findall(r"\(\s*LBL\.\w+\s*,\s*'_?([^']+)'", win)
                lab = labs[-1].strip() if labs else ''
                if fld not in fields or (lab and not fields[fld]):
                    fields[fld] = lab
    return fields


def host_label(srcs, usage):
    """모달을 여는 조회조건 라벨 — open={X} → setX(true) → onY={() => setX(true)} → 폼의 onY 위치 앞 라벨"""
    o = usage['open']
    vm = re.match(r'^!?!?\s*([A-Za-z_]\w*)', o or '')
    if not vm:
        return ''
    var = vm.group(1)
    setter = 'set' + var[0].upper() + var[1:]
    pats = [re.escape(setter) + r'\(\s*(true|[A-Z_.]+|\w+\.\w+)\s*\)']
    rx_lab = r"t\(\s*(?:LBL\.\w+|'[^']*'|\"[^\"]*\")\s*,\s*'_?([^']+)'\s*\)"
    # 2026-11-18 SCP0111: open 상태(useState)는 모달을 그린 컴포넌트 파일 안에서만 유효 — 다른 파일의 같은 이름 setter(그리드·화면 모두 setOpenItemModal)를 잡아 그리드 셀 팝업에 조회조건 라벨이 붙던 결함
    for f, src in [(f, s) for f, s in srcs.items() if f == usage.get('file')] or list(srcs.items()):
        for pm in re.finditer(pats[0], src):
            before = src[max(0, pm.start() - 120):pm.start()]
            pn = re.search(r'(\w+)\s*=\s*\{\s*\(\)\s*=>\s*$', before)
            if re.search(r'<SearchArea\b|<FormItem\b', src) and not pn:
                labs = re.findall(rx_lab, src[max(0, pm.start() - 900):pm.start()])
                if labs:
                    return labs[-1].strip()
            if pn:
                prop = pn.group(1)
                for f2, s2 in srcs.items():
                    if not re.search(r'<SearchArea\b|<FormItem\b', s2):
                        continue
                    # 2026-11-18 SCP0111: 함수 인자로 넘기는 형태 popupField(…,\n  onItemSearch\n)(앞 ',' · 뒤 줄바꿈 + ')')도 여는 위치로 본다(host_label 빈값 → SEARCH G5 행 미연결 · 미검증)
                    for um in re.finditer(r'[={(,]\s*' + re.escape(prop) + r'\b(?!\s*[:,]\s*\(?\s*\))', s2):
                        if re.match(r'\s*[}),]', s2[um.end():um.end() + 40]) or s2[um.end():um.end() + 1] in ('}', ')', ' '):
                            labs = re.findall(rx_lab, s2[max(0, um.start() - 900):um.start()])
                            if labs and 'interface' not in s2[max(0, um.start() - 40):um.start()]:
                                return labs[-1].strip()
    return ''


def asis_popups(aid):
    """AS-IS 팝업 호출 → [{cls_method, file, line, popup, var, args:[(param, arg, source_kind, source, concept)], result_concepts}]"""
    acts = read_csv(P('Doc', 'asisfacts', 'screens', aid, 'actions.csv'))
    cur = {f['file'] for f in read_csv(P('Doc', 'asisfacts', 'screens', aid, 'files.csv')) if is_cur(f)}
    dead = dead_methods(aid)  # 실행되지 않는 AS-IS 메서드의 팝업 호출 제외(2026-10-30 asis_live)
    acts = [a for a in acts if (not cur or a['file'] in cur) and (a['class'], a['method']) not in dead]
    by_m = {}
    for a in acts:
        by_m.setdefault((a['class'], a['method']), []).append(a)
    src_cache, out = {}, []

    def src_lines(rel):
        if rel not in src_cache:
            fp = P('GSCM', *re.split(r'[\\/]', rel))
            try:
                with open(fp, encoding='utf-8-sig', errors='replace') as h:
                    src_cache[rel] = h.read().split('\n')
            except OSError:
                src_cache[rel] = []
        return src_cache[rel]

    for (cls, meth), rows in by_m.items():
        rows.sort(key=lambda a: int(a['line'] or 0))
        pops = [a for a in rows if a['kind'] == 'POPUP' and 'ProgressForm' not in a['target'] and not a['target'].startswith('prg.')
                and not re.search(r'MessageBox|SaveFileDialog|OpenFileDialog|FolderBrowser', a['target'])]
        if not pops:
            continue
        var_cls = {}
        for a in pops:
            cm = re.match(r'^new\s+([\w.]+)$', a['target'])
            if cm:
                ln = src_lines(a['file'])
                txt = ln[int(a['line']) - 1] if 0 < int(a['line']) <= len(ln) else ''
                # T371(2026-11-19 SCP0005): 'X popup = new GSCM.SCM.PopUp.UIL.X()' 처럼 이름공간이 붙은 new 도 변수 이름을 찾는다(종전엔 '_GSCM…' 로 남아 popup.ROUTE_ID 대입이 인자에서 빠짐)
                vm = re.search(r'(\w+)\s*=\s*new\s+(?:\w+\.)*' + re.escape(cm.group(1).split('.')[-1]), txt)
                var_cls[vm.group(1) if vm else '_' + cm.group(1)] = cm.group(1).split('.')[-1]
        locals_ = [a for a in rows if a['kind'] == 'LOCAL']
        # T371: 팝업 객체를 지역 변수 선언 문장(LOCAL 'X pop = new X();')으로 만들고 pop.Form_Load(…)·pop.ShowDialog() 로 여는 경우 — 종전엔 POPUP 행의 new 만 보아
        #   Form_Load 인자가 통째로 빠졌다(SCP0005 btnFromSrch·btnToSrch·셀 더블클릭 도시 팝업 cs:343·361·1137)
        for lo in locals_:
            lm = re.match(r'^(?:[\w.<>]+\s+)?(\w+)\s*=\s*new\s+((?:\w+\.)*(\w+))\s*\(', lo['target'])
            if lm and lm.group(1) not in var_cls and any(re.match(r'^' + re.escape(lm.group(1)) + r'\.(ShowDialog|Show|Form_Load)$', p['target']) for p in pops):
                var_cls[lm.group(1)] = lm.group(3)

        def resolve(arg, line):
            arg = arg.strip()
            if re.fullmatch(r'"[^"]*"|true|false|null|-?\d+(\.\d+)?|string\.Empty|String\.Empty|CAppSetting\.\w+|"?"?', arg):
                return 'LITERAL', arg, ''
            src_expr = arg
            if re.fullmatch(r'[A-Za-z_]\w*', arg):
                cand = None
                for lo in locals_:
                    if int(lo['line']) >= line:
                        continue
                    t = lo['target']
                    dm = re.match(r'^(?:[\w<>\[\],.]+\s+)?' + re.escape(arg) + r'\s*=\s*(.+?);?$', t)
                    if dm:
                        cand = dm.group(1)
                    elif t == arg and lo.get('value'):
                        cand = lo['value']
                if cand is None:
                    return 'VAR', arg, concept(arg)
                src_expr = cand
            cm = re.search(r'DefColumns\.(\w+)', src_expr)
            if cm:
                return 'GRID', f"셀 {cm.group(1)}", concept(cm.group(1))
            ctl = re.findall(r'\b([a-z]{2,4}[A-Z]\w*)\.(ControlValues|Text|Value|SelectedValue|EditValue|Checked|ControlText|SelectedItem)', src_expr)
            if ctl:
                return 'CONTROL', f"{ctl[-1][0]}.{ctl[-1][1]}", concept(ctl[-1][0])
            if re.fullmatch(r'\s*"[^"]*"\s*|string\.Empty', src_expr):
                return 'LITERAL', src_expr.strip(), ''
            return 'EXPR', src_expr[:80], concept(arg)

        results = set()
        for a in rows:
            if a['kind'] in ('VALUE_SET',) and any(int(a['line']) > int(p['line']) for p in pops):
                tm = re.match(r'^([a-z]{2,4}[A-Z]\w*)\.(Text|ControlValues|Value)$', a['target'])
                if tm:
                    results.add(concept(tm.group(1)))
        calls = []
        for a in pops:
            cm = re.match(r'^new\s+([\w.]+)$', a['target'])
            mm = re.match(r'^(\w+)\.(\w+)$', a['target'])
            args_txt = (a.get('value') or '').strip()
            if args_txt.startswith('(') and args_txt.endswith(')'):
                args_txt = args_txt[1:-1]
            if cm:
                calls.append((a, cm.group(1).split('.')[-1], '(생성자)', split_top(args_txt)))
            elif mm and mm.group(1) in var_cls and mm.group(2) not in ('ShowDialog', 'Show', 'Dispose', 'Close'):
                calls.append((a, var_cls[mm.group(1)], mm.group(2), split_top(args_txt)))
        # 팝업 속성 대입(pop.Division = x) — 인자와 같은 취급
        for a in rows:
            pm = re.match(r'^(\w+)\.(\w+)$', a['target'])
            if a['kind'] in ('UI_PROP', 'VALUE_SET', 'DATA_OP') and pm and pm.group(1) in var_cls and not UI_ONLY_PROP.match(pm.group(2)) and a.get('value'):
                calls.append((a, var_cls[pm.group(1)], f"={pm.group(2)}", [a['value']]))
        for a, pcls, how, args in calls:
            if not args:
                continue
            pnames = popup_params(pcls, how, len(args))
            items = []
            for k, arg in enumerate(args):
                kind, srcd, cpt = resolve(arg, int(a['line']))
                pname = how[1:] if how.startswith('=') else (pnames[k] if k < len(pnames) else f"#{k + 1}")
                cands = {c for c in (cpt, concept(arg), concept(pname)) if c}
                items.append({'param': pname, 'arg': arg, 'kind': kind, 'source': srcd, 'concept': cpt or concept(pname), 'cands': cands})
            out.append({'cls': cls, 'method': meth, 'file': os.path.basename(a['file']), 'line': a['line'], 'popup': pcls, 'how': how,
                        'items': items, 'results': results})
    return out


_POP_IDX = {}


def popup_params(pcls, how, n):
    """AS-IS 팝업 원문의 시그니처(Form_Load/생성자) 인자 이름 — 이름 개념이 TO-BE 인자와 짝짓는 데 쓰인다"""
    if not _POP_IDX:
        for dp, _, fs in os.walk(P('GSCM', '06.UIL')):
            for f in fs:
                if f.endswith('.cs') and not f.endswith('.Designer.cs'):
                    _POP_IDX.setdefault(f[:-3], os.path.join(dp, f))
        _POP_IDX.setdefault('__built__', '')
    fp = _POP_IDX.get(pcls)
    if not fp:
        return []
    try:
        src = open(fp, encoding='utf-8-sig', errors='replace').read()
    except OSError:
        return []
    name = pcls if how == '(생성자)' else how
    for m in re.finditer(r'public\s+(?:[\w<>]+\s+)?' + re.escape(name) + r'\s*\(([^)]*)\)', src):
        ps = [x for x in split_top(m.group(1)) if x]
        if len(ps) == n:
            return [re.split(r'\s+', x.strip().split('=')[0].strip())[-1] for x in ps]
    return []


def judge_literal(param, value, hit):
    """AS-IS 고정 인자 ↔ TO-BE (EG282 · 문서 DM-43 sMdmActive_Sw=Y). hit = (키, 값) 또는 None
    플래그 이름(Sw·Flag·Yn·Active)만 값 대조 — 그 밖 고정값은 연동 대상이 아니므로 NA 유지"""
    v = (value or '').strip().strip('"').strip("'")
    if not re.search(r'(_?sw|flag|yn|active)$', param or '', re.I) or v == '':
        return 'NA', f'AS-IS 고정값 {value} — 연동 대상 아님'
    if hit is None:
        return 'ERROR', f"[확인 대상] AS-IS 고정 플래그 {param}={v} 를 TO-BE 팝업에 전달 안 함 — 팝업 기본값이 같은지 확인"
    tv = (hit[1] or '').strip().strip('"').strip("'")
    if re.fullmatch(r'[\w-]*', tv) and not re.search(r'[.(]', hit[1] or ''):
        if tv == v:
            return 'PASS', f'고정 플래그 {param}={v} = TO-BE {hit[0]}={tv}'
        return 'FAIL', f'고정 플래그 {param} AS-IS {v} ↔ TO-BE {hit[0]}={tv or chr(39) * 2}'
    return 'NA', f'고정 플래그 {param}={v} · TO-BE {hit[0]} 는 변수({(hit[1] or "")[:40]}) — 값 미확인'


def selftest():
    cases = [('같음', judge_literal('_mdmActive_Sw', '"Y"', ('mdmActiveSw', "'Y'"))[0], 'PASS'), ('다름', judge_literal('_mdmActive_Sw', '"Y"', ('mdmActiveSw', "'N'"))[0], 'FAIL'), ('미전달', judge_literal('_mdmActive_Sw', '"Y"', None)[0], 'ERROR'), ('변수 전달', judge_literal('_mdmActive_Sw', '"Y"', ('a', 'state.x'))[0], 'NA'), ('플래그 아님', judge_literal('sProgramID', '"DMF0003"', None)[0], 'NA'), ('빈 값', judge_literal('sw', '""', None)[0], 'NA')]
    bad = 0
    for nm, got, want in cases:
        k = got == want
        bad += 0 if k else 1
        print(f"{'OK ' if k else 'NG '} {nm} → {got}(기대 {want})")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def main():
    mid = sys.argv[1].upper()
    aid = sys.argv[sys.argv.index('--asis') + 1].upper() if '--asis' in sys.argv else next(
        (m['asis_id'].upper() for m in read_csv(P('tools', 'Harness', 'rules', 'map_screen.csv')) if (m.get('tobe_id') or '').upper() == mid), mid)
    pdir = page_dir(mid)
    out_p = P('Doc', 'verify', mid, 'popup_args.csv')
    os.makedirs(os.path.dirname(out_p), exist_ok=True)
    rows = []
    rel = lambda f: os.path.relpath(f, ROOT).replace('\\', '/')
    srcs = fe_sources(pdir) if pdir and os.path.isdir(pdir) else {}
    usages = tobe_usages(srcs, rel)
    fields = screen_fields(srcs)
    fcon = {}
    for fld, lab in fields.items():
        fcon.setdefault(concept(fld), (fld, lab))
    for lab_f in list(fields.items()):
        if lab_f[1]:
            fcon.setdefault(concept(lab_f[1]), lab_f)
    pops = asis_popups(aid)
    mapping_txt = ''
    for f in srcs:
        if f.endswith('__asis-mapping__.md'):
            mapping_txt = open(f, encoding='utf-8', errors='replace').read()
    if pdir:
        mp = os.path.join(pdir, '__asis-mapping__.md')
        if os.path.exists(mp):
            mapping_txt = open(mp, encoding='utf-8', errors='replace').read()

    def base(**kw):
        r = {k: '' for k in FIELDS}; r['menu_id'] = mid; r.update(kw); return r

    # AS-IS 호출 ↔ TO-BE 사용처 짝짓기: 개념 겹침 + 결과 반영 대상 + 대조표 동시 언급 + 이름 토큰
    def score(pc, u):
        tk = {concept(k) for k, _, _ in u['params']}
        sc_ = len({c for it in pc['items'] if it['kind'] in ('CONTROL', 'GRID', 'VAR', 'EXPR') for c in it['cands']} & tk) * 2
        sel = ' '.join(v for k, v in u['attrs'].items() if re.match(r'^(set[A-Z]|on[A-Z])', k))
        sc_ += 2 * len({concept(x) for x in re.findall(r'\b([A-Za-z_]\w*)\s*:', sel)} & pc['results'])
        sc_ += 3 if (pc['popup'] in mapping_txt and u['modal'] in mapping_txt and re.search(re.escape(pc['popup']) + r'[^\n]*' + re.escape(u['modal']) + '|' + re.escape(u['modal']) + r'[^\n]*' + re.escape(pc['popup']), mapping_txt)) else 0
        a_tok = set(re.findall(r'[A-Z][a-z]+', pc['popup'])) - {'Popup', 'Form'}
        b_tok = set(re.findall(r'[A-Z][a-z]+', u['modal'])) - {'Modal', 'Popup'}
        return sc_ + len(a_tok & b_tok)

    pair = {}
    used = set()
    for i, pc in enumerate(pops):
        cand = sorted(((score(pc, u), j) for j, u in enumerate(usages) if not u['error']), reverse=True)
        if cand and cand[0][0] > 0 and (len(cand) == 1 or cand[0][0] > cand[1][0]):
            pair[i] = cand[0][1]; used.add(cand[0][1])
    hosts = {j: host_label(srcs, u) for j, u in enumerate(usages)}

    for i, pc in enumerate(pops):
        aref = f"{pc['file']}:{pc['line']} {pc['cls']}.{pc['method']}"
        u = usages[pair[i]] if i in pair else None
        pid = f"P{i + 1}"
        if u is None:
            for it in pc['items']:
                if it['kind'] == 'LITERAL':
                    continue
                rows.append(base(side='ASIS', pair=pid, asis_ref=aref, asis_method=pc['method'], asis_popup=pc['popup'], asis_param=it['param'],
                                 asis_arg=it['arg'], asis_source=it['source'], concept=it['concept'], verdict='NA',
                                 note='TO-BE 대응 팝업 사용처를 기계로 확정하지 못함(후보 0 또는 동점) — 사람 확인(W7)'))
            continue
        tparams = {concept(k): (k, v) for k, v, _ in u['params']}
        for it in pc['items']:
            common = dict(side='ASIS', pair=pid, asis_ref=aref, asis_method=pc['method'], asis_popup=pc['popup'], asis_param=it['param'],
                          asis_arg=it['arg'], asis_source=it['source'], concept=it['concept'], tobe_ref=f"{u['rel']}:{u['line']}",
                          tobe_modal=u['modal'], host_label=hosts.get(pair[i], ''))
            if it['kind'] == 'LITERAL':
                lv_ = it['source'] or it['arg']; lh_ = next((tparams[c] for c in it.get('cands', [it['concept']]) if c in tparams), None); vd_, nt_ = judge_literal(it['param'], lv_, lh_)
                if lh_:
                    common.update(tobe_key=lh_[0], tobe_value=(lh_[1] or '')[:120])
                rows.append(base(**common, verdict=vd_, note=nt_))
                continue
            hit = next((tparams[c] for c in it['cands'] if c in tparams), None)
            if not hit:
                # 2026-11-20 T406(SSP0014 T-3a730d4a · 결정 D7): TO-BE 모달이 이 화면 폴더 밖 공용 모달이면 '모달이 받는 인자만 연동'은 확정 TO-BE 룰 CR-096
                #   (AS-IS SCM_SITE_ID 필터 등 그 밖 인자 미전달은 오류 아님 · 사용자 결정 2026-11-06). 화면 폴더 안 모달은 종전대로 사람 확인
                shared_ = not any(re.search(r'\b(?:function|const|class)\s+' + re.escape(u['modal']) + r'\b', s) for s in srcs.values())
                rows.append(base(**common, verdict='NA', note=(f"TO-BE 룰 CR-096 — AS-IS 는 {it['source'] or it['arg']} 를 팝업 인자 {it['param']} 로 전달 · TO-BE 공용 모달 {u['modal']}(화면 폴더 밖 정의)은 모달이 받는 인자만 연동 · 그 밖 AS-IS 인자 미전달은 오류 아님(사용자 결정 2026-11-06)" if shared_ else f"AS-IS 는 {it['source'] or it['arg']} 를 팝업 인자 {it['param']} 로 전달 · TO-BE {u['modal']} 사용처에 같은 개념 인자 미전달(팝업 교체·조건 축소 여부 사람 확인 W7)")))
                continue
            k, v = hit
            cls_, bound = classify(v)
            common.update(tobe_key=k, tobe_value=v[:120])
            if cls_ == 'BOUND':
                rows.append(base(**common, verdict='PASS', note=f"AS-IS {it['source'] or it['arg']} → TO-BE {k}={v[:60]} (값 연동)"))
            elif re.search(r'this\.Name(\.Substring\(\s*0\s*,\s*7\s*\))?', it['source'] or it['arg'] or '') and re.fullmatch(r"\s*(MENU_ID|menuId|'" + re.escape(mid) + r"'|\"" + re.escape(mid) + r"\")\s*", v or ''):
                # 2026-11-06 T79(SCP0037 V-01cdddea 허위 FAIL): AS-IS this.Name(.Substring(0,7)) = 폼 이름 앞 7자 = 화면 ID · TO-BE MENU_ID 상수(= 화면 ID)·'<ID>' 리터럴은 같은 값
                rows.append(base(**common, verdict='PASS', note=f"AS-IS {it['source'] or it['arg']}(= 화면 ID {mid}) → TO-BE {k}={v[:60]} (같은 값 — 화면 ID 상수)"))
            else:
                lab = fcon.get(it['concept'], ('', ''))[1] or it['concept']
                rows.append(base(**common, verdict='FAIL', screen_field=fcon.get(it['concept'], ('', ''))[0],
                                 note=f"연동 누락: {lab}({k}={v[:40] or chr(39) * 2}) — AS-IS 는 {it['source'] or it['arg']} 값을 팝업 인자 {it['param']} 로 전달하는데 TO-BE 는 고정값 전달"))

    for j, u in enumerate(usages):
        tref = f"{u['rel']}:{u['line']}"
        pid = next((f"P{i + 1}" for i, jj in pair.items() if jj == j), f"T{j + 1}")
        hl = hosts.get(j, '')
        if u['error']:
            rows.append(base(side='TOBE', pair=pid, tobe_ref=tref, tobe_modal=u['modal'], host_label=hl, verdict='ERROR',
                             note=f"검사기 한계 — 모달 속성 {u['error']}"))
            continue
        asis_fail = {r['tobe_key'] for r in rows if r['side'] == 'ASIS' and r['pair'] == pid and r['verdict'] == 'FAIL'}
        for k, v, prop in u['params']:
            if k == '(spread)':
                rows.append(base(side='TOBE', pair=pid, tobe_ref=tref, tobe_modal=u['modal'], tobe_key=k, tobe_value=v[:120], host_label=hl,
                                 verdict='NA', note='펼침 인자(...) — 기계 해석 불가, 사람 확인(W7)'))
                continue
            if k in asis_fail:
                continue  # ASIS 축 FAIL 과 같은 인자 — 1건으로
            cls_, bound = classify(v)
            cpt = concept(k)
            fh = fcon.get(cpt)
            common = dict(side='TOBE', pair=pid, tobe_ref=tref, tobe_modal=u['modal'], tobe_key=(f"{prop}.{k}" if prop else k), tobe_value=v[:120],
                          concept=cpt, host_label=hl, screen_field=fh[0] if fh else '')
            # 여는 위치: 조회조건(라벨 확인) · 그리드 행(속성에 행/그리드 값) · 미확정 — 조회조건 연동 축은 조회조건에서 여는 팝업에만(10-29 SCP0111 셀 팝업 허위 FAIL 방지)
            attr_txt = ' '.join(u['attrs'].values())
            cell = not hl and bool(re.search(r'\b(row|ROW|rows|GridUtils|gridRef|hitTest|rowIndex|\w*Row)\b', attr_txt))
            if cls_ in ('EMPTY', 'LITERAL') and fh and not hl:
                rows.append(base(**common, verdict='PASS' if cell else 'NA',
                                 note=(f"그리드 행(셀) 팝업 — 조회조건 {fh[1] or fh[0]} 연동 대상 아님 · 행 값 연동은 AS-IS 인자 축에서 판정" if cell else
                                       f"고정 조건 {k}={v[:40] or chr(39) * 2} · 같은 개념의 조회조건 {fh[1] or fh[0]} 있음 — 팝업을 여는 위치(조회조건/버튼)를 기계로 확정하지 못함, 사람 확인(W7)")))
                continue
            if cls_ in ('EMPTY', 'LITERAL'):
                if fh:
                    lab = fh[1] or fh[0]
                    rows.append(base(**common, verdict='FAIL',
                                     note=f"연동 누락: {lab}({k}={v[:40] or chr(39) * 2}) — 화면 조회조건 {lab}(searchCondition.{fh[0]}) 이 있는데 팝업 조건 {k} 에 고정값 전달 · 팝업이 조회조건과 연동되지 않음(CR-004)"))
                elif not fields:
                    rows.append(base(**common, verdict='ERROR', note='검사기 한계 — 화면 조회조건 상태(searchCondition) 추출 불가, 고정값 인자의 연동 필요 여부 미검증'))
                else:
                    rows.append(base(**common, verdict='PASS', note=f"고정 조건 {k}={v[:40] or chr(39) * 2} — 화면에 같은 개념의 조회조건 없음"))
            else:
                bc = concept(bound)
                if bc == cpt or (fh and bound == fh[0]) or (min(len(bc), len(cpt)) >= 4 and (bc.endswith(cpt) or cpt.endswith(bc))):
                    rows.append(base(**common, verdict='PASS', note=f"{k} ← {v[:60]} (값 연동)"))
                elif bound in fields:
                    rows.append(base(**common, verdict='PASS', note=f"{k} ← 화면 조회조건 {fields[bound] or bound}(searchCondition.{bound})"))
                else:
                    rows.append(base(**common, verdict='NA', note=f"{k} ← {v[:60]} — 인자 개념({cpt})과 값 출처({bc}) 이름이 달라 기계 대응 불가, 사람 확인(W7)"))

    with open(out_p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=FIELDS)
        w.writeheader()
        w.writerows(rows)
    print(f"{mid}: G5 팝업 인자 — AS-IS 호출 {len(pops)} · TO-BE 사용처 {len(usages)} · 짝 {len(pair)} · 조회조건 필드 {len(fields)} → "
          f"{dict(Counter(r['verdict'] for r in rows))} → {out_p}")
    for r in rows:
        if r['verdict'] in ('FAIL', 'ERROR'):
            print(f"  [{r['verdict']}] {r['tobe_ref'] or r['asis_ref']} {r['tobe_modal']} {r['tobe_key']}: {r['note'][:160]}")


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        sys.exit(selftest())
    main()
