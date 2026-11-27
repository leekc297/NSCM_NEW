"""AS-IS 그리드 잠금 규칙 전개 + 컬럼별 편집 기대표 (v2 — 2026-10-30 SCP0111 D1 전면 UNKNOWN 계기 · 검사기 결함 T11)

  python tools/Harness/verify/facts_lockrules.py <AS-IS ID> [--class <메인 클래스명>]

산출 (Doc/asisfacts/screens/<ID>/):
  lock_rules.csv   AS-IS GRID_LOCK 액션 1건 = 1행 — 범위를 AS-IS 컬럼 순서로 전개 · 가드를 정규형 조건(cond)으로 · 잠금 인자가 변수면 lock_expr
  edit_expect.csv  컬럼별 기대 — 신규행 / 기존행(편집모드) 각각 Y(편집 가능) · N(잠금) · COND(조건부 — *_rules 에 순서 있는 규칙 JSON) · UNKNOWN(해석 실패 사유)

AS-IS 동작 근거(프레임워크):
  · 조회 직후 LockColumn(0, Max, true) = 전체 잠금(조회 모드) — TO-BE 는 편집 모드가 없어(사용자 결정 2026-10-30) **편집 모드 ON** 상태를 기대로 삼는다
  · EditButton 경로: SwitchLock() 로 전체 해제 후 LockColumn/LockRange 를 **원문 순서대로** 적용 → 기존행 기대 = 규칙 목록을 순서대로 평가한 마지막 상태(기본 편집 가능)
  · InsertButton 경로(InsertRow 등 CALL_LOCAL 피호출 포함): siMain.Insert() 가 신규행 전체 해제 → 그 뒤 LockRange(insCell, …) 만 잠금 → 신규행 기대
v2 해석(화면 독립 — 화면 리터럴 없음):
  · 컬럼 상수 접두 = 화면 코드의 Def* 클래스 전부(DefColumns·DefMain·…) — 종전 DefColumns 고정이 SCP0111(DefMain) 전 잠금을 UNRESOLVED 로 만들었다
  · GetColumnIndex(변수): 같은 메서드의 변수 정의를 따라간다 — dtX.Rows[..][Def*.YYYYMM] 이고 dtX = Data.Common(Data.Type.CalendarMonth…) 이면 런타임 컬럼 패밀리 '<DYNAMIC:CalendarMonth>'(facts_dyncols 와 같은 키)
  · 가드 정규형: GROUP==\"ADMIN\"(NowGroupID 변수) · DIV!=\"82\"(Division 콤보 변수) · COL(SEQ_FLAG)[1:2]==\"6\"(GetValue(iRow, …Def*.COL)… + Substring) · COL(SELF)==\"\"(잠그는 바로 그 셀 값) ·
    TRUE 로 접는 것 = null 검사 · IsEditMode(편집 모드 ON 가정) · IsLock==false · 행/달력 for 루프 · 'else of (X)' = !(X) · 그 밖 = RAW(원문) — 평가 불가 표식(판정은 ERROR, FAIL 아님)
  · 잠금 인자가 변수(!isEdit)면 그 변수의 대입(값 true 인 가드)을 따라 조건으로 전개한다
"""
import argparse
import csv
import json
import os
import re
import sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); from asis_live import dead_methods, _src_path  # noqa: E402
from facts_combosrc import strip_comments  # noqa: E402
from asis_variant import is_main, is_cur  # 2026-11-09 T172: variant 'only' 화면(SSP 등 180) = 현행 — 판정 단일 원천

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
RX_DEFCOL = re.compile(r'\bDef\w+\.([A-Za-z_][A-Za-z0-9_]*)')  # 2026-11-12 T265: 이름 전체(종전 [A-Z0-9_]+ 는 EditFlag 를 E 로 잘랐다) — 값은 Resolver.defcol() 로
RX_TABLE_FAMILY = re.compile(r'Data\.Common\(\s*Data\.Type\.(\w+)')
RX_GROUP_SRC = re.compile(r'NowGroupID|GroupID"\]|UserGroup', re.I)
RX_DIV_SRC = re.compile(r'Division|DIVISION', re.I)
_FW_CONST = None


def fw_consts():
    """T542(2026-11-25 SCP0005 FACT-c0e149fc): 프레임워크 CAppSetting 의 `public const string X = "v";` 상수(CAppSetting.cs:149~151 FlagM·FlagI·FlagD) → {'CAppSetting.X': '"v"'}
    종전엔 StringY·StringN 두 개만 코드에 적어 'action != CAppSetting.FlagI' 가 RAW 였다. 원문을 읽는다(하드코딩 없음 · 파일 없으면 빈 표)"""
    global _FW_CONST
    if _FW_CONST is None:
        _FW_CONST = {}
        fp = os.path.join(ROOT, 'GSCM', '01.Framework', 'GSCM.Windows.Forms', 'Utility', 'CAppSetting.cs')
        try:
            txt = open(fp, encoding='utf-8-sig', errors='replace').read()
        except OSError:
            txt = ''
        for k, v in re.findall(r'\bpublic\s+const\s+string\s+(\w+)\s*=\s*"([^"]*)"\s*;', txt):
            _FW_CONST.setdefault(f'CAppSetting.{k}', f'"{v}"')
        # 2026-11-26 T674(DMF0003 EditButton:1248 등 27원자 'GetText(iRow, …StringAction) == CAppSetting.StringI'): 'public static string StringI { get { return m_sI; } }'
        #   + 'private readonly static string m_sI = "I";' 형태 속성도 필드 값으로 푼다(CAppSetting.cs:105~113 · 618~640)
        fld = dict(re.findall(r'\b(?:private|internal|public)\s+(?:readonly\s+)?static\s+(?:readonly\s+)?string\s+(\w+)\s*=\s*"([^"]*)"\s*;', txt))
        for k, f_ in re.findall(r'\bpublic\s+static\s+string\s+(\w+)\s*\{\s*get\s*\{\s*return\s+(\w+)\s*;\s*\}\s*\}', txt):
            if f_ in fld:
                _FW_CONST.setdefault(f'CAppSetting.{k}', f'"{fld[f_]}"')
    return _FW_CONST
LOCK_COLS = ['method', 'line', 'api', 'scope', 'locked', 'lock_expr', 'columns', 'expand', 'cond', 'guard', 'control', 'raw']


def lock_sig(api, argc):
    """프레임워크 잠금 함수 오버로드(GSCM.Windows.Forms/Class/SpreadInfo.cs:6910-7154 · 2026-11-11 원문 확인) → (컬럼 인자 위치들, 잠금 여부 인자 위치) 또는 None
      LockColumn·LockColumn2 : (c1, pLock) · (c1, c2, pLock) · (c1, c2, pLock, isAlternatingRow)
      LockRange·2·3          : (cell, c1, c2, pLock) · (r1, c1, r2, c2, pLock) · (…, pLock, bChangeBackColor) · (…, pLock, ForeColor, BackColor)"""
    a = re.sub(r'\d+$', '', api or '')
    if a == 'LockColumn':
        return {2: ([0], 1), 3: ([0, 1], 2), 4: ([0, 1], 2)}.get(argc)
    if a == 'LockRange':
        return {4: ([1, 2], 3), 5: ([1, 3], 4), 6: ([1, 3], 4), 7: ([1, 3], 4)}.get(argc)
    return None


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


class Resolver:
    """메인 클래스 원문의 메서드별 변수 정의 → 가드·인자의 정규형 조건 해석"""

    def __init__(self, src_lines, spans, acts):
        self.lines = src_lines  # 1-based 접근은 lines[i-1]
        self.spans = spans      # (cls, meth) → (lo, hi)
        self.guard_of_line = {(a['class'], a['method'], int(a['line'] or 0)): a.get('guard', '') for a in acts if a.get('line')}
        self.unresolved = []
        self.control = ''  # 지금 해석 중인 잠금의 스프레드 컨트롤(siMain·siExcept) — 시트/컨트롤 상태 가드를 접는 기준
        self.line = 0      # 지금 해석 중인 문장 줄(불리언 플래그 변수는 그 앞의 대입만)
        # T542(2026-11-25 SCP0005 FACT-c0e149fc): `string action = siMain.GetText(i, 0);`(cs:1285) 의 0번 칸 = 행 상태 칸(CRUD_TYPE).
        #   근거 = 시트 머리를 메타로 만드는 SetSheetHeaderColumn(si, n)·CreateSheetHeaderColumn 이 InitSheet(ColumnCount=0) 바로 뒤 AddActionTextBox 로
        #   StringAction 칸을 첫 칸으로 넣는다(SpreadInfo.cs:1350~1351 · 1852~1855 · 3765). 이 호출이 없는 화면은 0번 칸을 풀지 않는다
        # T680: SetSheetHeaderColumnSCP(si, n, …) 도 InitSheet 뒤 AddActionTextBox(SpreadInfo.cs:2878 · 2892) — SCP0104 :2163
        self.action_col0 = any(re.search(r'\.(?:SetSheetHeaderColumn\(\s*\w+\s*,\s*\d+\s*\)|SetSheetHeaderColumnSCP\(\s*\w+\s*,\s*\d+\s*,|CreateSheetHeaderColumn\()', l_) for l_ in src_lines)

    def member_returns(self, name):
        """2026-11-26 T680(SCP0104 _fixed_column_idx · _fixed_column_name · GetCurrEditType): 같은 파일의 속성 getter·메서드가 돌려주는 식 [(줄, 식, 가드)].
        'return 지역변수;' 면 그 변수의 대입식(초기값 ""·-1·0·null·string.Empty 제외)을 모은다. 가드 = 원문에서 감싼 블록 조건(source_guard). 못 찾으면 []"""
        rx_decl = re.compile(r'^\s*(?:(?:private|public|protected|internal|static|override|virtual|async)\s+)+[\w<>\[\],.]+\s+' + re.escape(name) + r'\s*(?:\([^;]*\))?\s*\{?\s*$')
        for i, ln in enumerate(self.lines, 1):
            if not rx_decl.match(ln):
                continue
            body, d, started = [], 0, False
            for j in range(i, min(i + 120, len(self.lines) + 1)):
                l_ = self.lines[j - 1]
                d += l_.count('{') - l_.count('}')
                started = started or '{' in l_
                body.append((j, l_))
                if started and d <= 0:
                    break
            rets = [(j, m_.group(1).strip()) for j, l_ in body for m_ in [re.search(r'\breturn\s+([^;]+);', l_)] if m_]
            out = []
            for j, ex in rets:
                if re.fullmatch(r'[A-Za-z_]\w*', ex) and ex not in ('true', 'false', 'null'):
                    for k, l_ in body:
                        m_ = re.search(r'(?:^|[;{\s])' + re.escape(ex) + r'\s*=(?!=)\s*([^;]+);', l_)
                        if m_ and m_.group(1).strip() not in ('""', '-1', '0', 'null', 'string.Empty', 'String.Empty'):
                            out.append((k, m_.group(1).strip(), self.source_guard((None, None), k).split('▸')[-1].strip()))
                else:
                    out.append((j, ex, self.source_guard((None, None), j).split('▸')[-1].strip()))
            return out
        return []

    def method_of_line(self, line):
        """줄을 감싼 메서드 이름(선언 줄을 거슬러 찾음, 400줄)"""
        for i in range(line, max(0, line - 400), -1):
            m_ = re.match(r'^\s*(?:(?:private|public|protected|internal|static|override|virtual|async)\s+)+[\w<>\[\],.]+\s+(\w+)\s*\([^;]*\)\s*$', self.lines[i - 1])
            if m_:
                return m_.group(1)
        return ''

    def ctx_bool(self, meth, prop, depth=3, seen=None):
        """T680: 메서드 meth 가 불릴 때 불리언 속성 prop 의 값 — 호출 줄을 감싼 가드에 'if (prop)' 이면 True · 'else of (prop)' 이면 False.
        가드에 없으면 호출한 메서드로 거슬러 올라감(depth). 호출 경로마다 값이 다르거나 못 정하면 None"""
        seen = seen or set()
        if depth < 0 or not meth or meth in seen:
            return None
        seen = seen | {meth}
        vals = set()
        rxp = r'(?:this\.)?' + re.escape(prop)
        for i, ln in enumerate(self.lines, 1):
            if not re.search(r'(?<![\w.])' + re.escape(meth) + r'\s*\(', ln) or re.match(r'^\s*(?:(?:private|public|protected|internal|static|override|virtual|async)\s+)+', ln):
                continue
            segs = [s_.strip() for s_ in self.source_guard((None, None), i).split('▸')]
            v = None
            for s_ in reversed(segs):
                if re.fullmatch(r'if \(' + rxp + r'\)', s_) or re.fullmatch(r'else of \(!' + rxp + r'\)', s_):
                    v = True; break
                if re.fullmatch(r'else of \(' + rxp + r'\)', s_) or re.fullmatch(r'if \(!' + rxp + r'\)', s_):
                    v = False; break
            if v is None:
                v = self.ctx_bool(self.method_of_line(i), prop, depth - 1, seen)
            if v is None:
                return None
            vals.add(v)
        return vals.pop() if len(vals) == 1 else None

    def member_pick(self, key, name):
        """T680: 속성·메서드 반환식 1개 — 후보가 하나면 그것, 'if (P)' / else 로 갈리면 잠금 메서드(key[1])의 호출 경로에서 P 값을 정해 고른다. 못 고르면 None"""
        rets = self.member_returns(name)
        if len({r_[1] for r_ in rets}) == 1:
            return rets[0][1]
        conds = set()
        for _, ex, g in rets:
            m_ = re.fullmatch(r'(if|else of) \((!?)(?:this\.)?(\w+)\)', g)
            if not m_:
                return None
            conds.add(m_.group(3))
        if len(conds) != 1:
            return None
        p_ = conds.pop()
        v = self.ctx_bool(key[1] if key else '', p_)
        if v is None:
            return None
        for _, ex, g in rets:
            m_ = re.fullmatch(r'(if|else of) \((!?)(?:this\.)?(\w+)\)', g)
            truth = (m_.group(1) == 'if') != bool(m_.group(2))
            if truth == v:
                return ex
        return None

    def field_ctrl(self, name, depth=2):
        """T675: 파일 전체에서 name 에 대입한 식이 모두 같은 조회조건 컨트롤(cbo·clb·rdo·cmb·usr X.ControlValues)로 이어지면 그 컨트롤 이름, 아니면 None.
        식이 다른 변수(+ .ToString())면 depth 만큼 따라감. 빈 값 초기화는 뺌. 주석 줄은 보지 않음"""
        if depth < 0 or not re.fullmatch(r'[A-Za-z_]\w*', name or ''):
            return None
        rx = re.compile(r'(?:^|[;{(\s])(?:(?:string|String|object|var)\s+)?' + re.escape(name) + r'\s*=(?!=)\s*(.+?);')
        ctls = set()
        for ln in self.lines:
            s = ln.split('//')[0]
            for m in rx.finditer(s):
                ex = m.group(1).strip()
                if re.fullmatch(r'(?:string|String)\.Empty|""|null', ex):
                    continue
                mc = re.search(r'\b((?:cbo|clb|rdo|cmb|usr)\w+)\.(?:ControlValues|SelectedValue|ControlValue)\b', ex)
                if mc:
                    ctls.add(mc.group(1)); continue
                mv = re.fullmatch(r'([A-Za-z_]\w*)(?:\.ToString\(\))?', ex)
                sub = self.field_ctrl(mv.group(1), depth - 1) if mv and mv.group(1) != name else None
                if not sub:
                    return None
                ctls.add(sub)
        return next(iter(ctls)) if len(ctls) == 1 else None

    def const_value(self, name):
        """같은 파일의 문자열·정수 상수 값 — `public static string S_Status_C = "C";` · `const string X = "v";` · `static readonly int N = 3;`
        이름은 `Cls.NAME` 또는 `NAME`. 같은 이름이 서로 다른 값으로 여러 번 정의돼 있으면(중첩 클래스마다 다른 값) 풀지 않는다(None). 2026-11-12 T263"""
        short = name.split('.')[-1]
        if not re.fullmatch(r'[A-Za-z_]\w*', short):
            return None
        cache = self.__dict__.setdefault('_const_cache', {})
        if short not in cache:
            rx = re.compile(r'\b(?:public|private|internal|protected)?\s*(?:static\s+readonly|static|const|readonly)\s+(?:readonly\s+)?(?:string|int|String)\s+' + re.escape(short) + r'\s*=\s*("[^"]*"|-?\d+)\s*;')
            vals = set()
            for ln in self.lines:
                s = ln.split('//')[0]
                m = rx.search(s)
                if m:
                    vals.add(m.group(1))
            cache[short] = vals.pop() if len(vals) == 1 else None
        # 2026-11-26 T676(DMF0003_1 'DefColumns.Measure = "MEASURE"' · 'DefColumnsLabel.Measure = "Measure"'): 같은 이름이 구조체마다 다른 값이면
        #   참조에 적힌 구조체(DefColumns.Measure 의 DefColumns) 블록 안 정의를 쓴다. 종전 = 풀지 않음 → 칸 이름이 'Measure' 로 남아 DMF0003 편집 기대 15칸이 엉뚱한 이름
        if cache[short] is None and '.' in name:
            cls = name.split('.')[-2]
            ck = f'{cls}.{short}'
            if ck not in cache:
                cache[ck] = None
                rx_c = re.compile(r'\b(?:struct|class)\s+' + re.escape(cls) + r'\b')
                rx = re.compile(r'\b(?:public|private|internal|protected)?\s*(?:static\s+readonly|static|const|readonly)\s+(?:readonly\s+)?(?:string|int|String)\s+' + re.escape(short) + r'\s*=\s*("[^"]*"|-?\d+)\s*;')
                for i, ln in enumerate(self.lines):
                    if not rx_c.search(ln.split('//')[0]):
                        continue
                    depth = 0; started = False; vals = set()
                    for ln2 in self.lines[i:]:
                        s = ln2.split('//')[0]
                        m = rx.search(s)
                        if m and started and depth == 1:
                            vals.add(m.group(1))
                        for ch in s:
                            if ch == '{':
                                depth += 1; started = True
                            elif ch == '}':
                                depth -= 1
                        if started and depth <= 0:
                            break
                    if len(vals) == 1:
                        cache[ck] = vals.pop()
                    break
            return cache[ck]
        return cache[short]

    def toggle_enter_pre(self, key, var):
        """상태 토글 변수 var 의 '편집 모드 진입 분기' 조건 값 — `if (var == false) { … var = true; }` 이면 False.
        메서드 안에서 `if (… var == X …)` 블록이 var 에 !X 를 대입하는 구조를 찾아, 대입 값이 true 인(= 편집 모드로 들어가는) 분기의 X 를 돌려준다.
        그런 구조가 없거나 서로 어긋나면 None(접지 않는다). 2026-11-12 T264"""
        rx_if = re.compile(r'\bif\s*\(\s*(?:this\.)?' + re.escape(var) + r'\s*==\s*(true|false)\s*\)')
        rx_as = re.compile(r'(?:this\.)?\b' + re.escape(var) + r'\s*=\s*(true|false)\s*;')
        ml = self.method_lines(key)
        found = set()
        for idx, (i, ln) in enumerate(ml):
            m = rx_if.search(ln.split('//')[0])
            if not m:
                continue
            depth = 0; started = False
            for _, l2 in ml[idx:]:
                s = l2.split('//')[0]
                for ch in s:
                    if ch == '{':
                        depth += 1; started = True
                    elif ch == '}':
                        depth -= 1
                ma = rx_as.search(s)
                if started and ma and depth >= 1:
                    if (ma.group(1) == 'true') != (m.group(1) == 'true') and ma.group(1) == 'true':
                        found.add(m.group(1) == 'true')
                if started and depth <= 0:
                    break
        return found.pop() if len(found) == 1 else None

    def defcol(self, name):
        """컬럼 상수 멤버 이름 → 컬럼 이름. 대문자·숫자·밑줄만이면 그대로(대부분 이름 = 값). 섞여 있으면 같은 파일 상수 값(EditFlag = "EDIT_FLAG") · 못 찾으면 이름 그대로. T265"""
        # 2026-11-20 T390(SSP0014 FACT-a7e4b62c): 대문자 이름도 원문 상수 값이 우선 — `const string DIVISION = "DIVISION_ID"`(cs:77) 을 이름 그대로 써
        #   LockColumn(DIVISION, NICK_NAME) 범위가 메타 순서에서 안 풀려 ENDPOINTS(양 끝만)로 적히고 없는 칸 DIVISION 이 생겼다
        v = self.const_value(name)
        if v and v.startswith('"') and re.fullmatch(r'"[A-Za-z0-9_]+"', v):
            return v.strip('"')
        return name.split('.')[-1]  # T676: 'DefColumns.X' 로 받아도 못 풀면 멤버 이름만

    def method_lines(self, key):
        lo, hi = self.spans.get(key, (0, 0))
        return [(i, self.lines[i - 1]) for i in range(max(lo, 1), min(hi, len(self.lines)) + 1)]

    def _cond_text(self, i):
        """줄 i 에서 시작하는 if/else if/for/while 의 괄호 조건 전체(여러 줄) → (키워드, 조건문)"""
        text = ''
        for k in range(i, min(i + 12, len(self.lines) + 1)):
            text += self.lines[k - 1].strip() + ' '
            m = re.match(r'\s*(?:\}\s*)?(else\s+if|if|for|foreach|while)\s*\((.*)', text)
            if m:
                body, d, out = m.group(2), 1, ''
                for ch in body:
                    if ch == '(': d += 1
                    elif ch == ')':
                        d -= 1
                        if d == 0: return m.group(1), out.strip()
                    out += ch
        return '', ''

    def source_guard(self, key, line):
        """원문에서 줄 line 을 감싸는 블록들의 조건(바깥 → 안쪽) — actions.csv 의 guard 가 '…' 로 잘렸을 때 쓴다.
        else 블록은 'else of (<짝 if 조건>)'. 조건을 못 읽은 블록은 'RAW(?)'"""
        lo, _ = self.spans.get(key, (0, 0))
        lo = max(1, min(lo, line) - 1)
        # 메서드 시작(선언 줄)까지 거슬러 올라가도록 lo 를 넉넉히 잡는다
        lo = max(1, lo - 400)
        segs, d, i = [], 0, line - 1
        while i >= lo:
            ln = self.lines[i - 1]
            d += ln.count('}'); d -= ln.count('{')
            if d < 0:
                d = 0
                # 블록을 여는 줄 — 조건은 이 줄 또는 바로 위 비어있지 않은 줄
                j = i
                RX_HEAD = re.compile(r'^\s*(\}\s*)?(else\s+if|else|if|for|foreach|while|try|finally|catch|switch)\b')
                while j >= lo and not RX_HEAD.match(self.lines[j - 1]):
                    s_ = self.lines[j - 1].strip()
                    if j != i and (s_.endswith(';') or s_.endswith('}') or s_.endswith('{')):
                        break  # 문장 경계 — 조건 없는 블록(메서드 본문 등)
                    j -= 1
                head = self.lines[j - 1].strip() if j >= lo and RX_HEAD.match(self.lines[j - 1]) else ''
                pv = j - 1
                while pv >= lo and not self.lines[pv - 1].strip():
                    pv -= 1
                if re.match(r'^(\}\s*)?else\b(?!\s+if)', head) and not head.startswith('}') and pv >= lo and not self.lines[pv - 1].rstrip().endswith('}'):
                    # 2026-11-26 T678(DMF0042 EditButton:589 'if (…IndexOf("M_") != 0) 한 문장; else {…}'): 중괄호 없는 if 의 else — 짝 if = else 와 들여쓰기가 같은 가장 가까운 if 줄
                    ind = len(self.lines[j - 1]) - len(self.lines[j - 1].lstrip())
                    k = pv
                    while k >= lo:
                        l2 = self.lines[k - 1]
                        if l2.strip() and len(l2) - len(l2.lstrip()) == ind and re.match(r'^\s*(\}\s*)?(else\s+)?if\s*\(', l2):
                            kw, ct = self._cond_text(k)
                            segs.append(f'else of ({ct})' if ct else 'else of (RAW(?))'); break
                        if l2.strip() and len(l2) - len(l2.lstrip()) < ind:
                            segs.append('else of (RAW(?))'); break
                        k -= 1
                    else:
                        segs.append('else of (RAW(?))')
                elif re.match(r'^(\}\s*)?else\b(?!\s+if)', head):
                    # 짝 if: else 앞의 '}' 로 닫힌 블록의 여는 줄을 찾아 그 if 조건
                    dd, k = 0, j - (0 if head.startswith('}') else 1)
                    while k >= lo:
                        l2 = self.lines[k - 1]
                        dd += l2.count('}'); dd -= l2.count('{')
                        if dd <= 0 and ('{' in l2 or k < j):
                            if dd <= 0 and '{' in l2:
                                kk = k
                                while kk >= lo and not re.search(r'\bif\s*\(', self.lines[kk - 1]) and self.lines[kk - 1].strip() in ('{', ''):
                                    kk -= 1
                                # T678(DMF0042 EditButton:653~658): 여러 줄 조건의 닫는 ')' 줄에 멈추면 if 줄까지 더 올라간다(15줄 · 문장 경계에서 멈춤)
                                k3 = kk
                                while k3 >= max(lo, kk - 15) and not re.search(r'\bif\s*\(', self.lines[k3 - 1]):
                                    s3 = self.lines[k3 - 1].strip()
                                    if k3 != kk and (s3.endswith(';') or s3.endswith('}') or s3.endswith('{')):
                                        break
                                    k3 -= 1
                                if k3 >= lo and re.search(r'\bif\s*\(', self.lines[k3 - 1]):
                                    kk = k3
                                kw, ct = self._cond_text(kk)
                                segs.append(f'else of ({ct})' if ct else 'else of (RAW(?))'); break
                        k -= 1
                    else:
                        segs.append('else of (RAW(?))')
                elif re.match(r'^(\}\s*)?(else\s+if|if|for|foreach|while)\b', head):
                    kw, ct = self._cond_text(j)
                    segs.append(f'{kw} ({ct})' if ct else 'RAW(?)')
                elif re.match(r'^(\}\s*)?(try|finally|catch|switch)\b', head):
                    segs.append(head.split('(')[0].strip('} '))
                elif re.search(r'\)\s*$', head) and re.search(r'^\s*(?:' + r'(?:public|private|protected|internal|static|override|virtual)\s+' + r')+', head):
                    break  # 메서드 선언에 닿음
                i = j
            i -= 1
        return ' ▸ '.join(reversed(segs))

    def var_defs(self, key, name):
        """[(line, expr)] — 메서드 안에서 name 에 대입한 식(선언 포함)"""
        rx = re.compile(r'^\s*(?:(?:string|int|bool|object|var|double|decimal|long|DataTable|DataRow)\s+)?' + re.escape(name) + r'\s*=(?!=)\s*(.+?);\s*$')
        out = []
        for i, ln in self.method_lines(key):
            m = rx.match(ln)
            if m:
                out.append((i, m.group(1).strip()))
        return out

    def table_family(self, key, tbl):
        for _, ex in self.var_defs(key, tbl):
            m = RX_TABLE_FAMILY.search(ex)
            if m:
                return m.group(1)
        return ''

    def col_arg(self, key, arg):
        """GetColumnIndex(…) 안의 식 → ('COL', NAME) · ('DYN', family) · ('RAW', text)"""
        arg = arg.strip()
        if arg == 'CAppSetting.StringAction':
            return ('COL', 'CRUD_TYPE')  # 프레임워크 행 상태 칸(2026-11-02 DMF0005)
        if arg == '0' and self.action_col0:
            return ('COL', 'CRUD_TYPE')  # T542: 0번 칸 = 행 상태 칸(__init__ action_col0 근거)
        m = RX_DEFCOL.search(arg)
        if m:
            return ('COL', self.defcol(m.group(0)))  # T676: 구조체 이름까지 넘김(같은 멤버 이름이 구조체마다 다른 값)
        ms = re.fullmatch(r'"([A-Za-z0-9_]+)"', arg)  # 2026-11-11 T245: GetColumnIndex("TO_SITE_SOLDTO_CODE") — 컬럼 이름을 문자열로 직접 준 형태(SSP0015 InsertRow:7861)
        if ms:
            return ('COL', ms.group(1).upper())
        if re.fullmatch(r'\w+', arg):
            defs = self.var_defs(key, arg)
            before = [d for d in defs if d[0] < self.line] if self.line else []
            for _, ex in (before[-1:] if before else defs):  # 잠금 문장 바로 앞의 마지막 대입(iCol 을 문장마다 다시 쓰는 DMF0003 EditButton 1067~1220)
                mt = re.search(r'(\w+)\.Rows\[[^\]]*\]\s*\[\s*Def\w+\.(\w+)\s*\]', ex)
                if mt:
                    fam = self.table_family(key, mt.group(1))
                    if fam:
                        return ('DYN', fam)
                mt2 = RX_DEFCOL.search(ex)
                if mt2:
                    return ('COL', self.defcol(mt2.group(0)))  # T676
        return ('RAW', arg)

    def atom(self, key, a, self_col=''):
        """가드 원자 1개 → 정규형. 접을 수 있으면 'TRUE'"""
        a = a.strip()
        # 2026-11-26 T673: 가드 문자열에 'else if (조건)' 이 통째로 원자로 들어온 경우(DMF0042 EditButton:611·631) — 안쪽 조건만 해석
        mei_ = re.fullmatch(r'else\s+if\s*\((.*)\)', a, re.S)
        if mei_ and self._balanced(mei_.group(1)):
            return self.expr(key, mei_.group(1), self_col)
        while a.startswith('(') and a.endswith(')') and self._balanced(a[1:-1]):
            a = a[1:-1].strip()
        if not a:
            return 'TRUE'
        # `x.Equals("lit")` → `x == "lit"` (SCP0041 status.Equals("HOLD") · status = GetText(iRow, GetColumnIndex(DefPack.DIR)) → COL(DIR)=="HOLD")
        a = re.sub(r'^(\w+(?:\.\w+)*)\.Equals\(\s*("[^"]*")\s*\)$', r'\1 == \2', a)
        a = re.sub(r'^!\s*(\w+(?:\.\w+)*)\.Equals\(\s*("[^"]*")\s*\)$', r'\1 != \2', a)
        # 포커스 탭 인덱스 가드 — 잠금 규칙은 그 탭의 시트(메인 시트) 기준으로 해석하므로 '== n' 은 TRUE, '!= n' 은 FALSE(2026-10-31 SCP0041 iFocusTabIndex == 1 = Pack Hold Stock 탭)
        mt_ = re.fullmatch(r'\w*TabIndex\w*\s*(==|!=)\s*\d+', a)
        if mt_:
            return 'TRUE' if mt_.group(1) == '==' else 'FALSE'
        # 2026-11-26 T684: EditButton 안의 행 상태 칸(StringAction) 표시 검사 = 편집 모드 토글. 숨김(Visible == false)이면 편집 모드로 들어가는 분기다
        #   (SpreadInfo.cs:9830~9831 SwitchLock 과 같은 모델 · DMF0082 EditButton:1570 'sv.Columns[xCol1].Visible == false' · xCol1 = sv.Columns[CAppSetting.StringAction].Index :1568)
        #   잠금 기대는 편집 모드에 들어간 뒤 상태라 이 분기는 TRUE, else(편집 모드 해제)는 FALSE
        mv_ = re.fullmatch(r'[\w.]+\.Columns\[\s*([\w.]+)\s*\]\.Visible\s*(==|!=)\s*(true|false)', a)
        if mv_ and key and key[1] == 'EditButton':
            ix_ = mv_.group(1)
            is_act = ix_ == 'CAppSetting.StringAction'
            if not is_act and re.fullmatch(r'\w+', ix_):
                ds_ = self.var_defs(key, ix_)
                is_act = len(ds_) == 1 and bool(re.fullmatch(r'[\w.]+\.Columns\[\s*CAppSetting\.StringAction\s*\]\.Index', ds_[0][1].strip()))
            if is_act:
                return 'TRUE' if (mv_.group(2) == '==') == (mv_.group(3) == 'false') else 'FALSE'
        # 동적 컬럼 루프 필터(태그 접두) — 컬럼 전개(<DYNAMIC:…>)가 이미 대상을 정했으므로 조건으로는 항상 참(2026-10-31 SCP0096 SetLockSumColumn)
        mtag = re.fullmatch(r'(?:\w+\.)?GetColumnTag\(\s*\w+\s*\)\.IndexOf\(\s*"(\w+_?)"\s*\)\s*==\s*0', a)
        if mtag:
            return f'SELF~"^{mtag.group(1)}"'  # 동적 binding 접두 조건 — 전 패밀리가 아니라 그 접두 컬럼만(2026-10-31 SCP0096 M_/W_ 합계 컬럼)
        # 2026-11-26 T679(DMF0042 EditButton:587 'GetColumnTag(iCol).IndexOf("M_") != 0' · DMF0003 EditButton:1094 'IndexOf("W_") != -1' ·
        #   DMF0044 EditButton:358 'GetValue(iRow, …MEASURE).ToString().IndexOf("RTF") >= 0'): 접두(== 0 · != 0) · 포함(!= -1 · >= 0 · > -1 · == -1 · < 0)
        #   검사를 태그면 SELF~ · 칸 값이면 COL(X)~ 정규식 원자로(condeval.ts). 그 밖 비교 값은 RAW 유지
        mix = re.fullmatch(r'(.+?)\.IndexOf\(\s*"([A-Za-z0-9_ ]+)"\s*\)\s*(==|!=|>=|>|<)\s*(-?\d+)', a)
        if mix:
            kind_ = {('==', 0): ('^', True), ('!=', 0): ('^', False), ('!=', -1): ('', True), ('>=', 0): ('', True),
                     ('>', -1): ('', True), ('==', -1): ('', False), ('<', 0): ('', False)}.get((mix.group(3), int(mix.group(4))))
            if kind_:
                rx_ = kind_[0] + mix.group(2)
                if re.fullmatch(r'(?:\w+\.)?GetColumnTag\(\s*\w+\s*\)', mix.group(1)):
                    at_ = f'SELF~"{rx_}"'
                else:
                    L_ = self.lhs(key, mix.group(1), self_col)
                    at_ = f'{L_}~"{rx_}"' if L_ and re.fullmatch(r'COL\(\w+\)', L_) else ''
                if at_:
                    return at_ if kind_[1] else f'!({at_})'
        # 2026-11-12 T264 ① 행 수 조건 — 검사는 조회 행이 있을 때만 잰다
        mr_ = re.fullmatch(r'(?:\w+(?:\(\d+\)|\[\d+\])?\.)+(?:Rows\.Count|RowCount)\s*(>|>=|==|!=|<=)\s*(\d+)', a)
        if mr_ and re.search(r'ActiveSheet|Sheet\(\d+\)|Sheets\[', a):
            op_, n_ = mr_.group(1), int(mr_.group(2))
            if n_ == 0:
                return {'>': 'TRUE', '!=': 'TRUE', '==': 'FALSE', '<=': 'FALSE', '>=': 'TRUE'}[op_]
        # ② 편집 모드 플래그 변수 — TO-BE 는 조회 즉시 편집 모드(CR-084·CR-093)
        me_ = re.fullmatch(r'(!?)\s*(?:this\.)?((?:b|is|_b|m_b)?_?[Ee]dit_?[Mm]ode)\s*(?:(==|!=)\s*(true|false))?', a)
        if me_:
            want_ = True                      # 이 원자가 참이 되는 변수 값
            if me_.group(3):
                want_ = (me_.group(3) == '==') == (me_.group(4) == 'true')
            if me_.group(1):
                want_ = not want_
            pre_ = self.toggle_enter_pre(key, me_.group(2))   # 편집 모드로 들어가는 분기의 '들어가기 전 값'(원문 구조로 확인) · 못 찾으면 None
            if pre_ is not None:
                return 'TRUE' if want_ == pre_ else 'FALSE'
        # ③ 편집 권한 플래그 변수 — 계정에 따라 다르므로 평가 가능한 원자로 내보낸다(평가기 문맥 auth)
        ma_ = re.fullmatch(r'(!?)\s*(?:this\.)?(?:b|is|_b|m_b)?_?[Ee]dit_?[Aa]uth\s*(?:(==|!=)\s*(true|false))?', a)
        if ma_:
            pos_ = True
            if ma_.group(2):
                pos_ = (ma_.group(2) == '==') == (ma_.group(3) == 'true')
            if ma_.group(1):
                pos_ = not pos_
            return 'AUTH' if pos_ else '!(AUTH)'
        # ④ 다중 시트 컨트롤(siDetail 등)의 활성 시트 조건 — 컨트롤 이름으로 접지 못하는 경우 시트 이름 상수값으로 내보낸다
        msh_ = re.fullmatch(r'(?:\w+\.)?ActiveSheet\.SheetName\s*(==|!=)\s*((?:\w+\.)*sht\w+)', a)
        if msh_:
            cv0_ = self.const_value(msh_.group(2))
            if cv0_ and cv0_.startswith('"'):
                return f'SHEET{msh_.group(1)}{cv0_}'  # 시트 이름 상수값으로 — 컨트롤 이름(siDetail ↔ shtDetail)이 우연히 같아도 다중 시트일 수 있어 접지 않는다
            suf0_ = re.sub(r'^(si|spd)', '', self.control or '', flags=re.I).lower()
            if suf0_:  # 상수값을 못 풀면 종전 규칙(컨트롤 이름 ↔ 시트 상수 이름)으로
                same0_ = msh_.group(2).split('.')[-1][3:].lower() == suf0_
                return 'TRUE' if same0_ == (msh_.group(1) == '==') else 'FALSE'
        # 접는 것(TRUE)
        if re.fullmatch(r'string\.IsNullOrEmpty\(\s*\w+\s*\)', a):
            # T460(2026-11-20 SCP0005 FACT-a3f92559·FACT-3d955bfe): 변수가 그리드 칸 값(string strFromCity = siMain.GetValue(i, nFromCityName).ToString())이면 COL(X)==""
            #   (cs:1301~1305 CheckValid). 그 밖(세션 그룹·Division 값)은 종전대로 비어 있지 않다고 본다
            L0_ = self.lhs(key, re.search(r'\(\s*(\w+)\s*\)', a).group(1), self_col)
            if L0_ and L0_.startswith('COL('):
                return f'{L0_}==""'
            return 'FALSE'  # 세션 값(그룹·Division)은 비어 있지 않다고 본다 → '!string.IsNullOrEmpty(x)' 는 expr 의 부정으로 TRUE
        if re.search(r'\b(spd\w+|si\w+|fps|spreadInfo)\s*!=\s*null\b', a) or re.search(r'IsLock\([^)]*\)\s*==\s*false', a) \
                or re.search(r'\.IsEditMode\s*==\s*true', a) or re.fullmatch(r'(try|finally|else)', a):
            return 'TRUE'
        # 2026-11-26 T671(SCP0104 SetLockColumnsAllAssign·AllSOP 8문장 미해석): ① this.IsEditModes[키] = 편집 모드 플래그 — IsEditMode == true 와 같게 참
        #   (TO-BE 룰 CR-084·093 편집 버튼 없음·조회 즉시 상시 편집) ② 행 수 변수(RowCount·GetMaxRowIndex()+1 대입) > 0 = 참(행이 있을 때만 평가)
        #   ③ 칸 위치 변수(GetColumnIndex 대입) != -1 = 참(잠그는 칸이 시트에 있음). 대입식을 메서드 안에서 확인한 변수만
        if re.fullmatch(r'(?:this\.)?IsEditModes\s*\[[^\]]+\]', a):
            return 'TRUE'
        # 2026-11-26 T672(DMF0003 26 · DMF0005 3 문장 RAW(IsEditMode == true)): 폼 속성 IsEditMode 를 점 없이 쓴 형태 — 위 '.IsEditMode == true' 와 같은 처리
        #   · '!x.IsLock(시트)' = 'IsLock(...) == false' 와 같음 · 'x.GetColumnIndex(Def.X) != -1' = 잠그는 칸이 시트에 있음(T671 ③ 과 같음)
        mie_ = re.fullmatch(r'(!\s*)?(?:this\.)?IsEditMode(?:\s*(==|!=)\s*(true|false))?', a)
        if mie_:
            pos_ = (mie_.group(2) != '!=') == (mie_.group(3) != 'false')
            return 'TRUE' if pos_ != bool(mie_.group(1)) else 'FALSE'
        if re.fullmatch(r'!\s*(?:spd\w+|si\w+|_si\w+|spreadInfo)\.IsLock\([^()]*\)', a):
            return 'TRUE'
        if re.fullmatch(r'(?:spd\w+|si\w+|_si\w+|spreadInfo)\.GetColumnIndex\([^()]*\)\s*(?:!=\s*-1|>=\s*0|>\s*-1)', a):
            return 'TRUE'
        # T674: '> 0' 도 칸 존재 — 0번 칸은 프레임워크 행 상태 칸(StringAction · SpreadInfo.cs:1350~1351)이라 업무 칸은 1번부터(DMF0003 EditButton:1248~1256 6원자)
        #   행 상태 칸 자신(StringAction)을 묻는 경우는 제외
        if re.fullmatch(r'(?:spd\w+|si\w+|_si\w+|spreadInfo)\.GetColumnIndex\((?!\s*CAppSetting\.StringAction)[^()]*\)\s*>\s*0', a):
            return 'TRUE'
        # 2026-11-26 T674(DMF0003·DMF0005 16원자 RAW(!siMain.IsLock(siMain.SheetName))): expr 가 '!' 를 떼고 넘긴 단독 'x.IsLock(시트)' — 편집 모드에서 거짓
        #   (위 'IsLock(...) == false' = 참과 같은 처리 · T672 의 '!' 포함 형태는 expr 를 거치면 닿지 않았음)
        if re.fullmatch(r'(?:spd\w+|si\w+|_si\w+|spreadInfo)\.IsLock\([^()]*\)', a):
            return 'FALSE'
        # T674: 조회조건 컨트롤 값을 담은 변수의 null 검사(sDivision != null · DMF0003 spdMain_ComboSelChange:2527 5원자) = 참(세션·조회조건 값은 비어 있지 않다고 보는 종전 처리와 같음)
        mnn_ = re.fullmatch(r'(\w+)\s*!=\s*null', a)
        if mnn_ and any(re.search(r'\b(?:cbo|clb|rdo|cmb|usr)\w+\.(?:ControlValues|SelectedValue|ControlValue)', ex) for _, ex in self.var_defs(key, mnn_.group(1))):
            return 'TRUE'
        mv_ = re.fullmatch(r'(\w+)\s*(>\s*0|>=\s*1|!=\s*0)', a)
        if mv_ and any(re.search(r'\.RowCount(?!\w)|GetMaxRowIndex\(\)\s*\+\s*1', ex) for _, ex in self.var_defs(key, mv_.group(1))):
            return 'TRUE'
        mv_ = re.fullmatch(r'(\w+)\s*(!=\s*-1|>=\s*0|>\s*-1)', a)
        if mv_ and any(re.fullmatch(r'[\w.]+\.GetColumnIndex\([^()]*\)', ex) for _, ex in self.var_defs(key, mv_.group(1))):
            return 'TRUE'
        if re.search(r'\.IsEditMode\s*==\s*false', a):
            return 'FALSE'
        # 시트·컨트롤 상태 가드 — 지금 잠그는 컨트롤(siMain ↔ spdMain · shtMain) 기준으로 접는다(SCP0020 fps.Name == "spdMain" · ActiveSheetIndex == 0 · SheetName == SpdSheet.shtMain)
        suf = re.sub(r'^(si|spd)', '', self.control or '', flags=re.I).lower()
        ms_ = re.fullmatch(r'(?:\w+\.)?ActiveSheetIndex\s*(==|!=)\s*(\d+)', a)
        if ms_:
            main_ = ms_.group(2) == '0'
            return 'TRUE' if (main_ == (suf in ('main', ''))) == (ms_.group(1) == '==') else 'FALSE'
        ms_ = re.fullmatch(r'fps\.Name(?:\.Equals\(|\s*(==|!=)\s*)\s*(?:"(\w+)"|(\w+)\.Name)\)?', a)
        if ms_ and suf:
            tgt = (ms_.group(2) or ms_.group(3) or '').lower()
            same = re.sub(r'^(si|spd)', '', tgt) == suf
            return 'TRUE' if same == (ms_.group(1) != '!=') else 'FALSE'
        ms_ = re.fullmatch(r'(?:\w+\.SheetName|_?s?\w*SheetName)\s*(==|!=)\s*SpdSheet\.sht(\w+)', a)
        if ms_ and suf:
            same = ms_.group(2).lower() == suf
            return 'TRUE' if same == (ms_.group(1) == '==') else 'FALSE'
        # `식 == true/false` → 식 / !(식)
        mb_ = re.fullmatch(r'(.+?)\s*(==|!=)\s*(true|false)', a)
        if mb_ and not re.search(r'\.IsEditMode$|IsLock\(', mb_.group(1)):
            inner_ = self.expr(key, mb_.group(1), self_col); pos_ = (mb_.group(2) == '==') == (mb_.group(3) == 'true')
            if not inner_.startswith('RAW('):
                return inner_ if pos_ else ('FALSE' if inner_ == 'TRUE' else 'TRUE' if inner_ == 'FALSE' else f'!({inner_})')
        # String.IsNullOrEmpty(si.GetText(iRow, si.GetColumnIndex(Def*.X))) → COL(X)==""
        mn_ = re.fullmatch(r'[Ss]tring\.IsNullOrEmpty\(\s*((?:\w+\.)+Get(?:Text|Value)\(.*\)(?:\.ToString\(\))?)\s*\)', a)
        if mn_:
            L_ = self.lhs(key, mn_.group(1), self_col)
            if L_:
                return f'{L_}==""'
        # 불리언 플래그 변수(isMultiChildItem) 단독
        if re.fullmatch(r'\w+', a):
            bv = self.bool_var(key, a, self.line)
            if bv is not None:
                return bv
        m = re.fullmatch(r'(.+?)\s*(==|!=)\s*(.+)', a)
        if m and not re.search(r'\(.*\)\s*$', m.group(1)) or (m and re.fullmatch(r'[\w.]+\([^=]*\)(?:\.ToString\(\))?', m.group(1).strip())) \
                or (m and re.fullmatch(r'UserInfoContext\.Current\[\s*"\w+"\s*\](?:\.ToString\(\))?', m.group(1).strip())):  # T267: 세션 그룹 직접 비교
            lhs, op, rhs = m.group(1).strip(), m.group(2), m.group(3).strip()
            rhs = '""' if rhs in ('string.Empty', 'String.Empty') else rhs
            rhs = {'CAppSetting.StringY': '"Y"', 'CAppSetting.StringN': '"N"'}.get(rhs, rhs)  # 프레임워크 상수(2026-11-02 EDIT_FLAG=="Y" 가 전부 RAW 였음)
            rhs = fw_consts().get(rhs, rhs)  # T542: CAppSetting const(FlagI·FlagM·FlagD)
            if not re.fullmatch(r'"[^"]*"|-?\d+', rhs) and re.fullmatch(r'(?:\w+\.)*[A-Za-z_]\w*', rhs):  # 2026-11-12 T263: 우변이 같은 파일 상수(Shipment_Status.S_Status_C = "C")
                cv_ = self.const_value(rhs)
                if cv_ is not None:
                    rhs = cv_
            L = self.lhs(key, lhs, self_col)
            if L and re.fullmatch(r'"[^"]*"|-?\d+', rhs):
                return f'{L}{op}{rhs}'
        self.unresolved.append(a)
        return f'RAW({a})'

    def lhs(self, key, lhs, self_col):
        """비교 좌변 → GROUP · DIV · COL(NAME) · COL(NAME)[a:b] · COL(SELF)"""
        # 가드 안의 직접 GetText/GetValue(…GetColumnIndex(Def*.COL)…) (SCP0020 siMain.ActiveSheet.GetText(i, …INPUT_STATUS…).ToString() == "M")
        mi = re.fullmatch(r'(?:\w+\.)+Get(?:Text|Value)\(\s*[\w.]+\s*,\s*\w+\.GetColumnIndex\(\s*([^)]+)\)\s*\)(?:\.ToString\(\))?(?:\.Substring\(\s*(\d+)\s*,\s*(\d+)\s*\))?', lhs)
        if mi:
            kind, nm = self.col_arg(key, mi.group(1))
            sl0 = f'[{mi.group(2)}:{int(mi.group(2)) + int(mi.group(3))}]' if mi.group(2) else ''
            return f'COL({nm}){sl0}' if kind == 'COL' else f'COL(SELF){sl0}' if kind == 'DYN' else ''
        if self.action_col0 and re.fullmatch(r'(?:\w+\.)+Get(?:Text|Value)\(\s*[\w.]+\s*,\s*0\s*\)(?:\.ToString\(\))?', lhs):
            return 'COL(CRUD_TYPE)'  # T680: 0번 칸 = 행 상태 칸(SCP0104 GetCurrEditType :3915 _siAssign.GetText(rowIdx, 0))
        mu_ = re.fullmatch(r'UserInfoContext\.Current\[\s*"(\w+)"\s*\](?:\.ToString\(\))?', lhs)
        if mu_ and re.search(r'GROUP', mu_.group(1), re.I):
            return 'GROUP'
        # 2026-11-26 T673(DMF0003·DMF0042 원자 88 'cboBucketType.ControlValues == BucketType.Daily' · DMF0003 10 'clbDivision.ControlValues == "81"'):
        #   조회조건 컨트롤 값을 변수 없이 바로 비교 — Division 컨트롤 = DIV · 그 밖의 조회조건 컨트롤 = SRCH(컨트롤) (검사기가 조회 요청 본문 값으로 평가 · condeval.ts)
        mc_ = re.fullmatch(r'((?:cbo|clb|rdo|cmb|usr)\w+)\.(?:ControlValues|SelectedValue|ControlValue)(?:\.ToString\(\))?(?:\.Substring\(\s*(\d+)\s*,\s*(\d+)\s*\))?', lhs)
        if mc_:
            sl_ = f'[{mc_.group(2)}:{int(mc_.group(2)) + int(mc_.group(3))}]' if mc_.group(2) else ''
            if RX_DIV_SRC.search(mc_.group(1)):
                return 'DIV' + sl_
            return '' if sl_ else f'SRCH({mc_.group(1)})'  # 조회조건 값 일부 비교는 평가기(SRCH)에 없음 → 평가 불가 유지
        # 2026-11-26 T675(SCP0007 InsertButton:411 16원자 'strSel_InputStatus == "R"'): 조회 때 다른 메서드에서 조회조건 값을 저장해 둔 필드
        #   (strSel_InputStatus = p_input_status.ToString() · p_input_status = GetCheckedListValue(dtInputStatus, cboInputStatus.ControlValues, true)).
        #   파일 전체 대입을 2단계까지 따라가 모두 같은 조회조건 컨트롤이면 SRCH(컨트롤)·DIV. 빈 값 초기화(string.Empty·""·null)는 셈에서 뺌
        if re.fullmatch(r'\w+', lhs) and not self.var_defs(key, lhs):
            ctl_ = self.field_ctrl(lhs)
            if ctl_:
                return 'DIV' if RX_DIV_SRC.search(ctl_) else f'SRCH({ctl_})'
        ms = re.fullmatch(r'(\w+)\.Substring\(\s*(\d+)\s*,\s*(\d+)\s*\)', lhs)
        base, sl = (ms.group(1), f'[{ms.group(2)}:{int(ms.group(2)) + int(ms.group(3))}]') if ms else (lhs, '')
        if not re.fullmatch(r'\w+', base):
            return ''
        defs = self.var_defs(key, base)
        for _, ex in defs:
            if RX_GROUP_SRC.search(ex):
                return 'GROUP' + sl
            mg = re.search(r'Get(?:Value|Text)\(\s*[\w.]+\s*,\s*\w+\.GetColumnIndex\(\s*([^)]+)\)\s*\)', ex)  # T267: 행 인자 e.Row
            mg = mg or re.search(r'Get(?:Value|Text)\(\s*[\w.]+\s*,\s*(\w+)\s*\)', ex)  # T460: 칸 번호 변수(nFromCityName = …GetColumnIndex(Def*.X)) — col_arg 가 변수 대입을 따라감
            if mg:
                kind, nm = self.col_arg(key, mg.group(1))
                if kind == 'COL':
                    return f'COL({nm}){sl}'
                if kind == 'DYN':
                    return f'COL(SELF){sl}'
            if RX_DIV_SRC.search(ex) and re.search(r'ControlValues|SelectedValue|GetCheckedListValue|SelectedItem', ex):
                return 'DIV' + sl
            md = re.fullmatch(r'(\w+)\.Substring\(\s*(\d+)\s*,\s*(\d+)\s*\)', ex)  # 파생 변수(packFlag = seqFlag.Substring(0,1))
            if md:
                inner = self.lhs(key, md.group(1), self_col)
                if inner and inner.startswith('COL('):
                    return f"{inner.split('[')[0]}[{md.group(2)}:{int(md.group(2)) + int(md.group(3))}]"
            # T680: 같은 파일 메서드 호출 값(SCP0104 editType = GetCurrEditType(rowIdx) · 반환 = _siAssign.GetText(rowIdx, 0)) — 반환식 1개를 좌변으로 다시 해석
            mm_ = re.fullmatch(r'([A-Za-z_]\w*)\(\s*[\w.]*\s*\)', ex)
            if mm_ and not sl:
                pk_ = self.member_pick(key, mm_.group(1))
                if pk_ and pk_ != ex:
                    inner = self.lhs(key, pk_, self_col)
                    if inner:
                        return inner
        return ''

    def expr(self, key, text, self_col=''):
        """가드 절(괄호·&&·||·!) → 정규형 식(원자별 정규화, TRUE 접기)"""
        t = text.strip()
        if t.startswith('if (') and t.endswith(')'):
            t = t[4:-1].strip()
        while t.startswith('(') and t.endswith(')') and self._balanced(t[1:-1]):
            t = t[1:-1].strip()
        m = re.fullmatch(r'else of \((.*)\)', t)
        if m:
            inner = self.expr(key, m.group(1), self_col)
            if inner.startswith('!(') and inner.endswith(')') and self._balanced(inner[2:-1]):
                return inner[2:-1]  # T679: else of (!X) = X (이중 부정 정리)
            return 'TRUE' if inner == 'FALSE' else 'FALSE' if inner == 'TRUE' else f'!({inner})'
        if re.match(r'^(for|foreach|while)\b', t):
            return 'TRUE'
        parts = self._split(t, '||')
        if len(parts) > 1:
            xs = [self.expr(key, p, self_col) for p in parts]
            if any(x == 'TRUE' for x in xs): return 'TRUE'
            xs = [x for x in xs if x != 'FALSE']
            return ' || '.join(f'({x})' if ' && ' in x else x for x in xs) if xs else 'FALSE'
        parts = self._split(t, '&&')
        if len(parts) > 1:
            xs = [self.expr(key, p, self_col) for p in parts]
            if any(x == 'FALSE' for x in xs): return 'FALSE'
            xs = [x for x in xs if x != 'TRUE']
            return ' && '.join(f'({x})' if ' || ' in x else x for x in xs) if xs else 'TRUE'
        if t.startswith('!') and not t.startswith('!='):
            inner = self.expr(key, t[1:], self_col)
            if inner == 'TRUE': return 'FALSE'
            if inner == 'FALSE': return 'TRUE'
            if inner.startswith('RAW('): return f'RAW({t})'
            return f'!({inner})'
        return self.atom(key, t, self_col)

    def guard(self, key, guard_path, self_col='', line=0):
        if '…' in (guard_path or '') and line:  # 추출기가 긴 조건을 잘랐다 → 원문에서 감싸는 블록 조건을 다시 읽는다(SCP0111 isEdit 의 그룹 3종 OR)
            sg = self.source_guard(key, line)
            if sg and '…' not in sg:
                guard_path = sg
        parts = [self.expr(key, g, self_col) for g in (guard_path or '').split('▸')]
        parts = [p for p in parts if p and p != 'TRUE']
        if any(p == 'FALSE' for p in parts):
            return 'FALSE'
        return ' && '.join(f'({p})' if ' || ' in p else p for p in parts)

    def bool_var(self, key, name, line):
        """불리언 플래그 변수 → '참이 되는 조건' 정규형(대입 true 의 가드 OR). 정의 없으면 None"""
        conds = []
        for i, ex in self.var_defs(key, name):
            if i >= line:
                continue
            if ex.strip() == 'true':
                keep = self.line; self.line = i  # 플래그 대입 가드 안의 또 다른 플래그는 그 줄 기준으로
                g = self.guard(key, self.guard_of_line.get((key[0], key[1], i), '') or self.source_guard(key, i), line=i)
                self.line = keep
                conds.append(g or 'TRUE')
            elif ex.strip() != 'false':
                # T680: 대입이 1개뿐이고 비교식이면 그 식이 값(SCP0104 SetLockColumnsAllAssign:3983 isInsertMode = (editType != "I")) — 평가 불가 원자가 남으면 종전대로 None
                defs_ = [d_ for d_ in self.var_defs(key, name) if d_[0] < line]
                if len(self.var_defs(key, name)) == 1 and len(defs_) == 1 and re.search(r'==|!=|<|>', ex):
                    v_ = self.expr(key, ex)
                    if v_ and 'RAW(' not in v_:
                        return v_
                return None
        if not conds:
            return 'FALSE' if self.var_defs(key, name) else None
        if any(c == 'TRUE' for c in conds):
            return 'TRUE'
        return ' || '.join(f'({c})' if ' && ' in c else c for c in conds)

    @staticmethod
    def _balanced(s):
        d = 0
        for ch in s:
            d += ch == '('; d -= ch == ')'
            if d < 0: return False
        return d == 0

    @staticmethod
    def _split(s, op):
        out, d, cur, i = [], 0, '', 0
        while i < len(s):
            ch = s[i]
            if ch == '(': d += 1
            elif ch == ')': d -= 1
            if d == 0 and s.startswith(op, i):
                out.append(cur); cur = ''; i += len(op); continue
            cur += ch; i += 1
        out.append(cur)
        return [x for x in out if x.strip()]


def _nrm_sheet(s):
    return re.sub(r'[^a-z0-9가-힣]', '', (s or '').lower())


def spec_sheet(cond, sheet):
    """정규형 조건의 SHEET=="X" · SHEET!="X" 원자를 시트 sheet 기준 참·거짓으로 접는다(2026-11-26 T658 다중 시트 편집 기대).
    결과: '' = 항상 참 · 'FALSE' = 이 시트에서 성립 안 함 · 그 밖 = 남은 조건. 다른 원자는 그대로 둔다"""
    def ss(t):
        t = (t or '').strip()
        if not t or t == 'TRUE':
            return 'TRUE'
        if t == 'FALSE':
            return 'FALSE'
        while t.startswith('(') and t.endswith(')') and Resolver._balanced(t[1:-1]):
            t = t[1:-1].strip()
        for op, absorb, unit in (('||', 'TRUE', 'FALSE'), ('&&', 'FALSE', 'TRUE')):
            ps = Resolver._split(t, op)
            if len(ps) > 1:
                xs = [ss(p) for p in ps]
                if absorb in xs:
                    return absorb
                xs = [x for x in xs if x != unit]
                if not xs:
                    return unit
                if len(xs) == 1:
                    return xs[0]
                other =' && ' if op == '||' else ' || '
                return f' {op} '.join(f'({x})' if other in x else x for x in xs)
        if t.startswith('!(') and t.endswith(')') and Resolver._balanced(t[2:-1]):
            x = ss(t[2:-1])
            return 'FALSE' if x == 'TRUE' else 'TRUE' if x == 'FALSE' else f'!({x})'
        m = re.fullmatch(r'SHEET\s*(==|!=)\s*"([^"]*)"', t)
        if m and sheet is not None:  # T685: sheet=None 이면 SHEET 원자는 두고 TRUE·FALSE 만 접는다
            same = _nrm_sheet(m.group(2)) == _nrm_sheet(sheet)
            return 'TRUE' if same == (m.group(1) == '==') else 'FALSE'
        return t
    r = ss(cond)
    return '' if r == 'TRUE' else r


def main():
    if '--selftest' in sys.argv:
        return selftest()
    ap = argparse.ArgumentParser()
    ap.add_argument('asis_id')
    ap.add_argument('--class', dest='cls', default='')
    a = ap.parse_args()
    # 2026-11-26 T673: 'DMF0005/' 처럼 끝에 경로 기호가 붙은 인자 — 종전엔 오류 없이 빈 사실로 계산해 그 화면 파일을 덮어씀(17:30·17:55 사고 · 27화면) → 기호 제거 · 형식 아니면 중단
    sid = re.sub(r'[\\/\s]+$', '', a.asis_id.strip()).upper()
    if not re.fullmatch(r'[A-Z][A-Z0-9_]*', sid):  # GSCM_BASECODE 같은 폴더 이름도 허용
        print(f'[ERROR] 화면 ID 형식 아님: {a.asis_id!r}'); return 2
    sdir = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid)
    if not os.path.exists(os.path.join(sdir, 'files.csv')):
        print(f'[ERROR] AS-IS 사실 없음: {sdir}/files.csv — pack 먼저'); return 2
    cur_files = {f['file'] for f in read_csv(os.path.join(sdir, 'files.csv')) if is_cur(f)}
    dead = dead_methods(sid)  # 실행되지 않는 AS-IS 메서드의 잠금은 사실 아님(2026-10-30 asis_live)
    acts = [x for x in read_csv(os.path.join(sdir, 'actions.csv')) if (not cur_files or x['file'] in cur_files) and (x['class'], x['method']) not in dead]
    main_files = {f['file'] for f in read_csv(os.path.join(sdir, 'files.csv')) if is_main(f, sdir) and f['file'].endswith('.cs') and not f['file'].endswith('.Designer.cs')}
    cnt = {}
    for x in acts:
        if x['file'] in main_files:
            cnt[x['class']] = cnt.get(x['class'], 0) + 1
    main_cls = a.cls or (max(cnt, key=cnt.get) if cnt else next((x['class'] for x in acts if x['class'].upper().startswith(sid + '_') and 'Popup' not in x['class']), ''))
    meta = [m for m in read_csv(os.path.join(sdir, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv')) if (m.get('PROGRAM_ID') or '').upper() == sid and m.get('VALID_YN', 'Y') != 'N']
    sheets = {}
    for m in meta:
        sheets.setdefault(m['SHEET_NAME'], []).append(m)
    main_sheet = max(sheets, key=lambda s: len(sheets[s])) if sheets else ''
    ms = sorted(sheets.get(main_sheet, []), key=lambda m: float(m.get('SORT_ORDER_NO') or 0))
    order = [m['COLUMN_NAME'].upper() for m in ms]
    if not order:  # 메타 없는 화면 — 코드 선언 순(grid_columns_asis.csv)
        order = [c['column'].upper() for c in read_csv(os.path.join(sdir, 'grid_columns_asis.csv')) if c.get('source') == 'CODE' and re.fullmatch(r'[A-Z0-9_]+', c.get('column') or '')]
    sort_no = {m['COLUMN_NAME'].upper(): m.get('SORT_ORDER_NO') for m in ms}
    visible = {m['COLUMN_NAME'].upper(): m.get('VISIBLE_FLAG', 'Y') for m in ms}

    # 원문·메서드 범위(변수 해석용)
    main_file = next((x['file'] for x in acts if x['class'] == main_cls and x['file'] in main_files), '')
    src = _src_path(main_file) if main_file else ''
    src_lines = strip_comments(open(src, encoding='utf-8-sig', errors='replace').read()).split('\n') if src and os.path.exists(src) else []
    spans = {}
    for x in acts:
        k = (x['class'], x['method']); ln = int(x['line'] or 0)
        lo, hi = spans.get(k, (ln, ln)); spans[k] = (min(lo, ln), max(hi, ln))
    R = Resolver(src_lines, spans, acts)
    # 2026-11-18 SCP0111 D3(cs:622~642): 'V = Data.Common(Data.Type.LookupCommon, false, "TYPE"); for (…) { b = V.Rows[i]["NAME"]…; if (a == b) flag = true }' 존재 검사가
    #   RAW(V != null) && RAW(V.Rows.Count > 0) && RAW(a == b) 로 남아 평가 불가였다 → INLOOKUP(<a 의 정규형>,"TYPE","NAME") 원자(condeval · lookups.json 값 목록)
    lookup_types = set()

    def lookup_fix(key, cond, ln0):
        for V in sorted(set(re.findall(r'RAW\((\w+) != null\)', cond))):
            m = re.search(r'RAW\(' + re.escape(V) + r' != null\) && RAW\(' + re.escape(V) + r'\.Rows\.Count > 0\) && RAW\((\w+) == (\w+)\)', cond)
            if not m:
                continue
            dv = [d for d in R.var_defs(key, V) if d[0] < ln0] or [(i_, re.sub(r'^\s*DataTable\s+' + re.escape(V) + r'\s*=\s*', '', l_).rstrip(';').strip()) for i_, l_ in R.method_lines(key) if re.match(r'^\s*DataTable\s+' + re.escape(V) + r'\s*=', l_) and i_ < ln0]
            ml = re.search(r'Data\.Common\(\s*Data\.Type\.LookupCommon\w*\s*,\s*\w+\s*,\s*"([^"]+)"', dv[-1][1]) if dv else None
            if not ml:
                continue
            a_, b_ = m.group(1), m.group(2)
            fld = None
            for x_, y_ in ((a_, b_), (b_, a_)):
                for i_, l_ in R.method_lines(key):
                    mm = re.search(r'\b' + re.escape(y_) + r'\s*=\s*' + re.escape(V) + r'\.Rows\[\w+\]\["(\w+)"\]', l_)
                    if mm:
                        fld = (x_, mm.group(1)); break
                if fld: break
            if not fld:
                continue
            e_ = R.expr(key, f'{fld[0]} == "__Z__"', '')
            mc_ = re.match(r'^(COL\(\w+\))=="__Z__"$', e_ or '')
            if not mc_:
                continue
            lookup_types.add(ml.group(1))
            cond = cond.replace(m.group(0), f'INLOOKUP({mc_.group(1)},"{ml.group(1)}","{fld[1]}")')
        return cond
    # T542(2026-11-25 SCP0005 FACT-c0e149fc·FACT-75a752a0): 색 문장을 감싼 for/foreach/while 본문 안, 그 문장 앞의 `if (C) continue;` · `if (C) { …; break; }` 는
    #   그 행에서 색 문장을 건너뛰게 한다(CheckValid cs:1286~1287 행 상태 I·M·D 아님 continue · cs:1293~1298 PRIORITY<1 break → cs:1305·1313 미실행).
    #   종전 cond 는 색 문장 자신의 guard 만 읽었다 → 같은 루프 본문·앞 줄의 FLOW(continue·break) 마다 '!(그 FLOW 만의 if 조건)' 을 cond 앞에 붙인다.
    #   한계: break 는 뒤 행까지 끝내지만 행 단위 cond 로는 '앞 행에서 break 됨'을 적을 수 없다(그 행 자신의 조건만). switch 안 break 는 루프 탈출 아님 → 제외
    def enclosing_loop(ln):
        """줄 ln 을 감싸는 가장 안쪽 for/foreach/while 블록의 머리 줄(못 찾거나 메서드 경계면 0)"""
        d = 0
        for i in range(min(ln, len(src_lines) + 1) - 1, max(0, ln - 800), -1):
            s_ = src_lines[i - 1]
            for j in range(len(s_) - 1, -1, -1):
                ch = s_[j]
                if ch == '}':
                    d += 1
                elif ch == '{':
                    if d:
                        d -= 1
                        continue
                    head, k = s_[:j].strip(), i
                    while not head and k > 1:
                        k -= 1
                        head = src_lines[k - 1].strip()
                    if re.match(r'^(?:\}\s*)?(?:for|foreach|while)\s*\(', head):
                        return k
                    if re.search(r'\)\s*$', head) and re.match(r'^(?:(?:public|private|protected|internal|static|override|virtual|async)\s+)+', head):
                        return 0
        return 0

    def flow_guards(key, x, ln0):
        """색 문장 x(줄 ln0)를 같은 루프 반복에서 건너뛰게 하는 앞선 continue·break 의 부정 조건 목록(정규형)"""
        lp = enclosing_loop(ln0)
        if not lp:
            return []
        out = []
        keep = R.line
        for f in acts:
            if f['class'] != x['class'] or f['method'] != x['method'] or f.get('kind') != 'FLOW':
                continue
            mfl = re.fullmatch(r'(continue|break)\s*;?', (f.get('target') or '').strip())
            fl = int(f['line'] or 0)
            if not mfl or not (lp < fl < ln0) or enclosing_loop(fl) != lp:
                continue
            gf, gx = f.get('guard') or '', x.get('guard') or ''
            if '…' in gf or '…' in gx:
                gf, gx = R.source_guard(key, fl), R.source_guard(key, ln0)
            sf = [g_.strip() for g_ in gf.split('▸') if g_.strip()]
            sc = [g_.strip() for g_ in gx.split('▸') if g_.strip()]
            k = 0
            while k < len(sf) and k < len(sc) and sf[k] == sc[k]:
                k += 1
            extra = sf[k:]
            if not extra or any(re.match(r'(?:for|foreach|while)\b', g_) for g_ in extra):
                continue  # 같은 블록의 무조건 FLOW(뒤 문장 도달 불가 · 원문 이상) 또는 안쪽 루프 FLOW — 대상 아님
            if mfl.group(1) == 'break' and any(re.match(r'(?:switch|case)\b', g_) for g_ in sf):
                continue  # switch 의 break
            R.line = fl
            g = R.guard(key, ' ▸ '.join(extra), '', line=fl)
            R.line = keep
            if g == 'FALSE':
                continue
            out.append('FALSE' if g in ('', 'TRUE') else f'!({g})')
        return out

    def with_flow(key, x, ln0, cond):
        fg = flow_guards(key, x, ln0)
        if not fg:
            return cond
        parts = fg + ([cond] if cond and cond != 'TRUE' else [])
        if 'FALSE' in parts:
            return 'FALSE'
        return ' && '.join(f'({p_})' if ' || ' in p_ and not (p_.startswith('!(') and Resolver._balanced(p_[2:-1]) and p_.endswith(')')) else p_ for p_ in parts)
    # 진입점 경로(actions_entries): EditButton 경로 메서드 = 기존행 규칙 · InsertButton 경로 메서드 = 신규행 규칙
    ents = read_csv(os.path.join(sdir, 'actions_entries.csv'))
    chain = lambda entry: {r['method'] for r in ents if r.get('entry') == entry and r.get('class') == main_cls} | {entry}
    edit_chain, insert_chain = chain('EditButton'), chain('InsertButton')
    insert_unlocks_row = any(x['method'] in insert_chain and x['class'] == main_cls and re.search(r'\.Insert\s*$', x['target'] or '') and x.get('kind') != 'CALL_LOCAL' for x in acts)
    # 2026-11-26 T682(DMF0082 InsertRow:2520 'this.Insert()' = 화면 자체 Insert(cs:9292)): 프레임워크 SpreadInfo.Insert 가 아니므로 신규행 해제를 그 본문으로 판단한다.
    #   본문에 분기 밖 '.Locked = false' 가 있어야 해제(DMF0082 는 :9403 주석 처리 · 해제는 'if (c == null)' 첫 행 분기 :9331 뿐 → 해제 안 함)
    _local_ins = [x for x in acts if x['method'] in insert_chain and x['class'] == main_cls and x.get('kind') == 'CALL_LOCAL' and re.fullmatch(r'(?:this\.)?Insert', (x['target'] or '').strip())]
    if _local_ins and not insert_unlocks_row:
        _decl = [i for i, l_ in enumerate(src_lines, 1) if re.match(r'^\s*public\s+[\w.]+\s+Insert\s*\(\s*\)\s*$', l_)]
        if _decl:
            _d, _st, _unl = 0, False, False
            for _i in range(_decl[0], min(_decl[0] + 200, len(src_lines) + 1)):
                _l = src_lines[_i - 1]
                _d += _l.count('{') - _l.count('}'); _st = _st or '{' in _l
                if re.search(r'\.Locked\s*=\s*false\s*;', _l):
                    _g = [s_ for s_ in R.source_guard((None, None), _i).split('▸') if re.match(r'\s*(if|else)', s_.strip())]
                    if not _g:
                        _unl = True
                if _st and _d <= 0:
                    break
            insert_unlocks_row = _unl
    has_insert_button = any(x['method'] == 'InsertButton' and x['class'] == main_cls for x in acts)  # 화면에 InsertButton 자체가 없으면 신규행 시나리오 없음(2026-10-31 SCP0041)
    # 2026-11-19 미검증 해소(SCP0028 D1 15행 '[잠금 해석 실패] InsertButton 경로에 siMain.Insert() 없음'): InsertButton 경로의 메서드가 호출만 있고
    #   실행 문장이 0(SCP0028 InsertButton → InsertRow() · InsertRow 본문 비어 있음 cs:571)이면 AS-IS 는 신규 행을 만들지 않는다 → 해석 실패가 아니라 신규행 시나리오 없음(NONE).
    #   기준 = tools/E2E/lib/newrow.ts asisInsertNoop 과 같은 규칙(CALL_LOCAL·RETURN·BRANCH·LOCAL 외 문장 0)
    _ins_body = [x for x in acts if x['method'] in insert_chain and x['class'] == main_cls and x.get('kind') not in ('CALL_LOCAL', 'RETURN', 'BRANCH', 'LOCAL')]
    insert_noop = has_insert_button and not _ins_body

    _dyn_rows = read_csv(os.path.join(sdir, 'dyn_columns.csv')) if os.path.exists(os.path.join(sdir, 'dyn_columns.csv')) else []

    def dyn_family_by_tag(key, var):
        """잠금 문장 앞 같은 메서드 안에 'GetColumnTag(var).IndexOf("P_") == 0' 가드가 있으면 접두 P_ 에 맞는 동적 패밀리 이름(없으면 '')"""
        pref = None; alias = set()
        for i, ln in R.method_lines(key):
            if R.line and i > R.line: break
            m = re.search(r'GetColumnTag\(\s*' + re.escape(var) + r'\s*\)\.IndexOf\(\s*"([A-Za-z]+_?)"\s*\)\s*==\s*0', ln)
            if m: pref = m.group(1)
            # 2026-11-11 T246: 태그를 지역 변수에 담아 검사하는 형태 — sColName = <ctl>.ActiveSheet.Columns[j].Tag… / GetColumnTag(j) … if (sColName.IndexOf("D_") == 0 | StartsWith("D_"))
            ma = re.search(r'\b(\w+)\s*=\s*[\w.]*(?:Columns\[\s*' + re.escape(var) + r'\s*\]\.Tag|GetColumnTag\(\s*' + re.escape(var) + r'\s*\))', ln)
            if ma: alias.add(ma.group(1))
            for al in alias:
                m2 = re.search(r'\b' + re.escape(al) + r'\.(?:IndexOf\(\s*"([A-Za-z]+_?)"\s*\)\s*==\s*0|StartsWith\(\s*"([A-Za-z]+_?)"\s*\))', ln)
                if m2: pref = m2.group(1) or m2.group(2)
        if not pref: return ''
        for d in _dyn_rows:
            try:
                if re.match(d.get('binding_regex') or '', pref + '202601'): return re.sub(r'^<DYNAMIC:|>$', '', d.get('family_id') or '')
            except re.error: continue
        return ''

    # 2026-11-26 T665(사용자 '루프 변수 잠금 786칸도 해석'): 칸 인자가 루프 변수·시작 변수(iCol·j·iStartCol·xCol1·intEndIdx2 …)라 RAW 로 남던 잠금 문장
    #   (DMF0003 EditButton:1067 'for (int iCol = siMain.GetColumnIndex(DefColumns.Measure) + 1; iCol <= siMain.GetMaxColumnIndex(); iCol++)' 안의 LockColumn(iCol, iCol, true) 등 66건)이
    #   UNRESOLVED 가 되어 화면 전체 기존행·신규행 기본값을 UNKNOWN 으로 만들었다(루프 밖 고정 칸까지). 원문 루프 머리·대입식으로 칸 위치를 푼다:
    #   GetColumnIndex(C)[±n] = 메타 순서 위치 · 숫자 상수 · GetMaxColumnIndex()/ColumnCount-1/Columns.Count-1 = 끝 · 변수 = 가장 가까운 앞선 for 머리(시작·끝) 또는 앞선 대입식
    #   끝이 끝(Max)이 아니거나 끝 변수를 못 풀면 범위는 시작~끝으로 넓히되 근사 표시(cond 에 RAW 원자 → 그 칸은 평가 불가 = 미검증, 허위 판정 없음)
    _dyn_fams = sorted({re.sub(r'^<DYNAMIC:|>$', '', d.get('family_id') or '') for d in _dyn_rows} - {''})
    RX_END = re.compile(r'.*(?:GetMaxColumnIndex\(\)|(?:ColumnCount|Columns\.Count)\s*-\s*1)')

    def str_defs(key, v, lines=False):
        """변수 v 의 대입식 — 잠금 줄에서 메서드 머리까지 거슬러(가장 가까운 것) · 없으면 클래스 전체 대입(값이 하나일 때만). lines=True 면 [(줄, 식)]"""
        rx_ = re.compile(r'(?:^|[;{(]|\s)(?:(?:int|string|var|String)\s+)?' + re.escape(v) + r'\s*=(?!=)\s*([^;]+);')
        ln0 = R.line or 0
        for i in range(min(ln0 - 1, len(src_lines)), max(0, ln0 - 400), -1):
            s_ = src_lines[i - 1]
            if i < ln0 and re.match(r'\s*(?:public|private|protected|internal)\b[^;=]*\)\s*\{?\s*$', s_):
                break
            m_ = rx_.search(s_)
            if m_:
                return [(i, m_.group(1).strip())] if lines else [m_.group(1).strip()]
        allv = [(i, m_.group(1).strip()) for i, s_ in enumerate(src_lines, 1) for m_ in [rx_.search(s_)] if m_ and m_.group(1).strip() not in ('""', '0', 'null')]
        if len({x_[1] for x_ in allv}) == 1:
            return allv[:1] if lines else [allv[0][1]]
        if not lines and allv:
            return [x_[1] for x_ in allv]
        return []

    def skip_cover(key, v, ln_, ex_):
        """2026-11-27 T686(DMF0003 EditButton:1334 'iStartCol = iResultCol2' · 바로 앞 :1308 'LockRange(iRow, iStartCol, iRow, iResultCol2, true)'):
        시작 변수 v 를 w 로 옮기는 대입(ln_ 줄) 앞, 같은 블록 30줄 안에서 옮기기 전 구간 [v, w] 를 이미 잠갔는가(true).
        참이면 그 뒤 v 부터 도는 잠금(Y) 문장의 결과는 옮기기 전 v 부터 돈 것과 같다"""
        w_ = (ex_ or '').strip()
        if not re.fullmatch(r'[A-Za-z_]\w*', w_):
            return False
        rx_ = re.compile(r'\.LockRange2?\(\s*\w+\s*,\s*' + re.escape(v) + r'\s*,\s*\w+\s*,\s*' + re.escape(w_) + r'\s*,\s*true\s*\)')
        prev_ = [t for i, t in R.method_lines(key) if ln_ - 30 <= i < ln_]
        hit_ = [k for k, t in enumerate(prev_) if rx_.search(t)]
        if not hit_:
            return False
        bal_ = 0
        for t in prev_[hit_[-1] + 1:]:  # 잠금 줄과 대입 줄이 같은 블록(사이 중괄호 균형 0, 중간에 음수로 내려가지 않음)
            bal_ += t.count('{') - t.count('}')
            if bal_ < 0:
                return False
        return bal_ == 0

    def var_lb(key, v, seen):
        """변수 v 의 칸 위치 하한 = 메서드 안 모든 대입식·for 머리 시작식의 최솟값(순환 참조는 건너뜀 — 루프 변수는 커지기만 한다).
        풀지 못하는 대입이 하나라도 있으면 None. 대입이 여럿이면 근사(True). DMF0003 iStartCol = Measure+1 · = iResultCol2(= iStartCol · = iCol)"""
        seen = seen | {v}
        defs_ = R.var_defs(key, v)
        exprs = [ex for _, ex in defs_]
        for _, ln in R.method_lines(key):
            mh = re.search(r'\bfor\s*\(\s*(?:int\s+)?' + re.escape(v) + r'\s*=\s*([^;]+);', ln)
            if mh:
                exprs.append(mh.group(1).strip())
        if not exprs:
            exprs = str_defs(key, v)
        leaves = []
        for ex in exprs:
            ex = ex.strip()
            if re.fullmatch(r'[A-Za-z_]\w*', ex):
                if ex in seen:
                    continue
                r_ = var_lb(key, ex, seen)
            else:
                r_ = loop_pos(key, ex, 3)
            if not r_ or r_[0] not in ('P', 'PLOOP'):
                return None
            leaves.append(r_[1] if r_[0] == 'P' else r_[1][0])
        if not leaves:
            return None
        approx_ = len(set(leaves)) > 1 or len(exprs) > 1
        # 2026-11-27 T686: 옮기는 대입마다 skip_cover 면 최솟값부터 돈 것과 같다(잠금 Y 문장만)
        if approx_ and getattr(R, 'cur_locked', '') == 'Y' and len(defs_) == len(exprs):
            mn_ = min(leaves)
            if all(lf_ == mn_ or skip_cover(key, v, ln_, ex_) for (ln_, ex_), lf_ in zip(defs_, leaves)):
                approx_ = False
        return ('P', min(leaves), approx_)

    def foreach_list_pos(key, v, depth):
        """2026-11-26 T681(DMF0082 SetLockRange:9261~9276 'foreach (int idx in list_Edit_Target_Idx)' · list_Edit_Target_Idx = list_EDIT_Month/Week/Day.ToList()):
        foreach 정수 변수 → 목록에 넣는(.Add(iCol)) 모든 곳의 for 시작 위치 최솟값부터 끝까지('PLOOP', 근사). 넣는 곳 하나라도 못 풀면 None"""
        hd_ = None
        for i, ln in R.method_lines(key):
            if R.line and i > R.line:
                break
            m_ = re.search(r'\bforeach\s*\(\s*(?:int|var)\s+' + re.escape(v) + r'\s+in\s+(\w+)\s*\)', ln)
            if m_:
                hd_ = m_.group(1)
        if not hd_:
            return None
        lists_, todo_ = set(), [hd_]
        while todo_:
            l_ = todo_.pop()
            if l_ in lists_ or len(lists_) > 8:
                continue
            lists_.add(l_)
            for _, ex in R.var_defs(key, l_) + [(0, m2_.group(1)) for s_ in src_lines for m2_ in [re.search(r'(?<![\w.])' + re.escape(l_) + r'\s*=(?!=)\s*([^;]+);', s_)] if m2_]:
                mt_ = re.fullmatch(r'(\w+)(?:\.ToList\(\))?', ex.strip())
                if mt_ and mt_.group(1) != l_:
                    todo_.append(mt_.group(1))
        starts = []
        keep = R.line
        for i, s_ in enumerate(src_lines, 1):
            ma_ = re.search(r'(?<![\w.])(' + '|'.join(map(re.escape, lists_)) + r')\.Add\(\s*(\w+)\s*\)', s_)
            if not ma_:
                continue
            iv_ = ma_.group(2)
            hdr_ = None
            for k in range(i - 1, max(0, i - 120), -1):
                mh_ = re.search(r'\bfor\s*\(\s*(?:int\s+)?' + re.escape(iv_) + r'\s*=\s*([^;]+);', src_lines[k - 1])
                if mh_:
                    hdr_ = mh_.group(1); break
            if not hdr_:
                return None
            R.line = i
            st_ = loop_pos(key, hdr_, depth + 1)
            R.line = keep
            if not st_ or st_[0] != 'P':
                return None
            starts.append(st_[1])
        if not starts:
            return None
        return ('PLOOP', (min(starts), True), True)

    def loop_pos(key, expr, depth=0):
        """칸 위치 식 → ('P', 메타 순서 위치, 근사) · ('PLAST', None, 근사) · ('PLOOP', (시작 위치, 끝까지 도는가), 근사) · None(못 풂)"""
        e = (expr or '').strip()
        while e.startswith('(') and e.endswith(')') and Resolver._balanced(e[1:-1]):
            e = e[1:-1].strip()
        if RX_END.fullmatch(e):
            return ('PLAST', None, False)
        # 행 상태 칸(메타 칸 앞 0번 · SpreadInfo AddActionTextBox) — DMF0082 EditButton:1568 xCol1 = sv.Columns[CAppSetting.StringAction].Index
        if re.fullmatch(r'[\w.]+\.Columns\[\s*CAppSetting\.StringAction\s*\]\.Index|[\w.]+\.GetColumnFromTag\(\s*null\s*,\s*CAppSetting\.StringAction\s*\)\.Index', e):
            return ('P', -1, False)
        m = re.fullmatch(r'(.+?)\s*([+-])\s*(\d+)', e)
        if m:
            b = loop_pos(key, m.group(1), depth + 1)
            n = int(m.group(3)) * (1 if m.group(2) == '+' else -1)
            if not b:
                return None
            if b[0] == 'P':
                return ('P', b[1] + n, b[2])
            if b[0] == 'PLOOP':
                return ('PLOOP', (b[1][0] + n, b[1][1] and n >= 0), b[2])
            return ('PLAST', None, True)  # 끝 ± n — 끝 근처(근사)
        mg = re.fullmatch(r'\w+\.GetColumnIndex\((.*)\)', e)
        if mg and re.fullmatch(r'[A-Za-z_]\w*', mg.group(1).strip()) and not mg.group(1).strip().startswith('Def'):
            sv_ = str_defs(key, mg.group(1).strip())
            if sv_ and all(re.match(r'"[A-Za-z_]*[A-Za-z]_"\s*\+', s_) for s_ in sv_):
                return ('P', len(order), False)  # 접두 문자열로 만든 칸 이름(DMF0082 this_YYYYMM = "M_" + …) = 기간 동적 칸
            if sv_ and len(set(sv_)) == 1 and re.fullmatch(r'"[A-Za-z0-9_]+"', sv_[0]):
                c0_ = sv_[0].strip('"').upper()
                return ('P', order.index(c0_), False) if c0_ in order else ('P', len(order), False)
            if not sv_ and not R.var_defs(key, mg.group(1).strip()):
                # T680: 칸 이름이 속성(SCP0104 _fixed_column_name = isPageSOP ? ELTR_LN_TP_CD : DUMMY_YN) — 호출 경로로 고른 반환식.
                #   칸 번호를 구한 시트 컨트롤이 잠그는 컨트롤과 다르면(SetLockColumnsAllSOP:4048 _siSop 잠금에 _siAssign 칸 번호) 위치를 옮길 근거가 없어 풀지 않음
                pk_ = R.member_pick(key, mg.group(1).strip())
                ctl_ = e.split('.GetColumnIndex')[0].split('.')[-1]
                if not pk_ or (R.control and ctl_ != R.control):
                    return None
                md2_ = re.fullmatch(r'Def\w*\.\w+', pk_)
                if not md2_:
                    return None
                c_ = R.defcol(pk_).upper()
                return ('P', order.index(c_), False) if c_ in order else ('P', len(order), False)
        if mg:
            md_ = re.fullmatch(r'Def\w*\.(\w+)', mg.group(1).strip())  # 원문 식은 대소문자 섞인 상수 이름(DefColumns.Measure)이 남아 있다 — 상수 값으로
            ca = ('COL', R.defcol(md_.group(0)).upper()) if md_ and re.fullmatch(r'[A-Za-z0-9_]+', R.defcol(md_.group(0))) else R.col_arg(key, mg.group(1))  # T676: 구조체 이름까지
            if ca[0] != 'COL':
                return None
            c_ = ca[1] if ca[1] in order else ca[1].upper()
            # 기준 칸이 이 칸 순서(시트)에 없음 = 다른 시트 컨트롤의 칸(SSP0021 siMain MEASURE ↔ 메인 시트 Shipment Plan Detail) — 이 시트 정적 칸에는 해당 없음
            return ('P', order.index(c_), False) if c_ in order else ('P', len(order), False)
        if re.fullmatch(r'\d+', e):
            return ('P', int(e), False)
        if re.fullmatch(r'[A-Za-z_]\w*', e) and depth < 4:
            best = None
            for i, ln in R.method_lines(key):
                if R.line and i > R.line:
                    break
                mh = re.search(r'\bfor\s*\(\s*(?:int\s+)?' + re.escape(e) + r'\s*=\s*([^;]+);\s*' + re.escape(e) + r'\s*(<=|<)\s*([^;]+);', ln)
                if mh:
                    best = mh
            if best:
                st = loop_pos(key, best.group(1), depth + 1)
                if (not st or st[0] != 'P') and re.fullmatch(r'[A-Za-z_]\w*', best.group(1).strip()):
                    st = var_lb(key, best.group(1).strip(), {e})  # 시작 변수의 대입이 여럿(DMF0003 :1336 iStartCol) — 하한
                if not st or st[0] != 'P':
                    return None
                end = best.group(3).strip()
                last_ok = (best.group(2) == '<=' and bool(RX_END.fullmatch(end))) or (best.group(2) == '<' and bool(re.fullmatch(r'.*(?:ColumnCount|Columns\.Count)', end)))
                return ('PLOOP', (st[1], last_ok), st[2])
            fe_ = foreach_list_pos(key, e, depth)
            if fe_:
                return fe_
            defs = R.var_defs(key, e)
            before = [d for d in defs if d[0] < R.line] if R.line else defs
            if not before:
                before = str_defs(key, e, lines=True)  # 사실 범위 앞의 대입(SCP0104 :3965) · 클래스 필드 대입
            if not before:
                pk_ = R.member_pick(key, e)  # T680: 칸 번호 속성(SCP0104 _fixed_column_idx { get { res = _siAssign.GetColumnIndex(_fixed_column_name); } })
                if pk_:
                    return loop_pos(key, pk_, depth + 1)
            if before and getattr(R, 'cur_locked', '') == 'Y':  # T686: 잠금 구간을 건너뛰려 옮긴 대입은 빼고 그 앞 대입으로
                while len(before) > 1 and skip_cover(key, e, before[-1][0], before[-1][1]):
                    before = before[:-1]
            if before:
                b = loop_pos(key, before[-1][1], depth + 1)
                if b and len({x_[1] for x_ in before}) > 1:
                    b = (b[0], b[1], True)  # 앞선 대입이 여럿(분기마다 다름) — 마지막 것으로 근사
                if not b and depth < 3:
                    b = var_lb(key, e, set())
                return b
        return None

    def foreach_cols(key, cols_arg):
        """2026-11-26 T681(DMF0082 InsertRow:2751 'foreach (string sColName in arrEditColList) LockRange2(r, GetColumnIndex(sColName), r2, GetColumnIndex(sColName), false, …)'):
        칸 인자 양 끝이 같은 foreach 변수의 GetColumnIndex 이고, 그 목록이 Def 칸 상수만으로 만든 문자열 Split(',') · 배열 초기화면 그 칸 목록. 아니면 None"""
        if len(cols_arg) != 2 or cols_arg[0].replace(' ', '') != cols_arg[1].replace(' ', ''):
            return None
        mv_ = re.fullmatch(r'[\w.]+\.GetColumnIndex\(\s*([A-Za-z_]\w*)\s*\)', cols_arg[0].strip())
        if not mv_:
            return None
        v_ = mv_.group(1)
        arr_ = None
        for i, ln in R.method_lines(key):
            if R.line and i > R.line:
                break
            mf_ = re.search(r'\bforeach\s*\(\s*(?:string|var)\s+' + re.escape(v_) + r'\s+in\s+(\w+)\s*\)', ln)
            if mf_:
                arr_ = (i, mf_.group(1))
        if not arr_:
            return None

        def text_of(name, upto, depth=0):
            """변수 name 의 문자열 식(여러 줄 '+' 이어 쓰기 포함, 앞쪽 마지막 대입)"""
            if depth > 2:
                return None
            hit = None
            for i, ln in R.method_lines(key):
                if i >= upto:
                    break
                if re.search(r'(?:^|[\s;{])(?:(?:string|var|String)(?:\[\])?\s+)?' + re.escape(name) + r'\s*=(?!=)', ln):
                    hit = i
            if not hit:
                return None
            t_ = ''
            for k in range(hit, min(hit + 15, upto)):
                t_ += ' ' + R.lines[k - 1].strip()
                if t_.rstrip().endswith(';'):
                    break
            m_ = re.search(re.escape(name) + r'\s*=(?!=)\s*(.+);\s*$', t_)
            return m_.group(1).strip() if m_ else None
        ex_ = text_of(arr_[1], arr_[0])
        if not ex_:
            return None
        ms_ = re.fullmatch(r'(\w+)\.Split\(\s*\'(.)\'\s*\)', ex_)
        if ms_:
            body_ = text_of(ms_.group(1), arr_[0])
            if not body_:
                return None
            parts_ = re.findall(r'\$"([^"]*)"', body_)
            if not parts_ or re.sub(r'\$"[^"]*"|\+|\s', '', body_):
                return None  # 보간 문자열 이어 붙이기 말고 다른 식이 섞임
            items_ = ''.join(parts_).split(ms_.group(2))
        else:
            mb_ = re.fullmatch(r'new\s+string\s*\[\s*\]\s*\{(.*)\}', ex_)
            if not mb_:
                return None
            items_ = [x_.strip() for x_ in mb_.group(1).split(',') if x_.strip()]
        out = []
        for it in items_:
            it = it.strip()
            mi_ = re.fullmatch(r'\{\s*(Def\w*\.\w+)\s*\}|(Def\w*\.\w+)', it)
            if not mi_:
                return None
            c_ = R.defcol(mi_.group(1) or mi_.group(2)).upper()
            if c_ in order:  # 이 시트 칸 순서에 없는 이름(다른 시트 칸)은 뺀다
                out.append(c_)
        return out or None

    def expand(key, arg_text, self_hint='', api_hint=''):
        if api_hint == 'SetLockAllRows':  # T665: SheetUtils.SetLockAllRows(si, true) — 시트 전 행·전 칸(SCP0104 SetLockColumnsAllAssign:4009 · SetLockColumnsAllSOP:4042)
            return list(order), 'ALL'
        """LockColumn/LockRange 의 컬럼 인자 → (컬럼 목록, 전개 방식). 동적 패밀리는 '<DYNAMIC:Family>'"""
        inner = arg_text.strip()
        if inner.startswith('(') and inner.endswith(')'):
            inner = inner[1:-1]
        args = Resolver._split(inner, ',')
        args = [x.strip() for x in args]
        # 2026-11-11 T244: 컬럼 인자 위치 = 프레임워크 오버로드 서명(lock_sig). 서명에 없는 인자 수만 종전 추정(마지막 = 잠금 여부)으로
        sg = lock_sig(api_hint, len(args))
        if sg:
            cols_arg = [args[i] for i in sg[0]]
        else:
            cols_arg = args[:-1]
            if len(cols_arg) == 4:
                cols_arg = [cols_arg[1], cols_arg[3]]
            elif len(cols_arg) == 3:
                cols_arg = [cols_arg[1], cols_arg[2]]
        fl_ = foreach_cols(key, cols_arg)
        if fl_:
            return fl_, 'LIST'
        ends = []
        for x in cols_arg:
            x0_ = x
            # 루프 변수 + 'GetColumnTag(x).IndexOf("M_") == 0' 가드 → 태그 접두에 맞는 동적 패밀리(2026-10-31 SCP0096 SetLockSumColumn:408 LockColumn(iCol))
            if re.fullmatch(r'\w+', x) and not re.fullmatch(r'\d+', x):
                fam_ = dyn_family_by_tag(key, x)
                if fam_:
                    ends.append(('DYN', fam_)); continue
            # 지역 변수면 잠금 문장 앞의 마지막 대입식으로 치환(iColStart = 0 · iColEnd = siMain.ActiveSheet.ColumnCount - 1 — 2026-10-31 SCP0041 EditButton:281 전 시트 LockRange)
            if re.fullmatch(r'\w+', x) and not re.fullmatch(r'\d+', x):
                defs = R.var_defs(key, x); before = [d for d in defs if d[0] < R.line] if R.line else []
                src = (before[-1:] or defs[-1:])
                if src and re.fullmatch(r'0|\w+\.ActiveSheet\.ColumnCount\s*-\s*1|\w+\.ColumnCount\s*-\s*1|\w+\.GetMaxColumnIndex\(\)', src[0][1].strip()):
                    x = src[0][1].strip()
            if re.fullmatch(r'0', x):
                ends.append(('FIRST', '')); continue
            if re.fullmatch(r'\d+', x) and int(x) < len(order):  # 2026-11-11 T245: 열 번호 상수(LockRange(i, 1, i, Max, …) — SSP0200 EditButton:819) = 메타 순서의 그 위치 컬럼
                ends.append(('COL', order[int(x)])); continue
            if re.search(r'ColumnCount\s*-\s*1|GetMaxColumnIndex\(\)', x):
                ends.append(('LAST', '')); continue
            mg = re.search(r'GetColumnIndex\((.*)\)\s*$', x)
            ca_ = R.col_arg(key, mg.group(1) if mg else x)
            if re.fullmatch(r'[A-Za-z_]\w*', x0_) and ca_[0] == 'COL':  # T665: 변수 = 'GetColumnIndex(C) + 1' 대입이면 +1 까지(종전 해석은 C 로 읽음 · DMF0003 iStartCol)
                lp0_ = loop_pos(key, x0_)
                if lp0_ and lp0_[0] in ('P', 'PLOOP'):
                    ends.append(lp0_); continue
            # T682(DMF0082 SetLockRange:9253 'GetColumnIndex(DefColumns.MEASURE) + 1'): 식이 '… + 1' 로 끝나면 위 mg 가 안 걸려(끝이 ')' 아님) MEASURE 로 읽었다 — ± 검사는 식 전체로
            #   칸 이름이 이 시트 칸 순서에 없으면(SSP0015 EditButton:1963 siDetail AVAILABLE_YN) 위치 계산 근거가 없어 종전(칸 이름 끝점) 해석을 유지
            if ca_[0] == 'RAW' or (re.search(r'GetColumnIndex\(.*\)\s*[+-]\s*\d+\s*$', x) and not (ca_[0] == 'COL' and ca_[1] not in order and ca_[1].upper() not in order)):  # T665: 못 푼 칸 인자 · 'GetColumnIndex(C) + 1' 처럼 ± 가 붙은 식
                lp_ = loop_pos(key, x0_)
                if lp_:
                    ends.append(lp_); continue
            ends.append(ca_)
        if not ends:
            return [], 'UNRESOLVED'
        if len(ends) == 1:
            ends = ends * 2
        if any(len(e_) == 3 for e_ in (ends[0], ends[-1])):  # T665 루프·위치 해석
            def _st(e_):
                k_ = e_[0]
                return e_[1] if k_ == 'P' else e_[1][0] if k_ == 'PLOOP' else 0 if k_ == 'FIRST' else (order.index(e_[1]) if k_ == 'COL' and e_[1] in order else order.index(e_[1].upper()) if k_ == 'COL' and e_[1].upper() in order else None)
            def _en(e_):
                k_ = e_[0]
                return e_[1] if k_ == 'P' else ('LAST' if e_[1][1] else 'LAST~') if k_ == 'PLOOP' else 'LAST' if k_ in ('PLAST', 'LAST') else (order.index(e_[1]) if k_ == 'COL' and e_[1] in order else 0 if k_ == 'FIRST' else 'LAST~')
            si_, ei_ = _st(ends[0]), _en(ends[-1])
            if si_ is None or si_ < 0:
                return [], 'UNRESOLVED'
            approx_ = any(len(e_) == 3 and e_[2] for e_ in (ends[0], ends[-1])) or ei_ == 'LAST~'
            if isinstance(ei_, int) and si_ >= len(order):
                cs_ = [f'<DYNAMIC:{f_}>' for f_ in _dyn_fams] or ['<DYNAMIC:LOOP>']  # 정적 칸 뒤 = 동적 칸
            elif isinstance(ei_, int):
                cs_ = order[si_:ei_ + 1]
            else:
                cs_ = order[si_:] + [f'<DYNAMIC:{f_}>' for f_ in _dyn_fams]
                if not cs_:  # 시작이 정적 칸 끝 뒤(DMF0003 Measure+1 = 기간 동적 칸만) · 동적 칸 사실(dyn_columns.csv) 없음 — 정적 칸에는 해당 없음
                    cs_ = ['<DYNAMIC:LOOP>']
            if not cs_:
                return [], 'UNRESOLVED'
            return cs_, 'LOOP~' if approx_ else 'LOOP'
        (k1, v1), (k2, v2) = ends[0], ends[-1]
        if k1 == 'DYN' or k2 == 'DYN':
            if k1 == k2 == 'DYN' or (k1 == 'DYN' and k2 == 'DYN'):
                return [f'<DYNAMIC:{v1}>'], 'DYNAMIC'
            if k1 == 'DYN': return [f'<DYNAMIC:{v1}>'], 'DYNAMIC'
            return [f'<DYNAMIC:{v2}>'], 'DYNAMIC'
        if k1 == 'FIRST' and k2 == 'LAST':
            return list(order), 'ALL'
        if 'RAW' in (k1, k2):
            return [], 'UNRESOLVED'
        s = order[0] if k1 == 'FIRST' else v1
        e = order[-1] if k2 == 'LAST' else v2
        if s in order and e in order:
            i, j = order.index(s), order.index(e)
            return order[i:j + 1], 'RANGE' if i != j else 'ONE'
        return sorted({v for k, v in (ends[0], ends[-1]) if k == 'COL'}), 'ENDPOINTS'

    # 2026-11-26 T685: 조회 결과 존재 가드(ds.Tables[n].Rows.Count > 0 · ds.Tables[n] != null)가 그 표를 그리드에 바인딩한 블록의 잠금을 감싸면
    #   기존 행이 있는 상황(편집 기대를 재는 상황)에서는 참이다 → TRUE 로 접는다. 바인딩 = 같은 메서드·같은 컨트롤의 앞선 GRID_BIND 로
    #   ① 같은 가드 안(가드 끝 마디가 그 표를 검사 · SSP0015 FindData_WHstock:3892 siDetail.Query(dsDetail) · dsDetail = ds.Tables[1].Copy()) 또는
    #   ② 바깥 가드에서 그 데이터셋(0번 표) · 그 표를 직접 바인딩(SCP0041 FindData_Main:678 siMain.Query(ds) 뒤 :682 'if (ds.Tables[0].Rows.Count > 0)')
    _RX_DX = re.compile(r'RAW\(\s*(\w+)\.Tables\[(\d+)\](?:\.Rows\.Count\s*>\s*0|\s*!=\s*null)\s*\)')

    def data_exists_fix(x, ctl, cond):
        if not cond or 'RAW(' not in cond:
            return cond
        ln_ = int(x['line'] or 0); lg = (x.get('guard') or '').strip()
        binds = [b for b in acts if b['kind'] == 'GRID_BIND' and b['method'] == x['method'] and b['class'] == x['class'] and (b['target'] or '').split('.')[0] == ctl and int(b['line'] or 0) < ln_]

        def ok(ds, n):
            for b in binds:
                bg = (b.get('guard') or '').strip(); bv = (b.get('value') or '').strip()
                if bg == lg and lg and re.search(re.escape(ds) + r'\.Tables\[' + n + r'\]', lg.split(' ▸ ')[-1]):
                    return True
                if bg == '' or lg == bg or lg.startswith(bg + ' ▸ '):
                    if (n == '0' and re.fullmatch(r'\(\s*' + re.escape(ds) + r'\s*\)', bv)) or re.match(r'\(\s*' + re.escape(ds) + r'\.Tables\[' + n + r'\]', bv):
                        return True
            return False
        new = _RX_DX.sub(lambda mm: 'TRUE' if ok(mm.group(1), mm.group(2)) else mm.group(0), cond)
        if new == cond:
            return cond
        return spec_sheet(new, None)

    locks = []
    lock_src = {}
    for x in sorted((x for x in acts if x['kind'] == 'GRID_LOCK' and x['class'] == main_cls), key=lambda x: int(x['line'] or 0)):
        tgt, val, m = x['target'], x['value'], x['method']
        key = (x['class'], m)
        ctl = tgt.split('.')[0]
        # 2026-11-26 T683: 정적 도구 클래스 호출(SheetUtils.SetLockAllRows(_siSop, true))의 컨트롤 = 첫 인자. 종전엔 'SheetUtils' 가 컨트롤이 되어 시트별 기대에서 빠졌다
        if re.fullmatch(r'\w*Utils?', ctl):
            _a0 = re.match(r'\s*\(\s*(?:this\.)?(\w+)\s*,', val or '')
            if _a0:
                ctl = _a0.group(1)
        if tgt.endswith('SwitchLock'):
            locks.append({'method': m, 'line': x['line'], 'api': 'SwitchLock', 'scope': 'MODE', 'locked': 'TOGGLE', 'lock_expr': '', 'columns': '', 'expand': '', 'cond': '', 'guard': x['guard'], 'control': ctl, 'raw': tgt + val})
            continue
        # 2026-11-26 T684: SetLockFlag(시트명, bool) 은 시트별 잠금 플래그(ht)만 바꾸고 칸 Locked 는 바꾸지 않는다(SpreadInfo.cs:9809~9823 · 플래그는 IsLock() 으로 머리글 체크박스·편집 진입 검사에만 쓰임 BaseForm.cs:2769·2868).
        #   종전엔 칸 범위를 못 정한 잠금 문장(UNRESOLVED)으로 들어가 DMF0082 기존 행 45칸을 UNKNOWN 으로 만들었다 → 칸 잠금 문장에서 뺀다(FLAG)
        if tgt.endswith('SetLockFlag'):
            locks.append({'method': m, 'line': x['line'], 'api': 'SetLockFlag', 'scope': 'MODE', 'locked': 'FLAG', 'lock_expr': '', 'columns': '', 'expand': 'FLAG', 'cond': '', 'guard': x['guard'], 'control': ctl, 'raw': tgt + val})
            continue
        if val.rstrip().endswith('…') and src_lines:
            # 2026-11-11 T245: 문장 사실의 값 칸이 길이 제한으로 잘린 경우(…) — 원문에서 그 줄부터 괄호가 닫힐 때까지 다시 읽는다(SSP0060 InsertRow:2553 '…, tr…')
            ln0 = int(x['line'] or 0)
            chunk = ' '.join(s_.strip() for s_ in src_lines[max(ln0 - 1, 0):ln0 + 6])
            i0 = chunk.find(tgt.split('.')[-1] + '(')
            if i0 >= 0:
                j0 = i0 + len(tgt.split('.')[-1]); depth = 0
                for k0 in range(j0, len(chunk)):
                    if chunk[k0] == '(':
                        depth += 1
                    elif chunk[k0] == ')':
                        depth -= 1
                        if depth == 0:
                            val = chunk[j0:k0 + 1]
                            break
        _args = [a_.strip() for a_ in Resolver._split(val.strip()[1:-1] if val.strip().startswith('(') else val, ',')] if val.strip() else []
        _sg = lock_sig(tgt.split('.')[-1], len(_args))
        last = (_args[_sg[1]] if _sg else (_args[-1] if _args else ''))  # 잠금 여부 인자 — 서명 위치(6·7인자의 마지막은 색·배경 플래그다)
        R.control = ctl; R.line = int(x['line'] or 0)
        lock_expr = ''
        if last in ('true', 'false'):
            locked = 'Y' if last == 'true' else 'N'
        else:
            neg = last.startswith('!'); vn = last.lstrip('!').strip()
            cond_true = R.bool_var(key, vn, int(x['line'] or 0)) if re.fullmatch(r'\w+', vn) else None
            if cond_true is None:
                locked = 'EXPR'; lock_expr = f'RAW({last})'; R.unresolved.append(last)
            else:
                locked = 'EXPR'; lock_expr = (f'!({cond_true})' if neg else cond_true) if cond_true not in ('TRUE', 'FALSE') else ({'TRUE': 'N' if neg else 'Y', 'FALSE': 'Y' if neg else 'N'}[cond_true])
                if lock_expr in ('Y', 'N'):
                    locked, lock_expr = lock_expr, ''
        R.cur_locked = locked  # T686: 잠금(Y) 문장만 시작 칸 이동 근사를 풀 수 있다
        cols, how = expand(key, val, api_hint=tgt.split('.')[-1])
        if tgt.endswith('LockColumn'):
            scope = 'ALL_ROWS'
        else:
            row_arg = val.strip().lstrip('(').split(',')[0].strip()
            scope = 'NEW_ROW' if m in insert_chain or row_arg == 'insCell' else 'ROW_COND'
        self_col = cols[0] if how == 'DYNAMIC' else ''
        cond = R.guard(key, x['guard'], self_col, line=int(x['line'] or 0))
        cond = lookup_fix(key, cond, int(x['line'] or 0))
        cond = data_exists_fix(x, ctl, cond)
        if how == 'LOOP~':  # T665 칸 범위 근사 — 이 규칙은 평가 불가(미검증)로 남긴다
            cond = (cond + ' && ' if cond and cond != 'TRUE' else '') + 'RAW(루프 칸 범위 근사)'
        locks.append({'method': m, 'line': x['line'], 'api': tgt.split('.')[-1], 'scope': scope, 'locked': locked, 'lock_expr': lock_expr, 'columns': ';'.join(cols), 'expand': how,
                      'cond': cond, 'guard': x['guard'], 'control': ctl, 'raw': tgt + val})
        lock_src[(m, x['line'], tgt + val)] = (key, val, tgt.split('.')[-1])  # T658: 시트별 칸 범위 재전개용

    # 2026-11-26 T683: 칸을 못 정한 잠금(Y) 문장이라도 같은 메서드에서 바로 앞에 같은 컨트롤 전 칸 잠금(Y)이 있고 그 사이에 다른 잠금·호출 문장이 없으면
    #   어느 칸을 가리키든 이미 잠긴 칸을 다시 잠그는 문장이다 → 결과 무변화(NOOP)로 보고 미해석 문장에서 뺀다
    #   (SCP0104 SetLockColumnsAllSOP:4042 SetLockAllRows(_siSop, true) 뒤 :4048 _siSop.LockRange2(0, _fixed_column_idx, …, true) · _fixed_column_idx 는 _siAssign 칸 번호)
    _gs = lambda g_: (g_ or '').strip()
    for l in locks:
        if l['expand'] not in ('UNRESOLVED', '') or l['locked'] != 'Y' or l['api'] == 'SwitchLock':
            continue
        ln_ = int(l['line'] or 0)
        prev = [p for p in locks if p['method'] == l['method'] and p['control'] == l['control'] and int(p['line'] or 0) < ln_]
        if not prev:
            continue
        p = max(prev, key=lambda p: int(p['line'] or 0))
        if not (p['expand'] == 'ALL' and p['locked'] == 'Y' and (p.get('cond') or '') in ('', 'TRUE')):
            continue
        pg, lg = _gs(p['guard']), _gs(l['guard'])
        if not (pg == '' or lg == pg or lg.startswith(pg + ' ▸ ')):
            continue
        pl = int(p['line'] or 0)
        if any(a['method'] == l['method'] and a['class'] == main_cls and pl < int(a['line'] or 0) < ln_ and a['kind'] not in ('BRANCH', 'EXPR', 'UI_MISC', 'VAR') for a in acts):
            continue
        l['expand'] = 'NOOP'; l['columns'] = ''
        l['cond'] = (l['cond'] + ' · ' if l['cond'] else '') + f"NOOP({p['method']}:{p['line']} 전 칸 잠금 직후 재잠금)"

    base = os.path.basename((acts[0]['file'] if acts else '')).replace('.cs', '')
    # 2026-11-09 T176: 근거 파일명 = 그 잠금 문장(메서드·줄)의 실제 파일 — 종전엔 첫 동작 행의 파일(팝업)을 일괄로 써서 본 화면 EditButton:223 이 'ItembyDivisionPopup:223' 으로 표기됐다
    _fof = {(a.get('method'), str(a.get('line'))): os.path.basename(a.get('file') or '').replace('.cs', '') for a in acts}
    fbase = lambda l: _fof.get((l.get('method'), str(l.get('line'))), base)
    out1 = os.path.join(sdir, 'lock_rules.csv')
    with open(out1, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=LOCK_COLS)
        w.writeheader()
        w.writerows(locks)

    def rules_of(lk):
        """잠금 문장 1건 → 규칙 목록 [{g, lock(Y/N), ref}] (잠금 인자가 조건식이면 2규칙)"""
        ref = f"{lk['method']}:{lk['line']}"
        g = lk['cond']
        if g == 'FALSE':
            return []
        if lk['locked'] in ('Y', 'N'):
            return [{'g': g, 'lock': lk['locked'], 'ref': ref}]
        le = lk['lock_expr']
        j = lambda a, b: a if not b else b if not a else f'{a} && ({b})'
        return [{'g': j(g, le), 'lock': 'Y', 'ref': ref}, {'g': j(g, f'!({le})'), 'lock': 'N', 'ref': ref}]

    def build_exp(locks, ins=None):
        """잠금 문장 집합 → 컬럼별 기대(통합 또는 스프레드 컨트롤별). ins = (신규행 기대, 사유) — 시트별 기대에서 Insert 대상 컨트롤이 아닌 시트(T658)"""
        edit_locks = [l for l in locks if l['method'] in edit_chain and l['api'] not in ('SwitchLock', 'SetLockFlag')]
        new_locks = [l for l in locks if l['scope'] == 'NEW_ROW']
        edit_unlocks_all = any(l['method'] in edit_chain and l['api'] == 'SwitchLock' for l in locks)
        unres_edit = [l for l in edit_locks if l['expand'] in ('UNRESOLVED', '')]
        unres_new = [l for l in new_locks if l['expand'] in ('UNRESOLVED', '')]
        search_locks_all = any(l['scope'] == 'ALL_ROWS' and l['expand'] == 'ALL' and l['locked'] == 'Y' and l['method'] not in edit_chain for l in locks)
        no_edit_button = not any(l['method'] in edit_chain for l in locks)
        # 편집 버튼(SwitchLock) 모델이 아니고 조회 후 전체 잠금도 없으면 프레임워크 기본(해제) — 명시 LockColumn 규칙만 적용(2026-10-31 SCP0096 UNKNOWN 12)
        d_exist = 'Y' if edit_unlocks_all and not unres_edit else ('N' if no_edit_button and search_locks_all else 'Y' if not unres_edit and not search_locks_all else 'UNKNOWN')
        # 2026-11-26 T664(SSP0015 siMain 'EditButton SwitchLock 없음' UNKNOWN 70칸 · 전 화면 254칸): 편집 모드 경로에 조건 없는 전 칸 잠금(EditButton:1788 LockRange2(0, 0, RowCount-1, ColCount-1, true))이
        #   있으면 편집 모드의 기본 상태는 잠금이다 → 기존행 기본 N, 뒤따르는 해제(WH_IN 행 등)는 칸별 규칙(COND)으로 계산. 해석 못 한 편집 잠금 문장이 있으면 종전대로 UNKNOWN
        edit_lock_all = any(l['expand'] == 'ALL' and l['locked'] == 'Y' and not (l.get('cond') or '').strip() for l in edit_locks)
        if d_exist == 'UNKNOWN' and not edit_unlocks_all and edit_lock_all and not unres_edit:
            d_exist = 'N'
        # T665: 조회 뒤 전 칸 잠금(search_locks_all)이 있고 편집 모드 경로에 모드 전환(SwitchLock·SetLockFlag)이 없으면 편집 모드에서도 잠긴 채 — 해제 문장만 칸별 규칙(SSP0021 siMain EditButton:2399)
        search_lock_kept = d_exist == 'UNKNOWN' and not edit_unlocks_all and search_locks_all and not unres_edit and not any(l['method'] in edit_chain and l['api'] == 'SwitchLock' for l in locks)  # T684: SetLockFlag 은 칸 잠금을 바꾸지 않아 조회 뒤 잠금이 그대로 남는다
        if search_lock_kept:
            d_exist = 'N'
        d_new = 'Y' if insert_unlocks_row and not unres_new else ('NONE' if not has_insert_button or insert_noop else 'UNKNOWN')
        why_exist = ('EditButton SwitchLock 없음 · 조회 후 전체 잠금 없음 → 기본 편집 가능(명시 잠금 규칙만)' if d_exist == 'Y' and not edit_unlocks_all else '') if d_exist == 'Y' else ((('편집 모드 경로의 조건 없는 전 칸 잠금 → 기본 잠금(해제는 칸별 규칙) · ' + ' · '.join(f"{l['method']}:{l['line']}" for l in edit_locks if l['expand'] == 'ALL' and l['locked'] == 'Y' and not (l.get('cond') or '').strip())[:80]) if edit_lock_all and not no_edit_button else '조회 후 전체 잠금 · 편집 모드 전환(SwitchLock) 없음 → 기본 잠금(해제는 칸별 규칙)' if search_lock_kept else '조회 후 전체 잠금 · EditButton 없음(조회 전용 화면)') if d_exist == 'N' else 'EditButton SwitchLock 없음(편집 모드 모델 아님)' if not edit_unlocks_all else '해석 못 한 잠금: ' + ' · '.join(f"{l['method']}:{l['line']} {l['raw'][:60]}" for l in unres_edit[:3]))
        why_new = '' if d_new == 'Y' else ('AS-IS InsertButton 없음(신규행 시나리오 없음)' if not has_insert_button else f"AS-IS InsertButton 경로({','.join(sorted(insert_chain))}) 실행 문장 0(신규행 시나리오 없음)") if d_new == 'NONE' else (('화면 자체 Insert() 가 신규 행을 풀지 않음(분기 밖 Locked = false 없음) · 신규 행 기본 잠금 상태 미확인' if _local_ins else 'InsertButton 경로에 siMain.Insert() 없음') if not insert_unlocks_row else '해석 못 한 잠금: ' + ' · '.join(f"{l['method']}:{l['line']} {l['raw'][:60]}" for l in unres_new[:3]))
        if ins:
            d_new, why_new = ins
        exp = {}

        def ent(c):
            return exp.setdefault(c, {'column': c, 'new_row': d_new, 'existing_row': d_exist, 'new_row_cond': why_new, 'existing_cond': why_exist, 'new_rules': [], 'existing_rules': [], 'ref': ''})
        for c in order:
            ent(c)
        for l in edit_locks:
            for c in [c for c in l['columns'].split(';') if c]:
                e = ent(c); e['existing_rules'] += rules_of(l); e['ref'] = (e['ref'] + ' | ' if e['ref'] else '') + f"기존행 {fbase(l)}:{l['line']} {l['api']}"
        # 2026-11-16(SSP0020 D1 허위 FAIL 8행 · cs:294·307): 조회 결과를 바인딩한 바로 그 블록에서 컬럼 범위를 잠그고(전 컬럼 잠금이 아니라 search_locks_all 에 안 걸림)
        #   EditButton 경로가 SwitchLock 으로 풀지 않으면 그 컬럼은 조회된 모든 행에서 잠긴 채다 → 기존행 잠금 규칙으로 넣는다.
        #   '같은 블록' = 같은 메서드·같은 guard 의 GRID_BIND 문장이 있다(행 수 > 0 같은 guard 는 바인딩의 전제라 행 조건이 아니다). 전 컬럼 잠금(ALL)은 종전 규칙(d_exist)이 맡는다
        if not edit_unlocks_all:
            bind_guards = {(x['method'], x.get('guard', '')) for x in acts if x.get('kind') == 'GRID_BIND'}
            for l in locks:
                if l['scope'] == 'ALL_ROWS' and l['locked'] == 'Y' and l['method'] not in edit_chain and l['expand'] not in ('UNRESOLVED', '', 'ALL') and (l['method'], l.get('guard', '')) in bind_guards:
                    for c in [c for c in l['columns'].split(';') if c and c.upper() != 'CHK']:   # 행 선택용 CHK 는 잠겨 있어도 CellClick 처리기가 값을 뒤집는다(선택 가능) — 편집 기대에서 뺀다
                        e = ent(c); e['existing_rules'] += [{'g': '', 'lock': 'Y', 'ref': f"{l['method']}:{l['line']} 조회 결과 바인딩 블록의 잠금 · EditButton 해제 없음"}]
                        e['ref'] = (e['ref'] + ' | ' if e['ref'] else '') + f"기존행 {fbase(l)}:{l['line']} {l['api']}(조회 후 잠금)"
        for l in new_locks:
            for c in [c for c in l['columns'].split(';') if c]:
                e = ent(c); e['new_rules'] += rules_of(l); e['ref'] = (e['ref'] + ' | ' if e['ref'] else '') + f"신규행 {fbase(l)}:{l['line']} {l['api']}"
        # 접기: 규칙이 전부 무조건이면 마지막 규칙의 상태 · 조건 규칙이 하나라도 있으면 COND(JSON) · RAW 만 있으면 COND 이되 평가 불가 표식
        for c, e in exp.items():
            for k, rk, ck in (('existing_row', 'existing_rules', 'existing_cond'), ('new_row', 'new_rules', 'new_rules_cond')):
                rs = e[rk]
                # 2026-11-26 T682: 기본 상태만 모르는 UNKNOWN(해석 못 한 잠금 문장은 없음)이고 이 칸의 마지막 규칙이 조건 없는 문장이면
                #   기본 상태와 관계없이 그 문장이 최종 상태다(DMF0082 InsertRow:2751 편집 칸 9개 해제 · 화면 자체 Insert 가 신규 행을 풀지 않아 기본은 미확인)
                if e[k] == 'UNKNOWN' and rs and not rs[-1]['g'] and not (unres_new if k == 'new_row' else unres_edit):
                    e[k] = 'N' if rs[-1]['lock'] == 'Y' else 'Y'
                    e[ck if ck != 'new_rules_cond' else 'new_row_cond'] = f"{'잠금' if rs[-1]['lock'] == 'Y' else '해제'} ({rs[-1]['ref']}) · 마지막 문장이 조건 없음(기본 상태 미확인과 무관)"
                    continue
                if e[k] == 'UNKNOWN' or not rs:
                    if e[k] != 'UNKNOWN' and not rs: e[ck if ck != 'new_rules_cond' else 'new_row_cond'] = ''
                    continue
                if all(not r['g'] for r in rs):
                    e[k] = 'N' if rs[-1]['lock'] == 'Y' else 'Y'
                    e[ck if ck != 'new_rules_cond' else 'new_row_cond'] = ' | '.join(f"{'잠금' if r['lock'] == 'Y' else '해제'} ({r['ref']})" for r in rs)
                else:
                    e[k] = 'COND'
                    e[ck if ck != 'new_rules_cond' else 'new_row_cond'] = 'RULES:' + json.dumps(rs, ensure_ascii=False)
        return exp

    exp = build_exp(locks)
    controls = sorted({l.get('control', '') for l in locks if l.get('control')})
    # 헬퍼 매개변수 이름 컨트롤(SetLockSumColumn(SpreadInfo spreadInfo) 류)은 필드 컨트롤의 별칭 — 가장 많이 쓰인 필드 컨트롤로 합친다(2026-10-31 SCP0096 'spreadInfo' 가 별도 컨트롤로 갈라져 UNKNOWN)
    _GENERIC_CTL = re.compile(r'^(spreadInfo|spread|si|sp|fps|fpSpread|spd|grid|sheet)$', re.I)
    _cnt = {}
    for l in locks:
        c0 = l.get('control') or ''
        if c0 and not _GENERIC_CTL.match(c0): _cnt[c0] = _cnt.get(c0, 0) + 1
    if _cnt:
        _main_ctl = max(_cnt, key=_cnt.get)
        for l in locks:
            if l.get('control') and _GENERIC_CTL.match(l['control']): l['control'] = _main_ctl
        controls = {l['control'] for l in locks if l.get('control')}
    exp_ctl = {ctl: build_exp([l for l in locks if l.get('control') == ctl]) for ctl in controls} if len(controls) > 1 else {}
    out2 = os.path.join(sdir, 'edit_expect.csv')
    bounds = set()
    for l in locks:
        cs = [c for c in l['columns'].split(';') if c]
        if l['expand'] == 'RANGE' and cs:
            bounds.update({sort_no.get(cs[0]), sort_no.get(cs[-1])})
    with open(out2, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['column', 'asis_visible', 'new_row', 'existing_row', 'new_row_cond', 'existing_cond', 'ambiguous', 'ref', 'control', 'sheet'])
        w.writeheader()
        for ctl, ex in [('', exp)] + sorted(exp_ctl.items()):
            for c in order + [k for k in ex if k not in order]:
                r = {k: v for k, v in ex[c].items() if k in ('column', 'new_row', 'existing_row', 'new_row_cond', 'existing_cond', 'ref')}
                r['asis_visible'] = visible.get(c, '')
                r['control'] = ctl
                r['sheet'] = main_sheet  # 잠금 규칙이 해석된 시트(메타 컬럼 순서의 원천) — 다른 시트의 같은 이름 컬럼에는 적용하지 않는다(2026-10-31 SCP0041 Osp Stock.QTY ← Pack Hold 규칙)
                peers = [o for o in order if o != c and sort_no.get(o) == sort_no.get(c)]
                r['ambiguous'] = f"정렬번호 {sort_no.get(c)} 동률({','.join(peers)}) — 범위 경계 포함 여부 확정 불가" if peers and sort_no.get(c) in bounds else ''
                w.writerow(r)
    # 2026-11-26 T658(사용자 '다중 시트 편집 기대도 시트별로 보완'): 편집 기대가 메인 시트 1개만 있어 다중 시트 화면 10개의 다른 시트 칸 D1 455행이
    #   'AS-IS 편집 기대 없음' 미검증으로 남았다(SSP0015 Hold stock·W/H stock 등). 메인 밖 시트마다 원문 근거로 기대를 만든다.
    #   시트 ↔ 잠금 컨트롤 = 원문 `AddSheet(spdX, 시트)` + `siY = GetSheetInfo(spdX.Name, …)`(못 이으면 그 시트는 만들지 않음)
    #   잠금 문장 = 그 컨트롤의 문장만 · 조건의 SHEET 원자는 그 시트 기준으로 접음(성립 안 하면 제외) · 칸 범위(ALL·RANGE)는 그 시트 메타 순서로 다시 전개
    #   Insert 대상 컨트롤이 이 시트 컨트롤이 아니면 신규행 시나리오 없음(NONE). 결과는 edit_expect_sheets.csv(소비처 = ledger.py ee_for) — edit_expect.csv 는 그대로
    sheet_log = []
    _code = [l_.split('//')[0] for l_ in src_lines]
    _spd_of_sheet, _si_of_spd = {}, {}
    for l_ in _code:
        for ma in re.finditer(r'\bAddSheet\(\s*(\w+)\s*,\s*([\w.]+|"[^"]*")', l_):
            sv = ma.group(2) if ma.group(2).startswith('"') else (R.const_value(ma.group(2)) or '')
            if sv.startswith('"'):
                _spd_of_sheet.setdefault(_nrm_sheet(sv.strip('"')), set()).add(ma.group(1))
        for ma in re.finditer(r'\b(\w+)\s*=\s*(?:this\.)?GetSheetInfo\(\s*(\w+)\.Name\b', l_):
            _si_of_spd.setdefault(ma.group(2), set()).add(ma.group(1))
    _ins_ctl = {x['target'].split('.')[0] for x in acts if x['method'] in insert_chain and x['class'] == main_cls and re.search(r'\.Insert\s*$', x['target'] or '')}
    _keep = (order, sort_no, visible)
    with open(os.path.join(sdir, 'edit_expect_sheets.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['column', 'asis_visible', 'new_row', 'existing_row', 'new_row_cond', 'existing_cond', 'ambiguous', 'ref', 'control', 'sheet'])
        w.writeheader()
        for S in sorted(sheets):
            if _nrm_sheet(S) == _nrm_sheet(main_sheet):
                continue
            ctls = {si for spd in _spd_of_sheet.get(_nrm_sheet(S), set()) for si in _si_of_spd.get(spd, set())}
            if not ctls:
                sheet_log.append(f'{S}: 시트 ↔ 잠금 컨트롤 대응 없음(AddSheet·GetSheetInfo) — 만들지 않음')
                continue
            ms2 = sorted(sheets[S], key=lambda m: float(m.get('SORT_ORDER_NO') or 0))
            order = [m['COLUMN_NAME'].upper() for m in ms2]
            sort_no = {m['COLUMN_NAME'].upper(): m.get('SORT_ORDER_NO') for m in ms2}
            visible = {m['COLUMN_NAME'].upper(): m.get('VISIBLE_FLAG', 'Y') for m in ms2}
            locks_s = []
            for l in locks:
                if l.get('control') not in ctls:
                    continue
                c2 = spec_sheet(l['cond'], S)
                if c2 == 'FALSE':
                    continue
                l2 = dict(l, cond=c2)
                if l['locked'] == 'EXPR' and l['lock_expr']:
                    le2 = spec_sheet(l['lock_expr'], S)
                    if le2 == '':
                        l2['locked'], l2['lock_expr'] = 'Y', ''
                    elif le2 == 'FALSE':
                        l2['locked'], l2['lock_expr'] = 'N', ''
                    else:
                        l2['lock_expr'] = le2
                src_ = lock_src.get((l['method'], l['line'], l['raw']))
                if src_ and l['expand'] not in ('DYNAMIC', 'NOOP'):  # T683 NOOP 은 칸을 다시 정하지 않는다
                    R.control = l['control']; R.line = int(l['line'] or 0); R.cur_locked = l['locked']
                    cs2, how2 = expand(src_[0], src_[1], api_hint=src_[2])
                    l2['columns'], l2['expand'] = ';'.join(cs2), how2
                locks_s.append(l2)
            ins = None
            if has_insert_button and not insert_noop and not (_ins_ctl & ctls):
                ins = ('NONE', f"AS-IS InsertButton 경로 Insert 대상({','.join(sorted(_ins_ctl)) or '없음'})이 이 시트 컨트롤({','.join(sorted(ctls))})이 아님(신규행 시나리오 없음)")
            ex_s = build_exp(locks_s, ins)
            bnd = set()
            for l in locks_s:
                cs = [c for c in l['columns'].split(';') if c]
                if l['expand'] == 'RANGE' and cs:
                    bnd.update({sort_no.get(cs[0]), sort_no.get(cs[-1])})
            for c in order + [k for k in ex_s if k not in order]:
                r = {k: v for k, v in ex_s[c].items() if k in ('column', 'new_row', 'existing_row', 'new_row_cond', 'existing_cond', 'ref')}
                r['asis_visible'] = visible.get(c, ''); r['control'] = ''; r['sheet'] = S
                peers = [o for o in order if o != c and sort_no.get(o) == sort_no.get(c)]
                r['ambiguous'] = f"정렬번호 {sort_no.get(c)} 동률({','.join(peers)}) — 범위 경계 포함 여부 확정 불가" if peers and sort_no.get(c) in bnd else ''
                w.writerow(r)
            sheet_log.append(f"{S}: {len(order)}칸 · 컨트롤 {','.join(sorted(ctls))} · 잠금 문장 {len(locks_s)}")
    order, sort_no, visible = _keep
    # 2026-11-18 SCP0111 H2 SetBGColor2 미검증: 조건부 배경색 문장도 잠금과 같은 가드 정규형으로 전개 → color_rules.csv(E2E _trace 'H2 조건부 배경색' 이 행 값·계정 그룹·Division 으로 계산해 대조)
    #   색 인자가 변수면 같은 메서드에서 문장 앞 마지막 대입 묶음을 읽는다 — 'if (… IsEditMode …)' 쪽 대입 = 편집 모드 색(TO-BE 는 상시 편집 모드 · CR-084/093), else 쪽 = 조회 모드 색
    color_rows = []
    rx_col = re.compile(r'Color\.FromArgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)|Color\.(\w+)')
    for x in sorted((x for x in acts if x['kind'] == 'GRID_STYLE' and x['class'] == main_cls and re.search(r'\.(SetBGColor2?|SetBackColor|SetCellColor)$', x['target'] or '')), key=lambda x: int(x['line'] or 0)):
        key = (x['class'], x['method']); ln0 = int(x['line'] or 0); R.control = x['target'].split('.')[0]; R.line = ln0
        _args = [a_.strip() for a_ in Resolver._split(x['value'].strip()[1:-1] if x['value'].strip().startswith('(') else x['value'], ',')]
        carg = _args[-1] if _args else ''
        edit_c = view_c = ''
        m0 = rx_col.search(carg)
        if m0:
            edit_c = view_c = (f'rgb({m0.group(1)},{m0.group(2)},{m0.group(3)})' if m0.group(1) else m0.group(4))
        elif re.fullmatch(r'\w+', carg):
            mode = ''
            for i, ln in R.method_lines(key):
                if i >= ln0: break
                kw, ctext = R._cond_text(i)
                if kw in ('if', 'else if'): mode = 'edit' if re.search(r'IsEditMode\s*(==\s*true)?\s*$', ctext) else ('view' if re.search(r'IsEditMode\s*==\s*false|!\s*[\w.]*IsEditMode', ctext) else '')
                elif re.match(r'\s*(\}\s*)?else\b(?!\s+if)', ln): mode = {'edit': 'view', 'view': 'edit'}.get(mode, '')
                ma = re.search(r'\b' + re.escape(carg) + r'\s*=(?!=)\s*([^;]+);', ln)
                if ma:
                    mc = rx_col.search(ma.group(1)); cv = (f'rgb({mc.group(1)},{mc.group(2)},{mc.group(3)})' if mc and mc.group(1) else (mc.group(4) if mc else f'RAW({ma.group(1).strip()[:40]})'))
                    if re.match(r'\s*\w+\s+' + re.escape(carg) + r'\s*=', ln): edit_c = view_c = cv  # 선언(기본값) — 뒤의 분기 대입이 덮는다
                    elif mode == 'edit': edit_c = cv
                    elif mode == 'view': view_c = cv
                    else: edit_c = view_c = cv
        cols, how = expand(key, x['value'], api_hint='SetBGColor')
        cond = R.guard(key, x['guard'], cols[0] if how == 'DYNAMIC' else '', line=ln0)
        cond = lookup_fix(key, cond, ln0)
        cond = with_flow(key, x, ln0, cond)  # T542: 앞선 continue·break 가드
        # 존재 검사 'V = DBUtils.Filter(T, "A = '" + v + "' AND B = 'lit'", …); if (V != null && V.Rows.Count > 0)' — T 가 조회 결과 전체(T = ds.Tables[0])면 EXISTS(A==COL(..) && B=="lit") 로 바꾼다(condeval EXISTS)
        for V in sorted(set(re.findall(r'RAW\((\w+) != null\)', cond))):
            if f'RAW({V}.Rows.Count > 0)' not in cond: continue
            dv = [d for d in R.var_defs(key, V) if d[0] < ln0]
            mf = re.match(r'DBUtils\.Filter\(\s*(\w+)\s*,\s*(.+?)\s*(?:,\s*true\s*)?\)$', dv[-1][1]) if dv else None
            if not mf or not any(re.search(r'\b(?:this\.)?' + re.escape(mf.group(1)) + r'\s*=\s*\w+\.Tables\[0\]', l_) for l_ in src_lines): continue
            txt = ''; ok_ = True
            for tok in [t_.strip() for t_ in Resolver._split(mf.group(2), '+')]:
                if re.fullmatch(r'"[^"]*"', tok): txt += tok[1:-1]
                elif re.fullmatch(r'\w+', tok):
                    e_ = R.expr(key, f'{tok} == "__Z__"', '')
                    mc_ = re.match(r'^(COL\(\w+\))=="__Z__"$', e_ or '')
                    if not mc_: ok_ = False; break
                    txt += '\x00' + mc_.group(1) + '\x00'
                else: ok_ = False; break
            cls_ = [re.match(r"^\s*(\w+)\s*=\s*'(?:\x00(COL\(\w+\))\x00|([^'\x00]*))'\s*$", c_) for c_ in re.split(r'\s+AND\s+', txt.strip(), flags=re.I)] if ok_ else []
            if not cls_ or not all(cls_): continue
            ex_ = 'EXISTS(' + ' && '.join(f'{c_.group(1)}=={c_.group(2)}' if c_.group(2) else f'{c_.group(1)}=="{c_.group(3)}"' for c_ in cls_) + ')'
            cond = cond.replace(f'RAW({V} != null) && RAW({V}.Rows.Count > 0)', ex_)
        color_rows.append({'method': x['method'], 'line': x['line'], 'api': x['target'].split('.')[-1], 'columns': ';'.join(cols), 'expand': how, 'color_edit': edit_c, 'color_view': view_c,
                           'cond': cond, 'ref': f"{fbase({'method': x['method'], 'line': x['line']})}:{x['line']}", 'raw': x['raw'][:300]})
    # T566(2026-11-25 SCP0005 FACT 색 규칙 1행): 셀 속성 대입 `Cells[iRow, iCol].BackColor = colorLink;`(cs:569, switch(GetColumnTag(iCol)) case "ROUTE_ID" 안 · colorLink = Color.Yellow cs:71)
    #   를 SetBGColor 계열만 읽어 기록하지 않았다. 열 인자가 GetColumnIndex(Def.X) 면 X, 루프 변수면 그 변수의 태그(GetColumnTag·Columns[v].Tag)를 고르는 switch case / if == 리터럴이 칸이다.
    #   칸을 고르는 가드 절은 조건에서 뺀다(행 조건 아님). 색 변수는 메서드 안 앞선 대입 → 파일 전체 대입(값이 하나일 때만) 순서로 푼다. 칸을 못 정하면 기록하지 않는다(추측 금지)
    rx_bc = re.compile(r'\.Cells\[\s*[^,\]]+,\s*(.+?)\s*\]\.BackColor$')
    for x in sorted((x for x in acts if x['kind'] == 'GRID_SET' and x['class'] == main_cls and rx_bc.search(x['target'] or '')), key=lambda x: int(x['line'] or 0)):
        key = (x['class'], x['method']); ln0 = int(x['line'] or 0); R.control = x['target'].split('.')[0]; R.line = ln0
        cexpr = rx_bc.search(x['target']).group(1)
        segs = [g_.strip() for g_ in (x['guard'] or '').split('▸') if g_.strip()]
        mcol = re.search(r'GetColumnIndex\(\s*(?:' + r'\w+\.)?"?(\w+)"?\s*\)', cexpr)
        cols_bc = [R.defcol(mcol.group(1))] if mcol else []
        if not cols_bc and re.fullmatch(r'\w+', cexpr) and '…' not in (x['guard'] or ''):
            tagv = {cexpr}
            for _i, _ln in R.method_lines(key):
                if _i >= ln0: break
                ma_ = re.search(r'\b(\w+)\s*=\s*[\w.]*(?:GetColumnTag\(\s*' + re.escape(cexpr) + r'\s*\)|Columns\[\s*' + re.escape(cexpr) + r'\s*\]\.Tag)', _ln)
                if ma_: tagv.add(ma_.group(1))
            keep = []
            for g_ in segs:
                ms_ = re.match(r'switch\s*\(\s*(\w+)\s*\)\s*((?:case\s+"\w+"\s*:\s*)+)$', g_)
                mi_ = re.match(r'(?:if|else if)\s*\(\s*(\w+)\s*==\s*"(\w+)"\s*\)$', g_)
                if ms_ and ms_.group(1) in tagv: cols_bc += re.findall(r'case\s+"(\w+)"', ms_.group(2))
                elif mi_ and mi_.group(1) in tagv: cols_bc.append(mi_.group(2))
                else: keep.append(g_)
            segs = keep
        if not cols_bc:
            continue
        val = (x['value'] or '').strip(); cv = ''
        mc_ = rx_col.search(val)
        if mc_:
            cv = f'rgb({mc_.group(1)},{mc_.group(2)},{mc_.group(3)})' if mc_.group(1) else mc_.group(4)
        elif re.fullmatch(r'\w+', val):
            loc = [d for d in R.var_defs(key, val) if d[0] < ln0]
            defs_ = [loc[-1][1]] if loc else sorted({m_.group(1).strip() for l_ in src_lines for m_ in [re.search(r'\b' + re.escape(val) + r'\s*=(?!=)\s*([^;]+);', l_)] if m_})
            if len(defs_) == 1:
                mc_ = rx_col.search(defs_[0])
                cv = (f'rgb({mc_.group(1)},{mc_.group(2)},{mc_.group(3)})' if mc_.group(1) else mc_.group(4)) if mc_ else f'RAW({defs_[0][:40]})'
            else:
                cv = f'RAW({val})'
        cond = with_flow(key, x, ln0, lookup_fix(key, R.guard(key, ' ▸ '.join(segs), '', line=ln0), ln0))  # T542: 앞선 continue·break 가드
        color_rows.append({'method': x['method'], 'line': x['line'], 'api': 'BackColor', 'columns': ';'.join(c_.upper() for c_ in cols_bc), 'expand': 'ONE' if len(cols_bc) == 1 else 'LIST',
                           'color_edit': cv, 'color_view': cv, 'cond': cond, 'ref': f"{fbase({'method': x['method'], 'line': x['line']})}:{x['line']}", 'raw': (x['raw'] or '')[:300]})
    out3 = os.path.join(sdir, 'color_rules.csv')
    with open(out3, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['method', 'line', 'api', 'columns', 'expand', 'color_edit', 'color_view', 'cond', 'ref', 'raw'])
        w.writeheader(); w.writerows(color_rows)
    nres = sum(1 for l in locks if l['expand'] in ('UNRESOLVED', ''))
    print(f'{sid}: 잠금 규칙 {len(locks)}건(미해석 {nres}) → {out1}')
    print(f'  조건부 배경색 규칙 {len(color_rows)}건 → {out3}')
    # INLOOKUP 원자가 쓰는 공통 코드 값 — TO-BE LookupCommon 콤보 SQL(SCM_ADM_CMBO_SQL_M 'LookupCommon': CODE=SEGMENT1 · NAME=SEGMENT2 · VALID_YN='Y')과 같은 조건으로 읽는다
    if lookup_types:
        lk = {}
        try:
            sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
            from dbconn import connect
            with connect('tobe') as cx:
                cur = cx.cursor()
                for t in sorted(lookup_types):
                    cur.execute("SELECT B.SEGMENT1, B.SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER A JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y' WHERE A.LOOKUP_TYPE = :t AND A.VALID_YN = 'Y' ORDER BY B.DISPLAY_SEQ", t=t)
                    rs = cur.fetchall()
                    lk[t] = {'CODE': [str(r[0] or '').strip() for r in rs], 'NAME': [str(r[1] or '').strip() for r in rs]}
        except Exception as e:  # noqa: BLE001 — DB 접속 실패는 값 없음(INLOOKUP 평가 불가 = 미검증)으로 남긴다
            print(f'  [경고] 공통 코드 값 조회 실패({e}) — INLOOKUP 평가 불가')
        if lk:
            out4 = os.path.join(sdir, 'lookups.json')
            json.dump({'source': 'TO-BE SCM_ADM_LOOKUP_MASTER_DETAIL(LookupCommon: CODE=SEGMENT1 · NAME=SEGMENT2 · VALID_YN=Y)', 'types': lk}, open(out4, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
            print('  공통 코드 ' + ', '.join(k + ' ' + str(len(v['NAME'])) + '건' for k, v in lk.items()) + f' → {out4}')
    print(f'  편집 기대 {len(exp)}컬럼 → {out2} (메인 시트 {main_sheet}, 클래스 {main_cls}, Insert 경로 .Insert {"있음" if insert_unlocks_row else "없음"}, 기존행 기본 {exp[order[0]]["existing_row"] if order and order[0] in exp else "-"})')
    if sheet_log:
        print(f'  시트별 편집 기대(메인 밖 {len(sheet_log)}시트) → edit_expect_sheets.csv: ' + ' | '.join(sheet_log))
    if R.unresolved:
        print('  평가 불가 원자(RAW): ' + ' · '.join(sorted(set(R.unresolved))[:8]))
    return 0


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok = ok and bool(c)
    A = 'SHEET=="Shipment Confirm Detail" && COL(SHIPMENT_STATUS)=="C"'
    chk('T658 다른 시트 조건 = 성립 안 함', spec_sheet(A, 'Hold stock') == 'FALSE')
    chk('T658 같은 시트 조건 = SHEET 원자만 빠짐', spec_sheet(A, 'Shipment Confirm Detail') == 'COL(SHIPMENT_STATUS)=="C"')
    B = '!(SHEET=="Shipment Confirm Detail") && SHEET=="Stock Detail" && (COL(A)=="D" || COL(B)=="-")'
    chk('T658 else 분기(부정) + 같은 시트', spec_sheet(B, 'Stock Detail') == 'COL(A)=="D" || COL(B)=="-"')
    chk('T658 else 분기 + 다른 시트', spec_sheet(B, 'Hold stock') == 'FALSE')
    chk('T658 SHEET 없는 조건 = 그대로', spec_sheet('COL(X)=="Y" && GROUP=="A"', 'S') == 'COL(X)=="Y" && GROUP=="A"')
    chk('T658 빈 조건 = 항상', spec_sheet('', 'S') == '')
    chk('T658 != 원자', spec_sheet('SHEET!="Hold stock"', 'Hold stock') == 'FALSE' and spec_sheet('SHEET!="Hold stock"', 'W/H stock') == '')
    chk('T658 || 한쪽 성립 = 항상', spec_sheet('SHEET=="A" || COL(X)=="1"', 'A') == '')
    chk('T658 시트 이름 공백·기호 무시', spec_sheet('SHEET=="W/H stock"', 'W/H Stock') == '')
    # T678: 중괄호 없는 if 의 else · 여러 줄 조건 if 의 else → 짝 if 조건
    src = ['void M()', '{', '    for (int iCol = 0; iCol < 9; iCol++)', '    {',
           '        if (a == "1")', '        {', '            if (b == "2")', '                X(1);', '            else', '            {',
           '                Y(2);', '            }', '        }', '        if ((c == "3")', '            && d == "4"', '            )', '        {',
           '            Z(3);', '        }', '        else', '        {', '            W(4);', '        }', '    }', '}']
    R_ = Resolver(src, {('C', 'M'): (1, len(src))}, [])
    g11 = R_.source_guard(('C', 'M'), 11)
    chk('T678 중괄호 없는 if 의 else = 그 if 조건', g11.endswith('if (a == "1") ▸ else of (b == "2")') if '▸' in g11 else g11.endswith('else of (b == "2")'))
    g22 = R_.source_guard(('C', 'M'), 22)
    chk('T678 여러 줄 조건 if 의 else = 조건 전체', 'else of ((c == "3") && d == "4")' in g22 and 'RAW(?)' not in g22)
    # T679: IndexOf 접두·포함 검사
    chk('T679 태그 IndexOf != 0 = 접두 아님', R_.atom(('C', 'M'), 'siMain.GetColumnTag(iCol).IndexOf("M_") != 0') == '!(SELF~"^M_")')
    chk('T679 태그 IndexOf != -1 = 포함', R_.atom(('C', 'M'), 'siMain.GetColumnTag(iCol).IndexOf("W_") != -1') == 'SELF~"W_"')
    chk('T679 else of (!X) = X', R_.expr(('C', 'M'), 'else of (siMain.GetColumnTag(iCol).IndexOf("M_") != 0)') == 'SELF~"^M_"')
    # T680: 속성 반환식 + 호출 경로의 불리언 속성 값
    src2 = ['        private string colName', '        {', '            get', '            {', '                string res = "";',
            '                if (isPage)', '                {', '                    res = DefColumns.A_COL;', '                }', '                else',
            '                {', '                    res = DefColumns.B_COL;', '                }', '                return res;', '            }', '        }',
            '        protected override void EditButton()', '        {', '            if (isPage)', '            {', '                LockP();',
            '            }', '            else', '            {', '                LockQ();', '            }', '        }',
            '        private void LockQ()', '        {', '            si.LockRange2(0, 0, 9, si.GetColumnIndex(colName), true);', '        }']
    R2 = Resolver(src2, {('C', 'LockQ'): (28, 31)}, [])
    chk('T680 속성 getter 반환식 후보 2개', len(R2.member_returns('colName')) == 2)
    chk('T680 호출 경로 else of (isPage) → isPage=False', R2.ctx_bool('LockQ', 'isPage') is False)
    chk('T680 호출 경로로 고른 반환식', R2.member_pick(('C', 'LockQ'), 'colName') == 'DefColumns.B_COL')
    # T684: EditButton 안의 행 상태 칸 숨김 검사 = 편집 모드 진입(TRUE) · 다른 메서드는 해석하지 않음
    src3 = ['        protected override void EditButton()', '        {', '            int xCol1 = sv.Columns[CAppSetting.StringAction].Index;',
            '            if (sv.Columns[xCol1].Visible == false)', '            {', '            }', '        }']
    R3 = Resolver(src3, {('C', 'EditButton'): (1, 7), ('C', 'Other'): (1, 7)}, [])
    chk('T684 EditButton Action 칸 숨김 = 편집 모드 진입', R3.atom(('C', 'EditButton'), 'sv.Columns[xCol1].Visible == false') == 'TRUE')
    chk('T684 else = 편집 모드 해제', R3.expr(('C', 'EditButton'), 'else of (sv.Columns[xCol1].Visible == false)') == 'FALSE')
    chk('T684 EditButton 밖은 종전(RAW)', 'RAW(' in R3.atom(('C', 'Other'), 'sv.Columns[xCol1].Visible == false'))
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(main())
