"""hook #154 search-condition-labelless-toggle-input-column — 전수 스캔기 (v2 2026-10-23).

조회조건(SearchArea) 보유 tsx 에서 Radio/RadioGroup/Checkbox 를 찾아, 직전 <Grid 부터 컨트롤까지
구간의 FormItem·label 과 Checkbox 의 labelText 로 배치를 분류한다.
v2 = 조건명은 FormItem 좌측 라벨 열 · Checkbox 는 박스만(labelText 없음) · 조건마다 한 칸.

  OK_V2              FormItem label=조건명 (Checkbox 는 labelText 없음)       → 준수
  LABELED_WITH_TEXT  FormItem label=조건명 + Checkbox labelText(박스 옆 글자) → 위반 후보 X4
  OLD_V1_NBSP        label = NBSP(U+00A0) (v1 무라벨 패턴)                   → v1 잔존 X3
  OLD_V1_SPACE       label = 공백 1칸 (v1 무라벨 패턴)                       → v1 잔존 X3
  NO_FORMITEM        FormItem 없이 Grid 에 직접 배치 → 라벨 열부터 시작       → 위반 후보 X2
  EMPTY_LABEL        FormItem label=''               → 라벨 트랙 미생성      → 위반 후보 X1
  FORMITEM_NOLABEL   FormItem 에 label 미지정         → 라벨 트랙 미생성      → 위반 후보 X1

한계: 헬퍼 렌더·Box 레이아웃 팝업·조회조건 아닌 체크박스는 오분류 가능 → 화면 실측으로 최종 판정.
사용: python -I scripts/rules/scan_labelless_toggle.py nscm-fe/features
"""
import collections
import pathlib
import re
import sys

VIOLATION = ('NO_FORMITEM', 'EMPTY_LABEL', 'FORMITEM_NOLABEL', 'OLD_V1_NBSP', 'OLD_V1_SPACE', 'LABELED_WITH_TEXT')


def classify(seg):
    fi = list(re.finditer(r'<FormItem\b', seg))
    if not fi:
        return 'NO_FORMITEM'
    tail = seg[fi[-1].start():]
    lit = re.search(r"\blabel=\{?(['\"`])(.*?)\1\}?", tail, re.S)
    if lit:
        v = lit.group(2)
        if v == '':
            return 'EMPTY_LABEL'
        if v in ('\\u00A0', '\\u00a0') or v.strip(' \u00A0') == '':
            return 'OLD_V1_SPACE' if v.strip(' ') == '' and '\u00A0' not in v and '\\u00' not in v.lower() else 'OLD_V1_NBSP'
        return 'OK_V2:' + v[:20]
    expr = re.search(r"\blabel=\{([^'\"`][^}]*)\}", tail)
    if expr:
        return 'OK_V2:' + expr.group(1)[:30]
    return 'FORMITEM_NOLABEL'


def scan(root):
    rows = []
    for f in sorted(root.rglob('*.tsx')):
        if 'node_modules' in f.parts or '__tests__' in f.parts:
            continue
        s = f.read_text(encoding='utf-8', errors='ignore')
        if not re.search(r'<SearchArea\b|conditions=\{', s):
            continue
        for m in re.finditer(r'<(Checkbox|RadioGroup|Radio)\b', s):
            # RadioGroup 안의 개별 Radio 는 RadioGroup 1건으로 센다
            if m.group(1) == 'Radio' and s.rfind('<RadioGroup', 0, m.start()) > s.rfind('</RadioGroup>', 0, m.start()):
                continue
            g = s.rfind('<Grid', 0, m.start())
            if g < 0:
                continue
            line = s.count('\n', 0, m.start()) + 1
            cls = classify(s[g:m.start()])
            tag = s[m.start():s.find('>', m.start()) + 1]
            # v2 X4 — 라벨 열에 조건명이 있는데 박스 옆 글자(labelText)도 준 Checkbox
            if m.group(1) == 'Checkbox' and cls.startswith('OK_V2') and re.search(r'\blabelText=', tag):
                cls = 'LABELED_WITH_TEXT:' + cls.split(':', 1)[-1]
            rows.append((f.relative_to(root).as_posix(), line, m.group(1), cls))
    return rows


def main():
    root = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else 'nscm-fe/features')
    rows = scan(root)
    counts = collections.Counter(r[3].split(':')[0] for r in rows)
    print('TOTAL', len(rows), dict(counts))
    print('VIOLATION_CANDIDATES', sum(counts[k] for k in VIOLATION))
    for r in rows:
        print('\t'.join(map(str, r)))


if __name__ == '__main__':
    main()
