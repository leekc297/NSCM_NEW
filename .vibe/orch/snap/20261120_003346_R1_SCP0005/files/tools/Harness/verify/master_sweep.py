# -*- coding: utf-8 -*-
"""기준정보 존재·활성 스윕(2026-11-02 엔진 갭 EG455)

  python tools/Harness/verify/master_sweep.py <MENU_ID>   → Doc/verify/<ID>/master_sweep.csv (eg_ingest 가 N1 행으로 반입)
  python tools/Harness/verify/master_sweep.py --selftest   판정 변이 입증

  대상: 화면 PKG(proc_meta) 본문이 읽는 기준표(SCM_MST_*·SCM_ADM_* · 주석 제외)
  MASTER_KEY: 기준표 PK 키를 AS-IS 같은 이름 표와 대조 — AS-IS 에만 있는 키 = ERROR(확인 대상 · 원천 DB 시점 차이 가능이라 FAIL 로 올리지 않음)
  ACTIVE_CAND: 콤보 후보(combo_runtime.json) ↔ 활성 컬럼이 있는 SCM_* 표 전체(소유자 무관 · 시노님 뒤 FP_MGR 표 포함)의 PK 컬럼별 값 — 비활성 코드가 후보에 있으면 ERROR(확인 대상 · AS-IS 후보 대조는 combo_oracle)
  한계: AS-IS 표 이름이 다르면 NA · 키 값은 대문자·공백 제거·빈 값 센티널('-','/') 같은 값으로 비교
"""
import csv, json, os, re, sys, time

_HERE_ = os.path.dirname(os.path.abspath(__file__)); _ROOT_ = os.path.abspath(os.path.join(_HERE_, '..', '..', '..'))
CACHE_PATH = os.path.join(_ROOT_, 'Doc', 'verify', '_master_sweep_cache.json'); CACHE_TTL_SEC = 12 * 3600
try:
    _CACHE = json.load(open(CACHE_PATH, encoding='utf-8')) if os.path.exists(CACHE_PATH) else {}
except (OSError, ValueError):
    _CACHE = {}


def _cache_save():
    """GROUP BY 결과 캐시 저장(원자 교체 · 동시 실행 보호) — 바뀐 게 있을 때만"""
    if not _CACHE.pop('_dirty', False):
        return
    try:
        tmp = f'{CACHE_PATH}.{os.getpid()}.tmp'
        with open(tmp, 'w', encoding='utf-8') as f:
            json.dump(_CACHE, f, ensure_ascii=False)
        os.replace(tmp, CACHE_PATH)
    except OSError:
        pass

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); sys.path.insert(0, HERE)
from facts_sortrules import strip_comments  # noqa: E402  # SQL 주석 제거(T37)
csv.field_size_limit(10 ** 8)
COLS = ['kind', 'target', 'result', 'why']
RX_MST = re.compile(r'\b(?:SCM_MGR\.)?(SCM_(?:MST|ADM)_\w+)', re.I)
RX_ACTIVE = re.compile(r'^(ACTIVE_(FLAG|FLG|YN)|ACTV_(FLAG|YN)|USE_(YN|FLAG)|ENABLED_FLAG)$', re.I)
RX_BACKUP = re.compile(r'(BAK|BACK|_BK|_B2|_\d{6,}|^DROP_|__CT$)', re.I)
RX_HIST = re.compile(r'(_H|_HIS|_HIST|_HISTORY|_LOG|_BAK|_BACKUP)$', re.I)
MAX_ROWS = 300000
MIN_OVERLAP = 0.9  # 후보가 이 비율 이상 표의 키일 때만 그 표를 후보의 원천으로 본다


def norm_key(v):
    t = '' if v is None else str(v).strip().upper()
    return '' if t in ('-', '/') else t


def read_tables(body):
    return sorted({m.group(1).upper() for m in RX_MST.finditer(strip_comments(body))})


def pkg_literals(body):
    """PKG 본문(주석 제외)의 따옴표 문자열 상수 — 대문자·공백 제거"""
    return {norm_key(m.group(1)) for m in re.finditer(r"'([^'\n]{2,60})'", strip_comments(body)) if norm_key(m.group(1))}


def judge_keys(tbl, asis, tobe, scope=None):
    """asis·tobe = 키 튜플 집합 — AS-IS 0행은 비교 근거 없음
    scope = 화면 PKG 본문의 문자열 상수(+ 화면 ID). 2026-11-16 SCP0104(N1 미검증 8행): PKG 가 LOOKUP_TYPE='OPERATION_SPEED_UNIT' 처럼
      키 첫 컬럼을 상수로 거르는 공용 기준표는 표 전체를 대조하면 다른 화면 코드(CUST_FCST_MEASURE · DMF0021)까지 이 화면 미검증이 된다.
      키 첫 값이 scope 에 있는 키가 하나라도 있으면 그 키들만 대조한다(하나도 없으면 범위를 못 정한 것이라 표 전체 대조 유지)"""
    if not asis:
        return 'NA', f'{tbl} AS-IS 0행 — 비교 근거 없음(TO-BE {len(tobe)}행)'
    note = ''
    if scope:
        ins = {k for k in asis if k and k[0] in scope}
        if ins:
            note = f' · 범위 = 화면 PKG 조건 값 {len({k[0] for k in ins})}종(AS-IS 키 {len(ins)}/{len(asis)}건 · 범위 밖 {len(asis - ins - tobe)}건 제외)'
            asis = ins; tobe = {k for k in tobe if k and k[0] in scope}
    only = sorted(asis - tobe)
    if not only:
        return 'PASS', f'{tbl} AS-IS 키 {len(asis)}건 전부 TO-BE 에 있음(TO-BE 전용 {len(tobe - asis)}건){note}'
    smp = ', '.join('/'.join(k) for k in only[:5])
    return 'ERROR', f'[확인 대상] {tbl} AS-IS 키 {len(asis)}건 중 {len(only)}건 TO-BE 에 없음: {smp}{note}'


def _judge_keys_old(tbl, asis, tobe):
    """(사용 안 함 — 2026-11-16 범위 판정 이전 원형 보관)"""
    if not asis:
        return 'NA', f'{tbl} AS-IS 0행 — 비교 근거 없음(TO-BE {len(tobe)}행)'
    only = sorted(asis - tobe)
    if not only:
        return 'PASS', f'{tbl} AS-IS 키 {len(asis)}건 전부 TO-BE 에 있음(TO-BE 전용 {len(tobe - asis)}건)'
    smp = ', '.join('/'.join(k) for k in only[:5])
    return 'ERROR', f'[확인 대상] {tbl} AS-IS 키 {len(asis)}건 중 {len(only)}건 TO-BE 에 없음: {smp}'


def judge_active(label, cands, keys, inactive):
    """cands 후보 코드 · keys 표 키 전체 · inactive 비활성 키 — 후보가 그 표에서 온 것이 확인될 때만 판정"""
    c = {norm_key(x) for x in cands if norm_key(x)}
    if len(c) < 3:
        return None
    hit = c & keys
    if len(hit) / len(c) < MIN_OVERLAP:
        return None
    bad = sorted(c & inactive)
    if bad:
        return 'ERROR', f"[확인 대상] '{label}' 후보 {len(c)}건 중 비활성 {len(bad)}건: {', '.join(bad[:5])}"
    return 'PASS', f"'{label}' 후보 {len(c)}건 비활성 0"


def selftest():
    A = {('A',), ('B',)}
    cases = [
        ('키 같음', judge_keys('T', A, set(A))[0], 'PASS'),
        ('TO-BE 전용만', judge_keys('T', A, A | {('C',)})[0], 'PASS'),
        ('AS-IS 전용', judge_keys('T', A, {('A',)})[0], 'ERROR'),
        ('AS-IS 0행', judge_keys('T', set(), A)[0], 'NA'),
        ('범위 밖 키만 누락', judge_keys('T', {('X', '1'), ('Y', '1')}, {('X', '1')}, scope={'X'})[0], 'PASS'),
        ('범위 안 키 누락', judge_keys('T', {('X', '1'), ('X', '2')}, {('X', '1')}, scope={'X'})[0], 'ERROR'),
        ('범위 못 정함 = 전체 대조', judge_keys('T', {('Y', '1')}, set(), scope={'X'})[0], 'ERROR'),
        ('PKG 상수', 'OPERATION_SPEED_UNIT' in pkg_literals("WHERE LOOKUP_TYPE = 'OPERATION_SPEED_UNIT' -- 'ZZZ'"), True),
        ('센티널 동일', norm_key('-') == norm_key('/') == '', True),
        ('공백·대소문자', norm_key(' ab ') == 'AB', True),
        ('비활성 후보', judge_active('L', ['A', 'B', 'C'], {'A', 'B', 'C'}, {'C'})[0], 'ERROR'),
        ('활성만', judge_active('L', ['A', 'B', 'C'], {'A', 'B', 'C', 'D'}, {'D'})[0], 'PASS'),
        ('다른 표 후보', judge_active('L', ['A', 'B', 'C'], {'A', 'X'}, {'A'}), None),
        ('후보 부족', judge_active('L', ['A'], {'A'}, {'A'}), None),
        ('대리키', is_surrogate(['ID'], {('187',), ('188',)}), True),
        ('문자 키는 대리키 아님', is_surrogate(['ID'], {('187',), ('A',)}), False),
        ('복합 키는 대리키 아님', is_surrogate(['A', 'B'], {('1', '2')}), False),
        ('단일 키', key_cols('SCM_X_M', {'P': ['CODE_A']}), ['CODE_A']),
        ('복합 키 실체 컬럼', key_cols('SCM_PLANT_M', {'P': ['PLANT_ID', 'DIVISION_ID']}), ['PLANT_ID']),
        ('복합 키 다른 실체', key_cols('SCM_PLM_WO_TACT_TIME_M', {'P': ['DIVISION_ID', 'SEQ_NO']}), []),
        ('주석 표 제외', read_tables('-- SCM_MST_X\nSELECT 1 FROM scm_mgr.SCM_MST_Y'), ['SCM_MST_Y']),
    ]
    ok = 0
    for n, got, want in cases:
        if got == want: ok += 1
        else: print('FAIL', n, got, want)
    print(f'{ok}/{len(cases)}')
    return 0 if ok == len(cases) else 1


def iter_cands(j):
    """combo_runtime.json 의 실제 콤보 응답·그리드 셀 콤보(라벨, 코드 목록) — 조회조건 opts 는 표시 이름이라 제외"""
    for x in j.get('combos') or []:
        try: label = json.loads(x.get('body') or '{}').get('comboId') or 'combo'
        except ValueError: label = 'combo'
        lst = [i.get('c') for i in x.get('rows') or [] if isinstance(i, dict)]
        if lst: yield str(label), lst
    for k, x in (j.get('grid') or {}).items():
        lst = [i.get('c') for i in ((x or {}).get('newRow') or {}).get('items') or [] if isinstance(i, dict)]
        if lst: yield str(k), lst


def is_surrogate(pk, keys):
    """단일 숫자 PK = 채번 대리키 — DB 사이 값 대조 의미 없음"""
    return len(pk) == 1 and bool(keys) and all(k[0].isdigit() for k in keys)


def key_cols(tbl, by):
    """표의 실체 코드 컬럼만 — 단일 컬럼 키, 또는 표 이름에 이름이 든 복합 키 컬럼(SCM_PLANT_M.PLANT_ID) · 다른 실체의 코드(DIVISION_ID 등)는 우연히 후보와 겹치므로 제외"""
    out = []
    for cols in by.values():
        for c in cols:
            stem = re.sub(r'_(ID|CD|CODE)$', '', c, flags=re.I).upper()
            if (len(cols) == 1 or stem in tbl.upper().split('_')) and c not in out:
                out.append(c)
    return out


def active_rows(tc, cands):
    """활성 컬럼 표마다 PK 컬럼을 후보 원천으로 시험 — 한 코드의 행 중 하나라도 활성이면 활성"""
    out = []
    if not cands:
        return out
    tc.execute("""SELECT C.OWNER, C.TABLE_NAME, C.COLUMN_NAME FROM ALL_TAB_COLUMNS C JOIN ALL_TABLES T ON T.OWNER=C.OWNER AND T.TABLE_NAME=C.TABLE_NAME
                  WHERE C.OWNER IN ('SCM_MGR','FP_MGR') AND C.COLUMN_NAME IN ('ACTIVE_FLAG','ACTIVE_FLG','ACTIVE_YN','ACTV_FLAG','ACTV_YN','USE_YN','USE_FLAG','ENABLED_FLAG')
                  AND C.TABLE_NAME LIKE 'SCM\\_%' ESCAPE '\\' AND NVL(T.NUM_ROWS, 0) <= :n""", n=MAX_ROWS)
    seen, done = set(), set()
    for owner, tbl, flag in list(tc.fetchall()):
        if RX_BACKUP.search(tbl) or RX_HIST.search(tbl) or (owner, tbl) in seen:
            continue
        seen.add((owner, tbl))
        tc.execute("""SELECT K.CONSTRAINT_NAME, C.COLUMN_NAME FROM ALL_CONSTRAINTS K JOIN ALL_CONS_COLUMNS C ON C.OWNER=K.OWNER AND C.CONSTRAINT_NAME=K.CONSTRAINT_NAME
                      WHERE K.OWNER=:o AND K.TABLE_NAME=:t AND K.CONSTRAINT_TYPE IN ('P','U') ORDER BY C.POSITION""", o=owner, t=tbl)
        by = {}
        for k, c in tc.fetchall():
            by.setdefault(k, []).append(c)
        for col in key_cols(tbl, by):
            # 2026-11-08 속도: 표×키 컬럼마다 GROUP BY 전체 스캔(SCP0122 실측 36s · post 단계의 70%) → 12시간 캐시(Doc/verify/_master_sweep_cache.json · 기준표 활성값은 하루 안에 거의 안 바뀜 · 결과 동일)
            ck = f'{owner}.{tbl}.{col}|{flag}'
            hit = _CACHE.get(ck)
            if hit and (time.time() - float(hit.get('at') or 0)) < CACHE_TTL_SEC:
                rows = [tuple(x) for x in hit['rows']]
            else:
                try:
                    tc.execute(f'SELECT "{col}", MAX(CASE WHEN UPPER("{flag}") IN (\'Y\',\'1\',\'TRUE\') THEN 1 ELSE 0 END) FROM {owner}."{tbl}" GROUP BY "{col}"')
                except Exception as e:  # 권한 없는 표
                    out.append({'kind': 'ACTIVE_CAND', 'target': f'{owner}.{tbl}', 'result': 'ERROR', 'why': f'[측정 경로 없음] {str(e)[:80]}'})
                    break
                rows = tc.fetchall()
                _CACHE[ck] = {'at': time.time(), 'rows': [[None if a is None else str(a), int(b or 0)] for a, b in rows]}; _CACHE['_dirty'] = True
            keys = {norm_key(a) for a, _ in rows}
            inactive = {norm_key(a) for a, b in rows if not b}
            if not inactive:
                continue
            for label, lst in cands:
                j = judge_active(label, lst, keys, inactive)
                t = f'{owner}.{tbl}.{col}|{label}'
                if j and t not in done:
                    done.add(t)
                    out.append({'kind': 'ACTIVE_CAND', 'target': t, 'result': j[0], 'why': j[1]})
    return out


def main(mid):
    from dbconn import connect
    pm = [r for r in csv.DictReader(open(os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'proc_meta.csv'), encoding='utf-8-sig', newline='')) if (r.get('menu_id') or '').upper() == mid.upper()]
    pkgs = sorted({r['proc'].split('.')[0].upper() for r in pm})
    res, tables = [], set()
    p_rt = os.path.join(ROOT, 'Doc', 'verify', mid, 'combo_runtime.json')
    cands = list(iter_cands(json.load(open(p_rt, encoding='utf-8-sig')))) if os.path.exists(p_rt) else []
    with connect('tobe') as tcx, connect('asis') as acx:
        tc = tcx.cursor(); ac = (getattr(acx, 'cx', acx)).cursor()
        lits = {mid.upper()}  # 화면 PKG 본문의 문자열 상수(LOOKUP_TYPE·PROGRAM_ID 조건 값) — 키 대조 범위
        for pkg in pkgs:
            tc.execute("SELECT TEXT FROM ALL_SOURCE WHERE NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=pkg)
            _body = ''.join(x[0] for x in tc.fetchall())
            tables |= set(read_tables(_body)); lits |= pkg_literals(_body)
        for tbl in sorted(tables):
            tc.execute("SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME=:t", t=tbl)
            if not tc.fetchone()[0]:
                continue  # 뷰·시노님은 기준표 아님
            tc.execute("""SELECT C.COLUMN_NAME FROM ALL_CONSTRAINTS K JOIN ALL_CONS_COLUMNS C ON C.OWNER=K.OWNER AND C.CONSTRAINT_NAME=K.CONSTRAINT_NAME
                          WHERE K.TABLE_NAME=:t AND K.CONSTRAINT_TYPE='P' ORDER BY C.POSITION""", t=tbl)
            pk = [r[0] for r in tc.fetchall()]
            if not pk:  # PK 없는 표는 첫 유일 인덱스를 키로
                tc.execute("""SELECT C.COLUMN_NAME FROM ALL_INDEXES I JOIN ALL_IND_COLUMNS C ON C.INDEX_OWNER=I.OWNER AND C.INDEX_NAME=I.INDEX_NAME
                              WHERE I.TABLE_NAME=:t AND I.UNIQUENESS='UNIQUE' AND I.INDEX_NAME=(SELECT MIN(INDEX_NAME) FROM ALL_INDEXES WHERE TABLE_NAME=:t2 AND UNIQUENESS='UNIQUE') ORDER BY C.COLUMN_POSITION""", t=tbl, t2=tbl)
                pk = [r[0] for r in tc.fetchall()]
            tc.execute('SELECT COLUMN_NAME, DATA_TYPE FROM ALL_TAB_COLUMNS WHERE TABLE_NAME=:t', t=tbl)
            ctypes = dict(tc.fetchall()); tcols = set(ctypes)
            pk = [c for c in pk if not re.match(r'DATE|TIMESTAMP', ctypes.get(c, ''))]  # 일시 키 컬럼은 등록 시점 값이라 대조에서 제외
            pk_src = 'TO-BE PK·유일 인덱스'
            if not pk:
                # 2026-11-18 미검증 해소(SCP0096 SCM_ADM_MSG_M·SCM_MST_PLAN_DETAIL 'PK 없음'): TO-BE 에 PK·유일 인덱스가 없으면 AS-IS 표의 PK(없으면 첫 유일 인덱스)를 키로 쓴다
                try:
                    ac.execute("""SELECT c.name FROM sys.indexes i JOIN sys.index_columns ic ON ic.object_id=i.object_id AND ic.index_id=i.index_id
                                  JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
                                  WHERE i.object_id=OBJECT_ID(?) AND (i.is_primary_key=1 OR i.is_unique=1) AND ic.is_included_column=0
                                  AND i.index_id=(SELECT TOP 1 index_id FROM sys.indexes WHERE object_id=OBJECT_ID(?) AND (is_primary_key=1 OR is_unique=1) ORDER BY is_primary_key DESC, index_id)
                                  ORDER BY ic.key_ordinal""", (f'dbo.{tbl}', f'dbo.{tbl}'))
                    apk = [r[0].upper() for r in ac.fetchall()]
                except Exception:
                    apk = []
                pk = [c for c in apk if c in tcols and not re.match(r'DATE|TIMESTAMP', ctypes.get(c, ''))] if apk and all(c in tcols for c in apk) else []
                pk_src = 'AS-IS PK·유일 인덱스(TO-BE 에 없음)'
            if not pk:
                # 2026-11-18 미검증 해소(SCP0096 SCM_ADM_MSG_M): AS-IS 에 같은 표가 없으면 키가 없어도 대조 대상 아님 — 'PK 없음' 오류보다 먼저 본다
                ac.execute('SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ?', tbl)
                if not ac.fetchone()[0]:
                    res.append({'kind': 'MASTER_KEY', 'target': tbl, 'result': 'NA', 'why': 'AS-IS 에 같은 이름 표 없음(TO-BE 신설·이름 변경) · 키 정의 없음'})
                    continue
                # 2026-11-18 미검증 해소(SCP0096 SCM_MST_PLAN_DETAIL): 양쪽 모두 PK·유일 인덱스가 없으면 첫 일반 인덱스 컬럼 조합을 식별 키로(중복 허용 · 키 조합 존재 대조)
                tc.execute("""SELECT C.COLUMN_NAME FROM ALL_INDEXES I JOIN ALL_IND_COLUMNS C ON C.INDEX_OWNER=I.OWNER AND C.INDEX_NAME=I.INDEX_NAME
                              WHERE I.TABLE_NAME=:t AND I.INDEX_NAME=(SELECT MIN(INDEX_NAME) FROM ALL_INDEXES WHERE TABLE_NAME=:t2) ORDER BY C.COLUMN_POSITION""", t=tbl, t2=tbl)
                ix = [r[0] for r in tc.fetchall()]
                if not ix:
                    try:
                        ac.execute("""SELECT c.name FROM sys.indexes i JOIN sys.index_columns ic ON ic.object_id=i.object_id AND ic.index_id=i.index_id JOIN sys.columns c ON c.object_id=ic.object_id AND c.column_id=ic.column_id
                                      WHERE i.object_id=OBJECT_ID(?) AND i.index_id=(SELECT MIN(index_id) FROM sys.indexes WHERE object_id=OBJECT_ID(?) AND index_id>0) AND ic.is_included_column=0 ORDER BY ic.key_ordinal""", (f'dbo.{tbl}', f'dbo.{tbl}'))
                        ix = [r[0].upper() for r in ac.fetchall()]
                    except Exception:
                        ix = []
                pk = [c for c in ix if c in tcols and not re.match(r'DATE|TIMESTAMP', ctypes.get(c, ''))]
                pk_src = '일반 인덱스 컬럼(PK·유일 인덱스 없음 · 중복 허용)'
            if RX_HIST.search(tbl):
                res.append({'kind': 'MASTER_KEY', 'target': tbl, 'result': 'NA', 'why': '이력·로그 표 — 기준정보 아님'})
                continue
            if not pk:
                res.append({'kind': 'MASTER_KEY', 'target': tbl, 'result': 'ERROR', 'why': '[측정 경로 없음] PK 없음 — 키 대조 불가'})
                continue
            tc.execute(f'SELECT COUNT(*) FROM {tbl}')
            n = tc.fetchone()[0]
            if n > MAX_ROWS:
                res.append({'kind': 'MASTER_KEY', 'target': tbl, 'result': 'NA', 'why': f'{n}행 — 트랜잭션성 대량 표(상한 {MAX_ROWS})'})
                continue
            sel = ','.join(pk)
            tc.execute(f'SELECT {sel} FROM {tbl}')
            tkeys = {tuple(norm_key(v) for v in r) for r in tc.fetchall()}
            ac.execute('SELECT UPPER(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ?', tbl)
            acols = {r[0] for r in ac.fetchall()}
            if not acols:
                res.append({'kind': 'MASTER_KEY', 'target': tbl, 'result': 'NA', 'why': 'AS-IS 에 같은 이름 표 없음(TO-BE 신설·이름 변경)'})
            elif not set(pk) <= acols:
                res.append({'kind': 'MASTER_KEY', 'target': tbl, 'result': 'NA', 'why': f"PK 컬럼 {sorted(set(pk) - acols)} AS-IS 에 없음"})
            else:
                # 2026-11-18(SCP0096 N1 EG-d98bd5c6): AS-IS 개발 DB 에 시험용으로 넣은 행(ATTRIBUTE* = 'ASISLIVE_TEST_…' 표시)은 이관 대상이 아니므로 대조에서 뺀다
                _tc = sorted(c for c in acols if re.fullmatch(r'ATTRIBUTE\d+', c))
                _tw = (' WHERE NOT (' + ' OR '.join(f"ISNULL(CONVERT(nvarchar(100),[{c}]),'') LIKE 'ASISLIVE_TEST%'" for c in _tc) + ')') if _tc else ''
                ac.execute(f"SELECT {','.join('[' + c + ']' for c in pk)} FROM dbo.[{tbl}] WITH(NOLOCK){_tw}")
                akeys = {tuple(norm_key(v) for v in r) for r in ac.fetchall()}
                _ntest = 0
                if _tw:
                    ac.execute(f"SELECT COUNT(*) FROM dbo.[{tbl}] WITH(NOLOCK) WHERE ({_tw[12:-1]})"); _ntest = ac.fetchone()[0]
                if is_surrogate(pk, akeys | tkeys):
                    res.append({'kind': 'MASTER_KEY', 'target': tbl, 'result': 'NA', 'why': f'단일 숫자 대리키 {pk[0]} — DB 사이 값 대조 의미 없음'})
                    continue
                r, why = judge_keys(tbl, akeys, tkeys, scope=lits)
                res.append({'kind': 'MASTER_KEY', 'target': tbl, 'result': r, 'why': why + ('' if pk_src.startswith('TO-BE') else f' · 키 = {pk_src} {pk}') + (f' · AS-IS 시험 표시 행(ASISLIVE_TEST) {_ntest}행 제외' if _ntest else '')})
        res += active_rows(tc, cands)
    p = os.path.join(ROOT, 'Doc', 'verify', mid, 'master_sweep.csv')
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, COLS); w.writeheader(); w.writerows(res)
    c = {}
    for x in res: c[x['result']] = c.get(x['result'], 0) + 1
    _cache_save()
    print(f'[master_sweep] {mid} 표 {len(tables)} · {c} → {p}')
    return 0


if __name__ == '__main__':
    if len(sys.argv) < 2: sys.exit(__doc__)
    sys.exit(selftest() if sys.argv[1] == '--selftest' else main(sys.argv[1].upper()))
