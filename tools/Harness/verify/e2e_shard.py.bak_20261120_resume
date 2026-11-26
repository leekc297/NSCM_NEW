# -*- coding: utf-8 -*-
"""한 화면 E2E 나눠 동시 실행 (2026-11-20 D1 · 사용자 지시)
   "E2E 테스트의 경우에도 간섭이 없는 범위에서 동시 수행" · "정합성에 문제가 되는 것이라면 방법으로 고려해서는 안됩니다"

  run_verify.py 가 부른다: e2e_shard.run(mid, env, spec_files, tier_args, out_dir, e2e_dir) → 종료코드 · None(나눠 실행 조건 아님 → 종전 1개 실행)

  간섭 없는 범위의 정의(tools/E2E/lib/writeguard.ts)
    - 쓰기 시험 = 지난 실행에서 서버 상태를 바꾸는 요청(실저장 call-proc · 언어 · 시간대 · 즐겨찾기 · 개인화 등 GET 이 아닌 /api/ 요청 중 읽기 목록 밖)을 보낸 시험
    - 읽기 시험 = 지난 차례 실행에서 그런 요청이 0건인 시험. 처음 보는 시험은 쓰기로 본다(차례 실행)
  순서
    1) 읽기 시험을 작업자 N개(harness.json e2eReadPar · 기본 3)에 나눠 동시에 돈다(E2E_PHASE=read).
       이 단계에서 쓰기 요청이 나오면 서버로 보내지 않고 끊는다 → 그 시험은 위반으로 기록되고 2) 에서 다시 돈다(결과는 행 단위로 덮어씀)
    2) 쓰기 시험 + 1) 의 위반 시험을 작업자 1개로 차례 실행(종전과 같은 조건)
    3) Playwright JSON 보고서를 합쳐 e2e/results.json 하나로 · 필수 조건 자동 채움 행 판정(작업자별 기록을 모아 _verify.spec 과 같은 문구)
  결과 파일(e2e_results.json · combo_runtime.json · index_verify.json)은 스펙 쪽 파일 잠금(withFileLock)으로 합친다
  끄기 = harness.json e2eReadPar 1
"""
import csv, hashlib, json, os, re, subprocess, sys, threading, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)
TEST_LINE = re.compile(r'^\s+(ok|x|✘|-|✓)\s+(\d+)\s+(.*)$')


def cfg_par():
    try:
        return max(1, int(json.load(open(os.path.join(ROOT, 'tools', 'Harness', 'harness.json'), encoding='utf-8-sig')).get('e2eReadPar') or 3))
    except (OSError, ValueError, TypeError):
        return 3


def list_tests(e2e_dir, env, spec_files, tier_args):
    """[(file, full_title, title)] — Playwright --list(JSON)"""
    cmd = ['node', os.path.join('node_modules', '@playwright', 'test', 'cli.js'), 'test', *spec_files, *tier_args, '--list', '--reporter=json']
    e = dict(env); e.pop('PLAYWRIGHT_JSON_OUTPUT_NAME', None)
    r = subprocess.run(cmd, cwd=e2e_dir, env=e, capture_output=True, text=True, encoding='utf-8', errors='replace', timeout=600)
    txt = r.stdout; i = txt.find('{')
    if i < 0:
        return []
    try:
        j = json.loads(txt[i:])
    except ValueError:
        return []
    out = []

    def walk(s, path, file_):
        file_ = s.get('file') or file_
        t = s.get('title') or ''
        p = path + ([t] if t and not t.endswith('.ts') else [])
        for sp in s.get('specs', []):
            out.append((os.path.basename(sp.get('file') or file_ or ''), ' '.join(p + [sp.get('title', '')]), sp.get('title', '')))
        for c in s.get('suites', []):
            walk(c, p, file_)
    for s in j.get('suites', []):
        walk(s, [], '')
    return out


def kinds(mid):
    """{(file, title): 'read'|'write'} — 차례 실행 기록의 마지막 값. 동시 실행 단계 위반(blocked)은 쓰기"""
    p = os.path.join(ROOT, 'Doc', 'verify', mid, 'e2e_test_kind.jsonl'); out = {}
    try:
        for ln in open(p, encoding='utf-8'):
            try:
                x = json.loads(ln)
            except ValueError:
                continue
            k = (x.get('file', ''), x.get('title', ''))
            if x.get('phase') == 'serial':      # 차례 실행 기록이 기준(마지막 값)
                out[k] = 'write' if x.get('write') else 'read'
            elif x.get('blocked'):              # 동시 실행 단계에서 쓰기 요청을 끊은 시험 = 쓰기(뒤 차례 실행 기록이 다시 정함)
                out[k] = 'write'
    except OSError:
        pass
    return out


def durations(mid):
    """{title: 지난 실행 소요 ms} — _test_timing.jsonl 마지막 값"""
    p = os.path.join(ROOT, 'Doc', 'verify', mid, '_test_timing.jsonl'); out = {}
    try:
        for ln in open(p, encoding='utf-8'):
            try:
                x = json.loads(ln); out[x.get('title', '')] = sum(int(v or 0) for v in (x.get('ms') or {}).values()) or 60000
            except (ValueError, TypeError, AttributeError):
                continue
    except OSError:
        pass
    return out


def balance(tests, dur, n):
    """긴 시험부터 가장 덜 찬 작업자에 → n 묶음"""
    bins = [[] for _ in range(n)]; load = [0] * n
    for t in sorted(tests, key=lambda t: -dur.get(t[2], 60000)):
        k = load.index(min(load)); bins[k].append(t); load[k] += dur.get(t[2], 60000)
    return [b for b in bins if b], load


def grep_of(tests):
    # Playwright grep 대상 = 상위 묶음 제목(프로젝트·파일·describe) + 시험 제목 + 태그(@x)를 공백으로 이은 문자열(node_modules/playwright/lib/common/index.js _grepTitleWithTags) → 앞은 공백 경계, 끝은 태그만 허용
    return '(?:' + '|'.join('(?:^| )' + re.escape(full) + '(?: @\S+)*$' for _f, full, _t in tests) + ')'


def merge_reports(paths, out):
    suites, errors, stats, cfg = [], [], {}, None
    for p in paths:
        try:
            j = json.load(open(p, encoding='utf-8'))
        except (OSError, ValueError):
            continue
        cfg = cfg or j.get('config'); suites += j.get('suites', []); errors += j.get('errors', [])
        for k, v in (j.get('stats') or {}).items():
            if isinstance(v, (int, float)) and not isinstance(v, bool):
                stats[k] = (stats.get(k) or 0) + v
            elif k not in stats:
                stats[k] = v
    json.dump({'config': cfg or {}, 'suites': suites, 'errors': errors, 'stats': stats}, open(out, 'w', encoding='utf-8'), ensure_ascii=False)


def finalize_req_notes(mid, run_id, res_json):
    """_verify.spec afterAll 과 같은 판정·문구(E2E_SHARD 실행에서는 스펙이 판정하지 않고 이 함수가 함)"""
    led = os.path.join(ROOT, 'Doc', 'verify', mid, 'verify_ledger.csv')
    try:
        rows = list(csv.DictReader(open(led, encoding='utf-8-sig')))
    except OSError:
        return
    rq = next((r for r in rows if r.get('source') == 'RULE_SCREEN' and re.search('필수 조건 자동 채움', r.get('target') or '')), None)
    if not rq:
        return
    fp = os.path.join(ROOT, 'Doc', 'verify', mid, f'_req_notes_{run_id or "run"}.json')
    try:
        notes = json.load(open(fp, encoding='utf-8'))
    except (OSError, ValueError):
        notes = []
    res, ev = ('판정필요', f"[필수 조건 자동 채움 {len(notes)}건 — 검사기가 우회한 필수 알림] {' | '.join(notes[:5])} → 그 조건의 기본값(ALL 등)·필수 처리가 결함인지 사람 판정") if notes else ('PASS', '필수 조건 자동 채움 0건 — 조회가 기본값으로 바로 됨')
    try:
        cur = json.load(open(res_json, encoding='utf-8'))
    except (OSError, ValueError):
        cur = []
    cur = [x for x in cur if x.get('row_id') != rq['row_id']]
    cur.append({'row_id': rq['row_id'], 'result': res, 'evidence': ev[:900], 'tobe_ref': 'E2E @verify', 'cond': hashlib.sha1((rq.get('condition') or '').encode('utf-8')).hexdigest()[:8], 'run': run_id})
    tmp = res_json + '.tmp'; json.dump(cur, open(tmp, 'w', encoding='utf-8'), ensure_ascii=False, indent=1); os.replace(tmp, res_json)
    try:
        os.remove(fp)
    except OSError:
        pass


def _pump(proc, tag, counter, lock, logf):
    for raw in iter(proc.stdout.readline, b''):
        ln = raw.decode('utf-8', 'replace').rstrip('\r\n')
        with lock:
            try:
                logf.write(ln + '\n')
            except Exception:
                pass
            m = TEST_LINE.match(ln)
            if m:
                counter[0] += 1; print(f"  {m.group(1)} {counter[0]} {m.group(3)}  [{tag}]", flush=True)
            elif ln.strip():
                print(f"[{tag}] {ln}", flush=True)


def run(mid, env, spec_files, tier_args, out_dir, e2e_dir):
    par = cfg_par()
    if par <= 1:
        return None
    tests = list_tests(e2e_dir, env, spec_files, tier_args)
    if not tests:
        print('[INFO] 나눠 실행 안 함: 시험 목록을 못 읽음 → 차례 실행', flush=True); return None
    kd = kinds(mid)
    read = [t for t in tests if kd.get((t[0], t[2])) == 'read']; serial = [t for t in tests if t not in read]
    if len(read) < 2:
        print(f'[INFO] 나눠 실행 안 함: 지난 차례 실행 기록으로 확인된 읽기 시험 {len(read)}개(시험 {len(tests)}개) → 차례 실행(이번 실행이 시험 종류를 기록)', flush=True); return None
    dur = durations(mid); bins, load = balance(read, dur, par)
    tier_inv = ['--grep-invert', tier_args[tier_args.index('--grep-invert') + 1]] if '--grep-invert' in tier_args else []
    e2e_out = os.path.join(out_dir, 'e2e'); os.makedirs(e2e_out, exist_ok=True)
    print(f"[INFO] E2E 나눠 실행: 시험 {len(tests)}개 = 읽기 {len(read)}개(작업자 {len(bins)}개 동시 · 예정 부하 {', '.join(f'{x // 60000}분' for x in load if x)}) + 차례 {len(serial)}개(쓰기 또는 처음 보는 시험)", flush=True)
    print(f"Running {len(tests)} tests using {len(bins)} workers(읽기) + 1 worker(차례)", flush=True)
    counter = [0]; lock = threading.Lock(); reports = []; rc_all = 0; t0 = time.time()
    procs = []
    for k, b in enumerate(bins, 1):
        rp = os.path.join(e2e_out, f'results_read{k}.json'); reports.append(rp)
        e = dict(env, E2E_PHASE='read', E2E_SHARD=f'read{k}', E2E_RESULTS=os.path.join(e2e_out, f'read{k}'), PLAYWRIGHT_JSON_OUTPUT_NAME=rp)
        cmd = ['node', os.path.join('node_modules', '@playwright', 'test', 'cli.js'), 'test', *spec_files, '--grep', grep_of(b), *tier_inv, '--workers', '1', '--reporter=list,json']
        logf = open(os.path.join(e2e_out, f'read{k}.log'), 'w', encoding='utf-8')
        p = subprocess.Popen(cmd, cwd=e2e_dir, env=e, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        th = threading.Thread(target=_pump, args=(p, f'작업자 {k}', counter, lock, logf), daemon=True); th.start(); procs.append((p, th, logf))
        time.sleep(3)  # 로그인이 한꺼번에 몰리지 않게
    for p, th, logf in procs:
        rc_all = max(rc_all, p.wait() or 0); th.join(timeout=30); logf.close()
    t1 = time.time()
    # 동시 실행 단계 위반(쓰기 요청을 끊은 시험) → 차례 실행에 더함
    viol = set()
    try:
        for ln in open(os.path.join(ROOT, 'Doc', 'verify', mid, 'e2e_test_kind.jsonl'), encoding='utf-8'):
            try:
                x = json.loads(ln)
            except ValueError:
                continue
            if x.get('run') == env.get('VERIFY_RUN_ID') and x.get('blocked'):
                viol.add((x.get('file', ''), x.get('title', '')))
    except OSError:
        pass
    redo = [t for t in read if (t[0], t[2]) in viol]
    if redo:
        print(f"[INFO] 동시 실행 단계에서 쓰기 요청이 나온 시험 {len(redo)}개 → 차례 실행에서 다시: " + ' | '.join(t[2] for t in redo)[:300], flush=True)
    todo = serial + redo
    if todo:
        rp = os.path.join(e2e_out, 'results_serial.json'); reports.append(rp)
        e = dict(env, E2E_SHARD='serial', E2E_RESULTS=os.path.join(e2e_out, 'serial'), PLAYWRIGHT_JSON_OUTPUT_NAME=rp); e.pop('E2E_PHASE', None)
        cmd = ['node', os.path.join('node_modules', '@playwright', 'test', 'cli.js'), 'test', *spec_files, '--grep', grep_of(todo), *tier_inv, '--workers', '1', '--reporter=list,json']
        logf = open(os.path.join(e2e_out, 'serial.log'), 'w', encoding='utf-8')
        p = subprocess.Popen(cmd, cwd=e2e_dir, env=e, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        th = threading.Thread(target=_pump, args=(p, '차례', counter, lock, logf), daemon=True); th.start()
        rc_all = max(rc_all, p.wait() or 0); th.join(timeout=30); logf.close()
    merge_reports(reports, os.path.join(e2e_out, 'results.json'))
    finalize_req_notes(mid, env.get('VERIFY_RUN_ID', ''), os.path.join(out_dir, 'e2e_results.json'))
    print(f"[시간] E2E 나눠 실행 · 읽기 {round((t1 - t0) / 60, 1)}분(작업자 {len(bins)}) · 차례 {round((time.time() - t1) / 60, 1)}분(시험 {len(todo)}) · 합계 {round((time.time() - t0) / 60, 1)}분", flush=True)
    return rc_all


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok = ok and bool(c)
    t = [('_verify.spec.ts', '정합검증 X @verify 합계 값(A3)', '합계 값(A3)'), ('_verify.spec.ts', '정합검증 X @verify 조회 전 합계 값(A3)', '조회 전 합계 값(A3)'), ('_trace.spec.ts', '추적 X @trace a.b(c)', 'a.b(c)')]
    g = re.compile(grep_of(t[:1]))
    chk('grep: 같은 꼬리 다른 시험은 고르지 않음', g.search('정합검증 X @verify 합계 값(A3)') and not g.search('정합검증 X @verify 조회 전 합계 값(A3)'))
    chk('grep: 특수 문자 이스케이프', re.compile(grep_of(t[2:])).search('추적 X @trace a.b(c)') and not re.compile(grep_of(t[2:])).search('추적 X @trace aXb(c)'))
    b, load = balance(t, {'합계 값(A3)': 300000, '조회 전 합계 값(A3)': 100000, 'a.b(c)': 100000}, 2)
    chk('묶음: 긴 시험 따로 · 나머지 함께', len(b) == 2 and sorted(len(x) for x in b) == [1, 2] and sorted(load) == [200000, 300000])
    import tempfile, shutil
    d = tempfile.mkdtemp()
    try:
        p1 = os.path.join(d, 'a.json'); p2 = os.path.join(d, 'b.json')
        json.dump({'config': {'x': 1}, 'suites': [{'title': 'A'}], 'errors': [], 'stats': {'expected': 2, 'duration': 10.5, 'startTime': 's'}}, open(p1, 'w'))
        json.dump({'suites': [{'title': 'B'}], 'errors': ['e'], 'stats': {'expected': 3, 'duration': 4}}, open(p2, 'w'))
        merge_reports([p1, p2, os.path.join(d, 'none.json')], os.path.join(d, 'r.json')); r = json.load(open(os.path.join(d, 'r.json')))
        chk('보고서 합치기: 묶음 2 · 건수 합 · 오류 합', [s['title'] for s in r['suites']] == ['A', 'B'] and r['stats']['expected'] == 5 and r['errors'] == ['e'] and r['config'] == {'x': 1})
    finally:
        shutil.rmtree(d, ignore_errors=True)
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(selftest() if '--selftest' in sys.argv else 0)
