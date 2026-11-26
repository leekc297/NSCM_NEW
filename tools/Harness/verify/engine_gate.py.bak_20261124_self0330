# -*- coding: utf-8 -*-
"""검사기 보완 구간 보호 (2026-11-20 CheckList 한 번 실행 구조 2.4)
   체인의 '검증 보완(Claude)' 단계 앞뒤에서 부른다. 공용 검사기(스펙 · tools/E2E/lib · tools/Harness/verify)를 고치는 구간을 화면끼리 겹치지 않게 하고,
   고친 뒤 엔진 게이트(engine_selfcheck.py)를 통과하지 못하면 고친 파일을 보완 전으로 되돌린다.

  python tools/Harness/verify/engine_gate.py <MENU_ID> --mark     잠금 획득(다른 화면이 보완 중이면 대기) + 검사기 파일 사본·지문 보관
  python tools/Harness/verify/engine_gate.py <MENU_ID> --check    바뀐 파일 확인 → 게이트 → 실패면 되돌림 → 변경 기록 → 잠금 해제
  python tools/Harness/verify/engine_gate.py --selftest

  잠금 Doc/verify/_engine_fix.lock {screen, at, pid}. 주인이 같은 화면이면 다시 잡는다. STALE_MIN(90분: Claude 단계 상한 60분 + 여유) 넘은 잠금은 버려진 것으로 보고 넘겨받는다
  사본 .vibe/orch/snap/engine_<ID>/  (manifest.json = 경로별 해시)
  기록 Doc/verify/_engine_changes.jsonl  {at, screen, files[], gate('ok'|'reverted'|'none'), why}
       다른 화면은 다음 실행의 소스 기준선(source_snap.py 의 lib·시험 지문)이 이 변경을 감지해 영향 규칙을 다시 잰다
  종료코드 0 = 진행(변경 없음 · 게이트 통과 · 되돌림 모두 0. 되돌렸으면 [WARN] 줄) · 3 = --check 인데 사본 없음
"""
import datetime, glob, hashlib, json, os, shutil, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
STALE_MIN = 90
PATTERNS = (('Doc', 'e2e', 'specs', '_*.spec.ts'), ('Doc', 'e2e', 'specs', 'eg_*.ts'), ('tools', 'E2E', 'lib', '*.ts'), ('tools', 'E2E', 'fixtures', '*.ts'),
            ('tools', 'Harness', 'verify', '*.py'), ('tools', 'Harness', 'verify', '*.csv'), ('tools', 'Harness', 'rules', '*.csv'))


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def fhash(p):
    try:
        return hashlib.sha1(open(p, 'rb').read()).hexdigest()
    except OSError:
        return ''


def tracked(root=None):
    root = root or ROOT; out = {}
    for pat in PATTERNS:
        for p in glob.glob(os.path.join(root, *pat)):
            if os.path.isfile(p):
                out[os.path.relpath(p, root).replace('\\', '/')] = fhash(p)
    return out


def lock_path(root=None):
    return os.path.join(root or ROOT, 'Doc', 'verify', '_engine_fix.lock')


def acquire(mid, root=None, wait_sec=None, say=print, sleep=time.sleep):
    """잠금 획득. 반환 = 기다린 초. wait_sec 를 넘기면 그대로 넘겨받지 않고 계속 기다린다(None = 끝없이, 시험용 한도만)"""
    lp = lock_path(root); os.makedirs(os.path.dirname(lp), exist_ok=True); t0 = time.time(); told = 0
    while True:
        try:
            cur = json.load(open(lp, encoding='utf-8'))
        except (OSError, ValueError):
            cur = None
        stale = cur and (time.time() - float(cur.get('ts') or 0)) > STALE_MIN * 60
        if not cur or cur.get('screen') == mid or stale:
            if stale and cur.get('screen') != mid:
                say(f"[INFO] 검사기 보완 잠금 넘겨받음: {cur.get('screen')} 가 {cur.get('at')} 에 잡고 {STALE_MIN}분 넘게 풀지 않음", flush=True)
            json.dump({'screen': mid, 'at': now(), 'ts': time.time(), 'pid': os.getpid()}, open(lp, 'w', encoding='utf-8'), ensure_ascii=False)
            return int(time.time() - t0)
        if time.time() - told > 60:
            say(f"[WAIT] 검사기 보완 순서 대기: {cur.get('screen')} 가 {cur.get('at')} 부터 보완 중(공용 검사기 파일을 한 화면씩 고침)", flush=True); told = time.time()
        if wait_sec is not None and time.time() - t0 > wait_sec:
            return -1
        sleep(5)


def release(mid, root=None):
    lp = lock_path(root)
    try:
        if json.load(open(lp, encoding='utf-8')).get('screen') == mid:
            os.remove(lp)
    except (OSError, ValueError):
        pass


def snap_dir(mid, root=None):
    return os.path.join(root or ROOT, '.vibe', 'orch', 'snap', f'engine_{mid}')


def mark(mid, root=None):
    root = root or ROOT; sd = snap_dir(mid, root)
    shutil.rmtree(sd, ignore_errors=True); os.makedirs(sd, exist_ok=True)
    man = tracked(root)
    for rel in man:
        dst = os.path.join(sd, rel); os.makedirs(os.path.dirname(dst), exist_ok=True); shutil.copy2(os.path.join(root, rel), dst)
    json.dump({'at': now(), 'files': man}, open(os.path.join(sd, 'manifest.json'), 'w', encoding='utf-8'), ensure_ascii=False)
    return len(man)


def changed(mid, root=None):
    """(바뀐 파일, 새 파일, 지워진 파일) — 사본 없으면 None"""
    root = root or ROOT
    try:
        man = json.load(open(os.path.join(snap_dir(mid, root), 'manifest.json'), encoding='utf-8'))['files']
    except (OSError, ValueError, KeyError):
        return None
    cur = tracked(root)
    return (sorted(k for k in cur if k in man and cur[k] != man[k]), sorted(k for k in cur if k not in man), sorted(k for k in man if k not in cur))


def restore(mid, mod, new, gone, root=None):
    root = root or ROOT; sd = snap_dir(mid, root)
    for rel in mod + gone:
        os.makedirs(os.path.dirname(os.path.join(root, rel)), exist_ok=True); shutil.copy2(os.path.join(sd, rel), os.path.join(root, rel))
    for rel in new:   # 보완이 새로 만든 파일은 지우지 않고 이름을 바꿔 남긴다(되돌린 근거 확인용)
        try:
            os.replace(os.path.join(root, rel), os.path.join(root, rel) + '.reverted')
        except OSError:
            pass


def log_change(rec, root=None):
    p = os.path.join(root or ROOT, 'Doc', 'verify', '_engine_changes.jsonl')
    with open(p, 'a', encoding='utf-8') as fh:
        fh.write(json.dumps(rec, ensure_ascii=False) + '\n')


def check(mid, root=None, gate=None):
    """gate() → (rc, 출력 끝). 반환 = 기록 dict"""
    root = root or ROOT; ch = changed(mid, root)
    if ch is None:
        return None
    mod, new, gone = ch; files = mod + new + gone
    rec = {'at': now(), 'screen': mid, 'files': files, 'gate': 'none', 'why': ''}
    if files:
        rc, tail = (gate or run_gate)()
        if rc == 0:
            rec['gate'] = 'ok'
        else:
            restore(mid, mod, new, gone, root); rec['gate'] = 'reverted'; rec['why'] = f'engine_selfcheck rc {rc}: ' + tail[-600:]
        log_change(rec, root)
    release(mid, root)
    return rec


def run_gate():
    r = subprocess.run([sys.executable, os.path.join(HERE, 'engine_selfcheck.py')], cwd=ROOT, capture_output=True, text=True, encoding='utf-8', errors='replace')
    return r.returncode, (r.stdout or '') + (r.stderr or '')


def selftest():
    import tempfile
    ok = True

    def chk(name, cond, extra=''):
        nonlocal ok
        print(('PASS ' if cond else 'FAIL ') + name + (' ' + str(extra) if extra and not cond else '')); ok = ok and bool(cond)
    root = tempfile.mkdtemp(prefix='egate-')

    def W(rel, s):
        p = os.path.join(root, rel); os.makedirs(os.path.dirname(p), exist_ok=True); open(p, 'w', encoding='utf-8').write(s); return p
    W('tools/E2E/lib/probe.ts', 'a'); W('tools/Harness/verify/judge.py', 'b'); W('Doc/e2e/specs/_verify.spec.ts', 'c'); os.makedirs(os.path.join(root, 'Doc', 'verify'), exist_ok=True)
    msgs = []
    chk('잠금 획득(대기 0)', acquire('SCP0001', root, say=lambda *a, **k: msgs.append(a[0])) == 0)
    chk('다른 화면은 대기(한도 안에 못 잡음)', acquire('SCP0002', root, wait_sec=0, say=lambda *a, **k: msgs.append(a[0]), sleep=lambda s: None) == -1 and any('[WAIT]' in m for m in msgs))
    chk('같은 화면은 다시 잡음', acquire('SCP0001', root, say=lambda *a, **k: None) == 0)
    n = mark('SCP0001', root); chk('사본 3개', n == 3)
    chk('변경 없음', changed('SCP0001', root) == ([], [], []))
    r = check('SCP0001', root, gate=lambda: (1, 'x')); chk('변경 없으면 게이트 안 돌림 · 잠금 해제', r['gate'] == 'none' and not os.path.exists(lock_path(root)))
    acquire('SCP0001', root, say=lambda *a, **k: None); mark('SCP0001', root)
    W('tools/E2E/lib/probe.ts', 'a2'); W('tools/E2E/lib/newprobe.ts', 'n')
    chk('바뀐 파일 · 새 파일 감지', changed('SCP0001', root) == (['tools/E2E/lib/probe.ts'], ['tools/E2E/lib/newprobe.ts'], []))
    r = check('SCP0001', root, gate=lambda: (0, 'ok')); chk('게이트 통과 = 유지 · 기록', r['gate'] == 'ok' and open(os.path.join(root, 'tools/E2E/lib/probe.ts')).read() == 'a2')
    acquire('SCP0001', root, say=lambda *a, **k: None); mark('SCP0001', root)
    W('tools/E2E/lib/probe.ts', 'broken'); W('tools/Harness/verify/x.py', 'new')
    r = check('SCP0001', root, gate=lambda: (2, 'PY_UNDEF'))
    chk('게이트 실패 = 되돌림', r['gate'] == 'reverted' and open(os.path.join(root, 'tools/E2E/lib/probe.ts')).read() == 'a2' and 'PY_UNDEF' in r['why'])
    chk('새 파일은 .reverted 로 남김', os.path.exists(os.path.join(root, 'tools/Harness/verify/x.py.reverted')) and not os.path.exists(os.path.join(root, 'tools/Harness/verify/x.py')))
    lines = [json.loads(l) for l in open(os.path.join(root, 'Doc', 'verify', '_engine_changes.jsonl'), encoding='utf-8')]
    chk('변경 기록 2줄(ok, reverted)', [x['gate'] for x in lines] == ['ok', 'reverted'])
    json.dump({'screen': 'SSP0009', 'at': 'old', 'ts': time.time() - (STALE_MIN + 1) * 60}, open(lock_path(root), 'w', encoding='utf-8'))
    chk('오래된 잠금은 넘겨받음', acquire('SCP0002', root, wait_sec=0, say=lambda *a, **k: None, sleep=lambda s: None) == 0)
    chk('사본 없는 화면 check = None', check('NONE0001', root) is None)
    shutil.rmtree(root, ignore_errors=True)
    print('SELFTEST ' + ('OK' if ok else 'FAIL')); return 0 if ok else 1


def main():
    if '--selftest' in sys.argv:
        return selftest()
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if not args:
        print(__doc__); return 2
    mid = args[0].upper()
    if '--mark' in sys.argv:
        w = acquire(mid); n = mark(mid)
        print(f'[OK] 검사기 보완 구간 시작: 잠금 획득(대기 {w}초) · 검사기 파일 {n}개 사본 보관(.vibe/orch/snap/engine_{mid})', flush=True); return 0
    if '--check' in sys.argv:
        r = check(mid)
        if r is None:
            print(f'[FAIL] 사본 없음(.vibe/orch/snap/engine_{mid}) — --mark 를 먼저 실행'); release(mid); return 3
        if not r['files']:
            print('[INFO] 검사기 파일 변경 없음(보완 단계가 검사기를 고치지 않음)', flush=True)
        elif r['gate'] == 'ok':
            print(f"[OK] 검사기 변경 {len(r['files'])}개 · 엔진 게이트 통과: " + ', '.join(r['files'][:8]), flush=True)
        else:
            print(f"[WARN] 엔진 게이트 실패 → 검사기 변경 {len(r['files'])}개를 보완 전으로 되돌림: " + ', '.join(r['files'][:8]) + ' · ' + r['why'][-300:], flush=True)
        return 0
    print(__doc__); return 2


if __name__ == '__main__':
    sys.exit(main())
