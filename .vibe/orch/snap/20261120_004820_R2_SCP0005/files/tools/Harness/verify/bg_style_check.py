# -*- coding: utf-8 -*-
"""AS-IS 조건부 셀 스타일(SetBGColor/SetFontColor/SetForeColor) ↔ TO-BE 화면 스타일 코드 존재(H2 정적 · EG312 · SCPSSP-14) — Doc/verify/<ID>/bg_style.csv (2026-11-03)

  python -I tools/Harness/verify/bg_style_check.py <ID>

  AS-IS : Doc/asisfacts/screens/<ID>/actions.csv 의 GRID_STYLE 행(SetBGColor·SetFontColor·SetForeColor·SetCellColor) — 메서드·색 상수·guard 를 묶어
          '조건부 색 규칙' 로 본다(같은 메서드의 같은 API 는 1건). 색 상수(ControlColor.InvalidColor 등)는 그대로 기록.
  TO-BE : 화면 폴더(nscm-fe/features/*/src/pages/<폴더>) 의 .ts/.tsx 에서 셀 색을 바꾸는 코드 흔적 — formatItem · backgroundColor · setProperty('background
          · setProperty('color · wj-state/sp-cell 클래스 토글 · paintNegativeText — 1건이라도 있으면 '구현 흔적 있음'(색 값·조건 일치는 E2E H2 가 실측)
  판정 : AS-IS 규칙 ≥1 & TO-BE 흔적 0 → FAIL(조건부 배경/글자색 미구현 후보 · 실측 W5) · 흔적 ≥1 → PASS(존재만 · 조건·색 일치는 E2E) · AS-IS 규칙 0 → NA
  변이 : BG_MUTATE=1 → TO-BE 흔적을 0 으로 간주해 FAIL 경로 확인
"""
import csv, glob, os, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
COLS = ['method', 'api', 'color', 'guard', 'tobe_hits', 'result', 'why']
API_RE = re.compile(r'\.(SetBGColor2?|SetFontColor|SetForeColor|SetCellColor|SetBackColor)$')  # 2026-11-18 SCP0111 SetBGColor2(cs:757·782) 누락 → '색 규칙 없음' NA 오판
TOBE_RE = re.compile(r"formatItem|backgroundColor|setProperty\('background|setProperty\('color|paintNegativeText|cell\.style\.(background|color)|classList\.(add|toggle)\([^)]*(color|bg|invalid|valid|lock|current)", re.I)


def page_dir(mid):
    for p in glob.glob(os.path.join(ROOT, 'nscm-fe', 'features', '*', 'src', 'pages', '*', '*.constants.ts')):
        try:
            if f"MENU_ID = '{mid}'" in open(p, encoding='utf-8').read():
                return os.path.dirname(p)
        except Exception:
            pass
    return ''


def tobe_hits(d):
    hits = []
    for p in glob.glob(os.path.join(d, '**', '*.ts*'), recursive=True):
        if p.endswith('.test.ts') or p.endswith('.test.tsx'): continue
        try:
            for i, line in enumerate(open(p, encoding='utf-8'), 1):
                if TOBE_RE.search(line) and not line.strip().startswith('//'):
                    hits.append(f"{os.path.relpath(p, ROOT)}:{i}")
        except Exception:
            pass
    return hits


def judge(n_rules, hits):
    if n_rules == 0: return 'NA', 'AS-IS 조건부 셀 색 규칙 없음'
    if not hits: return 'FAIL', f'AS-IS 조건부 셀 색 규칙 {n_rules}건인데 TO-BE 화면 코드에 셀 색 변경 흔적 0 — 미구현 후보(조건·색 일치는 E2E H2 실측 대상)'
    return 'PASS', f'TO-BE 셀 색 변경 코드 {len(hits)}곳 존재(예 {hits[0]}) — 조건·색 일치는 E2E H2 실측'


def selftest():
    assert judge(0, [])[0] == 'NA' and judge(3, [])[0] == 'FAIL' and judge(3, ['a:1'])[0] == 'PASS'
    print('selftest ok')


def main(mid):
    acts = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', mid, 'actions.csv')
    rules = {}
    if os.path.exists(acts):
        for r in csv.DictReader(open(acts, encoding='utf-8-sig', newline='')):
            if r.get('kind') != 'GRID_STYLE': continue
            m = API_RE.search(r.get('target') or '')
            if not m: continue
            color = (re.search(r'ControlColor\.\w+|Color\.\w+', r.get('args') or '') or [''])[0] if isinstance(re.search(r'ControlColor\.\w+|Color\.\w+', r.get('args') or ''), re.Match) else ''
            key = (r.get('method'), m.group(1), color)
            rules.setdefault(key, (r.get('guard') or '')[:160])
    d = page_dir(mid)
    hits = tobe_hits(d) if d else []
    if os.environ.get('BG_MUTATE') == '1': hits = []
    res = []
    r_, why = judge(len(rules), hits)
    if rules:
        for (meth, api, color), guard in sorted(rules.items()):
            res.append({'method': meth, 'api': api, 'color': color, 'guard': guard, 'tobe_hits': len(hits), 'result': r_, 'why': why + (f' · AS-IS {meth} {api} {color} [{guard[:80]}]' if guard else f' · AS-IS {meth} {api} {color}') + (' · [변이 BG_MUTATE]' if os.environ.get('BG_MUTATE') == '1' else '')})
    else:
        res.append({'method': '', 'api': '', 'color': '', 'guard': '', 'tobe_hits': len(hits), 'result': 'NA', 'why': why})
    vd = os.path.join(ROOT, 'Doc', 'verify', mid); os.makedirs(vd, exist_ok=True)
    with open(os.path.join(vd, 'bg_style.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, COLS); w.writeheader(); w.writerows(res)
    print(f"[bg_style] {mid}: AS-IS 규칙 {len(rules)}건 · TO-BE 흔적 {len(hits)}곳({d and os.path.relpath(d, ROOT)}) → {r_}")
    return 0


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest': selftest(); sys.exit(0)
    if len(sys.argv) < 2: sys.exit(__doc__)
    sys.exit(main(sys.argv[1]))
