# -*- coding: utf-8 -*-
"""계획 진행 기록(2026-11-25 사용자 지시 '필요한 작업이 있으면 먼저 전체를 진행하고 테스트를 진행')

  python tools/Harness/plan_state.py set "<계획 이름>" <항목> [<항목> ...]   승인된 계획의 구현 항목 등록(모두 남음)
  python tools/Harness/plan_state.py set --purpose <목적 키> "<계획 이름>" <항목> ...   목적 키(예 checklistTime)를 붙여 등록. VMO 목적 원장(orch-ladder.js purposeLedger)이 남은 구현 항목으로 셈(2026-11-26 개선안 20261126165130_SELF)
  python tools/Harness/plan_state.py done <항목> [<항목> ...]              구현 끝난 항목 표시
  python tools/Harness/plan_state.py drop <항목> "<사유>"                   사용자가 빼라고 한 항목(사유 필수)
  python tools/Harness/plan_state.py status                                  남은 항목 출력(종료코드 0 = 남은 항목 없음, 2 = 남음)
  python tools/Harness/plan_state.py clear                                   계획 끝(시험까지 마침)
  python tools/Harness/plan_state.py --selftest

  파일 = tools/Harness/plan_state.json. 실행 hook .claude/hooks/check-plan-before-test.ps1 이 이 파일을 읽어
  남은 항목이 있으면 화면 측정·통합 시험 명령(run_verify, checklist_run, row_run, run-e2e, e2e_suite, eg_chain, playwright test)을 막는다.
  컴파일 검사·자기 시험(tsc, --selftest, engine_selfcheck, run_all.js)은 막지 않는다
"""
import datetime, json, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))
P = os.path.join(HERE, 'plan_state.json')


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def load(p=None):
    try:
        return json.load(open(p or P, encoding='utf-8'))
    except (OSError, ValueError):
        return {'plan': '', 'items': []}


def save(s, p=None):
    json.dump(s, open(p or P, 'w', encoding='utf-8'), ensure_ascii=False, indent=1)


def pending(s):
    return [i for i in s.get('items', []) if i.get('status') not in ('done', 'dropped')]


def main(argv, p=None):
    if not argv:
        print(__doc__); return 3
    cmd, rest = argv[0], argv[1:]
    s = load(p)
    if cmd == 'set':
        purpose = ''
        if rest[:1] == ['--purpose']:
            purpose, rest = (rest[1] if len(rest) > 1 else ''), rest[2:]
            if not purpose:
                print('[ERROR] set --purpose <목적 키> "<계획 이름>" <항목>...'); return 3
        if len(rest) < 2:
            print('[ERROR] set "<계획 이름>" <항목>...'); return 3
        s = {'plan': rest[0], 'at': now(), 'items': [{'name': x, 'status': 'todo', 'at': now()} for x in rest[1:]]}
        if purpose:
            s['purpose'] = purpose
        save(s, p); print(f"[계획] {s['plan']} · 구현 항목 {len(s['items'])}개 등록 — 모두 끝나기 전에는 화면 측정·통합 시험을 하지 않음"); return 0
    if cmd in ('done', 'drop'):
        names = rest[:1] if cmd == 'drop' else rest
        why = rest[1] if cmd == 'drop' and len(rest) > 1 else ''
        if cmd == 'drop' and not why:
            print('[ERROR] drop <항목> "<사유>" — 사유 필수(사용자가 빼라고 한 경우만)'); return 3
        hit = 0
        for i in s.get('items', []):
            if i['name'] in names:
                i['status'] = 'done' if cmd == 'done' else 'dropped'; i['at'] = now(); hit += 1
                if why:
                    i['why'] = why
        save(s, p); print(f"[계획] {cmd} {hit}개 · 남은 항목 {len(pending(s))}개: {', '.join(i['name'] for i in pending(s)) or '없음'}"); return 0 if hit else 3
    if cmd == 'status':
        pd = pending(s)
        print(f"[계획] {s.get('plan') or '(없음)'} · 남은 항목 {len(pd)}개" + (': ' + ', '.join(i['name'] for i in pd) if pd else '')); return 2 if pd else 0
    if cmd == 'clear':
        save({'plan': '', 'items': [], 'cleared': now(), 'last': s.get('plan', '')}, p); print('[계획] 끝(기록 비움)'); return 0
    print(__doc__); return 3


def selftest():
    import tempfile
    ok = True
    p = os.path.join(tempfile.mkdtemp(), 'ps.json')
    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok &= bool(c)
    chk('등록 → 남은 항목 2 → status 2', main(['set', '계획', 'A', 'B'], p) == 0 and main(['status'], p) == 2)
    chk('사유 없는 drop 거부', main(['drop', 'A'], p) == 3)
    main(['done', 'A'], p); main(['drop', 'B', '사용자가 뺌'], p)
    chk('done + drop → 남은 항목 0 → status 0', main(['status'], p) == 0 and load(p)['items'][1]['why'] == '사용자가 뺌')
    chk('--purpose 로 목적 키 기록 · 항목 2', main(['set', '--purpose', 'checklistTime', '계획2', 'D2', 'D3'], p) == 0 and load(p).get('purpose') == 'checklistTime' and len(load(p)['items']) == 2)
    chk('--purpose 값 없음 거부', main(['set', '--purpose'], p) == 3)
    chk('--purpose 없이 set = purpose 없음', main(['set', '계획3', 'A'], p) == 0 and 'purpose' not in load(p))
    print('selftest', 'OK' if ok else 'FAIL'); return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(selftest() if sys.argv[1:2] == ['--selftest'] else main(sys.argv[1:]))
