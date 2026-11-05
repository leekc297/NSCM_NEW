"""콤보 후보 AS-IS 원천 비교(W1 · B4 집합 / B3 순서) — Doc/verify/<ID>/combo_oracle.json (2026-10-24)

  python tools/Harness/verify/combo_oracle.py <MENU_ID> [--asis <AS-IS ID>]

입력
  AS-IS  Doc/asisfacts/screens/<AS-IS ID>/combo_src.csv (facts_combosrc.py) — 대상별 원천 SP·code·인자 식·필터 체인·바인딩 메서드
  TO-BE  Doc/verify/<ID>/combo_runtime.json (_verify.spec.ts @verify 덤프) — 조회조건 목록(표시 순서) · 그리드 콤보 항목(코드·표시값)·행별 후보
정답(O1) = AS-IS 원천을 AS-IS DB(LGCE_SCMDEV)에서 TO-BE 와 같은 상태(같은 계정·조회조건 초기값·행 값)로 실행한 결과 + AS-IS 클라이언트 필터
인자 해석(원문 근거):
  UserInfoContext NowGroupID/UserId → E2E 계정(e2e.config forceAccount)의 AS-IS 그룹·ID
  clbX.ControlValues(초기 미선택) = "ALL" (UsrCheckedList.cs:298-307) · CString.GetCheckedListValue(dt,"ALL") = dt 의 CODE 전부 쉼표 연결(CString.cs:529-548)
  CString.GetCheckedListValue(dt, cv, false) = dt CODE 전부(CString.cs:584-590) · 행 변수 sDivision 등 = TO-BE 같은 행 값(덤프 newCtx/exCtx)
  DataService.GetDMInnerTable = BigFilter list_line_dm 결과셋 + 열별 필터·CODE 중복 제거·CODE 정렬(DataService.cs:3682-4105)
판정
  B4: AS-IS ∖ TO-BE · TO-BE ∖ AS-IS 가 모두 '데이터 차이'로 설명되면 PASS. 설명 = 차이 코드의 원천 마스터 행이 상대 DB 에 없거나,
      원천 WHERE 가 보는 컬럼 값이 두 DB 에서 다름(AS-IS DEV 와 사내 데이터 시점 차이). 설명 안 되는 차이 = 조건 차이 → FAIL
  B3: 공통 항목의 상대 순서 = AS-IS 순서(ORDER BY 또는 GetDMInnerTable CODE 정렬). AS-IS 정렬 근거가 없으면 NA
  해석 불가 인자·원천 미해결·분기 원천(행 값에 따라 원천이 바뀜)은 판정필요(사유 기록) — 추측 PASS 금지
"""
import csv
import json
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
sys.path.insert(0, os.path.dirname(__file__))
from dbconn import connect  # noqa: E402
import facts_combosrc as fc  # noqa: E402
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); from asis_live import dead_methods, dead_sps, sp_base  # noqa: E402

E2E_CFG = os.path.join(ROOT, 'tools', 'E2E', 'e2e.config.json')
BIGFILTER = os.path.join(ROOT, 'GSCM', '04.WSL', 'FoxQuery', 'DM', 'Common', 'BigFilter.xml')
INIT_METHODS = re.compile(r'^(<field>|SheetMeta|Init\w*|\w*_Load|Form_Load|SetInit\w*|Load\w*|\w*Constructor|SetChangeControl|SetControl\w*|Bind\w*)$', re.I)
ALL_WORDS = re.compile(r'^(SELECT ALL|ALL|전체)$', re.I)
CRS = [r for r in csv.DictReader(open(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'confirmed_requirements.csv'), encoding='utf-8-sig'))
       if re.search(r'B4|B3|C1|B8|B5', (r.get('rule_ids') or '') + (r.get('rule_id') or ''))] if os.path.exists(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'confirmed_requirements.csv')) else []


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def norm(s):
    return re.sub(r'[^a-z0-9]', '', str(s or '').lower())


def net_sort_key(s):
    """.NET 문화권 문자열 비교 근사 — 하이픈·아포스트로피 무시(단어 정렬) 후 대소문자 무시. 동률은 원문 순서(안정 정렬)"""
    return re.sub(r"[-']", '', s).lower()


class AsIs:
    def __init__(self, cx, group, user):
        self.cx, self.group, self.user = cx, group, user
        self.cache, self.bigfilter = {}, None

    def timezone(self):
        if not hasattr(self, '_tz'):
            cur = self.cx.cursor()
            try:
                cur.execute("SELECT TOP 1 TimeZone FROM TB_FX_User WITH(NOLOCK) WHERE UserID=?", self.user)
                r = cur.fetchone()
                self._tz = r[0] if r else None
            except Exception:  # noqa: BLE001 — 컬럼 없으면 null
                self._tz = None
        return self._tz

    def sp_meta(self, sp):
        cur = self.cx.cursor()
        cur.execute("SELECT TOP 1 SCHEMA_NAME(o.schema_id), o.object_id FROM sys.objects o WHERE o.name=? AND o.type IN ('P','PC')", sp)
        r = cur.fetchone()
        if not r:
            return None, []
        cur.execute("SELECT name FROM sys.parameters WHERE object_id=? ORDER BY parameter_id", r[1])
        return r[0], [x[0] for x in cur.fetchall()]

    def run_sp(self, sp, params):
        key = (sp, tuple(sorted(params.items())))
        if key in self.cache:
            return self.cache[key]
        schema, names = self.sp_meta(sp)
        if not schema:
            raise RuntimeError(f'AS-IS DB 에 SP {sp} 없음')
        up = {k.upper(): v for k, v in params.items()}
        # 원문이 넘기지 않은 파라미터 = null(Data*.cs 기본값 null) · @TimeZone = 계정 시간대(Data*.CallBizCommonData 가 UserInfo TimeZone 을 싣는다)
        up.setdefault('@TIMEZONE', self.timezone())
        use = [(n, up.get(n.upper())) for n in names]
        cur = self.cx.cursor()
        sql = f"EXEC [{schema}].[{sp}] " + ', '.join(f'{n}=?' for n, _ in use)
        cur.execute(sql, [v for _, v in use])
        while cur.description is None and cur.nextset():
            pass
        cols = [d[0].upper() for d in cur.description] if cur.description else []
        rows = [dict(zip(cols, r)) for r in cur.fetchall()] if cols else []
        self.cache[key] = rows
        return rows

    def run_bigfilter(self):
        if self.bigfilter is None:
            t = fc.read_text(BIGFILTER)
            body = t[t.find('list_line_dm'):]
            body = body[body.find('<![CDATA[') + 9:body.find(']]>')]
            sql = "SET NOCOUNT ON; DECLARE @GROUP_ID NVARCHAR(200) = ?, @USER_ID NVARCHAR(200) = ?;\n" + body
            cur = self.cx.cursor()
            cur.execute(sql, [self.group, self.user])
            sets = []
            while True:
                if cur.description:
                    cols = [d[0].upper() for d in cur.description]
                    sets.append([dict(zip(cols, r)) for r in cur.fetchall()])
                if not cur.nextset():
                    break
            self.bigfilter = sets
        return self.bigfilter


def dm_inner(asis, col, ctx):
    idx, keys = fc.DM_INNER[col]
    sets = asis.run_bigfilter()
    if idx >= len(sets):
        raise RuntimeError(f'BigFilter 결과셋 {idx} 없음(총 {len(sets)})')
    f = {k: [v for v in str(ctx.get(f'Filter.{k}', '') or '').split(',') if v and v.upper() != 'ALL'] for k in keys}
    if col == 'UserSiteByEndCustomer' and (ctx.get('Filter.DIVISION_ID') != '40' or not ctx.get('Filter.DEPT_ID')):
        f['DEPT_ID'] = []  # DataService.cs:3891-3894
    out, seen = [], set()
    for r in sets[idx]:
        if any(vals and str(r.get(k, '')) not in vals for k, vals in f.items()):
            continue
        c = str(r.get('CODE', ''))
        if c in seen:
            continue
        seen.add(c); out.append({'CODE': c, 'NAME': str(r.get('NAME', ''))})
    return sorted(out, key=lambda r: net_sort_key(r['CODE'])), True


ROW_VAR = {'DIVISION': ['DIVISION_ID'], 'DIVISIONID': ['DIVISION_ID'], 'TEAM': ['DEPT_ID', 'TEAM_ID'], 'DEPT': ['DEPT_ID', 'TEAM_ID'],
           'ENDCUSTOMER': ['END_CUSTOMER'], 'CUSTOMER': ['END_CUSTOMER'], 'SCMSITEID': ['SCM_SITE_ID'], 'SALESSITEID': ['SCM_SITE_ID'],
           'SALESITEID': ['SCM_SITE_ID'], 'ITEMID': ['ITEM_ID'], 'PROJECTCODE': ['PROJECT_CODE'], 'SALESCOMPANY': ['SALES_COMPANY']}


def resolve(expr, ctx, asis, codes_of):
    """C# 인자 식 → 값. 해석 불가면 KeyError(사유)"""
    e = (expr or '').strip()
    if e in ('', '""', 'null', 'string.Empty', 'String.Empty'):
        return ''
    m = re.fullmatch(r'"((?:[^"\\]|\\.)*)"', e)
    if m:
        return m.group(1)
    if 'NowGroupID' in e:
        return asis.group
    if re.search(r'\.UserId\b', e):
        return asis.user
    m = re.fullmatch(r'Filter\["(\w+)"\]', e)
    if m:
        return ctx.get(f'Filter.{m.group(1)}', '')
    m = re.search(r'CString\.GetCheckedListValue\w*\(\s*(\w+)\s*,\s*([\w.]+)\s*(?:,\s*(\w+))?\)', e)
    if m:
        cv = 'ALL' if m.group(3) == 'false' else resolve(m.group(2), ctx, asis, codes_of)
        if cv in ('', 'ALL'):
            return ','.join(codes_of(m.group(1)))
        return cv
    m = re.fullmatch(r'(?:this\.)?(c\w+)\.(?:ControlValues|ValueList|Value|EditValue)(?:\.ToString\(\))?', e)
    if m:
        v = ctx.get(f'ctrl.{m.group(1)}')
        return 'ALL' if v is None else v  # 초기 미선택 = "ALL"(UsrCheckedList.cs:298-307)
    m = re.fullmatch(r'(?:s|str)([A-Z]\w*)', e)
    if m:
        for k in ROW_VAR.get(norm(m.group(1)).upper(), []):
            if ctx.get(f'row.{k}'):
                return ctx[f'row.{k}']
        if ROW_VAR.get(norm(m.group(1)).upper()):
            return ''  # 행 변수가 가리키는 셀이 비어 있음 — AS-IS 도 빈 셀 값을 그대로 넘긴다(신규행 Model 미입력 등)
        raise KeyError(f'행 변수 {e} 의 셀 대응 미등록(ROW_VAR)')
    if e in ('true', 'false'):
        return e
    raise KeyError(f'인자 식 해석 불가: {e[:60]}')


def eval_filter(rows, expr, ctx, asis, codes_of):
    """DataTable.Select 식(=, <>, IN, AND) — 정적 리터럴 · 'DIVISION_ID IN (조회조건 Div)' 조립식만. 그 밖은 KeyError"""
    e = expr.split(' @')[0].strip()
    if ':=' in e:
        name, tmpl = [x.strip() for x in e.split(':=', 1)]
        if re.search(r"DIVISION_ID IN \('\"\s*\+\s*string\.Join", tmpl):
            div = ctx.get('ctrl.clbDivision', 'ALL')
            vals = codes_of('dtMyDivision') if div in ('', 'ALL') else div.split(',')
            return [r for r in rows if str(r.get('DIVISION_ID', '')) in vals]
        raise KeyError(f'필터 변수 {name} 조립식 해석 불가: {tmpl[:80]}')
    e = e.strip('"')
    if not e:
        return rows

    def one(r, cond):
        m = re.fullmatch(r"\s*(\w+)\s*(=|<>|!=)\s*'([^']*)'\s*", cond)
        if m:
            v = str(r.get(m.group(1).upper(), ''))
            return (v == m.group(3)) if m.group(2) == '=' else (v != m.group(3))
        m = re.fullmatch(r"\s*(\w+)\s+(NOT\s+)?IN\s*\(([^)]*)\)\s*", cond, re.I)
        if m:
            vals = [x.strip().strip("'") for x in m.group(3).split(',')]
            return (str(r.get(m.group(1).upper(), '')) in vals) != bool(m.group(2))
        raise KeyError(f'필터식 해석 불가: {cond[:60]}')
    parts = re.split(r'\s+AND\s+', e, flags=re.I)
    return [r for r in rows if all(one(r, c) for c in parts)]


def branch_sql(asis, sp, code):
    """AS-IS SP 원문에서 @Code 분기 SQL — 마스터 테이블·CODE 식·WHERE 컬럼(차이 설명용)"""
    cur = asis.cx.cursor()
    cur.execute("SELECT m.definition FROM sys.sql_modules m JOIN sys.objects o ON o.object_id=m.object_id WHERE o.name=?", sp)
    r = cur.fetchone()
    if not r:
        return ''
    d = r[0]
    m = re.search(r"@Code\s*=\s*'" + re.escape(code) + r"'", d, re.I)
    if not m:
        return ''
    # 분기 본문 = 조건 뒤 첫 BEGIN 부터 짝이 맞는 END 까지(주석 안의 BEGIN/END 는 제외)
    body = fc.strip_comments(d[m.end():m.end() + 60000].replace('--', '//'))
    b = re.search(r'\bBEGIN\b', body, re.I)
    if not b:
        return body[:3000]
    depth, pos = 0, b.start()
    for t in re.finditer(r'\b(BEGIN|CASE|END)\b', body[b.start():], re.I):  # CASE … END 도 짝으로 센다(FromSiteByDivision1Ex 가 CASE 의 END 에서 잘린 사고)
        depth += 1 if t.group(1).upper() in ('BEGIN', 'CASE') else -1
        if depth == 0:
            return body[b.start():b.start() + t.end()]
    return body[pos:pos + 3000]


SQL_KW = {'AND', 'OR', 'NOT', 'CODE', 'NAME', 'TOKEN', 'GROUPID', 'USERID', 'AUTHTYPE', 'NULL', 'SELECT', 'FROM', 'WHERE'}


def master_of(sql, params=None):
    """UNION 이면 SELECT 마다 해석해 공통 등호 조건만 남긴다(첫 SELECT 의 SEGMENT1 = '-' 가 전체 조건으로 번지던 오류 — 2026-10-24 CELL_PROD_SITE_ID)"""
    # CODE 를 내는 SELECT 마다 자른다(UNION·IF/ELSE 분기 모두) — 한 SELECT 에만 있는 리터럴 조건이 전체로 번지지 않게
    starts = [m.start() for m in re.finditer(r'SELECT\s+(?:DISTINCT\s+)?(?:TOP\s+\d+\s+)?[\w.\[\]]+\s+(?:AS\s+)?\[?CODE\]?\s*[,\n]', sql, re.I)]
    parts = [sql[st:(starts[i + 1] if i + 1 < len(starts) else len(sql))] for i, st in enumerate(starts)]
    if len(parts) <= 1:
        return _master_one(sql, params)
    ms = [m for m in (_master_one(x, params) for x in parts) if m]
    if not ms:
        return None
    base = dict(ms[0])
    same = [m for m in ms if m['tbl'].upper() == base['tbl'].upper()]
    base['eqs'] = {k: v for k, v in base['eqs'].items() if all(m['eqs'].get(k) == v for m in same)}
    base['wcols'] = sorted(set().union(*[set(m['wcols']) for m in same]))
    base['order'] = (_master_one(parts[-1], params) or {}).get('order') or base['order']  # ORDER BY 는 UNION 끝에 붙는다
    return base


def _master_one(sql, params=None):
    """분기 SQL → dict(tbl=CODE 원천 테이블, col=CODE 컬럼, wcols=그 테이블에서 WHERE·JOIN 이 보는 컬럼, eqs={컬럼: 값}, order=[정렬 컬럼]).
    별칭은 FROM/JOIN 절로 실제 테이블에 연결. eqs = 원천 별칭 컬럼의 등호 조건(리터럴·@ParamN), JOIN 등호를 거친 전이 포함
    (LOOKUP_TYPE 처럼 코드만으로 행이 특정되지 않는 마스터용)"""
    params = {k.upper(): v for k, v in (params or {}).items()}
    m = re.search(r'SELECT\s+(?:DISTINCT\s+)?(?:TOP\s+\d+\s+)?([\w.\[\]]+)\s+(?:AS\s+)?\[?CODE\]?\s*[,\n]', sql, re.I)
    tabs = [(t.group(1), (t.group(2) or t.group(1))) for t in re.finditer(
        r'(?:FROM|JOIN)\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?(?:\s+(?:AS\s+)?(?!WITH\b|ON\b|WHERE\b|INNER\b|LEFT\b|JOIN\b)(\w+))?', sql, re.I)]
    if not m or not tabs:
        return None
    expr = m.group(1).strip('[]')
    alias, col = (expr.split('.', 1) if '.' in expr else ('', expr))
    alias_map = {a.upper(): t for t, a in tabs}
    tbl = alias_map.get(alias.upper(), tabs[0][0]) if alias else tabs[0][0]
    if not alias and tabs[0][1] != tabs[0][0]:
        alias = tabs[0][1]  # 'SCM_SITE_ID AS CODE … FROM T AS A' — 별칭 없는 CODE 는 첫 테이블 소속
    pre = (alias + '.') if alias else ''
    pat = (re.escape(pre) if pre else r'(?<![\w.@])') + r'([A-Z][A-Z0-9_]{2,})(?:\s*(?:=|<>|!=)|\s+(?:NOT\s+)?(?:IN|LIKE|IS)\b)'
    cols = sorted({c.upper() for c in re.findall(pat, sql, re.I) if c.upper() not in SQL_KW})
    # 등호 전이 — 항 = 'ALIAS.COL' | '@PARAMn' | "'lit'"
    parent = {}

    def find(x):
        while parent.get(x, x) != x:
            x = parent[x]
        return x
    term = r"(\w+\.\w+|@\w+|'[^']*')"
    # 리터럴은 출현마다 별개 노드('Y'#3) — 같은 'Y' 를 공유하면 ATTRIBUTE1='Y'·VALID_YN='Y'·@VMI='N'(OR) 이 한 묶음이 되어
    #   마스터 조회 조건이 VALID_YN=N 으로 틀어지고 '행 없음 = 데이터 차이' 허위 PASS 가 났다(2026-10-24 DMF0082 MEASURE)
    for k, (a, b) in enumerate(re.findall(term + r'\s*=\s*' + term, sql)):
        a = f'{a}#{k}' if a.startswith("'") else a.upper()
        b = f'{b}#{k}' if b.startswith("'") else b.upper()
        if a.startswith('@') and b.startswith('@'):
            continue
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb
    eqs = {}
    if alias:
        terms = set(parent) | set(parent.values())
        for t in terms:
            if t.startswith(alias.upper() + '.'):
                root = find(t)
                grp = [x for x in terms if find(x) == root]
                lits = {x.split('#')[0] for x in grp if x.startswith("'")}
                if len(lits) > 1:
                    continue  # 한 컬럼에 서로 다른 리터럴 = OR·CASE 분기 — 등호 조건으로 쓰지 않는다
                val = next(iter(lits), None)
                if val is None:
                    pv = next((x for x in grp if x.startswith('@')), None)
                    if pv and pv in params:
                        val = f"'{params[pv]}'"
                if val is not None:
                    eqs[t.split('.', 1)[1]] = val.strip("'")
    if not alias or len(tabs) == 1:
        # 별칭 없는 단일 테이블 원문 — 'WHERE LOOKUP_TYPE = 'INCOTERMS'' 같은 맨 컬럼 등호(2026-10-24: 빠뜨려 다른 LOOKUP_TYPE 의 DISPLAY_SEQ 를 읽은 오탐)
        for c3, v3 in re.findall(r"(?<![\w.@])([A-Z_][A-Z0-9_]+)\s*=\s*('[^']*'|@\w+)", sql, re.I):
            if c3.upper() in SQL_KW:
                continue
            v = v3.strip("'") if v3.startswith("'") else params.get(v3.upper())
            if v is not None:
                eqs.setdefault(c3.upper(), v)
    om = re.search(r'ORDER\s+BY\s+(.+?)(?:\bEND\b|;|$)', sql, re.I | re.S)
    order = []
    if om:
        for part in om.group(1).split(','):
            c2 = re.sub(r'\b(?:UPPER|LOWER|LTRIM|RTRIM|ISNULL)\s*\(', '', part.strip(), flags=re.I).split(')')[0]
            c2 = re.sub(r'\s+(ASC|DESC)\b.*$', '', c2.strip(), flags=re.I | re.S).split('.')[-1].strip('[] \n\t')
            if re.fullmatch(r'\w+', c2):
                order.append(c2.upper())
    return {'tbl': tbl, 'col': col.strip('[]').upper(), 'wcols': cols, 'eqs': eqs, 'order': order}


def _master_rows(cur, dialect, mst, sel, code):
    extra = [(k, v) for k, v in mst['eqs'].items() if k != mst['col']]
    if dialect == 'mssql':
        w = ' AND '.join([f"[{mst['col']}] = ?"] + [f'[{k}] = ?' for k, _ in extra])
        cur.execute(f"SELECT TOP 1 {sel} FROM dbo.[{mst['tbl']}] WITH(NOLOCK) WHERE {w}", [code] + [v for _, v in extra])
    else:
        w = ' AND '.join([f"{mst['col']} = :p0"] + [f'{k} = :p{i + 1}' for i, (k, _) in enumerate(extra)])
        cur.execute(f"SELECT {sel} FROM {mst['tbl']} WHERE {w} AND ROWNUM = 1", [code] + [v for _, v in extra])
    return cur.fetchone()


def tobe_cols(tobe_cx, tbl):
    tc = tobe_cx.cursor()
    tc.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t", t=tbl.upper())
    return {r[0] for r in tc.fetchall()}


def asis_cols(asis, tbl):
    cur = asis.cx.cursor()
    cur.execute("SELECT UPPER(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ?", tbl)
    return {r[0] for r in cur.fetchall()}


def usable(mst, asis, tobe_cx):
    """두 DB 에 모두 있는 컬럼만 남긴 마스터 정의 — 분기 SQL 의 JOIN 이 여러 개면 컬럼 소속 추정이 틀릴 수 있다(2026-10-24 DMF0082 Invalid column)"""
    both = tobe_cols(tobe_cx, mst['tbl']) & asis_cols(asis, mst['tbl'])
    if mst['col'] not in both:
        return None, f"설명 불가({mst['tbl']}.{mst['col']} 이 두 DB 에 함께 있지 않음)"
    m2 = dict(mst)
    m2['eqs'] = {k: v for k, v in mst['eqs'].items() if k in both}
    m2['wcols'] = [c for c in mst['wcols'] if c in both]
    m2['order'] = [c for c in mst.get('order', []) if c in both] if set(mst.get('order', [])) <= both else mst.get('order', [])
    return m2, ''


def explain(diff_codes, side, mst, asis, tobe_cx, probe=None):
    """차이 코드 설명 — side='asis_only'|'tobe_only'. 반환 {code: 사유}. 마스터 행은 코드 + 원문 등호 조건(eqs)으로 특정.
    자기 검증: 두 쪽 모두 후보인 코드(probe)가 같은 조건으로 두 DB 에서 조회돼야 조건 해석을 믿는다 — 안 되면 '설명 불가'
    (조건 해석이 틀리면 모든 행이 '없음'으로 나와 데이터 차이로 허위 설명된다 — 2026-10-24 DMF0082 MEASURE)"""
    out = {}
    if not mst:
        return {c: '설명 불가(원천 마스터 테이블 해석 실패)' for c in diff_codes}
    mst, why = usable(mst, asis, tobe_cx)
    if not mst:
        return {c: why for c in diff_codes}
    if diff_codes:
        if probe is None:
            return {c: '설명 불가(공통 후보 없음 — 마스터 조건 해석을 검증할 기준 행 없음)' for c in diff_codes}
        try:
            pa = _master_rows(asis.cx.cursor(), 'mssql', mst, mst['col'], probe)
            pt = _master_rows(tobe_cx.cursor(), 'oracle', mst, mst['col'], probe)
        except Exception as ex:  # noqa: BLE001
            return {c: f'설명 불가(마스터 조회 오류 {str(ex)[:80]})' for c in diff_codes}
        if not (pa and pt):
            return {c: f"설명 불가(조건 해석 검증 실패 — 공통 후보 '{probe}' 가 {'AS-IS' if not pa else '사내'} 마스터에서 조회 안 됨)" for c in diff_codes}
    cmp_cols = [c for c in mst['wcols'] if c not in mst['eqs']]
    sel = ', '.join([mst['col']] + cmp_cols)
    ac, tc = asis.cx.cursor(), tobe_cx.cursor()
    shown = {k: v for k, v in mst['eqs'].items() if k != mst['col']}  # 코드 컬럼 자체 조건은 조회에서 빠지므로 표시에서도 뺀다
    key = mst['tbl'] + (f"({', '.join(f'{k}={v}' for k, v in shown.items())})" if shown else '')
    for c in list(diff_codes)[:60]:
        try:
            ar = _master_rows(ac, 'mssql', mst, sel, c)
            tr = _master_rows(tc, 'oracle', mst, sel, c)
        except Exception as ex:  # noqa: BLE001 — 조회 실패 = 설명 불가(판정필요), FAIL 로 몰지 않는다
            out[c] = f'설명 불가(마스터 조회 오류 {str(ex)[:80]})'
            continue
        if side == 'asis_only' and not tr:
            out[c] = f'데이터 차이(사내 {key} 에 없음)'
        elif side == 'tobe_only' and not ar:
            out[c] = f'데이터 차이(AS-IS DEV {key} 에 없음)'
        elif ar and tr:
            dif = [f'{k} {ar[i + 1]!s}→{tr[i + 1]!s}' for i, k in enumerate(cmp_cols) if str(ar[i + 1] or '') != str(tr[i + 1] or '')]
            out[c] = f'데이터 차이(속성 {", ".join(dif)[:120]})' if dif else f'조건 차이 의심 — 두 DB {key} 행이 {cmp_cols} 같음'
        else:
            out[c] = '설명 불가(마스터 행 조회 실패)'
    for c in list(diff_codes)[60:]:
        out[c] = '미검사(60건 초과)'
    return out


def _key(v):
    if v is None:
        return (0, '')
    if isinstance(v, (int, float)) or re.fullmatch(r'-?\d+(\.\d+)?', str(v)):
        return (1, float(v))
    return (2, str(v).upper())


def order_check(t_seq, a_rows, mst, asis, tobe_cx, by_code_sort, has_order=False):
    """B3 — TO-BE 표시 순서(t_seq, 공통 코드) ↔ AS-IS 정렬 기준.
    by_code_sort(GetDMInnerTable CODE 정렬) = CODE 정렬 그대로. ORDER BY 가 CODE 가 아니면 정렬 키 값 기준(동률 내부 순서는 기준 없음).
    AS-IS 키로 역전이면 사내 DB 의 키 값으로 다시 검사 — 맞으면 정렬값 데이터 차이로 설명"""
    if by_code_sort:
        want = sorted(t_seq, key=net_sort_key)
        if t_seq == want:
            return 'PASS', f'공통 {len(t_seq)}건 CODE 정렬 일치'
        i = next(i for i, (p, q) in enumerate(zip(t_seq, want)) if p != q)
        return 'FAIL', f'CODE 정렬 기준 {i + 1}번째부터 다름: TO-BE {t_seq[i:i + 4]} / 기대 {want[i:i + 4]}'
    if not mst or not mst['order']:
        if has_order:
            a_seq = list(dict.fromkeys(r['CODE'] for r in a_rows if r['CODE'] in set(t_seq)))
            ok = t_seq == a_seq
            return ('PASS' if ok else '판정필요'), f"원문 ORDER BY 있음·정렬 키 해석 불가 — AS-IS 반환 순서와 {'일치' if ok else '다름'}: TO-BE {t_seq[:5]} / AS-IS {a_seq[:5]}"
        return 'NA', 'AS-IS 원천에 정렬 근거(ORDER BY) 없음 — 순서 기준 없음'
    ob = mst['order']
    if ob[0] == mst['col']:
        a_seq = list(dict.fromkeys(r['CODE'] for r in a_rows if r['CODE'] in set(t_seq)))
        if t_seq == a_seq:
            return 'PASS', f'공통 {len(t_seq)}건 순서 일치(ORDER BY {ob})'
        i = next(i for i, (p, q) in enumerate(zip(t_seq, a_seq)) if p != q)
        return 'FAIL', f'ORDER BY {ob} 기준 {i + 1}번째부터 다름: TO-BE {t_seq[i:i + 4]} / AS-IS {a_seq[i:i + 4]}'
    m2, why = usable(mst, asis, tobe_cx)
    if not m2:
        return '판정필요', why
    mst = m2
    if not set(ob) <= (tobe_cols(tobe_cx, mst['tbl']) & asis_cols(asis, mst['tbl'])):
        return '판정필요', f"정렬 컬럼 {ob} 이 사내 {mst['tbl']} 에 없음"
    uniq = list(dict.fromkeys(t_seq))

    def keys_from(dialect, cur):
        """코드별 정렬 키 — IN 목록 500건씩 묶어 조회(코드 + 원문 등호 조건). 같은 코드 여러 행이면 첫 행"""
        ks = {}
        extra = [(k, v) for k, v in mst['eqs'].items() if k != mst['col']]
        sel = ', '.join([mst['col']] + ob)
        for i in range(0, len(uniq), 500):
            part = uniq[i:i + 500]
            if dialect == 'mssql':
                w = f"[{mst['col']}] IN ({', '.join('?' * len(part))})" + ''.join(f' AND [{k}] = ?' for k, _ in extra)
                cur.execute(f"SELECT {sel} FROM dbo.[{mst['tbl']}] WITH(NOLOCK) WHERE {w}", part + [v for _, v in extra])
            else:
                w = f"{mst['col']} IN ({', '.join(f':p{j}' for j in range(len(part)))})" + ''.join(f' AND {k} = :q{j}' for j, (k, _) in enumerate(extra))
                binds = {f'p{j}': v for j, v in enumerate(part)}
                binds.update({f'q{j}': v for j, (_, v) in enumerate(extra)})
                cur.execute(f"SELECT {sel} FROM {mst['tbl']} WHERE {w}", binds)
            for r in cur.fetchall():
                ks.setdefault(str(r[0]), tuple(_key(v) for v in r[1:]))
        return ks

    def first_inversion(ks):
        seq = [ks[c] for c in uniq if c in ks]
        return next((i for i in range(1, len(seq)) if seq[i] < seq[i - 1]), None), seq
    bad_a, _ = first_inversion(keys_from('mssql', asis.cx.cursor()))
    if bad_a is None:
        return 'PASS', f'공통 {len(uniq)}건이 ORDER BY {ob} 키 순서(동률 내부 순서는 기준 없음)'
    bad_t, st = first_inversion(keys_from('oracle', tobe_cx.cursor()))
    if bad_t is None:
        return 'PASS', f'AS-IS 키로는 {bad_a + 1}번째 역전이나 사내 {mst["tbl"]} 의 {ob} 값으로는 정렬 일치 — 데이터 차이(정렬값 시점 차이)'
    return 'FAIL', f'ORDER BY {ob} 키 기준 {bad_t + 1}번째 역전: 키 {[k[1] for k in st[max(bad_t - 1, 0)]]}→{[k[1] for k in st[bad_t]]} (사내 값 기준)'


def to_oracle_sql(q):
    """보조 조회 원문(MSSQL) → 사내(Oracle) — 단순 SELECT 만(WITH(NOLOCK)·[dbo].·대괄호·N'' 제거). TOP·함수 변환이 필요하면 None"""
    if re.search(r'\bTOP\b|ISNULL|GETDATE|CHARINDEX|STRING_SPLIT|\+\s*\'', q, re.I):
        return None
    q = re.sub(r'WITH\s*\(\s*NOLOCK\s*\)', '', q, flags=re.I)
    q = re.sub(r'\[?dbo\]?\.', '', q, flags=re.I)
    q = re.sub(r"\bN'", "'", q)
    return re.sub(r'\[(\w+)\]', r'\1', q)


def aux_checks(sql, vals, asis, tobe_cx):
    """분기 SQL 의 보조 조건을 같은 인자로 두 DB 에서 실행해 비교 — 마스터 행이 같아도 보조 테이블 데이터가 다르면 '데이터 차이'다.
    대상: SELECT @v = COL FROM T WHERE … (변수 조회) · IF (SELECT COUNT(…) FROM T WHERE …) 조건. 반환 [(설명, AS-IS 값, 사내 값)] / 실행 불가면 None"""
    up = {k.upper(): ('' if v is None else str(v)) for k, v in (vals or {}).items()}
    stmts = []
    for m in re.finditer(r'SELECT\s+@(\w+)\s*=\s*([\w.\[\]]+)\s+FROM\s+(.+?)(?=\n\s*\n|\bSELECT\b|\bIF\b|\bEND\b|\bDECLARE\b|$)', sql, re.I | re.S):
        stmts.append((f'@{m.group(1)} = {m.group(2)}', f'SELECT {m.group(2)} FROM {m.group(3).strip()}'))
    for m in re.finditer(r'\(\s*SELECT\s+COUNT\s*\(\s*[\w*]+\s*\)\s+FROM\s+(.+?)\)\s*[<>=!]', sql, re.I | re.S):
        stmts.append(('COUNT', f'SELECT COUNT(1) FROM {m.group(1).strip()}'))
    if not stmts:
        return []
    out = []
    for desc, q in stmts:
        names = re.findall(r'@\w+', q)
        if any(n.upper() not in up for n in names):
            return None  # 인자 밖 지역 변수를 본다 — 대조 불가
        ms = re.sub(r'@\w+', '?', q)
        ora = to_oracle_sql(q)
        if ora is None:
            return None
        binds = {}
        for i, n in enumerate(names):
            ora = ora.replace(n, f':a{i}', 1)
            binds[f'a{i}'] = up[n.upper()]
        try:
            ac = asis.cx.cursor(); ac.execute(ms, [up[n.upper()] for n in names]); av = [tuple(r) for r in ac.fetchall()[:5]]
            tc = tobe_cx.cursor(); tc.execute(ora, binds); tv = [tuple(r) for r in tc.fetchall()[:5]]
        except Exception:  # noqa: BLE001 — 변환·실행 실패 = 대조 불가
            return None
        out.append((f'{desc} [{re.sub(chr(10), " ", q)[:90]}]', [list(map(str, r)) for r in av], [list(map(str, r)) for r in tv]))
    return out


# DM BigFilter 결과셋별 원천 마스터(차이 설명용) — BigFilter.xml list_line_dm 원문(2026-10-24 판독). 결과셋이 UNION 이면 원천 여러 개
DM_INNER_MASTER = {
    'MyDivision': [('SCM_MST_DIVISION', 'DIVISION_ID')],
    'UserTeamByDivision': [('SCM_MST_SSO_DEPT_INFO', 'DEPT_ID')],
    'EndCustomerByDivision': [('SCM_MST_SITE_ITEM', 'PROJECT_CODE'), ('SCM_ADM_LOOKUP_MASTER_DETAIL', 'SEGMENT2'), ('SCM_MST_SITE', 'END_CUSTOMER')],
    'BizType': [('SCM_ADM_LOOKUP_MASTER_DETAIL', 'SEGMENT1'), ('SCM_MST_PROJECT', 'BIZ_TYPE')],
    'UserSiteByEndCustomer': [('SCM_MST_SITE', 'SCM_SITE_ID')],
    'UserPlantSiteByDivision': [('SCM_MST_SITE', 'SCM_SITE_ID')],
    'UserPlantSiteByEndCustomer': [('SCM_MST_SITE', 'SCM_SITE_ID')],
    'ScmSitebyEndCustomer40': [('SCM_MST_SITE', 'SCM_SITE_ID')],
}


def explain_bigfilter(col, codes, side, asis, tobe_cx):
    """BigFilter 결과셋 차이 — 원천 마스터 어디에도 상대 DB 에 없으면 데이터 차이, 있으면 '보조 조건(조인) 차이 의심'(BigFilter 는 사용자·부서 조인 → FAIL 단정 금지)"""
    srcs = DM_INNER_MASTER.get(col)
    if not srcs:
        return {c: f'설명 불가(BigFilter {col} 원천 마스터 미등록)' for c in codes}
    out = {}
    ac, tc = asis.cx.cursor(), tobe_cx.cursor()
    for c in list(codes)[:60]:
        in_a = in_t = False
        for tbl, cc in srcs:
            try:
                ac.execute(f"SELECT TOP 1 1 FROM dbo.[{tbl}] WITH(NOLOCK) WHERE [{cc}] = ?", c); in_a = in_a or bool(ac.fetchone())
                tc.execute(f"SELECT 1 FROM {tbl} WHERE {cc} = :v AND ROWNUM = 1", v=c); in_t = in_t or bool(tc.fetchone())
            except Exception:  # noqa: BLE001
                continue
        if side == 'asis_only' and not in_t:
            out[c] = f'데이터 차이(사내 원천 {[t for t, _ in srcs]} 에 없음)'
        elif side == 'tobe_only' and not in_a:
            out[c] = f'데이터 차이(AS-IS DEV 원천 {[t for t, _ in srcs]} 에 없음)'
        else:
            out[c] = f'보조 조건 차이 의심 — 두 DB 원천 {[t for t, _ in srcs]} 에 모두 있음(BigFilter 사용자·부서 조인 조건 확인)'
    for c in list(codes)[60:]:
        out[c] = '미검사(60건 초과)'
    return out


def row_specific(combos, items_codes, ctx_vals):
    """그리드 행별 재조회 응답 — 그 행 값(Division·Item 등)을 인자로 보낸 콤보 응답 중 코드가 컬럼 항목 안에 드는 것(가장 최근).
    TO-BE 그리드는 컬럼 dataMap 이 누적 표시맵이고 편집 후보는 행별 응답이다(ForecastPriceGrid.tsx:671-734)"""
    vals = [v for v in ctx_vals if v and len(v) >= 2]
    hit = None
    for c in combos:
        rows = c.get('rows') or []
        if not rows:
            continue
        body = c.get('body') or ''
        if sum(1 for v in vals if f"'{v}'" in body or f'"{v}"' in body) < 2:
            continue
        codes = [r['c'] for r in rows]
        if codes and set(codes) <= items_codes:
            hit = (c, rows)
    return hit


def to_list(rows):
    return [{'CODE': str(r.get('CODE', '') if r.get('CODE') is not None else ''), 'NAME': str(r.get('NAME', '') if r.get('NAME') is not None else '')} for r in rows]


_DISP = {}


def load_display(asis_id):
    """G7 — AS-IS 조회조건 컨트롤별 표시 열. 근거 = 01.Framework/GSCM.Windows.Forms
      UsrCheckedList·UsrCheckedList2·UsrColorCheckList : DataSource 세터가 CODE→0·NAME→1 로 재배치 후 Items.Add(row[1]) = NAME
      UsrCheckedListBox·CheckedListBox setListBox 3·4인자(string) = dr[Name] · 4인자(bool blnBeforeCheck) = dr[Code]  (CControl.cs:56-256)
      ComboBox(UsrCombo 상속) setListBox 3인자 = dr[Code] · 4인자 = Code/Name → DisplayMember NAME · 5인자 = sDisplayMember (CControl.cs:315-377)"""
    d = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', asis_id)
    types = {r['name']: r['type'].rsplit('.', 1)[-1] for r in read_csv(os.path.join(d, 'controls.csv'))}
    calls = {}
    dead = dead_methods(asis_id)  # 실행되지 않는 AS-IS 메서드의 바인딩 제외(2026-10-30 asis_live)
    for r in read_csv(os.path.join(d, 'actions.csv')):
        if (r['class'], r['method']) in dead: continue
        if r['kind'] == 'LIST_REBIND' and r['target'].endswith(('setListBox', 'setListBoxEx')):
            a = [s.strip().strip('"') for s in r['value'].strip('()').split(',')]
            if len(a) >= 2:
                calls.setdefault(a[1], (a, f"{os.path.basename(r['file'])}:{r['line']}"))
    _DISP.clear()
    _DISP.update({'types': types, 'calls': calls})


def asis_display(ctl):
    t = _DISP.get('types', {}).get(ctl, '')
    a, ref = _DISP.get('calls', {}).get(ctl, ([], ''))
    if t in ('UsrCheckedList', 'UsrCheckedList2', 'UsrColorCheckList'):
        return 'NAME', f'{t}.DataSource → row[1]=NAME'
    if t in ('UsrCheckedListBox', 'CheckedListBox') and a:
        by_code = len(a) == 4 and a[3].lower() in ('true', 'false')
        return ('CODE' if by_code else 'NAME'), f"{t} setListBox {len(a)}인자 @{ref}"
    if t in ('UsrCombo', 'ComboBox') and a:
        if len(a) >= 5:
            return a[4].upper(), f"{t} DisplayMember={a[4]} @{ref}"
        return ('CODE' if len(a) == 3 else 'NAME'), f"{t} setListBox {len(a)}인자 @{ref}"
    return '', f'컨트롤 유형 {t or "미상"} · 바인딩 {"있음" if a else "없음"}'


def match_rep(asis_rows, texts):
    """TO-BE 표시 문구가 AS-IS 의 어떤 표현(CODE·NAME·'CODE NAME')과 맞는지 — 가장 많이 맞는 표현 선택"""
    reps = {'CODE': lambda r: r['CODE'], 'NAME': lambda r: r['NAME'], 'CODE NAME': lambda r: f"{r['CODE']} {r['NAME']}",
            'CODE - NAME': lambda r: f"{r['CODE']} - {r['NAME']}", '[CODE] NAME': lambda r: f"[{r['CODE']}] {r['NAME']}"}
    ts = set(texts)
    best = max(reps, key=lambda k: sum(1 for r in asis_rows if reps[k](r) in ts))
    return best, reps[best]


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if not args:
        print(__doc__)
        return 2
    mid = args[0].upper()
    asis_id = sys.argv[sys.argv.index('--asis') + 1].upper() if '--asis' in sys.argv else mid
    src = read_csv(os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', asis_id, 'combo_src.csv'))
    rt_p = os.path.join(ROOT, 'Doc', 'verify', mid, 'combo_runtime.json')
    if not src or not os.path.exists(rt_p):
        print(f'[SKIP] {mid}: combo_src.csv({len(src)}) 또는 combo_runtime.json 없음 — facts_combosrc.py · E2E @verify 먼저')
        return 1
    rt = json.load(open(rt_p, encoding='utf-8'))
    cfg = json.load(open(E2E_CFG, encoding='utf-8-sig'))
    user = cfg.get('forceAccount') or cfg.get('defaultAccount')
    results = []
    load_display(asis_id)
    with connect('asis') as acx, connect('tobe') as tcx:
        c = acx.cursor()
        c.execute("SELECT TOP 1 GroupID FROM TB_FX_UserGroupAuthExtention WITH(NOLOCK) WHERE UserID=? ORDER BY CASE WHEN GroupID='ADMIN' THEN 0 ELSE 1 END", user)
        g = c.fetchone()
        asis = AsIs(acx, g[0] if g else 'ADMIN', user)
        by_var = {}
        for r in src:
            by_var.setdefault(r['var'], []).append(r)

        def run_source(r, ctx):
            if r['unresolved']:
                raise KeyError(r['unresolved'])
            ps = json.loads(r['args'] or '[]')
            if r['sp'] == 'STATIC':  # 화면 Rows.Add · biz 고정 목록 — 원문 순서 그대로
                rows = json.loads(next((p['expr'] for p in ps if p['n'] == 'rows'), '[]'))
                return to_list(rows), {'mst': None, 'by_code': False, 'static': True}
            if r['sp'] == 'DM_BIGFILTER':
                for p in ps:
                    if p['n'].startswith('Filter.'):
                        ctx.setdefault(p['n'], ctx.get(p['n'], ''))
                rows, _ = dm_inner(asis, r['code'], ctx)
                return rows, {'mst': None, 'by_code': True, 'bigfilter': r['code']}
            vals = {p['n']: resolve(p['expr'], ctx, asis, codes_of) for p in ps}
            if r['code'] and r['sp'].upper().startswith('UP_FX_'):
                vals['@Code'] = r['code']
            if not r['sp']:
                raise KeyError('원천 SP 없음')
            full = asis.run_sp(r['sp'], vals)
            sql = branch_sql(asis, r['sp'], r['code']) if r['code'] and r['sp'].upper().startswith('UP_FX_') else ''
            mst = master_of(sql, vals) if sql else None
            for fexpr in [f for f in (r['filters'] or '').split(' ▸ ') if f]:
                full = eval_filter(full, fexpr, ctx, asis, codes_of)  # DataTable.Select 는 원천 순서를 유지(DBUtils.cs:297/320)
            return to_list(full), {'mst': mst, 'by_code': False, 'sql': bool(sql), 'sql_text': sql, 'vals': vals, 'has_order': bool(re.search(r'ORDER\s+BY', sql, re.I))}

        def codes_of(var):
            rs = [x for x in by_var.get(var, []) if INIT_METHODS.match(x['method'] or '<field>')] or by_var.get(var, [])
            if not rs:
                return []
            try:
                rows, _ = run_source(rs[0], {})
            except Exception:  # noqa: BLE001 — 콤보 원천 CODE 목록 보조 조회 실패는 빈 목록
                return []
            return [x['CODE'] for x in rows]

        def judge(kind, target, label, cands, tobe_texts, tobe_codes, ctx, scenario):
            """한 대상 — 후보 원천(cands) 중 시나리오에 맞는 것을 실행해 TO-BE 와 비교"""
            rec = {'kind': kind, 'target': target, 'label': label, 'scenario': scenario, 'tobe_n': len(tobe_texts)}
            pairs = {(x['sp'], x['code'], x['filters'], x['args']) for x in cands}
            if not cands:
                rec.update(b4='판정필요', b3='판정필요', why='AS-IS 원천 미발견(combo_src 에 이 대상 바인딩 없음)'); return rec
            outs = []
            for x in cands:
                try:
                    rows, meta = run_source(x, dict(ctx))
                    outs.append((x, rows, meta, ''))
                except Exception as ex:  # noqa: BLE001
                    outs.append((x, None, False, str(ex)[:160]))
            ok = [o for o in outs if o[1] is not None]
            if not ok:
                rec.update(b4='판정필요', b3='판정필요', why='AS-IS 원천 실행 불가 — ' + ' / '.join(o[3] for o in outs)[:300]); return rec
            # 여러 원천(행 값 분기) — TO-BE 와 가장 가까운 원천 하나로 판정하고, 분기 원천임을 기록
            best = None
            for x, rows, meta, _ in ok:
                rep_name, rep = match_rep(rows, tobe_texts)
                a_keys = [r['CODE'] for r in rows]
                if tobe_codes is not None:
                    t_keys = tobe_codes
                else:
                    by_text = {rep(r): r['CODE'] for r in rows}
                    # 표시값 = 코드 표현이면 AS-IS 에 없는 항목도 그 문구가 곧 코드(설명 단계로 넘긴다)
                    t_keys = [by_text.get(t, t if rep_name == 'CODE' else f'?{t}') for t in tobe_texts]
                if os.environ.get('B4_MUTATE') == '1' and len(set(t_keys) & set(a_keys)) > 1:
                    gone = next(k for k in t_keys if k in set(a_keys))
                    t_keys = [k for k in t_keys if k != gone]  # 변이 시험(2026-10-28): AS-IS 후보 1개를 TO-BE 에서 뺌 → B4 FAIL 이어야
                a_only = [k for k in dict.fromkeys(a_keys) if k not in set(t_keys)]
                t_only = [k for k in dict.fromkeys(t_keys) if k not in set(a_keys)]
                score = len(a_only) + len(t_only)
                if best is None or score < best[0]:
                    best = (score, x, rows, meta, rep_name, a_keys, t_keys, a_only, t_only)
            _, x, rows, meta, rep_name, a_keys, t_keys, a_only, t_only = best
            rec.update(asis_src=f"{x['sp']} {x['code']} @{x['method']} ({x['ref'][:60]})", asis_n=len(a_keys), rep=rep_name,
                       branches=len(pairs), asis_only=a_only[:40], tobe_only=t_only[:40], asis_only_n=len(a_only), tobe_only_n=len(t_only))
            if not a_only and not t_only:
                rec['b4'] = 'PASS'; rec['why'] = f'후보 {len(a_keys)}건 집합 일치'
            else:
                mst = meta.get('mst')
                probe = next((k for k in a_keys if k in set(t_keys)), None)
                if meta.get('bigfilter'):
                    ex = {**explain_bigfilter(meta['bigfilter'], [k for k in a_only if not k.startswith('?')], 'asis_only', asis, tcx),
                          **explain_bigfilter(meta['bigfilter'], [k for k in t_only if not k.startswith('?')], 'tobe_only', asis, tcx)}
                else:
                    ex = {**explain([k for k in a_only if not k.startswith('?')], 'asis_only', mst, asis, tcx, probe),
                          **explain([k for k in t_only if not k.startswith('?')], 'tobe_only', mst, asis, tcx, probe)}
                unk = [k for k in t_only if k.startswith('?')]
                cond = {k: v for k, v in ex.items() if v.startswith('조건 차이')}
                noexp = {k: v for k, v in ex.items() if not v.startswith(('데이터 차이', '조건 차이'))}
                rec['explain'] = dict(list(ex.items())[:40])
                if unk:
                    rec['b4'] = '판정필요'; rec['why'] = f'TO-BE 표시값 {len(unk)}건을 AS-IS 코드로 환산 못 함(표현 {rep_name}) 예: {unk[:5]}'
                elif noexp and not cond:
                    rec['b4'] = '판정필요'
                    rec['why'] = f'AS-IS {len(a_keys)}건 vs TO-BE {len(t_keys)}건 · 차이 {len(noexp)}건 설명 불가: ' + '; '.join(f'{k}: {v}' for k, v in list(noexp.items())[:6])
                elif cond:
                    # 분기 SQL 이 마스터 외 테이블을 IF·EXISTS·JOIN·변수 조회로 보면, 마스터 행이 같아도 보조 테이블 데이터 차이일 수 있다 → 단정 금지
                    others = sorted({t.upper() for t in re.findall(r'(?:FROM|JOIN)\s+(?:\[?dbo\]?\.)?\[?(\w+)\]?', meta.get('sql_text', ''), re.I)
                                     if mst and t.upper() != mst['tbl'].upper()})
                    aux = aux_checks(meta.get('sql_text', ''), meta.get('vals'), asis, tcx) if others else []
                    head = (f'AS-IS {len(a_keys)}건 vs TO-BE {len(t_keys)}건 · 마스터({mst["tbl"] if mst else "-"}) 행으로 설명 안 되는 차이 {len(cond)}건: '
                            + '; '.join(f'{k}: {v}' for k, v in list(cond.items())[:6]))
                    if not others:
                        rec['b4'], rec['why'] = 'FAIL', head
                    elif aux and all(av == tv for _, av, tv in aux):
                        # 보조 조건(변수 조회·COUNT)도 두 DB 에서 같은 값 → 데이터가 아닌 조건 차이로 확정
                        rec['b4'] = 'FAIL'
                        rec['why'] = head + ' — 보조 조건 두 DB 동일: ' + '; '.join(f'{d} = {av}' for d, av, _ in aux)[:300]
                    elif aux:
                        rec['b4'] = '판정필요'
                        rec['why'] = head + ' — 보조 조건 값이 두 DB 에서 다름(데이터 차이 가능): ' + '; '.join(f'{d} AS-IS {av} / 사내 {tv}' for d, av, tv in aux if av != tv)[:300]
                    else:
                        rec['b4'] = '판정필요'
                        rec['why'] = head + f' — 원천 분기가 보조 테이블 {others[:5]} 도 조건으로 봄(자동 대조 불가): 그 데이터 차이인지 확인 필요'
                else:
                    rec['b4'] = 'PASS'; rec['why'] = f'차이 {len(ex)}건 모두 데이터 차이(AS-IS DEV↔사내 시점) — 조건 동일'
            if len(pairs) > 1:
                rec['why'] += f' · 분기 원천 {len(pairs)}종 중 가장 가까운 원천 기준(분기 선택은 C2 행에서 판정)'
            # B3 순서 — 공통 항목만(중복 제거한 표시 순서)
            common = list(dict.fromkeys(k for k in t_keys if k in set(a_keys)))
            if os.environ.get('B3_MUTATE') == '1' and len(common) > 1:
                common = common[::-1]  # 변이 시험(2026-10-28): TO-BE 표시 순서를 뒤집음 → 정렬 근거 있는 콤보는 FAIL 이어야
            if meta.get('static'):
                a_order = list(dict.fromkeys(k for k in a_keys if k in set(common)))
                rec['b3'] = 'PASS' if common == a_order else 'FAIL'
                rec['b3_why'] = f'고정 목록 순서 {"일치" if common == a_order else "다름"}: TO-BE {common[:6]} / AS-IS {a_order[:6]}'
            elif x['sp'] != 'DM_BIGFILTER' and not meta.get('sql'):
                a_order = list(dict.fromkeys(k for k in a_keys if k in set(common)))
                rec['b3'] = 'PASS' if common == a_order else '판정필요'
                rec['b3_why'] = f'전용 SP {x["sp"]} 반환 순서 {"일치" if common == a_order else "다름(원문 ORDER BY 미해석 — 사람 확인)"}: TO-BE {common[:5]} / AS-IS {a_order[:5]}'
            else:
                try:
                    rec['b3'], rec['b3_why'] = order_check(common, rows, meta.get('mst'), asis, tcx, meta.get('by_code'), meta.get('has_order', False))
                except Exception as ex2:  # noqa: BLE001
                    rec['b3'], rec['b3_why'] = '판정필요', f'정렬 키 대조 실패: {str(ex2)[:120]}'
            if kind == 'SEARCH':
                g7_check(rec, x['target'], rows, tobe_texts)
            o2_override(rec, target, label, t_keys, ctx)
            cr_scope(rec, kind, target, label)
            # Active 정책(EG055) — 코드로 비교되는 대상만. 표시값 비교(NAME)는 코드 집합과 대조할 수 없다
            if meta.get('mst') and rep_name == 'CODE' and kind not in ('CASCADE', 'GRID_CASCADE'):
                try:
                    from active_policy import judge_active, master_sets
                    ms = master_sets(tcx.cursor(), meta['mst'])
                    if ms:
                        only_y = any(re.search('만 후보', x['requirement']) for x in CRS if x['req_id'] in rec.get('cr', []))
                        reqs = [x['requirement'] for x in CRS if x['req_id'] in rec.get('cr', [])]
                        # 조회조건 '전체' 는 확정 규칙 대상(무관하게)에만 — 규칙 대상 아닌 조건(SCP0007 From Site)은 AS-IS 후보가 기준이라 재지 않는다(2026-11-02 허위 FAIL 2건)
                        if kind != 'SEARCH' or only_y or any('무관' in q for q in reqs):
                            rec['active'], rec['active_why'] = judge_active('SEARCH' if kind == 'SEARCH' else 'GRID', only_y, t_keys, ms[0], ms[1])
                            if rec['active'] == 'FAIL' and rec.get('b4') == 'PASS' and not reqs:  # AS-IS 후보와 같고 적용 확정 규칙 없음 — 결함 단정 금지
                                rec['active'], rec['active_why'] = 'ERROR', '[확인 대상] AS-IS 후보와 일치하나 정책과 다름 · ' + rec['active_why']
                except Exception as ex3:  # noqa: BLE001 — 측정 실패는 ERROR 로 남긴다
                    rec['active'], rec['active_why'] = 'ERROR', f'[측정 경로 없음] 마스터 조회 실패: {str(ex3)[:150]}'
            # 정렬: TO-BE 가 표시명 오름차순이면 AS-IS(코드·원천 정렬)와 달라도 의도된 개선일 수 있다 → 사람 확인(오탐 억제)
            if rec.get('b3') == 'FAIL':
                shown = [t for t in tobe_texts if t]
                if shown and shown == sorted(shown, key=lambda z: z.lower()):
                    rec['b3'] = '판정필요'
                    rec['b3_why'] += ' — TO-BE 는 표시명 오름차순(AS-IS 코드·원천 정렬과 다름): 의도된 정렬 개선인지 확인'
            return rec

        def g7_check(rec, ctl, rows, tobe_texts):
            """G7 조회조건 표시값 형식 — AS-IS 컨트롤이 보여주던 열(CODE/NAME)과 TO-BE 표시 문구가 같은 형식인지 · 혼용 0"""
            exp, why = asis_display(ctl)
            if not exp:
                rec['g7'], rec['g7_why'] = '판정필요', f'AS-IS 표시 열 해석 불가({ctl}: {why})'; return
            dist = [r for r in rows if r['CODE'] and r['NAME'] and r['CODE'] != r['NAME']]
            if not dist:
                rec['g7'], rec['g7_why'] = 'NA', f'AS-IS 후보 CODE=NAME(형식 구분 불가) · AS-IS 표시 {exp} ({why})'; return
            ts = {t for t in tobe_texts if not ALL_WORDS.match(t or '')}
            reps = {'CODE': lambda r: r['CODE'], 'NAME': lambda r: r['NAME'], 'CODE NAME': lambda r: f"{r['CODE']} {r['NAME']}",
                    'CODE - NAME': lambda r: f"{r['CODE']} - {r['NAME']}", '[CODE] NAME': lambda r: f"[{r['CODE']}] {r['NAME']}"}
            hits = {k: sum(1 for r in dist if f(r) in ts) for k, f in reps.items()}
            used = {k: n for k, n in hits.items() if n}
            if not used:
                rec['g7'], rec['g7_why'] = '판정필요', f'CODE≠NAME 후보 {len(dist)}건이 TO-BE 표시 문구와 한 건도 안 맞음(데이터 차이 또는 다른 형식) · AS-IS 표시 {exp}'; return
            shown = ', '.join(f'{k} {n}건' for k, n in used.items())
            if exp in used and len(used) == 1:
                rec['g7'], rec['g7_why'] = 'PASS', f'AS-IS 표시 {exp} ({why}) = TO-BE 표시 {exp} (CODE≠NAME 후보 {hits[exp]}/{len(dist)}건 확인)'
            elif exp not in used:
                ex = next(r for r in dist if any(reps[k](r) in ts for k in used))
                rec['g7'], rec['g7_why'] = 'FAIL', (f'AS-IS 표시 {exp} ({why}) ≠ TO-BE 표시 {shown} — 예: AS-IS "{reps[exp](ex)}" / TO-BE "'
                                                    + next(reps[k](ex) for k in used) + '"')
            else:
                rec['g7'], rec['g7_why'] = 'FAIL', f'TO-BE 표시 형식 혼용: {shown} (AS-IS 표시 {exp} — {why})'

        def cr_scope(rec, kind, target, label):
            """원천을 AS-IS 와 다르게 정한 확정 규칙(CR — '원천은'·'무관하게'·'만 후보')의 대상이면 AS-IS 차이를 FAIL 로 단정하지 않는다"""
            if rec.get('oracle') == 'O2':
                return
            # 대상 이름 전체로만 대조(단어 하나 'sales' 로 CR-069 Sales Plant 에 걸린 과잉 매칭 — 2026-10-24 DMF0005 SCM_SITE_ID)
            words = {w for w in (norm(label), norm(target), norm(target.replace('_ID', ''))) if len(w) >= 4}
            for cr in CRS:
                if not re.search(r'원천은|무관하게|만 후보', cr['requirement']):
                    continue
                if kind == 'SEARCH' and '조회조건' not in cr['target'] or kind == 'GRID' and not re.search(r'셀|그리드|컬럼', cr['target']):
                    continue
                tgt = norm(cr['target'])
                if any(w and w in tgt for w in words):
                    rec.setdefault('cr', []).append(cr['req_id'])
                    if rec.get('b4') == 'FAIL' or (rec.get('b4') == '판정필요' and '설명 불가' in rec.get('why', '')):
                        rec['b4'] = '판정필요'
                        rec['why'] = f"[{cr['req_id']} 확정 규칙 대상 — {cr['requirement'][:70]}] AS-IS 와의 차이가 이 규칙에 따른 변경인지 확인 · " + rec.get('why', '')

        def o2_override(rec, target, label, t_keys, ctx):
            """확정 규칙(O2)이 원천을 AS-IS 와 다르게 정한 대상 — 정답을 확정 규칙 원천으로 바꿔 다시 판정.
            Team(DEPT): confirmed_requirements '원천은 모든 화면에서 SCM_MST_SITE_ITEM(SSPM).DEPT_ID' → 같은 Division 의 SSPM DEPT_ID 집합"""
            n = norm(target) + ' ' + norm(label)
            if not re.search(r'team|dept', n):
                return
            div = ctx.get('row.DIVISION_ID') or ctx.get('Filter.DIVISION_ID') or ''
            divs = [d for d in div.split(',') if d]
            cur = tcx.cursor()

            def sspm(use_div, valid):
                ds = divs if use_div else []
                w = ' AND '.join(['DEPT_ID IS NOT NULL'] + ([f"DIVISION_ID IN ({', '.join(f':d{i}' for i in range(len(ds)))})"] if ds else [])
                                 + (["VALID_YN = 'Y'"] if valid else []))
                cur.execute(f'SELECT DISTINCT DEPT_ID FROM SCM_MST_SITE_ITEM WHERE {w}', {f'd{i}': d for i, d in enumerate(ds)})
                return {str(r[0]) for r in cur.fetchall()}
            sets = {False: sspm(True, False), True: sspm(True, True)}
            tk = {k for k in t_keys if not k.startswith('?')}
            hit = next((v for v in (False, True) if sets[v] == tk), None)
            base = f"[O2 확정 규칙: Team 원천 = SCM_MST_SITE_ITEM(SSPM).DEPT_ID, Div {divs or '전체'}] AS-IS 비교({rec.get('b4')}: {rec.get('why', '')[:120]}) 대신 확정 규칙으로 판정 — "
            all_div = [v for v in (False, True) if divs and sspm(False, v) == tk]
            if hit is not None:
                rec['b4'], rec['why'] = 'PASS', base + f"TO-BE {len(tk)}건 = SSPM DEPT_ID{'(VALID_YN=Y)' if hit else ''} {len(tk)}건 일치"
            elif all_div:
                rec['b4'] = '판정필요'
                rec['why'] = base + (f"TO-BE {len(tk)}건 = SSPM DEPT_ID 전체 Division 집합(행 Division {divs} 필터 미적용, Div {divs} 기준이면 {len(sets[False])}건). "
                                     "AS-IS 도 Division 미필터 — Div 기준 요구(결함 원장 DM-21 등)가 이 화면에도 적용되는지 확인")
            else:
                s = sets[False]
                miss, extra = sorted(s - tk)[:8], sorted(tk - s)[:8]
                rec['b4'] = 'FAIL' if extra else '판정필요'
                rec['why'] = base + f"TO-BE {len(tk)}건 vs SSPM {len(s)}건(VALID_YN=Y {len(sets[True])}) · SSPM 에 없는 TO-BE 후보 {extra} · TO-BE 에 없는 SSPM {miss}"
            rec['oracle'] = 'O2'

        # 조회조건 — 초기 상태(미선택 = ALL)
        labels = {norm(r['label']): r['label'] for r in src if r['target_kind'] == 'SEARCH' and r['label']}
        # 기준표(search_cond.csv) TO-BE 명칭 → AS-IS 명칭(예 SCP0007 Active ↔ Valid)
        for sc in read_csv(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'search_cond.csv')):
            if (sc.get('menu_id') or '').upper() == mid and sc.get('tobe_name') and sc.get('asis_name') and norm(sc['asis_name']) in labels:
                labels.setdefault(norm(sc['tobe_name']), labels[norm(sc['asis_name'])])
        # 화면 문구 → 코드: TO-BE 콤보 응답(코드·명칭 쌍) 중 가장 많이 맞는 응답으로 환산 — 세션 언어(KO/EN)와 무관하게 AS-IS 코드와 비교
        resp = [c['rows'] for c in rt.get('combos', []) if c.get('rows')]

        def to_codes(texts):
            if not texts:
                return [], 0
            best_map, best_n = {}, -1
            for rows in resp:
                m = {}
                for r in rows:
                    for k in (r['v'], r['c'], f"{r['c']} {r['v']}", f"{r['c']} - {r['v']}"):
                        m.setdefault(k, r['c'])
                n = sum(1 for t in texts if t in m)
                if n > best_n:
                    best_map, best_n = m, n
            return [best_map.get(t, f'?{t}') for t in texts], best_n

        def role(nm):
            n = norm(nm)
            if n.startswith('div'):
                return 'DIVISION_ID'
            if 'team' in n or 'dept' in n:
                return 'DEPT_ID'
            if 'endcustomer' in n or n == 'customer':
                return 'END_CUSTOMER'
            if 'salessite' in n or 'scmsite' in n:
                return 'SCM_SITE_ID'
            return ''

        def label_of(name):
            return labels.get(norm(name)) or next((v for k, v in labels.items() if k and (k in norm(name) or norm(name) in k)), '')
        # 실행 상태 = TO-BE 화면의 현재 선택값(앞 조건 선택값으로 뒤 조건을 거르는 AS-IS 연쇄 재현 — DMF0005 Division 40 기본 선택)
        sctx, sel_desc = {}, []
        for name, d in (rt.get('search') or {}).items():
            sel = [t.replace('​', '').strip() for t in (d.get('sel') or [])]
            sel = [t for t in sel if t and not ALL_WORDS.match(t)]
            rl = role(name)
            if not rl or not sel:
                continue
            codes, _ = to_codes(sel)
            codes = [c for c in codes if not c.startswith('?')]
            if not codes:
                continue
            v = ','.join(codes)
            sctx[f'Filter.{rl}'] = v
            sctx[f'row.{rl}'] = v
            for r in src:
                if r['target_kind'] == 'SEARCH' and r['label'] == label_of(name):
                    sctx[f"ctrl.{r['target']}"] = v
            sel_desc.append(f'{name}={v[:40]}')
        for name, d in (rt.get('search') or {}).items():
            texts = [t for t in d.get('opts', []) if not ALL_WORDS.match(t.strip())]
            lab = label_of(name) or label_of(d.get('label', ''))
            cands = [r for r in src if r['target_kind'] == 'SEARCH' and r['label'] == lab and INIT_METHODS.match(r['method'] or '<field>')] \
                or [r for r in src if r['target_kind'] == 'SEARCH' and r['label'] == lab]
            codes, hit = to_codes(texts)
            ctx = {k: v for k, v in sctx.items() if not k.endswith('.' + role(name))} if role(name) else dict(sctx)  # 자기 자신의 선택값으로는 거르지 않는다
            results.append(judge('SEARCH', name, lab, cands, texts, codes if hit > 0 else None, ctx,
                                 f"화면 초기(선택 {', '.join(sel_desc) or '없음=ALL'})"))
        # 상위 값으로 좁힌 하위 후보(EG081) — C1 시험 덤프의 상위 값을 ctx 에 넣어 AS-IS 원천을 재실행
        _cf = os.path.join(ROOT, 'Doc', 'verify', mid, 'combo_cascade.json')
        for cd in (json.load(open(_cf, encoding='utf-8')) if os.path.exists(_cf) else []):
            rl = role(cd['parent'])
            if not rl:
                continue
            pc, _h = to_codes([cd['picked'].strip()])
            if not pc or pc[0].startswith('?'):
                continue
            texts = [t for t in cd.get('opts', []) if t.strip() and not ALL_WORDS.match(t.strip())]
            lab = label_of(cd['child'])
            cands = [r for r in src if r['target_kind'] == 'SEARCH' and r['label'] == lab]
            codes, hit = to_codes(texts)
            ctx = {**{k: v for k, v in sctx.items() if not k.endswith('.' + (role(cd['child']) or '§'))}, f'Filter.{rl}': pc[0], f'row.{rl}': pc[0]}
            for r in src:
                if r['target_kind'] == 'SEARCH' and r['label'] == label_of(cd['parent']):
                    ctx[f"ctrl.{r['target']}"] = pc[0]
            results.append(judge('CASCADE', cd['child'], lab, cands, texts, codes if hit > 0 else None, ctx, f"상위 {cd['parent']}={pc[0]}"))
        # 상위 셀 값별 하위 셀 후보(EG088) — C2 시험 덤프의 원천 값을 행 문맥에 넣어 AS-IS 원천을 재실행
        _seen_gc = set()
        for gc in rt.get('gridCascade') or []:
            _k = (gc['src'], gc['v'], gc['tgt'])  # 같은 대상 C2 행이 여럿이면 같은 시도가 반복 기록된다
            if _k in _seen_gc:
                continue
            _seen_gc.add(_k)
            tg = [r for r in src if r['target_kind'] == 'GRID' and norm(r['target']) == norm(gc['tgt']) and (r['method'] or '') != 'SheetMeta']
            if not tg or not gc.get('cands'):
                continue
            ctx = {f'row.{k}': v for k, v in (gc.get('ctx') or {}).items()}
            ctx[f"row.{gc['src']}"] = gc['v']
            results.append(judge('GRID_CASCADE', gc['tgt'], '', tg, gc['cands'], gc['cands'], ctx, f"원천 {gc['src']}={gc['v']}"))
        # 그리드 — 신규행(Insert 경로 우선) + 기존행(EG059 · 2026-11-01 기존행 후보는 덤프만 하고 판정이 없었다 · Insert 없는 화면은 기존행이 유일한 대상)
        for b, d in (rt.get('grid') or {}).items():
            for side, dump_key, ctx_key, label in (('new', 'newRow', 'newCtx', '신규행'), ('ex', 'existing', 'exCtx', '기존행')):
                nr = d.get(dump_key) or {}
                if not nr.get('disp') and not nr.get('items'):
                    continue
                by_v = {}
                for it in nr.get('items', []):
                    by_v.setdefault(it['v'], it['c'])
                texts = [t for t in nr.get('disp', []) if t.strip()]
                codes = [by_v.get(t, f'?{t}') for t in texts]
                ctx = {f'row.{k}': v for k, v in (d.get(ctx_key) or {}).items()}
                # 행별 재조회 응답이 있으면 그것이 그 행의 편집 후보(컬럼 dataMap 은 누적 표시맵일 수 있다 — DMF0082 CELL_PROD_SITE_ID)
                rs = row_specific(rt.get('combos', []), {it['c'] for it in nr.get('items', [])}, list((d.get(ctx_key) or {}).values()))
                row_note = ''
                if rs:
                    texts, codes = [r['v'] for r in rs[1]], [r['c'] for r in rs[1]]
                    row_note = f" · TO-BE 후보 = 행별 재조회 응답 {rs[0].get('body', '')[:90]}"
                tg = [r for r in src if r['target_kind'] == 'GRID' and norm(r['target']) == norm(b)]
                ins = [r for r in tg if re.search(r'Insert', r['method'] or '', re.I)]
                non_ins = [r for r in tg if not re.search(r'Insert', r['method'] or '', re.I)]
                pool = ins if side == 'new' else non_ins
                cands = pool or [r for r in tg if (r['method'] or '') == 'SheetMeta'] or [r for r in tg if INIT_METHODS.match(r['method'] or '<field>')] or tg
                has_new = bool((d.get('newRow') or {}).get('disp') or (d.get('newRow') or {}).get('items'))
                kind = 'GRID' if side == 'new' or not has_new else 'GRID_EX'
                results.append(judge(kind, b, d.get('header', ''), cands, texts, codes, ctx, f"{label}({', '.join(f'{k}={v}' for k, v in (d.get(ctx_key) or {}).items())}){row_note}"))
    out = os.path.join(ROOT, 'Doc', 'verify', mid, 'combo_oracle.json')
    with open(out, 'w', encoding='utf-8') as f:
        json.dump({'mid': mid, 'asis_id': asis_id, 'account': user, 'group': asis.group, 'results': results}, f, ensure_ascii=False, indent=1, default=str)
    from collections import Counter
    print(f"{mid}: 콤보 {len(results)}개 — B4 {dict(Counter(r.get('b4') for r in results))} · B3 {dict(Counter(r.get('b3') for r in results))} · G7 {dict(Counter(r.get('g7') for r in results if r.get('kind') == 'SEARCH'))} → {out}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
