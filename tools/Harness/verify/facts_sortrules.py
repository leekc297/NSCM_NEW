# -*- coding: utf-8 -*-
"""AS-IS 결과 정렬 사실 추출 — SQL(SP ORDER BY) 인지 그리드/코드 정렬인지 (2026-10-26 사용자 지시: "AS-IS 에서 정렬을 어떻게 수행하는지 확인해서 동일하게 SORT 적용")

  python tools/Harness/verify/facts_sortrules.py <AS-IS ID>        → Doc/asisfacts/screens/<ID>/sort_rules.csv
  python tools/Harness/verify/facts_sortrules.py --all             → Fact Pack 이 있는 전 화면

  원천
    ① 화면이 부르는 SP(Doc/asisfacts/screens/<ID>/endpoints.csv · actions.csv ENDPOINT) 의 AS-IS 원문 Doc/asisfacts/db/modules/dbo.<SP>.sql
       - 정적 ORDER BY · 동적 SQL(SET @qry = @qry + 'ORDER BY …') 모두. 동적 문장은 바로 위 IF/ELSE IF 가드(파라미터 분기)를 guard 로 적는다
       - 주석(-- · /* */) 안의 ORDER BY 는 제외(실제 실행 동작만 — 사용자 지시 2026-10: 운영 원문의 실제 실행 동작만)
       - 서브쿼리 안 ORDER BY(TOP n 용) 는 depth>0 로 표시 — 결과 순서 규칙이 아니다
    ② 화면 코드 정렬(.cs): FpSpread/SheetView .Sort(…)·SortRange·AutoSortColumn·DataView.Sort = "…"·LINQ OrderBy → kind=GRID/CODE
  산출 열: screen_id,kind(SQL|GRID|CODE),sp,file,line,guard,keys,raw,depth,note
    keys = 정렬 키 목록(콤마) — 'T.FROM_YYYYMMDD' 같은 접두는 떼고 대문자. DESC 는 키 뒤에 ' DESC'
  사용처: ledger.py A6 행(조회 SP 마다 1행, 분기별 기대) · sort_check.py(TO-BE PKG ORDER BY 정적 대조) · _trace.spec @trace A6(결과 행 순서 실측)
"""
import csv, os, re, sys, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); from asis_live import dead_methods, dead_sps, sp_base  # noqa: E402
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
DOC = os.path.join(ROOT, 'Doc')
SCR = os.path.join(DOC, 'asisfacts', 'screens')
MOD = os.path.join(DOC, 'asisfacts', 'db', 'modules')
csv.field_size_limit(10 ** 8)
rdcsv = lambda p: list(csv.DictReader(open(p, encoding='utf-8-sig'))) if os.path.exists(p) else []
COLS = ['screen_id', 'kind', 'sp', 'file', 'line', 'guard', 'keys', 'raw', 'depth', 'note']


def strip_comments(sql):
    """주석 제거(위치 보존 — 줄 번호 유지). 문자열 리터럴 안의 -- 는 주석이 아니다"""
    out = []; i = 0; n = len(sql); in_str = False
    while i < n:
        c = sql[i]
        if in_str:
            out.append(c)
            if c == "'": in_str = False
            i += 1; continue
        if c == "'": in_str = True; out.append(c); i += 1; continue
        if sql.startswith('--', i):
            j = sql.find('\n', i); j = n if j < 0 else j
            out.append(' ' * (j - i)); i = j; continue
        if sql.startswith('/*', i):
            j = sql.find('*/', i); j = n if j < 0 else j + 2
            out.append(''.join('\n' if ch == '\n' else ' ' for ch in sql[i:j])); i = j; continue
        out.append(c); i += 1
    return ''.join(out)


def norm_keys(txt):
    txt = re.sub(r"['\+]|char\(10\)|char\(13\)", ' ', txt)
    keys = []
    for k in txt.split(','):
        k = k.strip()
        if not k: continue
        m = re.match(r'^([\w.\[\]]+)(?:\s+(ASC|DESC))?', k, re.I)
        if not m: break
        name = m.group(1).split('.')[-1].strip('[]').upper()
        if not re.fullmatch(r'[A-Z_][A-Z0-9_]*', name): break
        keys.append(name + (' DESC' if (m.group(2) or '').upper() == 'DESC' else ''))
    return keys


def sp_rules(sp, screen):
    p = os.path.join(MOD, f'dbo.{sp}.sql')
    if not os.path.exists(p): return [{'screen_id': screen, 'kind': 'SQL', 'sp': sp, 'file': '', 'line': '', 'guard': '', 'keys': '', 'raw': '', 'depth': '', 'note': 'AS-IS SP 원문 없음(Doc/asisfacts/db/modules)'}]
    raw = open(p, encoding='utf-8', errors='ignore').read()
    txt = strip_comments(raw); lines = txt.split('\n'); out = []
    for ln, line in enumerate(lines, 1):
        for m in re.finditer(r'(?i)ORDER\s+BY\s+(.+)', line):
            tail = m.group(1)
            # 동적 문자열: 'ORDER BY a, b ' + char(10) → 따옴표 전까지
            if "'" in tail: tail = tail.split("'")[0]
            tail = re.split(r'(?i)\)\s*(?:T|AS\s+\w+)?\s*$|\bFOR\s+XML|\bOFFSET\b|\bOPTION\b|;', tail)[0]
            keys = norm_keys(tail)
            # 깊이: 이 줄까지의 괄호 균형(서브쿼리 안이면 >0)
            before = '\n'.join(lines[:ln - 1]) + line[:m.start()]
            depth = max(0, before.count('(') - before.count(')'))
            # 가드: 동적 SQL 이면 바로 위 비어있지 않은 줄들 중 IF/ELSE IF/BEGIN 를 거슬러 올라가며 수집(최대 6줄)
            guard = []
            dyn = bool(re.search(r'(?i)@\w+\s*=\s*@\w+\s*\+', line)) or "'" in line
            if dyn:
                # 가드 = 이 문장을 감싸는 IF/ELSE IF/ELSE 만 — 들여쓰기가 더 얕은 IF 중 ① 다음 비공백 줄이 BEGIN(블록) 이거나 ② 다음 비공백 줄이 바로 이 문장(단문 본문)인 것.
                #   형제 IF(단문 본문이 다른 SET 문)는 가드가 아니다(2026-10-26 1차: incoterms_ssp·trans_mode IF 가 ORDER BY 가드로 잡힘)
                ind = lambda t: len(t.expandtabs(4)) - len(t.expandtabs(4).lstrip())
                cur = ind(lines[ln - 1]); k = ln - 2
                while k >= 0 and len(guard) < 4:
                    s = lines[k].strip()
                    if s and ind(lines[k]) < cur and re.match(r'(?i)^(ELSE\s+IF|IF|ELSE)\b', s):
                        nxt_i = next((q for q in range(k + 1, ln) if lines[q].strip()), ln - 1)
                        if re.match(r'(?i)^\s*BEGIN\b', lines[nxt_i]) or nxt_i == ln - 1:
                            guard.insert(0, s[:160]); cur = ind(lines[k])
                    if s and ind(lines[k]) == 0 and not re.match(r'(?i)^(ELSE\s+IF|IF|ELSE|BEGIN|END)\b', s) and guard: break
                    k -= 1
            out.append({'screen_id': screen, 'kind': 'SQL', 'sp': sp, 'file': os.path.relpath(p, ROOT), 'line': ln, 'guard': ' ▸ '.join(guard), 'keys': ','.join(keys), 'raw': line.strip()[:240], 'depth': depth,
                        'note': ('동적 SQL' if dyn else '정적') + ('' if depth == 0 else ' · 서브쿼리 안(TOP 용) — 결과 순서 규칙 아님') + ('' if keys else ' · 키 해석 실패(사람 확인)')})
    if not out: out.append({'screen_id': screen, 'kind': 'SQL', 'sp': sp, 'file': os.path.relpath(p, ROOT), 'line': '', 'guard': '', 'keys': '', 'raw': '', 'depth': 0, 'note': 'ORDER BY 없음 — 결과 순서 미정(테이블 순)'})
    return out


RX_CODE = re.compile(r'(?:\.Sort\s*\(|SortRange\s*\(|AutoSortColumn|AllowAutoSort|\.Sort\s*=\s*"|\.OrderBy(?:Descending)?\s*\(|ORDER BY)', re.I)


def code_rules(screen):
    out = []
    for f in rdcsv(os.path.join(SCR, screen, 'files.csv')):
        rel = f.get('file', '')
        if not rel.endswith('.cs') or rel.endswith('.Designer.cs'): continue
        p = next((q for q in (os.path.join(ROOT, 'GSCM', rel), os.path.join(ROOT, 'GSCM_20260512', rel)) if os.path.exists(q)), '')
        if not p: continue
        src = strip_comments(open(p, encoding='utf-8', errors='ignore').read())
        for ln, line in enumerate(src.split('\n'), 1):
            if RX_CODE.search(line):
                out.append({'screen_id': screen, 'kind': 'GRID' if re.search(r'(?i)spd|sheet|SortRange|AutoSort', line) else 'CODE', 'sp': '', 'file': rel, 'line': ln, 'guard': '', 'keys': ','.join(norm_keys((re.search(r'"([^"]+)"', line) or [None, ''])[1])), 'raw': line.strip()[:240], 'depth': 0, 'note': '화면 코드 정렬'})
    return out


def run(screen):
    sd = os.path.join(SCR, screen)
    if not os.path.isdir(sd): print(f'[SKIP] {screen} Fact Pack 없음'); return None
    sps = []
    for r in rdcsv(os.path.join(sd, 'endpoints.csv')):
        n = (r.get('sp') or r.get('endpoint') or r.get('name') or '').split('.')[-1].strip().strip('"')
        if n: sps.append(n)
    dead = dead_methods(screen)
    for r in rdcsv(os.path.join(sd, 'actions.csv')):
        if r.get('kind') == 'ENDPOINT' and r.get('endpoint') and (r['class'], r['method']) not in dead: sps.append(r['endpoint'].split('.')[-1])
    dsp = dead_sps(screen)  # 호출이 전부 실행되지 않는 메서드 안에만 있는 SP — endpoints.csv 에 있어도 정렬 규칙 원천 아님(2026-10-30 asis_live)
    sps = [s for s in dict.fromkeys(sps) if re.fullmatch(r'[A-Za-z0-9_]+', s) and sp_base(s) not in dsp]
    rows = []
    for sp in sps: rows += sp_rules(sp, screen)
    rows += code_rules(screen)
    with open(os.path.join(sd, 'sort_rules.csv'), 'w', encoding='utf-8-sig', newline='') as fp:
        w = csv.DictWriter(fp, fieldnames=COLS); w.writeheader(); [w.writerow({k: r.get(k, '') for k in COLS}) for r in rows]
    c = collections.Counter(r['kind'] for r in rows if r.get('keys'))
    print(f"{screen}: SP {len(sps)} → 정렬 규칙 {sum(c.values())} (SQL {c.get('SQL', 0)} · GRID {c.get('GRID', 0)} · CODE {c.get('CODE', 0)}) · ORDER BY 없는 SP {sum(1 for r in rows if r['kind'] == 'SQL' and not r['keys'] and 'ORDER BY 없음' in r['note'])} → Doc/asisfacts/screens/{screen}/sort_rules.csv")
    return rows


if __name__ == '__main__':
    a = sys.argv[1:]
    if not a: print(__doc__); sys.exit(2)
    if a[0] == '--all':
        for s in sorted(os.listdir(SCR)):
            if os.path.isdir(os.path.join(SCR, s)) and not s.startswith('_'): run(s)
    else: run(a[0].upper())
