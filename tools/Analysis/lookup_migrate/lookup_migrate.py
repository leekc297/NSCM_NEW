# -*- coding: utf-8 -*-
"""LOOKUP 이관(MSSQL → Oracle) 쿼리 생성과 로컬 검증. VMW 업무 'LOOKUP 이관' 의 단계 LK.gen · LK.verify 가 부름
  python lookup_migrate.py gen    --module <단위>   쿼리 파일 4개 + _statements.json 생성
  python lookup_migrate.py verify --module <단위>   AS-IS 개발 MSSQL 에서 생성 쿼리 실행 → ZIOUI1 에서 백업, MERGE, 확인, 복원 실행 → ROLLBACK
  단위 = LOOKUP_GROUP(COMMON, DM, SCP, SSP) 1개 또는 묶음(DM_SSP). ALL 이 들어 있으면 그룹 조건 없음
  입력 = quick.json 'lookupmig' 업무의 inputsFile(_inputs.json). 출력 폴더 = 그 파일이 있는 폴더(경로는 quick.json 1곳)
  변환 규칙(2026-11-25 11:22 ZIOUI1, LGCE_SCMDEV 실측 근거, Doc/통합테스트_SSP SSP LOOKUP 이관과 같음)
    키 SEGMENT1~5 '' → '-' · ATTRIBUTE1~15 '' → ' ' · DESCRIPTION 등 '' → NULL
    VALID_YN 대문자, 상세 NULL/'' → '/' · 일시 초 단위 · 작은따옴표 두 번 · & ? : CR LF TAB → CHR()"""
import sys, os, io, re, json, datetime, collections
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
CHAIN_ID = 'lookupmig'
GROUPS = ['COMMON', 'DM', 'SCP', 'SSP']
ATTR = ['ATTRIBUTE%d' % i for i in range(1, 16)]
SEG = ['SEGMENT%d' % i for i in range(1, 6)]
MASTER = ['LOOKUP_TYPE', 'DESCRIPTION', 'LOOKUP_GROUP', 'VALID_YN'] + SEG + ['CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE'] + ATTR
DETAIL = ['LOOKUP_TYPE'] + SEG + ['DISPLAY_SEQ', 'VALID_YN', 'DESCRIPTION', 'CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE'] + ATTR
DATES = {'CREATION_DATE', 'LAST_UPDATE_DATE'}
NUMS = {'DISPLAY_SEQ'}
TM, TD = 'SCM_ADM_LOOKUP_MASTER', 'SCM_ADM_LOOKUP_MASTER_DETAIL'
LINE = '-- ' + '=' * 110


class InputError(Exception):
    pass


# ---------------------------------------------------------------- 입력
def item_def():
    q = json.load(io.open(os.path.join(ROOT, 'tools', 'VibeManager', 'quick.json'), encoding='utf-8-sig'))
    for g in q.get('groups', []):
        for it in g.get('items', []):
            if it.get('chainId') == CHAIN_ID:
                return it
    raise InputError('quick.json 에 chainId %s 업무 없음' % CHAIN_ID)


def unit_dir(unit):
    rel = item_def().get('inputsFile') or ''
    if '${id}' not in rel:
        raise InputError('quick.json lookupmig inputsFile 에 ${id} 없음')
    return os.path.join(ROOT, os.path.dirname(rel.replace('${id}', unit)))


def split_list(s):
    if isinstance(s, list):
        s = ','.join(s)
    return [x for x in re.split(r'[\s,]+', str(s or '').strip()) if x]


WORD_OK = {'AND', 'OR', 'NOT', 'IN', 'LIKE', 'IS', 'NULL', 'BETWEEN', 'ESCAPE', 'UPPER', 'LOWER', 'LTRIM', 'RTRIM'}
BAD_TEXT = [(';', '세미콜론'), ('&', '앰퍼샌드'), ('?', '물음표'), (':', '콜론'), ('--', '주석'), ('/*', '주석'), ('"', '큰따옴표'), ('||', '문자 연결'), ('[', '대괄호')]


def check_where(text, alias, cols):
    """추가 조건 검사. MSSQL 과 Oracle 양쪽에서 같은 뜻으로 도는 문장만 받음(컬럼, 비교, AND OR NOT IN LIKE IS NULL BETWEEN, UPPER LOWER LTRIM RTRIM)"""
    w = str(text or '').strip()
    if not w:
        return ''
    if w.count("'") % 2:
        raise InputError('추가 조건 작은따옴표 짝이 맞지 않음: %s' % w)
    bare = re.sub(r"'[^']*'", "''", w)
    if re.search(r"\bN''", bare, re.I):
        raise InputError("추가 조건에 N'…' 사용 불가(Oracle 에서 다른 뜻): %s" % w)
    if '&' in w:
        raise InputError('추가 조건에 앰퍼샌드(&) 사용 불가(작은따옴표 안 포함, Oracle 실행 도구가 변수로 읽음): %s' % w)
    for ch, nm in BAD_TEXT:
        if ch in bare:
            raise InputError('추가 조건에 %s(%s) 사용 불가: %s' % (nm, ch, w))
    for c in DATES:
        if re.search(r'\b%s\b' % c, bare, re.I):
            raise InputError('추가 조건에 일시 컬럼 %s 사용 불가(MSSQL 과 Oracle 의 문자 → 일시 변환이 다름): %s' % (c, w))
    if bare.count('(') != bare.count(')'):
        raise InputError('추가 조건 괄호 짝이 맞지 않음: %s' % w)
    for q, c in re.findall(r'\b([A-Za-z_]\w*)\s*\.\s*([A-Za-z_]\w*)', bare):
        if q.upper() != alias:
            raise InputError('추가 조건 별칭은 %s. 만 씀(%s.%s): %s' % (alias, q, c, w))
    for tok in re.findall(r'[A-Za-z_]\w*', re.sub(r'\b%s\s*\.' % alias, ' ', bare, flags=re.I)):
        u = tok.upper()
        if u in WORD_OK or u in cols:
            continue
        raise InputError('추가 조건에 쓸 수 없는 낱말 %s(쓸 수 있는 것 = %s 컬럼, %s): %s' % (tok, alias, ', '.join(sorted(WORD_OK)), w))
    return w


def ymd(s):
    d = re.findall(r'\d+', str(s or ''))
    if len(d) >= 3 and len(d[0]) == 4:
        return '%04d%02d%02d' % (int(d[0]), int(d[1]), int(d[2]))
    if len(d) == 1 and len(d[0]) == 8:
        return d[0]
    return datetime.date.today().strftime('%Y%m%d')


def q(s):
    return "'" + str(s).replace("'", "''") + "'"


def load_spec(unit):
    unit = unit.strip().upper()
    parts = [p for p in unit.split('_') if p]
    bad = [p for p in parts if p not in GROUPS + ['ALL']]
    if not parts or bad:
        raise InputError('단위 %s: 그룹은 %s 또는 ALL 만 씀(틀린 값 %s)' % (unit, ', '.join(GROUPS), bad))
    f = os.path.join(unit_dir(unit), '_inputs.json')
    inp = json.load(io.open(f, encoding='utf-8-sig')) if os.path.exists(f) else {}
    types = split_list(inp.get('types'))
    excl = split_list(inp.get('exclude'))
    for t in types + excl:
        if not re.match(r'^[A-Za-z0-9_.\-]+$', t):
            raise InputError('LOOKUP_TYPE 값에 쓸 수 없는 글자: %s' % t)
    day = ymd(inp.get('date'))
    tag = str(inp.get('bkTag') or '').strip().upper() or 'BK' + day
    if not re.match(r'^[A-Z][A-Z0-9_]{0,29}$', tag):
        raise InputError('백업 꼬리 이름은 영문 대문자로 시작, 영문 대문자 숫자 _ 30자 이내: %s' % tag)
    groups = None if 'ALL' in parts else [g for g in GROUPS if g in parts]
    whereM = check_where(inp.get('whereM'), 'M', set(MASTER))
    whereD = check_where(inp.get('whereD'), 'D', set(DETAIL))
    return dict(unit=unit, dir=unit_dir(unit), groups=groups, types=types, exclude=excl, whereM=whereM, whereD=whereD,
                day=day, tag=tag, bkM='%s_%s' % (TM, tag), bkD='%s_%s' % (TD, tag), verify=str(inp.get('verify') or 'Y').upper() != 'N', inputs=inp)


def mpred(sp):
    """마스터 조건(별칭 M). MSSQL 과 Oracle 같은 문장"""
    c = []
    if sp['groups']:
        c.append('M.LOOKUP_GROUP IN (%s)' % ', '.join(q(g) for g in sp['groups']))
    if sp['types']:
        c.append('M.LOOKUP_TYPE IN (%s)' % ', '.join(q(t) for t in sp['types']))
    if sp['whereM']:
        c.append('(%s)' % sp['whereM'])
    return ' AND '.join(c) if c else '1 = 1'


def excl_pred(sp, al='D'):
    return ('%s.LOOKUP_TYPE NOT IN (%s)' % (al, ', '.join(q(t) for t in sp['exclude']))) if sp['exclude'] else ''


def dpred(sp, mtab, nolock):
    """상세 조건(별칭 D). mtab = 마스터 테이블 이름"""
    h = ' WITH (NOLOCK)' if nolock else ''
    c = ['D.LOOKUP_TYPE IN (SELECT M.LOOKUP_TYPE FROM %s M%s WHERE %s)' % (mtab, h, mpred(sp))]
    if sp['exclude']:
        c.append(excl_pred(sp))
    if sp['whereD']:
        c.append('(%s)' % sp['whereD'])
    return '\n   AND '.join(c)


def describe(sp):
    a = ['그룹 = %s' % (', '.join(sp['groups']) if sp['groups'] else '조건 없음(전체 그룹)')]
    a.append('LOOKUP_TYPE = %s' % (', '.join(sp['types']) if sp['types'] else '조건 없음'))
    if sp['whereM']:
        a.append('마스터 추가 조건 = %s' % sp['whereM'])
    if sp['whereD']:
        a.append('상세 추가 조건 = %s' % sp['whereD'])
    a.append('상세 제외 유형 = %s' % (', '.join(sp['exclude']) if sp['exclude'] else '없음'))
    return a


# ---------------------------------------------------------------- MERGE 생성 쿼리(MSSQL)
ESC = [('CHAR(39)', 'CHAR(39) + CHAR(39)')] + [('CHAR(%d)' % n, "CHAR(39) + ' || CHR(%d) || ' + CHAR(39)" % n) for n in (38, 63, 58, 13, 10, 9)]


def esc(v):
    s = v
    for a, b in ESC:
        s = 'REPLACE(%s, %s, %s)' % (s, a, b)
    return s


def value(al, c, detail):
    x = '%s.%s' % (al, c)
    if c in SEG:
        return "CASE WHEN DATALENGTH(%s) = 0 THEN N'-' ELSE %s END" % (x, x)
    if c in ATTR:
        return "CASE WHEN DATALENGTH(%s) = 0 THEN N' ' ELSE %s END" % (x, x)
    if c == 'VALID_YN':
        return ("CASE WHEN %s IS NULL OR DATALENGTH(%s) = 0 THEN N'/' ELSE UPPER(%s) END" % (x, x, x)) if detail else ("UPPER(CASE WHEN DATALENGTH(%s) = 0 THEN NULL ELSE %s END)" % (x, x))
    if c == 'LOOKUP_TYPE':
        return x
    return "CASE WHEN DATALENGTH(%s) = 0 THEN NULL ELSE %s END" % (x, x)


def lit(al, c, detail):
    x = '%s.%s' % (al, c)
    if c in DATES:
        return ("CASE WHEN %s IS NULL THEN 'NULL' ELSE 'TO_DATE(' + CHAR(39) + CONVERT(VARCHAR(8), %s, 112) + REPLACE(CONVERT(VARCHAR(8), %s, 108), CHAR(58), SPACE(0)) + CHAR(39) + ', ' + CHAR(39) + 'YYYYMMDDHH24MISS' + CHAR(39) + ')' END" % (x, x, x))
    if c in NUMS:
        return "CASE WHEN %s IS NULL THEN 'NULL' ELSE CONVERT(VARCHAR(20), %s) END" % (x, x)
    v = value(al, c, detail)
    return "CASE WHEN %s IS NULL THEN 'NULL' ELSE CHAR(39) + %s + CHAR(39) END" % (v, esc(v))


def stmt(tb, cols, keys, al, detail):
    sel = ["       + %s%s + ' AS %s'" % ("', ' + " if i else '', lit(al, c, detail), c) for i, c in enumerate(cols)]
    on = ' AND '.join('T.%s = S.%s' % (k, k) for k in keys)
    upd = ', '.join('T.%s = S.%s' % (c, c) for c in cols if c not in keys)
    head = "SELECT CAST('MERGE INTO %s T USING (SELECT ' AS NVARCHAR(MAX))\n" % tb
    tail = ("       + ' FROM DUAL) S ON (%s) WHEN MATCHED THEN UPDATE SET %s WHEN NOT MATCHED THEN INSERT (%s) VALUES (%s)' + CHAR(59) AS SQL_TEXT\n"
            % (on, upd, ', '.join(cols), ', '.join('S.' + c for c in cols)))
    return head + '\n'.join(sel) + '\n' + tail


def m2(sp):
    m = stmt(TM, MASTER, ['LOOKUP_TYPE'], 'M', False)
    d = stmt(TD, DETAIL, ['LOOKUP_TYPE'] + SEG, 'D', True)
    m = m.replace(' AS SQL_TEXT\n', ' AS SQL_TEXT\n     , 1 AS ORD, M.LOOKUP_TYPE AS K0' + ''.join(', CAST(NULL AS NVARCHAR(200)) AS K%d' % i for i in range(1, 6)) + '\n')
    d = d.replace(' AS SQL_TEXT\n', ' AS SQL_TEXT\n     , 2 AS ORD, D.LOOKUP_TYPE AS K0' + ''.join(', D.SEGMENT%d AS K%d' % (i, i) for i in range(1, 6)) + '\n')
    m += '  FROM dbo.%s M WITH (NOLOCK)\n WHERE %s\n' % (TM, mpred(sp))
    d += '  FROM dbo.%s D WITH (NOLOCK)\n WHERE %s\n' % (TD, dpred(sp, 'dbo.' + TM, True))
    body = '\n'.join('       ' + l for l in (m + 'UNION ALL\n' + d).rstrip('\n').split('\n'))
    return 'SELECT X.SQL_TEXT\n  FROM (\n' + body + '\n       ) X\n ORDER BY X.ORD, X.K0, X.K1, X.K2, X.K3, X.K4, X.K5'


# ---------------------------------------------------------------- 문장
def statements(sp):
    P, bkM, bkD = mpred(sp), sp['bkM'], sp['bkD']
    scope = ('SELECT M.LOOKUP_TYPE FROM %s M WHERE %s\n                          UNION\n                         SELECT M.LOOKUP_TYPE FROM %s M WHERE %s' % (TM, P, bkM, P))
    ex = ('\n   AND ' + excl_pred(sp)) if sp['exclude'] else ''
    exB = ('\n   AND ' + excl_pred(sp, 'B')) if sp['exclude'] else ''
    S = collections.OrderedDict()
    S['B1'] = 'CREATE TABLE %s AS\nSELECT *\n  FROM %s' % (bkM, TM)
    S['B2'] = 'CREATE TABLE %s AS\nSELECT *\n  FROM %s' % (bkD, TD)
    S['B3'] = ('SELECT (SELECT COUNT(*) FROM %s) AS MASTER_CNT\n     , (SELECT COUNT(*) FROM %s) AS MASTER_BK_CNT\n'
               '     , (SELECT COUNT(*) FROM %s) AS DETAIL_CNT\n     , (SELECT COUNT(*) FROM %s) AS DETAIL_BK_CNT\n'
               '     , (SELECT COUNT(*) FROM %s M WHERE %s) AS SCOPE_MASTER_BK_CNT\n'
               '     , (SELECT COUNT(*) FROM %s D WHERE %s) AS SCOPE_DETAIL_BK_CNT\n  FROM DUAL') % (TM, bkM, TD, bkD, bkM, P, bkD, dpred(sp, bkM, False))
    S['M1'] = ('SELECT (SELECT COUNT(*) FROM dbo.%s M WITH (NOLOCK) WHERE %s) AS MASTER_CNT\n'
               '     , (SELECT COUNT(*) FROM dbo.%s D WITH (NOLOCK) WHERE %s) AS DETAIL_CNT') % (TM, P, TD, dpred(sp, 'dbo.' + TM, True))
    S['M3'] = ('SELECT M.LOOKUP_TYPE\n     , M.LOOKUP_GROUP\n     , M.VALID_YN\n     , (SELECT COUNT(*)\n          FROM dbo.%s D WITH (NOLOCK)\n         WHERE D.LOOKUP_TYPE = M.LOOKUP_TYPE%s%s) AS DETAIL_CNT\n'
               '  FROM dbo.%s M WITH (NOLOCK)\n WHERE %s\n ORDER BY M.LOOKUP_TYPE') % (TD, ex, (' AND (%s)' % sp['whereD']) if sp['whereD'] else '', TM, P)
    S['M2'] = m2(sp)
    S['O1'] = ('SELECT (SELECT COUNT(*) FROM %s M WHERE %s) AS MASTER_CNT\n'
               '     , (SELECT COUNT(*) FROM %s D WHERE %s) AS DETAIL_CNT\n  FROM DUAL') % (TM, P, TD, dpred(sp, TM, False))
    S['O2'] = ('SELECT M.LOOKUP_TYPE\n     , M.LOOKUP_GROUP\n     , M.VALID_YN\n     , (SELECT COUNT(*)\n          FROM %s D\n         WHERE D.LOOKUP_TYPE = M.LOOKUP_TYPE%s%s) AS DETAIL_CNT\n'
               '     , (SELECT MAX(D.LAST_UPDATE_DATE)\n          FROM %s D\n         WHERE D.LOOKUP_TYPE = M.LOOKUP_TYPE) AS LAST_UPDATE_DATE\n  FROM %s M\n WHERE %s\n ORDER BY M.LOOKUP_TYPE') % (TD, ex, (' AND (%s)' % sp['whereD']) if sp['whereD'] else '', TD, TM, P)
    S['O3'] = 'SELECT D.VALID_YN\n     , COUNT(*) AS CNT\n  FROM %s D\n WHERE %s\n GROUP BY D.VALID_YN\n ORDER BY D.VALID_YN' % (TD, dpred(sp, TM, False))
    S['R1'] = 'DELETE FROM %s D\n WHERE D.LOOKUP_TYPE IN (%s)%s' % (TD, scope, ex)
    S['R2'] = 'INSERT INTO %s\nSELECT B.*\n  FROM %s B\n WHERE B.LOOKUP_TYPE IN (%s)%s' % (TD, bkD, scope, exB)
    S['R3'] = ('DELETE FROM %s T\n WHERE T.LOOKUP_TYPE IN (%s)\n   AND NOT EXISTS (SELECT 1\n                     FROM %s B\n                    WHERE B.LOOKUP_TYPE = T.LOOKUP_TYPE)') % (TM, scope, bkM)
    S['R4'] = ('MERGE INTO %s T\nUSING (SELECT B.*\n         FROM %s B\n        WHERE B.LOOKUP_TYPE IN (%s)) S\n   ON (T.LOOKUP_TYPE = S.LOOKUP_TYPE)\n'
               ' WHEN MATCHED THEN UPDATE SET %s\n WHEN NOT MATCHED THEN INSERT (%s)\n VALUES (%s)') % (
        TM, bkM, scope, '\n                          , '.join('T.%s = S.%s' % (c, c) for c in MASTER if c != 'LOOKUP_TYPE'), ', '.join(MASTER), ', '.join('S.' + c for c in MASTER))
    def mins(a, b, tb_a, tb_b, detail):
        w = ' WHERE X.LOOKUP_TYPE IN (%s)%s' % (scope, (' AND ' + excl_pred(sp, 'X')) if (detail and sp['exclude']) else '')
        return ('(SELECT COUNT(*)\n          FROM (SELECT X.* FROM %s X%s\n                MINUS\n                SELECT X.* FROM %s X%s)) AS %s') % (tb_a, w, tb_b, w, a + '_' + b)
    S['R5'] = ('SELECT ' + '\n     , '.join([mins('MASTER', 'ONLY_NOW', TM, bkM, False), mins('MASTER', 'ONLY_BK', bkM, TM, False),
                                          mins('DETAIL', 'ONLY_NOW', TD, bkD, True), mins('DETAIL', 'ONLY_BK', bkD, TD, True)]) + '\n  FROM DUAL')
    return S


# ---------------------------------------------------------------- 파일
def block(key, title, notes, sql):
    out = [LINE, '-- [%s] %s' % (key, title)] + ['-- ' + n for n in notes] + [LINE, sql + ';', '']
    return '\n'.join(out)


def head(sp, n, title, lines):
    a = [LINE, '-- LOOKUP 이관 %s/4 · %s' % (n, title), '-- 단위 : %s · 작성 %s' % (sp['unit'], datetime.datetime.now().strftime('%Y-%m-%d %H:%M'))]
    a += ['-- 대상 : ' + x for x in describe(sp)]
    a += ['-- ' + x for x in lines] + [LINE, '', '']
    return '\n'.join(a)


def gen(unit):
    sp = load_spec(unit)
    S = statements(sp)
    os.makedirs(sp['dir'], exist_ok=True)
    stamp = datetime.datetime.now().strftime('%H%M')
    base = 'LOOKUP_이관_%s_%s_%s' % (sp['unit'], sp['day'], stamp)
    files = []
    def w(n, kind, body):
        f = os.path.join(sp['dir'], '%s_%d_%s.sql' % (base, n, kind))
        io.open(f, 'w', encoding='utf-8', newline='\r\n').write(body)
        files.append(f)
    w(1, '백업_ORACLE', head(sp, 1, 'Oracle(클라우드 QA) LOOKUP 테이블 백업', [
        '순서 : [B1] · [B2] 백업 테이블 생성 → [B3] 건수 확인 → 2/4 파일(MSSQL) 실행',
        '백업 범위 : 두 테이블 전체 행. 4/4 복원 파일은 이 백업에서 이번 대상 유형만 되돌림',
        '주의 : CREATE TABLE 은 실행하면 바로 반영됨. 같은 이름 테이블이 있으면 ORA-00955 로 멈춤. 그때는 [B3] 로 건수만 확인하고 진행',
        '백업 테이블 : %s, %s' % (sp['bkM'], sp['bkD'])])
      + block('B1', '마스터 백업', [], S['B1']) + '\n' + block('B2', '상세 백업', [], S['B2']) + '\n'
      + block('B3', '백업 건수 확인', ['확인 : MASTER_CNT = MASTER_BK_CNT, DETAIL_CNT = DETAIL_BK_CNT. SCOPE_* = 이번 대상의 백업 건수'], S['B3']))
    w(2, 'MERGE생성_MSSQL', head(sp, 2, 'MSSQL(클라우드 QA) 에서 실행 · Oracle MERGE INTO 문장 생성', [
        '앞 단계 : 1/4 파일로 Oracle QA 백업을 끝낸 뒤 실행',
        '사용 : [M1] 건수 확인 → [M2] 실행 → 결과 열 SQL_TEXT 전체 복사 → Oracle QA 새 탭에 붙여 스크립트 실행(DBeaver Alt+X)',
        '       → 3/4 파일 [O1] ~ [O3] 확인 → COMMIT. 되돌릴 때는 4/4 파일',
        '결과 행 : 마스터 1행 = MERGE 1문장, 상세 1행 = MERGE 1문장. 마스터가 먼저 나옴',
        '변환 : 상세 키 SEGMENT1~5 빈 문자열 → \'-\', ATTRIBUTE1~15 빈 문자열 → 공백 1자, DESCRIPTION 등 빈 문자열 → NULL',
        '       VALID_YN 대문자. 상세 VALID_YN 빈 값 → \'/\'. 일시 = 초 단위. 작은따옴표 두 번, & ? : 줄바꿈 탭 → CHR()',
        'MERGE 동작 : 키가 있으면 키 외 전 열 UPDATE, 없으면 INSERT. Oracle 에만 있는 행은 지우지 않음',
        '조건 값 : MSSQL 은 대소문자를 가리지 않고 Oracle 은 가림. 1/3/4 파일(Oracle)도 같은 조건을 쓰므로 값은 데이터와 같은 대소문자로 씀',
        'IF_STOCK_CHECK 를 상세 제외에 두는 이유 : SEGMENT5(일자)가 키라서 MERGE 하면 일자 다른 행이 하나 더 생김(2026-11-25 SSP 로컬 시험 123묶음 중 14묶음)'])
      + block('M1', '건수 확인(MSSQL) : [M2] 결과 행 수 = MASTER_CNT + DETAIL_CNT', [], S['M1']) + '\n'
      + block('M3', '유형별 상세 건수(MSSQL) : Oracle 실행 뒤 3/4 파일 [O2] 결과와 비교', [], S['M3']) + '\n'
      + block('M2', 'Oracle MERGE INTO 문장 생성(조회 문장. MSSQL 데이터는 바뀌지 않음)', [], S['M2']))
    w(3, '확인_ORACLE', head(sp, 3, 'Oracle(클라우드 QA) 확인 쿼리 · 조회 문장', [
        '순서 : [O1] 실행 전 건수 기록 → 2/4 파일 [M2] 결과(MERGE 문장) 실행 → [O1] · [O2] · [O3] 다시 실행 → 맞으면 COMMIT',
        'DBeaver 자동 커밋이 켜져 있으면 MERGE 문장마다 바로 반영됨. 확인 뒤 반영하려면 수동 커밋으로 바꾸고 실행'])
      + block('O1', '대상 건수', ['확인 : MERGE 뒤 MASTER_CNT ≥ 2/4 파일 [M1] MASTER_CNT, DETAIL_CNT ≥ [M1] DETAIL_CNT. Oracle 에만 있는 행은 지우지 않으므로 같거나 많음'], S['O1']) + '\n'
      + block('O2', '유형별 상세 건수', ['확인 : 2/4 파일 [M3] 와 유형별 비교. MSSQL 에 있는 유형은 DETAIL_CNT 가 같거나 많음'], S['O2']) + '\n'
      + block('O3', '상세 VALID_YN 값', ['확인 : Y, N, / 만 나옴(소문자 y 없음)'], S['O3']) + '\n'
      + '\n'.join([LINE, '-- [O4] 반영 : 위 결과가 맞으면 아래 COMMIT 실행. 맞지 않으면 ROLLBACK 실행 후 결과 회신', '-- COMMIT 뒤 되돌릴 때는 4/4 복원 파일 실행', LINE, '-- COMMIT;', '']))
    w(4, '복원_ORACLE', head(sp, 4, 'Oracle(클라우드 QA) 복원 · 이관 결과를 되돌릴 때만 실행', [
        '범위 : 지금 대상 조건에 맞는 유형 + 백업 때 대상 조건에 맞던 유형. 다른 유형은 건드리지 않음',
        '순서 : [R1] → [R2] → [R3] → [R4] → [R5] 확인 → COMMIT(맞지 않으면 ROLLBACK)',
        '결과 : 이관으로 새로 생긴 유형과 행은 지워지고, 백업 때 행이 돌아옴. 상세 제외 유형은 지금 값 그대로 둠',
        '백업 테이블 : %s, %s' % (sp['bkM'], sp['bkD'])])
      + block('R1', '상세 삭제(변경 문장)', [], S['R1']) + '\n'
      + block('R2', '상세 복원(변경 문장) : [R1] 과 같은 범위의 백업 행', [], S['R2']) + '\n'
      + block('R3', '마스터 삭제(변경 문장) : 백업에 없는 유형만', [], S['R3']) + '\n'
      + block('R4', '마스터 복원(변경 문장) : 백업 값으로 덮어씀', [], S['R4']) + '\n'
      + block('R5', '복원 확인', ['확인 : 네 값이 모두 0'], S['R5']) + '\n'
      + '\n'.join([LINE, '-- [R6] 반영 : [R5] 가 모두 0 이면 아래 COMMIT 실행', LINE, '-- COMMIT;', '']))
    meta = dict(unit=sp['unit'], at=datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), base=base, files=[os.path.basename(f) for f in files],
                bkM=sp['bkM'], bkD=sp['bkD'], scope=describe(sp), exclude=sp['exclude'], verify=sp['verify'], statements=S)
    io.open(os.path.join(sp['dir'], '_statements.json'), 'w', encoding='utf-8').write(json.dumps(meta, ensure_ascii=False, indent=1))
    for f in files:
        print('[OUT]', os.path.relpath(f, ROOT).replace(os.sep, '/'))
    print('대상 :', ' · '.join(describe(sp)))
    return 0


# ---------------------------------------------------------------- 로컬 검증
def verify(unit):
    sp = load_spec(unit)
    mf = os.path.join(sp['dir'], '_statements.json')
    meta = json.load(io.open(mf, encoding='utf-8'))
    if not sp['verify']:
        print('[SKIP] 입력 로컬 검증 = N. 검증하지 않음(미검증)')
        return 0
    S = meta['statements']
    sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
    import dbconn
    log = []
    def P(*a):
        s = ' '.join(str(x) for x in a); print(s, flush=True); log.append(s)
    fail = []
    a = dbconn.connect('asis'); a.timeout = 600; ac = a.cursor()
    ac.execute("SELECT DB_NAME(), CONVERT(VARCHAR(19), GETDATE(), 120)"); P('AS-IS', tuple(ac.fetchone()), '(개발 DB. 클라우드 QA MSSQL 아님)')
    ac.execute(S['M1']); mc, dc = ac.fetchone(); P('[M1] MASTER_CNT', mc, '· DETAIL_CNT', dc)
    ac.execute(S['M3']); m3 = ac.fetchall(); P('[M3] 유형', len(m3))
    t0 = datetime.datetime.now(); ac.execute(S['M2']); rows = [r[0] for r in ac.fetchall()]
    P('[M2] 결과 행', len(rows), '· 걸린 시간', round((datetime.datetime.now() - t0).total_seconds(), 1), '초')
    if len(rows) != mc + dc: fail.append('[M2] 행 수 %d ≠ [M1] %d' % (len(rows), mc + dc))
    if any(r is None for r in rows): fail.append('[M2] NULL 행 %d' % sum(1 for r in rows if r is None))
    bad = [r for r in rows if r and re.search(r"[?&:\r\n\t]", r)]
    if bad: fail.append('[M2] 문장 안 ? & : 줄바꿈 탭 남은 행 %d' % len(bad))
    if sp['types']:
        found = {r[0] for r in m3}; miss = [t for t in sp['types'] if t not in found]
        if miss: P('  [주의] AS-IS 개발 DB 에 없는 LOOKUP_TYPE', miss)
    io.open(os.path.join(sp['dir'], meta['base'] + '_검증_MERGE문장.sql'), 'w', encoding='utf-8', newline='\n').write('\n'.join(r for r in rows if r) + '\n')
    t = dbconn.connect('tobe'); t.autocommit = False; tc = t.cursor()
    tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'), SYS_CONTEXT('USERENV','CURRENT_SCHEMA') FROM DUAL"); P('TO-BE ZIOUI1', tc.fetchone())
    for tb, cols in ((TM, MASTER), (TD, DETAIL)):
        tc.execute("SELECT column_name FROM all_tab_columns WHERE owner = 'SCM_MGR' AND table_name = :t", t=tb); oc = {r[0] for r in tc.fetchall()}
        ac.execute("SELECT name FROM sys.columns WHERE object_id = OBJECT_ID('dbo.' + ?)", tb); acs = {r[0].upper() for r in ac.fetchall()}
        if oc != set(cols) or not set(cols) <= acs:
            fail.append('%s 컬럼 다름: Oracle 만 %s · 생성기 만 %s · AS-IS 에 없음 %s' % (tb, sorted(oc - set(cols)), sorted(set(cols) - oc), sorted(set(cols) - acs)))
    if fail:
        for f in fail: P('[FAIL]', f)
        return finish(sp, meta, log, fail, a, t)
    vt = 'VT' + datetime.datetime.now().strftime('%H%M%S')
    sub = lambda s: s.replace(meta['bkD'], '%s_%s' % (TD, vt)).replace(meta['bkM'], '%s_%s' % (TM, vt))
    made = []
    try:
        for k in ('B1', 'B2'):
            tc.execute(sub(S[k])); made.append(k); P('[%s] 시험 백업 생성(시험 이름 꼬리 %s)' % (k, vt))
        tc.execute(sub(S['B3'])); b3 = tc.fetchone(); P('[B3]', b3)
        if b3[0] != b3[1] or b3[2] != b3[3]: fail.append('[B3] 백업 건수 다름 %s' % (b3,))
        tc.execute(S['O1']); o1a = tc.fetchone(); P('[O1] 실행 전', o1a)
        err = collections.Counter(); ex = {}; ok = 0; t0 = datetime.datetime.now()
        body = [r.rstrip().rstrip(';') for r in rows if r]
        for i in range(0, len(body), 200):
            ch = body[i:i + 200]
            try:
                tc.execute('BEGIN\n' + ';\n'.join(ch) + ';\nEND;'); ok += len(ch)
            except Exception:
                for r in ch:
                    try: tc.execute(r); ok += 1
                    except Exception as e:
                        k = str(e).split('\n')[0][:100]; err[k] += 1; ex.setdefault(k, r[:300])
        P('MERGE 실행', len(body), '문장 · 성공', ok, '· 오류', sum(err.values()), '· 걸린 시간', round((datetime.datetime.now() - t0).total_seconds(), 1), '초')
        for k, n in err.items(): fail.append('MERGE 오류 %d건 %s · 예 %s' % (n, k, ex[k][:200]))
        tc.execute(S['O1']); o1b = tc.fetchone(); P('[O1] 실행 뒤(트랜잭션 안)', o1b)
        if o1b[0] < mc or o1b[1] < dc: fail.append('[O1] 실행 뒤 건수 < [M1] (%s < %s)' % (o1b, (mc, dc)))
        tc.execute(S['O2']); P('[O2] 유형', len(tc.fetchall()))
        tc.execute(S['O3']); P('[O3] VALID_YN', tc.fetchall())
        compare(sp, S, ac, tc, P, fail)
        for k in ('R1', 'R2', 'R3', 'R4'):
            tc.execute(sub(S[k])); P('[%s] 처리 행 %d' % (k, tc.rowcount))
        tc.execute(sub(S['R5'])); r5 = tc.fetchone(); P('[R5]', r5)
        if any(r5): fail.append('[R5] 복원 확인 0 아님 %s' % (r5,))
    except Exception as e:
        fail.append('실행 오류 %s' % str(e).split('\n')[0][:200])
    finally:
        t.rollback(); tc.execute(S['O1']); o1c = tc.fetchone(); P('ROLLBACK 뒤 [O1]', o1c)
        for k, tb in (('B2', TD), ('B1', TM)):
            if k in made:
                try: tc.execute('DROP TABLE %s_%s PURGE' % (tb, vt)); P('시험 백업 삭제', '%s_%s' % (tb, vt))
                except Exception as e: fail.append('시험 백업 삭제 실패 %s_%s %s' % (tb, vt, str(e)[:100]))
    return finish(sp, meta, log, fail, a, t)


def compare(sp, S, ac, tc, P, fail):
    """MERGE 뒤 Oracle 값 = AS-IS 값(변환 규칙 적용) 인지 행, 칸 단위 대조"""
    def norm(c, v, detail):
        if isinstance(v, datetime.datetime): return v.replace(microsecond=0)
        if v is None: return '/' if (detail and c == 'VALID_YN') else None
        if not isinstance(v, str): return int(v)
        if c in SEG and v == '': return '-'
        if c in ATTR and v == '': return ' '
        if c == 'VALID_YN': return v.upper() or ('/' if detail else None)
        return None if v == '' else v
    P_ = mpred(sp)
    for tb, cols, detail in ((TM, MASTER, False), (TD, DETAIL, True)):
        kc = ['LOOKUP_TYPE'] + (SEG if detail else [])
        w = dpred(sp, 'dbo.' + TM, True) if detail else P_
        ac.execute('SELECT %s FROM dbo.%s %s WITH (NOLOCK) WHERE %s' % (', '.join(('D.' if detail else 'M.') + c for c in cols), tb, 'D' if detail else 'M', w))
        exp = {}
        for r in ac.fetchall():
            v = [norm(c, r[i], detail) for i, c in enumerate(cols)]; exp[tuple(v[cols.index(k)] for k in kc)] = v
        types = sorted({k[0] for k in exp})
        got = {}
        for i in range(0, len(types), 500):
            part = types[i:i + 500]
            tc.execute('SELECT %s FROM %s WHERE LOOKUP_TYPE IN (%s)' % (', '.join(cols), tb, ', '.join(':%d' % (j + 1) for j in range(len(part)))), part)
            for r in tc.fetchall():
                v = [(x.replace(microsecond=0) if isinstance(x, datetime.datetime) else (int(x) if isinstance(x, (int, float)) else x)) for x in r]; got[tuple(v[cols.index(k)] for k in kc)] = v
        miss = [k for k in exp if k not in got]
        diff = collections.Counter(); dx = {}
        for k in exp:
            if k in got:
                for i, c in enumerate(cols):
                    if exp[k][i] != got[k][i]: diff[c] += 1; dx.setdefault(c, (k, exp[k][i], got[k][i]))
        P('  대조 %s : AS-IS %d행 · Oracle 에 없음 %d · 값 다른 칸 %d' % (tb, len(exp), len(miss), sum(diff.values())))
        if miss: fail.append('%s MERGE 뒤 Oracle 에 없는 행 %d (예 %s)' % (tb, len(miss), miss[:3]))
        for c, n in diff.items(): fail.append('%s %s 값 다름 %d (예 %s)' % (tb, c, n, str(dx[c])[:160]))


def finish(sp, meta, log, fail, a, t):
    try: a.close(); t.close()
    except Exception: pass
    res = 'PASS' if not fail else 'FAIL'
    for f in fail: log.append('[FAIL] ' + f)
    log.append('결과 : %s · 실패 %d건' % (res, len(fail)))
    f = os.path.join(sp['dir'], meta['base'] + '_검증.txt')
    io.open(f, 'w', encoding='utf-8').write('\n'.join(['LOOKUP 이관 로컬 검증 ' + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
        '방식 : AS-IS 개발 MSSQL 에서 [M1] [M3] [M2] 실행 → ZIOUI1 에서 시험 이름 백업 생성 → MERGE → [O1]~[O3] → 대조 → [R1]~[R5] → ROLLBACK → 시험 백업 삭제',
        '대상 : ' + ' · '.join(meta['scope'])] + log) + '\n')
    print('[OUT]', os.path.relpath(f, ROOT).replace(os.sep, '/'))
    print('결과 :', res)
    return 0 if not fail else 1


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    if len(sys.argv) < 4 or sys.argv[1] not in ('gen', 'verify') or sys.argv[2] != '--module':
        print(__doc__); sys.exit(2)
    try:
        sys.exit((gen if sys.argv[1] == 'gen' else verify)(sys.argv[3]))
    except InputError as e:
        print('[FAIL] 입력 오류 :', e); sys.exit(3)
