# -*- coding: utf-8 -*-
"""공용 결과 파일 안전 읽기·쓰기(2026-11-13 엔진 점검 · T284)

왜: 이 PC 에서 이미 있는 파일을 'w' 로 다시 열 때 OSError [Errno 22] 가 나는 경우가 있다.
  실측 — SCP0028 CheckList 11-13 15:57:14 diff_ingest.py:82 open(e2e_results.json, 'w') → Errno 22 → rc 1 → ASIS_DIFF 행 반입 누락.
  같은 PC 전례 — tools/VibeManager/quick.json·CHANGELOG.md 도 'w' 는 실패하고 'r+b' → seek(0) → write → truncate() 는 써졌다.
  Node 쪽 같은 증상 = "UNKNOWN: unknown error, open …e2e_results.json"(T281). 파일을 잡고 있던 프로세스는 미확인(추정하지 않는다).

  write_text(path, text, encoding)  'w' 로 쓰고, OSError 면 짧게 기다려 다시(최대 5회) → 그래도 안 되면 'r+b' 덮어쓰기(파일이 있을 때).
                                    끝까지 실패하면 OSError 를 그대로 던진다(기록 실패를 성공으로 넘기지 않는다).
  read_json_list(path)              없으면 [] · 있는데 못 읽으면(OSError) 다시 읽고, 끝까지 못 읽으면 예외.
                                    ⚠ 종전 diff_ingest 는 OSError 를 '이전 결과 없음([])' 으로 처리해, 잠긴 순간에 읽기는 실패하고 쓰기가 성공하면
                                      E2E 판정 전체가 차등 검증 행만으로 덮일 수 있었다 → 못 읽은 것과 없는 것을 구분한다.
  python tools/Harness/verify/safe_io.py --selftest
"""
import json
import os
import sys
import time

TRIES = 5
WAIT = 0.3


def write_text(path, text, encoding='utf-8', log=None):
    data = text.encode(encoding)
    last = None
    for k in range(TRIES):
        try:
            with open(path, 'wb') as f:
                f.write(data)
            if k and log:
                log(f"[safe_io] {os.path.basename(path)} 쓰기 {k + 1}번째 시도에 성공(앞 시도: {last})")
            return 'w'
        except OSError as e:
            last = f'{type(e).__name__} errno={e.errno}'
            time.sleep(WAIT * (k + 1))
    if os.path.exists(path):
        try:
            with open(path, 'r+b') as f:
                f.seek(0); f.write(data); f.truncate()
            if log:
                log(f"[safe_io] {os.path.basename(path)} 'w' {TRIES}회 실패({last}) → 'r+b' 덮어쓰기로 기록")
            return 'r+b'
        except OSError as e:
            last = f'{type(e).__name__} errno={e.errno}'
    raise OSError(f"{path} 쓰기 실패 — 'w' {TRIES}회·'r+b' 모두 실패({last})")


def read_json_list(path, encoding='utf-8'):
    if not path or not os.path.exists(path):
        return []
    last = None
    for k in range(TRIES):
        try:
            with open(path, encoding=encoding) as f:
                d = json.load(f)
            return d if isinstance(d, list) else []
        except OSError as e:
            last = e
            time.sleep(WAIT * (k + 1))
    raise OSError(f'{path} 읽기 실패({last}) — 이전 결과를 못 읽은 채 덮어쓰지 않는다')


def _selftest():
    import tempfile
    bad = 0
    d = tempfile.mkdtemp(prefix='safe_io_')
    p = os.path.join(d, 'r.json')

    def chk(name, ok):
        nonlocal bad
        print(('PASS' if ok else 'FAIL'), name)
        bad += 0 if ok else 1
    chk('없는 파일 읽기 = []', read_json_list(p) == [])
    chk("새 파일 쓰기 = 'w'", write_text(p, json.dumps([{'row_id': 'A', 'v': '가'}], ensure_ascii=False)) == 'w')
    chk('다시 읽기', read_json_list(p) == [{'row_id': 'A', 'v': '가'}])
    chk('짧은 내용으로 덮어쓰기(꼬리 없음)', write_text(p, '[]') == 'w' and open(p, 'rb').read() == b'[]')
    # 'w' 가 계속 실패하는 상황을 흉내 — open 을 바꿔 'wb' 만 Errno 22 로
    import builtins
    real = builtins.open
    calls = {'n': 0}

    def fake(file, mode='r', *a, **kw):
        if file == p and mode == 'wb':
            calls['n'] += 1
            raise OSError(22, 'Invalid argument')
        return real(file, mode, *a, **kw)
    global WAIT
    w0, WAIT = WAIT, 0.0
    builtins.open = fake
    try:
        how = write_text(p, '[{"row_id": "B"}]')
    finally:
        builtins.open = real; WAIT = w0
    chk(f"'w' {TRIES}회 Errno 22 → 'r+b' 로 기록", how == 'r+b' and calls['n'] == TRIES and read_json_list(p) == [{'row_id': 'B'}])
    # 읽기가 계속 실패하면 [] 로 넘기지 않고 예외

    def fake_r(file, mode='r', *a, **kw):
        if file == p and 'r' in mode and 'b' not in mode:
            raise OSError(22, 'Invalid argument')
        return real(file, mode, *a, **kw)
    w0, WAIT = WAIT, 0.0
    builtins.open = fake_r
    try:
        try:
            read_json_list(p); raised = False
        except OSError:
            raised = True
    finally:
        builtins.open = real; WAIT = w0
    chk('있는 파일을 못 읽으면 예외(빈 목록으로 넘기지 않음)', raised)
    try:
        os.remove(p); os.rmdir(d)
    except OSError:
        pass
    print(f'[safe_io selftest] {"FAIL " + str(bad) if bad else "PASS 6/6"}')
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(_selftest() if '--selftest' in sys.argv else 0)
