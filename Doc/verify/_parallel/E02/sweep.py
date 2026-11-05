#!/usr/bin/env python
"""E02 실측 순회 — 화면·호출 선택 후 run.sh 를 차례로 실행. 부하 신호가 나오면 즉시 멈춘다.
  python -I sweep.py <진행표.json> <ID[:modes]> ...
  호출 선택 = facts 의 (클래스, 트리거 종류, 컬럼/컨트롤) 중복 제거 + TO-BE 메타 팝업 셀(문서 대상 토큰)
"""
import json, os, re, subprocess, sys, time

ROOT = r'C:\Projects\NSCM'
E02 = os.path.join(ROOT, 'Doc', 'verify', '_parallel', 'E02')
BE_LOG = r'C:\Users\ejene\AppData\Local\Temp\claude\c--Projects-NSCM\df35bb3d-69d0-477c-a01d-67a99b5ba4ea\scratchpad\be_start.log'
RUN = 'Doc/verify/_parallel/E02/run.sh'
sys.stdout.reconfigure(encoding='utf-8', line_buffering=True)
env0 = dict(os.environ)
env0['PYTHONIOENCODING'] = 'utf-8'
env0['EG_META'] = '1'


def stamp():
    return time.strftime('%H:%M:%S')


def load_signals(run_dir, mark):
    sig = []
    try:
        with open(BE_LOG, encoding='utf-8', errors='replace') as f:
            f.seek(mark)
            t = f.read()
        if 'Connection is not available' in t:
            sig.append('HikariPool 연결 타임아웃(BE 로그)')
    except OSError:
        pass
    try:
        t = open(os.path.join(run_dir, 'run.log'), encoding='utf-8', errors='replace').read()
        if re.search(r'ERR_CONNECTION|로그인 실패|HTTP 401|ORA-12\d\d\d|10055', t):
            sig.append('run.log 연결·로그인 오류')
    except OSError:
        pass
    p = os.path.join(run_dir, 'popup_results.json')
    if os.path.exists(p):
        R = json.load(open(p, encoding='utf-8'))
        if any('부하' in r['actual'] and r['result'] == 'ERROR' for r in R):
            sig.append('측정 시간 초과(부하 가능) ' + str(sum('부하' in r['actual'] for r in R)) + '건')
    return sig


def size():
    try:
        return os.path.getsize(BE_LOG)
    except OSError:
        return 0


def sel_calls(mid):
    j = json.load(open(os.path.join(E02, 'facts', f'{mid}.json'), encoding='utf-8'))
    seen, out = set(), []
    for i, c in enumerate(j['calls']):
        t = c['trigger']
        k = (c['cls'], t['kind'], t.get('column') or t.get('control'))
        if k in seen or t['kind'] == 'OTHER':
            continue
        seen.add(k)
        out.append(i)
    # TO-BE 메타 팝업 셀(AS-IS 호출 facts 없음) — 스펙의 합성 번호(100+)와 같은 순서
    mp = os.path.join(E02, 'facts', f'{mid}.meta.json')
    if os.path.exists(mp):
        mj = json.load(open(mp, encoding='utf-8'))
        sc = {c['trigger']['column'] for c in j['calls'] if c['trigger']['kind'] == 'CELL'}
        cols = list(dict.fromkeys(x['COLUMN_NAME'] for x in mj['columns'] if re.search(r'FP(Text)?Modal', x['CELL_CONTROL_OBJECT_TYPE_CODE'], re.I)))
        base = max(100, len(j['calls']))
        for n, col in enumerate(c for c in cols if c not in sc):
            out.append(base + n)
    return out


def main():
    prog_p = sys.argv[1]
    prog = json.load(open(prog_p, encoding='utf-8')) if os.path.exists(prog_p) else {}
    for spec in sys.argv[2:]:
        mid, _, modes = spec.partition(':')
        if prog.get(spec, {}).get('done'):
            continue
        calls = ''
        if not modes.startswith('INSERT'):
            ids = sel_calls(mid) if os.path.exists(os.path.join(E02, 'facts', f'{mid}.json')) else []
            calls = ','.join(map(str, ids))
            if not ids:
                prog[spec] = {'done': True, 'note': '호출 facts 없음'}
                json.dump(prog, open(prog_p, 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
                print(stamp(), spec, '호출 없음')
                continue
        mark = size()
        t0 = time.time()
        print(stamp(), spec, '시작 calls', calls)
        lbl = 's' + time.strftime('%H%M')
        p = subprocess.run(['bash', RUN, mid, lbl, calls, modes], cwd=ROOT, capture_output=True, text=True, encoding='utf-8', errors='replace', env=env0)
        out = p.stdout.strip().split('\n')
        run_dir = out[-1].replace('/c/', 'C:/') if out else ''
        sig = load_signals(run_dir, mark)
        el = round(time.time() - t0)
        print(stamp(), spec, f'rc={p.returncode} {el}s dir={os.path.basename(run_dir)} 부하신호={sig}')
        prog[spec] = {'done': p.returncode in (0, 1), 'rc': p.returncode, 'dir': run_dir, 'sec': el, 'load': sig, 'end': stamp()}
        json.dump(prog, open(prog_p, 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
        if p.returncode == 92:
            prog[spec]['done'] = False
            json.dump(prog, open(prog_p, 'w', encoding='utf-8'), ensure_ascii=False, indent=0)
            print(stamp(), spec, '다른 세션 사용 중 — 건너뜀(재실행 대상)')
            continue
        if p.returncode == 90 or sig:
            print(stamp(), '[STOP] 부하 신호 — 순회 중지', sig)
            return 90
    print(stamp(), '순회 끝')
    return 0


if __name__ == '__main__':
    sys.exit(main())
