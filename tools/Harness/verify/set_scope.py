"""보완 범위 환경설정 — tools/Harness/harness.json 의 repairScope 를 읽고 쓴다(단일 원천)

  python tools/Harness/verify/set_scope.py            현재 값 출력
  python tools/Harness/verify/set_scope.py DB         DB MODE    (저장값 DB_ONLY) — DB·META 만 개발·수정, FE·BE 는 가이드만
  python tools/Harness/verify/set_scope.py UIDB       UI/DB MODE (저장값 DB_FE)   — 제약 없이 개발·수정
  python tools/Harness/verify/set_scope.py --selftest 임시 harness.json, 임시 events.jsonl 로 기록 시험(실제 작업 모드 안 바꿈)
  --path <harness.json> · --events <events.jsonl> 로 대상 파일을 바꿀 수 있다.
  DB_ONLY · DB_FE 도 그대로 받는다. 이 값은 Vibe_Manager 환경설정 🧭 작업 모드의 단일 원천이다(2026-11-02).
공통 컴포넌트(@shared·@foundation)는 어느 값이든 가이드만 — 보완 프롬프트(🛠️·🧯·🩹)와 make_verify_docs.py 가 이 값을 읽는다.
2026-11-26 개선안 20261126180322_VISION: 값이 바뀌면 .vibe/orch/events.jsonl 에 scope.change 1줄을 남긴다(전환일 기준 시각).
  바꾸는 값이 DB_FE 이면 전환 전 점검 3줄(종료 전 게이트 기준선, 생성기 자체 시험, 자가진단 S2)을 출력한다. 점검 결과로 전환을 막지 않는다.
"""
import json
import os
import sys
import tempfile
import time
from datetime import datetime

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'harness.json'))
EVENTS = os.path.join(ROOT, '.vibe', 'orch', 'events.jsonl')
CHOICES = {'DB_ONLY': 'DB MODE — DB·META 만 개발·수정, FE·BE 는 가이드만 · Git Download & Merge 로컬 소스 보호 안 함 · 클라우드 이관 DB 만',
           'DB_FE': 'UI/DB MODE — 제약 없이 개발·수정 · Git Download & Merge 로컬 소스 보호 · 클라우드 이관 DB + FE·BE'}
ALIASES = {'DB': 'DB_ONLY', 'DB_MODE': 'DB_ONLY', 'DB MODE': 'DB_ONLY', 'DB_ONLY': 'DB_ONLY', 'UIDB': 'DB_FE', 'UI/DB': 'DB_FE', 'UI_DB': 'DB_FE', 'UI/DB MODE': 'DB_FE', 'UIDB_MODE': 'DB_FE', 'DB_FE': 'DB_FE'}


def now_local():
    return datetime.now().astimezone().isoformat(timespec='seconds')


def append_event(events, before, after):
    os.makedirs(os.path.dirname(events), exist_ok=True)
    rec = {'at': now_local(), 'ms': int(time.time() * 1000), 'type': 'scope.change', 'src': 'set_scope.py', 'before': before, 'after': after, 'by': 'set_scope.py'}
    with open(events, 'a', encoding='utf-8') as f:
        f.write(json.dumps(rec, ensure_ascii=False) + '\n')


def precheck(root):
    """UI/DB MODE 전환 전 점검 3줄. 파일이 없으면 '없음'으로 적는다(전환을 막지 않음)"""
    out = []
    base = os.path.join(root, 'tools', 'Harness', 'gate_baseline.tsv')
    try:
        with open(base, encoding='utf-8-sig') as f:
            head = f.readline().strip()
            n = sum(1 for ln in f if ln.strip() and not ln.startswith('#'))
        out.append(f'[점검 1] 종료 전 게이트 기준선: {head.lstrip("# ")} · 화면 파일 {n}개 ({base})')
    except OSError:
        out.append(f'[점검 1] 종료 전 게이트 기준선 없음 ({base})')
    eng = os.path.join(root, 'Doc', 'verify', '_engine_selfcheck.json')
    try:
        with open(eng, encoding='utf-8-sig') as f:
            d = json.load(f)
        g = (d.get('meta') or {}).get('gen_smoke') or {}
        out.append(f'[점검 2] 생성기 자체 시험(GEN_SMOKE): {g.get("result", "기록 없음")} {g.get("at", "")} · 엔진 자체 점검 {d.get("result", "?")} {d.get("at", "")} ({eng})')
    except (OSError, ValueError):
        out.append(f'[점검 2] 생성기 자체 시험 기록 없음 ({eng})')
    res = os.path.join(root, '.vibe', 'orch', 'selfcheck', 'result.json')
    try:
        with open(res, encoding='utf-8-sig') as f:
            s2 = (json.load(f).get('checks') or {}).get('S2') or {}
        i = s2.get('info') or {}
        out.append(f'[점검 3] 자가진단 S2 시험: {s2.get("status", "기록 없음")} {s2.get("at", "")} · 파일 {i.get("ok", "?")}/{i.get("files", "?")} 통과, FAIL {i.get("fail", "?")} ({res})')
    except (OSError, ValueError):
        out.append(f'[점검 3] 자가진단 S2 기록 없음 ({res})')
    return out


def run(args, path, events, root):
    with open(path, encoding='utf-8-sig') as f:
        cfg = json.load(f)
    if not args or not ' '.join(args).strip():
        cur = cfg.get('repairScope', 'DB_ONLY')
        print(f'repairScope = {cur} — {CHOICES.get(cur, "?")}')
        return 0
    v = ALIASES.get(' '.join(args).strip().upper())
    if v not in CHOICES:
        print(f'[FAIL] 값은 DB 또는 UIDB (입력: {args[0]})')
        return 2
    if v == 'DB_FE':
        print('UI/DB MODE 전환 전 점검(전환을 막지 않음)')
        for ln in precheck(root):
            print('  ' + ln)
    before = cfg.get('repairScope', 'DB_ONLY')
    cfg['repairScope'] = v
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(cfg, f, ensure_ascii=False, indent=2)
        f.write('\n')
    if before != v:
        append_event(events, before, v)
        print(f'repairScope {before} → {v} — {CHOICES[v]}  ({path}) · 전환 기록 {events}')
    else:
        print(f'repairScope {before} → {v} — {CHOICES[v]}  ({path}) · 같은 값이라 전환 기록 없음')
    return 0


def selftest():
    ok = True

    def chk(name, cond, extra=''):
        nonlocal ok
        print(('PASS' if cond else 'FAIL'), name, extra)
        ok = ok and bool(cond)
    d = tempfile.mkdtemp(prefix='setscope-')
    hp = os.path.join(d, 'harness.json')
    ev = os.path.join(d, 'events.jsonl')
    with open(hp, 'w', encoding='utf-8') as f:
        json.dump({'repairScope': 'DB_ONLY', 'orch': {'x': 1}}, f)
    lines = lambda: open(ev, encoding='utf-8').read().splitlines() if os.path.exists(ev) else []
    chk('DB_ONLY → DB_FE 종료 코드 0', run(['UIDB'], hp, ev, d) == 0)
    L = lines()
    rec = json.loads(L[0]) if L else {}
    chk('전환 기록 1줄', len(L) == 1 and rec.get('type') == 'scope.change' and rec.get('before') == 'DB_ONLY' and rec.get('after') == 'DB_FE' and rec.get('by') == 'set_scope.py', str(rec))
    chk('harness 값 DB_FE, 다른 키 유지', json.load(open(hp, encoding='utf-8')) == {'repairScope': 'DB_FE', 'orch': {'x': 1}})
    run(['DB_FE'], hp, ev, d)
    chk('같은 값 재지정 = 기록 0줄 추가', len(lines()) == 1, str(len(lines())))
    run(['DB'], hp, ev, d)
    chk('DB_FE → DB_ONLY 기록 1줄 추가', len(lines()) == 2 and json.loads(lines()[1]).get('after') == 'DB_ONLY')
    chk('잘못된 값 = 종료 코드 2, 기록 없음', run(['XX'], hp, ev, d) == 2 and len(lines()) == 2)
    pc = precheck(d)
    chk('점검 3줄(파일 없는 임시 폴더 = 없음 표시)', len(pc) == 3 and all('없음' in x for x in pc), ' / '.join(pc))
    try:
        for n in os.listdir(d):
            os.remove(os.path.join(d, n))
        os.rmdir(d)
    except OSError:
        pass
    print('ALL PASS' if ok else 'SOME FAIL')
    return 0 if ok else 1


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    path, events = PATH, EVENTS
    if '--path' in a:
        i = a.index('--path'); path = os.path.abspath(a[i + 1]); del a[i:i + 2]
    if '--events' in a:
        i = a.index('--events'); events = os.path.abspath(a[i + 1]); del a[i:i + 2]
    return run(a, path, events, ROOT)


if __name__ == '__main__':
    sys.exit(main())
