# -*- coding: utf-8 -*-
"""FE 기동 때 다국어 JSON 자동 재생성 (2026-11-13 사용자 지시: "별도 요청 없이 서버 기동 시 다국어 JSON 생성 — FE START 시")

왜: nscm-fe/public/locales/{KO,EN,CN}.json 은 손으로 '다국어 JSON 재생성' 을 돌려야만 갱신됐다.
  실측 11-13 — JSON 생성 10-28 · DB(SCM_ADM_MSG_M) 에만 있는 키 KO 158·EN 166·CN 167 → SCP0016 조회조건 라벨이 '_Ver.' 로 표시돼
  CheckList 14행이 화면 결함이 아닌데 판정이 바뀜(I2 FAIL 1 · PASS→ERROR 11 등). 재생성 자체는 2초(17:10 실측).

동작: quick.json '🎨 FE Start' 가 vite 와 나란히 이 스크립트를 띄운다(vite 기동을 막지 않는다 — JSON 은 public/ 정적 파일이라 화면 새로고침으로 반영).
  1) 로컬 BE(8080)가 열릴 때까지 기다린다(기본 최대 300초 · BE 와 FE 를 같이 띄우는 경우 BE 가 늦게 뜬다).
  2) 열리면 fe_gen_i18n.py(로컬 BE 메시지만 · 0건이면 아무것도 바꾸지 않음)를 실행한다. 메시지 API 가 아직 준비 전이면 몇 번 다시 시도한다.
  3) BE 가 끝내 안 뜨면 아무 파일도 바꾸지 않고 사유를 한 줄 남긴다(FE 는 그대로 뜬다).
  끄기: 환경변수 VIBE_FE_I18N=off

  python tools/Env/fe_start_i18n.py [--wait 초] [--selftest]
출력은 모두 '[i18n]' 으로 시작한다(VM FE Log 창에 섞여 보인다 · VM 의 기동 완료/실패 문구와 겹치지 않게).
"""
import io
import os
import socket
import sys
import time
import contextlib

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)


def say(msg):
    print(f'[i18n] {msg}', flush=True)


def port_open(port=8080, host='127.0.0.1'):
    try:
        with socket.create_connection((host, port), timeout=2):
            return True
    except OSError:
        return False


def run(wait_s=300, poll_s=3, gen=None, is_open=port_open, sleep=time.sleep, tries=4):
    """반환: 0 생성됨 · 3 꺼짐 · 4 BE 미기동(변경 없음) · 5 생성 실패(변경 없음 또는 생성기 보고)"""
    if os.environ.get('VIBE_FE_I18N', '').lower() == 'off':
        say('VIBE_FE_I18N=off — 다국어 JSON 자동 재생성 건너뜀')
        return 3
    t0 = time.time(); waited = 0
    while not is_open():
        if waited >= wait_s:
            say(f'로컬 BE(8080)가 {wait_s}초 안에 열리지 않아 다국어 JSON 을 재생성하지 않았습니다(파일 변경 없음) — BE 기동 뒤 VM "다국어 JSON 재생성" 을 실행하세요')
            return 4
        if waited == 0:
            say(f'로컬 BE(8080) 기동 대기 — 열리면 다국어 JSON 을 재생성합니다(최대 {wait_s}초 · FE 기동은 계속 진행)')
        sleep(poll_s); waited += poll_s
    if gen is None:
        import fe_gen_i18n
        gen = fe_gen_i18n.main
    rc = 5
    for k in range(tries):
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            try:
                rc = gen()
            except Exception as ex:  # 생성기 예외가 FE 기동 로그를 Traceback 으로 덮지 않게
                rc = 5; print(f'[FAIL] 생성기 예외: {ex}')
        out = [l for l in buf.getvalue().splitlines() if l.strip()]
        if rc == 0:
            last = next((l for l in reversed(out) if '키 수' in l), '')
            say(f'다국어 JSON 재생성 완료({time.time() - t0:.0f}초) — {last.strip()} · 화면 새로고침으로 반영')
            return 0
        if k < tries - 1:
            sleep(10)  # BE 포트는 열렸지만 메시지 API 가 아직 준비 전일 수 있다
    for l in out[-3:]:
        say(l.strip()[:300])
    say(f'다국어 JSON 재생성 실패(종료코드 {rc} · {tries}회 시도) — 위 사유 확인')
    return 5


def _selftest():
    bad = 0

    def chk(name, ok):
        nonlocal bad
        print('PASS' if ok else 'FAIL', name); bad += 0 if ok else 1
    nosleep = lambda s: None
    quiet = io.StringIO()
    with contextlib.redirect_stdout(quiet):
        calls = {'n': 0}
        def g_ok():
            calls['n'] += 1; print("실행 후 키 수 {'KO': 3} (실행 전 {'KO': 2})"); return 0
        r1 = run(gen=g_ok, is_open=lambda: True, sleep=nosleep)
        n1 = calls['n']
        r2 = run(wait_s=9, poll_s=3, gen=g_ok, is_open=lambda: False, sleep=nosleep)
        n2 = calls['n']
        seq = iter([False, False, True])
        r3 = run(wait_s=30, poll_s=3, gen=g_ok, is_open=lambda: next(seq), sleep=nosleep)
        st = {'n': 0}
        def g_late():
            st['n'] += 1
            if st['n'] < 3:
                print('[FAIL] 로컬 BE 메시지 0건'); return 5
            print("실행 후 키 수 {'KO': 3}"); return 0
        r4 = run(gen=g_late, is_open=lambda: True, sleep=nosleep)
        r5 = run(gen=lambda: 5, is_open=lambda: True, sleep=nosleep, tries=2)
        def g_boom():
            raise RuntimeError('x')
        r6 = run(gen=g_boom, is_open=lambda: True, sleep=nosleep, tries=1)
        os.environ['VIBE_FE_I18N'] = 'off'
        r7 = run(gen=g_ok, is_open=lambda: True, sleep=nosleep); n7 = calls['n']
        del os.environ['VIBE_FE_I18N']
    text = quiet.getvalue()
    chk('BE 열림 → 생성 1회 · rc 0', r1 == 0 and n1 == 1)
    chk('BE 안 열림 → 생성 호출 없음 · rc 4', r2 == 4 and n2 == 1)
    chk('BE 가 늦게 열림 → 기다렸다 생성 · rc 0', r3 == 0)
    chk('메시지 API 준비 전(2회 실패) → 다시 시도해 성공', r4 == 0 and st['n'] == 3)
    chk('생성 실패 지속 → rc 5', r5 == 5)
    chk('생성기 예외 → rc 5(Traceback 없이)', r6 == 5 and 'Traceback' not in text)
    chk('VIBE_FE_I18N=off → 건너뜀 · rc 3', r7 == 3 and n7 == calls['n'])
    chk("모든 출력 줄이 '[i18n]' 으로 시작", all(l.startswith('[i18n] ') for l in text.splitlines() if l.strip()))
    import re
    chk('VM 기동 실패 판정 문구와 겹치지 않음', not re.search(r'Port \d+ was already in use|Address already in use|EADDRINUSE|is not recognized as an internal or external command|cannot find the path|could not find or load main class', text, re.I))
    print(f"[fe_start_i18n selftest] {'FAIL ' + str(bad) if bad else 'PASS 9/9'}")
    return 1 if bad else 0


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        sys.exit(_selftest())
    w = 300
    if '--wait' in sys.argv:
        try:
            w = int(sys.argv[sys.argv.index('--wait') + 1])
        except (ValueError, IndexError):
            pass
    sys.exit(run(wait_s=w))
