# -*- coding: utf-8 -*-
"""클라우드 40_SPEED_COMPARE 결과(사용자 공유 2026-11-02) → 비교 Excel. 값은 공유 결과 그대로."""
import os, statistics as st
from openpyxl import Workbook
from openpyxl.chart import BarChart, Reference
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'DMF0082_클라우드_속도비교_20261102.xlsx')

# C1: 사업부, 전합계, 후합계, 차이, %, 전실행, 후실행, 전fetch, 후fetch, 전범위, 후범위, 전행, 후행, NOTE
C1 = [('40', 16.11, 19.14, 3.03, 18.8, 9.64, 11.38, 6.47, 7.97, '15.95~16.32', '19.05~28.6', 7421, 7421, 'OK'),
      ('81', 20.49, 33.42, 12.93, 63.1, 12.81, 18.61, 7.84, 14.02, '20.01~20.84', '31.57~34.28', 8060, 8060, 'OK'),
      ('82', 46.79, 47.74, 0.95, 2.0, 26.76, 35.27, 20.03, 14.97, '41.28~67.43', '41.2~60.76', 16082, 16082, 'OK')]
# C2: 사업부, 구분, 회차, 실행, fetch, 합계, 행, 컬럼, 시각
C2 = [('40', '적용 전', 1, 9.51, 6.44, 15.95, 7421, 438, '11:20:19'), ('40', '적용 전', 2, 9.64, 6.47, 16.11, 7421, 438, '11:20:35'), ('40', '적용 전', 3, 9.69, 6.63, 16.32, 7421, 438, '11:20:51'),
      ('40', '적용 후', 1, 18.82, 9.78, 28.6, 7421, 438, '11:25:44'), ('40', '적용 후', 2, 11.38, 7.76, 19.14, 7421, 438, '11:26:04'), ('40', '적용 후', 3, 11.08, 7.97, 19.05, 7421, 438, '11:26:23'),
      ('81', '적용 전', 1, 12.81, 7.68, 20.49, 8060, 439, '11:21:12'), ('81', '적용 전', 2, 12.17, 7.84, 20.01, 8060, 439, '11:21:32'), ('81', '적용 전', 3, 12.87, 7.97, 20.84, 8060, 439, '11:21:52'),
      ('81', '적용 후', 1, 18.27, 15.15, 33.42, 8060, 439, '11:26:56'), ('81', '적용 후', 2, 20.26, 14.02, 34.28, 8060, 439, '11:27:30'), ('81', '적용 후', 3, 18.61, 12.96, 31.57, 8060, 439, '11:28:02'),
      ('82', '적용 전', 1, 24.76, 16.52, 41.28, 16082, 439, '11:22:34'), ('82', '적용 전', 2, 26.76, 20.03, 46.79, 16082, 439, '11:23:21'), ('82', '적용 전', 3, 40.31, 27.12, 67.43, 16082, 439, '11:24:28'),
      ('82', '적용 후', 1, 26.23, 14.97, 41.2, 16082, 439, '11:28:43'), ('82', '적용 후', 2, 42.06, 18.7, 60.76, 16082, 439, '11:29:44'), ('82', '적용 후', 3, 35.27, 12.47, 47.74, 16082, 439, '11:30:32')]

# 대조: C1 = C2 중앙값
for r in C1:
    d = r[0]
    b = [x for x in C2 if x[0] == d and x[1] == '적용 전']
    a = [x for x in C2 if x[0] == d and x[1] == '적용 후']
    exp = (st.median(x[5] for x in b), st.median(x[5] for x in a), st.median(x[3] for x in b), st.median(x[3] for x in a), st.median(x[4] for x in b), st.median(x[4] for x in a))
    got = (r[1], r[2], r[5], r[6], r[7], r[8])
    assert exp == got, (d, exp, got)
    assert abs(r[2] - r[1] - r[3]) < 0.005 and abs(round((r[2] - r[1]) / r[1] * 100, 1) - r[4]) < 0.05, d

FONT = 'Malgun Gothic'
HEAD = PatternFill('solid', fgColor='1F3864')
SUB = PatternFill('solid', fgColor='F2F2F2')
SLOW = PatternFill('solid', fgColor='FCE4E4')
thin = Side(style='thin', color='BFBFBF')
BOX = Border(left=thin, right=thin, top=thin, bottom=thin)
CENTER = Alignment(horizontal='center', vertical='center', wrap_text=True)
LEFT = Alignment(horizontal='left', vertical='center', wrap_text=True)


def put(ws, r, c, v, fmt=None, bold=False, fill=None, align=CENTER, color=None, size=10, box=True):
    x = ws.cell(r, c, v)
    x.font = Font(name=FONT, size=size, bold=bold, color=color)
    x.alignment = align
    if fmt: x.number_format = fmt
    if fill: x.fill = fill
    if box: x.border = BOX
    return x


wb = Workbook()
ws = wb.active
ws.title = '요약'
ws.sheet_view.showGridLines = False
for col, w in zip('ABCDEFGHIJ', (11, 11, 11, 11, 10, 11, 11, 11, 11, 10)):
    ws.column_dimensions[col].width = w
ws.merge_cells('A1:J1')
put(ws, 1, 1, 'PKG_DMF0082 힌트 적용 전후 속도 비교 (클라우드)', bold=True, size=14, align=LEFT, box=False)
ws.row_dimensions[1].height = 26
ws.merge_cells('A2:J2')
put(ws, 2, 1, '2026-11-02 11:20~11:30 · P_DMF0082_GET_MAIN_DATA · 사용자 jssbae · 기간 20261101~20270430 · 사업부별 3회 중앙값(초) · 프로시저 실행 + 커서 fetch', align=LEFT, color='595959', size=9, box=False)
ws.row_dimensions[2].height = 28

ws.merge_cells('A4:A5'); ws.merge_cells('B4:E4'); ws.merge_cells('F4:G4'); ws.merge_cells('H4:I4'); ws.merge_cells('J4:J5')
for c, t in ((1, '사업부'), (2, '합계 (초)'), (6, '프로시저 실행 (초)'), (8, '커서 fetch (초)'), (10, '행 수 전·후')):
    put(ws, 4, c, t, bold=True, fill=HEAD, color='FFFFFF')
for c in (3, 4, 5, 7, 9):
    ws.cell(4, c).border = BOX; ws.cell(4, c).fill = HEAD
for c, t in ((2, '적용 전'), (3, '적용 후'), (4, '증감'), (5, '증감률'), (6, '적용 전'), (7, '적용 후'), (8, '적용 전'), (9, '적용 후')):
    put(ws, 5, c, t, bold=True, fill=SUB)
ws.cell(5, 1).border = BOX; ws.cell(5, 10).border = BOX
for i, r in enumerate(C1, 6):
    put(ws, i, 1, int(r[0]), '0', bold=True)
    put(ws, i, 2, r[1], '0.00'); put(ws, i, 3, r[2], '0.00')
    put(ws, i, 4, r[3], '+0.00;-0.00;0.00', bold=True, fill=SLOW, color='C00000')
    put(ws, i, 5, r[4] / 100, '+0.0%;-0.0%;0.0%', bold=True, fill=SLOW, color='C00000')
    put(ws, i, 6, r[5], '0.00'); put(ws, i, 7, r[6], '0.00'); put(ws, i, 8, r[7], '0.00'); put(ws, i, 9, r[8], '0.00')
    put(ws, i, 10, '동일' if r[11] == r[12] else '다름')
    ws.row_dimensions[i].height = 20

notes = ['세 사업부 모두 적용 후 합계가 늘었습니다. 40 +3.03초(+18.8%), 81 +12.93초(+63.1%), 82 +0.95초(+2.0%).',
         '행 수는 40 7,421 · 81 8,060 · 82 16,082 로 전후 같고, 비교 쿼리 판정(NOTE)은 모두 OK 입니다.',
         '회별 편차: 82 는 적용 전 41.28~67.43초, 적용 후 41.2~60.76초로 넓고, 40 은 적용 후 1회차가 28.6초로 튑니다. 회별 값은 [회별 측정] 시트 참고.',
         'DB 안 시간이며 BE 왕복·JSON 변환은 포함되지 않습니다. 측정 당시 클라우드의 다른 부하는 측정하지 않았습니다.']
for k, t in enumerate(notes, 10):
    ws.merge_cells(start_row=k, start_column=1, end_row=k, end_column=10)
    put(ws, k, 1, t, align=LEFT, size=9, box=False)
    ws.row_dimensions[k].height = 28

ch = BarChart(); ch.type = 'col'; ch.grouping = 'clustered'
ch.title = '사업부별 합계 시간 (초, 낮을수록 빠름)'; ch.title.overlay = False; ch.y_axis.number_format = '0'
ch.add_data(Reference(ws, min_col=2, max_col=3, min_row=5, max_row=8), titles_from_data=True)
ch.set_categories(Reference(ws, min_col=1, min_row=6, max_row=8))
ch.x_axis.delete = False; ch.y_axis.delete = False
ch.y_axis.majorGridlines = None
ch.series[0].graphicalProperties.solidFill = 'A6A6A6'; ch.series[1].graphicalProperties.solidFill = '1F3864'
from openpyxl.chart.label import DataLabelList
for s in ch.series:
    s.dLbls = DataLabelList(); s.dLbls.showVal = True
    s.dLbls.showSerName = False; s.dLbls.showCatName = False; s.dLbls.showLegendKey = False
ch.height = 7.5; ch.width = 19; ch.legend.position = 't'
ws.add_chart(ch, 'A15')
ws.page_setup.orientation = 'landscape'; ws.page_setup.fitToWidth = 1; ws.page_setup.fitToHeight = 1; ws.sheet_properties.pageSetUpPr.fitToPage = True

w2 = wb.create_sheet('회별 측정')
w2.sheet_view.showGridLines = False
heads = ['사업부', '구분', '회차', '프로시저 실행(초)', '커서 fetch(초)', '합계(초)', '행 수', '컬럼 수', '측정 시각']
for c, (t, wd) in enumerate(zip(heads, (11, 11, 9, 19, 17, 12, 11, 11, 13)), 1):
    put(w2, 1, c, t, bold=True, fill=HEAD, color='FFFFFF')
    w2.column_dimensions[chr(64 + c)].width = wd
w2.row_dimensions[1].height = 32
for i, r in enumerate(C2, 2):
    fill = SUB if r[1] == '적용 전' else None
    for c, v in enumerate(r, 1):
        fmt = '0.00' if c in (4, 5, 6) else ('#,##0' if c == 7 else None)
        put(w2, i, c, int(v) if c == 1 else v, fmt, fill=fill)
w2.freeze_panes = 'A2'
w2.auto_filter.ref = f'A1:I{len(C2) + 1}'
wb.save(OUT)
print('saved', OUT)
