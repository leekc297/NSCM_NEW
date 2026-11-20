# -*- coding: utf-8 -*-
"""분류 CSV(Doc/verify/sources/_classified/*.csv 또는 defects_classified.csv) 형식·일관성 검사 — 보고만(자동 수정 없음)

  python tools/Harness/verify/validate_classified.py [paths...]   (기본: Doc/verify/sources/_classified/*.csv)
  python tools/Harness/verify/validate_classified.py --merged     (defects_classified.csv 확장 행 검사)

검사: 열 순서 · 열거값(status/generalize/general_rule/detectable/human_check) · rule_ids 가 카탈로그(detect_rules.csv + G9/E7 예정 + NEW-*) 에 있는지 ·
      menu_id 가 menu.csv 에 있는지(COMMON·공란 허용) · target 에 라틴 토큰(3자 이상) 유무 · DESIGN 행의 asis/tobe/reason/human_check ·
      같은 gap_item(화면 무관)의 rule_ids 일관성(보고) · 원천 CSV 와 (src,no) 대응(누락·초과) · 중복 (src,no)
종료코드 0 = 오류 0(경고는 허용) · 1 = 오류 있음
"""
import csv
import glob
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
COLS = ['src', 'no', 'menu_id', 'family', 'rule_ids', 'oracle', 'method', 'target', 'condition', 'expected', 'general_rule', 'general_rule_text',
        'detectable', 'undetectable_reason', 'note', 'proposed_new', 'status', 'generalize', 'src_file', 'src_sheet', 'src_row', 'gap_item',
        'evidence_ref', 'human_check', 'classified_by', 'classified_at', 'target_tokens', 'asis', 'tobe', 'reason']
ENUM = {'status': {'DEFECT', 'DESIGN', 'OPEN', 'REQ', 'INFO'}, 'generalize': {'Y', 'N', ''}, 'general_rule': {'Y', 'N', ''}, 'detectable': {'Y', 'N', ''},
        'human_check': {'', '보류', '확인(원천 제외)', '확인'}}
EXTRA_RULES = {'G9', 'E7', 'UNCLASSIFIED'}
SRC_FILES = {'GAP': 'gap_analysis_20260928.csv', 'GAPPI': 'gap_analysis_20260928.csv', 'GAPSELF': 'gap_analysis_20260928.csv',
             'SSP45': 'scpssp_test_dmf0045.csv', 'SSP45REQ': 'scpssp_test_dmf0045.csv'}


def read_csv(p):
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def main():
    a = [x for x in sys.argv[1:] if not x.startswith('--')]
    merged = '--merged' in sys.argv
    paths = a or ([P('Doc', 'verify', 'defects_classified.csv')] if merged else sorted(glob.glob(P('Doc', 'verify', 'sources', '_classified', '*.csv'))))
    rules = {r['rule_id'] for r in read_csv(P('tools', 'Harness', 'verify', 'detect_rules.csv'))} | EXTRA_RULES
    menu = {r['mnu_id'] for r in read_csv(P('Doc', 'tobefacts', 'db', 'menu.csv'))}
    src_rows = {}
    for f in set(SRC_FILES.values()):
        p = P('Doc', 'verify', 'sources', f)
        if os.path.exists(p):
            for r in read_csv(p):
                s, n = r['row_id'].split('-', 1)
                src_rows[(s, n)] = r
    errs, warns = [], []
    seen = {}
    by_gap = {}
    total = 0
    for p in paths:
        if not os.path.exists(p):
            errs.append(f'{p}: 파일 없음'); continue
        with open(p, encoding='utf-8-sig', newline='') as f:
            rd = csv.DictReader(f); rows = list(rd); cols = rd.fieldnames or []
        rel = os.path.relpath(p, ROOT)
        if not merged and cols != COLS:
            errs.append(f'{rel}: 열 순서/이름 불일치 — 기대 {COLS[:6]}… 실제 {cols[:6]}… (누락 {sorted(set(COLS) - set(cols))} · 초과 {sorted(set(cols) - set(COLS))})')
        for i, r in enumerate(rows, 2):
            if r.get('src') not in SRC_FILES and not merged:
                errs.append(f'{rel}:{i} src 값 이상 {r.get("src")!r}')
            if merged and r.get('src') not in SRC_FILES:
                continue  # 기존 DM/SCPSSP 행은 검사 대상 아님
            total += 1
            key = (r['src'], r['no'])
            if key in seen:
                errs.append(f'{rel}:{i} 중복 (src,no) {key} — 먼저 {seen[key]}')
            seen[key] = f'{rel}:{i}'
            if key not in src_rows:
                errs.append(f'{rel}:{i} 원천에 없는 행 {key}')
            for col, allowed in ENUM.items():
                if (r.get(col) or '') not in allowed:
                    errs.append(f'{rel}:{i} {col}={r.get(col)!r} 허용값 아님 {sorted(allowed)}')
            st = r.get('status') or ''
            rids = [x.strip() for x in (r.get('rule_ids') or '').split(';') if x.strip()]
            if st in ('DEFECT', 'DESIGN', 'OPEN', 'REQ') and not rids:
                errs.append(f'{rel}:{i} {key} status={st} 인데 rule_ids 공란')
            for x in rids:
                if x not in rules and not x.startswith('NEW-'):
                    errs.append(f'{rel}:{i} {key} rule_id {x} 카탈로그에 없음')
                if x.startswith('NEW-') and not (r.get('proposed_new') or '').strip():
                    errs.append(f'{rel}:{i} {key} NEW 규칙 {x} 인데 proposed_new 공란')
            fam = ''.join(sorted({x[0] for x in rids if re.match(r'^[A-N]\d', x) or x == 'MS1'}))  # MS1(메시지 의미 대조)의 가족은 M
            if rids and st != 'INFO' and set((r.get('family') or '').replace(';', '')) != set(fam) and fam:
                warns.append(f'{rel}:{i} {key} family={r.get("family")!r} ≠ rule_ids 가족 {";".join(sorted(fam))}')
            mid = r.get('menu_id') or ''
            if mid and mid != 'COMMON' and mid not in menu:
                errs.append(f'{rel}:{i} {key} menu_id {mid} 가 menu.csv 에 없음')
            if st in ('DEFECT', 'DESIGN', 'OPEN') and not re.search(r'[A-Za-z][A-Za-z_]{2,}', r.get('target') or ''):
                errs.append(f'{rel}:{i} {key} target 에 라틴 식별자 없음: {(r.get("target") or "")[:60]!r}')
            if st in ('DEFECT', 'DESIGN', 'OPEN', 'REQ') and not (r.get('expected') or '').strip():
                errs.append(f'{rel}:{i} {key} expected 공란')
            if st == 'DESIGN':
                for c in ('asis', 'tobe', 'reason'):
                    if not (r.get(c) or '').strip():
                        errs.append(f'{rel}:{i} {key} DESIGN 인데 {c} 공란')
                if (r.get('human_check') or '') not in ('확인(원천 제외)', '보류', '확인'):
                    errs.append(f'{rel}:{i} {key} DESIGN 인데 human_check={r.get("human_check")!r}')
                if not (r.get('target_tokens') or '').strip():
                    errs.append(f'{rel}:{i} {key} DESIGN 인데 target_tokens 공란(판정 행 대조 불가)')
            if st == 'INFO' and rids:
                warns.append(f'{rel}:{i} {key} INFO 인데 rule_ids 있음')
            if (r.get('detectable') or '') == 'N' and not (r.get('undetectable_reason') or '').strip() and st != 'INFO':
                errs.append(f'{rel}:{i} {key} detectable=N 인데 undetectable_reason 공란')
            src = src_rows.get(key)
            if src:
                for c in ('src_sheet', 'src_row'):
                    if (r.get(c) or '') != (src.get(c) or ''):
                        errs.append(f'{rel}:{i} {key} {c}={r.get(c)!r} ≠ 원천 {src.get(c)!r}')
                code = (src.get('화면 코드') or '').strip()
                exp_mid = {'공통': 'COMMON', 'DMF00005': 'DMF0005'}.get(code, code)
                if r['src'].startswith('SSP45'):
                    exp_mid = 'COMMON' if r['src'] == 'SSP45REQ' else 'DMF0045'
                if exp_mid and mid != exp_mid:
                    errs.append(f'{rel}:{i} {key} menu_id {mid!r} ≠ 원천 화면 코드 {exp_mid!r}')
                stt = (src.get('처리 상태') or '').replace('\n', ' ').strip()
                if r['src'] == 'GAP' and stt == '제외' and st != 'DESIGN':
                    warns.append(f'{rel}:{i} {key} 처리 상태 제외인데 status={st}')
                if r['src'] == 'GAP' and re.search(r'확인필요|수정필요|재수정중', stt) and st != 'OPEN':
                    warns.append(f'{rel}:{i} {key} 처리 상태 {stt!r} 인데 status={st}')
            gi = (r.get('gap_item') or '').strip()
            if gi:  # 항목 번호(F-xx)는 화면별 번호 — 같은 화면 안에서 같은 항목이 다른 규칙으로 갈리면 보고
                by_gap.setdefault((mid, gi), set()).add(';'.join(sorted(rids)))
    for (m_, gi), s in sorted(by_gap.items()):
        if len(s) > 1:
            warns.append(f'{m_} gap_item {gi}: 같은 화면 같은 항목의 rule_ids 불일치 {sorted(s)}')
    # 원천 대응(누락) — 배치 파일 검사일 때는 배치가 맡은 범위만 알 수 없으니 전체 합산일 때만 의미 있음(--merged 또는 전체 글롭)
    if (merged or not a) and src_rows:
        missing = [k for k in src_rows if k not in seen]
        if missing:
            warns.append(f'원천 행 중 아직 분류되지 않은 행 {len(missing)}건 — 예 {missing[:8]}')
    print(f'분류 행 {total} · 오류 {len(errs)} · 경고 {len(warns)}')
    for e in errs[:200]:
        print('  [ERROR]', e)
    for w in warns[:100]:
        print('  [WARN]', w)
    return 1 if errs else 0


if __name__ == '__main__':
    sys.exit(main())
