# -*- coding: utf-8 -*-
"""DB 참조 정합(2026-11-02 엔진 갭 EG142·EG143)

  python tools/Harness/verify/db_ref_check.py <MENU_ID>   → Doc/verify/<ID>/db_ref.csv (eg_ingest 가 DB-SYN 행으로 반입)
  python tools/Harness/verify/db_ref_check.py --selftest   판정 변이 입증

  EG142: 화면 PKG(proc_meta) 본문의 AS-IS 사용자 테이블(TB_FX_*) 참조 — 주석 제외 · 있으면 FAIL
  EG143: UI Category ATTRIBUTE9(콤보 SQL ID) ↔ SCM_ADM_CMBO_SQL_M — 없는 ID·미사용(USE_YN≠Y) FAIL · 대소문자만 다르면 ERROR(확인 대상)
  소스·메타만 읽는다(새로 조회 · hook #152)
"""
import csv, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); sys.path.insert(0, HERE)
from facts_sortrules import strip_comments  # noqa: E402  # SQL 주석 제거(T37)
csv.field_size_limit(10 ** 8)
COLS = ['kind', 'target', 'result', 'why']
RX_TB = re.compile(r'\bTB_FX_\w+', re.I)


def judge_tbfx(body):
    hits = sorted({x.upper() for x in RX_TB.findall(body or '')})
    if hits:
        return 'FAIL', f'AS-IS 사용자 테이블 참조 {len(hits)}종: {hits[:6]}'
    return 'PASS', 'TB_FX_* 참조 0'


def judge_attr9(sql_id, master):
    """master: {SQL_ID: USE_YN}"""
    if sql_id in master:
        return ('PASS', f"콤보 SQL '{sql_id}' 실존") if master[sql_id] == 'Y' else ('FAIL', f"콤보 SQL '{sql_id}' 미사용(USE_YN={master[sql_id]})")
    near = [k for k in master if k.lower() == sql_id.lower()]
    if near:
        return 'ERROR', f"[확인 대상] '{sql_id}' 와 대소문자만 다른 '{near[0]}' 있음 — 조회가 대소문자를 구분하면 후보 없음"
    return 'FAIL', f"콤보 SQL '{sql_id}' 없음(SCM_ADM_CMBO_SQL_M)"


RX_SSO = re.compile(r'\bSCM_MST_SSO_USER_INFO\b', re.I)
RX_SITE = re.compile(r'\bSCM_MST_SITE_ITEM\b', re.I)


def judge_team_src(pkg, body):
    """Team(DEPT) 원천 = SCM_MST_SITE_ITEM.DEPT_ID 만 — OWNER→SCM_MST_SSO_USER_INFO.DEPT_ID 경유 금지(EG076·EG247). 주석 제외 본문"""
    lines = (body or '').splitlines(); hits = []
    for i, t in enumerate(lines):
        m = RX_SSO.search(t)
        if not m:
            continue
        # 경유 = SSO_USER_INFO 별칭으로 DEPT_ID 를 읽는 것 — Owner 이름 조회 조인은 대상 아님(2026-11-02 PKG_DMF0003·0082 허위 후보)
        am = re.match(r'\s+(?!ON\b|WHERE\b|JOIN\b|LEFT\b|INNER\b)(\w+)', t[m.end():], re.I)
        alias = am.group(1) if am else ''
        near = ' '.join(lines[max(0, i - 12):i + 13])
        if alias and re.search(rf'\b{re.escape(alias)}\.DEPT_ID\b', near, re.I) and re.search(r'\bOWNER\b', near, re.I):
            hits.append(i + 1)
    if hits:
        return 'ERROR', f'[확인 대상] {pkg} 에 OWNER→SSO_USER_INFO.DEPT_ID 경유 후보 {len(hits)}곳(본문 줄 {hits[:4]}) — Team 원천은 SITE_ITEM.DEPT_ID 만'
    if not RX_SITE.search(body or ''):
        return 'NA', f'{pkg} 에 SCM_MST_SITE_ITEM 참조 없음 — Team 원천 판정 대상 아님'
    return 'PASS', f'{pkg} OWNER 경유 없음 · SCM_MST_SITE_ITEM 참조'


def judge_team_val(rows, master):
    """그리드 Team 값 ↔ SCM_MST_SITE_ITEM.DEPT_ID (EG076·EG038·EG077). rows = [{key, dept}] · master = {key: {dept 집합}}
    원장에 없는 키는 판정 제외(건수만 기록) · 원장이 비었는데 그리드에 값이 있으면 다른 원천 → FAIL"""
    if not rows:
        return 'ERROR', '[측정 경로 없음] 그리드 Team 값 덤프 0행'
    bad, none, ok = [], 0, 0
    for r in rows:
        m = master.get(r['key'])
        if m is None:
            none += 1
            continue
        g = (r.get('dept') or '').strip()
        real = {x for x in m if x and x not in ('-', '/')}
        grid_empty = g in ('', '-', '/')
        if (grid_empty and not real) or g in m:
            ok += 1
        else:
            bad.append(f"{'/'.join(r['key'])} 화면 '{g}' ↔ 원장 {sorted(m)[:3]}")
    if not ok and not bad:
        return 'ERROR', f'[측정 경로 없음] 원장에 없는 키만 {none}행'
    if bad:
        return 'FAIL', f'Team 값 불일치 {len(bad)}행 / 대조 {ok + len(bad)}행(원장 없음 {none}): {bad[:3]}'
    return 'PASS', f'Team 값 = SITE_ITEM.DEPT_ID {ok}행 일치(원장 없음 {none})'


def judge_team_name(rows):
    """부서 코드가 있는 행의 팀명 표시 (EG010·EG058 · 문서 GAP-205). rows = [{dept, name}] · 팀명 칸 없으면 대상 아님"""
    t = [r for r in rows if 'name' in r and r['name'] is not None]
    if not t:
        return 'NA', '그리드에 팀명 칸 없음'
    has = [r for r in t if (r.get('dept') or '').strip() not in ('', '-', '/')]
    if not has:
        return 'NA', '부서 코드 있는 행 없음'
    blank = [r['dept'] for r in has if not str(r.get('name') or '').strip()]
    code = [r['dept'] for r in has if str(r.get('name') or '').strip() == r['dept'].strip()]
    if blank:
        return 'FAIL', f"부서 코드 있는 {len(has)}행 중 팀명 빈 칸 {len(blank)}행(부서 {sorted(set(blank))[:4]})"
    if code:
        return 'ERROR', f"[확인 대상] 팀명 칸에 코드 그대로 {len(code)}행(부서 {sorted(set(code))[:4]}) — 이름 사전 미등록 여부 확인"
    return 'PASS', f'부서 코드 있는 {len(has)}행 팀명 표시'


RX_INS = re.compile(r'\bINSERT\s+INTO\s+(?:\w+\.)?(\w+)\s*\(([^()]*)\)\s*VALUES\s*\(', re.I)
RX_SENT = re.compile(r"NVL\s*\(.*,\s*'/'\s*\)\s*$|^'/'$", re.I | re.S)


def split_top(t):
    """최상위 콤마로 나눈다(괄호·문자열 안 콤마 제외)"""
    out, d, q, cur = [], 0, False, []
    for ch in t:
        if ch == "'":
            q = not q
        if not q:
            if ch == '(':
                d += 1
            elif ch == ')':
                d -= 1
            elif ch == ',' and d == 0:
                out.append(''.join(cur).strip()); cur = []
                continue
        cur.append(ch)
    if ''.join(cur).strip():
        out.append(''.join(cur).strip())
    return out


def sentinel_inserts(body):
    """INSERT … VALUES 문에서 '/' 를 넣는 칸 → [(표, 칸, 식)] (EG454)"""
    hits = []
    for m in RX_INS.finditer(body or ''):
        st, d, i = m.end(), 1, m.end()
        while i < len(body) and d:
            d += {'(': 1, ')': -1}.get(body[i], 0)
            i += 1
        cols, vals = split_top(m.group(2)), split_top(body[st:i - 1])
        if len(cols) != len(vals):
            continue
        if re.match(r'GT_', m.group(1), re.I):
            continue  # 임시 표 — 문서 규칙은 영구 원장 적재 대상(2026-11-02 PKG_DMF0044 GT_0044 허위 후보)
        hits += [(m.group(1).upper(), c.strip().upper(), v) for c, v in zip(cols, vals) if RX_SENT.search(v.strip())]
    return hits


def judge_null_rule(hits, nullable):
    """NULL 허용 칸에 '/' 적재 = 위반 후보 — 문서 규칙: NULL 허용 칸 NULL · NOT NULL 키 칸만 '/'. nullable = {(표, 칸): 'Y'|'N'}"""
    if not hits:
        return 'NA', "INSERT VALUES 에 '/' 적재 없음"
    bad = sorted({f'{t}.{c}' for t, c, _ in hits if nullable.get((t, c)) == 'Y'})
    unk = sorted({f'{t}.{c}' for t, c, _ in hits if (t, c) not in nullable})
    if bad:
        return 'ERROR', f"[확인 대상] NULL 허용 칸에 '/' 적재 {len(bad)}개: {bad[:6]} — 문서 규칙은 NULL 저장"
    if unk:
        return 'ERROR', f"[측정 경로 없음] 칸 정의 못 찾음 {unk[:4]}"
    return 'PASS', f"'/' 적재 {len(hits)}칸 전부 NOT NULL 칸"


RX_LIKE = re.compile(r"((?:NVL\s*\()?[\w.]+(?:\s*,[^)]*\))?)\s+LIKE\s+'%'\s*\|\|\s*(?:UPPER\s*\(\s*)?(\w+)", re.I)


def like_null_hits(body):
    """NULL 칸이 조건 때문에 탈락하는 LIKE 후보(EG246·EG435) — `칸 LIKE '%'||p||'%'` 인데 칸에 NVL 없고 앞뒤에 `p IS NULL OR` 가드도 없음"""
    out = []
    for m in RX_LIKE.finditer(body or ''):
        col, var = m.group(1), m.group(2)
        if col.upper().startswith('NVL'):
            continue
        near = (body or '')[max(0, m.start() - 160):m.end() + 100].upper()
        if re.search(rf"\b{re.escape(var.upper())}\s+IS\s+NULL\b|NVL\s*\(\s*{re.escape(var.upper())}\s*,\s*'%'|\b{re.escape(var.upper())}\s*=\s*'ALL'|\b{re.escape(var.upper())}\s*IS\s+NOT\s+NULL", near):
            continue
        out.append(f'{col}~{var}@{(body or "").count(chr(10), 0, m.start()) + 1}')
    return out


def judge_like_null(pkg, hits):
    if not hits:
        return 'PASS', f"{pkg} 가드 없는 LIKE 0"
    return 'ERROR', f"[확인 대상] {pkg} 가드 없는 LIKE {len(hits)}곳 — 칸이 NULL 인 행이 조건 때문에 탈락 가능: {hits[:5]}"


def judge_amp(col, asis, tobe):
    """AS-IS 라벨에 & 가 있을 때 TO-BE 라벨 대조 — EG328"""
    a, t = (asis or '').strip(), (tobe or '').strip()
    if a == t:
        return 'PASS', f"{col} 라벨 '{t}' = AS-IS"
    if '&' in a and '&' not in t and (a.split('&')[0].strip() == t or a.startswith(t)):
        return 'FAIL', f"{col} 라벨 '&' 뒤 잘림 — AS-IS '{a}' ↔ TO-BE '{t}'"
    if '&' in a and '&' not in t:
        return 'ERROR', f"[확인 대상] {col} AS-IS '{a}' 의 & 가 TO-BE '{t}' 에 없음 — 의도한 변경인지 확인"
    return 'PASS', f"{col} TO-BE '{t}' & 유지(AS-IS '{a}')"


RX_ISNULL_EQ = re.compile(r"ISNULL\(\s*(?:\[?\w+\]?\.)?\[?(\w+)\]?\s*,\s*N?'[^']*'\s*\)\s*=\s*ISNULL\(\s*(?:\[?\w+\]?\.)?\[?(\w+)\]?", re.I)


def null_join_pairs(asis_sql):
    """AS-IS 조인·판정의 양변 ISNULL 비교 컬럼 쌍(EG005) — 빈 값끼리 같다고 보는 결합"""
    return sorted({(a.upper(), b.upper()) for a, b in RX_ISNULL_EQ.findall(asis_sql)})


def judge_null_join(pkg, pairs, body):
    """TO-BE 본문에 같은 쌍을 NVL 없이 = 로 잇는 곳이 있으면 빈 값 행이 빠질 수 있다 — 행 수 차이는 golden·a1 이 재므로 확인 대상"""
    if not pairs:
        return 'NA', 'AS-IS 양변 ISNULL 결합 없음'
    bad = []
    for a, b in pairs:
        if re.search(rf"(?<!\()\b\w+\.{a}\s*=\s*\w+\.{b}\b(?!\s*,)", body, re.I):
            bad.append(f'{a}={b}')
    if bad:
        return 'ERROR', f"[확인 대상] {pkg} AS-IS 양변 빈 값 결합 {len(pairs)}쌍 중 {len(bad)}쌍을 NVL 없이 비교: {', '.join(bad[:6])}"
    return 'PASS', f'{pkg} AS-IS 양변 빈 값 결합 {len(pairs)}쌍 — NVL 없는 직접 비교 0'


def empty_eq_hits(body):
    """Oracle 에서 항상 거짓인 빈 문자열 비교(X = '' · X <> '') — 문자열 리터럴 안(동적 SQL)은 제외(EG005 GAP-196·198)"""
    out = []
    for ln in body.splitlines():
        for m in re.finditer(r"([\w.]+)\s*(<>|!=|(?<![:<>!])=)\s*''(?=\s*(?:$|\)|;|AND\b|OR\b|THEN\b))", ln, re.I):  # 뒤에 값이 이어지면(= ''RTF'') 여러 줄 동적 SQL 의 따옴표
            if ln[:m.start()].count("'") % 2 == 0:
                out.append(f"{m.group(1)} {m.group(2)} ''")
    return out


def judge_empty_eq(pkg, hits):
    if not hits:
        return 'PASS', f"{pkg} 빈 문자열 직접 비교 0"
    return 'ERROR', f"[확인 대상] {pkg} Oracle 에서 항상 거짓인 빈 문자열 비교 {len(hits)}곳: {', '.join(sorted(set(hits))[:6])}"


def json_short_hits(body):
    """JSON_OBJECT·JSON_ARRAYAGG 가 RETURNING CLOB 없이 쓰인 곳 — 기본 VARCHAR2(4000) 라 대량이면 ORA-40478(EG207 GAP-260)"""
    out = []
    for m in re.finditer(r'\bJSON_(OBJECT|ARRAYAGG|ARRAY)\s*\(', body, re.I):
        d, i = 1, m.end()
        while i < len(body) and d:
            d += {'(': 1, ')': -1}.get(body[i], 0); i += 1
        if not re.search(r'RETURNING\s+CLOB', body[m.start():i], re.I):
            out.append(body[:m.start()].count('\n') + 1)
    return out


def select_into_hits(body):
    """빈 결과 처리 없는 단건 SELECT INTO(EG208 ORA-01403) — 집계·DUAL·ROWNUM 없이 바로 뒤 NO_DATA_FOUND 처리도 없는 곳"""
    out = []
    for m in re.finditer(r'\bSELECT\b((?:(?!;|\bSELECT\b).){1,1500}?)\bINTO\s+(\w+)\b((?:(?!;).){0,1500});', body, re.I | re.S):
        head, tail = m.group(1), m.group(3)
        if body[:m.start()].count("'") % 2:  # 동적 SQL 문자열 안
            continue
        if re.search(r'\b(COUNT|MAX|MIN|SUM|AVG|LISTAGG)\s*\(', head, re.I) or re.search(r'\bDUAL\b', tail, re.I):
            continue
        if re.search(r'\bFROM\b', head, re.I):  # INSERT … SELECT … 의 서브쿼리 절
            continue
        if re.search(r'\bEXCEPTION\b\s+WHEN\s+(NO_DATA_FOUND|OTHERS)\b', body[m.end():m.end() + 400], re.I):
            continue
        out.append((body[:m.start()].count('\n') + 1, m.group(2)))
    return out


def judge_source(body, mode, regex, desc):
    """문서가 소스 내용을 정한 항목(EG167·EG157) — 주석 뺀 본문 기준 · present = 있어야 함 · absent = 없어야 함"""
    if not body:
        return 'ERROR', f'[측정 경로 없음] {desc}: 패키지 본문 없음'
    hit = re.search(regex, body, re.I)
    if mode == 'absent':
        return ('FAIL', f"{desc}: 없어야 할 '{hit.group(0)[:60]}' 이 남아 있음(줄 {body[:hit.start()].count(chr(10)) + 1})") if hit else ('PASS', f'{desc}: 해당 코드 없음')
    return ('PASS', f"{desc}: '{hit.group(0)[:60]}' 있음(줄 {body[:hit.start()].count(chr(10)) + 1})") if hit else ('FAIL', f'{desc}: /{regex[:60]}/ 없음')


def judge_team_combo(cid, sql, procs):
    """Team 콤보 원천 = SSPM SITE_ITEM.DEPT_ID(EG080) — SQL 또는 그 SQL 이 부르는 PROC 본문에 표가 있어야 한다"""
    if not sql:
        return 'ERROR', f'[측정 경로 없음] 콤보 {cid} SQL 없음'
    if re.search(r'SITE_ITEM', sql, re.I):
        return 'PASS', f'콤보 {cid} SQL 이 SITE_ITEM 을 읽음'
    if any(re.search(r'SITE_ITEM', x, re.I) for x in procs.values()):
        return 'PASS', f"콤보 {cid} 호출 PROC {list(procs)[:2]} 이 SITE_ITEM 을 읽음"
    return 'ERROR', f"[확인 대상] 콤보 {cid} 원천에 SITE_ITEM 없음 — Team 은 SSPM DEPT_ID 기준 · 호출 PROC {list(procs)[:3]}"


def selftest():
    m = {'Aa': 'Y', 'Bb': 'N'}
    cases = [('가드 없는 LIKE', judge_like_null('P', like_null_hits("where a.x like '%' || p_x || '%'"))[0], 'ERROR'), ('NULL 가드', judge_like_null('P', like_null_hits("where (p_x is null or a.x like '%' || p_x || '%')"))[0], 'PASS'), ('칸 NVL', judge_like_null('P', like_null_hits("where nvl(a.x,' ') like '%' || p_x || '%'"))[0], 'PASS'), ('값 NVL %', judge_like_null('P', like_null_hits("where a.x like '%' || nvl(p_x,'%') || '%'"))[0], 'ERROR'), ('NULL 칸 / 적재', judge_null_rule(sentinel_inserts("insert into T (A, B) values (NVL(x,'/'), 1)"), {('T', 'A'): 'Y'})[0], 'ERROR'), ('NOT NULL 칸 /', judge_null_rule(sentinel_inserts("insert into T (A, B) values (NVL(x,'/'), 1)"), {('T', 'A'): 'N'})[0], 'PASS'), ('/ 없음', judge_null_rule(sentinel_inserts('insert into T (A) values (x)'), {})[0], 'NA'), ('임시 표 제외', str(len(sentinel_inserts("insert into GT_A (A) values (NVL(x,'/'))"))), '0'), ('함수 안 콤마', str(len(sentinel_inserts("insert into T (A, B) values (F(x, 1), '/')"))), '1'), ('팀명 표시', judge_team_name([{'dept': 'D', 'name': '영업'}])[0], 'PASS'), ('팀명 빈 칸', judge_team_name([{'dept': 'D', 'name': ''}])[0], 'FAIL'), ('팀명 = 코드', judge_team_name([{'dept': 'D', 'name': 'D'}])[0], 'ERROR'), ('팀명 칸 없음', judge_team_name([{'dept': 'D'}])[0], 'NA'), ('부서 없음', judge_team_name([{'dept': '/', 'name': ''}])[0], 'NA'), ('Team 값 일치', judge_team_val([{'key': ('a',), 'dept': 'D1'}], {('a',): {'D1'}})[0], 'PASS'), ('Team 값 다름', judge_team_val([{'key': ('a',), 'dept': 'D2'}], {('a',): {'D1'}})[0], 'FAIL'), ('원장 비고 화면 값', judge_team_val([{'key': ('a',), 'dept': 'D2'}], {('a',): {''}})[0], 'FAIL'), ('둘 다 빈 값', judge_team_val([{'key': ('a',), 'dept': '/'}], {('a',): {'/'}})[0], 'PASS'), ('원장 없는 키만', judge_team_val([{'key': ('z',), 'dept': 'D'}], {})[0], 'ERROR'), ('덤프 없음', judge_team_val([], {})[0], 'ERROR'), ('-- 주석 안 TB_FX', judge_tbfx(strip_comments('select 1 -- TB_FX_USER\nfrom dual'))[0], 'PASS'), ('블록 주석 안 TB_FX', judge_tbfx(strip_comments('/* TB_FX_USER */ select 1 from dual'))[0], 'PASS'), ('실제 TB_FX', judge_tbfx(strip_comments('select 1 from TB_FX_USER -- x'))[0], 'FAIL'), ('문자열 안 -- 보존', judge_tbfx(strip_comments("select '--' a from TB_FX_USER"))[0], 'FAIL'), ('Team 경유', judge_team_src('P', 'select su.dept_id\nfrom scm_mst_sso_user_info su\nwhere su.user_id = a.owner')[0], 'ERROR'), ('Owner 이름 조인', judge_team_src('P', 'select f.dept_id, j.user_nm from scm_mst_site_item f\nleft join scm_mst_sso_user_info j\non j.user_id = f.owner')[0], 'PASS'), ('Team 정상', judge_team_src('P', 'select a.dept_id from scm_mst_site_item a')[0], 'PASS'), ('Team 대상 아님', judge_team_src('P', 'select 1 from dual')[0], 'NA'), ('SSO 만 참조·OWNER 없음', judge_team_src('P', 'select a.dept_id from scm_mst_site_item a, scm_mst_sso_user_info s')[0], 'PASS'), ('라벨 같음', judge_amp('C', 'A & B', 'A & B')[0], 'PASS'), ('& 뒤 잘림', judge_amp('C', 'Spec & Version', 'Spec')[0], 'FAIL'), ('& 사라짐', judge_amp('C', 'S&OP', 'SOP Report')[0], 'ERROR'), ('& 유지 다른 문구', judge_amp('C', 'A & B', 'A & C')[0], 'PASS'), ('TB_FX 참조', judge_tbfx('select * from TB_FX_MenuItemInfo')[0], 'FAIL'), ('참조 없음', judge_tbfx('select 1 from dual')[0], 'PASS'), ('콤보 직접', judge_team_combo('T', 'select from SCM_MST_SITE_ITEM', {})[0], 'PASS'), ('콤보 PROC 경유', judge_team_combo('T', 'call PR_X', {'PR_X': 'FROM SCM_MST_SITE_ITEM'})[0], 'PASS'), ('콤보 다른 원천', judge_team_combo('T', 'select from SSO', {})[0], 'ERROR'), ('콤보 SQL 없음', judge_team_combo('T', '', {})[0], 'ERROR'), ('소스 있음', judge_source('A B', 'present', 'A', 'd')[0], 'PASS'), ('소스 없음', judge_source('B', 'present', 'A', 'd')[0], 'FAIL'), ('금지 남음', judge_source('A', 'absent', 'A', 'd')[0], 'FAIL'), ('금지 없음', judge_source('B', 'absent', 'A', 'd')[0], 'PASS'), ('본문 없음', judge_source('', 'present', 'A', 'd')[0], 'ERROR'), ('JSON 짧음', len(json_short_hits("V := JSON_OBJECT('A' VALUE 1);")), 1), ('JSON CLOB', len(json_short_hits("V := JSON_OBJECT('A' VALUE 1 RETURNING CLOB);")), 0), ('단건 무처리', len(select_into_hits("BEGIN SELECT A INTO V FROM T WHERE K=1; END;")), 1), ('집계 제외', len(select_into_hits("SELECT COUNT(*) INTO V FROM T;")), 0), ('DUAL 제외', len(select_into_hits("SELECT 1 INTO V FROM DUAL;")), 0), ('처리 있음', len(select_into_hits("BEGIN SELECT A INTO V FROM T; EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;")), 0), ('빈 값 비교', judge_empty_eq('P', empty_eq_hits("WHERE A.X = ''"))[0], 'ERROR'), ('부등 비교', judge_empty_eq('P', empty_eq_hits("WHERE A.X <> ''"))[0], 'ERROR'), ('대입 제외', judge_empty_eq('P', empty_eq_hits("V := '';"))[0], 'PASS'), ('NVL 판정 제외', judge_empty_eq('P', empty_eq_hits("WHERE NVL(A.X,'/') = '/'"))[0], 'PASS'), ('여러 줄 동적 SQL 값 제외', judge_empty_eq('P', empty_eq_hits("  AND E.LOOKUP_TYPE = ''X'' ")) [0], 'PASS'), ('문장 끝 비교', judge_empty_eq('P', empty_eq_hits("IF V = '' THEN"))[0], 'ERROR'), ('동적 SQL 제외', judge_empty_eq('P', empty_eq_hits("V := 'WHERE A = '' X ''';"))[0], 'PASS'), ('양변 쌍 추출', null_join_pairs("ON ISNULL(A.X,'')=ISNULL(B.X,'')"), [('X','X')]), ('NVL 없이 비교', judge_null_join('P', [('X','X')], 'WHERE A.X = B.X')[0], 'ERROR'), ('NVL 로 비교', judge_null_join('P', [('X','X')], "WHERE NVL(A.X,'/') = NVL(B.X,'/')")[0], 'PASS'), ('AS-IS 결합 없음', judge_null_join('P', [], 'A.X = B.X')[0], 'NA'), ('실존', judge_attr9('Aa', m)[0], 'PASS'), ('미사용', judge_attr9('Bb', m)[0], 'FAIL'), ('없음', judge_attr9('Zz', m)[0], 'FAIL'), ('대소문자', judge_attr9('aa', m)[0], 'ERROR')]
    bad = 0
    for n, got, want in cases:
        k = got == want
        bad += 0 if k else 1
        print(f"{'OK ' if k else 'NG '} {n} → {got}(기대 {want})")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def main(mid):
    from sort_check import proc_body
    from dbconn import connect
    pm = [r for r in csv.DictReader(open(os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'proc_meta.csv'), encoding='utf-8-sig', newline='')) if (r.get('menu_id') or '').upper() == mid and '.' in (r.get('proc') or '')]
    pkgs = sorted({r['proc'].split('.')[0].upper() for r in pm})
    res = []
    with connect('tobe') as cx:
        cur = cx.cursor()
        for pkg in pkgs:
            cur.execute("SELECT OWNER FROM ALL_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=pkg)
            m = cur.fetchone()
            if not m:
                res.append({'kind': 'TB_FX', 'target': pkg, 'result': 'ERROR', 'why': '[측정 경로 없음] 패키지 본문 없음'})
                continue
            cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", o=m[0], n=pkg)
            _body = strip_comments(''.join(x[0] for x in cur.fetchall()))
            r, why = judge_tbfx(_body)
            res.append({'kind': 'TB_FX', 'target': pkg, 'result': r, 'why': why})
            _h = sentinel_inserts(_body)
            if _h:
                _ts = sorted({x[0] for x in _h}); _nl = {}
                cur.execute("SELECT TABLE_NAME, COLUMN_NAME, NULLABLE FROM ALL_TAB_COLUMNS WHERE TABLE_NAME IN (" + ','.join(f':t{i}' for i in range(len(_ts))) + ')', {f't{i}': v for i, v in enumerate(_ts)})
                for a0, b0, c0 in cur.fetchall():
                    _nl[(a0, b0)] = c0
                r, why = judge_null_rule(_h, _nl)
                res.append({'kind': 'NULL_RULE', 'target': pkg, 'result': r, 'why': why})
            _j = json_short_hits(_body)
            res.append({'kind': 'JSON_SHORT', 'target': pkg, 'result': 'ERROR' if _j else 'PASS', 'why': f'[확인 대상] {pkg} RETURNING CLOB 없는 JSON 생성 {len(_j)}곳(본문 줄 {_j[:6]}) — 대량이면 ORA-40478' if _j else f'{pkg} JSON 생성 전부 CLOB 또는 없음'})
            _s = select_into_hits(_body)
            res.append({'kind': 'SELECT_INTO', 'target': pkg, 'result': 'ERROR' if _s else 'PASS', 'why': f"[확인 대상] {pkg} 빈 결과 처리 없는 단건 SELECT INTO {len(_s)}곳: {', '.join(f'줄{a}:{b}' for a, b in _s[:6])} — 기준 데이터 없으면 ORA-01403" if _s else f'{pkg} 단건 SELECT INTO 전부 처리됨'})
            r, why = judge_empty_eq(pkg, empty_eq_hits(_body))
            res.append({'kind': 'EMPTY_EQ', 'target': pkg, 'result': r, 'why': why})
            r, why = judge_like_null(pkg, like_null_hits(_body))
            res.append({'kind': 'LIKE_NULL', 'target': pkg, 'result': r, 'why': why})
            r, why = judge_team_src(pkg, _body)
            if r != 'NA':
                res.append({'kind': 'TEAM_SRC', 'target': pkg, 'result': r, 'why': why})
        cur.execute('SELECT SQL_ID, USE_YN FROM SCM_ADM_CMBO_SQL_M')
        master = {}
        for s, u in cur.fetchall():
            master[str(s)] = 'Y' if u == 'Y' or master.get(str(s)) == 'Y' else str(u)
        cur.execute("SELECT DISTINCT TRIM(ATTRIBUTE9) FROM SCM_MST_SHEET_COLUMNS WHERE UPPER(PROGRAM_ID) = :1 AND TRIM(ATTRIBUTE9) IS NOT NULL", [mid])
        for (a9,) in cur.fetchall():
            r, why = judge_attr9(a9, master)
            res.append({'kind': 'ATTR9', 'target': a9, 'result': r, 'why': why})
    # EG328 — AS-IS 라벨에 & 있는 칸 (라벨 3종 · 없는 칸은 대상 아님)
    try:
        with connect('asis') as cx:
            c2 = cx.cursor()
            c2.execute("SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME FROM dbo.SCM_MST_SHEET_COLUMNS WITH (NOLOCK) WHERE PROGRAM_ID=? AND (COLUMN_LABEL_NAME LIKE '%&%' OR SMALL_CLASS_LABEL_NAME LIKE '%&%' OR LARGE_CLASS_LABEL_NAME LIKE '%&%')", mid)
            amp = [tuple(x) for x in c2.fetchall()]
        if amp:
            with connect('tobe') as cx:
                cur = cx.cursor()
                cur.execute('SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID=:p', p=mid)
                tb = {str(x[0]).upper(): x for x in cur.fetchall()}
            done = set()
            for x in amp:
                t = tb.get(str(x[0]).upper())
                if not t:
                    continue
                for i, nm in ((1, '라벨'), (2, '소분류'), (3, '대분류')):
                    if '&' in str(x[i] or '') and (x[0], i) not in done:
                        done.add((x[0], i))
                        r, why = judge_amp(f'{x[0]} {nm}', x[i], t[i])
                        res.append({'kind': 'LABEL_AMP', 'target': f'{x[0]}.{nm}', 'result': r, 'why': why})
    except Exception as e:
        res.append({'kind': 'LABEL_AMP', 'target': mid, 'result': 'ERROR', 'why': f'[측정 경로 없음] AS-IS 라벨 조회 실패: {str(e)[:140]}'})
    # EG080 — 이 화면이 부른 Team 콤보의 원천
    try:
        import json as _j
        _rt = os.path.join(ROOT, 'Doc', 'verify', mid, 'combo_runtime.json')
        ids = set()
        if os.path.exists(_rt):
            for x in _j.load(open(_rt, encoding='utf-8-sig')).get('combos') or []:
                try:
                    v = _j.loads(x.get('body') or '{}').get('comboId')
                except ValueError:
                    v = None
                if v and re.search('team', v, re.I):
                    ids.add(v)
        if ids:
            with connect('tobe') as cx:
                cur = cx.cursor()
                for cid in sorted(ids):
                    cur.execute('SELECT SQL_DTL_CTN FROM SCM_ADM_CMBO_SQL_M WHERE SQL_ID=:i', i=cid); y = cur.fetchone()
                    sql = str(y[0].read() if y and hasattr(y[0], 'read') else (y[0] if y else '') or '')
                    procs = {}
                    for nm in sorted(set(re.findall(r'\b((?:PR_|PKG_|FN_)\w+)', sql, re.I)))[:4]:
                        cur.execute('SELECT TEXT FROM ALL_SOURCE WHERE NAME=:n ORDER BY TYPE, LINE', n=nm.upper())
                        procs[nm] = strip_comments(''.join(z[0] for z in cur.fetchall()))
                    r, why = judge_team_combo(cid, sql, procs)
                    res.append({'kind': 'TEAM_SRC', 'target': cid, 'result': r, 'why': why})
    except Exception as e:
        res.append({'kind': 'TEAM_SRC', 'target': mid, 'result': 'ERROR', 'why': f'[측정 경로 없음] {str(e)[:140]}'})
    # EG167·EG157 — 문서가 소스 내용을 정한 항목
    try:
        with open(os.path.join(ROOT, 'Doc', 'verify', 'source_expect.csv'), encoding='utf-8-sig', newline='') as f:
            se = [x for x in csv.DictReader(f) if x['menu_id'] == mid]
        if se:
            with connect('tobe') as cx:
                cur = cx.cursor()
                for x in se:
                    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=x['pkg'])
                    r, why = judge_source(strip_comments(''.join(y[0] for y in cur.fetchall())), x['mode'], x['regex'], x['desc'])
                    res.append({'kind': 'SRC_' + x['rule'], 'target': x['desc'], 'result': r, 'why': f"{why} · 문서 {x['source']}"})
    except Exception as e:
        res.append({'kind': 'SRC_F4', 'target': mid, 'result': 'ERROR', 'why': f'[측정 경로 없음] {str(e)[:140]}'})
    # EG005 — AS-IS 조회 SP 의 양변 ISNULL 결합을 TO-BE 패키지가 NVL 없이 잇는지
    try:
        gc = [r for r in csv.DictReader(open(os.path.join(ROOT, 'Doc', 'golden', 'golden_cases.csv'), encoding='utf-8-sig', newline='')) if r.get('screen') == mid and r.get('kind') == 'GET' and '.' in (r.get('tobe_proc') or '')]
        by_pkg = {}
        with connect('asis') as acx:
            ac = acx.cursor()
            for g in gc:
                ac.execute(f"SELECT OBJECT_DEFINITION(OBJECT_ID('dbo.{g['asis_sp']}'))")
                x = ac.fetchone()
                by_pkg.setdefault(g['tobe_proc'].split('.')[0].upper(), set()).update(null_join_pairs(strip_comments((x[0] if x else '') or '')))
        with connect('tobe') as cx:
            cur = cx.cursor()
            for pkg, prs in sorted(by_pkg.items()):
                cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=pkg)
                r, why = judge_null_join(pkg, sorted(prs), strip_comments(''.join(y[0] for y in cur.fetchall())))
                if r != 'NA':
                    res.append({'kind': 'NULL_JOIN', 'target': pkg, 'result': r, 'why': why})
    except Exception as e:
        res.append({'kind': 'NULL_JOIN', 'target': mid, 'result': 'ERROR', 'why': f'[측정 경로 없음] {str(e)[:140]}'})
    # EG076·EG038·EG077 — E2E 덤프(team_cells.json)가 있으면 행 단위 값 대조
    _tc = os.path.join(ROOT, 'Doc', 'verify', mid, 'team_cells.json')
    if os.path.exists(_tc):
        import json
        with open(_tc, encoding='utf-8') as f:
            cells = json.load(f)
        rows_t = [{'key': (str(x.get('SCM_SITE_ID') or ''), str(x.get('ITEM_ID') or '')), 'dept': str(x.get('DEPT_ID') or '')} for x in cells if x.get('ITEM_ID')]
        master_t = {}
        with connect('tobe') as cx:
            cur = cx.cursor()
            keys = sorted({r['key'] for r in rows_t})
            for i in range(0, len(keys), 300):
                ch = keys[i:i + 300]
                cur.execute('SELECT SCM_SITE_ID, ITEM_ID, DEPT_ID FROM SCM_MST_SITE_ITEM WHERE (SCM_SITE_ID, ITEM_ID) IN (' + ','.join(f'(:s{j},:i{j})' for j in range(len(ch))) + ')', {**{f's{j}': k[0] for j, k in enumerate(ch)}, **{f'i{j}': k[1] for j, k in enumerate(ch)}})
                for a0, b0, c0 in cur.fetchall():
                    master_t.setdefault((str(a0), str(b0)), set()).add(str(c0 or ''))
        r, why = judge_team_val(rows_t, master_t)
        res.append({'kind': 'TEAM_VAL', 'target': mid, 'result': r, 'why': why})
        r, why = judge_team_name([{'dept': str(x.get('DEPT_ID') or ''), **({'name': x.get('TEAM_NAME')} if 'TEAM_NAME' in x else {})} for x in cells])
        if r != 'NA':
            res.append({'kind': 'TEAM_VAL', 'target': f'{mid}.팀명', 'result': r, 'why': why})
    with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'db_ref.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(res)
    print(f'[db_ref] {mid}: ' + ' / '.join(f"{x['kind']} {x['target']} {x['result']}" + ('' if x['result'] == 'PASS' else f" {x['why'][:110]}") for x in res))
    return 0


if __name__ == '__main__':
    sys.exit(selftest() if sys.argv[1] == '--selftest' else main(sys.argv[1].upper()))
