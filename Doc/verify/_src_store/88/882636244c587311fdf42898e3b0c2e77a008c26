# -*- coding: utf-8 -*-
"""AS-IS 실측(Doc/asislive/<ID>/latest.json) → 문서(xlsx) 시트 (2026-11-12 · 승인 플랜 velvet-conjuring-lake P3)

문서 생성기(make_test_report.py · tools/Docs/make_docs.py)가 공통으로 쓴다.
  load(mid)                → 실측 묶음(dict) 또는 None(실측 없음·상태 OK 아님)
  add_sheet(wb, mid, name) → 시트 1장 추가: 실측 개요 · 화면 캡처 · 실행 시 호출 SP(인자·건수) · 조회조건 · 그리드 구성
                             반환 = {'shots': n, 'calls': n, 'conditions': n, 'sheets': n} 또는 None(시트를 만들지 않음)
실측이 없으면 아무것도 추가하지 않는다(문서 내용을 지어내지 않는다). 번호 붙은 표준 시트(설계서 8 · 분석서 10)는 건드리지 않고 '부록' 시트로만 붙인다.
"""
import json, os, re

from openpyxl.drawing.image import Image as XLImage
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
FRAMEWORK_SP = re.compile(r'^(UP_FX_|SCM_SYS_GET_SPREAD_TITLE$|SCP0009_GET_SHEET_CALENDAR)', re.I)
_HF = PatternFill('solid', fgColor='D9E1F2'); _SF = PatternFill('solid', fgColor='F2F2F2')
_B = Border(*(Side(style='thin', color='BFBFBF'),) * 4)
_WRAP = Alignment(vertical='top', wrap_text=True)
_ILLEGAL = re.compile(r'[\x00-\x08\x0b\x0c\x0e-\x1f]')


def _j(p):
    try:
        with open(p, encoding='utf-8') as f: return json.load(f)
    except (OSError, ValueError):
        return None


def load(mid):
    mid = mid.upper()
    latest = _j(os.path.join(ROOT, 'Doc', 'asislive', mid, 'latest.json'))
    if not latest:
        return None
    rdir = os.path.join(ROOT, *latest['run_dir'].split('/'))
    run = _j(os.path.join(rdir, 'run.json')) or {}
    if run.get('status') != 'OK':
        return None
    calls = [c for c in (_j(os.path.join(rdir, 'calls.json')) or {}).get('calls') or [] if c.get('phase') in ('load', 'find')]
    ctl = _j(os.path.join(rdir, 'controls.json')) or {}; grid = _j(os.path.join(rdir, 'grids.json')) or {}
    cap = {'_01_load': '화면을 연 직후(조회 전)', '_02_find': '조회(Find) 후'}
    shots = []
    sd = os.path.join(rdir, 'shots')
    for f in sorted(os.listdir(sd)) if os.path.isdir(sd) else []:
        if f.lower().endswith('.png') and os.path.getsize(os.path.join(sd, f)) > 2000:
            shots.append({'path': os.path.join(sd, f), 'file': f, 'caption': next((v for k, v in cap.items() if k in f), f)})
    return {'id': mid, 'run_dir': latest['run_dir'], 'run': run, 'calls': calls, 'controls': ctl.get('controls') or [], 'layout_items': ctl.get('layout_items') or [],
            'grids': grid.get('grids') or [], 'shots': shots}


def _cell(ws, r, c, v, bold=False, fill=None):
    x = ws.cell(r, c)
    x.value = _ILLEGAL.sub(' ', v) if isinstance(v, str) else v
    x.alignment, x.border = _WRAP, _B
    if bold: x.font = Font(bold=True)
    if fill: x.fill = fill
    return x


def _hdr(ws, r, cols):
    for i, h in enumerate(cols, 1):
        _cell(ws, r, i, h, bold=True, fill=_HF)
    return r + 1


def _sec(ws, r, text):
    c = ws.cell(r, 1); c.value = text; c.font = Font(bold=True, size=12); c.fill = _SF
    for i in range(2, 7): ws.cell(r, i).fill = _SF
    return r + 1


def add_sheet(wb, mid, name='AS-IS 실측'):
    L = load(mid)
    if not L:
        return None
    ws = wb.create_sheet(name); run = L['run']
    for i, w in enumerate([8, 26, 44, 12, 12, 90], 1):
        ws.column_dimensions[get_column_letter(i)].width = w
    r = 1
    t = ws.cell(r, 1); t.value = f"{L['id']} AS-IS 실측 — 현행 프로그램 실행 결과"; t.font = Font(bold=True, size=14); r += 1
    ws.cell(r, 1).value = ('AS-IS 런처를 이 PC 에서 구동해 화면을 열고 조회한 기록임. 조회 조건은 AS-IS 화면이 처음 열릴 때의 기본값임(TO-BE 시험 조건과 같다는 보장 없음).'); r += 2

    r = _sec(ws, r, '1. 실측 개요'); r = _hdr(ws, r, ['', '항목', '값'])
    scr, fnd = run.get('screen') or {}, run.get('find') or {}
    for k, v in [('실행 시각', f"{run.get('started')} ~ {run.get('ended')}"), ('계정', run.get('user_id')), ('화면', f"{scr.get('form_text')} ({scr.get('form_type')})"),
                 ('조회 결과', f"{fnd.get('total')} · {fnd.get('time_status')}"), ('접속 서버', run.get('client_base_url')),
                 ('대화상자', f"{len(run.get('dialogs') or [])}건"), ('다른 런처 동시 실행', ', '.join(run.get('other_launchers') or []) or '없음'), ('원본 폴더', L['run_dir'])]:
        _cell(ws, r, 1, ''); _cell(ws, r, 2, k, bold=True); _cell(ws, r, 3, v); ws.merge_cells(start_row=r, start_column=3, end_row=r, end_column=6); r += 1
    for d in run.get('dialogs') or []:
        _cell(ws, r, 2, '대화상자 내용'); _cell(ws, r, 3, f"{d.get('at')} [{d.get('caption')}] {(d.get('text') or '').replace(chr(10), ' / ')} → {d.get('action')}"); ws.merge_cells(start_row=r, start_column=3, end_row=r, end_column=6); r += 1
    r += 1

    r = _sec(ws, r, '2. 화면 캡처')
    for s in L['shots']:
        _cell(ws, r, 1, ''); _cell(ws, r, 2, s['caption'], bold=True); _cell(ws, r, 3, s['file']); r += 1
        try:
            img = XLImage(s['path']); w, h = img.width, img.height
            if w > 1100: h = int(h * 1100 / w); w = 1100
            img.width, img.height = w, h; img.anchor = f'B{r}'; ws.add_image(img)
            ws.row_dimensions[r].height = max(20, h * 0.75 + 6)
        except Exception as ex:
            ws.cell(r, 2).value = f'(캡처 삽입 실패: {ex})'
        r += 2
    if not L['shots']:
        ws.cell(r, 2).value = '(캡처 없음 — 미측정)'; r += 2

    r = _sec(ws, r, '3. 실행 시 호출 SP (화면 고유 → 공통 순 · 호출 순서 유지)')
    r = _hdr(ws, r, ['순번', 'SP', '서비스', '구간', '건수', '인자'])
    own = [c for c in L['calls'] if not FRAMEWORK_SP.match(c.get('sp') or '')]; fw = [c for c in L['calls'] if FRAMEWORK_SP.match(c.get('sp') or '')]
    seq = {id(c): i for i, c in enumerate(L['calls'], 1)}
    for c in own:
        ps = ', '.join(f"{k}={'NULL' if v is None else v}" for k, v in (c.get('params') or {}).items())
        for i, v in enumerate([seq[id(c)], c.get('sp'), c.get('service'), {'load': '화면 열기', 'find': '조회'}.get(c.get('phase'), c.get('phase')), c.get('rows'), ps[:1500]], 1):
            _cell(ws, r, i, v)
        r += 1
    agg = {}
    for c in fw:
        a = agg.setdefault((c.get('sp'), c.get('phase')), [0, c.get('service')]); a[0] += 1
    for (sp, ph), (n, svc) in sorted(agg.items()):
        for i, v in enumerate(['공통', sp, svc, {'load': '화면 열기', 'find': '조회'}.get(ph, ph), f'{n}회', '공통 프레임워크 호출(그리드 제목·달력·공통 코드·실행 기록) — 건별 인자는 원본 calls.json'], 1):
            _cell(ws, r, i, v)
        r += 1
    r += 1

    r = _sec(ws, r, '4. 조회조건 (화면에 나온 라벨 · * = 필수)')
    r = _hdr(ws, r, ['', '라벨', '컨트롤', '필수', '보임', '열렸을 때 값'])
    byname = {c.get('name'): c for c in L['controls']}; nc = 0
    for it in L['layout_items']:
        if not it.get('control'): continue
        c = byname.get(it['control'], {}); nc += 1
        val = c.get('selected_text') if 'selected_text' in c else (c.get('edit_value') or c.get('control_values') or c.get('text') or '')
        if 'checked' in c: val = '체크' if c.get('checked') else '체크 안 함'
        if c.get('items') and isinstance(c['items'], list) and c['items'] and isinstance(c['items'][0], dict):
            val = ', '.join(x['text'] for x in c['items'] if x.get('checked'))[:300]
        for i, v in enumerate(['', it.get('label'), f"{it['control']} ({(c.get('type') or '').split('.')[-1]})", 'Y' if it.get('required') else '', '' if str(c.get('visible')) != 'False' else '숨김', str(val or '')[:400]], 1):
            _cell(ws, r, i, v)
        r += 1
    r += 1

    r = _sec(ws, r, '5. 그리드 구성 (실행 결과 기준)')
    r = _hdr(ws, r, ['', '그리드 / 시트', '보이는 컬럼(왼쪽부터)', '컬럼 수', '행 수', '헤더 단수 · 고정 컬럼 · 숨김 컬럼 수'])
    ns = 0
    for g in L['grids']:
        for s in g.get('sheets') or []:
            ns += 1; cols = s.get('columns') or []; vis = [c for c in cols if str(c.get('visible')) != 'False']
            def lab(c):
                hs = [h for h in (c.get('header') or []) if h]; out = []
                for h in hs:
                    if not out or out[-1] != h: out.append(h)
                return ' / '.join(out) or (c.get('label') or '')
            names = [lab(c).replace('\n', ' ') for c in vis]
            for i, v in enumerate(['', f"{g.get('name')} / {s.get('name')}", ' | '.join(names)[:3000], f'{len(cols)}(보임 {len(vis)})', s.get('rows'),
                                    f"헤더 {s.get('header_rows')}단 · 고정 {s.get('frozen_cols')} · 숨김 {len(cols) - len(vis)}"], 1):
                _cell(ws, r, i, v)
            r += 1
    ws.sheet_view.showGridLines = False
    return {'shots': len(L['shots']), 'calls': len(L['calls']), 'own_calls': len(own), 'conditions': nc, 'sheets': ns}
