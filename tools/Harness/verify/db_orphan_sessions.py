# -*- coding: utf-8 -*-
"""검증 실행이 사내 Oracle 에 남긴 장시간 세션 찾기·종료 (2026-11-12 T250)

  사고: 2026-11-12 03:31~03:38 SCP0111 CheckList 의 저장 시험 5건이 PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI 안에서 끝나지 않았다.
        화면 테스트는 시간 초과로 끝났지만 DB 실행은 취소되지 않아(BE 에 SQL 실행 시간 제한 없음 — nscm-be application.yml) 09:37 사용자 지적 때까지
        약 6시간 동안 세션 5개가 SCP_ANL_PSI_INTEGRATION 행 잠금을 잡고 있었다. 그 뒤 화면의 복원·검사도 이 잠금에 걸릴 수 있다.

  python tools/Harness/verify/db_orphan_sessions.py <MENU_ID>            목록만(종료하지 않음) → Doc/verify/<ID>/db_orphan_sessions.csv
  python tools/Harness/verify/db_orphan_sessions.py <MENU_ID> --kill     종료 대상만 종료하고 잔여·잠금을 다시 잰다
  python tools/Harness/verify/db_orphan_sessions.py --all                화면 구분 없이 이 PC 에서 나간 장시간 세션 목록만(종료 불가)
  python tools/Harness/verify/db_orphan_sessions.py --watch              상시 감시(사용자 상시 지시 2026-11-12): 이 PC 에서 나간 DB 실행이
                                                                          5분 이상 = 알림 줄 '[DB 5분 경고]' · 30분 이상 = 알림 줄 '[DB 30분 종료]' + 종료. 화면 구분 없음 · 60초 간격(--interval)
                                                                          기록 Doc/verify/_db_watch.log (알림·종료만 · 한 세션당 경고 1회)
  python tools/Harness/verify/db_orphan_sessions.py --selftest           선별 규칙 변이 입증

  종료 대상(모두 만족할 때만 · 하나라도 아니면 목록에 '제외 사유' 를 적고 건드리지 않는다):
    ① 접속 PC = 이 PC(v$session.machine 의 마지막 마디 = hostname)   — 다른 사람 PC 세션은 절대 건드리지 않는다
    ② 접속 계정 = BE 앱 계정(기본 SCMP_APP · --user)               — 도구·DBeaver(SCM_MGR·system) 세션 제외
    ③ 상태 ACTIVE 이고 같은 호출이 --min-sec(기본 1800초 = 가장 긴 테스트 제한 20분 초과) 이상 진행 중
    ④ 진입 프로시저의 PKG 가 이 화면에 배선된 PKG(SCM_ADM_MNU_BTN_MPG_M → SCM_ADM_API_M.API_URL)
  종료 = ALTER SYSTEM KILL SESSION(열린 트랜잭션은 Oracle 이 롤백). 막고 있는 세션을 먼저 종료한다.
  종료코드: 0 남은 것 없음(또는 전부 종료) · 2 종료 대상이 남음(목록만 모드 포함) · 3 측정 실패(접속·권한)
"""
import csv, datetime, getpass, os, socket, sys, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))


def _oev(type_, **fields):
    """2026-11-19 오케스트라 P1: DB 경고·종료 사건 기록(.vibe/orch/events.jsonl). 기록 실패·모듈 없음은 감시를 멈추지 않는다"""
    try:
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
        import orch_event
        orch_event.emit(type_, **{k: (v if isinstance(v, (int, float, bool, str)) or v is None else str(v)) for k, v in fields.items()})
    except Exception:
        pass
COLS = ['sid', 'serial', 'username', 'machine', 'status', 'last_call_et', 'sql_exec_start', 'event', 'blocking_session', 'pkg', 'proc', 'tx_open', 'osuser', 'decision', 'why']


def host_tail(machine):
    """'DOMAIN\\LEE-03' · 'lee-03.corp' → 'LEE-03'"""
    m = (machine or '').replace('/', '\\').split('\\')[-1]
    return m.split('.')[0].upper()


ME = getpass.getuser()


def not_mine(s, host, me=None):
    """이 세션이 '내가(이 PC 의 이 윈도우 사용자가) 실행한 것' 이 아니면 사유, 맞으면 ''.
    2026-11-12 사용자 지시 "감시 프로세스는 제가 수행한 것에 대해서만 동작 — 놓치면 안 됨": PC 이름과 OS 사용자가 모두 일치해야 한다.
    둘 중 하나라도 다르거나 읽지 못하면(빈 값) 남의 것으로 본다 — 알리지도 종료하지도 않는다."""
    me = (ME if me is None else me)
    if not s.get('machine') or host_tail(s.get('machine')) != host.upper():
        return f"다른 PC({s.get('machine')})"
    ou = host_tail(s.get('osuser'))
    if not ou or ou != (me or '').upper():
        return f"다른 OS 사용자({s.get('osuser')})"
    return ''


def decide(s, host, pkgs, app_user, min_sec):
    """세션 1행 → ('KILL'|'KEEP', 사유). pkgs = 화면 PKG 집합(대문자) 또는 None(--all = 종료 불가)"""
    nm = not_mine(s, host)
    if nm:
        return 'KEEP', nm
    if (s.get('username') or '').upper() != app_user.upper():
        return 'KEEP', f"앱 계정 아님({s.get('username')})"
    if (s.get('status') or '').upper() != 'ACTIVE':
        return 'KEEP', f"실행 중 아님({s.get('status')})"
    if int(s.get('last_call_et') or 0) < min_sec:
        return 'KEEP', f"진행 {s.get('last_call_et')}초 < 기준 {min_sec}초"
    if pkgs is None:
        return 'KEEP', '화면 미지정(--all) — 목록만'
    if not s.get('pkg'):
        return 'KEEP', '진입 프로시저 확인 불가'
    if s['pkg'].upper() not in pkgs:
        return 'KEEP', f"다른 화면 PKG({s['pkg']})"
    return 'KILL', f"이 화면 PKG 호출이 {s.get('last_call_et')}초째 진행"


def decide_watch(s, host, warn_sec=300, kill_sec=1800):
    """상시 감시 판정(사용자 상시 지시 2026-11-12 — DB 작업 5분 이상 = 알림 · 30분 이상 = 알림 + 종료). 화면·계정 구분 없이 이 PC 에서 나간 실행 중 세션만.
    다른 PC 세션은 건드리지 않는다(알리지도 않는다 — 남의 작업). 반환 ('KILL'|'WARN'|'KEEP', 사유)"""
    nm = not_mine(s, host)
    if nm:
        return 'KEEP', nm
    if (s.get('status') or '').upper() != 'ACTIVE':
        return 'KEEP', f"실행 중 아님({s.get('status')})"
    et = int(s.get('last_call_et') or 0)
    if et >= kill_sec:
        return 'KILL', f"{et}초째 실행(한도 {kill_sec}초)"
    if et >= warn_sec:
        return 'WARN', f"{et}초째 실행(경고 기준 {warn_sec}초)"
    return 'KEEP', f"진행 {et}초"


def kill_order(rows):
    """막고 있는 세션(다른 대상의 blocking_session) 먼저"""
    blockers = {str(r.get('blocking_session')) for r in rows if r.get('blocking_session')}
    return sorted(rows, key=lambda r: 0 if str(r['sid']) in blockers else 1)


def selftest():
    base = dict(sid=1, serial=2, username='SCMP_APP', machine='LEE-03', status='ACTIVE', last_call_et=21000, pkg='PKG_SCP0111', blocking_session=None, osuser=ME)
    P = {'PKG_SCP0111'}
    t = []
    t.append(('정상 대상 = KILL', decide(base, 'lee-03', P, 'SCMP_APP', 1800)[0] == 'KILL'))
    t.append(('다른 PC = KEEP', decide(dict(base, machine='DESKTOP-FD2Q1OT'), 'LEE-03', P, 'SCMP_APP', 1800)[0] == 'KEEP'))
    t.append(('도메인 붙은 같은 PC = KILL', decide(dict(base, machine='CORP\\LEE-03'), 'LEE-03', P, 'SCMP_APP', 1800)[0] == 'KILL'))
    t.append(('도구 계정 = KEEP', decide(dict(base, username='SCM_MGR'), 'LEE-03', P, 'SCMP_APP', 1800)[0] == 'KEEP'))
    t.append(('기준 시간 미만 = KEEP', decide(dict(base, last_call_et=1799), 'LEE-03', P, 'SCMP_APP', 1800)[0] == 'KEEP'))
    t.append(('쉬는 세션 = KEEP', decide(dict(base, status='INACTIVE'), 'LEE-03', P, 'SCMP_APP', 1800)[0] == 'KEEP'))
    t.append(('다른 화면 PKG = KEEP', decide(dict(base, pkg='PKG_SSP0015'), 'LEE-03', P, 'SCMP_APP', 1800)[0] == 'KEEP'))
    t.append(('프로시저 모름 = KEEP', decide(dict(base, pkg=None), 'LEE-03', P, 'SCMP_APP', 1800)[0] == 'KEEP'))
    t.append(('화면 미지정 = KEEP', decide(base, 'LEE-03', None, 'SCMP_APP', 1800)[0] == 'KEEP'))
    t.append(('감시: 4분 59초 = KEEP', decide_watch(dict(base, last_call_et=299), 'LEE-03')[0] == 'KEEP'))
    t.append(('감시: 5분 = WARN', decide_watch(dict(base, last_call_et=300), 'LEE-03')[0] == 'WARN'))
    t.append(('감시: 29분 59초 = WARN', decide_watch(dict(base, last_call_et=1799), 'LEE-03')[0] == 'WARN'))
    t.append(('감시: 30분 = KILL', decide_watch(dict(base, last_call_et=1800), 'LEE-03')[0] == 'KILL'))
    t.append(('감시: 도구 계정(SCM_MGR)도 30분이면 KILL', decide_watch(dict(base, username='SCM_MGR', pkg=None, last_call_et=1900), 'LEE-03')[0] == 'KILL'))
    t.append(('감시: 다른 PC 는 5시간이어도 KEEP', decide_watch(dict(base, machine='DESKTOP-FD2Q1OT', last_call_et=18000), 'LEE-03')[0] == 'KEEP'))
    t.append(('감시: 쉬는 세션 = KEEP', decide_watch(dict(base, status='INACTIVE', last_call_et=99999), 'LEE-03')[0] == 'KEEP'))
    t.append(('같은 PC 라도 다른 OS 사용자 = KEEP(화면 정리)', decide(dict(base, osuser='someone_else'), 'LEE-03', P, 'SCMP_APP', 1800)[0] == 'KEEP'))
    t.append(('감시: 같은 PC 라도 다른 OS 사용자는 5시간이어도 KEEP', decide_watch(dict(base, osuser='someone_else', last_call_et=18000), 'LEE-03')[0] == 'KEEP'))
    t.append(('감시: OS 사용자를 못 읽으면 KEEP', decide_watch(dict(base, osuser=None, last_call_et=18000), 'LEE-03')[0] == 'KEEP'))
    t.append(('감시: PC 이름을 못 읽으면 KEEP', decide_watch(dict(base, machine=None, last_call_et=18000), 'LEE-03')[0] == 'KEEP'))
    t.append(('감시: 도메인 붙은 내 OS 사용자 = 내 것', decide_watch(dict(base, osuser='CORP' + chr(92) + ME, last_call_et=1800), 'LEE-03')[0] == 'KILL'))
    o = kill_order([dict(sid=858, blocking_session=860), dict(sid=860, blocking_session=None), dict(sid=299, blocking_session=860)])
    t.append(('막는 세션 먼저', o[0]['sid'] == 860))
    bad = [n for n, ok in t if not ok]
    for n, ok in t:
        print(('PASS ' if ok else 'FAIL ') + n)
    print(f'selftest {len(t) - len(bad)}/{len(t)}')
    return 1 if bad else 0


def fetch(cur, min_et=600):
    cur.execute("""
        select s.sid, s.serial#, s.username, s.machine, s.status, s.last_call_et,
               to_char(s.sql_exec_start,'YYYY-MM-DD HH24:MI:SS'), s.event, s.blocking_session,
               p.object_name, p.procedure_name, case when s.taddr is null then 0 else 1 end, s.osuser
          from v$session s
          left join dba_procedures p on p.object_id = s.plsql_entry_object_id and p.subprogram_id = s.plsql_entry_subprogram_id
         where s.type = 'USER' and s.username is not null
           and (s.status = 'ACTIVE' and s.last_call_et >= :m or s.blocking_session is not null)
           and s.sid <> sys_context('userenv','sid')""", m=min_et)
    keys = COLS[:13]
    return [dict(zip(keys, r)) for r in cur.fetchall()]


def kill_one(dbconn, r):
    """세션 1개 종료 — 문장마다 새 접속. 반환 (성공 여부, 메시지)"""
    try:
        c2 = dbconn.connect('tobe', write=True); c2.call_timeout = 20000
        c2.cursor().execute(f"alter system kill session '{int(r['sid'])},{int(r['serial'])}'")
        return True, 'ok'
    except Exception as e:
        msg = ' '.join(str(e).split())
        return ('ORA-00031' in msg or 'ORA-00030' in msg), msg[:120]


def sql_of(cur, sid):
    try:
        cur.execute("select substr(q.sql_text, 1, 160) from v$session s join v$sqlarea q on q.sql_id = s.sql_id where s.sid = :1", [sid])
        r = cur.fetchone()
        return ' '.join((r[0] if r else '') .split())
    except Exception:
        return ''


PIDF = os.path.join(ROOT, 'Doc', 'verify', '_db_watch.pid')


def watcher_alive():
    """감시 프로세스가 살아 있나 — pid 파일의 프로세스가 python 이고 명령줄에 --watch 가 있을 때만 참"""
    try:
        pid = int(open(PIDF, encoding='utf-8').read().strip())
    except Exception:
        return 0
    try:
        import subprocess
        o = subprocess.run(['powershell', '-NoProfile', '-Command', f"(Get-CimInstance Win32_Process -Filter 'ProcessId={pid}').CommandLine"],
                           capture_output=True, text=True, timeout=30).stdout
        if 'db_orphan_sessions' in o and '--watch' in o:
            return pid
        if o.strip():
            return 0  # 그 pid 는 살아 있지만 감시가 아니다(pid 재사용)
    except Exception:
        pass
    # 2026-11-12 13:57 실측: PC 부하로 명령줄 조회(CIM)가 '호출이 취소됨' 으로 실패 → 죽은 것으로 보고 감시를 하나 더 띄웠다(pid 17892 + 32092 중복).
    #   명령줄을 못 읽었으면 '없다' 가 아니다 — 프로세스 목록(tasklist)에 그 pid 의 python 이 있으면 살아 있는 것으로 본다(중복 기동 방지 쪽으로 판정)
    try:
        import subprocess
        o2 = subprocess.run(['tasklist', '/FI', f'PID eq {pid}', '/FO', 'CSV', '/NH'], capture_output=True, text=True, timeout=30).stdout
        return pid if (f'"{pid}"' in o2 and 'python' in o2.lower()) else 0
    except Exception:
        return pid  # 둘 다 못 읽음 — 새로 띄우지 않는다


def ensure_watch():
    """감시가 없으면 독립 프로세스로 띄운다(부모가 끝나도 계속 돈다). 검증 체인 시작 때 호출 — VM 만으로 실행해도 감시가 붙도록"""
    pid = watcher_alive()
    if pid:
        print(f'[DB 감시] 실행 중(pid {pid})'); return 0
    import subprocess
    flags = getattr(subprocess, 'DETACHED_PROCESS', 0) | getattr(subprocess, 'CREATE_NEW_PROCESS_GROUP', 0) | getattr(subprocess, 'CREATE_NO_WINDOW', 0)
    p = subprocess.Popen([sys.executable, os.path.abspath(__file__), '--watch'], cwd=ROOT, creationflags=flags, close_fds=True,
                         stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    print(f'[DB 감시] 시작(pid {p.pid}) — 5분 이상 경고 · 30분 이상 종료 · 기록 Doc/verify/_db_watch.log'); return 0


def watch(a):
    """상시 감시 — 60초마다 조회. 알림 줄은 표준 출력(호출한 쪽이 사용자에게 전달)과 Doc/verify/_db_watch.log 에 남긴다"""
    import dbconn
    interval = int(a[a.index('--interval') + 1]) if '--interval' in a else 60
    warn_sec = int(a[a.index('--warn-sec') + 1]) if '--warn-sec' in a else 300
    kill_sec = int(a[a.index('--kill-sec') + 1]) if '--kill-sec' in a else 1800
    once = '--once' in a
    host = socket.gethostname()
    logp = os.path.join(ROOT, 'Doc', 'verify', '_db_watch.log')
    warned = set(); fails = 0

    def say(line):
        print(line, flush=True)
        try:
            with open(logp, 'a', encoding='utf-8') as f:
                print(line, file=f)
        except Exception:
            pass
    try:
        with open(PIDF, 'w', encoding='utf-8') as f:
            f.write(str(os.getpid()))
    except Exception:
        pass
    say(f"[DB 감시 시작] {datetime.datetime.now():%Y-%m-%d %H:%M:%S} 대상 = 이 PC {host} 의 OS 사용자 {ME} 가 실행한 세션만 · 경고 {warn_sec}초 · 종료 {kill_sec}초 · 간격 {interval}초")
    while True:
        try:
            cx = dbconn.connect('tobe'); cx.call_timeout = 30000; cur = cx.cursor()
            cur.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); now = cur.fetchone()[0]
            rows = fetch(cur, warn_sec)
            for r in rows:
                r['decision'], r['why'] = decide_watch(r, host, warn_sec, kill_sec)
            for r in kill_order([x for x in rows if x['decision'] == 'KILL']):
                desc = f"sid={r['sid']},{r['serial']} {r['username']} {r['pkg'] or '-'}.{r['proc'] or '-'} {r['last_call_et']}초 시작 {r['sql_exec_start']} 대기={r['event']} SQL={sql_of(cur, r['sid'])}"
                ok, msg = kill_one(dbconn, r)
                say(f"[DB 30분 종료] {now} {desc} → {'종료함' if ok else '종료 실패: ' + msg}")
                _oev('db.kill', sid=r['sid'], serial=r['serial'], username=r['username'], pkg=r['pkg'], proc=r['proc'], sec_run=r['last_call_et'], wait_event=r['event'], killed=bool(ok), msg=str(msg or '')[:200])
            for r in rows:
                key = (r['sid'], r['serial'], r['sql_exec_start'])
                if r['decision'] == 'WARN' and key not in warned:
                    warned.add(key)
                    _oev('db.warn', sid=r['sid'], serial=r['serial'], username=r['username'], pkg=r['pkg'], proc=r['proc'], sec_run=r['last_call_et'], wait_event=r['event'], blocking_session=r['blocking_session'])
                    say(f"[DB 5분 경고] {now} sid={r['sid']},{r['serial']} {r['username']} {r['pkg'] or '-'}.{r['proc'] or '-'} {r['last_call_et']}초째 실행 시작 {r['sql_exec_start']} 대기={r['event']} 막는세션={r['blocking_session'] or '-'} SQL={sql_of(cur, r['sid'])}")
            cx.close(); fails = 0
        except Exception as e:
            fails += 1
            if fails in (1, 10) or fails % 60 == 0:
                say(f"[DB 감시 오류] {datetime.datetime.now():%Y-%m-%d %H:%M:%S} 조회 실패 {fails}회 연속(미측정): {str(e)[:120]}")
        if once:
            return 0
        time.sleep(interval)


def main():
    a = sys.argv[1:]
    try:
        sys.stdout.reconfigure(errors='replace')  # run-e2e.cmd(cp949 명령창)에서 '·'·'—' 출력이 예외로 끝나지 않게
    except Exception:
        pass
    if '--selftest' in a:
        return selftest()
    if '--ensure-watch' in a:
        return ensure_watch()
    if '--watch' in a:
        return watch(a)
    kill = '--kill' in a
    allm = '--all' in a
    app_user = a[a.index('--user') + 1] if '--user' in a else 'SCMP_APP'
    min_sec = int(a[a.index('--min-sec') + 1]) if '--min-sec' in a else 1800
    ids = [x for x in a if not x.startswith('--') and x.replace('_', '').isalnum() and not x.isdigit() and x != app_user]
    if not allm and not ids:
        print(__doc__); return 3
    mid = None if allm else ids[0].upper()
    if allm and kill:
        print('[ERROR] --all 은 목록만 — 종료는 화면을 지정해야 한다'); return 3
    host = socket.gethostname()
    try:
        import dbconn
        cx = dbconn.connect('tobe', write=kill)
        cur = cx.cursor()
        cur.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); now = cur.fetchone()[0]
        pkgs = None
        if mid:
            cur.execute("SELECT DISTINCT A.API_URL FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID = B.API_ID WHERE B.MNU_ID = :1", [mid])
            pkgs = {str(r[0]).split('.')[0].upper() for r in cur.fetchall() if r[0] and '.' in str(r[0])}
            if not pkgs:
                print(f'[ERROR] {mid}: 화면에 배선된 PKG 0건(SCM_ADM_MNU_BTN_MPG_M) — 종료 대상을 정할 수 없음(미측정)'); return 3
        rows = fetch(cur)
    except Exception as e:
        print(f'[ERROR] 장시간 세션 조회 실패(미측정): {str(e)[:200]}'); return 3
    for r in rows:
        r['decision'], r['why'] = decide(r, host, pkgs, app_user, min_sec)
    tgt = [r for r in rows if r['decision'] == 'KILL']
    tag = mid or 'ALL'
    print(f"[실측 {now}] {tag}: 이 PC={host} · 화면 PKG={','.join(sorted(pkgs)) if pkgs else '-'} · 10분 이상 실행 중이거나 잠금 대기인 세션 {len(rows)}개 · 종료 대상 {len(tgt)}개(기준 {min_sec}초)")
    for r in rows:
        print(f"  {r['decision']} sid={r['sid']},{r['serial']} {r['username']}@{r['machine']} {r['last_call_et']}초 {r['pkg'] or '-'}.{r['proc'] or '-'} 대기={r['event']} 막는세션={r['blocking_session'] or '-'} 트랜잭션={'열림' if r['tx_open'] else '없음'} — {r['why']}")
    left = len(tgt)
    if kill and tgt:
        for r in kill_order(tgt):
            try:
                c2 = dbconn.connect('tobe', write=True); c2.call_timeout = 20000  # 문장마다 새 접속 — 종료 대기가 길면 접속이 끊긴다(11-12 09:36 실측 DPY-4011)
                c2.cursor().execute(f"alter system kill session '{int(r['sid'])},{int(r['serial'])}'")
                r['decision'] = 'KILLED'
                print(f"  종료 sid={r['sid']},{r['serial']}")
            except Exception as e:
                msg = str(e).replace('\n', ' ')
                if 'ORA-00031' in msg or 'ORA-00030' in msg:   # 종료 표시됨 / 이미 없음
                    r['decision'] = 'KILLED'
                    print(f"  종료 sid={r['sid']},{r['serial']} ({msg[:60]})")
                else:
                    r['why'] += f' · 종료 실패: {msg[:100]}'
                    print(f"  [ERROR] 종료 실패 sid={r['sid']},{r['serial']}: {msg[:120]}")
        left = -1
        for _ in range(6):
            time.sleep(5)
            try:
                c3 = dbconn.connect('tobe'); k = c3.cursor()
                pairs = ','.join(f"({int(r['sid'])},{int(r['serial'])})" for r in tgt)
                k.execute(f"select count(*) from v$session where (sid, serial#) in ({pairs}) and status <> 'KILLED'")
                left = k.fetchone()[0]
                k.execute("select to_char(sysdate,'HH24:MI:SS') from dual"); t2 = k.fetchone()[0]
                c3.close()
            except Exception as e:
                print(f'  [ERROR] 잔여 확인 실패(미측정): {str(e)[:120]}'); left = -1; break
            if left == 0:
                break
        print(f"  잔여 확인 {t2 if left >= 0 else '-'}: 종료 대상 중 살아 있는 세션 {left if left >= 0 else '미측정'}개")
    if mid:
        out = os.path.join(ROOT, 'Doc', 'verify', mid, 'db_orphan_sessions.csv')
        if os.path.isdir(os.path.dirname(out)):
            new = not os.path.exists(out)
            with open(out, 'a', encoding='utf-8-sig', newline='') as f:
                w = csv.writer(f)
                if new:
                    w.writerow(['at'] + COLS)
                for r in rows:
                    w.writerow([now] + [r.get(c, '') for c in COLS])
            if rows:
                print(f'  → {os.path.relpath(out, ROOT)}')
    if left < 0:
        return 3
    return 2 if left else 0


if __name__ == '__main__':
    sys.exit(main())
