# -*- coding: utf-8 -*-
"""미검증 해소 보완 뒤 CheckList 재수행 전인지 판단(2026-11-19 사용자 지시)

  python tools/Harness/verify/pending_recheck.py <MENU_ID>          → 재수행 전이면 안내 1줄 출력
  python tools/Harness/verify/pending_recheck.py <MENU_ID> --mark   → 보완 표식 남김(🧪 미검증 해소에서 검사기를 고친 뒤)
  python tools/Harness/verify/pending_recheck.py --selftest

  사용자 지시: 미검증 해소를 한 뒤에는 보완 전 CheckList 건수를 보여 주지 않는다. 보여 줄 때는 보완 뒤 다시 수행한 CheckList 건수만.
  판단 = 보완 표식(Doc/verify/<ID>/_unverified_fix.json fixed_at)이 원장(verify_ledger.csv) 수정 시각보다 뒤면 재수행 전.
  CheckList 를 다시 수행하면 원장이 새로 써져 풀린다. _unverified_work.md 수정 시각은 쓰지 않음(재수행 결과 기록도 그 파일에 붙어 오판 · SCP0096 10:03).
  같은 판단 = tools/VibeManager/recheck.js
"""
import datetime, json, os, sys, time

ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
MARK = '_unverified_fix.json'


def _stamp(t):
    return datetime.datetime.fromtimestamp(t).strftime('%Y-%m-%d %H:%M')


def judge(fixed_at, ledger_mtime):
    """보완 표식 시각·원장 수정 시각(초) → 재수행 전이면 dict, 아니면 None"""
    if fixed_at is None or ledger_mtime is None or fixed_at <= ledger_mtime:
        return None
    return {'fixed_at': _stamp(fixed_at), 'ledger_at': _stamp(ledger_mtime),
            'note': f'미검증 해소 보완 {_stamp(fixed_at)} · CheckList 재수행 전(보완 전 건수는 표시하지 않음, 재수행 뒤 표시)'}


def _vd(mid):
    return os.path.join(ROOT, 'Doc', 'verify', mid.upper())


def pending(mid):
    vd = _vd(mid); m, l = os.path.join(vd, MARK), os.path.join(vd, 'verify_ledger.csv')
    if not (os.path.exists(m) and os.path.exists(l)):
        return None
    try:
        fx = float(json.load(open(m, encoding='utf-8')).get('fixed_at'))
    except Exception:
        return None
    return judge(fx, os.path.getmtime(l))


def mark(mid):
    vd = _vd(mid); os.makedirs(vd, exist_ok=True); t = time.time()
    json.dump({'menu_id': mid.upper(), 'fixed_at': t, 'at': _stamp(t), 'why': '🧪 미검증 해소 검사기 보완 · CheckList 재수행 전까지 보완 전 건수 숨김'},
              open(os.path.join(vd, MARK), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
    return t


def selftest():
    cases = [('보완이 원장보다 뒤', judge(200.0, 100.0) is not None, True), ('재수행으로 원장이 뒤', judge(100.0, 200.0) is None, True),
             ('표식 없음', judge(None, 100.0) is None, True), ('같은 시각', judge(100.0, 100.0) is None, True)]
    bad = 0
    for n, got, want in cases:
        ok = got == want; bad += not ok; print(('OK ' if ok else 'NG ') + n)
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    if '--selftest' in sys.argv:
        sys.exit(selftest())
    args = [x for x in sys.argv[1:] if not x.startswith('--')]
    if not args:
        print('사용: python tools/Harness/verify/pending_recheck.py <MENU_ID> [--mark]'); sys.exit(2)
    if '--mark' in sys.argv:
        print(f'보완 표식 {_stamp(mark(args[0]))} · {os.path.relpath(os.path.join(_vd(args[0]), MARK), ROOT)}')
    p = pending(args[0])
    print(p['note'] if p else '재수행 전 아님(원장이 보완 표식보다 새것이거나 표식 없음)')
    sys.exit(0)
