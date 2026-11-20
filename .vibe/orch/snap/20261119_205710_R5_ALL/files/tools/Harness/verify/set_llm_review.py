# -*- coding: utf-8 -*-
"""AI 검토 켜고 끄기 — tools/Harness/harness.json 의 llmReview 를 읽고 쓴다(단일 원천 · 2026-11-19 사용자 지시 'VM 환경설정에 AI 검토 켜고 끄는 항목')

  python tools/Harness/verify/set_llm_review.py            현재 값 출력
  python tools/Harness/verify/set_llm_review.py ON         켬  — CheckList 수행 때 Claude Code 로 사용자의견 처리·AS-IS 사실 추출 검토·판정 검토·설명 문장 작성
  python tools/Harness/verify/set_llm_review.py OFF        끔  — 검사엔진 판정만. 지난 AI 검토 결과(llm_review.csv)도 판정에 반입하지 않는다
  python tools/Harness/verify/set_llm_review.py --selftest

  VM 메뉴: 환경설정 → 🧠 AI 검토 (켜기 / 끄기) — steps.json S8.llmReview 가 이 도구를 부른다.
  다른 설정(llmReviewKinds 단계 · llmReviewModel 모델 · llmReviewEffort · llmReviewBudgetUsd 상한)은 harness.json 에서 직접 고친다. 모델이 빈 값이면 VM 워크벤치 모델을 쓴다.
  harness.json 의 다른 줄은 건드리지 않는다(llmReview 값만 바꾼다).
  종료코드 0 · 2 = 값 오류 · 3 = harness.json 에 llmReview 키 없음·쓰기 실패
"""
import json
import os
import re
import sys

PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'harness.json'))
ON_WORDS = {'ON', '1', 'TRUE', 'Y', 'YES', '켜기', '켬'}
OFF_WORDS = {'OFF', '0', 'FALSE', 'N', 'NO', '끄기', '끔'}
RX = re.compile(r'("llmReview"\s*:\s*)(true|false)')


def describe(cfg):
    on = bool(cfg.get('llmReview'))
    kinds = ', '.join(cfg.get('llmReviewKinds') or []) or '(없음)'
    model = (cfg.get('llmReviewModel') or '').strip() or 'VM 워크벤치 모델'
    bud = cfg.get('llmReviewBudgetUsd') or 0
    return (f"AI 검토 = {'켬' if on else '끔'} · 단계 {kinds} · 모델 {model} · effort {cfg.get('llmReviewEffort', '')}"
            f" · 화면당 상한 {'없음' if not bud else str(bud) + ' USD'}")


def parse(word):
    """'ON'|'OFF'|None(값 오류) — 선택 목록 문구('ON — …')도 받는다"""
    w = str(word or '').strip().split()[0].upper() if str(word or '').strip() else ''
    return 'ON' if w in ON_WORDS else 'OFF' if w in OFF_WORDS else None


def apply_text(text, on):
    """harness.json 원문에서 llmReview 값만 바꾼 글 — 키가 없으면 None"""
    if not RX.search(text):
        return None
    return RX.sub(lambda m: m.group(1) + ('true' if on else 'false'), text, count=1)


def selftest():
    ok = True

    def chk(name, cond):
        nonlocal ok
        print(f"  [{'OK' if cond else 'FAIL'}] {name}")
        ok = ok and bool(cond)
    chk('값 해석 — ON·켜기·선택 문구', parse('on') == 'ON' and parse('켜기') == 'ON' and parse('ON — 켜기') == 'ON')
    chk('값 해석 — OFF·끄기', parse('OFF') == 'OFF' and parse('끄기') == 'OFF')
    chk('값 해석 — 모르는 값', parse('maybe') is None and parse('') is None)
    src = '{\n  "snapAutoApprove": true,\n  "llmReview": false,\n  "llmReviewKinds": ["judge"],\n  "x": "llmReview 설명 true"\n}\n'
    out = apply_text(src, True)
    chk('쓰기 — llmReview 줄만 바뀜', out == src.replace('"llmReview": false', '"llmReview": true') and json.loads(out)['llmReview'] is True and json.loads(out)['snapAutoApprove'] is True)
    chk('쓰기 — 끄기', json.loads(apply_text(out, False))['llmReview'] is False)
    chk('쓰기 — 키 없음', apply_text('{"a": 1}', True) is None)
    chk('설명 — 모델 빈 값', 'VM 워크벤치 모델' in describe({'llmReview': True, 'llmReviewKinds': ['judge'], 'llmReviewModel': ''}))
    print('SELFTEST ' + ('OK' if ok else 'FAIL'))
    return 0 if ok else 1


def main():
    a = [x for x in sys.argv[1:] if x.strip()]
    if a and a[0] == '--selftest':
        return selftest()
    raw = open(PATH, encoding='utf-8-sig').read()
    cfg = json.loads(raw)
    if not a or a[0].upper() in ('STATUS', '현재'):
        print(describe(cfg) + f'  ({PATH})')
        return 0
    v = parse(' '.join(a))
    if v is None:
        print(f'[FAIL] 값은 ON 또는 OFF (입력: {" ".join(a)})')
        return 2
    on = v == 'ON'
    if bool(cfg.get('llmReview')) == on:
        print('변경 없음 — ' + describe(cfg))
        return 0
    out = apply_text(raw, on)
    if out is None:
        print('[ERROR] harness.json 에 llmReview 키가 없음 — tools/Harness/harness.json 에 "llmReview": true 줄을 먼저 넣는다')
        return 3
    try:
        json.loads(out)
        with open(PATH, 'w', encoding='utf-8', newline='') as f:
            f.write(out)
    except (OSError, ValueError) as e:
        print(f'[ERROR] harness.json 쓰기 실패: {e}')
        return 3
    print(f"AI 검토 {'끔 → 켬' if on else '켬 → 끔'} — " + describe(json.loads(out)))
    print('다음 CheckList 실행부터 적용된다. 실행 중인 CheckList 는 시작할 때 읽은 값으로 끝까지 간다(판정 단계는 실행 시점 값을 읽는다).')
    return 0


if __name__ == '__main__':
    sys.exit(main())
