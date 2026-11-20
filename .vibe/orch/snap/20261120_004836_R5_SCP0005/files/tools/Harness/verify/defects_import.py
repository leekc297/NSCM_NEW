"""결함 원장(사람이 수행한 단위테스트 결과) → Doc/verify/defects_baseline.csv

  python tools/Harness/verify/defects_import.py [--dm <xlsx>] [--scp <xlsx>]

정답지(수용 기준) — 검증 시스템이 이 원장의 결함을 전부 도출해야 한다(계획 P0, 2026-10-23).
  · 공통·DM : 최종 단위테스트 결과 점검 (zio 관리) — 시트 '수정사항'
  · SCP·SSP : SCP & SSP 단위테스트 결과 — 시트 '확인사항'
UI명 → MENU_ID 는 Doc/tobefacts/db/menu.csv 의 mnu_desc 정확 일치 → 아래 ALIAS 순으로 찾는다. 못 찾으면 menu_id 공란 + map_status=UNMAPPED.
분류 열(family·oracle·…)은 비워 둔다 — defects_classified.csv 가 행 단위 판독 결과로 채운다(자동 키워드 분류 금지: anti-simplification).
"""
import argparse
import csv
import os
import re
import sys

import openpyxl

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
DEFAULT_DM = r'C:\TRANFILE\RECEIVE\최종 단위테스트 결과 점검 (zio 관리) _ 202600826.xlsx'
DEFAULT_SCP = r'C:\TRANFILE\RECEIVE\SCP & SSP 단위테스트 결과 v1.0.xlsx'
OUT = os.path.join(ROOT, 'Doc', 'verify', 'defects_baseline.csv')

# 원장 UI명 ↔ menu.csv mnu_desc 가 다른 화면(실측 2026-10-23). 공통 행은 COMMON.
ALIAS = {
    'FCST&PRICE MGMT': 'DMF0082',
    'N:N Mapping Master': 'DMF0072',
    'ERP EDI Master Validation': 'DMF0008',
    'Demand manager': 'DMF0068',
    'ETC Sales Report': 'DMF0049',
    'ETC Sales Reports': 'DMF0049',
    'Dynamic Query': 'SYS0013',
    'BOD': 'SCP0007',
    'Project Route': 'SCP0006',
    'Master→Shipment Lot Size': 'SCP0028',
    'Master→Distribution Route': 'SCP0005',
    'API Management': 'SYS0006',
    'Proc. Setting': 'SYS0005',
}
COMMON_PAT = re.compile(r'(?:^(?:공통|전체\s*(?:팝업\s*)?UI|일부\s*UI))|(?:^(?:Common|Home)$)', re.I)

COLS = ['src', 'no', 'category', 'ui_name', 'menu_id', 'map_status', 'div', 'test_content', 'defect_type', 'test_result',
        'recur', 'zionex_status', 'action_note', 'req_date', 'done_date', 'confirm_date', 'open']


def norm(s):
    return re.sub(r'\s+', ' ', str(s or '').replace('\n', ' ').replace('\x0b', ' ').replace('_x000B_', ' ')).strip()


def load_menu():
    path = os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'menu.csv')
    by_desc = {}
    with open(path, encoding='utf-8-sig') as f:
        for r in csv.DictReader(f):
            d = norm(r['mnu_desc']).lower()
            if d and r.get('use_yn', 'Y') == 'Y' and not d.endswith('_bk'):
                by_desc.setdefault(d, r['mnu_id'])
    return by_desc


def map_menu(ui, by_desc):
    u = norm(ui)
    if not u:
        return '', 'UNMAPPED'
    if COMMON_PAT.match(u) or u.startswith('공통(') or u.startswith('전체 UI'):
        return 'COMMON', 'COMMON'
    if u in ALIAS:
        return ALIAS[u], 'ALIAS'
    m = by_desc.get(u.lower())
    if m:
        return m, 'EXACT'
    # 원장 표기 '…(41자 잘림)' 대비: 접두 일치 1건일 때만
    cands = [v for k, v in by_desc.items() if k.startswith(u.lower()) or u.lower().startswith(k)]
    if len(set(cands)) == 1:
        return cands[0], 'PREFIX'
    return '', 'UNMAPPED'


def read_sheet(path, sheet):
    ws = openpyxl.load_workbook(path, read_only=True, data_only=True)[sheet]
    rows = list(ws.iter_rows(values_only=True))
    hdr = [norm(c) for c in rows[1]]
    out = []
    for r in rows[2:]:
        cells = list(r) + [None] * (len(hdr) - len(r))
        d = {}
        for i, h in enumerate(hdr):
            if h and h not in d:  # 중복 헤더(조치결과 확인일자·유형)는 첫 열
                d[h] = norm(cells[i]) if cells[i] is not None else ''
        # 번호만 있는 빈 양식 행 제외(SCP·SSP 시트 104행 실측) — 판정 근거는 테스트 내용·결과
        if d.get('No.') and (pick(d, '테스트 내용') or pick(d, '테스트 결과')):
            out.append(d)
    return out


def pick(d, *keys):
    for k in keys:
        for h, v in d.items():
            if h.startswith(k) and v:
                return v
    return ''


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--dm', default=DEFAULT_DM)
    ap.add_argument('--scp', default=DEFAULT_SCP)
    a = ap.parse_args()
    by_desc = load_menu()
    rows = []
    for src, path, sheet in (('DM', a.dm, '수정사항'), ('SCPSSP', a.scp, '확인사항')):
        if not os.path.exists(path):
            print(f'[ERROR] 원장 없음: {path}', file=sys.stderr)
            return 2
        for d in read_sheet(path, sheet):
            ui = pick(d, 'UI명')
            mid, ms = map_menu(ui, by_desc)
            status = pick(d, 'Zionex 확인')
            done = pick(d, '조치완료일')
            rows.append({
                'src': src, 'no': d.get('No.', ''), 'category': pick(d, '구분'), 'ui_name': ui, 'menu_id': mid, 'map_status': ms,
                'div': pick(d, 'Div'), 'test_content': pick(d, '테스트 내용'), 'defect_type': d.get('유형', ''),
                'test_result': pick(d, '테스트 결과'), 'recur': pick(d, '재결함 차수'), 'zionex_status': status,
                'action_note': pick(d, '수정사항 테스트 결과 증빙', '결함 확인&조치 결과'), 'req_date': pick(d, '요청일자')[:10],
                'done_date': done[:10], 'confirm_date': pick(d, '조치결과 확인일자', '조치결과 PI 확인일자')[:10],
                'open': 'N' if (done or status.startswith('4')) else 'Y',
            })
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(rows)
    by = {}
    for r in rows:
        by.setdefault((r['src'], r['map_status']), 0)
        by[(r['src'], r['map_status'])] += 1
    print(f'{len(rows)}행 → {OUT}')
    for k, v in sorted(by.items()):
        print(f'  {k[0]:7} {k[1]:9} {v}')
    un = sorted({r['ui_name'] for r in rows if r['map_status'] == 'UNMAPPED'})
    if un:
        print('  UNMAPPED UI명:', ' / '.join(un))
    print(f"  미조치(open=Y) {sum(r['open'] == 'Y' for r in rows)}건")
    return 0


if __name__ == '__main__':
    sys.exit(main())
