# -*- coding: utf-8 -*-
"""CheckList 서버 확인·자동 기동 (2026-11-19 사용자 지시)
   "CheckList 작업 중 FE, BE 서버가 기동 중이지 않으면 서버를 기동시켜 진행 · 서버가 죽어 있는데 대기만 하면 진행이 안 됨
    · 서버가 살아 있어야 하는데 응답이 없으면 서버 기동 프로세스를 가동"

  python tools/Harness/verify/server_guard.py                  BE 8080 · FE 5173 확인, 응답 없으면 기동 후 응답까지 대기
  python tools/Harness/verify/server_guard.py --ports 8080     지정 포트만
  python tools/Harness/verify/server_guard.py --check          확인만(기동 안 함) · 종료코드 0 = 전부 응답
  python tools/Harness/verify/server_guard.py --selftest       판정 함수 시험

  판정: HTTP 응답이 오면(상태코드 무관) 살아 있음. 연결 거부·시간 초과 = 응답 없음.
        포트는 열려 있는데 응답이 없으면 20초 간격 3회 다시 본 뒤에도 없을 때만 멈춘 것으로 본다(동시 CheckList 부하로 느린 경우 오판 방지).
  기동: VM 메뉴 항목(tools/VibeManager/quick.json · kind terminal · port)의 cmd·cwd 를 그대로 쓴다(BE = gradlew bootRun · FE = fe_start.cmd).
        창 없이 따로 떠서 이 스크립트가 끝나도 계속 돈다. 출력 = Doc/e2e/logs/_server_<port>.log
        포트를 잡고 멈춘 프로세스는 java·node·cmd 일 때만 종료 후 기동. VPN·시스템 프로세스(F5FltSrv 등)는 건드리지 않고 rc 5.
  동시 실행: 포트별 잠금(Doc/e2e/_server_<port>.lock) — 한 실행만 기동하고 나머지는 응답을 기다린다.
  종료코드: 0 = 전부 응답 · 5 = 기동 실패·시간 초과(호출자는 서버 미기동으로 처리)
"""
import argparse, json, os, re, subprocess, sys, time, urllib.error, urllib.request

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
URL = {8080: 'http://localhost:8080/user/login', 5173: 'http://127.0.0.1:5173/'}
LABEL = {8080: 'BE 8080', 5173: 'FE 5173'}
PROTECTED = re.compile(r'^(F5FltSrv|f5fpclientW|BIGIPEdge|svchost|System|lsass|csrss|wininit|services|explorer|Code|vpnagent|vpnui|GlobalProtect|PanGPS|NordVPN|openvpn)', re.I)
KILLABLE = re.compile(r'^(java|javaw|node|cmd)(\.exe)?$', re.I)
NOWIN = 0x08000000  # CREATE_NO_WINDOW


def say(msg):
    print(f'[서버] {time.strftime("%H:%M:%S")} {msg}', flush=True)


def alive(port, timeout=15):
    """HTTP 응답이 오면 True(상태코드 무관)"""
    try:
        urllib.request.urlopen(URL.get(port, f'http://127.0.0.1:{port}/'), timeout=timeout)
        return True
    except urllib.error.HTTPError:
        return True
    except Exception:
        return False


def owner(port):
    """(pid, 이름) — 그 포트를 LISTEN 하는 프로세스 · 없으면 None"""
    try:
        out = subprocess.run(['netstat', '-ano', '-p', 'TCP'], capture_output=True, text=True, timeout=30, creationflags=NOWIN).stdout
    except Exception:
        return None
    for ln in out.splitlines():
        p = ln.split()
        if len(p) >= 5 and p[3].upper() == 'LISTENING' and p[1].rsplit(':', 1)[-1] == str(port):
            pid = int(p[4])
            try:
                t = subprocess.run(['tasklist', '/FI', f'PID eq {pid}', '/FO', 'CSV', '/NH'], capture_output=True, text=True, timeout=20, creationflags=NOWIN).stdout
                name = t.split('","')[0].strip().strip('"') if t.strip().startswith('"') else '?'
            except Exception:
                name = '?'
            return pid, name
    return None


def server_items():
    """quick.json 의 서버 기동 항목 {port: {cmd, cwd, ready}}"""
    out = {}
    try:
        q = json.load(open(os.path.join(ROOT, 'tools', 'VibeManager', 'quick.json'), encoding='utf-8-sig'))
        for g in q.get('groups', []):
            for it in g.get('items', []):
                if it.get('kind') == 'terminal' and str(it.get('port') or '').isdigit() and it.get('cmd'):
                    out[int(it['port'])] = {'cmd': it['cmd'], 'cwd': str(it.get('cwd') or '').replace('${root}', ROOT), 'ready': int(it.get('readyTimeoutSec') or 300), 'name': it.get('name') or it.get('label')}
    except Exception as e:
        say(f'quick.json 읽기 실패: {e}')
    return out


def pid_alive(pid):
    try:
        t = subprocess.run(['tasklist', '/FI', f'PID eq {pid}', '/FO', 'CSV', '/NH'], capture_output=True, text=True, timeout=20, creationflags=NOWIN).stdout
        return f'"{pid}"' in t
    except Exception:
        return True  # 확인 실패를 '죽음' 으로 보지 않는다


def take_lock(port):
    """잠금 획득 True · 다른 살아 있는 실행이 잡고 있으면 False"""
    lk = os.path.join(ROOT, 'Doc', 'e2e', f'_server_{port}.lock'); os.makedirs(os.path.dirname(lk), exist_ok=True)
    for _ in range(2):
        try:
            fd = os.open(lk, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
            with os.fdopen(fd, 'w', encoding='utf-8') as f:
                json.dump({'pid': os.getpid(), 'at': time.strftime('%Y-%m-%d %H:%M:%S')}, f)
            return True
        except FileExistsError:
            try:
                pid = int(json.load(open(lk, encoding='utf-8')).get('pid') or 0)
            except Exception:
                pid = 0
            if pid and pid_alive(pid):
                return False
            try: os.remove(lk)
            except OSError: pass
    return False


def drop_lock(port):
    try: os.remove(os.path.join(ROOT, 'Doc', 'e2e', f'_server_{port}.lock'))
    except OSError: pass


def wait_up(port, sec):
    t0 = time.time()
    while time.time() - t0 < sec:
        if alive(port, timeout=10):
            return True
        time.sleep(5)
    return False


def start(port, it):
    log = os.path.join(ROOT, 'Doc', 'e2e', 'logs', f'_server_{port}.log'); os.makedirs(os.path.dirname(log), exist_ok=True)
    # 2026-11-20 정정: DETACHED_PROCESS 를 빼고 CREATE_NEW_PROCESS_GROUP · 창 없음만 쓴다.
    #   DETACHED_PROCESS 로 띄우면 cmd 출력은 로그에 남지만 그 아래 콘솔 프로그램(vite node, gradle java) 출력이 버려졌다
    #   (실측: _server_5173.log, _server_8080.log 가 기동 머리줄 1줄뿐 · 같은 명령 재현에서 DETACHED+NOWIN = node 출력 없음, NOWIN 만 = node 출력 기록).
    #   CREATE_NO_WINDOW 는 숨은 콘솔을 따로 주므로 이 스크립트가 끝나거나 창을 닫아도 서버는 계속 돈다
    flags = 0x00000200 | NOWIN  # CREATE_NEW_PROCESS_GROUP · 창 없음
    with open(log, 'a', encoding='utf-8') as f:
        f.write(f'\n==== {time.strftime("%Y-%m-%d %H:%M:%S")} server_guard 기동 (pid {os.getpid()}) : {it["cmd"]}\n')
    subprocess.Popen(f'cmd /d /c "{it["cmd"]} >> "{log}" 2>&1"', cwd=it['cwd'], creationflags=flags, stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, close_fds=True)
    return log


def ensure(port, items, check_only=False):
    lab = LABEL.get(port, f'포트 {port}')
    if alive(port):
        return True
    occ = owner(port)
    if occ:  # 포트는 열려 있는데 응답 없음 — 느린 응답일 수 있어 다시 본다
        for k in range(3):
            say(f'{lab} 포트 열림({occ[1]} {occ[0]}) · 응답 없음 → 20초 뒤 다시 확인 {k + 1}/3')
            time.sleep(20)
            if alive(port, timeout=30):
                say(f'{lab} 응답 확인'); return True
    if check_only:
        say(f'{lab} 응답 없음'); return False
    it = items.get(port)
    if not it:
        say(f'{lab} 기동 항목(quick.json kind terminal · port {port}) 없음 → 기동 불가'); return False
    if not take_lock(port):
        say(f'{lab} 다른 CheckList 가 기동 중 → 응답까지 대기(최대 {it["ready"] + 60}초)')
        ok = wait_up(port, it['ready'] + 60); say(f'{lab} {"응답 확인" if ok else "대기 시간 초과"}'); return ok
    try:
        if alive(port):
            return True
        occ = owner(port)
        if occ:
            if PROTECTED.match(occ[1]) or not KILLABLE.match(occ[1]):
                say(f'{lab} 포트 점유 {occ[1]}({occ[0]}) 는 종료 대상 아님(VPN·시스템·예상 밖 프로세스) → 직접 확인 필요'); return False
            say(f'{lab} 응답 없는 {occ[1]}({occ[0]}) 종료 후 다시 기동')
            subprocess.run(['taskkill', '/PID', str(occ[0]), '/T', '/F'], capture_output=True, timeout=60, creationflags=NOWIN)
            for _ in range(20):
                if not owner(port): break
                time.sleep(1)
        log = start(port, it)
        say(f'{lab} 미기동 → {it["name"]} 기동({it["cmd"]}) · 출력 {os.path.relpath(log, ROOT)} · 응답까지 최대 {it["ready"]}초 대기')
        t0 = time.time(); ok = wait_up(port, it['ready'])
        say(f'{lab} {"기동 완료" if ok else "기동 시간 초과"} · {round(time.time() - t0)}초')
        return ok
    finally:
        drop_lock(port)


def selftest():
    bad = []
    if alive(1, timeout=2): bad.append('닫힌 포트를 살아 있다고 판정')
    it = server_items()
    if 8080 not in it or 5173 not in it: bad.append(f'quick.json 서버 항목 못 찾음: {sorted(it)}')
    if not PROTECTED.match('F5FltSrv.exe') or KILLABLE.match('F5FltSrv.exe'): bad.append('보호 프로세스 판정 오류')
    if not KILLABLE.match('java.exe') or not KILLABLE.match('node.exe'): bad.append('종료 대상 판정 오류')
    return bad


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--ports', default='8080,5173')
    ap.add_argument('--check', action='store_true')
    ap.add_argument('--selftest', action='store_true')
    a = ap.parse_args()
    if a.selftest:
        b = selftest(); print('selftest', 'OK' if not b else 'FAIL', *b, sep='\n'); return 1 if b else 0
    if os.environ.get('VERIFY_SERVER_GUARD', '').lower() == 'off':
        return 0
    items = server_items(); ports = [int(x) for x in a.ports.split(',') if x.strip().isdigit()]
    res = {pt: ensure(pt, items, a.check) for pt in ports}
    if all(res.values()):
        return 0
    say('응답 없는 서버: ' + ', '.join(LABEL.get(pt, str(pt)) for pt, v in res.items() if not v))
    return 5


if __name__ == '__main__':
    sys.exit(main())
