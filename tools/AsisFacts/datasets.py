# -*- coding: utf-8 -*-
"""2b — 액션 데이터셋 (사용자 지시·승인 2026-10-23: 액션의 DB 연결을 실제로 실행해 결과 데이터셋까지 — 전체 화면 · 결과셋마다 최대 1,000행
   진행 순서(사용자 승인): ① --dry 로 실행 계획만(DB 접속 없음) 검토 → ② 실제 실행)

입력: screens/<ID>/action_links.csv(2a) · db/ + _fpdb/db/(모듈 참조·파라미터·원문) · foxquery_sql/ · foxquery_params.csv
      db/meta/dbo.TB_FX_SearchCondition.csv(사용자가 저장한 조회조건) · db/meta/dbo.SCM_ADM_DQ_LIST/PARAMETER.csv(저장 쿼리)
실행 단위
  SP     액션 체인에서 엔드포인트가 직접 실행하는 SP(하위 SP 는 그 실행 안에서 함께 돈다)
  SQL    FoxQuery 인라인 SQL(@변수 바인딩)
  DQ     테이블에 저장된 쿼리(SCM_ADM_DQ_LIST.DQ_TEXT) — STORED_QUERY 가 연결된 화면
파라미터 값(우선순위, 행마다 출처 기록)
  ① 코드 리터럴(액션 PARAM·BIZ code) ② 컨트롤 값 → 그 화면에 사용자가 저장한 조회조건(ADMIN 그룹 최빈값 우선)
  ③ 사업부 → 40·81·82 각각 실행(값이 ①②로 정해지지 않을 때) ④ 사용자·그룹 → 그 화면에 조회조건을 저장한 실제 AS-IS 사용자(ADMIN 우선)
  ⑤ 날짜·기간 → 실행일 기준(일=오늘, 주=ISO 주, 월=이번 달, From=월초, To=월말) ⑥ SP 기본값 있으면 생략 → 이름이 맞는 저장 조회조건 → 빈값
안전(기존 DbGrid 규칙 확장)
  · EXEC 전이 closure 에 영구 테이블 쓰기·COMMIT·암호화·원문 없는 모듈·시스템 SP(sp_executesql 제외) → 실행 안 함(UNSAFE)
  · 동적 SQL 은 문자열 리터럴에 쓰기/DDL/EXEC 키워드(임시 #테이블 대상 제외)가 없을 때만
  · 모든 실행 = 트랜잭션 + 항상 ROLLBACK · LOCK_TIMEOUT 10초 · 쿼리 제한 60초 · 동시 연결 4 · 실행 뒤 트랜잭션 로그 기록 수(>0 = WROTE_ROLLED_BACK 표시)
출력: datasets/runs.csv(실행 1건 1행) · datasets/<DB>/<SP 또는 키>/<run_id>_rs<n>.csv(결과셋마다 최대 1,000행) · screens/<ID>/action_data.csv(액션 → 실행)
      --dry 는 datasets/plan.csv 만(실행 계획 · UNSAFE 사유 · 파라미터 값과 출처)
사용: python datasets.py [화면ID ...] [--workers 4] [--dry]
"""
import csv, os, re, sys, json, hashlib, time, datetime, collections, threading, queue

csv.field_size_limit(10 ** 9)
ROOT = r'C:\Projects\NSCM'
OUT = os.path.join(ROOT, r'Doc\asisfacts')
DS = os.path.join(OUT, 'datasets')
DBS = (('LGCE_SCMDEV', 'db'), ('LGCE_FPDEV_TR', '_fpdb/db'))
MAXROWS = 1000          # 결과셋마다 저장 상한(사용자 지시: 액션당 최대 1,000행)
COUNTCAP = 100000       # 전체 행 수 집계 상한
QTIMEOUT = 60
args = sys.argv[1:]
DRY = '--dry' in args
WORKERS = int(args[args.index('--workers') + 1]) if '--workers' in args else 4
IDS = [a.upper() for i, a in enumerate(args) if not a.startswith('--') and not (i > 0 and args[i - 1] == '--workers')]
R = lambda p: csv.DictReader(open(os.path.join(OUT, p), encoding='utf-8-sig'))
norm = lambda s: re.sub(r'^\[?dbo\]?\.', '', (s or '').strip(), flags=re.I).strip('[]').upper()
TODAY = datetime.date.today()


# ── T-SQL 렉서(주석 제거·문자열 리터럴 분리 — 주석/문자열 판정을 정규식으로 하지 않는다)
def lex(text):
    i, n = 0, len(text); toks = []
    while i < n:
        c = text[i]
        if text.startswith('--', i):
            j = text.find('\n', i); i = n if j < 0 else j
        elif text.startswith('/*', i):
            d = 1; i += 2
            while i < n and d:
                if text.startswith('/*', i): d += 1; i += 2
                elif text.startswith('*/', i): d -= 1; i += 2
                else: i += 1
        elif c == "'" or (c in 'Nn' and i + 1 < n and text[i + 1] == "'" and (i == 0 or not (text[i - 1].isalnum() or text[i - 1] == '_'))):
            i += 1 if c == "'" else 2; s = []
            while i < n:
                if text[i] == "'" and i + 1 < n and text[i + 1] == "'": s.append("'"); i += 2
                elif text[i] == "'": i += 1; break
                else: s.append(text[i]); i += 1
            toks.append(('str', ''.join(s)))
        elif c == '[':
            j = text.find(']', i); toks.append(('word', text[i + 1:j if j > 0 else n])); i = (j + 1) if j > 0 else n
        elif c.isalnum() or c in '_@#$':
            j = i
            while j < n and (text[j].isalnum() or text[j] in '_@#$'): j += 1
            toks.append(('word', text[i:j])); i = j
        elif c.isspace(): i += 1
        else: toks.append(('sym', c)); i += 1
    return toks


WRITE_DYN = re.compile(r'\b(INSERT\s+(?:INTO\s+)?(?!#|@)[\w\[]|UPDATE\s+(?!#|@)[\w\[]|DELETE\s+(?:FROM\s+)?(?!#|@)[\w\[]|MERGE\s|TRUNCATE\s|DROP\s+(?!TABLE\s+#)|ALTER\s|CREATE\s+(?!TABLE\s+#)|COMMIT|EXEC\s|EXECUTE\s|SP_EXECUTESQL)', re.I)
WRITE_WORDS = ('INSERT', 'UPDATE', 'DELETE', 'MERGE', 'TRUNCATE', 'DROP', 'ALTER', 'COMMIT', 'EXEC', 'EXECUTE', 'CREATE')


def body_writes(txt):
    """인라인 SQL·저장 쿼리 본문: 쓰기/DDL/EXEC 가 있으면 사유, 없으면 '' (임시 #테이블·@테이블변수 대상은 허용)"""
    toks = [t for t in lex(txt) if t[0] == 'word']
    for i, (_, w) in enumerate(toks):
        u = w.upper()
        if u not in WRITE_WORDS: continue
        nxt = [t[1] for t in toks[i + 1:i + 4]]
        tgt = next((x for x in nxt if x.upper() not in ('INTO', 'FROM', 'TABLE', 'TOP')), '')
        if u in ('INSERT', 'UPDATE', 'DELETE') and tgt.startswith(('#', '@')): continue
        if u == 'CREATE' and nxt[:1] and nxt[0].upper() == 'TABLE' and len(nxt) > 1 and nxt[1].startswith('#'): continue
        if u == 'DROP' and nxt[:1] and nxt[0].upper() == 'TABLE' and len(nxt) > 1 and nxt[1].startswith('#'): continue
        if u == 'UPDATE' and i > 0 and toks[i - 1][1].upper() == 'FOR': continue  # FOR UPDATE 구문
        return f'{u} {" ".join(nxt)}'
    return ''


print('loading facts…', flush=True)
MOD = {}   # (db, NAME) → {'full','refs':[(kind,name,access)],'params':[...]}
for db, sub in DBS:
    base = os.path.join(OUT, sub)
    if not os.path.exists(os.path.join(base, 'db_module_refs.csv')): continue
    for r in csv.DictReader(open(os.path.join(base, 'db_module_refs.csv'), encoding='utf-8-sig')):
        m = MOD.setdefault((db, norm(r['module'])), {'full': r['module'], 'refs': [], 'params': []})
        m['refs'].append((r['ref_kind'], r['name'], r['access']))
    for r in csv.DictReader(open(os.path.join(base, 'db_params.csv'), encoding='utf-8-sig')):
        k = (db, norm(r['object_name']))
        if k in MOD and r['param_name']: MOD[k]['params'].append(r)
OWNER = {}
for (db, name) in MOD: OWNER.setdefault(name, db)  # 같은 이름이면 SCM 우선(DBS 순서)


def mod_text(db, name):
    sub = dict(DBS)[db]; m = MOD.get((db, name))
    if not m: return ''
    f = os.path.join(OUT, sub, 'modules', re.sub(r'[\\/:*?"<>|]', '_', m['full']) + '.sql')
    return open(f, encoding='utf-8-sig', errors='replace').read() if os.path.exists(f) else ''


def defaults(db, name):
    """SP 머리(AS 앞)의 '@p 타입 = 기본값' — sys.parameters.has_default_value 는 T-SQL SP 에서 항상 0 이라 원문에서 읽는다"""
    toks = lex(mod_text(db, name)); res = {}
    k = next((i for i, t in enumerate(toks) if t[0] == 'word' and t[1].upper() in ('PROCEDURE', 'PROC')), None)
    if k is None: return res
    i = k + 1
    while i < len(toks) and not (toks[i][0] == 'word' and toks[i][1].upper() == 'AS'):
        if toks[i][0] == 'word' and toks[i][1].startswith('@'):
            p = toks[i][1]; j = i + 1; depth = 0
            while j < len(toks) and not (toks[j] == ('sym', ',') and depth == 0) and not (toks[j][0] == 'word' and toks[j][1].upper() == 'AS' and depth == 0):
                if toks[j] == ('sym', '('): depth += 1
                if toks[j] == ('sym', ')'): depth -= 1
                if toks[j] == ('sym', '=') and depth == 0: res[p.upper()] = toks[j + 1][1] if j + 1 < len(toks) else ''
                j += 1
            i = j
            continue
        i += 1
    return res


SAFE = {}
def safety(db, name):
    key = (db, name)
    if key in SAFE: return SAFE[key]
    def done(v): SAFE[key] = v; return v
    seen = set(); q = [(db, name)]; dyn = False
    while q:
        d, m = q.pop()
        if (d, m) in seen: continue
        seen.add((d, m))
        if (d, m) not in MOD:
            if OWNER.get(m): d = OWNER[m]
            else: return done((False, f'원문 없는 모듈 호출: {m}'))
        mm = MOD[(d, m)]; mdyn = False
        for kind, nm, acc in mm['refs']:
            if kind == 'ENCRYPTED': return done((False, f'원문 없음(암호화): {m}'))
            if kind == 'TABLE' and acc.upper() in ('INSERT', 'UPDATE', 'DELETE', 'MERGE', 'CREATE', 'TRUNCATE') and not nm.startswith(('#', '@')):
                return done((False, f'영구 테이블 쓰기: {m} {acc} {nm}'))
            if kind == 'EXEC':
                nn = norm(nm)
                if nn == 'SP_EXECUTESQL': mdyn = True; continue
                if (nn.startswith('SP_') or nn.startswith('XP_')) and (d, nn) not in MOD and nn not in OWNER: return done((False, f'시스템 SP 호출: {nm}'))
                q.append((d, nn))
            if kind == 'DYNAMIC': mdyn = True
        toks = lex(mod_text(d, m))
        if any(t[0] == 'word' and t[1].upper() == 'COMMIT' for t in toks): return done((False, f'COMMIT 포함: {m}'))
        if mdyn or any(t[0] == 'word' and t[1].upper() == 'SP_EXECUTESQL' for t in toks) or any(t[0] == 'word' and t[1].upper() in ('EXEC', 'EXECUTE') and i + 1 < len(toks) and toks[i + 1] == ('sym', '(') for i, t in enumerate(toks)):
            dyn = True
            for t in toks:
                if t[0] == 'str' and WRITE_DYN.search(t[1]): return done((False, f'동적 SQL 문자열에 쓰기/DDL/EXEC: {m} — {t[1][:60]!r}'))
    return done((True, f'closure {len(seen)} 모듈 · 쓰기 없음' + (' · 동적 SQL(읽기 문자열만)' if dyn else '')))


# 저장 조회조건(사용자 값)
SC = collections.defaultdict(collections.Counter); SCUSER = collections.defaultdict(collections.Counter); ALLADMIN = collections.Counter()
for r in R('db/meta/dbo.TB_FX_SearchCondition.csv'):
    w = 3 if r['GroupID'] == 'ADMIN' else 1
    SC[(r['MenuID'].upper(), r['ControlName'])][r['ControlValue']] += w
    SCUSER[r['MenuID'].upper()][(r['UserID'], r['GroupID'])] += w
    if r['GroupID'] == 'ADMIN': ALLADMIN[(r['UserID'], 'ADMIN')] += 1
def saved(menu, ctrl):
    c = SC.get((menu, ctrl)); return c.most_common(1)[0][0] if c else None
def rep_user(menu):
    c = SCUSER.get(menu)
    if c:
        adm = [u for u, n in c.most_common() if u[1] == 'ADMIN']
        return adm[0] if adm else c.most_common(1)[0][0]
    return ALLADMIN.most_common(1)[0][0]


FQ = {r['key'].upper(): r for r in R('foxquery_endpoints.csv') if r['commented'] == '0'}
FQP = collections.defaultdict(list)
for r in R('foxquery_params.csv'):
    if r['commented'] == '0': FQP[r['key'].upper()].append(r)
FQR = collections.defaultdict(list)
for r in R('foxquery_sql_refs.csv'):
    if r['ref_kind'] != 'NONE': FQR[r['key'].upper()].append((r['ref_kind'], r['access']))
DQL = {r['DQ_ID']: r for r in R('db/meta/dbo.SCM_ADM_DQ_LIST.csv') if r.get('VALID_YN', 'Y') == 'Y'}
DQP = collections.defaultdict(list)
for r in R('db/meta/dbo.SCM_ADM_DQ_PARAMETER.csv'):
    if r['VALID_YN'] == 'Y': DQP[r['DQ_ID']].append(r['PARAMETER_ID'])
print(f'modules {len(MOD)} · 저장 조회조건 화면 {len(SCUSER)} · foxquery {len(FQ)} · DQ {len(DQL)}', flush=True)

CTRL = re.compile(r'\b((?:cbo|clb|txt|dt|dte|chk|rdo|usr|cal|num|lup|spn|cmb|lst|opt|date)\w*)\.(?:ControlValues|Text|EditValue|SelectedValue|Value|Checked|DateTime|SelectedText|StartDate|EndDate|FromDate|ToDate|InitValue)', re.I)
LIT = re.compile(r'^\s*@?"([^"]*)"\s*$|^\s*N?\'([^\']*)\'\s*$')
def iso_week(d): y, w, _ = d.isocalendar(); return f'{y}{w:02d}'
def month_end(d): return (d.replace(day=28) + datetime.timedelta(days=4)).replace(day=1) - datetime.timedelta(days=1)


def by_rule(pn, dtype, menu, user, group):
    n = pn.lstrip('@').lower(); n2 = re.sub(r'^(p|v|i)_', '', n)
    if any(x in n2 for x in ('user_id', 'userid', 'created_by', 'updated_by', 'login', 'emp_no')) or n2 in ('user', 'ses_user_id'): return user, '대표 사용자(저장 조회조건)'
    if ('group' in n2 and 'id' in n2) or n2 in ('groupid', 'group'): return group, '대표 사용자 그룹'
    if n2 in ('uicode', 'ui_code', 'program_id', 'programid', 'menu_id', 'menuid', 'screen_id'): return menu, '화면 ID'
    if 'timezone' in n2 or 'time_zone' in n2: return 'AS054', '기본 타임존(AS054)'
    if n2 in ('lang', 'language', 'lang_cd'): return 'KO', '언어 KO'
    if dtype in ('date', 'datetime', 'datetime2', 'smalldatetime'):
        if any(x in n2 for x in ('to', 'end')): return month_end(TODAY), '이번 달 말일'
        if any(x in n2 for x in ('from', 'start')): return TODAY.replace(day=1), '이번 달 1일'
        return TODAY, '오늘'
    if 'yyyyww' in n2 or n2.endswith('week'): return iso_week(TODAY), '이번 ISO 주'
    if ('yyyymm' in n2 and 'dd' not in n2) or n2.endswith('month') or n2.endswith('_ym'): return TODAY.strftime('%Y%m'), '이번 달'
    if any(x in n2 for x in ('date', 'ymd', '_dt', 'yyyymmdd', 'day')):
        if any(x in n2 for x in ('to', 'end')): return month_end(TODAY).strftime('%Y%m%d'), '이번 달 말일'
        if any(x in n2 for x in ('from', 'start')): return TODAY.replace(day=1).strftime('%Y%m%d'), '이번 달 1일'
        return TODAY.strftime('%Y%m%d'), '오늘'
    if n2.endswith('year') or n2 == 'yyyy': return TODAY.strftime('%Y'), '올해'
    return None, None


def resolve(pn, dtype, hints, menu, user, group, dflt):
    """→ (값 또는 None, 출처, 사업부 팬아웃 여부)"""
    n = pn.lstrip('@').lower(); n2 = re.sub(r'^(p|v|i)_', '', n)
    for hk, hv in hints.items():
        hk2 = hk.lstrip('@').lower()
        if hk2 in (n, n2) or re.sub(r'^(p|v|i)_', '', hk2) == n2:
            m = LIT.match(hv or '')
            if m: return (m.group(1) if m.group(1) is not None else m.group(2)), '코드 리터럴', False
            c = CTRL.search(hv or '')
            if c:
                v = saved(menu, c.group(1))
                if v is not None: return v, f'저장 조회조건 {c.group(1)}', False
            if 'division' in n2: return None, f'사업부 팬아웃(코드 식 {hv[:40]})', True
            v, src = by_rule(pn, dtype, menu, user, group)
            if v is not None: return v, f'{src}(코드 식 {hv[:40]})', False
            if pn.upper() in dflt: return None, f'SP 기본값(코드 식 {hv[:40]} 미해석)', False
            return '', f'코드 식 미해석({hv[:40]}) — 빈값', False
    if 'division' in n2: return None, '사업부 팬아웃', True
    v, src = by_rule(pn, dtype, menu, user, group)
    if v is not None: return v, src, False
    if pn.upper() in dflt: return None, f'SP 기본값({dflt[pn.upper()]})', False
    for (mn, ctrl), cnt in SC.items():
        if mn == menu and re.sub(r'^(cbo|clb|txt|dt|chk|rdo|usr|dte|cal)', '', ctrl, flags=re.I).lower() == n2.replace('_', ''):
            return cnt.most_common(1)[0][0], f'저장 조회조건 {ctrl}(이름 일치)', False
    return '', '매칭 없음 — 빈값', False


DIVS = ('40', '81', '82')
NV = {'data_type': 'nvarchar', 'max_length': '-1'}


def units_for(sid):
    p = os.path.join(OUT, 'screens', sid, 'action_links.csv')
    if not os.path.exists(p): return []
    rows = list(csv.DictReader(open(p, encoding='utf-8-sig')))
    groups = collections.OrderedDict()
    for r in rows: groups.setdefault((r['class'], r['method'], r['line'], r['action_kind'], r['action_target'], r['action_value']), []).append(r)
    out = []
    for ak, rs in groups.items():
        hints = {}
        for r in rs:
            if r['link_kind'] == 'PARAM':
                for kv in re.split(r',\s*(?=\w+=)', r['to']):
                    if '=' in kv: k, v = kv.split('=', 1); hints[k.strip()] = v.strip()
            if r['link_kind'] == 'ENDPOINT' and r['cond']:
                for kv in r['cond'].split(', '):
                    if '=' in kv:
                        k, v = kv.split('=', 1); v = v.strip()
                        hints.setdefault(k.strip(), v if v.startswith('"') else '"' + v + '"')
        for i, r in enumerate(rs):
            if r['link_kind'] == 'SP' and r['status'] == 'RESOLVED' and i > 0 and rs[i - 1]['link_kind'] == 'ENDPOINT':
                out.append((ak, 'SP', r['to'] or OWNER.get(norm(r['from']), 'LGCE_SCMDEV'), norm(r['from']), dict(hints)))
            elif r['link_kind'] == 'SQL':
                out.append((ak, 'SQL', 'LGCE_FPDEV_TR' if r['from'].upper().startswith(('FP\\', 'FP_')) else 'LGCE_SCMDEV', r['from'], dict(hints)))
            elif r['link_kind'] == 'STORED_QUERY':
                for dq in DQL: out.append((ak, 'DQ', 'LGCE_SCMDEV', dq, dict(hints)))
    return out


def fan(kind, db, name, base, fans, src, why, text=None):
    return [dict(kind=kind, db=db, name=name, status='PLAN', why=why, params=dict(base, **{f: (dv, p) for f, p in fans}), src=src, division=dv or '', text=text)
            for dv in (DIVS if fans else (None,))]


def plan(sid, unit):
    ak, kind, db, name, hints = unit
    user, group = rep_user(sid)
    if kind == 'SP':
        if (db, name) not in MOD: return [dict(kind=kind, db=db, name=name, status='UNRESOLVED', why='모듈 원문 없음', params={}, src={})]
        ok, why = safety(db, name)
        if not ok: return [dict(kind=kind, db=db, name=name, status='UNSAFE', why=why, params={}, src={})]
        dflt = defaults(db, name); base, src, fans = {}, {}, []
        for p in sorted(MOD[(db, name)]['params'], key=lambda x: int(x['parameter_id'] or 0)):
            pn = p['param_name']
            if p['is_output'] == '1': base[pn] = ('OUT', p); src[pn] = 'OUTPUT 변수'; continue
            v, s, f = resolve(pn, p['data_type'], hints, sid, user, group, dflt); src[pn] = s
            if f: fans.append((pn, p))
            elif v is not None or pn.upper() not in dflt: base[pn] = (v, p)
        return fan(kind, db, name, base, fans, src, why)
    if kind == 'SQL':
        refs = FQR.get(name.upper(), [])
        if any(k in ('EXEC', 'PROCEDURE') for k, a in refs) or any(a.upper() not in ('SELECT', '') for k, a in refs if k in ('TABLE', 'VIEW')):
            return [dict(kind=kind, db=db, name=name, status='UNSAFE', why='인라인 SQL 참조에 쓰기/EXEC', params={}, src={})]
        fq = FQ.get(name.upper()); tf = os.path.join(OUT, fq['text_file']) if fq else ''
        if not fq or not fq['text_file'] or not os.path.isfile(tf): return [dict(kind=kind, db=db, name=name, status='UNRESOLVED', why='SQL 본문 파일 없음', params={}, src={})]
        txt = open(tf, encoding='utf-8-sig', errors='replace').read(); w = body_writes(txt)
        if w: return [dict(kind=kind, db=db, name=name, status='UNSAFE', why=f'인라인 SQL 본문 쓰기/DDL/EXEC: {w}', params={}, src={})]
        base, src, fans = {}, {}, []
        for p in FQP.get(name.upper(), []):
            pn = '@' + p['name']
            if (p['db_type'] or '').lower() == 'command':
                # dbType=command = 값 바인딩이 아니라 본문의 그 자리를 조건절 텍스트로 치환(DataService.LtTool 등이 'AND A.X IN (…)' 생성) — 필터 없음 = 빈 텍스트
                txt = re.sub(re.escape(pn) + r'(?![\w@#$])', '', txt, flags=re.I); src[pn] = '명령형 치환 — 빈 조건(필터 없음)'; continue
            v, s, f = resolve(pn, (p['db_type'] or '').lower(), hints, sid, user, group, {}); src[pn] = s
            if f: fans.append((pn, NV))
            else: base[pn] = (v, NV)
        return fan(kind, db, name, base, fans, src, '인라인 SQL(SELECT)', txt)
    if kind == 'DQ':
        txt = DQL[name]['DQ_TEXT']; w = body_writes(txt)
        if w: return [dict(kind=kind, db=db, name=f'DQ{name}', status='UNSAFE', why=f'저장 쿼리 쓰기/DDL/EXEC: {w}', params={}, src={})]
        base, src, fans = {}, {}, []
        for pn in DQP.get(name, []):
            v, s, f = resolve(pn, 'nvarchar', hints, sid, user, group, {}); src[pn] = s
            if f: fans.append((pn, NV))
            else: base[pn] = (v, NV)
        return fan(kind, db, f'DQ{name}', base, fans, src, f"저장 쿼리 {DQL[name]['DQ_NAME'][:40]}", txt)
    return []


def pval(v):
    return None if v is None else ('OUTPUT' if v == 'OUT' else (v.isoformat() if hasattr(v, 'isoformat') else str(v)))
def run_id(r):
    h = json.dumps([r['db'], r['kind'], r['name'], sorted((k, str(pval(v[0]))) for k, v in r['params'].items())], ensure_ascii=False)
    return hashlib.sha1(h.encode('utf-8')).hexdigest()[:12]
def sqltype(p):
    t = (p.get('data_type') or 'nvarchar').lower(); ml = int(p.get('max_length') or -1)
    if t in ('nvarchar', 'nchar'): return f'{t}({"max" if ml < 0 else max(ml // 2, 1)})'
    if t in ('varchar', 'char', 'varbinary', 'binary'): return f'{t}({"max" if ml < 0 else max(ml, 1)})'
    if t in ('decimal', 'numeric'): return 'decimal(38,10)'
    return t


def env():
    kv = {}
    for line in open(os.path.join(ROOT, '.env.asis'), encoding='utf-8'):
        m = re.match(r'^\s*([A-Z_]+)\s*=\s*(.*)$', line)
        if m: kv[m.group(1)] = m.group(2).strip().strip('"')
    return kv


def connect(db):
    import pyodbc
    kv = env(); srv = kv['ASIS_DB_HOST'] + (',' + kv['ASIS_DB_PORT'] if kv.get('ASIS_DB_PORT') else '')
    c = pyodbc.connect(f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={srv};DATABASE={db};UID={kv['ASIS_DB_USER']};PWD={kv['ASIS_DB_PASS']};TrustServerCertificate=yes", autocommit=False, timeout=15)
    c.timeout = QTIMEOUT
    return c


def execute(conn, r, rid):
    cur = conn.cursor()
    cur.execute('SET LOCK_TIMEOUT 10000; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; SET NOCOUNT ON;')
    decl, args_ = [], []
    if r['kind'] == 'SP':
        sets = []
        for k, (v, p) in r['params'].items():
            if v == 'OUT':
                vn = '@o_' + k.lstrip('@'); decl.append(f'DECLARE {vn} {sqltype(p)};'); sets.append(f'{k}={vn} OUTPUT')
            else:
                sets.append(f'{k}=?'); args_.append(pval(v))
        sql = ' '.join(decl) + f" EXEC [{r['db']}].[dbo].[{r['name']}] " + ', '.join(sets)
    else:
        # FoxQuery 런타임과 같이 sp_executesql 파라미터 바인딩(본문 앞에 DECLARE 를 붙이면 WITH 로 시작하는 쿼리가 깨진다)
        ks = list(r['params'])
        sql = 'EXEC sp_executesql ?' + (', ?, ' + ', '.join(f'{k}=?' for k in ks) if ks else '')
        args_ = [r['text']] + ([', '.join(f'{k} nvarchar(max)' for k in ks)] + [pval(r['params'][k][0]) for k in ks] if ks else [])
    t0 = time.time(); info = []; n = 0
    cur.execute(sql, args_)
    while True:
        if cur.description:
            cols = [d[0] for d in cur.description]; rows = cur.fetchmany(MAXROWS); total = len(rows)
            while total < COUNTCAP:
                more = cur.fetchmany(5000)
                if not more: break
                total += len(more)
            n += 1
            d = os.path.join(DS, r['db'], re.sub(r'[\\/:*?"<>|#]', '_', r['name'])); os.makedirs(d, exist_ok=True)
            fn = os.path.join(d, f'{rid}_rs{n}.csv')
            with open(fn, 'w', encoding='utf-8-sig', newline='') as f:
                w = csv.writer(f); w.writerow(cols)
                for row in rows: w.writerow(['' if v is None else (v.isoformat() if hasattr(v, 'isoformat') else v) for v in row])
            info.append({'rs': n, 'cols': len(cols), 'rows': total if total < COUNTCAP else f'>={COUNTCAP}', 'saved': len(rows), 'file': os.path.relpath(fn, OUT)})
        if not cur.nextset(): break
    try:
        cur.execute("SELECT ISNULL(SUM(database_transaction_log_record_count),0) FROM sys.dm_tran_database_transactions WHERE transaction_id = CURRENT_TRANSACTION_ID() AND database_id <> 2")
        logrec = cur.fetchone()[0]
    except Exception:
        logrec = 'n/a'
    conn.rollback()
    return info, round(time.time() - t0, 2), logrec


def main():
    ids = IDS or sorted(x for x in os.listdir(os.path.join(OUT, 'screens')) if os.path.isdir(os.path.join(OUT, 'screens', x)))
    plans = collections.OrderedDict(); amap = collections.defaultdict(list); used = collections.defaultdict(set)
    for sid in ids:
        for u in units_for(sid):
            for r in plan(sid, u):
                rid = run_id(r) if r['status'] == 'PLAN' else hashlib.sha1((r['db'] + r['kind'] + r['name']).encode()).hexdigest()[:12]
                plans.setdefault(rid, r); used[rid].add(sid)
                amap[sid].append((u[0], rid, r.get('division', '')))
    todo = [rid for rid, r in plans.items() if r['status'] == 'PLAN']
    stc = collections.Counter(r['status'] for r in plans.values())
    print(f'screens {len(ids)} · runs {len(plans)} · {dict(stc)}', flush=True)
    os.makedirs(DS, exist_ok=True)
    if DRY:
        with open(os.path.join(DS, 'plan.csv'), 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.writer(f, quoting=csv.QUOTE_ALL)
            w.writerow(['run_id', 'status', 'kind', 'db', 'name', 'division', 'params', 'param_sources', 'safety_or_reason', 'screens'])
            for rid, r in plans.items():
                w.writerow([rid, r['status'], r['kind'], r['db'], r['name'], r.get('division', ''), json.dumps({k: pval(v[0]) for k, v in r['params'].items()}, ensure_ascii=False),
                            json.dumps(r['src'], ensure_ascii=False), r['why'], ' '.join(sorted(used[rid]))])
        print(f'plan → {os.path.join(DS, "plan.csv")}', flush=True)
        return
    prev = {}
    rp = os.path.join(DS, 'runs.csv')
    if os.path.exists(rp):
        for r in csv.DictReader(open(rp, encoding='utf-8-sig')): prev[r['run_id']] = r
    results = {}; qq = queue.Queue()
    for rid in todo:
        if prev.get(rid, {}).get('status') in ('OK', 'EMPTY', 'WROTE_ROLLED_BACK'): continue  # 재실행 시 끝난 실행 재사용
        qq.put(rid)
    lock = threading.Lock(); cnt = [0]; total = qq.qsize(); t0 = time.time()
    print(f'실행 {total}건 (이미 완료 {len(todo) - total}) · workers {WORKERS}', flush=True)
    def worker():
        conns = {}
        while True:
            try: rid = qq.get_nowait()
            except queue.Empty: break
            r = plans[rid]
            try:
                if r['db'] not in conns: conns[r['db']] = connect(r['db'])
                info, sec, logrec = execute(conns[r['db']], r, rid)
                st = 'WROTE_ROLLED_BACK' if isinstance(logrec, int) and logrec > 0 else ('OK' if any(s['saved'] for s in info) else 'EMPTY')
                res = dict(status=st, sec=sec, log_records=logrec, resultsets=json.dumps(info, ensure_ascii=False), error='')
            except Exception as e:
                msg = str(e).replace('\n', ' ')[:400]
                res = dict(status='TIMEOUT' if ('timeout' in msg.lower() or 'HYT00' in msg or 'HYT01' in msg) else 'ERROR', sec='', log_records='', resultsets='', error=msg)
                try: conns[r['db']].rollback()
                except Exception: conns.pop(r['db'], None)
            with lock:
                results[rid] = res; cnt[0] += 1
                if cnt[0] % 100 == 0: print(f'  {cnt[0]}/{total} ({int(time.time() - t0)}s)', flush=True)
        for c in conns.values():
            try: c.rollback(); c.close()
            except Exception: pass
    ths = [threading.Thread(target=worker) for _ in range(WORKERS)]
    [t.start() for t in ths]; [t.join() for t in ths]
    cols = ['run_id', 'db', 'kind', 'name', 'division', 'params', 'param_sources', 'safety', 'status', 'sec', 'log_records', 'resultsets', 'error', 'screens']
    allrows = {}  # 현재 계획에 있는 실행만(계획이 바뀌어 사라진 이전 실행 행은 버림)
    for rid, r in plans.items():
        res = results.get(rid) or (prev.get(rid) if prev.get(rid, {}).get('status') in ('OK', 'EMPTY', 'WROTE_ROLLED_BACK') else {'status': r['status']})
        allrows[rid] = {'run_id': rid, 'db': r['db'], 'kind': r['kind'], 'name': r['name'], 'division': r.get('division', ''),
                        'params': json.dumps({k: pval(v[0]) for k, v in r['params'].items()}, ensure_ascii=False), 'param_sources': json.dumps(r['src'], ensure_ascii=False),
                        'safety': r['why'], 'status': res.get('status'), 'sec': res.get('sec', ''), 'log_records': res.get('log_records', ''),
                        'resultsets': res.get('resultsets', ''), 'error': res.get('error', ''), 'screens': ' '.join(sorted(used[rid]))}
    with open(rp, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols); w.writeheader()
        for v in allrows.values(): w.writerow({k: v.get(k, '') for k in cols})
    for sid, lst in amap.items():
        with open(os.path.join(OUT, 'screens', sid, 'action_data.csv'), 'w', encoding='utf-8-sig', newline='') as f:
            w = csv.writer(f, quoting=csv.QUOTE_ALL)
            w.writerow(['screen_id', 'class', 'method', 'line', 'action_kind', 'action_target', 'run_id', 'kind', 'db', 'name', 'division', 'status', 'resultsets'])
            for ak, rid, dv in lst:
                a = allrows[rid]; w.writerow([sid, ak[0], ak[1], ak[2], ak[3], ak[4], rid, a['kind'], a['db'], a['name'], dv, a['status'], a['resultsets']])
    print(f'done · {dict(collections.Counter(allrows[rid]["status"] for rid in plans))} → {rp}', flush=True)


main()
