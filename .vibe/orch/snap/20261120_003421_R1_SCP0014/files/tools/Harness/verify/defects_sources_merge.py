# -*- coding: utf-8 -*-
"""원천 CSV(Doc/verify/sources/*.csv · sources_extract.py 산출) → 결함 원장 확장 (2026-10-30 2단계)

  python tools/Harness/verify/defects_sources_merge.py            # baseline 확장 + 분류 병합 + 설계 결정 CSV 생성
  python tools/Harness/verify/defects_sources_merge.py --baseline-only

① Doc/verify/defects_baseline.csv — 기존 DM/SCPSSP 행(defects_import.py 소유)은 그대로 두고 src ∈ {GAP, GAPPI, GAPSELF, SSP45, SSP45REQ} 행을 뒤에 다시 쓴다(재실행 멱등).
   열 대응(기존 COLS 그대로): 화면 코드→menu_id · 업무 현상+AS-IS→test_content · TO-BE+근거→test_result · 조치 담당→defect_type · 처리 상태→zionex_status ·
   처리 내역·반영 내역·확인사항·테스트→action_note · 수정 일자→done_date · 화면 확인→confirm_date · open=Y ⇔ 처리 상태 확인필요·수정필요·재수정중(또는 PI/자체 미완료)
② Doc/verify/defects_classified.csv — Doc/verify/sources/_classified/*.csv(validate_classified.py 통과분)의 행을 (src,no) 로 병합(기존 DM/SCPSSP 행 유지 · 확장 열은 기존 행에 공란).
③ tools/Harness/rules/design_decisions.csv — 분류 status=DESIGN 행 → DD-<n> (judge 가 FAIL→NA '설계 결정' 전환에 쓴다 · human_check 확인(원천 제외)/확인 만 적용).
ledger.py 는 src 값과 무관하게 (src,no) 로 DEFECT/GENERAL 행을 만들므로 하류 변경 없음(row_id 안정).
"""
import argparse
import csv
import glob
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import defects_import as DI  # noqa: E402  (COLS · norm · load_menu · map_menu 재사용)

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
SRC_DIR = P('Doc', 'verify', 'sources')
NEW_SRC = ('GAP', 'GAPPI', 'GAPSELF', 'SSP45', 'SSP45REQ')
CODE_FIX = {'공통': 'COMMON', 'DMF00005': 'DMF0005'}
CLS_COLS = ['src', 'no', 'menu_id', 'family', 'rule_ids', 'oracle', 'method', 'target', 'condition', 'expected', 'general_rule', 'general_rule_text',
            'detectable', 'undetectable_reason', 'note', 'proposed_new', 'status', 'generalize', 'src_file', 'src_sheet', 'src_row', 'gap_item',
            'evidence_ref', 'human_check', 'classified_by', 'classified_at', 'target_tokens', 'asis', 'tobe', 'reason']
DD_COLS = ['dd_id', 'src', 'no', 'menu_id', 'scope', 'gap_item', 'rule_ids', 'target', 'target_tokens', 'condition', 'asis', 'tobe', 'reason', 'status',
           'decided_by', 'decided_at', 'human_check', 'note']


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def write_csv(p, cols, rows):
    with open(p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols); w.writeheader()
        for r in rows:
            w.writerow({c: r.get(c, '') for c in cols})


def join(*parts, sep=' ｜ '):
    return sep.join(DI.norm(x) for x in parts if DI.norm(x))


def baseline_rows(by_desc):
    out = []
    g = read_csv(os.path.join(SRC_DIR, 'gap_analysis_20260928.csv'))
    s = read_csv(os.path.join(SRC_DIR, 'scpssp_test_dmf0045.csv'))
    for r in g + s:
        src, no = r['row_id'].split('-', 1)
        sheet = r['src_sheet']
        code = DI.norm(r.get('화면 코드'))
        if src == 'SSP45REQ':
            mid, ms = 'COMMON', 'COMMON'
        elif src == 'SSP45':
            mid, ms = 'DMF0045', 'EXACT'
        elif code in CODE_FIX:
            mid, ms = CODE_FIX[code], 'ALIAS' if code != '공통' else 'COMMON'
        elif code:
            mid, ms = code, 'EXACT'
        else:
            mid, ms = DI.map_menu(DI.norm(r.get('화면 이름')), by_desc) if DI.norm(r.get('화면 이름')) else ('', 'UNMAPPED')
            if isinstance(mid, tuple):
                mid, ms = mid
        state = DI.norm(r.get('처리 상태'))
        if sheet == '갭분석':
            tc = join(r.get('업무 현상'), ('AS-IS: ' + DI.norm(r.get('AS-IS'))) if DI.norm(r.get('AS-IS')) else '')
            tr = join(r.get('TO-BE'), ('근거: ' + DI.norm(r.get('근거'))) if DI.norm(r.get('근거')) else '')
            note = join(('처리: ' + DI.norm(r.get('처리 내역'))) if DI.norm(r.get('처리 내역')) else '', ('반영: ' + DI.norm(r.get('반영 내역'))) if DI.norm(r.get('반영 내역')) else '',
                        ('확인사항: ' + DI.norm(r.get('확인사항'))) if DI.norm(r.get('확인사항')) else '', ('테스트: ' + DI.norm(r.get('테스트'))) if DI.norm(r.get('테스트')) else '')
            cat = join(r.get('구분'), r.get('항목 번호'), r.get('대상 기능'), sep=' · ')
            dtype = DI.norm(r.get('조치 담당'))
            opn = 'Y' if re.search(r'확인필요|수정필요|재수정중', state) else 'N'
            done, conf = DI.norm(r.get('수정 일자')), DI.norm(r.get('화면 확인'))
            div = DI.norm(r.get('사업부 · 대상'))
        elif sheet in ('PI확인요청', '자체결함확인'):
            tc = DI.norm(r.get('업무 현상'))
            tr = DI.norm(r.get('처리 내역'))
            note = ''
            cat = join(sheet, r.get('세부 구분'), r.get('항목 번호'), sep=' · ')
            dtype = ''
            opn = 'N' if re.search(r'완료|품질반영|제외', state) else ('Y' if (tc or tr) else 'N')
            done, conf = DI.norm(r.get('수정 일자')), ''
            div = DI.norm(r.get('사업부 · 대상'))
        elif sheet == '공통요건':
            tc = DI.norm(r.get('내용'))
            tr = ''
            note = join(('관련 팀: ' + DI.norm(r.get('관련 팀'))) if DI.norm(r.get('관련 팀')) else '', r.get('비고'))
            cat = join('공통요건', r.get('구분'), sep=' · ')
            dtype, opn, done, conf, div = '', 'N', '', '', '공통'
            state = '요건'
        else:  # 검증내역
            tc = DI.norm(r.get('테스트 내용'))
            tr = DI.norm(r.get('조치결과'))
            note = join(r.get('요청내용 확인일자'), r.get('조치결과 확인일자(A)'), r.get('조치결과 확인일자(M)'))
            cat = join(r.get('구분') or 'SCP', r.get('유형'), sep=' · ')
            dtype = ''
            opn = 'N' if re.search(r'처리 완료|수정|재현 불가', tr) else ('Y' if tc else 'N')
            done, conf, div = '', '', DI.norm(r.get('Div'))
            state = tr[:40]
        out.append({'src': src, 'no': no, 'category': cat, 'ui_name': DI.norm(r.get('화면 이름') or r.get('UI명') or ('공통요건' if src == 'SSP45REQ' else 'Shipment Request')),
                    'menu_id': mid, 'map_status': ms, 'div': div, 'test_content': tc, 'defect_type': dtype, 'test_result': tr, 'recur': '',
                    'zionex_status': state, 'action_note': note, 'req_date': DI.norm(r.get('요청 일자') or r.get('요청일자')), 'done_date': done, 'confirm_date': conf, 'open': opn})
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--baseline-only', action='store_true')
    a = ap.parse_args()
    by_desc = DI.load_menu()
    # ① baseline
    bp = P('Doc', 'verify', 'defects_baseline.csv')
    base = [r for r in read_csv(bp) if r['src'] not in NEW_SRC]
    new = baseline_rows(by_desc)
    write_csv(bp, DI.COLS, base + new)
    import collections
    print(f"defects_baseline.csv: 기존 {len(base)} + 추가 {len(new)} = {len(base) + len(new)} · 추가 src {dict(collections.Counter(r['src'] for r in new))} · map {dict(collections.Counter(r['map_status'] for r in new))} · open Y {sum(1 for r in new if r['open'] == 'Y')}")
    if a.baseline_only:
        return 0
    # ② classified 병합
    cp = P('Doc', 'verify', 'defects_classified.csv')
    old = read_csv(cp)
    old_cols = list(old[0].keys()) if old else CLS_COLS[:16]
    keep = [r for r in old if r['src'] not in NEW_SRC]
    newc = []
    for f in sorted(glob.glob(os.path.join(SRC_DIR, '_classified', '*.csv'))):
        newc += read_csv(f)
    seen = {}
    for r in newc:
        seen[(r['src'], r['no'])] = r  # 뒤 파일이 앞을 덮음(배치 재작성 허용)
    # 2026-10-30 배치가 제안한 NEW-* 규칙 → 카탈로그 규칙 ID(detect_rules.csv 에 등록 · impl=N 이면 judge 가 W4 수동 검수로 분류)
    NEW_MAP = {'NEW-FBucketDay': 'F9', 'NEW-FAtomicTxn': 'F10', 'NEW-FSaveAtomic': 'F10', 'NEW-HLoadingSpinner': 'H11', 'NEW-HGridFixedCol': 'H12', 'NEW-HFixedCol': 'H12', 'NEW-GEnterPopup': 'G10'}
    for r in seen.values():
        ids = [x.strip() for x in (r.get('rule_ids') or '').split(';') if x.strip()]
        if ids:  # family 는 rule_ids 가족 문자에서 일관되게(배치별 표기 차이 정리)
            r['family'] = ';'.join(sorted({x[0] for x in ids if re.match(r'^[A-N]\d', x) or x == 'MS1'}))
        if any(x in NEW_MAP for x in ids):
            r['note'] = ((r.get('note') or '') + ' | NEW→카탈로그: ' + ', '.join(f'{x}→{NEW_MAP[x]}' for x in ids if x in NEW_MAP))[:1200]
            ids = list(dict.fromkeys(NEW_MAP.get(x, x) for x in ids))
            r['rule_ids'] = ';'.join(ids)
            r['family'] = ';'.join(sorted({x[0] for x in ids if re.match(r'^[A-N]\d', x) or x == 'MS1'}))
    cols = old_cols + [c for c in CLS_COLS if c not in old_cols]
    write_csv(cp, cols, keep + list(seen.values()))
    print(f"defects_classified.csv: 기존 {len(keep)} + 확장 {len(seen)} = {len(keep) + len(seen)} · status {dict(collections.Counter(r.get('status') for r in seen.values()))}")
    missing = [(r['src'], r['no']) for r in new if (r['src'], r['no']) not in seen]
    print(f"   분류 없는 확장 행 {len(missing)}건" + (f" — 예 {missing[:6]} (ledger 는 UNCLASSIFIED 로 넣는다)" if missing else ''))
    # ③ design_decisions.csv
    dp = P('tools', 'Harness', 'rules', 'design_decisions.csv')
    dd = []
    for i, r in enumerate(sorted((x for x in seen.values() if x.get('status') == 'DESIGN'), key=lambda x: (x['src'], len(x['no']), x['no'])), 1):
        dd.append({'dd_id': f'DD-{i:03d}', 'src': r['src'], 'no': r['no'], 'menu_id': r.get('menu_id') or '', 'scope': r.get('menu_id') or 'ALL', 'gap_item': r.get('gap_item') or '',
                   'rule_ids': r.get('rule_ids') or '', 'target': r.get('target') or '', 'target_tokens': r.get('target_tokens') or '', 'condition': r.get('condition') or '',
                   'asis': r.get('asis') or '', 'tobe': r.get('tobe') or '', 'reason': r.get('reason') or '', 'status': '제외' if '원천 제외' in (r.get('human_check') or '') else (r.get('note') or '')[:20],
                   'decided_by': r.get('classified_by') or '', 'decided_at': r.get('classified_at') or '', 'human_check': r.get('human_check') or '', 'note': r.get('note') or ''})
    write_csv(dp, DD_COLS, dd)
    print(f"design_decisions.csv: {len(dd)}행 (적용 대상 human_check 확인 {sum(1 for d in dd if d['human_check'].startswith('확인'))} · 보류 {sum(1 for d in dd if d['human_check'] == '보류')})")
    return 0


if __name__ == '__main__':
    sys.exit(main())
