# -*- coding: utf-8 -*-
"""테스트 약화 검사 — E2E 기대값 보정(🩹 시험 기준 보정) 전후로 시험 도구·스펙이 약해졌는지 기계로 본다 (2026-10-26)

  python tools/Harness/verify/weaken_check.py <ID> --snapshot      보정 직전: 지표 스냅샷 → Doc/gen/<ID>/_e2e_snapshot.json
  python tools/Harness/verify/weaken_check.py <ID> --compare       보정 직후: 비교 → Doc/gen/<ID>/E2E_EXPECTFIX.result.json (결과 봉투)

왜: 보정 세션은 '기대값이 틀렸다' 고 판단해 시험을 고친다. 근거가 맞아도 고친 결과가 검사 삭제·skip 추가·예외 삼키기면
    재시험 통과는 허위 통과다(🩹 expectPrompt 의 '테스트 약화 금지' 를 사람이 아니라 기계가 확인).
대상: tools/E2E/gen-e2e.js · tools/E2E/lib/** · tools/E2E/fixtures/** (생성기·헬퍼 — 전 화면 공통) + Doc/e2e/specs/<ID>.*.spec.ts (이 화면 스펙)
지표(파일별, 주석 제외):
  assert   expect( / expect.soft( / expect.poll( 호출 수              — 줄면 약화
  skip     test.skip( / test.fixme( / .skip( / testInfo.skip / 'N/A' 어노테이션 — 늘면 약화
  swallow  빈 catch {} / .catch(() => {}) / .catch(() => undefined)   — 늘면 약화
  file     스펙·헬퍼 파일 삭제                                          — 약화
판정: 약화 신호 0 = verdict pass · 1 이상 = state input-required / verdict hold (사람이 근거를 보고 승인해야 통과로 인정)
한계: 기대값 리터럴을 실측값으로 바꾼 것(의미 약화)은 지표로 못 잡는다 — 그래서 보정 대상은 근거 등급 hard 인 항목으로만 제한한다(e2e-judge.js).
"""
import glob
import hashlib
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import envelope  # noqa: E402

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
E2E = os.path.join(ROOT, 'tools', 'E2E')
GEN = os.path.join(ROOT, 'Doc', 'gen')

PAT = {
    'assert': re.compile(r'\bexpect(?:\.soft|\.poll)?\s*\('),
    'skip': re.compile(r'\btest\.(?:skip|fixme)\s*\(|\.skip\s*\(|testInfo\.skip|[\'"]N/?A[\'"]'),
    'swallow': re.compile(r'catch\s*(?:\([^)]*\))?\s*\{\s*\}|\.catch\(\s*\(\s*\w*\s*\)\s*=>\s*(?:\{\s*\}|undefined|null)\s*\)'),
}


def strip_comments(t):
    t = re.sub(r'/\*[\s\S]*?\*/', ' ', t)
    return re.sub(r'(^|[^:\'"])//.*$', r'\1', t, flags=re.M)


def targets(mid):
    fs = [os.path.join(E2E, 'gen-e2e.js')]
    for sub in ('lib', 'fixtures'):
        fs += [f for f in glob.glob(os.path.join(E2E, sub, '**', '*'), recursive=True) if re.search(r'\.(ts|js|mjs)$', f)]
    fs += glob.glob(os.path.join(ROOT, 'Doc', 'e2e', 'specs', f'{mid}.*.spec.ts'))
    return sorted({os.path.normpath(f) for f in fs if os.path.isfile(f)})


def metrics(p):
    with open(p, encoding='utf-8', errors='replace') as f:
        raw = f.read()
    t = strip_comments(raw)
    return {'sha': hashlib.sha1(raw.encode('utf-8', 'replace')).hexdigest()[:12], **{k: len(rx.findall(t)) for k, rx in PAT.items()}}


def rel(p):
    return os.path.relpath(p, ROOT).replace('\\', '/')


def main():
    a = sys.argv[1:]
    if not a or not ({'--snapshot', '--compare'} & set(a)):
        print(__doc__)
        return 2
    mid = a[0].upper()
    snap = os.path.join(GEN, mid, '_e2e_snapshot.json')
    if '--snapshot' in a:
        os.makedirs(os.path.dirname(snap), exist_ok=True)
        data = {rel(p): metrics(p) for p in targets(mid)}
        with open(snap, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=1)
        print(f'WEAKEN: snapshot {len(data)} files → {rel(snap)}')
        return 0
    out = os.path.join(GEN, mid, 'E2E_EXPECTFIX.result.json')
    if not os.path.exists(snap):
        envelope.write(out, {'producer': 'weaken_check', 'id': mid, 'state': 'error', 'verdict': None, 'why': '보정 전 스냅샷 없음 — 비교 불가'})
        print('WEAKEN: ERROR 스냅샷 없음')
        return 3
    with open(snap, encoding='utf-8') as f:
        before = json.load(f)
    after = {rel(p): metrics(p) for p in targets(mid)}
    issues, changed = [], []
    for f in sorted(set(before) | set(after)):
        b, c = before.get(f), after.get(f)
        if b and not c:
            issues.append({'id': f'del:{f}', 'class': 'weakened', 'msg': f'파일 삭제 {f}', 'evidence': [{'kind': 'exec', 'ref': 'weaken_check file'}]})
            continue
        if c and not b:
            changed.append(f'+{f}')
            continue
        if b['sha'] == c['sha']:
            continue
        changed.append(f)
        if c['assert'] < b['assert']:
            issues.append({'id': f'assert:{f}', 'class': 'weakened', 'msg': f"검사(expect) {b['assert']}→{c['assert']} 감소 {f}", 'evidence': [{'kind': 'exec', 'ref': 'weaken_check assert'}]})
        if c['skip'] > b['skip']:
            issues.append({'id': f'skip:{f}', 'class': 'weakened', 'msg': f"skip/N/A {b['skip']}→{c['skip']} 증가 {f}", 'evidence': [{'kind': 'exec', 'ref': 'weaken_check skip'}]})
        if c['swallow'] > b['swallow']:
            issues.append({'id': f'swallow:{f}', 'class': 'weakened', 'msg': f"예외 삼키기 {b['swallow']}→{c['swallow']} 증가 {f}", 'evidence': [{'kind': 'exec', 'ref': 'weaken_check swallow'}]})
    weak = bool(issues)
    envelope.write(out, {'producer': 'weaken_check', 'id': mid, 'state': 'input-required' if weak else 'completed', 'verdict': 'hold' if weak else 'pass',
                         'summary': {'changed': len(changed), 'weakened': len(issues)}, 'changed': changed, 'issues': issues,
                         'evidence': [{'kind': 'exec', 'ref': 'tools/Harness/verify/weaken_check.py'}]})
    print(f"WEAKEN: changed={len(changed)} weakened={len(issues)} → {rel(out)}")
    for i in issues:
        print(f"  ! {i['msg']}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
