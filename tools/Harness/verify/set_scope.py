"""보완 범위 환경설정 — tools/Harness/harness.json 의 repairScope 를 읽고 쓴다(단일 원천)

  python tools/Harness/verify/set_scope.py            현재 값 출력
  python tools/Harness/verify/set_scope.py DB_ONLY    DB 객체·메타만 보완, 화면 FE 는 가이드만 (기본)
  python tools/Harness/verify/set_scope.py DB_FE      화면 FE(features/**/pages/<screen>)까지 보완
공통 컴포넌트(@shared·@foundation)는 어느 값이든 가이드만 — 보완 프롬프트(🛠️·🧯·🩹)와 make_verify_docs.py 가 이 값을 읽는다.
"""
import json
import os
import sys

PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'harness.json'))
CHOICES = {'DB_ONLY': 'DB 객체·메타만 적용 (화면 FE 는 보완대상목록에 가이드만)', 'DB_FE': 'DB + 화면 FE 까지 적용 (공통 컴포넌트는 가이드만)'}


def main():
    with open(PATH, encoding='utf-8-sig') as f:
        cfg = json.load(f)
    if len(sys.argv) < 2 or not sys.argv[1].strip():
        cur = cfg.get('repairScope', 'DB_ONLY')
        print(f'repairScope = {cur} — {CHOICES.get(cur, "?")}')
        return 0
    v = sys.argv[1].strip().upper()
    if v not in CHOICES:
        print(f'[FAIL] 값은 DB_ONLY 또는 DB_FE (입력: {sys.argv[1]})')
        return 2
    before = cfg.get('repairScope', 'DB_ONLY')
    cfg['repairScope'] = v
    with open(PATH, 'w', encoding='utf-8') as f:
        json.dump(cfg, f, ensure_ascii=False, indent=2)
        f.write('\n')
    print(f'repairScope {before} → {v} — {CHOICES[v]}  ({PATH})')
    return 0


if __name__ == '__main__':
    sys.exit(main())
