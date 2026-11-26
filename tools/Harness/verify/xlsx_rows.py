# -*- coding: utf-8 -*-
"""양식 xlsx 에 데이터 행을 써서 업로드 시험 파일을 만든다(2026-11-25 T584 SCP0005 M1 V-219edc76).

  python -I tools/Harness/verify/xlsx_rows.py heads <양식.xlsx>                 → 마지막 머리글 행 문구 JSON 배열
  python -I tools/Harness/verify/xlsx_rows.py write <양식.xlsx> <출력.xlsx> <행.json>  → 행(JSON 2차 배열 · 양식 칸 순서)을 머리글 다음 행부터 씀
  빈 문자열 = 빈 칸. 양식 머리글·서식은 그대로 둔다.
"""
import json
import sys

import openpyxl


def head_row(ws):
    first = next((i for i, r in enumerate(ws.iter_rows(values_only=True, max_row=10), 1) if any(v not in (None, '') for v in r)), 1)
    last = first
    for i in range(first + 1, ws.max_row + 1):
        if any(c.value not in (None, '') for c in ws[i]):
            last = i
    return last


def heads(src):
    ws = openpyxl.load_workbook(src).worksheets[0]
    print(json.dumps(['' if c.value is None else str(c.value) for c in ws[head_row(ws)]], ensure_ascii=False))


def write(src, out, rows_fp):
    wb = openpyxl.load_workbook(src)
    ws = wb.worksheets[0]
    h = head_row(ws)
    with open(rows_fp, encoding='utf-8') as f:
        rows = json.load(f)
    for k, r in enumerate(rows, 1):
        for j, v in enumerate(r, 1):
            ws.cell(row=h + k, column=j, value=(None if v in (None, '') else str(v)))
    wb.save(out)
    print(json.dumps({'rows': len(rows), 'headRow': h}, ensure_ascii=False))


if __name__ == '__main__':
    if sys.argv[1] == 'heads':
        heads(sys.argv[2])
    elif sys.argv[1] == 'write':
        write(sys.argv[2], sys.argv[3], sys.argv[4])
