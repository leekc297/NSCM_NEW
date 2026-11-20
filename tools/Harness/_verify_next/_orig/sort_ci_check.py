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


def judge(parts, is_text, nullable=lambda k: True):
    """parts ORDER BY 키 원문 · is_text(key) True 문자 / False 비문자 / None 모름"""
    if not parts:
        return 'NA', 'ORDER BY 없음'
    bad, unk, n, tie, cut, done = [], [], 0, [], [], set()
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
        miss = [x for x, ok in (('대소문자 무시', ci), ('NULL 먼저', nf)) if not ok]
        if miss:
            bad.append(f"{k}({'·'.join(miss)} 없음)")
        else:
            done.add(k)
    tail = (f" · 자료형 모름 {len(unk)}건({', '.join(unk[:4])})" if unk else '') + (f" · 동률 해소 키 {len(tie)}건({', '.join(tie[:4])})" if tie else '')         + (f" · [측정 경로 누락] 원문 잘림 {len(cut)}건({', '.join(cut[:4])}) — 판정 제외" if cut else '')
    if bad:
        return '판정필요', f'[SORT 기준 차이 → 판정필요] 문자 키 {len(bad)}/{n}건 AS-IS 콜레이션과 다를 수 있음: {", ".join(bad[:6])}{tail}'
    if cut:
        return 'ERROR', f'문자 키 {n}건 대소문자 무시·NULL 먼저{tail}'
    if not n:
        return 'NA', f'문자 정렬 키 없음{tail}'
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


def key_source(stmt, part):
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
        return None
    outer = bool(re.search(r'\b' + re.escape(al) + r'\.\w+\s*\(\+\)', stmt, re.I)) or bool(re.search(r'\b(LEFT|RIGHT|FULL)\s+(OUTER\s+)?JOIN\s+' + re.escape(tm.group(1)) + r'\s+' + re.escape(al) + r'\b', stmt, re.I))
    return tm.group(1).upper().split('.')[-1], col, outer


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
            stmt_now['s'] = stmt_before(proc_body(proc), ob)
            v, why = judge(split_keys(ob), is_text, nullable)
            res.append({'proc': proc, 'result': v, 'why': why, 'order_by': ob[:400]})
    with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'sort_ci.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(res)
    print(f'[sort_ci] {mid}: {len(res)}건 ' + str({k: sum(1 for x in res if x["result"] == k) for k in sorted({x["result"] for x in res})}))
    return 0


if __name__ == '__main__':
    sys.exit(selftest() if sys.argv[1] == '--selftest' else main(sys.argv[1].upper()))
