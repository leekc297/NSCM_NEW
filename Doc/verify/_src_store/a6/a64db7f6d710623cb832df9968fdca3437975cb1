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
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))  # 2026-11-09 T174: python -I 실행 시에도 같은 폴더 asis_variant 를 찾도록(import 보다 먼저)
from asis_variant import is_main  # 2026-11-09 T172: variant 'only' 화면(SSP 등 180) = 현행 — 판정 단일 원천

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
SRC = os.path.join(ROOT, 'GSCM')
CLS = os.path.join(SRC, '01.Framework', 'GSCM.Windows.Forms', 'Class')
COLS = ['target_kind', 'target', 'label', 'method', 'var', 'filters', 'wrapper', 'sp', 'code', 'args', 'unresolved', 'ref', 'added_rows']
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

# SSP 조회조건 공통 원천 — DataService.GetSSPInnerTable(열, Filter)(DataService.cs:4176-5257 · 2026-11-11 원문에서 기계 추출):
#   FoxQuery SSP/Common/BigFilter.xml list_line_ssp 1회 실행(결과셋 27개 · 인자 @GROUP_ID·@USER_ID·@LANGUAGE_CODE)
#   열 이름 → (결과셋 번호, Filter 키, 중복 제거 열(빈 튜플 = Copy 그대로), 정렬 열). Filter 키 = 쉼표 목록 포함 여부(빈값·'ALL' = 전체)
#   실측 배경: 콤보 원천 미해석 108행 중 46행(7개 화면)이 이 함수 미등록 → 콤보 AS-IS 실행 대조가 전부 판정필요로 남았다.
def _ssp(idx, keys=(), dedupe=('CODE',), order='CODE'):
    return (idx, list(keys), tuple(dedupe), order)


SSP_INNER = {
    'MyDivision': _ssp(0), 'Div_Company': _ssp(1, dedupe=()), 'MyCompanyID': _ssp(2), 'CellTypeGr': _ssp(3), 'MyModelChk': _ssp(4),
    'SHIPMENT_PERIOD_DAY': _ssp(5, dedupe=()), 'PgmAuthId': _ssp(6, dedupe=()), 'MyDivisionOut40': _ssp(7), 'CHANGE_REASON_CODE_ALL': _ssp(8),
    'OWMS_STOCK_STATUS': _ssp(9), 'SSP_SHIPMENT_RESULT_TYPE': _ssp(10), 'CHANGE_REQ_DAY': _ssp(11),
    'Div_CompanyEE': _ssp(12, ['DIVISION_ID'], ('CODE', 'DIVISION_ID')), 'DomExpTypeCode': _ssp(13), 'ElectrodePackageType': _ssp(14),
    'BuildingForShipMasterElec': _ssp(15, ['DIVISION_ID', 'PLANT_ID'], ('CODE', 'SCM_SITE_ID')), 'SALES_TYPE_CODE': _ssp(16),
    'CompanyID': _ssp(17, dedupe=(), order='COMPANY_ID'), 'SHIPMENT_STATUS': _ssp(18), 'CHANGE_REQ_TYPE': _ssp(19), 'AllDivision': _ssp(20),
    'ESS_STOCK_STORAGE_ID': _ssp(21), 'Dept': _ssp(22), 'CHANGE_REQ_APP_DAY': _ssp(23), 'CHANGE_REQ_STATUS': _ssp(24), 'MyDivisionCMM': _ssp(25),
    'OPERATION_GROUP': _ssp(26),
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
    if call == 'DataService.GetSSPInnerTable':
        col = args[0].strip('"') if args else ''
        if col not in SSP_INNER:
            return call, 'SSP_BIGFILTER', col, [], f'GetSSPInnerTable 열 {col} 미등록(DataService.cs 원문 확인 후 SSP_INNER 등록)'
        idx, keys, _, _ = SSP_INNER[col]
        return call, 'SSP_BIGFILTER', col, [('@GROUP_ID', 'UserInfoContext.Current["NowGroupID"]'), ('@USER_ID', 'UserInfoContext.Current.UserId')] \
            + [(f'Filter.{k}', f'Filter["{k}"]') for k in keys], ''
    if call.startswith('sem:'):   # 2026-11-25 의미 분석: 호출 대상 메서드 안 SP(args = [('SP', 키), ('@파라미터', 식)…])
        sp_ = next((e for n_, e in args if n_ == 'SP'), '')
        ps_ = [(n_, e) for n_, e in args if n_ != 'SP']
        code_ = next((e.strip('"') for _n, e in ps_ if re.fullmatch(r'"[^"]*"', e)), '')
        return call[4:], sp_, code_, ps_, '' if sp_ and '{' not in sp_ else f'{call[4:]} 안 SP 미결정(의미 분석)'
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


# 2026-11-25 T607(SCP0005 FACT-708ae4ce cboValidYN): clsCtrl.setListBox(dtValidYN, cboValidYN, true, "CODE", "NAME")(SCP0005_DistributionRoute.cs:204) 는
#   CControl.setListBox(DataTable, ComboBox, bool blnAllFlag, string, string)(CControl.cs:344~) 오버로드로, blnAllFlag=true 면 원천 사본 0번에
#   모든 칸 = CConstVariable.FlagAll("ALL" · CConstVariable.cs:42) 행을 넣는다(Decimal 칸은 0). 종전엔 바인딩 인자만 읽어 Y/N 만 기대 후보로 남았다.
#   오버로드는 원문에서 고른다: 인자 수 · 컨트롤 형(Designer new 문장 → 프레임워크 클래스 상속 사슬, 가장 가까운 형) · 4번째 인자 리터럴 형(bool/int/string).
#   본문이 if (플래그) 안에서 NewRow + CConstVariable.X 대입 + Rows.InsertAt(행, 0) 이면 그 행을 added_rows(pos 0)로, 다른 setListBox 로 넘기면 그 오버로드를 따라간다.
#   한계(미반영): Items.Add(CAppSetting.StringALL) 형 오버로드(CheckedListBox·ComboBox 3인자)와 플래그가 변수인 호출 · 수신 객체가 CControl 로 확인되지 않는 호출
_LBX = {}


def _const_of(cls, name):
    """프레임워크 Class/<cls>.cs 의 static/const 문자열 상수 값 → (값, 'cls.cs:줄') · 못 찾으면 None"""
    key = ('C', cls, name)
    if key not in _LBX:
        t = read_text(os.path.join(CLS, f'{cls}.cs'))
        m = re.search(r'\b(?:static|const)\s+(?:readonly\s+)?string\s+' + re.escape(name) + r'\s*=\s*"((?:[^"\\]|\\.)*)"\s*;', t)
        _LBX[key] = (m.group(1), f'{cls}.cs:{t.count(chr(10), 0, m.start()) + 1}') if m else None
    return _LBX[key]


def _listbox_overloads():
    """CControl.cs setListBox 오버로드 → [{'params': [(형, 이름)], 'body', 'lines'}]"""
    if 'O' not in _LBX:
        t = strip_comments(read_text(os.path.join(CLS, 'CControl.cs')))
        out = []
        for m in re.finditer(r'\bpublic\s+void\s+setListBox\s*\(([^)]*)\)\s*\{', t):
            dep, i = 1, m.end()
            while i < len(t) and dep:
                dep += {'{': 1, '}': -1}.get(t[i], 0); i += 1
            ps = [tuple(p.split()[-2:]) for p in m.group(1).split(',') if len(p.split()) >= 2]
            out.append({'params': ps, 'body': t[m.end():i - 1], 'lines': f"CControl.cs:{t.count(chr(10), 0, m.start()) + 1}-{t.count(chr(10), 0, i) + 1}"})
        _LBX['O'] = out
    return _LBX['O']


def _fw_bases():
    """GSCM.Windows.Forms 클래스 → 기반 클래스(마지막 이름) — class X : Base"""
    if 'B' not in _LBX:
        b = {}
        for dp, _dn, fns in os.walk(os.path.dirname(CLS)):
            for fn in fns:
                if fn.endswith('.cs') and not fn.endswith('.Designer.cs'):
                    for m in re.finditer(r'\bclass\s+(\w+)\s*:\s*([\w.]+)', read_text(os.path.join(dp, fn))):
                        b.setdefault(m.group(1), m.group(2).split('.')[-1])
        _LBX['B'] = b
    return _LBX['B']


def _arg_kind(a):
    a = a.strip()
    return 'bool' if a in ('true', 'false') else 'int' if re.fullmatch(r'-?\d+', a) else 'string' if a.startswith('"') else ''


def _pick_overload(ctype, args):
    """C# 오버로드 해석(이 화면 호출에 필요한 범위): 인자 수 · 컨트롤 형 상속 사슬에서 가장 가까운 형 · 4번째 인자 리터럴 형. 하나로 정해지지 않으면 None"""
    chain, bs, c = [], _fw_bases(), ctype
    while c and c not in chain and len(chain) < 8:
        chain.append(c); c = bs.get(c)
    cand = [o for o in _listbox_overloads() if len(o['params']) == len(args) and len(o['params']) >= 3]
    for ct in chain:
        hit = [o for o in cand if o['params'][1][0].split('.')[-1] == ct]
        if len(hit) > 1 and len(args) >= 4:
            k = _arg_kind(args[3])
            hit = [o for o in hit if k and o['params'][3][0] == k]
        if hit:
            return hit[0] if len(hit) == 1 else None
    return None


def listbox_all_row(ctype, args, depth=0):
    """setListBox(dt, ctrl, true, …) 가 원천 사본에 넣는 '전체' 행 → {'CODE','NAME','pos','ref'} · 넣지 않거나 확인 못 하면 None(T607)"""
    o = _pick_overload(ctype, args) if depth < 3 else None
    if not o or args[2].strip() != 'true':
        return None
    flag = o['params'][2][1]
    m = re.search(r'\bif\s*\(\s*' + re.escape(flag) + r'\s*\)\s*\{', o['body'])
    if m:
        dep, i = 1, m.end()
        while i < len(o['body']) and dep:
            dep += {'{': 1, '}': -1}.get(o['body'][i], 0); i += 1
        blk = o['body'][m.end():i]
        rv = re.search(r'\b(\w+)\s*=\s*\w+\.NewRow\s*\(\s*\)', blk)
        cv = re.search(r'=\s*CConstVariable\.(\w+)\s*;', blk)
        if rv and cv and re.search(r'\.Rows\.InsertAt\s*\(\s*' + re.escape(rv.group(1)) + r'\s*,\s*0\s*\)', blk):
            val = _const_of('CConstVariable', cv.group(1))
            if val is None:
                return None
            return {'CODE': val[0], 'NAME': val[0], 'pos': 0, 'ref': f"{o['lines']} blnAllFlag=true → 0번 행 모든 칸 CConstVariable.{cv.group(1)}=\"{val[0]}\"({val[1]} · Decimal 칸은 0)"}
    d = re.search(r'\bsetListBox\s*\(\s*(\w+)\s*,\s*(\w+)\s*,\s*' + re.escape(flag) + r'\s*,([^;]*)\)\s*;', o['body'])
    if d:   # 다른 오버로드로 넘김(예 int·string 기본값 오버로드 → 5인자) — 넘기는 인자의 형은 원문 상수 이름으로 판단(CDefineColumn.* = string)
        rest = [('"x"' if re.fullmatch(r'[A-Z]\w*\.\w+', x.strip()) else x) for x in d.group(3).split(',')]
        return listbox_all_row(ctype, [args[0], args[1], 'true'] + rest, depth + 1)
    return None


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


_SITES = None


def sem_target_source(t, rhs):
    """호출 대상 메서드(t) 안의 SP 호출 지점 → [('SP', 키), ('@요청파라미터', 식)…]. 매개변수 자리표시자 {p:이름} 은 호출 인자 식으로 바꾼다"""
    global _SITES
    if _SITES is None:
        _SITES = {}
        for r in read_csv(os.path.join(ROOT, 'Doc', 'asisfacts', 'sites.csv')):
            if r.get('active') == '1' and r.get('commented') != '1' and r.get('site_kind') in ('ctor', 'invoke', 'prop'):
                _SITES.setdefault((r['file'], r['member_line']), []).append(r)
    rows = _SITES.get((t['file'], str(t['line'])), [])
    if not rows:
        return None
    m = re.match(r'[\w.]+\s*\((.*)\)\s*$', rhs.strip(), re.S)
    args, _ = split_args(m.group(1) + ')') if m else ([], '')
    pmap = {p: (args[i] if i < len(args) else '') for i, p in enumerate(t['params'])}
    r = rows[0]
    sp = r['values'].split(' || ')[0]
    out = [('SP', sp)]
    for kv in (r.get('req_params') or '').split('; '):
        if '=' in kv:
            k, v = kv.split('=', 1)
            pm = re.fullmatch(r'\{p:(\w+)\}', v.strip())
            out.append((f'@{k}', pmap.get(pm.group(1), v) if pm else v))
    return out


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    sid = sys.argv[1].upper()
    sdir = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid)
    files = [r['file'] for r in read_csv(os.path.join(sdir, 'files.csv')) if is_main(r, sdir)]
    if not files:
        print(f'[FAIL] {sid}: files.csv current 변형 없음 — AsisFacts 먼저 실행')
        return 1
    global CAT
    CAT = cat = build_catalog()
    src_of, filt_of, binds, labels = {}, {}, [], {}
    texts = []
    alltxt = []  # 2026-11-20 T438: 메서드 참조 세기용(Designer.cs 이벤트 연결 포함)
    for rel in files:
        raw = read_text(os.path.join(SRC, rel))
        alltxt.append(strip_comments(raw))
        if rel.endswith('.Designer.cs'):
            labels.update(designer_labels(raw))
            continue
        t = strip_comments(raw)
        scan_locals(t)
        texts.append((rel, t))
    inline = {}  # 바인딩 인자에 원천 호출을 바로 넣은 경우(SetCellTypeCombo(…, Data.Common(…))) → 가상 변수
    bind_add = {}  # T607 바인딩(대상, 위치) → setListBox 가 넣는 '전체' 행
    _all = '\n'.join(alltxt)
    _dead = {}

    def dead_private(name):
        """T438: private 로만 선언되고 선언 밖 참조(호출·이벤트 연결 += 이름)가 0 인 메서드면 True. override·public·internal·protected 는 밖에서 부를 수 있어 False"""
        if not name or name.startswith('<'):
            return False
        if name not in _dead:
            decl = re.findall(r'\b(private|public|protected|internal)\b[^;{()=]*?\b' + re.escape(name) + r'\s*\(', _all)
            refs = len(re.findall(r'\b' + re.escape(name) + r'\b', _all))
            _dead[name] = bool(decl) and all(d == 'private' for d in decl) and refs - len(decl) <= 0
        return _dead[name]

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
                if dead_private(method_at(m.start())):
                    continue  # T438: 어디서도 부르지 않는 private 메서드 안 바인딩(예 SCP0028 ClearUsrCheckedList cs:149~156) = 화면 동작 아님
                binds.append(('SEARCH', args[1].replace('this.', ''), '', as_var(args[0], f'{base}:{line(m.start())}'), f'{base}:{line(m.start())}', method_at(m.start())))
                # T607: blnAllFlag=true 로 '전체' 행을 넣는 오버로드면 그 행을 이 바인딩의 added_rows 로(수신 객체가 CControl 이고 컨트롤 형이 원문에서 확인될 때만)
                recv = re.search(r'(\w+)\s*$', t[:m.start()])
                ctl = args[1].replace('this.', '').strip()
                ctm = re.search(r'\b' + re.escape(ctl) + r'\s*=\s*new\s+([\w.]+)\s*\(', _all) or re.search(r'\b([\w.]+)\s+' + re.escape(ctl) + r'\s*[;=]', _all)
                if len(args) >= 3 and recv and ctm and re.search(r'\bCControl\s+' + re.escape(recv.group(1)) + r'\b|\b' + re.escape(recv.group(1)) + r'\s*=\s*new\s+CControl\s*\(', _all):
                    ar = listbox_all_row(ctm.group(1).split('.')[-1], args)
                    if ar:
                        bind_add.setdefault((args[1].replace('this.', ''), f'{base}:{line(m.start())}'), []).append({**ar, 'ref': f'{base}:{line(m.start())} setListBox(…, true, …) → ' + ar['ref']})
        # 2026-11-20 T438(SCP0028 FACT-78289eda): 컨트롤.DataBind(Data.Type.X, isALL[, p1…]) = Data.Common(X, isALL, p1…) 바인딩(UsrComboBox.cs:34~44).
        #   종전엔 setListBox 만 읽어 cboValid.DataBind(Data.Type.YesOrNo, true)(SCP0028 cs:135) 같은 조회조건 콤보 원천이 빠졌다(GSCM 전체 약 80건)
        for m in re.finditer(r'\b(\w+)\.DataBind\s*\(', t):
            args, _ = split_args(t[m.end():])
            if not args or not re.fullmatch(r'Data\.Type\.\w+', args[0].strip()) or dead_private(method_at(m.start())):
                continue
            key = f'<bind {m.group(1)} {args[0].strip()}>'
            inline[key] = [('Data.Common', [a.strip() for a in args], f'{base}:{line(m.start())}')]
            binds.append(('SEARCH', m.group(1).replace('this.', ''), '', key, f'{base}:{line(m.start())}', method_at(m.start())))
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

    # 2026-11-20 T391(SSP0014 FACT-b00010d1 · B4 '?Warranty'): 원천 DataTable 에 화면이 직접 넣은 행 — `r = dtX.NewRow(); r["CODE"] = "W"; r["NAME"] = "…"; dtX.Rows.Add(r)`
    #   (InsertAt(r, n) 은 n 번째) 를 콤보 기대 후보에 합친다(SSP0014_ShipmentModelPIC.cs:183~187). 종전엔 원천 SP 결과만 기대 후보로 써 화면 하드코딩 항목이 빠졌다
    added_of = {}
    for rel, t in texts:
        base = os.path.basename(rel)
        for mn in re.finditer(r'(\w+)\s*=\s*(\w+)\.NewRow\s*\(\s*\)\s*;', t):
            rv, dv = mn.group(1), mn.group(2)
            nxt = re.search(r'\b' + re.escape(rv) + r'\s*=\s*\w+\.NewRow\s*\(', t[mn.end():])
            seg = t[mn.end(): mn.end() + nxt.start()] if nxt else t[mn.end():]
            ma = re.search(r'\b' + re.escape(dv) + r'\.Rows\.(Add|InsertAt)\s*\(\s*' + re.escape(rv) + r'\s*(?:,\s*(\d+)\s*)?\)', seg)
            if not ma:
                continue
            vals = {k.upper(): v for k, v in re.findall(r'\b' + re.escape(rv) + r'\s*\[\s*"(\w+)"\s*\]\s*=\s*"((?:[^"\\]|\\.)*)"\s*;', seg[:ma.start()])}
            if 'CODE' not in vals:
                continue
            added_of.setdefault(dv, []).append({'CODE': vals['CODE'], 'NAME': vals.get('NAME', vals['CODE']),
                                                'pos': int(ma.group(2)) if ma.group(1) == 'InsertAt' and ma.group(2) else -1,
                                                'ref': f'{base}:{t.count(chr(10), 0, mn.start()) + 1}'})
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
    # T567(2026-11-25 SCP0005 B4 V-82d97d20·V-5bcb735c): 화면이 SetSheetHeaderColumn*(siObj, n …) 로 시트를 만들면 프레임워크가 SHEET_COLUMNS ATTRIBUTE1~5 를
    #   Data.Common(eDataType, false, sParam1…sParam5) 인자로 넘긴다(SpreadInfo.cs:1975~1981 · 2312 · 2660 · 3020 · 14575 같은 문장). CreateSheetHeaderColumn 경로(SpreadInfo.cs:1478)만 인자 없음.
    #   종전엔 인자 없이 Data.Common(Type) 한 변수로 합쳐 LT_TYPE·TRANSPORT_MODE 가 빈 인자 LookupCommon(AS-IS 0건)이 됐다. 인자 있는 컬럼은 인자별 가상 변수로 나눈다.
    #   한계: Measure·MeasureGroup(COLUMN_NAME MEASURE·MEASURE_GROUP) 분기는 종전대로(인자 PROGRAM_ID·SHEET_NAME 미반영)
    hdr_attr = any(re.search(r'\.SetSheetHeaderColumn\w*\s*\(', t_) for _r, t_ in texts)
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
            attrs = [(r.get(f'ATTRIBUTE{i}') or '') for i in range(1, 6)]
            if hdr_attr and any(a.strip() for a in attrs) and not (ct.upper() in ('MEASURE', 'MEASUREGROUP') and col.upper() in ('MEASURE', 'MEASURE_GROUP')):
                key = f"<meta Data.Type.{dtypes[ct.upper()]} {'|'.join(attrs).rstrip('|')}>"
                inline[key] = [('Data.Common', [f'Data.Type.{dtypes[ct.upper()]}', 'false'] + [json.dumps(a, ensure_ascii=False) for a in attrs], ref + ' ATTRIBUTE1~5 · SpreadInfo.cs:1975-1981')]
                binds.append(('GRID', col, r.get('COLUMN_LABEL_NAME') or '', key, ref, 'SheetMeta'))
                continue
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

    # 2026-11-25 사용자 지시 'VM 의 AS-IS 파서에도 의미 분석 추가': 정규식으로 원천 대입을 못 찾은 변수는 Roslyn 의미 모델(asis_sem.defs)로
    #   값을 넣는 문장을 찾는다(다른 메서드·partial 파일의 필드 대입, 생성자·매개변수로 들어온 값 포함). 찾은 오른쪽 식은 종전 원천 해석(as_var → resolve_source)에 그대로 넣는다.
    #   도구 실패면 종전 결과 그대로(미해결 사유 유지)
    sem_note = {}
    rel_of = {os.path.basename(r): r for r in files}
    need = []
    for kind, target, label, var, ref, meth in binds:
        v0 = var.replace('this.', '').strip()
        mref = re.fullmatch(r'(.+\.cs):(\d+)', ref or '')
        if chain(var) or not mref or v0.startswith('<') or not re.fullmatch(r'\w+', v0) or mref.group(1) not in rel_of:
            continue
        need.append((var, (rel_of[mref.group(1)], int(mref.group(2)), v0)))
    if need:
        try:
            import asis_sem
            got = asis_sem.defs([q for _v, q in need])
            follow = []; tgt_q = []
            for var, q in need:
                for d in got.get(q) or []:
                    rref = f"{os.path.basename(d['file'])}:{d['line']} (의미 분석 {d['how']})"
                    rhs = d['rhs'].strip()
                    if re.fullmatch(r'(this\.)?\w+', rhs):
                        filt_of.setdefault(var, []).append((rhs.replace('this.', ''), '대입(의미 분석)', rref))
                        follow.append((rhs.replace('this.', ''), (d['file'], d['line'], rhs)))
                        continue
                    k = as_var(rhs, rref)
                    if k in inline and inline[k] and not resolve_source(inline[k][0][0], inline[k][0][1], cat)[4].startswith('원천 함수'):   # 종전 해석이 아는 원천
                        inline.setdefault(var, []).extend(inline[k])
                    else:
                        tgt_q.append((var, rref, rhs, (d['file'], d['line'], rhs)))
            # 원천 래퍼가 등록되지 않은 호출(ScpUtils.GetLookupValues 등): 의미 분석으로 호출 대상 메서드를 특정하고,
            #   그 메서드 안의 SP 호출 지점(AsisFacts sites.csv · 의미 분석 반영본)의 SP 와 요청 파라미터를 원천으로 쓴다. 매개변수 값은 호출 인자로 바꾼다
            if tgt_q:
                tg = asis_sem.target([q for *_x, q in tgt_q])
                for var, rref, rhs, q in tgt_q:
                    t_ = tg.get(q)
                    src_ = sem_target_source(t_, rhs) if t_ else None
                    if src_:
                        inline.setdefault(var, []).append((f"sem:{t_['sig']}", src_, rref))
                    else:
                        sem_note.setdefault(var, []).append(f'{rref}: {rhs[:80]}')
            # 한 단계 더: 대입 오른쪽이 다른 변수면 그 변수의 정의
            if follow:
                got2 = asis_sem.defs([q for _v, q in follow if not chain(_v)])
                for v2, q in follow:
                    for d in got2.get(q) or []:
                        rref = f"{os.path.basename(d['file'])}:{d['line']} (의미 분석 {d['how']})"
                        k = as_var(d['rhs'].strip(), rref)
                        if k in inline:
                            inline.setdefault(v2, []).extend(inline[k])
            print(f"{sid}: 의미 분석 정의 조회 {asis_sem.LAST['requested']}건(캐시 {asis_sem.LAST['cached']}) · 원천 찾음 {sum(1 for v, _q in need if chain(v))}/{len(need)}"
                  + (f" · 오류 {asis_sem.LAST['error'][:120]}" if asis_sem.LAST['error'] else ''))
        except Exception as e:  # 도구 실패 = 종전 정규식 결과
            print(f'[WARN] {sid}: 의미 분석 정의 조회 실패({type(e).__name__}: {str(e)[:120]}) — 종전 결과 유지')

    rows = []
    for kind, target, label, var, ref, meth in binds:
        srcs = chain(var)
        if not srcs:
            rows.append({'target_kind': kind, 'target': target, 'label': label or labels.get(target, ''), 'method': meth, 'var': var, 'filters': '',
                         'wrapper': '', 'sp': '', 'code': '', 'args': '[]',
                         'unresolved': f'{var} 원천 대입 미발견(필드 초기화·외부 주입 확인)' + (f" · 의미 분석 대입 {len(sem_note[var])}건(원천 호출 아님): " + ' | '.join(sem_note[var][:3]) if sem_note.get(var) else ''), 'ref': ref})
            continue
        for call, args, sref, fl in srcs:
            w, sp, code, ps, un = resolve_source(call, args, cat)
            if call in HELPERS and HELPERS[call]['filter']:
                fl = [f"{HELPERS[call]['filter']} @{HELPERS[call]['ref']}"] + fl
            rows.append({'target_kind': kind, 'target': target, 'label': label or labels.get(target, ''), 'method': meth, 'var': var,
                         'filters': ' ▸ '.join(fl), 'wrapper': w, 'sp': sp, 'code': code,
                         'args': json.dumps([{'n': n, 'expr': e} for n, e in ps], ensure_ascii=False), 'unresolved': un, 'ref': f'{ref} ← {sref}',
                         'added_rows': json.dumps(_add, ensure_ascii=False) if (_add := (added_of[var] if added_of.get(var) and sp != 'STATIC' else []) + bind_add.get((target, ref), [])) else ''})  # T607: 바인딩이 넣는 '전체' 행은 원천 종류(STATIC 포함)와 무관하게 뒤에(0번 삽입)
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
