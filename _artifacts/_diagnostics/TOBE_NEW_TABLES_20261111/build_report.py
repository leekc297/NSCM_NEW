# -*- coding: utf-8 -*-
"""공통·DM UI 사용 TABLE 기준 — AS-IS 대비 TO-BE 신규 TABLE + 생성 시기 분류 (2026-11-11)
입력: ui_used/TOBE_UI사용_TABLE_VIEW_SYSTEM_ADMIN_DM_AUTH_20261111.xlsx (3_TABLE_VIEW목록 — 오늘 재실행)
      tobe_tables_all.csv (tobe_new_tables.py — TO-BE 전체 TABLE × AS-IS 존재 × 05-07 덤프 × 사내 생성일)
출력: TOBE_신규TABLE_공통_DM_UI기준_20261111.xlsx
"""
import csv, re, pathlib, collections
import openpyxl
from openpyxl.styles import Font, PatternFill, Alignment
from openpyxl.utils import get_column_letter

D = pathlib.Path(__file__).resolve().parent
allt = {(r['OWNER'], r['TABLE_NAME']): r for r in csv.DictReader((D / 'tobe_tables_all.csv').open(encoding='utf-8-sig'))}
wb0 = openpyxl.load_workbook(D / 'ui_used' / 'TOBE_UI사용_TABLE_VIEW_SYSTEM_ADMIN_DM_AUTH_20261111.xlsx', read_only=True)
ws0 = wb0['3_TABLE_VIEW목록']
it = ws0.iter_rows(values_only=True)
basis = next(it)[0]
hdr = [str(x) for x in next(it)]
used = [dict(zip(hdr, r)) for r in it if r and r[1]]
BAK = re.compile(r'(^ZB_|^ZT_|^ZZ|BAK|BACKUP|_BK\d*$|_BKUP|_OLD$|_TMP$|_TEMP$|_\d{6,8}(_\d+)?$|\$|^TMP_|^TEMP_|_COPY$)', re.I)
rows, views, missing = [], [], []
for u in used:
    o, n, typ = u['OWNER'], u['TABLE/VIEW'], u['유형']
    grp_common = ' '.join(g for g in ('SYSTEM', 'ADMIN', 'AUTHORITY', 'COMMON') if u.get(g) == 'Y')
    base = dict(OWNER=o, TABLE=n, 공통=grp_common, DM='Y' if u.get('DM') == 'Y' else '', 접근=u.get('접근') or '', 사용화면수=u.get('사용화면수') or '', 사용화면=u.get('사용 화면') or '')
    if not typ.startswith(('TABLE', 'GTT')):
        views.append(dict(base, 유형=typ, 비고=u.get('비고(VIEW 경유)') or ''))
        continue
    a = allt.get((o, n))
    if a is None:
        missing.append((o, n, typ))
        continue
    kind = 'GTT' if typ == 'GTT' else ('백업·임시' if BAK.search(n) else '일반')
    if o != 'SCM_MGR':
        when = '판정 불가(05-07 덤프는 SCM_MGR 만)'
    elif a['IN_MAY_DUMP'] == 'Y':
        when = '① 이관시점(05-07 덤프)에 있음'
    elif a['TOBE_CREATED'][:10] in ('2026-10-09', '2026-10-13'):
        when = '② 5월 이후 — 05-07 덤프에 없음 · 사내 일괄 적재일(10-09·10-13) 생성'
    else:
        when = '③ 5월 이후 — 05-07 덤프에 없음 · 사내 10-14 이후 생성'
    rows.append(dict(base, 구분=kind, AS_IS존재='Y' if a['IN_ASIS'] == 'Y' else 'N', AS_IS_DB=a['ASIS_DB'], AS_IS_다른DB=a['ASIS_OTHER_DB'],
                     생성시기=when, 덤프0507='Y' if a['IN_MAY_DUMP'] == 'Y' else 'N', 사내_CREATED=a['TOBE_CREATED'], 사내_LAST_DDL=a['TOBE_LAST_DDL'], AS_IS_CREATED=a['ASIS_CREATED']))
COLS = ['OWNER', 'TABLE', '구분', 'AS_IS존재', '생성시기', '덤프0507', '사내_CREATED', '사내_LAST_DDL', '공통', 'DM', '접근', '사용화면수', '사용화면', 'AS_IS_DB', 'AS_IS_다른DB', 'AS_IS_CREATED']
wb = openpyxl.Workbook()
HF = PatternFill('solid', fgColor='1F4E78'); HFONT = Font(bold=True, color='FFFFFF')
def sheet(name, data, cols):
    ws = wb.create_sheet(name)
    ws.append(cols)
    for c in ws[1]: c.fill = HF; c.font = HFONT; c.alignment = Alignment(horizontal='center')
    for r in data: ws.append([r.get(c, '') for c in cols])
    for i, c in enumerate(cols, 1):
        ws.column_dimensions[get_column_letter(i)].width = min(60, max(10, len(c) + 2, *(len(str(r.get(c, ''))) + 2 for r in data[:300]))) if data else 14
    ws.freeze_panes = 'C2'; ws.auto_filter.ref = ws.dimensions
    return ws
key = lambda r: (r['구분'], r['생성시기'], r['OWNER'], r['TABLE'])
new = sorted([r for r in rows if r['AS_IS존재'] == 'N'], key=key)
old = sorted([r for r in rows if r['AS_IS존재'] == 'Y'], key=key)
# 요약
ws = wb.active; ws.title = '0_요약'
L = [['공통·DM UI 사용 TABLE 기준 — AS-IS 대비 TO-BE 신규 TABLE (2026-11-11)'], [basis], [],
     ['범위', '공통 = Admin>System 13 · Admin>Admin_Menu 4 · Authority 2 화면 + 공용 프레임워크·공통 팝업 / DM = Demand 26 화면 + DMF0022·DMF0045 (SCP·SSP 등 제외)'],
     ['사용 TABLE 산출', '화면 FE 실호출 → 메타 배선(API·PKG) → PL/SQL 호출 폐포 → 정적·동적 SQL 의 TABLE/VIEW (ui_used 파이프라인 01~07 오늘 재실행)'],
     ['AS-IS 존재', '대응 AS-IS DB(LGCE_SCMDEV 등) sys.tables 에 같은 이름(대소문자 무시)이 있으면 Y'],
     ['이관시점 기준', 'C:/TRANFILE/OLD/To-be/Tobe_OPTENG_SCP_Table*_DDL.sql (파일 일자 2026-05-07 · SCM_MGR 1,729 TABLE)에 있으면 ①'],
     ['한계', '사내 DB 생성일은 2026-10-09 부터만 존재 → 5월~10월 초 사이 실제 생성일은 알 수 없음. ②③ = 05-07 덤프에 없다는 사실 + 사내 생성일'],
     [], ['[A] 사용 TABLE 전체 (VIEW 제외)'], ['구분', 'AS-IS 존재', '건수']]
for (k, a), v in sorted(collections.Counter((r['구분'], r['AS_IS존재']) for r in rows).items()): L.append([k, a, v])
L += [[], ['[B] 신규 TABLE (AS-IS 에 없음) — 구분 × 생성 시기'], ['구분', '생성 시기', '건수']]
for (k, w), v in sorted(collections.Counter((r['구분'], r['생성시기']) for r in new).items()): L.append([k, w, v])
L += [[], ['[C] AS-IS 에도 있는 TABLE — 구분 × 생성 시기(참고)'], ['구분', '생성 시기', '건수']]
for (k, w), v in sorted(collections.Counter((r['구분'], r['생성시기']) for r in old).items()): L.append([k, w, v])
L += [[], ['VIEW(별도 시트)', len(views)], ['사용 목록에 있으나 TO-BE 전체 목록(16:16 조회)에 없는 TABLE', len(missing)] + [f'{o}.{n}' for o, n, t in missing[:10]]]
for r in L: ws.append(r)
ws['A1'].font = Font(bold=True, size=13); ws.column_dimensions['A'].width = 34; ws.column_dimensions['B'].width = 90
for k in ('일반', 'GTT', '백업·임시'):
    sheet(f'1_신규_{k}', [r for r in new if r['구분'] == k], COLS)
sheet('2_AS-IS에도있음', old, COLS)
sheet('3_사용TABLE전체', sorted(rows, key=lambda r: (r['OWNER'], r['TABLE'])), COLS)
sheet('4_VIEW', views, ['OWNER', 'TABLE', '유형', '공통', 'DM', '접근', '사용화면수', '사용화면', '비고'])
out = D / 'TOBE_신규TABLE_공통_DM_UI기준_20261111.xlsx'
wb.save(out)
print(basis)
print('사용 TABLE', len(rows), 'VIEW', len(views), 'missing', missing)
for r in L[9:]: print('  ', r)
print(out)
