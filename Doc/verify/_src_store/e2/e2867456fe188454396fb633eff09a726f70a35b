# -*- coding: utf-8 -*-
"""CheckList 실행 중 AS-IS 런처 자동 구동 (사용자 2026-11-13: "VM CHECKLIST 실행 시 AS-IS 실구동 런처 자동구동해서 필요한 데이터 취합")

  python tools/Harness/verify/asis_live_auto.py <ID> [--mode auto|always|off] [--max-age-hours 24]
동작
  1) 대상 아님이면 건너뜀: FP 화면 전체 · Material 필수 4개 · tools/AsisLive/asis_live_batch.py EXCLUDED(소스 없음·미사용 예정 — 사용자 결정 11-12/11-13)
  2) auto = 최근 실측(Doc/asislive/<ID>/latest.json → run.json status OK)이 max-age 안에 있으면 그것을 쓰고 다시 띄우지 않는다 · always = 매번 · off = 안 함
  3) 로컬 AS-IS 웹 서비스(IIS Express 8086)가 꺼져 있으면 tools/AsisLocal/asis_iis.cmd 로 띄우고 포트가 열릴 때까지 기다린다(이미 떠 있으면 건드리지 않는다 · 끝나도 끄지 않는다)
  4) 런처 접속 주소(ClientConfig.xml)가 http://localhost:8086/ 가 아니면 실행하지 않는다(재빌드로 원본 서버 주소로 되돌아간 상태 — 원본 서버 접속 방지)
  5) tools/AsisLive/asis_live_run.py <ID> 실행(다른 실측과는 그 도구의 잠금으로 순서를 기다린다 · 10분 넘으면 미측정)
환경변수 VERIFY_ASIS_LIVE(auto|always|off) 가 --mode 기본값. 실패해도 CheckList 체인은 계속한다(실측 없음 = 미측정으로 남음).
종료코드: 0 실측 있음(새로 실행 또는 최근 실측 사용) · 3 미측정(대상 아님·환경 미비·실행 실패) · 2 인자 오류
"""
import argparse, datetime as dt, json, os, re, socket, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
PORT = 8086; BASE_URL = 'http://localhost:8086/'
MATERIAL4 = {'FP02510', 'FP02800N', 'SCP0008', 'SCP0038'}
for _s in (sys.stdout, sys.stderr):
    try: _s.reconfigure(encoding='utf-8', errors='replace')
    except Exception: pass


def port_open(port):
    with socket.socket() as s:
        s.settimeout(2)
        return s.connect_ex(('127.0.0.1', port)) == 0


def excluded(mid):
    if mid.startswith('FP'): return 'FP 화면은 AS-IS 실구동 대상에서 제외(사용자 결정 11-13)'
    if mid in MATERIAL4: return 'Material 필수 화면 4개는 제외(사용자 결정 11-13)'
    try:
        src = open(P('tools', 'AsisLive', 'asis_live_batch.py'), encoding='utf-8').read()
        m = re.search(r'^EXCLUDED\s*=\s*\{([^}]*)\}', src, re.M)
        if m and mid in set(re.findall(r'"([A-Z0-9_]+)"', m.group(1))): return '제외 화면(소스 없음·미사용 예정 — 사용자 결정 11-12 · asis_live_batch.EXCLUDED)'
    except Exception:
        pass
    return ''


def latest_ok(mid, max_age_h):
    """최근 실측이 쓸 만하면 (run_dir, 시각) — 아니면 (None, 사유)"""
    try: lt = json.load(open(P('Doc', 'asislive', mid, 'latest.json'), encoding='utf-8'))
    except Exception: return None, '실측 없음'
    rd = lt.get('run_dir') or lt.get('dir') or ''
    rd = rd if os.path.isabs(rd) else P(*re.split(r'[\\/]', rd)) if rd else ''
    try: run = json.load(open(os.path.join(rd, 'run.json'), encoding='utf-8'))
    except Exception: return None, 'run.json 없음'
    if str(run.get('status')) != 'OK': return None, f"직전 실측 상태 {run.get('status')}"
    try: at = dt.datetime.strptime(str(run.get('started'))[:19], '%Y-%m-%d %H:%M:%S')
    except Exception: return None, '실측 시각 없음'
    age = (dt.datetime.now() - at).total_seconds() / 3600
    # 2026-11-20 사용자 지시: 나이(24시간) 대신 원장 지문 — 원장이 같으면 오래돼도 재사용(asis_fp.py). VERIFY_ASIS_LIVE_MAX_AGE_H 를 따로 지정했을 때만 나이도 본다
    if os.environ.get('VERIFY_ASIS_LIVE_MAX_AGE_H') and age > max_age_h: return None, f'직전 실측 {age:.1f}시간 전(지정 기준 {max_age_h}시간)'
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); import asis_fp
    ok, why = asis_fp.same(mid, 'basic')
    if not ok: return None, why
    return rd, f"{str(run.get('started'))[:16]} · {age:.1f}시간 전 · {why}"


def client_url():
    f = P('GSCM', '02.Launcher', 'GSCM.Launcher', 'bin', 'Debug', 'ClientConfig.xml')
    try: x = re.sub(r'<!--[\s\S]*?-->', '', open(f, encoding='utf-8', errors='replace').read())
    except Exception as e: return None, f'{f} 읽기 실패: {e}'
    for m in re.finditer(r'<address\b[^>]*>', x, re.I):
        nm = re.search(r'\bname\s*=\s*"([^"]*)"', m.group(0), re.I); bu = re.search(r'\bbaseUrl\s*=\s*"([^"]*)"', m.group(0), re.I)
        if nm and bu and nm.group(1) == 'GSCM': return bu.group(1), f
    return None, f


def menu_slow(limit=25):
    """런처를 띄우기 전에 메뉴 목록 SP 응답 시간을 잰다. 런처의 웹 서비스는 이 SP 가 30초를 넘으면 0행으로 끊고, 그러면 메뉴가 비어 화면을 열 수 없다
    (2026-11-13 14:29~14:36 실측: 평소 6~7초 → AS-IS DB 부하로 30초 초과 4회 연속 · 실측 4회 전부 '메뉴 목록이 비어 있음').
    반환: '' = 정상(또는 잴 수 없음 — 그대로 진행) · 문자열 = 느려서 띄우지 않는 사유. 제한 시간에 서버 쪽 실행도 함께 취소된다(남는 세션 없음)"""
    try:
        import winreg
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r'devscm\setting') as k: uid = str(winreg.QueryValueEx(k, 'UserId')[0])
    except Exception:
        return ''
    try:
        sys.path.insert(0, P('tools', 'DbConn')); import dbconn
        c = dbconn.connect('asis'); c.timeout = limit; cur = c.cursor()
        cur.execute("SELECT GroupID FROM dbo.TB_FX_UserGroupInfo WITH(NOLOCK) WHERE UserID=? AND UseYN='Y'", uid); gs = [r[0] for r in cur.fetchall()]
        if not gs: c.close(); return ''
        g = 'ADMIN' if 'ADMIN' in gs else gs[0]; t0 = time.time()
        try:
            cur.execute('EXEC UP_FX_GetGSCMAuthenticationMenuList @UserID=?, @GroupID=?, @ProgramId=?', uid, g, ''); n = len(cur.fetchall()); sec = time.time() - t0
            print(f'[asis_live_auto] 메뉴 목록 SP 응답 {sec:.1f}초 · {n}행(계정 {uid} · 그룹 {g})', flush=True)
            return '' if n else f'메뉴 목록 SP 가 0행(계정 {uid} · 그룹 {g}) — 런처 메뉴가 비어 화면을 열 수 없음'
        except Exception as e:
            sec = time.time() - t0
            return f'AS-IS DB 응답 지연 — 메뉴 목록 SP 가 {sec:.0f}초 안에 끝나지 않음(런처 제한 30초 · 평소 6~7초). 지금 띄우면 메뉴가 비어 실패하므로 띄우지 않음 · DB 부하가 풀린 뒤 다시 실행 ({str(e)[:60]})'
        finally:
            try: c.close()
            except Exception: pass
    except Exception:
        return ''


def ensure_iis(wait=90):
    if port_open(PORT): return True, f'IIS Express {PORT} 이미 기동 중(건드리지 않음)'
    cmd = P('tools', 'AsisLocal', 'asis_iis.cmd')
    if not os.path.isfile(cmd): return False, f'IIS 기동 스크립트 없음: {cmd}'
    log = P('.vibe', 'logs', 'asis_iis_%s.log' % dt.datetime.now().strftime('%Y%m%d_%H%M%S')); os.makedirs(os.path.dirname(log), exist_ok=True)
    fo = open(log, 'ab')
    subprocess.Popen(['cmd', '/c', cmd], cwd=os.path.dirname(cmd), stdin=subprocess.PIPE, stdout=fo, stderr=fo, creationflags=0x00000008 | 0x00000200)  # DETACHED_PROCESS | NEW_PROCESS_GROUP — CheckList 가 끝나도 서버는 남는다
    print(f'[IIS] IIS Express 기동 — 포트 {PORT} 대기(최대 {wait}초) · 로그 {os.path.relpath(log, ROOT)}', flush=True)
    t0 = time.time()
    while time.time() - t0 < wait:
        if port_open(PORT): return True, f'IIS Express 를 새로 기동({int(time.time() - t0)}초) — CheckList 가 끝나도 끄지 않음'
        time.sleep(2)
    return False, f'IIS Express 가 {wait}초 안에 {PORT} 포트를 열지 못함 — 로그 {os.path.relpath(log, ROOT)}'


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('id'); ap.add_argument('--mode', default=os.environ.get('VERIFY_ASIS_LIVE', 'auto'), choices=['auto', 'always', 'off'])
    ap.add_argument('--max-age-hours', type=float, default=float(os.environ.get('VERIFY_ASIS_LIVE_MAX_AGE_H', '24'))); ap.add_argument('--dry', action='store_true', help='실제로 띄우지 않고 무엇을 할지만 출력')
    a = ap.parse_args(); mid = a.id.upper()
    if a.mode == 'off': print(f'[asis_live_auto] {mid}: 건너뜀(--mode off)'); return 3
    why = excluded(mid)
    if why: print(f'[asis_live_auto] {mid}: 대상 아님 — {why}'); return 3
    if a.mode == 'auto':
        rd, info = latest_ok(mid, a.max_age_hours)
        if rd: print(f'[asis_live_auto] {mid}: 최근 실측 사용({info}) — 런처를 다시 띄우지 않음 · {os.path.relpath(rd, ROOT)}'); return 0
        print(f'[asis_live_auto] {mid}: 새로 실측 — {info}')
    url, cf = client_url()
    if (url or '').strip().rstrip('/').lower() != BASE_URL.rstrip('/'):
        print(f"[asis_live_auto] {mid}: 미측정 — 런처 접속 주소가 {url or '(없음)'} 입니다(기대 {BASE_URL}). 재빌드하면 원본 서버 주소로 되돌아갑니다 → {cf} 를 고친 뒤 다시 실행"); return 3
    slow = menu_slow()
    if slow:
        print(f'[asis_live_auto] {mid}: 미측정 — {slow}'); return 0 if (a.mode == 'always' and latest_ok(mid, 10 ** 6)[0]) else 3
    if a.dry: print(f"[asis_live_auto] {mid}: (dry) IIS {'기동 중' if port_open(PORT) else '기동 필요'} · 다음 = asis_live_run.py {mid}"); return 0
    ok, msg = ensure_iis(); print(f'[asis_live_auto] {mid}: {msg}', flush=True)
    if not ok: return 3
    cmd = [sys.executable, P('tools', 'AsisLive', 'asis_live_run.py'), mid]
    print('$ ' + ' '.join(cmd), flush=True)
    # 새 실측이 실패하면 직전의 정상 실측(latest.json)을 되살린다 — 실패한 실행이 latest 를 덮어 정상 기록을 못 쓰게 되는 것을 막는다(11-13 14:33 SCP0104 에서 실제로 발생)
    lp = P('Doc', 'asislive', mid, 'latest.json'); prev = None
    try:
        prev = open(lp, encoding='utf-8').read()
        if json.loads(prev).get('status') != 'OK': prev = None
    except Exception: prev = None
    try: rc = subprocess.call(cmd, cwd=ROOT, timeout=1500)
    except subprocess.TimeoutExpired: rc = -1; print(f'[asis_live_auto] {mid}: 미측정 — AS-IS 실측이 25분 안에 끝나지 않음')
    if rc != 0 and prev:
        try:
            open(lp, 'w', encoding='utf-8').write(prev); print(f"[asis_live_auto] {mid}: 새 실측이 실패해 직전 정상 실측을 계속 씁니다({json.loads(prev).get('run_dir')})"); return 0
        except Exception: pass
    if rc == -1: return 3
    if rc == 0:
        try:
            sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); import asis_fp; asis_fp.record(mid, 'basic', 'asis_live_run')
        except Exception as _e: print(f'[asis_live_auto] {mid}: 원장 지문 기록 실패 {_e}')
    print(f"[asis_live_auto] {mid}: asis_live_run 종료코드 {rc} — {({0: '정상', 2: '화면 열기·조회 실패', 3: '미측정(환경 미비·잠금 대기 초과·증거 일부 없음)', 5: '로컬 서버 미기동'}).get(rc, '확인 필요')}")
    return 0 if rc == 0 else 3


if __name__ == '__main__':
    sys.exit(main())
