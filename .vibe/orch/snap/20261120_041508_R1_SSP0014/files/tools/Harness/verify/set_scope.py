"""보완 범위 환경설정 — tools/Harness/harness.json 의 repairScope 를 읽고 쓴다(단일 원천)

  python tools/Harness/verify/set_scope.py            현재 값 출력
  python tools/Harness/verify/set_scope.py DB         DB MODE    (저장값 DB_ONLY) — DB·META 만 개발·수정, FE·BE 는 가이드만
  python tools/Harness/verify/set_scope.py UIDB       UI/DB MODE (저장값 DB_FE)   — 제약 없이 개발·수정
  DB_ONLY · DB_FE 도 그대로 받는다. 이 값은 Vibe_Manager 환경설정 🧭 작업 모드의 단일 원천이다(2026-11-02).
공통 컴포넌트(@shared·@foundation)는 어느 값이든 가이드만 — 보완 프롬프트(🛠️·🧯·🩹)와 make_verify_docs.py 가 이 값을 읽는다.
"""
import json
import os
import sys

PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'harness.json'))
CHOICES = {'DB_ONLY': 'DB MODE — DB·META 만 개발·수정, FE·BE 는 가이드만 · Git Download & Merge 로컬 소스 보호 안 함 · 클라우드 이관 DB 만',
           'DB_FE': 'UI/DB MODE — 제약 없이 개발·수정 · Git Download & Merge 로컬 소스 보호 · 클라우드 이관 DB + FE·BE'}
ALIASES = {'DB': 'DB_ONLY', 'DB_MODE': 'DB_ONLY', 'DB MODE': 'DB_ONLY', 'DB_ONLY': 'DB_ONLY', 'UIDB': 'DB_FE', 'UI/DB': 'DB_FE', 'UI_DB': 'DB_FE', 'UI/DB MODE': 'DB_FE', 'UIDB_MODE': 'DB_FE', 'DB_FE': 'DB_FE'}


def main():
    with open(PATH, encoding='utf-8-sig') as f:
        cfg = json.load(f)
    if len(sys.argv) < 2 or not sys.argv[1].strip():
        cur = cfg.get('repairScope', 'DB_ONLY')
        print(f'repairScope = {cur} — {CHOICES.get(cur, "?")}')
        return 0
    v = ALIASES.get(' '.join(sys.argv[1:]).strip().upper())
    if v not in CHOICES:
        print(f'[FAIL] 값은 DB 또는 UIDB (입력: {sys.argv[1]})')
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
