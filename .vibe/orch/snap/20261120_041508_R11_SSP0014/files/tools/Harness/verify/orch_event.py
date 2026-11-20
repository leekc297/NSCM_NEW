# -*- coding: utf-8 -*-
"""오케스트라 사건 기록(Python 쪽) — .vibe/orch/events.jsonl 에 한 줄 1건(JSON) 덧붙임 (2026-11-19 오케스트라 P1)

  VM(tools/VibeManager/orch-events.js)과 같은 파일·같은 줄 형식: {at, ms, type, src, pid, ...필드}
  기록 실패는 호출한 작업을 멈추지 않는다(예외를 삼킨다).

  사용:
    import orch_event
    orch_event.emit('wait.start', kind='lock', screen='SCP0111', blocker_pid=1234, why='같은 화면 E2E 진행 중')
    orch_event.emit('wait.end',   kind='lock', screen='SCP0111', sec_wait=90, gave_up=False)

  대기 종류(kind): admit(부하 입장) · lock(화면 잠금) · slot(동시 상한) · dbwin(시험 데이터 구간) · langwait(언어 전환 재실행 대기)
  시험: python tools/Harness/verify/orch_event.py --selftest
"""
import json
import os
import sys
import time

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
MAX_BYTES = 16 * 1024 * 1024


def _dir():
    return os.environ.get('VIBE_ORCH_DIR') or os.path.join(ROOT, '.vibe', 'orch')


def _now_local(ts):
    lt = time.localtime(ts)
    off = -(time.altzone if lt.tm_isdst > 0 else time.timezone)
    sg = '+' if off >= 0 else '-'
    off = abs(off)
    return time.strftime('%Y-%m-%dT%H:%M:%S', lt) + f'{sg}{off // 3600:02d}:{off % 3600 // 60:02d}'


def emit(type_, **fields):
    """사건 1건 기록. 반환 = 기록한 dict(실패하면 None)"""
    try:
        d = _dir()
        os.makedirs(d, exist_ok=True)
        f = os.path.join(d, 'events.jsonl')
        try:
            if os.path.getsize(f) >= MAX_BYTES:
                os.replace(f, os.path.join(d, 'events_' + time.strftime('%Y%m%d_%H%M%S') + '.jsonl'))
        except OSError:
            pass
        ts = time.time()
        ev = {'at': _now_local(ts), 'ms': int(ts * 1000), 'type': str(type_), 'src': 'py', 'pid': os.getpid(),
              'script': os.path.basename(sys.argv[0] or '')}
        ev.update(fields)
        with open(f, 'a', encoding='utf-8', newline='\n') as fh:
            fh.write(json.dumps(ev, ensure_ascii=False) + '\n')
        return ev
    except Exception:
        return None


def _selftest():
    import tempfile
    d = tempfile.mkdtemp(prefix='orch-')
    os.environ['VIBE_ORCH_DIR'] = d
    a = emit('wait.start', kind='lock', screen='SCP0000', why='시험')
    b = emit('wait.end', kind='lock', screen='SCP0000', sec_wait=30, gave_up=False)
    rows = [json.loads(x) for x in open(os.path.join(d, 'events.jsonl'), encoding='utf-8') if x.strip()]
    ok = bool(a and b) and len(rows) == 2 and rows[0]['type'] == 'wait.start' and rows[1]['sec_wait'] == 30 and rows[0]['why'] == '시험'
    for x in os.listdir(d):
        os.remove(os.path.join(d, x))
    os.rmdir(d)
    print('selftest', 'OK' if ok else 'FAIL', rows[0]['at'] if rows else '')
    return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(_selftest() if '--selftest' in sys.argv else 0)
