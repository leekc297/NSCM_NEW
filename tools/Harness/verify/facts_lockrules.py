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

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
RX_DEFCOL = re.compile(r'\bDef\w+\.([A-Z0-9_]+)')
RX_TABLE_FAMILY = re.compile(r'Data\.Common\(\s*Data\.Type\.(\w+)')
RX_GROUP_SRC = re.compile(r'NowGroupID|GroupID"\]|UserGroup', re.I)
RX_DIV_SRC = re.compile(r'Division|DIVISION', re.I)
LOCK_COLS = ['method', 'line', 'api', 'scope', 'locked', 'lock_expr', 'columns', 'expand', 'cond', 'guard', 'control', 'raw']


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
                if re.match(r'^(\}\s*)?else\b(?!\s+if)', head):
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
        m = RX_DEFCOL.search(arg)
        if m:
            return ('COL', m.group(1))
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
                    return ('COL', mt2.group(1))
        return ('RAW', arg)

    def atom(self, key, a, self_col=''):
        """가드 원자 1개 → 정규형. 접을 수 있으면 'TRUE'"""
        a = a.strip()
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
        # 동적 컬럼 루프 필터(태그 접두) — 컬럼 전개(<DYNAMIC:…>)가 이미 대상을 정했으므로 조건으로는 항상 참(2026-10-31 SCP0096 SetLockSumColumn)
        mtag = re.fullmatch(r'(?:\w+\.)?GetColumnTag\(\s*\w+\s*\)\.IndexOf\(\s*"(\w+_?)"\s*\)\s*==\s*0', a)
        if mtag:
            return f'SELF~"^{mtag.group(1)}"'  # 동적 binding 접두 조건 — 전 패밀리가 아니라 그 접두 컬럼만(2026-10-31 SCP0096 M_/W_ 합계 컬럼)
        # 접는 것(TRUE)
        if re.fullmatch(r'string\.IsNullOrEmpty\(\s*\w+\s*\)', a):
            return 'FALSE'  # 세션 값(그룹·Division)은 비어 있지 않다고 본다 → '!string.IsNullOrEmpty(x)' 는 expr 의 부정으로 TRUE
        if re.search(r'\b(spd\w+|si\w+|fps|spreadInfo)\s*!=\s*null\b', a) or re.search(r'IsLock\([^)]*\)\s*==\s*false', a) \
                or re.search(r'\.IsEditMode\s*==\s*true', a) or re.fullmatch(r'(try|finally|else)', a):
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
        if m and not re.search(r'\(.*\)\s*$', m.group(1)) or (m and re.fullmatch(r'[\w.]+\([^=]*\)(?:\.ToString\(\))?', m.group(1).strip())):
            lhs, op, rhs = m.group(1).strip(), m.group(2), m.group(3).strip()
            rhs = '""' if rhs in ('string.Empty', 'String.Empty') else rhs
            rhs = {'CAppSetting.StringY': '"Y"', 'CAppSetting.StringN': '"N"'}.get(rhs, rhs)  # 프레임워크 상수(2026-11-02 EDIT_FLAG=="Y" 가 전부 RAW 였음)
            L = self.lhs(key, lhs, self_col)
            if L and re.fullmatch(r'"[^"]*"|-?\d+', rhs):
                return f'{L}{op}{rhs}'
        self.unresolved.append(a)
        return f'RAW({a})'

    def lhs(self, key, lhs, self_col):
        """비교 좌변 → GROUP · DIV · COL(NAME) · COL(NAME)[a:b] · COL(SELF)"""
        # 가드 안의 직접 GetText/GetValue(…GetColumnIndex(Def*.COL)…) (SCP0020 siMain.ActiveSheet.GetText(i, …INPUT_STATUS…).ToString() == "M")
        mi = re.fullmatch(r'(?:\w+\.)+Get(?:Text|Value)\(\s*\w+\s*,\s*\w+\.GetColumnIndex\(\s*([^)]+)\)\s*\)(?:\.ToString\(\))?(?:\.Substring\(\s*(\d+)\s*,\s*(\d+)\s*\))?', lhs)
        if mi:
            kind, nm = self.col_arg(key, mi.group(1))
            sl0 = f'[{mi.group(2)}:{int(mi.group(2)) + int(mi.group(3))}]' if mi.group(2) else ''
            return f'COL({nm}){sl0}' if kind == 'COL' else f'COL(SELF){sl0}' if kind == 'DYN' else ''
        mu_ = re.fullmatch(r'UserInfoContext\.Current\[\s*"(\w+)"\s*\](?:\.ToString\(\))?', lhs)
        if mu_ and re.search(r'GROUP', mu_.group(1), re.I):
            return 'GROUP'
        ms = re.fullmatch(r'(\w+)\.Substring\(\s*(\d+)\s*,\s*(\d+)\s*\)', lhs)
        base, sl = (ms.group(1), f'[{ms.group(2)}:{int(ms.group(2)) + int(ms.group(3))}]') if ms else (lhs, '')
        if not re.fullmatch(r'\w+', base):
            return ''
        defs = self.var_defs(key, base)
        for _, ex in defs:
            if RX_GROUP_SRC.search(ex):
                return 'GROUP' + sl
            mg = re.search(r'Get(?:Value|Text)\(\s*\w+\s*,\s*\w+\.GetColumnIndex\(\s*([^)]+)\)\s*\)', ex)
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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('asis_id')
    ap.add_argument('--class', dest='cls', default='')
    a = ap.parse_args()
    sid = a.asis_id.upper()
    sdir = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid)
    cur_files = {f['file'] for f in read_csv(os.path.join(sdir, 'files.csv')) if f.get('variant') in ('current', 'shared')}
    dead = dead_methods(sid)  # 실행되지 않는 AS-IS 메서드의 잠금은 사실 아님(2026-10-30 asis_live)
    acts = [x for x in read_csv(os.path.join(sdir, 'actions.csv')) if (not cur_files or x['file'] in cur_files) and (x['class'], x['method']) not in dead]
    main_files = {f['file'] for f in read_csv(os.path.join(sdir, 'files.csv')) if f.get('variant') == 'current' and f['file'].endswith('.cs') and not f['file'].endswith('.Designer.cs')}
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
    # 진입점 경로(actions_entries): EditButton 경로 메서드 = 기존행 규칙 · InsertButton 경로 메서드 = 신규행 규칙
    ents = read_csv(os.path.join(sdir, 'actions_entries.csv'))
    chain = lambda entry: {r['method'] for r in ents if r.get('entry') == entry and r.get('class') == main_cls} | {entry}
    edit_chain, insert_chain = chain('EditButton'), chain('InsertButton')
    insert_unlocks_row = any(x['method'] in insert_chain and x['class'] == main_cls and re.search(r'\.Insert\s*$', x['target'] or '') for x in acts)
    has_insert_button = any(x['method'] == 'InsertButton' and x['class'] == main_cls for x in acts)  # 화면에 InsertButton 자체가 없으면 신규행 시나리오 없음(2026-10-31 SCP0041)

    _dyn_rows = read_csv(os.path.join(sdir, 'dyn_columns.csv')) if os.path.exists(os.path.join(sdir, 'dyn_columns.csv')) else []

    def dyn_family_by_tag(key, var):
        """잠금 문장 앞 같은 메서드 안에 'GetColumnTag(var).IndexOf("P_") == 0' 가드가 있으면 접두 P_ 에 맞는 동적 패밀리 이름(없으면 '')"""
        pref = None
        for i, ln in R.method_lines(key):
            if R.line and i > R.line: break
            m = re.search(r'GetColumnTag\(\s*' + re.escape(var) + r'\s*\)\.IndexOf\(\s*"([A-Za-z]+_?)"\s*\)\s*==\s*0', ln)
            if m: pref = m.group(1)
        if not pref: return ''
        for d in _dyn_rows:
            try:
                if re.match(d.get('binding_regex') or '', pref + '202601'): return re.sub(r'^<DYNAMIC:|>$', '', d.get('family_id') or '')
            except re.error: continue
        return ''

    def expand(key, arg_text, self_hint=''):
        """LockColumn/LockRange 의 컬럼 인자 → (컬럼 목록, 전개 방식). 동적 패밀리는 '<DYNAMIC:Family>'"""
        inner = arg_text.strip()
        if inner.startswith('(') and inner.endswith(')'):
            inner = inner[1:-1]
        args = Resolver._split(inner, ',')
        args = [x.strip() for x in args]
        # 마지막 인자 = 잠금 bool · 앞은 (col) 또는 (colA, colB) 또는 (row, colA, row, colB)
        cols_arg = args[:-1]
        if len(cols_arg) == 4:
            cols_arg = [cols_arg[1], cols_arg[3]]
        elif len(cols_arg) == 3:
            cols_arg = [cols_arg[1], cols_arg[2]]
        ends = []
        for x in cols_arg:
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
            if re.search(r'ColumnCount\s*-\s*1|GetMaxColumnIndex\(\)', x):
                ends.append(('LAST', '')); continue
            mg = re.search(r'GetColumnIndex\((.*)\)\s*$', x)
            ends.append(R.col_arg(key, mg.group(1) if mg else x))
        if not ends:
            return [], 'UNRESOLVED'
        if len(ends) == 1:
            ends = ends * 2
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

    locks = []
    for x in sorted((x for x in acts if x['kind'] == 'GRID_LOCK' and x['class'] == main_cls), key=lambda x: int(x['line'] or 0)):
        tgt, val, m = x['target'], x['value'], x['method']
        key = (x['class'], m)
        ctl = tgt.split('.')[0]
        if tgt.endswith('SwitchLock'):
            locks.append({'method': m, 'line': x['line'], 'api': 'SwitchLock', 'scope': 'MODE', 'locked': 'TOGGLE', 'lock_expr': '', 'columns': '', 'expand': '', 'cond': '', 'guard': x['guard'], 'control': ctl, 'raw': tgt + val})
            continue
        last = Resolver._split(val.strip()[1:-1] if val.strip().startswith('(') else val, ',')[-1].strip() if val.strip() else ''
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
        cols, how = expand(key, val)
        if tgt.endswith('LockColumn'):
            scope = 'ALL_ROWS'
        else:
            row_arg = val.strip().lstrip('(').split(',')[0].strip()
            scope = 'NEW_ROW' if m in insert_chain or row_arg == 'insCell' else 'ROW_COND'
        self_col = cols[0] if how == 'DYNAMIC' else ''
        cond = R.guard(key, x['guard'], self_col, line=int(x['line'] or 0))
        locks.append({'method': m, 'line': x['line'], 'api': tgt.split('.')[-1], 'scope': scope, 'locked': locked, 'lock_expr': lock_expr, 'columns': ';'.join(cols), 'expand': how,
                      'cond': cond, 'guard': x['guard'], 'control': ctl, 'raw': tgt + val})

    base = os.path.basename((acts[0]['file'] if acts else '')).replace('.cs', '')
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

    def build_exp(locks):
        """잠금 문장 집합 → 컬럼별 기대(통합 또는 스프레드 컨트롤별)"""
        edit_locks = [l for l in locks if l['method'] in edit_chain and l['api'] != 'SwitchLock']
        new_locks = [l for l in locks if l['scope'] == 'NEW_ROW']
        edit_unlocks_all = any(l['method'] in edit_chain and l['api'] == 'SwitchLock' for l in locks)
        unres_edit = [l for l in edit_locks if l['expand'] in ('UNRESOLVED', '')]
        unres_new = [l for l in new_locks if l['expand'] in ('UNRESOLVED', '')]
        search_locks_all = any(l['scope'] == 'ALL_ROWS' and l['expand'] == 'ALL' and l['locked'] == 'Y' and l['method'] not in edit_chain for l in locks)
        no_edit_button = not any(l['method'] in edit_chain for l in locks)
        # 편집 버튼(SwitchLock) 모델이 아니고 조회 후 전체 잠금도 없으면 프레임워크 기본(해제) — 명시 LockColumn 규칙만 적용(2026-10-31 SCP0096 UNKNOWN 12)
        d_exist = 'Y' if edit_unlocks_all and not unres_edit else ('N' if no_edit_button and search_locks_all else 'Y' if not unres_edit and not search_locks_all else 'UNKNOWN')
        d_new = 'Y' if insert_unlocks_row and not unres_new else ('NONE' if not has_insert_button else 'UNKNOWN')
        why_exist = ('EditButton SwitchLock 없음 · 조회 후 전체 잠금 없음 → 기본 편집 가능(명시 잠금 규칙만)' if d_exist == 'Y' and not edit_unlocks_all else '') if d_exist == 'Y' else ('조회 후 전체 잠금 · EditButton 없음(조회 전용 화면)' if d_exist == 'N' else 'EditButton SwitchLock 없음(편집 모드 모델 아님)' if not edit_unlocks_all else '해석 못 한 잠금: ' + ' · '.join(f"{l['method']}:{l['line']} {l['raw'][:60]}" for l in unres_edit[:3]))
        why_new = '' if d_new == 'Y' else 'AS-IS InsertButton 없음(신규행 시나리오 없음)' if d_new == 'NONE' else ('InsertButton 경로에 siMain.Insert() 없음' if not insert_unlocks_row else '해석 못 한 잠금: ' + ' · '.join(f"{l['method']}:{l['line']} {l['raw'][:60]}" for l in unres_new[:3]))
        exp = {}

        def ent(c):
            return exp.setdefault(c, {'column': c, 'new_row': d_new, 'existing_row': d_exist, 'new_row_cond': why_new, 'existing_cond': why_exist, 'new_rules': [], 'existing_rules': [], 'ref': ''})
        for c in order:
            ent(c)
        for l in edit_locks:
            for c in [c for c in l['columns'].split(';') if c]:
                e = ent(c); e['existing_rules'] += rules_of(l); e['ref'] = (e['ref'] + ' | ' if e['ref'] else '') + f"기존행 {base}:{l['line']} {l['api']}"
        for l in new_locks:
            for c in [c for c in l['columns'].split(';') if c]:
                e = ent(c); e['new_rules'] += rules_of(l); e['ref'] = (e['ref'] + ' | ' if e['ref'] else '') + f"신규행 {base}:{l['line']} {l['api']}"
        # 접기: 규칙이 전부 무조건이면 마지막 규칙의 상태 · 조건 규칙이 하나라도 있으면 COND(JSON) · RAW 만 있으면 COND 이되 평가 불가 표식
        for c, e in exp.items():
            for k, rk, ck in (('existing_row', 'existing_rules', 'existing_cond'), ('new_row', 'new_rules', 'new_rules_cond')):
                rs = e[rk]
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
    nres = sum(1 for l in locks if l['expand'] in ('UNRESOLVED', ''))
    print(f'{sid}: 잠금 규칙 {len(locks)}건(미해석 {nres}) → {out1}')
    print(f'  편집 기대 {len(exp)}컬럼 → {out2} (메인 시트 {main_sheet}, 클래스 {main_cls}, Insert 경로 .Insert {"있음" if insert_unlocks_row else "없음"}, 기존행 기본 {exp[order[0]]["existing_row"] if order and order[0] in exp else "-"})')
    if R.unresolved:
        print('  평가 불가 원자(RAW): ' + ' · '.join(sorted(set(R.unresolved))[:8]))
    return 0


if __name__ == '__main__':
    sys.exit(main())
