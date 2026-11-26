# -*- coding: utf-8 -*-
"""운영자 매뉴얼 구성 규칙(2026-11-24 사용자 확정). ops_manual.py 가 부름.

  장 구성(OPS): 업무 개요, 전체 업무 흐름, 프로세스 구조, UI 메뉴 구조, 배치 잡 구조, 시간대별 실행표, 데이터 구조, 인터페이스,
  일상 운영 점검표, 장애 대응, 로그와 모니터링, 기준 정보 관리, 권한과 메뉴 관리, 연락처와 담당 부서, 변경 이력과 산출물, 부록 A 잡별 배치 흐름도.
  - 배치 기준 = TO-BE(사내 Oracle DBMS_SCHEDULER 잡, 2026-11-24 사용자 지시). AS-IS 로직은 넣지 않음. TO-BE 잡에 스케줄이 없거나 잡이 없을 때만 AS-IS 시각을 참고값으로 적음.
  - 연락처와 담당 부서 = 장표와 표 모양만(빈 칸). 내용을 채우지 않음.
  - 본문은 업무 프로세스 단위로 묶고, 잡별 상세 흐름도는 부록 A.
  - 담당: ai = AI 단계가 content/chapters.json 에 씀 · gen = 생성기가 사실 자료로 만듦(AI 는 notes 로 설명만 보탬, 장 앞에 장표를 더할 수 있음) · layout = 모양만
"""
import os, re, csv, glob

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
# 2026-11-24 13:5x 사용자: 매뉴얼 취지 = 운영자가 운영하며 쓰는 정보. 나열식 목록은 본문에서 빼고 부록으로. TO-BE(NSCM) 변경점과 개선점 장 추가
#   (id, 장 이름, 담당, 본문/부록). 장 번호는 위치로 매김(본문 1.., 부록 A..), 장표 제목 번호도 compose 가 다시 매김
OPS = [
    ('C1', '업무 개요', 'ai', 'body'), ('CT', 'TO-BE 변경 사항과 개선점', 'ai', 'body'), ('C2', '전체 업무 흐름', 'ai', 'body'), ('C3', '업무 프로세스별 운영', 'ai', 'body'),
    ('C9', '일상 운영 점검표', 'ai', 'body'), ('C10', '장애 대응', 'ai', 'body'), ('C11', '로그와 모니터링', 'ai', 'body'), ('C12', '기준 정보 관리', 'ai', 'body'),
    ('C13', '권한과 메뉴 관리', 'ai', 'body'), ('C8', '인터페이스', 'gen', 'body'), ('C14', '연락처와 담당 부서', 'layout', 'body'),
    ('C4', 'UI 메뉴 구조', 'gen', 'app'), ('C5', '배치 JOB 구조', 'gen', 'app'), ('C6', '시간대별 실행표', 'gen', 'app'), ('C7', '데이터 구조', 'gen', 'app'),
    ('CTR', 'TO-BE 룰 목록', 'gen', 'app'), ('A', 'JOB별 배치 흐름도', 'gen', 'app'), ('C15', '산출물', 'gen', 'app'),
]
# 예전 장 이름(이미 쓴 content 제목을 새 번호로 바꿀 때 씀)
OLD_NAMES = {'C3': ['프로세스 구조'], 'C15': ['변경 이력과 산출물'], 'A': ['부록 A. 잡별 배치 흐름도', '잡별 배치 흐름도'], 'C5': ['배치 잡 구조']}
TOBE_RULES = os.path.join(ROOT, 'tools', 'Harness', 'rules', 'tobe_rule_registry.csv')
TOBE_MAP = os.path.join(ROOT, 'Doc', 'tobefacts', 'asis_mapping.csv')


def chapter_titles():
    """id → (번호 머리, 장 이름). 본문 = '1.', '2.' … 부록 = '부록 A.' …"""
    out = {}; nb = 0; na = 0
    for cid, name, _o, part in OPS:
        if part == 'body':
            nb += 1; out[cid] = (f'{nb}.', name)
        else:
            out[cid] = (f'부록 {chr(65 + na)}.', name); na += 1
    return out


AI_REQ = [c for c, _, o, _p in OPS if o == 'ai']
# 업무 프로세스 기본 묶음(TO-BE 잡 이름 + 실행 프로시저 기준, 위에서부터 첫 일치). AI 가 content.processOf 로 바꿀 수 있음
PROC_RULES = [('컷오프', r'CUTOFF'), ('메일과 SMS 알림', r'MAIL|SMS'), ('인터페이스 수신', r'_XIF_\w*?_R(?:_|\b)|EDI|NERP|_R\b'),
              ('인터페이스 송신', r'_XIF_\w*?_S(?:_|\b)|_S\b|SEND\b'), ('분석과 KPI', r'_ANL_|KPI|SUMMARY'), ('기준 정보 동기화', r'_MST_|SYNC|4MCC|MAPPING'),
              ('계획 생성', r'_PLN_|FCST|PLAN'), ('기타', r'')]
PROC_ORDER = ['기준 정보 동기화', '인터페이스 수신', '계획 생성', '컷오프', '인터페이스 송신', '분석과 KPI', '메일과 SMS 알림', '기타']
DOW = ['일', '월', '화', '수', '목', '금', '토']
TBL_KIND = [(r'XIF|_DNM_|_IF\b|_IF_', '인터페이스'), (r'_PLN_', '계획'), (r'_MST_|LOOKUP', '기준 정보'), (r'_ANL_|KPI', '분석'), (r'LOG', '로그'), (r'_BPS_', '사업 계획')]
CONTACT_COLS = ['구분', '시스템', '담당 부서', '담당자', '연락처', '비고']
NOTE_KEYS = ('screenNotes', 'jobNotes', 'tableNotes', 'processOf', 'processOrder')
NO_DESC = re.compile(r'^\s*$|설명이 없습니다|No description', re.I)
SQL_KW = {'SELECT', 'WHERE', 'SET', 'VALUES', 'TOP', 'WITH', 'AS', 'ON', 'AND', 'OR', 'NOT', 'NULL', 'EXISTS', 'OPENQUERY', 'DUAL', 'INSERTED', 'DELETED', 'OUTPUT', 'STRING_SPLIT', 'OPENJSON'}


def rcsv(f):
    try:
        with open(f, encoding='utf-8-sig', newline='') as fh:
            return list(csv.DictReader(fh))
    except Exception:
        return []


def wcsv(path, rows, cols):
    with open(path, 'w', encoding='utf-8-sig', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=cols, extrasaction='ignore'); w.writeheader()
        for r in rows:
            w.writerow(r)


def srcp(key, n):
    """근거 경로(저장소 기준). OPS_MANUAL_OUT 이면 그 폴더 기준"""
    base = os.environ.get('OPS_MANUAL_OUT') or os.path.join(ROOT, 'Doc', 'OpsManual')
    return os.path.relpath(os.path.join(base, key, 'facts', n), ROOT).replace(os.sep, '/')


def proc_of(job, execs):
    s = (job + ' ' + ' '.join(execs)).upper()
    for name, rx in PROC_RULES:
        if not rx or re.search(rx, s):
            return name
    return '기타'


def hhmm(v):
    try:
        v = int(v)
    except Exception:
        return ''
    return f'{v // 10000:02d}:{(v // 100) % 100:02d}'


def sched_info(s):
    """AS-IS 스케줄 한 줄 → { days, every, times, hours, on }. ops_tobe 가 TO-BE 잡 없는 배치의 참고 시각에만 씀"""
    try:
        ft, fi, st, si = int(s['freq_type']), int(s['freq_interval']), int(s['freq_subday_type']), int(s['freq_subday_interval'])
        rf = int(s.get('freq_recurrence_factor') or 0); a, b = int(s['active_start_time']), int(s['active_end_time'])
    except Exception:
        return {'days': '해독 불가', 'every': '', 'times': [], 'hours': [], 'on': s.get('enabled') == '1'}
    days = {1: '1회', 4: '매일' if fi == 1 else f'{fi}일마다', 8: (f'{rf}주마다 ' if rf > 1 else '') + ','.join(d for i, d in enumerate(DOW) if fi & (1 << i)),
            16: f'매월 {fi}일', 32: '매월 상대일', 64: 'Agent 시작 때', 128: '유휴 때'}.get(ft, f'freq_type {ft}')
    if st in (2, 4, 8):
        unit = {2: '초', 4: '분', 8: '시간'}[st]
        return {'days': days, 'every': f'{si}{unit}마다 {hhmm(a)}~{hhmm(b)}', 'times': [], 'hours': list(range(a // 10000, b // 10000 + 1)), 'on': s.get('enabled') == '1'}
    return {'days': days, 'every': '', 'times': [hhmm(a)], 'hours': [a // 10000], 'on': s.get('enabled') == '1'}


# ───────────────────────── TO-BE 본문 테이블 이름 ─────────────────────────
def tbl_names(rx, body):
    out = set()
    for m in re.finditer(rx, body):
        n = m.group(1).upper()
        if n.startswith(('#', '@')) or n in SQL_KW or len(n) < 4 or '_' not in n:
            continue
        out.add(n)
    return out


# ───────────────────────── 사실 수집(prep) ─────────────────────────
def collect(d, plan, S, B, common_rx, tobe, TL):
    """facts/jobs.csv, timeline.csv, job_links.csv, sp_tables.csv, tables.csv. B, TL = ops_tobe.batch_facts(TO-BE 잡), tobe = ops_tobe.TobeDB. 반환 요약 dict"""
    mods_jobs = {}
    for b in B:
        mods_jobs.setdefault(b['job'], []).append(b)
    J, T, L, SPT = [], list(TL), [], {}
    for job, st in mods_jobs.items():
        execs = [x for b in st for x in b['exec'].split(', ') if x]
        J.append({'job': job, 'module': st[0]['module'], 'process': proc_of(job, execs), 'enabled': st[0]['enabled'], 'desc': (st[0]['desc'] or '').replace('\r', ' ').replace('\n', ' ')[:300],
                  'schedule': st[0]['schedule'], 'steps': len(st), 'exec': ', '.join(dict.fromkeys(execs)), 'ext': next((b['ext'] for b in st if b['ext']), ''),
                  'runs': st[0]['runs'], 'failed': st[0]['failed'], 'lastOutcome': st[-1]['lastOutcome'], 'lastRun': st[-1]['lastRun'], 'basis': st[0]['basis']})
        for sp in dict.fromkeys(execs):
            if sp not in SPT:
                w, r = tobe.io(sp)
                SPT[sp] = {'sp': sp, 'found': 'Y' if w is not None else 'N', 'writes': ' '.join(w or []), 'reads': ' '.join(r or [])}
    tables = {}

    def tb(n):
        return tables.setdefault(n, {'table': n, 'kind': next((k for rx, k in TBL_KIND if re.search(rx, n)), '기타'), 'screenWrites': set(), 'screenReads': set(), 'batchWrites': set(), 'batchReads': set()})
    for s in S:
        for t in s['writes'].split():
            if not common_rx.search(t):
                tb(t)['screenWrites'].add(s['id'])
        for t in s['reads'].split():
            if not common_rx.search(t) and t in tables:
                tables[t]['screenReads'].add(s['id'])
    for sp in SPT.values():
        for t in sp['writes'].split():
            if not common_rx.search(t):
                tb(t)['batchWrites'].add(sp['sp'])
    for sp in SPT.values():
        for t in sp['reads'].split():
            if t in tables:
                tables[t]['batchReads'].add(sp['sp'])
    for s in S:  # 쓰는 곳이 생긴 뒤 화면 읽기 다시
        for t in s['reads'].split():
            if t in tables:
                tables[t]['screenReads'].add(s['id'])
    TB = [{k: (' '.join(sorted(v)) if isinstance(v, set) else v) for k, v in x.items()} for x in sorted(tables.values(), key=lambda x: (x['kind'], x['table']))]
    mod_ids = {s['id'] for s in S}
    TR = [r for r in rcsv(TOBE_RULES) if r.get('scope') == 'ALL' or r.get('scope') in mod_ids or any(x in mod_ids for x in re.split(r'[;, ]+', r.get('scope') or ''))]
    wcsv(os.path.join(d, 'facts', 'tobe_rules.csv'), [{k: (r.get(k) or '').replace('\n', ' ') for k in ('rule_id', 'kind', 'scope', 'title', 'requirement', 'status')} for r in TR], ['rule_id', 'kind', 'scope', 'title', 'requirement', 'status'])
    TM = {}
    for r in rcsv(TOBE_MAP):
        if r.get('menu_id') in mod_ids:
            x = TM.setdefault(r['menu_id'], {'screen': r['menu_id'], 'page': r.get('page_key', ''), 'items': 0, 'implemented': 0, 'other': 0})
            x['items'] += 1
            if (r.get('status') or '').strip() == '구현':
                x['implemented'] += 1
            else:
                x['other'] += 1
    wcsv(os.path.join(d, 'facts', 'tobe_mapping.csv'), sorted(TM.values(), key=lambda x: x['screen']), ['screen', 'page', 'items', 'implemented', 'other'])
    wcsv(os.path.join(d, 'facts', 'jobs.csv'), J, ['job', 'module', 'process', 'enabled', 'desc', 'schedule', 'steps', 'exec', 'ext', 'runs', 'failed', 'lastOutcome', 'lastRun', 'basis'])
    wcsv(os.path.join(d, 'facts', 'timeline.csv'), T, ['job', 'jobOn', 'on', 'days', 'every', 'times', 'hours', 'basis'])
    wcsv(os.path.join(d, 'facts', 'job_links.csv'), L, ['from', 'to', 'how'])
    wcsv(os.path.join(d, 'facts', 'sp_tables.csv'), list(SPT.values()), ['sp', 'found', 'writes', 'reads'])
    wcsv(os.path.join(d, 'facts', 'tables.csv'), TB, ['table', 'kind', 'screenWrites', 'screenReads', 'batchWrites', 'batchReads'])
    return {'jobs': len(J), 'schedules': len(T), 'links': len(L), 'sps': len(SPT), 'spFound': sum(1 for x in SPT.values() if x['found'] == 'Y'), 'tables': len(TB),
            'tobeRules': len(TR), 'tobeMapped': len(TM), 'processes': sorted({j['process'] for j in J}, key=lambda p: PROC_ORDER.index(p) if p in PROC_ORDER else 99)}


def facts(d):
    f = lambda n: rcsv(os.path.join(d, 'facts', n))
    return {'TR': f('tobe_rules.csv'), 'TM': f('tobe_mapping.csv'), 'S': f('screens.csv'), 'J': f('jobs.csv'), 'T': f('timeline.csv'), 'L': f('job_links.csv'), 'SPT': f('sp_tables.csv'), 'TB': f('tables.csv'), 'B': f('batch.csv'), 'E': f('flow_edges.csv')}


def processes(F, content):
    po = (content or {}).get('processOf') or {}
    for j in F['J']:
        j['process'] = po.get(j['job']) or j['process']
    order = list((content or {}).get('processOrder') or []) + [p for p in PROC_ORDER]
    names = []
    for j in F['J']:
        if j['process'] not in names:
            names.append(j['process'])
    return sorted(names, key=lambda p: order.index(p) if p in order else 99)


# ───────────────────────── 자동 초안(AI 장) ─────────────────────────
def auto_draft(plan, F, key):
    src = lambda n: srcp(key, n)
    procs = processes(F, None); chs = []
    chs.append({'id': 'C1', 'title': '1. 업무 개요', 'slides': [{'kind': 'text', 'title': '1. 업무 개요', 'lines': ['작성 필요(AI 단계)'], 'src': [src('screens.csv'), src('jobs.csv')]}]})
    nodes = [{'id': p, 'label': p, 'sub': f'잡 {sum(1 for j in F["J"] if j["process"] == p)}개'} for p in procs]
    chs.append({'id': 'C2', 'title': '2. 전체 업무 흐름', 'slides': [{'kind': 'flow', 'title': '2. 전체 업무 흐름', 'nodes': nodes, 'edges': [{'from': procs[i], 'to': procs[i + 1], 'label': ''} for i in range(len(procs) - 1)], 'notes': ['작성 필요(AI 단계)'], 'src': [src('jobs.csv'), src('flow_edges.csv')]}]})
    sl = []
    for p in procs:
        js = [j for j in F['J'] if j['process'] == p]
        sl.append({'kind': 'divider', 'title': p})
        sl.append({'kind': 'flow', 'title': f'3. 프로세스 구조 - {p}', 'nodes': [{'id': j['job'], 'label': j['job'][:40], 'sub': j['schedule'][:30]} for j in js[:15]], 'edges': [], 'notes': ['작성 필요(AI 단계)'], 'src': [src('jobs.csv'), src('sp_tables.csv')]})
    chs.append({'id': 'C3', 'title': '3. 프로세스 구조', 'slides': sl})
    for cid, t, o, _p in OPS:
        if o == 'ai' and cid not in ('C1', 'C2', 'C3'):
            n = cid[1:]
            chs.append({'id': cid, 'title': f'{n}. {t}', 'slides': [{'kind': 'text', 'title': f'{n}. {t}', 'lines': ['작성 필요(AI 단계)'], 'src': [src('jobs.csv')]}]})
    return {'key': key, 'auto': True, 'screenNotes': {}, 'jobNotes': {}, 'tableNotes': {}, 'processOf': {}, 'processOrder': procs, 'chapters': chs}


# ───────────────────────── 생성기 장(gen, layout) ─────────────────────────
def tobe_part(t):
    """룰 원문이 'AS-IS: … → TO-BE: …' 이면 TO-BE 부분만(2026-11-24 사용자: AS-IS 로직은 매뉴얼에 넣지 않음)"""
    m = re.search(r'TO-BE\s*[:：]\s*(.+)$', str(t or ''), re.S)
    t = (m.group(1) if m and re.search(r'AS-IS\s*[:：]', str(t)) else str(t or '')).strip()
    # 2026-11-24 사용자: 근거 표기 삭제. 룰 원문의 판정 메모('(PASS 로 근거 표시)', '· 사유 근거 …', '· 근거 …', '· 처리 내역 …')는 싣지 않음
    t = re.sub(r'\([^()]*근거[^()]*\)', '', t)
    t = re.split(r'\s*·\s*(?:사유|근거|처리 내역|판정)', t)[0]
    return re.sub(r'\s{2,}', ' ', t).strip()


def gen_chapter(cid, plan, F, content, key):
    src = lambda n: srcp(key, n)
    sn = content.get('screenNotes') or {}; jn = content.get('jobNotes') or {}; tn = content.get('tableNotes') or {}
    S, J, T, L, TB = F['S'], F['J'], F['T'], F['L'], F['TB']
    if cid == 'C4':
        sl = []
        for top in dict.fromkeys(s['top'] for s in S):
            gs = list(dict.fromkeys(s['group'] for s in S if s['top'] == top)); hub = f'top:{top}'
            # 2026-11-24 사용자 지적(별 모양 그림 시인성 나쁨) → 계층 구조형(Level1 → Level2 → 화면)
            sl.append({'kind': 'tree', 'title': f'4. UI 메뉴 구조 - {top}', 'root': top, 'groups': [{'name': g, 'items': [[s['id'], s['name']] for s in S if s['top'] == top and s['group'] == g]} for g in gs], 'src': [src('screens.csv')]})
        sl.append({'kind': 'table', 'title': '4. UI 메뉴 구조 - 화면 목록', 'columns': ['Level1', 'Level2', '화면 ID', '화면명', '저장 대상 테이블', '역할'],
                   'rows': [[s['top'], s['group'], s['id'], s['name'], ' '.join(s['writes'].split()[:4]) or '조회 전용', sn.get(s['id'], '')] for s in S], 'src': [src('screens.csv')]})
        return sl
    if cid == 'C5':
        # 사용 여부 칸 없음: 사내 TO-BE 잡 enabled 값은 운영 반영 전 값이라 쓰지 않음(운영 미확인)
        rows = [[j['job'], j['process'], j['schedule'][:50], j['steps'], j['exec'][:60], (j['desc'] if not NO_DESC.search(j['desc']) else jn.get(j['job'], ''))[:80]] for j in J]
        sl = [{'kind': 'table', 'title': '5. 배치 잡 구조 - 잡 목록', 'columns': ['잡', '프로세스', '스케줄', '단계', '실행 프로시저', '설명'], 'rows': rows, 'src': [src('jobs.csv')]}]
        if L:
            ns = list(dict.fromkeys([x['from'] for x in L] + [x['to'] for x in L]))
            sl.append({'kind': 'flow', 'title': '5. 배치 잡 구조 - 잡 호출 관계', 'nodes': [{'id': n, 'label': n[:40], 'sub': ''} for n in ns], 'edges': [{'from': x['from'], 'to': x['to'], 'label': x.get('how', '')} for x in L], 'src': [src('job_links.csv')]})
        return sl
    if cid == 'C6':
        # 시각 = TO-BE 잡 스케줄. TO-BE 잡이 없거나 스케줄이 없는 배치만 AS-IS 시각을 참고 행으로 따로 셈(2026-11-24 사용자 지시)
        bands = [(0, 6), (6, 12), (12, 18), (18, 24)]
        tobe = [t for t in T if (t.get('basis') or 'TO-BE 잡') == 'TO-BE 잡']; ref = [t for t in T if t not in tobe and t['hours'].strip()]
        cnt = lambda rs: [str(sum(1 for t in rs if any(a <= int(h) < b for h in t['hours'].split()))) for a, b in bands]
        rows = [['TO-BE 스케줄'] + cnt(tobe) + [str(sum(1 for t in T if t['days'] == '스케줄 없음'))]] + ([['AS-IS 참고 시각'] + cnt(ref) + ['']] if ref else [])
        sl = [{'kind': 'table', 'title': '6. 시간대별 실행표 - 시간대 요약', 'columns': ['구분'] + [f'{a:02d}~{b:02d}시' for a, b in bands] + ['스케줄 없음'], 'rows': rows, 'src': [src('timeline.csv')]}]
        rows = sorted(T, key=lambda t: (t['days'] == '스케줄 없음', int((t['hours'].split() or ['99'])[0]), t['job']))
        sl.append({'kind': 'timeline', 'title': '6. 시간대별 실행표', 'rows': [{'job': t['job'], 'days': t['days'], 'every': t['every'], 'times': t['times'].split(), 'hours': [int(h) for h in t['hours'].split()], 'on': True} for t in rows], 'src': [src('timeline.csv')]})
        return sl
    if cid == 'C7':
        return [{'kind': 'table', 'title': '7. 데이터 구조 - 테이블', 'columns': ['테이블', '구분', '쓰는 화면', '읽는 화면', '쓰는 배치 SP', '역할'],
                 'rows': [[t['table'], t['kind'], t['screenWrites'][:30], t['screenReads'][:30], t['batchWrites'][:40], tn.get(t['table'], '')[:60]] for t in TB], 'src': [src('tables.csv'), src('sp_tables.csv')]}]
    if cid == 'C8':
        ext = {}
        for j in J:
            if j['ext']:
                ext.setdefault(j['ext'], []).append(j)
        ext = {x: v for x, v in ext.items() if x not in plan['mods']}
        hub = 'NSCM_' + '_'.join(plan['mods'])
        nodes = [{'id': x, 'label': x, 'sub': f'잡 {len(v)}개'} for x, v in ext.items()] + [{'id': hub, 'label': 'NSCM ' + ', '.join(plan['mods']), 'sub': 'TO-BE 배치 기준', 'hub': True}]
        edges = []
        for x, v in ext.items():
            rc = [j for j in v if j['process'] == '인터페이스 수신']; sd = [j for j in v if j not in rc]
            if rc:
                edges.append({'from': x, 'to': hub, 'label': ', '.join(j['exec'].split(', ')[0] for j in rc[:2])})
            if sd:
                edges.append({'from': hub, 'to': x, 'label': ', '.join(j['exec'].split(', ')[0] for j in sd[:2])})
        tbl = [[x, j['job'], j['process'], j['schedule'][:40], j['exec'][:60]] for x, v in ext.items() for j in v]
        return [{'kind': 'flow', 'layout': 'hub', 'title': '8. 인터페이스 구성도', 'nodes': nodes, 'edges': edges, 'src': [src('jobs.csv')]},
                {'kind': 'table', 'title': '8. 인터페이스 - 잡 목록', 'columns': ['외부 시스템', '잡', '구분', '스케줄', '실행 프로시저'], 'rows': tbl or [['해당 없음', '', '', '', '']], 'src': [src('jobs.csv')]}]
    if cid == 'CTR':
        TR = F.get('TR') or []
        return [{'kind': 'table', 'title': 'TO-BE 룰 목록', 'columns': ['룰', '구분', '범위', '제목', '요구 사항'],
                 'rows': [[r['rule_id'], '개발 기준' if r['kind'] == 'TOBE_DEV' else 'AS-IS 와 다름', '전 화면' if r['scope'] == 'ALL' else r['scope'], r['title'][:40], tobe_part(r['requirement'])[:90]] for r in TR] or [['없음', '', '', '', '']],
                 'src': ['tools/Harness/rules/tobe_rule_registry.csv', src('tobe_rules.csv')]}]
    if cid == 'CT_FALLBACK':
        TR = F.get('TR') or []; TM = F.get('TM') or []
        allr = [r for r in TR if r['scope'] == 'ALL']
        lines = [f'기술 구조: AS-IS C#.NET WinForms, MS-SQL → TO-BE React 18, Spring Boot 3.5, Oracle 19c',
                 f'TO-BE 룰: {len(TR)}건(전 화면 공통 {len(allr)}건, 화면별 {len(TR) - len(allr)}건). 목록 = 부록 TO-BE 룰 목록',
                 (f'AS-IS 대조: 화면 {len(TM)}개, 항목 {sum(int(x["items"]) for x in TM)}건 중 구현 {sum(int(x["implemented"]) for x in TM)}건' if TM else 'AS-IS 대조: 대조 원장(Doc/tobefacts/asis_mapping.csv)에 이 모듈 화면 없음(미확인)')]
        return [{'kind': 'text', 'title': 'TO-BE 변경 사항과 개선점', 'lines': lines, 'src': [src('tobe_rules.csv'), src('tobe_mapping.csv')]}]
    if cid == 'C14':
        return [{'kind': 'table', 'title': '14. 연락처와 담당 부서', 'columns': CONTACT_COLS, 'rows': [[''] * len(CONTACT_COLS) for _ in range(10)], 'src': [], 'layoutOnly': True}]
    if cid == 'C15':
        rows = []
        pre = {'DM': ('DMF', 'DMD'), 'SCP': ('SCP',), 'SSP': ('SSP',), 'SYSTEM': ('SYS',)}
        ids = [s['id'] for s in S]
        for label, pat in (('화면분석서', 'Doc/화면분석서/*'), ('화면설계서', 'Doc/화면설계서/*'), ('UI CheckList', 'Doc/UI_CHECKLIST/*'), ('사용자 매뉴얼', 'Doc/UserManual/*/*.pptx'), ('운영자 매뉴얼', 'Doc/OpsManual/*/*.pptx')):
            fs = [f for f in glob.glob(os.path.join(ROOT, pat)) if any(os.path.basename(f).upper().startswith(p) for m in plan['mods'] for p in pre[m]) or any(i in f for i in ids) or any(f'{os.sep}{m}' in f for m in plan['mods'])]
            rows.append([label, pat, str(len(fs))])
        return [{'kind': 'table', 'title': '15. 변경 이력과 산출물 - 산출물', 'columns': ['구분', '경로', '건수'], 'rows': rows, 'src': ['Doc']}]
    if cid == 'C2MAP':  # 2026-11-24 사용자: 흐름이 너무 나뉘어 있음 → 전체 프로세스 한 장(프로세스 순서 + 관련 화면, 잡, 시각, 결과 테이블)
        spt = {x['sp']: x for x in F['SPT']}; tbl = {t['table']: t for t in TB}; tl = {}
        for t in T:
            tl.setdefault(t['job'], []).append(t)
        procs = []
        for p in processes(F, content):
            js = [j for j in J if j['process'] == p]
            w = sorted({t for j in js for sp in j['exec'].split(', ') if sp in spt for t in spt[sp]['writes'].split()})
            scr = sorted({s for t in w if t in tbl for s in tbl[t]['screenReads'].split()} | {s for t in w if t in tbl for s in tbl[t]['screenWrites'].split()})
            times = []
            for j in js:
                for t in tl.get(j['job'], []):
                    if t['days'] != '스케줄 없음':
                        v = f"{t['days']} {t['times'] or t['every']}".strip()
                        if v not in times:
                            times.append(v)
            procs.append({'name': p, 'screens': scr or ['없음'], 'jobs': [f'{len(js)}개'] + [re.sub(r'^JOB_(?:LGCE_SCMPROD_)?', '', j['job'])[:28] for j in js[:4]], 'times': times[:5] or ['스케줄 없음'], 'tables': w[:6] or ['없음']})
        return [{'kind': 'pmap', 'title': '2. 전체 업무 흐름 - 전체 프로세스 맵', 'procs': procs, 'src': [src('jobs.csv'), src('sp_tables.csv'), src('tables.csv'), src('timeline.csv')]}]
    if cid == 'A':
        spt = {x['sp']: x for x in F['SPT']}; sl = []
        for p in processes(F, content):
            js = [j for j in J if j['process'] == p]
            if not js:
                continue
            sl.append({'kind': 'divider', 'title': f'부록 A. {p}'})
            for j in js:
                st = [b for b in F['B'] if b['job'] == j['job']]
                nodes = [{'id': f's{b["step"]}', 'label': (b['stepName'] or b['exec'])[:30], 'sub': b['exec'][:32]} for b in st]
                w = sorted({t for b in st for x in b['exec'].split(', ') if x in spt for t in spt[x]['writes'].split()})
                sl.append({'kind': 'flow', 'title': f'A. {p} - {j["job"]}', 'nodes': nodes, 'edges': [{'from': nodes[i]['id'], 'to': nodes[i + 1]['id'], 'label': ''} for i in range(len(nodes) - 1)],
                           'notes': [f'스케줄: {j["schedule"][:80]}'] + ([f'쓰는 테이블: {", ".join(w[:8])}'] if w else []) + ([jn.get(j['job'])] if jn.get(j['job']) else []), 'src': [src('batch.csv'), src('sp_tables.csv')]})
        return sl
    return []


def retitle(title, head, name, olds):
    """장표 제목 번호를 장 위치 번호로 바꿈. '3. 프로세스 구조 - X' → '4. 업무 프로세스별 운영 - X'(본문) · 'A. UI 메뉴 구조 - X'(부록)"""
    t = re.sub(r'^\s*(?:부록\s+[A-Z]\.|[A-Z]\.|\d+\.)\s*', '', str(title or '')).strip()
    h = head.replace('부록 ', '')
    for nm in [name] + list(olds):
        if t.startswith(nm):
            return f'{h} {name}{t[len(nm):]}'
    return f'{h} {name} - {t}' if t else f'{h} {name}'


def compose(plan, F, content, key):
    """최종 장 순서(본문 → 부록). ai 장 = content 장표, gen 장 = content 의 같은 id 장표(앞) + 생성기 장표, layout = 모양만. 장표 제목 번호는 위치로 다시 매김"""
    by = {c.get('id'): c for c in (content or {}).get('chapters', [])}
    TT = chapter_titles(); chs = []
    for cid, t, o, part in OPS:
        head, name = TT[cid]
        slides = list((by.get(cid) or {}).get('slides') or []) if o != 'layout' else []
        if o in ('gen', 'layout'):
            if not (cid == 'C8' and slides):
                slides += gen_chapter(cid, plan, F, content or {}, key)
        if cid == 'C2':  # 전체 프로세스 맵을 장 맨 앞에
            slides = gen_chapter('C2MAP', plan, F, content or {}, key) + slides
        if cid == 'CT' and not slides:  # AI 가 아직 안 쓴 경우 사실 요약
            slides = gen_chapter('CT_FALLBACK', plan, F, content or {}, key)
        out = []
        for sl in slides:
            sl = dict(sl)
            if sl.get('kind') == 'divider':
                dt = re.sub(r'^\s*(?:부록\s+[A-Z]\.|[A-Z]\.|\d+\.)\s*', '', str(sl.get('title', ''))).strip()
                sl['title'] = f'{head} {dt}' if part == 'app' else dt
            else:
                sl['title'] = retitle(sl.get('title', ''), head, name, OLD_NAMES.get(cid, []))
            out.append(sl)
        chs.append({'id': cid, 'title': f'{head} {name}', 'owner': o, 'part': part, 'slides': out})
    return chs


# ───────────────────────── 검사 규칙 ─────────────────────────
# 2026-11-24 사용자: AS-IS 로직은 운영자 매뉴얼에 넣지 않음. 시각 참고('AS-IS 참고 시각')와 변경 전후 비교 문장(CT 장)은 허용
ASIS_LOGIC = re.compile(r'msdb|sysjobs|sysjobhistory|sysschedules|sp_start_job|sp_executesql|SQL\s*Server\s*Agent|SQL\s*Server|WITH\s*\(\s*NOLOCK|\bNOLOCK\b|GETDATE\s*\(|ISNULL\s*\(|DATEADD\s*\(|\bTOP\s+\d|\bJOB\.[A-Z]|LGCE_SCMDEV|LGCE_SCM\.dbo|\bdbo\.|\bEXEC\s+(?:dbo\.)?\w', re.I)


def asis_logic_hits(content):
    """content 의 장표 글(제목, 줄, 표, 노드, 메모)에서 AS-IS 로직 흔적. 반환 [(장, 장표 제목, 찾은 글)]"""
    out = []

    def walk(v):
        if isinstance(v, str):
            yield v
        elif isinstance(v, dict):
            for x in v.values():
                yield from walk(x)
        elif isinstance(v, list):
            for x in v:
                yield from walk(x)
    for ch in (content or {}).get('chapters', []):
        for sl in ch.get('slides', []):
            for t in walk({k: v for k, v in sl.items() if k != 'src'}):
                m = ASIS_LOGIC.search(t)
                if m:
                    out.append((ch.get('id'), sl.get('title', ''), t[max(0, m.start() - 20): m.end() + 30]))
    for k in ('jobNotes', 'screenNotes', 'tableNotes'):
        for n, t in ((content or {}).get(k) or {}).items():
            m = ASIS_LOGIC.search(str(t))
            if m:
                out.append((k, n, str(t)[max(0, m.start() - 20): m.end() + 30]))
    return out


def check(plan, F, content, check_slide, style_texts):
    fails = []; c = content or {}
    by = {x.get('id'): x for x in c.get('chapters', [])}
    for cid in AI_REQ:
        ch = by.get(cid)
        if not ch or not [s for s in ch.get('slides', []) if s.get('kind') != 'divider']:
            fails.append(f'장 빠짐 {cid} {dict((a, b) for a, b, _, _p in OPS)[cid]}')
    procs = processes(F, c)
    c3 = (by.get('C3') or {}).get('slides', [])
    divs = [s.get('title', '') for s in c3 if s.get('kind') == 'divider']
    for p in procs:
        if p not in divs:
            fails.append(f'C3 프로세스 간지 빠짐: {p}(잡 {sum(1 for j in F["J"] if j["process"] == p)}개)')
    cur = None; seen_flow = set(); per = {}
    for s in c3:
        if s.get('kind') == 'divider':
            cur = s.get('title')
        elif cur:
            per[cur] = per.get(cur, 0) + 1
            if s.get('kind') == 'flow':
                seen_flow.add(cur)
            if s.get('kind') == 'table' and len(s.get('rows') or []) > 8:  # 2026-11-24 사용자: 나열식 목록은 본문에서 뺌(잡 목록 = 부록 배치 잡 구조)
                fails.append(f'C3 {cur}: 표 {len(s.get("rows") or [])}행 = 목록 나열. 잡, 테이블 목록은 부록에 있으니 운영 포인트(확인, 조치) 8행 이내로')
    for p, n in per.items():
        if n > 3:
            fails.append(f'C3 {p}: 장표 {n}장. 프로세스마다 흐름 1장 + 운영 포인트 2장 이내')
    for p in procs:
        if p in divs and p not in seen_flow:
            fails.append(f'C3 {p}: 흐름도 없음')
    sn = c.get('screenNotes') or {}; jn = c.get('jobNotes') or {}; tn = c.get('tableNotes') or {}
    ms = [s['id'] for s in F['S'] if not str(sn.get(s['id'], '')).strip()]
    if ms:
        fails.append(f'screenNotes 빠짐 {len(ms)}개(UI 메뉴 구조 역할 칸): {", ".join(ms[:15])}')
    mj = [j['job'] for j in F['J'] if NO_DESC.search(j['desc']) and not str(jn.get(j['job'], '')).strip()]
    if mj:
        fails.append(f'jobNotes 빠짐 {len(mj)}개(설명 없는 TO-BE 잡): {", ".join(mj[:10])}')
    mt = [t['table'] for t in F['TB'] if (t['screenWrites'] or t['batchWrites']) and not str(tn.get(t['table'], '')).strip()]
    if mt:
        fails.append(f'tableNotes 빠짐 {len(mt)}개(쓰는 곳이 있는 테이블): {", ".join(mt[:15])}')
    texts = [str(v) for k in ('screenNotes', 'jobNotes', 'tableNotes') for v in (c.get(k) or {}).values()]
    allids = {s['id'] for s in F['S']}; jobs = {j['job'] for j in F['J']}; seen = {'screens': set(), 'jobs': set()}
    for cid in AI_REQ + ['C8', 'C15']:
        for i, s in enumerate((by.get(cid) or {}).get('slides', []), 1):
            if s.get('kind') == 'divider':
                continue
            check_slide(f'{cid}-{i} {s.get("title", "")}', s, allids, jobs, seen, texts, fails)
    if by.get('C14') and by['C14'].get('slides'):
        fails.append('C14 연락처와 담당 부서 = 모양만 생성(내용 쓰지 않음). chapters.json 에서 C14 장표를 뺌')
    hits = asis_logic_hits(c)
    for cid, t, x in hits[:15]:  # 2026-11-24 사용자: AS-IS 로직 금지(TO-BE 로직만)
        fails.append(f'AS-IS 로직 들어감 {cid} {str(t)[:40]}: "{x.strip()}" → TO-BE(Oracle, DBMS_SCHEDULER, TO-BE 프로시저) 기준으로 바꿈')
    if len(hits) > 15:
        fails.append(f'AS-IS 로직 들어감 나머지 {len(hits) - 15}건')
    unk = [k for k in list(jn) + list(c.get('processOf') or {}) if k not in {j['job'] for j in F['J']}]
    if unk:
        fails.append(f'TO-BE 잡에 없는 잡 이름 {len(unk)}개(jobNotes, processOf): {", ".join(unk[:8])} → facts/jobs.csv 의 TO-BE 잡 이름으로')
    style_texts(texts, fails)
    return fails, {'procs': len(procs), 'screenNotes': len(F['S']) - len(ms), 'screens': len(F['S']), 'jobNotes': len(mj), 'tableNotes': len(mt), 'tables': len(F['TB'])}
