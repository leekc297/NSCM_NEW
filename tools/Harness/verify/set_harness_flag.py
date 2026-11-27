# -*- coding: utf-8 -*-
"""harness.json 켜고 끄는 키 설정. 개선안 20261124040955_SELF_2, 사용자 지시 R131(harness.json 에서 켜고 끄는 기능 설정은 VM 환경설정 화면에 항목을 둠)

  python tools/Harness/verify/set_harness_flag.py <키>            현재 값 출력
  python tools/Harness/verify/set_harness_flag.py <키> ON|OFF     켬 / 끔
  python tools/Harness/verify/set_harness_flag.py --selftest

  키: snapAutoApprove, llmReviewLean, dedupGeneral, dedupScreen, orch.agentEnabled, orch.r14Enabled, orch.autoImproveOnStop
  VM 메뉴: 환경설정 → 키별 항목. steps.json S8.flag* 가 이 도구를 부른다(set_llm_review.py 와 같은 틀).
  harness.json 의 다른 줄은 건드리지 않는다(그 키 값만 바꾼다). orch.* 키는 "orch" 절 안의 값만 바꾼다.
  종료코드 0, 2 = 키·값 오류, 3 = harness.json 에 키 없음 또는 쓰기 실패
"""
import json
import os
import re
import sys

PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'harness.json'))
ON_WORDS = {'ON', '1', 'TRUE', 'Y', 'YES', '켜기', '켬'}
OFF_WORDS = {'OFF', '0', 'FALSE', 'N', 'NO', '끄기', '끔'}

# 키: (설명, 값이 없을 때 쓰는 기본값 · 읽는 코드 기준)
FLAGS = {
    'snapAutoApprove': ('CheckList 스냅샷 자동 승인(대조 OK, NA 수신본을 기준본으로 승인)', False),
    'llmReviewLean': ('AI 검토 가벼운 호출(CLAUDE.md, 메모리, hook, MCP, 스킬을 싣지 않음)', True),
    'dedupGeneral': ('공용 결함 중복 정리(같은 결함을 GENERAL 행 1개로 묶음)', True),
    'dedupScreen': ('화면 안 중복 정리(같은 원인 행을 대표 행으로 묶음)', True),
    'orch.agentEnabled': ('VMO 에이전트 자동 진단', True),
    'orch.r14Enabled': ('VMO 중지 뒤 계속 실행 감시', True),
    'orch.autoImproveOnStop': ('작업 종료 뒤 대기 개선안 이어 진행(Claude Code Stop hook .claude/hooks/auto-improve-on-stop.js)', True),  # 2026-11-26 개선안 20261126192237_SELF, 사용자 지시 R257
}


def get(cfg, key):
    if key.startswith('orch.'):
        o = cfg.get('orch') if isinstance(cfg.get('orch'), dict) else {}
        k = key[5:]
        return bool(o[k]) if k in o else FLAGS[key][1]
    return bool(cfg[key]) if key in cfg else FLAGS[key][1]


def describe(cfg, key):
    return f"{FLAGS[key][0]} = {'켬' if get(cfg, key) else '끔'}  (harness.json {key})"


def parse(word):
    """'ON'|'OFF'|None(값 오류). 선택 목록 문구('ON — …')도 받는다"""
    s = str(word or '').strip()
    w = s.split()[0].upper() if s else ''
    return 'ON' if w in ON_WORDS else 'OFF' if w in OFF_WORDS else None


def find_key(key):
    for k in FLAGS:
        if k.lower() == str(key or '').strip().lower():
            return k
    return None


def apply_text(text, key, on):
    """harness.json 원문에서 그 키 값만 바꾼 글. 키가 없으면 None"""
    val = 'true' if on else 'false'
    if key.startswith('orch.'):
        m = re.search(r'"orch"\s*:\s*\{', text)
        if not m:
            return None
        # orch 절 끝(짝 맞는 닫는 괄호)까지만 본다
        depth, i, end = 0, m.end() - 1, None
        in_str = False
        while i < len(text):
            ch = text[i]
            if in_str:
                if ch == '\\':
                    i += 2
                    continue
                if ch == '"':
                    in_str = False
            elif ch == '"':
                in_str = True
            elif ch == '{':
                depth += 1
            elif ch == '}':
                depth -= 1
                if depth == 0:
                    end = i
                    break
            i += 1
        if end is None:
            return None
        body = text[m.end():end]
        rx = re.compile(r'("' + re.escape(key[5:]) + r'"\s*:\s*)(true|false)')
        if not rx.search(body):
            return None
        return text[:m.end()] + rx.sub(lambda x: x.group(1) + val, body, count=1) + text[end:]
    rx = re.compile(r'(^\s*"' + re.escape(key) + r'"\s*:\s*)(true|false)', re.M)
    if not rx.search(text):
        return None
    return rx.sub(lambda x: x.group(1) + val, text, count=1)


def selftest():
    ok = True

    def chk(name, cond):
        nonlocal ok
        print(f"  [{'OK' if cond else 'FAIL'}] {name}")
        ok = ok and bool(cond)
    chk('값 해석 ON, 켜기, 선택 문구', parse('on') == 'ON' and parse('켜기') == 'ON' and parse('ON — 켜기') == 'ON')
    chk('값 해석 OFF, 모르는 값', parse('끄기') == 'OFF' and parse('maybe') is None and parse('') is None)
    chk('키 찾기 대소문자', find_key('ORCH.AGENTENABLED') == 'orch.agentEnabled' and find_key('x') is None)
    src = ('{\n  "snapAutoApprove": true,\n  "llmReview": true,\n  "dedupScreen": true,\n  "x": "snapAutoApprove 설명 true",\n'
           '  "orch": {\n    "agentEnabled": true,\n    "r14Enabled": true,\n    "n": {"r14Enabled": true}\n  },\n  "r14Enabled": true\n}\n')
    out = apply_text(src, 'snapAutoApprove', False)
    chk('쓰기 상위 키 그 줄만 바뀜', out == src.replace('"snapAutoApprove": true', '"snapAutoApprove": false', 1) and json.loads(out)['x'].endswith('true'))
    out2 = apply_text(src, 'orch.r14Enabled', False)
    j2 = json.loads(out2)
    chk('쓰기 orch 키 orch 절 첫 값만 바뀜', j2['orch']['r14Enabled'] is False and j2['r14Enabled'] is True and j2['orch']['agentEnabled'] is True)
    chk('쓰기 키 없음', apply_text(src, 'dedupGeneral', True) is None and apply_text('{"a": 1}', 'orch.agentEnabled', True) is None)
    chk('읽기 기본값', get({}, 'snapAutoApprove') is False and get({}, 'orch.agentEnabled') is True and get({'orch': {'r14Enabled': False}}, 'orch.r14Enabled') is False)
    print('SELFTEST ' + ('OK' if ok else 'FAIL'))
    return 0 if ok else 1


def main():
    a = [x for x in sys.argv[1:] if x.strip()]
    if a and a[0] == '--selftest':
        return selftest()
    key = find_key(a[0]) if a else None
    if not key:
        print('[FAIL] 키는 ' + ', '.join(FLAGS) + f' 중 하나 (입력: {a[0] if a else ""})')
        return 2
    raw = open(PATH, encoding='utf-8-sig').read()
    cfg = json.loads(raw)
    rest = a[1:]
    if not rest or rest[0].upper() in ('STATUS', '현재'):
        print(describe(cfg, key) + f'  ({PATH})')
        return 0
    v = parse(' '.join(rest))
    if v is None:
        print(f'[FAIL] 값은 ON 또는 OFF (입력: {" ".join(rest)})')
        return 2
    on = v == 'ON'
    if get(cfg, key) == on:
        print('변경 없음. ' + describe(cfg, key))
        return 0
    out = apply_text(raw, key, on)
    if out is None:
        print(f'[ERROR] harness.json 에 {key} 키가 없음. tools/Harness/harness.json 에 그 줄을 먼저 넣는다')
        return 3
    try:
        json.loads(out)
        with open(PATH, 'w', encoding='utf-8', newline='') as f:
            f.write(out)
    except (OSError, ValueError) as e:
        print(f'[ERROR] harness.json 쓰기 실패: {e}')
        return 3
    print(f"{'끔 → 켬' if on else '켬 → 끔'}. " + describe(json.loads(out), key))
    print('VMO 키(orch.*)는 VM 이 harness.json 을 다시 읽을 때, CheckList 키는 다음 CheckList 실행부터 적용된다.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
