# -*- coding: utf-8 -*-
"""미검증 행 확인 재측정(2026-11-25 사용자: 검사기 보완이 고친 행을 바로 확인 · 🧪 미검증 해소가 묶음마다 부름)

  python tools/Harness/verify/row_probe.py <MENU_ID> <row_id[,row_id...]>
  python tools/Harness/verify/row_probe.py --selftest

  고른 행을 판정하는 규칙만 다시 잰다(run_verify.py --only, VERIFY_SETTLE=1: AS-IS 런처 실측 생략, E2E 4종은 그 행의 종류만, 사실 검토는 FACT- 행이 있을 때만).
  잰 결과는 원장(verify_ledger.csv)에 들어간다(실측이므로 버리지 않음). 행마다 전후 판정을 출력한다.
  AI 검토 행(FAIL·판정필요인데 AI 가 검사기 오판으로 가린 행)은 원장 판정과 llm_review.csv 의 지금 분류를 같이 본다.
  종료코드 0 = 고른 행 모두 미검증 아님 · 2 = 아직 미검증이거나 AI 검토가 여전히 오판 지적 · 3 = 원장 없음·행 없음 · 그 밖 = run_verify 종료코드
"""
import csv, os, subprocess, sys, time

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE)
csv.field_size_limit(10 ** 8)


def _read(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as fh:
            return list(csv.DictReader(fh))
    except OSError:
        return []


def state(mid, ids):
    """행 ID → (원장 판정, 증거 앞부분, AI 검토 분류)"""
    vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    led = {r.get('row_id'): r for r in _read(os.path.join(vd, 'verify_ledger.csv'))}
    rv = {r.get('row_id'): r for r in _read(os.path.join(vd, 'llm_review.csv'))}
    fc = {r.get('fact_id'): r for r in _read(os.path.join(vd, 'llm_facts.csv'))}
    out = {}
    for i in ids:
        r = led.get(i); x = rv.get(i); f = fc.get(i)
        ai = (x.get('class') or '') if x and x.get('verified') == 'Y' else ''
        if f and f.get('verified') == 'Y':
            ai = 'AI검토:추출오류'
        out[i] = ((r.get('result') or '') if r else ('(사실 검토 행)' if i.startswith('FACT-') else '(원장에 없음)'),
                  ' '.join((r.get('evidence') or '').split())[:140] if r else '', ai)
    return out


def done(st):
    res, _ev, ai = st
    return res not in ('ERROR', '(원장에 없음)') and ai not in ('검사기오판', '추출오류', 'TOBE룰', 'AI검토:추출오류')


def main(argv):
    if len(argv) < 2:
        print(__doc__); return 3
    mid = argv[0].upper(); ids = [x.strip().strip('`*') for x in argv[1].split(',') if x.strip()]
    vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    led = _read(os.path.join(vd, 'verify_ledger.csv'))
    if not led:
        print(f'[ERROR] 원장 없음: Doc/verify/{mid}/verify_ledger.csv', flush=True); return 3
    import unverified_resolve as U, checklist_run as C
    remap = U.id_bridge(mid, led)
    ids = [remap(i) for i in ids]
    by = {r.get('row_id'): r for r in led}
    rows = [by[i] for i in ids if i in by] + [{'row_id': i} for i in ids if i.startswith('FACT-') and i not in by]
    if not rows:
        print(f'[ERROR] 원장에 고른 행이 없음: {",".join(ids)}', flush=True); return 3
    rules, stages, stage_rules, why = C.plan_rows(rows)
    before = state(mid, ids)
    t0 = time.time()
    print(f'== 행 확인 재측정 {mid} · 행 {len(ids)} · {time.strftime("%H:%M:%S")} ==', flush=True)
    if rules:
        env = C.settle_env(rows, stages, stage_rules)
        print(f'[INFO] {why}: {",".join(rules)}' + (f" · E2E 4종 {env['VERIFY_SUITE_KINDS']}" if env['VERIFY_SUITE_KINDS'] else ''), flush=True)
        cmd = [sys.executable, os.path.join(HERE, 'run_verify.py'), mid, '--only', ','.join(rules)]
        print('$ ' + ' '.join(cmd[1:]), flush=True)
        rc = subprocess.call(cmd, cwd=ROOT, env=env)
        if rc not in (0, 10):
            print(f'[ERROR] run_verify 종료코드 {rc}(3 = 이 규칙을 판정하는 시험 없음, 4 = 같은 화면 실행 중, 5 = 서버 미기동) · 판정 변화 미측정', flush=True)
            return rc
    elif any(i.startswith('FACT-') for i in ids):
        cmd = [sys.executable, os.path.join(HERE, 'llm_facts.py'), mid]
        print('$ ' + ' '.join(cmd[1:]), flush=True)
        subprocess.call(cmd, cwd=ROOT)
    else:
        print(f'[INFO] 다시 잴 규칙 없음({why}) · 판정 변화 미측정', flush=True); return 2
    after = state(mid, ids)
    ok = 0
    print(f'[행별 결과] ({(time.time() - t0) / 60:.1f}분)', flush=True)
    for i in ids:
        b, a = before[i], after[i]
        d = done(a); ok += d
        print(f"  {'해소' if d else '미해소'} {i}: {b[0]}{'/' + b[2] if b[2] else ''} → {a[0]}{'/' + a[2] if a[2] else ''} · {a[1]}", flush=True)
    print(f'[{"OK" if ok == len(ids) else "INFO"}] 해소 {ok}/{len(ids)}행', flush=True)
    return 0 if ok == len(ids) else 2


def selftest():
    ok = True
    for st, want in ((('PASS', '', ''), True), (('ERROR', '', ''), False), (('FAIL', '', '검사기오판'), False), (('판정필요', '', '정판'), True), (('(원장에 없음)', '', ''), False)):
        if done(st) != want:
            print('FAIL done', st); ok = False
    print('selftest', 'OK' if ok else 'FAIL'); return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(selftest() if sys.argv[1:2] == ['--selftest'] else main(sys.argv[1:]))
