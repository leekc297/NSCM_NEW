# -*- coding: utf-8 -*-
"""근거 확인기 — 결과 봉투(vibe-result/1)의 인용 근거가 실제로 있는지 기계로 확인해 근거 등급(hard/soft)을 매긴다 (2026-10-26)

  python tools/Harness/verify/evidence_check.py <봉투 .result.json> [--quiet]

왜: '기대값이 틀렸다'·'AS-IS 와 같다' 같은 판정이 AI 설명만으로 통과하면 테스트 약화·허위 PASS 가 된다(정직 보고 #126).
    Atlas Studio 규약 — 통과 근거는 기계·사람 근거(hard) 와 AI 판단(soft) 으로 나누고, AI 판단만으로는 통과시키지 않는다.

근거 kind 별 확인
  source  ref = '<경로>:<줄>' 또는 '<경로>:<줄>-<줄>' 또는 '<경로>'(줄 없음) · expect = 그 줄 원문 인용(문자열 또는 문자열 배열)
          경로 = 저장소 루트 기준 상대 또는 절대(AS-IS 소스 GSCM/ 도 루트 아래). 줄이 있으면 [줄-3, 줄끝+3] 창에서,
          줄이 없으면 파일 전체에서 '한 줄 안에' expect 토큰이 모두 나와야 verified=True. expect 없는 인용은 verified=False
          (줄 번호만으로는 내용이 맞는지 알 수 없다 — 지어낸 줄 번호를 걸러내기 위함).
  human   by 가 사람 이름이어야 함(AI·claude 등 불가)
  test·build·lint·schema·exec·db  기계 산출 — ref 가 파일 경로면 존재해야 verified
  agent-judgment  항상 soft
결과: 각 근거에 verified·why, 각 이슈에 grade(hard|soft) 를 써서 같은 파일에 저장. 요약 출력 'EVIDENCE: hard=N soft=M'.
"""
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import envelope  # noqa: E402

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
WINDOW = 3
_cache = {}


def _lines(p):
    if p not in _cache:
        for enc in ('utf-8-sig', 'cp949', 'latin-1'):
            try:
                with open(p, encoding=enc) as f:
                    _cache[p] = f.read().splitlines()
                break
            except (UnicodeDecodeError, OSError):
                continue
        else:
            _cache[p] = None
    return _cache[p]


def _norm(s):
    return re.sub(r'\s+', ' ', str(s)).strip().lower()


def _resolve(path):
    path = path.strip().strip('`').replace('\\', '/')
    cands = [path] if os.path.isabs(path) else [os.path.join(ROOT, path)]
    for c in cands:
        c = os.path.normpath(c)
        if os.path.isfile(c):
            return c
    return None


REF = re.compile(r'^(?P<path>.+?)(?::(?P<a>\d+)(?:-(?P<b>\d+))?)?$')


def check_source(ev):
    ref = str(ev.get('ref') or '').strip()
    m = REF.match(ref)
    if not m:
        return False, 'ref 형식 오류'
    p = _resolve(m.group('path'))
    if not p:
        return False, f"파일 없음: {m.group('path')}"
    lines = _lines(p)
    if lines is None:
        return False, '파일 읽기 실패'
    exp = ev.get('expect')
    toks = [t for t in ([exp] if isinstance(exp, str) else (exp or [])) if str(t).strip()]
    if not toks:
        return False, '원문 인용(expect) 없음 — 줄 번호만으로는 확인 불가'
    toks = [_norm(t) for t in toks]
    if m.group('a'):
        a = int(m.group('a')); b = int(m.group('b') or a)
        if a < 1 or a > len(lines):
            return False, f'줄 범위 밖({a} > {len(lines)})'
        rng = range(max(1, a - WINDOW), min(len(lines), b + WINDOW) + 1)
    else:
        rng = range(1, len(lines) + 1)
    for i in rng:
        ln = _norm(lines[i - 1])
        if all(t in ln for t in toks):
            ev['found_line'] = i
            return True, f'확인 {os.path.relpath(p, ROOT)}:{i}'
    # 여러 줄에 걸친 인용(구문이 줄바꿈된 경우) — 창 전체를 이어 붙여 한 번 더
    if m.group('a'):
        blob = _norm(' '.join(lines[i - 1] for i in rng))
        if all(t in blob for t in toks):
            return True, f'확인(여러 줄) {os.path.relpath(p, ROOT)}:{rng.start}-{rng.stop - 1}'
    return False, '인용 원문이 그 위치에 없음'


def check_ev(ev):
    k = ev.get('kind')
    if k == 'source':
        ok, why = check_source(ev)
    elif k == 'human':
        ok = envelope.is_hard(ev); why = '사람 판정' if ok else '사람 이름(by) 없음 또는 AI'
    elif k in envelope.MACHINE:
        ref = str(ev.get('ref') or '')
        looks_path = bool(re.search(r'[\\/]', ref)) and not re.search(r'\s', ref)
        ok = (not looks_path) or bool(_resolve(ref.split(':')[0]))
        why = '기계 산출' if ok else f'산출 파일 없음: {ref}'
    else:
        ok, why = False, 'AI 판단(근거 등급 soft)'
    ev['verified'] = bool(ok)
    ev['why'] = why
    return ev


def grade(env):
    for i in env.get('issues') or []:
        for ev in i.get('evidence') or []:
            check_ev(ev)
        i['grade'] = envelope.grade_of(i)
    for ev in env.get('evidence') or []:
        check_ev(ev)
    return env


def main():
    a = sys.argv[1:]
    if not a:
        print(__doc__)
        return 2
    env = envelope.read(a[0])
    if env['state'] == 'error' and env.get('why'):
        print(f"[ERROR] {env['why']}: {env['file']}")
        return 2
    grade(env)
    env.pop('file', None)
    envelope.write(a[0], env)
    hard = sum(1 for i in env['issues'] if i['grade'] == 'hard'); soft = len(env['issues']) - hard
    if '--quiet' not in a:
        for i in env['issues']:
            whys = '; '.join(e.get('why', '') for e in i.get('evidence') or []) or '근거 없음'
            print(f"  [{i['grade']}] {i.get('id', '')} {i.get('class', '')} — {whys}")
    print(f'EVIDENCE: hard={hard} soft={soft}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
