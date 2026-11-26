# -*- coding: utf-8 -*-
"""결과 정렬(A6) 정적 대조 — AS-IS SP ORDER BY(sort_rules.csv) ↔ TO-BE PKG 프로시저 ORDER BY(사내오라클 ALL_SOURCE 새로 조회) (2026-10-26)

  python tools/Harness/verify/sort_check.py <MENU_ID> [--asis <AS-IS ID>]   → Doc/verify/<ID>/sort_check.csv

  TO-BE 원문은 매 실행 DB 에서 새로 읽는다(hook #152 — 로컬 사본 기준 금지). PROC_M(proc_meta.csv) 로 AS-IS SP → TO-BE 프로시저를 잇는다(이 화면 → 전 화면).
  TO-BE ORDER BY 해석: 주석 제거 후 프로시저 본문의 최상위(괄호 깊이 0) 마지막 ORDER BY. 키 'CASE WHEN <cond> THEN <key> END' 는 조건부 키 —
    AS-IS 분기 가드의 리터럴('R'/'C' 등)이 cond 에 들어 있으면 그 분기에서 유효한 키로 본다(SCP0007 Input Status 분기 패턴).
  판정: PASS(분기별 키 순서 동일) · FAIL(다름) · NA(AS-IS·TO-BE 모두 ORDER BY 없음) · REVIEW(AS-IS 없음·TO-BE 있음 = 임의 정렬 추가 / 키 해석 실패 / TO-BE 프로시저 미배선)
  TO-BE 가 AS-IS 뒤에 동률 고정 키를 덧붙인 경우(접미 추가, 예 ROUTE_ID NULLS FIRST)는 PASS 에 note 로 적는다 — 결정적 순서 보장은 AS-IS 의 미정 순서보다 엄격할 뿐 다르지 않다.
"""
import csv, os, re, sys, datetime, argparse
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
DOC = os.path.join(ROOT, 'Doc')
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
csv.field_size_limit(10 ** 8)
rdcsv = lambda p: list(csv.DictReader(open(p, encoding='utf-8-sig'))) if os.path.exists(p) else []
COLS = ['menu_id', 'sp', 'asis_file', 'asis_line', 'guard', 'asis_keys', 'tobe_proc', 'tobe_last_ddl', 'tobe_order_by', 'tobe_keys', 'verdict', 'note']
tail = lambda s: re.sub(r'^(P_|UP_|SP_)', '', s.split('.')[-1].upper())


def asis_of(mid):
    for r in rdcsv(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'map_screen.csv')):
        if r.get('tobe_id', '').upper() == mid: return r['asis_id'].upper()
    return mid


# 2026-11-20 T488(SCP0028 T-653f1a5d A6 PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION · T-6dc0e2d5 A6 PR_GET_MNU_BTN_AUTH):
#   AS-IS sort_rules 에 없는 SP 는 이 검사기 행이 없어 대조표 A6 가 미검증으로 남았다. TO-BE 에서만 부르는 SP(AS-IS 경로 SP 집합에 없음)는
#   AS-IS 정렬 원천을 요구하지 않고 CR-075 로 판정한다: ① TO-BE ORDER BY 있음 → PASS(키 기록) · 없음 + 그리드 메타 있는 메뉴 배선 → FAIL
#   ③ PROC_M 배선 0 + BE 매퍼에서만 호출(그리드 비바인딩 보조 SP) → NA(호출 위치 기재). AS-IS 경로 SP 집합을 못 만들면 행을 만들지 않는다(미검증 유지).
def asis_path_sps(asis):
    """AS-IS 화면 경로 SP 이름 집합(화면 원문 + new 로 여는 팝업·폼 원문, tools/AsisLive screen_sp_universe) → (이름 집합, 접두 집합) · 못 만들면 None"""
    try:
        sys.path.insert(0, os.path.join(ROOT, 'tools', 'AsisLive'))
        from asis_live_proof_answers import screen_sp_universe
        return screen_sp_universe(asis)
    except Exception:
        return None


def be_mapper_calls(name):
    """BE MyBatis 매퍼(nscm-be/src/main/resources/**/*.xml)의 CALL [스키마.]패키지.프로시저 위치 → [(경로:줄, 패키지.프로시저, 스키마 또는 '')]"""
    import glob as _g
    out = []
    pr = name.split('.')[-1].upper()
    rx = re.compile(r'(?i)\bCALL\s+(?:(\w+)\.)?(\w+)\.(' + re.escape(pr) + r')\s*\(')
    for f in _g.glob(os.path.join(ROOT, 'nscm-be', 'src', 'main', 'resources', '**', '*.xml'), recursive=True):
        try:
            lines = open(f, encoding='utf-8', errors='replace').read().split('\n')
        except OSError:
            continue
        for i, ln in enumerate(lines, 1):
            m = rx.search(ln)
            if m: out.append((f"{os.path.relpath(f, ROOT).replace(os.sep, '/')}:{i}", f'{m.group(2).upper()}.{m.group(3).upper()}', (m.group(1) or '').upper()))
    return out


def tobe_only_verdict(has_order, wired_menus, be_locs, grid_menus, proc):
    """T488 TO-BE 전용 SP 판정(CR-075) → (판정, 사유)"""
    if has_order: return 'PASS', 'AS-IS 에 없던 ORDER BY 를 TO-BE 가 둠 — 결정적 순서(TO-BE 룰 CR-075 ①)'
    if not wired_menus and be_locs: return 'NA', f'PROC_M 배선 0(그리드 시트 바인딩 없음) · BE 매퍼 호출 {be_locs[0]} → 그리드 비바인딩 보조 SP(TO-BE 룰 CR-075 ③ 대상 아님)'
    if wired_menus and not ({m.upper() for m in wired_menus} & grid_menus): return 'NA', f"배선 메뉴 {','.join(sorted(set(wired_menus)))} 에 SHEET_COLUMNS 0 → 그리드 비바인딩(TO-BE 룰 CR-075 ③ 대상 아님)"
    if not wired_menus: return 'REVIEW', 'PROC_M 배선 0 · BE 매퍼 호출 0 — 그리드 바인딩 근거 없음'
    return 'FAIL', f'TO-BE PKG 에 ORDER BY 없음 — 그리드 표시 조회 SP 는 결정적 순서 필수(TO-BE 룰 CR-075 ①) → PKG {proc} 에 ORDER BY 추가(DB 객체 보완)'


def tobe_only_candidates(mid, done):
    """대조표 A6 SP 요소(직전 mapping_trace_instances.csv 의 이름) 중 이 검사기 행이 없는 것 · done = 이미 행이 있는 꼬리 이름 집합"""
    out = []
    for r in rdcsv(os.path.join(DOC, 'verify', mid, 'mapping_trace_instances.csv')):
        n = (r.get('name') or '').strip()
        if r.get('check') == 'A6' and r.get('et') == 'SP' and n and tail(n) not in done and n not in out: out.append(n)
    return out


def strip_comments(sql):
    from facts_sortrules import strip_comments as sc
    return sc(sql)


def proc_body(src, proc):
    """패키지 본문에서 프로시저 구간(주석 제거본)"""
    m = re.search(r'(?i)\bPROCEDURE\s+' + re.escape(proc) + r'\b', src)
    if not m: return ''
    e = re.search(r'(?i)\bEND\s+' + re.escape(proc) + r'\s*;', src[m.start():])
    return src[m.start(): m.start() + (e.end() if e else 30000)]


def tobe_order_by(body):
    """최상위(깊이 0) 마지막 ORDER BY 절 — (원문, [(key, cond|None, desc)])"""
    best = None; depth = 0; i = 0; n = len(body); up = body.upper()
    while i < n:
        c = body[i]
        if c == '(': depth += 1
        elif c == ')': depth = max(0, depth - 1)
        elif depth == 0 and up.startswith('ORDER', i) and re.match(r'ORDER\s+BY\s', up[i:i + 12]):
            j = body.find(';', i); j = n if j < 0 else j
            best = body[i:j]
            i = j; continue
        i += 1
    if not best: return '', []
    txt = re.sub(r'(?i)^ORDER\s+BY\s+', '', best.strip())
    keys = []
    # 괄호 밖 콤마로 분할
    parts = []; d = 0; cur = ''
    for ch in txt:
        if ch == '(': d += 1
        if ch == ')': d -= 1
        if ch == ',' and d == 0: parts.append(cur); cur = ''
        else: cur += ch
    parts.append(cur)
    def _unwrap(p):
        """NLSSORT(A.COL, 'NLS_SORT=…') · UPPER(COL) · NVL(COL, '/') 같은 래퍼의 첫 인자를 키로(2026-10-29 SCP0041 'NLSSORT' 가 키로 잡혀 1번째 키부터 다름 허위 FAIL)"""
        for _ in range(3):
            m = re.match(r'(?i)^(FN_ASIS_SORT_KEY|NLSSORT|UPPER|LOWER|TRIM|LTRIM|RTRIM|NVL|NVL2|COALESCE|TO_CHAR|TO_NUMBER|TO_DATE|SUBSTR|CAST|DECODE|REGEXP_REPLACE|REGEXP_SUBSTR|TRANSLATE|REPLACE|LPAD|RPAD|ROUND|TRUNC|ABS|GREATEST|LEAST|INSTR|LENGTH)\s*\((.*)$', p.strip())
            if not m: return p
            inner = m.group(2); d = 0; out = ''
            for ch in inner:
                if ch == '(': d += 1
                elif ch == ')':
                    if d == 0: break
                    d -= 1
                elif ch == ',' and d == 0: break
                out += ch
            tail_ = inner[len(out):]
            p = out.strip() + (' DESC' if re.search(r'(?i)\bDESC\b', tail_) else '')
        return p
    for p in parts:
        p = ' '.join(p.split())
        if not p: continue
        desc = bool(re.search(r'(?i)\bDESC\b', p))
        p = _unwrap(p)
        m = re.match(r'(?i)^CASE\s+WHEN\s+(.*?)\s+THEN\s+([\w.]+)\s*(?:ELSE\s+\w+\s*)?END', p)
        if m: keys.append((m.group(2).split('.')[-1].upper(), m.group(1), desc)); continue
        m = re.match(r'^([\w.]+)', p)
        if m: keys.append((m.group(1).split('.')[-1].upper(), None, desc))
        else: keys.append((p[:40], 'UNPARSED', desc))
    return best.strip(), keys


def effective(tobe_keys, guard):
    """AS-IS 분기 가드에 맞는 TO-BE 유효 키 — 조건부 키는 가드 리터럴이 cond 에 있을 때만"""
    lits = set(re.findall(r"=\s*'([^']*)'", guard or ''))
    out = []
    for k, cond, desc in tobe_keys:
        if cond is None: out.append(k + (' DESC' if desc else ''))
        elif cond == 'UNPARSED': out.append(k)
        else:
            clits = set(re.findall(r"'([^']*)'", cond))
            if lits & clits: out.append(k + (' DESC' if desc else ''))
    return dedup_adjacent(out)   # 2026-11-13 T290: 한 컬럼에 쓴 정렬 보정 식 2개 → 같은 키 연속 → 하나로


def dedup_adjacent(keys):
    """연달아 같은 키(방향 포함)는 하나로 — 떨어져 다시 나오는 같은 키는 그대로 둔다. T290"""
    out = []
    for k in keys:
        if not out or out[-1] != k:
            out.append(k)
    return out


def selftest():
    b1 = "OPEN O_RC1 FOR SELECT 1 FROM T A ORDER BY FN_ASIS_SORT_KEY(A.DIVISION_ID) NULLS FIRST , FN_ASIS_SORT_KEY(A.ITEM_ID) NULLS FIRST;"
    b2 = "OPEN O_RC1 FOR SELECT 1 FROM T A ORDER BY NLSSORT(REGEXP_REPLACE(A.DIVISION_ID, '[^[:alnum:] ]', ''), 'NLS_SORT=BINARY_CI') , NLSSORT(A.DIVISION_ID, 'NLS_SORT=BINARY_CI') , A.CUTOFF_DATE DESC , UPPER(TRANSLATE(A.ITEM_ID, '_-', '/')) NULLS FIRST , UPPER(A.ITEM_ID);"
    k1 = effective(tobe_order_by(b1)[1], ''); k2 = effective(tobe_order_by(b2)[1], '')
    cases = [('T290 FN_ASIS_SORT_KEY 로 감싼 키 = 안쪽 컬럼', k1 == ['DIVISION_ID', 'ITEM_ID']),
             ('T290 한 컬럼의 보정 식 2개 = 키 1개', k2 == ['DIVISION_ID', 'CUTOFF_DATE DESC', 'ITEM_ID']),
             ('T290 떨어져 다시 나오는 키는 유지(변이)', dedup_adjacent(['A', 'B', 'A']) == ['A', 'B', 'A']),
             ('T290 방향이 다르면 다른 키', dedup_adjacent(['A', 'A DESC']) == ['A', 'A DESC']),
             ('T290 다른 컬럼은 여전히 다름(변이)', effective(tobe_order_by("OPEN O FOR SELECT 1 FROM T ORDER BY FN_ASIS_SORT_KEY(A.SITE_ID);")[1], '') != ['DIVISION_ID']),
             ('T488 TO-BE 전용 SP ORDER BY 있음 = PASS', tobe_only_verdict(True, ['COM9'], [], {'COM9'}, 'P.X')[0] == 'PASS'),
             ('T488 PROC_M 0 + BE 매퍼만 = NA(CR-075 ③)', tobe_only_verdict(False, [], ['a.xml:3'], {'COM9'}, 'P.X')[0] == 'NA'),
             ('T488 그리드 메타 메뉴 배선 + ORDER BY 없음 = FAIL', tobe_only_verdict(False, ['COM9'], [], {'COM9'}, 'P.X')[0] == 'FAIL'),
             ('T488 배선 메뉴 그리드 메타 0 = NA', tobe_only_verdict(False, ['COM8'], [], {'COM9'}, 'P.X')[0] == 'NA'),
             ('T488 위치 근거 없음 = REVIEW', tobe_only_verdict(False, [], [], {'COM9'}, 'P.X')[0] == 'REVIEW')]
    bad = 0
    for n, ok in cases:
        print(('PASS ' if ok else 'FAIL ') + n); bad += 0 if ok else 1
    print(f'selftest {len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


_TOK = re.compile(r"'(?:[^']|'')*'|[()]|;|,|[A-Z_@#][\w@#$]*(?:\.[\w@#$\[\]]+)*|\[[^\]]*\](?:\.\[[^\]]*\])*|\d+(?:\.\d+)?|\S")
# 최상위(괄호 깊이 0·CASE 밖) 문장 시작 키워드 — 여기서 앞 문장이 끝난다
_STMT_KW = {'SELECT', 'END', 'IF', 'ELSE', 'INSERT', 'UPDATE', 'DELETE', 'SET', 'RETURN', 'DECLARE', 'BEGIN', 'EXEC', 'EXECUTE', 'OPEN', 'WITH',
            'WHILE', 'PRINT', 'RAISERROR', 'THROW', 'TRUNCATE', 'DROP', 'CREATE', 'ALTER', 'FETCH', 'CLOSE', 'DEALLOCATE', 'GOTO', 'BREAK', 'CONTINUE',
            'COMMIT', 'ROLLBACK', 'MERGE', 'USE', 'GRANT'}
_SETOP = {'UNION', 'EXCEPT', 'INTERSECT', 'MINUS'}
_AGGF = {'MIN', 'MAX', 'COUNT', 'SUM', 'AVG', 'COUNT_BIG', 'STDEV', 'VAR'}


def _stmts(toks):
    """토큰 → 최상위 문장 목록(각 문장 = 토큰 리스트). 괄호 안·CASE…END 안의 키워드는 경계로 보지 않는다"""
    out = []; cur = []; d = 0; case = 0
    for t in toks:
        if t == '(': d += 1
        elif t == ')': d -= 1
        if d == 0 and t == 'CASE': case += 1
        elif d == 0 and t == 'END' and case: case -= 1; cur.append(t); continue
        if d == 0 and not case and (t in _STMT_KW or t == ';'):
            if cur: out.append(cur)
            cur = [] if t == ';' else [t]; continue
        cur.append(t)
    if cur: out.append(cur)
    return out


def _split0(toks, sep=','):
    out = [[]]; d = 0
    for t in toks:
        if t == '(': d += 1
        elif t == ')': d -= 1
        if t == sep and d == 0: out.append([]); continue
        out[-1].append(t)
    return out


def _agg_only(item):
    """선택 항목이 집계 함수 호출·상수·연산자로만 구성(예 MIN(A)+':'+MAX(B)) — 집계 밖 컬럼·함수 참조가 하나라도 있으면 False"""
    if item and item[-1] not in (')',) and len(item) >= 2 and re.match(r'^[A-Z_][\w]*$', item[-1]):  # 별칭 제거(… AS X / … X)
        item = item[:-2] if item[-2] == 'AS' else item[:-1]
    i = 0; nagg = 0
    while i < len(item):
        t = item[i]
        if t in _AGGF and i + 1 < len(item) and item[i + 1] == '(':
            d = 0; j = i + 1
            while j < len(item):
                if item[j] == '(': d += 1
                elif item[j] == ')':
                    d -= 1
                    if d == 0: break
                j += 1
            nagg += 1; i = j + 1; continue
        if t.startswith("'") or re.fullmatch(r'\d+(?:\.\d+)?|[+\-*/|()]', t): i += 1; continue
        return False
    return nagg > 0


def _one_row(st):
    """st = SELECT 로 시작하는 최상위 문장 토큰 — 결과가 구조상 최대 1행이면 True(증명 못 하면 False)"""
    b = st[1:]
    if b[:1] == ['DISTINCT']: b = b[1:]
    if b[:2] == ['TOP', '1'] or b[:4] == ['TOP', '(', '1', ')']: return True  # TOP 1 = 최대 1행
    d = 0; f = -1
    for i, t in enumerate(b):
        if t == '(': d += 1
        elif t == ')': d -= 1
        elif d == 0 and t in ('FROM', 'INTO'): f = i; break
        elif d == 0 and t in _SETOP: return False
    if f >= 0 and b[f] == 'INTO': return False  # SELECT … INTO 테이블 — 결과 집합 아님이지만 보수적으로 증명 불가
    tail_ = b[f + 1:] if f >= 0 else []
    d = 0
    for t in tail_:
        if t == '(': d += 1
        elif t == ')': d -= 1
        elif d == 0 and t in _SETOP | {'GROUP', 'HAVING'}: return False
    if f < 0: return True  # FROM 없는 SELECT(변수·상수) = 1행
    items = _split0(b[:f])
    if items and all(_agg_only(x) for x in items): return True  # GROUP BY 없는 집계 = 정확히 1행
    if not tail_ or tail_[0] != '(': return False
    d = 0; j = 0
    for j, t in enumerate(tail_):
        if t == '(': d += 1
        elif t == ')':
            d -= 1
            if d == 0: break
    inner = tail_[1:j]; after = tail_[j + 1:]
    d = 0
    for t in after:
        if t == '(': d += 1
        elif t == ')': d -= 1
        elif d == 0 and t in ('JOIN', ',', 'APPLY', 'PIVOT', 'UNPIVOT'): return False  # 다른 행원과 결합 — 증명 불가
    inner_st = _stmts(inner)
    return len(inner_st) == 1 and inner_st[0][:1] == ['SELECT'] and _one_row(inner_st[0])


def _read_asis(rel):
    p = rel if os.path.isabs(rel or '') else os.path.join(ROOT, (rel or '').replace(chr(92), os.sep))
    try: return open(p, encoding='utf-8-sig', errors='replace').read() if rel and os.path.isfile(p) else ''
    except OSError: return ''


def single_row_result(sql):
    """2026-11-10 T204(SSP0005 A6 허위 FAIL · SCM0001_GET_SCP_PERIOD = 'MIN:MAX' 기간 1행 1열 SP 가 골든 SKIP(asis_rows 없음)으로 그리드 SP 로 판정됨):
       골든 실측 행 수가 없을 때 AS-IS 원문 구조로 결과 1행을 증명 — 결과 집합을 내는 최상위 SELECT 가 모두
       FROM 없음 · GROUP BY 없는 집계만 · TOP 1 · 단일 파생표(같은 조건 재귀)일 때만 True.
       변수 대입 SELECT @x= 는 결과 아님(제외). INSERT…SELECT · WITH · DECLARE/OPEN…FOR · UNION · JOIN · GROUP BY 는 증명 불가(False).
       PROCEDURE 가 아니면(뷰·함수) False."""
    if not sql: return False
    up = strip_comments(sql).upper()
    m = re.search(r'\bCREATE\s+(?:OR\s+ALTER\s+)?PROC(?:EDURE)?\b[\s\S]*?\bAS\b', up)
    if not m: return False
    toks = _TOK.findall(up[m.end():])
    found = 0; prev = None
    for st in _stmts(toks):
        if st[0] in ('EXEC', 'EXECUTE'): return False  # 동적 SQL·다른 SP 가 결과 집합을 낼 수 있음(DM0004_GET_SALES_SITE_DATA2 표본) — 증명 불가
        if st[0] == 'SELECT':
            if prev and prev[0] in ('INSERT', 'WITH', 'DECLARE', 'OPEN', 'MERGE') and not any(t in ('VALUES',) for t in prev): return False
            if prev and prev[-1:] and prev[-1] in _SETOP | {'ALL'}: return False
            if len(st) > 2 and st[1].startswith('@') and st[2] == '=': prev = st; continue  # 변수 대입 — 결과 집합 아님
            if len(st) > 3 and st[1] == 'TOP' and st[3].startswith('@'): prev = st; continue  # SELECT TOP 1 @x = …
            if not _one_row(st): return False
            found += 1
        prev = st
    return found > 0


def main():
    if '--selftest' in sys.argv[1:]:
        return selftest()
    ap = argparse.ArgumentParser(); ap.add_argument('menu'); ap.add_argument('--asis', default='')
    a = ap.parse_args(); mid = a.menu.upper(); asis = (a.asis or asis_of(mid)).upper()
    rules = [r for r in rdcsv(os.path.join(DOC, 'asisfacts', 'screens', asis, 'sort_rules.csv')) if r['kind'] == 'SQL']
    if not rules:
        print(f'[INFO] sort_rules.csv 없음 — facts_sortrules.py {asis} 먼저'); return 2
    pm_all = [r for r in rdcsv(os.path.join(DOC, 'tobefacts', 'db', 'proc_meta.csv')) if r.get('proc')]
    # 2026-11-19 SSP0014 미검증 해소(T358): 이름이 다른 짝(SSP0014_GET_SHIPMENT_MODEL_PIC → P_SSP0014_GET_MODEL_PIC)은 이름 비교로 못 찾아 'PROC_M 배선 없음' REVIEW(A6 미검증) → sp_pair.csv 짝 먼저
    pairs = {r.get('asis_sp', '').upper(): r.get('tobe_proc', '') for r in rdcsv(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'rules', 'sp_pair.csv')) if r.get('menu_id', '').upper() == mid and r.get('tobe_proc')}
    def tobe_proc(sp):
        _k = sp.split('.')[-1].upper()
        if pairs.get(_k) or pairs.get(tail(sp)): return pairs.get(_k) or pairs[tail(sp)]
        for scope in ([r for r in pm_all if r.get('menu_id', '').upper() == mid], pm_all):
            hit = next((r['proc'] for r in scope if tail(r['proc']) == tail(sp)), '')
            if hit: return hit
        return ''
    from dbconn import connect
    cache = {}; out = []
    with connect('tobe') as cx:
        cur = cx.cursor()
        def body_of(pkg):
            if pkg in cache: return cache[pkg]
            cur.execute("SELECT OWNER, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=pkg)
            meta = cur.fetchone()
            if not meta: cache[pkg] = ('', ''); return cache[pkg]
            cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", o=meta[0], n=pkg)
            cache[pkg] = (strip_comments(''.join(r[0] for r in cur.fetchall())), meta[1]); return cache[pkg]
        by_sp = {}
        for r in rules: by_sp.setdefault(r['sp'], []).append(r)
        # CR-075(2026-10-28 사용자): 그리드에 표시되는 조회 SP = PROC_M 의 sheet 가 SHEET_COLUMNS 메타를 가진 시트. 결과 1행 집계·룩업 SP 는 대상 아님
        grid_sheets = {r['sheet_name'] for r in rdcsv(os.path.join(DOC, 'tobefacts', 'db', 'sheet_columns.csv')) if r.get('program_id', '').upper() == mid}
        sheet_of = {tail(r['proc']): r.get('sheet', '') for r in pm_all if r.get('menu_id', '').upper() == mid}
        gold = {tail(g.get('asis_sp', '')): g for g in rdcsv(__import__('e2e_paths').golden_path(mid)) if g.get('screen', '').upper() == mid}  # 2026-11-06 화면 폴더 골든 요약 우선
        pkg_msgs = []  # MS1(메시지 의미 대조)용 — TO-BE PKG 본문이 쓰는 MSG ID
        for sp, rs in by_sp.items():
            tp = tobe_proc(sp)
            row = {'menu_id': mid, 'sp': sp, 'tobe_proc': tp}
            if not tp:
                for r in rs: out.append({**row, 'asis_file': r['file'], 'asis_line': r['line'], 'guard': r['guard'], 'asis_keys': r['keys'], 'tobe_last_ddl': '', 'tobe_order_by': '', 'tobe_keys': '', 'verdict': 'REVIEW', 'note': 'TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인'})
                continue
            pkg, proc = (tp.split('.') + [''])[:2] if '.' in tp else ('', tp)
            src, ddl = body_of(pkg) if pkg else ('', '')
            body = proc_body(src, proc) if src else ''
            ob, tkeys = tobe_order_by(body) if body else ('', [])
            asis_has = any(r['keys'] and str(r.get('depth', '0')) == '0' for r in rs)
            for r in rs:
                if r.get('depth') and str(r['depth']) != '0': continue  # 서브쿼리(TOP) 정렬은 결과 순서 규칙이 아니다
                base = {**row, 'asis_file': r['file'], 'asis_line': r['line'], 'guard': r['guard'], 'asis_keys': r['keys'], 'tobe_last_ddl': ddl, 'tobe_order_by': ' '.join(ob.split())[:2000]}  # T384(2026-11-20 SSP0014 EG-b255a2c0): 300자에서 잘려 sort_ci_check 가 마지막 키를 'NULL 먼저 없음' 으로 오판 → 2000자
                if not body: out.append({**base, 'tobe_keys': '', 'verdict': 'REVIEW', 'note': f'TO-BE 본문 없음(ALL_SOURCE {pkg}.{proc} 미발견)'}); continue
                if body and not any(m_['proc'] == proc for m_ in pkg_msgs): pkg_msgs.append({'pkg': pkg, 'proc': proc, 'msg_ids': ','.join(sorted(set(re.findall(r'MSG\d{5}', body))))})
                if not r['keys']:
                    if not tkeys:
                        sh = sheet_of.get(tail(sp), ''); g = gold.get(tail(sp), {}); nrows = int(g.get('asis_rows') or g.get('tobe_rows') or -1)
                        is_save = bool(re.search(r'(?i)_(SAVE|SET|INS|UPD|DEL|CHK|CHECK)', sp))
                        if is_save: out.append({**base, 'tobe_keys': '', 'verdict': 'NA', 'note': f"AS-IS·TO-BE 모두 ORDER BY 없음 — 저장·검증 SP(이름 {re.search(r'(?i)_(SAVE|SET|INS|UPD|DEL|CHK|CHECK)', sp).group(0)}) — 결과 순서 대상 아님(CR-075 ③)"})  # T533 문구
                        elif sh and sh not in grid_sheets: out.append({**base, 'tobe_keys': '', 'verdict': 'NA', 'note': f"AS-IS·TO-BE 모두 ORDER BY 없음 — 그리드 비바인딩 룩업 SP(PROC_M sheet '{sh}' 는 SHEET_COLUMNS 없음) → CR-075 대상 아님"})
                        elif 0 <= nrows <= 1: out.append({**base, 'tobe_keys': '', 'verdict': 'NA', 'note': f'AS-IS·TO-BE 모두 ORDER BY 없음 — 결과 {nrows}행 집계 SP → CR-075 대상 아님'})
                        elif nrows < 0 and single_row_result(_read_asis(r['file'])): out.append({**base, 'tobe_keys': '', 'verdict': 'NA', 'note': 'AS-IS·TO-BE 모두 ORDER BY 없음 — 골든 행 수 없음 · AS-IS 원문 구조상 결과 1행(GROUP BY 없는 집계/FROM 없는 SELECT/단일 파생표) → CR-075 ③ 대상 아님(T204)'})
                        else: out.append({**base, 'tobe_keys': '', 'verdict': 'FAIL', 'note': f"TO-BE PKG 에 ORDER BY 없음(AS-IS 도 없음) — 그리드 표시 조회 SP 는 결정적 순서 필수(TO-BE 룰 CR-075 · 사용자 판정 2026-10-28) → PKG {pkg}.{proc} 에 ORDER BY 추가(DB 객체 보완)"})
                    elif 'ORDER BY 없음' in r['note']: out.append({**base, 'tobe_keys': ','.join(effective(tkeys, '')), 'verdict': 'PASS', 'note': 'AS-IS 에 없던 ORDER BY 를 TO-BE 가 추가 — 결정적 순서(TO-BE 룰 CR-075 충족인'})
                    else: out.append({**base, 'tobe_keys': ','.join(effective(tkeys, r['guard'])), 'verdict': 'REVIEW', 'note': 'AS-IS 키 해석 실패 — 원문 확인: ' + r['raw'][:120]})
                    continue
                eff = effective(tkeys, r['guard']); want = [k.strip().upper() for k in r['keys'].split(',') if k.strip()]
                if eff == want: v, note = 'PASS', '분기 키 순서 동일' + (f" (가드 {r['guard'][:60]})" if r['guard'] else '')
                elif eff[:len(want)] == want: v, note = 'PASS', f"AS-IS 키 뒤에 동률 고정 키 추가 {eff[len(want):]} — 순서 보장 강화(다르지 않음)"
                else:
                    # 어디서 갈리는지
                    i = next((k for k in range(min(len(eff), len(want))) if eff[k] != want[k]), min(len(eff), len(want)))
                    v, note = 'FAIL', f"{i + 1}번째 키부터 다름: AS-IS {want[i:i + 3]} ↔ TO-BE {eff[i:i + 3]}" + (' · TO-BE 키 부족' if len(eff) < len(want) else '')
                out.append({**base, 'tobe_keys': ','.join(eff), 'verdict': v, 'note': note})
        # T488 TO-BE 전용 SP(AS-IS 경로 SP 집합에 없음) — CR-075 ①·③ 로 판정
        done = {tail(x['sp']) for x in out} | {tail(x['tobe_proc']) for x in out if x.get('tobe_proc')}
        cands = tobe_only_candidates(mid, done)
        uni = asis_path_sps(asis) if cands else None
        paired = {tail(v) for v in pairs.values()}
        grid_menus = None
        for n in cands:
            if uni is None: break
            full, pre = uni
            t = tail(n)
            if t in {tail(x) for x in full} or any(t.startswith(tail(p)) for p in pre) or t in paired: continue  # AS-IS 경로에 있음 → 이 규칙 대상 아님(종전대로)
            wired = [r for r in pm_all if tail(r['proc']) == t]
            tp = n if '.' in n else (wired[0]['proc'] if wired else '')
            be = [] if wired else be_mapper_calls(n)
            if not tp and be: tp = be[0][1]
            ev = f"TO-BE 전용 SP — AS-IS 경로 SP 집합(화면·팝업 원문 {len(full)}종)에 {t} 없음"
            base = {'menu_id': mid, 'sp': n, 'asis_file': '', 'asis_line': '', 'guard': '', 'asis_keys': '', 'tobe_proc': tp, 'tobe_last_ddl': '', 'tobe_order_by': ''}
            if not tp: out.append({**base, 'tobe_keys': '', 'verdict': 'REVIEW', 'note': ev + ' · TO-BE 프로시저 위치 못 찾음(PROC_M·BE 매퍼 0)'}); continue
            pkg, proc = tp.split('.')[-2:] if '.' in tp else ('', tp)
            src, ddl = body_of(pkg.upper()) if pkg else ('', '')
            body = proc_body(src, proc) if src else ''
            base['tobe_last_ddl'] = ddl
            if not body: out.append({**base, 'tobe_keys': '', 'verdict': 'REVIEW', 'note': ev + f' · TO-BE 본문 없음(ALL_SOURCE {pkg}.{proc} 미발견)'}); continue
            ob, tkeys = tobe_order_by(body)
            if grid_menus is None: grid_menus = {(g.get('program_id') or '').upper() for g in rdcsv(os.path.join(DOC, 'tobefacts', 'db', 'sheet_columns.csv'))}
            v, why = tobe_only_verdict(bool(tkeys), [w.get('menu_id', '') for w in wired], [x[0] for x in be], grid_menus, f'{pkg}.{proc}')
            out.append({**base, 'tobe_order_by': ' '.join(ob.split())[:2000] if tkeys else '', 'tobe_keys': ','.join(effective(tkeys, '')) if tkeys else '', 'verdict': v, 'note': ev + ' · ' + why})
    od = os.path.join(DOC, 'verify', mid); os.makedirs(od, exist_ok=True)
    with open(os.path.join(od, 'tobe_pkg_msgs.csv'), 'w', encoding='utf-8-sig', newline='') as fp:  # MS1 메시지 의미 대조(judge) 입력
        w = csv.DictWriter(fp, fieldnames=['pkg', 'proc', 'msg_ids']); w.writeheader(); w.writerows(pkg_msgs)
    p = os.path.join(od, 'sort_check.csv')
    with open(p, 'w', encoding='utf-8-sig', newline='') as fp:
        w = csv.DictWriter(fp, fieldnames=COLS); w.writeheader(); [w.writerow({k: x.get(k, '') for k in COLS}) for x in out]
    import collections
    c = collections.Counter(x['verdict'] for x in out)
    print(f"{mid}: 정렬 대조 {len(out)}행 — " + ' · '.join(f'{k} {v}' for k, v in c.most_common()) + f" (TO-BE 원문 ZIOUI1 {datetime.datetime.now():%Y-%m-%d %H:%M} 조회) → {p}")
    for x in out:
        if x['verdict'] != 'PASS': print(f"  [{x['verdict']}] {x['sp']} → {x['tobe_proc']} | AS-IS {x['asis_keys'][:60]} | TO-BE {x['tobe_keys'][:60]} | {x['note'][:100]}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
