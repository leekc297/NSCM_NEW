# -*- coding: utf-8 -*-
"""문자 정렬 키의 대소문자 무시·NULL 먼저 점검(2026-11-02 엔진 갭 EG034)

  python tools/Harness/verify/sort_ci_check.py <MENU_ID>   → Doc/verify/<ID>/sort_ci.csv (eg_ingest 가 A6 행으로 반입)
  python tools/Harness/verify/sort_ci_check.py --selftest   판정 변이 입증

  입력: sort_check.csv 의 TO-BE ORDER BY · 키의 자료형은 ALL_TAB_COLUMNS(같은 이름 컬럼 전체)에서 — 문자형으로만 나올 때 문자 키로 본다
  기준: AS-IS SQL Server = 대소문자 무시 콜레이션 · 오름차순 NULL 먼저 → TO-BE 문자 키는 UPPER/LOWER/NLSSORT 와 NULLS FIRST(또는 NVL) 필요
  판정: 사용자 결정(정렬 기준 차이 = 판정필요)에 따라 누락은 FAIL 이 아니라 판정필요 · 자료형 모름은 대상에서 빼고 건수만 남긴다
"""
import csv, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
csv.field_size_limit(10 ** 8)
COLS = ['proc', 'result', 'why', 'order_by']
TEXT = {'VARCHAR2', 'NVARCHAR2', 'CHAR', 'NCHAR', 'CLOB'}


def split_keys(order_by):
    txt = re.sub(r'(?is)^\s*ORDER\s+BY\s+', '', order_by or '').strip().rstrip(';')
    parts, d, cur = [], 0, ''
    for ch in txt:
        d += (ch == '(') - (ch == ')')
        if ch == ',' and d == 0:
            parts.append(cur); cur = ''
        else:
            cur += ch
    if cur.strip():
        parts.append(cur)
    return [' '.join(p.split()) for p in parts]


def key_of(part):
    """래퍼 안의 첫 컬럼 이름(별칭 제외)"""
    names = [x for x in re.findall(r'(?:\b\w+\.)?\b([A-Za-z_][A-Za-z0-9_]{2,})\b(?!\s*\()', re.sub(r"'[^']*'", '', part)) if x.upper() not in ('NULLS', 'FIRST', 'LAST', 'DESC', 'ASC', 'CASE', 'WHEN', 'THEN', 'ELSE', 'END', 'NLS_SORT', 'BINARY_CI') and not x.upper().startswith(('P_', 'V_'))]  # P_·V_ = 프로시저 인자·변수(CASE 조건)
    return names[0].upper() if names else ''


def check_part(part):
    """(대소문자 무시, NULL 먼저) — 내림차순은 NULL 위치 기준이 달라 NULL 칸을 보지 않는다"""
    ci = bool(re.search(r'(?i)\b(UPPER|LOWER)\s*\(|BINARY_CI|GENERIC_M_CI', part))
    desc = bool(re.search(r'(?i)\bDESC\b', part))
    nf = desc or bool(re.search(r'(?i)NULLS\s+FIRST|\bNVL\s*\(|\bCOALESCE\s*\(', part))
    return ci, nf


def judge(parts, is_text, nullable=lambda k: True, moot=None):
    """parts ORDER BY 키 원문 · is_text(key) True 문자 / False 비문자 / None 모름
    2026-11-25 T546 moot(k, part, need) → (ok, 근거 문구, 'src'|'data'|'') · need 'ci'(대소문자 무시) / 'nf'(NULL 먼저) 가 원문에 없을 때만 부른다.
      src  = 쓰기 경로 전부 UPPER 증명(원문 인용) → 그 칸은 대소문자 차이가 생길 수 없음
      data = TO-BE 원본 표 실측(소문자·NULL 0행) → 실측 기준 차이 없음
      판정: 남은 누락 있음 = 판정필요(종전) · data 근거 사용 = PASS(데이터 실측 명시) · src 근거만 = NA(근거 인용) · 근거 미사용 = PASS(종전)"""
    if not parts:
        return 'NA', 'ORDER BY 없음'
    bad, unk, n, tie, cut, done = [], [], 0, [], [], set()
    basis, kinds = {}, set()
    for p in parts:
        # 2026-11-20 T384(SSP0014 EG-b255a2c0): 괄호가 닫히지 않은 키 = 원문 잘림(sort_check.csv 300자) — 잘린 글자로 판정하지 않고 따로 적는다
        if p.count('(') != p.count(')'):
            cut.append(key_of(p) or p[:30]); continue
        k = key_of(p); t = is_text(k)
        if t is None:
            unk.append(k or p[:30]); continue
        if not t:
            continue
        ci, nf = check_part(p)
        try:  # 2026-11-20 T433: 키 원문(p)을 넘겨 원본 표의 칸으로 NULL 가능 여부를 본다 · 키만 받는 함수(시험)는 종전대로
            nn = nullable(k, p)
        except TypeError:
            nn = nullable(k)
        nf = nf or not nn  # NOT NULL 컬럼은 NULL 위치가 없다
        # T384: 같은 칸을 앞에서 대소문자 무시·NULL 먼저로 이미 정렬했으면 뒤의 원래 값 키는 동률 해소 키(순서 결정에 대소문자 무시를 깨지 않음)
        if k in done:
            tie.append(k); continue
        n += 1
        if moot is not None:  # T546 원문에 없는 항목 = 원본 표 근거(쓰기 경로 UPPER · 데이터 실측)로 차이 발생 여부 확인
            for need in [x for x, ok in (('ci', ci), ('nf', nf)) if not ok]:
                ok_, why_, kind_ = moot(k, p, need)
                if why_:
                    basis.setdefault(why_, []).append(k)
                if ok_:
                    kinds.add(kind_)
                    ci, nf = (True, nf) if need == 'ci' else (ci, True)
        miss = [x for x, ok in (('대소문자 무시', ci), ('NULL 먼저', nf)) if not ok]
        if miss:
            bad.append(f"{k}({'·'.join(miss)} 없음)")
        else:
            done.add(k)
    btxt = (' · 근거: ' + ' / '.join(f"{'·'.join(dict.fromkeys(ks))} {w}" for w, ks in basis.items())) if basis else ''  # T546
    tail = (f" · 자료형 모름 {len(unk)}건({', '.join(unk[:4])})" if unk else '') + (f" · 동률 해소 키 {len(tie)}건({', '.join(tie[:4])})" if tie else '')         + (f" · [측정 경로 누락] 원문 잘림 {len(cut)}건({', '.join(cut[:4])}) — 판정 제외" if cut else '')
    if bad:
        return '판정필요', f'[SORT 기준 차이 → 판정필요] 문자 키 {len(bad)}/{n}건 AS-IS 콜레이션과 다를 수 있음: {", ".join(bad[:6])}{tail}{btxt}'
    if cut:
        return 'ERROR', f'문자 키 {n}건 대소문자 무시·NULL 먼저{tail}{btxt}'
    if not n:
        return 'NA', f'문자 정렬 키 없음{tail}'
    if 'data' in kinds:  # T546 실측 근거 사용 = PASS(데이터 실측 명시 · 데이터가 바뀌면 다시 재야 함)
        return 'PASS', f'문자 키 {n}건 대소문자 무시·NULL 먼저 — ORDER BY 에 없는 항목은 TO-BE 원본 표 데이터 실측으로 차이 0 확인(CR-075 ④){tail}{btxt}'
    if 'src' in kinds:  # T546 원문 근거만 = 정렬 차이 발생 불가 → NA
        return 'NA', f'문자 키 {n}건 — ORDER BY 에 없는 항목은 원문 근거로 차이 발생 불가(CR-075 ④ 대상 아님){tail}{btxt}'
    return 'PASS', f'문자 키 {n}건 대소문자 무시·NULL 먼저{tail}'


_KW = {'SELECT', 'FROM', 'WHERE', 'AND', 'OR', 'ON', 'JOIN', 'LEFT', 'RIGHT', 'INNER', 'OUTER', 'FULL', 'TABLE', 'DUAL', 'AS', 'BY', 'GROUP', 'ORDER', 'UNION', 'ALL', 'DISTINCT', 'CASE', 'WHEN', 'THEN', 'ELSE', 'END', 'NOT', 'IN', 'IS', 'NULL', 'EXISTS'}


def strip_sql(t):
    """주석·문자열 제거(-- 와 /* */ · 'x' → '')"""
    t = re.sub(r'/\*.*?\*/', ' ', t or '', flags=re.S)
    t = re.sub(r'--[^\n]*', ' ', t)
    return re.sub(r"'(?:[^']|'')*'", "''", t)


def stmt_before(body, order_by):
    """2026-11-20 T433: 프로시저 본문에서 이 ORDER BY 가 붙은 문장(앞 ';' 뒤 ~ ORDER BY 앞, 공백 한 칸으로 편 글자). 못 찾으면 ''"""
    head = ' '.join(re.sub(r'(?is)^\s*ORDER\s+BY\s+', '', strip_sql(order_by)).split())[:60]
    if not head:
        return ''
    flat = ' '.join(strip_sql(body).split())
    i = flat.upper().find('ORDER BY ' + head.upper())
    if i < 0:
        return ''
    return flat[flat.rfind(';', 0, i) + 1:i]


def key_source(stmt, part, _depth=0):
    """2026-11-20 T433(SCP0028 EG-78281d4c A6 'NULL 먼저 없음' 판정필요): 정렬 키 → (원본 표, 원본 칸, 바깥 조인 여부).
    키에 별칭이 있으면(A.COL) 그 별칭, 없으면 문장 안 'X.COL AS KEY' · 'X.KEY,' 선택 목록에서 별칭을 찾는다.
    별칭이 표 이름에 붙어 있을 때만 결과를 낸다(부분 질의·표 함수 별칭은 None). 바깥 조인 'X.c(+)' · LEFT/RIGHT/FULL JOIN 이면 outer=True"""
    if not stmt:
        return None
    k = key_of(part)
    if not k:
        return None
    m = re.search(r'\b([A-Za-z_]\w*)\.([A-Za-z_]\w*)\b', re.sub(r"'[^']*'", '', part))
    if m and m.group(2).upper() == k:
        al, col = m.group(1).upper(), k
    else:
        m2 = re.search(r'\b([A-Za-z_]\w*)\.("?)([A-Za-z_]\w*)\2\s+AS\s+"?' + re.escape(k) + r'\b', stmt, re.I)
        m3 = None if m2 else re.search(r'\b([A-Za-z_]\w*)\.' + re.escape(k) + r'\s*(?:,|\bFROM\b)', stmt, re.I)
        if m2:
            al, col = m2.group(1).upper(), m2.group(3).upper()
        elif m3:
            al, col = m3.group(1).upper(), k
        else:
            return None
    tm = None
    for t in re.finditer(r'(?:\bFROM|\bJOIN|,)\s+([A-Za-z_][\w$#]*(?:\.[A-Za-z_][\w$#]*)?)\s+' + re.escape(al) + r'\b(?!\s*\.)', stmt, re.I):
        if t.group(1).upper() not in _KW:
            tm = t
    if not tm:
        # 2026-11-25 T546 (SCP0005 EG-9afd4a78·EG-89828767·EG-e6b3240d): 별칭이 부분 질의 '( SELECT … ) T' 이면 원본 표를 못 찾아
        #   같은 이름 칸 아무 표의 NULL 가능 여부로 판정했다 → 안쪽 SELECT 에서 같은 칸을 다시 추적(3단까지). 못 찾으면 종전대로 None
        dm = None
        for d in re.finditer(r'\)\s*(?:AS\s+)?' + re.escape(al) + r'\b(?!\s*\.)', stmt, re.I):
            dm = d
        if not dm or _depth >= 3:
            return None
        e, dep, st0 = dm.start(), 0, -1
        for i in range(e, -1, -1):
            if stmt[i] == ')':
                dep += 1
            elif stmt[i] == '(':
                dep -= 1
                if dep == 0:
                    st0 = i; break
        inner = stmt[st0 + 1:e] if st0 >= 0 else ''
        if not re.match(r'\s*SELECT\b', inner, re.I):
            return None
        sub = key_source(inner, col, _depth + 1)
        if not sub:
            return None
        douter = bool(re.search(r'\b' + re.escape(al) + r'\.\w+\s*\(\+\)', stmt, re.I)) or bool(re.search(r'\b(LEFT|RIGHT|FULL)\s+(OUTER\s+)?JOIN\s*$', stmt[:st0], re.I))
        return sub[0], sub[1], sub[2] or douter
    outer = bool(re.search(r'\b' + re.escape(al) + r'\.\w+\s*\(\+\)', stmt, re.I)) or bool(re.search(r'\b(LEFT|RIGHT|FULL)\s+(OUTER\s+)?JOIN\s+' + re.escape(tm.group(1)) + r'\s+' + re.escape(al) + r'\b', stmt, re.I))
    return tm.group(1).upper().split('.')[-1], col, outer


# 2026-11-25 T546 (SCP0005 EG-9afd4a78·EG-89828767 A6 문자 정렬 '대소문자 무시 없음'): 정렬 키 원본 칸의 쓰기 경로(INSERT·UPDATE)가 전부 UPPER 면
#   그 칸에는 소문자가 저장될 수 없어 대소문자 무시 여부가 순서를 바꾸지 못한다. AS-IS 원문(Doc/asisfacts/db/modules) · TO-BE 원문(ALL_SOURCE) 양쪽에서
#   그 표에 쓰는 문장을 모두 찾아 칸 값 식이 UPPER(…)·대문자 리터럴·NULL 인지 본다. 해석 못 한 쓰기(MERGE·SELECT INTO·칸 목록 없는 INSERT)가 하나라도 있거나
#   한쪽 쓰기가 0곳이면 증명 실패(종전 판정 · 데이터 실측으로 넘어감).
_STOP_SET = {'WHERE', 'FROM', 'OUTPUT', 'RETURNING', 'END', 'IF', 'ELSE', 'BEGIN', 'INSERT', 'UPDATE', 'DELETE', 'SELECT', 'EXEC', 'EXECUTE', 'DECLARE', 'RETURN', 'COMMIT', 'MERGE', 'OPEN', 'WHILE'}
_TOKRX = re.compile(r"N?'(?:[^']|'')*'|\(|\)|;|\b\w+\b")


def _tblrx(t):
    return r'(?<![\w$#.\[])(?:\[?\w+\]?\.)?\[?' + re.escape(t) + r'\]?(?![\w$#])'


def _strip_keep(t):
    """주석 제거(줄 수 유지) · 문자열은 남긴다"""
    t = re.sub(r'/\*.*?\*/', lambda m: '\n' * m.group(0).count('\n'), t or '', flags=re.S)
    return re.sub(r'--[^\n]*', '', t)


def _top_stop(s, stops):
    """최상위(괄호·CASE 밖) 첫 stops 낱말 또는 ';' 위치 · 없으면 len(s)"""
    dep = case = 0
    for m in _TOKRX.finditer(s):
        tk = m.group(0); up = tk.upper()
        if tk == '(':
            dep += 1
        elif tk == ')':
            dep -= 1
            if dep < 0:
                return m.start()
        elif dep == 0 and up == 'CASE':
            case += 1
        elif dep == 0 and up == 'END' and case:
            case -= 1
        elif dep == 0 and not case and (tk == ';' or up in stops):
            return m.start()
    return len(s)


def _split_top(s):
    out, dep, cur, q = [], 0, '', False
    for ch in s:
        if ch == "'":
            q = not q
        if not q:
            dep += (ch == '(') - (ch == ')')
            if ch == ',' and dep == 0:
                out.append(cur); cur = ''; continue
        cur += ch
    out.append(cur)
    return [x.strip() for x in out]


def _close(s, i):
    dep, q = 0, False
    for j in range(i, len(s)):
        ch = s[j]
        if ch == "'":
            q = not q
        elif not q and ch == '(':
            dep += 1
        elif not q and ch == ')':
            dep -= 1
            if dep == 0:
                return j
    return -1


def _is_upper(e):
    e = (e or '').strip()
    if re.fullmatch(r'(?i)NULL', e) or re.fullmatch(r"N?'[^a-z']*'", e):
        return True
    m = re.match(r'(?i)UPPER\s*\(', e)
    return bool(m) and _close(e, m.end() - 1) == len(e) - 1


def _set_sites(t, start, col, ln, at):
    body = t[start:]
    items = _split_top(body[:_top_stop(body, _STOP_SET)])
    out = []
    for it in items:
        m = re.match(r'(?s)\s*(?:[\w\[\]"]+\.)?[\["]?(\w+)[\]"]?\s*=\s*(.*)$', it)
        if m and m.group(1).upper() == col:
            out.append((ln(at), 'UPDATE', m.group(2).strip()))
        elif not m and re.search(r'\b' + re.escape(col) + r'\b', it, re.I):
            out.append((ln(at), 'UPDATE', None))
    return out


def write_sites(text, table, col):
    """원문 text 에서 table.col 에 값을 쓰는 곳 → [(줄, 종류, 값 식 · 해석 실패 None)] (그 칸을 안 쓰는 문장은 빠짐)"""
    t = _strip_keep(text); T = _tblrx(table); C = col.upper(); out = []
    ln = lambda i: t.count('\n', 0, i) + 1
    for m in re.finditer(r'(?i)\bINSERT\s+(?:INTO\s+)?' + T, t):
        k = re.match(r'\s*\(', t[m.end():])
        if not k:
            out.append((ln(m.start()), 'INSERT', None)); continue
        p0 = m.end() + k.end() - 1; p1 = _close(t, p0)
        if p1 < 0:
            out.append((ln(m.start()), 'INSERT', None)); continue
        cols = [re.sub(r'[\[\]"\s]', '', x).split('.')[-1].upper() for x in _split_top(t[p0 + 1:p1])]
        if C not in cols:
            continue
        rest = t[p1 + 1:]
        v = re.match(r'(?is)\s*VALUES\s*\(', rest)
        if v:
            q0 = p1 + 1 + v.end() - 1; q1 = _close(t, q0)
            items = _split_top(t[q0 + 1:q1]) if q1 > 0 else []
        else:
            sm = re.match(r'(?is)\s*SELECT\s+(?:DISTINCT\s+)?', rest)
            if not sm:
                out.append((ln(m.start()), 'INSERT', None)); continue
            b = rest[sm.end():]
            items = [re.sub(r'(?is)\s+(?:AS\s+)?"?\w+"?$', '', x) if re.search(r'\)\s*(?:AS\s+)?"?\w+"?$|\s+AS\s+"?\w+"?$', x, re.I) else x
                     for x in _split_top(b[:_top_stop(b, {'FROM', 'WHERE', 'UNION', 'GROUP', 'ORDER'} | (_STOP_SET - {'END'}))])]
        if len(items) != len(cols):
            out.append((ln(m.start()), 'INSERT', None)); continue
        out.append((ln(m.start()), 'INSERT', items[cols.index(C)]))
    for m in re.finditer(r'(?i)\bUPDATE\s+' + T + r'(?:\s+(?:AS\s+)?(?!SET\b)\w+)?\s+SET\b', t):
        out += _set_sites(t, m.end(), C, ln, m.start())
    for m in re.finditer(r'(?i)\bUPDATE\s+(\w+)\s+SET\b', t):  # MSSQL 'UPDATE 별칭 SET … FROM 표 별칭'
        al = m.group(1)
        if al.upper() == table.upper():
            continue
        seg = t[m.end():m.end() + _top_stop(t[m.end():], {'INSERT', 'UPDATE', 'DELETE', 'MERGE'})]
        if re.search(r'(?is)\bFROM\b.*?' + T + r'\s+(?:AS\s+)?' + re.escape(al) + r'\b', seg):
            out += _set_sites(t, m.end(), C, ln, m.start())
    for m in re.finditer(r'(?i)\bMERGE\s+(?:INTO\s+)?' + T, t):
        out.append((ln(m.start()), 'MERGE', None))
    for m in re.finditer(r'(?i)\bINTO\s+' + T, t):
        if not re.search(r'(?i)\b(INSERT|MERGE)\s+$', t[max(0, m.start() - 30):m.start()]):
            out.append((ln(m.start()), 'SELECT INTO', None))
    return out


def upper_proof(table, col, asis_docs, tobe_docs):
    """asis_docs·tobe_docs = [(인용 이름, 원문)] → (증명 여부, 근거 문구)"""
    res, bad = {}, []
    for side, docs in (('AS-IS', asis_docs), ('TO-BE', tobe_docs)):
        by = {}
        for name, txt in docs:
            for line, kind, e in write_sites(txt, table, col):
                by.setdefault(name, []).append(line)
                if e is None or not _is_upper(e):
                    bad.append(f"{side} {name}:{line} {kind} {(e or '해석 실패')[:40]}")
        res[side] = by
    cite = ' · '.join(f"{side} 쓰기 {sum(len(v) for v in by.values())}곳(" + ', '.join(f"{n}:{','.join(map(str, ls))}" for n, ls in by.items()) + ')' for side, by in res.items())
    if bad:
        return False, f"UPPER 아닌 쓰기 {len(bad)}곳({'; '.join(bad[:3])}) · {cite}"
    if not all(res.values()):
        return False, f"쓰기 경로 못 찾은 쪽 있음 · {cite}"
    return True, f"쓰기 경로 전부 UPPER — {cite}"


def unbound_lookup(proc_sheets, grid_cols, result_cols):
    """2026-11-25 T549 (SCP0005 EG-58b590c3 P_SCP0005_GET_COUNTRY_CITY): CR-075 ③ '그리드에 바인딩되지 않는 룩업·보조 SP 는 대상 아님'.
    proc_sheets = PROC_M 시트 · grid_cols = {시트: 칸 nkey 집합}(SHEET_COLUMNS · 이 메뉴 전 시트) · result_cols = 결과 칸 nkey 집합(골든 실측)
    PROC_M 시트가 모두 그리드 메타를 갖고, 결과 칸이 이 메뉴 어느 그리드 칸과도 겹치지 않을 때만 사유 문구 · 아니면 ''"""
    if not proc_sheets or not result_cols or not grid_cols:
        return ''
    if any(s not in grid_cols for s in proc_sheets):
        return ''
    allc = set().union(*grid_cols.values())
    if result_cols & allc:
        return ''
    return (f"그리드 비바인딩 룩업 SP — 결과 칸 {sorted(result_cols)} 가 이 메뉴 SHEET_COLUMNS {len(allc)}칸(PROC_M 시트 {sorted(proc_sheets)} 포함)과 겹침 0 "
            f"→ 그리드에 표시되지 않음(TO-BE 룰 CR-075 ③ 대상 아님)")


def selftest():
    T = lambda k: {'A': True, 'B': True, 'QTY': False}.get(k.replace('_K', ''), None) if k else None
    t = lambda k: {'CUST': True, 'SITE': True, 'QTY': False}.get(k)
    cases = [('CI·NULL 있음', judge(["UPPER(CUST) NULLS FIRST"], t), 'PASS'), ('NLSSORT·NVL', judge(["NLSSORT(NVL(A.CUST,'/'),'NLS_SORT=BINARY_CI')"], t), 'PASS'), ('CI 없음', judge(['CUST NULLS FIRST'], t), '판정필요'), ('NULL 없음', judge(['UPPER(CUST)'], t), '판정필요'), ('둘 다 없음', judge(['A.CUST'], t), '판정필요'), ('숫자 키', judge(['QTY'], t), 'NA'), ('내림차순 NULL 무시', judge(['UPPER(CUST) DESC'], t), 'PASS'), ('자료형 모름', judge(['ZZZ'], t), 'NA'), ('없음', judge([], t), 'NA'), ('NOT NULL 은 NULL 칸 면제', judge(['UPPER(CUST)'], t, lambda k: False), 'PASS'), ('인자 제외', judge(["CASE WHEN P_X = 'A' THEN UPPER(CUST) END NULLS FIRST"], t), 'PASS'), ('T384 동률 해소 키', judge(["UPPER(TRANSLATE(IA.CUST, '_-', '/')) NULLS FIRST", 'IA.CUST NULLS FIRST'], t), 'PASS'), ('T384 동률 키 앞이 결함이면 유지', judge(['CUST', 'CUST NULLS FIRST'], t), '판정필요'), ('T384 잘린 키', judge(['UPPER(CUST) NULLS FIRST', 'UPPER(TRANSLATE(IA.SITE'], t), 'ERROR')]
    # T433 원본 표 추적(SCP0028 본 조회 모양: 바깥 SELECT ← 부분 질의 A=표 · D 바깥 조인 · 표 함수 별칭)
    body = ("PROCEDURE P_X IS BEGIN V := 1; OPEN C FOR SELECT DIVISION_ID, OPERATION_GROUP_ID, LOT_SIZE FROM (SELECT DISTINCT A.DIVISION_ID , A.OPERATION_GROUP AS OPERATION_GROUP_ID , "
            "D.LOT_SIZE , D.TO_SITE AS D_TO FROM SCP_MST_SHIPMENT_LOT_SIZE A , (SELECT TOKEN AS ITEM_ID FROM TABLE(F(P,','))) E , SCP_MST_SHIPMENT_LOT_SIZE D -- x\n"
            "WHERE A.DIVISION_ID = D.DIVISION_ID(+) ) ORDER BY NLSSORT(DIVISION_ID, 'NLS_SORT=BINARY_CI') , NLSSORT(OPERATION_GROUP_ID, 'NLS_SORT=BINARY_CI'); END;")
    st = stmt_before(body, "ORDER BY NLSSORT(DIVISION_ID, 'NLS_SORT=BINARY_CI') , NLSSORT(OPERATION_GROUP_ID, 'NLS_SORT=BINARY_CI')")
    ks = [('T433 문장 찾기', ('찾음' if st.startswith(' OPEN C FOR SELECT') else repr(st[:40])), '찾음'),
          ('T433 이름 그대로 키', key_source(st, "NLSSORT(DIVISION_ID, 'NLS_SORT=BINARY_CI')"), ('SCP_MST_SHIPMENT_LOT_SIZE', 'DIVISION_ID', False)),
          ('T433 AS 별칭 키', key_source(st, "NLSSORT(OPERATION_GROUP_ID, 'NLS_SORT=BINARY_CI')"), ('SCP_MST_SHIPMENT_LOT_SIZE', 'OPERATION_GROUP', False)),
          ('T433 바깥 조인 쪽', key_source(st, 'D_TO'), ('SCP_MST_SHIPMENT_LOT_SIZE', 'TO_SITE', True)),
          ('T433 표 함수 별칭 = 모름', key_source(st, 'E.ITEM_ID'), None),
          ('T433 문장 못 찾음', key_source('', 'A.X'), None)]
    cases += [(n, (('PASS' if got == want else 'NG'), repr(got)), 'PASS') for n, got, want in ks]
    cases.append(('T433 키 원문 넘김', judge(["NLSSORT(CUST, 'NLS_SORT=BINARY_CI')"], t, lambda k, p='': not p), 'PASS'))
    # 2026-11-25 T546 부분 질의 별칭 · 쓰기 경로 UPPER · 실측 근거 판정 / T549 그리드 비바인딩
    dq = "OPEN C FOR SELECT T.COLA , (SELECT S.NAM FROM CITY S WHERE S.CODE = T.COLA) AS COLA_NM FROM (SELECT X.COLA , X.COLB FROM TBL X WHERE X.ID = N) T ORDER BY T.COLA , T.COLB NULLS FIRST"
    sq = stmt_before('PROCEDURE P IS BEGIN ' + dq + '; END;', 'ORDER BY T.COLA , T.COLB NULLS FIRST')
    lj = "OPEN C FOR SELECT T.COLA FROM ZZZ LEFT JOIN (SELECT X.COLA FROM TBL X) T ON ZZZ.KEY1 = T.COLA ORDER BY T.COLA"
    asis = ("CREATE PROC P AS\nUPDATE dbo.TBL\n SET A = UPPER(@a) -- , A = @a\n , B = @b\n WHERE ID = @id\n"
            "/* INSERT INTO TBL (A) VALUES (@a) */\nINSERT\n INTO dbo.TBL (ID, A, B) VALUES (NEXT VALUE FOR S, UPPER(@a ), @b)\n"
            "INSERT INTO TBL_H (A) VALUES (@a)\nUPDATE r SET r.B = @b FROM TBL r WHERE r.ID = 1\n")
    tobe = "INSERT INTO TBL (ID, A) SELECT 1, UPPER(V.A) AS A FROM DUAL;\nUPDATE TBL SET A = CASE WHEN 1=1 THEN UPPER(X) END WHERE 1=1;"
    ks2 = [('T546 부분 질의 별칭 → 안쪽 원본 표', key_source(sq, 'T.COLA'), ('TBL', 'COLA', False)),
           ('T546 부분 질의 바깥 조인', key_source(lj, 'T.COLA'), ('TBL', 'COLA', True)),
           ('T546 AS-IS 쓰기 A = UPPER 2곳(주석·다른 표 제외)', [(k_, _is_upper(e)) for _, k_, e in write_sites(asis, 'TBL', 'A')], [('INSERT', True), ('UPDATE', True)]),
           ('T546 AS-IS 쓰기 B = 원값 3곳(별칭 UPDATE 포함)', sorted((k_, _is_upper(e)) for _, k_, e in write_sites(asis, 'TBL', 'B')), [('INSERT', False), ('UPDATE', False), ('UPDATE', False)]),
           ('T546 줄 번호', [l_ for l_, _, _ in write_sites(asis, 'TBL', 'A')], [7, 2]),
           ('T546 증명 A(양쪽 UPPER)', upper_proof('TBL', 'A', [('a.sql', asis)], [('PKG', tobe.split(';')[0])])[0], True),
           ('T546 TO-BE CASE 식 = UPPER 아님(변이)', upper_proof('TBL', 'A', [('a.sql', asis)], [('PKG', tobe)])[0], False),
           ('T546 TO-BE 쓰기 0곳 = 증명 실패', upper_proof('TBL', 'A', [('a.sql', asis)], [])[0], False),
           ('T546 MERGE = 해석 실패', upper_proof('TBL', 'A', [('a.sql', asis)], [('PKG', 'MERGE INTO TBL T USING D ON (1=1)')])[0], False),
           ('T549 결과 칸 겹침 0 = 비바인딩', bool(unbound_lookup({'route'}, {'route': {'fromcity'}, 'POPUP': {'routeid'}}, {'country', 'city'})), True),
           ('T549 겹침 있음 = 대상', unbound_lookup({'route'}, {'route': {'fromcity', 'city'}}, {'country', 'city'}), ''),
           ('T549 PROC_M 시트에 그리드 메타 없음 = 모름', unbound_lookup({'history'}, {'route': {'x'}}, {'a'}), ''),
           ('T549 결과 칸 모름 = 모름', unbound_lookup({'route'}, {'route': {'x'}}, set()), '')]
    cases += [(n, (('PASS' if got == want else 'NG'), repr(got)), 'PASS') for n, got, want in ks2]
    m_src = lambda k, p, need: (True, 'UPPER 증명', 'src') if need == 'ci' else (False, '', '')
    m_dat = lambda k, p, need: (True, '실측 0행', 'data')
    m_no = lambda k, p, need: (False, '실측 3행', '')
    cases += [('T546 대소문자=UPPER 증명 · NOT NULL = NA', judge(['T.CUST'], t, lambda k, p='': False, m_src), 'NA'),
              ('T546 UPPER 증명 · NULL 칸 근거 없음 = 판정필요 유지', judge(['T.CUST'], t, lambda k, p='': True, m_src), '판정필요'),
              ('T546 데이터 실측 0 = PASS', judge(['T.CUST', 'T.SITE'], t, lambda k, p='': True, m_dat), 'PASS'),
              ('T546 실측 >0 = 판정필요 유지(변이)', judge(['T.CUST'], t, lambda k, p='': True, m_no), '판정필요'),
              ('T546 원문 래퍼 있으면 moot 안 부름', judge(['UPPER(CUST) NULLS FIRST'], t, lambda k, p='': True, m_no), 'PASS')]
    bad = 0
    for n, got, want in cases:
        ok = got[0] == want
        bad += 0 if ok else 1
        print(f"{'OK ' if ok else 'NG '} {n} → {got[0]}(기대 {want}) {got[1]}")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def main(mid):
    p = os.path.join(ROOT, 'Doc', 'verify', mid, 'sort_check.csv')
    if not os.path.exists(p):
        print(f'[sort_ci] {mid}: sort_check.csv 없음 — 생략')
        return 0
    rows = list(csv.DictReader(open(p, encoding='utf-8-sig', newline='')))
    from dbconn import connect
    res, seen, memo = [], set(), {}
    with connect('tobe') as cx:
        cur = cx.cursor()

        stmt_now = {'s': ''}
        body_memo = {}

        def proc_body(proc):
            """패키지 본문에서 이 프로시저 구간(PROCEDURE <이름> ~ 다음 PROCEDURE·FUNCTION 앞). 못 읽으면 ''"""
            pk, _, pr = proc.upper().rpartition('.')
            if not pk or not pr:
                return ''
            if pk not in body_memo:
                try:
                    cur.execute("select text from all_source where name = :1 and type = 'PACKAGE BODY' order by line", [pk])
                    body_memo[pk] = ''.join(x[0] or '' for x in cur.fetchall())
                except Exception:
                    body_memo[pk] = ''
            b = body_memo[pk]
            m = re.search(r'(?im)^\s*PROCEDURE\s+' + re.escape(pr) + r'\b', b)
            if not m:
                return ''
            n = re.search(r'(?im)^\s*(PROCEDURE|FUNCTION)\s+\w+', b[m.end():])
            return b[m.start():m.end() + (n.start() if n else len(b))]

        def nullable(k, part=''):
            # 2026-11-20 T433: 키가 표 별칭으로 원본 표까지 이어지면 그 표의 칸으로 판단(바깥 조인 쪽 표는 NULL 가능). 못 이으면 종전(같은 이름 칸 하나라도 NULL 가능)
            src = key_source(stmt_now['s'], part) if part else None
            if src:
                tb, col, outer = src
                if outer:
                    return True
                cur.execute('select nullable from all_tab_columns where table_name = :1 and column_name = :2', [tb, col])
                ns = {x[0] for x in cur.fetchall()}
                if ns:
                    return 'Y' in ns
            cur.execute("select count(*) from all_tab_columns where column_name = :1 and nullable = 'Y'", [k])
            return cur.fetchone()[0] > 0

        # 2026-11-25 T546 원본 표 근거: 쓰기 경로 UPPER(AS-IS modules · TO-BE ALL_SOURCE) · TO-BE 원본 표 데이터 실측(읽기 전용 COUNT)
        import glob as _g, datetime as _dt
        _asis_files = _g.glob(os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules', '*.sql'))
        _docs, _meas, _proof, _srcs = {}, {}, {}, {}

        def docs_of(tb):
            if tb not in _docs:
                a_, t_ = [], []
                for f in _asis_files:
                    try:
                        tx = open(f, encoding='utf-8-sig', errors='replace').read()
                    except OSError:
                        continue
                    if tb in tx.upper():
                        a_.append((os.path.relpath(f, ROOT).replace(os.sep, '/'), tx))
                try:  # 표 이름이 나오는 줄이 전부 읽기(FROM·JOIN·',' 뒤 표)인 객체는 원문을 받지 않는다(쓰기 낱말·애매한 줄이 하나라도 있으면 받음)
                    cur.execute("select owner, name, type, text from all_source where upper(text) like :1 and owner not in ('SYS','SYSTEM','PUBLIC','XDB','MDSYS','CTXSYS','ORDSYS','WMSYS')", ['%' + tb + '%'])
                    rd = re.compile(r'^\s*(?:(?:FROM|JOIN|,)\s+|.*\b(?:FROM|JOIN)\s+)' + _tblrx(tb) + r'(?:\s+\w+)?\s*(?:/\*.*\*/)?\s*$', re.I)
                    objs = {}
                    for ow, nm, ty, tx in cur.fetchall():
                        tx = tx or ''
                        hit = bool(re.search(r'(?i)\b(INSERT|UPDATE|MERGE|INTO)\b', tx)) or not (rd.match(tx) or re.match(r'^\s*--', tx))
                        objs[(ow, nm, ty)] = objs.get((ow, nm, ty), False) or hit
                    for (ow, nm, ty), need in objs.items():
                        if not need:
                            continue
                        if (ow, nm, ty) not in _srcs:
                            cur.execute('select text from all_source where owner = :1 and name = :2 and type = :3 order by line', [ow, nm, ty])
                            _srcs[(ow, nm, ty)] = ''.join(x[0] or '' for x in cur.fetchall())
                        t_.append((f'{nm}({ty})', _srcs[(ow, nm, ty)]))
                except Exception:
                    t_ = []
                _docs[tb] = (a_, t_)
            return _docs[tb]

        def measure(tb, col):
            if (tb, col) not in _meas:
                _meas[(tb, col)] = None
                if re.fullmatch(r'[A-Z_][A-Z0-9_$#]*', tb) and re.fullmatch(r'[A-Z_][A-Z0-9_$#]*', col):
                    try:
                        cur.execute(f'select count(*), count(case when {col} is null then 1 end), count(case when {col} <> upper({col}) then 1 end) from {tb}')
                        _meas[(tb, col)] = tuple(cur.fetchone()) + (_dt.datetime.now().strftime('%Y-%m-%d %H:%M'),)
                    except Exception:
                        _meas[(tb, col)] = None
            return _meas[(tb, col)]

        def moot(k, part, need):
            src = key_source(stmt_now['s'], part)
            if not src:
                return False, '', ''
            tb, col, outer = src
            m = measure(tb, col)
            if need == 'nf':
                if outer:
                    return False, f'바깥 조인 쪽 {tb} — NULL 가능', ''
                if m and m[0] > 0 and m[1] == 0:
                    return True, f'NULL 0행(TO-BE {tb} 전 {m[0]}행 데이터 실측 {m[3]} · 표는 NULL 허용)', 'data'
                return False, (f'NULL {m[1]}/{m[0]}행(TO-BE {tb} 데이터 실측 {m[3]})' if m else f'TO-BE {tb} 데이터 실측 실패'), ''
            if (tb, col) not in _proof:
                _proof[(tb, col)] = upper_proof(tb, col, *docs_of(tb))
            ok, cite = _proof[(tb, col)]
            if ok and (m is None or m[2] == 0):
                return True, f'{tb} {cite}' + (f' · 소문자 0/{m[0]}행 실측 {m[3]}' if m else ' · 데이터 실측 실패'), 'src'
            if m and m[0] > 0 and m[2] == 0:
                return True, f'소문자 0행(TO-BE {tb} 전 {m[0]}행 데이터 실측 {m[3]}) · 쓰기 경로 증명 못 함: {cite[:160]}', 'data'
            return False, (f'소문자 {m[2]}/{m[0]}행(TO-BE {tb} 데이터 실측 {m[3]})' if m else f'TO-BE {tb} 데이터 실측 실패') + f' · {cite[:160]}', ''

        # 2026-11-25 T549 CR-075 ③ 그리드 비바인딩 룩업 판별 재료(PROC_M · SHEET_COLUMNS · 골든 결과 칸)
        _pmf = os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'proc_meta.csv'); _scf = os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'sheet_columns.csv')
        _pm = [x for x in csv.DictReader(open(_pmf, encoding='utf-8-sig')) if (x.get('menu_id') or '').upper() == mid] if os.path.exists(_pmf) else []
        _gc = {}
        if os.path.exists(_scf):
            for x in csv.DictReader(open(_scf, encoding='utf-8-sig')):
                if (x.get('program_id') or '').upper() == mid:
                    _gc.setdefault(x.get('sheet_name') or '', set()).add(re.sub(r'[^a-z0-9]', '', (x.get('column_name') or '').lower()))

        def result_cols(sp):
            f = os.path.join(ROOT, 'Doc', 'golden', mid, f'{sp}.cols.csv')
            if not sp or not os.path.exists(f):
                return set()
            return {re.sub(r'[^a-z0-9]', '', (x.get('column') or '').lower()) for x in csv.DictReader(open(f, encoding='utf-8-sig')) if str(x.get('set')) == '1'}

        def is_text(k):
            if not k:
                return None
            if k not in memo:
                cur.execute('select distinct data_type from all_tab_columns where column_name = :1', [k])
                ts = {r[0] for r in cur.fetchall()}
                memo[k] = None if not ts else (ts <= TEXT)
            return memo[k]

        for r in rows:
            ob = (r.get('tobe_order_by') or '').strip(); proc = r.get('tobe_proc') or ''
            if not ob or (proc, ob) in seen or re.search(r'_SAVE_', proc, re.I):  # 저장 SP 내부 정렬은 조회 결과 순서가 아니다
                continue
            seen.add((proc, ob))
            # 2026-11-20 T490(SCP0028 EG-c77e3290 INPUT SP 'NULL 먼저 없음 5/5' 판정필요): AS-IS SP 에 ORDER BY 가 없으면(sort_check asis_keys 빈칸 · 'AS-IS 에 없던 ORDER BY')
            #   대조할 AS-IS 콜레이션 순서가 없다. TO-BE 가 넣은 결정적 순서는 sort_check(CR-075)가 판정 → 이 검사는 대상 없음
            if not (r.get('asis_keys') or '').strip() and re.search(r'AS-IS 에 없던 ORDER BY', r.get('note') or ''):
                res.append({'proc': proc, 'result': 'NA', 'why': f"AS-IS SP {r.get('sp') or ''} 에 ORDER BY 없음 — 대소문자·NULL 위치를 대조할 AS-IS 정렬 기준 없음 · TO-BE 정렬 추가는 sort_check(CR-075) 판정: {(r.get('note') or '')[:120]}", 'order_by': ob[:400]})
                continue
            lk = unbound_lookup({x.get('sheet') or '' for x in _pm if (x.get('proc') or '').upper() == proc.upper()}, _gc, result_cols(r.get('sp') or ''))
            if lk:  # T549 CR-075 ③
                res.append({'proc': proc, 'result': 'NA', 'why': lk + f" · 결과 칸 원천 Doc/golden/{mid}/{r.get('sp') or ''}.cols.csv", 'order_by': ob[:400]})
                continue
            stmt_now['s'] = stmt_before(proc_body(proc), ob)
            v, why = judge(split_keys(ob), is_text, nullable, moot)
            res.append({'proc': proc, 'result': v, 'why': why, 'order_by': ob[:400]})
    with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'sort_ci.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(res)
    print(f'[sort_ci] {mid}: {len(res)}건 ' + str({k: sum(1 for x in res if x["result"] == k) for k in sorted({x["result"] for x in res})}))
    return 0


if __name__ == '__main__':
    sys.exit(selftest() if sys.argv[1] == '--selftest' else main(sys.argv[1].upper()))
