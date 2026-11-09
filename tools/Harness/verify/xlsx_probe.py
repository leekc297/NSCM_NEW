# -*- coding: utf-8 -*-
"""Excel 시험 도우미(2026-11-01 EG420·EG421)
  python -I xlsx_probe.py read <파일>        → 시트별 행·칸·머리글 JSON
  python -I xlsx_probe.py badheader <파일>   → 머리글이 틀린 xlsx 생성(업로드 차단 시험용)
  python -I xlsx_probe.py blankreq <양식> <출력>  → 양식 머리글 그대로 · '*' 필수 칸만 비운 1행 추가(EG153) · 출력 JSON {req, others}
  python -I xlsx_probe.py formhead <파일>   → 병합 수·앞 2행·날짜형 칸 제목(EG283·EG344)
  python -I xlsx_probe.py content <파일>     → 첫 시트 머리글·앞 200행 값·틀 고정·숫자 서식(EG013·EG345·EG343·EG346·EG350)
"""
import json, re, sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')  # Windows 기본 인코딩(cp949)으로 쓰면 특수 문자에서 죽는다
import openpyxl


def read(p):
    wb = openpyxl.load_workbook(p, read_only=True, data_only=True); out = []
    for ws in wb.worksheets:
        rows = 0; hdr = []
        for i, row in enumerate(ws.iter_rows(values_only=True)):
            if any(v not in (None, '') for v in row):
                rows += 1
                if not hdr: hdr = [str(v) for v in row if v not in (None, '')]
            if i > 200000: break
        out.append({'name': ws.title, 'rows': rows, 'cols': len(hdr), 'header': hdr[:40]})
    print(json.dumps(out, ensure_ascii=False))


def content(p):
    # read_only 는 freeze_panes·서식 일부를 못 읽는다 — 일반 모드
    wb = openpyxl.load_workbook(p, data_only=True); ws = wb.worksheets[0]
    head_row = next((i for i, r in enumerate(ws.iter_rows(values_only=True, max_row=10), 1) if any(v not in (None, '') for v in r)), 1)
    # 2026-11-06(SCP0016 H7 허위 FAIL): 다단 헤더(월→주차→일) 파일은 맨 위 행만 읽으면 화면 맨 아래 헤더('24'…)와 어긋난다 — 헤더 행 수 = 틀 고정 행(freeze) 또는 헤더 영역 병합 범위,
    #   열마다 헤더 행들 중 맨 아래 비어 있지 않은 값을 머리글로 쓴다(화면 쪽 column.header 와 같은 단)
    hrows = 1
    try:
        fz = ws.freeze_panes
        if fz:
            mm = re.search(r'(\d+)$', str(fz)); fr = int(mm.group(1)) - 1 if mm else 0
            if head_row <= fr <= head_row + 5: hrows = fr - head_row + 1
        if hrows == 1:
            mx = max([rg.max_row for rg in ws.merged_cells.ranges if rg.min_row >= head_row and rg.min_row <= head_row + 5] or [head_row])
            if mx > head_row: hrows = min(mx - head_row + 1, 6)
    except Exception:
        hrows = 1
    hdr = []
    for ci in range(1, ws.max_column + 1):
        v = ''
        for ri in range(head_row + hrows - 1, head_row - 1, -1):
            cv = ws.cell(row=ri, column=ci).value
            if cv is not None and str(cv) != '': v = str(cv); break
        hdr.append(v)
    rows = []; num = gen = 0; fmts = []
    for r in ws.iter_rows(min_row=head_row + hrows, max_row=head_row + hrows + 199):
        rows.append([('' if c.value is None else str(c.value)) for c in r])
        for c in r:
            if isinstance(c.value, (int, float)) and not isinstance(c.value, bool):
                num += 1
                if c.number_format == 'General':
                    gen += 1
                elif c.number_format not in fmts:
                    fmts.append(c.number_format)
    print(json.dumps({'sheet': ws.title, 'header': hdr, 'headerRows': hrows, 'rows': rows, 'freeze': ws.freeze_panes, 'numCells': num, 'general': gen, 'samples': fmts[:5]}, ensure_ascii=False))


def badheader(p):
    wb = openpyxl.Workbook(); ws = wb.active; ws.append(['E2E_WRONG_A', 'E2E_WRONG_B']); ws.append(['1', '2']); wb.save(p); print(p)


def formhead(p):
    wb = openpyxl.load_workbook(p); ws = wb.worksheets[0]
    rows = [[('' if v is None else str(v)) for v in r] for r in ws.iter_rows(min_row=1, max_row=2, values_only=True)]
    buckets = []
    for r in rows:
        for v in r:
            d = ''.join(ch for ch in v if ch.isdigit())
            if len(d) in (6, 8) and d[:2] == '20' and len(d) == len(v.strip().replace('-', '').replace('.', '')):
                buckets.append(d)
    print(json.dumps({'merged': len(ws.merged_cells.ranges), 'rows': ws.max_row, 'buckets': buckets, 'row1': rows[0][:6] if rows else [], 'row2': rows[1][:6] if len(rows) > 1 else []}, ensure_ascii=False))


def blankreq(src, out):
    wb = openpyxl.load_workbook(src); ws = wb.worksheets[0]
    head_row = next((i for i, r in enumerate(ws.iter_rows(values_only=True, max_row=10), 1) if any(v not in (None, '') for v in r)), 1)
    # 2단 머리글이면 마지막 머리글 행 다음에 쓴다
    last = head_row
    for i in range(head_row + 1, ws.max_row + 1):
        if any(c.value not in (None, '') for c in ws[i]):
            last = i
    req, others = [], []
    for c in ws[head_row]:
        t = '' if c.value is None else str(c.value)
        if not t:
            continue
        if t.rstrip().endswith('*') or t.lstrip().startswith('*'):
            req.append(t)
        else:
            others.append(t)
            ws.cell(row=last + 1, column=c.column, value='E2E')
    wb.save(out); print(json.dumps({'req': req, 'others': others}, ensure_ascii=False))


if __name__ == '__main__':
    if sys.argv[1] == 'blankreq':
        blankreq(sys.argv[2], sys.argv[3]); sys.exit(0)
    {'read': read, 'badheader': badheader, 'content': content, 'formhead': formhead}[sys.argv[1]](sys.argv[2])
