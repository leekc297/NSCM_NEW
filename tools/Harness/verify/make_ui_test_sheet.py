# -*- coding: utf-8 -*-
"""UI 테스트 Sheet — CheckList '조치 필요' 시트를 Doc/UI_TEST(SCP&SSP) 의 화면별 테스트 Excel 로 옮긴다
(2026-11-16 사용자 요청: "Checklist 생성 후 Doc/UI_TEST(SCP&SSP) 폴더 내에 Test Excel 문서도 같이 생성")

  python tools/Harness/verify/make_ui_test_sheet.py <MENU_ID> [--checklist <CheckList xlsx>]
  make_verify_docs.py 가 CheckList 저장 직후 build(mid, checklist_path) 를 부른다(실패해도 CheckList 생성은 성공으로 둔다).

입력  CheckList xlsx '조치 필요' 시트(저장본 · 문장 규칙 정리 뒤 문구)
양식  tools/Harness/verify/templates/ui_test_template.xlsx (시트 '공통요건' 23행 · '검증내역' 머리 2행, 원본 = SCP0131 테스트 파일)
출력  Doc/UI_TEST(SCP&SSP)/☆NSCME_SCP&SSP 테스트_<ID>(<메뉴명>).xlsx

사람이 쓰는 파일이라 덮어쓰지 않는다.
  기록한 검증 ID  Doc/verify/<ID>/ui_test_rows.json {파일명: [검증 ID…]} — 사람이 행 문구를 고치거나 행을 지워도 다시 넣지 않음.
                  파일을 지우면 그 파일 몫의 기록은 무시(새로 생성). 테스트 내용 칸에는 검증 ID 를 쓰지 않는다
                  (2026-11-16 14:34 사용자가 SSP0020 파일에서 '검증 ID' 줄을 지움)
  파일 없음           양식 복사 후 조치 필요 행 기록
  파일 있음·이미지 없음 기록에 없는 검증 ID 행만 아래에 덧붙임. 기존 행·공통요건은 그대로.
                      수정 전 원본 = Doc/verify/<ID>/ui_test_backup/<파일>_<일시>.xlsx
  파일 있음·이미지 있음 openpyxl 저장 시 붙여 넣은 캡처가 지워지므로 원본은 건드리지 않음. 새 행은 같은 이름 + '_추가항목.xlsx' 에 기록
  Excel 로 열려 있어 저장 불가 ERROR 출력 후 종료코드 1(CheckList 결과에는 영향 없음)
대상 화면  SCP·SSP(폴더 이름 기준). 다른 화면은 생성하지 않고 안내만 출력.
조치 필요 0행  새 파일을 만들지 않음.
"""
import argparse
import copy
import datetime
import glob
import json
import os
import re
import shutil
import sys
import zipfile

from openpyxl import load_workbook
from openpyxl.styles import Alignment

try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)

OUTDIR = P('Doc', 'UI_TEST(SCP&SSP)')
TEMPLATE = os.path.join(HERE, 'templates', 'ui_test_template.xlsx')
PREFIX = '☆NSCME_SCP&SSP 테스트_'
EXTRA = '_추가항목'
SHEET = '검증내역'
HEAD_ROW = 2          # 검증내역 머리 행
NCOL = 14             # A~N
ID_RX = re.compile(r'검증 ID[ :]*([A-Z]{1,3}-[0-9A-Za-z]{6,})')
CR_RX = re.compile(r'CR-\d+')
TARGET_PREFIX = ('SCP', 'SSP')


def menu_name(mid):
    import csv
    try:
        with open(P('Doc', 'tobefacts', 'db', 'menu.csv'), encoding='utf-8-sig') as f:
            for r in csv.DictReader(f):
                if (r.get('mnu_id') or '').upper() == mid:
                    return (r.get('mnu_desc') or '').strip() or mid
    except OSError:
        pass
    return mid


def safe_name(s):
    return re.sub(r'[\\/:*?"<>|]', '_', s)


def latest_checklist(mid):
    best, bn = None, -1
    for f in glob.glob(P('Doc', 'UI_CHECKLIST', f'{mid}_*_CheckList_v*.xlsx')):
        m = re.search(r'_v(\d+)\.xlsx$', f)
        if m and int(m.group(1)) > bn and not os.path.basename(f).startswith('~$'):
            best, bn = f, int(m.group(1))
    return best


def read_action_rows(path):
    wb = load_workbook(path, read_only=True, data_only=True)
    if '조치 필요' not in wb.sheetnames:
        raise RuntimeError(f"'조치 필요' 시트 없음 — {os.path.basename(path)}")
    it = wb['조치 필요'].iter_rows(values_only=True)
    hdr = [str(h or '') for h in next(it)]
    rows = [dict(zip(hdr, ['' if v is None else str(v) for v in r])) for r in it if any(v not in (None, '') for v in r)]
    wb.close()
    return rows


def has_images(path):
    try:
        names = zipfile.ZipFile(path).namelist()
    except (OSError, zipfile.BadZipFile):
        return False
    return any(n.startswith(('xl/media/', 'xl/drawings/', 'xl/charts/')) for n in names)


def ids_in(path):
    if not path or not os.path.exists(path):
        return set()
    wb = load_workbook(path, read_only=True, data_only=True)
    out = set()
    if SHEET in wb.sheetnames:
        for r in wb[SHEET].iter_rows(min_row=HEAD_ROW + 1, values_only=True):
            for v in r:
                if isinstance(v, str):
                    out.update(ID_RX.findall(v))
    wb.close()
    return out


def state_path(mid):
    return P('Doc', 'verify', mid, 'ui_test_rows.json')


def load_state(mid):
    try:
        with open(state_path(mid), encoding='utf-8') as f:
            d = json.load(f)
        return d if isinstance(d, dict) else {}
    except (OSError, ValueError):
        return {}


def save_state(mid, st):
    os.makedirs(os.path.dirname(state_path(mid)), exist_ok=True)
    with open(state_path(mid), 'w', encoding='utf-8') as f:
        json.dump(st, f, ensure_ascii=False, indent=1)


def recorded_ids(mid, paths):
    """있는 파일 몫의 기록 + 예전 방식(테스트 내용 칸 '검증 ID <id>') 둘 다"""
    st = load_state(mid)
    out = set()
    for p in paths:
        if p and os.path.exists(p):
            out.update(st.get(os.path.basename(p), []))
            out |= ids_in(p)
    return out


def test_text(r):
    """'테스트 내용' 칸 — [영역] 대상 / CheckList 설명 / AS-IS 근거"""
    lines = [f"[{r.get('영역', '')}] {r.get('대상', '')}".strip()]
    desc = (r.get('설명') or '').strip()
    if desc:
        lines.append(desc)
    if r.get('AS-IS 근거') and 'O1' in (r.get('정답') or ''):  # O2·O3 행의 근거 칸은 규칙 정의라 AS-IS 근거로 적지 않는다
        lines.append(f"- AS-IS 근거 : {r['AS-IS 근거']}")
    return '\n'.join(lines)


def kind_text(r):
    how = r.get('판정 방법') or ''
    return f"{'동적' if 'E2E' in how else '정적'}-{r.get('영역') or r.get('규칙') or ''}"


def request_text(r):
    o = re.split(r'[+;,\s]+', (r.get('정답') or '').strip())[0]  # 'O1+O2' · 'O1;O3'(결함일반화) → 첫 값
    if not o:  # 권한 시험(eg-auth) 행은 정답 칸이 비고 오라클 칸만 있음
        o = {'ASIS': 'O1', 'RULE': 'O2'}.get((r.get('오라클') or '').strip().upper(), '')
    if o == 'O1':
        return 'asis 와 동일하게 수정'
    if o == 'O2':
        cr = CR_RX.search((r.get('AS-IS 근거') or '') + ' ' + (r.get('기대 원천') or ''))
        return f"TO-BE 확정 규칙({cr.group(0)})으로 수정" if cr else f"TO-BE 규칙({r.get('규칙') or ''})으로 수정"
    if o == 'O3':
        return '오류 수정'
    return ''


def last_row(ws):
    for r in range(ws.max_row, HEAD_ROW, -1):
        if any(ws.cell(r, c).value not in (None, '') for c in range(1, NCOL + 1)):
            return r
    return HEAD_ROW


def append_rows(path, mid, name, rows):
    wb = load_workbook(path)
    if SHEET not in wb.sheetnames:
        raise RuntimeError(f"'{SHEET}' 시트 없음 — {os.path.basename(path)}")
    ws = wb[SHEET]
    style_src = HEAD_ROW + 1   # 데이터 첫 행 서식(양식·사람 파일 공통)
    styles = [copy.copy(ws.cell(style_src, c)._style) for c in range(1, NCOL + 1)]
    end = last_row(ws)
    nos = [ws.cell(r, 2).value for r in range(HEAD_ROW + 1, end + 1)]
    no = max([int(v) for v in nos if isinstance(v, (int, float)) or (isinstance(v, str) and v.isdigit())] or [0])
    div = mid[:3]
    for i, r in enumerate(rows, 1):
        rr = end + i
        no += 1
        g = test_text(r)
        vals = {2: no, 3: div, 4: mid, 5: name, 6: '공통', 7: g, 8: kind_text(r), 10: request_text(r)}
        for c in range(1, NCOL + 1):
            cell = ws.cell(rr, c)
            cell._style = copy.copy(styles[c - 1])
            cell.value = vals.get(c)
        ws.cell(rr, 7).alignment = Alignment(wrap_text=True, vertical='center')
        ws.row_dimensions[rr].height = min(409, 15 * (g.count('\n') + 1 + len(g) // 90))
    wb.save(path)


def build(mid, checklist=None):
    """반환 (rc, 안내 문장). rc 0 = 기록 또는 기록할 것 없음, 1 = 실패"""
    mid = mid.upper()
    if not mid.startswith(TARGET_PREFIX):
        return 0, f'UI 테스트 Sheet: 대상 아님({mid} · SCP·SSP 화면만 Doc/UI_TEST(SCP&SSP) 에 생성)'
    checklist = checklist or latest_checklist(mid)
    if not checklist or not os.path.exists(checklist):
        return 1, f'UI 테스트 Sheet: ERROR CheckList 파일 없음({mid})'
    if not os.path.exists(TEMPLATE):
        return 1, f'UI 테스트 Sheet: ERROR 양식 없음 — {os.path.relpath(TEMPLATE, ROOT)}'
    rows = read_action_rows(checklist)
    name = menu_name(mid)
    base = os.path.join(OUTDIR, safe_name(f'{PREFIX}{mid}({name})') + '.xlsx')
    found = [f for f in glob.glob(os.path.join(OUTDIR, glob.escape(f'{PREFIX}{mid}(') + '*.xlsx'))
             if not os.path.basename(f).startswith('~$') and EXTRA not in os.path.basename(f)]
    main = found[0] if found else None
    note = f' · 같은 화면 파일 {len(found)}개 중 {os.path.basename(main)} 사용' if len(found) > 1 else ''
    extra = (os.path.splitext(main)[0] if main else os.path.splitext(base)[0]) + EXTRA + '.xlsx'
    done = recorded_ids(mid, [main, extra])
    new = [r for r in rows if r.get('검증 ID') and r['검증 ID'] not in done]
    src = os.path.basename(checklist)
    if not rows:
        return 0, f'UI 테스트 Sheet: 조치 필요 0행 — 기록할 행 없음({src})'
    if not new:
        tgt = extra if os.path.exists(extra) else (main or base)
        return 0, f'UI 테스트 Sheet: 추가 0행(조치 필요 {len(rows)}행 이미 기록) — {os.path.relpath(tgt, ROOT)}{note}'
    os.makedirs(OUTDIR, exist_ok=True)
    try:
        if main is None:
            target = base
            shutil.copyfile(TEMPLATE, target)
            how = '새 파일'
        elif not has_images(main):
            target = main
            bdir = P('Doc', 'verify', mid, 'ui_test_backup')
            os.makedirs(bdir, exist_ok=True)
            shutil.copyfile(main, os.path.join(bdir, f"{os.path.splitext(os.path.basename(main))[0]}_{datetime.datetime.now():%Y%m%d_%H%M%S}.xlsx"))
            how = '기존 파일에 덧붙임(원본 백업 Doc/verify/%s/ui_test_backup)' % mid
        else:
            target = extra
            if os.path.exists(target) and has_images(target):
                return 1, f'UI 테스트 Sheet: ERROR 원본·추가항목 파일 둘 다 이미지 포함 — 덧붙이면 이미지가 지워짐, 기록 안 함({os.path.basename(target)})'
            if not os.path.exists(target):
                shutil.copyfile(TEMPLATE, target)
            how = f'원본에 캡처 이미지가 있어 별도 파일에 기록({os.path.basename(main)} 은 그대로)'
        append_rows(target, mid, name, new)
        st = load_state(mid)
        st = {k: v for k, v in st.items() if os.path.exists(os.path.join(OUTDIR, k))}  # 지운 파일 몫은 정리
        st[os.path.basename(target)] = sorted(set(st.get(os.path.basename(target), [])) | {r['검증 ID'] for r in new})
        save_state(mid, st)
    except PermissionError:
        return 1, f'UI 테스트 Sheet: ERROR 저장 불가(Excel 로 열려 있음) — {os.path.basename(target)} 닫은 뒤 python tools/Harness/verify/make_ui_test_sheet.py {mid}'
    try:  # 문장 규칙 검사 — 보고만(make_verify_docs 와 같은 방식)
        sys.path.insert(0, P('tools', 'Docs'))
        import doc_style
        doc_style.after_save(target)
    except Exception as e:
        print('[문장 규칙] ERROR 검사 못함:', e)
    left = len(rows) - len(new)
    return 0, (f'UI 테스트 Sheet: {os.path.relpath(target, ROOT)} · {how} · 추가 {len(new)}행'
               + (f' · 이미 있는 행 {left}' if left else '') + f' · 기준 {src}{note}')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--checklist')
    a = ap.parse_args()
    rc, msg = build(a.menu_id, a.checklist)
    print(msg)
    return rc


if __name__ == '__main__':
    sys.exit(main())
