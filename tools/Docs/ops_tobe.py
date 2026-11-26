# -*- coding: utf-8 -*-
"""운영자 매뉴얼 TO-BE 사실 수집(2026-11-24 사용자 지시). ops_manual.py prep 이 부름.

  사용자 지시: 모든 잡, 배치는 TO-BE 기준으로만. TO-BE 에 잡이 걸려 있지 않은 경우만 시각을 AS-IS 시각으로 참고 표기. AS-IS 로직은 매뉴얼에 넣지 않음.
  원천(사내 Oracle, 접속 tools/DbConn dbconn 'tobe', 실행 때 조회)
    - 화면 → TO-BE 프로시저: SCM_MGR.SCM_ADM_MNU_M, SCM_ADM_MNU_BTN_MPG_M, SCM_ADM_API_M(메뉴, 버튼, API 배선)
    - 배치: ALL_SCHEDULER_JOBS(owner SCM_MGR, job_action 의 '-- step N : 이름' 단계와 호출 프로시저), ALL_SCHEDULER_SCHEDULES(이름 붙은 스케줄)
    - 읽기, 쓰기 테이블: ALL_SOURCE(프로시저, 패키지 본문의 해당 프로시저 구간)
  AS-IS 참고 시각(시각만): Doc/asisfacts/db/batch(SQL Server Agent 잡) 중 실행 SP 가 TO-BE 에 같은 이름으로 있는데 TO-BE 잡이 그 프로시저를 부르지 않는 것.
    TO-BE 잡에 스케줄이 없는 것(같은 이름 AS-IS 잡). AS-IS 잡 이름, 단계, SP 는 쓰지 않음.
"""
import os, re, sys, csv

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'Analysis'))
BATCH = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'batch')
OWNER = 'SCM_MGR'
DOW = {'MON': '월', 'TUE': '화', 'WED': '수', 'THU': '목', 'FRI': '금', 'SAT': '토', 'SUN': '일'}
MOD_RX = {'DM': r'PR_DM_|DMF\d{4}|DMD\d{4}|PKG_DM|(?:^|_)DM_', 'SCP': r'PR_SCP_|SCP\d{4}|PKG_SCP|(?:^|_)SCP_', 'SSP': r'PR_SSP_|SSP\d{4}|PKG_SSP|(?:^|_)SSP_', 'SYSTEM': r'PR_SCM_SYS|SYS\d{4}|PKG_SYS'}
SQL_KW = {'BEGIN', 'END', 'DECLARE', 'IF', 'THEN', 'ELSE', 'LOOP', 'COMMIT', 'ROLLBACK', 'NULL', 'RETURN', 'EXCEPTION', 'WHEN', 'OTHERS', 'RAISE', 'EXECUTE', 'IMMEDIATE', 'DBMS_OUTPUT', 'DBMS_LOCK', 'DBMS_SCHEDULER', 'TO_CHAR', 'SYSDATE', 'NVL'}


def rcsv(f):
    try:
        with open(f, encoding='utf-8-sig', newline='') as fh:
            return list(csv.DictReader(fh))
    except Exception:
        return []


def cal_info(ri):
    """DBMS_SCHEDULER 달력 문자열 → { days, every, times, hours, text }"""
    d = {}
    for kv in str(ri or '').upper().replace(' ', '').split(';'):
        if '=' in kv:
            k, v = kv.split('=', 1); d[k] = v
    f = d.get('FREQ', ''); iv = int(d.get('INTERVAL', '1') or 1)
    hrs = [int(x) for x in d.get('BYHOUR', '').split(',') if x.isdigit()]
    mins = [int(x) for x in d.get('BYMINUTE', '').split(',') if x.isdigit()] or [0]
    if d.get('BYDAY'):
        days = ','.join(DOW.get(x[-3:], x) for x in d['BYDAY'].split(','))
    elif f == 'MONTHLY':
        days = f'매월 {d.get("BYMONTHDAY", "")}일'.replace(' 일', '')
    elif f == 'WEEKLY':
        days = '매주'
    else:
        days = '매일' if iv == 1 or f in ('HOURLY', 'MINUTELY') else f'{iv}일마다'
    if f in ('HOURLY', 'MINUTELY'):
        every = f'{iv}{"시간" if f == "HOURLY" else "분"}마다'
        hours = hrs or list(range(24)); times = []
        text = f'{days} {every}' + (f'({min(hours):02d}~{max(hours):02d}시)' if hrs else '')
    else:
        every = ''; hours = hrs or [0]
        times = [f'{h:02d}:{m:02d}' for h in (hrs or [0]) for m in mins]
        text = f'{days} {", ".join(times)}'
    return {'days': days, 'every': every, 'times': times, 'hours': hours, 'text': text.strip()}


class TobeDB:
    """사내 Oracle TO-BE 사실(한 번 읽고 캐시)"""

    def __init__(self):
        from dbconn import connect
        self.cx = connect('tobe'); self.cx.call_timeout = 120000
        self.cur = self.cx.cursor(); self._src = {}; self._pkg = {}; self._io = {}
        self.cur.execute(f"""SELECT M.MNU_ID, NVL(BMP.SHT_NM,'_DEFAULT_'), NVL(BMP.MNU_BTN_CD,'SEARCH'), API.API_URL
                               FROM {OWNER}.SCM_ADM_MNU_M M
                               JOIN {OWNER}.SCM_ADM_MNU_BTN_MPG_M BMP ON BMP.MNU_ID = M.MNU_ID
                               JOIN {OWNER}.SCM_ADM_API_M API ON API.API_ID = BMP.API_ID
                              WHERE NVL(BMP.USE_YN,'Y') = 'Y' AND API.API_URL IS NOT NULL""")
        self.meta = {}
        for mid, sht, btn, url in self.cur.fetchall():
            self.meta.setdefault(mid, []).append({'sheet': sht, 'btn': btn, 'proc': url.upper().replace(f'{OWNER}.', '')})
        self.cur.execute(f"SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OWNER = '{OWNER}' AND OBJECT_TYPE IN ('PROCEDURE','PACKAGE','FUNCTION')")
        self.objects = {r[0].upper(): r[1] for r in self.cur.fetchall()}
        # 테이블 = TO-BE 실제 테이블, 뷰, 시노님만(임시 테이블 GT_* = TEMPORARY 'Y' 제외)
        self.cur.execute(f"SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = '{OWNER}' AND TEMPORARY = 'N'")
        self.tables = {r[0].upper() for r in self.cur.fetchall()}
        self.cur.execute(f"SELECT OBJECT_NAME FROM ALL_OBJECTS WHERE OWNER = '{OWNER}' AND OBJECT_TYPE IN ('VIEW','SYNONYM')")
        self.tables |= {r[0].upper() for r in self.cur.fetchall()}
        self.cur.execute(f"SELECT SCHEDULE_NAME, REPEAT_INTERVAL FROM ALL_SCHEDULER_SCHEDULES WHERE OWNER = '{OWNER}'")
        self.sched = {r[0].upper(): r[1] for r in self.cur.fetchall()}
        self.cur.execute(f"""SELECT JOB_NAME, ENABLED, STATE, REPEAT_INTERVAL, SCHEDULE_NAME, RUN_COUNT, FAILURE_COUNT,
                                    TO_CHAR(LAST_START_DATE,'YYYY-MM-DD HH24:MI'), COMMENTS, JOB_ACTION FROM ALL_SCHEDULER_JOBS WHERE OWNER = '{OWNER}'""")
        self.jobs = []
        for r in self.cur.fetchall():
            self.jobs.append({'job': r[0], 'enabled': 'Y' if str(r[1]).upper() == 'TRUE' else 'N', 'state': r[2] or '', 'ri': r[3] or '', 'sname': r[4] or '',
                              'runs': r[5] or 0, 'failed': r[6] or 0, 'last': r[7] or '', 'comments': (r[8] or '').replace('\n', ' '), 'action': r[9].read() if hasattr(r[9], 'read') else (r[9] or '')})

    def close(self):
        try:
            self.cx.close()
        except Exception:
            pass

    def schedules(self, j):
        """잡 스케줄 → [cal_info]. repeat_interval 이 이름 붙은 스케줄 목록이면 각각 풀어 씀. 없으면 []"""
        out = []
        names = [x.strip().upper() for x in (j['ri'] or j['sname'] or '').split(',') if x.strip()]
        if j['ri'] and 'FREQ=' in j['ri'].upper():
            return [cal_info(j['ri'])]
        for n in names:
            if n in self.sched and self.sched[n]:
                out.append(cal_info(self.sched[n]))
        return out

    def steps(self, j):
        """job_action → [(번호, 이름, [프로시저])]. 프로시저 = TO-BE 객체에 있는 이름만"""
        st = []; cur = None
        for ln in str(j['action']).splitlines():
            m = re.match(r'\s*--\s*step\s*(\d+)\s*:\s*(.*)$', ln, re.I)
            if m:
                cur = [int(m.group(1)), m.group(2).strip(), []]; st.append(cur); continue
            for p in re.findall(r'\b((?:' + OWNER + r'\.)?[A-Z][A-Z0-9_$#]*(?:\.[A-Z][A-Z0-9_$#]*)?)\s*(?:\(|;)', ln.upper()):
                p = p.replace(f'{OWNER}.', ''); base = p.split('.')[0]
                if base in SQL_KW or self.objects.get(base) not in ('PROCEDURE', 'PACKAGE'):  # 함수(FN_NEXT_DAY 등) = 단계 프로시저 아님
                    continue
                if cur is None:
                    cur = [1, '', []]; st.append(cur)
                if p not in cur[2]:
                    cur[2].append(p)
        return st

    def source(self, proc):
        """'PKG.PROC' = 패키지 본문 중 그 프로시저 구간, 'PROC' = 프로시저 본문. 없으면 ''"""
        proc = proc.upper()
        if proc in self._src:
            return self._src[proc]
        pkg, _, name = proc.partition('.')
        txt = ''
        try:
            if name:
                if pkg not in self._pkg:
                    self.cur.execute(f"SELECT TEXT FROM ALL_SOURCE WHERE OWNER = '{OWNER}' AND NAME = :n AND TYPE = 'PACKAGE BODY' ORDER BY LINE", n=pkg)
                    self._pkg[pkg] = ''.join(r[0] or '' for r in self.cur.fetchall())
                body = self._pkg[pkg]
                m = re.search(r'(?is)\b(?:PROCEDURE|FUNCTION)\s+' + re.escape(name) + r'\b', body)
                if m:  # 끝 = 'END <이름>;'(내부 PROCEDURE 선언에서 자르지 않게). 없으면 다음 줄머리 PROCEDURE/FUNCTION
                    en = re.search(r'(?is)\bEND\s+' + re.escape(name) + r'\s*;', body[m.end():])
                    nx = None if en else re.search(r'(?im)^\s*(?:PROCEDURE|FUNCTION)\s+\w+', body[m.end():])
                    txt = body[m.start(): m.end() + (en.end() if en else nx.start() if nx else len(body))]
            else:
                self.cur.execute(f"SELECT TEXT FROM ALL_SOURCE WHERE OWNER = '{OWNER}' AND NAME = :n AND TYPE IN ('PROCEDURE','FUNCTION') ORDER BY LINE", n=pkg)
                txt = ''.join(r[0] or '' for r in self.cur.fetchall())
        except Exception:
            txt = ''
        self._src[proc] = txt
        return txt

    def io(self, proc):
        """TO-BE 본문 기준 쓰기, 읽기 테이블. 본문 없으면 (None, None)"""
        import ops_struct as OS
        if proc in self._io:
            return self._io[proc]
        b = self.source(proc)
        if not b.strip():
            return None, None
        b = re.sub(r'(?s)/\*.*?\*/', ' ', b); b = re.sub(r'--[^\n]*', ' ', b)
        rx_w = r'(?is)\b(?:INSERT\s+(?:/\*.*?\*/\s*)?INTO\s+|UPDATE\s+|MERGE\s+INTO\s+|DELETE\s+(?:FROM\s+)?|TRUNCATE\s+TABLE\s+)(?:\w+\.)?([A-Z][\w$#]*)'
        rx_r = r'(?is)\b(?:FROM|JOIN)\s+(?:\w+\.)?([A-Z][\w$#]*)'
        cur = {m.upper() for m in re.findall(r'(?is)\bCURSOR\s+(\w+)\s+IS', b)}
        real = getattr(self, 'tables', None)
        w = OS.tbl_names(rx_w, b) - cur - set(self.objects)
        r = OS.tbl_names(rx_r, b) - w - cur - set(self.objects) - {'DUAL', 'TABLE'}
        if real is not None:
            w &= real; r &= real
        self._io[proc] = (sorted(w), sorted(r))
        return self._io[proc]


def screen_facts(db, sid):
    """TO-BE 화면 사실: 버튼별 프로시저, 쓰기, 읽기 테이블"""
    f = {'id': sid, 'facts': '', 'sps': set(), 'reads': set(), 'writes': set(), 'buttons': {}}
    rows = db.meta.get(sid, [])
    if rows:
        f['facts'] = 'TO-BE 메뉴 API 배선(SCM_ADM_MNU_BTN_MPG_M, SCM_ADM_API_M)'
    for r in rows:
        f['sps'].add(r['proc']); f['buttons'].setdefault(r['btn'].title(), set()).add(r['proc'])
        w, rd = db.io(r['proc'])
        f['writes'] |= set(w or []); f['reads'] |= set(rd or [])
    return f


def asis_times():
    """AS-IS 잡 실행 SP, 잡 이름 → [{text, hours}]. 시각만 참고용이고 잡 이름, 단계, SP 본문은 매뉴얼에 쓰지 않음"""
    import ops_struct as OS
    sch = {}
    for s in rcsv(os.path.join(BATCH, 'agent_schedules.csv')):
        i = OS.sched_info(s)
        if i['days'] == '해독 불가':
            continue
        sch.setdefault(s['job_name'], []).append({'text': f"{i['days']} {i['every'] or ', '.join(i['times'])}".strip(), 'hours': i['hours']})
    by_sp, by_job = {}, {}
    for st in rcsv(os.path.join(BATCH, 'agent_jobsteps.csv')):
        tms = sch.get(st['job_name']) or []
        if not tms:
            continue
        by_job[re.sub(r'[^A-Z0-9]', '_', st['job_name'].upper())] = tms
        for m in re.findall(r'(?i)\bEXEC(?:UTE)?\s+(?:@\w+\s*=\s*)?([\w.\[\]]+)', st.get('command') or ''):
            lst = by_sp.setdefault(m.split('.')[-1].strip('[]').upper(), [])
            for t in tms:
                if t not in lst:
                    lst.append(t)
    return by_sp, by_job


def clean_desc(t):
    """TO-BE 잡 COMMENTS 중 이관 메모('ORACLE job: JOB.<AS-IS 잡> | schedules(n): <AS-IS 스케줄 이름>')는 설명으로 쓰지 않음(AS-IS 이름, 2026-11-24 사용자 지시)"""
    t = str(t or '').strip()
    return '' if re.match(r'(?i)^ORACLE job\s*:', t) or re.search(r'(?i)\bJOB\.[A-Z]', t) else t


def ref_row(job, on, ref, basis):
    return {'job': job, 'jobOn': on, 'on': '0', 'days': 'AS-IS 참고 ' + ' / '.join(x['text'] for x in ref), 'every': '', 'times': '',
            'hours': ' '.join(str(h) for h in sorted({h for x in ref for h in x['hours']})), 'basis': basis}


def batch_facts(db, mod, mod_procs):
    """TO-BE 배치 행(batch.csv 칸 + basis)과 실행표 행. 반환 (rows, timeline)"""
    try:
        import ssp_batch_flow as SB
    except Exception:
        SB = None
    rx = re.compile(MOD_RX.get(mod, r'^$'), re.I)
    asis_sp, asis_job = asis_times()
    rows, tl, called = [], [], set()

    def grp(p):
        b = p.split('.')[-1]
        return (SB.group_of(b).replace('SSP', mod), SB.ext_of(b)) if SB and b else ('', '')
    for j in db.jobs:
        st = db.steps(j)
        procs = [p for s in st for p in s[2]]
        if not (rx.search(j['job']) or any(rx.search(p) for p in procs) or (set(procs) & mod_procs)):
            continue
        called |= {p.split('.')[-1] for p in procs} | set(procs)
        sc = db.schedules(j)
        if sc:
            text = ' / '.join(x['text'] for x in sc); basis = 'TO-BE 잡'
            for x in sc:
                tl.append({'job': j['job'], 'jobOn': j['enabled'], 'on': '1' if j['enabled'] == 'Y' else '0', 'days': x['days'], 'every': x['every'],
                           'times': ' '.join(x['times']), 'hours': ' '.join(str(h) for h in x['hours']), 'basis': basis})
        else:  # TO-BE 잡에 스케줄 없음 → 같은 이름 AS-IS 잡 또는 같은 프로시저 AS-IS 시각만 참고
            ref = asis_job.get(re.sub(r'[^A-Z0-9]', '_', j['job'].upper())) or next((asis_sp[p.split('.')[-1]] for p in procs if p.split('.')[-1] in asis_sp), None)
            basis = 'TO-BE 잡(시각 = AS-IS 참고)' if ref else 'TO-BE 잡(스케줄 없음)'
            text = ('TO-BE 스케줄 없음. AS-IS 참고 시각: ' + ' / '.join(x['text'] for x in ref)) if ref else 'TO-BE 스케줄 없음(AS-IS 참고 시각 없음)'
            tl.append(ref_row(j['job'], j['enabled'], ref, basis) if ref else {'job': j['job'], 'jobOn': j['enabled'], 'on': '0', 'days': '스케줄 없음', 'every': '', 'times': '', 'hours': '', 'basis': basis})
        for no, name, ps in (st or [(1, '', [])]):
            g, e = grp(ps[0]) if ps else ('', '')
            if re.match(r'(?i)^\s*JOB\.', name or ''):  # 단계 이름이 AS-IS 잡 이름(JOB.LGCE_SCMPROD.X) = TO-BE 프로시저 이름으로
                name = ', '.join(ps) or re.sub(r'(?i)^\s*JOB\.(?:LGCE_\w+\.)?', '', name)
            rows.append({'module': mod, 'job': j['job'], 'enabled': j['enabled'], 'desc': clean_desc(j['comments']), 'schedule': text, 'step': no, 'stepName': name, 'exec': ', '.join(ps),
                         'group': g, 'ext': e, 'lastOutcome': j['state'], 'lastRun': j['last'], 'runs': j['runs'], 'failed': j['failed'], 'basis': basis})
    # TO-BE 프로시저는 있는데 TO-BE 잡이 부르지 않는 배치 → TO-BE 프로시저 이름과 AS-IS 참고 시각만
    for sp, tms in sorted(asis_sp.items()):
        if db.objects.get(sp) == 'PROCEDURE' and rx.search(sp) and sp not in called:
            job = f'(TO-BE 잡 미등록) {sp}'; basis = 'TO-BE 잡 미등록(시각 = AS-IS 참고)'
            g, e = grp(sp)
            rows.append({'module': mod, 'job': job, 'enabled': 'N', 'desc': '', 'schedule': 'TO-BE 잡 미등록. AS-IS 참고 시각: ' + ' / '.join(x['text'] for x in tms), 'step': 1, 'stepName': '', 'exec': sp,
                         'group': g, 'ext': e, 'lastOutcome': '', 'lastRun': '', 'runs': '', 'failed': '', 'basis': basis})
            tl.append(ref_row(job, 'N', tms, basis))
    return rows, tl
