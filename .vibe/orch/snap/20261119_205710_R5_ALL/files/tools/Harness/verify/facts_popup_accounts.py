# -*- coding: utf-8 -*-
"""팝업 계정 간 비교 (2026-10-31 E02) — 같은 팝업을 다른 계정으로 연 결과(popup_rowsets.json) 비교

  python -I tools/Harness/verify/facts_popup_accounts.py <MENU_ID> <run 폴더 A> <run 폴더 B> [문서 번호] -> <run 폴더 B>/popup_accounts.csv

판정(문서가 '계정 무관 같은 목록'으로 확정한 팝업만 FAIL — DM-13·GAP-211): 호출 번호·클래스가 같은 행의 행수·앞 3000행 값 집합
  같음 = PASS · 다름 = FAIL(문서 지정 시) / 판정필요(미지정) · 한쪽 측정 없음 = ERROR
버튼 목록 차이(J2·EG370)는 판정하지 않고 증거만 남긴다(권한별 버튼 기대는 메뉴 버튼 권한 메타 몫).
"""
import csv, json, os, sys

FIELDS = ['menu', 'call', 'cls', 'accounts', 'result', 'rows', 'diff', 'buttons', 'basis']


def main(mid, a, b, doc=''):
    ra = {(r['call'], r['cls']): r for r in json.load(open(os.path.join(a, 'popup_rowsets.json'), encoding='utf-8'))}
    rb = {(r['call'], r['cls']): r for r in json.load(open(os.path.join(b, 'popup_rowsets.json'), encoding='utf-8'))}
    out = []
    for k in sorted(set(ra) | set(rb), key=str):
        x, y = ra.get(k), rb.get(k)
        if not x or not y:
            out.append({'menu': mid, 'call': k[0], 'cls': k[1], 'accounts': '', 'result': 'ERROR', 'rows': '', 'diff': '한쪽 측정 없음', 'buttons': '', 'basis': doc})
            continue
        sa, sb = set(x.get('sample', [])), set(y.get('sample', []))
        same = x['rows'] == y['rows'] and sa == sb
        out.append({'menu': mid, 'call': k[0], 'cls': k[1], 'accounts': f"{x['account']} vs {y['account']}",
                    'result': 'PASS' if same else ('FAIL' if doc else '판정필요'), 'rows': f"{x['rows']} vs {y['rows']}",
                    'diff': f"A만 {len(sa - sb)} · B만 {len(sb - sa)}", 'buttons': f"{x.get('buttons', [])} vs {y.get('buttons', [])}"[:300], 'basis': doc})
    with open(os.path.join(b, 'popup_accounts.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, FIELDS)
        w.writeheader()
        w.writerows(out)
    return out


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    for r in main(*sys.argv[1:5]):
        print(r)
