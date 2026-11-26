# -*- coding: utf-8 -*-
"""VMO 보완 뒤 재수행 — tools/Harness/harness.json orch.rerunAfterFix 를 읽고 쓴다(단일 원천 · 2026-11-20 사용자 지시)

  사용자 지시: "사용자 작업에 대한 오류가 발생했을 때 vmo 가 보완 후 작업재개 나 재실행을 하지 않는 것이 기본입니다.
               환경설정에서 재수행여부를 관리해서 default 는 수행없음 을 값으로 가지고 있고, 재수행을 선택했을 때는 보완 후 작업재개 나 재실행 수행" · "vm 환경설정에 두어야 합니다."

  python tools/Harness/verify/set_vmo_rerun.py            현재 값 출력
  python tools/Harness/verify/set_vmo_rerun.py RERUN      재수행(기본 · 17:2x 사용자 변경) — VMO 가 보완한 뒤 그 작업을 재개(끊긴 단계부터) 또는 재실행. 작업·화면마다 orch.rerunMax(기본 2)번까지, 3번째 오류면 재수행 안 함
  python tools/Harness/verify/set_vmo_rerun.py NONE       수행 없음 — VMO 는 보완까지만. 작업 재개·재실행은 사용자
  python tools/Harness/verify/set_vmo_rerun.py --selftest

  VM 메뉴: 환경설정 → 🔁 VMO 보완 뒤 재수행 (수행 없음 / 재수행) — steps.json S8.vmoRerun 이 이 도구를 부른다.
  harness.json 의 다른 줄은 건드리지 않는다(orch.rerunAfterFix 값만 바꾸거나, 없으면 orch 첫 줄에 넣는다).
  종료코드 0 · 2 = 값 오류 · 3 = harness.json 쓰기 실패·orch 없음
"""
import json
import os
import re
import sys

PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'harness.json'))
NONE_WORDS = {'NONE', 'OFF', '0', 'FALSE', 'N', 'NO', '수행없음', '수행', '없음'}
RERUN_WORDS = {'RERUN', 'ON', '1', 'TRUE', 'Y', 'YES', '재수행'}
RX = re.compile(r'("rerunAfterFix"\s*:\s*)"(none|rerun)"')
ORCH = re.compile(r'("orch"\s*:\s*\{)(\s*)')


def describe(orch):
    v = (orch or {}).get('rerunAfterFix', 'rerun')
    mx = (orch or {}).get('rerunMax', 2)
    return (f'VMO 보완 뒤 재수행 = 재수행(기본 · VMO 가 보완한 뒤 작업 재개 또는 재실행 · 작업·화면마다 {mx}번까지, 그 뒤 오류는 재수행 안 함)' if v != 'none'
            else 'VMO 보완 뒤 재수행 = 수행 없음(VMO 는 보완까지만, 작업 재개·재실행은 사용자)')


def parse(word):
    """'none'|'rerun'|None — 선택 목록 문구('NONE — …')도 받는다"""
    s = str(word or '').strip()
    if not s:
        return None
    w = s.split()[0].upper()
    if w in RERUN_WORDS or s.startswith('재수행'):
        return 'rerun'
    if w in NONE_WORDS or s.startswith('수행 없음') or s.startswith('수행없음'):
        return 'none'
    return None


def apply_text(text, val):
    """harness.json 원문에서 orch.rerunAfterFix 값만 바꾼 글. 키가 없으면 orch 첫 줄에 넣는다. orch 가 없으면 None"""
    if RX.search(text):
        return RX.sub(lambda m: m.group(1) + '"' + val + '"', text, count=1)
    m = ORCH.search(text)
    if not m:
        return None
    ind = m.group(2) if '\n' in m.group(2) else '\n    '
    return text[:m.end(1)] + ind + '"rerunAfterFix": "' + val + '",' + m.group(2) + text[m.end():]


def selftest():
    ok = True

    def chk(name, cond):
        nonlocal ok
        print(f"  [{'OK' if cond else 'FAIL'}] {name}")
        ok = ok and bool(cond)
    chk('값 해석 — NONE·수행 없음·선택 문구', parse('none') == 'none' and parse('수행 없음') == 'none' and parse('NONE — 수행 없음') == 'none')
    chk('값 해석 — RERUN·재수행', parse('RERUN') == 'rerun' and parse('재수행') == 'rerun' and parse('RERUN — 재수행') == 'rerun')
    chk('값 해석 — 모르는 값', parse('maybe') is None and parse('') is None)
    src = '{\n  "llmReview": false,\n  "orch": {\n    "enabled": true,\n    "x": "rerunAfterFix 설명"\n  }\n}\n'
    out = apply_text(src, 'rerun')
    chk('키 없음 → orch 첫 줄에 넣음 · 다른 값 그대로', json.loads(out)['orch']['rerunAfterFix'] == 'rerun' and json.loads(out)['orch']['enabled'] is True and json.loads(out)['llmReview'] is False)
    out2 = apply_text(out, 'none')
    chk('키 있음 → 값만 바뀜(키 1개)', json.loads(out2)['orch']['rerunAfterFix'] == 'none' and out2.count('"rerunAfterFix"') == 1 and out2.replace('"none"', '"rerun"', 1) == out)
    chk('orch 없음 = None', apply_text('{\n  "a": 1\n}\n', 'rerun') is None)
    print('selftest', 'PASS' if ok else 'FAIL')
    return 0 if ok else 1


def main():
    args = [a for a in sys.argv[1:] if a.strip()]
    if args and args[0] == '--selftest':
        return selftest()
    try:
        text = open(PATH, encoding='utf-8-sig').read()
        cfg = json.loads(text)
    except (OSError, ValueError) as e:
        print(f'[FAIL] harness.json 읽기 실패: {e}')
        return 3
    orch = cfg.get('orch') or {}
    if not args or args[0].upper() == 'STATUS' or args[0].startswith('현재'):
        print(describe(orch))
        return 0
    val = parse(' '.join(args))
    if val is None:
        print(f'[FAIL] 값 오류: {" ".join(args)} — NONE(수행 없음) 또는 RERUN(재수행)')
        return 2
    new = apply_text(text, val)
    if new is None:
        print('[FAIL] harness.json 에 orch 가 없음')
        return 3
    try:
        json.loads(new)
        with open(PATH, 'w', encoding='utf-8', newline='\n') as f:
            f.write(new)
    except (OSError, ValueError) as e:
        print(f'[FAIL] 쓰기 실패: {e}')
        return 3
    print(f"[OK] {describe({'rerunAfterFix': val})}")
    print('적용: 바로(VMO 가 조치할 때마다 harness.json 을 읽음)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
