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
    3) Playwright JSON 보고서를 합쳐 e2e/results.json 하나로. 필수 조건 자동 채움 행 판정은 run_verify 가 이 함수(finalize_req_notes)로 한 번 한다
  결과 파일(e2e_results.json · combo_runtime.json · index_verify.json)은 스펙 쪽 파일 잠금(withFileLock)으로 합친다
  끄기 = harness.json e2eReadPar 1

  2026-11-20 사용자 지시 '읽기 시험은 작업자 10개를 설정하고 부하에 따라 조정 · 작업자 10명의 아이디가 없으면 있는 아이디만큼을 최대치'
                       '서로 연관된 기능은 하나의 아이디로, 연관되지 않은 기능은 각각의 아이디로 병렬' · '몇개의 계정을 각각의 개인화 설정으로 인지하면 문제되지 않음'
    - 작업자 최대 = harness.json e2eReadPar(기본 10). 실제 = min(최대, 쓸 수 있는 계정 수, 묶음 수)
    - 계정 = 작업자 1 은 기본 계정(E2E_ACCOUNT, e2e.config forceAccount, defaultAccount), 나머지는 users.json adminPool.users(기본 계정과 사업부 권한이 같은 ADMIN)에서
      다른 시험 계정(영역 명부, 화면 지정, GUEST)을 빼고, 다른 실행이 잡은 계정(잠금 Doc/e2e/_run.langacct.<USER>.lock, 언어 시험과 같은 잠금)도 뺀다
    - 연관 기능 묶음 = 같은 스펙 파일에서 시험 제목의 첫 규칙 번호(A5, SC1, X-ROW 등)가 같은 시험. 규칙 번호가 없는 시험은 혼자 한 묶음. 한 묶음은 한 실행(한 계정) 안에서만 돈다
    - 부하 조절 = 작업자를 한 번에 하나씩 늘린다. 늘리기 전 CPU 사용률 < verifyLoadCpuMax(80) 이고 여유 메모리 >= verifyLoadMemFreeMinMB(3072MB)일 때만
      (tools/E2E/e2e.config.json, CheckList 입장과 같은 값). 늘린 뒤 e2eReadRampSec(기본 20초) 동안은 더 늘리지 않음. 작업자 0개면 부하와 무관하게 1개 시작
    - 일 단위 = 묶음 여러 개(예상 소요 합 >= 전체 / (작업자 최대 x 2)) → Playwright 실행 1회. 끝난 작업자 자리는 같은 계정으로 다음 일을 받는다(부하 기준을 넘으면 받지 않음)
"""
import csv, hashlib, json, os, re, subprocess, sys, threading, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)
TEST_LINE = re.compile(r'^\s+(ok|x|✘|-|✓)\s+(\d+)\s+(.*)$')


def _json(p):
    try:
        return json.load(open(p, encoding='utf-8-sig'))
    except (OSError, ValueError):
        return {}


def cfg_par():
    """읽기 작업자 최대(harness.json e2eReadPar, 기본 10, 2026-11-20 사용자 지시 3 → 10)"""
    try:
        v = _json(os.path.join(ROOT, 'tools', 'Harness', 'harness.json')).get('e2eReadPar')
        return max(1, int(10 if v is None else v))
    except (ValueError, TypeError):
        return 10


def cfg_load():
    """(CPU 상한 %, 여유 메모리 하한 MB, 작업자 늘린 뒤 대기 초) — e2e.config.json 의 CheckList 입장 기준과 같은 값"""
    e = _json(os.path.join(ROOT, 'tools', 'E2E', 'e2e.config.json')); h = _json(os.path.join(ROOT, 'tools', 'Harness', 'harness.json'))
    try:
        return float(e.get('verifyLoadCpuMax', 80)), int(e.get('verifyLoadMemFreeMinMB', 3072)), int(h.get('e2eReadRampSec', 20))
    except (ValueError, TypeError):
        return 80.0, 3072, 20


# 계정(2026-11-20)
LOCK_DIR = os.path.join(ROOT, 'Doc', 'e2e')


def _lock_path(u):
    return os.path.join(LOCK_DIR, '_run.langacct.' + re.sub(r'[^A-Za-z0-9._-]', '_', u) + '.lock')   # tools/E2E/lib/langacct.ts LK 와 같은 이름(언어 시험과 서로 비켜 감)


def _pid_alive(pid):
    try:
        pid = int(pid)
    except (TypeError, ValueError):
        return False
    if pid <= 0:
        return False
    if pid == os.getpid():
        return True
    try:
        return f'"{pid}"' in subprocess.run(['tasklist', '/FI', f'PID eq {pid}', '/FO', 'CSV', '/NH'], capture_output=True, text=True, timeout=20).stdout
    except Exception:
        return True   # 확인 못 함 = 살아 있다고 봄(남의 계정을 빼앗지 않음)


def default_account(env):
    cfg = _json(os.path.join(ROOT, 'tools', 'E2E', 'e2e.config.json'))
    return str(env.get('E2E_ACCOUNT') or cfg.get('forceAccount') or cfg.get('defaultAccount') or '').strip()


def reserved_accounts(env):
    """langacct.ts reservedAccounts() 와 같은 기준 — 다른 시험이 로그인하는 계정 + 기본 계정"""
    uj = _json(os.path.join(ROOT, 'tools', 'E2E', 'users.json')); cfg = _json(os.path.join(ROOT, 'tools', 'E2E', 'e2e.config.json')); out = set()
    skip = re.compile(r'^_|note|doc|updated|mode|conds|extracted|appliesTo|roles|groupDisabled', re.I)

    def walk(v):
        if isinstance(v, str):
            if v.strip():
                out.add(v.strip().lower())
        elif isinstance(v, list):
            for x in v:
                walk(x)
        elif isinstance(v, dict):
            for k, x in v.items():
                if not skip.search(k):
                    walk(x)
    for a in (uj.get('areas') or {}).values():
        if isinstance(a, dict):
            walk(a.get('divisions')); walk(a.get('admins'))
    for sc in (uj.get('screens') or {}).values():
        if isinstance(sc, dict):
            walk(sc.get('accounts')); walk(sc.get('extra'))
    walk(uj.get('guestAccount'))
    for k in ('defaultAccount', 'forceAccount'):
        if cfg.get(k):
            out.add(str(cfg[k]).lower())
    if env.get('E2E_ACCOUNT'):
        out.add(env['E2E_ACCOUNT'].lower())
    if (uj.get('adminPool') or {}).get('default'):
        out.add(str(uj['adminPool']['default']).lower())
    return out


def take_accounts(env, n, tag):
    """[기본 계정, 잡은 명부 계정 …] 최대 n 개. 명부 계정은 잠금 파일을 원자적으로 만들어 잡는다(주인 = 이 프로세스)"""
    first = default_account(env); got = [first] if first else []
    if n <= len(got):
        return got[:max(n, 1)]
    pool = [str(u) for u in ((_json(os.path.join(ROOT, 'tools', 'E2E', 'users.json')).get('adminPool') or {}).get('users') or []) if str(u).strip()]
    rs = reserved_accounts(env); os.makedirs(LOCK_DIR, exist_ok=True)
    for u in pool:
        if len(got) >= n:
            break
        if u.lower() in rs:
            continue
        lk = _lock_path(u); me = {'pid': os.getpid(), 'at': int(time.time() * 1000), 'tag': tag, 'user': u, 'orig': ''}
        try:
            fd = os.open(lk, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
            with os.fdopen(fd, 'w', encoding='utf-8') as f:
                json.dump(me, f)
            got.append(u); continue
        except FileExistsError:
            pass
        except OSError:
            continue
        old = _json(lk)
        if not old or _pid_alive(old.get('pid')):
            continue                                    # 다른 실행이 쓰는 중(막 만들어 내용이 없는 잠금 포함)
        if old.get('orig') and old.get('restored') is False:
            continue                                    # 언어를 못 되돌린 계정 = 언어 시험이 먼저 되돌려야 함
        try:
            json.dump(me, open(lk, 'w', encoding='utf-8'))
            if (_json(lk) or {}).get('pid') == os.getpid():
                got.append(u)
        except OSError:
            continue
    return got


def release_accounts(users):
    for u in users:
        lk = _lock_path(u)
        if (_json(lk) or {}).get('pid') == os.getpid():
            try:
                os.remove(lk)
            except OSError:
                pass


# 연관 기능 묶음(2026-11-20)
RULE_IN_TITLE = re.compile(r'(?<![A-Za-z0-9])([A-N]\d{1,2}|SC\d|X-[A-Z]+)(?![0-9])')


def group_key(t):
    m = RULE_IN_TITLE.search(t[2] or '')
    return ('rule', t[0], m.group(1).upper()) if m else ('test', t[0], t[1])


def groups_of(tests, dur):
    """[(시험 목록, 예상 ms)] 긴 묶음부터 — 같은 스펙 파일 안에서 제목의 첫 규칙 번호가 같으면 한 묶음"""
    g = {}
    for t in tests:
        g.setdefault(group_key(t), []).append(t)
    out = [(v, sum(dur.get(t[2], 60000) for t in v)) for v in g.values()]
    return sorted(out, key=lambda x: -x[1])


def next_job(queue, target):
    """줄 앞(긴 묶음)부터 꺼내 예상 합이 target 이상이 되면 멈춘다(최소 1묶음)"""
    job, ms = [], 0
    while queue and (not job or ms < target):
        v, m = queue.pop(0); job += v; ms += m
    return job, ms


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


def read_api_rx():
    """tools/E2E/lib/writeguard.ts 의 READ_API 정규식(단일 원천) · 못 읽으면 None(기록값 그대로)"""
    try:
        src = open(os.path.join(ROOT, 'tools', 'E2E', 'lib', 'writeguard.ts'), encoding='utf-8').read()
        m = re.search(r'^const READ_API = /(.+)/([a-z]*);', src, re.M)
        return re.compile(m.group(1).replace('\/', '/'), re.I if 'i' in m.group(2) else 0) if m else None
    except (OSError, re.error):
        return None


def _still_write(u, rx):
    """기록 주소 1개가 지금 기준으로도 쓰기인가 — 저장 call-proc 은 기록 때 판정(가짜 응답 여부 포함)을 그대로 따름"""
    if re.search(r'/call-proc(?:-stream)?(?:\?|$)', u, re.I):
        return True
    return not rx.search(u)


def kinds(mid):
    """{(file, title): 'read'|'write'} — 차례 실행 기록의 마지막 값. 동시 실행 단계 위반(blocked)은 쓰기"""
    p = os.path.join(ROOT, 'Doc', 'verify', mid, 'e2e_test_kind.jsonl'); out = {}
    rx = read_api_rx()
    try:
        for ln in open(p, encoding='utf-8'):
            try:
                x = json.loads(ln)
            except ValueError:
                continue
            k = (x.get('file', ''), x.get('title', ''))
            if x.get('phase') == 'serial':      # 차례 실행 기록이 기준(마지막 값)
                w = bool(x.get('write'))
                if w and rx and len(x.get('urls') or []) < 8:   # 2026-11-20: 기록한 쓰기 주소를 지금 읽기 목록(writeguard.ts READ_API)으로 다시 판정 — 읽기 목록을 넓히면 다음 실행부터 바로 반영
                    w = any(_still_write(u, rx) for u in (x.get('urls') or []))
                out[k] = 'write' if w else 'read'
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


def _spec_key(file_, path, sp):
    return (os.path.basename(sp.get('file') or file_ or ''), ' '.join(path + [sp.get('title', '')]))


def merge_reports(paths, out):
    """보고서 여러 개 → 하나. 2026-11-20 작업 재개(R3): 같은 시험(파일, 묶음 제목 + 시험 제목)이 둘 이상이면 뒤 보고서 것만 남기고,
       결과가 interrupted 뿐인 항목(끊긴 프로세스가 남긴 것)은 버린다. 건수(stats expected, unexpected, flaky, skipped)는 남은 항목으로 다시 센다"""
    reps, errors, stats, cfg = [], [], {}, None
    for p in paths:
        try:
            j = json.load(open(p, encoding='utf-8'))
        except (OSError, ValueError):
            continue
        reps.append(j); cfg = cfg or j.get('config'); errors += j.get('errors', [])
        for k, v in (j.get('stats') or {}).items():
            if isinstance(v, (int, float)) and not isinstance(v, bool):
                stats[k] = (stats.get(k) or 0) + v
            elif k not in stats:
                stats[k] = v
    last = {}

    def mark(s, path, file_, ri):
        file_ = s.get('file') or file_
        t = s.get('title') or ''
        p2 = path + ([t] if t and not t.endswith('.ts') else [])
        for sp in s.get('specs', []):
            for t_ in sp.get('tests', []):
                t_['results'] = [r for r in (t_.get('results') or []) if r.get('status') != 'interrupted']
            if any(t_.get('results') for t_ in sp.get('tests', [])):
                last[_spec_key(file_, p2, sp)] = (ri, id(sp))
        for c in s.get('suites', []):
            mark(c, p2, file_, ri)
    for ri, j in enumerate(reps):
        for s in j.get('suites', []):
            mark(s, [], '', ri)
    cnt = {'expected': 0, 'unexpected': 0, 'flaky': 0, 'skipped': 0}

    def keep(s, path, file_, ri):
        file_ = s.get('file') or file_
        t = s.get('title') or ''
        p2 = path + ([t] if t and not t.endswith('.ts') else [])
        specs = []
        for sp in s.get('specs', []):
            if last.get(_spec_key(file_, p2, sp)) != (ri, id(sp)):
                continue
            specs.append(sp)
            for t_ in sp.get('tests', []):
                rs = t_.get('results') or []
                st = rs[-1].get('status') if rs else ''
                k = 'skipped' if st == 'skipped' else ('flaky' if st == 'passed' and len(rs) > 1 else ('expected' if st == 'passed' else 'unexpected'))
                cnt[k] += 1
        subs = [x for x in (keep(c, p2, file_, ri) for c in s.get('suites', [])) if x]
        if not specs and not subs:
            return None
        return dict(s, specs=specs, suites=subs)
    suites = []
    for ri, j in enumerate(reps):
        suites += [x for x in (keep(s, [], '', ri) for s in j.get('suites', [])) if x]
    stats.update(cnt)
    json.dump({'config': cfg or {}, 'suites': suites, 'errors': errors, 'stats': stats}, open(out, 'w', encoding='utf-8'), ensure_ascii=False)


# 2026-11-20 작업 재개(플랜 vm-ui-snug-mountain R3 2.3): 끊긴 E2E 를 같은 실행 ID 로 다시 돌릴 때 끝난 시험은 건너뛴다.
#   끝난 시험 = 이번 실행 ID(vrun)의 _test_timing.jsonl 마지막 기록이 passed, skipped 이거나, failed, timedOut 이면서 재시도를 다 쓴 것(retry ≥ rmax).
#   동시 실행 단계(read)에서 쓰기 요청을 끊은 시험(wblocked)은 차례 실행에서 다시 돌아야 하므로 끝나지 않은 것으로 본다. interrupted 도 끝나지 않은 것.
#   끝난 시험의 Playwright 보고서 항목은 기록으로 다시 만든다(results_carry.json, 상태, 오류 문구 첫 500자, 소요)
DONE_OK = ('passed', 'skipped')
DONE_FAIL = ('failed', 'timedOut')


def run_records(mid, run_id):
    """{(file, full): [기록 …]}, 이번 실행(vrun == run_id)의 시험 기록, 쓴 순서"""
    out = {}
    if not run_id:
        return out
    try:
        for ln in open(os.path.join(ROOT, 'Doc', 'verify', mid, '_test_timing.jsonl'), encoding='utf-8'):
            try:
                x = json.loads(ln)
            except ValueError:
                continue
            if not isinstance(x, dict) or x.get('vrun') != run_id or not x.get('full'):
                continue
            out.setdefault((x.get('file', ''), x['full']), []).append(x)
    except OSError:
        pass
    return out


def is_done(recs):
    if not recs:
        return False
    x = recs[-1]; st = x.get('status')
    if x.get('wblocked'):
        return False
    if st in DONE_OK:
        return True
    if st in DONE_FAIL:
        try:
            return int(x.get('retry') or 0) >= int(x.get('rmax') or 0)
        except (TypeError, ValueError):
            return False
    return False


def last_attempts(recs):
    """마지막 시도 묶음(마지막 retry 0 기록부터 끝까지), 끊겨 버려진 앞 시도는 뺀다"""
    i = max((k for k, x in enumerate(recs) if int(x.get('retry') or 0) == 0), default=0)
    return recs[i:]


def done_tests(mid, run_id):
    """{(file, full): [마지막 시도 기록 …]}, 끝난 시험만"""
    return {k: last_attempts(v) for k, v in run_records(mid, run_id).items() if is_done(v)}


def carry_report(done, out):
    """끝난 시험 기록 → Playwright JSON 보고서 형식(results_carry.json). 반환 = 시험 수"""
    files = {}
    for (file_, full), recs in sorted(done.items()):
        x = recs[-1]; tp = list(x.get('tp') or []); title = x.get('title') or full
        res = []
        for r in recs:
            err = str(r.get('err') or '')[:500]
            rr = {'workerIndex': 0, 'status': r.get('status'), 'duration': int(((r.get('ms') or {}).get('total')) or 0), 'retry': int(r.get('retry') or 0),
                  'startTime': r.get('at') or '', 'errors': [{'message': err}] if err else [], 'attachments': [], 'stdout': [], 'stderr': [],
                  'annotations': list(r.get('ann') or [])}
            if err:
                rr['error'] = {'message': err}
            res.append(rr)
        st = res[-1]['status']
        test = {'timeout': 0, 'annotations': list(x.get('ann') or []), 'expectedStatus': 'skipped' if st == 'skipped' else 'passed', 'projectId': '', 'projectName': '',
                'results': res, 'status': 'skipped' if st == 'skipped' else ('flaky' if st == 'passed' and len(res) > 1 else ('expected' if st == 'passed' else 'unexpected'))}
        spec = {'title': title, 'ok': st in DONE_OK, 'tags': [], 'tests': [test], 'id': '', 'file': file_, 'line': 0, 'column': 0, 'carried': True}
        node = files.setdefault(file_, {'title': file_, 'file': file_, 'line': 0, 'column': 0, 'specs': [], 'suites': []})
        for d in tp:
            nxt = next((c for c in node['suites'] if c.get('title') == d), None)
            if nxt is None:
                nxt = {'title': d, 'file': file_, 'line': 0, 'column': 0, 'specs': [], 'suites': []}; node['suites'].append(nxt)
            node = nxt
        node['specs'].append(spec)
    json.dump({'config': {}, 'suites': list(files.values()), 'errors': [], 'stats': {}}, open(out, 'w', encoding='utf-8'), ensure_ascii=False)
    return len(done)


def resume_split(mid, run_id, tests, out_dir):
    """재개: (남은 시험, results_carry.json 경로), 이번 목록 중 끝난 시험의 보고서 항목을 results_carry.json 으로"""
    keys = {(t[0], t[1]) for t in tests}
    done = {k: v for k, v in done_tests(mid, run_id).items() if k in keys}
    left = [t for t in tests if (t[0], t[1]) not in done]
    cp = os.path.join(out_dir, 'e2e', 'results_carry.json'); os.makedirs(os.path.dirname(cp), exist_ok=True)
    n = carry_report(done, cp)
    print(f"[재개] E2E 실행 ID {run_id}: 시험 {len(tests)}개 중 끝난 시험 {n}개 건너뜀(기록으로 보고서 항목, e2e/results_carry.json), 남은 시험 {len(left)}개", flush=True)
    return left, cp


def tier_invert(tier_args):
    return ['--grep-invert', tier_args[tier_args.index('--grep-invert') + 1]] if '--grep-invert' in tier_args else []


def run_serial_resume(mid, env, spec_files, tier_args, out_dir, e2e_dir):
    """차례 실행(나눠 실행 조건 아님, --only)의 재개: 남은 시험만 --grep 으로 돌리고 results_carry.json 과 합쳐 e2e/results.json.
       반환 = 종료코드, None(시험 목록을 못 읽음 → 호출자가 처음부터 차례 실행)"""
    tests = list_tests(e2e_dir, env, spec_files, tier_args)
    if not tests:
        print('[재개] 시험 목록을 못 읽음 → 이 단계 시험을 처음부터 실행', flush=True); return None
    left, cp = resume_split(mid, env.get('VERIFY_RUN_ID', ''), tests, out_dir)
    e2e_out = os.path.join(out_dir, 'e2e'); rp = os.path.join(e2e_out, 'results_resume.json'); rc = 0
    try:
        os.remove(rp)
    except OSError:
        pass
    if left:
        e = dict(env, PLAYWRIGHT_JSON_OUTPUT_NAME=rp)
        cmd = ['node', os.path.join('node_modules', '@playwright', 'test', 'cli.js'), 'test', *spec_files, '--grep', grep_of(left), *tier_invert(tier_args), '--workers', '1', '--reporter=list,json']
        print('$ ' + ' '.join(cmd[:4]) + f' --grep <남은 시험 {len(left)}개> ' + ' '.join(tier_invert(tier_args)), flush=True)
        rc = subprocess.call(cmd, cwd=e2e_dir, env=e)
    merge_reports([cp, rp], os.path.join(e2e_out, 'results.json'))
    return rc


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


REC_LINKS = []


def rec_report(e2e_out):
    """나눠 실행에서 녹화가 있으면 위치를 한 번에(2026-11-20 사용자 지시 'AS-IS, TO-BE 녹화완료되면 위치 알려주세요')"""
    dirs = [ln.split('|', 1)[1].strip() for ln in REC_LINKS if '|' in ln]
    if not dirs:
        return
    for d in dirs:
        print(f'[TO-BE 녹화] {os.path.relpath(d, ROOT)}', flush=True)
    print(f'@@LINK 🎬 TO-BE 녹화(실행 {len(dirs)}회, 각 read*·serial 아래 video)|{os.path.relpath(e2e_out, ROOT)}', flush=True)
    del REC_LINKS[:]


def _pump(proc, tag, counter, lock, logf):
    for raw in iter(proc.stdout.readline, b''):
        ln = raw.decode('utf-8', 'replace').rstrip('\r\n')
        with lock:
            try:
                logf.write(ln + '\n')
            except Exception:
                pass
            if ln.startswith('@@LINK'):          # 2026-11-20 녹화 위치(video_keep.js) — 실행마다 찍히므로 모아 두었다가 끝에 한 번
                REC_LINKS.append(ln); continue
            m = TEST_LINE.match(ln)
            if m:
                counter[0] += 1; print(f"  {m.group(1)} {counter[0]} {m.group(3)}  [{tag}]", flush=True)
            elif ln.strip():
                print(f"[{tag}] {ln}", flush=True)


def run(mid, env, spec_files, tier_args, out_dir, e2e_dir, resume=False):
    par = cfg_par()
    if par <= 1:
        return None
    tests = list_tests(e2e_dir, env, spec_files, tier_args)
    if not tests:
        print('[INFO] 나눠 실행 안 함: 시험 목록을 못 읽음 → 차례 실행', flush=True); return None
    carry = []
    if resume:  # 2026-11-20 작업 재개: 이번 실행 ID 로 끝난 시험은 빼고 보고서 항목은 기록으로(results_carry.json)
        all_n = len(tests); tests, cp = resume_split(mid, env.get('VERIFY_RUN_ID', ''), tests, out_dir); carry = [cp]
        if not tests:
            merge_reports(carry, os.path.join(out_dir, 'e2e', 'results.json'))
            print(f'[재개] 시험 {all_n}개 모두 끝남, Playwright 실행 없음', flush=True); return 0
    kd = kinds(mid)
    read = [t for t in tests if kd.get((t[0], t[2])) == 'read']; serial = [t for t in tests if t not in read]
    if len(read) < 2:
        print(f'[INFO] 나눠 실행 안 함: 지난 차례 실행 기록으로 확인된 읽기 시험 {len(read)}개(시험 {len(tests)}개) → 차례 실행(이번 실행이 시험 종류를 기록)', flush=True); return None
    dur = durations(mid); tier_inv = tier_invert(tier_args)
    e2e_out = os.path.join(out_dir, 'e2e'); os.makedirs(e2e_out, exist_ok=True)
    grp = groups_of(read, dur); total = sum(m for _v, m in grp)
    accts = take_accounts(env, min(par, len(grp)), f'e2e-read {mid}')
    maxw = max(1, min(par, len(accts) or 1, len(grp)))
    cpu_max, mem_min, ramp = cfg_load(); target = total / (maxw * 2)
    print(f"[INFO] E2E 나눠 실행: 시험 {len(tests)}개 = 읽기 {len(read)}개(연관 기능 묶음 {len(grp)}개, 지난 소요 합 {round(total / 60000, 1)}분) + 차례 {len(serial)}개(쓰기 또는 처음 보는 시험)", flush=True)
    print(f"[INFO] 읽기 작업자 최대 {maxw}개 = min(설정 e2eReadPar {par}, 쓸 수 있는 계정 {len(accts)}개, 묶음 {len(grp)}개) · 계정 {', '.join(accts) or '(기본 계정 없음)'}"
          f" · 늘리는 기준 CPU < {cpu_max:g}%, 여유 메모리 >= {mem_min}MB, 늘린 뒤 {ramp}초 대기", flush=True)
    print(f"Running {len(tests)} tests using up to {maxw} workers(읽기) + 1 worker(차례)", flush=True)
    counter = [0]; lock = threading.Lock(); reports = list(carry); rc_all = 0; t0 = time.time()
    queue = list(grp); slots = {}; runs = [0]; peak = 0; last_up = 0.0; lc = {'at': 0.0, 'v': (None, None), 'said': 0.0}; busy_s = {}

    def load_ok():
        if time.time() - lc['at'] > 10:
            try:
                if HERE not in sys.path:
                    sys.path.insert(0, HERE)
                import run_verify as _rv
                lc['v'] = _rv.load_now()
            except Exception:
                lc['v'] = (None, None)
            lc['at'] = time.time()
        cpu, mem = lc['v']
        return (cpu is not None and cpu < cpu_max and mem is not None and mem >= mem_min), cpu, mem

    def launch(k, acct):
        job, ms = next_job(queue, target); runs[0] += 1; n = runs[0]
        rp = os.path.join(e2e_out, f'results_read{n}.json'); reports.append(rp)
        try:
            os.remove(rp)  # 지난 실행이 남긴 보고서가 이번 합치기에 섞이지 않게
        except OSError:
            pass
        e = dict(env, E2E_PHASE='read', E2E_SHARD=f'read{n}', E2E_RESULTS=os.path.join(e2e_out, f'read{n}'), PLAYWRIGHT_JSON_OUTPUT_NAME=rp)
        if acct:
            e['E2E_ACCOUNT'] = acct
        cmd = ['node', os.path.join('node_modules', '@playwright', 'test', 'cli.js'), 'test', *spec_files, '--grep', grep_of(job), *tier_inv, '--workers', '1', '--reporter=list,json']
        logf = open(os.path.join(e2e_out, f'read{n}.log'), 'w', encoding='utf-8')
        p = subprocess.Popen(cmd, cwd=e2e_dir, env=e, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        th = threading.Thread(target=_pump, args=(p, f'작업자 {k} {acct}', counter, lock, logf), daemon=True); th.start()
        slots[k] = (p, th, logf, time.time())
        with lock:
            print(f"[작업자 {k} · 계정 {acct or '-'}] 일 {n}: 시험 {len(job)}개 · 지난 소요 합 {round(ms / 60000, 1)}분 · 남은 묶음 {len(queue)}개", flush=True)

    try:
        while queue or slots:
            for k in list(slots):                                   # 끝난 일 거두기
                p, th, logf, st = slots[k]
                if p.poll() is not None:
                    rc_all = max(rc_all, p.returncode or 0); th.join(timeout=30); logf.close(); busy_s[k] = busy_s.get(k, 0) + time.time() - st; del slots[k]
            if queue:
                idle = [k for k in range(1, maxw + 1) if k not in slots]
                if idle and not slots:                              # 작업자 0개 = 부하와 무관하게 1개는 돈다
                    launch(idle[0], accts[idle[0] - 1] if accts else ''); last_up = time.time()
                elif idle and time.time() - last_up >= ramp:
                    ok, cpu, mem = load_ok()
                    if ok:
                        launch(idle[0], accts[idle[0] - 1]); last_up = time.time(); lc['at'] = 0.0
                    elif time.time() - lc['said'] > 120:
                        lc['said'] = time.time()
                        with lock:
                            print(f"[부하 조절] 작업자 {len(slots)}개 유지 · CPU {cpu if cpu is not None else '미측정'}% · 여유 메모리 {mem if mem is not None else '미측정'}MB (늘리는 기준 CPU < {cpu_max:g}%, 메모리 >= {mem_min}MB)", flush=True)
            peak = max(peak, len(slots))
            time.sleep(2)
    finally:
        for k, (p, th, logf, st) in list(slots.items()):
            try:
                p.wait(timeout=5)
            except Exception:
                pass
            try:
                logf.close()
            except Exception:
                pass
        release_accounts(accts[1:])
    t1 = time.time()
    print(f"[시간] 읽기 {round((t1 - t0) / 60, 1)}분 · 실행 {runs[0]}회 · 동시 최대 {peak}개 · 작업자별 일한 시간 " + ', '.join(f"{(accts[k - 1] if accts else k)} {round(v / 60, 1)}분" for k, v in sorted(busy_s.items())), flush=True)
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
        try:
            os.remove(rp)
        except OSError:
            pass
        e = dict(env, E2E_SHARD='serial', E2E_RESULTS=os.path.join(e2e_out, 'serial'), PLAYWRIGHT_JSON_OUTPUT_NAME=rp); e.pop('E2E_PHASE', None)
        cmd = ['node', os.path.join('node_modules', '@playwright', 'test', 'cli.js'), 'test', *spec_files, '--grep', grep_of(todo), *tier_inv, '--workers', '1', '--reporter=list,json']
        logf = open(os.path.join(e2e_out, 'serial.log'), 'w', encoding='utf-8')
        p = subprocess.Popen(cmd, cwd=e2e_dir, env=e, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        th = threading.Thread(target=_pump, args=(p, '차례', counter, lock, logf), daemon=True); th.start()
        rc_all = max(rc_all, p.wait() or 0); th.join(timeout=30); logf.close()
    merge_reports(reports, os.path.join(e2e_out, 'results.json'))
    rec_report(e2e_out)
    # 필수 조건 자동 채움 행 확정(finalize_req_notes)은 run_verify 가 E2E 뒤 한 번 한다(2026-11-20: 여기서도 부르면 기록 파일이 지워진 뒤 두 번째 호출이 0건 PASS 로 덮었다)
    print(f"[시간] E2E 나눠 실행 · 읽기 {round((t1 - t0) / 60, 1)}분(작업자 동시 최대 {peak}) · 차례 {round((time.time() - t1) / 60, 1)}분(시험 {len(todo)}) · 합계 {round((time.time() - t0) / 60, 1)}분", flush=True)
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
    # 2026-11-20 연관 기능 묶음, 일 나누기, 계정
    tt = [('_verify.spec.ts', 'X 표시 컬럼(A5) 1', '표시 컬럼(A5) 1'), ('_verify.spec.ts', 'X 표시 컬럼 폭(A5) 2', '표시 컬럼 폭(A5) 2'), ('_verify.spec.ts', 'X 조회조건(G3)', '조회조건(G3)'),
          ('_verify.spec.ts', 'X 규칙 없음', '규칙 없음'), ('_trace.spec.ts', 'Y 표시(A5)', '표시(A5)')]
    gg = groups_of(tt, {'표시 컬럼(A5) 1': 100, '표시 컬럼 폭(A5) 2': 100, '조회조건(G3)': 50, '규칙 없음': 10, '표시(A5)': 10})
    chk('묶음: 같은 스펙 같은 첫 규칙 = 한 묶음, 다른 스펙은 따로, 규칙 없는 시험 혼자', len(gg) == 4 and gg[0][1] == 200 and len(gg[0][0]) == 2)
    q = list(gg); j1, m1 = next_job(q, 150); j2, m2 = next_job(q, 150)
    chk('일 나누기: 묶음을 쪼개지 않고 예상 합 >= 기준까지', len(j1) == 2 and m1 == 200 and m2 == 70 and not q)
    chk('기본 계정 = E2E_ACCOUNT 우선', default_account({'E2E_ACCOUNT': 'zz'}) == 'zz')
    import tempfile, shutil
    d0 = tempfile.mkdtemp(); g0 = globals(); ld0 = g0['LOCK_DIR']
    try:
        g0['LOCK_DIR'] = d0
        pool = [str(u) for u in ((_json(os.path.join(ROOT, 'tools', 'E2E', 'users.json')).get('adminPool') or {}).get('users') or [])]
        free = [u for u in pool if u.lower() not in reserved_accounts({})]
        if len(free) >= 4:
            json.dump({'pid': 99999991, 'user': free[0], 'orig': 'KO', 'restored': False}, open(_lock_path(free[0]), 'w', encoding='utf-8'))
            json.dump({'pid': 4, 'user': free[1]}, open(_lock_path(free[1]), 'w', encoding='utf-8'))   # pid 4 = System(살아 있음)
            a = take_accounts({}, 3, 'selftest')
            chk('계정: 기본 계정 + 언어 원복 대기, 사용 중 계정 건너뜀, 최대 n개', len(a) == 3 and a[0] == default_account({}) and free[0] not in a and free[1] not in a and all(os.path.exists(_lock_path(u)) for u in a[1:]))
            release_accounts(a[1:])
            chk('계정 반납: 이 프로세스 잠금만 지움', not any(os.path.exists(_lock_path(u)) for u in a[1:]) and os.path.exists(_lock_path(free[1])))
        else:
            chk('계정 명부 후보 4개 이상', False)
    finally:
        g0['LOCK_DIR'] = ld0; shutil.rmtree(d0, ignore_errors=True)
    d = tempfile.mkdtemp()
    try:
        p1 = os.path.join(d, 'a.json'); p2 = os.path.join(d, 'b.json')
        json.dump({'config': {'x': 1}, 'suites': [{'title': 'A', 'specs': [{'title': 'a1', 'tests': [{'results': [{'status': 'passed'}]}]}]}], 'errors': [], 'stats': {'expected': 2, 'duration': 10.5, 'startTime': 's'}}, open(p1, 'w'))
        json.dump({'suites': [{'title': 'B', 'specs': [{'title': 'b1', 'tests': [{'results': [{'status': 'failed'}]}]}]}], 'errors': ['e'], 'stats': {'expected': 3, 'duration': 4}}, open(p2, 'w'))
        merge_reports([p1, p2, os.path.join(d, 'none.json')], os.path.join(d, 'r.json')); r = json.load(open(os.path.join(d, 'r.json')))
        chk('보고서 합치기: 묶음 2 · 건수 = 남은 항목으로 다시 셈, 소요 합 · 오류 합', [s['title'] for s in r['suites']] == ['A', 'B'] and r['stats']['expected'] == 1 and r['stats']['unexpected'] == 1 and r['stats']['duration'] == 14.5 and r['errors'] == ['e'] and r['config'] == {'x': 1})
    finally:
        shutil.rmtree(d, ignore_errors=True)
    # 2026-11-20 작업 재개(R3): 끝난 시험 판별, 마지막 시도 묶음, 기록으로 만든 보고서 항목, 합치기(중복은 뒤 것, interrupted 버림, 건수 다시 셈)
    R = lambda st, rt=0, rmax=1, **k: dict({'vrun': 'R1', 'file': '_verify.spec.ts', 'full': 'D a', 'tp': ['D'], 'title': 'a', 'status': st, 'retry': rt, 'rmax': rmax, 'ms': {'total': 1000}, 'err': ''}, **k)
    chk('끝남: passed, skipped', is_done([R('passed')]) and is_done([R('skipped')]))
    chk('끝나지 않음: failed 재시도 남음, interrupted, 빈 기록', not is_done([R('failed', 0, 1)]) and not is_done([R('interrupted')]) and not is_done([]))
    chk('끝남: failed, timedOut 재시도 다 씀', is_done([R('failed', 0, 1), R('failed', 1, 1)]) and is_done([R('timedOut', 0, 0)]))
    chk('끝나지 않음: 동시 실행 단계에서 쓰기 요청 차단(wblocked)', not is_done([R('passed', wblocked=True)]))
    la = last_attempts([R('failed', 0), R('failed', 0, err='x'), R('passed', 1)])
    chk('마지막 시도 묶음 = 마지막 retry 0 부터', len(la) == 2 and la[0]['err'] == 'x' and la[1]['status'] == 'passed')
    d = tempfile.mkdtemp(); g = globals(); root0 = g['ROOT']
    try:
        g['ROOT'] = d; vd = os.path.join(d, 'Doc', 'verify', 'X1'); os.makedirs(vd)
        with open(os.path.join(vd, '_test_timing.jsonl'), 'w', encoding='utf-8') as f:
            for x in [R('passed', full='D a', title='a'), R('failed', 0, full='D b', title='b', err='E' * 900), R('failed', 1, full='D b', title='b', err='boom'),
                      R('failed', 0, full='D c', title='c'), dict(R('passed', full='D a', title='a'), vrun='R0'), R('passed', full='T t', title='t', tp=['T'], file='_trace.spec.ts')]:
                f.write(json.dumps(x, ensure_ascii=False) + '\n')
            f.write('깨진 줄\n')
        dn = done_tests('X1', 'R1')
        chk('기록 판별: a 끝, b 재시도 다 씀 끝, c 재시도 남음, 다른 실행 기록 무시', set(dn) == {('_verify.spec.ts', 'D a'), ('_verify.spec.ts', 'D b'), ('_trace.spec.ts', 'T t')} and len(dn[('_verify.spec.ts', 'D b')]) == 2)
        tests = [('_verify.spec.ts', 'D a', 'a'), ('_verify.spec.ts', 'D b', 'b'), ('_verify.spec.ts', 'D c', 'c'), ('_verify.spec.ts', 'D d', 'd')]
        left, cp = resume_split('X1', 'R1', tests, vd)
        chk('남은 시험 = c, d(목록 밖 끝난 시험은 보고서에 넣지 않음)', [t[2] for t in left] == ['c', 'd'])
        cj = json.load(open(cp, encoding='utf-8'))
        sp = {s_['title']: s_ for s_ in cj['suites'][0]['suites'][0]['specs']}
        chk('보고서 항목: 묶음 D 아래 a, b, b 결과 2개, 오류 문구 500자, 상태', set(sp) == {'a', 'b'} and [r['status'] for r in sp['b']['tests'][0]['results']] == ['failed', 'failed']
            and sp['b']['tests'][0]['results'][-1]['error']['message'] == 'boom' and len(sp['b']['tests'][0]['results'][0]['error']['message']) == 500)
        # 끊긴 프로세스 보고서(c interrupted, a passed) + 기록 보고서(a, b) + 이어 돈 보고서(c failed, d passed) → a 1, b 1, c 1, d 1
        rpt = lambda specs: {'suites': [{'title': '_verify.spec.ts', 'file': '_verify.spec.ts', 'specs': [], 'suites': [{'title': 'D', 'file': '_verify.spec.ts', 'specs': specs, 'suites': []}]}], 'stats': {'duration': 5}}
        spc = lambda t, *st: {'title': t, 'file': '_verify.spec.ts', 'tests': [{'results': [{'status': x} for x in st]}]}
        p0 = os.path.join(d, 'p0.json'); p2 = os.path.join(d, 'p2.json'); out = os.path.join(d, 'm.json')
        json.dump(rpt([spc('a', 'passed'), spc('c', 'interrupted')]), open(p0, 'w', encoding='utf-8'))
        json.dump(rpt([spc('c', 'failed', 'failed'), spc('d', 'failed', 'passed')]), open(p2, 'w', encoding='utf-8'))
        merge_reports([p0, cp, p2], out); m = json.load(open(out, encoding='utf-8'))
        got = []

        def walk(s_, f_=''):
            for x in s_.get('specs', []):
                got.append((x['title'], [r['status'] for r in x['tests'][0]['results']], bool(x.get('carried'))))
            for c in s_.get('suites', []):
                walk(c)
        for s_ in m['suites']:
            walk(s_)
        chk('합치기: 시험마다 1개, 뒤 보고서 우선, interrupted 버림', sorted(got) == [('a', ['passed'], True), ('b', ['failed', 'failed'], True), ('c', ['failed', 'failed'], False), ('d', ['failed', 'passed'], False)])
        chk('합치기 건수 다시 셈: expected 1, unexpected 2, flaky 1', m['stats']['expected'] == 1 and m['stats']['unexpected'] == 2 and m['stats']['flaky'] == 1 and m['stats']['duration'] == 10)
    finally:
        g['ROOT'] = root0; shutil.rmtree(d, ignore_errors=True)
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(selftest() if '--selftest' in sys.argv else 0)
