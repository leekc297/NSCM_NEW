# -*- coding: utf-8 -*-
"""AS-IS·TO-BE 실측 화면 방식 설정 — tools/Harness/harness.json 의 asisLiveView · e2eView 를 읽고 쓴다(2026-11-20 사용자 지시 '환경설정에 AS-IS 설정 · TO-BE 설정 2개 · 창 없이 실행/창 띄우기/녹화')

  python tools/Harness/verify/set_live_view.py ASIS            AS-IS 현재 값
  python tools/Harness/verify/set_live_view.py ASIS hidden     AS-IS 창 없이 실행 (window = 창 띄우기 · record = 녹화)
  python tools/Harness/verify/set_live_view.py TOBE window     TO-BE 창 띄우기
  python tools/Harness/verify/set_live_view.py --selftest

  AS-IS 실측(런처 실행기 · tools/AsisLive/asis_view.py)
    hidden  실행기 창을 화면 밖으로 옮겨 실행(조작·화면 사진은 같음 · 창이 처음 뜰 때 잠깐 보였다가 옮겨짐)
    window  창 띄우기(종전 · 기본)
    record  창 없이(투명 창) 1초마다 화면을 찍어 동영상 1개로 저장(<실행 폴더>/record.webm · 그 밖 Doc/asislive/_rec/ · ffmpeg 없으면 GIF)
    capture 창 없이(투명 창) 실행하고 새 창이 뜰 때와 끝날 때만 캡처(<실행 폴더>/captures/*.jpg · 2026-11-26 기본)
  TO-BE 실측(Playwright · tools/E2E/playwright.config.ts)
    hidden  창 없이 실행(종전 · 기본)
    window  Chrome 창을 띄우고 동작 사이 e2eSlowMoMs(기본 300ms) 지연 · 작업자 1개
    record  창 없이 실행 + 시험마다 동영상(<결과 폴더>/video/<시각>_<pid>/*.webm · 1280×720)
  녹화 동영상 = Playwright 전용 ffmpeg(%LOCALAPPDATA%/ms-playwright/ffmpeg-1013 · 2026-11-20 사용자 지시로 받음). 다른 PC 는 tools/E2E 에서 node node_modules/playwright-core/cli.js install ffmpeg
  VM 메뉴: 환경설정 → 🖥️ AS-IS 실측 화면 · 🌐 TO-BE 실측 화면 (steps.json S8.asisView · S8.tobeView)
  harness.json 의 다른 줄은 건드리지 않는다(키가 없으면 llmReview 줄 뒤에 한 줄 넣음).
  종료코드 0 · 2 = 값 오류 · 3 = 쓰기 실패
"""
import json
import os
import re
import sys

PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'harness.json'))
KEYS = {'ASIS': ('asisLiveView', 'window', 'AS-IS 실측'), 'TOBE': ('e2eView', 'hidden', 'TO-BE 실측')}
NAMES = {'hidden': '창 없이 실행', 'window': '창 띄우기', 'record': '녹화', 'capture': '창 없이 실행 + 캡처'}
WORDS = {'hidden': 'hidden', '창없이': 'hidden', '창 없이 실행': 'hidden', 'window': 'window', '창띄우기': 'window', '창 띄우기': 'window', 'record': 'record', '녹화': 'record', 'capture': 'capture', '캡처': 'capture', '캡쳐': 'capture'}
SIDE_MODES = {'ASIS': ('hidden', 'window', 'record', 'capture'), 'TOBE': ('hidden', 'window', 'record')}   # 2026-11-26 capture = AS-IS 만(TO-BE 는 FAIL 행 캡처가 이미 있음)


def parse(word):
    w = str(word or '').strip().lower()
    if not w:
        return None
    if w.split()[0] in WORDS:
        return WORDS[w.split()[0]]
    for k, v in WORDS.items():
        if w.startswith(k):
            return v
    return None


def apply_text(text, key, value):
    rx = re.compile(r'("%s"\s*:\s*)"[^"]*"' % re.escape(key))
    if rx.search(text):
        return rx.sub(lambda m: m.group(1) + '"%s"' % value, text, count=1)
    m = re.search(r'\n(\s*)"llmReview"\s*:\s*(true|false)\s*,', text) or re.search(r'\{\s*\n(\s*)', text)
    if not m:
        return None
    ind = m.group(1)
    nl = '\r\n' if '\r\n' in text else '\n'
    return text[:m.end()] + f'{nl}{ind}"{key}": "{value}",' + text[m.end():] if m.re.pattern.startswith('\\n') else text[:m.end()] + f'"{key}": "{value}",{nl}{ind}' + text[m.end():]


def describe(cfg, side):
    key, dflt, label = KEYS[side]
    v = str(cfg.get(key) or dflt)
    extra = f" · 동작 사이 지연 {cfg.get('e2eSlowMoMs', 300)}ms" if side == 'TOBE' and v == 'window' else ''
    return f'{label} 화면 방식 = {NAMES.get(v, v)}({key}={v}){extra}'


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print(('  [OK] ' if c else '  [FAIL] ') + n); ok = ok and bool(c)
    chk('값 해석 — 한글·영문·선택 문구', parse('녹화') == 'record' and parse('hidden') == 'hidden' and parse('window — 창 띄우기') == 'window' and parse('창 없이 실행') == 'hidden')
    chk('값 해석 — 캡처', parse('캡처') == 'capture' and parse('capture') == 'capture' and 'capture' not in SIDE_MODES['TOBE'])
    chk('값 해석 — 모르는 값', parse('xx') is None and parse('') is None)
    src = '{\n  "repairScope": "DB_ONLY",\n  "llmReview": true,\n  "x": 1\n}\n'
    out = apply_text(src, 'e2eView', 'window')
    chk('쓰기 — 키 없으면 llmReview 뒤에 추가', json.loads(out)['e2eView'] == 'window' and json.loads(out)['llmReview'] is True)
    out2 = apply_text(out, 'e2eView', 'record')
    chk('쓰기 — 있으면 값만 바꿈', json.loads(out2)['e2eView'] == 'record' and out2.count('e2eView') == 1)
    out3 = apply_text('{\n  "a": 1\n}\n', 'asisLiveView', 'hidden')
    chk('쓰기 — llmReview 없어도 추가', json.loads(out3)['asisLiveView'] == 'hidden')
    chk('설명 — TO-BE 기본 = 창 없이 실행', '창 없이 실행' in describe({}, 'TOBE') and '창 띄우기' in describe({}, 'ASIS'))
    print('SELFTEST ' + ('OK' if ok else 'FAIL'))
    return 0 if ok else 1


def main():
    a = [x for x in sys.argv[1:] if x.strip()]
    if a and a[0] == '--selftest':
        return selftest()
    if not a or a[0].upper() not in KEYS:
        print('[FAIL] 첫 인자는 ASIS 또는 TOBE'); return 2
    side = a[0].upper(); key = KEYS[side][0]
    raw = open(PATH, encoding='utf-8-sig').read(); cfg = json.loads(raw)
    rest = ' '.join(a[1:]).strip()
    if not rest or rest.upper() in ('STATUS', '현재'):
        print(describe(cfg, side) + f'  ({PATH})'); return 0
    v = parse(rest)
    if v is None or v not in SIDE_MODES[side]:
        print(f"[FAIL] {side} 값은 " + ' · '.join(f'{m}({NAMES[m]})' for m in SIDE_MODES[side]) + f' (입력: {rest})'); return 2
    if str(cfg.get(key) or KEYS[side][1]) == v and key in cfg:
        print('변경 없음 — ' + describe(cfg, side)); return 0
    out = apply_text(raw, key, v)
    try:
        json.loads(out)
        with open(PATH, 'w', encoding='utf-8', newline='') as f:
            f.write(out)
    except Exception as e:
        print(f'[ERROR] harness.json 쓰기 실패: {e}'); return 3
    print('변경 — ' + describe(json.loads(out), side) + ' · 다음 실측부터 적용')
    return 0


if __name__ == '__main__':
    sys.exit(main())
